/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9028C 2.00.00.006} /*** "010006" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9028c MBC}
&ENDIF


/**********************************************************************************
**     Programa...: bc9028c.p
**
**     Finalidade.: Pre-api de reporte de producao por serial.
**
**     Criado em..: Junho 2000
**
**     Versao.....: 2.00.00.000 Carlos Alberto Soares Pereira
**********************************************************************************/
{bcp/bc9028.i}   /* Defincao da temp-table de transferencia do coleta de dados  */
{bcp/bc9102.i}   /* Definicao da temp-table de erros do coleta de dados          */
{bcp/bc9107.i}   /* Campos de comunicacao com o adapter                          */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT PARAMETER pNumTrans    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER pRawConteudo AS RAW     NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/

/*********************************************************************************/
DEFINE VARIABLE vNumProduto         AS INTEGER              NO-UNDO.
DEFINE VARIABLE vAdapterProgram     AS CHARACTER            NO-UNDO.
/*********************************************************************************/

DEF NEW GLOBAL SHARED VAR c-seg-usuario  AS CHAR FORMAT "X(12)" NO-UNDO.

DO:
   FIND LAST Param-bc NO-LOCK NO-ERROR.
   IF NOT AVAIL Param-bc THEN
      RETURN 'NOK':U.
   
   ASSIGN vAdapterProgram = 'bcp/bc9028d.p':U.
   
   CREATE tt-reporte-serial-wms.
   RAW-TRANSFER pRawConteudo TO tt-reporte-serial-wms.
   
   FIND FIRST bc-trans
        WHERE bc-trans.nr-trans = pNumTrans NO-LOCK NO-ERROR.
   
   /* Info de Tela - Referente a Login */
   _AddField('cod-usuario'                            , STRING(tt-reporte-serial-wms.cod-usuario         ),  'Character').
   _AddField('cod-coletor'                            , STRING(tt-reporte-serial-wms.cod-coletor         ),  'Character').
   _AddField('cod-equipamento'                        , STRING(tt-reporte-serial-wms.cod-equipamento     ),  'Character'). 
   
   /* Info de Tela - Referente a Tarefa*/                                 
   _AddField('num-serial'                             , STRING(tt-reporte-serial-wms.num-serial          ),  'Decimal').
   _AddField('des-endereco'                           , STRING(tt-reporte-serial-wms.des-endereco        ),  'Character').
   _AddField('cod-item'                               , STRING(tt-reporte-serial-wms.cod-item            ),  'Character').
   _AddField('num-box-lido'                           , STRING(tt-reporte-serial-wms.num-box-lido        ),  'Decimal').
   
   _AddField('cod-depos'                              , STRING(tt-reporte-serial-wms.cod-depos           ),  'Character').
   _AddField('cod-depos-sai'                          , STRING(tt-reporte-serial-wms.cod-depos-sai       ),  'Character').
   _AddField('cod-estabel'                            , STRING(tt-reporte-serial-wms.cod-estabel         ),  'Character').
   _AddField('cod-localiz'                            , STRING(tt-reporte-serial-wms.cod-localiz         ),  'Character').
   _AddField('cod-local-sai'                          , STRING(tt-reporte-serial-wms.cod-local-sai       ),  'Character').
   _AddField('dep-refugo'                             , STRING(tt-reporte-serial-wms.dep-refugo          ),  'Character').
   _AddField('loc-refugo'                             , STRING(tt-reporte-serial-wms.loc-refugo          ),  'Character').
   _AddField('id-docto'                               , STRING(tt-reporte-serial-wms.id-docto            ),  'Decimal').
   _AddField('ind-tipo-movto'                         , STRING(tt-reporte-serial-wms.ind-tipo-movto      ),  'Integer').
   _AddField('id-movto'                               , STRING(tt-reporte-serial-wms.id-movto            ),  'Decimal').
   _AddField('num-seq-item'                           , STRING(tt-reporte-serial-wms.num-seq-item        ),  'Integer').
   _AddField('num-box'                                , STRING(tt-reporte-serial-wms.num-box             ),  'Integer').
   _AddField('tipo-equipamento'                       , STRING(tt-reporte-serial-wms.tipo-equipamento    ),  'Integer').
   _AddField('qtd-saldo'                              , STRING(tt-reporte-serial-wms.qtd-saldo           ),  'Decimal').
   _AddField('horario-inicio'                         , STRING(tt-reporte-serial-wms.horario-inicio      ),  'Integer').
   _AddField('nr-ord-produ'                           , STRING(tt-reporte-serial-wms.nr-ord-produ        ),  'Integer').
   _AddField('tipo'                                   , STRING(tt-reporte-serial-wms.tipo-equipamento                ),  'Integer').
   _AddField('un'                                     , STRING(tt-reporte-serial-wms.un                  ),  'Character').
   _AddField('nro-docto'                              , STRING(tt-reporte-serial-wms.nro-docto           ),  'Character').
   _AddField('serie-docto'                            , STRING(tt-reporte-serial-wms.serie-docto         ),  'Character').
   _AddField('op-codigo'                              , STRING(tt-reporte-serial-wms.op-codigo           ),  'Integer').
   _AddField('cod-roteiro'                            , STRING(tt-reporte-serial-wms.cod-roteiro         ),  'Character').
   _AddField('it-oper'                                , STRING(tt-reporte-serial-wms.it-oper             ),  'Character').
   _AddField('pto-controle'                           , STRING(tt-reporte-serial-wms.pto-controle        ),  'Integer').
   _AddField('sequencia'                              , STRING(tt-reporte-serial-wms.sequencia           ),  'Integer').
   _AddField('baixa-reservas'                         , STRING(tt-reporte-serial-wms.baixa-reservas      ),  'Integer').
   _AddField('time-out'                               , STRING(tt-reporte-serial-wms.time-out            ),  'Integer').
   _AddField('tentativas'                             , STRING(tt-reporte-serial-wms.tentativas          ),  'Integer').
   _AddField('procura-saldos'                         , STRING(tt-reporte-serial-wms.procura-saldos      ),  'Logical').
   _AddField('carrega-reservas'                       , STRING(tt-reporte-serial-wms.carrega-reservas    ),  'Logical').
   _AddField('requis-automatica'                      , STRING(tt-reporte-serial-wms.requis-automatica   ),  'Logical').
   _AddField('prog-seg'                               , STRING(tt-reporte-serial-wms.prog-seg            ),  'Character').
   _AddField('finaliza-ordem'                         , STRING(tt-reporte-serial-wms.finaliza-ordem      ),  'Logical').
   _AddField('finaliza-oper'                          , STRING(tt-reporte-serial-wms.finaliza-oper       ),  'Logical').
   _AddField('reserva'                                , STRING(tt-reporte-serial-wms.reserva             ),  'Logical').
   _AddField('nro-ord-seq'                            , STRING(tt-reporte-serial-wms.nro-ord-seq         ),  'Integer').
   _AddField('linha'                                  , STRING(tt-reporte-serial-wms.linha               ),  'Integer').
   _AddField('ct-refugo'                              , STRING(tt-reporte-serial-wms.ct-refugo           ),  'Character').
   _AddField('sc-refugo'                              , STRING(tt-reporte-serial-wms.sc-refugo           ),  'Character').
   _AddField('ct-codigo'                              , STRING(tt-reporte-serial-wms.ct-codigo           ),  'Character').
   _AddField('sc-codigo'                              , STRING(tt-reporte-serial-wms.sc-codigo           ),  'Character').
   _AddField('cod-cta-unif'                           , STRING(tt-reporte-serial-wms.cod-cta-unif        ),  'Character').
   _AddField('cod-ccusto-unif'                        , STRING(tt-reporte-serial-wms.cod-ccusto-unif     ),  'Character').
   _AddField('estado'                                 , STRING(tt-reporte-serial-wms.estado              ),  'Character').
   _AddField('lote-serie'                             , STRING(tt-reporte-serial-wms.lote-serie          ),  'Character').
   _AddField('dt-vali-lote'                           , STRING(tt-reporte-serial-wms.dt-vali-lote        ),  'Date').
   _AddField('cod-refer'                              , STRING(tt-reporte-serial-wms.cod-refer           ),  'Character').
   _AddField('qt-reporte'                             , STRING(tt-reporte-serial-wms.qt-reporte          ),  'Decimal').
   _AddField('loc-sai-unica'                          , STRING(tt-reporte-serial-wms.loc-sai-unica       ),  'Logical').
   _AddField('qt-refugo'                              , STRING(tt-reporte-serial-wms.qt-refugo           ),  'Decimal').
   _AddField('qt-estorno'                             , STRING(tt-reporte-serial-wms.qt-estorno          ),  'Decimal').
   _AddField('qt-est-aprov'                           , STRING(tt-reporte-serial-wms.qt-est-aprov        ),  'Decimal').
   _AddField('qt-est-refugo'                          , STRING(tt-reporte-serial-wms.qt-est-refugo       ),  'Decimal').
   _AddField('qt-apr-cond'                            , STRING(tt-reporte-serial-wms.qt-apr-cond         ),  'Decimal').
   
   /* Campos extras padräes do Data Collection */                         
   _AddField('dat-atualizacao'                        , STRING(tt-reporte-serial-wms.dat-atualizacao     ),  'Date').
   _AddField('data'                                   , STRING(tt-reporte-serial-wms.data                ),  'Date').   
   _AddField('dat-transacao'                          , STRING(tt-reporte-serial-wms.dat-transacao       ),  'Date').
   _AddField('cod-lote'                               , STRING(tt-reporte-serial-wms.cod-lote            ),  'Character').
   _AddField('cod-livre-1'                            , STRING(tt-reporte-serial-wms.cod-livre-1         ),  'Character').
   _AddField('cod-livre-2'                            , STRING(tt-reporte-serial-wms.cod-livre-2         ),  'Character').
   _AddField('cod-livre-3'                            , STRING(tt-reporte-serial-wms.cod-livre-3         ),  'Character').
   _AddField('cod-livre-4'                            , STRING(tt-reporte-serial-wms.cod-livre-4         ),  'Character').
   _AddField('cod-livre-5'                            , STRING(tt-reporte-serial-wms.cod-livre-5         ),  'Character').
   _AddField('num-livre-1'                            , STRING(tt-reporte-serial-wms.num-livre-1         ),  'Integer').
   _AddField('num-livre-2'                            , STRING(tt-reporte-serial-wms.num-livre-2         ),  'Integer').
   _AddField('num-livre-3'                            , STRING(tt-reporte-serial-wms.num-livre-3         ),  'Integer').
   _AddField('num-livre-4'                            , STRING(tt-reporte-serial-wms.num-livre-4         ),  'Integer').
   _AddField('num-livre-5'                            , STRING(tt-reporte-serial-wms.num-livre-5         ),  'Integer').
   _AddField('dec-livre-1'                            , STRING(tt-reporte-serial-wms.dec-livre-1         ),  'Decimal').
   _AddField('dec-livre-2'                            , STRING(tt-reporte-serial-wms.dec-livre-2         ),  'Decimal').
   _AddField('dec-livre-3'                            , STRING(tt-reporte-serial-wms.dec-livre-3         ),  'Decimal').
   _AddField('dec-livre-4'                            , STRING(tt-reporte-serial-wms.dec-livre-4         ),  'Decimal').
   _AddField('dec-livre-5'                            , STRING(tt-reporte-serial-wms.dec-livre-5         ),  'Decimal').
   _AddField('log-livre-1'                            , STRING(tt-reporte-serial-wms.log-livre-1         ),  'Logical').
   _AddField('log-livre-2'                            , STRING(tt-reporte-serial-wms.log-livre-2         ),  'Logical').
   _AddField('log-livre-3'                            , STRING(tt-reporte-serial-wms.log-livre-3         ),  'Logical').
   _AddField('log-livre-4'                            , STRING(tt-reporte-serial-wms.log-livre-4         ),  'Logical').
   _AddField('log-livre-5'                            , STRING(tt-reporte-serial-wms.log-livre-5         ),  'Logical').
   _AddField('dat-livre-1'                            , STRING(tt-reporte-serial-wms.dat-livre-1         ),  'Date').
   _AddField('dat-livre-2'                            , STRING(tt-reporte-serial-wms.dat-livre-2         ),  'Date').
   _AddField('dat-livre-3'                            , STRING(tt-reporte-serial-wms.dat-livre-3         ),  'Date').
   _AddField('dat-livre-4'                            , STRING(tt-reporte-serial-wms.dat-livre-4         ),  'Date').
   _AddField('dat-livre-5'                            , STRING(tt-reporte-serial-wms.dat-livre-5         ),  'Date').
   
   RUN VALUE(vAdapterProgram) (INPUT pNumTrans,
                               INPUT TABLE ttIntegracao,
                               INPUT-OUTPUT TABLE tt-erro).
   
   FIND FIRST tt-erro NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-erro THEN DO:
      FIND FIRST bc-etiqueta
           WHERE bc-etiqueta.progressivo = STRING(tt-reporte-serial-wms.num-serial) EXCLUSIVE-LOCK NO-ERROR.
      IF AVAIL bc-etiqueta THEN
         ASSIGN bc-etiqueta.dt-producao    = TODAY
                bc-etiqueta.hr-producao    = STRING(TIME,"HH:MM:SS")
                bc-etiqueta.usuar-producao = c-seg-usuario.
   END.
END.
