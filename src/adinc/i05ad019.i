/******************************************************************
**
** i05ad019.i  Campo: bam-calc
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 N∆o calculado
&glob val2 Calculado
&glob val3 Implantado no per°odo
&glob val4 Implantado Uni∆o/Desmembramento
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Calculado
&glob val2 Calculado
&glob val3 Implant en el Per°odo
&glob val4 Implantado Uni¢n/Desmembramnto
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Calc
&glob val2 Calculated
&glob val3 Added In Period
&glob val4 Added Union/Separation
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

