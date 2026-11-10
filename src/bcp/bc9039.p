/********************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9039 2.00.00.018 } /*** "010018" 12/07/2024 14:57:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9039 MBC}
&ENDIF

{include/i_dbinst.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9039.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2006 - Thiago Bravo - Cria‡Æo do programa            **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Caixa Resumo WMS     **
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

/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9039
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */
{bcp/bc9039.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
{cdp/cdcfgmat.i} 

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEF TEMP-TABLE ttEtiquetasBox  NO-UNDO
    FIELD id-etiqueta              LIKE wm-etiqueta.id-etiqueta
    FIELD id-agrupador             LIKE wm-etiqueta.id-agrupador
    FIELD cod-serial               LIKE wm-etiqueta.cod-serial
    FIELD cod-item                 LIKE wm-etiqueta.cod-item
    FIELD ind-leitura-etiqueta     LIKE wm-etiqueta.ind-leitura-etiqueta
    FIELD cod-refer                LIKE wm-etiqueta.cod-refer
    FIELD cod-lote                 LIKE wm-etiqueta.cod-lote
    FIELD dt-validade-lote         LIKE wm-etiqueta.dt-validade-lote
    FIELD qtd-item                 LIKE wm-etiqueta.qtd-item
    FIELD qtd-item-retirado        LIKE wm-etiqueta.qtd-item-retirado
    FIELD id-carga                 LIKE wm-etiqueta.id-carga
    FIELD des-item                 LIKE wm-item.des-item
    FIELD r-rowid                  AS ROWID
    INDEX codigo1 id-etiqueta
                  id-agrupador
    INDEX codigo2 id-agrupador.

DEF TEMP-TABLE ttResumoBoxCol NO-UNDO
         FIELD cod-estabel      LIKE  wm-box-saldo.cod-estabel
         FIELD cod-local        LIKE  wm-box-saldo.cod-local
         FIELD cod-item         LIKE  wm-box-saldo.cod-item
         FIELD cod-refer        LIKE  wm-box-saldo.cod-refer
         FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
         FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
         FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
         FIELD ind-status-box   LIKE  wm-box-saldo.ind-status-box
         FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
         FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
         FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
         FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
         FIELD qtd-item-bloq    LIKE  wm-box-saldo.qtd-item-bloq
         FIELD qti-embalagem    LIKE  wm-box-movto.qti-embalagem
         FIELD cod-cliente      LIKE  wm-box-saldo.cod-cliente
         &IF '{&bf_lote_avancado_liberado}' = 'yes' &THEN
            FIELD log-bloq-movto-cq LIKE wm-box-saldo.log-bloq-movto-cq
            FIELD desc-lote-estado  AS CHARACTER FORMAT "x(20)"
         &ENDIF
         FIELD RowNum           AS INTEGER
         FIELD r-RowId          AS ROWID
         INDEX w-res01 IS UNIQUE  cod-item
                                  cod-refer
                                  cod-lote
                                  dt-transacao   
                                  cod-embalagem 
                                  ind-status-saldo.

DEFINE TEMP-TABLE ttResumoDisplay NO-UNDO LIKE ttResumoBoxCol
    FIELD ind-saldo-destinado AS CHAR FORMAT "x(1)"
    FIELD des-status-saldo    AS CHAR FORMAT "x(15)".

DEF TEMP-TABLE ttItensBox NO-UNDO
     FIELD cod-item         LIKE  wm-box-saldo.cod-item
     FIELD cod-estabel      LIKE  wm-box-saldo.cod-estabel
     FIELD cod-local        LIKE  wm-box-saldo.cod-local
     FIELD cod-refer        LIKE  wm-box-saldo.cod-refer
     FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
     FIELD ind-status-box   LIKE  wm-box-saldo.ind-status-box
     FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
     FIELD qtd-item-bloq    LIKE  wm-box-saldo.qtd-item-bloq
     FIELD qti-embalagem    LIKE  wm-box-movto.qti-embalagem.


&global-define TempTable tt-consulta

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.
DEFINE TEMP-TABLE RowErrors NO-UNDO 
    FIELD ErrorSequence    AS INTEGER 
    FIELD ErrorNumber      AS INTEGER 
    FIELD ErrorDescription AS CHARACTER 
    FIELD ErrorParameters  AS CHARACTER 
    FIELD ErrorType        AS CHARACTER 
    FIELD ErrorHelp        AS CHARACTER 
    FIELD ErrorSubType     AS CHARACTER.


DEFINE VARIABLE cCodItem                AS CHARACTER FORMAT 'x(15)':U     INIT ''  NO-UNDO.
DEFINE VARIABLE de-id-box               AS DECIMAL   FORMAT '>>>>>>>>>>'           NO-UNDO.
DEFINE VARIABLE c-cod-estabel           LIKE  wm-box-saldo.cod-estabel             NO-UNDO.
DEFINE VARIABLE c-cod-local             LIKE  wm-box-saldo.cod-local               NO-UNDO.
DEFINE VARIABLE iTipoConsulta           AS INTEGER FORMAT  '>'                     NO-UNDO.
DEFINE VARIABLE wgBOSC152               AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE wgbcapiwms              AS HANDLE                                  NO-UNDO. 

/************************************************************/

/* Query e Browser utilizados para mostrar sumarizacao do saldo do item no Box */
DEFINE QUERY qry-itens-box FOR ttItensBox.

DEFINE BROWSE brw-itens-box QUERY qry-itens-box NO-LOCK
   DISPLAY ttItensBox.cod-item                                FORMAT "x(16)"             LABEL "Item"
           (ttItensBox.qtd-item - ttItensBox.qtd-item-bloq)   FORMAT ">>>,>>>,>>9.9999"  LABEL "Qtd Item"
           ttItensBox.qti-embalagem                           FORMAT ">>>>>>>>9"         LABEL "Qtd Emb"
           ttItensBox.cod-refer                               FORMAT "x(08)"             LABEL "Refer"
           ttItensBox.cod-lote                                FORMAT "x(40)"             LABEL "Lote"
           With No-box No-labels Size 20 By 4 No-scrollbar-vertical.

/* Query e Browser utilizados para mostrar detalhamento do saldo do Item no Box */
DEFINE QUERY qry-resumo-box-saldo FOR ttResumoDisplay.

DEFINE BROWSE brw-resumo-box-saldo QUERY qry-resumo-box-saldo NO-LOCK
   DISPLAY ttResumoDisplay.ind-saldo-destinado   FORMAT "x(01)"            LABEL "S"
           ttResumoDisplay.dt-transacao          FORMAT "99/99/9999"       LABEL "Dt Trans"
           ttResumoDisplay.cod-embalagem         FORMAT "x(10)"            LABEL "Embalagem"
           ttResumoDisplay.qtd-original          FORMAT ">>>,>>>,>>9.9999" LABEL "Qtd Orig"
           ttResumoDisplay.qtd-item              FORMAT ">>>,>>>,>>9.9999" LABEL "Qtd Item"
           ttResumoDisplay.qtd-item-bloq         FORMAT ">>>,>>>,>>9.9999" LABEL "Qtd Bloq"
           ttResumoDisplay.cod-refer             FORMAT "x(08)"            LABEL "Refer"
           ttResumoDisplay.cod-lote              FORMAT "x(40)"            LABEL "Lote"
           ttResumoDisplay.des-status-saldo      FORMAT "x(15)"            LABEL "Status Saldo"
           With No-box No-labels Size 20 By 4 No-scrollbar-vertical.


/* Query e Browser utilizados para mostrar Etiquetas do Box */
DEFINE QUERY qry-etiquetas FOR ttEtiquetasBox.

DEFINE BROWSE brw-etiquetas QUERY qry-etiquetas NO-LOCK
             DISPLAY ttEtiquetasBox.id-etiqueta         FORMAT  ">>>>>>>>>>>>>9"       LABEL "Etiqueta"
                     ttEtiquetasBox.id-agrupador        FORMAT  ">>>>>>>>>>>>>9"       LABEL "Agrupador"
                     ttEtiquetasBox.cod-serial          FORMAT  "x(16)"                LABEL "Serial"
                     ttEtiquetasBox.cod-item            FORMAT  "X(16)"                LABEL "Item"
                     ttEtiquetasBox.cod-refer           FORMAT  "X(8)"                 LABEL "Refer"
                     ttEtiquetasBox.cod-lote            FORMAT  "X(40)"                LABEL "Lote"
                     ttEtiquetasBox.dt-validade-lote    FORMAT  "99/99/9999"           LABEL "Valid Lote"
                     ttEtiquetasBox.qtd-item            FORMAT  ">>>,>>>,>>9.9999"     LABEL "Qtd Item"
                     ttEtiquetasBox.qtd-item-retirado   FORMAT  ">>>,>>>,>>9.9999"     LABEL "Qtd Retirada"
                     ttEtiquetasBox.id-carga            FORMAT  ">>>>>>>>>>>>>9"       LABEL "Id Carga"
                   With No-box No-labels Size 20 By 4 No-scrollbar-vertical.

/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Consulta Local WMS  '                            At Row 01 Col 01          ~
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
&global-define Frame02Defs   'Consulta Local WMS  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Est:                '                             At Row 03 Col 01          ~
                             c-cod-estabel                                      At Row 03 Col 05 No-label ~
                             'Loc:                '                             At Row 04 Col 01          ~
                             c-cod-local                                        At Row 04 Col 05 No-label ~
                             'Box:                '                             At Row 05 Col 01          ~
                             de-id-box                                          At Row 05 Col 05 No-label ~
                             '*'                                                At Row 05 Col 17          ~
                             '* 0 = Endere‡o Box  '                             At Row 07 Col 01          ~

&global-define Frame02Repeat NO
/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Consulta Local WMS  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Saldo Itens     '                             At Row 03 Col 01          ~
                             '2 - Etiquetas       '                             At Row 04 Col 01          ~
                             'Op‡Æo:              '                             At Row 07 Col 01          ~
                              iTipoConsulta                                     At Row 07 Col 08 No-Label

&global-define Frame03Repeat NO

/************************************************************/

&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Consulta Local WMS  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-itens-box                                      At Row 03 Col 01          ~
                             'ENTER: DETALHE ITEM'                              AT ROW 08 COL 01          ~
                             
&global-define Frame04Repeat NO


/* Definicao da Frame03 ---                                 */
&global-define Frame05Name   Frame05
&global-define Frame05Defs   'Consulta Local WMS  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-resumo-box-saldo                               At Row 03 Col 01          ~
                             'It:'                                              AT ROW 07 COL 01          ~
                             cCodItem                                           AT ROW 07 COL 04 NO-LABEL ~
                             '* = Destinado'                                    AT ROW 08 COL 01          ~
                             
&global-define Frame05Repeat YES

&global-define Frame06Name   Frame06
&global-define Frame06Defs   'Consulta Local WMS  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             brw-etiquetas                                      At Row 03 Col 01          ~
                             'Etiquetas'                                        AT ROW 07 COL 01          ~
                             'Box:'                                             AT ROW 08 COL 01          ~
                             de-id-box                                          AT ROW 08 COL 05 NO-LABEL ~
                             
&global-define Frame06Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = ''  ~
                              vcod-senha WHEN ttWork.cod-usuario = ''          ~
                              ttWork.cod-coletor ttWork.cod-equipamento        ~

&global-define Update02Fields c-cod-estabel ~
                              c-cod-local ~
                              de-id-box ~

&global-define Update03Fields iTipoConsulta

&global-define Update04Fields brw-itens-box

&global-define Update05Fields brw-resumo-box-saldo

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04.
&global-define TriggerBeforeFrame05 Run InicializaCamposFrame05.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. 

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
                            ON 'ESC':U OF Frame Frame01    ~
                            DO:                            ~
                                ASSIGN  vlogerro = YES     ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES. ~
                                       vLogCancela = YES.  ~
                                Return 'ESC':U.            ~
                            END. ~
                            ON 'Return':U        OF brw-itens-box In Frame {&Frame04Name}           ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-resumo-box-saldo In Frame {&Frame05Name}     ~
                            DO:                                                                     ~
                                RUN piAtualizaFrame05. ~
                            END.                                                                    ~



/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC092
&global-define ActiveObject2 wgBOSC079
&global-define ActiveObject3 wgBOSC030
&global-define ActiveObject4 wgBOSC152
&global-define ActiveObject5 wgbcapiwms

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
/*RUN pi-return-value.*/
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

   IF RETURN-VALUE = 'ESC':U  THEN DO:
      ASSIGN vlogerro = YES     
             vLogSai  = YES      
             vLogFinaliza = YES
             vLogCancela = YES. 
      HIDE ALL NO-PAUSE.
      RETURN  ERROR.
   END.
   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
          
   EMPTY TEMP-TABLE ttWork.

   CREATE ttWork.
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:blank IN FRAME frame01 = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
      IF v_cod-coletor_corren     <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:blank IN FRAME frame01 = YES
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

   ASSIGN vLogErro = NO
          vLogsai = NO
          vLogfinaliza = NO
          ttWork.des-endereco = ''
          vtexto = ''
          c-cod-estabel:SCREEN-VALUE IN FRAME Frame02 = ''
          c-cod-local:SCREEN-VALUE IN FRAME Frame02 = ''
          de-id-box:SCREEN-VALUE IN FRAME Frame02 = '0'.

END PROCEDURE.


PROCEDURE InicializaCamposFrame03:   
    
   ASSIGN iTipoConsulta:SCREEN-VALUE IN FRAME frame03 = '0'.
    
END PROCEDURE.


PROCEDURE InicializaCamposFrame04:
   ASSIGN vLogErro        = NO
          vLogCancela     = NO.
    
   IF NOT VALID-HANDLE(wgbosc035) THEN DO:
      RUN scbo/bosc035.p PERSISTENT SET wgbosc035 NO-ERROR.
      RUN openQueryStatic IN wgbosc035 (INPUT "Main":U) NO-ERROR.
   END.

   EMPTY TEMP-TABLE ttResumoBoxCol.
   EMPTY TEMP-TABLE ttItensBox.
    
   /* Busca resumo do Box */
   RUN getOcupacaoBox1 IN wgbosc035(INPUT c-cod-estabel,
                                    INPUT c-cod-local,
                                    INPUT de-id-box,
                                    OUTPUT TABLE ttResumoBoxCol).

   IF VALID-HANDLE(wgbosc035) THEN
      RUN destroy IN wgbosc035.

   RUN pi-totaliza-itens-box. /* Sumariza os itens retornados na ttResumoBoxCol */

   OPEN QUERY qry-itens-box
      FOR EACH ttItensBox 
            BY ttItensBox.cod-item     
            BY ttItensBox.cod-refer       
            BY ttItensBox.cod-lote.

   APPLY 'value-changed':U TO brw-itens-box IN FRAME {&Frame04Name}.
END PROCEDURE.

PROCEDURE InicializaCamposFrame05:
   ASSIGN vLogErro        = NO
          vLogCancela     = NO.
    
   EMPTY TEMP-TABLE ttResumoDisplay.
    
   FIND FIRST ttResumoBoxCol NO-LOCK NO-ERROR.
   IF AVAIL ttResumoBoxCol AND ROWID(ttResumoBoxCol) <> ? THEN DO:
      FOR EACH ttResumoBoxCol:
         CREATE ttResumoDisplay.
         BUFFER-COPY ttResumoBoxCol TO ttResumoDisplay.
                   
         IF ttResumoDisplay.ind-status-saldo = 2 THEN
            ASSIGN ttResumoDisplay.ind-saldo-destinado = "*".
         ELSE
            ASSIGN ttResumoDisplay.ind-saldo-destinado = "".
   
         ASSIGN ttResumoDisplay.des-status-saldo = {scinc/i01sc035.i 04 ttResumoDisplay.ind-status-saldo}.
      END.
   
      OPEN QUERY qry-resumo-box-saldo
         FOR EACH ttResumoDisplay
            WHERE ttResumoDisplay.cod-item = ttItensBox.cod-item
               BY ttResumoDisplay.dt-transacao     
               BY ttResumoDisplay.cod-item
               BY ttResumoDisplay.cod-refer
               BY ttResumoDisplay.cod-lote.
   
      APPLY 'value-changed':U TO brw-resumo-box-saldo IN FRAME {&Frame05Name}.
   END.
END.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.

   /* VALIDA€AO USUµRIO */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
   END. 
   IF v2_cod_usuar_corren = ''  THEN DO:
      FOR EACH tt-erros:
         DELETE tt-erros.
      END.
      login:
      DO ON ERROR UNDO login, LEAVE login
         ON QUIT UNDO login, LEAVE login
         ON STOP UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
         RUN btb/btapi910za.p(INPUT INPUT FRAME frame01 ttWork.cod-usuario, 
                              INPUT INPUT FRAME frame01 vCod-Senha, 
                              OUTPUT TABLE tt-erros) NO-ERROR.        
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

   IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   RUN validaUsuario IN wgbosc079 ( INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
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
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   IF ttWork.cod-coletor = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (DC)"}
   END.
   
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (DC)"}
   END.
   IF vLogErro = YES THEN 
      RETURN ERROR.

   /* instancia as BOs de forma persistente */
   IF NOT VALID-HANDLE(wgBOSC092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
   END.

   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor IN wgbosc092(INPUT ttWork.cod-coletor,
                                       OUTPUT vCodTipoEquip,
                                       OUTPUT vLogAtivo,
                                       OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento e se est  ativo */
   RUN validaEquipTransportador IN wgbosc092(INPUT ttWork.cod-equipamento,
                                             OUTPUT vCodTipoEquip,
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

   RETURN RETURN-VALUE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   IF LENGTH(STRING(de-id-box)) > 10 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta informada deve ser Identificadora de Endere‡o (Box)"}
      ASSIGN de-id-box = 0.
      UNDO,RETRY.
   END.

   IF de-id-box = 0 THEN DO:
      RUN pi-solicita-Coordenada.
   END.
END PROCEDURE.

PROCEDURE pi-return-value:
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE GravaCamposFrame03:
   ASSIGN vLogErro     = NO
          vLogCancela  = NO.

   /* Validacoes Frame 02 Fim    --- */
   IF INPUT FRAME Frame03 iTipoConsulta <> 1 AND INPUT FRAME Frame03 iTipoConsulta <> 2 THEN DO:
      {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}
      HIDE ALL.
      RETURN ERROR. 
   END.

   /* Se quiser consultar etiquetas, exibir o browser */
   IF iTipoConsulta = 2 THEN DO:
      HIDE ALL.
      EMPTY TEMP-TABLE ttEtiquetasBox.
        
      ON 'End-Error':U OF brw-etiquetas IN FRAME {&Frame06Name} DO:
         ASSIGN vLogErro = YES.
         UNDO,RETRY.
      END.

      RUN pi-busca-etiquetas-box. /* busca etiquetas do box informado */
        
      VIEW FRAME Frame06.
      ASSIGN de-id-box:SCREEN-VALUE IN FRAME Frame06 = STRING(de-id-box).
      OPEN QUERY qry-etiquetas
         FOR EACH ttEtiquetasBox 
               BY ttEtiquetasBox.id-etiqueta.
            UPDATE brw-etiquetas WITH FRAME {&Frame06Name}.
   END.
END PROCEDURE.

PROCEDURE GravaCamposFrame04:
END PROCEDURE.

PROCEDURE piAtualizaFrame05:
   ASSIGN cCodItem:SCREEN-VALUE IN FRAME Frame05 = TRIM(STRING(ttResumoDisplay.cod-item)).        
END.

PROCEDURE pi-totaliza-itens-box:
   FOR EACH ttResumoBoxCol
      BREAK BY ttResumoBoxCol.cod-item
            BY ttResumoBoxCol.cod-refer
            BY ttResumoBoxCol.cod-lote:

      IF FIRST-OF(ttResumoBoxCol.cod-item) THEN DO:
         CREATE ttItensBox.
         ASSIGN ttItensBox.cod-item       =  ttResumoBoxCol.cod-item      
                ttItensBox.cod-estabel    =  ttResumoBoxCol.cod-estabel   
                ttItensBox.cod-local      =  ttResumoBoxCol.cod-local     
                ttItensBox.cod-refer      =  ttResumoBoxCol.cod-refer     
                ttItensBox.cod-lote       =  ttResumoBoxCol.cod-lote      
                ttItensBox.ind-status-box =  ttResumoBoxCol.ind-status-box.
      END.    
      ASSIGN ttItensBox.qtd-item      = ttItensBox.qtd-item + ttResumoBoxCol.qtd-item
             ttItensBox.qtd-item-bloq = ttItensBox.qtd-item-bloq + ttResumoBoxCol.qtd-item-bloq
             ttItensBox.qti-embalagem = ttItensBox.qti-embalagem + ttResumoBoxCol.qti-embalagem.
   END.
END PROCEDURE.

PROCEDURE pi-busca-etiquetas-box:
   /* Busca as etiquetas armazenadas no box informado */
   IF NOT VALID-HANDLE(wgbosc030) THEN DO:
      RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
   END.

   EMPTY TEMP-TABLE ttEtiquetasBox.

   /* Busca as etiquetas do box  */
   RUN RetornarTtResumos IN wgbosc030 (INPUT c-cod-estabel,
                                       INPUT c-cod-local,
                                       INPUT de-id-box,
                                       INPUT 1, /* Nao Agrupadoras */
                                       INPUT 2, /* Agrupadoras */
                                       INPUT 3, /* Agrupador Pr¢prio */
                                       OUTPUT TABLE ttEtiquetasBox).
    
END PROCEDURE.

PROCEDURE pi-solicita-Coordenada:
   DEFINE FRAME FrameCoordenada
        'Consulta Local WMS'                               AT ROW 01 COL 01
        '------------------':U                             AT ROW 02 COL 01
        'Bloco:'                                           AT ROW 03 COL 01
        vCodBloco                                          AT ROW 03 COL 10 NO-LABEL
        'Rua:'                                             AT ROW 04 COL 01
        vCodRua                                            AT ROW 04 COL 10 NO-LABEL
        'N¡vel:'                                           AT ROW 05 COL 01
        vCodNivel                                          AT ROW 05 COL 10 NO-LABEL
        'Coluna:'                                          AT ROW 06 COL 01
        vCodColuna                                         AT ROW 06 COL 10 NO-LABEL
       WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.

   UPDATE vCodBloco
          vCodRua
          vCodNivel
          vCodColuna
   WITH FRAME FrameCoordenada.

   HIDE FRAME FrameCoordenada NO-PAUSE.

   IF NOT VALID-HANDLE(wgbosc030) THEN DO:
      RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
   END.

   RUN retornaEnderecoBox2 IN wgbosc030 ( INPUT c-cod-estabel,  
                                          INPUT c-cod-local,    
                                          INPUT vCodBloco,          
                                          INPUT vCodRua,            
                                          INPUT vCodNivel,          
                                          INPUT vCodColuna,
                                          OUTPUT vNumBox).        
   IF vNumBox = 0 THEN
      DO ON ENDKEY UNDO,RETRY:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "159" "BOX nÆo encontrado para a coordenada informada.(bc9025)"}
         UNDO,RETRY.
      END.
   ELSE
      ASSIGN de-id-box = vNumBox
             de-id-box:SCREEN-VALUE IN FRAME Frame02 = STRING(vNumBox).
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
