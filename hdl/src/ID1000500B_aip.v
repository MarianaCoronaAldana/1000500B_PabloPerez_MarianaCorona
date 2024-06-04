`define ID1000500B_MEM_IN 1

`define ID1000500B_MEM_OUT 1

`define ID1000500B_CONF_REG 1


// `define ID1000500B_STREAMING_IN
// `define ID1000500B_STREAMING_OUT

module ID1000500B_aip
(
  clk,
  rst,
  en,

  //--- AIP ---//
  dataInAIP,
  dataOutAIP,
  configAIP,
  readAIP,
  writeAIP,
  startAIP,
  intAIP,

  //--- IP-core ---//
  rdDataMemIn_0,

rdAddrMemIn_0,


  wrDataMemOut_0,

wrAddrMemOut_0,

wrEnMemOut_0,


  rdDataConfigReg,
  

  

  statusIPcore_Busy,

intIPCore_Done,


  startIPcore
);

  localparam DATA_WIDTH = 32;

  localparam MEM_ADDR_MAX_WIDTH = 16;

  localparam CONFIG_WIDTH = 5;

  localparam STATUS_WIDTH = 8;

  localparam CONF_REG_SIZE = 1;

  input clk;
  input rst;
  input en;

  //--- AIP ---//
  input [DATA_WIDTH-1:0] dataInAIP;
  output [DATA_WIDTH-1:0] dataOutAIP;
  input [CONFIG_WIDTH-1:0] configAIP;
  input readAIP;
  input writeAIP;
  input startAIP;
  output intAIP;

  //--- IP-core ---//
  output wire [DATA_WIDTH-1:0] rdDataMemIn_0;
input wire [MEM_ADDR_MAX_WIDTH-1:0] rdAddrMemIn_0;

  input [DATA_WIDTH-1:0] wrDataMemOut_0;
input [MEM_ADDR_MAX_WIDTH-1:0] wrAddrMemOut_0;
input wrEnMemOut_0;

  output [(CONF_REG_SIZE*DATA_WIDTH)-1:0] rdDataConfigReg;
  
  
  input statusIPcore_Busy;
