/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9022 2.00.00.004 } /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BCAPI9022 MUT}
&ENDIF


/********************************************************************************************
**   Programa..: bcapi9022.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - novembro/2002 - Karen - Criaá∆o do programa                 **
**                                                                                         **
**   Finalidade: Api de efetivacao do Packing List WMS                                     ** 
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9022.i}     /* Definicao dos campos de comunicacao com o adapter      */
/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans    As Integer   No-undo.
Define Input        Parameter pRaw         As Raw       No-undo.
Define Input-Output Parameter Table For tt-erro.
/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char     Format  "x(12)" No-undo.
Define                   Variable wgBOSC126                     As Widget-handle            No-undo.      
Define                   Variable wgBOSC111                     As Widget-handle            No-undo.      
Define                   Variable vRowid                        As Rowid                    No-undo.      

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
/*****************************************************************************/

/* Inicializacao dos objetos ativos ---                     */ 
Run scbo/bosc111.p Persistent Set wgBOSC111.
Run openQueryStatic In wgBOSC126 (Input "Main":U) No-error.

Run scbo/bosc126.p Persistent Set wgBOSC126.
Run openQueryStatic In wgBOSC126 (Input "Main":U) No-error.


/************************************************************/

BC9022:
DO TRANSACTION on ERROR  undo BC9022, leave BC9022
               on quit   undo BC9022, leave BC9022
               on stop   undo BC9022, leave BC9022
               on endkey undo BC9022, leave BC9022:

    Find First bc-trans Where bc-trans.nr-trans = pNumTrans NO-LOCK NO-ERROR.
    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bc9022"
           tt-prog-bc.cod-versao-integracao = 1
           tt-prog-bc.usuario               = c-seg-usuario
           tt-prog-bc.opcao                 = 1.

    Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

    Find First tt-prog-bc   NO-LOCK No-error.
    Find First tt-erro      NO-LOCK No-error.

    If  Available tt-erro Then Do:
        Create  tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_Trans" *}
        Assign  tt-erro.i-sequen    = 1
                tt-erro.cd-erro     = 1
                tt-erro.mensagem    = RETURN-VALUE.
        Run deleteObjects.
        UNDO BC9022, Return 'NOK':U.
    End. 
         
    Create tt-packing-wms.
    Raw-Transfer pRaw To tt-packing-wms.

    Find First tt-packing-wms NO-LOCK No-error.

    /* Valida de o usuario informado na transacao esta cadastrado no ems */
    If  Connected('mguni':U) Then Do:
        {bcp/bc9017.i1 tt-packing-wms.cod-usuario}
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
                   tt-erro.mensagem = c-lbl-liter-usuario + ' ' + tt-packing-wms.cod-usuario + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems.
            Run deleteObjects.
            UNDO BC9022, Return 'NOK':U.
        End.
    End.
    
    /*******************************************************************************************
     * Apenas se NAO FOI SOLICITADO um estorno                                                 *
     *******************************************************************************************/
    If tt-packing-wms.log-inicializa Then Do:
        Run iniciaTarefaResumoPedido In wgBOSC111(Input tt-packing-wms.cod-estabel,
                                                  Input tt-packing-wms.cod-local,
                                                  Input tt-packing-wms.cdd-embarq,
                                                  Input tt-packing-wms.num-resumo,
                                                  Input tt-packing-wms.cod-pedcli,
                                                  Input tt-packing-wms.nom-abrev, 
                                                  Input tt-packing-wms.num-tarefa, 
                                                  Input tt-packing-wms.cod-usuario, 
                                                  Input tt-packing-wms.cod-equipamento, 
                                                  Input tt-packing-wms.cod-coletor).
        If  Return-value <> 'OK':U Then do:
            Run getRowErrors In wgBOSC111 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Create tt-erro.
                Assign tt-erro.i-sequen = 8
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription.
            End.
            RUN deleteObjects.
            UNDO BC9022, Return 'NOK':U.
        End. 
    End.
    If  Not tt-packing-wms.log-finaliza  Then Do:
        IF tt-packing-wms.tip-movimento = 1 THEN DO:
           Run geraPackingList In wgBOSC126(Input tt-packing-wms.cod-estabel,
                                            Input tt-packing-wms.cod-local,
                                            Input tt-packing-wms.cdd-embarq,
                                            Input tt-packing-wms.num-resumo,
                                            Input tt-packing-wms.cod-pedcli,
                                            Input tt-packing-wms.nom-abrev, 
                                            Input tt-packing-wms.num-volume-pack,
                                            Input tt-packing-wms.cod-volume,
                                            Input tt-packing-wms.num-volume,
                                            Input tt-packing-wms.num-serial,
                                            Output vRowid).
           If  Return-value <> 'OK':U Then do:
               RUN getRowErrors In wgBOSC126 (Output Table RowErrors) No-error.
               FOR Each RowErrors:
                   Create tt-erro.
                   Assign tt-erro.i-sequen = 9
                          tt-erro.cd-erro  = ErrorNumber
                          tt-erro.mensagem = ErrorDescription.
               End. 
               RUN deleteObjects.
               UNDO BC9022, Return 'NOK':U.
           End. 
        END.
        ELSE DO:
            Run EstornoPackingList In wgBOSC126(Input tt-packing-wms.cod-estabel,
                                                Input tt-packing-wms.cod-local,
                                                Input tt-packing-wms.cdd-embarq,
                                                Input tt-packing-wms.num-resumo,
                                                Input tt-packing-wms.cod-pedcli,
                                                Input tt-packing-wms.nom-abrev, 
                                                Input tt-packing-wms.num-volume-pack,
                                                Input tt-packing-wms.num-serial,
                                                Input tt-packing-wms.cod-volume,
                                                Input tt-packing-wms.num-volume).
            If  Return-value <> 'OK':U Then do:
                RUN getRowErrors In wgBOSC126 (Output Table RowErrors) No-error.
                FOR Each RowErrors:
                    Create tt-erro.
                    Assign tt-erro.i-sequen = 9
                           tt-erro.cd-erro  = ErrorNumber
                           tt-erro.mensagem = ErrorDescription.
                End. 
                RUN deleteObjects.
                UNDO BC9022, Return 'NOK':U.
            End. 
        END.
    End.
    Else Do:
        Run encerraPackingList In wgBOSC126(Input tt-packing-wms.cod-estabel,
                                            Input tt-packing-wms.cod-local,
                                            Input tt-packing-wms.cdd-embarq,
                                            Input tt-packing-wms.num-resumo,
                                            Input tt-packing-wms.cod-pedcli,
                                            Input tt-packing-wms.nom-abrev, 
                                            Input tt-packing-wms.num-volume-pack,
                                            Input tt-packing-wms.cod-usuario, 
                                            Input tt-packing-wms.cod-equipamento, 
                                            Input tt-packing-wms.cod-coletor).
        
        If  Return-value <> 'OK':U Then do:
            Run getRowErrors In wgBOSC126 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Create tt-erro.
                Assign tt-erro.i-sequen = 10
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription.
            End. 
            Run deleteObjects.
            UNDO BC9022, Return 'NOK':U.
        End. 
    End.
    Run deleteObjects.
    Return 'OK':U.
End. 

Procedure deleteObjects:
    Run destroy In wgBOSC126 No-error.
    If valid-handle(wgBOSC126) Then
      Delete Object wgBOSC126.

    Run destroy In wgBOSC111 No-error.
    If valid-handle(wgBOSC111) Then
      Delete Object wgBOSC111.
End Procedure.



