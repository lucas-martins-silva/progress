/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025H 2.00.00.014 } /*** "010014" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025h MBC}
&ENDIF


{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Janeiro/2004 - Farley - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
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
**                        Ex: tt-transf-wms.                                                      **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por    **
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

DEFINE SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
DEFINE SHARED TEMP-TABLE tt-transf-wms-bkp NO-UNDO LIKE tt-transf-wms.

DEFINE BUFFER bf-ttResumo FOR ttResumo.

/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE NEW SHARED VARIABLE vLogProcesso AS LOGICAL                      INIT NO  NO-UNDO.

DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER                    INIT ''  NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAnswer              AS LOGICAL                      INIT YES NO-UNDO.
DEFINE VARIABLE vLogAnswer-esc          AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogFirstTime           AS LOGICAL                      INIT YES NO-UNDO.
DEFINE VARIABLE c-ind-tipo-contr-est    AS INTEGER                               NO-UNDO.
DEFINE VARIABLE vLogFimTran             AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vRowIds                 AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE vCodSenha               AS CHARACTER FORMAT 'x(12)':U            NO-UNDO.
DEFINE VARIABLE vEndereco               AS CHARACTER FORMAT 'x(12)':U            NO-UNDO.
DEFINE VARIABLE vCodBloco               AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE vCodRua                 AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE vCodNivel               AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE vCodColuna              AS CHARACTER                             NO-UNDO. 
DEFINE VARIABLE cDispItem               AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cEmbalSel               AS INTEGER                               NO-UNDO.
DEFINE VARIABLE cTotalItem              AS INTEGER   FORMAT '9999'               NO-UNDO.
DEFINE VARIABLE cBoxOrig                AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE cIndex                  AS INTEGER                               NO-UNDO.

DEFINE VARIABLE wgbosc035 AS HANDLE NO-UNDO. 
DEFINE VARIABLE wgbosc145 AS HANDLE NO-UNDO. 
DEFINE VARIABLE wgbosc044 AS HANDLE NO-UNDO. 

DEFINE SHARED VARIABLE vNumLidos AS INTEGER NO-UNDO.

DEFINE QUERY qSaldoItem FOR ttResumo.
DEFINE BROWSE bSaldoItem QUERY qSaldoItem NO-LOCK
    DISPLAY cDispItem @ ttResumo.cod-item FORMAT "x(19)" 
      WITH SIZE 20 BY 3 NO-BOX NO-LABELS NO-SCROLLBAR-VERTICAL.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Saldo Box '                                      At Row 01  Col 01           ~
                             cBoxOrig                                          at row 01  col 11 no-label  ~
                             'Emb:'                                            at row 02  col 01           ~
                             ttEmbSelec.cNumEmbal                              at row 02  col 05 no-label  ~
                             bSaldoItem                                        at row 03  col 01           ~
                             'It:'                                             at row 06  col 01           ~
                             ttResumo.cod-item                                 at row 06  col 04 format "x(15)" no-label  ~
                             'Ref:'                                            at row 07  col 01           ~
                             ttResumo.cod-refer                                at row 07  col 05 no-label  ~
                             'Tot.It:'                                         at row 08  col 01           ~
                             cTotalItem                                        at row 08  col  8 no-label

&global-define Frame01Repeat yes 

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                               ~
               bSaldoItem                                   
               
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' AND vLogFinaliza = YES Then RETURN 'OK':U.            ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U.                                  ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                                                              ~
                            ON 'return':U OF bSaldoItem IN Frame Frame01                                                                 ~
                            DO:                                                                                                          ~
                                find last ttWork no-error.                                                                               ~
                                assign ttWork.cod-embalagem = ttResumo.cod-embalagem.                                                    ~
                                assign ttWork.cod-refer = ttResumo.cod-refer:screen-value in frame Frame01                               ~
                                       ttWork.cod-item = ttResumo.cod-item:screen-value in frame Frame01.                               ~
                                find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)).                                       ~
                                If ttResumo.qti-embalagem > integer(entry(1,ttEmbSelec.cNumEmbal,"/")) Then                                ~
                                    assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) + 1).   ~
                                assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).                ~
                                apply 'value-changed' to bSaldoItem in frame Frame01.                                                    ~
                            End.                                                                                                         ~
                            ON '1':U OF bSaldoItem in Frame Frame01                                                                      ~
                            DO:                                                                                                          ~
                                apply 'return' to bSaldoItem in frame Frame01.                                                           ~
                            END.                                                                                                         ~
                            ON '0':U OF bSaldoItem in Frame Frame01                                                                      ~
                            DO:                                                                                                          ~
                                find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)).                                       ~
                                If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) > 0 Then                                                   ~
                                    assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) - 1).   ~
                                assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).                ~
                                apply 'value-changed' to bSaldoItem in frame Frame01.                                                    ~
                            END.                                                                                                         ~
                            ON 'row-display':U OF bSaldoItem in Frame Frame01                                                            ~
                            DO:                                                                                                          ~
                               Assign cDispItem = "". ~
                               If ttResumo.cod-lote <> "" Then                                                                           ~
                                  assign cDispItem = cDispItem + ttResumo.cod-lote + "/".                                                ~
                               assign cDispItem = cDispItem + string(ttResumo.qtd-item) + "/" + ttResumo.cod-embalagem.                  ~
                            END.                                                                                                         ~
                            on 'value-changed' of bSaldoItem in Frame Frame01                                                            ~
                            do:                                                                                                          ~
                               Assign cTotalItem = 0.                                                                                    ~
                               find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) no-error.                               ~
                               If avail ttEmbSelec Then do:                                                                              ~
                                    assign cNumEmbal:screen-value in frame Frame01 = ttEmbSelec.cNumEmbal.                                ~
                                    For each bf-ttResumo where bf-ttResumo.cod-item = ttResumo.cod-item and bf-ttResumo.cod-lote = ttResumo.cod-lote and ~
                                          bf-ttResumo.cod-refer = ttResumo.cod-refer:                                                    ~
                                        find ttEmbSelec where ttEmbSelec.cChave = string(rowid(bf-ttResumo)) no-lock no-error.           ~
                                        If avail ttEmbSelec Then                                                                         ~
                                            assign cTotalItem = cTotalItem + integer(entry(1,cNumEmbal,"/")) * bf-ttResumo.qtd-item.     ~
                                    End.                                                                                                 ~
                               End.                                                                                                      ~
                               else do:                                                                                                  ~
                                    assign cNumEmbal:screen-value in frame Frame01 = "0/0".                                              ~
                               End.                                                                                                      ~
                               display cTotalItem ttResumo.cod-item ttResumo.cod-refer with frame Frame01.                               ~
                            End.                                                                                                         ~
                            ON 'ESC':U of Frame Frame01                                                                                  ~
                            DO:                                                                                                          ~
                                For each ttEmbSelec no-lock:                                                                             ~
                                    find ttResumo where rowid(ttResumo) = to-rowid(ttEmbSelec.cChave) no-lock no-error.                  ~
                                    If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) = 0 Then do:                                           ~
                                        run piVerificarTransf (input ttResumo.qtd-item,                                                  ~
                                                                     ttResumo.qtd-item,                                                  ~
                                                                     0).                                                                 ~
                                    End.                                                                                                 ~
                                    else do:                                                                                             ~
                                        Do cIndex = 1 to integer(entry(1,ttEmbSelec.cNumEmbal,"/")):                                     ~
                                            run piVerificarTransf(input ttResumo.qtd-item,                                               ~
                                                                  input ttResumo.qtd-item,                                               ~
                                                                  input 1).                                                              ~
                                                                                                                                         ~
                                        End.                                                                                             ~
                                    End.                                                                                                 ~
                                End.                                                                                                     ~
                                empty temp-table ttEmbSelec.                                                                             ~
                                assign vLogSai = yes                                                                                     ~
                                       vLogfimTran = yes.                                                                                ~
                            END.                                                                                                         ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc035
&global-define ActiveObject2 wgbosc044
&global-define ActiveObject3 wgbosc145
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc035.p PERSISTENT SET wgbosc035 NO-ERROR.
RUN openQueryStatic IN wgbosc035 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc145.p PERSISTENT SET wgbosc145 NO-ERROR.
RUN openQueryStatic IN wgbosc145 (INPUT "Main":U) NO-ERROR. 

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ≤ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:  
   FIND FIRST ttWork NO-ERROR.
   
   ASSIGN cBoxOrig:SCREEN-VALUE IN FRAME Frame01 = STRING(ttWork.num-box-orig).   
   
   RUN getOcupacaoBox IN wgbosc035 (INPUT ttWork.cod-estabel,
                                    INPUT ttWork.cod-local,
                                    INPUT ttWork.num-box-orig,
                                    OUTPUT TABLE ttResumo).   
   IF NOT CAN-FIND(FIRST ttResumo) THEN DO:
      {bcp/bc9105.i "303" "Item inexistente neste Box (WMS)"}
   
      RETURN ERROR.
   END.
   
   IF vLogFirstTime THEN DO: /* Testando se n∆o Ç a primeira entrada no programa */
      RUN goToKey IN wgbosc044 (INPUT ttWork.cod-item).
      IF RETURN-VALUE = "NOK":U OR ttWork.cod-item = "777777" THEN
         ASSIGN vLogFirstTime = NO.
   END.
   
   /* Agrupando as quantidades dos itens existentes no box informado e verificando existància de alguma seleá∆o */
   FOR EACH ttResumo EXCLUSIVE-LOCK:
       /* Se o saldo n∆o estiver liberado n∆o dever† ser mostrado */
      IF ttResumo.ind-status-saldo <> 3 THEN DO:
         DELETE ttResumo.
         NEXT.
      END.
      RUN existeEmbalagemItemLocal IN wgbosc145 (INPUT ttResumo.cod-estabel,
                                                 INPUT ttResumo.cod-local,
                                                 INPUT ttResumo.cod-item).
      IF RETURN-VALUE = "NOK":U THEN DO:
         DELETE ttResumo.
         NEXT.
      END.
      ASSIGN ttResumo.r-Rowid = ROWID(ttResumo)
             cEmbalSel        = 0.
      
      ASSIGN ttResumo.qtd-item = ttResumo.qtd-item - ttResumo.qtd-item-bloq.
      IF ttResumo.qtd-item <= 0 THEN DO: /* Se o saldo do item for igual a zero, n∆o Ç preciso disponibilizar no zoom */
         DELETE ttResumo.
         NEXT.
      END.
   
      /* Consolidando os registros com as mesmas caracter°sticas em um mesmo registro (item, referencia, lote, embalagem e quantidades) */
      FOR EACH bf-ttResumo 
         WHERE bf-ttResumo.cod-item = ttResumo.cod-item 
           AND bf-ttResumo.cod-embalagem = ttResumo.cod-embalagem 
           AND bf-ttResumo.qtd-item = ttResumo.qtd-item 
           AND bf-ttResumo.qtd-item-bloq = ttResumo.qtd-item-bloq 
           AND bf-ttResumo.qtd-original = ttResumo.qtd-original 
           AND bf-ttResumo.cod-refer = ttResumo.cod-refer 
           AND bf-ttResumo.cod-lote = ttResumo.cod-lote 
           AND bf-ttResumo.cod-cliente = ttResumo.cod-cliente 
           AND ROWID(bf-ttResumo) <> ROWID(ttResumo):
      
         ASSIGN ttResumo.qti-embalagem = ttResumo.qti-embalagem + bf-ttResumo.qti-embalagem.
         DELETE bf-ttResumo.
      END.
   
      FIND FIRST tt-transf-wms-bkp NO-LOCK NO-ERROR.
      
      /* Caso j† tenha sido lido alguma embalagem, dever† retornar na posiá∆o anterior */
      FIND ttEmbSelec WHERE ttEmbSelec.cChave = STRING(ROWID(ttResumo)) NO-ERROR. 
      FOR EACH tt-transf-wms-bkp 
         WHERE tt-transf-wms-bkp.cod-item          = ttResumo.cod-item 
           AND tt-transf-wms-bkp.cod-refer         = ttResumo.cod-refer 
           AND tt-transf-wms-bkp.cod-lote          = ttResumo.cod-lote 
           AND tt-transf-wms-bkp.cod-embalagem     = ttResumo.cod-embalagem 
           AND tt-transf-wms-bkp.qtd-item          = ttResumo.qtd-item 
           AND tt-transf-wms-bkp.qtd-item-retirado = ttResumo.qtd-item 
           AND tt-transf-wms-bkp.cod-cliente       = ttResumo.cod-cliente 
           AND tt-transf-wms-bkp.ind-tip-movto     = 1 EXCLUSIVE-LOCK:
         IF NOT AVAIL ttEmbSelec THEN DO:
            CREATE ttEmbSelec. 
            ASSIGN ttEmbSelec.cChave = STRING(ROWID(ttResumo)) NO-ERROR.  
         END.
         ASSIGN cEmbalSel = cEmbalSel + 1.
      END.
      IF NOT AVAIL ttEmbSelec THEN
         CREATE ttEmbSelec.
      
      ASSIGN ttEmbSelec.cNumEmbal = STRING(cEmbalSel) + "/" + STRING(ttResumo.qti-embalagem)
             ttEmbSelec.cChave    = STRING(ROWID(ttResumo)).
   END.
   
   IF NOT CAN-FIND(FIRST ttResumo) THEN DO:
      {bcp/bc9105.i "303" "Item inexistente neste Box (WMS - Ponto 2)"}
      RETURN ERROR.
   END.
   
   IF vLogFirstTime THEN 
      OPEN QUERY qSaldoItem
        FOR EACH ttResumo
           WHERE ttResumo.cod-item = ttWork.cod-item NO-LOCK.
   ELSE
      OPEN QUERY qSaldoItem
        FOR EACH ttResumo NO-LOCK.
   
   APPLY 'VALUE-CHANGED' TO bSaldoItem IN FRAME Frame01.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   DEFINE VARIABLE cTotalQtde AS INTEGER         NO-UNDO.
   DEFINE VARIABLE lSai       AS LOGICAL INIT NO NO-UNDO.
   DEFINE VARIABLE cNumEmbal  AS INTEGER         NO-UNDO.
   DEFINE VARIABLE i          AS INTEGER         NO-UNDO.
   
   IF vlogFinaliza OR vLogFimTran THEN DO:
      APPLY 'GO' TO FRAME Frame01.
   END.
