&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN767 2.00.00.044 } /*** "010044" 17/06/2025 16:40:54 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin767 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : boin767.p
    Purpose    : Cont‚m a l¢gica de neg¢cio e acesso a dados para a tabela
                 mla-doc-pend-aprov
    Parameters : 

    Notes      : 
----------------------------------------------------------------------- ---*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName boin767
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-doc-pend-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND TRUE
&GLOBAL-DEFINE CHANGE-QUERY-TO-FIND-PROCS selecao

/*:T--- Include com defini‡Æo da temptable RowObject ---*/
{inbo/boin767.i RowObject}

/*:T--- Include com defini‡Æo da query para tabela {&TableName} ---*/
{method/dboqry.i}

{utp/ut-glob.i}

/*:T--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

/**  Defini‡Æo das temp-tables **/
{inbo/boin767.i1}
{inbo/boin767.i3}                   /* Temp-tables utilizadas na piSubstituiAprovador           */
{lap/mlaapi001.i04}                 /* tt-doc-integrated-fluig                                  */
{inbo/boin768.i tt-mla-doc-sit-aux} /* Defini‡Æo temp-table utilizada na piSubstituiAprovador   */

DEFINE TEMP-TABLE tt-mla-usuar-aprov-altern NO-UNDO LIKE mla-usuar-aprov-altern
    FIELD r-Rowid AS ROWID.

/* Utilizada na procedure getPendenciasAprov (melhora de performance) */
DEFINE TEMP-TABLE tt-mla-usuar-aprov-pend NO-UNDO
    FIELD cod-usuar    AS CHARACTER
    FIELD nome-usuar   AS CHARACTER
    FIELD usuar-mestre AS LOGICAL
        INDEX id IS PRIMARY UNIQUE cod-usuar.


DEFINE TEMP-TABLE ttApprovalUser NO-UNDO
    FIELD cod-usuar    AS CHARACTER SERIALIZE-NAME "code":U
    FIELD nome-usuar   AS CHARACTER SERIALIZE-NAME "name":U
    FIELD e-mail       AS CHARACTER SERIALIZE-NAME "email":U.

/**  Variaveis necessarias aos setConstraints **/
DEFINE VARIABLE i-ind-situacao-ini       LIKE mla-doc-pend-aprov.ind-situacao       NO-UNDO.
DEFINE VARIABLE i-ind-situacao-fim       LIKE mla-doc-pend-aprov.ind-situacao       NO-UNDO.
DEFINE VARIABLE i-ep-codigo-ini          LIKE mla-doc-pend-aprov.ep-codigo          NO-UNDO.
DEFINE VARIABLE i-ep-codigo-fim          LIKE mla-doc-pend-aprov.ep-codigo          NO-UNDO.
DEFINE VARIABLE c-cod-estabel-ini        LIKE mla-doc-pend-aprov.cod-estabel        NO-UNDO.
DEFINE VARIABLE c-cod-estabel-fim        LIKE mla-doc-pend-aprov.cod-estabel        NO-UNDO.
DEFINE VARIABLE i-cod-tip-doc-ini        LIKE mla-doc-pend-aprov.cod-tip-doc        NO-UNDO.
DEFINE VARIABLE i-cod-tip-doc-fim        LIKE mla-doc-pend-aprov.cod-tip-doc        NO-UNDO.
DEFINE VARIABLE l-historico              LIKE mla-doc-pend-aprov.historico          NO-UNDO.
DEFINE VARIABLE l-so-alternativos        LIKE mla-doc-pend-aprov.historico          NO-UNDO.
DEFINE VARIABLE l-sem-limite             LIKE mla-doc-pend-aprov.historico          NO-UNDO.
DEFINE VARIABLE l-sem-lotacao            LIKE mla-doc-pend-aprov.historico          NO-UNDO.
DEFINE VARIABLE c-cod-usuar-aprov-ini    LIKE mla-doc-pend-aprov.cod-usuar          NO-UNDO.
DEFINE VARIABLE c-cod-usuar-aprov-fim    LIKE mla-doc-pend-aprov.cod-usuar          NO-UNDO.
DEFINE VARIABLE c-cod-usuar-altern-ini   LIKE mla-doc-pend-aprov.cod-usuar-altern   NO-UNDO.
DEFINE VARIABLE c-cod-usuar-altern-fim   LIKE mla-doc-pend-aprov.cod-usuar-altern   NO-UNDO.
DEFINE VARIABLE c-cod-usuar-doc-ini      LIKE mla-doc-pend-aprov.cod-usuar-doc      NO-UNDO.
DEFINE VARIABLE c-cod-usuar-doc-fim      LIKE mla-doc-pend-aprov.cod-usuar-doc      NO-UNDO.
DEFINE VARIABLE c-cod-usuar-trans-ini    LIKE mla-doc-pend-aprov.cod-usuar-trans    NO-UNDO.
DEFINE VARIABLE c-cod-usuar-trans-fim    LIKE mla-doc-pend-aprov.cod-usuar-trans    NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-doc-ini    LIKE mla-doc-pend-aprov.cod-lotacao-doc    NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-doc-fim    LIKE mla-doc-pend-aprov.cod-lotacao-doc    NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-trans-ini  LIKE mla-doc-pend-aprov.cod-lotacao-trans  NO-UNDO.
DEFINE VARIABLE c-cod-lotacao-trans-fim  LIKE mla-doc-pend-aprov.cod-lotacao-trans  NO-UNDO.
DEFINE VARIABLE de-valor-ini             LIKE mla-doc-pend-aprov.valor-doc          NO-UNDO.
DEFINE VARIABLE de-valor-fim             LIKE mla-doc-pend-aprov.valor-doc          NO-UNDO.
DEFINE VARIABLE da-geracao-ini           LIKE mla-doc-pend-aprov.dt-geracao         NO-UNDO.
DEFINE VARIABLE da-geracao-fim           LIKE mla-doc-pend-aprov.dt-geracao         NO-UNDO.
DEFINE VARIABLE da-aprovacao-ini         LIKE mla-doc-pend-aprov.dt-aprova          NO-UNDO.
DEFINE VARIABLE da-aprovacao-fim         LIKE mla-doc-pend-aprov.dt-aprova          NO-UNDO.
DEFINE VARIABLE da-rejeicao-ini          LIKE mla-doc-pend-aprov.dt-rejeita         NO-UNDO.
DEFINE VARIABLE da-rejeicao-fim          LIKE mla-doc-pend-aprov.dt-rejeita         NO-UNDO.
DEFINE VARIABLE da-reaprovacao-ini       LIKE mla-doc-pend-aprov.dt-reaprova        NO-UNDO.
DEFINE VARIABLE da-reaprovacao-fim       LIKE mla-doc-pend-aprov.dt-reaprova        NO-UNDO.
DEFINE VARIABLE c-chave-doc-ini          LIKE mla-doc-pend-aprov.chave-doc          NO-UNDO.
DEFINE VARIABLE c-chave-doc-fim          LIKE mla-doc-pend-aprov.chave-doc          NO-UNDO.
DEFINE VARIABLE c-cod-usuar              LIKE mla-usuar-aprov.cod-usuar             NO-UNDO.
DEFINE VARIABLE l-assume-permissoes-prin AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE l-assume-lotacoes-prin   AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE l-assume-mestre-prin     AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE l-log-aprov-altern-data  AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE l-mestre                 AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE l-aprovador-mestre       AS LOGICAL                                 NO-UNDO.
/**  Outras Vari veis **/
DEFINE VARIABLE l-spp-allPendAprov       AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE cAuxTraducao001          AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-cod-usuar-trans        AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-lista-situacao         AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE c-prazo-aprov            AS CHARACTER                               NO-UNDO.
DEFINE VARIABLE hmla-usuar-aprov         AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE hmla-perm-aprov          AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE hmla-perm-lotacao        AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE hmla-usuar-aprov-altern  AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE hmla-param-aprov         AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE h-mlaapi014              AS HANDLE                                  NO-UNDO.
DEFINE VARIABLE iNumRowsReturned         AS INTEGER                                 NO-UNDO.
DEFINE VARIABLE l-limite                 AS LOGICAL                                 NO-UNDO.
DEFINE VARIABLE l-lotacao                AS LOGICAL                                 NO-UNDO.

/**  Boot Variaveis **/
ASSIGN l-spp-allPendAprov = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-allPendAprov":U AND funcao.ativo).

&IF "{&FNC_MULTI_IDIOMA}":U = "Yes":U &THEN
    ASSIGN cAuxTraducao001 = {ininc/i01in767.i 3}.
    RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
    ASSIGN  c-lista-situacao = cAuxTraducao001.
&ELSE
    ASSIGN c-lista-situacao = {ininc/i01in767.i 3}.
&ENDIF


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 2.08
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

DEFINE TEMP-TABLE RowErrorsAux LIKE RowErrors.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroy DBOProgram 
PROCEDURE afterDestroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(hmla-usuar-aprov) THEN DO:
        DELETE PROCEDURE hmla-usuar-aprov.
        ASSIGN hmla-usuar-aprov = ?.
    END.
    IF VALID-HANDLE(hmla-perm-aprov) THEN DO:
        DELETE PROCEDURE hmla-perm-aprov.
        ASSIGN hmla-perm-aprov = ?.
    END.
    IF VALID-HANDLE(hmla-perm-lotacao) THEN DO:
        DELETE PROCEDURE hmla-perm-lotacao.
        ASSIGN hmla-perm-lotacao = ?.
    END.
    IF VALID-HANDLE(hmla-usuar-aprov-altern) THEN DO:
        DELETE PROCEDURE hmla-usuar-aprov-altern.
        ASSIGN hmla-usuar-aprov-altern = ?.
    END.
    IF VALID-HANDLE(hmla-param-aprov) THEN DO:
        DELETE PROCEDURE hmla-param-aprov.
        ASSIGN hmla-param-aprov = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE createTTmlaUsuarAprovPend DBOProgram 
