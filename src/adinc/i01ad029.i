/******************************************************************
**
** i01ad029.i  Campo: tipo-dia (calen-coml)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Util
&glob val2 Sab/Dom
&glob val3 Feriado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 H bil
&glob val2 S b/Dom
&glob val3 Festivo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Work
&glob val2 Sat/Sun
&glob val3 Holiday
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

