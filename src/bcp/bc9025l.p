/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025L 2.00.00.025 } /*** "010025" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025l MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025o.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Agosto/2009 - Lilian   - Cria‡Æo do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferˆncia WMS                **
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
**                        Ex: tt-transf-wms.                                                       **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por   **
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
DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.
    
DEFINE INPUT PARAM pcod-coletor     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-equipamento AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-estabel     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-local       AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-usuario     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM TABLE FOR ttWm-etiqueta.

FIND FIRST ttwm-etiqueta NO-LOCK NO-ERROR.
/* Definicao global do nome da transacao */
&global-define ProgramName BC9025
&GLOBAL-DEFINE UsingBcTransfilho    YES

/* Definicao da temp-table de integracao */
&global-define TempTable tt-transf-wms
{bcp/bc9025.i " "}
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWork  NO-UNDO LIKE {&TempTable}. 
CREATE ttWork.
ASSIGN ttWork.cod-coletor      = pcod-coletor                
       ttWork.cod-equipamento  = pcod-equipamento
       ttWork.cod-estabel      = pcod-estabel
       ttWork.cod-local        = pcod-local
       ttWork.cod-usuario      = pcod-usuario.

DEFINE TEMP-TABLE ttMovto-Etiqueta NO-UNDO LIKE wm-movto-etiqueta
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE ttWm-box-movto-idx NO-UNDO LIKE wm-box-movto
            FIELD val-prioridade    AS INTEGER
            FIELD r-rowid           AS ROWID
            INDEX idx-prioridade val-prioridade DESC
            INDEX idx-movto      id-movto       ASC.

DEFINE TEMP-TABLE tt-etiqueta NO-UNDO
            FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item    LIKE wm-etiqueta.qtd-item
            INDEX codigo IS UNIQUE id-etiqueta.                         

/* Variaveis de trabalho */              
DEFINE VARIABLE vLogOk             AS LOGICAL                        INITIAL NO  NO-UNDO.
DEFINE VARIABLE vEndereco          AS CHARACTER FORMAT 'x(17)':U                 NO-UNDO.
DEFINE VARIABLE vCodBloco          AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE vCodRua            AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE vCodNivel          AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE vCodColuna         AS CHARACTER                                  NO-UNDO. 
DEFINE VARIABLE v-pos-box          AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE l-box-bloq-armaz   AS LOGICAL                                    NO-UNDO.
DEFINE VARIABLE c-mensagem-box-ent AS CHARACTER FORMAT 'x(16)'                   NO-UNDO.
DEFINE VARIABLE c-mensagem         AS CHARACTER FORMAT 'x(6)'                    NO-UNDO.
DEFINE VARIABLE num-box-orig-aux   AS DECIMAL   FORMAT '>>>>>>>>>9':U INITIAL 0  NO-UNDO.

DEFINE VARIABLE i-ind-status-saldo-origem  LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE o-ind-status-saldo-origem  LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE i-id-movto-box-saldo       LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE o-id-movto-box-saldo       LIKE wm-box-saldo.id-movto            NO-UNDO.

DEFINE TEMP-TABLE ttWm-etiqueta2 NO-UNDO LIKE wm-etiqueta
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

DEFINE VARIABLE d-qtd-item LIKE wm-etiqueta.qtd-item   NO-UNDO.
DEFINE VARIABLE idBox      LIKE wm-box-movto.id-box    NO-UNDO.

DEFINE VARIABLE wgbosc096  AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc030  AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc074  AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc112  AS HANDLE NO-UNDO.       

/* Propriedades globais para frames */              
&global-define FrameSize    20 By 8 

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferˆncia WMS'                                At Row 01  Col 01          ~
                             '--------------------':U                           At Row 02  Col 01          ~
                             'Box Ent:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             vEndereco                                          At Row 04  Col 01 NO-LABEL ~
                             'Ser:'                                             at row 05  col 01          ~
                             ttWork.num-serial                                  at row 05  col 05 no-label ~
                             c-mensagem-box-ent                                 At Row 07  Col 01 NO-LABEL ~
                             'Cancelar: '                                       At Row 08  Col 01          ~
                             c-mensagem                                         At Row 08  Col 11 NO-LABEL 

