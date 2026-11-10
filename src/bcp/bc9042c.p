/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9042C 2.00.00.005 } /*** "010005" 23/07/2024 13:43:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9042c MBC}
&ENDIF



{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9042.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Setembro/2009 - Lilian - Cria‡Æo do programa                **
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
    
DEFINE TEMP-TABLE tt-etiq-packing NO-UNDO LIKE wms-etiq-packing.

DEFINE INPUT PARAM pcod-coletor     AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM pcod-equipamento AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM p-cod-usuario    AS CHARACTER  NO-UNDO.
DEFINE INPUT PARAM TABLE FOR tt-etiq-packing.

/* Definicao global do nome da transacao */
&global-define ProgramName BC9042
&global-define TempTable tt-armazena-packing
{bcp/bc9042.i " "}
{utp/utapi009.i} /* login */
{utp/ut-glob.i}                
{bcp/bc9015.i3}  /* def variaveis padroes */
{method/dbotterr.i}

DEFINE TEMP-TABLE ttwm-etiqueta    NO-UNDO LIKE wm-etiqueta.
DEFINE TEMP-TABLE ttwms-box-espera NO-UNDO LIKE wms-box-espera
    FIELD r-Rowid AS ROWID.

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
ASSIGN ttWork.cod-usuario        = p-cod-usuario
       ttWork.cod-coletor        = pcod-coletor
       ttWork.cod-equipamento    = pcod-equipamento.

DEFINE TEMP-TABLE tt-packing-end-espera NO-UNDO
    FIELD id-packing       LIKE wms-box-packing.val-etiq-packing
    FIELD id-endereco      LIKE wms-box-packing.id-box
    FIELD bloco            LIKE wms-box-espera.cod-bloco
    FIELD rua              LIKE wms-box-espera.cod-rua
    FIELD nivel            LIKE wms-box-espera.cod-nivel
    FIELD coluna           LIKE wms-box-espera.cod-coluna
    FIELD posicao-end      LIKE wms-box-espera.ind-posicao-box
    FIELD dt-armaz         LIKE wms-box-packing.dat-armaz
    FIELD hr-armaz         LIKE wms-box-packing.num-hora-armaz
    FIELD usuario-armaz    LIKE wms-box-packing.cod-usuar-armaz
    FIELD dt-retir         LIKE wms-box-packing.dat-retir
    FIELD hr-retir         LIKE wms-box-packing.num-hora-retir
    FIELD usuario-retir    LIKE wms-box-packing.cod-usuar-retir
    FIELD situacao         LIKE wms-box-packing.idi-sit-packing.

/* Variaveis de trabalho */              
DEFINE VARIABLE vLogOk            AS LOGICAL   INITIAL NO         NO-UNDO.
DEFINE VARIABLE vEndereco         AS CHAR      FORMAT 'x(17)':U   NO-UNDO.
DEFINE VARIABLE v-pos-box         AS CHAR                         NO-UNDO.
DEFINE VARIABLE vNumCont          AS INTEGER   INITIAL 0          NO-UNDO.
DEFINE VARIABLE c-mensagem        AS CHARACTER                    NO-UNDO.
DEFINE VARIABLE vNomeUsuario      AS CHARACTER                    NO-UNDO.

DEFINE NEW SHARED VARIABLE wgbosc169 AS WIDGET-HANDLE NO-UNDO.    
DEFINE NEW SHARED VARIABLE wgbosc168 AS WIDGET-HANDLE NO-UNDO.    

/* Propriedades globais para frames */              
&global-define ErrorDisplaySeconds 3
&global-define FrameSize    20 By 8

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Local Armazenamento '                             At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'End.:'                                            AT ROW 03 COL 01          ~
                             ttwork.num-box                                     At Row 03 Col 06 NO-LABEL ~
                             vEndereco                                          At Row 04 Col 01 NO-LABEL
&global-define Frame01Repeat NO
&global-define Update01Fields     ~
               ttWork.num-box

