/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9019 2.00.00.018 } /*** "010018" 18/03/2024 10:23:51 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9019 MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9019.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karen - Criaá∆o do programa                  **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Packing WMS                      **
**                                                                                         **
********************************************************************************************/
DEFINE NEW GLOBAL SHARED VAR lMenu          AS LOGICAL                               NO-UNDO.
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
**                        que executa a procedure _GenerateDCTransaction que eÔ responsavel por   **
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
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE NEW SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.

/* Definicao da Temp-table de Tarefas do Resumo Pedido */
DEFINE NEW SHARED TEMP-TABLE tt-tarefa-resumo NO-UNDO LIKE wm-tarefa-resumo-pedido.
DEFINE BUFFER btt-tarefa-resumo FOR tt-tarefa-resumo.

DEFINE TEMP-TABLE tt-volume NO-UNDO
            FIELD cod-volume AS CHARACTER FORMAT 'x(10)':U     LABEL 'Volume'      
            FIELD num-volume AS INTEGER   FORMAT '>>>>>>>9':U  LABEL 'Seq Volume'.           

DEFINE BUFFER bttWork FOR ttWork.
/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE NEW SHARED VARIABLE vLogControla AS LOGICAL                         INIT NO  NO-UNDO.
                                                                           
DEFINE VARIABLE vCodOpcao               AS CHARACTER                       INIT ''  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER                       INIT ''  NO-UNDO.
DEFINE VARIABLE vCodEmbalagem           AS CHARACTER                       INIT ''  NO-UNDO.
DEFINE VARIABLE vCodItem                AS CHARACTER                       INIT ''  NO-UNDO.
DEFINE VARIABLE vNumCont                AS INTEGER                         INIT 0   NO-UNDO.
DEFINE VARIABLE vNumSeq                 AS INTEGER                         INIT 0   NO-UNDO.
                                                                           
DEFINE VARIABLE wgbosc092               AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VARIABLE wgbosc109               AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VARIABLE wgbosc111               AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VARIABLE wgbosc040               AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VARIABLE wgbosc079               AS WIDGET-HANDLE                            NO-UNDO.       
DEFINE VARIABLE wgbosc044               AS WIDGET-HANDLE                            NO-UNDO.   
DEFINE VARIABLE wgbosc135               AS WIDGET-HANDLE                            NO-UNDO.
DEFINE VARIABLE wgbcapiwms              AS HANDLE                                   NO-UNDO.         
                                                                           
DEFINE VARIABLE vLogOk                  AS LOGICAL                         INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL                         INIT NO  NO-UNDO.
DEFINE VARIABLE vLogProcesso            AS LOGICAL                         INIT NO  NO-UNDO.
DEFINE VARIABLE v-cod-estabel           AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE v-cod-local             AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE vEmbarque               AS DECIMAL      FORMAT '>>>>>>>>>>>>>>>9':U NO-UNDO.
DEFINE VARIABLE vCodSenha               AS CHARACTER    FORMAT 'x(18)':U            NO-UNDO.

DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                         INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                         INIT NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                         INIT NO  NO-UNDO.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE QUERY qry-tt-tarefa-resumo FOR tt-tarefa-resumo.

DEFINE BROWSE brw-tt-tarefa-resumo QUERY qry-tt-tarefa-resumo NO-LOCK
         DISPLAY nome-abrev  FORMAT 'x(10)'
                 nr-pedcli   FORMAT 'x(08)'
           WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Packing WMS'                                      At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             At Row 04 Col 01          ~
                             vCodSenha                                          At Row 04 Col 05 No-label FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Packing WMS'              At Row 01 Col 01          ~
                             '--------------------':U   At Row 02 Col 01          ~
                             '1 - P£blicos'             At Row 03 Col 01          ~
                             '2 - Meus Abertos'         At Row 04 Col 01          ~
                             '3 - Meus em Processo'     At Row 05 Col 01          ~
                             'Opá∆o:'                   At Row 06 Col 01          ~
                              ttWork.cod-opcao          At Row 06 Col 12 No-Label
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Packing WMS'                                      At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             brw-tt-tarefa-resumo                               At Row 03 Col 01          ~
                             vEmbarque                                          At Row 08 Col 01 NO-LABEL
&global-define Frame03Repeat YES



      
/* Definicao dos campos a serem recebidos ---               */

&global-define Update01Fields                                  ~
               ttWork.cod-usuario  WHEN ttWork.cod-usuario = ''~
               vCodSenha           WHEN ttWork.cod-usuario = ''~
               ttWork.cod-coletor ~
               ttWork.cod-equipamento 

&global-define Update02Fields ttWork.cod-opcao

