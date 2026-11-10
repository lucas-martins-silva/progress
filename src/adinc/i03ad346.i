/******************************************************************
**
** i03ad346.i  Campo: emprestimo (contrato-imp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 ACC
&glob val2 ACE
&glob val3 Pr‚-Pagamento Liquida‡Æo
&glob val4 Pr‚-Pagamento Remessa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 ACC
&glob val2 ACE
&glob val3 Pre-Pago Liquidaci¢n
&glob val4 Pre-Pago Remesa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 ECA
&glob val2 DEA
&glob val3 Settlement Prepayment
&glob val4 Remittance Prepayment
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

