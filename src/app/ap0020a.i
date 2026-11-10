/***********************************************************************
**
** ap0020.i - Parametriza o intervalo de datas para valida‡Æo
**
***********************************************************************/

FIND empresa
    WHERE empresa.ep-codigo = i-ep-codigo-usuario
    NO-LOCK NO-ERROR.

FIND param-ap
    WHERE param-ap.ep-codigo = i-ep-codigo-usuario
    NO-LOCK NO-ERROR.

if avail param-ap then do:
    &if "{&mgadm_version}" <= "2.02" &then                
       ASSIGN da-ini-validac = param-ap.dt-ult-fec
              da-fim-validac = 12/31/9999.
    &else
         if avail empresa then do:
            ASSIGN da-ini-validac = IF empresa.data-inicio > param-ap.dt-ult-fec THEN empresa.data-inicio ELSE param-ap.dt-ult-fec
                   da-fim-validac = empresa.data-fim.
         end.
    &endif    
end.

/* fim */
