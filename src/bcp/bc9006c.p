/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9006C 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9006C MBC}
&ENDIF
/**********************************************************************************
**     Programa...: bc9006c.p
**
**     Finalidade.: Pre-api de reporte de producao repetitivo.
**
**     Criado em..: Junho 2000
**
**     Versao.....: 2.00.00.000 Carlos Alberto Soares Pereira
**********************************************************************************/
{include/i_dbvers.i}
{bcp/bc9006.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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
            Assign vAdapterProgram = 'bcp/bc9006d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9006e.p'.
    End. /* Case */

    Create tt-reporte-repet-bc.
    Raw-Transfer pRawConteudo to tt-reporte-repet-bc.

    _AddField('nr-reporte'              , String(tt-reporte-repet-bc.nr-reporte             ),  'Integer').
    _AddField('data'                    , String(tt-reporte-repet-bc.data                   ),  'Date').
    _AddField('qt-reporte'              , String(tt-reporte-repet-bc.qt-reporte             ),  'Decimal').
    _AddField('qt-refugo'               , String(tt-reporte-repet-bc.qt-refugo              ),  'Decimal').
    _AddField('qt-estorno'              , String(tt-reporte-repet-bc.qt-estorno             ),  'Decimal').
    _AddField('cod-usuario'             , String(tt-reporte-repet-bc.cod-usuario            ),  'Character').
    _AddField('hora'                    , String(tt-reporte-repet-bc.hora                   ),  'Character').
    _AddField('it-codigo'               , String(tt-reporte-repet-bc.it-codigo              ),  'Character').
    _AddField('ct-refugo'               , String(tt-reporte-repet-bc.ct-refugo              ),  'Character').
    _AddField('sc-refugo'               , String(tt-reporte-repet-bc.sc-refugo              ),  'Character').
    _AddField('qt-apr-cond'             , String(tt-reporte-repet-bc.qt-apr-cond            ),  'Decimal').
    _AddField('nro-docto'               , String(tt-reporte-repet-bc.nro-docto              ),  'Character').
    _AddField('serie-docto'             , String(tt-reporte-repet-bc.serie-docto            ),  'Character').
    _AddField('cod-depos'               , String(tt-reporte-repet-bc.cod-depos              ),  'Character').
    _AddField('lote-serie'              , String(tt-reporte-repet-bc.lote-serie             ),  'Character').
    _AddField('cod-refer'               , String(tt-reporte-repet-bc.cod-refer              ),  'Character').
    _AddField('dt-vali-lote'            , String(tt-reporte-repet-bc.dt-vali-lote           ),  'Date').
    _AddField('cod-localiz'             , String(tt-reporte-repet-bc.cod-localiz            ),  'Character').
    _AddField('cod-estabel'             , String(tt-reporte-repet-bc.cod-estabel            ),  'Character').
    _AddField('cod-cta-aplic'           , String(tt-reporte-repet-bc.cod-cta-aplic          ),  'Character').
    _AddField('cod-ccusto-aplic'        , String(tt-reporte-repet-bc.cod-ccusto-aplic       ),  'Character').
    _AddField('qt-est-aprov'            , String(tt-reporte-repet-bc.qt-est-aprov           ),  'Decimal').
    _AddField('qt-est-refugo'           , String(tt-reporte-repet-bc.qt-est-refugo          ),  'Decimal').
    _AddField('cod-local-sai'           , String(tt-reporte-repet-bc.cod-local-sai          ),  'Character').
    _AddField('cod-depos-sai'           , String(tt-reporte-repet-bc.cod-depos-sai          ),  'Character').
    _AddField('loc-sai-unica'           , String(tt-reporte-repet-bc.loc-sai-unica          ),  'Logical').
    _AddField('prog-seg'                , String(tt-reporte-repet-bc.prog-seg               ),  'Character').
    _AddField('time-out'                , String(tt-reporte-repet-bc.time-out               ),  'Integer').
    _AddField('tentativas'              , String(tt-reporte-repet-bc.tentativas             ),  'Integer').
    _AddField('cod-versao-integracao'   , String(tt-reporte-repet-bc.cod-versao-integracao  ),  'Integer').
    _AddField('estado-rep'              , String(tt-reporte-repet-bc.estado-rep             ),  'Integer').
    _AddField('ct-db-codigo'            , String(tt-reporte-repet-bc.ct-db-codigo           ),  'Integer').
    _AddField('sc-db-codigo'            , String(tt-reporte-repet-bc.sc-db-codigo           ),  'Integer').
    _AddField('data-transacao'          , String(tt-reporte-repet-bc.data-transacao         ),  'Date').
    _AddField('cod-unico'               , String(tt-reporte-repet-bc.cod-unico              ),  'Character').
    _AddField('cod-livre-1'             , String(tt-reporte-repet-bc.cod-livre-1            ),  'Character').
    _AddField('cod-livre-2'             , String(tt-reporte-repet-bc.cod-livre-2            ),  'Character').
    _AddField('cod-livre-3'             , String(tt-reporte-repet-bc.cod-livre-3            ),  'Character').
    _AddField('num-livre-1'             , String(tt-reporte-repet-bc.num-livre-1            ),  'Integer').
    _AddField('num-livre-2'             , String(tt-reporte-repet-bc.num-livre-2            ),  'Integer').
    _AddField('num-livre-3'             , String(tt-reporte-repet-bc.num-livre-3            ),  'Integer').
    _AddField('dec-livre-1'             , String(tt-reporte-repet-bc.dec-livre-1            ),  'Decimal').
    _AddField('dec-livre-2'             , String(tt-reporte-repet-bc.dec-livre-2            ),  'Decimal').
    _AddField('dec-livre-3'             , String(tt-reporte-repet-bc.dec-livre-3            ),  'Decimal').
    _AddField('log-livre-1'             , String(tt-reporte-repet-bc.log-livre-1            ),  'Logical').
    _AddField('log-livre-2'             , String(tt-reporte-repet-bc.log-livre-2            ),  'Logical').
    _AddField('log-livre-3'             , String(tt-reporte-repet-bc.log-livre-3            ),  'Logical').
    _AddField('dat-livre-1'             , String(tt-reporte-repet-bc.dat-livre-1            ),  'Date').
    _AddField('dat-livre-2'             , String(tt-reporte-repet-bc.dat-livre-2            ),  'Date').
    _AddField('dat-livre-3'             , String(tt-reporte-repet-bc.dat-livre-3            ),  'Date').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/*********************************************************************************/
