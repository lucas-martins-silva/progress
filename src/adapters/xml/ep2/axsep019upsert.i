
/*-------------------------------------------------
               axsep027Upsert.i
-------------------------------------------------*/

PROCEDURE PITransUpsert: 

    DEFINE INPUT  PARAMETER pTranAction    AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pTranEvent     AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER pRowidNF       AS ROWID       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt_log_erro.
    
    FOR FIRST nota-fiscal NO-LOCK
        WHERE ROWID(nota-fiscal) = pRowidNF:

        /* NÆo enviar nota cancelada */
        IF  nota-fiscal.dt-cancela  <> ? THEN NEXT.

            IF NOT VALID-HANDLE(h-axsep017) THEN
               RUN adapters/xml/ep2/axsep027.p PERSISTENT SET h-axsep017.
            RUN pi-seta-nota-fiscal    IN h-axsep017 (INPUT ROWID(nota-fiscal)).
            RUN pi-prepara-dados       IN h-axsep017.
            RUN pi-devolve-temp-tables IN h-axsep017 (OUTPUT  TABLE ttAdi         , 
                                                      OUTPUT  TABLE ttArma        , 
                                                      OUTPUT  TABLE ttAutXML      , 
                                                      OUTPUT  TABLE ttAvulsa      , 
                                                      OUTPUT  TABLE ttCobr        , 
                                                      OUTPUT  TABLE ttCOFINSAliq  , 
                                                      OUTPUT  TABLE ttCOFINSNT    , 
                                                      OUTPUT  TABLE ttCOFINSOutr  , 
                                                      OUTPUT  TABLE ttCOFINSQtde  , 
                                                      OUTPUT  TABLE ttCOFINSST    , 
                                                      OUTPUT  TABLE ttICMSUFDest  ,
                                                      OUTPUT  TABLE ttComb        , 
                                                      OUTPUT  TABLE ttCompra      , 
                                                      OUTPUT  TABLE ttDest        , 
                                                      OUTPUT  TABLE ttDet         , 
                                                      OUTPUT  TABLE ttDetExport   , 
                                                      OUTPUT  TABLE ttDI          , 
                                                      OUTPUT  TABLE ttDup         , 
                                                      OUTPUT  TABLE ttEmit        , 
                                                      OUTPUT  TABLE ttEntrega     , 
                                                      OUTPUT  TABLE ttExporta     , 
                                                      OUTPUT  TABLE ttICMS00      , 
                                                      OUTPUT  TABLE ttICMS10      , 
                                                      OUTPUT  TABLE ttICMS20      , 
                                                      OUTPUT  TABLE ttICMS30      , 
                                                      OUTPUT  TABLE ttICMS40      , 
                                                      OUTPUT  TABLE ttICMS51      , 
                                                      OUTPUT  TABLE ttICMS60      , 
                                                      OUTPUT  TABLE ttICMS70      , 
                                                      OUTPUT  TABLE ttICMS90      , 
                                                      OUTPUT  TABLE ttICMSTot     , 
                                                      OUTPUT  TABLE ttIde         , 
                                                      OUTPUT  TABLE ttII          , 
                                                      OUTPUT  TABLE ttImpostoDevol, 
                                                      OUTPUT  TABLE ttInfAdic     , 
                                                      OUTPUT  TABLE ttIPI         , 
                                                      OUTPUT  TABLE ttISSQN       , 
                                                      OUTPUT  TABLE ttISSQNtot    , 
                                                      OUTPUT  TABLE ttLacres      , 
                                                      OUTPUT  TABLE ttMed         , 
                                                      OUTPUT  TABLE ttNFe         , 
                                                      OUTPUT  TABLE ttrefNF       , 
                                                      OUTPUT  TABLE ttObsCont     , 
                                                      OUTPUT  TABLE ttObsFisco    , 
                                                      OUTPUT  TABLE ttPISAliq     , 
                                                      OUTPUT  TABLE ttPISNT       , 
                                                      OUTPUT  TABLE ttPISOutr     , 
                                                      OUTPUT  TABLE ttPISQtde     , 
                                                      OUTPUT  TABLE ttPISST       , 
                                                      OUTPUT  TABLE ttProcRef     , 
                                                      OUTPUT  TABLE ttReboque     , 
                                                      OUTPUT  TABLE ttRetirada    , 
                                                      OUTPUT  TABLE ttRetTrib     , 
                                                      OUTPUT  TABLE ttTransp      , 
                                                      OUTPUT  TABLE ttVeic        , 
                                                      OUTPUT  TABLE ttVol         , 
                                                      OUTPUT  TABLE ttrefNFP      , 
                                                      OUTPUT  TABLE ttrefCTe      , 
                                                      OUTPUT  TABLE ttrefECF      , 
                                                      OUTPUT  TABLE ttICMSPart    , 
                                                      OUTPUT  TABLE ttICMSST      , 
                                                      OUTPUT  TABLE ttICMSSN101   , 
                                                      OUTPUT  TABLE ttICMSSN102   , 
                                                      OUTPUT  TABLE ttICMSSN201   , 
                                                      OUTPUT  TABLE ttICMSSN202   , 
                                                      OUTPUT  TABLE ttICMSSN500   , 
                                                      OUTPUT  TABLE ttICMSSN900   ,
                                                      OUTPUT  TABLE ttCana        ,
                                                      OUTPUT  TABLE ttForDia      ,
                                                      OUTPUT  TABLE ttDeduc       ).

            IF VALID-HANDLE(h-axsep017) THEN DO:
               DELETE PROCEDURE h-axsep017.
               ASSIGN h-axsep017 = ?.
            END.
            
        /* Prepara‡Æo dos dados a serem gerados no XML */
        RUN pi-prepara-dados.
    END.

    /* Gerar XML para Aplica‡Æo TransmissÆo */
    RUN PIUpsert ( INPUT  pTranAction              , /* add / upd */
                   INPUT  pTranEvent               , /* Evento    */
                   INPUT  TABLE ttAdi              , 
                   INPUT  TABLE ttArma             ,
                   INPUT  TABLE ttAutXML           ,
                   INPUT  TABLE ttAvulsa           ,
                   INPUT  TABLE ttCobr             ,
                   INPUT  TABLE ttCOFINSAliq       ,
                   INPUT  TABLE ttCOFINSNT         ,
                   INPUT  TABLE ttCOFINSOutr       ,
                   INPUT  TABLE ttCOFINSQtde       ,
                   INPUT  TABLE ttCOFINSST         ,
                   INPUT  TABLE ttComb             ,
                   INPUT  TABLE ttCompra           ,
                   INPUT  TABLE ttDest             ,
                   INPUT  TABLE ttDet              ,
                   INPUT  TABLE ttDetExport        ,
                   INPUT  TABLE ttDI               ,
                   INPUT  TABLE ttDup              ,
                   INPUT  TABLE ttEmit             ,
                   INPUT  TABLE ttEntrega          ,
                   INPUT  TABLE ttExporta          ,
                   INPUT  TABLE ttICMS00           ,
                   INPUT  TABLE ttICMS10           ,
                   INPUT  TABLE ttICMS20           ,
                   INPUT  TABLE ttICMS30           ,
                   INPUT  TABLE ttICMS40           ,
                   INPUT  TABLE ttICMS51           ,
                   INPUT  TABLE ttICMS60           ,
                   INPUT  TABLE ttICMS70           ,
                   INPUT  TABLE ttICMS90           ,
                   INPUT  TABLE ttICMSTot          ,
                   INPUT  TABLE ttIde              ,
                   INPUT  TABLE ttII               ,
                   INPUT  TABLE ttImpostoDevol     ,
                   INPUT  TABLE ttInfAdic          ,
                   INPUT  TABLE ttIPI              ,
                   INPUT  TABLE ttISSQN            ,
                   INPUT  TABLE ttISSQNtot         ,
                   INPUT  TABLE ttLacres           ,
                   INPUT  TABLE ttMed              ,
                   INPUT  TABLE ttNFe              ,
                   INPUT  TABLE ttrefNF            ,
                   INPUT  TABLE ttObsCont          ,
                   INPUT  TABLE ttObsFisco         ,
                   INPUT  TABLE ttPISAliq          ,
                   INPUT  TABLE ttPISNT            ,
                   INPUT  TABLE ttPISOutr          ,
                   INPUT  TABLE ttPISQtde          ,
                   INPUT  TABLE ttPISST            ,
                   INPUT  TABLE ttProcRef          ,
                   INPUT  TABLE ttReboque          ,
                   INPUT  TABLE ttRetirada         ,
                   INPUT  TABLE ttRetTrib          ,
                   INPUT  TABLE ttTransp           ,
                   INPUT  TABLE ttVeic             ,
                   INPUT  TABLE ttVol              ,
                   INPUT  TABLE ttrefNFP           ,
                   INPUT  TABLE ttrefCTe           ,
                   INPUT  TABLE ttrefECF           ,
                   INPUT  TABLE ttICMSPart         ,
                   INPUT  TABLE ttICMSST           ,
                   INPUT  TABLE ttICMSSN101        ,
                   INPUT  TABLE ttICMSSN102        ,
                   INPUT  TABLE ttICMSSN201        ,
                   INPUT  TABLE ttICMSSN202        ,
                   INPUT  TABLE ttICMSSN500        ,
                   INPUT  TABLE ttICMSSN900        ,
                   INPUT  TABLE ttCana             ,
                   INPUT  TABLE ttForDia           ,
                   INPUT  TABLE ttDeduc            ,
                   INPUT  TABLE ttHeader           ,
                   INPUT  TABLE ttConditionPay     ,
                   INPUT  TABLE ttItem             ,
                   INPUT  TABLE ttEtiqueta         ,
                   INPUT  TABLE ttCallKanban       ,
                   INPUT  TABLE ttInvoiceReferenced,       
                   INPUT  TABLE ttSummary          ,     
                   OUTPUT TABLE tt_log_erro).            
    
    /* ******************************************* */
    /* *************** BODY - END   ************** */
    /* ******************************************* */

