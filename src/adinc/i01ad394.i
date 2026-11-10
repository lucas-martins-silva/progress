/******************************************************************
**
** i01ad394.i  Campo: clien-inadimp.idi-cr-clien
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Autom tico
&glob val3 S¢ Imp Ped
&glob val4 Suspenso
&glob val5 Pagto … Vista
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Autom tico
&glob val3 S¢lo Imp Ped
&glob val4 Suspendido
&glob val5 Pago al Contado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Regular
&glob val2 Automatic
&glob val3 Ord Tax Only
&glob val4 Suspended
&glob val5 Pymt in Cash
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
