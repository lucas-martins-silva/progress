/******************************************************************
**
** i01ad300.i  Campo: tipo-operacao (aux-movto-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Cau‡Æo
&glob val3 Descontado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Fianza
&glob val3 Descontado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Escrow
&glob val3 Discounted
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

