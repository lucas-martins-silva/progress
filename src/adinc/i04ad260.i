/******************************************************************
**
**  i04ad260.i Campo: sit-receb (tit-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 OK
&glob val2 Aguardando Recebimento
&glob val3 Com Problema
&glob val4 Pendente de Aprova‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 OK
&glob val2 Esperando Recibo
&glob val3 Con Problema
&glob val4 Pendiente de Aprovaci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 OK
&glob val2 Waiting For Receipt
&glob val3 With Problem
&glob val4 Pending on Approval 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

