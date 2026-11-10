/******************************************************************************
    Programa .....: boin303-211128.p
    Data .........: 13/10/2025
    Empresa ......: TOTVS
    Objetivo .....: ExtensÆo BO tabela evento-trib-dfe referente ao
    Evento 211128 - ÿAceite de d‚bito na apura‡Æo por emissÆo de nota de cr‚dito.
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-211128 1.00.00.000 } /*** "010000" ***/

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

    DEFINE VARIABLE c-label-indicador-aceite AS CHAR NO-UNDO.
    DEFINE VARIABLE c-label-tipo-autor AS CHAR NO-UNDO.
    
    DEFINE VARIABLE oIndicadorAceitacaoList   AS cdp.list.IndicadorAceitacaoList   NO-UNDO.
    
    FIND FIRST RowObject NO-LOCK NO-ERROR.

    // Valida‡äes espec¡ficas do evento 211150
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            
            IF RowObject.idi-tip-autor <> 2 THEN DO:  // Empresa destinat ria
                {utp/ut-liter.i Tipo_autor}
                ASSIGN c-label-tipo-autor = RETURN-VALUE.
                {utp/ut-liter.i o_evento }
                RUN piCreateError (INPUT 32241,
                                   INPUT c-label-tipo-autor + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)).
            END.
            
            
            IF RowObject.idi-ind-aceitacao = ? THEN DO:
               {utp/ut-liter.i Indicador_de_aceita‡Æo}
                ASSIGN c-label-indicador-aceite = RETURN-VALUE.
                {utp/ut-liter.i o_evento }
                RUN piCreateError (INPUT 32241,
                                   INPUT c-label-indicador-aceite + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)). 
            END.
            ELSE DO:
                oIndicadorAceitacaoList = new cdp.list.IndicadorAceitacaoList().

                IF oIndicadorAceitacaoList:existe(RowObject.idi-ind-aceitacao)  = NO THEN DO:
                
                    {utp/ut-liter.i Indicador_de_aceita‡Æo}
                    ASSIGN c-label-indicador-aceite = RETURN-VALUE.
                    {utp/ut-liter.i o_evento }
                    RUN piCreateError (INPUT 32241,
                                       INPUT c-label-indicador-aceite + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)). 
                
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
        DELETE OBJECT oIndicadorAceitacaoList NO-ERROR.
    END FINALLY.

END PROCEDURE.


