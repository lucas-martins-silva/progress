/******************************************************************
**
** i01ad043.i campo cdn-aplic-contat (cont-emit) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhuma
&glob val2 Destinat rio XML NF-e
&glob val3 Tomador NFS-e
&glob val4 Download XML NF-e
&glob val5 Destinat rio XML NFCom
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ninguna
&glob val2 Destinatario XML Fact-e
&glob val3 Tomador Fact-e
&glob val4 Descarga Fact-e XML
&glob val5 Destinatario XML NFCom
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 None
&glob val2 e-Ivc XML Addressee
&glob val3 e-Ivc Taker
&glob val4 Download XML e-Ivc
&glob val5 NFCom XML Addressee
&ENDIF


{include/ind01-10.i {1} {2}}
/* Fim */


