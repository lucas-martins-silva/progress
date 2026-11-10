/*****************************************************************
**
**      i01ad320.i  - define o conte£do do campo "Cod-campo"
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Empresa
&glob val2 Banco
&glob val3 Agˆncia
&glob val4 Conta
&glob val5 Diferenciador
&glob val6 Saldo
&glob val7 DB/CR
&glob val8 C¢digo Lan‡amento
&glob val9 Hist¢rico
&glob val10 N£mero Documento
&glob val11 Data Movimento
&glob val12 Valor Lan‡amento
&glob val13 Data Saldo
&glob val14 Data Gera‡Æo
&glob val15 N£mero Extrato
&glob val16 Natureza Lan‡amento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Empresa
&glob val2 Banco
&glob val3 Agencia
&glob val4 Cuenta
&glob val5 Diferenciador
&glob val6 Saldo
&glob val7 DB/CR
&glob val8 C¢digo Asiento
&glob val9 Hist¢rico
&glob val10 N£mero Documento
&glob val11 Fecha Movimiento
&glob val12 Valor Asiento
&glob val13 Fecha Saldo
&glob val14 Fecha Generaci¢n
&glob val15 N£mero Extracto
&glob val16 Naturaleza Asiento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Company
&glob val2 Bank
&glob val3 Branch
&glob val4 Account
&glob val5 Difference
&glob val6 Bal
&glob val7 Dr/CR
&glob val8 Transaction Code
&glob val9 Comment
&glob val10 Document Number
&glob val11 Transaction Date
&glob val12 Transaction Value
&glob val13 Bal Date
&glob val14 Generation Date
&glob val15 Number Extract
&glob val16 Nature (Connect Banking)
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */
