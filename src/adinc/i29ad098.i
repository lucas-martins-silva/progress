/**********************************************************************
**
**      i29ad098.i  - emitente.cod-classif-(fornec / cliente)
**
**********************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Primeiro N¡vel
&glob val2 Segundo N¡vel
&glob val3 Terceiro N¡vel
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Primer N¡vel 
&glob val2 Segundo N¡vel
&glob val3 Tercer N¡vel
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 First Level
&glob val2 Second Level
&glob val3 Third Level
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

