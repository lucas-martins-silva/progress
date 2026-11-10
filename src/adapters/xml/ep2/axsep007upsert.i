
PROCEDURE PITransUpsert:

/*PARAMETERS - BEGIN*/
DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
DEFINE INPUT  PARAM p-estabel   AS CHARACTER           NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
/*PARAMETERS - END*/

/* ******************************************* */
/* *************** BODY - BEGIN ************** */
/* ******************************************* */

DEFINE VARIABLE c-cgc     LIKE estabelec.cgc NO-UNDO.
DEFINE VARIABLE cTpTrans  AS CHARACTER       NO-UNDO.
DEFINE VARIABLE i-serie   AS INTEGER         NO-UNDO.
DEFINE VARIABLE l-nfe-pfe AS LOGICAL         NO-UNDO.

EMPTY TEMP-TABLE tt_log_erro       NO-ERROR.
EMPTY TEMP-TABLE ttEmpresa         NO-ERROR.

FOR FIRST b-estabelec NO-LOCK
    WHERE b-estabelec.cod-estabel = p-estabel:

    ASSIGN c-cod-estabel = p-estabel.

    FOR FIRST cidade FIELDS(&IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN cdn-munpio-ibge &ELSE int-2 &ENDIF) 
        WHERE cidade.cidade = b-estabelec.cidade
        AND   cidade.estado = b-estabelec.estado
        AND   cidade.pais   = b-estabelec.pais NO-LOCK: 
    END.

    FOR FIRST emitente FIELDS(nome-abrev telefone[1] natureza) WHERE
              emitente.cod-emitente = b-estabelec.cod-emitente NO-LOCK:
    END.

    FOR FIRST pais FIELDS(&IF'{&bf_dis_versao_ems}' >= '2.06':U &THEN cod-pais-siscomex &ELSE char-1 &ENDIF) WHERE
              pais.nome-pais = b-estabelec.pais NO-LOCK:
    END.

    ASSIGN c-endereco = b-estabelec.endereco.

    IF NOT VALID-HANDLE(h-cdapi704) THEN
        RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

    IF  INDEX(c-endereco,CHR(ASC("§"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("§")),"").

    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    IF c-nro = "" THEN
       ASSIGN c-nro = "S/N".

    ASSIGN c-cgc = STRING(b-estabelec.cgc).

    /* PONTO UPC - CHAMADO AAC450 - PROTEGE */
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:

        FOR EACH   tt-epc
            WHERE  tt-epc.cod-event = "TrocaCNPJ":U:
            DELETE tt-epc.
        END.
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "TrocaCNPJ"
               tt-epc.cod-parameter = "Rowid_Estabelec"
               tt-epc.val-parameter = STRING(ROWID(b-estabelec)).
    
        {include/i-epc201.i "TrocaCNPJ"}
    
        FOR FIRST tt-epc
            WHERE tt-epc.cod-event     = "TrocaCNPJ":U
              AND tt-epc.cod-parameter = "Rowid_Estabelec":

            IF tt-epc.val-parameter <> "" THEN
                ASSIGN c-cgc = tt-epc.val-parameter.
            ELSE
                ASSIGN c-cgc = STRING(b-estabelec.cgc).
        END.
    END.
    /*--------------------------------------*/
   
    CREATE ttEmpresa.
    ASSIGN ttEmpresa.cod-estabel          = fn-trata-caracteres(fn-free-accent(b-estabelec.cod-estabel)).
    ASSIGN ttEmpresa.bairro               = fn-trata-caracteres(fn-free-accent(b-estabelec.bairro))
           ttEmpresa.cep                  = STRING(b-estabelec.cep)
           ttEmpresa.cnpj                 = c-cgc
           ttEmpresa.cod-mun              = IF b-estabelec.pais = "Brasil":U THEN 
                                                &IF '{&BF_DIS_VERSAO_EMS}' >= "2.07":U &THEN 
                                                   IF AVAIL cidade THEN STRING(cidade.cdn-munpio-ibge) ELSE "0"
                                                &ELSE 
                                                   IF AVAIL cidade THEN STRING(cidade.int-2) ELSE "0"
                                                &ENDIF 
                                            ELSE "9999999"
                                            
           ttEmpresa.cod-pais             = &IF '{&bf_dis_versao_ems}' >= "2.06" &THEN
                                               STRING(pais.cod-pais-siscomex)
                                            &ELSE 
                                               SUBSTR(pais.char-1,1,5) 
                                            &ENDIF WHEN AVAIL pais
           ttEmpresa.cod-suframa          = b-estabelec.cod-suframa   
           ttEmpresa.complemento          = fn-trata-caracteres(fn-free-accent(c-comp))
           ttEmpresa.endereco             = fn-trata-caracteres(fn-free-accent(c-rua))
           ttEmpresa.fone                 = STRING(emitente.telefone[1]) WHEN AVAIL emitente  
           ttEmpresa.insc-estadual        = STRING(b-estabelec.ins-estadual)
           ttEmpresa.insc-estadual        = REPLACE(ttEmpresa.insc-estadual,"-","")
           ttEmpresa.insc-estadual        = REPLACE(ttEmpresa.insc-estadual,".","")
           ttEmpresa.insc-estadual        = REPLACE(ttEmpresa.insc-estadual,"/","")
           ttEmpresa.insc-estadual        = REPLACE(ttEmpresa.insc-estadual,"~\","")
           ttEmpresa.insc-estadual        = REPLACE(ttEmpresa.insc-estadual,",","") 
           ttEmpresa.insc-municipal       = STRING(b-estabelec.ins-municipal)
           ttEmpresa.insc-municipal       = REPLACE(ttEmpresa.insc-municipal,"-","")
           ttEmpresa.insc-municipal       = REPLACE(ttEmpresa.insc-municipal,".","")
           ttEmpresa.insc-municipal       = REPLACE(ttEmpresa.insc-municipal,"/","")
           ttEmpresa.insc-municipal       = REPLACE(ttEmpresa.insc-municipal,"~\","")
           ttEmpresa.insc-municipal       = REPLACE(ttEmpresa.insc-municipal,",","") 
           ttEmpresa.municipio            = fn-trata-caracteres(fn-free-accent(b-estabelec.cidade))
           ttEmpresa.nome                 = fn-trata-caracteres(fn-free-accent(b-estabelec.nome))
           ttEmpresa.nome-fantasia        = fn-trata-caracteres(fn-free-accent(emitente.nome-abrev)) WHEN AVAIL emitente
           ttEmpresa.numero               = c-nro
           ttEmpresa.uf                   = b-estabelec.estado
           ttEmpresa.cpf                  = "".                                                

    ASSIGN i-serie = INT(b-estabelec.serie) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN l-nfe-pfe = NO.        
    END.
    ELSE DO:
        IF i-serie >= 920 AND i-serie <= 969 THEN
           ASSIGN l-nfe-pfe = YES.
        ELSE
           ASSIGN l-nfe-pfe = NO.
    END.

    IF l-nfe-pfe
    OR emitente.natureza = 1 /* Pessoa F¡sica */ THEN DO:
        ASSIGN ttEmpresa.cnpj = ""
               ttEmpresa.cpf  = SUBSTRING(c-cgc,4,11). 
    END.
    
    IF VALID-HANDLE(h-cdapi704) THEN DO:
       DELETE PROCEDURE h-cdapi704.
       ASSIGN h-cdapi704 = ?.
    END.
    
END.

    RUN cdp/cd0360b.p (INPUT p-estabel,
                       INPUT "":U,
                       OUTPUT cTpTrans).

   IF CAN-FIND(FIRST ttEmpresa) THEN
      IF  LOOKUP("TSS":U, cTpTrans) > 0 OR 
          LOOKUP("TC":U, cTpTrans) > 0 THEN
      RUN pi-Configura-Empresa-TSS-Sincrono.
   ELSE
      RUN PIUpsert (INPUT cTranAction,                
                    INPUT TABLE ttEmpresa,     
                    OUTPUT TABLE tt_log_erro).

END PROCEDURE.

PROCEDURE pi-Configura-Empresa-TSS-Sincrono:

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

    DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cIdEnt               AS CHARACTER   NO-UNDO.
    
    IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
        RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunica‡Æo com o TSS*/
    END.
    
    FIND FIRST ttEmpresa    NO-LOCK NO-ERROR.

    IF NOT AVAIL param-nf-estab THEN
        FOR FIRST param-nf-estab NO-LOCK
            WHERE param-nf-estab.cod-estabel = ttEmpresa.cod-estabel: END.
    
    IF  NOT AVAIL param-nf-estab OR 
        &if "{&bf_dis_versao_ems}" >= "2.08" &then
           TRIM(param-nf-estab.cod-url-ws-tss) = "":U OR
           TRIM(param-nf-estab.cod-url-ws-tss) = "http://":U
        &else
           TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100)) = "":U OR
           TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100)) = "http://":U
        &endif
        THEN DO:

        CREATE TT_LOG_ERRO.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-url-webservice-do-tss-nao-info AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "URL_WebService_do_TSS_nÆo_informada" *}
        ASSIGN c-lbl-liter-url-webservice-do-tss-nao-info = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-a-url-do-webservice-do-tss-dev AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_URL_do_WebService_do_TSS_deve_ser_previamente_informada_nos_parƒmetros_de_integra‡Æo_com_o_TSS" *}
        ASSIGN c-lbl-liter-a-url-do-webservice-do-tss-dev = TRIM(RETURN-VALUE).
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006
               TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-url-webservice-do-tss-nao-info + "!"
               TT_LOG_ERRO.TTV_DES_MSG_AJUDA = c-lbl-liter-a-url-do-webservice-do-tss-dev + ".".

        RETURN "NOK":U.
    END.

    RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                 TRIM(param-nf-estab.cod-url-ws-tss)
                               &else
                                 TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                               &endif).
                               
    RUN setTSSAuthParam IN h-TSSAPI(INPUT 1,
                                    INPUT "*",
                                    INPUT param-nf-estab.cod-estabel,
                                    INPUT param-nf-estab.cod-url-ws-tss).
                               
    RUN SPEDADM_ADMEMPRESAS IN h-TSSAPI (INPUT BUFFER ttEmpresa:HANDLE, 
                                         INPUT BUFFER ttSpedGenericStruct:HANDLE, /* ttINSCRICAO */
                                         OUTPUT cIdEnt).

    ASSIGN cReturnValue = RETURN-VALUE.
    
    RUN disconnectTss IN h-TSSAPI ("SPEDADM":U).
    
    IF  cReturnValue <> "OK":U THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
      
        /*Busca Mensagem*/
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 36370,
                           INPUT "[TSS ADMEMPRESAS]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
      
        /*Busca Help */
        RUN utp/ut-msgs.p (INPUT "HELP":U,
                           INPUT 36370,
                           INPUT "[TSS ADMEMPRESAS]":U + "~~":U + cReturnValue).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    END.
    ELSE DO:
        FIND CURRENT param-nf-estab EXCLUSIVE-LOCK NO-ERROR.
        IF  AVAIL param-nf-estab THEN
            ASSIGN param-nf-estab.ind-empresa = cIdEnt.
        RELEASE param-nf-estab NO-ERROR.
    END.

    IF  VALID-HANDLE(h-TSSAPI) THEN DO:
        DELETE PROCEDURE h-TSSAPI.
        ASSIGN h-TSSAPI = ?.
    END.

    &ENDIF

END PROCEDURE.