PROCEDURE createTTmlaUsuarAprovPend :
/*------------------------------------------------------------------------------
  Purpose:     Centralizar a criação da tabela temporária e o preenchimento dos campos
  Parameters:  pc-cod-usuar (entrada) -  código do usuário
               ph-boin785   (entrada) - handle da bo instanciado e ja executado o metodo openQuery
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pc-cod-usuar AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER ph-boin785   AS HANDLE    NO-UNDO.

    RUN goToKey IN ph-boin785 (INPUT pc-cod-usuar).

    IF  RETURN-VALUE = "OK":U 
    AND NOT CAN-FIND(FIRST tt-mla-usuar-aprov-pend WHERE tt-mla-usuar-aprov-pend.cod-usuar = pc-cod-usuar) THEN DO:

        CREATE tt-mla-usuar-aprov-pend.
        ASSIGN tt-mla-usuar-aprov-pend.cod-usuar = pc-cod-usuar.
        
        RUN getCharField IN ph-boin785 (INPUT "nome-usuar":U,   OUTPUT tt-mla-usuar-aprov-pend.nome-usuar).
        RUN getLogField  IN ph-boin785 (INPUT "usuar-mestre":U, OUTPUT tt-mla-usuar-aprov-pend.usuar-mestre).
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findfirstSelecao DBOProgram 
PROCEDURE findfirstSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND FIRST {&TABLENAME} 
         WHERE {&TABLENAME}.ind-situacao      >= i-ind-situacao-ini 
           AND {&TABLENAME}.ind-situacao      <= i-ind-situacao-fim 
           AND {&TABLENAME}.ep-codigo         >= i-ep-codigo-ini 
           AND {&TABLENAME}.ep-codigo         <= i-ep-codigo-fim 
           AND {&TABLENAME}.cod-estabel       >= c-cod-estabel-ini 
           and {&TABLENAME}.cod-estabel       <= c-cod-estabel-fim 
           AND {&TABLENAME}.cod-tip-doc       >= i-cod-tip-doc-ini 
           AND {&TABLENAME}.cod-tip-doc       <= i-cod-tip-doc-fim 
           AND {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini 
           AND {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim 
           AND {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini 
           AND {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim 
           AND {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini 
           AND {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim 
           AND {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini 
           AND {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim 
           AND {&TABLENAME}.valor-doc         >= de-valor-ini 
           AND {&TABLENAME}.valor-doc         <= de-valor-fim 
           AND {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)      
           AND {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)      
           AND {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)    
           AND {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)    
           AND {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)     
           AND {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)     
           AND {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini)  
           AND {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim)  
           AND {&TABLENAME}.chave-doc         >= c-chave-doc-ini 
           AND {&TABLENAME}.chave-doc         <= c-chave-doc-fim 
           AND {&TABLENAME}.historico          = l-historico NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findlastSelecao DBOProgram 
PROCEDURE findlastSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND LAST {&TABLENAME} 
        WHERE {&tablename}.ind-situacao      >= i-ind-situacao-ini 
          AND {&tablename}.ind-situacao      <= i-ind-situacao-fim 
          AND {&TABLENAME}.ep-codigo         >= i-ep-codigo-ini 
          AND {&TABLENAME}.ep-codigo         <= i-ep-codigo-fim 
          AND {&TABLENAME}.cod-estabel       >= c-cod-estabel-ini 
          AND {&TABLENAME}.cod-estabel       <= c-cod-estabel-fim 
          AND {&TABLENAME}.cod-tip-doc       >= i-cod-tip-doc-ini 
          AND {&TABLENAME}.cod-tip-doc       <= i-cod-tip-doc-fim 
          AND {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini 
          AND {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim 
          AND {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini 
          AND {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim 
          AND {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini 
          AND {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim 
          AND {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini 
          AND {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim 
          AND {&TABLENAME}.valor-doc         >= de-valor-ini 
          AND {&TABLENAME}.valor-doc         <= de-valor-fim 
          AND {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)      
          AND {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)      
          AND {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)    
          AND {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)    
          AND {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)     
          AND {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)     
          AND {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini)  
          AND {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim)  
          AND {&TABLENAME}.chave-doc         >= c-chave-doc-ini 
          AND {&TABLENAME}.chave-doc         <= c-chave-doc-fim 
          AND {&TABLENAME}.historico          = l-historico NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findnextSelecao DBOProgram 
PROCEDURE findnextSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND NEXT {&TABLENAME} 
        WHERE {&TABLENAME}.ind-situacao      >= i-ind-situacao-ini 
          AND {&TABLENAME}.ind-situacao      <= i-ind-situacao-fim 
          AND {&TABLENAME}.ep-codigo         >= i-ep-codigo-ini 
          AND {&TABLENAME}.ep-codigo         <= i-ep-codigo-fim 
          AND {&TABLENAME}.cod-estabel       >= c-cod-estabel-ini 
          AND {&TABLENAME}.cod-estabel       <= c-cod-estabel-fim 
          AND {&TABLENAME}.cod-tip-doc       >= i-cod-tip-doc-ini 
          AND {&TABLENAME}.cod-tip-doc       <= i-cod-tip-doc-fim 
          AND {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini 
          AND {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim 
          AND {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini 
          AND {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim 
          AND {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini 
          AND {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim 
          AND {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini 
          AND {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim 
          AND {&TABLENAME}.valor-doc         >= de-valor-ini 
          AND {&TABLENAME}.valor-doc         <= de-valor-fim 
          AND {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)      
          AND {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)      
          AND {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)    
          AND {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)    
          AND {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)     
          AND {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)     
          AND {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini)  
          AND {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim)  
          AND {&TABLENAME}.chave-doc         >= c-chave-doc-ini 
          AND {&TABLENAME}.chave-doc         <= c-chave-doc-fim 
          AND {&TABLENAME}.historico          = l-historico NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findprevSelecao DBOProgram 
PROCEDURE findprevSelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    FIND PREV {&TABLENAME} 
        WHERE {&tablename}.ind-situacao      >= i-ind-situacao-ini 
          AND   {&tablename}.ind-situacao      <= i-ind-situacao-fim 
          AND   {&TABLENAME}.ep-codigo         >= i-ep-codigo-ini 
          AND   {&TABLENAME}.ep-codigo         <= i-ep-codigo-fim 
          AND   {&TABLENAME}.cod-estabel       >= c-cod-estabel-ini 
          AND   {&TABLENAME}.cod-estabel       <= c-cod-estabel-fim 
          AND   {&TABLENAME}.cod-tip-doc       >= i-cod-tip-doc-ini 
          AND   {&TABLENAME}.cod-tip-doc       <= i-cod-tip-doc-fim 
          AND   {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini 
          AND   {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim 
          AND   {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini 
          AND   {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim 
          AND   {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini 
          AND   {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim 
          AND   {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini 
          AND   {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim 
          AND   {&TABLENAME}.valor-doc         >= de-valor-ini 
          AND   {&TABLENAME}.valor-doc         <= de-valor-fim 
          AND   {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)      
          AND   {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)      
          AND   {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)    
          AND   {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)    
          AND   {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)     
          AND   {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)     
          AND   {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini)  
          AND   {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim)  
          AND   {&TABLENAME}.chave-doc         >= c-chave-doc-ini 
          AND   {&TABLENAME}.chave-doc         <= c-chave-doc-fim 
          AND   {&TABLENAME}.historico          = l-historico NO-LOCK NO-ERROR.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U             THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U             THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U             THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U             THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U             THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "chave-doc":U          THEN ASSIGN pFieldValue = RowObject.chave-doc.
        WHEN "cod-estabel":U        THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-lotacao-doc":U    THEN ASSIGN pFieldValue = RowObject.cod-lotacao-doc.
        WHEN "cod-lotacao-trans":U  THEN ASSIGN pFieldValue = RowObject.cod-lotacao-trans.
        WHEN "cod-referencia":U     THEN ASSIGN pFieldValue = RowObject.cod-referencia.
        WHEN "cod-usuar":U          THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "cod-usuar-altern":U   THEN ASSIGN pFieldValue = RowObject.cod-usuar-altern.
        WHEN "cod-usuar-doc":U      THEN ASSIGN pFieldValue = RowObject.cod-usuar-doc.
        WHEN "cod-usuar-trans":U    THEN ASSIGN pFieldValue = RowObject.cod-usuar-trans.
        WHEN "ep-codigo":U          THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        WHEN "hora-geracao":U       THEN ASSIGN pFieldValue = RowObject.hora-geracao.
        WHEN "it-codigo":U          THEN ASSIGN pFieldValue = RowObject.it-codigo.
        WHEN "motivo-doc":U         THEN ASSIGN pFieldValue = RowObject.motivo-doc.
        WHEN "motivo-hist":U        THEN ASSIGN pFieldValue = RowObject.motivo-hist.
        WHEN "narrativa-apr":U      THEN ASSIGN pFieldValue = RowObject.narrativa-apr.
        WHEN "narrativa-rej":U      THEN ASSIGN pFieldValue = RowObject.narrativa-rej.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE      NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U      THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U      THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U      THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U      THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U      THEN ASSIGN pFieldValue = RowObject.data-5.
        WHEN "dt-aprova":U   THEN ASSIGN pFieldValue = RowObject.dt-aprova.
        WHEN "dt-geracao":U  THEN ASSIGN pFieldValue = RowObject.dt-geracao.
        WHEN "dt-reaprova":U THEN ASSIGN pFieldValue = RowObject.dt-reaprova.
        WHEN "dt-rejeita":U  THEN ASSIGN pFieldValue = RowObject.dt-rejeita.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U     THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U     THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U     THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U     THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U     THEN ASSIGN pFieldValue = RowObject.dec-5.
        WHEN "valor-doc":U THEN ASSIGN pFieldValue = RowObject.valor-doc.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cod-rejeicao":U       THEN ASSIGN pFieldValue = RowObject.cod-rejeicao.
        WHEN "cod-tip-aprov":U      THEN ASSIGN pFieldValue = RowObject.cod-tip-aprov.
        WHEN "cod-tip-doc":U        THEN ASSIGN pFieldValue = RowObject.cod-tip-doc.
        WHEN "ind-situacao":U       THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        WHEN "ind-tip-aprov":U      THEN ASSIGN pFieldValue = RowObject.ind-tip-aprov.
        WHEN "int-1":U              THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U              THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U              THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U              THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U              THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "mo-codigo":U          THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "nr-trans":U           THEN ASSIGN pFieldValue = RowObject.nr-trans.
        WHEN "num-faixa":U          THEN ASSIGN pFieldValue = RowObject.num-faixa.
        WHEN "prioridade-aprov":U   THEN ASSIGN pFieldValue = RowObject.prioridade-aprov.
        WHEN "seq-aprov":U          THEN ASSIGN pFieldValue = RowObject.seq-aprov.
        WHEN "seq-log-aprov":U      THEN ASSIGN pFieldValue = RowObject.seq-log-aprov.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice transacao
  Parameters:  retorna valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnr-trans = RowObject.nr-trans.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aprov-auto":U THEN ASSIGN pFieldValue = RowObject.aprov-auto.
        WHEN "historico":U  THEN ASSIGN pFieldValue = RowObject.historico.
        WHEN "log-1":U      THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U      THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U      THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U      THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U      THEN ASSIGN pFieldValue = RowObject.log-5.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPendenciasAprov DBOProgram 
PROCEDURE getPendenciasAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt{&TABLENAME}.

    DEFINE VARIABLE de-vl-doc-conv            AS DECIMAL     NO-UNDO.
    DEFINE VARIABLE h-mlaapi019               AS HANDLE      NO-UNDO.
    DEFINE VARIABLE i-tipo-conversao          AS INTEGER     NO-UNDO.
    DEFINE VARIABLE i-moeda-conversao         AS INTEGER     NO-UNDO.
    DEFINE VARIABLE l-necessita-conversao     AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-faixa-val-doc-default   AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE l-faixas-default          AS LOGICAL     NO-UNDO.

    EMPTY TEMP-TABLE tt{&TABLENAME}.
    EMPTY TEMP-TABLE tt-mla-alternativos-def.

    IF NOT VALID-HANDLE(h-mlaapi019) THEN 
        RUN lap/mlaapi019.p PERSISTENT SET h-mlaapi019.

    RUN initializeBO IN THIS-PROCEDURE.
    
    /* Abre query das BO'S utilizadas */
    RUN openQueryStatic IN hmla-param-aprov  (INPUT "Main":U).
    RUN openQueryStatic IN hmla-usuar-aprov  (INPUT "Main":U). 
    RUN openQueryStatic IN hmla-perm-aprov   (INPUT "Main":U).
    RUN openQueryStatic IN hmla-perm-lotacao (INPUT "Main":U).

    /* Resgata parametros */
    RUN goToKey         IN hmla-param-aprov (INPUT i-ep-codigo-ini, INPUT c-cod-estabel-ini).
    RUN getLogField     IN hmla-param-aprov (INPUT "log-aprovac-altern-dat":U,     OUTPUT l-log-aprov-altern-data).
    RUN getLogField     IN hmla-param-aprov (INPUT "log-assume-permissoes-prin":U, OUTPUT l-assume-permissoes-prin).
    RUN getLogField     IN hmla-param-aprov (INPUT "log-assume-lotacoes-prin":U,   OUTPUT l-assume-lotacoes-prin).
    RUN getLogField     IN hmla-param-aprov (INPUT "log-assume-mestre-prin":U,     OUTPUT l-assume-mestre-prin).
    
    /* Cria temp-table com o usuario logado */
    RUN createTTmlaUsuarAprovPend (INPUT c-cod-usuar-trans, INPUT hmla-usuar-aprov).

    FIND FIRST tt-mla-usuar-aprov-pend
         WHERE tt-mla-usuar-aprov-pend.cod-usuar = c-cod-usuar-trans NO-LOCK NO-ERROR.

    /* Verifica‡Æo de usu rio mestre */
    IF AVAIL tt-mla-usuar-aprov-pend AND tt-mla-usuar-aprov-pend.usuar-mestre THEN
        ASSIGN l-aprovador-mestre = YES.

    RUN pi-verifica-necessidade-conversao IN h-mlaapi019 (INPUT  c-cod-usuar-trans,
                                                          OUTPUT l-necessita-conversao,
                                                          OUTPUT i-tipo-conversao,
                                                          OUTPUT i-moeda-conversao).

    RUN getAprovAlternativos IN hmla-usuar-aprov-altern (INPUT c-cod-usuar-trans, OUTPUT TABLE tt-mla-alternativos-def).

    IF de-valor-ini = 0 AND de-valor-fim = 9999999999999.99 THEN
        ASSIGN l-faixa-val-doc-default = YES.
    ELSE
        ASSIGN l-faixa-val-doc-default = NO.

    RUN pi-faixas-default IN THIS-PROCEDURE (OUTPUT l-faixas-default). 

    /* {inbo/boin767.i5}   Validacoes e criacao da temp-table com as pendencias de aprovacao  */

    IF l-faixas-default THEN DO:
        IF i-ind-situacao-ini = i-ind-situacao-fim THEN DO:

            FOR EACH {&TABLENAME} 
               WHERE {&TABLENAME}.ep-codigo          = i-ep-codigo-ini
                 AND {&TABLENAME}.cod-estabel        = c-cod-estabel-ini
                 AND {&TABLENAME}.cod-tip-doc        = i-cod-tip-doc-ini
                 AND {&TABLENAME}.ind-situacao       = i-ind-situacao-ini
                 AND {&TABLENAME}.historico          = l-historico NO-LOCK:

                {inbo/boin767.i5}
            END.
        END.
        ELSE DO:

            FOR EACH {&TABLENAME} 
               WHERE {&TABLENAME}.ep-codigo     = i-ep-codigo-ini
                 AND {&TABLENAME}.cod-estabel   = c-cod-estabel-ini
                 AND {&TABLENAME}.cod-tip-doc   = i-cod-tip-doc-ini
                 AND {&TABLENAME}.historico     = l-historico NO-LOCK:

                {inbo/boin767.i5}
            END.
        END.
    END.
    ELSE DO:

        IF i-ind-situacao-ini = i-ind-situacao-fim THEN DO:
            FOR EACH {&TABLENAME} 
               WHERE {&TABLENAME}.ep-codigo          = i-ep-codigo-ini
                 AND {&TABLENAME}.cod-estabel        = c-cod-estabel-ini
                 AND {&TABLENAME}.cod-tip-doc        = i-cod-tip-doc-ini
                 AND {&TABLENAME}.ind-situacao       = i-ind-situacao-ini
                 AND {&TABLENAME}.historico          = l-historico
                 AND {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini
                 AND {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim
                 AND {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini
                 AND {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim
                 AND {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini
                 AND {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim
                 AND {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini
                 AND {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim
                 AND {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)     
                 AND {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)     
                 AND {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)   
                 AND {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)   
                 AND {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)    
                 AND {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)    
                 AND {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini) 
                 AND {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim) NO-LOCK:
    
                {inbo/boin767.i5}
            END.
        END.
        ELSE DO:
            FOR EACH {&TABLENAME} 
               WHERE {&TABLENAME}.ep-codigo          = i-ep-codigo-ini
                 AND {&TABLENAME}.cod-estabel        = c-cod-estabel-ini
                 AND {&TABLENAME}.cod-tip-doc        = i-cod-tip-doc-ini
                 AND {&TABLENAME}.historico          = l-historico
                 AND {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini
                 AND {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim
                 AND {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini
                 AND {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim
                 AND {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini
                 AND {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim
                 AND {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini
                 AND {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim
                 AND {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)     
                 AND {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)     
                 AND {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)   
                 AND {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)   
                 AND {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)    
                 AND {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)    
                 AND {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini) 
                 AND {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim) NO-LOCK:
    
                {inbo/boin767.i5}
            END.
        END.
    END.
                                   
    RUN pi-finaliza IN h-mlaapi019.

    IF VALID-HANDLE(h-mlaapi019) THEN DO:
        DELETE PROCEDURE h-mlaapi019.
        ASSIGN h-mlaapi019 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getPendenciasAprovAprov DBOProgram 
PROCEDURE getPendenciasAprovAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER TABLE FOR tt{&TABLENAME}.

    &IF "{&FNC_MULTI_IDIOMA}":U = "Yes":U &THEN
        ASSIGN cAuxTraducao001 = {ininc/i01in767.i 3}.
        RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
        ASSIGN c-lista-situacao = cAuxTraducao001.
    &ELSE
        ASSIGN c-lista-situacao = {ininc/i01in767.i 3}.
    &ENDIF
    
    EMPTY TEMP-TABLE tt{&TABLENAME}.
 
    FOR EACH {&TABLENAME} 
       WHERE {&TABLENAME}.cod-usuar    = c-cod-usuar-aprov-ini
         AND {&TABLENAME}.cod-tip-doc  = i-cod-tip-doc-ini 
         AND {&TABLENAME}.ind-situacao = i-ind-situacao-ini 
         AND {&TABLENAME}.historico    = l-historico  NO-LOCK:

        /**  Somente Alternativo **/
        IF l-so-alternativos THEN DO:
            
            RUN openQueryStatic IN hmla-usuar-aprov-altern (INPUT "Main":U).
            RUN goToKey         IN hmla-usuar-aprov-altern (INPUT {&TABLENAME}.cod-usuar, INPUT c-cod-usuar-trans).

            RUN getAprovadorAlternativo IN hmla-usuar-aprov-altern.
            IF  RETURN-VALUE = "NOK":U THEN 
                NEXT.
            
        END.
        ELSE DO:

            RUN openQueryStatic IN hmla-usuar-aprov (INPUT "Main":U).
            RUN goToKey         IN hmla-usuar-aprov (INPUT c-cod-usuar-trans).
            RUN getUsuarioMestre IN hmla-usuar-aprov.
            IF  RETURN-VALUE = "NOK" AND
                {&TABLENAME}.cod-usuar <> c-cod-usuar-trans THEN 
                NEXT.
        END.

        /**  Sem Limite de Aprova‡Æo **/
        ASSIGN l-limite = YES.

        RUN openQueryStatic in hmla-perm-aprov (INPUT "Main":U).

        RUN goToKey IN hmla-perm-aprov (INPUT {&TABLENAME}.ep-codigo,
                                        INPUT {&TABLENAME}.cod-estabel,
                                        INPUT c-cod-usuar-trans,
                                        INPUT {&TABLENAME}.cod-tip-doc).

        RUN getPermAprovacao IN hmla-perm-aprov (INPUT {&TABLENAME}.valor-doc).

        IF  RETURN-VALUE = "NOK" THEN DO:
            ASSIGN l-limite = NO.
            RUN goToKey IN hmla-usuar-aprov (INPUT c-cod-usuar-trans).
            RUN getUsuarioMestre IN hmla-usuar-aprov.
            IF NOT l-sem-limite AND RETURN-VALUE = "NOK" THEN
                NEXT.
        END.

        /**  Sem PermissÆo na Lota‡Æo
        **/
        ASSIGN l-lotacao = YES.
        run openQueryStatic in hmla-perm-aprov (input "Main":U).
        RUN goToKey IN hmla-perm-lotacao (INPUT {&TABLENAME}.ep-codigo,
                                          INPUT c-cod-usuar-trans,
                                          INPUT {&TABLENAME}.cod-lotacao-doc).
        RUN getPermLotacao IN hmla-perm-lotacao.
        IF  RETURN-VALUE = "NOK" THEN DO:
            ASSIGN l-lotacao = NO.
            IF  NOT l-sem-lotacao THEN
                NEXT.
        END.

        /**  Cria temp-table **/
        CREATE tt{&TABLENAME}.
        BUFFER-COPY {&TABLENAME} TO tt{&TABLENAME}.
        assign tt{&tablename}.situacao  = entry({&TABLENAME}.ind-situacao, c-lista-situacao)
               tt{&TABLENAME}.rowid-doc = rowid({&TABLENAME})
               tt{&TABLENAME}.limite    = l-limite
               tt{&TABLENAME}.lotacao   = l-lotacao
               tt{&TABLENAME}.hora-aprova  = substring({&TABLENAME}.char-1,1,8)
               tt{&TABLENAME}.hora-rejeita  = substring({&TABLENAME}.char-1,9,8)
               tt{&TABLENAME}.hora-reaprova  = substring({&TABLENAME}.char-1,17,8).

        /**  Nomes dos Usu rios **/
        RUN goToKey      IN hmla-usuar-aprov (INPUT {&TABLENAME}.cod-usuar-trans).
        RUN getCharField IN hmla-usuar-aprov (INPUT  "nome-usuar",
                                              OUTPUT tt{&TABLENAME}.nome-usuar-trans).

        RUN goToKey      IN hmla-usuar-aprov (INPUT {&TABLENAME}.cod-usuar-doc).
        RUN getCharField IN hmla-usuar-aprov (INPUT  "nome-usuar",
                                              OUTPUT tt{&TABLENAME}.nome-usuar-doc).

        RUN goToKey      IN hmla-usuar-aprov (INPUT {&TABLENAME}.cod-usuar).
        RUN getCharField IN hmla-usuar-aprov (INPUT  "nome-usuar",
                                              OUTPUT tt{&TABLENAME}.nome-usuar-aprov).

        RUN goToKey      IN hmla-usuar-aprov (INPUT {&TABLENAME}.cod-usuar-altern).
        RUN getCharField IN hmla-usuar-aprov (INPUT  "nome-usuar",
                                              OUTPUT tt{&TABLENAME}.nome-usuar-alter).

        /**  EPC para tratar limite de aprova‡Æo do alternativo
        **/
        run lap/mlaapi050.p (input  rowid({&TABLENAME}),
                              input  l-limite,
                              output l-limite).
        assign tt{&TABLENAME}.limite = l-limite.
        /**  Fim EPC  **/

    END.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW        NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalPendencias DBOProgram 
PROCEDURE getTotalPendencias :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-ind-situacao      LIKE mla-doc-pend-aprov.ind-situacao NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-usuar-aprov   LIKE mla-doc-pend-aprov.cod-usuar    NO-UNDO.
    DEFINE INPUT  PARAMETER p-historico         LIKE mla-doc-pend-aprov.historico    NO-UNDO.
    DEFINE INPUT  PARAMETER p-ep-codigo         LIKE mla-doc-pend-aprov.ep-codigo    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-total-pend-princ  AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-total-pend-altern AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE l-perm AS LOGICAL INITIAL YES NO-UNDO.
    
    ASSIGN p-total-pend-princ  = 0
           p-total-pend-altern = 0 .

    FIND FIRST mla-usuar-aprov
         WHERE mla-usuar-aprov.cod-usuar = trim(p-cod-usuar-aprov) NO-LOCK NO-ERROR.

    /* usuario mestre */
    IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.usuar-mestre THEN DO:
        FOR EACH {&tablename} 
           WHERE {&tablename}.ep-codigo       = p-ep-codigo
             AND {&tablename}.ind-situacao    = p-ind-situacao     
             AND {&tablename}.historico       = p-historico        NO-LOCK:
            ASSIGN p-total-pend-princ = p-total-pend-princ + 1.            
        END.
    END.
    ELSE DO:
        /* usuario logado */
        FOR EACH {&tablename} 
           WHERE {&tablename}.ep-codigo       = p-ep-codigo
             AND {&tablename}.ind-situacao    = p-ind-situacao
             AND {&tablename}.cod-usuar       = p-cod-usuar-aprov
             AND {&tablename}.historico       = p-historico        NO-LOCK,
             FIRST mla-perm-aprov                                                 /* verifica permissao usuario-documetno */
              WHERE mla-perm-aprov.ep-codigo   = {&tablename}.ep-codigo
                AND mla-perm-aprov.cod-estabel = {&tablename}.cod-estabel 
                AND mla-perm-aprov.cod-usuar   = p-cod-usuar-aprov 
                AND mla-perm-aprov.cod-tip-doc = {&tablename}.cod-tip-doc NO-LOCK,
             FIRST mla-tipo-doc-aprov                                            /* verifica documento parametrizado-aprovacao */
              WHERE mla-tipo-doc-aprov.ep-codigo   = {&tablename}.ep-codigo
                AND mla-tipo-doc-aprov.cod-estabel = {&tablename}.cod-estabel
                AND mla-tipo-doc-aprov.cod-tip-doc = {&tablename}.cod-tip-doc 
                AND mla-tipo-doc-aprov.apr-tip-doc = yes: 

            ASSIGN p-total-pend-princ = p-total-pend-princ + 1.
        END.

        /* usuario alternativo */
        EMPTY TEMP-TABLE tt-mla-alternativos-def.
    
        FOR EACH mla-usuar-aprov-altern 
           WHERE mla-usuar-aprov-altern.cod-usuar-altern = p-cod-usuar-aprov 
             AND mla-usuar-aprov-altern.validade-ini <= TODAY
             AND mla-usuar-aprov-altern.validade-fim >= TODAY NO-LOCK:
            CREATE tt-mla-alternativos-def.
            ASSIGN tt-mla-alternativos-def.cod-usuar  = mla-usuar-aprov-altern.cod-usuar
                   tt-mla-alternativos-def.da-inicial = mla-usuar-aprov-altern.validade-ini
                   tt-mla-alternativos-def.da-final   = mla-usuar-aprov-altern.validade-fim.
        END.
    
        FOR EACH tt-mla-alternativos-def NO-LOCK,
            EACH {&tablename}
            WHERE {&tablename}.ep-codigo       = p-ep-codigo
              AND {&tablename}.cod-usuar       = tt-mla-alternativos-def.cod-usuar
              AND {&tablename}.ind-situacao    = p-ind-situacao 
              AND {&tablename}.historico       = p-historico NO-LOCK
              BREAK BY {&tablename}.cod-tip-doc:
    
            IF FIRST-OF({&tablename}.cod-tip-doc) THEN DO:
                ASSIGN l-perm = YES.
                FIND FIRST mla-perm-aprov 
                     WHERE mla-perm-aprov.ep-codigo   = {&tablename}.ep-codigo
                       AND mla-perm-aprov.cod-estabel = {&tablename}.cod-estabel 
                       AND mla-perm-aprov.cod-usuar   = p-cod-usuar-aprov 
                       AND mla-perm-aprov.cod-tip-doc = {&tablename}.cod-tip-doc NO-LOCK NO-ERROR.
                IF NOT AVAIL mla-perm-aprov THEN
                    ASSIGN l-perm = NO.
    
                FIND FIRST mla-tipo-doc-aprov
                     WHERE mla-tipo-doc-aprov.ep-codigo   = {&tablename}.ep-codigo
                     AND   mla-tipo-doc-aprov.cod-estabel = {&tablename}.cod-estabel
                     AND   mla-tipo-doc-aprov.cod-tip-doc = {&tablename}.cod-tip-doc 
                     AND   mla-tipo-doc-aprov.apr-tip-doc = YES NO-LOCK NO-ERROR.
                IF NOT AVAIL mla-tipo-doc-aprov THEN
                    ASSIGN l-perm = NO.
            END.
    
            IF l-perm = NO THEN NEXT.
    
            ASSIGN p-total-pend-altern = p-total-pend-altern + 1.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalPendenciasAprov DBOProgram 
PROCEDURE getTotalPendenciasAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-total-pend AS INTEGER NO-UNDO.
    
    ASSIGN p-total-pend = 0.

    FOR EACH {&TABLENAME}
       WHERE {&tablename}.ind-situacao      >= i-ind-situacao-ini
         AND {&tablename}.ind-situacao      <= i-ind-situacao-fim
         AND {&TABLENAME}.ep-codigo         >= i-ep-codigo-ini
         AND {&TABLENAME}.ep-codigo         <= i-ep-codigo-fim
         AND {&TABLENAME}.cod-estabel       >= c-cod-estabel-ini
         AND {&TABLENAME}.cod-estabel       <= c-cod-estabel-fim
         AND {&TABLENAME}.cod-tip-doc       >= i-cod-tip-doc-ini
         AND {&TABLENAME}.cod-tip-doc       <= i-cod-tip-doc-fim
         AND {&TABLENAME}.cod-usuar         >= c-cod-usuar-aprov-ini
         AND {&TABLENAME}.cod-usuar         <= c-cod-usuar-aprov-fim
         AND {&TABLENAME}.cod-usuar-altern  >= c-cod-usuar-altern-ini
         AND {&TABLENAME}.cod-usuar-altern  <= c-cod-usuar-altern-fim
         AND {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini
         AND {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim
         AND {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini
         AND {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim
         AND {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini
         AND {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim
         AND {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini
         AND {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim
         AND {&TABLENAME}.valor-doc         >= de-valor-ini
         AND {&TABLENAME}.valor-doc         <= de-valor-fim
         AND {&TABLENAME}.dt-geracao        >= (if {&TABLENAME}.dt-geracao  = ? then ? else da-geracao-ini)
         AND {&TABLENAME}.dt-geracao        <= (if {&TABLENAME}.dt-geracao  = ? then ? else da-geracao-fim)
         AND {&TABLENAME}.dt-aprova         >= (if {&TABLENAME}.dt-aprova   = ? then ? else da-aprovacao-ini)
         AND {&TABLENAME}.dt-aprova         <= (if {&TABLENAME}.dt-aprova   = ? then ? else da-aprovacao-fim)
         AND {&TABLENAME}.dt-rejeita        >= (if {&TABLENAME}.dt-rejeita  = ? then ? else da-rejeicao-ini)
         AND {&TABLENAME}.dt-rejeita        <= (if {&TABLENAME}.dt-rejeita  = ? then ? else da-rejeicao-fim)
         AND {&TABLENAME}.dt-reaprova       >= (if {&TABLENAME}.dt-reaprova = ? then ? else da-reaprovacao-ini)
         AND {&TABLENAME}.dt-reaprova       <= (if {&TABLENAME}.dt-reaprova = ? then ? else da-reaprovacao-fim)
         AND {&TABLENAME}.chave-doc         >= c-chave-doc-ini 
         AND {&TABLENAME}.chave-doc         <= c-chave-doc-fim
         AND {&TABLENAME}.historico          = l-historico NO-LOCK:

        /**  Somente Alternativo **/
        IF l-so-alternativos THEN DO:

            RUN goToKey                 IN hmla-usuar-aprov-altern (INPUT {&TABLENAME}.cod-usuar, INPUT c-cod-usuar-trans).
            RUN getAprovadorAlternativo IN hmla-usuar-aprov-altern.
            IF RETURN-VALUE = "NOK":U THEN
                NEXT.
        END.
        ELSE DO:

            RUN goToKey          IN hmla-usuar-aprov (INPUT c-cod-usuar-trans).
            RUN getUsuarioMestre IN hmla-usuar-aprov.

            IF RETURN-VALUE = "NOK":U AND {&TABLENAME}.cod-usuar <> c-cod-usuar-trans THEN
                NEXT.
        END.

        /**  Sem Limite de Aprova»’o **/
        ASSIGN l-limite = YES.

        RUN goToKey IN hmla-perm-aprov (INPUT {&TABLENAME}.ep-codigo,
                                        INPUT {&TABLENAME}.cod-estabel,
                                        INPUT c-cod-usuar-trans,
                                        INPUT {&TABLENAME}.cod-tip-doc).
        RUN getPermAprovacao IN hmla-perm-aprov (INPUT {&TABLENAME}.valor-doc).

        IF RETURN-VALUE = "NOK":U THEN DO:

            ASSIGN l-limite = NO.
            RUN goToKey          IN hmla-usuar-aprov (INPUT c-cod-usuar-trans).
            RUN getUsuarioMestre IN hmla-usuar-aprov.

            IF NOT l-sem-limite AND RETURN-VALUE = "NOK":U THEN
                NEXT.
        END.

        /**  Sem Permiss’o na Lota»’o **/
        ASSIGN l-lotacao = YES.
        RUN goToKey IN hmla-perm-lotacao (INPUT {&TABLENAME}.ep-codigo,
                                          INPUT c-cod-usuar-trans,
                                          INPUT {&TABLENAME}.cod-lotacao-doc).
        RUN getPermLotacao IN hmla-perm-lotacao.
        
        IF RETURN-VALUE = "NOK":U THEN DO:

            ASSIGN l-lotacao = NO.
            IF NOT l-sem-lotacao THEN
                NEXT.
        END.

        ASSIGN p-total-pend = p-total-pend + 1.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalPendenciasAprovadas DBOProgram 
PROCEDURE getTotalPendenciasAprovadas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-total-pend AS INTEGER NO-UNDO.
    
    DEFINE VARIABLE i-cont AS INTEGER NO-UNDO.

    ASSIGN p-total-pend = 0.

    IF i-ind-situacao-ini > i-ind-situacao-fim THEN
        ASSIGN i-ind-situacao-fim = i-ind-situacao-ini. /* se nao informou assumo o mesmo valor para ambos */

    DO i-cont = i-ind-situacao-ini TO i-ind-situacao-fim:
    
        for each {&TABLENAME} where 
                 {&tablename}.ind-situacao   = i-cont and 
                 {&TABLENAME}.cod-tip-doc    = i-cod-tip-doc-ini AND
                 {&TABLENAME}.cod-usuar      = c-cod-usuar-aprov-ini AND
                 {&TABLENAME}.historico      = l-historico NO-LOCK:
    
            /**  Somente Alternativo
            **/
            IF  l-so-alternativos THEN DO:
                run openQueryStatic in hmla-usuar-aprov-altern (input "Main":U).
                RUN goToKey IN hmla-usuar-aprov-altern (INPUT {&TABLENAME}.cod-usuar,
                                                        INPUT c-cod-usuar-trans).
                RUN getAprovadorAlternativo IN hmla-usuar-aprov-altern.
                IF  RETURN-VALUE = "NOK" THEN
                    NEXT.
            END.
            ELSE DO:
                run openQueryStatic in hmla-usuar-aprov (input "Main":U).
                RUN goToKey IN hmla-usuar-aprov (INPUT c-cod-usuar-trans).
                RUN getUsuarioMestre IN hmla-usuar-aprov.
                IF  RETURN-VALUE = "NOK" AND
                    {&TABLENAME}.cod-usuar <> c-cod-usuar-trans THEN
                    NEXT.
            END.
      
            ASSIGN p-total-pend = p-total-pend + 1.
    
        END.
    END.
        
    RETURN "OK":U.
END PROCEDURE.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE linkToSaldo-Terc DBOProgram 
PROCEDURE linkToTT-Mla-usuar-aprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pHandle AS HANDLE NO-UNDO.
    
    RUN getKey IN pHandle (OUTPUT c-cod-usuar).
                       
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTotalPendenciasAprovAprov DBOProgram 
PROCEDURE getTotalPendenciasAprovAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-tip-doc     LIKE mla-doc-pend-aprov.cod-tip-doc NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-usuar-aprov LIKE mla-doc-pend-aprov.cod-usuar   NO-UNDO.               
    DEFINE INPUT  PARAMETER p-ep-codigo       LIKE mla-doc-pend-aprov.ep-codigo   NO-UNDO.
    DEFINE INPUT  PARAMETER p-cod-estabel     LIKE mla-doc-pend-aprov.cod-estabel NO-UNDO.
    DEFINE INPUT  PARAMETER p-so-alternativos AS LOGICAL NO-UNDO.
    DEFINE INPUT  PARAMETER p-so-pendentes    AS LOGICAL NO-UNDO.
    DEFINE OUTPUT PARAMETER p-total-pend      AS INTEGER NO-UNDO.
    
    ASSIGN p-total-pend = 0.

    IF p-so-pendentes THEN DO:
        /*caixa alternativo*/
        IF p-so-alternativos THEN DO:
            FOR EACH mla-usuar-aprov-altern NO-LOCK
                 WHERE mla-usuar-aprov-altern.cod-usuar-altern = p-cod-usuar-aprov
                   AND mla-usuar-aprov-altern.validade-ini    <= TODAY
                   AND mla-usuar-aprov-altern.validade-fim    >= TODAY:

                FOR EACH {&TABLENAME}
                   WHERE {&TABLENAME}.ep-codigo    = p-ep-codigo                       
                     AND {&TABLENAME}.cod-estabel  = p-cod-estabel                     
                     AND {&TABLENAME}.cod-usuar    = mla-usuar-aprov-altern.cod-usuar  
                     AND {&tablename}.ind-situacao = 1                                 
                     AND {&TABLENAME}.cod-tip-doc  = p-cod-tip-doc                     
                     AND {&TABLENAME}.historico    = NO  NO-LOCK:

                    ASSIGN p-total-pend = p-total-pend + 1.
               END.
            END.
        END.
        /*caixa entrada*/
        ELSE DO:
            /*Usuario mestre*/
            FIND FIRST mla-usuar-aprov NO-LOCK
                 WHERE mla-usuar-aprov.cod-usuar = p-cod-usuar-aprov NO-ERROR.
            IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.usuar-mestre THEN DO:
                for each {&TABLENAME} where 
                         {&TABLENAME}.ep-codigo    = p-ep-codigo    and 
                         {&TABLENAME}.cod-estabel  = p-cod-estabel  and
                         {&TABLENAME}.cod-tip-doc  = p-cod-tip-doc  AND
                         {&TABLENAME}.historico    = NO             AND
                         {&tablename}.ind-situacao = 1              NO-LOCK:
                     ASSIGN p-total-pend = p-total-pend + 1.
                END.
            END.
            /*Usu rio nÆo ‚ mestre*/
            ELSE DO:
                for each {&TABLENAME} where 
                         {&TABLENAME}.ep-codigo    = p-ep-codigo        and 
                         {&TABLENAME}.cod-estabel  = p-cod-estabel      and
                         {&TABLENAME}.cod-usuar    = p-cod-usuar-aprov  AND
                         {&tablename}.ind-situacao = 1                  AND
                         {&TABLENAME}.cod-tip-doc  = p-cod-tip-doc      AND
                         {&TABLENAME}.historico    = NO             NO-LOCK:
                    ASSIGN p-total-pend = p-total-pend + 1.
                END.
            END.
        END.
    END.
    /*caixa de saida*/
    ELSE DO:
        for each {&TABLENAME} where 
                 {&TABLENAME}.ep-codigo    = p-ep-codigo        and 
                 {&TABLENAME}.cod-estabel  = p-cod-estabel      and
                 {&TABLENAME}.cod-usuar    = p-cod-usuar-aprov  AND
                 {&tablename}.ind-situacao > 1                  AND
                 {&TABLENAME}.cod-tip-doc  = p-cod-tip-doc      AND
                 {&TABLENAME}.historico    = NO             NO-LOCK:
            ASSIGN p-total-pend = p-total-pend + 1.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice transacao
  Parameters:  recebe valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    FIND FIRST bfmla-doc-pend-aprov 
         WHERE bfmla-doc-pend-aprov.nr-trans = pnr-trans NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfmla-doc-pend-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfmla-doc-pend-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeBO DBOProgram 
PROCEDURE initializeBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT VALID-HANDLE(hmla-usuar-aprov) THEN
        RUN inbo/boin785.p PERSISTENT SET hmla-usuar-aprov.
    IF NOT VALID-HANDLE(hmla-perm-aprov) THEN
        RUN inbo/boin774.p PERSISTENT SET hmla-perm-aprov.
    IF NOT VALID-HANDLE(hmla-perm-lotacao) THEN
        RUN inbo/boin775.p PERSISTENT SET hmla-perm-lotacao.
    IF NOT VALID-HANDLE(hmla-usuar-aprov-altern) THEN
        RUN inbo/boin786.p PERSISTENT SET hmla-usuar-aprov-altern.
    IF NOT VALID-HANDLE(hmla-param-aprov) THEN
        RUN inbo/boin773.p PERSISTENT SET hmla-param-aprov.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-ordem AS CHARACTER NO-UNDO.

    CASE p-ordem:
        WHEN "dataGeracao":U THEN RUN openQueryStatic (INPUT "dataGeracao":U).
        WHEN "transacao":U   THEN RUN openQueryStatic (INPUT "transacao":U).
        WHEN "documento":U   THEN RUN openQueryStatic (INPUT "documento":U).
        WHEN "selecao":U     THEN RUN openQueryStatic (INPUT "selecao":U).
        WHEN "situacao":U    THEN RUN openQueryStatic (INPUT "situacao":U).
        OTHERWISE                 RUN openQueryStatic (INPUT "Main":U). 
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDataGeracao DBOProgram 
PROCEDURE openQueryDataGeracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} NO-LOCK
                 BY {&TABLENAME}.dt-geracao
                 INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryDocumento DBOProgram 
PROCEDURE openQueryDocumento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} NO-LOCK
                 BY {&TABLENAME}.ep-codigo
                 BY {&TABLENAME}.cod-estabel
                 BY {&TABLENAME}.cod-tip-doc
                 BY {&TABLENAME}.chave-doc   
                 INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySelecao DBOProgram 
PROCEDURE openQuerySelecao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} 
        WHERE    {&tablename}.ind-situacao      >= i-ind-situacao-ini 
        AND      {&tablename}.ind-situacao      <= i-ind-situacao-fim 
        AND      {&TABLENAME}.ep-codigo         >= i-ep-codigo-ini 
        AND      {&TABLENAME}.ep-codigo         <= i-ep-codigo-fim 
        AND      {&TABLENAME}.cod-estabel       >= c-cod-estabel-ini 
        AND      {&TABLENAME}.cod-estabel       <= c-cod-estabel-fim 
        AND      {&TABLENAME}.cod-tip-doc       >= i-cod-tip-doc-ini 
        AND      {&TABLENAME}.cod-tip-doc       <= i-cod-tip-doc-fim 
        AND      {&TABLENAME}.cod-usuar-doc     >= c-cod-usuar-doc-ini 
        AND      {&TABLENAME}.cod-usuar-doc     <= c-cod-usuar-doc-fim 
        AND      {&TABLENAME}.cod-usuar-trans   >= c-cod-usuar-trans-ini 
        AND      {&TABLENAME}.cod-usuar-trans   <= c-cod-usuar-trans-fim 
        AND      {&TABLENAME}.cod-lotacao-doc   >= c-cod-lotacao-doc-ini 
        AND      {&TABLENAME}.cod-lotacao-doc   <= c-cod-lotacao-doc-fim 
        AND      {&TABLENAME}.cod-lotacao-trans >= c-cod-lotacao-trans-ini 
        AND      {&TABLENAME}.cod-lotacao-trans <= c-cod-lotacao-trans-fim 
        AND      {&TABLENAME}.valor-doc         >= de-valor-ini 
        AND      {&TABLENAME}.valor-doc         <= de-valor-fim 
        AND      {&TABLENAME}.dt-geracao        >= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-ini)      
        AND      {&TABLENAME}.dt-geracao        <= (IF {&TABLENAME}.dt-geracao  = ? THEN ? ELSE da-geracao-fim)      
        AND      {&TABLENAME}.dt-aprova         >= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-ini)    
        AND      {&TABLENAME}.dt-aprova         <= (IF {&TABLENAME}.dt-aprova   = ? THEN ? ELSE da-aprovacao-fim)    
        AND      {&TABLENAME}.dt-rejeita        >= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-ini)     
        AND      {&TABLENAME}.dt-rejeita        <= (IF {&TABLENAME}.dt-rejeita  = ? THEN ? ELSE da-rejeicao-fim)     
        AND      {&TABLENAME}.dt-reaprova       >= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-ini)  
        AND      {&TABLENAME}.dt-reaprova       <= (IF {&TABLENAME}.dt-reaprova = ? THEN ? ELSE da-reaprovacao-fim)  
        AND      {&TABLENAME}.chave-doc         >= c-chave-doc-ini 
        AND      {&TABLENAME}.chave-doc         <= c-chave-doc-fim 
        AND      {&TABLENAME}.historico          = l-historico NO-LOCK
        BY       {&TABLENAME}.nr-trans  INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryTransacao DBOProgram 
PROCEDURE openQueryTransacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    OPEN QUERY {&QUERYNAME} 
        FOR EACH {&TABLENAME} NO-LOCK
                 BY {&TABLENAME}.nr-trans
                 INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-faixas-default DBOProgram 
PROCEDURE pi-faixas-default :
/*------------------------------------------------------------------------------
  Purpose:  Verifica se foi informado alguma faixa para busca das pendencias
  Parameters: pl-faixas-detault - indica se houve alteracao nas faixas ou nao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pl-faixas-detault AS LOGICAL NO-UNDO.
        
    IF  c-cod-usuar-doc-ini     = ""         AND c-cod-usuar-doc-fim     = "ZZZZZZZZZZZZ":U 
    AND c-cod-usuar-trans-ini   = ""         AND c-cod-usuar-trans-fim   = "ZZZZZZZZZZZZ":U 
    AND c-cod-lotacao-doc-ini   = ""         AND c-cod-lotacao-doc-fim   = "ZZZZZZZZZZZZZZZZZZZZ":U 
    AND c-cod-lotacao-trans-ini = ""         AND c-cod-lotacao-trans-fim = "ZZZZZZZZZZZZZZZZZZZZ":U 
    AND da-geracao-ini          = 01/01/1900 AND da-geracao-fim          = 12/31/2999 
    AND da-aprovacao-ini        = 01/01/1900 AND da-aprovacao-fim        = 12/31/2999 
    AND da-rejeicao-ini         = 01/01/1900 AND da-rejeicao-fim         = 12/31/2999 
    AND da-reaprovacao-ini      = 01/01/1900 AND da-reaprovacao-fim      = 12/31/2999 THEN
        ASSIGN pl-faixas-detault = YES.
    ELSE
        ASSIGN pl-faixas-detault = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSubstituiAprovador DBOProgram 
PROCEDURE piSubstituiAprovador :
/*------------------------------------------------------------------------------
  Purpose:  Transferir as pendˆncias de aprova‡Æo e pendˆncias de contrato que ainda estÆo pendentes de libera‡Æo .
  Parameters: /* Input */
              pcEmpresaIni: Empresa inicial
              pcEmpresaFim: Empresa final
              pcEstabIni  : Estabelecimento inicial
              pcEstabFim  : Estabelecimento final
              pcOrigem    : Usu rio origem
              pcDestino   : Usu rio destino
              plSimulaAlteracao : Indica se ‚ apenas simula‡Æo.(Cria as temp-tables por‚m nÆo efetiva as altera‡äes)
              /* Output */
              tt-mla-doc-pend-aprov: Temp-table contendo os dados(pendˆncias de aprova‡Æo) dos registros afetados pela leitura.
              tt-mla-doc-sit       : Temp-table contendo os dados(pendˆncias de contrato nÆo liberadas) dos registros afetados pela leitura.   
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pcEmpresaIni   LIKE empresa.ep-codigo NO-UNDO.            
    DEFINE INPUT PARAM pcEmpresaFim   LIKE empresa.ep-codigo NO-UNDO.            
    DEFINE INPUT PARAM pcEstabIni     LIKE estabelec.cod-estabel NO-UNDO.        
    DEFINE INPUT PARAM pcEstabFim     LIKE estabelec.cod-estabel NO-UNDO. 
    DEFINE INPUT PARAM pcOrigem       LIKE mla-usuar-aprov.cod-usuar NO-UNDO.  
    DEFINE INPUT PARAM pcDestino      LIKE mla-usuar-aprov.cod-usuar NO-UNDO.      
    DEFINE INPUT PARAM plSimulaAlteracao AS LOGICAL NO-UNDO.                     
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-doc-pend-aprov.                         
    DEFINE OUTPUT PARAM TABLE FOR tt-mla-doc-sit. 

    EMPTY TEMP-TABLE tt-mla-doc-pend-aprov.
    EMPTY TEMP-TABLE tt-mla-doc-sit.

    DEFINE VARIABLE c-chave-doc AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE cErrorDescription       LIKE RowErrors.ErrorDescription NO-UNDO.
    DEFINE VARIABLE cErrorHelp              LIKE RowErrors.ErrorHelp        NO-UNDO.    

    FOR EACH mla-doc-pend-aprov NO-LOCK
       WHERE mla-doc-pend-aprov.ep-codigo   >= pcEmpresaIni
         AND mla-doc-pend-aprov.ep-codigo   <= pcEmpresaFim
         AND mla-doc-pend-aprov.cod-estabel >= pcEstabIni
         AND mla-doc-pend-aprov.cod-estabel <= pcEstabFim
         AND mla-doc-pend-aprov.cod-usuar    = pcOrigem
         AND mla-doc-pend-aprov.ind-situacao = 1
    GROUP BY mla-doc-pend-aprov.ep-codigo  
          BY mla-doc-pend-aprov.cod-estabel
          BY mla-doc-pend-aprov.cod-tip-doc:

        ASSIGN c-chave-doc = "".
    
        FOR EACH mla-chave-doc-aprov 
           WHERE mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK:
            ASSIGN c-chave-doc = c-chave-doc + 
                SUBSTRING(mla-doc-pend-aprov.chave-doc,mla-chave-doc-aprov.posicao-ini,
                        ((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1)) + " | ".
        END.
    
        ASSIGN c-chave-doc = SUBSTRING(c-chave-doc,1,(LENGTH(c-chave-doc) - 3)).

        CREATE tt-mla-doc-pend-aprov.
        BUFFER-COPY mla-doc-pend-aprov TO tt-mla-doc-pend-aprov.
        ASSIGN tt-mla-doc-pend-aprov.r-rowid       = ROWID(mla-doc-pend-aprov)
               tt-mla-doc-pend-aprov.chave-doc     = c-chave-doc
               tt-mla-doc-pend-aprov.usuar-destino = pcDestino.

        IF CAN-FIND(FIRST mla-perm-aprov
                    WHERE mla-perm-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo
                      AND mla-perm-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
                      AND mla-perm-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                      AND mla-perm-aprov.cod-usuar   = pcDestino) THEN DO:
            {utp/ut-liter.i "Transferido" * R}
            ASSIGN tt-mla-doc-pend-aprov.situacao = TRIM(RETURN-VALUE)
                   tt-mla-doc-pend-aprov.id-sit   = 6.
        END.
        ELSE DO:
            {utp/ut-liter.i "Mantido" * R}
            ASSIGN tt-mla-doc-pend-aprov.situacao = TRIM(RETURN-VALUE)
                   tt-mla-doc-pend-aprov.id-sit   = 1.
            {utp/ut-liter.i "Usu rio_destino_nÆo_possui_permissÆo_no_documento" * R}
            ASSIGN tt-mla-doc-pend-aprov.observacao = TRIM(RETURN-VALUE).
        END.

        /**** Veirifcar Integra‡Æo com Fluig ******/
        IF NOT CAN-FIND(FIRST tt-doc-integrated-fluig
                        	WHERE tt-doc-integrated-fluig.ep-codigo   = mla-doc-pend-aprov.ep-codigo
                        	AND   tt-doc-integrated-fluig.cod-estabel = mla-doc-pend-aprov.cod-estabel
                        	AND   tt-doc-integrated-fluig.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc) THEN DO:
        	FOR FIRST mla-tipo-doc-aprov FIELDS(log-integr-fluig)
        		WHERE mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo
        		AND   mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
        		AND   mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK:
        		FOR FIRST mla-param-aprov FIELDS(log-integr-fluig)
        			WHERE mla-param-aprov.ep-codigo = mla-tipo-doc-aprov.ep-codigo
        			AND   mla-param-aprov.cod-estabel = mla-tipo-doc-aprov.cod-estabel NO-LOCK:
        			CREATE tt-doc-integrated-fluig.
        			ASSIGN tt-doc-integrated-fluig.ep-codigo        = mla-tipo-doc-aprov.ep-codigo
        				   tt-doc-integrated-fluig.cod-estabel      = mla-tipo-doc-aprov.cod-estabel
        				   tt-doc-integrated-fluig.cod-tip-doc      = mla-tipo-doc-aprov.cod-tip-doc
        				   tt-doc-integrated-fluig.log-integr-fluig = (mla-tipo-doc-aprov.log-integr-fluig AND mla-param-aprov.log-integr-fluig).
        		END.
        	END.
        END.
    END.

    FOR EACH mla-doc-sit NO-LOCK
       WHERE mla-doc-sit.ep-codigo    >= pcEmpresaIni
         AND mla-doc-sit.ep-codigo    <= pcEmpresaFim
         AND mla-doc-sit.cod-estabel  >= pcEstabIni  
         AND mla-doc-sit.cod-estabel  <= pcEstabFim  
         AND mla-doc-sit.cod-tip-doc   = 13
         AND mla-doc-sit.ind-situacao  = 1
         AND mla-doc-sit.cod-usuar     = pcOrigem:

        ASSIGN c-chave-doc = "".
    
        FOR EACH mla-chave-doc-aprov 
           WHERE mla-chave-doc-aprov.cod-tip-doc = mla-doc-sit.cod-tip-doc NO-LOCK:
            ASSIGN c-chave-doc = c-chave-doc + 
                SUBSTRING(mla-doc-sit.chave-doc,mla-chave-doc-aprov.posicao-ini,
                        ((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1)).
        END.

        CREATE tt-mla-doc-sit.
        BUFFER-COPY mla-doc-sit TO tt-mla-doc-sit.
        ASSIGN tt-mla-doc-sit.r-rowid       = ROWID(mla-doc-sit)
               tt-mla-doc-sit.chave-doc     = c-chave-doc
               tt-mla-doc-sit.usuar-destino = pcDestino.

        IF CAN-FIND(FIRST mla-perm-aprov
                    WHERE mla-perm-aprov.ep-codigo   = mla-doc-sit.ep-codigo
                      AND mla-perm-aprov.cod-estabel = mla-doc-sit.cod-estabel
                      AND mla-perm-aprov.cod-tip-doc = mla-doc-sit.cod-tip-doc
                      AND mla-perm-aprov.cod-usuar   = pcDestino) THEN DO:
            {utp/ut-liter.i "Transferido" * R}
            ASSIGN tt-mla-doc-sit.situacao = TRIM(RETURN-VALUE)
                   tt-mla-doc-sit.id-sit   = 6.
        END.
        ELSE DO:
            {utp/ut-liter.i "Mantido" * R}
            ASSIGN tt-mla-doc-sit.situacao = TRIM(RETURN-VALUE)
                   tt-mla-doc-pend-aprov.id-sit   = 1.
            {utp/ut-liter.i "Usu rio_destino_nÆo_possui_permissÆo_no_documento" * R}
            ASSIGN tt-mla-doc-sit.observacao = TRIM(RETURN-VALUE).
        END.
    END.

    /* Substitui‡Æo das pendˆncis */
    IF NOT plSimulaAlteracao THEN DO:
        DEFINE VARIABLE h-boin768 AS HANDLE      NO-UNDO.
        IF NOT VALID-HANDLE(h-boin768) THEN
            RUN inbo/boin768.p PERSISTENT SET h-boin768.
        IF NOT VALID-HANDLE(h-mlaapi014) THEN
            RUN lap/mlaapi014.p PERSISTEN SET h-mlaapi014.
        /* Inicia o handle da api de integra‡Æo com Fluig apenas uma vez, melhorando a performance da integra‡Æo. */
        RUN setHandleFluig IN h-mlaapi014.

        FOR EACH tt-mla-doc-pend-aprov
           WHERE tt-mla-doc-pend-aprov.id-sit = 6: /* Transferido */

            RUN emptyRowObject IN THIS-PROCEDURE.
            RUN emptyRowErrors IN THIS-PROCEDURE.
            RUN openQueryStatic IN THIS-PROCEDURE (INPUT "main":U).
            RUN repositionRecord IN THIS-PROCEDURE (INPUT tt-mla-doc-pend-aprov.r-rowid).
            IF RETURN-VALUE = "NOK":U THEN NEXT.
            RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE rowObject).
            FIND FIRST rowObject NO-ERROR.
            IF NOT AVAIL rowObject THEN NEXT.
            ASSIGN rowObject.cod-usuar = tt-mla-doc-pend-aprov.usuar-destino.
            RUN setRecord IN THIS-PROCEDURE(INPUT TABLE rowObject).
            RUN updateRecord IN THIS-PROCEDURE.

            /* Transferir pendˆncia do Fluig */
            FIND FIRST tt-doc-integrated-fluig NO-LOCK
            	WHERE tt-doc-integrated-fluig.ep-codigo   = tt-mla-doc-pend-aprov.ep-codigo
            	AND   tt-doc-integrated-fluig.cod-estabel = tt-mla-doc-pend-aprov.cod-estabel
            	AND   tt-doc-integrated-fluig.cod-tip-doc = tt-mla-doc-pend-aprov.cod-tip-doc NO-ERROR.
            IF tt-mla-doc-pend-aprov.cdn-workflow-fluig > 0 AND AVAIL tt-doc-integrated-fluig AND tt-doc-integrated-fluig.log-integr-fluig THEN DO:
                RUN trocaAprovador IN h-mlaapi014(INPUT tt-mla-doc-pend-aprov.nr-trans,
                                                  INPUT pcOrigem, /* USUARIO ORIGINAL */
                                                  OUTPUT TABLE RowErrorsAux). 

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN utp/ut-msgs.p(INPUT "msg", INPUT 54790, INPUT "").
                    ASSIGN cErrorDescription = return-value.
                    RUN utp/ut-msgs.p(INPUT "help", INPUT 54790, INPUT "").
                    ASSIGN cErrorHelp = return-value.
            
                    IF NOT CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber = 54790) THEN DO:
                        {method/svc/errors/inserr.i &ErrorNumber="54790"
                                                    &ErrorType="EMS":U
                                                    &ErrorSubType="WARNING":U
                                                    &ErrorParameters="''"}
                        ASSIGN RowErrors.ErrorDescription = cErrorDescription
                               RowErrors.ErrorHelp        = cErrorHelp.
                    END.
                END.
            END.
            /* Fim - Transferir pendˆncia do Fluig */
        END.
    
        FOR EACH tt-mla-doc-sit
           WHERE tt-mla-doc-sit.id-sit  = 6: /* Transferido */

            RUN emptyRowObject IN h-boin768.
            RUN emptyRowErrors IN h-boin768.
            RUN openQueryStatic IN h-boin768 (INPUT "main":U).
            RUN repositionRecord IN h-boin768 (INPUT tt-mla-doc-sit.r-rowid).
            IF RETURN-VALUE = "NOK":U THEN NEXT.
            RUN getRecord IN h-boin768 (OUTPUT TABLE tt-mla-doc-sit-aux).
            FIND FIRST tt-mla-doc-sit-aux NO-ERROR.
            IF NOT AVAIL tt-mla-doc-sit-aux THEN NEXT.
            ASSIGN tt-mla-doc-sit-aux.cod-usuar = pcDestino.
            RUN setRecord IN h-boin768(INPUT TABLE tt-mla-doc-sit-aux).
            RUN updateRecord IN h-boin768.
        END.
    END.

    /* Elimina o handle da api de integra‡Æo com Fluig apenas uma vez, melhorando a performance da integra‡Æo. */
    RUN unsetHandleFluig IN h-mlaapi014.

    IF VALID-HANDLE(h-boin768) THEN DO:
        DELETE PROCEDURE h-boin768.
        ASSIGN h-boin768 = ?.
    END.
    
    IF VALID-HANDLE(h-mlaapi014) THEN DO:
        DELETE PROCEDURE h-mlaapi014.
        ASSIGN h-mlaapi014 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaNomeUsuarios DBOProgram 
PROCEDURE retornaNomeUsuarios :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*      DEFINE INPUT PARAMETER TABLE FOR tt-mla-alternativos-def. */

    DEFINE INPUT PARAMETER usuariosList  AS CHAR no-undo.
        DEFINE OUTPUT PARAMETER nomeUsuariosList AS CHAR no-undo.
        
        /*empty temp-table tt-data-user.        */
        
        DEFINE VARIABLE qtd-entries AS INTEGER NO-UNDO.
        DEFINE VARIABLE cont AS INTEGER INITIAL 0 NO-UNDO.
        DEFINE VARIABLE codUsuario AS CHARACTER NO-UNDO.

        assign qtd-entries = num-entries(usuariosList, ',').
        
        assign nomeUsuariosList = "".
        DO cont = 1 TO qtd-entries:     
            ASSIGN codUsuario = entry(cont, usuariosList, ',').
                
                find first mla-usuar-aprov
                        where mla-usuar-aprov.cod-usuar = codUsuario no-lock no-error.
                if avail mla-usuar-aprov then do:
        
                        ASSIGN nomeUsuariosList = nomeUsuariosList + mla-usuar-aprov.nome-usuar + ",".

                end.            

        end.
    
end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint DBOProgram 
PROCEDURE setConstraint :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER TABLE FOR tt-parametros.


    FIND FIRST tt-parametros
        NO-ERROR.
    IF  NOT AVAILABLE tt-parametros THEN
        RETURN "NOK":U.

    RUN initializeBO IN THIS-PROCEDURE.
   
    ASSIGN i-ind-situacao-ini      = tt-parametros.ind-situacao-ini            
           i-ind-situacao-fim      = tt-parametros.ind-situacao-fim
           i-ep-codigo-ini         = tt-parametros.ep-codigo-ini         
           i-ep-codigo-fim         = tt-parametros.ep-codigo-fim         
           c-cod-estabel-ini       = tt-parametros.cod-estabel-ini     
           c-cod-estabel-fim       = tt-parametros.cod-estabel-fim     
           i-cod-tip-doc-ini       = tt-parametros.cod-tip-doc-ini
           i-cod-tip-doc-fim       = tt-parametros.cod-tip-doc-fim
           l-historico             = tt-parametros.historico
           l-so-alternativos       = tt-parametros.so-alternativos     
           l-sem-limite            = tt-parametros.sem-limite          
           l-sem-lotacao           = tt-parametros.sem-lotacao         
           c-cod-usuar-aprov-ini   = tt-parametros.cod-usuar-aprov-ini 
           c-cod-usuar-aprov-fim   = tt-parametros.cod-usuar-aprov-fim 
           c-cod-usuar-altern-ini  = tt-parametros.cod-usuar-altern-ini
           c-cod-usuar-altern-fim  = tt-parametros.cod-usuar-altern-fim
           c-cod-usuar-doc-ini     = tt-parametros.cod-usuar-doc-ini   
           c-cod-usuar-doc-fim     = tt-parametros.cod-usuar-doc-fim   
           c-cod-usuar-trans-ini   = tt-parametros.cod-usuar-trans-ini 
           c-cod-usuar-trans-fim   = tt-parametros.cod-usuar-trans-fim 
           c-cod-lotacao-doc-ini   = tt-parametros.cod-lotacao-doc-ini 
           c-cod-lotacao-doc-fim   = tt-parametros.cod-lotacao-doc-fim 
           c-cod-lotacao-trans-ini = tt-parametros.cod-lotacao-trans-ini 
           c-cod-lotacao-trans-fim = tt-parametros.cod-lotacao-trans-fim 
           de-valor-ini            = tt-parametros.valor-ini          
           de-valor-fim            = tt-parametros.valor-fim          
           da-geracao-ini          = tt-parametros.geracao-ini        
           da-geracao-fim          = tt-parametros.geracao-fim        
           da-aprovacao-ini        = tt-parametros.aprovacao-ini      
           da-aprovacao-fim        = tt-parametros.aprovacao-fim      
           da-rejeicao-ini         = tt-parametros.rejeicao-ini       
           da-rejeicao-fim         = tt-parametros.rejeicao-fim       
           da-reaprovacao-ini      = tt-parametros.reaprovacao-ini    
           da-reaprovacao-fim      = tt-parametros.reaprovacao-fim    
           c-chave-doc-ini         = tt-parametros.chave-doc-ini       
           c-chave-doc-fim         = tt-parametros.chave-doc-fim.       

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUsuarioTransacao DBOProgram 
PROCEDURE setUsuarioTransacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cod-usuar-trans AS CHAR NO-UNDO.

    ASSIGN c-cod-usuar-trans = p-cod-usuar-trans.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*:T--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as valida‡äes ---*/
    
    /*:T--- Verifica ocorrˆncia de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE  getApprovers  DBOProgram 
PROCEDURE getApprovers:
    DEFINE INPUT PARAM pcCompany     AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM pcSite        AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAM piDocTypeCode AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAM pcDocKey      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM TABLE FOR ttApprovalUser. 
    
    FOR EACH mla-doc-pend-aprov FIELDS(cod-usuar) NO-LOCK
       WHERE mla-doc-pend-aprov.ep-codigo    = pcCompany 
         AND mla-doc-pend-aprov.cod-estabel  = pcSite 
         AND mla-doc-pend-aprov.cod-tip-doc  = piDocTypeCode
         AND mla-doc-pend-aprov.chave-doc    = pcDocKey
         AND mla-doc-pend-aprov.ind-situacao = 1:

        IF NOT CAN-FIND(FIRST ttApprovalUser 
                        WHERE ttApprovalUser.cod-usuar = mla-doc-pend-aprov.cod-usuar) THEN DO:
            FOR FIRST mla-usuar-aprov FIELDS(cod-usuar nome-usuar e-mail) 
                WHERE mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar NO-LOCK:
        
                CREATE ttApprovalUser.
                BUFFER-COPY mla-usuar-aprov TO ttApprovalUser NO-ERROR. 
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

