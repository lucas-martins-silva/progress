/******************************************************************
**
**  i03ad264.i Campo: situacao (titulo)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Normal
&glob val2 Antecipado
&glob val3 Em devolu‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Normal
&glob val2 Anticipo
&glob val3 En devolucn
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Normal
&glob val2 Advanced
&glob val3 In Return
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

