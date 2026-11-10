/****************************************************************
**
** adinc/i01ad310.i  Campo: his-tit-eliminados.ind-impl-baixa
**
*****************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Implanta‡Æo Pendente
&glob val2 Implanta‡Æo Atualizado
&glob val3 Baixa Pendente
&glob val4 Baixa Atualizada
&glob val5 Substitui‡Æo
&glob val6 Ordem de Pagamento
&glob val7 Nota Promiss¢ria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Implantaci¢n Pendiente
&glob val2 Implantaci¢n Actualizada
&glob val3 Baja Pendiente 
&glob val4 Baja Actualizada
&glob val5 Substituci¢n
&glob val6 Orden de Pagamento
&glob val7 Pagar‚
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Pending Entry 
&glob val2 Update Entry
&glob val3 Pending Payment
&glob val4 Updating Payment
&glob val5 Replacement
&glob val6 Payment Order
&glob val7 Promissory Note
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

