/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9033I 2.00.00.010 } /*** "010010" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9033i MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9033i.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - Junho/2006 - Bravo - Criaá∆o do programa                    **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking ~\ Packing WMS            **
**   Observacao: Programa Origem: bc9018i.p                                                **
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
&global-define ProgramName BC9033

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-picking-wms
{bcp/bc9033.i " "}
{bcp/bc9033.i1 }
{bcp/bc9015.i3} /* def variaveis padroes */
/* login */
{utp/utapi009.i}

{bcp/bc9018h.i} /*mk - definicao das procedures utilizadas */
DEFINE INPUT PARAMETER vRowid AS ROWID NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-picking-wms-table.

DEFINE BUFFER bf-ttResumo FOR ttResumo.
DEFINE BUFFER bf-ttEmbSelec FOR ttEmbSelec.

FIND FIRST ttWm-box-movto-idx-picking WHERE ROWID(ttWm-box-movto-idx-picking) = vRowid NO-ERROR.

FIND FIRST ttWork NO-ERROR.

/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE VARIABLE vLogAnswer       AS LOGICAL                    INITIAL YES  NO-UNDO.
DEFINE VARIABLE vLogAnswer-esc   AS LOGICAL                    INITIAL NO   NO-UNDO.
DEFINE VARIABLE vLogFimTran      AS LOGICAL                    INITIAL NO   NO-UNDO.
DEFINE VARIABLE vCodSenha        AS CHARACTER FORMAT 'x(12)':U              NO-UNDO.
DEFINE VARIABLE vEndereco        AS CHARACTER FORMAT 'x(12)':U              NO-UNDO.
DEFINE VARIABLE vCodBloco        AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE vCodRua          AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE vCodNivel        AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE vCodColuna       AS CHARACTER                               NO-UNDO. 
DEFINE VARIABLE cDispItem        AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE cEmbalSel        AS INTEGER                                 NO-UNDO.
DEFINE VARIABLE cTotalItem       AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE cBoxOrig         AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE cIndex           AS INTEGER                                 NO-UNDO.

/* opcao do tipo de leitura. Esse valor vem da bc9033h.p */
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura  AS INTEGER NO-UNDO. 

DEFINE VARIABLE p-qtd-item     AS DECIMAL NO-UNDO.
DEFINE VARIABLE iLogHabilitaUn AS LOGICAL NO-UNDO.

DEFINE VARIABLE wgbosc035      AS HANDLE  NO-UNDO.
DEFINE VARIABLE wgbosc044      AS HANDLE  NO-UNDO.
DEFINE VARIABLE wgbosc145      AS HANDLE  NO-UNDO. 
DEFINE VARIABLE wgbosc148      AS HANDLE  NO-UNDO.
DEFINE VARIABLE wgbc9033f      AS HANDLE  NO-UNDO.

DEFINE QUERY qSaldoItem FOR ttResumo.
DEFINE BROWSE bSaldoItem QUERY qSaldoItem NO-LOCK
    DISPLAY cDispItem @ ttResumo.cod-item
      WITH SIZE 20 BY 2 NO-BOX NO-LABELS NO-SCROLLBAR-VERTICAL.

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
                             'Lt:'                                             at row 05  col 01           ~
                             ttResumo.cod-lote                                 at row 05  col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'It:'                                             at row 06  col 01           ~
                             ttResumo.cod-item                                 at row 06  col 04 format "x(15)" no-label   ~
                             'Qtd:'                                            at row 07  col 01           ~
                             ttWork.qtd-item                                   at row 07  col 05 no-label  ~
                             'Tot.It:'                                         at row 08  col 01           ~
                             cTotalItem                                        at row 08  col  8 no-label

&global-define Frame01Repeat yes 

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                               ~
               bSaldoItem                                   
               
/************************************************************/

/* fk ini: frame */
DEFINE FRAME fCodEan
  ttWork.cod-livre-1 FORMAT "x(10)" NO-LABEL.

/* mk - Frame Emb~\Un */
DEFINE FRAME fEmbUn
    'Emb:'             AT ROW 01 COL 01
    ttWork.cod-livre-1 AT ROW 01 COL 05 NO-LABEL FORMAT "x(4)"
    'Un:'              AT ROW 02 COL 02
    ttWork.cod-livre-2 AT ROW 02 COL 05 NO-LABEL FORMAT "x(4)".

