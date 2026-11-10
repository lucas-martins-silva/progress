/******************************************************************
**
** i01ad185.i - campo tipo (originado do arquivo movimento)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Debito
&glob val2 Credito
&glob val3 Partida Dupla DB
&glob val4 Partida Dupla CR
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 D‚bito
&glob val2 Cr‚dito
&glob val3 Partida Doble DB
&glob val4 Partida Doble CR
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Debit
&glob val2 Credit
&glob val3 Dr Double Entry 
&glob val4 Cr Double Entry 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

