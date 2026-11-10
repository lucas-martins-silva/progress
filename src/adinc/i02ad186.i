/******************************************************************
**
** i02ad186.i Campo: correcao (movto-aplic-empr)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Apl-Emp
&glob val2  Res-Pag
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Apl-Emp
&glob val2  Res-Pag
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Apl-Loa
&glob val2  Wdw-Pay
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

