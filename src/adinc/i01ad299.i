/******************************************************************
**
** i01ad299.i  Campo: situacao (talonario)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativo
&glob val2 Inativo
&glob val3 Utilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activo
&glob val2 Inactivo
&glob val3 Utilizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Active
&glob val2 Inactive
&glob val3 Used
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

