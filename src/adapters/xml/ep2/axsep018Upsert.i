FUNCTION fnDateTZ RETURNS CHAR (INPUT pcvalue AS DATETIME-TZ):
    DEF VAR c-data AS CHAR FORMAT 'x(32)'.

    ASSIGN c-data = string(pcvalue,'9999-99-99THH:MM:SS-HH:MM')
           OVERLAY(c-data,1,10) = STRING(YEAR(pcvalue),'9999') + '-' + STRING(MONTH(pcvalue),'99') + '-' + STRING(DAY(pcvalue),'99').

    RETURN c-data.
    
END FUNCTION.
PROCEDURE PITransUpsert:    
    DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pTpEvento   AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-dados-evento.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

    DEF VAR l-funcao-tss   AS LOG         NO-UNDO.
    DEF VAR l-epp          AS LOG         NO-UNDO.
    DEF VAR c-dia          AS CHAR        NO-UNDO.
    DEF VAR c-mes          AS CHAR        NO-UNDO.
    DEF VAR c-ano          AS CHAR        NO-UNDO.
    DEF VAR c-hora         AS CHAR        NO-UNDO FORMAT "x(15)".
    DEF VAR da-tz          AS DATETIME-TZ NO-UNDO.
    DEF VAR p-dh-formatada AS CHAR        NO-UNDO.
    DEF VAR i-serie        AS IN          NO-UNDO.
    DEF VAR l-nfe-pfe      AS LOG         NO-UNDO.
    
    FIND FIRST tt-dados-evento NO-LOCK NO-ERROR.
    
    FIND FIRST nota-fiscal WHERE 
               nota-fiscal.cod-estabel = tt-dados-evento.cod-estab    AND
               nota-fiscal.serie       = tt-dados-evento.cod-serie    AND
               nota-fiscal.nr-nota-fis = tt-dados-evento.cod-nota-fis NO-LOCK NO-ERROR.

    IF  AVAIL nota-fiscal THEN DO:

        ASSIGN l-epp = CAN-DO("111500,111501,111502,111503", pTpEvento).

        RUN cdp/cd0360b.p (INPUT  nota-fiscal.cod-estabel,
                           INPUT  IF l-epp THEN "PedProrrogICMS":U ELSE "NF-e":U,
                           OUTPUT cTpTrans).
        
        ASSIGN l-funcao-tss =  lookup(cTpTrans,"TSS,TC":U) > 0. 
    
        FOR FIRST param-nf-estab NO-LOCK WHERE 
                  param-nf-estab.cod-estabel = nota-fiscal.cod-estabel: END.
    
        FOR FIRST estabelec NO-LOCK WHERE 
                  estabelec.cod-estabel = nota-fiscal.cod-estabel: END.
                                            
        FOR FIRST unid-feder NO-LOCK 
            WHERE unid-feder.pais   = estabelec.pais 
            AND   unid-feder.estado = estabelec.estado: 
        END.

        CREATE ttEvento.
        ASSIGN ttEvento.codEstab     = tt-dados-evento.cod-estab   
               ttEvento.codSerie     = tt-dados-evento.cod-serie   
               ttEvento.codNrNota    = tt-dados-evento.cod-nota-fis
               ttEvento.descEvento   = fn-free-accent(tt-dados-evento.desc-evento)
               ttEvento.nSeqEvento   = STRING(tt-dados-evento.num-seq)
               ttEvento.tpEvento     = pTpEvento       
               ttEvento.verEvento    = STRING(tt-dados-evento.cod-versao)
               ttEvento.cnpj         = estabelec.cgc
               ttEvento.cpf          = (IF ttEvento.cpf <> ? THEN ttEvento.cpf ELSE "").

        ASSIGN i-serie = INT(ttEvento.codSerie) NO-ERROR.

        IF ERROR-STATUS:ERROR THEN DO:
            ASSIGN l-nfe-pfe = NO.        
        END.
        ELSE DO:
            IF i-serie >= 920 AND i-serie <= 969 THEN
               ASSIGN l-nfe-pfe = YES.
            ELSE
               ASSIGN l-nfe-pfe = NO.
        END.

        /* e-cpf */
        IF l-nfe-pfe THEN DO:
           ASSIGN ttEvento.cnpj = ""
                  ttEvento.cpf  = SUBSTRING(estabelec.cgc,4,11). 
        END.

        IF ttEvento.tpEvento = "110110" THEN DO: //Carta de Corre‡Æo
           ASSIGN ttEvento.xCondUso     = "A Carta de Correcao e disciplinada pelo paragrafo 1o-A do art. 7o do Convenio S/N, de 15 de dezembro de 1970 e pode ser utilizada para regularizacao de erro ocorrido na emissao de documento fiscal, desde que o erro nao esteja relacionado com: I - as variaveis que determinam o valor do imposto tais como: base de calculo, aliquota, diferenca de preco, quantidade, valor da operacao ou da prestacao; II - a correcao de dados cadastrais que implique mudanca do remetente ou do destinatario; III - a data de emissao ou de saida."
                  ttEvento.xCorrecao    = fn-free-accent(tt-dados-evento.dsl-evento)
                  ttEvento.xCorrecao    = REPLACE(ttEvento.xCorrecao, CHR(10), " ")
                  ttEvento.xCorrecao    = REPLACE(ttEvento.xCorrecao, CHR(13), " ")
                  ttEvento.xCorrecao    = REPLACE(ttEvento.xCorrecao, CHR(9), " ")
                  ttEvento.xCorrecao    = fn-ajusta-espacos-branco(ttEvento.xCorrecao).
        END.
        ELSE DO:
           IF  ttEvento.tpEvento <> "110130" 
           AND ttEvento.tpEvento <> "110131" /* NÆo ‚ comprovante de entrega*/
           AND ttEvento.tpEvento <> "110150" /* NÆo ‚ Ator Interessado */ 
           AND ttEvento.tpEvento <> "110192"
           AND ttEvento.tpEvento <> "110193" /* NÆo ‚ Insucesso na Entrega */
           THEN DO:   
               ASSIGN ttEvento.nProt = &if "{&bf_dis_versao_ems}" >= "2.07" &then nota-fiscal.cod-protoc &else SUBSTR(nota-fiscal.char-1,97,15) &ENDIF 
                      ttEvento.xJust = fn-free-accent(tt-dados-evento.dsl-evento)
                      ttEvento.xJust = REPLACE(ttEvento.xJust, CHR(10), " ")
                      ttEvento.xJust = REPLACE(ttEvento.xJust, CHR(13), " ")
                      ttEvento.xJust = REPLACE(ttEvento.xJust, CHR(9), " ")
                      ttEvento.xJust = fn-ajusta-espacos-branco(ttEvento.xJust).
           END.
        END.

        ASSIGN ttEvento.cOrgao    = STRING(IF  estabelec.pais = "Brasil":U THEN 
                                           (&IF '{&bf_dis_versao_ems}' >= '2.07':U &THEN 
                                               IF  AVAIL unid-feder THEN 
                                                   INT(unid-feder.cod-uf-ibge)
                                               ELSE 0
                                           &ELSE 
                                               IF  AVAIL unid-feder THEN 
                                                   INT(SUBSTRING(unid-feder.char-1,1,2)) 
                                               ELSE 0 &endif)
                                          ELSE 99).
        //91 - Ambiente Nacional
        //92 - SVRS
        CASE ttEvento.tpEvento:
            WHEN "110130":U OR 
            WHEN "110150":U OR //Ator Interessado
            WHEN "110131":U THEN ASSIGN ttEvento.cOrgao = "91". /* Comprovante de Entrega */
            WHEN "110192":U OR
            WHEN "110193":U THEN ASSIGN ttEvento.cOrgao = "92". /* Insucesso na Entrega   */
        END CASE.
            
        IF  l-funcao-tss THEN DO:
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
                                          INT(SUBSTR(estabelec.char-1,168,1)) = 3  /* Processo EmissÆo NF-e - CD0403 */
                                          &ENDIF
                                      THEN "1"  /* Produ‡Æo    */
                                      ELSE "2") /* Homologa‡Æo */. 
        END.
        ELSE DO:
            ASSIGN ttEvento.tpAmb   = (IF &IF "{&BF_DIS_VERSAO_EMS}" >= "2.07" &THEN
                                          estabelec.idi-tip-emis-nf-eletro    = 3
                                      &ELSE
                                          INT(SUBSTR(estabelec.char-1,168,1)) = 3  /* Processo EmissÆo NF-e - CD0403 */
                                      &ENDIF
                                      THEN "1"  /* Produ‡Æo    */
                                      ELSE "2") /* Homologa‡Æo */.
        END.

        ASSIGN ttEvento.chNFe        = TRIM(&IF  '{&bf_dis_versao_ems}' >= '2.07':U &THEN 
                                            nota-fiscal.cod-chave-aces-nf-eletro 
                                       &ELSE 
                                            SUBSTRING(nota-fiscal.char-2,3,60) 
                                       &ENDIF).
    
        ASSIGN c-dia  = SUBSTRING(tt-dados-evento.des-dat-hora-event,1,2)
               c-mes  = SUBSTRING(tt-dados-evento.des-dat-hora-event,4,2)
               c-ano  = SUBSTRING(tt-dados-evento.des-dat-hora-event,7,4).

        RUN cdp/cd0591.p (INPUT tt-dados-evento.cod-estab,
                          INPUT DATE(c-dia + "/" + c-mes + "/" + c-ano),
                          INPUT SUBSTRING(tt-dados-evento.des-dat-hora-event,12,8),
                          INPUT NO, /* formatar hora sem aplicar o fuso */
                          OUTPUT p-dh-formatada).

        ASSIGN ttEvento.dhEvento     = p-dh-formatada
               ttEvento.infEventoID  = pTpEvento + ttEvento.chNFe + STRING(tt-dados-evento.num-seq,"99"). 
                  

        IF  LOOKUP(cTpTrans, "TSS,TC,TC2,TPF":U) > 0 THEN DO:
        
            IF ttEvento.tpEvento = "110130" 
            OR ttEvento.tpEvento = "110131" 
            OR ttEvento.tpEvento = "110150" //Ator Interessado
            OR ttEvento.tpEvento = "110192" 
            OR ttEvento.tpEvento = "110193" THEN DO:
               RUN pi-integra-XML-eventos.
            END.
            ELSE DO:
               RUN pi-integra-XML.
            END.
                
        END.
        ELSE
            RUN PIUpsert (INPUT cTranAction, INPUT cEvent, INPUT TABLE ttEvento, OUTPUT TABLE tt_log_erro).
                        
    END.
    
    RUN pi-executa-upc.

END PROCEDURE.
PROCEDURE piCreateTtEventoAtorRec:    
    DEFINE INPUT  PARAM cTranAction AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM cEvent      AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM pTpEvento   AS CHARACTER INITIAL ? NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR tt-dados-evento.
    DEFINE OUTPUT PARAM TABLE FOR tt_log_erro.

    DEF VAR l-funcao-tss   AS LOG         NO-UNDO.
    DEF VAR c-dia          AS CHAR        NO-UNDO.
    DEF VAR c-mes          AS CHAR        NO-UNDO.
    DEF VAR c-ano          AS CHAR        NO-UNDO.
    DEF VAR p-dh-formatada AS CHAR        NO-UNDO.
    DEF VAR i-serie        AS IN          NO-UNDO.
    DEF VAR l-nfe-pfe      AS LOG         NO-UNDO.
     
    FIND FIRST tt-dados-evento NO-LOCK NO-ERROR.

    RUN cdp/cd0360b.p (INPUT  tt-dados-evento.cod-estab,
                       INPUT  "NF-e":U,
                       OUTPUT cTpTrans).
        
    ASSIGN l-funcao-tss =  lookup(cTpTrans,"TSS,TC":U) > 0. 
    
    FOR FIRST param-nf-estab NO-LOCK WHERE 
              param-nf-estab.cod-estabel = tt-dados-evento.cod-estab: END.

    FOR FIRST estabelec NO-LOCK WHERE 
              estabelec.cod-estabel = tt-dados-evento.cod-estab: END.
                                        
    FOR FIRST unid-feder NO-LOCK 
        WHERE unid-feder.pais   = estabelec.pais 
        AND   unid-feder.estado = estabelec.estado: 
    END.

    FOR FIRST tt-ator-interessado NO-LOCK 
        WHERE tt-ator-interessado.cod-estab    = tt-dados-evento.cod-estab  
          AND tt-ator-interessado.cod-serie    = tt-dados-evento.cod-serie 
          AND tt-ator-interessado.cod-nota-fis = tt-dados-evento.cod-nota-fis:  
    END.

    CREATE ttEvento.
    ASSIGN ttEvento.codEstab     = tt-dados-evento.cod-estab   
           ttEvento.codSerie     = tt-dados-evento.cod-serie   
           ttEvento.codNrNota    = tt-dados-evento.cod-nota-fis
           ttEvento.descEvento   = fn-free-accent(tt-dados-evento.desc-evento)
           ttEvento.nSeqEvento   = STRING(tt-dados-evento.num-seq)
           ttEvento.tpEvento     = pTpEvento       
           ttEvento.verEvento    = STRING(tt-dados-evento.cod-versao)
           ttEvento.cnpj         = estabelec.cgc
           ttEvento.cpf          = (IF ttEvento.cpf <> ? THEN ttEvento.cpf ELSE "").

    ASSIGN i-serie = INT(ttEvento.codSerie) NO-ERROR.

    IF ERROR-STATUS:ERROR THEN DO:
        ASSIGN l-nfe-pfe = NO.        
    END.
    ELSE DO:
        IF i-serie >= 920 AND i-serie <= 969 THEN
           ASSIGN l-nfe-pfe = YES.
        ELSE
           ASSIGN l-nfe-pfe = NO.
    END.

    /* e-cpf */
    IF l-nfe-pfe THEN DO:
        ASSIGN ttEvento.cnpj = ""
               ttEvento.cpf  = SUBSTRING(estabelec.cgc,4,11). 
    END.

    ASSIGN ttEvento.cOrgao    = STRING(IF  estabelec.pais = "Brasil":U THEN 
                                      (IF  AVAIL unid-feder THEN  INT(unid-feder.cod-uf-ibge)
                                       ELSE 0 )
                                       ELSE 99).    
    
    IF  l-funcao-tss THEN DO:
        ASSIGN ttEvento.tpAmb   = IF  AVAIL param-nf-estab THEN 
                                      STRING(param-nf-estab.idi-tip-emis-amb-sefaz)
                                  ELSE 
                                      (IF estabelec.idi-tip-emis-nf-eletro    = 3
                                       THEN "1"  /* Produ‡Æo    */
                                       ELSE "2") /* Homologa‡Æo */. 
    END.
    ELSE DO:
        ASSIGN ttEvento.tpAmb   = (IF estabelec.idi-tip-emis-nf-eletro    = 3
                                   THEN "1"  /* Produ‡Æo    */
                                   ELSE "2") /* Homologa‡Æo */.
    END.

    ASSIGN ttEvento.chNFe        = tt-ator-interessado.cod-chave-aces-nf-eletro.

    ASSIGN c-dia  = SUBSTRING(tt-dados-evento.des-dat-hora-event,1,2)
           c-mes  = SUBSTRING(tt-dados-evento.des-dat-hora-event,4,2)
           c-ano  = SUBSTRING(tt-dados-evento.des-dat-hora-event,7,4).

    RUN cdp/cd0591.p (INPUT tt-dados-evento.cod-estab,
                      INPUT DATE(c-dia + "/" + c-mes + "/" + c-ano),
                      INPUT SUBSTRING(tt-dados-evento.des-dat-hora-event,12,8),
                      INPUT NO, /* formatar hora sem aplicar o fuso */
                      OUTPUT p-dh-formatada).

    ASSIGN ttEvento.dhEvento     = p-dh-formatada
           ttEvento.infEventoID  = pTpEvento + ttEvento.chNFe + STRING(tt-dados-evento.num-seq,"99"). 

    IF  LOOKUP(cTpTrans, "TSS,TC,TC2,TPF":U) > 0 THEN DO:
        IF ttEvento.tpEvento = "110150" THEN 
            RUN pi-integra-XML-eventos.
     
    END.
    ELSE
        RUN PIUpsert (INPUT cTranAction, INPUT cEvent, INPUT TABLE ttEvento, OUTPUT TABLE tt_log_erro).
    
    RUN pi-executa-upc.
    
