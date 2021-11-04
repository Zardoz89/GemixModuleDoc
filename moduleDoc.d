#!/usr/bin/env dub
/+ dub.sdl:
  name "moduleDoc"
  +/
import std.stdio;
import std.getopt;

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

/// Tipos de Gemix
enum Type {
  Byte   = "BYTE",
  Word   = "WORD",
  DWord  = "DWORD",
  Int    = "INT",
  Int8   = "INT8",
  Int16  = "INT16",
  Int32  = "INT32",
  Int64  = "INT64",
  Float  = "FLOAT",
  Double = "DOUBLE",
  String = "STRING"
}

/**
 * Contenedor de la información parseada de un modulo Gemix
 */
class ModuleInfo {
  string name;
  Category category = Category.Null;
  System system = System.Null;
  FunctionInfo[string] functions;

  override
  public string toString() {
    string ret =
      "Name: " ~ this.name ~  ", "
      ~ "Category: " ~ this.category ~ ", "
      ~ "System: " ~ this.system;
    if (functions.length > 0) {
      import std.conv : to;
      ret ~= functions.to!string;
    }
    return "{" ~ ret  ~ "}";
  }
}

class FunctionInfo {
  string signature;
  Type returnType;
  ParamInfo[] params;
  string docText;

  override
  public string toString() {
    import std.conv : to;
    string ret =
      "Signature: " ~ this.signature ~  ", "
      ~ "Return: " ~ this.returnType ~ ", "
      ~ "Params: " ~ this.params.to!string;
    if (docText.length > 0) {
      ret ~= ", " ~ docText;
    }
    return "f{" ~ ret ~ "}";
  }
}

class ParamInfo {
  string name;
  Type type;
  string defaultValue;
  string docText;

  override
  public string toString() {
    string ret = 
      "Name: " ~ this.name ~  ", "
      ~ "Type: " ~ this.type;
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
  auto f = File(fileName, "r");
  scope(exit) {
    f.close();
  }

  ModuleInfo moduleInfo = new ModuleInfo();
  import std.algorithm.iteration : map;
  import std.algorithm.mutation : stripRight;
  foreach (line; f.byLineCopy().map!(l => l.stripRight('\r'))) {
    processHeaderCommentBlock(line, moduleInfo);
    processLibraryProperties(line, moduleInfo);
    processLibraryExportsBlock(line, moduleInfo);
  }

  return moduleInfo;
}

private bool headerCommentBlock;
private bool procesedHeaderCommentBlock;
private void processHeaderCommentBlock(string line, ModuleInfo moduleInfo) {
  import std.algorithm.searching : findSkip;
  import std.regex : split, regex;
  if (procesedHeaderCommentBlock) {
    return;
  }

  if(line.findSkip("/**")) {
    headerCommentBlock = true;
  }

  if(headerCommentBlock && line.findSkip("@name")) {
    import std.algorithm.mutation : strip, stripRight;
    import std.conv : to;
    moduleInfo.name = line.strip(' ').stripRight('*');
  }

  if(headerCommentBlock && line.findSkip("*/")) {
    headerCommentBlock = false;
    procesedHeaderCommentBlock = true;
  }
}

private bool libraryPropertiesBlock;
private bool procesedLibraryPropertiesBlock;
private bool propertyCategoryBlock;
private bool propertySystemBlock;
private void processLibraryProperties(string line, ModuleInfo moduleInfo) {
  import std.algorithm.searching : findSkip;
  import std.regex : split, regex;

  if (procesedLibraryPropertiesBlock) {
    return;
  }

  if (line.findSkip("GMXDEFINE_LIBRARY_PROPERTIES")) {
    libraryPropertiesBlock = true;
  }

  if (libraryPropertiesBlock && line.findSkip("GMXDEFINE_PROPERTY_CATEGORY")) {
    propertyCategoryBlock = true;
  }
  if (propertyCategoryBlock) {
    if (line.findSkip("GMXCATEGORY_")) {
      auto categoryToken = line.split(regex("[)]|$"));
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
      propertyCategoryBlock = false;
    }
  }

  if (libraryPropertiesBlock && line.findSkip("GMXDEFINE_PROPERTY_SYSTEM")) {
    propertySystemBlock = true;
  }
  if (propertySystemBlock) {
    if (line.findSkip("GMXSYSTEM_")) {
      auto systemToken = line.split(regex("[)]|$"));
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
      propertySystemBlock = false;
    }
  }

  if (libraryPropertiesBlock && moduleInfo.system != System.Null && moduleInfo.category != Category.Null) {
    procesedLibraryPropertiesBlock = true;
    libraryPropertiesBlock = false;
  }
}

private bool libraryExportsBlock;
private bool procesedLibraryExportsBlock;
private void processLibraryExportsBlock(string line, ModuleInfo moduleInfo) {
  import std.algorithm.searching : findSkip;
  import std.regex : split, regex;

  if (procesedLibraryExportsBlock) {
    return;
  }

  if (line.findSkip("GMXDEFINE_LIBRARY_EXPORTS")) {
    libraryExportsBlock = true;
  }

  processFunctionsBlock(line, moduleInfo);
}

private bool functionsBlock;
private bool procesedFunctionsBlock;
private void processFunctionsBlock(string line, ModuleInfo moduleInfo) {
  import std.algorithm.searching : findSkip, findSplit;
  import std.regex : split, regex;

  if (procesedFunctionsBlock) {
    return;
  }

  if (line.findSkip("GMXDEFINE_FUNCTIONS")) {
    functionsBlock = true;
  }

  // todo

}

