#include <stdio.h>
#include <stdlib.h>
#include <time.h>
#include <math.h>

/*CONSTANTES DEL ARCHIVO*/
#define TAM_NOMBRE_ARCHIVO 100
/// cambiar el nombre de archivo
#define NOMBRE_ARCHIVO "memX_3"
/// cambiar terminacion archivo (txt o ipd)
#define TIPO_ARCHIVO ".txt"
/// cambiar ubicacion de archivo
#define UBICACION_ARCHIVO "../../Memorias/"

/*CONSTANTES DE LA MEMORIA*/
/// cambiar cantidad de registros
#define CANTIDAD_REG 10
/// cambiar el numero de bits que tendra la salida
#define CANTIDAD_BITS 8

void guarda_num(int num, FILE* archivo);

int main()
{
    FILE* archivo = NULL;
    char nombreArchivo[TAM_NOMBRE_ARCHIVO] = {};
    sprintf(nombreArchivo, "%s%s%s", UBICACION_ARCHIVO, NOMBRE_ARCHIVO, TIPO_ARCHIVO);

    srand(time(NULL));
    archivo=fopen(nombreArchivo, "wb");

    printf("[");
    for(int i=0;i<CANTIDAD_REG; i++){
        guarda_num((int) rand()%((int) pow(2,CANTIDAD_BITS)), archivo);
    }
    printf("]\n");

    fclose(archivo);
    return 0;
}

void guarda_num(int num, FILE* archivo){
    int i = 1, j, temp;
    char car[4];
    char espacio='\n';

    while (num != 0) {
        temp = num % 16;
        if (temp < 10)
            temp = temp + 48;
        else
            temp = temp + 55;
        car[i++] = temp;
        num = num / 16;
    }

    if(archivo==NULL){
        perror("El archivo no esta abierto para guardar");
    }
    for(j = i-1; j>0; j-- ){
        printf("%c", car[j]);
        if(!fwrite(&(car[j]), sizeof(char), 1, archivo))
           printf("\nNo se pudo guardar el dato\n");
    }
    printf(" ");
    fwrite(&(espacio), sizeof(char), 1, archivo);
}
