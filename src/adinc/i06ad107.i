/******************************************************************
**
** i06ad107.i campo cdn-regim-tribut (estabelec) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Simples Nacional
&glob val2 Simp Nac (exc sublimite rec bruta)
&glob val3 Regime Normal
&glob val4 Simples Nacional - MEI
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Simple Nacional
&glob val2 Simp Nac (exc subl¡mite ingr. bruto)
&glob val3 Regimen Normal
&glob val4 Simple Nacional - MEI
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Regular Domestic Mail
&glob val2 Regular Domestic Mail (except gross revenue sublimit)
&glob val3 Regular Method
&glob val4 Regular Domestic Mail - IME
&ENDIF


{include/ind01-10.i {1} {2}}
/* Fim */
