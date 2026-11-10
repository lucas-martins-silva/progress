/******************************************************************
**
**  i01ad107.i Campo: custo-contab (Tabela Estabelecimento).
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Mensal
&glob val2 On-line
&glob val3 Padr∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Mensual
&glob val2 On line
&glob val3 Estandar
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Monthly
&glob val2 Online
&glob val3 Standard
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

