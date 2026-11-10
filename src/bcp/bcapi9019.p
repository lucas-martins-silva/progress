/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9019 2.00.00.015 } /*** "010015" 24/06/2026 14:03:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BCAPI9019 MUT}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9019.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Finalidade: Api de efetivacao do Packing WMS                                          **                                                                                         
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9019.i}     /* Definicao dos campos de comunicacao com o adapter      */
{cdp/cdcfgwms.i}   /* Definição dos pre-processadores do wms*/
{wmp/wm9070.i}     /* Defini‡Æo Temp-Table para o Packing */
/*****************************************************************************/


/*****************************************************************************/
DEFINE INPUT        PARAMETER pNumTrans    AS INTEGER   NO-UNDO.
DEFINE INPUT        PARAMETER pRaw         AS RAW       NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-erro.
/*****************************************************************************/
DEFINE                   VARIABLE vNumSeq                       AS INTEGER                  NO-UNDO.
DEFINE                   VARIABLE vLogOK                        AS LOGICAL                  NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE c-seg-usuario                 AS CHAR     FORMAT  "X(12)" NO-UNDO.
DEFINE                   VARIABLE wgbosc100                     AS WIDGET-HANDLE            NO-UNDO.      
DEFINE                   VARIABLE wgbosc106                     AS WIDGET-HANDLE            NO-UNDO.      
DEFINE                   VARIABLE wgbosc111                     AS WIDGET-HANDLE            NO-UNDO.      
DEFINE                   VARIABLE v-cod-estabel                 AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE v-cod-local                   AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE vDesSeriais                   AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE vNumSeqVolume                 AS INTEGER         INIT 0   NO-UNDO.
DEFINE                   VARIABLE l-encerra-tarefa              AS LOGICAL                  NO-UNDO.
DEFINE                   VARIABLE hDBOWm-docto-itens-atua       AS HANDLE                   NO-UNDO.
DEFINE                   VARIABLE de-qtd-estorno                AS DECIMAL                  NO-UNDO.
DEFINE                   VARIABLE de-qtd-estorno-aux            AS DECIMAL                  NO-UNDO.

DEFINE TEMP-TABLE tt-wm-packing-aux  NO-UNDO LIKE wm-packing
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

/*****************************************************************************/

/*****************************************************************************/
DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.

DEFINE BUFFER b-wm-packing-item FOR wm-packing-item.

