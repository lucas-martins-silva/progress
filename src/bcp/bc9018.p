/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9018 2.00.00.025 } /*** "010025" 09/10/2025 11:26:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9018 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9018.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking WMS                      **
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
&global-define ProgramName BC9018
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{bcp/bc9018.i " "}
{bcp/bc9018.i1 "New"}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

CREATE ttWork.

DEFINE VARIABLE vnr-pedcli         AS CHARACTER FORMAT 'x(12)':U     INIT ''   NO-UNDO.
DEFINE VARIABLE vnome-abrev        AS CHARACTER FORMAT 'x(12)':U     INIT ''   NO-UNDO.
DEFINE VARIABLE vcod-item          AS CHARACTER FORMAT 'x(16)':U     INIT ''   NO-UNDO.
DEFINE VARIABLE vdes-item          AS CHARACTER FORMAT 'x(18)':U     INIT ''   NO-UNDO. 
DEFINE VARIABLE c-desc-item        AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE vcod-senha         AS CHARACTER FORMAT 'x(18)':U               NO-UNDO.
DEFINE VARIABLE l-menu-padrao      AS LOGICAL                        INIT YES  NO-UNDO.
DEFINE VARIABLE cod-estab-roteiriz LIKE ttWm-box-movto-idx-picking.cod-estabel NO-UNDO.
DEFINE VARIABLE cod-local-roteiriz LIKE ttWm-box-movto-idx-picking.cod-local   NO-UNDO.
DEFINE VARIABLE id-movto-roteiriz  LIKE ttWm-box-movto-idx-picking.id-movto    NO-UNDO.
DEFINE VARIABLE wgbcapiwms         AS HANDLE                                   NO-UNDO.  

DEFINE TEMP-TABLE tt-mostra-locais NO-UNDO
            FIELD num-seq           AS INTEGER
            FIELD des-local         AS CHARACTER FORMAT 'X(19)':U
            FIELD rowid-box-movto   AS ROWID
            INDEX ID num-seq.

DEFINE TEMP-TABLE tt-serial NO-UNDO
            FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
            FIELD id-movto             LIKE wm-movto-etiqueta.id-movto
            INDEX idx-serial  AS PRIMARY /*UNIQUE*/ id-etiqueta.

DEFINE QUERY qry-wm-box-movto FOR tt-mostra-locais.

DEFINE BROWSE brw-wm-box-movto QUERY qry-wm-box-movto NO-LOCK
         DISPLAY tt-mostra-locais.des-local
            WITH NO-BOX NO-LABELS SIZE 20 BY 2.5 NO-SCROLLBAR-VERTICAL.


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
                             'Est:'                                             At Row 07 Col 01          ~
                             ttWork.cod-estabel                                 At Row 07 Col 05 NO-LABEL          ~
                             'Loc:'                                             At Row 08 Col 01          ~
                             ttWork.cod-local                                   At Row 08 Col 05 NO-LABEL          ~
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Tarefas P£blicas'                             At Row 03 Col 01          ~
                             '2 - Minhas Tarefas'                               At Row 04 Col 01          ~
                             '3 - Tarefas Equipto'                              At Row 05 Col 01          ~
                             '4 - Meus Processos'                               At Row 06 Col 01          ~
                             'Op‡Æo:'                                           At Row 07 Col 01          ~
                              ttWork.opcao                                      At Row 07 Col 08 NO-LABEL ~

&global-define Frame02Repeat No
/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking WMS'                                      At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'Ped:'                                             AT ROW 05 COL 01          ~
                             vnr-pedcli                                         At Row 05 Col 06 No-label ~
                             'Cli:'                                             AT ROW 06 COL 01          ~
                             vnome-abrev                                        AT ROW 06 COL 06 NO-LABEL ~
                             'It:'                                              AT ROW 07 COL 01          ~
                             vcod-item                                          AT ROW 07 COL 03 NO-LABEL ~
                             vdes-item                                          AT ROW 08 COL 01 NO-LABEL ~
                             
&global-define Frame03Repeat YES
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento ~
                              ttWork.cod-estabel ~
                              ttWork.cod-local


&global-define Update02Fields ttwork.opcao

