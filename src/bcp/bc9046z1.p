/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9046Z1 2.00.00.002} /*** "010002" 09/10/2025 11:26:33 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BC9021Z1 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* versao das bases e bases instaladas */
/********************************************************************************************
**   Programa..: BC9021Z1.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - karla Klemke - Cria‡Æo do programa         **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Devolu‡Æo de Picking             **
**                                                                                         **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04':U &then
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
&global-define ProgramName BC9046
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-confirma
{bcp/bc9046.i}
{scbo/bosc076.i tt-item-docto-transf-depos}

def var h-bosc076   as handle  no-undo.
def var i-registros as integer no-undo.
/*
def var h-bosc038       as handle    no-undo.
def var h-bosc032       as handle    no-undo.
def var h-bosc137       as handle    no-undo.
def var i-sequencia-aux as integer   no-undo.
def var l-elimina       as logical   no-undo.
def var i-aux           as integer   no-undo.
def var c-aux           as character no-undo.
def var c-aux2          as character no-undo.


def buffer bf-tt-wm-box-movto for tt-wm-box-movto.
*/
def query qr-itens for tt-itens.

def browse brw-confirma query qr-itens no-lock
      disp tt-itens.cod-item width 19
      with no-box no-labels size 20 by 3 no-scrollbar-vertical.

define temp-table ttWork NO-UNDO like tt-confirma.

def input-output param table for ttWork.
def       output param table for tt-itens.

DEFINE VARIABLE vQtd    LIKE wm-box-movto.qtd-item.
DEFINE VARIABLE vLote   LIKE wm-box-movto.cod-lote.
DEFINE VARIABLE vRefer  LIKE wm-box-movto.cod-refer.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs  'Conf. Transf. WMS   '   At Row 01 Col 01 ~
                            brw-confirma             at row 02 col 01 ~
                            'Qtd: '                  at row 05 col 01 ~
                            vQtd                     at row 05 col 06 NO-LABEL FORMAT ">>,>>9.9999" ~
                            'Lt: '                   at row 06 col 01 ~
                            vLote                    at row 06 col 04 NO-LABEL FORMAT "x(40)" VIEW-AS FILL-IN SIZE 17 BY 0.88 ~
                            'Refer: '                at row 07 col 01 ~
                            vRefer                   at row 07 col 08 NO-LABEL FORMAT 'x(8)' ~
                            'TODOS: F3'              at row 08 col 01
&global-define Frame01Repeat YES

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields brw-confirma
/*&global-define Update02Fields ttWork.qtd-item*/ /*fk comentado*/

/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01. If vLogSai = Yes Then do: LEAVE _frame01. END.
&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If vLogFinaliza = Yes Then do: LEAVE _frame01. END.

/* Definicao das trigger de usuario ---                     */ 
&global-define UserTriggers ~
                            on 'Return':U of brw-confirma in frame {&frame01Name}           ~
                            do:                                                             ~
                                   apply 'Go' to this-procedure.                            ~
                            end.                                                            ~
                            ON 'value-changed':U of brw-confirma in frame {&frame01Name} DO: ~
                                ASSIGN vQtd:SCREEN-VALUE IN FRAME {&frame01Name} = STRING(tt-itens.qtd-item)     ~
                                       vLote:SCREEN-VALUE IN FRAME {&frame01Name} = STRING(tt-itens.cod-lote)    ~
                                       vRefer:SCREEN-VALUE IN FRAME {&frame01Name} = STRING(tt-itens.cod-refer). ~
                            END.                                                            ~
                            on 'ESC':U of frame frame01                                     ~
                            do:                                                             ~
                                return 'ESC':U.                                             ~
                            end.                                                            ~
                            on 'F3' of frame frame01 anywhere do:                           ~
                                assign ttWork.cod-item = "*F3-TODOS*"                       ~
                                       vLogSai         = yes                                ~
                                       vLogFinaliza    = yes.                               ~
                                apply 'Go' to this-procedure.                               ~
                            end.
/************************************************************/
/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
/************************************************************/

/*****************************************   Frames Fim ******************************************/

/**************************************************************************************************
** SECAO DO CODIGO PRINCIPAL DO PROGRAMA                                                         **
** Esta secao contem includes com codigos de execucao das interfaces.                      .     **
** Nao eï necessario efetuar alteracoes nesta sessao.                                            **
***************************************************************************************************/
 
&global activeObject1 h-bosc070
&global activeObject2 h-bosc076

/* Definicao do numero de segundos que cada mensagem fica sendo apresentada na tela --- */
&global-define ErrorDisplaySeconds 3
/****************************************************************************************/

{bcp/bc9100.i} /* Gerador da interface caracter do coleta de dados */
{bcp/bc9101.i} /* procedure de atualizacao da transacao            */   

/**************************************************************************************************/

