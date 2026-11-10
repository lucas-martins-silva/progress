/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9021 2.00.00.073 } /*** "010073" 09/10/2025 11:26:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i BC9021 MBC}
&ENDIF
 
{include/i_dbinst.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9021.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - dezembro/2002 - karla Klemke - Criaá∆o do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Devoluá∆o Picking WMS            **
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
&global-define ProgramName BC9021
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-devolve-picking
{bcp/bc9021.i}
{wmp/wm9000.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE TEMP-TABLE tt-etiq-resumo NO-UNDO
            FIELD nr-resumo        LIKE wm-docto-itens-ped-etiqueta.nr-resumo
            FIELD nr-pedcli        LIKE wm-docto-itens-ped.nr-pedcli         
            FIELD nome-abrev       LIKE wm-docto-itens-ped.nome-abrev        
            FIELD num-seq-item     LIKE wm-docto-itens-ped.num-seq-item
            FIELD num-seq-item-ped LIKE wm-docto-itens-ped.num-seq-item-ped
            FIELD id-etiqueta      LIKE wm-docto-itens-ped-etiqueta.qtd-item
            FIELD cod-item         LIKE wm-docto-itens-ped-etiqueta.cod-item
            FIELD qtd-item         LIKE wm-docto-itens-ped-etiqueta.qtd-item
            INDEX id IS PRIMARY UNIQUE nr-resumo
                                       nr-pedcli
                                       nome-abrev
                                       num-seq-item
                                       id-etiqueta.

DEF NEW GLOBAL SHARED VAR v_log_control_lista_tarefa AS LOGICAL INITIAL NO NO-UNDO. /* utilizado para controlar retorno quando n∆o h† lista mais lista de tarefa */

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

DEFINE TEMP-TABLE dc-ttWM-docto-itens NO-UNDO   LIKE ttWM-docto-itens.

DEFINE TEMP-TABLE tt-etiq NO-UNDO
            FIELD id-etiqueta      LIKE wm-etiqueta.id-etiqueta
            FIELD cod-item         LIKE wm-etiqueta.cod-item
            FIELD cod-refer        LIKE wm-etiqueta.cod-refer
            FIELD qtd-item         LIKE wm-etiqueta.qtd-item
            FIELD cdd-embarq       LIKE wm-pedidos.cdd-embarq
            FIELD nr-resumo        LIKE wm-pedidos.nr-resumo
            FIELD nome-abrev       LIKE wm-pedidos.nome-abrev
            FIELD nr-pedcli        LIKE wm-pedidos.nr-pedcli
            FIELD num-seq-item     LIKE wm-docto-itens-ped.num-seq-item
            FIELD num-seq-item-ped LIKE wm-docto-itens-ped.num-seq-item-ped
            FIELD item-pai         LIKE wm-item.cod-item
            INDEX id id-etiqueta.

DEFINE TEMP-TABLE tt-dev-picking NO-UNDO
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
            FIELD cdd-embarq         LIKE wm-docto-itens-ped.cdd-embarq
            FIELD nr-resumo          LIKE wm-docto-itens-ped.nr-resumo
            FIELD nr-pedcli          LIKE wm-docto-itens-ped.nr-pedcli
            INDEX codigo 
                  cod-estabel
                  cod-local
                  nr-pedcli
                  num-seq-item
                  cod-item
                  cod-refer
                  cod-lote
                  cod-embalagem
                  nr-entrega. 

DEFINE VARIABLE l-erro-qtd-picking    AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE i-cont-reg            AS INTEGER                         NO-UNDO.
DEFINE VARIABLE p-num-seq-item        LIKE wm-box-movto.num-seq-item     NO-UNDO.
DEFINE VARIABLE c-nr-pedcli           LIKE tt-etiq.nr-pedcli             NO-UNDO.
DEFINE VARIABLE i-nr-resumo           LIKE tt-etiq.nr-resumo             NO-UNDO.
DEFINE VARIABLE c-nome-abrev          LIKE tt-etiq.nome-abrev            NO-UNDO.
DEFINE VARIABLE wgbcapiwms            AS HANDLE                          NO-UNDO.  
DEFINE VARIABLE de-qtd-etiqueta-devol LIKE wm-docto-itens-devol.qtd-item NO-UNDO.

DEFINE BUFFER b-tt-etiq  FOR tt-etiq.
DEFINE BUFFER bfWm-docto FOR wm-docto.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

CREATE ttWork.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Devoluá∆o Pick. WMS '                                      At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label 
                             
&global-define Frame01Repeat NO 

/* Definicao da Frame02 ---                             */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Devoluá∆o Pick. WMS '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Estab:'                                           AT ROW 03 COL 01          ~
                              ttWork.cod-estabel                                AT ROW 03 COL 07 NO-LABEL ~
                             'Local:'                                           AT ROW 04 COL 01          ~
                              ttWork.cod-local                                  AT ROW 04 COL 07 NO-LABEL ~
                             'Documento:'                                       At Row 05 Col 01          ~
                              ttWork.num-documento                              At Row 06 Col 02 No-label ~
                             'Embarque:'                                        At Row 07 Col 01          ~
                             ttWork.cdd-embarq                                  At Row 08 Col 02 No-label ~
&global-define Frame02Repeat No

&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Devoluá∆o Pick. WMS '                             At Row 01 Col 01            ~
                             '--------------------'                             At Row 02 Col 01            ~
                             'Ser:'                                             At Row 03 Col 01            ~
                             vNumSerial                                         At Row 03 Col 05  No-label  ~
                             '777777-Lista Itens  '                             AT ROW 07 COL 01            ~
                             '999999-Finaliza Dev.'                             AT ROW 08 COL 01            ~
