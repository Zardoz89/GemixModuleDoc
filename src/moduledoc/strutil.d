/**
 * Funciones auxiliares para procesar cadenas
 */
module moduledoc.strutil;

import std.range.primitives;
import std.traits : isSomeString;

/**
 * Elimina todos los espacios/tabuladores alrededor de la cadena
 */
R stripSpaces(R)(R text)
if (isSomeString!R)
{
  import std.string : strip;
  return text.strip("\t").strip(" ").strip("\t").strip(" ");
}

/**
 * Elimina todos los espacios/tabuladores en los extremos del InputRange
 */
R stripSpaces(R)(R text)
if (!isSomeString!R && isInputRange!R)
{
  import std.algorithm.mutation : strip;
  return text.strip('\t').strip(' ').strip('\t').strip(' ');
}

/**
 * Elimina todos los espacios/tabuladores en al principio de la cadena
 */
R stripLeftSpaces(R)(R text)
if (isSomeString!R)
{
  import std.string : stripLeft;
  return text.stripLeft("\t").stripLeft(" ").stripLeft("\t").stripLeft(" ");
}

/**
 * Elimina todos los espacios/tabuladores en al principio del InputRange
 */
R stripLeftSpaces(R)(R text)
if (!isSomeString!R && isInputRange!R)
{
  import std.algorithm.mutation : stripLeft;
  return text.stripLeft('\t').stripLeft(' ').stripLeft('\t').stripLeft(' ');
}

/**
 * Elimina todos los fines de liena al principio de la cadena
 */
R stripLeftEOL(R)(R text)
if (isSomeString!R)
{
  import std.string : stripLeft;
  return text.stripLeft("\r").stripLeft("\n");
}

/**
 * Elimina todos los fines de linea al principio del InputRange
 */
R stripLeftEOL(R)(R text)
if (!isSomeString!R && isInputRange!R)
{
  import std.algorithm.mutation : stripLeft;
  return text.stripLeft('\r').stripLeft('\n');
}

/**
 * Elimina todos los parentesis en los extremos de la cadena
 */
R stripAllParens(R)(R text)
if (isSomeString!R)
{
  import std.string : strip;
  return text.stripLeft("(", ")");
}

/**
 * Elimina todos los parentesis en los extremos de la cadena
 */
R stripOneLevelParens(R)(R text)
if (isSomeString!R)
{
  if (text.empty) {
    return text;
  }
  if (text[0] == '(') {
    text = text[1..$];
  }
  if (text.empty) {
    return text;
  }
  if (text[$-1] == ')') {
    text = text[0..$-1];
  }
  return text;
}


