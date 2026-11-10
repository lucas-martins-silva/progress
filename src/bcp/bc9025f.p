/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025F 2.00.00.041 } /*** "010041" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025f MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025f.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Cria‡Æo do programa                **
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
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9025

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-transf-wms
{bcp/bc9025.i " "}
{method/dbotterr.i}
{wmp/wm9000.i}

/* Verificar a cria€ço da ttwork na transa€ço via serial */
DEFINE NEW SHARED TEMP-TABLE ttWork           NO-UNDO LIKE {&TempTable}.
CREATE ttWork.

DEFINE NEW SHARED TEMP-TABLE ttwm-etiqueta-bkp NO-UNDO LIKE wm-etiqueta.

DEFINE TEMP-TABLE ttwm-etiqueta-met            NO-UNDO LIKE wm-etiqueta.   /* tt que recebe do metodo o que esta no WMS */
DEFINE TEMP-TABLE ttwm-etiqueta-9000           NO-UNDO LIKE ttwm-etiqueta. /* tt utilizada para execucao wm90000 */

DEFINE SHARED TEMP-TABLE tt-transf-wms-bkp     NO-UNDO LIKE tt-transf-wms.

DEFINE VARIABLE iCodTipoEquip      AS INTEGER                                     NO-UNDO.
DEFINE VARIABLE vLogAtivo          AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE vLogProcesso       AS LOGICAL                    INIT NO          NO-UNDO.
DEFINE VARIABLE c-date             AS CHARACTER                                   NO-UNDO.
DEFINE VARIABLE c-date-docto       AS CHARACTER                                   NO-UNDO.
DEFINE VARIABLE iTotRegistro       AS INTEGER                                     NO-UNDO. 
DEFINE VARIABLE r-box-movto        AS ROWID                                       NO-UNDO.

DEFINE VARIABLE vTmp_id-docto LIKE wm-docto.id-docto.
DEFINE VARIABLE vTmp_id-movto LIKE wm-box-movto.id-movto.

DEFINE VARIABLE i-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE o-ind-status-saldo-origem       LIKE wm-box-saldo.ind-status-saldo    NO-UNDO.
DEFINE VARIABLE i-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.
DEFINE VARIABLE o-id-movto-box-saldo            LIKE wm-box-saldo.id-movto            NO-UNDO.

&global-define ActiveObject2 wgbosc092

DEFINE TEMP-TABLE ttWm-box-movto-idx NO-UNDO LIKE wm-box-movto
            FIELD val-prioridade    AS INTEGER
            FIELD r-rowid           AS ROWID
            INDEX idx-prioridade val-prioridade DESC
            INDEX idx-movto      id-movto       ASC.

DEFINE TEMP-TABLE tt-etiqueta NO-UNDO
            FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item    LIKE wm-etiqueta.qtd-item
            INDEX codigo IS UNIQUE id-etiqueta.

DEFINE TEMP-TABLE tt-saldo NO-UNDO
            FIELD cod-lote         LIKE  wm-box-saldo.cod-lote
            FIELD dt-validade-lote LIKE  wm-saldo-estoque.dt-validade-lote
            FIELD dt-transacao     LIKE  wm-box-saldo.dt-transacao
            FIELD id-box           LIKE  wm-box-saldo.id-box
            FIELD ind-status-saldo LIKE  wm-box-saldo.ind-status-saldo
            FIELD cod-embalagem    LIKE  wm-box-saldo.cod-embalagem
            FIELD qtd-original     LIKE  wm-box-saldo.qtd-original
            FIELD qtd-item         LIKE  wm-box-saldo.qtd-item
            FIELD qtd-embalagem    LIKE  wm-box-movto.qti-embalagem
            FIELD qtd-retirar      LIKE  wm-box-saldo.qtd-item
            INDEX w-res01 IS UNIQUE  cod-lote
                                     dt-transacao  
                                     id-box       
                                     cod-embalagem 
                                     qtd-original 
                                     qtd-item.

DEFINE TEMP-TABLE tt-docto-itens-emb-manual NO-UNDO
            FIELD cod-embalagem         LIKE wm-box-saldo.cod-embalagem         
            FIELD qtd-item-emb          LIKE wm-box-saldo.qtd-item    
            FIELD qti-embalagem         LIKE wm-box-movto.qti-embalagem                            
            FIELD qtd-volume            LIKE wm-item-embalagem.qtd-volume         
            FIELD qtd-peso              LIKE wm-item-embalagem.qtd-peso
            FIELD id-box                LIKE wm-box.id-box
            FIELD cod-bloco             LIKE wm-box.cod-bloco
            FIELD cod-rua               LIKE wm-box.cod-rua
            FIELD cod-nivel             LIKE wm-box.cod-nivel
            FIELD cod-coluna            LIKE wm-box.cod-coluna.

DEF BUFFER b-tt-transf-wms-bkp FOR tt-transf-wms-bkp.
/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE NEW SHARED VARIABLE vNumLidos   AS INTEGER       NO-UNDO.

DEFINE VARIABLE vLogOk              AS LOGICAL                           INITIAL NO   NO-UNDO.
DEFINE VARIABLE vEndereco           AS CHARACTER FORMAT 'x(15)':U                     NO-UNDO.
DEFINE VARIABLE vDesLidos           AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE vNumSaidas          AS INTEGER                                        NO-UNDO.
DEFINE VARIABLE vLogAnswer          AS LOGICAL                           INITIAL NO   NO-UNDO.
DEFINE VARIABLE vLogAnswer-esc      AS LOGICAL                           INITIAL NO   NO-UNDO.
DEFINE VARIABLE v-count             AS INTEGER                           INITIAL 0    NO-UNDO.
DEFINE VARIABLE v-tipo              AS CHARACTER FORMAT 'x(08)':U                     NO-UNDO.
DEFINE VARIABLE vDetalhe            AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE vCodBloco           AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE vCodRua             AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE vCodNivel           AS CHARACTER                                      NO-UNDO.
DEFINE VARIABLE vCodColuna          AS CHARACTER                                      NO-UNDO.                              
DEFINE VARIABLE vQtdPeso            AS DECIMAL   FORMAT ">,>>>,>>9.9999"              NO-UNDO. 
DEFINE VARIABLE vQtdVolume          AS DECIMAL   FORMAT ">,>>>,>>9.9999"              NO-UNDO. 
DEFINE VARIABLE r-rowid-docto-itens AS ROWID                                          NO-UNDO.
DEFINE VARIABLE capacidade          AS LOGICAL                            INITIAL YES NO-UNDO.
DEFINE VARIABLE tipoCapacidade      AS INTEGER                            INITIAL 1   NO-UNDO.

DEFINE BUFFER bf_ttWm-box-movto-idx FOR ttWm-box-movto-idx.

