/*  Jason Lin
    mg208
    lin57@purdue.edu
    2/7/2015

    IF/ID register
*/

`include "ifid_if.vh"
`include "cpu_types_pkg.vh"

module ifid (
  input logic CLK,
  input logic nRST,
  ifid_if ifid
);


always_ff @ (posedge CLK, negedge nRST) begin
  if(!nRST) begin
    ifid.out_iload <= '0;
    ifid.out_cpc <= '0;
  end else begin
    ifid.out_iload <= ifid.in_iload;
    ifid.out_cpc <= ifid.in_cpc;
  end
end

endmodule
