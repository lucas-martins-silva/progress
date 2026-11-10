/******************************************************************
**
** i06ad200.i  Campo: param-cr.gera-movto
**
******************************************************************/

{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
&glob val1 Aviso de D‚bito
&glob val2 Movimento de Diferen‡a
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
&glob val1 Aviso de D‚bito
&glob val2 Transacci¢n Diferencia
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
&glob val1 Debit Warning
&glob val2 Difference Transaction
&ENDIF

{include/ind01-10.i {1} {2}}

/* fim */
