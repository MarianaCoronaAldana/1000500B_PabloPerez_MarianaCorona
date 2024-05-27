#ifndef _ID1000500B_H__
#define _ID1000500B_H__

#include <stdint.h>

/** Global variables declaration (public) */
/* These variables must be declared "extern" to avoid repetitions. They are defined in the .c file*/
/******************************************/

/** Public functions declaration */

/* Driver initialization*/
int32_t id1000500b_init(const char *connector, uint8_t nic_addr, uint8_t port, const char *csv_file);

/* Write data*/
int32_t id1000500b_writeData(uint32_t *data, uint32_t dataSize);

/* Write the length of the input array */
int32_t id1000500b_writeConfReg(uint32_t sizeX);

/* Read data*/
int32_t id1000500b_readData(uint32_t *data, uint32_t dataSize);

/* Start processing*/
int32_t id1000500b_startIP(void);

/* Enable interruption notification "Done"*/
int32_t id1000500b_enableINT(void);

/* Disable interruption notification "Done"*/
int32_t id1000500b_disableINT(void);

/* Show status*/
int32_t id1000500b_status(void);

/* Wait interruption*/
int32_t id1000500b_waitINT(void);

/* Finish*/
int32_t id1000500b_finish(void);


#endif // _ID1000500B_H__