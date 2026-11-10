/******************************************************************
**
** i03ad180.i - campo: tp-pagto (mov-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cheque
&glob val2 Bordero
&glob val3 Escritural
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val4 Encontro de Contas
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Cheque
&glob val2 Border¢
&glob val3 Escritural
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val4 Encuentro de Cuentas
&ENDIF
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Check
&glob val2 Statement
&glob val3 Special Chrg
&IF DEFINED(BF_FIN_ENCCONTAS) &THEN
    &glob val4 Account Meeting
&ENDIF
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

