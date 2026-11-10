/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9015 2.00.00.013 } /*** "010013" 15/03/2024 16:00:03  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9015 MBC}
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
/********************************************************************************************
**   Programa..: bc9015.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - ago/2002 - Karla Cristiane Klemke                           **
**                                                                                         **
**   Objetivo..: Templates DB Interface para transacao de Requisicao de Materiais          **
**                                                                                         **
**                                                                                         **
********************************************************************************************/
Define New Global Shared Var lMenu          As Logical                               No-undo.

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-requis-mat-bc.                                                   **
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
***************************************************************************************************/
/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9015

/************************************************************/


DEFINE VARIABLE vNumItens               As INTEGER FORMAT '999'             NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE wgbosc074               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE wgbosc079               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE wgbcapiwms              AS HANDLE                           NO-UNDO.
DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                 INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                 INIT NO  NO-UNDO.
DEFINE VARIABLE wgbcapi001              AS HANDLE                           NO-UNDO.
DEFINE VARIABLE vtitulo                 AS CHARACTER FORMAT 'x(15)'         NO-UNDO.
DEFINE VARIABLE vnrtrans                LIKE bc-trans.nr-trans              NO-UNDO.
DEFINE VARIABLE wgbc9015f               AS HANDLE                           NO-UNDO.
DEFINE VARIABLE vcontrol                AS LOGICAL                          NO-UNDO.
DEFINE VARIABLE vmensagem               AS CHARACTER                        NO-UNDO.
DEFINE VARIABLE vLogPalletOk            AS LOGICAL                 Init NO  NO-UNDO.
DEFINE VARIABLE vLogPalletNokUnico      AS LOGICAL                 Init NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                 Init NO  NO-UNDO.
DEFINE VARIABLE vcod-senha              AS CHARACTER FORMAT 'x(18)':U       NO-UNDO.
DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

{bcp/bc9015.i3} /* def var padroes */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */
{utp/utapi009.i} /* login */

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-monta-cargas
{bcp/bc9015.i " "}
DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta .
DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
DEFINE TEMP-TABLE RowErrors NO-UNDO    
            FIELD ErrorSequence    AS INTEGER 
            FIELD ErrorNumber      AS INTEGER 
            FIELD ErrorDescription AS CHARACTER 
            FIELD ErrorParameters  AS CHARACTER 
            FIELD ErrorType        AS CHARACTER 
            FIELD ErrorHelp        AS CHARACTER 
            FIELD ErrorSubType     AS CHARACTER.
/************************************************************/

/* instanciando BO da tabela wm-etiqueta */


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Entrada Carga WMS'        At Row 01 Col 01          ~
                             '1 - Montar Carga'         At Row 02 Col 01          ~
                             '2 - Estornar Carga'       At Row 03 Col 01          ~
                             '3 - Fechar Carga'         At Row 04 Col 01          ~
                             '9 - Voltar'               At Row 05 Col 01          ~
                             'Tipo Trans:'              At Row 06 Col 01          ~
                              ttWork.tipo-trans         At Row 06 Col 12 NO-LABEL

&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Pto:   '     At Row 03 Col 01          ~
                             'Usr:   '     At Row 04 Col 01          ~
                             'Sen:'        AT ROW 05 COL 01          ~
                             vcod-senha    AT ROW 05 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Ser:   '     At Row 06 Col 01          ~
                             'Qt/It: '     At Row 08 Col 01          ~
                             vtitulo                  At Row 01 Col 03 NO-LABEL ~
                             ttWork.num-ponto   At Row 03 Col 05 No-label ~
                             ttWork.cod-usuario       At Row 04 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             ttWork.num-serial        At Row 06 Col 05 No-Label ~
                             vNumItens                At Row 08 Col 09 NO-LABEL ~

&global-define Frame02Repeat YES
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.tipo-trans

&global-define Update02Fields ~
               ttWork.num-ponto    WHEN ttWork.num-ponto = 0 ~
               ttWork.cod-usuario  WHEN ttWork.cod-usuario = ''~
               vcod-senha          WHEN ttWork.cod-usuario = ''~
               ttWork.num-serial   WHEN ttwork.tipo-trans <> 3~
 
                             
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. IF vLogFinaliza = YES THEN RETURN.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02.~
                                    Run GravaTransacao. 

