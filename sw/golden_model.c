#include <stdio.h>
#include <stdlib.h>
#include <string.h>
//#include <svdpi.h>

/*CONSTANTES DEL ARCHIVO*/
#define TAM_NOMBRE_ARCHIVO 100
/// cambiar nombre de archivos
#define NOMBRE_ARCHIVO_MEMX "memX_2.txt"
#define NOMBRE_ARCHIVO_MEMY "memY_2.txt"
#define NOMBRE_ARCHIVO_MEMZ "memZ_2.txt"
/// cambiar ubicacion de archivo
#define UBICACION_ARCHIVO "../Memorias/"

/*MEMORIAS*/
///cambiar tamaños de memorias
#define SIZE_X 10
#define SIZE_Y 5
#define SIZE_Z SIZE_X+SIZE_Y-1

//extern "C" void convolucion();
void convolucion();
void lee_archivo(FILE* archivo, int nums [], int cantidad);
int guarda_liga(FILE* archivo, int nums [], int cantidad);

int main()
{
    convolucion();
    return 0;
}

//extern "C" void convolucion(){
void convolucion(){
    FILE* archivo = NULL;
    char nombreArchivoMemX[TAM_NOMBRE_ARCHIVO] = {},
         nombreArchivoMemY[TAM_NOMBRE_ARCHIVO] = {},
         nombreArchivoMemZ[TAM_NOMBRE_ARCHIVO] = {};

    int x [SIZE_X], y [SIZE_Y], z [SIZE_Z];
    int memY_addr=0, memZ_addr=0, romX_addr=0;
    int dataZ_temp;
    int aux = 0;

    sprintf(nombreArchivoMemX, "%s%s", UBICACION_ARCHIVO, NOMBRE_ARCHIVO_MEMX);
    sprintf(nombreArchivoMemY, "%s%s", UBICACION_ARCHIVO, NOMBRE_ARCHIVO_MEMY);
    sprintf(nombreArchivoMemZ, "%s%s", UBICACION_ARCHIVO, NOMBRE_ARCHIVO_MEMZ);
    archivo=fopen(nombreArchivoMemX, "r");
    lee_archivo(archivo, x, SIZE_X);
    archivo=fopen(nombreArchivoMemY, "r");
    lee_archivo(archivo, y, SIZE_Y);

    while (romX_addr<SIZE_Z){
        dataZ_temp=0;
        memY_addr=0;

        while (memY_addr<SIZE_Y){
            aux = romX_addr - memY_addr;
            if (aux>=0 && aux<SIZE_X)
                dataZ_temp+=y[memY_addr]*x[aux];
            memY_addr=memY_addr+1;
        }

        memZ_addr=romX_addr;
        z[memZ_addr]=dataZ_temp;
        romX_addr=romX_addr+1;
    }

    archivo=fopen(nombreArchivoMemZ, "w");
    guarda_liga(archivo, z, SIZE_Z);
    fclose(archivo);
    printf("\nTerminado.\n");
}

void lee_archivo(FILE* archivo, int nums [], int cantidad){
    //revisar si archivo esta abierto
    if(archivo==NULL){
        perror("El archivo no esta abierto para leer");
    }
    for(int i = 0; i<cantidad; i++)
        fscanf (archivo, "%X", &nums[i]);
}

int guarda_liga(FILE* archivo, int nums [], int cantidad){
    int resultado=1;
    //revisar si archivo esta abierto
    if(archivo==NULL){
        perror("El archivo no esta abierto para guardar");
        return 0;
    }
    for(int i = 0; i<cantidad; i++)
        fprintf (archivo, "%X\n", nums[i]);
    return resultado;
}
