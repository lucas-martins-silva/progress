/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9037D 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9037d MBC}
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
**   Programa..: bc9037d.p                                                                 **
**                                                                                         **
**   Versao....: 2.00.00.000 - agosto/2006 - Cria‡Æo do programa                           **
**                                                                                         **
**   Finalidade: Adapter da transacao de Conferˆncia Embarque                              ** 
**                                                                                         **
********************************************************************************************/
{bcp/bc9102.i}     /* Definicao da temp-table de erros do coleta de dados         */
{bcp/bc9107.i}     /* Definicao dos campos de comunicacao com o adapter           */
{bcp/bc9037.i}     /* Definicao da temp-table de transferencia do coleta de dados */
/* DEFINICAO FIXA POIS A TABELA NAO EXISTE NA VERSAO 2.02 - FLAVIO.ARCEGA
{scbo/bosc156.i TtWms-conferen-packing }   /* TEMP-TABLE DE BOSC056 */     */
DEFINE TEMP-TABLE TtWms-conferen-packing
    FIELD cod-estabel        AS CHAR      FORMAT "X(3)":U               
    FIELD cod-local          AS CHAR      FORMAT "X(3)":U               
    FIELD id-docto           AS DECIMAL   FORMAT ">>>>>>>>>9":U DECIMALS 10        
    FIELD nr-leitura         AS INT       FORMAT ">>9":U                
    FIELD cod-usuario        AS CHAR      FORMAT "X(12)":U              
    FIELD val-etiq-packing   AS DECIMAL   FORMAT ">>>>>>>>>>>>>>9":U DECIMALS 0  
    FIELD cod-embalagem      AS CHAR      FORMAT "X(10)":U              
    FIELD cdd-embarq         AS DEC       FORMAT ">>>>>>>>>>>>>>>9":U             
    FIELD nr-resumo          AS INT       FORMAT ">>>>,>>9":U           
    FIELD nr-pedcli          AS CHAR      FORMAT "X(12)":U              
    FIELD nome-abrev         AS CHAR      FORMAT "X(12)":U              
    FIELD num-volume         AS INT       FORMAT ">>>>>>>>>9":U         
    FIELD cod-usuario-aprov  AS CHAR      FORMAT "X(12)":U              
    FIELD cod-livre-1        AS CHAR      FORMAT "X(100)":U             
    FIELD cod-livre-2        AS CHAR      FORMAT "X(100)":U             
    FIELD log-livre-1        AS LOGICAL   FORMAT "Sim/NÆo"             
    FIELD log-livre-2        AS LOGICAL   FORMAT "Sim/NÆo"            
    FIELD num-livre-1        AS INTEGER   FORMAT "->>>>>>>>9":U         
    FIELD num-livre-2        AS INTEGER   FORMAT "->>>>>>>>9":U
    FIELD val-livre-1        AS DECIMAL   FORMAT "->>>>>>>>>>>9.9999":U DECIMALS 10
    FIELD val-livre-2        AS DECIMAL   FORMAT "->>>>>>>>>>>9.9999":U DECIMALS 10
    FIELD dat-livre-1        AS DATE      FORMAT "99/99/9999":U         
    FIELD dat-livre-2        AS DATE      FORMAT "99/99/9999":U
    FIELD r-Rowid            AS ROWID.

/*********************************************************************************/

/*********************************************************************************/
Define Input        Parameter pNumTrans    as integer No-undo.
Define Input        Parameter Table For ttIntegracao.
Define Input-Output Parameter Table For tt-erro.
/*********************************************************************************/
Define Variable vRaw                As Raw                  No-undo.
DEFINE VARIABLE vsequencia          AS INTEGER              NO-UNDO.
/*********************************************************************************/

DEF VAR hBosc156 AS HANDLE NO-UNDO.
DEF VAR hBosc095 AS HANDLE NO-UNDO.

DEF VAR de-num-serial           AS DEC NO-UNDO.
DEF VAR de-num-serial-agrupador AS DEC NO-UNDO.
DEF VAR ind-sit-agrup-serial    AS INT NO-UNDO.
DEF VAR r-rowid-tabela  AS ROWID NO-UNDO.
DEF VAR cCodEquipamento AS CHAR NO-UNDO.
DEF VAR cCodColetor     AS CHAR NO-UNDO.
DEF VAR cCodUsuario     AS CHAR NO-UNDO.

Define Temp-table RowErrors No-undo 
    Field ErrorSequence    As Integer 
    Field ErrorNumber      As Integer 
    Field ErrorDescription As Character 
    Field ErrorParameters  As Character 
    Field ErrorType        As Character 
    Field ErrorHelp        As Character 
    Field ErrorSubType     As Character.