&global-define Frame01Repeat YES

&global-define Update01Fields                                  ~

                                 /* Definicao das trigger de interacao com a tela */ 
&global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogFinaliza = YES THEN DO: ~
                                                               ASSIGN vLogFinaliza        = YES    ~
                                                                      vLogSai             = YES    ~
                                                                      ttWork.num-box-orig = 0      ~
                                                                      ttWork.num-serial   = ttWm-etiqueta.id-etiqueta   ~
                                                                      ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = '0'  ~
                                                                      ttWork.num-serial:SCREEN-VALUE   IN FRAME Frame01 = STRING(ttWm-etiqueta.id-etiqueta). ~
                                                               EMPTY TEMP-TABLE ttwm-etiqueta.     ~
                                                            END. 
/* Definicao das trigger de usuario  */ 
&global-define UserTriggers                                                                                ~
                                ON 'ESC':U OF Frame Frame01                                                ~
                                DO:                                                                        ~
                                    ASSIGN vlogerro     = YES                                              ~
                                           vLogSai      = YES                                              ~
                                           vLogFinaliza = YES                                              ~
                                           ttWork.num-box-orig = 999999                                    ~
                                           ttWork.num-serial   = ttWm-etiqueta.id-etiqueta                                ~
                                           ttWork.num-box-orig:SCREEN-VALUE  IN FRAME Frame01  = '999999'  ~
                                           ttWork.num-serial:SCREEN-VALUE  IN FRAME Frame01    = STRING(ttWm-etiqueta.id-etiqueta). ~
                                    HIDE ALL.                                                              ~
                                END.                                                                       ~
                                ON 'enter':U OF ttwork.num-box-orig IN Frame Frame01                       ~
                                DO:                                                                     ~
                                END.                                                                       ~
                                ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01     ~
                                DO:                                                      ~
                                    ASSIGN INPUT FRAME Frame01 ttwork.num-box-orig.      ~
                                    IF ttWork.num-box-orig = 999999 THEN DO:             ~
                                         APPLY 'go':U TO FRAME Frame01.                  ~
                                    END.                                                 ~
                                    FIND FIRST wm-box NO-LOCK                                       ~
                                        WHERE wm-box.cod-estabel = ttWork.cod-estabel               ~
                                        AND   wm-box.cod-local   = ttWork.cod-local                 ~
                                        AND   wm-box.id-box      = ttWork.num-box-orig NO-ERROR.    ~
                                    IF AVAIL wm-box THEN DO:                                        ~
                                       IF wm-box.ind-posicao-box = 1 THEN                           ~
                                           ASSIGN v-pos-box = "E".                                  ~
                                       ELSE                                                         ~
                                           ASSIGN v-pos-box = "D".                                  ~
                                       ASSIGN vEndereco = wm-box.cod-bloco  + "/":U +               ~
                                                          wm-box.cod-rua    + "/":U +               ~
                                                          wm-box.cod-nivel  + "/":U +               ~
                                                          wm-box.cod-coluna + "/":U +               ~
                                                          v-pos-box.                                ~
                                    END.                                                            ~
                                    ELSE DO:                                                        ~
                                        ASSIGN vEndereco = ''.                                      ~
                                    END.                                                            ~
                                    DISP vEndereco WITH FRAME frame01.                              ~
                                END.                                                                ~
                                ON 'entry':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                                DO:                                                                           ~
                                    DISABLE ttWork.num-serial WITH FRAME Frame01.                             ~
                                    ASSIGN  ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01 = STRING(ttWm-etiqueta.id-etiqueta).  ~
                                    IF ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0" OR             ~
                                       ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "" THEN            ~
                                        ASSIGN vEndereco = "".                                                ~
                                    DISP vEndereco WITH FRAME frame01.                                        ~
                                END.
                                
