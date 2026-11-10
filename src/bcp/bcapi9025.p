/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9025 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9025 MBC}
&ENDIF

{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/********************************************************************************************
**   Programa..: bcapi9025.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - fevereiro/2003 - Karen - Criaá∆o do programa                **
**                                                                                         **
**   Finalidade: Api de efetivacao da Transferància WMS                                    **
********************************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9025.i}     /* Definicao da temp-table de transferencia do coleta de dados */
/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans     As Integer   No-undo.
Define Input        PARAMETER TABLE FOR ttintegracao.
Define Input-Output Parameter Table For tt-erro.

/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char     Format  "x(12)" No-undo.
Define                   Variable wgbosc096                     As Widget-handle            No-undo.      
Define                   Variable vNumCont                      As Integer         Init 0   No-undo.
Define                   Variable v-cod-estabel                 As Character                No-undo.
Define                   Variable v-cod-local                   As Character                No-undo.
Define                   Variable vDesSeriais                   As Character                No-undo.
Define                   Variable vDetalhe                      As Character                No-undo.
DEFINE                   VARIABLE vusuario                      AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE i-cont-erro                   AS INTEGER                  NO-UNDO.
Define New Shared        Variable wgbosc032                     As Widget-handle            No-undo.       
DEFINE                   VARIABLE r-rowid-box-movto             AS ROWID                    NO-UNDO.
/*****************************************************************************/
Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.

/*****************************************************************************/
Define SHARED Temp-table ttwm-etiqueta-bkp NO-UNDO Like wm-etiqueta.

def temp-table tt-etiqueta no-undo
    field id-etiqueta    like wm-etiqueta.id-etiqueta
    field qtd-retirada   like wm-etiqueta.qtd-item 
    index codigo is unique id-etiqueta.

def temp-table tt-tarefa-docto no-undo
    field CodUsuario     like wm-tarefa-docto-itens.cod-usuario     
    field CodEquipamento like wm-tarefa-docto-itens.cod-equipamento 
    field CodColetor     like wm-tarefa-docto-itens.cod-coletor     
    field TempoInicio    as integer.

Define SHARED Temp-table tt-transf-wms-bkp NO-UNDO Like tt-transf-wms.

DEF BUFFER b-tt-transf-wms-bkp FOR tt-transf-wms-bkp.
{include/i-epc200.i "BCAPI9025"} /* Definicao de elementos referentes a UPC       */
/************************************************************/

BC9025:
DO TRANSACTION on ERROR  undo BC9025, leave BC9025
               on quit   undo BC9025, leave BC9025
               on stop   undo BC9025, leave BC9025
               on endkey undo BC9025, leave BC9025:

    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bc9025"
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
        UNDO BC9025, Return 'NOK':U.
    End. 

    ASSIGN vusuario = trim(_RetornaValChar('usuario':U)).
    ASSIGN vdetalhe =  _RetornaValChar('detalhe':U).

    /* Valida se o usuario informado na transacao esta cadastrado no ems */
    ASSIGN vLogOk = NO.
    If  Connected('mguni':U) Then Do:
        {bcp/bc9017.i1 vusuario}
        If  vLogOk = No Then do:
            Create tt-erro.
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Usu†rio" *}
            ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "n∆o_cadastrado_no_Datasul-EMS" *}
            ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
            Assign tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 1
                   tt-erro.mensagem = c-lbl-liter-usuario + ' ' + vusuario + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
            Run deleteObjects.
            UNDO BC9025, Return 'NOK':U.
        End.
    END.

    IF  NOT can-find(first bc-trans-filho WHERE
           bc-trans-filho.nr-trans = pNumTrans) THEN DO:
        Create tt-erro.
        ASSIGN i-cont-erro = i-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "N∆o_existem_seriais_para_serem_transferidos" *}
        Assign tt-erro.i-sequen = i-cont-erro
               tt-erro.cd-erro  = 3
               tt-erro.mensagem = RETURN-VALUE + '.'.
        UNDO BC9025, Return 'NOK':U.
    END.

    IF NOT VALID-HANDLE(wgbosc032) THEN DO:
       Run scbo/bosc032.p Persistent SET wgbosc032.
       Run openQueryStatic In wgbosc032 (Input "Main":U) No-error. 
    END.                   

    FOR EACH tt-transf-wms-bkp WHERE 
        tt-transf-wms-bkp.ind-tip-movto = 1 USE-INDEX idx-tip-movto:

        /* Caso n∆o existe o registro de entrada, o movimento n∆o poder† ser efetivado. 
           O Objetivo Ç permitir a transferància dos itens de forma parcial, tornando a transaá∆o mais flex°vel */
        find first b-tt-transf-wms-bkp where
                   b-tt-transf-wms-bkp.cod-livre-2   = string(rowid(tt-transf-wms-bkp))and
                   b-tt-transf-wms-bkp.ind-tip-movto = 2 no-error.

        If not avail b-tt-transf-wms-bkp Then
            next.

        If tt-transf-wms-bkp.num-serial <> 0 Then do: /* Apenas criar a tt-etiqueta se for via serial */
            EMPTY TEMP-TABLE tt-etiqueta.

            FIND FIRST ttwm-etiqueta-bkp WHERE 
                 ttwm-etiqueta-bkp.id-etiqueta = tt-transf-wms-bkp.num-serial  AND 
                 ttwm-etiqueta-bkp.cod-item    = tt-transf-wms-bkp.cod-item    AND 
                 ttwm-etiqueta-bkp.cod-refer   = tt-transf-wms-bkp.cod-refer   AND 
                 ttwm-etiqueta-bkp.cod-lote    = tt-transf-wms-bkp.cod-lote    NO-LOCK NO-ERROR.


            Create  tt-epc.
            Assign  tt-epc.cod-event     = "Finish_Update"
                    tt-epc.cod-parameter = "Id-Etiqueta"
                    tt-epc.val-parameter = STRING(ttwm-etiqueta-bkp.id-etiqueta).

            CREATE tt-etiqueta.
            ASSIGN tt-etiqueta.id-etiqueta  = ttwm-etiqueta-bkp.id-etiqueta
                   tt-etiqueta.qtd-retirada = ttwm-etiqueta-bkp.qtd-item - ttwm-etiqueta-bkp.qtd-item-retirado.
        End.

        CREATE tt-tarefa-docto.
        ASSIGN tt-tarefa-docto.CodUsuario     = tt-transf-wms-bkp.cod-usuario
               tt-tarefa-docto.CodEquipamento = tt-transf-wms-bkp.cod-equipamento
               tt-tarefa-docto.CodColetor     = tt-transf-wms-bkp.cod-coletor.

        Run GoToKey In wgbosc032 (INPUT tt-transf-wms-bkp.cod-estabel, 
                                  INPUT tt-transf-wms-bkp.cod-local, 
                                  INPUT tt-transf-wms-bkp.dat-transacao, 
                                  INPUT tt-transf-wms-bkp.id-docto,
                                  INPUT tt-transf-wms-bkp.num-seq-item, 
                                  INPUT tt-transf-wms-bkp.num-box-orig, 
                                  INPUT tt-transf-wms-bkp.cod-embalagem).

        IF Return-value <> 'OK'Then UNDO BC9025, Return 'NOK':U.

        RUN getrowid IN wgbosc032 (OUTPUT r-rowid-box-movto).
        IF Return-value <> 'OK'Then UNDO BC9025, Return 'NOK':U.

        RUN wmp/wm9021.p (INPUT tt-transf-wms-bkp.num-box-orig, 
                          INPUT tt-transf-wms-bkp.cod-lote,
                          INPUT (tt-transf-wms-bkp.qtd-item - tt-transf-wms-bkp.qtd-item-retirado), 
                          INPUT r-rowid-box-movto,
                          INPUT tt-transf-wms-bkp.cod-embalagem,
                          INPUT TABLE tt-etiqueta,
                          INPUT TABLE tt-tarefa-docto,
                          OUTPUT TABLE RowErrors). 
        FIND FIRST RowErrors NO-LOCK NO-ERROR.                 

        If  Return-value <> 'OK':U OR AVAILABLE RowErrors Then do:
            For Each RowErrors:
                Create tt-erro.
                Assign tt-erro.i-sequen = 8
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription.
            End. 
            UNDO BC9025, Return 'NOK':U.
        End.

        Run GoToKey In wgbosc032 (INPUT b-tt-transf-wms-bkp.cod-estabel, 
                                  INPUT b-tt-transf-wms-bkp.cod-local, 
                                  INPUT b-tt-transf-wms-bkp.dat-transacao, 
                                  INPUT b-tt-transf-wms-bkp.id-docto,
                                  INPUT b-tt-transf-wms-bkp.num-seq-item, 
                                  INPUT b-tt-transf-wms-bkp.num-box-orig, 
                                  INPUT b-tt-transf-wms-bkp.cod-embalagem).

        IF Return-value <> 'OK'Then UNDO BC9025, Return 'NOK':U.

        RUN getrowid IN wgbosc032 (OUTPUT r-rowid-box-movto).

        IF Return-value <> 'OK'Then UNDO BC9025, Return 'NOK':U.

        find first RowErrors no-lock no-error.

        RUN wmp/wm9031.p (INPUT r-rowid-box-movto,
                          INPUT b-tt-transf-wms-bkp.num-box-orig,
                          INPUT TABLE tt-etiqueta,
                          INPUT TABLE tt-tarefa-docto,
                          OUTPUT TABLE RowErrors).

        /* Devido a transferencia poder ser parcial, sempre excluir os movimentos que j† foram efetivados para n∆o gerar movimentos duplicados
           de sa°da x entrada */
        delete b-tt-transf-wms-bkp.

        FIND FIRST RowErrors NO-LOCK NO-ERROR.                  
        If  Return-value <> 'OK':U OR AVAILABLE RowErrors Then do:
            For Each RowErrors:
                Create tt-erro.
                Assign tt-erro.i-sequen = 8
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription.
            End. 
            UNDO BC9025, Return 'NOK':U.
        End.
        else delete tt-transf-wms-bkp.
    END.

    IF VALID-HANDLE(wgbosc032) THEN RUN destroy IN wgbosc032.

    /*** passar a etiqueta agrupadora que foram movimentada para geracao de etiquta - VIPAL MG **/
    FIND FIRST tt-epc
         WHERE tt-epc.cod-event     = "Finish_Update"
         NO-LOCK NO-ERROR.

    IF  AVAIL TT-EPC 
    THEN DO:
        {include/i-epc201.i "Finish_Update"}
    END.  
    /*** passar as etiquetas agrupadoras que foram movimentadas para geracao de etiquta - VIPAL MG **/
    Return 'OK':U.
End. 
&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
