// © IBM Corp. 2020
// This softcore is licensed under and subject to the terms of the CC-BY 4.0
// license (https://creativecommons.org/licenses/by/4.0/legalcode). 
// Additional rights, including the right to physically implement a softcore 
// that is compliant with the required sections of the Power ISA 
// Specification, will be available at no cost via the OpenPOWER Foundation. 
// This README will be updated with additional information when OpenPOWER's 
// license is available.

`timescale 1 ns / 1 ns






module iuq_ic_miss_table(
   input                new_miss,
   input                miss_ci_l2,
   input                reld_r1_val_l2,
   input                r2_crit_qw_l2,
   input                ecc_err,
   input                ecc_err_ue,

   input                addr_match,
   input                iu2_flush,
   input                release_sm,
   input                miss_flushed_l2,
   input                miss_inval_l2,
   input [0:5]          miss_tid_sm_l2,
   input                last_data,

   output [0:5]         miss_tid_sm_d,
   output               reset_state,
   output               request_tag,
   output               write_dir_inval,
   output               write_dir_val,
   output               hold_tid,
   output               data_write,
   output               dir_write,
   output               load_tag,
   output               release_sm_hold
);

   wire [1:23]          miss_sm_pt;

/*
?TABLE miss_sm LISTING(final) OPTIMIZE PARMS(ON-SET, OFF-SET);
*INPUTS*=========================================*OUTPUTS*========================================*
|                                                |                                                |
| new_miss                                       |  miss_tid_sm_d                                 |
| |                                              |  |                                             |
| |                                              |  |      reset_state                            |
| |                                              |  |      |                                      |
| |   miss_ci_l2                                 |  |      |  request_tag                         |
| |   | reld_r1_val_l2                           |  |      |  | write_dir_inval                   |
| |   | | r2_crit_qw_l2                          |  |      |  | | write_dir_val                   |
| |   | | | ecc_err                              |  |      |  | | |                               |
| |   | | | | ecc_err_ue                         |  |      |  | | |                               |
| |   | | | | |                                  |  |      |  | | |                               |
| |   | | | | |                                  |  |      |  | | |                               |
| |   | | | | |   addr_match                     |  |      |  | | |                               |
| |   | | | | |   | iu2_flush                    |  |      |  | | | hold_tid                      | -- this holds 1 tid and gates iu2
| |   | | | | |   | | release_sm                 |  |      |  | | | |                             |
| |   | | | | |   | | | miss_flushed_l2          |  |      |  | | | |                             |
| |   | | | | |   | | | | miss_inval_l2          |  |      |  | | | |                             |
| |   | | | | |   | | | | | miss_tid_sm_l2       |  |      |  | | | |                             |
| |   | | | | |   | | | | | |      last_data     |  |      |  | | | |                             |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   data_write                |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | dir_write               |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | |                       |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | | load_tag              |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | | |                     |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | | | release_sm_hold     |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | | | |                   |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | | | |                   |
| |   | | | | |   | | | | | |      |             |  |      |  | | | |   | | | |                   |
| |   | | | | |   | | | | | 012345 |             |  012345 |  | | | |   | | | |                   |
*TYPE*===========================================+================================================+
| P   P P P P P   P P P P P PPPPPP P             |  PPPPPP P  P P P P   P P P P                   |
*OPTIMIZE*-------------------------------------->|  AAAAAA A  A A A B   A A A A                   |
*TERMS*==========================================+================================================+
| 0   - - - - -   - 0 - - - 100000 -             |  100000 0  0 0 0 0   0 0 0 0                   | -- In idle and stay in idle
| 1   - - - - -   0 0 - - - 100000 -             |  001000 0  1 0 0 0   0 0 0 0                   | -- In idle and we got a miss for my tag not CI and no match
| 1   - - - - -   1 0 0 - - 100000 -             |  010000 0  0 0 0 0   0 0 0 0                   | -- In Idle miss that matches a current tag's outstanding address
| 1   - - - - -   1 0 1 - - 100000 -             |  100000 0  0 0 0 0   0 0 0 0                   | -- In Idle miss that matches a current tag's outstanding address, release_sm
| -   - - - - -   - 1 - - - 100000 -             |  100000 0  0 0 0 0   0 0 0 0                   | -- Flush while in idle
|                                                |                                                |
| -   - - - - -   - 0 0 - - 010000 -             |  010000 0  0 0 0 1   0 0 0 0                   | -- (1) In WaitMiss no valid stay in WaitMiss
| -   - - - - -   - 0 1 - - 010000 -             |  100000 0  0 0 0 1   0 0 0 0                   | -- (1) In WaitMiss got a valid to another tag, release hold
| -   - - - - -   - 1 - - - 010000 -             |  100000 0  0 0 0 1   0 0 0 0                   | -- (1) In WaitMiss and flushed, go to idle
|                                                |                                                |
| -   - 0 - - -   - - - - - 001000 -             |  001000 0  0 0 0 1   0 0 0 0                   | -- (2) In Wait0 no valid to tag, stay in wait0
| -   0 1 - - -   - - - - - 001000 -             |  000100 0  0 0 0 1   0 0 0 0                   | -- (2) In Wait0 Got a valid command and not CI
| -   1 1 - - -   - - - - - 001000 -             |  000010 0  0 0 0 1   0 0 0 0                   | -- (2) In Wait0 Got a valid command and CI
|                                                |                                                |
| -   - 0 1 - -   - - - 0 0 000100 0             |  001000 0  0 1 0 1   1 1 1 0                   | -- (3) In Data0 no valid, goto Wait1 - Crit QW
| -   - 1 1 - -   - - - 0 0 000100 0             |  000100 0  0 1 0 1   1 1 1 0                   | -- (3) In Data0 valid, goto Data1 - Crit QW
| -   - 0 0 - -   - - - 0 0 000100 0             |  001000 0  0 1 0 1   1 1 0 0                   | -- (3) In Data0 no valid, goto Wait1
| -   - 1 0 - -   - - - 0 0 000100 0             |  000100 0  0 1 0 1   1 1 0 0                   | -- (3) In Data0 valid, goto Data1
| -   - 0 - - -   - - - 1 - 000100 0             |  001000 0  0 0 0 1   0 0 0 0                   | -- (3) In Data0 no valid, goto Wait1; Flushed
| -   - 1 - - -   - - - 1 - 000100 0             |  000100 0  0 0 0 1   0 0 0 0                   | -- (3) In Data0 valid, goto Data1; Flushed
| -   - 0 0 - -   - - - 0 1 000100 0             |  001000 0  0 0 0 1   0 0 0 0                   | -- (3) In Data0 no valid, goto Wait1; Invalidated - don't cache
| -   - 1 0 - -   - - - 0 1 000100 0             |  000100 0  0 0 0 1   0 0 0 0                   | -- (3) In Data0 valid, goto Data1; Invalidated - don't cache
| -   - 0 1 - -   - - - 0 1 000100 0             |  001000 0  0 0 0 1   0 0 1 0                   | -- (3) In Data0 no valid, goto Wait1; Invalidated - don't cache
| -   - 1 1 - -   - - - 0 1 000100 0             |  000100 0  0 0 0 1   0 0 1 0                   | -- (3) In Data0 valid, goto Data1; Invalidated - don't cache
|                                                |                                                |
| -   - 0 1 0 0   - - - 0 0 000100 1             |  000001 0  0 0 1 0   1 0 1 1                   | -- (3) In Data3/7 goto CheckECC - Crit QW
| -   - 0 0 0 0   - - - 0 0 000100 1             |  000001 0  0 0 1 0   1 0 0 1                   | -- (3) In Data3/7 goto CheckECC
| -   - 0 1 1 -   - - - 0 0 000100 1             |  000001 0  0 0 0 0   1 0 1 1                   | -- (3) In Data3/7 ECC don't write dir; goto CheckECC - Crit QW
| -   - 0 0 1 -   - - - 0 0 000100 1             |  000001 0  0 0 0 0   1 0 0 1                   | -- (3) In Data3/7 ECC don't write dir; goto CheckECC
| -   - 0 1 - 1   - - - 0 0 000100 1             |  000001 0  0 0 0 0   1 0 1 1                   | -- (3) In Data3/7 UE don't write dir; goto CheckECC - Crit QW
| -   - 0 0 - 1   - - - 0 0 000100 1             |  000001 0  0 0 0 0   1 0 0 1                   | -- (3) In Data3/7 UE don't write dir; goto CheckECC
| -   - 0 - - -   - - - 1 - 000100 1             |  000001 0  0 0 0 0   0 0 0 1                   | -- (3) In Data3/7 goto CheckECC; Flushed
| -   - 0 0 - -   - - - 0 1 000100 1             |  000001 0  0 0 0 0   0 0 0 1                   | -- (3) In Data3/7 goto CheckECC; Invalidated
| -   - 0 1 - -   - - - 0 1 000100 1             |  000001 0  0 0 0 0   0 0 1 1                   | -- (3) In Data3/7 goto CheckECC; Invalidated
|                                                |                                                |
| -   - - - - -   - - - 0 - 000010 -             |  000001 0  0 0 0 0   0 0 1 1                   | -- (4) In Load data to IU2
| -   - - - - -   - - - 1 - 000010 -             |  000001 0  0 0 0 0   0 0 0 1                   | -- (4) In Load data to IU2; Flushed
|                                                |                                                |
| -   - - - 0 0   - - - - - 000001 -             |  100000 1  0 0 0 0   0 0 0 1                   | -- (5) In CheckECC, no error; go to idle
| -   - - - 0 1   - - - - - 000001 -             |  100000 1  0 0 0 0   0 0 0 1                   | -- (5) In CheckECC, uncorrectable error; go to idle
| -   - - - 1 -   - - - - - 000001 -             |  001000 0  0 0 0 0   0 0 0 0                   | -- (5) In CheckECC, correctable error; go to wait state
*END*============================================+================================================+
?TABLE END miss_sm;
*/


assign miss_sm_pt[1] =
    (({ miss_flushed_l2 , miss_inval_l2 , 
    miss_tid_sm_l2[3] , last_data
     }) === 4'b0010);
assign miss_sm_pt[2] =
    (({ reld_r1_val_l2 , miss_tid_sm_l2[3] , 
    last_data }) === 3'b010);
assign miss_sm_pt[3] =
    (({ miss_tid_sm_l2[3] , last_data
     }) === 2'b10);
assign miss_sm_pt[4] =
    (({ ecc_err , ecc_err_ue , 
    miss_flushed_l2 , miss_inval_l2 , 
    miss_tid_sm_l2[3] , last_data
     }) === 6'b000011);
assign miss_sm_pt[5] =
    (({ miss_tid_sm_l2[3] , last_data
     }) === 2'b11);
assign miss_sm_pt[6] =
    (({ iu2_flush , miss_tid_sm_l2[2] , 
    miss_tid_sm_l2[3] , miss_tid_sm_l2[4] , 
    miss_tid_sm_l2[5] }) === 5'b10000);
assign miss_sm_pt[7] =
    (({ miss_tid_sm_l2[0] , miss_tid_sm_l2[3] , 
    miss_tid_sm_l2[4] , miss_tid_sm_l2[5]
     }) === 4'b0000);
assign miss_sm_pt[8] =
    (({ ecc_err , miss_tid_sm_l2[5]
     }) === 2'b01);
assign miss_sm_pt[9] =
    (({ ecc_err , miss_tid_sm_l2[5]
     }) === 2'b11);
assign miss_sm_pt[10] =
    (({ miss_flushed_l2 , miss_tid_sm_l2[4]
     }) === 2'b01);
assign miss_sm_pt[11] =
    (({ miss_tid_sm_l2[4] }) === 1'b1);
assign miss_sm_pt[12] =
    (({ miss_flushed_l2 , miss_inval_l2 , 
    miss_tid_sm_l2[3] }) === 3'b001);
assign miss_sm_pt[13] =
    (({ r2_crit_qw_l2 , miss_flushed_l2 , 
    miss_tid_sm_l2[3] }) === 3'b101);
assign miss_sm_pt[14] =
    (({ reld_r1_val_l2 , miss_tid_sm_l2[3]
     }) === 2'b11);
assign miss_sm_pt[15] =
    (({ reld_r1_val_l2 , miss_tid_sm_l2[2]
     }) === 2'b01);
assign miss_sm_pt[16] =
    (({ miss_ci_l2 , reld_r1_val_l2 , 
    miss_tid_sm_l2[2] }) === 3'b011);
assign miss_sm_pt[17] =
    (({ miss_ci_l2 , reld_r1_val_l2 , 
    miss_tid_sm_l2[2] }) === 3'b111);
assign miss_sm_pt[18] =
    (({ iu2_flush , release_sm , 
    miss_tid_sm_l2[1] }) === 3'b001);
assign miss_sm_pt[19] =
    (({ release_sm , miss_tid_sm_l2[1]
     }) === 2'b11);
assign miss_sm_pt[20] =
    (({ new_miss , addr_match , 
    iu2_flush , release_sm , 
    miss_tid_sm_l2[0] }) === 5'b11001);
assign miss_sm_pt[21] =
    (({ addr_match , release_sm , 
    miss_tid_sm_l2[0] }) === 3'b111);
assign miss_sm_pt[22] =
    (({ new_miss , addr_match , 
    iu2_flush , miss_tid_sm_l2[0]
     }) === 4'b1001);
assign miss_sm_pt[23] =
    (({ new_miss , miss_tid_sm_l2[0]
     }) === 2'b01);
assign miss_tid_sm_d[0] = 
    (miss_sm_pt[6] | miss_sm_pt[8]
     | miss_sm_pt[19] | miss_sm_pt[21]
     | miss_sm_pt[23]);
assign miss_tid_sm_d[1] = 
    (miss_sm_pt[18] | miss_sm_pt[20]
    );
assign miss_tid_sm_d[2] = 
    (miss_sm_pt[2] | miss_sm_pt[9]
     | miss_sm_pt[15] | miss_sm_pt[22]
    );
assign miss_tid_sm_d[3] = 
    (miss_sm_pt[14] | miss_sm_pt[16]
    );
assign miss_tid_sm_d[4] = 
    (miss_sm_pt[17]);
assign miss_tid_sm_d[5] = 
    (miss_sm_pt[5] | miss_sm_pt[11]
    );
assign reset_state = 
    (miss_sm_pt[8]);
assign request_tag = 
    (miss_sm_pt[22]);
assign write_dir_inval = 
    (miss_sm_pt[1]);
assign write_dir_val = 
    (miss_sm_pt[4]);
assign hold_tid = 
    (miss_sm_pt[3] | miss_sm_pt[7]
    );
assign data_write = 
    (miss_sm_pt[12]);
assign dir_write = 
    (miss_sm_pt[1]);
assign load_tag = 
    (miss_sm_pt[10] | miss_sm_pt[13]
    );
assign release_sm_hold = 
    (miss_sm_pt[5] | miss_sm_pt[8]
     | miss_sm_pt[11]);


endmodule

