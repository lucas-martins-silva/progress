/******************************************************************
**
** i03ad107.i - campo: estabelec.idi-control-emis-nfe 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Parcial
&glob val2 Total
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Parcial
&glob val2 Total
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Partial
&glob val2 Total
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
