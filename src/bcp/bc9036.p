/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9036 2.00.00.011 } /*** "010011" 11/07/2024 13:53:24 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9036 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9036.p                                                                  **
**                                                                                         **
**   Versao....: 1.00.00.000 - Agosto/2006                                                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para a Transacao de Conferˆncia de Embarque        **
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
&if '{&mgscm_version}' >= '2.04' &then

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9036

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-conferencia-embarque-wms-bc

{bcp/bc9036.i " "}
{bcp/bc9036.i1   }  /* Def Variaveis Padroes Produto */
{utp/utapi009.i  }  /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

ASSIGN vQtdTotalLeituras  = 0
       vQtdLeiturasFeitas = 0.

/**************************************************************************************************/
DEFINE VARIABLE iTipoConf      AS INTEGER FORMAT '>' NO-UNDO.
DEFINE VARIABLE l-esc-etiqueta AS LOGICAL INIT NO    NO-UNDO.
DEFINE VARIABLE l-conferen-ok  AS LOGICAL INIT NO    NO-UNDO.
DEFINE VARIABLE l-log-packing  AS LOGICAL            NO-UNDO.
DEFINE VARIABLE r-rowid-tabela AS ROWID              NO-UNDO.
DEFINE VARIABLE hBosc156       AS HANDLE             NO-UNDO.
DEFINE VARIABLE wgbosc000      AS HANDLE             NO-UNDO.
DEFINE VARIABLE wgbcapiwms     AS HANDLE             NO-UNDO. 

DEFINE VARIABLE c-cod-estabel     LIKE wm-docto.cod-estabel               NO-UNDO.               
DEFINE VARIABLE c-cod-local       LIKE wm-docto.cod-local                 NO-UNDO.
DEFINE VARIABLE c-id-docto        LIKE wm-tarefa-docto.id-docto           NO-UNDO.
DEFINE VARIABLE c-nr-pedcli       LIKE wm-tarefa-resumo-pedido.nr-pedcli  NO-UNDO.
DEFINE VARIABLE c-cod-equipamento LIKE wm-tarefa-docto.cod-equipamento    NO-UNDO.
DEFINE VARIABLE c-cod-coletor     LIKE wm-tarefa-docto.cod-coletor        NO-UNDO.
DEFINE VARIABLE c-nome-abrev      LIKE wm-tarefa-resumo-pedido.nome-abrev NO-UNDO.
DEFINE VARIABLE l-menu-padrao     AS LOGICAL INITIAL YES                  NO-UNDO.

/**************************************************************************************************/
DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
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
       nr-leitura  ASC
       id-docto    ASC 
       cod-usuario ASC.

DEFINE TEMP-TABLE tt-tarefa-docto-emb NO-UNDO
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
    FIELD num-docto               LIKE wm-docto.num-docto
    FIELD cod-estabel             LIKE wm-docto.cod-estabel
    FIELD cod-local               LIKE wm-docto.cod-local
    FIELD qtd-leituras            AS INTEGER
    FIELD cdd-embarq              LIKE wm-pedidos.cdd-embarq
    FIELD r-rowid                 AS ROWID.

DEFINE TEMP-TABLE tt-tarefa-resumo-pedido-emb NO-UNDO
    FIELD cod-estabel               LIKE wm-tarefa-resumo-pedido.cod-estabel
    FIELD cod-local                 LIKE wm-tarefa-resumo-pedido.cod-local
    FIELD id-docto                  LIKE wm-tarefa-resumo-pedido.id-docto
    FIELD cdd-embarq                LIKE wm-tarefa-resumo-pedido.cdd-embarq
    FIELD nr-resumo                 LIKE wm-tarefa-resumo-pedido.nr-resumo
    FIELD nr-pedcli                 LIKE wm-tarefa-resumo-pedido.nr-pedcli
    FIELD nome-abrev                LIKE wm-tarefa-resumo-pedido.nome-abrev
    FIELD nr-pedido                 LIKE wm-tarefa-resumo-pedido.nr-pedido
    FIELD id-tarefa                 LIKE wm-tarefa-resumo-pedido.id-tarefa
    FIELD cod-tarefa                LIKE wm-tarefa-resumo-pedido.cod-tarefa
    FIELD cod-usuario               LIKE wm-tarefa-resumo-pedido.cod-usuario
    FIELD cod-equipamento           LIKE wm-tarefa-resumo-pedido.cod-equipamento
    FIELD cod-coletor               LIKE wm-tarefa-resumo-pedido.cod-coletor
    FIELD cdn-tipo-equipamento      LIKE wm-tarefa-resumo-pedido.cdn-tipo-equipamento
    FIELD ind-status-tarefa-itens   LIKE wm-tarefa-resumo-pedido.ind-status-tarefa-itens
    FIELD dt-inicio-tarefa          LIKE wm-tarefa-resumo-pedido.dt-inicio-tarefa
    FIELD hr-inicio-tarefa          LIKE wm-tarefa-resumo-pedido.hr-inicio-tarefa
    FIELD dt-fim-tarefa             LIKE wm-tarefa-resumo-pedido.dt-fim-tarefa
    FIELD hr-fim-tarefa             LIKE wm-tarefa-resumo-pedido.hr-fim-tarefa
    FIELD val-prioridade            LIKE wm-tarefa-resumo-pedido.val-prioridade
    FIELD log-itens-packing         LIKE wm-tarefa-resumo-pedido.log-itens-packing
    FIELD qtd-leituras              AS INTEGER
    FIELD r-rowid                   AS ROWID.

