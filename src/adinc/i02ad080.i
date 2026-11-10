/******************************************************************
**
** i02ad080.i  Campo: destaque (det-dem-vid)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 NÆo destaca
&glob val2 Linha acima
&glob val3 Linha abaixo
&glob val4 Acima e abaixo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 No destaca
&glob val2 L¡nea arriba
&glob val3 L¡nea abajo
&glob val4 Arriba y abajo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 No hilite
&glob val2 Above Line
&glob val3 Below Line
&glob val4 Above / Below
&ENDIF

{include/ind01-10.i {1} {2} }
/* Fim */

