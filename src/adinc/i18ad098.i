/******************************************************************
**
** i18ad098.i  Campo: ind-atraso
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo informa
&glob val2 Informa
&glob val3 Sumaria
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No Informa
&glob val2 Informa
&glob val3 Sintetiza
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Not enter
&glob val2 Enter
&glob val3 Summarize
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

