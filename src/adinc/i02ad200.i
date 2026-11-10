/******************************************************************
**
** i02ad200.i Campo: geracao (originado do arquivo param-cr)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  On-line
&glob val2  Batch
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  On line
&glob val2  Batch
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Online
&glob val2  Batch
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

