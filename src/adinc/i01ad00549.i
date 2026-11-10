/***************************
* Include: i01ad00549.i
* Campo: idi-status-envio-xml
***************************/
{include/i-lgcode.i}
&IF "{&LANGUAGE-CODE}" = "POR" &THEN

&glob val1 Gerado com Erro
&glob val2 Enviado
&glob val3 Em Processamento
&glob val4 Autorizado
&glob val5 Rejeitado

&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
