/**
 * Procesador de cabeceras de modulos de Gemix, para generar documentación de forma automatica
 */
module moduledoc.parseheader;

import std.stdio;
import std.regex : split;
import std.algorithm.searching : findSkip, findSplit, findSplitBefore;
import std.conv : to;
import std.range : drop;
import std.range.primitives : isInputRange;

import moduledoc.data;
import moduledoc.regexutil;
import moduledoc.strutil;

/**
 * Lee un fichero fuente C o C++ y genera un GemixModuleInfo con la información parseada del fichero
 */
GemixModuleInfo processFile(string fileName) {
  import std.file : readText;
  import std.utf : byUTF;

  GemixModuleInfo moduleInfo;
  auto fileData = readText(fileName).byUTF!char()
    .processHeaderCommentBlock(moduleInfo)
    .processLibraryProperties(moduleInfo)
    .processLibraryExportsBlock(moduleInfo);

  return moduleInfo;
}

/// Procesa el comentario cabecera del modulo
private R processHeaderCommentBlock(R)(R text, ref GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  import std.regex : matchFirst;
  import std.range : dropBack;

  if(text.findSkip("/**")) {
    moduleInfo.docText = text.to!string.matchFirst(EXTRACT_COMMENT_BLOCK_REGEX).hit.dropBack(2);
  }
  text.findSkip("*/");
  return text;
}

/// Procesa las propiedades del modulo
private R processLibraryProperties(R)(R text, ref GemixModuleInfo moduleInfo)
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

/// Procesa las declaraciones publicas del modulo
private R processLibraryExportsBlock(R)(R text, ref GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  if (text.findSkip("GMXDEFINE_LIBRARY_EXPORTS")) {
    text = text
      .processConstsBlock(moduleInfo)
      .processFunctionsBlock(moduleInfo);
  }
  return text;
}

/// Procesa los bloques de declaraciones de constantes del modulo
private R processConstsBlock(R)(R text, ref GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  while (text.findSkip("GMXDEFINE_CONSTS_")) {
    string constBlock = text.findSplitBefore(");")[0].to!string;
    auto constBlockLength = constBlock.length;

    constBlock.processConstBlock(moduleInfo);

    text = text.drop(constBlockLength);
  }
  return text;
}

/// Procesa un bloque de declaraciones de constantes del modulo
private void processConstBlock(string constBlock, ref GemixModuleInfo moduleInfo)
{
  import std.algorithm.searching : canFind;
  import std.range : chunks, drop;
  import std.regex : ctRegex, matchFirst, splitter;
  import std.string : strip;
  import std.typecons : Yes;

  auto match = constBlock.matchFirst(ctRegex!(`([A-Z]+[0-9]{0,2})(?:\()`));
  if (match.length > 0) {
    string type = match[1];
    constBlock = constBlock.drop(type.length + 1);

    // Dividimos el bloque en subloques que contengan bloques de comentarios y constantes
    auto constDecAndCommentBlocks = constBlock.splitter!(Yes.keepSeparators)(COMMENT_BLOCK_REGEX);
    string constDocText = "";
    foreach (constDecAndCommentBlock; constDecAndCommentBlocks) {
      constDecAndCommentBlock = constDecAndCommentBlock.stripLeftEOL.stripLeftSpaces;
      if (constDecAndCommentBlock.length == 0) {
        continue;
      }

      // Obtenemos el texto del bloque de comentarios que enbace estas declaraciones de funciones
      if (constDecAndCommentBlock.canFind("/**")) {
        constDocText = processCommentBlock(constDecAndCommentBlock);
      } else {
        // Rango de pares "XXXX" valor
        auto constPairs = constDecAndCommentBlock.splitter(SPLIT_COMMA_SPACE_SEPARATOR_REGEX).chunks(2);
        foreach(constPair ; constPairs) {
          ConstInfo constInfo = {name: constPair.front.stripSpaces.stripRightEOL.strip("\""), type: type};
          constPair.popFront;
          constInfo.value = constPair.front.stripSpaces.stripRightEOL;
          constInfo.docText = constDocText.stripSpaces;
          constDocText = "";

          moduleInfo.constInfos ~= constInfo;
        }
      }
    }
  }
}

/// Procesa las declaraciones de funciones del modulo
private R processFunctionsBlock(R)(R text, ref GemixModuleInfo moduleInfo)
if (isInputRange!R)
{
  import std.algorithm.searching : canFind;
  import std.range : chunks, stride;
  import std.regex : splitter;
  import std.typecons : Yes;

  if (text.findSkip("GMXDEFINE_FUNCTIONS(")) {
    text = text.stripLeftEOL.stripLeftSpaces;

    // Obtenemos todo el bloque dentro de GMXDEFINE_FUNCTIONS
    string functionsBlock = text.findSplitBefore(");")[0].to!string;

    // Dividimos el bloque en otros que contengan bloques de comentarios y declaraciones de funciones
    auto fDecAndCommentBlocks = functionsBlock.splitter!(Yes.keepSeparators)(COMMENT_BLOCK_REGEX);
    string functionDocText = "";
    foreach (fDecAndCommentBlock; fDecAndCommentBlocks) {
      string lastFunctionName;
      fDecAndCommentBlock = fDecAndCommentBlock.stripLeftEOL.stripLeftSpaces;
      if (fDecAndCommentBlock.length == 0) {
        continue;
      }

      // Obtenemos el texto del bloque de comentarios que enbace estas declaraciones de funciones
      if (fDecAndCommentBlock.canFind("/**")) {
        functionDocText = processCommentBlock(fDecAndCommentBlock);
      } else {
        auto fTokens = fDecAndCommentBlock.splitter(SPLIT_COMMA_SPACE_SEPARATOR_REGEX).chunks(2).stride(2);
        // Cada entrada en fTokens, es una definición de una funcion : "sigantura", "retorno"
        foreach(fToken; fTokens) {
          if (fToken.empty) {
            continue;
          }
          auto functionInfo = processFunctionToken(fToken);
          if (!(functionInfo is null)) {

            // Evitamos arrastrar el mismo bloque de comentarios a otras funciones con nombre distinto
            if (lastFunctionName.length > 0 && lastFunctionName != functionInfo.functionName &&
                functionDocText == moduleInfo.functions[lastFunctionName][0].docText) {
              functionDocText = "";
            }
            functionInfo.docText = functionDocText;
            lastFunctionName = functionInfo.functionName;
            moduleInfo.functions[lastFunctionName] ~= functionInfo;

            // Guardamos el orden de aparición de las funciones en fichero C/C++
            if (!moduleInfo.sortedFunctionNames.canFind(lastFunctionName)) {
              moduleInfo.sortedFunctionNames ~= lastFunctionName;
            }
          }
        }
      }
    }

    text = text.drop(functionsBlock.length);
  }
  return text;
}

private string processCommentBlock(R)(ref R text)
if (isInputRange!R)
{
  import std.range : dropBack;
  import std.regex : matchFirst;

  string ret = "";
  if(text.findSkip("/**")) {
    ret = text.matchFirst(EXTRACT_COMMENT_BLOCK_REGEX).hit.dropBack(2);
  }
  text.findSkip("*/");
  return ret;
}

private FunctionInfo processFunctionToken(R)(R fToken)
if (isInputRange!R)
{
  import std.regex : matchFirst;
  import std.string : strip, stripLeft, stripRight;

  string signature = fToken.front.stripLeftEOL.stripSpaces.strip("\"");
  if (signature.length == 0) {
    return null;
  }

  FunctionInfo funcionInfo = new FunctionInfo();
  funcionInfo.signature = signature;
  funcionInfo.functionName = funcionInfo.signature.matchFirst(IDENTIFIER_REGEX).hit;
  foreach(param; funcionInfo.signature[funcionInfo.functionName.length..$].stripOneLevelParens.split(SPLIT_COMMA_SEPARATOR_REGEX)) {
    funcionInfo.params ~= processSignatureParam(param);
  }

  fToken.popFront();
  funcionInfo.returnType = Type.getFromText(fToken.front);
  return funcionInfo;
}

private ParamInfo processSignatureParam(R)(R param)
if (isInputRange!R)
{
  ParamInfo paramInfo;
  paramInfo.type = Type.getFromText(param);
  if (param.findSkip("=")) {
    paramInfo.defaultValue = param;
  }
  return paramInfo;
}

