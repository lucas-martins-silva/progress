/******************************************************************
**
** i02ad257.i  Campo: tipo-preco (tipo-fluxo)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Reposi‡Æo
&glob val2 Base
&glob val3 éltima Compra
&glob val4 Pre‡o M‚dio
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Reposici¢n
&glob val2 Base
&glob val3 éltima Compra
&glob val4 Prec Medio
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Replacement
&glob val2 Base
&glob val3 Last Purchase
&glob val4 Avg Price
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

