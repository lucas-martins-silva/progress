/******************************************************************
**
** i05ad098.i campo tr-ar-valor (originado no arquivo emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Trunca
&glob val2 Arredonda
&glob val3 Rejeita
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Trunca
&glob val2 Redondea
&glob val3 Rechaza
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Trunc
&glob val2 Rounding
&glob val3 Reject
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
