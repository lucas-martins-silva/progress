/******************************************************************
**
** i02ad242.i Campo: situacao (simulacao)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativo
&glob val2 Inativo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activo
&glob val2 Inactivo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Active
&glob val2 Inactive
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

