/**
 * Funciones auxiliares para procesar cadenas
 */
module moduledoc.strutil;

import std.algorithm.mutation : remove, strip, stripLeft, stripRight;
import std.range.primitives;
import std.regex : replaceAll, ctRegex;
import std.string : strip;
import std.traits : isSomeString;

/**
 * Elimina todos los espacios/tabuladores alrededor de la cadena
 */
R stripSpaces(R)(R text)
if (isSomeString!R)
{
  return text.strip("\t").strip(" ").strip("\t").strip(" ");
}

/**
 * Elimina todos los espacios/tabuladores en los extremos del InputRange
 */
R stripSpaces(R)(R text)
if (!isSomeString!R && isInputRange!R)
{
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
  return text.stripLeft('\r').stripLeft('\n');
}

/**
 * Elimina todos los fines de liena al final de la cadena
 */
R stripRightEOL(R)(R text)
if (isSomeString!R)
{
  import std.string : stripRight;
  return text.stripRight("\n").stripRight("\r");
}

/**
 * Elimina todos los parentesis en los extremos de la cadena
 */
R stripAllParens(R)(R text)
if (isSomeString!R)
{
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

/// Removes carraige return (\r) from a string
R removeCarriageReturn(R)(R text)
if (isSomeString!R)
{
  return text.replaceAll(ctRegex!"\r", "");
}

/// Removes carraige return (\r) from a string
R removeCarriageReturn(R)(R text)
if (!isSomeString!R && isInputRange!R)
{
  return text.remove!("c == \r")(text);
}
