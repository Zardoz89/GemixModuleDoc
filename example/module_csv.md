Modulo CSV
----------

Category: Generic

System: Common


## Functions

### `INT CSV_ReadFileToArray(STRING filename, INT size, INT8* arrayPointer)`


Blabla bla

Name/Path of the CSV file to open
Size of the array
Pointer of the array where to write


#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| filename	| STRING	| 	|
| size	| INT	| 	|
| arrayPointer	| INT8*	| 	|

#### Return

INT
number of readed elements on the CSV

#### Overloads

```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, UINT8* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, INT16* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, UINT16* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, INT32* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, UINT32* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, INT64* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, INT64* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, FLOAT* arrayPointer)
```
```gemix
INT CSV_ReadFileToArray(STRING filename, INT size, DOUBLE* arrayPointer)
```


### `INT CSV_ReadToArray(INT , INT , INT8* )`

 Read from opened file 

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| INT	| 	|
| 	| INT	| 	|
| 	| INT8*	| 	|

#### Return

INT

#### Overloads

```gemix
INT CSV_ReadToArray(INT , INT , UINT8* )
```
```gemix
INT CSV_ReadToArray(INT , INT , INT16* )
```
```gemix
INT CSV_ReadToArray(INT , INT , UINT16* )
```
```gemix
INT CSV_ReadToArray(INT , INT , INT32* )
```
```gemix
INT CSV_ReadToArray(INT , INT , UINT32* )
```
```gemix
INT CSV_ReadToArray(INT , INT , INT64* )
```
```gemix
INT CSV_ReadToArray(INT , INT , INT64* )
```
```gemix
INT CSV_ReadToArray(INT , INT , FLOAT* )
```
```gemix
INT CSV_ReadToArray(INT , INT , DOUBLE* )
```


### `FLOAT sdk_min(INT , INT )`

 Minimimize 

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| INT	| 	|
| 	| INT	| 	|

#### Return

FLOAT

#### Overloads

```gemix
FLOAT sdk_min(FLOAT , FLOAT )
```
```gemix
sdk_color sdk_min(sdk_color , sdk_color )
```


### `INT sdk_copy(sdk_color* , sdk_color* )`

 Copy 

#### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| 	| sdk_color*	| 	|
| 	| sdk_color*	| 	|

#### Return

INT



### `INT sdk_swap(vec2* , vec2* )`

 Swap 

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


