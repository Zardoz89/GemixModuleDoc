/* Gemix Studio - Copyright (c) 2005-2013 Skygem Software. All rights reserved. */
/**
 * @name SDK Example
 **/
#include "sdkexample.h"

GMXDEFINE_LIBRARY_PROPERTIES(GMXEXT_mod_csv,
    GMXDEFINE_PROPERTY_CATEGORY(GMXCATEGORY_GENERIC);
    GMXDEFINE_PROPERTY_SYSTEM(GMXSYSTEM_COMMON);
);

/* The Module needs de math module to use Vector TYPE's */
GMXDEFINE_LIBRARY_DEPENDENCIES(GMXEXT_mod_sdkexample,
	"GMX_mod_math"
);

GMXDEFINE_LIBRARY_EXPORTS(GMXEXT_mod_sdkexample,
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

	/* FUNCTIONS */
	GMXDEFINE_FUNCTIONS(
	/**
	 * Returns the lower/minimal value from two values
	 * @param value1
	 * @param value2
	 */
	    "sdk_min(I,I)"                         , "F"           , 0, GMXEXT_sdkexample_sdk_min ,
      "sdk_min(F,F)"                         , "F"           , 0, GMXEXT_sdkexample_sdk_minF,
      "sdk_min(T(sdk_color),T(sdk_color))"   , "T(sdk_color)", 0, GMXEXT_sdkexample_sdk_minT,
      "sdk_copy(TP(sdk_color),TP(sdk_color))", "I"           , 0, GMXEXT_sdkexample_sdk_copy,
  /**
   * Swaps two values
   */
      "sdk_swap(TP(vec2),TP(vec2))"          , "I"           , 0, GMXEXT_sdkexample_sdk_swap_vec2,
      "sdk_swap(TP(vec3),TP(vec3))"          , "I"           , 0, GMXEXT_sdkexample_sdk_swap_vec3,
      "sdk_swap(TP(vec4),TP(vec4))"          , "I"           , 0, GMXEXT_sdkexample_sdk_swap_vec4
	);

	/* ENTRYPOINTS */
	GMXDEFINE_ENTRYPOINTS(GMX_init   , GMXEXT_mod_sdkexample_init,
	                      GMX_frame  , GMXEXT_mod_sdkexample_frame,
	                      GMX_release, GMXEXT_mod_sdkexample_release
	);
)

/* *** ENTRYPOINT *** */

// INIT
void GMXEXT_mod_sdkexample_init() {
	// initializing data...

	// we need to recover the address of the variable to access it
	sdk_normalize_colorchannels = GMXAPI_GlobalIntPtrOf("sdk_normalize_colorchannels");
}

// FRAME
void GMXEXT_mod_sdkexample_frame() {
	// data executed every FRAME

	// make sure that the variable is always 0 or 1 (modify phisically the value of the Gemix variable)
	if(GMXAPI_GlobalIntValueOf(sdk_normalize_colorchannels) < 0) {
		GMXAPI_GlobalIntValueOf(sdk_normalize_colorchannels) = 0;
	}
	else if(GMXAPI_GlobalIntValueOf(sdk_normalize_colorchannels) > 1) {
		GMXAPI_GlobalIntValueOf(sdk_normalize_colorchannels) = 1;
	}
}

// RELEASE
void GMXEXT_mod_sdkexample_release() {
	// nothing to do
}
