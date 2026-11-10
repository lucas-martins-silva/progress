/******************************************************************
**
** i01ad265.i Campo: tipo-ad (titulo)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aviso D‚bito
&glob val2 Ocorrˆncia
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Aviso D‚bito
&glob val2 Ocurrencia
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Debit Note
&glob val2 Occurrence
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

