/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BCAPI9016 2.00.00.005 } /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bcapi9016 MBC}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (2003)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
/********************************************************************************************
**   Programa..: bcapi9016.p                                                               **
**                                                                                         **
**   Versao....: 2.00.00.000 - setembro/2002 - Karen - Criaá∆o do programa                 **
**                                                                                         **
**   Finalidade: Api de efetivacao do Recebimento WMS                                      **                                                                                         **
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados    */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter      */
{bcp/bcapi004.i}   /* Definicao da temp-table tt-prog-bc                     */
{bcp/bc9016.i}     /* Definicao da temp-table de transferencia do coleta de dados */
{utp/utapi009.i}   /* login */
/*****************************************************************************/
Define Input        Parameter pNumTrans    As Integer   No-undo.
Define Input        Parameter TABLE FOR ttIntegracao.
Define Input-Output Parameter Table For tt-erro.

/*****************************************************************************/
Define                   Variable vNumSeq                       As Integer                           No-undo.
Define                   Variable vNrLeitura                    As Integer                           No-undo.
Define                   Variable vCodLocal                     As Character                         No-undo.
Define                   Variable vCodEstabel                   As Character                         No-undo.
Define New Global Shared Variable c-seg-usuario                 As Char Format  "x(12)":U            No-undo.
Define                   Variable wgbosc074                     As Widget-handle                     No-undo.      
Define                   Variable wgbosc093                     As Widget-handle                     NO-UNDO.      
Define                   Variable wgbosc094                     As Widget-handle                     No-undo.      
Define                   Variable wgbosc095                     As Widget-handle                     No-undo.      
Define                   Variable vLogOK                        As Logical                           No-undo.
DEFINE                   VARIABLE i-cont-erro                   AS INTEGER                           NO-UNDO.
DEFINE                   VARIABLE vdetalhe                      AS CHARACTER                         NO-UNDO.
DEFINE                   VARIABLE vtarefa                       As Character Format 'x(02)':U        NO-UNDO.
DEFINE                   VARIABLE vconteudo-trans               AS CHARACTER                         NO-UNDO.
DEFINE                   VARIABLE vusuario                      AS CHARACTER                         NO-UNDO.
DEFINE                   VARIABLE vcoletor                      As CHARACTER Format 'x(14)':U        NO-UNDO.   
DEFINE                   VARIABLE vequipamento                  As Character FORMAT 'x(14)':U        NO-UNDO.
DEFINE                   VARIABLE vdocumento                    As Character Format 'x(14)':U        NO-UNDO.
DEFINE                   VARIABLE vserial                       As DECIMAL Format '>>>>>>>>>>>>>>':U NO-UNDO.
DEFINE                   VARIABLE vinicia-processo              As Logical Format 'yes/no'           NO-UNDO.
DEFINE                   VARIABLE vfinaliza-processo            As Logical Format 'yes/no'           NO-UNDO.
DEFINE                   VARIABLE vestabel                      LIKE estabelec.cod-estabel           NO-UNDO.
DEFINE                   VARIABLE vlocal                        As Character Format 'x(5)':U         NO-UNDO.
DEFINE                   VARIABLE vnr-leitura                   AS INTEGER                           NO-UNDO.
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

DEFINE TEMP-TABLE ttWm-conferencia-item-aux NO-UNDO
    FIELD cod-estabel             AS CHAR
    FIELD cod-embalagem           AS CHAR
    FIELD cod-item                AS CHAR
    FIELD cod-refer               AS CHAR
    FIELD cod-usuario             AS CHAR
    FIELD cod-usuario-aprov       AS CHAR
    FIELD cod-local               AS CHAR
    FIELD id-box                  AS DEC
    FIELD id-docto                AS DEC
    FIELD id-etiqueta             AS DEC
    FIELD nr-leitura              AS INT
    FIELD qtd-item                AS DEC
    FIELD qtd-embalagem           AS DEC
    FIELD qtd-peso                AS DEC
 INDEX idx-conferencia-item AS PRIMARY UNIQUE
    cod-estabel asc
    cod-local asc
    id-docto asc
    nr-leitura asc
    cod-usuario asc
    id-etiqueta asc
    cod-item asc
    cod-refer asc
    id-box asc
    cod-embalagem asc.

