`timescale 1ns/1ns

module ID1000500BTB();
            //----------------------------------------------------------
            //.......MANDATORY TB PARAMETERS............................
            //----------------------------------------------------------
localparam	CYCLE		 = 'd20, // Define the clock work cycle in ns (user)
            DATAWIDTH    = 'd32, // AIP BITWIDTH
            MAX_SIZE_MEM = 'd64, // MAX MEMORY SIZE AMONG ALL AIP MEMORIES (Defined by the user)
            //------------------------------------------------------------
            //..................CONFIG VALUES.............................
            //------------------------------------------------------------           
            STATUS    = 5'd30,//Mandatory config
            IP_ID     = 5'd31,//Mandatory config
			// Config values defined in the CSV file
			CONV_CORE = 'h1000500B,
			MEM_Y     = 'b00000,
			MEM_Z     = 'b00010,
			AEM_Y     = 'b00001,
			AEM_Z     = 'b00011, 
			CONFREG   = 'b00100, 
			AONFREG   = 'b00101, 
            //------------------------------------------------------------
            //..................PARAMETERS DEFINED BY THE USER............
            //------------------------------------------------------------
			SIZE_MEM     = 'd64, 
			INT_BIT_DONE = 'd0; 
			
localparam sizeY = 5'd5, 
		   sizeX = 5'd10,
           sizeZ = sizeX+sizeY-1;  

//AIP Interface signals
reg	readAIP;
reg	writeAIP;
reg	startAIP;
reg	[ 4:0]          configAIP;
reg	[DATAWIDTH-1:0] dataInAIP;

wire intAIP;
wire [DATAWIDTH-1:0] dataOutAIP;

reg clk, rst_a;  
reg en_s;

// Expected results signals
reg [5:0]  result_addr;
reg [15:0] data_result;

//Clock source procedural block
always #(CYCLE/2) clk = !clk;

//************ IP MODULE ***********
ID1000500B_conv
DUT
(
    .clk		(clk),
    .rst_a		(rst_a),
    .en_s		(en_s),
    .data_in	(dataInAIP),      //different data in information types
    .data_out	(dataOutAIP),     //different data out information types
    .write		(writeAIP),       //Used for protocol to write different information types
    .read		(readAIP),        //Used for protocol to read different information types
    .start		(startAIP),       //Used to start the IP core
    .conf_dbus	(configAIP),      //Used for protocol to determine different actions types
    .int_req	(intAIP)          //Interruption request
);

//************ EXPECTED RESULTS ***********
convolution_simple_rom_sv #(
	.DATA_WIDTH(16),
	.ADDR_WIDTH(6),
	.TXT_FILE("C:/Users/roset/Downloads/CUCEI/Semestre_4/CINVESTAV_SISTEMAS_EMBEBIDOS/Metodologia_Diseno_SystemOnChip/Convolucion/Memorias/memZ_2.txt")
)
MEM_EXPECTED_RESULTS
(
	.clk(clk),		
	.read_addr_i(result_addr),
	.read_data_o(data_result)	   
);

//**************** Testbench stimulus ****************
initial
   begin
      $display($time, " << Start Simulation >>");
      aipReset();  
      convolution_task();
      #(CYCLE*400);
      $display($time, " << End Simulation >>");
      $stop;      
   end

task convolution_task;
   //Auxiliar variables
   reg                 validation;
   reg [DATAWIDTH-1:0] tb_data;
   reg [31:0]          dataSet [31:0];
   reg [1023:0]        dataSet_packed;
   reg [31:0]          sample_result [63:0];
   reg [31:0]          result [63:0];
   reg [2047:0]        result_packed;
   
   integer i;
   begin
		// FILL OUT THE EXPECTED RESULT 
	    $display(" << Start Filling Expected Result >>");
		fill_expected_result(sample_result);
	    $display(" << End Filling Expected Result >>");
		
        // READ IP_ID
        getID(tb_data);
        $display ("%7T Read ID %h", $time, tb_data);
        
        // READ STATUS
        getStatus(tb_data);
        $display ("%7T Read STATUS %h", $time, tb_data);
        
        //FOR ENABLING INTERRUPTIONS 
        enableINT(INT_BIT_DONE);

        // RANDOM DATA GENERATION
        // for (i = 0; i < sizeY ; i=i+1) begin //generating random data
            // dataSet[i] = $urandom%100;          
        // end     
		
		// NO RANDOM DATA GENRATION
        for (i = 0; i < sizeY ; i=i+1) begin //generating random data
            dataSet[i] = i;          
        end     
		
        //**CONVERTION TO A SINGLE ARRAY
        for (i = 0; i < (32) ; i=i+1) begin 
            dataSet_packed[32*i+:32] = dataSet[i]; 
        end        
        
        writeMem(MEM_Y, dataSet_packed, 32,0);
        
        //CONFIGURATION reg
        tb_data[4:0] = sizeY; 
        tb_data[31:5] = 27'd0; 
        
        writeConfReg(CONFREG,tb_data,1,0); /// no seria 32 en vez de 1??

        // START PROCESS
        $display("%7T Sending start", $time);
        start();
        
        // WAIT FOR DONE FLAG WITH INTERRUPTIONS ENABLED     
        while (intAIP) begin//checking intAIP signal
            #(CYCLE*10);
        end
        
        $display("%7T Done flag detected!", $time);
        
        // READ STATUS
        getStatus(tb_data);
        $display ("%7T Read STATUS %h", $time, tb_data);
        
        //CLEAR INT DONE FLAG
        clearINT(INT_BIT_DONE);
        
        // READ STATUS
        getStatus(tb_data);
        $display ("%7T Read STATUS %h", $time, tb_data);     

        // READ MEM OUT
        readMem(MEM_Z, result_packed, 64, 0);
		
        //*CONVERTION TO A 2D ARRAY
        for (i = 0; i < (64) ; i=i+1) begin 
            result[i]= result_packed[32*i+:32]; 
        end
        		
        $display ("\t\tI \t\tO \t\tResult");
        for (i = 0; i < SIZE_MEM; i=i+1) begin
            //read_interface(MDATAOUT, tb_data);
            // $display ("Read data %2d \t%8h \t%8h \t%s", i, dataSet[i], result[i], (dataSet[i] === result[i] ? "OK": "ERROR"));
            $display ("Read data %2d \t%8h ", i, result[i]);
        end
        	
		// IS THE RESULT THE EXPECTED ONE?
		validation = 1'b1;
        for (i = 0; i < sizeZ; i=i+1) begin
            validation = validation && ((result[i] == sample_result[i])? 1'b1:1'b0);
        end		
		if(validation == 1'b1) $display ("The convolutioner WORKS FINE!");
		else 				   $display ("The convolutioner DOES NOT WORK");
		
        // DISABLE INTERRUPTIONS
        disableINT(INT_BIT_DONE);

        #(CYCLE*15);   
   end

endtask

task fill_expected_result;
   integer i;
   output reg [31:0] sample_result [63:0];
   begin   
		i = 0;
		while (i < (sizeZ)) begin 
			result_addr = i;
			#(CYCLE);
			sample_result[i] = {16'b0,data_result}; 
			i=i+1;
        end	
   end
endtask

//*******************************************************************
//AIP TASKS DEFINITION*************************
//*******************************************************************

task aipReset;
   begin
      clk		= 1'b1;
      en_s		= 1'b1;
      readAIP	= 1'b0;
      writeAIP	= 1'b0;
      startAIP	= 1'b0;
      configAIP= 5'd0;
      dataInAIP= 32'd0;
      
      rst_a		= 1'b0;	// reset is active
      #3 rst_a	= 1'b1;	// at time #n release reset
      #37;
   end
endtask


task getID;
   output [DATAWIDTH-1:0] read_ID;
      
      begin
         single_read(IP_ID,read_ID);
      end
endtask

task getStatus;
   output [DATAWIDTH-1:0] read_status;
      
      begin
         single_read(STATUS,read_status);
      end
endtask

task writeMem;
        input [                         4:0] config_value;
        input [(DATAWIDTH*MAX_SIZE_MEM)-1:0] write_data;
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;

      integer i;
        begin        
            //SET POINTER
            single_write(config_value+1, offset);
            
            //WRITE MEMORY
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin
               dataInAIP = write_data[(i*DATAWIDTH)+:DATAWIDTH];
               writeAIP = 1'b1;
               #(CYCLE);
            end
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask

task writeConfReg;
        input [                         4:0] config_value;
        input [(DATAWIDTH*MAX_SIZE_MEM)-1:0] write_data;
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;
        
        integer i;
        begin        
            //SET POINTER
            single_write(config_value+1, offset);
            
            //WRITE MEMORY
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin
               dataInAIP = write_data[(i*DATAWIDTH)+:DATAWIDTH];
               writeAIP = 1'b1;
               #(CYCLE);
            end
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask



task readMem;
        input [                         4:0] config_value;   
        output[(DATAWIDTH*MAX_SIZE_MEM)-1:0] read_data;     
        input [               DATAWIDTH-1:0] length;
        input [               DATAWIDTH-1:0] offset;        
        
        integer i;
        begin
            //SET POINTER
            single_write(config_value+1, offset);
        
            configAIP = config_value;
            #(CYCLE)
            for(i=0; i < length ; i= i+1) begin               
               readAIP = 1'b1;
               #(CYCLE);
               read_data[(i*DATAWIDTH)+:DATAWIDTH]=dataOutAIP;
            end
            readAIP = 1'b0;
            #(CYCLE);
        end
endtask

task enableINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] mask;
       
  begin

       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       mask[idxInt] = 1'b1; //enabling INT bit

       single_write(STATUS, {8'd0,mask,16'd0});//write status reg
  end
endtask

task disableINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] mask;
  begin
   
       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       mask[idxInt] = 1'b0; //disabling INT bit

       single_write(STATUS, {8'd0,mask,16'd0});//write status reg
  end
endtask

task clearINT;
      input [3:0] idxInt;   
      
       reg [DATAWIDTH-1:0] read_status;
       reg [7:0] clear_value;
       reg [7:0] mask;
    
  begin
    
       getStatus(read_status);
       
       mask = read_status[23:16]; //previous stored mask
       clear_value = 7'd1 <<  idxInt;

       single_write(STATUS, {8'd0,mask,8'd0,clear_value});//write status reg
  end
endtask

task start;
  begin
      startAIP = 1'b1;
      #(CYCLE);
      startAIP = 1'b0;
      #(CYCLE);
  end
endtask

task single_write;
        input [          4:0] config_value;
        input [DATAWIDTH-1:0] write_data;
        begin
            configAIP = config_value;
            dataInAIP = write_data;
            #(CYCLE)
            writeAIP = 1'b1;
            #(CYCLE)
            writeAIP = 1'b0;
            #(CYCLE);
        end
endtask

task single_read;
  input  [          4:0] config_value;
  output [DATAWIDTH-1:0] read_data;
  begin
      configAIP = config_value;
      #(CYCLE);
      readAIP = 1'b1;
      #(CYCLE);
      read_data = dataOutAIP;
      readAIP = 1'b0;
      #(CYCLE);
  end
endtask

endmodule