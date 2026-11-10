/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9002C 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9002C MBC}
&ENDIF
/**********************************************************************************
**     Programa...: bc9002c.p
**
**     Finalidade.: Pre-api de inventario
**
**     Criado em..: Setembro/2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9002.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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
            Assign vAdapterProgram = 'bcp/bc9002d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9002e.p'.
    End. /* Case */
    
    Create tt-contagem-bc.
    Raw-Transfer pRawConteudo to tt-contagem-bc.
    
    _AddField('cod-estabel          ', String(tt-contagem-bc.cod-estabel            ),  'Character ').
    _AddField('num-ficha-inventario ', String(tt-contagem-bc.num-ficha-inventario   ),  'Integer   ').
    _AddField('num-contagem         ', String(tt-contagem-bc.num-contagem           ),  'Integer   ').
    _AddField('data-transacao       ', String(tt-contagem-bc.data-transacao         ),  'Date      ').
    _AddField('dat-contagem         ', String(tt-contagem-bc.dat-contagem           ),  'Date      ').
    _AddField('cod-item             ', String(tt-contagem-bc.cod-item               ),  'Character ').
    _AddField('cod-unico            ', String(tt-contagem-bc.cod-unico              ),  'Character ').
    _AddField('cod-refer            ', String(tt-contagem-bc.cod-refer              ),  'Character ').
    _AddField('cod-depos            ', String(tt-contagem-bc.cod-depos              ),  'Character ').
    _AddField('cod-local            ', String(tt-contagem-bc.cod-local              ),  'Character ').
    _AddField('cod-lote             ', String(tt-contagem-bc.cod-lote               ),  'Character ').
    _AddField('dat-valid-lote       ', String(tt-contagem-bc.dat-valid-lote         ),  'Date      ').
    _AddField('cod-usuario          ', String(tt-contagem-bc.cod-usuario            ),  'Character ').
    _AddField('qtd-apontada         ', String(tt-contagem-bc.qtd-apontada           ),  'Decimal   ').
    _AddField('valor-mat-m          ', String(tt-contagem-bc.valor-mat-m            ),  'Decimal   ').
    _AddField('valor-mob-m          ', String(tt-contagem-bc.valor-mob-m            ),  'Decimal   ').
    _AddField('valor-mat-o          ', String(tt-contagem-bc.valor-mat-o            ),  'Decimal   ').
    _AddField('valor-mat-p          ', String(tt-contagem-bc.valor-mat-p            ),  'Decimal   ').
    _AddField('valor-mob-o          ', String(tt-contagem-bc.valor-mob-o            ),  'Decimal   ').
    _AddField('valor-mob-p          ', String(tt-contagem-bc.valor-mob-p            ),  'Decimal   ').
    _AddField('valor-ggf-m          ', String(tt-contagem-bc.valor-ggf-m            ),  'Decimal   ').
    _AddField('valor-ggf-o          ', String(tt-contagem-bc.valor-ggf-o            ),  'Decimal   ').
    _AddField('valor-ggf-p          ', String(tt-contagem-bc.valor-ggf-p            ),  'Decimal   ').
    _AddField('cod-livre-1          ', String(tt-contagem-bc.cod-livre-1            ),  'Character ').
    _AddField('cod-livre-2          ', String(tt-contagem-bc.cod-livre-2            ),  'Character ').
    _AddField('cod-livre-3          ', String(tt-contagem-bc.cod-livre-3            ),  'Character ').
    _AddField('num-livre-1          ', String(tt-contagem-bc.num-livre-1            ),  'Integer   ').
    _AddField('num-livre-2          ', String(tt-contagem-bc.num-livre-2            ),  'Integer   ').
    _AddField('num-livre-3          ', String(tt-contagem-bc.num-livre-3            ),  'Integer   ').
    _AddField('dec-livre-1          ', String(tt-contagem-bc.dec-livre-1            ),  'Decimal   ').
    _AddField('dec-livre-2          ', String(tt-contagem-bc.dec-livre-2            ),  'Decimal   ').
    _AddField('dec-livre-3          ', String(tt-contagem-bc.dec-livre-3            ),  'Decimal   ').
    _AddField('log-livre-1          ', String(tt-contagem-bc.log-livre-1            ),  'Logical   ').
    _AddField('log-livre-2          ', String(tt-contagem-bc.log-livre-2            ),  'Logical   ').
    _AddField('log-livre-3          ', String(tt-contagem-bc.log-livre-3            ),  'Logical   ').
    _AddField('dat-livre-1          ', String(tt-contagem-bc.dat-livre-1            ),  'Date      ').
    _AddField('dat-livre-2          ', String(tt-contagem-bc.dat-livre-2            ),  'Date      ').
    _AddField('dat-livre-3          ', String(tt-contagem-bc.dat-livre-3            ),  'Date      ').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/***********************************************************************************************************/