DEFINE TEMP-TABLE ttWm-conferencia-aux NO-UNDO
    FIELD cod-estabel             AS CHAR
    FIELD cod-usuario             AS CHAR
    FIELD cod-local               AS CHAR
    FIELD id-docto                AS DEC
    FIELD ind-nivel-conferencia   AS INT
    FIELD ind-status-conferencia  AS INT
    FIELD ind-tipo-conferencia    AS INT
    FIELD nr-leitura              AS INT
 INDEX idx-conferencia AS PRIMARY UNIQUE
    nr-leitura asc
    id-docto asc
    cod-usuario asc.

/*****************************************************************************/

/* Inicializacao dos objetos ativos ---                     */ 
IF NOT VALID-HANDLE(wgbosc074)  THEN DO:
   Run scbo/bosc074.p Persistent Set wgbosc074.
END.

IF NOT VALID-HANDLE(wgbosc093) THEN DO:
   Run scbo/bosc093.p Persistent Set wgbosc093.
END.

IF NOT VALID-HANDLE(wgbosc094) THEN DO:
   Run scbo/bosc094.p Persistent Set wgbosc094.
END.

IF NOT VALID-HANDLE(wgbosc095) THEN DO:
   Run scbo/bosc095.p Persistent Set wgbosc095.
END.

