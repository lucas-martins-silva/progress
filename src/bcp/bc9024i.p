/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024I 2.00.00.015 } /*** "010015" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024i MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9024i.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Criação do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Inventário WMS                   **
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
**                        que executa a procedure _GenerateDCTransaction que e´ responsavel por   **
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
&global-define ProgramName BC9024
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i}
{bcp/bc9018h.i}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

DEFINE INPUT PARAMETER pDesEndereco AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE INPUT PARAMETER vQtdItems    AS INTEGER                  NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER Table FOR ttWork.

DEFINE VARIABLE wgbosc145 AS WIDGET-HANDLE NO-UNDO.

FIND FIRST ttWork NO-ERROR.

DEFINE VARIABLE iIndTipoLeitura        AS INTEGER       NO-UNDO.
DEFINE VARIABLE iIndTipoLeituraUnidade AS INTEGER       NO-UNDO.
DEFINE VARIABLE qtdPesoItem            AS DECIMAL       NO-UNDO.
DEFINE VARIABLE qtdPesoEmbal           AS DECIMAL       NO-UNDO.
DEFINE VARIABLE d-qtd-peso             AS DECIMAL       NO-UNDO.
DEFINE VARIABLE vQtdItemEmbal          AS DECIMAL       NO-UNDO.
DEFINE VARIABLE pQtdItem               AS DECIMAL       NO-UNDO.
DEFINE VARIABLE vLogPadrao             AS LOGICAL       NO-UNDO.
DEFINE VARIABLE l-voltar               AS LOGICAL       NO-UNDO.
DEFINE VARIABLE i-ind-unid-cont        AS INTEGER       NO-UNDO.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/

/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Item:              '     At Row 01 Col 01                         ~
                             ttWork.cod-item           At Row 02 Col 01 No-label                ~
                             'Quantidade:        '     At Row 03 Col 01                         ~
                             ttWork.qtd-item           At Row 04 Col 01 No-label                ~
                             'Peso:              '     At Row 05 Col 01                         ~
                             ttWork.qtd-peso           AT ROW 06 COL 01 NO-LABEL                ~
                             'Lidos:'                  At Row 07 Col 01                         ~
                             vQtdItems                 At Row 07 Col 07 No-label Format   '>>>>9':U
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'It:                '     At Row 01 Col 01                         ~
                             ttWork.cod-item           At Row 01 Col 04 No-label FORMAT 'x(15)' ~
                             'Embalagens:        '     At Row 02 Col 01                         ~
                             ttWork.num-livre-1        At Row 03 Col 01 NO-LABEL FORMAT '>>>>9':U ~
                             'Unidades:'               At Row 04 Col 01                         ~
                             ttWork.num-livre-2        At Row 04 Col 10 No-label FORMAT '>>>>9':U ~
                             'Peso:              '     At Row 05 Col 01                         ~
                             ttWork.qtd-peso           AT ROW 06 COL 01 NO-LABEL                ~
                             'Lidos:'                  At Row 07 Col 01                         ~
                             vQtdItems                 At Row 07 Col 07 No-label Format '>>>>9':U
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name Frame03
&global-define Frame03Defs    'Inventario WMS     '                             At Row 01 Col 01~
                              'Tipo leitura?      '                             At Row 02 Col 01~
                              '2 - Por Quantidade '                             At Row 03 Col 01~
                              '4 - Por Emb/Un     '                             AT ROW 04 COL 01~
                              'Opcao              '                             At Row 08 Col 01~
                              iIndTipoLeitura                                   At Row 08 Col 14 No-label Format '9'~
&global-define Frame03Repeat No

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.qtd-item ttWork.qtd-peso
                                  
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 IF l-voltar = YES THEN do: Return 'NOK':U. END. Run InicializaCamposFrame01. if vLogSai or vLogFinaliza then return "ok".
&global-define TriggerBeforeFrame02 IF l-voltar = YES THEN Return 'NOK':U.
&global-define TriggerAfterFrame01  IF l-voltar = YES THEN Return 'NOK':U. If vLogSai = Yes Then Return 'OK':U.
&global-define TriggerAfterFrame02  IF l-voltar = YES THEN DO: /*LEAVE _frame02.*/ Return 'NOK':U. END.

/* Definicao das trigger de usuario ---                     */ 

