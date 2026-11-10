/******************************************************************
**
** i01ad395.i  Campo: fiador-inadimp.idi-tip-pessoa
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 F¡sica
&glob val2 Jur¡dica
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 F¡sica
&glob val2 Jur¡dica
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Physical
&glob val2 Corporate
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
