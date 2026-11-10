/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025I 2.00.00.012 } /*** "010012" 01/04/2024 13:31:18  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025i MBC}
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

DEFINE TEMP-TABLE ttTransfMovimento NO-UNDO LIKE tt-transf-wms-bkp.

DEFINE BUFFER bf-ttTransfMovimento FOR ttTransfMovimento.
DEFINE BUFFER bf-ttTransf-wms-bkp FOR tt-transf-wms-bkp.

DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-transf-wms-bkp.

/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE SHARED VARIABLE vNumLidos        AS INTEGER                                NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogProcesso AS LOGICAL                      INIT NO   NO-UNDO.

DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER                    INIT ''   NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vLogAnswer              AS LOGICAL                      INIT YES  NO-UNDO.
DEFINE VARIABLE vLogAnswer-esc          AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vLogFirstTime           AS LOGICAL                      INIT YES  NO-UNDO.
DEFINE VARIABLE c-ind-tipo-contr-est    AS INTEGER                                NO-UNDO.
DEFINE VARIABLE vLogFimTran             AS LOGICAL                      INIT NO   NO-UNDO.
DEFINE VARIABLE vCodSenha               AS CHARACTER FORMAT 'x(12)':U             NO-UNDO.
DEFINE VARIABLE vEndereco               AS CHARACTER FORMAT 'x(12)':U             NO-UNDO.
DEFINE VARIABLE vCodBloco               AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE vCodRua                 AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE vCodNivel               AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE vCodColuna              AS CHARACTER                              NO-UNDO. 
DEFINE VARIABLE cDispItem               AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE cEmbalSel               AS INTEGER                                NO-UNDO.
DEFINE VARIABLE cTotalItem              AS INTEGER   FORMAT '9999'                NO-UNDO.
DEFINE VARIABLE cBoxOrig                AS CHARACTER                              NO-UNDO.
DEFINE VARIABLE cIndex                  AS INTEGER                                NO-UNDO.
DEFINE VARIABLE wgbosc035               AS HANDLE                                 NO-UNDO. 
DEFINE VARIABLE wgbosc044               AS HANDLE                                 NO-UNDO. 

DEFINE QUERY qSaldoItem FOR ttTransfMovimento.
DEFINE BROWSE bSaldoItem QUERY qSaldoItem NO-LOCK
    DISPLAY cDispItem @ ttTransfMovimento.cod-item FORMAT "x(19)"
      WITH SIZE 20 BY 3 NO-BOX NO-LABELS NO-SCROLLBAR-VERTICAL.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Embalag. p/ Entrada '                            At Row 01  Col 01          ~
                             'Emb:'                                            at row 02  col 01          ~
                             ttEmbSelec.cNumEmbal                              at row 02  col 05 no-label ~
                             bSaldoItem                                        at row 03  col 01          ~
                             'It:'                                             at row 06  col 01           ~
                             ttTransfMovimento.cod-item                        at row 06  col 04 format "x(15)" no-label  ~
                             'Ref:'                                            at row 07  col 01           ~
                             ttTransfMovimento.cod-refer                       at row 07  col 05 no-label  ~
                             'Tot.It:'                                         at row 08 col 01           ~
                             cTotalItem                                        at row 08 col 8 no-label
&global-define Frame01Repeat yes 

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                               ~
               bSaldoItem                                   ~
               
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' AND vLogFinaliza = YES Then RETURN 'OK':U.  ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U.                        ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                                                             ~
                            ON 'return':U OF bSaldoItem IN Frame Frame01                                                                ~
                            DO:                                                                                                         ~
                                find last ttWork no-error.                                                                              ~
                                assign ttWork.cod-embalagem = ttTransfMovimento.cod-embalagem                                           ~
                                       vLogFinaliza = yes                                                                               ~
                                       vLogSai      = yes                                                                               ~
                                       vLogFimTran  = yes.                                                                              ~
                                assign ttWork.cod-refer = ttTransfMovimento.cod-refer:screen-value in frame Frame01                     ~
                                       ttWork.cod-item = ttTransfMovimento.cod-item:screen-value in frame Frame01.                      ~
                                find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttTransfMovimento)).                             ~
                                If ttTransfMovimento.qti-embalagem > integer(entry(1,ttEmbSelec.cNumEmbal,"/")) Then                               ~
                                    assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) + 1).  ~
                                assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).               ~
                                apply 'value-changed' to bSaldoItem in frame Frame01.                                                   ~
                            End.                                                                                                        ~
                            ON '1':U OF bSaldoItem in Frame Frame01                                                                     ~
                            DO:                                                                                                         ~
                                apply 'return' to bSaldoItem in frame Frame01.                                                          ~
                            END.                                                                                                        ~
                            ON '0':U OF bSaldoItem in Frame Frame01                                                                     ~
                            DO:                                                                                                         ~
                                find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttTransfMovimento)).                             ~
                                If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) > 0 Then                                                  ~
                                    assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) - 1).  ~
                                assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).               ~
                                apply 'value-changed' to bSaldoItem in frame Frame01.                                                   ~
                            END.                                                                                                        ~
                            ON 'row-display':U OF bSaldoItem in Frame Frame01                                                           ~
                            DO:                                                                                                         ~
                               assign cDispItem = "":U.                                                                                 ~
                               If ttTransfMovimento.cod-lote <> "" Then                                                                 ~
                                  assign cDispItem = cDispItem + ttTransfMovimento.cod-lote + "/".                                      ~
                               assign cDispItem = cDispItem + string(ttTransfMovimento.qtd-item) + "/" + ttTransfMovimento.cod-embalagem.  ~
                               RETURN.                                                                                                  ~
                            END.                                                                                                        ~
                            on 'value-changed' of bSaldoItem in Frame Frame01                                                           ~
                            do:                                                                                                         ~
                               assign cTotalItem = 0.                                                                                   ~
                               find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttTransfMovimento)) no-error.                     ~
                               If avail ttEmbSelec Then do:                                                                             ~
                                   assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = ttEmbSelec.cNumEmbal.                    ~
                                   For each bf-ttTransfMovimento where bf-ttTransfMovimento.cod-item = ttTransfMovimento.cod-item and bf-ttTransfMovimento.cod-lote = ttTransfMovimento.cod-lote and ~
                                          bf-ttTransfMovimento.cod-refer = ttTransfMovimento.cod-refer:                                 ~
                                        find ttEmbSelec where ttEmbSelec.cChave = string(rowid(bf-ttTransfMovimento)) no-lock no-error. ~
                                        If avail ttEmbSelec Then                                                                        ~
                                            assign cTotalItem = cTotalItem + integer(entry(1,cNumEmbal,"/")) * bf-ttTransfMovimento.qtd-item.     ~
                                   End.                                                                                                 ~
                               End.                                                                                                     ~
                               else do:                                                                                                 ~
                                   assign cNumEmbal:screen-value in frame Frame01 = "0/0"                                               ~
                                           .                                                                                            ~
                               End.                                                                                                     ~
                               display cTotalItem with frame Frame01.                                                                   ~
                               if avail ttTransfMovimento then display ttTransfMovimento.cod-item ttTransfMovimento.cod-refer with frame Frame01. ~
                            End.                                                                                                        ~
                            ON 'ESC':U OF Frame Frame01                                                                                 ~
                            DO:                                                                                                         ~
                                find first ttWork no-lock no-error.                                                                     ~
                                For each ttEmbSelec no-lock:                                                                            ~
                                    If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) = 0 Then                                              ~
                                        run piVerificarTransf (input ttTransfMovimento.qtd-item,                                        ~
                                                                     ttTransfMovimento.qtd-item,                                        ~
                                                                     0).                                                                ~
                                    else do:                                                                                            ~
                                        Do cIndex = 1 to integer(entry(1,ttEmbSelec.cNumEmbal,"/")):                                    ~
                                            find ttTransfMovimento where rowid(ttTransfMovimento) = to-rowid(ttEmbSelec.cChave) no-lock no-error.           ~
                                            run piVerificarTransf (input ttTransfMovimento.qtd-item,                                    ~
                                                                   input ttTransfMovimento.qtd-item,                                    ~
                                                                   input 1).                                                            ~
                                        End.                                                                                            ~
                                    End.                                                                                                ~
                                End.                                                                                                    ~
                                empty temp-table ttEmbSelec.                                                                            ~
                                assign vLogFinaliza = yes                                                                               ~
                                       vLogFimTran  = yes.                                                                              ~
                                return "OK":U.                                                                                          ~
                            END.                                                                                                        ~
                            ON 'F2':U OF Frame Frame01                                                                                  ~
                            DO:                                                                                                         ~
                                apply 'esc' to frame Frame01.                                                                           ~
                            END.                                                                                                        ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc035
&global-define ActiveObject2 wgbosc044
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
   IF NOT AVAIL ttWork THEN DO:
      APPLY "GO" TO FRAME Frame01.
   END.
   
   ASSIGN vNumLidos = 0.                                                                                   
   
   IF vLogFirstTime THEN DO: /* Testando se n∆o Ç a primeira entrada no programa */
      RUN goToKey IN wgbosc044 (INPUT ttWork.cod-item).
      IF RETURN-VALUE = "NOK":U OR ttWork.cod-item = "777777" THEN
         ASSIGN vLogFirstTime = NO.
   End.
   
   /* Agrupando as quantidades dos itens existentes no box informado e n∆o permitindo que seja realizada entrada de itens no mesmo box onde
   foi realizada a sa°da */
   FOR EACH tt-transf-wms-bkp 
      WHERE tt-transf-wms-bkp.ind-tip-movto = 1 
        AND tt-transf-wms-bkp.num-box-orig <> ttWork.num-box-orig no-lock:
      
      FIND FIRST bf-ttTransf-wms-bkp 
           WHERE bf-ttTransf-wms-bkp.cod-item = tt-transf-wms-bkp.cod-item 
             AND bf-ttTransf-wms-bkp.cod-refer = tt-transf-wms-bkp.cod-refer 
             AND bf-ttTransf-wms-bkp.cod-lote = tt-transf-wms-bkp.cod-lote 
             AND bf-ttTransf-wms-bkp.cod-embalagem = tt-transf-wms-bkp.cod-embalagem 
             AND bf-ttTransf-wms-bkp.cod-cliente = tt-transf-wms-bkp.cod-cliente
             AND bf-ttTransf-wms-bkp.ind-tip-movto = 2 
             AND bf-ttTransf-wms-bkp.cod-livre-1 = "":U NO-ERROR.
      IF AVAIL bf-ttTransf-wms-bkp THEN DO:
         ASSIGN tt-transf-wms-bkp.cod-livre-1   = STRING(ROWID(tt-transf-wms-bkp))
                bf-ttTransf-wms-bkp.cod-livre-1 = STRING(ROWID(tt-transf-wms-bkp)).
         /* Atribuindo o RowID ao campo cod-livre-1 das tabelas para n∆o validar o mesmo registro de sa°da para mais de um registro de entrada */
         NEXT.
      END.
   
      /* Consolidando os registros para que n∆o sejam apresentados em n£mero de embalagens unit†rias */
      /* Testando se n∆o tem o movimento de entrada verificado na l¢gica anterior */
      FIND FIRST ttTransfMovimento
           WHERE ttTransfMovimento.cod-item = tt-transf-wms-bkp.cod-item
             AND ttTransfMovimento.cod-refer = tt-transf-wms-bkp.cod-refer
             AND ttTransfMovimento.cod-lote = tt-transf-wms-bkp.cod-lote
             AND ttTransfMovimento.cod-embalagem = tt-transf-wms-bkp.cod-embalagem
             AND ttTransfMovimento.cod-cliente = tt-transf-wms-bkp.cod-cliente EXCLUSIVE-LOCK NO-ERROR.
      IF NOT AVAIL ttTransfMovimento THEN DO:
         CREATE ttTransfMovimento.
         BUFFER-COPY tt-transf-wms-bkp TO ttTransfMovimento.
      END.
      ELSE
         ASSIGN ttTransfMovimento.qti-embalagem = ttTransfMovimento.qti-embalagem + 1.
      
      FIND ttEmbSelec WHERE ttEmbSelec.cChave = STRING(ROWID(ttTransfMovimento)) NO-ERROR. 
      IF NOT AVAIL ttEmbSelec THEN DO:
         CREATE ttEmbSelec. 
         ASSIGN ttEmbSelec.cChave = STRING(ROWID(ttTransfMovimento)) NO-ERROR.  
      END.
      ASSIGN ttEmbSelec.cNumEmbal = "0/" + STRING(ttTransfMovimento.qti-embalagem).    
   END.
   
   IF NOT CAN-FIND(FIRST ttTransfMovimento) THEN DO:
      {bcp/bc9105.i "303" "Movimento Transfància inexistente (bc9025.i)"}
      RETURN ERROR.
   END.
   
   OPEN QUERY qSaldoItem
     FOR EACH ttTransfMovimento NO-LOCK.
   
   APPLY 'VALUE-CHANGED' TO bSaldoItem IN FRAME Frame01.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   DEFINE VARIABLE cTotalQtde AS INTEGER            NO-UNDO.
   DEFINE VARIABLE lSai       AS LOGICAL INITIAL NO NO-UNDO.
   DEFINE VARIABLE cNumEmbal  AS INTEGER            NO-UNDO.
   DEFINE VARIABLE i          AS INTEGER            NO-UNDO.
   
   IF vlogFinaliza OR vLogFimTran THEN
      LEAVE.
   
   ASSIGN vLogErro     = No
          vLogOk       = No
          vLogFinaliza = NO .
