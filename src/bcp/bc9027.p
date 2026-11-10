/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9027 2.00.00.006 } /*** "010006" 21/03/2024 09:45:50  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9027 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9027.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - marco/2005 - Frank    - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao Montagem de pallet WMS              **
**                                                                                         **
********************************************************************************************/
DEFINE NEW GLOBAL SHARED VAR lMenu      AS LOGICAL           NO-UNDO.
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-ressup-wms.                                                      **
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
&global-define ProgramName BC9027
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-Montagem-Pallet
{bcp/bc9027.i}
{utp/ut-glob.i}

DEFINE TEMP-TABLE ttWork No-Undo Like {&TempTable}.

{scbo/bosc074.i ttwm-etiqueta} /*ttwm-etiqueta*/
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

CREATE ttWork.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

&global-define ActiveObject1 hbosc074
&global-define ActiveObject2 wgbcapiwms
&global-define ActiveObject3 wgbosc047
&global-define ActiveObject4 wgbosc092


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Mont. pallet WMS 1/3'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Estab:'                                           AT ROW 06 COL 01          ~
                              ttWork.cod-estabel                                AT ROW 06 COL 07 NO-LABEL ~
                             'Local:'                                           AT ROW 07 COL 01          ~
                              ttWork.cod-local                                  AT ROW 07 COL 07 NO-LABEL
&global-define Frame01Repeat NO

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Mont. pallet WMS 2/3'                             At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Etiq Pallet:        '                             At Row 03 Col 01          ~
                             ttWork.id-agrupador                                At Row 04 Col 01 No-label ~
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Mont. pallet WMS 2/3'                             At Row 01 Col 01          ~
                             '--------------------':U                           At Row 02 Col 01          ~
                             'Etiq Embalagem:     '                             At Row 03 Col 01          ~
                             ttWork.id-etiqueta                                 At Row 04 Col 01 No-label ~
&global-define Frame03Repeat NO

&global-define UserTriggers ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name}          ~
                            DO:                                                             ~
                                IF v_cod-coletor_corren     <> '' AND                       ~
                                   v_cod-equipamento_corren <> '' THEN DO:                  ~
                                    IF l-menu-padrao = YES THEN DO:                         ~
                                        ASSIGN l-menu-padrao = NO.                          ~
                                        APPLY "Enter":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}.  ~
                                    END.                                                    ~
                                    ELSE DO:                                                ~
                                        APPLY "ESC":U TO ttWork.cod-coletor IN FRAME {&Frame01Name}.    ~
                                    END.                                                    ~
                                END.                                                        ~
                            END.                                                            ~
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-estabel ~
                              ttWork.cod-local
&global-define Update02Fields ttWork.id-agrupador 
&global-define Update03Fields ttWork.id-etiqueta

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 



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
RUN scbo/bosc047.p PERSISTENT SET wgbosc047  NO-ERROR.
RUN openQueryStatic IN wgbosc047 (INPUT "Main":U) NO-ERROR.

RUN scbo/bosc092.p PERSISTENT SET wgbosc092  NO-ERROR.

RUN scbo/bosc074.p PERSISTENT SET hbosc074   NO-ERROR.
RUN openQueryStatic IN hbosc074 (INPUT "Main":U) NO-ERROR.

RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.


{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
{method/dbotterr.i} /* temp-table rowerrors */

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure e‹ executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame01:
   ASSIGN vLogErro    = NO
          vLogCancela = NO.
   /* caso tenha sido startado login automÿtico */
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login automÿtico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login automÿtico */
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''
             ttWork.cod-estabel   = ''
             ttWork.cod-local     = ''.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   ASSIGN ttwork.id-agrupador = 0.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   ASSIGN ttwork.id-etiqueta = 0.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure e‹ executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   ASSIGN vLogErro          = NO 
         vLogControlaLogin  = NO.
   
   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor IN wgBOSC092 (INPUT ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.
   
   IF ttWork.cod-estabel = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "200" "Estabelecimento Inv lido (DC)"}
      RETURN ERROR.
   END.
   
   RUN getNomEstabel IN wgbosc047 (INPUT ttWork.cod-estabel,
                                   OUTPUT vnom-estabel).   
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Estabelecimento Inv lido (WMS)"}
      RETURN ERROR.
   END.
   
   IF ttWork.cod-local = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "202" "Local Inv lido (DC)"}
      RETURN ERROR.
   END.
   
   RUN getNomLocal IN wgbosc047 (INPUT ttWork.cod-estabel,
                                 INPUT ttWork.cod-local,
                                 OUTPUT vnom-local).   
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "203" "Local Inv lido (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida usuario mestre contra mguni do EMS */
   IF ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Usuÿrio Invÿlido (DC)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RUN loginuser IN wgbcapiwms (INPUT ttWork.cod-usuario,
                                INPUT vcod-senha,
                                OUTPUT TABLE tt-erro).
   IF RETURN-VALUE <> "OK":U THEN DO:
      FOR EACH tt-erro NO-LOCK:
         RUN bcp/bc9115.p (INPUT tt-erro.cd-erro,
                           INPUT tt-erro.mensagem,
                           INPUT 8,
                           INPUT 20,
                           INPUT 3).
         ASSIGN vLogErro = YES.
      END.
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   ASSIGN {&TempTable}.cod-usuario = ttWork.cod-usuario 
          {&TempTable}.cod-coletor = ttWork.cod-coletor.
