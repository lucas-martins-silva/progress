/******************************************************************
**
** i01ad025.i Campo: pag-cabec (bord-rec)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Primeira
&glob val2 Todas
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Primera
&glob val2 Todas			
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 First
&glob val2 All
&ENDIF

{include/ind01-10.i {1} {2}}
/* fim */
