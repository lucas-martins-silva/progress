/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9004C 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9004C MBC}
&ENDIF
/**********************************************************************************
**     Programa...: bc9004c.p
**
**     Finalidade.: Pre-api de Requisicao de Materiais.
**
**     Criado em..: Setembro/2000
**
**     Versao.....: 2.00.00.000 Luciano Leonhardt
**********************************************************************************/
{include/i_dbvers.i}
{bcp/bc9004.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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
            Assign vAdapterProgram = 'bcp/bc9004d.p'.
        When 2 Then
            Assign vAdapterProgram = 'bcp/bc9004e.p'.
    End. /* Case */

    Create tt-requis-mat-bc.
    Raw-Transfer pRawConteudo to tt-requis-mat-bc.

    _AddField('sequen-nf           ', String(tt-requis-mat-bc.sequen-nf                 ),  'Integer   ').
    _AddField('cod-depos           ', String(tt-requis-mat-bc.cod-depos                 ),  'Character ').
    _AddField('cod-emitente        ', String(tt-requis-mat-bc.cod-emitente              ),  'Integer   ').
    _AddField('cod-estabel         ', String(tt-requis-mat-bc.cod-estabel               ),  'Character ').
    _AddField('cod-refer           ', String(tt-requis-mat-bc.cod-refer                 ),  'Character ').
    _AddField('ct-codigo           ', String(tt-requis-mat-bc.ct-codigo                 ),  'Character ').
    _AddField('descricao-db        ', String(tt-requis-mat-bc.descricao-db              ),  'Character ').
    _AddField('dt-nf-saida         ', String(tt-requis-mat-bc.dt-nf-saida               ),  'Date      ').
    _AddField('esp-docto           ', String(tt-requis-mat-bc.esp-docto                 ),  'Integer   ').
    _AddField('it-codigo           ', String(tt-requis-mat-bc.it-codigo                 ),  'Character ').
    _AddField('cod-localiz         ', String(tt-requis-mat-bc.cod-localiz               ),  'Character ').
    _AddField('lote                ', String(tt-requis-mat-bc.lote                      ),  'Character ').
    _AddField('nat-operacao        ', String(tt-requis-mat-bc.nat-operacao              ),  'Character ').
    _AddField('nro-docto           ', String(tt-requis-mat-bc.nro-docto                 ),  'Character ').
    _AddField('num-sequen          ', String(tt-requis-mat-bc.num-sequen                ),  'Integer   ').
    _AddField('numero-ordem        ', String(tt-requis-mat-bc.numero-ordem              ),  'Integer   ').
    _AddField('nr-ord-produ        ', String(tt-requis-mat-bc.nr-ord-produ              ),  'Integer   ').
    _AddField('peso-liquido        ', String(tt-requis-mat-bc.peso-liquido              ),  'Decimal   ').
    _AddField('quantidade          ', String(tt-requis-mat-bc.quantidade                ),  'Decimal   ').
    _AddField('referencia          ', String(tt-requis-mat-bc.referencia                ),  'Character ').
    _AddField('sc-codigo           ', String(tt-requis-mat-bc.sc-codigo                 ),  'Character ').
    _AddField('serie-docto         ', String(tt-requis-mat-bc.serie-docto               ),  'Character ').
    _AddField('tipo-preco[1]       ', String(tt-requis-mat-bc.tipo-preco[1]             ),  'Integer   ').
    _AddField('tipo-preco[2]       ', String(tt-requis-mat-bc.tipo-preco[2]             ),  'Integer   ').
    _AddField('tipo-preco[3]       ', String(tt-requis-mat-bc.tipo-preco[2]             ),  'Integer   ').
    _AddField('tipo-trans          ', String(tt-requis-mat-bc.tipo-trans                ),  'Integer   ').
    _AddField('tipo-valor          ', String(tt-requis-mat-bc.tipo-valor                ),  'Integer   ').
    _AddField('un                  ', String(tt-requis-mat-bc.un                        ),  'Character ').
    _AddField('valor-mat-m[1]      ', String(tt-requis-mat-bc.valor-mat-m[1]            ),  'Decimal   ').
    _AddField('valor-mat-m[2]      ', String(tt-requis-mat-bc.valor-mat-m[2]            ),  'Decimal   ').
    _AddField('valor-mat-m[3]      ', String(tt-requis-mat-bc.valor-mat-m[3]            ),  'Decimal   ').
    _AddField('valor-mat-o[1]      ', String(tt-requis-mat-bc.valor-mat-o[1]            ),  'Decimal   ').
    _AddField('valor-mat-o[2]      ', String(tt-requis-mat-bc.valor-mat-o[2]            ),  'Decimal   ').
    _AddField('valor-mat-o[3]      ', String(tt-requis-mat-bc.valor-mat-o[3]            ),  'Decimal   ').
    _AddField('valor-mat-p[1]      ', String(tt-requis-mat-bc.valor-mat-p[1]            ),  'Decimal   ').
    _AddField('valor-mat-p[2]      ', String(tt-requis-mat-bc.valor-mat-p[2]            ),  'Decimal   ').
    _AddField('valor-mat-p[3]      ', String(tt-requis-mat-bc.valor-mat-p[3]            ),  'Decimal   ').
    _AddField('valor-mob-m[1]      ', String(tt-requis-mat-bc.valor-mob-m[1]            ),  'Decimal   ').
    _AddField('valor-mob-m[2]      ', String(tt-requis-mat-bc.valor-mob-m[2]            ),  'Decimal   ').
    _AddField('valor-mob-m[3]      ', String(tt-requis-mat-bc.valor-mob-m[3]            ),  'Decimal   ').
    _AddField('valor-mob-o[1]      ', String(tt-requis-mat-bc.valor-mob-o[1]            ),  'Decimal   ').
    _AddField('valor-mob-o[2]      ', String(tt-requis-mat-bc.valor-mob-o[2]            ),  'Decimal   ').
    _AddField('valor-mob-o[3]      ', String(tt-requis-mat-bc.valor-mob-o[3]            ),  'Decimal   ').
    _AddField('valor-mob-p[1]      ', String(tt-requis-mat-bc.valor-mob-p[1]            ),  'Decimal   ').
    _AddField('valor-mob-p[2]      ', String(tt-requis-mat-bc.valor-mob-p[2]            ),  'Decimal   ').
    _AddField('valor-mob-p[3]      ', String(tt-requis-mat-bc.valor-mob-p[3]            ),  'Decimal   ').
    _AddField('valor-ggf-m[1]      ', String(tt-requis-mat-bc.valor-ggf-m[1]            ),  'Decimal   ').
    _AddField('valor-ggf-m[2]      ', String(tt-requis-mat-bc.valor-ggf-m[2]            ),  'Decimal   ').
    _AddField('valor-ggf-m[3]      ', String(tt-requis-mat-bc.valor-ggf-m[3]            ),  'Decimal   ').
    _AddField('valor-ggf-o[1]      ', String(tt-requis-mat-bc.valor-ggf-o[1]            ),  'Decimal   ').
    _AddField('valor-ggf-o[2]      ', String(tt-requis-mat-bc.valor-ggf-o[2]            ),  'Decimal   ').
    _AddField('valor-ggf-o[3]      ', String(tt-requis-mat-bc.valor-ggf-o[3]            ),  'Decimal   ').
    _AddField('valor-ggf-p[1]      ', String(tt-requis-mat-bc.valor-ggf-p[1]            ),  'Decimal   ').
    _AddField('valor-ggf-p[2]      ', String(tt-requis-mat-bc.valor-ggf-p[2]            ),  'Decimal   ').
    _AddField('valor-ggf-p[3]      ', String(tt-requis-mat-bc.valor-ggf-p[3]            ),  'Decimal   ').
    _AddField('valor-nota          ', String(tt-requis-mat-bc.valor-nota                ),  'Decimal   ').
    _AddField('vl-nota-fasb[1]     ', String(tt-requis-mat-bc.vl-nota-fasb[1]           ),  'Decimal   ').
    _AddField('vl-nota-fasb[2]     ', String(tt-requis-mat-bc.vl-nota-fasb[2]           ),  'Decimal   ').
    _AddField('nr-ord-refer        ', String(tt-requis-mat-bc.nr-ord-refer              ),  'Integer   ').
    _AddField('nr-req-sum          ', String(tt-requis-mat-bc.nr-req-sum                ),  'Integer   ').
    _AddField('cod-roteiro         ', String(tt-requis-mat-bc.cod-roteiro               ),  'Character ').
    _AddField('nr-reporte          ', String(tt-requis-mat-bc.nr-reporte                ),  'Integer   ').
    _AddField('item-pai            ', String(tt-requis-mat-bc.item-pai                  ),  'Character ').
    _AddField('op-codigo           ', String(tt-requis-mat-bc.op-codigo                 ),  'Integer   ').
    _AddField('ct-db               ', String(tt-requis-mat-bc.ct-db                     ),  'Character ').
    _AddField('sc-db               ', String(tt-requis-mat-bc.sc-db                     ),  'Character ').
    _AddField('dt-vali-lote        ', String(tt-requis-mat-bc.dt-vali-lote              ),  'Date      ').
    _AddField('op-seq              ', String(tt-requis-mat-bc.op-seq                    ),  'Integer   ').
    _AddField('nr-trans            ', String(tt-requis-mat-bc.nr-trans                  ),  'Integer   ').
    _AddField('cod-estabel-des     ', String(tt-requis-mat-bc.cod-estabel-des           ),  'Character ').
    _AddField('origem-valor        ', String(tt-requis-mat-bc.origem-valor              ),  'Character ').
    _AddField('num-ord-des         ', String(tt-requis-mat-bc.num-ord-des               ),  'Integer   ').
    _AddField('num-seq-des         ', String(tt-requis-mat-bc.num-seq-des               ),  'Integer   ').
    _AddField('num-ord-inv         ', String(tt-requis-mat-bc.num-ord-inv               ),  'Integer   ').
    _AddField('valor-ipi           ', String(tt-requis-mat-bc.valor-ipi                 ),  'Decimal   ').
    _AddField('valor-iss           ', String(tt-requis-mat-bc.valor-iss                 ),  'Decimal   ').
    _AddField('valor-icm           ', String(tt-requis-mat-bc.valor-icm                 ),  'Decimal   ').
    _AddField('vl-icm-fasb[1]      ', String(tt-requis-mat-bc.vl-icm-fasb[1]            ),  'Decimal   ').
    _AddField('vl-icm-fasb[2]      ', String(tt-requis-mat-bc.vl-icm-fasb[2]            ),  'Decimal   ').
    _AddField('vl-iss-fasb[1]      ', String(tt-requis-mat-bc.vl-iss-fasb[1]            ),  'Decimal   ').
    _AddField('vl-iss-fasb[2]      ', String(tt-requis-mat-bc.vl-iss-fasb[2]            ),  'Decimal   ').
    _AddField('vl-ipi-fasb[1]      ', String(tt-requis-mat-bc.vl-ipi-fasb[1]            ),  'Decimal   ').
    _AddField('vl-ipi-fasb[2]      ', String(tt-requis-mat-bc.vl-ipi-fasb[2]            ),  'Decimal   ').
    _AddField('atualiza-ul-ent     ', String(tt-requis-mat-bc.atualiza-ul-ent           ),  'Logical   ').
    _AddField('i-sequen            ', String(tt-requis-mat-bc.i-sequen                  ),  'Integer   ').
    _AddField('procura-saldos      ', String(tt-requis-mat-bc.procura-saldos            ),  'Logical   ').
    _AddField('qt-alocada          ', String(tt-requis-mat-bc.qt-alocada                ),  'Decimal   ').
    _AddField('data-transacao      ', String(tt-requis-mat-bc.data-transacao            ),  'Date      ').
    _AddField('cod-unico           ', String(tt-requis-mat-bc.cod-unico                 ),  'Character ').
    _AddField('cod-usuario         ', String(tt-requis-mat-bc.cod-usuario               ),  'Character ').
    _AddField('cod-usu-ult-alter   ', String(tt-requis-mat-bc.cod-usu-ult-alter         ),  'Character ').
    _AddField('cod-livre-1         ', String(tt-requis-mat-bc.cod-livre-1               ),  'Character ').
    _AddField('cod-livre-2         ', String(tt-requis-mat-bc.cod-livre-2               ),  'Character ').
    _AddField('cod-livre-3         ', String(tt-requis-mat-bc.cod-livre-3               ),  'Character ').
    _AddField('cod-livre-4         ', String(tt-requis-mat-bc.cod-livre-4               ),  'Character ').
    _AddField('cod-livre-5         ', String(tt-requis-mat-bc.cod-livre-5               ),  'Character ').
    _AddField('num-livre-1         ', String(tt-requis-mat-bc.num-livre-1               ),  'Integer   ').
    _AddField('num-livre-2         ', String(tt-requis-mat-bc.num-livre-2               ),  'Integer   ').
    _AddField('num-livre-3         ', String(tt-requis-mat-bc.num-livre-3               ),  'Integer   ').
    _AddField('num-livre-4         ', String(tt-requis-mat-bc.num-livre-4               ),  'Integer   ').
    _AddField('num-livre-5         ', String(tt-requis-mat-bc.num-livre-5               ),  'Integer   ').
    _AddField('dec-livre-1         ', String(tt-requis-mat-bc.dec-livre-1               ),  'Decimal   ').
    _AddField('dec-livre-2         ', String(tt-requis-mat-bc.dec-livre-2               ),  'Decimal   ').
    _AddField('dec-livre-3         ', String(tt-requis-mat-bc.dec-livre-3               ),  'Decimal   ').
    _AddField('dec-livre-4         ', String(tt-requis-mat-bc.dec-livre-4               ),  'Decimal   ').
    _AddField('dec-livre-5         ', String(tt-requis-mat-bc.dec-livre-5               ),  'Decimal   ').
    _AddField('log-livre-1         ', String(tt-requis-mat-bc.log-livre-1               ),  'Logical   ').
    _AddField('log-livre-2         ', String(tt-requis-mat-bc.log-livre-2               ),  'Logical   ').
    _AddField('log-livre-3         ', String(tt-requis-mat-bc.log-livre-3               ),  'Logical   ').
    _AddField('log-livre-4         ', String(tt-requis-mat-bc.log-livre-4               ),  'Logical   ').
    _AddField('log-livre-5         ', String(tt-requis-mat-bc.log-livre-5               ),  'Logical   ').
    _AddField('dat-livre-1         ', String(tt-requis-mat-bc.dat-livre-1               ),  'Date      ').
    _AddField('dat-livre-2         ', String(tt-requis-mat-bc.dat-livre-2               ),  'Date      ').
    _AddField('dat-livre-3         ', String(tt-requis-mat-bc.dat-livre-3               ),  'Date      ').
    _AddField('dat-livre-4         ', String(tt-requis-mat-bc.dat-livre-4               ),  'Date      ').
    _AddField('dat-livre-5         ', String(tt-requis-mat-bc.dat-livre-5               ),  'Date      ').

    Run Value(vAdapterProgram) (Input               pNumTrans,
                                Input        Table  ttIntegracao,
                                Input-Output Table  tt-erro).

End. /* Do Main */

/*********************************************************************************/
