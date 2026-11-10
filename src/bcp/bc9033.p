/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9033 2.00.00.019 } /*** "010019" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC9033 MBC}
&ENDIF

{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */

/********************************************************************************************
**   Programa..: bc9033.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Junho/2006 - Thiago Bravo - Cria‡Æo do programa             **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Picking/Packing Simultaneos WMS  **
**                                                                                         **
********************************************************************************************/
DEFINE NEW GLOBAL SHARED VAR lMenu      AS LOGICAL           NO-UNDO.
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-picking-wms.                                                     **
** FrameSize            - Tamanho da tela da interface. Deve-se observar este parametro quando da **
**                        definicao das telas, o espaco utilizado nao pode ultrapassar o limite   **
**                        estabelecido por este pre-processador.                                  **
** Frame99Name          - Nome da Tela. Sugestao "Frame" mais sequencia.                          **
**                        Ex. Frame01, Frame02, Frame04, etc.                                     **
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
&global-define ProgramName BC9033
/************************************************************/

/* Definicao da temp-table de integracao ---                */
DEFINE NEW SHARED VARIABLE i-etiqueta-packing  AS DECIMAL       FORMAT '>>>>>>>>>>>>>>>' NO-UNDO.

DEFINE VARIABLE wgbosc030              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc032              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc044              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc047              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc092              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc096              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgbosc079              AS HANDLE   NO-UNDO.
DEFINE VARIABLE wgBosc135              AS HANDLE   NO-UNDO.   
DEFINE VARIABLE wgbosc152              AS HANDLE   NO-UNDO.       
DEFINE VARIABLE wgbcapiwms             AS HANDLE   NO-UNDO. 
DEFINE VARIABLE l-tarefas-publicas     AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-tarefas-em-processo  AS LOGICAL  NO-UNDO.


&global-define TempTable tt-picking-wms

{bcp/bc9033.i " "}
{bcp/bc9033.i1 "New"}
{utp/utapi009.i} /* login */
{bcp/bc9048.i1} /* definicao variaveis menu padrao */

CREATE ttWork.

DEFINE VARIABLE vnr-pedcli       AS CHARACTER FORMAT 'x(12)':U      INITIAL ''  NO-UNDO.
DEFINE VARIABLE vnome-abrev      AS CHARACTER FORMAT 'x(12)':U      INITIAL ''  NO-UNDO.
DEFINE VARIABLE vcod-item        AS CHARACTER FORMAT 'x(16)':U      INITIAL ''  NO-UNDO.
DEFINE VARIABLE vdes-item        AS CHARACTER FORMAT 'x(18)':U      INITIAL ''  NO-UNDO. 
DEFINE VARIABLE c-desc-item      AS CHARACTER                                   NO-UNDO.
DEFINE VARIABLE vcod-senha       AS CHARACTER FORMAT 'x(18)':U                  NO-UNDO.
DEFINE VARIABLE vnom-estabel     AS CHARACTER FORMAT 'x(14)':U                  NO-UNDO.
DEFINE VARIABLE vnom-local       AS CHARACTER FORMAT 'x(14)':U                  NO-UNDO.

DEFINE VARIABLE l-menu-padrao AS LOGICAL INITIAL YES NO-UNDO.

DEFINE VARIABLE cod-estab-roteiriz LIKE ttWm-box-movto-idx-picking.cod-estabel  NO-UNDO.
DEFINE VARIABLE cod-local-roteiriz LIKE ttWm-box-movto-idx-picking.cod-local    NO-UNDO.
DEFINE VARIABLE id-movto-roteiriz  LIKE ttWm-box-movto-idx-picking.id-movto     NO-UNDO.

DEFINE VARIABLE l-ascend       AS LOGICAL INIT YES NO-UNDO.
DEFINE VARIABLE l-ler-etiqpack AS LOGICAL          NO-UNDO.
DEFINE VARIABLE iOpcao         AS INTEGER          NO-UNDO.

/***************************************************************************************/

DEFINE TEMP-TABLE tt-mostra-locais NO-UNDO
            FIELD cod-bloco         AS CHARACTER
            FIELD cod-rua           AS CHARACTER
            FIELD cod-nivel         AS CHARACTER
            FIELD cod-coluna        AS CHARACTER
            FIELD ind-posicao-box   AS INTEGER
            FIELD num-seq           AS INTEGER
            FIELD des-local         AS CHARACTER FORMAT 'X(19)':U
            FIELD rowid-box-movto   AS ROWID 
            INDEX ID num-seq.

DEFINE TEMP-TABLE tt-serial NO-UNDO
            FIELD id-etiqueta          LIKE wm-etiqueta.id-etiqueta
            FIELD qtd-item-retirado    LIKE wm-etiqueta.qtd-item-retirado
            FIELD id-movto             LIKE wm-movto-etiqueta.id-movto
            INDEX idx-serial  AS PRIMARY id-etiqueta.


