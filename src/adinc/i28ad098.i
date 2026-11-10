/******************************************************************
**
**  i28ad098.i Campo: ind-emit-retencao (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Respons vel
&glob val2 NÆo Respons vel
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Responsable
&glob val2 No Responsable
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Authority
&glob val2 No Authority
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

