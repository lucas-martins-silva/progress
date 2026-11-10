/******************************************************************
**
** i01ad200.i Campo: e-bloqueto (originado do arquivo param-cr)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1  Empresa
&glob val2  Banco
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1  Empresa
&glob val2  Banco
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1  Company
&glob val2  Bank
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