DEFINE VARIABLE wgbosc030    AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc032    AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc035sto AS HANDLE NO-UNDO. 
DEFINE VARIABLE wgbosc038    AS HANDLE NO-UNDO.
DEFINE VARIABLE wgbosc039    AS HANDLE NO-UNDO.
DEFINE VARIABLE wgbosc044    AS HANDLE NO-UNDO.
DEFINE VARIABLE wgbosc074    AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc092    AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc096    AS HANDLE NO-UNDO.       
DEFINE VARIABLE wgbosc145    AS HANDLE NO-UNDO.  
DEFINE VARIABLE wgbcapi001   AS HANDLE NO-UNDO.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferˆncia WMS'                                At Row 01  Col 01          ~
                             '--------------------':U                           At Row 02  Col 01          ~
                             'Box Ent:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             'En:'                                              At Row 04  Col 01          ~
                             vEndereco                                          At Row 04  Col 04 NO-LABEL ~
                             'Ser:'                                             at row 05  col 01          ~
                             ttWork.num-serial                                  at row 05  col 05 no-label ~
                             'Lidos:'                                           At Row 07  Col 01          ~
                             vDesLidos                                          At Row 07  Col 07 NO-LABEL ~
                             'Cancelar = 999999'                                At Row 7.3 Col 01

&global-define Frame01Repeat YES

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields              ~
         
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' AND vLogFinaliza = YES Then RETURN 'OK':U. ~
                                                            else do: ~
                                                                 for each tt-transf-wms-bkp where tt-transf-wms-bkp.ind-tip-movto = 2: ~
                                                                     delete tt-transf-wms-bkp. ~
                                                                 End. ~
                                                                 hide frame _error no-pause. ~
                                                            End. ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U. ~
                                                            If Return-value = 'CAN'Then RETURN 'CAN':U. ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON 'ESC':U OF Frame Frame01                                                    ~
                            DO:                                                                            ~
                                Define Variable vDesErro As Character View-as Editor Size 19 By 7  No-undo. ~
                                find first tt-transf-wms-bkp no-lock no-error.                             ~
                                If avail tt-transf-wms-bkp Then                                            ~
                                    If tt-transf-wms-bkp.num-serial = 0 Then do:     ~
                                        hide all no-pause.                                                 ~
                                        PAUSE 0.                                                           ~
                                        view frame error.                                                  ~
                                        Disp  'Erro:'         At Row 1 Col 1                               ~
                                              105   format '>>>>>>9'  At Row 1 Col 6 No-label              ~
                                              vDesErro At Row 2 Col 1 No-label                             ~
                                              With Frame Error 1 down font 3 Size 20 By 8 No-box.          ~
                                        If session:display-type = "GUI" Then                               ~
                                           Assign vDesErro:Width  = Frame Error:Width  - 1                 ~
                                                  vDesErro:Height = Frame Error:height - 1.                ~
                                        assign vDesErro:screen-value in frame Error = 'NÆo ‚ poss¡vel sair sem realocar todas embalagens'. ~
                                        Pause No-message.                                                  ~
                                        Hide Frame Error.                                                  ~
                                        PAUSE 0.                                                           ~
                                        disp ttWork.num-box-orig with frame Frame01.                       ~
                                        return no-apply.                                                   ~
                                    End.                                                                   ~
                                    else do:                                                               ~
                                        FIND FIRST tt-transf-wms-bkp WHERE tt-transf-wms-bkp.ind-tip-movto = 2 NO-LOCK NO-ERROR. ~
                                        IF AVAIL tt-transf-wms-bkp THEN DO:                                ~
                                           Disp 'Existem Entradas.' At Row 01 Col 01                       ~
                                                'Deseja Desfazer?'  AT ROW 02 COL 01                       ~
                                                '1=Sim 2=NÆo'       At Row 03 Col 01 With Frame f-conf Font 2 Size 20 By 8 No-box. ~
                                           Update vLogAnswer-esc    At Row 03 Col 13 No-label Format '1/2':U With Frame f-conf Font 2 Size 20 By 8. ~
                                           If  vLogAnswer-esc = YES Then do:                               ~
                                               ASSIGN ttWork.num-box-orig = 0                              ~
                                                      ttWork.num-serial   = 0                              ~
                                                      vNumLidos           = 0.                             ~
                                               EMPTY TEMP-TABLE tt-transf-wms-bkp.                         ~
                                               EMPTY TEMP-TABLE ttwm-etiqueta-met.                         ~
                                               EMPTY TEMP-TABLE ttwm-docto.                                ~
                                               EMPTY TEMP-TABLE ttwm-docto-itens.                          ~
                                           END.                                                            ~
                                           ELSE DO:                                                        ~
                                               RETURN NO-APPLY.                                            ~
                                           END.                                                            ~
                                        END.                                                               ~
                                    End.                                                                   ~
                            END.                                                                           ~
                            ON 'enter':U OF ttwork.num-box-orig IN Frame Frame01     ~
                            DO:                                                      ~
                            END.~
                            ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01                           ~
                            DO:                                                                            ~
                                Run retornaEnderecoBox In wgbosc030 (Input ttwork.cod-estabel,             ~
                                                                     Input ttwork.cod-local,               ~
                                                                     Input ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01, ~
                                                                     OUTPUT vCodBloco,                     ~
                                                                     OUTPUT vCodRua,                       ~
                                                                     OUTPUT vCodNivel,                     ~
                                                                     OUTPUT vCodColuna).                   ~
                                assign input Frame Frame01 ttWork.num-box-orig.                            ~
                                IF vCodBloco = '' and vCodRua = ''                                         ~
                                   THEN ASSIGN vEndereco:SCREEN-VALUE IN FRAME Frame01 = ''.               ~
                                ELSE do:                                                                   ~
                                    ASSIGN vEndereco:SCREEN-VALUE IN FRAME Frame01 = vCodBloco  + "/":U +  ~
                                                                                         vCodRua    + "/":U + ~
                                                                                         vCodNivel  + "/":U + ~
                                                                                         vCodColuna.          ~
                                    find first tt-transf-wms-bkp where tt-transf-wms-bkp.ind-tip-movto = 1 no-lock no-error.  ~
                                    If tt-transf-wms-bkp.num-serial = 0 Then do: /* Se for transa‡Æo via embalagens, chamar o zomm */   ~
                                        assign input frame Frame01 ttWork.num-box-orig.                       ~
                                        hide all no-pause.                                                    ~
                                        run bcp/bc9025i.p (input-output table tt-transf-wms-bkp).             ~
                                        hide all no-pause.                                                    ~
                                        assign entry(1,vDesLidos,"/") = String(vNumLidos).                    ~
                                        disp vDesLidos with Frame Frame01.                                    ~
                                        pause 0 before-hide.                                                  ~
                                    End.                                                                      ~
                                End.                                                                          ~
                            END.                                                                              ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc032
&global-define ActiveObject3 wgbosc035sto
&global-define ActiveObject4 wgbosc038
&global-define ActiveObject5 wgbosc039
&global-define ActiveObject6 wgbosc044
&global-define ActiveObject7 wgbosc074
&global-define ActiveObject8 wgbosc092
&global-define ActiveObject9 wgbosc096
&global-define ActiveObject10 wgbosc145
&global-define ActiveObject11 wgbcapi001
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc030.p PERSISTENT SET wgbosc030.
RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc032.p PERSISTENT SET wgbosc032 NO-ERROR.
RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.

