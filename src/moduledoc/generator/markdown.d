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

  private void generate(R)(R sink, ref GemixModuleInfo moduleInfo)
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

    if (moduleInfo.constInfos.length > 0) {
      sink.put("## Consts");
      sink.put("\n\n");

      this.generateVarsList(sink , moduleInfo.constInfos);
      sink.put("\n\n");
    }

    if (moduleInfo.globalsInfos.length > 0) {
      sink.put("## Globals");
      sink.put("\n\n");

      this.generateVarsList(sink , moduleInfo.globalsInfos);
      sink.put("\n\n");
    }

    if (moduleInfo.localInfos.length > 0) {
      sink.put("## Locals");
      sink.put("\n\n");

      this.generateVarsList(sink , moduleInfo.localInfos);
      sink.put("\n\n");
    }

    if (moduleInfo.typedefInfos.length > 0) {
      sink.put("## Types");
      sink.put("\n\n");

      this.generateTypes(sink , moduleInfo.typedefInfos);
      sink.put("\n\n");
    }

    if (moduleInfo.functions.length > 0) {
      import std.array : array;
      import std.algorithm.sorting : sort;

      sink.put("## Functions");
      sink.put("\n\n");

      auto sortedFunctionNames = moduleInfo.sortedFunctionNames;
      foreach(functionName; sortedFunctionNames) {
        this.generateFunctions(sink, moduleInfo.functions[functionName]);
        sink.put("\n\n");
      }
    }
  }

  private void generateVarsList(R)(R sink, VarInfo[] varInfos)
  if (isOutputRange!(R, char)) {
    foreach(varInfo; varInfos) {
      this.generateVar(sink, varInfo);
    }
  }

  private void generateVar(R)(R sink, VarInfo varInfo)
  if (isOutputRange!(R, char)) {
    sink.put(" * `");
    sink.put(varInfo.type);
    sink.put(" ");
    sink.put(varInfo.name);
    if (varInfo.value.length > 0) {
      sink.put(" = ");
      sink.put(varInfo.value);
    }
    sink.put("`\n");
    if (varInfo.docText.length > 0) {
      sink.put("\t\n");
      sink.put("\t");
      sink.put(varInfo.docText);
      sink.put("\n\t\n");
    }
  }

  private void generateTypes(R)(R sink, TypedefInfo[] typedefInfos)
  if (isOutputRange!(R, char)) {
    if (typedefInfos.empty) {
      return;
    }

    foreach(typedefInfo; typedefInfos) {
      this.generateType(sink, typedefInfo);
    }
  }

  private void generateType(R)(R sink, TypedefInfo typedefInfo)
  if (isOutputRange!(R, char)) {
    sink.put("### ");
    sink.put(typedefInfo.name);
    sink.put("\n\n");

    if (typedefInfo.docText.length > 0) {
      sink.put(typedefInfo.docText);
      sink.put("\n\n");
    }

    sink.put("#### Members");
    sink.put("\n\n");
    this.typeTable(sink, typedefInfo.members);
    sink.put("\n");
  }

  /// Genera la tabla de miembros de un typedef o parámetros de una función
  private void typeTable(R)(R sink, TypeMember[] typeMembers)
  if (isOutputRange!(R, char)) {
    import std.string : leftJustify;

    sink.put("| Name              | Type        |                                      |\n");
    sink.put("|-------------------|-------------|--------------------------------------|\n");

    foreach(member; typeMembers) {
      sink.put("| ");
      sink.put(member.name.leftJustify(17));
      sink.put(" | ");
      sink.put(member.type.toString.leftJustify(11));
      sink.put(" | ");
      sink.put(member.docText.leftJustify(36));
      sink.put(" |\n");
    }
  }

  private void generateFunctions(R)(R sink, FunctionInfo[] functionInfos)
  if (isOutputRange!(R, char)) {
    if (functionInfos.empty) {
      return;
    }

    this.generateFunction(sink, functionInfos[0], true);
    functionInfos = functionInfos[1..$];
    if (functionInfos.length > 0) {
      sink.put("#### Overloads");
      sink.put("\n\n");

      foreach(functionInfo; functionInfos) {
        this.generateFunction(sink, functionInfo, false);
      }
    }
  }

  private void generateFunction(R)(R sink, FunctionInfo functionInfo, bool showDocumentation)
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
        sink.put("\n");
      }

      if (functionInfo.params.length > 0) {
        sink.put("#### Parameters");
        sink.put("\n\n");
        this.typeTable(sink, functionInfo.params);
        sink.put("\n");
      }

      sink.put("#### Return");
      sink.put("\n\n`");
      sink.put(functionInfo.returnType.toString);
      sink.put("`");
      if (functionInfo.docReturnBody.length > 0) {
        sink.put(" ");
        sink.put(functionInfo.docReturnBody);
      }
      sink.put("\n\n");
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

