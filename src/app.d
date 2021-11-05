/**
 * Procesador de cbeceras de modulos de Gemix, para generar documentación de forma automatica
 */
import std.stdio;

import moduledoc.parseheader;
import moduledoc.data;

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

  GemixModuleInfo[] moduleInfos = [];
  foreach(inputFile; inputFiles) {
    moduleInfos ~= processFile(inputFile);
  }

  foreach(moduleInfo; moduleInfos) {
    moduleInfo.parseDocText();
  }

  writeln(moduleInfos);

  return 0;
}

