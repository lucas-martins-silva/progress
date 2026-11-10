EMPTY TEMP-TABLE RowErrors   NO-ERROR.
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

CREATE tt-cidade.
ASSIGN tt-cidade.pais         = Country_00
       tt-cidade.estado       = State_00
       tt-cidade.cidade       = City_00.

FIND FIRST cidade
     WHERE cidade.pais   = tt-cidade.pais
     AND   cidade.estado = tt-cidade.estado
     AND   cidade.cidade = tt-cidade.cidade NO-LOCK NO-ERROR.
IF NOT AVAIL cidade THEN DO:
    CREATE tt_log_erro.
    ASSIGN ttv_num_cod_erro  = 2    
           ttv_des_msg_ajuda = "business_error":U       
           ttv_des_msg_erro  = "NÆo encontrado Cidade para a chave informada.".
END.
ELSE DO:
    /*Bo valida‡Æo it-requisi‡Æo*/
    RUN dibo/bodi341.p PERSISTENT SET h-bodi341.
    RUN openQueryStatic IN h-bodi341 (INPUT "Default").
    RUN goToKey         IN h-bodi341(INPUT tt-cidade.cidade,INPUT tt-cidade.estado,INPUT tt-cidade.pais).
    RUN deleteRecord    IN h-bodi341.
    RUN getRowErrors    IN h-bodi341(OUTPUT TABLE RowErrors).
    IF CAN-FIND(FIRST RowErrors) THEN
        RUN pi-carrega-tt_log_erro(INPUT TABLE RowErrors).
END.
       
