/******************************************************************
**
** i03ad412.i  Campo:tit-inadimp.idi-tip-tit
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Original
&glob val2 Renegociado
&glob val3 Novo
&glob val4 Aviso de D‚bito
&glob val5 Antecipa‡Æo
&glob val6 Renegocia‡Æo Pendente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Original
&glob val2 Renegociado
&glob val3 Nuevo
&glob val4 Aviso de D‚bito
&glob val5 Anticipo
&glob val6 Renegociaci¢n Pendiente
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Source
&glob val2 Renegotiated
&glob val3 New
&glob val4 Debt Warining
&glob val5 Advance
&glob val6 Pending Renegotiation
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */

