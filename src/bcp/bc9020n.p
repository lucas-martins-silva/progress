/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9020N 2.00.00.004 } /*** "010004" 13/11/2023 10:17:02  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9020 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-ressup-wms.                                                      **
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

DEFINE INPUT  PARAMETER pCod-usuario              AS CHARACTER   NO-UNDO.
DEFINE INPUT  PARAMETER pCod-coletor              AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pCod-equipamento          AS INTEGER     NO-UNDO.
DEFINE INPUT  PARAMETER pRowid-tarefa-docto-itens AS ROWID       NO-UNDO.
DEFINE OUTPUT PARAMETER pLogEsc                   AS LOGICAL     NO-UNDO.

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9020
/************************************************************/

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-ressup-wms
{bcp/bc9020.i " "}
{bcp/bc9020.i1 "New"}

CREATE ttWork.
ASSIGN ttWork.cod-usuario     = pCod-usuario
       ttWork.cod-coletor     = STRING(pCod-coletor)
       ttWork.cod-equipamento = STRING(pCod-equipamento).

DEFINE TEMP-TABLE tt-mostra-locais NO-UNDO
            FIELD num-seq           AS INTEGER
            FIELD des-local         AS CHARACTER FORMAT 'X(19)'
            FIELD rowid-box-movto   AS ROWID
            INDEX ID num-seq.

DEFINE QUERY qry-wm-box-movto FOR tt-mostra-locais.

DEFINE BROWSE brw-wm-box-movto QUERY qry-wm-box-movto NO-LOCK
         DISPLAY tt-mostra-locais.des-local
            WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

DEFINE VARIABLE vCodItemCorrente        AS CHARACTER FORMAT 'x(16)':U   INIT ''  NO-UNDO.
DEFINE VARIABLE vDesItemCorrente        AS CHARACTER FORMAT 'x(18)':U   INIT ''  NO-UNDO.
DEFINE VARIABLE vLogEmProcesso          AS LOGICAL                      INIT NO  NO-UNDO.

DEFINE NEW SHARED VARIABLE vLogControla       AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vLogEmProcesso-aux AS LOGICAL                INIT NO  NO-UNDO.
DEFINE NEW SHARED VARIABLE vEsc               AS LOGICAL                INIT NO  NO-UNDO.


DEFINE VARIABLE vLogUtilizaColetor      AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAprovaFatura        AS LOGICAL                      INIT NO  NO-UNDO.
DEFINE VARIABLE vLogControlaLogin       AS LOGICAL                      INIT NO  NO-UNDO.

DEFINE VARIABLE vCodSenha AS CHARACTER FORMAT 'x(12)':U NO-UNDO.

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Ressuprimento WMS'                                At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             vCodItemCorrente                                   At Row 07 Col 01 No-label ~
                             vDesItemCorrente                                   At Row 08 Col 01 No-label ~
