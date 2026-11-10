/******************************************************************
**
** i03ad198.i - campo dt-conversao (param-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Fluxo
&glob val2  Emissao
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Flujo
&glob val2  Emisi¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Flow
&glob val2  Print
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

