/******************************************************************
**
** i26ad098.i  Campo: flag-pag    Tabela: Emitente
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 OK
&glob val2 Suspenso para pagamentos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 OK
&glob val2 Suspendido por pagos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 OK
&glob val2 Suspended for payments
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

