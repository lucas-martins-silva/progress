/******************************************************************
**
** i23ad098.i  Campo: tp-qt-prg
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 L¡quida
&glob val2 Acumulada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 L¡quida
&glob val2 Acumulada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Net
&glob val2 Accum
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