DEFINE TEMP-TABLE tt-tarefa-resumo-pedido-emb-aux NO-UNDO LIKE tt-tarefa-resumo-pedido-emb.

DEFINE TEMP-TABLE RowErrors NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER 
    FIELD ErrorDescription AS CHARACTER  
    FIELD ErrorParameters  AS CHARACTER  
    FIELD ErrorType        AS CHARACTER  
    FIELD ErrorHelp        AS CHARACTER  
    FIELD ErrorSubType     AS CHARACTER.

/**************************************************************************************************/
DEFINE QUERY qry-tarefa-docto FOR tt-tarefa-docto-emb.

DEFINE BROWSE brw-tarefa-docto QUERY qry-tarefa-docto NO-LOCK
      DISPLAY tt-tarefa-docto-emb.cdd-embarq  FORMAT '>>>>>>>>>>>>>>>9'   LABEL "Embarque"
              tt-tarefa-docto-emb.id-docto    FORMAT '>>>>>>>>9' LABEL "Docto"
              tt-tarefa-docto-emb.id-tarefa   FORMAT '>>>>>>9'   LABEL "Tarefa"
      WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

DEFINE QUERY qry-tarefa-ped FOR tt-tarefa-resumo-pedido-emb.

DEFINE BROWSE brw-tarefa-ped QUERY qry-tarefa-ped NO-LOCK
      DISPLAY tt-tarefa-resumo-pedido-emb.nr-pedcli   FORMAT 'x(6)'      LABEL "Pedido"
              tt-tarefa-resumo-pedido-emb.nome-abrev  FORMAT 'x(12)'     LABEL "Cliente"
              tt-tarefa-resumo-pedido-emb.cdd-embarq  FORMAT '>>>>>>>>>>>>>>>9'     LABEL "Embarque"
              tt-tarefa-resumo-pedido-emb.id-docto    FORMAT '>>>>>>>>9' LABEL "Docto"
              tt-tarefa-resumo-pedido-emb.id-tarefa   FORMAT '>>>>>>9'   LABEL "Tarefa"
      WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.


/***************************************** Frames Inicio ******************************************/
/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 

/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Conferˆncia Embarque'                             At Row 01 Col 01          ~
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

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Conferˆncia Embarque'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Tarefas P£blicas'                             At Row 03 Col 01          ~
                             '2 - Minhas Tarefas  '                             At Row 04 Col 01          ~
                             '3 - Meus Processos  '                             At Row 05 Col 01          ~
                             'Op‡Æo:              '                             At Row 07 Col 01          ~
                              ttWork.opcao                                      At Row 07 Col 08 No-Label

&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Conferˆncia Embarque'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-tarefa-docto                                   At Row 03 Col 01          ~
                             vDesDocumento                                      At Row 08 Col 01 No-label
&global-define Frame03Repeat NO

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Conferˆncia Embarque'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Por Embarque    '                             At Row 03 Col 01          ~
                             '2 - Por Pedido      '                             At Row 04 Col 01          ~
                             'Op‡Æo:              '                             At Row 07 Col 01          ~
                              iTipoConf                                         At Row 07 Col 08 No-Label

&global-define Frame04Repeat NO

/* Definicao da Frame05 ---                                 */
&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Conferˆncia Embarque'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-tarefa-ped                                     At Row 03 Col 01          ~
                             vDesDocumento                                      At Row 08 Col 01 No-label
