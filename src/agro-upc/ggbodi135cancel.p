/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGBODI135CANCEL 2.00.00.023 } /*** "010023" 29/05/2025 09:23:33 ***/

/*************************************************************************
**    Programa.:  
**    Objetivo.:  
**    Data.....:  JULHO de 2007
*************************************************************************/

{include/i-epc200.i1} /* definicao da temp-table tt-epc */
{cdp/cdcfgmat.i}
{include/i_fncrowid.i} /* Pre-processador da substituicao do RECID pelo ROWID */

{ggp/gg0003.i}
{ggbo/bogg00757.i ttLote}
{ggbo/bogg00759.i ttLoteMov}

DEF INPUT        PARAM p-ind-event AS CHAR NO-UNDO.
DEF INPUT-OUTPUT PARAM TABLE       FOR tt-epc.

DEF TEMP-TABLE ttErrosIntegracao NO-UNDO
    FIELD numMensagem       AS INTEGER   FORMAT ">>>>,>>9" LABEL "N£mero"
    FIELD tipoMensagem      AS INTEGER   FORMAT ">9"       LABEL "Tipo Mensagem " /*1-Erro, 2-Advertˆncia, 3-Pergunta, 4-Informa‡Æo */
    FIELD desMsgErro        AS CHARACTER FORMAT "x(60)"    LABEL "Mensagem Erro"
    FIELD desMsgAjuda       AS CHARACTER FORMAT "x(2000)"  LABEL "Mensagem Ajuda"
    .

DEF TEMP-TABLE ttTradEst NO-UNDO
    FIELD codEstabel2 AS CHARACTER
    FIELD codEstabel5 AS CHARACTER.

DEF NEW GLOBAL SHARED VAR c-seg-usuario AS CHAR FORMAT "x(12)" NO-UNDO.

DEFINE VARIABLE rw-param       AS ROWID       NO-UNDO.
DEFINE VARIABLE h-acr933zb     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-ggp702za     AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bogg00757    AS HANDLE      NO-UNDO.
DEFINE VARIABLE cParametro     AS CHARACTER   NO-UNDO.
DEFINE VARIABLE indTransAbrev  AS INTEGER     NO-UNDO.
DEFINE VARIABLE h-bogg00759    AS HANDLE      NO-UNDO.
DEF BUFFER bf-it-nota-fisc FOR it-nota-fisc.

RUN prgagro/ggp/ggp702za.py  PERSISTENT SET h-ggp702za.
RUN prgfin/acr/acr933zb.py PERSISTENT SET h-acr933zb.


