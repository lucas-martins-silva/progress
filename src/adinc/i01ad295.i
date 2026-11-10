/******************************************************************
**
** adinc/i01ad295.i  Campo: usuar-permiss∆o-ap.ind-tipo-autorizaá∆o
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Preparaá∆o
&glob val2 Liberaá∆o
&glob val3 Preparaá∆o-liberaá∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Preparaci¢n
&glob val2 Liberaci¢n
&glob val3 Preparaci¢n-Liberaci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Preparation
&glob val2 Release
&glob val3 Release-Preparation
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

