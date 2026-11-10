/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9019N 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9019N MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9019n.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - outubro/2002 - Karen - Cria‡Æo do programa                  **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Packing WMS                      **
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
&global-define ProgramName BC9019
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-packing-wms
{bcp/bc9019.i " "}
Define SHARED Temp-table ttWork No-Undo like {&TempTable}.

DEFINE TEMP-TABLE tt-itens NO-UNDO
    FIELD cod-item    LIKE wm-docto-itens.cod-item
    FIELD cod-lote    LIKE wm-docto-itens.cod-lote
    FIELD cod-refer   LIKE wm-docto-itens.cod-refer
    FIELD dt-validade LIKE wm-docto-itens.dt-validade
    FIELD qtd-item    LIKE wm-docto-itens.qtd-item.

/************************************************************/

/* Variaveis de trabalho ---                                */              
Define Variable vQtdItem                As Integer              Init 0   No-undo.
Define Variable wgbosc099               As Widget-handle                 No-undo.

DEFINE INPUT  PARAMETER vDescSit  AS CHARACTER NO-UNDO.

FIND FIRST ttWork NO-ERROR.
ASSIGN vQtdItem = ttWork.qtd-item.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/************************************************************/
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Packing '                                      At Row 01 Col 01                         ~
                             vDescSit                                        At Row 01 Col 09 NO-LABEL FORMAT 'x(07)' ~
                             'Volu:             '                            At Row 02 Col 01                         ~
                             ttWork.cod-volume                               At Row 02 Col 06 No-label                ~
                             'NumV:             '                            At Row 03 Col 01                         ~
                             ttWork.num-volume                               At Row 03 Col 06 No-label                ~
                             'Item: '                                        At Row 04 Col 01                         ~
                             ttWork.cod-item                                 At Row 04 Col 06 Format 'x(16)' No-label VIEW-AS FILL-IN SIZE 13 BY 0.88 ~
                             'Qtde:'                                         At Row 05 Col 01                         ~
                             ttWork.qtd-item                                 At Row 05 Col 06 No-label Format '>>>>>9'~
                             'Lt:'                                           At Row 06 Col 01                         ~
                             ttWork.cod-lote                                 At Row 06 Col 04 NO-LABEL FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Refe:'                                         At Row 07 Col 01                         ~
                             ttWork.cod-refer                                At Row 07 Col 06 No-label                ~
                             'Vali:'                                         At Row 08 Col 01                         ~
                             ttWork.dat-validade                             At Row 08 Col 06 No-label                
&global-define Frame01Repeat No

/************************************************************/

&global-define Update01Fields  ttWork.qtd-item

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogErro = No Then Return 'OK':U.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers 
                            
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc099

/******************************************* Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

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
Procedure InicializaCamposFrame01:
     DISP ttWork.cod-volume  
          ttWork.num-volume  
          ttWork.cod-item    
          ttWork.qtd-item    
          ttWork.cod-lote    
          ttWork.cod-refer   
          ttWork.dat-validade
          vDescSit WITH FRAME frame01.
End Procedure.
     
/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    Assign vLogErro = No.

    Run scbo/bosc099.p Persistent Set wgbosc099 No-error.

    IF ttWork.log-estorna THEN
        RUN getItensPackingEstorno In wgbosc099 (Input ttWork.cod-estabel, 
                                                 Input ttWork.cod-local, 
                                                 Input ttWork.cdd-embarq, 
                                                 Input ttWork.num-resumo,
                                                 Input ttWork.cod-pedcli,
                                                 Input ttWork.nom-abrev,
                                                 Input ttWork.num-documento,
                                                 INPUT ttWork.cod-volume,
                                                 INPUT ttWork.num-volume,
                                                 Output Table tt-itens).

    ELSE
        RUN getItensPacking In wgbosc099 (Input ttWork.cod-estabel, 
                                          Input ttWork.cod-local, 
                                          Input ttWork.cdd-embarq, 
                                          Input ttWork.num-resumo,
                                          Input ttWork.cod-pedcli,
                                          Input ttWork.nom-abrev,
                                          Input ttWork.num-documento,
                                          Output Table tt-itens).

    IF VALID-HANDLE(wgbosc099) THEN RUN destroy IN wgbosc099.

    FIND tt-itens WHERE 
         tt-itens.cod-item = ttwork.cod-item NO-LOCK NO-ERROR.
    IF AVAIL tt-itens THEN
       ASSIGN vQtdItem            = tt-itens.qtd-item
              ttWork.cod-lote     = tt-itens.cod-lote   
              ttWork.cod-refer    = tt-itens.cod-refer
              ttWork.dat-validade = tt-itens.dt-validade.


    If   ttWork.qtd-item = 0 Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "503" "Qtde Inv lida. (WMS)"}
         View Frame Frame02.
         Pause 0 No-message.
         Return Error.
    End.

    If   ttWork.qtd-item > vQtdItem Then do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "504" "Qtde Excedente. (WMS)"}
         View Frame Frame02.
         Pause 0 No-message.
         Return Error.
    End.
    Return 'OK':U.
End Procedure.



