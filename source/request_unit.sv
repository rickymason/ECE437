/*  Jason Lin
    mg208
    lin57@purdue.edu
    1/31/2015

    Request Unit Source file
*/

`include "request_unit_if.vh"
`include "cpu_types_pkg.vh"
module request_unit(
  input logic CLK, nRST, request_unit_if.ru ruif
);
import cpu_types_pkg::*;
logic ihit, dhit;
// latching the data and signal from cpu on clock edge
always_ff @ (posedge CLK, negedge nRST) begin
  if(!nRST) begin
    ruif.dREN <= 0;
    ruif.dWEN <= 0;
    ruif.iREN <= 0;
  end else begin
    ihit <= ruif.ihit;
    dhit <= ruif.dhit;
    if(ruif.ihit) begin
        ruif.dREN <= ruif.dren;
        ruif.dWEN <= ruif.dwen;
        ruif.iREN <= 0;
        // r-type output
        ruif.rdata.opcode = '{ruif.iload[31:26]};
        ruif.rdata.rs = '{ruif.iload[25:21]};
        ruif.rdata.rt = '{ruif.iload[20:16]};
        ruif.rdata.rd = '{ruif.iload[15:11]};
        ruif.rdata.shamt = '{ruif.iload[10:6]};
        ruif.rdata.funct = '{ruif.iload[5:0]};
        // i-type output
        ruif.idata.opcode = '{ruif.iload[31:26]};
        ruif.idata.rs = '{ruif.iload[25:21]};
        ruif.idata.rt = '{ruif.iload[20:16]};
        ruif.idata.imm = '{ruif.iload[15:0]};
        // j-type output
        ruif.jdata.opcode = '{ruif.iload[31:26]};
        ruif.jdata.addr = '{ruif.iload[25:0]};
    end
    if(ruif.dhit) begin
        ruif.dREN <= 0;
        ruif.dWEN <= 0;
        ruif.iREN <= 1;
        //ruif.readData = ruif.dload;
    end
  end
end
assign ruif.iaddr = ruif.pc;
assign ruif.daddr = ruif.d_addr;
assign ruif.dstore = ruif.writeData;
//assign ruif.iREN = nRST && ruif.iren & ~(ruif.dren || ruif.dwen);
assign ruif.pcen = nRST && ruif.ihit && ~ruif.dhit;
/*always_comb begin
  if(ruif.ihit) begin
      // r-type output
      ruif.rdata.opcode = '{ruif.iload[31:26]};
      ruif.rdata.rs = '{ruif.iload[25:21]};
      ruif.rdata.rt = '{ruif.iload[20:16]};
      ruif.rdata.rd = '{ruif.iload[15:11]};
      ruif.rdata.shamt = '{ruif.iload[10:6]};
      ruif.rdata.funct = '{ruif.iload[5:0]};
      // i-type output
      ruif.idata.opcode = '{ruif.iload[31:26]};
      ruif.idata.rs = '{ruif.iload[25:21]};
      ruif.idata.rt = '{ruif.iload[20:16]};
      ruif.idata.imm = '{ruif.iload[15:0]};
      // j-type output
      ruif.jdata.opcode = '{ruif.iload[31:26]};
      ruif.jdata.addr = '{ruif.iload[25:0]};
    end
    if(ruif.dhit) begin
      // memory read
      ruif.readData = ruif.dload;
    end
end*/

endmodule

