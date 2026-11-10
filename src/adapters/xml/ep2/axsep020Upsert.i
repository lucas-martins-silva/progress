PROCEDURE PITransUpsert:    
    
    DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-selec-docto.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

    DEF VAR l-funcao-tss AS LOG         NO-UNDO.
    /* TOTVS COLAB 2.0 */
    DEFINE VARIABLE cTpTrans   AS CHARACTER NO-UNDO.
    DEF VAR c-serie            AS CHARACTER NO-UNDO.
    DEF VAR p-dh-formatada     AS CHARACTER NO-UNDO.
    DEF VAR i-serie            AS IN        NO-UNDO.
    DEF VAR l-nfe-pfe          AS LOG       NO-UNDO.
    DEF VAR de-qt-reg          AS DECIMAL   NO-UNDO.
    
    FIND FIRST mdfe-param 
        WHERE  mdfe-param.cod-estab = estabelec.cod-estab NO-LOCK NO-ERROR.
    IF AVAIL mdfe-param THEN
        ASSIGN cVersaoMDFe = mdfe-param.cod-vers-mdfe.
    ELSE
        ASSIGN cVersaoMDFe = "3.00".
    
    ASSIGN lLayoutXML = YES.
    
    EMPTY TEMP-TABLE ttEvento.

    FOR EACH tt-selec-docto:
        
        ASSIGN c-dia = ""
               c-mes = ""
               c-ano = "".

        ASSIGN lMDFe =   tt-selec-docto.tp-evento = "110111" /* Cancelamento */
                      OR tt-selec-docto.tp-evento = "110112" /* Encerramento */
                      OR tt-selec-docto.tp-evento = "110114" /* Inclus∆o de Condutor */ 
                      OR tt-selec-docto.tp-evento = "110115" /* Carregamento Posterior */
                      OR tt-selec-docto.tp-evento = "110116" /* Pagamento Operaá∆o MDF-e */. 

        RUN cdp/cd0360b.p (INPUT tt-selec-docto.cod-estabel,
                           INPUT IF lMDFe THEN "MDF-e" ELSE "MD-e":U,
                           OUTPUT cTpTrans).

        ASSIGN l-funcao-tss = cTpTrans = "TSS":U or cTpTrans = "TC":U.

        FOR FIRST param-manif-destin NO-LOCK
            WHERE param-manif-destin.cod-estab = tt-selec-docto.cod-estabel: END.
        
        FOR FIRST param-nf-estab NO-LOCK 
            WHERE param-nf-estab.cod-estabel = tt-selec-docto.cod-estabel: END.
    
        FOR FIRST estabelec NO-LOCK 
            WHERE estabelec.cod-estabel = tt-selec-docto.cod-estabel: END.

        FOR FIRST unid-feder NO-LOCK 
            WHERE unid-feder.pais   = estabelec.pais 
              AND unid-feder.estado = estabelec.estado : END.
        
        FOR FIRST emitente NO-LOCK
            WHERE emitente.cod-emitente = estabelec.cod-emitente: END.


        ASSIGN c-serie = (IF SUBSTR(TRIM(tt-selec-docto.chave-nfe),23,3) <> "000":U
                          THEN STRING(INT(SUBSTR(TRIM(tt-selec-docto.chave-nfe),23,3)))
                          ELSE "":U).
        IF  lMDFe THEN DO:
            FOR FIRST mdfe-docto NO-LOCK
                WHERE mdfe-docto.cod-chave-mdfe = tt-selec-docto.chave-nfe:
            END.
        END.
        
        IF tt-selec-docto.tp-evento = "110115" THEN DO:
            FIND LAST mdfe-carregto-poster WHERE
                      mdfe-carregto-poster.cod-estab     = mdfe-docto.cod-estab    AND
                      mdfe-carregto-poster.cod-ser-mdfe  = mdfe-docto.cod-ser-mdfe AND
                      mdfe-carregto-poster.cod-num-mdfe  = mdfe-docto.cod-num-mdfe NO-LOCK NO-ERROR.
           
            IF AVAIL mdfe-carregto-poster THEN DO:
                FIND FIRST mdfe-descarreg WHERE
                     mdfe-descarreg.cod-estab     = mdfe-docto.cod-estab    AND
                     mdfe-descarreg.cod-ser-mdfe  = mdfe-docto.cod-ser-mdfe AND
                     mdfe-descarreg.cod-num-mdfe  = mdfe-docto.cod-num-mdfe AND 
                     mdfe-descarreg.num-seq-Event = mdfe-carregto-poster.num-seq-Event NO-LOCK NO-ERROR.
                 
                CREATE ttevIncDFeMDFe.
                ASSIGN ttevIncDFeMDFe.descEvento  = "Inclusao DF-e"                                          //descricao do evento
                       ttevIncDFeMDFe.nProt       = IF mdfe-carregto-poster.cod-protocolo = "" 
                                                    OR mdfe-carregto-poster.cod-protocolo = ? 
                                                    THEN "0" ELSE STRING(mdfe-carregto-poster.cod-protocolo) //numero do protocolo
                       ttevIncDFeMDFe.cMunCarrega = mdfe-carregto-poster.cod-munpio-ibge-carreg              //codigo municipio carregamento
                       ttevIncDFeMDFe.xMunCarrega = mdfe-carregto-poster.nom-munpio-carreg.                  //nome municipio carregamento

                FOR EACH mdfe-descarreg NO-LOCK WHERE
                   mdfe-descarreg.cod-estab     = mdfe-carregto-poster.cod-estab    AND
                   mdfe-descarreg.cod-ser-mdfe  = mdfe-carregto-poster.cod-ser-mdfe AND
                   mdfe-descarreg.cod-num-mdfe  = mdfe-carregto-poster.cod-num-mdfe AND
                   mdfe-descarreg.num-seq-Event = mdfe-carregto-poster.num-seq-Event:
        
                  CREATE ttinfDoc.
                  ASSIGN ttinfDoc.cMunDescarga = mdfe-descarreg.cod-munpio-ibge //codigo municipio descarregamento
                         ttinfDoc.xMunDescarga = mdfe-descarreg.nom-munpio      //nome municipio descarregamento
                         ttinfDoc.chNFe        = mdfe-descarreg.cod-chave-nfe.  //chave da nfe
                END. // for each mdfe-descarreg
                
                ASSIGN c-nome-arquivo-xml = mdfe-carregto-poster.cod-estab + mdfe-carregto-poster.cod-num-mdfe + STRING(mdfe-carregto-poster.num-seq-Event).
                
            END. // IF avail mdfe-carregto-poster
        END. //IF tt-selec-docto.tp-evento = "110115" 

        IF tt-selec-docto.tp-evento = "110116" THEN DO:
            
            FOR LAST mdfe-evento NO-LOCK
               WHERE mdfe-evento.cod-estab    = mdfe-docto.cod-estab   
                 AND mdfe-evento.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe
                 AND mdfe-evento.cod-num-mdfe = mdfe-docto.cod-num-mdfe
                 AND mdfe-evento.cod-evento   = "1":
                
                CREATE ttevPagtoOperMDFe.
                ASSIGN ttevPagtoOperMDFe.descEvento  = mdfe-evento.des-evento
                       ttevPagtoOperMDFe.nProt       = mdfe-evento.cod-protoc-mdfe
                       ttevPagtoOperMDFe.qtdViagens  = STRING(mdfe-evento.num-livre-1, "99999")
                       ttevPagtoOperMDFe.nroViagem   = STRING(mdfe-evento.num-livre-2, "99999").
                 
                 FOR EACH mdfe-evento-pagto-frete NO-LOCK 
                    WHERE mdfe-evento-pagto-frete.cod-estab     = mdfe-evento.cod-estab
                      AND mdfe-evento-pagto-frete.cod-ser-mdfe  = mdfe-evento.cod-ser-mdfe
                      AND mdfe-evento-pagto-frete.cod-num-mdfe  = mdfe-evento.cod-num-mdfe
                      AND mdfe-evento-pagto-frete.cod-evento    = mdfe-evento.cod-evento
                      AND mdfe-evento-pagto-frete.num-seq-event = mdfe-evento.num-seq-event
                      AND mdfe-evento-pagto-frete.cod-num-modal = "1":
                 
                     CREATE ttinfPag.              
                     ASSIGN ttinfPag.id            = INTEGER(mdfe-evento-pagto-frete.cod-num-pagto-frete)
                            ttinfPag.xNome         = mdfe-evento-pagto-frete.nom-respons-pagto
                            ttinfPag.vContrato     = mdfe-evento-pagto-frete.val-tot-contrat
                            ttinfPag.indPag        = STRING(mdfe-evento-pagto-frete.idi-forma-pagto - 1)
                            ttinfPag.codBanco      = mdfe-evento-pagto-frete.cod-banco
                            ttinfPag.codAgencia    = mdfe-evento-pagto-frete.cod-agencia
                            ttinfPag.CNPJIPEF      = mdfe-evento-pagto-frete.cod-cnpj-pagto
                            ttinfpag.PIX           = TRIM(SUBSTR(mdfe-evento-pagto-frete.cod-livre-1,1,60))
                            ttinfpag.vAdiant       = mdfe-evento-pagto-frete.val-livre-1.
                            
                     CASE mdfe-evento-pagto-frete.idi-classif:
                        WHEN 1 THEN
                            ASSIGN ttinfPag.CPF = mdfe-evento-pagto-frete.cod-cnpj.
                        WHEN 2 THEN
                            ASSIGN ttinfPag.CNPJ = mdfe-evento-pagto-frete.cod-cnpj.
                        WHEN 3 THEN           
                            ASSIGN ttinfPag.idEstrangeiro = mdfe-evento-pagto-frete.cod-cnpj.
                     END CASE.  
                      
                     FOR EACH mdfe-evento-pagto-frete-co NO-LOCK OF mdfe-evento-pagto-frete:
                        CREATE ttComp.
                        ASSIGN ttComp.id     = INTEGER(mdfe-evento-pagto-frete.cod-num-pagto-frete)    
                               ttComp.tpComp = STRING(mdfe-evento-pagto-frete-co.idi-tip-compon, "99")
                               ttComp.vComp  = mdfe-evento-pagto-frete-co.val-compon
                               ttComp.xComp  = mdfe-evento-pagto-frete-co.des-compon WHEN ttComp.tpComp = "99".
                     END.  
                      
                     FOR EACH mdfe-evento-pagto-frete-p NO-LOCK OF mdfe-evento-pagto-frete:
                         CREATE ttinfPrazo.
                            ASSIGN ttinfPrazo.id       = INTEGER(mdfe-evento-pagto-frete.cod-num-pagto-frete)    
                                   ttinfPrazo.nParcela = mdfe-evento-pagto-frete-p.cod-parc
                                   ttinfPrazo.vParcela = mdfe-evento-pagto-frete-p.val-parc.
                                   
                            ASSIGN ttinfPrazo.dVenc    = STRING(YEAR (mdfe-evento-pagto-frete-p.dat-vencto),"9999") + "-" +
                                                         STRING(MONTH(mdfe-evento-pagto-frete-p.dat-vencto),"99")   + "-" +
                                                         STRING(DAY  (mdfe-evento-pagto-frete-p.dat-vencto),"99") WHEN mdfe-evento-pagto-frete-p.dat-vencto <> ? NO-ERROR.
                     END.
                 END. 
                 
                 ASSIGN c-nome-arquivo-xml = mdfe-evento.cod-estab +  
                                             mdfe-evento.cod-ser-mdfe +
                                             mdfe-evento.cod-num-mdfe + 
                                             mdfe-evento.cod-evento + 
                                             STRING(mdfe-evento.num-seq-event).
            END.            
        END.

        ASSIGN i-serie = INT(c-serie) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN l-nfe-pfe = NO.        
        END.
        ELSE DO:
            IF i-serie >= 920 AND i-serie <= 969 THEN
               ASSIGN l-nfe-pfe = YES.
            ELSE
               ASSIGN l-nfe-pfe = NO.
        END.
        
        CREATE ttEvento.
        ASSIGN ttEvento.verEvento    = STRING(tt-selec-docto.cod-versao)
               ttEvento.chNFe        = tt-selec-docto.chave-nfe
               ttEvento.codEstab     = tt-selec-docto.cod-estab   
               /*Usar com serie especifica 920-969 para emitente pessoa fisica com inscricao estadual*/
               ttEvento.cnpj         = (IF l-nfe-pfe THEN "" ELSE estabelec.cgc)
               ttEvento.cpf          = (IF l-nfe-pfe OR emitente.natureza = 1 /*Pessoa F°sica*/
                                        THEN SUBSTRING(estabelec.cgc,4,11)
                                        ELSE IF   ttEvento.cpf <> ?
                                             THEN ttEvento.cpf
                                             ELSE "")
               ttEvento.xJust        = tt-selec-docto.justificativa
               ttEvento.tpEvento     = tt-selec-docto.tp-evento.

        ASSIGN ttEvento.cOrgao       = STRING(IF estabelec.pais = "Brasil":U THEN
                                                  (IF  NOT lMDFe
                                                   AND AVAIL param-manif-destin 
                                                   AND param-manif-destin.log-livre-2 THEN 91
                                                   ELSE IF AVAIL unid-feder THEN
                                                      INT(unid-feder.cod-uf-ibge)
                                                   ELSE 0)
                                              ELSE 99).
        IF  lMDFe 
        AND (cTpTrans = "TC2":U OR cTpTrans = "TPF":U)
        AND AVAIL mdfe-docto THEN
            ASSIGN ttEvento.nProt = mdfe-docto.cod-protoc-autoriz.

        /*Tp Ambiente*/
        IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN
            ASSIGN ttEvento.tpAmb = string(tt-selec-docto.ambiente).
        ELSE
        IF  cTpTrans = "TSS":U OR cTpTrans = "TC":U THEN DO:
            ASSIGN ttEvento.tpAmb   = IF  AVAIL param-nf-estab THEN 
                                        &IF "{&BF_DIS_VERSAO_EMS}" >= "2.08" &THEN
                                          STRING(param-nf-estab.idi-tip-emis-amb-sefaz)
                                        &ELSE
                                          STRING(param-nf-estab.num-livre-1)
                                        &ENDIF
                                      ELSE 
                                      (IF &IF "{&BF_DIS_VERSAO_EMS}" >= "2.07" &THEN
                                            estabelec.idi-tip-emis-nf-eletro    = 3
                                          &ELSE
                                            INT(SUBSTR(estabelec.char-1,168,1)) = 3  /* Processo Emiss∆o NF-e - CD0403 */
                                          &ENDIF
                                       THEN "1" ELSE "2") /* Homologaá∆o */. 
        END.
        ELSE DO:
            ASSIGN ttEvento.tpAmb   = (IF &IF "{&BF_DIS_VERSAO_EMS}" >= "2.07" &THEN
                                          estabelec.idi-tip-emis-nf-eletro    = 3
                                      &ELSE
                                          INT(SUBSTR(estabelec.char-1,168,1)) = 3  /* Processo Emiss∆o NF-e - CD0403 */
                                      &ENDIF
                                      THEN "1"  /* Produá∆o    */
                                      ELSE "2") /* Homologaá∆o */.
        END.

        ASSIGN c-dia  = SUBSTRING(tt-selec-docto.des-dat-hora-event,1,2)
               c-mes  = SUBSTRING(tt-selec-docto.des-dat-hora-event,4,2)
               c-ano  = SUBSTRING(tt-selec-docto.des-dat-hora-event,7,4).

        IF  lMDFe THEN
            ASSIGN c-hora = "T" + SUBSTRING(tt-selec-docto.des-dat-hora-event,12,8)
                   ttEvento.descEvento = IF tt-selec-docto.tp-evento = "110111" 
                                         THEN "Cancelamento":U 
                                         ELSE IF tt-selec-docto.tp-evento = "110112" 
                                              THEN "Encerramento"
                                              ELSE IF tt-selec-docto.tp-evento = "110115" 
                                                  THEN "Inclusao DF-e"  
                                                  ELSE IF tt-selec-docto.tp-evento = "110116"  
                                                       THEN "Pagamento Operacao MDF-e"
                                                       ELSE "Inclusao Condutor".
        ELSE
            ttEvento.descEvento = IF  tt-selec-docto.tp-evento = "210200" 
                                      THEN "Confirmacao da Operacao":U 
                                      ELSE IF  tt-selec-docto.tp-evento = "210220" 
                                               THEN "Desconhecimento da Operacao":U
                                               ELSE 
                                                   IF  tt-selec-docto.tp-evento = "210240"
                                                       THEN "Operacao nao Realizada":U
                                                       ELSE "Ciencia da Operacao":U.

        RUN cdp/cd0591.p (INPUT tt-selec-docto.cod-estabel,
                          INPUT DATE(c-dia + "/" + c-mes + "/" + c-ano),
                          INPUT SUBSTRING(tt-selec-docto.des-dat-hora-event,12,8),
                          INPUT NO, /* formatar hora sem aplicar o fuso */
                          OUTPUT p-dh-formatada).

        IF lMDFe THEN
             ASSIGN ttEvento.dhEvento = IF cVersaoMDFe >= "3.00":U THEN p-dh-formatada ELSE SUBSTRING(p-dh-formatada,1,19). /*retira o fuso da formataªío para nío dar falha de schema na mdf-e*/
        ELSE
             ASSIGN ttEvento.dhEvento = p-dh-formatada.

        ASSIGN ttEvento.infEventoID  = ttEvento.tpEvento + ttEvento.chNFe + "01"
               ttEvento.nSeqEvento   = IF cTpTrans = "TPF":U THEN "1" ELSE "01". 

        IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN DO:
            FOR FIRST unid-feder NO-LOCK 
                WHERE unid-feder.pais   = estabelec.pais 
                  AND unid-feder.estado = substr(ttEvento.xJust,1,2) : END.

            ASSIGN c-dt-enc       = c-ano + "-" + c-mes + "-" + c-dia
                   c-uf           = STRING(IF  estabelec.pais = "Brasil":U THEN 
                                     (&IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN 
                                     IF  AVAIL unid-feder THEN 
                                       INT(unid-feder.cod-uf-ibge)
                                     ELSE 0
                                      &ELSE 
                                     IF  AVAIL unid-feder THEN 
                                       INT(SUBSTRING(unid-feder.char-1,1,2)) 
                                     ELSE 0 &endif)
                                       ELSE 99)
                   c-cod-mun-ibge = TRIM(SUBSTRING(ttEvento.xJust,4,7)).

            IF  ttEvento.tpEvento = "110114" THEN DO: /* Inclus∆o de Condutor */
                SELECT COUNT (*) 
                        INTO de-qt-reg FROM mdfe-condut
                                            mdfe-condut
                                      WHERE mdfe-condut.cod-estab    = mdfe-docto.cod-estab
                                      AND   mdfe-condut.cod-num-mdfe = mdfe-docto.cod-num-mdfe
                                      AND   mdfe-condut.cod-ser-mdfe = mdfe-docto.cod-ser-mdfe.

                IF  de-qt-reg > 0 THEN
                    ASSIGN ttEvento.infEventoID = ttEvento.tpEvento + ttEvento.chNFe + STRING(de-qt-reg,"99")
                           ttEvento.nSeqEvento  = STRING(de-qt-reg).
            END.
            IF c-uf = "99" THEN
                ASSIGN c-cod-mun-ibge = "9999999".
            
            IF  lMDFe THEN
                RUN pi-integra-XML-mdfe.
            ELSE
                RUN pi-integra-XML-mde.

            DELETE ttEvento.
        END.

    END.

    IF  CAN-FIND(FIRST ttEvento) THEN DO:

        RUN cdp/cd0360b.p (INPUT "",
                           INPUT IF lMDFe THEN "MDF-e" ELSE "MD-e":U,
                           OUTPUT cTpTrans).
        IF  LOOKUP("TSS":U, cTpTrans) > 0 OR 
            LOOKUP("TC":U, cTpTrans) > 0 THEN
            RUN pi-TSS-Sincrono.
    END.

    RUN pi-executa-upc.
    
