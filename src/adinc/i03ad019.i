/******************************************************************
**
** i03ad019.i Campo: bem-calc (bem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 N∆o calculado
&glob val2 Calculado
&glob val3 Implantado no Per°odo
&glob val4 Implantado Desmembr/Uni∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Calculado
&glob val2 Calculado
&glob val3 Implant en el Per°odo
&glob val4 Implant Separaci¢n/Uni¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Calc
&glob val2 Calculated
&glob val3 Added In Period
&glob val4 Added Separation/Union
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

