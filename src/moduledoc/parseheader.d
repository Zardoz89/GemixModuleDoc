/**
 * Procesador de cabeceras de modulos de Gemix, para generar documentación de forma automatica
 */
module moduledoc.parseheader;

import std.stdio;
import std.regex : split, ctRegex;
import std.algorithm.searching : findSkip, findSplit, findSplitBefore;
import std.conv : to;
import std.range : drop;
import std.range.primitives : isInputRange;

import moduledoc.data;

private enum EOL_REGEX = ctRegex!`[)]|\r\n|\n|$`;

/**
 * Lee un fichero fuente C o C++ y genera un GemixModuleInfo con la información parseada del fichero
 */
GemixModuleInfo processFile(string fileName) {
  import std.file : readText;
  import std.utf : byUTF;

  GemixModuleInfo moduleInfo = new GemixModuleInfo();
  auto fileData = readText(fileName).byUTF!char()
    .processHeaderCommentBlock(moduleInfo)
    .processLibraryProperties(moduleInfo)
    .processLibraryExportsBlock(moduleInfo);

  return moduleInfo;
}

private R processHeaderCommentBlock(R)(R text, GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  import std.regex : matchFirst;
  import std.range : dropBack;

  if(text.findSkip("/**")) {
    moduleInfo.docText = text.to!string.matchFirst(ctRegex!(`.*?\*/`, "s")).hit.dropBack(2);

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

private R processLibraryProperties(R)(R text, GemixModuleInfo moduleInfo)
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

private R processLibraryExportsBlock(R)(R text, GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  if (text.findSkip("GMXDEFINE_LIBRARY_EXPORTS")) {
    text = text.processFunctionsBlock(moduleInfo);
  }
  return text;
}

private R processFunctionsBlock(R)(R text, GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  import std.algorithm.searching : canFind;
  import std.algorithm.mutation : stripLeft, stripRight;
  import std.range : chunks, stride;
  import std.regex : splitter;
  import std.typecons : Yes;

  if (text.findSkip("GMXDEFINE_FUNCTIONS(")) {
    text = text.stripLeft('\r').stripLeft('\n').stripLeft(' ').stripLeft('\t').stripLeft(' ');

    // Obtenemos todo el bloque dentro de GMXDEFINE_FUNCTIONS
    string functionsBlock = text.findSplitBefore(");")[0].to!string;

    // Dividimos el bloque en otros que contengan bloques de comentarios y declaraciones de funciones
    auto fDecAndCommentBlocks = functionsBlock.splitter!(Yes.keepSeparators)(ctRegex!(`/\*\*.*?\*/`, "s"));
    string functionDocText = "";
    foreach (fDecAndCommentBlock; fDecAndCommentBlocks) {
      fDecAndCommentBlock = fDecAndCommentBlock.stripLeft('\r').stripLeft('\n').stripLeft(' ');
      if (fDecAndCommentBlock.length == 0) {
        continue;
      }

      // Obtenemos el texto del bloque de comentarios que enbace estas declaraciones de funciones
      if (fDecAndCommentBlock.canFind("/**")) {
        functionDocText = processFunctionCommentBlock(fDecAndCommentBlock);
      } else {
        auto fTokens = fDecAndCommentBlock.splitter(ctRegex!`,\s+`).chunks(2).stride(2);
        // Cada entrada en fTokens, es una definición de una funcion : "sigantura", "retorno"
        foreach(fToken; fTokens) {
          if (fToken.empty) {
            continue;
          }
          auto functionInfo = processFunctionToken(fToken);
          if (!(functionInfo is null)) {
            functionInfo.docText = functionDocText;
            moduleInfo.functions[functionInfo.functionName] ~= functionInfo;
          }
        }
      }
    }

    text = text.drop(functionsBlock.length);
  }
  return text;
}

private string processFunctionCommentBlock(R)(ref R text)
if (isInputRange!R)
{
  import std.range : dropBack;
  import std.regex : matchFirst;

  string ret = "";
  if(text.findSkip("/**")) {
    ret = text.matchFirst(ctRegex!(`.*\*/`, "s")).hit.dropBack(2);
  }
  text.findSkip("*/");
  return ret;
}

private FunctionInfo processFunctionToken(R)(R fToken)
if (isInputRange!R)
{
  import std.regex : matchFirst;
  import std.string : strip, stripLeft, stripRight;

  string signature = fToken.front.stripLeft("\r").stripLeft("\n").stripLeft(" ").strip("\"");
  if (signature.length == 0) {
    return null;
  }

  FunctionInfo funcionInfo = new FunctionInfo();
  funcionInfo.signature = signature;
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
