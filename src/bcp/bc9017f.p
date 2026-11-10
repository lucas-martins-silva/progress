/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9017F 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9017f MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9017.p                                                                  **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2002 - Karen - Cria‡Æo do programa                   **
**                                                                                         **
**   Objetivo..: Templates DC Interface para transacao de Armazenamento WMS                **
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
**                        Ex: tt-ender-wms.                                                       **
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
&global-define ProgramName BC9017
/************************************************************/

/* Definicao da temp-table de integracao ---                */

&global-define TempTable tt-ender-wms
{bcp/bc9017.i " "}

Define Shared Temp-table ttWork No-Undo like {&TempTable}.
find first ttWork no-error.

Define Shared Temp-table ttwm-docto-itens No-undo Like wm-docto-itens. 

Define Shared Temp-table ttwm-box No-undo Like wm-box
    Field RowNum As Integer Init 1
    Field r-Rowid AS Rowid. 

DEFINE Shared  TEMP-TABLE ttWm-box-movto-idx LIKE wm-box-movto
        Field val-prioridade    As Integer
        FIELD r-rowid           AS ROWID
        Index idx-prioridade val-prioridade Descending
        INDEX idx-movto      id-movto ASCENDING.

/* fk teste */
/*FOR EACH ttwm-box.
    MESSAGE "wm-box" ttwm-box.id-box VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.
FOR EACH ttWm-box-movto-idx.
    MESSAGE ttWm-box-movto-idx.id-box VIEW-AS ALERT-BOX INFO BUTTONS OK.
END.*/
/* fk teste fim */

/* fk inicio: alterado para pegar o id-box correto */
FIND FIRST ttwm-box NO-ERROR.
find first ttwm-box-movto-idx 
    WHERE ttwm-box-movto-idx.id-box = ttwm-box.id-box
    no-error.

/* fk fim */


DEFINE Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.                                      

DEFINE NEW SHARED TEMP-TABLE tt-serialfilho
    FIELD cd-trans        LIKE bc-integracao.cd-trans
    FIELD num-serial      LIKE wm-etiqueta.id-etiqueta
    FIELD id-docto        LIKE wm-box-movto.id-docto
    FIELD id-movto        LIKE wm-box-movto.id-movto
    FIELD num-seq-item    LIKE wm-box-movto.num-seq-item
    FIELD ind-tipo-movto  LIKE wm-box-movto.ind-tipo-movto
    FIELD num-itemserial1 LIKE bc-integracao.inteiro-1
    FIELD num-itemserial2 LIKE bc-integracao.inteiro-2.

DEFINE TEMP-TABLE ttSerialQtd NO-UNDO
       FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado.

/************************************************************/

/* Variaveis de trabalho ---                                */              
Define Variable vNumItensSerial         As Decimal                      Init 0   No-undo.
Define Variable vCodTipoEquip           As Character                    Init ''  No-undo.
Define Variable vCodItemCorrente        As Character Format 'x(16)':U   Init ''  No-undo.
Define Variable vDesItemCorrente        As Character Format 'x(18)':U   Init ''  No-undo.
define variable vCodLote                like ttWm-box-movto-idx.cod-lote  no-undo.
define variable vCodRefer               like ttWm-box-movto-idx.cod-refer no-undo.
define variable vCodItem                like ttWm-box-movto-idx.cod-item  no-undo.
Define Variable vNumCont                As Integer                      Init 0   No-undo.
Define Variable vNumCont2               As Integer                      Init 0   No-undo.
Define Variable vNumSeq                 As Integer                      Init 0   No-undo.
Define Variable vLogOk                  As Logical                      Init No  No-undo.
Define Variable vLogAtivo               As Logical                      Init No  No-undo.
Define New Shared Variable vLogProcesso As LOGICAL                      Init No  No-undo.

Define Variable vLogUtilizaColetor      As Logical                      Init No  No-undo.
Define Variable vLogAprovaFatura        As Logical                      Init No  No-undo.
Define Variable vLogControlaLogin       As Logical                      Init No  No-undo.
define variable vIndTipContrEstoq       as integer                               no-undo.

Define Variable IDttwm-box           As Rowid No-undo.
Define Variable IDttwm-box-movto-idx As Rowid No-undo.
Define Variable IDttwm-docto-itens   As Rowid No-undo.
Define New Shared Variable vLogEmProcesso     As Logical                  Init No  No-undo.
Define New Shared Variable vLogEmProcesso-aux As Logical                  Init No  No-undo.
Define NEW SHARED Variable vLogControla       As Logical                  Init No  No-undo.

