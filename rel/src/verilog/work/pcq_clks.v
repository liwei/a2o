// © IBM Corp. 2020
// This softcore is licensed under and subject to the terms of the CC-BY 4.0
// license (https://creativecommons.org/licenses/by/4.0/legalcode). 
// Additional rights, including the right to physically implement a softcore 
// that is compliant with the required sections of the Power ISA 
// Specification, will be available at no cost via the OpenPOWER Foundation. 
// This README will be updated with additional information when OpenPOWER's 
// license is available.




module pcq_clks( 
`include "tri_a2o.vh"

   inout			vdd,
   inout			gnd,
   input  [0:`NCLK_WIDTH-1]	nclk,
   input			rtim_sl_thold_7,
   input			func_sl_thold_7,
   input			func_nsl_thold_7,
   input			ary_nsl_thold_7,
   input			sg_7,
   input			fce_7,
   input			gsd_test_enable_dc,
   input			gsd_test_acmode_dc,
   input			ccflush_dc,
   input			ccenable_dc,
   input			lbist_en_dc,
   input			lbist_ip_dc,
   input			rg_ck_fast_xstop,
   input			ct_ck_pm_ccflush_disable,
   input			ct_ck_pm_raise_tholds,
   input  [0:8]			scan_type_dc,
   output			pc_pc_ccflush_out_dc,
   output			pc_pc_gptr_sl_thold_4,
   output			pc_pc_time_sl_thold_4,
   output 			pc_pc_repr_sl_thold_4,
   output			pc_pc_abst_sl_thold_4,
   output			pc_pc_abst_slp_sl_thold_4,
   output			pc_pc_regf_sl_thold_4,
   output			pc_pc_regf_slp_sl_thold_4,
   output			pc_pc_func_sl_thold_4,
   output			pc_pc_func_slp_sl_thold_4,
   output			pc_pc_cfg_sl_thold_4,
   output			pc_pc_cfg_slp_sl_thold_4,
   output			pc_pc_func_nsl_thold_4,
   output			pc_pc_func_slp_nsl_thold_4,
   output			pc_pc_ary_nsl_thold_4,
   output			pc_pc_ary_slp_nsl_thold_4,
   output			pc_pc_rtim_sl_thold_4,
   output			pc_pc_sg_4,
   output			pc_pc_fce_4,
   output               	pc_fu_ccflush_dc,
   output               	pc_fu_gptr_sl_thold_3,
   output               	pc_fu_time_sl_thold_3,
   output               	pc_fu_repr_sl_thold_3,
   output               	pc_fu_abst_sl_thold_3,
   output               	pc_fu_abst_slp_sl_thold_3,
   output [0:1]               	pc_fu_func_sl_thold_3,
   output [0:1]               	pc_fu_func_slp_sl_thold_3,
   output               	pc_fu_cfg_sl_thold_3,
   output               	pc_fu_cfg_slp_sl_thold_3,
   output               	pc_fu_func_nsl_thold_3,
   output               	pc_fu_func_slp_nsl_thold_3,
   output               	pc_fu_ary_nsl_thold_3,
   output               	pc_fu_ary_slp_nsl_thold_3,
   output [0:1]              	pc_fu_sg_3,
   output               	pc_fu_fce_3,
   output			pc_pc_ccflush_dc,
   output			pc_pc_gptr_sl_thold_0,
   output			pc_pc_func_sl_thold_0,
   output			pc_pc_func_slp_sl_thold_0,
   output			pc_pc_cfg_sl_thold_0,
   output			pc_pc_cfg_slp_sl_thold_0,
   output			pc_pc_sg_0
);
   
   
   wire          	rtim_sl_thold_6;
   wire          	func_sl_thold_6;
   wire          	func_nsl_thold_6;
   wire          	ary_nsl_thold_6;
   wire          	sg_6;
   wire          	fce_6;
   wire          	ccflush_out_dc;
   wire          	gptr_sl_thold_5;
   wire          	time_sl_thold_5;
   wire          	repr_sl_thold_5;
   wire          	abst_sl_thold_5;
   wire          	abst_slp_sl_thold_5;
   wire          	regf_sl_thold_5;
   wire          	regf_slp_sl_thold_5;
   wire          	func_sl_thold_5;
   wire          	func_slp_sl_thold_5;
   wire          	cfg_sl_thold_5;
   wire         	cfg_slp_sl_thold_5;
   wire          	func_nsl_thold_5;
   wire          	func_slp_nsl_thold_5;
   wire          	ary_nsl_thold_5;
   wire          	ary_slp_nsl_thold_5;
   wire          	rtim_sl_thold_5;
   wire          	sg_5;
   wire          	fce_5;
      
   
   pcq_clks_ctrl  clkctrl(
      .vdd(vdd),
      .gnd(gnd),
      .nclk(nclk),
      .rtim_sl_thold_6(rtim_sl_thold_6),
      .func_sl_thold_6(func_sl_thold_6),
      .func_nsl_thold_6(func_nsl_thold_6),
      .ary_nsl_thold_6(ary_nsl_thold_6),
      .sg_6(sg_6),
      .fce_6(fce_6),
      .gsd_test_enable_dc(gsd_test_enable_dc),
      .gsd_test_acmode_dc(gsd_test_acmode_dc),
      .ccflush_dc(ccflush_dc),
      .ccenable_dc(ccenable_dc),
      .scan_type_dc(scan_type_dc),
      .lbist_en_dc(lbist_en_dc),
      .lbist_ip_dc(lbist_ip_dc),
      .rg_ck_fast_xstop(rg_ck_fast_xstop),
      .ct_ck_pm_ccflush_disable(ct_ck_pm_ccflush_disable),
      .ct_ck_pm_raise_tholds(ct_ck_pm_raise_tholds),
      .ccflush_out_dc(ccflush_out_dc),
      .gptr_sl_thold_5(gptr_sl_thold_5),
      .time_sl_thold_5(time_sl_thold_5),
      .repr_sl_thold_5(repr_sl_thold_5),
      .cfg_sl_thold_5(cfg_sl_thold_5),
      .cfg_slp_sl_thold_5(cfg_slp_sl_thold_5),
      .abst_sl_thold_5(abst_sl_thold_5),
      .abst_slp_sl_thold_5(abst_slp_sl_thold_5),
      .regf_sl_thold_5(regf_sl_thold_5),
      .regf_slp_sl_thold_5(regf_slp_sl_thold_5),
      .func_sl_thold_5(func_sl_thold_5),
      .func_slp_sl_thold_5(func_slp_sl_thold_5),
      .func_nsl_thold_5(func_nsl_thold_5),
      .func_slp_nsl_thold_5(func_slp_nsl_thold_5),
      .ary_nsl_thold_5(ary_nsl_thold_5),
      .ary_slp_nsl_thold_5(ary_slp_nsl_thold_5),
      .rtim_sl_thold_5(rtim_sl_thold_5),
      .sg_5(sg_5),
      .fce_5(fce_5)
   );
   
   
   pcq_clks_stg  clkstg(
      .vdd(vdd),
      .gnd(gnd),
      .nclk(nclk),
      .ccflush_out_dc(ccflush_out_dc),
      .gptr_sl_thold_5(gptr_sl_thold_5),
      .time_sl_thold_5(time_sl_thold_5),
      .repr_sl_thold_5(repr_sl_thold_5),
      .cfg_sl_thold_5(cfg_sl_thold_5),
      .cfg_slp_sl_thold_5(cfg_slp_sl_thold_5),
      .abst_sl_thold_5(abst_sl_thold_5),
      .abst_slp_sl_thold_5(abst_slp_sl_thold_5),
      .regf_sl_thold_5(regf_sl_thold_5),
      .regf_slp_sl_thold_5(regf_slp_sl_thold_5),
      .func_sl_thold_5(func_sl_thold_5),
      .func_slp_sl_thold_5(func_slp_sl_thold_5),
      .func_nsl_thold_5(func_nsl_thold_5),
      .func_slp_nsl_thold_5(func_slp_nsl_thold_5),
      .ary_nsl_thold_5(ary_nsl_thold_5),
      .ary_slp_nsl_thold_5(ary_slp_nsl_thold_5),
      .rtim_sl_thold_5(rtim_sl_thold_5),
      .sg_5(sg_5),
      .fce_5(fce_5),
      .pc_pc_ccflush_out_dc(pc_pc_ccflush_out_dc),
      .pc_pc_gptr_sl_thold_4(pc_pc_gptr_sl_thold_4),
      .pc_pc_time_sl_thold_4(pc_pc_time_sl_thold_4),
      .pc_pc_repr_sl_thold_4(pc_pc_repr_sl_thold_4),
      .pc_pc_abst_sl_thold_4(pc_pc_abst_sl_thold_4),
      .pc_pc_abst_slp_sl_thold_4(pc_pc_abst_slp_sl_thold_4),
      .pc_pc_regf_sl_thold_4(pc_pc_regf_sl_thold_4),
      .pc_pc_regf_slp_sl_thold_4(pc_pc_regf_slp_sl_thold_4),
      .pc_pc_func_sl_thold_4(pc_pc_func_sl_thold_4),
      .pc_pc_func_slp_sl_thold_4(pc_pc_func_slp_sl_thold_4),
      .pc_pc_cfg_sl_thold_4(pc_pc_cfg_sl_thold_4),
      .pc_pc_cfg_slp_sl_thold_4(pc_pc_cfg_slp_sl_thold_4),
      .pc_pc_func_nsl_thold_4(pc_pc_func_nsl_thold_4),
      .pc_pc_func_slp_nsl_thold_4(pc_pc_func_slp_nsl_thold_4),
      .pc_pc_ary_nsl_thold_4(pc_pc_ary_nsl_thold_4),
      .pc_pc_ary_slp_nsl_thold_4(pc_pc_ary_slp_nsl_thold_4),
      .pc_pc_rtim_sl_thold_4(pc_pc_rtim_sl_thold_4),
      .pc_pc_sg_4(pc_pc_sg_4),
      .pc_pc_fce_4(pc_pc_fce_4),
      .pc_fu_ccflush_dc(pc_fu_ccflush_dc),
      .pc_fu_gptr_sl_thold_3(pc_fu_gptr_sl_thold_3),
      .pc_fu_time_sl_thold_3(pc_fu_time_sl_thold_3),
      .pc_fu_repr_sl_thold_3(pc_fu_repr_sl_thold_3),
      .pc_fu_abst_sl_thold_3(pc_fu_abst_sl_thold_3),
      .pc_fu_abst_slp_sl_thold_3(pc_fu_abst_slp_sl_thold_3),
      .pc_fu_func_sl_thold_3(pc_fu_func_sl_thold_3),
      .pc_fu_func_slp_sl_thold_3(pc_fu_func_slp_sl_thold_3),
      .pc_fu_cfg_sl_thold_3(pc_fu_cfg_sl_thold_3),
      .pc_fu_cfg_slp_sl_thold_3(pc_fu_cfg_slp_sl_thold_3),
      .pc_fu_func_nsl_thold_3(pc_fu_func_nsl_thold_3),
      .pc_fu_func_slp_nsl_thold_3(pc_fu_func_slp_nsl_thold_3),
      .pc_fu_ary_nsl_thold_3(pc_fu_ary_nsl_thold_3),
      .pc_fu_ary_slp_nsl_thold_3(pc_fu_ary_slp_nsl_thold_3),
      .pc_fu_sg_3(pc_fu_sg_3),
      .pc_fu_fce_3(pc_fu_fce_3),
      .pc_pc_ccflush_dc(pc_pc_ccflush_dc),
      .pc_pc_gptr_sl_thold_0(pc_pc_gptr_sl_thold_0),
      .pc_pc_func_sl_thold_0(pc_pc_func_sl_thold_0),
      .pc_pc_func_slp_sl_thold_0(pc_pc_func_slp_sl_thold_0),
      .pc_pc_cfg_sl_thold_0(pc_pc_cfg_sl_thold_0),
      .pc_pc_cfg_slp_sl_thold_0(pc_pc_cfg_slp_sl_thold_0),
      .pc_pc_sg_0(pc_pc_sg_0)
   );

   

   tri_plat #(.WIDTH(6)) lvl7to6_plat(
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .flush(ccflush_dc),

      .din({rtim_sl_thold_7,  func_sl_thold_7,  func_nsl_thold_7,
	    ary_nsl_thold_7,  sg_7,             fce_7}),

      .q(  {rtim_sl_thold_6,  func_sl_thold_6,  func_nsl_thold_6,
	    ary_nsl_thold_6,  sg_6,             fce_6})
   );
       

endmodule

