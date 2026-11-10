/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9042 2.00.00.007 } /*** "010007" 23/07/2024 13:43:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9042 MBC}
&ENDIF

{include/i_dbvers.i}  /* versao das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9042.p                                                                  **
**                                                                                         **
**   Versao....: 1.00.00.000 - Setembro 2009 - Lilian Souza - Criaá∆o do programa          **
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
**                        Ex: &global-define ActiveObject Hbosc074                               **
***************************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9042
&global-define TempTable tt-armazena-packing
{bcp/bc9042.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}                
{method/dbotterr.i}
{bcp/bc9015.i3}  /* def variaveis padroes */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD cod-usuario      AS CHARACTER FORMAT 'x(25)':U           LABEL 'Usuario'         
    FIELD cod-coletor      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Coletor'      INITIAL ""
    FIELD cod-equipamento  AS CHARACTER FORMAT 'x(14)':U           LABEL 'Equipamento'  INITIAL ""
    FIELD tpArmaz          AS INTEGER   FORMAT '9':U               LABEL 'TpMovto'
    FIELD num-serial       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>':U LABEL 'Serial Lido'
    FIELD num-box          AS DECIMAL   FORMAT '>>>>>>>>>9':U      LABEL 'Box Armazenamento'
    FIELD cod-estabel      AS CHARACTER FORMAT 'x(3)':U            LABEL 'Estabelecimento'
    FIELD cod-local        AS CHARACTER FORMAT 'x(3)':U            LABEL 'Local'
    FIELD val-etiq-packing LIKE wms-box-packing.val-etiq-packing   LABEL 'Etiqueta'
    FIELD dat-atualizacao  AS DATE
    FIELD dat-transacao    AS DATE.       
CREATE ttWork.

/* ************************** Definitions ******************************** */
DEFINE VARIABLE vLogOk             AS LOGICAL   INIT NO           NO-UNDO.
DEFINE VARIABLE vcod-senha         AS CHARACTER FORMAT 'x(18)':U  NO-UNDO.
DEFINE VARIABLE vCodSenha          AS CHARACTER FORMAT 'x(12)':U  NO-UNDO.
DEFINE VARIABLE vNomeUsuario       AS CHARACTER                   NO-UNDO.
DEFINE VARIABLE vLogControlaLogin  AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura   AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE iCodTipoEquip      AS INTEGER                     NO-UNDO.
DEFINE VARIABLE iCodTipoColetor    AS INTEGER                     NO-UNDO.
DEFINE VARIABLE vLogProcesso       AS LOGICAL  INITIAL NO         NO-UNDO.
DEFINE VARIABLE vLogAtivo          AS LOGICAL  INITIAL NO         NO-UNDO.

DEFINE VARIABLE wgbosc079          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc092          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbosc135          AS HANDLE                       NO-UNDO.
DEFINE VARIABLE wgbcapiwms         AS HANDLE                       NO-UNDO. 

&GLOBAL-DEFINE ActiveObject1 wgbosc079
&GLOBAL-DEFINE ActiveObject2 wgbosc092
&GLOBAL-DEFINE ActiveObject3 wgbosc135
&GLOBAL-DEFINE ActiveObject4 wgbcapiwms

&GLOBAL-DEFINE ErrorDisplaySeconds 3
&GLOBAL-DEFINE FrameSize    20 By 8 

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&GLOBAL-DEFINE Frame01Name   Frame01
&GLOBAL-DEFINE Frame01Defs   'Armazenagem Packing '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                              ttWork.cod-usuario                                At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vCodSenha                                          AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                              ttWork.cod-coletor                                At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                              ttWork.cod-equipamento                            At Row 06 Col 05 NO-LABEL
&GLOBAL-DEFINE Frame01Repeat NO

/* Definicao da Frame02 ---                             */
&GLOBAL-DEFINE Frame02Name   Frame02
&GLOBAL-DEFINE Frame02Defs   'Tipo Armazenamento  '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Por Volume'                                   AT ROW 03 COL 01          ~
                             '2 - Agrupado'                                     AT ROW 04 COL 01          ~
                             'Opá∆o:'                                           At Row 08 Col 01          ~
                              ttWork.tpArmaz                                    At Row 08 Col 07 NO-LABEL