input intIPCore_Done;


  output startIPcore;

  ID1000500B_aipModules AIP
  (
    .clk (clk),
    .rst (rst),
    .en (en),

    //--- AIP ---//
    .configAIP (configAIP),
    .readAIP (readAIP),
    .writeAIP (writeAIP),
    .startAIP (startAIP),
    .dataInAIP (dataInAIP),
    .dataOutAIP (dataOutAIP),
    .intAIP (intAIP),

    //--- IP-core ---//
    .rdDataMemIn({rdDataMemIn_0}),

    .rdAddrMemIn({rdAddrMemIn_0}),

    .wrDataMemOut({wrDataMemOut_0}),

    .wrAddrMemOut({wrAddrMemOut_0}),

    .wrEnMemOut({wrEnMemOut_0}),

    .rdDataConfigReg(rdDataConfigReg),
    
    
    .statusIPcore({7'b0,statusIPcore_Busy}),

    .intIPCore({7'b0,intIPCore_Done}),


    .startIPcore (startIPcore)
  );

endmodule

module ID1000500B_aipModules
(
  clk,
  rst,
  en,

  //--- AIP ---//
  configAIP,
  readAIP,
  writeAIP,
  startAIP,
  dataInAIP,
  dataOutAIP,
  intAIP,

  //--- IP-core ---//
  `ifdef ID1000500B_MEM_IN
  rdDataMemIn,
  rdAddrMemIn,
  `elsif ID1000500B_STREAMING_IN
  rdDataMemIn,
  rdAddrMemIn,
  `endif

  `ifdef ID1000500B_MEM_OUT
  wrDataMemOut,
  wrAddrMemOut,
  wrEnMemOut,
  `elsif ID1000500B_STREAMING_OUT
  wrDataMemOut,
  wrEnMemOut,
  `endif

  `ifdef ID1000500B_CONF_REG
  rdDataConfigReg,
  `endif

  `ifdef ID1000500B_STREAMING_IN
  dataInStreaming,
  startStreaming,
  wrInStreaming,
  `endif

  `ifdef ID1000500B_STREAMING_OUT
  dataOutStreaming,
  doneStreaming,
  wrOutStreaming,
  `endif

  statusIPcore,
  intIPCore,

  startIPcore
);

  localparam IP_ID = 32'h1000500B;

  localparam SEL_BITS = 'd2;

  localparam DATA_WIDTH = 32;

  localparam MEM_ADDR_MAX_WIDTH = 16;

  localparam CONF_REG_ADDR_MAX_WIDTH = 3;

  localparam CONFIG_WIDTH = 5;

  localparam STATUS_WIDTH = 8;

  `ifdef ID1000500B_MEM_IN
  localparam [(`ID1000500B_MEM_IN*MEM_ADDR_MAX_WIDTH)-1:0] MEM_IN_ADDR_WIDTH = { 16'd5 };

  localparam [((`ID1000500B_MEM_IN*2)*CONFIG_WIDTH)-1:0] CONFIG_MEM_IN = { 5'b00001, 5'b00000 };
  `endif

  `ifdef ID1000500B_MEM_OUT
  localparam [(`ID1000500B_MEM_OUT*MEM_ADDR_MAX_WIDTH)-1:0] MEM_OUT_ADDR_WIDTH = { 16'd6 };

  localparam [((`ID1000500B_MEM_OUT*2)*CONFIG_WIDTH)-1:0] CONFIG_MEM_OUT = { 5'b00011, 5'b00010 };
  `endif

  `ifdef ID1000500B_CONF_REG
  localparam [(`ID1000500B_CONF_REG*CONF_REG_ADDR_MAX_WIDTH)-1:0] CONF_REG_ADDR_WIDTH = { 3'd1 };

  localparam [(2*CONFIG_WIDTH)-1:0] CONFIG_CONF_REG = { 5'b00101, 5'b00100 };
  `endif

  `ifdef ID1000500B_STREAMING_IN
  localparam [MEM_ADDR_MAX_WIDTH-1:0] MEM_IN_STREAMING_ADDR_WIDTH = {  };
  `endif

  input clk;
  input rst;
  input en;

  input [CONFIG_WIDTH-1:0] configAIP;
  input readAIP;
  input writeAIP;
  input startAIP;
  input [DATA_WIDTH-1:0] dataInAIP;
  output [DATA_WIDTH-1:0] dataOutAIP;
  output intAIP;

  `ifdef ID1000500B_MEM_IN
  output [(`ID1000500B_MEM_IN*DATA_WIDTH)-1:0] rdDataMemIn;
  input wire [(`ID1000500B_MEM_IN*MEM_ADDR_MAX_WIDTH)-1:0] rdAddrMemIn;

  wire [(`ID1000500B_MEM_IN*MEM_ADDR_MAX_WIDTH)-1:0] wrAddrMemIn;
  wire [`ID1000500B_MEM_IN-1:0] wrEnMemIn;

  wire [DATA_WIDTH-1:0] rdDataMemIn0;
  `elsif ID1000500B_STREAMING_IN
  output [DATA_WIDTH-1:0] rdDataMemIn;
  input wire [MEM_ADDR_MAX_WIDTH-1:0] rdAddrMemIn;
  `endif // ID1000500B_MEM_IN

  `ifdef ID1000500B_MEM_OUT
  input [(`ID1000500B_MEM_OUT*DATA_WIDTH)-1:0] wrDataMemOut;
  input [(`ID1000500B_MEM_OUT*MEM_ADDR_MAX_WIDTH)-1:0] wrAddrMemOut;
  input [`ID1000500B_MEM_OUT-1:0] wrEnMemOut;

  wire [(`ID1000500B_MEM_OUT*DATA_WIDTH)-1:0] rdDataMemOut;
  wire [(`ID1000500B_MEM_OUT*MEM_ADDR_MAX_WIDTH)-1:0] rdAddrMemOut;
  `elsif ID1000500B_STREAMING_OUT
  input [DATA_WIDTH-1:0] wrDataMemOut;
  input [0:0] wrEnMemOut;
  `endif // ID1000500B_MEM_OUT

  `ifdef ID1000500B_CONF_REG
  output [(CONF_REG_ADDR_WIDTH*DATA_WIDTH)-1:0] rdDataConfigReg;

  wire [CONF_REG_ADDR_MAX_WIDTH-1:0] wrAddrConfigReg;
  wire wrEnConfigReg;
  `endif //ID1000500B_CONF_REG

  `ifdef ID1000500B_STREAMING_IN
  input [DATA_WIDTH-1:0] dataInStreaming;
  input startStreaming;
  input wrInStreaming;

  wire [MEM_ADDR_MAX_WIDTH-1:0] wrAddrStreamingIn;

  wire [DATA_WIDTH-1:0] rdDataMemInStreaming;
  `endif

  `ifdef ID1000500B_STREAMING_OUT
  output [DATA_WIDTH-1:0] dataOutStreaming;
  output doneStreaming;
  output wrOutStreaming;
  `endif

  input [STATUS_WIDTH-1:0] statusIPcore;
  input [STATUS_WIDTH-1:0] intIPCore;

  output startIPcore;

  wire [SEL_BITS-1:0] selMux;
  wire [((2**SEL_BITS)*DATA_WIDTH)-1:0] dataMux;

  wire [DATA_WIDTH-1:0] wireIpId;

  wire setStatus;
  wire [DATA_WIDTH-1:0] wireStatus;

  wire [DATA_WIDTH-1:0] configsAIP;

  `ifdef ID1000500B_STREAMING_IN
      assign startIPcore = (configsAIP[1]&startAIP)|(configsAIP[2]&startStreaming);
  `else
      assign startIPcore = startAIP;
  `endif

  `ifdef ID1000500B_STREAMING_OUT
      assign dataOutStreaming = wrDataMemOut[0+:DATA_WIDTH];
      assign doneStreaming = intIPCore[0];
      assign wrOutStreaming = wrEnMemOut[0];
  `endif

  genvar i;

  //--- Mem In ---//
  `ifdef ID1000500B_MEM_IN
  generate
      for(i=0; i<`ID1000500B_MEM_IN; i = i + 1) begin :  MEMIN
          if (0 == i)
              simple_dual_port_ram_single_clk
              #(
                  .DATA_WIDTH (DATA_WIDTH),
                  .ADDR_WIDTH (MEM_IN_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH])
              )
              MEMIN
              (
                  .Write_clock__i (clk),

                  .Write_enable_i (wrEnMemIn[i]),
                  .Write_addres_i (wrAddrMemIn[MEM_ADDR_MAX_WIDTH*i+:MEM_IN_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH]]),
                  .data_input___i (dataInAIP),

                  .Read_address_i (rdAddrMemIn[MEM_ADDR_MAX_WIDTH*i+:MEM_IN_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH]]),
                  .data_output__o (rdDataMemIn0)
              );
          else
              simple_dual_port_ram_single_clk
              #(
                  .DATA_WIDTH (DATA_WIDTH),
                  .ADDR_WIDTH (MEM_IN_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH])
              )
              MEMIN
              (
                  .Write_clock__i (clk),

                  .Write_enable_i (wrEnMemIn[i]),
                  .Write_addres_i (wrAddrMemIn[MEM_ADDR_MAX_WIDTH*i+:MEM_IN_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH]]),
                  .data_input___i (dataInAIP),

                  .Read_address_i (rdAddrMemIn[MEM_ADDR_MAX_WIDTH*i+:MEM_IN_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH]]),
                  .data_output__o (rdDataMemIn[DATA_WIDTH*i+:DATA_WIDTH])
              );
      end
  endgenerate
  `endif

  `ifdef ID1000500B_STREAMING_IN
  simple_dual_port_ram_single_clk
  #(
      .DATA_WIDTH (DATA_WIDTH),
      .ADDR_WIDTH (MEM_IN_STREAMING_ADDR_WIDTH)
  )
  MEMIN_STREAMING
  (
      .Write_clock__i (clk),

      .Write_enable_i (wrInStreaming),
      .Write_addres_i (wrAddrStreamingIn[0+:MEM_IN_STREAMING_ADDR_WIDTH]),
      .data_input___i (dataInStreaming),

      .Read_address_i (rdAddrMemIn[0+:MEM_IN_STREAMING_ADDR_WIDTH]),
      .data_output__o (rdDataMemInStreaming)
  );
  `endif

  `ifdef ID1000500B_MEM_IN
      `ifdef ID1000500B_STREAMING_IN
          assign rdDataMemIn[0+:DATA_WIDTH] = configsAIP[0] ? rdDataMemInStreaming : rdDataMemIn0;
      `else
          assign rdDataMemIn[0+:DATA_WIDTH] = rdDataMemIn0;
      `endif
  `elsif ID1000500B_STREAMING_IN
      assign rdDataMemIn[0+:DATA_WIDTH] = rdDataMemInStreaming;
  `endif

  //--- Mem Out ---//
  `ifdef ID1000500B_MEM_OUT
  generate
      for(i=0; i<`ID1000500B_MEM_OUT; i = i+1) begin : MEMOUT
          simple_dual_port_ram_single_clk
          #(
              .DATA_WIDTH (DATA_WIDTH),
              .ADDR_WIDTH (MEM_OUT_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH])
          )
          MEMOUT
          (
              .Write_clock__i (clk),

              .Write_enable_i (wrEnMemOut[i]),
              .Write_addres_i (wrAddrMemOut[MEM_ADDR_MAX_WIDTH*i+:MEM_OUT_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH]]),
              .data_input___i (wrDataMemOut[DATA_WIDTH*i+:DATA_WIDTH]),

              .Read_address_i (rdAddrMemOut[MEM_ADDR_MAX_WIDTH*i+:MEM_OUT_ADDR_WIDTH[MEM_ADDR_MAX_WIDTH*i+:MEM_ADDR_MAX_WIDTH]]),
              .data_output__o (rdDataMemOut[DATA_WIDTH*i+:DATA_WIDTH])
          );
      end
  endgenerate
  `endif

  //--- Conf Reg ---//
  `ifdef ID1000500B_CONF_REG
  generate
      aipConfigurationRegister
      #(
          .DATAWIDTH (DATA_WIDTH),
          .REGISTERS (CONF_REG_ADDR_WIDTH)
      )
      CONFREG
      (
          .reset(rst),
          .writeClock (clk),

          .writeEnable (wrEnConfigReg),
          .writeAddress (wrAddrConfigReg),

          .dataInput (dataInAIP),
          .dataOutput ({configsAIP,rdDataConfigReg})
      );
  endgenerate
  `endif

  //---------- Control ----------//
  ID1000500B_aipCtrl
  #(
      `ifdef ID1000500B_MEM_IN
      .CONFIG_MEM_IN(CONFIG_MEM_IN),
      `endif
      `ifdef ID1000500B_MEM_OUT
      .CONFIG_MEM_OUT(CONFIG_MEM_OUT),
      `endif
      `ifdef ID1000500B_CONF_REG
      .CONF_REG_ADDR_WIDTH(CONF_REG_ADDR_WIDTH),
      .CONFIG_CONF_REG(CONFIG_CONF_REG),
      `endif
      .SIZE_MUX(SEL_BITS)
  )
  CNTRL
  (
      .clk(clk),
      .rst(rst),
      .en(en),
      .readAIP(readAIP),
      .writeAIP(writeAIP),
      .configAIP(configAIP),

      `ifdef ID1000500B_MEM_IN
      .wrEnMemIn(wrEnMemIn),
      .wrAddrMemIn(wrAddrMemIn),
      `endif

      `ifdef ID1000500B_MEM_OUT
      .rdAddrMemOut(rdAddrMemOut),
      `endif

      `ifdef ID1000500B_CONF_REG
      .wrAddrConfigReg(wrAddrConfigReg),
      .wrEnConfigReg(wrEnConfigReg),
      `endif

      `ifdef ID1000500B_STREAMING_IN
      .startStreaming(startStreaming),
      .wrStreaming(wrInStreaming),
      .wrAddrStreamingIn(wrAddrStreamingIn),
      `endif

      .memAddr(dataInAIP[MEM_ADDR_MAX_WIDTH-1:0]),
      .setStatus(setStatus),
      .selMux(selMux)
  );

  genvar j;
  generate
      for (j=((2**SEL_BITS)-1); j>=0; j = j - 1) begin : SEL_MUX
          if (j == ((2**SEL_BITS)-2))
              assign dataMux[DATA_WIDTH*j+:DATA_WIDTH] = wireStatus;
          else if (j == ((2**SEL_BITS)-1))
              assign dataMux[DATA_WIDTH*j+:DATA_WIDTH] = wireIpId;
          `ifdef ID1000500B_MEM_OUT
          else if (j<`ID1000500B_MEM_OUT)
              assign dataMux[DATA_WIDTH*j+:DATA_WIDTH] = rdDataMemOut[DATA_WIDTH*j+:DATA_WIDTH];
          `endif
          else
              assign dataMux[DATA_WIDTH*j+:DATA_WIDTH] = 32'h00000000;
      end // for
  endgenerate

  //--- Mux ---//
  aipParametricMux
  #(
      .DATAWIDTH (DATA_WIDTH),
      .SELBITS (SEL_BITS)
  )
  MUX
  (
      .data_in (dataMux),
      .sel (selMux),
      .data_out (dataOutAIP)
  );

  //--- ID Reg ---//
  aipId
  #(
      .ID (IP_ID)
  )
  ID
  (
      .clk (clk),
      .data_IP_ID (wireIpId)
  );

  //--- Status Reg ---//
  aipStatus STATUS
  (
      .clk (clk),
      .rst (rst),
      .enSet (setStatus),
      .dataIn (dataInAIP),
      .intIP (intIPCore),
      .statusIP (statusIPcore),
      .dataStatus (wireStatus),
      .intReq (intAIP)
  );

endmodule

module ID1000500B_aipCtrl
(
  clk,
  rst,
  en,
  readAIP,
  writeAIP,
  configAIP,

  `ifdef ID1000500B_MEM_IN
  wrEnMemIn,
  wrAddrMemIn,
  `endif

  `ifdef ID1000500B_MEM_OUT
  rdAddrMemOut,
  `endif

  `ifdef ID1000500B_CONF_REG
  wrAddrConfigReg,
  wrEnConfigReg,
  `endif

  `ifdef ID1000500B_STREAMING_IN
  startStreaming,
  wrStreaming,
  wrAddrStreamingIn,
  `endif

  memAddr,
  setStatus,
  selMux
);

  localparam MEM_ADDR_MAX_WIDTH = 16;

  localparam CONF_REG_ADDR_MAX_WIDTH = 3;

  localparam CONFIG_WIDTH = 5;

  localparam STAT_REG = 5'b11110;

  localparam ID_REG = 5'b11111;

  parameter SIZE_MUX = 'd2;

  `ifdef ID1000500B_MEM_IN
  parameter [((`ID1000500B_MEM_IN*2)*CONFIG_WIDTH)-1:0] CONFIG_MEM_IN = {5'b00011, 5'b00010, 5'b00001, 5'b00000};
  `endif

  `ifdef ID1000500B_MEM_OUT
  parameter [((`ID1000500B_MEM_OUT*2)*CONFIG_WIDTH)-1:0] CONFIG_MEM_OUT = {5'b00101, 5'b00100};
  `endif

  `ifdef ID1000500B_CONF_REG
  parameter [CONF_REG_ADDR_MAX_WIDTH-1:0] CONF_REG_ADDR_WIDTH = {3'd2};

  parameter [(2*CONFIG_WIDTH)-1:0] CONFIG_CONF_REG = {5'b01011, 5'b01010};
  `endif

  input clk;
  input rst;
  input en;
  input readAIP;
  input writeAIP;
  input [CONFIG_WIDTH-1:0] configAIP;

  `ifdef ID1000500B_MEM_IN
  output wire [(`ID1000500B_MEM_IN*MEM_ADDR_MAX_WIDTH)-1:0] wrAddrMemIn;
  output wire [`ID1000500B_MEM_IN-1:0] wrEnMemIn;

  reg [MEM_ADDR_MAX_WIDTH-1:0] regWrAddrMemIn [0:`ID1000500B_MEM_IN];
  `endif

  `ifdef ID1000500B_MEM_OUT
  output wire [(`ID1000500B_MEM_OUT*MEM_ADDR_MAX_WIDTH)-1:0] rdAddrMemOut;

  reg [MEM_ADDR_MAX_WIDTH-1:0] regRdAddrMemOut [0:`ID1000500B_MEM_OUT];
  `endif

  `ifdef ID1000500B_CONF_REG
  output wire [CONF_REG_ADDR_MAX_WIDTH-1:0] wrAddrConfigReg;
  output wrEnConfigReg;

  reg [CONF_REG_ADDR_MAX_WIDTH-1:0] regWrAddrConfigReg;
  `endif

  `ifdef ID1000500B_STREAMING_IN
  input startStreaming;
  input wrStreaming;

  output wire [MEM_ADDR_MAX_WIDTH-1:0] wrAddrStreamingIn;

  reg [MEM_ADDR_MAX_WIDTH-1:0] regWrAddrStreamingIn;
  `endif

  output wire [SIZE_MUX-1:0] selMux;

  input [MEM_ADDR_MAX_WIDTH-1:0] memAddr;

  output wire setStatus;

  wire [SIZE_MUX-1:0] wireSelMux [0:2**SIZE_MUX-2];

  assign setStatus = writeAIP & (configAIP == STAT_REG);

  genvar indexEn;
  `ifdef ID1000500B_MEM_IN
  generate
      for (indexEn=0; indexEn<`ID1000500B_MEM_IN; indexEn= indexEn + 1) begin : WR_EN_MEMIN
          assign wrEnMemIn[indexEn] = writeAIP & (configAIP == CONFIG_MEM_IN[CONFIG_WIDTH*(indexEn*2)+:CONFIG_WIDTH]);
      end // for ID1000500B_MEM_IN
   endgenerate
  `endif

  `ifdef ID1000500B_CONF_REG
  generate
      assign wrEnConfigReg = writeAIP & (configAIP == CONFIG_CONF_REG[0+:CONFIG_WIDTH]);
   endgenerate
  `endif

  wire [31:0] idValue;
  wire [31:0] statusValue;
  assign statusValue = ((2**SIZE_MUX)-2);
  assign idValue = ((2**SIZE_MUX)-1);

  genvar j;
  generate
    if(SIZE_MUX > 1) begin
    for (j=((2**SIZE_MUX)-2); j>=0; j = j - 1) begin : SEL_MUX
      if (j==(2**SIZE_MUX)-2) begin
        assign wireSelMux[j] = configAIP == STAT_REG ? statusValue[SIZE_MUX-1:0] : idValue[SIZE_MUX-1:0];
      end // if (j==(2**SIZE_MUX)-2)
      else if (j==0) begin
        `ifdef ID1000500B_MEM_OUT
        if (`ID1000500B_MEM_OUT == 1) begin
          assign selMux = (configAIP == CONFIG_MEM_OUT[CONFIG_WIDTH*(j*2)+:CONFIG_WIDTH]) ? j[SIZE_MUX-1:0] : wireSelMux[(2**SIZE_MUX)-2];
        end
        else begin
          assign selMux = (configAIP == CONFIG_MEM_OUT[CONFIG_WIDTH*(j*2)+:CONFIG_WIDTH]) ? j[SIZE_MUX-1:0] : wireSelMux[j+1];
        end
        `else
        assign selMux = wireSelMux[(2**SIZE_MUX)-2];
        `endif
      end // if (j==0)
      `ifdef ID1000500B_MEM_OUT
      else if (j == `ID1000500B_MEM_OUT - 1) begin
        assign wireSelMux[j] = configAIP == CONFIG_MEM_OUT[CONFIG_WIDTH*(j*2)+:CONFIG_WIDTH] ? j[SIZE_MUX-1:0] : wireSelMux[(2**SIZE_MUX)-2];
      end // if (j == `ID1000500B_MEM_OUT - 1)
      else if (j<`ID1000500B_MEM_OUT) begin
        assign wireSelMux[j] = configAIP == CONFIG_MEM_OUT[CONFIG_WIDTH*(j*2)+:CONFIG_WIDTH] ? j[SIZE_MUX-1:0] : wireSelMux[j+1];
      end // if (j<`ID1000500B_MEM_OUT)
      `endif
    end // for
    end // if(SEL_MUX > 1)
    else begin
      assign selMux = configAIP == STAT_REG ? statusValue[SIZE_MUX-1:0] : idValue[SIZE_MUX-1:0];
    end
  endgenerate

  integer i;
  always @(posedge clk or negedge rst) begin
    if (!rst) begin
      `ifdef ID1000500B_MEM_IN
      for (i=0; i<`ID1000500B_MEM_IN; i= i + 1) begin
        regWrAddrMemIn[i] <= 'd0;
      end
      `endif

      `ifdef ID1000500B_MEM_OUT
      for (i=0; i<`ID1000500B_MEM_OUT; i= i + 1) begin
        regRdAddrMemOut[i] <= 'd0;
      end
      `endif

      `ifdef ID1000500B_CONF_REG
      regWrAddrConfigReg <= 'd0;
      `endif

      `ifdef ID1000500B_STREAMING_IN
      regWrAddrStreamingIn <= 'd0;
      `endif
    end // if (!rst)
    else begin
      if (en) begin
        `ifdef ID1000500B_MEM_IN
        for (i=0; i<`ID1000500B_MEM_IN; i= i + 1) begin
          if (writeAIP && configAIP == CONFIG_MEM_IN[CONFIG_WIDTH*(i*2+1)+:CONFIG_WIDTH])
            regWrAddrMemIn[i] <= memAddr[MEM_ADDR_MAX_WIDTH-1:0];
          else if (writeAIP && (configAIP == CONFIG_MEM_IN[CONFIG_WIDTH*(i*2)+:CONFIG_WIDTH]))
            regWrAddrMemIn[i] <= regWrAddrMemIn[i] + 1'b1;
        end // for ID1000500B_MEM_IN
        `endif

        `ifdef ID1000500B_MEM_OUT
        for (i=0; i<`ID1000500B_MEM_OUT; i= i + 1) begin
          if (writeAIP && configAIP == CONFIG_MEM_OUT[CONFIG_WIDTH*(i*2+1)+:CONFIG_WIDTH])
            regRdAddrMemOut[i] <= memAddr[MEM_ADDR_MAX_WIDTH-1:0];
          else if (readAIP && (configAIP == CONFIG_MEM_OUT[CONFIG_WIDTH*(i*2)+:CONFIG_WIDTH]))
            regRdAddrMemOut[i] <= regRdAddrMemOut[i] + 1'b1;
        end // for ID1000500B_MEM_OUT
        `endif

        `ifdef ID1000500B_CONF_REG
        if (writeAIP && configAIP == CONFIG_CONF_REG[CONFIG_WIDTH+:CONFIG_WIDTH])
          regWrAddrConfigReg <= memAddr[CONF_REG_ADDR_MAX_WIDTH-1:0];
        else if (writeAIP && (configAIP == CONFIG_CONF_REG[0+:CONFIG_WIDTH]))
          if ((CONF_REG_ADDR_WIDTH[0+:CONF_REG_ADDR_MAX_WIDTH]-1) > regWrAddrConfigReg)
            regWrAddrConfigReg <= regWrAddrConfigReg + 1'b1;
          else
            regWrAddrConfigReg <= 'd0;
        `endif

        `ifdef ID1000500B_STREAMING_IN
        if (startStreaming)
          regWrAddrStreamingIn <= 'd0;
        else if (wrStreaming)
          regWrAddrStreamingIn <= regWrAddrStreamingIn + 1'b1;
        `endif
      end // if (en)
    end // else
  end // always

  genvar indexAddr;
  `ifdef ID1000500B_MEM_IN
  generate
    for (indexAddr=0; indexAddr<(`ID1000500B_MEM_IN); indexAddr=indexAddr+1) begin: MEM_IN_ADDR
      assign wrAddrMemIn[MEM_ADDR_MAX_WIDTH*indexAddr +: MEM_ADDR_MAX_WIDTH] = regWrAddrMemIn[indexAddr][MEM_ADDR_MAX_WIDTH-1:0];
    end
  endgenerate
  `endif

  `ifdef ID1000500B_MEM_OUT
  generate
    for (indexAddr=0; indexAddr<(`ID1000500B_MEM_OUT); indexAddr=indexAddr+1) begin: MEM_OUT_ADDR
      assign rdAddrMemOut[MEM_ADDR_MAX_WIDTH*indexAddr +: MEM_ADDR_MAX_WIDTH] = regRdAddrMemOut[indexAddr][MEM_ADDR_MAX_WIDTH-1:0];
    end
  endgenerate
  `endif

  `ifdef ID1000500B_CONF_REG
  generate
    assign wrAddrConfigReg = regWrAddrConfigReg;
  endgenerate
  `endif

  `ifdef ID1000500B_STREAMING_IN
  generate
    assign wrAddrStreamingIn = regWrAddrStreamingIn;
  endgenerate
  `endif
endmodule
