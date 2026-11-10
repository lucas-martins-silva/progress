/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025C 2.00.00.011 } /*** "010011" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025c MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025c.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Criaá∆o do programa                **
**                                                                                         **
**   Finalidade: Pre-api de Transferància WMS                                              ** 
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

   EMPTY TEMP-TABLE ttintegracao.
   
   CASE vNumProduto:
      WHEN 1 THEN
         ASSIGN vAdapterProgram = 'bcp/bc9025d.p':U.
   END.
   
   FIND FIRST bc-trans
        WHERE bc-trans.nr-trans = pnumtrans NO-LOCK NO-ERROR.
   IF AVAIL bc-trans THEN DO:                                                                                                               
      _AddField('cd-trans              ':U, STRING(bc-trans.cd-trans                ),  'character ':U).
      _AddField('nr-trans              ':U, STRING(bc-trans.Nr-trans                ),  'decimal   ':U).
      _AddField('data                  ':U, STRING(bc-trans.data                    ),  'date      ':U).
      _AddField('detalhe               ':U, STRING(bc-trans.detalhe                 ),  'character ':U).
      _AddField('ep-codigo             ':U, STRING(bc-trans.ep-codigo               ),  'character ':U).
      _AddField('estado-trans          ':U, STRING(bc-trans.estado-trans            ),  'integer   ':U).
      _AddField('horario               ':U, STRING(bc-trans.horario                 ),  'character ':U).
      _AddField('usuario               ':U, STRING(bc-trans.usuario                 ),  'character ':U).
      _AddField('ind-tipo-trans        ':U, STRING(bc-trans.ind-tipo-trans          ),  'integer   ':U).
      _AddField('des-observacao        ':U, STRING(bc-trans.des-observacao          ),  'character ':U).
   END.
   
   bc9025:
   DO ON ERROR  UNDO bc9025, LEAVE bc9025
      ON QUIT   UNDO bc9025, LEAVE bc9025
      ON STOP   UNDO bc9025, LEAVE bc9025
      ON ENDKEY UNDO bc9025, LEAVE bc9025:
      RUN VALUE(vAdapterProgram) (INPUT pNumTrans,
                                  INPUT TABLE ttIntegracao,
                                  INPUT-OUTPUT TABLE tt-erro) NO-ERROR.
   END.
   
   FIND FIRST tt-erro NO-ERROR.
   
   IF (ERROR-STATUS:ERROR = YES
      AND ERROR-STATUS:GET-NUMBER(1) <> 565) 
       OR AVAILABLE(tt-erro)
       OR (RETURN-VALUE <> 'OK':U AND RETURN-VALUE <> '') THEN DO:
      
      ASSIGN vsequencia = 1.
      FIND LAST tt-erro NO-LOCK NO-ERROR.
      IF AVAIL tt-erro THEN
         ASSIGN vsequencia = tt-erro.i-sequen + 1.
      
      CREATE tt-erro.
      {utp/ut-liter.i "Problemas_no_processo_PRE-API" *}
      ASSIGN tt-erro.i-sequen = vsequencia
             tt-erro.cd-erro  = 999
             tt-erro.mensagem = RETURN-VALUE + " " + ERROR-STATUS:GET-MESSAGE(1) + "(DC)":U.
      
      RETURN "NOK":U.
   END.
   ELSE
      RETURN "OK":U.
END.