Define New Shared Variable v-cod-estabel    As Character                     No-undo.
Define New Shared Variable v-cod-local      As Character                     No-undo.
Define New Shared Variable wgbosc030        As Widget-handle                 No-undo.       
Define New Shared Variable wgbosc038        As Widget-handle                 No-undo.       
Define New Shared Variable wgbosc051        As Widget-handle                 No-undo.       
Define New Shared Variable wgbosc044        As Widget-handle                 No-undo.       

Define Variable vCodSenha AS CHAR FORMAT 'x(12)':U No-undo.

/*fk - opcao do tipo de leitura. Esse valor vem da bc9018h.p*/
DEFINE NEW GLOBAL SHARED VARIABLE iIndTipoLeitura  AS INTEGER NO-UNDO. 

{bcp/bc9015.i3} /* def variaveis padroes */
{utp/utapi009.i} /* login */
{bcp/bc9018h.i} /*fk - definicao das procedures utilizadas para controle ean/dun */

Define Temp-table tt-mostra-locais NO-UNDO
    Field num-seq           As Integer
    Field des-local         As Character Format 'X(27)':U
    Field dt-movto          As Date Format '99/99/9999':U
    Field rowid-box-movto   As Rowid
        Index ID num-seq
        Index local des-local
        Index data dt-movto.

/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Armazenamento WMS'                               At Row 01 Col 01                           ~
                             '............/..... ':U                           At Row 02 Col 01                           ~
                             '...................':U                           At Row 03 Col 01                           ~
                             'Box:......         '                             at row 04 col 01                           ~
                             'It:...             '                             At Row 05 Col 01                           ~
                             'Ref:               '                             At Row 06 Col 01                           ~
                             'Lt:                '                             At Row 07 Col 01                           ~
                             'Qtd:'                                            at row 08 col 01                           ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(11)':U ~
                             ttWork.qtd-item                                   At Row 02 Col 14 No-label Format '>>>>9':U ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)':U ~
                             ttWork.num-box-lido                               at row 04 col 05 no-label                  ~
                             vCodItem                                          At Row 05 Col 04 view-as fill-in SIZE 15 BY .88 No-label   ~
                             vCodRefer                                         At Row 06 col 05 No-label                  ~
                             vCodLote                                          At Row 07 Col 04 No-label FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 17 BY 0.88 ~
                             ttWork.qtd-embal-lidas                            at row 08 col 05 no-label                  ~

&global-define Frame01Repeat YES
                 

/* FK INICIO - projeto parati ********************************************************************/
/* Definicao da Frame03 ---                                 */
&global-define Frame02Name   Frame02
&global-define Frame02Defs   'Armazenamento WMS'                                     At Row 01 Col 01                         ~
                             'Tipo leitura?      '                             At Row 02 Col 01                         ~
                             '2 - Por quantidade '                             At Row 03 Col 01                         ~
                             '3 - Por EAN/DUN    '                             At Row 04 Col 01                         ~
                             'Opcao              '                             At Row 08 Col 01                         ~
                             iIndTipoLeitura                                   At Row 08 Col 14 No-label Format '9'
                             
&global-define Frame02Repeat NO .

/* Definicao da Frame03 ---                                 */
&global-define Frame03Name   Frame03
&global-define Frame03Defs   'Armazenamento WMS'                               At Row 01 Col 01                           ~
                             '............/..... ':U                           At Row 02 Col 01                           ~
                             '...................':U                           At Row 03 Col 01                           ~
                             'Box:......         '                             at row 04 col 01                           ~
                             'It:...             '                             At Row 05 Col 01                           ~
                             'Ref:               '                             At Row 06 Col 01                           ~
                             'Lt:               '                             At Row 07 Col 01                           ~
                             'CB'                                            at row 08 col 01                           ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(11)':U ~
                             ttWork.qtd-item                                   At Row 02 Col 14 No-label Format '>>>>9':U ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)':U ~
                             ttWork.num-box-lido                               at row 04 col 05 no-label                  ~
                             vCodItem                                          At Row 05 Col 04 view-as fill-in SIZE 15 BY .88 No-label   ~
                             vCodRefer                                         At Row 06 col 05 No-label                  ~
                             vCodLote                                          At Row 07 Col 04 NO-LABEL FORMAT "x(40)"  VIEW-AS FILL-IN SIZE 17 BY 0.88 ~
                             ttWork.cod-livre-1                                At Row 08 Col 04 No-label Format 'x(14)' /*fk armazena o ean/dun*/

