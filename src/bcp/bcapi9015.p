/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9015 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9015 MBC}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i_dbinst.i}  /* vers∆o das bases e bases instaladas */
/*****************************************************************************
**     Programa...: bcapi9015.p  
**
**     Finalidade.: Api de efetivacao fechamento de carga
**
**     Criado em..: agosto de 2003
**
**     Versao.....: 2.00.00.000
******************************************************************************/
&if '{&mgscm_version}' >= '2.04' &then
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi001.i}   /* Definicao da temp-table tt-trans                       */
{bcp/bcapi002.i}   /* Definicao da temp-table tt-etiqueta                    */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */

/*****************************************************************************/

/*****************************************************************************/
Define Input        Parameter pNumTrans    As Integer   No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*****************************************************************************/
Define                   Variable vNumSerialAgrup               As Decimal                  No-undo.
Define                   Variable vNumSerialCarga               As Decimal                  No-undo.
Define                   Variable vNumSeq                       As Integer                  No-undo.
Define                   Variable vLogOK                        As Logical                  No-undo.
Define                   Variable vTransDetail                  As Character                No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char    Format "x(12)":U No-undo.
Define                   Variable wgbosc074                     As Handle                   No-undo.
Define                   Variable wgbosc075                     As Handle                   No-undo.
Define                   Variable vRaw                          As Raw                      No-undo.
DEFINE                   VARIABLE vdetalhe                      AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE vconteudo-trans               AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE vusuario                      AS CHARACTER                NO-UNDO.
DEFINE                   VARIABLE i-cont-erro                   AS INT                      NO-UNDO.

/*****************************************************************************/
Define Temp-table ttSerial No-undo
        Field de-serial As Decimal.

Define Temp-table ttWm-Carga NO-UNDO
        Like wm-carga.

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

IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
   Run scbo/bosc074.p Persistent Set wgbosc074.
   Run openQueryStatic In wgbosc074 (Input "Main":U) No-error.
END.
IF NOT VALID-HANDLE(wgbosc075)  THEN DO:
   Run scbo/bosc075.p Persistent Set wgbosc075.
   Run openQueryStatic In wgbosc075 (Input "Main":U) No-error.
END. 
/************************************************************/

