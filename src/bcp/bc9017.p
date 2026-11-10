/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9017 2.00.00.019 } /*** "010019" 14/11/2023 09:21:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9017 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9017.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2002 - Karen - Cria‡Æo do programa                   **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Armazenamento WMS                **
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
**                        Ex: tt-ender-wms.                                                       **
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
&global-define ProgramName BC9017
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-ender-wms
{bcp/bc9017.i " "}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE NEW SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.

DEFINE NEW SHARED TEMP-TABLE ttwm-docto-itens NO-UNDO LIKE wm-docto-itens. 

DEFINE NEW SHARED TEMP-TABLE ttwm-box NO-UNDO LIKE wm-box
            FIELD RowNum  AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID. 

DEFINE NEW SHARED  TEMP-TABLE ttWm-box-movto-idx NO-UNDO LIKE wm-box-movto
            FIELD val-prioridade    AS INTEGER
            FIELD r-rowid           AS ROWID
            INDEX idx-prioridade    val-prioridade DESCENDING
            INDEX idx-movto         id-movto ASCENDING.

DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.                                      

DEFINE NEW SHARED TEMP-TABLE tt-serialfilho NO-UNDO
            FIELD cd-trans        LIKE bc-integracao.cd-trans
            FIELD num-serial      LIKE wm-etiqueta.id-etiqueta
            FIELD id-docto        LIKE wm-box-movto.id-docto
            FIELD id-movto        LIKE wm-box-movto.id-movto
            FIELD num-seq-item    LIKE wm-box-movto.num-seq-item
            FIELD ind-tipo-movto  LIKE wm-box-movto.ind-tipo-movto
            FIELD num-itemserial1 LIKE bc-integracao.inteiro-1
            FIELD num-itemserial2 LIKE bc-integracao.inteiro-2.

DEFINE TEMP-TABLE ttSerialQtd NO-UNDO
            FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado.

/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE VARIABLE vNumItensSerial         AS DECIMAL                      INIT 0   NO-UNDO.
DEFINE VARIABLE vCodItem                AS CHARACTER                    INIT ''  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER                    INIT ''  NO-UNDO.
DEFINE VARIABLE vCodItemCorrente        AS CHARACTER FORMAT 'x(16)':U   INIT ''  NO-UNDO.
DEFINE VARIABLE vDesItemCorrente        AS CHARACTER FORMAT 'x(18)':U   INIT ''  NO-UNDO.
DEFINE VARIABLE vNumCont                AS INTEGER                      INIT 0   NO-UNDO.
DEFINE VARIABLE vNumCont2               AS INTEGER                      INIT 0   NO-UNDO.
DEFINE VARIABLE vNumSeq                 AS INTEGER                      INIT 0   NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE l-reutiliza-etiqueta    AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE l-menu-padrao           AS LOGICAL                      INIT YES NO-UNDO.
DEFINE VARIABLE IDttwm-box              AS ROWID                                 NO-UNDO.
DEFINE VARIABLE IDttwm-box-movto-idx    AS ROWID                                 NO-UNDO.
DEFINE VARIABLE IDttwm-docto-itens      AS ROWID                                 NO-UNDO.
DEFINE VARIABLE wgbcapiwms              AS HANDLE                                NO-UNDO.       
DEFINE VARIABLE vCodSenha               AS CHARACTER FORMAT 'x(18)':U            NO-UNDO.

DEFINE NEW SHARED VARIABLE vLogProcesso       AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogEmProcesso     AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogEmProcesso-aux AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogControla       AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE v-cod-estabel      AS CHARACTER                       NO-UNDO.
DEFINE NEW SHARED VARIABLE v-cod-local        AS CHARACTER                       NO-UNDO.
DEFINE NEW SHARED VARIABLE wgbosc030          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc038          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc039          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc074          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc092          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc093          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc096          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc044          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc079          AS WIDGET-HANDLE                   NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc135          AS WIDGET-HANDLE                   NO-UNDO.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

DEFINE TEMP-TABLE tt-mostra-locais NO-UNDO
            FIELD num-seq           AS INTEGER
            FIELD des-local         AS CHARACTER FORMAT 'X(27)':U
            FIELD dt-movto          AS DATE      FORMAT '99/99/9999':U
            FIELD rowid-box-movto   AS ROWID
            INDEX ID    num-seq
            INDEX local des-local
            INDEX data  dt-movto.

DEFINE QUERY qry-wm-box-movto FOR tt-mostra-locais.  

DEFINE BROWSE brw-wm-box-movto QUERY qry-wm-box-movto NO-LOCK
         DISPLAY tt-mostra-locais.des-local
            WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Armazenamento WMS'                                At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             At Row 04 Col 01          ~
                             vCodSenha                                          At Row 04 Col 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Armazenamento WMS'        At Row 01 Col 01          ~
                             '--------------------':U   At Row 02 Col 01          ~
                             '1 - P£blicas'             At Row 03 Col 01          ~
                             '2 - Meu Usu rio'          At Row 04 Col 01          ~
                             '3 - Meu Equipamento'      At Row 05 Col 01          ~
                             'Op‡Æo:'                   At Row 06 Col 01          ~
                              ttWork.cod-opcao          At Row 06 Col 12 No-Label
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Armazenamento WMS'                                At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             vCodItemCorrente                                   At Row 07 Col 01 No-label ~
                             vDesItemCorrente                                   At Row 08 Col 01 No-label ~
&global-define Frame03Repeat NO
               
/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Armazenamento WMS'                               At Row 01 Col 01                           ~
                             '............/..... ':U                           At Row 02 Col 01                           ~
                             '...................':U                           At Row 03 Col 01                           ~
                             'Qtd Lida:.....     '                             At Row 04 Col 01                           ~
                             'Doca Ori:...       '                             At Row 05 Col 01                           ~
                             'Ser:.............. '                             At Row 06 Col 01                           ~
                             'Box:......         '                             At Row 07 Col 01                           ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(11)':U ~
                             ttWork.qtd-item                                   At Row 02 Col 14 No-label Format '>>>>9':U ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)':U ~
                             ttWork.qtd-embal-lidas                            At Row 04 Col 10 No-label Format '>>>>>':U ~
                             ttWork.num-doca                                   At Row 05 Col 10 No-label Format '>>>':U   ~
                             ttWork.num-serial                                 At Row 06 Col 05 No-label                  ~
                             ttWork.num-box-lido                               At Row 07 col 05 No-label                  

&global-define Frame04Repeat YES
                 
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                                  ~
               ttWork.cod-usuario  WHEN ttWork.cod-usuario = ''~
               vCodSenha           WHEN ttWork.cod-usuario = ''~
               ttWork.cod-coletor ~
               ttWork.cod-equipamento 

&global-define Update02Fields ttWork.cod-opcao

&global-define Update03Fields brw-wm-box-movto

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
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. if return-value = "ITOK":U then leave _frame04.

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
                                Find ttwm-box-movto-idx                                                 ~
                                     Where ttWm-box-movto-idx.r-rowid = tt-mostra-locais.rowid-box-movto ~
                                            No-error.                                                   ~
                                If  Not Available ttwm-box-movto-idx Then Return No-apply.              ~
                                    Run getInfoDoctoItens IN wgbosc096 (Input ttwm-box-movto-idx.cod-estabel,  ~
                                                                        Input ttwm-box-movto-idx.cod-local,    ~
                                                                        Input ttwm-box-movto-idx.id-docto,     ~
                                                                        Input ttwm-box-movto-idx.num-seq-item, ~
                                                                        Output Table ttwm-docto-itens ).       ~
                                Find First ttwm-docto-itens NO-ERROR.                                          ~
                                ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame03 = ttwm-docto-itens.cod-item. ~
                                    RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).                             ~
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
                            END.                        ~
                            ON 'ESC':U OF Frame Frame04 ~
                            DO:                         ~
                                run inicializaTarefaMovtoNOK in wgbosc096             ~
                                             (Input ttwm-box-movto-idx.id-docto,      ~
                                              Input 13,                               ~
                                              Input ttWork.cod-usuario,               ~
                                              Input ttWork.cod-equipamento,           ~
                                              Input ttWork.cod-coletor,               ~
                                              Input ttwm-box-movto-idx.id-movto,      ~
                                              Input ttwm-box-movto-idx.num-seq-item). ~
                                Return 'ESC'.           ~
                            END.                        ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc038
&global-define ActiveObject3 wgbosc039
&global-define ActiveObject4 wgbosc074
&global-define ActiveObject5 wgbosc092
&global-define ActiveObject6 wgbosc093
&global-define ActiveObject7 wgbosc096
&global-define ActiveObject8 wgbosc044
&global-define ActiveObject9 wgbosc079
&global-define ActiveObject10 wgbosc135
&global-define ActiveObject11 wgbcapiwms

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
             vCodSenha:SCREEN-VALUE IN FRAME Frame01          = ''
             vLogEmProcesso-aux                               = NO.
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
   ASSIGN vLogControla = NO.
   
   IF vLogEmProcesso = YES THEN DO:
      RUN EmptyRowErrors IN wgbosc074.
      RUN inicializaTarefaMovtoNOK IN wgbosc096 (INPUT ttwm-box-movto-idx.id-docto,      
                                                 INPUT 13,                             
                                                 INPUT ttWork.cod-usuario,             
                                                 INPUT ttWork.cod-equipamento,         
                                                 INPUT ttWork.cod-coletor,             
                                                 INPUT ttwm-box-movto-idx.id-movto,        
                                                 INPUT ttwm-box-movto-idx.num-seq-item ). 
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
   FOR EACH ttwm-box-movto-idx
      WHERE ttwm-box-movto-idx.ind-tipo-movto = 1
         BY ttwm-box-movto-idx.val-prioridade:
   
      /* Pegar Informacoes Box */
      RUN SetConstraintBoxes IN wgbosc030 ( INPUT ttwm-box-movto-idx.cod-estabel,
                                            INPUT ttwm-box-movto-idx.cod-local,
                                            INPUT ttwm-box-movto-idx.id-box,
                                            INPUT ttwm-box-movto-idx.id-box).
   
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
      ASSIGN tt-mostra-locais.num-seq           = vNumSeq
             tt-mostra-locais.dt-movto          = ttwm-box-movto-idx.dt-atualizacao
             tt-mostra-locais.des-local         = ttwm-box.cod-bloco            + '/':U +
                                                  ttwm-box.cod-rua              + '/':U +
                                                  ttwm-box.cod-nivel            + '/':U +
                                                  ttwm-box.cod-coluna           + '/':U +
                                                  IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
             tt-mostra-locais.rowid-box-movto   = ttwm-box-movto-idx.r-rowid.   
   END.
   
   FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-mostra-locais THEN DO:
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq   = 999
             tt-mostra-locais.des-local = 'Sem tarefas (WMS).'.
   END.
   
   OPEN QUERY qry-wm-box-movto
     FOR EACH tt-mostra-locais 
           BY tt-mostra-locais.num-seq 
           BY tt-mostra-locais.des-local 
           BY tt-mostra-locais.dt-movto DESCENDING.          
   
   BROWSE brw-wm-box-movto:REFRESH() NO-ERROR.
   APPLY 'VALUE-CHANGED':U TO brw-wm-box-movto IN FRAME {&Frame03Name}.
   
   EMPTY TEMP-TABLE tt-serialfilho.
   EMPTY TEMP-TABLE ttserialqtd.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:
   IF vLogControla = YES THEN
      RETURN ERROR.
   
   IF NOT AVAIL ttwm-box-movto-idx THEN DO:
      RETURN.
   END.
   
   /* Pegar Informacoes Box */
   RUN SetConstraintBoxes IN wgbosc030 ( INPUT ttwm-box-movto-idx.cod-estabel,
                                         INPUT ttwm-box-movto-idx.cod-local,
                                         INPUT ttwm-box-movto-idx.id-box,
                                         INPUT ttwm-box-movto-idx.id-box).
   
   RUN openQueryStatic IN wgbosc030 (INPUT 'Boxes':U).
   
   RUN getBatchRecords IN wgbosc030 (INPUT ?,
                                     INPUT NO,
                                     INPUT ?,
                                     OUTPUT vNumCont2,
                                     OUTPUT TABLE ttwm-box).
   
   FIND FIRST ttwm-box NO-ERROR.   
   IF NOT AVAIL ttwm-box THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "401" "Box Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   FIND FIRST ttwm-docto-itens NO-LOCK NO-ERROR.   
   IF NOT AVAIL ttwm-docto-itens THEN DO:
      RETURN.
   END.
   
   ASSIGN ttWork.cod-item:SCREEN-VALUE IN FRAME {&Frame04Name}        = ttwm-docto-itens.cod-item
          ttWork.qtd-item:SCREEN-VALUE IN FRAME {&Frame04Name}        = STRING(ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) 
          ttWork.des-endereco:SCREEN-VALUE IN FRAME {&Frame04Name}    = ttwm-box.cod-bloco            + '/':U + 
                                                                        ttwm-box.cod-rua              + '/':U + 
                                                                        ttwm-box.cod-nivel            + '/':U + 
                                                                        ttwm-box.cod-coluna           + '/':U +
                                                                        IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
          ttWork.qtd-embal-lidas:SCREEN-VALUE IN FRAME {&Frame04Name} = STRING(ttWork.qtd-embal-lidas)  
          ttWork.num-doca:SCREEN-VALUE IN FRAME {&Frame04Name}        = STRING(ttwm-docto-itens.cod-doca)
          ttWork.num-serial:SCREEN-VALUE IN FRAME {&Frame04Name}      = '0'
          ttWork.num-box-lido:SCREEN-VALUE IN FRAME {&Frame04Name}    = '0'.
   
   ASSIGN ttWork.num-serial = 0.
