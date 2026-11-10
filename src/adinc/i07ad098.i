/******************************************************************
**
**  i07ad098.i Campo: gera-difer (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Gera
&glob val2 NÆo Gera
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Gnra
&glob val2 No Gnra
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Gen
&glob val2 Not Gen
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

