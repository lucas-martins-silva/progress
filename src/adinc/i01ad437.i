
/******************************************************************
**
** i01ad437.i  Campo: movto-tit-ap-bcio.idi-tip-movto-bco
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Nenhum
&glob val2 Inclus∆o Carteira
&glob val3 Baixa Carteira
&glob val4 Alteraá∆o T°tulo
&glob val5 Cancelamento T°tulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Ning£n
&glob val2 Inclusn Cartera
&glob val3 Baja Cartera
&glob val4 Alterac T°tulo
&glob val5 Cancelacn T°tulo
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 None
&glob val2 Portfolio Additn
&glob val3 Issue Portfl
&glob val4 Document Update
&glob val5 Doc Cancellation
&ENDIF

{include/ind01-10.i {1} {2}}
/* Fim */



