/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9020C 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9020c MBC}
&ENDIF


{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9020c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Criaá∆o do programa                 **
**                                                                                         **
**   Finalidade: Pre-api de Ressuprimento WMS                                              ** 
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
{bcp/bc9020.i}   /* Definiá∆o da temp-table de transferencia do coleta de dados  */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as INTEGER  No-undo.
Define Input        Parameter pRawConteudo as raw      No-undo.
Define Input-Output Parameter Table        For tt-erro.
/*********************************************************************************/

/*********************************************************************************/
Define Variable vNumProduto         As Integer              No-undo.
Define Variable vAdapterProgram     As Character            No-undo.
/*********************************************************************************/

/*********************************************************************************/
Do:
    Find Last param-bc No-lock No-error.

    If  Not AvailAble param-bc Then Return 'NOK':U.

    ASSIGN vNumProduto = param-bc.ind-sistema.

    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'bcp/bc9020d.p':U.
    End. /* Case */

    Create tt-ressup-wms.
    Raw-Transfer pRawConteudo to tt-ressup-wms.

    _AddField('cod-usuario              ':U, String(tt-ressup-wms.cod-usuario          ),  'Character':U). 
    _AddField('cod-coletor              ':U, String(tt-ressup-wms.cod-coletor          ),  'Character':U). 
    _AddField('cod-estabel              ':U, String(tt-ressup-wms.cod-estabel          ),  'Character':U). 
    _AddField('cod-local                ':U, String(tt-ressup-wms.cod-local            ),  'Character':U). 
    _AddField('des-endereco             ':U, String(tt-ressup-wms.des-endereco         ),  'Character':U). 
    _AddField('num-documento            ':U, String(tt-ressup-wms.num-documento        ),  'Decimal  ':U). 
    _AddField('num-movimento            ':U, String(tt-ressup-wms.num-movimento        ),  'Decimal  ':U). 
    _AddField('num-seq-item             ':U, String(tt-ressup-wms.num-seq-item         ),  'Integer  ':U). 
    _AddField('num-box                  ':U, String(tt-ressup-wms.num-box              ),  'Integer  ':U). 
    _AddField('num-tempo-inicio         ':U, String(tt-ressup-wms.num-tempo-inicio     ),  'Decimal  ':U). 
    _AddField('cod-equipamento          ':U, String(tt-ressup-wms.cod-equipamento      ),  'Character':U). 
    _AddField('cod-item                 ':U, String(tt-ressup-wms.cod-item             ),  'Character':U). 
    _AddField('qtd-item                 ':U, String(tt-ressup-wms.qtd-item             ),  'Decimal  ':U). 
    _AddField('qtd-item-digit           ':U, String(tt-ressup-wms.qtd-item-digit       ),  'Decimal  ':U). 
    _AddField('num-box-orig             ':U, String(tt-ressup-wms.num-box-orig         ),  'Integer  ':U). 
    _AddField('num-box-lido             ':U, String(tt-ressup-wms.num-box-lido         ),  'Integer  ':U). 
    _AddField('cod-embalagem            ':U, String(tt-ressup-wms.cod-embalagem        ),  'Character':U). 
    _AddField('qtd-embalagem            ':U, String(tt-ressup-wms.qtd-embalagem        ),  'Decimal  ':U). 
    _AddField('qtd-embal-lidas          ':U, String(tt-ressup-wms.qtd-embal-lidas      ),  'Decimal  ':U). 
    _AddField('des-seriais              ':U, String(tt-ressup-wms.des-seriais          ),  'Character':U). 
    _AddField('num-serial               ':U, String(tt-ressup-wms.num-serial           ),  'Decimal  ':U). 
    _AddField('dat-atualizacao          ':U, String(tt-ressup-wms.dat-atualizacao      ),  'Date     ':U). 
    _AddField('dat-transacao            ':U, String(tt-ressup-wms.dat-transacao        ),  'Date     ':U). 
    _AddField('des-qtdseriais           ':U, String(tt-ressup-wms.des-qtdseriais       ),  'Character':U). 
    _AddField('cod-livre-1              ':U, String(tt-ressup-wms.cod-livre-1          ),  'Character':U).      
    _AddField('cod-livre-2              ':U, String(tt-ressup-wms.cod-livre-2          ),  'Character':U).      
    _AddField('cod-livre-3              ':U, String(tt-ressup-wms.cod-livre-3          ),  'Character':U).      
    _AddField('num-livre-1              ':U, String(tt-ressup-wms.num-livre-1          ),  'Integer  ':U).      
    _AddField('num-livre-2              ':U, String(tt-ressup-wms.num-livre-2          ),  'Integer  ':U).      
    _AddField('num-livre-3              ':U, String(tt-ressup-wms.num-livre-3          ),  'Integer  ':U).      
    _AddField('dec-livre-1              ':U, String(tt-ressup-wms.dec-livre-1          ),  'Decimal  ':U).      
    _AddField('dec-livre-2              ':U, String(tt-ressup-wms.dec-livre-2          ),  'Decimal  ':U).      
    _AddField('dec-livre-3              ':U, String(tt-ressup-wms.dec-livre-3          ),  'Decimal  ':U).      
    _AddField('log-livre-1              ':U, String(tt-ressup-wms.log-livre-1          ),  'Logical  ':U).      
    _AddField('log-livre-2              ':U, String(tt-ressup-wms.log-livre-2          ),  'Logical  ':U).      
    _AddField('log-livre-3              ':U, String(tt-ressup-wms.log-livre-3          ),  'Logical  ':U).      
    _AddField('dat-livre-1              ':U, String(tt-ressup-wms.dat-livre-1          ),  'Date     ':U).      
    _AddField('dat-livre-2              ':U, String(tt-ressup-wms.dat-livre-2          ),  'Date     ':U).      
    _AddField('dat-livre-3              ':U, String(tt-ressup-wms.dat-livre-3          ),  'Date     ':U).      

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                INPUT               tt-ressup-wms.r-rowid,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).
End. /* Do Main */
&endif