&global-define Frame01Repeat NO

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update03Fields brw-wm-box-movto

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame01Name}                       ~
                            DO:                                                                                    ~
                                Apply 'Go':U To This-procedure.                                                    ~
                            END.                                                                                   ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame01Name}                       ~
                            DO:                                                                                    ~
                                Find ttwm-box-movto                                                                ~
                                    Where ttWm-box-movto.r-rowid = tt-mostra-locais.rowid-box-movto                ~
                                           No-error.                                                               ~
                                If  Not Available ttwm-box-movto Then DO:                                          ~
                                    ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame01 = ""                     ~
                                           vDesItemCorrente:SCREEN-VALUE IN FRAME frame01 = "".                    ~
                                    Return No-apply.                                                               ~
                                END.                                                                               ~
                                Run getInfoDoctoItens IN wgbosc096 (Input ttwm-box-movto.cod-estabel,              ~
                                                                    Input ttwm-box-movto.cod-local,                ~
                                                                    Input ttwm-box-movto.id-docto,                 ~
                                                                    Input ttwm-box-movto.num-seq-item,             ~
                                                                    Output Table ttwm-docto-itens ).               ~
                                Find First ttwm-docto-itens.                                                       ~
                                ASSIGN vCodItemCorrente:SCREEN-VALUE IN FRAME Frame01 = ttwm-docto-itens.cod-item. ~
                                RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).                                 ~
                                RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item).                        ~
                                IF RETURN-VALUE = "OK":U THEN DO:                                                  ~
                                   RUN getCharField IN wgbosc044 (INPUT "des-item":U,                              ~
                                                                  OUTPUT vDesItemCorrente).                        ~
                                   ASSIGN vDesItemCorrente:SCREEN-VALUE IN FRAME Frame01 = vDesItemCorrente.       ~
                                END.                                                                               ~
                                ELSE                                                                               ~
                                   ASSIGN vDesItemCorrente:SCREEN-VALUE IN FRAME Frame01 = "".                     ~
                            END.                                                                                   ~
                            ON 'ESC':U OF FRAME {&Frame01Name}                                                     ~
                            DO:                                                                                    ~
                                ASSIGN pLogEsc = YES.                                                              ~
                            END.

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc032
&global-define ActiveObject3 wgbosc038
&global-define ActiveObject4 wgbosc044
&global-define ActiveObject5 wgbosc074
&global-define ActiveObject6 wgbosc096
&global-define ActiveObject6 wgbosc098
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                            **
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

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame01:
   ASSIGN vLogErro    = NO
          vLogCancela = NO.
   
   IF NOT VALID-HANDLE(wgbosc030) THEN DO:
      RUN scbo/bosc030.p PERSISTENT SET wgbosc030      NO-ERROR.
      RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc032) THEN DO:
      RUN scbo/bosc032.p PERSISTENT SET wgbosc032 NO-ERROR.
      RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc038) THEN DO:
      RUN scbo/bosc038.p PERSISTENT SET wgbosc038 NO-ERROR.
      RUN openQueryStatic IN wgbosc038 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc074) THEN DO:
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074 NO-ERROR.
      RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc096) THEN DO:
      RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
      RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.
   END.
   
   IF NOT VALID-HANDLE(wgbosc098) THEN DO:
      RUN scbo/bosc098.p PERSISTENT SET wgbosc098 NO-ERROR.
      RUN openQueryStatic IN wgbosc098 (INPUT "Main":U) NO-ERROR.
   END.
   
   EMPTY TEMP-TABLE ttWm-box-movto.
   
   RUN getTarefaRessupConvoc IN wgbosc096 (INPUT pCod-equipamento,
                                           INPUT pRowid-tarefa-docto-itens,
                                           OUTPUT TABLE ttWm-box-movto).
   
   IF vLogErro = YES THEN
      RETURN ERROR.
   
   EMPTY TEMP-TABLE tt-mostra-locais.
   
   ASSIGN vNumSeq = 0.
   
   wm-boxm:
   FOR EACH ttwm-box-movto
      WHERE ttwm-box-movto.ind-tipo-movto = 2
         BY ttwm-box-movto.val-prioridade:
   
      /* Pegar Informacoes Box */
      RUN SetConstraintBoxes IN wgbosc030 (INPUT ttwm-box-movto.cod-estabel,
                                           INPUT ttwm-box-movto.cod-local,
                                           INPUT ttwm-box-movto.id-box,
                                           INPUT ttwm-box-movto.id-box).
   
      RUN openQueryStatic IN wgbosc030 (INPUT 'Boxes':U).
   
      RUN getBatchRecords IN wgbosc030 (INPUT ?,
                                        INPUT NO,
                                        INPUT ?,
                                        OUTPUT vNumCont,
                                        OUTPUT TABLE ttwm-box).
   
      FIND FIRST ttwm-box NO-ERROR.
      IF NOT AVAIL ttwm-box THEN
         NEXT wm-boxm.
   
      ASSIGN vNumSeq = vNumSeq + 1.
   
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq         = vNumSeq
             tt-mostra-locais.des-local       = ttwm-box.cod-bloco            + '/':U +
                                                ttwm-box.cod-rua              + '/':U +
                                                ttwm-box.cod-nivel            + '/':U +
                                                ttwm-box.cod-coluna           + '/':U +
                                                IF ttwm-box.ind-posicao-box = 1 THEN 'E' ELSE 'D'
             tt-mostra-locais.rowid-box-movto = ttwm-box-movto.r-rowid.
   END.
   
   FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-mostra-locais THEN DO:
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq   = 999
             tt-mostra-locais.des-local = 'Sem tarefas ou Equipamento sem acesso (WMS).'.
   END.
   
   OPEN QUERY qry-wm-box-movto
     FOR EACH tt-mostra-locais
           BY tt-mostra-locais.num-seq
           BY tt-mostra-locais.des-local.
   
   APPLY 'VALUE-CHANGED':U TO brw-wm-box-movto IN FRAME {&Frame01Name}.
END PROCEDURE.


/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:    
   ASSIGN vLogErro = NO.
   
   IF NOT AVAIL ttwm-box-movto THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movto Invalido. (WMS)"}
      RETURN ERROR.
   END.
   
   RUN getInfoDoctoItens IN wgbosc096 (INPUT ttwm-box-movto.cod-estabel, 
                                       INPUT ttwm-box-movto.cod-local,   
                                       INPUT ttwm-box-movto.id-docto,    
                                       INPUT ttwm-box-movto.num-seq-item, 
                                       OUTPUT TABLE ttwm-docto-itens). 
   FIND FIRST ttwm-docto-itens NO-ERROR.
   
   IF vLogEmProcesso = NO THEN DO:
      RUN inicializaTarefaMovtoOK IN wgbosc096 (INPUT ttwm-box-movto.id-docto,
                                                INPUT 04,     
                                                INPUT ttWork.cod-usuario,              
                                                INPUT ttWork.cod-equipamento,          
                                                INPUT ttWork.cod-coletor,              
                                                INPUT ttwm-box-movto.id-movto,         
                                                INPUT ttwm-box-movto.num-seq-item).
   
      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Tarefa J  Iniciada. (WMS)"}
         RETURN ERROR.
      END.
      ASSIGN vLogEmProcesso = YES.
   END.
   
   ASSIGN ttwork.num-tempo-inicio = TIME
          ttwork.des-seriais = "".
   
   FIND FIRST ttWork NO-ERROR.
   
   HIDE ALL.
   RUN bcp/bc9020f.p (INPUT ROWID(ttwm-box-movto)).
   FIND FIRST ttWork NO-ERROR.
   HIDE ALL.
   
   IF RETURN-VALUE <> "OK":U THEN DO:
      /* Reinicia a tarefa */
      RUN inicializaTarefaMovtoNOK IN wgbosc096 (INPUT ttwm-box-movto.id-docto,
                                                 INPUT 04,
                                                 INPUT ttWork.cod-usuario,
                                                 INPUT ttWork.cod-equipamento,
                                                 INPUT ttWork.cod-coletor,
                                                 INPUT ttwm-box-movto.id-movto,
                                                 INPUT ttwm-box-movto.num-seq-item).
   
      ASSIGN pLogEsc = YES.
   END.
   
   ASSIGN vLogFinaliza = YES
          vLogSai      = YES.
   
   RETURN RETURN-VALUE.
END PROCEDURE.
