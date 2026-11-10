/******************************************************************
**
** i05ad198.i  Campo: ir-pes-jur-ib (param-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Implanta‡Æo
&glob val2 Baixa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Implantaci¢n
&glob val2 Baja
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Entry
&glob val2 Payment
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

