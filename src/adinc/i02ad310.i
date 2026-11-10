/*******************************************************************
**
** adinc/i02ad310.i  Campo: his-tit-eliminados.ind-pend-atualizado
**
********************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pendente
&glob val2 Atualizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pendiente
&glob val2 Actualizado
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Pending
&glob val2 Updated
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

