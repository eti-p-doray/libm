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

/* $Id: mulsf3.S 1174 2007-01-14 15:13:54Z dmix $ */

#include "fp32def.h"
#include "asmdef.h"
#include "fp_split.h"

FUNCTION __mulsf3

/********************************************************************************
 *  Both operand A and B are inf or NaN.
 *
 *  Register pressure = 5
 *
 *  \Input
 *  aM0 : r24 Exponent<0>:Mantissa<22..16>
 *  aM1 : r23 Mantissa<15..8>
 *  aM2 : r22 Mantissa<7..0>
 *  bM0 : r21 Exponent<0>:Mantissa<22..16>
 *  bM1 : r19 Mantissa<15..8>
 *  bM2 : r18 Mantissa<7..0>
 *
 *  \Input - Output
 *  xE   : r25  Exponent of x
 *  xM0  : r24  Mantissa<31..24>
 *  xM1  : r23  Mantissa<23..16>
 *  xM2  : r22  Mantissa<15..8>
 *  xM3  : r27  Mantissa<7..0>
 *  xS  : T Sign of x
 ********************************************************************************/
__fp_ml_ABnonfinite:
  /*
  xM = aM || bM; // if any NaN, it will end up in result
  */
  or  aM2,  bM2;
  or  aM1,  bM1;
  or  aM0,  bM0;

  rjmp  _U(__fp_nonfinite); return (a.sign ^ b.sign) * b;

/********************************************************************************
 *  Operand A is inf or NaN.
 *
 *  Register pressure = 5
 *
 *  \Input
 *  bE  : r21 Exponent<7..0> of x
 *
 *  \Input - Output
 *  xE  : r25  Exponent of x
 *  xM0 : r24  Mantissa<31..24>
 *  xM1 : r23  Mantissa<23..16>
 *  xM2 : r22  Mantissa<15..8>
 *  xM3 : r27  Mantissa<7..0>
 *  xS  : T Sign of x
 ********************************************************************************/
__fp_ml_Anonfinite:
  eor aM3, bM3
  bst xM3, 7;

  /*
  if (bE == 0) {
    return NaN ; // inf * 0 = NaN
  }
  */
  tst bE;
  breq  90;
    rjmp  _U(__fp_nan);
90:

  /*
  if (bE == 0xff) {
    branch ABnonFinite
  }
  */
  cpi bE, 0xff;
  breq  __fp_ml_ABnonfinite;

  /*else {
    return (a.sign ^ b.sign) * inf;
  }
  */
  rjmp  _U(__fp_nonfinite)


/********************************************************************************
 *  Operand B is inf or NaN.
 *
 *  Register pressure = 5
 *
 *  \Input
 *  aE  : r25 Exponent<7..0> of x
 *
 *  \Input - Output
 *  xE  : r25  Exponent of x
 *  xM0 : r24  Mantissa<31..24>
 *  xM1 : r23  Mantissa<23..16>
 *  xM2 : r22  Mantissa<15..8>
 *  xM3 : r27  Mantissa<7..0>
 *  xS  : T Sign of x
 ********************************************************************************/
__fp_ml_Bnonfinite:
  eor aM3, bM3
  bst xM3, 7;
  /*
  if (bE == 0) {
    ret ; // inf * 0 = NaN
  }
  */
  tst aE;
  breq  LA0
  rjmp  _U(__fp_nan);
LA0:

  /*else {
    return (a.sign ^ b.sign) * b;
  }
  */
  X_movw  xM2,  bM2;
  mov   xM1,  bM1;
  rjmp  _U(__fp_nonfinite)


/********************************************************************************
 *  Multiplication of 2 flt32_t
 *
 *  flt32_t operator*(flt32_t a, flt32_t b) {
 *    x = a * b;
 *    return x;
 *  }
 *
 *  Register pressure = 13
 *
 *  \Input
 *  aE  : r25 Sign:Exponent<7..1>
 *  aM0 : r24 Exponent<0>:Mantissa<22..16>
 *  aM1 : r23 Mantissa<15..8>
 *  aM2 : r22 Mantissa<7..0>
 *  bE  : r22 Sign:Exponent<7..1>
 *  bM0 : r21 Exponent<0>:Mantissa<22..16>
 *  bM1 : r19 Mantissa<15..8>
 *  bM2 : r18 Mantissa<7..0>
 *
 *  \Output
 *  xE  : +(aE)   Sign:Exponent<7..1>
 *  xM0 : +(aM0)  Exponent<0>:Mantissa<22..16>
 *  xM1 : +(aM1)  Mantissa<15..8>
 *  xM2 : +(aM2)  Mantissa<7..0>
 *
 *  \Clobber
 *  r0
 *  r27
 *  r28
 *  r30
 *  r31
 ********************************************************************************/

FP_SPLITA_CSUBN
FP_SPLITB_CSUBN

ENTRY __mulsf3

  FP_SPLITA;
  FP_SPLITB;

  cpi aE, 0xff;
  breq  __fp_ml_Anonfinite; if (aE == 0xff)
  cpi bE, 0xff;
  breq  __fp_ml_Bnonfinite; if (bE == 0xff)

	rcall	_U(__mulsf3x)
  rjmp _U(__fp_pack);

ENDFUNC