&global-define UserTriggers ON 'leave':U OF ttWork.qtd-item IN Frame Frame01 ~
                            DO:                         ~
                                assign input frame Frame01 ttWork.qtd-item. ~
                                RUN piCalcularPeso (INPUT ttWork.qtd-item). ~
                                DISPLAY d-qtd-peso @ ttWork.qtd-peso with frame frame01. ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                /*Return 'ESC':U.*/         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'ESC':U OF Frame Frame03 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'F4':U OF Frame Frame01 ~
                            DO:                         ~
                                /*Return 'ESC':U.*/         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'F4':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
                            ON 'F4':U OF Frame Frame03 ~
                            DO:                         ~
                                ASSIGN l-voltar = YES.  ~
                            END.                        ~
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e´ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local é destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure e´ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
     ASSIGN vLogErro = NO vLogSai = NO vLogFinaliza = NO.     
     DISP 
         ttWork.cod-item 
         ttWork.qtd-item
         ttWork.qtd-peso
         vQtdItems  WITH FRAME frame01.

     IF NOT VALID-HANDLE(wgbosc145) THEN 
        RUN scbo/bosc145.p PERSISTENT SET wgbosc145.

    RUN setConstraintItem IN wgbosc145 (ttWork.cod-item).
    RUN openQueryStatic IN wgbosc145 (INPUT "item":U).
    IF  RETURN-VALUE <> 'OK':U THEN DO:
        RUN piEliminaHandles.
        {bcp/bc9105.i "103" "Item sem embalagem relacionada. (WMS)"}
        ASSIGN vLogErro = YES.
        RETURN ERROR.
    END.

     RUN pi-getIndTipoLeitura IN THIS-PROCEDURE.
     IF  RETURN-VALUE = 'NOK' THEN DO:
         ASSIGN vLogSai = YES
                vLogFinaliza = YES.
         HIDE ALL NO-PAUSE.
         RETURN ERROR.
     END.

     IF iIndTipoLeitura = 2 THEN DO: /* por Quantidade */
        /*DO ON ENDKEY UNDO, RETURN "ESC":*/
           UPDATE ttWork.qtd-item ttWork.qtd-peso WITH FRAME frame01.
        /*END.*/
        ASSIGN vLogErro = NO vLogSai = NO vLogFinaliza = NO.

        IF  ttWork.qtd-Item = 0 OR 
            ttWork.qtd-Item = ? THEN DO:
            //Hide All.
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "105" "Quantidade Inv lida (DC)"}
            VIEW FRAME {&Frame01Name}.
            PAUSE 0 NO-MESSAGE.
            //Hide All No-pause.
            //Return Error.
            RETURN "NOK".
        END.

        IF  ttWork.qtd-peso = 0 OR
            ttWork.qtd-peso = ? THEN DO:
            //Hide All.
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "105" "Peso Inv lido (DC)"}
            VIEW FRAME {&Frame01Name}.
            PAUSE 0 NO-MESSAGE.
            //Hide All No-pause.
            //Return Error.
            RETURN "NOK".
        END.

        IF  ttWork.qtd-peso = 0 THEN DO:
            HIDE ALL.
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "105" "Peso Inv lido (DC)"}
            VIEW FRAME {&Frame01Name}.
            PAUSE 0 NO-MESSAGE.
            HIDE ALL NO-PAUSE.
        END.
        
        IF  NOT vLogErro THEN DO:
            ASSIGN vLogSai      = YES
                   vLogFinaliza = YES.
            HIDE ALL NO-PAUSE.
        END.
     END. /**********************************  end tipo leitura 2*/
     ELSE DO: /* por Embalagem/Unidade */
         RUN pi-getValorParametro (ttWork.cod-item,
                                   "WmOut003",
                                  ("HABILITA-UNIDADE"),
                                   OUTPUT iIndTipoLeituraUnidade).

         IF  ttWork.num-serial <> 0 THEN DO:

             FIND wm-etiqueta
                 WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
             
             RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.cod-item,
                                                   INPUT wm-etiqueta.cod-embalagem,
                                                   INPUT ttWork.qtd-Item,
                                                   OUTPUT ttWork.num-livre-1,
                                                   OUTPUT ttWork.num-livre-2).
         END.

         IF iIndTipoLeituraUnidade = 1 THEN DO:
             HIDE ALL NO-PAUSE.
             DISP ttWork.cod-item WITH FRAME frame02.
            /* ASSIGN ttWork.num-livre-1 = 0
                    ttWork.num-livre-2 = 0.*/
             /*DO ON ENDKEY UNDO, RETURN "ESC":*/
                UPDATE ttWork.num-livre-1 ttWork.num-livre-2 WITH FRAME frame02.
             /*END.*/
         END.
         ELSE DO:
             HIDE ALL NO-PAUSE.
             DISP ttWork.cod-item WITH FRAME frame02.
             /*ASSIGN ttWork.num-livre-1 = 0
                    ttWork.num-livre-2 = 0. */
             /*DO ON ENDKEY UNDO, RETURN "ESC":*/
                UPDATE ttWork.num-livre-1 WITH FRAME frame02.
             /*END.*/
         END.

         ASSIGN vLogErro = NO vLogSai = NO vLogFinaliza = NO.

         IF  ttWork.num-serial <> 0 THEN DO:
             FIND wm-etiqueta
                 WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
             RUN emptyRowErrors IN wgbosc145.
             RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.cod-item,
                                                   INPUT wm-etiqueta.cod-embalagem,
                                                   INPUT ttWork.num-livre-1,
                                                   INPUT ttWork.num-livre-2,
                                                   OUTPUT pQtdItem).
             IF  RETURN-VALUE = 'NOK' THEN DO:
                 RUN getRowErrors IN wgbosc145(OUTPUT TABLE RowErrors).
                 FOR EACH RowErrors:
                     ASSIGN vLogErro = YES.
                     ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                     {bcp/bc9015.i2 STRING(ErrorNumber) string(ErrorDescription)}
                 END.
                 IF vLogErro = YES THEN DO :
                     RUN piEliminaHandles.
                     RETURN ERROR.
                 END.
             END.
         END.
         ELSE DO:
             FIND FIRST wm-item-embalagem-local
                  WHERE wm-item-embalagem-local.cod-estabel = ttWork.cod-estabel
                    AND wm-item-embalagem-local.cod-local   = ttWork.cod-local
                    AND wm-item-embalagem-local.cod-item    = ttWork.cod-item
                    AND wm-item-embalagem-local.log-padrao  = YES NO-LOCK NO-ERROR.
             
             RUN emptyRowErrors IN wgbosc145.
             RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.cod-item,
                                                   INPUT wm-item-embalagem-local.cod-embalagem,
                                                   INPUT ttWork.num-livre-1,
                                                   INPUT ttWork.num-livre-2,
                                                   OUTPUT pQtdItem).
             IF  RETURN-VALUE = 'NOK' THEN DO:
                 RUN getRowErrors IN wgbosc145(OUTPUT TABLE RowErrors).
                 FOR EACH RowErrors:
                     ASSIGN vLogErro = YES.
                     ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                     {bcp/bc9015.i2 STRING(ErrorNumber) string(ErrorDescription)}
                 END.
                 IF vLogErro = YES THEN DO: 
                     RUN piEliminaHandles.
                     RETURN ERROR.
                 END.
             END.
         END.
         RUN piCalcularPeso IN THIS-PROCEDURE (INPUT pQtdItem).
         ASSIGN ttWork.qtd-peso = d-qtd-peso
                ttWork.qtd-item = pQtdItem.
         /*DO ON ENDKEY UNDO, RETURN "ESC":*/
            UPDATE ttWork.qtd-peso WITH FRAME frame02.
         /*END.*/
         IF  ttWork.qtd-peso = 0 THEN DO:
             HIDE ALL.
             ASSIGN vLogErro = YES.
             {bcp/bc9105.i "105" "Peso Inv lido (DC)"}
             VIEW FRAME {&Frame02Name}.
             PAUSE 0 NO-MESSAGE.
             HIDE ALL NO-PAUSE.
             RETURN ERROR.
         END.

         RUN piEliminaHandles.

         ASSIGN vLogSai = YES
                vLogFinaliza = YES.
         HIDE ALL NO-PAUSE.
     END.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   **********************************/