/*****************************************************************************/
/* Inicializacao dos objetos ativos ---                     */ 
RUN scbo/bosc100.p PERSISTENT SET wgbosc100.
RUN scbo/bosc106.p PERSISTENT SET wgbosc106.
RUN scbo/bosc111.p PERSISTENT SET wgbosc111.
/************************************************************/
bc9019:
DO TRANSACTION ON ERROR  UNDO bc9019, LEAVE bc9019
               ON QUIT   UNDO bc9019, LEAVE bc9019
               ON STOP   UNDO bc9019, LEAVE bc9019
               ON ENDKEY UNDO bc9019, LEAVE bc9019:

   CREATE tt-prog-bc.
   ASSIGN tt-prog-bc.cod-prog-dtsul        = "bc9019":U
          tt-prog-bc.cod-versao-integracao = 1
          tt-prog-bc.usuario               = c-seg-usuario
          tt-prog-bc.opcao                 = 1.

   RUN bcp/bcapi004.p (INPUT-OUTPUT TABLE tt-prog-bc,
                       INPUT-OUTPUT TABLE tt-erro).

   FIND FIRST tt-prog-bc NO-ERROR.
   FIND FIRST tt-erro    NO-ERROR.
   IF AVAILABLE tt-erro THEN DO:
      CREATE  tt-erro.

      {utp/ut-liter.i "Erro_Trans" *}
      ASSIGN  tt-erro.i-sequen    = 1
              tt-erro.cd-erro     = 1
              tt-erro.mensagem    = RETURN-VALUE.
      RUN deleteObjects.
      UNDO bc9019, RETURN 'NOK':U.
   END. 

   CREATE tt-packing-wms.
   RAW-TRANSFER pRaw TO tt-packing-wms.

   FIND FIRST tt-packing-wms NO-ERROR.

   /* Valida de o usuario informado na transacao esta cadastrado no ems */
   IF CONNECTED('MGUNI':U) THEN DO:
      {bcp/bc9017.i1 tt-packing-wms.cod-usuario}
      IF vLogOk = NO THEN DO:
         CREATE tt-erro.

         DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Usuario" *}
         ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).

         DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "nao_cadastrado_no_Datasul-EMS" *}
         ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).

         ASSIGN tt-erro.i-sequen = 1
                tt-erro.cd-erro  = 1
                tt-erro.mensagem = c-lbl-liter-usuario + ' ' + tt-packing-wms.cod-usuario + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
         RUN deleteObjects.
         UNDO bc9019, RETURN 'NOK':U.
      END.
   END. 

   FIND FIRST wm-param NO-LOCK NO-ERROR.

   CREATE tt-wm-packing.
   ASSIGN tt-wm-packing.cod-estabel     = tt-packing-wms.cod-estabel
          tt-wm-packing.cod-local       = tt-packing-wms.cod-local
          tt-wm-packing.cdd-embarq      = tt-packing-wms.cdd-embarq
          tt-wm-packing.nr-resumo       = tt-packing-wms.num-resumo
          tt-wm-packing.nr-pedcli       = tt-packing-wms.cod-pedcli
          tt-wm-packing.nome-abrev      = tt-packing-wms.nom-abrev
          tt-wm-packing.num-seq-volume  = tt-packing-wms.num-seq-volume
          tt-wm-packing.cod-volume      = tt-packing-wms.cod-volume
          tt-wm-packing.num-volume      = tt-packing-wms.num-volume
          tt-wm-packing.id-docto        = tt-packing-wms.num-documento
          tt-wm-packing.id-tarefa       = tt-packing-wms.num-tarefa
          tt-wm-packing.alteracao       = tt-packing-wms.log-alteracao
          tt-wm-packing.encerra-packing = tt-packing-wms.log-finaliza.                            
   
   CREATE tt-itens.
   ASSIGN tt-itens.cod-estabel       = tt-packing-wms.cod-estabel
          tt-itens.cod-local         = tt-packing-wms.cod-local
          tt-itens.id-docto          = tt-packing-wms.num-documento
          tt-itens.cdd-embarq        = tt-packing-wms.cdd-embarq
          tt-itens.nr-resumo         = tt-packing-wms.num-resumo
          tt-itens.nr-pedcli         = tt-packing-wms.cod-pedcli
          tt-itens.nome-abrev        = tt-packing-wms.nom-abrev
          tt-itens.cod-volume        = tt-packing-wms.cod-volume
          tt-itens.num-volume        = tt-packing-wms.num-volume
          tt-itens.cod-item          = tt-packing-wms.cod-item
          tt-itens.cod-lote          = tt-packing-wms.cod-lote
          tt-itens.cod-refer         = tt-packing-wms.cod-refer
          tt-itens.cod-embalagem     = tt-packing-wms.cod-embalagem
          tt-itens.qtd-item          = tt-packing-wms.qtd-item          
          tt-itens.qtd-peso          = tt-packing-wms.qtd-peso
          tt-itens.qti-embalagem     = tt-packing-wms.qtd-embalagem
          tt-itens.dt-validade-lote  = tt-packing-wms.dat-validade.
          tt-itens.num-seq-item      = ?. /* Packing nÆo estava sendo efetivado corretamente sem esta atribui‡Æo */

   /*******************************************************************************************
   * Apenas se NAO FOI SOLICITADO um estorno                                                  *
   *******************************************************************************************/
   IF tt-packing-wms.log-estorna = NO THEN DO:
      /* Somente monta item no pallet se nao tiver solicitado fechamento */
      IF tt-packing-wms.log-finaliza = NO THEN DO:
         RUN wmp/wm9070.p (INPUT TABLE tt-wm-packing,
                           INPUT TABLE tt-itens,
                           INPUT tt-packing-wms.cod-usuario,
                           INPUT tt-packing-wms.cod-coletor,
                           INPUT tt-packing-wms.cod-equipamento,
                           INPUT tt-packing-wms.log-finaliza,
                           OUTPUT TABLE RowErrors). 

         FIND FIRST RowErrors NO-LOCK NO-ERROR.
         IF RETURN-VALUE <> 'OK':U OR AVAILABLE RowErrors THEN DO:
            RUN getRowErrors IN wgbosc106 (OUTPUT TABLE RowErrors) NO-ERROR.
            FOR EACH RowErrors:
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 8
                      tt-erro.cd-erro  = ErrorNumber
                      tt-erro.mensagem = ErrorDescription.
            END. 
            RUN deleteObjects.
            UNDO bc9019, RETURN 'NOK':U.
         END. 
      END. 

      /* Procede se foi solicitado o fechamento da tarefa */
      IF tt-packing-wms.log-finaliza = YES THEN DO:
         RUN wmp/wm9070a.p (INPUT tt-packing-wms.cod-estabel,
                            INPUT tt-packing-wms.cod-local,
                            INPUT tt-packing-wms.num-documento,
                            INPUT tt-packing-wms.cdd-embarq,
                            INPUT tt-packing-wms.num-resumo,
                            INPUT tt-packing-wms.cod-pedcli,
                            INPUT tt-packing-wms.nom-abrev,
                            INPUT tt-packing-wms.cod-usuario,
                            INPUT tt-packing-wms.log-finaliza). 

         IF RETURN-VALUE <> 'OK':U THEN DO:
            RUN getRowErrors IN wgbosc111 (OUTPUT TABLE RowErrors) NO-ERROR.
            FOR EACH RowErrors:
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 8
                      tt-erro.cd-erro  = ErrorNumber
                      tt-erro.mensagem = ErrorDescription.
            END. 
            RUN deleteObjects.
            UNDO bc9019, RETURN 'NOK':U.
         END. 
      END. 
      RUN pi-finaliza-tarefa.
   END. 

   /* Apenas se FOI SOLICITADO um estorno */
   IF tt-packing-wms.log-estorna = YES THEN DO:
      ASSIGN de-qtd-estorno = tt-packing-wms.qtd-item.

      blk_item:
      FOR EACH b-wm-packing-item 
         WHERE b-wm-packing-item.cod-estabel      = tt-packing-wms.cod-estabel
           AND b-wm-packing-item.cod-local        = tt-packing-wms.cod-local   
           AND b-wm-packing-item.nr-embarque      = 0 		   	 
           AND b-wm-packing-item.cdd-embarq       = tt-packing-wms.cdd-embarq  
           AND b-wm-packing-item.nr-resumo        = tt-packing-wms.num-resumo  
           AND b-wm-packing-item.nr-pedcli        = tt-packing-wms.cod-pedcli  
           AND b-wm-packing-item.nome-abrev       = tt-packing-wms.nom-abrev
           AND b-wm-packing-item.cod-item         = tt-packing-wms.cod-item 
           AND b-wm-packing-item.cod-lote         = tt-packing-wms.cod-lote 
           AND b-wm-packing-item.cod-refer        = tt-packing-wms.cod-refer
           AND b-wm-packing-item.dt-validade-lote = tt-packing-wms.dat-validade NO-LOCK:

         IF de-qtd-estorno <= 0 THEN
            NEXT blk_item.

         IF b-wm-packing-item.qtd-item <= de-qtd-estorno THEN
            ASSIGN de-qtd-estorno-aux = b-wm-packing-item.qtd-item
                   de-qtd-estorno     = de-qtd-estorno - b-wm-packing-item.qtd-item.
         ELSE
            ASSIGN de-qtd-estorno-aux = de-qtd-estorno
                   de-qtd-estorno     = de-qtd-estorno - b-wm-packing-item.qtd-item.
           
         RUN estornaItemPacking IN wgbosc106(INPUT b-wm-packing-item.cod-estabel,
                                             INPUT b-wm-packing-item.cod-local,
                                             INPUT b-wm-packing-item.cdd-embarq,
                                             INPUT b-wm-packing-item.nr-resumo,
                                             INPUT b-wm-packing-item.nr-pedcli,
                                             INPUT b-wm-packing-item.nome-abrev,
                                             INPUT b-wm-packing-item.id-docto,
                                             INPUT b-wm-packing-item.num-seq-item,
                                             INPUT tt-packing-wms.num-volume,
                                             INPUT tt-packing-wms.num-tarefa,
                                             INPUT tt-packing-wms.num-serial,
                                             INPUT b-wm-packing-item.cod-item,
                                             INPUT b-wm-packing-item.cod-lote,
                                             INPUT b-wm-packing-item.cod-refer,
                                             INPUT de-qtd-estorno-aux,
                                             INPUT b-wm-packing-item.dt-validade-lote).
         IF RETURN-VALUE <> 'OK':U THEN DO:
            RUN getRowErrors IN wgbosc106 (OUTPUT TABLE RowErrors) NO-ERROR.
            FOR EACH RowErrors:
               CREATE tt-erro.
               ASSIGN tt-erro.i-sequen = 9
                      tt-erro.cd-erro  = ErrorNumber
                      tt-erro.mensagem = ErrorDescription.
            END.
            RUN deleteObjects.
            UNDO bc9019, RETURN 'NOK':U.
         END. 
         IF de-qtd-estorno <= 0 THEN
            NEXT blk_item.
      END.
   END. 

   /* Processo concluido com sucesso */
   RUN deleteObjects.
   RETURN 'OK':U.
