/******************************************************************
**
** i01ad208.i Campo: atualiza-ap (..cb/cr - arquivo parfluge)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Batch
&glob val2 On-line
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Batch
&glob val2 On line
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Batch
&glob val2 Online
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

