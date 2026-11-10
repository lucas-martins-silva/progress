/******************************************************************************
    Programa .....: boin303-112150.p
    Data .........: 13/10/2025
    Empresa ......: TOTVS
    Objetivo .....: Extens∆o BO tabela evento-trib-dfe referente ao
    Evento 112150 - Atualizaá∆o da data de previs∆o de entrega
*******************************************************************************/
BLOCK-LEVEL ON ERROR UNDO, THROW.

USING com.totvs.framework.api.*.

{include/i-prgvrs.i boin303-112150 1.00.00.001 } /*** "010001" 09/01/2026 09:09:36 ***/

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

    DEFINE VARIABLE c-label-dt-prev-ent  AS CHAR NO-UNDO.
    DEFINE VARIABLE c-label-tipo-autor   AS CHAR NO-UNDO.
    
    FIND FIRST RowObject NO-LOCK NO-ERROR.

    // Validaá‰es espec°ficas do evento 211150
    CASE pType:
        WHEN "Create":U OR WHEN "Update":U THEN DO:
            
            IF RowObject.idi-tip-autor <> 1 THEN DO:  // Empresa emitente
                {utp/ut-liter.i Tipo_autor}
                ASSIGN c-label-tipo-autor = RETURN-VALUE.
                {utp/ut-liter.i o_evento }
                RUN piCreateError (INPUT 32241,
                                   INPUT c-label-tipo-autor + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)).
            END.
            
            IF  RowObject.dt-prev-entrega = ? THEN DO:
               {utp/ut-liter.i Data_de_previs∆o_de_entrega}
                ASSIGN c-label-dt-prev-ent = RETURN-VALUE.
                {utp/ut-liter.i o_evento }
                RUN piCreateError (INPUT 32241,
                                   INPUT c-label-dt-prev-ent + '~~' + RETURN-VALUE + ' ' + STRING(RowObject.cod-evento)). 
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