&global-define Frame03Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&global-define Update02Fields ttWork.cod-estabel ttWork.cod-local ttWork.num-documento ttWork.cdd-embarq
&global-define Update03Fields vNumSerial
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. If vNumSerial = 999999 THEN DO: Apply 'end-error':U To Frame Frame03. END.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      If vLogSai = Yes Then do: LEAVE _frame01. END. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.      If  Return-value = 'OK':U Then  LEAVE _frame03.


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
                            END. 
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc074
&global-define ActiveObject3 wgbosc074f
&global-define ActiveObject4 wgbosc099f
&global-define ActiveObject5 wgbosc092
&global-define ActiveObject6 wgbosc099
&global-define ActiveObject7 wgbcapi001
&global-define ActiveObject8 wgbosc038
&global-define ActiveObject9 wgbosc109
&global-define ActiveObject10 wgbcapiwms
&global-define ActiveObject11 wgbc9021f

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eÔ necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/************************************* Codigo do Usuario Inicio ************************************
** Este local Ç destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

PROCEDURE InicializaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure esta inicializando o campo tipo-trans da tela Frame01 com o valor 1 
           Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor
           caso seja retornado a proxima tela para esta.    
           Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame01}.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
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
             vcod-senha:SCREEN-VALUE IN FRAME frame01         = '****************':U
             vcod-senha                                       = '****************':U.
      
      IF v_cod-coletor_corren <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE     IN FRAME {&Frame01Name} = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''
             vcod-senha = ''.
   END.
END PROCEDURE.

PROCEDURE InicializaCamposFrame02:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure esta inicializando os campos da tela Frame02 com valores em branco
           Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame02}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   IF v_cod_usuar_corren = '' THEN
      RETURN ERROR.
   
   ASSIGN ttWork.cod-estabel   = '' 
          ttWork.cod-local     = ''
          ttWork.num-documento = ''
          ttWork.cdd-embarq    = 0
          vNumSerial           = 0.
   
   DISPLAY ttWork.cod-estabel  
           ttWork.cod-local    
           ttWork.num-documento
           ttWork.cdd-embarq
      WITH FRAME frame02.

   IF NOT VALID-HANDLE(wgbosc038) THEN DO:
      RUN scbo/bosc038.p PERSISTENT SET wgbosc038.
      RUN openQueryStatic IN wgbosc038 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc109) THEN DO:
      RUN scbo/bosc109.p PERSISTENT SET wgbosc109.
      RUN openQueryStatic IN wgbosc109 (INPUT "Main":U) NO-ERROR.
   END.
END PROCEDURE.

PROCEDURE InicializaCamposFrame03:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure esta inicializando os campos da tela Frame04 com valores em branco
           Esta procedure eÔ executada pelo pre-processador {&TriggerBeforeFrame04}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   IF RETURN-VALUE = 'NOK':U THEN DO:
      ASSIGN vLogErro = YES.
      RETURN RETURN-VALUE.
   END.
   ASSIGN v_log_control_lista_tarefa = NO.
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO
          vNumSerial   = 0.
END PROCEDURE.

PROCEDURE GravaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure esta armazenando na temp-table {&Temp-Table} os valores
           recebidos por ttWork na tela Frame 01. Esta procedure eÔ executada pelo
           pre-processador {&TriggerAfterFrame01}.   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   ASSIGN vLogErro          = NO
          vLogsai           = NO
          vLogfinaliza      = NO
          vLogErro          = NO
          vLogControlaLogin = NO.

   /* Validaá∆o usu†rio */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu†rio Inv†lido (DC)"}
   END. 
   IF v2_cod_usuar_corren = ''  THEN DO:
      EMPTY TEMP-TABLE tt-erros.
      
      login:
      DO ON ERROR  UNDO login, LEAVE login
         ON QUIT   UNDO login, LEAVE login
         ON STOP   UNDO login, LEAVE login
         ON ENDKEY UNDO login, LEAVE login: 
         
         RUN btb/btapi910za.p(INPUT INPUT FRAME frame01 ttwork.cod-usuario, 
                              INPUT INPUT FRAME frame01 vCod-Senha, 
                              OUTPUT TABLE tt-erros) NO-ERROR.        
      END. 
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado!(DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est†ˇcorreta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

      RUN piValidaUsuario IN wgbcapiwms (INPUT INPUT FRAME frame01 ttwork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
                                          
      IF VALID-HANDLE(wgbcapiwms) THEN
          DELETE PROCEDURE wgbcapiwms NO-ERROR.   
                                           
      ASSIGN vLogControlaLogin = YES.
   END.

   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.

   RUN validaUsuario IN wgbosc079 ( INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.                                           
      ASSIGN vLogErro = YES.
   END.
   
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu†rio sem permiss∆o para Coletor (WMS)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.

   IF ttWork.cod-coletor = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv†lido (DC)"}
   END.
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv†lido (DC)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.

   /* instancia as BOs de forma persistente */
   IF NOT VALID-HANDLE(wgbosc092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
   END.

   /* valida se equipamento Ç do tipo coletor */
   RUN validaEquipColetor IN wgbosc092(INPUT ttWork.cod-coletor,
                                       OUTPUT vCodTipoEquip,
                                       OUTPUT vLogAtivo,
                                       OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv†lido (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento e se est† ativo */
   RUN validaEquipamento IN wgbosc092 (INPUT ttWork.cod-equipamento,
                                       OUTPUT vLogAtivo,
                                       OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv†lido (WMS)"}
   END.
   
   IF vlogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Desativado (WMS)"}
   END.

   If vLogErro = YES THEN
      RETURN ERROR.
END PROCEDURE.

PROCEDURE GravaCamposFrame02:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame02}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.

   IF ttWork.cod-estabel = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "200" "Estabelecimento Inv†lido (DC)"}
      RETURN ERROR.
   END.

   RUN getnomestabel IN wgbosc038 ( INPUT ttWork.cod-estabel,
                                    OUTPUT vnom-estabel).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Estabelecimento Inv†lido (WMS)"}
      RETURN ERROR.
   END.

   IF ttWork.cod-local = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "202" "Local Inv†lido (DC)"}
      RETURN ERROR.
   END.

   RUN getNomLocal IN wgbosc038 (INPUT ttWork.cod-local,
                                 OUTPUT vnom-local).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "203" "Local Inv†lido (WMS)"}
      RETURN ERROR.
   END.

   IF ttWork.num-documento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "204" "Documento Inv†lido (DC)"}
      RETURN ERROR.
   END.

   RUN verifyDoctoSaida IN wgbosc038 ( INPUT ttWork.cod-estabel,
                                       INPUT ttWork.cod-local,
                                       INPUT ttWork.num-documento).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "205" "Documento Inv†lido (WMS)"}
      RETURN ERROR.
   END.

   IF ttWork.cdd-embarq = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "206" "Embarque Inv†lido (DC)"}
      RETURN ERROR.
   END.

   /* Alteraá∆o da bosc109 feita pelo Carlos Costa Jr, para resolver problema de performance.
      Para isto foi criado novo metodo.
      RUN verifyEmbarque IN wgbosc109 (INPUT ttWork.cdd-embarq). */
   RUN verifyEmbarqueEstabel IN wgbosc109(INPUT ttWork.cod-estabel,
                                          INPUT ttWork.cod-local,
                                          INPUT ttWork.cdd-embarq).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "207" "Embarque Inv†lido (WMS)"}
      RETURN ERROR.
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.
   
   RETURN 'OK':U.
END PROCEDURE.