&global-define Frame03Repeat YES
/* FK FIM - projeto parati **********************************************************************/


/************************************************************/

/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields 
/************************************************************/

/* Definicao das trigger de interacao com a tela ---        */ 
&global-define TriggerBeforeFrame01 Run InicializaCamposFrame01.

&global-define TriggerAfterFrame01  Run GravaCamposFrame01. If  Return-value = 'OK' Then Do:         ~
                                                                 Assign vLogFinaliza = Yes            ~
                                                                        vLogSai      = Yes.           ~
                                                                 Return.                              ~
                                                            End.                                     ~
                                                            ELSE RETURN RETURN-VALUE. ~

/* Definicao das trigger de usuario ---                     */ 

&global-define UserTriggers ON 'END-ERROR':U OF Frame Frame01 ~
                            DO:                        ~
                                Return 'ESC':U.          ~
                            END. 

&global-define UserTriggers ON 'END-ERROR':U OF Frame Frame02 ~
                            DO:                         ~
                                Return 'ESC':U.          ~
                            END. 

&global-define UserTriggers ON 'END-ERROR':U OF Frame Frame03 ~
                            DO:                         ~
                                Return NO-APPLY.          ~
                            END. ~ 
/************************************************************/
/* Definicao dos objetos ativos ---                         */ 
&global-define ActiveObject1 wgbosc030
&global-define ActiveObject2 wgbosc038
&global-define ActiveObject3 wgbosc051
&global-define ActiveObject4 wgbosc044

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

    IF vLogControla = YES THEN RETURN ERROR.

    If  Not Avail ttwm-box-movto-idx Then Do:
        Return.
    End.

    Run scbo/bosc030.p Persistent Set wgbosc030 No-error.
    Run scbo/bosc051.p Persistent Set wgbosc051 No-error.
    Run scbo/bosc038.p Persistent Set wgbosc038 No-error.
    Run scbo/bosc044.p Persistent Set wgbosc044 No-error.

    /* Pegar Informacoes Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto-idx.cod-estabel,
                                          Input ttwm-box-movto-idx.cod-local,
                                          Input ttwm-box-movto-idx.id-box,
                                          Input ttwm-box-movto-idx.id-box).

    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).

    Run getBatchRecords IN wgbosc030 (Input   ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont2,
                                      Output Table ttwm-box).

    Find First ttwm-box No-error.

    If  Not Avail ttwm-box Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "401" "Box Invalido. (WMS)"}
        Return Error.
    End.

   Find First ttwm-docto-itens No-lock No-error.

   If  Not Avail ttwm-docto-itens Then Do:
       Return.
   End.

   Assign ttWork.cod-item       :Screen-value In Frame {&Frame01Name} = ttwm-docto-itens.cod-item
          ttWork.qtd-item       :Screen-value In Frame {&Frame01Name} = String(ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) 
          ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} =        ttwm-box.cod-bloco            + '/':U + 
                                                                               ttwm-box.cod-rua              + '/':U + 
                                                                               ttwm-box.cod-nivel            + '/':U + 
                                                                               ttwm-box.cod-coluna           + '/':U +
                                                                               If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
          ttWork.qtd-embal-lidas:Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-embal-lidas)  
          ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = '0'.


    Assign ttWork.num-serial = 0.

    RUN openQueryStatic IN wgbosc044 (INPUT "MAIN":U).
    run gotoKey in wgbosc044 (input ttwm-docto-itens.cod-item).
    run getIntField in wgbosc044 (input "ind-tipo-contr-est",
                                  output vIndTipContrEstoq).

    /* fk - Identifica o tipo de leitura a ser feita (1:pede em tela, 2:por qtd, 3:por ean/dun) */
    RUN pi-getTipoLeitura IN THIS-PROCEDURE.

    /* fk - Se for por codigo ean/dun, chama outra procedure */
    IF iIndTipoLeitura = 3 THEN DO:
        /* Pega a qtd pelas etiquetas ean-dun lidas */
        RUN getInfoCodigoEanDun IN THIS-PROCEDURE.
    END.
    ELSE DO:
        If vIndTipContrEstoq = 1 Then 
            update ttWork.num-box-lido
                   vCodItem
                   ttWork.qtd-embal-lidas with frame Frame01.
        else If vIndTipContrEstoq > 1 and vIndTipContrEstoq <> 4 Then do:
            update ttWork.num-box-lido                
                   vCodItem             
                   vCodLote 
                   ttWork.qtd-embal-lidas
                   with frame Frame01.
        End.
        else do:
            update ttWork.num-box-lido                
                   vCodItem             
                   vCodRefer
                   vCodLote
                   ttWork.qtd-embal-lidas
                   with frame Frame01.
        End.

        /* fk adicionado */
        assign input frame Frame01 ttWork.num-box-lido
                                   ttWork.qtd-item
                                   ttWork.qtd-embal-lidas
                                   vCodItem
                                   vCodLote
                                   vCodRefer.

    END.


