
/**
 * Tipos basicos para guardar los datos parseados de las cabeceras
 */
module moduledoc.data;

import std.conv : to;

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
  String = "STRING"
}

/// Representa un tipo pasado como argumento o devuelto por una función
struct Type {
  /// Tipo primitivo
  BasicType type;

  /// Nivel de indirección. Si es >= 1 es un puntero a algo
  size_t indirectionLevel = 0;

  public string toString() {
    import std.algorithm.iteration : joiner;
    import std.range : repeat;
    return type ~ "*".repeat(this.indirectionLevel).joiner().to!string;
  }
}

/**
 * Contenedor de la información parseada de un modulo Gemix
 */
class GemixModuleInfo {
  /// Nombre del modulo
  string name;

  /// Categoria del módulo
  Category category = Category.Null;

  /// Tipo de sistema del módulo
  System system = System.Null;

  /// Información de las funciones definidas en el módulo
  FunctionInfo[][string] functions;

  /// Bloque de texto de documentación en bruto
  string docText;

  override
  public string toString() {
    string ret =
      "Name: " ~ this.name ~  ", "
      ~ "Category: " ~ this.category ~ ", "
      ~ "System: " ~ this.system;
    if (functions.length > 0) {
      ret ~= ", \n";
      import std.conv : to;
      ret ~= functions.to!string;
    }
    if (docText.length > 0) {
      ret ~= ", " ~ docText;
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

  override
  public string toString() {
    import std.conv : to;
    string ret =
      "Name: " ~ this.functionName ~  ", "
      ~ "Signature: " ~ this.signature ~  ", "
      ~ "Return: " ~ this.returnType.toString() ~ ", "
      ~ "Params: " ~ this.params.to!string;
    if (docText.length > 0) {
      ret ~= ", " ~ docText;
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

