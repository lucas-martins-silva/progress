/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9015D 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9015D MBC}
&ENDIF


/***********************************************************************************
** Copyright DATASUL S.A. (2000)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
**********************************************************************************/
/**********************************************************************************
**     Programa...: bc9015d.p   
**
**     Finalidade.: Adapter da transacao de fechamento de Carga
**
**     Criado em..: Agosto de 2002
**
**********************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados        */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter          */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

Do:
    Find First ttIntegracao No-lock No-error.

    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9003d").
        Create  tt-erro.
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.mensagem = trim(return-value) + "(DC)":U.
        Return 'NOK'.
    End.
    
    Find First tt-erro No-lock No-error.
    If  Avail tt-erro
    Then
        Return "NOK":U.
    
    bc9015:
    DO on error  undo bc9015, leave bc9015
       on quit   undo bc9015, leave bc9015
       on stop   undo bc9015, leave bc9015
       on endkey undo bc9015, leave bc9015:
       
       Run 'bcp/bcapi9015.p':U (Input              pNumTrans,
                                INPUT        TABLE ttIntegracao,
                                Input-Output Table tt-erro) NO-ERROR.
    
    END.
    
    if error-status:error = YES then do:
        ASSIGN vsequencia = 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1) + "(DC)":U.
    END.
End. /* Do: Main */

