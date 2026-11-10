/******************************************************************************
    Programa .....: boin303-211130.p
    Data .........: 17/10/2025
    Empresa ......: TOTVS
    Objetivo .....: Extens∆o BO tabela evento-trib-dfe referente ao
    Evento 211130 - Imobilizaá∆o do Item
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-211130 1.00.00.002 } /*** "010002" 06/01/2026 13:54:50 ***/

{method/dbotterr.i}
{utils/errorUtil.i}
{utp/ut-api-ctrl-rowerrors.i}
{inbo/boin303.i RowObject}
{inbo/boin304.i tt-evento-trib-dfe-item}
{inbo/boin303-211130.i tt-bem-pat-event-trib-dfe}
def temp-table tt-bem-pat-event-trib-dfe-aux no-undo like tt-bem-pat-event-trib-dfe.

PROCEDURE validateRecord:
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR RowObject. // tt-evento-trib-dfe
    DEFINE INPUT  PARAM TABLE FOR tt-evento-trib-dfe-item.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-label-seq-item-dfe AS CHAR NO-UNDO.
    DEFINE VARIABLE c-label-completo-seq-item-dfe AS CHAR NO-UNDO.
    DEFINE VARIABLE hdlDBOEms5           AS HANDLE NO-UNDO.
    DEFINE VARIABLE i-num-cont-reg       as int    no-undo.
    define variable c-des-param-msg      as char   no-undo.
    define variable i-errorNumber        as int    no-undo.
    define variable c-errorparameters    as char   no-undo.
    FIND FIRST RowObject NO-LOCK NO-ERROR.

    IF  RowObject.idi-tip-autor = 1 THEN DO:
        {utp/ut-liter.i Imobilizaá∆o_de_Item}
        assign c-des-param-msg = "211130 - ":U + return-value.
        {utp/ut-liter.i Empresa_Destinat†ria}
        assign c-des-param-msg = c-des-param-msg + "~~" + "2 - ":U + return-value.
        RUN piCreateError (INPUT 58187,
                           INPUT c-des-param-msg).
    END.
    
    IF  RowObject.modulo-orig-info = "FAS" THEN
        RUN getTTEventoTribDfeBensItem IN SOURCE-PROCEDURE (OUTPUT TABLE tt-bem-pat-event-trib-dfe).

    // Validaá‰es espec°ficas do evento 211130
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            // Obrigat¢rio ter itens!
            IF NOT CAN-FIND(FIRST tt-evento-trib-dfe-item) THEN DO:
                RUN piCreateError (INPUT 58086,
                                   INPUT RowObject.cod-evento).
            END.

            {utp/ut-liter.i Seq_item_DF-e}
            ASSIGN c-label-seq-item-dfe = RETURN-VALUE + ": ".

            FOR EACH tt-evento-trib-dfe-item:
                ASSIGN c-label-completo-seq-item-dfe = c-label-seq-item-dfe + STRING(tt-evento-trib-dfe-item.seq-item-nf) + " - ".

                IF tt-evento-trib-dfe-item.seq-item-nf = 0 OR tt-evento-trib-dfe-item.seq-item-nf = ? THEN DO:
                    {utp/ut-liter.i Sequància_item_DF-e}
                    RUN piCreateError (INPUT 26246,
                                       INPUT RETURN-VALUE).
                END.
                IF tt-evento-trib-dfe-item.quantidade = 0 OR tt-evento-trib-dfe-item.quantidade = ? THEN DO:
                    {utp/ut-liter.i Quantidade_imobilizaá∆o}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                IF tt-evento-trib-dfe-item.unid-med = "" OR tt-evento-trib-dfe-item.unid-med = ? THEN DO:
                    {utp/ut-liter.i Unidade_medida_imobilizaá∆o}
                    RUN piCreateError (INPUT 822,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                IF tt-evento-trib-dfe-item.valor-ibs = 0 OR tt-evento-trib-dfe-item.valor-ibs = ? THEN DO:
                    {utp/ut-liter.i Valor_IBS}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                IF tt-evento-trib-dfe-item.valor-cbs = 0 OR tt-evento-trib-dfe-item.valor-cbs = ? THEN DO:
                    {utp/ut-liter.i Valor_CBS}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                IF  RowObject.modulo-orig-info = "FAS" THEN DO:
                    assign i-num-cont-reg = 0.
                    empty temp-table tt-bem-pat-event-trib-dfe-aux.
                    for each  tt-bem-pat-event-trib-dfe no-lock
                        where tt-bem-pat-event-trib-dfe.cod_chave_aces_docto_fisc = tt-evento-trib-dfe-item.cod-chave-aces-nf-eletro
                        and   tt-bem-pat-event-trib-dfe.cod_evento                = tt-evento-trib-dfe-item.cod-evento
                        and   tt-bem-pat-event-trib-dfe.num_seq_event             = tt-evento-trib-dfe-item.seq-evento
                        and   tt-bem-pat-event-trib-dfe.num_seq_item_xml          = tt-evento-trib-dfe-item.seq-item-nf:
                        assign i-num-cont-reg = i-num-cont-reg + 1.
                        create tt-bem-pat-event-trib-dfe-aux.
                        buffer-copy tt-bem-pat-event-trib-dfe to tt-bem-pat-event-trib-dfe-aux.
                    end.
                    case i-num-cont-reg:
                        when 0 then do:
                            {utp/ut-liter.i Bem_patrimonial}
                            RUN piCreateError (INPUT 8099,
                                               INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                        end.
                        when 1 then do:
                            IF  NOT VALID-HANDLE(hdlDBOEms5) THEN
                                RUN prgfin/fas/fas929za.py PERSISTENT SET hdlDBOEms5.

                            FIND FIRST tt-bem-pat-event-trib-dfe-aux NO-LOCK NO-ERROR.
                            if  tt-bem-pat-event-trib-dfe-aux.cdn_fornecedor <> RowObject.cod-emitente then do:
                                {utp/ut-liter.i Fornecedor}
                                RUN piCreateError (INPUT 58186,
                                                   INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                                
                            end.
                            if  tt-bem-pat-event-trib-dfe-aux.cod_docto_entr <> RowObject.nro-docto then do:
                                {utp/ut-liter.i N£mero_Documento}
                                RUN piCreateError (INPUT 58186,
                                                   INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                                
                            end.
                            if  tt-bem-pat-event-trib-dfe-aux.cod_ser_nota <> RowObject.serie-docto then do:
                                {utp/ut-liter.i SÇrie_Nota}
                                RUN piCreateError (INPUT 58186,
                                                   INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                                
                            end.
                            RUN pi_valida_bem_pat_event_trib_dfe IN hdlDBOEms5 (INPUT TABLE tt-bem-pat-event-trib-dfe-aux,
                                                                                INPUT c-label-completo-seq-item-dfe,
                                                                                output i-errorNumber,
                                                                                output c-errorparameters).
                            if  i-errorNumber > 0 then
                                RUN piCreateError (INPUT i-errorNumber,
                                                   INPUT c-errorparameters).
                        end.
                        otherwise do:
                            {utp/ut-liter.i Apenas_um_bem_patrimonial}
                            assign c-des-param-msg = c-label-completo-seq-item-dfe + return-value.
                            {utp/ut-liter.i cada_item_do_evento}
                            assign c-des-param-msg = c-des-param-msg + "~~" + return-value.
                            RUN piCreateError (INPUT 34996,
                                               INPUT c-des-param-msg).
                        end.
                    end case.
                END.
            END.
            IF  VALID-HANDLE(hdlDBOEms5) THEN
                DELETE PROCEDURE hdlDBOEms5 NO-ERROR.
        END.
    END CASE.

    RETURN "OK":U.

    CATCH Erro as Progress.lang.Error:
        fn-catch-to-row-errors(Erro).
        RETURN "NOK":U.
    END CATCH.

    FINALLY:
    END FINALLY.

END PROCEDURE.

