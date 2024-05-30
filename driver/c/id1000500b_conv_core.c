
#include "id100500b_conv_core.h"
#include "id1000500b.h"
#include <stdio.h>

/* DEFINIITONS */
#define MAX_AMOUNT          32
#define AMOUNT_RESULT_MAX   64
#define FAULT               -1
#define SUCCESS             0

/* PRIVATES */
static int32_t check_if_valid_size(uint8_t sizeX);
static void set_parameters(uint8_t *X, uint8_t sizeX);
static void run_convolution(void);
static void read_result(uint16_t *result);
static void stop_core(void);
/************************************************/

uint32_t conv(uint8_t *X, uint8_t sizeX, uint16_t *result){
    
    //int32_t *dataX = (int32_t*) X;

    if(SUCCESS != check_if_valid_size(sizeX)){
        printf("\ninvalid size");
        return FAULT;
    }
    
    //begin the writing of the input data
    set_parameters(X,sizeX);
    printf("Size of Y: is %08X\n ", sizeX);
    run_convolution();
    read_result(result);
    stop_core();
    return SUCCESS;
}


/* PRIVATE FUNCITON DECLARATION */
int32_t check_if_valid_size(uint8_t sizeX){

    if(!(sizeX > 0) && (sizeX > MAX_AMOUNT)){
        return FAULT;
    }
    else{
        return SUCCESS;
    }

    
}

static void set_parameters(uint8_t *X, uint8_t sizeX){
    
    uint32_t sizeX_32b      = (uint32_t) sizeX;
    uint32_t dataX_32b[32];

    /* Lets initialize the 32 bit data long array with X values */
    for(int i = 0; i < sizeX_32b; i++){
        dataX_32b[i] = X[i];
    }

    id1000500b_writeConfReg(sizeX);
    id1000500b_writeData(dataX_32b,sizeX);
    
}

void run_convolution(void){
    
    id1000500b_startIP();
    id1000500b_waitINT();
    printf("\n\n Done detected \n\n");
    id1000500b_status(); // to tell if the core has done the convolution

}

void read_result(uint16_t *result){
    
    uint32_t result_32b[AMOUNT_RESULT_MAX] = {0};

    id1000500b_readData(result_32b,AMOUNT_RESULT_MAX);

    //give the calculated values to the output
    for(int i=0; i<AMOUNT_RESULT_MAX; i++){
        
        /* give original array the values calculated */    
        result[i] = result_32b[i];
              
    }
    printf("]\n\n");

}

static void stop_core(void){
    id1000500b_finish();
}