DEFINE BUFFER b-ttwm-box-aux FOR ttwm-box-aux.

DEFINE QUERY qry-wm-box-movto FOR tt-mostra-locais.

DEFINE BROWSE brw-wm-box-movto QUERY qry-wm-box-movto NO-LOCK 
             DISPLAY tt-mostra-locais.des-local 
               WITH NO-BOX NO-LABELS SIZE 20 BY 2.5 NO-SCROLLBAR-VERTICAL.


/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Picking/Packing WMS'                              At Row 01 Col 01  ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Usr:'                                             At Row 03 Col 01          ~
                             ttWork.cod-usuario                                 At Row 03 Col 05 No-label FORMAT "x(25)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Sen:'                                             AT ROW 04 COL 01          ~
                             vcod-senha                                         AT ROW 04 COL 05 NO-LABEL FORMAT "x(18)"  VIEW-AS FILL-IN SIZE 15 BY 0.88 ~
                             'Col:'                                             At Row 05 Col 01          ~
                             ttWork.cod-coletor                                 At Row 05 Col 05 No-label ~
                             'Equ:'                                             At Row 06 Col 01          ~
                             ttWork.cod-equipamento                             At Row 06 Col 05 No-label ~
                             'Estab:'                                           AT ROW 07 COL 01          ~
                              ttWork.cod-estabel                                AT ROW 07 COL 07 NO-LABEL ~
                             'Local:'                                           AT ROW 08 COL 01          ~
                              ttWork.cod-local                                  AT ROW 08 COL 07 NO-LABEL

&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Picking/Packing WMS'                              At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             '1 - Tarefas P£blicas'                             At Row 03 Col 01          ~
                             '2 - Minhas Tarefas'                               At Row 04 Col 01          ~
                             '3 - Tarefas Equipto'                              At Row 05 Col 01          ~
                             '4 - Meus Processos'                               At Row 06 Col 01          ~
                             'Op‡Æo:'                                           At Row 07 Col 01          ~
                              ttWork.opcao                                      At Row 07 Col 08 No-Label

&global-define Frame02Repeat No
/************************************************************/

/* Definicao da Frame03 ---                                                                               */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Picking/Packing WMS'                              At Row 01 Col 01          ~
                             '--------------------'                             At Row 02 Col 01          ~
                             'Etiqueta Packing:'                                AT ROW 03 COL 01          ~
                             i-etiqueta-packing                                    At Row 04 Col 01 No-label ~
&global-define Frame03Repeat No


/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   'Pick/Pack WMS'                              At Row 01 Col 01          ~
                             brw-wm-box-movto                                   At Row 02 Col 01          ~
                             'Ped:'                                             AT ROW 05 COL 01          ~
                             vnr-pedcli                                         At Row 05 Col 06 No-label ~
                             'Cli:'                                             AT ROW 06 COL 01          ~
                             vnome-abrev                                        AT ROW 06 COL 06 NO-LABEL ~
                             'It:'                                              AT ROW 07 COL 01          ~
                             vcod-item                                          AT ROW 07 COL 03 NO-LABEL ~
                             vdes-item                                          AT ROW 08 COL 01 NO-LABEL ~
                             
&global-define Frame04Repeat YES
/************************************************************/

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-usuario WHEN ttWork.cod-usuario = '' ~
                              vcod-senha WHEN ttWork.cod-usuario = '' ~
                              ttWork.cod-coletor ~
                              ttWork.cod-equipamento ~
                              ttWork.cod-estabel ~
                              ttWork.cod-local

&global-define Update02Fields ttwork.opcao

&global-define Update03Fields i-etiqueta-packing

&global-define Update04Fields brw-wm-box-movto

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. Empty Temp-table tt-mostra-locais. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. 

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
                            ON 'Return':U        OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                   Apply 'Go' To This-procedure.                                    ~
                            END.                                                                    ~
                            ON 'value-changed':U OF brw-wm-box-movto In Frame {&Frame04Name}        ~
                            DO:                                                                     ~
                                RUN piAtualizaFrame04. ~
                            END. ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc032
&global-define ActiveObject3 wgbosc044
&global-define ActiveObject4 wgbosc047
&global-define ActiveObject5 wgbosc079
&global-define ActiveObject6 wgbosc092
&global-define ActiveObject7 wgbosc096
&global-define ActiveObject8 wgbosc135
&global-define ActiveObject9 wgbosc152
&global-define ActiveObject10 wgbcapiwms


