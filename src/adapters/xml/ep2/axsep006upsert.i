
/*-------------------------------------------------
               AXSEP006Upsert.i
-------------------------------------------------*/

PROCEDURE PITransUpsert:

    /*PARAMETERS - BEGIN*/
    
    DEFINE INPUT  PARAMETER pTranAction    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pTranEvent     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pRowidNF       AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
    
    /*PARAMETERS - END*/
    
    
    /*LOCAL VARIABLES - BEGIN*/
    DEFINE VARIABLE i-codigo-orig AS INTEGER     NO-UNDO.
    DEFINE VARIABLE h-axsep027    AS HANDLE      NO-UNDO.
    DEFINE VARIABLE h-axsep037    AS HANDLE      NO-UNDO.

    /*DEFINIÄÂES NA axsep006ExtraDeclarations.i*/

    /*LOCAL VARIABLES - END*/
    
    
    
    /* ******************************************* */
    /* *************** BODY - BEGIN ************** */
    /* ******************************************* */
    
    RUN pi-limpa-temp-tables.

    ASSIGN iContNota = 0.

    FOR FIRST nota-fiscal NO-LOCK
        WHERE ROWID(nota-fiscal) = pRowidNF:
    
        /* N∆o enviar nota cancelada */
        IF  nota-fiscal.dt-cancela  <> ? THEN
            NEXT.

        IF  NOT AVAIL estabelec 
            OR (AVAIL estabelec AND estabelec.cod-estabel <> nota-fiscal.cod-estabel) 
        THEN
            FOR FIRST estabelec NO-LOCK WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel: END.
        
        /* VERS«O LAYOUT NF-E FOR 4.00 OU SUPERIOR, EXECUTAR O AXSEP037 */
        IF  TRIM(estabelec.des-vers-layout) >= "4.00" THEN DO:

            IF  NOT VALID-HANDLE(h-axsep037) THEN
                RUN adapters/xml/ep2/axsep037.p PERSISTENT SET h-axsep037.
            
            RUN pi-setaObtemXMLNFe IN h-axsep037 (INPUT lObtemXMLNFe).    
            
            RUN PITransUpsert      IN h-axsep037 (INPUT  "upd":U,
                                                  INPUT  "InvoiceNFe":U,
                                                  INPUT  ROWID(nota-fiscal),
                                                  OUTPUT TABLE tt_log_erro).


            &IF INTEGER(ENTRY(1,PROVERSION,".":U)) >= 10 &THEN 
                RUN pi-retornaXMLNFe   IN h-axsep037 (OUTPUT lcXMLNFe).
            &ENDIF

            IF  VALID-HANDLE(h-axsep037) then do:
                DELETE PROCEDURE h-axsep037.
                ASSIGN h-axsep037 = ?.
            END.

            RETURN. /* executar apenas a geraá∆o do XML do novo layout 3.10 (axsep027) */
        END.
        /* VERS«O LAYOUT NF-E FOR 3.10 OU SUPERIOR, EXECUTAR O AXSEP027 */
        ELSE IF  TRIM(estabelec.des-vers-layout) >= "3.10" THEN DO:

            IF  NOT VALID-HANDLE(h-axsep027) THEN
                RUN adapters/xml/ep2/axsep027.p PERSISTENT SET h-axsep027.
            
            RUN pi-setaObtemXMLNFe IN h-axsep027 (INPUT lObtemXMLNFe).    
            
            RUN PITransUpsert      IN h-axsep027 (INPUT  "upd":U,
                                                  INPUT  "InvoiceNFe":U,
                                                  INPUT  ROWID(nota-fiscal),
                                                  OUTPUT TABLE tt_log_erro).


            &IF INTEGER(ENTRY(1,PROVERSION,".":U)) >= 10 &THEN 
                RUN pi-retornaXMLNFe   IN h-axsep027 (OUTPUT lcXMLNFe).
            &ENDIF

            IF  VALID-HANDLE(h-axsep027) then do:
                DELETE PROCEDURE h-axsep027.
                ASSIGN h-axsep027 = ?.
            END.

            RETURN. /* executar apenas a geraá∆o do XML do novo layout 3.10 (axsep027) */
        END.
        /* FIM - VERS«O LAYOUT NF-E FOR 3.10 OU SUPERIOR, EXECUTAR O AXSEP027 */
        ELSE IF TRIM(estabelec.des-vers-layout) >= "2.00" THEN DO:

            IF  NOT VALID-HANDLE(h-axsep017) THEN
                RUN adapters/xml/ep2/axsep017.p PERSISTENT SET h-axsep017.
            
            RUN pi-setaObtemXMLNFe IN h-axsep017 (INPUT lObtemXMLNFe).    
            
            RUN PITransUpsert      IN h-axsep017 (INPUT  "upd":U,
                                                  INPUT  "InvoiceNFe":U,
                                                  INPUT  ROWID(nota-fiscal),
                                                  OUTPUT TABLE tt_log_erro).


            &IF INTEGER(ENTRY(1,PROVERSION,".":U)) >= 10 &THEN 
                RUN pi-retornaXMLNFe   IN h-axsep017 (OUTPUT lcXMLNFe).
            &ENDIF

            IF  VALID-HANDLE(h-axsep017) then do:
                DELETE PROCEDURE h-axsep017.
                ASSIGN h-axsep017 = ?.
            END.

            RETURN. /* executar apenas a geraá∆o do XML do novo layout 2.00 (axsep017) */
        END.
        /* FIM - VERS«O LAYOUT NF-E FOR 2.00 OU SUPERIOR, EXECUTAR O AXSEP017 */

        RUN cdp/cd0360b.p (INPUT nota-fiscal.cod-estabel,
                           INPUT "NF-e":U,
                           OUTPUT cTpTrans).
        /* Preparaá∆o dos dados a serem gerados [XML ou TXT] */
        RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.
        
        RUN pi-prepara-dados.
        
        IF  VALID-HANDLE(h-cdapi704) THEN DO:
            DELETE PROCEDURE h-cdapi704.
            ASSIGN h-cdapi704 = ?.
        END.
    END.    
    
    IF  lLayoutXML THEN DO:
    
        IF  NOT AVAIL ttNFe THEN
            FIND FIRST ttNFe NO-LOCK NO-ERROR.

        IF  LOOKUP (cTpTrans, "TSS,TC":U) > 0 THEN
            RUN pi-TSS-Sincrono.
        ELSE
        /* Via adapter -> Gerar XML para Aplicaá∆o Transmiss∆o */
        RUN PIUpsert ( INPUT  pTranAction       , /* add / upd */
                       INPUT  pTranEvent        , /* Evento    */
                       INPUT  TABLE ttAdi       ,
                       INPUT  TABLE ttArma      ,
                       INPUT  TABLE ttAvulsa    ,
                       INPUT  TABLE ttCobr      ,
                       INPUT  TABLE ttCOFINSAliq,
                       INPUT  TABLE ttCOFINSNT  ,
                       INPUT  TABLE ttCOFINSOutr,
                       INPUT  TABLE ttCOFINSQtde,
                       INPUT  TABLE ttCOFINSST  ,
                       INPUT  TABLE ttComb      ,
                       INPUT  TABLE ttCompra    ,
                       INPUT  TABLE ttDest      ,
                       INPUT  TABLE ttDet       ,
                       INPUT  TABLE ttDI        ,
                       INPUT  TABLE ttDup       ,
                       INPUT  TABLE ttEmit      ,
                       INPUT  TABLE ttEntrega   ,
                       INPUT  TABLE ttExporta   ,
                       INPUT  TABLE ttICMS00    ,
                       INPUT  TABLE ttICMS10    ,
                       INPUT  TABLE ttICMS20    ,
                       INPUT  TABLE ttICMS30    ,
                       INPUT  TABLE ttICMS40    ,
                       INPUT  TABLE ttICMS51    ,
                       INPUT  TABLE ttICMS60    ,
                       INPUT  TABLE ttICMS70    ,
                       INPUT  TABLE ttICMS90    ,
                       INPUT  TABLE ttICMSTot   ,
                       INPUT  TABLE ttIde       ,
                       INPUT  TABLE ttII        ,
                       INPUT  TABLE ttInfAdic   ,
                       INPUT  TABLE ttIPI       ,
                       INPUT  TABLE ttISSQN     ,
                       INPUT  TABLE ttISSQNtot  ,
                       INPUT  TABLE ttLacres    ,
                       INPUT  TABLE ttMed       ,
                       INPUT  TABLE ttNFe       ,
                       INPUT  TABLE ttNFRef     ,
                       INPUT  TABLE ttObsCont   ,
                       INPUT  TABLE ttObsFisco  ,
                       INPUT  TABLE ttPISAliq   ,
                       INPUT  TABLE ttPISNT     ,
                       INPUT  TABLE ttPISOutr   ,
                       INPUT  TABLE ttPISQtde   ,
                       INPUT  TABLE ttPISST     ,
                       INPUT  TABLE ttProcRef   ,
                       INPUT  TABLE ttReboque   ,
                       INPUT  TABLE ttRetirada  ,
                       INPUT  TABLE ttRetTrib   ,
                       INPUT  TABLE ttTransp    ,
                       INPUT  TABLE ttVeic      ,
                       INPUT  TABLE ttVol       ,
                       OUTPUT TABLE tt_log_erro ).
    END.
    /* Via adapter -> Gerar TXT para Transmiss∆o Manual */
    IF  lLayoutTXT THEN DO:

        IF  NOT AVAIL ttNFe THEN
            FIND FIRST ttNFe NO-LOCK NO-ERROR.

        ASSIGN cArquivoNFeTXT  = ("NFe_" + ttNFe.NrNotaFisNF + "_" + ttNfe.CodEstabelNF + "_" + ttNfe.SerieNF + "_" + REPLACE(STRING(TODAY,"99/99/9999"),"/","_") + ".txt")
               cArquivoNFeTXT  = cLocalArqTXT + cArquivoNFeTXT.

        RUN adapters/xml/ep2/axsep006imprimetxt.p ( INPUT  cArquivoNFeTXT    ,
                                                    INPUT  ?                 , /* Para o caso de imprimir Emissor (Estabelec) [Sera impresso somente via FT0910a.p] */
                                                    INPUT  TABLE ttAdi       ,
                                                    INPUT  TABLE ttArma      ,
                                                    INPUT  TABLE ttAvulsa    ,
                                                    INPUT  TABLE ttCobr      ,
                                                    INPUT  TABLE ttCOFINSAliq,
                                                    INPUT  TABLE ttCOFINSNT  ,
                                                    INPUT  TABLE ttCOFINSOutr,
                                                    INPUT  TABLE ttCOFINSQtde,
                                                    INPUT  TABLE ttCOFINSST  ,
                                                    INPUT  TABLE ttComb      ,
                                                    INPUT  TABLE ttCompra    ,
                                                    INPUT  TABLE ttDest      ,
                                                    INPUT  TABLE ttDet       ,
                                                    INPUT  TABLE ttDI        ,
                                                    INPUT  TABLE ttDup       ,
                                                    INPUT  TABLE ttEmit      ,
                                                    INPUT  TABLE ttEntrega   ,
                                                    INPUT  TABLE ttExporta   ,
                                                    INPUT  TABLE ttICMS00    ,
                                                    INPUT  TABLE ttICMS10    ,
                                                    INPUT  TABLE ttICMS20    ,
                                                    INPUT  TABLE ttICMS30    ,
                                                    INPUT  TABLE ttICMS40    ,
                                                    INPUT  TABLE ttICMS51    ,
                                                    INPUT  TABLE ttICMS60    ,
                                                    INPUT  TABLE ttICMS70    ,
                                                    INPUT  TABLE ttICMS90    ,
                                                    INPUT  TABLE ttICMSTot   ,
                                                    INPUT  TABLE ttIde       ,
                                                    INPUT  TABLE ttII        ,
                                                    INPUT  TABLE ttInfAdic   ,
                                                    INPUT  TABLE ttIPI       ,
                                                    INPUT  TABLE ttISSQN     ,
                                                    INPUT  TABLE ttISSQNtot  ,
                                                    INPUT  TABLE ttLacres    ,
                                                    INPUT  TABLE ttMed       ,
                                                    INPUT  TABLE ttNFe       ,
                                                    INPUT  TABLE ttNFRef     ,
                                                    INPUT  TABLE ttObsCont   ,
                                                    INPUT  TABLE ttObsFisco  ,
                                                    INPUT  TABLE ttPISAliq   ,
                                                    INPUT  TABLE ttPISNT     ,
                                                    INPUT  TABLE ttPISOutr   ,
                                                    INPUT  TABLE ttPISQtde   ,
                                                    INPUT  TABLE ttPISST     ,
                                                    INPUT  TABLE ttProcRef   ,
                                                    INPUT  TABLE ttReboque   ,
                                                    INPUT  TABLE ttRetirada  ,
                                                    INPUT  TABLE ttRetTrib   ,
                                                    INPUT  TABLE ttTransp    ,
                                                    INPUT  TABLE ttVeic      ,
                                                    INPUT  TABLE ttVol       ).
    END.

    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.