&global-define Frame05Repeat NO

/* Definicao da Frame06 ---                                 */
&global-define Frame06Name   Frame06
&global-define Frame06Defs   'Conferˆncia Embarque'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Docto/Tarefa:'                                    AT ROW 03 COL 01          ~
                             vdoctar                                            AT ROW 04 COL 01 NO-LABEL ~
                             'Etiqueta Packing:'                                At Row 05 Col 01          ~
                             ttWork.num-etiqueta-packing                        At Row 06 Col 01 No-label ~
                             'Leitura:'                                         At Row 07 Col 01          ~
                             vDesLidos                                          At Row 07 Col 10 No-label
&global-define Frame06Repeat YES 

/**************************************************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento

&global-define Update02Fields ttWork.opcao     

&global-define Update03Fields brw-tarefa-docto 

&global-define Update04Fields iTipoConf

&global-define Update05Fields brw-tarefa-ped

&global-define Update06Fields ttWork.num-etiqueta-packing

/**************************************************************************************************/
/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerBeforeFrame05 Run InicializaCamposFrame05.
&global-define TriggerBeforeFrame06 Run InicializaCamposFrame06.

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerAfterFrame04  Run GravaCamposFrame04.  
&global-define TriggerAfterFrame05  Run GravaCamposFrame05.
&global-define TriggerAfterFrame06  Run GravaCamposFrame06.  

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                      ~
    ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name}                         ~
                            DO:                                                    ~
                                IF v_cod-coletor_corren     <> '' AND              ~
                                   v_cod-equipamento_corren <> '' THEN DO:         ~
                                    IF l-menu-padrao = YES THEN DO:                ~
                                        ASSIGN l-menu-padrao = NO.                 ~
                                        APPLY "Enter":U TO ttWork.cod-equipamento IN FRAME {&Frame01Name}.  ~
                                    END.                                           ~
                                    ELSE DO:                                       ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}.        ~
                                    END.                                           ~
                                    RETURN NO-APPLY.                               ~
                                END.                                               ~
                            END.                                                   ~
    ON "RETURN":U OF brw-tarefa-docto IN FRAME {&Frame03Name} DO:                                ~
        APPLY "GO":U TO THIS-PROCEDURE.                                                          ~
    END.                                                                                         ~
    ON "VALUE-CHANGED":U OF brw-tarefa-docto IN FRAME {&Frame03Name} DO:                         ~
        IF AVAIL tt-tarefa-docto-emb THEN                                                        ~
            ASSIGN ttWork.id-docto = tt-tarefa-docto-emb.id-docto                                ~
                   vDesDocumento = "Doc:":U + STRING(tt-tarefa-docto-emb.num-docto).             ~
    END.                                                                                         ~
    /* Browse pedidos */                                                                         ~
    ON "VALUE-CHANGED":U OF brw-tarefa-ped IN FRAME {&Frame05Name} DO:                           ~
        ASSIGN l-conferen-ok = NO.                                                               ~
    END.                                                                                         ~
    ON "RETURN":U OF brw-tarefa-ped IN FRAME {&Frame05Name} DO:                                  ~
        APPLY "GO":U TO THIS-PROCEDURE.                                                          ~
    END.                                                                                         ~
    ON "ENTRY":U OF brw-tarefa-ped IN FRAME {&Frame05Name} DO:                                   ~
        IF iTipoConf = 1 THEN                                                                    ~
           IF l-esc-etiqueta OR                                                                  ~
              l-conferen-ok  THEN APPLY "END-ERROR":U TO brw-tarefa-ped IN FRAME {&Frame05Name}. ~
                             ELSE APPLY "GO":U TO THIS-PROCEDURE.                                ~
    END.                                                                                         ~
    /* Campo Etiqueta */                                                                         ~
    ON "END-ERROR":U OF ttWork.num-etiqueta-packing IN FRAME {&Frame06Name} DO:                  ~
        ASSIGN l-esc-etiqueta = YES.                                                             ~
    END.                                                                                         ~
    ON "ENTRY":U OF ttWork.num-etiqueta-packing IN FRAME {&Frame06Name} DO:                      ~
        IF l-conferen-ok THEN                                                                    ~
            APPLY "END-ERROR":U TO ttWork.num-etiqueta-packing IN FRAME {&Frame06Name}.          ~
    END.

