/******************************************************************
**
** i02ad019.i campo situacao-bem (bem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Comprado
&glob val2 Imobilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Comprado
&glob val2 Inmovilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Purchased
&glob val2 Corrected
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