/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
RUN InitHandles IN THIS-PROCEDURE.

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
          
   /* caso tenha sido startado login autom tico */
   IF v_cod_usuar_corren <> '' THEN DO: 
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = NO
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = v_cod_usuar_corren
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
      ASSIGN vcod-senha:BLANK IN FRAME frame01 = YES
             ttWork.cod-usuario:SCREEN-VALUE IN FRAME Frame01 = '' 
             ttWork.cod-usuario = ''
             vcod-senha = ''  
             vcod-senha:SCREEN-VALUE IN FRAME Frame01 = ''
             ttWork.cod-estabel   = ''
             ttWork.cod-local     = ''.
   END.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame02 com valores em branco              **
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame02:
    
   ASSIGN vLogErro    = NO
          vLogCancela = NO
          vLogSai     = NO.

   IF v_cod_usuar_corren = "" THEN
      RETURN ERROR.

END PROCEDURE.

/***************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeframe03}.                        **
*****************************************************************************************************/
PROCEDURE InicializaCamposFrame03:
   ASSIGN vLogErro     = NO
          vLogCancela  = NO
          vLogSai      = NO.

   ASSIGN i-etiqueta-packing = 0.

   PAUSE 0 NO-MESSAGE.
END PROCEDURE.
/****************************************************************************************************/ 


