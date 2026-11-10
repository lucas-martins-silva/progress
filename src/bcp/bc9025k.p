/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9025K 2.00.00.022 } /*** "010022" 27/01/2025 09:42:28 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9025k MBC}
&ENDIF

{include/i_dbinst.i}  /* versío das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferºncia WMS                **
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
DEFINE TEMP-TABLE ttwm-etiqueta NO-UNDO LIKE wm-etiqueta.

DEFINE INPUT PARAM pcod-coletor        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-equipamento    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-estabel        AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-local          AS CHARACTER  NO-UNDO.
DEFINE OUTPUT PARAM i-retorno-bc9025m   AS DECIMAL    NO-UNDO.
DEFINE OUTPUT PARAM TABLE FOR ttWm-etiqueta.

/* Definicao global do nome da transacao */
&global-define ProgramName BC9025
/* Definicao da temp-table de integracao */
&global-define TempTable tt-transf-wms

{bcp/bc9025.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}              
{bcp/bc9015.i3}  /* def variaveis padroes */
{method/dbotterr.i}

DEFINE TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.
CREATE ttWork.
ASSIGN ttWork.cod-coletor      = pcod-coletor
       ttWork.cod-equipamento  = pcod-equipamento
       ttWork.cod-estabel      = pcod-estabel
       ttWork.cod-local        = pcod-local
       ttWork.cod-usuario      = v_cod_usuar_corren.

DEFINE TEMP-TABLE ttWm-etiqueta2 NO-UNDO LIKE wm-etiqueta
            FIELD RowNum AS INTEGER INIT 1
            FIELD r-Rowid AS ROWID.

DEFINE TEMP-TABLE tt-etiqueta NO-UNDO
            FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item    LIKE wm-etiqueta.qtd-item
            INDEX codigo IS UNIQUE id-etiqueta.

/* Variaveis de trabalho */              
DEFINE VARIABLE vLogOk             AS LOGICAL                         INITIAL NO NO-UNDO.
DEFINE VARIABLE d-qtd-item         LIKE wm-etiqueta.qtd-item                     NO-UNDO.
DEFINE VARIABLE vEndereco          AS CHARACTER FORMAT 'x(17)':U                 NO-UNDO.
DEFINE VARIABLE vCodBloco          AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE vCodRua            AS CHARACTER                                  NO-UNDO. 
DEFINE VARIABLE vCodNivel          AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE vCodColuna         AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE vlog-bloq-armaz    AS LOGICAL                                    NO-UNDO.
DEFINE VARIABLE vlog-bloq-retir    AS LOGICAL                                    NO-UNDO. 
DEFINE VARIABLE v-pos-box          AS CHARACTER                                  NO-UNDO.
DEFINE VARIABLE num-box-orig-aux   AS DECIMAL   FORMAT '>>>>>>>>>9':U INITIAL 0  NO-UNDO.  
DEFINE VARIABLE c-mensagem         AS CHARACTER FORMAT 'x(6)'                    NO-UNDO.
DEFINE VARIABLE c-msg-erro         AS CHARACTER FORMAT 'x(16)'                   NO-UNDO.
DEFINE VARIABLE vLogEtiqueta-aux   AS LOGICAL                         INITIAL NO NO-UNDO.
DEFINE VARIABLE c-mensagem-box-ent AS CHARACTER FORMAT 'x(16)'                   NO-UNDO.
DEFINE VARIABLE erroDescricao      AS CHARACTER FORMAT 'x(16)'                   NO-UNDO.

DEFINE NEW SHARED VARIABLE wgbosc030 AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc074 AS WIDGET-HANDLE NO-UNDO.       
DEFINE NEW SHARED VARIABLE wgbosc098 AS WIDGET-HANDLE NO-UNDO.       


/* Propriedades globais para frames */              
&global-define FrameSize    20 By 8

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Transferància WMS'                                At Row 01  Col 01          ~
                             '-------------------':U                            At Row 02  Col 01          ~
                             'Box Sai:'                                         At Row 03  Col 01          ~
                             ttwork.num-box-orig                                At Row 03  Col 09 No-label ~
                             vEndereco                                          At Row 04  Col 01 NO-LABEL ~
                             'Ser:'                                             At Row 05  Col 01          ~
                             ttWork.num-serial                                  At Row 05  Col 05 NO-LABEL ~
                             c-mensagem-box-ent                                 At Row 07  Col 01 NO-LABEL ~
                             'Cancelar: '                                       At Row 08  Col 01          ~
                             c-mensagem                                         At Row 08  Col 11 NO-LABEL

&global-define Frame01Repeat YES

&global-define Update01Fields                                  ~
               ttWork.num-box-orig                             ~
               ttWork.num-serial

/* Definicao das trigger de interacao com a tela */ 
&global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  RUN GravaCamposFrame01. IF vLogfinaliza = YES THEN DO: LEAVE _frame01. END.

/* Definicao das trigger de usuario  */ 
&global-define UserTriggers                                                                               ~
                            ON 'ESC':U OF Frame Frame01 OR END-ERROR OF FRAME {&Frame01Name}              ~
                            DO:                                                                           ~
                                ASSIGN vlogerro          = YES                                            ~
                                       i-retorno-bc9025m = 999999.                                        ~
                                Return 'ESC':U.                                                           ~
                            END.                                                                          ~
                            ON 'F4':U OF ttwork.num-box-orig IN Frame Frame01                             ~
                             DO:                                                                          ~
                                 ASSIGN vlogerro          = YES                                           ~
                                        i-retorno-bc9025m = ttWork.num-box-orig.                          ~
                                 APPLY 'ESC':U TO FRAME Frame01.                                          ~
                             END.                                                                         ~
                            ON 'enter':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                            DO:                            ~
                                IF ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "999999" THEN  ~
                                    APPLY 'go':U TO FRAME Frame01.                                    ~
                                ELSE DO:                                                              ~
                                    APPLY 'leave':U TO ttwork.num-box-orig IN FRAME Frame01.          ~
                                    DISABLE ttWork.num-box-orig WITH FRAME Frame01.                   ~
                                    APPLY 'entry':U TO ttwork.num-serial IN FRAME Frame01.            ~
                                    RETURN NO-APPLY.                                                  ~
                                END.                                                                  ~
                            END.                                                                          ~
                            ON 'entry':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                            DO:                                                                           ~
                                ASSIGN c-mensagem-box-ent = ""                                            ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                IF ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 <> "0" AND           ~
                                   ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 <> "999999" THEN DO: ~
                                     DISABLE ttWork.num-box-orig WITH FRAME Frame01.                      ~
                                     APPLY "entry" TO ttWork.num-serial IN FRAME Frame01.                 ~
                                END.                                                                      ~
                            END.                                                                          ~
                            ON 'leave':U OF ttwork.num-box-orig IN Frame Frame01                          ~
                            DO:                                                                           ~
                                ASSIGN INPUT FRAME Frame01 ttwork.num-box-orig.                           ~
                                FIND FIRST wm-box NO-LOCK                                                 ~
                                    WHERE wm-box.cod-estabel = ttWork.cod-estabel                         ~
                                    AND   wm-box.cod-local   = ttWork.cod-local                           ~
                                    AND   wm-box.id-box      = ttWork.num-box-orig NO-ERROR.              ~
                                IF AVAIL wm-box THEN DO:                                                  ~
                                   IF wm-box.ind-posicao-box = 1 THEN                                     ~
                                       ASSIGN v-pos-box = "E".                                            ~
                                   ELSE                                                                   ~
                                       ASSIGN v-pos-box = "D".                                            ~
                                   ASSIGN vEndereco = wm-box.cod-bloco  + "/":U +                         ~
                                                      wm-box.cod-rua    + "/":U +                         ~
                                                      wm-box.cod-nivel  + "/":U +                         ~
                                                      wm-box.cod-coluna + "/":U +                         ~
                                                      v-pos-box.                                          ~
                                END.                                                                      ~
                                ELSE DO:                                                                  ~
                                    ASSIGN vEndereco = ''.                                                ~
                                END.                                                                      ~
                                DISP vEndereco WITH FRAME frame01.                                        ~
                                ASSIGN c-mensagem-box-ent = ""                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                            END.                                                                          ~
                            ON 'entry':U OF ttwork.num-serial IN FRAME Frame01                            ~
                            DO:                                                                           ~
                                ASSIGN c-mensagem = 'ESC'                                                 ~
                                       c-mensagem-box-ent = "               ".                            ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                            END.                                                                          ~
                            ON 'F4':U OF ttwork.num-serial IN Frame Frame01                               ~
                            DO:                                                                           ~
                                ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0".           ~
                                ENABLE ttWork.num-box-orig WITH FRAME Frame01.                            ~
                                ASSIGN c-mensagem-box-ent = ""                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                APPLY 'entry':U TO ttwork.num-box-orig IN FRAME Frame01.                  ~
                                RETURN NO-APPLY.                                                          ~
                            END.                                                                          ~
                            ON 'ESC':U OF ttwork.num-serial IN Frame Frame01 OR END-ERROR OF FRAME {&Frame01Name}     ~
                            DO:                                                                           ~
                                ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = "0".           ~
                                ENABLE ttWork.num-box-orig WITH FRAME Frame01.                            ~
                                ASSIGN c-mensagem-box-ent = ""                             ~
                                       c-mensagem         = '999999'.                                     ~
                                DISP c-mensagem WITH FRAME frame01.                                       ~
                                DISP c-mensagem-box-ent WITH FRAME frame01.                               ~
                                APPLY 'entry':U TO ttwork.num-box-orig IN FRAME Frame01.                  ~
                                RETURN NO-APPLY.                                                          ~
                            END.

/* Definicao dos objetos ativos */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc074
&global-define ActiveObject3 wgbosc098

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela */
&global-define ErrorDisplaySeconds 3

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc030.p PERSISTENT SET wgbosc030.
RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR. 
                                                           
RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR. 

RUN scbo/bosc098.p PERSISTENT SET wgbosc098.
RUN openQueryStatic IN wgbosc098 (INPUT "Main":U) NO-ERROR.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/************************************* Codigo do Usuario Inicio ************************************
** Este local ˝ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame03 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame03}.                       **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   IF vLogEtiqueta-aux = YES THEN DO:
      ASSIGN vlogerro         = YES     
             vLogSai          = YES      
             vLogFinaliza     = YES
             vLogEtiqueta-aux = YES.
      HIDE ALL NO-PAUSE.
      RETURN RETURN-VALUE.
   END.
   
   ASSIGN vLogErro         = NO 
          vLogOk           = NO 
          vLogFinaliza     = NO
          vLogEtiqueta-aux = NO.
   
   EMPTY TEMP-TABLE ttwm-etiqueta.
   
   ASSIGN ttWork.des-endereco   = ''
          vEndereco             = ''
          c-mensagem            = '999999'
          c-mensagem-box-ent    = "" 
          i-retorno-bc9025m     = 0.
          
   IF vLogOk = YES THEN DO:
      ASSIGN ttWork.num-box-orig = num-box-orig-aux /*999999*/
             ttWork.num-serial   = 0
             ttWork.num-serial:SCREEN-VALUE IN FRAME Frame01 = '0'.
      APPLY 'GO':U TO FRAME Frame01.
   END.
   
   DISP ttWork.num-box-orig
        vEndereco ttWork.num-serial
        c-mensagem-box-ent
        c-mensagem
      WITH FRAME Frame01. 
   
   APPLY 'LEAVE':U TO ttWork.num-box-orig IN FRAME Frame01. 
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame01}.                        **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   ASSIGN INPUT FRAME Frame01 vEndereco
                              ttWork.num-box-orig
                              ttWork.num-serial
                              c-mensagem-box-ent
                              c-mensagem.
   
   IF ttWork.num-box-orig <> 999999 THEN DO:
      /*Valida ID Box*/
      ASSIGN num-box-orig-aux = ttWork.num-box-orig.
      RUN retornaEnderecoBox IN wgbosc030(INPUT ttWork.cod-estabel, 
                                          INPUT ttWork.cod-local,   
                                          INPUT ttWork.num-box-orig,
                                          OUTPUT vCodBloco, 
                                          OUTPUT vCodRua,   
                                          OUTPUT vCodNivel, 
                                          OUTPUT vCodColuna).
      IF vCodBloco = '' AND vCodRua = '' THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "301" "Box Inv†lido. (WMS)"}
         RETURN ERROR.
      END.
      
      RUN retornaBloqBox IN wgbosc030(INPUT ttWork.cod-estabel, 
                                      INPUT ttWork.cod-local,   
                                      INPUT ttWork.num-box-orig,
                                      OUTPUT vlog-bloq-armaz, 
                                      OUTPUT vlog-bloq-retir).      
      
      IF vlog-bloq-retir = YES THEN DO:
         ASSIGN vLogErro = YES.
         ASSIGN erroDescricao = "Endereáo " + STRING(ttWork.num-box-orig) + " bloqueado (WMS)":U.
         {bcp/bc9015.i2 STRING(28259) STRING(erroDescricao)}         
         RETURN ERROR.          
      END.
      
      /*Valida Etiqueta*/
      RUN getInfoEtiqueta IN wgbosc074(INPUT ttwork.num-serial,
                                       OUTPUT TABLE ttWm-etiqueta).
      If RETURN-VALUE <> 'OK':U THEN DO:
         RUN getrowErrors IN wgbosc074 (OUTPUT TABLE RowErrors).
         ASSIGN vLogErro          = YES
                ttWork.num-serial = 0.
         FOR EACH RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
         END.
         RETURN ERROR.
      END.
      
      FIND FIRST ttwm-etiqueta NO-ERROR.
      IF NOT AVAILABLE ttwm-etiqueta THEN DO:
         ASSIGN vLogErro          = YES
                ttWork.num-serial = 0.
         {bcp/bc9105.i "302" "Serial Inv†lido ou Usu†rio N∆o Utiliza Coletor (DC)"}
         RETURN ERROR.
      END.
      
      If AVAILABLE ttWm-etiqueta AND ttWm-etiqueta.ind-sit-agrupador = 1 THEN DO:
         ASSIGN vLogErro          = YES
                ttWork.num-serial = 0.
         {bcp/bc9105.i "303" "Etiqueta n∆o Ç um agrupador"}
         RETURN ERROR.
      END.
      
      RUN openquerystatic IN wgbosc098(INPUT "main"). 
      RUN gotokey IN wgbosc098(INPUT ttWork.cod-estabel,
                               INPUT ttWork.cod-local,
                               INPUT ttWork.num-box-orig,
                               INPUT ttWork.num-serial).        
      IF RETURN-VALUE = 'NOK':U THEN DO:
         ASSIGN vLogErro          = YES
                ttWork.num-serial = 0.
         {bcp/bc9105.i "303" "Etiqueta n∆o est† armazenada no endereáo informado"}
         RETURN ERROR.
      END.
      
      
      ASSIGN vLogOk = YES.
      ASSIGN vLogFinaliza = YES.
      
      HIDE ALL NO-PAUSE.
   END.
   ELSE DO:
      ASSIGN vLogFinaliza      = YES.
             i-retorno-bc9025m = ttWork.num-box-orig.
      HIDE ALL NO-PAUSE.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame01}.                        **
****************************************************************************************************/
PROCEDURE piSolicitaCordenada:
   DEFINE FRAME FrameNavegIDWMS
         'Transferància WMS'                                 AT ROW 01 COL 01
         '------------------':U                             AT ROW 02 COL 01
         'Bloco:'                                           AT ROW 03 COL 01
         vCodBloco                                          AT ROW 03 COL 10 NO-LABEL
         'Rua:'                                             AT ROW 04 COL 01
         vCodRua                                            AT ROW 04 COL 10 NO-LABEL
         'N°vel:'                                           AT ROW 05 COL 01
         vCodNivel                                          AT ROW 05 COL 10 NO-LABEL
         'Coluna:'                                          AT ROW 06 COL 01
         vCodColuna                                         AT ROW 06 COL 10 NO-LABEL
      WITH 1 DOWN FONT 3 SIZE 20 BY 8 NO-BOX.
   
   UPDATE vCodBloco
          vCodRua
          vCodNivel
          vCodColuna
      WITH FRAME FrameNavegIDWMS.
   
   HIDE FRAME FrameNavegIDWMS NO-PAUSE.
   
   RUN retornaEnderecoBox2 IN wgbosc030 (INPUT ttWork.cod-estabel,  
                                         INPUT ttWork.cod-local,    
                                         INPUT vCodBloco,          
                                         INPUT vCodRua,            
                                         INPUT vCodNivel,          
                                         INPUT vCodColuna,
                                         OUTPUT ttWork.num-box-orig).        
   IF ttWork.num-box-orig = 0 THEN DO ON ENDKEY UNDO,RETRY:
      {bcp/bc9105.i "159" "BOX n∆o encontrado para a coordenada informada.(bc9025)"}
   END.
   ELSE
      ASSIGN ttWork.num-box-orig:SCREEN-VALUE IN FRAME Frame01 = string(ttWork.num-box-orig).
END PROCEDURE.