&global-define Update03Fields brw-tt-tarefa-resumo


/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
                            DO:                                                    ~
                                IF v_cod-coletor_corren     <> '' AND              ~
                                   v_cod-equipamento_corren <> '' THEN DO:         ~
                                    IF l-menu-padrao = YES THEN DO:                ~
                                        ASSIGN l-menu-padrao = NO.                 ~
                                        APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    ELSE DO:                                       ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}. ~
                                    END.                                           ~
                                    RETURN NO-APPLY.                                   ~
                                END.                                               ~
                            END.                                                   ~
                            ON 'Return':U        OF brw-tt-tarefa-resumo In Frame {&Frame03Name}     ~
                            DO:                                                                      ~
                               Apply 'Go':U To This-procedure.                                       ~
                            END.                                                                     ~
                            ON 'value-changed':U OF brw-tt-tarefa-resumo In Frame {&Frame03Name}     ~
                            DO:                                                                      ~
                                IF AVAIL tt-tarefa-resumo THEN                                       ~
                                    Assign vEmbarque:screen-value In Frame frame03 = string(tt-tarefa-resumo.cdd-embarq).  ~
                            END.                                                                                                

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc092
&global-define ActiveObject2 wgbosc109
&global-define ActiveObject3 wgbosc111
&global-define ActiveObject4 wgbosc079
&global-define ActiveObject5 wgbosc135
&global-define ActiveObject6 wgbcapiwms
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eÔ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local Ç destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vCodSenha:BLANK IN FRAME Frame01                 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vCodSenha                                        = '****************':U 
             vCodSenha:SCREEN-VALUE IN FRAME frame01          = '****************':U. 
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
          ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                 ttWork.cod-coletor     = v_cod-coletor_corren
                 ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                 ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vCodSenha:BLANK IN FRAME Frame01                 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario                               = '' 
             vCodSenha                                        = ''  
             vCodSenha:SCREEN-VALUE IN FRAME Frame01          = ''.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   IF v_cod_usuar_corren = '' THEN
      RETURN ERROR.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   ASSIGN vLogErro    = NO
          vLogCancela = NO.
   
   RUN GetTasks.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   FIND FIRST tt-tarefa-resumo NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-tarefa-resumo THEN DO:
      CREATE tt-tarefa-resumo.
      ASSIGN tt-tarefa-resumo.val-prioridade  = 999
             tt-tarefa-resumo.nome-abrev      = 'Sem tarefas (WMS).'.
   END.
   
   OPEN QUERY qry-tt-tarefa-resumo
     FOR EACH tt-tarefa-resumo
           BY tt-tarefa-resumo.nome-abrev
           BY tt-tarefa-resumo.nr-pedcli
           BY tt-tarefa-resumo.val-prioridade.
   BROWSE brw-tt-tarefa-resumo:REFRESH() NO-ERROR.
   
   APPLY 'VALUE-CHANGED':U TO brw-tt-tarefa-resumo IN FRAME {&Frame03Name}.
   
   ASSIGN ttWork.log-inicializa = YES
          ttWork.log-finaliza   = NO
          ttWork.log-estorna    = NO.
END PROCEDURE.

