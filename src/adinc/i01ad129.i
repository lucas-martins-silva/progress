/******************************************************************
**
**      i01ad129.i  
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo exportar para os clientes
&glob val2 Exportar conforme conte£do anterior
&glob val3 Exportar para todos os clientes do grupo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No exportar para los clientes
&glob val2 Exportar de acuerdo al contenido anterior
&glob val3 Exportar para todos los clientes del grupo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Do not export to customers
&glob val2 Export as per previous CONTENTS
&glob val3 Export to all customers of group 
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
 
