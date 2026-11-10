/******************************************************************
**
** i02ad101.i  Campo: contab-estat(empresa) Contabil/Estatistico
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Cont bil
&glob val2 Estat¡stico
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Contable
&glob val2 Estad¡stico
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Accounting
&glob val2 Statistics
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