&global-define Update03Fields brw-wm-box-movto

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. Empty Temp-table tt-mostra-locais. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 

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
                            ON 'enter':U OF ttWork.cod-estabel IN Frame {&Frame01Name}             ~
                            DO:                                                                    ~
                                RUN piValidateScreen (INPUT "Estab").                              ~
                                IF RETURN-VALUE = "NOK" THEN DO:                                   ~
                                    View Frame frame01.                                            ~
                                    RETURN NO-APPLY.                                               ~
                                END.                                                               ~
                                APPLY 'entry':U TO ttWork.cod-local IN FRAME {&Frame01Name}.       ~
                                RETURN NO-APPLY.                                                   ~
                            END.                                                                   ~
                            ON 'enter':U OF ttWork.cod-local IN Frame {&Frame01Name}               ~
                            DO:                                                                    ~
                                RUN piValidateScreen (INPUT "Local").                              ~
                                IF RETURN-VALUE = "NOK" THEN DO:                                   ~
                                    View Frame frame01.                                            ~
                                    RETURN NO-APPLY.                                               ~
                                END.                                                               ~
                            END.                                                                   ~
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame03Name}        ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame03Name}        ~
                            DO:                                                                     ~
                                Find ttWm-box-movto-idx-picking                                                  ~
                                    Where Rowid(ttWm-box-movto-idx-picking) = tt-mostra-locais.rowid-box-movto   ~
                                           No-error.                                                             ~
                                If  Not Available ttWm-box-movto-idx-picking Then Return No-apply.               ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttWm-box-movto-idx-picking.cod-estabel,  ~
                                                                    Input ttWm-box-movto-idx-picking.cod-local,    ~
                                                                    Input ttWm-box-movto-idx-picking.id-docto,     ~
                                                                    Input ttWm-box-movto-idx-picking.num-seq-item, ~
                                                                    Output Table ttwm-docto-itens ).               ~
                                Find First ttwm-docto-itens.                                                                             ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item).  ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                                        ~
	                                RUN getCharField IN wgbosc044 (INPUT "des-item":U,                                                   ~
                                                                   OUTPUT c-desc-item).   ~
                                    ASSIGN vdes-item:SCREEN-VALUE   IN FRAME frame03 = TRIM(SUBSTRING(c-desc-item,1,18)).                ~
                                END.                                                                                                     ~
                                ELSE DO:                                                                                                 ~
	                                ASSIGN vdes-item:SCREEN-VALUE   IN FRAME frame03 = ''.                                               ~
                                END.                                                                                                     ~
                                ASSIGN vcod-item:SCREEN-VALUE   IN FRAME FRAMe03 = TRIM(ttwm-docto-itens.cod-item)                       ~
                                       vnr-pedcli:screen-value  In Frame frame03 = trim(ttWm-box-movto-idx-picking.nr-pedcli)            ~
                                       vnome-abrev:screen-value In Frame frame03 = trim(ttWm-box-movto-idx-picking.nome-abrev).          ~
                            END. ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1  wgbosc030
