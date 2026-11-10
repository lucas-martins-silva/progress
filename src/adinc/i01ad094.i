/******************************************************************
**
** adinc/i01ad094.i  Campo: doc-i-cr.ind-sit-lote-implantacao-cr.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Antecipa‡äes
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Anticipos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Adv Payments
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

