/******************************************************************
**
** i01ad046.i campo cdn-aplic-contat (cont-tran) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhuma
&glob val2 Destinat rio XML NF-e
&glob val3 Download XML NF-e
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ninguna
&glob val2 Destinatario XML Fact-e
&glob val3 Descarga Fact-e XML
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 None
&glob val2 e-Ivc XML Addressee
&glob val3 Download XML e-Ivc
&ENDIF


{include/ind01-10.i {1} {2}}
/* Fim */