ON 'END-ERROR':U OF ttwork.cod-livre-1 IN FRAME fCodEan
DO: 
   RETURN NO-APPLY.
END.
/* fk fim */

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK' AND vLogFinaliza = YES Then RETURN 'OK':U.            ~
                                                            If Return-value = 'NOK'Then RETURN 'NOK':U.                                  ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                                                              ~
/* Tecla enter no browser */ ~
ON 'RETURN':U OF bSaldoItem IN FRAME Frame01                                                                ~
DO:                                                                                                         ~
   RUN pi-BrowserEnterEvent IN THIS-PROCEDURE.                                                              ~
END.                                                                                                        ~
/* Tecla 1 no browser */                                                                                    ~
ON '1':U OF bSaldoItem in Frame Frame01                                                                     ~
DO:                                                                                                         ~
   APPLY 'RETURN' TO bSaldoItem IN FRAME Frame01.                                                           ~
END.                                                                                                        ~
/* Tecla 2 do browser */                                                                                    ~
ON '0':U OF bSaldoItem in Frame Frame01                                                                     ~
DO:                                                                                                         ~
   RUN pi-BrowserZeroEvent IN THIS-PROCEDURE.                                                               ~
END.                                                                                                        ~
/* Display do Saldo de browser */                                                                           ~
ON 'ROW-DISPLAY':U OF bSaldoItem IN FRAME Frame01                                                           ~
DO:                                                                                                         ~
   RUN pi-BrowserRowDisplayEvent IN THIS-PROCEDURE.                                                         ~
END.                                                                                                        ~
/* Mudanca de valor do browser */                                                                           ~
ON 'VALUE-CHANGED' OF bSaldoItem IN FRAME Frame01                                                           ~
DO:                                                                                                         ~
   RUN pi-BrowserValueChangedEvent IN THIS-PROCEDURE.                                                       ~
END.                                                                                                        ~
/* Tecla esc */                                                                                             ~
ON 'ESC':U OF FRAME Frame01                                                                                 ~
DO:                                                                                                         ~
   RUN pi-BrowserEscEvent IN THIS-PROCEDURE.                                                                ~
END.                                                                                                        ~


/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc035
&global-define ActiveObject2 wgbosc044
&global-define ActiveObject3 wgbosc145
&global-define ActiveObject4 wgbosc148
&global-define ActiveObject5 wgbc9033f
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN InitHandles IN THIS-PROCEDURE.

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
   ASSIGN cBoxOrig:SCREEN-VALUE IN FRAME Frame01 = STRING(ttWork.num-box-lido)
          cTotalItem = "0/" + STRING((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking).   
   
   RUN getOcupacaoBox IN wgbosc035 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                    INPUT ttWm-box-movto-idx-picking.cod-local,
                                    INPUT ttWork.num-box-lido,
                                    OUTPUT TABLE ttResumo).
   
   /* Agrupando as quantidades dos itens existentes no box informado e verificando existància de alguma seleá∆o */
   FOR EACH ttResumo EXCLUSIVE-LOCK:   
      /* Se o saldo n∆o estiver liberado n∆o dever† ser mostrado */
      IF ttResumo.ind-status-saldo <> 3 THEN DO:
         DELETE ttResumo.
         NEXT.
      END.
            
      IF ttResumo.cod-embalagem <> ttWm-box-movto-idx-picking.cod-embalagem THEN DO:
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
             cEmbalSel = 0.
      
      ASSIGN ttResumo.qtd-item = ttResumo.qtd-item - ttResumo.qtd-item-bloq.
      IF ttResumo.qtd-item <= 0 THEN DO: /* Se o saldo do item for igual a zero, n∆o Ç preciso disponibilizar no zoom */
         DELETE ttResumo.
         NEXT.
      END.
            
      /* Consolidando os registros com as mesmas caracter°sticas em um mesmo registro (item, referencia, lote, embalagem e quantidades) */
      FOR EACH bf-ttResumo
         WHERE bf-ttResumo.cod-item      = ttResumo.cod-item
           AND bf-ttResumo.cod-embalagem = ttResumo.cod-embalagem
           AND bf-ttResumo.qtd-item      = ttResumo.qtd-item
           AND bf-ttResumo.qtd-item-bloq = ttResumo.qtd-item-bloq
           AND bf-ttResumo.qtd-original  = ttResumo.qtd-original
           AND bf-ttResumo.cod-refer     = ttResumo.cod-refer
           AND bf-ttResumo.cod-lote      = ttResumo.cod-lote
           AND ROWID(bf-ttResumo) <> ROWID(ttResumo):
         ASSIGN ttResumo.qti-embalagem = ttResumo.qti-embalagem + bf-ttResumo.qti-embalagem.
         DELETE bf-ttResumo.
      END.   
   END.
   
   OPEN QUERY qSaldoItem
     FOR EACH ttResumo
        WHERE ttResumo.cod-item = ttWm-box-movto-idx-picking.cod-item
          AND ttResumo.cod-refer = ttWm-box-movto-idx-picking.cod-refer NO-LOCK.
   
   APPLY 'VALUE-CHANGED' TO bSaldoItem IN FRAME Frame01.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   DEFINE VARIABLE cTotalQtde AS DECIMAL            NO-UNDO.
   DEFINE VARIABLE lSai       AS LOGICAL INITIAL NO NO-UNDO.
   DEFINE VARIABLE cNumEmbal  AS INTEGER            NO-UNDO.
   DEFINE VARIABLE i          AS INTEGER            NO-UNDO.
   
   IF vlogFinaliza OR vLogFimTran THEN DO:
      APPLY 'GO' TO FRAME Frame01.
   END.
