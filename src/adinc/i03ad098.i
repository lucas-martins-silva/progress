/******************************************************************
**
** i03ad098.i campo natureza (originado no arquivo emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Pessoa F¡sica
&glob val2 Pessoa Jur¡dica
&glob val3 Estrangeiro
&glob val4 Trading
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Pers F¡sica
&glob val2 Pers Jur¡dica
&glob val3 Extranjero
&glob val4 Trading
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Non-Corporate
&glob val2 Corporate
&glob val3 Foreign
&glob val4 Export
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */

