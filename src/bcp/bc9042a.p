/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9042A 2.00.00.006 } /*** "010006" 23/07/2024 13:43:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9042a MBC}
&ENDIF



{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9042.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Setembro/2009 - Lilian - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Armazenamento Packing            **
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
**                        Ex: tt-transf-wms.                                                      **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por    **
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
DEFINE INPUT PARAM pcod-coletor     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-equipamento AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-usuario     AS CHARACTER  NO-UNDO.

/* Definicao global do nome da transacao */
&global-define ProgramName BC9042
&global-define TempTable tt-armazena-packing
{bcp/bc9042.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}                
{bcp/bc9015.i3}  /* def variaveis padroes */
{method/dbotterr.i}

DEFINE TEMP-TABLE tt-etiq-packing NO-UNDO LIKE wms-etiq-packing.
DEFINE TEMP-TABLE ttwm-etiqueta   NO-UNDO LIKE wm-etiqueta.

DEFINE TEMP-TABLE ttWork NO-UNDO
    FIELD cod-usuario      AS CHARACTER FORMAT 'x(14)':U           LABEL 'Usuario'         
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
ASSIGN ttWork.cod-usuario     = pcod-usuario
       ttWork.cod-coletor     = pcod-coletor
       ttWork.cod-equipamento = pcod-equipamento.

/* Variaveis de trabalho */              
DEFINE VARIABLE vLogOk            AS LOGICAL   INITIAL NO                  NO-UNDO.
DEFINE VARIABLE de-embarque       AS DECIMAL   FORMAT '>>>>>>>>>>>>>>>9':U NO-UNDO.
DEFINE VARIABLE i-cod-resumo      AS INTEGER   FORMAT '>>>>,>>9':U         NO-UNDO.
DEFINE VARIABLE c-num-pedido      AS CHARACTER FORMAT 'x(12)':U            NO-UNDO.
DEFINE VARIABLE c-cod-cli         AS CHARACTER FORMAT 'x(12)':U            NO-UNDO.
DEFINE VARIABLE c-cod-estabel     AS CHARACTER                             NO-UNDO.
DEFINE VARIABLE c-cod-local       AS CHARACTER                             NO-UNDO.

DEFINE NEW SHARED VARIABLE wgbosc152 AS WIDGET-HANDLE NO-UNDO.      
DEFINE NEW SHARED VARIABLE wgbosc169 AS WIDGET-HANDLE NO-UNDO.   

/* Propriedades globais para frames */  
&global-define ErrorDisplaySeconds 3
&global-define FrameSize    20 By 8

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Etiqueta Packing    '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                              ttWork.num-serial                                 AT ROW 03 COL 02 NO-LABEL ~
                             'Emb:'                                             AT ROW 04 COL 01          ~
                              de-embarque                                       AT ROW 04 COL 05 NO-LABEL ~
                             'Resumo:'                                          AT ROW 05 COL 01          ~
                              i-cod-resumo                                      AT ROW 05 COL 08 NO-LABEL ~
                             'Ped:'                                             At Row 06 Col 01          ~
                              c-num-pedido                                      At Row 06 Col 05 NO-LABEL ~
                             'Cli:'                                             At Row 07 Col 01          ~
                              c-cod-cli                                         At Row 07 Col 05 NO-LABEL
&global-define Frame01Repeat NO
&global-define Update01Fields     ~
               ttWork.num-serial

/* Definicao das trigger de interacao com a tela */ 
&global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      

/* Definicao das trigger de usuario  */ 
&global-define UserTriggers                                                                     ~
                            ON 'ESC':U OF Frame Frame01                                         ~
                            DO:                                                                 ~
                                ASSIGN vlogerro     = YES                                              ~
                                       vLogSai      = YES                                              ~
                                       vLogFinaliza = YES                                              ~
                                       ttWork.num-serial   = 0                                         ~
                                       ttWork.num-serial:SCREEN-VALUE  IN FRAME Frame01    = '0'.      ~
                                HIDE ALL.                                                              ~
                            END.                                                              ~
                            ON 'leave':U OF ttwork.num-serial IN Frame Frame01                ~
                            DO:                                                               ~
                                ASSIGN INPUT FRAME Frame01 ttwork.num-serial.                 ~
                                RUN gotokey         IN wgbosc152(INPUT ttWork.num-serial).    ~
                                IF RETURN-VALUE = 'OK':U THEN DO:                             ~
                                    RUN getCharField IN wgbosc152(INPUT "nr-pedcli",          ~
                                                                  OUTPUT c-num-pedido).       ~
                                    RUN getCharField IN wgbosc152(INPUT "nome-abrev",         ~
                                                                  OUTPUT c-cod-cli).          ~
                                    RUN getDecField IN wgbosc152(INPUT "cdd-embarq",          ~
                                                                 OUTPUT de-embarque).         ~
                                    RUN getIntField IN wgbosc152(INPUT "nr-resumo",           ~
                                                                 OUTPUT i-cod-resumo).        ~
                                    DISP de-embarque                                          ~
                                         i-cod-resumo                                         ~
                                         c-num-pedido                                         ~
                                         c-cod-cli WITH FRAME frame01.                        ~
                                END.                                                          ~
                            END.                                                              ~