END PROCEDURE.

/* **************************************************************************************************** */
/*                                                                                                      */
/* **************************************************************************************************** */
PROCEDURE piVerificarTransf:
   DEFINE INPUT PARAMETER pQtdItem          AS DECIMAL NO-UNDO.
   DEFINE INPUT PARAMETER pQtdItemEmbalagem AS DECIMAL NO-UNDO.
   DEFINE INPUT PARAMETER pQtiEmbalagem     AS INTEGER NO-UNDO.
   
   DEFINE VARIABLE cTot AS INTEGER NO-UNDO.
   
   IF pQtdItem = 0 THEN
      LEAVE.
   
   IF NOT CAN-FIND ( FIRST tt-picking-wms-table 
                     WHERE tt-picking-wms-table.cod-item       = ttResumo.cod-item
                       AND tt-picking-wms-table.qtd-item       = pQtdItem
                       AND tt-picking-wms-table.cod-embalagem  = ttResumo.cod-embalagem
                       AND tt-picking-wms-table.qtd-item-digit = pQtdItemEmbalagem
                       AND tt-picking-wms-table.qtd-embalagem  = pQtiEmbalagem
                       AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto)
      AND pQtiEmbalagem <> 0 THEN DO:
      RUN piCriarTransf (INPUT pQtdItem,
                         INPUT pQtdItemEmbalagem,
                         INPUT 1).
   END.
   ELSE DO:
      FOR EACH tt-picking-wms-table
         WHERE tt-picking-wms-table.cod-item       = ttResumo.cod-item
           AND tt-picking-wms-table.qtd-item       = pQtdItem
           AND tt-picking-wms-table.cod-embalagem  = ttResumo.cod-embalagem
           AND tt-picking-wms-table.qtd-item-digit = pQtdItemEmbalagem
           AND tt-picking-wms-table.qtd-embalagem  = pQtiEmbalagem /* Esta Quantidade sempre vai ser 1 */
           AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-LOCK:
      
         /* N∆o considerar registros de transferància que n∆o est∆o associados ao item especificado */  
         IF ROWID(ttResumo) <> TO-ROWID(ttEmbSelec.cChave) THEN
            NEXT. 
         
         ASSIGN cTot = cTot + 1.
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

/* **************************************************************************************************** */
/*                                                                                                      */
/* **************************************************************************************************** */
PROCEDURE piCriarTransf:
   DEFINE INPUT PARAMETER pQtdItem          AS DECIMAL NO-UNDO.
   DEFINE INPUT PARAMETER pQtdItemEmbalagem AS DECIMAL NO-UNDO.
   DEFINE INPUT PARAMETER pQtiEmbalagem     AS INTEGER NO-UNDO.
   
   RUN pi-cria-tt-picking-ems-table IN wgbc9033f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                  INPUT ttWm-box-movto-idx-picking.cod-local,
                                                  INPUT ttWm-box-movto-idx-picking.id-movto,
                                                  INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                  INPUT ttwm-box-movto-idx-picking.id-docto,
                                                  INPUT ttWork.num-serial,
                                                  INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                  INPUT pQtdItem,
                                                  INPUT pQtdItemEmbalagem , 
                                                  INPUT ttWm-box-movto-idx-picking.cod-item,
                                                  INPUT ttWork.num-box-lido /* ttWm-box-movto-idx-picking.id-box */ ,
                                                  INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                  INPUT ttWm-box-movto-idx-picking.qti-embalagem,
                                                  INPUT ttWm-box-movto-idx-picking.dt-atualizacao,
                                                  INPUT ttWm-box-movto-idx-picking.dt-transacao,
                                                  INPUT ttWork.num-tempo-inicio,
                                                  INPUT ttWork.cod-coletor,
                                                  INPUT ttWork.cod-equipamento,
                                                  INPUT ttResumo.cod-lote,
                                                  INPUT-OUTPUT TABLE tt-picking-wms-table,
                                                  OUTPUT TABLE tt-erro).
