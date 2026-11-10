/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9003C 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9003C MBC}
&ENDIF
/**********************************************************************************
**     Programa...: bc9003c.p
**
**     Finalidade.: Pre-api de Reporte Ppor Ordem, Por Opera‡Æo, Por Ponto Controle
**
**     Criado em..: Setembro/2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{include/i_dbvers.i}
{bcp/bc9003.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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
            Assign vAdapterProgram = 'bcp/bc9003d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9003e.p'.
    End. /* Case */

    Create tt-reporte-ordem-bc.
    Raw-Transfer pRawConteudo to tt-reporte-ordem-bc.

    _AddField('tipo'                    , String(tt-reporte-ordem-bc.tipo)                  , 'Integer').
    _AddField('nr-reporte'              , String(tt-reporte-ordem-bc.nr-reporte)            , 'Integer').
    _AddField('nr-ord-produ'            , String(tt-reporte-ordem-bc.nr-ord-produ)          , 'Integer').
    _AddField('data'                    , String(tt-reporte-ordem-bc.data)                  , 'Date').   
    _AddField('qt-reporte'              , String(tt-reporte-ordem-bc.qt-reporte)            , 'Decimal').
    _AddField('qt-refugo'               , String(tt-reporte-ordem-bc.qt-refugo)             , 'Decimal').
    _AddField('qt-apr-cond'             , String(tt-reporte-ordem-bc.qt-apr-cond)           , 'Decimal').
    _AddField('it-codigo'               , String(tt-reporte-ordem-bc.it-codigo)             , 'Character').
    _AddField('un'                      , String(tt-reporte-ordem-bc.un)                    , 'Character').
    _AddField('nro-docto'               , String(tt-reporte-ordem-bc.nro-docto)             , 'Character').
    _AddField('serie-docto'             , String(tt-reporte-ordem-bc.serie-docto)           , 'Character').
    _AddField('cod-depos'               , String(tt-reporte-ordem-bc.cod-depos)             , 'Character').
    _AddField('cod-localiz'             , String(tt-reporte-ordem-bc.cod-localiz)           , 'Character').
    _AddField('dep-refugo'              , String(tt-reporte-ordem-bc.dep-refugo)            , 'Character').
    _AddField('loc-refugo'              , String(tt-reporte-ordem-bc.loc-refugo)            , 'Character').
    _AddField('lote-serie'              , String(tt-reporte-ordem-bc.lote-serie)            , 'Character').
    _AddField('cod-refer'               , String(tt-reporte-ordem-bc.cod-refer)             , 'Character').
    _AddField('dt-vali-lote'            , String(tt-reporte-ordem-bc.dt-vali-lote)          , 'Date').   
    /*Inicio Altera‡äes Projeto - 107*/
    _AddField('cod-cta-codigo'          , String(tt-reporte-ordem-bc.cod-cta-codigo)        , 'Character').
    _AddField('cod-ccusto-codigo'       , String(tt-reporte-ordem-bc.cod-ccusto-codigo)     , 'Character').
    _AddField('cod-cta-refugo'          , String(tt-reporte-ordem-bc.cod-cta-refugo)        , 'Character').
    _AddField('cod-ccusto-refugo'       , String(tt-reporte-ordem-bc.cod-ccusto-refugo)     , 'Character').
    _AddField('cod-cta-aplic'           , String(tt-reporte-ordem-bc.cod-cta-aplic)         , 'Character').
    _AddField('cod-ccusto-aplic'        , String(tt-reporte-ordem-bc.cod-ccusto-aplic)      , 'Character').
    /*Fim altera‡äes projeto - 107*/
    _AddField('cod-depos-sai'           , String(tt-reporte-ordem-bc.cod-depos-sai)         , 'Character').
    _AddField('cod-local-sai'           , String(tt-reporte-ordem-bc.cod-local-sai)         , 'Character').
    _AddField('op-codigo'               , String(tt-reporte-ordem-bc.op-codigo)             , 'Integer').
    _AddField('cod-roteiro'             , String(tt-reporte-ordem-bc.cod-roteiro)           , 'Character').
    _AddField('it-oper'                 , String(tt-reporte-ordem-bc.it-oper)               , 'Character').
    _AddField('pto-controle'            , String(tt-reporte-ordem-bc.pto-controle)          , 'Integer').
    _AddField('sequencia'               , String(tt-reporte-ordem-bc.sequencia)             , 'Integer').
    _AddField('baixa-reservas'          , String(tt-reporte-ordem-bc.baixa-reservas)        , 'Integer').
    _AddField('time-out'                , String(tt-reporte-ordem-bc.time-out)              , 'Integer').
    _AddField('tentativas'              , String(tt-reporte-ordem-bc.tentativas)            , 'Integer').
    _AddField('procura-saldos'          , String(tt-reporte-ordem-bc.procura-saldos)        , 'Logical').
    _AddField('carrega-reservas'        , String(tt-reporte-ordem-bc.carrega-reservas)      , 'Logical').
    _AddField('requis-automatica'       , String(tt-reporte-ordem-bc.requis-automatica)     , 'Logical').
    _AddField('prog-seg'                , String(tt-reporte-ordem-bc.prog-seg)              , 'Character').
    _AddField('finaliza-ordem'          , String(tt-reporte-ordem-bc.finaliza-ordem)        , 'Logical').
    _AddField('finaliza-oper'           , String(tt-reporte-ordem-bc.finaliza-oper)         , 'Logical').
    _AddField('reserva'                 , String(tt-reporte-ordem-bc.reserva)               , 'Logical').
    _AddField('nro-ord-seq'             , String(tt-reporte-ordem-bc.nro-ord-seq)           , 'Integer').
    _AddField('linha'                   , String(tt-reporte-ordem-bc.linha)                 , 'Integer').
    _AddField('ct-refugo'               , String(tt-reporte-ordem-bc.ct-refugo)             , 'Integer').
    _AddField('sc-refugo'               , String(tt-reporte-ordem-bc.sc-refugo)             , 'Integer').
    _AddField('ct-codigo'               , String(tt-reporte-ordem-bc.ct-codigo)             , 'Integer').
    _AddField('sc-codigo'               , String(tt-reporte-ordem-bc.sc-codigo)             , 'Integer').
    _AddField('estado'                  , String(tt-reporte-ordem-bc.estado)                , 'Character').
    _AddField('data-transacao'          , String(tt-reporte-ordem-bc.data-transacao)        , 'Date').   
    _AddField('cod-unico'               , String(tt-reporte-ordem-bc.cod-unico)             , 'Character').
    _AddField('cod-usuario'             , String(tt-reporte-ordem-bc.cod-usuario)           , 'Character').
    _AddField('tipo-movto'              , String(tt-reporte-ordem-bc.tipo-movto)            , 'Integer').
    _AddField('cd-mob-dir'              , String(tt-reporte-ordem-bc.cd-mob-dir)            , 'Character').
    _AddField('gm-codigo'               , String(tt-reporte-ordem-bc.gm-codigo)             , 'Character').
    _AddField('tipo-relogio'            , String(tt-reporte-ordem-bc.tipo-relogio)          , 'Integer').
    _AddField('hora-ini'                , String(tt-reporte-ordem-bc.hora-ini)              , 'Integer').
    _AddField('min-ini'                 , String(tt-reporte-ordem-bc.min-ini)               , 'Integer').
    _AddField('hora-fim'                , String(tt-reporte-ordem-bc.hora-fim)              , 'Integer').
    _AddField('min-fim'                 , String(tt-reporte-ordem-bc.min-fim)               , 'Integer').
    _AddField('Tempo-ini'               , String(tt-reporte-ordem-bc.Tempo-ini)             , 'Decimal').
    _AddField('Tempo-Fim'               , String(tt-reporte-ordem-bc.Tempo-Fim)             , 'Decimal').
    _AddField('Centesimal-ini'          , String(tt-reporte-ordem-bc.Centesimal-ini)        , 'Decimal').
    _AddField('Centesimal-Fim'          , String(tt-reporte-ordem-bc.Centesimal-Fim)        , 'Decimal').
    _AddField('tempo'                   , String(tt-reporte-ordem-bc.tempo)                 , 'Decimal').
    _AddField('minutos-report'          , String(tt-reporte-ordem-bc.minutos-report)        , 'Integer').
    _AddField('referencia'              , String(tt-reporte-ordem-bc.referencia)            , 'Character').
    _AddField('matr-func'               , String(tt-reporte-ordem-bc.matr-func)             , 'Integer').
    _AddField('op-final'                , String(tt-reporte-ordem-bc.op-final)              , 'Logical').
    _AddField('cod-livre-1'             , String(tt-reporte-ordem-bc.cod-livre-1)           , 'Character').
    _AddField('cod-livre-2'             , String(tt-reporte-ordem-bc.cod-livre-2)           , 'Character').
    _AddField('cod-livre-3'             , String(tt-reporte-ordem-bc.cod-livre-3)           , 'Character').
    _AddField('num-livre-1'             , String(tt-reporte-ordem-bc.num-livre-1)           , 'Integer').
    _AddField('num-livre-2'             , String(tt-reporte-ordem-bc.num-livre-2)           , 'Integer').
    _AddField('num-livre-3'             , String(tt-reporte-ordem-bc.num-livre-3)           , 'Integer').
    _AddField('dec-livre-1'             , String(tt-reporte-ordem-bc.dec-livre-1)           , 'Decimal').
    _AddField('dec-livre-2'             , String(tt-reporte-ordem-bc.dec-livre-2)           , 'Decimal').
    _AddField('dec-livre-3'             , String(tt-reporte-ordem-bc.dec-livre-3)           , 'Decimal').
    _AddField('log-livre-1'             , String(tt-reporte-ordem-bc.log-livre-1)           , 'Logical').
    _AddField('log-livre-2'             , String(tt-reporte-ordem-bc.log-livre-2)           , 'Logical').
    _AddField('log-livre-3'             , String(tt-reporte-ordem-bc.log-livre-3)           , 'Logical').
    _AddField('dat-livre-1'             , String(tt-reporte-ordem-bc.dat-livre-1)           , 'Date').
    _AddField('dat-livre-2'             , String(tt-reporte-ordem-bc.dat-livre-2)           , 'Date').
    _AddField('dat-livre-3'             , String(tt-reporte-ordem-bc.dat-livre-3)           , 'Date').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/***********************************************************************************************************/