End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:

    if return-value = "ESC" then return return-value.  /* Realizando tratamento do ESC */
    /* Validacoes Frame 04 Inicio --- */
    Assign vLogErro = No vLogSai = No vLogFinaliza = No.

    /* fk comentado */
/*     assign input frame Frame01 ttWork.num-box-lido    */
/*                                ttWork.qtd-item        */
/*                                ttWork.qtd-embal-lidas */
/*                                vCodItem               */
/*                                vCodLote               */
/*                                vCodRefer.             */

    If ttwm-box-movto-idx.id-box <> ttWork.num-box-lido Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "505" "Box Inv lido. (DC)"}
        Return error.
    End.

    If vIndTipContrEstoq > 1 Then do:
        If vCodLote = "" or vCodLote <> ttwm-box-movto-idx.cod-lote Then do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "502" "Lote inv lido. (DC)"}
            Return error.
        End.
    End.

    If ttwm-docto-itens.cod-item <> vCodItem Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "503" "Item inv lido. (DC)"}
        Return error.
    End.

    If vIndTipContrEstoq = 4 Then do:
        RUN openQueryStatic IN wgbosc051 (INPUT "MAIN":U).
        run goToKey in wgbosc051 (input vCodItem,
                                  input vCodRefer).
        If return-value <> "OK" Then do:
            Assign vLogErro = Yes.
            {bcp/bc9105.i "504" "Referˆncia inv lida. (DC)"}
            Return error.
        End.
    End.

    If  ttWork.num-box-lido = 0 Or 
        ttWork.num-box-lido <> ttwm-box-movto-idx.id-box Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "501" "Box Invalido. (WMS)"}
        Return error.
    End.

    /*  */
    If (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) <> ttWork.qtd-embal-lidas Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "506" "Quantidade inv lida. (DC)"}
        Return error.
    End.

    /* Valida Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto-idx.cod-estabel,
                                          Input ttwm-box-movto-idx.cod-local,
                                          Input ttWork.num-box-lido,
                                          Input ttWork.num-box-lido).

    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).

    Run getBatchRecords IN wgbosc030 (Input  ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
                                      Output Table ttwm-box).
    Find First ttwm-box No-error.

    If  Not Available ttwm-box Then do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "502" "Box Invalido. (WMS)"}
        Return error.
    End. 

    Assign ttWork.cod-estabel           = v-cod-estabel
           ttWork.cod-local             = v-cod-local
           ttWork.num-documento         = ttwm-box-movto-idx.id-docto
           ttWork.num-movimento         = ttwm-box-movto-idx.id-movto
           ttWork.num-seq-item          = ttwm-box-movto-idx.num-seq-item
           ttWork.num-box               = ttwm-box-movto-idx.id-box
           ttWork.num-doca              = ttwm-docto-itens.cod-doca
           ttWork.cod-embalagem         = ttwm-box-movto-idx.cod-embalagem
           ttWork.des-endereco          = ttWork.des-endereco:Screen-value In Frame {&Frame01Name} 
           ttWork.cod-item              = ttwm-docto-itens.cod-item
           ttWork.qtd-item              = ttwm-box-movto-idx.qtd-item
           ttWork.qtd-embalagem         = ttwm-box-movto-idx.qti-embalagem
           ttWork.dat-atualizacao       = ttwm-box-movto-idx.dt-atualizacao
           ttWork.dat-transacao         = ttwm-box-movto-idx.dt-transacao
           ttWork.r-rowid               = ttwm-box-movto-idx.r-rowid.

    Run getEstabelLocalDocto In wgbosc038 (Input  ttwm-box-movto-idx.id-docto,
                                           Output v-cod-estabel,
                                           Output v-cod-local) No-error.

    If  (ttWork.qtd-embal-lidas) > (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "404" "Quantidade lida ultrapassa limite box. (WMS)"}
        View Frame Frame01.                               
        Return Error.
    End.

    Display ttWork.qtd-embal-lidas With Frame {&Frame01Name}. 

    Assign {&TempTable}.num-serial     = ttWork.num-serial
           {&TempTable}.qtd-item-digit = vNumItensSerial
           ttWork.qtd-item             = ttWork.qtd-embal-lidas.

    /*Se a quantidade de item solicitada ja foi atendida manda confirmar a transacao no WMS*/
    If  (ttwm-box-movto-idx.qtd-item * ttwm-box-movto-idx.qti-embalagem) = ttWork.qtd-embal-lidas Then Do:
        Assign IDttwm-box           = Rowid(ttwm-box)         
               IDttwm-box-movto-idx = ttwm-box-movto-idx.r-rowid   
               IDttwm-docto-itens   = Rowid(ttwm-docto-itens).
        RUN GravaTransacao.
        IF RETURN-VALUE = 'NOK' THEN DO:
           {bcp/bc9105.i "903" "Problemas na Efetiva‡Æo"}
        END.
        Hide All No-pause.
        RETURN RETURN-VALUE.
    End.
    Pause 0 No-message.