END. 

PROCEDURE pi-finaliza-tarefa:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   ASSIGN l-encerra-tarefa = YES.
   /*Verifica se o packing foi realizado*/
   FOR EACH wm-docto-itens-ped
       WHERE wm-docto-itens-ped.cod-estabel      = tt-packing-wms.cod-estabel
         AND wm-docto-itens-ped.cod-local        = tt-packing-wms.cod-local
         AND wm-docto-itens-ped.id-docto         = tt-packing-wms.num-documento
         AND wm-docto-itens-ped.cdd-embarq       = tt-packing-wms.cdd-embarq
         AND wm-docto-itens-ped.nr-resumo        = tt-packing-wms.num-resumo
         AND wm-docto-itens-ped.nr-pedcli        = tt-packing-wms.cod-pedcli
         AND wm-docto-itens-ped.nome-abrev       = tt-packing-wms.nom-abrev
         AND wm-docto-itens-ped.log-devol-cancel = NO NO-LOCK:

       FIND FIRST wm-box-movto
         WHERE wm-box-movto.cod-estabel    = wm-docto-itens-ped.cod-estabel 
           AND wm-box-movto.cod-local      = wm-docto-itens-ped.cod-local   
           AND wm-box-movto.id-docto       = wm-docto-itens-ped.id-docto   
           AND wm-box-movto.num-seq-item   = wm-docto-itens-ped.num-seq-item 
           AND wm-box-movto.ind-tipo-movto = 2                        /* sa¡da */
           AND ((wm-box-movto.qti-embalagem * wm-box-movto.qtd-item) <> (wm-box-movto.qtd-item-packing + wm-box-movto.qtd-devol)) NO-LOCK NO-ERROR.
       IF AVAIL wm-box-movto THEN DO:
          ASSIGN l-encerra-tarefa = NO.
          LEAVE.
       END.
   END.
   FIND FIRST wm-docto
        WHERE wm-docto.cod-estabel = tt-packing-wms.cod-estabel  
          AND wm-docto.cod-local   = tt-packing-wms.cod-local    
          AND wm-docto.id-docto    = tt-packing-wms.num-documento NO-LOCK NO-ERROR.
   IF AVAIL wm-docto THEN DO:
      /*Encerra a tarefa*/
      IF l-encerra-tarefa THEN DO:
         FIND FIRST wm-tarefa-resumo-pedido 
              WHERE wm-tarefa-resumo-pedido.cod-estabel = tt-packing-wms.cod-estabel  
                AND wm-tarefa-resumo-pedido.cod-local   = tt-packing-wms.cod-local    
                AND wm-tarefa-resumo-pedido.id-docto    = tt-packing-wms.num-documento   
                AND wm-tarefa-resumo-pedido.cdd-embarq  = tt-packing-wms.cdd-embarq
                AND wm-tarefa-resumo-pedido.nr-resumo   = tt-packing-wms.num-resumo   
                AND wm-tarefa-resumo-pedido.nr-pedcli   = tt-packing-wms.cod-pedcli   
                AND wm-tarefa-resumo-pedido.nome-abrev  = tt-packing-wms.nom-abrev
                AND wm-tarefa-resumo-pedido.cod-tarefa  = 8 EXCLUSIVE-LOCK NO-ERROR.
         IF AVAIL wm-tarefa-resumo-pedido THEN DO:
            ASSIGN wm-tarefa-resumo-pedido.ind-status-tarefa-itens = 3
                   wm-tarefa-resumo-pedido.dt-fim-tarefa = TODAY 
                   wm-tarefa-resumo-pedido.hr-fim-tarefa = TIME.
            
            VALIDATE wm-tarefa-resumo-pedido.
            
            IF wm-docto.ind-origem-docto = 4                       /* pr‚-faturamento */
               AND wm-param.log-libera-embarq-autom = YES THEN     /* atualiza embarque apos o packing */
               RUN pi-Atualiza-PreFaturamento IN THIS-PROCEDURE.
         END.
      END.
   END.
   RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-Atualiza-PreFaturamento:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/ 
   IF NOT VALID-HANDLE(hDBOWm-docto-itens-atua) THEN
      RUN scbo/bosc039atua.p PERSISTENT SET hDBOWm-docto-itens-atua.

   RUN atualizaPreFatur IN hDBOWm-docto-itens-atua(INPUT wm-tarefa-resumo-pedido.cod-estabel,
                                                   INPUT wm-tarefa-resumo-pedido.cod-local, 
                                                   INPUT wm-tarefa-resumo-pedido.nr-pedcli,     
                                                   INPUT wm-tarefa-resumo-pedido.nome-abrev,    
                                                   INPUT wm-tarefa-resumo-pedido.cdd-embarq,    
                                                   INPUT wm-tarefa-resumo-pedido.nr-resumo).      
                                                                                  
   IF RETURN-VALUE = "NOK":U THEN DO:
      RUN getRowErrors IN hDBOWm-docto-itens-atua (OUTPUT TABLE RowErrors).
      RUN destroy IN hDBOWm-docto-itens-atua.
   END.

   RETURN "OK":U.
END PROCEDURE.

PROCEDURE deleteObjects:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/    
   IF VALID-HANDLE(wgbosc100) THEN DO:
      DELETE OBJECT wgbosc100.
      RUN destroy IN wgbosc100 NO-ERROR.
   END.
   
   IF VALID-HANDLE(wgbosc106) THEN DO:
      DELETE OBJECT wgbosc106.
      RUN destroy IN wgbosc106 NO-ERROR.
   END.
   
   IF VALID-HANDLE(wgbosc111) THEN DO:
      DELETE OBJECT wgbosc111.
      RUN destroy IN wgbosc111 NO-ERROR.
   END.
   IF VALID-HANDLE(hDBOWm-docto-itens-atua) THEN DO:
      DELETE OBJECT hDBOWm-docto-itens-atua.
      RUN destroy IN hDBOWm-docto-itens-atua NO-ERROR.    
   END.
END PROCEDURE.