END PROCEDURE.

/*************************************************************************************************** 
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
      IF CAN-FIND(FIRST tt-erros
                  WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado. (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND(FIRST tt-erros
                     WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta. (DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
         ELSE DO:
            IF CAN-FIND(FIRST tt-erros) THEN DO:
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
   
   RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
   RUN scbo/bosc074.p PERSISTENT SET wgbosc074 NO-ERROR.
   RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
   RUN scbo/bosc038.p PERSISTENT SET wgbosc038 NO-ERROR.
   RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
   RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
   RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
   
   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135 NO-ERROR.    
   END.    
   
   {bcp/bc9017.i1 ttWork.cod-usuario}
   IF vLogOk = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu rio Inv lido. (DC)"}
      RETURN ERROR.
   END.
   
   /* Valida se usu rio tem permissÆo para executar a tarefa. */
   RUN validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                         INPUT 13).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Armazenamento. (WMS)"}
      RETURN ERROR.
   END.
   
   IF VALID-HANDLE(wgbosc135) THEN RUN destroy IN wgbosc135.
   
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
   RUN validaEquipColetor IN wgbosc092 (INPUT ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
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
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipto Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipto Inativo. (WMS)"}
      RETURN ERROR.
   END.
   
   /* Validacoes Frame 01 Fim    --- */
   
   ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario 
          {&TempTable}.cod-coletor     = ttWork.cod-coletor
          {&TempTable}.cod-equipamento = ttWork.cod-equipamento.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   ASSIGN vLogErro = NO.
   IF INPUT FRAME Frame02 ttWork.cod-opcao < 1 OR INPUT FRAME  Frame02 ttWork.cod-opcao > 3 THEN DO:
      vLogErro = YES.
      {bcp/bc9105.i "201" "As op‡äes dispon¡veis sÆo 1, 2 e 3. (DC)"}
   END.
   
   ASSIGN ttWork.qtd-embal-lidas  = 0
          ttWork.des-seriais      = ''.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
   /* Validacoes Frame 03 Inicio --- */
   ASSIGN vLogErro = NO vLogControla = NO.
   IF NOT AVAIL ttwm-box-movto-idx THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movto Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   /* Pegar Item */
   RUN getInfoDoctoItens IN wgbosc096 (INPUT ttwm-box-movto-idx.cod-estabel, 
                                       INPUT ttwm-box-movto-idx.cod-local,   
                                       INPUT ttwm-box-movto-idx.id-docto,
                                       INPUT ttwm-box-movto-idx.num-seq-item,
                                       OUTPUT TABLE ttwm-docto-itens ).
   
   
   IF vLogEmProcesso = NO THEN DO:
      RUN inicializaTarefaMovtoOK IN wgbosc096 (INPUT ttwm-box-movto-idx.id-docto,
                                                INPUT 13,     
                                                INPUT ttWork.cod-usuario,              
                                                INPUT ttWork.cod-equipamento,          
                                                INPUT ttWork.cod-coletor,              
                                                INPUT ttwm-box-movto-idx.id-movto,         
                                                INPUT ttwm-box-movto-idx.num-seq-item).
      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Movto Expirou. (WMS)"}
         RETURN ERROR.
      END.
      ASSIGN vLogEmProcesso     = YES
             vLogEmProcesso-aux = NO.
   END.
   
   ASSIGN ttWork.num-tempo-inicio = TIME.
   
   FIND FIRST ttwm-docto-itens NO-ERROR.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame04:
   /* Validacoes Frame 04 Inicio --- */
   ASSIGN vLogErro           = NO
          vLogSai            = NO
          vLogFinaliza       = NO
          vLogControla       = NO
          vLogEmProcesso-aux = NO.
   
   ASSIGN INPUT FRAME Frame04 ttWork.num-serial.
   
   IF ttWork.num-serial = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "402" "Serial Invalido. (DC)"}
      VIEW FRAME Frame04.                               
      RETURN ERROR.
   END.
   
   /* Transa‡Æo via seriais */
   
   /*Este procedimento verifica se o serial informado j  nao faz parte de um pallet*/
   
   IF CAN-FIND ( FIRST tt-serialfilho
                 WHERE tt-serialfilho.cd-trans       = 'BC9017'
                   AND tt-serialfilho.id-docto       = ttwm-box-movto-idx.id-docto
                   AND tt-serialfilho.id-movto       = ttwm-box-movto-idx.id-movto
                   AND tt-serialfilho.num-seq-item   = ttwm-box-movto-idx.num-seq-item
                   AND tt-serialfilho.ind-tipo-movto = ttwm-box-movto-idx.ind-tipo-movto) THEN DO:
       
       EMPTY TEMP-TABLE ttSerialQtd.
       
       FOR EACH tt-serialfilho
          WHERE tt-serialfilho.cd-trans       = 'BC9017'
            AND tt-serialfilho.id-docto       = ttwm-box-movto-idx.id-docto
            AND tt-serialfilho.id-movto       = ttwm-box-movto-idx.id-movto
            AND tt-serialfilho.num-seq-item   = ttwm-box-movto-idx.num-seq-item
            AND tt-serialfilho.ind-tipo-movto = ttwm-box-movto-idx.ind-tipo-movto NO-LOCK:
          
          CREATE ttSerialQtd.
          ASSIGN ttSerialQtd.id-etiqueta        = tt-serialfilho.num-serial
                  ttSerialQtd.qtd-item-retirado = tt-serialfilho.num-itemserial2.
       END.
   END.
   
   RUN EmptyRowErrors IN wgbosc074 NO-ERROR.
   
   RUN validaEtiquetaMovtoArmaz IN wgbosc074  (INPUT ttwm-box-movto-idx.cod-estabel, 
                                               INPUT ttwm-box-movto-idx.cod-local,   
                                               INPUT ttWork.num-serial,
                                               INPUT ttwm-box-movto-idx.id-docto,
                                               INPUT ttwm-box-movto-idx.num-seq-item,
                                               INPUT ttwm-box-movto-idx.id-movto,
                                               INPUT ttwm-box-movto-idx.ind-tipo-movto,
                                               INPUT TABLE ttSerialQtd,
                                               OUTPUT vCodItem,
                                               OUTPUT ttWork.cod-embalagem,
                                               OUTPUT vNumItensSerial).
   
   RUN getRowErrors IN wgbosc074 (OUTPUT TABLE RowErrors) NO-ERROR.
   FOR EACH RowErrors:
      HIDE ALL.
      RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
      HIDE ALL.
   END.
   
   IF CAN-FIND( FIRST rowErrors) THEN DO:
      ASSIGN vLogErro = YES.
      VIEW FRAME Frame04.
      RETURN ERROR.
   END.
   
   IF vNumItensSerial = 0 THEN DO:
      HIDE ALL.
      RUN bcp/bc9115.p (0,"Etiqueta j  informada ou nÆo possui relacionamento com o movimento. ",8,20,3).
      HIDE ALL.
      ASSIGN vLogErro = YES.
      VIEW FRAME Frame04.                               
      RETURN ERROR.                    
   END.
   
   RUN getEstabelLocalDocto IN wgbosc038 (INPUT ttwm-box-movto-idx.id-docto,
                                          OUTPUT v-cod-estabel,
                                          OUTPUT v-cod-local) NO-ERROR.
   
   FIND FIRST tt-serialfilho
        WHERE tt-serialfilho.cd-trans       = 'BC9017'
          AND tt-serialfilho.num-serial     = ttWork.num-serial                 
          AND tt-serialfilho.id-docto       = ttwm-box-movto-idx.id-docto
          AND tt-serialfilho.id-movto       = ttwm-box-movto-idx.id-movto
          AND tt-serialfilho.num-seq-item   = ttwm-box-movto-idx.num-seq-item
          AND tt-serialfilho.ind-tipo-movto = ttwm-box-movto-idx.ind-tipo-movto NO-ERROR.
   
   IF AVAILABLE tt-serialfilho THEN DO:
      ASSIGN tt-serialfilho.num-itemserial2 = tt-serialfilho.num-itemserial2 + vNumItensSerial.
   END. 
   ELSE DO:
      CREATE tt-serialfilho.
      ASSIGN tt-serialfilho.cd-trans        = 'BC9017'
             tt-serialfilho.num-serial      = ttWork.num-serial
             tt-serialfilho.id-docto        = ttwm-box-movto-idx.id-docto
             tt-serialfilho.id-movto        = ttwm-box-movto-idx.id-movto
             tt-serialfilho.num-seq-item    = ttwm-box-movto-idx.num-seq-item   
             tt-serialfilho.ind-tipo-movto  = ttwm-box-movto-idx.ind-tipo-movto 
             tt-serialfilho.num-itemserial1 = vNumItensSerial 
             tt-serialfilho.num-itemserial2 = vNumItensSerial.
   END.
   
   IF (ttWork.qtd-embal-lidas + VNumItensSerial) > (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "404" "Quantidade lida ultrapassa limite box. (WMS)"}
      VIEW FRAME Frame04.                               
      RETURN ERROR.
   END.
   
   ASSIGN ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + vNumItensSerial.
   
   DISPLAY ttWork.qtd-embal-lidas WITH FRAME {&Frame04Name}. 
   
   ASSIGN {&TempTable}.num-serial     = ttWork.num-serial
          {&TempTable}.qtd-item-digit = vNumItensSerial.
   
   /*Se a quantidade de item solicitada ja foi atendida manda confirmar a transacao no WMS*/
   IF (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) = ttWork.qtd-embal-lidas THEN DO:
      ASSIGN IDttwm-box           = ROWID(ttwm-box)         
             IDttwm-box-movto-idx = ttwm-box-movto-idx.r-rowid   
             IDttwm-docto-itens   = ROWID(ttwm-docto-itens).
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9017l.p (INPUT IDttwm-box,        
                         INPUT IDttwm-box-movto-idx,
                         INPUT IDttwm-docto-itens,
                         INPUT TABLE tt-serialfilho).
      IF RETURN-VALUE = 'NOK' THEN DO:
         RUN inicializaTarefaMovtoNOK IN wgbosc096(INPUT ttwm-box-movto-idx.id-docto,
                                                   INPUT 13,     
                                                   INPUT ttWork.cod-usuario,              
                                                   INPUT ttWork.cod-equipamento,          
                                                   INPUT ttWork.cod-coletor,              
                                                   INPUT ttwm-box-movto-idx.id-movto,         
                                                   INPUT ttwm-box-movto-idx.num-seq-item).
         {bcp/bc9105.i "903" "Problemas na Efetiva‡Æo"}
      END.
      HIDE ALL NO-PAUSE.
   
      EMPTY TEMP-TABLE tt-serialfilho.
      EMPTY TEMP-TABLE ttserialqtd.
      ASSIGN ttWork.qtd-embal-lidas = 0
             ttwork.des-seriais     = ''.
      RETURN RETURN-VALUE.
   END.
   
   PAUSE 0 NO-MESSAGE.
