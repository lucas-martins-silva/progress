/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9037 2.00.00.010 } /*** "010010" 12/07/2024 14:22:00  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9037 MBC}
&ENDIF


/***************************************************************************************************
** Copyright DATASUL S.A. (2003)                                                                  **
** Todos os Direitos Reservados.                                                                  **
**                                                                                                **
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao                               **
** parcial ou total por qualquer meio, so podera ser feita mediante                               **
** autorizacao expressa.                                                                          **
****************************************************************************************************/
{include/i_dbinst.i}                                       /* versao das bases e bases instaladas **/
/***************************************************************************************************
** Copyright DATASUL S.A. (2002)                                                                  **
** Todos os Direitos Reservados.                                                                  **
**                                                                                                **
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao                               **
** parcial ou total por qualquer meio, so podera ser feita mediante                               **
** autorizacao expressa.                                                                          **
****************************************************************************************************/
/***************************************************************************************************
** Programa..: bc9037.p                                                                           **
**                                                                                                **
** Versao....: 2.00.00.000 - agosto/2006 - Thiago Bravo - Programa Inicial                        **
**                                                                                                **
** Objetivo..: Templates DC Interface para transacao de Consulta de Caixa                         **
**             Resumo WMS                                                                         **
****************************************************************************************************/

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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
****************************************************************************************************/

/************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9037              /* transacao */
/************************************************************/
{utp/utapi009.i}                                   /* login */
/************************************************************/
/* Definicao da temp-table de integracao ---                */
{bcp/bc9037.i}

DEFINE TEMP-TABLE tt-wms-etiq-packing NO-UNDO
    FIELD val-etiq-packing             AS DECIMAL      FORMAT ">>>>>>>>>>>>>>9":U DECIMALS 0
    FIELD cod-estabel                  AS CHARACTER    FORMAT "X(03)":U
    FIELD cod-local                    AS CHARACTER    FORMAT "X(03)":U
    FIELD cod-embalagem                AS CHARACTER    FORMAT "X(10)":U
    FIELD dt-geracao                   AS DATE         FORMAT "99/99/9999":U
    FIELD hra-gerac                    AS CHARACTER    FORMAT "99:99:99":U
    FIELD cdd-embarq                   AS DECIMAL      FORMAT ">>>>>>>>>>>>>>>9":U
    FIELD nr-resumo                    AS INTEGER      FORMAT ">>>>,>>9":U
    FIELD nr-pedido                    AS INTEGER      FORMAT ">>>,>>>,>>9":U
    FIELD nr-pedcli                    AS CHARACTER    FORMAT "X(12)":U
    FIELD nome-abrev                   AS CHARACTER    FORMAT "X(12)":U
    FIELD cod-usuario                  AS CHARACTER    FORMAT "X(12)":U
    FIELD cod-usuar-leitura            AS CHARACTER    FORMAT "X(08)":U
    FIELD dt-leitura                   AS DATE         FORMAT "99/99/9999":U
    FIELD cod-usuario-ult-acesso       AS CHARACTER    FORMAT "X(12)":U
    FIELD dt-ult-acesso                AS DATE         FORMAT "99/99/9999":U
    FIELD hra-ult-aces                 AS CHARACTER    FORMAT "99:99:99":U
    FIELD log-efetua-packing           AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD log-impressa                 AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD log-confer                   AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD log-bloqdo                   AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD log-embcado                  AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD log-inutzado                 AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD num-volume                   AS INTEGER      FORMAT ">>>>>>>>>9":U
    FIELD idi-tip-gerac                AS INTEGER      FORMAT "9":U
    FIELD cod-livre-1                  AS CHARACTER    FORMAT "X(100)":U
    FIELD cod-livre-2                  AS CHARACTER    FORMAT "X(100)":U
    FIELD log-livre-1                  AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD log-livre-2                  AS LOGICAL      FORMAT "Sim/NÆo"
    FIELD num-livre-1                  AS INTEGER      FORMAT "->>>>>>>>9":U
    FIELD num-livre-2                  AS INTEGER      FORMAT "->>>>>>>>9":U
    FIELD val-livre-1                  AS DECIMAL      FORMAT "->>>>>>>>>>>9.9999":U DECIMALS 10
    FIELD val-livre-2                  AS DECIMAL      FORMAT "->>>>>>>>>>>9.9999":U DECIMALS 10
    FIELD dat-livre-1                  AS DATE         FORMAT "99/99/9999":U
    FIELD dat-livre-2                  AS DATE         FORMAT "99/99/9999":U
    FIELD r-Rowid                      AS ROWID. 

{scbo/bosc074.i tt-wm-etiqueta}
{scbo/bosc074.i tt-itens-etiqueta}

&global-define TempTable tt-despalletizacao

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.