END PROCEDURE.

/* **************************************************************************************************** */
/* Busca a quantidade digitada em tela. Caso o codigo for por ean, pega do ean              */
/* **************************************************************************************************** */
PROCEDURE pi-getQtdItem:
   DEFINE VARIABLE deValorAnterior AS DECIMAL    NO-UNDO.
   
   /* Armazena o valor anterior */
   ASSIGN deValorAnterior = ttWork.qtd-item.
   
   /* Se for por quantidade, pega a quantidade digitada em tela */
   IF iIndTipoLeitura = 2 THEN DO:
      /* Repete atÇ o usuario informar o valor correto */
      REPEAT ON ENDKEY UNDO, NEXT:
         UPDATE ttWork.qtd-item NO-LABEL WITH FRAME eu VIEW-AS DIALOG-BOX FONT 2 SIZE 13 BY 2.1 TITLE "Qtd...". 
         
         /* Se a quantidade atendida for maior que a quantidade requisitada, sai fora  */
         IF (ttWork.qtd-item - deValorAnterior + DECIMAL(ENTRY(1,cTotalItem,"/"))) <= DECIMAL(ENTRY(2,cTotalItem,"/")) THEN DO:
            LEAVE.
         END.
      END.
   END.
   
   /* Confirma as informacoes digitadas */
   RUN pi-atualizaQtdTela IN THIS-PROCEDURE.
END PROCEDURE.
/* fk fim */