RUN scbo/bosc035sto.p PERSISTENT SET wgbosc035sto.
RUN openQueryStatic IN wgbosc035sto (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc038.p PERSISTENT SET wgbosc038 NO-ERROR.

RUN scbo/bosc039.p PERSISTENT SET wgbosc039.
RUN openQueryStatic IN wgbosc039 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc044.p PERSISTENT SET wgbosc044.
RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.

RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.

RUN scbo/bosc145.p PERSISTENT SET wgbosc145 NO-ERROR.
RUN openQueryStatic IN wgbosc145 (INPUT "Main":U) NO-ERROR. 

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

RUN bcp/bcapi001.p PERSISTENT SET wgbcapi001 (INPUT-OUTPUT TABLE tt-trans,
                                              INPUT-OUTPUT TABLE tt-erro).

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ² destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:   
   DEFINE VARIABLE cTranEmbal AS DECIMAL NO-UNDO. /* Deve ser decimal pois caso seja uma etiqueta, o serial ‚ um n£mero maior do que o suportado por um inteiro */
   
   EMPTY TEMP-TABLE ttwm-etiqueta-met. 
   EMPTY TEMP-TABLE ttwm-docto.
   EMPTY TEMP-TABLE ttwm-docto-itens.
   
   ASSIGN vEndereco  = ''
          vNumSaidas = 0.
   
   FIND FIRST tt-transf-wms-bkp NO-LOCK NO-ERROR.
   
   ASSIGN ttwork.cod-usuario = tt-transf-wms-bkp.cod-usuario
          ttwork.cod-coletor = tt-transf-wms-bkp.cod-coletor
          ttwork.cod-estabel = tt-transf-wms-bkp.cod-estabel
          ttwork.cod-local   = tt-transf-wms-bkp.cod-local
          cTranEmbal         = tt-transf-wms-bkp.num-serial. 
   
   IF vLogOk = YES THEN 
      ASSIGN ttWork.num-box-orig = 0
             ttWork.num-serial   = 0.
   
   IF tt-transf-wms-bkp.num-serial = 0 OR tt-transf-wms-bkp.num-serial = 777777 THEN 
       ASSIGN ttWork.num-serial = 0.
   
   FOR EACH tt-transf-wms-bkp
      WHERE tt-transf-wms-bkp.ind-tip-movto = 1: 
      ASSIGN vNumSaidas = vNumSaidas + 1.
   END.
   
   ASSIGN vDesLidos = TRIM(STRING(vNumLidos,'>>9':U)) + '/':U + TRIM(STRING(vNumSaidas,'>>9':U)).
   
   DISP ttWork.num-box-orig
        vEndereco
        ttWork.num-serial
        vDesLidos
      WITH FRAME Frame01. 
   
   IF cTranEmbal = 0 THEN DO: /* Transa‡Æo via Embalagem */
      UPDATE ttWork.num-box-orig WITH FRAME Frame01.
   END.
   ELSE DO: /* Transa‡Æo via Seriais */
      UPDATE ttWork.num-box-orig
             ttWork.num-serial
         WITH FRAME Frame01.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   DEFINE VARIABLE cTotalQtdeMov AS INTEGER NO-UNDO.
   DEFINE VARIABLE cNumBoxOrig   AS INTEGER NO-UNDO.
   DEFINE VARIABLE cTranEmbal    AS INTEGER NO-UNDO.
   
   ASSIGN vLogErro     = NO
          vLogOk       = NO
          vLogFinaliza = NO.
   
   ASSIGN INPUT FRAME frame01 vEndereco
                              ttWork.num-serial
                              ttWork.num-box-orig.
   
   RUN retornaEnderecoBox IN wgbosc030 (INPUT ttwork.cod-estabel, 
                                        INPUT ttwork.cod-local,   
                                        INPUT ttWork.num-box-orig,
                                        OUTPUT vCodBloco,         
                                        OUTPUT vCodRua,           
                                        OUTPUT vCodNivel,         
                                        OUTPUT vCodColuna).       
   IF ttWork.num-box-orig <> 999999 THEN DO:
      IF vCodBloco = '' AND vCodRua = '' THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "101" "Box Inv lido. (WMS)"}
         HIDE ALL NO-PAUSE.
         RETURN ERROR.
      END. 
   
      FIND FIRST tt-transf-wms-bkp NO-LOCK NO-ERROR.
      /* Se o num-serial estiver em zero, ‚ transa‡Æo via embalagens, caso contr rio, ‚ serial */
      IF tt-transf-wms-bkp.num-serial = 0 THEN DO: 
         IF NOT CAN-FIND ( FIRST b-tt-transf-wms-bkp
                           WHERE b-tt-transf-wms-bkp.ind-tip-movto = 2
                             AND b-tt-transf-wms-bkp.num-box-orig  = ttWork.num-box-orig) THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "106" "NÆo existe nenhum movimento de entrada neste Box. (DC)"}
            HIDE ALL NO-PAUSE.
            RETURN ERROR.
         END.
      END.
      ELSE DO: /* Transa‡Æo vai Serial */
         RUN getInfoEtiqueta IN wgbosc074 (INPUT ttWork.num-serial, 
                                           OUTPUT TABLE ttWm-etiqueta-met). 
         IF RETURN-VALUE <> 'OK':U THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "102" "Etiqueta Inexistente. (WMS)"}
            HIDE ALL NO-PAUSE.
            RETURN ERROR.
         END.
         
         /* validar os seriais que nÆo foram lidos na entrada e foram lidos na sa¡da */
         FIND FIRST tt-transf-wms-bkp
              WHERE tt-transf-wms-bkp.cod-local     = ttwork.cod-local
                AND tt-transf-wms-bkp.num-serial    = ttWork.num-serial
                AND tt-transf-wms-bkp.ind-tip-movto = 1 NO-LOCK NO-ERROR.
         IF NOT AVAIL tt-transf-wms-bkp THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "103" "NÆo existe movto Sa¡da para este serial. (DC)"}
            RETURN ERROR.
         END.
         ELSE DO:
            FIND FIRST ttwm-etiqueta-met NO-LOCK NO-ERROR. 
         
            FIND FIRST ttwm-etiqueta-bkp
                 WHERE ttwm-etiqueta-bkp.id-etiqueta = ttwm-etiqueta-met.id-etiqueta NO-LOCK NO-ERROR. 
            IF NOT AVAIL ttwm-etiqueta-bkp THEN DO:
               CREATE ttwm-etiqueta-bkp.
               BUFFER-COPY ttwm-etiqueta-met TO ttWm-etiqueta-bkp. 
            END.
         
            IF ttwork.num-box-orig = tt-transf-wms-bkp.num-box-orig THEN DO:
               ASSIGN vLogErro = YES.
               {bcp/bc9105.i "104" "End Entrada ‚ o mesmo Sa¡da. (DC)"}  
               RETURN ERROR.
            END.
            ELSE DO:
               FIND FIRST tt-transf-wms-bkp
                    WHERE tt-transf-wms-bkp.cod-estabel   = ttwork.cod-estabel
                      AND tt-transf-wms-bkp.cod-local     = ttwork.cod-local
                      AND tt-transf-wms-bkp.num-serial    = ttWork.num-serial
                      AND tt-transf-wms-bkp.ind-tip-movto = 2 NO-LOCK NO-ERROR.
               
               IF NOT AVAIL tt-transf-wms-bkp THEN DO:
                  CREATE tt-transf-wms-bkp.
                  ASSIGN tt-transf-wms-bkp.cod-usuario       = ttWork.cod-usuario
                         tt-transf-wms-bkp.cod-coletor       = ttWork.cod-coletor
                         tt-transf-wms-bkp.cod-equipamento   = ttWork.cod-equipamento
                         tt-transf-wms-bkp.cod-estabel       = ttWork.cod-estabel
                         tt-transf-wms-bkp.cod-local         = ttWork.cod-local
                         tt-transf-wms-bkp.num-box-orig      = ttWork.num-box-orig
                         tt-transf-wms-bkp.num-serial        = ttWork.num-serial
                         tt-transf-wms-bkp.des-endereco      = vEndereco
                         tt-transf-wms-bkp.cod-item          = ttwm-etiqueta-met.cod-item  
                         tt-transf-wms-bkp.qtd-item          = ttwm-etiqueta-met.qtd-item  
                         tt-transf-wms-bkp.cod-lote          = ttwm-etiqueta-met.cod-lote  
                         tt-transf-wms-bkp.cod-refer         = ttwm-etiqueta-met.cod-refer 
                         tt-transf-wms-bkp.cod-embalagem     = ttwm-etiqueta-met.cod-embalagem 
                         tt-transf-wms-bkp.qtd-item-retirado = ttwm-etiqueta-met.qtd-item-retirado
                         tt-transf-wms-bkp.cod-cliente       = ttwm-etiqueta-met.cod-cliente
                         tt-transf-wms-bkp.ind-tip-movto     = 2
                         tt-transf-wms-bkp.dat-transacao     = TODAY.
               
                  ASSIGN vNumLidos = vNumLidos + 1
                         vLogOk    = YES
                         ENTRY(1,vDesLidos,"/") = STRING(vNumLidos)
                         vDesLidos:SCREEN-VALUE IN FRAME Frame01 = vDesLidos.
               END.
               ELSE DO:
                  ASSIGN vLogErro = YES.
                  {bcp/bc9105.i "105" "Serial j  lido. (DC)"}
                  RETURN ERROR.
               END.
            END.
         END.
      END. 
      /* Validar quantidade de itens lidos na sa¡da e quantidade de itens lidos na entrada 
         Possibilidade a transferˆncia parcial das embalagens/itens */
      bloco-wms:
      DO TRANSACTION 
         ON ERROR  UNDO bloco-wms, LEAVE bloco-wms
         ON STOP   UNDO bloco-wms, LEAVE bloco-wms
         ON QUIT   UNDO bloco-wms, LEAVE bloco-wms
         ON ENDKEY UNDO bloco-wms, LEAVE bloco-wms:
  
         ASSIGN c-date       = STRING(TODAY)     
                c-date-docto = STRING(ENTRY(1,c-date,"/")) + STRING(ENTRY(2,c-date,"/")).
   
         IF (vNumLidos > 0) THEN DO:
            CREATE ttwm-docto.
            ASSIGN ttwm-docto.cod-estabel      = ttWork.cod-estabel
                   ttwm-docto.cod-local        = ttWork.cod-local
                   ttwm-docto.dt-implan-docto  = TODAY
                   ttwm-docto.ind-origem-docto = 6 /* Transferencia Interna */
                   ttwm-docto.id-docto         = 0
                   ttwm-docto.ind-sit-docto    = 2 /* Atualizado    */
                   ttwm-docto.ind-tipo-trans   = 4 /* Transferˆncia */
                   ttwm-docto.num-docto        = IF LENGTH(ttWork.cod-usuario) <= 7 THEN
                                                    ttWork.cod-usuario + "-" + STRING(TODAY)
                                                 ELSE 
                                                    ttWork.cod-usuario + "-" + c-date-docto
                   ttwm-docto.alteracao        = NO.
   
            ASSIGN v-count = 0.
            
            frBlk:
            FOR EACH tt-transf-wms-bkp USE-INDEX idx-tip-movto
               WHERE tt-transf-wms-bkp.ind-tip-movto = 1 NO-LOCK:   
            
               /* NÆo realizar a efetiva‡Æo de itens pendentes de serem realizadas os movimentos de entrada */
               IF tt-transf-wms-bkp.num-serial = 0 THEN DO:
                  FIND FIRST b-tt-transf-wms-bkp
                       WHERE b-tt-transf-wms-bkp.ind-tip-movto = 2
                         AND b-tt-transf-wms-bkp.num-serial    = 0 /* Quando for embalagem, o num-serial ‚ igual a zero */
                         AND b-tt-transf-wms-bkp.cod-refer     = tt-transf-wms-bkp.cod-refer
                         AND b-tt-transf-wms-bkp.cod-lote      = tt-transf-wms-bkp.cod-lote
                         AND b-tt-transf-wms-bkp.cod-item      = tt-transf-wms-bkp.cod-item
                         AND b-tt-transf-wms-bkp.cod-cliente   = tt-transf-wms-bkp.cod-cliente
                         AND b-tt-transf-wms-bkp.qtd-item      = tt-transf-wms-bkp.qtd-item
                         AND b-tt-transf-wms-bkp.cod-embalagem = tt-transf-wms-bkp.cod-embalagem
                         AND b-tt-transf-wms-bkp.cod-livre-2   = "":U NO-ERROR.
               END.
               ELSE DO:
                  FIND FIRST b-tt-transf-wms-bkp
                       WHERE b-tt-transf-wms-bkp.ind-tip-movto = 2
                         AND b-tt-transf-wms-bkp.num-serial    = tt-transf-wms-bkp.num-serial NO-LOCK NO-ERROR.
               END.
               IF NOT AVAIL b-tt-transf-wms-bkp THEN
                  NEXT.
               ELSE
                  ASSIGN b-tt-transf-wms-bkp.cod-livre-2 = STRING(ROWID(tt-transf-wms-bkp))
                         v-count                         = v-count + 1.
               
               CREATE ttwm-docto-itens.      
               ASSIGN ttwm-docto-itens.cod-estabel    = ttwm-docto.cod-estabel
                      ttwm-docto-itens.cod-local      = ttwm-docto.cod-local
                      ttwm-docto-itens.num-docto      = ttwm-docto.num-docto
                      ttwm-docto-itens.id-docto       = ttwm-docto.id-docto
                      ttWm-docto-itens.cod-item       = tt-transf-wms-bkp.cod-item
                      ttWm-docto-itens.cod-refer      = tt-transf-wms-bkp.cod-refer
                      ttWm-docto-itens.cod-lote       = tt-transf-wms-bkp.cod-lote
                      ttWm-docto-itens.cod-cliente    = tt-transf-wms-bkp.cod-cliente
                      ttWm-docto-itens.qtd-item       = (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado) 
                      ttWm-docto-itens.dt-atualizacao = TODAY 
                      ttWm-docto-itens.gera-sugestao  = NO
                      ttWm-docto-itens.num-seq-item   = IF tt-transf-wms-bkp.num-serial = 0 THEN v-count ELSE 0. /* Agrupar por embalagem */
               
               EMPTY TEMP-TABLE RowErrors.
               
               FIND FIRST ttWm-docto NO-ERROR.
               FIND FIRST ttWm-docto-itens NO-ERROR.
               
               ASSIGN tt-transf-wms-bkp.id-docto = ttwm-docto.id-docto.
               IF AVAILABLE ttwm-docto-itens  THEN DO:
                  ASSIGN tt-transf-wms-bkp.num-seq-item  = ttwm-docto-itens.num-seq-item
                         b-tt-transf-wms-bkp.num-seq-item = ttwm-docto-itens.num-seq-item.
               END.
               ASSIGN ttWm-docto.alteracao = YES.
               
               EMPTY TEMP-TABLE ttWm-docto-itens.
            END.                                                       
   
            FOR EACH tt-transf-wms-bkp USE-INDEX idx-tip-movto
               WHERE tt-transf-wms-bkp.ind-tip-movto = 1 NO-LOCK:   
   
               /* NÆo pode efetivar registros de sa¡da que nÆo possuam uma entrada. Utilizando a referˆncia do ROWID gerada acima */
               FIND FIRST b-tt-transf-wms-bkp
                    WHERE b-tt-transf-wms-bkp.cod-livre-2   = STRING(ROWID(tt-transf-wms-bkp))
                      AND b-tt-transf-wms-bkp.ind-tip-movto = 2 NO-LOCK NO-ERROR.
               IF NOT AVAIL b-tt-transf-wms-bkp THEN
                  NEXT.
               
               EMPTY TEMP-TABLE tt-saldo.
               EMPTY TEMP-TABLE tt-docto-itens-emb-manual.
               
               CREATE tt-saldo.
               ASSIGN tt-saldo.cod-lote       = tt-transf-wms-bkp.cod-lote      
                      tt-saldo.dt-transacao   = TODAY
                      tt-saldo.id-box         = tt-transf-wms-bkp.num-box-orig
                      tt-saldo.cod-embalagem  = tt-transf-wms-bkp.cod-embalagem 
                      tt-saldo.qtd-original   = tt-transf-wms-bkp.qtd-item
                      tt-saldo.qtd-item       = (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado)
                      tt-saldo.qtd-embalagem  = IF tt-transf-wms-bkp.num-serial = 0 THEN tt-transf-wms-bkp.qti-embalagem ELSE tt-saldo.qtd-embalagem + 1
                      tt-saldo.qtd-retirar    = tt-transf-wms-bkp.qtd-item-retirado. /* Sempre ser  retirado o todo da embalagem */
               
               FIND FIRST ttwm-docto NO-LOCK NO-ERROR.
               
               RUN GoToKey IN wgbosc039 (INPUT ttWm-docto.cod-estabel, 
                                         INPUT ttWm-docto.cod-local, 
                                         INPUT ttWm-docto.id-docto, 
                                         INPUT tt-transf-wms-bkp.num-seq-item).
               
               
               /* Criação do Documento de transferência */
               /* Processo manual de saída */
               RUN pi-getValorParametro (INPUT tt-transf-wms-bkp.cod-item, /* codigo do item */              
                                         INPUT "WMOut001":U, /*transacao*/
                                         INPUT "ALOCACAO-ILIMITADA":U, /*codigo do parametro*/
                                         OUTPUT tipoCapacidade).
                   
               IF tipoCapacidade = 0 THEN
                  ASSIGN capacidade = NO.
               ELSE 
                  ASSIGN capacidade = YES.
                    
               
               /*API para validações e geração do Documento de transferência*/
               RUN wmp/wm9090.p (INPUT tt-transf-wms-bkp.cod-estabel, /*– Estabelecimento informado pelo usuário */
                                 INPUT tt-transf-wms-bkp.cod-local,   /*– Local do WMS informado pelo usuário */
                                 INPUT ?,                             /* –Rowid do documento (informar ?). */
                                 INPUT ttWork.num-box-orig,           /* –Informar “?”, pois o endereço de destino não é conhecido neste momento. */
                                 INPUT 0,                             /* –não necessário, pois é informada a etiqueta – informar “?”. wm-box-saldo.id-saldo */
                                 INPUT 0,                             /* –não necessário, pois não juntará embalagem. Informar “?”. */
                                 INPUT NO,                            /* –indica se embalagem será unificada – informar “no” */   
                                 INPUT ttWork.cod-usuario,            /* –código d o usuário informado no acesso do equipamento */ 
                                 INPUT tt-saldo.qtd-item,             /* –Quantidade que está sendo transferida – Com base na etiqueta, obter saldo do item (ttWm-etiqueta.qtd-item – ttWm-etiqueta.qtd-item-retirado).*/  /*(tt-etiqueta.qtd-item – tt-transf-wms.qtd-item-retirado) */
                                 INPUT tt-transf-wms-bkp.num-serial,  /* –identificador da etiqueta lida pelo usuário*/ /****  ttWm-etiqueta.id-etiqueta */
                                 INPUT capacidade,                    /* valor lógico de capacidade do destino "infinito" */
                                 OUTPUT TABLE RowErrors).             /* Tabela Temporária de Erros (RowErrors) */               
               IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                  ASSIGN vLogErro = YES.
                  FIND FIRST RowErrors NO-LOCK NO-ERROR.
                  {bcp/bc9105.i "305" "Erro na API wm9090. (DC)"}
                  RETURN ERROR.
               END.
               ELSE DO: 
                  /* Documento criado. Efetivando Saída */
                  EMPTY TEMP-TABLE ttWm-box-movto-idx.
               
                  RUN getMovtosTarefasAbertas IN wgbosc096 (INPUT ttwork.cod-estabel,
                                                            INPUT ttwork.cod-local,  
                                                            INPUT 2,
                                                            INPUT 3,
                                                            INPUT "", 
                                                            OUTPUT TABLE ttWm-box-movto-idx).
                 
               
                  /* busca o documento correspondente ao que foi criado no wm9090 */
                  RUN setConstraintDtNumIdDocto2 IN wgbosc038 (INPUT tt-transf-wms-bkp.cod-estabel,
                                                               INPUT tt-transf-wms-bkp.cod-local,
                                                               INPUT ttWork.cod-usuario + "-" + STRING(TODAY),
                                                               INPUT ttWork.cod-usuario + "-" + STRING(TODAY),
                                                               INPUT 4,
                                                               INPUT 4,
                                                               INPUT 18,
                                                               INPUT 18).
                                
                  RUN openQueryStatic IN wgbosc038 (INPUT "DtNumIdDocto2":U) NO-ERROR.
                  RUN getDecField IN wgbosc038 (INPUT "id-docto":U,
                                                OUTPUT vTmp_id-docto).
                   
                  /* Busca a tarefa aberta com o id do documento correspoendente ao que foi gerado no wm9090 */
                  FIND LAST ttWm-box-movto-idx
                      WHERE ttWm-box-movto-idx.cod-estabel    = tt-transf-wms-bkp.cod-estabel
                        AND ttWm-box-movto-idx.cod-local      = tt-transf-wms-bkp.cod-local
                        AND ttWm-box-movto-idx.id-docto       = vTmp_id-docto
                        AND ttWm-box-movto-idx.id-box         = tt-saldo.id-box 
                        AND ttWm-box-movto-idx.ind-tipo-movto = 2 NO-LOCK NO-ERROR.
                  IF AVAIL ttWm-box-movto-idx THEN DO:
                     /*armazena chave para localiar documento para efetivar a saída e posteriormente entrada*/
                     ASSIGN vTmp_id-docto = ttWm-box-movto-idx.id-docto.
                     ASSIGN vTmp_id-movto = ttWm-box-movto-idx.id-movto.
               
                     RUN goToKey2 IN wgbosc032 ( INPUT ttWm-box-movto-idx.cod-estabel,
                                                 INPUT ttWm-box-movto-idx.cod-local,
                                                 INPUT ttWm-box-movto-idx.id-movto,
                                                 INPUT 2).
                     
                     RUN getRowid IN wgbosc032 (OUTPUT r-box-movto).

                     /* deleta etiquetas */
                     EMPTY TEMP-TABLE tt-etiqueta.
                      
                     CREATE tt-etiqueta.
                     ASSIGN tt-etiqueta.id-etiqueta = tt-transf-wms-bkp.num-serial
                            tt-etiqueta.qtd-item    = (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado).
               
                     /* Efetivação da saída */
                     RUN wmp/wm9091.p (INPUT r-box-movto,                       /* row da saída */
                                       INPUT ttWork.num-box-orig,               /* box destino */
                                       INPUT tt-transf-wms-bkp.cod-usuario,
                                       INPUT tt-transf-wms-bkp.cod-equipamento, /* equipto */
                                       INPUT ttWork.cod-coletor,                /* coletor */
                                       INPUT TIME,                              /* hora inicio */
                                       INPUT NO,
                                       INPUT 0,
                                       INPUT i-ind-status-saldo-origem,
                                       OUTPUT o-ind-status-saldo-origem,
                                       INPUT i-id-movto-box-saldo, 
                                       OUTPUT o-id-movto-box-saldo,
                                       INPUT TABLE tt-etiqueta,
                                       OUTPUT TABLE RowErrors).
                     IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                        FIND FIRST RowErrors NO-LOCK NO-ERROR.
                        ASSIGN vLogErro = YES.
                        {bcp/bc9105.i "305" "Erro no processo de sa¡da API wm9091. (DC)"}
                        RETURN ERROR.
                     END.
                  END.
               END.
               
               RUN GoToKey IN wgbosc145 ( INPUT tt-transf-wms-bkp.cod-estabel,
                                          INPUT tt-transf-wms-bkp.cod-local,
                                          INPUT tt-transf-wms-bkp.cod-item,
                                          INPUT tt-transf-wms-bkp.cod-embalagem).
               IF RETURN-VALUE = 'OK':U THEN DO:
                  RUN getDecField IN wgbosc145 (INPUT "qtd-peso":U,
                                                OUTPUT vQtdPeso).
                  
                  RUN getDecField IN wgbosc145 (INPUT "qtd-volume":U,
                                                OUTPUT vQtdVolume).
               END.
               
               /* Permitindo a transferˆncia Parcial das embalagens x seriais */
               CREATE tt-docto-itens-emb-manual.
               ASSIGN tt-docto-itens-emb-manual.cod-embalagem = b-tt-transf-wms-bkp.cod-embalagem
                      tt-docto-itens-emb-manual.qtd-volume    = vQtdVolume
                      tt-docto-itens-emb-manual.qtd-peso      = vQtdPeso
                      tt-docto-itens-emb-manual.qtd-item      = (b-tt-transf-wms-bkp.qtd-item - b-tt-transf-wms-bkp.qtd-item-retirado) /* Quantidade a ser retirada do item desta embalagem */
                      tt-docto-itens-emb-manual.qti-embalagem = IF tt-transf-wms-bkp.num-serial = 0 THEN b-tt-transf-wms-bkp.qti-embalagem ELSE tt-docto-itens-emb-manual.qti-embalagem + 1 /* Quantidade de embalagens a ser retirada */
                      tt-docto-itens-emb-manual.id-box        = b-tt-transf-wms-bkp.num-box-orig. 
               
               ASSIGN b-tt-transf-wms-bkp.id-docto = tt-transf-wms-bkp.id-docto.
               IF tt-transf-wms-bkp.num-serial <> 0 THEN 
                  ASSIGN b-tt-transf-wms-bkp.num-seq-item = tt-transf-wms-bkp.num-seq-item.
               
               /* Validando Box, se compartilha endere‡os, e capacidade de armazenamento*/
               RUN validateItemEmbBox IN wgbosc035sto (INPUT tt-docto-itens-emb-manual.cod-embalagem,
                                                       INPUT tt-docto-itens-emb-manual.qtd-item,
                                                       INPUT 0,
                                                       INPUT vQtdVolume,
                                                       INPUT vQtdPeso,
                                                       INPUT tt-transf-wms-bkp.cod-item,
                                                       INPUT tt-transf-wms-bkp.cod-refer,
                                                       INPUT tt-transf-wms-bkp.cod-estabel,
                                                       INPUT tt-transf-wms-bkp.cod-local,
                                                       INPUT ttWork.num-box-orig,
                                                       INPUT vCodBloco, 
                                                       INPUT vCodRua,
                                                       INPUT vCodNivel,
                                                       INPUT vCodColuna,
                                                       INPUT TABLE tt-docto-itens-emb-manual,
                                                       INPUT tt-transf-wms-bkp.cod-lote).
               
               RUN pi_trata_erro_bloco_wms( INPUT "BOSC035STO":U,
                                            INPUT wgbosc035STO).               
               IF RETURN-VALUE = "NOK":U  THEN DO: 
                  UNDO bloco-wms, RETURN "NOK":U.
               END.
               
               /* Processo manual de entrada */
               RUN validaEquipTransportador IN wgbosc092 (  INPUT tt-transf-wms-bkp.cod-equipamento,
                                                            OUTPUT iCodTipoEquip,
                                                            OUTPUT vLogAtivo,
                                                            OUTPUT vLogProcesso).
               
               /* Busca o movimento de entrada com base no movimento de entrada */
               FIND LAST ttWm-box-movto-idx
                   WHERE ttWm-box-movto-idx.cod-estabel    = tt-transf-wms-bkp.cod-estabel
                     AND ttWm-box-movto-idx.cod-local      = tt-transf-wms-bkp.cod-local
                     AND ttWm-box-movto-idx.id-movto       = vTmp_id-movto  
                     AND ttWm-box-movto-idx.id-docto       = vTmp_id-docto
                     AND ttWm-box-movto-idx.ind-tipo-movto = 1 NO-LOCK NO-ERROR.  /* Entrada */
               IF AVAIL ttWm-box-movto-idx THEN DO:
                  RUN goToKey2 IN wgbosc032 ( INPUT ttWm-box-movto-idx.cod-estabel,
                                              INPUT ttWm-box-movto-idx.cod-local,
                                              INPUT ttWm-box-movto-idx.id-movto,
                                              INPUT 1). /*alterado pra buscar o rowid a entrada*/
                  
                  RUN getRowid IN wgbosc032 (OUTPUT r-box-movto).
                  
                  /* Efetiva entrada */
                  RUN wmp/wm9091.p (INPUT r-box-movto,                       /* Rowid Movimento - ttWm-box-movto-idx.r-rowid */
                                    INPUT ttWork.num-box-orig,               /* IdBoxDestino – Endereço de destino. Informar o Box lido. */
                                    INPUT tt-transf-wms-bkp.cod-usuario,     /* usuário – Usuário que fez login no equipamento */
                                    INPUT tt-transf-wms-bkp.cod-equipamento, /* equipamento – código do equipamento informado no login */
                                    INPUT ttWork.cod-coletor,                /* coletor – código do coletor informado no login */
                                    INPUT TIME,                              /* hora de início da movimentação – informar hora atual (time) */
                                    INPUT NO,                                /* sobrepor – indica se deve sobrepor endereço – informa YES. */
                                    INPUT 0,                                 /* id agrupador – informar “0” (zero) */
                                    INPUT o-ind-status-saldo-origem,
                                    OUTPUT o-ind-status-saldo-origem,
                                    INPUT o-id-movto-box-saldo, 
                                    OUTPUT o-id-movto-box-saldo,
                                    INPUT TABLE tt-etiqueta,                 /* tt-etiqueta – gravar a etiqueta lida na tabela temporária e sua respectiva quantidade movimentada (qtd-item – qtd-item-retirado) */
                                    OUTPUT TABLE RowErrors).                 /* erros – RowErrors. */
                  IF CAN-FIND(FIRST RowErrors NO-LOCK) THEN DO:
                     FIND FIRST RowErrors NO-LOCK NO-ERROR. 
                     ASSIGN vLogErro = YES.
                     {bcp/bc9105.i "305" "Erro no procesos de entrada na API wm9091. (DC)"}
                     RETURN ERROR.
                  END.
               END.
            END.
   
            /* grava na bc-trans e bc-trans-filho */
            FIND FIRST ttwm-docto NO-LOCK NO-ERROR.
            
            EMPTY TEMP-TABLE tt-trans-filho.
            
            ASSIGN vDetalhe = 'Est:':U + STRING(ttWork.cod-estabel)  + ';':U +
                              'Loc:':U + STRING(ttWork.cod-local)    + ';':U + 
                              'Doc:':U + STRING(ttwm-docto.id-docto).
            FIND FIRST tt-trans NO-ERROR. /* Apenas criar a transa‡Æo na primeira intera‡Æo parcial da transa‡Æo, para facilitar a rastreabilidade e consulta da transa‡Æo pelo DC */
            IF NOT AVAIL tt-trans THEN DO:
               CREATE tt-trans.
               ASSIGN tt-trans.cod-versao-integracao = 1
                      tt-trans.i-sequen = 1
                      tt-trans.cd-trans = 'WMOut001':U
                      tt-trans.detalhe = vDetalhe
                      tt-trans.usuario = ttwork.cod-usuario.
                      tt-trans.etiqueta = NO.
            END.
            
            ASSIGN v-count = 0.
            FOR EACH tt-transf-wms-bkp:
               IF tt-transf-wms-bkp.ind-tip-movto = 1 THEN DO: /* NÆo gerando registro de transa‡Æo para movimentos de sa¡da que nÆo possuem entrada */
                  FIND FIRST b-tt-transf-wms-bkp
                       WHERE b-tt-transf-wms-bkp.cod-livre-2   = STRING(ROWID(tt-transf-wms-bkp))
                         AND b-tt-transf-wms-bkp.ind-tip-movto = 2 NO-ERROR.
                  IF NOT AVAIL b-tt-transf-wms-bkp THEN
                     NEXT.
               END.
               ASSIGN v-count = v-count + 1.
               IF tt-transf-wms-bkp.ind-tip-movto = 1 THEN
                  ASSIGN v-tipo = "Sa¡da":U. 
               ELSE
                  ASSIGN v-tipo = "Entrada":U.
               
               CREATE tt-trans-filho.
               ASSIGN tt-trans-filho.i-sequen-pai = 1
                      tt-trans-filho.i-sequen     = v-count    
                      tt-trans-filho.num-versao   = 1.
               
               IF tt-transf-wms-bkp.num-serial <> 0 THEN
                  ASSIGN tt-trans-filho.conteudo-xml = 'Tip:' + CHR(30) + STRING(v-tipo) + CHR(30) + 
                                                       'Box:' + CHR(30) + STRING(tt-transf-wms-bkp.num-box-orig)  + CHR(30) +
                                                       'Ser:' + CHR(30) + STRING(tt-transf-wms-bkp.num-serial,'>>>>>>>>>>>>>9':U).
               ELSE
                 ASSIGN tt-trans-filho.conteudo-xml = 'Tip:' + chr(30) + STRING(v-tipo) + chr(30)  
                                                      + 'Box:' + chr(30) + STRING(tt-transf-wms-bkp.num-box-orig)  + chr(30) 
                                                      + 'Item'            + CHR(30) + tt-transf-wms-bkp.cod-item              + CHR(30)
                                                      + 'Embalagem'       + CHR(30) + string(tt-transf-wms-bkp.cod-embalagem) + CHR(30) 
                                                      + 'Quantidade'      + CHR(30) + String(tt-transf-wms-bkp.qtd-item)      + CHR(30)
                                                      + 'Lote'            + CHR(30) + tt-transf-wms-bkp.cod-lote              + CHR(30)
                                                      + 'Referencia'      + CHR(30) + tt-transf-wms-bkp.cod-refer.
            END.
            /* faz validações na bc-trans e volta a transação se não obtiver êxito (manter por compatibilidade) */
            RUN gravaTransacao. 
            ASSIGN vLogFinaliza = YES. 
            
            ASSIGN ENTRY(2,vDesLidos,"/") = STRING(INTEGER(ENTRY(2,vDesLidos,"/")) - vNumLidos)
                   vNumLidos = 0.
            
            DISP vDeslidos WITH FRAME Frame01.
            
            IF RETURN-VALUE = "NOK":U THEN DO:
               /* Verificando retorno com erro e desfazendo toda a transa‡Æo */
               IF AVAIL tt-transf-wms-bkp THEN
                  UNDO bloco-wms, RETURN "OK":U.
               ELSE
                  UNDO bloco-wms, RETURN RETURN-VALUE.
            END.
            ELSE DO:
               IF ENTRY(2,vDesLidos,"/") = "0" THEN
                  EMPTY TEMP-TABLE tt-trans.

               RETURN RETURN-VALUE.
            END.
         END.
      END.
   END.
   ELSE DO:
      {bcp/bc9105.i "987" "Transferˆncia Cancelada. (bc9025f)"}
      RETURN "CAN":U.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                       **
