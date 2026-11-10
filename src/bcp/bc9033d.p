/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9033D 2.00.00.002} /*** "010002" 25/03/2024 13:37:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9033d MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/********************************************************************************************
**   Programa..: bc9033d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Junho/2006 - Bravo - Cria‡Æo do programa                    **
**                                                                                         **
**   Finalidade: Adapter da transacao de Picking / Packing Simultaneos WMS                 ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
{bcp/bc9016.i}     /* Definicao da temp-table de transferencia do coleta de dados */
/*********************************************************************************/

/*********************************************************************************/
DEFINE INPUT PARAMETER pNumTrans    AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*********************************************************************************/
DEFINE VARIABLE vRaw                AS RAW                  NO-UNDO.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/
DO:
   FIND FIRST ttIntegracao NO-LOCK NO-ERROR.
   IF NOT AVAIL ttIntegracao THEN DO:
      RUN utp/ut-msgs.p ( INPUT "MSG":U,
                          INPUT 25346,
                          INPUT "bc9003d").
      CREATE tt-erro.
      
      ASSIGN tt-erro.cd-erro  = 25346
             tt-erro.i-sequen = vsequencia
             tt-erro.mensagem = TRIM(RETURN-VALUE).
      RETURN 'NOK':U.
   END.
   
   FIND FIRST tt-erro NO-LOCK NO-ERROR.
   IF AVAIL tt-erro THEN
      RETURN "NOK":U.
   
   ASSIGN ERROR-STATUS:ERROR = NO.
   
   bc9033:
   DO ON ERROR  UNDO bc9033, LEAVE bc9033
      ON QUIT   UNDO bc9033, LEAVE bc9033
      ON STOP   UNDO bc9033, LEAVE bc9033
      ON ENDKEY UNDO bc9033, LEAVE bc9033:
      
      RUN 'bcp/bcapi9033.p':U (INPUT pNumTrans,
                               INPUT TABLE ttIntegracao,
                               INPUT-OUTPUT TABLE tt-erro) NO-ERROR.
   END.
   
   IF ERROR-STATUS:ERROR = YES OR RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vsequencia =  vsequencia + 1.
      FIND LAST tt-erro NO-LOCK NO-ERROR.
      IF AVAIL tt-erro THEN
         ASSIGN vsequencia = tt-erro.i-sequen + 1.
      
      CREATE tt-erro.
      {utp/ut-liter.i "Problemas_no_processo_PRE-API(bcapi9033)" *}
      ASSIGN tt-erro.i-sequen = vsequencia
             tt-erro.cd-erro  = 999
             tt-erro.mensagem = RETURN-VALUE + " " + ERROR-STATUS:GET-MESSAGE(1).
   END.
END.
