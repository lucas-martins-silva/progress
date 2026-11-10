/******************************************************************
**
** i05ad200.i  Importa / Exporta
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Integra
&glob val2  Exporta
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Integra
&glob val2  Exporta
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Integrate
&glob val2  Export
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

