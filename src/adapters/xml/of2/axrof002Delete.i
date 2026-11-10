EMPTY TEMP-TABLE RowErrors   NO-ERROR.
EMPTY TEMP-TABLE tt_log_erro NO-ERROR.

IF LENGTH(DocumentNumber) < 7 THEN
    ASSIGN cDocumentoAlte = FILL("0",7 - (LENGTH(DocumentNumber))) + DocumentNumber.
ELSE
    ASSIGN cDocumentoAlte = DocumentNumber.


CREATE tt-doc-fiscal.
ASSIGN tt-doc-fiscal.cod-emitente = CustomerNumber
       tt-doc-fiscal.nr-doc-fis   = cDocumentoAlte
       tt-doc-fiscal.serie        = DocumentSeries
       tt-doc-fiscal.nat-operacao = FiscalOperationCode
       tt-doc-fiscal.cod-estabel  = Site. 

FIND FIRST doc-fiscal
     WHERE doc-fiscal.cod-emitente = tt-doc-fiscal.cod-emitente
     AND   doc-fiscal.nr-doc-fis   = tt-doc-fiscal.nr-doc-fis  
     AND   doc-fiscal.serie        = tt-doc-fiscal.serie       
     AND   doc-fiscal.nat-operacao = tt-doc-fiscal.nat-operacao
     AND   doc-fiscal.cod-estabel  = tt-doc-fiscal.cod-estabel NO-LOCK NO-ERROR.

IF NOT AVAIL doc-fiscal THEN DO:
    CREATE tt_log_erro.
    ASSIGN ttv_num_cod_erro  = 2    
           ttv_des_msg_ajuda = "business_error":U       
           ttv_des_msg_erro  = "NÆo encontrado Documento Fiscal para a chave informada.".
    RETURN 'NOK'.

END.
ELSE DO:
    /* Convenio 15 */
    FOR FIRST ext-doc-fiscal EXCLUSIVE-LOCK
        WHERE ext-doc-fiscal.cod-estabel  = doc-fiscal.cod-estabel
        AND   ext-doc-fiscal.serie        = doc-fiscal.serie
        AND   ext-doc-fiscal.nr-doc-fis   = doc-fiscal.nr-doc-fis
        AND   ext-doc-fiscal.cod-emitente = doc-fiscal.cod-emitente
        AND   ext-doc-fiscal.nat-operacao = doc-fiscal.nat-operacao:
        DELETE ext-doc-fiscal.
    END.    

    FOR FIRST nota-fisc-adc EXCLUSIVE-LOCK
        WHERE nota-fisc-adc.cod-estab        = doc-fiscal.cod-estabel  
        AND   nota-fisc-adc.cod-serie        = doc-fiscal.serie        
        and   nota-fisc-adc.cod-nota-fisc    = doc-fiscal.nr-doc-fis   
        and   nota-fisc-adc.cdn-emitente     = doc-fiscal.cod-emitente 
        and   nota-fisc-adc.cod-natur-operac = doc-fiscal.nat-operacao 
        and   nota-fisc-adc.idi-tip-dado     = 13:
        DELETE nota-fisc-adc. 
    END.
    
    /*Bo valida‡Æo it-requisi‡Æo*/
    RUN dibo/bodi037.p PERSISTENT SET h-bodi037.
    RUN openQueryStatic IN h-bodi037 (INPUT "Main").
    RUN goToKey         IN h-bodi037(INPUT tt-doc-fiscal.cod-estabel,
                                     INPUT tt-doc-fiscal.serie,
                                     INPUT tt-doc-fiscal.nr-doc-fis,
                                     INPUT tt-doc-fiscal.cod-emitente,
                                     INPUT doc-fiscal.nat-operacao).
    RUN deleteRecord    IN h-bodi037.
    RUN getRowErrors    IN h-bodi037(OUTPUT TABLE RowErrors).
    IF CAN-FIND(FIRST RowErrors) THEN DO:

        RUN PI_gera_tt_log_erro.

    END.
END.

 
