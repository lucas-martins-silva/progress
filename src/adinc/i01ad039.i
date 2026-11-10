/******************************************************************
**
** i01ad039.i campo dia-sem-base (cond-pagto)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Domingo
&glob val2 Segunda
&glob val3 Ter‡a
&glob val4 Quarta
&glob val5 Quinta
&glob val6 Sexta
&glob val7 S bado
&glob val8 NÆo Considera
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Domingo
&glob val2 Lunes
&glob val3 Martes
&glob val4 Mi‚rcols
&glob val5 Jueves
&glob val6 Viernes
&glob val7 S bado
&glob val8 No considera
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Sunday
&glob val2 Monday 
&glob val3 Tuesday
&glob val4 Wednesday 
&glob val5 Thursday
&glob val6 Friday
&glob val7 Saturday
&glob val8 Exclude
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

