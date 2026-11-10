/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9019D 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9019D MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9019d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karen - Cria‡Æo do programa                  **
**                                                                                         **
**   Finalidade: Adapter da transacao de Packing WMS                                       ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9019.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
/**********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg":U,
                            input 25346,
                            input "bc9003d":U).
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value).
        Return 'NOK':U.
    End.

    Create tt-packing-wms.

    Assign tt-packing-wms.cod-estabel       = _RetornaValChar('cod-estabel    ':U).
           tt-packing-wms.cod-usuario       = _RetornaValChar('cod-usuario    ':U).
           tt-packing-wms.cod-coletor       = _RetornaValChar('cod-coletor    ':U).
           tt-packing-wms.cod-equipamento   = _RetornaValChar('cod-equipamento':U).
           tt-packing-wms.cod-local         = _RetornaValChar('cod-local      ':U).
           tt-packing-wms.cod-pedcli        = _RetornaValChar('cod-pedcli     ':U).
           tt-packing-wms.nom-abrev         = _RetornaValChar('nom-abrev      ':U).
           tt-packing-wms.cdd-embarq        = _RetornaValDeci('cdd-embarq     ':U).
           tt-packing-wms.num-resumo        = _RetornaValInte('num-resumo     ':U).
           tt-packing-wms.cod-volume        = _RetornaValChar('cod-volume     ':U).
           tt-packing-wms.num-documento     = _RetornaValDeci('num-documento  ':U).
           tt-packing-wms.num-tarefa        = _RetornaValDeci('num-tarefa     ':U).
           tt-packing-wms.num-volume        = _RetornaValInte('num-volume     ':U).
           tt-packing-wms.num-seq-volume    = _RetornaValInte('num-seq-volume ':U).
           tt-packing-wms.num-serial        = _RetornaValDeci('num-serial     ':U).
           tt-packing-wms.cod-item          = _RetornaValChar('cod-item       ':U).
           tt-packing-wms.cod-lote          = _RetornaValChar('cod-lote       ':U).
           tt-packing-wms.cod-refer         = _RetornaValChar('cod-refer      ':U).
           tt-packing-wms.qtd-item          = _RetornaValDeci('qtd-item       ':U).
           tt-packing-wms.dat-validade      = _RetornaValData('dat-validade   ':U).
           tt-packing-wms.dat-transacao     = _RetornaValData('dat-transacao  ':U).
           tt-packing-wms.log-inicializa    = _RetornaValLogi('log-inicializa ':U).
           tt-packing-wms.log-finaliza      = _RetornaValLogi('log-finaliza   ':U).
           tt-packing-wms.log-estorna       = _RetornaValLogi('log-estorna    ':U).
           tt-packing-wms.log-alteracao     = _RetornaValLogi('log-alteracao  ':U).

    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return 'NOK':U.

    Raw-Transfer tt-packing-wms To vRaw.
    Run 'bcp/bcapi9019.p':U (Input        pNumTrans,
                             Input        vRaw,
                             Input-Output Table tt-erro).

End. /* Do: Main */

