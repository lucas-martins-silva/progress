/****************************************************************************
** adinc/i04ad204.i - Tipo de C lculo
****************************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Valor Mercadoria (Com ICMS)
&glob val2 Valor Mercadoria (Sem ICMS)
&glob val3 Valor Total
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Valor Mercanc¡a (Con IMP)
&glob val2 Valor Mercanc¡a (Sin IMP)
&glob val3 Valor Total
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Goods Value (W/ Tax)
&glob val2 Goods Value (W/Out Tax)
&glob val3 Total Value
&ENDIF

{include/ind01-10.i {1} {2}}

/* Fim */
