/******************************************************************
**
**      i02ad180.i - campo transacao (mov-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 IMD
&glob val2 BND
&glob val3 PEF
&glob val4 Outros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 IMD
&glob val2 BND
&glob val3 PEF
&glob val4 Otros
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 ENT
&glob val2 IPT
&glob val3 OPT
&glob val4 Others
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

