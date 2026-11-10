/******************************************************************
**
** adinc/i03ad337.i  Campo: cod-operador (obj-cenario)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
    &GLOBAL-DEFINE val1 Igual
    &GLOBAL-DEFINE val2 Maior
    &GLOBAL-DEFINE val3 Maior Igual
    &GLOBAL-DEFINE val4 Menor
    &GLOBAL-DEFINE val5 Menor Igual
    &GLOBAL-DEFINE val6 Diferente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
    &GLOBAL-DEFINE val1 Igual
    &GLOBAL-DEFINE val2 Mayor
    &GLOBAL-DEFINE val3 Mayor Igual
    &GLOBAL-DEFINE val4 Menor
    &GLOBAL-DEFINE val5 Menor Igual
    &GLOBAL-DEFINE val6 Diferente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
    &GLOBAL-DEFINE val1 Equal
    &GLOBAL-DEFINE val2 Great
    &GLOBAL-DEFINE val3 Great Equal
    &GLOBAL-DEFINE val4 Less
    &GLOBAL-DEFINE val5 Less Equal
    &GLOBAL-DEFINE val6 Different
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
