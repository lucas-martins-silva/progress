/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9016 2.00.00.016 } /*** "010016" 15/03/2024 16:33:34 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9016 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9016.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2002 - karla Klemke - Cria‡Æo do programa            **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Conferˆncia WMS                  **
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
**                        Ex: tt-recebe-wms.                                                      **
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
&global-define ProgramName BC9016
/************************************************************/
{bcp/bc9016.i1} /* Def Variaveis Padroes Produto */
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-recebe-wms
{bcp/bc9016.i " "}

DEFINE NEW SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.


DEFINE NEW SHARED TEMP-TABLE ttWm-conferencia-aux NO-UNDO
    FIELD cod-estabel             AS CHARACTER
    FIELD cod-usuario             AS CHARACTER
    FIELD cod-local               AS CHARACTER
    FIELD id-docto                AS DECIMAL
    FIELD ind-nivel-conferencia   AS INTEGER
    FIELD ind-status-conferencia  AS INTEGER
    FIELD ind-tipo-conferencia    AS INTEGER
    FIELD nr-leitura              AS INTEGER
 INDEX idx-conferencia AS PRIMARY UNIQUE
    nr-leitura ASC
    id-docto ASC
    cod-usuario ASC.

DEFINE NEW SHARED TEMP-TABLE tt-tarefa-docto NO-UNDO
    FIELD id-docto                LIKE wm-tarefa-docto.id-docto
    FIELD id-tarefa               LIKE wm-tarefa-docto.id-tarefa
    FIELD cod-tarefa              LIKE wm-tarefa-docto.cod-tarefa
    FIELD cod-usuario             LIKE wm-tarefa-docto.cod-usuario
    FIELD cod-equipamento         LIKE wm-tarefa-docto.cod-equipamento
    FIELD cod-coletor             LIKE wm-tarefa-docto.cod-coletor
    FIELD ind-status-tarefa-docto LIKE wm-tarefa-docto.ind-status-tarefa-docto
    FIELD dt-inicio-tarefa        LIKE wm-tarefa-docto.dt-inicio-tarefa
    FIELD hr-inicio-tarefa        LIKE wm-tarefa-docto.hr-inicio-tarefa
    FIELD dt-fim-tarefa           LIKE wm-tarefa-docto.dt-fim-tarefa
    FIELD hr-fim-tarefa           LIKE wm-tarefa-docto.hr-fim-tarefa
    FIELD val-prioridade          LIKE wm-tarefa-docto.val-prioridade
    FIELD num-docto               Like wm-docto.num-docto
    FIELD cod-estabel             LIKE wm-docto.Cod-estabel
    FIELD cod-local               LIKE wm-docto.Cod-Local.

DEFINE TEMP-TABLE RowErrors NO-UNDO 
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE wgbcapiwms    AS HANDLE              NO-UNDO.
/************************************************************/

DEFINE QUERY qry-tarefa-docto FOR tt-tarefa-docto. 

DEFINE BROWSE brw-tarefa-docto QUERY qry-tarefa-docto NO-LOCK
             DISPLAY 
                tt-tarefa-docto.id-docto  FORMAT '>>>>>>>>9'
                tt-tarefa-docto.id-tarefa FORMAT '>>>>>>9'
                     WITH NO-BOX NO-LABELS SIZE 20 BY 4 NO-SCROLLBAR-VERTICAL.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Conferˆncia WMS'                                  At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label
&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Conferˆncia WMS'                                  At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Tarefas P£blicas'                             At Row 03 Col 01          ~
                             '2 - Minhas Tarefas  '                             At Row 04 Col 01          ~
                             '3 - Meus Processos  '                             At Row 05 Col 01          ~
                             'Op‡Æo:              '                             At Row 07 Col 01          ~
                              ttWork.opcao                                      At Row 07 Col 08 No-Label

&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Conferˆncia WMS'                                  At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             vtiptarefa                                         At Row 03 Col 01 NO-LABEL ~
                             brw-tarefa-docto                                   At Row 04 Col 01          ~
                             vDesDocumento                                      At Row 08 Col 01 No-label
&global-define Frame03Repeat NO

&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Conferˆncia WMS'                                  At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Docto/Tarefa:'                                    AT ROW 03 COL 01          ~
                             vdoctar                                            AT ROW 04 COL 01 NO-LABEL ~
                             'Serial:             '                             At Row 05 Col 01          ~
                             ttWork.num-serial                                  At Row 06 Col 01 No-label ~
                             'Lidos: '                                          At Row 08 Col 01          ~
                             vDesLidos                                          At Row 08 Col 08 No-label