/**************************************************************************************************/
/* Definicao dos objetos ativos --- */ 
&global-define ActiveObject1 wgbc9036f
&global-define ActiveObject2 wgbosc092
&global-define ActiveObject3 wgbosc093
&global-define ActiveObject4 wgbosc095
&global-define ActiveObject5 wgbosc094
&global-define ActiveObject6 wgbosc074
&global-define ActiveObject7 wgbosc079
&global-define ActiveObject8 wgbcapi001
&global-define ActiveObject9 wgbosc135
&global-define ActiveObject10 wgbosc000
&global-define ActiveObject11 wgbcapiwms

/**************************************************************************************************/
/*         Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela       */
&global-define ErrorDisplaySeconds 3
/***************************************** Frames Fim *********************************************/

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
      ASSIGN vcod-senha:BLANK IN FRAME {&Frame01Name} = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod_usuar_corren
             ttWork.cod-usuario                                      = v_cod_usuar_corren
             vcod-senha                                              = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME {&Frame01Name}         = '****************':U. /* login autom tico */
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME {&Frame01Name} = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME {&Frame01Name} = ''.
   END.

   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   
   ASSIGN ttWork.opcao:SCREEN-VALUE IN FRAME {&Frame02Name} = '0'.

   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os DBOs e carrega as tarefas no browse                       **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   ASSIGN vLogErro      = NO
          l-conferen-ok = NO.

   /* Inicializar DBOs */
   IF NOT VALID-HANDLE(wgbosc093) THEN
      RUN scbo/bosc093.p PERSISTENT SET wgbosc093.

   IF NOT VALID-HANDLE(wgbosc094) THEN
      RUN scbo/bosc094.p PERSISTENT SET wgbosc094.

   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.
    
   ASSIGN {&TempTable}.opcao = ttWork.opcao.
   
   EMPTY TEMP-TABLE tt-tarefa-docto-emb.

   /* Retorna Tarefas de Conferencia por Embarque */
   RUN GetTasks(INPUT 1).

   FIND FIRST tt-tarefa-docto-emb NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-tarefa-docto-emb THEN
      ASSIGN vtiptarefa = "Tarefa Inexistente (WMS)".

   OPEN QUERY qry-tarefa-docto FOR EACH tt-tarefa-docto-emb.
   BROWSE brw-tarefa-docto:REFRESH() NO-ERROR.
   APPLY "VALUE-CHANGED":U TO brw-tarefa-docto IN FRAME {&Frame03Name}.

   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame04 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:   
   ASSIGN iTipoConf:SCREEN-VALUE IN FRAME {&Frame04Name} = '0'.

   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame05 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame05}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame05:

   DEFINE VARIABLE l-reg AS INTEGER NO-UNDO.

   ASSIGN vLogErro = NO
          ttWork.num-etiqueta-packing = 0.
    
   EMPTY TEMP-TABLE tt-tarefa-resumo-pedido-emb.

   IF iTipoConf = 1 THEN DO:
      IF vNrLeituraEmAndamento > vQtdTotalLeituras AND NOT l-conferen-ok AND 
         vQtdTotalLeituras <> 0 AND vNrLeituraEmAndamento <> 0 THEN DO:
         ASSIGN vLogErro      = YES
                l-conferen-ok = YES.
         HIDE ALL.
         {bcp/bc9105.i "503" "Todas etiquetas da tarefa foram lidas (WMS)"}
         RETURN "NOK":U.
      END.        
   END.

   /* Se a Conferencia for por Pedido, exibe browser com as tarefas por Pedido do Embarque */
   IF iTipoConf = 2 THEN DO:
      RUN getTasks(INPUT 2).
      
      ASSIGN l-reg = 0.
      
      FOR EACH tt-tarefa-resumo-pedido-emb:
         ASSIGN l-reg = l-reg + 1.
      END.
        
      FIND FIRST tt-tarefa-resumo-pedido-emb NO-LOCK NO-ERROR.
      IF NOT AVAIL tt-tarefa-resumo-pedido-emb THEN DO:
         ASSIGN vtiptarefa = "Tarefa Inexistente (WMS)".
         APPLY "END-ERROR":U TO brw-tarefa-ped IN FRAME {&Frame05Name}.

         RETURN "NOK":U.
      END.
    
      OPEN QUERY qry-tarefa-ped FOR EACH tt-tarefa-resumo-pedido-emb NO-LOCK.
      BROWSE brw-tarefa-ped:REFRESH() NO-ERROR.
      APPLY "VALUE-CHANGED":U TO brw-tarefa-ped IN FRAME {&Frame05Name}.
   END.
    
   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame06 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame06}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame06:
   ASSIGN vdoctar = TRIM(STRING(tt-tarefa-docto-emb.id-docto)) + "/":U + TRIM(STRING(tt-tarefa-docto-emb.id-tarefa)).
   
   DISPLAY vdoctar
      WITH FRAME {&Frame06Name}.
    
   IF NOT VALID-HANDLE(hBosc156) THEN
      RUN scbo/bosc156.p PERSISTENT SET hBosc156.

   /* busca numero de leituras efetuadas */
   RUN getLeiturasEmb IN hBosc156 (INPUT  c-cod-estabel,
                                   INPUT  c-cod-local,
                                   INPUT  c-id-docto,
                                   INPUT  vNrLeitura, /* ttWork.nr-leitura, */
                                   INPUT  v_cod_usuar_corren,
                                   INPUT  c-nome-abrev,
                                   INPUT  c-nr-pedcli,
                                   INPUT  iTipoConf,
                                   OUTPUT vQtdLeiturasFeitas).
    
   IF VALID-HANDLE(hBosc156) THEN
      RUN destroy IN hBosc156.

   ASSIGN vNrLeituraEmAndamento = vQtdLeiturasFeitas + 1
          ttWork.rowid-tabela   = r-rowid-tabela.

   RUN verificaStatusTarefa IN wgbosc095 (INPUT tt-tarefa-docto-emb.id-docto,
                                          INPUT tt-tarefa-docto-emb.id-tarefa,
                                          OUTPUT vNumStatus).
   IF vNumStatus <= 1 THEN
      ASSIGN ttWork.log-inicia-processo   = YES
             ttWork.log-finaliza-processo = NO.
   ELSE
      ASSIGN ttWork.log-inicia-processo   = NO
             ttWork.log-finaliza-processo = NO.

   ASSIGN vDesLidos = TRIM(STRING(vNrLeituraEmAndamento,'>>9':U)) + '/':U + TRIM(STRING(vQtdTotalLeituras,'>>9':U)).
   
   DISPLAY vDesLidos
      WITH FRAME {&Frame06Name}.

   IF vNrLeituraEmAndamento > vQtdTotalLeituras AND vNrLeituraEmAndamento <> 0 AND vQtdTotalLeituras <> 0 THEN DO:
      ASSIGN vLogErro      = YES
             l-conferen-ok = YES.
      {bcp/bc9105.i "503" "Todas etiquetas da tarefa foram lidas (WMS)"}
      RETURN "NOK":U.
   END.

   IF vLogErro THEN
      RETURN ERROR.

   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro          = NO
          vLogControlaLogin = NO.

   /* VALIDA€AO USUµRIO   INPUT FRAME {&Frame01Name}  */
   IF ttWork.cod-usuario = '' OR ttWork.cod-usuario = ? THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
   END.
   
   IF v2_cod_usuar_corren = '' THEN DO:

      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
         ON QUIT   UNDO login, LEAVE login
         ON STOP   UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
         RUN btb/btapi910za.p (INPUT  ttWork.cod-usuario, 
                               INPUT  vCod-Senha, 
                               OUTPUT TABLE tt-erros) NO-ERROR.        
      END.
      IF CAN-FIND(FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado! (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND(FIRST tt-erros
                     WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est ÿcorreta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
           RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

      RUN piValidaUsuario IN wgbcapiwms (INPUT ttWork.cod-usuario,
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
   IF RETURN-VALUE <> "OK":U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Conferˆncia (WMS)"}
      RETURN ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   RUN validaUsuario IN wgbosc079 (INPUT  ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> "OK":U THEN DO:
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
        
      IF vLogControlaLogin THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
        
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.                                           
      ASSIGN vLogErro = YES.
   END.
   
   IF NOT vLogUtilizaColetor THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   
   IF vLogErro THEN
      RETURN ERROR.

   IF ttWork.cod-coletor = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
   END.
   
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.
   
   IF vLogErro THEN
      RETURN ERROR.

   /* instancia as BOs de forma persistente */
   IF NOT VALID-HANDLE(wgbosc092) THEN
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.

   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor IN wgbosc092 (INPUT ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> "OK":U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento e se est  ativo */
   RUN validaEquipamento IN wgbosc092 (INPUT  ttWork.cod-equipamento,
                                       OUTPUT vLogAtivo,
                                       OUTPUT vLogProcesso).
   IF RETURN-VALUE <> "OK":U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.
   
   IF NOT vlogAtivo THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
   END.

   IF vLogErro THEN
      RETURN ERROR.

   /* Validacoes Frame 02 Fim    --- */
   ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario
          {&TempTable}.cod-coletor     = ttWork.cod-coletor
          {&TempTable}.cod-equipamento = ttWork.cod-equipamento
          c-cod-equipamento            = ttWork.cod-equipamento
          c-cod-coletor                = ttWork.cod-coletor.

   RETURN "OK":U.
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
   IF ttWork.opcao <> 1 AND 
      ttWork.opcao <> 2 AND 
      ttWork.opcao <> 3 THEN DO:
      {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}
      HIDE ALL.
      RETURN ERROR. 
   END.

   IF VALID-HANDLE(wgbosc093) THEN DO:
      RUN "Destroy":U IN wgbosc093.
      DELETE OBJECT wgbosc093.
   END.
   
   IF VALID-HANDLE(wgbosc094) THEN DO:
      RUN "Destroy":U IN wgbosc094.
      DELETE OBJECT wgbosc094.
   END.
   
   IF VALID-HANDLE(wgbosc074) THEN DO:
      RUN "Destroy":U IN wgbosc074.
      DELETE OBJECT wgbosc074.
   END.
    
   EMPTY TEMP-TABLE tt-tarefa-docto-emb.
   EMPTY TEMP-TABLE tt-tarefa-resumo-pedido-emb.
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

   IF NOT AVAIL tt-tarefa-docto-emb THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento inv lido. (WMS)"}
      RETURN ERROR.
   END.

   ASSIGN ttWork.cod-estabel     = tt-tarefa-docto-emb.cod-estabel
          ttWork.cod-local       = tt-tarefa-docto-emb.cod-local
          ttWork.cod-tarefa      = tt-tarefa-docto-emb.cod-tarefa
          ttWork.cod-equipamento = tt-tarefa-docto-emb.cod-equipamento
          ttWork.cod-coletor     = tt-tarefa-docto-emb.cod-coletor
          ttWork.id-docto        = tt-tarefa-docto-emb.id-docto
          ttWork.id-tarefa       = tt-tarefa-docto-emb.id-tarefa
          ttWork.cdd-embarq      = tt-tarefa-docto-emb.cdd-embarq.

   RUN _RetornaUsuario (OUTPUT ttWork.cod-usuario).
                                                 
   RUN doctoConferenciaEmProcesso IN wgbosc093 (INPUT  ttWork.cod-estabel,
                                                INPUT  ttWork.cod-local,
                                                INPUT  ttWork.cod-usuario,
                                                INPUT  ttWork.id-docto,
                                                OUTPUT TABLE ttWm-conferencia-aux).
                                                     
   /* Se a conferˆncia j  foi iniciada, atualiza nro. leitura */
   IF CAN-FIND(FIRST ttWm-conferencia-aux) THEN DO:
      FIND FIRST ttWm-conferencia-aux NO-LOCK NO-ERROR.
      ASSIGN ttWork.log-inicia-processo   = NO 
             ttWork.log-finaliza-processo = NO 
             ttWork.nr-leitura            = ttWm-conferencia-aux.nr-leitura.
   END.
   ELSE
      ASSIGN ttWork.log-inicia-processo   = YES
             ttWork.log-finaliza-processo = NO
             vNrLeitura                   = 1.
    
   IF tt-tarefa-docto-emb.qtd-leituras = 0 THEN DO:
      ASSIGN vLogErro      = YES
             l-conferen-ok = YES.
      {bcp/bc9105.i "502" "Todas etiquetas da tarefa foram lidas (DC)"}
   END.

   IF vLogErro THEN
      RETURN ERROR.

   RETURN "OK":U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure tem como objetivo permitir ao usuario decidir se a conferencia sera feita por   **
** embarque ou por pedido                                                                         **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame04:
   ASSIGN vLogErro              = NO
          vLogCancela           = NO
          l-esc-etiqueta        = NO
          l-conferen-ok         = NO
          vQtdTotalLeituras     = 0
          vNrLeituraEmAndamento = 0.
    
   IF iTipoConf <> 1 AND iTipoConf <> 2 THEN DO:
      {bcp/bc9105.i "100" "Op‡Æo inv lida (DC)"}
      HIDE ALL.
      RETURN ERROR.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure tem como objetivo permitir ao usuario decidir se a conferencia sera feita por   **
** embarque ou por pedido                                                                         **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame05:
   IF NOT AVAIL tt-tarefa-resumo-pedido-emb AND iTipoConf = 2 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento inv lido. (WMS)"}
      RETURN ERROR.
   END.

   IF iTipoConf = 1 THEN
      ASSIGN vQtdTotalLeituras = tt-tarefa-docto-emb.qtd-leituras
             r-rowid-tabela    = tt-tarefa-docto-emb.r-rowid
             c-cod-estabel     = tt-tarefa-docto-emb.cod-estabel
             c-cod-local       = tt-tarefa-docto-emb.cod-local
             c-id-docto        = tt-tarefa-docto-emb.id-docto
             c-nr-pedcli       = ""
             c-nome-abrev      = "".
   ELSE
      ASSIGN vQtdTotalLeituras = tt-tarefa-resumo-pedido-emb.qtd-leituras
             r-rowid-tabela    = tt-tarefa-resumo-pedido-emb.r-rowid
             c-cod-estabel     = tt-tarefa-resumo-pedido-emb.cod-estabel
             c-cod-local       = tt-tarefa-resumo-pedido-emb.cod-local
             c-id-docto        = tt-tarefa-resumo-pedido-emb.id-docto
             c-nr-pedcli       = tt-tarefa-resumo-pedido-emb.nr-pedcli
             c-nome-abrev      = tt-tarefa-resumo-pedido-emb.nome-abrev.
    
   CLOSE QUERY qry-tarefa-ped.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 04.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame06:
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.

   /* Inicializar as temp-tables */
   EMPTY TEMP-TABLE tt-trans.

   EMPTY TEMP-TABLE tt-trans-filho.

   EMPTY TEMP-TABLE tt-erro.
    
   IF NOT VALID-HANDLE(wgbosc152) THEN DO:
      RUN scbo/bosc152.p PERSISTENT SET wgbosc152.
      RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   END.

   IF ttWork.num-etiqueta-packing = 0 OR ttWork.num-etiqueta-packing = ? THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "501" "Etiqueta de packing inv lida (DC)"}
   END.

   IF vLogErro THEN
      RETURN ERROR.
    
   RUN getInfPackItemEtiqueta IN wgbosc152 (INPUT  ttWork.num-etiqueta-packing,
                                            OUTPUT l-log-packing).

   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "501" "Etiqueta de packing inv lida (DC)"}
   END.

   IF VALID-HANDLE(wgbosc152) THEN
      RUN destroy IN wgbosc152.

   IF vLogErro THEN
      RETURN ERROR.
    
   ASSIGN {&TempTable}.num-etiqueta-packing = ttWork.num-etiqueta-packing.

   RUN GravaTransacao.
    
   RETURN RETURN-VALUE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
***************************************************************************************************/
PROCEDURE GravaTransacao:
   DEFINE VARIABLE vNomeUsuario AS CHARACTER NO-UNDO.
    
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.

   IF NOT VALID-HANDLE(wgbosc152) THEN
      RUN scbo/bosc152.p PERSISTENT SET wgbosc152.

   /* Posiciona registro da BO na etiqueta lida */
   RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   RUN goToKey         IN wgbosc152 (INPUT ttWork.num-etiqueta-packing).

   /* Busca informa‡äes da etiqueta necessarias */
   RUN getCharField IN wgbosc152 (INPUT "cod-embalagem":U,                                                   
                                  OUTPUT ttWork.cod-embalagem). /* Vari vel ou Campo com a descri‡Æo do Item */  
   RUN getCharField IN wgbosc152 (INPUT "nr-pedcli":U,                                                   
                                  OUTPUT ttWork.nr-pedcli). /* Vari vel ou Campo com a descri‡Æo do Item */  
   RUN getIntField  IN wgbosc152 (INPUT "nr-resumo":U,                                                   
                                  OUTPUT ttWork.nr-resumo). /* Vari vel ou Campo com a descri‡Æo do Item */  

   BUFFER-COPY ttWork TO {&TempTable}.

   ASSIGN vTransDetail = 'Doc:':U + STRING({&temptable}.id-docto)   + ' ':U +
                         'Tar:':U + STRING({&TempTable}.cod-tarefa) + ' ':U +
                         'Est:':U + STRING({&TempTable}.cod-estabel)+ ' ':U +
                         'Loc:':U + STRING({&TempTable}.cod-local).

   RUN _RetornaUsuario (OUTPUT vNomeUsuario).

   /** enviar qt leituras para consistencia de fechamento de pedido **/ 
   ASSIGN {&TempTable}.data-transacao         = TODAY
          {&TempTable}.hora-transacao         = STRING(TIME,"hh:mm:ss")
          {&TempTable}.cod-usuario            = vNomeUsuario
          {&TempTable}.cod-equipamento        = c-cod-equipamento
          {&TempTable}.cod-coletor            = c-cod-coletor
          {&TempTable}.nome-abrev             = c-nome-abrev
          {&TempTable}.qtd-total-leituras     = vQtdTotalLeituras
          {&TempTable}.qtd-leituras-efetuadas = vNrLeituraEmAndamento
          {&TempTable}.nr-leitura             = vNrLeitura
          {&TempTable}.tipo-conferencia       = iTipoConf.
    
   RAW-TRANSFER {&TempTable} TO vConteudoRaw.

   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */

   FIND FIRST tt-erro-after-GenerateDC NO-ERROR.
   IF AVAIL tt-erro-after-GenerateDC THEN DO:
      FOR EACH tt-erro-after-GenerateDC:
         {bcp/bc9015.i2 STRING(tt-erro-after-GenerateDC.cd-erro) STRING(tt-erro-after-GenerateDC.mensagem)}
      END.
      ASSIGN vLogErro = YES.
      RETURN ERROR.
   END.

   IF VALID-HANDLE(wgbosc152) THEN
      RUN destroy IN wgbosc152.
    
   RETURN "OK":U.
END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure armazena a lista de tarefas para conferˆncia na temp-table                      **
** tt-tarefa-docto-emb quando Embarque ou na tt-tarefa-resumo-pedido-emb quando Pedido.           **
****************************************************************************************************/
PROCEDURE GetTasks:
   DEFINE INPUT PARAMETER iTipoTask AS INTEGER NO-UNDO. /* 1 - Embarque ; 2 - Pedido */
    
   ASSIGN vLogCancela  = NO
          vLogErro     = NO.

   IF NOT VALID-HANDLE(wgbosc095) THEN
      RUN scbo/bosc095.p PERSISTENT SET wgbosc095.

   /* Retorna as Tarefas por Embarque */
   IF iTipoTask = 1 THEN DO:
      EMPTY TEMP-TABLE tt-tarefa-docto-emb.
      ASSIGN vtiptarefa = "Tarefas Embarque".
      RUN getAllTarefaDoctoAbertaEmb IN wgbosc095 (INPUT INTEGER(15),
                                                   INPUT ttWork.cod-usuario,
                                                   INPUT {&TempTable}.opcao,
                                                   OUTPUT TABLE tt-tarefa-docto-emb).
   END.
    
   /* Retorna as Tarefas por Pedido, ref. ao Embarque selecionado */
   IF iTipoTask = 2 THEN DO:
      EMPTY TEMP-TABLE tt-tarefa-resumo-pedido-emb.
      ASSIGN vtiptarefa = "Tarefas Pedido".
      RUN getAllTarefaPedidoAbertaEmb IN wgbosc095 (INPUT INTEGER(15),
                                                    INPUT ttWork.id-docto,
                                                    INPUT ttWork.id-tarefa,
                                                    INPUT ttWork.cod-usuario,
                                                    INPUT {&TempTable}.opcao,
                                                    OUTPUT TABLE tt-tarefa-resumo-pedido-emb).
      IF {&TempTable}.opcao = 1 THEN DO:
         /* FLAVIO - Quando processado 1 pedido o status do documento entra em processo (op‡Æo 3 da frame2) */
         RUN getAllTarefaPedidoAbertaEmb IN wgbosc095 (INPUT INTEGER(15),
                                                       INPUT ttWork.id-docto,
                                                       INPUT ttWork.id-tarefa,
                                                       INPUT ttWork.cod-usuario,
                                                       INPUT 3, /* {&TempTable}.opcao */
                                                       OUTPUT TABLE tt-tarefa-resumo-pedido-emb-aux).
         FOR EACH tt-tarefa-resumo-pedido-emb-aux:
            CREATE tt-tarefa-resumo-pedido-emb.
            RAW-TRANSFER tt-tarefa-resumo-pedido-emb-aux TO tt-tarefa-resumo-pedido-emb.
         END.
         EMPTY TEMP-TABLE tt-tarefa-resumo-pedido-emb-aux.
      END.
   END.
   RETURN "OK":U.
END PROCEDURE.

&ELSE 
   RUN utp/ut-msgs.p (INPUT "show", 
                      INPUT 28036,
                      INPUT "").
&ENDIF. 

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