/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame04}.                      **
****************************************************************************************************/
PROCEDURE InicializaCamposFrame04:
   ASSIGN vLogErro        = NO
          vLogCancela     = NO
          vLogEmProcesso  = NO.

   RUN GetTasks.

   IF vLogerro = YES THEN
      RETURN ERROR. 

   EMPTY TEMP-TABLE ttWm-Box-aux.
   EMPTY TEMP-TABLE tt-mostra-locais.
    
   ASSIGN vNumSeq = 1.

   wm-boxm:
   FOR EACH ttWm-box-movto-idx-picking
      WHERE ttWm-box-movto-idx-picking.ind-tipo-movto = 2
        AND ttWm-box-movto-idx-picking.cod-estabel    = ttWork.cod-estabel
        AND ttWm-box-movto-idx-picking.cod-local      = ttWork.cod-local  
      BREAK BY ttWm-box-movto-idx-picking.nr-pedcli
            BY ttWm-box-movto-idx-picking.nome-abrev
            BY ttWm-box-movto-idx-picking.val-prioridade:

      /* Pegar Informacoes Box */
      RUN SetConstraintBoxes IN wgbosc030 (INPUT ttWm-box-movto-idx-picking.cod-estabel,
                                           INPUT ttWm-box-movto-idx-picking.cod-local,
                                           INPUT ttWm-box-movto-idx-picking.id-box,
                                           INPUT ttWm-box-movto-idx-picking.id-box).

      RUN openQueryStatic IN wgbosc030 (INPUT 'Boxes':U).

      EMPTY TEMP-TABLE ttWm-Box.

      RUN getBatchRecords IN wgbosc030 (INPUT ?,
                                        INPUT NO,
                                        INPUT ?,
                                        OUTPUT vNumCont,
                                        OUTPUT TABLE ttwm-box).

      FIND FIRST ttwm-box NO-ERROR.

      IF AVAIL ttwm-box THEN DO:
         FOR EACH ttwm-box:
            FIND FIRST ttwm-box-aux 
                 WHERE ttwm-box-aux.cod-estabel = ttwm-box.cod-estabel
                   AND ttwm-box-aux.cod-local   = ttwm-box.cod-local
                   AND ttwm-box-aux.id-box      = ttwm-box.id-box NO-LOCK NO-ERROR.
            IF NOT AVAIL ttwm-box-aux THEN DO:
               CREATE ttwm-box-aux.
               BUFFER-COPY ttwm-box TO ttwm-box-aux.
    
               ASSIGN ttwm-box-aux.r-Rowid         = ROWID(ttWm-box-movto-idx-picking)
                      ttwm-box-aux.log-pend-ressup = ttWm-box-movto-idx-picking.log-pend-ressup.
            END.    
         END.                
      END.        
   END.        

   /* L¢gica de Roteiriza‡Æo - Inicio */
   FOR EACH ttwm-box-aux
      WHERE ttwm-box-aux.cod-estabel    = ttWork.cod-estabel
        AND ttwm-box-aux.cod-local      = ttWork.cod-local  
      BREAK BY ttWm-Box-aux.cod-bloco
            BY ttWm-Box-aux.cod-rua:

      IF FIRST-OF(ttWm-Box-aux.cod-rua) THEN DO:
         IF l-ascend THEN DO: /* Se a ordena‡Æo deve ser ascendente */
            FOR EACH b-ttWm-Box-aux 
               WHERE b-ttwm-box-aux.cod-estabel = ttWm-Box-aux.cod-estabel
                 AND b-ttwm-box-aux.cod-local   = ttWm-Box-aux.cod-local   
                 AND b-ttWm-Box-aux.cod-bloco   = ttWm-Box-aux.cod-bloco
                 AND b-ttWm-Box-aux.cod-rua     = ttWm-Box-aux.cod-rua 
               BY b-ttWm-Box-aux.cod-rua
               BY b-ttWm-Box-aux.cod-coluna:

               CREATE tt-mostra-locais.
               ASSIGN tt-mostra-locais.num-seq           = vNumSeq
                      tt-mostra-locais.cod-bloco         = b-ttWm-Box-aux.cod-bloco             
                      tt-mostra-locais.cod-rua           = b-ttWm-Box-aux.cod-rua    
                      tt-mostra-locais.cod-nivel         = b-ttWm-Box-aux.cod-nivel  
                      tt-mostra-locais.cod-coluna        = b-ttWm-Box-aux.cod-coluna 
                      tt-mostra-locais.ind-posicao-box   = b-ttWm-Box-aux.ind-posicao-box
                      tt-mostra-locais.des-local         = b-ttWm-Box-aux.cod-bloco            + '/':U +
                                                           b-ttWm-Box-aux.cod-rua              + '/':U +
                                                           b-ttWm-Box-aux.cod-nivel            + '/':U +
                                                           b-ttWm-Box-aux.cod-coluna           + '/':U +
                                                           IF b-ttWm-Box-aux.ind-posicao-box = 1 THEN 'E' ELSE 'D'.
                      tt-mostra-locais.rowid-box-movto   = b-ttWm-Box-aux.r-Rowid.                                                                                   
    
               IF b-ttWm-Box-aux.log-pend-ressup AND ttWork.opcao = 4 THEN
                  ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.
                    
               ASSIGN vNumSeq = vNumSeq + 1.
            END.
            ASSIGN l-ascend = NO.
         END.
         ELSE 
            IF l-ascend = NO THEN DO:
               FOR EACH b-ttWm-Box-aux 
                  WHERE b-ttwm-box-aux.cod-estabel = ttWm-Box-aux.cod-estabel
                    AND b-ttwm-box-aux.cod-local   = ttWm-Box-aux.cod-local   
                    AND b-ttWm-Box-aux.cod-bloco   = ttWm-Box-aux.cod-bloco
                    AND b-ttWm-Box-aux.cod-rua     = ttWm-Box-aux.cod-rua 
                  BY b-ttWm-Box-aux.cod-rua
                  BY b-ttWm-Box-aux.cod-coluna DESCEND:

                  CREATE tt-mostra-locais.                     
                  ASSIGN tt-mostra-locais.num-seq           = vNumSeq
                         tt-mostra-locais.cod-bloco         = b-ttWm-Box-aux.cod-bloco             
                         tt-mostra-locais.cod-rua           = b-ttWm-Box-aux.cod-rua    
                         tt-mostra-locais.cod-nivel         = b-ttWm-Box-aux.cod-nivel  
                         tt-mostra-locais.cod-coluna        = b-ttWm-Box-aux.cod-coluna 
                         tt-mostra-locais.ind-posicao-box   = b-ttWm-Box-aux.ind-posicao-box
                         tt-mostra-locais.des-local         = b-ttWm-Box-aux.cod-bloco            + '/':U +
                                                              b-ttWm-Box-aux.cod-rua              + '/':U +
                                                              b-ttWm-Box-aux.cod-nivel            + '/':U +
                                                              b-ttWm-Box-aux.cod-coluna           + '/':U +
                                                              IF b-ttWm-Box-aux.ind-posicao-box = 1 THEN 'E' ELSE 'D'.
                         tt-mostra-locais.rowid-box-movto   = b-ttWm-Box-aux.r-Rowid.                                                                                 
                               
                  IF b-ttWm-Box-aux.log-pend-ressup AND ttWork.opcao = 4 THEN
                     ASSIGN tt-mostra-locais.des-local = tt-mostra-locais.des-local + '  R'.
                               
                  ASSIGN vNumSeq = vNumSeq + 1.
               END.
               ASSIGN l-ascend = YES.
            END.
      END.
   END.
   /* Elimina da tt-mostra-locais as tarefas j  conclu¡das */
   /* (Tarefa que est  na tt-mostra-locais e nÆo est  na ttWm-Box-Aux j  foi conclu¡da) */
   FOR EACH tt-mostra-locais:
      FIND FIRST ttWm-Box-aux
           WHERE ttWm-Box-aux.cod-bloco       = tt-mostra-locais.cod-bloco              
             AND ttWm-Box-aux.cod-rua         = tt-mostra-locais.cod-rua           
             AND ttWm-Box-aux.cod-nivel       = tt-mostra-locais.cod-nivel         
             AND ttWm-Box-aux.cod-coluna      = tt-mostra-locais.cod-coluna        
             AND ttWm-Box-aux.ind-posicao-box = tt-mostra-locais.ind-posicao-box NO-LOCK NO-ERROR.
      IF NOT AVAIL ttWm-Box-aux THEN
         DELETE tt-mostra-locais.
   END.
   
   /* L¢gica de Roteiriza‡Æo - Final */    
   FIND FIRST tt-mostra-locais NO-LOCK NO-ERROR.
   IF NOT AVAIL tt-mostra-locais THEN DO:
      CREATE tt-mostra-locais.
      ASSIGN tt-mostra-locais.num-seq   = 999
             tt-mostra-locais.des-local = 'NÆo existem tarefas (WMS)'
             vcod-item:SCREEN-VALUE IN FRAME Frame04   = ""                       
             vnr-pedcli:SCREEN-VALUE IN FRAME Frame04  = ""            
             vnome-abrev:SCREEN-VALUE IN FRAME Frame04 = ""
             vdes-item:SCREEN-VALUE IN FRAME Frame04   = "".
   END.

   OPEN QUERY qry-wm-box-movto FOR EACH tt-mostra-locais
      BY tt-mostra-locais.num-seq.

   APPLY 'VALUE-CHANGED':U TO brw-wm-box-movto IN FRAME {&Frame04Name}.

   HIDE ALL NO-PAUSE.
 
   PAUSE 0 NO-MESSAGE.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   ASSIGN vLogErro          = NO
          vLogControlaLogin = NO.

   /* valida usuario mestre contra mguni do EMS */
   IF ttWork.cod-usuario = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "101" "Usu rio Inv lido (DC)"}
   END.

   IF v2_cod_usuar_corren = "" THEN DO:

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
      IF CAN-FIND (FIRST tt-erros 
                   WHERE tt-erros.cod-erro = 4753) THEN DO:
         {bcp/bc9105.i "4753" "Usu rio nÆo encontrado!(DC)"}
         Assign vLogErro           = YES
                v_cod_usuar_corren = ''.
         RETURN ERROR.
      END.
      ELSE DO:
         IF CAN-FIND (FIRST tt-erros
                      WHERE tt-erros.cod-erro = 4758) THEN DO:
            {bcp/bc9105.i "4758" "Senha para o usu rio nÆo est  correta!(DC)"} 
            ASSIGN vLogErro           = YES
                   v_cod_usuar_corren = ''.
            RETURN ERROR.
         END.
      END.

      RUN piValidaUsuario IN wgbcapiwms (INPUT INPUT FRAME frame01 ttWork.cod-usuario,
                                         OUTPUT ttWork.cod-usuario).
                                          
      ASSIGN vLogControlaLogin = YES.
   END.

   RUN validaUsuarioTarefa In wgbosc135 (INPUT ttWork.cod-usuario,
                                         INPUT 07).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ""
                v2_cod_usuar_corren = "".
      {bcp/bc9105.i "100" "Usu rio sem permissÆo para executar Picking (WMS)"}
      RETURN ERROR.
   END.

   RUN validaUsuario In wgbosc079 (INPUT INPUT FRAME Frame01 ttWork.cod-usuario,
                                   OUTPUT vLogUtilizaColetor,
                                   OUTPUT vLogAprovaFatura).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
                
      RUN getrowErrors In wgbosc079 (OUTPUT TABLE RowErrors).
      FOR EACH RowErrors:
         ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
         {bcp/bc9015.i2 STRING(ErrorNumber) STRING(ErrorDescription)}
      END.                                           
   END.

   IF vLogUtilizaColetor = NO THEN DO:
      ASSIGN vLogErro = YES.
      IF vLogControlaLogin = YES THEN
         ASSIGN v_cod_usuar_corren  = ''
                v2_cod_usuar_corren = ''.
      {bcp/bc9105.i "101" "Usu rio sem permissÆo para utilizar Coletor (WMS)"}
      RETURN ERROR.
   END.

   IF ttWork.cod-coletor = '' THEN DO:
      ASSIGN vLogErro = Yes.
      {bcp/bc9105.i "102" "Coletor Inv lido (WMS)"}
   END.

   IF ttWork.cod-equipamento = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Equipamento Inv lido (WMS)"}
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   RUN EmptyRowErrors In wgbosc092.

   RUN validaEquipColetor In wgbosc092  (INPUT ttWork.cod-coletor,
                                         OUTPUT vCodTipoEquip,
                                         OUTPUT vLogAtivo,
                                         OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inv lido (WMS)"}
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "103" "Coletor Inativo (WMS)"}
   END.

   IF ttWork.cod-estabel = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "200" "Estabelecimento Inv lido (DC)"}
      RETURN ERROR.
   END.

   RUN getNomEstabel IN wgbosc047 (INPUT ttWork.cod-estabel,
                                   OUTPUT vnom-estabel).

   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "201" "Estabelecimento Inv lido (WMS)"}
      RETURN ERROR.
   END.

   IF ttWork.cod-local = '' THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "202" "Local Inv lido (DC)"}
      RETURN ERROR.
   END.

   RUN getNomLocal IN wgbosc047 (INPUT ttWork.cod-estabel,
                                 INPUT ttWork.cod-local,
                                 OUTPUT vnom-local).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "203" "Local Inv lido (WMS)"}
      RETURN ERROR.
   END.

   IF vLogErro = YES THEN
      RETURN ERROR.

   RUN validaEquipTransportador In wgbosc092 (INPUT ttWork.cod-equipamento,
                                              OUTPUT vCodTipoEquip,
                                              OUTPUT vLogAtivo,
                                              OUTPUT vLogProcesso).
   IF RETURN-VALUE <> 'OK':U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "104" "Equipamento Inv lido (WMS)"}
   END.

   IF vLogAtivo = NO THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "105" "Equipamento Inativo (WMS)"}
   END.
   
   IF vLogErro = YES THEN
      RETURN ERROR.
 
   ASSIGN {&TempTable}.cod-usuario     = ttWork.cod-usuario 
          {&TempTable}.cod-coletor     = ttWork.cod-coletor
          {&TempTable}.cod-equipamento = ttWork.cod-equipamento.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 02.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame02:
   ASSIGN vLogErro = NO.
   
   IF INPUT FRAME Frame02 ttWork.opcao <> 1
      AND INPUT FRAME Frame02 ttWork.opcao <> 2
      AND INPUT FRAME Frame02 ttWork.opcao <> 3
      AND INPUT FRAME Frame02 ttWork.opcao <> 4 THEN DO:
      {bcp/bc9105.i "100" "Op‡Æo Inv lida (DC)"}
      HIDE ALL.
      RETURN ERROR. 
   END.

   ASSIGN {&TempTable}.opcao  = INPUT FRAME Frame02 ttWork.opcao.

   ASSIGN vLogIniciado = NO.

   ASSIGN ttWork.qtd-embal-lidas  = 0
          ttWork.des-seriais      = ''
          ttWork.num-box-lido     = 0
          ttWork.num-doca         = 0
          ttWork.qtd-embal-lidas  = 0
          ttWork.qtd-item-digit   = 0.

   EMPTY TEMP-TABLE tt-mostra-locais.
