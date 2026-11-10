/******************************************************************
**
**  i04d180.i Campo: ind-tp-alter (mov-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Altera‡Æo
&glob val2 Baixa
&glob val3 Reajuste
&glob val4 Devolu‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Alteraci¢n
&glob val2 Baja
&glob val3 Reajuste
&glob val4 Devoluci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Mod
&glob val2 Payment
&glob val3 Readjust
&glob val4 Return
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

