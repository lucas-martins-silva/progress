/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9019Z 2.00.00.014 } /*** "010014" 18/03/2024 10:23:51  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9019Z MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9019z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karen - Cria‡Æo do programa                  **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Packing WMS                      **
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
**                        Ex: tt-packing-wms.                                                     **
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
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9019
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-packing-wms
{bcp/bc9019.i " "}

DEFINE TEMP-TABLE tt-itens NO-UNDO
            FIELD cod-item    LIKE wm-docto-itens.cod-item
            FIELD cod-lote    LIKE wm-docto-itens.cod-lote
            FIELD cod-refer   LIKE wm-docto-itens.cod-refer
            FIELD dt-validade LIKE wm-docto-itens.dt-validade
            FIELD qtd-item    LIKE wm-docto-itens.qtd-item.

DEFINE TEMP-TABLE tt-devol-picking NO-UNDO
            FIELD cod-estabel        LIKE wm-box-movto.cod-estabel 
            FIELD cod-local          LIKE wm-box-movto.cod-local
            FIELD cod-item           LIKE wm-box-movto.cod-item
            FIELD cod-refer          LIKE wm-box-movto.cod-refer
            FIELD cod-lote           LIKE wm-box-movto.cod-lote
            FIELD cod-embalagem      LIKE wm-box-movto.cod-embalagem
            FIELD qtd-item           LIKE wm-box-movto.qtd-item
            FIELD qtd-devol          LIKE wm-box-movto.qtd-devol
            FIELD qtd-a-devolver     LIKE wm-box-movto.qtd-devol LABEL "Qtd a Devolver"
            FIELD num-seq-item       LIKE wm-box-movto.num-seq-item
            FIELD rownum             AS INTEGER
            FIELD r-rowid            AS ROWID
            FIELD nr-entrega         LIKE wm-docto-itens-ped.nr-entrega
            FIELD item-pai           LIKE wm-box-movto.cod-item
            FIELD log-alter          AS LOGICAL INIT NO
            INDEX codigo cod-estabel
                         cod-local
                         num-seq-item
                         cod-item
                         cod-refer
                         cod-lote
                         cod-embalagem
                         nr-entrega.


DEFINE TEMP-TABLE ttwm-pedidos NO-UNDO LIKE wm-pedidos
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

DEFINE SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

FIND FIRST ttWork NO-ERROR.

/************************************************************/
/* Variaveis de trabalho ---                                */              
DEFINE VARIABLE vCodOpcao               AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vCodEmbalagem           AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vCodItem                AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vNumCont                AS INTEGER              INIT 0   NO-UNDO.
DEFINE VARIABLE vNumVolumeTMP           AS INTEGER              INIT 0   NO-UNDO.
DEFINE VARIABLE vNumSeq                 AS INTEGER              INIT 0   NO-UNDO.
DEFINE VARIABLE wgbosc099               AS WIDGET-HANDLE                 NO-UNDO.
DEFINE VARIABLE wgbosc032               AS WIDGET-HANDLE                 NO-UNDO.
DEFINE VARIABLE wgbosc109               AS WIDGET-HANDLE                 NO-UNDO.
DEFINE VARIABLE wgbosc044               AS WIDGET-HANDLE                 NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE vLogProcesso            AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE v-cod-estabel           AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE v-cod-local             AS CHARACTER                     NO-UNDO.

DEFINE TEMP-TABLE tt-zoom NO-UNDO
            FIELD cod-item          AS CHARACTER FORMAT 'X(16)'
            FIELD cod-lote          AS CHARACTER FORMAT 'X(40)'
            FIELD cod-refer         AS CHARACTER FORMAT 'X(03)'
            FIELD dt-validade       AS DATE      FORMAT '99/99/9999'
            FIELD qtd-item          AS DECIMAL
            FIELD des-item          AS CHARACTER FORMAT 'X(40)'.

DEFINE QUERY qry-zoom FOR tt-zoom.

DEFINE BROWSE brw-zoom QUERY qry-zoom NO-LOCK
             DISPLAY tt-zoom.cod-item 
                     tt-zoom.cod-lote 
                     tt-zoom.dt-validade
                     tt-zoom.des-item 
                     WITH NO-BOX NO-LABELS SIZE 20 BY 8 NO-SCROLLBAR-VERTICAL.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   brw-zoom                                           At Row 01 Col 01 

