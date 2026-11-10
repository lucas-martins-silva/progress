/******************************************************************
**
** i01ad411.i  
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Ativo
&glob val2 Passivo
&glob val3 Patrim“nio L¡quido
&glob val4 Contas de Resultado
&glob val5 Contas de Compensa‡Æo
&glob val9 Outras
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Acti
&glob val2 Pasivo
&glob val3 Activo Fijo Liquido
&glob val4 Cuentas Resultado
&glob val5 Cuentas Compensacion
&glob val9 Otras
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Actv
&glob val2 Liabil
&glob val3 Net Assets
&glob val4 result Accounts
&glob val5 Compensation Accounts
&glob val9 Others
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
