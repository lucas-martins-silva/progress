/******************************************************************
**
** i02ad081.i Campo: considera (originado no arquivo det-demonst)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Sim
&glob val2 Nao
&glob val3 Variavel
&glob val4 Titulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 S¡
&glob val2 No
&glob val3 Variable
&glob val4 T¡tulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Yes
&glob val2 No 
&glob val3 Variable
&glob val4 Document
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

