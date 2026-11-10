/******************************************************************
**  Objeto: i05ad229.i
**  Campo:  repres.idi-liber-pagto-comis-agent
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 PadrÆo
&glob val2 Final Proces Export
&glob val3 Ap¢s Liquid Ult Tit
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Est ndar
&glob val2 Final Proces Export
&glob val3 Despu‚s Liquid élt T¡t
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Standard
&glob val2 Final Process Export
&glob val3 After Settling Last Document
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

