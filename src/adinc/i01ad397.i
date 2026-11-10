/******************************************************************
**
** i01ad397.i  Campo:param-inadimp.idi-produt-integr
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 EMS2
&glob val2 EMS5
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 EMS2
&glob val2 EMS5
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 EMS2
&glob val2 EMS5
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
