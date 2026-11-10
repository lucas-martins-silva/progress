/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9027C 2.00.00.006 } /*** "010006" 21/03/2024 09:45:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9027c MBC}
&ENDIF


{include/i_dbinst.i}  /* vers’o das bases e bases instaladas */
/**********************************************************************************
**     Programa...: bc9027c.p
**
**     Finalidade.: Pre-api de montagem de pallet
**
**     Criado em..: marco/2005
**
**     Versao.....: 2.00.00.000 Frank Rinald Rodrigues
**********************************************************************************/
{bcp/bc9027.i}   /* Defini‡Æo da temp-table de transferencia do coleta de dados  */
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

/*********************************************************************************/
DO:
   FIND LAST Param-bc NO-LOCK NO-ERROR.   
   IF NOT AVAIL Param-bc THEN
      RETURN 'NOK':U.
   
   ASSIGN vNumProduto = Param-bc.ind-sistema.
   
   CASE vNumProduto:
      WHEN 1 THEN
         ASSIGN vAdapterProgram = 'bcp/bc9027d.p':U.   
   END.
   
   CREATE tt-Montagem-Pallet.
   
   RAW-TRANSFER pRawConteudo TO tt-Montagem-Pallet.
   
   _AddField('id-agrupador             ', STRING(tt-Montagem-Pallet.id-agrupador  ),  'Decimal  ').
   _AddField('id-etiqueta              ', STRING(tt-Montagem-Pallet.id-etiqueta   ),  'Decimal  ').
   _AddField('it-codigo                ', STRING(tt-Montagem-Pallet.it-codigo     ),  'character').
   _AddField('qtd-item                 ', STRING(tt-Montagem-Pallet.qtd-item      ),  'Decimal  ').
   _AddField('qtd-peso                 ', STRING(tt-Montagem-Pallet.qtd-peso      ),  'Decimal  ').
   _AddField('cod-estabel              ', STRING(tt-Montagem-Pallet.cod-estabel   ),  'character').
   _AddField('cod-local                ', STRING(tt-Montagem-Pallet.cod-local     ),  'character').
   
   RUN VALUE(vAdapterProgram) (INPUT pNumTrans,
                               INPUT TABLE ttIntegracao,
                               INPUT-OUTPUT TABLE tt-erro).
END.
