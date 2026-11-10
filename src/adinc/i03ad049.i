/******************************************************************
**
** i03ad049.i campo estado (conta-contab)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativada
&glob val2 Desativada
&glob val3 Sistema
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activada
&glob val2 Desactivada
&glob val3 Sistema
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Active
&glob val2 Inactive
&glob val3 System
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

