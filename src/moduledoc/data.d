
/**
 * Tipos basicos para guardar los datos parseados de las cabeceras
 */
module moduledoc.data;

import std.conv : to;
import std.range;

import moduledoc.strutil;
import moduledoc.regexutil;

/// Categoria del módulo
enum Category {
  Null     = "",
  Unknown  = "unknow",
  Generic  = "generic",
  Audio    = "audio",
  Graphics = "graphics",
  Input    = "input",
  Physics  = "physics"
}

/// Sistema del módulo
enum System {
  Null    = "",
  Unknown = "unknow",
  Common  = "common",
  Legacy  = "legacy",
  Modern  = "modern"
}

/// Tipos primitivos de Gemix
enum BasicType {
  Unknow = "?",
  Byte   = "BYTE",
  Word   = "WORD",
  DWord  = "DWORD",
  Int    = "INT",
  Int8   = "INT8",
  Int16  = "INT16",
  Int32  = "INT32",
  Int64  = "INT64",
  UInt   = "UINT",
  UInt8  = "UINT8",
  UInt16 = "UINT16",
  UInt32 = "UINT32",
  UInt64 = "UINT64",
  Float  = "FLOAT",
  Double = "DOUBLE",
  String = "STRING",
  Type   = "TypeDef"
}

/// Representa un tipo pasado como argumento o devuelto por una función
struct Type {
  /// Tipo primitivo
  BasicType type;

  /// Nombre del tipo complejo
  string typeName;

  /// Nivel de indirección. Si es >= 1 es un puntero a algo
  size_t indirectionLevel = 0;

  public string toString() {
    import std.algorithm.iteration : joiner;
    import std.range : repeat;
    if (type != BasicType.Type) {
      return type ~ "*".repeat(this.indirectionLevel).joiner().to!string;
    }
    return typeName ~ "*".repeat(this.indirectionLevel).joiner().to!string;
  }

  public static Type getFromText(R)(R text)
  if (isInputRange!R)
  {
    import std.algorithm.searching : canFind, count;

    Type type;
    if (text.canFind("I64")) {
      type.type = BasicType.Int64;
    } else if (text.canFind("UI64")) {
      type.type = BasicType.UInt64;
    } else if (text.canFind("UI32")) {
      type.type = BasicType.UInt32;
    } else if (text.canFind("UI16")) {
      type.type = BasicType.UInt16;
    } else if (text.canFind("UI8")) {
      type.type = BasicType.UInt8;
    } else if (text.canFind("I64")) {
      type.type = BasicType.Int64;
    } else if (text.canFind("I32")) {
      type.type = BasicType.Int32;
    } else if (text.canFind("I16")) {
      type.type = BasicType.Int16;
    } else if (text.canFind("I8")) {
      type.type = BasicType.Int8;
    } else if (text.canFind("UI")) {
      type.type = BasicType.UInt;
    } else if (text.canFind("I")) {
      type.type = BasicType.Int;
    } else if (text.canFind("F")) {
      type.type = BasicType.Float;
    } else if (text.canFind("D")) {
      type.type = BasicType.Double;
    } else if (text.canFind("S")) {
      type.type = BasicType.String;
    } else if (text.canFind("T")) {
      type.type = BasicType.Type;

      import std.regex : matchFirst, ctRegex;
      auto matchTypeName = text.matchFirst(ctRegex!(`\(([a-zA-Z0-9_-]+)\)`));
      if (!matchTypeName.empty) {
        type.typeName = matchTypeName[1];
      }
    }
    type.indirectionLevel = text.count('P');
    return type;
  }
}

/**
 * Contenedor de la información parseada de un modulo Gemix
 */
class GemixModuleInfo {
  /// Nombre del modulo
  string name;

  /// Texto de documentación
  string docBody;

  /// Categoria del módulo
  Category category = Category.Null;

  /// Tipo de sistema del módulo
  System system = System.Null;

  /// Información de las funciones definidas en el módulo
  FunctionInfo[][string] functions;

  /// Lista con el orden de insercción del nombre de las funciones
  string[] sortedFunctionNames;

  /// Bloque de texto de documentación en bruto
  string docText;