&GLOBAL-DEFINE Frame02Repeat NO

/* Definicao dos campos a serem recebidos ---               */
&GLOBAL-DEFINE Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vCodSenha          WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento
&GLOBAL-DEFINE Update02Fields ttWork.tpArmaz

/* Definicao das trigger de interacao com a tela ---        */ 
&GLOBAL-DEFINE TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogSai = YES THEN DO: LEAVE _frame01. END. 
&GLOBAL-DEFINE TriggerBeforeFrame02 Run InicializaCamposFrame02. 

&GLOBAL-DEFINE TriggerAfterFrame01  Run GravaCamposFrame01.      
&GLOBAL-DEFINE TriggerAfterFrame02  Run GravaCamposFrame02. 

/* Definicao das trigger de usuario ---                     */ 
&GLOBAL-DEFINE UserTriggers ~
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
                            ON 'enter':U OF ttWork.cod-coletor IN Frame Frame01             ~
                            DO:                                                             ~
                                APPLY 'entry':U TO ttWork.cod-equipamento IN FRAME Frame01. ~
                                RETURN NO-APPLY.                                            ~
                            END.                                                            ~

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
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod_usuar_corren
             ttWork.cod-usuario                                      = v_cod_usuar_corren
             vCodSenha                                               = '****************':U 
             vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = '****************':U. 
      IF v_cod-coletor_corren     <> '' AND v_cod-equipamento_corren <> '' THEN DO:
         ASSIGN ttWork.cod-coletor:SCREEN-VALUE IN FRAME {&Frame01Name}     = v_cod-coletor_corren
                ttWork.cod-coletor     = v_cod-coletor_corren
                ttWork.cod-equipamento:SCREEN-VALUE IN FRAME {&Frame01Name} = v_cod-equipamento_corren
                ttWork.cod-equipamento = v_cod-equipamento_corren.
      END.
   END.
   ELSE DO:
      ASSIGN vCodSenha:BLANK IN FRAME {&Frame01Name}                 = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name} = '' 
             ttWork.cod-usuario                                      = '' 
             vCodSenha                                               = ''  
             vCodSenha:SCREEN-VALUE IN FRAME {&Frame01Name}          = ''.
   END.
END PROCEDURE.

