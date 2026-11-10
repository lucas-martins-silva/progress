/***************************
* Include: i01ad00962.i
* Campo: idi-ult-status-gerac
***************************/
{include/i-lgcode.i}
&IF "{&LANGUAGE-CODE}" = "POR" &THEN

&glob val1 Gerado com Erro
&glob val2 Enviado
&glob val3 Em Processamento
&glob val4 Autorizado
&glob val5 Rejeitado
&glob val6 Em Exclus∆o
&glob val7 Exclu°do

&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
