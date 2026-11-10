/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9019F 2.00.00.015 } /*** "010015" 18/03/2024 10:23:51  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9019f MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9019.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karen - Cria‡Æo do programa                  **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Packing WMS                      **
**                                                                                         **
********************************************************************************************/

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-packing-wms.                                                     **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame03, etc.                                     **
** Frame99Defs          - Definicoes da tela onde a mesma deve conter:                            **
**                        .Titulo da Tela quando necessario.                                      **
**                        .Campos com a opcao no-label e sua localizacao Ex. At Row x Col y.      **
**                        .Literais que substituem os labels dos campos e sua localizacao.        **
**                        .Instrucoes de Navegacao quando houver espaco livre para o mesmo.       **
**                        Ex. "F4=Sair","ESC=Voltar","F2=Gravar" etc.                             **
** Frame99Repeat        - Indica se a tela tem caracteristica de repeticao. O Valor YES indica    **
**                        que ha repeticao e o valor NO indica que nao ha repeticao.              **
** Update99Fields       - Relaciona os campos que serao solicitados na tela.                      **
**                        OBS. Nao deve conter formatacao. Ex. ttWork.it-codigo no-label.         **
** TriggerBeforeFrame99 - Gatilho para ser executado antes da execucao da tela. Neste gatilho     **
**                        devem ser colocadas chamadas as procedures de inicializacao dos campos  **
**                        da tela.                                                                **
** TriggerAfterFrame99  - Gatilho para ser executado apos a execucao da tela. Neste gatilho       **
**                        dever ser colocada a chamada a procedures que devera armazenar  na      **
**                        temp-table {&TempTable} os campos da ttWork, que sao os campos          **
**                        solicitados em tela. Neste gatilho tambem, quando o mesmo se referir a  **
**                        ultima tela de entrada de dados, devera existir uma chamada a procedure **
**                        que executa a procedure _GenerateDCTransaction que eï responsavel por   **
**                        gerar a transacao no Coleta de Dados.                                   **
** UserTriggers         - Este pro-processador destina-se as triggers customizadas do usuario.    **
**                        Ex: Alimentar um campo da dela conforme o informado em outro campo.     **
**                            On Leave of ttWork.cod-depos in Frame Frame02                       **
**                            Do:                                                                 **
**                                Case ttWork.cod-depos:                                          **
**                                  When 'Pro' Then Assign ttWork.cod-local = 'Pro01'.            **
**                                  When 'Alm' Then Assign ttWork.cod-local = 'Alm01'.            **
**                                  When 'Exp' Then Assign ttWork.cod-local = 'Exp01'.            **
**                            End.                                                                **
** AtiveObject1         - Este pro-processador permite que se destruam os objetos persistentes    **
**                        no final da sessao progress.                                            **
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9019
/************************************************************/
/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-packing-wms
{bcp/bc9019.i " "}
DEFINE SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
FIND FIRST ttWork NO-ERROR.
/* Definicao da Temp-table de Tarefas do Resumo Pedido */
DEFINE SHARED TEMP-TABLE tt-tarefa-resumo NO-UNDO LIKE wm-tarefa-resumo-pedido.

DEFINE TEMP-TABLE tt-volume NO-UNDO
            FIELD cod-volume AS CHARACTER FORMAT 'x(10)':U     LABEL 'Volume':U
            FIELD num-volume AS INTEGER   FORMAT '>>>>>>>9':U  LABEL 'Seq Volume':U.           

DEFINE BUFFER bttWork FOR ttWork.

DEFINE INPUT PARAMETER vRowid        AS ROWID NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER vLogOk AS LOGICAL NO-UNDO.

FIND FIRST tt-tarefa-resumo WHERE ROWID(tt-tarefa-resumo) = vRowid NO-ERROR.
/************************************************************/
/* Variaveis de trabalho ---                                */               
DEFINE NEW SHARED VARIABLE vLogControla AS LOGICAL              INIT NO  NO-UNDO.

DEFINE VARIABLE wgbosc040               AS WIDGET-HANDLE                   NO-UNDO.
DEFINE VARIABLE wgbosc044               AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE VARIABLE vCodReferTemp           AS CHARACTER                       NO-UNDO.
DEFINE VARIABLE vDescSit                AS CHARACTER          INIT 'WMS':U NO-UNDO.

{bcp/bc9015.i3} /* def variaveis padroes */ 
{utp/utapi009.i} /* login */ 

