/******************************************************************
**
** i05ad206.i Campo:per-completo(param-patrim) Calculado/Nao Calculado
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Calculado
&glob val2 NÆo Calculado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Calculado
&glob val2 No Calculado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Calculated
&glob val2 Not Calc
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

