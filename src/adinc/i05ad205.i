/******************************************************************
**
**  i05ad205.i Campo: mod-conf (param-global)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo Implementado
&glob val2 Conf MAGNUS
&glob val3 Conf EMS
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Implementado
&glob val2 Conf MAGNUS
&glob val3 Conf EMS
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not Implemented
&glob val2 Conf EMS 
&glob val3 Conf EMS
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

