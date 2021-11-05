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
      "CSV_ReadFileToArray(S,I,DP)",    "I", 1, GMXEXT_CSV_readToDoubleArray,
      /**
       * Lee un fichero CSV y carga el contenido en un array de Gemix
       *
       * Al leer el fichero, deja el cursor del fichero al final del mismo, o donde haya alcanzado el nº maximo de
       * elementos que puede leer sin desbordar el array.
       *
       * @param file Handler del fichero abierto en Gemix
       * @param size Tamaño del array
       * @param pointer Puntero al array de Gemix. Si es NULL (0), lee el fichero CSV, pero no guarda los datos en ningun array.
       * @return Nº de elementos leidos en el CSV.
       */
      "CSV_ReadToArray(F,I,I8P)",   "I", 1, GMXEXT_CSV_readToInt8Array,
      "CSV_ReadToArray(F,I,UI8P)",  "I", 1, GMXEXT_CSV_readToUInt8Array,
      "CSV_ReadToArray(F,I,I16P)",  "I", 1, GMXEXT_CSV_readToInt16Array,
      "CSV_ReadToArray(F,I,UI16P)", "I", 1, GMXEXT_CSV_readToUInt16Array,
      "CSV_ReadToArray(F,I,I32P)",  "I", 1, GMXEXT_CSV_readToInt32Array,
      "CSV_ReadToArray(F,I,UI32P)", "I", 1, GMXEXT_CSV_readToUInt32Array,
      "CSV_ReadToArray(F,I,I64P)",  "I", 1, GMXEXT_CSV_readToInt64Array,
      "CSV_ReadToArray(F,I,UI64P)", "I", 1, GMXEXT_CSV_readToUInt64Array,
      "CSV_ReadToArray(F,I,FP)",    "I", 1, GMXEXT_CSV_readToFloatArray,
      "CSV_ReadToArray(F,I,DP)",    "I", 1, GMXEXT_CSV_readToDoubleArray,
      );
    );
/* vim: set ts=2 sw=2 tw=0 et fileencoding=utf-8 :*/