DO TRANS:
    
    EMPTY TEMP-TABLE tt-erro.

    Find First ttIntegracao No-lock No-error.
    
    If  Not Avail ttIntegracao Then Do:
        Run utp/ut-msgs.p ( input "msg",
                            input 25346,
                            input "bc9037d").
        Create  tt-erro.
  
        Assign  tt-erro.cd-erro  = 25346
                tt-erro.i-sequen = vsequencia
                tt-erro.mensagem = trim(return-value) + "(DC)":U.
        Return 'NOK':U.
    End.

    Find First tt-erro No-lock No-error.

    If  Avail tt-erro
    Then
        Return "NOK":U.

    de-num-serial           = _RetornaValDeci('num-serial').
    de-num-serial-agrupador = _RetornaValDeci('num-serial-agrupador').
    ind-sit-agrup-serial    = _RetornaValInte('ind-sit-agrup-serial').
    cCodEquipamento         = _RetornaValChar('cod-equipamento').
    cCodColetor             = _RetornaValChar('cod-coletor').
    cCodUsuario             = _RetornaValChar('cod-usuario').

    bc9037:
    DO on error  undo bc9037, leave bc9037
       on quit   undo bc9037, leave bc9037
       on stop   undo bc9037, leave bc9037
       on endkey undo bc9037, leave bc9037:
        
        IF ind-sit-agrup-serial = 1 THEN DO: /* Etiqueta nao Agrupadora */
            /*******************************************************/
            /* Remover a associa‡Æo do item da etiqueta agrupadora */
            /*******************************************************/
            IF NOT VALID-HANDLE(wgbosc074) THEN DO:
                RUN scbo/bosc074.p PERSISTENT SET wgbosc074       NO-ERROR.
                RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
            END.

            RUN desassociaEtiquetasAgrup IN wgbosc074 (INPUT de-num-serial,
                                                       INPUT de-num-serial-agrupador,
                                                       OUTPUT TABLE RowErrors).
            
            IF RETURN-VALUE <> 'OK':U THEN DO:

               Run getRowErrors In wgbosc074 (Output Table RowErrors) No-error.
    
               For Each RowErrors:
                   Create tt-erro.
                   Assign tt-erro.i-sequen = 1
                          tt-erro.cd-erro  = ErrorNumber
                          tt-erro.mensagem = ErrorDescription + "(WMS)".
                   
               End. /* Each RowErrors */
    
               DELETE OBJECT wgbosc074.
               UNDO, Return 'NOK':U.

            END.
            RETURN "OK":U.
        END.
        ELSE DO: /* Serial ‚ agrupador etiquetas (2) ou agrupador proprio (3) */
            /*********************************************************/
            /* Remover a associa‡Æo dos itens da etiqueta agrupadora */
            /*********************************************************/
            IF NOT VALID-HANDLE(wgbosc074) THEN DO:
                RUN scbo/bosc074.p PERSISTENT SET wgbosc074       NO-ERROR.
                RUN openQueryStatic IN wgbosc074 (INPUT "Main":U) NO-ERROR.
            END.
    
            RUN desassociaEtiquetas IN wgbosc074 (INPUT  cCodUsuario,
                                                  INPUT  de-num-serial,
                                                  OUTPUT TABLE RowErrors).
    
            IF RETURN-VALUE <> 'OK':U THEN DO:

               Run getRowErrors In wgbosc074 (Output Table RowErrors) No-error.
    
               For Each RowErrors:
                   Create tt-erro.
                   Assign tt-erro.i-sequen = 1
                          tt-erro.cd-erro  = ErrorNumber
                          tt-erro.mensagem = ErrorDescription + "(WMS)".
                   
               End. /* Each RowErrors */
    
               DELETE OBJECT wgbosc074.
               UNDO, Return 'NOK':U.

             END.
             RETURN "OK":U.
        END.
    END.
    
    if error-status:error = YES OR RETURN-VALUE <> 'OK':U then do:

        ASSIGN vsequencia =  vsequencia + 1.
        FIND LAST tt-erro NO-LOCK NO-ERROR.
        IF AVAILABLE tt-erro THEN ASSIGN vsequencia = tt-erro.i-sequen + 1.
        create tt-erro.
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Problemas_no_processo_PRE-API" *}
        assign tt-erro.i-sequen = vsequencia
               tt-erro.cd-erro  = 999
               tt-erro.mensagem = RETURN-VALUE + " " + error-status:get-message(1) + "(DC)":U.
        
        UNDO, RETURN "NOK".

    END.

End. /* Do: Main */