/************************************* Codigo do Usuario Inicio ************************************
** Este local ‚ destinado ao codigo do usuario.                                                   **
** Para efeitos de escalabilidade entre versoes de produto recomenda-se que o acesso as tabelas   **
** do ERP seja feita atraves de um proxy, caso contrario poderao haver retrabalhos na migracao    **
****************************************************************************************************/
/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerBeforeFrame01}.                      **
****************************************************************************************************/
procedure InicializaCamposFrame01:

    find first ttWork NO-LOCK NO-ERROR.

    if  return-value = 'ESC':U then do:
        assign vlogfinaliza = yes.
        return return-value.
    end.
    assign vLogErro     = no
           vLogsai      = no
           vLogfinaliza = no.

    empty temp-table tt-itens.
    
    FIND FIRST docto-transf-depos NO-LOCK
         WHERE docto-transf-depos.num-docto-transf = ttWork.num-documento NO-ERROR.
    IF AVAIL docto-transf-depos THEN DO:
        FIND FIRST wm-docto NO-LOCK
             WHERE wm-docto.id-docto = docto-transf-depos.id-docto NO-ERROR.
        IF AVAIL wm-docto THEN DO:
            FOR EACH wm-box-movto NO-LOCK
               WHERE wm-box-movto.cod-estabel = wm-docto.cod-estabel
                 AND wm-box-movto.cod-local   = wm-docto.cod-local
                 AND wm-box-movto.id-docto    = wm-docto.id-docto
                 AND wm-box-movto.ind-tipo-movto = 2:
                IF wm-box-movto.log-picking THEN DO:
                    FOR EACH wm-box-movto-lote NO-LOCK
                       WHERE wm-box-movto-lote.cod-estabel    = wm-box-movto.cod-estabel
                         AND wm-box-movto-lote.cod-local      = wm-box-movto.cod-local
                         AND wm-box-movto-lote.id-movto       = wm-box-movto.id-movto:
                        FIND FIRST tt-itens EXCLUSIVE-LOCK
                             WHERE tt-itens.cod-estabel  = wm-box-movto-lote.cod-estabel
                               AND tt-itens.cod-local    = wm-box-movto-lote.cod-local
                               AND tt-itens.id-docto     = wm-box-movto-lote.id-docto
                               AND tt-itens.num-seq-item = wm-box-movto-lote.num-seq-item
                               AND tt-itens.cod-item     = wm-box-movto-lote.cod-item
                               AND tt-itens.cod-lote     = wm-box-movto-lote.cod-lote
                               AND tt-itens.cod-refer    = wm-box-movto-lote.cod-refer NO-ERROR.
                        IF NOT AVAIL tt-itens THEN DO:
                            CREATE tt-itens.
                            ASSIGN tt-itens.cod-estabel  = wm-box-movto-lote.cod-estabel
                                   tt-itens.cod-local    = wm-box-movto-lote.cod-local
                                   tt-itens.id-docto     = wm-box-movto-lote.id-docto
                                   tt-itens.num-seq-item = wm-box-movto-lote.num-seq-item
                                   tt-itens.cod-item     = wm-box-movto-lote.cod-item
                                   tt-itens.cod-lote     = wm-box-movto-lote.cod-lote
                                   tt-itens.cod-refer    = wm-box-movto-lote.cod-refer
                                   tt-itens.qtd-item     = 0.
                        END.
                        ASSIGN tt-itens.qtd-item = tt-itens.qtd-item + (wm-box-movto-lote.qtd-item - wm-box-movto-lote.qtd-liber-erp).
                    END.
                END.
                ELSE DO:
                    FIND FIRST tt-itens EXCLUSIVE-LOCK
                         WHERE tt-itens.cod-estabel  = wm-box-movto.cod-estabel
                           AND tt-itens.cod-local    = wm-box-movto.cod-local
                           AND tt-itens.id-docto     = wm-box-movto.id-docto
                           AND tt-itens.num-seq-item = wm-box-movto.num-seq-item
                           AND tt-itens.cod-item     = wm-box-movto.cod-item
                           AND tt-itens.cod-lote     = wm-box-movto.cod-lote
                           AND tt-itens.cod-refer    = wm-box-movto.cod-refer NO-ERROR.
                    IF NOT AVAIL tt-itens THEN DO:
                        CREATE tt-itens.
                        ASSIGN tt-itens.cod-estabel  = wm-box-movto.cod-estabel
                               tt-itens.cod-local    = wm-box-movto.cod-local
                               tt-itens.id-docto     = wm-box-movto.id-docto
                               tt-itens.num-seq-item = wm-box-movto.num-seq-item
                               tt-itens.cod-item     = wm-box-movto.cod-item
                               tt-itens.cod-lote     = wm-box-movto.cod-lote
                               tt-itens.cod-refer    = wm-box-movto.cod-refer
                               tt-itens.qtd-item     = 0.
                    END.
                    ASSIGN tt-itens.qtd-item = tt-itens.qtd-item + (wm-box-movto.qtd-item-picking - wm-box-movto.qtd-liber-erp).
                END.
            END.
        END.
    END.

    FIND FIRST tt-itens NO-LOCK
         WHERE tt-itens.qtd-item > 0 NO-ERROR.
    IF AVAIL tt-itens THEN DO:
        ASSIGN vQtd:SCREEN-VALUE IN FRAME {&frame01Name} = STRING(tt-itens.qtd-item)
               vLote:SCREEN-VALUE IN FRAME {&frame01Name} = STRING(tt-itens.cod-lote)
               vRefer:SCREEN-VALUE IN FRAME {&frame01Name} = STRING(tt-itens.cod-refer).
    END.
    ELSE DO:
        IF ttWork.cod-item <> "" THEN DO:
            ASSIGN ttWork.cod-item = ''
                   vlogfinaliza    = yes.
        END.

        ASSIGN vLogErro = YES
               vLogSai  = YES.
        {bcp/bc9105.i "301" "NÆo existem itens para liberar. (WMS)"}
        RETURN ERROR.
    END.
    
    open query qr-itens for each tt-itens WHERE tt-itens.qtd-item > 0.
end procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
procedure GravaCamposFrame01: 

    if  return-value = 'ESC' then do:
        return return-value.
    end.

    if  ttWork.cod-item = "*F3-TODOS*" THEN DO:
        FOR EACH tt-itens NO-LOCK:
            ASSIGN ttWork.cod-item     = tt-itens.cod-item
                   ttWork.qtd-item     = tt-itens.qtd-item
                   ttWork.cod-lote     = tt-itens.cod-lote
                   ttWork.cod-refer    = tt-itens.cod-refer
                   ttWork.num-seq-item = tt-itens.num-seq-item.
            RUN GravaTransacao IN THIS-PROCEDURE.
        END.
        ASSIGN vLogSai          = YES
               vLogFinaliza     = YES
               ttWork.cod-item  = "*F3-TODOS*".
        RETURN "OK".
    END.

    ASSIGN vLogErro     = NO
           vLogSai      = NO
           vLogFinaliza = NO.
    
    IF NOT AVAILAB ttWork THEN
        FIND FIRST ttWork NO-LOCK NO-ERROR.

    IF AVAILAB tt-itens THEN
        ASSIGN ttWork.cod-item     = tt-itens.cod-item
               ttWork.qtd-item     = tt-itens.qtd-item
               ttWork.cod-lote     = tt-itens.cod-lote
               ttWork.cod-refer    = tt-itens.cod-refer
               ttWork.num-seq-item = tt-itens.num-seq-item.

    /*
       vLogSai             = YES
       vLogFinaliza        = YES
    */

    RUN bcp/bc9046a.p (INPUT-OUTPUT TABLE ttWork).
    
    EMPTY TEMP-TABLE tt-itens.

    RETURN 'ok':U.
end procedure.

/*************************************  Codigo do Usuario Fim   **********************************/
&else 
    run utp/ut-msgs.p (input "show":u, 
                       input 28036,
                       input "").
&endif

PROCEDURE GravaTransacao:
    
    RUN _RetornaUsuario (OUTPUT vNomeUsuario).
    ASSIGN ttWork.cod-usuario = vNomeUsuario.
    RAW-TRANSFER ttWork TO vConteudoRaw.

    ASSIGN vTransDetail =  'EST:':U  + STRING(ttWork.cod-estabel)  +
                          ';LOC:':U  + STRING(ttWork.cod-local)    +
                          ';DEP:':U  + STRING(ttWork.cod-depos)    +
                          ';IDD:':U  + STRING(ttWork.id-docto)     +
                          ';DOC:':U  + STRING(num-documento)       +
                          ';SEQ:':U  + STRING(ttWork.num-seq-item) +
                          ';REF:':U  + STRING(ttWork.cod-refer)    +
                          ';LOT:':U  + STRING(ttWork.cod-lote)     +
                          ';QTD:':U  + STRING(ttWork.qtd-item).

    RUN _GenerateDCTransaction (INPUT vTransaction,  /* Codigo da Transacao                   */
                                INPUT vConteudoRaw,  /* Conteudo da temp-table ttWork         */
                                INPUT vTransDetail,  /* Cabecalho de detalhes da transacao    */
                                INPUT vNomeUsuario). /* Usuario responsavel pela transacao    */
    
    FIND FIRST tt-erro-after-GenerateDC NO-LOCK NO-ERROR.
    
    IF  NOT AVAIL tt-erro-after-GenerateDC AND RETURN-VALUE = "OK" THEN DO:
        ASSIGN vLogSai      = YES
               vLogFinaliza = YES.
        HIDE ALL.
        RETURN "OK".
    END.
    ELSE DO:
        ASSIGN vLogErro = YES.
        RETURN "NOK".
    END.

    RETURN "OK".
END PROCEDURE.