END PROCEDURE.

PROCEDURE pi-prepara-dados:
    
    RUN pi-limpa-temp-tables.
    RUN pi-localiza-tabelas.
    RUN pi-grava-temp-tables.

END PROCEDURE.

PROCEDURE pi-localiza-tabelas:

    FOR FIRST emitente NO-LOCK
        WHERE emitente.cod-emitente = nota-fiscal.cod-emitente:
    END.
    
    FOR FIRST bf-natur-oper-nf NO-LOCK
        WHERE bf-natur-oper-nf.nat-operacao = nota-fiscal.nat-operacao:
    END.

    IF  AVAIL bf-natur-oper-nf THEN DO:
        
        &if '{&bf_dis_versao_ems}' >= '2.05':U &then
            FOR FIRST cfop-natur FIELDS(des-cfop) NO-LOCK
                WHERE cfop-natur.cod-cfop = &if defined(bf_dis_formato_CFOP) &then bf-natur-oper-nf.cod-cfop &else SUBSTR(bf-natur-oper-nf.char-1,45,10) &endif:
            END.
        &else
            FOR FIRST ped-curva FIELDS(nome) NO-LOCK
                WHERE ped-curva.it-codigo = &if defined(bf_dis_formato_CFOP) &then bf-natur-oper-nf.cod-cfop &else SUBSTR(bf-natur-oper-nf.char-1,45,10) &endif
                  AND ped-curva.vl-aberto = 620:
            END.
        &endif
    END.

    FOR FIRST cond-pagto FIELDS (descricao cod-vencto cod-cond-pag num-parcelas) NO-LOCK 
        WHERE cond-pagto.cod-cond-pag = nota-fiscal.cod-cond-pag:
    END.

    FOR FIRST estabelec
        WHERE estabelec.cod-estabel = nota-fiscal.cod-estabel NO-LOCK:
    END.
    
