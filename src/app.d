/**
 * Procesador de cbeceras de modulos de Gemix, para generar documentación de forma automatica
 */
import std.stdio;

import moduledoc.parseheader;
import moduledoc.data;
import moduledoc.generator.markdown;

enum VERSION = "v0.1.0";

int main(string[] args) {
  import std.getopt;
  bool showVersion;
  bool append;
  string outputFilename;
  auto helpInformation = getopt(
      args,
      "v", "Show version", &showVersion,
      "a", "Append to output", &append,
      "o|output", "Output file", &outputFilename,
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

  auto output = stdout;
  if (outputFilename.length > 0) {
    output = File(outputFilename, append ? "a" : "w");
  }
  scope(exit) {
    if (output != stdout) {
      output.close();
    }
  }

  auto generator = new MarkdownGenerator(moduleInfos);
  generator.generate(output.lockingTextWriter());

  return 0;
}