END PROCEDURE.

PROCEDURE pi-integra-XML-mdfe:
    
    DEFINE VARIABLE cTpTrans   AS CHARACTER NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

        DEFINE VARIABLE h-TSSAPI          AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hXMLEvento        AS HANDLE      NO-UNDO.
        DEFINE VARIABLE lEnvioEventoTSSOK AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE cReturnValue      AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE iCdEDI            AS INTEGER     NO-UNDO.
        DEFINE VARIABLE cEvMDFe           AS CHARACTER   NO-UNDO.
        
        ASSIGN lcXMLEvento = "".

        RUN reset       IN hGenXml.
        RUN setEncoding IN hGenXml ("UTF-8").

        addStack(iId).
 
            FOR FIRST ttEvento: END.

            ASSIGN icdEDI  = IF ttEvento.tpEvento = "110111" 
                             THEN 362 
                             ELSE IF ttEvento.tpEvento = "110112" 
                                  THEN 361
                                  ELSE 420
                   cEvMDFe = IF ttEvento.tpEvento = "110111" 
                             THEN "evCancMDFe"
                             ELSE IF ttEvento.tpEvento = "110112" 
                                  THEN "evEncMDFe"
                                ELSE IF ttEvento.tpEvento = "110115" 
                                  THEN "evIncDFeMDFe"
                                  else IF ttEvento.tpEvento = "110116"  
                                    THEN "evPagtoOperMDFe"
                                    ELSE "evIncCondutorMDFe".

            RUN addNode      IN hGenXml (getStack(), "eventoMDFe",        "", OUTPUT iId).
            RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/mdfe").
            RUN setAttribute IN hGenXml (INPUT iId,  "versao",  cVersaoMDFe).
            addStack(iId).

                RUN addNode      IN hGenXml (getStack(), "infEvento",     "", OUTPUT iId).
                RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("ID" + ttEvento.infEventoID)).
                addStack(iId).

                    RUN addNode      IN hGenXml (getStack(), "cOrgao",     ttEvento.cOrgao,     OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "tpAmb",      ttEvento.tpAmb,      OUTPUT iId).

                    IF  ttEvento.cnpj <> "" THEN
                        RUN addNode  IN hGenXml (getStack(), "CNPJ",       ttEvento.cnpj,       OUTPUT iId).
                    ELSE                                               
                        RUN addNode  IN hGenXml (getStack(), "CPF",        ttEvento.cpf,        OUTPUT iId).

                    RUN addNode      IN hGenXml (getStack(), "chMDFe",      ttEvento.chNFe,     OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "dhEvento",   ttEvento.dhEvento,   OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "tpEvento",   ttEvento.tpEvento,   OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "nSeqEvento", ttEvento.nSeqEvento, OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "detEvento",  "",                  OUTPUT iId).
                    RUN setAttribute IN hGenXml (INPUT iId,  "versaoEvento", cVersaoMDFe).
                    addStack(iId).
                        RUN addNode      IN hGenXml (getStack(), cEvMDFe,  "",                  OUTPUT iId).
                        addStack(iId).
                            RUN addNode IN hGenXml (getStack(), "descEvento", ttEvento.descEvento, OUTPUT iId).
                            IF ttEvento.tpEvento <> "110114" THEN
                                RUN addNode IN hGenXml (getStack(), "nProt",  ttEvento.nProt,   OUTPUT iId).
                            ELSE DO:
                                RUN addNode      IN hGenXml (getStack(), "condutor",  "",       OUTPUT iId).
                                addStack(iId).
                            END.
                            IF  ttEvento.tpEvento = "110112" THEN DO:
                                RUN addNode      IN hGenXml (getStack(), "dtEnc", c-dt-enc,          OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "cUF",   CAPS(c-uf)    ,    OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "cMun",  c-cod-mun-ibge,    OUTPUT iId).
                            END.
                            IF  ttEvento.tpEvento = "110114" THEN DO: 
                                RUN addNode  IN hGenXml (getStack(), "xNome", TRIM(SUBSTRING(ttEvento.xJust,1,60)),  OUTPUT iId).
                                RUN addNode  IN hGenXml (getStack(), "CPF",  TRIM(SUBSTRING(ttEvento.xJust,61,11)), OUTPUT iId).
                                delStack().
                            END.
                            IF  ttEvento.tpEvento = "110111" THEN
                                RUN addNode IN hGenXml (getStack(), "xJust",   ttEvento.xJust,   OUTPUT iId).
                            IF ttEvento.tpEvento = "110115" THEN DO:
                                FOR EACH ttevIncDFeMDFe: 
                                      RUN addNode  IN hGenXml (getStack(), "cMunCarrega", ttevIncDFeMDFe.cMunCarrega, OUTPUT iId).
                                      RUN addNode  IN hGenXml (getStack(), "xMunCarrega", ttevIncDFeMDFe.xMunCarrega, OUTPUT iId).
                                       
                                      FOR EACH ttinfDoc:
                                          RUN addNode IN hGenXml (getStack(), "infDoc", "", OUTPUT iId).
                                          addStack(iId).
                                              RUN addNode  IN hGenXml (getStack(), "cMunDescarga", ttinfDoc.cMunDescarga, OUTPUT iId).
                                              RUN addNode  IN hGenXml (getStack(), "xMunDescarga", ttinfDoc.xMunDescarga, OUTPUT iId).
                                              RUN addNode  IN hGenXml (getStack(), "chDFe",        ttinfDoc.chNFe,        OUTPUT iId).
                                          delStack().
                                      END.                     
                                END.
                            END.
                            IF ttEvento.tpEvento = "110116" THEN DO:
                                FOR EACH ttevPagtoOperMDFe: 
                                      //RUN addNode  IN hGenXml (getStack(), "descEvento", ttevPagtoOperMDFe.descEvento, OUTPUT iId).
                                      //RUN addNode  IN hGenXml (getStack(), "nProt", ttevPagtoOperMDFe.nProt, OUTPUT iId).
                                       
                                      RUN addNode IN hGenXml (getStack(), "infViagens", "", OUTPUT iId).
                                      addStack(iId).
                                          RUN addNode  IN hGenXml (getStack(), "qtdViagens", ttevPagtoOperMDFe.qtdViagens, OUTPUT iId).
                                          RUN addNode  IN hGenXml (getStack(), "nroViagem", ttevPagtoOperMDFe.nroViagem, OUTPUT iId).                                          
                                      delStack().
                                      
                                      FOR EACH ttinfPag:
                                          RUN addNode IN hGenXml (getStack(), "infPag", "", OUTPUT iId).
                                          addStack(iId).                                      
                                              IF ttinfPag.xNome <> ? AND ttinfPag.xNome <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "xNome", ttinfPag.xNome, OUTPUT iId).
                                              IF ttinfPag.CPF <> ? AND ttinfPag.CPF <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "CPF", ttinfPag.CPF, OUTPUT iId).
                                              IF ttinfPag.CNPJ <> ? AND ttinfPag.CNPJ <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "CNPJ", ttinfPag.CNPJ, OUTPUT iId).
                                              IF ttinfPag.idEstrangeiro <> ? AND ttinfPag.idEstrangeiro <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "idEstrangeiro", ttinfPag.idEstrangeiro, OUTPUT iId).    
                                              
                                              FOR EACH ttComp
                                                 WHERE ttComp.id = ttinfPag.id:
                                                  RUN addNode IN hGenXml (getStack(), "Comp", "", OUTPUT iId).
                                                  addStack(iId). 
                                                      RUN addNode  IN hGenXml (getStack(), "tpComp", ttComp.tpComp, OUTPUT iId).
                                                      
                                                      {adapters/xml/ep2/axsep017nodedec.i   "vComp" ttComp.vComp "YES" 2 "YES"}
                                                      
                                                      IF ttComp.xComp <> ? AND ttComp.xComp <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "xComp", ttComp.xComp, OUTPUT iId).
                                                  delStack().                                                 
                                              END.
                                              
                                              {adapters/xml/ep2/axsep017nodedec.i  "vContrato" ttinfPag.vContrato  "YES" 2 "YES"}
                                              
                                              RUN addNode  IN hGenXml (getStack(), "indPag", ttinfPag.indPag, OUTPUT iId).    
                                             
                                              IF CAN-FIND (FIRST funcao NO-LOCK
                                                           WHERE funcao.cd-funcao = "spp-mdfe-nt2021002"
                                                           AND   funcao.ativo) 
                                              AND ttinfPag.indpag = "1" THEN 
                                                  {adapters/xml/ep2/axsep017nodedec.i "vAdiant" ttinfPag.vAdiant "no" 2 "no"}
                                              
                                              FOR EACH ttinfPrazo
                                                 WHERE ttinfPrazo.id = ttinfPag.id:
                                                  RUN addNode IN hGenXml (getStack(), "infPrazo", "", OUTPUT iId).
                                                  addStack(iId). 
                                                      IF ttinfPrazo.nParcela <> ? AND ttinfPrazo.nParcela <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "nParcela", ttinfPrazo.nParcela, OUTPUT iId).
                                                      IF ttinfPrazo.dVenc <> ? AND ttinfPrazo.dVenc <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "dVenc", ttinfPrazo.dVenc, OUTPUT iId).
                                                                                                            
                                                      {adapters/xml/ep2/axsep017nodedec.i "vParcela" ttinfPrazo.vParcela "YES" 2 "YES"}                                                    
                                                      
                                                  delStack().
                                              END.                                             
                                             
                                              RUN addNode IN hGenXml (getStack(), "infBanc", "", OUTPUT iId).
                                              addStack(iId).
                                                  IF  ttinfPag.codBanco   <> ? AND ttinfPag.codBanco   <> "" 
                                                  AND ttinfPag.codAgencia <> ? AND ttinfPag.codAgencia <> "" THEN DO: 
                                                      RUN addNode  IN hGenXml (getStack(), "codBanco",   ttinfPag.codBanco,   OUTPUT iId).    
                                                      RUN addNode  IN hGenXml (getStack(), "codAgencia", ttinfPag.codAgencia, OUTPUT iId).    
                                                  END.
                                                  ELSE IF ttinfPag.CNPJIPEF <> ? AND ttinfPag.CNPJIPEF <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "CNPJIPEF",   ttinfPag.CNPJIPEF,   OUTPUT iId).
                                                  ELSE IF ttinfPag.PIX      <> ? AND ttinfPag.PIX      <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "PIX",        ttinfPag.PIX,        OUTPUT iId).   
                                              delStack().
                                              
                                          delStack().
                                      END.
                                END.
                            END.
                        delStack().
                    
                    delStack().

                delStack().

            delStack().

        delStack().

        RUN generateXML IN hGenXml (OUTPUT hXMLEvento).

        hXMLEvento:SAVE("LONGCHAR",lcXMLEvento).
        
        EMPTY TEMP-TABLE tt-erro.

        RUN piSalvaXMLdiretorio (INPUT hXMLEvento).
            
        /*hXMLEvento:SAVE('FILE', "C:\temp\XML\teste_cancel_mdfe.xml").*/
        RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                           INPUT "MDF-e":U,
                           OUTPUT cTpTrans).

        /*hXMLEvento:SAVE('FILE', "C:\temp\XML\teste_cancel_mdfe.xml").*/
        IF  cTpTrans = "TC2":U THEN DO:
            RUN cdp/cdapi590.p (INPUT icdEDI, 
                                INPUT hXMLEvento,
                                INPUT ttEvento.chNFe,
                                OUTPUT TABLE tt-erro).
        END.
        IF  cTpTrans = "TPF":U THEN DO:
            RUN cdp/cdapi590tpf.p (INPUT icdEDI,
                                   INPUT hXMLEvento,
                                   INPUT ttEvento.chNFe,
                                   OUTPUT TABLE tt-erro).
        END.

        FOR EACH tt-erro:
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = tt-erro.cd-erro
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO  = tt-erro.mensagem
                   TT_LOG_ERRO.TTV_DES_MSG_AJUDA = tt-erro.mensagem.
        END.

    &ENDIF

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-integra-XML-mde:

    DEFINE VARIABLE cTpTrans   AS CHARACTER NO-UNDO.

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN

        DEFINE VARIABLE hXMLEvento           AS HANDLE      NO-UNDO.
                
        FIND FIRST param-manif-destin WHERE
            param-manif-destin.cod-estab = estabelec.cod-estabel NO-LOCK NO-ERROR.
    
        IF  NOT AVAIL param-manif-destin THEN DO:
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
            {utp/ut-liter.i "Parametros_Estabelecimento_MDe_nao_encontrado" *}
            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE 
                   tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
            RETURN tt_log_erro.ttv_des_msg_erro.
        END.
    
        IF  param-manif-destin.cod-md-vers = "" THEN DO:
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
            {utp/ut-liter.i "Versao_MDe_nao_informada" *}
            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE 
                   tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
            RETURN tt_log_erro.ttv_des_msg_erro.
        END.
        
        RUN reset       IN hGenXml.
        RUN setEncoding IN hGenXml ("UTF-8":U).

        addStack(iId).

            FOR FIRST ttEvento NO-LOCK: END. 
            
            RUN addNode      IN hGenXml (getStack(), "evento", "",      OUTPUT iId).
            RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/nfe").
            RUN setAttribute IN hGenXml (INPUT iId,  "versao",  ttEvento.verEvento).

            addStack(iId).

                RUN addNode      IN hGenXml (getStack(), "infEvento",     "", OUTPUT iId).
                RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("ID" + ttEvento.infEventoID)).
                addStack(iId).

                    RUN addNode      IN hGenXml (getStack(), "cOrgao",     ttEvento.cOrgao,     OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "tpAmb",      ttEvento.tpAmb,      OUTPUT iId).

                    IF  ttEvento.cnpj <> "" THEN
                        RUN addNode  IN hGenXml (getStack(), "CNPJ",       ttEvento.cnpj,       OUTPUT iId).
                    ELSE                                               
                        RUN addNode  IN hGenXml (getStack(), "CPF",        ttEvento.cpf,        OUTPUT iId).

                    RUN addNode      IN hGenXml (getStack(), "chNFe",      ttEvento.chNFe,      OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "dhEvento",   ttEvento.dhEvento,   OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "tpEvento",   ttEvento.tpEvento,   OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "nSeqEvento", string(int(ttEvento.nSeqEvento), "9"), OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "verEvento",  ttEvento.verEvento,  OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "detEvento",  "",                  OUTPUT iId).
                    RUN setAttribute IN hGenXml (INPUT iId,  "versao",     ttEvento.verEvento).
                    addStack(iId).
                        
                        RUN addNode      IN hGenXml (getStack(), "descEvento" , ttEvento.descEvento, OUTPUT iId).
                        IF  ttEvento.xJust <> "" THEN
                            RUN addNode      IN hGenXml (getStack(), "xJust"  , ttEvento.xJust,      OUTPUT iId).

                    delStack().

                delStack().
            
            delStack().

        delStack().

        RUN generateXML IN hGenXml (OUTPUT hXMLEvento) NO-ERROR.

        EMPTY TEMP-TABLE tt-erro.

        RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                           INPUT IF lMDFe THEN "MDF-e" ELSE "MD-e":U,
                           OUTPUT cTpTrans).

        /*hXMLEvento:SAVE('FILE', "C:\temp\XML\teste_cancel_mdfe.xml").*/
        IF  cTpTrans = "TC2":U THEN DO:
            RUN cdp/cdapi590.p (INPUT 320, /*Codigo Neogrid Evento*/
                                INPUT hXMLEvento,
                                INPUT ttEvento.chNFe,
                                OUTPUT TABLE tt-erro).
        END.
        IF  cTpTrans = "TPF":U THEN DO:
            RUN cdp/cdapi590tpf.p (INPUT 320, /*Codigo Neogrid Evento*/
                                INPUT hXMLEvento,
                                INPUT ttEvento.chNFe,
                                OUTPUT TABLE tt-erro).
        END.

        FOR EACH tt-erro:
            CREATE TT_LOG_ERRO.
            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = tt-erro.cd-erro
                   TT_LOG_ERRO.TTV_DES_MSG_ERRO  = tt-erro.mensagem
                   TT_LOG_ERRO.TTV_DES_MSG_AJUDA = tt-erro.mensagem.
        END.
        
    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-TSS-Sincrono:

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
    
        DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hXMLEvento           AS HANDLE      NO-UNDO.
        DEFINE VARIABLE lEnvioEventoTSSOK    AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
        
        DEFINE VARIABLE c-cod-estabel AS CHARACTER   NO-UNDO.
        ASSIGN lcXMLEvento = "".

            RUN reset       IN hGenXml.
            RUN setEncoding IN hGenXml ("UTF-8").
            addStack(iId).
                FOR FIRST ttEvento: END.

                RUN addNode      IN hGenXml (getStack(), "envEvento",    "", OUTPUT iId).
                /*RUN setAttribute IN hGenxml (iId, "verEvento", ttEvento.verEvento).
                RUN setAttribute IN hGenxml (iId, "xmlns", "http://www.portalfiscal.inf.br/nfe").*/
                addStack(iId).
                    RUN addNode      IN hGenXml (getStack(), "eventos",        "", OUTPUT iId).
                    addStack(iId).
                        FOR EACH ttEvento: 
                            ASSIGN c-cod-estabel = ttEvento.codEstab.

                            RUN addNode      IN hGenXml (getStack(), "detEvento",    "", OUTPUT iId).
                            addStack(iId).
                                RUN addNode      IN hGenXml (getStack(), "tpEvento", ttEvento.tpEvento, OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "chNFe"   , ttEvento.chNFe,    OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "ambiente", ttEvento.tpAmb,    OUTPUT iId).

                                IF ttEvento.tpEvento = "110112" THEN DO:
                                    ASSIGN c-dt-enc       = c-ano + "-" + c-mes + "-" + c-dia
                                           c-uf           = SUBSTRING(ttEvento.xJust,1,2)
                                           c-cod-mun-ibge = TRIM(SUBSTRING(ttEvento.xJust,4,7)).

                                    IF  c-uf = "EX" THEN
                                        ASSIGN c-cod-mun-ibge = "9999999".

                                    RUN addNode      IN hGenXml (getStack(), "dtEnc", c-dt-enc,          OUTPUT iId).
                                    RUN addNode      IN hGenXml (getStack(), "cUF",   CAPS(c-uf)    ,    OUTPUT iId).
                                    RUN addNode      IN hGenXml (getStack(), "cMun",  c-cod-mun-ibge,    OUTPUT iId).
                                END.
                                ELSE IF ttEvento.tpEvento = "110114" THEN DO: /*Novo Evento MDF-e - Inclus„o de condutor*/
                                    RUN addNode  IN hGenXml (getStack(), "nomecondutor", TRIM(SUBSTRING(ttEvento.xJust,1,60)),  OUTPUT iId).
                                    RUN addNode  IN hGenXml (getStack(), "cpfcondutor",  TRIM(SUBSTRING(ttEvento.xJust,61,11)), OUTPUT iId).
                                END.
                                ELSE IF ttEvento.tpEvento = "110115" THEN DO:
                                    FOR EACH ttevIncDFeMDFe: 
                                          RUN addNode  IN hGenXml (getStack(), "descEvento",  ttevIncDFeMDFe.descEvento,  OUTPUT iId).
                                          //RUN addNode  IN hGenXml (getStack(), "nProt",       ttevIncDFeMDFe.nProt,       OUTPUT iId).
                                          RUN addNode  IN hGenXml (getStack(), "cMunCarrega", ttevIncDFeMDFe.cMunCarrega, OUTPUT iId).
                                          RUN addNode  IN hGenXml (getStack(), "xMunCarrega", ttevIncDFeMDFe.xMunCarrega, OUTPUT iId).
                                           
                                          FOR EACH ttinfDoc:
                                              RUN addNode IN hGenXml (getStack(), "infDoc", "", OUTPUT iId).
                                              addStack(iId).
                                                  RUN addNode  IN hGenXml (getStack(), "cMunDescarga", ttinfDoc.cMunDescarga, OUTPUT iId).
                                                  RUN addNode  IN hGenXml (getStack(), "xMunDescarga", ttinfDoc.xMunDescarga, OUTPUT iId).
                                                  RUN addNode  IN hGenXml (getStack(), "chDFe",        ttinfDoc.chNFe,        OUTPUT iId).
                                              delStack().
                                          END.                     
                                    END.
                                END.
                                ELSE IF ttEvento.tpEvento = "110116" THEN DO:
                                    FOR EACH ttevPagtoOperMDFe: 
                                      //RUN addNode  IN hGenXml (getStack(), "descEvento", ttevPagtoOperMDFe.descEvento, OUTPUT iId).
                                      //RUN addNode  IN hGenXml (getStack(), "nProt", ttevPagtoOperMDFe.nProt, OUTPUT iId).
                                       
                                      //RUN addNode IN hGenXml (getStack(), "infViagens", "", OUTPUT iId).
                                      //addStack(iId).
                                          RUN addNode  IN hGenXml (getStack(), "qtdViagens", ttevPagtoOperMDFe.qtdViagens, OUTPUT iId).
                                          RUN addNode  IN hGenXml (getStack(), "nroViagem", ttevPagtoOperMDFe.nroViagem, OUTPUT iId).                                          
                                      //delStack().
                                      
                                      FOR EACH ttinfPag:
                                          RUN addNode IN hGenXml (getStack(), "infPag", "", OUTPUT iId).
                                          addStack(iId).                                      
                                              IF ttinfPag.xNome <> ? AND ttinfPag.xNome <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "xNome", ttinfPag.xNome, OUTPUT iId).
                                              IF ttinfPag.CPF <> ? AND ttinfPag.CPF <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "CPF", ttinfPag.CPF, OUTPUT iId).
                                              IF ttinfPag.CNPJ <> ? AND ttinfPag.CNPJ <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "CNPJ", ttinfPag.CNPJ, OUTPUT iId).
                                              IF ttinfPag.idEstrangeiro <> ? AND ttinfPag.idEstrangeiro <> "" THEN
                                              RUN addNode  IN hGenXml (getStack(), "idEstrangeiro", ttinfPag.idEstrangeiro, OUTPUT iId).    
                                              
                                              FOR EACH ttComp
                                                 WHERE ttComp.id = ttinfPag.id:
                                                  RUN addNode IN hGenXml (getStack(), "Comp", "", OUTPUT iId).
                                                  addStack(iId). 
                                                      RUN addNode  IN hGenXml (getStack(), "tpComp", ttComp.tpComp, OUTPUT iId).
                                                      
                                                      {adapters/xml/ep2/axsep017nodedec.i   "vComp" ttComp.vComp "YES" 2 "YES"}
                                                      
                                                      IF ttComp.xComp <> ? AND ttComp.xComp <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "xComp", ttComp.xComp, OUTPUT iId).
                                                  delStack().                                                 
                                              END.
                                              
                                              {adapters/xml/ep2/axsep017nodedec.i  "vContrato" ttinfPag.vContrato  "YES" 2 "YES"}
                                              
                                              RUN addNode  IN hGenXml (getStack(), "indPag", ttinfPag.indPag, OUTPUT iId).    

                                              IF CAN-FIND (FIRST funcao NO-LOCK
                                                           WHERE funcao.cd-funcao = "spp-mdfe-nt2021002"
                                                           AND   funcao.ativo) 
                                              AND ttinfPag.indpag = "1" THEN
                                                 {adapters/xml/ep2/axsep017nodedec.i "vAdiant" ttinfPag.vAdiant "no" 2 "no"}
                                             
                                              FOR EACH ttinfPrazo
                                                 WHERE ttinfPrazo.id = ttinfPag.id:
                                                  RUN addNode IN hGenXml (getStack(), "infPrazo", "", OUTPUT iId).
                                                  addStack(iId). 
                                                      IF ttinfPrazo.nParcela <> ? AND ttinfPrazo.nParcela <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "nParcela", ttinfPrazo.nParcela, OUTPUT iId).
                                                      IF ttinfPrazo.dVenc <> ? AND ttinfPrazo.dVenc <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "dVenc", ttinfPrazo.dVenc, OUTPUT iId).
                                                      
                                                      {adapters/xml/ep2/axsep017nodedec.i "vParcela" ttinfPrazo.vParcela "YES" 2 "YES"}                                                    
                                                  delStack().
                                              END.                                             
                                             
                                              RUN addNode IN hGenXml (getStack(), "infBanc", "", OUTPUT iId).
                                              addStack(iId).
                                                  IF  ttinfPag.codBanco   <> ? AND ttinfPag.codBanco   <> "" 
                                                  AND ttinfPag.codAgencia <> ? AND ttinfPag.codAgencia <> "" THEN DO: 
                                                      RUN addNode  IN hGenXml (getStack(), "codBanco",   ttinfPag.codBanco,   OUTPUT iId).    
                                                      RUN addNode  IN hGenXml (getStack(), "codAgencia", ttinfPag.codAgencia, OUTPUT iId).    
                                                  END.
                                                  ELSE IF ttinfPag.CNPJIPEF <> ? AND ttinfPag.CNPJIPEF <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "CNPJIPEF", ttinfPag.CNPJIPEF, OUTPUT iId).    
                                                  ELSE IF ttinfPag.PIX      <> ? AND ttinfPag.PIX      <> "" THEN
                                                      RUN addNode  IN hGenXml (getStack(), "PIX", ttinfPag.PIX, OUTPUT iId).   

                                              delStack().
                                              
                                          delStack().
                                        END.
                                    END.
                                END.
                                ELSE 
                                    RUN addNode      IN hGenXml (getStack(), "xJust"   , ttEvento.xJust,    OUTPUT iId).
                            delStack().
                        END.
                    delStack().
                delStack().
            delStack().

            RUN generateXML IN hGenXml (OUTPUT hXMLEvento).
    
            hXMLEvento:SAVE("LONGCHAR",lcXMLEvento).
            ASSIGN lcXMLEvento = SUBSTR(lcXMLEvento, INDEX(lcXMLEvento, "<EnvEvento")).
            
            RUN piSalvaXMLdiretorio (INPUT hXMLEvento).
           
            IF  NOT AVAIL param-nf-estab THEN
                FOR FIRST param-nf-estab NO-LOCK
                    WHERE param-nf-estab.cod-estabel = c-cod-estabel: END.
    
            IF  NOT AVAIL param-nf-estab THEN
                RETURN "NOK".
    
            IF  NOT VALID-HANDLE(h-TSSAPI) THEN
                RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. 
            
            RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                         TRIM(param-nf-estab.cod-url-ws-tss)
                                       &else
                                         TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                                       &endif).
                                       
            RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                             INPUT "*",
                                             INPUT param-nf-estab.cod-estabel,
                                             INPUT param-nf-estab.cod-url-ws-tss).
    
            RUN NFESBRA_REMESSAEVENTO IN h-TSSAPI (INPUT  param-nf-estab.ind-empresa, 
                                                   INPUT  lcXMLEvento,
                                                   OUTPUT cReturnValue). 

            RUN disconnectTss IN h-TSSAPI ("NFESBRA").
      
            IF  VALID-HANDLE(h-TSSAPI) THEN DO:
                DELETE PROCEDURE h-TSSAPI.
                ASSIGN h-TSSAPI = ?.
            END.

            ASSIGN iSeq =  int(substring(cReturnValue, INDEX(cReturnValue, "</STRING>") - 2, 2)) NO-ERROR.

    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.

                

