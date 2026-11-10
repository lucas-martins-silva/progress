/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9036C 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9036C MBC}
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
**   Programa..: bc9036c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2006 - Criaá∆o do programa                           **
**                                                                                         **
**   Finalidade: Pre-api de Conferencia de Embarque                                        ** 
**                                                                                         **
********************************************************************************************/

{bcp/bc9036.i}   /* Definiá∆o da temp-table de transferencia do coleta de dados  */
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
    
    
    CREATE tt-conferencia-embarque-wms-bc.
    RAW-TRANSFER pRawConteudo TO tt-conferencia-embarque-wms-bc.

    _AddField('cod-usuario          ':U, String(tt-conferencia-embarque-wms-bc.cod-usuario          ),  'character ':U).  
    _AddField('cod-coletor          ':U, String(tt-conferencia-embarque-wms-bc.cod-coletor          ),  'character ':U).  
    _AddField('cod-equipamento      ':U, String(tt-conferencia-embarque-wms-bc.cod-equipamento      ),  'character ':U).  
    _AddField('cod-tarefa           ':U, String(tt-conferencia-embarque-wms-bc.cod-tarefa           ),  'character ':U).  
    _AddField('cod-estabel          ':U, String(tt-conferencia-embarque-wms-bc.cod-estabel          ),  'character ':U).      
    _AddField('cod-local            ':U, String(tt-conferencia-embarque-wms-bc.cod-local            ),  'character ':U).      
    _AddField('nome-abrev           ':U, String(tt-conferencia-embarque-wms-bc.nome-abrev           ),  'character ':U).  
    
    _AddField('tipo-conferencia     ':U, String(tt-conferencia-embarque-wms-bc.tipo-conferencia     ),  'integer   ':U).
    
    _AddField('id-docto             ':U, String(tt-conferencia-embarque-wms-bc.id-docto             ),  'decimal   ':U).      
    _AddField('id-tarefa            ':U, String(tt-conferencia-embarque-wms-bc.id-tarefa            ),  'decimal   ':U).      

    _AddField('num-etiqueta-packing ':U, String(tt-conferencia-embarque-wms-bc.num-etiqueta-packing ),  'decimal   ':U).  

    _AddField('qtd-total-leituras    ':U, String(tt-conferencia-embarque-wms-bc.qtd-total-leituras    ),  'decimal   ':U).  
    _AddField('qtd-leituras-efetuadas':U, String(tt-conferencia-embarque-wms-bc.qtd-leituras-efetuadas),  'decimal   ':U).  

    _AddField('log-inicia-processo  ':U, String(tt-conferencia-embarque-wms-bc.log-inicia-processo  ),  'logical   ':U).  
    _AddField('log-finaliza-processo':U, String(tt-conferencia-embarque-wms-bc.log-finaliza-processo),  'logical   ':U).  

    _AddField('data-transacao       ':U, String(tt-conferencia-embarque-wms-bc.data-transacao       ),  'date      ':U).      
    _AddField('rowid-tabela         ':U, String(tt-conferencia-embarque-wms-bc.rowid-tabela         ),  'character ':U).      

    _AddField('cdd-embarq           ':U, String(tt-conferencia-embarque-wms-bc.cdd-embarq           ),  'decimal   ':U).
    _AddField('cod-embalagem        ':U, String(tt-conferencia-embarque-wms-bc.cod-embalagem        ),  'character ':U).
    _AddField('nr-resumo            ':U, String(tt-conferencia-embarque-wms-bc.nr-resumo            ),  'integer   ':U).
    _AddField('nr-pedcli            ':U, String(tt-conferencia-embarque-wms-bc.nr-pedcli            ),  'character ':U).

    
    bc9036:                                                                                                        
    DO on error  undo bc9036, leave bc9036                                                                         
       on quit   undo bc9036, leave bc9036                                                                         
       on stop   undo bc9036, leave bc9036
       on endkey undo bc9036, leave bc9036:

       Run 'bcp/bc9036d.p':U      (Input               pNumTrans,
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

