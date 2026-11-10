/******************************************************************
**
** i01ad425.i  Campo: idi-natur-lancto-ctbl
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 DB
&glob val2 CR
&glob val3 Partida Dupla
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 DB
&glob val2 CR
&glob val3 Partida Doble
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 DB
&glob val2 CR
&glob val3 Doubled Shipment
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