PROCEDURE GravaCamposFrame03:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eÔ executada pelo pre-processador {&TriggerAfterFrame04}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEF VAR cmensagem      AS CHARACTER       NO-UNDO.
   DEF VAR vNomeUsuario   As CHARACTER       NO-UNDO.
   DEF VAR v-detalhe      AS CHARACTER       NO-UNDO.
   DEF VAR i-seq          AS INTEGER         NO-UNDO.

   IF NOT VALID-HANDLE(wgbc9021f) THEN DO:
      RUN bcp/bc9021f.p PERSISTENT SET wgbc9021f.
   END.
   
   RUN pi-popula-temp-table-devolucao IN wgbc9021f (INPUT ttWork.cod-estabel,
                                                    INPUT ttWork.cod-local,
                                                    INPUT ttWork.num-documento,
                                                    INPUT STRING(ttWork.cdd-embarq),
                                                    INPUT ttWork.cdd-embarq,
                                                    INPUT ttWork.cod-usuario,
                                                    OUTPUT TABLE tt-devolve-picking-bkp).

   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
          
   IF vNumSerial = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Serial Inv†lido (DC)"}
      RETURN ERROR.
   END.
   ASSIGN ttWOrk.num-serial = vNumSerial.

   IF ttWOrk.num-serial = 777777 THEN DO:
      FIND FIRST tt-etiq NO-LOCK NO-ERROR. 
      IF AVAIL tt-etiq THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "888" "Devoluá∆o Somente por Serial."}
         ASSIGN  vNumSerial = 0.
         RETURN ERROR.
      END.
      HIDE ALL NO-PAUSE. 
      /* pede item, referencia, lote.... */
      bc9021:
      DO ON ERROR  UNDO bc9021, LEAVE bc9021
         ON QUIT   UNDO bc9021, LEAVE bc9021
         ON STOP   UNDO bc9021, LEAVE bc9021
         ON ENDKEY UNDO bc9021, LEAVE bc9021:
                                     
         ASSIGN ttWork.cod-item     = ''
                ttWork.cod-lote     = '' 
                ttWork.cod-refer    = '' 
                ttWork.dat-validade = ?  
                ttWork.qtd-item     = 0. 

         /*se contiver erro nas quantidades ele n∆o deixar† criar o documento de devoluá∆o*/ 
         RUN bcp/bc9021z.p(INPUT-OUTPUT TABLE ttwork,
                           OUTPUT l-erro-qtd-picking,
                           OUTPUT p-num-seq-item, /* retorna a sequencia de origem (wm0390) do item */
                           OUTPUT TABLE tt-dev-picking) NO-ERROR.
         HIDE ALL NO-PAUSE.

         FIND FIRST ttWork NO-ERROR.
         
         IF RETURN-VALUE <> 'OK':U AND ttWork.cod-item = ''  THEN DO:
            ASSIGN vLogErro     = YES
                   vlogfinaliza = YES.
            RETURN.
         END.
         IF v_log_control_lista_tarefa = YES THEN DO: /* n∆o existem tarefas de ressuprimento */
            ASSIGN vLogfinaliza = YES.
            RETURN.
         END.
      END.
   END.

   EMPTY TEMP-TABLE ttWm-docto.
   EMPTY TEMP-TABLE ttWm-docto-itens. /* somente dever† ser populada quando informado item = 777777 serial */
   EMPTY TEMP-TABLE tt-etiq-resumo.

   IF NOT VALID-HANDLE(wgbosc099) THEN DO:
      RUN scbo/bosc099.p PERSISTENT SET wgbosc099.
      RUN openQueryStatic IN wgbosc099 (INPUT "Main":U) NO-ERROR.
   END.                                 

   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.
   IF ttWork.num-serial <> 777777 THEN DO:
      IF ttWork.num-serial <> 999999 THEN DO:
         RUN goToKey IN wgbosc074 (INPUT ttWork.num-serial).
         IF RETURN-VALUE = "NOK" THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "300" "Serial inexistente. (WMS)"}
            RETURN ERROR.
         END.        
      END.
   END.

   FIND FIRST ttWm-docto NO-LOCK NO-ERROR.
   IF NOT AVAIL ttWm-docto THEN
      CREATE ttWm-docto.

   IF ttWork.num-serial <> 777777 THEN DO:
      IF ttWork.num-serial <> 999999 THEN DO:
         RUN Gotokey IN wgbosc074 (INPUT ttWOrk.num-serial).
         RUN getEtiquetaResumo IN wgbosc099 (INPUT ttWork.cod-estabel,
                                             INPUT ttWork.cod-local,
                                             INPUT ttWork.cdd-embarq,
                                             INPUT ttWork.num-serial,
                                             OUTPUT TABLE tt-etiq-resumo).

         FOR EACH tt-etiq:
            FIND FIRST tt-etiq-resumo
                 WHERE tt-etiq-resumo.nr-resumo        = tt-etiq.nr-resumo       
                   AND tt-etiq-resumo.nome-abrev       = tt-etiq.nome-abrev      
                   AND tt-etiq-resumo.nr-pedcli        = tt-etiq.nr-pedcli       
                   AND tt-etiq-resumo.num-seq-item     = tt-etiq.num-seq-item
                   AND tt-etiq-resumo.num-seq-item-ped = tt-etiq.num-seq-item-ped
                   AND tt-etiq-resumo.id-etiqueta      = tt-etiq.id-etiqueta
                   AND tt-etiq-resumo.cod-item         = tt-etiq.cod-item NO-ERROR.
            IF AVAIL tt-etiq-resumo THEN DO:
               DELETE tt-etiq-resumo.
            END.
         END.
         FIND FIRST tt-etiq-resumo
              WHERE tt-etiq-resumo.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
         IF AVAIL tt-etiq-resumo THEN DO:
            FIND FIRST tt-etiq
                 WHERE tt-etiq.nr-resumo        = tt-etiq-resumo.nr-resumo   
                   AND tt-etiq.nome-abrev       = tt-etiq-resumo.nome-abrev  
                   AND tt-etiq.nr-pedcli        = tt-etiq-resumo.nr-pedcli
                   AND tt-etiq.num-seq-item     = tt-etiq-resumo.num-seq-item
                   AND tt-etiq.num-seq-item-ped = tt-etiq-resumo.num-seq-item-ped
                   AND tt-etiq.id-etiqueta      = tt-etiq-resumo.id-etiqueta 
                   AND tt-etiq.cod-item         = tt-etiq-resumo.cod-item NO-ERROR.            
            IF NOT AVAIL tt-etiq THEN DO:              
               CREATE tt-etiq.
               ASSIGN tt-etiq.id-etiqueta      = ttWork.num-serial.
            END.
         END.

         ASSIGN i-cont-reg = 0.
         FOR EACH tt-etiq-resumo:
            ASSIGN i-cont-reg = i-cont-reg + 1.
         END.

         IF i-cont-reg = 0 THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "303" "Serial j† devolvido ou n∆o est† no embarque. (WMS)"}
            RETURN.
         END.

         /* encontrou a leitura da etiqueta apenas uma vez no embarque */
         IF i-cont-reg = 1 THEN DO:
            FIND FIRST tt-etiq-resumo
                 WHERE tt-etiq-resumo.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
            IF AVAIL tt-etiq-resumo THEN DO:
               RUN getCharField IN wgbosc074(INPUT 'cod-item':U, 
                                             OUTPUT ttWork.cod-item).
               
               RUN getCharField IN wgbosc074(INPUT 'cod-refer':U,
                                             OUTPUT tt-etiq.cod-refer).
               
               RUN getCharField IN wgbosc074(INPUT 'cod-item':U,
                                             OUTPUT tt-etiq.cod-item).
      
               
               RUN getResumoPedido In wgbosc099(INPUT ttWork.cdd-embarq,
                                                INPUT ttWork.num-serial,
                                                INPUT tt-etiq-resumo.num-seq-item,
                                                OUTPUT tt-etiq.nr-resumo,
                                                OUTPUT tt-etiq.nr-pedcli,
                                                OUTPUT tt-etiq.nome-abrev,
                                                OUTPUT tt-etiq.num-seq-item-ped,
                                                OUTPUT tt-etiq.item-pai).            
               
               ASSIGN ttWork.nr-resumo         = tt-etiq-resumo.nr-resumo
                      ttWork.nr-pedcli         = tt-etiq-resumo.nr-pedcli
                      ttWork.nome-abrev        = tt-etiq-resumo.nome-abrev
                      ttWork.qtd-item          = tt-etiq-resumo.qtd-item
                      tt-etiq.qtd-item         = ttWork.qtd-item
                      tt-etiq.nr-resumo        = ttWork.nr-resumo    
                      tt-etiq.nr-pedcli        = ttWork.nr-pedcli 
                      tt-etiq.nome-abrev       = ttWork.nome-abrev
                      tt-etiq.num-seq-item     = tt-etiq-resumo.num-seq-item
                      tt-etiq.num-seq-item-ped = tt-etiq-resumo.num-seq-item-ped.
            END.
         END.
         ELSE DO:
            /* encontrou a leitura da etiqueta mais de uma vez no embarque. ser† solicitado de qual resumo ser† feita a devoluá∆o. */
            bc9021y:
            DO ON ERROR  UNDO bc9021y, LEAVE bc9021y
               ON QUIT   UNDO bc9021y, LEAVE bc9021y
               ON STOP   UNDO bc9021y, LEAVE bc9021y
               ON ENDKEY UNDO bc9021y, LEAVE bc9021y:
        
               /*se contiver erro nas quantidades ele n∆o deixar† criar o documento de devoluá∆o*/ 
               RUN bcp/bc9021y.p(INPUT TABLE tt-etiq-resumo,
                                 INPUT-OUTPUT TABLE ttwork,
                                 OUTPUT l-erro-qtd-picking) NO-ERROR.
        
               HIDE ALL NO-PAUSE.
        
               FIND FIRST ttWork NO-ERROR.
               
               IF l-erro-qtd-picking THEN DO:
                  DELETE tt-etiq.
                  LEAVE.
               END.

               RUN getCharField IN wgbosc074(INPUT 'cod-refer':U,
                                    OUTPUT tt-etiq.cod-refer).
                  
               RUN getCharField IN wgbosc074(INPUT 'cod-item':U,
                                             OUTPUT tt-etiq.cod-item).

               RUN getResumoPedido In wgbosc099(INPUT ttWork.cdd-embarq,
                                                INPUT ttWork.num-serial,
                                                INPUT ttWork.num-seq-item,
                                                OUTPUT tt-etiq.nr-resumo,
                                                OUTPUT tt-etiq.nr-pedcli,
                                                OUTPUT tt-etiq.nome-abrev,
                                                OUTPUT tt-etiq.num-seq-item-ped,
                                                OUTPUT tt-etiq.item-pai).            
               
               ASSIGN tt-etiq.num-seq-item     = ttWork.num-seq-item
                      tt-etiq.qtd-item         = ttWork.qtd-item
                      ttWork.num-seq-item-ped  = 0. /*zera para n∆o armazenar informaá∆o */
            END.
         END.
         
         IF l-erro-qtd-picking THEN
            LEAVE.
            
         RUN pi-atualiza-etiqueta IN wgbc9021f (INPUT ttWork.cod-estabel,
                                                INPUT ttWork.cod-local,
                                                INPUT ttWork.cdd-embarq,
                                                INPUT ttWork.num-serial,
                                                INPUT-OUTPUT TABLE tt-etiq).
         
         /* valida se o serial jaˇ encontra-se lido */
         RUN pi-valida-serial IN wgbc9021f ( INPUT ttWork.num-serial,
                                             INPUT TABLE tt-devolve-picking-bkp).
         IF RETURN-VALUE <> 'OK':U THEN DO: 
            HIDE ALL NO-PAUSE.
            {bcp/bc9105.i "110" "Serial j† coletado (DC)"}
            DELETE tt-etiq.
            RETURN.
         END.
      END.
   END.
   ELSE DO:
      RUN pi-valida-item IN wgbc9021f (INPUT ttWork.num-serial,
                                       INPUT ttWork.cod-item,
                                       INPUT ttWork.cod-refer,
                                       INPUT ttWork.cod-lote,
                                       INPUT TABLE tt-devolve-picking-bkp).
      IF RETURN-VALUE <> 'OK':U THEN DO: 
         ASSIGN vLogerro = YES.
         HIDE ALL NO-PAUSE.
         {bcp/bc9105.i "111" "Item j† coletado (DC)"}
         RETURN ERROR.
      END.
   END.

   /* l-erro-qtd-picking = erro na quantidade. Valor digitado pelo usuario,
      ou o item no documento do prÇ-faturamento n∆o est† conclu°do */
   IF (ttWork.num-serial = 777777 OR ttWork.num-serial = 999999) THEN DO:
      bc9021:
      DO TRANSACTION ON ERROR UNDO bc9021, LEAVE bc9021: 
         /* Informando etiquetas */
         IF ttWork.num-serial = 999999 THEN DO:
            IF NOT CAN-FIND(FIRST tt-etiq) THEN
               LEAVE.
               
            FOR EACH tt-etiq NO-LOCK
               BREAK BY tt-etiq.nr-resumo
                     BY tt-etiq.nr-pedcli
                     BY tt-etiq.nome-abrev
                     BY tt-etiq.num-seq-item-ped:

               /* valida etiquetas informadas em caso de item composto */
               IF FIRST-OF(tt-etiq.num-seq-item-ped) THEN DO:
                  RUN pi-valida-etiquetas.
                  IF RETURN-VALUE = "NOK":U THEN DO:
                     ASSIGN vLogErro = YES.
                     {bcp/bc9105.i "410" "Devoluá∆o do componente n∆o est† proporcional ao produto composto."}
                     RETURN ERROR.
                  END.
               END.

               IF LAST-OF(tt-etiq.nr-resumo) THEN DO:
                  ASSIGN c-nr-pedcli  = tt-etiq.nr-pedcli 
                         i-nr-resumo  = tt-etiq.nr-resumo 
                         c-nome-abrev = tt-etiq.nome-abrev.

                  RUN pi-confirma.
                  IF RETURN-VALUE = "NOK":U THEN
                     RETURN ERROR.
               END.
            END.
         END.
         ELSE DO:
            ASSIGN c-nr-pedcli  = ttWork.nr-pedcli 
                   i-nr-resumo  = ttWork.nr-resumo 
                   c-nome-abrev = ttWork.nome-abrev.

            RUN pi-confirma.
            IF RETURN-VALUE = "NOK":U THEN
               RETURN ERROR.
         END.
      END.
   END.
   ELSE
      RETURN.
END PROCEDURE.

PROCEDURE pi-valida-etiquetas:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEF BUFFER b-tt-etiq  FOR tt-etiq.
   DEF BUFFER b2-tt-etiq FOR tt-etiq.

   DEF VAR de-devol-tot     AS DECIMAL NO-UNDO. /* utilizada para acumular o total devolvido de um componente */
   DEF VAR de-resto         AS DECIMAL NO-UNDO. /* utilizada para o c†lculo da proporcionalidade entre o total devolvido do componente e a quantidade padr∆o do componente no composto */
   DEF VAR de-item-pai-prop AS DECIMAL NO-UNDO. /* utilizada para controlar a proporcionalidade entre todos os componentes devolvidos */
   DEF VAR de-anterior      AS DECIMAL NO-UNDO.

   /* As validaá‰es abaixo servem para garantir que o produto composto est† sendo devolvido em todo o KIT.
      Exemplo: 
      Item pai: A
      Item filhos: B (2 peáas)
                   C (3 peáas)
                   D (4 peáas)
    
      Foi criado um pedido solicitando 5 peáas do item A.
      Ent∆o, para separaá∆o no WMS ser∆o solicitados:
         10 peáas item B
         15 peáas item C
         20 peáas item D
    
      Caso tente ser devolvido: 
         3 peáas do item B 
      Neste caso, n∆o ser† poss°vel fazer a devoluá∆o de picking, porque 3 peáas se referem a 1,5 KIT do item A.
      Ser† apresentado erro.
    
      Caso tente ser devolvido:
         2 peáas do item B
         6 peáas do item C
      TambÇm n∆o ser† poss°vel fazer a devoluá∆o, porque est∆o sendo devolvidos 1 KIT pela quantidade do item B
      e 2 KITs pela quantidade do item C. 
    
      Conclus∆o: o usu†rio dever† sempre devolver a quantidade proporcional Ö quantidade que forma o KIT. */
   FOR EACH b-tt-etiq
      WHERE b-tt-etiq.cdd-embarq       = tt-etiq.cdd-embarq     
        AND b-tt-etiq.nr-resumo        = tt-etiq.nr-resumo       
        AND b-tt-etiq.nome-abrev       = tt-etiq.nome-abrev      
        AND b-tt-etiq.nr-pedcli        = tt-etiq.nr-pedcli       
        AND b-tt-etiq.num-seq-item-ped = tt-etiq.num-seq-item-ped
        AND b-tt-etiq.item-pai        <> "" 
      BREAK BY b-tt-etiq.num-seq-item-ped
            BY b-tt-etiq.cod-item
            BY b-tt-etiq.cod-refer:

      IF FIRST-OF(b-tt-etiq.num-seq-item-ped) THEN
         ASSIGN de-anterior  = ?.

      IF FIRST-OF(b-tt-etiq.cod-refer) THEN
         ASSIGN de-devol-tot = 0.

      ASSIGN de-devol-tot = de-devol-tot + b-tt-etiq.qtd-item.

      IF LAST-OF(b-tt-etiq.cod-refer) THEN DO:
         FIND FIRST prod-composto
              WHERE prod-composto.it-codigo-pai   = b-tt-etiq.item-pai
                AND prod-composto.it-codigo-filho = b-tt-etiq.cod-item
                AND prod-composto.cod-refer       = b-tt-etiq.cod-refer NO-LOCK NO-ERROR.
         IF AVAIL prod-composto THEN DO:
            ASSIGN de-resto         = de-devol-tot / prod-composto.qt-filho
                   de-resto         = IF  de-resto = ? THEN 0 ELSE de-resto
                   de-item-pai-prop = de-resto
                   de-resto         = de-resto - TRUNC(de-resto,0).

            IF de-resto <> 0 THEN DO:
               RETURN "NOK":U.
            END.

            IF de-anterior = ? THEN
               ASSIGN de-anterior = de-item-pai-prop.

            IF de-anterior <> ? AND de-anterior <> de-item-pai-prop THEN DO:
               RETURN "NOK":U.
            END.
         END.
      END.

      /* Verifica se todas as etiquetas dos itens filhos foram devolvidas */
      IF LAST-OF(b-tt-etiq.num-seq-item-ped) THEN DO:
         FOR EACH prod-composto
            WHERE prod-composto.it-codigo-pai = b-tt-etiq.item-pai NO-LOCK:
            
            FIND FIRST b2-tt-etiq
                 WHERE b2-tt-etiq.cod-item         = prod-composto.it-codigo-filho
                   AND b2-tt-etiq.cod-refer        = prod-composto.cod-refer
                   AND b2-tt-etiq.num-seq-item-ped = b-tt-etiq.num-seq-item-ped NO-LOCK NO-ERROR.
            IF NOT AVAIL b2-tt-etiq THEN
               RETURN "NOK":U.
         END.
      END.
   END.
END PROCEDURE.


PROCEDURE pi-confirma:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   DEF VAR i-seq          AS INTEGER         NO-UNDO.
   EMPTY TEMP-TABLE ttwm-etiqueta.

   /* se j† existe um documento de ressuprimento criado para este embarque, pedido,*/
   /* resumo e cliente cria a wm-docto-itens no mesmo documento                    */ 
   FIND FIRST wm-docto
        WHERE wm-docto.cod-estabel      = ttWork.cod-estabel
          AND wm-docto.cod-local        = ttWork.cod-local  
          AND wm-docto.nr-embarque      = 0
          AND wm-docto.cdd-embarq       = ttWork.cdd-embarq
          AND wm-docto.nr-pedcli        = c-nr-pedcli 
          AND wm-docto.nr-resumo        = i-nr-resumo 
          AND wm-docto.nome-abrev       = c-nome-abrev
          AND wm-docto.ind-origem-docto = 9
          AND wm-docto.ind-sit-docto    = 1 NO-LOCK NO-ERROR.
   IF AVAIL wm-docto THEN DO:
      RUN pi-altera-documento-wms.
   END.
   ELSE DO: /*se n∆o existe o documento criado, cria uma wm-docto nova*/
      RUN pi-cria-documento-wms.
   END.
     
   FIND FIRST RowErrors NO-LOCK NO-ERROR.
    IF RETURN-VALUE = 'NOK':U OR AVAILABLE rowErrors Then Do:
      EMPTY TEMP-TABLE tt-etiq.
      IF CAN-FIND(FIRST RowErrors
                  WHERE RowErrors.ErrorNumbeR <> 58041
                    AND RowErrors.ErrorNumber <> 58042) THEN
         ASSIGN vLogErro = YES.              
       
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)".
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.                                           
      
      IF vLogErro = YES THEN
         RETURN "NOK":U.
   END.
       
   FIND FIRST ttWm-docto NO-LOCK NO-ERROR.
   IF AVAIL ttWM-docto THEN DO:
      ASSIGN ttWork.num-documento    = ttWM-docto.num-docto
             ttWork.serie            = ttWM-docto.serie          
             ttWork.id-docto         = ttWM-docto.id-docto
             ttWork.num-docto-origem = DECIMAL(ttWM-docto.num-docto-origem)
             ttWork.ind-tipo-trans   = ttWM-docto.ind-tipo-trans
             ttWork.ind-origem-docto = ttWM-docto.ind-origem-docto
             ttWork.id-carga         = ttWM-docto.id-carga
             ttWork.alteracao        = ttWM-docto.alteracao
             ttWork.cod-depos        = ttWM-docto.cod-depos.
   END.

   /* grava na bc-trans e bc-trans-filho */
   EMPTY TEMP-TABLE tt-trans.
   EMPTY TEMP-TABLE tt-trans-filho.
   
   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMSai004':U                                                          
          tt-trans.detalhe  = 'Est:':U + TRIM(STRING(ttWork.cod-estabel))                            + ';':U +
                              'Loc:':U + TRIM(STRING(ttWork.cod-local))                              + ';':U + 
                              'Doc:':U + STRING(ttWork.num-documento)                                + ';':U + 
                              'DcO:':U + TRIM(STRING(ttWork.num-docto-origem,'>>>>>>>>>>>>>>>9':U))  + ';':U + 
                              'Emb:':U + TRIM(STRING(ttWork.cdd-embarq,'>>>>>>>>>>>>>>>9':U))        + ';':U + 
                              'Usr:':U + TRIM(ttWork.cod-usuario).
          tt-trans.usuario  = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.

   /* movimento de conclusao do documento depende da criacao da tt-trans-filho */ 
   IF ttWork.num-serial = 777777 OR ttWork.num-serial = 999999 THEN DO:
      ASSIGN i-seq = 1.
      FOR EACH ttWm-docto-itens:
         CREATE tt-trans-filho.
         ASSIGN tt-trans-filho.i-sequen-pai = 1
                tt-trans-filho.i-sequen     = i-seq
                tt-trans-filho.num-versao   = 1
                tt-trans-filho.conteudo-xml = 'IdD:':U + TRIM(string(ttwork.id-docto, '>>>>>>>>>9':U))          + ';':U + 
                                              'Seq:':U + TRIM(STRING(ttwm-docto-itens.num-seq-item,'>>>>>9':U)) + ';':U + 
                                              'Ser:':U + TRIM(STRING(ttWork.num-serial, '>>>>>>>>>>>>>9':U))    + ';':U + 
                                              'Ite:':U + TRIM(STRING(ttwm-docto-itens.cod-item))                + ';':U + 
                                              'Ref:':U + TRIM(STRING(ttwm-docto-itens.cod-refer))               + ';':U + 
                                              'Lot:':U + TRIM(STRING(ttwm-docto-itens.cod-lote))                + ';':U + 
                                              'Qtd:':U + TRIM(STRING(ttwm-docto-itens.qtd-item, '>>>,>>>,>>9.9999':U))
                i-seq = i-seq + 1.
      END.
   END.
       
   IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
      RUN bcp/bcapi001.p PERSISTENT SET wgbcapi001(INPUT-OUTPUT TABLE tt-trans,
                                                   INPUT-OUTPUT TABLE tt-erro).
   END.
   RUN cria_reg_wms IN wgbcapi001 ( INPUT 4, /* 4 = Estado da Transacao = Em Processo */
                                    INPUT-OUTPUT TABLE tt-trans,
                                    INPUT-OUTPUT TABLE tt-trans-filho,
                                    INPUT-OUTPUT TABLE tt-erro).
   
   RUN devolucao-picking-pre-api IN wgbc9021f ( INPUT-OUTPUT TABLE tt-trans,
                                                INPUT-OUTPUT TABLE tt-erro).

   FIND FIRST tt-erro NO-ERROR.
   IF AVAIL tt-erro OR RETURN-VALUE <> 'OK':U THEN DO: 
      HIDE ALL NO-PAUSE.
      {bcp/bc9105.i "903" "Problemas na Efetivaá∆o (DC)"}
      FOR EACH tt-erro:
         {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
      END.
      ASSIGN vLogErro = YES.
      EMPTY TEMP-TABLE tt-etiq.
   END.
   ELSE DO:
      FIND FIRST tt-trans NO-ERROR.
      /* temp-table que contÇm os seriais j† coletados */
      IF ttWork.num-serial = 777777 THEN DO:
         CREATE tt-devolve-picking-bkp.
         ASSIGN tt-devolve-picking-bkp.id-docto         = ttWork.id-docto
                tt-devolve-picking-bkp.num-seq-item     = ttWork.num-seq-item
                tt-devolve-picking-bkp.num-seq-item-ped = ttWork.num-seq-item-ped
                tt-devolve-picking-bkp.num-serial       = ttWork.num-serial
                tt-devolve-picking-bkp.cod-item         = ttWork.cod-item
                tt-devolve-picking-bkp.cod-refer        = ttWork.cod-refer
                tt-devolve-picking-bkp.cod-lote         = ttWork.cod-lote
                tt-devolve-picking-bkp.qtd-item         = ttWork.qtd-item
                tt-devolve-picking-bkp.nr-trans         = tt-trans.nr-trans.
      END.
      ELSE DO:
         FOR EACH b-tt-etiq
             WHERE b-tt-etiq.cdd-embarq  = tt-etiq.cdd-embarq
               AND b-tt-etiq.nr-resumo   = tt-etiq.nr-resumo:

             DELETE b-tt-etiq.
         END.
      END.
      {bcp/bc9105.i "902" "Documento Devolvido (DC)"}
   END.

   IF vLogErro = YES THEN 
      RETURN ERROR.
   ELSE 
      IF ttWork.num-serial = 777777 THEN 
         RUN GravaCamposFrame03.
      ELSE 
         RETURN "OK":U.
END PROCEDURE.

PROCEDURE pi-cria-documento-wms:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   EMPTY TEMP-TABLE RowErrors.

   ASSIGN ttWm-docto.cod-estabel         = ttWork.cod-estabel 
          ttWm-docto.cod-local           = ttWork.cod-local
          ttWm-docto.num-docto           = ttWork.num-documento
          ttWm-docto.serie               = '' 
          ttWm-docto.id-docto            = 0
          ttWm-docto.ind-tipo-trans      = 1
          ttWm-docto.num-docto-origem    = TRIM(STRING(ttWork.cdd-embarq))
          ttWm-docto.cdd-embarq          = ttWork.cdd-embarq
          ttWM-docto.nr-resumo           = i-nr-resumo
          ttWm-docto.ind-origem-docto    = 9 /* devoluá∆o */
          ttWm-docto.id-carga            = ttWm-docto.id-carga
          ttWm-docto.alteracao           = NO
          ttWm-docto.cod-depos           = vcod-deposito
          ttWm-docto.nr-pedcli           = c-nr-pedcli
          ttWm-docto.nome-abrev          = c-nome-abrev.

   IF ttWork.num-serial = 777777 THEN DO:
      FIND FIRST tt-dev-picking
           WHERE tt-dev-picking.cod-estabel   = ttWork.cod-estabel
             AND tt-dev-picking.cod-local     = ttWork.cod-local  
             AND tt-dev-picking.nr-pedcli     = ttWork.nr-pedcli  
             AND tt-dev-picking.num-seq-item  = ttWork.num-seq-item-ped 
             AND tt-dev-picking.cod-item      = ttWork.cod-item      
             AND tt-dev-picking.cod-refer     = ttWork.cod-refer     
             AND tt-dev-picking.cod-lote      = ttWork.cod-lote      
             AND tt-dev-picking.cdd-embarq    = ttWork.cdd-embarq NO-LOCK NO-ERROR.

      CREATE ttwm-docto-itens.      
      ASSIGN ttwm-docto-itens.cod-estabel       = ttWork.cod-estabel
             ttwm-docto-itens.cod-local         = ttWork.cod-local
             ttwm-docto-itens.num-docto         = ttWork.num-documento
             ttwm-docto-itens.id-docto          = 0
             ttWm-docto-itens.cod-item          = ttWork.cod-item
             ttWm-docto-itens.cod-refer         = ttWork.cod-refer
             ttWm-docto-itens.cod-lote          = ttWork.cod-lote
             ttWm-docto-itens.qtd-item          = ttWork.qtd-item
             ttWm-docto-itens.num-seq-item-ped  = ttWork.num-seq-item-ped
             ttWm-docto-itens.dt-atualizacao    = TODAY 
             ttWm-docto-itens.gera-sugestao     = YES
             ttWm-docto-itens.alteracao         = IF AVAIL tt-dev-picking THEN YES ELSE NO
             ttWm-docto-itens.num-seq-orig      = IF AVAIL tt-dev-picking THEN tt-dev-picking.nr-entrega ELSE 0
             ttWm-docto-itens.num-seq-item      = 0
             ttWm-docto-itens.nr-pedcli         = ttWork.nr-pedcli
             ttWm-docto-itens.nome-abrev        = ttWork.nome-abrev
             ttWm-docto-itens.cdd-embarq        = ttWork.cdd-embarq
             ttWm-docto-itens.nr-resumo         = ttWork.nr-resumo
             ttWm-docto-itens.nr-pedcli-devol   = ttWork.nr-pedcli 
             ttwm-docto-itens.nome-abrev-devol  = ttWork.nome-abrev
             ttWm-docto-itens.cdd-embarq-devol  = ttWork.cdd-embarq
             ttWm-docto-itens.nr-resumo-devol   = ttWork.nr-resumo.

   END.
   ELSE DO:  /* atualiza as etiquetas que ser∆o devolvidas para geraá∆o do documento */
      FOR EACH b-tt-etiq
         WHERE b-tt-etiq.cdd-embarq    = tt-etiq.cdd-embarq
           AND b-tt-etiq.nr-resumo     = tt-etiq.nr-resumo,
         FIRST wm-etiqueta
         WHERE wm-etiqueta.id-etiqueta       = b-tt-etiq.id-etiqueta
           AND wm-etiqueta.ind-sit-agrupador <> 2 
         BREAK BY b-tt-etiq.nr-pedcli:
         
         ASSIGN de-qtd-etiqueta-devol = b-tt-etiq.qtd-item.
         FIND FIRST wm-docto-itens-ped-etiqueta
              WHERE wm-docto-itens-ped-etiqueta.nr-embarque    = 0                 
                AND wm-docto-itens-ped-etiqueta.cdd-embarq   = ttWork.cdd-embarq
                AND wm-docto-itens-ped-etiqueta.id-etiqueta  = b-tt-etiq.id-etiqueta  
                AND wm-docto-itens-ped-etiqueta.cod-estabel  = ttWork.cod-estabel 
                AND wm-docto-itens-ped-etiqueta.cod-local    = ttWork.cod-local
                AND wm-docto-itens-ped-etiqueta.num-seq-item = b-tt-etiq.num-seq-item NO-LOCK NO-ERROR.
         IF AVAIL wm-docto-itens-ped-etiqueta THEN
            ASSIGN de-qtd-etiqueta-devol = wm-docto-itens-ped-etiqueta.qtd-item - wm-docto-itens-ped-etiqueta.qtd-prev-devol.

         CREATE ttwm-etiqueta.
         ASSIGN ttwm-etiqueta.id-etiqueta = b-tt-etiq.id-etiqueta
                ttwm-etiqueta.qtd-item    = de-qtd-etiqueta-devol
                ttwm-etiqueta.hr-geracao  = b-tt-etiq.num-seq-item. 

         FIND FIRST ttwm-docto NO-LOCK NO-ERROR.
         FIND CURRENT ttwm-docto EXCLUSIVE-LOCK NO-ERROR.
   
         FIND FIRST wm-docto
              WHERE wm-docto.cod-estabel      = ttWork.cod-estabel
                AND wm-docto.cod-local        = ttWork.cod-local  
                AND wm-docto.nr-embarque      = 0
                AND wm-docto.cdd-embarq       = ttWork.cdd-embarq
                AND wm-docto.nr-pedcli        = b-tt-etiq.nr-pedcli 
                AND wm-docto.nr-resumo        = b-tt-etiq.nr-resumo
                AND Wm-docto.nome-abrev       = b-tt-etiq.nome-abrev
                AND Wm-docto.ind-origem-docto = 9
                AND wm-docto.ind-sit-docto    = 1 NO-LOCK NO-ERROR.
         IF AVAIL wm-docto THEN DO: 
            EMPTY TEMP-TABLE ttwm-docto.
                
            CREATE ttwm-docto.
            ASSIGN ttwm-docto.cod-estabel      = wm-docto.cod-estabel
                   ttwm-docto.cod-local        = wm-docto.cod-local
                   ttwm-docto.cod-local        = wm-docto.cod-local
                   ttwm-docto.num-docto        = wm-docto.num-docto
                   ttwm-docto.serie            = wm-docto.serie
                   ttwm-docto.id-docto         = wm-docto.id-docto
                   ttwm-docto.num-docto-origem = wm-docto.num-docto-origem
                   ttwm-docto.ind-tipo-trans   = wm-docto.ind-tipo-trans
                   ttwm-docto.ind-origem-docto = wm-docto.ind-origem-docto
                   ttwm-docto.id-carga         = wm-docto.id-carga
                   ttwm-docto.alteracao        = YES
                   ttwm-docto.cod-depos        = ''
                   ttwm-docto.cdd-embarq       = wm-docto.cdd-embarq
                   ttwm-docto.nr-resumo        = wm-docto.nr-resumo
                   ttwm-docto.nr-pedcli        = wm-docto.nr-pedcli
                   ttwm-docto.nome-abrev       = wm-docto.nome-abrev
                   ttwm-docto.dt-implan-docto  = wm-docto.dt-implan-docto
                   ttwm-docto.ind-sit-docto    = wm-docto.ind-sit-docto.
         END.
         ELSE DO:
            ASSIGN ttWM-docto.nr-resumo     = b-tt-etiq.nr-resumo  
                   ttWm-docto.nr-pedcli     = b-tt-etiq.nr-pedcli  
                   ttWm-docto.nome-abrev    = b-tt-etiq.nome-abrev
                   ttwm-docto.alteracao     = NO.
         END.
      END.
   END.
   RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttwm-docto,
                     INPUT-OUTPUT TABLE ttWm-docto-itens,
                     INPUT-OUTPUT TABLE ttwm-etiqueta,
                     OUTPUT TABLE RowErrors).
   
   EMPTY TEMP-TABLE ttwm-etiqueta.
   
   IF CAN-FIND(FIRST RowErrors
               WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
      RETURN "NOK":U.                           
   
END PROCEDURE.

PROCEDURE pi-altera-documento-wms:
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   EMPTY TEMP-TABLE RowErrors.

   BUFFER-COPY wm-docto TO ttWm-docto.
   ASSIGN ttWm-docto.alteracao = YES
          ttWm-docto.cod-depos = vcod-deposito.

   /* Devoluá∆o sem etiqueta */
   IF ttWork.num-serial = 777777 THEN DO:
       CREATE ttwm-docto-itens.      
       ASSIGN ttwm-docto-itens.cod-estabel       = ttWm-docto.cod-estabel
              ttwm-docto-itens.cod-local         = ttWm-docto.cod-local
              ttwm-docto-itens.num-docto         = ttWm-docto.num-docto
              ttwm-docto-itens.id-docto          = ttwm-docto.id-docto
              ttWm-docto-itens.cod-item          = ttWork.cod-item
              ttWm-docto-itens.cod-refer         = ttWork.cod-refer
              ttWm-docto-itens.cod-lote          = ttWork.cod-lote
              ttWm-docto-itens.qtd-item          = ttWork.qtd-item
              ttWm-docto-itens.num-seq-item-ped  = ttWork.num-seq-item-ped
              ttWm-docto-itens.dt-atualizacao    = TODAY 
              ttWm-docto-itens.gera-sugestao     = YES
              ttWm-docto-itens.num-seq-orig      = p-num-seq-item 
              ttWm-docto-itens.num-seq-item      = 0
              ttWm-docto-itens.nr-pedcli         = ttWork.nr-pedcli
              ttWm-docto-itens.nome-abrev        = ttWork.nome-abrev
              ttWm-docto-itens.cdd-embarq        = ttWork.cdd-embarq
              ttWm-docto-itens.nr-resumo         = ttWork.nr-resumo
              ttWm-docto-itens.nr-pedcli-devol   = ttWork.nr-pedcli 
              ttwm-docto-itens.nome-abrev-devol  = ttWork.nome-abrev
              ttWm-docto-itens.cdd-embarq-devol  = ttWork.cdd-embarq
              ttWm-docto-itens.nr-resumo-devol   = ttWork.nr-resumo. 

      RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttwm-docto,
                        INPUT-OUTPUT TABLE ttWm-docto-itens,
                        INPUT-OUTPUT TABLE ttwm-etiqueta,
                        OUTPUT TABLE RowErrors).
      IF CAN-FIND(FIRST RowErrors
                  WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
         RETURN "NOK":U.
   END.
   ELSE DO:
      /* atualiza as etiquetas que ser∆o devolvidas para geraá∆o do documento */
      FOR EACH b-tt-etiq
         WHERE b-tt-etiq.cdd-embarq    = tt-etiq.cdd-embarq
           AND b-tt-etiq.nr-resumo     = tt-etiq.nr-resumo,
         FIRST wm-etiqueta
         WHERE wm-etiqueta.id-etiqueta       = b-tt-etiq.id-etiqueta
           AND wm-etiqueta.ind-sit-agrupador <> 2
         BREAK BY b-tt-etiq.nr-pedcli:

         ASSIGN de-qtd-etiqueta-devol = b-tt-etiq.qtd-item.
         FIND FIRST wm-docto-itens-ped-etiqueta
              WHERE wm-docto-itens-ped-etiqueta.nr-embarque    = 0                 
                AND wm-docto-itens-ped-etiqueta.cdd-embarq   = ttWork.cdd-embarq
                AND wm-docto-itens-ped-etiqueta.id-etiqueta  = b-tt-etiq.id-etiqueta  
                AND wm-docto-itens-ped-etiqueta.cod-estabel  = ttWork.cod-estabel 
                AND wm-docto-itens-ped-etiqueta.cod-local    = ttWork.cod-local
                AND wm-docto-itens-ped-etiqueta.num-seq-item = b-tt-etiq.num-seq-item NO-LOCK NO-ERROR.
         IF AVAIL wm-docto-itens-ped-etiqueta THEN
            ASSIGN de-qtd-etiqueta-devol = wm-docto-itens-ped-etiqueta.qtd-item - wm-docto-itens-ped-etiqueta.qtd-prev-devol.

         CREATE ttwm-etiqueta.
         ASSIGN ttwm-etiqueta.id-etiqueta = b-tt-etiq.id-etiqueta
                ttwm-etiqueta.qtd-item    = de-qtd-etiqueta-devol
                ttwm-etiqueta.hr-geracao  = b-tt-etiq.num-seq-item.
      END.  

      FIND FIRST ttwm-docto NO-LOCK NO-ERROR.
      FIND CURRENT ttwm-docto EXCLUSIVE-LOCK NO-ERROR.

      FIND FIRST wm-docto
           WHERE wm-docto.cod-estabel      = ttWork.cod-estabel
             AND wm-docto.cod-local        = ttWork.cod-local  
             AND wm-docto.nr-embarque      = 0
             AND wm-docto.cdd-embarq       = ttWork.cdd-embarq
             AND wm-docto.nr-pedcli        = b-tt-etiq.nr-pedcli 
             AND wm-docto.nr-resumo        = b-tt-etiq.nr-resumo
             AND wm-docto.nome-abrev       = b-tt-etiq.nome-abrev
             AND wm-docto.ind-origem-docto = 9
             AND wm-docto.ind-sit-docto    = 1 NO-LOCK NO-ERROR.
      IF NOT AVAIL wm-docto THEN DO:
         ASSIGN ttwm-docto.nr-resumo     = b-tt-etiq.nr-resumo  
                ttwm-docto.nr-pedcli     = b-tt-etiq.nr-pedcli  
                ttwm-docto.nome-abrev    = b-tt-etiq.nome-abrev
                ttwm-docto.alteracao     = NO.
      END.
      RUN wmp/wm9000.p (INPUT-OUTPUT TABLE ttwm-docto,
                        INPUT-OUTPUT TABLE ttWm-docto-itens,
                        INPUT-OUTPUT TABLE ttwm-etiqueta,
                        OUTPUT TABLE RowErrors). 
      EMPTY TEMP-TABLE ttwm-etiqueta.
      IF CAN-FIND(FIRST RowErrors
                  WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
         RETURN "NOK":U.                           
   END.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
