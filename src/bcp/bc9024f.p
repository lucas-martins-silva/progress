/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024F 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024f MBC}
&ENDIF


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
**   Programa..: bc9024f.p                                                                 **
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
**                        Ex: &global-define ActiveObject wgbosc074                               **
***************************************************************************************************/

                                 /* Definicao global do nome da transacao ---                */
&global-define ProgramName bc9024
/************************************************************/
&global-define TempTable tt-inventario-wms
{bcp/bc9024.i}

/* Definicao da temp-table de integracao ---                */

Define Input Parameter  vCodEstabel As Character No-undo.
Define Input Parameter  vCodLocal   As Character No-undo.
Define Output Parameter vIdBox As Integer Format ">>>>>>>>>9" No-undo.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Invent rio WMS'                                  At Row 01 Col 01                         ~
                             '-----------------'                               At Row 02 Col 01                         ~
                             'Box:'                                            At Row 03 Col 01                         ~
                             vIdBox                                            At Row 04 Col 01 No-label                ~
                             'Bloco:'                                          At Row 05 Col 01                         ~
                             vCodBloco                                         At Row 05 Col 08 No-label                ~
                             'Rua:'                                            At Row 06 Col 01                         ~
                             vCodRua                                           At Row 06 Col 08 No-label                ~
                             'N¡vel:'                                          At Row 07 Col 01                         ~
                             vCodNivel                                         At Row 07 Col 08 No-label                ~
                             'Coluna:'                                         At Row 08 Col 01                         ~
                             vCodColuna                                        At Row 08 Col 08 No-label
&global-define Frame01Repeat No

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields vCodBloco vCodRua vCodNivel vCodColuna
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01.
/* Definicao das trigger de usuario ---                     */ 
/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ON END-ERROR OF FRAME {&Frame01Name} ~
                            DO:                                  ~
                                Return 'ESC':U.                    ~
                            END.                                 ~
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030

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

    Disp vIdBox With Frame frame01.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    IF NOT VALID-HANDLE(wgbosc030)  THEN DO:
       Run scbo/bosc030.p Persistent Set wgbosc030.
       Run openQueryStatic In wgbosc030 (Input "Main":U) No-error.
    END.

    Run emptyRowErrors In wgbosc030.

    Run GotoKeyAux   In wgbosc030 (input  vCodEstabel, 
                                   Input  vCodLocal,   
                                   Input  vCodBloco,   
                                   Input  vCodRua,   
                                   Input  vCodNivel,  
                                   Input  vCodColuna).

    If  Return-value <> 'OK':U Then Do:
        Run getRowErrors In wgbosc030(Output Table RowErrors).
        IF NOT CAN-FIND(FIRST RowErrors) THEN DO:
            {bcp/bc9105.i "102" "Endere‡o Inexistente no WMS (WMS)"}.
        END.
        ELSE DO:
            For Each RowErrors:
                ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
                Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).    
            End.
        END.
        Assign vLogErro = Yes.
        Return Error.
    End. /* Return-value <> 'OK' */

    Run emptyRowErrors In wgbosc030.

    Run GetDecField   In wgbosc030 (input  "Id-Box":U, 
                                    Output vIdBox).

    If  Return-value <> 'OK':U Then Do:

        Run getRowErrors In wgbosc030(Output Table RowErrors).
        For Each RowErrors:
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).    
        End.
        Assign vLogErro = Yes.
        Return Error.
    End. /* Return-value <> 'OK' */

    Assign vLogSai = Yes
           vLogFinaliza = Yes.

    IF VALID-HANDLE(wgbosc030) THEN RUN destroy IN wgbosc030.

End Procedure.

/*************************************  Codigo do Usuario Fim   **********************************/
