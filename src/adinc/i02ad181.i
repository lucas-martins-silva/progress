/******************************************************************
**
** i02ad181.i campo: registro (mov-cb)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativo
&glob val2 Eliminado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activo
&glob val2 Eliminado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Active
&glob val2 Deleted
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