DEFINE TEMP-TABLE RowErrors   NO-UNDO
       FIELD ErrorSequence    AS INTEGER 
       FIELD ErrorNumber      AS INTEGER 
       FIELD ErrorDescription AS CHARACTER  
       FIELD ErrorParameters  AS CHARACTER  
       FIELD ErrorType        AS CHARACTER  
       FIELD ErrorHelp        AS CHARACTER  
       FIELD ErrorSubType     AS CHARACTER.

DEFINE VARIABLE de-etiqueta     AS DECIMAL    FORMAT '>>>>>>>>>>>>>>'         NO-UNDO.
DEFINE VARIABLE c-etiqueta      AS CHARACTER  FORMAT 'x(18)':U     INIT ''    NO-UNDO.
DEFINE VARIABLE l-exibe-msg     AS LOGICAL                         INIT YES   NO-UNDO.
DEFINE VARIABLE c-separador     AS CHAR       FORMAT 'x(3)':U      INIT ' / ' NO-UNDO.
DEFINE VARIABLE vNomeUsuario    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE i-sit-agrup     AS INTEGER    NO-UNDO.
DEFINE VARIABLE de-id-agrupador AS DECIMAL    NO-UNDO.
DEFINE VARIABLE wgBOSC152       AS HANDLE     NO-UNDO.
DEFINE VARIABLE wgbcapiwms      AS HANDLE     NO-UNDO. 

/**************************************************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Propriedades globais para frames ---                                                           */              
&global-define FrameSize    20 By 8 

/* Definicao da Frame01 ---                                                                       */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Despalletiza‡Æo     '            AT ROW 01 COL 01          ~
                             '--------------------'            AT ROW 02 COL 01          ~
                             'Usr:'                            AT ROW 03 COL 01          ~
                             ttWork.cod-usuario                AT ROW 03 COL 05 NO-LABEL FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                            AT ROW 04 COL 01          ~
                             vcod-senha                        AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                            AT ROW 05 COL 01          ~
                             ttWork.cod-coletor                AT ROW 05 COL 05 NO-LABEL ~
                             'Equ:'                            AT ROW 06 COL 01          ~
                             ttWork.cod-equipamento            AT ROW 06 COL 05 NO-LABEL
&global-define Frame01Repeat No


/* Definicao da Frame02 ---                                                                       */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Despalletiza‡Æo     '            AT ROW 01 COL 01          ~
                             '--------------------'            AT ROW 02 COL 01          ~
                             'Etiqueta:           '            AT ROW 03 COL 01          ~
                             de-etiqueta                     AT ROW 04 COL 01 NO-LABEL ~
                             
&global-define Frame02Repeat NO
/**************************************************************************************************/
/* Definicao dos campos a serem recebidos ---                                                     */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = ''  ~
                              vcod-senha WHEN ttWork.cod-usuario = ''          ~
                              ttWork.cod-coletor ttWork.cod-equipamento        ~