&global-define Frame01Repeat No

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-zoom
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. Assign vLogSai = Yes vLogFinaliza = YES. RETURN RETURN-VALUE.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'return':U OF brw-zoom In Frame Frame01 ~
                            DO:                                        ~
                                Apply 'GO':U To This-procedure.        ~
                            END.                                       

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc099
&global-define ActiveObject2 wgbosc032
&global-define ActiveObject3 wgbosc109
&global-define ActiveObject4 wgbosc044
/************************************************************/
RUN scbo/bosc099.p PERSISTENT SET wgbosc099       NO-ERROR.

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
   DEFINE VARIABLE vDesItem AS CHARACTER NO-UNDO.

   EMPTY TEMP-TABLE tt-itens.
   EMPTY TEMP-TABLE tt-zoom.

   IF NOT VALID-HANDLE(wgbosc099) THEN DO:
      RUN scbo/bosc099.p PERSISTENT SET wgbosc099.
      RUN openQueryStatic IN wgbosc099 (INPUT "Main":U) NO-ERROR.
   END.

   IF ttWork.log-estorna THEN
      RUN getItensPackingEstorno IN wgbosc099 (INPUT ttWork.cod-estabel, 
                                               INPUT ttWork.cod-local, 
                                               INPUT ttWork.cdd-embarq, 
                                               INPUT ttWork.num-resumo,
                                               INPUT ttWork.cod-pedcli,
                                               INPUT ttWork.nom-abrev,
                                               INPUT ttWork.num-documento,
                                               INPUT ttWork.cod-volume,
                                               INPUT ttWork.num-volume,
                                               OUTPUT TABLE tt-itens).
   ELSE DO:
      IF ttWork.cod-item = '777777' THEN DO: /* Via item com seriais */
          RUN getItensPacking IN wgbosc099 (INPUT ttWork.cod-estabel, 
                                            INPUT ttWork.cod-local, 
                                            INPUT ttWork.cdd-embarq, 
                                            INPUT ttWork.num-resumo,
                                            INPUT ttWork.cod-pedcli,
                                            INPUT ttWork.nom-abrev,
                                            INPUT ttWork.num-documento,
                                            OUTPUT TABLE tt-itens).
      END.
      IF ttWork.cod-item = '666666':U THEN DO: /* Via item sem seriais */
         IF NOT VALID-HANDLE(wgBOSC032) THEN DO:
             RUN scbo/bosc032.p PERSISTENT SET wgBOSC032.
             RUN openQueryStatic IN wgBOSC032 (INPUT "Main":U) NO-ERROR.
         END.
         
         IF NOT VALID-HANDLE(wgBOSC109) THEN DO:
             RUN scbo/bosc109.p PERSISTENT SET wgBOSC109.
         END.
         
         RUN setConstraintFaixa IN wgBOSC109 (INPUT ttWork.cod-estabel,         
                                              INPUT ttWork.cod-estabel,         
                                              INPUT ttWork.cod-local,           
                                              INPUT ttWork.cod-local,           
                                              INPUT "",                         
                                              INPUT "zzzzzzzzz",                
                                              INPUT "",                         
                                              INPUT "zzzzzzzzz",                
                                              INPUT ttWork.cdd-embarq,         
                                              INPUT ttWork.cdd-embarq,         
                                              INPUT 0,                          
                                              INPUT 99999999).           
         
         RUN openQueryStatic IN wgBOSC109 (INPUT "Faixa2":U) NO-ERROR.
         
         RUN getRecord IN wgBOSC109 (OUTPUT TABLE ttwm-pedidos).
         
         IF VALID-HANDLE(wgBOSC109) THEN
            RUN destroy IN wgBOSC109.
         
         FOR EACH ttwm-pedidos:
            RUN getMovtoPedidoDevolPickingNew IN wgBOSC032 (INPUT ttWork.cod-estabel,
                                                            INPUT ttWork.cod-local,
                                                            INPUT ttWork.cdd-embarq,
                                                            INPUT ttwm-pedidos.nr-resumo,      
                                                            INPUT ttwm-pedidos.nr-pedcli,        
                                                            INPUT ttwm-pedidos.nome-abrev,     
                                                            OUTPUT TABLE tt-devol-picking).
            FOR EACH tt-devol-picking:
               IF tt-devol-picking.qtd-item = tt-devol-picking.qtd-devol THEN DO:
                  DELETE tt-devol-picking.
                  NEXT.
               END.
               ASSIGN tt-devol-picking.qtd-item = tt-devol-picking.qtd-item - tt-devol-picking.qtd-devol
                      tt-devol-picking.qtd-devol = 0.
               CREATE tt-itens.
               ASSIGN tt-itens.cod-item  = tt-devol-picking.cod-item
                      tt-itens.cod-lote  = tt-devol-picking.cod-lote
                      tt-itens.cod-refer = tt-devol-picking.cod-refer
                      tt-itens.qtd-item  = tt-devol-picking.qtd-item.
            END.
         END.
         IF VALID-HANDLE(wgBOSC032) THEN
            RUN destroy IN wgBOSC032.
      END.
   END.
   
   IF VALID-HANDLE(wgbosc099) THEN
     RUN destroy IN wgbosc099.
   
   IF NOT VALID-HANDLE(wgBOSC044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgBOSC044.
      RUN openQueryStatic IN wgBOSC044 (INPUT "Main":U) NO-ERROR.
   END.
   
   FOR EACH tt-itens: 
      BUFFER-COPY tt-itens TO tt-zoom.
      RUN goToKey IN wgBOSC044 (INPUT tt-itens.cod-item).
      IF RETURN-VALUE = "OK":U THEN DO:
         RUN getCharField IN wgBOSC044 (INPUT "des-item":U,
                                        OUTPUT vDesItem).
         ASSIGN tt-zoom.des-item = vDesItem.
      END.
      ELSE 
         ASSIGN tt-zoom.des-item = "Item desconhecido":U.
      
      RELEASE tt-zoom.
   END.
   IF VALID-HANDLE(wgBOSC044) THEN
      RUN destroy IN wgBOSC044.
   
   OPEN QUERY qry-zoom
     FOR EACH tt-zoom
           BY tt-zoom.cod-item.   
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   IF NOT AVAIL tt-zoom THEN DO:
      RETURN 'NOK':U.
   END.
   ASSIGN ttWork.qtd-item      = tt-zoom.qtd-item   
          ttWork.cod-item      = tt-zoom.cod-item   
          ttWork.cod-lote      = tt-zoom.cod-lote   
          ttWork.cod-refer     = tt-zoom.cod-refer.
          ttWork.dat-validade  = tt-zoom.dt-validade.
   RETURN 'OK':U.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   **********************************/
