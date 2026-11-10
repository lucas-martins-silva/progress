/******************************************************************
**  Objeto: i05ad107.i
**  Campo:Idi-tip-transm
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aplicaá∆o Transmiss∆o
&glob val2 Transmiss∆o Manual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Aplicac Transmision
&glob val2 Transmision Manual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Transmision Manual
&glob val2 Manual Transmiss
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
