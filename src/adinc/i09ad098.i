/******************************************************************
**
**  i09ad098.i Campo: ind-aval (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo Avalia
&glob val2 Somente Atrasos Duplicatas
&glob val3 Limites e Atrasos Duplicatas
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Evalua
&glob val2 Solo Atrasos Copias
&glob val3 L¡mites y Atrasos Copias
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Eval
&glob val2 Only Invoice Delays
&glob val3 Invoice Limits and Delays 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

