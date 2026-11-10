/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9022J 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC9022J MBC}
&ENDIF


/********************************************************************************************
**   Programa..: bc9022j.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Packing List WMS                 **
**                                                                                         **
********************************************************************************************/
{include/i_dbinst.i}  /* versao das bases e bases instaladas */
&if '{&mgscm_version}' >= '2.04' &then 
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

Define SHARED Temp-table ttWork           No-Undo like {&TempTable}.
DEFINE SHARED TEMP-TABLE tt-tarefa-resumo NO-UNDO LIKE wm-tarefa-resumo-pedido.

DEFINE INPUT PARAMETER pRowid AS ROWID.

Define Variable wgBOSC126   As Widget-handle No-undo.

FIND FIRST ttWork NO-ERROR.
FIND FIRST tt-tarefa-resumo WHERE rowid(tt-tarefa-resumo) = pRowid NO-ERROR.

DEFINE BUFFER bttWork FOR ttWork.

/************************************************************/

/* Variaveis de trabalho ---                                */              

Define Variable vLogOk             As Logical   Init No  No-undo.
Define Variable vLogRetorna        AS Logical   Init No  No-undo.
Define NEW SHARED Variable vLogEsc As Logical   Init No  No-undo.
DEFINE VARIABLE c-situacao         AS CHARACTER          NO-UNDO.
/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/************************************************************/
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Packing List WMS'                                 At Row 01 Col 01                         ~
                             '-------------------'                              At Row 02 Col 01                         ~
                             'Vol Pack:'                                        At Row 03 Col 01                         ~
                             ttWork.num-volume-pack                             At Row 03 Col 11 No-label                ~
                             '1-Empac/2-Estor:'                                 At Row 04 Col 01                         ~
                             ttWork.tip-movimento                               At Row 04 Col 18 No-label                ~
                             'Ser:'                                             At Row 05 Col 01                         ~
                             ttWork.num-serial                                  At Row 05 Col 05 No-label                ~
                             'Embalag:'                                         At Row 06 Col 01                         ~
                             ttWork.cod-volume                                  At Row 06 Col 09 No-label                ~
                             'Volume:'                                          At Row 07 Col 01                         ~
                             ttWork.num-volume                                  At Row 07 Col 08 No-label                ~
                             'Qtd Lidos:'                                       AT ROW 08 COL 01                         ~
                             qtd-etiquetas                                      AT ROW 08 COL 14 NO-LABEL                ~
&global-define Frame01Repeat No
/************************************************************/

/* Definicao da Frame02 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   {&Frame01Defs}
&global-define Frame02Repeat Yes

/************************************************************/

&global-define Update01Fields ttWork.num-volume-pack ttWork.tip-movimento

&global-define Update02Fields ttWork.num-serial 

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 
&global-define TriggerBeforeFrame02 Run InicializaCamposFrame02. If vLogRetorna Then Apply 'End-Error':U To Frame frame02.

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. 
&global-define TriggerAfterFrame02  Run GravaCamposFrame02. if return-value = "OKF":U then return "OK":U.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers 

/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject3 wgBOSC126

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
Run scbo/bosc126.p Persistent Set wgBOSC126.

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
    ASSIGN vLogFinaliza = NO
           vLogRetorna  = No.

    Assign ttWork.num-volume-pack = 0
           ttWork.num-volume      = 0
           ttWork.num-serial      = 0
           ttWork.cod-volume      = ''
           ttWork.tip-movimento   = 0
           qtd-etiquetas          = 0
           cod-volume-pack        = 0.

    Disp ttWork.num-volume
         ttWork.num-serial
         ttWork.cod-volume 
         ttWork.tip-movimento
         qtd-etiquetas With Frame frame01.

    Pause 0 No-message.

    Assign ttWork.cod-estabel    = tt-tarefa-resumo.cod-estabel
           ttWork.cod-local      = tt-tarefa-resumo.cod-local
           ttWork.cdd-embarq     = tt-tarefa-resumo.cdd-embarq
           ttWork.num-resumo     = tt-tarefa-resumo.nr-resumo
           ttWork.num-documento  = tt-tarefa-resumo.id-docto
           ttWork.num-tarefa     = tt-tarefa-resumo.id-tarefa
           ttWork.cod-pedcli     = tt-tarefa-resumo.nr-pedcli 
           ttWork.nom-abrev      = tt-tarefa-resumo.nome-abrev.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame02}.                      **
