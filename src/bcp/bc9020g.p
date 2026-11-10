/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9020G 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9020g MBC}
&ENDIF


{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9025.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - Janeiro/2004 - Farley - Criaá∆o do programa                **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Transferància WMS                **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
/***************************************************************************************************
** SECAO DE PRE-PROCESSADORES DA TEMPLATE                                                         **
** Nesta secao sao definidos os pre-processadores que serao usados na montagem da interface.      **
**                                                                                                **
** DESCRICAO DOS PREPROCESSADORES:                                                                **
** ProgramName          - Nome do programa e, tambem, do Codigo da transacao do Data Collection   **
**                        que sera acionada pela interface.                                       **
** TempTable            - Nome da Temp-Table da transacao de negocio para comunicacao com ERP.    **
**                        Ex: tt-transf-wms.                                                      **
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
**                        que executa a procedure _GenerateDCTransaction que e responsavel por    **
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
&global-define ProgramName BC9020

/* Definicao da temp-table de integracao ---                */
&global-define TempTable tt-ressup-wms
{bcp/bc9020.i " "}
{bcp/bc9020.i1 " "}
DEFINE INPUT PARAMETER vRowid AS ROWID NO-UNDO.
FIND FIRST ttwm-box-movto WHERE rowid(ttwm-box-movto) = vRowid NO-ERROR.
FIND FIRST ttWork NO-ERROR.

{bcp/bc9015.i3} /* def variaveis padroes */
/* login */
{utp/utapi009.i}
define buffer bf-ttResumo for ttResumo.
define buffer bf-ttEmbSelec for ttEmbSelec.

/************************************************************/

/* Variaveis de trabalho ---                                */              
DEFINE NEW GLOBAL SHARED VARIABLE vReturn     AS CHAR                   NO-UNDO.
Define Variable vLogAnswer              As Logical                      Init YES  No-undo.
Define Variable vLogAnswer-esc          As Logical                      Init NO   No-undo.
define variable vLogFimTran             as logical                      init no   no-undo.

Define Variable vCodSenha  AS CHAR FORMAT 'x(12)':U No-undo.
Define Variable vEndereco  AS CHAR FORMAT 'x(12)':U No-undo.
Define Variable vCodBloco  AS CHAR                  No-undo.
Define Variable vCodRua    AS CHAR                  No-undo.
Define Variable vCodNivel  AS CHAR                  No-undo.
Define Variable vCodColuna AS CHAR                  No-undo. 

define variable cDispItem as character              no-undo.
define variable cEmbalSel as integer                no-undo.
define variable cTotalItem as character             no-undo.
define variable cBoxOrig   as character             no-undo.
define variable cIndex     as integer               no-undo.

Define New Shared Variable wgbosc035 As Widget-handle No-undo. 
Define New Shared Variable wgbosc145 As Widget-handle No-undo. 

define query  qSaldoItem for ttResumo.
define browse bSaldoItem query qSaldoItem no-lock
    display  cDispItem @ ttResumo.cod-item
    with size 20 by 2 No-box No-labels No-scrollbar-vertical.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Saldo Box '                                      At Row 01  Col 01           ~
                             cBoxOrig                                          at row 01  col 11 no-label  ~
                             'Emb:'                                            at row 02  col 01           ~
                             ttEmbSelec.cNumEmbal                              at row 02  col 05 no-label  ~
                             bSaldoItem                                        at row 03  col 01           ~
                             'It:'                                             at row 05  col 01           ~
                             ttResumo.cod-item                                 at row 05  col 04 format "x(15)" no-label   ~
                             'Ref:'                                            at row 06  col 01           ~
                             ttResumo.cod-refer                                at row 06  col 05 no-label  ~
                             'Lt:'                                             at row 07  col 01           ~
                             ttResumo.cod-lote                                 at row 07  col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 11 BY 0.88 ~
                             'Tot.It:'                                         at row 08  col 01           ~
                             cTotalItem                                        at row 08  col  8 no-label

&global-define Frame01Repeat yes 

/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields                               ~
               bSaldoItem                                   
               
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. 

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If Return-value = 'OK':U AND vLogFinaliza = YES  Then RETURN 'OK':U.            ~
                                                            If Return-value = 'NOK':U Then RETURN 'NOK':U.                                  ~

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers                                                                                                              ~
                            ON 'return':U OF bSaldoItem IN Frame Frame01                                                                 ~
                            DO:                                                                                                          ~
                                If not avail ttResumo Then return no-apply.                                                              ~
                                if (ttwm-box-movto.qtd-item * ttwm-box-movto.qti-embalagem) = decimal(entry(1,cTotalItem,"/")) then ~
                                    return no-apply.  ~
                                find last ttWork no-error.                                                                               ~
                                assign ttWork.cod-embalagem = ttResumo.cod-embalagem.                                                    ~
                                assign ttWork.cod-item = entry(1,ttResumo.cod-item:screen-value in browse bSaldoItem,"/")                ~
                                       ttWork.qtd-embalagem = integer(entry(2,ttEmbSelec.cNumEmbal:screen-value in frame Frame01,"/")).  ~
                                find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)).                                       ~
                                If ttWork.qtd-embalagem > integer(entry(1,ttEmbSelec.cNumEmbal,"/")) Then                                ~
                                    assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) + 1).   ~
                                assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).                ~
                                apply 'value-changed' to bSaldoItem in frame Frame01.                                                    ~
                            End.                                                                                                         ~
                            ON '1':U OF bSaldoItem in Frame Frame01                                                                      ~
                            DO:                                                                                                          ~
                                apply 'return' to bSaldoItem in frame Frame01.                                                           ~
                            END.                                                                                                         ~
                            ON '0':U OF bSaldoItem in Frame Frame01                                                                      ~
                            DO:                                                                                                          ~
                                If not avail ttResumo Then return no-apply.                                                              ~
                                find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)).                                       ~
                                If integer(entry(1,ttEmbSelec.cNumEmbal,"/")) > 0 Then                                                   ~
                                    assign entry(1,ttEmbSelec.cNumEmbal,"/") = string(integer(entry(1,ttEmbSelec.cNumEmbal,"/")) - 1).   ~
                                if ttEmbSelec.qtdItem <> 0 then                                                                          ~
                                    assign ttEmbSelec.qtdItem = 0.                                                                       ~
                                assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).                ~
                                apply 'value-changed' to bSaldoItem in frame Frame01.                                                    ~
                            END.                                                                                                         ~
                            ON 'row-display':U OF bSaldoItem in Frame Frame01                                                            ~
                            DO:                                                                                                          ~
                               If not avail ttResumo Then return no-apply.                                                               ~
                               assign cDispItem = "":U                                                                                   ~
                                      cDispItem = cDispItem + string(ttResumo.qtd-item) + "/" + ttResumo.cod-embalagem.                  ~
                               find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) no-lock no-error.                       ~
                               If not avail ttEmbSelec Then do:                                                                          ~
                                   create ttEmbSelec.                                                                                    ~
                                   assign ttEmbSelec.cChave = string(rowid(ttResumo))                                                    ~
                                          ttEmbSelec.cNumEmbal = "0/" + string(ttResumo.qti-embalagem).                                  ~
                               End.                                                                                                      ~
                               else assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = string(ttEmbSelec.cNumEmbal).            ~
                            END.                                                                                                         ~
                            on 'value-changed' of bSaldoItem in Frame Frame01                                                            ~
                            do:                                                                                                          ~
                               define variable cTotItem as decimal no-undo.                                                              ~
                               find ttEmbSelec where ttEmbSelec.cChave = string(rowid(ttResumo)) no-error.                               ~
                               If avail ttEmbSelec Then do:                                                                              ~
                                   assign cNumEmbal:screen-value in frame Frame01 = ttEmbSelec.cNumEmbal.                                ~
                                   For each bf-ttResumo where bf-ttResumo.cod-item = ttResumo.cod-item and bf-ttResumo.cod-lote = ttResumo.cod-lote and ~
                                          bf-ttResumo.cod-refer = ttResumo.cod-refer:                                                    ~
                                        find bf-ttEmbSelec where bf-ttEmbSelec.cChave = string(rowid(bf-ttResumo)) no-lock no-error.           ~
                                        If avail bf-ttEmbSelec Then do:                                                                     ~
                                            if bf-ttEmbSelec.qtdItem = 0 then                                                               ~
                                                assign cTotItem = cTotItem + decimal(entry(1,bf-ttEmbSelec.cNumEmbal,"/")) * bf-ttResumo.qtd-item. ~
                                            else do: ~
                                                assign cTotItem = cTotItem + ((decimal(entry(1,bf-ttEmbSelec.cNumEmbal,"/")) - 1) * bf-ttResumo.qtd-item) + bf-ttEmbSelec.qtdItem. ~
                                            End. ~
                                        End.                                                                                             ~
                                   End.                                                                                                  ~
                                   assign ttWork.qtd-item = ttEmbSelec.qtdItem                                                           ~
                                          entry(1,cTotalItem,"/") = string(cTotItem).                                                    ~
                               End.                                                                                                      ~
                               else do:                                                                                                  ~
                                   assign ttEmbSelec.cNumEmbal:screen-value in frame Frame01 = "0/0".                                    ~
                               End.                                                                                                      ~
                               if avail ttResumo then                                                                                    ~
                                    display cTotalItem ttResumo.cod-lote ttResumo.cod-item ttResumo.cod-refer with frame Frame01.        ~
                            End.                                                                                                         ~
                            ON 'ESC':U of Frame Frame01                                                                                  ~
                            DO:                                                                                                          ~
                                If decimal(entry(1,cTotalItem,"/")) <> ttwm-box-movto.qtd-item * ttwm-box-movto.qti-embalagem Then                                      ~
                                    return no-apply.                                                                                     ~
                                For each ttEmbSelec no-lock:                                                                             ~
                                    find ttResumo where rowid(ttResumo) = to-rowid(ttEmbSelec.cChave) no-lock no-error.                  ~
                                    Do cIndex = 1 to integer(entry(1,ttEmbSelec.cNumEmbal,"/")):                                     ~
                                        run piVerificarRessup(input ttResumo.qtd-item,                                               ~
                                                              input 1).                                                              ~
                                    End.                                                                                             ~
                                End.                                                                                                     ~
                                empty temp-table ttEmbSelec.                                                                             ~
                                assign vLogSai = yes                                                                                     ~
                                       vLogfimTran = yes.                                                                                ~
                                run gravaCamposFrame01. ~
                            END.                                                                                                         ~