***************************************************************************************************/
PROCEDURE gravatransacao:
   RUN cria_reg_wms IN wgbcapi001 ( INPUT 1,
                                    INPUT-OUTPUT TABLE tt-trans,
                                    INPUT-OUTPUT TABLE tt-trans-filho,
                                    INPUT-OUTPUT TABLE tt-erro).
   
   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro THEN DO: 
      FOR EACH tt-erro:
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
         
         DO ON ENDKEY UNDO,RETRY:
            {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
         END.
      END.
      RETURN "NOK":U.
   END.
   
   FIND FIRST ttWm-etiqueta-bkp NO-LOCK NO-ERROR.
   
   RUN bcp/bc9025g.p (INPUT-OUTPUT TABLE tt-trans,
                      INPUT-OUTPUT TABLE tt-erro).
   
   FIND FIRST tt-erro no-error.   
   IF AVAIL tt-erro OR RETURN-VALUE = 'NOK':U THEN DO ON ENDKEY UNDO,RETRY: 
      {bcp/bc9105.i "903" "Problemas na Efetiva‡Æo. (WMS)"}
      FOR EACH tt-erro:
         {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
      END.
      RETURN "NOK":U.
   END.
   ELSE DO:
      {bcp/bc9105.i "902" "Transferˆncia OK"}
   END.
   EMPTY TEMP-TABLE tt-erro.
   
   RETURN RETURN-VALUE.
END PROCEDURE.

/************************************************************************************************************************************/
/************************************************************************************************************************************/
/************************************************************************************************************************************/
PROCEDURE pi_trata_erro_bloco_wms:
   DEF INPUT PARAM pcPrograma AS CHARACTER NO-UNDO.
   DEF INPUT PARAM phPrograma AS HANDLE    NO-UNDO.
   
   DEF VAR cCodErro AS CHARACTER NO-UNDO.
   DEF VAR cMsgErro AS CHARACTER NO-UNDO.
   DEF VAR lerror   AS LOGICAL   NO-UNDO.
   
   IF RETURN-VALUE = 'NOK' THEN DO:   
      RUN getRowErrors in phPrograma (OUTPUT TABLE RowErrors).
   
      FOR EACH RowErrors:
         ASSIGN lerror = TRUE.
         DO ON ENDKEY UNDO,RETRY:
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)  + "(WMS) (Programa: " + pcPrograma + ")"}
         END.  
      END.
   
      IF lerror THEN DO:
         ASSIGN vLogErro = YES.
         RETURN "NOK":U.       
      END.
   
      
      ASSIGN cCodErro = "0"
             cMsgErro = "ERRO RETORNADO PELO PROGRAMA: " + pcPrograma + "(DC)".
   
      DO ON ENDKEY UNDO,RETRY:
         {bcp/bc9015.i2 cCodErro cMsgErro}
      END.
   
      ASSIGN vLogErro = YES.
      RETURN "NOK":U.          
   END.
   ELSE DO: 
      RUN getRowErrors IN phPrograma (OUTPUT TABLE RowErrors).                   
      
      FOR EACH RowErrors
         BREAK BY RowErrors.ErrorNumber:
         
         DO ON ENDKEY UNDO,RETRY:
           {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription) + "(WMS) (Programa: " + pcPrograma + ")"}
         END.                                
         
         IF LAST(RowErrors.ErrorNumber) THEN DO:
            ASSIGN vLogErro = YES.
            RETURN "NOK":U.       
         END.
      END.
   END.
