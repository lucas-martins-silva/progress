/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0994F 2.00.00.006 } /*** "010006" 16/10/2026 09:59:10 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994f MIM}
&ENDIF

/****************************************************************************
**
**    RE9340F.p - Geraá∆o da tt-previsao para baixa da previs∆o criada na
**                atualizaá∆o do Remito
**              - Copia do programa RE9340.i6
**
****************************************************************************/

/************************* Begin Definition Temp-Table ************************/
DEF TEMP-TABLE tt-erro NO-UNDO
    FIELD i-sequen AS INT
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".

DEF TEMP-TABLE tt_titulos_ems5 NO-UNDO
    FIELD cod-estab                    AS CHARACTER FORMAT "x(3)" LABEL "Estabelecimento" COLUMN-LABEL "Estab"
    FIELD cod-fornec                   AS INTEGER   FORMAT ">>>,>>>,>>9" LABEL "Fornecedor" COLUMN-LABEL "Fornecedor"
    FIELD cod-esp                      AS CHARACTER FORMAT "x(03)" LABEL "EspÇcie Documento" COLUMN-LABEL "EspÇcie"
    FIELD serie                        AS CHARACTER FORMAT "x(8)"
    FIELD nr-docto                     AS CHARACTER FORMAT "x(10)" LABEL "T°tulo" COLUMN-LABEL "T°tulo"
    FIELD parcela                      AS CHARACTER FORMAT "x(02)" LABEL "Parcela" COLUMN-LABEL "Parc"
    FIELD vl-saldo-me                  AS DECIMAL   FORMAT "->>>,>>>,>>9.99" DECIMALS 2 INITIAL 0 LABEL "Valor Saldo" COLUMN-LABEL "Valor Saldo"
    FIELD tta_cod_indic_econ           AS CHARACTER FORMAT "x(8)" LABEL "Moeda" COLUMN-LABEL "Moeda"
    FIELD tta_cod_estab_ext            AS CHARACTER FORMAT "x(8)" LABEL "Estabelecimento Exte" COLUMN-LABEL "Estabelecimento Ext"
    FIELD moeda                        AS CHARACTER FORMAT "x(8)" LABEL "Moeda" COLUMN-LABEL "Moeda"
    .

DEF TEMP-TABLE tt-previsao NO-UNDO
    FIELD Ep-cod-pre      LIKE tit-ap.ep-codigo
    FIELD Cod-est-pre     LIKE tit-ap.cod-estabel
    FIELD Cod-esp-pre     LIKE tit-ap.cod-esp
    FIELD Serie-pre       LIKE tit-ap.serie
    FIELD nr-docto-pre    LIKE tit-ap.nr-docto
    FIELD Parcela-pre     LIKE tit-ap.parcela
    FIELD Moeda-pre       LIKE tit-ap.moeda
    FIELD Cod-fornec      LIKE tit-ap.cod-fornec
    FIELD cotacao-dia     LIKE tit-ap.cotacao-dia
    FIELD Vl-previsao     LIKE tit-ap.vl-original
    FIELD Vl-previsao-me  LIKE tit-ap.vl-orig-me
    INDEX CODIGO IS PRIMARY ep-cod-pre
                            cod-est-pre
                            cod-esp-pre
                            serie-pre
                            nr-docto-pre
                            parcela-pre
                            cod-fornec.

/************************** End Definition Temp-Table *************************/

/************************* Begin Definition Parameters ************************/
DEF INPUT  PARAM pRowID           AS ROWID                     NO-UNDO.
DEF INPUT  PARAM i-empresa      LIKE param-global.empresa-prin NO-UNDO.
DEF OUTPUT PARAM de-tot-despesas  AS DEC                       NO-UNDO.
DEF OUTPUT PARAM l-gerar-previsao AS LOG                       NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-erro.
DEF INPUT-OUTPUT PARAM TABLE FOR tt_titulos_ems5.
DEF INPUT-OUTPUT PARAM TABLE FOR tt-previsao.

/************************** End Definition Parameters *************************/