END PROCEDURE.

PROCEDURE pi-grava-temp-tables:
    
    RUN pi-cria-ttNFe.
    RUN pi-cria-ttHeader.
    RUN pi-cria-ttConditionPay. 

    FOR EACH it-nota-fisc OF nota-fiscal NO-LOCK:
        RUN pi-cria-ttItem.  
    END.

    RUN pi-cria-ttSummary.

    /* RUN pi-cria-ttCallKanban. */ /* Tag Opcional */
    /*RUN pi-cria-ttInvoiceReferenced. */  /* Tag Opcional */

    RUN pi-executa-upc.

END PROCEDURE.

PROCEDURE pi-limpa-temp-tables:

    EMPTY TEMP-TABLE ttNFe               NO-ERROR.
    EMPTY TEMP-TABLE ttHeader            NO-ERROR.
    EMPTY TEMP-TABLE ttConditionPay      NO-ERROR.
    EMPTY TEMP-TABLE ttItem              NO-ERROR.
    EMPTY TEMP-TABLE ttEtiqueta          NO-ERROR.
    EMPTY TEMP-TABLE ttCallKanban        NO-ERROR.
    EMPTY TEMP-TABLE ttInvoiceReferenced NO-ERROR.
    EMPTY TEMP-TABLE ttSummary           NO-ERROR.
    EMPTY TEMP-TABLE tt_log_erro         NO-ERROR.

END PROCEDURE.

PROCEDURE pi-cria-ttNFe:

    /*
    === ttNFe ===
    CodEstabelNF   AS CHARACTER INITIAL ?
    SerieNF        AS CHARACTER INITIAL ?
    NrNotaFisNF    AS CHARACTER INITIAL ?
    */

    CREATE ttNFe.
    ASSIGN ttNFe.CodEstabelNF   = nota-fiscal.cod-estabel
           ttNFe.SerieNF        = nota-fiscal.serie
           ttNFe.NrNotaFisNF    = nota-fiscal.nr-nota-fis
           ttNFe.ChaveAcessoNFe = TRIM(&IF '{&bf_dis_versao_ems}' >= '2.07':U
                                       &THEN STRING   (nota-fiscal.cod-chave-aces-nf-eletro)
                                       &ELSE SUBSTRING(nota-fiscal.char-2,3,60) &ENDIF)
           ttNFe.VersaoLayout   = TRIM(&IF "{&bf_dis_versao_ems}" >= "2.071"
                                       &THEN TRIM(estabelec.des-vers-layout)
                                       &ELSE TRIM(SUBSTRING(estabelec.char-1,173,10)) &ENDIF)
    .

    ASSIGN iContNota = iContNota + 1.

END PROCEDURE.

