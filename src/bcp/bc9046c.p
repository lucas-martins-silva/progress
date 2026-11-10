/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9046C 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9046c MBC}
&ENDIF


{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
{method/dbotterr.i}

{wmp/wm0552.i ttMovto}
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */

/*{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */*/

DEFINE INPUT        PARAMETER pNumTrans    AS INTEGER NO-UNDO.
DEFINE INPUT        PARAMETER pRawConteudo AS RAW     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE        FOR tt-erro.

FIND FIRST bc-trans NO-LOCK
     WHERE bc-trans.nr-trans = pNumTrans NO-ERROR.
IF AVAIL bc-trans THEN DO:
    CREATE ttMovto.
    ASSIGN ttMovto.cod-estabel  = ENTRY(2, ENTRY(1, bc-trans.detalhe,';':U), ':':U)
           ttMovto.cod-local    = ENTRY(2, ENTRY(2, bc-trans.detalhe,';':U), ':':U)
           ttMovto.id-docto     = INTEGER(ENTRY(2, ENTRY(4,bc-trans.detalhe, ';':U), ':':U))
           ttMovto.num-seq-item = INTEGER(ENTRY(2, ENTRY(6,bc-trans.detalhe, ';':U), ':':U))
           ttMovto.cod-refer    = ENTRY(2, ENTRY(7, bc-trans.detalhe,';':U), ':':U)
           ttMovto.cod-lote     = ENTRY(2, ENTRY(8, bc-trans.detalhe,';':U), ':':U)
           ttMovto.qtd-item     = DECIMAL(ENTRY(2, ENTRY(9,bc-trans.detalhe, ';':U), ':':U)).
END.

EMPTY TEMP-TABLE RowErrors.
RUN wmp/wm0552.p (INPUT  TODAY,
                  INPUT  TABLE ttMovto,
                  OUTPUT TABLE RowErrors).
IF CAN-FIND(FIRST RowErrors) THEN DO:
    FOR EACH RowErrors:
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = RowErrors.ErrorSequence
               tt-erro.cd-erro  = RowErrors.ErrorNumber
               tt-erro.mensagem = RowErrors.ErrorDescription + "(WMS)".
    END.
    RETURN "NOK".
END.

RETURN "OK":U.