END PROCEDURE.
/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   Assign vLogErro = No.
   /* Validacoes Frame 01 Inicio --- */
   RUN emptyRowErrors IN hbosc074.
   RUN goToKey IN hbosc074 (INPUT ttwork.id-agrupador).
   
   /* Se nÆo achou a etiqueta */
   IF RETURN-VALUE = 'nok' OR ttwork.id-agrupador = 0 THEN DO:
       {bcp/bc9105.i "0" "Etiqueta agrupadora inexistente. (DC)"}
       ASSIGN vLogErro = YES.
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   RUN getRecord IN hbosc074 (OUTPUT TABLE ttWm-etiqueta).
   FIND FIRST ttWm-Etiqueta NO-ERROR.
   
   /* Verifica se a etiqueta j  possui agrupador */
   IF ttWm-Etiqueta.ind-sit-agrupador <> 2 THEN DO:
      {bcp/bc9105.i "0" "Etiqueta nao ‚ do tipo agrupador. (DC)"}
      ASSIGN vLogErro = YES.
   END.
   ASSIGN ttwork.it-codigo = ttWm-etiqueta.cod-item
          ttwork.cod-refer = ttWm-etiqueta.cod-refer
          ttwork.cod-lote  = ttWm-etiqueta.cod-lote.
   
   IF vlogerro = YES THEN
      RETURN ERROR.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
   ASSIGN vLogErro = NO.
   /* Validacoes Frame 01 Inicio --- */
   
   /* Se informar 999999, retorna para a frame anterior */
   IF ttwork.id-etiqueta = 999999 THEN DO:
      ASSIGN ttwork.id-agrupador = 0.
      UPDATE ttwork.id-agrupador WITH FRAME frame02.
      RETURN NO-APPLY.
   END.
   
   /* Procura pela etiqueta no wms */
   RUN emptyRowErrors IN hbosc074.
   RUN goToKey IN hbosc074 (INPUT ttwork.id-etiqueta).
   
   /* Se nÆo achou a etiqueta */
   IF RETURN-VALUE = 'NOK':U OR ttwork.id-etiqueta = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Etiqueta inexistente. (DC)"}
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   /* Busca as informa‡oes da etiqueta  */
   RUN getRecord IN hbosc074 (OUTPUT TABLE ttWm-etiqueta).
   FIND FIRST ttWm-Etiqueta NO-ERROR.
   
   /* Verifica se a etiqueta j  possui agrupador */
   IF ttWm-Etiqueta.id-agrupador > 0 THEN DO:
      {bcp/bc9105.i "0" "Etiqueta j  possui agrupador. (DC)"}
      ASSIGN vLogErro = YES.
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   IF ttWm-Etiqueta.ind-sit-agrupador <> 1 THEN DO:
      {bcp/bc9105.i "0" "Etiqueta nao ‚ do tipo nao agrupador. (DC)"}
      ASSIGN vLogErro = YES.
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   IF ttWm-Etiqueta.cod-item <> ttwork.it-codigo THEN DO:
      {bcp/bc9105.i "0" "Etiqueta nao ‚ do mesmo item do agrupador. (DC)"}
      ASSIGN vLogErro = YES.
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   IF ttWm-Etiqueta.cod-refer <> ttwork.cod-refer THEN DO:
      {bcp/bc9105.i "0" "Etiqueta nao ‚ da mesma referencia do item do agrupador. (DC)"}
      ASSIGN vLogErro = YES.
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   IF ttWm-Etiqueta.cod-lote <> ttwork.cod-lote THEN DO:
      {bcp/bc9105.i "0" "Etiqueta nao ‚ do mesmo lote do item do agrupador. (DC)"}
      ASSIGN vLogErro = YES.
   END.
   IF vlogerro = YES THEN
      RETURN ERROR.
   
   /* Adiciona os valores da etiqueta na temp-table */
   IF AVAIL ttWm-Etiqueta  THEN DO:
      ASSIGN ttwork.qtd-item  = ttWm-Etiqueta.qtd-item
             ttwork.it-codigo = ttWm-Etiqueta.cod-item
             ttwork.qtd-peso  = ttWm-Etiqueta.qtd-peso.
   END.
   
   IF vLogErro = NO THEN DO:
      RUN GravaTransacao.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure e‹ executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
   DEF VAR vNomeUsuario            AS CHARACTER                NO-UNDO.
   
   ASSIGN vTransDetail = "It: "        + String(ttWork.it-codigo)
                         + " Agrup: "  + String(ttWork.id-agrupador)
                         + " Etiq: "   + STRING(ttWork.id-etiqueta) 
                         + " Qt item " + STRING(ttWork.qtd-item) 
                         + " Qt peso " + STRING(ttWork.qtd-peso)
                         + " Estab "   + STRING(ttWork.cod-estabel) 
                         + " Local "   + STRING(ttWork.cod-local).
   
   RUN _RetornaUsuario (OUTPUT vNomeUsuario).
   
   IF vNomeUsuario = '' THEN DO:
      ASSIGN vNomeUsuario = 'super':U.
   END.
   
   RAW-TRANSFER ttwork TO vConteudoRaw.
   
   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
