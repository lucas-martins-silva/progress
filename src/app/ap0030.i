/***********************************************************************
**
** ap0020.i - Parametriza o intervalo de datas para valida‡Æo
**
***********************************************************************/

FIND empresa
    WHERE empresa.ep-codigo = tt-param.i-ep-codigo
    NO-LOCK NO-ERROR.
FIND param-ap
    WHERE param-ap.ep-codigo = tt-param.i-ep-codigo
    NO-LOCK NO-ERROR.

ASSIGN da-ini-validac = IF empresa.data-inicio > param-ap.dt-ult-fec THEN empresa.data-inicio ELSE param-ap.dt-ult-fec
       da-fim-validac = empresa.data-fim.

/* fim */
