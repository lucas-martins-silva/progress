/******************************************************************
**
** i01ad433.i  Campo:layout-diver.idi-tip-layout-diver
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Varredura de Sacado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Barredura de Sacado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Drawee Scanning
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
