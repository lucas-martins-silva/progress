/******************************************************************
**
** i01ad436.i  Campo: tit-ap-bcio.idi-tip-concil
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Manual
&glob val2 Autom tica
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Manual
&glob val2 Autom tica
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Manual
&glob val2 Automatic
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */


