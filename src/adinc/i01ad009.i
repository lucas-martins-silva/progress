/******************************************************************
**
** i01ad009.i  Campo: tipo (agencia) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pr¢pria
&glob val2 Correspondente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Propia
&glob val2 Correspondiente 
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Own
&glob val2 Corresponding
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
