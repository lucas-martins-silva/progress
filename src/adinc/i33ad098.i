/******************************************************************
**
** i33ad098.i campo Tipo Regime IBS/CBS - tpRegimeIBSCBS (emitente)
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 1-Simples c/ regime regular
&glob val2 2-Normal c/ opcao pend. CRT 1
&glob val3 3-Normal c/ opcao pend. CRT 2
&glob val4 4-Normal pend. c/ regime regular
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 1-Simple c/ regimen regular
&glob val2 2-Normal c/ opcion pend. CRT 1
&glob val3 3-Normal c/ opcion pend. CRT 2
&glob val4 4-Normal pend. c/ regimen regular
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 1-Simples w/ regular regime
&glob val2 2-Normal w/ pending option CRT 1
&glob val3 3-Normal w/ pending option CRT 2
&glob val4 4-Normal pend. w/ regular regime
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
