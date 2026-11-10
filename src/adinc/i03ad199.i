/******************************************************************
**
** i03ad199.i - campo ch-cobranca (param-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Usa
&glob val2  NÆo usa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Usa
&glob val2  No usa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Use
&glob val2  Not use
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

