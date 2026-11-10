/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9037C 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9037c MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9037c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2006 - Criaá∆o do programa                           **
**                                                                                         **
**   Finalidade: Pre-api de Conferencia de Embarque                                        ** 
**                                                                                         **
********************************************************************************************/

{bcp/bc9037.i}   /* Definiá∆o da temp-table de transferencia do coleta de dados  */
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
    
    If  Not AvailAble Param-BC Then Return 'NOK':U.
    
    
    CREATE tt-despalletizacao.
    RAW-TRANSFER pRawConteudo TO tt-despalletizacao.

    _AddField('cod-usuario          ':U, String(tt-despalletizacao.cod-usuario          ),  'character ':U).  
    _AddField('cod-coletor          ':U, String(tt-despalletizacao.cod-coletor          ),  'character ':U).  
    _AddField('cod-equipamento      ':U, String(tt-despalletizacao.cod-equipamento      ),  'character ':U).  
    
    _AddField('cod-estabel          ':U, String(tt-despalletizacao.cod-estabel          ),  'character ':U).      
    _AddField('cod-local            ':U, String(tt-despalletizacao.cod-local            ),  'character ':U).      

    _AddField('num-serial           ':U, String(tt-despalletizacao.num-serial           ),  'decimal   ':U).
    _AddField('num-serial-agrupador ':U, String(tt-despalletizacao.num-serial-agrupador ),  'decimal   ':U).
    _AddField('ind-sit-agrup-serial ':U, String(tt-despalletizacao.ind-sit-agrup-serial ),  'integer   ':U).

    _AddField('data-transacao       ':U, String(tt-despalletizacao.data-transacao       ),  'date      ':U).
    _AddField('hora-transacao       ':U, String(tt-despalletizacao.hora-transacao       ),  'character ':U).      
    
    bc9037:                                                                                                        
    DO on error  undo bc9037, leave bc9037                                                                         
       on quit   undo bc9037, leave bc9037                                                                         
       on stop   undo bc9037, leave bc9037
       on endkey undo bc9037, leave bc9037:

       Run 'bcp/bc9037d.p':U      (Input               pNumTrans,
                                   Input        Table  ttIntegracao,
                                   Input-Output Table  tt-erro) NO-ERROR.
    END.

    if error-status:error = YES then do:
        ASSIGN vsequencia = 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_de_execuá∆o_da_PRE-API" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1) + "(DC)":U.
    end. /* if */ 

End. /* Do Main */