PROCEDURE piSincronizaDocumentos.
          
    DEFINE INPUT PARAMETER estab  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER indnfe AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER indemi AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.

    DEFINE VARIABLE hXMLMDe       AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue  AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cTpTrans   AS CHARACTER NO-UNDO.

    FIND FIRST estabelec WHERE
        estabelec.cod-estabel = estab NO-LOCK NO-ERROR.

    IF  NOT AVAIL estabelec THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
        {utp/ut-liter.i "Estabelecimento_nao_encontrado" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE 
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        RETURN tt_log_erro.ttv_des_msg_erro.
    END.
    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = estabelec.cod-emitente:
    END.

    FIND FIRST param-manif-destin WHERE
        param-manif-destin.cod-estab = estabelec.cod-estabel NO-LOCK NO-ERROR.

    IF  NOT AVAIL param-manif-destin THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
        {utp/ut-liter.i "Parametros_Estabelecimento_MDe_nao_encontrado" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE 
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        RETURN tt_log_erro.ttv_des_msg_erro.
    END.

    IF  param-manif-destin.cod-md-vers = "" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
        {utp/ut-liter.i "Versao_MDe_nao_informada" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE 
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        RETURN tt_log_erro.ttv_des_msg_erro.
    END.

    RUN reset       IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8").

    addStack(iId).
 
        RUN addNode      IN hGenXml (getStack(), "consNFeDest", "", OUTPUT iId).
        RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/nfe").
        RUN setAttribute IN hGenXml (INPUT iId,  "versao",   param-manif-destin.cod-md-vers).
        
        addStack(iId).

            RUN addNode      IN hGenXml (getStack(), "tpAmb",   STRING(param-manif-destin.idi-md-ambien),        OUTPUT iId).
            RUN addNode      IN hGenXml (getStack(), "xServ",   "CONSULTAR NFE DEST",                            OUTPUT iId).
            IF emitente.natureza = 1 /*Pessoa F°sica*/ THEN
                RUN addNode      IN hGenXml (getStack(), "CPF",    SUBSTRING(estabelec.cgc,4,11),                OUTPUT iId).
            ELSE
                RUN addNode      IN hGenXml (getStack(), "CNPJ",    estabelec.cgc,                               OUTPUT iId).

            RUN addNode      IN hGenXml (getStack(), "indNFe",  indnfe,                                          OUTPUT iId).
            RUN addNode      IN hGenXml (getStack(), "indEmi",  indemi,                                          OUTPUT iId).
            RUN addNode      IN hGenXml (getStack(), "ultNSU",  STRING(param-manif-dest.cod-ult-seqcial-unico),  OUTPUT iId).
            
        delStack().
    delStack().

    RUN generateXML IN hGenXml (OUTPUT hXMLMDe).

    /*hXMLMDe:SAVE('FILE', "C:\temp\teste_MDe.xml").*/

    RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                       INPUT IF lMDFe THEN "MDF-e" ELSE "MD-e":U,
                       OUTPUT cTpTrans).

    IF  cTpTrans = "TC2":U THEN DO:
        RUN cdp/cdapi590.p (INPUT 338, /*Codigo Neogrid NF-e*/
                            INPUT hXMLMDe,
                            INPUT ( IF emitente.natureza = 1 /*Pessoa F°sica*/ THEN SUBSTRING(estabelec.cgc,4,11) ELSE estabelec.cgc),
                            OUTPUT TABLE tt-erro).
    END.
    IF  cTpTrans = "TPF":U THEN DO:
        RUN cdp/cdapi590tpf.p (INPUT 338, /*Codigo Neogrid NF-e*/
                            INPUT hXMLMDe,
                            INPUT ( IF emitente.natureza = 1 /*Pessoa F°sica*/ THEN SUBSTRING(estabelec.cgc,4,11) ELSE estabelec.cgc),
                            OUTPUT TABLE tt-erro).
    END.

    FOR EACH tt-erro:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = tt-erro.cd-erro
               TT_LOG_ERRO.TTV_DES_MSG_ERRO  = tt-erro.mensagem
               TT_LOG_ERRO.TTV_DES_MSG_AJUDA = tt-erro.mensagem.
        RETURN tt_log_erro.ttv_des_msg_erro.
    END.


    DELETE OBJECT hXMLMDe NO-ERROR.

    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piSincronizaDocumentosDFe:
    DEFINE INPUT  PARAMETER estab  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE  FOR tt_log_erro.

    DEFINE VARIABLE hXMLMDe             AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cReturnValue        AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-UFAutor           AS CHARACTER   NO-UNDO.

    DEFINE VARIABLE cTpTrans   AS CHARACTER NO-UNDO.

    FIND FIRST estabelec NO-LOCK 
        WHERE estabelec.cod-estabel = estab NO-ERROR.

    IF NOT AVAIL estabelec THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.

        {utp/ut-liter.i "Estabelecimento_nao_encontrado" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        
        RETURN tt_log_erro.ttv_des_msg_erro.
    END.

    FIND FIRST unid-feder NO-LOCK
        WHERE unid-feder.pais   = estabelec.pais
        AND   unid-feder.estado = estabelec.estado NO-ERROR.
    IF AVAIL unid-feder THEN
        ASSIGN c-UFAutor = unid-feder.cod-uf-ibge. 

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = estabelec.cod-emitente:
    END.
    
    FIND FIRST param-manif-destin NO-LOCK 
        WHERE param-manif-destin.cod-estab = estabelec.cod-estabel NO-ERROR.

    IF NOT AVAIL param-manif-destin THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.

        {utp/ut-liter.i "Parametros_Estabelecimento_MDe_nao_encontrado" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.

        RETURN tt_log_erro.ttv_des_msg_erro.
    END.

    IF param-manif-destin.cod-md-vers = "" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 17006.

        {utp/ut-liter.i "Versao_MDe_nao_informada" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.

        RETURN tt_log_erro.ttv_des_msg_erro.
    END.

    RUN reset IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8").
    
    addStack(iId).
    
        RUN addNode      IN hGenXml (getStack(), "distDFeInt", "", OUTPUT iId).
        RUN setAttribute IN hGenXml (INPUT iId, "xmlns", "http://www.portalfiscal.inf.br/nfe").
        RUN setAttribute IN hGenXml (INPUT iId, "versao", param-manif-destin.cod-md-vers).
    
        addStack(iId).

            RUN addNode IN hGenXml (getStack(), "tpAmb",    STRING(param-manif-destin.idi-md-ambien),         OUTPUT iId).
            RUN addNode IN hGenXml (getStack(), "cUFAutor", c-UFAutor,                                        OUTPUT iId).

            IF emitente.natureza = 1 /*Pessoa F°sica*/ THEN
                RUN addNode IN hGenXml (getStack(), "CPF",     substring(estabelec.cgc,4,11),                OUTPUT iId).
            ELSE
                RUN addNode IN hGenXml (getStack(), "CNPJ",     estabelec.cgc,                                OUTPUT iId).
            
            RUN addNode IN hGenXml (getStack(), "distNSU",  "",                                               OUTPUT iId).
            addStack(iId).
                RUN addNode IN hGenXml (getStack(), "ultNSU", param-manif-destin.cod-ult-seqcial-unico,       OUTPUT iId). 
            delStack().
        delStack().
    delStack().

    RUN generateXML IN hGenXml (OUTPUT hXMLMDe).
    
    RUN cdp/cd0360b.p (INPUT estabelec.cod-estabel,
                       INPUT IF lMDFe THEN "MDF-e" ELSE "MD-e":U,
                       OUTPUT cTpTrans).

    IF  cTpTrans = "TC2":U THEN DO:
        RUN cdp/cdapi590.p (INPUT 443, /* Codigo Neogrid DF-e */
                            INPUT hXMLMDe,
                            INPUT (IF emitente.natureza = 1  THEN substring(estabelec.cgc,4,11) ELSE estabelec.cgc),
                            OUTPUT TABLE tt-erro).
    END.
    IF  cTpTrans = "TPF":U THEN DO:
        RUN cdp/cdapi590tpf.p (INPUT 443, /* Codigo Neogrid DF-e */
                            INPUT hXMLMDe,
                            INPUT (IF emitente.natureza = 1  THEN substring(estabelec.cgc,4,11) ELSE estabelec.cgc),
                            OUTPUT TABLE tt-erro).
    END.

    FOR EACH tt-erro:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = tt-erro.cd-erro
               TT_LOG_ERRO.TTV_DES_MSG_ERRO  = tt-erro.mensagem
               TT_LOG_ERRO.TTV_DES_MSG_AJUDA = tt-erro.mensagem.
         RETURN tt_log_erro.ttv_des_msg_erro.
    END.

    DELETE OBJECT hXMLMDe NO-ERROR.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE piConfigurarParametro.
          
    DEFINE INPUT PARAMETER id_ent   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ambiente AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER versao   AS CHARACTER NO-UNDO.

    {xmlinc/xmlloadmessagehandler.i &MessageHandler="hMessageHandler" &MHReturnValue="cReturnValue"}

    IF cReturnValue <> "OK" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_ao_executar_MessageHandle" *}
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + ": "+ cReturnValue
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        RETURN cReturnValue.
    END.


    RUN isSubscribed IN hMessageHandler ("{&XmlProdName}", "{&XmlApp}", "{&XmlTranName}", "{&XmlTranVersion}", "upd", "CONFIGURARPARAMETROSENV", OUTPUT lCreateMsg).


    IF RETURN-VALUE <> "OK" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-3 AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-liter-3 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-erro-ao-executar-is2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Erro_ao_executar_isSubscribed_no_MessageHandle" *}
        ASSIGN c-lbl-liter-erro-ao-executar-is2 = TRIM(RETURN-VALUE).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = c-lbl-liter-erro-ao-executar-is2 + ": "+ c-lbl-liter-3
               tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
        RETURN RETURN-VALUE.
    END.

    IF NOT lCreateMsg THEN DO:
         CREATE TT_LOG_ERRO.
              ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 17006.
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "A_transaá∆o_'{&XmlTranName}'_n∆o_Ç_assinada" *}
              ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE + '.'
                     tt_log_erro.ttv_des_msg_ajuda = tt_log_erro.ttv_des_msg_erro.
         RETURN "OK".
    END.

    RUN setTransInfoComment IN hMessageHandler ("Comment").
    RUN setSystemId         IN hMessageHandler ("{&XmlMod}",  "{&XmlProdVersion}").
    
    RUN setKeyFields IN hMessageHandler ("ID_ENT", id_ent).

    RUN setCompanyId        IN hMessageHandler (STRING(v_cdn_empres_usuar), "").

    RUN reset       IN hGenXml.
    RUN setEncoding IN hGenXml ("UTF-8").
    RUN addNode     IN hGenXml (getStack(), "Upsert", "", OUTPUT iId).

    addStack(iId).

    RUN addNode IN hGenXml (getStack(), "USERTOKEN", "",                        OUTPUT iId).
    RUN addNode IN hGenXml (getStack(), "ID_ENT",    ID_ENT, OUTPUT iId).
    RUN addNode IN hGenXml (getStack(), "AMBIENTE",  AMBIENTE, OUTPUT iId).
    RUN addNode IN hGenXml (getStack(), "VERSAO",    VERSAO, OUTPUT iId).


    delStack().

    RUN generateXML         IN hGenXml (OUTPUT hBusinessContent).

    RUN generateXMLToMemptr IN hGenXml (OUTPUT inPtr) NO-ERROR.
    COPY-LOB inPtr TO lcConteudo.

    IF RETURN-VALUE = "Leave" THEN RETURN "OK".

    RUN setBusinessContent IN hMessageHandler (INPUT  hBusinessContent).
    DELETE OBJECT hBusinessContent NO-ERROR.
    RUN sendMessage        IN hMessageHandler (INPUT "xmlschema/ep2/MDConfigurarParametros_Env_204_000_v1.00.xsd").


    IF  RETURN-VALUE <> "OK" THEN DO:
        CREATE TT_LOG_ERRO.
        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO = 0.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-4 AS CHARACTER NO-UNDO.
        ASSIGN c-lbl-liter-4 = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-erro-no-envio-da-ms2 AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Erro_no_envio_da_Mensagem" *}
        ASSIGN c-lbl-liter-erro-no-envio-da-ms2 = TRIM(RETURN-VALUE).
        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO = c-lbl-liter-erro-no-envio-da-ms2 + ": " + c-lbl-liter-4.
        RETURN RETURN-VALUE.
    END.

    RUN getReturnStatus IN hMessageHandler (OUTPUT pSendSuccess, OUTPUT pTotalErrors).

    IF  NOT pSendSuccess THEN DO:
        REPEAT iCount = 1 TO pTotalErrors:
            CREATE TT_LOG_ERRO.
            RUN getError IN hMessageHandler (iCount, OUTPUT TT_LOG_ERRO.TTV_NUM_COD_ERRO, OUTPUT pErrorType, OUTPUT TT_LOG_ERRO.TTV_DES_MSG_ERRO).
        END.
        RETURN "NOK".
    END.



END PROCEDURE.

PROCEDURE piSalvaXMLdiretorio:
    DEFINE INPUT PARAMETER h-XMLEvento        AS HANDLE      NO-UNDO.
    DEFINE VARIABLE cArquivoHistoricoXML AS CHARACTER   NO-UNDO.
    
    FOR FIRST ttEvento:
    
        FIND FIRST mdfe-param NO-LOCK 
             WHERE mdfe-param.cod-estabel = ttEvento.codEstab NO-ERROR.
    
        IF ttEvento.tpEvento = "110115" OR ttEvento.tpEvento = "110116" THEN DO:
            
            /* GRAVA HISTORICO XML EM DIRET‡RIO */
            ASSIGN cArquivoHistoricoXML = TRIM(mdfe-param.cod-dir-xml-histor-mdfe)
                   cArquivoHistoricoXML = REPLACE(cArquivoHistoricoXML,"~\","/").

            IF  cArquivoHistoricoXML <> "" THEN DO:
                IF  NOT SUBSTR(cArquivoHistoricoXML,LENGTH(cArquivoHistoricoXML),LENGTH(cArquivoHistoricoXML) - 1) = "/"  THEN
                    ASSIGN cArquivoHistoricoXML = cArquivoHistoricoXML + "/".

                ASSIGN cArquivoHistoricoXML =  cArquivoHistoricoXML                                                                                                                       
                                             + c-nome-arquivo-xml
                                             + "/".     

                ASSIGN FILE-INFO:FILE-NAME = cArquivoHistoricoXML.
                IF  FILE-INFO:FULL-PATHNAME = ? THEN
                    OS-CREATE-DIR value(cArquivoHistoricoXML) NO-ERROR.

                ASSIGN cArquivoHistoricoXML =   cArquivoHistoricoXML
                                              + STRING(YEAR(TODAY),"9999")              /* ex: 2010   (Ano)       */
                                              + STRING(MONTH(TODAY),"99")               /* ex: 05     (Mes Maio)  */
                                              + STRING(DAY(TODAY),"99")                 /* ex: 01     (Dia)       */
                                              + REPLACE(STRING(TIME,"HH:MM:SS"),":","") /* Ex: 140105 (14h01m05s) */
                                              + ".xml":U.
                h-XMLEvento:SAVE ('FILE', cArquivoHistoricoXML) NO-ERROR.
            END.            
        END.
    END.
            
END PROCEDURE.

PROCEDURE PIRetornaSequence:
    DEF OUTPUT PARAMETER pSeq AS IN NO-UNDO.

    ASSIGN pSeq = iSeq.


END PROCEDURE.
