/******************************************************************
**
** i01ad224.i  Campo: tipo-incl (rel-conta)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Autom tica
&glob val2 Manual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Autom tica
&glob val2 Manual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Automatic
&glob val2 Manual
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

