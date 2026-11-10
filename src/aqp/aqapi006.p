/********************************************************************************
** Copyright DATASUL S.A. (2017)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************
**
**       Programa: AQAPI006
**
**       Objetivo: Geracao de duplicatas, eventos financeiros e tabela de notas x fechamento
**       Cria‡Æo: 05/05/2017
**
*****************************************************************************/

{include/i-prgvrs.i AQAPI006 2.00.00.013 } /*** "010013" 03/03/2026 08:23:53 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AQAPI006 MAQ}
&ENDIF

DEFINE TEMP-TABLE ttRowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

{dibo/bodi515.i tt-nota-fisc-adc}
{aqp/aqapi004.i}
{aqp/aqapi004.i1} /* Definicao  tt-retorno-nota tt-erro-imp tt-fechto-docto Shared */
{method/dbotterr.i}  /*--- Include com defini‡Æo da temp-table RowErrors ---*/
{inbo/boin092.i tt-dupli-apagar}

{cdp/cd9701.i}   /* ? */
{cdp/cdcfgdis.i} /* ? */
{utp/ut-glob.i}  /* ? */
{cdp/cdcfgmat.i} /* ? */

{cdp/cd4400.i} /* pi-traduz-empresa-estab-pais */ /* pi-busca-tipo-imposto */

DEFINE SHARED VARIABLE h-acomp AS HANDLE NO-UNDO.

DEFINE VARIABLE l-erro                   AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE c-erro                   AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE de-total-item            LIKE item-doc-est.preco-total[1]    NO-UNDO.
DEFINE VARIABLE c-it-codigo              LIKE item-doc-est.it-codigo         NO-UNDO.
DEFINE VARIABLE h-movto-event-fin        AS HANDLE                           NO-UNDO.
DEFINE VARIABLE c_tta_des_movto_event    AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE v_hld_dbo                AS HANDLE                           NO-UNDO.
DEFINE VARIABLE i-tipo-nf                AS INT                              NO-UNDO.
DEFINE VARIABLE i_tta_num_id_movto_event AS INT                              NO-UNDO.
DEFINE VARIABLE c_des_movto_event        AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE d-tot-qualid             AS DECIMAL                          NO-UNDO.

DEFINE BUFFER   bf-aux-docum-est  FOR docum-est.
DEFINE BUFFER   bf-novo-docum-est FOR docum-est.
DEFINE BUFFER   bf-docum-est      FOR docum-est.