&global-define ActiveObject2  wgbosc032
&global-define ActiveObject3  wgbosc044
&global-define ActiveObject4  wgbosc079
&global-define ActiveObject5  wgbc9018f
&global-define ActiveObject6  wgbosc092
&global-define ActiveObject7  wgbosc096
&global-define ActiveObject8  wgbosc135
&global-define ActiveObject9  wgbosc038
&global-define ActiveObject10 wgbcapiwms

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
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
          ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                 ttWork.cod-coletor     = v_cod-coletor_corren
                 ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                 ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
   END.
   IF NOT VALID-HANDLE(wgbosc038) THEN DO:
      RUN scbo/bosc038.p PERSISTENT SET wgbosc038.
      RUN openQueryStatic IN wgbosc038 (INPUT "Main":U) NO-ERROR.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   ASSIGN vLogErro    = NO
          vLogCancela = NO
          vLogSai     = NO.

   IF v_cod_usuar_corren = '' THEN
      RETURN ERROR.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   ASSIGN vLogErro        = NO
          vLogCancela     = NO
          vLogEmProcesso  = NO.
   
   RUN GetTasks. // carrega ttWm-box-movto-idx-picking
   
   IF vLogerro = YES THEN
      RETURN ERROR. 
   
   IF NOT VALID-HANDLE(wgbosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR.
   END.
   
   EMPTY TEMP-TABLE tt-mostra-locais.
   
   ASSIGN vNumSeq = 0.
   
   wm-boxm:
   FOR EACH ttWm-box-movto-idx-picking
      WHERE ttWm-box-movto-idx-picking.ind-tipo-movto = 2
      BREAK BY ttWm-box-movto-idx-picking.nr-pedcli
            BY ttWm-box-movto-idx-picking.nome-abrev
            BY ttWm-box-movto-idx-picking.val-prioridade:
   
      /* Pegar Informacoes Box */
      RUN SetConstraintBoxes IN wgbosc030 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                           INPUT ttWm-box-movto-idx-picking.cod-local,
                                           INPUT ttWm-box-movto-idx-picking.id-box,
                                           INPUT ttWm-box-movto-idx-picking.id-box).
      
      RUN openQueryStatic IN wgbosc030 (INPUT 'Boxes':U).
      
      RUN getBatchRecords IN wgbosc030 (INPUT ?,
                                        INPUT NO,
                                        INPUT ?,
                                        OUTPUT vNumCont,
                                        OUTPUT TABLE ttwm-box).
      
      FIND FIRST ttwm-box NO-ERROR.      
      IF NOT AVAIL ttwm-box THEN
         NEXT wm-boxm.
      
      ASSIGN vNumSeq = vNumSeq + 1.
      
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq         = vNumSeq
             tt-mostra-locais.des-local       = ttwm-box.cod-bloco            + '/':U +
                                                ttwm-box.cod-rua              + '/':U +
                                                ttwm-box.cod-nivel            + '/':U +
                                                ttwm-box.cod-coluna           + '/':U +
                                                IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'.
             tt-mostra-locais.rowid-box-movto = ROWID(ttWm-box-movto-idx-picking).                                                                                   
      
      
      IF ttWm-box-movto-idx-picking.log-pend-ressup AND ttWork.opcao = 4 THEN
         ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.   
   End.
   
   FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-mostra-locais THEN DO:
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq   = 999
             tt-mostra-locais.des-local = 'NÆo existem tarefas (WMS)'.
   END.
   
   OPEN QUERY qry-wm-box-movto
     FOR EACH tt-mostra-locais
           BY tt-mostra-locais.num-seq
           BY tt-mostra-locais.des-local.
   
   APPLY 'VALUE-CHANGED':U TO brw-wm-box-movto IN FRAME {&Frame03Name}.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
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
                               OUTPUT TABLE tt-erros) NO-ERROR.        
      END. 
      IF CAN-FIND(FIRST tt-erros
                  WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         Assign vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND(FIRST tt-erros
                     WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            Assign vLogErro           = YES
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
   
   /* executa-se neste ponto devido ao login */
   IF NOT VALID-HANDLE(wgbosc030) THEN DO:
      RUN scbo/bosc030.p Persistent Set wgbosc030 NO-ERROR.
      RUN openQueryStatic In wgbosc030 (Input "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc096) THEN DO:
      RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
      RUN openQueryStatic IN wgbosc096 (Input "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc032) THEN DO:
      RUN scbo/bosc032.p PERSISTENT SET wgbosc032 NO-ERROR.
      RUN openQueryStatic IN wgbosc032 (Input "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
      RUN openQueryStatic IN wgbosc044 (Input "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135.
      RUN openQueryStatic IN wgbosc135 (INPUT "Main":U) NO-ERROR.
   END.
   
   /* Valida se usu rio tem permissÆo para executar a tarefa. */
   RUN validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                         INPUT 07).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Picking (WMS)"}
      RETURN ERROR.
   END.
   
   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.                                           
   End.
   
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu rio sem permissÆo para utilizar Coletor (WMS)"}
      RETURN ERROR.
   END.
   
   
   IF ttWork.cod-coletor = '' THEN DO:
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
   
   RUN validaEquipColetor IN wgbosc092(INPUT ttWork.cod-coletor,
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
   
   RUN validaEquipTransportador IN wgbosc092  (INPUT ttWork.cod-equipamento,
                                               OUTPUT vCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Inv lido (WMS)"}
   END.
   
   IF vLogAtivo = NO THEN DO:
      Assign vLogErro = YES.
      {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF VALID-HANDLE (wgbosc038) THEN DO:
      DELETE OBJECT wgbosc038.
      ASSIGN wgbosc038 = ?.
   END.
      
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
   ASSIGN vLogErro = NO.
   IF INPUT FRAME Frame02 ttWork.opcao <> 1
      AND INPUT FRAME Frame02 ttWork.opcao <> 2
      AND INPUT FRAME Frame02 ttWork.opcao <> 3
      AND INPUT FRAME Frame02 ttWork.opcao <> 4 THEN DO:
      {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}
      HIDE ALL.
      RETURN ERROR. 
   END.
   
   ASSIGN {&TempTable}.opcao  = INPUT FRAME Frame02 ttWork.opcao.
   
   ASSIGN vLogIniciado = NO.
   
   ASSIGN ttWork.qtd-embal-lidas  = 0
          ttWork.des-seriais      = ''
          ttWork.num-box-lido     = 0
          ttWork.num-doca         = 0
          ttWork.qtd-embal-lidas  = 0
          ttWork.qtd-item-digit   = 0.
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
   
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
      RETURN ERROR.
   END.                     
   
   IF ttWork.opcao = 4 THEN DO:
      ASSIGN vLogEmProcesso = YES.
   END.
      
   ASSIGN vLogErro = NO.
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido (WMS)"}
      RETURN ERROR.
   END.
   
   HIDE ALL.
   
   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.
   
   FIND FIRST ttWork NO-ERROR.
   
   ASSIGN ttWork.qtd-embal-lidas = 0. 
   
   HIDE ALL NO-PAUSE.
   ASSIGN cod-estab-roteiriz = ttWm-box-movto-idx-picking.cod-estabel
          cod-local-roteiriz = ttWm-box-movto-idx-picking.cod-local
          id-movto-roteiriz  = ttWm-box-movto-idx-picking.id-movto.
   RUN bcp/bc9018h.p (INPUT ROWID(ttWm-box-movto-idx-picking)).
   
   HIDE ALL NO-PAUSE.
   IF ttWork.opcao = 2 THEN DO:
      RUN wmp/wm9043.p (INPUT cod-estab-roteiriz,
                        INPUT cod-local-roteiriz,
                        INPUT id-movto-roteiriz).
   END.
   
   FIND FIRST ttWork NO-ERROR.
   RETURN RETURN-VALUE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure ir  obter a lista das tarefas para a transa‡Æo de picking                       **
****************************************************************************************************/
PROCEDURE GetTasks:
   ASSIGN vLogCancela  = NO
          vLogErro     = NO
          INPUT FRAME Frame01 ttWork.cod-estabel
          INPUT FRAME Frame01 ttWork.cod-local.
   
   EMPTY TEMP-TABLE ttWm-box-movto-idx-picking.
   
   CASE ttWork.opcao:
      WHEN 1 THEN DO:
         RUN getNewMovtoTarefasPublicasPicking IN wgbosc096 ( INPUT ttWork.cod-equipamento,
                                                              INPUT vCodTipoEquip,
                                                              INPUT 07,           
                                                              INPUT NO,
                                                              INPUT YES,
                                                              INPUT ttWork.cod-estabel,
                                                              INPUT ttWork.cod-local,
                                                              OUTPUT TABLE ttWm-box-movto-idx-picking).
      END. 
      WHEN 2 THEN DO:
         RUN getNewMovtoTarefasUsuarioPicking IN wgbosc096 ( INPUT ttWork.cod-usuario,
                                                             INPUT ttWork.cod-equipamento,
                                                             INPUT vCodTipoEquip,
                                                             INPUT 07,           
                                                             INPUT NO,
                                                             INPUT YES,
                                                             INPUT ttWork.cod-estabel,
                                                             INPUT ttWork.cod-local,
                                                             OUTPUT TABLE ttWm-box-movto-idx-picking).
      END.  
      WHEN 3 THEN DO:
         RUN getNewMovtoTarefasEquipPicking IN wgbosc096 ( INPUT ttWork.cod-usuario,
                                                           INPUT ttWork.cod-equipamento,
                                                           INPUT vCodTipoEquip,
                                                           INPUT 07,           
                                                           INPUT NO,
                                                           INPUT YES,
                                                           INPUT ttWork.cod-estabel,
                                                           INPUT ttWork.cod-local,
                                                           OUTPUT TABLE ttWm-box-movto-idx-picking).
      END. 
      WHEN 4 THEN DO:
         RUN getNewMovtoTarefasIniciadasPicking IN wgbosc096 ( INPUT ttWork.cod-usuario,
                                                               INPUT ttWork.cod-equipamento,
                                                               INPUT vCodTipoEquip,
                                                               INPUT 07,           
                                                               INPUT NO,
                                                               INPUT YES,
                                                               INPUT ttWork.cod-estabel,
                                                               INPUT ttWork.cod-local,
                                                               OUTPUT TABLE ttWm-box-movto-idx-picking).
      END.  
   END CASE.
   
   RETURN 'OK':U.
END PROCEDURE.


PROCEDURE piValidateScreen:
   DEFINE INPUT PARAMETER pTpValidacao AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE vnom-estabel        AS CHARACTER    NO-UNDO.
   DEFINE VARIABLE vnom-local          AS CHARACTER    NO-UNDO.

   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO
          INPUT FRAME Frame01 ttWork.cod-estabel
          INPUT FRAME Frame01 ttWork.cod-local.

   IF pTpValidacao = "Estab" THEN DO:
      RUN getnomestabel IN wgbosc038 (INPUT ttWork.cod-estabel,
                                      OUTPUT vnom-estabel).
    
      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "201" "Estabelecimento Inv lido (WMS)"}
         RETURN "NOK":U.
      END.
   END.

   IF pTpValidacao = "Local" THEN DO:
      RUN getLocalEstab IN wgbosc038 (INPUT ttWork.cod-estabel,
                                      INPUT ttWork.cod-local).

      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "203" "Local Inv lido (WMS)"}
         RETURN "NOK":U.
      END.
   END.
END.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
