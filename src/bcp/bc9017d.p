/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9017D 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9017D MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9017d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Finalidade: Adapter da transacao de Enderecamento WMs                                 ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9017.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
DEFINE Input        PARAMETER r-BoxMovtoIdx AS ROWID  NO-UNDO.
Define Input-Output Parameter Table For tt-erro.

/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
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

    Create tt-ender-wms.
    Assign tt-ender-wms.cod-usuario      = _RetornaValChar('cod-usuario     ':U).
           tt-ender-wms.cod-coletor      = _RetornaValChar('cod-coletor     ':U).
           tt-ender-wms.cod-estabel      = _RetornaValChar('cod-estabel     ':U).
           tt-ender-wms.cod-local        = _RetornaValChar('cod-local       ':U).
           tt-ender-wms.des-endereco     = _RetornaValChar('des-endereco    ':U).
           tt-ender-wms.num-documento    = _RetornaValDeci('num-documento   ':U).
           tt-ender-wms.num-movimento    = _RetornaValDeci('num-movimento   ':U).
           tt-ender-wms.num-seq-item     = _RetornaValInte('num-seq-item    ':U).
           tt-ender-wms.num-box          = _RetornaValInte('num-box         ':U).
           tt-ender-wms.num-doca         = _RetornaValInte('num-doca        ':U).
           tt-ender-wms.qtd-item-digit   = _RetornaValDeci('qtd-item-digit  ':U).
           tt-ender-wms.num-tempo-inicio = _RetornaValDeci('num-tempo-inicio':U).
           tt-ender-wms.cod-equipamento  = _RetornaValChar('cod-equipamento ':U).
           tt-ender-wms.cod-item         = _RetornaValChar('cod-item        ':U).
           tt-ender-wms.qtd-item         = _RetornaValDeci('qtd-item        ':U).
           tt-ender-wms.num-box-lido     = _RetornaValInte('num-box-lido    ':U).
           tt-ender-wms.cod-embalagem    = _RetornaValChar('cod-embalagem   ':U).
           tt-ender-wms.qtd-embalagem    = _RetornaValDeci('qtd-embalagem   ':U).
           tt-ender-wms.qtd-embal-lidas  = _RetornaValDeci('qtd-embal-lidas ':U).
           tt-ender-wms.des-seriais      = _RetornaValChar('des-seriais     ':U).
           tt-ender-wms.num-serial       = _RetornaValDeci('num-serial      ':U).
           tt-ender-wms.dat-atualizacao  = _RetornaValData('dat-atualizacao ':U).
           tt-ender-wms.dat-transacao    = _RetornaValData('dat-transacao   ':U).

    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return 'NOK':U.

    Raw-Transfer tt-ender-wms To vRaw.

    ASSIGN error-status:ERROR = NO.
    bc9017:
    DO on error  undo bc9017, leave bc9017
       on quit   undo bc9017, leave bc9017
       on stop   undo bc9017, leave bc9017
       on endkey undo bc9017, leave bc9017:

    Run 'bcp/bcapi9017.p':U (Input        pNumTrans,
                             Input        vRaw,
                             INPUT        r-BoxMovtoIdx,
                             Input-Output Table tt-erro).
    END.
    if error-status:error = YES OR RETURN-VALUE <> 'OK':U then do:
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API(bcapi9017)" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1).
    END.


/* Do: Main */ End. 
