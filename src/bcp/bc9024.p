/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024 2.00.00.043 } /*** "010043" 10/11/2023 15:29:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9024 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9024.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Invent rio WMS                   **
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
&global-define ProgramName BC9024
&global-define MessageBell YES
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i}

DEFINE VARIABLE id-box-contar LIKE wm-box.id-box   NO-UNDO.
DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

CREATE ttWork.

DEFINE TEMP-TABLE ttInventario NO-UNDO LIKE wm-inventario.

DEFINE TEMP-TABLE ttContagem NO-UNDO
            FIELDS vNrContagem AS INTEGER.

DEFINE QUERY qryInventario FOR ttInventario.       

DEFINE QUERY qryContagem FOR ttContagem.

DEF VAR hDBOsc047       AS HANDLE                     NO-UNDO.
DEF VAR c-cod-depos     AS CHARACTER  FORMAT 'x(3)':U NO-UNDO.

DEFINE BROWSE brwInventario
         QUERY qryInventario NO-LOCK
         DISPLAY ttInventario.char-1         FORMAT "x(3)":U
                 ttInventario.num-seq-invent FORMAT ">>9":U
                 '-':U
                 ttInventario.dt-inventario
            WITH NO-BOX NO-LABELS SIZE 20 BY 4 NO-SCROLLBAR-VERTICAL.

DEFINE BROWSE brwContagem
         QUERY qryContagem NO-LOCK
         DISPLAY ttContagem.vNrContagem
            WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

DEFINE VARIABLE i-num-box-aux LIKE ttWork.num-box   NO-UNDO.
DEFINE VARIABLE vpause AS CHARACTER FORMAT 'x(15)'  NO-UNDO. 
DEFINE VARIABLE intvLado AS INTEGER                 NO-UNDO. 
DEFINE VARIABLE wgbosc038          AS HANDLE        NO-UNDO.
DEFINE VARIABLE wgbcapiwms         AS HANDLE        NO-UNDO.    
DEFINE VARIABLE vleitura AS CHARACTER FORMAT 'x(2)' NO-UNDO. 
/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Invent rio WMS'                                   At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Legenda Serial:   '                               AT ROW 05 COL 01          ~
                             '555555 -End. Vazio'                               AT ROW 06 COL 01          ~
                             vpause                                             AT ROW 07 COL 01 NO-LABEL ~
&global-define Frame01Repeat NO 

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Invent rio WMS:'                                  At Row 01 Col 01          ~
                             'Est:'                                             At Row 02 Col 01          ~
                             ttWork.cod-estabel                                 At Row 02 Col 05 NO-LABEL          ~
                             'Loc:'                                             At Row 03 Col 01          ~
                             ttWork.cod-local                                   At Row 03 Col 05 NO-LABEL          ~
                             'Invent rios Pend.:'                               At Row 04 Col 01          ~
                             brwInventario                                      At Row 05 Col 01
&global-define Frame02Repeat NO

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Invent rio WMS'                                   At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Contagens:'                                       At Row 03 Col 01          ~
                             brwContagem                                        At Row 04 Col 01          
&global-define Frame03Repeat NO

/* Definicao da Frame04 ---                               */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Invent rio WMS'                                  At Row 01 Col 01                         ~
                             '--------------------'                            At Row 02 Col 01                         ~
                             'Box:'                                            At Row 03 Col 01                         ~
                             ttWork.num-box                                    At Row 04 Col 01 No-label                ~
                             'Bloco:'                                          At Row 05 Col 01                         ~
                             vCodBloco                                         At Row 05 Col 08 No-label                ~
                             'Rua:'                                            At Row 06 Col 01                         ~
                             vCodRua                                           At Row 06 Col 08 No-label                ~
                             'N¡vel:'                                          At Row 07 Col 01                         ~
                             vCodNivel                                         At Row 07 Col 08 No-label                ~
                             'Coluna:'                                         At Row 08 Col 01                         ~
                             vCodColuna                                        At Row 08 Col 08 No-label                ~
                             'Lado:'                                           At Row 08 Col 12                         ~
                             vLado                                             At Row 08 Col 17 No-label                ~
