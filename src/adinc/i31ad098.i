/******************************************************************
**
** i31ad098.i campo tipo-fornecimento (fornecedor EMS5)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Produtos
&glob val2 Servi‡os
&glob val3 Prod/Ser
&glob val4 PR Rural
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Produtos
&glob val2 Servi‡os
&glob val3 Prod/Ser
&glob val4 PR Rural
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Produtos
&glob val2 Servi‡os
&glob val3 Prod/Ser
&glob val4 PR Rural
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
