/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9020 2.00.00.011 } /*** "010011" 09/10/2025 11:26:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bcapi9020 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9020.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Finalidade: Api de efetivacao do Ressuprimento WMS                                    **                                                                                         
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9020.i}    /* Definicao dos campos de comunicacao com o adapter       */
/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans    As Integer   No-undo.
Define Input        Parameter pRaw         As Raw       No-undo.
Define Input        PARAMETER p-rBoxMovto  AS ROWID     NO-UNDO.
Define Input-Output Parameter Table For tt-erro.
/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char     Format  "x(12)" No-undo.
Define                   Variable wgbosc096                     As Widget-handle            No-undo.
Define                   Variable wgbosc032                     As Widget-handle            No-undo.
Define                   Variable wgbosc074                     As Widget-handle            No-undo.
Define                   Variable wgwm9300                      As Widget-handle            No-undo.      
Define                   Variable vNumCont                      As Integer         Init 0   No-undo.
Define                   Variable v-cod-estabel                 As Character                No-undo.
Define                   Variable v-cod-local                   As Character                No-undo.
Define                   Variable vDesSeriais                   As Character                No-undo.
Define                   Variable de-id-etiqueta                AS decimal                  No-undo.
Define                   Variable de-qtd-item-retirado          AS decimal                  No-undo.
/*****************************************************************************/

/*****************************************************************************/
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.
/*****************************************************************************/

DEFINE TEMP-TABLE tt-serial NO-UNDO
            FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado         
            INDEX idx-serial  AS PRIMARY UNIQUE
                  id-etiqueta.

DEFINE BUFFER bfwm-box-movto FOR wm-box-movto.

/* Inicializacao dos objetos ativos ---                     */ 
Run scbo/bosc096.p Persistent Set wgbosc096.
Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.

Run scbo/bosc074.p Persistent Set wgbosc074.
Run openQueryStatic IN wgbosc074 (Input "Main":U) No-error.

Run scbo/bosc032.p Persistent Set wgbosc032.
Run wmp/wm9300.p Persistent Set wgwm9300.

/************************************************************/

