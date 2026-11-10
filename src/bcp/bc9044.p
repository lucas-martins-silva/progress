/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9044 2.00.00.008 } /*** "010008" 24/07/2024 09:57:07  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9044 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-picking-wms.                                                     **
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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9044
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{bcp/bc9018.i " "}
{bcp/bc9018.i1 "New"}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

CREATE ttWork.

DEFINE VARIABLE vcod-senha    AS CHARACTER FORMAT 'x(18)':U   NO-UNDO.
DEFINE VARIABLE l-esc         AS LOGICAL                      NO-UNDO.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE NEW GLOBAL SHARED VARIABLE hbc9025n              AS HANDLE       NO-UNDO. 

DEFINE VARIABLE wgbcapiwms              AS HANDLE                       NO-UNDO. 

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Convoc. Ativa'                                    At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
&global-define Frame01Repeat NO
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
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
                            ON 'Return':U        OF ttWork.cod-equipamento In Frame {&Frame01Name}  ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1  wgbosc079
&global-define ActiveObject2  wgbosc092
&global-define ActiveObject3  wgbosc096
&global-define ActiveObject4  wgbosc135
&global-define ActiveObject5  wgbcapiwms

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
   ASSIGN vLogErro = NO
          vLogCancela = NO.

   /* caso tenha sido startado login autom tico */
   IF  v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01                = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
      IF v_cod-coletor_corren  <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01                = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario                               = ''
             vcod-senha                                       = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01         = ''.
   END.
END PROCEDURE.



