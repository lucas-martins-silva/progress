/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9021D 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9021d MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

&if '{&mgscm_version}' >= '2.04' &then 
/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9021d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - janeiro/2003 - Karla Klemke - Cria‡Æo do programa           **
**                                                                                         **
**   Finalidade: Adapter da transacao de Devolu‡Æo Picking WMs                             ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9021.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
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
         
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return 'NOK':U.
    
    ASSIGN error-status:ERROR = NO.
    bc9021:
    DO on error  undo bc9021, leave bc9021
       on quit   undo bc9021, leave bc9021
       on stop   undo bc9021, leave bc9021
       on endkey undo bc9021, leave bc9021:
       
       Run 'bcp/bcapi9021.p':U (Input              pNumTrans,
                                Input   TABLE      ttintegracao,
                                Input-Output Table tt-erro) NO-ERROR.
    
    END.
    
    if error-status:error = YES OR RETURN-VALUE <> 'OK':U then do:
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API(bcapi9021)" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1).
    END.

End. /* Do: Main */
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
