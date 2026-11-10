/******************************************************************
**
** i01ad112.i campo tipo(originado no arquivo ext-cmi)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Exposta
&glob val2 Protegida
&glob val3 Compromisso
&glob val4 Tradu‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Expuesta
&glob val2 Protegida
&glob val3 Compromiso
&glob val4 Traducci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Exposed
&glob val2 Protected
&glob val3 Commitment
&glob val4 Transl
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

