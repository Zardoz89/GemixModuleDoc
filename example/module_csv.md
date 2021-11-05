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
#### `INT CSV_ReadToArray(FLOAT file, INT size, INT8* pointer)`


Lee un fichero CSV y carga el contenido en un array de Gemix

Al leer el fichero, deja el cursor del fichero al final del mismo, o donde haya alcanzado el nº maximo de
elementos que puede leer sin desbordar el array.



##### Parameters

| Name              | Type        |                                      |
|-------------------|-------------|--------------------------------------|
| file	| FLOAT	| Handler del fichero abierto en Gemix	|
| size	| INT	| Tamaño del array	|
| pointer	| INT8*	| Puntero al array de Gemix. Si es NULL (0), lee el fichero CSV, pero no guarda los datos en ningun array.	|

##### Return

INT
Nº de elementos leidos en el CSV.

##### Overloads

```gemix
INT CSV_ReadToArray(FLOAT file, INT size, UINT8* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, INT16* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, UINT16* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, INT32* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, UINT32* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, INT64* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, INT64* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, FLOAT* pointer)
```
```gemix
INT CSV_ReadToArray(FLOAT file, INT size, DOUBLE* pointer)
```