/* Propriedades globais para frames ---                     */               
&global-define FrameSize    20 By 8 
/************************************************************/
/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01                    
&global-define Frame01Defs   'Packing '                                         At Row 01 Col 01                         ~
                             vDescSit                                           At Row 01 Col 09 NO-LABEL FORMAT 'x(07)' ~
                             'Volu:             '                               At Row 02 Col 01                         ~
                             ttWork.cod-volume                                  At Row 02 Col 06 No-label                ~
                             'NumV:             '                               At Row 03 Col 01                         ~
                             ttWork.num-volume                                  At Row 03 Col 06 No-label                ~
                             'Item:'                                            At Row 04 Col 01                         ~
                             ttWork.cod-item                                    At Row 04 Col 06 Format 'x(16)' No-label VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             'Qtde:'                                            At Row 05 Col 01                         ~
                             ttWork.qtd-item                                    At Row 05 Col 06 No-label Format '>>>>>9'~
                             'Lt:'                                              At Row 06 Col 01                         ~
                             ttWork.cod-lote                                    At Row 06 Col 04 NO-LABEL FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             'Refe:'                                            At Row 07 Col 01                         ~
                             ttWork.cod-refer                                   At Row 07 Col 06 No-label                ~
                             'Vali:'                                            At Row 08 Col 01                         ~
                             ttWork.dat-validade                                At Row 08 Col 06 No-label                
&global-define Frame01Repeat NO
/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   {&Frame01Defs}
&global-define Frame02Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-volume ttWork.num-volume
&global-define Update02Fields ttWork.cod-item
/* Definicao das trigger de interacao com a tela ---        */  
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogFinaliza = YES THEN RETURN.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF vLogFinaliza = YES THEN RETURN RETURN-VALUE.
/* Definicao das trigger de usuario ---                     */  
&global-define UserTriggers 

&global-define ActiveObject1 wgbosc040
&global-define ActiveObject2 wgbosc044


/************************************************************/
/* Definicao dos objetos ativos ---                         */  
/************************************************************/

