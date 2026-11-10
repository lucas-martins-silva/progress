/******************************************************************
**
** i01ad205.i Campo: ind-venc-dom/fer/sab (param-global)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Antecipa
&glob val2 Adia
&glob val3 Mant‚m
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Adelanta
&glob val2 Prorroga
&glob val3 Mantiene
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Advance
&glob val2 Postpone
&glob val3 Maintain
&ENDIF


{include/ind01-10.i {1} {2} {3}}

/* fim */
