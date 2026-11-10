/******************************************************************
**
** i04ad183.i  campo mov-tit.tp-pagto 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Encontro de Contas
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Encuentro de Cuentas
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Account Meeting
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
