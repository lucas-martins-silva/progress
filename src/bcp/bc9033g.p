/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{include/i-prgvrs.i BC9033G 2.00.00.020 } /*** "010020" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9033g MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/*******************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9033g.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking / Packing WMS            **
**                                                                                         **
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
**                        Ex: tt-picking-wms.                                                     **
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
**                        que executa a procedure _GenerateDCTransaction que eÔ responsavel por   **
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
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-picking-wms
{bcp/bc9033.i " "}
{bcp/bc9033.i1 " "}

{bcp/bc9018h.i} /* definicao das procedures utilizadas */

FIND FIRST ttWork NO-ERROR.

DEFINE INPUT PARAMETER IDttwm-box          AS ROWID   NO-UNDO.
DEFINE INPUT PARAMETER IDttwm-box-movto    AS ROWID   NO-UNDO.
DEFINE INPUT PARAMETER IDbttwm-box-movto   AS ROWID   NO-UNDO.
DEFINE INPUT PARAMETER IDttwm-docto-itens  AS ROWID   NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-picking-wms-table.
DEFINE OUTPUT PARAM l-retorno-bc9033g      AS LOGICAL NO-UNDO.

/* opcao do tipo de leitura. Esse valor vem da bc9033h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura   AS INTEGER NO-UNDO. 
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoVisualiza AS INTEGER NO-UNDO.

DEFINE SHARED VARIABLE i-etiqueta-packing  AS DECIMAL FORMAT ">>>>>>>>>>>>>>>" NO-UNDO. 

DEFINE VARIABLE iLogHabilitaUn     AS LOGICAL  NO-UNDO.
DEFINE VARIABLE p-qtd-item         AS DECIMAL  NO-UNDO.
DEFINE VARIABLE p-qtd-caixas       AS DECIMAL  NO-UNDO.
DEFINE VARIABLE p-qtd-unidades     AS DECIMAL  NO-UNDO.
DEFINE VARIABLE d-qtd-retirada     AS DECIMAL  NO-UNDO.
DEFINE VARIABLE l-leitura-etq-pack AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-packing-item     AS LOGICAL  NO-UNDO.
DEFINE VARIABLE wgbosc044          AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc058          AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc074          AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbc9033f          AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc145          AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc148          AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc152          AS HANDLE   NO-UNDO.

/*Definiá∆o das temp-table tt-Wm-packing e tt-itens.*/
{cdp/cdcfgwms.i}
{wmp/wm9070.i}

DEFINE TEMP-TABLE tt-etiquetas-packing NO-UNDO LIKE wm-etiqueta
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

FIND ttwm-box NO-LOCK WHERE ROWID(ttwm-box)= IDttwm-box NO-ERROR.

FIND ttWm-box-movto-idx-picking NO-LOCK WHERE ROWID(ttWm-box-movto-idx-picking) = IDttwm-box-movto NO-ERROR.

FIND bttwm-box-movto NO-LOCK WHERE ROWID(bttwm-box-movto) = IDbttwm-box-movto NO-ERROR.

FIND ttwm-docto-itens NO-LOCK WHERE ROWID(ttwm-docto-itens) = IDttwm-docto-itens NO-ERROR.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Qtd:.....          '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(11)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label FORMAT ">>>>>>>>>>>>>9"  ~
                             ttWork.qtd-item-digit                             At Row 08 Col 05 No-label Format '>>>>>>>>9.9999'

&global-define Frame01Repeat YES
/************************************************************/

/* fk inicio: projeto parati: pega o valor do ean */
/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking WMS'                                     At Row 01 Col 01                         ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'CB:                '                             At Row 08 Col 01                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label                      ~
                             ttWork.cod-livre-1                                At Row 08 Col 04 No-label Format 'x(14)'

&global-define Frame02Repeat YES

/************************************************************/

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking WMS'                                     At Row 01 Col 01                               ~
                             '.................. '                             At Row 02 Col 01                               ~
                             '.................. '                             At Row 03 Col 01                               ~
                             'Doca:....Box:..... '                             AT ROW 04 COL 01                               ~
                             'Lida:...........   '                             At Row 05 Col 01                               ~
                             'Pend:...........   '                             AT ROW 06 COL 01                               ~
                             'Ser:.............. '                             At Row 07 Col 01                               ~
                             'Emb:'                                            At Row 08 Col 01                               ~
                             'Un:'                                             AT ROW 08 COL 11                               ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(18)'       ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)'       ~
                             ttWork.num-doca                                   At Row 04 Col 06 No-label Format '>>>'         ~
                             ttWork.num-box-lido                               At Row 04 Col 13 No-label FORMAT '>>>>>9'      ~
                             ttWork.cod-livre-3                                At Row 05 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             ttWork.cod-livre-4                                At Row 06 Col 06 NO-LABEL FORMAT "x(14)"       ~
                             ttWork.num-serial                                 At Row 07 Col 05 No-label FORMAT ">>>>>>>>>>>>>9"  ~
                             ttWork.cod-livre-1                                At Row 08 Col 05 No-label Format 'x(4)' ~
                             ttWork.cod-livre-2                                AT ROW 08 COL 15 NO-LABEL FORMAT 'x(4)'
&global-define Frame03Repeat YES

/* Definicao dos campos a serem recebidos ---               */
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If return-value = "ESC":U or return-value = "NOK":U or return-value = "OK":U then LEAVE _frame01.
                                                            

/* Definicao das trigger de usuario ---                     */  
&global-define UserTriggers ON 'END-ERROR':U OF Frame Frame01     ~
                            DO:                             ~
                                Assign vLogFinaliza = YES   ~
                                       vLogSai      = YES.  ~
                                RETURN 'ESC':U.             ~
                            END.                            ~
                            ON 'END-ERROR':U OF Frame Frame02     ~
                            DO:                             ~
                                IF l-ler-endereco = NO THEN ~
                                    Assign vLogFinaliza = YES   ~
                                           vLogSai      = YES.  ~
                                RETURN 'ESC':U.             ~
                            END.                            ~