PROCEDURE pi-cria-ttHeader:

   /*  numbernf         AS CHARACTER INITIAL ?  Identifica no documento o n£mero da nota fiscal */                                                                                                                                                                                                                                                                                                                                  
   /*  seriesnf         AS CHARACTER INITIAL ?  Identifica no documento a s‚rie da nota fiscal  */                                                                                                                                                                                                                                                                                                                                  
   /*  datetimeoutput   AS DATE      INITIAL ?  Data e hora na qual as mercadorias discriminadas na nota fiscal serÆo despachadas ou embarcadas. O formato utilizado ‚: AAAAMMDDTHHMM */                                                                                                                                                                                                                                            
   /*  datetimedelivery AS DATE      INITIAL ?  Data e hora em que as mercadorias discriminadas na nota fiscal estÆo previstas para serem entregues no destino.O formato utilizado ‚: AAAAMMDDTHHMM */                                                                                                                                                                                                                              
   /*  pricelist        AS CHARACTER INITIAL ?  N£mero da Lista de Pre‡os referente as mercadorias discriminadas na nota fiscal, quando esta for informada pelo fornecedor.  N£mero de referˆncia assinalado para uma Lista de Pre‡o.  Nota EANCOM:  Este c¢digo deve ser utilizado para identificar uma mensagem Cat logo de Produtos/Lista de Pre‡os (PRICAT). */                                                                 
   /*  cfop             AS CHARACTER INITIAL ?  C¢digo fiscal de Opera‡äes e Presta‡äes. Identifica, atrav‚s de um c¢digo, qual a Natureza de Opera‡Æo Fiscal da Nota. Ex.: 5101 (5.101) corresponde a venda de produ‡Æo do estabelecimento. */                                                                                                                                                                                     
   /*  numpucharseorder AS CHARACTER INITIAL ?  N£mero do contrato de compra que est  sendo faturado na respectiva nota fiscal, quando esta nota estiver faturando um £nico pedido de compra. Quando a nota estiver faturando itens de diversos pedidos, a informa‡Æo dever  ser enviada somente nos itens da nota. */                                                                                                                                                                                                                                                                                             
   /*  eanbyer          AS CHARACTER INITIAL ?  EAN DO COMPRADOR (3035: BY - EANCOM) Identifica‡Æo atrav‚s do C¢digo EAN-13 (c¢digos de barras aplicados a locais que ‚ a indica‡Æo da EAN Brasil) do comprador das mercadorias discriminadas no Pedido de Compra. */                                                                                                                                                               
   /*  eancollection    AS CHARACTER INITIAL ?  EAN DO LOCAL DE COBRAN€A DA FATURA (3035: IV - EANCOM) Identifica‡Æo atrav‚s de C¢digo EAN-13 (c¢digos de barras aplicados a  locais que ‚ a indica‡Æo da EAN Brasil) do local de cobran‡a da fatura.  Tipicamente, o local de fatura corresponde ao local indicado pelo comprador para onde deve ser dirigida a cobran‡a, ou que mant‚m a administra‡Æo de pagamentos. */          
   /*  eandelivery      AS CHARACTER INITIAL ?  EAN DO LOCAL DE ENTREGA (3035:DP -EANCOM) Identifica‡Æo atrav‚s de c¢digo EAN-13 (c¢digos de barras aplicados a locais que ‚ a indica‡Æo da EAN Brasil) do Local de Entrega das mercadorias discriminadas na Nota Fiscal. */                                                                                                                                                        
   /*  eanprovider      AS CHARACTER INITIAL ?  EAN DO FORNECEDOR (3035: SU - EANCOM) Identifica‡Æo atrav‚s de c¢digo EAN-13 (c¢digos de barras aplicados a locais que ‚ a indica‡Æo da EAN Brasil) do fornecedor das mercadorias. */                                                                                                                                                                                               
   /*  eaninssuernf     AS CHARACTER INITIAL ?  EAN DO FORNECEDOR (3035: SU - EANCOM) Identifica‡Æo atrav‚s de c¢digo EAN-13 (c¢digos de barras aplicados a locais que ‚ a indica‡Æo da EAN Brasil) do fornecedor das mercadorias. */                                                                                                                                                                                               
   /*  cnpjcollection   AS CHARACTER INITIAL ?  CNPJ DO LOCAL DE COBRAN€A DA FATURA n£mero do CNPJ do local de cobran‡a da fatura. Tipicamente, o local de fatura corresponde ao local indicado pelo comprador para onde deve ser dirigida a cobran‡a, ou que mant‚m a administra‡Æo de pagamentos. */                                                                                                                              
   /*  codplaceDelivery AS CHARACTER INITIAL ?  CODIGO DO LOCAL DE ENTREGA C¢digo da f brica de destino do item. Este c¢digo pode, por exemplo, diferenciar diversas plantas/unidades de neg¢cio da empresa, pertencentes a um mesmo CNPJ.1. */                                                                                                                                                                                     
  
   CREATE ttHeader.
   ASSIGN ttHeader.numbernf           = nota-fiscal.nr-nota-fis                      
          ttHeader.seriesnf           = nota-fiscal.serie                                                
          ttHeader.datetimeoutput     = IF nota-fiscal.dt-embarque = ? THEN TODAY ELSE nota-fiscal.dt-embarque
          ttheader.datetimedelivery   = nota-fiscal.dt-entr-cli
          ttHeader.pricelist          = nota-fiscal.nr-tabpre
          ttHeader.eanbyer            = "" /*emitente.cgc*/                                         
          ttHeader.eancollection      = "" /*emitente.cgc-cob*/                                           
          ttHeader.eandelivery        = "" /*emitente.cgc*/                                        
          ttHeader.eanprovider        = "" /*estabelec.cgc*/                                          
          ttHeader.eaninssuernf       = "" /*estabelec.cgc*/                                         
          ttHeader.cnpjcollection     = emitente.cgc-cob 
          ttHeader.codplacedelivery   = emitente.cgc
          ttHeader.codestabelnf       = nota-fiscal.cod-estabel
          ttHeader.serienf            = nota-fiscal.serie
          ttHeader.nrnotafisnf        = nota-fiscal.nr-nota-fis
          ttHeader.numpucharseorder   = nota-fiscal.nr-pedcli.

    IF TRIM(nota-fiscal.nr-pedcli) = "" THEN         
        ASSIGN ttHeader.numpucharseorder   = "SEM PEDIDO".
    ELSE 
        ASSIGN ttHeader.numpucharseorder   = nota-fiscal.nr-pedcli.

    FOR FIRST natur-oper NO-LOCK 
        WHERE natur-oper.nat-operacao = nota-fiscal.nat-operacao: 
    END.

    IF AVAIL natur-oper THEN
        ASSIGN ttHeader.cfop = &if defined(bf_dis_formato_CFOP) &then natur-oper.cod-cfop &else SUBSTR(natur-oper.char-1,45,10) &endif.

END PROCEDURE.

