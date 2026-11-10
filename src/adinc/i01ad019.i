/******************************************************************
**
** i01ad019.i campo estado (para arquivos do patrimonio Ex: Bem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativo
&glob val2 Baixado
&glob val3 Unido/Desunido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Activo
&glob val2 Bajado
&glob val3 Unido/Desunido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Active
&glob val2 Retired
&glob val3 United/Separated
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