BC9015:
DO TRANSACTION on ERROR  undo BC9015, leave BC9015
               on quit   undo BC9015, leave BC9015
               on stop   undo BC9015, leave BC9015
               on endkey undo BC9015, leave BC9015:
    
    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bc9015":U
           tt-prog-bc.cod-versao-integracao = 1
           tt-prog-bc.usuario               = c-seg-usuario
           tt-prog-bc.opcao                 = 1.

    Run bcp/bcapi004.p (Input-output Table tt-prog-bc,
                        Input-output Table tt-erro).

    Find First tt-prog-bc   No-error.
    Find First tt-erro      No-error.

    If  Available tt-erro Then Do:
        Create  tt-erro.
        ASSIGN i-cont-erro = i-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Erro_encontrado_quando_acessando_programa_bcapi004_(bc-prog-trans)" *}
        Assign  tt-erro.i-sequen    = i-cont-erro
                tt-erro.cd-erro     = 1
                tt-erro.mensagem    = RETURN-VALUE + '(DC)':U.
        Run DeleteObjects.
        UNDO BC9015, Return 'NOK':U.
    End. /* If  Available tt-erro */
    
    ASSIGN vusuario = trim(_RetornaValChar('usuario':U)).
    ASSIGN vdetalhe =  _RetornaValChar('detalhe':U).
    
    ASSIGN vLogOk = NO.
    {bcp/bc9017.i1  vusuario}
    IF vLogOk = NO THEN DO:
        Create  tt-erro.
        ASSIGN i-cont-erro = i-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-usuario AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Usu†rio" *}
        ASSIGN c-lbl-liter-usuario = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-nao-cadastrado-no-datasul-ems AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "n∆o_cadastrado_no_Datasul-EMS" *}
        ASSIGN c-lbl-liter-nao-cadastrado-no-datasul-ems = TRIM(RETURN-VALUE).
        Assign  tt-erro.i-sequen    = i-cont-erro
                tt-erro.cd-erro     = 2
                tt-erro.mensagem    = c-lbl-liter-usuario + ' ' +  _RetornaValChar('usuario') + ' ' + c-lbl-liter-nao-cadastrado-no-datasul-ems + '(DC)':U.
        Run DeleteObjects.
        UNDO BC9015, Return 'NOK':U.
    END.
    
    if NOT can-find(first bc-trans-filho WHERE
           bc-trans-filho.nr-trans = pNumTrans) THEN DO:
        Create tt-erro.
        ASSIGN i-cont-erro = i-cont-erro + 1.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "N∆o_existem_itens_lidos_pendentes_para_este_ponto_de_carga" *}
        Assign tt-erro.i-sequen = i-cont-erro
               tt-erro.cd-erro  = 3
               tt-erro.mensagem = RETURN-VALUE + '.' + '(DC)':U.
        Run DeleteObjects.
        UNDO BC9015, Return 'NOK':U.
    END.
    FOR EACH ttSerial:
        DELETE ttSerial.
    END.
    FOR EACH bc-trans-filho
        where bc-trans-filho.nr-trans = pNumTrans NO-LOCK :
        ASSIGN vconteudo-trans = substring(entry(2,bc-trans-filho.conteudo-trans,';':U),5).
        CREATE ttSerial.
        Assign ttSerial.de-serial = Dec(vconteudo-trans).
    END.

    Create ttWm-Carga.
    ASSIGN ttWm-Carga.dt-geracao      = Today
           ttWm-Carga.hr-geracao      = Time
           ttWm-Carga.cod-usuario     = vusuario.

    Run geraCarga In wgbosc075 (Input  Table ttWm-carga,
                                Output vNumSerialCarga).
    Release wm-param.
    Release wm-etiqueta.

    If  Return-value <> 'OK' Then Do:
        Run getRowErrors In wgbosc075(Output Table RowErrors).
        For Each RowErrors:
            Create tt-erro.
            Assign tt-erro.i-sequen = 4
                   tt-erro.cd-erro  = ErrorNumber
                   tt-erro.mensagem = ErrorDescription + '(WMS)':U.
        End. /* Each RowErrors */
        Run DeleteObjects.
        UNDO BC9015, Return 'NOK':U.
     End. /* Return-value <> 'OK' */

    For Each ttSerial:
        Run associaAgrupCarga In wgbosc074 (Input  _RetornaValChar('usuario':U),
                                            Input  ttSerial.de-serial,
                                            Input  vNumSerialCarga).
        Release wm-param.
        Release wm-etiqueta.

        If  Return-value <> 'OK' Then Do:
            Run getRowErrors In wgbosc074 (Output Table RowErrors).
            For Each RowErrors:
                Create tt-erro.
                ASSIGN i-cont-erro = i-cont-erro + 1.
                Assign tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription + '(WMS)':U.
            End. /* Each RowErrors */
            Run DeleteObjects.
            UNDO BC9015, Return 'NOK':U.
        End. /* Return-value <> 'OK' */
    End. /*For Each ttSerial:*/
    Run DeleteObjects.
End. 

Procedure DeleteObjects:
    
    Run destroy In wgbosc075 No-error.
    If  valid-handle(wgbosc075) Then Delete Object wgbosc075.
    Run destroy In wgbosc074 No-error.
    If  valid-handle(wgbosc074) Then Delete Object wgbosc074.
    Release bc-integracao.
    Release bc-trans.
    Release bc-trans-filho.

End. /* Procedure DeleteObjects: */

&else 
    run utp/ut-msgs.p (input "show", 
                       input 28036,
                       INPUT "").
&endif
