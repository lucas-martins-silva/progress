/******************************************************************
**
** i02ad103.i  Campo: esp-cob-esc
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 DM-Duplicata Mercantil
&glob val2 NP-Nota Promiss¢ria
&glob val3 SG-Nota de seguro
&glob val4 RC-Recibo
&glob val5 CD-Cobran‡a Direta c/ Bloqueto p/ Banco
&glob val6 CF-Cobran‡a Direta c/ Bloqueto e Nr pelo Cliente
&glob val7 LC-Letra de Cƒmbio
&glob val8 WR-Warrant
&glob val9 CH-Cheque
&glob val10 CN-Cobran‡a Direta c/ Bloqueto p/ Cliente e Nr p/ Banco
&glob val11 DS-Duplicata de Servi‡o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 CM-Copia Mercantil
&glob val2 P-Pagar‚
&glob val3 SG-Nota de seguro
&glob val4 RC-Recibo
&glob val5 CD-Cobro Directo c/ Boleto p/ Banco
&glob val6 CF-Cobro Directo con boleto y Nr por el Cliente
&glob val7 LC-Letra de Cambio
&glob val8 WR-Warrant
&glob val9 CH-Cheque
&glob val10 CN-Cobro Directo con Boleto para Cliente y Nr p/ Banco
&glob val11 CS-Copia de Servicio
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 CI-Commercial Invoice
&glob val2 PN-Promissory Note 
&glob val3 IN-Insurance note
&glob val4 RC-Recpt
&glob val5 DB-Direct Bill-to with Bank Statement  
&glob val6 DB-Direct Bill-to with Statement and No by Cust
&glob val7 BE-Bill Exchange
&glob val8 WR-Warrant
&glob val9 CH-Check
&glob val10 DB-Direct bill-to with Statement for Cust No for Bank
&glob val11 DS-Service Invoice
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */

