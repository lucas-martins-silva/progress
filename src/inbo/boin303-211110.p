/******************************************************************************
    Programa .....: boin303-211110.p
    Data .........: 13/10/2025
    Empresa ......: TOTVS
    Objetivo .....: ExtensÆo BO tabela evento-trib-dfe referente ao
    Evento 211110 - Solicita‡Æo de Apropria‡Æo de Cr‚dito presumido
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-211110 1.00.00.005 } /*** "010005" 27/06/2026 08:02:31 ***/

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

    // Valida‡äes espec¡ficas do evento 211110
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            // Obrigat¢rio ter itens!
            IF NOT CAN-FIND(FIRST tt-evento-trib-dfe-item) THEN DO:
                RUN piCreateError (INPUT 58086,
                                   INPUT RowObject.cod-evento).
            END.

            IF  RowObject.idi-tip-autor <> 1           // Empresa emitente
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
                    {utp/ut-liter.i Sequˆncia_item_DF-e}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe +  RETURN-VALUE).  
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
                
                IF tt-evento-trib-dfe-item.valor-base = 0 OR tt-evento-trib-dfe-item.valor-base = ? THEN DO:
                    {utp/ut-liter.i Valor_da_base_de_c lculo_do_item}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe +  RETURN-VALUE).
                END.
                IF  (tt-evento-trib-dfe-item.cod-cred-pres-cbs = "0" OR tt-evento-trib-dfe-item.cod-cred-pres-cbs = " " OR tt-evento-trib-dfe-item.cod-cred-pres-cbs = ?) THEN
                DO:
                    {utp/ut-liter.i C¢digo_cCredPres}
                    RUN piCreateError (INPUT 26246,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE). 
                END.
                       
                IF  (tt-evento-trib-dfe-item.cod-cred-pres-cbs = "0" OR tt-evento-trib-dfe-item.cod-cred-pres-cbs = " " OR tt-evento-trib-dfe-item.cod-cred-pres-cbs = ?) 
                AND (   (tt-evento-trib-dfe-item.perc-credpres-cbs > 0 OR tt-evento-trib-dfe-item.valor-cbs > 0) 
                     OR (tt-evento-trib-dfe-item.perc-credpres-ibs > 0 OR tt-evento-trib-dfe-item.valor-ibs > 0) ) THEN DO:
                    {utp/ut-liter.i C¢digo_cCredPres}
                    RUN piCreateError (INPUT 33899,
                                       INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).   
                END.
                ELSE DO:
                    IF  tt-evento-trib-dfe-item.cod-cred-pres-cbs <> "0" 
                    AND tt-evento-trib-dfe-item.cod-cred-pres-cbs <> " " 
                    AND tt-evento-trib-dfe-item.cod-cred-pres-cbs <> ? THEN DO: 
                        /* Deve existir pelo menos um valor de cr‚dito */
                        IF  (tt-evento-trib-dfe-item.valor-cbs = 0 OR tt-evento-trib-dfe-item.valor-cbs = ?)
                        AND (tt-evento-trib-dfe-item.valor-ibs = 0 OR tt-evento-trib-dfe-item.valor-ibs = ?) THEN DO:
                              
                            {utp/ut-liter.i Valor_do_Cr‚dito_Presumido_CBS_ou_IBS}
                            RUN piCreateError (INPUT 26246,
                                               INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).  
                        END.
                        //Se informou percentual do cr‚dito presumido do CBS e nÆo informou valor
                        IF  tt-evento-trib-dfe-item.perc-credpres-cbs <> 0
                        AND tt-evento-trib-dfe-item.perc-credpres-cbs <> ?
                        AND (tt-evento-trib-dfe-item.valor-cbs = 0 OR tt-evento-trib-dfe-item.valor-cbs = ?) THEN DO:
                            {utp/ut-liter.i Valor_do_Cr‚dito_Presumido_CBS}
                            RUN piCreateError (INPUT 33899,
                                               INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                        END.
                        //Se informou percentual do cr‚dito presumido do IBS e nÆo informou valor
                        IF  tt-evento-trib-dfe-item.perc-credpres-ibs <> 0
                        AND tt-evento-trib-dfe-item.perc-credpres-ibs <> ? 
                        AND (tt-evento-trib-dfe-item.valor-ibs = 0 OR tt-evento-trib-dfe-item.valor-ibs = ?) THEN DO:
                            {utp/ut-liter.i Valor_do_Cr‚dito_Presumido_IBS}
                            RUN piCreateError (INPUT 33899,
                                               INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                        END.
                        
                        
                        //Se informou valor do cr‚dito presumido do CBS e nÆo informou percentual
                        IF tt-evento-trib-dfe-item.valor-cbs <> 0
                        AND tt-evento-trib-dfe-item.valor-cbs <> ? THEN DO:

                            IF tt-evento-trib-dfe-item.perc-credpres-cbs = 0
                            OR tt-evento-trib-dfe-item.perc-credpres-cbs = ? THEN DO:

                                {utp/ut-liter.i Percentual_do_Cr‚dito_Presumido_CBS}
                                RUN piCreateError (INPUT 26246,
                                                   INPUT c-label-completo-seq-item-dfe + RETURN-VALUE).
                            END.
                        END.
                        //Se informou valor do cr‚dito presumido do IBS e nÆo informou percentual
                        IF tt-evento-trib-dfe-item.valor-ibs <> 0
                        AND tt-evento-trib-dfe-item.valor-ibs <> ? THEN DO:

                            IF tt-evento-trib-dfe-item.perc-credpres-ibs = 0
                            OR tt-evento-trib-dfe-item.perc-credpres-ibs = ? THEN DO:

                                {utp/ut-liter.i Percentual_do_Cr‚dito_Presumido_IBS}
                                RUN piCreateError (INPUT 26246,
                                            INPUT c-label-completo-seq-item-dfe + RETURN-VALUE
                                ).
                            END.
                        END.
                        
                    END.
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

