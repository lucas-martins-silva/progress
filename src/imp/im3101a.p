/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3101A 2.00.00.017 } /*** "010017" 23/09/2025 14:33:38  ***/
 
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i IM3101A MIM}
&ENDIF
 
/***** DEFINI€ÇO INCLUDES *****/
{cdp/cdcfgmat.i}
{cdp/cd9900.i5}
{cdp/cd4300.i3}                       /* tratamento atributo livre */
{cxbo/bocx310a.i tt-selecao-despesa}  
{include/boerrtab.i}                  /* tt-bo-erro                */
{imp/im3101.i} /*tt-impostos-despesa*/
{imp/im0100x.i tt-parametros}
{imp/im0091.i}                        /* tt-desp-rateio            */ 
{inbo/boin090.i tt-docum-est-orig}   
{inbo/boin090.i tt-docum-est} 
{include/i-epc200.i im3101a} 
{utp/ut-glob.i}
/******************************/
/***** DEFINI°€O TEMP-TABLES *****/
DEFINE NEW SHARED TEMP-TABLE tt-desp-rateio-dpc NO-UNDO
    field numero-ordem      like ordem-compra.numero-ordem
    field parcela           like prazo-compra.parcela
    field cod-desp          like desp-imp.cod-desp    
    field it-codigo         like ordem-compra.it-codigo
    field val-desp-unit     like cotacao-item-cex.val-desp
    field val-desp-unit-mo  like cotacao-item-cex.val-desp
    field val-desp          like cotacao-item-cex.val-desp
    field val-desp-mo       like cotacao-item-cex.val-desp
    field num-adic            as int
    index codigo is unique primary
        numero-ordem
        parcela
        cod-desp
        num-adic
    index despesa 
        cod-desp.

DEF BUFFER bftipo-tax FOR tipo-tax.
DEF BUFFER bfdocum-est FOR docum-est.
def temp-table tt-parametros-2 no-undo like tt-parametros.
/******************************/

/***** DEFINI°€O VARIæVEIS LOCAIS *****/
DEF VAR i-seq-erro             AS INTEGER NO-UNDO.
DEF VAR h-acomp                AS HANDLE  NO-UNDO.
DEF VAR c-acomp                AS CHAR    NO-UNDO.
DEF VAR h-im3101a1             AS HANDLE  NO-UNDO.    
DEF VAR l-im0101               AS LOG     NO-UNDO.
DEF VAR i-tipo-geracao         AS INT     NO-UNDO.
DEF VAR v_valorGravado         AS DECIMAL NO-UNDO.
DEF VAR v_valorNaoGravado      AS DECIMAL NO-UNDO.
DEF VAR v_valorIsento          AS DECIMAL NO-UNDO.
/******************************/

/***********API FINANCAS****************/
DEF VAR i-empresa             LIKE param-globa.empresa-prin NO-UNDO.
def var h_api_cta             as handle no-undo.
def var v_cod_cta_ctbl        as char no-undo.
def var v_des_cta_ctbl        as char no-undo.
def var v_num_tip_cta_ctbl    as char no-undo.
def var v_num_sit_cta_ctbl    as int no-undo.
def var v_ind_finalid_cta     as char no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "N£mero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistˆncia".
/***************************************/