END PROCEDURE.

/*Gozdecki*/
PROCEDURE pi-getValorParametro :
/*------------------------------------------------------------------------------
  Purpose:     Busca o parametro cadastrado na bc-param-ext
  Parameters:  Retorna o valor do parametro
  
  Notes:       Faz tres buscas at² achar o parametro.
                - Busca o parametro para item
                - Busca o parametro para a familia
                - Busca o parametro para a transacao
                - Se n’o achou, retorna 0
------------------------------------------------------------------------------*/
   DEFINE INPUT  PARAMETER p-cItCodigo    AS CHARACTER  NO-UNDO. /*codigo do item*/
   DEFINE INPUT  PARAMETER p-cTransacao   AS CHARACTER  NO-UNDO. /*transacao*/
   DEFINE INPUT  PARAMETER p-cCodParamExt AS CHARACTER  NO-UNDO. /*codigo do parametro*/
   DEFINE OUTPUT PARAMETER p-iParametro   AS INTEGER    NO-UNDO. 

   /* Procura se existe o item cadastrado para esse parametro */
   FIND FIRST bc-param-ext
        WHERE bc-param-ext.cod-entidade-param-ext   = "bc-tipo-trans":U
          AND bc-param-ext.cod-chave-param-ext      = p-cItCodigo
          AND bc-param-ext.cod-param-ext            = p-cCodParamExt NO-LOCK NO-ERROR.
   IF NOT AVAIL bc-param-ext THEN DO: /* Se n’o achar, busca pela familia */
      /* Procura o cadastro de item para poder pegar a familia */
      FIND FIRST wm-item
           WHERE wm-item.cod-item = p-cItCodigo NO-LOCK NO-ERROR.
      
      /* Procura os parametros para a familia */
      FIND FIRST bc-param-ext
           WHERE bc-param-ext.cod-entidade-param-ext = "bc-ext-familia":U
             AND bc-param-ext.cod-chave-param-ext    = wm-item.cod-familia
             AND bc-param-ext.cod-param-ext          = p-cCodParamExt NO-LOCK NO-ERROR.
      
      /* Se n’o achou, busca pela transacao */
      IF NOT AVAIL bc-param-ext THEN DO:
         FIND FIRST bc-param-ext
              WHERE bc-param-ext.cod-entidade-param-ext = "bc-tipo-trans":U 
                AND bc-param-ext.cod-chave-param-ext    = p-cTransacao
                AND bc-param-ext.cod-param-ext          = p-cCodParamExt NO-LOCK NO-ERROR.
         IF NOT AVAIL bc-param-ext THEN DO: /* Se n’o encontrou, adiciona o valor default */
            ASSIGN p-iParametro = 0.
         END.
      END.
   END.
   
   IF AVAIL bc-param-ext THEN DO: 
       IF bc-param-ext.ind-tipo-dado = 5 THEN DO: /* Param Logico */
           ASSIGN p-iParametro = IF bc-param-ext.param-logico THEN 1 ELSE 2.
       END.
   
   END.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
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
      WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.
   
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
      ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = STRING(ttWork.num-box-orig).
END PROCEDURE.
