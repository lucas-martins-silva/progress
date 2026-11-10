/******************************************************************
**
** i01ad229.i  Campo: tipo-repres
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Funcion rio
&glob val2 Aut“nomo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Empleado
&glob val2 Aut¢nomo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Employee
&glob val2 Freelancer
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
