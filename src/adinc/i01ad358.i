/******************************************************************
**
** i01ad358.i  Campo: ind-entr-docto (crta-remessa-exp)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Contra Pagamento
&glob val2 Contra Aceite
&glob val3 Pagamento Antecipado
&glob val4 Simples Remessa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Contra Pagamento
&glob val2 Contra Aprobaci¢n
&glob val3 Pagamento Anticipado
&glob val4 Simple Remesa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Against Payment
&glob val2 Against Approval
&glob val3 Advanced Payment
&glob val4 Simple Dispatch
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
