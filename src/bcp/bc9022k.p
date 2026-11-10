/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9022K 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9022K MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9022k.p                                                                 **
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
Define SHARED Temp-table ttWork No-Undo like {&TempTable}.

FIND FIRST ttWork NO-ERROR.

/************************************************************/

/* Variaveis de trabalho ---                                */              

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/************************************************************/
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Packing List'                                     At Row 01 Col 01                         ~
                             '-------------------'                              At Row 02 Col 01                         ~
                             'Vol Pack:'                                        At Row 03 Col 01                         ~
                             ttWork.num-volume-pack                             At Row 03 Col 11 No-label                ~
                             'Nr Serial:'                                       At Row 04 Col 01                         ~
                             ttWork.num-serial                                  At Row 05 Col 01 No-label                ~
                             'Embalag:'                                         At Row 06 Col 01                         ~
                             ttWork.cod-volume                                  At Row 06 Col 09 No-label                ~
                             'Volume:'                                          At Row 07 Col 01                         ~
                             ttWork.num-volume                                  At Row 07 Col 08 No-label                ~
                             'Qtd Lidos:'                                       AT ROW 08 COL 01                         ~
                             qtd-etiquetas                                      AT ROW 08 COL 14 NO-LABEL                ~
&global-define Frame01Repeat No

&global-define Update01Fields ttWork.cod-volume ttWork.num-volume

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. IF vLogFinaliza = YES THEN RETURN.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.      IF vLogFinaliza = YES THEN RETURN.
                                                                                              
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers 
                            
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
/*&global-define ActiveObject1 */

/*****************************************   Frames Fim ******************************************/

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

    ASSIGN vLogFinaliza = NO.
    
    Assign ttWork.num-volume      = 0
           ttWork.cod-volume      = ''.
    Disp ttWork.num-volume-pack
         ttWork.num-serial 
         qtd-etiquetas With Frame frame01.
    Pause 0 No-message.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 01.                                                                              **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    Assign vLogErro = No.

    If   ttWork.num-volume = 0 Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "101" "Volume Inv lido. (DC)"}
         Return Error.
    End. 
    If   ttWork.cod-volume = '' Then Do:
         Assign vLogErro = Yes.
         {bcp/bc9105.i "102" "Embalagem Inv lida. (DC)"}
         Return Error.
    End. 

    Assign vLogFinaliza = Yes.

End Procedure.

