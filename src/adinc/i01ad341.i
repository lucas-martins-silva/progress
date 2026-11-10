/******************************************************************
**
** i01ad341.i  Campo: tp-contrato-imp (contrato-imp) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pronto
&glob val2 Antecipa‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pronto
&glob val2 Anticipo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Ready
&glob val2 Adv Payment
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