End Procedure.

/*************************************************************************************************** 
** Esta procedure esta gerando a transacao no Data Collection atraves da chamada a procedure      **
** _GenerateDCTransaction.                                                                        **
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaTransacao:
    Def Var vNomeUsuario            As Character                No-undo.
    DEF VAR vcont                   AS INTEGER   INITIAL 0      NO-UNDO.

    Assign vNomeUsuario = ttWork.cod-usuario.

    Assign     {&TempTable}.cod-usuario           = ttWork.cod-usuario           
               {&TempTable}.cod-coletor           = ttWork.cod-coletor           
               {&TempTable}.cod-estabel           = ttWork.cod-estabel           
               {&TempTable}.cod-local             = ttWork.cod-local             
               {&TempTable}.num-documento         = ttWork.num-documento         
               {&TempTable}.num-movimento         = ttWork.num-movimento         
               {&TempTable}.num-seq-item          = ttWork.num-seq-item          
               {&TempTable}.num-box               = ttWork.num-box               
               {&TempTable}.cod-equipamento       = ttWork.cod-equipamento       
               {&TempTable}.des-endereco          = ttWork.des-endereco          
               {&TempTable}.cod-item              = ttWork.cod-item              
               {&TempTable}.qtd-item              = ttWork.qtd-item              
               {&TempTable}.num-box-lido          = ttWork.num-box-lido          
               {&TempTable}.cod-embalagem         = ttWork.cod-embalagem         
               {&TempTable}.qtd-embalagem         = ttWork.qtd-embalagem         
               {&TempTable}.qtd-embal-lidas       = ttWork.qtd-embal-lidas       
               {&TempTable}.num-serial            = ttWork.num-serial            
               {&TempTable}.num-tempo-inicio      = ttWork.num-tempo-inicio 
               {&TempTable}.des-seriais           = ttWork.des-seriais           
               {&TempTable}.dat-atualizacao       = ttWork.dat-atualizacao
               {&TempTable}.dat-transacao         = ttWork.dat-transacao
               {&TempTable}.r-rowid               = ttWork.r-rowid.

    Assign vTransDetail = vTransaction  + 
                  ' Usr: '  + String({&TempTable}.cod-usuario)                      +   
                  ' Col: '  + String({&TempTable}.cod-coletor)                      +
                  ' Eqp: '  + String({&TempTable}.cod-equipamento)                  +
                  ' Ser: '  + String({&TempTable}.num-serial,'999999999999999')     +
                  ' Doc: '  + String({&TempTable}.num-documento)                    +
                  ' Mov: '  + String({&TempTable}.num-movimento)                    +
                  ' Tip: '  + '1'                                                   +
                  ' Seq: '  + String({&TempTable}.num-seq-item).

    Raw-transfer {&TempTable} To vConteudoRaw.

    Run _GenerateDCTransaction (Input vTransaction,            /* Codigo da Transacao                   */
                                Input vConteudoRaw,            /* Conteudo da temp-table {&TempTable}   */
                                Input vTransDetail,            /* Cabecalho de detalhes da transacao    */
                                Input vNomeUsuario).           /* Usuario responsavel pela transacao    */ 
    EMPTY TEMP-TABLE tt-trans-filho.
    ASSIGN vLogControla = YES.
    IF RETURN-VALUE <> 'NOK':U THEN DO:
       {bcp/bc9105.i1 "902" "Item Armazenado.(DC)"}
       ASSIGN vLogEmProcesso-aux = YES.
       RETURN 'OK':U.
    END.
    RETURN 'NOK':U.