/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc035
&global-define ActiveObject2 wgbosc044
&global-define ActiveObject3 wgbosc145
/************************************************************/
/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/
/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao e necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* Procedure de atualizacao da transacao            */
/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ≤ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/

/*************************************************************************************************** 
** Esta procedure esta inicializando os campos da tela Frame01 com valores em branco              **
** Esta procedure e executada pelo pre-processador {&TriggerBeforeFrame01}.                       **
****************************************************************************************************/
Procedure InicializaCamposFrame01:  

IF NOT VALID-HANDLE(wgbosc035)  THEN DO:
   Run scbo/bosc035.p Persistent SET wgbosc035.
   Run openQueryStatic In wgbosc035 (Input "Main":U) No-error. 
END.      
IF NOT VALID-HANDLE(wgbosc044)  THEN DO:
   Run scbo/bosc044.p Persistent SET wgbosc044.
   Run openQueryStatic In wgbosc044 (Input "Main":U) No-error. 
END. 
IF NOT VALID-HANDLE(wgbosc044)  THEN DO:
   Run scbo/bosc044.p Persistent SET wgbosc044.
   Run openQueryStatic In wgbosc044 (Input "Main":U) No-error. 
END. 
IF NOT VALID-HANDLE(wgbosc096)  THEN DO:
   Run scbo/bosc096.p Persistent SET wgbosc096.
   Run openQueryStatic In wgbosc096 (Input "Main":U) No-error. 
