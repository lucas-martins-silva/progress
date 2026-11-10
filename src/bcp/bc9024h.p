/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9024H 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9024h MBC}
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
**   Programa..: bc9024h.p                                                                 **
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
&global-define ProgramName BC9024
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-inventario-wms
{bcp/bc9024.i}

Define Temp-table ttWork NO-UNDO Like {&TempTable}.

Define Input Parameter pDesEndereco As Character Format "x(11)" No-undo.
Define Input Parameter vQtdItems As Integer No-undo.
Define Input-output Parameter Table For ttWork.

DEFINE VARIABLE wgbosc145 AS WIDGET-HANDLE     NO-UNDO.

Find First ttWork NO-ERROR.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Item:              '     At Row 01 Col 01                         ~
                             ttWork.cod-item           At Row 02 Col 01 No-label                ~
                             'Lote:              '     At Row 03 Col 01                         ~
                             ttWork.cod-lote           At Row 04 Col 01 No-label VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Referˆncia:        '     At Row 05 Col 01                         ~
                             ttWork.cod-refer          AT ROW 06 COL 01 NO-LABEL                ~
                             'Valid.:'                 At Row 07 Col 01                         ~
                             ttWork.dat-validade       At Row 07 Col 08 No-label                ~
                             'Lidos:'                  At Row 08 Col 01                         ~
                             vQtdItems                 At Row 08 Col 07 No-label Format '>>>>9'
&global-define Frame01Repeat No

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   {&Frame01Defs}
&global-define Frame02Repeat No

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   {&Frame01Defs}
&global-define Frame03Repeat No

