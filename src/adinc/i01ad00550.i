/***************************
* Include: i01ad00550.i
* Campo: idi-tip-ambiente
***************************/
{include/i-lgcode.i}
&IF "{&LANGUAGE-CODE}" = "POR" &THEN

&glob val1 Produ‡Æo
&glob val2 Produ‡Æo Restrita

&ENDIF

&IF "{&LANGUAGE-CODE}" = "ESP" &THEN

&glob val1 Producci¢n
&glob val2 Producci¢n Restringida

&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN

&glob val1 Production
&glob val2 Restricted Production
   
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
