/******************************************************************
**
**  adinc/i03ad297.i - codigos-retenc.natureza.
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 F¡sica
&glob val3 Jur¡dica
&glob val4 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 F¡sica
&glob val3 Jur¡dica
&glob val4 Ambos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Non-Corporate Entity
&glob val3 Corporate Entity
&glob val4 Both
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

