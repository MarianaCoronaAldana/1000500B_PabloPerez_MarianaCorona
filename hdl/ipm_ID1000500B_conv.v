// ipm <-> ID1000500B_conv


module ipm_ID1000500B_conv
(
    // Main
    input clk,
    input rst,
    
    // MCU
    input [3:0] addressMCU,
    input rstMCU,
    input rdMCU,
    input wrMCU,
    inout [7:0] dataMCU,
    output intMCU
);

    localparam CONF_WIDTH = 5,
               DATA_WIDTH = 32;

    wire wireReset;
    wire [DATA_WIDTH-1:0] wireDataIPtoMCU;
    wire [DATA_WIDTH-1:0] wireDataMCUtoIP;
    wire [CONF_WIDTH-1:0] wireConf;
    wire wireReadIP;
    wire wireWriteIP;
    wire wireStartIP;
    wire wireINT;	 
   
    assign wireReset = rst & rstMCU;

    ipm IPM
    (
        .clk_n_Hz (clk),
        .ipm_RstIn (wireReset),
        
        // MCU
        .ipmMCUDataInout (dataMCU),
        .ipmMCUAddrsIn (addressMCU),
        .ipmMCURdIn (rdMCU),
        .ipmMCUWrIn (wrMCU),
        .ipmMCUINTOut (intMCU),
        
        // IP
        .ipmPIPDataIn (wireDataIPtoMCU),
        .ipmPIPConfOut (wireConf),
        .ipmPIPReadOut (wireReadIP),
        .ipmPIPWriteOut (wireWriteIP),
        .ipmPIPStartOut (wireStartIP),
        .ipmPIPDataOut (wireDataMCUtoIP),
        .ipmPIPINTIn (wireINT)
    );

    ID1000500B_conv IP_CORE
    (
        .clk (clk),
        .rst_a (wireReset),
        .en_s (1'b1),

        .data_in   (wireDataMCUtoIP),
        .data_out  (wireDataIPtoMCU),
        .write     (wireWriteIP),
        .read      (wireReadIP),
        .start     (wireStartIP),
        .conf_dbus (wireConf),
        .int_req   (wireINT)

    );

endmodule