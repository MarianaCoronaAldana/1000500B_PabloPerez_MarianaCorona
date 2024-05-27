
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
static void set_parameters(int32_t *X, uint8_t sizeX);
static void run_convolution(void);
static void read_result(uint16_t *result);
static void stop_core(void);
/************************************************/

uint32_t conv(uint8_t *X, uint8_t sizeX, uint16_t *result){
    
    int32_t *dataX = (int32_t*) X;

    if(SUCCESS != check_if_valid_size(sizeX)){
        printf("\ninvalid size");
        return FAULT;
    }
    
    //begin the writing of the input data
    set_parameters(dataX,sizeX);
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

void set_parameters(int32_t *X, uint8_t sizeX){
    
    id1000500b_writeConfReg(sizeX);
    id1000500b_writeData(X,sizeX);
    
}

void run_convolution(void){
    
    id1000500b_startIP();
    id1000500b_waitINT();
    printf("\n\n Done detected \n\n");
    id1000500b_status(); // to tell if the core has done the convolution

}

void read_result(uint16_t *result){
    uint32_t *temp_result = (uint32_t*) result;
    id1000500b_readData(temp_result,AMOUNT_RESULT_MAX);

    // print the result
    printf("\nresult Data: [");
    for(int i=0; i<AMOUNT_RESULT_MAX; i++){
        printf("0x%08X", temp_result[i]);
        if(i != AMOUNT_RESULT_MAX-1){
            printf("\n, ");
        }
    }
    printf("]\n\n");

}

static void stop_core(void){
    id1000500b_finish();
}