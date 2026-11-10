/******************************************************************
**
** i02ad438.i Campo: idi-tip-contat (contat-manad-in)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Contabilista
&glob val2 Contribuinte
&glob val3 Respons vel T‚cnico
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Contabilista
&glob val2 Contribuyente
&glob val3 Responsable T‚cnico
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Accountant
&glob val2 Contributor
&glob val3 Technical Officer
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