/*****************************************   Frames Fim ******************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */ 
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */ 
/**************************************************************************************************/
/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   IF vLogControla = YES THEN
      RETURN ERROR.

   DISP vDescSit WITH FRAME Frame01.
   
   PAUSE 0 NO-MESSAGE. 
   
   ASSIGN vLogFinaliza = NO.
   
   ASSIGN ttWork.cod-volume    = ''
          ttWork.num-volume    = 0
          ttWork.num-serial    = 0
          ttWork.cod-lote      = ''
          ttWork.cod-refer     = ''
          ttWork.dat-validade  = ?.
   
   ASSIGN ttWork.cod-estabel    = tt-tarefa-resumo.cod-estabel
          ttWork.cod-local      = tt-tarefa-resumo.cod-local
          ttWork.cdd-embarq     = tt-tarefa-resumo.cdd-embarq
          ttWork.num-resumo     = tt-tarefa-resumo.nr-resumo
          ttWork.num-documento  = tt-tarefa-resumo.id-docto
          ttWork.num-tarefa     = tt-tarefa-resumo.id-tarefa
          ttWork.cod-pedcli     = tt-tarefa-resumo.nr-pedcli 
          ttWork.nom-abrev      = tt-tarefa-resumo.nome-abrev.
   
   IF NOT tt-tarefa-resumo.log-itens-packing THEN DO:
      HIDE ALL NO-PAUSE.
      ASSIGN vLogOk = NO.
      
      /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
      DEFINE VARIABLE c-lbl-liter-fechar-tarefa AS CHARACTER FORMAT "X(16)" NO-UNDO.
      {utp/ut-liter.i "Fechar_Tarefa?" *}
      ASSIGN c-lbl-liter-fechar-tarefa = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(13)" NO-UNDO.
      {utp/ut-liter.i "1=Sim_2=NÆo" *}
      ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-fechar-tarefa AT ROW 01 COL 01 NO-LABEL
           c-lbl-liter-1sim-2nao     AT ROW 02 COL 01 NO-LABEL WITH FRAME F-CONF FONT 2 SIZE 20 BY 8 NO-BOX.
      
      UPDATE vLogOk AT ROW 02 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME F-CONF FONT 2 SIZE 20 BY 8.
      HIDE ALL NO-PAUSE.
      IF vLogOK = NO THEN DO:
         ASSIGN vLogFinaliza = NO
                vLogSai      = NO.
         RETURN.
      END.
      
      ASSIGN ttWork.log-inicializa = NO
             ttWork.log-finaliza   = YES
             ttWork.log-estorna    = NO.
      RUN gravaTransacao.
      
      ASSIGN vLogFinaliza = YES
             vLogSai      = YES.
      RETURN.
   END. 
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   IF vLogControla = YES THEN
      RETURN ERROR.
   
   ASSIGN vDescSit           = 'WMS':U
          ttWork.log-estorna = NO.
   
   ASSIGN ttWork.cod-item     = ''
          ttWork.qtd-item     = 0 
          ttWork.cod-lote     = ''
          ttWork.cod-refer    = ''
          ttWork.dat-validade = ?.
   
   DISP ttWork.cod-volume 
        ttWork.num-volume 
        ttWork.cod-lote
        ttWork.cod-refer
        ttWork.dat-validade
        vDescSit
     WITH FRAME {&Frame02Name}.
   
   ASSIGN vLogSai      = NO
          vLogFinaliza = NO.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   ASSIGN vLogErro     = NO
          vLogControla = NO.
   IF ttWork.cod-volume = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "401" "Volume Inv lido. (DC)"}
      RETURN ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc040) THEN
      RUN scbo/bosc040.p PERSISTENT SET wgbosc040 NO-ERROR.
   RUN validaEmbalagem IN wgbosc040 (INPUT ttWork.cod-volume).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "401" "Volume Inv lido. (WMS)"}
      RETURN ERROR.
   END. 
   IF ttWork.num-volume = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "401" "Volume Inv lido. (DC)"}
      RETURN ERROR.
   END. 
   ASSIGN {&TempTable}.cod-volume = ttWork.cod-volume
          {&TempTable}.num-volume = ttWork.num-volume.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO
          vLogControla = NO.
   
   /* Verifica se foi solicitada a saida do programa */     
   IF ttWork.cod-item = '999999':U THEN DO:
      ASSIGN vLogSai      = YES 
             vLogFinaliza = YES.
      RETURN.
   END. 
   
   IF ttWork.cod-item = '888888':U THEN DO:
      HIDE ALL NO-PAUSE.
      ASSIGN vLogOk = NO.
      /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
      DEFINE VARIABLE c-lbl-liter-fechar-tarefa-2 AS CHARACTER FORMAT "X(16)" NO-UNDO.
      {utp/ut-liter.i "Fechar_Tarefa?" *}
      ASSIGN c-lbl-liter-fechar-tarefa-2 = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-1sim-2nao-2 AS CHARACTER FORMAT "X(13)" NO-UNDO.
      {utp/ut-liter.i "1=Sim_2=NÆo" *}
      ASSIGN c-lbl-liter-1sim-2nao-2 = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-fechar-tarefa-2   AT ROW 01 COL 01 NO-LABEL                                             
           c-lbl-liter-1sim-2nao-2       AT ROW 02 COL 01 NO-LABEL
         WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX.
      UPDATE vLogOk           AT ROW 02 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME F-CONF FONT 2 SIZE 20 BY 8.
   
      HIDE ALL NO-PAUSE.
      VIEW FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
      IF vLogOK = NO THEN
         RETURN 'NOK':U.
   
      ASSIGN ttWork.log-inicializa = NO
             ttWork.log-finaliza   = YES
             ttWork.log-estorna    = NO.
   
      RUN gravaTransacao.
      ASSIGN vLogControla = YES
             vLogfinaliza = YES.
      RETURN 'OK':U.
   END. 

   /* Verifica se foi solicitado o estorno do packing */     
   IF ttWork.cod-item = '555555':U THEN DO:
      HIDE ALL NO-PAUSE.
      ASSIGN vLogOk = NO.
      
      /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
      DEFINE VARIABLE c-lbl-liter-estornar-item AS CHARACTER FORMAT "X(16)" NO-UNDO.
      {utp/ut-liter.i "Estornar_Item?" *}
      ASSIGN c-lbl-liter-estornar-item = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-estornar-item AT ROW 01 COL 01 NO-LABEL WITH FRAME f-estor FONT 2 SIZE 20 BY 8 NO-BOX.
      UPDATE vLogOk AT ROW 02 COL 01 FORMAT 'Sim/NÆo' NO-LABEL WITH FRAME f-estor FONT 2 SIZE 20 BY 8.
      
      HIDE ALL NO-PAUSE.
      VIEW FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
      IF vLogOK = NO THEN
         RETURN 'NOK':U.
      
      BUFFER-COPY ttWork To bttWork.
      ASSIGN ttWork.log-inicializa = NO
             ttWork.log-finaliza   = NO
             ttWork.log-estorna    = YES.
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9019z.p.
      HIDE ALL NO-PAUSE.
      VIEW FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
      ASSIGN vDescSit = 'Estorno':U.
      
      DISP vDescSit WITH FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
      
      FIND FIRST ttWork NO-ERROR.
      
      IF ttWork.cod-item = '' THEN DO:
         ASSIGN ttWork.log-estorna = NO
                vDescSit = 'WMS'.
         DISP vDescSit WITH FRAME Frame02.
         PAUSE 0 NO-MESSAGE.
         RETURN 'NOK':U.
      END. 
   END. 
   
   /* Via item com presen‡a de seriais (777777), via item sem presen‡a de seriais (666666) */
   If ttWork.cod-item = '777777':U OR ttWork.cod-item = '666666':U THEN DO:
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9019z.p.
      HIDE ALL NO-PAUSE.
      VIEW FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
      IF SESSION:DATA-ENTRY-RETURN = YES THEN.
      
      FIND FIRST ttWork NO-ERROR.
      IF ttWork.cod-item = '777777':U OR ttWork.cod-item = '' THEN
         RETURN 'NOK':U.
      
      DISPLAY ttWork.cod-item WITH FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
      
      DISPLAY ttWork.cod-lote
              ttWork.cod-refer
              ttWork.dat-validade
         WITH FRAME Frame02.
      
      PAUSE 0 NO-MESSAGE.
      ASSIGN vLogErro = NO.
   END.
   
   IF ttWork.cod-item = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "504" "Item Inv lido. (DC)"}
      RETURN ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc044) THEN
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
   
   RUN EmptyRowErrors IN wgbosc044.
   RUN validaDadosItem IN wgbosc044 (INPUT ttWork.cod-item).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "504" "Item Inv lido. (WMS)"}
      RETURN ERROR.
   END. 
   
   FIND FIRST bc-ext-saldo-estoq
        WHERE bc-ext-saldo-estoq.cod-unico = ttWork.cod-item NO-LOCK NO-ERROR.
   IF AVAIL bc-ext-saldo-estoq THEN DO:
      ASSIGN vCodReferTemp = ENTRY(2,bc-ext-saldo-estoq.lote,'-') NO-ERROR.
      IF vCodReferTemp = ? THEN
         ASSIGN vCodReferTemp = ' '.
      
      ASSIGN ttWork.cod-item       = bc-ext-saldo-estoq.it-codigo
             ttWork.cod-lote       = bc-ext-saldo-estoq.lote
             ttWork.cod-refer      = vCodReferTemp
             ttWork.dat-validade   = bc-ext-saldo-estoq.data-1
             ttWork.dat-transacao  = TODAY.
      HIDE ALL.
      DISPLAY ttWork.cod-item
              ttWork.cod-lote
              ttWork.cod-refer
              ttWork.dat-validade
         WITH FRAME Frame02.
      PAUSE 0 NO-MESSAGE.
   END. 
   
   IF vLogFinaliza = YES THEN
       RETURN ERROR.
   
   HIDE ALL.
   
   RUN bcp/bc9019n.p(INPUT vDescSit).
   HIDE ALL.
   
   FIND FIRST tt-volume
        WHERE tt-volume.cod-volume = ttwork.cod-volume
          AND tt-volume.num-volume = ttwork.num-volume NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-volume THEN DO:
      CREATE tt-volume.
      ASSIGN tt-volume.cod-volume = ttWork.cod-volume
             tt-volume.num-volume = ttWork.num-volume
             ttWork.log-alteracao = NO.
   END.
   ELSE DO:
      ASSIGN ttWork.log-alteracao = YES.
   END.
   
   HIDE ALL.
   IF RETURN-VALUE = 'OK':U THEN DO:
      RUN gravaTransacao.
      ASSIGN ttWork.log-inicializa = NO
             ttWork.log-finaliza   = NO
             ttWork.log-estorna    = NO
             vDescSit              = 'WMS':U.
      
      DISP vDescSit WITH FRAME Frame02.
      
      PAUSE 0 NO-MESSAGE.
      RETURN 'OK':U.
   END.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure e‹ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   DEF VAR vNomeUsuario AS CHARACTER NO-UNDO.
   
   ASSIGN vTransDetail = vTransaction  + 
                         'User: '  + STRING(ttWork.cod-usuario)      +   
                         'Coll: '  + STRING(ttWork.cod-coletor)      +
                         ' Eqp: '  + STRING(ttWork.cod-equipamento)  +
                         ' Doc: '  + STRING(ttWork.num-documento)    +
                         'Date: '  + STRING(TODAY,'99/99/9999')      +
                         'Time: '  + STRING(TIME,'hh:mm:ss').
   ASSIGN vNomeUsuario = ttWork.cod-usuario.
   BUFFER-COPY ttWork TO {&TempTable}.
   RAW-TRANSFER {&TempTable} TO vConteudoRaw.
   
   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */     
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */         
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */   
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */  
   IF ttWork.log-estorna = YES THEN DO:
      IF RETURN-VALUE <> 'NOK':U THEN DO:
         {bcp/bc9105.i "901" "Estornado. (DC)"}
         RETURN 'OK':U.
      END. 
   END.
   ELSE DO:
      IF RETURN-VALUE <> 'NOK':U THEN DO:
         {bcp/bc9105.i "902" "Empacotado. (DC)"}
         RETURN 'OK':U.
      END. 
   END.
   RETURN 'NOK':U.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   **********************************/
