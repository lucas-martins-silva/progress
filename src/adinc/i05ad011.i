/******************************************************************
**
**  i05ad011.i Campo: periodo-taxa (apl-empr-banco)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Di ria
&glob val2 Mensal
&glob val3 Trimestral
&glob val4 Semestral
&glob val5 Anual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Diaria
&glob val2 Mensual
&glob val3 Trimestral
&glob val4 Semestral
&glob val5 Anual
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Jrnl Rpt
&glob val2 Monthly
&glob val3 Quarterly
&glob val4 Half-Yearly
&glob val5 Yearly
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

