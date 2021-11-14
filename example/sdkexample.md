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

#### Members

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| r                 | INT8        |                                      |
| g                 | INT8        |                                      |
| b                 | INT8        |                                      |
| a                 | INT16       |                                      |

### OtherType

#### Members

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| ptr               | INT8*       |                                      |
| size              | INT         |                                      |

### sdk_color

 A type... 

#### Members

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| r                 | FLOAT       |                                      |
| g                 | FLOAT       |                                      |
| b                 | FLOAT       |                                      |
| a                 | FLOAT       |                                      |

### ComplexType

#### Members

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| color             | sdk_color   |                                      |
| vec[3]            | INT32       |                                      |
| enabled           | BOOL        |                                      |



## Functions

### `FLOAT sdk_min(INT value1, INT value2)`


Returns the lower/minimal value from two values



#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| value1            | INT         | A value                              |
| value2            | INT         |                                      |

#### Return

`FLOAT` the minimal/lowest value from value1 and value2

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
|                   | sdk_color   |                                      |
|                   | sdk_color   |                                      |

#### Return

`sdk_color`



### `INT sdk_copy(sdk_color* , sdk_color* )`

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
|                   | sdk_color*  |                                      |
|                   | sdk_color*  |                                      |

#### Return

`INT`



### `VOID sdk_swap(vec2* vectorA, vec2* vectorB)`


Swaps two values


#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| vectorA           | vec2*       | the first vector                     |
| vectorB           | vec2*       | the second vector                    |

#### Return

`VOID`

#### Overloads

```gemix
VOID sdk_swap(vec3* vectorA, vec3* vectorB)
```
```gemix
VOID sdk_swap(vec4* vectorA, vec4* vectorB)
```


### `VOID sdk_misc_fun(VOID* )`

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
|                   | VOID*       |                                      |

#### Return

`VOID`

#### Overloads

```gemix
VOID sdk_misc_fun(Struct* )
```