END PROCEDURE.



/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame03:
   /* Valida o codigo da Etiqueta de Packing informado */
   IF LENGTH(STRING(i-etiqueta-packing)) = 0 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta deve ser informada"}
      UNDO,RETRY.
   END.
    
   IF LENGTH(STRING(i-etiqueta-packing)) <> 15 THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta informada deve ser de Embalagem"}
      ASSIGN i-etiqueta-packing = 0.
      UNDO,RETRY.
   END.

   RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   RUN goToKey IN wgbosc152 (INPUT i-etiqueta-packing).
   IF RETURN-VALUE <> "OK":U THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "000" "Etiqueta de embalagem nÆo foi encontrada"}
      ASSIGN i-etiqueta-packing = 0.
      UNDO,RETRY.
   END.
END PROCEDURE.
/**************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame04}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame04:
   ASSIGN vLogErro     = NO
          vLogSai      = NO 
          vLogFinaliza = NO.

   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido. (WMS)"}
      RETURN ERROR.
   END.                     

   /* Usa-se ttWm-box-movto-idx-picking.ind-status-movto para saber se a tarefa foi iniciada ou nao.
      1 = Nao iniciada, 2 = Iniciada, 3 = Concluida */

   IF ttWork.opcao = 4 THEN DO:
      ASSIGN vLogEmProcesso = YES.
   END.

   IF vLogEmProcesso = NO THEN DO:
      RUN inicializaTarefaMovtoOK IN wgbosc096 (INPUT ttWm-box-movto-idx-picking.id-docto,
                                                INPUT 07,     
                                                INPUT ttWork.cod-usuario,              
                                                INPUT ttWork.cod-equipamento,          
                                                INPUT ttWork.cod-coletor,
                                                INPUT ttWm-box-movto-idx-picking.id-movto,         
                                                INPUT ttWm-box-movto-idx-picking.num-seq-item).
      IF RETURN-VALUE <> 'OK' THEN DO:
         ASSIGN vLogErro = YES.
         {bcp/bc9105.i "302" "Movimento Expirado ou J  Alocado (WMS)"}
         RETURN ERROR.
      END.

      ASSIGN vLogEmProcesso = YES.
   END.

   ASSIGN vLogErro = NO.
   
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN DO:
      ASSIGN vLogErro = YES.
      {bcp/bc9105.i "301" "Movimento Inv lido (WMS)"}
      RETURN ERROR.
   END.

   HIDE All NO-PAUSE.

   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.

   FIND FIRST ttWork NO-ERROR.

   HIDE All NO-PAUSE.

   ASSIGN cod-estab-roteiriz = ttWm-box-movto-idx-picking.cod-estabel
          cod-local-roteiriz = ttWm-box-movto-idx-picking.cod-local
          id-movto-roteiriz  = ttWm-box-movto-idx-picking.id-movto.

   RUN bcp/bc9033h.p (INPUT ROWID(ttWm-box-movto-idx-picking)).
   HIDE All NO-PAUSE.

   IF RETURN-VALUE = "OK" THEN DO:
      {bcp/bc9105.i "001" "Picking Concluido com Sucesso (DC)"}
   END.

   FIND FIRST ttWork NO-ERROR.

   IF ttWork.opcao = 2 THEN DO:
      RUN wmp/wm9043.p (INPUT cod-estab-roteiriz,
                        INPUT cod-local-roteiriz,
                        INPUT id-movto-roteiriz).
   END.

   RETURN RETURN-VALUE.
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure ir  obter a lista das tarefas para a transa‡Æo de picking / packing             **
****************************************************************************************************/
PROCEDURE GetTasks:
   ASSIGN vLogCancela  = NO
          vLogErro     = NO.

   EMPTY TEMP-TABLE ttWm-box-movto-idx-picking.
   EMPTY TEMP-TABLE ttwm-docto-itens.

   RUN openQueryStatic In wgbosc152 (Input "Main":U) NO-ERROR.

   CASE ttWork.opcao:
      WHEN 1 THEN DO:
         /* Tarefas publicas */
         ASSIGN l-tarefas-publicas = Yes.
         
         RUN getParamTrans (INPUT "WMSai009",
                            INPUT "LER-TAREFAS-PROCESSO",
                            OUTPUT l-tarefas-em-processo).
                               
         RUN getMovtoTarefasPubPickPack IN wgbosc152 (INPUT ttWork.cod-usuario,
                                                      INPUT ttWork.cod-equipamento,
                                                      INPUT ttWork.cod-estabel,
                                                      INPUT ttWork.cod-local,
                                                      INPUT vCodTipoEquip,
                                                      INPUT 07,           
                                                      INPUT l-tarefas-publicas,
                                                      INPUT l-tarefas-em-processo,
                                                      INPUT i-etiqueta-packing,
                                                      OUTPUT TABLE ttWm-box-movto-idx-picking,
                                                      OUTPUT TABLE ttwm-docto-itens).

      END.
      WHEN 2 THEN DO:
         /* Tarefas do usuario*/
         RUN getMovtoTarefasUsuarioPickPack IN wgbosc152 (INPUT ttWork.cod-usuario,
                                                          INPUT ttWork.cod-equipamento,
                                                          INPUT ttWork.cod-estabel,
                                                          INPUT ttWork.cod-local,
                                                          INPUT vCodTipoEquip,
                                                          INPUT 07,           
                                                          INPUT i-etiqueta-packing,
                                                          OUTPUT TABLE ttWm-box-movto-idx-picking,
                                                          OUTPUT TABLE ttwm-docto-itens).
      END.
      WHEN 3 THEN DO:
         /* Tarefas do equipamento */
         RUN getMovtoTarefasEquipPickPack IN wgbosc152 (INPUT ttWork.cod-usuario,
                                                        INPUT ttWork.cod-equipamento,
                                                        INPUT ttWork.cod-estabel,
                                                        INPUT ttWork.cod-local,
                                                        INPUT vCodTipoEquip,
                                                        INPUT 07,           
                                                        INPUT i-etiqueta-packing,
                                                        OUTPUT TABLE ttWm-box-movto-idx-picking,
                                                        OUTPUT TABLE ttwm-docto-itens).
      END.
      WHEN 4 THEN DO:
         /* Em processo */
         RUN getMovtoTarefasPubPickPack IN wgbosc152 (INPUT ttWork.cod-usuario,
                                                      INPUT ttWork.cod-equipamento,
                                                      INPUT ttWork.cod-estabel,
                                                      INPUT ttWork.cod-local,
                                                      INPUT vCodTipoEquip,
                                                      INPUT 07,           
                                                      INPUT No,  /* Nao traz Tarefas Publicas */
                                                      INPUT Yes, /* Tras tarefas Em Processo  */
                                                      INPUT i-etiqueta-packing,
                                                      OUTPUT TABLE ttWm-box-movto-idx-picking,
                                                      OUTPUT TABLE ttwm-docto-itens).
      END.
   END CASE.

   IF RETURN-VALUE = "NOK":U THEN DO:
      ASSIGN vLogerro = YES.
      RETURN "NOK":U.
   END.
   
   RETURN 'OK':U.
