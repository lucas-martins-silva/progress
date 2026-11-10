/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9027D 2.00.00.007 } /*** "010007" 21/03/2024 09:45:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9027d MBC}
&ENDIF


{include/i_dbinst.i}  /* vers’o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9027d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - MARCO/2005 - Frank - Montagem de pallet                     **
**                                                                                         **
**   Finalidade: Adapter da transacao de Montagem de pallet wms                            ** 
**                                                                                         **
********************************************************************************************/
/*********************************************************************************/

{bcp/bc9027.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */

/**********************************************************************************/

/*********************************************************************************/
DEFINE INPUT PARAMETER pNumTrans   AS INTEGER NO-UNDO.
DEFINE INPUT PARAMETER TABLE FOR ttIntegracao.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.

/*********************************************************************************/

{scbo/bosc074.i ttwm-etiqueta} /*ttwm-etiqueta*/
DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.

DEF VAR h-bosc074 AS HANDLE NO-UNDO.
/*********************************************************************************/

DO TRANSACTION:
   FIND FIRST ttIntegracao NO-LOCK NO-ERROR.
   IF NOT AVAIL ttIntegracao THEN DO:
      RUN utp/ut-msgs.p(INPUT "MSG":U,
                        INPUT 25346,
                        INPUT "bc9027d":U).
      CREATE tt-erro.
      ASSIGN tt-erro.cd-erro  = 25346
             tt-erro.mensagem = TRIM(RETURN-VALUE) + "(DC)":U.
      
      RETURN 'NOK':U.
   END.
   
   /* Abre a query */
   IF NOT VALID-HANDLE(h-bosc074)  THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET h-bosc074.
      RUN openQueryStatic IN h-bosc074 (INPUT "Main":U) NO-ERROR.
   END.
   
   /* Agrupa as etiquetas */
   RUN emptyRowErrors  IN h-bosc074.
   RUN FormacaoAgrupador IN h-bosc074 (INPUT 1, 
                                       INPUT _RetornaValDeci('id-etiqueta') ,
                                       INPUT _RetornaValDeci('id-agrupador'),
                                       INPUT _RetornaValDeci('qtd-item'),
                                       INPUT _RetornaValDeci('qtd-peso'),
                                       INPUT _RetornaValChar('cod-estabel'),
                                       INPUT _RetornaValChar('cod-local')). 
   
   RUN getRowErrors IN h-bosc074 (OUTPUT TABLE RowErrors).
   
   IF CAN-FIND(FIRST RowErrors) THEN DO:
      IF VALID-HANDLE(h-bosc074) THEN
         DELETE OBJECT h-bosc074.
      
      FOR EACH RowErrors:
         CREATE tt-erro.
         ASSIGN tt-erro.cd-erro  = RowErrors.errorNumber
                tt-erro.mensagem = TRIM(RowErrors.ErrorDescription) + '(WMS)':U.
      END.         
      RETURN "NOK":U.
   END.
   
   RUN reportaEtiqueta IN h-bosc074 (INPUT _RetornaValDeci('id-agrupador')). 
   
   IF VALID-HANDLE(h-bosc074) THEN
      DELETE OBJECT h-bosc074.
   
   /* API para cria‡Æo do historico da etiqueta */
   RUN bcp/bcapi9000.p (INPUT pNumTrans,
                        INPUT STRING(_RetornaValDeci('id-etiqueta')),
                        INPUT STRING(_RetornaValDeci('id-agrupador'))).
                        
   RETURN "OK":U.
END.
