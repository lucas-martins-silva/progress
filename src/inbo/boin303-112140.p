/******************************************************************************
    Programa .....: boin303-112140.p
    Data .........: 10/10/2025
    Empresa ......: TOTVS
    Objetivo .....: Extens∆o BO tabela evento-trib-dfe referente ao
    Evento 112140 - Fornecimento n„o realizado com pagamento antecipado
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-112140 1.00.00.002 } /*** "010002" 09/01/2026 09:09:36 ***/

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

    /* Validaá‰es espec°ficas do evento 112140 */
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

                /* valida se a sequencia do item foi informada */
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
                
                /* valida se a unidade de medida foi informado */
                IF tt-evento-trib-dfe-item.unid-med = "" OR tt-evento-trib-dfe-item.unid-med = ? THEN DO:
                    {utp/ut-liter.i Unidade_medida_n∆o_fornecida}
                    RUN piCreateError (INPUT 822,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                END.
                
                /* valida se a quantidade foi informada */
                IF tt-evento-trib-dfe-item.quantidade = 0 OR tt-evento-trib-dfe-item.quantidade = ? THEN DO:
                    IF tt-evento-trib-dfe-item.cod-evento = '112140' THEN DO:                        
                       FIND FIRST nota-fiscal WHERE nota-fiscal.cod-chave-aces-nf-eletro = tt-evento-trib-dfe-item.cod-chave-aces-nf-eletro NO-LOCK NO-ERROR.
                        
                       IF AVAIL nota-fiscal THEN DO:                                                                   
                          IF INT(TRIM(SUBSTRING(nota-fiscal.char-1,521,2))) > 0 AND INT(TRIM(SUBSTRING(nota-fiscal.char-1,521,2))) = 6 THEN DO: //Pagamento antecipado                                                   
                             IF INT(SUBSTR(nota-fiscal.char-2,211,2)) = 6 THEN DO:  //Nota de D≤bito                             
                                NEXT.    
                             END.                      
                          END.
                       END.
                    END.
                    {utp/ut-liter.i Quantidade_n∆o_fornecida  }
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
