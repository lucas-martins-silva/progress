/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024G 2.00.00.038 } /*** "010038" 25/09/2023 15:37:56  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9024g MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
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
**                        Ex: &global-define ActiveObject wgBOSC074                               **
***************************************************************************************************/

/* Definicao global do nome da transacao ---                */
&global-define ProgramName BC9024
/************************************************************/


/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i }
    
DEFINE TEMP-TABLE ttWork            NO-UNDO LIKE {&TempTable}.
DEFINE TEMP-TABLE ttWm-etiqueta-aux NO-UNDO LIKE wm-etiqueta.

DEFINE INPUT PARAMETER pDesEndereco AS CHARACTER FORMAT "x(11)" NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-inventario-wms-bkp.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttWork.

DEF VAR tempoespera         AS INTEGER                            NO-UNDO.
DEF VAR vSerialSeq          LIKE tt-inventario-wms-bkp.num-serial NO-UNDO.
DEF VAR vQtdItens           AS INTEGER   INIT 0                   NO-UNDO.
DEF VAR cDescriptionError   AS CHARACTER                          NO-UNDO.
DEF VAR c-embalagem         AS CHARACTER                          NO-UNDO.
DEF VAR i-num-seq-item      LIKE wm-inventario-item.num-seq-item  NO-UNDO.

FIND FIRST ttWork NO-ERROR.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Ser:'                   At Row 01 Col 01                          ~
                             ttWork.num-Serial        At Row 01 Col 05 No-label                 ~
                             'Legenda Serial:   '     AT ROW 02 COL 01                          ~
                             '444444 -Coletadas '     AT ROW 03 COL 01                          ~
                             '555555 -End. Vazio'     AT ROW 04 COL 01                          ~
                             '999999 -Encerra   '     AT ROW 05 COL 01                          ~
                             'End:'                   At Row 06 Col 01                          ~
                             pDesEndereco             At Row 07 Col 01 No-label Format "x(17)"  ~
                             'Lidos:'                 At Row 08 Col 01                          ~
                             vQtdItens                At Row 08 Col 07 No-label Format '>>>>9'

&global-define Frame01Repeat Yes  
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-Serial
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogSai = Yes Then do: ~
                                                               LEAVE _frame01. ~
                                                            END.

/* definicao da trigger de procedimentos para fechamento do programa */
&global-define TriggersCloseProgram Run destroy In wgbosc119   No-error. ~
                                    Run destroy In wgbosc120   No-error. ~
                                    Run destroy In wgbc9024j   No-error. ~
                                    Run destroy In wgbosc074   No-error. ~
                                    Run destroy In wgbcapi001  No-error. ~
                                    Run destroy In wgbosc130   No-error.