PROCEDURE pi-cria-ttConditionPay:

       /* conditionpay       AS CHARACTER INITIAL ?  CONDI€ÇO DE PAGAMENTO (4279 - EANCOM) Campo para identifica‡Æo do tipo de condi‡Æo de pagamento que est  sendo aplicada. Vide item 5.8 os conte£dos v lidos. */                                                                                                                                                                                                             
       /* datareference      AS CHARACTER INITIAL ?  REFERÒNCIA DA DATA (2475 - EANCOM) Campo para identifica‡Æo da data de referˆncia a partir da qual ser  contado o prazo de pagamento. Vide Item 5.9 os conte£dos v lidos */                                                                                                                                                                                                 
       /* timereference      AS CHARACTER INITIAL ?  REFERÒNCIA DA DATA (2475 - EANCOM) Campo para identifica‡Æo da data de referˆncia a partir da qual ser  contado o prazo de pagamento. Vide Item 5.9 os conte£dos v lidos REFERÒNCIA DE TEMPO (2009 - EANCOM) C¢digo relacionado a um per¡odo anterior, durante ou posterior … data de referˆncia. Vide Item 5.10 os conte£dos v lidos. */                                   
       /* typeperiod         AS CHARACTER INITIAL ?  Campo que identifica o c¢digo do tipo de per¡odo acordado ou especificado para pagamento. Vide Item 5.11 os conte£dos v lidos. */                                                                                                                                                                                                                                           
       /* periodnum          AS CHARACTER INITIAL ?  Campo para informa‡Æo do n£mero de per¡odos acordado para pagamento de acordo com a codifica‡Æo escolhida no campo Tipo de Per¡odo. */                                                                                                                                                                                                                                      
       /* termduedate        AS DATE      INITIAL ?  Campo para informa‡Æo do n£mero de per¡odos acordado para pagamento de acordo com a codifica‡Æo escolhida no campo Tipo de Per¡odo. Campo para informar a data de vencimento da fatura. O formato utilizado ‚: AAAA-MM */                                                                                                                                                   
       /* billingdatebase    AS DATE      INITIAL ?  DATA BASE DE FATURAMENTO - Data a partir da qual ‚ contado o prazo de pagamento das mercadorias. O formato utilizado ‚: AAAA-MM-DD. */                                                                                                                                                                                                                                      
       /* percenttypecondpay AS CHARACTER INITIAL ?  TIPO DE PERCENTUAL DA CONDI€ÇO DE PAGAMENTO (5245 - EANCOM) Campo utilizado para especificar a porcentagem da parcela de pagamento ou porcentagens que serÆo acrescidas ou abatidas se o pagamento nÆo for efetuado de acordo com as condi‡äes de pagamento. Vide item 5.12 os conte£dos v lidos. */                                                                        
       /* percentcondpay     AS DECIMAL   INITIAL ?  PERCENTUAL DA CONDI€ÇO DE PAGAMENTO (5482 - EANCOM) Campo para informa‡Æo do percentual relativo ao campo anterior */                                                                                                                                                                                                                                                       
       /* typevalcondpay     AS CHARACTER INITIAL ?  TIPO DE VALOR DA CONDI€ÇO DE PAGAMENTO (5025 - EANCOM) Campo utilizado para especificar o valor das parcelas de pagamento ou valores monet rios que serÆo acrescidos ou abatidos se o pagamento nÆo for efetuado de acordo com as condi‡äes de pagamento.Vide Item 5.13 os conte£dos v lidos. */                                                                            
       /* termamount         AS DECIMAL   INITIAL ?  Campo para informa‡Æo do valor a pagar da condi‡Æo de pagamento. */                                                                                                                                                                                                                                                                                                         
       /* duplicatenum       AS CHARACTER INITIAL ?  N£mero da duplicata gerada para pagamento das mercadorias faturadas. */                                                                                                                                                                                                                                                                                                     
       /* codconditionpay    AS CHARACTER INITIAL ?  C¢digo da condi‡Æo de pagamento do cliente no sistema do fornecedor para a respectiva nota fiscal. */                                                                                                                                                                                                                                                                       
     
       DEF VAR d-acum-vl-parcela AS DECIMAL NO-UNDO.
       DEF BUFFER bf-fat-duplic FOR fat-duplic.
     
       FOR EACH  fat-duplic NO-LOCK                                    
           WHERE fat-duplic.cod-estabel = nota-fiscal.cod-estabel      
             AND fat-duplic.serie       = nota-fiscal.serie            
             AND fat-duplic.nr-fatura   = nota-fiscal.nr-fatura:   

           ASSIGN d-acum-vl-parcela = 0.

           FOR EACH  bf-fat-duplic 
               WHERE bf-fat-duplic.cod-estabel = fat-duplic.cod-estabel
                 AND bf-fat-duplic.serie       = fat-duplic.serie
                 AND bf-fat-duplic.nr-fatura   = fat-duplic.nr-fatura NO-LOCK:
                ASSIGN d-acum-vl-parcela = d-acum-vl-parcela + bf-fat-duplic.vl-parcela.  
           END.

           CREATE ttConditionPay.
           ASSIGN ttConditionPay.conditionpay       = IF AVAIL cond-pagto AND cond-pagto.num-parcelas < 2 THEN "1" ELSE "21"
                  ttConditionPay.datareference      = "5"                                                                         
                  ttConditionPay.typeperiod         = "D"                                       
                  ttConditionPay.periodnum          = string(nota-fiscal.nr-parcelas)                                  
                  ttConditionPay.termduedate        = fat-duplic.dt-venciment                   
                  ttConditionPay.percenttypecondpay = "12E"                                       
                  ttConditionPay.percentcondpay     = ((fat-duplic.vl-parcela / d-acum-vl-parcela) * 100)                 
                  ttConditionPay.typevalcondpay     = "262"                                       
                  ttConditionPay.termamount         = fat-duplic.vl-parcela                     
                  ttConditionPay.duplicatenum       = (fat-duplic.nr-fatura + "/" + fat-duplic.parcela)                 
                  ttConditionPay.codconditionpay    = STRING(nota-fiscal.cod-cond-pag)    
                  ttConditionPay.codestabelnf       = nota-fiscal.cod-estabel
                  ttConditionPay.serienf            = nota-fiscal.serie
                  ttConditionPay.nrnotafisnf        = nota-fiscal.nr-nota-fis
                  ttConditionPay.billingdatebase    = nota-fiscal.dt-prvenc. 

           IF nota-fiscal.dt-prvenc = ? THEN 
               ASSIGN ttConditionPay.billingdatebase = fat-duplic.dt-venciment.
           ELSE 
               ASSIGN ttConditionPay.billingdatebase = nota-fiscal.dt-prvenc. 

           IF AVAIL cond-pagto THEN
           CASE cond-pagto.cod-vencto:
                WHEN 0 THEN ASSIGN ttConditionPay.timereference = "1".
                WHEN 1 THEN ASSIGN ttConditionPay.timereference = "3".
                WHEN 2 THEN ASSIGN ttConditionPay.timereference = "1".
                WHEN 3 THEN ASSIGN ttConditionPay.timereference = "1".
                WHEN 4 THEN ASSIGN ttConditionPay.timereference = "1".
                WHEN 5 THEN ASSIGN ttConditionPay.timereference = "4".
                WHEN 6 THEN ASSIGN ttConditionPay.timereference = "10E".
                WHEN 7 THEN ASSIGN ttConditionPay.timereference = "6".
                WHEN 8 THEN ASSIGN ttConditionPay.timereference = "10".
                WHEN 9 THEN ASSIGN ttConditionPay.timereference = "3".
           END CASE. 

       END.

