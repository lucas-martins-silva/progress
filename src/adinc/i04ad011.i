/******************************************************************
**
**  i04ad011.i Campo: periodo-dias (apl-empr-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Dias éteis
&glob val2 Dias Corridos
&glob val3 Dias Comerciais
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 D¡as H biles
&glob val2 D¡as Seguidos
&glob val3 D¡as Comercials
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Workdays
&glob val2 Concurrent
&glob val3 Trading Days
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

