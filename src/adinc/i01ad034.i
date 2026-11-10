/******************************************************************
**
** i01ad034.i  - controle (cfgadm)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 N£mero de Usu rios
&glob val2 CPU
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 N£mero de Usuarios
&glob val2 CPU
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Number of Users
&glob val2 CPU
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