/*************************************************************************************************** 

** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   
   ASSIGN vLogErro          = NO 
          vLogControlaLogin = NO.
   
   IF v2_cod_usuar_corren = '' THEN DO:
      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
         ON QUIT   UNDO login, LEAVE login
         ON STOP   UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
         RUN btb/btapi910za.p(INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame01,
                              INPUT vCodSenha,
                              OUTPUT TABLE tt-erros) NO-ERROR.        
      END. 
      IF CAN-FIND(FIRST tt-erros
                  WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado. (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND(FIRST tt-erros
                     WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta. (DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
         ELSE DO:
            IF CAN-FIND(FIRST tt-erros) THEN DO:
              {bcp/bc9105.i "202" "Problemas na autenticaá∆o do usu†rio. (DC)"} 
              ASSIGN vLogErro           = YES
                     v_cod_usuar_corren = ''.
              RETURN ERROR.
            END.
         END.
      END.
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.
   
      RUN piValidaUsuario IN wgbcapiwms (INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame01,
                                         OUTPUT ttWork.cod-usuario).
                                         
      IF VALID-HANDLE(wgbcapiwms) THEN
         DELETE PROCEDURE wgbcapiwms NO-ERROR.   
                                          
      ASSIGN vLogControlaLogin = YES.
   END.
   
   RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
   RUN scbo/bosc109.p PERSISTENT SET wgbosc109 NO-ERROR.
   RUN scbo/bosc111.p PERSISTENT SET wgbosc111 NO-ERROR.
   RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
   RUN scbo/bosc135.p PERSISTENT SET wgbosc135 NO-ERROR.
   
   {bcp/bc9017.i1 ttWork.cod-usuario}
   IF vLogOk = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu†rio Inv†lido. (DC)"}
      RETURN ERROR.
   END.
   
   /* Valida se usu†rio tem permiss∆o para executar a tarefa. */
   RUN validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                         INPUT 08).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "100" "Usu†rio sem permiss∆o para executar Packing. (WMS)"}
      RETURN ERROR.
   END.
   
   
   /* Valida existància do usu†rio no WMS e retorna se ele tem ou n∆o permiss∆o para utilizar coletor e aprovar faturas. */
   RUN validaUsuario IN wgbosc079 (INPUT ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu†rio Inv†lido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "102" "Usu†rio sem permiss∆o para utilizar Coletor. (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida se existe equipamento, se Ç do tipo coletor e se est† ativo */    
   RUN validaEquipColetor IN wgbosc092  (INPUT ttWork.cod-coletor,
                                         OUTPUT vCodTipoEquip,
                                         OUTPUT vLogAtivo,
                                         OUTPUT vLogProcesso).
   
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inv†lido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Coletor Inativo. (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida se existe equipamento, se Ç do tipo transportador e se est† ativo */
   RUN validaEquipTransportador IN wgbosc092  (INPUT ttWork.cod-equipamento,
                                               OUTPUT vCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipto Inv†lido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "106" "Equipto Inativo. (WMS)"}
      RETURN ERROR.
   END.
   
   /* Validacoes Frame 02 Fim    --- */
   ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario 
          {&TempTable}.cod-coletor     = ttWork.cod-coletor
          {&TempTable}.cod-equipamento = ttWork.cod-equipamento.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   ASSIGN vLogErro = NO vLogControla = NO.
   
   IF INPUT FRAME Frame02 ttWork.cod-opcao < 1 OR INPUT FRAME Frame02 ttWork.cod-opcao > 3 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "As opá‰es dispon°veis s∆o 1, 2 e 3. (DC)"}
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
   /* Validacoes Frame 03 Inicio --- */     
   
   ASSIGN vLogErro = NO.
   FIND FIRST btt-tarefa-resumo
        WHERE btt-tarefa-resumo.val-prioridade <> 999 NO-LOCK NO-ERROR.
   IF NOT AVAIL btt-tarefa-resumo THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Tarefa Inv†lida. (WMS)"}
      RETURN ERROR.
   END.
   
   RUN validaPackingPedido IN wgbosc109 (INPUT tt-tarefa-resumo.cod-estabel,
                                         INPUT tt-tarefa-resumo.cod-local,
                                         INPUT tt-tarefa-resumo.nr-resumo,
                                         INPUT tt-tarefa-resumo.cdd-embarq,
                                         INPUT tt-tarefa-resumo.nr-pedcli,
                                         INPUT tt-tarefa-resumo.nome-abrev).
   
   IF RETURN-VALUE <> 'OK'  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "302" "Picking Pendente. (WMS)"}
      RETURN ERROR.
   END.
   
   HIDE ALL.
   RUN bcp/bc9019f.p(INPUT ROWID(tt-tarefa-resumo),
                     INPUT-OUTPUT vLogOk).
   FIND FIRST ttWork NO-ERROR.
   HIDE ALL.
   RETURN RETURN-VALUE.
END PROCEDURE.

PROCEDURE GetTasks:
   ASSIGN vLogErro = NO.
   EMPTY TEMP-TABLE tt-tarefa-resumo.
   
   CASE ttWork.cod-opcao:
      WHEN 1 THEN DO:
         RUN getTarefaResumoPedidoAberta IN wgbosc111 (INPUT vCodTipoEquip,
                                                       INPUT 08,           
                                                       INPUT '',
                                                       OUTPUT TABLE tt-tarefa-resumo).
      END.
      WHEN 2 THEN DO:
         RUN getTarefaResumoPedidoAberta IN wgbosc111 (INPUT vCodTipoEquip,
                                                       INPUT 08,           
                                                       INPUT ttWork.cod-usuario,
                                                       OUTPUT TABLE tt-tarefa-resumo).
      END.
      WHEN 3 THEN DO:
         RUN getTarefaResumoPedidoProcesso IN wgbosc111 (INPUT vCodTipoEquip,
                                                         INPUT 08,           
                                                         INPUT ttWork.cod-usuario,
                                                         OUTPUT TABLE tt-tarefa-resumo).
      END.
   END CASE.
   
   RETURN 'OK':U.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