PROCEDURE setTtSelecao:
    DEFINE INPUT PARAMETER TABLE FOR tt-selecao-despesa.
    DEFINE INPUT PARAMETER TABLE FOR tt-impostos-despesa.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE createNFComplementar:
    /** Gera‡Æo nota fiscal complementar **/
    DEF INPUT  PARAMETER TABLE FOR tt-parametros.
    DEF OUTPUT PARAMETER TABLE FOR tt-docum-est.
    DEF OUTPUT PARAMETER TABLE FOR tt-bo-erro.
    
    FIND FIRST tt-parametros         NO-ERROR.
    FIND FIRST param-global  NO-LOCK NO-ERROR.
    
    EMPTY TEMP-TABLE tt-bo-erro.
    
    IF  NOT VALID-HANDLE (h-im3101a1) 
    OR  h-im3101a1:TYPE      <> "PROCEDURE":U 
    OR  h-im3101a1:FILE-NAME <> "imp/im3101a1.p":U THEN
        RUN imp/im3101a1.p PERSISTENT SET h-im3101a1.
    
    /** ACOMPANHAMENTO **/
    RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
    
    {utp/ut-liter.i Gera‡Æo_NF_Rateio * L}        
    ASSIGN c-acomp = TRIM(RETURN-VALUE).
    
    RUN pi-inicializar IN h-acomp (INPUT c-acomp).
    RUN pi-desabilita-cancela IN h-acomp.
    
    {utp/ut-liter.i Validando_Parƒmetros... * L}
    ASSIGN c-acomp = TRIM(RETURN-VALUE).
    RUN pi-acompanhar in h-acomp (INPUT c-acomp).
    /**********/
    for each tt-parametros break by tt-parametros.embarque:

        RUN validateParameters.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            {imp/im3101a.i}
        END.
            
        FIND FIRST tt-parametros-aux NO-ERROR.

        IF i-pais-impto-usuario = 2 THEN DO:
            RUN ValidaValorGravadoNaoGravadoIsento.
            IF  RETURN-VALUE = "NOK":U THEN DO: 
                {imp/im3101a.i}                 
            END.                       
        END.        

        RUN readParameters.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            {imp/im3101a.i}
        END.                  
    
        {utp/ut-liter.i Gerando_Documento/Itens_Tempor rios... * L}
        ASSIGN c-acomp = TRIM(RETURN-VALUE).
        RUN pi-acompanhar IN h-acomp (INPUT c-acomp).

        create tt-parametros-2.
        buffer-copy tt-parametros to tt-parametros-2.
        
        RUN loadParameters IN h-im3101a1 (INPUT TABLE tt-parametros-2,
                                          INPUT TABLE tt-parametros-aux,
                                          INPUT TABLE tt-docum-est-orig,
                                          INPUT TABLE tt-desp-rateio,   
                                          INPUT TABLE tt-ordens-totais,
                                          INPUT TABLE tt-selecao-despesa,
                                          INPUT TABLE tt-impostos-despesa).
        
        /** Gera apenas uma nf complementar para todos os embarques **/
        if  first (tt-parametros.embarque) then do:
            RUN generateTT-docum-est IN h-im3101a1.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                {imp/im3101a.i}
            END.
        END.
        
        RUN generateTT-item-doc-est IN h-im3101a1.
        IF  RETURN-VALUE = "NOK":U THEN DO:
            {imp/im3101a.i}
        END.   

        IF  LAST (tt-parametros.embarque) THEN DO:        
            {utp/ut-liter.i Gerando_Documento_Recebimento... * L}
            ASSIGN c-acomp = TRIM(RETURN-VALUE).
            RUN pi-acompanhar in h-acomp (INPUT c-acomp).

            RUN piTotalizaDocumento IN h-im3101a1.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                {imp/im3101a.i}
            END.  
        
            RUN generateDocumento IN h-im3101a1.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                {imp/im3101a.i}
            END.  
            
            run setTtDespTotaisEmbarquesMult in h-im3101a1 (input table tt-desp-totais-embarques-mult).
            run generateTT-dupli-apagar-cex  in h-im3101a1.
            if  return-value = "NOK":U then do:
                /** Identifica o embarque que possui erros **/
                {imp/im3101a.i}
            end.    
            
            RUN createImpostos IN h-im3101a1.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                {imp/im3101a.i}
            END.
        END.

        for each tt-parametros-2:
            delete tt-parametros-2.
        end.
        for each tt-parametros-aux:
            delete tt-parametros-aux.
        end.
        for each tt-docum-est-orig:
            delete tt-docum-est-orig.
        end.
        for each tt-desp-rateio:
            delete tt-desp-rateio.
        end.
        for each tt-ordens-totais:
            delete tt-ordens-totais.
        end.
        for each tt-desp-totais:
            delete tt-desp-totais.
        end.
    END.
    
    run getTT-docum-est-im3101a1 in h-im3101a1 (output table tt-docum-est).
    run getTT-bo-erro            in h-im3101a1 (output table tt-bo-erro append).

    IF  VALID-HANDLE (h-im3101a1) THEN DO:
        DELETE PROCEDURE h-im3101a1.
        ASSIGN h-im3101a1 = ?.
    END.

    IF  VALID-HANDLE(h-acomp) THEN
        RUN pi-finalizar IN h-acomp.
    
    RETURN "OK":U.