/************************************************************/
&global-define UserTriggers On Leave of ttWork.num-ponto in Frame Frame02 ~
                            DO: ~
                                /* popula os seriais j  lidos no ponto */                                                ~
                                RUN popula-temp-table-serial in wgbc9015f ( INPUT input Frame Frame01 ttWork.tipo-trans, ~
                                                                            INPUT INPUT FRAME frame02 ttWork.num-ponto,  ~
                                                                            INPUT-OUTPUT TABLE tt-monta-cargas-bkp,      ~
                                                                            INPUT-OUTPUT TABLE tt-erro,                  ~
                                                                            OUTPUT vcarganova,                           ~
                                                                            OUTPUT vnumitens).                           ~
                                Display vNumItens vtitulo With Frame {&Frame02Name}.                                     ~
                                IF v_cod_usuar_corren <> '' THEN DISABLE ttWork.cod-usuario WITH FRAME Frame02.          ~
                            END.~

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
/**************************************************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc074
&GLOBAL-DEFINE ActiveObject2 wgbc9015f
&GLOBAL-DEFINE ActiveObject3 wgbcapi001
&GLOBAL-DEFINE ActiveObject4 wgbcapiwms

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
   IF NOT VALID-HANDLE(wgbc9015f) THEN DO:
      RUN bcp/bc9015f.p PERSISTENT SET wgbc9015f.
   END.

   EMPTY TEMP-TABLE ttwork.
   EMPTY TEMP-TABLE tt-monta-cargas-bkp.

   ASSIGN vcontrol = NO.
   CREATE ttwork.
   ASSIGN vNumItens = 0
          ttWork.tipo-trans = 1
          ttwork.num-serial = 0
          ttwork.num-ponto  = 0.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando o campo estabelecimento da tela Frame02 com o valor 1        **
** Os outros campos nao estao sendo inicializados pois os mesmos devem apresentar valor           **
** caso seja retornado a proxima tela para esta.                                                  **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/

PROCEDURE InicializaCamposFrame02:
   IF NOT VALID-HANDLE(wgbc9015f)  THEN DO:
       RUN bcp/bc9015f.p PERSISTENT SET wgbc9015f.
   END.
   
   IF ttWork.tipo-trans = 1 THEN
      ASSIGN vtitulo = CAPS('Montar Carga').
   
   IF ttWork.tipo-trans = 2 THEN
      ASSIGN vtitulo = CAPS('Estornar Carga').
   
   IF ttWork.tipo-trans = 3 THEN
      ASSIGN vtitulo          = CAPS('Fechar Carga')
             ttwork.num-ponto = 0
             vnumitens        = 0.
   
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame02 = NO.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame02 = v_cod_usuar_corren
             ttWork.cod-usuario                               = v_cod_usuar_corren
             vcod-senha                                       = '****************':U /* login autom tico */
             vcod-senha:SCREEN-VALUE IN FRAME frame02         = '****************':U. /* login autom tico */
   END.
   ELSE DO:
      ASSIGN vcod-senha:BLANK IN FRAME frame02 = YES.
      ASSIGN ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame02 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame02 = ''.
   END.
   DISPLAY vNumItens 
           vtitulo
      WITH FRAME {&Frame02Name}.
   
   ASSIGN ttwork.num-serial = 0 .
