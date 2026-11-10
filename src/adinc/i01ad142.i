/******************************************************************
**
** i01ad142.i Campo: complemento (hist-padrao)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Obrigat¢rio
&glob val2 Opcional
&glob val3 NÆo permitido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Obligatorio
&glob val2 Opcional
&glob val3 No Permitido
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Mandatory
&glob val2 Optional
&glob val3 Not allowed
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

