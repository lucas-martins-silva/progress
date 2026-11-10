/******************************************************************
**
**  i05ad264.i Campo: titulo.sit-titulo
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Baixa/Devolu‡Æo
&glob val3 Abatimento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Baja/Devoluci¢n
&glob val3 Rebaja
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Pay/Return
&glob val3 Reduction
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