/* Definicao dos objetos ativos */ 
&global-define ActiveObject1 wgbosc152
&global-define ActiveObject2 wgbosc169

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/************************************* Codigo do Usuario Inicio ************************************
** Este local ≤ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:

   IF vLogFinaliza = YES THEN DO:
       ASSIGN vlogerro     = YES     
              vLogSai      = YES      
              vLogFinaliza = YES.
       HIDE ALL NO-PAUSE.
       RETURN RETURN-VALUE.
   END.

   IF NOT VALID-HANDLE(wgbosc152)  THEN DO:
      Run scbo/bosc152.p Persistent SET wgbosc152.
      Run openQueryStatic In wgbosc152 (Input "Main":U) No-error. 
   END.        

   IF NOT VALID-HANDLE(wgbosc169)  THEN DO:
      Run scbo/bosc169.p Persistent SET wgbosc169.
      Run openQueryStatic In wgbosc169 (Input "Main":U) No-error. 
   END.                               

   EMPTY TEMP-TABLE tt-etiq-packing.
   
   ASSIGN de-embarque  = 0
          i-cod-resumo = 0
          c-num-pedido = ''
          c-cod-cli    = ''
          ttWork.num-serial = 0. 

   DISP ttWork.num-serial de-embarque i-cod-resumo c-num-pedido c-cod-cli WITH FRAME Frame01. 
   APPLY 'leave':U TO ttWork.num-serial IN FRAME Frame01. 
END PROCEDURE.

PROCEDURE GravaCamposFrame01:

   ASSIGN vLogErro = NO 
          vLogOk   = NO 
          vLogFinaliza = NO
          INPUT FRAME Frame01 de-embarque
                              i-cod-resumo
                              c-num-pedido
                              c-cod-cli
                              ttWork.num-serial.

   /*Valida Etiqueta de Packing*/
   RUN openquerystatic IN wgbosc152(INPUT "main"). 
   RUN gotokey         IN wgbosc152(INPUT ttWork.num-serial).        
   IF RETURN-VALUE = 'NOK':U THEN DO:
      ASSIGN vLogErro = Yes.
      {bcp/bc9105.i "303" "Etiqueta n∆o cadastrada."}
      RETURN ERROR.
   END.

   RUN getCharField IN wgbosc152(INPUT "cod-estabel",
                                 OUTPUT c-cod-estabel).

   RUN getCharField IN wgbosc152(INPUT "cod-local",
                                 OUTPUT c-cod-local).

   RUN getCharField IN wgbosc152(INPUT "nr-pedcli",
                                 OUTPUT c-num-pedido).

   RUN getCharField IN wgbosc152(INPUT "nome-abrev",
                                 OUTPUT c-cod-cli).

   RUN getDecField IN wgbosc152(INPUT "cdd-embarq",
                                OUTPUT de-embarque).

   RUN getIntField IN wgbosc152(INPUT "nr-resumo",
                                OUTPUT i-cod-resumo).

   /*Valida Etiqueta j† armazenada*/
   RUN validateEtiqueta IN wgbosc169(INPUT c-cod-estabel,      
                                     INPUT c-cod-local,
                                     INPUT ttwork.num-serial).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN getrowErrors IN wgbosc169 (OUTPUT TABLE RowErrors).
      ASSIGN vLogErro = YES.
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.
      RETURN ERROR.
   END.

   DISP de-embarque
        i-cod-resumo
        c-num-pedido
        c-cod-cli WITH FRAME frame01.    

   EMPTY TEMP-TABLE tt-etiq-packing.
   
   CREATE tt-etiq-packing.
   ASSIGN tt-etiq-packing.val-etiq-packing = ttwork.num-serial
          tt-etiq-packing.cod-estabel      = c-cod-estabel
          tt-etiq-packing.cod-local        = c-cod-local
          tt-etiq-packing.cdd-embarq       = de-embarque
          tt-etiq-packing.nr-resumo        = i-cod-resumo 
          tt-etiq-packing.nr-pedcli        = c-num-pedido
          tt-etiq-packing.nome-abrev       = c-cod-cli.

   PAUSE 3 NO-MESSAGE.
    
   HIDE ALL NO-PAUSE.
   RUN bcp/bc9042c.p (INPUT ttWork.cod-coletor,    
                      INPUT ttWork.cod-equipamento,
                      INPUT ttWork.cod-usuario,
                      INPUT TABLE tt-etiq-packing).
   HIDE ALL NO-PAUSE.
    
END PROCEDURE.