/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc119
&global-define ActiveObject2 wgbosc120
&global-define ActiveObject3 wgbosc130
&global-define ActiveObject4 wgbc9024j
&global-define ActiveObject5 wgbosc074   /* wg originado pelo bc9024j */
&global-define ActiveObject6 wgbcapi001
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
 {bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
 {bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
 
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 2
&global-define MessageBell YES
/****************************************************************************************/

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
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.
   
   ASSIGN ttWork.num-serial    = 0
          ttWork.cod-lote      = ''
          ttWork.cod-refer     = ''
          ttWork.cod-item      = ''
          ttWork.cod-embalagem = ''
          ttWork.qtd-item      = 0
          ttWork.qtd-peso      = 0
          ttWork.dat-validade  = TODAY
          ttWork.ind-transacao = 2.
   
   
   FIND LAST tt-inventario-wms-bkp USE-INDEX id-seq NO-LOCK NO-ERROR.   
   IF AVAILABLE tt-inventario-wms-bkp THEN
      ASSIGN vQtdItens = tt-inventario-wms-bkp.num-sequencia.
   
   DISP ttWork.num-serial 
        pDesEndereco
        vQtdItens
      WITH FRAME frame01.
END PROCEDURE.

PROCEDURE GravaCamposFrame01:
/*------------------------------------------------------------------------------
  Purpose: Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.

   /* ind-transacao:
      1 = Item sem validar quantidade
      2 = Item com quantidade
      3 = Erro
      4 = Item sem etiqueta com quantidade
      8 = Processando
      9 = Finaliza */
   ASSIGN vLogErro     = NO
          vLogSai      = NO
          vLogFinaliza = NO.
    
   IF ttWork.num-serial = 0 THEN DO:
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "101" "Serial Inv lido (DC)"}
      
      VIEW FRAME {&Frame01Name}.
      PAUSE 0 NO-MESSAGE.
      RETURN ERROR.
   END.
    
   FIND FIRST wm-param NO-LOCK NO-ERROR.
   IF ttWork.num-serial = 444444 THEN DO:
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.
       
      RUN bcp/bc9024k.p(INPUT TABLE ttWork).

      HIDE ALL.
      VIEW FRAME frame01.
      PAUSE 0 NO-MESSAGE.
      
      RETURN.
   END.
   
   IF ttWork.num-serial = 999999
      AND (NOT wm-param.log-encerra-contag-sdo
       OR (wm-param.log-encerra-contag-sdo AND ttWork.num-contagem = 1)) THEN DO:
      IF NOT CAN-FIND ( FIRST tt-inventario-wms-bkp
                        WHERE tt-inventario-wms-bkp.cod-estabel    = ttWork.cod-estabel
                          AND tt-inventario-wms-bkp.cod-local      = ttWork.cod-local
                          AND tt-inventario-wms-bkp.dat-inventario = ttWork.dat-inventario
                          AND tt-inventario-wms-bkp.num-contagem   = ttWork.num-contagem
                          AND tt-inventario-wms-bkp.num-seq-invent = ttWork.num-seq-invent
                          AND tt-inventario-wms-bkp.num-box        = ttWork.num-box
                          AND tt-inventario-wms-bkp.qtd-item       <> 0 NO-LOCK) THEN DO:
         {bcp/bc9105.i "57355" "NÆo pode ser encerrado um endere‡o sem leituras (WMS)"} 
         ASSIGN vLogErro = YES.                                                                                   
         RETURN ERROR.
      END.
   END.
   
   IF ttWork.num-serial = 999999 AND wm-param.log-encerra-contag-sdo THEN DO:
      IF NOT CAN-FIND ( FIRST tt-inventario-wms-bkp
                        WHERE tt-inventario-wms-bkp.cod-estabel    = ttWork.cod-estabel
                          AND tt-inventario-wms-bkp.cod-local      = ttWork.cod-local
                          AND tt-inventario-wms-bkp.dat-inventario = ttWork.dat-inventario
                          AND tt-inventario-wms-bkp.num-contagem   = ttWork.num-contagem
                          AND tt-inventario-wms-bkp.num-seq-invent = ttWork.num-seq-invent
                          AND tt-inventario-wms-bkp.num-box        = ttWork.num-box
                          AND tt-inventario-wms-bkp.qtd-item       <> 0 NO-LOCK) THEN DO:
   
         HIDE ALL.
         PAUSE 0 NO-MESSAGE.
         HIDE FRAME frame01.
         PAUSE 0 NO-MESSAGE.
   
         ASSIGN vLogOk = YES.
       
         /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
         DEFINE VARIABLE c-lbl-liter-inventario-wms-1 AS CHARACTER FORMAT "X(18)" NO-UNDO.
         {utp/ut-liter.i "Invent rio_WMS" *}
         ASSIGN c-lbl-liter-inventario-wms-1 = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-contagem-endereco AS CHARACTER FORMAT "X(18)" NO-UNDO.
         {utp/ut-liter.i "Contagem_Endere‡o" *}
         ASSIGN c-lbl-liter-contagem-endereco = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-sem-leituras AS CHARACTER FORMAT "X(18)" NO-UNDO.
         {utp/ut-liter.i "Sem_Leituras!" *}
         ASSIGN c-lbl-liter-sem-leituras = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-deseja-encerrar AS CHARACTER FORMAT "X(18)" NO-UNDO.
         {utp/ut-liter.i "Deseja_Encerrar?" *}
         ASSIGN c-lbl-liter-deseja-encerrar = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-1sim-2nao-1 AS CHARACTER FORMAT "X(11)" NO-UNDO.
         {utp/ut-liter.i "1=Sim_2=NÆo" *}
         ASSIGN c-lbl-liter-1sim-2nao-1 = TRIM(RETURN-VALUE).
         
         DISP c-lbl-liter-inventario-wms-1     AT ROW 01 COL 01 NO-LABEL
              '----------------'               AT ROW 02 COL 01 
              c-lbl-liter-contagem-endereco    AT ROW 03 COL 01 NO-LABEL
              c-lbl-liter-sem-leituras         AT ROW 04 COL 01 NO-LABEL
              c-lbl-liter-deseja-encerrar      AT ROW 05 COL 01 NO-LABEL
              c-lbl-liter-1sim-2nao-1          AT ROW 07 COL 01 NO-LABEL
            WITH FRAME f-conf-1 FONT 2 SIZE 20 BY 8 NO-BOX.
         
         PAUSE 0 NO-MESSAGE.
         UPDATE vLogOk AT ROW 07 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf-1 FONT 2 SIZE 20 BY 8.
       
         HIDE ALL.
         PAUSE 0 NO-MESSAGE.
       
         IF NOT vLogOk THEN DO:
            VIEW FRAME frame01.
            PAUSE 0 NO-MESSAGE.
            ASSIGN vLogErro = YES.
            RETURN ERROR.
         END.
         
         /* Considera encerramento de contagem vazia dos itens em processo */
         ASSIGN ttWork.ind-transacao = 6
                ttWork.num-serial    = 333333.
                 
         RUN GravaTransacao.
         ASSIGN vLogSai      = YES
                vLogFinaliza = YES.
         RETURN.          
      END.
   END.
        
   IF ttWork.num-serial = 999999 THEN DO:
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.
       
      ASSIGN vLogOk = YES.
      
      /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
      DEFINE VARIABLE c-lbl-liter-inventario-wms AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Invent rio_WMS" *}
      ASSIGN c-lbl-liter-inventario-wms = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-encerra-inventario AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Encerra_Invent rio" *}      
      ASSIGN c-lbl-liter-encerra-inventario = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-do-box AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "do_Box?" *}
      ASSIGN c-lbl-liter-do-box = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(11)" NO-UNDO.
      {utp/ut-liter.i "1=Sim_2=NÆo" *}
      ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-inventario-wms       AT ROW 01 COL 01 NO-LABEL
           '----------------'               AT ROW 02 COL 01 
           c-lbl-liter-encerra-inventario   AT ROW 03 COL 01 NO-LABEL
           c-lbl-liter-do-box               AT ROW 04 COL 01 NO-LABEL
           c-lbl-liter-1sim-2nao            AT ROW 07 COL 01 NO-LABEL
         WITH FRAME f-conf FONT 2 SIZE 20 BY 8 NO-BOX.
      
      PAUSE 0 NO-MESSAGE.
      UPDATE vLogOk AT ROW 07 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf FONT 2 SIZE 20 BY 8.
              
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
       
      IF NOT vLogOk THEN DO:
         VIEW FRAME frame01.
         PAUSE 0 NO-MESSAGE.
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.

      ASSIGN ttWork.ind-transacao = 8. 
      RUN GravaTransacao.
      ASSIGN vLogSai      = YES
             vLogFinaliza = YES.
      RETURN.
   END.

   IF ttWork.num-serial = 555555 THEN DO:
      IF ttWork.log-existe-end = NO THEN DO: /* regra definida em 13/02/03 por Log¡stica: Se est  informando um endere‡o fora do invent rio, nÆo dever  deixar informar que est  vazio. */
         {bcp/bc9105.i "300" "NÆo poder  ser informado Box Vazio para endere‡o nÆo gerado pelo invent rio (WMS)"}
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.

      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.
       
      ASSIGN vLogOk = YES.
        
      /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
      DEFINE VARIABLE c-lbl-liter-inventario-wms-2 AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Invent rio_WMS" *}
      ASSIGN c-lbl-liter-inventario-wms-2 = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-confirma-box AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Confirma_Box" *}
      ASSIGN c-lbl-liter-confirma-box = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-vazio AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Vazio_?" *}
      ASSIGN c-lbl-liter-vazio = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-1sim-2nao-2 AS CHARACTER FORMAT "X(11)" NO-UNDO.
      {utp/ut-liter.i "1=Sim_2=NÆo" *}
      ASSIGN c-lbl-liter-1sim-2nao-2 = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-inventario-wms-2   AT ROW 01 COL 01 NO-LABEL
           '------------------'           AT ROW 02 COL 01 
           c-lbl-liter-confirma-box       AT ROW 03 COL 01 NO-LABEL
           c-lbl-liter-vazio              AT ROW 04 COL 01 NO-LABEL
           c-lbl-liter-1sim-2nao-2        AT ROW 07 COL 01 NO-LABEL
         WITH FRAME f-conf-2 FONT 2 SIZE 20 BY 8 NO-BOX.
      
      PAUSE 0 NO-MESSAGE.
      UPDATE vLogOk AT ROW 07 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf-2 FONT 2 SIZE 20 BY 8.
      
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      
      IF NOT vLogOk THEN DO:
         VIEW FRAME frame01.
         PAUSE 0 NO-MESSAGE.
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
      
      ASSIGN ttWork.ind-transacao = 6.
      RUN GravaTransacao.
      ASSIGN vLogSai      = YES
             vLogFinaliza = YES.
      RETURN.
   END.
    
   IF NOT VALID-HANDLE(wgbosc120)  THEN DO:
      RUN scbo/bosc120.p PERSISTENT SET wgbosc120.
   END.

   IF NOT VALID-HANDLE(wgbosc074) THEN 
      RUN scbo/bosc074.p PERSISTENT SET wgbosc074.

   RUN validaEtiqueta IN wgbosc074 (INPUT ttWork.num-serial,
                                    INPUT 2) NO-ERROR.
   IF RETURN-VALUE <> 'OK':U THEN DO:
      RUN emptyRowErrors IN wgbosc074.   
      RUN validaEtiqueta IN wgbosc074 (INPUT ttWork.num-serial,
                                       INPUT 3) NO-ERROR.
      IF RETURN-VALUE <> 'OK':U THEN DO:
         RUN emptyRowErrors IN wgbosc074.   
         RUN validaEtiqueta IN wgbosc074 (INPUT ttWork.num-serial,
                                          INPUT 1) NO-ERROR.
         IF RETURN-VALUE = 'OK':U THEN DO:
            RUN getInfoEtiqueta IN wgbosc074(INPUT ttWork.num-serial,
                                             OUTPUT TABLE ttWm-etiqueta-aux).
            
            FIND FIRST ttWm-etiqueta-aux NO-LOCK NO-ERROR.
            IF NOT AVAIL ttWm-etiqueta-aux THEN DO:
               ASSIGN cDescriptionError = "Agrupador Inexistente para Etiqueta Filha " + STRING(ttWork.num-serial) + "(WMS)":U.
               RUN bcp/bc9115.p (90001, cDescriptionError,8,20,3).    
               ASSIGN vLogErro = YES.
               RETURN ERROR.                
            END.
            ELSE DO:
               FIND FIRST tt-inventario-wms-bkp
                    WHERE tt-inventario-wms-bkp.num-serial = ttWm-etiqueta-aux.id-agrupador NO-LOCK NO-ERROR.
               IF NOT AVAIL tt-inventario-wms-bkp THEN DO:
                  ASSIGN cDescriptionError = "Etiqueta Agrupadora deve ser lido antes da Etiqueta NÆo Agrupadora " + STRING(ttWork.num-serial) + "(WMS)":U.
                  RUN bcp/bc9115.p (90001, cDescriptionError,8,20,3).    
                  ASSIGN vLogErro = YES.
                  RETURN ERROR.                
               END.
            END.
         END.
      END.
   END.

   IF VALID-HANDLE(wgbosc074) THEN
      RUN destroy IN wgbosc074.

   RUN emptyRowErrors IN wgbosc120.
   RUN validaEtiquetaInventario IN wgbosc120(INPUT ttWork.cod-estabel,
                                             INPUT ttWork.cod-local,
                                             INPUT ttWork.dat-inventario,
                                             INPUT ttWork.num-seq-invent,
                                             INPUT ttWork.num-box,
                                             INPUT ttWork.num-contagem,
                                             INPUT ttWork.num-serial, 
                                             OUTPUT ttWork.cod-item,   
                                             OUTPUT ttWork.cod-refer,
                                             OUTPUT ttWork.cod-lote,
                                             OUTPUT ttWork.cod-embalagem,
                                             OUTPUT ttWork.dat-validade,                                        
                                             OUTPUT ttWork.qtd-item,
                                             OUTPUT ttWork.ind-transacao).
   
   IF ttWork.ind-transacao = 3 THEN DO ON ENDKEY UNDO,RETRY:
      RUN getRowErrors IN wgbosc120(OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN vLogErro = YES.
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.
   
   IF ttWork.ind-transacao = 4 THEN DO:
      /* serial inv lido, ser  solicitado item */
      {bcp/bc9105.i "101" "Serial Inv lido (DC)"}
      RETURN ERROR.
   END.
   RUN validaItemInventarioConcluido IN wgbosc120( INPUT ttWork.cod-estabel,
                                                   INPUT ttWork.cod-local,
                                                   INPUT ttWork.dat-inventario,
                                                   INPUT ttWork.num-seq-invent,
                                                   INPUT ttWork.num-box,
                                                   INPUT ttWork.cod-item,
                                                   INPUT ttWork.cod-refer,
                                                   INPUT ttWork.cod-lote,
                                                   INPUT ttWork.cod-embalagem,
                                                   OUTPUT i-num-seq-item).
   IF RETURN-VALUE = "NOK":U THEN DO:
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.

      ASSIGN vLogOk = NO.
     
      /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
      DEFINE VARIABLE c-lbl-liter-inventario-wms-3 AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Invent rio_WMS" *}
      ASSIGN c-lbl-liter-inventario-wms-3 = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-contagem-do-item AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Contagem_do_Item" *}
      ASSIGN c-lbl-liter-contagem-do-item = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-concluida AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Concluida." *}
      ASSIGN c-lbl-liter-concluida = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-deseja-reabrir AS CHARACTER FORMAT "X(18)" NO-UNDO.
      {utp/ut-liter.i "Deseja reabrir?" *}
      ASSIGN c-lbl-liter-deseja-reabrir = TRIM(RETURN-VALUE).
      
      DEFINE VARIABLE c-lbl-liter-1sim-2nao-3 AS CHARACTER FORMAT "X(11)" NO-UNDO.
      {utp/ut-liter.i "1=Sim_2=NÆo" *}
      ASSIGN c-lbl-liter-1sim-2nao-3 = TRIM(RETURN-VALUE).
      
      DISP c-lbl-liter-inventario-wms-3     AT ROW 01 COL 01 NO-LABEL
           '----------------'               AT ROW 02 COL 01 
           c-lbl-liter-contagem-do-item     AT ROW 03 COL 01 NO-LABEL
           c-lbl-liter-concluida            AT ROW 04 COL 01 NO-LABEL
           c-lbl-liter-deseja-reabrir       AT ROW 05 COL 01 NO-LABEL
           c-lbl-liter-1sim-2nao-3          AT ROW 07 COL 01 NO-LABEL
         WITH FRAME f-conf-3 FONT 2 SIZE 20 BY 8 NO-BOX.
      
      PAUSE 0 NO-MESSAGE.
      UPDATE vLogOk AT ROW 07 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf-3 FONT 2 SIZE 20 BY 8.
     
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      VIEW FRAME frame01.
      PAUSE 0 NO-MESSAGE.

      IF NOT vLogOk THEN DO:
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
            
      IF NOT VALID-HANDLE(wgbosc119) THEN 
         RUN scbo/bosc119.p PERSISTENT SET wgbosc119.
        
      /* Ajusta inventario para continuar a contagem */
      RUN reabreInventarioItemConcluido IN wgbosc119 (INPUT ttWork.cod-estabel,
                                                      INPUT ttWork.cod-local,
                                                      INPUT ttWork.dat-inventario,
                                                      INPUT ttWork.num-seq-invent,
                                                      INPUT ttWork.num-box,
                                                      INPUT ttWork.num-contagem,
                                                      INPUT i-num-seq-item,
                                                      OUTPUT TABLE RowErrors).
      IF RETURN-VALUE = "NOK":U THEN DO:
         RUN getRowErrors IN wgbosc119(OUTPUT TABLE RowErrors).
         FOR EACH RowErrors:
            ASSIGN vLogErro = YES.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
         END.
         IF vLogErro = YES THEN
            RETURN ERROR.
      END.
      FIND FIRST tt-inventario-wms-bkp
           WHERE tt-inventario-wms-bkp.num-box       = ttWork.num-box
             AND tt-inventario-wms-bkp.num-serial    = ttWork.num-serial
             AND tt-inventario-wms-bkp.cod-item      = ttWork.cod-item
             AND tt-inventario-wms-bkp.cod-refer     = ttWork.cod-refer
             AND tt-inventario-wms-bkp.cod-lote      = ttWork.cod-lote
             AND tt-inventario-wms-bkp.cod-embalagem = ttWork.cod-embalagem NO-LOCK NO-ERROR.
      IF AVAIL tt-inventario-wms-bkp THEN 
         DELETE tt-inventario-wms-bkp.
   END.

   IF NOT VALID-HANDLE(wgbosc130) THEN
      RUN scbo/bosc130.p PERSISTENT SET wgbosc130.

   RUN emptyRowErrors IN wgbosc130.
   RUN validaItemPickingInvent IN wgbosc130 (INPUT ttWork.cod-estabel,
                                             INPUT ttWork.cod-local,
                                             INPUT ttWork.cod-item,
                                             INPUT ttWork.cod-refer,
                                             INPUT ttWork.num-box).
   IF RETURN-VALUE = "NOK":U THEN DO:
      RUN getRowErrors IN wgbosc130(OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN vLogErro = YES.
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 string(ErrorNumber) string(ErrorDescription)}
      END.
      IF vLogErro = YES THEN
         RETURN ERROR.
   END.

    
   /* valida‡Æo ref serial, se o mesmo ja foi lido ou nÆo  */
   IF ttWork.ind-transacao = 1 THEN DO:
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.

      RUN getRowErrors IN wgbosc120(OUTPUT TABLE RowErrors).

      ASSIGN vLogOk = YES.

      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         RUN bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
         /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
         DEFINE VARIABLE c-lbl-liter-confirma-leitura AS CHARACTER FORMAT "X(19)" NO-UNDO.
         {utp/ut-liter.i "Confirma_Leitura?" *}
         ASSIGN c-lbl-liter-confirma-leitura = TRIM(RETURN-VALUE).
         
         DEFINE VARIABLE c-lbl-liter-1sim-2nao-4 AS CHARACTER FORMAT "X(13)" NO-UNDO.
         {utp/ut-liter.i "1=Sim_2=NÆo" *}
         ASSIGN c-lbl-liter-1sim-2nao-4 = TRIM(RETURN-VALUE).
         
         DISP c-lbl-liter-confirma-leitura    AT ROW 01 COL 01 NO-LABEL   
              c-lbl-liter-1sim-2nao-4         AT ROW 02 COL 01 NO-LABEL
            WITH FRAME f-conf-4 FONT 2 SIZE 20 BY 8 NO-BOX.
         
         PAUSE 0 NO-MESSAGE.
         UPDATE vLogOk AT ROW 02 COL 13 NO-LABEL FORMAT '1/2':U WITH FRAME f-conf-4 FONT 2 SIZE 20 BY 8.
      END.
       
      HIDE ALL.
      PAUSE 0 NO-MESSAGE.

      VIEW FRAME frame01.
      PAUSE 0 NO-MESSAGE.

      IF NOT vLogOk THEN DO:
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
   END.

   IF ttWork.ind-transacao = 5 THEN DO:
      /* pallet fechado */
      HIDE ALL.
      PAUSE 0 NO-MESSAGE. 
      HIDE FRAME frame01.
      PAUSE 0 NO-MESSAGE.
      RUN GravaTransacao.
      RETURN.
   END.

   IF ttWork.ind-transacao = 2 AND ttWork.ind-tipo-contr-est <> 2 THEN DO:
      /* pede quantidade e peso */
      HIDE ALL NO-PAUSE.
      RUN bcp/bc9024i.p(INPUT pDesEndereco,
                        INPUT vQtdItens,
                        INPUT-OUTPUT TABLE ttWork) .
      HIDE ALL NO-PAUSE.
        
      FIND FIRST ttWork NO-ERROR.                             

      IF RETURN-VALUE <> 'OK':U THEN DO:
         ASSIGN vLogErro = YES.
         RETURN ERROR.
      END.
   END.
   RUN GravaTransacao.
   RETURN RETURN-VALUE.    
END PROCEDURE.

PROCEDURE GravaTransacao:
/*------------------------------------------------------------------------------
  Purpose:  Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure
            _GenerateDCTransaction.
            Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.
                
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
   IF NOT VALID-HANDLE(wgbc9024j) THEN
      RUN bcp/bc9024j.p PERSISTENT SET wgbc9024j.
   
   /* valida se o serial j  encontra-se lido */
   RUN pi-valida-serial IN wgbc9024j (INPUT ttWork.num-box,
                                      INPUT ttWork.num-serial,
                                      INPUT ttWork.cod-item,
                                      INPUT ttWork.cod-refer, 
                                      INPUT ttWork.cod-lote,
                                      INPUT ttWork.cod-embalagem,
                                      INPUT TABLE tt-inventario-wms-bkp).
   IF RETURN-VALUE <> 'OK':U THEN DO: 
       ASSIGN vLogerro = YES.
       {bcp/bc9105.i "110" "Item/Serial j  coletado (DC)"}
       RETURN 'NOK':U.
   END.
   
   EMPTY TEMP-TABLE tt-trans.
   EMPTY TEMP-TABLE tt-trans-filho.
   
   CREATE tt-trans.
   ASSIGN tt-trans.cod-versao-integracao = 1
          tt-trans.i-sequen = 1
          tt-trans.cd-trans = 'WMOut003':U
          tt-trans.detalhe  = 'Usr:':U + ttWork.cod-usuario + ';':U +
                              'Est:':U + ttWork.cod-estabel + ';':U +
                              'Loc:':U + ttWork.cod-local + ';':U +
                              'DtI:':U + STRING(ttWork.dat-inventario) + ';':U +
                              'Con:':U + STRING(ttWork.num-contagem,'>9':U) + ';':U +
                              'Box:':U + STRING(ttWork.num-box,'>>>>>>>>>9':U)  
          tt-trans.usuario  = v_cod_usuar_corren.
          tt-trans.etiqueta = NO.
          
   CREATE tt-trans-filho.
   ASSIGN tt-trans-filho.i-sequen-pai = 1
          tt-trans-filho.i-sequen     = 1    
          tt-trans-filho.num-versao   = 1
          tt-trans-filho.conteudo-xml = 'Seq:':U + STRING(ttWork.num-seq-invent,'>>>>>9':U) + ';':U +
                                        'Box:':U + STRING(ttWork.num-box,'>>>>>>>>>9':U) + ';':U +
                                        'Log:':U + STRING(ttWork.log-existe-end) + ';':U +
                                        'Ser:':U + STRING(ttWork.num-serial,'>>>>>>>>>>>>>>':U) + ';':U +
                                        'Qtd:':U + STRING(ttWork.qtd-item,'>>>,>>>,>>9.9999':U) + ';':U +
                                        'Ite:':U + STRING(ttWork.cod-item) + ';':U +
                                        'Lot:':U + STRING(ttWork.cod-lote) + ';':U +
                                        'Ref:':U + STRING(ttWork.cod-Refer) + ';':U +
                                        'Emb:':U + STRING(ttWork.cod-embalagem) + ';':U .
   
   IF ttWork.dat-validade = ? THEN
      ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml + 'DtV:':U + '?':U + ';':U. 
   ELSE
      ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml + 'DtV:':U + STRING(ttWork.dat-validade)  + ';':U.
   
   ASSIGN tt-trans-filho.conteudo-xml = tt-trans-filho.conteudo-xml +
                                       'Pes:':U + STRING(ttWork.qtd-peso,'>>>,>>>,>>9.9999':U) + ';':U +
                                       'QtC:':U + STRING(ttWork.qtd-caixas,'>>>>>9.999':U ) + ';':U +
                                       'Ind:':U + STRING(ttWork.ind-transacao,'99':U).
   
   IF NOT VALID-HANDLE(wgbcapi001) THEN
      RUN bcp/bcapi001.p PERSISTENT SET wgbcapi001 (INPUT-OUTPUT TABLE tt-trans,
                                                    INPUT-OUTPUT TABLE tt-erro).
   
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
      ASSIGN vLogerro = YES.
      RETURN 'NOK':U.
   END.
   ELSE DO:
      ASSIGN ttWork.log-existe-end = YES.
      
      /* criar regitro na tt-inventario-wms-bkp utilizada p valida‡Æo */
      FIND FIRST tt-trans NO-LOCK NO-ERROR.
      CREATE tt-inventario-wms-bkp.
      ASSIGN tt-inventario-wms-bkp.cod-usuario    = ttWork.cod-usuario
             tt-inventario-wms-bkp.cod-estabel    = ttWork.cod-estabel
             tt-inventario-wms-bkp.cod-local      = ttWork.cod-local
             tt-inventario-wms-bkp.dat-inventario = ttWork.dat-inventario
             tt-inventario-wms-bkp.num-contagem   = ttWork.num-contagem
             tt-inventario-wms-bkp.num-seq-invent = ttWork.num-seq-invent
             tt-inventario-wms-bkp.num-box        = ttWork.num-box
             tt-inventario-wms-bkp.log-existe-end = ttWork.log-existe-end
             tt-inventario-wms-bkp.num-serial     = ttWork.num-serial
             tt-inventario-wms-bkp.qtd-item       = ttWork.qtd-item
             tt-inventario-wms-bkp.cod-item       = ttWork.cod-item
             tt-inventario-wms-bkp.cod-lote       = ttWork.cod-lote
             tt-inventario-wms-bkp.cod-embalagem  = ttWork.cod-embalagem
             tt-inventario-wms-bkp.cod-refer      = ttWork.cod-refer
             tt-inventario-wms-bkp.dat-validade   = ttWork.dat-validade
             tt-inventario-wms-bkp.qtd-peso       = ttWork.qtd-peso
             tt-inventario-wms-bkp.qtd-caixas     = ttWork.qtd-caixas
             tt-inventario-wms-bkp.ind-transacao  = ttWork.ind-transacao
             tt-inventario-wms-bkp.num-sequencia  = vQtdItens + 1
             tt-inventario-wms-bkp.nr-trans       = tt-trans.nr-trans.
   
      ASSIGN vSerialSeq = tt-inventario-wms-bkp.num-serial.
   
      IF ttWork.num-serial = 999999
         OR ttWork.num-serial = 555555
         OR ttWork.num-serial = 333333 THEN DO:
         
         /* passa bc-trans.estado para 01 */
         RUN finaliza-inventario IN wgbc9024j (INPUT TABLE tt-trans,
                                               OUTPUT TABLE tt-erro).
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
            END.
            ASSIGN vLogerro = YES.
            RETURN 'NOK':U.
         END.
         /* prepara para efetiva‡Æo */
         RUN inventario-pre-api-wms IN wgbc9024j (INPUT-OUTPUT TABLE tt-trans,
                                                  INPUT-OUTPUT TABLE tt-erro).
   
         FIND FIRST tt-erro NO-ERROR.
         IF AVAIL tt-erro THEN DO: 
            FOR EACH tt-erro:
                ASSIGN tt-erro.mensagem = tt-erro.mensagem + "(DC)":U.
                {bcp/bc9015.i2 string(tt-erro.cd-erro) string(tt-erro.mensagem)}
            END.
            ASSIGN vLogerro = YES.
            RETURN 'NOK':U.
         END.
         ELSE DO:
           IF CAN-FIND(FIRST wm-inventario-endereco 
                       WHERE wm-inventario-endereco.cod-estabel      = ttWork.cod-estabel
                         AND wm-inventario-endereco.cod-local        = ttWork.cod-local
                         AND wm-inventario-endereco.dt-inventario    = ttWork.dat-inventario
                         AND wm-inventario-endereco.ind-sit-inv-end <> 1 ) THEN
              ASSIGN ttWork.ind-transacao = 9.   
         END.
      END.
   
      /* solicitado box vazio */      
      IF ttWork.ind-transacao = 6 THEN DO:
         HIDE ALL NO-PAUSE.
         {bcp/bc9105.i "903" "Box Encerrado (WMS)"} 
         ASSIGN vQtdItens = vQtdItens + 1.
      END.
      ELSE DO:
         IF ttWork.ind-transacao = 9 THEN DO:
             HIDE ALL NO-PAUSE.
            {bcp/bc9105.i "904" "Contagem Encerrada (WMS)"}
         END.
         ELSE
         IF ttWork.ind-transacao = 8 THEN DO:
            HIDE ALL NO-PAUSE.
            {bcp/bc9105.i "905" "Processo abortado (WMS)"}
         END.
         ELSE DO:
             HIDE ALL NO-PAUSE.
            {bcp/bc9105.i "902" "Item/Serial Confirmado (WMS)"}
            ASSIGN vQtdItens = vQtdItens + 1.
         END.
      END.
   END.
   
   HIDE ALL NO-PAUSE.
   RETURN RETURN-VALUE.
END PROCEDURE.
