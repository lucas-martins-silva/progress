/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9011C 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9011C MBC}
&ENDIF


/**********************************************************************************
**     Programa...: bc9011c.p
**
**     Finalidade.: Pre-api de Requisicao de Materiais Ordem de Manutencao
**
**     Criado em..: Jun/2001          
**
**     Versao.....: 2.00.00.000 Carlos Alberto Soares Pereira
**********************************************************************************/
{include/i_dbvers.i} /* Defini‡Æo do pr‚-processador */

{bcp/bc9011.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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

    If  Not AvailAble Param-BC Then Return 'NOK'.

    &if '{&mgcld_version}' <= '2.04' &then
        Assign vNumProduto = Param-BC.int-2.
    &else
        Assign vNumProduto = Param-BC.ind-sistema.
    &endif


    Case vNumProduto:
        When 1 Then
            Assign vAdapterProgram = 'bcp/bc9011d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9011e.p'.
    End. /* Case */

    Create tt-requis-manut-bc.
    Raw-Transfer pRawConteudo to tt-requis-manut-bc.

    _AddField('cod-estabel         ', String(tt-requis-manut-bc.cod-estabel               ),  'Character ').
    _AddField('nro-docto           ', String(tt-requis-manut-bc.nro-docto                 ),  'Character ').
    _AddField('serie-docto         ', String(tt-requis-manut-bc.serie-docto               ),  'Character ').
    _AddField('dt-trans            ', String(tt-requis-manut-bc.dt-trans                  ),  'Date      ').
    _AddField('numero-ordem        ', String(tt-requis-manut-bc.numero-ordem              ),  'Integer   ').
    _AddField('op-codigo           ', String(tt-requis-manut-bc.op-codigo                 ),  'Integer   ').
    _AddField('it-codigo           ', String(tt-requis-manut-bc.it-codigo                 ),  'Character ').
    _AddField('cod-refer           ', String(tt-requis-manut-bc.cod-refer                 ),  'Character ').
    _AddField('cod-depos           ', String(tt-requis-manut-bc.cod-depos                 ),  'Character ').
    _AddField('localizacao         ', String(tt-requis-manut-bc.localizacao               ),  'Character ').
    _AddField('lote                ', String(tt-requis-manut-bc.lote                      ),  'Character ').
    _AddField('quantidade          ', String(tt-requis-manut-bc.quantidade                ),  'Decimal   ').
    _AddField('un                  ', String(tt-requis-manut-bc.un                        ),  'Character ').
    _AddField('dt-validade-lote    ', String(tt-requis-manut-bc.dt-validade-lote          ),  'Date      ').
    _AddField('cod-livre-1         ', String(tt-requis-manut-bc.cod-livre-1               ),  'Character ').
    _AddField('cod-livre-2         ', String(tt-requis-manut-bc.cod-livre-2               ),  'Character ').
    _AddField('cod-livre-3         ', String(tt-requis-manut-bc.cod-livre-3               ),  'Character ').
    _AddField('cod-livre-4         ', String(tt-requis-manut-bc.cod-livre-4               ),  'Character ').
    _AddField('cod-livre-5         ', String(tt-requis-manut-bc.cod-livre-5               ),  'Character ').
    _AddField('num-livre-1         ', String(tt-requis-manut-bc.num-livre-1               ),  'Integer   ').
    _AddField('num-livre-2         ', String(tt-requis-manut-bc.num-livre-2               ),  'Integer   ').
    _AddField('num-livre-3         ', String(tt-requis-manut-bc.num-livre-3               ),  'Integer   ').
    _AddField('num-livre-4         ', String(tt-requis-manut-bc.num-livre-4               ),  'Integer   ').
    _AddField('num-livre-5         ', String(tt-requis-manut-bc.num-livre-5               ),  'Integer   ').
    _AddField('dec-livre-1         ', String(tt-requis-manut-bc.dec-livre-1               ),  'Decimal   ').
    _AddField('dec-livre-2         ', String(tt-requis-manut-bc.dec-livre-2               ),  'Decimal   ').
    _AddField('dec-livre-3         ', String(tt-requis-manut-bc.dec-livre-3               ),  'Decimal   ').
    _AddField('dec-livre-4         ', String(tt-requis-manut-bc.dec-livre-4               ),  'Decimal   ').
    _AddField('dec-livre-5         ', String(tt-requis-manut-bc.dec-livre-5               ),  'Decimal   ').
    _AddField('log-livre-1         ', String(tt-requis-manut-bc.log-livre-1               ),  'Logical   ').
    _AddField('log-livre-2         ', String(tt-requis-manut-bc.log-livre-2               ),  'Logical   ').
    _AddField('log-livre-3         ', String(tt-requis-manut-bc.log-livre-3               ),  'Logical   ').
    _AddField('log-livre-4         ', String(tt-requis-manut-bc.log-livre-4               ),  'Logical   ').
    _AddField('log-livre-5         ', String(tt-requis-manut-bc.log-livre-5               ),  'Logical   ').
    _AddField('dat-livre-1         ', String(tt-requis-manut-bc.dat-livre-1               ),  'Date      ').
    _AddField('dat-livre-2         ', String(tt-requis-manut-bc.dat-livre-2               ),  'Date      ').
    _AddField('dat-livre-3         ', String(tt-requis-manut-bc.dat-livre-3               ),  'Date      ').
    _AddField('dat-livre-4         ', String(tt-requis-manut-bc.dat-livre-4               ),  'Date      ').
    _AddField('dat-livre-5         ', String(tt-requis-manut-bc.dat-livre-5               ),  'Date      ').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

