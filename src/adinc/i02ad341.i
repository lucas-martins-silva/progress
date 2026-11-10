/******************************************************************
**
** i02ad341.i  Campo: situacao (contrato-imp)
**
*******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pendente Contrato
&glob val2 Contratado
&glob val3 Liquidado
&glob val4 Pendente Documento
&glob val5 Cancelado
&glob val6 Pendente Aprovacao
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pendiente Contrato
&glob val2 Contratado
&glob val3 Liquidado
&glob val4 Pendiente Documento
&glob val5 Cancelado
&glob val6 Pendiente Aprobación
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Contract Holdover
&glob val2 Hired
&glob val3 Paid
&glob val4 Document Holdover
&glob val5 Canceled
&glob val6 Pending Approval
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
