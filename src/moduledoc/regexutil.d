/**
 * Regex predefinidos
 */
module moduledoc.regexutil;

import std.regex : ctRegex;

/// Regex que busca un fin de linea o expresión
package enum EOL_REGEX = ctRegex!`[)]|\r\n|\n|$`;

/// Regex que extra el contenido de un bloque de comentarios
package enum EXTRACT_COMMENT_BLOCK_REGEX =ctRegex!(`.*?\*/`, "s");

/// Regex para un bloque de comentarios
package enum COMMENT_BLOCK_REGEX = ctRegex!(`/\*\*.*?\*/`, "s");

/// Regex para "tokenizar" valores separados por comas con espacios
package enum SPLIT_COMMA_SPACE_SEPARATOR_REGEX =ctRegex!(`,\s+`, "s");

/// Regex para "tokenizar" valores separados por comas con espacios
package enum SPLIT_COMMA_SEPARATOR_REGEX = ctRegex!(`,`, "s");

/// Regex que devuelve un identificador valido
package enum IDENTIFIER_REGEX = ctRegex!(`[a-z_][a-z0-9_-]+`, "i");

/// Regex para encontrar una entrada de documentación estilo JavaDoc/JsDoc/DOxygen
package enum SIMPLE_DOC_ATTRIBUTE_REGEX = ctRegex!(`@(\w+)\s+(.*)$`, "m");

/// Regex para encontrar una entrada @param XXXX ...
package enum PARAM_REGEX = ctRegex!(`@param\s+([a-zA-Z][a-zA-Z0-9_-]*)([ ]+.*){0,1}`, "m");

/// Regex para encontrar una entrada @return XXXX
package enum RETURN_REGEX = ctRegex!`@return\s+(.*)`;

/// Regex para encontrar una entrada @legacy
package enum LEGACY_REGEX = ctRegex!(`@legacy(?:\s+(.*)){0,1}?`);