END PROCEDURE.   

PROCEDURE pi-cria-ttItem:
        
       /*  orderline         AS CHARACTER INITIAL ?  Campo que cont‚m o n£mero seqencial da linha de item. N£mero serial designando cada item individual em uma s‚rie de produtos. */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                  
       /*  typecodprod       AS CHARACTER INITIAL ?  Campo utilizado como qualificador do c¢digo do produto. Vide Item 5.14 os conte£dos v lidos. */                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
       /*  itemcode          AS CHARACTER INITIAL ?  Campo utilizado para discrimina‡Æo do c¢digo do produto. Recomenda-se que sejam utilizados os c¢digos padrÆo EAN. */
       /*  prodcodsuppli     AS CHARACTER INITIAL ?  Campo utilizado para discrimina‡Æo do c¢digo do produto do fornecedor. */                                                                                                                                                                                                                                                                                                                                                       
       /*  itemreferencecode AS CHARACTER INITIAL ?  Campo que cont‚m a referˆncia do produto. */
       /*  itemunitofmeasure AS CHARACTER INITIAL ?  Unidade de medida referente … quantidade pedida.  Em que peso (massa), capacidade, comprimento,  rea, volume a quantidade ‚ expressa. Utilizada principalmente em produtos de gramatura nÆo definida na embalagem de consumo (produtos pes veis). */                                                                                                                                               
       /*  orderedquantity   AS DECIMAL   INITIAL ?  Campo utilizado para informa‡Æo da quantidade solicitada pelo comprador da mercadoria. */                                                                                                                                                                                                                                                                                                          
       /*  ponumber          AS CHARACTER INITIAL ?  N£mero do Pedido de Compra do sistema do comprador. */                                                                                                                                                                                                                                                                                                                                             
       /*  providernumber    AS CHARACTER INITIAL ?  NéMERO DO PEDIDO COMPRADOR (1153:ON - EANCOM).  N£mero do Pedido de Compra do sistema do fornecedor. Este campo ser  preenchido quando a nota fiscal se referir a mais de um pedido. Nestes casos, o campo NéMERO DO PEDIDO COMPRADOR do registro CABE€ALHO dever  ser gerado em branco e no registro de itens dever  fazer referˆncia ao pedido respectivo. */                                    
       /*  numorderbuy       AS CHARACTER INITIAL ?  N£mero da Ordem de Compra */                                                                                                                                                                                                                                                                                                                                                                       
       /*  grossweight       AS CHARACTER INITIAL ?  PESO BRUTO DO ITEM (6313:G - EANCOM) Peso (massa) das mercadorias incluindo a embalagem, mas excluindo o equipamento do transportador. */                                                                                                                                                                                                                                                          
       
       DEF VAR c-cod-ean LIKE item-mat.cod-ean NO-UNDO.
    
       FOR FIRST item-fornec NO-LOCK
           WHERE item-fornec.cod-emitente = nota-fiscal.cod-emitente
             AND item-fornec.it-codigo    = it-nota-fisc.it-codigo:
       END.     


       FOR FIRST tab-unidade
           WHERE tab-unidade.un = it-nota-fisc.un-fatur[2] NO-LOCK:
       END.
       
       CREATE ttItem.
       ASSIGN ttItem.orderline          = STRING(it-nota-fisc.nr-seq-fat)               
              ttItem.prodcodsuppli      = it-nota-fisc.it-codigo
              ttItem.itemreferencecode  = it-nota-fisc.cod-refer  
              ttItem.itemunitofmeasure  = string(it-nota-fisc.un-fatur[2])   
              ttItem.descunitmensure    = tab-unidade.descricao WHEN AVAIL tab-unidade
              ttItem.orderedquantity    = DEC(it-nota-fisc.qt-faturada[2]) 
              ttItem.ponumber           = it-nota-fisc.cod-ord-compra   
              ttItem.providernumber     = string(it-nota-fisc.nr-pedido)                  
              ttItem.numorderbuy        = it-nota-fisc.cod-ord-compra   
              ttItem.grossweight        = it-nota-fisc.peso-bruto
              ttItem.codestabelnf       = nota-fiscal.cod-estabel  
              ttItem.serienf            = nota-fiscal.serie        
              ttItem.nrnotafisnf        = nota-fiscal.nr-nota-fis
              ttItem.netunitaryprice    = it-nota-fisc.vl-preuni
              ttItem.itemcode           = ""
              ttItem.typecodprod        = "".            

       /* Fun‡Æo criada para retornar o codigo EAN/DUN utilizado na entrada do pedido de venda EDI
       ** Essa fun‡Æo ‚ necess ria pois o varejo exige que o c¢digo do item na nota fiscal (EAN ou DUN)
       ** seja o mesmo enviado na entrada do pedido. Esta fun‡Æo garante que o c¢digo ser  o do pedido */
       IF CAN-FIND(FIRST funcao
            WHERE funcao.cd-funcao = 'spp-gtin-pv':U
            AND   funcao.ativo     = TRUE) THEN DO:

           FOR FIRST ped-item NO-LOCK
               WHERE ped-item.nome-abrev   = it-nota-fisc.nome-ab-cli  
               AND   ped-item.nr-pedcli    = it-nota-fisc.nr-pedcli    
               AND   ped-item.nr-sequencia = it-nota-fisc.nr-seq-ped   
               AND   ped-item.it-codigo    = it-nota-fisc.it-codigo    
               AND   ped-item.cod-refer    = it-nota-fisc.cod-refer:
               ASSIGN ttItem.typecodprod = "EN"
                      ttItem.itemcode    = SUBSTRING(ped-item.char-2,70,16).
           END.
       END.

       IF ttItem.itemcode = "" THEN DO:
           FOR FIRST item-unid-venda NO-LOCK
               WHERE item-unid-venda.it-codigo = it-nota-fisc.it-codigo
               AND   item-unid-venda.un        = it-nota-fisc.un-fatur[2]
               AND   SUBSTRING(item-unid-venda.char-1,1,200) <> "":

               ASSIGN ttItem.typecodprod = "EN"
                      ttItem.itemcode    = SUBSTRING(item-unid-venda.char-1,1,200).
           END.
           IF NOT AVAIL item-unid-venda THEN DO:
               FOR FIRST item-mat
                   WHERE item-mat.it-codigo = it-nota-fisc.it-codigo
                   AND   item-mat.cod-ean  <> "" NO-LOCK:
                   ASSIGN ttItem.typecodprod = "EN"
                          ttItem.itemcode    = item-mat.cod-ean.
               END.
               IF NOT AVAIL item-mat THEN
                   ASSIGN ttItem.typecodprod = "BP"
                          ttItem.itemcode    = it-nota-fisc.it-codigo.
           END.
       END.

      /*RUN pi-cria-ttEtiqueta.*/ /* Tag Opcional */

