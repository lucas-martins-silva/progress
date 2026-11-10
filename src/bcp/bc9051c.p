/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9051C 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i bc9051C MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9051c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Finalidade: Adapter da transacao de Transferencia e Requisicao de alocados            **
**                                                                                         **
********************************************************************************************/
{bcp/bc9051.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter pRawConteudo as raw     No-undo.
Define Input-Output Parameter Table        For tt-erro.
/*********************************************************************************/

/*********************************************************************************/
Define Variable vNumProduto         As Integer              No-undo.
Define Variable vAdapterProgram     As Character            No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
Do:
    Find Last Param-BC No-lock No-error.

    If  Not AvailAble Param-BC Then Return 'NOK'.

    &if '{&mgcld_version}' >= '2.04':U &then
        ASSIGN vNumProduto = param-bc.ind-sistema.
    &else 
        Assign vNumProduto = Param-BC.int-2.   
    &endif

    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'bcp/bc9051d.p':U.
    End. /* Case */

    Create tt-transfere-prod-bc.
    Raw-Transfer pRawConteudo to tt-transfere-prod-bc.
    _AddField('nr-ord-produ              ':U, String(tt-transfere-prod-bc.nr-ord-produ         ),  'integer   ':U).
    _AddField('nr-req-sum                ':U, String(tt-transfere-prod-bc.nr-req-sum           ),  'integer   ':U).
    _AddField('cod-depos-ent             ':U, String(tt-transfere-prod-bc.cod-depos-ent        ),  'character ':U).
    _AddField('cod-localiz-ent           ':U, String(tt-transfere-prod-bc.cod-localiz-ent      ),  'character ':U).
    _AddField('cod-depos-sai             ':U, String(tt-transfere-prod-bc.cod-depos-sai        ),  'character ':U).
    _AddField('cod-localiz-sai           ':U, String(tt-transfere-prod-bc.cod-localiz-sai      ),  'character ':U).
    _AddField('it-codigo                 ':U, String(tt-transfere-prod-bc.it-codigo            ),  'character ':U).
    _AddField('cod-refer                 ':U, String(tt-transfere-prod-bc.cod-refer            ),  'character ':U).
    _AddField('lote-serie                ':U, String(tt-transfere-prod-bc.lote-serie           ),  'character ':U).
    _AddField('quantidade                ':U, String(tt-transfere-prod-bc.quantidade           ),  'decimal   ':U).
    _AddField('data-transacao            ':U, String(tt-transfere-prod-bc.data-transacao       ),  'date      ':U).
    _AddField('num-documento             ':U, String(tt-transfere-prod-bc.num-documento        ),  'character ':U).
    _AddField('cod-serie-documento       ':U, String(tt-transfere-prod-bc.cod-serie-documento  ),  'character ':U).
    _AddField('cod-usuario               ':U, String(tt-transfere-prod-bc.cod-usuario          ),  'character ':U).
    
    bc9051:
    DO on error  undo bc9051, leave bc9051
       on quit   undo bc9051, leave bc9051
       on stop   undo bc9051, leave bc9051
       on endkey undo bc9051, leave bc9051:
       Run Value(vAdapterProgram) (Input               pNumTrans,
                                   Input        Table  ttIntegracao,
                                   Input-Output Table  tt-erro) NO-ERROR.
    END.

    if error-status:error = YES then do:
        ASSIGN vsequencia = 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_de_execu‡Æo_da_PRE-API" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1).
    end. /* if */ 

End. /* Do Main */