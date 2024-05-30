import logging, time
from ipdi.ip.pyaip import pyaip, pyaip_init
import sys

## IP Convolution driver class
class convolution:
    ## Class constructor of IP Convolution driver
    #
    # @param self Object pointer
    # @param targetConn Middleware object
    # @param config Dictionary with IP Convolution configs
    # @param addrs Network address IP
    def __init__(self, connector, nic_addr, port, csv_file):
        ## Pyaip object
        self.__pyaip = pyaip_init(connector, nic_addr, port, csv_file)
        if self.__pyaip is None:
            logging.debug("error")
        ## Array of strings with information read
        self.__pyaip.reset()
        self.dataRX = []
        ## IP Convolution IP-ID
        self.IPID = 0
        self.__getID()
        self.__clearStatus()
        logging.debug(f"IP Convolution controller created with IP ID {self.IPID:08x}")

    ## Convolution Process
    #
    # @param self Object pointer
    # @param Y    Array of data to put in memory Y
    def conv(self, memY):          
        # Enable interruptions
        # self.__enableINT()
        # Write Conf Reg with size of memory Y
        self.__writeSizeY(len(memY))
        # Write memory: MEM_Y
        self.__writeData(memY)
        # Start IP
        self.__startIP()
        # Show status
        self.__status()
        # Clear Interrups
        #self.__disableINT()
        # Wait for Done Flag
        self.__waitInt()
        print('end waiting')
        # Read memory: MEM_Z
        memZ = self.__readData(64)
        # Clear flags
        self.__clearStatus()           
        # Show status
        self.__status()
        
        return memZ

    ## Set size of memory Y in IP Convolution processing
    #
    # @param self Object pointer
    # @param sizeY size of memory Y
    def __writeSizeY(self, sizeY):

        parameter = []
        parameter.append(sizeY)
        self.__pyaip.writeConfReg('CONFREG', parameter, 1, 0)
        logging.debug(f"Confreg setted to {sizeY}")
        
    ## Write data in the IP Convolution input memory
    #
    # @param self Object pointer
    # @param data String array with the data to write
    def __writeData(self, data):
        self.__pyaip.writeMem('MEM_Y', data, len(data), 0)
        logging.debug("Data captured in MEM_Y")
        print('Write memory: MEM_Y')
        print(f'memY Data: {[f"{x:08X}" for x in memY]}\n')        

    ## Start processing in IP Convolution
    #
    # @param self Object pointer
    def __startIP(self):
        print('startIP')
        self.__pyaip.start()
        logging.debug("Start sent")
    
    ## Wait for the completion of the process
    #
    # @param self Object pointer
    def __waitInt(self):
        print('Waiting')
        waiting = True        
        while waiting:
            status = self.__pyaip.getStatus()
            ##print('Status: ', status)
            logging.debug(f"status {status:08x}")            
            if status & 0x1:
                waiting = False            
            time.sleep(0.1)
    
    ## Read data from the IP Convolution output memory
    #
    # @param self Object pointer
    # @param size Amount of data to read
    def __readData(self, size):
        data = self.__pyaip.readMem('MEM_Z', size, 0)
        logging.debug("Data obtained from MemZ")
        print(f'result Data: {[f"{x:08X}" for x in data]}\n')
        return data   
    
    ## Show IP Convolution STATUS
    #
    # @param self Object pointer
    def __status(self):
        print('here status')
        status = self.__pyaip.getStatus()
        logging.info(f"{status:08x}")   
    
    ## Clear status register of IP Convolution
    #
    # @param self Object pointer
    def __clearStatus(self):
        for i in range(8):
            self.__pyaip.clearINT(i)

    ## Enable IP Convolution interruptions
    #
    # @param self Object pointer
    def __enableINT(self):
        self.__pyaip.enableINT(0,None)
        logging.debug("Int enabled")

    ## Disable IP Convolution interruptions
    #
    # @param self Object pointer
    def __disableINT(self):
        self.__pyaip.disableINT(0)

        logging.debug("Int disabled")  

    ## Get IP ID
    #
    # @param self Object pointer
    def __getID(self):
        self.IPID = self.__pyaip.getID()

    ## Finish connection
    #
    # @param self Object pointer
    def finish(self):
        self.__pyaip.finish()           
        
if __name__=="__main__":
    import sys, random, time, os
    logging.basicConfig(level=logging.DEBUG)

    aip_mem_size = 8
    size_mem_y   = 5
    connector = '/dev/ttyACM0'
    nic_addr = 1
    port = 0
    csv_file = '/home/pablo/convo_core/ID1000500B_config.csv'
    convolutioner = 0

    try:       
        convolutioner = convolution(connector, nic_addr, port, csv_file)
        ##convolutioner.reset()
    except:
        e = sys.exc_info()
        print('ERROR: ', e)
    
    #==========================================
    #random.seed(64)
    #memY = [random.randrange(2 ** 8) for i in range(0, size_mem_y)]
    memY = [ 0, 1, 2, 3, 4]
    memZ = convolutioner.conv(memY)
    convolutioner.finish()
    logging.info("DONE!")

    # ID = convolutioner.getID()
    # print(f'Read ID: {ID:08X}\n')
    
    
    # sizeY = [0x00000005]
    # print('Write configuration register: CONFREG')
    # convolutioner.writeConfReg('CONFREG', sizeY, 1, 0)
    # print(f'sizeY Data: {[f"{x:08X}" for x in sizeY]}\n')
    
    # memY = [random.randrange(2 ** 32) for i in range(0, aip_mem_size)]
    # convolutioner.writeData(memY)
   
    

    # memY = [0x00000000, 0x00000001, 0x00000002, 0x00000003, 0x00000004]

    # print('Write memory: MEM_Y')
    # convolutioner.writeMem('MEM_Y', memY, 5, 0)
    # print(f'memY Data: {[f"{x:08X}" for x in memY]}\n')

    # print('Start IP\n')
    # convolutioner.start()

    # STATUS = convolutioner.getStatus()
    # print(f'Read STATUS: {STATUS:08X}\n')

    # print('Read memory: MEM_Z')
    # result = convolutioner.readMem('MEM_Z', 63, 0)
    # print(f'result Data: {[f"{x:08X}" for x in result]}\n')

    # print('Clear INT: 0')
    # convolutioner.clearINT(0)

    # STATUS = convolutioner.getStatus()
    # print(f'Read STATUS: {STATUS:08X}\n')

    #==========================================

    # convolutioner.finish()


    # convolutioner.finish()
        