/* Definicao da Frame04 ---                                 */
&global-define Frame04Name   Frame04
&global-define Frame04Defs   {&Frame01Defs}
&global-define Frame04Repeat No

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.cod-item
&global-define Update02Fields ttWork.cod-lote
&global-define Update03Fields ttWork.cod-refer    WHEN  ttWork.ind-tipo-contr-est = 4
&global-define Update04Fields ttWork.dat-validade WHEN  vcontrol = YES
                                  
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogSai = Yes Then Return 'OK':U.
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. If vLogSai = Yes Then Return 'OK':U.
&global-define TriggerBeforeFrame03 Run InicializaCamposFrame03. 
&global-define TriggerAfterFrame03  Run GravaCamposFrame03.
&global-define TriggerBeforeFrame04 Run InicializaCamposFrame04. 
&global-define TriggerAfterFrame04  Run GravaCamposFrame04. If vLogSai = Yes Then Return 'OK':U.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers 
/************************************************************/
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc044
&global-define ActiveObject2 wgbosc051
&global-define ActiveObject3 wgbosc058
&global-define ActiveObject4 wgbosc145
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
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    Assign 
           ttWork.cod-item             = ''  
           ttWork.cod-refer            = ''
           ttWork.cod-lote             = ''
           ttWork.dat-validade         = ?.

    Disp ttWork.cod-item 
         ttWork.cod-refer
         ttWork.cod-lote
         ttWork.dat-validade 
         vQtdItems With Frame frame01.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    Assign 
           ttWork.cod-refer            = ''
           ttWork.cod-lote             = ''
           ttWork.dat-validade         = ?.

    Disp ttWork.cod-item 
         ttWork.cod-refer
         ttWork.cod-lote
         ttWork.dat-validade 
         vQtdItems With Frame frame02.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame03:
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    Assign 
           ttWork.cod-refer            = ''
           ttWork.dat-validade         = ?.

    Disp ttWork.cod-item 
         ttWork.cod-refer
         ttWork.cod-lote
         ttWork.dat-validade 
         vQtdItems With Frame frame03.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame04:
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    ASSIGN vcontrol = NO.
    IF NOT VALID-HANDLE(wgbosc058)  THEN DO:
       Run scbo/bosc058.p Persistent Set wgbosc058.
       Run openQueryStatic In wgbosc058 (Input "Main":U) No-error.
    END.

    Run emptyRowErrors In wgbosc058.
    
    Run retornaDtValidade  In wgbosc058 (input  ttWork.cod-estabel , 
                                         INPUT  ttWork.cod-local   ,
                                         INPUT  ttWork.cod-item    , 
                                         INPUT  ttWork.cod-refer   , 
                                         INPUT  ttWork.cod-lote    , 
                                         OUTPUT ttWork.dat-validade).
   
   IF ttWork.dat-validade = ? THEN DO:
       ASSIGN ttWork.dat-validade = TODAY
              vcontrol            = YES.

   END.

   Disp ttWork.cod-item 
        ttWork.cod-refer
        ttWork.cod-lote
        ttWork.dat-validade 
        vQtdItems With Frame frame04.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    If  ttWork.Cod-Item = '' Then Do:
        Hide All.
        Assign vLogErro = Yes.
        {bcp/bc9105.i "101" "Item Inv lido (DC)"}
        Return 'NOK':U.
    End.
    IF NOT VALID-HANDLE(wgbosc044)  THEN DO:
       Run scbo/bosc044.p Persistent Set wgbosc044.
       Run openQueryStatic In wgbosc044 (Input "Main":U) No-error.
    END.

    Run emptyRowErrors In wgbosc044.
    
    Run getTipoControle  In wgbosc044 (input  ttWork.cod-item, 
                                       Output ttWork.ind-tipo-contr-est).
    /* legenda:
       1 = controle serial
       2 = controle por serie (inf lote)
       3 = controle por lote (inf lote e validade)
       4 = controle por referencia (inf lote, ref e validade) */
    
    If  Return-value <> 'OK':U Then Do:
        {bcp/bc9105.i "102" "Item Inv lido (WMS)"}
        Assign vLogErro = Yes.
        Return Error.
    End. /* Return-value <> 'OK' */

    If not valid-handle(wgbosc145) Then 
        run scbo/bosc145.p persistent set wgbosc145.

    run setConstraintItem in wgbosc145 (ttWork.cod-item).
    run openQueryStatic in wgbosc145 (input "item":U).
    If  Return-value <> 'OK':U Then Do:
        {bcp/bc9105.i "103" "Item sem embalagem relacionada. (WMS)"}
        Assign vLogErro = Yes.
        Return Error.
    End.

    IF ttWork.ind-tipo-contr-est = 1 THEN DO:
        Assign vLogSai = Yes
               vLogFinaliza = Yes.
        Hide All No-pause.
        RETURN 'OK':U.
    END.
    
    RETURN 'OK':U.
    
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    If  ttWork.Cod-lote = '' Then Do:
        Hide All.
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "Lote Inv lido (DC)"}
        Return 'NOK':U.
    End.    
    IF ttWork.ind-tipo-contr-est = 2 THEN DO:
        Assign vLogSai = Yes
               vLogFinaliza = Yes.
        ASSIGN ttWork.qtd-item = 1
               ttWork.qtd-peso = 1.
        Hide All No-pause.
        RETURN 'OK':U.
    END.
    RETURN 'OK':U.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame03:
    
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    IF ttWork.ind-tipo-contr-est = 4 THEN DO:
        If  ttWork.Cod-refer = '' Then Do:
            Hide All.
            Assign vLogErro = Yes.
            {bcp/bc9105.i "104" "Referˆncia Inv lida (DC)"}
            Return 'NOK':U.
        End.    
        IF NOT VALID-HANDLE(wgbosc051)  THEN DO:
            Run scbo/bosc051.p Persistent Set wgbosc051.
            Run openQueryStatic In wgbosc051 (Input "Main":U) No-error.
        END.

        Run emptyRowErrors In wgbosc051.
    
        Run verifyRefItem  In wgbosc051 (input  ttWork.cod-item, 
                                         INPUT ttWork.cod-refer).
        IF RETURN-VALUE <> 'OK':U THEN DO:
            Hide All.
            Assign vLogErro = Yes.
            {bcp/bc9105.i "104" "Referˆncia Inv lida (WMS)"}
            Return 'NOK':U.
        END.
    END.
    RETURN 'OK':U.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame03}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame04:

    Assign vLogSai = Yes
           vLogFinaliza = Yes.
    Hide All No-pause.
    RETURN.

End Procedure.


/*************************************  Codigo do Usuario Fim   **********************************/