END PROCEDURE.

PROCEDURE piVerificarTransf:
   DEFINE INPUT PARAMETER pQtdItem          AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pQtdItemEmbalagem AS INTEGER NO-UNDO.
   DEFINE INPUT PARAMETER pQtiEmbalagem     AS INTEGER NO-UNDO.
   
   DEFINE VARIABLE cTotalEmbalagem AS INTEGER INITIAL 0 NO-UNDO.
   DEFINE VARIABLE cIndex          AS INTEGER           NO-UNDO.
   
   IF NOT CAN-FIND ( FIRST tt-transf-wms-bkp
                     WHERE tt-transf-wms-bkp.cod-item          = ttTransfMovimento.cod-item
                       AND tt-transf-wms-bkp.qtd-item          = pQtdItem
                       AND tt-transf-wms-bkp.cod-lote          = ttTransfMovimento.cod-lote
                       AND tt-transf-wms-bkp.cod-refer         = ttTransfMovimento.cod-refer
                       AND tt-transf-wms-bkp.cod-embalagem     = ttTransfMovimento.cod-embalagem
                       AND tt-transf-wms-bkp.cod-cliente       = ttTransfMovimento.cod-cliente
                       AND tt-transf-wms-bkp.qtd-item-retirado = pQtdItemEmbalagem
                       AND tt-transf-wms-bkp.qti-embalagem     = pQtiEmbalagem
                       AND tt-transf-wms-bkp.ind-tip-movto     = 2)
      AND pQtiEmbalagem <> 0 THEN DO:
      RUN piCriarTransf (INPUT pQtdItem,
                         INPUT pQtdItemEmbalagem,
                         INPUT 1).
   END.
   ELSE DO:
      FOR EACH tt-transf-wms-bkp
         WHERE tt-transf-wms-bkp.cod-item          = ttTransfMovimento.cod-item
           AND tt-transf-wms-bkp.qtd-item          = pQtdItem
           AND tt-transf-wms-bkp.cod-lote          = ttTransfMovimento.cod-lote
           AND tt-transf-wms-bkp.cod-refer         = ttTransfMovimento.cod-refer
           AND tt-transf-wms-bkp.cod-embalagem     = ttTransfMovimento.cod-embalagem
           AND tt-transf-wms-bkp.cod-cliente       = ttTransfMovimento.cod-cliente
           AND tt-transf-wms-bkp.qtd-item-retirado = pQtdItemEmbalagem
           AND tt-transf-wms-bkp.qti-embalagem     = 1 /* Quantidade de embalagens sempre deve ser 1, para permitir m£ltiplas sa°das x entradas */
           AND tt-transf-wms-bkp.ind-tip-movto     = 2 NO-LOCK:
      
         IF ROWID(ttTransfMovimento) <> TO-ROWID(ttEmbSelec.cChave) THEN
            NEXT.
      
         ASSIGN cTotalEmbalagem = cTotalEmbalagem + 1.
      
         IF cTotalEmbalagem > INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) THEN DO:
            DELETE tt-transf-wms-bkp.
            ASSIGN vNumLidos = vNumLidos - 1.
         END.      
      END.
      
      IF INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) > cTotalEmbalagem  THEN DO:
         DO cIndex = 1 TO (INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) - cTotalEmbalagem):
            RUN piCriarTransf(INPUT pQtdItem,
                              INPUT pQtdItemEmbalagem,
                              INPUT 1).
         END.
      END.
   END.
END PROCEDURE.

Procedure piCriarTransf:
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
          tt-transf-wms-bkp.cod-item          = ttTransfMovimento.cod-item
          tt-transf-wms-bkp.qtd-item          = pQtdItem
          tt-transf-wms-bkp.cod-lote          = ttTransfMovimento.cod-lote
          tt-transf-wms-bkp.cod-refer         = ttTransfMovimento.cod-refer
          tt-transf-wms-bkp.cod-embalagem     = ttTransfMovimento.cod-embalagem
          tt-transf-wms-bkp.cod-cliente       = ttTransfMovimento.cod-cliente
          tt-transf-wms-bkp.qtd-item-retirado = 0
          tt-transf-wms-bkp.qti-embalagem     = pQtiEmbalagem
          tt-transf-wms-bkp.ind-tip-movto     = 2
          tt-transf-wms-bkp.dat-transacao     = TODAY.   
   ASSIGN vNumLidos = vNumLidos + 1.
END PROCEDURE.
