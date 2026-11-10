/******************************************************************
**
** i05ad098.i campo tr-ar-valor (originado no arquivo emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Trunca
&glob val2 Arredonda
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Trunca
&glob val2 Redondea
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Trunc
&glob val2 Rounding
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