PROCEDURE pi-execute:

    DEFINE INPUT PARAM p-serie-docto  LIKE docum-est.serie-docto  NO-UNDO.
    DEFINE INPUT PARAM p-nro-docto    LIKE docum-est.nro-docto    NO-UNDO.
    DEFINE INPUT PARAM p-cod-emitente LIKE docum-est.cod-emitente NO-UNDO.
    DEFINE INPUT PARAM p-nat-operacao LIKE docum-est.nat-operacao NO-UNDO.

    DEFINE VARIABLE c-texto AS CHARACTER NO-UNDO.

    FIND FIRST param-global NO-LOCK NO-ERROR.

    /*gera‡Æo de eventos*/
    RUN prgfin/apb/apb061za.p PERSISTENT SET h-movto-event-fin.

    {utp/ut-liter.i Efetivando_nota_do_produtor:_ *}
    ASSIGN c-texto = RETURN-VALUE.

    RUN pi-acompanhar in h-acomp (INPUT c-texto + STRING(p-cod-emitente)).

    DEFINE VARIABLE de-qtd-item AS DECIMAL NO-UNDO.

    blk_integra:  
    DO TRANSACTION ON ERROR UNDO, RETURN "NOK":U:

        /*--- Se encontrar o docum-est, entao eh pq gerou a tabela sem erros no reapi316b.
              Gera duplicatas e impostos posteriormente por nÆo ter o valor a pagar antes de mandar a temp-table para a reapi316b ---*/
        FOR FIRST docum-est FIELDS (serie-docto cod-emitente nat-operacao nro-docto) NO-LOCK
            WHERE docum-est.serie-docto  = p-serie-docto
              AND docum-est.nro-docto    = p-nro-docto
              AND docum-est.cod-emitente = p-cod-emitente
              AND docum-est.nat-operacao = p-nat-operacao, 
            FIRST tt-fechto-docto                                                  
            WHERE tt-fechto-docto.serie-docto  = docum-est.serie-docto         
              AND tt-fechto-docto.cod-emitente = docum-est.cod-emitente        
              AND tt-fechto-docto.nat-operacao = docum-est.nat-operacao        
              AND tt-fechto-docto.nro-docto    = docum-est.nro-docto:
            
            ASSIGN de-total-item = 0
                   de-qtd-item   = 0.

            IF docum-est.cod-finalidade = "3":U THEN /*NF do tipo complementar*/
                ASSIGN i-tipo-nf = 1.

            FOR FIRST emitente FIELDS(nome-abrev)
                WHERE emitente.cod-emitente = docum-est.cod-emitente NO-LOCK: END.

            /*--- Atualiza rat-lote com a quantidade conferida ---*/
            /*soma qtd item para somar na quant-fornec-produt*/
            FOR EACH item-doc-est NO-LOCK
               WHERE item-doc-est.serie-docto  = docum-est.serie-docto
                 AND item-doc-est.cod-emitente = docum-est.cod-emitente
                 AND item-doc-est.nro-docto    = docum-est.nro-docto
                 AND item-doc-est.nat-operacao = docum-est.nat-operacao:

                /* Conta Cont bil nÆo informada */
                IF item-doc-est.ct-codigo = "" AND docum-est.cod-finalidade <> "3":U /* Nota Complementar */ THEN DO:
                  RUN utp/ut-msgs.p (INPUT "help":U, 
                                     INPUT 55439,
                                     INPUT docum-est.cod-estabel).
                  CREATE tt-erro-imp.
                  ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
                         tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U
                         tt-erro-imp.cd-erro          = 55439
                         tt-erro-imp.desc-erro        = TRIM(RETURN-VALUE).

                  UNDO blk_integra, RETURN "NOK":U.
                END.

                ASSIGN de-total-item = de-total-item + item-doc-est.preco-total[1]
                       de-qtd-item   = de-qtd-item   + item-doc-est.quantidade.

                FOR FIRST rat-lote EXCLUSIVE-LOCK
                    WHERE rat-lote.serie-docto  = item-doc-est.serie-docto
                      AND rat-lote.nro-docto    = item-doc-est.nro-docto
                      AND rat-lote.nat-operacao = item-doc-est.nat-operacao
                      AND rat-lote.cod-emitente = item-doc-est.cod-emitente
                      AND rat-lote.sequencia    = item-doc-est.sequencia:

                    ASSIGN rat-lote.quantidade = item-doc-est.quant-conf.

                END.
            END.

            /*Busca e cria vinculo com as notas de origem*/
            IF i-tipo-nf = 1 THEN DO:
            
                FOR EACH nf-produt-propried 
                   WHERE nf-produt-propried.cod-period       = tt-fechto-docto.cod-period
                     AND nf-produt-propried.cdn-produt-rural = docum-est.cod-emitente
                     AND nf-produt-propried.cod-propried     = tt-fechto-docto.cod-propried
                     AND nf-produt-propried.it-codigo        = tt-fechto-docto.it-codigo
                     AND nf-produt-propried.cod-estabel      = docum-est.cod-estabel:
    
                    /*Desconsidera se for nota complementar*/
                    IF nf-produt-propried.num-livre-1 = 1 THEN
                        NEXT.
    
                    FOR FIRST bf-aux-docum-est FIELDS()
                        WHERE bf-aux-docum-est.serie-docto   = nf-produt-propried.serie-docto 
                          AND bf-aux-docum-est.nro-docto     = nf-produt-propried.nro-docto 
                          AND bf-aux-docum-est.cod-emitente  = nf-produt-propried.cdn-produt-rural 
                          AND bf-aux-docum-est.nat-operacao  = nf-produt-propried.nat-operacao:
    
                        /*Cria o vinculo com as notas de origem*/
                        RUN criaVinculoNotaOrigem (INPUT ROWID(docum-est),
                                                   INPUT ROWID(bf-aux-docum-est)).
            
                        IF RETURN-VALUE = "NOK":U THEN DO:
                            UNDO blk_integra, RETURN "NOK":U.
                        END. 
    
                    END.
                    
                END.

            END.
            
            /*A cada nota gerada, gravar um registro na tabela de notas por produtor/propriedade (nf-produt-propried)*/
            IF NOT CAN-FIND(FIRST nf-produt-propried 
                            WHERE nf-produt-propried.cod-period       = tt-fechto-docto.cod-period
                              AND nf-produt-propried.cdn-produt-rural = docum-est.cod-emitente
                              AND nf-produt-propried.cod-propried     = tt-fechto-docto.cod-propried
                              AND nf-produt-propried.it-codigo        = tt-fechto-docto.it-codigo
                              AND nf-produt-propried.cod-estabel      = docum-est.cod-estabel
                              AND nf-produt-propried.serie-docto      = docum-est.serie-docto
                              AND nf-produt-propried.nro-docto        = docum-est.nro-docto
                              AND nf-produt-propried.nat-operacao     = docum-est.nat-operacao) THEN DO:
    
                CREATE nf-produt-propried.
                ASSIGN nf-produt-propried.cod-period       = tt-fechto-docto.cod-period       
                       nf-produt-propried.cdn-produt-rural = docum-est.cod-emitente
                       nf-produt-propried.cod-propried     = tt-fechto-docto.cod-propried    
                       nf-produt-propried.it-codigo        = tt-fechto-docto.it-codigo
                       nf-produt-propried.cod-estabel      = docum-est.cod-estabel                 
                       nf-produt-propried.serie-docto      = docum-est.serie-docto
                       nf-produt-propried.nro-docto        = docum-est.nro-docto
                       nf-produt-propried.nat-operacao     = docum-est.nat-operacao.

                IF i-tipo-nf = 1 THEN
                    ASSIGN nf-produt-propried.num-livre-1 = 1. /*indica que ‚ nota complementar*/
    
            END.

            /*A cada nota gerada, somar o volume fornecido pelo produtor em quant-fornec-produt.qtd-fornec*/
            FOR FIRST quant-fornec-produt EXCLUSIVE-LOCK
                WHERE quant-fornec-produt.cdn-produt-rural = docum-est.cod-emitente
                  AND quant-fornec-produt.it-codigo        = tt-fechto-docto.it-codigo
                  AND quant-fornec-produt.dat-inic        <= docum-est.dt-trans
                  AND quant-fornec-produt.dat-fim         >= docum-est.dt-trans:
                
                ASSIGN quant-fornec-produt.qtd-fornec = quant-fornec-produt.qtd-fornec + de-qtd-item.
            END.

            RUN pi-gera-duplicatas.
            IF RETURN-VALUE = "NOK":U THEN DO:
                UNDO blk_integra, RETURN "NOK":U.
            END.    

            RUN pi-gera-duplicatas-imposto.
            IF RETURN-VALUE = "NOK":U THEN DO:
                UNDO blk_integra, RETURN "NOK":U.
                
            END.   

            IF i-tipo-nf <> 1 THEN DO: /*quando for nota complementar não deve gerar eventos*/
                RUN pi-gera-evento-preco. 
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO blk_integra, RETURN "NOK":U.
                END.   

                RUN pi-gera-evento-imposto. 
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO blk_integra, RETURN "NOK":U.
                END.   
                
                RUN pi-gera-evento-incentivo.
                IF RETURN-VALUE = "NOK":U THEN DO:
                    UNDO blk_integra, RETURN "NOK":U.
                END. 
            END.

            /********************/

    
            FIND fechto-produt-period
                WHERE ROWID(fechto-produt-period) = tt-fechto-docto.rw-fechto EXCLUSIVE-LOCK NO-ERROR.

            IF  AVAIL fechto-produt-period THEN
                ASSIGN fechto-produt-period.idi-situacao = 3. /* NF Gerada */

            RELEASE fechto-produt-period.

            CREATE tt-retorno-nota.
            ASSIGN tt-retorno-nota.cod-emitente = docum-est.cod-emitente
                   tt-retorno-nota.cod-propried = tt-fechto-docto.cod-propried
                   tt-retorno-nota.nome-abrev   = emitente.nome-abrev WHEN AVAIL emitente 
                   tt-retorno-nota.nro-docto    = docum-est.nro-docto
                   tt-retorno-nota.nat-operacao = docum-est.nat-operacao
                   tt-retorno-nota.total-item   = de-total-item.

            DELETE tt-fechto-docto NO-ERROR.
            
        END. /*first docum-est*/

    END. /*do transaction*/

    IF  h-movto-event-fin <> ? THEN DO:
        DELETE PROCEDURE h-movto-event-fin.
        ASSIGN h-movto-event-fin = ?.    
    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-gera-duplicatas:

    EMPTY TEMP-TABLE tt-dupli-apagar.

    /*--- verifica se a natureza gera duplicata ---*/
    IF CAN-FIND(FIRST natur-oper 
                WHERE natur-oper.nat-operacao = docum-est.nat-operacao
                  AND natur-oper.emite-duplic = TRUE) THEN DO: 

        RUN rep/re9341.p (INPUT ROWID(docum-est), INPUT NO).

        /*cria tt-dupli-apagar para geração de impostos*/
        FOR EACH dupli-apagar NO-LOCK
            WHERE dupli-apagar.serie-docto   = docum-est.serie-docto
              AND dupli-apagar.nro-docto     = docum-est.nro-docto  /* na dupli-apagar sempre grava o nro-docto */
              AND dupli-apagar.cod-emitente  = docum-est.cod-emitente
              AND dupli-apagar.nat-operacao  = docum-est.nat-operacao:

            CREATE tt-dupli-apagar.
            BUFFER-COPY dupli-apagar TO tt-dupli-apagar.
        
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-gera-duplicatas-imposto:

    /*--- gera impostos das duplicatas ---*/
    EMPTY TEMP-TABLE RowErrors.

    RUN rep/re9343.p (INPUT TABLE tt-dupli-apagar, OUTPUT TABLE RowErrors).

    FOR EACH RowErrors:

        CREATE tt-erro-imp.
        ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
               tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE "":U
               tt-erro-imp.cd-erro          = RowErrors.ErrorNumber
               tt-erro-imp.desc-erro        = RowErrors.ErrorDescription
               l-erro                       = YES.

    END.

    IF CAN-FIND(FIRST RowErrors) THEN
        RETURN "NOK":U.
    /**************************************/
    
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-gera-evento-imposto:

    /*geração de eventos para as duplicatas de impostos retidos*/
    /*--- Traducao empresa, estabelecimento e pais, conforme
                matriz de traducao do ems 5 ---*/
    IF CAN-FIND(FIRST dupli-imp 
                WHERE dupli-imp.serie-docto        = docum-est.serie-docto  
                  AND dupli-imp.nro-docto    = docum-est.nro-docto    
                  AND dupli-imp.cod-emitente = docum-est.cod-emitente 
                  AND dupli-imp.nat-operacao = docum-est.nat-operacao)
       AND VALID-HANDLE(h-movto-event-fin) THEN DO:
     
        ASSIGN c-pais        = docum-est.pais
               c-cod-empresa = STRING(i-ep-codigo-usuario)
               c-cod-estabel = docum-est.cod-estabel.
    
        RUN pi-traduz-empresa-estab-pais(INPUT-OUTPUT c-cod-empresa,
                                         INPUT-OUTPUT c-cod-estabel,
                                         INPUT-OUTPUT c-pais).
    
        FOR EACH  dupli-imp FIELDS(int-1 cod-retencao vl-imposto serie-docto nro-docto cod-emitente nat-operacao parcela) 
            WHERE dupli-imp.serie-docto        = docum-est.serie-docto  
              AND dupli-imp.nro-docto    = docum-est.nro-docto    
              AND dupli-imp.cod-emitente = docum-est.cod-emitente 
              AND dupli-imp.nat-operacao = docum-est.nat-operacao NO-LOCK:
    
            RUN pi-busca-tipo-imposto(INPUT c-pais, 
                                      INPUT STRING(dupli-imp.int-1), 
                                      OUTPUT i-tipo-impto).          
    
            IF   i-tipo-impto  = 1  /* retido */ THEN DO:
    
                FOR FIRST item-doc-est FIELDS(it-codigo) NO-LOCK
                    WHERE item-doc-est.serie-docto  = dupli-imp.serie-docto
                      AND item-doc-est.nro-docto    = dupli-imp.nro-docto
                      AND item-doc-est.cod-emitente = dupli-imp.cod-emitente
                      AND item-doc-est.nat-operacao = dupli-imp.nat-operacao:
    
                    ASSIGN c-it-codigo = item-doc-est.it-codigo.
    
                END.
    
                FOR EACH event-aquis-rural FIELDS(cod-evento cdn-tipo) NO-LOCK
                    WHERE event-aquis-rural.cod-estabel = docum-est.cod-estabel
                      AND event-aquis-rural.it-codigo   = c-it-codigo
                      AND event-aquis-rural.cdn-tipo    = 7: /*imposto retido*/
    
                    /*gerar o evento imp retido*/
                    EMPTY TEMP-TABLE tt_row_errors.
                    EMPTY TEMP-TABLE tt_movto_event_financ.
    
                    /*buscar desc do imposto*/
                    RUN prgint/utb/utb944wc.py PERSISTENT SET v_hld_dbo.
    
                    RUN openQueryStatic in v_hld_dbo (INPUT "main":U).
    
                    RUN goToKey in v_hld_dbo (INPUT c-pais,                  /*pais*/
                                              INPUT "",                      /*UF*/
                                              INPUT dupli-imp.int-1,         /*cod imposto*/    
                                              INPUT dupli-imp.cod-retencao). /*classif imposto*/
    
                    IF RETURN-VALUE = "NOK":U THEN DO:
    
                        RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                                      OUTPUT c_tta_des_movto_event).
    
                    END.
                    ELSE DO:
    
                        RUN getFieldValue IN v_hld_dbo (INPUT "des_classif_impto":U,
                                                        OUTPUT c_tta_des_movto_event).
    
                        IF RETURN-VALUE = "NOK":U THEN DO:
    
                            RUN getRowErrors in v_hld_dbo (output table ttRowErrors).
    
                            RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                                          OUTPUT c_tta_des_movto_event).
    
                            FOR EACH ttRowErrors:
    
                                CREATE tt-erro-imp.
                                ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
                                       tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                                       tt-erro-imp.cd-erro          = ttRowErrors.ErrorNumber
                                       tt-erro-imp.desc-erro        = ttRowErrors.ErrorDescription.
    
                            END.
    
                        END.
    
                    END.

                    IF  v_hld_dbo <> ? THEN DO:
                        DELETE PROCEDURE v_hld_dbo.
                        ASSIGN v_hld_dbo = ?.    
                    END.
                    /************************/
    
                    CREATE tt_movto_event_financ.
                    ASSIGN tt_movto_event_financ.tta_cod_empresa                = i-ep-codigo-usuario
                           tt_movto_event_financ.tta_cdn_fornecedor             = docum-est.cod-emitente
                           tt_movto_event_financ.tta_cod_event_financ           = event-aquis-rural.cod-evento
                           tt_movto_event_financ.tta_dat_movto_event            = docum-est.dt-trans
                           tt_movto_event_financ.tta_num_seq_movto_event        = 0
                           tt_movto_event_financ.tta_des_movto_event            = c_tta_des_movto_event
                           tt_movto_event_financ.tta_cod_indic_econ             = "" /*EMS5 pega do par³metro geral dos eventos*/
                           tt_movto_event_financ.tta_val_movto_event            = dupli-imp.vl-imposto
                           tt_movto_event_financ.tta_log_integr                 = NO
                           tt_movto_event_financ.tta_num_id_fechto_event_financ = 0
                           tt_movto_event_financ.tta_ind_orig_movto_event       = "AQR":U
                           tt_movto_event_financ.tta_des_unid_event             = "" /*litro/gramas/etc..documentacional*/
                           tt_movto_event_financ.tta_cod_prop_rural             = tt-fechto-docto.cod-propried
                           tt_movto_event_financ.tta_num_parc_movto             = INT(dupli-imp.parcela)
                           tt_movto_event_financ.tta_cod_estab                  = docum-est.cod-estabel
                           tt_movto_event_financ.tta_cod_rota                   = "".
    
                    RUN pi_create_movto_event_financ in h-movto-event-fin (INPUT-OUTPUT TABLE tt_movto_event_financ,
                                                                           OUTPUT TABLE tt_row_errors).
    
                    FOR EACH tt_row_errors:
    
                        CREATE tt-erro-imp.
                        ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
                               tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                               tt-erro-imp.cd-erro          = tt_row_errors.ttv_num_erro
                               tt-erro-imp.desc-erro        = tt_row_errors.ttv_des_erro
                               l-erro                       = YES.
    
                    END.

                    IF CAN-FIND(FIRST tt_row_errors) THEN
                        RETURN "NOK":U.
     
                END. /*for each event-aquis-rural*/
    
            END. /*tipo imposto retido*/
    
        END. /*for each dupli-imp*/
    
    END. /*encontrou dupli-imp*/
    /***********************************************************/

    /*evento imposto sanidade animal*/
    FOR EACH fechto-produt-period  NO-LOCK 
        WHERE fechto-produt-period.cod-period       = tt-fechto-docto.cod-period
          AND fechto-produt-period.cod-estabel      = docum-est.cod-estabel
          AND fechto-produt-period.cdn-produt-rural = docum-est.cod-emitente
          AND fechto-produt-period.cod-propried     = tt-fechto-docto.cod-propried,
        EACH event-aquis-rural NO-LOCK
        WHERE event-aquis-rural.cod-estabel = docum-est.cod-estabel
          AND event-aquis-rural.it-codigo   = fechto-produt-period.it-codigo
          AND event-aquis-rural.cdn-tipo    = 8: /*imposto sanidade animal*/

        EMPTY TEMP-TABLE tt_row_errors.
        EMPTY TEMP-TABLE tt_movto_event_financ.

        IF fechto-produt-period.val-impto >= 0.01 THEN DO: //nÆo gerar valor de imposto menor que um centavo

            /*buscar desc do imposto*/
            RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                          OUTPUT c_tta_des_movto_event).
            /************************/
            CREATE tt_movto_event_financ.
            ASSIGN tt_movto_event_financ.tta_cod_empresa                = i-ep-codigo-usuario
                   tt_movto_event_financ.tta_cdn_fornecedor             = docum-est.cod-emitente
                   tt_movto_event_financ.tta_cod_event_financ           = event-aquis-rural.cod-evento
                   tt_movto_event_financ.tta_dat_movto_event            = docum-est.dt-trans
                   tt_movto_event_financ.tta_num_seq_movto_event        = 0
                   tt_movto_event_financ.tta_des_movto_event            = c_tta_des_movto_event
                   tt_movto_event_financ.tta_cod_indic_econ             = "" /*EMS5 pega do par³metro geral dos eventos*/
                   tt_movto_event_financ.tta_val_movto_event            = fechto-produt-period.val-impto
                   tt_movto_event_financ.tta_log_integr                 = NO
                   tt_movto_event_financ.tta_num_id_fechto_event_financ = 0
                   tt_movto_event_financ.tta_ind_orig_movto_event       = "AQR":U
                   tt_movto_event_financ.tta_des_unid_event             = "" /*litro/gramas/etc..documentacional*/
                   tt_movto_event_financ.tta_cod_prop_rural             = tt-fechto-docto.cod-propried
                   tt_movto_event_financ.tta_num_parc_movto             = 1
                   tt_movto_event_financ.tta_cod_estab                  = docum-est.cod-estabel
                   tt_movto_event_financ.tta_cod_rota                   = fechto-produt-period.cod-rota.
        
            RUN pi_create_movto_event_financ in h-movto-event-fin (INPUT-OUTPUT TABLE tt_movto_event_financ,
                                                                   OUTPUT TABLE tt_row_errors).
    
            FOR EACH tt_row_errors:
    
                CREATE tt-erro-imp.
                ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
                       tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                       tt-erro-imp.cd-erro          = tt_row_errors.ttv_num_erro
                       tt-erro-imp.desc-erro        = tt_row_errors.ttv_des_erro
                       l-erro                       = YES.
        
            END.
        
            IF CAN-FIND(FIRST tt_row_errors) THEN
                RETURN "NOK":U.
        END.
    
    END. /*for each event-aquis-rural*/
    /********************************/
    
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE pi-gera-evento-incentivo:

    /*-- Cria evento financeiro --*/
    IF  docum-est.valor-outras > 0 AND 
        tt-fechto-docto.nf-credito <> "NAO":U THEN DO:
        
        EMPTY TEMP-TABLE tt_row_errors.
        EMPTY TEMP-TABLE tt_movto_event_financ.

    
        IF VALID-HANDLE(h-movto-event-fin) THEN DO:

            RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  tt-fechto-docto.cod-evento,
                                                                          OUTPUT c_tta_des_movto_event).
            
            CREATE tt_movto_event_financ.
            ASSIGN tt_movto_event_financ.tta_cod_empresa                = i-ep-codigo-usuario
                   tt_movto_event_financ.tta_cdn_fornecedor             = docum-est.cod-emitente
                   tt_movto_event_financ.tta_cod_event_financ           = tt-fechto-docto.cod-evento
                   tt_movto_event_financ.tta_dat_movto_event            = docum-est.dt-trans
                   tt_movto_event_financ.tta_num_seq_movto_event        = 0
                   tt_movto_event_financ.tta_des_movto_event            = c_tta_des_movto_event
                   tt_movto_event_financ.tta_cod_indic_econ             = "" /*EMS5 pega do par³metro geral dos eventos*/
                   tt_movto_event_financ.tta_val_movto_event            = docum-est.valor-outras
                   tt_movto_event_financ.tta_log_integr                 = NO
                   tt_movto_event_financ.tta_num_id_fechto_event_financ = 0
                   tt_movto_event_financ.tta_ind_orig_movto_event       = "AQR":U
                   tt_movto_event_financ.tta_des_unid_event             = "" /*litro/gramas/etc..documentacional*/
                   tt_movto_event_financ.tta_cod_prop_rural             = tt-fechto-docto.cod-propried
                   tt_movto_event_financ.tta_num_parc_movto             = 1
                   tt_movto_event_financ.tta_cod_estab                  = docum-est.cod-estabel
                   tt_movto_event_financ.tta_cod_rota                   = "".
            
            RUN pi_create_movto_event_financ in h-movto-event-fin (INPUT-OUTPUT TABLE tt_movto_event_financ,
                                                                   OUTPUT TABLE tt_row_errors).
            
            IF AVAIL nf-produt-propried THEN
                FOR FIRST tt_movto_event_financ:
                    assign nf-produt-propried.cdn-id-movto-event = tt_movto_event_financ.tta_num_id_movto_event.
                END.
            
            FOR EACH tt_row_errors:
            
                CREATE tt-erro-imp.
                ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
                       tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                       tt-erro-imp.cd-erro          = tt_row_errors.ttv_num_erro
                       tt-erro-imp.desc-erro        = tt_row_errors.ttv_des_erro
                       l-erro                       = YES.
                
            END.

            IF CAN-FIND(FIRST tt_row_errors) THEN
                RETURN "NOK":U.

        END.

    END.
    
    RETURN "OK":U.

