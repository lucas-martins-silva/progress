/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9033C 2.00.00.002} /*** "010002" 25/03/2024 13:37:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9033c MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9033c                                                                   **
**                                                                                         **
**   Versao....: 2.00.00.000 - Junho/2006 - Bravo - Criaá∆o do programa                    **
**                                                                                         **
**   Finalidade: Pre-api de Picking / Packing Simultaneos WMS                              ** 
**                                                                                         **
********************************************************************************************/
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
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

/*********************************************************************************/
DO:
   FIND LAST Param-bc NO-LOCK NO-ERROR.   
   IF NOT AVAILABLE Param-bc THEN
      RETURN 'NOK':U.
   
   ASSIGN vNumProduto = param-bc.ind-sistema.
   
   CASE vNumProduto:
      WHEN 1 THEN
         ASSIGN vAdapterProgram = 'bcp/bc9033d.p':U.
   END.
   
   FIND FIRST bc-trans
        WHERE bc-trans.nr-trans = pnumtrans NO-LOCK NO-ERROR.
   IF AVAIL bc-trans THEN DO:                                                                                                               
       _AddField('cd-trans              ':U, STRING(bc-trans.cd-trans                ),  'character ':U).
       _AddField('nr-trans              ':U, STRING(bc-trans.Nr-trans                ),  'decimal   ':U).
       _AddField('data                  ':U, STRING(bc-trans.data                    ),  'date      ':U).
       _AddField('detalhe               ':U, STRING(bc-trans.detalhe                 ),  'character ':U).
       _AddField('ep-codigo             ':U, STRING(bc-trans.ep-codigo               ),  'integer   ':U).
       _AddField('estado-trans          ':U, STRING(bc-trans.estado-trans            ),  'integer   ':U).
       _AddField('horario               ':U, STRING(bc-trans.horario                 ),  'character ':U).
       _AddField('usuario               ':U, STRING(bc-trans.usuario                 ),  'character ':U).
       _AddField('ind-tipo-trans        ':U, STRING(bc-trans.ind-tipo-trans          ),  'integer   ':U).
       _AddField('des-observacao        ':U, STRING(bc-trans.des-observacao          ),  'character ':U).
   END.
   
   bc9033:
   DO ON ERROR  UNDO bc9033, LEAVE bc9033
      ON QUIT   UNDO bc9033, LEAVE bc9033
      ON STOP   UNDO bc9033, LEAVE bc9033
      ON ENDKEY UNDO bc9033, LEAVE bc9033:
      RUN VALUE(vAdapterProgram) (INPUT pNumTrans,
                                  INPUT TABLE ttIntegracao,
                                  INPUT-OUTPUT TABLE tt-erro) NO-ERROR.
   END.
   
   IF ERROR-STATUS:ERROR = YES THEN DO:
      ASSIGN vsequencia = 1.
      FIND LAST tt-erro NO-LOCK NO-ERROR.
      IF AVAIL tt-erro THEN
         ASSIGN vsequencia = tt-erro.i-sequen + 1.

      CREATE tt-erro.
      {utp/ut-liter.i "Problemas_no_processo_de_execuá∆o_da_PRE-API" *}
      ASSIGN tt-erro.i-sequen = vsequencia
             tt-erro.cd-erro  = 999
             tt-erro.mensagem = RETURN-VALUE + " " + ERROR-STATUS:GET-MESSAGE(1).
   END. 
END.
