/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9029C 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9029C MBC}
&ENDIF



/**********************************************************************************
**     Programa...: bc9003c.p
**
**     Finalidade.: Pre-api de Reporte Ppor Ordem, Por Opera»’o, Por Ponto Controle
**
**     Criado em..: Setembro/2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{bcp/bc9029.i}   /* Defini»’o da temp-table de transferencia do coleta de dados  */
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
            Assign vAdapterProgram = 'bcp/bc9029d.p'.
    End. /* Case */

    Create tt-storage-serial-wms.
    Raw-Transfer pRawConteudo to tt-storage-serial-wms.

    _AddField('cod-usuario'                    , String(tt-storage-serial-wms.cod-usuario)                  , 'Character').
    _AddField('cod-coletor'                    , String(tt-storage-serial-wms.cod-coletor)                  , 'Character').
    _AddField('cod-equipamento'                , String(tt-storage-serial-wms.cod-equipamento)              , 'Character').
    _AddField('num-serial'                     , String(tt-storage-serial-wms.num-serial)                   , 'Decimal  ').
    _AddField('des-endereco'                   , String(tt-storage-serial-wms.des-endereco)                 , 'Character').
    _AddField('cod-item'                       , String(tt-storage-serial-wms.cod-item)                     , 'Character').
    _AddField('num-box-lido'                   , String(tt-storage-serial-wms.num-box-lido)                 , 'Decimal  ').
    _AddField('cod-estabel'                    , String(tt-storage-serial-wms.cod-estabel)                  , 'Character').
    _AddField('cod-local'                      , String(tt-storage-serial-wms.cod-local)                    , 'Character').
    _AddField('id-docto'                       , String(tt-storage-serial-wms.id-docto)                     , 'Decimal  ').
    _AddField('ind-tipo-movto'                 , String(tt-storage-serial-wms.ind-tipo-movto)               , 'INTEGER  ').
    _AddField('id-movto'                       , String(tt-storage-serial-wms.id-movto)                     , 'Decimal  ').
    _AddField('num-seq-item'                   , String(tt-storage-serial-wms.num-seq-item)                 , 'Integer  ').
    _AddField('num-box'                        , String(tt-storage-serial-wms.num-box)                      , 'Integer  ').
    _AddField('tipo-equipamento'               , String(tt-storage-serial-wms.tipo-equipamento)             , 'Integer  ').
    _AddField('qtd-saldo'                      , String(tt-storage-serial-wms.qtd-saldo)                    , 'Decimal  ').
    _AddField('horario-inicio'                 , String(tt-storage-serial-wms.horario-inicio)               , 'Integer  ').
    _AddField('dat-atualizacao'                , String(tt-storage-serial-wms.dat-atualizacao)              , 'Date     ').
    _AddField('dat-transacao'                  , String(tt-storage-serial-wms.dat-transacao)                , 'Date     ').
    _AddField('cod-lote'                       , String(tt-storage-serial-wms.cod-lote)                     , 'character').
    _AddField('cod-livre-1'                    , String(tt-storage-serial-wms.cod-livre-1)                  , 'Character').
    _AddField('cod-livre-2'                    , String(tt-storage-serial-wms.cod-livre-2)                  , 'Character').
    _AddField('cod-livre-3'                    , String(tt-storage-serial-wms.cod-livre-3)                  , 'Character').
    _AddField('cod-livre-4'                    , String(tt-storage-serial-wms.cod-livre-4)                  , 'Character').
    _AddField('cod-livre-5'                    , String(tt-storage-serial-wms.cod-livre-5)                  , 'Character').
    _AddField('num-livre-1'                    , String(tt-storage-serial-wms.num-livre-1)                  , 'Integer  ').
    _AddField('num-livre-2'                    , String(tt-storage-serial-wms.num-livre-2)                  , 'Integer  ').
    _AddField('num-livre-3'                    , String(tt-storage-serial-wms.num-livre-3)                  , 'Integer  ').
    _AddField('num-livre-4'                    , String(tt-storage-serial-wms.num-livre-4)                  , 'Integer  ').
    _AddField('num-livre-5'                    , String(tt-storage-serial-wms.num-livre-5)                  , 'Integer  ').
    _AddField('dec-livre-1'                    , String(tt-storage-serial-wms.dec-livre-1)                  , 'Decimal  ').
    _AddField('dec-livre-2'                    , String(tt-storage-serial-wms.dec-livre-2)                  , 'Decimal  ').
    _AddField('dec-livre-3'                    , String(tt-storage-serial-wms.dec-livre-3)                  , 'Decimal  ').
    _AddField('dec-livre-4'                    , String(tt-storage-serial-wms.dec-livre-4)                  , 'Decimal  ').
    _AddField('dec-livre-5'                    , String(tt-storage-serial-wms.dec-livre-5)                  , 'Decimal  ').
    _AddField('log-livre-1'                    , String(tt-storage-serial-wms.log-livre-1)                  , 'Logical  ').
    _AddField('log-livre-2'                    , String(tt-storage-serial-wms.log-livre-2)                  , 'Logical  ').
    _AddField('log-livre-3'                    , String(tt-storage-serial-wms.log-livre-3)                  , 'Logical  ').
    _AddField('log-livre-4'                    , String(tt-storage-serial-wms.log-livre-4)                  , 'Logical  ').
    _AddField('log-livre-5'                    , String(tt-storage-serial-wms.log-livre-5)                  , 'Logical  ').
    _AddField('dat-livre-1'                    , String(tt-storage-serial-wms.dat-livre-1)                  , 'Date     ').
    _AddField('dat-livre-2'                    , String(tt-storage-serial-wms.dat-livre-2)                  , 'Date     ').
    _AddField('dat-livre-3'                    , String(tt-storage-serial-wms.dat-livre-3)                  , 'Date     ').
    _AddField('dat-livre-4'                    , String(tt-storage-serial-wms.dat-livre-4)                  , 'Date     ').
    _AddField('dat-livre-5'                    , String(tt-storage-serial-wms.dat-livre-5)                  , 'Date     ').
    _AddField('opcao'                          , String(tt-storage-serial-wms.opcao)                        , 'INTEGER  ').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/***********************************************************************************************************/

