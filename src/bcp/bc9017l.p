/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9017L 2.00.00.010 } /*** "010010" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9017l MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bc9017l.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000                                                               **
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

Define Shared Temp-table ttwm-docto-itens No-undo Like wm-docto-itens.

Define Shared Temp-table ttwm-box No-undo Like wm-box
    Field RowNum As Integer Init 1
    Field r-Rowid AS Rowid. 

DEFINE  Shared  TEMP-TABLE ttWm-box-movto-idx NO-UNDO LIKE wm-box-movto
        Field val-prioridade    As Integer
        FIELD r-rowid           AS ROWID
        Index idx-prioridade val-prioridade Descending
        INDEX idx-movto      id-movto ASCENDING.

DEFINE TEMP-TABLE ttSerialQtd NO-UNDO
       FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado.

Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

DEFINE SHARED TEMP-TABLE tt-serialfilho NO-UNDO
    FIELD cd-trans        LIKE bc-integracao.cd-trans
    FIELD num-serial      LIKE wm-etiqueta.id-etiqueta
    FIELD id-docto        LIKE wm-box-movto.id-docto
    FIELD id-movto        LIKE wm-box-movto.id-movto
    FIELD num-seq-item    LIKE wm-box-movto.num-seq-item
    FIELD ind-tipo-movto  LIKE wm-box-movto.ind-tipo-movto
    FIELD num-itemserial1 LIKE bc-integracao.inteiro-1
    FIELD num-itemserial2 LIKE bc-integracao.inteiro-2.

Define Input Param IDttwm-box           As Rowid No-undo.
Define Input Param IDttwm-box-movto-idx As Rowid No-undo.
Define Input Param IDttwm-docto-itens   As Rowid No-undo.
Define Input Param Table For tt-serialfilho.

Find First ttWork NO-ERROR.

Find ttwm-box           Where Rowid(ttwm-box)            = IDttwm-box NO-ERROR.
Find ttwm-box-movto-idx Where ttwm-box-movto-idx.r-rowid = IDttwm-box-movto-idx NO-ERROR.
Find ttwm-docto-itens   Where Rowid(ttwm-docto-itens)    = IDttwm-docto-itens NO-ERROR.

/************************************************************/

/* Variaveis de trabalho ---                                */              
Define Variable vNumItensSerial         As Decimal              Init 0   No-undo.
Define Variable vCodItem                As Character            Init ''  No-undo.
Define Variable vNumCont                As Integer              Init 0   No-undo.
Define Shared Variable vLogEmProcesso-aux As Logical                     No-undo.
Define SHARED VARIABLE vLogControla     As Logical              Init No  No-undo.
Define Shared Variable v-cod-estabel    As Character                     No-undo.
Define Shared Variable v-cod-local      As Character                     No-undo.
Define Shared Variable wgbosc030        As Widget-handle                 No-undo.       
Define Shared Variable wgbosc038        As Widget-handle                 No-undo.       
Define Shared Variable wgbosc039        As Widget-handle                 No-undo.       
Define Shared Variable wgbosc074        As Widget-handle                 No-undo.       
Define Shared Variable wgbosc092        As Widget-handle                 No-undo.       
Define Shared Variable wgbosc093        As Widget-handle                 No-undo.       
Define Shared Variable wgbosc096        As Widget-handle                 No-undo.       
DEFINE        VARIABLE wgbcapi001       AS WIDGET-HANDLE                 NO-UNDO.
/* Propriedades globais para frames ---                     */              
&global-define FrameSize    20 By 8 
/************************************************************/

/***************************************** Frames Inicio ******************************************/
/* Definicao da Frame01 ---                                 */
&global-define Frame01Name   Frame01
&global-define Frame01Defs   'Armazenamento WMS'                               At Row 01 Col 01                         ~
                             '............/..... ':U                           At Row 02 Col 01                         ~
                             '...................':U                           At Row 03 Col 01                         ~
                             'Qtd Lida:.....     '                             At Row 04 Col 01                         ~
                             'Doca Ori:...       '                             At Row 05 Col 01                         ~
                             'Ser:.............. '                             At Row 06 Col 01                         ~
                             'Box:......         '                             At Row 07 Col 01                         ~
                             ttWork.cod-item                                   At Row 02 Col 01 No-label Format 'x(11)' ~
                             ttWork.qtd-item                                   At Row 02 Col 14 No-label Format '>>>>9' ~
                             ttWork.des-endereco                               At Row 03 Col 01 No-label Format 'x(18)' ~
                             ttWork.qtd-embal-lidas                            At Row 04 Col 10 No-label Format '>>>>>' ~
                             ttWork.num-doca                                   At Row 05 Col 10 No-label Format '>>>'   ~
                             ttWork.num-serial                                 At Row 06 Col 05 No-label                ~
                             ttWork.num-box-lido                               At Row 07 col 05 No-label
