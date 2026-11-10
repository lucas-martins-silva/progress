/******************************************************************************
    Programa .....: boin303-112130.p
    Data .........: 30/09/2025
    Empresa ......: TOTVS
    Objetivo .....: Extens∆o BO tabela evento-trib-dfe referente ao
    Evento 112130 - Perecimento, perda, roubo ou furto durante o transporte contratado pelo fornecedor 
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-112130 1.00.00.002 } /*** "010002" 09/01/2026 09:09:36 ***/

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

    DEFINE VARIABLE c-label-seq-item-dfe          AS CHAR NO-UNDO.
    DEFINE VARIABLE c-label-completo-seq-item-dfe AS CHAR NO-UNDO.
    DEFINE VARIABLE c-label-tipo-autor            AS CHAR NO-UNDO.
    
    FIND FIRST RowObject NO-LOCK NO-ERROR.

    /* Validaá‰es espec°ficas do evento 112130 */
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            /* valida se tem itens */
            IF NOT CAN-FIND(FIRST tt-evento-trib-dfe-item) THEN DO:
                RUN piCreateError (INPUT 58086,
                                   INPUT RowObject.cod-evento).
            END.
            
            /* valida se o tipo autor esta como emitente */
            IF RowObject.idi-tip-autor <> 1 THEN DO: /* Empresa emitente */
                {utp/ut-liter.i Tipo_autor}
                ASSIGN c-label-tipo-autor = RETURN-VALUE.
                {utp/ut-liter.i o_evento }
                RUN piCreateError (INPUT 32241,
                                   INPUT c-label-tipo-autor + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)).
            END.

            {utp/ut-liter.i Seq_item_NF-e}
            ASSIGN c-label-seq-item-dfe = RETURN-VALUE + ": ".

            FOR EACH tt-evento-trib-dfe-item:
                ASSIGN c-label-completo-seq-item-dfe = c-label-seq-item-dfe + STRING(tt-evento-trib-dfe-item.seq-item-nf) + " - ".

                IF tt-evento-trib-dfe-item.seq-item-nf = 0 OR tt-evento-trib-dfe-item.seq-item-nf = ? THEN DO:
                    {utp/ut-liter.i Sequància_item_NF-e}
                    RUN piCreateError (INPUT 26246,
                                       INPUT RETURN-VALUE).
                END.
                ELSE DO:
                    /* valida se a sequencia do item passou de 990 (99 itens) */
                    IF tt-evento-trib-dfe-item.seq-item-nf > 990 THEN DO:
                        {utp/ut-liter.i item_DF-e}
                        RUN piCreateError (INPUT 58174,
                                          INPUT RETURN-VALUE + ' ' + string(tt-evento-trib-dfe-item.seq-item-nf)).
                    END.
                END.
                
                /* valida se o item informado existe na base &*/
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

                IF tt-evento-trib-dfe-item.quantidade = 0 OR tt-evento-trib-dfe-item.quantidade = ? THEN DO:
                    {utp/ut-liter.i Quantidade_perda}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                IF tt-evento-trib-dfe-item.unid-med = "" OR tt-evento-trib-dfe-item.unid-med = ? THEN DO:
                    {utp/ut-liter.i Unidade_medida_perda}
                    RUN piCreateError (INPUT 822,
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
