/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9017 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9017 MBC}
&ENDIF


{include/i_dbinst.i}  /* versÆo das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9017.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Cria‡Æo do programa                 **
**                                                                                         **
**   Finalidade: Api de efetivacao do Enderecamento WMS                                    **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9017.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{bcp/bc9018h.i}    /* fk: Metodos adicionados para o projeto parati*/
/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans     As Integer   No-undo.
Define Input        Parameter pRaw          As Raw       No-undo.
Define Input        PARAMETER r-BoxMovtoIdx AS ROWID     NO-UNDO.
Define Input-Output Parameter Table For tt-erro.

/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char     Format  "x(12)" No-undo.
Define                   Variable wgbosc096                     As Widget-handle            No-undo.
Define                   Variable wgbosc047                     As Widget-handle            No-undo.
Define                   Variable vNumCont                      As Integer         Init 0   No-undo.
Define                   Variable v-cod-estabel                 As Character                No-undo.
Define                   Variable v-cod-local                   As Character                No-undo.
Define                   Variable vDesSeriais                   As Character                No-undo.
Define                   Variable vDetalhe                      As Character                No-undo.
Define                   Variable l-reutiliza-etiqueta          As Logical                  No-undo.

DEF VAR i AS INTEGER.
/*****************************************************************************/

/*****************************************************************************/
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.
DEFINE TEMP-TABLE ttSerialQtd NO-UNDO
       FIELD id-etiqueta       LIKE wm-etiqueta.id-etiqueta
       FIELD qtd-item-retirado LIKE wm-etiqueta.qtd-item-retirado.
/*****************************************************************************/

DEFINE TEMP-TABLE tt-serial NO-UNDO
       FIELD id-etiqueta LIKE wm-etiqueta.id-etiqueta
       INDEX idx-serial  AS PRIMARY UNIQUE
             id-etiqueta.
DEFINE TEMP-TABLE tt-leitura NO-UNDO
           FIELD id-docto              LIKE wm-docto-itens.id-docto
           FIELD num-seq-item          LIKE wm-docto-itens.num-seq-item
           FIELD ind-tipo-movto        LIKE wm-box-movto.ind-tipo-movto
           FIELD id-movto              LIKE wm-box-movto.id-movto           
           FIELD id-box-lido           LIKE wm-box-movto.id-box 
           FIELD cod-item-lido         LIKE wm-docto-itens.cod-item
           FIELD qtd-item-lido         LIKE wm-docto-itens.qtd-item
           FIELD cod-embalagem-lido    LIKE wm-box-movto.cod-embalagem
           FIELD qti-embalagem-lido    LIKE wm-box-movto.qti-embalagem
           FIELD qtd-item-picking      LIKE wm-box-movto.qtd-item-picking.

Define Temp-table tt-box-movto NO-UNDO Like wm-box-movto
    FIELD r-rowid AS ROWID.

DEF TEMP-TABLE tt-tarefa-docto NO-UNDO
    FIELD CodUsuario     LIKE wm-tarefa-docto-itens.cod-usuario     
    FIELD CodEquipamento LIKE wm-tarefa-docto-itens.cod-equipamento 
    FIELD CodColetor     LIKE wm-tarefa-docto-itens.cod-coletor     
    FIELD TempoInicio    AS INTEGER.

/* Inicializacao dos objetos ativos ---                     */ 
Run scbo/bosc096.p Persistent Set wgbosc096.
Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.

/************************************************************/

