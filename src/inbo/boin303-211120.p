/******************************************************************************
    Programa .....: boin303-211110.p
    Data .........: 05/11/2025
    Empresa ......: TOTVS
    Objetivo .....: Extens∆o BO tabela evento-trib-dfe referente ao
    Evento 211120 - Destinaá∆o de item para consumo pessoal
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-211120 1.00.00.002 } /*** "010002" 30/12/2025 16:05:03 ***/

{method/dbotterr.i}
{utils/errorUtil.i}
{utp/ut-api-ctrl-rowerrors.i}
{inbo/boin303.i RowObject}
{inbo/boin304.i tt-evento-trib-dfe-item}

PROCEDURE validateRecord:
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    DEFINE INPUT  PARAM TABLE FOR RowObject. // tt-evento-trib-dfe
    DEFINE INPUT  PARAM TABLE FOR tt-evento-trib-dfe-item.
    DEFINE OUTPUT PARAM TABLE FOR RowErrors.

    DEFINE VARIABLE c-label-seq-item-dfe AS CHAR NO-UNDO.
    DEFINE VARIABLE c-label-completo-seq-item-dfe AS CHAR NO-UNDO.   
    DEFINE VARIABLE c-label-tipo-autor AS CHAR NO-UNDO.
    

    FIND FIRST RowObject NO-LOCK NO-ERROR.

    // Validaá‰es espec°ficas do evento 211120
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            // Obrigat¢rio ter itens!
            IF NOT CAN-FIND(FIRST tt-evento-trib-dfe-item) THEN DO:
                RUN piCreateError (INPUT 58086,
                                   INPUT RowObject.cod-evento).
            END.
            
            IF  RowObject.idi-tip-autor <> 1         //Empresa_emitente
            AND RowObject.idi-tip-autor <> 2 THEN DO:  // Empresa destinataria
                {utp/ut-liter.i Tipo_autor}
                ASSIGN c-label-tipo-autor = RETURN-VALUE.
                {utp/ut-liter.i o_evento }
                RUN piCreateError (INPUT 32241,
                                   INPUT c-label-tipo-autor + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)).
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
                ELSE DO:
                    IF tt-evento-trib-dfe-item.seq-item-nf > 990 THEN DO:
                        {utp/ut-liter.i item_DF-e}
                        RUN piCreateError (INPUT 58174,
                                           INPUT RETURN-VALUE + ' ' + string(tt-evento-trib-dfe-item.seq-item-nf)).
                    END.
                END.
                
                IF tt-evento-trib-dfe-item.it-codigo <> ? THEN DO:
                    IF NOT CAN-FIND (FIRST ITEM NO-LOCK WHERE ITEM.it-codigo = tt-evento-trib-dfe-item.it-codigo) THEN DO:
                        {utp/ut-liter.i item }
                        RUN piCreateError (INPUT 58176,
                                           INPUT RETURN-VALUE  + "~~" + c-label-completo-seq-item-dfe).
                    END.
                END.
                ELSE DO:
                    {utp/ut-liter.i item }
                    RUN piCreateError (INPUT 265,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                
                IF (tt-evento-trib-dfe-item.valor-cbs = 0 OR tt-evento-trib-dfe-item.valor-cbs = ?)
                AND (tt-evento-trib-dfe-item.valor-ibs = 0 OR tt-evento-trib-dfe-item.valor-ibs = ?) THEN DO:
                    {utp/ut-liter.i Valor_de_IBS_ou_CBS}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                
                IF tt-evento-trib-dfe-item.quantidade = 0 OR tt-evento-trib-dfe-item.quantidade = ? THEN DO:
                    {utp/ut-liter.i Quantidade_consumo}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                
                IF tt-evento-trib-dfe-item.unid-med = "" OR tt-evento-trib-dfe-item.unid-med = ? THEN DO:
                    {utp/ut-liter.i Unidade_medida_consumo}
                    RUN piCreateError (INPUT 822,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END. 
                
                IF tt-evento-trib-dfe-item.cod-chave-refNF = "" OR tt-evento-trib-dfe-item.cod-chave-refNF = ? THEN DO:
                    {utp/ut-liter.i Chave_de_acesso_do_documento_referenciado}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END. 
                
                IF length(tt-evento-trib-dfe-item.cod-chave-refNF) <> 44 THEN DO:
                    {utp/ut-liter.i Chave_de_acesso_do_documento_referenciado}
                    RUN piCreateError (INPUT 54898,
                                       INPUT c-label-completo-seq-item-dfe + return-value + "~~44").
                END.                             
                
                if tt-evento-trib-dfe-item.seq-item-refNF = 0 OR tt-evento-trib-dfe-item.seq-item-refNF = ? THEN DO:
                    {utp/ut-liter.i Seq_item_do_documento_referenciado}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).               
                END.               
                            
            END.
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