/* Definicao das trigger de interacao com a tela */ 
&global-define TriggerBeforeFrame01 RUN InicializaCamposFrame01.
&global-define TriggerAfterFrame01  RUN GravaCamposFrame01.  IF vLogFinaliza = YES THEN DO:         ~
                                                               ASSIGN vLogSai        = YES          ~
                                                                      ttWork.num-box = 0            ~
                                                                      ttWork.num-box:SCREEN-VALUE IN FRAME Frame01  = '0'.  ~
                                                            END.
/* Definicao das trigger de usuario  */ 
&global-define UserTriggers                                                                     ~
                            ON 'ESC':U OF Frame Frame01                                         ~
                            DO:                                                                 ~
                               HIDE ALL.                                                        ~
                            END.                                                                ~
                            ON 'leave':U OF ttwork.num-box IN Frame Frame01                   ~
                            DO:                                                               ~
                                ASSIGN INPUT FRAME Frame01 ttwork.num-box.                     ~
                                FIND FIRST tt-etiq-packing NO-LOCK NO-ERROR.                             ~
                                IF AVAIL tt-etiq-packing THEN DO:                                        ~
                                    RUN setConstraintEstabelLocalIdBox2  IN wgbosc168 (INPUT tt-etiq-packing.cod-estabel, ~
                                                                                       INPUT tt-etiq-packing.cod-local,   ~
                                                                                       INPUT ttWork.num-box,              ~
                                                                                       INPUT ttWork.num-box).             ~
                                    RUN openQueryStatic     IN wgbosc168 (INPUT 'EstabelLocalIdBox2':U).                  ~
                                    RUN getBatchRecords     IN wgbosc168 (INPUT  ?,                          ~
                                                                          INPUT  NO,                         ~
                                                                          INPUT  ?,                          ~
                                                                          OUTPUT vNumCont,                   ~
                                                                          OUTPUT TABLE ttwms-box-espera).            ~
                                    FIND FIRST ttwms-box-espera NO-ERROR.                                            ~
                                    IF AVAIL ttwms-box-espera THEN DO:                                               ~
                                        IF ttwms-box-espera.log-bloq-armaz <> YES THEN DO:                           ~
                                            IF ttwms-box-espera.ind-posicao-box = 1 THEN                                 ~
                                                ASSIGN v-pos-box = "E".                                          ~
                                            ELSE                                                                 ~
                                                ASSIGN v-pos-box = "D".                                          ~
                                            ASSIGN vEndereco = ttwms-box-espera.cod-bloco  + "/":U +                     ~
                                                               ttwms-box-espera.cod-rua    + "/":U +                     ~
                                                               ttwms-box-espera.cod-nivel  + "/":U +                     ~
                                                               ttwms-box-espera.cod-coluna + "/":U +                     ~
                                                               v-pos-box.                                        ~
                                            DISP vEndereco WITH FRAME frame01.                                   ~
                                        END.                                                                     ~
                                    END.                                                                     ~
                                END.                                                                         ~
                            END.                                                                             ~


