#include <stdio.h>
#include <stdbool.h>
#include "id1000500b.h"
#include "caip.h"

#ifdef _WIN32
#include <windows.h>
#else
#include <unistd.h>
#endif // _WIN32

/** DEFINITIONS*/
#define SUCCESS     0
#define FAULT       -1

#define INT_DONE    0
#define ONE_FLIT    1
#define ZERO_OFFSET 0
#define STATUS_BITS 8
#define INT_DONE_BIT    0x00000001

/** Global variables declaration (private) */
caip_t      *id1000500b_aip;
uint32_t    id1000500b_id = 0;
/***********************************************************************/
static uint32_t id1000500b_getID(uint32_t  *id);
static uint32_t id1000500b_clearStatus(void);



/***********************************************************************/

/* Initializes the aip to run */
int32_t id1000500b_init(const char *connector, uint8_t nic_addr, uint8_t port, const char *csv_file){
    
    id1000500b_aip = caip_init(connector, nic_addr, port, csv_file);

    if(id1000500b_aip == NULL){
        printf("CAIP Object not created");
        return FAULT;
    }
    id1000500b_aip->reset();

    id1000500b_getID(&id1000500b_id);
    id1000500b_clearStatus();

    printf("\nIP Convolution Core controller created with IP ID: %08X\n\n", id1000500b_id);
    return SUCCESS;
}

// WRITE DATA
int32_t id1000500b_writeData(uint32_t *data, uint32_t dataSize){

    //El mnemonico del primer parametro debe coincidir con nuestro csv_file de configuracion
    id1000500b_aip->writeMem("MEM_Y", data, dataSize, ZERO_OFFSET);
    return SUCCESS;
}

/* Write the length of the input array */
int32_t id1000500b_writeConfReg(uint32_t sizeX){
    
    id1000500b_aip->writeConfReg("CONFREG", &sizeX, ONE_FLIT, ZERO_OFFSET);
    return SUCCESS;
}

/* Read data*/
int32_t id1000500b_readData(uint32_t *data, uint32_t data_size)
{
    
    id1000500b_aip->readMem("MEM_Z", data, data_size, ZERO_OFFSET);
    return SUCCESS;
}

/* Start processing*/
int32_t id1000500b_startIP(void){

    id1000500b_aip->start();
    return SUCCESS;

}

/* Enable interruption notification "Done"*/
int32_t id1000500b_enableINT(void)
{
    id1000500b_aip->enableINT(INT_DONE, NULL);
    printf("\nINT Done enabled");
    return SUCCESS;
}

/* Disable interruption notification "Done"*/
int32_t id1000500b_disableINT(void)
{
    id1000500b_aip->disableINT(INT_DONE);
    printf("\nINT Done disabled");
    return SUCCESS;
}

/* Show status*/
int32_t id1000500b_status(void)
{
    uint32_t status;
    id1000500b_aip->getStatus(&status);
    printf("\nStatus: %08X",status);
    return SUCCESS;
}

/* Wait interruption*/
int32_t id1000500b_waitINT(void)
{
    bool waiting = true;
    uint32_t status;

    while(waiting)
    {
        id1000500b_aip->getStatus(&status);

        if((status & INT_DONE_BIT)>0)
            waiting = false;

        #ifdef _WIN32
        Sleep(500); // ms
        #else
        sleep(0.1); // segs
        #endif
    }

    id1000500b_aip->clearINT(INT_DONE);

    return 0;
}

/* Finish*/
int32_t id1000500b_finish(void)
{
    id1000500b_aip->finish();
    return SUCCESS;
}

//PRIVATE FUNCTIONS
uint32_t id1000500b_getID(uint32_t *id)
{
    id1000500b_aip->getID(id);

    return 0;
}

uint32_t id1000500b_clearStatus(void)
{
    for(uint8_t i = 0; i < STATUS_BITS; i++)
        id1000500b_aip->clearINT(i);

    return 0;
}