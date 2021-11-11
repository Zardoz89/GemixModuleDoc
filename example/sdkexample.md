SDK Example
-----------

Category: Generic

System: Common


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



### `INT sdk_swap(vec2* , vec2* )`


Swaps two values
   

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| vec2*	| 	|
| 	| vec2*	| 	|

#### Return

INT

#### Overloads

```gemix
INT sdk_swap(vec3* , vec3* )
```
```gemix
INT sdk_swap(vec4* , vec4* )
```