/* **************************************************************************************************** */
/* fk inicio - Busca a quantidade digitada em tela. Caso o codigo for por ean, pega do ean              */
/* **************************************************************************************************** */
PROCEDURE pi-getQtdCodigoEanDun:
   /* Variaveis */
   DEFINE VARIABLE iTipoInformacao     AS INTEGER               NO-UNDO.
   DEFINE VARIABLE cCodItem            AS CHARACTER             NO-UNDO.
   DEFINE VARIABLE cCodEmbalagem       AS CHARACTER             NO-UNDO.
   DEFINE VARIABLE deQtdInformacao     AS DECIMAL               NO-UNDO. /*Quantidade na etiqueta ean-dun*/
   DEFINE VARIABLE deQtdLidaEtiqueta   AS DECIMAL    INITIAL 0  NO-UNDO. /*Qtd lida para essa etiqueta*/
   
   /* Repete ateh completar a qtd do movimento ou a qtd da etiqueta */
   REPEAT:
      /* Executa o evento de mudanca no browser */
      RUN pi-atualizaQtdTela IN THIS-PROCEDURE.
      RUN pi-BrowserValueChangedEvent IN THIS-PROCEDURE.
      
      /* Se a quantidade for maior que a quantidade do movimento, sai fora */
      IF DECIMAL(ENTRY(1,cTotalItem,"/")) >= DECIMAL(ENTRY(2,cTotalItem,"/")) THEN DO:
         LEAVE.
      END.
      
      /* Faz a leitura da etiqueta ean-dun */
      UPDATE ttWork.cod-livre-1 WITH FRAME fCodEan
          VIEW-AS DIALOG-BOX FONT 2 SIZE 13 BY 3 TITLE "EAN/DUN" . 
      
      /* Se for 999999, efetiva o q foi lido e sai fora */
      IF ttWork.cod-livre-1 = "999999" THEN DO:
         LEAVE.
      END.
      
      /* Busca as informacoes referente ao codigo ean */
      RUN EmptyRowErrors IN wgbosc148.
      RUN readBarCode IN wgbosc148(INPUT ttResumo.cod-estabel,
                                   INPUT ttResumo.cod-local,
                                   INPUT ttwork.cod-livre-1, /*codigo ean/dun lido*/
                                   OUTPUT iTipoInformacao,
                                   OUTPUT cCodItem, 
                                   OUTPUT cCodEmbalagem,
                                   OUTPUT deQtdInformacao,
                                   OUTPUT TABLE RowErrors).
      
      /* Tratamento de erro */
      RUN getRowErrors IN wgbosc148 (OUTPUT TABLE RowErrors) NO-ERROR.
      FOR EACH RowErrors:
         HIDE ALL NO-PAUSE.
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         RUN bcp/bc9115.p (ErrorNumber,
                           ErrorDescription,
                           8,
                           20,
                           3).
         HIDE ALL NO-PAUSE.
         NEXT.
      END.
      
      /* Verifica se o item do codigo ean/dun eh o mesmo item do serial */
      IF cCodItem <> ttResumo.cod-item THEN DO:
         {bcp/bc9105.i "0" "Item do codigo ean/dun lido n∆o confere com o item do c¢digo serial (DC)"}
         NEXT.
      END.
      
      ASSIGN deQtdLidaEtiqueta = deQtdLidaEtiqueta + deQtdInformacao.
      
      /* Se a qtd lida for maior q a qtd da etiqueta, considera apenas a qtd da etiqueta */
      IF deQtdLidaEtiqueta > ttResumo.qtd-item THEN DO:
         ASSIGN ttWork.qtd-item = ttResumo.qtd-item.
         LEAVE.
      END.
      ELSE DO: 
         ASSIGN ttWork.qtd-item = deQtdLidaEtiqueta.
         
         /* Se a qtd lida for igual a qtd da etiqueta, sai fora */
         IF deQtdLidaEtiqueta >= ttResumo.qtd-item THEN DO:
            LEAVE.
         END.
      END.
      
      /* Se completou a qtd da etiqueta, sai fora */
      IF (DECIMAL(ENTRY(1,cTotalItem,"/"))) >= ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) + (ttWm-box-movto-idx-picking.qtd-item-picking)) THEN DO:
         LEAVE.
      END.
   END.
   /* Confirma as informacoes digitadas */
   RUN pi-atualizaQtdTela IN THIS-PROCEDURE.
END PROCEDURE.

/* **************************************************************************************************** */
/* Busca a quantidade digitada em tela por Emb e Un (se parametrizado).                     */
/* **************************************************************************************************** */
PROCEDURE pi-getQtdEmbUn:
   DEFINE VARIABLE deValorAnterior AS DECIMAL    NO-UNDO.
   
   /* Armazena o valor anterior */
   ASSIGN deValorAnterior = ttWork.qtd-item.
   
   RUN pi-getLogHabilitaUn.
   
   /* Repete atÇ o usuario informar o valor correto */
   REPEAT:   
      /* Parametro definido para habilitar ou n∆o para o usuario informar a unidade */
      IF iLogHabilitaUn THEN DO:
         UPDATE ttWork.cod-livre-1
                ttWork.cod-livre-2 NO-LABEL                
            WITH FRAME fEmbUn VIEW-AS DIALOG-BOX FONT 2 SIZE 21 BY 4 TITLE "Emb~\Un". 
      END.
      ELSE DO:
         UPDATE ttWork.cod-livre-1 NO-LABEL
            WITH FRAME fEmbUn VIEW-AS DIALOG-BOX FONT 2 SIZE 21 BY 4 TITLE "Emb~\Un". 
      END.
      
      /* Metodo para transformar a emb/un em quantidade */
      RUN EmptyRowErrors IN wgbosc145.
      RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                            INPUT ttWm-box-movto-idx-picking.cod-local,   
                                            INPUT ttWm-box-movto-idx-picking.cod-item,    
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.cod-livre-1,  
                                            INPUT ttWork.cod-livre-2,
                                            OUTPUT p-qtd-item).
      IF RETURN-VALUE <> "OK":U THEN DO:
         RUN getRowErrors In wgbosc145 (Output Table RowErrors) No-error.
         FOR Each RowErrors:
            HIDE ALL NO-PAUSE.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            RUN bcp/bc9115.p (ErrorNumber,
                              ErrorDescription,
                              8,
                              20,
                              3).
            HIDE ALL NO-PAUSE.
            NEXT.
         END. 
      END.
      ELSE DO:      
         /* Pega valor retornado do metodo. Emb~\Un convertida para Quantidade */
         ASSIGN ttWork.qtd-item = p-qtd-item.
         
         /* Se a quantidade atendida for maior que a quantidade requisitada, sai fora  */
         IF (ttWork.qtd-item - deValorAnterior + DECIMAL(ENTRY(1,cTotalItem,"/"))) <= DECIMAL(ENTRY(2,cTotalItem,"/")) THEN DO:
            LEAVE.
         END.
      END.
   END.
   
   /* Confirma as informacoes digitadas */
   RUN pi-atualizaQtdTela IN THIS-PROCEDURE.
END PROCEDURE.
/* mk fim */

/* **************************************************************************************************** */
/* Atualiza as informacoes em tela                                                          */
/* **************************************************************************************************** */
PROCEDURE pi-atualizaQtdTela:
   /* Confirma as informacoes digitadas */
   ASSIGN ttWork.qtd-item:SCREEN-VALUE IN FRAME Frame01 = STRING(ttWork.qtd-item) 
          ttEmbSelec.qtdItem = ttWork.qtd-item. 
END PROCEDURE.


/* **************************************************************************************************** */
/* Quando digita enter no browser                                                           */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserEnterEvent:
   /* Se nao tiver o ttResumo disponivel, sai fora  */
   IF NOT AVAIL ttResumo THEN
      RETURN NO-APPLY.
   
   /* Se a quantidade atendida for maior que a quantidade requisitada, sai fora  */   
   /* Verifica se abre embalagem */
   RUN getAbreEmbalagem IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                      INPUT ttWm-box-movto-idx-picking.cod-local, 
                                      INPUT ttWm-box-movto-idx-picking.cod-item, 
                                      INPUT ttWm-box-movto-idx-picking.cod-embalagem, 
                                      OUTPUT v-log-abre-embalagem).  
      
   /* Verifica o tipo de leitura */ 
   IF iIndTipoLeitura = 3 THEN DO: 
      /* Faz a leitura por codigo ean/dun */ 
      RUN pi-getQtdCodigoEanDun. 
   END. 
   ELSE IF iIndTipoLeitura = 4 THEN DO:
      /* Faz a leitura por emb/un*/
      RUN pi-getQtdEmbUn.
   END.
   ELSE DO:    
      If ttResumo.qtd-item + DECIMAL(ENTRY(1,cTotalItem,"/")) > ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - (ttWm-box-movto-idx-picking.qtd-item-picking ) ) THEN DO: 
         /* So executa se abre embalagem */
         IF v-log-abre-embalagem THEN DO:
            RUN pi-getQtdItem IN THIS-PROCEDURE.
         END.
         ELSE DO:
            RETURN NO-APPLY. 
         END.
      END.
      ELSE DO:
          /* Adiciona o valor igual ao a quantidade da embalagem  */
          ASSIGN ttEmbSelec.qtdItem = ttResumo.qtd-item.
      END.
   END.
   
   /* Procura as informacoes disponiveis em tela */
   FIND LAST ttWork no-error.
   
   /* Atribui as informacoes da embalagem na tela */
   ASSIGN ttWork.cod-embalagem = ttResumo.cod-embalagem
          ttWork.cod-item      = ENTRY  (1,ttResumo.cod-item:SCREEN-VALUE IN BROWSE bSaldoItem,"/")
          ttWork.qtd-embalagem = INTEGER(entry(2,ttEmbSelec.cNumEmbal:SCREEN-VALUE IN FRAME Frame01,"/")).  
   
   /* Procura pela embalagem selecionada na tela */
   FIND ttEmbSelec WHERE ttEmbSelec.cChave = STRING(ROWID(ttResumo)) NO-ERROR.                                       
   
   /* Atualiza as informacoes em tela */
   IF ttWork.qtd-embalagem > INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) THEN DO:                                
      ASSIGN ENTRY(1,ttEmbSelec.cNumEmbal,"/") = STRING(INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) + 1).   
   END.
   
   /* Atualiza o numero de embalagem */
   ASSIGN ttEmbSelec.cNumEmbal:SCREEN-VALUE IN FRAME Frame01 = STRING(ttEmbSelec.cNumEmbal).                
   
   /* Executa o evento de mudanca no browser */
   APPLY 'VALUE-CHANGED' TO bSaldoItem IN FRAME Frame01.                                                    
END PROCEDURE.

