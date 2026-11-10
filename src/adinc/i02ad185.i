/******************************************************************
**
** i02ad185.i  - campo tipo originado no arquivo movimento
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 D‚bito
&glob val2 Cr‚dito
&glob val3 PD D‚bito
&glob val4 PD Cr‚dito
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 D‚bito
&glob val2 Cr‚dito
&glob val3 PD D‚bito
&glob val4 PD Cr‚dito
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Debit
&glob val2 Credit
&glob val3 Debit
&glob val4 Credit
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

