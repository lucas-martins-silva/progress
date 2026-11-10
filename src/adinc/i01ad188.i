/******************************************************************
**
**      i01ad188.i  - campo mv-operacao(originado do arquivo movto-bem)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  II-Inclus∆o Bem Imobilizado
&glob val2  IC-Inclus∆o Compra
&glob val3  ID-Inclus∆o Desmembramento
&glob val4  IA-Inclus∆o Alteraá∆o
&glob val5  IU-Inclus∆o Uni∆o
&glob val6  BV-Baixa Venda
&glob val7  BI-Baixa Inutilizaá∆o
&glob val8  BD-Baixa Desmembramento
&glob val9  BA-Baixa Alteraá∆o
&glob val10 BU-Baixa Uni∆o
&glob val11 BE-Baixa Exaust∆o
&glob val12 BT-Baixa Transferància
&glob val13 BX-Baixa Venda Passivo
&glob val14 BS-Baixa Devoluá∆o
&glob val15 IT-Inclus∆o Transferància
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  II-Inclusi¢n Bien Inmovilizado
&glob val2  IC-Inclusi¢n Compra
&glob val3  ID-Inclusi¢n Separaci¢n 
&glob val4  IA-Inclusi¢n Alteraci¢n
&glob val5  IU-Inclusi¢n Uni¢n
&glob val6  BV-Baja Venta
&glob val7  BI-Baja Inutilizaci¢n
&glob val8  BS-Baja Separaci¢n
&glob val9  BA-Baja Alteraci¢n
&glob val10 BU-Baja Uni¢n
&glob val11 BA-Baja Agotamiento
&glob val12 BT-Baja Transferencia  
&glob val13 BX-Baja Venta Pasivo
&glob val14 BS-Baja Devoluci¢n
&glob val15 IT-Inclusi¢n Transferencia
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  AA-Asset Addition
&glob val2  PA-Purchase Addition
&glob val3  SA-Separation Addition
&glob val4  MA-Modify Addition
&glob val5  UA-Union Addition
&glob val6  RS-Retirement by Sale
&glob val7  RI-Retirement by Idle 
&glob val8  RP-Retirement by Separation
&glob val9  RA-Retirement by Alteration
&glob val10 RU-Retirement by Union
&glob val11 RC-Retirement by Consume 
&glob val12 RT-Retirement by Transference 
&glob val13 RL-Retirement by Liability Sale 
&glob val14 RR-Retirement by Return
&glob val15 TA-Transference Addition
&ENDIF

{include/ind11-50.i {1} {2}}
/* Fim */

