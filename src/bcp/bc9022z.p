/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9022Z 2.00.00.010 } /*** "010010" 19/03/2024 08:52:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9022z MBC}
&ENDIF

/********************************************************************************************
**   Programa..: bc9022z.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Packing List WMS                 **
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
**                        Ex: tt-packing-wms.                                                     **
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
&global-define ProgramName BC9022
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-packing-wms
{bcp/bc9022.i " "}
{bcp/bc9022.i1 " "}

DEFINE TEMP-TABLE tt-Packing NO-UNDO
            FIELD cod-estabel      LIKE estabelec.cod-estabel
            FIELD cod-local        AS CHARACTER FORMAT "X(3)"
            FIELD cdd-embarq       AS DECIMAL   FORMAT ">>>>>>>>>>>>>>>9"
            FIELD nr-resumo        AS INTEGER   FORMAT ">>>>,>>9"
            FIELD cod-volume       AS CHARACTER FORMAT "X(10)"
            FIELD num-seq-volume   AS INTEGER   FORMAT ">>>>>9"
            FIELD num-volume       AS INTEGER   FORMAT ">>>,>>>,>>9"
            FIELD dt-transacao     AS DATE      FORMAT "99/99/9999"
            FIELD id-docto         AS DECIMAL   FORMAT ">>>>>>>>>9"
            FIELD id-tarefa        AS DECIMAL   FORMAT ">>>>>>>>>9"
            FIELD usuario          AS CHARACTER FORMAT "x(12)"
            FIELD nr-pedcli        AS CHARACTER FORMAT "X(12)"
            FIELD nome-abrev       AS CHARACTER FORMAT "X(12)"
            FIELD vol-packing-list AS INTEGER   FORMAT ">>>>>9"
            FIELD id-etiqueta      AS DECIMAL   FORMAT ">>>>>>>>>>>>>9"
            FIELD cod-item         AS CHARACTER FORMAT "X(16)"
            FIELD des-item         AS CHARACTER FORMAT "X(60)"
            FIELD qtd-item         AS DECIMAL   FORMAT ">>>,>>>,>>9.9999"
            FIELD qtd-peso         AS DECIMAL   FORMAT ">,>>>,>>9.9999"
            INDEX packing IS PRIMARY cod-estabel
                                     cod-local
                                     cdd-embarq
                                     nr-resumo
                                     nr-pedcli
                                     nome-abrev
                                     num-seq-volume.
                                    
DEFINE SHARED TEMP-TABLE ttWork NO-UNDO LIKE {&TempTable}.

FIND FIRST ttWork NO-ERROR.

/************************************************************/
DEFINE SHARED VARIABLE vLogEsc          AS LOGICAL              INIT NO  NO-UNDO.

/* Variaveis de trabalho ---                                */              
DEFINE VARIABLE vCodOpcao               AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vCodTipoEquip           AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vCodEmbalagem           AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vCodItem                AS CHARACTER            INIT ''  NO-UNDO.
DEFINE VARIABLE vNumCont                AS INTEGER              INIT 0   NO-UNDO.
DEFINE VARIABLE vNumVolumeTMP           AS INTEGER              INIT 0   NO-UNDO.
DEFINE VARIABLE vNumSeq                 AS INTEGER              INIT 0   NO-UNDO.
DEFINE VARIABLE vLogOk                  AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE vLogAtivo               AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE vLogProcesso            AS LOGICAL              INIT NO  NO-UNDO.
DEFINE VARIABLE v-cod-estabel           AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE v-cod-local             AS CHARACTER                     NO-UNDO.
DEFINE VARIABLE wgBOSC100               AS WIDGET-HANDLE                 NO-UNDO.