PROCEDURE pi-prepara-dados:

    IF  NOT AVAIL estabelec 
        OR (AVAIL estabelec AND estabelec.cod-estabel <> nota-fiscal.cod-estabel) THEN
        FOR FIRST estabelec NO-LOCK
            WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel:
        END.

    ASSIGN lLayoutXML = (IF  LOOKUP (cTpTrans, "Manual,Nenhum":U) = 0  
                             THEN YES /* Aplicativo de Transmiss∆o */
                             ELSE NO)
           lLayoutTXT = (IF  cTpTrans = "Manual":U 
                             THEN YES /* Transmiss∆o Manual */
                             ELSE NO).

    IF  lLayoutTXT THEN
        ASSIGN cLocalArqTXT = TRIM(estabelec.des-local-arq)
               cLocalArqTXT = REPLACE(cLocalArqTXT,"/","~\")
               cLocalArqTXT = (IF SUBSTRING(cLocalArqTXT,LENGTH(cLocalArqTXT),1) = "~\"
                               THEN cLocalArqTXT
                               ELSE cLocalArqTXT + "~\").


    RUN pi-localiza-tabelas.

    ASSIGN c-serie = nota-fiscal.serie.
    
    /*--- UPC para Tratamento de SÇrie ---*/
    IF  c-nom-prog-dpc-mg97  <> "" 
    OR  c-nom-prog-appc-mg97 <> "" 
    OR  c-nom-prog-upc-mg97  <> "" THEN DO:

        /* TrataSerieNfe: EPC para retirar letras da sÇrie */
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
    END.
    /*-----*/

    ASSIGN c-serie = IF  c-serie = ""
                     THEN "0"
                     ELSE c-serie.

    ASSIGN c-cod-cfop = (&if defined(bf_dis_formato_CFOP)
                         &then bf-natur-oper-nf.cod-cfop
                         &else SUBSTR(bf-natur-oper-nf.char-1,45,10) &endif)  WHEN AVAIL bf-natur-oper-nf.
                         
                         
    ASSIGN l-funcao-preco-bruto-nfe = CAN-FIND (FIRST funcao
                                                WHERE funcao.cd-funcao = "SPP-PRECO-BRUTO-NFE":U
                                                  AND funcao.ativo).

    RUN pi-grava-temp-tables.

    ASSIGN d-total-base-icms    = 0
           d-total-icms         = 0
           d-total-base-iss     = 0
           d-total-iss          = 0
           d-total-serv         = 0
           d-total-ipi          = 0
           d-total-base-icms-st = 0
           d-total-icms-st      = 0
           d-total-ii           = 0
           d-total-pis          = 0
           d-total-cofins       = 0
           d-total-outras-desp  = 0
           d-total-ret-pis      = 0
           d-total-ret-cofins   = 0
           d-total-ret-csll     = 0
           d-total-ret-irf      = 0
           d-total-base-ret-irf = 0
           de-vl-zfm-tot        = 0
           de-vProdTotal        = 0.

END PROCEDURE.

PROCEDURE pi-localiza-tabelas:

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
    END.

    ASSIGN i-natureza = emitente.natureza.

    IF i-natureza = 1       AND 
       CONNECTED ("emsgra") THEN DO:

        RUN ggp/ggapi111.p (INPUT  nota-fiscal.cod-entrega,
                            INPUT  nota-fiscal.cod-emitente,
                            OUTPUT i-natureza).

    END.
    FOR FIRST pais NO-LOCK
        WHERE pais.nome-pais = estabelec.pais:
    END.

    IF  NOT AVAIL bf-unid-feder-est THEN
    FOR FIRST bf-unid-feder-est NO-LOCK
        WHERE bf-unid-feder-est.pais   = estabelec.pais
          AND bf-unid-feder-est.estado = estabelec.estado:
    END.

    IF  NOT AVAIL bf-cidade-est THEN
    FOR FIRST bf-cidade-est 
        WHERE bf-cidade-est.cidade = estabelec.cidade
          AND bf-cidade-est.estado = estabelec.estado
          AND bf-cidade-est.pais   = estabelec.pais   NO-LOCK:
    END.
    
    FOR FIRST bf-natur-oper-nf NO-LOCK
        WHERE bf-natur-oper-nf.nat-operacao = nota-fiscal.nat-operacao:
    END.

    IF  AVAIL bf-natur-oper-nf THEN DO:
        FOR FIRST cfop-natur NO-LOCK
            WHERE cfop-natur.cod-cfop = &if defined(bf_dis_formato_CFOP) &then bf-natur-oper-nf.cod-cfop &else SUBSTR(bf-natur-oper-nf.char-1,45,10) &endif:
        END.
    END.

    FOR FIRST cond-pagto NO-LOCK 
        WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag:
    END.

    FOR FIRST ser-estab NO-LOCK
        WHERE ser-estab.serie       = nota-fiscal.serie
          AND ser-estab.cod-estabel = nota-fiscal.cod-estabel:
    END.

    IF  NOT AVAIL bf-emitente-est THEN
    FOR FIRST bf-emitente-est NO-LOCK
        WHERE bf-emitente-est.cod-emitente = estabelec.cod-emitente:
    END.

    FOR FIRST bf-pais NO-LOCK
        WHERE bf-pais.nome-pais = emitente.pais:
    END.

    FOR FIRST estab-uf
        WHERE estab-uf.cod-estabel = nota-fiscal.cod-estabel
          AND estab-uf.estado      = nota-fiscal.estado  NO-LOCK:
    END.

    FOR FIRST bf-cidade-emit 
        WHERE bf-cidade-emit.cidade = emitente.cidade
          AND bf-cidade-emit.estado = emitente.estado
          AND bf-cidade-emit.pais   = emitente.pais   NO-LOCK:
    END.
    
    FOR FIRST bf-cidade-entrega 
        WHERE bf-cidade-entrega.cidade = nota-fiscal.cidade
          AND bf-cidade-entrega.estado = nota-fiscal.estado
          AND bf-cidade-entrega.pais   = nota-fiscal.pais   NO-LOCK:
    END.

    FOR FIRST bf-unid-feder-emit NO-LOCK
        WHERE bf-unid-feder-emit.pais   = emitente.pais
          AND bf-unid-feder-emit.estado = emitente.estado:
    END.

    FOR FIRST para-fat NO-LOCK: 
    END.

END PROCEDURE.

PROCEDURE pi-grava-temp-tables:

    RUN pi-cria-ttNFe.
    RUN pi-cria-ttIde.
    /*RUN pi-cria-ttNFref.*/
    RUN pi-cria-ttEmit.
    RUN pi-cria-ttDest.
                      
    /* Somente criar ttEntrega se endereáo de entrega for diferente do endereáo do cliente */

    IF AVAIL emitente
    AND emitente.natureza      > 1 /* Pessoa Fisica */
    AND (emitente.cgc          <> nota-fiscal.cgc          OR
         emitente.ins-estadual <> nota-fiscal.ins-estadual OR
         emitente.endereco     <> nota-fiscal.endereco     OR
         emitente.bairro       <> nota-fiscal.bairro       OR
         emitente.cidade       <> nota-fiscal.cidade       OR
         emitente.estado       <> nota-fiscal.estado       OR
         emitente.pais         <> nota-fiscal.pais         OR
         emitente.cep          <> nota-fiscal.cep          )  THEN
        RUN pi-cria-ttEntrega.

    RUN pi-cria-ttExporta.

    RUN pi-cria-ttDI.

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:

        FOR FIRST item NO-LOCK
            WHERE item.it-codigo = it-nota-fisc.it-codigo:
        END.

        RUN pi-cria-ttDet. 

        
        IF i-natureza > 1 THEN /*AlteraÁ„o Gutz*/
           RUN pi-cria-ttNFref.

        RUN pi-cria-ttAdi.

        RUN pi-cria-ICMS.

        RUN pi-cria-ttIPI.

        RUN pi-cria-ttII.

        RUN ftp/ftapi510.p (INPUT  ROWID(nota-fiscal),
                            INPUT  ROWID(it-nota-fisc),
                            OUTPUT d-aliq-pis,
                            OUTPUT d-base-pis,
                            OUTPUT d-valor-pis,
                            OUTPUT d-aliq-cofins,
                            OUTPUT d-base-cofins,
                            OUTPUT d-valor-cofins).

        RUN pi-cria-ttPIS.

        RUN pi-cria-ttCOFINS.

    	
        IF      (nota-fiscal.ind-tip-nota   = 8  /*no recebimento verificar apenas it-nota-fisc,*/ 
             AND  it-nota-fisc.cod-servico <> 0) /*para nao dar problema em notas de devolucao */
        OR       (nota-fiscal.ind-tip-nota <> 8 /*ou importaªío de item com cod-serviªo no cadastro do item */
             AND (it-nota-fisc.cod-servico <> 0 
                  OR   iTEM.cod-servico         <> 0)) THEN 
            RUN pi-cria-ISS.

        /*--- TOTAIS ---*/
        ASSIGN d-total-base-icms    = d-total-base-icms    + (IF (it-nota-fisc.cd-trib-icm = 3 AND l-icms-outras-it) THEN it-nota-fisc.vl-icmsou-it ELSE it-nota-fisc.vl-bicms-it)
               d-total-icms         = d-total-icms         + (IF  it-nota-fisc.cd-trib-icm = 1                           /*Tributado*/
                                                              OR (it-nota-fisc.cd-trib-icm = 3 AND l-icms-outras-it)     /*Outras e Considera Tributos Outras na NF-e */
                                                              OR  it-nota-fisc.cd-trib-icm = 4                           /*Reduzido  */
                                                              THEN it-nota-fisc.vl-icms-it
                                                              ELSE 0)
               d-total-base-iss     = d-total-base-iss     + it-nota-fisc.vl-biss-it
               d-total-iss          = d-total-iss          + (IF it-nota-fisc.cd-trib-iss = 1 /*Tributado*/
                                                              OR it-nota-fisc.cd-trib-iss = 4 /*Reduzido  */
                                                              THEN it-nota-fisc.vl-iss-it
                                                              ELSE 0)
               d-total-serv         = d-total-serv         + IF AVAIL bf-natur-oper-it AND bf-natur-oper-it.tipo = 3 THEN it-nota-fisc.vl-merc-liq ELSE  0
               d-total-base-icms-st = d-total-base-icms-st + it-nota-fisc.vl-bsubs-it
               d-total-icms-st      = d-total-icms-st      + it-nota-fisc.vl-icmsub-it
               d-total-pis          = d-total-pis          + d-valor-pis
               d-total-cofins       = d-total-cofins       + d-valor-cofins
               d-total-outras-desp  = d-total-outras-desp  + it-nota-fisc.vl-despes-it
               d-total-ret-irf      = d-total-ret-irf      + it-nota-fisc.vl-irf-it

        
               d-total-ret-pis      = d-total-ret-pis      + it-nota-fisc.val-retenc-pis
               d-total-ret-cofins   = d-total-ret-cofins   + it-nota-fisc.val-retenc-cofins
               d-total-ret-csll     = d-total-ret-csll     + it-nota-fisc.val-retenc-csll
        .

        /* Calcula base IRF: conforme dibo~\bodi317im1br.m25 */
        IF it-nota-fisc.vl-irf-it > 0  THEN DO:

          ASSIGN d-total-base-ret-irf = d-total-base-ret-irf + it-nota-fisc.vl-merc-liq .
                              
          if  it-nota-fisc.cd-trib-ipi <> 3
          and bf-natur-oper-nf.log-ipi-contrib-retid THEN
              assign d-total-base-ret-irf = d-total-base-ret-irf + it-nota-fisc.vl-ipi-it.

          if  it-nota-fisc.cd-trib-ipi = 3
           and substring(bf-natur-oper-nf.char-2,16,1) = "1":U
           and bf-natur-oper-nf.log-ipi-outras-contrib-retid THEN
               assign d-total-base-ret-irf = d-total-base-ret-irf + it-nota-fisc.vl-ipi-it.
                                        
          IF bf-natur-oper-nf.log-icms-substto-base-irf-retid = yes  then
              assign d-total-base-ret-irf = d-total-base-ret-irf + it-nota-fisc.vl-icmsub-it.
        END.
        
        /*--- FIM TOTAIS ---*/

    END.

    /* atualizar desconto do item para ZFM */
    IF  de-vl-zfm-tot <> 0 
    AND lLayoutTXT
    AND l-fn-ZFM then
        RUN pi-atualizar-desc-zfm-itens.

    RUN pi-cria-ttICMSTot.

    IF  d-total-base-iss > 0
    AND d-total-iss      > 0 THEN
        RUN pi-cria-ttISSQNTot.
    ELSE
        ASSIGN ttEmit.IM   = ""
               ttEmit.CNAE = "".

    RUN pi-cria-ttRetTrib.

    RUN pi-cria-ttTransp.

    RUN pi-cria-ttCobr.

    RUN pi-cria-ttInfAdic.

    RUN pi-cria-ttCompra.  /* VER MAPA NEOGRID - Lµ CONSTA INFORMAÄÂES DE COMPRA, E N«O DO PEDIDO */

    RUN pi-carregaEmailDestTransp. /* para o envio do e-mail do destinat†rio e transportador ao Neogrid */

    /*--- CHAMADAS UPC PARA TODOS OS CAMPOS DE TODAS AS TABELAS NF-e --*/
    RUN pi-executa-upc.
    /*-----*/

END PROCEDURE.

PROCEDURE pi-limpa-temp-tables:

    EMPTY TEMP-TABLE ttAdi        NO-ERROR.
    EMPTY TEMP-TABLE ttArma       NO-ERROR.
    EMPTY TEMP-TABLE ttAvulsa     NO-ERROR.
    EMPTY TEMP-TABLE ttCobr       NO-ERROR.
    EMPTY TEMP-TABLE ttCOFINSAliq NO-ERROR.
    EMPTY TEMP-TABLE ttCOFINSNT   NO-ERROR.
    EMPTY TEMP-TABLE ttCOFINSOutr NO-ERROR.
    EMPTY TEMP-TABLE ttCOFINSQtde NO-ERROR.
    EMPTY TEMP-TABLE ttCOFINSST   NO-ERROR.
    EMPTY TEMP-TABLE ttComb       NO-ERROR.
    EMPTY TEMP-TABLE ttCompra     NO-ERROR.
    EMPTY TEMP-TABLE ttDest       NO-ERROR.
    EMPTY TEMP-TABLE ttDet        NO-ERROR.
    EMPTY TEMP-TABLE ttDI         NO-ERROR.
    EMPTY TEMP-TABLE ttDup        NO-ERROR.
    EMPTY TEMP-TABLE ttEmit       NO-ERROR.
    EMPTY TEMP-TABLE ttEntrega    NO-ERROR.
    EMPTY TEMP-TABLE ttExporta    NO-ERROR.
    EMPTY TEMP-TABLE ttICMS00     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS10     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS20     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS30     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS40     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS51     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS60     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS70     NO-ERROR.
    EMPTY TEMP-TABLE ttICMS90     NO-ERROR.
    EMPTY TEMP-TABLE ttICMSTot    NO-ERROR.
    EMPTY TEMP-TABLE ttIde        NO-ERROR.
    EMPTY TEMP-TABLE ttII         NO-ERROR.
    EMPTY TEMP-TABLE ttInfAdic    NO-ERROR.
    EMPTY TEMP-TABLE ttIPI        NO-ERROR.
    EMPTY TEMP-TABLE ttISSQN      NO-ERROR.
    EMPTY TEMP-TABLE ttISSQNtot   NO-ERROR.
    EMPTY TEMP-TABLE ttLacres     NO-ERROR.
    EMPTY TEMP-TABLE ttMed        NO-ERROR.
    EMPTY TEMP-TABLE ttNFe        NO-ERROR.
    EMPTY TEMP-TABLE ttNFRef      NO-ERROR.
    EMPTY TEMP-TABLE ttObsCont    NO-ERROR.
    EMPTY TEMP-TABLE ttObsFisco   NO-ERROR.
    EMPTY TEMP-TABLE ttPISAliq    NO-ERROR.
    EMPTY TEMP-TABLE ttPISNT      NO-ERROR.
    EMPTY TEMP-TABLE ttPISOutr    NO-ERROR.
    EMPTY TEMP-TABLE ttPISQtde    NO-ERROR.
    EMPTY TEMP-TABLE ttPISST      NO-ERROR.
    EMPTY TEMP-TABLE ttProcRef    NO-ERROR.
    EMPTY TEMP-TABLE ttReboque    NO-ERROR.
    EMPTY TEMP-TABLE ttRetirada   NO-ERROR.
    EMPTY TEMP-TABLE ttRetTrib    NO-ERROR.
    EMPTY TEMP-TABLE ttTransp     NO-ERROR.
    EMPTY TEMP-TABLE ttVeic       NO-ERROR.
    EMPTY TEMP-TABLE ttVol        NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erro  NO-ERROR.

END PROCEDURE.

PROCEDURE pi-cria-ttNFe:

    /*
    === ttNFe ===
    CodEstabelNF   AS CHARACTER INITIAL ?
    SerieNF        AS CHARACTER INITIAL ?
    NrNotaFisNF    AS CHARACTER INITIAL ?
    ChaveAcessoNFe AS CHARACTER INITIAL ?
    VersaoLayout   AS CHARACTER INITIAL ?
    */

    CREATE ttNFe.
    ASSIGN ttNFe.CodEstabelNF   = nota-fiscal.cod-estabel
           ttNFe.SerieNF        = nota-fiscal.serie
           ttNFe.NrNotaFisNF    = nota-fiscal.nr-nota-fis
           ttNFe.ChaveAcessoNFe = TRIM(STRING   (nota-fiscal.cod-chave-aces-nf-eletro))
           ttNFe.VersaoLayout   = TRIM(estabelec.des-vers-layout).
                                       
    ASSIGN iContNota = iContNota + 1.

END PROCEDURE.

PROCEDURE pi-cria-ttIde:

    DEFINE VARIABLE cIndPag      AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE l-funcao-tss AS LOGICAL    NO-UNDO.
    /*
    === ttIde ===
    cDV            AS CHARACTER INITIAL ?  /*Digito Verificador da Chave de Acesso da NF-e*/
    cMunFG         AS INT       INITIAL ?  /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
    cNF            AS CHARACTER INITIAL ?  /*C¢digo numÇrico que comp‰e a Chave de Acesso. N£mero aleat¢rio gerado pelo emitente para cada NF-e.*/
    cUF            AS INT       INITIAL ?  /*C¢digo da UF do emitente do Documento Fiscal. Utilizar a Tabela do IBGE.*/
    dEmi           AS DATE      INITIAL ?  /*Data de emiss∆o do Documento Fiscal (AAAA-MM-DD)*/
    dSaiEnt        AS DATE      INITIAL ?  /*Data de sa°da ou de entrada da mercadoria / produto (AAAA-MM-DD)*/
    finNFe         AS CHARACTER INITIAL ?  /*Finalidade da emiss∆o da NF-e: 1 - NFe normal 2 - NFe complementar 3 - NFe de ajuste*/
    indPag         AS CHARACTER INITIAL ?  /*Indicador da forma de pagamento: 0 - pagamento Ö vista; 1 - pagamento ‡ prazo; 2 - outros.*/
    mod            AS CHARACTER INITIAL ?  /*C¢digo do modelo do Documento Fiscal. Utilizar 55 para identificaá∆o da NF-e, emitida em substituiá∆o ao modelo 1 e 1A.*/
    natOp          AS CHARACTER INITIAL ?  /*Descriá∆o da Natureza da Operaá∆o*/
    nNF            AS CHARACTER INITIAL ?  /*N£mero do Documento Fiscal*/
    procEmi        AS CHARACTER INITIAL ?  /*Processo de emiss∆o utilizado com a seguinte codificaá∆o: 0 - emiss∆o de NF-e com aplicativo do contribuinte; 1 - emiss∆o de NF-e avulsa pelo Fisco; 2 - emiss∆o de NF-e avulsa, pelo contribuinte com seu certificado digital, atravÈs do site do Fisco; 3- emiss∆o de NF-e pelo contribuinte com aplicativo fornecido pelo Fisco.*/
    serie          AS CHARACTER INITIAL ?  /*SÈrie do Documento Fiscal*/
    tpAmb          AS CHARACTER INITIAL ?  /*Identificaá∆o do Ambiente: 1 - Produá∆o 2 - Homologaá∆o*/
    tpEmis         AS CHARACTER INITIAL ?  /*Forma de emiss∆o da NF-e (1 - Normal; 2 - Contingància)*/
    tpImp          AS CHARACTER INITIAL ?  /*Formato de impress∆o do DANFE (1 - Retrato; 2 - Paisagem)*/
    tpNF           AS CHARACTER INITIAL ?  /*Tipo do Documento Fiscal (0 - entrada; 1 - sa°da)*/
    verProc        AS CHARACTER INITIAL ?  /*vers∆o do aplicativo utilizado no processo de emiss∆o*/
    */

    ASSIGN l-funcao-tss = LOOKUP (cTpTrans, "TSS,TC":U) > 0.

    FOR FIRST param-nf-estab NO-LOCK
        WHERE param-nf-estab.cod-estabel = nota-fiscal.cod-estabel: END.

    IF  AVAIL cond-pagto
    AND nota-fiscal.cod-cond-pag <> 0 THEN /* nao e condicao especial */
        ASSIGN cIndPag = (IF cond-pagto.cod-vencto = 2
                          THEN "0"
                          ELSE IF cond-pagto.cod-vencto = 3
                               THEN "2"
                               ELSE "1").
    ELSE
        ASSIGN cIndPag = "2". /* Outros */

    ASSIGN l-nota-compl-imp = NO.

    IF  i-natureza > 1 THEN
        IF  nota-fiscal.ind-tip-nota = 4 THEN DO:
            FIND it-nota-fisc WHERE /*nao use find first*/
                 it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel AND
                 it-nota-fisc.serie       = nota-fiscal.serie AND
                 it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis NO-LOCK NO-ERROR.
            IF  AVAIL it-nota-fisc              
            AND (it-nota-fisc.qt-faturada[1] = 1 OR it-nota-fisc.qt-faturada[1] = 0)
            AND it-nota-fisc.vl-merc-liq    = 0 
            AND it-nota-fisc.vl-merc-tab    = 0
            AND it-nota-fisc.tipo-contr     = 4 /*debito direto*/ THEN
            ASSIGN l-nota-compl-imp = YES.
    END.

    CREATE ttIde.
    ASSIGN ttIde.cDV     = SUBSTRING(STRING(nota-fiscal.cod-chave-aces-nf-eletro),44,1)
           ttIde.cMunFG  = STRING(IF  estabelec.pais = "Brasil":U
                                  THEN (IF AVAIL bf-cidade-est THEN bf-cidade-est.cdn-munpio-ibge ELSE 0)
                                  ELSE 9999999)
           ttIde.cNF     = SUBSTRING ( STRING   (nota-fiscal.cod-chave-aces-nf-eletro),35,9)
           ttIde.cUF     = STRING(IF  estabelec.pais = "Brasil":U
                                  THEN (IF AVAIL bf-unid-feder-est THEN INT(bf-unid-feder-est.cod-uf-ibge) ELSE 0)
                                  ELSE 99)
           ttIde.dEmi    = nota-fiscal.dt-emis-nota
           ttIde.dSaiEnt = nota-fiscal.dt-saida
           ttIde.finNFe  = (IF nota-fiscal.ind-tip-nota = 3 /*3 Diferenca de Preco*/
                         THEN "3"
                         ELSE IF l-nota-compl-imp /*2 Complementar de Imposto*/
                         THEN "2"
                         ELSE "1")
           ttIde.indPag  = cIndPag
           ttIde.indPag  = (IF nota-fiscal.emite-duplic
                            THEN "1"  /* cond pagto especial */
                            ELSE "0") WHEN (NOT AVAIL cond-pagto) OR (AVAIL cond-pagto AND cond-pagto.cod-cond-pag = 0)
           ttIde.mod     = bf-natur-oper-nf.cod-model-nf-eletro WHEN AVAIL bf-natur-oper-nf
           ttIde.natOp   = (IF AVAIL cfop-natur
                            THEN cfop-natur.des-cfop
                            ELSE IF AVAIL bf-natur-oper-nf THEN bf-natur-oper-nf.denominacao ELSE "")
           ttIde.nNF     = STRING( DEC(nota-fiscal.nr-nota-fis) )  /* Para retirar zeros Ö esquerda */
           ttIde.procEmi = (IF lLayoutTXT
                            THEN "3"  /*3 - emiss∆o de NF-e pelo contribuinte com aplicativo fornecido pelo FISCO*/
                            ELSE "0") /*0 - emiss∆o de NF-e com aplicativo do contribuinte*/
           ttIde.serie   = c-serie.

IF  l-funcao-tss THEN DO:
    ASSIGN ttIde.tpAmb   = IF  AVAIL param-nf-estab THEN 
                               STRING(param-nf-estab.idi-tip-emis-amb-sefaz)
                           ELSE 
                               (IF estabelec.idi-tip-emis-nf-eletro = 3
                                THEN "1"  /* Produá∆o    */
                                ELSE "2") /* Homologaá∆o */. 
END.
ELSE DO:
    ASSIGN ttIde.tpAmb   = (IF estabelec.idi-tip-emis-nf-eletro = 3
                            THEN "1"  /* Produá∆o    */
                            ELSE "2") /* Homologaá∆o */
                            .
END.

    ASSIGN ttIde.tpEmis  = STRING(nota-fiscal.idi-forma-emis-nf-eletro)
           ttIde.tpImp   = STRING(ser-estab.idi-format-emis-danfe) WHEN AVAIL ser-estab
           ttIde.tpNF    = (IF SUBSTRING(c-cod-cfop,1,1) = "1"
                            OR SUBSTRING(c-cod-cfop,1,1) = "2"
                            OR SUBSTRING(c-cod-cfop,1,1) = "3"
                            THEN "0"  /*Entrada*/
                            ELSE "1") /*Sa°da  */
           ttIde.verProc = (IF lLayoutTXT
                            THEN (IF &if  "{&bf_dis_versao_ems}" >= "2.09" &then 
                                       estabelec.des-vers-software-emissor
                                     &else 
                                       TRIM(SUBSTRING(estabelec.char-1,251,10)) &endif
                                  <> "":U
                                  THEN &if  "{&bf_dis_versao_ems}" >= "2.09"
                                       &then estabelec.des-vers-software-emissor
                                       &else TRIM(SUBSTRING(estabelec.char-1,251,10)) &endif
                                  ELSE "1.4.2")
                            ELSE "5.0")
           .

    /* Chave EMS */
    ASSIGN ttIde.CodEstabelNF = nota-fiscal.cod-estabel
           ttIde.SerieNF      = nota-fiscal.serie
           ttIde.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttIde THEN
        ASSIGN ttIde.cDV         = fn-ajusta-tamanho-campo(ttIde.cDV    , 1)
               ttIde.cMunFG      = fn-ajusta-tamanho-campo(ttIde.cMunFG , 7)
               ttIde.cNF         = fn-ajusta-tamanho-campo(ttIde.cNF    , 9)
               ttIde.cUF         = fn-ajusta-tamanho-campo(ttIde.cUF    , 2)
               ttIde.finNFe      = fn-ajusta-tamanho-campo(ttIde.finNFe , 1)
               ttIde.indPag      = fn-ajusta-tamanho-campo(ttIde.indPag , 1)
               ttIde.mod         = fn-ajusta-tamanho-campo(ttIde.mod    , 2)
               ttIde.natOp       = fn-ajusta-tamanho-campo(ttIde.natOp  ,60)
               ttIde.nNF         = fn-ajusta-tamanho-campo(ttIde.nNF    , 9)
               ttIde.procEmi     = fn-ajusta-tamanho-campo(ttIde.procEmi, 1)
               ttIde.serie       = fn-ajusta-tamanho-campo(ttIde.serie  , 3)
               ttIde.tpAmb       = fn-ajusta-tamanho-campo(ttIde.tpAmb  , 1)
               ttIde.tpEmis      = fn-ajusta-tamanho-campo(ttIde.tpEmis , 1)
               ttIde.tpImp       = fn-ajusta-tamanho-campo(ttIde.tpImp  , 1)
               ttIde.tpNF        = fn-ajusta-tamanho-campo(ttIde.tpNF   , 1)
               ttIde.verProc     = fn-ajusta-tamanho-campo(ttIde.verProc,20).

END PROCEDURE.

PROCEDURE pi-cria-ttNFref:

    DEF BUFFER bf-nota-fiscal FOR nota-fiscal.
    DEF VAR l-comp-imp AS LOG NO-UNDO.

    IF  l-nota-compl-imp THEN
        FOR FIRST nota-fisc-adc NO-LOCK
            WHERE nota-fisc-adc.cod-estab               = nota-fiscal.cod-estabel
             AND   nota-fisc-adc.cod-serie              = nota-fiscal.serie
             AND   nota-fisc-adc.cod-nota-fisc          = nota-fiscal.nr-nota-fis
             AND   nota-fisc-adc.cdn-emitente           = nota-fiscal.cod-emitente
             AND   nota-fisc-adc.cod-natur-operac       = nota-fiscal.nat-operacao
             AND   nota-fisc-adc.idi-tip-dado           = 3
             AND   nota-fisc-adc.idi-tip-docto-referado = 2 :

            FOR FIRST bf-nota-fiscal NO-LOCK
                WHERE bf-nota-fiscal.cod-estabel  = nota-fiscal.cod-estabel
                  AND bf-nota-fiscal.serie        = nota-fisc-adc.cod-ser-docto-referado
                  AND bf-nota-fiscal.nr-nota-fis  = nota-fisc-adc.cod-docto-referado
                  AND bf-nota-fiscal.cod-emitente = nota-fisc-adc.cdn-emit-docto-referado:
            END.

            RUN pi-ttNRef-docum-NF (INPUT IF  AVAIL bf-nota-fiscal 
                                          THEN bf-nota-fiscal.cod-chave-aces-nf-eletro 
                                          ELSE "" ,
                                    INPUT nota-fiscal.cod-estabel,
                                    INPUT nota-fisc-adc.cod-ser-docto-referado,
                                    INPUT nota-fisc-adc.dat-docto-referado,
                                    INPUT nota-fisc-adc.cod-docto-referado,
                                    INPUT nota-fisc-adc.cdn-emit-docto-referado,
                                    INPUT nota-fisc-adc.cod-model-docto-referado,
                                    INPUT "estab":U).
            
        END.
    

    FOR FIRST bf-nota-fiscal NO-LOCK
        WHERE bf-nota-fiscal.cod-estabel = nota-fiscal.cod-estabel
          AND bf-nota-fiscal.serie       = nota-fiscal.serie-orig
          AND bf-nota-fiscal.nr-nota-fis = nota-fiscal.nro-nota-orig:

        
        RUN pi-ttNRef-docum-NF (INPUT bf-nota-fiscal.cod-chave-aces-nf-eletro,
                                INPUT bf-nota-fiscal.cod-estabel,
                                INPUT bf-nota-fiscal.serie,
                                INPUT bf-nota-fiscal.dt-emis-nota,
                                INPUT bf-nota-fiscal.nr-nota-fis,
                                INPUT bf-nota-fiscal.cod-emitente,
                                INPUT "01",
                                INPUT "estab":U).

    END.

    
    FOR FIRST bf-nota-fiscal NO-LOCK
        WHERE bf-nota-fiscal.cod-estabel  = nota-fiscal.cod-estabel
          AND bf-nota-fiscal.serie        = it-nota-fisc.serie-docum
          AND bf-nota-fiscal.nr-nota-fis  = it-nota-fisc.nr-docum
          AND bf-nota-fiscal.cod-emitente = nota-fiscal.cod-emitente
          AND bf-nota-fiscal.nat-operacao = it-nota-fisc.nat-docum:

        
        RUN pi-ttNRef-docum-NF (INPUT bf-nota-fiscal.cod-chave-aces-nf-eletro,
                                INPUT bf-nota-fiscal.cod-estabel,
                                INPUT bf-nota-fiscal.serie,
                                INPUT bf-nota-fiscal.dt-emis-nota,
                                INPUT bf-nota-fiscal.nr-nota-fis,
                                INPUT bf-nota-fiscal.cod-emitente,
                                INPUT "01",
                                INPUT "estab":U).

    END.

    IF NOT AVAIL bf-nota-fiscal THEN DO:

        /*outras operacoes */
        FOR FIRST docum-est NO-LOCK
            WHERE docum-est.serie-docto  = it-nota-fisc.serie-docum
              AND docum-est.nro-docto    = it-nota-fisc.nr-docum
              AND docum-est.cod-emitente = nota-fiscal.cod-emitente
              AND docum-est.nat-operacao = it-nota-fisc.nat-docum:


            ASSIGN l-comp-imp = NO.

            /* Complementar de Importaá∆o */
            IF CONNECTED("mgcex") THEN DO:
               IF CAN-FIND(FIRST docum-est-cex WHERE
                                 docum-est-cex.serie-docto  = docum-est.serie-docto   AND
                                 docum-est-cex.nro-docto    = docum-est.nro-docto     AND
                                 docum-est-cex.cod-emitente = docum-est.cod-emitente  AND
                                 docum-est-cex.nat-operacao = docum-est.nat-operacao) THEN DO:

                  RUN pi-ttNRef-docum-NF (INPUT docum-est.cod-chave-aces-nf-eletro,
                                          INPUT docum-est.cod-estabel,
                                          INPUT docum-est.serie-docto,
                                          INPUT docum-est.dt-emissao,
                                          INPUT docum-est.nro-docto,
                                          INPUT docum-est.cod-emitente,
                                          INPUT "01",
                                          INPUT "estab":U).
                  ASSIGN l-comp-imp = YES.
               END.
            END.
            
           IF docum-est.nat-operacao BEGINS "3" THEN
                RUN pi-ttNRef-docum-NF (INPUT docum-est.cod-chave-aces-nf-eletro,
                                        INPUT docum-est.cod-estabel,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.dt-emissao,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.cod-emitente,
                                        INPUT "01",
                                        INPUT "estab":U).

            ELSE IF NOT l-comp-imp THEN
               RUN pi-ttNRef-docum-NF (INPUT docum-est.cod-chave-aces-nf-eletro,
                                       INPUT docum-est.cod-estabel,
                                       INPUT docum-est.serie-docto,
                                       INPUT docum-est.dt-emissao,
                                       INPUT docum-est.nro-docto,
                                       INPUT docum-est.cod-emitente,
                                       INPUT "01",
                                       INPUT "emit":U).
        END.

        IF  NOT AVAIL docum-est
        AND it-nota-fisc.nr-docum <> "" THEN DO:

            FOR FIRST item-doc-est USE-INDEX terceiro
                WHERE item-doc-est.cod-emit-terc  = nota-fiscal.cod-emitente
                AND   item-doc-est.serie-terc     = it-nota-fisc.serie-docum   
                AND   item-doc-est.nro-docto-terc = it-nota-fisc.nr-docum
                AND   item-doc-est.nat-terc       = it-nota-fisc.nat-docum
                AND   item-doc-est.seq-terc       = it-nota-fisc.int-1
                AND   item-doc-est.it-codigo      = it-nota-fisc.it-codigo NO-LOCK,
                FIRST docum-est NO-LOCK
                WHERE docum-est.cod-emitente = item-doc-est.cod-emitente
                AND   docum-est.serie-docto  = item-doc-est.serie-docto
                AND   docum-est.nro-docto    = item-doc-est.nro-docto
                AND   docum-est.nat-operacao = item-doc-est.nat-operacao : 

                RUN pi-ttNRef-docum-NF (INPUT docum-est.cod-chave-aces-nf-eletro,
                                        INPUT docum-est.cod-estabel,
                                        INPUT docum-est.serie-docto,
                                        INPUT docum-est.dt-emissao,
                                        INPUT docum-est.nro-docto,
                                        INPUT docum-est.cod-emitente,
                                        INPUT "01",
                                        INPUT "emit":U).
            END.                                        
        END.
    END.
     
    /* Nao tem notas referenciadas, entao enviar finalidade da NF-e como 1 [Opcoes: 1- NF-e Normal / 2-NF-e Complementar / 3 Œ NF-e de Ajuste] */
    FIND FIRST ttNFRef NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL ttNFRef THEN DO:
        IF  NOT AVAIL ttIde THEN
            FIND FIRST ttIde NO-ERROR.
            
        ASSIGN ttIde.finNFe = "1":U.
    END.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttNFRef THEN DO:
        ASSIGN ttNFRef.refNFe = fn-ajusta-tamanho-campo(ttNFRef.refNFe,44).
        ASSIGN ttNFRef.cUF    = fn-ajusta-tamanho-campo(ttNFRef.cUF   , 2)
               ttNFRef.AAMM   = fn-ajusta-tamanho-campo(ttNFRef.AAMM  , 4)
               ttNFRef.CNPJ   = fn-ajusta-tamanho-campo(ttNFRef.CNPJ  ,14)
               ttNFRef.mod    = fn-ajusta-tamanho-campo(ttNFRef.mod   , 2)
               ttNFRef.serie  = fn-ajusta-tamanho-campo(ttNFRef.serie , 3)
               ttNFRef.nNF    = fn-ajusta-tamanho-campo(ttNFRef.nNF   , 9).
    END.
    
        
END PROCEDURE.

PROCEDURE pi-ttNRef-docum-NF: 
    DEFINE INPUT PARAMETER p-cod-chave-aces-nf-eletro AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-estabel              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-serie                    AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-dt-emis-nota             AS DATE      NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-nota-fis              AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-emitente             AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-mod                      AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-emi-nota                 AS CHARACTER NO-UNDO.


    DEF BUFFER bf2-estabelec      FOR estabelec.
    DEF BUFFER bf2-emitente       FOR emitente.
    DEF BUFFER bf2-unid-feder-est FOR unid-feder.
    DEF BUFFER bf2-natur-oper-nf  FOR natur-oper.


    IF p-emi-nota = "estab":U THEN DO:
        FOR FIRST bf2-estabelec NO-LOCK
            WHERE bf2-estabelec.cod-estabel = p-cod-estabel:
        END.
    
        IF  NOT AVAIL bf2-unid-feder-est THEN
        FOR FIRST bf2-unid-feder-est NO-LOCK
            WHERE bf2-unid-feder-est.pais   = bf2-estabelec.pais   
              AND bf2-unid-feder-est.estado = bf2-estabelec.estado:
        END.
    END.
    ELSE IF p-emi-nota = "emit":U THEN DO:
        FOR FIRST bf2-emitente NO-LOCK
            WHERE bf2-emitente.cod-emitente = p-cod-emitente:
        END.
    
        IF  NOT AVAIL bf2-unid-feder-est THEN
        FOR FIRST bf2-unid-feder-est NO-LOCK
            WHERE bf2-unid-feder-est.pais   = bf2-emitente.pais
              AND bf2-unid-feder-est.estado = bf2-emitente.estado:
        END.
    END.

       
       /* Nota Eletronica, envia somente tag <refNFe> */
    IF  p-cod-chave-aces-nf-eletro <> ?
    AND p-cod-chave-aces-nf-eletro <> ""
    AND (estabelec.idi-tip-emis-nf-eletro    = 2  /* Processo Emiss∆o NF-e - CD0403 [Homologaá∆o] */
    OR  (estabelec.idi-tip-emis-nf-eletro    = 3  /* Processo Emiss∆o NF-e - CD0403 [Produá∆o] - Para verificar a sÇrie, Ç necess†rio verificar se o estabelecimento est† em Produá∆o */
    AND  CAN-FIND (FIRST ser-estab /* Verifica se a nota vinculada e' mesmo eletronica */
                   WHERE ser-estab.cod-estabel = p-cod-estabel
                     AND ser-estab.serie       = p-serie
                     AND ser-estab.log-nf-eletro)))
    THEN DO:
        FIND FIRST ttNFRef WHERE ttNFRef.refNFe = p-cod-chave-aces-nf-eletro NO-ERROR.
        IF NOT AVAIL ttNFRef THEN DO:

              CREATE ttNFRef.
              ASSIGN ttNFRef.refNFe       = ""
                     /* Chave EMS */
                     ttNFRef.CodEstabelNF = nota-fiscal.cod-estabel
                     ttNFRef.SerieNF      = IF nota-fiscal.serie = "" THEN "0" ELSE nota-fiscal.serie
                     ttNFRef.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                     ttNFRef.ItCodigoNF   = it-nota-fisc.it-codigo
                     ttNFRef.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        
              /* NFe: enviar somente chave de acesso */
              ASSIGN ttNFRef.refNFe     = TRIM(p-cod-chave-aces-nf-eletro).
        
        END.

    END.
    ELSE DO: /* Nao e' Nota Eletronica, enviar colecao <refNF> */
       
         FIND FIRST ttNFRef NO-LOCK
             WHERE ttNFRef.CodEstabelNF = nota-fiscal.cod-estabel
             AND   ttNFRef.SerieNF      = (IF nota-fiscal.serie = "" THEN "0" ELSE nota-fiscal.serie)
             AND   ttNFRef.NrNotaFisNF  = nota-fiscal.nr-nota-fis
             AND   ttNFRef.nNF          = STRING(INT(p-nr-nota-fis)) NO-ERROR.

         IF NOT AVAIL ttNFRef THEN DO:


            CREATE ttNFRef.
            ASSIGN ttNFRef.refNFe       = ""
                   /* Chave EMS */
                   ttNFRef.CodEstabelNF = nota-fiscal.cod-estabel
                   ttNFRef.SerieNF      = IF nota-fiscal.serie = "" THEN "0" ELSE nota-fiscal.serie
                   ttNFRef.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttNFRef.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttNFRef.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

            ASSIGN ttNFRef.cUF          = IF p-emi-nota = "estab":U THEN 
                                                 STRING(IF  bf2-estabelec.pais = "Brasil":U
                                                         THEN (IF AVAIL bf2-unid-feder-est THEN INT(bf2-unid-feder-est.cod-uf-ibge) ELSE 0)
                                                         ELSE 99)
                                          ELSE 
                                                  STRING(IF  bf2-emitente.pais = "Brasil":U
                                                         THEN (IF AVAIL bf2-unid-feder-est THEN INT(bf2-unid-feder-est.cod-uf-ibge) ELSE 0)
                                                         ELSE 99)
                   ttNFRef.AAMM         = TRIM(SUBSTRING(STRING(YEAR(p-dt-emis-nota),"9999"),3,2) + STRING(MONTH(p-dt-emis-nota),"99"))
                   ttNFRef.CNPJ         = IF p-emi-nota = "estab":U THEN bf2-estabelec.cgc ELSE 
                                          IF p-emi-nota = "emit":U  THEN bf2-emitente.cgc  ELSE estabelec.cgc
                   ttNFRef.mod          = p-mod 
                   ttNFRef.serie        = IF p-serie = "" THEN "0" ELSE p-serie
                   ttNFRef.nNF          = STRING(INT(p-nr-nota-fis)).

            
         END.
         
   END.

END PROCEDURE.

PROCEDURE pi-cria-ttEmit:

    /*
    === ttEmit ===
    CEP            AS CHARACTER INITIAL ?  /*CEP*/
    cMun           AS INT       INITIAL ?  /*C¢digo do munic°pio (utilizar a tabela do IBGE), informar 9999999 para operaá‰es com o exterior    .*/
    CNAE           AS CHARACTER INITIAL ?  /*CNAE Fiscal*/
    CNPJ           AS CHARACTER INITIAL ?  /*N£mero do CNPJ do emitente*/
    cPais          AS INT       INITIAL ?  /*C¢digo do pa°s*/
    CPF            AS CHARACTER INITIAL ?  /*N£mero do CPF do emitente*/
    fone           AS CHARACTER INITIAL ?  /*Telefone*/
    IE             AS CHARACTER INITIAL ?  /*Inscriá∆o Estadual*/
    IEST           AS CHARACTER INITIAL ?  /*Inscricao Estadual do Substituto Tribut†rio*/
    IM             AS CHARACTER INITIAL ?  /*Inscriá∆o Municipal*/
    nro            AS CHARACTER INITIAL ?  /*N£mero*/
    UF             AS CHARACTER INITIAL ?  /*Sigla da UF, , informar EX para operaá‰es com o exterior.*/
    xBairro        AS CHARACTER INITIAL ?  /*Bairro*/
    xCpl           AS CHARACTER INITIAL ?  /*Complemento*/
    xFant          AS CHARACTER INITIAL ?  /*Nome fantasia*/
    xLgr           AS CHARACTER INITIAL ?  /*Logradouro*/
    xMun           AS CHARACTER INITIAL ?  /*Nome do munic°pio, , informar EXTERIOR para operaá‰es com o exterior.*/
    xNome          AS CHARACTER INITIAL ?  /*Raz∆o Social ou Nome do emitente*/
    xPais          AS CHARACTER INITIAL ?  /*Nome do pa°s*/
    VersaoLayout   AS CHARACTER INITIAL ?  /*Vers∆o do Emissor*/
    */


    ASSIGN c-endereco = estabelec.endereco
           c-rua      = ""
           c-nro      = ""
           c-comp     = "".

    IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).

    IF  c-nro = "" THEN
        ASSIGN c-nro = "S/N".

    /*--- TRATAMENTO FONE - Sefaz aceita somente n£meros, e apenas 11 caracters -> DDD12345678 ---*/

    ASSIGN c-fone = "".

    DO  i-cont = 1 TO LENGTH(bf-emitente-est.telefone[1]):

        /* Nao considerar o primeiro zero do telefone, caso inicie com 0 (DDD iniciando com 0 ou nro de telefone incorreto) */
        IF  i-cont = 1
        AND LOOKUP(SUBSTRING(bf-emitente-est.telefone[1],i-cont,1),"0") > 0 THEN NEXT.

        IF  LOOKUP(SUBSTRING(bf-emitente-est.telefone[1],i-cont,1),"0,1,2,3,4,5,6,7,8,9") > 0 THEN
            ASSIGN c-fone = c-fone + SUBSTRING(bf-emitente-est.telefone[1],i-cont,1).
    END.
    /*---*/

    /* COD CNAE */
    FOR FIRST reg-inf-compl NO-LOCK
        WHERE reg-inf-compl.cod-tab-inform   = "estabelec":U
          AND reg-inf-compl.cod-campo-inform = "cod-cnae":U,
        FIRST inf-compl NO-LOCK
        WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
          AND inf-compl.cod-indice  = estabelec.cod-estabel:
        
    END. 
    /* FIM - COD CNAE */

    CREATE ttEmit.
    ASSIGN ttEmit.CEP        = STRING(estabelec.cep,"99999999")
           ttEmit.cMun       = STRING(IF  estabelec.pais = "Brasil":U
                                      THEN (IF AVAIL bf-cidade-est THEN bf-cidade-est.cdn-munpio-ibge ELSE 0)
                                      ELSE 9999999)
           ttEmit.CNAE       = IF AVAIL inf-compl THEN STRING(INTEGER(inf-compl.des-campo),">>>>>>>") ELSE ""
           ttEmit.CNAE       = (IF ttEmit.CNAE <> ?
                                 THEN ttEmit.CNAE
                                ELSE "")
           ttEmit.CNPJ       = estabelec.cgc
           ttEmit.cPais      = pais.cod-pais-siscomex
           ttEmit.CPF        = (IF ttEmit.CPF <> ?
                                 THEN ttEmit.CPF
                                ELSE "")
           ttEmit.fone       = c-fone
           ttEmit.IE         = estabelec.ins-estadual
           ttEmit.IE         = REPLACE(ttEmit.IE,"-","")
           ttEmit.IE         = REPLACE(ttEmit.IE,".","")
           ttEmit.IE         = REPLACE(ttEmit.IE,"/","")
           ttEmit.IE         = REPLACE(ttEmit.IE,"~\","")
           ttEmit.IE         = REPLACE(ttEmit.IE,",","")
           ttEmit.IE         = (IF ttEmit.IE <> ?
                                 THEN ttEmit.IE
                                ELSE "")
/*            ttEmit.IEST       = estab-uf.ins-estadual WHEN AVAIL estab-uf */
/*            ttEmit.IEST       = REPLACE(ttEmit.IEST,"-","")               */
/*            ttEmit.IEST       = REPLACE(ttEmit.IEST,".","")               */
/*            ttEmit.IEST       = REPLACE(ttEmit.IEST,"/","")               */
/*            ttEmit.IEST       = REPLACE(ttEmit.IEST,"~\","")              */
/*            ttEmit.IEST       = REPLACE(ttEmit.IEST,",","")               */
            ttEmit.IEST       = (IF ttEmit.IEST <> ?
                                 THEN ttEmit.IEST
                                ELSE "")                               
           ttEmit.IM         = estabelec.ins-municipal
           ttEmit.IM         = REPLACE(ttEmit.IM,"-","")
           ttEmit.IM         = REPLACE(ttEmit.IM,".","")
           ttEmit.IM         = REPLACE(ttEmit.IM,"/","")
           ttEmit.IM         = REPLACE(ttEmit.IM,"~\","")
           ttEmit.IM         = REPLACE(ttEmit.IM,",","")
           ttEmit.IM         = (IF ttEmit.IM <> ?
                                 THEN ttEmit.IM
                                ELSE "")
           ttEmit.nro        = c-nro
           ttEmit.UF         = estabelec.estado
           ttEmit.UF         = (IF ttEmit.UF <> ?
                                THEN ttEmit.UF
                                ELSE "")
           ttEmit.xBairro    = (IF estabelec.bairro <> ""
                                THEN estabelec.bairro
                                ELSE "Nao Informado")
           ttEmit.xCpl       = c-comp
           ttEmit.xFant      = bf-emitente-est.nome-abrev WHEN AVAIL bf-emitente-est
           ttEmit.xLgr       = c-rua
           ttEmit.xMun       = (IF estabelec.pais <> "Brasil":U
                                THEN "Exterior"
                                ELSE estabelec.cidade)
           ttEmit.xNome      = estabelec.nome
           ttEmit.xPais      = estabelec.pais
           ttEmit.VersaoLayout   = "1.01".

       
    /* Chave EMS */
    IF  AVAIL nota-fiscal THEN
        ASSIGN ttEmit.CodEstabelNF = nota-fiscal.cod-estabel
               ttEmit.SerieNF      = nota-fiscal.serie
               ttEmit.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttEmit THEN
        ASSIGN ttEmit.CEP        = fn-ajusta-tamanho-campo(ttEmit.CEP    , 8)
               ttEmit.cMun       = fn-ajusta-tamanho-campo(ttEmit.cMun   , 7)
               ttEmit.CNAE       = fn-ajusta-tamanho-campo(ttEmit.CNAE   , 7)
               ttEmit.CNPJ       = fn-ajusta-tamanho-campo(ttEmit.CNPJ   ,14)
               ttEmit.cPais      = fn-ajusta-tamanho-campo(ttEmit.cPais  , 4)
               ttEmit.CPF        = fn-ajusta-tamanho-campo(ttEmit.CPF    ,14)
               ttEmit.fone       = fn-ajusta-tamanho-campo(ttEmit.fone   ,10)
               ttEmit.IE         = fn-ajusta-tamanho-campo(ttEmit.IE     ,14)
               ttEmit.IEST       = fn-ajusta-tamanho-campo(ttEmit.IEST   ,14)
               ttEmit.IM         = fn-ajusta-tamanho-campo(ttEmit.IM     ,15)
               ttEmit.nro        = fn-ajusta-tamanho-campo(ttEmit.nro    ,60)
               ttEmit.UF         = fn-ajusta-tamanho-campo(ttEmit.UF     , 2)
               ttEmit.xBairro    = fn-ajusta-tamanho-campo(ttEmit.xBairro,60)
               ttEmit.xCpl       = fn-ajusta-tamanho-campo(ttEmit.xCpl   ,60)
               ttEmit.xFant      = fn-ajusta-tamanho-campo(ttEmit.xFant  ,60)
               ttEmit.xLgr       = fn-ajusta-tamanho-campo(ttEmit.xLgr   ,60)
               ttEmit.xMun       = fn-ajusta-tamanho-campo(ttEmit.xMun   ,60)
               ttEmit.xNome      = fn-ajusta-tamanho-campo(ttEmit.xNome  ,60)
               ttEmit.xPais      = fn-ajusta-tamanho-campo(ttEmit.xPais  ,60).

END PROCEDURE.

PROCEDURE pi-cria-ttDest:

    /*
    === ttDest ===
    CEP            AS CHARACTER INITIAL ?  /*CEP*/
    cMun           AS INT       INITIAL ?  /*C¢digo do munic°pio (utilizar a tabela do IBGE), informar 9999999 para operaá‰es com o exterior.*/
    CNPJ           AS CHARACTER INITIAL ?  /*N£mero do CNPJ*/
    cPais          AS INT       INITIAL ?  /*C¢digo do pa°s*/
    CPF            AS CHARACTER INITIAL ?  /*N£mero do CPF*/
    fone           AS CHARACTER INITIAL ?  /*Telefone*/
    IE             AS CHARACTER INITIAL ?  /*Inscriá∆o Estadual (obrigat¢rio nas operaá‰es com contribuintes do ICMS)*/
    ISUF           AS CHARACTER INITIAL ?  /*Inscriá∆o na SUFRAMA (Obrigat¢rio nas operaá‰es com as †reas com benef°cios de incentivos fiscais sob controle da SUFRAMA)*/
    nro            AS CHARACTER INITIAL ?  /*N£mero*/
    UF             AS CHARACTER INITIAL ?  /*Sigla da UF, , informar EX para operaá‰es com o exterior.*/
    xBairro        AS CHARACTER INITIAL ?  /*Bairro*/
    xCpl           AS CHARACTER INITIAL ?  /*Complemento*/
    xLgr           AS CHARACTER INITIAL ?  /*Logradouro*/
    xMun           AS CHARACTER INITIAL ?  /*Nome do munic°pio, , informar EXTERIOR para operaá‰es com o exterior.*/
    xNome          AS CHARACTER INITIAL ?  /*Raz∆o Social ou nome do destinat†rio*/
    xPais          AS CHARACTER INITIAL ?  /*Nome do pa°s*/
    */

    IF  i-natureza > 1 THEN DO:
        IF emitente.natureza = i-natureza THEN
            run pi-cria-ttDest-tp-pessoa(INPUT emitente.cep,
                                         INPUT emitente.pais,
                                         INPUT emitente.cgc,
                                         INPUT emitente.ins-estadual,
                                         INPUT emitente.estado,
                                         INPUT emitente.bairro,
                                         INPUT emitente.cidade,
                                         INPUT emitente.endereco,
                                         INPUT emitente.nome-emit).
        ELSE
            run pi-cria-ttDest-tp-pessoa(INPUT nota-fiscal.cep,         
                                         INPUT nota-fiscal.pais,        
                                         INPUT nota-fiscal.cgc,         
                                         INPUT nota-fiscal.ins-estadual,
                                         INPUT nota-fiscal.estado,      
                                         INPUT nota-fiscal.bairro,      
                                         INPUT nota-fiscal.cidade,      
                                         INPUT nota-fiscal.endereco,
                                         INPUT emitente.nome-emit).
    END.
    ELSE
        run pi-cria-ttDest-tp-pessoa(INPUT nota-fiscal.cep,         
                                     INPUT nota-fiscal.pais,        
                                     INPUT nota-fiscal.cgc,         
                                     INPUT nota-fiscal.ins-estadual,
                                     INPUT nota-fiscal.estado,      
                                     INPUT nota-fiscal.bairro,      
                                     INPUT nota-fiscal.cidade,      
                                     INPUT nota-fiscal.endereco,
                                     INPUT emitente.nome-emit).
            
    /* Chave EMS */
    ASSIGN ttDest.CodEstabelNF = nota-fiscal.cod-estabel
           ttDest.SerieNF      = nota-fiscal.serie
           ttDest.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttDest THEN
        ASSIGN ttDest.CEP        = fn-ajusta-tamanho-campo(ttDest.CEP    , 8)
               ttDest.cMun       = fn-ajusta-tamanho-campo(ttDest.cMun   , 7)
               ttDest.CNPJ       = fn-ajusta-tamanho-campo(ttDest.CNPJ   ,14)
               ttDest.cPais      = fn-ajusta-tamanho-campo(ttDest.cPais  , 4)
               ttDest.CPF        = fn-ajusta-tamanho-campo(ttDest.CPF    ,14)
               ttDest.fone       = fn-ajusta-tamanho-campo(ttDest.fone   ,10)
               ttDest.IE         = fn-ajusta-tamanho-campo(ttDest.IE     ,14)
               ttDest.ISUF       = fn-ajusta-tamanho-campo(ttDest.ISUF   ,14)
               ttDest.nro        = fn-ajusta-tamanho-campo(ttDest.nro    ,60)
               ttDest.UF         = fn-ajusta-tamanho-campo(ttDest.UF     , 2)
               ttDest.xBairro    = fn-ajusta-tamanho-campo(ttDest.xBairro,60)
               ttDest.xCpl       = fn-ajusta-tamanho-campo(ttDest.xCpl   ,60)
               ttDest.xLgr       = fn-ajusta-tamanho-campo(ttDest.xLgr   ,60)
               ttDest.xMun       = fn-ajusta-tamanho-campo(ttDest.xMun   ,60)
               ttDest.xNome      = fn-ajusta-tamanho-campo(ttDest.xNome  ,60)
               ttDest.xPais      = fn-ajusta-tamanho-campo(ttDest.xPais  ,60).

END PROCEDURE.

PROCEDURE pi-cria-ttEntrega:

    /*
    === ttEntrega ===
    cMun           AS INT       INITIAL ?  /*C¢digo do munic°pio (utilizar a tabela do IBGE)*/
    CNPJ           AS CHARACTER INITIAL ?  /*CNPJ*/
    nro            AS CHARACTER INITIAL ?  /*N£mero*/
    UF             AS CHARACTER INITIAL ?  /*Sigla da UF*/
    xBairro        AS CHARACTER INITIAL ?  /*Bairro*/
    xCpl           AS CHARACTER INITIAL ?  /*Complemento*/
    xLgr           AS CHARACTER INITIAL ?  /*Logradouro*/
    xMun           AS CHARACTER INITIAL ?  /*Nome do munic°pio*/
    */

    ASSIGN c-endereco = IF nota-fiscal.endereco <> "" THEN nota-fiscal.endereco ELSE emitente.endereco
           c-rua      = ""
           c-nro      = ""
           c-comp     = "".

    IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").

    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).

    IF  c-nro = "" THEN
        ASSIGN c-nro = "S/N".

    CREATE ttEntrega.

    IF  nota-fiscal.endereco <> "" THEN
        ASSIGN ttEntrega.CNPJ    = (IF nota-fiscal.pais <> "Brasil":U AND lLayoutXML
                                    THEN "00000000000000"
                                    ELSE IF nota-fiscal.pais <> "Brasil":U AND lLayoutTXT
                                    THEN ""
                                    ELSE  nota-fiscal.cgc)
               ttEntrega.nro     = c-nro
               ttEntrega.UF      = (IF nota-fiscal.pais <> "Brasil":U
                                    THEN "EX"
                                    ELSE nota-fiscal.estado)
               ttEntrega.UF      = (IF ttEntrega.UF <> ?
                                    THEN ttEntrega.UF
                                    ELSE "")
               ttEntrega.xBairro = (IF nota-fiscal.bairro <> ""
                                    THEN nota-fiscal.bairro
                                    ELSE "Nao Informado")
               ttEntrega.xCpl    = c-comp
               ttEntrega.xLgr    = c-rua
               ttEntrega.xMun    = (IF nota-fiscal.pais <> "Brasil":U
                                    THEN "Exterior"
                                    ELSE nota-fiscal.cidade).
    ELSE
        ASSIGN ttEntrega.CNPJ    = emitente.cgc
               ttEntrega.nro     = c-nro
               ttEntrega.UF      = (IF emitente.pais <> "Brasil":U
                                    THEN "EX"
                                    ELSE emitente.estado)
               ttEntrega.UF      = (IF ttEntrega.UF <> ?
                                    THEN ttEntrega.UF
                                    ELSE "")
               ttEntrega.xBairro = (IF emitente.bairro <> ""
                                    THEN emitente.bairro
                                    ELSE "Nao Informado")
               ttEntrega.xCpl    = c-comp
               ttEntrega.xLgr    = c-rua
               ttEntrega.xMun    = (IF emitente.pais <> "Brasil":U
                                    THEN "Exterior"
                                    ELSE emitente.cidade).

    ASSIGN     ttEntrega.CNPJ       =  REPLACE(ttEntrega.CNPJ,"-","")
               ttEntrega.CNPJ       =  REPLACE(ttEntrega.CNPJ,".","")
               ttEntrega.CNPJ       =  REPLACE(ttEntrega.CNPJ,"/","").

    IF (ttEntrega.xMun <> "Exterior"
    AND ttEntrega.xMun <> ""
    AND ttEntrega.xMun <> ?) THEN
        FOR FIRST bf-cidade-nf 
            WHERE bf-cidade-nf.cidade = ttEntrega.xMun
              AND bf-cidade-nf.estado = ttEntrega.UF
              AND bf-cidade-nf.pais   = "Brasil"   NO-LOCK:
    
            ASSIGN ttEntrega.cMun = STRING(bf-cidade-nf.cdn-munpio-ibge).
        END.
    ELSE
        ASSIGN ttEntrega.cMun = "9999999".

    /* Chave EMS */
    ASSIGN ttEntrega.CodEstabelNF = nota-fiscal.cod-estabel
           ttEntrega.SerieNF      = nota-fiscal.serie
           ttEntrega.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttEntrega THEN
        ASSIGN ttEntrega.cMun    = fn-ajusta-tamanho-campo(ttEntrega.cMun   , 7)
               ttEntrega.CNPJ    = fn-ajusta-tamanho-campo(ttEntrega.CNPJ   ,14)
               ttEntrega.nro     = fn-ajusta-tamanho-campo(ttEntrega.nro    ,60)
               ttEntrega.UF      = fn-ajusta-tamanho-campo(ttEntrega.UF     , 2)
               ttEntrega.xBairro = fn-ajusta-tamanho-campo(ttEntrega.xBairro,60)
               ttEntrega.xCpl    = fn-ajusta-tamanho-campo(ttEntrega.xCpl   ,60)
               ttEntrega.xLgr    = fn-ajusta-tamanho-campo(ttEntrega.xLgr   ,60)
               ttEntrega.xMun    = fn-ajusta-tamanho-campo(ttEntrega.xMun   ,60).
 
END PROCEDURE.

PROCEDURE pi-cria-ttExporta:

    /*
    === ttExporta ===
     UFEmbarq       AS CHARACTER INITIAL ?    /*Sigla da UF onde ocorrer† o embarque dos produtos*/
     xLocEmbarq     AS CHARACTER INITIAL ?    /*Local onde ocorrer† o embarque dos produtos*/     
    /*Chave EMS*/                                                                                      
     CodEstabelNF   AS CHARACTER INITIAL ?                                                        
     SerieNF        AS CHARACTER INITIAL ?                                                        
     NrNotaFisNF    AS CHARACTER INITIAL ?    
    */

    FIND FIRST param-global NO-LOCK NO-ERROR.

    /* MODULO DE EXPORTAÄ«O IMPLANTADO */
    IF  CONNECTED("mgcex":U)
    AND param-global.modulo-ex THEN DO:

        FOR FIRST proc-nota-fiscal NO-LOCK
            WHERE proc-nota-fiscal.cod-estabel = nota-fiscal.cod-estab-proces-export
              AND proc-nota-fiscal.nr-nota-fis = nota-fiscal.nr-nota-fis
              AND proc-nota-fiscal.nr-proc-exp = nota-fiscal.nr-proc-exp
              AND proc-nota-fiscal.cod-estab-faturam = nota-fiscal.cod-estabel
              AND proc-nota-fiscal.serie = nota-fiscal.serie,
            FIRST processo-exp
            WHERE processo-exp.cod-estabel = proc-nota-fiscal.cod-estabel
              AND processo-exp.nr-proc-exp = proc-nota-fiscal.nr-proc-exp,
            FIRST historico-proc-exp NO-LOCK
            WHERE historico-proc-exp.cod-estabel = processo-exp.cod-estabel
              AND historico-proc-exp.nr-proc-exp = processo-exp.nr-proc-exp
              AND historico-proc-exp.cod-itiner = processo-exp.cod-itiner
              AND historico-proc-exp.cod-pto-contr = processo-exp.pto-embarque,
            FIRST itinerario OF historico-proc-exp NO-LOCK,
            FIRST pto-contr NO-LOCK
            WHERE pto-contr.cod-pto-contr = itinerario.pto-embarque:
                CREATE ttExporta.
                ASSIGN ttExporta.CodEstabelNF = nota-fiscal.cod-estabel
                       ttExporta.SerieNF = nota-fiscal.serie
                       ttExporta.NrNotaFisNF = nota-fiscal.nr-nota-fis
                       ttExporta.UFEmbarq = IF historico-proc-exp.cod-uf <> "" THEN historico-proc-exp.cod-uf ELSE string(pto-contr.cod-uf)
                       ttExporta.xLocEmbarq = IF historico-proc-exp.descricao <> "" THEN historico-proc-exp.descricao ELSE pto-contr.descricao.
        END.
    END.
    ELSE DO:

        /* MODULO DE EXPORTAÄ«O N«O IMPLANTADO E FUNCAO ATIVA */
        IF  CAN-FIND(FIRST funcao 
                     WHERE funcao.cd-funcao = "spp-NFE-sem-modulo-MEX"
                     AND   funcao.ativo = YES) THEN DO:
    
            IF  nota-fiscal.nat-operacao BEGINS "7" 
            AND nota-fiscal.cod-rota <> "" THEN DO:
    
                FOR FIRST emitente NO-LOCK 
                    WHERE emitente.nome-abrev = nota-fiscal.nome-ab-cli
                    AND   (   i-natureza = 3
                           OR i-natureza = 4):
    
                    FOR FIRST rota NO-LOCK
                        WHERE rota.cod-rota = nota-fiscal.cod-rota:
    
                        CREATE ttExporta.
                        ASSIGN ttExporta.CodEstabelNF  = nota-fiscal.cod-estabel
                               ttExporta.SerieNF       = nota-fiscal.serie
                               ttExporta.NrNotaFisNF   = nota-fiscal.nr-nota-fis
                               ttExporta.UFEmbarq      = substring(rota.roteiro,1,2)
                               ttExporta.xLocEmbarq    = rota.descricao.
                    END.
                END.
            END.
        END.
    END.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttExporta THEN
        ASSIGN ttExporta.UFEmbarq   = fn-ajusta-tamanho-campo(ttExporta.UFEmbarq  , 2)
               ttExporta.xLocEmbarq = fn-ajusta-tamanho-campo(ttExporta.xLocEmbarq,60).

END PROCEDURE.

PROCEDURE pi-cria-ttDI:

    /*
    === ttDI ===
    cExportador    AS CHARACTER INITIAL ?  /*C¢digo do exportador (usado nos sistemas internos de informaá∆o do emitente da NF-e)*/
    dDesemb        AS DATE      INITIAL ?  /*Data do desembaraáo aduaneiro (AAAA-MM-DD)*/
    dDI            AS DATE      INITIAL ?  /*Data de registro da DI/DSI/DA (AAAA-MM-DD)*/
    nDI            AS CHARACTER INITIAL ?  /*Numero do Documento de Importaá∆o DI/DSI/DA (DI/DSI/DA)*/
    UFDesemb       AS CHARACTER INITIAL ?  /*UF onde ocorreu o desembaraáo aduaneiro*/
    xLocDesemb     AS CHARACTER INITIAL ?  /*Local do desembaraáo aduaneiro*/
    CodEstabelNF   AS CHARACTER INITIAL ?
    SerieNF        AS CHARACTER INITIAL ?
    NrNotaFisNF    AS CHARACTER INITIAL ?
    */

   FOR FIRST docto-estoq-nfe-imp NO-LOCK
       WHERE docto-estoq-nfe-imp.cod-ser-docto    = nota-fiscal.serie
         AND docto-estoq-nfe-imp.cod-docto        = nota-fiscal.nr-nota-ant 
         AND docto-estoq-nfe-imp.cdn-emitente     = nota-fiscal.cod-emitente
         AND docto-estoq-nfe-imp.cod-natur-operac = nota-fiscal.nat-operacao:
   
         CREATE ttDI.
         ASSIGN ttDI.nDI         = docto-estoq-nfe-imp.des-decla-import
                ttDI.dDI         = docto-estoq-nfe-imp.dat-decla-import
                ttDI.dDesemb     = docto-estoq-nfe-imp.dat-desembarac 
                ttDI.xLocDesemb  = docto-estoq-nfe-imp.des-descr-gener
                ttDI.UFDesemb    = docto-estoq-nfe-imp.cod-uf 
                ttDI.cExportador = string(docto-estoq-nfe-imp.cdn-expdor).
   
         ASSIGN ttDI.nDI = REPLACE(ttDI.nDI,"-","")
                ttDI.nDI = REPLACE(ttDI.nDI,".","")
                ttDI.nDI = REPLACE(ttDI.nDI,"/","")
                ttDI.nDI = REPLACE(ttDI.nDI,"~\","")
                ttDI.nDI = REPLACE(ttDI.nDI,",","").
         /* Chave EMS */
         ASSIGN ttDI.CodEstabelNF = nota-fiscal.cod-estabel
                ttDI.SerieNF      = nota-fiscal.serie
                ttDI.NrNotaFisNF  = nota-fiscal.nr-nota-fis.
   END.


END PROCEDURE.

PROCEDURE pi-cria-ttDet:

    /*
    === ttDet ===
    cEAN           AS CHARACTER INITIAL ?  /*GTIN (Global Trade Item Number) do produto, antigo c¢digo EAN ou c¢digo de barras*/
    cEANTrib       AS CHARACTER INITIAL ?  /*GTIN (Global Trade Item Number) da unidade tribut†vel, antigo c¢digo EAN ou c¢digo de barras*/
    CFOP           AS CHARACTER INITIAL ?  /*C¢digo Fiscal de Operaá‰es e Prestaá‰es*/
    cProd          AS CHARACTER INITIAL ?  /*C¢digo do produto ou serviáo. Preencher com CFOP caso se trate de itens n∆o relacionados com mercadorias/produto e que o contribuinte n∆o possua codificaá∆o pr¢pria Formato îCFOP9999î.*/
    EXTIPI         AS CHARACTER INITIAL ?  /*C¢digo EX TIPI (3 posiá‰es)*/
    genero         AS CHARACTER INITIAL ?  /*Gànero do produto ou serviáo. Preencher de acordo com a Tabela de Cap°tulos da NCM. Em caso de serviáo, n∆o incluir a TAG.*/
    infAdProd      AS CHARACTER INITIAL ?  /*Informaá‰es adicionais do produto (norma referenciada, informaá‰es complementares, etc)*/
    NCM            AS CHARACTER INITIAL ?  /*C¢digo NCM (8 posiá‰es)*/
    nSerie         AS CHARACTER INITIAL ?  /*Serial (sÇrie)*/
    pesoB          AS CHARACTER INITIAL ?  /*Peso bruto*/
    pesoL          AS CHARACTER INITIAL ?  /*Peso l°quido*/
    qCom           AS DECIMAL   INITIAL ?  /*Quantidade Comercial*/
    qTrib          AS DECIMAL   INITIAL ?  /*Quantidade Tribut†vel*/
    uCom           AS CHARACTER INITIAL ?  /*Unidade comercial*/
    uTrib          AS CHARACTER INITIAL ?  /*Unidade Tribut†vel*/
    vDesc          AS DECIMAL   INITIAL ?  /*Valor do Desconto*/
    vFrete         AS DECIMAL   INITIAL ?  /*Valor Total do Frete*/
    vProd          AS DECIMAL   INITIAL ?  /*Valor bruto do produto ou serviáo*/
    vSeg           AS DECIMAL   INITIAL ?  /*Valor Total do Seguro*/
    vUnCom         AS DECIMAL   INITIAL ?  /*Valor unit†rio de comercializaá∆o*/
    vUnTrib        AS DECIMAL   INITIAL ?  /*Valor unit†rio de tributaá∆o*/
    xProd          AS CHARACTER INITIAL ?  /*Descriá∆o do produto ou serviáo*/
    */

    DEFINE VARIABLE de-vlPrecoUnitario AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE de-vlMercadoria    AS DECIMAL     NO-UNDO.

    FOR FIRST bf-natur-oper-it NO-LOCK
        WHERE bf-natur-oper-it.nat-operacao = it-nota-fisc.nat-operacao:
    END.

    /*ICMS Outras*/
    ASSIGN l-icms-outras-it = bf-natur-oper-it.log-consid-icms-outras.
    /*ICMS Outras*/


    
    FOR FIRST item-mat 
        WHERE item-mat.it-codigo = it-nota-fisc.it-codigo NO-LOCK:
    END.
    IF  AVAIL item-mat THEN
        ASSIGN c-cod-ean = SUBSTR(item-mat.cod-ean,1,14). /* SEFAZ -> mˇx 14 posiªÑes */
    
    ASSIGN c-desc-prod = "".
    
    RUN pi-narrativa-item.

    RUN pi-calc-zona-franca.

    IF  l-funcao-preco-bruto-nfe THEN DO: /* valor bruto */
        ASSIGN de-vlPrecoUnitario = it-nota-fisc.vl-preori
               de-vlMercadoria    = it-nota-fisc.vl-merc-ori.
    END.
    ELSE DO: /* valor liquido */
        ASSIGN de-vlPrecoUnitario = it-nota-fisc.vl-preuni
               de-vlMercadoria    = it-nota-fisc.vl-merc-liq.
    END.

    CREATE ttDet.
    ASSIGN ttDet.cEAN      = c-cod-ean
           ttDet.cEANTrib  = c-cod-ean
           ttDet.CFOP      = (&if defined(bf_dis_formato_CFOP)
                              &then bf-natur-oper-it.cod-cfop
                              &else SUBSTR(bf-natur-oper-it.char-1,45,10) &endif) WHEN AVAIL bf-natur-oper-it
           ttDet.CFOP      = (IF ttDet.CFOP <> "" AND ttDet.CFOP <> ?
                              THEN ttDet.CFOP 
                              ELSE "1101") /* Conforme mapas Neogrid */
           ttDet.cProd     = (IF it-nota-fisc.it-codigo <> ""
                              THEN it-nota-fisc.it-codigo
                              ELSE &if defined(bf_dis_formato_CFOP)
                                   &then "CFOP" + bf-natur-oper-it.cod-cfop
                                   &else "CFOP" + SUBSTR(bf-natur-oper-it.char-1,45,10) &endif) WHEN AVAIL bf-natur-oper-it
           ttDet.cProd     = (IF ttDet.cProd <> "" AND ttDet.cProd <> ?
                              THEN ttDet.cProd
                              ELSE ttDet.CFOP)
           ttDet.EXTIPI    = STRING(item.dec-1,"99")
           ttDet.genero    = SUBSTR(it-nota-fisc.class-fiscal,1,2)
           ttDet.infAdProd = (IF  (item.ind-imp-desc = 4 or item.ind-imp-desc = 7 or item.ind-imp-desc = 9) AND AVAIL nar-it-nota THEN nar-it-nota.narrativa ELSE "")
           ttDet.NCM       = it-nota-fisc.class-fiscal

           /* ttDet.infAdProd */
           ttDet.infAdProd = REPLACE(ttDet.infAdProd, CHR(10), " ")
           ttDet.infAdProd = REPLACE(ttDet.infAdProd, CHR(13), " ")
           ttDet.infAdProd = REPLACE(ttDet.infAdProd, CHR(9), " ")
           ttDet.infAdProd = fn-ajusta-espacos-branco(ttDet.infAdProd)
           
           /*
           it-nota-fisc.ind-fat-qtfam = no  -> Fatura na Unidade do Item
           it-nota-fisc.ind-fat-qtfam = yes -> Fatura na Unidade da Familia
           it-nota-fisc.ind-fat-qtfam = ?   -> Fatura na Unidade do Cliente
           */
           /*--- TRIBUTµVEL ---*/
           ttDet.qTrib     = it-nota-fisc.qt-faturada[1] /* QTD Item */
           ttDet.uTrib     = trim(it-nota-fisc.un-fatur[1]) /*Unid Med Item*/
           ttDet.vUnTrib   =  IF  de-vl-unit-trib  <> ? AND de-vl-unit-trib  <> 0 
                                  THEN de-vl-unit-trib 
                                  ELSE (IF  it-nota-fisc.ind-fat-qtfam = NO 
                                            THEN de-vlPrecoUnitario
                                            ELSE IF it-nota-fisc.qt-faturada[1] = 0 
                                                    THEN  de-vlMercadoria
                                                    ELSE (de-vlMercadoria / it-nota-fisc.qt-faturada[1]))
           /*--- COMERCIAL  ---*/
           ttDet.qCom      = (IF it-nota-fisc.ind-fat-qtfam = no 
                              THEN it-nota-fisc.qt-faturada[1]
                              ELSE it-nota-fisc.qt-faturada[2])
           ttDet.uCom      = (IF it-nota-fisc.ind-fat-qtfam = no
                              THEN trim(it-nota-fisc.un-fatur[1])
                              ELSE trim(it-nota-fisc.un-fatur[2]))
           ttDet.vUnCom    = IF de-vl-unit  <> ? AND de-vl-unit  <> 0 
                                THEN de-vl-unit 
                                ELSE (IF it-nota-fisc.ind-fat-qtfam = NO 
                                         THEN de-vlPrecoUnitario 
                                         ELSE IF it-nota-fisc.qt-faturada[2] = 0 
                                                 THEN  de-vlMercadoria 
                                                 ELSE (de-vlMercadoria / it-nota-fisc.qt-faturada[2]))
           ttDet.vFrete    = (IF it-nota-fisc.vl-frete-it > 0 THEN it-nota-fisc.vl-frete-it ELSE ?)
           ttDet.vProd     = IF de-vl-total <> ? AND de-vl-total <> 0 THEN de-vl-total ELSE de-vlMercadoria /*it-nota-fisc.vl-tot-item - it-nota-fisc.vl-ipi-it*/ /* Desconta valor do IPI, pois o validador TXT realiza a soma */ 
           de-vProdTotal   = de-vProdTotal + ttDet.vProd
           /*ttDet.vSeg      =*/
           ttDet.xProd     = IF (    nota-fiscal.ind-tip-nota    = 4 
                                 AND it-nota-fisc.qt-faturada[1] = 0 
                                 AND item.ind-imp-desc          <> 7  /* Narrativa Informada */ ) 
                                 THEN "Complementar de Imposto" ELSE c-desc-prod 
           ttDet.xProd     = IF (nota-fiscal.ind-tip-nota = 8 AND it-nota-fisc.qt-faturada[1] = 0 AND bf-natur-oper-nf.nota-rateio) THEN "Complementar" ELSE ttDet.xProd.

    IF  CAN-FIND (funcao WHERE funcao.cd-funcao = "SPP-DESCONTO-NFE":U AND funcao.ativo) 
        AND INT(SUBSTRING(bf-natur-oper-nf.char-2,11,5)) = 2 THEN  /* base calculo IPI = 2 (Liquido) */
        ASSIGN ttDet.vDesc     = 0.
    ELSE
        /* Alterado para pegar it-nota-fisc.val-desconto-total pois o desconto total da nota est† buscando do campo  */
        /* nota-fiscal.val-desconto-total,e do item da nota fiscal (it-nota-fisc) busca o campo vl-desconto,         */
        /* e a somat¢ria do it-nota-fisc.vl-desconto n∆o bate com o total (nota-fiscal.val-desconto-total).          */
        /* Validaá∆o SEFAZ (v2.0): SOMATORIO(ttDet.vDesc) = ttICMSTot.vDesc                                          */
        /*ASSIGN ttDet.vDesc     = (IF it-nota-fisc.vl-desconto > 0 THEN it-nota-fisc.vl-desconto ELSE ?).*/
        ASSIGN ttDet.vDesc     = (IF it-nota-fisc.val-desconto-total > 0 THEN it-nota-fisc.val-desconto-total ELSE ?).

    IF  lLayoutTXT 
    AND ttDet.vDesc = 0 THEN
        ASSIGN ttDet.vDesc  = ?.

    /* Chave EMS */
    ASSIGN ttDet.CodEstabelNF = nota-fiscal.cod-estabel
           ttDet.SerieNF      = nota-fiscal.serie
           ttDet.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttDet.ItCodigoNF   = it-nota-fisc.it-codigo
           ttDet.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttDet THEN DO:
        ASSIGN /*tDet.cProd     = fn-ajusta-espacos-branco(ttDet.cProd)   Comentado em 31/03/2009 - MANGOTEX */
               ttDet.xProd     = REPLACE(ttDet.xProd, CHR(10), " ")
               ttDet.xProd     = REPLACE(ttDet.xProd, CHR(13), " ")
               ttDet.xProd     = REPLACE(ttDet.xProd, CHR(9), " ")
               ttDet.cEAN      = fn-ajusta-tamanho-campo(ttDet.cEAN     , 14)
               ttDet.cEANTrib  = fn-ajusta-tamanho-campo(ttDet.cEANTrib , 14)
               ttDet.CFOP      = fn-ajusta-tamanho-campo(ttDet.CFOP     ,  4)
               ttDet.cProd     = fn-ajusta-tamanho-campo(ttDet.cProd    , 60)
               ttDet.EXTIPI    = fn-ajusta-tamanho-campo(ttDet.EXTIPI   ,  3)
               ttDet.genero    = fn-ajusta-tamanho-campo(ttDet.genero   ,  2)
               ttDet.infAdProd = fn-ajusta-tamanho-campo(ttDet.infAdProd,500)
               ttDet.NCM       = fn-ajusta-tamanho-campo(ttDet.NCM      ,  8)
               ttDet.xProd     = fn-ajusta-tamanho-campo(ttDet.xProd    ,120)
               ttDet.xProd     = fn-ajusta-espacos-branco(ttDet.xProd)
               ttDet.infAdProd = fn-ajusta-espacos-branco(ttDet.infAdProd).
        IF  INDEX(ttDet.xProd,ttDet.infAdProd) > 0 THEN
            ASSIGN ttDet.infAdProd = "".
    END.

END PROCEDURE.

PROCEDURE pi-narrativa-item:

    /*------  PESQUISA A DESCRICAO DO PRODUTO  ------ */

    DEF VAR c-info-onu AS CHARACTER FORMAT "x(256)" NO-UNDO.
              
    if item.ind-imp-desc = 1 then /* Descriá∆o */
        assign c-desc-prod = item.desc-item.
    
    if  item.ind-imp-desc = 2           /* Descriá∆o + Narrativa */
    or  item.ind-imp-desc = 5           /* Narrativa Item */
    or  item.ind-imp-desc = 6           /* Uma Linha Narrativa */
    or  item.ind-imp-desc = 10 then do: /* Descriá∆o + 24 Narrativa Item */
    
        if  item.ind-imp-desc = 2
        or  item.ind-imp-desc = 10 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find narrativa of item no-lock no-error.
    
        if avail narrativa then 
           assign c-desc-prod = c-desc-prod +
                                if  item.ind-imp-desc = 6 then
                                    trim(entry(1,substring(narrativa.descricao,1,76),chr(10)))
                                else if item.ind-imp-desc = 10 then
                                    trim(entry(1,substring(narrativa.descricao,1,24),chr(10)))
                                else                        
                                    narrativa.descricao.
    end.
    
    if  item.ind-imp-desc = 3          /* Descriá∆o + Narrativa Item/Cliente */
    or  item.ind-imp-desc = 8 then do: /* Descriá∆o + 24 Narrativa Item/Cliente */
        find item-cli
             where item-cli.nome-abrev = nota-fiscal.nome-ab-cli
             and   item-cli.it-codigo  = it-nota-fisc.it-codigo
             no-lock no-error.
    
        assign c-desc-prod = item.desc-item + " ".
    
        if  avail item-cli then
            assign c-desc-prod = c-desc-prod +
                                 if item.ind-imp-desc = 3 then          
                                    item-cli.narrativa
                                 else
                                    trim(entry(1,substring(item-cli.narrativa,1,24),chr(10))).
    end.
    
    if  item.ind-imp-desc = 4            /* Descriá∆o + Narrativa Informada */
    or  item.ind-imp-desc = 7            /* Narrativa Informada */
    or  item.ind-imp-desc = 9 then do:   /* Descriá∆o + 24 Narrativa Informada */
    
        if  item.ind-imp-desc = 4
        or  item.ind-imp-desc = 9 then
            assign c-desc-prod = item.desc-item + " ".
        else 
            assign c-desc-prod = "".
    
        find nar-it-nota
             where nar-it-nota.cod-estabel  = it-nota-fisc.cod-estabel
             and   nar-it-nota.serie        = it-nota-fisc.serie
             and   nar-it-nota.nr-nota-fis  = it-nota-fisc.nr-nota-fis
             and   nar-it-nota.nr-sequencia = it-nota-fisc.nr-seq-fat
             and   nar-it-nota.it-codigo    = it-nota-fisc.it-codigo
             no-lock no-error.
    
        if avail nar-it-nota then 
           assign c-desc-prod = c-desc-prod +
                                if item.ind-imp-desc = 9 then
                                   trim(entry(1,substring(nar-it-nota.narrativa,1,24),chr(10)))
                                else
                                   nar-it-nota.narrativa.
    end.

    FOR FIRST item-dist                                                                                        
        WHERE item-dist.it-codigo = item.it-codigo NO-LOCK:                                                    
        IF item-dist.cdn-onu <> 0 THEN                                                                         
            ASSIGN c-info-onu = c-info-onu + " ONU: " + STRING(item-dist.cdn-onu) + " CLASSE: " + item-dist.cod-class-risco.
        IF item-dist.cod-grp-embal <> "" THEN                                                                  
            ASSIGN c-info-onu = c-info-onu + " GE: " + item-dist.cod-grp-embal.                                             
        IF item-dist.nom-apropdo-embal <> "" THEN                                                              
            ASSIGN c-info-onu = c-info-onu + " Nome AE: " + item-dist.nom-apropdo-embal.                                    
        IF item-dist.des-pto-fulgor <> "" THEN                                                                 
            ASSIGN c-info-onu = c-info-onu + " Ponto Fulgor: " + item-dist.des-pto-fulgor.                                  
                                                                                                               
    END.                                                                                                       
                                                                                                               
    IF c-info-onu <> "" THEN                                                                                   
        ASSIGN c-desc-prod = c-desc-prod + " (" + TRIM(c-info-onu) + ") ".                                          

                                                                                    
END PROCEDURE.

PROCEDURE pi-cria-ttAdi:

    /*
    === ttAdi ===
    cFabricante    AS CHARACTER INITIAL ?  /*C¢digo do fabricante estrangeiro (usado nos sistemas internos de informaá∆o do emitente da NF-e)*/
    nAdicao        AS CHARACTER INITIAL ?  /*N£mero da Adiá∆o*/
    nSeqAdic       AS CHARACTER INITIAL ?  /*N£mero seqÅencial do item dentro da Adiá∆o*/
    vDescDI        AS DECIMAL   INITIAL ?  /*Valor do desconto do item da DI - adiá∆o*/
    nDI            AS CHARACTER INITIAL ?  /*campo para ligaá∆o com a ttDI*/
    CodEstabelNF   AS CHARACTER INITIAL ?
    SerieNF        AS CHARACTER INITIAL ?
    NrNotaFisNF    AS CHARACTER INITIAL ?
    ItCodigoNF     AS CHARACTER INITIAL ?
    NrSeqFatNF     AS INTEGER   INITIAL ?
    */

    FOR FIRST docto-estoq-nfe-imp NO-LOCK
        WHERE docto-estoq-nfe-imp.cod-ser-docto    = nota-fiscal.serie 
        AND   docto-estoq-nfe-imp.cod-docto        = nota-fiscal.nr-nota-ant
        AND   docto-estoq-nfe-imp.cdn-emitente     = nota-fiscal.cod-emitente
        AND   docto-estoq-nfe-imp.cod-natur-operac = nota-fiscal.nat-operacao:

          FOR EACH  item-docto-estoq-nfe-imp NO-LOCK 
              WHERE item-docto-estoq-nfe-imp.cdn-emitente     = docto-estoq-nfe-imp.cdn-emitente     
              AND   item-docto-estoq-nfe-imp.cod-docto        = docto-estoq-nfe-imp.cod-docto        
              AND   item-docto-estoq-nfe-imp.cod-ser-docto    = docto-estoq-nfe-imp.cod-ser-docto    
              AND   item-docto-estoq-nfe-imp.cod-natur-operac = docto-estoq-nfe-imp.cod-natur-operac
              and   item-docto-estoq-nfe-imp.num-seq          = it-nota-fisc.nr-seq-ped : /*na leitura deve usar o seq-ped, pois o recebimento pode estar de 1 em 1 a seq do item*/
              
              /* Chave EMS */
              CREATE ttAdi.
              ASSIGN ttAdi.CodEstabelNF = nota-fiscal.cod-estabel
                     ttAdi.SerieNF      = nota-fiscal.serie
                     ttAdi.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                     ttAdi.ItCodigoNF   = it-nota-fisc.it-codigo    
                     ttAdi.NrSeqFatNF   = it-nota-fisc.nr-seq-fat /*para criar a ttII ele deve usar o seq-fat */ .              
    
             
              /* Chave para a ttDI */
              ASSIGN ttAdi.nDI          = docto-estoq-nfe-imp.des-decla-import.
    
              ASSIGN ttAdi.nAdicao      = string(item-docto-estoq-nfe-imp.num-adic)
                     ttAdi.nSeqAdic     = string(item-docto-estoq-nfe-imp.num-seq-import)
                     ttAdi.cFabricante  = string(item-docto-estoq-nfe-imp.cdn-expdor)
                     ttAdi.vDescDI      = item-docto-estoq-nfe-imp.val-desc.

              ASSIGN ttAdi.nDI = REPLACE(ttAdi.nDI,"-","")
                     ttAdi.nDI = REPLACE(ttAdi.nDI,".","")
                     ttAdi.nDI = REPLACE(ttAdi.nDI,"/","")
                     ttAdi.nDI = REPLACE(ttAdi.nDI,"~\","")
                     ttAdi.nDI = REPLACE(ttAdi.nDI,",","").

          END. 
    END.
    
END PROCEDURE.

PROCEDURE pi-cria-ICMS:

    DEFINE VARIABLE  i-codigo-orig AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-codigo-orig-estab AS INTEGER INIT ? NO-UNDO.


    ASSIGN i-niv-trib-icms = 0
           c-niv-trib-icms = "".

    RUN ftp/ft0515a.p (INPUT  ROWID(it-nota-fisc), 
                       OUTPUT i-niv-trib-icms,      
                       OUTPUT l-sub).

    if not avail ttEmit then
       find first ttEmit no-error.

    IF AVAIL ttEmit AND 
             l-sub AND (ttEmit.IEST = ? OR ttEmit.IEST = "") THEN do:

          assign ttEmit.IEST       = estab-uf.ins-estadual WHEN AVAIL estab-uf
                   ttEmit.IEST = REPLACE(ttEmit.IEST,"-","")
                   ttEmit.IEST = REPLACE(ttEmit.IEST,".","")
                   ttEmit.IEST = REPLACE(ttEmit.IEST,"/","")
                   ttEmit.IEST = REPLACE(ttEmit.IEST,"~\","")
                   ttEmit.IEST = REPLACE(ttEmit.IEST,",","")
                   ttEmit.IEST = (IF ttEmit.IEST <> ?
                                   THEN ttEmit.IEST
                                  ELSE "")
                   ttEmit.IEST = fn-ajusta-tamanho-campo(ttEmit.IEST,14).
    end.

    FIND FIRST item-uni-estab NO-LOCK
         WHERE item-uni-estab.it-codigo   = it-nota-fisc.it-codigo
           AND item-uni-estab.cod-estabel = it-nota-fisc.cod-estabel NO-ERROR.
    IF AVAILABLE item-uni-estab THEN DO:
    
        IF &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN 
           TRIM(STRING(item-uni-estab.num-origem))
           &ELSE 
           TRIM(SUBSTRING(item-uni-estab.char-2,18,3)) &ENDIF
           <> "":U THEN DO:
    
            &IF "{&bf_dis_versao_ems}" >= "2.09" &THEN
                ASSIGN i-codigo-orig-estab = item-uni-estab.num-origem.
            &ELSE
                ASSIGN i-codigo-orig-estab = INT(TRIM(SUBSTRING(item-uni-estab.char-2,18,3))).
            &ENDIF
        END.
    END.    

    &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
        ASSIGN i-codigo-orig = IF  it-nota-fisc.num-origem <> ? THEN  
                                   it-nota-fisc.num-origem.  
                               ELSE IF i-codigo-orig-estab <> ? THEN
                                       i-codigo-orig-estab
                                    ELSE ITEM.codigo-orig.
    &ELSE
        IF  SUBSTRING(it-nota-fisc.char-1,180,3) <> "" THEN
        ASSIGN i-codigo-orig = INT(SUBSTRING(it-nota-fisc.char-1,180,3)).
    ELSE
        ASSIGN i-codigo-orig = IF i-codigo-orig-estab <> ? THEN
                                  i-codigo-orig-estab
                               ELSE ITEM.codigo-orig.

    &ENDIF

    /* CST -> Codigo da Situacao Tributaria (conforme DANFE): Codigo Origem + Nivel Tributacao ICMS */
    ASSIGN i-niv-trib-icms = INT(STRING(i-codigo-orig) + STRING(i-niv-trib-icms, "99")) WHEN AVAIL item
           c-niv-trib-icms = string(i-niv-trib-icms,"999").

    ASSIGN c-mod-base-icms    = string(it-nota-fisc.idi-modalid-base-icms)
           c-mod-base-icms-st = string(it-nota-fisc.idi-modalid-base-icms-st).
                                 
    ASSIGN d-aliquota-icms  = 0
           d-vl-imp-icms    = 0
           d-vl-imp-icmsou  = 0
           d-perc-redimp    = 0
           d-vl-bicms-it    = 0.
                                 
    IF  i-pais-impto-usuario <> 1 THEN DO: /* Internacional */
    
        FOR EACH it-nota-imp NO-LOCK
           WHERE it-nota-imp.cod-estabel = it-nota-fisc.cod-estabel 
             AND it-nota-imp.serie       = it-nota-fisc.serie       
             AND it-nota-imp.nr-nota-fis = it-nota-fisc.nr-nota-fis 
             AND it-nota-imp.nr-seq-fat  = it-nota-fisc.nr-seq-fat
             AND it-nota-imp.it-codigo   = it-nota-fisc.it-codigo:
    
            ASSIGN d-aliquota-icms = d-aliquota-icms + it-nota-imp.aliquota
                   d-vl-imp-icms   = d-vl-imp-icms   + it-nota-imp.vl-imposto
                   d-perc-redimp   = d-perc-redimp   + it-nota-imp.perc-redimp
                   d-vl-bicms-it   = d-vl-bicms-it   + it-nota-imp.vl-base-imp.
        END.
    END.
    ELSE
        ASSIGN d-aliquota-icms = it-nota-fisc.aliquota-icm
               d-vl-imp-icms   = it-nota-fisc.vl-icms-it
               d-vl-imp-icmsou = it-nota-fisc.vl-icmsou-it
               d-perc-redimp   = it-nota-fisc.perc-red-icm
               d-vl-bicms-it   = it-nota-fisc.vl-bicms-it.

    CASE SUBSTRING(c-niv-trib-icms,2,2):

        WHEN "10" THEN
            RUN pi-grava-ttICMS10.

        WHEN "20" THEN
            RUN pi-grava-ttICMS20.

        WHEN "30" THEN
            RUN pi-grava-ttICMS30.

        WHEN "40" OR 
        WHEN "41" OR
        WHEN "50" THEN
            RUN pi-grava-ttICMS40.

        WHEN "51" THEN
            RUN pi-grava-ttICMS51.

        WHEN "60" THEN
            RUN pi-grava-ttICMS60.

        WHEN "70" THEN
            RUN pi-grava-ttICMS70.

        WHEN "90" THEN
            RUN pi-grava-ttICMS90.

        OTHERWISE
            RUN pi-grava-ttICMS00.
    END CASE.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS10:

    /*
    === ttICMS10 ===
    CST            AS CHARACTER INITIAL ?  /*10 - Tributada e com cobranáa do ICMS por substituiá∆o tribut†ria */
    modBC          AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o */
    modBCST        AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor) */
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMS          AS DECIMAL   INITIAL ?  /*Al°quota do ICMS*/
    pICMSST        AS DECIMAL   INITIAL ?  /*Al°quota do ICMS ST*/
    pMVAST         AS DECIMAL   INITIAL ?  /*Percentual da Margem de Valor Adicionado ICMS ST*/
    pRedBCST       AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC ICMS ST */
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS*/
    vBCST          AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS ST*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
    vICMSST        AS DECIMAL   INITIAL ?  /*Valor do ICMS ST*/
    */

    FOR FIRST item-nf-adc NO-LOCK
        WHERE item-nf-adc.cod-estab             = it-nota-fisc.cod-estabel
        AND   item-nf-adc.cod-serie             = it-nota-fisc.serie
        AND   item-nf-adc.cod-nota-fisc         = it-nota-fisc.nr-nota-fis
        AND   item-nf-adc.cdn-emitente          = nota-fiscal.cod-emitente
        AND   item-nf-adc.cod-natur-operac      = it-nota-fisc.nat-operacao
        AND   item-nf-adc.idi-tip-dado          = 1
        AND   item-nf-adc.num-seq               = 1
        AND   item-nf-adc.num-seq-item-nf       = it-nota-fisc.nr-seq-fat
        AND   item-nf-adc.cod-item              = it-nota-fisc.it-codigo:
    END.                   

    CREATE ttICMS10.
    ASSIGN ttICMS10.CST      = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS10.modBC    = (IF c-mod-base-icms = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms = "4"
                                          THEN "3"
                                          ELSE "0")
           ttICMS10.modBCST  = (IF c-mod-base-icms-st = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms-st = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms-st = "4"
                                          THEN "3"
                                          ELSE IF c-mod-base-icms-st = "5"
                                               THEN "4"
                                               ELSE IF c-mod-base-icms-st = "6"
                                                    THEN "5"
                                                    ELSE "0")
           ttICMS10.orig     = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS10.pICMS    = (IF it-nota-fisc.cd-trib-icm <> 3
                                THEN d-aliquota-icms
                                ELSE 0)
           ttICMS10.pICMSST  = IF  AVAIL item-nf-adc THEN item-nf-adc.val-aliq-icms-st ELSE 0
           ttICMS10.pMVAST   = ? /* valor nao gravado no EMS */
           ttICMS10.pRedBCST = ?
           ttICMS10.vBC      = it-nota-fisc.vl-bicms-it
           ttICMS10.vBCST    = it-nota-fisc.vl-bsubs-it
           ttICMS10.vICMS    = (IF it-nota-fisc.cd-trib-icm <> 3
                                THEN d-vl-imp-icms
                                ELSE 0)
           ttICMS10.vICMSST  = it-nota-fisc.vl-icmsub-it
           .

    /* Chave EMS */
    ASSIGN ttICMS10.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS10.SerieNF      = nota-fiscal.serie
           ttICMS10.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS10.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS10.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS20:

    /*
    === ttICMS20 ===
    CST            AS CHARACTER INITIAL ?  /*Tributá∆o pelo ICMS 20 - Com reduá∆o de base de c†lculo*/
    modBC          AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMS          AS DECIMAL   INITIAL ?  /*Al°quota do ICMS*/
    pRedBC         AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
    */

    CREATE ttICMS20.
    ASSIGN ttICMS20.CST    = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS20.modBC  = (IF c-mod-base-icms = "2"
                              THEN "1"
                              ELSE IF c-mod-base-icms = "3"
                                   THEN "2"
                                   ELSE IF c-mod-base-icms = "4"
                                        THEN "3"
                                        ELSE "0")
           ttICMS20.orig   = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS20.pICMS  = (IF it-nota-fisc.cd-trib-icm <> 3
                              THEN d-aliquota-icms
                              ELSE 0)
           ttICMS20.pRedBC = IF d-perc-redimp > 0 THEN d-perc-redimp  ELSE ? /*ELSE IF lLayoutXML THEN ? ELSE IF lLayoutTXT THEN 0 ELSE ?)*/
           ttICMS20.vBC    = d-vl-bicms-it
           ttICMS20.vICMS  = (IF it-nota-fisc.cd-trib-icm <> 3
                              THEN d-vl-imp-icms
                              ELSE 0).

    /* Chave EMS */
    ASSIGN ttICMS20.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS20.SerieNF      = nota-fiscal.serie
           ttICMS20.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS20.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS20.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS30:

    /*
    === ttICMS30 ===
    CST            AS CHARACTER INITIAL ?  /*Tributá∆o pelo ICMS 30 - Isenta ou n∆o tributada e com cobranáa do ICMS por substituiá∆o tribut†ria */
    modBCST        AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMSST        AS DECIMAL   INITIAL ?  /*Al°quota do ICMS ST*/
    pMVAST         AS DECIMAL   INITIAL ?  /*Percentual da Margem de Valor Adicionado ICMS ST*/
    pRedBCST       AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC ICMS ST */
    vBCST          AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS ST*/
    vICMSST        AS DECIMAL   INITIAL ?  /*Valor do ICMS ST*/
    */

    FOR FIRST item-nf-adc NO-LOCK
        WHERE item-nf-adc.cod-estab             = it-nota-fisc.cod-estabel
        AND   item-nf-adc.cod-serie             = it-nota-fisc.serie
        AND   item-nf-adc.cod-nota-fisc         = it-nota-fisc.nr-nota-fis
        AND   item-nf-adc.cdn-emitente          = nota-fiscal.cod-emitente
        AND   item-nf-adc.cod-natur-operac      = it-nota-fisc.nat-operacao
        AND   item-nf-adc.idi-tip-dado          = 1
        AND   item-nf-adc.num-seq               = 1
        AND   item-nf-adc.num-seq-item-nf       = it-nota-fisc.nr-seq-fat
        AND   item-nf-adc.cod-item              = it-nota-fisc.it-codigo:
    END.                   

    CREATE ttICMS30.
    ASSIGN ttICMS30.CST      = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS30.modBCST  = (IF c-mod-base-icms-st = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms-st = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms-st = "4"
                                          THEN "3"
                                          ELSE IF c-mod-base-icms-st = "5"
                                               THEN "4"
                                               ELSE IF c-mod-base-icms-st = "6"
                                                    THEN "5"
                                                    ELSE "0")
           ttICMS30.orig     = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS30.pICMSST  = IF  AVAIL item-nf-adc THEN item-nf-adc.val-aliq-icms-st ELSE 0
           ttICMS30.pMVAST   = ? /* valor nao gravado no EMS */
           ttICMS30.pRedBCST = ?
           ttICMS30.vBCST    = it-nota-fisc.vl-bsubs-it
           ttICMS30.vICMSST  = it-nota-fisc.vl-icmsub-it.

    /* Chave EMS */
    ASSIGN ttICMS30.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS30.SerieNF      = nota-fiscal.serie
           ttICMS30.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS30.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS30.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS40:

    /*
    === ttICMS40 ===
    CST            AS CHARACTER INITIAL ?  /*Tributaá∆o pelo ICMS 40 - Isenta 41 - N∆o tributada 50 - Suspens∆o 51 - Diferimento */
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    */

    CREATE ttICMS40.
    ASSIGN ttICMS40.CST  = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS40.orig = SUBSTRING(c-niv-trib-icms,1,1).

    /* Chave EMS */
    ASSIGN ttICMS40.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS40.SerieNF      = nota-fiscal.serie
           ttICMS40.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS40.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS40.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS51:

    /*
    === ttICMS51 ===
    CST            AS CHARACTER INITIAL ?  /*Tributá∆o pelo ICMS 20 - Com reduá∆o de base de c†lculo*/
    modBC          AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMS          AS DECIMAL   INITIAL ?  /*Al°quota do ICMS*/
    pRedBC         AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
    */

    CREATE ttICMS51.
    ASSIGN ttICMS51.CST    = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS51.modBC  = (IF c-mod-base-icms = "2"
                              THEN "1"
                              ELSE IF c-mod-base-icms = "3"
                                   THEN "2"
                                   ELSE IF c-mod-base-icms = "4"
                                        THEN "3"
                                        ELSE "0")
           ttICMS51.orig   = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS51.pICMS  = (IF it-nota-fisc.cd-trib-icm <> 3
                              THEN d-aliquota-icms
                              ELSE 0)
           ttICMS51.pRedBC = IF d-perc-redimp > 0 THEN d-perc-redimp  ELSE IF lLayoutTXT THEN 0 ELSE ?
           ttICMS51.vBC    = d-vl-bicms-it
           ttICMS51.vICMS  = (IF it-nota-fisc.cd-trib-icm <> 3
                              THEN d-vl-imp-icms
                              ELSE 0)
           .

    /* Chave EMS */
    ASSIGN ttICMS51.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS51.SerieNF      = nota-fiscal.serie
           ttICMS51.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS51.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS51.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS60:

    /*
    === ttICMS60 ===
    CST            AS CHARACTER INITIAL ?  /*Tributaá∆o pelo ICMS 60 - ICMS cobrado anteriormente por substituiá∆o tribut†ria */
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    vBCST          AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS ST retido anteriormente*/
    vICMSST        AS DECIMAL   INITIAL ?  /*Valor do ICMS ST retido anteriormente*/
    */

    CREATE ttICMS60.
    ASSIGN ttICMS60.CST     = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS60.orig    = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS60.vBCST   = it-nota-fisc.vl-bsubs-it
           ttICMS60.vICMSST = it-nota-fisc.vl-icmsub-it
           .

    /* Chave EMS */
    ASSIGN ttICMS60.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS60.SerieNF      = nota-fiscal.serie
           ttICMS60.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS60.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS60.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS70:

    /*
    === ttICMS70 ===
    CST            AS CHARACTER INITIAL ?  /*Tributá∆o pelo ICMS 70 - Com reduá∆o de base de c†lculo e cobranáa do ICMS por substituiá∆o tribut†ria */
    modBC          AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
    modBCST        AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido; 1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%); 5 - Pauta (valor).*/
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMS          AS DECIMAL   INITIAL ?  /*Al°quota do ICMS*/
    pICMSST        AS DECIMAL   INITIAL ?  /*Al°quota do ICMS ST*/
    pMVAST         AS DECIMAL   INITIAL ?  /*Percentual da Margem de Valor Adicionado ICMS ST*/
    pRedBC         AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC*/
    pRedBCST       AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC ICMS ST */
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS*/
    vBCST          AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS ST*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
    vICMSST        AS DECIMAL   INITIAL ?  /*Valor do ICMS ST*/
    */

    FOR FIRST item-nf-adc NO-LOCK
        WHERE item-nf-adc.cod-estab             = it-nota-fisc.cod-estabel
        AND   item-nf-adc.cod-serie             = it-nota-fisc.serie
        AND   item-nf-adc.cod-nota-fisc         = it-nota-fisc.nr-nota-fis
        AND   item-nf-adc.cdn-emitente          = nota-fiscal.cod-emitente
        AND   item-nf-adc.cod-natur-operac      = it-nota-fisc.nat-operacao
        AND   item-nf-adc.idi-tip-dado          = 1
        AND   item-nf-adc.num-seq               = 1
        AND   item-nf-adc.num-seq-item-nf       = it-nota-fisc.nr-seq-fat
        AND   item-nf-adc.cod-item              = it-nota-fisc.it-codigo:
    END.  

    CREATE ttICMS70.
    ASSIGN ttICMS70.CST      = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS70.modBC    = (IF c-mod-base-icms = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms = "4"
                                          THEN "3"
                                          ELSE "0")
           ttICMS70.modBCST  = (IF c-mod-base-icms-st = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms-st = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms-st = "4"
                                          THEN "3"
                                          ELSE IF c-mod-base-icms-st = "5"
                                               THEN "4"
                                               ELSE IF c-mod-base-icms-st = "6"
                                                    THEN "5"
                                                    ELSE "0")
           ttICMS70.orig     = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS70.pICMS    = (IF it-nota-fisc.cd-trib-icm <> 3
                                THEN d-aliquota-icms
                                ELSE 0)
           ttICMS70.pICMSST  = IF  AVAIL item-nf-adc THEN item-nf-adc.val-aliq-icms-st ELSE 0
           ttICMS70.pMVAST   = ? /* valor nao gravado no EMS */
           ttICMS70.pRedBC   = IF d-perc-redimp > 0 THEN d-perc-redimp  ELSE ? /*ELSE IF lLayoutXML THEN ? ELSE IF lLayoutTXT THEN 0 ELSE ?)*/
           ttICMS70.pRedBCST = ?
           ttICMS70.vBC      = d-vl-bicms-it
           ttICMS70.vBCST    = it-nota-fisc.vl-bsubs-it
           ttICMS70.vICMS    = (IF it-nota-fisc.cd-trib-icm <> 3
                                THEN d-vl-imp-icms
                                ELSE 0)
           ttICMS70.vICMSST  = it-nota-fisc.vl-icmsub-it.

    /* Chave EMS */
    ASSIGN ttICMS70.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS70.SerieNF      = nota-fiscal.serie
           ttICMS70.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS70.ItCodigoNF   = it-nota-fisc.it-codigo.
           ttICMS70.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS90:

    /*
    === ttICMS90 ===
    CST            AS CHARACTER INITIAL ?  /*Tributá∆o pelo ICMS 90 - Outras*/
    modBC          AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS:  0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
    modBCST        AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS ST: 0 - Preáo tabelado ou m†ximo  sugerido;  1 - Lista Negativa (valor); 2 - Lista Positiva (valor); 3 - Lista Neutra (valor); 4 - Margem Valor Agregado (%);  5 - Pauta (valor).*/
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMS          AS DECIMAL   INITIAL ?  /*Al°quota do ICMS*/
    pICMSST        AS DECIMAL   INITIAL ?  /*Al°quota do ICMS ST*/
    pMVAST         AS DECIMAL   INITIAL ?  /*Percentual da Margem de Valor Adicionado ICMS ST*/
    pRedBC         AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC*/
    pRedBCST       AS DECIMAL   INITIAL ?  /*Percentual de reduá∆o da BC ICMS ST */
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS*/
    vBCST          AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS ST*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
    vICMSST        AS DECIMAL   INITIAL ?  /*Valor do ICMS ST*/
    */

    FOR FIRST item-nf-adc NO-LOCK
        WHERE item-nf-adc.cod-estab             = it-nota-fisc.cod-estabel
        AND   item-nf-adc.cod-serie             = it-nota-fisc.serie
        AND   item-nf-adc.cod-nota-fisc         = it-nota-fisc.nr-nota-fis
        AND   item-nf-adc.cdn-emitente          = nota-fiscal.cod-emitente
        AND   item-nf-adc.cod-natur-operac      = it-nota-fisc.nat-operacao
        AND   item-nf-adc.idi-tip-dado          = 1
        AND   item-nf-adc.num-seq               = 1
        AND   item-nf-adc.num-seq-item-nf       = it-nota-fisc.nr-seq-fat
        AND   item-nf-adc.cod-item              = it-nota-fisc.it-codigo:
    END.  

    CREATE ttICMS90.
    ASSIGN ttICMS90.CST      = SUBSTRING(c-niv-trib-icms,2,2)
           ttICMS90.modBC    = (IF c-mod-base-icms = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms = "4"
                                          THEN "3"
                                          ELSE "0")
           ttICMS90.modBCST  = (IF c-mod-base-icms-st = "2"
                                THEN "1"
                                ELSE IF c-mod-base-icms-st = "3"
                                     THEN "2"
                                     ELSE IF c-mod-base-icms-st = "4"
                                          THEN "3"
                                          ELSE IF c-mod-base-icms-st = "5"
                                               THEN "4"
                                               ELSE IF c-mod-base-icms-st = "6"
                                                    THEN "5"
                                                    ELSE "0")
           ttICMS90.orig     = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS90.pICMS    = (IF  it-nota-fisc.cd-trib-icm <> 3
                                OR (it-nota-fisc.cd-trib-icm  = 3 AND l-icms-outras-it)
                                THEN d-aliquota-icms
                                ELSE 0)
           ttICMS90.pICMSST  = IF  AVAIL item-nf-adc THEN item-nf-adc.val-aliq-icms-st ELSE 0
           ttICMS90.pMVAST   = ? /* valor nao gravado no EMS */
           ttICMS90.pRedBC   = IF d-perc-redimp > 0 THEN d-perc-redimp  ELSE ? /*ELSE IF lLayoutXML THEN ? ELSE IF lLayoutTXT THEN 0 ELSE ?)*/
           ttICMS90.pRedBCST = ?
           ttICMS90.vBC      = (IF (it-nota-fisc.cd-trib-icm  = 3 AND l-icms-outras-it)
                                THEN d-vl-imp-icmsou
                                ELSE d-vl-bicms-it)
           ttICMS90.vBCST    = it-nota-fisc.vl-bsubs-it
           ttICMS90.vICMS    = (IF  it-nota-fisc.cd-trib-icm <> 3
                                OR (it-nota-fisc.cd-trib-icm  = 3 AND l-icms-outras-it)
                                THEN d-vl-imp-icms
                                ELSE 0)
           ttICMS90.vICMSST  = it-nota-fisc.vl-icmsub-it.
       
    /* Chave EMS */
    ASSIGN ttICMS90.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS90.SerieNF      = nota-fiscal.serie
           ttICMS90.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS90.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS90.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-grava-ttICMS00:

    /*
    === ttICMS00 ===
    CST            AS CHARACTER INITIAL ?  /*Tributá∆o pelo ICMS 00 - Tributada integralmente*/
    modBC          AS CHARACTER INITIAL ?  /*Modalidade de determinaá∆o da BC do ICMS: 0 - Margem Valor Agregado (%); 1 - Pauta (valor); 2 - Preáo Tabelado M†ximo (valor); 3 - Valor da Operaá∆o.*/
    orig           AS CHARACTER INITIAL ?  /*origem da mercadoria: 0 - Nacional 1 - Estrangeira - Importaá∆o direta 2 - Estrangeira - Adquirida no mercado interno */
    pICMS          AS DECIMAL   INITIAL ?  /*Al°quota do ICMS*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do ICMS*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor do ICMS*/
    */

    CREATE ttICMS00.
    ASSIGN ttICMS00.CST   = (IF LENGTH(c-niv-trib-icms) = 3
                             THEN SUBSTRING(c-niv-trib-icms,2,2)
                             ELSE "00")
           ttICMS00.modBC = (IF c-mod-base-icms = "2"
                             THEN "1"
                             ELSE IF c-mod-base-icms = "3"
                                  THEN "2"
                                  ELSE IF c-mod-base-icms = "4"
                                       THEN "3"
                                       ELSE "0")
           ttICMS00.orig  = SUBSTRING(c-niv-trib-icms,1,1)
           ttICMS00.pICMS = (IF it-nota-fisc.cd-trib-icm <> 3
                             THEN d-aliquota-icms
                             ELSE 0)
           ttICMS00.vBC   = d-vl-bicms-it
           ttICMS00.vICMS = (IF it-nota-fisc.cd-trib-icm <> 3
                             THEN d-vl-imp-icms
                             ELSE 0)
           .

    /* Chave EMS */
    ASSIGN ttICMS00.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMS00.SerieNF      = nota-fiscal.serie
           ttICMS00.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttICMS00.ItCodigoNF   = it-nota-fisc.it-codigo
           ttICMS00.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-cria-ttIPI:

    /*
    === ttIPI ===
    cEnq           AS CHARACTER INITIAL ?  /*C¢digo de Enquadramento Legal do IPI (tabela a ser criada pela RFB)*/
    clEnq          AS CHARACTER INITIAL ?  /*Classe de Enquadramento do IPI para Cigarros e Bebidas*/
    CNPJProd       AS CHARACTER INITIAL ?  /*CNPJ do produtor da mercadoria, quando diferente do emitente. Somente para os casos de exportaá∆o direta ou indireta.*/
    cSelo          AS CHARACTER INITIAL ?  /*C¢digo do selo de controle do IPI */
    CSTIPINT       AS CHARACTER INITIAL ?  /*C¢digo da Situaá∆o Tribut†ria do IPI: 01-Entrada tributada com al°quota zero 02-Entrada isenta 03-Entrada n∆o-tributada 04-Entrada imune 05-Entrada com suspens∆o 51-Sa°da tributada com al°quota zero 52-Sa°da isenta 53-Sa°da n∆o-tributada 54-Sa°da imune 55-Sa°da com suspens∆o*/
    CSTIPITrib     AS CHARACTER INITIAL ?  /*C¢digo da Situaá∆o Tribut†ria do IPI: 00-Entrada com recuperaá∆o de crÈdito 49 - Outras entradas 50-Sa°da tributada 99-Outras sa°das*/ 
    pIPI           AS DECIMAL   INITIAL ?  /*Al°quota do IPI*/
    qSelo          AS CHARACTER INITIAL ?  /*Quantidade de selo de controle do IPI*/
    qUnid          AS DECIMAL   INITIAL ?  /*Quantidade total na unidade padr∆o para tributaá∆o */
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do IPI*/
    vIPI           AS DECIMAL   INITIAL ?  /*Valor do IPI*/
    vUnid          AS DECIMAL   INITIAL ?  /*Valor por Unidade Tribut†vel. Informar o valor do imposto Pauta por unidade de medida.*/
    */

    ASSIGN c-sit-trib-ipi = string(it-nota-fisc.cod-sit-tributar-ipi).

    CREATE ttIPI.
    ASSIGN /*ttIPI.clEnq      =*/
           ttIPI.CNPJProd   = (IF ttIPI.CNPJProd <> ?
                                THEN ttIPI.CNPJProd
                               ELSE "")
           /*ttIPI.cSelo      =    */
           ttIPI.qSelo      = (IF ttIPI.qSelo <> ?
                                THEN ttIPI.qSelo
                               ELSE "")
           ttIPI.cEnq       = "999".
           

    IF  c-sit-trib-ipi = "01"
    OR  c-sit-trib-ipi = "02"
    OR  c-sit-trib-ipi = "03"
    OR  c-sit-trib-ipi = "04"
    OR  c-sit-trib-ipi = "05"
    OR  c-sit-trib-ipi = "51"
    OR  c-sit-trib-ipi = "52"
    OR  c-sit-trib-ipi = "53"
    OR  c-sit-trib-ipi = "54"
    OR  c-sit-trib-ipi = "55" THEN
        ASSIGN ttIPI.l-ipi-trib = NO.
    ELSE
        ASSIGN ttIPI.l-ipi-trib = YES.

    /*--- IPI Trib ---*/
    IF  ttIPI.l-ipi-trib THEN
        ASSIGN ttIPI.CSTIPITrib = (IF c-sit-trib-ipi = "00"
                                   OR c-sit-trib-ipi = "49"
                                   OR c-sit-trib-ipi = "50"
                                   OR c-sit-trib-ipi = "99"
                                   THEN c-sit-trib-ipi
                                   ELSE "99")
               ttIPI.pIPI       = it-nota-fisc.aliquota-ipi
               ttIPI.vBC        = it-nota-fisc.vl-bipi-it
               ttIPI.vIPI       = it-nota-fisc.vl-ipi-it
               ttIPI.qUnid      = it-nota-fisc.qt-faturada[1] WHEN c-sit-trib-ipi = "50"
               ttIPI.vUnid      = ITEM.valor-ipi-beb          WHEN c-sit-trib-ipi = "50"
               d-total-ipi      = d-total-ipi + it-nota-fisc.vl-ipi-i. 
    /*--- IPI NT ---*/
    ELSE
        ASSIGN ttIPI.CSTIPINT   = c-sit-trib-ipi.

    /* Chave EMS */
    ASSIGN ttIPI.CodEstabelNF = nota-fiscal.cod-estabel
           ttIPI.SerieNF      = nota-fiscal.serie
           ttIPI.NrNotaFisNF  = nota-fiscal.nr-nota-fis
           ttIPI.ItCodigoNF   = it-nota-fisc.it-codigo 
           ttIPI.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.


END PROCEDURE.

PROCEDURE pi-cria-ISS:
    /*
    cListServ      AS CHARACTER INITIAL ?                                         /*C¢digo da lista de serviáos da LC 116/03 em que se classifica o seriváo, campo de interesse da Prefeitura, devendo ser informado nas NFe conjugadas, onde h† a prestaá∆o de serviáos sujeitos ao ISSQN e fornecimento de peáas sujeitas ao ICMS*/
    cMunFG         AS CHARACTER INITIAL ?                                         /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
    vAliq          AS DECIMAL   INITIAL ?  FORMAT ">>9.99"           DECIMALS 2   /*Al°quota do ISSQN*/    
    vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da BC do ISSQN*/ 
    vISSQN         AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da do ISSQN*/  
    */
    
    DEFINE VARIABLE c-cMunFG      AS CHARACTER     NO-UNDO.
    DEFINE VARIABLE c-cod-servico AS CHARACTER     NO-UNDO.

    ASSIGN c-cod-servico = STRING(IF  it-nota-fisc.cod-servico = 0
                                  THEN ITEM.cod-servico
                                  ELSE it-nota-fisc.cod-servico).
    
    /* Carrega Cidade Prestaá∆o Serviáo - c-cMunFG */
    FOR FIRST reg-inf-compl NO-LOCK
        WHERE reg-inf-compl.cod-tab-inform   = "tab-codser"
        AND   reg-inf-compl.cod-campo-inform = "idi-orig-cidad-prestac-serv":U,
    
        FIRST inf-compl NO-LOCK
        WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
        AND   inf-compl.cod-indice = c-cod-servico:

    END.

    IF  AVAIL reg-inf-compl
    AND AVAIL inf-compl
    AND inf-compl.num-campo = 2 THEN /* Origem Cidade = Estabelecimento */
        ASSIGN c-cMunFG = STRING(IF bf-cidade-est.pais = "Brasil":U 
                                 THEN (IF AVAIL bf-cidade-est THEN bf-cidade-est.cdn-munpio-ibge ELSE 99)
                                 ELSE 9999999).
    ELSE /* Origem Cidade = Local de Entrega */
        ASSIGN c-cMunFG = STRING(IF bf-cidade-entrega.pais = "Brasil":U 
                                 THEN (IF AVAIL bf-cidade-entrega THEN bf-cidade-entrega.cdn-munpio-ibge ELSE 99)
                                 ELSE 9999999).
    /* Fim - Carrega Cidade Prestaá∆o Serviáo - c-cMunFG*/

    CREATE ttISSQN.  /* ISS */
    ASSIGN ttISSQN.cListServ = c-cod-servico
           ttISSQN.cMunFG    = c-cMunFG
           ttISSQN.vAliq     = it-nota-fisc.aliquota-iss
           ttISSQN.vBC       = it-nota-fisc.vl-biss-it
           ttISSQN.vISSQN    = it-nota-fisc.vl-iss-it.
        
   /* Chave EMS */
   ASSIGN ttISSQN.CodEstabelNF = nota-fiscal.cod-estabel
          ttISSQN.SerieNF      = nota-fiscal.serie
          ttISSQN.NrNotaFisNF  = nota-fiscal.nr-nota-fis
          ttISSQN.ItCodigoNF   = it-nota-fisc.it-codigo
          ttISSQN.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.

END PROCEDURE.

PROCEDURE pi-cria-ttII:
    /*
    === ttII ===
    vBC            AS DECIMAL   INITIAL ?  /*Base da BC do Imposto de Importaá∆o*/
    vDespAdu       AS DECIMAL   INITIAL ?  /*Valor das despesas aduaneiras*/
    vII            AS DECIMAL   INITIAL ?  /*Valor do Imposto de Importaá∆o*/
    vIOF           AS DECIMAL   INITIAL ?  /*Valor do Imposto sobre Operaá‰es Financeiras*/
    */

    ASSIGN d-base-ii = 0.

    FOR FIRST docto-estoq-nfe-imp NO-LOCK
        WHERE docto-estoq-nfe-imp.cod-ser-docto    = nota-fiscal.serie 
        AND   docto-estoq-nfe-imp.cod-docto        = nota-fiscal.nr-nota-ant 
        AND   docto-estoq-nfe-imp.cdn-emitente     = nota-fiscal.cod-emitente
        AND   docto-estoq-nfe-imp.cod-natur-operac = nota-fiscal.nat-operacao :
    
          ASSIGN d-base-ii = it-nota-fisc.vl-merc-ori.
          
          FOR EACH  item-docto-estoq-nfe-imp NO-LOCK 
              WHERE item-docto-estoq-nfe-imp.cdn-emitente     = docto-estoq-nfe-imp.cdn-emitente     
              AND   item-docto-estoq-nfe-imp.cod-docto        = docto-estoq-nfe-imp.cod-docto        
              AND   item-docto-estoq-nfe-imp.cod-ser-docto    = docto-estoq-nfe-imp.cod-ser-docto    
              AND   item-docto-estoq-nfe-imp.cod-natur-operac = docto-estoq-nfe-imp.cod-natur-operac
            AND   item-docto-estoq-nfe-imp.num-seq          = it-nota-fisc.nr-seq-ped /*na leitura deve usar o seq-ped, pois o recebimento pode estar de 1 em 1 a seq do item*/
              AND   item-docto-estoq-nfe-imp.val-impto-import <> 0 :
              
              /* Chave EMS */
              CREATE ttII.
              ASSIGN ttII.CodEstabelNF = nota-fiscal.cod-estabel
                     ttII.SerieNF      = nota-fiscal.serie
                     ttII.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                     ttII.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttII.NrSeqFatNF   = it-nota-fisc.nr-seq-fat. /*para criar a ttII ele deve usar o seq-fat */
              
                 ASSIGN ttII.vBC      = item-docto-estoq-nfe-imp.val-base
                        ttII.vDespAdu = item-docto-estoq-nfe-imp.val-despesa
                        ttII.vII      = item-docto-estoq-nfe-imp.val-impto-import
                        ttII.vIOF     = item-docto-estoq-nfe-imp.val-iof.

                 ASSIGN d-total-ii = d-total-ii + ttII.vII.
          END.
          
          
          
    END.
END PROCEDURE.

PROCEDURE pi-cria-ttPIS:

    /*
    === ttPISAliq ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do PIS. 01 - Operaá∆o Tribut†vel - Base de C†lculo = Valor da Operaá∆o Al°quota Normal (Cumulativo/N∆o Cumulativo); 02 - Operaá∆o Tribut†vel - Base de Calculo = Valor da Operaá∆o (Al°quota Diferenciada) */
    pPIS           AS DECIMAL   INITIAL ?  /*Al°quota do PIS (em percentual)*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do PIS*/
    vPIS           AS DECIMAL   INITIAL ?  /*Valor do PIS*/
    
    === ttPISNT ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do PIS. 04 - Operaá∆o Tribut†vel - Tributaá∆o Monof†sica - (Al°quota Zero); 06 - Operaá∆o Tribut†vel - Al°quota Zero; 07 - Operaá∆o Isenta da contribuiá∆o; 08 - Operaá∆o Sem Incidància da contribuiá∆o; 09 - Operaá∆o com suspens∆o da contribuiá∆o */
    
    === ttPISOutr ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do PIS. 99 - Outras Operaá‰es.*/
    pPIS           AS DECIMAL   INITIAL ?  /*Al°quota do PIS (em percentual)*/
    qBCProd        AS DECIMAL   INITIAL ?  /*Quantidade Vendida */
    vAliqProd      AS DECIMAL   INITIAL ?  /*Al°quota do PIS (em reais)*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do PIS*/
    vPIS           AS DECIMAL   INITIAL ?  /*Valor do PIS*/

    === ttPISQtde ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do PIS. 03 - Operaá∆o Tribut†vel - Base de Calculo = Quantidade Vendida x Al°quota por Unidade de Produto */
    qBCProd        AS DECIMAL   INITIAL ?  /*Quantidade Vendida */
    vAliqProd      AS DECIMAL   INITIAL ?  /*Al°quota do PIS (em reais)*/
    vPIS           AS DECIMAL   INITIAL ?  /*Valor do PIS*/
    
    === ttPISST ===
    pPIS           AS DECIMAL   INITIAL ?  /*Al°quota do PIS ST (em percentual)*/
    qBCProd        AS DECIMAL   INITIAL ?  /*Quantidade Vendida */
    vAliqProd      AS DECIMAL   INITIAL ?  /*Al°quota do PIS ST (em reais)*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do PIS ST*/
    vPIS           AS DECIMAL   INITIAL ?  /*Valor do PIS ST*/
    */


    ASSIGN c-sit-trib-pis = string(it-nota-fisc.cod-sit-tributar-pis).
                            
    CASE c-sit-trib-pis:
        /*--- PISAliq ---*/
        WHEN "01" OR
        WHEN "02" THEN DO:

            CREATE ttPISAliq.
            ASSIGN ttPISAliq.CST  = c-sit-trib-pis
                   ttPISAliq.pPIS = d-aliq-pis /*dec(substring(it-nota-fisc.char-2,76,5))*/
                   ttPISAliq.vBC  = d-base-pis
                   ttPISAliq.vPIS = d-valor-pis.

            /* Chave EMS */
            ASSIGN ttPISAliq.CodEstabelNF = nota-fiscal.cod-estabel
                   ttPISAliq.SerieNF      = nota-fiscal.serie
                   ttPISAliq.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttPISAliq.ItCodigoNF   = it-nota-fisc.it-codigo 
                   ttPISAliq.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
        /*--- PISQtde ---*/
        WHEN "03" THEN DO:

            CREATE ttPISQtde.
            ASSIGN ttPISQtde.CST       = c-sit-trib-pis
                   ttPISQtde.qBCProd   = it-nota-fisc.qt-faturada[2]
                   ttPISQtde.vAliqProd = it-nota-fisc.val-unit-pis
                   ttPISQtde.vPIS      = d-valor-pis.

            /* Chave EMS */
            ASSIGN ttPISQtde.CodEstabelNF = nota-fiscal.cod-estabel
                   ttPISQtde.SerieNF      = nota-fiscal.serie
                   ttPISQtde.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttPISQtde.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttPISQtde.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
        /*--- PISNT ---*/
        WHEN "04" OR 
        WHEN "06" OR 
        WHEN "07" OR 
        WHEN "08" OR 
        WHEN "09" THEN DO:

            CREATE ttPISNT.
            ASSIGN ttPISNT.CST = c-sit-trib-pis.

            /* Chave EMS */
            ASSIGN ttPISNT.CodEstabelNF = nota-fiscal.cod-estabel
                   ttPISNT.SerieNF      = nota-fiscal.serie
                   ttPISNT.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttPISNT.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttPISNT.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
        /*--- PISOutr ---*/
        OTHERWISE DO:

            CREATE ttPISOutr.
            ASSIGN ttPISOutr.CST       = c-sit-trib-pis /* tratamento novos CST's de PIS e COFINS */
                   ttPISOutr.vPIS      = d-valor-pis.

            IF  it-nota-fisc.val-unit-pis <> 0 THEN DO:

                ASSIGN ttPISOutr.qBCProd   = it-nota-fisc.qt-faturada[2]
                       ttPISOutr.vAliqProd = it-nota-fisc.val-unit-pis.
            END.
            ELSE DO:

                ASSIGN ttPISOutr.vBC       = d-base-pis
                       ttPISOutr.pPIS      = d-aliq-pis.
            END.

            /* Chave EMS */
            ASSIGN ttPISOutr.CodEstabelNF = nota-fiscal.cod-estabel
                   ttPISOutr.SerieNF      = nota-fiscal.serie
                   ttPISOutr.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttPISOutr.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttPISOutr.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
    END CASE.
    /*--- PISST ---*/
    IF  it-nota-fisc.vl-pis <> 0 THEN DO: /*Existe valor para PIS Substituto*/

        FOR FIRST item-cli 
            WHERE item-cli.nome-abrev = emitente.nome-abrev
            AND   item-cli.it-codigo  = it-nota-fisc.it-codigo NO-LOCK:

            ASSIGN de-perc-pis-subst = DEC(TRIM(SUBSTRING(item-cli.char-1,31,5))) / 100
                   de-base-pis-subs  = it-nota-fisc.vl-tot-item.

            IF CAN-FIND(FIRST funcao NO-LOCK
                        WHERE funcao.cd-funcao = "spp-icms-subs":U
                        AND   funcao.ativo) THEN
               ASSIGN de-base-pis-subs = de-base-pis-subs - it-nota-fisc.vl-icmsub-it.
        
            CREATE ttPISST.

            /* Em percentual */
            IF de-perc-pis-subst <> 0 AND
               de-perc-pis-subst <> ? THEN 
               ASSIGN ttPISST.pPIS        = de-perc-pis-subst
                      ttPISST.vBC         = de-base-pis-subs
                      ttPISST.qBCProd     = 0     
                      ttPISST.vAliqProd   = 0    
                      ttPISST.vPIS        = it-nota-fisc.vl-pis.

            /* Em reais */
            ELSE 
               ASSIGN ttPISST.vAliqProd   = IF bf-natur-oper-it.mercado = 1 THEN /* Mercado Interno */
                                               bf-natur-oper-it.perc-pis[1]
                                            ELSE bf-natur-oper-it.perc-pis[2]    
                      ttPISST.qBCProd     = it-nota-fisc.qt-faturada[1] * (DEC(TRIM(SUBSTRING(item-cli.char-1,1,15))) / 10000)
                      ttPISST.vBC         = 0
                      ttPISST.pPIS        = 0
                      ttPISST.vPIS        = it-nota-fisc.vl-pis.
                                  
            /* Chave EMS */
            ASSIGN ttPISST.CodEstabelNF = nota-fiscal.cod-estabel
                   ttPISST.SerieNF      = nota-fiscal.serie
                   ttPISST.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttPISST.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttPISST.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
    END.
                            
END PROCEDURE.

PROCEDURE pi-cria-ttCOFINS:

    /*
    === ttCOFINSAliq ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do COFINS. 01 Operaá∆o Tribut†vel - Base de C†lculo = Valor da Operaá∆o Al°quota Normal (Cumulativo/N∆o Cumulativo); 02 - Operaá∆o Tribut†vel - Base de Calculo = Valor da Operaá∆o (Al°quota Diferenciada) */
    pCOFINS        AS DECIMAL   INITIAL ?  /*Al°quota do COFINS (em percentual)*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do COFINS*/
    vCOFINS        AS DECIMAL   INITIAL ?  /*Valor do COFINS*/

    === ttCOFINSNT ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do COFINS: 04 - Operaá∆o Tribut†vel - Tributaá∆o Monof†sica - (Al°quota Zero); 06 - Operaá∆o Tribut†vel - Al°quota Zero; 07 - Operaá∆o Isenta da contribuiá∆o; 08 - Operaá∆o Sem Incidància da contribuiá∆o; 09 - Operaá∆o com suspens∆o da contribuiá∆o */
    
    === ttCOFINSOutr ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do COFINS: 99 - Outras Operaá‰es.*/
    pCOFINS        AS DECIMAL   INITIAL ?  /*Al°quota do COFINS (em percentual)*/
    qBCProd        AS DECIMAL   INITIAL ?  /*Quantidade Vendida */
    vAliqProd      AS DECIMAL   INITIAL ?  /*Al°quota do COFINS (em reais)*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do COFINS*/
    vCOFINS        AS DECIMAL   INITIAL ?  /*Valor do COFINS*/
    
    === ttCOFINSQtde ===
    CST            AS CHARACTER INITIAL ?  /*C¢digo de Situaá∆o Tribut†ria do COFINS. 03 - Operaá∆o Tribut†vel - Base de Calculo = Quantidade Vendida x Al°quota por Unidade de Produto */
    qBCProd        AS DECIMAL   INITIAL ?  /*Quantidade Vendida */
    vAliqProd      AS DECIMAL   INITIAL ?  /*Al°quota do COFINS (em reais)*/
    vCOFINS        AS DECIMAL   INITIAL ?  /*Valor do COFINS*/

    === ttCOFINSST ===
    pCOFINS        AS DECIMAL   INITIAL ?  /*Al°quota do COFINS ST(em percentual)*/
    qBCProd        AS DECIMAL   INITIAL ?  /*Quantidade Vendida */
    vAliqProd      AS DECIMAL   INITIAL ?  /*Al°quota do COFINS ST(em reais)*/
    vBC            AS DECIMAL   INITIAL ?  /*Valor da BC do COFINS ST*/
    vCOFINS        AS DECIMAL   INITIAL ?  /*Valor do COFINS ST*/
    */

    ASSIGN c-sit-trib-cofins = string(it-nota-fisc.cod-sit-tributar-cofins).
    CASE c-sit-trib-cofins:
        /*--- COFINSAliq ---*/
        WHEN "01" OR
        WHEN "02" THEN DO:

            CREATE ttCOFINSAliq.
            ASSIGN ttCOFINSAliq.CST     = c-sit-trib-cofins
                   ttCOFINSAliq.pCOFINS = d-aliq-cofins /*dec(substring(it-nota-fisc.char-2,81,5))*/
                   ttCOFINSAliq.vBC     = d-base-cofins
                   ttCOFINSAliq.vCOFINS = d-valor-cofins.

            /* Chave EMS */
            ASSIGN ttCOFINSAliq.CodEstabelNF = nota-fiscal.cod-estabel
                   ttCOFINSAliq.SerieNF      = nota-fiscal.serie
                   ttCOFINSAliq.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttCOFINSAliq.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttCOFINSAliq.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
        /*--- COFINSQtde ---*/
        WHEN "03" THEN DO:

            CREATE ttCOFINSQtde.
            ASSIGN ttCOFINSQtde.CST       = c-sit-trib-cofins
                   ttCOFINSQtde.qBCProd   = it-nota-fisc.qt-faturada[2]
                   ttCOFINSQtde.vAliqProd = it-nota-fisc.val-unit-cofins
                   ttCOFINSQtde.vCOFINS   = d-valor-cofins.

            /* Chave EMS */
            ASSIGN ttCOFINSQtde.CodEstabelNF = nota-fiscal.cod-estabel
                   ttCOFINSQtde.SerieNF      = nota-fiscal.serie
                   ttCOFINSQtde.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttCOFINSQtde.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttCOFINSQtde.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
        /*--- COFINSNT ---*/
        WHEN "04" OR 
        WHEN "06" OR
        WHEN "07" OR 
        WHEN "08" OR
        WHEN "09" THEN DO:

            CREATE ttCOFINSNT.
            ASSIGN ttCOFINSNT.CST       = c-sit-trib-cofins.

            /* Chave EMS */
            ASSIGN ttCOFINSNT.CodEstabelNF = nota-fiscal.cod-estabel
                   ttCOFINSNT.SerieNF      = nota-fiscal.serie
                   ttCOFINSNT.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttCOFINSNT.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttCOFINSNT.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
        /*--- COFINSOutr ---*/
        OTHERWISE DO:

            CREATE ttCOFINSOutr.
            ASSIGN ttCOFINSOutr.CST       = c-sit-trib-cofins /* tratamento novos CST's de PIS e COFINS */
                   ttCOFINSOutr.vCOFINS   = d-valor-cofins.

            IF  it-nota-fisc.val-unit-cofins <> 0 THEN DO:

                ASSIGN ttCOFINSOutr.qBCProd   = it-nota-fisc.qt-faturada[2]
                       ttCOFINSOutr.vAliqProd = it-nota-fisc.val-unit-cofins.
            END.
            ELSE DO:

                 ASSIGN ttCOFINSOutr.vBC       = d-base-cofins
                        ttCOFINSOutr.pCOFINS   = d-aliq-cofins.
            END.

            /* Chave EMS */
            ASSIGN ttCOFINSOutr.CodEstabelNF = nota-fiscal.cod-estabel
                   ttCOFINSOutr.SerieNF      = nota-fiscal.serie
                   ttCOFINSOutr.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttCOFINSOutr.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttCOFINSOutr.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
    END CASE.

    /*--- COFINSST ---*/
    IF  it-nota-fisc.vl-finsocial <> 0 THEN DO: /*Existe valor para PIS Substituto*/

        FOR FIRST item-cli 
            WHERE item-cli.nome-abrev = emitente.nome-abrev
            AND   item-cli.it-codigo  = it-nota-fisc.it-codigo NO-LOCK:

            ASSIGN de-perc-cofins-subst = DEC(TRIM(SUBSTRING(item-cli.char-1,36,5))) / 100
                   de-base-cofins-subs  = it-nota-fisc.vl-tot-item.

            IF CAN-FIND(FIRST funcao NO-LOCK
                        WHERE funcao.cd-funcao = "spp-icms-subs":U
                        AND   funcao.ativo) THEN
               ASSIGN de-base-cofins-subs = de-base-cofins-subs - it-nota-fisc.vl-icmsub-it.
        
            CREATE ttCOFINSST.

            /* Em percentual */
            IF de-perc-cofins-subst <> 0 AND
               de-perc-cofins-subst <> ? THEN 
               ASSIGN ttCOFINSST.pCOFINS     = de-perc-cofins-subst
                      ttCOFINSST.vBC         = de-base-cofins-subs
                      ttCOFINSST.qBCProd     = 0     
                      ttCOFINSST.vAliqProd   = 0    
                      ttCOFINSST.vCOFINS     = it-nota-fisc.vl-finsocial.

            /* Em reais */
            ELSE 
               ASSIGN ttCOFINSST.vAliqProd   = IF bf-natur-oper-it.mercado = 1 THEN /* Mercado Interno */
                                                  bf-natur-oper-it.per-fin-soc[1]
                                               ELSE bf-natur-oper-it.per-fin-soc[2]    
                      ttCOFINSST.qBCProd     = it-nota-fisc.qt-faturada[1] * (DEC(TRIM(SUBSTRING(item-cli.char-1,16,15))) / 10000)
                      ttCOFINSST.vBC         = 0
                      ttCOFINSST.pCOFINS     = 0
                      ttCOFINSST.vCOFINS     = it-nota-fisc.vl-finsocial.
                                  
            /* Chave EMS */
            ASSIGN ttCOFINSST.CodEstabelNF = nota-fiscal.cod-estabel
                   ttCOFINSST.SerieNF      = nota-fiscal.serie
                   ttCOFINSST.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttCOFINSST.ItCodigoNF   = it-nota-fisc.it-codigo
                   ttCOFINSST.NrSeqFatNF   = it-nota-fisc.nr-seq-fat.
        END.
    END.
END PROCEDURE.

PROCEDURE pi-cria-ttICMSTot:

    FIND FIRST param-global NO-LOCK NO-ERROR.

    /*
    === ttICMSTot ===
    vBC            AS DECIMAL   INITIAL ?  /*BC do ICMS*/
    vBCST          AS DECIMAL   INITIAL ?  /*BC do ICMS ST*/
    vCOFINS        AS DECIMAL   INITIAL ?  /*Valor do COFINS*/
    vDesc          AS DECIMAL   INITIAL ?  /*Valor Total do Desconto*/
    vFrete         AS DECIMAL   INITIAL ?  /*Valor Total do Frete*/
    vICMS          AS DECIMAL   INITIAL ?  /*Valor Total do ICMS*/
    vII            AS DECIMAL   INITIAL ?  /*Valor Total do II*/
    vIPI           AS DECIMAL   INITIAL ?  /*Valor Total do IPI*/
    vNF            AS DECIMAL   INITIAL ?  /*Valor Total da NF-e*/
    vOutro         AS DECIMAL   INITIAL ?  /*Outras Despesas acess¢rias*/
    vPIS           AS DECIMAL   INITIAL ?  /*Valor do PIS*/
    vProd          AS DECIMAL   INITIAL ?  /*Valor Total dos produtos e serviáos*/
    vSeg           AS DECIMAL   INITIAL ?  /*Valor Total do Seguro*/
    vST            AS DECIMAL   INITIAL ?  /*Valor Total do ICMS ST*/
    */

    CREATE ttICMSTot.
    ASSIGN ttICMSTot.vBC     = d-total-base-icms
           ttICMSTot.vBCST   = d-total-base-icms-st
           ttICMSTot.vCOFINS = d-total-cofins
           ttICMSTot.vFrete  = nota-fiscal.vl-frete
           ttICMSTot.vICMS   = d-total-icms
           ttICMSTot.vII     = d-total-ii
           ttICMSTot.vIPI    = d-total-ipi
           ttICMSTot.vNF     = nota-fiscal.vl-tot-nota
           ttICMSTot.vOutro  = nota-fiscal.vl-embalagem /*d-total-outras-desp*/
           ttICMSTot.vOutro  = (IF param-global.modulo-07 THEN ttICMSTot.vOutro  - ttICMSTot.vII  /* retira valor do II */ ELSE ttICMSTot.vOutro)
           ttICMSTot.vPIS    = d-total-pis
           ttICMSTot.vProd   = IF  de-vl-zfm-tot <> 0 THEN 
                                   de-vl-zfm-tot 
                               ELSE IF  l-funcao-preco-bruto-nfe THEN 
                                        de-vProdTotal         /* valor total produtos bruto   */
                                    ELSE 
                                        nota-fiscal.vl-mercad /* valor total produtos liquido */
           ttICMSTot.vSeg    = nota-fiscal.vl-seguro
           ttICMSTot.vST     = d-total-icms-st
           .
    
    IF ttICMSTot.vOutro < 0 THEN
       ASSIGN ttICMSTot.vOutro = 0.

    IF  de-vl-zfm-tot <> 0 
    AND lLayoutTXT
    AND l-fn-ZFM  THEN 
        ASSIGN ttICMSTot.vDesc = nota-fiscal.dec-1.
    ELSE
        IF  CAN-FIND (funcao WHERE funcao.cd-funcao = "SPP-DESCONTO-NFE":U AND funcao.ativo) 
            AND INT(SUBSTRING(bf-natur-oper-nf.char-2,11,5)) = 2 THEN  /* base calculo IPI = 2 (Liquido) */
            ASSIGN ttICMSTot.vDesc   = 0.
        ELSE
            ASSIGN ttICMSTot.vDesc   = nota-fiscal.val-desconto-total.

    /* Chave EMS */
    ASSIGN ttICMSTot.CodEstabelNF = nota-fiscal.cod-estabel
           ttICMSTot.SerieNF      = nota-fiscal.serie
           ttICMSTot.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

END PROCEDURE.

PROCEDURE pi-cria-ttISSQNTot:

    /*
    === ttISSQNTot ===
    vBC            AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo do ISS*/                                                    
    vCOFINS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do COFINS sobre serviáos*/                                            
    vISS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total do ISS*/                                                        
    vPIS           AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor do PIS sobre serviáos*/                                               
    vServ          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Total dos Serviáos sob n∆o-incidància ou n∆o tributados pelo ICMS */  
    */

    CREATE ttISSQNTot.
    ASSIGN ttISSQNTot.vBC     = d-total-base-iss
           ttISSQNTot.vISS    = d-total-iss
           ttISSQNTot.vServ   = d-total-serv
           .

    /* Chave EMS */
    ASSIGN ttISSQNTot.CodEstabelNF = nota-fiscal.cod-estabel
           ttISSQNTot.vCOFINS      = IF  lLayoutTXT THEN ? ELSE 0
           ttISSQNTot.vPIS         = IF  lLayoutTXT THEN ? ELSE 0
           ttISSQNTot.SerieNF      = nota-fiscal.serie
           ttISSQNTot.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

END PROCEDURE.


PROCEDURE pi-cria-ttRetTrib:

    /*
    === ttRetTrib ===
     vBCIRRF        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo do IRRF*/ 
     vBCRetPrev     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Base de C†lculo da Retená∆o da Previdàncica Social*/ 
     vIRRF          AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de IRRF*/    
     vRetCOFINS     AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de COFINS*/  
     vRetCSLL       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de CSLL*/    
     vRetPIS        AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor Retido de PIS*/     
     vRetPrev       AS DECIMAL   INITIAL ?  FORMAT ">>>>>>>>>>>>9.99" DECIMALS 2   /*Valor da Retená∆o da Previdàncica Social*/ 
    */

    CREATE ttRetTrib.
    ASSIGN ttRetTrib.vBCIRRF    = IF d-total-base-ret-irf > 0 THEN d-total-base-ret-irf ELSE ? 
           ttRetTrib.vIRRF      = IF d-total-ret-irf      > 0 THEN d-total-ret-irf      ELSE ? 
           ttRetTrib.vRetCOFINS = IF d-total-ret-cofins   > 0 THEN d-total-ret-cofins   ELSE ?
           ttRetTrib.vRetCSLL   = IF d-total-ret-csll     > 0 THEN d-total-ret-csll     ELSE ?
           ttRetTrib.vRetPIS    = IF d-total-ret-pis      > 0 THEN d-total-ret-pis      ELSE ?
           /*ttRetTrib.vBCRetPrev = */
           /*ttRetTrib.vRetPrev   = */
           .

    /* Chave EMS */
    ASSIGN ttRetTrib.CodEstabelNF = nota-fiscal.cod-estabel
           ttRetTrib.SerieNF      = nota-fiscal.serie
           ttRetTrib.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

END PROCEDURE.


PROCEDURE pi-cria-ttTransp:

    /*
    === ttTransp ===
    CFOP           AS CHARACTER INITIAL ?  /*C¢digo Fiscal de Operaá‰es e Prestaá‰es*/
    cMunFG         AS INT       INITIAL ?  /*C¢digo do Munic°pio de Ocorrància do Fato Gerador (utilizar a tabela do IBGE)*/
    CNPJ           AS CHARACTER INITIAL ?  /*CNPJ do transportador*/
    CPF            AS CHARACTER INITIAL ?  /*CPF do transportador*/
    IE             AS CHARACTER INITIAL ?  /*Inscriá∆o Estadual*/
    modFrete       AS CHARACTER INITIAL ?  /*Modalidade do frete (0 - por conta do emitente; 1 - por conta do destinat†rio)*/
    pICMSRet       AS DECIMAL   INITIAL ?  /*Al°quota da Retená∆o*/
    placa          AS CHARACTER INITIAL ?  /*Placa do ve°culo*/
    RNTC           AS CHARACTER INITIAL ?  /*Registro Nacional de Transportador de Carga (ANTT)*/
    UF             AS CHARACTER INITIAL ?  /*Sigla da UF*/
    UFplaca        AS CHARACTER INITIAL ?  /*Sigla da UF do Ve°culo*/
    vBCRet         AS DECIMAL   INITIAL ?  /*BC da Retená∆o do ICMS*/
    vICMSRet       AS DECIMAL   INITIAL ?  /*Valor do ICMS Retido*/
    vServ          AS DECIMAL   INITIAL ?  /*Valor do Serviáo*/
    xEnder         AS CHARACTER INITIAL ?  /*Endereáo completo*/
    xMun           AS CHARACTER INITIAL ?  /*Nome do mun°cipio*/
    xNome          AS CHARACTER INITIAL ?  /*Raz∆o Social ou nome*/
    
    === ttReboque ===
    placa          AS CHARACTER INITIAL ?  /*Placa do ve°culo*/
    RNTC           AS CHARACTER INITIAL ?  /*Registro Nacional de Transportador de Carga (ANTT)*/
    UF             AS CHARACTER INITIAL ?  /*Sigla da UF*/
    
    === ttVol ===
    esp            AS CHARACTER INITIAL ?  /*EspÇcie dos volumes transportados*/
    marca          AS CHARACTER INITIAL ?  /*Marca dos volumes transportados*/
    nVol           AS CHARACTER INITIAL ?  /*Numeraá∆o dos volumes transportados*/
    pesoB          AS DECIMAL   INITIAL ?  /*Peso bruto (em kg)*/
    pesoL          AS DECIMAL   INITIAL ?  /*Peso l°quido (em kg)*/
    qVol           AS CHARACTER INITIAL ?  /*Quantidade de volumes transportados*/
    */

/* VARIAVEIS PARA CALCULO DO PESO DOS VOLUMES */
DEF VAR i-tot-qt-volumes            LIKE nota-embal.qt-volumes          NO-UNDO.
DEF VAR de-tot-peso-liq             LIKE nota-fiscal.peso-liq-tot       NO-UNDO.
DEF VAR de-tot-peso-bru             LIKE nota-fiscal.peso-bru-tot       NO-UNDO.
DEF VAR de-dif-peso-liq             LIKE nota-fiscal.peso-liq-tot       NO-UNDO.
DEF VAR de-dif-peso-bru             LIKE nota-fiscal.peso-bru-tot       NO-UNDO.
DEF VAR de-peso-liq-rateado         LIKE nota-fiscal.peso-liq-tot       NO-UNDO.
DEF VAR de-peso-bru-rateado         LIKE nota-fiscal.peso-bru-tot       NO-UNDO.


    CREATE ttTransp.
    ASSIGN ttTransp.modFrete   = (IF nota-fiscal.cidade-cif <> "" 
                                   THEN "0"    /*CIF*/
                                  ELSE "1"). /*FOB*/

    FOR FIRST transporte NO-LOCK
        WHERE transporte.nome-abrev = nota-fiscal.nome-transp:

        ASSIGN ttTransp.i-natureza = transporte.natureza /* 1 - Pessoa F°sica | 2 - Pessoa Jur°dica | 3 - Estrangeiro | 4 - Trading */
               ttTransp.xNome      = transporte.nome.
               
        ASSIGN c-endereco = transporte.endereco
               c-rua      = ""
               c-nro      = ""
               c-comp     = "".
    
        IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
            ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").
    
        RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                             OUTPUT c-rua, 
                                             OUTPUT c-nro, 
                                             OUTPUT c-comp).
    
        IF  nota-fiscal.nome-transp = ""
        AND c-endereco              = ""
        AND c-nro                   = "" THEN DO:
            IF  AVAIL ttTransp THEN
                DELETE ttTransp.
            RETURN.
        END.

        IF  c-nro = "" THEN
            ASSIGN c-nro = "S/N".

        /* IF ttTransp.modFrete = "1" THEN DO:
            ASSIGN ttTransp.i-natureza = i-natureza. /* 1 - Pessoa F°sica | 2 - Pessoa Jur°dica | 3 - Estrangeiro | 4 - Trading */
        
            /* <Transporta> */
            IF  emitente.cgc <> "" THEN
                ASSIGN ttTransp.CNPJ     = (IF i-natureza > 2 THEN "" /* Estrangeiro ou Trading */
                                             ELSE IF i-natureza = 2 THEN emitente.cgc /* Pessoa Juridica */
                                                 ELSE "")
                       ttTransp.CPF      = (IF i-natureza = 1 /* Pessoa Fisica */
                                             THEN emitente.cgc
                                            ELSE "")
                       ttTransp.CPF        = (IF ttTransp.CPF <> ?
                                              THEN ttTransp.CPF
                                              ELSE "")
                       ttTransp.xNome    = emitente.nome-abrev
                       ttTransp.IE       = emitente.ins-estadual
                       ttTransp.IE       = IF emitente.contrib-icms AND 
                                              i-natureza = 1 AND 
                                              lLayoutTXT THEN ""  /* Pessoa F°sica, contribuinte ICMS -> Isento (no layout TXT, enviar branco) */
                                           ELSE ttTransp.IE 
                       ttTransp.IE       = REPLACE(ttTransp.IE,"-","")
                       ttTransp.IE       = REPLACE(ttTransp.IE,".","")
                       ttTransp.IE       = REPLACE(ttTransp.IE,"/","")
                       ttTransp.IE       = REPLACE(ttTransp.IE,"~\","")
                       ttTransp.IE       = REPLACE(ttTransp.IE,",","")
                       ttTransp.IE       = (IF ttTransp.IE <> ?
                                             THEN ttTransp.IE
                                            ELSE "")
                       ttTransp.xEnder   = (c-rua + " " + c-nro + " " + c-comp)
                       ttTransp.xMun     = emitente.cidade
                       ttTransp.UF       = emitente.estado
                       ttTransp.UF       = (IF ttTransp.UF <> ?
                                            THEN ttTransp.UF
                                            ELSE "").

        END.
        ELSE DO:*/
            
            /* <Transporta> */
            IF  transporte.nome-abrev <> "Remetente"    AND 
                transporte.nome-abrev <> "Destinat†rio" AND 
                transporte.nome-abrev <> "Destinatario" THEN

              ASSIGN ttTransp.CNPJ     = (IF transporte.pais <> "Brasil":U AND lLayoutXML
                                          THEN "00000000000000"
                                          else IF  transporte.pais <> "Brasil" OR transporte.natureza = 1 /* Estrangeiro ou Trading  ou Pessoa F°sica*/
                                              THEN ""
                                              ELSE transporte.cgc ) /* Pessoa Juridica */
                     ttTransp.CPF      = (IF transporte.natureza = 1 /* Pessoa Fisica */
                                           THEN transporte.cgc
                                          ELSE "")
                     ttTransp.CPF        = (IF ttTransp.CPF <> ?
                                            THEN ttTransp.CPF
                                            ELSE "")
                     ttTransp.xNome    = transporte.nome
                     ttTransp.IE       = IF transporte.ins-estadual = "isento":U AND lLayoutTXT 
                                         THEN ""
                                         ELSE transporte.ins-estadual
                     ttTransp.IE       = REPLACE(ttTransp.IE,"-","")
                     ttTransp.IE       = REPLACE(ttTransp.IE,".","")
                     ttTransp.IE       = REPLACE(ttTransp.IE,"/","")
                     ttTransp.IE       = REPLACE(ttTransp.IE,"~\","")
                     ttTransp.IE       = REPLACE(ttTransp.IE,",","")
                     ttTransp.IE       = (IF ttTransp.IE <> ?
                                           THEN ttTransp.IE
                                          ELSE "")
                     ttTransp.xEnder   = (c-rua + " " + c-nro + " " + c-comp)
                     ttTransp.xMun     = (IF transporte.pais <> "Brasil":U
                                            THEN "Exterior"
                                            ELSE transporte.cidade)
                     ttTransp.UF       = (IF transporte.pais <> "Brasil":U
                                          THEN "EX"
                                          ELSE transporte.estado)
                     ttTransp.UF       = (IF ttTransp.UF <> ?
                                          THEN ttTransp.UF
                                          ELSE "").
            ELSE 
                ASSIGN ttTransp.xNome    = ""
                       ttTransp.CNPJ     = ""
                       ttTransp.CPF      = ""
                       ttTransp.IE       = ""
                       ttTransp.xEnder   = ""
                       ttTransp.xMun     = ""
                       ttTransp.UF       = ""
                       .
        /*END.*/

        
    END.

    /*--------------------------
    /* <retTransp> */
    ASSIGN ttTransp.vServ    =
           ttTransp.vBCRet   =
           ttTransp.pICMSRet =
           ttTransp.vICMSRet =
           ttTransp.CFOP     =
           ttTransp.cMunFG   = .
    --------------------------*/

    /* <veicTransp> */
    ASSIGN ttTransp.placa    = REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(REPLACE(nota-fiscal.placa,"-",""),".",""),"/",""),"~\",""),",",""),"*","")," ","")
           ttTransp.UFPlaca  = nota-fiscal.uf-placa
           /*ttTransp.RNTC     =*/ .
           ttTransp.placa    = fn-ajusta-espacos-branco(ttTransp.placa) /*Tratamento para caso haja na placa mais de 1 espaáo em branco*/.

    /* Chave EMS */
    ASSIGN ttTransp.CodEstabelNF = nota-fiscal.cod-estabel
           ttTransp.SerieNF      = nota-fiscal.serie
           ttTransp.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

    /* Ajusta Formatacao dos Campos */
    IF  AVAIL ttTransp THEN DO:
        ASSIGN ttTransp.CNPJ       = REPLACE(ttTransp.CNPJ,"-","")
               ttTransp.CNPJ       = REPLACE(ttTransp.CNPJ,".","")
               ttTransp.CNPJ       = REPLACE(ttTransp.CNPJ,"/","")
               ttTransp.CNPJ       = REPLACE(ttTransp.CNPJ,"~\","")
               ttTransp.CNPJ       = REPLACE(ttTransp.CNPJ,",","").
        ASSIGN ttTransp.CNPJ     = fn-ajusta-tamanho-campo(ttTransp.CNPJ   ,14)
               ttTransp.CPF      = fn-ajusta-tamanho-campo(ttTransp.CPF    ,14)
               ttTransp.IE       = fn-ajusta-tamanho-campo(ttTransp.IE     ,14)
               ttTransp.UF       = fn-ajusta-tamanho-campo(ttTransp.UF     , 2)
               ttTransp.xNome    = fn-ajusta-tamanho-campo(ttTransp.xNome  ,60)
               ttTransp.xEnder   = fn-ajusta-tamanho-campo(ttTransp.xEnder ,60)
               ttTransp.xMun     = fn-ajusta-tamanho-campo(ttTransp.xMun   ,60)
               ttTransp.placa    = fn-ajusta-tamanho-campo(ttTransp.placa  , 8)
               ttTransp.UFPlaca  = fn-ajusta-tamanho-campo(ttTransp.UFPlaca, 2).

    END.   
    /*--------------------------
    /* ttReboque of ttTransp */
    CREATE ttReboque.
    ASSIGN ttReboque.placa =
           ttReboque.RNTC  =
           ttReboque.UF    = .
    --------------------------*/

    /* ttVol     of ttTransp */

    EMPTY TEMP-TABLE tt-nota-embal.
        
        ASSIGN i-tot-qt-volumes = 0  /* quantidade de volumes para rateio */
               de-tot-peso-liq  = 0  /* peso total calculado pelos itens */
               de-tot-peso-bru  = 0. /* peso total calculado pelos itens */

    FOR EACH nota-embal NO-LOCK
        WHERE nota-embal.cod-estabel = nota-fiscal.cod-estabel 
        AND   nota-embal.serie       = nota-fiscal.serie       
        AND   nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis:
        
        CREATE tt-nota-embal.
        ASSIGN tt-nota-embal.rw-nota-embal = ROWID(nota-embal)
               tt-nota-embal.peso-liq-tot  = 0
               tt-nota-embal.peso-bru-tot  = 0
               tt-nota-embal.calculado     = NO. 

        /* calcular o peso pelos itens vinculados na embalagem */
        FOR EACH item-embal NO-LOCK
            WHERE item-embal.cod-estabel = nota-embal.cod-estabel
            AND   item-embal.serie       = nota-embal.serie
            AND   item-embal.nr-nota-fis = nota-embal.nr-nota-fis
            AND   item-embal.sigla-emb   = nota-embal.sigla-emb,

            EACH it-nota-fisc NO-LOCK
            WHERE it-nota-fisc.cod-estabel = item-embal.cod-estabel
            AND   it-nota-fisc.serie       = item-embal.serie
            AND   it-nota-fisc.nr-nota-fis = item-embal.nr-nota-fis
            AND   it-nota-fisc.nr-seq-fat  = item-embal.nr-seq-fat
            AND   it-nota-fisc.it-codigo   = item-embal.it-codigo:

            ASSIGN tt-nota-embal.peso-liq-tot = tt-nota-embal.peso-liq-tot + (it-nota-fisc.peso-liq-fat / it-nota-fisc.qt-faturada[1] * item-embal.dec-1)
                   tt-nota-embal.peso-bru-tot = tt-nota-embal.peso-bru-tot + (it-nota-fisc.peso-bruto / it-nota-fisc.qt-faturada[1] * item-embal.dec-1)
                   tt-nota-embal.calculado    = YES.
        END.
            
        /* se a embalagem nao tem itens, entao acumula qt-volumes para o rateio */
        IF  tt-nota-embal.calculado = NO then
            ASSIGN i-tot-qt-volumes = i-tot-qt-volumes + nota-embal.qt-volumes.

        /* acumula o peso total calculado com base nos itens embalados */
        ASSIGN de-tot-peso-liq  = de-tot-peso-liq + tt-nota-embal.peso-liq-tot
               de-tot-peso-bru  = de-tot-peso-bru + tt-nota-embal.peso-bru-tot.
    END.

    /* s¢ existir† diferenáa se a nota possuir itens n∆o vinculados a embalagens */
    ASSIGN de-dif-peso-liq = nota-fiscal.peso-liq-tot - de-tot-peso-liq
           de-dif-peso-bru = nota-fiscal.peso-bru-tot - de-tot-peso-bru.
    
    IF  de-dif-peso-liq <> 0
    OR  de-dif-peso-bru <> 0 THEN DO:

        ASSIGN de-peso-liq-rateado = 0
               de-peso-bru-rateado = 0.

        /* considerar somente os registros nao vinculados a itens */
        FOR EACH tt-nota-embal
            WHERE tt-nota-embal.calculado = NO,
            
            EACH nota-embal NO-LOCK
            WHERE ROWID(nota-embal) = tt-nota-embal.rw-nota-embal

            BREAK BY nota-embal.qt-volumes:

            /* rateia a diferenáa do peso proporcionalmente † quantidade de volumes */
            ASSIGN tt-nota-embal.peso-liq-tot = nota-embal.qt-volumes / i-tot-qt-volumes * de-dif-peso-liq
                   tt-nota-embal.peso-bru-tot = nota-embal.qt-volumes / i-tot-qt-volumes * de-dif-peso-bru.

            IF  tt-nota-embal.peso-liq-tot = ? THEN
                ASSIGN tt-nota-embal.peso-liq-tot = 0.

            IF  tt-nota-embal.peso-bru-tot = ? THEN
                ASSIGN tt-nota-embal.peso-bru-tot = 0.

            ASSIGN de-peso-liq-rateado = de-peso-liq-rateado + tt-nota-embal.peso-liq-tot
                   de-peso-bru-rateado = de-peso-bru-rateado + tt-nota-embal.peso-bru-tot.

            /* acerta a diferenáa do rateio no registro com maior quantidade de volumes */
            IF  LAST(nota-embal.qt-volumes) THEN
                ASSIGN tt-nota-embal.peso-liq-tot = tt-nota-embal.peso-liq-tot + (de-dif-peso-liq - de-peso-liq-rateado)
                       tt-nota-embal.peso-bru-tot = tt-nota-embal.peso-bru-tot + (de-dif-peso-bru - de-peso-bru-rateado).
        END.
    END.
    
    FOR EACH tt-nota-embal,

        EACH nota-embal NO-LOCK
        WHERE ROWID(nota-embal) = tt-nota-embal.rw-nota-embal:

        FOR FIRST embalag NO-LOCK 
            WHERE embalag.sigla-emb = nota-embal.sigla-emb:
        END.

        CREATE ttVol.
        ASSIGN ttVol.esp   = embalag.descricao WHEN AVAIL embalag
               ttVol.esp   = fn-ajusta-tamanho-campo(ttVol.esp, 60)
               ttVol.marca = nota-fiscal.marca-volume
               ttVol.nVol  = nota-fiscal.nr-volumes
               ttVol.pesoB = tt-nota-embal.peso-bru-tot /* considerar o peso calc por volume */
               ttVol.pesoL = tt-nota-embal.peso-liq-tot /* considerar o peso calc por volume */
               ttVol.qVol  = string(nota-embal.qt-volumes)
               ttVol.qVol  = (IF ttVol.qVol <> ?
                               THEN ttVol.qVol
                              ELSE "")
               .

        /* Chave EMS */
        ASSIGN ttVol.CodEstabelNF = nota-fiscal.cod-estabel
               ttVol.SerieNF      = nota-fiscal.serie
               ttVol.NrNotaFisNF  = nota-fiscal.nr-nota-fis
               ttVol.siglaEmb     = nota-embal.sigla-emb
               .
    END.

    IF  NOT CAN-FIND (FIRST nota-embal
                      WHERE nota-embal.cod-estabel = nota-fiscal.cod-estabel 
                        AND nota-embal.serie       = nota-fiscal.serie       
                        AND nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN DO:

        CREATE ttVol.
        ASSIGN ttVol.pesoB = nota-fiscal.peso-bru-tot
               ttVol.pesoL = nota-fiscal.peso-liq-tot
               ttVol.marca = nota-fiscal.marca-volume
               ttVol.nVol  = nota-fiscal.nr-volumes
               ttVol.qVol  = (IF ttVol.qVol <> ?
                               THEN ttVol.qVol
                              ELSE "") .
               
        /* Chave EMS */
        ASSIGN ttVol.CodEstabelNF = nota-fiscal.cod-estabel
               ttVol.SerieNF      = nota-fiscal.serie
               ttVol.NrNotaFisNF  = nota-fiscal.nr-nota-fis.
    END.
   
    /*--- Integraá∆o com SGT -------------------------------------------------------------------*/
    if  l-funcao-sgt then do:
         
        /*--- Somente segue essa l¢gica se existir o relacionamento entre romaneio e nota-fiscal, 
              caso contr†rio permanece a informaá∆o das notas normais ---*/
        
        IF can-find(first roman-item-nf
                    where roman-item-nf.cod-estab   = nota-fiscal.cod-estabel
                    and   roman-item-nf.cod-serie   = nota-fiscal.serie
                    and   roman-item-nf.nr-nota-fis = nota-fiscal.nr-nota-fis) THEN DO:
        
            /* Elimina a temp-table para recarregar com as informaá‰es originadas do SGT */
            for each ttVol: delete ttVol. end.
            assign dpesoB-sgt = 0
                   dpesoL-sgt = 0
                   iqVol-sgt  = 0
                   cesp-sgt   = ''.
            /*---------------------------------------------------------------------------*/
    
            
            for first roman-item-nf no-lock
                where roman-item-nf.cod-estab   = nota-fiscal.cod-estabel
                and   roman-item-nf.cod-serie   = nota-fiscal.serie
                and   roman-item-nf.nr-nota-fis = nota-fiscal.nr-nota-fis:

                for first roman-faturam no-lock
                    where roman-faturam.num-romaneio = roman-item-nf.nr-romaneio:
                    for each  item-roman-faturam OF roman-faturam no-lock:
                        assign dpesoB-sgt = dpesoB-sgt + item-roman-faturam.val-livre-2
                               dpesoL-sgt = dpesoL-sgt + item-roman-faturam.val-livre-1
                               iqVol-sgt  = roman-faturam.num-livre-1
                               cesp-sgt   = roman-faturam.cod-livre-1.
                    end. /* for first item-roman-faturam */
                end. /* for each roman-faturam no-lock */
            end. /* for first roman-item-nf */
            
            /* Chave EMS */
            CREATE ttVol.
            ASSIGN ttVol.CodEstabelNF = nota-fiscal.cod-estabel
                   ttVol.SerieNF      = nota-fiscal.serie
                   ttVol.NrNotaFisNF  = nota-fiscal.nr-nota-fis
                   ttVol.siglaEmb     = ""
                   ttVol.marca        = nota-fiscal.marca-volume
                   ttVol.nVol         = nota-fiscal.nr-volumes
                   ttVol.pesoB        = dpesoB-sgt 
                   ttVol.pesoL        = dpesoL-sgt 
                   ttVol.qVol         = string(iqVol-sgt)
                   ttVol.esp          = cesp-sgt.
        END. /* END do IF can-find(first roman-item-nf ou do IF can-find(first tab-ocor */
    end. /* if  l-funcao-sgt then do: */
    /*------------------------------------------------------------------- Integraá∆o com SGT ---*/

END PROCEDURE.

PROCEDURE pi-cria-ttCobr:

    /*
    === ttCobr ===
    nFat           AS CHARACTER INITIAL ?  /*N£mero da fatura*/
    vDesc          AS DECIMAL   INITIAL ?  /*Valor do desconto da fatura*/
    vLiq           AS DECIMAL   INITIAL ?  /*Valor l°quido da fatura*/
    vOrig          AS DECIMAL   INITIAL ?  /*Valor original da fatura*/
    
    === ttDup ===
    dVenc          AS DATE      INITIAL ?  /*Data de vencimento da duplicata (AAAA-MM-DD)*/
    nDup           AS CHARACTER INITIAL ?  /*N£mero da duplicata*/
    vDup           AS DECIMAL   INITIAL ?  /*Valor da duplicata*/
    */

    FOR EACH fat-duplic NO-LOCK
       WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel 
         AND fat-duplic.serie       = nota-fiscal.serie       
         AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:

        /* ttDup of ttCobr */
        CREATE ttCobr.
        ASSIGN ttCobr.CodEstabelNF = nota-fiscal.cod-estabel
               ttCobr.SerieNF      = nota-fiscal.serie      
               ttCobr.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

        CREATE ttDup.
        ASSIGN ttDup.dVenc  = fat-duplic.dt-venciment
               ttDup.nDup   = (fat-duplic.nr-fatura + "/" + fat-duplic.parcela)
               ttDup.vDup   = fat-duplic.vl-parcela.

        ASSIGN ttDup.CodEstabelNF = nota-fiscal.cod-estabel
               ttDup.SerieNF      = nota-fiscal.serie      
               ttDup.NrNotaFisNF  = nota-fiscal.nr-nota-fis. 
               
    END.

END PROCEDURE.

PROCEDURE pi-cria-ttInfAdic:

    DEF BUFFER b-nota-fiscal FOR nota-fiscal.

    /*
    === ttInfAdic ===
    infAdFisco     AS CHARACTER INITIAL ?  /*Informaá‰es adicionais de interesse do Fisco*/
    infCpl         AS CHARACTER INITIAL ?  /*Informaá‰es complementares de interesse do Contribuinte*/
    */
    
    IF AVAIL nota-fiscal AND (AVAIL ttIde AND ttIde.tpemis <> "1") THEN DO: /* TODOS QUE S«O DIFERENTE DE 1 S«O CONTIGENCIA */
        FIND b-nota-fiscal EXCLUSIVE-LOCK WHERE ROWID(b-nota-fiscal) = ROWID(nota-fiscal) NO-ERROR.
        IF AVAIL b-nota-fiscal THEN DO:
            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "estabelec"
                AND   reg-inf-compl.cod-campo-inform = "cdn-msg-contingen",
                FIRST inf-compl NO-LOCK
                WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                AND   inf-compl.cod-indice  = b-nota-fiscal.cod-estabel:
                FIND FIRST mensagem NO-LOCK WHERE mensagem.cod-mensagem = inf-compl.num-campo NO-ERROR.
                IF AVAIL mensagem THEN
                    ASSIGN b-nota-fiscal.observ-nota = b-nota-fiscal.observ-nota + mensagem.texto-mensag.
            END.
        END.
    END.

    CREATE ttInfAdic.
    ASSIGN /*ttInfAdic.infAdFisco   = ""*/
           ttInfAdic.infCpl       = REPLACE(nota-fiscal.observ-nota,CHR(10), " ")
           ttInfAdic.infCpl       = REPLACE(ttInfAdic.infCpl,       CHR(13), " ")
           ttInfAdic.infCpl       = REPLACE(ttInfAdic.infCpl,       CHR(9), " ")
           ttInfAdic.infCpl       = IF  lLayoutTXT THEN REPLACE(ttInfAdic.infCpl, "|", "/") ELSE ttInfAdic.infCpl
           ttInfAdic.infCpl       = fn-ajusta-espacos-branco(ttInfAdic.infCpl)
           ttInfAdic.infCpl       = fn-ajusta-tamanho-campo(ttInfAdic.infCpl ,5000).

    /* Chave EMS */
    ASSIGN ttInfAdic.CodEstabelNF = nota-fiscal.cod-estabel
           ttInfAdic.SerieNF      = nota-fiscal.serie
           ttInfAdic.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

END PROCEDURE.

PROCEDURE pi-cria-ttCompra:

    /*
    === ttCompra ===
    xCont          AS CHARACTER INITIAL ?  /*Informaá∆o do contrato*/
    xNEmp          AS CHARACTER INITIAL ?  /*Informaá∆o da Nota de Empenho de compras p£blicas*/
    xPed           AS CHARACTER INITIAL ?  /*Informaá∆o do pedido*/
    */

    CREATE ttCompra.
    ASSIGN /*ttCompra.xCont =*/
           /*ttCompra.xNEmp =*/
           ttCompra.xPed  = nota-fiscal.nr-pedcli
           .

    /*Chave EMS*/
    ASSIGN ttCompra.CodEstabelNF = nota-fiscal.cod-estabel
           ttCompra.SerieNF      = nota-fiscal.serie
           ttCompra.NrNotaFisNF  = nota-fiscal.nr-nota-fis.

END PROCEDURE.

PROCEDURE pi-cria-ttDest-tp-pessoa:

    DEFINE INPUT PARAMETER pc-cep          LIKE emitente.cgc          NO-UNDO. 
    DEFINE INPUT PARAMETER pc-pais         LIKE emitente.pais         NO-UNDO.
    DEFINE INPUT PARAMETER pc-cgc          LIKE emitente.cgc          NO-UNDO.
    DEFINE INPUT PARAMETER pc-ins-estadual LIKE emitente.ins-estadual NO-UNDO.
    DEFINE INPUT PARAMETER pc-estado       LIKE emitente.estado       NO-UNDO.
    DEFINE INPUT PARAMETER pc-bairro       LIKE emitente.bairro       NO-UNDO.
    DEFINE INPUT PARAMETER pc-cidade       LIKE emitente.cidade       NO-UNDO.
    DEFINE INPUT PARAMETER pc-endereco     LIKE emitente.endereco     NO-UNDO.
    DEFINE INPUT PARAMETER pc-nome         LIKE emitente.nome-emit    NO-UNDO.


    ASSIGN c-endereco = pc-endereco
           c-rua      = ""
           c-nro      = ""
           c-comp     = "".
    
    IF  INDEX(c-endereco,CHR(ASC("ß"))) > 0 THEN /* Retirar caracter especial */
        ASSIGN c-endereco = REPLACE(c-endereco,CHR(ASC("ß")),"").
    
    RUN pi-trata-endereco IN h-cdapi704 (INPUT  c-endereco,
                                         OUTPUT c-rua, 
                                         OUTPUT c-nro, 
                                         OUTPUT c-comp).
    
    IF  c-nro = "" THEN
        ASSIGN c-nro = "S/N".
    
    
    /*--- TRATAMENTO FONE - Sefaz aceita somente n£meros, e apenas 11 caracters -> DDD12345678 ---*/
    
    ASSIGN c-fone = "".
    
    DO  i-cont = 1 TO LENGTH(emitente.telefone[1]):
    
        /* Nao considerar o primeiro zero do telefone, caso inicie com 0 (DDD iniciando com 0 ou nro de telefone incorreto) */
        IF  i-cont = 1
        AND LOOKUP(SUBSTRING(emitente.telefone[1],i-cont,1),"0") > 0 THEN NEXT.
    
        IF  LOOKUP(SUBSTRING(emitente.telefone[1],i-cont,1),"0,1,2,3,4,5,6,7,8,9") > 0 THEN
            ASSIGN c-fone = c-fone + SUBSTRING(emitente.telefone[1],i-cont,1).
    END.
    /*---*/
    
    CREATE ttDest.
    ASSIGN ttDest.CEP        = REPLACE(pc-cep,"-","")
           ttDest.CEP        = STRING (pc-cep,"99999999")
           ttDest.cPais      = bf-pais.cod-pais-siscomex
           ttDest.fone       = c-fone
           ttDest.IE         = pc-ins-estadual /* FO 1958776 */
           ttDest.IE         = IF emitente.contrib-icms AND 
                                  i-natureza = 1 AND
                                  ttDest.IE = "isento"  AND
                                  lLayoutTXT THEN ""  /* Pessoa F°sica, contribuinte ICMS -> Isento (no layout TXT, enviar branco) */
                               ELSE ttDest.IE 
           ttDest.IE         = REPLACE(ttDest.IE,"-","")
           ttDest.IE         = REPLACE(ttDest.IE,".","")
           ttDest.IE         = REPLACE(ttDest.IE,"/","")
           ttDest.IE         = REPLACE(ttDest.IE,"~\","")
           ttDest.IE         = REPLACE(ttDest.IE,",","")                                
           ttDest.IE         = (IF ttDest.IE <> ?
                                 THEN ttDest.IE
                                ELSE "")
           ttDest.ISUF       = emitente.cod-suframa
           ttDest.ISUF       = REPLACE(ttDest.ISUF,"-","")
           ttDest.ISUF       = REPLACE(ttDest.ISUF,".","")
           ttDest.ISUF       = REPLACE(ttDest.ISUF,"/","")
           ttDest.ISUF       = REPLACE(ttDest.ISUF,"~\","")
           ttDest.ISUF       = REPLACE(ttDest.ISUF,",","")                                
           ttDest.ISUF       = ttDest.ISUF 
           ttDest.nro        = c-nro
           ttDest.UF         = (IF pc-pais <> "Brasil":U
                                THEN "EX"
                                ELSE pc-estado)
           ttDest.UF         = (IF ttDest.UF <> ?
                                 THEN ttDest.UF
                                ELSE "")
           ttDest.xBairro   = (IF pc-bairro <> ""
                                THEN pc-bairro
                               ELSE "Nao Informado")
           ttDest.xCpl       = c-comp
           ttDest.xLgr       = c-rua
           ttDest.xMun       = (IF pc-pais <> "Brasil":U
                                THEN "Exterior"
                                ELSE pc-cidade)
           ttDest.xNome      = pc-nome
           ttDest.xPais      = pc-pais
           
           .

    IF i-natureza = emitente.natureza THEN
        ASSIGN ttDest.CNPJ       = (IF  emitente.pais <> "Brasil" OR i-natureza = 1 /* Pessoa F°sica */
                                    THEN ""
                                    ELSE emitente.cgc /* Pessoa Juridica */)
               ttDest.CNPJ       =  REPLACE(ttDest.CNPJ,"-","")
               ttDest.CNPJ       =  REPLACE(ttDest.CNPJ,".","")
               ttDest.CNPJ       =  REPLACE(ttDest.CNPJ,"/","")
               ttDest.CPF        = (IF i-natureza = 1 /* Pessoa Fisica */
                                    THEN pc-cgc
                                    ELSE "")
               ttDest.CPF        = (IF ttDest.CPF <> ?
                                     THEN ttDest.CPF
                                    ELSE "")
               ttDest.i-natureza = i-natureza /* 1 - Pessoa F°sica | 2 - Pessoa Jur°dica | 3 - Estrangeiro | 4 - Trading */
               ttDest.cMun       = STRING(IF  pc-pais = "Brasil":U
                                             THEN (IF  i-natureza = 1 /* Pessoa F°sica */
                                                   THEN IF AVAIL bf-cidade-entrega THEN bf-cidade-entrega.cdn-munpio-ibge ELSE 99
                                                   ELSE
                                                        IF AVAIL bf-cidade-emit THEN bf-cidade-emit.cdn-munpio-ibge ELSE 99)
                                             ELSE 9999999).
    ELSE
        ASSIGN ttDest.CNPJ       = (IF  emitente.pais <> "Brasil" OR i-natureza = 1 /* Pessoa F°sica */
                                    THEN ""
                                    ELSE pc-cgc /* Pessoa Juridica */)
               ttDest.CNPJ       =  REPLACE(ttDest.CNPJ,"-","")
               ttDest.CNPJ       =  REPLACE(ttDest.CNPJ,".","")
               ttDest.CNPJ       =  REPLACE(ttDest.CNPJ,"/","")
               ttDest.CPF        = (IF i-natureza = 1 /* Pessoa Fisica */
                                    THEN pc-cgc
                                    ELSE "")
               ttDest.CPF        = (IF ttDest.CPF <> ?
                                     THEN ttDest.CPF
                                    ELSE "")
               ttDest.i-natureza = i-natureza /* 1 - Pessoa F°sica | 2 - Pessoa Jur°dica | 3 - Estrangeiro | 4 - Trading */
               ttDest.cMun       = STRING(IF  pc-pais = "Brasil":U
                                      THEN (IF  i-natureza = 1 /* Pessoa F°sica */
                                            THEN IF AVAIL bf-cidade-entrega THEN bf-cidade-entrega.cdn-munpio-ibge ELSE 99
                                            ELSE
                                                 IF AVAIL bf-cidade-entrega THEN bf-cidade-entrega.cdn-munpio-ibge ELSE 99)
                                      ELSE 9999999).

END PROCEDURE.
              

PROCEDURE pi-calc-zona-franca.

    DEF VAR de-vl-preuni-aux LIKE it-nota-fisc.vl-preuni NO-UNDO.

    ASSIGN  de-qt-fatur = if   it-nota-fisc.ind-fat-qtfam = no 
                          then it-nota-fisc.qt-faturada[1]
                          else it-nota-fisc.qt-faturada[2].


       ASSIGN r-cidade-zf   = ?
              de-conv       = 1
              de-conv-total = 1.

       find first cidade-zf where cidade-zf.cidade = nota-fiscal.cidade
            and   cidade-zf.estado = nota-fiscal.estado no-lock no-error.

       FIND FIRST natur-oper WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao NO-LOCK NO-ERROR.
       
       IF AVAIL cidade-zf AND AVAIL natur-oper THEN DO:
        
           ASSIGN r-cidade-zf = ROWID(cidade-zf).
           
           IF dec(substr(it-nota-fisc.char-1,461,5)) > 0 then
            
               ASSIGN de-conv = (100 - dec(substr(it-nota-fisc.char-1,461,5))) / 100.

       END.
      
        IF AVAIL natur-oper THEN DO:

            if  avail cidade-zf 
             and (dec(substr(it-nota-fisc.char-1,461,5)) > 0 OR 
                 natur-oper.val-perc-desc-pis-zfm    > 0 OR
                 natur-oper.val-perc-desc-cofins-zfm > 0) THEN
                
                 assign de-conv-total = (100 - (dec(substr(it-nota-fisc.char-1,461,5)) +
                                               natur-oper.val-perc-desc-pis-zfm    +
                                               natur-oper.val-perc-desc-cofins-zfm)) / 100.

        END.
                
        ASSIGN de-vl-preuni-aux = IF it-nota-fisc.ind-fat-qtfam = NO 
                                  THEN it-nota-fisc.vl-preuni 
                                  ELSE IF it-nota-fisc.qt-faturada[2] = 0 
                                       THEN it-nota-fisc.vl-merc-liq 
                                       ELSE (it-nota-fisc.vl-merc-liq / it-nota-fisc.qt-faturada[2]).

        /*inicio zfm*/    
        IF  r-cidade-zf <> ? THEN DO: 
            IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                ASSIGN de-vl-unit  = it-nota-fisc.vl-preuni / de-conv-total
                       de-vl-total = ROUND(( ( it-nota-fisc.vl-preuni * de-qt-fatur )/ de-conv-total),2).
            ELSE
                ASSIGN de-vl-unit  = it-nota-fisc.vl-preuni / de-conv 
                       de-vl-total = round( ( (it-nota-fisc.vl-preuni *  de-qt-fatur ) / de-conv),2).

            IF  de-vl-unit = ? THEN
                ASSIGN de-vl-unit = 0.

            IF  de-vl-total = ? THEN
                ASSIGN de-vl-total = 0.

            IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                ASSIGN de-vl-unit-trib  =  ( IF it-nota-fisc.ind-fat-qtfam = NO 
                                           THEN ( it-nota-fisc.vl-preuni / de-conv-total )
                                           ELSE ( ( ( it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[2] ) / de-conv-total ) / it-nota-fisc.qt-faturada[1] ) ).
            ELSE
                ASSIGN de-vl-unit-trib  = ( IF it-nota-fisc.ind-fat-qtfam = NO 
                                           THEN ( it-nota-fisc.vl-preuni / de-conv )
                                           ELSE ( ( ( it-nota-fisc.vl-preuni * it-nota-fisc.qt-faturada[2] ) / de-conv ) / it-nota-fisc.qt-faturada[1] ) ).

            IF  de-vl-unit-trib  = ? THEN
                ASSIGN de-vl-unit-trib  = 0.

            IF  it-nota-fisc.aliquota-ipi <> 0  OR it-nota-fisc.vl-ipi-it    <> 0  OR  nota-fiscal.esp-docto     <> 20 THEN
                IF  it-nota-fisc.vl-despes-it > 0 AND 
                    it-nota-fisc.vl-ipi-it    > 0 AND 
                    it-nota-fisc.cd-trib-ipi <> 3 THEN DO:

                    {ftp/ft0513.i1}  /* Determina valor do IPI */

                    IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                        ASSIGN de-vl-ipi-it = de-vl-ipi-it / de-conv-total.
                    ELSE
                        ASSIGN de-vl-ipi-it = de-vl-ipi-it / de-conv.
                END.
                ELSE
                    IF it-nota-fisc.cd-trib-ipi <> 3 THEN DO:
                        IF  natur-oper.log-deduz-desc-zfm-tot-nf THEN
                            ASSIGN de-vl-ipi-it = it-nota-fisc.vl-ipi-it / de-conv-total.
                        ELSE
                            ASSIGN de-vl-ipi-it = it-nota-fisc.vl-ipi-it / de-conv.
            END.

            ASSIGN de-vl-zfm-tot = de-vl-zfm-tot + de-vl-total.
                
        END. /*Fim ZFM*/

END PROCEDURE.

PROCEDURE pi-TSS-Sincrono:

    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
    
        DEFINE VARIABLE h-TSSAPI             AS HANDLE      NO-UNDO.
        DEFINE VARIABLE hXMLNFe              AS HANDLE      NO-UNDO.
        DEFINE VARIABLE mPtrXMLNFe           AS MEMPTR      NO-UNDO.
        DEFINE VARIABLE lEnvioNotaTSSOK      AS LOGICAL     NO-UNDO.
        DEFINE VARIABLE cReturnValue         AS CHARACTER   NO-UNDO.
        DEFINE VARIABLE cArquivoHistoricoXML AS CHARACTER   NO-UNDO.
        
        ASSIGN lcXMLNFe = "".

        /* RESETA OS VALORES */
        RUN reset IN hGenXml.
        
        /* SETA VALOR DE ENCODING */
        RUN setEncoding IN hGenXml ("UTF-8").

        RUN adapters/xml/ep2/axsep006imprimexml.p (INPUT hGenXml               ,
                                                   INPUT-OUTPUT TABLE ttStack  ,
                                                   INPUT TABLE ttAdi           ,                    
                                                   INPUT TABLE ttArma          ,   
                                                   INPUT TABLE ttAvulsa        ,   
                                                   INPUT TABLE ttCobr          ,   
                                                   INPUT TABLE ttCOFINSAliq    ,   
                                                   INPUT TABLE ttCOFINSNT      ,   
                                                   INPUT TABLE ttCOFINSOutr    ,   
                                                   INPUT TABLE ttCOFINSQtde    ,   
                                                   INPUT TABLE ttCOFINSST      ,   
                                                   INPUT TABLE ttComb          ,   
                                                   INPUT TABLE ttCompra        ,   
                                                   INPUT TABLE ttDest          ,   
                                                   INPUT TABLE ttDet           ,   
                                                   INPUT TABLE ttDI            ,   
                                                   INPUT TABLE ttDup           ,   
                                                   INPUT TABLE ttEmit          ,   
                                                   INPUT TABLE ttEntrega       ,   
                                                   INPUT TABLE ttExporta       ,   
                                                   INPUT TABLE ttICMS00        ,   
                                                   INPUT TABLE ttICMS10        ,   
                                                   INPUT TABLE ttICMS20        ,   
                                                   INPUT TABLE ttICMS30        ,   
                                                   INPUT TABLE ttICMS40        ,   
                                                   INPUT TABLE ttICMS51        ,   
                                                   INPUT TABLE ttICMS60        ,   
                                                   INPUT TABLE ttICMS70        ,   
                                                   INPUT TABLE ttICMS90        ,   
                                                   INPUT TABLE ttICMSTot       ,   
                                                   INPUT TABLE ttIde           ,   
                                                   INPUT TABLE ttII            ,   
                                                   INPUT TABLE ttInfAdic       ,   
                                                   INPUT TABLE ttIPI           ,   
                                                   INPUT TABLE ttISSQN         ,   
                                                   INPUT TABLE ttISSQNtot      ,   
                                                   INPUT TABLE ttLacres        ,   
                                                   INPUT TABLE ttMed           ,   
                                                   INPUT TABLE ttNFe           ,   
                                                   INPUT TABLE ttNFRef         ,   
                                                   INPUT TABLE ttObsCont       ,   
                                                   INPUT TABLE ttObsFisco      ,   
                                                   INPUT TABLE ttPISAliq       ,   
                                                   INPUT TABLE ttPISNT         ,   
                                                   INPUT TABLE ttPISOutr       ,   
                                                   INPUT TABLE ttPISQtde       ,   
                                                   INPUT TABLE ttPISST         ,   
                                                   INPUT TABLE ttProcRef       ,   
                                                   INPUT TABLE ttReboque       ,   
                                                   INPUT TABLE ttRetirada      ,   
                                                   INPUT TABLE ttRetTrib       ,   
                                                   INPUT TABLE ttTransp        ,   
                                                   INPUT TABLE ttVeic          ,   
                                                   INPUT TABLE ttVol).
        
        RUN generateXML IN hGenXml (OUTPUT hXMLNFe).

        /* retirar o inicio do XML "<?xml version="1.0" encoding="utf-8" ?>" */
        /* para nao gerar erro na integraá∆o com o TSS                       */
        hXMLNFe:SAVE("LONGCHAR",lcXMLNFe).
        ASSIGN lcXMLNFe = SUBSTR(lcXMLNFe, INDEX(lcXMLNFe, "<NFe xmlns=")).
        
        IF  NOT lObtemXMLNFe THEN DO: /* efetuar integraá∆o com TSS se lObtemXMLNFe estiver igual a NO */

            IF  NOT AVAIL param-nf-estab THEN
                FOR FIRST param-nf-estab NO-LOCK
                    WHERE param-nf-estab.cod-estabel = nota-fiscal.cod-estabel: END.
    
            IF  NOT AVAIL param-nf-estab THEN
                RETURN "NOK".
    
            /*-------------------UPC Tratamento ANFAVEA-------------------*/
            FOR EACH tt-epc
               WHERE tt-epc.cod-event     = "AtualizaXML":U AND
                     tt-epc.cod-parameter = "hBusinessContent":U:
                DELETE tt-epc.
            END.
            
            CREATE tt-epc.
            ASSIGN tt-epc.cod-event     = "AtualizaXML":U
                   tt-epc.cod-parameter = "hBusinessContent":U
                   tt-epc.val-parameter = STRING(hXMLNFe).
            
            {include/i-epc201.i "AtualizaXML"}
            
            FOR FIRST tt-epc
                WHERE tt-epc.cod-event     = "AtualizaXML":U AND
                      tt-epc.cod-parameter = "hBusinessContentANFAVEA":U:
                ASSIGN hXMLNFe = WIDGET-HANDLE(tt-epc.val-parameter).
            END.
            /*-----------------FIM UPC Tratamento ANFAVEA-----------------*/


			IF OPSYS <> "WIN32" 
			AND CAN-FIND(FIRST funcao NO-LOCK
						 WHERE funcao.cd-funcao = "SPP-XML-OPSYS"
						   AND funcao.ativo) THEN DO:
					
				FIND FIRST ped-curva 
					 WHERE ped-curva.vl-aberto = 160616
					   AND ped-curva.codigo    = 160616 
					   AND ped-curva.nome      = param-nf-estab.cod-estabel NO-LOCK NO-ERROR.
						
				IF AVAIL ped-curva THEN DO:
					ASSIGN cArquivoHistoricoXML = TRIM(ped-curva.char-2).
				END.
			END.
			ELSE
				ASSIGN cArquivoHistoricoXML = &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                                              TRIM(param-nf-estab.cod-dir-histor-xml)
											  &ELSE
                                              TRIM(SUBSTR(param-nf-estab.cod-livre-1,116,100))
											  &ENDIF.
											  
			ASSIGN cArquivoHistoricoXML = REPLACE(cArquivoHistoricoXML,"~\","/").
    
            IF  cArquivoHistoricoXML <> "" THEN DO:
                IF  NOT SUBSTR(cArquivoHistoricoXML,LENGTH(cArquivoHistoricoXML),LENGTH(cArquivoHistoricoXML) - 1) = "/"  THEN
                    ASSIGN cArquivoHistoricoXML = cArquivoHistoricoXML + "/".
                
                ASSIGN cArquivoHistoricoXML =  cArquivoHistoricoXML 
                                             + param-nf-estab.cod-estabel + SUBSTR(ttNFe.ChaveAcessoNFe,23,3) + TRIM(STRING(INTEGER(SUBSTR(ttNFe.ChaveAcessoNFe,26,9)),">>9999999"))
                                             + "/".
    
                ASSIGN FILE-INFO:FILE-NAME = cArquivoHistoricoXML.
                IF  FILE-INFO:FULL-PATHNAME = ? THEN 
                    OS-CREATE-DIR value(cArquivoHistoricoXML) NO-ERROR. /* cria o diretorio caso nao exista */
                
                ASSIGN cArquivoHistoricoXML =   cArquivoHistoricoXML
                                              + STRING(YEAR(TODAY),"9999")              /* ex: 2010   (Ano)       */
                                              + STRING(MONTH(TODAY),"99")               /* ex: 05     (Mes Maio)  */
                                              + STRING(DAY(TODAY),"99")                 /* ex: 01     (Dia)       */
                                              + REPLACE(STRING(TIME,"HH:MM:SS"),":","") /* Ex: 140105 (14h01m05s) */
                                              + ".xml":U.
    
                hXMLNFe:SAVE ('FILE', cArquivoHistoricoXML) NO-ERROR.
            END.
            /*** FIM - GRAVA HISTORICO XML EM DIRETORIO ***/
    
            IF  NOT VALID-HANDLE(h-TSSAPI) THEN DO:
                RUN ftp/ftapi511.p PERSISTENT SET h-TSSAPI. /*API de comunicaªío com o TSS*/
            END.
    
            RUN setTSSURL IN h-TSSAPI (TRIM(param-nf-estab.cod-url-ws-tss)).
                       
            RUN setTSSAuthParam IN h-TSSAPI(INPUT 1,
                                            INPUT "*",
                                            INPUT param-nf-estab.cod-estabel,
                                            INPUT param-nf-estab.cod-url-ws-tss).
    
            EMPTY TEMP-TABLE ttNFETSS.
            EMPTY TEMP-TABLE ttNFETSSRet.
            EMPTY TEMP-TABLE ttNFES4.
            EMPTY TEMP-TABLE TT_LOG_ERRO.
    
            CREATE ttNFETSS.
            ASSIGN ttNFETSS.ID  = ttNFe.ChaveAcessoNFe
                   ttNFETSS.XML = lcXMLNFe.
    
            RUN NFESBRA_REMESSA IN h-TSSAPI (param-nf-estab.ind-empresa, 
                                             INPUT BUFFER ttNFETSS:HANDLE, 
                                             INPUT BUFFER ttNFETSSRet:HANDLE,
                                             YES). /* Criptografa XML BASE64 - Yes/No */
            ASSIGN cReturnValue = RETURN-VALUE.
    
            RUN disconnectTss IN h-TSSAPI ("NFESBRA").
    
            IF  cReturnValue <> "OK" THEN DO:
                CREATE TT_LOG_ERRO.
                ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
    
                /*Busca Mensagem*/
                RUN utp/ut-msgs.p (INPUT "MSG":U,
                                   INPUT 36370,
                                   INPUT "[TSS REMESSA]" + "~~" + cReturnValue).
                ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
    
                /*Busca Help */
                RUN utp/ut-msgs.p (INPUT "HELP":U,
                                   INPUT 36370,
                                   INPUT "[TSS REMESSA]" + "~~" + cReturnValue).
                ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
            END.
            ELSE DO:
                FOR EACH ttNFETSSRet:
                    IF  TRIM(ttNFETSSRet.STR) = TRIM(ttNFe.ChaveAcessoNFe) THEN
                        ASSIGN lEnvioNotaTSSOK = YES.
                END.
        
                IF  NOT lEnvioNotaTSSOK THEN DO:
                    /* NAO CRIOU A NOTA NO TSS, VERIFICAR ATRAVES DO METODO SCHEMA QUAL FOI O MOTIVO DE REJEICAO DA NOTA */
    
                    EMPTY TEMP-TABLE ttNFETSS.
    
                    CREATE ttNFETSS.
                    ASSIGN ttNFETSS.ID  = ttNFe.ChaveAcessoNFe
                           ttNFETSS.XML = lcXMLNFe.
    
                    RUN NFESBRA_SCHEMA  IN h-TSSAPI (param-nf-estab.ind-empresa, 
                                                     INPUT BUFFER ttNFETSS:HANDLE, 
                                                     INPUT BUFFER ttNFES4:HANDLE,
                                                     YES). /* Criptografa XML BASE64 - Yes/No */ 
                    ASSIGN cReturnValue = RETURN-VALUE.
    
                    RUN disconnectTss IN h-TSSAPI ("NFESBRA").
    
                    IF  cReturnValue <> "OK" THEN DO:
    
                        CREATE TT_LOG_ERRO.
                        ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36370.
            
                        /*Busca Mensagem*/
                        RUN utp/ut-msgs.p (INPUT "MSG":U,
                                           INPUT 36370,
                                           INPUT "[TSS SCHEMA]" + "~~" + cReturnValue).
                        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
            
                        /*Busca Help */
                        RUN utp/ut-msgs.p (INPUT "HELP":U,
                                           INPUT 36370,
                                           INPUT "[TSS SCHEMA]" + "~~" + cReturnValue).
                        ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    
                    END.
                    ELSE DO:
                        FOR EACH ttNFES4
                            WHERE ttNFES4.MENSAGEM <> "":
    
                            CREATE TT_LOG_ERRO.
                            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36372.
                
                            /*Busca Mensagem*/
                            RUN utp/ut-msgs.p (INPUT "MSG":U,
                                               INPUT 36372,
                                               INPUT nota-fiscal.nr-nota-fis + "~~" + ttNFES4.MENSAGEM).
                            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
                
                            /*Busca Help */
                            RUN utp/ut-msgs.p (INPUT "HELP":U,
                                               INPUT 36372,
                                               INPUT nota-fiscal.nr-nota-fis + "~~" + ttNFES4.MENSAGEM).
                            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    
                        END.
                        
                        IF  CAN-FIND (FIRST ttNFES4 
                                      WHERE ttNFES4.MENSAGEM <> "") THEN DO:
    
                            {adapters/xml/ep2/axrep012upsert.i}
                            
                            IF  CAN-FIND(funcao WHERE funcao.cd-funcao = "SPP-ATUALIZA-ESTOQUE-NFE" AND funcao.ativo)
                            AND nota-fiscal.dt-confirma <> ? THEN DO:
                                DEFINE VARIABLE h-bodi135 AS HANDLE      NO-UNDO.
    
                                RUN dibo/bodi135.p PERSISTENT SET h-bodi135.
    
                                RUN pi-desatualiza-nfe IN h-bodi135 (INPUT ROWID(nota-fiscal)).
    
                                DELETE PROCEDURE h-bodi135.
                                ASSIGN h-bodi135 = ?.
                            END.
                        END.
                        ELSE DO:
    
                            CREATE TT_LOG_ERRO.
                            ASSIGN TT_LOG_ERRO.TTV_NUM_COD_ERRO  = 36373.
                
                            /*Busca Mensagem*/
                            RUN utp/ut-msgs.p (INPUT "MSG":U,
                                               INPUT 36373,
                                               INPUT nota-fiscal.nr-nota-fis).
                            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_ERRO  = RETURN-VALUE.
                
                            /*Busca Help */
                            RUN utp/ut-msgs.p (INPUT "HELP":U,
                                               INPUT 36373,
                                               INPUT nota-fiscal.nr-nota-fis).
                            ASSIGN TT_LOG_ERRO.TTV_DES_MSG_AJUDA = RETURN-VALUE.
    
                        END. /* ELSE DO : IF  CAN-FIND (FIRST ttNFES4  */
    
                    END. /* ELSE DO: IF  RETURN-VALUE <> "OK" THEN DO: */
                END. /* IF  NOT lEnvioNotaTSSOK THEN DO: */
            END. /* ELSE DO: IF  RETURN-VALUE <> "OK" THEN DO: */
    
            IF  VALID-HANDLE(h-TSSAPI) THEN DO:
                DELETE PROCEDURE h-TSSAPI.
                ASSIGN h-TSSAPI = ?.
            END.

        END. /* Fim - IF  NOT lObtemXMLNFe THEN DO: */

    &ENDIF
    
    RETURN "OK":U.

END PROCEDURE.


/*******************************************************************************************
TODAS AS TEMP-TABLES DE GERAÄ«O DO XML DA NF-e EST«O CONTEMPLADAS NESTA CHAMADA UPC.
PARA MANIPULAÄ«O DAS INFORMAÄÂES, DEVE-SE IMPLEMENTAR AS UPC's UTILIZANDO TêCNICAS DE HANDLE
*******************************************************************************************/
{adapters~/xml~/ep2~/axsep006upc.i} /* pi-executa-upc */

PROCEDURE pi-atualizar-desc-zfm-itens:

    DEF VAR de-vl-desc-zfm      AS DECIMAL  NO-UNDO.
    DEF VAR de-vl-tot-rateio    AS DECIMAL  NO-UNDO.
    DEF VAR de-maior            AS DECIMAL  NO-UNDO.
    DEF VAR rw-maior            AS ROWID    NO-UNDO.

    ASSIGN de-vl-desc-zfm = de-vl-zfm-tot - nota-fiscal.vl-mercad.

    ASSIGN de-vl-tot-rateio = 0
           de-maior         = 0
           rw-maior         = ?.
    
    FOR EACH ttDet
        WHERE ttDet.CodEstabelNF = nota-fiscal.cod-estabel
        AND   ttDet.SerieNF      = nota-fiscal.serie
        AND   ttDet.NrNotaFisNF  = nota-fiscal.nr-nota-fis:

        ASSIGN ttDet.vDesc      = ROUND(ttDet.vProd / de-vl-zfm-tot * de-vl-desc-zfm, 2)
               de-vl-tot-rateio = de-vl-tot-rateio + ttDet.vDesc.

        IF  ttDet.vProd > de-maior THEN
            ASSIGN de-maior = ttDet.vProd
                   rw-maior = ROWID(ttDet).

    END.

    IF  de-vl-desc-zfm <> de-vl-tot-rateio 
    AND rw-maior <> ? THEN DO:
        FIND ttDet WHERE rowid(ttDet) = rw-maior NO-ERROR.
        ASSIGN ttDet.vDesc = ttDet.vDesc + (de-vl-desc-zfm - de-vl-tot-rateio).
    END.

END PROCEDURE.

PROCEDURE pi-carregaEmailDestTransp:
    DEFINE VARIABLE cEmailDest       AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cEmailTransp     AS CHARACTER  NO-UNDO.
    
    /* Integraá∆o TSS */

    /* Quando for integraá∆o TSS (vers∆o layout 1.10) o envio de email Ç  */
    /* efetuado pelo axrep009 (TSS Assincrono) ou axsep009 (TSS Sincrono) */
    
    /* Fim - Integraá∆o TSS */

    /* Integraá∆o Neogrid */
    IF  LOOKUP (cTpTrans, "TSS,TC":U) = 0 THEN DO:

        /* Carrega email destinatario */
        FOR FIRST cont-emit NO-LOCK
            WHERE cont-emit.cod-emitente  = emitente.cod-emitente
            AND   cont-emit.e-mail       <> ""
            AND   &IF '{&bf_dis_versao_ems}' >= '2.09':U 
                  &THEN cont-emit.cdn-aplic-contat
                  &ELSE cont-emit.int-1 
                  &ENDIF = 2:
            ASSIGN cEmailDest = cont-emit.e-mail.
        END.
        /* fim - Carrega email destinatario */
        
        /* Carrega email transportador */
        FOR FIRST transporte NO-LOCK
            WHERE transporte.nome-abrev = nota-fiscal.nome-transp:
    
            FOR FIRST cont-tran NO-LOCK
                WHERE cont-tran.cod-transp  = transporte.cod-transp
                AND   cont-tran.e-mail     <> ""
                AND   &IF '{&bf_dis_versao_ems}' >= '2.09':U 
                      &THEN cont-tran.cdn-aplic-contat
                      &ELSE cont-tran.int-1 
                      &ENDIF = 2:
                ASSIGN cEmailTransp = cont-tran.e-mail.
            END.
    
        END.
        /* fim - Carrega email transportador */

        IF  cEmailDest <> "" THEN DO:
            CREATE ttObsCont.
            ASSIGN ttObsCont.xCampo       = "mailDest":U
                   ttObsCont.xTexto       = cEmailDest
                   /* Chave EMS */
                   ttObsCont.CodEstabelNF = nota-fiscal.cod-estabel  
                   ttObsCont.SerieNF      = nota-fiscal.serie        
                   ttObsCont.NrNotaFisNF  = nota-fiscal.nr-nota-fis.
        END.

        IF  cEmailTransp <> "" THEN DO:
            CREATE ttObsCont.
            ASSIGN ttObsCont.xCampo       = "mailTransp":U
                   ttObsCont.xTexto       = cEmailTransp
                   /* Chave EMS */
                   ttObsCont.CodEstabelNF = nota-fiscal.cod-estabel  
                   ttObsCont.SerieNF      = nota-fiscal.serie        
                   ttObsCont.NrNotaFisNF  = nota-fiscal.nr-nota-fis.
        END.

    END.
    /* Fim - Integraá∆o Neogrid */

END PROCEDURE.

PROCEDURE pi-setaObtemXMLNFe :
    DEFINE INPUT PARAMETER plObtemXMLNFe AS LOGICAL NO-UNDO.

    ASSIGN lObtemXMLNFe = plObtemXMLNFe.
END PROCEDURE.

PROCEDURE pi-retornaXMLNFe :
    &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
        DEFINE OUTPUT PARAMETER plcXMLNFe AS LONGCHAR NO-UNDO.
    
        ASSIGN plcXMLNFe = lcXMLNFe.
    &ELSE
        DEFINE OUTPUT PARAMETER plcXMLNFe AS CHAR NO-UNDO.

        ASSIGN plcXMLNFe = "".
    &ENDIF
END PROCEDURE.
