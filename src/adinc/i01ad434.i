/******************************************************************
**
** i01ad434.i  Campo:tip-reg-layout.idi-tip-reg-layout
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Header
&glob val2 Transa‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Header
&glob val2 Trans
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Header
&glob val2 Trans
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

