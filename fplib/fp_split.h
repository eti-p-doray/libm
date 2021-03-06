/* Copyright (c) 2002  Michael Stumpf  <mistumpf@de.pepperl-fuchs.com>
   Copyright (c) 2006  Dmitry Xmelkov
   Copyright (c) 2015  Etienne Pierre-Doray
   All rights reserved.

   Redistribution and use in source and binary forms, with or without
   modification, are permitted provided that the following conditions are met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in
     the documentation and/or other materials provided with the
     distribution.
   * Neither the name of the copyright holders nor the names of
     contributors may be used to endorse or promote products derived
     from this software without specific prior written permission.

   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
   AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
   IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
   ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
   LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
   CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
   SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
   INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
   ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
   POSSIBILITY OF SUCH DAMAGE. */

/* $Id: fp_split.S 1174 2007-01-14 15:13:54Z dmix $ */

#include "fp32def.h"
#include "asmdef.h"

/******************************************************************************
 *  The __fp_splitA() convert an A flt32_t number to splflt40_t
 *
 *  splflt40_t __fp_splitA(flt40_t a);
 *
 *  Register pressure = 5
 *
 *  \Input
 *  aE  : r25 Sign:Exponent<7..1>
 *  aM0 : r24 Exponent<0>:Mantissa<23..16>
 *  aM1 : r23 Mantissa<15..8>
 *  aM2 : r22 Mantissa<7..0>
 *
 *  \Output
 *  aE  : r25 Exponent<7..0>
 *  aM0 : r24 1:Mantissa<29..23>
 *  aM1 : r23 Mantissa<22..15>
 *  aM2 : r22 Mantissa<14..7>
 *  aM3 : r27 Sign:Mantissa<6..0>
 ******************************************************************************/
.macro  FP_SPLITA
  ldi aM3,  0x01;
  lsl aM0;
  rol aE;
  breq  __fp_splitA1
  ror aM3;
__fp_splitA0:
  ror aM0;
.endm

.macro  FP_SPLITA_CSUBN
__fp_splitA1:
  ror aM3;
  cp  r1, aM2;
  cpc r1, aM1;
  cpc r1, aM0;
  rol aE;
  cpi aE, 1;
  rjmp  __fp_splitA0;
.endm
  


/******************************************************************************
 *  The __fp_splitB() convert an B flt32_t number to splflt40_t
 *
 *  splflt40_t __fp_splitB(flt40_t b);
 *
 *  Register pressure = 5
 *
 *  \Input
 *  bE  : r21 Sign:Exponent<7..1>
 *  bM0 : r20 Exponent<0>:Mantissa<23..16>
 *  bM1 : r19 Mantissa<15..8>
 *  bM2 : r18 Mantissa<7..0>
 *
 *  \Output
 *  bE  : r21 Exponent<7..0>
 *  bM0 : r20 1:Mantissa<29..23>
 *  bM1 : r19 Mantissa<22..15>
 *  bM2 : r18 Mantissa<14..7>
 *  bM3 : r26 Sign:Mantissa<6..0>
 ******************************************************************************/
.macro  FP_SPLITB
  ldi bM3,  0x01;
  lsl bM0;
  rol bE;
  breq  __fp_splitB1
  ror bM3;
__fp_splitB0:
  ror bM0;
.endm

.macro  FP_SPLITB_CSUBN
__fp_splitB1:
  ror bM3;
  cp  r1, bM2;
  cpc r1, bM1;
  cpc r1, bM0;
  rol bE;
  cpi bE, 1;
  rjmp  __fp_splitB0;
.endm