/* Definicao dos objetos ativos */ 
&global-define ActiveObject1 wgbosc169
&global-define ActiveObject2 wgbosc168

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

                                /************************************* Codigo do Usuario Inicio ************************************
** Este local ² destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   IF vLogSai  THEN DO:
      ASSIGN vLogSai      = YES      
             vLogFinaliza = YES.
      HIDE ALL NO-PAUSE.
      RETURN RETURN-VALUE.
   END.

   ASSIGN vLogErro  = NO.

   IF NOT VALID-HANDLE(wgbosc168)  THEN DO:
      RUN scbo/bosc168.p PERSISTENT SET wgbosc168.
      RUN openQueryStatic In wgbosc168 (INPUT "Main":U) No-error. 
   END.        
    
   IF NOT VALID-HANDLE(wgbosc169)  THEN DO:
      RUN scbo/bosc169.p PERSISTENT SET wgbosc169.
      RUN openQueryStatic IN wgbosc169 (INPUT "Main":U) NO-ERROR. 
   END.                               
    
   ASSIGN ttWork.num-box = 0
          vEndereco      = "".
          
   FOR EACH tt-etiq-packing NO-LOCK:
      EMPTY TEMP-TABLE tt-packing-end-espera. 
      RUN getPackingPedido IN wgbosc169(INPUT tt-etiq-packing.cod-estabel, 
                                        INPUT tt-etiq-packing.cod-local,   
                                        INPUT tt-etiq-packing.cdd-embarq,
                                        INPUT tt-etiq-packing.nr-resumo,
                                        INPUT tt-etiq-packing.nr-pedcli,
                                        INPUT tt-etiq-packing.nome-abrev, 
                                        OUTPUT TABLE tt-packing-end-espera). 
      FIND FIRST tt-packing-end-espera NO-LOCK NO-ERROR.
      IF AVAIL tt-packing-end-espera THEN DO:
         ASSIGN ttWork.num-box = tt-packing-end-espera.id-endereco.
         RUN setConstraintEstabelLocalIdBox2  IN wgbosc168 (INPUT tt-etiq-packing.cod-estabel,
                                                            INPUT tt-etiq-packing.cod-local,
                                                            INPUT ttWork.num-box,
                                                            INPUT ttWork.num-box).
         RUN openQueryStatic IN wgbosc168 (INPUT 'EstabelLocalIdBox2':U).
         RUN getBatchRecords IN wgbosc168 (INPUT  ?,
                                           INPUT  NO,
                                           INPUT  ?,
                                           OUTPUT vNumCont,
                                           OUTPUT TABLE ttwms-box-espera).
         FIND FIRST ttwms-box-espera NO-ERROR.
         IF AVAIL ttwms-box-espera THEN DO:
            IF ttwms-box-espera.log-bloq-armaz <> YES THEN DO:
               IF ttwms-box-espera.ind-posicao-box = 1 THEN                     
                  ASSIGN v-pos-box = "E".                              
               ELSE                                                     
                  ASSIGN v-pos-box = "D".
                                                
               ASSIGN vEndereco = ttwms-box-espera.cod-bloco  + "/":U +         
                                  ttwms-box-espera.cod-rua    + "/":U +         
                                  ttwms-box-espera.cod-nivel  + "/":U +         
                                  ttwms-box-espera.cod-coluna + "/":U +         
                                  v-pos-box.                            
            END.
         END.
         LEAVE.
      END.                                   
   END.

   DISP ttWork.num-box
        vEndereco
      WITH FRAME Frame01.
    
   APPLY 'leave':U TO ttWork.num-box IN FRAME Frame01. 
END PROCEDURE.

PROCEDURE GravaCamposFrame01:
   ASSIGN vLogErro = NO 
          vLogOk   = NO 
          vLogFinaliza = NO
          vLogSai      = NO
          INPUT FRAME Frame01 ttWork.num-box
                               vEndereco.
   FIND FIRST tt-etiq-packing NO-LOCK NO-ERROR.
   IF AVAIL tt-etiq-packing THEN DO:
      /*Valida Endere‡o*/
      RUN setConstraintEstabelLocalIdBox2  IN wgbosc168 (INPUT tt-etiq-packing.cod-estabel,
                                                         INPUT tt-etiq-packing.cod-local,
                                                         INPUT ttWork.num-box,
                                                         INPUT ttWork.num-box).
      RUN openQueryStatic     IN wgbosc168 (INPUT 'EstabelLocalIdBox2':U).
      RUN getBatchRecords     IN wgbosc168 (INPUT  ?,
                                            INPUT  NO,
                                            INPUT  ?,
                                            OUTPUT vNumCont,
                                            OUTPUT TABLE ttwms-box-espera).
      FIND FIRST ttwms-box-espera NO-ERROR.
      IF AVAIL ttwms-box-espera THEN DO:
         IF ttwms-box-espera.log-bloq-armaz = YES THEN DO:
            ASSIGN vLogErro = YES.
            {bcp/bc9105.i "301" "Endere‡o Bloqueado para Armazenamento. (WMS)"}
            RETURN ERROR.
         END.

         IF ttwms-box-espera.ind-posicao-box = 1 THEN                     
            ASSIGN v-pos-box = "E".                              
         ELSE                                                     
            ASSIGN v-pos-box = "D".
                                          
         ASSIGN vEndereco = ttwms-box-espera.cod-bloco  + "/":U +         
                            ttwms-box-espera.cod-rua    + "/":U +         
                            ttwms-box-espera.cod-nivel  + "/":U +         
                            ttwms-box-espera.cod-coluna + "/":U +         
                            v-pos-box.                            
      END.
      ELSE DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Endere‡o Inv lido. (WMS)"}
         RETURN ERROR.
      END.
      
      DISP vEndereco
         WITH FRAME frame01.    
        
      PAUSE 2 NO-MESSAGE.
        
      FOR EACH tt-etiq-packing NO-LOCK:
         EMPTY TEMP-TABLE tt-armazena-packing. 
         CREATE tt-armazena-packing.
         ASSIGN tt-armazena-packing.cod-usuario      = ttWork.cod-usuario     
                tt-armazena-packing.cod-coletor      = ttWork.cod-coletor     
                tt-armazena-packing.cod-equipamento  = ttWork.cod-equipamento 
                tt-armazena-packing.num-serial       = tt-etiq-packing.val-etiq-packing
                tt-armazena-packing.num-box          = ttWork.num-box
                tt-armazena-packing.cod-estabel      = tt-etiq-packing.cod-estabel 
                tt-armazena-packing.cod-local        = tt-etiq-packing.cod-local   
                tt-armazena-packing.cdd-embarq       = tt-etiq-packing.cdd-embarq
                tt-armazena-packing.nr-resumo        = tt-etiq-packing.nr-resumo
                tt-armazena-packing.nr-pedcli        = tt-etiq-packing.nr-pedcli
                tt-armazena-packing.nome-abrev       = tt-etiq-packing.nome-abrev.
         RUN GravaTransacao.
      END.
   END.
   ASSIGN vLogFinaliza = YES.