/*************************** Begin Definition Buffer **************************/
DEF BUFFER bfdupli-apagar-cex FOR dupli-apagar-cex.
DEF BUFFER bfdocum-est        FOR docum-est.
DEF BUFFER bfdocum-est2       FOR docum-est.
DEF BUFFER bfitem-doc-est     FOR item-doc-est.
DEF BUFFER bfunid-neg-nota    FOR unid-neg-nota.
/*************************** End Definition Buffer ****************************/

/************************** Begin Definition Variable *************************/
DEF VAR de-vl-tot-baixa           AS DECI   NO-UNDO.
DEF VAR de-vl-baixa-aux           AS DECI   NO-UNDO.
DEF VAR de-vl-baixa-prev          AS DECI   NO-UNDO.
DEF VAR p_cod_matriz_trad_org_ext AS CHAR   NO-UNDO FORMAT "x(8)".

{include/i_fncrowid.i}
{cdp/cd4300.i3}           /* Variveis para o cd4300.i4 */
{rep/re1001b.i50}         /*Variaveis para o re1001b.i51*/
{cdp/cdcfgmat.i}          /*PrÇ-Processadores do Aplicativo de Distribuiá∆o*/
{include/i-epc200.i IM0994f} 

/*************************** End Definition Variable **************************/

ASSIGN l-gerar-previsao = NO.

IF  SEARCH("prgint/ufn/ufn908za.r")  = ?
AND SEARCH("prgint/ufn/ufn908za.py") = ? THEN DO:
    RUN utp/ut-msgs.p ("msg", 6246, INPUT "prgint/ufn/ufn908za.py").
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 6246
            tt-erro.mensagem = RETURN-VALUE.
    
    RETURN.
END.

IF  SEARCH("prgfin/apb/apb205za.r")  = ?
AND SEARCH("prgfin/apb/apb205za.py") = ? THEN DO:
    RUN utp/ut-msgs.p ("msg", 6246, INPUT "prgfin/apb/apb205za.py").
    CREATE tt-erro.
    ASSIGN tt-erro.i-sequen = 1
           tt-erro.cd-erro  = 6246
           tt-erro.mensagem = RETURN-VALUE.
    
    RETURN.
END.


FIND FIRST bfdocum-est NO-LOCK
     WHERE ROWID(bfdocum-est) = pRowID NO-ERROR.

