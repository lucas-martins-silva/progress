/****************************************************************************
**   adinc/i03ad204.i - Frequencia de Totaliza‡Æo.
****************************************************************************/
{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Em Dias
&glob val2 Em Meses
&glob val3 Em Anos
&glob val4 Sempre nos Dias
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 En D¡as
&glob val2 En Meses
&glob val3 En A¤os
&glob val4 Siempre en(los) D¡a(s)
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 In Days
&glob val2 In Months
&glob val3 In Years
&glob val4 Always in Day(s)
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
