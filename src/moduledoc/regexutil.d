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
package enum IDENTIFIER_REGEX = ctRegex!(`[a-zA-Z_][a-zA-Z0-9_-]+`);

