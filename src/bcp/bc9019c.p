/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9019C 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9019C MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9019c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Finalidade: Pre-api de Packing WMS                                                    ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9019.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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
/*********************************************************************************/

/*********************************************************************************/
Do:
    Find Last Param-BC No-lock No-error.
    
    If  Not AvailAble Param-BC Then Return 'NOK':U.
    
    &if '{&mgcld_version}' >= '2.04':U &then
        ASSIGN vNumProduto = param-bc.ind-sistema.
    &else 
        Assign vNumProduto = Param-BC.int-2.   
    &endif

    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'bcp/bc9019d.p':U.
    End. /* Case */
    
    Create tt-packing-wms.
    Raw-Transfer pRawConteudo to tt-packing-wms.

    _AddField('cod-estabel              ':U, String(tt-packing-wms.cod-estabel          ),  'Character':U).  
    _AddField('cod-usuario              ':U, String(tt-packing-wms.cod-usuario          ),  'Character':U).  
    _AddField('cod-coletor              ':U, String(tt-packing-wms.cod-coletor          ),  'Character':U).  
    _AddField('cod-equipamento          ':U, String(tt-packing-wms.cod-equipamento      ),  'Character':U).  
    _AddField('cod-local                ':U, String(tt-packing-wms.cod-local            ),  'Character':U).  
    _AddField('cod-pedcli               ':U, String(tt-packing-wms.cod-pedcli           ),  'Character':U).  
    _AddField('nom-abrev                ':U, String(tt-packing-wms.nom-abrev            ),  'Character':U).  
    _AddField('cdd-embarq               ':U, String(tt-packing-wms.cdd-embarq           ),  'Decimal  ':U).  
    _AddField('num-resumo               ':U, String(tt-packing-wms.num-resumo           ),  'Integer  ':U).  
    _AddField('cod-volume               ':U, String(tt-packing-wms.cod-volume           ),  'Character':U).  
    _AddField('num-documento            ':U, String(tt-packing-wms.num-documento        ),  'Decimal  ':U).  
    _AddField('num-tarefa               ':U, String(tt-packing-wms.num-tarefa           ),  'Decimal  ':U).  
    _AddField('num-volume               ':U, String(tt-packing-wms.num-volume           ),  'Integer  ':U).  
    _AddField('num-seq-volume           ':U, String(tt-packing-wms.num-seq-volume       ),  'Integer  ':U).  
    _AddField('num-serial               ':U, String(tt-packing-wms.num-serial           ),  'Decimal  ':U).  
    _AddField('cod-item                 ':U, String(tt-packing-wms.cod-item             ),  'Character':U).  
    _AddField('cod-lote                 ':U, String(tt-packing-wms.cod-lote             ),  'Character':U).  
    _AddField('cod-refer                ':U, String(tt-packing-wms.cod-refer            ),  'Character':U).  
    _AddField('qtd-item                 ':U, String(tt-packing-wms.qtd-item             ),  'Decimal  ':U).  
    _AddField('dat-validade             ':U, String(tt-packing-wms.dat-validade         ),  'Date     ':U).  
    _AddField('dat-transacao            ':U, String(tt-packing-wms.dat-transacao        ),  'Date     ':U).  
    _AddField('log-inicializa           ':U, String(tt-packing-wms.log-inicializa       ),  'Logical  ':U).  
    _AddField('log-finaliza             ':U, String(tt-packing-wms.log-finaliza         ),  'Logical  ':U).  
    _AddField('log-estorna              ':U, String(tt-packing-wms.log-estorna          ),  'Logical  ':U).  
    _AddField('log-alteracao            ':U, String(tt-packing-wms.log-alteracao        ),  'Logical  ':U).  
    _AddField('cod-livre-1              ':U, String(tt-packing-wms.cod-livre-1          ),  'Character':U).      
    _AddField('cod-livre-2              ':U, String(tt-packing-wms.cod-livre-2          ),  'Character':U).      
    _AddField('cod-livre-3              ':U, String(tt-packing-wms.cod-livre-3          ),  'Character':U).      
    _AddField('num-livre-1              ':U, String(tt-packing-wms.num-livre-1          ),  'Integer  ':U).      
    _AddField('num-livre-2              ':U, String(tt-packing-wms.num-livre-2          ),  'Integer  ':U).      
    _AddField('num-livre-3              ':U, String(tt-packing-wms.num-livre-3          ),  'Integer  ':U).      
    _AddField('dec-livre-1              ':U, String(tt-packing-wms.dec-livre-1          ),  'Decimal  ':U).      
    _AddField('dec-livre-2              ':U, String(tt-packing-wms.dec-livre-2          ),  'Decimal  ':U).      
    _AddField('dec-livre-3              ':U, String(tt-packing-wms.dec-livre-3          ),  'Decimal  ':U).      
    _AddField('log-livre-1              ':U, String(tt-packing-wms.log-livre-1          ),  'Logical  ':U).      
    _AddField('log-livre-2              ':U, String(tt-packing-wms.log-livre-2          ),  'Logical  ':U).      
    _AddField('log-livre-3              ':U, String(tt-packing-wms.log-livre-3          ),  'Logical  ':U).      
    _AddField('dat-livre-1              ':U, String(tt-packing-wms.dat-livre-1          ),  'Date     ':U).      
    _AddField('dat-livre-2              ':U, String(tt-packing-wms.dat-livre-2          ),  'Date     ':U).      
    _AddField('dat-livre-3              ':U, String(tt-packing-wms.dat-livre-3          ),  'Date     ':U).      

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

