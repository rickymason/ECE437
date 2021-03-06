/*  Jason Lin
    mg208
    lin57@purdue.edu
    2/7/2015

    ex/mem register
*/

`include "exmem_if.vh"
`include "cpu_types_pkg.vh"

module exmem (
  input logic CLK,
  input logic nRST,
  input logic en,
  input logic nop,
  exmem_if exmem
);
  import cpu_types_pkg::*;
  always_ff @ (posedge CLK, negedge nRST) begin
    if(!nRST) begin
      exmem.out_cpc <= 0;
      exmem.out_regWrite <= 0;
      exmem.out_memtoReg <= 0;
      exmem.out_halt <= 0;
      exmem.out_opcode <= RTYPE;
      exmem.out_jump <= 0;
      exmem.out_branch <= 0;
      exmem.out_zflag <= 0;
      exmem.out_dren <= 0;
      exmem.out_dwen <= 0;
      exmem.out_aluout <= 0;
      exmem.out_writeData <= 0;
      exmem.out_imm <= 0;
      exmem.out_regtarget <= 0;
      exmem.out_wsel <= 0;
      exmem.out_jaddr <= 0;
      exmem.out_rs <= 0;
      exmem.out_rt <= 0;
      exmem.out_funct <= SLL;
    end else if(nop) begin
      exmem.out_cpc <= 0;
      exmem.out_regWrite <= 0;
      exmem.out_memtoReg <= 0;
      exmem.out_halt <= 0;
      exmem.out_opcode <= RTYPE;
      exmem.out_jump <= 0;
      exmem.out_branch <= 0;
      exmem.out_zflag <= 0;
      exmem.out_dren <= 0;
      exmem.out_dwen <= 0;
      exmem.out_aluout <= 0;
      exmem.out_writeData <= 0;
      exmem.out_imm <= 0;
      exmem.out_regtarget <= 0;
      exmem.out_wsel <= 0;
      exmem.out_jaddr <= 0;
      exmem.out_rs <= 0;
      exmem.out_rt <= 0;
      exmem.out_funct <= SLL;
    end else begin
      if (en) begin
      exmem.out_cpc <= exmem.in_cpc;
      exmem.out_regWrite <= exmem.in_regWrite;
      exmem.out_memtoReg <= exmem.in_memtoReg;
      exmem.out_halt <= exmem.in_halt;
      exmem.out_opcode <= exmem.in_opcode;
      exmem.out_jump <= exmem.in_jump;
      exmem.out_branch <= exmem.in_branch;
      exmem.out_zflag <= exmem.in_zflag;
      exmem.out_dren <= exmem.in_dren;
      exmem.out_dwen <= exmem.in_dwen;
      exmem.out_aluout <= exmem.in_aluout;
      exmem.out_writeData <= exmem.in_writeData;
      exmem.out_imm <= exmem.in_imm;
      exmem.out_regtarget <= exmem.in_regtarget;
      exmem.out_wsel <= exmem.in_wsel;
      exmem.out_jaddr <= exmem.in_jaddr;
      exmem.out_rs <= exmem.in_rs;
      exmem.out_rt <= exmem.in_rt;
      exmem.out_funct <= exmem.in_funct;
      end
    end
  end
endmodule