&global-define Frame04Repeat Yes
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              vpause
&global-define Update02Fields ttWork.cod-estabel ttWork.cod-local brwInventario
&global-define Update03Fields brwContagem 
&global-define Update04Fields ttWork.num-box 
                                 
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      If vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. If  Return-value = 'OK':U Then Return Return-value.
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'ESC':U OF Frame Frame01    ~
                            DO:                            ~
                                ASSIGN vlogerro = YES      ~
                                       vLogSai  = YES      ~
                                       vLogFinaliza = YES  ~
                                       vLogCancela = YES.  ~
                                Return 'NOK':U.            ~
                            END. ~
                            ON 'enter':U OF ttWork.cod-estabel IN Frame {&Frame02Name}             ~
                            DO:                                                                    ~
                                RUN piValidateScreen (INPUT "Estab").                              ~
                                IF RETURN-VALUE = "NOK" THEN DO:                                   ~
                                    View Frame frame02.                                            ~
                                    RETURN NO-APPLY.                                               ~
                                END.                                                               ~
                                APPLY 'entry':U TO ttWork.cod-local IN FRAME {&Frame02Name}.       ~
                                RETURN NO-APPLY.                                                   ~
                            END.                                                                   ~
                            ON 'enter':U OF ttWork.cod-local IN Frame {&Frame02Name}               ~
                            DO:                                                                    ~
                                RUN piValidateScreen (INPUT "Local").                              ~
                                IF RETURN-VALUE = "NOK" THEN DO:                                   ~
                                    View Frame frame02.                                            ~
                                    RETURN NO-APPLY.                                               ~
                                END.                                                               ~
                                RUN piCarregaEnderecos.                                            ~
                                IF RETURN-VALUE = "NOK" THEN DO:                                   ~
                                    View Frame frame02.                                            ~
                                    RETURN NO-APPLY.                                               ~
                                END.                                                               ~
                                APPLY 'entry':U TO brwInventario IN FRAME {&Frame02Name}.          ~
                                RETURN NO-APPLY.                                                   ~
                            END.                                                                   ~
                            ON 'Return':U        OF brwInventario       In Frame {&Frame02Name}    ~
                            DO:                                                                    ~
                               Apply 'Go' To This-procedure.                                       ~
                            END.                                                                   ~
                            ON 'Return':U        OF brwContagem In Frame {&Frame03Name}            ~
                            DO:                                                                    ~
                               Apply 'Go' To This-procedure.                                       ~
                            END.              ~
                                
/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc079
&global-define ActiveObject2 wgbosc117
&global-define ActiveObject3 wgbosc118
&global-define ActiveObject4 wgbosc030
&global-define ActiveObject5 wgbosc038
&global-define ActiveObject6 wgbcapiwms

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

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

PROCEDURE InicializaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vpause = '999999 -Encerra'.
   ASSIGN vpause:READ-ONLY IN FRAME frame01 = YES.    
   IF RETURN-VALUE = 'NOK':U THEN DO:
      ASSIGN vlogerro = YES     
             vLogSai  = YES      
             vLogFinaliza = YES
             vLogCancela = YES. 
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
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''.
   END.
END PROCEDURE.

PROCEDURE InicializaCamposFrame02:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame021}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO. 
   
   EMPTY TEMP-TABLE ttInventario.
   OPEN QUERY qryInventario
     FOR EACH ttInventario
           BY ttInventario.dt-inventario 
           BY ttInventario.num-seq-invent.       

   IF NOT VALID-HANDLE(wgbosc038)  THEN DO:
      RUN scbo/bosc038.p PERSISTENT SET wgbosc038.
      RUN openQueryStatic IN wgbosc038 (INPUT "Main":U) NO-ERROR.
   END.
END PROCEDURE.

PROCEDURE InicializaCamposFrame03:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame03}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   EMPTY TEMP-TABLE ttContagem.
   IF NOT VALID-HANDLE(wgbosc118)  THEN DO:
      RUN scbo/bosc118.p PERSISTENT SET wgbosc118.
      RUN openQueryStatic IN wgbosc118 (INPUT "Main":U) NO-ERROR.
   END.
   
   RUN getNumeroContagem IN wgbosc118 (INPUT ttInventario.cod-estabel,
                                       INPUT ttInventario.cod-local,
                                       INPUT ttInventario.dt-inventario,
                                       INPUT ttInventario.num-seq-invent,
                                       OUTPUT TABLE ttContagem).
   
   OPEN QUERY qryContagem
     FOR EACH ttContagem.