END PROCEDURE.

PROCEDURE GetTasks:
   ASSIGN vLogCancela  = NO
              vLogErro = NO.
   
   EMPTY TEMP-TABLE ttWm-box-movto-idx.
   
   CASE ttWork.cod-opcao:
      WHEN 1 THEN DO:
         RUN getMovtoTarefasPublicas IN wgbosc096 (INPUT ttWork.cod-equipamento,
                                                   INPUT vCodTipoEquip,
                                                   INPUT 13,           
                                                   INPUT YES,
                                                   INPUT NO,
                                                   OUTPUT TABLE ttWm-box-movto-idx).
      END.
      WHEN 2 THEN DO:
         RUN getMovtoTarefasUsuario IN wgbosc096 (INPUT ttWork.cod-usuario,
                                                  INPUT ttWork.cod-equipamento,
                                                  INPUT vCodTipoEquip,
                                                  INPUT 13,           
                                                  INPUT YES,
                                                  INPUT NO,
                                                  OUTPUT TABLE ttWm-box-movto-idx).
      END.
      WHEN 3 THEN DO:
         RUN getMovtoTarefasEquip IN wgbosc096 (INPUT ttWork.cod-usuario,
                                                INPUT ttWork.cod-equipamento,
                                                INPUT vCodTipoEquip,
                                                INPUT 13,           
                                                INPUT YES,
                                                INPUT NO,
                                                OUTPUT TABLE ttWm-box-movto-idx).
      END.
   END CASE.   
   RETURN 'OK'.
END.

FINALLY:    
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