PROCEDURE pi-getIndTipoLeitura:

    /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
    RUN pi-getValorParametro (ttWork.cod-item,
                              "WmOut003",
                             ("LEIT-QTD-INVENTARIO"),
                              OUTPUT iIndTipoLeitura).

    /* Se nao achar o parametro, assume o valor 2 */
    IF  iIndTipoLeitura = 0 THEN DO:
        {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
        ASSIGN iIndTipoLeitura = 2.
    END.

    /* Caso o parametro seja informado incorretamente, informa ao usuario */
    IF  iIndTipoLeitura < 0 OR iIndTipoLeitura > 4  THEN DO:
        {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
        ASSIGN iIndTipoLeitura = 2.
    END.

    /* Se o tipo de leitura for igual a 1, pede em tela */
    IF iIndTipoLeitura = 1 THEN DO:
        REPEAT:
            HIDE ALL NO-PAUSE.
            /*DO ON ENDKEY UNDO, RETURN "ESC":*/
               UPDATE iIndTipoLeitura WITH FRAME Frame03.
            /*END.*/
            HIDE ALL NO-PAUSE.
            /* S¢ aceita valores 2 e 3 digitados em tela */
            IF  iIndTipoLeitura = 2 OR iIndTipoLeitura = 4 THEN
                LEAVE.
        END.
        IF  l-voltar = YES THEN DO:
            ASSIGN vLogSai = YES
                   vLogFinaliza = YES.
            HIDE ALL NO-PAUSE.
            RETURN 'NOK'.
        END.
    END.
END PROCEDURE.

PROCEDURE piCalcularPeso:
    DEFINE INPUT PARAMETER iQtdItem AS DECIMAL NO-UNDO.
    
    FIND FIRST wms-item-estab-local
         WHERE wms-item-estab-local.cod-estab = ttWork.cod-estabel
           AND wms-item-estab-local.cod-local = ttWork.cod-local
           AND wms-item-estab-local.cod-item  = ttWork.cod-item NO-LOCK NO-ERROR.
    IF AVAIL wms-item-estab-local THEN DO:
       ASSIGN i-ind-unid-cont    = wms-item-estab-local.ind-unid-contr.
    END.
    ELSE DO:
       FIND FIRST wm-item
            WHERE wm-item.cod-item = ttWork.cod-item NO-LOCK NO-ERROR.
       ASSIGN i-ind-unid-cont = wm-item.ind-unid-contr.
    END.
    IF i-ind-unid-cont = 1 THEN DO:
       IF NOT VALID-HANDLE(wgbosc044) THEN DO:
           RUN scbo/bosc044.p PERSISTENT SET wgbosc044.
           RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).
           RUN gotoKey IN wgbosc044 (INPUT ttWork.cod-item).
       END.
   
       IF NOT VALID-HANDLE(wgbosc145) THEN DO:
           RUN scbo/bosc145.p PERSISTENT SET wgbosc145.
           RUN setConstraintItem IN wgbosc145 (ttWork.cod-item).
           RUN openQueryStatic IN wgbosc145 (INPUT "item":U).
       END.
   
       RUN getDecField IN wgbosc044 (INPUT "qtd-peso",
                                     OUTPUT qtdPesoItem).
       RUN getFirst IN wgbosc145.
       RUN getLogField IN wgbosc145 (INPUT "log-padrao",
                                     OUTPUT vLogPadrao).
       IF vLogPadrao <> YES THEN
           DO WHILE vLogSai = NO:
               RUN getNext IN wgbosc145.
               RUN getLogField IN wgbosc145 (INPUT "log-padrao",
                                             OUTPUT vLogPadrao).
               IF vLogPadrao = YES THEN ASSIGN vLogSai = YES.
           END.
   
       RUN getDecField IN wgbosc145 (INPUT "qtd-peso",
                                     OUTPUT qtdPesoEmbal).
   
       RUN getDecField IN wgbosc145 (INPUT "qtd-item-emb",
                                     OUTPUT vQtdItemEmbal).
   
       ASSIGN d-qtd-peso =  IF (iQtdItem / vQtdItemEmbal) - TRUNCATE(iQtdItem / vQtdItemEmbal,0) > 0
               THEN ((TRUNCATE(iQtdItem / vQtdItemEmbal,0) + 1) * qtdPesoEmbal) + (iQtdItem * qtdPesoItem)
               ELSE (TRUNCATE(iQtdItem / vQtdItemEmbal,0) * qtdPesoEmbal) + (iQtdItem * qtdPesoItem).
    END.
    ELSE DO:
       FIND FIRST wm-etiqueta
           WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
       IF AVAIL wm-etiqueta THEN DO:
          ASSIGN d-qtd-peso = wm-etiqueta.qtd-peso.   
       END.            
    END.

END PROCEDURE.

PROCEDURE piEliminaHandles:

    /*Elimina o handle instanciado neste programa*/
    IF VALID-HANDLE (wgbosc145) THEN DO:
        DELETE OBJECT wgbosc145.
        ASSIGN wgbosc145 = ?.
    END.

    IF VALID-HANDLE (wgbosc044) THEN DO:
        DELETE OBJECT wgbosc044.
        ASSIGN wgbosc044 = ?.
    END.

    RETURN "OK":U.

END PROCEDURE.


