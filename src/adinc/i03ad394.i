/******************************************************************
**
** i03ad394.i  Campo:clien-inadimp.idi-vencto-fer
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Mantem
&glob val2 Prorroga
&glob val3 Antecipa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Mantiene
&glob val2 Prorroga
&glob val3 Anticipa
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Maintain
&glob val2 Postpone
&glob val3 Advance
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

