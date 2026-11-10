/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9020 2.00.00.025 } /*** "010025" 18/03/2024 10:59:59 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9020 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9020.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Ressuprimento WMS                **
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
**                        Ex: tt-ressup-wms.                                                      **
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
&global-define ProgramName BC9020
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-ressup-wms
{bcp/bc9020.i " "}
{bcp/bc9020.i1 "New"}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

CREATE ttWork.

DEFINE TEMP-TABLE tt-mostra-locais NO-UNDO
            FIELD num-seq           AS INTEGER
            FIELD des-local         AS CHARACTER FORMAT 'X(19)'
            FIELD rowid-box-movto   AS ROWID
            INDEX ID num-seq.

DEFINE QUERY qry-wm-box-movto FOR tt-mostra-locais.

DEFINE BROWSE brw-wm-box-movto QUERY qry-wm-box-movto NO-LOCK
      DISPLAY tt-mostra-locais.des-local
         WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

DEFINE VARIABLE vCodItemCorrente        AS CHARACTER FORMAT 'x(16)':U   INIT ''  NO-UNDO.
DEFINE VARIABLE vDesItemCorrente        AS CHARACTER FORMAT 'x(18)':U   INIT ''  NO-UNDO.
DEFINE VARIABLE vLogEmProcesso          AS LOGICAL                      INIT NO  NO-UNDO.

DEFINE NEW SHARED VARIABLE vLogControla       AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogEmProcesso-aux AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vEsc               AS LOGICAL                INIT NO  NO-UNDO.


DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                      INIT NO  NO-UNDO.

DEFINE VARIABLE wgbcapiwms              AS HANDLE                        NO-UNDO. 

DEFINE VARIABLE vCodSenha AS CHARACTER FORMAT 'x(18)':U NO-UNDO.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Ressuprimento WMS'                                At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             At Row 04 Col 01          ~
                             vCodSenha                                          At Row 04 Col 05 No-label FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Ressuprimento WMS'        At Row 01 Col 01          ~
                             '--------------------':U   At Row 02 Col 01          ~
                             '1 - P£blicas'             At Row 03 Col 01          ~
                             '2 - Meu Usu rio'          At Row 04 Col 01          ~
                             '3 - Meu Equipamento'      At Row 05 Col 01          ~
                             'Op‡Æo:'                   At Row 06 Col 01          ~
                              ttWork.cod-opcao          At Row 06 Col 12 No-Label
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Ressuprimento WMS'                                At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             vCodItemCorrente                                   At Row 07 Col 01 No-label ~
                             vDesItemCorrente                                   At Row 08 Col 01 No-label ~
&global-define Frame03Repeat YES

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                                  ~
               ttWork.cod-usuario  WHEN ttWork.cod-usuario = ''~
               vCodSenha           WHEN ttWork.cod-usuario = ''~
               ttWork.cod-coletor ~
               ttWork.cod-equipamento 

&global-define Update02Fields ttWork.cod-opcao

&global-define Update03Fields brw-wm-box-movto

/************************************************************/

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
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame03Name}        ~
                            DO:                                                                     ~
                               Apply 'Go':U To This-procedure.                                      ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame03Name}        ~
                            DO:                                                                     ~
                                Find ttwm-box-movto                                                 ~
                                    Where ttWm-box-movto.r-rowid = tt-mostra-locais.rowid-box-movto ~
                                           No-error.                                                ~
                                If  Not Available ttwm-box-movto Then DO:                           ~
                                    ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame03 = ""      ~
                                           vDesItemCorrente:SCREEN-VALUE IN FRAME frame03 = "".     ~
                                    Return No-apply.                                                ~
                                END.                                                                ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttwm-box-movto.cod-estabel, ~
                                                                    Input ttwm-box-movto.cod-local,   ~
                                                                    Input ttwm-box-movto.id-docto,    ~
                                                                    Input ttwm-box-movto.num-seq-item,~
                                                                    Output Table ttwm-docto-itens ).  ~
                                Find First ttwm-docto-itens.                                          ~
                                ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame03 = ttwm-docto-itens.cod-item. ~
                                RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).                                 ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item).                        ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                  ~
                                   RUN getCharField IN wgbosc044 (INPUT "des-item":U,                              ~
                                                                  OUTPUT vDesItemCorrente).                        ~
                                   ASSIGN vDesItemCorrente:SCREEN-VALUE IN FRAME Frame03 = vDesItemCorrente.       ~
                                END.                                                                               ~
                                ELSE                                                                               ~
                                   ASSIGN vDesItemCorrente:SCREEN-VALUE IN FRAME Frame03 = "".                     ~
                            END.                                                                                   ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                Return 'ESC'.           ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                Return 'ESC'.           ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame03 ~
                            DO:                         ~
                                Return 'ESC'.           ~
                            END.                        

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc032
&global-define ActiveObject3 wgbosc038
&global-define ActiveObject4 wgbosc039
&global-define ActiveObject5 wgbosc044
&global-define ActiveObject6 wgbosc074
&global-define ActiveObject7 wgbosc092
&global-define ActiveObject8 wgbosc096
&global-define ActiveObject9 wgbosc079
&global-define ActiveObject10 wgbosc135
&global-define ActiveObject11 wgbosc098
&global-define ActiveObject12 wgbosc172
&global-define ActiveObject13 wgbcapiwms
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
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vCodSenha:BLANK IN FRAME Frame01                 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vCodSenha                                        = '****************':U 
             vCodSenha:SCREEN-VALUE IN FRAME frame01          = '****************':U. 
      IF v_cod-coletor_corren     <> '' AND 
          v_cod-equipamento_corren <> '' THEN DO:
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
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   IF v_cod_usuar_corren = '' THEN
      RETURN ERROR.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   IF vLogEmProcesso = YES AND vLogEmProcesso-aux = NO THEN DO:
      RUN inicializaTarefaMovtoNOK IN wgbosc096(INPUT ttwm-box-movto.id-docto,      
                                                INPUT 04,                             
                                                INPUT ttWork.cod-usuario,             
                                                INPUT ttWork.cod-equipamento,         
                                                INPUT ttWork.cod-coletor,             
                                                INPUT ttwm-box-movto.id-movto,        
                                                INPUT ttwm-box-movto.num-seq-item). 
      RUN EmptyRowErrors IN wgbosc074.
      RUN getRowErrors IN wgbosc074 (OUTPUT TABLE RowErrors) NO-ERROR.
      FOR EACH RowErrors:
         HIDE ALL.
         RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
         HIDE ALL.
      END.
   
      IF CAN-FIND( FIRST rowErrors) THEN DO:
         ASSIGN vLogErro = YES.
         VIEW FRAME frame04.                               
         RETURN ERROR.
      END.
   
      ASSIGN vLogEmProcesso = NO.
   END.
   
   ASSIGN vLogErro    = NO
          vLogCancela = NO.
   
   RUN GetTasks.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   EMPTY TEMP-TABLE tt-mostra-locais.
   
   ASSIGN vNumSeq = 0.
   
   wm-boxm:
   FOR EACH ttwm-box-movto
      WHERE ttwm-box-movto.ind-tipo-movto = 2
         BY ttwm-box-movto.val-prioridade:
   
      /* Pegar Informacoes Box */
      RUN SetConstraintBoxes IN wgbosc030(INPUT ttwm-box-movto.cod-estabel,
                                          INPUT ttwm-box-movto.cod-local,
                                          INPUT ttwm-box-movto.id-box,
                                          INPUT ttwm-box-movto.id-box).
   
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
                                                IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
             tt-mostra-locais.rowid-box-movto = ttwm-box-movto.r-rowid.
   END.
   
   FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-mostra-locais THEN DO:
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq   = 999
             tt-mostra-locais.des-local = 'Sem tarefas ou Equipamento sem acesso (WMS).'.
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
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado. (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta. (DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
         ELSE DO:
             IF CAN-FIND (FIRST tt-erros) THEN DO:
               {bcp/bc9105.i "202" "Problemas na autentica‡Æo do usu rio. (DC)"} 
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
   RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
   RUN scbo/bosc032.p PERSISTENT SET wgbosc032 NO-ERROR.
   RUN scbo/bosc074.p PERSISTENT SET wgbosc074 NO-ERROR.
   RUN scbo/bosc038.p PERSISTENT SET wgbosc038 NO-ERROR.
   RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
   RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
   RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
   
   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135 NO-ERROR.
   END.
   
   RUN scbo/bosc098.p PERSISTENT SET wgbosc098 NO-ERROR.
   RUN scbo/bosc172.p PERSISTENT SET wgbosc172 NO-ERROR.
   
   {bcp/bc9017.i1 ttWork.cod-usuario}
   IF vLogOk = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu rio Inv lido. (DC)"}
      RETURN ERROR.
   END.
   
   /* Valida se usuÿrio tem permiss’o para executar a tarefa. */
   RUN validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                         INPUT 04).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Ressuprimento. (WMS)"}
      RETURN ERROR.
   END.
   
   /* Valida existˆncia do usu rio no WMS e retorna se ele tem ou nÆo permissÆo para utilizar coletor e aprovar faturas. */
   RUN validaUsuario IN wgbosc079 (INPUT ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu rio Inv lido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "102" "Usu rio sem permissÆo para utilizar Coletor. (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida se existe equipamento, se ‚ do tipo coletor e se est  ativo */
   RUN validaEquipColetor IN wgbosc092  (INPUT ttWork.cod-coletor,
                                         OUTPUT vCodTipoEquip,
                                         OUTPUT vLogAtivo,
                                         OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inativo. (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida se existe equipamento, se ‚ do tipo transportador e se est  ativo */
   RUN validaEquipTransportador IN wgbosc092  (INPUT ttWork.cod-equipamento,
                                               OUTPUT vCodTipoEquip,
                                               OUTPUT vLogAtivo,
                                               OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipto Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipto Inativo. (WMS)"}
      RETURN ERROR.
   END.
   
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
   ASSIGN vLogErro = NO.

   IF INPUT FRAME Frame02 ttWork.cod-opcao < 1 OR INPUT FRAME Frame02 ttWork.cod-opcao > 3 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "As op‡äes dispon¡veis sÆo 1, 2 e 3. (DC)"}
   END.
   
   
   ASSIGN vLogIniciado = NO.   
   ASSIGN ttWork.qtd-embal-lidas  = 0
          ttWork.des-seriais      = ''.   
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
   /* Validacoes Frame 03 Inicio --- */
   
   ASSIGN vLogErro = NO.
   
   IF NOT AVAIL ttwm-box-movto THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movto Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   RUN getInfoDoctoItens IN wgbosc096 (INPUT ttwm-box-movto.cod-estabel, 
                                       INPUT ttwm-box-movto.cod-local,   
                                       INPUT ttwm-box-movto.id-docto,    
                                       INPUT ttwm-box-movto.num-seq-item, 
                                       OUTPUT TABLE ttwm-docto-itens). 
   
   FIND FIRST ttwm-docto-itens NO-ERROR.  
   
   IF vLogEmProcesso = NO THEN DO:
      RUN inicializaTarefaMovtoOK IN wgbosc096 (INPUT ttwm-box-movto.id-docto,
                                                INPUT 04,     
                                                INPUT ttWork.cod-usuario,              
                                                INPUT ttWork.cod-equipamento,          
                                                INPUT ttWork.cod-coletor,              
                                                INPUT ttwm-box-movto.id-movto,         
                                                INPUT ttwm-box-movto.num-seq-item).   
      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Movto Expirou. (WMS)"}
         RETURN ERROR.
      END.   
      ASSIGN vLogEmProcesso = YES.
   END.
   ASSIGN ttwork.num-tempo-inicio = TIME
          ttwork.des-seriais      = "".
   
   HIDE ALL.
   RUN bcp/bc9020f.p (INPUT ROWID(ttwm-box-movto)).
   FIND FIRST ttWork NO-ERROR.
   HIDE ALL.
   RETURN RETURN-VALUE.
END PROCEDURE.

PROCEDURE GetTasks:
   EMPTY TEMP-TABLE ttWm-box-movto.
   ASSIGN vLogErro = NO.

   CASE ttWork.cod-opcao:
      WHEN 1 THEN DO:
          RUN getMovtosTarefasAbertasRessup IN wgbosc096 (INPUT vCodTipoEquip,
                                                          INPUT 04,
                                                          INPUT "",           
                                                          INPUT ttWork.cod-equipamento,
                                                          OUTPUT TABLE ttWm-box-movto).
      END.
      WHEN 2 THEN DO:
          RUN getMovtosTarefasAbertasRessup IN wgbosc096 (INPUT vCodTipoEquip,
                                                          INPUT 04,
                                                          INPUT ttWork.cod-usuario,
                                                          INPUT ttWork.cod-equipamento,
                                                          OUTPUT TABLE ttWm-box-movto).
      END.
      WHEN 3 THEN DO:
          RUN getMovtosTarefasAbertasRessup IN wgbosc096 (INPUT vCodTipoEquip,
                                                          INPUT 04,
                                                          INPUT ttWork.cod-usuario,
                                                          INPUT ttWork.cod-equipamento,
                                                          OUTPUT TABLE ttWm-box-movto).
      END.
   END CASE.

   RETURN 'OK':U.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