End Procedure.


/* FK INICIO - Parati: identifica o tipo de endereco e o valor do parametro para o item */

/*************************************************************************************************** */
PROCEDURE pi-getTipoLeitura:
/*************************************************************************************************** */

    /* Busca o parametro da bc-param-ext conforme o tipo de endereco (BC9018h.i) */
    RUN pi-getValorParametro (ttwm-box-movto-idx.cod-item,
                              "wment003",
                              ("LEIT-QTD-ARMAZEN-TAR"),
                              OUTPUT iIndTipoLeitura).

    /* Se nÆo achar o parametro, assume o valor 2 */
    IF iIndTipoLeitura = 0 THEN DO:
        {bcp/bc9105.i "104" "Parametros nao foram inicializados (DC)"}
        ASSIGN iIndTipoLeitura = 2.
    END.

    /* Caso o parametro seja informado incorretamente, informa ao usuario */
    IF iIndTipoLeitura < 0 OR iIndTipoLeitura > 3  THEN DO:
        {bcp/bc9105.i "104" "Valor do parametro incorreto para o item/familia/transacao (DC)"}
        ASSIGN iIndTipoLeitura = 2.
    END.

    /* Se o tipo de leitura for igual a 1, pede em tela */
    IF iIndTipoLeitura = 1 THEN DO:
        REPEAT:
            UPDATE iIndTipoLeitura WITH FRAME Frame02.

            /* S¢ aceita valores 2 e 3 digitados em tela */
            IF iIndTipoLeitura = 2 OR iIndTipoLeitura = 3 THEN
                LEAVE.
        END.
    END.
END PROCEDURE.

