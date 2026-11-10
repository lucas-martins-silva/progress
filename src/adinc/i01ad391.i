/***********************************************************************
**
**   i01ad391.i  
**
***********************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Vincula‡Æo
&glob val2 Liquida‡Æo
&glob val3 Destina‡Æo
&glob val4 Devolu‡Æo de Reais
&glob val5 Cancelamento c/Desemb
&glob val6 Cancelamento s/Desemb
&glob val7 Abatimento
&glob val8 Devolu‡Æo da Devolu‡Æo
&glob val9 Liquida‡Æo T¡tulo Empr‚stimo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Vinculaci¢n
&glob val2 Liquidaci¢n
&glob val3 Destinaci¢n
&glob val4 Devoluci¢n de Reales
&glob val5 Cancelaci¢n c/Desemb
&glob val6 Cancelaci¢n s/Desemb
&glob val7 Rebaja
&glob val8 Devoluci¢n de Devoluci¢n
&glob val9 Liquidaci¢n T¡tulo Pr‚stamo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Link
&glob val2 Settlement
&glob val3 Target
&glob val4 Return of Reais
&glob val5 Cancellation w/Outlay
&glob val6 Cancellation w/out Outlay
&glob val7 Write-off
&glob val8 Return of Return
&glob val9 Loan Document Settlement
&ENDIF

{include/ind01-10.i {1} {2}}

/*  Fim  */