****************************************************************************************************/
Procedure InicializaCamposFrame02:

    Assign ttWork.num-volume    = 0
           ttWork.num-serial    = 0
           ttWork.cod-volume    = ''.

    Disp ttWork.num-volume-pack
         ttWork.num-volume
         ttWork.cod-volume 
         ttWork.tip-movimento
         qtd-etiquetas With Frame frame02.

    ASSIGN vLogSai = NO vLogFinaliza = NO.

End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    Assign vLogErro = No.

    If  ttWork.num-volume-pack = 0 Then Do:
        Assign vLogErro = Yes.
        Hide All No-pause.
        {bcp/bc9105.i "101" "Volume Packing Inv lido. (DC)"}
        View Frame Frame01.
        Pause 0 No-message.
        Return Error.
    End.

    Assign {&TempTable}.num-volume-pack = ttWork.num-volume-pack
           vLogRetorna = NO.

    RUN retornaStatusPacking In wgBOSC126(Input  ttwork.cod-estabel,
                                          Input  ttwork.cod-local,
                                          Input  ttwork.cdd-embarq,
                                          Input  ttwork.num-resumo,
                                          Input  ttwork.cod-pedcli,
                                          Input  ttwork.nom-abrev, 
                                          Input  ttwork.num-volume-pack,
                                          OUTPUT c-situacao).
    IF c-situacao = "Encerrado" Then do:
       Assign vLogErro = Yes.
       {bcp/bc9105.i "102" "Volume Packing j  foi encerrado. (WMS)"}
       View Frame Frame01.
       Pause 0 No-message.
       Return Error.
    END.

    IF {&TempTable}.num-volume-pack <> cod-volume-pack THEN DO:
        RUN countPackingList In wgBOSC126(Input  ttwork.cod-estabel,
                                          Input  ttwork.cod-local,
                                          Input  ttwork.cdd-embarq,
                                          Input  ttwork.num-resumo,
                                          Input  ttwork.cod-pedcli,
                                          Input  ttwork.nom-abrev, 
                                          Input  ttwork.num-volume-pack,
                                          OUTPUT qtd-etiquetas).
        ASSIGN cod-volume-pack = {&TempTable}.num-volume-pack.
    END.

    If ttWork.tip-movimento < 1 
    or ttWork.tip-movimento > 2
    Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "103" "As op‡äes dispon¡veis sÆo 1 - Empacotar e 2 - Estornar. (DC)"}
        View Frame Frame02.
        Pause 0 No-message.
        Return Error.
     END.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame02}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame02:

    Assign vLogErro = No vLogSai = No vLogFinaliza = NO vLogRetorna = NO.

    IF  ttWork.num-serial = 0 THEN DO:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "501" "Serial Inv lido. (WMS)"}
        View Frame Frame02.
        Pause 0 No-message.
        Return Error.
    END.
    ELSE DO:
        IF  ttWork.num-serial <> 777777 AND
            ttWork.num-serial <> 999999 Then Do:
            RUN VerificaExistenciaPacking In wgBOSC126(Input  ttwork.cod-estabel,
                                                       Input  ttwork.cod-local,
                                                       Input  ttwork.cdd-embarq,
                                                       INPUT  ttwork.num-resumo,
                                                       Input  ttwork.cod-pedcli,
                                                       Input  ttwork.nom-abrev, 
                                                       Input  ttwork.num-serial).
            IF RETURN-VALUE <> 'OK':U THEN DO:
               ASSIGN vLogErro = Yes.
               {bcp/bc9105.i "501" "Serial Inv lido. (WMS)"}
               View Frame Frame02.
               Pause 0 No-message.
               Return Error.
            END.
        END.
    End.

    /* Verifica se foi solicitado o estorno do packing list */
    If  ttWork.tip-movimento = 2 Then Do:
        Hide All No-pause.
        HIDE FRAME frame02.
        Pause 0 No-message.

        Run bcp/bc9022z.p.

        IF vLogEsc = YES THEN RETURN ERROR.

        Hide All No-pause.

        Disp ttWork.cod-volume 
             ttWork.num-volume
             ttWork.num-serial With Frame Frame02.

        Pause 5 No-message.

        Find First ttWork NO-ERROR.

        Assign ttWork.log-finaliza = No.
    End. 

    If  ttWork.num-serial = 777777 Then Do:
        ASSIGN vLogEsc = NO.
        Hide All No-pause.
        HIDE FRAME frame02.
        Pause 0 No-message.

        Run bcp/bc9022z.p.

        IF vLogEsc = YES THEN RETURN ERROR.

        Hide All No-pause.

        Disp ttWork.cod-volume 
             ttWork.num-volume
             ttWork.num-serial With Frame Frame02.

        Pause 5 No-message.

        Find First ttWork NO-ERROR.

        Assign ttWork.log-finaliza = No.
    End. 

    If  ttWork.num-serial = 777777 Then
        Assign ttWork.num-serial = 0.

    If  ttWork.num-serial = 999999 Then Do:
        Hide All No-pause.
        HIDE FRAME frame02.
        Pause 0 No-message.

        Assign vLogOk = No.

        /* Projeto Internacional -- Traducao de DISPLAY. Validar e verificar possibilidade de colocar em FRAME */
        DEFINE VARIABLE c-lbl-liter-encerrar-volume AS CHARACTER FORMAT "X(18)" NO-UNDO.
        {utp/ut-liter.i "Encerrar_Volume?" *}
        ASSIGN c-lbl-liter-encerrar-volume = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-1sim-2nao AS CHARACTER FORMAT "X(13)" NO-UNDO.
        {utp/ut-liter.i "1=Sim_2=Nao" *}
        ASSIGN c-lbl-liter-1sim-2nao = TRIM(RETURN-VALUE).
        Disp c-lbl-liter-encerrar-volume At Row 01 Col 01 NO-LABEL                                             
             c-lbl-liter-1sim-2nao       At Row 02 Col 01 NO-LABEL With Frame f-conf Font 2 Size 20 By 8 No-box.

        Update vLogOk At Row 02 Col 13 No-label Format '1/2' With Frame f-conf Font 2 Size 20 By 8.

        Hide All No-pause.
        View Frame Frame02.
        Pause 0 No-message.

        If vLogOK = No Then Return 'NOK':U.

        Assign ttWork.log-finaliza = Yes
               vLogFinaliza        = Yes
               vLogRetorna         = Yes.
    End. 

    Hide All No-pause.
    HIDE Frame Frame02.
    Pause 0 No-message.
    Run gravaTransacao.
    return return-value.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.

    Buffer-copy ttWork To {&TempTable}.

    Assign vTransDetail = " Usr:"  + String({&TempTable}.cod-usuario)                      +   
                          " Col:"  + String({&TempTable}.cod-coletor)                      +
                          " Equ:"  + String({&TempTable}.cod-equipamento)                  +
                          " Doc:"  + String({&TempTable}.num-documento)                    +
                          " Vol:"  + String({&TempTable}.num-volume-pack)                  +
                          " Ser:"  + String({&TempTable}.num-serial,'999999999999999').

    Assign vNomeUsuario = ttWork.cod-usuario.

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */ 

    Assign ttWork.log-inicializa = No.

    If Return-value <> 'NOK':U Then Do:
       If Not ttWork.log-finaliza Then Do:
           IF ttWork.tip-movimento = 1 THEN DO:
              {bcp/bc9105.i "902" "Empacotado!"}
              ASSIGN qtd-etiquetas = qtd-etiquetas + 1.
           END.
           ELSE DO:
               {bcp/bc9105.i "903" "Estornado!"}
               ASSIGN qtd-etiquetas = qtd-etiquetas - 1.
           END.
           RETURN 'OK':U.
       End.
       Else Do:
          {bcp/bc9105.i "903" "Pack Finalizado!"}
          return 'OKF':U.
       End.
    End. 
End Procedure.
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif


/*************************************  Codigo do Usuario Fim   **********************************/



