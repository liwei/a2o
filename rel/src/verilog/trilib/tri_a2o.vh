// © IBM Corp. 2020
// This softcore is licensed under and subject to the terms of the CC-BY 4.0
// license (https://creativecommons.org/licenses/by/4.0/legalcode). 
// Additional rights, including the right to physically implement a softcore 
// that is compliant with the required sections of the Power ISA 
// Specification, will be available at no cost via the OpenPOWER Foundation. 
// This README will be updated with additional information when OpenPOWER's 
// license is available.

`ifndef _tri_a2o_vh_
`define _tri_a2o_vh_

`include "tri.vh"

`define THREADS1

`define  gpr_t  3'b000
`define  cr_t  3'b001
`define  lr_t  3'b010
`define  ctr_t  3'b011
`define  xer_t  3'b100
`define  spr_t  3'b101
`define  axu0_t  3'b110
`define  axu1_t  3'b111

`ifdef THREADS1
    `define  THREADS  1
    `define  THREAD_POOL_ENC  0
    `define  THREADS_POOL_ENC  0
`else
    `define  THREADS  2
    `define  THREAD_POOL_ENC  1
    `define  THREADS_POOL_ENC  1
`endif
`define  EFF_IFAR_ARCH  62
`define  EFF_IFAR_WIDTH  20
`define  EFF_IFAR   20
`define  FPR_POOL_ENC 6
`define  REGMODE 6
`define  FPR_POOL 64
`define  REAL_IFAR_WIDTH  42
`define  EMQ_ENTRIES  4
`define  GPR_WIDTH  64
`define  ITAG_SIZE_ENC  7
`define  CPL_Q_DEPTH  32
`define  CPL_Q_DEPTH_ENC  6
`define  GPR_WIDTH_ENC 6
`define  GPR_POOL_ENC  6
`define  GPR_POOL  64
`define  GPR_UCODE_POOL  4
`define  CR_POOL_ENC  5
`define  CR_POOL  24
`define  CR_UCODE_POOL  1
`define  BR_POOL_ENC  3
`define  BR_POOL      8
`define  LR_POOL_ENC  3
`define  LR_POOL  8
`define  LR_UCODE_POOL  0
`define  CTR_POOL_ENC  3
`define  CTR_POOL  8
`define  CTR_UCODE_POOL  0
`define  XER_POOL_ENC  4
`define  XER_POOL  12
`define  XER_UCODE_POOL  0
`define  LDSTQ_ENTRIES  16
`define  LDSTQ_ENTRIES_ENC  4
`define  STQ_ENTRIES  12
`define  STQ_ENTRIES_ENC  4
`define  STQ_FWD_ENTRIES  4		
`define  STQ_DATA_SIZE  64		
`define  DC_SIZE  15			
`define  CL_SIZE  6			
`define  LMQ_ENTRIES  8
`define  LMQ_ENTRIES_ENC  3
`define  LGQ_ENTRIES  8
`define  AXU_SPARE_ENC  3
`define  RV_FX0_ENTRIES  12
`define  RV_FX1_ENTRIES  12
`define  RV_LQ_ENTRIES  16
`define  RV_AXU0_ENTRIES  12
`define  RV_AXU1_ENTRIES  0
`define  RV_FX0_ENTRIES_ENC  4
`define  RV_FX1_ENTRIES_ENC  4
`define  RV_LQ_ENTRIES_ENC  4
`define  RV_AXU0_ENTRIES_ENC  4
`define  RV_AXU1_ENTRIES_ENC  1
`define  UCODE_ENTRIES  8
`define  UCODE_ENTRIES_ENC  3
`define  FXU1_ENABLE  1
`define  TYPE_WIDTH 3
`define  IBUFF_INSTR_WIDTH  70
`define  IBUFF_IFAR_WIDTH  20
`define  IBUFF_DEPTH  16
`define  PF_IAR_BITS  12		
`define  FXU0_PIPE_START 1
`define  FXU0_PIPE_END 8
`define  FXU1_PIPE_START 1
`define  FXU1_PIPE_END 5
`define  LQ_LOAD_PIPE_START 4
`define  LQ_LOAD_PIPE_END 8
`define  LQ_REL_PIPE_START 2
`define  LQ_REL_PIPE_END 4
`define  LOAD_CREDITS   8 
`define  STORE_CREDITS 4
`define  IUQ_ENTRIES   4 		
`define  MMQ_ENTRIES   2 		
`define  CR_WIDTH 4
`define  BUILD_PFETCH  1		
`define  PF_IFAR_WIDTH  12
`define  PFETCH_INITIAL_DEPTH  0	
`define  PFETCH_Q_SIZE_ENC  3		
`define  PFETCH_Q_SIZE  8		
`define  INCLUDE_IERAT_BYPASS  1	
`define  XER_WIDTH  10
`define  INIT_BHT  1			
`define  INIT_IUCR0  16'h4000	
`define  INIT_MASK  2'b10		 
`define  RELQ_INCLUDE  0		

`define  G_BRANCH_LEN  `EFF_IFAR_WIDTH + 1 + 1 + `EFF_IFAR_WIDTH + 3 + 18 + 1

`define  IERAT_BCFG_EPN_0TO15      0
`define  IERAT_BCFG_EPN_16TO31     0
`define  IERAT_BCFG_EPN_32TO47     (2 ** 16) - 1   
`define  IERAT_BCFG_EPN_48TO51     (2 ** 4) - 1    
`define  IERAT_BCFG_RPN_22TO31     0               
`define  IERAT_BCFG_RPN_32TO47     (2 ** 16) - 1   
`define  IERAT_BCFG_RPN_48TO51     (2 ** 4) - 1    
`define  IERAT_BCFG_RPN2_32TO47    0               
`define  IERAT_BCFG_RPN2_48TO51    0               
`define  IERAT_BCFG_ATTR    0                      
   
`define  DERAT_BCFG_EPN_0TO15      0
`define  DERAT_BCFG_EPN_16TO31     0
`define  DERAT_BCFG_EPN_32TO47     (2 ** 16) - 1   
`define  DERAT_BCFG_EPN_48TO51     (2 ** 4) - 1    
`define  DERAT_BCFG_RPN_22TO31     0               
`define  DERAT_BCFG_RPN_32TO47     (2 ** 16) - 1   
`define  DERAT_BCFG_RPN_48TO51     (2 ** 4) - 1    
`define  DERAT_BCFG_RPN2_32TO47    0               
`define  DERAT_BCFG_RPN2_48TO51    0               
`define  DERAT_BCFG_ATTR    0                      
   
`endif  