/*************************************************************************************************** 
** [alteracao parati] Busca as informacoes do codigo ean/dun                           **
****************************************************************************************************/
Procedure getInfoCodigoEanDun:

    /* Variaveis */
    DEFINE VARIABLE iTipoInformacao AS INTEGER    NO-UNDO.
    DEFINE VARIABLE cCodItem        AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE cCodEmbalagem   AS CHARACTER  NO-UNDO.
    DEFINE VARIABLE deQtdInformacao AS DECIMAL    NO-UNDO.
    DEFINE VARIABLE hbosc148        AS HANDLE     NO-UNDO.

    /*  */
    RUN scbo/bosc148.p PERSISTENT SET hbosc148.

    /* Rotina para apresentar as mesmas informacoes da frame1 na frame 3 */
    ASSIGN INPUT FRAME {&Frame01Name} 
        ttwork.qtd-item 
        ttwork.cod-item 
        ttwork.des-endereco 
        ttwork.num-box-lido.

    DISP 
        ttWork.cod-item 
        ttWork.qtd-item 
        ttWork.des-endereco 
        ttWork.num-box-lido
        vCodItem 
        vCodRefer 
        vCodLote WITH  FRAME {&Frame03Name}.

    /* Solicita os campos padroes */
    /*Hide All No-pause.*/
    If vIndTipContrEstoq = 1 Then 
        update ttWork.num-box-lido
               vCodItem  with frame Frame03.
    else If vIndTipContrEstoq > 1 and vIndTipContrEstoq <> 4 Then do:
        update ttWork.num-box-lido                
               vCodItem             
               vCodLote  with frame Frame03.
    End.
    else do:
        update ttWork.num-box-lido                
               vCodItem             
               vCodRefer
               vCodLote with frame Frame03.
    End.

    /*  */
    ASSIGN ttwork.qtd-item-digit = 0.

    /* Faz a leitura at‚ a qtd de itens for igual a qtd da etiqueta */
    REPEAT:

        /*  */
        RUN EmptyRowErrors In hbosc148. 

        /* Habilita para digitacao do codigo ean-dun*/
        UPDATE ttwork.cod-livre-1 WITH FRAME Frame03.

        /* digita 999999 para sair */
        IF ttwork.cod-livre-1 = "999999" THEN DO:
            LEAVE.
        END.

        /* Busca as informacoes referente ao codigo ean */
        RUN readBarCode IN hbosc148 (INPUT ttwm-box-movto-idx.cod-estabel,
                                     INPUT ttwm-box-movto-idx.cod-local,
                                     INPUT ttwork.cod-livre-1, /*codigo ean/dun lido*/
                                     OUTPUT iTipoInformacao,
                                     OUTPUT cCodItem, 
                                     OUTPUT cCodEmbalagem,
                                     OUTPUT deQtdInformacao,
                                     OUTPUT TABLE RowErrors).

        /*MESSAGE "Foi lido o codigo para box normal" VIEW-AS ALERT-BOX INFO BUTTONS OK.*/

        /* Tratamento de erro */
        Run getRowErrors In hbosc148 (Output Table RowErrors) No-error.
        For Each RowErrors:
            Hide All No-pause.
            ASSIGN ErrorDescription = ErrorDescription + "(WMS)":U.
            Run bcp/bc9115.p (ErrorNumber, ErrorDescription,8,20,3).
            Hide All No-pause.
            next.
        End. 

        /* Teste inicio *************************************************/
        /*ASSIGN cCodItem = '80510308'
            cCodEmbalagem = '10x10'
            deQtdInformacao = 1.
        MESSAGE 'O metodo getInfoCodigoEanDun nao est  definido pela logistica.' SKIP
            'Est  sendo adicionado uma variavel de teste. Nao esquecer de retirar o comentario' SKIP
            ttwork.cod-item SKIP cCodItem 
            VIEW-AS ALERT-BOX WARNING BUTTONS OK.*/
        /*MESSAGE cCodItem SKIP "-" ttwork.cod-item VIEW-AS ALERT-BOX INFO BUTTONS OK.*/
        /* Teste fim ****************************************************/


        /* Verifica se o item do codigo ean/dun eh o mesmo item do serial */
        IF cCodItem <> ttwork.cod-item THEN DO:
            {bcp/bc9105.i "507" "Item do codigo ean/dun lido nÆo confere com o item do c¢digo serial (DC)" }
            NEXT.
        END.

        /* Verifica se a embalagem do codigo lido eh a mesma do serial*/
        /*IF cCodEmbalagem <> ttwork.cod-embalagem THEN DO:
            {bcp/bc9105.i "508" "Embalagem do codigo ean/dun lido nÆo confere com a embalagem do c¢digo serial (DC)"}
            NEXT.
        END.*/

        /* Incrementa a qtd de item digitado para os dois campos em tela  */
        ASSIGN ttwork.qtd-item-digit = ttwork.qtd-item-digit + deQtdInformacao
            ttWork.qtd-embal-lidas = ttWork.qtd-item-digit.

        /* S¢ sai do looping quando a qtd de item lido for igual a qtd no serial */
        IF ttwork.qtd-item-digit = ttWork.qtd-item THEN DO:
            LEAVE.
        END.
        ELSE DO:
            /* Se a quantidade lida for maior que a solicitada, considera apenas a quantidade do movimento */
            IF ttwork.qtd-item-digit > ttWork.qtd-item THEN DO:
                {bcp/bc9105.i "509" "Quantidade lida maior que a quantidade do movimento (DC)"}

                /* Retorna o valor anterior */
                ASSIGN ttwork.qtd-item-digit = ttwork.qtd-item-digit - deQtdInformacao
                    ttWork.qtd-embal-lidas = ttWork.qtd-item-digit.
            END.
        END.
    END.

    /* Confirma as informacoes da frame 3 na frame 1 */
    assign input frame Frame03 ttWork.num-box-lido
                               ttWork.qtd-item
                               /*ttWork.qtd-embal-lidas*/
                               vCodItem
                               vCodLote
                               vCodRefer.

    /*  */
    IF VALID-HANDLE (hbosc148) THEN DELETE OBJECT hbosc148.

    /*  */
    RETURN 'ok'.

END PROCEDURE.

/* FK FIM - Altera‡Æo projeto parati */

/*************************************  Codigo do Usuario Fim   **********************************/

/*************************************  Codigo do Usuario Fim   **********************************/

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif


