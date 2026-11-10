/******************************************************************
**
** i01ad164.i Campo: lin-ant.origem-antecip
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Implanta‡Æo de Documentos
&glob val2 Liquida‡Æo de Documentos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Implantaci¢n de Doctos
&glob val2 Liquidaci¢n de Doctos
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Document Entry
&glob val2 Document Pay-Off
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