BC9016:
DO TRANSACTION on ERROR  undo BC9016, leave BC9016
               on quit   undo BC9016, leave BC9016
               on stop   undo BC9016, leave BC9016
               on endkey undo BC9016, leave BC9016:

    Create tt-prog-bc.
    Assign tt-prog-bc.cod-prog-dtsul        = "bc9016":U
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
        Run deleteObjects.
        UNDO BC9016, Return 'NOK':U.
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
        UNDO BC9016, Return 'NOK':U.
    END.

    if NOT can-find(first bc-trans-filho WHERE
            bc-trans-filho.nr-trans = pNumTrans) THEN DO:
         Create tt-erro.
         ASSIGN i-cont-erro = i-cont-erro + 1.
         /* Inicio -- Projeto Internacional */
         {utp/ut-liter.i "Nao_existem_itens_lidos_para_conferància_do_documento" *}
         Assign tt-erro.i-sequen = i-cont-erro
                tt-erro.cd-erro  = 3
                tt-erro.mensagem = RETURN-VALUE + '(DC)':U.
         Run DeleteObjects.
         UNDO BC9016, Return 'NOK':U.
     END.
     FOR EACH tt-recebe-wms:
         DELETE tt-recebe-wms.
     END.

     ASSIGN vusuario = trim(_RetornaValChar('usuario':U))
            vdetalhe =  _RetornaValChar('detalhe':U).

     ASSIGN vdocumento   = ENTRY(2,ENTRY(1,vdetalhe,';':U),':':U)
            vtarefa      = ENTRY(2,ENTRY(2,vdetalhe,';':U),':':U)
            vestabel     = ENTRY(2,ENTRY(3,vdetalhe,';':U),':':U)
            vlocal       = ENTRY(2,ENTRY(4,vdetalhe,';':U),':':U).

     FOR EACH bc-trans-filho
         where bc-trans-filho.nr-trans = pNumTrans NO-LOCK :
         /* criar tt-recebe-wms */

         ASSIGN vconteudo-trans = bc-trans-filho.conteudo-trans.

         ASSIGN 
                vcoletor     = ENTRY(2,ENTRY(1,vconteudo-trans,';':U),':':U)
                vequipamento = ENTRY(2,ENTRY(2,vconteudo-trans,';':U),':':U)
                vserial      = dec(ENTRY(2,ENTRY(5,vconteudo-trans,';':U),':':U)).

         IF ENTRY(2,ENTRY(3,vconteudo-trans,';':U),':':U) = 'yes':U OR
            ENTRY(2,ENTRY(3,vconteudo-trans,';':U),':':U) = 'sim' THEN DO:
            ASSIGN vinicia-processo = YES.
         END.
         ELSE DO:
            ASSIGN vinicia-processo = NO.
         END.
         IF ENTRY(2,ENTRY(4,vconteudo-trans,';':U),':') = 'yes':U OR
            ENTRY(2,ENTRY(4,vconteudo-trans,';':U),':') = 'sim' THEN DO:
            ASSIGN vfinaliza-processo = YES.
         END.
         ELSE DO:
            ASSIGN vfinaliza-processo = NO.
         END.

         CREATE tt-recebe-wms.
         ASSIGN tt-recebe-wms.cod-usuario           = vusuario
                tt-recebe-wms.cod-coletor           = vcoletor
                tt-recebe-wms.cod-equipamento       = vequipamento
                tt-recebe-wms.cod-tarefa            = vtarefa
                tt-recebe-wms.cod-documento         = vdocumento
                tt-recebe-wms.num-serial            = vserial
                tt-recebe-wms.log-inicia-processo   = vinicia-processo 
                tt-recebe-wms.log-finaliza-processo = vfinaliza-processo
                tt-recebe-wms.cod-estabel           = vestabel
                tt-recebe-wms.cod-local             = vlocal.

         Run doctoConferenciaEmProcesso In wgbosc093 (Input  tt-recebe-wms.cod-estabel,
                                                      Input  tt-recebe-wms.cod-local,
                                                      Input tt-recebe-wms.cod-usuario,
                                                      Input Dec(tt-recebe-wms.cod-documento),
                                                      Output Table ttWm-conferencia-aux).

        If  Return-value <> 'OK':U Then do:
            Run getRowErrors In wgbosc093 (Output Table RowErrors) No-error.
            For Each RowErrors:
                Create tt-erro.
                ASSIGN i-cont-erro = i-cont-erro + 1.
                Assign tt-erro.i-sequen = i-cont-erro
                       tt-erro.cd-erro  = ErrorNumber
                       tt-erro.mensagem = ErrorDescription + "(WMS)".
            End. /* Each RowErrors */
            Run deleteObjects.
            UNDO BC9016, Return 'NOK':U.
         End. /* If  Return-value <> 'OK' Then do: */

         Find First ttWm-conferencia-aux No-error.

         If  Not Avail ttWm-conferencia-aux Then do:
             Create tt-erro.
             ASSIGN i-cont-erro = i-cont-erro + 1.
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Nao_foi_possivel_localizar_leitura_corrente" *}
             Assign tt-erro.i-sequen = i-cont-erro
                    tt-erro.cd-erro  = 1
                    tt-erro.mensagem = RETURN-VALUE + '.' + '(WMS)':U.
             Run deleteObjects.
             UNDO BC9016, Return 'NOK':U.
          End.  /* If   Not Avail ttWm-conferencia-aux Then do: */
          ASSIGN vnr-leitura = ttWm-conferencia-aux.nr-leitura.

          Run validaEtiquetaDocto In wgbosc074 (Input tt-recebe-wms.cod-estabel,
                                                Input tt-recebe-wms.cod-local,
                                                Input tt-recebe-wms.cod-documento,
                                                Input tt-recebe-wms.num-serial).

           If  Return-value <> 'OK':U Then do:
               Run getRowErrors In wgbosc074 (Output Table RowErrors) No-error.
               For Each RowErrors:
                  Create tt-erro.
                  ASSIGN i-cont-erro = i-cont-erro + 1.
                  Assign tt-erro.i-sequen = i-cont-erro
                         tt-erro.cd-erro  = ErrorNumber
                         tt-erro.mensagem = ErrorDescription + "(WMS)":U.
               End. /* Each RowErrors */
               Run deleteObjects.
               UNDO BC9016, Return 'NOK':U.
            End. /* If  Return-value <> 'OK' Then do: */

            FOR each ttWm-conferencia-item-aux:
                DELETE ttWm-conferencia-item-aux.
            END.

            Create ttWm-conferencia-item-aux.
            Assign ttWm-conferencia-item-aux.cod-estabel       = ttWm-conferencia-aux.cod-estabel
                   ttWm-conferencia-item-aux.cod-embalagem     = ""
                   ttWm-conferencia-item-aux.cod-item          = ""
                   ttWm-conferencia-item-aux.cod-refer         = ""
                   ttWm-conferencia-item-aux.cod-usuario       = tt-recebe-wms.cod-usuario
                   ttWm-conferencia-item-aux.cod-usuario-aprov = ""
                   ttWm-conferencia-item-aux.cod-local         = ttWm-conferencia-aux.cod-local
                   ttWm-conferencia-item-aux.id-box            = 0
                   ttWm-conferencia-item-aux.id-docto          = dec(tt-recebe-wms.cod-documento)
                   ttWm-conferencia-item-aux.id-etiqueta       = tt-recebe-wms.num-serial
                   ttWm-conferencia-item-aux.nr-leitura        = ttWm-conferencia-aux.nr-leitura
                   ttWm-conferencia-item-aux.qtd-item          = 0
                   ttWm-conferencia-item-aux.qtd-embalagem     = 1
                   ttWm-conferencia-item-aux.qtd-peso          = 0.

             Run createWm-conferencia-item In wgbosc094 (Input Table ttWm-conferencia-item-aux).

             If  Return-value <> 'OK':U Then do:
                 Run getRowErrors In wgbosc094 (Output Table RowErrors) No-error.
                 For Each RowErrors:
                    Create tt-erro.
                    ASSIGN i-cont-erro = i-cont-erro + 1.
                    Assign tt-erro.i-sequen = i-cont-erro
                           tt-erro.cd-erro  = ErrorNumber
                           tt-erro.mensagem = ErrorDescription + "(WMS)":U.
                 End. /* Each RowErrors */
                 Run deleteObjects.
                 UNDO BC9016, Return 'NOK':U.
            End. /* If  Return-value <> 'OK' Then do: */

            /* Processo concluido com sucesso */
     END.
     /* ap¢s envio dos seriais, encerramento da tarefa/doc */

     Run concluiTarefaDoctoConferencia In wgbosc095 (Input vestabel,
                                                     Input vlocal,
                                                     Input vdocumento,
                                                     Input Dec(vtarefa),
                                                     Input vnr-leitura,
                                                     Input vusuario).

     If  Return-value <> 'OK':U Then do:
          Run getRowErrors In wgbosc095(Output Table RowErrors) No-error.
          For Each RowErrors:
             Create tt-erro.
             ASSIGN i-cont-erro = i-cont-erro + 1.
             Assign tt-erro.i-sequen = i-cont-erro
                    tt-erro.cd-erro  = ErrorNumber
                    tt-erro.mensagem = ErrorDescription + "(WMS)":U.
          End. /* Each RowErrors */
          Run deleteObjects.
          UNDO BC9016, Return 'NOK':U.
      End. /* If  Return-value <> 'OK' Then do: */

      /* Processo concluido com sucesso */
      Run deleteObjects.
      Return 'OK':U.
End. /* Do: */

Procedure deleteObjects:
    Run destroy In wgbosc074 No-error.
    Run destroy In wgbosc093 No-error.
    Run destroy In wgbosc094 No-error.
    Run destroy In wgbosc095 No-error.
    If  valid-handle(wgbosc074) Then Delete Object wgbosc074.
    If  valid-handle(wgbosc093) Then Delete Object wgbosc093.
    If  valid-handle(wgbosc094) Then Delete Object wgbosc094.
    If  valid-handle(wgbosc095) Then Delete Object wgbosc095.
End Procedure.
