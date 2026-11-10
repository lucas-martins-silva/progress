/******************************************************************
**
** i04ad098.i campo resumo-mp (originado no arquivo emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Calculado
&glob val2 · Calcular
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Calculado
&glob val2 A Calcular
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Calculated
&glob val2 To Calc
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

