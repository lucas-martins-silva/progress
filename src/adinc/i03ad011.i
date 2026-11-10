/******************************************************************
**
** i03ad011.i Campo: fixado (apl-empr-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pre
&glob val2 Pos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pre
&glob val2 Pos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Pre
&glob val2 Pos
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