  /// Parsea el texto de documentación del módulo
  public void parseDocText() {
    import std.regex : matchFirst, replaceAll, ctRegex;

    auto nameMatch = this.docText.matchFirst(ctRegex!`@name\s+(.*)`);
    if (nameMatch.length > 0) {
      this.name = nameMatch[1].stripSpaces;
    }

    // Una vez extraido la información util de documentaciñon, obtenemos el cuerpo del texto de documentación
    this.docBody = this.docText.replaceAll(DOC_ENTRYPOINT_REGEX, "").replaceAll(ctRegex!`\s*\*\s*`, "");

    foreach(overloadedFunctions; this.functions.byValue()) {
      foreach(overloadFunction; overloadedFunctions) {
        overloadFunction.parseDocText;
      }
    }
  }

  override
  public string toString() {
    string ret =
      "Name: " ~ this.name ~  ", "
      ~ "Category: " ~ this.category ~ ", "
      ~ "System: " ~ this.system;
    if (docBody.length > 0) {
      ret ~= ", " ~ docBody;
    }
    if (functions.length > 0) {
      ret ~= ", \n";
      import std.conv : to;
      ret ~= functions.to!string;
    }
    return "{" ~ ret  ~ "}";
  }
}

/// Informacion de una función del módulo
class FunctionInfo {

  /// Signatura de la función
  string signature;

  /// Nombre de la función
  string functionName;

  /// Tipo retornado por la función
  Type returnType;

  /// Informarción de los parámetros de la función
  ParamInfo[] params;

  /// Bloque de texto de documentación en bruto
  string docText;

  /// Bloque de texto de documentación
  string docBody;

  /// Bloque de texto de documentación del valor retornado
  string docReturnBody;

  bool isLegacy;

  /// Parsea el texto de documentación del módulo
  public void parseDocText() {
    import std.regex : matchAll, matchFirst, replaceAll, ctRegex;

    auto paramMatches = this.docText.matchAll(PARAM_REGEX);
    size_t index;
    foreach(paramMatch ; paramMatches) {
      if (index >= this.params.length) {
        break;
      }
      this.params[index].name = paramMatch[1];
      this.params[index].docText = paramMatch[2].stripSpaces;
      index++;
    }
    this.docText = this.docText.replaceAll(PARAM_REGEX, "");

    auto returnMatch = this.docText.matchFirst(RETURN_REGEX);
    if (returnMatch.length > 0) {
      this.docReturnBody = returnMatch[1].stripSpaces;
    }
    this.docText = this.docText.replaceAll(RETURN_REGEX, "");

    this.isLegacy = this.docText.matchFirst(LEGACY_REGEX).length > 0;
    this.docText = this.docText.replaceAll(LEGACY_REGEX, "");

    // Una vez extraido la información util de documentaciñon, obtenemos el cuerpo del texto de documentación
    this.docBody = this.docText/*.replaceAll(DOC_ENTRYPOINT_REGEX, "")*/.replaceAll(ctRegex!`\s*\*\s*`, "\n");
  }

  override
  public string toString() {
    import std.conv : to;
    string ret =
      "Name: " ~ this.functionName ~  ", "
      ~ "Signature: " ~ this.signature ~  ", "
      ~ "Return: " ~ this.returnType.toString();
    if (docReturnBody.length > 0) {
      ret ~= " " ~ docReturnBody;
    }
    ret ~= ", Params: " ~ this.params.to!string;
    if (docBody.length > 0) {
      ret ~= ", " ~ docBody;
    }
    if (this.isLegacy) {
      ret ~= ", legacy";
    }
    return "f{" ~ ret ~ "}\n";
  }
}

/// Información de un parámetro de una función
class ParamInfo {

  /// Nombre del parámetro
  string name;

  /// Tipado del parámetro
  Type type;

  /// Valor por defecto
  string defaultValue;

  /// Documentación del parámetro
  string docText;

  override
  public string toString() {
    string ret =
      "Name: " ~ this.name ~  ", "
      ~ "Type: " ~ this.type.toString();
    if (defaultValue.length > 0) {
      ret ~= "= " ~ defaultValue;
    }
    if (docText.length > 0) {
      ret ~= ", " ~ docText;
    }
    return "p{" ~ ret ~ "}";
  }
}

