/******************************************************************
**  Objeto: i04ad107.i
**  Campo:Idi-tip-layout
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 EMS
&glob val2 SEFAZ
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 EMS
&glob val2 SEFAZ
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 EMS
&glob val2 SEFAZ
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
