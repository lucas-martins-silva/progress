/*****************************************************************
**
**      i01ad319.i  - define o conte£do do campo "tp-reg"
**
******************************************************************/

{include/i-lgcode.i}


&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Header 
&glob val2 Detalhe Saldo Anterior 
&glob val3 Detalhe Lan‡amento 
&glob val4 Detalhe Saldo Final 
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Header 
&glob val2 Detalle Saldo Anterior 
&glob val3 Detalle Asiento 
&glob val4 Detalle Saldo Final 
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Header 
&glob val2 Previous Balance Detail 
&glob val3 Transaction Detail 
&glob val4 End Balance Detail 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
