// © IBM Corp. 2020
// This softcore is licensed under and subject to the terms of the CC-BY 4.0
// license (https://creativecommons.org/licenses/by/4.0/legalcode). 
// Additional rights, including the right to physically implement a softcore 
// that is compliant with the required sections of the Power ISA 
// Specification, will be available at no cost via the OpenPOWER Foundation. 
// This README will be updated with additional information when OpenPOWER's 
// license is available.

`timescale 1 ns / 1 ns




   `include "tri_a2o.vh"
   

module fu_rnd(
   vdd,
   gnd,
   clkoff_b,
   act_dis,
   flush,
   delay_lclkr,
   mpw1_b,
   mpw2_b,
   sg_1,
   thold_1,
   fpu_enable,
   nclk,
   f_rnd_si,
   f_rnd_so,
   ex4_act_b,
   f_nrm_ex6_res,
   f_nrm_ex6_int_lsbs,
   f_nrm_ex6_int_sign,
   f_nrm_ex6_nrm_sticky_dp,
   f_nrm_ex6_nrm_guard_dp,
   f_nrm_ex6_nrm_lsb_dp,
   f_nrm_ex6_nrm_sticky_sp,
   f_nrm_ex6_nrm_guard_sp,
   f_nrm_ex6_nrm_lsb_sp,
   f_nrm_ex6_exact_zero,
   f_tbl_ex6_recip_den,
   f_pic_ex6_invert_sign,
   f_pic_ex6_en_exact_zero,
   f_pic_ex6_k_nan,
   f_pic_ex6_k_inf,
   f_pic_ex6_k_max,
   f_pic_ex6_k_zer,
   f_pic_ex6_k_one,
   f_pic_ex6_k_int_maxpos,
   f_pic_ex6_k_int_maxneg,
   f_pic_ex6_k_int_zer,
   f_pic_ex5_sel_est_b,
   f_tbl_ex6_est_frac,
   f_pic_ex5_rnd_ni_b,
   f_pic_ex5_rnd_nr_b,
   f_pic_ex5_rnd_inf_ok_b,
   f_pic_ex6_uc_inc_lsb,
   f_pic_ex6_uc_guard,
   f_pic_ex6_uc_sticky,
   f_pic_ex6_uc_g_v,
   f_pic_ex6_uc_s_v,
   f_pic_ex5_sel_fpscr_b,
   f_pic_ex5_to_integer_b,
   f_pic_ex5_word_b,
   f_pic_ex5_uns_b,
   f_pic_ex5_sp_b,
   f_pic_ex5_spec_inf_b,
   f_pic_ex5_quiet_b,
   f_pic_ex5_nj_deno,
   f_pic_ex5_unf_en_ue0_b,
   f_pic_ex5_unf_en_ue1_b,
   f_pic_ex5_ovf_en_oe0_b,
   f_pic_ex5_ovf_en_oe1_b,
   f_pic_ex6_round_sign,
   f_scr_ex6_fpscr_rd_dat_dfp,
   f_scr_ex6_fpscr_rd_dat,
   f_eov_ex6_sel_k_f,
   f_eov_ex6_sel_k_e,
   f_eov_ex6_sel_kif_f,
   f_eov_ex6_sel_kif_e,
   f_eov_ex6_ovf_expo,
   f_eov_ex6_ovf_if_expo,
   f_eov_ex6_unf_expo,
   f_eov_ex6_expo_p0,
   f_eov_ex6_expo_p1,
   f_eov_ex6_expo_p0_ue1oe1,
   f_eov_ex6_expo_p1_ue1oe1,
   f_pic_ex6_frsp,
   f_gst_ex6_logexp_v,
   f_gst_ex6_logexp_sign,
   f_gst_ex6_logexp_exp,
   f_gst_ex6_logexp_fract,
   f_dsq_ex6_divsqrt_v,
   f_dsq_ex6_divsqrt_sign,
   f_dsq_ex6_divsqrt_exp,
   f_dsq_ex6_divsqrt_fract,
   f_dsq_ex6_divsqrt_flag_fpscr,
   f_rnd_ex7_res_sign,
   f_rnd_ex7_res_expo,
   f_rnd_ex7_res_frac,
   f_rnd_ex7_flag_up,
   f_rnd_ex7_flag_fi,
   f_rnd_ex7_flag_ox,
   f_rnd_ex7_flag_den,
   f_rnd_ex7_flag_sgn,
   f_rnd_ex7_flag_inf,
   f_rnd_ex7_flag_zer,
   f_rnd_ex7_flag_ux,
   f_mad_ex7_uc_sign,
   f_mad_ex7_uc_zero
);
   parameter     expand_type = 2;		
   inout         vdd;
   inout         gnd;
   input         clkoff_b;		
   input         act_dis;		
   input         flush;		
   input [5:6]   delay_lclkr;		
   input [5:6]   mpw1_b;		
   input [1:1]   mpw2_b;		
   input         sg_1;
   input         thold_1;
   input         fpu_enable;		
   input [0:`NCLK_WIDTH-1]         nclk;
   
   input         f_rnd_si;		
   output        f_rnd_so;		
   input         ex4_act_b;		
   
   input [0:52]  f_nrm_ex6_res;		
   input [1:12]  f_nrm_ex6_int_lsbs;		
   input         f_nrm_ex6_int_sign;		
   input         f_nrm_ex6_nrm_sticky_dp;		
   input         f_nrm_ex6_nrm_guard_dp;		
   input         f_nrm_ex6_nrm_lsb_dp;		
   input         f_nrm_ex6_nrm_sticky_sp;		
   input         f_nrm_ex6_nrm_guard_sp;		
   input         f_nrm_ex6_nrm_lsb_sp;		
   input         f_nrm_ex6_exact_zero;		
   input         f_tbl_ex6_recip_den;		
   
   input         f_pic_ex6_invert_sign;		
   input         f_pic_ex6_en_exact_zero;		
   
   input         f_pic_ex6_k_nan;
   input         f_pic_ex6_k_inf;
   input         f_pic_ex6_k_max;
   input         f_pic_ex6_k_zer;
   input         f_pic_ex6_k_one;
   input         f_pic_ex6_k_int_maxpos;
   input         f_pic_ex6_k_int_maxneg;
   input         f_pic_ex6_k_int_zer;
   
   input         f_pic_ex5_sel_est_b;		
   input [0:26]  f_tbl_ex6_est_frac;		
   
   input         f_pic_ex5_rnd_ni_b;		
   input         f_pic_ex5_rnd_nr_b;		
   input         f_pic_ex5_rnd_inf_ok_b;		
   input         f_pic_ex6_uc_inc_lsb;		
   input         f_pic_ex6_uc_guard;
   input         f_pic_ex6_uc_sticky;
   input         f_pic_ex6_uc_g_v;
   input         f_pic_ex6_uc_s_v;
   
   input         f_pic_ex5_sel_fpscr_b;		
   input         f_pic_ex5_to_integer_b;		
   input         f_pic_ex5_word_b;		
   input         f_pic_ex5_uns_b;		
   input         f_pic_ex5_sp_b;		
   input         f_pic_ex5_spec_inf_b;		
   input         f_pic_ex5_quiet_b;
   input         f_pic_ex5_nj_deno;
   input         f_pic_ex5_unf_en_ue0_b;		
   input         f_pic_ex5_unf_en_ue1_b;		
   input         f_pic_ex5_ovf_en_oe0_b;		
   input         f_pic_ex5_ovf_en_oe1_b;		
   input         f_pic_ex6_round_sign;		
   input [0:3]   f_scr_ex6_fpscr_rd_dat_dfp;		
   input [0:31]  f_scr_ex6_fpscr_rd_dat;		
   
   input         f_eov_ex6_sel_k_f;		
   input         f_eov_ex6_sel_k_e;		
   input         f_eov_ex6_sel_kif_f;		
   input         f_eov_ex6_sel_kif_e;		
   input         f_eov_ex6_ovf_expo;		
   input         f_eov_ex6_ovf_if_expo;		
   input         f_eov_ex6_unf_expo;		
   input [1:13]  f_eov_ex6_expo_p0;		
   input [1:13]  f_eov_ex6_expo_p1;		
   input [3:7]   f_eov_ex6_expo_p0_ue1oe1;		
   input [3:7]   f_eov_ex6_expo_p1_ue1oe1;		
   input         f_pic_ex6_frsp;
   
   input         f_gst_ex6_logexp_v;
   input         f_gst_ex6_logexp_sign;
   input [1:11]  f_gst_ex6_logexp_exp;
   input [0:19]  f_gst_ex6_logexp_fract;
   
   input [0:1]   f_dsq_ex6_divsqrt_v;
   input         f_dsq_ex6_divsqrt_sign;
   input [01:13] f_dsq_ex6_divsqrt_exp;
   input [00:52] f_dsq_ex6_divsqrt_fract;
   input [00:10] f_dsq_ex6_divsqrt_flag_fpscr;
   
   output        f_rnd_ex7_res_sign;		
   output [1:13] f_rnd_ex7_res_expo;		
   output [0:52] f_rnd_ex7_res_frac;		
   
   output        f_rnd_ex7_flag_up;		
   output        f_rnd_ex7_flag_fi;		
   output        f_rnd_ex7_flag_ox;		
   output        f_rnd_ex7_flag_den;		
   output        f_rnd_ex7_flag_sgn;		
   output        f_rnd_ex7_flag_inf;		
   output        f_rnd_ex7_flag_zer;		
   output        f_rnd_ex7_flag_ux;		
   
   output        f_mad_ex7_uc_sign;
   output        f_mad_ex7_uc_zero;
   
   
   
   
   
   parameter     tiup = 1'b1;
   parameter     tidn = 1'b0;
   
   wire          sg_0;		
   wire          thold_0_b;		
   wire          thold_0;
   wire          force_t;
   wire          ex5_act;		
   wire          ex4_act;		
   wire          ex6_act;		
   
   wire          ex6_act_temp;

   (* analysis_not_referenced="TRUE" *) 
   wire [0:2]    act_spare_unused;		
   (* analysis_not_referenced="TRUE" *) 
   wire          flag_spare_unused;		
   wire [0:4]    act_so;		
   wire [0:4]    act_si;		
   wire [0:15]   ex6_ctl_so;		
   wire [0:15]   ex6_ctl_si;		
   wire [0:52]   ex7_frac_so;		
   wire [0:52]   ex7_frac_si;		
   wire [0:13]   ex7_expo_so;		
   wire [0:13]   ex7_expo_si;		
   wire [0:9]    ex7_flag_so;		
   wire [0:9]    ex7_flag_si;		
   wire          ex6_quiet;		
   wire          ex6_quiet_l2;
   wire          ex6_rnd_ni;		
   wire          ex6_rnd_nr;		
   wire          ex6_rnd_inf_ok;		
   wire          ex6_rnd_frc_up;		
   wire          ex6_sel_fpscr;		
   wire          ex6_to_integer;		
   wire          ex6_to_integer_l2;
   wire          ex6_word;		
   wire          ex6_sp;		
   wire          ex6_spec_inf;		
   wire          ex6_flag_den;
   wire          ex6_flag_inf;
   wire          ex6_flag_zer;
   wire          ex6_flag_ux;
   wire          ex6_flag_up;
   wire          ex6_flag_fi;
   wire          ex6_flag_ox;
   wire          ex6_all0_lo;
   wire          ex6_all0_sp;
   wire          ex6_all0;
   wire          ex6_all1;
   wire [0:52]   ex6_frac_c;		
   wire [0:52]   ex6_frac_p1;		
   wire [0:52]   ex6_frac_p0;		
   wire [0:52]   ex6_frac_px;		
   wire [0:52]   ex6_frac_k;		
   wire [0:52]   ex6_frac_misc;
   wire [0:63]   ex6_to_int_data;
   wire          ex6_to_int_imp;
   wire          ex6_p0_sel_dflt;
   
   wire          ex6_up;
   wire          ex6_up_sp;
   wire          ex6_up_dp;
   
   wire          ex6_sel_est_v;
   wire          ex6_logexp_v;
   wire          ex6_divsqrt_v;
   wire          ex6_sel_fpscr_v;
   
   wire [0:52]   ex6_res_frac;		
   wire          ex6_res_sign;
   wire [1:13]   ex6_res_expo;		
   wire [0:52]   ex7_res_frac;		
   wire          ex7_res_sign;
   wire [1:13]   ex7_res_expo;		
   wire          ex7_flag_sgn;
   wire          ex7_flag_den;
   wire          ex7_flag_inf;
   wire          ex7_flag_zer;
   wire          ex7_flag_ux;
   wire          ex7_flag_up;
   wire          ex7_flag_fi;
   wire          ex7_flag_ox;
   
   wire          ex6_sel_up;
   wire          ex6_sel_up_b;
   wire          ex6_sel_up_dp;
   wire          ex6_sel_up_dp_b;
   wire          ex6_gox;
   
   wire          ex6_sgn_result_fp;
   wire          ex6_res_sign_prez;
   wire          ex6_exact_sgn_rst;
   wire          ex6_exact_sgn_set;
   wire          ex6_res_sel_k_f;
   wire          ex6_res_sel_p1_e;
   wire          ex6_res_clip_e;
   wire          ex6_expo_sel_k;
   wire          ex6_expo_sel_k_both;
   wire          ex6_expo_p0_sel_k;
   wire          ex6_expo_p0_sel_int;
   wire          ex6_expo_p0_sel_gst;
   wire          ex6_expo_p0_sel_divsqrt;
   wire          ex6_expo_p0_sel_dflt;
   wire          ex6_expo_p1_sel_k;
   wire          ex6_expo_p1_sel_dflt;
   wire          ex6_sel_p0_joke;
   wire          ex6_sel_p1_joke;
   wire [1:13]   ex6_expo_k;
   wire [1:13]   ex6_expo_p0k;
   wire [1:13]   ex6_expo_p1k;
   wire [1:13]   ex6_expo_p0kx;
   wire [1:13]   ex6_expo_p1kx;
   wire          ex6_unf_en_ue0;
   wire          ex6_unf_en_ue1;
   wire          ex6_ovf_en_oe0;
   wire          ex6_ovf_en_oe1;
   wire          ex6_ov_oe0;
   wire          ex6_k_zero;
   wire          ex6_sel_est;
   wire          ex6_k_inf_nan_maxdp;
   wire          ex6_k_inf_nan_max;
   wire          ex6_k_inf_nan_zer;
   wire          ex6_k_zer_sp;
   wire          ex6_k_notzer;
   wire          ex6_k_max_intmax_nan;
   wire          ex6_k_max_intmax;
   wire          ex6_k_max_intsgn;
   wire          ex6_k_max_intmax_nsp;
   wire          ex6_pwr4_spec_frsp;
   wire          ex6_exact_zero_rnd;
   wire          ex6_rnd_ni_adj;
   wire [0:52]   ex6_nrm_res_b;
   wire [0:27]   ex6_all0_gp2;
   wire [0:13]   ex6_all0_gp4;
   wire [0:6]    ex6_all0_gp8;
   wire [0:3]    ex6_all0_gp16;
   
   wire [0:52]   ex6_frac_c_gp2;
   wire [0:52]   ex6_frac_c_gp4;
   wire [0:52]   ex6_frac_c_gp8;
   wire [0:6]    ex6_frac_g16;
   wire [0:6]    ex6_frac_g32;
   wire [1:6]    ex6_frac_g;
   wire          ex5_quiet;
   wire          ex5_rnd_ni;
   wire          ex5_rnd_nr;
   wire          ex5_rnd_inf_ok;
   wire          ex5_sel_fpscr;
   wire          ex5_to_integer;
   wire          ex5_word;
   wire          ex5_uns;
   wire          ex6_uns;
   wire          ex5_sp;
   wire          ex5_spec_inf;
   wire          ex5_nj_deno;
   wire          ex5_unf_en_ue0;
   wire          ex5_unf_en_ue1;
   wire          ex5_ovf_en_oe0;
   wire          ex5_ovf_en_oe1;
   wire          ex5_sel_est;
   wire          ex6_guard_dp;
   wire          ex6_guard_sp;
   wire          ex6_sticky_dp;
   wire          ex6_sticky_sp;
   wire          unused;
   wire          ex6_nj_deno;
   wire          ex7_nj_deno;
   wire          ex6_clip_deno;		
   wire          ex6_est_log_pow_divsqrt;		
   
   assign unused = ex6_frac_c[0] | f_nrm_ex6_int_lsbs[1];		
   
   
   
   tri_plat  thold_reg_0(
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .flush(flush),
      .din(thold_1),		
      .q(thold_0)
   );
   
   
   tri_plat  sg_reg_0(
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .flush(flush),
      .din(sg_1),
      .q(sg_0)
   );
   
   
   tri_lcbor  lcbor_0(
      .clkoff_b(clkoff_b),
      .thold(thold_0),
      .sg(sg_0),
      .act_dis(act_dis),
      .force_t(force_t),
      .thold_b(thold_0_b)
   );
   
   
   assign ex4_act = ((~ex4_act_b));	
   
   
   tri_rlmreg_p #(.WIDTH(5),  .NEEDS_SRESET(0)) act_lat(
      .force_t(force_t),		
      .d_mode(tiup),							
      .delay_lclkr(delay_lclkr[5]),		
      .mpw1_b(mpw1_b[5]),		
      .mpw2_b(mpw2_b[1]),		
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .thold_b(thold_0_b),
      .sg(sg_0),
      .act(fpu_enable),
      .scout(act_so),
      .scin(act_si),
      .din({ act_spare_unused[0],
             act_spare_unused[1],
             ex4_act,
             ex5_act,
             act_spare_unused[2]}),
      .dout({ act_spare_unused[0],
              act_spare_unused[1],
              ex5_act,
              ex6_act_temp,
              act_spare_unused[2]})
   );
   
   assign ex6_act = ex6_act_temp | ex6_divsqrt_v;		
   
   
   assign ex5_quiet = (~f_pic_ex5_quiet_b);
   assign ex5_rnd_ni = (~f_pic_ex5_rnd_ni_b);
   assign ex5_rnd_nr = (~f_pic_ex5_rnd_nr_b);
   assign ex5_rnd_inf_ok = (~f_pic_ex5_rnd_inf_ok_b);
   assign ex5_sel_fpscr = (~f_pic_ex5_sel_fpscr_b);
   assign ex5_to_integer = (~f_pic_ex5_to_integer_b);
   assign ex5_word = (~f_pic_ex5_word_b);
   assign ex5_uns = (~f_pic_ex5_uns_b);
   assign ex5_sp = (~f_pic_ex5_sp_b);
   assign ex5_spec_inf = (~f_pic_ex5_spec_inf_b);
   assign ex5_nj_deno = f_pic_ex5_nj_deno;
   assign ex5_unf_en_ue0 = (~f_pic_ex5_unf_en_ue0_b);
   assign ex5_unf_en_ue1 = (~f_pic_ex5_unf_en_ue1_b);
   assign ex5_ovf_en_oe0 = (~f_pic_ex5_ovf_en_oe0_b);
   assign ex5_ovf_en_oe1 = (~f_pic_ex5_ovf_en_oe1_b);
   assign ex5_sel_est = (~f_pic_ex5_sel_est_b);
   
   
   tri_rlmreg_p #(.WIDTH(16),  .NEEDS_SRESET(0)) ex6_ctl_lat(
      .force_t(force_t),		
      .d_mode(tiup),							
      .delay_lclkr(delay_lclkr[5]),		
      .mpw1_b(mpw1_b[5]),		
      .mpw2_b(mpw2_b[1]),		
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .thold_b(thold_0_b),
      .sg(sg_0),
      .act(ex5_act),
      .scout(ex6_ctl_so),
      .scin(ex6_ctl_si),
      .din({  ex5_quiet,		
              ex5_rnd_ni,		
              ex5_rnd_nr,		
              ex5_rnd_inf_ok,		
              ex5_sel_fpscr,		
              ex5_to_integer,		
              ex5_word,		
              ex5_sp,		
              ex5_spec_inf,		
              ex5_nj_deno,
              ex5_unf_en_ue0,
              ex5_unf_en_ue1,
              ex5_ovf_en_oe0,
              ex5_ovf_en_oe1,
              ex5_sel_est,
              ex5_uns}),
      .dout({  ex6_quiet_l2,		
               ex6_rnd_ni,		
               ex6_rnd_nr,		
               ex6_rnd_inf_ok,		
               ex6_sel_fpscr,		
               ex6_to_integer_l2,		
               ex6_word,		
               ex6_sp,		
               ex6_spec_inf,		
               ex6_nj_deno,		
               ex6_unf_en_ue0,
               ex6_unf_en_ue1,
               ex6_ovf_en_oe0,
               ex6_ovf_en_oe1,
               ex6_sel_est,
               ex6_uns})
   );
   
   assign ex6_rnd_frc_up = f_pic_ex6_uc_inc_lsb;
   assign ex6_to_integer = ex6_to_integer_l2 & (~ex6_divsqrt_v);
   assign ex6_quiet = ex6_quiet_l2 & (~ex6_divsqrt_v);
   
   
   
   assign ex6_guard_dp = (f_nrm_ex6_nrm_guard_dp & (~f_pic_ex6_uc_g_v)) | (f_pic_ex6_uc_guard & f_pic_ex6_uc_g_v);
   
   assign ex6_guard_sp = (f_nrm_ex6_nrm_guard_sp & (~f_pic_ex6_uc_g_v)) | (f_pic_ex6_uc_guard & f_pic_ex6_uc_g_v);
   
   assign ex6_sticky_dp = (f_nrm_ex6_nrm_sticky_dp) | (f_pic_ex6_uc_sticky & f_pic_ex6_uc_s_v);		
   
   assign ex6_sticky_sp = (f_nrm_ex6_nrm_sticky_sp) | (f_pic_ex6_uc_sticky & f_pic_ex6_uc_s_v);		
   
   assign ex6_up_sp = (ex6_rnd_frc_up) | (ex6_rnd_nr & ex6_guard_sp & ex6_sticky_sp) | (ex6_rnd_nr & ex6_guard_sp & f_nrm_ex6_nrm_lsb_sp) | (ex6_rnd_inf_ok & ex6_guard_sp) | (ex6_rnd_inf_ok & ex6_sticky_sp);		
   
   assign ex6_up_dp = ((ex6_rnd_frc_up) | (ex6_rnd_nr & ex6_guard_dp & ex6_sticky_dp) | (ex6_rnd_nr & ex6_guard_dp & f_nrm_ex6_nrm_lsb_dp) | (ex6_rnd_inf_ok & ex6_guard_dp) | (ex6_rnd_inf_ok & ex6_sticky_dp)) & (~ex6_divsqrt_v);		
   
   assign ex6_up = (ex6_up_sp & ex6_sp) | (ex6_up_dp & (~ex6_sp));
   
   assign ex6_sel_up = ex6_up & (~ex6_divsqrt_v);
   assign ex6_sel_up_b = ((~ex6_up)) | ex6_divsqrt_v;
   assign ex6_sel_up_dp = ex6_up_dp & (~ex6_sp);
   assign ex6_sel_up_dp_b = ((~ex6_up_dp) & (~ex6_sp)) | ex6_divsqrt_v;
   
   assign ex6_gox = (ex6_sp & ex6_guard_sp) | (ex6_sp & ex6_sticky_sp) | ((~ex6_sp) & ex6_guard_dp) | ((~ex6_sp) & ex6_sticky_dp);
   
   
   assign ex6_nrm_res_b[0:52] = (~f_nrm_ex6_res[0:52]);
   
   assign ex6_all0_gp2[0] = ex6_nrm_res_b[0] & ex6_nrm_res_b[1];
   assign ex6_all0_gp2[1] = ex6_nrm_res_b[2] & ex6_nrm_res_b[3];
   assign ex6_all0_gp2[2] = ex6_nrm_res_b[4] & ex6_nrm_res_b[5];
   assign ex6_all0_gp2[3] = ex6_nrm_res_b[6] & ex6_nrm_res_b[7];
   assign ex6_all0_gp2[4] = ex6_nrm_res_b[8] & ex6_nrm_res_b[9];
   assign ex6_all0_gp2[5] = ex6_nrm_res_b[10] & ex6_nrm_res_b[11];
   assign ex6_all0_gp2[6] = ex6_nrm_res_b[12] & ex6_nrm_res_b[13];
   assign ex6_all0_gp2[7] = ex6_nrm_res_b[14] & ex6_nrm_res_b[15];
   assign ex6_all0_gp2[8] = ex6_nrm_res_b[16] & ex6_nrm_res_b[17];
   assign ex6_all0_gp2[9] = ex6_nrm_res_b[18] & ex6_nrm_res_b[19];
   assign ex6_all0_gp2[10] = ex6_nrm_res_b[20] & ex6_nrm_res_b[21];
   assign ex6_all0_gp2[11] = ex6_nrm_res_b[22] & ex6_nrm_res_b[23];		
   assign ex6_all0_gp2[12] = ex6_nrm_res_b[24] & ex6_nrm_res_b[25];
   assign ex6_all0_gp2[13] = ex6_nrm_res_b[26] & ex6_nrm_res_b[27];
   assign ex6_all0_gp2[14] = ex6_nrm_res_b[28] & ex6_nrm_res_b[29];
   assign ex6_all0_gp2[15] = ex6_nrm_res_b[30] & ex6_nrm_res_b[31];
   assign ex6_all0_gp2[16] = ex6_nrm_res_b[32] & ex6_nrm_res_b[33];
   assign ex6_all0_gp2[17] = ex6_nrm_res_b[34] & ex6_nrm_res_b[35];
   assign ex6_all0_gp2[18] = ex6_nrm_res_b[36] & ex6_nrm_res_b[37];
   assign ex6_all0_gp2[19] = ex6_nrm_res_b[38] & ex6_nrm_res_b[39];
   assign ex6_all0_gp2[20] = ex6_nrm_res_b[40] & ex6_nrm_res_b[41];
   assign ex6_all0_gp2[21] = ex6_nrm_res_b[40] & ex6_nrm_res_b[41];
   assign ex6_all0_gp2[22] = ex6_nrm_res_b[42] & ex6_nrm_res_b[43];
   assign ex6_all0_gp2[23] = ex6_nrm_res_b[44] & ex6_nrm_res_b[45];
   assign ex6_all0_gp2[24] = ex6_nrm_res_b[46] & ex6_nrm_res_b[47];
   assign ex6_all0_gp2[25] = ex6_nrm_res_b[48] & ex6_nrm_res_b[49];
   assign ex6_all0_gp2[26] = ex6_nrm_res_b[50] & ex6_nrm_res_b[51];
   assign ex6_all0_gp2[27] = ex6_nrm_res_b[52];
   
   assign ex6_all0_gp4[0] = ex6_all0_gp2[0] & ex6_all0_gp2[1];
   assign ex6_all0_gp4[1] = ex6_all0_gp2[2] & ex6_all0_gp2[3];
   assign ex6_all0_gp4[2] = ex6_all0_gp2[4] & ex6_all0_gp2[5];
   assign ex6_all0_gp4[3] = ex6_all0_gp2[6] & ex6_all0_gp2[7];
   assign ex6_all0_gp4[4] = ex6_all0_gp2[8] & ex6_all0_gp2[9];
   assign ex6_all0_gp4[5] = ex6_all0_gp2[10] & ex6_all0_gp2[11];		
   assign ex6_all0_gp4[6] = ex6_all0_gp2[12] & ex6_all0_gp2[13];
   assign ex6_all0_gp4[7] = ex6_all0_gp2[14] & ex6_all0_gp2[15];
   assign ex6_all0_gp4[8] = ex6_all0_gp2[16] & ex6_all0_gp2[17];
   assign ex6_all0_gp4[9] = ex6_all0_gp2[18] & ex6_all0_gp2[19];
   assign ex6_all0_gp4[10] = ex6_all0_gp2[20] & ex6_all0_gp2[21];
   assign ex6_all0_gp4[11] = ex6_all0_gp2[22] & ex6_all0_gp2[23];
   assign ex6_all0_gp4[12] = ex6_all0_gp2[24] & ex6_all0_gp2[25];
   assign ex6_all0_gp4[13] = ex6_all0_gp2[26] & ex6_all0_gp2[27];
   
   assign ex6_all0_gp8[0] = ex6_all0_gp4[0] & ex6_all0_gp4[1];
   assign ex6_all0_gp8[1] = ex6_all0_gp4[2] & ex6_all0_gp4[3];
   assign ex6_all0_gp8[2] = ex6_all0_gp4[4] & ex6_all0_gp4[5];		
   assign ex6_all0_gp8[3] = ex6_all0_gp4[6] & ex6_all0_gp4[7];
   assign ex6_all0_gp8[4] = ex6_all0_gp4[8] & ex6_all0_gp4[9];
   assign ex6_all0_gp8[5] = ex6_all0_gp4[10] & ex6_all0_gp4[11];
   assign ex6_all0_gp8[6] = ex6_all0_gp4[12] & ex6_all0_gp4[13];
   
   assign ex6_all0_gp16[0] = ex6_all0_gp8[0] & ex6_all0_gp8[1];
   assign ex6_all0_gp16[1] = ex6_all0_gp8[2];		
   assign ex6_all0_gp16[2] = ex6_all0_gp8[3] & ex6_all0_gp8[4];
   assign ex6_all0_gp16[3] = ex6_all0_gp8[5] & ex6_all0_gp8[6];
   
   assign ex6_all0_sp = ex6_all0_gp16[0] & ex6_all0_gp16[1];
   assign ex6_all0_lo = ex6_all0_gp16[2] & ex6_all0_gp16[3];
   
   assign ex6_all0 = ex6_all0_sp & (ex6_sp | ex6_all0_lo);
   
   assign ex6_frac_c_gp2[0] = f_nrm_ex6_res[0] & f_nrm_ex6_res[1];
   assign ex6_frac_c_gp2[1] = f_nrm_ex6_res[1] & f_nrm_ex6_res[2];
   assign ex6_frac_c_gp2[2] = f_nrm_ex6_res[2] & f_nrm_ex6_res[3];
   assign ex6_frac_c_gp2[3] = f_nrm_ex6_res[3] & f_nrm_ex6_res[4];
   assign ex6_frac_c_gp2[4] = f_nrm_ex6_res[4] & f_nrm_ex6_res[5];
   assign ex6_frac_c_gp2[5] = f_nrm_ex6_res[5] & f_nrm_ex6_res[6];
   assign ex6_frac_c_gp2[6] = f_nrm_ex6_res[6] & f_nrm_ex6_res[7];
   assign ex6_frac_c_gp2[7] = f_nrm_ex6_res[7];
   assign ex6_frac_c_gp2[8] = f_nrm_ex6_res[8] & f_nrm_ex6_res[9];
   assign ex6_frac_c_gp2[9] = f_nrm_ex6_res[9] & f_nrm_ex6_res[10];
   assign ex6_frac_c_gp2[10] = f_nrm_ex6_res[10] & f_nrm_ex6_res[11];
   assign ex6_frac_c_gp2[11] = f_nrm_ex6_res[11] & f_nrm_ex6_res[12];
   assign ex6_frac_c_gp2[12] = f_nrm_ex6_res[12] & f_nrm_ex6_res[13];
   assign ex6_frac_c_gp2[13] = f_nrm_ex6_res[13] & f_nrm_ex6_res[14];
   assign ex6_frac_c_gp2[14] = f_nrm_ex6_res[14] & f_nrm_ex6_res[15];
   assign ex6_frac_c_gp2[15] = f_nrm_ex6_res[15];
   assign ex6_frac_c_gp2[16] = f_nrm_ex6_res[16] & f_nrm_ex6_res[17];
   assign ex6_frac_c_gp2[17] = f_nrm_ex6_res[17] & f_nrm_ex6_res[18];
   assign ex6_frac_c_gp2[18] = f_nrm_ex6_res[18] & f_nrm_ex6_res[19];
   assign ex6_frac_c_gp2[19] = f_nrm_ex6_res[19] & f_nrm_ex6_res[20];
   assign ex6_frac_c_gp2[20] = f_nrm_ex6_res[20] & f_nrm_ex6_res[21];
   assign ex6_frac_c_gp2[21] = f_nrm_ex6_res[21] & f_nrm_ex6_res[22];
   assign ex6_frac_c_gp2[22] = f_nrm_ex6_res[22] & f_nrm_ex6_res[23];
   assign ex6_frac_c_gp2[23] = f_nrm_ex6_res[23];
   assign ex6_frac_c_gp2[24] = f_nrm_ex6_res[24] & f_nrm_ex6_res[25];
   assign ex6_frac_c_gp2[25] = f_nrm_ex6_res[25] & f_nrm_ex6_res[26];
   assign ex6_frac_c_gp2[26] = f_nrm_ex6_res[26] & f_nrm_ex6_res[27];
   assign ex6_frac_c_gp2[27] = f_nrm_ex6_res[27] & f_nrm_ex6_res[28];
   assign ex6_frac_c_gp2[28] = f_nrm_ex6_res[28] & f_nrm_ex6_res[29];
   assign ex6_frac_c_gp2[29] = f_nrm_ex6_res[29] & f_nrm_ex6_res[30];
   assign ex6_frac_c_gp2[30] = f_nrm_ex6_res[30] & f_nrm_ex6_res[31];
   assign ex6_frac_c_gp2[31] = f_nrm_ex6_res[31];
   assign ex6_frac_c_gp2[32] = f_nrm_ex6_res[32] & f_nrm_ex6_res[33];
   assign ex6_frac_c_gp2[33] = f_nrm_ex6_res[33] & f_nrm_ex6_res[34];
   assign ex6_frac_c_gp2[34] = f_nrm_ex6_res[34] & f_nrm_ex6_res[35];
   assign ex6_frac_c_gp2[35] = f_nrm_ex6_res[35] & f_nrm_ex6_res[36];
   assign ex6_frac_c_gp2[36] = f_nrm_ex6_res[36] & f_nrm_ex6_res[37];
   assign ex6_frac_c_gp2[37] = f_nrm_ex6_res[37] & f_nrm_ex6_res[38];
   assign ex6_frac_c_gp2[38] = f_nrm_ex6_res[38] & f_nrm_ex6_res[39];
   assign ex6_frac_c_gp2[39] = f_nrm_ex6_res[39];
   assign ex6_frac_c_gp2[40] = f_nrm_ex6_res[40] & f_nrm_ex6_res[41];
   assign ex6_frac_c_gp2[41] = f_nrm_ex6_res[41] & f_nrm_ex6_res[42];
   assign ex6_frac_c_gp2[42] = f_nrm_ex6_res[42] & f_nrm_ex6_res[43];
   assign ex6_frac_c_gp2[43] = f_nrm_ex6_res[43] & f_nrm_ex6_res[44];
   assign ex6_frac_c_gp2[44] = f_nrm_ex6_res[44] & f_nrm_ex6_res[45];
   assign ex6_frac_c_gp2[45] = f_nrm_ex6_res[45] & f_nrm_ex6_res[46];
   assign ex6_frac_c_gp2[46] = f_nrm_ex6_res[46] & f_nrm_ex6_res[47];
   assign ex6_frac_c_gp2[47] = f_nrm_ex6_res[47];
   assign ex6_frac_c_gp2[48] = f_nrm_ex6_res[48] & f_nrm_ex6_res[49];
   assign ex6_frac_c_gp2[49] = f_nrm_ex6_res[49] & f_nrm_ex6_res[50];
   assign ex6_frac_c_gp2[50] = f_nrm_ex6_res[50] & f_nrm_ex6_res[51];
   assign ex6_frac_c_gp2[51] = f_nrm_ex6_res[51] & f_nrm_ex6_res[52];
   assign ex6_frac_c_gp2[52] = f_nrm_ex6_res[52];
   
   assign ex6_frac_c_gp4[0] = ex6_frac_c_gp2[0] & ex6_frac_c_gp2[2];
   assign ex6_frac_c_gp4[1] = ex6_frac_c_gp2[1] & ex6_frac_c_gp2[3];
   assign ex6_frac_c_gp4[2] = ex6_frac_c_gp2[2] & ex6_frac_c_gp2[4];
   assign ex6_frac_c_gp4[3] = ex6_frac_c_gp2[3] & ex6_frac_c_gp2[5];
   assign ex6_frac_c_gp4[4] = ex6_frac_c_gp2[4] & ex6_frac_c_gp2[6];
   assign ex6_frac_c_gp4[5] = ex6_frac_c_gp2[5] & ex6_frac_c_gp2[7];
   assign ex6_frac_c_gp4[6] = ex6_frac_c_gp2[6];
   assign ex6_frac_c_gp4[7] = ex6_frac_c_gp2[7];
   assign ex6_frac_c_gp4[8] = ex6_frac_c_gp2[8] & ex6_frac_c_gp2[10];
   assign ex6_frac_c_gp4[9] = ex6_frac_c_gp2[9] & ex6_frac_c_gp2[11];
   assign ex6_frac_c_gp4[10] = ex6_frac_c_gp2[10] & ex6_frac_c_gp2[12];
   assign ex6_frac_c_gp4[11] = ex6_frac_c_gp2[11] & ex6_frac_c_gp2[13];
   assign ex6_frac_c_gp4[12] = ex6_frac_c_gp2[12] & ex6_frac_c_gp2[14];
   assign ex6_frac_c_gp4[13] = ex6_frac_c_gp2[13] & ex6_frac_c_gp2[15];
   assign ex6_frac_c_gp4[14] = ex6_frac_c_gp2[14];
   assign ex6_frac_c_gp4[15] = ex6_frac_c_gp2[15];
   assign ex6_frac_c_gp4[16] = ex6_frac_c_gp2[16] & ex6_frac_c_gp2[18];
   assign ex6_frac_c_gp4[17] = ex6_frac_c_gp2[17] & ex6_frac_c_gp2[19];
   assign ex6_frac_c_gp4[18] = ex6_frac_c_gp2[18] & ex6_frac_c_gp2[20];
   assign ex6_frac_c_gp4[19] = ex6_frac_c_gp2[19] & ex6_frac_c_gp2[21];
   assign ex6_frac_c_gp4[20] = ex6_frac_c_gp2[20] & ex6_frac_c_gp2[22];
   assign ex6_frac_c_gp4[21] = ex6_frac_c_gp2[21] & ex6_frac_c_gp2[23];
   assign ex6_frac_c_gp4[22] = ex6_frac_c_gp2[22];
   assign ex6_frac_c_gp4[23] = ex6_frac_c_gp2[23];
   assign ex6_frac_c_gp4[24] = ex6_frac_c_gp2[24] & ex6_frac_c_gp2[26];
   assign ex6_frac_c_gp4[25] = ex6_frac_c_gp2[25] & ex6_frac_c_gp2[27];
   assign ex6_frac_c_gp4[26] = ex6_frac_c_gp2[26] & ex6_frac_c_gp2[28];
   assign ex6_frac_c_gp4[27] = ex6_frac_c_gp2[27] & ex6_frac_c_gp2[29];
   assign ex6_frac_c_gp4[28] = ex6_frac_c_gp2[28] & ex6_frac_c_gp2[30];
   assign ex6_frac_c_gp4[29] = ex6_frac_c_gp2[29] & ex6_frac_c_gp2[31];
   assign ex6_frac_c_gp4[30] = ex6_frac_c_gp2[30];
   assign ex6_frac_c_gp4[31] = ex6_frac_c_gp2[31];
   assign ex6_frac_c_gp4[32] = ex6_frac_c_gp2[32] & ex6_frac_c_gp2[34];
   assign ex6_frac_c_gp4[33] = ex6_frac_c_gp2[33] & ex6_frac_c_gp2[35];
   assign ex6_frac_c_gp4[34] = ex6_frac_c_gp2[34] & ex6_frac_c_gp2[36];
   assign ex6_frac_c_gp4[35] = ex6_frac_c_gp2[35] & ex6_frac_c_gp2[37];
   assign ex6_frac_c_gp4[36] = ex6_frac_c_gp2[36] & ex6_frac_c_gp2[38];
   assign ex6_frac_c_gp4[37] = ex6_frac_c_gp2[37] & ex6_frac_c_gp2[39];
   assign ex6_frac_c_gp4[38] = ex6_frac_c_gp2[38];
   assign ex6_frac_c_gp4[39] = ex6_frac_c_gp2[39];
   assign ex6_frac_c_gp4[40] = ex6_frac_c_gp2[40] & ex6_frac_c_gp2[42];
   assign ex6_frac_c_gp4[41] = ex6_frac_c_gp2[41] & ex6_frac_c_gp2[43];
   assign ex6_frac_c_gp4[42] = ex6_frac_c_gp2[42] & ex6_frac_c_gp2[44];
   assign ex6_frac_c_gp4[43] = ex6_frac_c_gp2[43] & ex6_frac_c_gp2[45];
   assign ex6_frac_c_gp4[44] = ex6_frac_c_gp2[44] & ex6_frac_c_gp2[46];
   assign ex6_frac_c_gp4[45] = ex6_frac_c_gp2[45] & ex6_frac_c_gp2[47];
   assign ex6_frac_c_gp4[46] = ex6_frac_c_gp2[46];
   assign ex6_frac_c_gp4[47] = ex6_frac_c_gp2[47];
   assign ex6_frac_c_gp4[48] = ex6_frac_c_gp2[48] & ex6_frac_c_gp2[50];
   assign ex6_frac_c_gp4[49] = ex6_frac_c_gp2[49] & ex6_frac_c_gp2[51];
   assign ex6_frac_c_gp4[50] = ex6_frac_c_gp2[50] & ex6_frac_c_gp2[52];
   assign ex6_frac_c_gp4[51] = ex6_frac_c_gp2[51];
   assign ex6_frac_c_gp4[52] = ex6_frac_c_gp2[52];
   
   assign ex6_frac_c_gp8[0] = ex6_frac_c_gp4[0] & ex6_frac_c_gp4[4];
   assign ex6_frac_c_gp8[1] = ex6_frac_c_gp4[1] & ex6_frac_c_gp4[5];
   assign ex6_frac_c_gp8[2] = ex6_frac_c_gp4[2] & ex6_frac_c_gp4[6];
   assign ex6_frac_c_gp8[3] = ex6_frac_c_gp4[3] & ex6_frac_c_gp4[7];
   assign ex6_frac_c_gp8[4] = ex6_frac_c_gp4[4];
   assign ex6_frac_c_gp8[5] = ex6_frac_c_gp4[5];
   assign ex6_frac_c_gp8[6] = ex6_frac_c_gp4[6];
   assign ex6_frac_c_gp8[7] = ex6_frac_c_gp4[7];
   assign ex6_frac_c_gp8[8] = ex6_frac_c_gp4[8] & ex6_frac_c_gp4[12];
   assign ex6_frac_c_gp8[9] = ex6_frac_c_gp4[9] & ex6_frac_c_gp4[13];
   assign ex6_frac_c_gp8[10] = ex6_frac_c_gp4[10] & ex6_frac_c_gp4[14];
   assign ex6_frac_c_gp8[11] = ex6_frac_c_gp4[11] & ex6_frac_c_gp4[15];
   assign ex6_frac_c_gp8[12] = ex6_frac_c_gp4[12];
   assign ex6_frac_c_gp8[13] = ex6_frac_c_gp4[13];
   assign ex6_frac_c_gp8[14] = ex6_frac_c_gp4[14];
   assign ex6_frac_c_gp8[15] = ex6_frac_c_gp4[15];
   assign ex6_frac_c_gp8[16] = ex6_frac_c_gp4[16] & ex6_frac_c_gp4[20];
   assign ex6_frac_c_gp8[17] = ex6_frac_c_gp4[17] & ex6_frac_c_gp4[21];
   assign ex6_frac_c_gp8[18] = ex6_frac_c_gp4[18] & ex6_frac_c_gp4[22];
   assign ex6_frac_c_gp8[19] = ex6_frac_c_gp4[19] & ex6_frac_c_gp4[23];
   assign ex6_frac_c_gp8[20] = ex6_frac_c_gp4[20];
   assign ex6_frac_c_gp8[21] = ex6_frac_c_gp4[21];
   assign ex6_frac_c_gp8[22] = ex6_frac_c_gp4[22];
   assign ex6_frac_c_gp8[23] = ex6_frac_c_gp4[23];
   assign ex6_frac_c_gp8[24] = ex6_frac_c_gp4[24] & ex6_frac_c_gp4[28];
   assign ex6_frac_c_gp8[25] = ex6_frac_c_gp4[25] & ex6_frac_c_gp4[29];
   assign ex6_frac_c_gp8[26] = ex6_frac_c_gp4[26] & ex6_frac_c_gp4[30];
   assign ex6_frac_c_gp8[27] = ex6_frac_c_gp4[27] & ex6_frac_c_gp4[31];
   assign ex6_frac_c_gp8[28] = ex6_frac_c_gp4[28];
   assign ex6_frac_c_gp8[29] = ex6_frac_c_gp4[29];
   assign ex6_frac_c_gp8[30] = ex6_frac_c_gp4[30];
   assign ex6_frac_c_gp8[31] = ex6_frac_c_gp4[31];
   assign ex6_frac_c_gp8[32] = ex6_frac_c_gp4[32] & ex6_frac_c_gp4[36];
   assign ex6_frac_c_gp8[33] = ex6_frac_c_gp4[33] & ex6_frac_c_gp4[37];
   assign ex6_frac_c_gp8[34] = ex6_frac_c_gp4[34] & ex6_frac_c_gp4[38];
   assign ex6_frac_c_gp8[35] = ex6_frac_c_gp4[35] & ex6_frac_c_gp4[39];
   assign ex6_frac_c_gp8[36] = ex6_frac_c_gp4[36];
   assign ex6_frac_c_gp8[37] = ex6_frac_c_gp4[37];
   assign ex6_frac_c_gp8[38] = ex6_frac_c_gp4[38];
   assign ex6_frac_c_gp8[39] = ex6_frac_c_gp4[39];
   assign ex6_frac_c_gp8[40] = ex6_frac_c_gp4[40] & ex6_frac_c_gp4[44];
   assign ex6_frac_c_gp8[41] = ex6_frac_c_gp4[41] & ex6_frac_c_gp4[45];
   assign ex6_frac_c_gp8[42] = ex6_frac_c_gp4[42] & ex6_frac_c_gp4[46];
   assign ex6_frac_c_gp8[43] = ex6_frac_c_gp4[43] & ex6_frac_c_gp4[47];
   assign ex6_frac_c_gp8[44] = ex6_frac_c_gp4[44];
   assign ex6_frac_c_gp8[45] = ex6_frac_c_gp4[45];
   assign ex6_frac_c_gp8[46] = ex6_frac_c_gp4[46];
   assign ex6_frac_c_gp8[47] = ex6_frac_c_gp4[47];
   assign ex6_frac_c_gp8[48] = ex6_frac_c_gp4[48] & ex6_frac_c_gp4[52];
   assign ex6_frac_c_gp8[49] = ex6_frac_c_gp4[49];
   assign ex6_frac_c_gp8[50] = ex6_frac_c_gp4[50];
   assign ex6_frac_c_gp8[51] = ex6_frac_c_gp4[51];
   assign ex6_frac_c_gp8[52] = ex6_frac_c_gp4[52];
   
   assign ex6_frac_c[0:7] = ex6_frac_c_gp8[0:7] & {8{ex6_frac_g[1]}};
   assign ex6_frac_c[8:15] = ex6_frac_c_gp8[8:15] & {8{ex6_frac_g[2]}};
   assign ex6_frac_c[16:23] = ex6_frac_c_gp8[16:23] & {8{ex6_frac_g[3]}};
   assign ex6_frac_c[24] = (ex6_frac_c_gp8[24] & ex6_frac_g[4]) | ex6_sp;
   assign ex6_frac_c[25:31] = ex6_frac_c_gp8[25:31] & {7{ex6_frac_g[4]}};
   assign ex6_frac_c[32:39] = ex6_frac_c_gp8[32:39] & {8{ex6_frac_g[5]}};
   assign ex6_frac_c[40:47] = ex6_frac_c_gp8[40:47] & {8{ex6_frac_g[6]}};
   assign ex6_frac_c[48:52] = ex6_frac_c_gp8[48:52];
   
   assign ex6_frac_g16[0] = ex6_frac_c_gp8[0] & ex6_frac_c_gp8[8];
   assign ex6_frac_g16[1] = ex6_frac_c_gp8[8] & ex6_frac_c_gp8[16];
   assign ex6_frac_g16[2] = ex6_frac_c_gp8[16];
   assign ex6_frac_g16[3] = ex6_frac_c_gp8[24] & ex6_frac_c_gp8[32];
   assign ex6_frac_g16[4] = ex6_frac_c_gp8[32] & ex6_frac_c_gp8[40];
   assign ex6_frac_g16[5] = ex6_frac_c_gp8[40] & ex6_frac_c_gp8[48];
   assign ex6_frac_g16[6] = ex6_frac_c_gp8[48];
   
   assign ex6_frac_g32[0] = ex6_frac_g16[0] & ex6_frac_g16[2];
   assign ex6_frac_g32[1] = ex6_frac_g16[1];
   assign ex6_frac_g32[2] = ex6_frac_g16[2];
   assign ex6_frac_g32[3] = ex6_frac_g16[3] & ex6_frac_g16[5];
   assign ex6_frac_g32[4] = ex6_frac_g16[4] & ex6_frac_g16[6];
   assign ex6_frac_g32[5] = ex6_frac_g16[5];
   assign ex6_frac_g32[6] = ex6_frac_g16[6];
   
   assign ex6_all1 = ex6_frac_g32[0] & (ex6_sp | ex6_frac_g32[3]);
   assign ex6_frac_g[1] = ex6_frac_g32[1] & (ex6_sp | ex6_frac_g32[3]);
   assign ex6_frac_g[2] = ex6_frac_g32[2] & (ex6_sp | ex6_frac_g32[3]);
   assign ex6_frac_g[3] = ex6_frac_g32[3] | ex6_sp;
   assign ex6_frac_g[4] = ex6_frac_g32[4];
   assign ex6_frac_g[5] = ex6_frac_g32[5];
   assign ex6_frac_g[6] = ex6_frac_g32[6];
   
   
   assign ex6_frac_p1[0] = f_nrm_ex6_res[0] | ex6_frac_c[1];		
   assign ex6_frac_p1[1:51] = f_nrm_ex6_res[1:51] ^ ex6_frac_c[2:52];
   assign ex6_frac_p1[52] = (~f_nrm_ex6_res[52]);
   
   
   assign ex6_to_int_data[0] = f_nrm_ex6_int_sign;		
   assign ex6_to_int_data[1:10] = f_nrm_ex6_res[1:10] | {10{ex6_word}};		
   assign ex6_to_int_data[11] = f_nrm_ex6_res[11] | (~ex6_to_int_imp) | ex6_word;		
   assign ex6_to_int_imp = f_nrm_ex6_res[1] | f_nrm_ex6_res[2] | f_nrm_ex6_res[3] | f_nrm_ex6_res[4] | f_nrm_ex6_res[5] | f_nrm_ex6_res[6] | f_nrm_ex6_res[7] | f_nrm_ex6_res[8] | f_nrm_ex6_res[9] | f_nrm_ex6_res[10] | f_nrm_ex6_res[11] | ex6_word;		
   assign ex6_to_int_data[12] = f_nrm_ex6_res[12] | ex6_word;		
   assign ex6_to_int_data[13:31] = f_nrm_ex6_res[13:31] & {19{(~ex6_word)}};		
   assign ex6_to_int_data[32:52] = f_nrm_ex6_res[32:52];
   assign ex6_to_int_data[53:63] = f_nrm_ex6_int_lsbs[2:12];
   
   assign ex6_p0_sel_dflt = (~ex6_to_integer) & (~ex6_sel_est) & (~f_gst_ex6_logexp_v) & (~ex6_divsqrt_v) & (~ex6_sel_fpscr);
   
   assign ex6_sel_est_v = ex6_sel_est & (~ex6_divsqrt_v);
   assign ex6_logexp_v = f_gst_ex6_logexp_v & (~ex6_divsqrt_v);
   assign ex6_divsqrt_v = |(f_dsq_ex6_divsqrt_v);
   assign ex6_sel_fpscr_v = ex6_sel_fpscr & (~ex6_divsqrt_v);
   
   assign ex6_frac_misc[0] = (ex6_sel_est_v & f_tbl_ex6_est_frac[0]) | (ex6_logexp_v & f_gst_ex6_logexp_fract[0]) | (ex6_divsqrt_v & f_dsq_ex6_divsqrt_fract[0]);
   
   assign ex6_frac_misc[1:16] = ({16{ex6_sel_est_v}} & f_tbl_ex6_est_frac[1:16]) | 
                                ({16{ex6_logexp_v}} & f_gst_ex6_logexp_fract[1:16]) | 
                                ({16{ex6_divsqrt_v}} & f_dsq_ex6_divsqrt_fract[1:16]);
   
   assign ex6_frac_misc[17:19] = ({3{ex6_sel_est_v}} & f_tbl_ex6_est_frac[17:19]) | 
                                 ({3{ex6_sel_fpscr_v}} & f_scr_ex6_fpscr_rd_dat_dfp[0:2]) | 
                                 ({3{ex6_logexp_v}} & f_gst_ex6_logexp_fract[17:19]) | 
                                 ({3{ex6_divsqrt_v}} & f_dsq_ex6_divsqrt_fract[17:19]);
   
   assign ex6_frac_misc[20] = ((ex6_sel_est_v) & f_tbl_ex6_est_frac[20]) | ((ex6_sel_fpscr_v) & f_scr_ex6_fpscr_rd_dat_dfp[3]) | ((ex6_divsqrt_v) & f_dsq_ex6_divsqrt_fract[20]);
   
   assign ex6_frac_misc[21:26] = ({6{ex6_sel_est_v}} & f_tbl_ex6_est_frac[21:26]) | 
                                 ({6{ex6_sel_fpscr_v}} & f_scr_ex6_fpscr_rd_dat[0:5]) | 
                                 ({6{ex6_divsqrt_v}} & f_dsq_ex6_divsqrt_fract[21:26]);
   
   assign ex6_frac_misc[27:52] = ({26{ex6_sel_fpscr_v}} & f_scr_ex6_fpscr_rd_dat[6:31]) | 
                                 ({26{ex6_divsqrt_v}} & f_dsq_ex6_divsqrt_fract[27:52]);
   
   assign ex6_frac_p0[0] = (ex6_p0_sel_dflt & f_nrm_ex6_res[0]) | (ex6_to_integer & ex6_to_int_imp) | (ex6_frac_misc[0]);		
   assign ex6_frac_p0[1] = (ex6_p0_sel_dflt & f_nrm_ex6_res[1]) | (ex6_to_integer & ex6_to_int_data[12]) | (ex6_frac_misc[1]) | (ex6_quiet);		
   assign ex6_frac_p0[2:19] = ({18{ex6_p0_sel_dflt}} & f_nrm_ex6_res[2:19]) | 
                              ({18{ex6_to_integer}} & ex6_to_int_data[13:30]) | 
                              (ex6_frac_misc[2:19]);		
   
   assign ex6_frac_p0[20:52] = ({33{ex6_p0_sel_dflt}} & f_nrm_ex6_res[20:52]) | 
                               ({33{ex6_to_integer}} & ex6_to_int_data[31:63]) | 
                               (ex6_frac_misc[20:52]);		
   
   assign ex6_frac_px[0:23] = ({24{ex6_sel_up_b}} & ex6_frac_p0[0:23]) | 
                              ({24{ex6_sel_up}}   & ex6_frac_p1[0:23]);
   
   assign ex6_frac_px[24:52] = ({29{ex6_sel_up_dp_b}} & ex6_frac_p0[24:52]) | 
                               ({29{ex6_sel_up_dp}}   & ex6_frac_p1[24:52]);
   
   
   assign ex6_frac_k[0] = ex6_k_notzer | ex6_word;		
   assign ex6_frac_k[1] = ex6_k_max_intmax_nan | ex6_word;
   assign ex6_frac_k[2:20] = {19{(ex6_k_max_intmax & (~ex6_word))}};
   assign ex6_frac_k[21] = ex6_k_max_intsgn;		
   assign ex6_frac_k[22] = ex6_k_max_intmax;
   assign ex6_frac_k[23] = ex6_k_max_intmax;
   assign ex6_frac_k[24:52] = {29{ex6_k_max_intmax_nsp}};
   
   assign ex6_k_notzer = (~(f_pic_ex6_k_zer | f_pic_ex6_k_int_zer | f_pic_ex6_k_int_maxneg));		
   assign ex6_k_max_intmax_nan = f_pic_ex6_k_max | f_pic_ex6_k_int_maxpos | f_pic_ex6_k_nan;
   assign ex6_k_max_intmax = f_pic_ex6_k_max | f_pic_ex6_k_int_maxpos;
   assign ex6_k_max_intmax_nsp = (f_pic_ex6_k_max | f_pic_ex6_k_int_maxpos) & (~ex6_sp);
   
   assign ex6_k_max_intsgn = (f_pic_ex6_k_max) | (f_pic_ex6_k_int_maxpos & (~ex6_word)) | (f_pic_ex6_k_int_maxneg & ex6_word & (~ex6_uns)) | (f_pic_ex6_k_int_maxpos & ex6_word & ex6_uns);		
   
   assign ex6_res_frac[0] = (ex6_frac_k[0] & ex6_res_sel_k_f) | (ex6_frac_px[0] & (~ex6_res_sel_k_f));		
   
   assign ex6_res_frac[1:52] = (ex6_frac_k[1:52] & {52{ex6_res_sel_k_f}}) | 
                               (ex6_frac_px[1:52] & {52{(~ex6_res_sel_k_f)}});
   
   
   
   assign ex6_k_inf_nan_max = f_pic_ex6_k_nan | f_pic_ex6_k_inf | f_pic_ex6_k_max;
   
   assign ex6_k_inf_nan_maxdp = f_pic_ex6_k_nan | f_pic_ex6_k_inf | (f_pic_ex6_k_max & (~ex6_sp));
   
   assign ex6_k_inf_nan_zer = f_pic_ex6_k_nan | f_pic_ex6_k_inf | f_pic_ex6_k_zer;
   
   assign ex6_k_zer_sp = f_pic_ex6_k_zer & ex6_sp;
   
   assign ex6_expo_k[1] = tidn;		
   assign ex6_expo_k[2] = tidn;		
   assign ex6_expo_k[3] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word;		
   assign ex6_expo_k[4] = ex6_k_inf_nan_maxdp | f_pic_ex6_k_int_maxpos | ex6_k_zer_sp | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[5] = ex6_k_inf_nan_maxdp | f_pic_ex6_k_int_maxpos | ex6_k_zer_sp | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[6] = ex6_k_inf_nan_maxdp | f_pic_ex6_k_int_maxpos | ex6_k_zer_sp | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[7] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[8] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[9] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[10] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[11] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[12] = ex6_k_inf_nan_max | f_pic_ex6_k_int_maxpos | ex6_word | f_pic_ex6_k_one;		
   assign ex6_expo_k[13] = ex6_k_inf_nan_zer | f_pic_ex6_k_int_maxpos | ex6_k_zero | f_pic_ex6_k_int_maxneg | ex6_word | f_pic_ex6_k_one;		
   
   
   assign ex6_expo_p0k[1:13] = (ex6_expo_k[1:13] &                            {13{ex6_expo_p0_sel_k}}) | 
                               (({tidn, tidn, ex6_to_int_data[1:11]}) &       {13{ex6_expo_p0_sel_int}}) | 
                               (({tidn, tidn, f_gst_ex6_logexp_exp[1:11]}) &  {13{ex6_expo_p0_sel_gst}}) | 
                               ((f_dsq_ex6_divsqrt_exp[1:13]) &               {13{ex6_expo_p0_sel_divsqrt}}) | 
                               (({{12{tidn}}, tiup}) &                        {13{ex6_sel_fpscr_v}}) | 
                               (f_eov_ex6_expo_p0[1:13] &                     {13{ex6_expo_p0_sel_dflt}});
   
   assign ex6_expo_p1k[1:13] = (ex6_expo_k[1:13] &         {13{ex6_expo_p1_sel_k}}) | 
                               (f_eov_ex6_expo_p1[1:13] &  {13{ex6_expo_p1_sel_dflt}});
   
   assign ex6_expo_p0kx[1:7] = (ex6_expo_p0k[1:7] &                              {7{(~ex6_sel_p0_joke)}}) | 
                               (({tidn, tidn, f_eov_ex6_expo_p0_ue1oe1[3:7]}) &  {7{ex6_sel_p0_joke}});
   
   assign ex6_expo_p1kx[1:7] = (ex6_expo_p1k[1:7] &                             {7{(~ex6_sel_p1_joke)}}) | 
                               (({tidn, tidn, f_eov_ex6_expo_p1_ue1oe1[3:7]}) & {7{ex6_sel_p1_joke}});
   
   assign ex6_expo_p0kx[8:12] = ex6_expo_p0k[8:12];		
   assign ex6_expo_p1kx[8:12] = ex6_expo_p1k[8:12];		
   
   
   assign ex6_expo_p0kx[13] = ex6_expo_p0k[13];		
   assign ex6_expo_p1kx[13] = ex6_expo_p1k[13];		
   
   assign ex6_res_expo[1] = (ex6_expo_p0kx[1] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[1] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[2] = (ex6_expo_p0kx[2] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[2] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[3] = (ex6_expo_p0kx[3] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[3] & ex6_res_sel_p1_e);		
   
   assign ex6_res_expo[4] = (ex6_expo_p0kx[4] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_sp & (~ex6_res_sel_p1_e) & ex6_res_clip_e) | (ex6_expo_p1kx[4] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[5] = (ex6_expo_p0kx[5] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_sp & (~ex6_res_sel_p1_e) & ex6_res_clip_e) | (ex6_expo_p1kx[5] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[6] = (ex6_expo_p0kx[6] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_sp & (~ex6_res_sel_p1_e) & ex6_res_clip_e) | (ex6_expo_p1kx[6] & ex6_res_sel_p1_e);		
   
   assign ex6_res_expo[7] = (ex6_expo_p0kx[7] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[7] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[8] = (ex6_expo_p0kx[8] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[8] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[9] = (ex6_expo_p0kx[9] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[9] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[10] = (ex6_expo_p0kx[10] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[10] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[11] = (ex6_expo_p0kx[11] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[11] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[12] = (ex6_expo_p0kx[12] & (~ex6_res_sel_p1_e) & (~ex6_res_clip_e)) | (ex6_expo_p1kx[12] & ex6_res_sel_p1_e);		
   assign ex6_res_expo[13] = (ex6_expo_p0kx[13] & (~ex6_res_sel_p1_e)) | ((~ex6_res_sel_p1_e) & ex6_res_clip_e) | (ex6_expo_p1kx[13] & ex6_res_sel_p1_e);		
   
   
   assign ex6_sgn_result_fp = f_pic_ex6_round_sign ^ f_pic_ex6_invert_sign;
   
   assign ex6_res_sign_prez = (ex6_sgn_result_fp & (~((ex6_to_integer | f_gst_ex6_logexp_v | ex6_divsqrt_v) & (~ex6_expo_sel_k)))) | (ex6_to_int_data[0] & (ex6_to_integer & (~ex6_expo_sel_k)) & (~ex6_word)) | (f_gst_ex6_logexp_sign & (f_gst_ex6_logexp_v & (~ex6_expo_sel_k))) | (f_dsq_ex6_divsqrt_sign & (ex6_divsqrt_v & (~ex6_expo_sel_k)));
   
   assign ex6_exact_zero_rnd = f_nrm_ex6_exact_zero & (~f_nrm_ex6_nrm_sticky_dp);		
   
   assign ex6_rnd_ni_adj = ex6_rnd_ni ^ f_pic_ex6_invert_sign;
   
   assign ex6_exact_sgn_rst = f_pic_ex6_en_exact_zero & ex6_exact_zero_rnd & (~ex6_rnd_ni_adj);
   assign ex6_exact_sgn_set = f_pic_ex6_en_exact_zero & ex6_exact_zero_rnd & ex6_rnd_ni_adj;
   
   assign ex6_res_sign = (((ex6_res_sign_prez & (~ex6_exact_sgn_rst)) | ex6_exact_sgn_set) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[6] & ex6_divsqrt_v);
   
   
   assign ex6_res_sel_k_f = ((f_eov_ex6_sel_kif_f & ex6_all1 & ex6_up) | (f_eov_ex6_sel_k_f) | (ex6_clip_deno) | (ex6_sel_est_v & f_tbl_ex6_recip_den & ex6_nj_deno)) & (~ex6_divsqrt_v);		
   
   
   assign ex6_res_sel_p1_e = ex6_all1 & ex6_up & (~ex6_divsqrt_v);
   
   assign ex6_est_log_pow_divsqrt = f_gst_ex6_logexp_v | ex6_sel_est | ex6_divsqrt_v;
   
   assign ex6_res_clip_e = (ex6_unf_en_ue0 & (~f_nrm_ex6_res[0]) & (~ex6_expo_sel_k) & (~ex6_est_log_pow_divsqrt)) | (ex6_unf_en_ue0 & f_eov_ex6_unf_expo & (~ex6_expo_sel_k) & (~ex6_est_log_pow_divsqrt)) | (ex6_all0 & (~ex6_to_integer) & (~ex6_expo_sel_k) & (~ex6_est_log_pow_divsqrt)) | (ex6_nj_deno & (~f_nrm_ex6_res[0]) & (~ex6_expo_sel_k) & (~ex6_est_log_pow_divsqrt));		
   
   assign ex6_clip_deno = (ex6_nj_deno & (~f_nrm_ex6_res[0]) & (~ex6_expo_sel_k) & (~ex6_est_log_pow_divsqrt));		
   
   assign ex6_expo_sel_k = f_eov_ex6_sel_k_e;
   assign ex6_expo_sel_k_both = f_eov_ex6_sel_k_e | f_eov_ex6_sel_kif_e;
   
   assign ex6_expo_p0_sel_k = ex6_expo_sel_k & (~ex6_divsqrt_v);
   assign ex6_expo_p0_sel_gst = (~ex6_expo_sel_k) & f_gst_ex6_logexp_v & (~ex6_divsqrt_v);
   assign ex6_expo_p0_sel_int = (~ex6_expo_sel_k) & ex6_to_integer & (~ex6_divsqrt_v);
   assign ex6_expo_p0_sel_dflt = (~ex6_expo_sel_k) & (~ex6_to_integer) & (~f_gst_ex6_logexp_v) & (~ex6_divsqrt_v);
   assign ex6_expo_p0_sel_divsqrt = ex6_divsqrt_v;
   
   assign ex6_expo_p1_sel_k = ex6_expo_sel_k_both;
   assign ex6_expo_p1_sel_dflt = (~ex6_expo_sel_k_both);
   
   assign ex6_sel_p0_joke = ((ex6_unf_en_ue1 & f_eov_ex6_unf_expo) | (ex6_ovf_en_oe1 & f_eov_ex6_ovf_expo)) & (~ex6_divsqrt_v);		
   
   assign ex6_sel_p1_joke = (ex6_unf_en_ue1 & f_eov_ex6_unf_expo) | (ex6_ovf_en_oe1 & f_eov_ex6_ovf_expo) | (ex6_ovf_en_oe1 & f_eov_ex6_ovf_if_expo);		
   
   
   assign ex6_pwr4_spec_frsp = ex6_unf_en_ue1 & (~f_nrm_ex6_res[0]) & f_pic_ex6_frsp;
   
   assign ex6_flag_ox = (f_eov_ex6_ovf_expo & (~ex6_divsqrt_v)) | (f_eov_ex6_ovf_if_expo & ex6_all1 & ex6_up & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[0] & ex6_divsqrt_v);
   
   assign ex6_ov_oe0 = ex6_flag_ox & ex6_ovf_en_oe0;
   
   assign ex6_flag_inf = (((ex6_spec_inf) | (ex6_ov_oe0 & (~f_pic_ex6_k_max))) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[9] & ex6_divsqrt_v);		
   
   
   assign ex6_flag_up = ((ex6_ov_oe0 | ex6_up) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[4] & ex6_divsqrt_v);		
   
   assign ex6_flag_fi = ((ex6_ov_oe0 | ex6_gox) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[5] & ex6_divsqrt_v);		
   
   assign ex6_flag_ux = (((ex6_unf_en_ue0 & (~f_nrm_ex6_res[0]) & (~ex6_exact_zero_rnd) & ex6_gox & (~ex6_sel_est)) | (ex6_unf_en_ue0 & f_eov_ex6_unf_expo & (~ex6_exact_zero_rnd) & ex6_gox) | (ex6_unf_en_ue1 & f_eov_ex6_unf_expo & (~ex6_exact_zero_rnd)) | (ex6_unf_en_ue1 & f_eov_ex6_unf_expo & ex6_sel_est) | (ex6_unf_en_ue0 & f_eov_ex6_unf_expo & ex6_sel_est) | (ex6_pwr4_spec_frsp)) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[1] & ex6_divsqrt_v);		
   
   assign ex6_k_zero = f_pic_ex6_k_zer | f_pic_ex6_k_int_zer;
   
   assign ex6_flag_zer = ((((~ex6_sel_est) & (~ex6_res_sel_k_f) & ex6_all0 & (~ex6_up)) | (ex6_res_sel_k_f & ex6_k_zero)) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[8] & ex6_divsqrt_v);		
   
   assign ex6_flag_den = ((((~ex6_sel_est) & (~ex6_res_frac[0])) | (ex6_sel_est & f_tbl_ex6_recip_den) | (ex6_sel_est & ex6_unf_en_ue0 & f_eov_ex6_unf_expo)) & (~ex6_divsqrt_v)) | (f_dsq_ex6_divsqrt_flag_fpscr[10] & ex6_divsqrt_v);		
   
   
   
   tri_rlmreg_p #(.WIDTH(53),  .NEEDS_SRESET(0)) ex7_frac_lat(
      .force_t(force_t),		
      .d_mode(tiup),							
      .delay_lclkr(delay_lclkr[6]),		
      .mpw1_b(mpw1_b[6]),		
      .mpw2_b(mpw2_b[1]),		
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .thold_b(thold_0_b),
      .sg(sg_0),
      .act(ex6_act),
      .scout(ex7_frac_so),
      .scin(ex7_frac_si),
      .din(ex6_res_frac[0:52]),
      .dout(ex7_res_frac[0:52])		
   );
   
   
   tri_rlmreg_p #(.WIDTH(14),  .NEEDS_SRESET(0)) ex7_expo_lat(
      .force_t(force_t),		
      .d_mode(tiup),							
      .delay_lclkr(delay_lclkr[6]),		
      .mpw1_b(mpw1_b[6]),		
      .mpw2_b(mpw2_b[1]),		
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .thold_b(thold_0_b),
      .sg(sg_0),
      .act(ex6_act),
      .scout(ex7_expo_so),
      .scin(ex7_expo_si),
      .din({ex6_res_sign,
            ex6_res_expo[1:13]}),
      .dout({ex7_res_sign,		
             ex7_res_expo[1:13]})		
   );
   
   
   tri_rlmreg_p #(.WIDTH(10),  .NEEDS_SRESET(1)) ex7_flag_lat(
      .force_t(force_t),		
      .d_mode(tiup),							
      .delay_lclkr(delay_lclkr[6]),		
      .mpw1_b(mpw1_b[6]),		
      .mpw2_b(mpw2_b[1]),		
      .vd(vdd),
      .gd(gnd),
      .nclk(nclk),
      .thold_b(thold_0_b),
      .sg(sg_0),
      .act(ex6_act),
      .scout(ex7_flag_so),
      .scin(ex7_flag_si),
      .din({  flag_spare_unused,
              ex6_res_sign,
              ex6_flag_den,
              ex6_flag_inf,
              ex6_flag_zer,
              ex6_flag_ux,
              ex6_flag_up,
              ex6_flag_fi,
              ex6_flag_ox,
              ex6_nj_deno}),
      .dout({  flag_spare_unused,		
               ex7_flag_sgn,		
               ex7_flag_den,		
               ex7_flag_inf,		
               ex7_flag_zer,		
               ex7_flag_ux,		
               ex7_flag_up,		
               ex7_flag_fi,		
               ex7_flag_ox,		
               ex7_nj_deno})		
   );
   
   assign f_rnd_ex7_res_sign = ex7_res_sign;		
   assign f_rnd_ex7_res_expo[1:13] = ex7_res_expo[1:13];		
   assign f_rnd_ex7_res_frac[0:52] = ex7_res_frac[0:52];		
   
   assign f_rnd_ex7_flag_sgn = ex7_flag_sgn;		
   assign f_rnd_ex7_flag_den = ex7_flag_den & (~ex7_nj_deno);		
   assign f_rnd_ex7_flag_inf = ex7_flag_inf;		
   assign f_rnd_ex7_flag_zer = ex7_flag_zer | (ex7_flag_den & ex7_nj_deno);		
   assign f_rnd_ex7_flag_ux = ex7_flag_ux & (~(ex7_flag_den & ex7_nj_deno));		
   assign f_rnd_ex7_flag_up = ex7_flag_up & (~(ex7_flag_den & ex7_nj_deno));		
   assign f_rnd_ex7_flag_fi = ex7_flag_fi & (~(ex7_flag_den & ex7_nj_deno));		
   assign f_rnd_ex7_flag_ox = ex7_flag_ox;		
   
   assign f_mad_ex7_uc_sign = ex7_res_sign;		
   assign f_mad_ex7_uc_zero = ex7_flag_zer & (~ex7_flag_fi);		
   
   
   assign act_si[0:4] = {act_so[1:4], f_rnd_si};
   assign ex6_ctl_si[0:15] = {ex6_ctl_so[1:15], act_so[0]};
   assign ex7_frac_si[0:52] = {ex7_frac_so[1:52], ex6_ctl_so[0]};
   assign ex7_expo_si[0:13] = {ex7_expo_so[1:13], ex7_frac_so[0]};
   assign ex7_flag_si[0:9] = {ex7_flag_so[1:9], ex7_expo_so[0]};
   assign f_rnd_so = ex7_flag_so[0];
   
endmodule
