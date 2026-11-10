/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9001C 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9001C MBC}
&ENDIF
/**********************************************************************************
**     Programa...: bc9001c.p
**
**     Finalidade.: Pre-api de transferencia entre depositos
**
**     Criado em..: Setembro/2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9001.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/
{include/i_dbvers.i}

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
    
    If  Not AvailAble Param-BC Then Return 'NOK'.
    
    &if '{&mgcld_version}' <= '2.04' &then
        Assign vNumProduto = Param-BC.int-2.
    &else
        Assign vNumProduto = Param-BC.ind-sistema.
    &endif
    
    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'bcp/bc9001d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9001e.p'.
    End. /* Case */
    
    Create tt-transfere-bc.
    Raw-Transfer pRawConteudo to tt-transfere-bc.

    _AddField('cod-estabel              ', String(tt-transfere-bc.cod-estabel               ),  'Character ').
    _AddField('num-documento            ', String(tt-transfere-bc.num-documento             ),  'Character ').
    _AddField('cod-serie-documento      ', String(tt-transfere-bc.cod-serie-documento       ),  'Character ').
    _AddField('num-especie-documento    ', String(tt-transfere-bc.num-especie-documento     ),  'Integer   ').
    _AddField('data-transacao           ', String(tt-transfere-bc.data-transacao            ),  'Date      ').
    _AddField('cod-item                 ', String(tt-transfere-bc.cod-item                  ),  'Character ').
    _AddField('cod-unico                ', String(tt-transfere-bc.cod-unico                 ),  'Character ').
    _AddField('cod-refer-origem         ', String(tt-transfere-bc.cod-refer-origem          ),  'Character ').
    _AddField('cod-refer-destino        ', String(tt-transfere-bc.cod-refer-destino         ),  'Character ').
    _AddField('cod-depos-origem         ', String(tt-transfere-bc.cod-depos-origem          ),  'Character ').
    _AddField('cod-depos-destino        ', String(tt-transfere-bc.cod-depos-destino         ),  'Character ').
    _AddField('cod-local-origem         ', String(tt-transfere-bc.cod-local-origem          ),  'Character ').
    _AddField('cod-local-destino        ', String(tt-transfere-bc.cod-local-destino         ),  'Character ').
    _AddField('cod-lote-origem          ', String(tt-transfere-bc.cod-lote-origem           ),  'Character ').
    _AddField('cod-lote-destino         ', String(tt-transfere-bc.cod-lote-destino          ),  'Character ').
    _AddField('dat-valid-lote-origem    ', String(tt-transfere-bc.dat-valid-lote-origem     ),  'Date      ').
    _AddField('dat-valid-lote-destino   ', String(tt-transfere-bc.dat-valid-lote-destino    ),  'Date      ').
    _AddField('cod-usuario              ', String(tt-transfere-bc.cod-usuario               ),  'Character ').
    _AddField('qtd-movimento            ', String(tt-transfere-bc.qtd-movimento             ),  'Decimal   ').
    _AddField('ct-codigo                ', String(tt-transfere-bc.ct-codigo                 ),  'Character ').
    _AddField('sc-codigo                ', String(tt-transfere-bc.sc-codigo                 ),  'Character ').
    _AddField('num-sequencia            ', String(tt-transfere-bc.num-sequencia             ),  'Integer   ').
    _AddField('un                       ', String(tt-transfere-bc.un                        ),  'Character ').
    _AddField('cod-livre-1              ', String(tt-transfere-bc.cod-livre-1               ),  'Character ').
    _AddField('cod-livre-2              ', String(tt-transfere-bc.cod-livre-2               ),  'Character ').
    _AddField('cod-livre-3              ', String(tt-transfere-bc.cod-livre-3               ),  'Character ').
    _AddField('num-livre-1              ', String(tt-transfere-bc.num-livre-1               ),  'Integer   ').
    _AddField('num-livre-2              ', String(tt-transfere-bc.num-livre-2               ),  'Integer   ').
    _AddField('num-livre-3              ', String(tt-transfere-bc.num-livre-3               ),  'Integer   ').
    _AddField('dec-livre-1              ', String(tt-transfere-bc.dec-livre-1               ),  'Decimal   ').
    _AddField('dec-livre-2              ', String(tt-transfere-bc.dec-livre-2               ),  'Decimal   ').
    _AddField('dec-livre-3              ', String(tt-transfere-bc.dec-livre-3               ),  'Decimal   ').
    _AddField('log-livre-1              ', String(tt-transfere-bc.log-livre-1               ),  'Logical   ').
    _AddField('log-livre-2              ', String(tt-transfere-bc.log-livre-2               ),  'Logical   ').
    _AddField('log-livre-3              ', String(tt-transfere-bc.log-livre-3               ),  'Logical   ').
    _AddField('dat-livre-1              ', String(tt-transfere-bc.dat-livre-1               ),  'Date      ').
    _AddField('dat-livre-2              ', String(tt-transfere-bc.dat-livre-2               ),  'Date      ').
    _AddField('dat-livre-3              ', String(tt-transfere-bc.dat-livre-3               ),  'Date      ').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).
End. /* Do Main */

/***********************************************************************************************************/
