/******************************************************************
**
** i03ad170.i  Campo: estado (lin-i-ap)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Liberado
&glob val2 Pend CQ
&glob val3 Susp
&glob val4 Devol
&glob val5 Antec
&glob val6 Antec CQ
&glob val7 Pend Aceitacao
&glob val8 Bloqueado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Liberado
&glob val2 Pend CQ
&glob val3 Susp
&glob val4 Devol
&glob val5 Antic
&glob val6 Antic CQ
&glob val7 Pendi Aceptacion
&glob val8 Bloqueado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Released
&glob val2 QC Pend
&glob val3 Susp
&glob val4 Rtrn
&glob val5 Adv 
&glob val6 QC Adv
&glob val7 Accept Pending
&glob val8 Blocked
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

