/************************************************
** i01ad347.i  Campo: situacao (contr-titulo-exp) 
************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Vinculado
&glob val2 Em Digita‡Æo
&glob val3 Devolvido
&glob val4 Cancelado
&glob val5 Pendente de Destina‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Vinculado
&glob val2 En Digitaci¢n
&glob val3 Devuelto
&glob val4 Cancelado
&glob val5 Pendiente de Destinaci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Linked
&glob val2 Being Typed
&glob val3 Returned
&glob val4 Canceled
&glob val5 Pending of Target
&ENDIF

{include/ind01-10.i {1} {2}}
