/******************************************************************
**
** i01ad398.i  Campo: perfil-usuar-inadimp.idi-tip-regra
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Saldo Cliente
&glob val2 Empresa
&glob val3 Estabelecimento
&glob val4 Cliente
&glob val5 Esp‚cie
&glob val6 Gr Cliente
&glob val7 Portador
&glob val8 Modalidade
&glob val9 Representante
&glob val10 Usu rio
&glob val11 Nr Dias Aberto
&glob val12 Estado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Saldo Cliente
&glob val2 Empresa
&glob val3 Sucursal
&glob val4 Cliente
&glob val5 Clase
&glob val6 Gr Cliente
&glob val7 Portador
&glob val8 Modalidad
&glob val9 Representante
&glob val10 Usu rio
&glob val11 Nr D¡as Abierto
&glob val12 Estado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Customer Balance
&glob val2 Company
&glob val3 Site
&glob val4 Customer
&glob val5 Class
&glob val6 Customer Gr
&glob val7 Collector
&glob val8 Modality
&glob val9 Representative
&glob val10 User
&glob val11 Nr Open Days
&glob val12 State
&ENDIF

{include/ind11-50.i {1} {2}}

/* fim */

