/******************************************************************
**
** i01ad174.i Campo: tipo-log (originado no arquivo log-mensagem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Envia
&glob val2 Recebe
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Env¡a
&glob val2 Recibe
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Send
&glob val2 Rec
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

