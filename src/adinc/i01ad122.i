/******************************************************************
**
** i01ad122.i  Campo: dt-ref (frequencia)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Data
&glob val2 Semana
&glob val3 Quinzena
&glob val4 Mˆs
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Fecha
&glob val2 Semana
&glob val3 Quincena
&glob val4 Mes
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Date
&glob val2 Week
&glob val3 Semi-monthly
&glob val4 Mth
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