END PROCEDURE.


PROCEDURE criaVinculoNotaOrigem:

    /******************************************************************************* 
    OBJETIVO: Cria‡Æo de V¡nculo da Nota Complementar Com Nota Origem 
              (Inf. Adicionais Nota Fiscal)
    PARAMETROS: Recebe o rowid do documento que est  sendo criado e o rowid
                do documento referenciado (origem)                
    ********************************************************************************/

    DEFINE INPUT PARAMETER rDocNovo     AS ROWID                            NO-UNDO.
    DEFINE INPUT PARAMETER rDocOrigem   AS ROWID                            NO-UNDO.
    
    DEF VAR c-modelo  AS CHAR   NO-UNDO.
    DEF VAR h-bodi515 AS HANDLE NO-UNDO.

    EMPTY TEMP-TABLE tt-nota-fisc-adc.

    IF NOT VALID-HANDLE(h-bodi515) THEN
        RUN dibo/bodi515.p PERSISTENT SET h-bodi515.

    /*Busca o registro da nota que est  sendo criada*/
    FOR FIRST bf-novo-docum-est FIELDS(serie-docto nro-docto cod-emitente dt-emissao nat-operacao) 
        WHERE ROWID(bf-novo-docum-est) = rDocNovo NO-LOCK:
    END.
    
    IF NOT AVAIL bf-novo-docum-est THEN
        NEXT.
    
    /*busca informa‡äes do documento de origem*/
    FOR FIRST bf-docum-est FIELDS(serie-docto nro-docto cod-emitente dt-emissao nat-operacao cod-chave-aces-nf-eletro) 
        WHERE ROWID(bf-docum-est) = rDocOrigem NO-LOCK:

        CREATE tt-nota-fisc-adc.
        ASSIGN tt-nota-fisc-adc.cod-estab = bf-novo-docum-est.cod-estabel
               tt-nota-fisc-adc.cod-serie = bf-novo-docum-est.serie-docto
               tt-nota-fisc-adc.cod-nota-fisc = bf-novo-docum-est.nro-docto
               tt-nota-fisc-adc.cdn-emitente = bf-novo-docum-est.cod-emitente
               tt-nota-fisc-adc.cod-natur-operac = bf-novo-docum-est.nat-operacao
               tt-nota-fisc-adc.idi-tip-dado = 3 /* Docto fiscal referenciado */ 
               tt-nota-fisc-adc.cod-ser-docto-referado = bf-docum-est.serie-docto
               tt-nota-fisc-adc.cod-docto-referado = bf-docum-est.nro-docto
               tt-nota-fisc-adc.cdn-emit-docto-referado = bf-docum-est.cod-emitente
               tt-nota-fisc-adc.dat-docto-referado = bf-docum-est.dt-emissao
               tt-nota-fisc-adc.idi-tip-emit-referado = 1 /* EmissÆo pr¢pria */
               tt-nota-fisc-adc.idi-tip-docto-referado = 1. /* Entrada */

        /*Busca do modelo do documento referenciado*/
        RUN pi-buscaModelo IN h-bodi515 (INPUT "FT":U,
                                         INPUT bf-novo-docum-est.cod-estabel, 
                                         INPUT bf-docum-est.serie-docto,
                                         INPUT bf-docum-est.nro-docto,
                                         INPUT bf-docum-est.cod-emitente,
                                         INPUT bf-docum-est.nat-operacao,
                                         OUTPUT c-modelo).

        /*Seta modelo e chave de acesso do documento referenciado*/
        ASSIGN tt-nota-fisc-adc.cod-model-docto-referado = c-modelo
        OVERLAY(tt-nota-fisc-adc.cod-livre-2,1,60) = bf-docum-est.cod-chave-aces-nf-eletro.

        FIND FIRST tt-nota-fisc-adc NO-LOCK NO-ERROR.

        /*cria registro na bo e retorna RowErrors caso ocorra algum problema*/
        IF CAN-FIND(FIRST tt-nota-fisc-adc) THEN DO:
            RUN openQueryStatic IN h-bodi515 (INPUT "Main").           
            RUN emptyRowErrors  IN h-bodi515.  
            RUN setRecord       IN h-bodi515(input table tt-nota-fisc-adc).
            RUN createRecord    IN h-bodi515.
            RUN getRowErrors    IN h-bodi515(OUTPUT TABLE RowErrors).
        END.
    
        IF  h-bodi515 <> ? THEN DO:
            DELETE PROCEDURE h-bodi515.
            ASSIGN h-bodi515 = ?.    
        END.
    
        FOR EACH RowErrors:

            CREATE tt-erro-imp.
            ASSIGN tt-erro-imp.cdn-produt-rural = bf-docum-est.cod-emitente
                   tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                   tt-erro-imp.cd-erro          = RowErrors.ErrorNumber
                   tt-erro-imp.desc-erro        = RowErrors.ErrorDescription
                   l-erro                       = YES.
            
        END.
    
        IF l-erro THEN
            RETURN "NOK":U.

    END.
    
    RETURN "OK":U.