END PROCEDURE.

PROCEDURE validateParameters:
    /** Valida parƒmetros informados em tela **/
    DEF VAR l-docum                 AS   LOGICAL NO-UNDO.
    DEF VAR l-docum-atual           AS   LOGICAL NO-UNDO.
    
    {rep/re1001a.i50}

    ASSIGN l-im0101 = YES.
    
    /** Valida‡äes gerais **/
    {cxbo/bocx220a.i2 -desp}
    
    IF  CAN-FIND(FIRST tt-bo-erro) THEN
        RETURN "NOK":U.    

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
        
    /** Verifica data do fechamento **/
    FOR estab-mat FIELDS(mensal-ate)
        WHERE estab-mat.cod-estabel = tt-parametros.cod-estabel:
        IF  tt-parametros.da-transacao <= estab-mat.mensal-ate THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            {utp/ut-liter.i Data_de_transa‡Æo * L}
            CREATE tt-bo-erro.
            ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
            {utp/ut-liter.i £ltimo_m‚dio_calculado * L}
            ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "msg":U,
                               INPUT 7744,
                               INPUT tt-bo-erro.parametros).
            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                   tt-bo-erro.cd-erro  = 7744
                   tt-bo-erro.mensagem = RETURN-VALUE.
            RETURN "NOK":U.
        END.
    END.
    
    /** Verifica se natureza de opera‡Æo ‚ de rateio **/
    IF  NOT natur-oper.nota-rateio THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Natureza_de_Opera‡Æo * L}
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        {utp/ut-liter.i Nota_de_Rateio * L}
        ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (input "msg":U,
                           input 17167,
                           input tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 17167
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.
    END.
    
    /** Embarque encerrado **/
    IF  embarque-imp.situacao = 2 THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 6036,
                           INPUT "").
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 6036
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.           
    END.

    /** Cria temp-table auxiliar para parƒmetros **/
    CREATE tt-parametros-aux.
    ASSIGN tt-parametros-aux.cod-estabel       = tt-parametros.cod-estabel
           tt-parametros-aux.embarque          = tt-parametros.embarque
           tt-parametros-aux.consum-final      = natur-oper.consum-final
           tt-parametros-aux.cod-mensagem      = natur-oper.cod-mensagem
           tt-parametros-aux.natur-oper-char-2 = natur-oper.char-2
           tt-parametros-aux.cd-trib-iss       = natur-oper.cd-trib-iss
           tt-parametros-aux.imp-nota          = natur-oper.imp-nota
           tt-parametros-aux.emite-duplic      = natur-oper.emite-duplic.

    FOR FIRST ordens-embarque FIELDS (numero-ordem) NO-LOCK
        WHERE ordens-embarque.cod-estabel = embarque-imp.cod-estabel
          AND ordens-embarque.embarque    = embarque-imp.embarque :
        
        FIND FIRST ordem-compra NO-LOCK
            WHERE ordem-compra.numero-ordem = ordens-embarque.numero-ordem NO-ERROR.
    END.
    
    /** Nao existe ordem relacionada ao embarque **/
    IF  NOT AVAIL ordem-compra THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Ordens_do_Embarque * L}
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.           
    END.

    ASSIGN l-docum       = NO
           l-docum-atual = NO.
    FOR EACH embarq-import-docto FIELDS (cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
        WHERE embarq-import-docto.cod-estab        = embarque-imp.cod-estabel
          AND embarq-import-docto.cod-embarq       = embarque-imp.embarque NO-LOCK,
        FIRST docum-est 
        WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto   
          AND docum-est.nro-docto    = embarq-import-docto.cod-docto       
          AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente    
          AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:

        /* Desconsidera notas fiscais de simples remessa mae */
        IF docum-est.idi-nf-simples-remes = 1 THEN NEXT. 

        {cdp/cd4300.i4 "yes" docum-est.char-1}
        {rep/re1001a.i51 "yes"}

        IF  c-embarque = embarque-imp.embarque THEN DO:
            ASSIGN l-docum = YES.

            IF  docum-est.ce-atual THEN DO: 
                ASSIGN l-docum-atual = YES.

                CREATE tt-docum-est-orig.
                BUFFER-COPY docum-est TO tt-docum-est-orig.
                ASSIGN tt-docum-est-orig.r-rowid = ROWID(docum-est).
            END.
        END.
    END.                               

    IF NOT l-docum THEN DO:
        /* Se nÆo encontrou documento, procura se existe a nota mÆe */
        FOR EACH embarq-import-docto FIELDS (cod-ser-docto cod-docto cdn-emitente cod-natur-operac)
           WHERE embarq-import-docto.cod-estab        = embarque-imp.cod-estabel
             AND embarq-import-docto.cod-embarq       = embarque-imp.embarque NO-LOCK,
           FIRST docum-est 
           WHERE docum-est.serie-docto  = embarq-import-docto.cod-ser-docto   
             AND docum-est.nro-docto    = embarq-import-docto.cod-docto       
             AND docum-est.cod-emitente = embarq-import-docto.cdn-emitente    
             AND docum-est.nat-operacao = embarq-import-docto.cod-natur-operac NO-LOCK:
         
           /* Notas fiscais de simples remessa mae */
           IF docum-est.idi-nf-simples-remes = 1 THEN DO: 
               {cdp/cd4300.i4 "yes" docum-est.char-1}
               {rep/re1001a.i51 "yes"}
         
               IF  c-embarque = embarque-imp.embarque THEN DO:
                   ASSIGN l-docum = YES.
         
                   IF  docum-est.ce-atual THEN DO: 
                       ASSIGN l-docum-atual = YES.
         
                       CREATE tt-docum-est-orig.
                       BUFFER-COPY docum-est TO tt-docum-est-orig.
                       ASSIGN tt-docum-est-orig.r-rowid = ROWID(docum-est).
                   END.
               END.
           END.
        END.
    END.


    /** Nao encontrou documento **/
    IF  NOT l-docum THEN DO:
        assign i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Documento_de_entrada * L}
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (input "msg":U,
                           input 2,
                           input tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.
    END.
    
    /** Documento encontrado nÆo atualizado **/
    IF  NOT l-docum-atual THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Documento_relacionado_ao_Embarque * L}
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        {utp/ut-liter.i atualizado_no_recebimento * L}
        ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (input "msg":U,
                           input 25368,
                           input tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen     = i-seq-erro
               tt-bo-erro.cd-erro      = 25368
               tt-bo-erro.mensagem     = RETURN-VALUE.
        RETURN "NOK":U.
    END.

    RUN validateDespesas.

    IF  RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U. 
    
    RETURN "OK":U.
END PROCEDURE.


procedure validateDespesas:
    /** Valida as despesas que serÆo geradas para a nota complemenetar **/
    DEF VAR h-im0091 AS HANDLE NO-UNDO.
    
    FIND FIRST tt-docum-est-orig NO-ERROR.
    
    /** Rateio Despesas de Importacao **/
    IF  NOT VALID-HANDLE (h-im0091) 
    OR  h-im0091:TYPE      <> "PROCEDURE":U 
    OR  h-im0091:FILE-NAME <> "imp/im0091.p":U THEN 
        RUN imp/im0091.p PERSISTENT SET h-im0091.

    IF tt-parametros.d-cotacao <> 0 THEN                                  
        RUN setaValorCotacao IN h-im0091 (INPUT tt-parametros.d-cotacao).    
        
    RUN setTtSelecaoDespesa IN h-im0091 (INPUT TABLE tt-selecao-despesa).

    
    RUN setaValorinicial    in h-im0091 (INPUT tt-parametros.da-cotacao, 
                                         INPUT tt-docum-est-orig.cod-estabel).

    RUN rateioDocumento     IN h-im0091 (INPUT        tt-docum-est-orig.cod-estabel,
                                         INPUT        tt-parametros.cod-estabel,
                                         INPUT        tt-parametros.embarque,
                                         INPUT        tt-docum-est-orig.serie-docto,
                                         INPUT        tt-docum-est-orig.nro-docto,
                                         INPUT        tt-docum-est-orig.cod-emitente,
                                         INPUT        tt-docum-est-orig.nat-operacao,
                                         INPUT        tt-parametros.cod-emitente-desp,
                                         INPUT        NO,
                                         OUTPUT TABLE tt-desp-rateio).
    
    IF  c-nom-prog-dpc-mg97  <> "" OR 
        c-nom-prog-appc-mg97 <> "" OR 
        c-nom-prog-upc-mg97  <> "" THEN DO:

         FOR EACH tt-epc WHERE tt-epc.cod-event = "corrige-tt":U:
             DELETE tt-epc.
         END.

         FOR EACH tt-desp-rateio-dpc EXCLUSIVE-LOCK:
             DELETE tt-desp-rateio-dpc.
         END.
         
         FOR EACH tt-desp-rateio NO-LOCK:
             CREATE tt-desp-rateio-dpc.
             BUFFER-COPY tt-desp-rateio TO tt-desp-rateio-dpc.
         END.

         CREATE tt-epc.
         ASSIGN tt-epc.cod-event     = "corrige-tt":U
                tt-epc.cod-parameter = "tt-desp-rateio":U
                tt-epc.val-parameter = STRING(TEMP-TABLE tt-desp-rateio:HANDLE).
         
         {include/i-epc201.i "corrige-tt"}

         FOR EACH tt-desp-rateio EXCLUSIVE-LOCK:
             DELETE tt-desp-rateio.
         END.

         FOR EACH tt-desp-rateio-dpc NO-LOCK:
             CREATE tt-desp-rateio.
             BUFFER-COPY tt-desp-rateio-dpc TO tt-desp-rateio.
         END.

     END.
    
    RUN getTTdesp-totais    in h-im0091 (OUTPUT TABLE tt-desp-totais).
    RUN getTTordens-totais  in h-im0091 (OUTPUT TABLE tt-ordens-totais).
    RUN getTTbo-erro        in h-im0091 (OUTPUT TABLE tt-bo-erro).

    CREATE tt-epc.
    ASSIGN tt-epc.cod-event     = "atualizar-rateio":U
           tt-epc.cod-parameter = "tt-desp-rateio":U
           tt-epc.val-parameter = STRING(TEMP-TABLE tt-desp-rateio:HANDLE).
   
    IF  VALID-HANDLE (h-im0091) THEN DO:
        DELETE PROCEDURE h-im0091.
        ASSIGN h-im0091 = ?.
    end.

    IF  CAN-FIND(first tt-bo-erro) THEN
        RETURN "NOK":U.
    
    FOR EACH tt-desp-totais:
        FIND FIRST tt-desp-totais-embarques-mult
            WHERE tt-desp-totais-embarques-mult.cod-desp          = tt-desp-totais.cod-desp
              AND tt-desp-totais-embarques-mult.cod-emitente-desp = tt-desp-totais.cod-emitente-desp NO-ERROR.
        IF  NOT AVAIL tt-desp-totais-embarques-mult THEN DO:
            CREATE tt-desp-totais-embarques-mult.
            BUFFER-COPY tt-desp-totais EXCEPT val-desp val-desp-mo TO tt-desp-totais-embarques-mult .
        END.
        ASSIGN tt-desp-totais-embarques-mult.val-desp    = tt-desp-totais-embarques-mult.val-desp    + tt-desp-totais.val-desp    + tt-desp-totais.val-desp-isento
               tt-desp-totais-embarques-mult.val-desp-mo = tt-desp-totais-embarques-mult.val-desp-mo + tt-desp-totais.val-desp-mo + tt-desp-totais.val-desp-isento-mo.
    end.
    
    IF  NOT CAN-FIND(FIRST tt-desp-rateio) THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        {utp/ut-liter.i Embarque * L}
        CREATE tt-bo-erro.
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        {utp/ut-liter.i despesa_complementar * L}
        ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + "~~" + TRIM(RETURN-VALUE) + "~~" + tt-parametros.embarque.
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT &if "{&bf_mat_versao_ems}":U >= "2.04":U &then 29348 &else 1342 &endif,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = &if "{&bf_mat_versao_ems}":U >= "2.04":U &then 29348 &else 1342 &endif
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.
    END.
    
    FIND FIRST tt-desp-totais NO-ERROR.
    ASSIGN tt-parametros-aux.mo-codigo    = tt-desp-totais.mo-codigo
           tt-parametros-aux.cod-cond-pag = tt-desp-totais.cod-cond-pag.

    FOR EACH  historico-embarque FIELDS(dt-efetiva cod-pto-contr)
        WHERE historico-embarque.cod-estabel = tt-parametros.cod-estabel
        AND   historico-embarque.embarque    = tt-parametros.embarque NO-LOCK 
        USE-INDEX codigo:

        IF  historico-embarque.cod-pto-contr = tt-desp-totais.cod-pto-contr THEN
            ASSIGN tt-parametros-aux.da-partida = historico-embarque.dt-efetiva.
    END.
    
    /** Encontra cotacao que sera utilizada **/
    IF tt-parametros.d-cotacao = 0 THEN DO:
        FIND FIRST cotacao
            WHERE cotacao.mo-codigo   = tt-parametros-aux.mo-codigo
              AND cotacao.ano-periodo = STRING(YEAR(tt-parametros.da-cotacao)) 
                                      + STRING(MONTH(tt-parametros.da-cotacao),"99")
            AND cotacao.cotacao[INT(DAY(tt-parametros.da-cotacao))] <> 0 NO-LOCK NO-ERROR.
        IF  NOT AVAIL cotacao THEN DO:
            IF  tt-parametros-aux.mo-codigo <> 0 then do:
                ASSIGN i-seq-erro = i-seq-erro + 1.
                CREATE tt-bo-erro.
                ASSIGN tt-bo-erro.parametros = STRING(tt-parametros-aux.mo-codigo) 
                                             + "~~" + STRING(tt-parametros.da-cotacao).
                RUN utp/ut-msgs.p (input "msg":U,
                                   input 1847,
                                   input tt-bo-erro.parametros).
                ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                       tt-bo-erro.cd-erro  = 1847
                       tt-bo-erro.mensagem = RETURN-VALUE.
                RETURN "NOK":U.
            END.
            ELSE
                ASSIGN tt-parametros-aux.cotacao-dia = 1.
        END.
        ELSE
            ASSIGN tt-parametros-aux.cotacao-dia = cotacao.cotacao[int(day(tt-parametros.da-cotacao))].
    END.
    ELSE
        ASSIGN tt-parametros-aux.cotacao-dia = tt-parametros.d-cotacao.
        
    IF  NOT CAN-FIND(FIRST cond-pagto
                     where cond-pagto.cod-cond-pag = tt-parametros-aux.cod-cond-pag) THEN DO:
        
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        {utp/ut-field.i mgcex desp-embarque cod-cond-pag 1}
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE) + "~~" + STRING(tt-parametros-aux.cod-cond-pag).
        RUN utp/ut-msgs.p (INPUT "msg":U,
                           INPUT 2,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.                
    end.
            
    RETURN "OK":U.
END PROCEDURE.


PROCEDURE readParameters:
    FOR FIRST tt-selecao-despesa :
        FOR FIRST desp-imp FIELDS (cod-espec-padr tp-despesa)
            WHERE desp-imp.cod-desp = tt-selecao-despesa.cod-desp NO-LOCK:
            ASSIGN tt-parametros-aux.tp-despesa = desp-imp.tp-despesa.
        END.
    END.

    IF tt-parametros.nff THEN
        ASSIGN tt-parametros-aux.esp-tit-rec = IF AVAIL desp-imp THEN desp-imp.cod-espec-padr
                                               ELSE "".
    ELSE
        FOR FIRST param-re FIELDS (esp-def-dup seq-item-um inc-seq)
            WHERE param-re.usuario = tt-parametros.usuario NO-LOCK:
            ASSIGN tt-parametros-aux.esp-tit-rec = param-re.esp-def-dup.
        END.

    FOR FIRST espec-ap FIELDS ( tipo ) 
        WHERE espec-ap.cod-esp = tt-parametros-aux.esp-tit-rec NO-LOCK:
    END.
    IF NOT AVAIL espec-ap THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        {utp/ut-liter.i Esp‚cie_T¡tulo *}
        ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 2,
                           INPUT tt-bo-erro.parametros).
        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
               tt-bo-erro.cd-erro  = 2
               tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.
    END.
        
    IF NOT AVAIL param-re THEN
        FOR FIRST param-re FIELDS(seq-item-um inc-seq) 
            WHERE param-re.usuario = tt-parametros.usuario NO-LOCK:
            ASSIGN tt-parametros-aux.seq-item-um = param-re.seq-item-um
                   tt-parametros-aux.inc-seq     = param-re.inc-seq.
        END.
    
    FOR FIRST estabelec FIELDS(estado cidade pais)
        WHERE estabelec.cod-estabel = tt-parametros.cod-estabel NO-LOCK:
        ASSIGN tt-parametros-aux.estado-estab = estabelec.estado
               tt-parametros-aux.cidade       = estabelec.cidade
               tt-parametros-aux.pais         = estabelec.pais.
    END.
    
    FOR FIRST emitente FIELDS(tp-desp-padrao nome-abrev natureza estado char-1
                              portador modalidade portador-ap modalidade-ap)
        WHERE emitente.cod-emitente = tt-parametros.cod-emitente-desp NO-LOCK:

        RUN pi-busca-portador-modalidade (BUFFER emitente,
                                          OUTPUT i-portador-emit,
                                          OUTPUT i-modalidade-emit).

        ASSIGN tt-parametros-aux.portador   = i-portador-emit   
               tt-parametros-aux.modalidade = i-modalidade-emit
               tt-parametros.estado-emit    = emitente.estado
               tt-parametros-aux.nome-abrev = emitente.nome-abrev
               tt-parametros-aux.natureza   = emitente.natureza.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE valorGravadoNaoGravadoIsento:
    DEF INPUT PARAMETER valorGravado    AS DECIMAL NO-UNDO.
    DEF INPUT PARAMETER valorNaoGravado AS DECIMAL NO-UNDO.
    DEF INPUT PARAMETER valorIsento     AS DECIMAL NO-UNDO.

    ASSIGN 
        v_valorGravado    = valorGravado    
        v_valorNaoGravado = valorNaoGravado 
        v_valorIsento     = valorIsento.    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE ValidaValorGravadoNaoGravadoIsento:
    DEFINE VARIABLE totalDespesas AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE totalBaseIVA AS DECIMAL     NO-UNDO.

    IF tt-parametros.nff THEN DO:
        ASSIGN totalDespesas = 0.

        FOR EACH tt-selecao-despesa :
            ASSIGN totalDespesas = totalDespesas + tt-selecao-despesa.val-desp.
        END.

        IF totalDespesas <> (v_valorGravado + v_valorNaoGravado + v_valorIsento) THEN DO:
            ASSIGN i-seq-erro = i-seq-erro + 1.
            CREATE tt-bo-erro.
            {utp/ut-liter.i "A_suma_dos_valores_Gravado,_NÆo_Gravado_e_Isento" *}
                ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE) + "~~".

            {utp/ut-liter.i "total_das_despesas" *}
                ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + TRIM(RETURN-VALUE).

            RUN utp/ut-msgs.p (INPUT "MSG":U,
                               INPUT 17399,
                               INPUT tt-bo-erro.parametros).

            ASSIGN tt-bo-erro.i-sequen = i-seq-erro
                tt-bo-erro.cd-erro  = 17399
                tt-bo-erro.mensagem = RETURN-VALUE.
            RETURN "NOK":U.
        END.
    END.
    
    ASSIGN totalBaseIVA = 0.
    FOR EACH tt-impostos-despesa,
        FIRST tipo-tax NO-LOCK WHERE tipo-tax.cod-tax = tt-impostos-despesa.cod-tax:
        IF tipo-tax.tipo = 2 /* IVA */ AND tipo-tax.perc-percepcao = 0 THEN
            ASSIGN totalBaseIVA = totalBaseIVA + tt-impostos-despesa.vl-base-me.
    END.
    IF totalBaseIVA <> v_valorGravado  THEN DO:
        ASSIGN i-seq-erro = i-seq-erro + 1.
        CREATE tt-bo-erro.
        {utp/ut-liter.i "Valor_Total_da_Base_de_Imposto_IVA" *}
            ASSIGN tt-bo-erro.parametros = TRIM(RETURN-VALUE) + "~~".

        {utp/ut-liter.i "Valor_Total_Gravado" *}
            ASSIGN tt-bo-erro.parametros = tt-bo-erro.parametros + TRIM(RETURN-VALUE).

        RUN utp/ut-msgs.p (INPUT "MSG":U,
                           INPUT 5955,
                           INPUT tt-bo-erro.parametros).

        ASSIGN tt-bo-erro.i-sequen = i-seq-erro
            tt-bo-erro.cd-erro  = 5955
            tt-bo-erro.mensagem = RETURN-VALUE.
        RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCalculaImposto:
    DEF INPUT        PARAMETER pcod-tax      LIKE tipo-tax.cod-tax  NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER ptax-perc     LIKE tipo-tax.tax-perc NO-UNDO.
    DEF INPUT        PARAMETER pBaseImposto  AS DECIMAL             NO-UNDO.
    DEF OUTPUT       PARAMETER pValorImposto AS DECIMAL             NO-UNDO.
    
    FOR FIRST tipo-tax NO-LOCK
        WHERE tipo-tax.cod-tax = pcod-tax:
        IF ptax-perc = 0 THEN DO:
            IF tipo-tax.tipo = 2 /* IVA */ AND tipo-tax.perc-percepcao <> 0 THEN
                ASSIGN ptax-perc =  tipo-tax.perc-percepcao.
            ELSE
                ASSIGN ptax-perc = tipo-tax.tax-perc.
        END.

        ASSIGN pValorImposto  = pBaseImposto * ( ptax-perc / 100).
    END.    

    RETURN "OK":U.
END PROCEDURE.

PROCEDURE piCalculaBaseRetencaoIVA:
    DEF INPUT        PARAMETER TABLE FOR tt-impostos-despesa.
    DEF INPUT        PARAMETER pcod-tax      LIKE tipo-tax.cod-tax  NO-UNDO.
    DEF INPUT-OUTPUT PARAMETER pBaseImposto  AS DECIMAL             NO-UNDO.
    
    FOR FIRST tipo-tax NO-LOCK
        WHERE tipo-tax.cod-tax = pcod-tax:
        
        IF tipo-tax.tipo = 1 /* Reten‡Æo */ AND tipo-tax.idi-val-base-retenc = 2 THEN DO:

            ASSIGN pBaseImposto = 0.

            FOR EACH tt-impostos-despesa NO-LOCK,
               FIRST bftipo-tax NO-LOCK
               WHERE bftipo-tax.cod-tax = tt-impostos-despesa.cod-tax
                 AND bftipo-tax.tipo    = 2 :
                ASSIGN pBaseImposto = pBaseImposto + tt-impostos-despesa.vl-imposto-me.
            END.

        END.

    END.    

    RETURN "OK":U.
END PROCEDURE.