&global-define Frame04Repeat Yes 

/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento

&global-define Update02Fields ttWork.opcao     

&global-define Update03Fields brw-tarefa-docto 

&global-define Update04Fields ttWork.num-serial 

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerAfterFrame04  Run GravaCamposFrame04.  If  Return-value = 'OK':U Then Do:         ~
                                                                 Assign vLogFinaliza = Yes              ~
                                                                        vLogSai      = Yes.             ~
                                                                 Return.                                ~
                                                             End.                                       ~


/************************************************************/

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
                            ON 'Return':U OF brw-tarefa-docto In Frame {&Frame03Name}               ~
                            DO: ~
                               Apply 'Go':U To This-procedure.                                        ~
                            END.  ~
                            ON 'value-changed':U OF brw-tarefa-docto In Frame {&Frame03Name}        ~
                            DO:      ~
                               If  Avail tt-tarefa-docto  Then Do:     ~
                                  ASSIGN ttWork.cod-documento = string(tt-tarefa-docto.id-docto)    ~
                                         vDesDocumento:screen-value In Frame frame03 = 'Doc:':U + string(tt-tarefa-docto.num-docto). ~
                               End.                                                                 ~
                            END.                                                                    

/************************************************************/

/* Definicao dos objetos ativos --- */ 
&global-define ActiveObject1 wgbc9016f
&global-define ActiveObject2 wgbosc092
&global-define ActiveObject3 wgbosc093
&global-define ActiveObject4 wgbosc095
&global-define ActiveObject5 wgbosc094
&global-define ActiveObject6 wgbosc074
&global-define ActiveObject7 wgbosc079
&global-define ActiveObject8 wgbcapi001
&global-define ActiveObject9 wgbosc135
&global-define ActiveObject10 wgbcapiwms
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1             **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:

   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
      IF v_cod-coletor_corren <> '' AND  v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor                                          = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento                                      = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
   END.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame04 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:

   ASSIGN vLogErro = NO.

   IF NOT VALID-HANDLE(wgbosc093) THEN DO:
      RUN scbo/bosc093.p PERSISTENT SET wgbosc093.
   END.
   
   IF NOT VALID-HANDLE(wgbosc094) THEN DO:
      RUN scbo/bosc094.p PERSISTENT SET wgbosc094.
   END.
   
   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
      RUN openQueryStatic IN wgbosc074 (INPUT "MAIN":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbc9016f) THEN DO:
      RUN bcp/bc9016f.p PERSISTENT SET wgbc9016f.
   END.                                       

   ASSIGN {&TempTable}.opcao = INPUT FRAME Frame02 ttWork.opcao.
   
   EMPTY TEMP-TABLE tt-tarefa-docto.

   RUN GetTasks.  /* Procedure respons vel em montar a lista de tarefas de conferˆncia */

   FIND FIRST tt-tarefa-docto NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-tarefa-docto THEN DO:
      ASSIGN vtiptarefa = 'Tarefa Inexistente (WMS)'.
      /* os campos do browser sÆo do tipo Integer e Decimal, impossibilitando utilizar a t‚cnica utilizada no Picking */
   END.

   DISPLAY vtiptarefa
      WITH FRAME  {&Frame03Name}.
      
   OPEN QUERY qry-tarefa-docto FOR EACH tt-tarefa-docto.
   
   BROWSE brw-tarefa-docto:REFRESH() NO-ERROR.
    
   APPLY 'VALUE-CHANGED':U To brw-tarefa-docto IN FRAME {&Frame03Name}.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:  

   ASSIGN vLogErro          = NO
          ttWork.num-serial = 0.

   RUN verificaStatusTarefa IN wgbosc095 (INPUT tt-tarefa-docto.id-docto,
                                          INPUT tt-tarefa-docto.id-tarefa,
                                          OUTPUT vNumStatus).
   IF vNumStatus = 1 THEN DO:
      ASSIGN ttWork.log-inicia-processo   = YES
             ttWork.log-finaliza-processo = NO.
   END.
   ELSE DO:
      ASSIGN ttWork.log-inicia-processo   = NO 
             ttWork.log-finaliza-processo = NO.
   END.

   ASSIGN vdoctar = TRIM(STRING(tt-tarefa-docto.id-docto)) + '/':U + TRIM(STRING(tt-tarefa-docto.id-tarefa)).
   
   DISPLAY vdoctar
      WITH FRAME Frame04.

   ASSIGN vDesLidos = TRIM(STRING(vQtdLeituras,'>>9':U)) + '/':U + TRIM(STRING(vQtdPalletCarga,'>>9':U)).
   
   DISPLAY vDesLidos
      WITH FRAME Frame04.

   IF vQtdLeituras >= vQtdPalletCarga AND vQtdLeituras <> 0 AND vQtdPalletCarga <> 0 THEN DO:
      ASSIGN vLogErro     = YES
             vLogFinaliza = YES.
      {bcp/bc9105.i "502" "Todos seriais j  encontram-se coletados (WMS)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:

   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro          = NO
          vLogControlaLogin = NO.

   /* VALIDA€AO USUµRIO */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
   END. 
   
   IF v2_cod_usuar_corren = '' THEN DO:

      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR UNDO LOGIN, LEAVE LOGIN
      ON QUIT UNDO LOGIN, LEAVE LOGIN
      ON STOP UNDO LOGIN, LEAVE LOGIN
      ON ENDKEY UNDO LOGIN, LEAVE LOGIN:
         RUN btb/btapi910za.p (INPUT INPUT FRAME frame01 ttWork.cod-usuario, 
                               INPUT INPUT FRAME frame01 vCod-Senha, 
                               OUTPUT TABLE tt-erros) NO-ERROR.        
      END. 
      
      IF CAN-FIND (FIRST tt-erros 
                   WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros
                      WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est ÿcorreta!(DC)"} 
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

   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135.
      RUN openQueryStatic IN wgbosc135 (INPUT "Main":U) NO-ERROR.
   END.

   /* Valida se usu rio tem permissÆo para executar a tarefa. */
   RUN validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                         INPUT 09).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Conferˆncia (WMS)"}
      RETURN ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   
   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK' THEN DO:
      Run getrowErrors In wgbosc079 (output Table RowErrors).
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.                                           
      ASSIGN vLogErro = YES.
   END.
   
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

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

   /* instancia as BOs de forma persistente */
   IF NOT VALID-HANDLE(wgbosc092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
   END.
   
   IF NOT VALID-HANDLE(wgbosc095) THEN DO:
      RUN scbo/bosc095.p PERSISTENT SET wgbosc095.
   END.

   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor In wgbosc092 (INPUT ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento e se est  ativo */
   RUN validaEquipamento In wgbosc092 (INPUT ttWork.cod-equipamento,
                                       OUTPUT vLogAtivo,
                                       OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.
   
   IF vlogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   /* Validacoes Frame 02 Fim    --- */
   ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario
          {&TempTable}.cod-coletor     = ttWork.cod-coletor
          {&TempTable}.cod-equipamento = ttWork.cod-equipamento.
           
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:

   ASSIGN vLogErro     = NO
          vLogCancela  = NO.

   /* Validacoes Frame 02 Fim    --- */
   IF INPUT FRAME Frame02 ttWork.opcao <> 1 AND
      INPUT FRAME Frame02 ttWork.opcao <> 2 AND
      INPUT FRAME Frame02 ttWork.opcao <> 3 THEN DO:
      {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}
      HIDE ALL.
      RETURN ERROR. 
   END.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:

   ASSIGN vLogErro     = NO
          vLogSai      = NO 
          vLogFinaliza = NO.

   IF NOT AVAIL tt-tarefa-docto THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
      RETURN ERROR.
   END.                     

   ASSIGN {&temptable}.cod-documento = STRING(tt-tarefa-docto.id-docto).

   ASSIGN {&temptable}.cod-tarefa = STRING(tt-tarefa-docto.id-tarefa)
          ttWork.cod-tarefa       = STRING(tt-tarefa-docto.id-tarefa).


   RUN doctoConferenciaEmProcesso IN wgbosc093 (INPUT  tt-tarefa-docto.cod-estabel,
                                                INPUT  tt-tarefa-docto.cod-local,
                                                INPUT {&TempTable}.cod-usuario,
                                                INPUT {&TempTable}.cod-documento,
                                                OUTPUT TABLE ttWm-conferencia-aux).

   /* atualiza estabelecimento e local para api */
   ASSIGN ttWork.cod-estabel = tt-tarefa-docto.cod-estabel
          ttWork.cod-local   = tt-tarefa-docto.cod-local.

   IF CAN-FIND(FIRST ttWm-conferencia-aux) THEN DO:
      FIND FIRST ttWm-conferencia-aux NO-LOCK NO-ERROR.
      ASSIGN ttWork.log-inicia-processo   = NO
             ttWork.log-finaliza-processo = NO
             vNrLeitura = ttWm-conferencia-aux.nr-leitura.
      {bcp/bc9105.i "401" "Conferˆncia em Processo (WMS)"}
   END. 
   ELSE DO:
      ASSIGN ttWork.log-inicia-processo   = Yes 
             ttWork.log-finaliza-processo = No
             vNrLeitura = 1.
   END.
   
   HIDE ALL NO-PAUSE.

   ASSIGN IDttwm-tarefa-docto = ROWID(tt-tarefa-docto).

   RUN getQtdAgrupadorCarga IN wgbosc074 (INPUT tt-tarefa-docto.cod-estabel,
                                          INPUT tt-tarefa-docto.cod-local,
                                          INPUT tt-tarefa-docto.id-docto,
                                          OUTPUT vQtdPalletCarga).

   EMPTY TEMP-TABLE tt-trans.
   
   EMPTY TEMP-TABLE tt-erro.

   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMEnt002':U
          tt-trans.detalhe  = 'Doc:':U + STRING(ttWork.cod-documento) + ';':U +
                              'Tar:':U + STRING(ttWork.cod-tarefa)    + ';':U +
                              'Est:':U + STRING(ttWork.cod-estabel)   + ';':U +
                              'Loc:':U + STRING(ttWork.cod-local).
          tt-trans.usuario = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.

   RUN verif_qtd_lida_reg IN wgbc9016f (INPUT TABLE tt-trans,
                                        OUTPUT vQtdLeituras).
   If vQtdLeituras >= vQtdPalletCarga AND vQtdLeituras <> 0 AND vQtdPalletCarga <> 0 THEN DO: 
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "502" "Todos seriais j  encontram-se coletados (DC)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.
      
   ASSIGN vLogErro = NO.
   
   HIDE ALL NO-PAUSE.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame04:

   EMPTY TEMP-TABLE tt-trans.
     
   EMPTY TEMP-TABLE tt-trans-filho.

   EMPTY TEMP-TABLE tt-erro.

   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.

   IF ttWork.num-serial = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "501" "Serial Invalido (DC)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   RUN emptyRowErrors IN wgbosc074.

   RUN validaEtiquetaDocto IN wgbosc074 (INPUT ttWork.cod-estabel,
                                         INPUT ttWork.cod-local,
                                         INPUT ttWork.cod-documento,
                                         INPUT ttWork.num-serial).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getRowErrors IN wgbosc074 (OUTPUT TABLE RowErrors) NO-ERROR.
      ASSIGN vLogErro = YES.
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.
   END.
   
   IF vLogErro = Yes THEN
      RETURN ERROR.

   RUN goToKey IN wgbosc074 (INPUT ttWork.num-serial).

   IF RETURN-VALUE = 'OK':U THEN DO:
      RUN getIntField IN wgbosc074(INPUT 'ind-sit-agrupador':U,
                                   OUTPUT vind-sit-agrupador ).
      IF vind-sit-agrupador = 1 THEN DO:
         /* nÆo ‚ serial e nao agrupador */
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "501" "Serial nÆo ‚ agrupador (WMS)"}
      END.
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

   ASSIGN {&TempTable}.num-serial = ttWork.num-serial.

   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMEnt002':U
          tt-trans.detalhe = 'Doc:':U + STRING(ttWork.cod-documento) + ';':U +
                             'Tar:':U + STRING(ttWork.cod-tarefa)    + ';':U +
                             'Est:':U + STRING(ttWork.cod-estabel)   + ';':U +
                             'Loc:':U + STRING(ttWork.cod-local).
          tt-trans.usuario = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.

   CREATE tt-trans-filho.
   ASSIGN tt-trans-filho.i-sequen-pai = 1
          tt-trans-filho.i-sequen     = 1    
          tt-trans-filho.num-versao   = 1
          tt-trans-filho.conteudo-xml = 'Col:':U + STRING(ttWork.cod-coletor)                   + ';':U + 
                                        'Equ:':U + String(ttWork.cod-equipamento)               + ';':U + 
                                        'Ini:':U + STRING(ttWork.log-inicia-processo)           + ';':U + 
                                        'Fin:':U + STRING(ttWork.log-finaliza-processo)         + ';':U + 
                                        'Ser:':U + STRING(ttWork.num-serial,'>>>>>>>>>>>>>>':U).

   RUN verif_serial IN wgbc9016f (INPUT TABLE tt-trans,
                                  INPUT TABLE tt-trans-filho).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "503" "Serial j  Coletado para este documento (DC)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   RUN gravaTransacao.

   RETURN RETURN-VALUE.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
***************************************************************************************************/
PROCEDURE gravatransacao:

   DEFINE VARIABLE vnrleitura_aux AS INTEGER NO-UNDO.

   ASSIGN vLogErro     = NO 
          vLogSai      = NO 
          vLogFinaliza = NO.

   RUN verif_inicio_tarefa IN wgbc9016f (INPUT TABLE tt-trans,
                                         INPUT TABLE tt-trans-filho).
   IF RETURN-VALUE <> 'OK':U THEN DO:    
      /* indica que est  iniciando a exec da tarefa */
      RUN iniciaTarefaDoctoConferencia In wgbosc095 (INPUT ttwork.cod-estabel,
                                                     INPUT ttwork.cod-local,
                                                     INPUT ttwork.cod-documento,
                                                     INPUT DECIMAL(ttwork.cod-tarefa),
                                                     INPUT ttwork.cod-usuario,
                                                     INPUT ttwork.cod-equipamento,
                                                     INPUT ttwork.cod-coletor,
                                                     OUTPUT vNrLeitura_aux).
   END.

   IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
      RUN bcp/bcapi001.p PERSISTENT SET wgbcapi001 (INPUT-OUTPUT TABLE tt-trans,
                                                    INPUT-OUTPUT TABLE tt-erro).
   END.

   RUN cria_reg_wms IN wgbcapi001 (INPUT 4,
                                   INPUT-OUTPUT TABLE tt-trans,
                                   INPUT-OUTPUT TABLE tt-trans-filho,
                                   INPUT-OUTPUT TABLE tt-erro).

   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO: 
      FOR EACH tt-erro:
         ASSIGN vLogSai = YES
                tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
         {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.
   ELSE DO:
      ASSIGN vQtdLeituras = vQtdLeituras + 1.

      {bcp/bc9105.i "901" "Serial Lido com Sucesso (DC)"}
      IF vQtdLeituras >= vQtdPalletCarga  THEN DO:
         
         EMPTY TEMP-TABLE tt-erro.
         
         RUN finaliza_conferencia IN wgbc9016f (INPUT TABLE tt-trans, OUTPUT TABLE tt-erro).
         
         FIND FIRST tt-erro NO-ERROR.
         
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN vLogFinaliza     = YES
                      vLogSai          = YES
                      tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
               {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
            END.
            IF vLogErro = YES THEN
               RETURN ERROR.
         END.
         ELSE DO:
            RUN conferencia_pre_api_wms IN wgbc9016f (INPUT-OUTPUT TABLE tt-trans,
                                                      INPUT-OUTPUT TABLE tt-erro).
            FIND FIRST tt-erro NO-ERROR.
            IF AVAIL tt-erro THEN DO: 
               FOR EACH tt-erro:
                  ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                  {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
               END.
            END.
            ELSE DO:
               ASSIGN vLogFinaliza = YES
                      vLogcancela  = YES.
               {bcp/bc9105.i "901" "Conferˆncia Finalizada com Sucesso (DC)"}
               RETURN ERROR. 
            END.
         END.
      END.
   END.

   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.

   RETURN 'NOK':U.
END PROCEDURE.

/* Procedure que busca a lista de tarefas p Conferˆncia */
PROCEDURE GetTasks:
   ASSIGN vLogCancela = NO
          vLogErro    = NO.

   EMPTY TEMP-TABLE tt-Tarefa-docto.

   CASE {&TempTable}.opcao:
      WHEN 1 THEN DO:
         ASSIGN vtiptarefa = 'Tarefas P£blicas'.
         RUN getAllTarefaDoctoAberta IN wgbosc095 (INPUT INTEGER(09),
                                                   INPUT '',                  
                                                   OUTPUT TABLE tt-tarefa-docto).
      END. 
      WHEN 2 THEN DO:
         ASSIGN vtiptarefa = 'Minhas Tarefas'.
         RUN getAllTarefaDoctoAberta IN wgbosc095 (INPUT INTEGER(09),
                                                   INPUT tt-recebe-wms.cod-usuario,  
                                                   OUTPUT TABLE tt-tarefa-docto).
      END. 
      WHEN 3 THEN DO:
         ASSIGN vtiptarefa = 'Meus Processos'.
         RUN getAllTarefaDoctoProcesso IN wgbosc095 (INPUT INTEGER(09),
                                                     INPUT tt-recebe-wms.cod-usuario,  
                                                     OUTPUT TABLE tt-tarefa-docto).
      END. 
   END CASE.
   RETURN 'OK':U.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
