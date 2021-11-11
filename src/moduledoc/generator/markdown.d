/**
 * Generador de Markdown a partir de los datos parseados
 */
module moduledoc.generator.markdown;

import std.range;
import std.conv : to;

import moduledoc.data;


class MarkdownGenerator {
  private GemixModuleInfo[] moduleInfos;

  this(GemixModuleInfo[] modulesInfos) {
    this.moduleInfos = modulesInfos;
  }

  void setModuleInfos(GemixModuleInfo[] modulesInfos) {
    this.moduleInfos = moduleInfos;
  }

  void generate(R)(R sink)
  if (isOutputRange!(R, char)) {
    foreach(index, moduleInfo ; moduleInfos) {
      this.generate(sink, moduleInfo);
      if (index < moduleInfos.length - 1) {
        sink.put("\n");
        sink.put("---");
        sink.put("\n");
      }
    }

  }

  private void generate(R)(R sink, GemixModuleInfo moduleInfo)
  if (isOutputRange!(R, char)) {
    if (moduleInfo.name.length > 0) {
      sink.put(moduleInfo.name);
      sink.put("\n");
      foreach(i; 0 .. moduleInfo.name.length) {
        sink.put("-");
      }
    } else {
      sink.put("noname\n");
      sink.put("------");
    }
    sink.put("\n\n");

    sink.put("Category: ");
    sink.put(moduleInfo.category.to!string);
    sink.put("\n\n");
    sink.put("System: ");
    sink.put(moduleInfo.system.to!string);
    sink.put("\n");

    if (moduleInfo.docBody.length > 0) {
      sink.put("\n");
      sink.put(moduleInfo.docBody);
    }
    sink.put("\n\n");

    if (moduleInfo.functions.length > 0) {
      import std.array : array;
      import std.algorithm.sorting : sort;

      sink.put("## Functions");
      sink.put("\n\n");

      auto sortedFunctionNames = moduleInfo.sortedFunctionNames;
      //moduleInfo.functions.byKey().array.sort!("a < b");
      foreach(functionName; sortedFunctionNames) {
        this.generate(sink, moduleInfo.functions[functionName]);
        sink.put("\n\n");
      }
    }
  }

  private void generate(R)(R sink, FunctionInfo[] functionInfos)
  if (isOutputRange!(R, char)) {
    if (functionInfos.empty) {
      return;
    }

    this.generate(sink, functionInfos[0], true);
    functionInfos = functionInfos[1..$];
    if (functionInfos.length > 0) {
      sink.put("#### Overloads");
      sink.put("\n\n");

      foreach(functionInfo; functionInfos) {
        this.generate(sink, functionInfo, false);
      }
    }

  }

  private void generate(R)(R sink, FunctionInfo functionInfo, bool showDocumentation)
  if (isOutputRange!(R, char)) {
    if (showDocumentation) {
      sink.put("### `");
      this.generateFunctionSignature(sink, functionInfo);
      sink.put("`\n\n");

      if (functionInfo.isLegacy) {
        sink.put("**LEGACY**\n");
      }

      if (functionInfo.docBody.length > 0) {
        sink.put(functionInfo.docBody);
        sink.put("\n\n");
      }

      if (functionInfo.params.length > 0) {
        sink.put("#### Parameters");
        sink.put("\n\n");
        sink.put("| Name              | Type        |                                      |\n");
        sink.put("|-------------------|-------------|--------------------------------------|\n");

        foreach(paramInfo; functionInfo.params) {
          sink.put("| ");
          sink.put(paramInfo.name);
          sink.put("\t| ");
          sink.put(paramInfo.type.toString);
          sink.put("\t| ");
          sink.put(paramInfo.docText);
          sink.put("\t|\n");
        }
        sink.put("\n");
      }

      sink.put("#### Return");
      sink.put("\n\n");
      sink.put(functionInfo.returnType.toString);
      sink.put("\n");
      if (functionInfo.docReturnBody.length > 0) {
        sink.put(functionInfo.docReturnBody);
        sink.put("\n");
      }
      sink.put("\n");
    } else {

      sink.put("```gemix\n");
      this.generateFunctionSignature(sink, functionInfo);
      sink.put("\n```\n");
    }
  }

  private void generateFunctionSignature(R)(R sink, FunctionInfo functionInfo)
  if (isOutputRange!(R, char)) {
    sink.put(functionInfo.returnType.toString);
    sink.put(" ");
    sink.put(functionInfo.functionName);
    sink.put("(");
    foreach(index, paramInfo; functionInfo.params) {
      sink.put(paramInfo.type.toString);
      sink.put(" ");
      sink.put(paramInfo.name);
      if (paramInfo.defaultValue.length > 0) {
        sink.put("=");
        sink.put(paramInfo.defaultValue);
      }
      if (index < functionInfo.params.length - 1) {
        sink.put(", ");
      }
    }
    sink.put(")");
  }

}