DEFINE TEMP-TABLE tt-zoom NO-UNDO
            FIELD cod-volume       AS CHARACTER FORMAT 'X(07)'
            FIELD num-volume       AS INTEGER   FORMAT '999999'
            FIELD id-etiqueta      LIKE ttWork.Num-Serial
            FIELD cod-item         AS CHARACTER FORMAT "X(16)"
            FIELD des-item         AS CHARACTER FORMAT "X(60)"
            FIELD qtd-item         AS DECIMAL   FORMAT ">>>,>>>,>>9.9999"
            FIELD qtd-peso         AS DECIMAL   FORMAT ">,>>>,>>9.9999"
            FIELD num-seq-volume   AS INTEGER   FORMAT ">>>>>9".

DEFINE QUERY qry-zoom FOR tt-zoom.             

DEFINE BROWSE brw-zoom QUERY qry-zoom NO-LOCK
            DISPLAY tt-zoom.cod-volume 
                    tt-zoom.num-volume 
                    tt-zoom.id-etiqueta
               WITH NO-BOX NO-LABELS SIZE 20 BY 5 NO-SCROLLBAR-VERTICAL.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs 'Zoom Packing List'                              At Row 01 Col 01   ~
                           '-----------------'                              At Row 02 Col 01   ~
                           brw-zoom                                         At Row 03 Col 01   

&global-define Frame01Repeat No

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-zoom
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. Assign vLogSai = Yes vLogFinaliza = YES vLogEsc = NO. 

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON 'return':U OF brw-zoom In Frame Frame01 ~
                            DO:                                        ~
                                Apply 'GO':U To This-procedure.        ~
                            END.                                       ~
                            ON 'ESC':U OF Frame Frame01                ~
                            DO:                                        ~
                                ASSIGN vLogEsc = YES.                  ~
                            END.                        


/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC100
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc100.p PERSISTENT SET wgBOSC100 NO-ERROR.

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
   EMPTY TEMP-TABLE tt-zoom.
   
   IF ttwork.tip-movimento = 1 THEN DO:
      RUN pesquisaPackingEmbarque IN wgBOSC100 (INPUT ttWork.cod-estabel, 
                                                INPUT ttWork.cod-local, 
                                                INPUT ttWork.cdd-embarq, 
                                                INPUT ttWork.num-resumo,
                                                INPUT ttWork.cod-pedcli,
                                                INPUT ttWork.nom-abrev,
                                                OUTPUT TABLE tt-Packing).
   END.
   ELSE DO:
      RUN pesquisaPackingListEstorno IN wgBOSC100 (INPUT ttWork.cod-estabel, 
                                                   INPUT ttWork.cod-local, 
                                                   INPUT ttWork.cdd-embarq, 
                                                   INPUT ttWork.num-resumo,
                                                   INPUT ttWork.cod-pedcli,
                                                   INPUT ttWork.nom-abrev,
                                                   INPUT ttWork.num-volume-pack,
                                                   OUTPUT TABLE tt-Packing).
   END.
   
   FOR EACH tt-Packing: 
      BUFFER-COPY tt-Packing TO tt-zoom.
      RELEASE tt-zoom.
   END.
   
   OPEN QUERY qry-zoom
     FOR EACH tt-zoom
           BY tt-zoom.cod-volume. 
END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
PROCEDURE GravaCamposFrame01:
   /* Validacoes Frame 01 Inicio --- */
   IF NOT AVAIL tt-zoom THEN DO:
      RETURN.
   END.
   
   ASSIGN ttWork.cod-volume     = tt-zoom.cod-volume
          ttWork.num-volume     = tt-zoom.num-volume
          ttWork.num-serial     = tt-zoom.id-etiqueta
          ttWork.cod-item       = tt-zoom.cod-item
          ttWork.des-item       = tt-zoom.des-item
          ttWork.qtd-item       = tt-zoom.qtd-item
          ttWork.qtd-peso       = tt-zoom.qtd-peso
          ttWork.num-seq-volume = tt-zoom.num-seq-volume.
END PROCEDURE.

/*************************************  Codigo do Usuario Fim   **********************************/