END PROCEDURE.

PROCEDURE pi-cria-ttEtiqueta:

    /* conditionunit         AS CHARACTER INITIAL ?  Unidade de condicionamento. */                                                                                                                         
    /* qtdpartsconditionunit AS DECIMAL   INITIAL ?  Quantidade de pe‡as na unidade de condicionamento. */     
    /* numinvoicepackage	 AS CHARACTER INITIAL ?  N£mero da Nota da Embalagem */
    /* serieinvoicepackage   AS CHARACTER INITIAL ?  S‚rie da Nota da Embalagem */
    /* qtdpackage            AS DECIMAL   INITIAL ?  Quantidade de pe‡as condicionamento. */

    FOR EACH  item-embal NO-LOCK                                        
        WHERE item-embal.cod-estabel = it-nota-fisc.cod-estabel          
          AND item-embal.serie       = it-nota-fisc.serie                
          AND item-embal.nr-nota-fis = it-nota-fisc.nr-nota-fis
          AND item-embal.nr-seq-fat  = it-nota-fisc.nr-seq-fat
          AND item-embal.it-codigo   = it-nota-fisc.it-codigo:         
    
        CREATE ttEtiqueta.
        ASSIGN ttEtiqueta.conditionunit         = item-embal.sigla-emb   
               ttEtiqueta.qtdpartsconditionunit = string(item-embal.dec-1)   
               ttEtiqueta.numinvoicepackage     = item-embal.nr-nota-fis
               ttEtiqueta.serieinvoicepackage   = item-embal.serie
               ttEtiqueta.qtdpackage            = string(item-embal.int-1)
               ttEtiqueta.codestabelnf          = nota-fiscal.cod-estabel  
               ttEtiqueta.serienf               = nota-fiscal.serie        
               ttEtiqueta.nrnotafisnf           = nota-fiscal.nr-nota-fis.  

    END.

END PROCEDURE.
                                      
PROCEDURE pi-cria-ttCallKanban:   

    /* numbercall       AS CHARACTER INITIAL ? N£mero da chamada */                                          
    /* datecall         AS DATE      INITIAL ? Data da chamada. O formato utilizado ‚: AAAAMM-DDTHH:MM:SS. */
    /* qtdpackagecall   AS INTEGER   INITIAL ? Quantidade de Embalagens da chamada */                        
    /* qtditenscall     AS INTEGER   INITIAL ? Quantidade de Itens da chamada */     

    /*
    CREATE ttCallKanban.
    ASSIGN ttCallKanBan.numbercall     = ""
           ttCallKanBan.datecall       = ?
           ttCallKanBan.qtdpackagecall = 0
           ttCallKanBan.qtditenscall   = 0
           ttCallKanBan.codestabelnf   = nota-fiscal.cod-estabel  
           ttCallKanBan.serienf        = nota-fiscal.serie        
           ttCallKanban.nrnotafisnf    = nota-fiscal.nr-nota-fis  
    . */

                                
END PROCEDURE.                                      

PROCEDURE pi-cria-ttInvoiceReferenced:  

    /* numinvoicereferenced       AS CHARACTER INITIAL ?  N£mero da nota de Remessa referenciada */    
    /* serieinvoicereferenced     AS CHARACTER INITIAL ?  S‚rie da nota de Remessa referenciada */     
    /* inssuanceinvoicereferenced AS CHARACTER INITIAL ?  EmissÆo da nota de remessa referenciada */   
    /* iteminvoicereferenced      AS CHARACTER INITIAL ?  Item da nota referenciada */                 
    /* valtotservreferenced       AS DECIMAL   INITIAL ?  Valor total do servi‡o referenciado */     

    /*
    CREATE ttInvoiceReferenced.
    ASSIGN ttInvoiceReferenced.numinvoicereferenced       = ""
           ttInvoiceReferenced.serieinvoicereferenced     = ""
           ttInvoiceReferenced.inssuanceinvoicereferenced = ""
           ttInvoiceReferenced.iteminvoicereferenced      = ""
           ttInvoiceReferenced.valtotservreferenced       = 0
           ttInvoiceReferenced.codestabelnf               = nota-fiscal.cod-estabel  
           ttInvoiceReferenced.serienf                    = nota-fiscal.serie        
           ttInvoiceReferenced.nrnotafisnf                = nota-fiscal.nr-nota-fis  
    . */              

END PROCEDURE.              

PROCEDURE pi-cria-ttSummary:  
    
    /* qtdtotpackage   AS DECIMAL INITIAL ?  QUANTIDADE TOTAL DE EMBALAGENS (6069:11 - EANCOM) N£mero total de embalagens de toda a nota fiscal. */                                                        
    /* qtdtotpallets   AS DECIMAL INITIAL ?  QUANTIDADE TOTAL DE PALLETS N£mero total de embalagens de pallets de toda a nota fiscal. */                                                                   
    /* valtotreduction AS DECIMAL INITIAL ?  VALOR TOTAL DE ABATIMENTOS (5025:260 - EANCOM) Campo para informa‡Æo do valor total dos abatimentos das mercadorias. */                                       
    /* valtoticmsred   AS DECIMAL INITIAL ?  VALOR TOTAL DE ICMS COM REDU€ÇO TRIBUTµRIA (5351:ICT - EANCOM) Campo para informa‡Æo do valor total do ICMS com redu‡Æo tribut ria. */                        
    /* valbaseipi      AS DECIMAL INITIAL ?  VALOR BASE DE CµLCULO DO IPI (5351:IPI - EANCOM) Campo para informa‡Æo do valor da base de c lculo do IPI */                                                                                                                         
    /* valtotipi       AS DECIMAL INITIAL ?  VALOR TOTAL DE IPI (5351:IPI - EANCOM) Campo para informa‡Æo do valor total de IPI */

    DEF VAR i-val-tot-embal    AS INTEGER NO-UNDO. 
    DEF VAR i-acumula-icms-it  AS DECIMAL NO-UNDO.
    DEF VAR i-acumula-bicms-it AS DECIMAL NO-UNDO.
    DEF VAR i-acumula-bipi-it  AS DECIMAL NO-UNDO.
    
    ASSIGN i-val-tot-embal = 0.
    FOR EACH  nota-embal NO-LOCK
        WHERE nota-embal.cod-estabel = nota-fiscal.cod-estabel
          AND nota-embal.serie       = nota-fiscal.serie
          AND nota-embal.nr-nota-fis = nota-fiscal.nr-nota-fis:
        ASSIGN i-val-tot-embal = i-val-tot-embal + nota-embal.qt-volumes.
    END.
    
    ASSIGN i-acumula-icms-it  = 0
           i-acumula-bicms-it = 0
           i-acumula-bipi-it  = 0.
    FOR EACH  it-nota-fisc NO-LOCK 
        WHERE it-nota-fisc.cod-estabel = nota-fiscal.cod-estabel
          AND it-nota-fisc.serie       = nota-fiscal.serie
          AND it-nota-fisc.nr-nota-fis = nota-fiscal.nr-nota-fis:
      ASSIGN i-acumula-bicms-it = i-acumula-bicms-it + it-nota-fisc.vl-bicms-it
             i-acumula-icms-it  = i-acumula-icms-it  + it-nota-fisc.vl-icms-it
             i-acumula-bipi-it  = i-acumula-bipi-it  + it-nota-fisc.vl-bipi-it.
    END.
    
    CREATE ttSummary.
    ASSIGN ttSummary.qtdtotpackage   = i-val-tot-embal
           ttSummary.valtotreduction = nota-fiscal.val-desconto-total
           ttSummary.valbaseicmsred  = i-acumula-bicms-it
           ttSummary.valtoticmsred   = i-acumula-icms-it
           ttSummary.valbaseipi      = i-acumula-bipi-it
           ttSummary.valtotipi       = nota-fiscal.vl-tot-ipi
           ttSummary.codestabelnf    = nota-fiscal.cod-estabel  
           ttSummary.serienf         = nota-fiscal.serie        
           ttSummary.nrnotafisnf     = nota-fiscal.nr-nota-fis  
           .

END PROCEDURE.

PROCEDURE pi-devolve-temp-tables:

    DEFINE OUTPUT  PARAM TABLE FOR ttNFe.
    DEFINE OUTPUT  PARAM TABLE FOR ttHeader.           
    DEFINE OUTPUT  PARAM TABLE FOR ttConditionPay.     
    DEFINE OUTPUT  PARAM TABLE FOR ttItem.             
    DEFINE OUTPUT  PARAM TABLE FOR ttEtiqueta.         
    DEFINE OUTPUT  PARAM TABLE FOR ttCallKanban.       
    DEFINE OUTPUT  PARAM TABLE FOR ttInvoiceReferenced.
    DEFINE OUTPUT  PARAM TABLE FOR ttSummary.

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

PROCEDURE pi-setaObtemXMLNFe :
    DEFINE INPUT PARAMETER plObtemXMLNFe AS LOGICAL NO-UNDO.

    ASSIGN lObtemXMLNFe = plObtemXMLNFe.

END PROCEDURE.

PROCEDURE pi-executa-upc:

    FOR EACH tt-epc 
       WHERE tt-epc.cod-event = "AtualizaDados":U :
        DELETE tt-epc.
    END.

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttHeader":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttHeader:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttConditionPay":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttConditionPay:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttItem":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttItem:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttEtiqueta":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttEtiqueta:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttCallKanban":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttCallKanban:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttInvoiceReferenced":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttInvoiceReferenced:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttSummary":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttSummary:HANDLE).
    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "AtualizaDados":U
           tt-epc.cod-parameter = "ttRemessaColab":U
           tt-epc.val-parameter = STRING(TEMP-TABLE ttRemessaColab:HANDLE).

    {include/i-epc201.i "AtualizaDados"}

END PROCEDURE.
