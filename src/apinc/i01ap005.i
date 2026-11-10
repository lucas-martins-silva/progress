/***********************************************************************
**
**   i01ap005.i   log-ordem.situacao
**
***********************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nova
&glob val2 Reprogramada
&glob val3 Eliminada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Nueva
&glob val2 Reprogramada
&glob val3 Eliminada
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 New
&glob val2 Rescheduled
&glob val3 Deleted
&ENDIF
 
{include/ind01-10.i {1} {2}}

/*  Fim  */
