/******************************************************************
**
** i01ad169.i campo: transacao (lin-doc-pend) Debito/Credito/PD
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 DB-Debito
&glob val2 CR-Credito
&glob val3 PD-Partida Dupla
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 DB-Debito
&glob val2 CR-Credito
&glob val3 PD-Partida Doble
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 DR-Debit
&glob val2 CR-Credit 
&glob val3 DE-Double Entry
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