END PROCEDURE.

PROCEDURE piVerificarTransf:
   DEFINE INPUT PARAMETER pQtdItem          AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pQtdItemEmbalagem AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pQtiEmbalagem     AS INTEGER NO-UNDO.
   
   DEFINE VARIABLE cTot AS INTEGER NO-UNDO.
   
   IF NOT CAN-FIND ( FIRST tt-transf-wms-bkp 
                     WHERE tt-transf-wms-bkp.cod-item          = ttResumo.cod-item
                       AND tt-transf-wms-bkp.qtd-item          = pQtdItem 
                       AND tt-transf-wms-bkp.cod-lote          = ttResumo.cod-lote 
                       AND tt-transf-wms-bkp.cod-refer         = ttResumo.cod-refer 
                       AND tt-transf-wms-bkp.cod-embalagem     = ttResumo.cod-embalagem 
                       AND tt-transf-wms-bkp.cod-cliente       = ttResumo.cod-cliente
                       AND tt-transf-wms-bkp.qtd-item-retirado = pQtdItemEmbalagem 
                       AND tt-transf-wms-bkp.qti-embalagem     = pQtiEmbalagem 
                       AND tt-transf-wms-bkp.ind-tip-movto     = 1) 
      AND pQtiEmbalagem <> 0 THEN DO:
      RUN piCriarTransf (INPUT pQtdItem,
                         INPUT pQtdItemEmbalagem,
                         INPUT 1).
   END.
   ELSE DO:
      FOR EACH tt-transf-wms-bkp 
         WHERE tt-transf-wms-bkp.cod-item          = ttResumo.cod-item 
           AND tt-transf-wms-bkp.qtd-item          = pQtdItem 
           AND tt-transf-wms-bkp.cod-lote          = ttResumo.cod-lote 
           AND tt-transf-wms-bkp.cod-refer         = ttResumo.cod-refer 
           AND tt-transf-wms-bkp.cod-embalagem     = ttResumo.cod-embalagem 
           AND tt-transf-wms-bkp.cod-cliente       = ttResumo.cod-cliente
           AND tt-transf-wms-bkp.qtd-item-retirado = pQtdItemEmbalagem 
           AND tt-transf-wms-bkp.qti-embalagem     = 1 /* Esta Quantidade sempre vai ser 1 */
           AND tt-transf-wms-bkp.ind-tip-movto     = 1 NO-LOCK:
      
         /* N∆o considerar registros de transferància que n∆o est∆o associados ao item especificado */  
         IF ROWID(ttResumo) <> TO-ROWID(ttEmbSelec.cChave) THEN
            NEXT. 
      
         ASSIGN cTot = cTot + 1.
         IF cTot > INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) THEN DO:
            DELETE tt-transf-wms-bkp.
            ASSIGN vNumLidos = vNumLidos - 1.
         END.
      END.
      IF INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) > cTot THEN DO:
         DO cIndex = 1 TO (INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) - cTot):
            RUN piCriarTransf (INPUT pQtdItem,
                               INPUT pQtdItemEmbalagem,
                               INPUT 1).
         END.
      END.
   END.