BC9020:
DO TRANSACTION on ERROR  undo BC9020, leave BC9020
               on quit   undo BC9020, leave BC9020
               on stop   undo BC9020, leave BC9020
               on endkey undo BC9020, leave BC9020:

   Create tt-prog-bc.
   Assign tt-prog-bc.cod-prog-dtsul        = "bc9020"
          tt-prog-bc.cod-versao-integracao = 1
          tt-prog-bc.usuario               = c-seg-usuario
          tt-prog-bc.opcao                 = 1.

   Run bcp/bcapi004.p ( Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

   Find First tt-prog-bc No-error.
   Find First tt-erro No-error.

   If Avail tt-erro Then Do:
      Create  tt-erro.
      /* Inicio -- Projeto Internacional */
      {utp/ut-liter.i "Erro_Trans" *}
      Assign tt-erro.i-sequen    = 1
             tt-erro.cd-erro     = 1
             tt-erro.mensagem    = RETURN-VALUE.
      Run deleteObjects.
      UNDO BC9020, Return 'NOK':U.
   End.

   EMPTY TEMP-TABLE tt-ressup-wms.
   EMPTY TEMP-TABLE tt-serial.

   Create tt-ressup-wms.
   Raw-Transfer pRaw To tt-ressup-wms.

   Find First tt-ressup-wms No-error.
    
   /* Valida se o usuario informado na transacao esta cadastrado no ems */
   If Connected('mguni':U) Then Do:
      {bcp/bc9017.i1 tt-ressup-wms.cod-usuario}
      If vLogOk = No Then do:
         Create tt-erro.
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Usuario" *}
         ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
         DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "nao_cadastrado_no_Datasul-EMS" *}
         ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
         Assign tt-erro.i-sequen = 1
                tt-erro.cd-erro  = 1
                tt-erro.mensagem = c-lbl-liter-usuario + ' ' + tt-ressup-wms.cod-usuario + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
         Run deleteObjects.
         UNDO BC9020, Return 'NOK':U.
      End.
   END.

   b-ser:
   DO vNumCont = 1 TO NUM-ENTRIES(tt-ressup-wms.des-seriais,';':U).
      IF DECIMAL(ENTRY(vNumCont,tt-ressup-wms.des-seriais,';':U)) = 0 THEN
         NEXT b-ser.
       
      ASSIGN de-id-etiqueta       = DECIMAL(ENTRY(vNumCont,tt-ressup-wms.des-seriais,';':U))
             de-qtd-item-retirado = DECIMAL(ENTRY(vNumCont,tt-ressup-wms.des-qtdseriais,';':U)).
       
      FIND FIRST bfwm-box-movto 
           WHERE bfwm-box-movto.cod-estabel    = tt-ressup-wms.cod-estabel
             AND bfwm-box-movto.cod-local      = tt-ressup-wms.cod-local
             AND bfwm-box-movto.id-movto       = tt-ressup-wms.num-movimento
             AND bfwm-box-movto.ind-tipo-movto = 2 NO-LOCK NO-ERROR. /* saida */
      IF AVAIL bfwm-box-movto THEN DO:
         RUN valEndMaxRessup IN wgbosc032(INPUT bfwm-box-movto.cod-estabel,
                                          INPUT bfwm-box-movto.cod-local,
                                          INPUT bfwm-box-movto.id-movto).
         IF RETURN-VALUE = "OK":U THEN DO:
            FIND FIRST wm-etiqueta
                 WHERE wm-etiqueta.id-etiqueta = de-id-etiqueta NO-LOCK NO-ERROR.
            IF AVAIL wm-etiqueta THEN DO:
               IF (wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado) > de-qtd-item-retirado THEN DO:   
                  RUN GeraEtiquetaAvulsa IN wgwm9300( INPUT bfwm-box-movto.cod-estabel,
                                                      INPUT bfwm-box-movto.cod-local,
                                                      INPUT bfwm-box-movto.cod-cliente,
                                                      INPUT bfwm-box-movto.cod-item,
                                                      INPUT bfwm-box-movto.cod-refer,
                                                      INPUT bfwm-box-movto.cod-lote,
                                                      INPUT bfwm-box-movto.cod-embalagem,
                                                      INPUT bfwm-box-movto.qtd-item,
                                                      INPUT tt-ressup-wms.cod-usuario,
                                                      OUTPUT de-id-etiqueta,
                                                      OUTPUT de-id-etiqueta,
                                                      OUTPUT TABLE RowErrors).    
                  IF RETURN-VALUE <> 'OK':U THEN DO:
                     For Each RowErrors:
                        CREATE tt-erro.
                        Assign tt-erro.i-sequen = 20
                               tt-erro.cd-erro  = ErrorNumber
                               tt-erro.mensagem = ErrorDescription.
                     End.          
                     Run deleteObjects.
                     UNDO BC9020, Return 'NOK':U.
                  END.
                   
                  IF wm-etiqueta.ind-sit-agrupador = 1 THEN DO:
                     RUN formacaoAgrupadorTransfEnd in wgbosc074 (INPUT 2,
                                                                  INPUT wm-etiqueta.id-etiqueta,
                                                                  INPUT wm-etiqueta.id-agrupador,
                                                                  INPUT de-qtd-item-retirado,
                                                                  INPUT wm-etiqueta.qtd-peso,
                                                                  INPUT bfwm-box-movto.cod-estabel,
                                                                  INPUT bfwm-box-movto.cod-local).
              
                     RUN formacaoAgrupadorTransfEnd in wgbosc074 (INPUT 1,
                                                                  INPUT wm-etiqueta.id-etiqueta,
                                                                  INPUT de-id-etiqueta,
                                                                  INPUT de-qtd-item-retirado,
                                                                  INPUT wm-etiqueta.qtd-peso,
                                                                  INPUT bfwm-box-movto.cod-estabel,
                                                                  INPUT bfwm-box-movto.cod-local).
      
                  END.
                  ELSE DO:
                     RUN formacaoAgrupadorProprioTransfEnd in wgbosc074(INPUT wm-etiqueta.id-etiqueta,
                                                                        INPUT de-id-etiqueta,
                                                                        INPUT de-qtd-item-retirado,
                                                                        INPUT wm-etiqueta.qtd-peso,
                                                                        INPUT bfwm-box-movto.cod-estabel,
                                                                        INPUT bfwm-box-movto.cod-local).
         
                  END.
               END.
            END.
         END.
      END.         
      FIND FIRST wm-etiqueta
           WHERE wm-etiqueta.id-etiqueta = de-id-etiqueta NO-LOCK NO-ERROR.       

      Create tt-serial.
      Assign tt-serial.id-etiqueta       = de-id-etiqueta.
             tt-serial.qtd-item-retirado = de-qtd-item-retirado.
   End.
    
   FIND FIRST bfwm-box-movto 
        WHERE bfwm-box-movto.cod-estabel    = tt-ressup-wms.cod-estabel
          AND bfwm-box-movto.cod-local      = tt-ressup-wms.cod-local
          AND bfwm-box-movto.id-movto       = tt-ressup-wms.num-movimento
          AND bfwm-box-movto.ind-tipo-movto = 2 NO-LOCK NO-ERROR. /* saida */
   IF AVAIL bfwm-box-movto THEN DO:
      /* executa saida */
      RUN wmp/wm9061.p (INPUT ROWID(bfwm-box-movto),
                        INPUT tt-ressup-wms.cod-usuario,
                        INPUT tt-ressup-wms.cod-equipamento,  /* equipto */
                        INPUT tt-ressup-wms.cod-coletor,      /* coletor */
                        INPUT tt-ressup-wms.num-tempo-inicio, /* hora inicio */
                        INPUT 0,
                        INPUT TABLE tt-serial,
                        OUTPUT TABLE RowErrors).
      FIND FIRST RowErrors NO-LOCK NO-ERROR.
      If Return-value <> 'OK':U OR AVAIL RowErrors Then do:
         For Each RowErrors:
            Create tt-erro.
            Assign tt-erro.i-sequen = 8
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
         End.         
        
         Run getRowErrors In wgbosc096(Output Table RowErrors) No-error.
         For Each RowErrors:
            CREATE tt-erro.
            Assign tt-erro.i-sequen = 19
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
         End.
         Run deleteObjects.
         UNDO BC9020, Return 'NOK':U.
      End.
   END.
    
   FIND FIRST bfwm-box-movto 
        WHERE bfwm-box-movto.cod-estabel    = tt-ressup-wms.cod-estabel
          AND bfwm-box-movto.cod-local      = tt-ressup-wms.cod-local
          AND bfwm-box-movto.id-movto       = tt-ressup-wms.num-movimento
          AND bfwm-box-movto.ind-tipo-movto = 1 NO-LOCK NO-ERROR. /* Entrada */
   IF AVAIL bfwm-box-movto THEN DO:
      RUN wmp/wm9061.p (INPUT ROWID(bfwm-box-movto),
                        INPUT tt-ressup-wms.cod-usuario,
                        INPUT tt-ressup-wms.cod-equipamento,  /* equipto */
                        INPUT tt-ressup-wms.cod-coletor,      /* coletor */
                        INPUT tt-ressup-wms.num-tempo-inicio, /* hora inicio */
                        INPUT 0,
                        INPUT TABLE tt-serial,
                        OUTPUT TABLE RowErrors).
      FIND FIRST RowErrors NO-LOCK NO-ERROR.
      If Return-value <> 'OK':U OR AVAIL RowErrors Then do:
         For Each RowErrors:
            Create tt-erro.
            Assign tt-erro.i-sequen = 8
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
         End.         
        
         Run getRowErrors In wgbosc096(Output Table RowErrors) No-error.
         For Each RowErrors:
            CREATE tt-erro.
            Assign tt-erro.i-sequen = 19
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription.
         End.
         Run deleteObjects.
         UNDO BC9020, Return 'NOK':U.
      End.
   END.                      
   /* Processo concluido com sucesso */
   Run deleteObjects.
   Return 'OK':U.
End.

Procedure deleteObjects:
   Run destroy In wgbosc096 No-error.
   If valid-handle(wgbosc096) Then
      Delete Object wgbosc096.

   RUN destroy IN wgbosc074 No-error.
   If valid-handle(wgbosc074) Then
      Delete Object wgbosc074.

   Run destroy In wgbosc032 No-error.
   If valid-handle(wgbosc032) Then
      Delete Object wgbosc032.

   If valid-handle(wgwm9300) Then
      Delete Object wgwm9300.
End Procedure.