IF  p-ind-event = "beforeexecutacancela":U THEN DO:   

    FIND FIRST tt-epc NO-LOCK
         WHERE tt-epc.cod-event     = "beforeexecutacancela":U 
           AND tt-epc.cod-parameter = "Table-Rowid":U NO-ERROR.

    ASSIGN rw-param = TO-ROWID(tt-epc.val-parameter).

    FIND FIRST nota-fiscal NO-LOCK
         WHERE ROWID(nota-fiscal) = rw-param NO-ERROR.

    IF  AVAIL nota-fiscal THEN DO:

        if  nota-fiscal.ind-tip-nota = 8 /* Recebimento */ then do:

            for each bf-it-nota-fisc NO-LOCK OF nota-fiscal:

                FIND FIRST item-doc-est 
                    WHERE item-doc-est.serie-docto  = bf-it-nota-fisc.serie 
                      AND item-doc-est.nro-docto    = bf-it-nota-fisc.nr-nota-fis
                      AND item-doc-est.cod-emitente = nota-fiscal.cod-emitente
                      AND item-doc-est.nat-operacao = bf-it-nota-fisc.nat-operacao 
                      AND item-doc-est.sequencia    = bf-it-nota-fisc.nr-seq-fat NO-LOCK NO-ERROR.
                if  avail item-doc-est and bf-it-nota-fisc.dt-cancela <> ? then do:

                    FIND FIRST gg-mov-contr NO-LOCK
                        WHERE gg-mov-contr.cod-estabel  = bf-it-nota-fisc.cod-estabel 
                          AND gg-mov-contr.num-romaneio = INT(SUBSTR(bf-it-nota-fisc.char-2,232,9))
                          AND gg-mov-contr.num-seq      = INT(SUBSTR(bf-it-nota-fisc.char-2,241,6)) NO-ERROR.
                    IF  AVAIL gg-mov-contr THEN DO:
                        FIND FIRST gg-mov NO-LOCK OF gg-mov-contr NO-ERROR.
                        IF  gg-mov.ind-tip-mov = 1 THEN DO: /* Entrada Compra */

                            FOR EACH  gg-contrato-mov NO-LOCK
                                WHERE gg-contrato-mov.cod-estabel   = gg-mov-contr.cod-estabel
                                  AND gg-contrato-mov.num-romaneio  = gg-mov-contr.num-romaneio
                                  AND gg-contrato-mov.referencia    = STRING(gg-mov-contr.num-seq)
                                  AND gg-contrato-mov.ep-codigo     = gg-mov-contr.ep-codigo
                                  AND gg-contrato-mov.cod-contrato  = gg-mov-contr.cod-contrato:

                                IF  (gg-contrato-mov.qtd-alocada-fechto + gg-contrato-mov.qtd-pago) > 0 THEN DO:
    
                                    RUN utp/ut-msgs.p (INPUT "HELP",
                                                       INPUT 35614,
                                                       INPUT "").
    
                                    CREATE tt-epc.
                                    ASSIGN tt-epc.cod-event     = 'beforeexecutacancela':u
                                           tt-epc.cod-parameter = 'EPC-ERROR'
                                           tt-epc.val-parameter = RETURN-VALUE.
                                END.
                            END.
                        END.
                    END.
                END.            
            END.
        END.
        
        FOR EACH fat-duplic NO-LOCK
             WHERE fat-duplic.cod-estabel   = nota-fiscal.cod-estabel
               AND fat-duplic.serie         = nota-fiscal.serie
               AND fat-duplic.nr-fatura     = nota-fiscal.nr-nota-fis:

            FOR FIRST gg-ext-titulo NO-LOCK
                WHERE gg-ext-titulo.cod-estab        = fat-duplic.cod-estabel
                  AND gg-ext-titulo.cod-espec-docto  = fat-duplic.cod-esp
                  AND gg-ext-titulo.cod-ser-docto    = fat-duplic.serie
                  AND gg-ext-titulo.cod-tit-acr      = fat-duplic.nr-fatura
                  AND gg-ext-titulo.cod-parcela      = fat-duplic.parcela
                  AND gg-ext-titulo.num-id-tit-juros > 0:

                EMPTY TEMP-TABLE tt_consult_tit_acr NO-ERROR.
    
                CREATE tt_consult_tit_acr.
                ASSIGN tt_consult_tit_acr.ttv_num_tip_leitura       = 2 /* NUM_ID */
                       tt_consult_tit_acr.tta_num_id_tit_acr        = gg-ext-titulo.num-id-tit-juros
                       tt_consult_tit_acr.ttv_log_val_tit_acr       = NO
                       tt_consult_tit_acr.ttv_log_movto_tit_acr     = YES
                       tt_consult_tit_acr.ttv_log_val_movto_tit_acr = NO
                       tt_consult_tit_acr.ttv_log_correc_movto      = NO.

                {ggp/gg0005.i  gg-ext-titulo.cod-estab tt_consult_tit_acr.tta_cod_estab} /* traduz estabelecimento 2 x 5 */
        
                RUN pi_consult_tit_acr IN h-acr933zb (INPUT  TABLE tt_consult_tit_acr,
                                                      OUTPUT TABLE tt_retorno_tit_acr,
                                                      OUTPUT TABLE tt_retorno_val_tit_acr,
                                                      OUTPUT TABLE tt_retorno_movto_tit_acr,
                                                      OUTPUT TABLE tt_retorno_val_movto_tit_acr,
                                                      OUTPUT TABLE tt_retorno_correc_val_movto,
                                                      OUTPUT TABLE tt_log_erro).
    
                IF CAN-FIND(FIRST tt_log_erro) 
                OR CAN-FIND(FIRST tt_retorno_tit_acr
                            WHERE tt_retorno_tit_acr.log_tit_acr_estordo = NO)
                OR CAN-FIND(FIRST tt_retorno_movto_tit_acr
                            WHERE tt_retorno_movto_tit_acr.LOG_movto_estordo = NO) THEN DO:
    
                        
                    FIND FIRST tt_retorno_movto_tit_acr NO-ERROR.
        
                    {utp/ut-liter.i "Ref. Cancelamento Nota Fiscal" * R}
                    ASSIGN cParametro = RETURN-VALUE.
                    
                    RUN ggp/ggapi814b.p (INPUT  tt_retorno_movto_tit_acr.cod_estab,
                                         INPUT  0,
                                         INPUT  tt_retorno_movto_tit_acr.num_id_movto_tit_acr,
                                         INPUT  nota-fiscal.dt-emis-nota,
                                         INPUT  cParametro,
                                         OUTPUT indTransAbrev,
                                         OUTPUT TABLE ttErrosIntegracao).     
        
                    FOR EACH ttErrosIntegracao:
                        CREATE tt-epc.
                        ASSIGN tt-epc.cod-event     = 'beforeexecutacancela':u
                               tt-epc.cod-parameter = 'EPC-ERROR'
                               tt-epc.val-parameter = ttErrosIntegracao.desMsgErro.
                    END.
                END.
            END.
        END.


        /****************** Acertar Calculo Servico de Armazenagem ****************/
        IF  nota-fiscal.ind-tip-nota <> 8 /* Recebimento */ THEN /* Notas de Sa¡da */
            RUN ggp/gg5053g.p (INPUT nota-fiscal.cod-estabel, /* estab */
                               INPUT 0,                       /* romaneio*/
                               INPUT nota-fiscal.nr-nota-fis, /* nota fiscal */
                               INPUT nota-fiscal.serie).      /* serie */



        /*--- Ajuste dos Lotes ---*/
         IF  NOT VALID-HANDLE(h-bogg00759) THEN
             RUN ggbo/bogg00759.p PERSISTENT SET h-bogg00759.

        IF  NOT VALID-HANDLE(h-bogg00757) THEN
            RUN ggbo/bogg00757.p PERSISTENT SET h-bogg00757.
        
        RUN openQueryStatic IN h-bogg00757 ( "Main":U ) NO-ERROR.
        RUN emptyRowErrors  IN h-bogg00757.
   
        // busca os itens da nota
        FOR EACH it-nota-fisc NO-LOCK OF nota-fiscal:

            // verifica os lotes faturados
            FOR EACH  fat-ser-lote NO-LOCK
                WHERE fat-ser-lote.cod-estabel = it-nota-fisc.cod-estabel
                AND   fat-ser-lote.serie       = it-nota-fisc.serie
                AND   fat-ser-lote.nr-nota-fis = it-nota-fisc.nr-nota-fis
                AND   fat-ser-lote.it-codigo   = it-nota-fisc.it-codigo
                AND   fat-ser-lote.nr-seq-fat  = it-nota-fisc.nr-seq-fat:

                // busca o lote no GrÆos
                FIND FIRST gg-lote NO-LOCK
                    WHERE  gg-lote.cod-lote       = fat-ser-lote.nr-serlote
                    AND    gg-lote.it-codigo      = fat-ser-lote.it-codigo  
                    AND    gg-lote.cod-refer-item = fat-ser-lote.cod-refer NO-ERROR.
                IF  AVAIL  gg-lote THEN DO:

                    // Ajusta a quantidade nos contratos da instru‡Æo
                    FIND FIRST gg-libera-embarq NO-LOCK
                        WHERE  gg-libera-embarq.ep-codigo   = gg-lote.ep-codigo
                        AND    gg-libera-embarq.num-instruc = gg-lote.num-instruc NO-ERROR.
                    IF  AVAIL  gg-libera-embarq THEN DO:
                        FOR FIRST gg-libera-embarq-contrat EXCLUSIVE-LOCK
                            WHERE gg-libera-embarq-contrat.ep-codigo    = gg-libera-embarq.ep-codigo
                              AND gg-libera-embarq-contrat.num-instruc  = gg-libera-embarq.num-instruc
                              AND gg-libera-embarq-contrat.cod-contrato = gg-lote.cod-contrato
                              AND gg-libera-embarq-contrat.num-seq-produt = gg-lote.num-seq-prod:
                            ASSIGN gg-libera-embarq-contrat.qtd-exped = gg-libera-embarq-contrat.qtd-exped - fat-ser-lote.qt-baixada[1].
                        END.
                    END.
    
                    EMPTY TEMP-TABLE ttLote.
                    RUN goToKey   IN h-bogg00757 ( INPUT gg-lote.num-id-lote ).
                    RUN getRecord IN h-bogg00757 ( OUTPUT TABLE ttLote).
                    
                    FIND FIRST ttLote NO-ERROR.
					                    
                    // Ajusta o status do lote
                    IF  gg-lote.idi-status = 6 /* Remetido */ THEN
                        ASSIGN ttLote.idi-status = 4 /* Instru¡do */.
                    ELSE DO:
                        IF  gg-lote.idi-status = 5 /* Faturado */ THEN DO:
                            ASSIGN ttLote.idi-status = 4 /* Instru¡do */.

                            // Se for a remessa, deve voltar para remetido
                            IF  AVAIL  gg-libera-embarq AND gg-libera-embarq.idi-instruc = 3 /* Remessa Terceiros */ THEN
                                ASSIGN ttLote.idi-status = 6 /* Remetido */.
                        END.
                    END.

                    RUN setRecord    IN h-bogg00757 ( INPUT TABLE ttLote ).
                    RUN updateRecord IN h-bogg00757.
                    
                    IF  nota-fiscal.esp-docto     = 23 /* NFT */ THEN DO: 
                        CREATE ttLoteMov.
                        RUN piRetornaUltSeq IN h-bogg00759 ( INPUT gg-Lote.num-id-lote, OUTPUT ttLoteMov.num-seq).
        
                        ASSIGN ttLoteMov.num-id-lote     = gg-Lote.num-id-lote
                               ttLoteMov.cod-estabel     = gg-lote.cod-estabel
                               ttLoteMov.it-codigo       = gg-lote.it-codigo
                               ttLoteMov.cod-refer-item  = gg-lote.cod-refer-item
                               ttLoteMov.qtd-movto-item  = gg-lote.qtd-lote
                               ttLoteMov.dat-atualiz     = TODAY
                               ttLoteMov.hra-atualiz     = STRING(TIME, "HH:MM:SS")
                               ttLoteMov.nro-docto       = it-nota-fisc.nr-nota-fis  
                               ttLoteMov.serie-docto     = it-nota-fisc.serie       
                               ttLoteMov.nr-ord-produ    = it-nota-fisc.nr-ord-prod
                               ttLoteMov.idi-trans       = 7 /* Estornado */
                               ttLoteMov.cod-usuario      = c-seg-usuario
                               ttLoteMov.num-seq         = ttLoteMov.num-seq + 1.
                        
                        {utp/ut-liter.i " Estorno NFT Saida " *}
                        ASSIGN ttLoteMov.des-obs = ttLoteMov.des-obs +  ' ' + RETURN-VALUE .
                        RUN openQueryStatic IN h-bogg00759 ( "Main":U ).
        				RUN emptyRowErrors  IN h-bogg00759.
                        RUN setRecord       IN h-bogg00759 ( INPUT TABLE ttLoteMov ).
                        RUN createRecord    IN h-bogg00759.
    				END.
                    ELSE DO:
                        // Ajusta as informa‡äes da integra‡Æo com o Beneficiamento, buscando o movimento relacionado ao faturamento da nota
                        FIND FIRST gg-lote-mov EXCLUSIVE-LOCK
                            WHERE  gg-lote-mov.num-id-lote = gg-lote.num-id-lote
                            AND    gg-lote-mov.num-seq-nf  = fat-ser-lote.nr-seq-fat
                            AND   (gg-lote-mov.idi-trans   = 5 /* Faturamento */ OR
                                   gg-lote-mov.idi-trans   = 6 /* Remessa     */) NO-ERROR.
                        IF  AVAIL  gg-lote-mov AND gg-lote-mov.num-livre-1 > 1 /* Integrado */ THEN
                            ASSIGN gg-lote-mov.num-livre-1 = 0 /* Sem Integra‡Æo */.

                        /* quando forem criados os campos na tabela, somente retirar essa parte de coment rio
                        IF  AVAIL  gg-lote-mov AND gg-lote-mov.idi-integracao > 1 /* Integrado */ THEN
                            ASSIGN gg-lote-mov.idi-integracao = 0 /* Sem Integra‡Æo */.
                        */
                    END.  
                END.
            END.
        END.

        IF  VALID-HANDLE(h-bogg00757) THEN DO:
            RUN destroy IN h-bogg00757.
            ASSIGN h-bogg00757 = ?.
        END.

         IF  VALID-HANDLE(h-bogg00759) THEN
             DELETE PROCEDURE h-bogg00759.

        /*--- FIM - Ajuste dos Lotes ---*/

    END.
END.

IF  VALID-HANDLE(h-acr933zb) THEN
    DELETE PROCEDURE h-acr933zb.

IF VALID-HANDLE(h-ggp702za) THEN
    DELETE PROCEDURE  h-ggp702za.

RETURN "OK":U.
