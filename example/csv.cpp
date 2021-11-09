/**
 * @name Modulo CSV
 */
#include "csv.h"

GMXDEFINE_LIBRARY_PROPERTIES(GMXEXT_mod_csv,
    GMXDEFINE_PROPERTY_CATEGORY(GMXCATEGORY_GENERIC);
    GMXDEFINE_PROPERTY_SYSTEM(GMXSYSTEM_COMMON);
);

GMXDEFINE_LIBRARY_EXPORTS(GMXEXT_mod_csv,
  /* CONSTS */
  GMXDEFINE_CONSTS_INT("sdk_colorchannel_min",   0,
                        "sdk_colorchannel_max", 255
  );
  GMXDEFINE_CONSTS_FLOAT("sdk_colorchannel_min_normalized", 0.0f,
                          "sdk_colorchannel_max_normalized", 1.0f
  );

  /* TYPES */
  GMXDEFINE_TYPES("type sdk_color "
                    "float r;"
                    "float g;"
                    "float b;"
                    "float a;"
                  "end "
  );

  /* GLOBALS */
  GMXDEFINE_GLOBALS("int sdk_normalize_colorchannels = 0;"
  );
  GMXDEFINE_FUNCTIONS(
    /**
     * Blabla bla
     *
     * @param filename Name/Path of the CSV file to open
     * @param size Size of the array
     * @param arrayPointer Pointer of the array where to write
     * @return number of readed elements on the CSV
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
    /** Read from opened file */
    "CSV_ReadToArray(I,I,I8P)",   "I", 1, GMXEXT_CSV_readToInt8Array,
    "CSV_ReadToArray(I,I,UI8P)",  "I", 1, GMXEXT_CSV_readToUInt8Array,
    "CSV_ReadToArray(I,I,I16P)",  "I", 1, GMXEXT_CSV_readToInt16Array,
    "CSV_ReadToArray(I,I,UI16P)", "I", 1, GMXEXT_CSV_readToUInt16Array,
    "CSV_ReadToArray(I,I,I32P)",  "I", 1, GMXEXT_CSV_readToInt32Array,
    "CSV_ReadToArray(I,I,UI32P)", "I", 1, GMXEXT_CSV_readToUInt32Array,
    "CSV_ReadToArray(I,I,I64P)",  "I", 1, GMXEXT_CSV_readToInt64Array,
    "CSV_ReadToArray(I,I,UI64P)", "I", 1, GMXEXT_CSV_readToUInt64Array,
    "CSV_ReadToArray(I,I,FP)",    "I", 1, GMXEXT_CSV_readToFloatArray,
    "CSV_ReadToArray(I,I,DP)",    "I", 1, GMXEXT_CSV_readToDoubleArray,

    /** Minimimize */
    "sdk_min(I,I)"                         , "F"           , 0, GMXEXT_sdkexample_sdk_min ,
    "sdk_min(F,F)", "F"           , 0, GMXEXT_sdkexample_sdk_minF,
    "sdk_min(T(sdk_color),T(sdk_color))"   , "T(sdk_color)", 0, GMXEXT_sdkexample_sdk_minT,
    /** Copy */
    "sdk_copy(TP(sdk_color),TP(sdk_color))", "I"           , 0, GMXEXT_sdkexample_sdk_copy,
    /** Swap */
    "sdk_swap(TP(vec2),TP(vec2))"          , "I"           , 0, GMXEXT_sdkexample_sdk_swap_vec2,
    "sdk_swap(TP(vec3),TP(vec3))"          , "I"           , 0, GMXEXT_sdkexample_sdk_swap_vec3,
    "sdk_swap(TP(vec4),TP(vec4))"          , "I"           , 0, GMXEXT_sdkexample_sdk_swap_vec4

    );
  );


