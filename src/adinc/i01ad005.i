/******************************************************************
**
** i01ad005.i  Campo: origem (acum-cb) 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pedidos
&glob val2 Compras
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pedidos
&glob val2 Compras
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Order
&glob val2 Purchase
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
