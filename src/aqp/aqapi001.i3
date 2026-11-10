/*seleção das produt-carg (carga) para apuração de valores ou simulação preço final*/

DEF VAR cQuery as CHARACTER  NO-UNDO.

/* DATA DE TRANSAÇÃO */
ASSIGN cQuery = "FOR EACH produt-carg NO-LOCK WHERE  produt-carg.Dat-trans >= '" + string(tt-param.da-dat-ini) + "'"
                                             + " AND produt-carg.Dat-trans <= '" + string(tt-param.da-dat-fim) + "'".

/* ITEM */
IF tt-param.it-codigo <> "" THEN
    ASSIGN cQuery = cQuery + " AND produt-carg.it-codigo = '" + tt-param.it-codigo + "'".

/* PRODUTOR RURAL */
IF tt-param.cdn-produt-rural-ini <> INT("") OR  tt-param.cdn-produt-rural-fim  <> INT(FILL('9', 9)) THEN DO:    
    IF tt-param.cdn-produt-rural-ini = tt-param.cdn-produt-rural-fim THEN 
        ASSIGN cQuery = cQuery + " AND produt-carg.cdn-produt-rural = " + string(tt-param.cdn-produt-rural-ini)  .  
    ELSE                                                                                                 
        ASSIGN cQuery = cQuery + " AND produt-carg.cdn-produt-rural >= '" + string(tt-param.cdn-produt-rural-ini) + "'"  
                               + " AND produt-carg.cdn-produt-rural <= '" + string(tt-param.cdn-produt-rural-fim) + "'". 
END.

/* ESTABELEC */
IF tt-param.cod-estabel-ini <> "" OR tt-param.cod-estabel-fim  <> FILL('Z', 5) THEN DO:    
    IF tt-param.cod-estabel-ini = tt-param.cod-estabel-fim THEN 
        ASSIGN cQuery = cQuery + " AND produt-carg.cod-estabel = '"  + tt-param.cod-estabel-ini  + "'".
    ELSE                                                          
        ASSIGN cQuery = cQuery + " AND produt-carg.cod-estabel >= '" + tt-param.cod-estabel-ini + "'"
                               + " AND produt-carg.cod-estabel <= '" + tt-param.cod-estabel-fim + "'".     
END.  

/* PONTO DE COLETA */
IF tt-param.cod-pto-coleta-ini <> "" OR  tt-param.cod-pto-coleta-fim  <> FILL('Z', 12) THEN DO:    
    IF tt-param.cod-pto-coleta-ini = tt-param.cod-pto-coleta-fim THEN 
        ASSIGN cQuery = cQuery + " AND produt-carg.cod-pto-coleta = '" + tt-param.cod-pto-coleta-ini  + "'". 
    ELSE                                                                                                 
        ASSIGN cQuery = cQuery + " AND produt-carg.cod-pto-coleta >= '" + tt-param.cod-pto-coleta-ini + "'"  
                               + " AND produt-carg.cod-pto-coleta <= '" + tt-param.cod-pto-coleta-fim + "'". 
END.
