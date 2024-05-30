

// Example code of the convolution driver for the ID1000500B core
/***************************************************************************/
#include <stdio.h>
#include <stdlib.h>
#include "id1000500b_conv_core.c"
/***************************************************************************/

/***************************************************************************/
/* DEFINITION OF PARAMETERS */

#define CONFIG_PATH "/home/pablo/convo_core/ID1000500B_config.csv"
#define USB_PORT    "/dev/ttyACM0"
#define SIZE_X      5
/***************************************************************************/

int main(void) 
{

/***************************************************************************/    
    // config init
    uint8_t nic_addr  = 1;
    uint8_t port = 0;

    // convolution process
    
    uint8_t dataX[SIZE_X] = {0x00, 0x01, 0x02, 0x03, 0x04};
    uint8_t sizeX = sizeof(dataX)/sizeof(dataX)[0];
    uint16_t result[AMOUNT_RESULT_MAX] = {0};
/***************************************************************************/

    // initialize the core
    id1000500b_init(USB_PORT, nic_addr, port, CONFIG_PATH);

    printf("\nData in mem_Y to be sent");
    printf("\nTX Data\n");
    for(uint32_t i=0; i<SIZE_X; i++){
        printf("%08X\n", dataX[i]);
    }

    // print the result before
    printf("\nresult Data before processing: [");
    for(int i=0; i<AMOUNT_RESULT_MAX; i++){
        printf("0x%08X", result[i]);
        if(i != AMOUNT_RESULT_MAX-1){
            printf(" , ");
        }
    }
    printf("]\n\n");

    // call the task to be executed
    conv(dataX, sizeX, result);

    printf("\n\nPress key to close ... ");
    return SUCCESS;

}