END.

PROCEDURE pi-gera-evento-preco:

    ASSIGN i_tta_num_id_movto_event = 0.

    EMPTY TEMP-TABLE tt_row_errors         NO-ERROR.
    EMPTY TEMP-TABLE tt_movto_event_financ NO-ERROR.

    ASSIGN l-erro = NO.

    FOR EACH fechto-produt-period FIELDS(it-codigo cdn-produt-rural val-preco-base cod-propried cod-estabel 
                                         cod-rota cod-period val-var-volum val-bonus-fix-inf  val-bonus-fix qtd-period val-livre-1 val-var-qualid) NO-LOCK 
        WHERE fechto-produt-period.cod-period       = tt-fechto-docto.cod-period 
          AND fechto-produt-period.cod-estabel      = docum-est.cod-estabel
          AND fechto-produt-period.cdn-produt-rural = docum-est.cod-emitente
          AND fechto-produt-period.cod-propried     = tt-fechto-docto.cod-propried:

        /*preco_base*/
        FOR FIRST event-aquis-rural FIELDS(cod-evento) NO-LOCK
            WHERE event-aquis-rural.cod-estabel = fechto-produt-period.cod-estabel
              AND event-aquis-rural.it-codigo   = fechto-produt-period.it-codigo  
              AND event-aquis-rural.cdn-tipo    = 1: /*Preco Base*/

            RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                          OUTPUT c_des_movto_event).

            ASSIGN i_tta_num_id_movto_event = i_tta_num_id_movto_event + 1.

            RUN pi-cria-tt-movto-event-financ (INPUT fechto-produt-period.val-preco-base * fechto-produt-period.qtd-period,
                                               INPUT STRING(fechto-produt-period.val-preco-base, ">>>>>,>>>,>>9.9999")).

        END.

        IF l-erro = YES THEN
            RETURN "NOK":U.
        /*****************/

        /*bonus_qualidade*/
        
        ASSIGN d-tot-qualid = 0.

        FOR EACH fechto-qualid FIELDS(cod-exame cdn-comp val-var-qualid) NO-LOCK
            WHERE fechto-qualid.cod-period       = fechto-produt-period.cod-period
              AND fechto-qualid.cod-estabel      = fechto-produt-period.cod-estabel
              AND fechto-qualid.it-codigo        = fechto-produt-period.it-codigo
              AND fechto-qualid.cod-propried     = fechto-produt-period.cod-propried
              AND fechto-qualid.cdn-produt-rural = fechto-produt-period.cdn-produt-rural:

            ASSIGN d-tot-qualid = d-tot-qualid + fechto-qualid.val-var-qualid.

            FOR EACH event-aquis-rural FIELDS(cod-evento) NO-LOCK
                WHERE event-aquis-rural.cod-estabel = fechto-produt-period.cod-estabel
                  AND event-aquis-rural.it-codigo   = fechto-produt-period.it-codigo  
                  AND event-aquis-rural.cdn-tipo    = 2 /*Bonus Qualidade*/
                  AND event-aquis-rural.cod-exame   = fechto-qualid.cod-exame
                  AND event-aquis-rural.cod-comp    = fechto-qualid.cdn-comp:
                
                RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                              OUTPUT c_des_movto_event).

                ASSIGN i_tta_num_id_movto_event = i_tta_num_id_movto_event + 1.

                RUN pi-cria-tt-movto-event-financ (INPUT fechto-qualid.val-var-qualid * fechto-produt-period.qtd-period,
                                                   INPUT STRING(fechto-qualid.val-var-qualid, "->>>,>>9.9999")).
            END.
        END.

        /* Soma dos b“nus de qualidade tem que ser igual ao total do periodo */
        IF d-tot-qualid <> fechto-produt-period.val-var-qualid THEN DO: 
            CREATE tt-erro-imp.
            ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
                   tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
                   tt-erro-imp.cd-erro          = 56016
                   tt-erro-imp.desc-erro        = "H  diferen‡a nos valores dos b“nus de qualidade":U
                   l-erro                       = YES.
        END.
        
        IF l-erro = YES THEN
            RETURN "NOK":U.
        /**************/

        /*bonus_volume*/
        FOR FIRST event-aquis-rural FIELDS(cod-evento) NO-LOCK
            WHERE event-aquis-rural.cod-estabel = fechto-produt-period.cod-estabel
              AND event-aquis-rural.it-codigo   = fechto-produt-period.it-codigo  
              AND event-aquis-rural.cdn-tipo    = 3: /*Variacao Volume*/

            RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                          OUTPUT c_des_movto_event).

            ASSIGN i_tta_num_id_movto_event = i_tta_num_id_movto_event + 1.

            RUN pi-cria-tt-movto-event-financ (INPUT fechto-produt-period.val-var-volum * fechto-produt-period.qtd-period,
                                               INPUT STRING(fechto-produt-period.val-var-volum, "->>>,>>9.9999")).
        END.    

        IF l-erro = YES THEN
            RETURN "NOK":U.
        /************/

        /*bonus_fixo*/
        FOR FIRST event-aquis-rural FIELDS(cod-evento) NO-LOCK
            WHERE event-aquis-rural.cod-estabel = fechto-produt-period.cod-estabel
              AND event-aquis-rural.it-codigo   = fechto-produt-period.it-codigo  
              AND event-aquis-rural.cdn-tipo    = 4: /*Bonus Fixo*/

            RUN pi_retornar_dados_evento_financeiro IN h-movto-event-fin (INPUT  event-aquis-rural.cod-evento,
                                                                             OUTPUT c_des_movto_event).

            ASSIGN i_tta_num_id_movto_event = i_tta_num_id_movto_event + 1.

            RUN pi-cria-tt-movto-event-financ (INPUT (fechto-produt-period.val-bonus-fix + fechto-produt-period.val-bonus-fix-inf + fechto-produt-period.val-livre-1) * fechto-produt-period.qtd-period,
                                               INPUT STRING(fechto-produt-period.val-bonus-fix + fechto-produt-period.val-bonus-fix-inf, "->>>,>>9.9999")).
            

        END.
        /************/

        IF l-erro = YES THEN
            RETURN "NOK":U.

    END.
    
    RETURN "OK":U.