END. 

Run getInfoDoctoItens IN wgbosc096 (Input ttwm-box-movto.cod-estabel,
                                    Input ttwm-box-movto.cod-local,  
                                    Input ttwm-box-movto.id-docto,
                                    Input ttwm-box-movto.num-seq-item,
                                    Output Table ttwm-docto-itens ).

IF VALID-HANDLE(wgbosc096) THEN RUN destroy IN wgbosc096.

find first ttwm-docto-itens no-error.

assign cBoxOrig:screen-value in Frame Frame01 = string(ttWork.num-box-orig)
       cTotalItem = "0/" + String((ttwm-box-movto.qtd-item) * ttwm-box-movto.qti-embalagem).   

If valid-handle(wgbosc035) Then
    run getOcupacaoBox in wgbosc035 (input ttwm-box-movto.cod-estabel,
                                     input ttwm-box-movto.cod-local,
                                     input ttWork.num-box-orig,
                                     output table ttResumo).

/* Agrupando as quantidades dos itens existentes no box informado e verificando existància de alguma seleá∆o */

For each ttResumo exclusive-lock:
    /* Se o saldo n∆o estiver comprometido devido ao ressuprimento n∆o dever† ser mostrado */
    If ttResumo.ind-status-saldo <> 1 Then do: 
        delete ttResumo.
        next.
    End.
    If ttResumo.cod-embalagem <> ttwm-box-movto.cod-embalagem or ttResumo.cod-refer <> ttwm-box-movto.cod-refer or ttResumo.cod-lote <> ttwm-box-movto.cod-lote Then do:
        delete ttResumo.
        next.
    End.
    
    If valid-handle(wgbosc145) Then do: /* Validando se existe embalagem padr∆o para o item. Validaá∆o para garantia, pois n∆o deveria existir esta situaá∆o na base */
        run existeEmbalagemItemLocal in wgbosc145 (input ttResumo.cod-estabel,
                                                   input ttResumo.cod-local,
                                                   input ttResumo.cod-item).
        If return-value = "NOK":U Then do:
            delete ttResumo.
            next.
        End.
    End.
    assign ttResumo.r-Rowid = rowid(ttResumo)
           cEmbalSel = 0.
    
    /* Consolidando os registros com as mesmas caracter°sticas em um mesmo registro (item, referencia, lote, embalagem e quantidades) */
    For each bf-ttResumo where bf-ttResumo.cod-item = ttResumo.cod-item and bf-ttResumo.cod-embalagem = ttResumo.cod-embalagem and
        bf-ttResumo.qtd-item = ttResumo.qtd-item and bf-ttResumo.qtd-item-bloq = ttResumo.qtd-item-bloq and bf-ttResumo.qtd-original = ttResumo.qtd-original and
        bf-ttResumo.cod-refer = ttResumo.cod-refer and bf-ttResumo.cod-lote = ttResumo.cod-lote and rowid(bf-ttResumo) <> rowid(ttResumo):
        assign ttResumo.qti-embalagem = ttResumo.qti-embalagem + bf-ttResumo.qti-embalagem.
        delete bf-ttResumo.
    End.
