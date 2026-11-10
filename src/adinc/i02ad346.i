/******************************************************************
**
** i02ad346.i  Campo: situacao (contrato-exp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pendente Contrato
&glob val2 Contratado
&glob val3 Liquidado
&glob val4 Pendente Documento
&glob val5 Cancelado
&glob val6 Prorrogado
&glob val7 Posi‡Æo Especial
&glob val8 Liquidado Sem T¡tulo
&glob val9 Liquidado Sem Contrato
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pendiente Contrato
&glob val2 Contratado
&glob val3 Pagado
&glob val4 Pendiente Documento
&glob val5 Cancelado
&glob val6 Prorrogado
&glob val7 Posici¢n Especial
&glob val8 Liquidado Sin T¡tulo
&glob val9 Liquidado Sin Contrato
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Contract Holdover
&glob val2 Hired
&glob val3 Paid
&glob val4 Document Holdover
&glob val5 Canceled
&glob val6 Postponed
&glob val7 Special Position
&glob val8 Paid Without Document
&glob val9 Paid Without Contract
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
