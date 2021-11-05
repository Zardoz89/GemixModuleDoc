# Gemix Module documentation generator

A tool to automate the documentation generation for Gemix Studio modules

## Building

This tool uses DLang, so requires `dub` and a DLang compiler, like `dmd`. We
recomend using `dmd`, since his install includes `dub`.

https://dlang.org/download.html

Simply run `dub build`, and a executable will be generated on the root folder
of the project.

## Using it

`moduleDoc [options] inputFile [inputFile1...]`

Where `inputFile` is a C/C++ source file where the Gemix module dlecaration
code plus documentation comment blocks (JavaDoc/Doxygen like syntax) are expected.

Where options are :

* -h : Shows help
* -v : Shows version
* -o | --output : Output file. If it's ommited, then will be stdout.
* -a : Append to output file. Intead of overwriting, appends the generated
    documentation to the file.

Note, that moduleDoc accepts multiple module input files that will be procesed and
joined on the output.

## Example

```C
/*****************************************************************************
 **                 Lector de ficheros CSV para GEMIX                       **
 *****************************************************************************
 @name CSV MODULE
 @author bla bla bla
 */

#include "csv.h"

GMXDEFINE_LIBRARY_PROPERTIES(GMXEXT_mod_csv,
    /* CATEGORY */
    GMXDEFINE_PROPERTY_CATEGORY(GMXCATEGORY_GENERIC);
    /* SYSTEM */
    GMXDEFINE_PROPERTY_SYSTEM(GMXSYSTEM_COMMON);
);

GMXDEFINE_LIBRARY_EXPORTS(GMXEXT_mod_csv,
    GMXDEFINE_FUNCTIONS(
      /**
       * Lee un fichero CSV y carga el contenido en un array de Gemix
       * @param file Ruta al fichero
       * @param size Tamaño del array
       * @param pointer Puntero al array de Gemix. Si es NULL (0), lee el fichero CSV, pero no guarda los datos en ningun array.
       * @return Nº de elementos leidos en el CSV.
       */
      "CSV_ReadFileToArray(S,I,I8P)",   "I", 1, GMXEXT_CSV_readToInt8Array,
      "CSV_ReadFileToArray(S,I,UI8P)",  "I", 1, GMXEXT_CSV_readToUInt8Array,
      "CSV_ReadFileToArray(S,I,I16P)",  "I", 1, GMXEXT_CSV_readToInt16Array,
      "CSV_ReadFileToArray(S,I,UI16P)", "I", 1, GMXEXT_CSV_readToUInt16Array,
      "CSV_ReadFileToArray(S,I,I32P)",  "I", 1, GMXEXT_CSV_readToInt32Array,
      "CSV_ReadFileToArray(S,I,UI32P)", "I", 1, GMXEXT_CSV_readToUInt32Array,
      "CSV_ReadFileToArray(S,I,I64P)",  "I", 1, GMXEXT_CSV_readToInt64Array,
      "CSV_ReadFileToArray(S,I,UI64P)", "I", 1, GMXEXT_CSV_readToUInt64Array,
      "CSV_ReadFileToArray(S,I,FP)",    "I", 1, GMXEXT_CSV_readToFloatArray,
      "CSV_ReadFileToArray(S,I,DP)",    "I", 1, GMXEXT_CSV_readToDoubleArray
    );
);
```
Output :


## CSV MODULE

Category: Generic

System: Common

Lector de ficheros CSV para GEMIX

### Functions

#### `INT CSV_ReadFileToArray(STRING file, INT size, INT8* pointer)`


Lee un fichero CSV y carga el contenido en un array de Gemix


##### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| file	| STRING	| Ruta al fichero	|
| size	| INT	| Tamaño del array	|
| pointer	| INT8*	| Puntero al array de Gemix. Si es NULL (0), lee el fichero CSV, pero no guarda los datos en ningun array.	|

##### Return

INT
Nº de elementos leidos en el CSV.

##### Overloads

```gemix
INT CSV_ReadFileToArray(STRING file, INT size, UINT8* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, INT16* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, UINT16* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, INT32* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, UINT32* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, INT64* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, INT64* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, FLOAT* pointer)
```
```gemix
INT CSV_ReadFileToArray(STRING file, INT size, DOUBLE* pointer)
```