/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

   DEFINE VARIABLE r-tarefa-docto-itens AS ROWID       NO-UNDO.
   DEFINE VARIABLE i-cod-tarefa         AS INTEGER     NO-UNDO.

   ASSIGN vLogErro          = NO
          vLogControlaLogin = NO.

   /* valida usuario mestre contra mguni do EMS */
   IF ttWork.cod-usuario = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "101" "Usu rio Inv lido (DC)"}
   END.

   IF v2_cod_usuar_corren = '' THEN DO:
      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
      ON QUIT   UNDO login, LEAVE login
      ON STOP   UNDO login, LEAVE login
      ON ENDKEY UNDO login, LEAVE login: 
         RUN btb/btapi910za.p (INPUT INPUT FRAME frame01 ttWork.cod-usuario, 
                               INPUT INPUT FRAME frame01 vCod-Senha, 
                               OUTPUT table tt-erros) NO-ERROR.        
      END.
       
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

      RUN piValidaUsuario IN wgbcapiwms (INPUT INPUT FRAME frame01 ttWork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
                                          
      IF VALID-HANDLE(wgbcapiwms) THEN
         DELETE PROCEDURE wgbcapiwms NO-ERROR. 
                                           
      ASSIGN vLogControlaLogin = YES.
   END.

   /*****************************************************************/
   IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc135)  THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135.
      RUN openQueryStatic IN wgbosc135 (INPUT "Main":U) NO-ERROR.
   END.

   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      RUN getrowErrors IN wgbosc079 (OUTPUT Table RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.                                           
   END.

   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu rio sem permissÆo para utilizar Coletor (WMS)"}
      RETURN ERROR.
   END.

   IF ttWork.cod-coletor = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
   END.

   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   IF NOT VALID-HANDLE(wgbosc092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
      RUN EmptyRowErrors IN wgbosc092.
   END.

   RUN validaEquipColetor IN wgbosc092  (INPUT  ttWork.cod-coletor,
                                         OUTPUT vCodTipoEquip,
                                         OUTPUT vLogAtivo,
                                         OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inv lido (WMS)"}
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   RUN validaEquipTransportador IN wgbosc092  (INPUT  ttWork.cod-equipamento,
                                               OUTPUT vCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Inv lido (WMS)"}
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   IF NOT VALID-HANDLE(wgbosc096) THEN DO:
      RUN scbo/bosc096.p PERSISTENT SET wgbosc096       NO-ERROR.
      RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.
   END.

   /* Executa enquanto tiver Tarefa para o Usu rio, ou for dado ESC pelo Usu rio */
   REPEAT:
      RUN wmp/wm9042.p (INPUT  ttWork.cod-usuario,
                        INPUT  ttWork.cod-equipamento,
                        INPUT  "",
                        INPUT  "",
                        INPUT  ?,
                        OUTPUT r-tarefa-docto-itens).

      IF r-tarefa-docto-itens = ? THEN
         LEAVE.
    
      IF VALID-HANDLE(wgbosc096) THEN DO:
         RUN repositionRecord IN wgbosc096 (INPUT r-tarefa-docto-itens) NO-ERROR.
         IF RETURN-VALUE = "OK":U THEN DO:
            RUN getIntField  IN wgbosc096 (INPUT "cod-tarefa":U, OUTPUT i-cod-tarefa).
                
            CASE i-cod-tarefa:
               WHEN 3  THEN DO: /* Transferˆncia entre Endere‡os */
                  RUN getMovtoTarefasUsuarioConvoc IN wgbosc096 (INPUT r-tarefa-docto-itens,
                                                                 INPUT ttWork.cod-equipamento,
                                                                 INPUT NO,
                                                                 INPUT YES,
                                                                 OUTPUT TABLE ttWm-box-movto-idx).    
                  FIND FIRST ttWm-box-movto-idx NO-LOCK
                       WHERE ttWm-box-movto-idx.ind-tipo-movto = 2 NO-ERROR.
                  IF AVAIL  ttWm-box-movto-idx THEN DO:
                     /* Execu‡Æo nesse ponto para que nos programas seguintes a tt-agrupadores esteja disponivel */
                     IF NOT VALID-HANDLE(hbc9025n) THEN DO:
                        RUN bcp/bc9025n.p PERSISTENT SET hbc9025n NO-ERROR.
                     END.

                     FIND FIRST wm-equipamento NO-LOCK
                          WHERE wm-equipamento.cod-equipamento = ttWork.cod-equipamento NO-ERROR.
                    
                     RUN validaAgrupadores IN hbc9025n (INPUT ttWork.cod-usuario,
                                                        INPUT ttWork.cod-equipamento,
                                                        INPUT IF AVAIL wm-equipamento THEN wm-equipamento.cdn-tipo-equipamento ELSE 0,
                                                        INPUT ttWork.cod-coletor,
                                                        INPUT ttWm-box-movto-idx.cod-estabel,
                                                        INPUT ttWm-box-movto-idx.cod-local).

                     IF ttWm-box-movto-idx.ind-status-movto < 3 THEN DO:    
                        HIDE ALL NO-PAUSE.
                        RUN bcp/bc9025s2.p (INPUT  2, /* Sa¡da */
                                            INPUT  1, /* Autom tico */
                                            OUTPUT l-esc).
                        HIDE ALL NO-PAUSE.                                
                     END.
                     ELSE DO:
                        FIND FIRST ttWm-box-movto-idx NO-LOCK
                             WHERE ttWm-box-movto-idx.ind-tipo-movto = 1 NO-ERROR.
                        IF AVAIL ttWm-box-movto-idx AND ttWm-box-movto-idx.ind-status-movto < 3 THEN DO:        
                           HIDE ALL NO-PAUSE.
                           RUN bcp/bc9025e2.p (INPUT 1, /* Entrada */
                                               INPUT 1, /* Autom tico */
                                               OUTPUT l-esc).
                           HIDE ALL NO-PAUSE.

                        END.
                     END.
                  END.
               END.
               WHEN 4 THEN DO: /* Ressuprimento */
                  RUN getTarefaRessupConvoc IN wgbosc096 (INPUT ttWork.cod-equipamento,
                                                          INPUT r-tarefa-docto-itens,
                                                          OUTPUT TABLE ttWm-box-movto-idx).    
                  FIND FIRST ttWm-box-movto-idx NO-LOCK NO-ERROR.
                  IF AVAIL ttWm-box-movto-idx THEN DO:
                     HIDE ALL NO-PAUSE.
                     RUN bcp/bc9020n.p (INPUT ttWork.cod-usuario,
                                        INPUT ttWork.cod-coletor,
                                        INPUT ttWork.cod-equipamento,
                                        INPUT r-tarefa-docto-itens,
                                        OUTPUT l-esc).
                     HIDE ALL NO-PAUSE.
                  END.
               END.
               WHEN 7 THEN DO: /* Picking */
                  RUN getTarefaPickingConvoc IN wgbosc096 (INPUT ttWork.cod-equipamento,
                                                           INPUT r-tarefa-docto-itens,
                                                           INPUT NO,
                                                           INPUT YES,
                                                           OUTPUT TABLE ttWm-box-movto-idx-picking).
                  IF RETURN-VALUE = "NOK" THEN DO:
                     RUN getrowErrors IN wgbosc096 (OUTPUT Table RowErrors).
                     FOR EACH RowErrors:
                        ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                        {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
                     END.                                           
                     RETURN ERROR.
                  END.
                  FIND FIRST ttWm-box-movto-idx-picking NO-LOCK NO-ERROR.
                  IF AVAIL ttWm-box-movto-idx-picking THEN DO:
                     HIDE ALL NO-PAUSE.
                     RUN bcp/bc9018j.p (INPUT ttWork.cod-usuario,
                                        INPUT ttWork.cod-coletor,
                                        INPUT ttWork.cod-equipamento,
                                        INPUT r-tarefa-docto-itens,
                                        OUTPUT l-esc).
                     HIDE ALL NO-PAUSE.
                  END.
               END.
               WHEN 13 THEN DO: /* Recebimento (Armazenamento) */
                  HIDE ALL NO-PAUSE.
                  RUN bcp/bc9029e.p (INPUT ttWork.cod-usuario,
                                     INPUT ttWork.cod-coletor,
                                     INPUT ttWork.cod-equipamento,
                                     INPUT r-tarefa-docto-itens,
                                     OUTPUT l-esc).
                  HIDE ALL NO-PAUSE.
               END.
            END CASE.
         END.
      END.
    
      ASSIGN  {&TempTable}.cod-usuario     = ttWork.cod-usuario 
              {&TempTable}.cod-coletor     = ttWork.cod-coletor
              {&TempTable}.cod-equipamento = ttWork.cod-equipamento.
              
      /* Se foi dado um ESC na tela que foi chamada, sai do processo */
      IF l-esc THEN
         LEAVE.
   END.

   IF VALID-HANDLE(hbc9025n) THEN
      DELETE PROCEDURE hbc9025n.

   IF vLogErro = YES THEN RETURN ERROR.

END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
