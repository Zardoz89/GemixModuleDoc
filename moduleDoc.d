#!/usr/bin/env dub
/+ dub.sdl:
  name "moduleDoc"
  +/
import std.stdio;
import std.regex : split, ctRegex;
import std.algorithm.searching : findSkip, findSplit, findSplitBefore;
import std.conv : to;
import std.range : drop;
import std.range.primitives : isInputRange;

private enum EOL_REGEX = ctRegex!`[)]|\r\n|\n|$`;

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
  BasicType type;
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
class ModuleInfo {
  string name;
  Category category = Category.Null;
  System system = System.Null;
  FunctionInfo[][string] functions;

  override
  public string toString() {
    string ret =
      "Name: " ~ this.name ~  ", "
      ~ "Category: " ~ this.category ~ ", "
      ~ "System: " ~ this.system;
    if (functions.length > 0) {
      ret ~= ", ";
      import std.conv : to;
      ret ~= functions.to!string;
    }
    return "{" ~ ret  ~ "}";
  }
}

/// Informacion de una función del módulo
class FunctionInfo {
  string signature;
  string functionName;
  Type returnType;
  ParamInfo[] params;
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
  string name;
  Type type;
  string defaultValue;
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

enum VERSION = "v0.1.0";

int main(string[] args) {
  import std.getopt;
  bool showVersion;
  auto helpInformation = getopt(
      args,
      "v", "Show version", &showVersion
      );

  if (showVersion) {
    writeln("moduleDoc " ~ VERSION);
    return 0;
  }

  if (helpInformation.helpWanted || args.length <= 1)
  {
    defaultGetoptPrinter("moduleDoc [options] inputFile0 inputFile1...\n"
        ~ "An automatic tool to generate Gemix modules documentation from his source files.",
        helpInformation.options);
    return helpInformation.helpWanted ? 0 : 1;
  }

  string[] inputFiles = args[1..$];

  ModuleInfo[] moduleInfos = [];
  foreach(inputFile; inputFiles) {
    moduleInfos ~= processFile(inputFile);
  }

  writeln(moduleInfos);

  return 0;
}

/**
 * Lee un fichero fuente C o C++ y genera un ModuleInfo con la información parseada del fichero
 */
ModuleInfo processFile(string fileName) {
  import std.file : readText;
  import std.utf : byUTF;

  ModuleInfo moduleInfo = new ModuleInfo();
  auto fileData = readText(fileName).byUTF!char()
    .processHeaderCommentBlock(moduleInfo)
    .processLibraryProperties(moduleInfo)
    .processLibraryExportsBlock(moduleInfo);

  return moduleInfo;
}

private R processHeaderCommentBlock(R)(R text, ModuleInfo moduleInfo)
if (isInputRange!R)
{
  if(text.findSkip("/**")) {
    if(text.findSkip("@name")) {
      import std.algorithm.mutation : strip;
      string nameToken = text.to!string.split(EOL_REGEX)[0];
      moduleInfo.name = nameToken.strip('\t').strip(' ').strip('*');
      text = text.drop(nameToken.length);
    }
  }
  text.findSkip("*/");
  return text;
}

private R processLibraryProperties(R)(R text, ModuleInfo moduleInfo)
if (isInputRange!R)
{
  if (text.findSkip("GMXDEFINE_LIBRARY_PROPERTIES")) {
    if (text.findSkip("GMXDEFINE_PROPERTY_CATEGORY")) {
      if (text.findSkip("GMXCATEGORY_")) {
        auto categoryToken = text.to!string.split(EOL_REGEX);
        switch (categoryToken[0]) {
          case "GENERIC":
            moduleInfo.category = Category.Generic;
            break;

          case "AUDIO":
            moduleInfo.category = Category.Audio;
            break;

          case "GRAPHICS":
            moduleInfo.category = Category.Graphics;
            break;

          case "INPUT":
            moduleInfo.category = Category.Input;
            break;

          case "PHYSICS":
            moduleInfo.category = Category.Physics;
            break;

          case "UNKNOWN":
          default:
            moduleInfo.category = Category.Unknown;
        }
        text = text.drop(categoryToken[0].length);
      }
    }

    if (text.findSkip("GMXDEFINE_PROPERTY_SYSTEM")) {
      if (text.findSkip("GMXSYSTEM_")) {
        auto systemToken = text.to!string.split(EOL_REGEX);
        switch (systemToken[0]) {
          case "COMMON":
            moduleInfo.system = System.Common;
            break;

          case "LEGACY":
            moduleInfo.system = System.Legacy;
            break;

          case "MODERN":
            moduleInfo.system = System.Modern;
            break;

          case "UNKNOWN":
          default:
            moduleInfo.system = System.Unknown;
        }
        text = text.drop(systemToken[0].length);
      }
    }
  }
  return text;
}

private R processLibraryExportsBlock(R)(R text, ModuleInfo moduleInfo)
if (isInputRange!R)
{
  if (text.findSkip("GMXDEFINE_LIBRARY_EXPORTS")) {
    text = text.processFunctionsBlock(moduleInfo);
  }
  return text;
}

private R processFunctionsBlock(R)(R text, ModuleInfo moduleInfo)
if (isInputRange!R)
{
  import std.algorithm.mutation : stripLeft, stripRight;
  import std.range : chunks, stride;
  import std.regex : splitter;
  if (text.findSkip("GMXDEFINE_FUNCTIONS(")) {
    text = text.stripLeft('\r').stripLeft('\n').stripLeft(' ').stripLeft('\t').stripLeft(' ');
    // TODO
    string functionsBlock = text.findSplitBefore(");")[0].to!string;
    auto fTokens = functionsBlock.splitter(ctRegex!`,\s+`).chunks(2).stride(2);
    // Cada entrada en fTokens, es una definición de una funcion : "sigantura", "retorno"
    foreach(fToken; fTokens) {
      auto functionInfo = processFunctionToken(fToken);
      moduleInfo.functions[functionInfo.functionName] ~= functionInfo;
    }

    text = text.drop(functionsBlock.length);
  }
  return text;
}

private FunctionInfo processFunctionToken(R)(R fToken)
if (isInputRange!R)
{
  import std.regex : matchFirst;
  import std.string : strip, stripLeft, stripRight;

  FunctionInfo funcionInfo = new FunctionInfo();
  funcionInfo.signature = fToken.front.strip("\"");
  funcionInfo.functionName = funcionInfo.signature.matchFirst(ctRegex!`[a-zA-Z0-9_-]+`).hit;
  foreach(param; funcionInfo.signature[funcionInfo.functionName.length..$].stripLeft("(").stripRight(")").split(ctRegex!`,`)) {
    funcionInfo.params ~= processSignatureParam(param);
  }

  fToken.popFront();
  funcionInfo.returnType = fToken.front.getTypeFromText;
  return funcionInfo;
}

private ParamInfo processSignatureParam(R)(R param)
if (isInputRange!R)
{
  ParamInfo paramInfo = new ParamInfo();
  paramInfo.type = param.getTypeFromText;
  if (param.findSkip("=")) {
    paramInfo.defaultValue = param;
  }
  return paramInfo;
}

private Type getTypeFromText(R)(R text)
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
  }
  type.indirectionLevel = text.count('P');
  return type;
}
