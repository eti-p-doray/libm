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

/* $Id: fp_nan.S 1174 2007-01-14 15:13:54Z dmix $ */

#include "fp32def.h"
#include "asmdef.h"

/********************************************************************************
 *  __fp_splnan() return NaN value in splflt40_t : 0xffc0XXXXXX
 *
 *  Register pressure = 5
 *
 *  \Output
 *  xE  : r25 Exponent<7..0>
 *  xM0 : r24 1:Mantissa<29..21>
 *  xM1 : r23 Mantissa<21..15>
 *  xM2 : r22 Mantissa<14..7>
 *  xM3 : r27 Sign:Mantissa<6..0>
 ********************************************************************************/
ENTRY   __fp_splnan
/********************************************************************************
 *  __fp_nan() return NaN value in flt32_t : 0xffc0XXXX
 *
 *  Register pressure = 4
 *
 *  \Output
 *  xE  : r25 Sign:Exponent<7..1>
 *  xM0 : r24 Exponent<0>:Mantissa<22..16>
 *  xM1 : r23 Mantissa<15..8>
 *  xM2 : r22 Mantissa<7..0>
 ********************************************************************************/
ENTRY   __fp_nan
	ldi	xE,   0xFF
	ldi	xM0,  0xC0
	ret
ENDFUNC
