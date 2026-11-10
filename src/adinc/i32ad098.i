/******************************************************************
**
** i32ad098.i campo char-1,165,1 (Tipo de Ente Governamental)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Uni∆o
&glob val2 Estado
&glob val3 Distrito Federal
&glob val4 Munic°pio
&glob val5 Cons¢rcio P£blico
&glob val6 Comità Gestor do IBS
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Uni∆o
&glob val2 Estado
&glob val3 Distrito Federal
&glob val4 Munic°pio
&glob val5 Cons¢rcio P£blico
&glob val6 Comità Gestor do IBS
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Uni∆o
&glob val2 Estado
&glob val3 Distrito Federal
&glob val4 Munic°pio
&glob val5 Cons¢rcio P£blico
&glob val6 Comità Gestor do IBS
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