END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   ASSIGN vLogErro          = NO 
          vLogControlaLogin = NO.
   
   IF INPUT FRAME Frame01 ttWork.tipo-trans < 1 OR (INPUT FRAME Frame01  ttWork.tipo-trans > 3 AND INPUT FRAME Frame01 ttwork.tipo-trans <> 9) THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "001" "As op‡äes dispon¡veis sÆo: 1,2,3 e 9 (DC)"}
   End.
   
   IF vLogErro = YES THEN DO:
      RUN destroyhandle IN THIS-PROCEDURE.
      RETURN ERROR.
   END.
   
   /* Validacoes Frame 01 Fim    --- */
   IF INPUT FRAME Frame01 ttWork.tipo-trans = 9 THEN DO:
      RUN destroyhandle IN THIS-PROCEDURE.
      ASSIGN vLogSai     = YES
            vLogFinaliza = YES.
      HIDE ALL NO-PAUSE.
      RETURN 'OK':U.
   END.
   ASSIGN {&TempTable}.tipo-trans = INPUT FRAME Frame01 ttWork.tipo-trans.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:
   DEF VAR vdetalhe AS CHAR.
   
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.

   /* Valida  ponto */
   IF INPUT FRAME Frame02 ttWork.num-ponto = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "101" "Ponto Carga Inv lido (DC)"}
   END.
   
   ASSIGN vdetalhe = 'Pto:':U + STRING(INPUT FRAME Frame02 ttWork.num-ponto).
   IF {&TempTable}.tipo-trans = 1 THEN DO: /* Montagem da carga */    
      IF vcontrol = NO THEN DO:
         FIND FIRST tt-monta-cargas-bkp NO-LOCK NO-ERROR.
         IF AVAILABLE tt-monta-cargas-bkp THEN DO:
            IF vcarganova = NO  THEN  DO:
               {bcp/bc9105.i "102" "Carga J  Iniciada!(DC)"}
            END.
            ASSIGN vcontrol = YES.
         END.
      END.
   END.
   IF vLogErro = YES THEN DO:
      RUN destroyhandle IN THIS-PROCEDURE.
      RETURN ERROR.
   END.
        
   /* Valida usuµrio */
   IF INPUT FRAME Frame02 ttWork.cod-usuario = '' THEN DO:
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
         RUN btb/btapi910za.p(INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame02,
                              INPUT vCod-Senha,
                              OUTPUT TABLE tt-erros) NO-ERROR.        
      END. 
      IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4753) THEN DO:
         RUN destroyhandle IN THIS-PROCEDURE.
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         ASSIGN vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros WHERE tt-erros.cod-erro = 4758) THEN DO:
            RUN destroyhandle IN THIS-PROCEDURE.
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.
      ASSIGN vLogControlaLogin = YES.
   
      IF NOT VALID-HANDLE(wgbcapiwms) THEN
         RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.
   
      RUN piValidaUsuario IN wgbcapiwms ( INPUT ttWork.cod-usuario:SCREEN-VALUE IN FRAME frame02,
                                          OUTPUT ttWork.cod-usuario).
   END.
   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
   RUN validaUsuario IN wgbosc079 ( INPUT INPUT FRAME Frame02 ttWork.cod-usuario,
                                    OUTPUT vLogUtilizaColetor,
                                    OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors In wgbosc079 (OUTPUT TABLE RowErrors).
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
   IF vLogErro = YES THEN DO:
      RUN destroyhandle IN THIS-PROCEDURE.
      RETURN ERROR.
   END.

   /* Valida serial */
   IF INPUT FRAME Frame01 ttWork.tipo-trans <> 3 AND INPUT FRAME Frame02 ttWork.num-serial = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Serial Inv lido (DC)"}
   END.
   IF vLogErro = YES THEN DO:
      RUN destroyhandle IN THIS-PROCEDURE.
      RETURN ERROR.
   END.
   IF INPUT FRAME Frame01 ttWork.tipo-trans = 1 THEN DO:
      /* valida se o serial j  foi lido para a carga corrente */
      FIND tt-monta-cargas-bkp WHERE
           tt-monta-cargas-bkp.num-serial = input Frame Frame02 ttWork.num-serial NO-LOCK NO-ERROR.
      IF AVAILABLE tt-monta-cargas-bkp THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Serial j  encontra-se na carga (DC)"}
      END.
      IF vLogErro = YES THEN DO:
         RUN destroyhandle IN THIS-PROCEDURE.
         RETURN ERROR.
      END.
      /* valida se o serial j  foi lido  em outra carga */
      EMPTY TEMP-TABLE tt-erro.
      EMPTY TEMP-TABLE tt-trans.
      
      CREATE tt-trans.
      ASSIGN tt-trans.cod-versao-integracao = 1
             tt-trans.i-sequen = 1
             tt-trans.cd-trans = 'WMEnt001':U
             tt-trans.detalhe = 'Pto:':U + input Frame Frame02 ttWork.num-ponto
             tt-trans.usuario = v_cod_usuar_corren.
             tt-trans.etiqueta = NO.

      IF NOT VALID-HANDLE(wgbc9015f) THEN DO:
         RUN bcp/bc9015f.p PERSISTENT SET wgbc9015f.
      END.

      RUN valida_serial_wms in wgbc9015f (INPUT String(input Frame Frame02 ttWork.num-serial,'99999999999999':U),
                                          INPUT TABLE tt-trans,
                                          INPUT-OUTPUT TABLE tt-erro).
      FIND FIRST tt-erro NO-ERROR.
      IF AVAIL tt-erro THEN DO: 
         ASSIGN vLogErro = YES.
         FOR EACH tt-erro:
            ASSIGN tt-erro.mensagem =  tt-erro.mensagem + "(DC)":U.
            {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
         END.
      END.
      IF vLogErro = YES THEN DO:
         RUN destroyhandle IN THIS-PROCEDURE.
         RETURN ERROR.
      END.
      
      IF NOT VALID-HANDLE(wgbosc074) THEN DO:
         RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
         RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
      END.
      RUN EmptyRowErrors IN wgbosc074.

      /* a validagrupcarga era utilizada na efetivacao da montagem */
      RUN validaAgrupCarga IN wgbosc074 (INPUT INPUT FRAME Frame02 ttWork.cod-usuario,
                                         INPUT INPUT FRAME Frame02 ttWork.num-serial).         
      IF RETURN-VALUE <> 'OK' THEN DO:
         RUN getrowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
         ASSIGN vLogErro = YES.
         FOR EACH RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
         END.                                           
      END.
      IF vLogErro = YES THEN DO:
         RUN destroyhandle IN THIS-PROCEDURE.
         RETURN ERROR.
      END.
      RUN getInfoEtiqueta IN wgbosc074 (INPUT INPUT FRAME Frame02 ttWork.num-serial,
                                        OUTPUT TABLE ttWM-etiqueta).         
      IF RETURN-VALUE <> 'OK':U THEN DO:
         RUN getrowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
         ASSIGN vLogErro = YES.
         FOR EACH RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
         END.                                                            
      END.
      FIND FIRST ttwm-etiqueta NO-ERROR.
      If NOT AVAILABLE ttwm-etiqueta THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Serial Invalido ou Usuario Nao Utiliza Coletor (DC)"}
      END.
      
      IF AVAIL ttWm-etiqueta AND ttWm-etiqueta.id-carga <> 0 THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "303" "Serial ja esta em uma Carga"}
      END.
      
      /* Valida se quantidade do pallet e menor que quantidade da embalagem (paleativo) */
      RUN ReturnValueStandard IN wgbosc074 (INPUT INPUT FRAME Frame02 ttWork.num-serial,
                                            OUTPUT vLogPalletOk).         
      IF RETURN-VALUE <> 'OK':U THEN DO:
         RUN getrowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
         FOR EACH RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
         END.
         ASSIGN vLogErro = YES.
      END.
   END.
     
   IF {&TempTable}.tipo-trans = 2 THEN DO: /* Estorno da carga */
      IF vcarganova = YES THEN DO:
         ASSIGN vLogErro = YES.
         ASSIGN ttWork.num-ponto = 0.
         DISP   ttWork.num-ponto WITH FRAME frame02.
         {bcp/bc9105.i "103" "NÆo existe serial para estorno neste ponto (DC)"}
      END.
      ELSE DO:
         FIND FIRST tt-monta-cargas-bkp
              WHERE tt-monta-cargas-bkp.num-serial = INPUT FRAME Frame02 ttWork.num-serial NO-LOCK NO-ERROR.
         IF NOT AVAILABLE tt-monta-cargas-bkp THEN DO:
            ASSIGN vLogErro = YES.
            ASSIGN ttWork.num-serial = 0.
            DISP ttWork.num-serial WITH FRAME frame02.
            {bcp/bc9105.i "56" "Serial Inv lido (DC)"}
         END.
      END.
   END.
      
   IF {&TempTable}.tipo-trans = 3 THEN DO: /* Fechamento da carga */
      IF vcarganova = YES THEN DO:
         ASSIGN vLogErro = YES.
         ASSIGN ttWork.num-ponto = 0.
         
         DISP ttWork.num-ponto WITH FRAME frame02.
         {bcp/bc9105.i "57" "NÆo existe carga para fechamento neste ponto (DC)"}
      END.
   END.
   IF vLogErro = YES THEN DO:
      RUN destroyhandle IN THIS-PROCEDURE.
      RETURN ERROR.
   END.
   /* Validacoes Frame 02 Fim    --- */
   ASSIGN {&TempTable}.num-ponto   = INPUT FRAME Frame02 ttWork.num-ponto 
          {&TempTable}.cod-usuario = INPUT FRAME Frame02 ttWork.cod-usuario 
          {&TempTable}.num-serial  = INPUT FRAME Frame02 ttWork.num-serial.
   RUN destroyhandle IN THIS-PROCEDURE.         
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
   DEF VAR vNomeUsuario  AS CHARACTER  NO-UNDO.
   DEF VAR vsequencia    AS INTEGER    NO-UNDO.  
   DEF VAR vcont         AS INTEGER    NO-UNDO.
   DEF VAR i-qtd-reg     AS INTEGER    NO-UNDO.
   
   IF vLogErro = NO THEN DO:
      IF {&TempTable}.tipo-trans = 1 THEN DO: /* Montagem da carga */ 
         /* ps.: conf definicao... a montagem devera considerar somente a bc-trans e bc-trans-filho desconsiderando logica VIPAL */
         EMPTY TEMP-TABLE tt-trans.
         EMPTY TEMP-TABLE tt-trans-filho.
   
         CREATE tt-trans.
         ASSIGN tt-trans.cod-versao-integracao = 1
                tt-trans.i-sequen              = 1
                tt-trans.cd-trans              = 'WMEnt001':U
                tt-trans.detalhe               = 'Pto:':U + STRING({&TempTable}.num-ponto)
                tt-trans.usuario               = v_cod_usuar_corren.
                tt-trans.etiqueta              = NO.
         
         CREATE tt-trans-filho.
         ASSIGN tt-trans-filho.i-sequen-pai = 1
                tt-trans-filho.i-sequen     = 1    
                tt-trans-filho.num-versao   = 1
                tt-trans-filho.conteudo-xml = 'Pto:':U + STRING({&TempTable}.num-ponto) + ';' + 'Ser:':U + STRING({&TempTable}.num-serial,'99999999999999':U).       
      
         IF NOT VALID-HANDLE(wgbcapi001) THEN DO:
            RUN bcp/bcapi001.p PERSISTENT SET wgbcapi001(INPUT-OUTPUT TABLE tt-trans,
                                                         INPUT-OUTPUT TABLE tt-erro).
         END.
      
         RUN cria_reg_wms IN wgbcapi001 ( INPUT 4,
                                          INPUT-OUTPUT TABLE tt-trans,
                                          INPUT-OUTPUT TABLE tt-trans-filho,
                                          INPUT-OUTPUT TABLE tt-erro).
         /* 4 = Estado da Transacao = Em Processo */
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
               {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
            END.
         END.
         ELSE DO:
            {bcp/bc9105.i "901" "Carregado!(DC)"}
            /* serial lido c sucesso, logo deve-se atualizar tt-monta-cargas-bkp */
      
            FIND FIRST tt-trans NO-ERROR.
            FIND FIRST tt-monta-cargas-bkp
                 WHERE tt-monta-cargas-bkp.num-serial = INPUT FRAME Frame02 ttWork.num-serial NO-LOCK NO-ERROR.
            IF NOT AVAIL tt-monta-cargas-bkp THEN DO:
               CREATE tt-monta-cargas-bkp.
               ASSIGN tt-monta-cargas-bkp.num-ponto  = INPUT FRAME Frame02 ttWork.num-ponto 
                      tt-monta-cargas-bkp.num-serial = INPUT FRAME Frame02 ttWork.num-serial
                      tt-monta-cargas-bkp.nr-trans   = tt-trans.nr-trans.
            END.
            ASSIGN vNumItens = vNumItens + 1.
            DISPLAY vnumitens WITH FRAME frame02.
         END.
      END.
      IF {&TempTable}.tipo-trans = 2 THEN DO: /* Estorno da carga */
         /* ps.: conf definicao... o estorno devera considerar somente a bc-trans e bc-trans-filho desconsiderando logica VIPAL */
         EMPTY TEMP-TABLE tt-trans.
         EMPTY TEMP-TABLE tt-trans-filho.
         
         FIND FIRST tt-monta-cargas-bkp
              WHERE tt-monta-cargas-bkp.num-serial = INPUT FRAME Frame02 ttWork.num-serial NO-LOCK NO-ERROR.
         CREATE tt-trans.
         ASSIGN tt-trans.cod-versao-integracao = 1
                tt-trans.i-sequen              = 1
                tt-trans.nr-trans              = tt-monta-cargas-bkp.nr-trans
                tt-trans.cd-trans              = 'WMEnt001':U
                tt-trans.detalhe               = 'Pto:':U + STRING({&TempTable}.num-ponto)
                tt-trans.usuario               = v_cod_usuar_corren
                tt-trans.etiqueta              = NO.
         
         CREATE tt-trans-filho.
         ASSIGN tt-trans-filho.i-sequen-pai = 1
                tt-trans-filho.i-sequen     = 1    
                tt-trans-filho.num-versao   = 1
                tt-trans-filho.conteudo-xml = 'Pto:':U + STRING({&TempTable}.num-ponto) + ';' + 'Ser:':U + String({&TempTable}.num-serial,'99999999999999':U).       
      
         IF NOT VALID-HANDLE(wgbc9015f) THEN DO:
            RUN bcp/bc9015f.p PERSISTENT SET wgbc9015f.
         END.
         
         RUN elimina_reg_wms IN wgbc9015f (INPUT-OUTPUT TABLE tt-trans, 
                                           INPUT-OUTPUT TABLE tt-trans-filho,
                                           INPUT-OUTPUT TABLE tt-monta-cargas-bkp,
                                           OUTPUT vcont, 
                                           INPUT-OUTPUT TABLE tt-erro).
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
               {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
            END.
         END.
         ELSE DO:
            {bcp/bc9105.i "901" "Serial Eliminado!(DC)"}
            ASSIGN vNumItens = vNumItens - 1.
            DISPLAY vnumitens WITH FRAME frame02.
         END.
      END.
      IF {&TempTable}.tipo-trans = 3 THEN DO: /* Fechamento da carga */
         FIND FIRST tt-monta-cargas-bkp NO-LOCK NO-ERROR.
         EMPTY TEMP-TABLE tt-trans.
         IF vnrtrans = 0 THEN DO: 
            CREATE tt-trans.
            ASSIGN tt-trans.cod-versao-integracao = 1
                   tt-trans.i-sequen              = 1
                   tt-trans.nr-trans              = tt-monta-cargas-bkp.nr-trans
                   tt-trans.cd-trans              = 'WMEnt001':U
                   tt-trans.detalhe               = 'Pto:':U + STRING({&TempTable}.num-ponto)
                   tt-trans.usuario               = v_cod_usuar_corren.
                   tt-trans.etiqueta              = NO.
         END.
         
         IF NOT VALID-HANDLE(wgbc9015f) THEN DO:
            RUN bcp/bc9015f.P PERSISTENT SET wgbc9015f.
         END.
         
         RUN fechamento_carga_wms IN wgbc9015f (INPUT-OUTPUT TABLE tt-trans,
                                                INPUT-OUTPUT TABLE tt-erro).
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
               ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
               {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
            END.
         END.
         ELSE DO:
            RUN fechamento_pre_api_wms IN wgbc9015f ( INPUT-OUTPUT TABLE tt-trans,
                                                      INPUT-OUTPUT TABLE tt-erro).
            FIND FIRST tt-erro NO-ERROR.
            IF AVAIL tt-erro THEN DO: 
               FOR EACH tt-erro:
                  ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                  {bcp/bc9015.i2 STRING(tt-erro.cd-erro) STRING(tt-erro.mensagem)}
               END.
            END.
            ELSE DO:
               FIND FIRST tt-trans NO-LOCK NO-ERROR.
               IF tt-trans.nr-trans  <> 0 THEN DO:
                  ASSIGN vmensagem = "Carga Fechada! Total de Itens: " + STRING(vNumItens) + "(DC)":U.
                  {bcp/bc9015.i2 string(901) vmensagem}       
               END.
               ELSE DO:
                  {bcp/bc9105.i "56" "Ponto Inexistente! (DC)"}
               END.
            END.
         END.
         EMPTY TEMP-TABLE tt-erro.
      END.
             
      IF NOT CAN-FIND (FIRST tt-monta-cargas-bkp) THEN DO:
         RUN destroyhandle IN THIS-PROCEDURE.
         ASSIGN ttWork.num-ponto  = 0
                ttWork.num-serial = 0.
             
         DISP ttWork.num-ponto 
              ttWork.num-serial
            WITH FRAME frame02.
         
         ASSIGN vLogErro           = YES.
         RETURN ERROR.
      END.
   END.
END PROCEDURE.


PROCEDURE destroyhandle :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   IF VALID-HANDLE(wgbosc079) THEN
      RUN destroy IN wgbosc079.
   
   IF VALID-HANDLE(wgbosc074) THEN
      RUN destroy IN wgbosc074.
   
   IF VALID-HANDLE(wgbc9015f) THEN
      DELETE PROCEDURE wgbc9015f.
  
   IF VALID-HANDLE(wgbcapi001) THEN
      DELETE PROCEDURE wgbcapi001.
  
   IF VALID-HANDLE(wgbc9015f) THEN
      DELETE PROCEDURE wgbc9015f.
   
   IF VALID-HANDLE(wgbcapiwms) THEN
      DELETE PROCEDURE wgbcapiwms NO-ERROR.    
     
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
/*************************************  Codigo do Usuario Fim   **********************************/
