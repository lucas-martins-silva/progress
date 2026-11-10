/******************************************************************
**
** i25ad098.i  Campo: estoque
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aloca
&glob val2 NÆo Aloca
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Asigna
&glob val2 No Asigna
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Alloc
&glob val2 No Alloc
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

