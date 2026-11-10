/******************************************************************
**
** i17ad098.i  Campo: ven-domingo (emitente)
** Tambem utilizado para campo ven-sabado e
**                       campo ven-feriado
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Prorroga
&glob val2 Antecipa
&glob val3 Mant‚m
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Prorroga
&glob val2 Adelanta
&glob val3 Mantiene
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Postpone
&glob val2 Advance
&glob val3 Keep
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