END PROCEDURE.

PROCEDURE InicializaCamposFrame04:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO
          vCodBloco    = ""
          vCodRua      = ""
          vCodNivel    = ""
          vCodColuna   = "".
       
   /* Pegar Informacoes Box */
   IF ttWork.num-box <> 0 THEN
      ASSIGN i-num-box-aux = ttWork.num-box.
    
   ASSIGN ttWork.num-box = 0.
    
   FIND FIRST Wm-param NO-LOCK NO-ERROR.
   IF Wm-param.log-gera-rotei-invent = YES THEN DO:
      IF i-num-box-aux <> 0 AND NOT AVAIL RowErrors THEN DO:
         /* Sugere endere‡o para inventariar */
         IF NOT VALID-HANDLE(wgbosc118) THEN DO:
            RUN scbo/bosc118.p PERSISTENT SET wgbosc118.
            RUN openQueryStatic IN wgbosc118 (INPUT "Main":U) NO-ERROR.
         END.
           
         RUN emptyRowErrors IN wgbosc118.
         RUN retornaEndereco IN wgbosc118(INPUT ttWork.cod-estabel,
                                          INPUT ttWork.cod-local,     
                                          INPUT ttWork.dat-inventario, 
                                          INPUT ttWork.num-seq-invent,
                                          INPUT i-num-box-aux,  
                                          INPUT ttWork.num-contagem,      
                                          INPUT ttWork.cod-usuario,   
                                          OUTPUT id-box-contar,
                                          OUTPUT TABLE RowErrors).
         IF CAN-FIND(FIRST RowErrors) THEN DO:
            FOR EACH RowErrors:
                ASSIGN vLogErro = YES.
                ASSIGN ErrorDescription = ErrorDescription + " para (WMS)":U.
                {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
            END.
            IF vLogErro = YES THEN
               RETURN ERROR.
         END.                        
    
         FIND FIRST wm-box
              WHERE wm-box.cod-estabel = ttWork.cod-estabel
                AND wm-box.cod-local   = ttWork.cod-local 
                AND wm-box.id-box      = id-box-contar NO-LOCK NO-ERROR.
         IF AVAIL wm-box THEN DO:
            ASSIGN vCodBloco  = wm-box.cod-bloco
                   vCodRua    = wm-box.cod-rua
                   vCodNivel  = wm-box.cod-nivel
                   vCodColuna = wm-box.cod-coluna.
            
            IF wm-box.ind-posicao-box=1 THEN
               ASSIGN vLado = "E".
            ELSE
               ASSIGN vLado = "D".
         END.
      END.
   END.
   DISP vCodBloco
        vCodRua
        vCodNivel
        vCodColuna
        vLado
      WITH FRAME frame04.
    
    PAUSE 0 NO-MESSAGE.
END PROCEDURE.

PROCEDURE GravaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro          = NO
          vLogsai           = NO
          vLogfinaliza      = NO.
          vLogControlaLogin = NO.
   
   /* Valida‡ao usu rio */
   IF INPUT FRAME Frame01 ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Usu rio Inv lido!(DC)"}
   END. 
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   IF v2_cod_usuar_corren = '' THEN DO:
      EMPTY TEMP-TABLE tt-erros.
      
      login:
      DO ON ERROR  UNDO LOGIN, LEAVE LOGIN
         ON QUIT   UNDO LOGIN, LEAVE LOGIN
         ON STOP   UNDO LOGIN, LEAVE LOGIN
         ON ENDKEY UNDO LOGIN, LEAVE LOGIN: 
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
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est ÿcorreta!(DC)"} 
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
   
   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic In wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   RUN validaUsuario IN wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
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
      
      {bcp/bc9105.i "202" "Usu rio sem permissÆo para Coletor (WMS)"}
   END.
   IF vLogErro = YES THEN
      RETURN ERROR.
         
   RETURN RETURN-VALUE.
End Procedure.

Procedure GravaCamposFrame02:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO
          INPUT FRAME Frame02 ttWork.cod-estabel
          INPUT FRAME Frame02 ttWork.cod-local.
   
   IF VALID-HANDLE (wgbosc038) THEN DO:
      DELETE OBJECT wgbosc038.
      ASSIGN wgbosc038 = ?.
   END.
   
   IF NOT AVAIL ttInventario THEN
      RETURN ERROR.
   
   ASSIGN ttWork.cod-estabel    = ttInventario.cod-estabel 
          ttWork.cod-local      = ttInventario.cod-local 
          ttWork.dat-inventario = ttInventario.dt-inventario 
          ttWork.num-seq-invent = ttInventario.num-seq-invent.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO. 
END PROCEDURE.

PROCEDURE GravaCamposFrame03:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   IF NOT AVAIL ttContagem THEN
      RETURN ERROR.
   
   ASSIGN ttWork.num-contagem = ttContagem.vNrContagem.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.  
END PROCEDURE.

PROCEDURE GravaCamposFrame04:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.

   IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
      RUN scbo/bosc030.p PERSISTENT SET wgbosc030.
      RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF ttWork.num-box = 0 THEN DO:
      HIDE ALL NO-PAUSE.
             
      Run bcp/bc9024f.p  (INPUT ttWork.cod-estabel,
                          INPUT ttWork.cod-Local  ,
                          OUTPUT ttWork.num-box) .
      
      HIDE ALL NO-PAUSE.

      IF vLogErro = YES OR ttWork.num-box = 0 THEN DO:
         ASSIGN vLogerro = YES.
         RETURN ERROR.
      END.

      VIEW FRAME frame04.
      PAUSE 0 NO-MESSAGE.
      DISP ttWork.num-box WITH FRAME frame04.
      PAUSE 0 NO-MESSAGE.
   END.

   IF id-box-contar <> 0 AND id-box-contar <> ? THEN DO:
      IF(ttWork.num-box <> id-box-contar) THEN DO:
         ASSIGN vLogerro       = YES
                ttWork.num-box = 0.
         
         {bcp/bc9105.i "202" "Box nÆo confere com endere‡o a contar."}
         RETURN ERROR.  
      END.
   END.
                                      
   RUN emptyRowErrors IN wgbosc118.
   RUN ValidaEnderecoInventario IN wgbosc118 (INPUT ttWork.cod-estabel, 
                                              INPUT ttWork.cod-local,   
                                              INPUT ttWork.dat-inventario,
                                              INPUT ttWork.num-seq-invent,
                                              INPUT ttWork.num-contagem,
                                              INPUT ttWork.num-box,                                        
                                              OUTPUT ttWork.log-existe-end).   
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getRowErrors IN wgbosc118(OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
          ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
          {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.
      ASSIGN vLogErro = YES.
      RETURN ERROR.
   END.
   
   RUN emptyRowErrors IN wgbosc030.   
   RUN GoToKey IN wgbosc030(INPUT ttWork.cod-estabel,
                            INPUT ttWork.cod-local,   
                            INPUT ttWork.num-box).

   RUN getIntField IN wgbosc030(INPUT "ind-posicao-box", OUTPUT intvLado).
   RUN GetKey IN wgbosc030(OUTPUT ttWork.cod-estabel,
                           OUTPUT ttWork.cod-local,                         
                           OUTPUT vCodBloco,
                           OUTPUT vCodRua,
                           OUTPUT vCodNivel,
                           OUTPUT vCodColuna).           
   IF RETURN-VALUE <> 'OK' THEN DO:        
      RUN getRowErrors In wgbosc030(Output Table RowErrors).
      FOR EACH RowErrors:
          ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
          RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
      END.
      ASSIGN vLogErro = Yes.
      RETURN ERROR.
   END.
   
   IF intvLado=1 THEN
       ASSIGN vLado = "E".
   ELSE
       ASSIGN vLado = "D".
       
   ASSIGN vDesEndereco = trim(vCodBloco) + '/' + trim(vCodRua) + '/' + trim(vCodNivel) + '/' +  trim(vCodColuna) + '/' + TRIM(vLado).

   DISP vCodBloco
        vCodRua
        vCodNivel
        vCodColuna
        vLado
      WITH FRAME frame04.
   PAUSE 0 NO-MESSAGE.

   IF NOT ttWork.log-existe-end THEN DO:
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME FRAME04.
      PAUSE 0 NO-MESSAGE.

      ASSIGN vLogOk = YES.
      bc9024:
      DO ON ERROR  UNDO bc9024, LEAVE bc9024
         ON QUIT   UNDO bc9024, LEAVE bc9024
         ON STOP   UNDO bc9024, LEAVE bc9024
         ON ENDKEY UNDO bc9024, LEAVE bc9024:

         /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
         DEFINE VARIABLE c-lbl-liter-inventario-wms AS CHARACTER FORMAT "X(16)" NO-UNDO.
         {utp/ut-liter.i "Invent rio_WMS" *}
         ASSIGN c-lbl-liter-inventario-wms = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-box-nao-pertence AS CHARACTER FORMAT "X(18)" NO-UNDO.
         {utp/ut-liter.i "Box_nÆo_pertence" *}
         ASSIGN c-lbl-liter-box-nao-pertence = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-ao-inventario AS CHARACTER FORMAT "X(18)" NO-UNDO.
         {utp/ut-liter.i "ao_invent rio :" *}
         ASSIGN c-lbl-liter-ao-inventario = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-deseja-inclui-lo AS CHARACTER FORMAT "X(19)" NO-UNDO.
         {utp/ut-liter.i "Deseja_inclu¡-lo?" *}
         ASSIGN c-lbl-liter-deseja-inclui-lo = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(13)" NO-UNDO.
         {utp/ut-liter.i "1=Sim_2=NÆo" *}
         ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
         
         DISP c-lbl-liter-inventario-wms        AT ROW 01 COL 01 NO-LABEL    
              '------------------'              AT ROW 02 COL 01
              c-lbl-liter-box-nao-pertence      AT ROW 03 COL 01 NO-LABEL                                             
              c-lbl-liter-ao-inventario         AT ROW 04 COL 01 NO-LABEL             
              vDesEndereco                      AT ROW 05 COL 01 NO-LABEL FORMAT 'X(17)':U
              c-lbl-liter-deseja-inclui-lo      AT ROW 06 COL 01 NO-LABEL
              c-lbl-liter-1sim-2nao             AT ROW 07 COL 01 NO-LABEL WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX.
   
   
         ON 'ESC':U OF FRAME f-conf /* colocado p nÆo ocorrer erro progress de frame nÆo definida */
         DO:                                                    
            ASSIGN vlogerro = YES.  
            RETURN 'ESC':U.           
         END. 
         PAUSE 0 NO-MESSAGE.
         UPDATE vLogOk AT ROW 07 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8.
      END.
      
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      VIEW FRAME FRAME04.
      PAUSE 0 NO-MESSAGE.
      
      IF NOT vLogOk OR RETURN-VALUE = 'ESC':U THEN DO:
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
      ELSE DO:       
         RUN createEnderecoInventarioColetor IN wgbosc118(INPUT ttWork.cod-estabel,   
                                                          INPUT ttWork.cod-local,     
                                                          INPUT ttWork.dat-inventario, 
                                                          INPUT ttWork.num-seq-invent,
                                                          INPUT ttWork.num-box,
                                                          OUTPUT TABLE RowErrors).
         ASSIGN ttWork.log-existe-end = YES.
         IF CAN-FIND(FIRST RowErrors) THEN DO:  
            FOR EACH RowErrors:
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            END.
            RETURN ERROR.
         END.  
      END.
   END.
   /* Valida se usuario pode realizar contagem */
   RUN emptyRowErrors IN wgbosc118.

   RUN validaContagem IN wgbosc118(INPUT ttWork.cod-estabel,   
                                   INPUT ttWork.cod-local,     
                                   INPUT ttWork.dat-inventario, 
                                   INPUT ttWork.num-seq-invent,
                                   INPUT ttWork.num-box,        
                                   INPUT ttWork.cod-usuario,
                                   OUTPUT TABLE RowErrors).
   IF CAN-FIND(FIRST RowErrors) THEN DO:  
      FOR EACH RowErrors:
          ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
          RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
      END.
      RETURN ERROR.
   END.  

   /* Valida se usuario pode realizar contagem */
   IF NOT VALID-HANDLE(wgbc9024j) THEN
      RUN bcp/bc9024j.p PERSISTENT SET wgbc9024j.

   /* a tt-invent rio possuir  os registros j  lidos, afim de valida‡Æo */
   RUN pi-popula-temp-table-inventario IN wgbc9024j (INPUT ttWork.cod-usuario,
                                                     INPUT ttWork.cod-estabel,
                                                     INPUT ttWork.cod-local,
                                                     INPUT ttWork.dat-inventario,
                                                     INPUT ttWork.num-contagem,
                                                     INPUT ttWork.num-box,
                                                     OUTPUT TABLE tt-inventario-wms-bkp).

   IF VALID-HANDLE (wgbc9024j) THEN DO:
      DELETE OBJECT wgbc9024j.
      ASSIGN wgbc9024j = ?.
   END.

   HIDE ALL.
   PAUSE 0 NO-MESSAGE.
   HIDE FRAME FRAME04.
   PAUSE 0 NO-MESSAGE.
   
   RUN bcp/bc9024g.p (INPUT vDesEndereco, 
                      INPUT-OUTPUT TABLE tt-inventario-wms-bkp,
                      INPUT-OUTPUT TABLE ttWork).

   HIDE ALL.
   VIEW FRAME frame04.
   PAUSE 0 NO-MESSAGE.

   FIND FIRST ttWork NO-ERROR.
END PROCEDURE.


PROCEDURE piValidateScreen:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï respons vel valida‡Æo dos campos em tela do estabelecimento 
           e do local da frame 02    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAMETER pTpValidacao AS CHARACTER    NO-UNDO.
   
   DEFINE VARIABLE vnom-estabel AS CHARACTER           NO-UNDO.
   DEFINE VARIABLE vnom-local   AS CHARACTER           NO-UNDO.

   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO
          INPUT FRAME Frame02 ttWork.cod-estabel
          INPUT FRAME Frame02 ttWork.cod-local.

   IF pTpValidacao = "Estab" THEN DO:
      RUN getnomestabel IN wgbosc038 (INPUT ttWork.cod-estabel,
                                      OUTPUT vnom-estabel).
    
      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "201" "Estabelecimento Inv lido (WMS)"}
         
         RETURN "NOK":U.
      END.
   END.

   IF pTpValidacao = "Local" THEN DO:
      RUN getNomLocal IN wgbosc038 (INPUT ttWork.cod-local,
                                    OUTPUT vnom-local).
      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "203" "Local Inv lido (WMS)"}
         
         RETURN "NOK":U.
      END.
   END.
END.


PROCEDURE piCarregaEnderecos:
/*------------------------------------------------------------------------------
  Purpose: Carrega os endere‡os    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN INPUT FRAME Frame02 ttWork.cod-estabel
          INPUT FRAME Frame02 ttWork.cod-local.
  
   EMPTY TEMP-TABLE ttInventario.
   
   IF NOT VALID-HANDLE(wgbosc117) THEN
      RUN scbo/bosc117.p PERSISTENT SET wgbosc117.

   RUN getNewInventario IN wgbosc117 ( INPUT ttWork.cod-estabel,  
                                       INPUT ttWork.cod-local,
                                       OUTPUT TABLE ttInventario).   
   IF VALID-HANDLE(wgbosc117) THEN DO:
      RUN destroy IN wgbosc117.
      DELETE PROCEDURE wgbosc117 NO-ERROR.
   END.
   
   OPEN QUERY qryInventario
     FOR EACH ttInventario
           BY ttInventario.dt-inventario 
           BY ttInventario.num-seq-invent.                                

   IF NOT AVAIL ttInventario THEN DO:
      {bcp/bc9105.i "100" "NÆo existem invent rios para serem realizados (WMS)"}
      ASSIGN vLogErro = YES.
      RETURN "NOK":U.
   END.
END.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
