PROCEDURE PITransUpsert:
    
    /*PARAMETERS - BEGIN*/
    DEFINE INPUT  PARAM pcUf                  AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pAnoInut              AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAM pCnpj                 AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pModelo               AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pSerie                AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pnNfeIni              AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pnNfeFin              AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pJust                 AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM pTranAction           AS CHARACTER NO-UNDO . /* add/upd */
    DEFINE INPUT  PARAM pTranEvent            AS CHARACTER NO-UNDO . /* UpdateDocument/UndoUpdateDocument */
    DEFINE INPUT  PARAM pRowidNotaFiscal      AS ROWID     NO-UNDO.
    DEFINE OUTPUT PARAM p-tipo-transacao      AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.
    DEFINE OUTPUT PARAM TABLE FOR tt_nfe_erro.
    /*PARAMETERS - END*/
    
    DEF VAR c-serie          AS CHARACTER  NO-UNDO. 
    DEF VAR cVersaoLayoutNFe AS CHARACTER NO-UNDO.

    DEF VAR c-cod-uf   AS CHAR FORMAT "x(02)" NO-UNDO.
    DEF VAR c-nota-ini AS CHAR FORMAT "x(09)" NO-UNDO.
    DEF VAR c-nota-fim AS CHAR FORMAT "x(09)" NO-UNDO.

    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */

    EMPTY TEMP-TABLE tt_log_erro           NO-ERROR.
    EMPTY TEMP-TABLE tt_nfe_erro           NO-ERROR.
    EMPTY TEMP-TABLE ttInutInvoiceDocument NO-ERROR.

    FOR FIRST nota-fiscal NO-LOCK
        WHERE ROWID(nota-fiscal) = pRowidNotaFiscal:
    END.

    RUN cdp/cd0360b.p (INPUT nota-fiscal.cod-estabel,
                       INPUT "NF-e":U,
                       OUTPUT cTpTrans).

    IF  NOT AVAIL estabelec
    OR (AVAIL estabelec
    AND estabelec.cod-estabel <> nota-fiscal.cod-estabel) THEN
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel: 
        END.
    
    ASSIGN cVersaoLayoutNFe = &if "{&bf_dis_versao_ems}" >= "2.071" &then 
                                 Trim(estabelec.des-vers-layout)
                              &else 
                                 TRIM(SUBSTRING(estabelec.char-1,173,10))
                              &endif WHEN AVAIL estabelec NO-ERROR.

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = "spp-nfe"
                AND   funcao.ativo     ) THEN DO:
            
           assign c-serie = pserie.
            
            /* TrataSerieNfe: EPC para retirar letras da s‚rie */
            FOR EACH  tt-epc
                WHERE tt-epc.cod-event = "TrataSerieNfe":U:
               DELETE tt-epc.
            END.
            
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "TrataSerieNfe":U
                   tt-epc.cod-parameter = "serie":U
                   tt-epc.val-parameter =  c-serie.
                   
            {include/i-epc201.i "TrataSerieNfe"}
            
            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = "TrataSerieNfe":U AND 
                      tt-epc.cod-parameter = "serie-nfe":U :
               
                ASSIGN c-serie = tt-epc.val-parameter.
            END.

            /* TrataSerieNfe */
            ASSIGN pserie = c-serie. 
            IF pserie = "" THEN ASSIGN pserie = "0". 
    END.

    IF  cTpTrans = "TC2" OR cTpTrans = "TPF" THEN 
        FOR FIRST unid-feder FIELDS( &IF "{&bf_dis_versao_ems}" < "2.07" &THEN char-1 &ELSE cod-uf-ibge &ENDIF) 
            WHERE unid-feder.estado = estabelec.estado   AND 
                  unid-feder.pais   = estabelec.pais NO-LOCK: END.
    ELSE
        FOR FIRST unid-feder FIELDS( &IF "{&bf_dis_versao_ems}" < "2.07" &THEN char-1 &ELSE cod-uf-ibge &ENDIF) 
            WHERE unid-feder.estado = pcUf AND 
                  unid-feder.pais   = 'Brasil':U NO-LOCK: END.

    ASSIGN c-cod-uf = IF AVAIL unid-feder THEN
                     &IF "{&bf_dis_versao_ems}" < "2.07" &THEN SUBSTR(unid-feder.char-1,1,2) 
                     &ELSE string(unid-feder.cod-uf-ibge) &ENDIF ELSE "00".
                     
    if nota-fiscal.serie = "" then
       assign c-serie = "000".
    else do:
        if length(c-serie) < 3 then do:
            assign c-serie = if length(c-serie) = 1 then
                                 "00" + c-serie
                             else "0" + c-serie.
        end.
        else
            if length(c-serie) > 3 then
               assign c-serie = substring(c-serie,1,3).
    end.
    
    if length(pnNfeIni) < 9 THEN
        assign c-nota-ini = string(int(pnNfeIni),"999999999").
    else
        if length(pnNfeIni) = 9 then
            assign c-nota-ini = pnNfeIni.
        else
            assign c-nota-ini = substring(pnNfeIni,1,9).

    if length(pnNfeFin) < 9 THEN
        assign c-nota-fim = string(int(pnNfeFin),"999999999").
    else
        if length(pnNfeFin) = 9 then
            assign c-nota-fim = pnNfeFin.
        else
            assign c-nota-fim = substring(pnNfeFin,1,9).

    CREATE ttInutInvoiceDocument.
    ASSIGN ttInutInvoiceDocument.ano       = IF  cTpTrans = "TC2" OR cTpTrans = "TPF" THEN int(SUBSTRING(string(pAnoInut),3,2)) ELSE pAnoInut
           ttInutInvoiceDocument.cnpj      = pCnpj
           ttInutInvoiceDocument.cUf       = c-cod-uf
           ttInutInvoiceDocument.mod       = pModelo
           ttInutInvoiceDocument.nNFFin    = LEFT-TRIM(pnNfeFin,"0")
           ttInutInvoiceDocument.nNFIni    = LEFT-TRIM(pnNfeIni,"0")
           ttInutInvoiceDocument.serie     = pSerie
           ttInutInvoiceDocument.tpAmb     = (IF &if "{&BF_DIS_VERSAO_EMS}" >= "2.07" &then
                                                 estabelec.idi-tip-emis-nf-eletro    = 3
                                                 &else
                                                 INT(SUBSTR(estabelec.char-1,168,1)) = 3  /* Processo Emissao NF-e - CD0403 */
                                                 &endif
                                              THEN "1"  /* Producao    */
                                              ELSE "2") /* Homologacao */
           ttInutInvoiceDocument.versao    = (IF cVersaoLayoutNFe = "1.10":U THEN "1.06":U
                                                                             ELSE cVersaoLayoutNFe)
           ttInutInvoiceDocument.xJust     = pJust
           ttInutInvoiceDocument.xServ     = "INUTILIZAR":U
           ttInutInvoiceDocument.Signature = " ":U.
                                
    /* C¢digo da UF + Ano (2 posi‡äes) + CNPJ  + modelo + s‚rie + nro inicial e nro final  precedida do literal ËIDÌ */
    IF  cTpTrans = "TC2" OR cTpTrans = "TPF" THEN DO:
        ASSIGN pJust = fn-free-accent(pJust)                               /* substitui os acentos */
               pJust = REPLACE(REPLACE(pJust, CHR(13), " "), CHR(10), " ") /* substitui os break-lines por espa‡o em branco */
               pJust = fn-trata-caracteres(pJust)                          /* retira qualquer caracter especial nÆo aceito pelo TSS/SEFAZ */
               pJust = "Motivo Inutiliza‡Æo: ":U + pJust. /* foi fixado esse texto pois a msg de cancelamento deve ter no minimo 15 caracteres */   

        ttInutInvoiceDocument.id        = "ID":U + c-cod-uf + SUBSTRING(string(pAnoInut),3,2) + string(pCnpj) + 
                                           STRING(pModelo) + trim(STRING(c-serie)) + STRING(c-nota-ini) + STRING(c-nota-fim).
    END.
    ELSE
        ttInutInvoiceDocument.id        = "ID":U + STRING(pcUf) + STRING(pModelo) + STRING(pSerie) + STRING(pnNfeIni) + STRING(pnNfeFin).

    /* Tirar os espaços do campo */
    ASSIGN ttInutInvoiceDocument.xJust = TRIM(ttInutInvoiceDocument.xJust).

    RUN PIUpsert ( INPUT pTranAction,
                   INPUT pTranEvent,
                   INPUT TABLE ttInutInvoiceDocument,     /* Dados do Pedido de Cancelamento da nota fiscal  */
                   OUTPUT p-tipo-transacao,
                   OUTPUT TABLE tt_log_erro ).

   
   
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.