&global-define Frame01Repeat No
/************************************************************/
/* Definicao dos campos a serem recebidos ---               */
&global-define Update01Fields ttWork.num-box-lido

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
&global-define UserTriggers 
/************************************************************/

/* Definicao dos objetos ativos ---                         */ 
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
def temp-table tt-erro-aux no-undo  like tt-erro.
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

    IF vLogControla = YES THEN RETURN error.

    If  Not Avail ttwm-box-movto-idx Then Do:
        Return.
    End.

    /* Pegar Informacoes Box */
    Run SetConstraintBoxes  In wgbosc030 (Input ttwm-box-movto-idx.cod-estabel,
                                          Input ttwm-box-movto-idx.cod-local,
                                          Input ttwm-box-movto-idx.id-box,
                                          Input ttwm-box-movto-idx.id-box).

    Run openQueryStatic In wgbosc030 (Input 'Boxes':U).

    Run getBatchRecords IN wgbosc030 (Input  ?,
                                      Input  NO,
                                      Input  ?,
                                      Output vNumCont,
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
          ttWork.des-endereco   :Screen-value In Frame {&Frame01Name} =             ttwm-box.cod-bloco            + '/':U + 
                                                                                    ttwm-box.cod-rua              + '/':U + 
                                                                                    ttwm-box.cod-nivel            + '/':U + 
                                                                                    ttwm-box.cod-coluna           + '/':U +
                                                                                    If ttwm-box.ind-posicao-box = 1 Then 'E' Else 'D'
          ttWork.qtd-embal-lidas:Screen-value In Frame {&Frame01Name} = String(ttWork.qtd-embal-lidas)  
          ttWork.num-doca       :Screen-value In Frame {&Frame01Name} = String(ttwm-docto-itens.cod-doca)
          ttWork.num-serial     :Screen-value In Frame {&Frame01Name} = String(ttWork.num-serial)
          ttWork.num-box-lido   :Screen-value In Frame {&Frame01Name} = '0'.

    Assign ttWork.num-box-lido.
End Procedure.

/*************************************************************************************************** 
** Esta procedure eï executada pelo pre-processador {&TriggerAfterFrame01}.                       **
****************************************************************************************************/
Procedure GravaCamposFrame01:
    DEF VAR vcont AS INT INITIAL 0.

    Assign vLogErro = No vLogSai = No vLogFinaliza = No.
    If  ttWork.num-box-lido = 0 Or 
        ttWork.num-box-lido <> ttwm-box-movto-idx.id-box Then Do:
        Assign vLogErro = Yes.
        {bcp/bc9105.i "501" "Box Invalido. (WMS)"}
        Return.
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
        Return.
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

    FOR EACH tt-serialfilho:
        IF ttWork.des-seriais = "" 
           THEN ASSIGN ttWork.des-seriais = string(tt-serialfilho.num-serial).
           ELSE ASSIGN ttWork.des-seriais = string(ttWork.des-seriais) + ";":U + string(tt-serialfilho.num-serial).
    END.

    FOR EACH tt-serialfilho:
        ASSIGN vcont = vcont + 1.
        CREATE tt-trans-filho.
        ASSIGN  tt-trans-filho.i-sequen-pai = 1
                TT-trans-filho.i-sequen     = vcont
                TT-trans-filho.num-versao   = 1
                TT-trans-filho.conteudo-xml = string(tt-serialfilho.cd-trans) + ";":U + string(tt-serialfilho.id-docto)     + ";":U +
                                              string(tt-serialfilho.id-movto) + ";":U + string(tt-serialfilho.num-seq-item) + ";":U +       
                                              string(tt-serialfilho.ind-tipo-movto) + ";":U + string(tt-serialfilho.num-serial) + ";":U +
                                              string(tt-serialfilho.num-itemserial2).
    END.

    RUN GravaTransacao.
    RETURN RETURN-VALUE.
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
/*************************************  Codigo do Usuario Fim   **********************************/

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif

