/******************************************************************
**
** i02ad208.i  Campo: tipo-preco-pmi (parfluge)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Base
&glob val2 M‚dio
&glob val3 Reposi‡Æo
&glob val4 éltima Entrada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Base
&glob val2 Medio
&glob val3 Reposici¢n
&glob val4 éltima Entrada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Base
&glob val2 Average
&glob val3 Replacement
&glob val4 Last Receipt
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