/* **************************************************************************************************** */
/* Quando digita o numero zero no browser                                                           */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserZeroEvent:
   /* Se nao tiver nada, returna */
   IF NOT AVAIL ttResumo THEN
      RETURN NO-APPLY.                                                              
   
   /* Procura pela embalagem selecionada em tela */
   FIND ttEmbSelec WHERE ttEmbSelec.cChave = STRING(ROWID(ttResumo)) NO-ERROR.                                       
   
   /* Atualiza, caso o numero de embalagem for maior que zero */
   IF INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) > 0 THEN DO:
      ASSIGN ENTRY(1,ttEmbSelec.cNumEmbal,"/") = STRING(INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")) - 1).   
   END.
   
   /* Zera a quantidade de itens selecionados */
   IF ttEmbSelec.qtdItem <> 0 THEN DO:
      ASSIGN ttEmbSelec.qtdItem = 0.                                                                       
   END.
   
   /* Atualiza o codigo da emgalagem */
   ASSIGN ttEmbSelec.cNumEmbal:SCREEN-VALUE IN FRAME Frame01 = STRING(ttEmbSelec.cNumEmbal).                
   
   /* Executa o evento de mudanca de tela */
   APPLY 'VALUE-CHANGED' TO bSaldoItem IN FRAME Frame01.                                                    
END PROCEDURE.


/* **************************************************************************************************** */
/* Quando as informacoes sao disponibilizadas em tela                                                   */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserRowDisplayEvent:
   /* Se nao tiver informacoes, retorna */
   IF NOT AVAIL ttResumo THEN
      RETURN NO-APPLY.                                                               
   
   /* Atualiza as informacoes em tela */
   ASSIGN cDispItem = "":U                                                                                   
          cDispItem = cDispItem + STRING(ttResumo.qtd-item) + "/" + ttResumo.cod-embalagem.                  
   
   /* Procura a embalagem selecinada em tela */
   FIND ttEmbSelec WHERE ttEmbSelec.cChave = STRING(ROWID(ttResumo)) NO-LOCK NO-ERROR.                       
   
   /* Se nao tiver sido criado, cria como valor igual a zero */
   IF NOT AVAIL ttEmbSelec THEN DO:                                                                          
      CREATE ttEmbSelec.                                                                                    
      ASSIGN ttEmbSelec.cChave    = STRING(ROWID(ttResumo))                                                    
             ttEmbSelec.cNumEmbal = "0/" + STRING(ttResumo.qti-embalagem).                                  
   END.                                                                                                      
   ELSE DO:
      /* Atualiza o valor tem tela */
      ASSIGN ttEmbSelec.cNumEmbal:SCREEN-VALUE IN FRAME Frame01 = STRING(ttEmbSelec.cNumEmbal).            
   END.
END PROCEDURE.

/* **************************************************************************************************** */
/* Quando as informacoes sao ocorrem alteracoes nos valores em tela                                     */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserValueChangedEvent:
   DEFINE VARIABLE cTotItem AS DECIMAL NO-UNDO.                                                              
   
   /* Procura pela embalagem selecionada */
   FIND ttEmbSelec WHERE ttEmbSelec.cChave = STRING(ROWID(ttResumo)) NO-ERROR.                               
   
   IF AVAIL ttEmbSelec THEN DO:                                                                              
      ASSIGN cNumEmbal:SCREEN-VALUE IN FRAME Frame01 = ttEmbSelec.cNumEmbal.                                
      
      FOR EACH bf-ttResumo
         WHERE bf-ttResumo.cod-item = ttResumo.cod-item
           AND bf-ttResumo.cod-lote = ttResumo.cod-lote
           AND bf-ttResumo.cod-refer = ttResumo.cod-refer:
      
         FIND FIRST bf-ttEmbSelec
              WHERE bf-ttEmbSelec.cChave = STRING(ROWID(bf-ttResumo)) NO-LOCK NO-ERROR.
         IF AVAIL bf-ttEmbSelec THEN DO:
            /* Se a quantidade for diferente de zero */
            IF bf-ttEmbSelec.qtdItem <> 0 THEN DO:
               ASSIGN cTotItem = cTotItem + bf-ttEmbSelec.qtdItem. 
            END.
         END.
      END.
      
      /* Atualiza a quantidade em tela */
      ASSIGN ttWork.qtd-item         = ttEmbSelec.qtdItem
             ENTRY(1,cTotalItem,"/") = STRING(cTotItem).
      
      /* Visualiza em tela */
      DISP ttWork.qtd-item WITH FRAME Frame01.
   END.
   ELSE DO:
      /* Adiciona valores defaults */
      ASSIGN ttEmbSelec.cNumEmbal:SCREEN-VALUE IN FRAME Frame01 = "0/0".
   END.
   
   /* Visualiza em tela */
   IF AVAIL ttResumo THEN                                                                                    
      DISPLAY cTotalItem
              ttResumo.cod-lote
              ttResumo.cod-item
         WITH FRAME Frame01.
END PROCEDURE.

/* **************************************************************************************************** */
/* Quando o usuario digitar esc no browser                                                              */
/* **************************************************************************************************** */
PROCEDURE pi-BrowserEscEvent:
   /* Para cada embalagem selecionada */
   FOR EACH ttEmbSelec NO-LOCK:                                                                             
      /* Procura as informacoes da embalagem selecionada */
      FIND ttResumo WHERE ROWID(ttResumo) = TO-ROWID(ttEmbSelec.cChave) NO-LOCK NO-ERROR.                  
      
      /* Para todas as embalagens selecionadas, verifica o que foi transferido */
      DO cIndex = 1 TO INTEGER(ENTRY(1,ttEmbSelec.cNumEmbal,"/")):                                     
         RUN piVerificarTransf(IF ttEmbSelec.qtdItem = 0 THEN ttResumo.qtd-item ELSE ttEmbSelec.qtdItem, 
                               IF ttEmbSelec.qtdItem = 0 THEN ttResumo.qtd-item ELSE ttEmbSelec.qtdItem, 
                               INPUT 1).                                                              
      END.                                                                                             
   END.
   
   /* Esvazia a tabela */
   EMPTY TEMP-TABLE ttEmbSelec.                                                                             
   
   /* Flega para sair do campo */
   ASSIGN vLogSai     = YES                                                                                     
          vLogfimTran = YES.                                                                                
END PROCEDURE.

/* Busca Parametro HABILITA-UNIDADE - Inicio */
PROCEDURE pi-getLogHabilitaUn:
   DEFINE VARIABLE iNumLogHabilitaUn AS INTEGER     NO-UNDO.
   
   /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
   RUN pi-getValorParametro (INPUT ttWm-box-movto-idx-picking.cod-item,
                             INPUT "wmsai009":U,
                             INPUT "HABILITA-UNIDADE":U,
                             OUTPUT iNumLogHabilitaUn).
   
   /* Se n∆o achar o parametro, assume o valor 1 - Habilita Unidade */
   IF iNumLogHabilitaUn = 0 THEN DO:
      ASSIGN iLogHabilitaUn = NO.
   END.
   
   /* Caso o parametro seja informado incorretamente, informa ao usuario */
   IF iNumLogHabilitaUn <> 1 AND iNumLogHabilitaUn <> 2 AND iNumLogHabilitaUn <> 0  THEN DO:
      {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
      ASSIGN iLogHabilitaUn = YES.
   END.
   
   IF iNumLogHabilitaUn = 1 THEN
      ASSIGN iLogHabilitaUn = YES.
   
   IF iNumLogHabilitaUn = 2 THEN
      ASSIGN iLogHabilitaUn = NO.
END PROCEDURE.

/* Inicializa Handles utilizados no programa */
PROCEDURE InitHandles:
   IF NOT VALID-HANDLE(wgbosc035) THEN DO:
      RUN scbo/bosc035.p PERSISTENT SET wgbosc035.
      RUN openQueryStatic IN wgbosc035 (INPUT "Main":U) NO-ERROR. 
   END.      
   IF NOT VALID-HANDLE(wgbosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044.
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR. 
   END. 
   IF NOT VALID-HANDLE(wgbosc145) THEN DO:
      RUN scbo/bosc145.p PERSISTENT SET wgbosc145.
      RUN openQueryStatic IN wgbosc145 (INPUT "Main":U) NO-ERROR. 
   END. 
   IF NOT VALID-HANDLE(wgbosc148) THEN   
      RUN scbo/bosc148.p PERSISTENT SET wgbosc148 NO-ERROR.

   IF NOT VALID-HANDLE(wgbc9033f) THEN
      RUN bcp/bc9033f.p PERSISTENT SET wgbc9033f NO-ERROR.
END PROCEDURE.