/************************************************************/

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                            
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
/************************************************************/
&global-define ActiveObject1 wgbosc044
&global-define ActiveObject2 wgbosc058
&global-define ActiveObject3 wgbosc074
&global-define ActiveObject4 wgbc9033f
&global-define ActiveObject5 wgbosc145
&global-define ActiveObject6 wgbosc148
&global-define ActiveObject7 wgbosc152
/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eÔ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
RUN InitHandles IN THIS-PROCEDURE.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local Ç destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   ASSIGN vLogErro          = NO
          l-retorno-bc9033g = NO.
   
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      RETURN.
   END.
   
   IF ttWork.num-serial = 0 THEN
      ASSIGN vNumItensSerial = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking
             ttWork.qtd-item = vNumItensSerial.
   
   IF v-log-abre-embalagem THEN DO:
      IF vNumItensSerial > (ttWork.qtd-item - ttWork.qtd-embal-lidas) THEN DO:
         ASSIGN  ttWork.qtd-item-digit = ttWork.qtd-item - ttWork.qtd-embal-lidas.
      END.
      ELSE
         ASSIGN ttWork.qtd-item-digit = vNumItensSerial.
   END.
   ELSE
      ASSIGN ttWork.qtd-item-digit = vNumItensSerial.  /* retirado para testes */
   
   /* Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
   IF iIndTipoVisualiza = 2 THEN DO:
      ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>>>>9.9999")
             ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWork.qtd-embal-lidas,">>>>>>>>9.9999").
   END.
   IF iIndTipoVisualiza = 4 THEN DO:      
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-item, 
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades).
      
      ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
      
      RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                            INPUT ttWm-box-movto-idx-picking.cod-local,
                                            INPUT ttWm-box-movto-idx-picking.cod-item,
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.qtd-embal-lidas,
                                            OUTPUT p-qtd-caixas,
                                            OUTPUT p-qtd-unidades). 
      
      ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
   END.
   
   ASSIGN ttWork.qtd-item = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.
   
   /* Verifica o Tipo de Visualizaá∆o da quantidade - Fim */
   
   ASSIGN ttWork.cod-item:SCREEN-VALUE IN FRAME {&Frame01Name}       = ttwm-docto-itens.cod-item
          ttWork.num-doca:SCREEN-VALUE IN FRAME {&Frame01Name}       = STRING(ttwm-docto-itens.cod-doca)
          ttWork.des-endereco:SCREEN-VALUE IN FRAME {&Frame01Name}   = ttwm-box.cod-bloco     + '/':U 
                                                                       + ttwm-box.cod-rua     + '/':U 
                                                                       + ttwm-box.cod-nivel   + '/':U 
                                                                       + ttwm-box.cod-coluna  + '/':U
                                                                       + IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
          ttWork.num-box-lido:SCREEN-VALUE IN FRAME {&Frame01Name}   = STRING(ttWork.num-box-lido)
          ttWork.num-serial:SCREEN-VALUE IN FRAME {&Frame01Name}     = STRING(ttWork.num-serial)
          ttWork.qtd-item-digit:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWork.qtd-item-digit)  .
   
   DO:
      /* Se o tipo de leitura for por ean, pega o codigo */
      IF iIndTipoLeitura = 3 THEN DO:
         /* Efetiva os campos do buffer */
         ASSIGN ttWork.cod-item  
                ttWork.cod-livre-4
                ttWork.des-endereco      
                ttWork.cod-livre-3
                ttWork.num-doca
                ttWork.num-box-lido      
                ttWork.num-serial.
         
         /* Metodo para pegar as informacoes do eah-dun*/
         RUN getInfoCodigoEanDun.
      END.
      ELSE IF iIndTipoLeitura = 4 THEN DO:
         /* Efetiva os campos do buffer */
         ASSIGN ttWork.cod-item
                ttWork.cod-livre-4
                ttWork.des-endereco      
                ttWork.cod-livre-3
                ttWork.num-doca
                ttWork.num-box-lido      
                ttWork.num-serial.
         
         /* Metodo para pegar as informacoes do eah-dun*/
         RUN getInfoEmbUn.
      END.
      ELSE DO:
         HIDE ALL NO-PAUSE.
         
         /* Se der esc, retorna ao valor anterior */
         ON END-ERROR OF ttWork.qtd-item-digit DO: 
            ASSIGN ttWork.qtd-item-digit = 0
                   vLogErro = YES.
         END.
         
         DO ON ENDKEY UNDO, RETURN "ESC":
            UPDATE ttWork.qtd-item-digit WITH FRAME {&Frame01Name} .
         END.
      END.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 05 Inicio --- */
   ASSIGN vLogSai      = NO
          vLogFinaliza = NO.
   
   IF RETURN-VALUE = "ESC":U THEN DO:
      ASSIGN vLogFinaliza = YES
             vLogSai      = YES.
      RETURN RETURN-VALUE.
   END.
         
   /* se tiver erro, retorna */
   IF vLogErro = YES THEN DO:
      HIDE ALL.
      ASSIGN vLogErro = NO.
      RETURN 'NOK':U.
   END.
   
   IF ttWork.qtd-item-digit = 0 THEN DO:
      /* Se for igual a zero, retorna sem executar nada */
      {bcp/bc9105.i "605" "Quantidade picking igual a zero(DC)"}
      RETURN "NOK":U.
   END.

   IF ttWork.qtd-item-digit > vNumItensSerial THEN DO:
      ASSIGN vLogErro = YES.
      IF ttWork.num-serial <> 0 THEN DO:
         {bcp/bc9105.i "602" "Quantidade serial maior que a quantidade necess†ria (WMS)"}
      END.
      ELSE DO:
         {bcp/bc9105.i "602" "Quantidade informada maior que a quantidade necess†ria (WMS)"}
      END.
      VIEW FRAME {&Frame01Name}.
      PAUSE 0 NO-MESSAGE.
      RETURN 'NOK':U.
   END.
   
   IF v-log-abre-embalagem = NO AND vNumItensSerial <> ttWork.qtd-item-digit THEN DO:
       ASSIGN vLogErro = YES.
       {bcp/bc9105.i "603" "Quantidade Inv†lida (WMS)"}
       VIEW FRAME {&Frame01Name}.
       PAUSE 0 NO-MESSAGE.
       RETURN 'NOK':U.
   END.
   
   IF v-log-abre-embalagem = YES AND ttWork.qtd-item-digit > (ttWork.qtd-item - ttWork.qtd-embal-lidas) THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "604" "Quantidade Inv†lida (WMS)"}
      VIEW FRAME {&Frame01Name}.
      PAUSE 0 NO-MESSAGE.
      RETURN 'NOK':U.
   END.
   
   IF CAN-FIND(FIRST tt-picking-wms-table
               WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
                 AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
                 AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
                 AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto) THEN DO:
   
      EMPTY TEMP-TABLE ttSerialQtd.
   
      FOR EACH tt-picking-wms-table
         WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
           AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
           AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
           AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-LOCK:      
         
         CREATE ttSerialQtd.
         ASSIGN ttSerialQtd.id-etiqueta       = tt-picking-wms-table.num-serial
                ttSerialQtd.qtd-item-retirado = tt-picking-wms-table.qtd-item-digit.
      END.
   END.
   
   IF ttWork.num-serial <> 0 THEN DO: /* Apenas para transaá∆o via seriais */
      RUN EmptyRowErrors IN wgbosc074.
      IF (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) <> ttWm-box-movto-idx-picking.qtd-item-picking THEN DO:
         RUN validaQtdItemEtiquetaPicking IN wgbosc074 (INPUT ttWm-box-movto-idx-picking.cod-local,
                                                        INPUT ttWork.num-serial,
                                                        INPUT ttWork.qtd-item-digit,
                                                        INPUT TABLE ttSerialQtd).
         
         RUN getRowErrors In wgbosc074 (OUTPUT TABLE RowErrors) NO-ERROR.
         FOR Each RowErrors:
             HIDE ALL NO-PAUSE.
             ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
             RUN bcp/bc9115.p(ErrorNumber,
                              ErrorDescription,
                              8,
                              20,
                              3).
             HIDE ALL NO-PAUSE.
         END.
         
         IF CAN-FIND( FIRST rowErrors) THEN DO:
            ASSIGN vLogErro = YES.
            RETURN 'NOK':U.
         END.
      END.
   END.
   
   FIND FIRST tt-picking-wms-table
        WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
          AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
          AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
          AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
          AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-ERROR.
   
   IF AVAIL tt-picking-wms-table THEN DO:
      RUN pi-atualiza-qtd-digitada IN wgbc9033f(INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                INPUT ttWm-box-movto-idx-picking.cod-local,
                                                INPUT ttWm-box-movto-idx-picking.id-movto,
                                                INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                INPUT ttwm-box-movto-idx-picking.id-docto,
                                                INPUT ttWork.num-serial,
                                                INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                INPUT vNumItensSerial,
                                                INPUT ttwork.qtd-item-digit,
                                                INPUT-OUTPUT TABLE tt-erro).
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN DO: 
         FOR EACH tt-erro:
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
            {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
            ASSIGN vLogSai = YES.
         END.
         IF vLogErro = YES THEN
            RETURN ERROR.
      END.
      ASSIGN tt-picking-wms-table.qtd-item-digit =  tt-picking-wms-table.qtd-item-digit + vNumItensSerial.
   END.
   ELSE DO:
      RUN pi-cria-tt-picking-ems-table IN wgbc9033f (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                                     INPUT ttWm-box-movto-idx-picking.cod-local,
                                                     INPUT ttWm-box-movto-idx-picking.id-movto,
                                                     INPUT ttWm-box-movto-idx-picking.ind-tipo-movto,
                                                     INPUT ttwm-box-movto-idx-picking.id-docto,
                                                     INPUT ttWork.num-serial,
                                                     INPUT ttWm-box-movto-idx-picking.num-seq-item,
                                                     INPUT vNumItensSerial,
                                                     INPUT ttwork.qtd-item-digit,
                                                     INPUT ttWm-box-movto-idx-picking.cod-item,
                                                     INPUT ttwork.num-box-lido,
                                                     INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                                     INPUT ttWm-box-movto-idx-picking.qti-embalagem,
                                                     INPUT ttWm-box-movto-idx-picking.dt-atualizacao,
                                                     INPUT ttWm-box-movto-idx-picking.dt-transacao,
                                                     INPUT ttWork.num-tempo-inicio,
                                                     INPUT ttWork.cod-coletor,
                                                     INPUT ttWork.cod-equipamento,
                                                     INPUT "",
                                                     INPUT-OUTPUT TABLE tt-picking-wms-table,
                                                     OUTPUT TABLE tt-erro).
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN DO: 
      FOR EACH tt-erro:
         ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
         {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
         ASSIGN vLogSai = YES.
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
      END.
   END.
   
   ASSIGN ttWork.qtd-embal-lidas = 0.
   
   FOR EACH tt-picking-wms-table
      WHERE tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto 
        AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
        AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item    
        AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto NO-LOCK:
   
       ASSIGN ttWork.qtd-embal-lidas = ttWork.qtd-embal-lidas + tt-picking-wms-table.qtd-item-digit.
    END.
   
    ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame01Name} = STRING(ttWork.qtd-embal-lidas). 
   
    ASSIGN ttWork.cod-estabel           = v-cod-estabel
           ttWork.cod-local             = v-cod-local
           ttWork.id-docto              = ttWm-box-movto-idx-picking.id-docto
           ttWork.id-movto              = ttWm-box-movto-idx-picking.id-movto
           ttWork.num-seq-item          = ttWm-box-movto-idx-picking.num-seq-item
           ttWork.num-box               = ttWm-box-movto-idx-picking.id-box
           ttWork.num-doca              = ttwm-docto-itens.cod-doca
           ttWork.cod-embalagem         = ttWm-box-movto-idx-picking.cod-embalagem
           ttWork.des-endereco          = ttWork.des-endereco:SCREEN-VALUE IN FRAME {&Frame01Name} 
           ttWork.cod-item              = ttwm-docto-itens.cod-item
           ttWork.qtd-item              = ttWm-box-movto-idx-picking.qtd-item
           ttWork.qtd-embalagem         = ttWm-box-movto-idx-picking.qti-embalagem
           ttWork.dat-atualizacao       = ttWm-box-movto-idx-picking.dt-atualizacao
           ttWork.dat-transacao         = ttWm-box-movto-idx-picking.dt-transacao.
   
   IF ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) >= ttwork.qtd-embal-lidas THEN DO:
      RUN GravaTransacao.
      ASSIGN l-retorno-bc9033g = (RETURN-VALUE = "OK":U).    
      RETURN RETURN-VALUE.
   END.
   
   /* Se o movimento ainda estiver esperando itens e se ainda houverem itens                  
      disponiveis no serial informado sugere a quantidade restante no campo 
      que solicita a quantidade */
   IF ttwm-docto-itens.qtd-item > ttWork.qtd-embal-lidas AND (vNumItensSerial - ttWork.qtd-item-digit) > 0 THEN DO:
      ASSIGN vNumItensSerial = vNumItensSerial - ttWork.qtd-item-digit.
   END. 
   ASSIGN vLogFinaliza = YES
          vLogSai      = YES.
   
   RETURN 'ESC':U.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   DEF VAR vNomeUsuario            AS CHARACTER                NO-UNDO.
   DEF VAR v-detalhe               AS CHARACTER                NO-UNDO.

   FIND FIRST wm-etiqueta
        WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
   IF AVAIL wm-etiqueta THEN
      ASSIGN d-qtd-retirada = wm-etiqueta.qtd-item-retirado.

   ASSIGN vNomeUsuario = ttWork.cod-usuario.
   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.

   EMPTY TEMP-TABLE tt-erro.
   EMPTY TEMP-TABLE tt-trans.
   
   ASSIGN v-detalhe = 'Est:':U  + TRIM(ttWm-box-movto-idx-picking.cod-estabel) + ';':U +
                      'Loc:':U  + TRIM(ttWm-box-movto-idx-picking.cod-local) + ';':U +
                      'IMo:':U  + TRIM(STRING(ttWm-box-movto-idx-picking.id-movto,'>>>>>>>>>9':U)) + ';':U + 
                      'ITM:':U  + TRIM(STRING(ttWm-box-movto-idx-picking.ind-tipo-movto, '>9':U)).

   /* criaáao da bc-trans */
   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMSai009':U
          tt-trans.detalhe  = v-detalhe.
          tt-trans.usuario  = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.

   HIDE ALL.

   GravaTrans:
   DO TRANSACTION:
      RUN finaliza-picking IN wgbc9033f ( INPUT TABLE tt-trans,
                                          OUTPUT TABLE tt-erro).
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN DO: 
         FOR EACH tt-erro:
            ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
            {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
            ASSIGN vLogFinaliza = YES
                   vLogSai      = YES.
         END.
         IF vLogSai = YES THEN
            UNDO GravaTrans, LEAVE GravaTrans.
      END.
      ELSE DO:
         RUN picking-pre-api-wms IN wgbc9033f ( INPUT-OUTPUT TABLE tt-trans,
                                                INPUT-OUTPUT TABLE tt-erro).
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
               {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
               ASSIGN vLogFinaliza = YES
                      vLogSai      = YES.
            END.
            IF vLogSai = YES THEN
               UNDO GravaTrans, LEAVE GravaTrans.
         END.
         ELSE DO:
            FIND FIRST tt-picking-wms-table
                 WHERE tt-picking-wms-table.num-serial     = ttWork.num-serial
                   AND tt-picking-wms-table.id-docto       = ttWm-box-movto-idx-picking.id-docto
                   AND tt-picking-wms-table.id-movto       = ttWm-box-movto-idx-picking.id-movto
                   AND tt-picking-wms-table.num-seq-item   = ttWm-box-movto-idx-picking.num-seq-item
                   AND tt-picking-wms-table.ind-tipo-movto = ttWm-box-movto-idx-picking.ind-tipo-movto 
                   AND tt-picking-wms-table.num-serial     = ttwork.num-serial NO-ERROR.

                 /* Se ainda tiver pendencias na embalagem, nao elimina a ttWm-box-movto-idx-picking
                    Isso faz com que possibilite ler as etiquetas atÇ preencher a quantidade do movimento */
            DO:
               /*Ap¢s efetuar o picking, envia a etiqueta para a API de packing*/
               RUN getParamTrans(INPUT "WMSai009":U,
                                 INPUT "LER-ETIQUETA-PACKING":U,
                                 OUTPUT l-leitura-etq-pack).
    
               RUN pi-cria-tt-packing (OUTPUT TABLE tt-wm-packing,
                                       OUTPUT TABLE tt-itens,
                                       OUTPUT TABLE tt-erro,
                                       OUTPUT l-packing-item).
               IF RETURN-VALUE = "NOK":U THEN DO:
                  FOR EACH tt-erro:
                     ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                     {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
                     ASSIGN vLogFinaliza = YES
                            vLogSai      = YES.
                  END.
                  IF vLogSai = YES THEN
                     UNDO GravaTrans, LEAVE GravaTrans.
               END.
    
               IF l-packing-item = YES OR l-leitura-etq-pack = YES THEN DO:
                  /* Faz o packing */
                  RUN wmp/wm9070.p (INPUT TABLE tt-wm-packing,
                                    INPUT TABLE tt-itens,
                                    INPUT ttWork.cod-usuario,
                                    INPUT ttWork.cod-coletor,
                                    INPUT ttWork.cod-equipamento,
                                    INPUT NO,
                                    OUTPUT TABLE RowErrors).

                  FIND FIRST RowErrors NO-LOCK NO-ERROR.
                  IF RETURN-VALUE <> 'OK':U OR AVAILABLE RowErrors THEN DO:
                     FOR EACH RowErrors:
                        CREATE tt-erro.
                        ASSIGN tt-erro.i-sequen = 8
                               tt-erro.cd-erro  = ErrorNumber
                               tt-erro.mensagem = ErrorDescription.
                     END.
        
                     FOR EACH tt-erro:
                        ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(WMS)":U.
                        HIDE ALL NO-PAUSE.
                        RUN bcp/bc9115.p (tt-erro.cd-erro,
                                          tt-erro.mensagem,
                                          8,
                                          20,
                                          3).
                        HIDE ALL NO-PAUSE.                        
                        ASSIGN vLogFinaliza = YES
                               vLogSai      = YES.
                     END.
                     UNDO, RETURN "NOK":U.
                  END.
     	            IF vLogSai = YES THEN
     	               UNDO GravaTrans, LEAVE GravaTrans.
               END.
               /* Pega a quantidade do que jah foi lido */
               DEFINE VARIABLE deAuxiliar AS DECIMAL    NO-UNDO.
               ASSIGN deAuxiliar = (ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking.

               /* Se a quantidade da etiqueta for menor que a quantidade do movimento, nao elimina a tabela */
               IF (deAuxiliar - ttWork.qtd-item-digit) = 0 THEN DO:
                  IF AVAILABLE tt-picking-wms-table THEN DO:
                     DELETE ttWm-box-movto-idx-picking.
                     {bcp/bc9105.i "901" "Picking/Packing executado com Sucesso (DC)"}
                  END.
               END.
               ELSE DO:
                  /* Incrementa a quantidade retirada */
                  ASSIGN ttWm-box-movto-idx-picking.qtd-item-picking = ttWm-box-movto-idx-picking.qtd-item-picking + ttWork.qtd-item-digit.
               END.
            END.
            HIDE ALL NO-PAUSE.
            ASSIGN ttWork.qtd-item-digit = 0.

            ASSIGN vLogEmProcesso = NO 
                   vLogSai        = NO 
                   vLogFinaliza   = YES.
            RETURN 'OK':U.
         END.
      END.
   END.
   ASSIGN ttWork.qtd-item-digit                           = 0
          ttWork.qtd-embal-lidas                          = 0
          ttWork.num-serial                               = 0
          ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01 = '0':U.

   ASSIGN vLogEmProcesso = YES
          vLogSai        = YES
          vLogFinaliza   = YES.
   HIDE ALL.
   RETURN 'NOK':U.
END PROCEDURE.


/*************************************************************************************************** 
** Busca as informacoes do codigo ean/dun                           **
****************************************************************************************************/
PROCEDURE getInfoCodigoEanDun:
   /* Variaveis */
   DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
   
   
   /* Nao deixa sair do campo */
   ON END-ERROR OF ttwork.cod-livre-1 IN FRAME {&Frame02Name} DO:
      ASSIGN ttwork.qtd-item-digit = 0
             vLogErro = YES.
   END.
   ASSIGN ttwork.qtd-item-digit = 0.
   
   /* Faz a leitura atÇ a qtd de itens for igual a qtd da etiqueta */
   REPEAT:
      /* Busca o valor do codigo ean/dun da tela */
      DISP ttWork.cod-item
           ttWork.des-endereco              
           ttWork.num-doca
           ttWork.num-box-lido              
           ttWork.num-serial
           ttWork.cod-livre-1
         WITH FRAME {&Frame02Name}.
      
      /* Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
      IF iIndTipoVisualiza = 2 THEN DO:
         ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>>>>9.9999")
                ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas,">>>>>>>>9.9999").
      END.
      IF iIndTipoVisualiza = 4 THEN DO:         
      
         RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                               INPUT ttWm-box-movto-idx-picking.cod-local,
                                               INPUT ttWm-box-movto-idx-picking.cod-item,
                                               INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                               INPUT ttWork.qtd-item, 
                                               OUTPUT p-qtd-caixas,
                                               OUTPUT p-qtd-unidades).
      
         ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
      
         RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                               INPUT ttWm-box-movto-idx-picking.cod-local,
                                               INPUT ttWm-box-movto-idx-picking.cod-item,
                                               INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                               INPUT ttWork.qtd-embal-lidas,
                                               OUTPUT p-qtd-caixas,
                                               OUTPUT p-qtd-unidades). 
      
         ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
      
      END.
      
      IF ttWork.qtd-embal-lidas = 0 THEN
         ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWm-box-movto-idx-picking.qtd-item-picking, ">>>>>>>>9.9999"). 
      ELSE 
         ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame02Name} = STRING(ttWork.qtd-embal-lidas, ">>>>>>>>9.9999"). 
      
      
      /* Habilita para digitacao do codigo ean-dun*/
      HIDE ALL NO-PAUSE.
      ASSIGN ttwork.cod-livre-1 = "".
      DO ON ENDKEY UNDO, RETURN "ESC":
         UPDATE ttwork.cod-livre-1 WITH FRAME {&Frame02Name}.
      END.
      
      /* Se for digitado 999999, efetiva o que for lido */
      IF ttwork.cod-livre-1 = "999999" THEN DO:
         LEAVE.
      END.
      
      /* Busca as informacoes referente ao codigo ean */
      RUN EmptyRowErrors IN wgbosc148.
      RUN readBarCode IN wgbosc148 (INPUT v-cod-estabel,
                                    INPUT v-cod-local,
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
      IF cCodItem <> ttwork.cod-item THEN DO:
         {bcp/bc9105.i "0" "Item do codigo ean/dun lido n∆o confere com o item do c¢digo serial (DC)"}
         NEXT.
      END.
      
      IF (ttwork.qtd-item-digit + deQtdInformacao) > ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
         {bcp/bc9105.i "0" "Quantidade lida maior que a quantidade necessaria. (DC)"}
         NEXT.
      END.
      
      IF ttWork.qtd-item-digit + deQtdInformacao > vNumItensSerial THEN DO:
         {bcp/bc9105.i "602" "Quantidade lida maior que a quantidade do Serial (WMS)"}
         NEXT.
      END.
      /* Incrementa a qtd de item digitado para os dois campos em tela  */
      ASSIGN ttwork.qtd-item-digit = ttwork.qtd-item-digit + deQtdInformacao
             ttWork.qtd-embal-lidas = ttWork.qtd-item-digit.
      
      /* S¢ sai do looping quando a qtd de item lido for igual a qtd no serial */
      IF ttwork.qtd-item-digit = vNumItensSerial THEN DO:
         LEAVE.
      END.
      IF ttwork.qtd-item-digit = ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
         LEAVE.
      END.
   END.
   /* Zera o valor lido em tela, pois eh usado apenas na leitura por qtd */
   ASSIGN ttWork.qtd-embal-lidas = 0.
   
   RETURN 'OK':U.
END PROCEDURE.

/*************************************************************************************************** 
** Busca as informacoes do codigo emb/un                            **
****************************************************************************************************/
PROCEDURE getInfoEmbUn:
   /* Variaveis */
   DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
   DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
   DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
   
   /* Nao deixa sair do campo */
   ON END-ERROR OF ttwork.cod-livre-1 IN FRAME {&Frame03Name} DO:
      ASSIGN ttwork.qtd-item-digit = 0
             vLogErro = YES.
   END.
   ASSIGN ttwork.qtd-item-digit = 0.
   
   
   /* Faz a leitura atÇ a qtd de itens for igual a qtd da etiqueta */
   REPEAT:
      /* Busca o valor do codigo emb~\un da tela */
      DISP ttWork.cod-item
           ttWork.cod-livre-1
           ttWork.cod-livre-2
           ttWork.cod-livre-3
           ttWork.des-endereco              
           ttWork.cod-livre-4
           ttWork.num-doca
           ttWork.num-box-lido              
           ttWork.num-serial
         WITH FRAME {&Frame03Name}.
      
      /* Verifica o Tipo de Visualizaá∆o da quantidade - Inicio */
      IF iIndTipoVisualiza = 2 THEN DO:
         ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking,">>>>>>>>9.9999")
                ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING(ttWork.qtd-embal-lidas,">>>>>>>>9.9999").
      END.
      IF iIndTipoVisualiza = 4 THEN DO:         
         RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                               INPUT ttWm-box-movto-idx-picking.cod-local,
                                               INPUT ttWm-box-movto-idx-picking.cod-item,
                                               INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                               INPUT vNumItensSerial, 
                                               OUTPUT p-qtd-caixas,
                                               OUTPUT p-qtd-unidades).
         
         ASSIGN ttWork.cod-livre-1 = STRING(p-qtd-caixas)
                ttWork.cod-livre-2 = STRING(p-qtd-unidades).
         
         RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                               INPUT ttWm-box-movto-idx-picking.cod-local,
                                               INPUT ttWm-box-movto-idx-picking.cod-item,
                                               INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                               INPUT ttWork.qtd-item, 
                                               OUTPUT p-qtd-caixas,
                                               OUTPUT p-qtd-unidades).
         
         ASSIGN ttWork.cod-livre-4:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
         
         /* VERIFICA«√O SE A QUANTIDADE PENDENTE … MENOR QUE A DO SERIAL, Ent„o ele assume o valor da quantidade pendente na Sugest„o*/
         IF ttWork.qtd-item < vNumItensSerial THEN DO:
            ASSIGN ttWork.cod-livre-1 = STRING(p-qtd-caixas)
                   ttWork.cod-livre-2 = STRING(p-qtd-unidades).
         END.
         
         RUN piConverteQtdeCaixa IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                               INPUT ttWm-box-movto-idx-picking.cod-local,
                                               INPUT ttWm-box-movto-idx-picking.cod-item,
                                               INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                               INPUT ttWork.qtd-embal-lidas,
                                               OUTPUT p-qtd-caixas,
                                               OUTPUT p-qtd-unidades). 
         
         ASSIGN ttWork.cod-livre-3:SCREEN-VALUE IN FRAME {&Frame03Name} = STRING(p-qtd-caixas,">>>>9") + " |" + STRING(p-qtd-unidades).
      END.
      /* Habilita para digitacao do codigo emb e un (se parametrizado)*/
      RUN pi-getLogHabilitaUn IN THIS-PROCEDURE.
      
      DISP ttWork.cod-livre-1
           ttWork.cod-livre-2
         WITH FRAME Frame03.
      
      HIDE ALL NO-PAUSE.
      DO ON ENDKEY UNDO, RETURN "ESC":
         IF iLogHabilitaUn THEN DO:
            UPDATE ttwork.cod-livre-1
                   ttWork.cod-livre-2
               WITH FRAME {&Frame03Name}.
         END.
         ELSE
            UPDATE ttwork.cod-livre-1 WITH FRAME {&Frame03Name}.
      END.
      
      /* mk Metodo para transformar a emb/un em quantidade */
      Run EmptyRowErrors In wgbosc145.
      RUN piConverteCaixaQtde IN wgbosc145 (INPUT ttWm-box-movto-idx-picking.cod-estabel, 
                                            INPUT ttWm-box-movto-idx-picking.cod-local,   
                                            INPUT ttWm-box-movto-idx-picking.cod-item,    
                                            INPUT ttWm-box-movto-idx-picking.cod-embalagem,
                                            INPUT ttWork.cod-livre-1,  
                                            INPUT ttWork.cod-livre-2,
                                            OUTPUT p-qtd-item).
      IF RETURN-VALUE <> "OK" THEN DO:
         RUN getRowErrors IN wgbosc145 (OUTPUT TABLE RowErrors) NO-ERROR.
         FOR EACH RowErrors:
            HIDE ALL NO-PAUSE.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            HIDE ALL NO-PAUSE.
            NEXT.
         END.
      END.
      ELSE DO:
         ASSIGN ttwork.qtd-item-digit = p-qtd-item.
         
         /* Se for informado quantidade a mais da alerta */
         IF ttWork.qtd-item-digit > vNumItensSerial THEN DO:
            {bcp/bc9105.i "602" "Quantidade lida maior que a quantidade do Serial (WMS)"}
            NEXT.
         END.
         
         /* S¢ sai do looping quando a qtd de item lido for igual a qtd de emb~\un */
         IF ttwork.qtd-item-digit = vNumItensSerial THEN DO:
            LEAVE.
         END.
         ELSE IF ttwork.qtd-item-digit = ((ttWm-box-movto-idx-picking.qtd-item * ttWm-box-movto-idx-picking.qti-embalagem) - ttWm-box-movto-idx-picking.qtd-item-picking) THEN DO:
            LEAVE.
         END.
         
         IF ttwork.qtd-item-digit <> 0 THEN DO:
            LEAVE.
         END.
         ELSE DO:
            {bcp/bc9105.i "602" "Quantidade lida deve ser maior que 0 (WMS)"}
            NEXT.
         END.
      END.
   END.
   
   /* Zera o valor lido em tela, pois eh usado apenas na leitura por qtd */
   ASSIGN ttWork.qtd-embal-lidas = 0.
   
   RETURN 'OK':U.
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
   IF iNumLogHabilitaUn <> 1 AND iNumLogHabilitaUn <> 2 AND iNumLogHabilitaUn <> 0 THEN DO:
      {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DEEEEEC)"}
      ASSIGN iLogHabilitaUn = YES.
   END.
   
   IF iNumLogHabilitaUn = 1 THEN
      ASSIGN iLogHabilitaUn = YES.
   
   IF iNumLogHabilitaUn = 2 THEN
      ASSIGN iLogHabilitaUn = NO.
END PROCEDURE.

PROCEDURE pi-cria-tt-packing:
   DEFINE OUTPUT PARAMETER TABLE FOR tt-wm-packing.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-itens.
   DEFINE OUTPUT PARAMETER TABLE FOR tt-erro.
   DEFINE OUTPUT PARAMETER l-packing-item-aux AS LOGICAL NO-UNDO.
   
   DEFINE VARIABLE i-id-tarefa      LIKE wm-tarefa-resumo-pedido.id-tarefa NO-UNDO.
   DEFINE VARIABLE i-num-seq-volume LIKE wm-packing.num-seq-volume         NO-UNDO.
   DEFINE VARIABLE i-ind-sit-agrup  AS INTEGER                             NO-UNDO.
   DEFINE VARIABLE de-peso-item     AS DECIMAL                             NO-UNDO.
   DEFINE VARIABLE dt-validade-lote AS DATE                                NO-UNDO.
   DEFINE VARIABLE c-cod-cliente    AS INTEGER                             NO-UNDO.
   DEFINE VARIABLE c-cod-local      AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-cod-estabel    AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-nr-pedcli      AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-cod-embalagem  AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE c-nome-abrev     AS CHARACTER                           NO-UNDO.
   DEFINE VARIABLE i-num-volume     AS INTEGER                             NO-UNDO.
   DEFINE VARIABLE d-cdd-embarq     AS DECIMAL                             NO-UNDO.
   DEFINE VARIABLE i-nr-resumo      AS INTEGER                             NO-UNDO.
   
   EMPTY TEMP-TABLE tt-wm-packing.
   EMPTY TEMP-TABLE tt-itens.
   
   ASSIGN l-packing-item-aux = NO.
   
   RUN getInfPackItemEtiqueta IN wgbosc152 (INPUT i-etiqueta-packing,
                                            OUTPUT l-packing-item-aux).
   
   IF RETURN-VALUE <> "OK":U THEN DO:
      CREATE tt-erro.
      
      {utp/ut-liter.i "Etiqueta_de_packing_n∆o_foi_encontrada" *}
      ASSIGN tt-erro.i-sequen = 8
             tt-erro.cd-erro  = 000
             tt-erro.mensagem = RETURN-VALUE.
      
      RETURN "NOK":U.
   END.
   
   IF l-packing-item-aux = NO THEN
      RETURN "OK":U.
   
   RUN goToKey IN wgbosc152 (INPUT i-etiqueta-packing).
   
   IF RETURN-VALUE <> "OK":U THEN DO:
      CREATE tt-erro.
      
      {utp/ut-liter.i "Etiqueta_de_packing_n∆o_foi_encontrada" *}
      ASSIGN tt-erro.i-sequen = 8
             tt-erro.cd-erro  = 000
             tt-erro.mensagem = RETURN-VALUE.
      
      RETURN "NOK":U.
   END.
   
   RUN getCharField IN wgbosc152 (INPUT "cod-local":U,
                                  OUTPUT c-cod-local).
   
   RUN getCharField IN wgbosc152 (INPUT "cod-estabel":U,
                                  OUTPUT c-cod-estabel).
   
   RUN getCharField IN wgbosc152 (INPUT "nome-abrev":U,
                                  OUTPUT c-nome-abrev).
   
   RUN getCharField IN wgbosc152 (INPUT "cod-embalagem":U,
                                  OUTPUT c-cod-embalagem).
   
   RUN getCharField IN wgbosc152 (INPUT "nr-pedcli":U,
                                  OUTPUT c-nr-pedcli).
   
   RUN getIntField  IN wgbosc152 (INPUT "num-volume":U,
                                  OUTPUT i-num-volume).
   
   RUN getIntField  IN wgbosc152 (INPUT "nr-resumo":U,
                                  OUTPUT i-nr-resumo).
   
   RUN getDecField  IN wgbosc152 (INPUT "cdd-embarq":U,
                                  OUTPUT d-cdd-embarq).
   
   Run getInfTarefaVolumePacking In wgbosc152 (INPUT i-etiqueta-packing,
                                               OUTPUT i-id-tarefa,
                                               OUTPUT i-num-seq-volume).
   
   RUN gotokey IN wgbosc044 (INPUT ttWm-box-movto-idx-picking.cod-item).
   RUN getDecField IN wgbosc044 (INPUT "qtd-peso",
                                 OUTPUT de-peso-item).
   
   RUN OpenQueryMain IN wgbosc058.
   RUN goToKeySemReferLote IN wgbosc058 (INPUT c-cod-estabel,
                                         INPUT c-cod-local,
                                         INPUT c-cod-cliente,
                                         INPUT ttWm-box-movto-idx-picking.cod-item).
   RUN getDateField IN wgbosc058 (INPUT "dt-validade-lote",
                                  OUTPUT dt-validade-lote).
   
   RUN goToKey IN wgbosc074 (INPUT ttWork.num-serial).
   RUN getIntField IN wgbosc074 (INPUT "ind-sit-agrupador":U,
                                 OUTPUT i-ind-sit-agrup).
   
   CREATE tt-wm-packing.
   ASSIGN tt-wm-packing.cod-estabel     = c-cod-estabel
          tt-wm-packing.cod-local       = c-cod-local
          tt-wm-packing.cdd-embarq      = d-cdd-embarq
          tt-wm-packing.nr-resumo       = i-nr-resumo
          tt-wm-packing.nr-pedcli       = c-nr-pedcli
          tt-wm-packing.nome-abrev      = c-nome-abrev
          tt-wm-packing.num-seq-volume  = i-num-seq-volume
          tt-wm-packing.cod-volume      = c-cod-embalagem
          tt-wm-packing.num-volume      = i-num-volume
          tt-wm-packing.id-docto        = ttWm-box-movto-idx-picking.id-docto
          tt-wm-packing.id-tarefa       = i-id-tarefa
          tt-wm-packing.alteracao       = NO
          tt-wm-packing.id-packing      = i-etiqueta-packing
          tt-wm-packing.encerra-packing = YES.
   
   CREATE tt-itens.
   ASSIGN tt-itens.cod-estabel       = c-cod-estabel
          tt-itens.cod-local         = c-cod-local
          tt-itens.id-docto          = ttWm-box-movto-idx-picking.id-docto
          tt-itens.cdd-embarq        = d-cdd-embarq
          tt-itens.nr-resumo         = i-nr-resumo
          tt-itens.nr-pedcli         = c-nr-pedcli
          tt-itens.nome-abrev        = c-nome-abrev
          tt-itens.cod-volume        = c-cod-embalagem
          tt-itens.num-volume        = i-num-volume
          tt-itens.cod-item          = ttWm-box-movto-idx-picking.cod-item
          tt-itens.cod-lote          = ttWm-box-movto-idx-picking.cod-lote
          tt-itens.cod-refer         = ttWm-box-movto-idx-picking.cod-refer
          tt-itens.cod-embalagem     = c-cod-embalagem
          tt-itens.dt-validade-lote  = dt-validade-lote
          tt-itens.num-seq-item      = ?
          tt-itens.id-etiqueta       = ttWork.num-serial
          tt-itens.qtd-item-retirada = d-qtd-retirada.
   
   ASSIGN tt-itens.qtd-item      = ttwork.qtd-item-digit
          tt-itens.qtd-peso      = ttwork.qtd-item-digit * de-peso-item
          tt-itens.qti-embalagem = ttWm-box-movto-idx-picking.qti-embalagem
          d-qtd-retirada         = 0.
   
   RETURN "OK":U.
END PROCEDURE.

PROCEDURE InitHandles:
   IF NOT VALID-HANDLE(wgbosc044) THEN DO:   
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044.
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR.
   END.
   IF NOT VALID-HANDLE(wgbosc058) THEN
      RUN scbo/bosc058.p PERSISTENT SET wgbosc058 NO-ERROR.

   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074 NO-ERROR.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbc9033f) THEN   
      RUN bcp/bc9033f.p PERSISTENT SET wgbc9033f NO-ERROR.
   
   IF NOT VALID-HANDLE(wgbosc145) THEN DO:
      RUN scbo/bosc145.p PERSISTENT SET wgbosc145 NO-ERROR.
      RUN openQueryStatic IN wgbosc145 (INPUT "Main":U) NO-ERROR.
   END.
   IF NOT VALID-HANDLE(wgbosc148) THEN
      RUN scbo/bosc148.p PERSISTENT SET wgbosc148 NO-ERROR.
   
   IF NOT VALID-HANDLE(wgbosc152) THEN DO:
      RUN scbo/bosc152.p PERSISTENT SET wgbosc152.
      RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   END.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   **********************************/
