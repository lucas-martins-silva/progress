/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9017C 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9017C MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9017c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Finalidade: Pre-api de Enderecamento WMs                                              ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9017.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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
            Assign vAdapterProgram = 'bcp/bc9017d.p':U.
    End. /* Case */

    Create tt-ender-wms.
    Raw-Transfer pRawConteudo to tt-ender-wms.

    _AddField('cod-usuario              ':U, String(tt-ender-wms.cod-usuario          ),  'Character':U). 
    _AddField('cod-coletor              ':U, String(tt-ender-wms.cod-coletor          ),  'Character':U). 
    _AddField('cod-estabel              ':U, String(tt-ender-wms.cod-estabel          ),  'Character':U). 
    _AddField('cod-local                ':U, String(tt-ender-wms.cod-local            ),  'Character':U). 
    _AddField('des-endereco             ':U, String(tt-ender-wms.des-endereco         ),  'Character':U). 
    _AddField('num-documento            ':U, String(tt-ender-wms.num-documento        ),  'Decimal  ':U). 
    _AddField('num-movimento            ':U, String(tt-ender-wms.num-movimento        ),  'Decimal  ':U). 
    _AddField('num-seq-item             ':U, String(tt-ender-wms.num-seq-item         ),  'Integer  ':U). 
    _AddField('num-box                  ':U, String(tt-ender-wms.num-box              ),  'Integer  ':U). 
    _AddField('num-doca                 ':U, String(tt-ender-wms.num-doca             ),  'Integer  ':U). 
    _AddField('num-tempo-inicio         ':U, String(tt-ender-wms.num-tempo-inicio     ),  'Decimal  ':U). 
    _AddField('cod-equipamento          ':U, String(tt-ender-wms.cod-equipamento      ),  'Character':U). 
    _AddField('cod-item                 ':U, String(tt-ender-wms.cod-item             ),  'Character':U). 
    _AddField('qtd-item                 ':U, String(tt-ender-wms.qtd-item             ),  'Decimal  ':U). 
    _AddField('num-box-lido             ':U, String(tt-ender-wms.num-box-lido         ),  'Integer  ':U). 
    _AddField('cod-embalagem            ':U, String(tt-ender-wms.cod-embalagem        ),  'Character':U). 
    _AddField('qtd-embalagem            ':U, String(tt-ender-wms.qtd-embalagem        ),  'Decimal  ':U). 
    _AddField('qtd-embal-lidas          ':U, String(tt-ender-wms.qtd-embal-lidas      ),  'Decimal  ':U). 
    _AddField('des-seriais              ':U, String(tt-ender-wms.des-seriais          ),  'Character':U). 
    _AddField('qtd-item-digit           ':U, String(tt-ender-wms.qtd-item-digit       ),  'Decimal  ':U). 
    _AddField('num-serial               ':U, String(tt-ender-wms.num-serial           ),  'Decimal  ':U). 
    _AddField('dat-atualizacao          ':U, String(tt-ender-wms.dat-atualizacao      ),  'Date     ':U). 
    _AddField('dat-transacao            ':U, String(tt-ender-wms.dat-transacao        ),  'Date     ':U). 
    _AddField('cod-livre-1              ':U, String(tt-ender-wms.cod-livre-1          ),  'Character':U).      
    _AddField('cod-livre-2              ':U, String(tt-ender-wms.cod-livre-2          ),  'Character':U).      
    _AddField('cod-livre-3              ':U, String(tt-ender-wms.cod-livre-3          ),  'Character':U).      
    _AddField('num-livre-1              ':U, String(tt-ender-wms.num-livre-1          ),  'Integer  ':U).      
    _AddField('num-livre-2              ':U, String(tt-ender-wms.num-livre-2          ),  'Integer  ':U).      
    _AddField('num-livre-3              ':U, String(tt-ender-wms.num-livre-3          ),  'Integer  ':U).      
    _AddField('dec-livre-1              ':U, String(tt-ender-wms.dec-livre-1          ),  'Decimal  ':U).      
    _AddField('dec-livre-2              ':U, String(tt-ender-wms.dec-livre-2          ),  'Decimal  ':U).      
    _AddField('dec-livre-3              ':U, String(tt-ender-wms.dec-livre-3          ),  'Decimal  ':U).      
    _AddField('log-livre-1              ':U, String(tt-ender-wms.log-livre-1          ),  'Logical  ':U).      
    _AddField('log-livre-2              ':U, String(tt-ender-wms.log-livre-2          ),  'Logical  ':U).      
    _AddField('log-livre-3              ':U, String(tt-ender-wms.log-livre-3          ),  'Logical  ':U).      
    _AddField('dat-livre-1              ':U, String(tt-ender-wms.dat-livre-1          ),  'Date     ':U).      
    _AddField('dat-livre-2              ':U, String(tt-ender-wms.dat-livre-2          ),  'Date     ':U).      
    _AddField('dat-livre-3              ':U, String(tt-ender-wms.dat-livre-3          ),  'Date     ':U).      

    Run Value(vAdapterProgram) (Input        pNumTrans,
                                Input        Table  ttIntegracao,
                                INPUT        tt-ender-wms.r-rowid,
                                Input-Output Table  tt-erro).
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

/* Do Main */ End. 
