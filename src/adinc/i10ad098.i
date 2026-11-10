/******************************************************************
**
**  i10ad098.i Campo: ind-cre-cli (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Autom tico
&glob val3 S¢ Imp Ped
&glob val4 Suspenso
&glob val5 Pg … Vista
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Autom tico
&glob val3 Imp Pedido
&glob val4 Suspendido
&glob val5 Al Contado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Automatic
&glob val3 Ad Ord Oly
&glob val4 Suspended
&glob val5 In Cash
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