BC9017:
DO TRANSACTION on ERROR  undo BC9017, leave BC9017
               on quit   undo BC9017, leave BC9017
               on stop   undo BC9017, leave BC9017
               on endkey undo BC9017, leave BC9017:

    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bc9017"
           tt-prog-bc.cod-versao-integracao = 1
           tt-prog-bc.usuario               = c-seg-usuario
           tt-prog-bc.opcao                 = 1.

    Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

    Find First tt-prog-bc   No-error.
    Find First tt-erro      No-error.

    If  Available tt-erro Then Do:
        Create  tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_Trans" *}
        Assign  tt-erro.i-sequen    = 1
                tt-erro.cd-erro     = 1
                tt-erro.mensagem    = RETURN-VALUE.
        Run deleteObjects.
        UNDO BC9017, Return 'NOK':U.
    End. /* If  Available tt-erro */

    Create tt-ender-wms.

    Raw-Transfer pRaw To tt-ender-wms.

    Find First tt-ender-wms No-error.

    /* Valida se o usuario informado na transacao esta cadastrado no ems */
    If  Connected('mguni':U) Then Do:
        {bcp/bc9017.i1 tt-ender-wms.cod-usuario}
        If  vLogOk = No Then do:
            Create tt-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Usuario" *}
            ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "nao_cadastrado_no_Datasul-EMS" *}
            ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
            Assign tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 1
                   tt-erro.mensagem = c-lbl-liter-usuario + ' ' + tt-ender-wms.cod-usuario + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
            Run deleteObjects.
            UNDO BC9017, Return 'NOK':U.
        End.
    END.

    Create tt-leitura.
    Assign tt-leitura.id-docto                  = tt-ender-wms.num-documento
           tt-leitura.num-seq-item              = tt-ender-wms.num-seq-item
           tt-leitura.ind-tipo-movto            = 1
           tt-leitura.id-movto                  = tt-ender-wms.num-movimento
           tt-leitura.id-box-lido               = tt-ender-wms.num-box-lido
           tt-leitura.cod-item-lido             = tt-ender-wms.cod-item 
           tt-leitura.qtd-item-lido             = tt-ender-wms.qtd-item                      
           tt-leitura.cod-embalagem-lido        = tt-ender-wms.cod-embalagem                 
           tt-leitura.qti-embalagem-lido        = tt-ender-wms.qtd-embal-lidas.                      

    Create tt-box-movto.
    Assign tt-box-movto.cod-embalagem           = tt-ender-wms.cod-embalagem
           tt-box-movto.cod-estabel             = tt-ender-wms.cod-estabel
           tt-box-movto.cod-local               = tt-ender-wms.cod-local
           tt-box-movto.dt-atualizacao          = tt-ender-wms.dat-atualizacao
           tt-box-movto.dt-transacao            = tt-ender-wms.dat-transacao
           tt-box-movto.id-box                  = tt-ender-wms.num-box-lido
           tt-box-movto.id-docto                = tt-ender-wms.num-documento
           tt-box-movto.id-movto                = tt-ender-wms.num-movimento
           tt-box-movto.ind-status-movto        = 1
           tt-box-movto.ind-tipo-movto          = 1
           tt-box-movto.log-atualizado-coletor  = Yes
           tt-box-movto.num-seq-item            = tt-ender-wms.num-seq-item
           tt-box-movto.qtd-item                = tt-ender-wms.qtd-item
           tt-box-movto.qtd-item-orig           = tt-ender-wms.qtd-embalagem
           tt-box-movto.qti-embalagem           = tt-ender-wms.qtd-embal-lidas
           tt-box-movto.r-rowid                 = r-BoxMovtoIdx.

    Create tt-tarefa-docto.
    Assign tt-tarefa-docto.CodUsuario           = tt-ender-wms.cod-usuario
           tt-tarefa-docto.CodEquipamento       = tt-ender-wms.cod-equipamento
           tt-tarefa-docto.CodColetor           = tt-ender-wms.cod-coletor
           tt-tarefa-docto.TempoInicio          = tt-ender-wms.num-tempo-inicio.

    ASSIGN vDetalhe = 'BC9017'                        + ";":U + 
                  string(tt-box-movto.id-docto)       + ";":U + 
                  STRING(tt-box-movto.id-movto)       + ";":U + 
                  string(tt-box-movto.num-seq-item)   + ";":U +       
                  string(tt-box-movto.ind-tipo-movto).

    For Each tt-serial:
        Delete tt-serial.
    End.
    For Each ttSerialQtd:
        Delete ttSerialQtd.
    End.

    If tt-ender-wms.num-serial <> 0 Then do: /* Apenas para transa‡Æo via seriais */
        /* Altera‡Æo provinda da equipe de Servi‡os */
        DO i = 1 TO NUM-ENTRIES(tt-ender-wms.des-seriais,";"):  
           Create ttSerialQtd.
           Assign ttSerialQtd.id-etiqueta       = DECIMAL(entry(i, tt-ender-wms.des-seriais,";"))
                  ttSerialQtd.qtd-item-retirado = tt-ender-wms.qtd-item-digit .
        END.
    End.

    IF NOT VALID-HANDLE(wgbosc096) THEN DO:
        Run scbo/bosc096.p Persistent Set wgbosc096.
        Run openQueryStatic In wgbosc096 (Input "Main":U) No-error.
    END.

    Run emptyRowErrors In wgbosc096.

    IF VALID-HANDLE(wgbosc096) THEN
       RUN destroy IN wgbosc096.


    RUN scbo/bosc047.p PERSISTEN SET wgbosc047.
    RUN OpenQueryStatic IN wgbosc047 (INPUT "Main":U) NO-ERROR.
    
    RUN verificarReutilizaEtiqMovto IN wgbosc047 ( INPUT tt-box-movto.cod-estabel,
                                                   INPUT tt-box-movto.cod-local,
                                                   INPUT tt-box-movto.id-movto,
                                                   INPUT tt-ender-wms.num-serial,
                                                   OUTPUT l-reutiliza-etiqueta).

    IF VALID-HANDLE(wgbosc047) THEN
       RUN destroy IN wgbosc047.

    IF l-reutiliza-etiqueta THEN DO:
       /* executa entrada */
        Run wmp/wm9031a.p (INPUT tt-box-movto.r-rowid,
                           INPUT tt-box-movto.id-box,
                           INPUT 2, /*Coletor*/
                           INPUT TABLE ttSerialQtd,
     	                     INPUT TABLE tt-tarefa-docto,
                           OUTPUT TABLE RowErrors).   
    END.
    ELSE DO:
        Run wmp/wm9031.p (INPUT tt-box-movto.r-rowid,
                          INPUT tt-box-movto.id-box,
                          INPUT TABLE ttSerialQtd,
     	                    INPUT TABLE tt-tarefa-docto,
                          OUTPUT TABLE RowErrors).   
    END.



    IF CAN-FIND(FIRST rowErrors) THEN DO:
       For Each RowErrors:
           Create tt-erro.
           Assign tt-erro.i-sequen = 8
                  tt-erro.cd-erro  = ErrorNumber
                  tt-erro.mensagem = ErrorDescription.
       End. 
       UNDO BC9017, Return 'NOK':U.
    End. 

    /* fk ini */
    FOR EACH ttSerialQtd.
        RUN piHabilitaHistoricoBcEtiqueta (pNumTrans, ttSerialQtd.id-etiqueta ). /*bcp/bc9018h.i*/
    END.
    /* fk fim */

    Return 'OK':U.
End. 
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
