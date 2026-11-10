/******************************************************************
**
** i01ad145.i - campo tipo (originado do arquivo imag-for)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Inclus∆o
&glob val2 Alteraá∆o
&glob val3 Eliminaá∆o
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Inclusi¢n
&glob val2 Alteraci¢n
&glob val3 Eliminaci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Addition
&glob val2 Mod
&glob val3 Deletion
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

