/******************************************************************
**
**  i04ad019.i Campo: opcao-calc (bem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Corrige e Deprecia
&glob val2 Corrige
&glob val3 Deprecia
&glob val4 Nada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Corrige y Deprecia
&glob val2 Corrige
&glob val3 Deprecia
&glob val4 Nada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Correct & Depr
&glob val2 Correct
&glob val3 Depreciate
&glob val4 None
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

