/*
  Eric Villasenor
  evillase@gmail.com

  datapath contains register file, control, hazard,
  muxes, and glue logic for processor
*/

// data path interface
`include "datapath_cache_if.vh"
`include "control_unit_if.vh"
`include "register_file_if.vh"
`include "alu_if.vh"
`include "pc_if.vh"
`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"

// alu op, mips op, and instruction type
`include "cpu_types_pkg.vh"

module datapath (
  input logic CLK, nRST,
  datapath_cache_if.dp dpif
);
  import cpu_types_pkg::word_t;
  word_t imm;

  // import types
  import cpu_types_pkg::*;
  control_unit_if cuif();
  register_file_if rfif();
  alu_if aluif();
  pc_if pcif();
  request_unit_if ruif();

  // pc init
  parameter PC_INIT = 0;

  //mapping control unit, regfile, alu and request unit, pc
  pc PC(CLK, nRST, pcif);
  control_unit CU(CLK, nRST,cuif);
  register_file RF(CLK, nRST, rfif);
  alu ALU(aluif);
  request_unit RU(CLK, nRST, ruif);

  assign imm = (cuif.extend) ? {{16{dpif.imemload[15]}},dpif.imemload[15:0]}
                             : {16'h0000,dpif.imemload[15:0]};
  /*always_ff @ (posedge CLK, negedge nRST) begin
    if(!nRST) begin
      dpif.halt <= 0;
    end else begin
      dpif.halt <= cuif.halt;
    end
  end*/
  always_comb begin
    if(!nRST | cuif.halt) begin
      dpif.imemREN = 0;
    end else begin
      dpif.imemREN = 1;
    end
    if(cuif.alusrc) begin
      if(cuif.shift) begin
        aluif.portb = dpif.imemload[10:6];
      end else if(cuif.lui) begin
        aluif.portb = (dpif.imemload[15:0]<<16);
      end else begin
        aluif.portb = imm;
      end
    end else begin
      aluif.portb = rfif.rdat2;
    end
  end

  // routing PC inputs
  assign pcif.imm = imm;
  assign pcif.jaddr = dpif.imemload[25:0];//ruif.jdata.addr;
  assign pcif.branch = cuif.branch && aluif.z_flag;
  assign pcif.jump = cuif.jump;
  assign pcif.regtarget = rfif.rdat1;
  assign pcif.pcen = ruif.pcen;
  // routing control unit
  assign cuif.opcode = '{dpif.imemload[31:26]};//ruif.rdata.opcode;
  assign cuif.func = '{dpif.imemload[5:0]};//ruif.rdata.funct;
  assign cuif.vflag = aluif.v_flag;
  assign cuif.instr = '{dpif.imemload};
  // routing register file
  assign rfif.WEN = cuif.regWrite;
  assign rfif.rsel1 = dpif.imemload[25:21];//ruif.rdata.rs;
  assign rfif.rsel2 = dpif.imemload[20:16];//ruif.rdata.rt;
  assign rfif.wsel = (dpif.imemload[31:26] == JAL) ? 31 : ((cuif.regDst) ? dpif.imemload[15:11] : dpif.imemload[20:16]);
  assign rfif.wdat = (dpif.imemload[31:26] == JAL) ? 31 : ((cuif.memtoReg) ? dpif.dmemload : aluif.portout);
  //routing ALU
  assign aluif.porta = rfif.rdat1;
  /*assign aluif.portb = (cuif.alusrc) ? imm :
                       ((cuif.shift) ? ruif.rdata.shamt :
                       ((cuif.lui) ? {ruif.idata.imm,'0} : rfif.rdat2));
*/
  assign aluif.aluop = cuif.aluop;
  // routing request unit
  assign ruif.pc = pcif.cpc;
  assign ruif.d_addr = aluif.portout;
  assign ruif.writeData = rfif.rdat2;
  assign ruif.iren = cuif.iren;
  assign ruif.dren = cuif.dren;
  assign ruif.dwen = cuif.dwen;
  assign ruif.ihit = dpif.ihit;
  assign ruif.dhit = dpif.dhit;
  assign ruif.iload = dpif.imemload;
  assign ruif.dload = dpif.dmemload;
  //assign ruif.halt = cuif.halt;
  // routing datapath
//  assign dpif.imemREN = ruif.iREN;
  assign dpif.dmemREN = ruif.dREN;
  assign dpif.dmemWEN = ruif.dWEN;
  assign dpif.imemaddr = pcif.cpc;
  assign dpif.dmemaddr = aluif.portout;//ruif.daddr;
  assign dpif.dmemstore = rfif.rdat2;
  assign dpif.halt = cuif.halt;
endmodule
