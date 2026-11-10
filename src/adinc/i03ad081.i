/******************************************************************
**
** i03ad081.i campo espaco (det-demonst)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo pula
&glob val2 Pula 1
&glob val3 Pula 2
&glob val4 Pula 3
&glob val5 Pr¢xima Pg
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No salta
&glob val2 Salta1
&glob val3 Salta2
&glob val4 Salta3
&glob val5 Pr¢xima Pg
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 No skip
&glob val2 Skip 1
&glob val3 Skip 2
&glob val4 Skip 3
&glob val5 Next Page
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

