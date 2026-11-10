/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9008C 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9008C MBC}
&ENDIF
/**********************************************************************************
**     Programa...: bc9001c.p
**
**     Finalidade.: Pre-api de transferencia entre depositos
**
**     Criado em..: Junho 2000
**
**     Versao.....: 2.00.00.000 Carlos Alberto Soares Pereira
**********************************************************************************/
{include/i_dbvers.i}
{bcp/bc9008.i}   /* Defini‡Æo da temp-table de av embarque do coleta de dados    */
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
            Assign vAdapterProgram = 'bcp/bc9008d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9008e.p'.
    End. /* Case */
    
    Create tt-embarque-bc.
    Raw-Transfer pRawConteudo to tt-embarque-bc.

    _AddField('num-aviso-embarque   ',  String(tt-embarque-bc.num-aviso-embarque    ),  'Decimal    ').
    _AddField('nr-resumo            ',  String(tt-embarque-bc.nr-resumo             ),  'Integer    ').
    _AddField('data-transacao       ',  String(tt-embarque-bc.data-transacao        ),  'Date       ').
    _AddField('cod-item             ',  String(tt-embarque-bc.cod-item              ),  'Character  ').
    _AddField('cod-unico            ',  String(tt-embarque-bc.cod-unico             ),  'Character  ').
    _AddField('cod-refer            ',  String(tt-embarque-bc.cod-refer             ),  'Character  ').
    _AddField('cod-depos            ',  String(tt-embarque-bc.cod-depos             ),  'Character  ').
    _AddField('cod-local            ',  String(tt-embarque-bc.cod-local             ),  'Character  ').
    _AddField('cod-lote             ',  String(tt-embarque-bc.cod-lote              ),  'Character  ').
    _AddField('dat-valid-lote       ',  String(tt-embarque-bc.dat-valid-lote        ),  'Date       ').
    _AddField('cod-usuario          ',  String(tt-embarque-bc.cod-usuario           ),  'Character  ').
    _AddField('qtd-embarcada        ',  String(tt-embarque-bc.qtd-embarcada         ),  'Decimal    ').
    _AddField('chave-unica          ',  String(tt-embarque-bc.chave-unica           ),  'Character  ').
    _AddField('cod-livre-1          ',  String(tt-embarque-bc.cod-livre-1           ),  'Character  ').
    _AddField('cod-livre-2          ',  String(tt-embarque-bc.cod-livre-2           ),  'Character  ').
    _AddField('cod-livre-3          ',  String(tt-embarque-bc.cod-livre-3           ),  'Character  ').
    _AddField('num-livre-1          ',  String(tt-embarque-bc.num-livre-1           ),  'Integer    ').
    _AddField('num-livre-2          ',  String(tt-embarque-bc.num-livre-2           ),  'Integer    ').
    _AddField('num-livre-3          ',  String(tt-embarque-bc.num-livre-3           ),  'Integer    ').
    _AddField('dec-livre-1          ',  String(tt-embarque-bc.dec-livre-1           ),  'Decimal    ').
    _AddField('dec-livre-2          ',  String(tt-embarque-bc.dec-livre-2           ),  'Decimal    ').
    _AddField('dec-livre-3          ',  String(tt-embarque-bc.dec-livre-3           ),  'Decimal    ').
    _AddField('log-livre-1          ',  String(tt-embarque-bc.log-livre-1           ),  'Logical    ').
    _AddField('log-livre-2          ',  String(tt-embarque-bc.log-livre-2           ),  'Logical    ').
    _AddField('log-livre-3          ',  String(tt-embarque-bc.log-livre-3           ),  'Logical    ').
    _AddField('dat-livre-1          ',  String(tt-embarque-bc.dat-livre-1           ),  'Date       ').
    _AddField('dat-livre-2          ',  String(tt-embarque-bc.dat-livre-2           ),  'Date       ').
    _AddField('dat-livre-3          ',  String(tt-embarque-bc.dat-livre-3           ),  'Date       ').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/*********************************************************************************/
