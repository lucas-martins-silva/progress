/******************************************************************
**
** i01ad405.i  Campo:fiador-renegoc-inadimp.idi-tip-fiador
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Testemunha
&glob val2 Fiador
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Testigo
&glob val2 Fiador
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Witness
&glob val2 Guarantor
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