END PROCEDURE.

PROCEDURE pi-integra-XML:

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
    
        DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hXMLEvento           AS HANDLE      NO-UNDO.
        DEFINE VARIABLE lEnvioEventoTSSOK    AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
        
        ASSIGN lcXMLEvento = "".

        RUN reset       IN hGenXml.
        RUN setEncoding IN hGenXml ("UTF-8").
       
        addStack(iId).

           FOR FIRST ttEvento: END.
                IF  NOT cTpTrans = "TC2":U AND NOT cTpTrans = "TPF":U THEN DO:
                    RUN addNode      IN hGenXml (getStack(), "envEvento",    "", OUTPUT iId).
                    addStack(iId).
                    RUN addNode      IN hGenXml (getStack(), "versao",    "1.00", OUTPUT iId).
                    RUN addNode      IN hGenXml (getStack(), "idLote",       "1", OUTPUT iId).
                END.
                    RUN addNode      IN hGenXml (getStack(), "evento",        "", OUTPUT iId).
                    IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN DO:
                        RUN setAttribute IN hGenXml (INPUT iId,  "versao",    "1.00").
                        RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/nfe").
                    END.    
                    addStack(iId).

                        IF  NOT cTpTrans = "TC2":U AND NOT cTpTrans = "TPF":U THEN
                            RUN addNode      IN hGenXml (getStack(), "versao",    "1.00", OUTPUT iId).
                        RUN addNode      IN hGenXml (getStack(), "infEvento",     "", OUTPUT iId).
                        IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN
                            RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("ID" + ttEvento.infEventoID)).
                        addStack(iId).
                            
                            IF  NOT cTpTrans = "TC2":U AND NOT cTpTrans = "TPF":U THEN
                                RUN addNode      IN hGenXml (getStack(), "Id",        ("ID" + ttEvento.infEventoID), OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "cOrgao",     ttEvento.cOrgao,              OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "tpAmb",      ttEvento.tpAmb,               OUTPUT iId).
    
                            IF  ttEvento.cnpj <> "" THEN
                                RUN addNode  IN hGenXml (getStack(), "CNPJ",       ttEvento.cnpj,       OUTPUT iId).
                            ELSE                                               
                                RUN addNode  IN hGenXml (getStack(), "CPF",        ttEvento.cpf,        OUTPUT iId).
    
                            RUN addNode      IN hGenXml (getStack(), "chNFe",      ttEvento.chNFe,      OUTPUT iId).
                            RUN addNode      IN hGenXml (getStack(), "dhEvento",   ttEvento.dhEvento,   OUTPUT iId).
                            RUN addNode      IN hGenXml (getStack(), "tpEvento",   ttEvento.tpEvento,   OUTPUT iId).
                            RUN addNode      IN hGenXml (getStack(), "nSeqEvento", ttEvento.nSeqEvento, OUTPUT iId).
                            RUN addNode      IN hGenXml (getStack(), "verEvento",  ttEvento.verEvento,  OUTPUT iId).
                            RUN addNode      IN hGenXml (getStack(), "detEvento",  "",                  OUTPUT iId).
                            IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN
                                RUN setAttribute IN hGenXml (INPUT iId,  "versao",     "1.00").
                            addStack(iId).
                                IF  NOT cTpTrans = "TC2":U AND NOT cTpTrans = "TPF":U THEN
                                    RUN addNode IN hGenXml (getStack(), "versao",                  "1.00", OUTPUT iId).
                                RUN addNode IN hGenXml (getStack(), "descEvento", ttEvento.descEvento, OUTPUT iId).
                                IF  tpEvento = "110110" THEN DO:
                                    RUN addNode IN hGenXml (getStack(), "xCorrecao",  ttEvento.xCorrecao,  OUTPUT iId).
                                    RUN addNode IN hGenXml (getStack(), "xCondUso",   ttEvento.xCondUso,   OUTPUT iId).
                                END.
                                ELSE DO:
                                    IF NOT CAN-DO("111502,111503",tpEvento) THEN   /* Evento Cancelamento de Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                        RUN addNode IN hGenXml (getStack(), "nProt",  ttEvento.nProt,  OUTPUT iId).

                                    IF NOT CAN-DO("111500,111501,111502,111503",tpEvento) THEN 
                                        RUN addNode IN hGenXml (getStack(), "xJust",  ttEvento.xJust,  OUTPUT iId).
                                END.

                                /*--- NT 2015.001 ---*/
                                IF  CAN-DO("111500,111501",tpEvento) /* Evento Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                AND CAN-FIND (FIRST ttitemPedido) THEN DO:
                                
                                    FOR EACH ttitemPedido NO-LOCK:

                                        RUN addNode      IN hGenXml (getStack(), "itemPedido",     "", OUTPUT iId).
                                        RUN setAttribute IN hGenXml (INPUT iId,  "numItem",    ttitemPedido.numItem).

                                        addStack(iId).

                                        /*RUN addNode    IN hGenXml (getStack(), "numItem",  ttitemPedido.numItem,  OUTPUT iId).*/
                                        {adapters/xml/ep2/axsep018nodedec.i    "qtdeItem"  ttitemPedido.qtdeItem  "YES" "4"  "NO" }
                                        /*RUN addNodeDec IN hGenXml (getStack(), "qtdeItem", ttitemPedido.qtdeItem, OUTPUT iId).*/

                                        delStack().
                                    END.
                                    
                                END.
                                IF  CAN-DO("111502,111503",tpEvento) /* Evento Cancelamento de Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                AND CAN-FIND (FIRST ttitemPedido) THEN DO:
                                    FOR EACH ttitemPedido NO-LOCK:
                                        RUN addNode    IN hGenXml (getStack(), "idPedidoCancelado",  ttitemPedido.idPedidoCancelado,  OUTPUT iId).
                                        ASSIGN ttEvento.nProt = ttitemPedido.nProt.
                                    END.
                                    RUN addNode IN hGenXml (getStack(), "nProt",  ttEvento.nProt,  OUTPUT iId).
                                END.
                                /*--- NT 2015.001 ---*/

                            delStack().
    
                        delStack().

                    delStack().

                delStack().

        delStack().

        RUN generateXML IN hGenXml (OUTPUT hXMLEvento).

        hXMLEvento:SAVE("LONGCHAR",lcXMLEvento).
        IF  NOT cTpTrans = "TC2":U AND NOT cTpTrans = "TPF":U THEN
            ASSIGN lcXMLEvento = SUBSTR(lcXMLEvento, INDEX(lcXMLEvento, "<EnvEvento")).

        IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN DO:
            EMPTY TEMP-TABLE tt-erro.

            /*hXMLEvento:SAVE('FILE', "C:\temp\XML\teste.xml").*/
            IF  cTpTrans = "TC2":U THEN DO:
                RUN cdp/cdapi590.p (INPUT IF tpEvento = "110110" 
                                          THEN 301                                           /* Codigo Neogrid CC-e Evento */
                                          ELSE IF tpEvento = "111500" OR tpEvento = "111501" /* Evento Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                          THEN 534
                                          ELSE IF tpEvento = "111502" OR tpEvento = "111503" /* Evento Cancelamento de Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                          THEN 535
                                          ELSE 171,                                          /* Codigo Neogrid CC-e Evento */
                                    INPUT hXMLEvento,
                                    INPUT ttEvento.chNFe,
                                    OUTPUT TABLE tt-erro).
            END.

            IF  cTpTrans = "TPF":U THEN DO:
                RUN cdp/cdapi590tpf.p (INPUT IF tpEvento = "110110" 
                                          THEN 301                                           /* Codigo Neogrid CC-e Evento */
                                          ELSE IF tpEvento = "111500" OR tpEvento = "111501" /* Evento Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                          THEN 534
                                          ELSE IF tpEvento = "111502" OR tpEvento = "111503" /* Evento Cancelamento de Pedido de Prorroga‡Æo 1§ e 2§ prazo */
                                          THEN 535
                                          ELSE 171,                                          /* Codigo Neogrid CC-e Evento */
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
        END.

        IF  NOT cTpTrans = "TC2":U AND NOT cTpTrans = "TPF":U THEN DO:
                 
            IF  NOT AVAIL param-nf-estab THEN
                FOR FIRST param-nf-estab NO-LOCK
                    WHERE param-nf-estab.cod-estabel = ttEvento.codEstab: END.
    
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
    
            EMPTY TEMP-TABLE TT_LOG_ERRO.
    
            RUN NFESBRA_NFEREMESSAEVENTO IN h-TSSAPI (INPUT  param-nf-estab.ind-empresa, 
                                                      INPUT  lcXMLEvento,
                                                      OUTPUT cReturnValue). 
            ASSIGN glcReturnValue = cReturnValue.
    
            RUN disconnectTss IN h-TSSAPI ("NFESBRA").
      
            IF  VALID-HANDLE(h-TSSAPI) THEN DO:
                DELETE PROCEDURE h-TSSAPI.
                ASSIGN h-TSSAPI = ?.
            END.

        END.
        
    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-integra-XML-eventos:

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
    
        DEFINE VARIABLE h-TSSAPI                 AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hXMLEvento               AS HANDLE      NO-UNDO.
        DEFINE VARIABLE lEnvioEventoTSSOK        AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE cReturnValue             AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE i-tpEvento               AS INTEGER     NO-UNDO.
        DEFINE VARIABLE mpt-xml                  AS MEMPTR      NO-UNDO.
        
        DEFINE BUFFER bnota-fisc-comp-entr    FOR nota-fisc-comp-entr.
        DEFINE BUFFER bnota-fisc-ator-interes FOR nota-fisc-ator-interes.
        DEFINE BUFFER bnota-fisc-insuc-entr   FOR nota-fisc-insuc-entr.

        ASSIGN lcXMLEvento = "".

        RUN reset       IN hGenXml.
        RUN setEncoding IN hGenXml ("UTF-8").
       
        addStack(iId).

           FOR FIRST ttEvento: END.
                IF  cTpTrans = "TSS":U THEN DO:
                    RUN addNode      IN hGenXml (getStack(), "envEvento",    "", OUTPUT iId).
                    addStack(iId).
                    RUN addNode      IN hGenXml (getStack(), "eventos",        "", OUTPUT iId).
                END.
                ELSE 
                    RUN addNode      IN hGenXml (getStack(), "evento",        "", OUTPUT iId).

                    IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN DO:
                        RUN setAttribute IN hGenXml (INPUT iId,  "versao",    "1.00").
                        RUN setAttribute IN hGenXml (INPUT iId,  "xmlns",   "http://www.portalfiscal.inf.br/nfe").
                    END.    
                    addStack(iId).

                        IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN DO:

                           RUN addNode      IN hGenXml (getStack(), "infEvento",     "", OUTPUT iId).
                           RUN setAttribute IN hGenXml (INPUT iId, "Id",     ("ID" + ttEvento.infEventoID)).
                           
                           addStack(iId).
                                
                                RUN addNode      IN hGenXml (getStack(), "cOrgao",     ttEvento.cOrgao,              OUTPUT iId).
                                RUN addNode      IN hGenXml (getStack(), "tpAmb",      ttEvento.tpAmb,               OUTPUT iId).
                                
                                IF  ttEvento.cnpj <> "" THEN
                                   RUN addNode  IN hGenXml (getStack(), "CNPJ",       ttEvento.cnpj,       OUTPUT iId).
                                ELSE                                               
                                   RUN addNode  IN hGenXml (getStack(), "CPF",        ttEvento.cpf,        OUTPUT iId).

                           
                                 RUN addNode      IN hGenXml (getStack(), "chNFe",      ttEvento.chNFe,      OUTPUT iId).
                                 RUN addNode      IN hGenXml (getStack(), "dhEvento",   ttEvento.dhEvento,   OUTPUT iId).
                                 RUN addNode      IN hGenXml (getStack(), "tpEvento",   ttEvento.tpEvento,   OUTPUT iId).
                                 RUN addNode      IN hGenXml (getStack(), "nSeqEvento", ttEvento.nSeqEvento, OUTPUT iId).
                                 RUN addNode      IN hGenXml (getStack(), "verEvento",  ttEvento.verEvento,  OUTPUT iId).

                        END.

                           RUN addNode      IN hGenXml (getStack(), "detEvento",  "",                  OUTPUT iId).
                           addStack(iId).
                           
                           
                           IF  cTpTrans = "TSS":U THEN DO:
                               RUN addNode      IN hGenXml (getStack(), "tpEvento",   ttEvento.tpEvento,   OUTPUT iId).
                               RUN addNode      IN hGenXml (getStack(), "chNFe",      ttEvento.chNFe,      OUTPUT iId).

                           END.                                                          

                           IF cTpTrans = "TC2":U AND CAN-FIND (FIRST tt-comp-entrega) THEN DO: 
                              FOR FIRST tt-comp-entrega
                                  WHERE tt-comp-entrega.cod-estab                = ttEvento.codEstab 
                                  AND   tt-comp-entrega.cod-serie                = ttEvento.codSerie 
                                  AND   tt-comp-entrega.cod-nota-fis             = ttEvento.codNrNota 
                                  AND   tt-comp-entrega.cod-chave-aces-nf-eletro = ttEvento.chNFe NO-LOCK:
                                  RUN setAttribute IN hGenXml (INPUT iId,  "versao",  tt-comp-entrega.versao).
                              END.
                           END.                                                                                                          
                           
                           IF cTpTrans = "TC2":U AND CAN-FIND (FIRST tt-insucesso-entrega) THEN DO: 
                              FOR FIRST tt-insucesso-entrega
                                  WHERE tt-insucesso-entrega.cod-estab                = ttEvento.codEstab 
                                  AND   tt-insucesso-entrega.cod-serie                = ttEvento.codSerie  
                                  AND   tt-insucesso-entrega.cod-nota-fis             = ttEvento.codNrNota   
                                  AND   tt-insucesso-entrega.cod-chave-aces-nf-eletro = ttEvento.chNFe NO-LOCK:
                                  RUN setAttribute IN hGenXml (INPUT iId,  "versao",  tt-insucesso-entrega.versao).
                              END.
                           END.
                                   
                           IF CAN-DO("110150",tpEvento) THEN DO: //Ator Interessado
                           
                              IF cTpTrans = "TPF":U THEN 
                                  RUN setAttribute IN hGenXml (INPUT iId,  "versao",    ttEvento.verEvento).
                               
                              IF cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN 
                                  RUN addNode IN hGenXml (getStack(), "descEvento", ttEvento.descEvento, OUTPUT iId).                           
                           
                              FOR FIRST tt-ator-interessado
                                  WHERE tt-ator-interessado.cod-estab                = ttEvento.codEstab  
                                  AND   tt-ator-interessado.cod-serie                = ttEvento.codSerie 
                                  AND   tt-ator-interessado.cod-nota-fis             = ttEvento.codNrNota 
                                  AND   tt-ator-interessado.cod-chave-aces-nf-eletro = ttEvento.chNFe     
                                  AND   tt-ator-interessado.num-seq                  = INT(ttEvento.nSeqEvento) NO-LOCK:
                                                                                                                                       
                                  RUN addNode IN hGenXml (getStack(), "cOrgaoAutor", tt-ator-interessado.orgao-autor,    OUTPUT iId). 
                                  RUN addNode IN hGenXml (getStack(), "tpAutor",     tt-ator-interessado.tp-autor-event, OUTPUT iId).
                                                                    
                                  IF cTpTrans = "TPF":U THEN 
                                      RUN addNode IN hGenXml (getStack(), "verAplic", "5.0", OUTPUT iId).  //Mesma versão enviada na NFe na tag verProc
                                  
                                  RUN addNode IN hGenXml (getStack(), "autXML",      "",                                 OUTPUT iId).      
                                    
                                  addStack(iId).
                                  IF LENGTH(tt-ator-interessado.cgc) > 11 THEN
                                     RUN addNode IN hGenXml (getStack(), "CNPJ", tt-ator-interessado.cgc, OUTPUT iId).
                                  ELSE 
                                     RUN addNode IN hGenXml (getStack(), "CPF",  tt-ator-interessado.cgc, OUTPUT iId).
                                  delStack(). 
                                      
                                  IF tt-ator-interessado.tp-autor-event <> 3 THEN //somente enviar quando for emitente e destinat rio
                                     RUN addNode IN hGenXml (getStack(), "tpAutorizacao", tt-ator-interessado.tp-autorizacao, OUTPUT iId).                                   
                                     
                                  IF tt-ator-interessado.tp-autorizacao = 1 AND cTpTrans = "TPF":U THEN  
                                      RUN addNode IN hGenXml (getStack(), "xCondUso", tt-ator-interessado.cond-uso, OUTPUT iId).
                                     
                              END.                                                                                                  
                           END.
                                   
                           IF  CAN-DO("110130,110131",tpEvento) THEN DO: /*--- NT 2015.001 ---*/
                                
                               IF cTpTrans = "TC2":U THEN 
                                  RUN addNode IN hGenXml (getStack(), "descEvento", ttEvento.descEvento, OUTPUT iId).
                                    
                               IF  CAN-FIND (FIRST tt-comp-entrega) THEN DO:   /*comprovante de entrega*/
                                   FOR FIRST tt-comp-entrega
                                       WHERE tt-comp-entrega.cod-estab                = ttEvento.codEstab             
                                       AND   tt-comp-entrega.cod-nota-fis             = ttEvento.codNrNota            
                                       AND   tt-comp-entrega.cod-serie                = ttEvento.codSerie             
                                       AND   tt-comp-entrega.cod-chave-aces-nf-eletro = ttEvento.chNFe NO-LOCK:

                                       RUN addNode IN hGenXml (getStack(), "cOrgaoAutor", tt-comp-entrega.orgao-autor, OUTPUT iId).
                                       RUN addNode IN hGenXml (getStack(), "tpAutor",     1,                           OUTPUT iId).

                                       IF ttEvento.tpEvento = "110130" THEN DO:  // Envio do Comprovante
                                          RUN addNode IN hGenXml (getStack(), "dhEntrega",         fnDatetz(tt-comp-entrega.dh-entrega),                    OUTPUT iId).
                                          RUN addNode IN hGenXml (getStack(), "nDoc",              tt-comp-entrega.ndoc,                                    OUTPUT iId).
                                          RUN addNode IN hGenXml (getStack(), "xNome",             fn-free-accent(tt-comp-entrega.nome-pessoa),             OUTPUT iId).
                                          RUN addNode IN hGenXml (getStack(), "latGPS",            TRIM(STRING(tt-comp-entrega.latGPS * 1000000,"->9,999999")),   OUTPUT iId).
                                          RUN addNode IN hGenXml (getStack(), "longGPS",           TRIM(STRING(tt-comp-entrega.longGPS * 1000000,"->>9,999999")), OUTPUT iId).
                                          RUN addNode IN hGenXml (getStack(), "hashComprovante",   tt-comp-entrega.hashComprovante,                         OUTPUT iId).
                                          RUN addNode IN hGenXml (getStack(), "dhHashComprovante", fnDateTZ(tt-comp-entrega.dhHashComprovante),             OUTPUT iId).
                                       END.
                                       ELSE DO:
                                          IF cTpTrans = "TC2":U  AND ttEvento.tpEvento = "110131" THEN DO:  // Cancelamento do comprovante
                                             RUN addNode IN hGenXml (getStack(), "nProtEvento", tt-comp-entrega.nprot-evento, OUTPUT iId).
                                          END.
                                       END.
                                       
                                   END.
                               END.
                               
                           END.  

                           IF  CAN-DO("110192,110193",tpEvento) THEN DO: /*--- NT 2023.005 ---*/
                                
                               IF cTpTrans = "TC2":U THEN 
                                  RUN addNode IN hGenXml (getStack(), "descEvento", ttEvento.descEvento, OUTPUT iId).
                                    
                               IF  CAN-FIND (FIRST tt-insucesso-entrega)  THEN DO:   /* Innsucesso na Entrega*/
                                   FOR FIRST tt-insucesso-entrega 
                                       WHERE tt-insucesso-entrega.cod-estab                = ttEvento.codEstab             
                                       AND   tt-insucesso-entrega.cod-nota-fis             = ttEvento.codNrNota            
                                       AND   tt-insucesso-entrega.cod-serie                = ttEvento.codSerie             
                                       AND   tt-insucesso-entrega.cod-chave-aces-nf-eletro = ttEvento.chNFe NO-LOCK:

                                        IF cTpTrans = "TC2" THEN DO:
                                           RUN addNode IN hGenXml (getStack(), "cOrgaoAutor", tt-insucesso-entrega.orgao-autor, OUTPUT iId).
                                           RUN addNode IN hGenXml (getStack(), "verAplic",    "5.0", OUTPUT iId).  //Mesma versao enviada na NFe na tag verProc
                                        END.
                                       IF ttEvento.tpEvento = "110192" THEN DO:  // Envio do Insucesso na Entrega
                                          IF cTpTrans = "TSS" THEN DO:
                                             RUN addNode IN hGenXml (getStack(), "dhEntrega",         fnDatetz(tt-insucesso-entrega.dh-tentativa-entrega),          OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "nTentativa",        tt-insucesso-entrega.nr-tentativa,                            OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "tpMotivo",          tt-insucesso-entrega.tp-motivo,                               OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "xJustMotivo",       fn-free-accent(tt-insucesso-entrega.just-motivo),             OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "latGPS",            trim(STRING(tt-insucesso-entrega.latGPS * 1000000,"->9,999999")),   OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "longGPS",           trim(STRING(tt-insucesso-entrega.longGPS * 1000000,"->>9,999999")), OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "hashComprovante",   tt-insucesso-entrega.hashTentativaEntrega,                    OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "dhHashComprovante", fnDateTZ(tt-insucesso-entrega.dhHashTentativaEntrega),        OUTPUT iId).  
                                          END.
                                          ELSE DO:
                                             RUN addNode IN hGenXml (getStack(), "dhTentativaEntrega",     fnDatetz(tt-insucesso-entrega.dh-tentativa-entrega),          OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "nTentativa",             tt-insucesso-entrega.nr-tentativa,                            OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "tpMotivo",               tt-insucesso-entrega.tp-motivo,                               OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "xJustMotivo",            fn-free-accent(tt-insucesso-entrega.just-motivo),             OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "latGPS",                 trim(STRING(tt-insucesso-entrega.latGPS * 1000000,"->9,999999")),   OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "longGPS",                trim(STRING(tt-insucesso-entrega.longGPS * 1000000,"->>9,999999")), OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "hashTentativaEntrega",   tt-insucesso-entrega.hashTentativaEntrega,                    OUTPUT iId).
                                             RUN addNode IN hGenXml (getStack(), "dhHashTentativaEntrega", fnDateTZ(tt-insucesso-entrega.dhHashTentativaEntrega),        OUTPUT iId).
                                          END.
                                       END.
                                       ELSE DO: 
                                          IF cTpTrans = "TC2":U AND ttEvento.tpEvento = "110193" THEN DO: // Cancelamento do Insucesso na Entrega
                                             RUN addNode IN hGenXml (getStack(), "nProtEvento", tt-insucesso-entrega.nprot-evento, OUTPUT iId).
                                          END.
                                       END.
                                         
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
        
        IF  cTpTrans = "TSS":U THEN 
            ASSIGN lcXMLEvento = SUBSTR(lcXMLEvento, INDEX(lcXMLEvento, "<EnvEvento")).
            
        IF  cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN DO:
        
        EMPTY TEMP-TABLE tt-erro.
         
            CASE tpEvento:
                WHEN "110130":U THEN DO:
                    
                    FOR FIRST bnota-fisc-comp-entr EXCLUSIVE-LOCK
                        WHERE (bnota-fisc-comp-entr.idi-situacao = 1  /* NÆo Enviado */ 
                           OR  bnota-fisc-comp-entr.idi-situacao = 4) /* REJEITADO */
                          AND bnota-fisc-comp-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                 
                        /*  GRAVAR O XML ANTES DO ENVIO */
                        COPY-LOB lcXMLEvento TO bnota-fisc-comp-entr.blb-xml-envio CONVERT TARGET CODEPAGE "UTF-8". 
                         
                        ASSIGN bnota-fisc-comp-entr.idi-situacao      = 2 // Evento Enviado
                               bnota-fisc-comp-entr.cod-usuario-envio = c-seg-usuario 
                               bnota-fisc-comp-entr.dtm-envio         = NOW 
                               i-tpEvento                             = 598. /* C¢digo Evento Neogrid ENVIO Comprovante de Entrega */.  
        
                    END.
               
                END.
                WHEN "110131":U THEN DO:
                
                    FOR FIRST bnota-fisc-comp-entr EXCLUSIVE-LOCK 
                        WHERE bnota-fisc-comp-entr.idi-situacao             = 3  //Autorizado
                          AND bnota-fisc-comp-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                 
                        /*  GRAVAR O XML ANTES DO ENVIO */
                        COPY-LOB lcXMLEvento TO bnota-fisc-comp-entr.blb-xml-canc CONVERT TARGET CODEPAGE "UTF-8".                                                         
    
                        ASSIGN bnota-fisc-comp-entr.idi-situacao           = 5 // Cancelamaneto Enviado
                               bnota-fisc-comp-entr.cod-usuario-envio-canc = c-seg-usuario 
                               bnota-fisc-comp-entr.dtm-envio-canc         = NOW .

                    END.                    
                END.
                WHEN "110150":U THEN DO: //Ator Interessado
                                
                    FOR FIRST bnota-fisc-ator-interes EXCLUSIVE-LOCK 
                        WHERE (bnota-fisc-ator-interes.idi-situacao            = 1  // NÆo Enviado 
                           OR  bnota-fisc-ator-interes.idi-situacao            = 4) // Rejeitado
                          AND bnota-fisc-ator-interes.cod-chave-aces-nf-eletro = ttEvento.chNFe                  
                          AND bnota-fisc-ator-interes.num-seq                  = INT(ttEvento.nSeqEvento): 
                                  
                        COPY-LOB lcXMLEvento TO bnota-fisc-ator-interes.blb-xml-envio CONVERT TARGET CODEPAGE "UTF-8".                
                                                                                                         
                        ASSIGN bnota-fisc-ator-interes.idi-situacao      = 2 // Evento Enviado                    
                               bnota-fisc-ator-interes.cod-usuario-envio = c-seg-usuario                         
                               bnota-fisc-ator-interes.dtm-envio         = NOW 
                               i-tpEvento                                = 594. /* C¢digo Evento Neogrid ENVIO Ator Intressado */                                 
                    END.                     
                END.
                WHEN "110192":U THEN DO:
                
                   FOR FIRST bnota-fisc-insuc-entr EXCLUSIVE-LOCK
                       WHERE (bnota-fisc-insuc-entr.idi-situacao = 1  /* NÆo Enviado */ 
                          OR  bnota-fisc-insuc-entr.idi-situacao = 4) /* REJEITADO */
                         AND bnota-fisc-insuc-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                 
                       /*  GRAVAR O XML ANTES DO ENVIO */
                       COPY-LOB lcXMLEvento TO bnota-fisc-insuc-entr.blb-xml-envio CONVERT TARGET CODEPAGE "UTF-8". 
                         
                       ASSIGN bnota-fisc-insuc-entr.idi-situacao      = 2 // Evento Enviado
                              bnota-fisc-insuc-entr.cod-usuario-envio = c-seg-usuario 
                              bnota-fisc-insuc-entr.dtm-envio         = NOW 
                              i-tpEvento                              = 626. /* C¢digo Evento Neogrid ENVIO Insucesso na Entrega */        
                   END.
                END.
                WHEN "110193":U THEN DO:

                    FOR FIRST bnota-fisc-insuc-entr EXCLUSIVE-LOCK 
                        WHERE bnota-fisc-insuc-entr.idi-situacao             = 3  //Autorizado
                          AND bnota-fisc-insuc-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                 
                        /*  GRAVAR O XML ANTES DO ENVIO */
                        COPY-LOB lcXMLEvento TO bnota-fisc-insuc-entr.blb-xml-canc CONVERT TARGET CODEPAGE "UTF-8".                                                         
    
                        ASSIGN bnota-fisc-insuc-entr.idi-situacao           = 5 // Cancelamaneto Enviado
                               bnota-fisc-insuc-entr.cod-usuario-envio-canc = c-seg-usuario 
                               bnota-fisc-insuc-entr.dtm-envio-canc         = NOW 
                               i-tpEvento                                   = 627. /* C¢digo Evento Neogrid ENVIO Insucesso na Entrega */ 
                    END.                
                END.
            END CASE.
            
            IF  cTpTrans= "TC2":U THEN DO:
                RUN cdp/cdapi590.p (INPUT i-tpEvento, /* C¢digo Evento Neogrid CANCELAMENTO Comprovante Entrega */          
                                    INPUT hXMLEvento,
                                    INPUT ttEvento.chNFe,
                                    OUTPUT TABLE tt-erro).   
            END.
            ELSE DO:                
                RUN cdp/cdapi590tpf.p (INPUT i-tpEvento,
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
            
        END.
        ELSE DO:
        
            IF  cTpTrans = "TSS":U THEN DO:
                     
                IF  NOT AVAIL param-nf-estab THEN
                    FOR FIRST param-nf-estab NO-LOCK
                        WHERE param-nf-estab.cod-estabel = ttEvento.codEstab: END.
        
                IF  NOT AVAIL param-nf-estab THEN
                    RETURN "NOK".
        
                IF  NOT VALID-HANDLE(h-TSSAPI) THEN
                    RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. 
                
                /*  GRAVAR O XML ANTES DO ENVIO */
                CASE tpEvento:
                    WHEN "110130":U THEN DO:
                        
                        FOR FIRST bnota-fisc-comp-entr EXCLUSIVE-LOCK
                            WHERE (bnota-fisc-comp-entr.idi-situacao  = 1  /* NÆo Enviado */ 
                               OR  bnota-fisc-comp-entr.idi-situacao  = 4) /* Rejeitado */
                              AND bnota-fisc-comp-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                             
                            COPY-LOB lcXMLEvento TO bnota-fisc-comp-entr.blb-xml-envio CONVERT TARGET CODEPAGE "UTF-8".                                                         
            
                            ASSIGN bnota-fisc-comp-entr.idi-situacao      = 2 //Evento Enviado
                                   bnota-fisc-comp-entr.cod-usuario-envio = c-seg-usuario 
                                   bnota-fisc-comp-entr.dtm-envio         = NOW .  
            
                        END.
                   
                    END.
                    WHEN "110131":U THEN DO:
                    
                        FOR FIRST bnota-fisc-comp-entr EXCLUSIVE-LOCK 
                            WHERE bnota-fisc-comp-entr.idi-situacao             = 3  /* Autorizado */ 
                              AND bnota-fisc-comp-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                         
                            COPY-LOB lcXMLEvento TO bnota-fisc-comp-entr.blb-xml-canc CONVERT TARGET CODEPAGE "UTF-8".                                                         

                            ASSIGN bnota-fisc-comp-entr.idi-situacao           = 5 // Cancelamento Enviado
                                   bnota-fisc-comp-entr.cod-usuario-envio-canc = c-seg-usuario 
                                   bnota-fisc-comp-entr.dtm-envio-canc         = NOW .  

                        END.
                        
                    END.
                    WHEN "110150":U THEN DO:
                    
                        FOR FIRST bnota-fisc-ator-interes EXCLUSIVE-LOCK                                                             
                            WHERE (bnota-fisc-ator-interes.idi-situacao            = 1  // NÆo Enviado 
                               OR  bnota-fisc-ator-interes.idi-situacao            = 4) // Rejeitado
                              AND bnota-fisc-ator-interes.cod-chave-aces-nf-eletro = ttEvento.chNFe                  
                              AND bnota-fisc-ator-interes.num-seq                  = INT(ttEvento.nSeqEvento):       
                                                                                                                 
                            COPY-LOB lcXMLEvento TO bnota-fisc-ator-interes.blb-xml-envio CONVERT TARGET CODEPAGE "UTF-8".                
                                                                                                                 
                            ASSIGN bnota-fisc-ator-interes.idi-situacao      = 2 // Evento Enviado                    
                                   bnota-fisc-ator-interes.cod-usuario-envio = c-seg-usuario                         
                                   bnota-fisc-ator-interes.dtm-envio         = NOW .                                
                        END.
                        
                    END.
                    WHEN "110192":U THEN DO:
                    
                       FOR FIRST bnota-fisc-insuc-entr EXCLUSIVE-LOCK
                           WHERE (bnota-fisc-insuc-entr.idi-situacao = 1  /* NÆo Enviado */ 
                              OR  bnota-fisc-insuc-entr.idi-situacao = 4) /* REJEITADO */
                             AND bnota-fisc-insuc-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                     
                           /*  GRAVAR O XML ANTES DO ENVIO */
                           COPY-LOB lcXMLEvento TO bnota-fisc-insuc-entr.blb-xml-envio CONVERT TARGET CODEPAGE "UTF-8". 
                             
                           ASSIGN bnota-fisc-insuc-entr.idi-situacao      = 2 // Evento Enviado
                                  bnota-fisc-insuc-entr.cod-usuario-envio = c-seg-usuario 
                                  bnota-fisc-insuc-entr.dtm-envio         = NOW.
            
                       END.

                    END.
                    WHEN "110193":U THEN DO:
                        
                        FOR FIRST bnota-fisc-insuc-entr EXCLUSIVE-LOCK 
                            WHERE bnota-fisc-insuc-entr.idi-situacao             = 3  //Autorizado
                              AND bnota-fisc-insuc-entr.cod-chave-aces-nf-eletro = ttEvento.chNFe:
                     
                            /*  GRAVAR O XML ANTES DO ENVIO */
                            COPY-LOB lcXMLEvento TO bnota-fisc-insuc-entr.blb-xml-canc CONVERT TARGET CODEPAGE "UTF-8".                                                         
        
                            ASSIGN bnota-fisc-insuc-entr.idi-situacao           = 5 // Cancelamaneto Enviado
                                   bnota-fisc-insuc-entr.cod-usuario-envio-canc = c-seg-usuario 
                                   bnota-fisc-insuc-entr.dtm-envio-canc         = NOW .  

                        END.
                    
                    END.
                END CASE.

                RUN setTSSURL IN h-TSSAPI (&if "{&bf_dis_versao_ems}" >= "2.08" &then
                                             TRIM(param-nf-estab.cod-url-ws-tss)
                                           &else
                                             TRIM(SUBSTR(param-nf-estab.cod-livre-1,1,100))
                                           &endif).
                                           
                RUN setTSSAuthParam IN h-TSSAPI (INPUT 1,
                                                 INPUT "*",
                                                 INPUT param-nf-estab.cod-estabel,
                                                 INPUT param-nf-estab.cod-url-ws-tss).
            
                EMPTY TEMP-TABLE TT_LOG_ERRO.
            
                RUN NFESBRA_REMESSAEVENTO IN h-TSSAPI (INPUT  param-nf-estab.ind-empresa, 
                                                       INPUT  lcXMLEvento,
                                                       OUTPUT cReturnValue). 
               
                ASSIGN glcReturnValue = cReturnValue.
            
                RUN disconnectTss IN h-TSSAPI ("NFESBRA"). 
              
                IF VALID-HANDLE(h-TSSAPI) THEN DO:
                   DELETE PROCEDURE h-TSSAPI.
                   ASSIGN h-TSSAPI = ?.
                END.
            END. //FIM TSS
        END.   
    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.
PROCEDURE pi-recebe-ttitemPedido:

    DEFINE INPUT  PARAM TABLE FOR ttitemPedido.

END PROCEDURE.
PROCEDURE pi-recebe-ttcompEntrega:

    DEFINE INPUT  PARAM TABLE FOR tt-comp-entrega.

END PROCEDURE.

PROCEDURE pi-recebe-ttAtorInteressado:
    
    DEFINE INPUT PARAM TABLE FOR tt-ator-interessado.
    
END PROCEDURE.

PROCEDURE pi-recebe-ttInsucessoEntrega:
    
    DEFINE INPUT PARAM TABLE FOR tt-insucesso-entrega.
    
END PROCEDURE.