End.

open query qSaldoItem for each ttResumo no-lock.

apply 'value-changed' to bSaldoItem in Frame Frame01.

End Procedure.

/*************************************************************************************************** 
** Esta procedure esta armazenando na temp-table {&Temp-Table} os valores recebidos por ttWork    **
** na tela Frame 03.                                                                              **
** Esta procedure e executada pelo pre-processador {&TriggerAfterFrame03}.                        **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    define variable cTotalQtde as integer no-undo.
    define variable lSai       as logical init no no-undo.
    define variable cNumEmbal  as integer no-undo.
    define variable i          as integer no-undo.

    If vlogFinaliza or vLogFimTran Then do:
        apply 'go' to frame Frame01.
    End.

    If decimal(entry(1,cTotalItem,"/")) = ttwm-box-movto.qtd-item * ttwm-box-movto.qti-embalagem Then do:
        HIDE ALL NO-PAUSE.
        Run bcp/bc9020m.p (Input Rowid(ttwm-box),        
                           Input ttwm-box-movto.r-rowid,
                           Input Rowid(ttwm-docto-itens)).
        HIDE ALL NO-PAUSE.
        IF RETURN-VALUE = 'OK':U THEN DO:
            ASSIGN vLogFinaliza = YES.
        END.
        ASSIGN vReturn = RETURN-VALUE.
        RETURN RETURN-VALUE.
    End.
End Procedure.

Procedure piVerificarRessup:
    define input        parameter pQtdItem          as integer no-undo.
    define input        parameter pQtiEmbalagem     as integer no-undo.

    define variable               cTot              as integer no-undo.

    Assign ttWork.qtd-embal-lidas       = ttWork.qtd-embal-lidas + pQtiEmbalagem
           ttWork.cod-estabel           = ttwm-box-movto.cod-estabel
           ttWork.cod-local             = ttwm-box-movto.cod-local
           ttWork.num-documento         = ttwm-box-movto.id-docto
           ttWork.num-movimento         = ttwm-box-movto.id-movto
           ttWork.num-seq-item          = ttwm-box-movto.num-seq-item
           ttWork.num-box               = ttwm-box-movto.id-box
           ttWork.cod-embalagem         = ttwm-box-movto.cod-embalagem
           ttWork.cod-item              = ttwm-docto-itens.cod-item
           ttWork.qtd-item              = pQtdItem
           ttWork.qtd-embalagem         = ttResumo.qti-embalagem
           ttWork.dat-atualizacao       = ttwm-box-movto.dt-atualizacao
           ttWork.dat-transacao         = ttwm-box-movto.dt-transacao
           ttWork.qtd-item-digit        = pQtdItem
           ttWork.des-seriais           = ""
           ttWork.des-qtdseriais        = ""
           ttWork.r-rowid               = ttwm-box-movto.r-rowid.

End procedure.

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif


