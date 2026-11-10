/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9023A 2.00.00.003 } /*** "010003" 19/03/2024 10:34:37  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc9023a MBC}
&ENDIF


/* Alterado por Amarildo Gambeta
Substitu¡da a chamada do m‚todo "getLocalizacaoEtiqueta" da BO "bosc112.p" 
pelo m‚todo "getSerialAdrress" da BO "BOSC074" (conforme orientado pela  rea 
de neg¢cio na FO 1.363.764) para busca do endere‡o correto de armazenamento 
da etiqueta. 
** FOI ALTERADA A DOCUMENTA€ÇO DO PRODUTO PARA CONTEMPLAR A NOVA FORMA DE CONSULTA (SEM STATUS E SOMENTE AS ETIQUETAS ARMAZENADAS) - 
Definido em conjunto com a equipe de servi‡os e Desenvolviemnto.
*/
/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versao das bases e bases instaladas */
/********************************************************************************
** Copyright DATASUL S.A. (2002)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bc9023.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - karla Klemke - Cria‡Æo do programa          **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Consulta de Endere‡o WMS         **
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
&global-define ProgramName BC9023
/************************************************************/

{utp/utapi009.i} /* login */
/* Definicao da temp-table de integracao ---                */
{bcp/bc9023.i}
&global-define TempTable tt-consulta
Define Temp-table ttWork No-Undo like {&TempTable}.
Create ttWork.
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

Define Query qry-etiq-mensagem FOR tt-etiq-consulta SCROLLING.

Define Browse brw-etiq-mensagem Query qry-etiq-mensagem
    Display 
        tt-etiq-consulta.num-docto         
        tt-etiq-consulta.cod-estabel       
        tt-etiq-consulta.cod-local         
        tt-etiq-consulta.c-ind-origem-docto
         With NO-BOX Size 20 By 5.

DEFINE INPUT PARAMETER pi-serial AS DECIMAL      FORMAT '>>>>>>>>>>>>>>':U NO-UNDO.

/************************************************************/

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Consult Endere‡o WMS'   At Row 01 Col 01  ~
                             '--------------------'   At Row 02 Col 01  ~
                              brw-etiq-mensagem       AT Row 03 Col 01  ~
&global-define Frame01Repeat NO
/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-etiq-mensagem

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.  IF vLogSai = Yes Then do: LEAVE _frame01. END.
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~

/************************************************************/

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgBOSC074

/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
RUN scbo/bosc074.p PERSISTENT SET wgbosc074.
RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */

/**************************************************************************************************/

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
   IF RETURN-VALUE = 'ESC':U THEN DO:
      ASSIGN vlogfinaliza = YES.
      RETURN.
   END.
   
   EMPTY TEMP-TABLE tt-etiq-consulta.
   
   ASSIGN vLogErro     = NO
          vLogsai      = NO
          vLogfinaliza = NO.
   
   RUN getSituacaoEtiqueta IN wgbosc074 (INPUT pi-serial,
                                         OUTPUT TABLE tt-etiq-consulta).
   
   OPEN QUERY qry-etiq-mensagem
     FOR EACH tt-etiq-consulta
           BY tt-etiq-consulta.num-docto.
   
   ASSIGN vLogFinaliza = NO
          vLogSai      = NO.
          vLogErro     = NO.

END PROCEDURE.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01. Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.     **
****************************************************************************************************/