IF  bfdocum-est.nff AND bfdocum-est.nat-operacao = " "    /*Faturas*/ THEN DO:
    FIND FIRST item-doc-est {cdp/cd8900.i item-doc-est bfdocum-est}  NO-LOCK NO-ERROR.
    
    FIND FIRST bfdocum-est2 NO-LOCK
         WHERE bfdocum-est2.cod-emitente = item-doc-est.fornec-comp
           AND bfdocum-est2.serie-docto  = item-doc-est.serie-comp
           AND bfdocum-est2.nro-docto    = item-doc-est.nro-comp
           AND bfdocum-est2.nat-operacao = item-doc-est.nat-comp NO-ERROR.
    
    IF  CAN-FIND(FIRST natur-oper NO-LOCK
                 WHERE natur-oper.nat-operacao = bfdocum-est2.nat-operacao
                   AND natur-oper.nota-rateio  = YES) THEN DO:
       ASSIGN l-gerar-previsao = YES.
       RETURN.
    END.
    
    ASSIGN de-vl-baixa-prev = 0.
    
    &if defined (bf_dis_consiste_conta) &then

        FIND  estabelec 
        WHERE estabelec.cod-estabel = docum-est.cod-estabel NO-LOCK NO-ERROR.
        
        RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                          OUTPUT i-empresa).
    &endif
    
    FOR EACH item-doc-est {cdp/cd8900.i item-doc-est bfdocum-est}  NO-LOCK:
        
        /* despesas adicionais */
        IF  item-doc-est.cod-despesa > "":U
        AND item-doc-est.nro-comp    = "":U
        AND item-doc-est.serie-comp  = "":U
        AND item-doc-est.nat-comp    = "":U THEN 
            NEXT.
        
        /*fatura de despesa*/
        IF  item-doc-est.cod-despesa > "":U THEN DO:
            
            /*localiza a despesa do remito com o fornecedor da fatura e n∆o do remito*/
            FIND  bfitem-doc-est NO-LOCK
            WHERE bfitem-doc-est.cod-emitente = item-doc-est.fornec-comp
              AND bfitem-doc-est.serie-docto  = item-doc-est.serie-comp
              AND bfitem-doc-est.nro-docto    = item-doc-est.nro-comp
              AND bfitem-doc-est.nat-operacao = item-doc-est.nat-comp
              AND bfitem-doc-est.sequencia    = item-doc-est.seq-comp NO-ERROR.
        END.
        ELSE DO: /*fatura normal de remito*/
            IF  item-doc-est.sit-item = 2 THEN
                 NEXT.
            
            FIND  bfitem-doc-est NO-LOCK
            WHERE bfitem-doc-est.cod-emitente = item-doc-est.fornec-comp
              AND bfitem-doc-est.serie-docto  = item-doc-est.serie-comp
              AND bfitem-doc-est.nro-docto    = item-doc-est.nro-comp
              AND bfitem-doc-est.nat-operacao = item-doc-est.nat-comp
              AND bfitem-doc-est.sequencia    = item-doc-est.seq-comp NO-ERROR.
        END.
        
        IF  NOT AVAIL bfitem-doc-est THEN
            NEXT.

        {cdp/cd4300.i4  "yes" item-doc-est.char-1} 
        {rep/re1001b.i51 "yes"}
        
        FIND bfdocum-est2 {cdp/cd8900.i bfdocum-est2 bfitem-doc-est} NO-LOCK NO-ERROR.
        
        FIND FIRST bfdupli-apagar-cex use-index documento 
             WHERE bfdupli-apagar-cex.serie-docto       = bfitem-doc-est.serie-docto    
               AND bfdupli-apagar-cex.nro-docto         = bfitem-doc-est.nro-docto      
               AND bfdupli-apagar-cex.cod-emitente      = bfitem-doc-est.cod-emitente   
               AND bfdupli-apagar-cex.cod-emitente-desp = bfdocum-est.cod-emitente 
               AND bfdupli-apagar-cex.nat-operacao      = bfitem-doc-est.nat-operacao   NO-LOCK NO-ERROR.  
            
        IF  NOT AVAIL bfdupli-apagar-cex THEN
            NEXT.
        
        /* Copia unidade de negΩcio da Previs∆o para a Fatura */    
        &if defined(bf_mat_unidade_negocio) &then

            FIND FIRST param-mat NO-LOCK NO-ERROR.
            
            IF   AVAIL param-mat 
            AND  param-mat.ind-unid-neg THEN DO:
                 FOR EACH bfunid-neg-nota
                    WHERE bfunid-neg-nota.cod-emitente = bfitem-doc-est.cod-emitente
                      AND bfunid-neg-nota.serie-docto  = bfitem-doc-est.serie-docto
                      AND bfunid-neg-nota.nro-docto    = bfitem-doc-est.nro-docto
                      AND bfunid-neg-nota.nat-operacao = bfitem-doc-est.nat-operacao
                      AND bfunid-neg-nota.sequencia    = bfitem-doc-est.sequencia NO-LOCK:
                      
                      BUFFER-COPY bfunid-neg-nota to unid-neg-nota
                           ASSIGN unid-neg-nota.cod-emitente = item-doc-est.cod-emitente
                                  unid-neg-nota.serie-docto  = item-doc-est.serie-docto
                                  unid-neg-nota.nro-docto    = item-doc-est.nro-docto
                                  unid-neg-nota.nat-operacao = item-doc-est.nat-operacao
                                  unid-neg-nota.sequencia    = item-doc-est.sequencia.
                 END.
            END.

        &endif 

        /* Quando for conciliacao do material, baixa o valor digitado na conciliacao */
        IF  item-doc-est.cod-despesa = "":U THEN
            ASSIGN de-vl-baixa-prev  = de-vl-baixa-prev
                                     + item-doc-est.preco-total-me
                                     - item-doc-est.desconto-me
                                     + de-tot-taxa-item-me.
        ELSE DO:
            
            /* Quando for conciliacao da despesa, baixa o valor total digitado 
               para cada despesa no remito */
            FOR EACH  desp-item-doc-est NO-LOCK
                WHERE desp-item-doc-est.cod-emitente = item-doc-est.fornec-comp 
                  AND desp-item-doc-est.nat-operacao = item-doc-est.nat-comp    
                  AND desp-item-doc-est.serie-docto  = item-doc-est.serie-comp  
                  AND desp-item-doc-est.nro-docto    = item-doc-est.nro-comp    
                  AND desp-item-doc-est.sequencia    = item-doc-est.seq-comp   
                  AND desp-item-doc-est.cod-despesa  = item-doc-est.cod-despesa:
                
                ASSIGN de-vl-baixa-prev = de-vl-baixa-prev + desp-item-doc-est.val-despesa.
                
            END.
            
            ASSIGN de-tot-despesas = de-tot-despesas + de-vl-baixa-prev.
            
        END.
        
        RUN prgint/ufn/ufn908za.py (INPUT 1, 
                                    INPUT "14",  /*"Recebimento 2.00",*/   
                                    OUTPUT p_cod_matriz_trad_org_ext).
        
        RUN prgfin/apb/apb205za.py (INPUT "",
                                    INPUT bfdocum-est.cod-estabel,
                                    INPUT p_cod_matriz_trad_org_ext,
                                    INPUT "4",  /*cod_tip_espec_docto*/
                                    INPUT bfdupli-apagar-cex.cod-emitente-desp,
                                    INPUT bfdupli-apagar-cex.cod-esp,
                                    INPUT bfdupli-apagar-cex.serie-docto,
                                    INPUT bfdupli-apagar-cex.nro-docto,
                                    OUTPUT TABLE tt_titulos_ems5).

        if c-nom-prog-dpc-mg97  <> "" or
           c-nom-prog-appc-mg97 <> "" or 
           c-nom-prog-upc-mg97  <> "" then do:
            
            /*Chamada EPC - Tratamento de sÇrie */
            &IF "{&BF_MAT_VERSAO_EMS}" >= "2.06B" &THEN
                
                for each tt-epc
                    where tt-epc.cod-event = "Integra-serie-recepcion-cex":U:
                    delete tt-epc.
                END.
           
                create tt-epc.
                assign tt-epc.cod-event     = "Integra-serie-recepcion-cex":U
                       tt-epc.cod-parameter = "handle_tt_titulos_ems5":U.
                &IF INTEGER(ENTRY(1,PROVERSION,'.')) >= 9 &THEN
                    ASSIGN tt-epc.val-parameter = string(temp-table tt_titulos_ems5:handle) + ";" +
                                                  &IF {&ROWID_READY} = YES &THEN 
                                                    STRING(ROWID(bfdupli-apagar-cex))
                                                  &ELSE 
                                                    STRING(recid(bfdupli-apagar-cex))
                                                  &ENDIF + ";" +
                                                  p_cod_matriz_trad_org_ext.
                &ENDIF
                
                {include/i-epc201.i "Integra-serie-recepcion-cex"}
           
                for each tt-epc
                    where tt-epc.cod-event = "Integra-serie-recepcion-cex":U:
                    delete tt-epc.
                END.
            &ENDIF /* Fim da chamada EPC */
        END.
        ASSIGN de-vl-tot-baixa = 0.
        
        FOR EACH bfdupli-apagar-cex {cdp/cd8900.i bfdupli-apagar-cex bfitem-doc-est} NO-LOCK
            BREAK BY bfdupli-apagar-cex.parcela :

            /* de-vl-baixa-prev -> valor do item 
            de-vl-baixa-aux  -> valor do item rateado por dupli-apagar */

            ASSIGN de-vl-baixa-aux = TRUNC(de-vl-baixa-prev * bfdupli-apagar-cex.valor-a-pagar-me
                                           / bfdocum-est2.tot-valor-me, 2 ).

            IF  de-vl-baixa-aux > bfdupli-apagar-cex.valor-a-pagar-me THEN
                ASSIGN de-vl-baixa-aux = bfdupli-apagar-cex.valor-a-pagar-me.                                                       
            
            IF  LAST(bfdupli-apagar-cex.parcela) 
            AND de-vl-baixa-aux + de-vl-tot-baixa <> de-vl-baixa-prev THEN
                ASSIGN de-vl-baixa-aux = de-vl-baixa-prev - de-vl-tot-baixa.
            
            FOR EACH tt_titulos_ems5  /*tit-ap.ep-codigo = i-empresa*/
               WHERE tt_titulos_ems5.tta_cod_estab_ext = bfdocum-est.cod-estabel
                 AND tt_titulos_ems5.cod-esp           = bfdupli-apagar-cex.cod-esp
                 AND tt_titulos_ems5.serie             = bfdupli-apagar-cex.serie-docto
                 AND tt_titulos_ems5.nr-docto          = bfdupli-apagar-cex.nro-docto 
                 AND tt_titulos_ems5.parcela           = bfdupli-apagar-cex.parcela NO-LOCK:
                
                IF  tt_titulos_ems5.vl-saldo-me <> 0 THEN DO:

                    FIND FIRST tt-previsao USE-INDEX codigo
                         WHERE tt-previsao.ep-cod-pre   = i-empresa
                           AND tt-previsao.cod-est-pre  = tt_titulos_ems5.cod-estab
                           AND tt-previsao.cod-esp-pre  = tt_titulos_ems5.cod-esp
                           AND tt-previsao.serie-pre    = tt_titulos_ems5.serie
                           AND tt-previsao.nr-docto-pre = tt_titulos_ems5.nr-docto
                           AND tt-previsao.parcela-pre  = tt_titulos_ems5.parcela 
                           AND tt-previsao.cod-fornec   = tt_titulos_ems5.cod-fornec                    
                           NO-ERROR.

                    IF  NOT AVAIL tt-previsao THEN DO:

                        CREATE tt-previsao.
                        ASSIGN tt-previsao.Ep-cod-pre   = i-empresa 
                               tt-previsao.Cod-est-pre  = tt_titulos_ems5.cod-estab
                               tt-previsao.Cod-esp-pre  = tt_titulos_ems5.cod-esp
                               tt-previsao.Serie-pre    = tt_titulos_ems5.serie
                               tt-previsao.Nr-docto-pre = tt_titulos_ems5.nr-docto         
                               tt-previsao.Parcela-pre  = tt_titulos_ems5.parcela
                               tt-previsao.Moeda-pre    = int(tt_titulos_ems5.moeda)
                               tt-previsao.Cod-fornec   = tt_titulos_ems5.cod-fornec
                               tt-previsao.cotacao-dia  = bfdocum-est.cotacao-dia.
                    END.

                    IF  de-vl-baixa-aux + tt-previsao.vl-previsao-me > tt_titulos_ems5.vl-saldo-me THEN
                        ASSIGN de-vl-baixa-aux =  tt_titulos_ems5.vl-saldo-me - tt-previsao.vl-previsao-me.

                    ASSIGN tt-previsao.vl-previsao-me = tt-previsao.vl-previsao-me 
                                                        + de-vl-baixa-aux     
                           tt-previsao.vl-previsao    = tt-previsao.vl-previsao-me * bfdocum-est.cotacao-dia
                           de-vl-tot-baixa            = de-vl-tot-baixa + de-vl-baixa-aux.

                    IF   de-vl-tot-baixa = de-vl-baixa-prev THEN
                         LEAVE.
                END.
            END.
        END.
    END. /* end for each item-doc-est */
END. /* end if principal */

/* fim do include */

