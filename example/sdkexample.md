SDK Example
-----------

Category: Generic

System: Common



Gemix Studio - Copyright (c) 2005-2013 Skygem Software. All rights reserved.
 

## Consts

 * `INT sdk_colorchannel_min = 0`
	
	Minimal valid value for a color channel
	
 * `INT sdk_colorchannel_max = 255`
 * `FLOAT sdk_colorchannel_min_normalized = 0.0f`
 * `FLOAT sdk_colorchannel_max_normalized = 1.0f`


## Types

### MyType

Members:

 * `INT8 r`
 * `INT8 g`
 * `INT8 b`
 * `INT16 a`

### OtherType

Members:

 * `INT8* ptr`
 * `INT size`

### sdk_color

Members:

 * `FLOAT r`
 * `FLOAT g`
 * `FLOAT b`
 * `FLOAT a`

 A type... 

### ComplexType

Members:

 * `sdk_color color`
 * `INT32 vec[3]`
 * `BOOL enabled`



## Functions

### `FLOAT sdk_min(INT value1, INT value2)`


Returns the lower/minimal value from two values



#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| value1	| INT	| 	|
| value2	| INT	| 	|

#### Return

FLOAT

#### Overloads

```gemix
FLOAT sdk_min(FLOAT value1, FLOAT value2)
```
```gemix
sdk_color sdk_min(sdk_color value1, sdk_color value2)
```


### `sdk_color min_sdk(sdk_color , sdk_color )`

**LEGACY**

Old way


#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| sdk_color	| 	|
| 	| sdk_color	| 	|

#### Return

sdk_color



### `INT sdk_copy(sdk_color* , sdk_color* )`

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| sdk_color*	| 	|
| 	| sdk_color*	| 	|

#### Return

INT



### `VOID sdk_swap(vec2* , vec2* )`


Swaps two values
   

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| vec2*	| 	|
| 	| vec2*	| 	|

#### Return

VOID

#### Overloads

```gemix
VOID sdk_swap(vec3* , vec3* )
```
```gemix
VOID sdk_swap(vec4* , vec4* )
```


### `VOID sdk_misc_fun(VOID* )`

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| VOID*	| 	|

#### Return

VOID

#### Overloads

```gemix
VOID sdk_misc_fun(Struct* )
```


