/******************************************************************
**
** i02ad300.i  Campo: situacao-guia (aux-movto-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pendente
&glob val2 Confirmado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pendiente
&glob val2 Confirmado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Pending
&glob val2 Confirmed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