&global-define Update02Fields de-etiqueta
/**************************************************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = YES THEN DO: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'ESC':U OF Frame Frame01 DO:~
                                ASSIGN vlogerro     = YES  ~
                                       vLogSai      = YES  ~
                                       vLogFinaliza = YES. ~
                                       vLogCancela  = YES. ~
                                RETURN 'ESC':U.            ~
                            END.
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC092
&global-define ActiveObject2 wgbosc074
&global-define ActiveObject2 wgBOSC079
&global-define ActiveObject3 wgBOSC112
&global-define ActiveObject4 wgBOSC152 
&global-define ActiveObject5 wgbcapiwms
/************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

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
   IF RETURN-VALUE = 'ESC':U  THEN DO:
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
      ASSIGN vcod-senha:BLANK                IN FRAME frame01 = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U  /* login autom tico */
             vcod-senha:SCREEN-VALUE         IN FRAME frame01 = '****************':U. /* login autom tico */
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK                IN FRAME frame01 = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario                               = ''
             vcod-senha                                       = ''  
             vcod-senha:SCREEN-VALUE         IN FRAME Frame01 = ''.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   
   ASSIGN vLogErro            = NO
          vLogsai             = NO
          vLogfinaliza        = NO
          ttWork.des-endereco = ''
          vtexto              = '' .
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.

   /* VALIDA€AO USUµRIO */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
   END.
    
   IF v2_cod_usuar_corren = '' THEN DO:
      EMPTY TEMP-TABLE tt-erros.
      
      login:
      DO ON ERROR  UNDO login, LEAVE login
         ON QUIT   UNDO login, LEAVE login
         ON STOP   UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
          
         RUN btb/btapi910za.p (INPUT INPUT FRAME frame01 ttWork.cod-usuario, 
                               INPUT INPUT FRAME frame01 vCod-Senha, 
                               OUTPUT TABLE tt-erros) NO-ERROR.        
      END. 
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         ASSIGN vLogErro           = YES 
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            ASSIGN vLogErro           = YES 
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
       
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

      RUN piValidaUsuario IN wgbcapiwms (INPUT INPUT FRAME frame01 ttWork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
                                          
      IF VALID-HANDLE(wgbcapiwms) THEN
         DELETE PROCEDURE wgbcapiwms NO-ERROR.
                                                                       
      ASSIGN vLogControlaLogin = YES.
   END.

   IF NOT VALID-HANDLE(wgbosc079)  THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   
   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
    
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN ASSIGN v_cod_usuar_corren  = ''
                                             v2_cod_usuar_corren = ''.
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.                                           
   END.
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN ASSIGN v_cod_usuar_corren  = ''
                                             v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   IF ttWork.cod-coletor = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (DC)"}
   END.
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (DC)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

   /* instancia as BOs de forma persistente */
   IF NOT VALID-HANDLE(wgBOSC092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
   END.

   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor IN wgbosc092 (INPUT  ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento e se est  ativo */
   RUN validaEquipTransportador IN wgbosc092 (INPUT  ttWork.cod-equipamento,
                                              OUTPUT vCodTipoEquip,
                                              OUTPUT vLogAtivo,
                                              OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.
   IF vlogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   RETURN RETURN-VALUE.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
    
   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074       NO-ERROR.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.
    
   RUN goToKey IN wgbosc074 (INPUT de-etiqueta).

   IF RETURN-VALUE <> "OK":U THEN DO:
      IF VALID-HANDLE(wgbosc074) THEN
         RUN destroy IN wgbosc074.
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta inv lida"}
      UNDO,RETRY.
   END.
    
   IF VALID-HANDLE(wgbosc074) THEN
      RUN destroy IN wgbosc074.

   RUN GravaTransacao.
    
END PROCEDURE.


PROCEDURE GravaTransacao:

   ASSIGN vLogErro     = NO 
          vLogSai      = NO 
          vLogFinaliza = NO.

   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074       NO-ERROR.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.

   RUN goToKey IN wgbosc074 (INPUT de-etiqueta).
   RUN getIntField IN wgbosc074 (INPUT "ind-sit-agrupador":U, OUTPUT i-sit-agrup).

   IF i-sit-agrup = 1 THEN /* Etiqueta Nao Agrupadora, busca serial do agrupador */
      RUN getDecField IN wgbosc074 (INPUT "id-agrupador":U,
                                    OUTPUT de-id-agrupador).

   IF VALID-HANDLE(wgbosc074) THEN
      RUN destroy IN wgbosc074.
      
   IF VALID-HANDLE(wgbosc074) THEN
      RUN destroy IN wgbosc074.

   BUFFER-COPY ttWork TO {&TempTable}.

   RUN _RetornaUsuario (OUTPUT vNomeUsuario).

   ASSIGN vTransDetail = 'Col:':U + STRING(ttWork.cod-coletor) + ' ':U +
                         'Eqp:':U + STRING(ttWork.cod-equipamento)    + ' ':U +
                         'Usr:':U + STRING(vNomeUsuario)   + ' ':U +
                         'Etq:':U + STRING(de-etiqueta).
    
   ASSIGN {&TempTable}.data-transacao       = TODAY
          {&TempTable}.hora-transacao       = STRING(TIME,"hh:mm:ss")
          {&TempTable}.cod-usuario          = vNomeUsuario
          {&TempTable}.cod-equipamento      = ttWork.cod-equipamento
          {&TempTable}.cod-coletor          = ttWork.cod-coletor
          {&TempTable}.num-serial           = de-etiqueta
          {&temptable}.ind-sit-agrup-serial = i-sit-agrup
          {&TempTable}.num-serial-agrupador = de-id-agrupador.

   RAW-TRANSFER {&TempTable} TO vConteudoRaw.

   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */

   FIND FIRST tt-erro-after-GenerateDC NO-ERROR.
    
   IF AVAIL tt-erro-after-GenerateDC THEN DO:         
      FOR EACH tt-erro-after-GenerateDC:
         {bcp/bc9015.i2 string(tt-erro-after-GenerateDC.cd-erro) string(tt-erro-after-GenerateDC.mensagem)}
      END.
      HIDE ALL.
   END.
   ELSE DO:
      IF i-sit-agrup = 1 THEN DO:
         {bcp/bc9105.i "000" "Etiqueta desvinculada do Agrupador, despalletizacao concluida (DC)"}
      END.
      ELSE DO:
         {bcp/bc9105.i "000" "Etiquetas Desvinculadas, despalletizacao concluida (DC)"}
      END.
   END.
   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.

   RETURN 'OK':U.

END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.