END PROCEDURE.

PROCEDURE pi-cria-tt-movto-event-financ:

    DEFINE INPUT PARAMETER p-val-movto LIKE tt_movto_event_financ.tta_val_movto_event NO-UNDO.
    DEFINE INPUT PARAMETER p-des-movto LIKE tt_movto_event_financ.tta_des_unid_event  NO-UNDO.

    CREATE tt_movto_event_financ.
    ASSIGN tt_movto_event_financ.tta_cod_empresa                = param-global.empresa-prin
           tt_movto_event_financ.tta_cdn_fornecedor             = fechto-produt-period.cdn-produt-rural
           tt_movto_event_financ.tta_cod_event_financ           = event-aquis-rural.cod-evento
           tt_movto_event_financ.tta_dat_movto_event            = docum-est.dt-trans
           tt_movto_event_financ.tta_num_seq_movto_event        = 0
           tt_movto_event_financ.tta_des_movto_event            = c_des_movto_event
           tt_movto_event_financ.tta_cod_indic_econ             = "" /*EMS5 pega do parƒmetro geral dos eventos*/
           tt_movto_event_financ.tta_val_movto_event            = p-val-movto
           tt_movto_event_financ.tta_log_integr                 = NO
           tt_movto_event_financ.tta_num_id_fechto_event_financ = 0
           tt_movto_event_financ.tta_ind_orig_movto_event       = "AQR"
           tt_movto_event_financ.tta_des_unid_event             = p-des-movto
           tt_movto_event_financ.tta_cod_prop_rural             = fechto-produt-period.cod-propried
           tt_movto_event_financ.tta_num_parc_movto             = 1
           tt_movto_event_financ.tta_cod_estab                  = fechto-produt-period.cod-estabel
           tt_movto_event_financ.tta_cod_rota                   = fechto-produt-period.cod-rota
           tt_movto_event_financ.tta_num_id_movto_event         = i_tta_num_id_movto_event.
           
    RUN pi_create_movto_event_financ in h-movto-event-fin (INPUT-OUTPUT TABLE tt_movto_event_financ,
                                                           OUTPUT TABLE tt_row_errors).

    FOR EACH tt_row_errors:

        CREATE tt-erro-imp.
        ASSIGN tt-erro-imp.cdn-produt-rural = docum-est.cod-emitente
               tt-erro-imp.nom-produt-rural = IF AVAIL emitente THEN emitente.nome-abrev ELSE ""
               tt-erro-imp.cd-erro          = tt_row_errors.ttv_num_erro
               tt-erro-imp.desc-erro        = tt_row_errors.ttv_des_erro
               l-erro                       = YES.
        
        DELETE tt_row_errors NO-ERROR.

    END.

    FOR EACH tt_movto_event_financ:
        DELETE tt_movto_event_financ.
    END.

    RETURN "OK":U.

END PROCEDURE.
