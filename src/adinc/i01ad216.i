/******************************************************************
**
** i01ad216.i  Campo: situacao (rateio)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativado
&glob val2 Desativado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activdo
&glob val2 Desactivdo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Actv
&glob val2 Deact 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

