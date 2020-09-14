// © IBM Corp. 2020
// This softcore is licensed under and subject to the terms of the CC-BY 4.0
// license (https://creativecommons.org/licenses/by/4.0/legalcode). 
// Additional rights, including the right to physically implement a softcore 
// that is compliant with the required sections of the Power ISA 
// Specification, will be available at no cost via the OpenPOWER Foundation. 
// This README will be updated with additional information when OpenPOWER's 
// license is available.


`include "tri_a2o.vh"
module xu_alu_cmp(
   input [0:`NCLK_WIDTH-1] nclk,
   
   inout                   vdd,
   inout                   gnd,
   
   input                   d_mode_dc,
   input                   delay_lclkr_dc,
   input                   mpw1_dc_b,
   input                   mpw2_dc_b,
   input                   func_sl_force,
   input                   func_sl_thold_0_b,
   input                   sg_0,
   input                   scan_in,
   output                  scan_out,
   
   input                   ex2_act,
   
   input                   ex1_msb_64b_sel,
   
   input [6:10]            ex2_instr,
   input                   ex2_sel_trap,
   input                   ex2_sel_cmpl,
   input                   ex2_sel_cmp,
   
   input                   ex2_rs1_00,
   input                   ex2_rs1_32,
   
   input                   ex2_rs2_00,
   input                   ex2_rs2_32,
   
   input [64-`GPR_WIDTH:63] ex3_alu_rt,
   input                   ex3_add_ca,
   
   output [0:2]            ex3_alu_cr,
   
   output                  ex3_trap_val
);
   localparam              msb = 64 - `GPR_WIDTH;
   wire                    ex2_msb_64b_sel_q;		
   wire                    ex3_msb_64b_sel_q;		
   wire                    ex3_diff_sign_q;		
   wire                    ex2_diff_sign;
   wire                    ex3_rs1_trm1_q;		
   wire                    ex2_rs1_trm1;
   wire                    ex3_rs2_trm1_q;		
   wire                    ex2_rs2_trm1;
   wire [6:10]             ex3_instr_q;		
   wire                    ex3_sel_trap_q;		
   wire                    ex3_sel_cmpl_q;		
   wire                    ex3_sel_cmp_q;		
   localparam              ex2_msb_64b_sel_offset = 0;
   localparam              ex3_msb_64b_sel_offset = ex2_msb_64b_sel_offset + 1;
   localparam              ex3_diff_sign_offset = ex3_msb_64b_sel_offset + 1;
   localparam              ex3_rs1_trm1_offset = ex3_diff_sign_offset + 1;
   localparam              ex3_rs2_trm1_offset = ex3_rs1_trm1_offset + 1;
   localparam              ex3_instr_offset = ex3_rs2_trm1_offset + 1;
   localparam              ex3_sel_trap_offset = ex3_instr_offset + 5;
   localparam              ex3_sel_cmpl_offset = ex3_sel_trap_offset + 1;
   localparam              ex3_sel_cmp_offset = ex3_sel_cmpl_offset + 1;
   localparam              scan_right = ex3_sel_cmp_offset + 1;
   wire [0:scan_right-1]   siv;
   wire [0:scan_right-1]   sov;
   wire                    ex3_cmp0_hi;
   wire                    ex3_cmp0_lo;
   wire                    ex3_cmp0_eq;
   wire                    ex2_rs1_msb;
   wire                    ex2_rs2_msb;
   wire                    ex3_rt_msb;
   wire                    ex3_rslt_gt_s;
   wire                    ex3_rslt_lt_s;
   wire                    ex3_rslt_gt_u;
   wire                    ex3_rslt_lt_u;
   wire                    ex3_cmp_eq;
   wire                    ex3_cmp_gt;
   wire                    ex3_cmp_lt;
   wire                    ex3_sign_cmp;


   tri_st_or3232 or3232(
      .d(ex3_alu_rt),
      .or_hi_b(ex3_cmp0_hi),
      .or_lo_b(ex3_cmp0_lo)
   );

   assign ex2_rs1_msb = (ex2_msb_64b_sel_q == 1'b1) ? ex2_rs1_00 : ex2_rs1_32;

   assign ex2_rs2_msb = (ex2_msb_64b_sel_q == 1'b1) ? ex2_rs2_00 : ex2_rs2_32;

   assign ex3_rt_msb  = (ex3_msb_64b_sel_q == 1'b1) ? ex3_alu_rt[msb] : ex3_alu_rt[32];

   assign ex3_cmp0_eq = (ex3_msb_64b_sel_q == 1'b1) ? (ex3_cmp0_lo & ex3_cmp0_hi) : ex3_cmp0_lo;
   
   assign ex2_diff_sign = (ex2_rs1_msb ^ ex2_rs2_msb) & (ex2_sel_cmpl | ex2_sel_cmp | ex2_sel_trap);


   assign ex3_sign_cmp = ((ex3_sel_cmpl_q | ex3_sel_cmp_q | ex3_sel_trap_q) == 1'b1) ? ex3_add_ca : ex3_rt_msb;
   assign ex2_rs1_trm1 = ex2_rs1_msb & ex2_diff_sign;
   assign ex2_rs2_trm1 = ex2_rs2_msb & ex2_diff_sign;

   assign ex3_rslt_gt_s = (ex3_rs2_trm1_q | (~ex3_sign_cmp & ~ex3_diff_sign_q));		
   assign ex3_rslt_lt_s = (ex3_rs1_trm1_q | ( ex3_sign_cmp & ~ex3_diff_sign_q));		
   assign ex3_rslt_gt_u = (ex3_rs1_trm1_q | (~ex3_sign_cmp & ~ex3_diff_sign_q));		
   assign ex3_rslt_lt_u = (ex3_rs2_trm1_q | ( ex3_sign_cmp & ~ex3_diff_sign_q));		

   assign ex3_cmp_eq = ex3_cmp0_eq;
   assign ex3_cmp_gt = ((~ex3_sel_cmpl_q & ex3_rslt_gt_s) | (ex3_sel_cmpl_q & ex3_rslt_gt_u)) & (~ex3_cmp0_eq);
   assign ex3_cmp_lt = ((~ex3_sel_cmpl_q & ex3_rslt_lt_s) | (ex3_sel_cmpl_q & ex3_rslt_lt_u)) & (~ex3_cmp0_eq);

   assign ex3_alu_cr = {ex3_cmp_lt, ex3_cmp_gt, ex3_cmp_eq};

   assign ex3_trap_val = ex3_sel_trap_q & 
                        ((ex3_instr_q[6]  & (~ex3_cmp_eq) & ex3_rslt_lt_s) |
                         (ex3_instr_q[7]  & (~ex3_cmp_eq) & ex3_rslt_gt_s) |
                         (ex3_instr_q[8]  &   ex3_cmp_eq) |
                         (ex3_instr_q[9]  & (~ex3_cmp_eq) & ex3_rslt_lt_u) |
                         (ex3_instr_q[10] & (~ex3_cmp_eq) & ex3_rslt_gt_u));

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex2_msb_64b_sel_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(1'b1),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex2_msb_64b_sel_offset]),
      .scout(sov[ex2_msb_64b_sel_offset]),
      .din(ex1_msb_64b_sel),
      .dout(ex2_msb_64b_sel_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_msb_64b_sel_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_msb_64b_sel_offset]),
      .scout(sov[ex3_msb_64b_sel_offset]),
      .din(ex2_msb_64b_sel_q),
      .dout(ex3_msb_64b_sel_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_diff_sign_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_diff_sign_offset]),
      .scout(sov[ex3_diff_sign_offset]),
      .din(ex2_diff_sign),
      .dout(ex3_diff_sign_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_rs1_trm1_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_rs1_trm1_offset]),
      .scout(sov[ex3_rs1_trm1_offset]),
      .din(ex2_rs1_trm1),
      .dout(ex3_rs1_trm1_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_rs2_trm1_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_rs2_trm1_offset]),
      .scout(sov[ex3_rs2_trm1_offset]),
      .din(ex2_rs2_trm1),
      .dout(ex3_rs2_trm1_q)
   );

   tri_rlmreg_p #(.WIDTH(5), .INIT(0), .NEEDS_SRESET(1)) ex3_instr_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_instr_offset:ex3_instr_offset + 5 - 1]),
      .scout(sov[ex3_instr_offset:ex3_instr_offset + 5 - 1]),
      .din(ex2_instr),
      .dout(ex3_instr_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_sel_trap_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_sel_trap_offset]),
      .scout(sov[ex3_sel_trap_offset]),
      .din(ex2_sel_trap),
      .dout(ex3_sel_trap_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_sel_cmpl_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_sel_cmpl_offset]),
      .scout(sov[ex3_sel_cmpl_offset]),
      .din(ex2_sel_cmpl),
      .dout(ex3_sel_cmpl_q)
   );

   tri_rlmlatch_p #(.INIT(0), .NEEDS_SRESET(1)) ex3_sel_cmp_latch(
      .nclk(nclk),
      .vd(vdd),
      .gd(gnd),
      .act(ex2_act),
      .force_t(func_sl_force),
      .d_mode(d_mode_dc),
      .delay_lclkr(delay_lclkr_dc),
      .mpw1_b(mpw1_dc_b),
      .mpw2_b(mpw2_dc_b),
      .thold_b(func_sl_thold_0_b),
      .sg(sg_0),
      .scin(siv[ex3_sel_cmp_offset]),
      .scout(sov[ex3_sel_cmp_offset]),
      .din(ex2_sel_cmp),
      .dout(ex3_sel_cmp_q)
   );

   assign siv[0:scan_right-1] = {sov[1:scan_right-1], scan_in};
   assign scan_out = sov[0];
      
endmodule