END PROCEDURE.


/**************************************************************************/
PROCEDURE piAtualizaFrame04 :
/**************************************************************************/
   FIND ttWm-box-movto-idx-picking WHERE ROWID(ttWm-box-movto-idx-picking) = tt-mostra-locais.rowid-box-movto NO-ERROR.                                                             
   IF NOT AVAIL ttWm-box-movto-idx-picking THEN
      RETURN NO-APPLY.               

   FIND FIRST ttwm-docto-itens 
        WHERE ttwm-docto-itens.cod-estabel  = ttWm-box-movto-idx-picking.cod-estabel
          AND ttwm-docto-itens.cod-local    = ttWm-box-movto-idx-picking.cod-local 
          AND ttwm-docto-itens.id-docto     = ttWm-box-movto-idx-picking.id-docto   
          AND ttwm-docto-itens.num-seq-item = ttWm-box-movto-idx-picking.num-seq-item NO-LOCK NO-ERROR.
   IF NOT AVAIL ttwm-docto-itens THEN
      RETURN NO-APPLY.

   RUN goToKey IN wgbosc044 (INPUT ttwm-docto-itens.cod-item). /* Vari vel ou Campo com o c¢digo do Item */ 
   IF RETURN-VALUE = "OK":U THEN DO:                                                                        
      RUN getCharField IN wgbosc044 (INPUT "des-item":U,                                                   
                                     OUTPUT c-desc-item). /* Vari vel ou Campo com a descri‡Æo do Item */  
      ASSIGN vdes-item:SCREEN-VALUE IN FRAME Frame04 = TRIM(SUBSTRING(c-desc-item,1,18)).                
   END.                                                                                                     
   ELSE DO:                                                                                                 
      ASSIGN vdes-item:SCREEN-VALUE IN FRAME Frame04 = ''.                                               
   END.                                                                                                     

   ASSIGN vcod-item:SCREEN-VALUE IN FRAME Frame04   = TRIM(ttwm-docto-itens.cod-item)                       
          vnr-pedcli:SCREEN-VALUE IN FRAME Frame04  = TRIM(ttWm-box-movto-idx-picking.nr-pedcli)            
          vnome-abrev:SCREEN-VALUE IN FRAME Frame04 = TRIM(ttWm-box-movto-idx-picking.nome-abrev).          