/* Definicao dos objetos ativos  */ 
&GLOBAL-DEFINE ActiveObject1 wgbosc030
&GLOBAL-DEFINE ActiveObject2 wgbosc074
&GLOBAL-DEFINE ActiveObject3 wgbosc096
&GLOBAL-DEFINE ActiveObject4 wgbosc112

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela */
&global-define ErrorDisplaySeconds 3

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc030.p PERSISTENT SET wgbosc030.
RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc096.p PERSISTENT SET wgbosc096.
RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc112.p PERSISTENT SET wgbosc112.
RUN openQueryStatic IN wgbosc112 (INPUT "Main":U) NO-ERROR. 

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */


/************************************* Codigo do Usuario Inicio ************************************
** Este local ý destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:   
   IF vLogFinaliza = YES THEN DO:
      ASSIGN vlogerro     = YES     
             vLogSai      = YES      
             vLogFinaliza = YES.
      HIDE ALL NO-PAUSE.
      RETURN RETURN-VALUE.
   END.
   
   ASSIGN vEndereco  = ''
          c-mensagem = '999999'.
   
   IF vLogOk = YES THEN DO:
      ASSIGN ttWork.num-box-orig  = num-box-orig-aux /* 999999 */
             ttWork.num-serial    = ttWm-etiqueta.id-etiqueta
             ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01  = '999999' 
             ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01    = STRING(ttWm-etiqueta.id-etiqueta).
      APPLY 'GO':U TO FRAME Frame01.
   END.
   
   DISP ttWork.num-box-orig
        vEndereco
        ttWork.num-serial
        c-mensagem
     WITH FRAME Frame01. 
   
   UPDATE ttWork.num-box-orig
          ttWork.num-serial
     WITH FRAME Frame01.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   DEFINE VARIABLE l-saida-ok   AS LOGICAL     NO-UNDO INITIAL NO.
   DEFINE VARIABLE l-capacidade AS LOGICAL     NO-UNDO INITIAL YES.
   DEFINE VARIABLE l-continua   AS LOGICAL     NO-UNDO INITIAL YES.
   
   ASSIGN vLogErro     = NO
          vLogOk       = NO
          vLogFinaliza = NO.
   
   ASSIGN INPUT FRAME frame01 vEndereco
                      ttWork.num-serial
                      ttWork.num-box-orig
                      c-mensagem.
   
   IF ttWork.num-box-orig <> 999999 THEN DO:
      DO TRANSACTION:
         FIND FIRST wm-equipamento
              WHERE wm-equipamento.cod-equipamento = ttWork.cod-equipamento NO-LOCK NO-ERROR.
         
         /* Valida‡Æo para realizar pergunta sobre a capacidade do endere‡o. */
         RUN retornaCapacidadeEnd IN wgbosc030(INPUT ttWork.cod-estabel,
                                               INPUT ttWork.cod-local,
                                               INPUT ttwork.num-box-orig,
                                               INPUT ttwm-etiqueta.cod-item,
                                               INPUT ttwm-etiqueta.cod-embalagem,
                                               INPUT NO,
                                               INPUT d-qtd-item,
                                               OUTPUT l-capacidade).
         IF NOT l-capacidade THEN DO:
            DISP 'Capacidade do':U      AT ROW 01 COL 01 ~ 
                 'endere‡o excedida.':U  AT ROW 02 COL 01 ~
                 'Deseja Continuar?':U  AT ROW 03 COL 01 ~
                 '1=Sim 2=N’o':U         AT ROW 04 COL 01 ~
               WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX. ~
            UPDATE l-continua AT ROW 04 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8. ~
            IF NOT l-continua THEN
               UNDO,LEAVE.
         END.
         /*------------------------------------------------------------------*/
         
         /* Efetua saida */
         ASSIGN d-qtd-item = (ttwm-etiqueta.qtd-item - ttwm-etiqueta.qtd-item-retirado).
         EMPTY TEMP-TABLE RowErrors.    
         RUN wmp/wm9090.p(INPUT ttWork.cod-estabel, /*pCodEstabel         */
                          INPUT ttWork.cod-local,   /*pCodLocal           */
                          INPUT ?,                  /*pRowDocto           */
                          INPUT ttwork.num-box-orig,/*pIdBoxDestino       */
                          INPUT 0,                  /*pIdSaldoOrigem      */
                          INPUT 0,                  /*pIdSaldoDestino     */
                          INPUT NO,                 /*pJuntaEmbalagem     */
                          INPUT ttWork.cod-usuario, /*pCodUsuario         */
                          INPUT d-qtd-item,         /*pQtdItem            */
                          INPUT ttwork.num-serial,  /*pIdEtiqueta         */
                          INPUT NO,                 /*pl-verifica-capacidade AS LOGICAL                 */
                          OUTPUT TABLE RowErrors).
         IF CAN-FIND(FIRST RowErrors) THEN DO:
            ASSIGN vLogErro          = YES
                   ttWork.num-serial = 0.
            FOR EACH RowErrors:
               ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
               {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
            END.
            UNDO, RETURN ERROR.                
         END.
         
         EMPTY TEMP-TABLE RowErrors.
         EMPTY TEMP-TABLE tt-etiqueta.
         EMPTY TEMP-TABLE ttWm-etiqueta2.  
         
         CREATE tt-etiqueta.
         ASSIGN tt-etiqueta.id-etiqueta = ttwork.num-serial
                tt-etiqueta.qtd-item    = d-qtd-item. 
         
         RUN getInfoAgrupador IN wgbosc074(INPUT ttwork.num-serial,
                                           OUTPUT TABLE ttWm-etiqueta2).
         IF RETURN-VALUE = 'OK':U THEN DO:
            FOR EACH ttWm-etiqueta2 NO-LOCK
               WHERE ttWM-etiqueta2.qtd-item > ttWm-etiqueta2.qtd-item-retirado:
               CREATE tt-etiqueta.
               ASSIGN tt-etiqueta.id-etiqueta = ttWm-etiqueta2.id-etiqueta
                      tt-etiqueta.qtd-item    = (ttWm-etiqueta2.qtd-item - ttWm-etiqueta2.qtd-item-retirado).
            END.
         END.
         
         FIND FIRST wm-docto
              WHERE wm-docto.cod-estabel      = ttWork.cod-estabel
                AND wm-docto.cod-local        = ttWork.cod-local                        
                AND wm-docto.dt-implan-docto  = TODAY                             
                AND wm-docto.ind-origem-docto = 18                                 
                AND wm-docto.num-docto        = ttWork.cod-usuario + "-" + STRING(TODAY) NO-LOCK NO-ERROR.
         IF AVAIL wm-docto THEN DO:
            FIND FIRST wm-box-movto NO-LOCK
                 WHERE wm-box-movto.cod-estabel      = ttWork.cod-estabel
                   AND wm-box-movto.cod-local        = ttWork.cod-local
                   AND wm-box-movto.id-docto         = wm-docto.id-docto
                   AND wm-box-movto.cod-item         = ttwm-etiqueta.cod-item
                   AND wm-box-movto.cod-lote         = ttwm-etiqueta.cod-lote
                   AND wm-box-movto.cod-refer        = ttwm-etiqueta.cod-refer
                   AND wm-box-movto.qtd-item         = d-qtd-item
                   AND wm-box-movto.ind-tipo-movto   = 2           /* Saida */       
                   AND wm-box-movto.ind-status-movto = 1 NO-ERROR. /* NÆo Iniciado */
            IF AVAIL wm-box-movto THEN DO:
               RUN wmp/wm9091.p(INPUT ROWID(wm-box-movto),   /* pRwMovto       */  
                                INPUT ?,                     /* pIdBoxDestino  */  
                                INPUT ttWork.cod-usuario,    /* pCodUsuario    */  
                                INPUT ttWork.cod-equipamento,/* pCodEqpto      */  
                                INPUT ttWork.cod-coletor,    /* pCodColetor    */  
                                INPUT TIME,                  /* pHoraInicio    */  
                                INPUT NO,                    /* pSobreporBox   */  
                                INPUT 0,                     /* pIdAgrupador   */
                                INPUT i-ind-status-saldo-origem,
                                OUTPUT o-ind-status-saldo-origem,
                                INPUT i-id-movto-box-saldo, 
                                OUTPUT o-id-movto-box-saldo,
                                INPUT TABLE tt-etiqueta,     /* tt-etiqueta    */
                                OUTPUT TABLE RowErrors).     /* rowerrors      */
         
               IF CAN-FIND(FIRST RowErrors) THEN DO:
                  ASSIGN vLogErro          = YES
                         ttWork.num-serial = 0.
                  FOR EACH RowErrors:
                     ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                     {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
                  END.
                  UNDO, RETURN ERROR.
               END.
               ELSE DO:
                  ASSIGN l-saida-ok = TRUE.
         
                  RUN gravaTransacaoSAI.
               END.
            END.
            ELSE DO:
               ASSIGN vLogErro          = YES
                      ttWork.num-serial = 0.
               {bcp/bc9105.i "306" "NÆo existe movimento para confirma‡Æo."}
               UNDO, RETURN ERROR.
            END.
         END.
         ELSE DO:
             ASSIGN vLogErro = Yes
                    ttWork.num-serial = 0.
             {bcp/bc9105.i "307" "Documento nÆo existe para confirma‡Æo."}
             UNDO, RETURN ERROR.
         END.
         /* Efetua saida */
         /* Validando se o ID-BOX de Entrada ‚ diferente do ID-BOX de Sa¡da */
         RUN getIdBoxIniciado IN wgbosc096(INPUT ttWork.cod-estabel,
                                                 INPUT ttWork.cod-local,
                                                 INPUT 3, /*Transferencia*/
                                                 INPUT wm-equipamento.cdn-tipo-equipamento,
                                                 INPUT ttWork.num-serial,
                                                 OUTPUT idBox ).
         
         IF idBox = ttwork.num-box-orig  THEN DO:
            ASSIGN vLogErro          = YES
                   ttWork.num-serial = 0.
            {bcp/bc9105.i "55371" "BOX Origem e Destino devem ser diferentes."}
            UNDO, RETURN ERROR.         
         END.
         
         /* Efetua entrada  */
         /*Valida ID Box*/
         ASSIGN num-box-orig-aux = ttWork.num-box-orig.
         RUN retornaEnderecoBox IN wgbosc030(INPUT ttWork.cod-estabel, 
                                             INPUT ttWork.cod-local,   
                                             INPUT ttWork.num-box-orig,
                                             OUTPUT vCodBloco, 
                                             OUTPUT vCodRua,   
                                             OUTPUT vCodNivel, 
                                             OUTPUT vCodColuna).
         IF vCodBloco = '' AND vCodRua = '' THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "401" "Box Inv lido. (WMS)"}
            RETURN ERROR.
         END.
         
         RUN openquerystatic IN wgbosc030(INPUT "main"). 
         RUN gotokey IN wgbosc030(INPUT ttWork.cod-estabel,
                                  INPUT ttWork.cod-local,
                                  INPUT ttWork.num-box-orig).        
         RUN getLogField IN wgbosc030(INPUT "log-bloq-armaz",
                                      OUTPUT l-box-bloq-armaz).
         IF l-box-bloq-armaz THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "401" "Box Bloqueado para Armazenamento. (WMS)"}
            RETURN ERROR.
         END.
         
         /*Valida Etiqueta*/
         EMPTY TEMP-TABLE ttwm-etiqueta.
         RUN getInfoEtiqueta IN wgbosc074(INPUT ttwork.num-serial,
                                          OUTPUT TABLE ttWm-etiqueta).
         If RETURN-VALUE <> 'OK':U THEN DO:
            RUN getrowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
            ASSIGN vLogErro          = YES
                   ttWork.num-serial = ttWm-etiqueta.id-etiqueta.
            FOR EACH RowErrors:
               ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
               {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
            END.
            RETURN ERROR.
         END.
         
         FIND FIRST ttwm-etiqueta NO-ERROR.
         IF NOT AVAILABLE ttwm-etiqueta THEN DO:
            ASSIGN vLogErro          = YES
                   ttWork.num-serial = ttWm-etiqueta.id-etiqueta.
            {bcp/bc9105.i "402" "Serial Invalido ou Usuario Nao Utiliza Coletor (DC)"}
            RETURN ERROR.
         END.
         
         EMPTY TEMP-TABLE ttWm-box-movto-idx.
         RUN getMovtoTransfIniciado IN wgbosc096(INPUT ttWork.cod-estabel,
                                                 INPUT ttWork.cod-local,
                                                 INPUT 3, /*Transferencia*/
                                                 INPUT wm-equipamento.cdn-tipo-equipamento,
                                                 INPUT ttWork.num-serial,
                                                 OUTPUT TABLE ttWm-box-movto-idx).
         FIND FIRST ttWm-box-movto-idx NO-LOCK NO-ERROR.
         IF AVAIL ttWm-box-movto-idx THEN DO:
            EMPTY TEMP-TABLE RowErrors.
            EMPTY TEMP-TABLE tt-etiqueta.
            EMPTY TEMP-TABLE ttMovto-Etiqueta. 
            
            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.id-etiqueta = ttwork.num-serial
                   tt-etiqueta.qtd-item    = ttWm-box-movto-idx.qtd-item * ttWm-box-movto-idx.qti-embalagem.
         
            RUN getMovtoEtiqueta IN wgbosc112(INPUT ttWork.cod-estabel, 
                                              INPUT ttWork.cod-local,   
                                              INPUT ttWm-box-movto-idx.id-movto,
                                              OUTPUT TABLE ttMovto-Etiqueta).
            If RETURN-VALUE = 'OK':U THEN DO:
               FOR EACH ttMovto-Etiqueta NO-LOCK
                  WHERE ttMovto-Etiqueta.id-etiqueta <> ttWork.num-serial:
                  CREATE tt-etiqueta.
                  ASSIGN tt-etiqueta.id-etiqueta = ttMovto-Etiqueta.id-etiqueta
                         tt-etiqueta.qtd-item    = ttMovto-Etiqueta.qtd-item.
               END.
            END.
         
            /*Efetivacao da ENTRADA*/
            RUN wmp/wm9091.p (INPUT ttWm-box-movto-idx.r-rowid, /* pRwMovto       */   
                              INPUT ttWork.num-box-orig,        /* pIdBoxDestino  */   
                              INPUT ttWork.cod-usuario,         /* pCodUsuario    */   
                              INPUT ttWork.cod-equipamento,     /* pCodEqpto      */   
                              INPUT ttWork.cod-coletor,         /* pCodColetor    */   
                              INPUT TIME,                       /* pHoraInicio    */   
                              INPUT YES,                        /* pSobreporBox   */   
                              INPUT 0,                          /* pIdAgrupador   */
                              INPUT o-ind-status-saldo-origem,
                              OUTPUT o-ind-status-saldo-origem,
                              INPUT o-id-movto-box-saldo, 
                              OUTPUT o-id-movto-box-saldo,
                              INPUT TABLE tt-etiqueta,          /* tt-etiqueta    */   
                              OUTPUT TABLE RowErrors).          /* rowerrors      */   
            IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
               ASSIGN vLogErro          = YES
                      ttWork.num-serial = ttWm-etiqueta.id-etiqueta.
               FOR EACH RowErrors:
                  ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                  {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
               END.
               UNDO, RETURN ERROR.
            END.
            ELSE DO:
               RUN gravaTransacaoENT.
         
               {bcp/bc9105.i "305" "Sa¡da e Entrada efetivados com sucesso."}
            END.
         END.
         ELSE DO:
            ASSIGN vLogErro = YES
                   ttWork.num-serial = ttWm-etiqueta.id-etiqueta.
         
            {bcp/bc9105.i "403" "NÆo h ÿtransferˆncia pendente para a etiqueta informada."}
            RETURN ERROR.
         END.
      END.
      
      ASSIGN vLogOk = YES.
      HIDE ALL NO-PAUSE.
      
      ASSIGN ttWork.num-box-orig = 999999.
      ASSIGN vLogFinaliza = YES.
      HIDE ALL NO-PAUSE.
      
      RETURN 'ESC':U.
   END.
   ELSE DO:
      HIDE ALL NO-PAUSE.
      ASSIGN vLogFinaliza = YES.
   END.
END PROCEDURE.

PROCEDURE piSolicitaCordenada:
   DEFINE FRAME FrameNavegIDWMS
         'Transferˆncia WMS'                                 AT ROW 01 COL 01
         '------------------':U                             AT ROW 02 COL 01
         'Bloco:'                                           AT ROW 03 COL 01
         vCodBloco                                          AT ROW 03 COL 10 NO-LABEL
         'Rua:'                                             AT ROW 04 COL 01
         vCodRua                                            AT ROW 04 COL 10 NO-LABEL
         'N¡vel:'                                           AT ROW 05 COL 01
         vCodNivel                                          AT ROW 05 COL 10 NO-LABEL
         'Coluna:'                                          AT ROW 06 COL 01
         vCodColuna                                         AT ROW 06 COL 10 NO-LABEL
      With 1 down font 3 Size 20 BY 8 No-box.
   
   UPDATE vCodBloco
          vCodRua
          vCodNivel
          vCodColuna
      WITH FRAME FrameNavegIDWMS.
   
   HIDE FRAME FrameNavegIDWMS NO-PAUSE.
   
   RUN retornaEnderecoBox2 IN wgbosc030 (INPUT ttWork.cod-estabel,
                                         INPUT ttWork.cod-local,
                                         INPUT vCodBloco,
                                         INPUT vCodRua,
                                         INPUT vCodNivel,
                                         INPUT vCodColuna,
                                         OUTPUT ttWork.num-box-orig).
   
   IF ttWork.num-box-orig = 0 THEN DO ON ENDKEY UNDO,RETRY:
      {bcp/bc9105.i "159" "BOX nÆo encontrado para a coordenada informada.(bc9025f)"}
   END.                                
   ELSE
      ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = string(ttWork.num-box-orig).

END PROCEDURE.

PROCEDURE gravaTransacaoSAI:
   DEF VAR v-detalhe   AS CHARACTER FORMAT "X(100)" NO-UNDO.
   DEF VAR iSeq        AS INTEGER                   NO-UNDO INITIAL 0.
   
   EMPTY TEMP-TABLE tt-trans-filho.
   
   ASSIGN v-detalhe = 'TraMan-':U +
                      'Eqp:':U + TRIM(ttWork.cod-equipamento) + ';':U +
                      'Col:':U + TRIM(ttWork.cod-coletor)     + ';':U +
                      'Est:':U + TRIM(ttWork.cod-estabel)     + ';':U +
                      'Loc:':U + TRIM(ttWork.cod-local).
   
   CREATE tt-trans-filho.
   ASSIGN iSeq = iSeq + 1
          tt-trans-filho.i-sequen-pai = 1
          tt-trans-filho.i-sequen     = iSeq
          tt-trans-filho.num-versao   = 1
          tt-trans-filho.cod-versao-integracao = 1
          tt-trans-filho.conteudo-xml = 'TpMv:':U + TRIM(STRING(0))                         + ';':U + /* Manual */
                                        'IdBx:':U + TRIM(STRING(ttwork.num-box-orig))       + ';':U +
                                        'Mvto:':U + TRIM('Sai')                             + ';':U + /* NÆo existe movimento para transferˆncia manual */
                                        'CdIt:':U + TRIM(STRING(ttWm-etiqueta.cod-item))    + ';':U +
                                        'CEst:':U + TRIM(STRING(ttWork.cod-estabel))        + ';':U +
                                        'CLoc:':U + TRIM(STRING(ttWork.cod-local))          + ';':U +
                                        'CEqt:':U + TRIM(STRING(ttWork.cod-equipamento))    + ';':U +
                                        'CCol:':U + TRIM(STRING(ttWork.cod-coletor))        + ';':U +
                                        'QtIt:':U + TRIM(STRING(d-qtd-item))                + ';':U +
                                        'DtTr:':U + TRIM(STRING(TODAY))                     + ';':U +
                                        'HrTr:':U + TRIM(STRING(TIME,"HH:MM:SS"))           + ';':U +
                                        'NmSr:':U + TRIM(STRING(ttWm-etiqueta.id-etiqueta)) + ';':U.
   
   RUN _GenerateDCTransaction (INPUT "WMOUT001":U,         /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,         /* Conteudo da temp-table {&TempTable}   */
                               INPUT v-detalhe,            /* Cabecalho de detalhes da transacao    */
                               INPUT ttWork.cod-usuario).  /* Usuario responsavel pela transacao    */
END PROCEDURE.


PROCEDURE gravaTransacaoENT:
   DEF VAR v-detalhe   AS CHARACTER FORMAT "X(100)" NO-UNDO.
   DEF VAR iSeq        AS INTEGER                   NO-UNDO INITIAL 0.
   
   EMPTY TEMP-TABLE tt-trans-filho.
   
   ASSIGN v-detalhe = 'TraMan-':U +
                      'Eqp:':U + TRIM(pcod-equipamento) + ';':U +
                      'Col:':U + TRIM(pcod-coletor)     + ';':U +
                      'Est:':U + TRIM(pcod-estabel)     + ';':U +
                      'Loc:':U + TRIM(pcod-local).
   
   CREATE tt-trans-filho.
   ASSIGN iSeq = iSeq + 1
          tt-trans-filho.i-sequen-pai = 1
          tt-trans-filho.i-sequen     = iSeq
          tt-trans-filho.num-versao   = 1
          tt-trans-filho.cod-versao-integracao = 1
          tt-trans-filho.conteudo-xml = 'TpMv:':U + TRIM(STRING(0))                         + ';':U + /* Manual */
                                        'IdBx:':U + TRIM(STRING(ttwork.num-box-orig))       + ';':U +
                                        'Mvto:':U + TRIM('Ent')                             + ';':U + /* NÆo existe movimento para transferˆncia manual */
                                        'CdIt:':U + TRIM(STRING(ttWm-etiqueta.cod-item))    + ';':U +
                                        'CEst:':U + TRIM(STRING(pcod-estabel))              + ';':U +
                                        'CLoc:':U + TRIM(STRING(pcod-local))                + ';':U +
                                        'CEqt:':U + TRIM(STRING(pcod-equipamento))          + ';':U +
                                        'CCol:':U + TRIM(STRING(pcod-coletor))              + ';':U +
                                        'QtIt:':U + TRIM(STRING(tt-etiqueta.qtd-item))      + ';':U +
                                        'DtTr:':U + TRIM(STRING(TODAY))                     + ';':U +
                                        'HrTr:':U + TRIM(STRING(TIME,"HH:MM:SS"))           + ';':U +
                                        'NmSr:':U + TRIM(STRING(ttWm-etiqueta.id-etiqueta)) + ';':U.
   
   RUN _GenerateDCTransaction (INPUT "WMOUT001":U,         /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,         /* Conteudo da temp-table {&TempTable}   */
                               INPUT v-detalhe,            /* Cabecalho de detalhes da transacao    */
                               INPUT ttWork.cod-usuario).  /* Usuario responsavel pela transacao    */
END PROCEDURE.