END PROCEDURE.

PROCEDURE GravaTransacao:
   ASSIGN vTransDetail = VTransaction   +
                         " Serial: "     +  STRING({&TempTable}.num-serial) + 
                         " idBox: "      +  STRING({&TempTable}.num-box).

   RUN _RetornaUsuario (OUTPUT vNomeUsuario).

   ASSIGN {&TempTable}.dat-atualizacao         = TODAY 
          {&TempTable}.dat-transacao           = TODAY 
          {&TempTable}.cod-usuario             = vNomeUsuario.

   RAW-TRANSFER {&TempTable} TO vConteudoRaw.

   EMPTY TEMP-TABLE tt-erro-after-GenerateDC.
    
   RUN _GenerateDCTransaction (INPUT vTransaction,            /* Codigo da Transacao                   */
                               INPUT vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                               INPUT vTransDetail,            /* Cabecalho de detalhes da transacao    */
                               INPUT vNomeUsuario).           /* Usuario responsavel pela transacao    */

   FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.

   IF AVAIL tt-erro-after-GenerateDC THEN DO:
      RUN bcp/bc9115.p (tt-erro-after-GenerateDC.cd-erro,tt-erro-after-GenerateDC.mensagem,8,20,3).
      HIDE ALL.
   END.
   ELSE DO:
      ASSIGN c-mensagem = "Armazenamento da etiqueta: " + STRING({&TempTable}.num-serial) + " efetuado com sucesso".
      RUN bcp/bc9115.p ("0", c-mensagem,8,20,3).
      HIDE ALL.
   END.  
END  PROCEDURE.

