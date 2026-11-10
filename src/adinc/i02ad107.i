/******************************************************************
**
** i02ad107.i - campo: estabelec.idi-tip-emis-nf-eletro 
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhum
&glob val2 Homologa‡Æo
&glob val3 Produ‡Æo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ning£n
&glob val2 Homolog
&glob val3 Producci¢n
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 None
&glob val2 Homolog
&glob val3 Mfg
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */
