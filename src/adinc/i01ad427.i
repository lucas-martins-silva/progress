
/******************************************************************
**
** adinc/i01ad427.i => Atributo: idi-tip-sit-calc
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Revers∆o Total (Sem C†lculo)
&glob val2 C†lculo Normal
&glob val3 1ß C†lculo no Per°odo c/ Revers∆o
&glob val4 1ß C†lculo no Per°odo s/ Revers∆o
&glob val5 Indeterminado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Reversn Total (Sin C†lculo)
&glob val2 C†lculo Normal
&glob val3 1er C†lculo en Per°odo c/ Reversn
&glob val4 1er C†lculo en Per°odo s/ Reversn
&glob val5 Indeterminado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Total Revertn (S/out Calc)
&glob val2 Reg Calculatn
&glob val3 1st Calc in Period w/ Review
&glob val4 1st Calc in Period w/out Review
&glob val5 Undetermined
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */


