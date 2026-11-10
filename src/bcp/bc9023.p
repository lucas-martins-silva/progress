/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9023 2.00.00.019 } /*** "010019" 19/03/2024 10:34:37  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9023 MBC}
&ENDIF

{include/i_dbinst.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9023.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Endere‡o WMS         **
**                                                                                         **
********************************************************************************************/
DEFINE NEW GLOBAL SHARED VAR lMenu          AS LOGICAL                               NO-UNDO.
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
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9023
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */
{bcp/bc9023.i}
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

&global-define TempTable tt-consulta

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.
DEFINE VARIABLE wgbcapiwms    AS HANDLE              NO-UNDO.  

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.

DEFINE TEMP-TABLE RowErrors NO-UNDO 
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Consult Endere‡o WMS'                            At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label
&global-define Frame01Repeat No


/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Consult Endere‡o WMS'                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Serial  :           '                             At Row 03 Col 01          ~
                             'End:'                                             At Row 05 Col 01          ~
                             'Saldo:'                                           At Row 06 Col 01          ~
                             ttWork.num-serial                                  At Row 04 Col 01 No-label ~
                             ttWork.des-endereco                                At Row 05 Col 05 NO-LABEL ~
                             ttWork.dec-livre-1                                 At Row 06 Col 07 NO-LABEL ~
                             '777777-Lista Docto  '                             AT ROW 07 COL 01          ~
                             ttWork.num-livre-2                                 At Row 08 Col 01 NO-LABEL 
&global-define Frame02Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = ''  ~
                              vcod-senha WHEN ttWork.cod-usuario = ''          ~
                              ttWork.cod-coletor ttWork.cod-equipamento        ~

&global-define Update02Fields ttWork.num-serial

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. IF vLogErro = YES THEN do: LEAVE _frame02. END.     
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON ENTRY OF ttWork.cod-coletor IN FRAME {&Frame01Name} ~
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
                            ON 'ESC':U OF Frame Frame01    ~
                            DO:                            ~
                                ASSIGN  vlogerro = YES     ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES. ~
                                       vLogCancela = YES.  ~
                                Return 'ESC':U.            ~
                            END. ~


/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC092
&global-define ActiveObject2 wgBOSC079
&global-define ActiveObject3 wgBOSC074
&global-define ActiveObject4 wgbcapiwms

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
RUN scbo/bosc092.p PERSISTENT SET wgbosc092.
RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

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
   IF RETURN-VALUE = 'ESC':U THEN DO:
      ASSIGN vlogerro     = YES     
             vLogSai      = YES      
             vLogFinaliza = YES
             vLogCancela  = YES. 
      HIDE ALL NO-PAUSE.
      RETURN  ERROR.
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
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   ASSIGN ttWork.des-endereco = ''.
   DISP ttWork.des-endereco
        ttWork.dec-livre-1
     WITH FRAME Frame02.
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
   
   /* Valida€ usuµrio */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido (DC)"}
   END. 
   IF v2_cod_usuar_corren = ''  THEN DO:
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
      IF CAN-FIND(FIRST tt-erros
                  WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND(FIRST tt-erros
                     WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      RUN piValidaUsuario IN wgbcapiwms (INPUT FRAME frame01 ttWork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
   
      ASSIGN vLogControlaLogin = YES.
   END.
   
   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      
      RUN getrowErrors IN wgbosc079 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.                                           
   END.
   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF ttWork.cod-coletor = ''  THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (DC)"}
   END.
   
   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (DC)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   /* valida se equipamento ‚ do tipo coletor */
   RUN validaEquipColetor IN wgbosc092 (INPUT ttWork.cod-coletor,
                                        OUTPUT vCodTipoEquip,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
      RETURN ERROR.
   END.
   
   /* valida se existe equipamento e se est  ativo */
   RUN validaEquipTransportador IN wgbosc092  (INPUT ttWork.cod-equipamento,
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
Procedure GravaCamposFrame02:
   DEFINE VARIABLE vlogcontrol   AS LOGICAL                   NO-UNDO.
   DEFINE VARIABLE vMsg          AS CHARACTER FORMAT "X(35)"  NO-UNDO.
   DEFINE VARIABLE de-saldo-etiq LIKE wm-etiqueta.qtd-item    NO-UNDO.
   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   IF ttWork.num-serial = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Serial Inv lido (DC)"}
      RETURN ERROR.
   END.
   
   FIND FIRST wm-etiqueta
       WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
   IF NOT AVAIL wm-etiqueta THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "202" "Etiqueta inexistente"}
      RETURN ERROR.
   END.
   
   RUN emptyRowErrors IN wgbosc074.
   RUN getSerialAdrress IN wgbosc074 (INPUT ttWork.num-serial,
                                      OUTPUT vNumBox,
                                      OUTPUT vCodBloco,
                                      OUTPUT vCodRua,
                                      OUTPUT vCodNivel,
                                      OUTPUT vCodcoluna).
   
   IF RETURN-VALUE = 'NOK':U THEN DO:
      RUN getRowErrors IN wgbosc074 (OUTPUT TABLE RowErrors) NO-ERROR.    
      FOR EACH RowErrors:
         ASSIGN vLogErro     = YES.
         HIDE ALL NO-PAUSE.
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
         HIDE ALL NO-PAUSE.
      END.     
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.
   
   IF vNumBox <> 0  AND STRING(vCodBloco) <> "" AND STRING(vCodRua) <> "" AND STRING(vCodNivel) <> "" AND STRING(vCodcoluna) <> "" THEN DO:
      FOR FIRST wm-etiqueta
          WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK:
          ASSIGN ttWork.dec-livre-1 = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado.
      END.
      
      ASSIGN ttWork.des-endereco = vcodbloco + '/':U + vcodrua + '/':U + vcodnivel + '/':U + vcodcoluna.
      
      DISPLAY ttWork.des-endereco 
              ttWork.dec-livre-1
         WITH FRAME {&Frame02Name}.
      
      ASSIGN {&TempTable}.num-serial    = ttWork.num-serial
             {&TempTable}.des-endereco  = ttWork.des-endereco
             {&TempTable}.dat-transacao = TODAY.
      
      ASSIGN ttWork.des-endereco:READ-ONLY IN FRAME frame02 = YES.   
      
      ASSIGN vLogFinaliza = NO
             vLogSai      = YES
             vLogErro     = NO.
      
      UPDATE ttWork.num-livre-2 WITH FRAME frame02.
      IF ttWork.num-livre-2 = 777777 THEN DO:
         RUN bcp/bc9023a.p (INPUT ttWork.num-serial).
      END.
   END.
   ELSE DO:
      FIND FIRST wm-movto-etiqueta
           WHERE wm-movto-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
      IF AVAIL wm-movto-etiqueta THEN DO:      
         FIND FIRST wm-box-movto
              WHERE wm-box-movto.cod-estabel  = wm-movto-etiqueta.cod-estabel 
                AND wm-box-movto.cod-local    = wm-movto-etiqueta.cod-local   
                AND wm-box-movto.id-movto     = wm-movto-etiqueta.id-movto NO-LOCK NO-ERROR.
         
         FIND FIRST wm-box
              WHERE wm-box.cod-estabel = wm-box-movto.cod-estabel
                AND wm-box.cod-local   = wm-box-movto.cod-local  
                AND wm-box.id-box      = wm-box-movto.id-box NO-LOCK NO-ERROR.
                  
         FOR FIRST wm-etiqueta FIELDS(qtd-item qtd-item-retirado)
             WHERE wm-etiqueta.id-etiqueta = ttWork.num-serial NO-LOCK:
           ASSIGN de-saldo-etiq = wm-etiqueta.qtd-item - wm-etiqueta.qtd-item-retirado.
         END.
         
         IF de-saldo-etiq = 0 THEN
           ASSIGN vMsg = "Etiqueta sem Saldo".
         ELSE
            ASSIGN vMsg = "Etiqueta sugerida para endereco:" + CHR(10) + STRING(wm-box.cod-bloco) + '/' +
                                                                         STRING(wm-box.cod-rua)   + '/' +
                                                                         STRING(wm-box.cod-nivel) + '/' +
                                                                         STRING(wm-box.cod-coluna).
                     
         {bcp/bc9015.i2 STRING(203) vMsg}
      END.
      ELSE DO:
         FIND FIRST wms-docto-item-etiq
              WHERE wms-docto-item-etiq.id-etiqueta = ttWork.num-serial NO-LOCK NO-ERROR.
         IF NOT AVAIL wms-docto-item-etiq THEN DO:
           {bcp/bc9105.i "204" "Falta sugestÆo de armazenamento para a Etiqueta"}
         END.
         ELSE DO:
            UPDATE ttWork.num-livre-2 WITH FRAME frame02.
            IF ttWork.num-livre-2 = 777777 THEN DO:
               RUN bcp/bc9023a.p (INPUT ttWork.num-serial).
            END.
         END.
      END.
   END.
   
   ASSIGN vNumBox             = 0
          vCodBloco           = ""
          vCodRua             = ""
          vCodNivel           = ""
          vCodcoluna          = ""
          ttWork.des-endereco = ""
          ttWork.dec-livre-1  = 0
          ttWork.num-livre-2  = 0.
   
   RETURN 'OK':U.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
