/******************************************************************
**
**  i08ad098.i Campo: ind-atraso (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo Informa
&glob val2 Informa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Informa
&glob val2 Informa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Enter
&glob val2 Enter
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