END PROCEDURE.

/* Inicializa Handles utilizados no programa */
PROCEDURE InitHandles:
   IF NOT VALID-HANDLE(wgbosc030) THEN DO:
      RUN scbo/bosc030.p PERSISTENT SET wgbosc030 NO-ERROR.
      RUN openQueryStatic IN wgbosc030 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc032) THEN DO:
      RUN scbo/bosc032.p PERSISTENT SET wgbosc032 NO-ERROR.
      RUN openQueryStatic IN wgbosc032 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc044) THEN DO:
      RUN scbo/bosc044.p PERSISTENT SET wgbosc044 NO-ERROR.
      RUN openQueryStatic IN wgbosc044 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc047) THEN DO:
      RUN scbo/bosc047.p PERSISTENT SET wgbosc047 NO-ERROR.
      RUN openQueryStatic IN wgbosc047 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc079) THEN DO:
      RUN scbo/bosc079.p PERSISTENT SET wgbosc079 NO-ERROR.
      RUN openQueryStatic IN wgbosc079 (INPUT "Main":U) NO-ERROR.
   END.
    
   IF NOT VALID-HANDLE(wgbosc092) THEN DO:
      RUN scbo/bosc092.p PERSISTENT SET wgbosc092 NO-ERROR.
      RUN openQueryStatic IN wgbosc092 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc096) THEN DO:
      RUN scbo/bosc096.p PERSISTENT SET wgbosc096 NO-ERROR.
      RUN openQueryStatic IN wgbosc096 (INPUT "Main":U) NO-ERROR.
   END.
    
   IF NOT VALID-HANDLE(wgbosc135) THEN DO:
      RUN scbo/bosc135.p PERSISTENT SET wgbosc135 NO-ERROR.
      RUN openQueryStatic IN wgbosc135 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbosc152) THEN DO:
      RUN scbo/bosc152.p PERSISTENT SET wgbosc152 NO-ERROR.
      RUN openQueryStatic IN wgbosc152 (INPUT "Main":U) NO-ERROR.
   END.

   IF NOT VALID-HANDLE(wgbcapiwms) THEN
      RUN bcp/bcapiwms.p PERSISTENT SET wgbcapiwms NO-ERROR.
END PROCEDURE.

FINALLY:
   IF NOT lMenu AND THIS-PROCEDURE:PERSISTENT THEN
      DELETE PROCEDURE THIS-PROCEDURE.
  
   RETURN 'OK':U.
END FINALLY.