END PROCEDURE.

PROCEDURE piCriarTransf:
   DEFINE INPUT PARAMETER pQtdItem          AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pQtdItemEmbalagem AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pQtiEmbalagem     AS INTEGER NO-UNDO.
   
   CREATE tt-transf-wms-bkp.
   ASSIGN tt-transf-wms-bkp.cod-usuario       = ttWork.cod-usuario
          tt-transf-wms-bkp.cod-coletor       = ttWork.cod-coletor
          tt-transf-wms-bkp.cod-equipamento   = ttWork.cod-equipamento
          tt-transf-wms-bkp.cod-estabel       = ttWork.cod-estabel
          tt-transf-wms-bkp.cod-local         = ttWork.cod-local
          tt-transf-wms-bkp.num-box-orig      = ttWork.num-box-orig
          tt-transf-wms-bkp.num-serial        = 0 /* este valor estar† sem zero (0) */
          tt-transf-wms-bkp.des-endereco      = vEndereco
          tt-transf-wms-bkp.cod-item          = ttResumo.cod-item
          tt-transf-wms-bkp.qtd-item          = pQtdItem
          tt-transf-wms-bkp.cod-lote          = ttResumo.cod-lote
          tt-transf-wms-bkp.cod-refer         = ttResumo.cod-refer
          tt-transf-wms-bkp.cod-embalagem     = ttResumo.cod-embalagem
          tt-transf-wms-bkp.cod-cliente       = ttResumo.cod-cliente
          tt-transf-wms-bkp.qtd-item-retirado = 0
          tt-transf-wms-bkp.qti-embalagem     = pQtiEmbalagem
          tt-transf-wms-bkp.ind-tip-movto     = 1
          tt-transf-wms-bkp.dat-transacao     = TODAY.   
   
   ASSIGN vNumLidos       = vNumLidos       + 1. 
END PROCEDURE.
