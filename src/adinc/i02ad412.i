/******************************************************************
**
** i02ad412.i  Campo:tit-inadimp.idi-sit-tit
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Status 1
&glob val2 Status 2
&glob val3 Status 3
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Situaci¢n 1
&glob val2 Situaci¢n 2
&glob val3 Situaci¢n 3
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Status 1
&glob val2 Status 2
&glob val3 Status 3
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
