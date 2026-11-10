/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9028 2.00.00.026 } /*** "010026" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9028 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9029.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - abril/2005 - Paulo Eduardo Budal - Cria‡Æo do programa      **
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
**                        Ex: &global-define ActiveObject h-bosc074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9028
/************************************************************/

{utp/utapi009.i} /* login */
{utp/ut-glob.i}
{cdp/cdcfgmat.i}
/* Definicao da temp-table de integracao ---                */

&global-define TEMPTABLE tt-reporte-serial-wms
{bcp/bc9028.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.

{method/dbotterr.i}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/


/* ************************** Definitions ******************************** */
DEFINE VARIABLE vcod-senha          AS CHARACTER  FORMAT 'x(14)':U              NO-UNDO.
DEFINE VARIABLE vNomeUsuario        AS CHARACTER                                NO-UNDO.
DEFINE VARIABLE vLogControlaLogin   AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE vProcesso           AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE iUnidContr          AS INTEGER                                  NO-UNDO.
DEFINE VARIABLE h-bcapiwms          AS HANDLE                                   NO-UNDO.
DEFINE VARIABLE h-bcapi9029         AS HANDLE                                   NO-UNDO.
DEFINE VARIABLE h-bosc074           AS HANDLE                                   NO-UNDO.
DEFINE VARIABLE h-bosc044           AS HANDLE                                   NO-UNDO.
DEFINE VARIABLE h-bosc047           AS HANDLE                                   NO-UNDO.
DEFINE VARIABLE l-utiliz-etiq-movto AS LOGICAL                      INITIAL NO  NO-UNDO.
DEFINE VARIABLE c-cod-local         LIKE wm-local.cod-local                     NO-UNDO.
/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Reporte WMS '                                     At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
                             
&global-define Frame01Repeat NO 

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Reporte WMS   '                                   At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Estab Entrada:'                                   AT ROW 03 COL 01          ~
                              ttWork.cod-estabel                                AT ROW 04 COL 01 NO-LABEL ~
                             'Depos Entrada:'                                   AT ROW 05 COL 01          ~
                              ttWork.cod-depos                                  AT ROW 06 COL 01 NO-LABEL ~

&global-define Frame02Repeat NO

&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Reporte WMS'                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Etiqueta:'                                        AT ROW 03 COL 01          ~
                              ttWork.num-serial                                 AT ROW 04 COL 01 NO-LABEL ~
                             'Opera: '                                          AT ROW 05 COL 01          ~
                             ttWork.op-codigo                                   AT ROW 05 COL 08 NO-LABEL ~
                             'PtoCont: '                                        At Row 06 Col 01          ~
                             ttWork.pto-controle                                At Row 06 Col 10 No-label ~

&global-define Frame03Repeat YES
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha         WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&global-define Update02Fields ttWork.cod-estabel ttWork.cod-depos
&GLOBAL-DEFINE Update03Fields ttWork.num-serial

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
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
                            ON 'ESC':U OF Frame Frame01 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES      ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES  ~
                                       vLogCancela = YES.  ~
                                Return 'NOK':U.            ~
                            END. ~
                            ON 'ESC':U OF Frame Frame02 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END. ~
                            ON 'ESC':U OF Frame Frame03 ~
                            DO:                         ~
                                ASSIGN vlogerro = YES.  ~
                                Return 'ESC':U.         ~
                            END. ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 h-bcapiwms
&global-define ActiveObject2 h-bcapi9029
&global-define ActiveObject3 h-bosc074
&global-define ActiveObject4 h-bosc044
&global-define ActiveObject5 h-bosc047


/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN bcp/bcapiwms.p PERSISTENT SET h-bcapiwms NO-ERROR.
RUN scbo/bosc044.p PERSISTENT SET h-bosc044  NO-ERROR.

RUN scbo/bosc047.p PERSISTENT SET h-bosc047.
RUN openQueryStatic IN h-bosc047 (INPUT "Main":U) NO-ERROR.

RUN scbo/bosc074.p PERSISTENT SET h-bosc074  NO-ERROR.
RUN openQueryStatic IN h-bosc074 (INPUT "Main":U) NO-ERROR.

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
   IF RETURN-VALUE = 'NOK':U THEN DO:
      ASSIGN vlogerro     = YES     
             vLogSai      = YES      
             vLogFinaliza = YES
             vLogCancela  = YES. 
      HIDE ALL NO-PAUSE.
      RETURN ERROR.
   END.
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   EMPTY TEMP-TABLE ttWork.
   
   CREATE ttWork.   
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U. /* login autom tico */
      
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
   ASSIGN vLogErro     = NO                               
          vLogsai      = NO                               
          vLogfinaliza = NO.
   
   IF v_cod_usuar_corren = '' THEN
      RETURN ERROR.
   FIND FIRST ttwork NO-ERROR.
   ASSIGN ttWork.cod-estabel   = ""                         
          ttWork.cod-depos     = "".
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame04 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
********************************************************************
********************************/
PROCEDURE InicializaCamposFrame03:
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   FIND FIRST ttWork NO-LOCK NO-ERROR.
   
   ASSIGN ttWork.num-serial   = 0
          ttWork.op-codigo    = 0
          ttWork.pto-controle = 0.
   
   ASSIGN ttWork.num-serial:SCREEN-VALUE IN FRAME frame03   = STRING(ttWork.num-serial)
          ttWork.op-codigo:SCREEN-VALUE IN FRAME frame03    = STRING(ttWork.op-codigo)
          ttWork.pto-controle:SCREEN-VALUE IN FRAME frame03 = STRING(ttWork.pto-controle).
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   ASSIGN vLogErro          = NO 
          vLogControlaLogin = NO.
   
   /* valida usuario mestre contra mguni do EMS */
   IF ttWork.cod-usuario = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "101" "Usu rio Inv lido (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RUN loginuser IN h-bcapiwms (INPUT ttWork.cod-usuario,
                                INPUT vcod-senha,
                                OUTPUT TABLE tt-erro).
   IF RETURN-VALUE <> "OK" THEN DO:
      FOR EACH tt-erro NO-LOCK:
         RUN bcp/bc9115.p (tt-erro.cd-erro,
                           tt-erro.mensagem,
                           8,
                           20,
                           3).
         ASSIGN vLogErro = YES.
      END.
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RUN validateUser IN h-bcapiwms (INPUT ttWork.cod-usuario,
                                   INPUT 07,
                                   OUTPUT TABLE tt-erro).
   IF RETURN-VALUE <> "OK" THEN DO:
      FOR EACH tt-erro NO-LOCK:
         RUN bcp/bc9115.p (tt-erro.cd-erro,
                           tt-erro.mensagem,
                           8,
                           20,
                           3).
         ASSIGN vLogErro = YES.
      END.
   END.
   IF vLogErro = YES THEN  
      RETURN ERROR.
   
   FIND FIRST param-global NO-LOCK NO-ERROR.   
   IF AVAIL param-global AND param-global.modulo-cl = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "31638" "M¢dulo de Coleta de Dados NÆo Implantado "}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF ttWork.cod-coletor = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RUN ValidateEquipament IN h-bcapiwms ( INPUT ttWork.cod-coletor,
                                          INPUT ttWork.cod-equipamento,
                                          OUTPUT ttWork.tipo-equipamento,
                                          OUTPUT TABLE tt-erro).
   IF RETURN-VALUE <> "OK" THEN DO:
      FOR EACH tt-erro NO-LOCK:
         RUN bcp/bc9115.p (tt-erro.cd-erro,
                           tt-erro.mensagem,
                           8,
                           20,
                           3).
         vLogErro = YES.
      END.
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   ASSIGN {&TempTable}.cod-usuario      = ttWork.cod-usuario 
          {&TempTable}.cod-coletor      = ttWork.cod-coletor
          {&TempTable}.cod-equipamento  = ttWork.cod-equipamento
          {&TempTable}.tipo-equipamento = ttWork.tipo-equipamento.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   ASSIGN vLogErro          = NO 
          vLogControlaLogin = NO.
   
   FIND FIRST estabelec
        WHERE estabelec.cod-estabel = INPUT FRAME Frame02 ttWork.cod-estabel NO-LOCK NO-ERROR.
   IF NOT AVAIL estabelec THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Estabelecimento Inv lido (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   FIND FIRST deposito
        WHERE deposito.cod-depos = INPUT FRAME Frame02 ttWork.cod-depos NO-LOCK NO-ERROR.
   IF NOT AVAIL deposito THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Dep¢sito Inv lido (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RUN getLocalDepositoEstab IN h-bosc047 (INPUT ttWork.cod-estabel,
                                           INPUT deposito.cod-depos,
                                           OUTPUT c-cod-local).
   
   /* ALtera€ço para permitir depàsito de cq vinculado ao wms, abaixo */
   IF deposito.log-gera-wms = NO THEN DO:
      FIND FIRST wm-local-deposito
           WHERE wm-local-deposito.cod-estabel = estabelec.cod-estabel
             AND wm-local-deposito.cod-deposito = deposito.cod-depos NO-LOCK NO-ERROR.
      IF NOT AVAIL wm-local-deposito THEN DO:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "103" "Dep¢sito nÆo ‚ WMS (DC)"}
      END.
      ELSE DO:
         ASSIGN c-cod-local = wm-local-deposito.cod-local.
      END.
   END.

   RUN verificarUtilizaEtiqMovto IN h-bosc047(INPUT ttWork.cod-estabel,
                                              INPUT c-cod-local,
                                              OUTPUT l-utiliz-etiq-movto).
   IF NOT l-utiliz-etiq-movto THEN DO:
      ASSIGN vLogErro = YES.
      /*Tratamento erro (51820)*/
      {bcp/bc9105.i "51820" "Deposito Entrada nÆo utiliza etiqueta!"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   ASSIGN {&TempTable}.cod-estabel = INPUT FRAME Frame02 ttWork.cod-estabel
          {&TempTable}.cod-depos   = INPUT FRAME Frame02 ttWork.cod-depos.
END PROCEDURE.                                                                 

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
   ASSIGN vLogErro = NO.
   
   FIND FIRST bc-etiqueta
        WHERE bc-etiqueta.progressivo = STRING(ttWork.num-serial) NO-LOCK NO-ERROR.
   IF NOT AVAIL bc-etiqueta THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "0" "Etiqueta WMS nao possui correspondente no DC. Favor reimprimir a etiqueta."}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   EMPTY TEMP-TABLE rowerrors.
   
   RUN getInfoEtiqueta IN h-bosc074(INPUT ttWork.num-serial,
                                    OUTPUT TABLE ttWm-etiqueta).
   IF RETURN-VALUE <> "OK":U THEN DO:
      RUN getRowErrors IN h-bosc074 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors NO-LOCK:
         RUN bcp/bc9115.p (RowErrors.ErrorNumber, 
                           RowErrors.ErrorDescription,
                           8,
                           20,
                           3).
      END.
      ASSIGN vLogErro = YES.
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   FIND FIRST ord-prod
        WHERE ord-prod.nr-ord-produ = bc-etiqueta.nr-ord-produ NO-LOCK NO-ERROR.
   
   FIND FIRST item
        WHERE item.it-codigo = bc-etiqueta.it-codigo NO-LOCK NO-ERROR.
   IF NOT AVAIL item THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Item Inexistente. (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF NOT AVAIL ord-prod THEN DO:
      ASSIGN ttWork.num-livre-1 = item.rep-prod.
   END.
   ELSE DO:
      ASSIGN ttWork.num-livre-1 = ord-prod.rep-prod.
   END.
   
   FIND FIRST bc-etiqueta
        WHERE bc-etiqueta.progressivo = INPUT FRAME Frame03 ttWork.num-serial NO-LOCK NO-ERROR.
   IF AVAIL bc-etiqueta THEN DO:
      IF AVAIL ITEM THEN DO:
         IF ttWork.num-livre-1 = 2 THEN
            UPDATE ttWork.op-codigo WITH FRAME frame03.
         IF ttWork.num-livre-1 = 3 THEN
            UPDATE ttWork.pto-controle WITH FRAME frame03.
      END.
   END.
   
   FIND FIRST ttWm-etiqueta NO-LOCK NO-ERROR.   
   IF ttWm-etiqueta.log-reportada = YES THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Etiqueta j  reportada. (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF ttWm-etiqueta.ind-sit-agrupador <> 2              /* agrupador etiquetas */     
      AND ttWm-etiqueta.ind-sit-agrupador <> 3 THEN DO: /* agrupador proprio   */
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Etiqueta deve ser do tipo 'Agrupador Etiquetas' ou 'Agrupador Pr¢prio'. (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RUN setConstraintCod-item IN h-bosc044(INPUT bc-etiqueta.it-codigo,
                                          INPUT bc-etiqueta.it-codigo).
   RUN openquerystatic IN h-bosc044(INPUT "Cod-item":U).
   RUN goToKey IN h-bosc044 (INPUT bc-etiqueta.it-codigo).
   RUN getIntField IN h-bosc044 (INPUT "ind-unid-contr":U,
                                 OUTPUT iUnidContr).   
   IF iUnidContr = 2 THEN /* peso */
      ASSIGN {&TempTable}.qt-reporte = ttWm-etiqueta.qtd-peso.
   ELSE                              
      ASSIGN {&TempTable}.qt-reporte = ttWm-etiqueta.qtd-item.
   
   ASSIGN {&TempTable}.num-serial    = INPUT FRAME Frame03 ttWork.num-serial
          {&TempTable}.op-codigo     = INPUT FRAME Frame03 ttWork.op-codigo
          {&TempTable}.pto-controle  = INPUT FRAME Frame03 ttWork.pto-controle 
          {&temptable}.cod-item      = bc-etiqueta.it-codigo
          {&TempTable}.num-livre-1   = ttWork.num-livre-1
          {&TempTable}.nr-ord-produ  = bc-etiqueta.nr-ord-produ
          {&TempTable}.tipo-equipamento          = ttWork.num-livre-1      
          {&TempTable}.cod-depos-sai = IF bc-etiqueta.cod-depos <> "" THEN bc-etiqueta.cod-depos ELSE ?
          {&TempTable}.cod-local-sai = IF bc-etiqueta.cod-local <> "" THEN bc-etiqueta.cod-local ELSE ?
          {&TempTable}.lote-serie    = bc-etiqueta.lote
          {&TempTable}.dt-vali-lote  = bc-etiqueta.dt-validade
          {&TempTable}.cod-refer     = bc-etiqueta.referencia
          {&TempTable}.un            = item.un.
   
   IF item.tipo-contr = 1 THEN DO:
      ASSIGN {&TempTable}.cod-cta-unif    = item.ct-codigo
             {&TempTable}.cod-ccusto-unif = item.sc-codigo.
   END.                                                           
   
   IF {&TempTable}.num-livre-1 <> 4 THEN DO:
      FIND FIRST ord-prod
           WHERE ord-prod.nr-ord-produ = bc-etiqueta.nr-ord-produ NO-LOCK NO-ERROR.
      IF ord-prod.cod-estabel <> INPUT FRAME Frame02 ttWork.cod-estabel THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "103" "Estabelecimento informado no coletor ‚ diferente do estabelecimento da Ordem de Produ‡Æo (DC)"}
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.                                       
   IF vLogErro = NO THEN
      RUN GravaTransacao.   
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
PROCEDURE GravaTransacao:
   ASSIGN vTransDetail = VTransaction
                         + " Serial: " + STRING({&TempTable}.num-serial) 
                         + " Item: "   + STRING(TRIM({&TempTable}.cod-item)).
   
   RUN _RetornaUsuario (OUTPUT vNomeUsuario).
   
   ASSIGN {&TempTable}.dat-transacao = TODAY
          {&TempTable}.data          = TODAY
          {&TempTable}.cod-usuario   = vNomeUsuario.
   
   RAW-TRANSFER {&TempTable} TO vConteudoRaw.
   
   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */
   
   FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-erro-after-GenerateDC AND RETURN-VALUE = "OK":U THEN DO:
      RUN bcp/bc9115.p (0,
                        "Reporte executado com sucesso.",
                        8,
                        20,
                        3).
      HIDE ALL.
   END.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
/*************************************  Codigo do Usuario Fim   **********************************/