PROCEDURE GravaCamposFrame01:

   ASSIGN vLogErro          = NO
          vLogControlaLogin = NO.

   IF v_cod_usuar_corren <> "" THEN
      ASSIGN ttWork.cod-usuario = v_cod_usuar_corren.
   ELSE
      ASSIGN INPUT FRAME {&Frame01Name} ttWork.cod-usuario.

   IF v2_cod_usuar_corren = '' THEN DO:
      
      EMPTY TEMP-TABLE tt-erros.

      login:
      DO ON ERROR  UNDO login, LEAVE login
      ON QUIT      UNDO login, LEAVE login
      ON STOP      UNDO login, LEAVE login
      ON ENDKEY    UNDO login, LEAVE login:
         RUN btb/btapi910za.p (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}, 
                               INPUT  vCodSenha,
                               OUTPUT TABLE tt-erros) NO-ERROR. 
      END. 
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu†rio n∆o encontrado. (DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO: 
            {bcp/bc9105.i "4758" "Senha para o usu†rio n∆o est† correta. (DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
         ELSE DO:
            IF CAN-FIND (FIRST tt-erros) THEN DO:
               {bcp/bc9105.i "202" "Problemas na autenticaá∆o do usu†rio. (DC)"} 
               ASSIGN vLogErro           = YES
                      v_cod_usuar_corren = ''.
               RETURN ERROR.
            END.
         END.
      END.
      
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.

      RUN piValidaUsuario IN wgbcapiwms (INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name},
                                         OUTPUT ttWork.cod-usuario).
                                          
      IF VALID-HANDLE(wgbcapiwms) THEN
         DELETE PROCEDURE wgbcapiwms NO-ERROR. 
                                           
      ASSIGN vLogControlaLogin = YES.
   END.

   {bcp/bc9017.i1 ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name}}

   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135 NO-ERROR.
   END.
    
   IF vLogOk = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.

      {bcp/bc9105.i "101" "Usu†rio Inv†lido. (DC)"}
      RETURN ERROR.
   END.

   /* Valida existencia do usuario no WMS e retorna se ele tem ou nao permissao para utilizar coletor */
   RUN validaUsuario IN wgbosc079 (INPUT  ttWork.cod-usuario:SCREEN-VALUE IN FRAME {&Frame01Name},
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu†rio Inv†lido. (WMS)"}
      RETURN ERROR.
   END.

   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "102" "Usu†rio sem permiss∆o para utilizar Coletor. (WMS)"}
      RETURN ERROR.
   END.

   /*valida tarefa usuario*/
   RUN  validaUsuarioTarefa IN wgbosc135 (INPUT ttWork.cod-usuario,
                                          INPUT 18). /*Tarefa Armazenamento Packing*/
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors IN wgbosc135 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.
      RETURN ERROR.
   END.

   /* valida se existe equipamento, se e do tipo coletor e se esta ativo */
   RUN validaEquipColetor IN wgbosc092 (INPUT  ttWork.cod-coletor,
                                        OUTPUT iCodTipoColetor,
                                        OUTPUT vLogAtivo,
                                        OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inv†lido. (WMS)"}
      RETURN ERROR.
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Coletor Inativo. (WMS)"}
      RETURN ERROR.
   END.

   /* valida se existe equipamento, se e do tipo transportador e se esta ativo */
   RUN validaEquipTransportador In wgbosc092 (INPUT  ttWork.cod-equipamento,
                                              OUTPUT iCodTipoEquip,
                                              OUTPUT vLogAtivo,
                                              OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipto Inv†lido. (WMS)"}
      RETURN ERROR.
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "106" "Equipto Inativo. (WMS)"}
      RETURN ERROR.
   END.

   /* Validacoes Frame 01 Fim    --- */
   ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario 
          {&TempTable}.cod-coletor     = ttWork.cod-coletor
          {&TempTable}.cod-equipamento = ttWork.cod-equipamento.

   IF VALID-HANDLE(wgbosc092) THEN
      DELETE PROCEDURE wgbosc092.
      
   IF VALID-HANDLE(wgbosc079) THEN
      DELETE PROCEDURE wgbosc079.
      
   IF VALID-HANDLE(wgbosc135) THEN
      DELETE PROCEDURE wgbosc135.

END PROCEDURE.

PROCEDURE InicializaCamposFrame02:   
   ASSIGN vLogErro  = NO.
END PROCEDURE.

PROCEDURE GravaCamposFrame02:
   ASSIGN  vLogErro = NO
          INPUT FRAME  Frame01 ttWork.cod-coletor
          INPUT FRAME  Frame01 ttWork.cod-equipamento.

   IF ttWork.tpArmaz:SCREEN-VALUE IN FRAME {&Frame02Name} <> "1" AND 
      ttWork.tpArmaz:SCREEN-VALUE IN FRAME {&Frame02Name} <> "2" THEN DO:
      {bcp/bc9105.i "100" "Opá∆o Inv†lida (DC)"}
      HIDE ALL.
      RETURN ERROR.
   END.
                                       
   IF ttWork.tpArmaz = 1 THEN DO:
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9042a.p  (INPUT ttWork.cod-coletor,
                          INPUT ttWork.cod-equipamento,
                          INPUT ttWork.cod-usuario).
      HIDE ALL NO-PAUSE.
      RETURN RETURN-VALUE.
   END.
   ELSE DO:
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9042b.p (INPUT ttWork.cod-coletor,
                         INPUT ttWork.cod-equipamento,
                         INPUT ttWork.cod-usuario).
      HIDE ALL NO-PAUSE.
      RETURN RETURN-VALUE.
   END.                                    
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
