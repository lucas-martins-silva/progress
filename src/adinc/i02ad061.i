/******************************************************************
**
**  i02ad061.i Campo: tipo-inform (dem-i-lin)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Receita/Despesa
&glob val2 Modalidade
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ingreso/Gasto
&glob val2 Modalidad
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Income/Expense
&glob val2 Modality
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

