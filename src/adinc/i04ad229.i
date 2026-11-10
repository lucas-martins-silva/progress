/******************************************************************
**  Objeto: i04ad229.i
**  Campo:  repres.idi-tip-base-comis-agent
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Valor FOB
&glob val2 Valor INCOTERM
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Valor FOB
&glob val2  Valor INCOTERM
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 FOB Amount
&glob val2 INCOTERM Amount
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

