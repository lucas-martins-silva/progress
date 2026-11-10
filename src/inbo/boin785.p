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
{include/i-prgvrs.i BOIN785 2.00.00.029 } /*** "010029" 24/11/2023 13:25:29  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin785 MUT}
&ENDIF

/*:T--------------------------------------------------------------------------
    File       : BOIN785.P
    Purpose    : L¢gica de neg¢cio e acesso a dados para a tabela mla-usuar-aprov
    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boin785
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-usuar-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE XMLReceiver YES    /*:T DBO atua como receiver de mensagens enviado pelo Message Broker (mÇtodo Receive Message) */
&GLOBAL-DEFINE XMLProducer YES    /*:T DBO atua como producer de mensagens para o Message Broker */
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES


/*:T--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin785.i RowObject}
{inbo/boin785.i tt-mla-usuar-aprov-antes}


/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/* DefiniÁ„o das vari·veis necess·rias ao setConstraint */
def var c-cod-usuar-ini as char no-undo.
def var c-cod-usuar-fim as char no-undo.
def var c-nome-usuar-ini as char no-undo.
def var c-nome-usuar-fim as char no-undo.

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf-{&TableName} FOR {&TableName}.

DEFINE VARIABLE c-empresa               LIKE empresa.ep-codigo         NO-UNDO.
DEFINE VARIABLE c-log-reg               AS CHARACTER FORMAT "X(2000)"  NO-UNDO.
DEFINE VARIABLE r-rowid                 AS ROWID                       NO-UNDO.
DEFINE VARIABLE c-desc-ordenacao        AS CHARACTER FORMAT "X(20)"    NO-UNDO.

DEFINE VARIABLE c-lbl-cod-usuar                    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-nome-usuar                   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-cod-lotacao                  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-cod-estabel                  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-mo-codigo                    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-perm-aprov                   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-aprova-auto                  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-aprova-auto-aprov            AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-destino-lotacao              AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-libera-verba                 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-log-html                     AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-log-4                        AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-usuar-mestre                 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-envia-email                  AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-recebe-email                 AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-e-mail                       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-ordenacao                    AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-todas-empresas               AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-visualizacao-padrao          AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-aprov-indvd-sem-sel          AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-visualiza-detalhe-listagem   AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-visualiza-contador-pendencia AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-converte-para-moeda          AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-tipo-conversao-moeda         AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-data-aprovacao               AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-data-geracao-pendencia       AS CHARACTER          NO-UNDO.
DEFINE VARIABLE c-lbl-log-usuar-config             AS CHARACTER          NO-UNDO.

DEFINE VARIABLE h-boin769               AS HANDLE                      NO-UNDO.

{cdp/cd0666.i} /* Temp-table tt-erro */

DEFINE VARIABLE c-sim   AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nao   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-traduziu AS LOGICAL     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-ordenacao DBOProgram 
FUNCTION fn-desc-ordenacao RETURNS CHARACTER
  ( i-ordenacao AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-desc-visualizacao-padrao DBOProgram 
FUNCTION fn-desc-visualizacao-padrao RETURNS CHARACTER
  ( i-visualizacao AS INTEGER )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-traduz-char-log DBOProgram 
FUNCTION fn-traduz-char-log RETURNS CHARACTER
  ( p-value AS CHAR )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-traduz-log DBOProgram 
FUNCTION fn-traduz-log RETURNS CHARACTER
  ( l-value AS LOGICAL )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 15.33
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */
{utp/ut-liter.i "Sim" * r}
ASSIGN c-sim = RETURN-VALUE.
{utp/ut-liter.i "N∆o" * r}
ASSIGN c-nao = RETURN-VALUE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN pi-traduz-labels IN THIS-PROCEDURE.

    ASSIGN c-log-reg = entry(23,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                       c-lbl-cod-usuar            + ": " + string(RowObject.cod-usuar)                                + chr(13) + 
                       c-lbl-nome-usuar           + ": " + string(RowObject.nome-usuar)                               + chr(13) + 
                       c-lbl-cod-lotacao          + ": " + string(RowObject.cod-lotacao)                              + chr(13) +                                      
                       c-lbl-cod-estabel          + ": " + string(RowObject.cod-estabel)                              + chr(13) +                                      
                       c-lbl-mo-codigo            + ": " + string(RowObject.mo-codigo)                                + chr(13) +   
                       c-lbl-converte-para-moeda  + ": " + fn-traduz-char-log(SUBSTRING(RowObject.char-1,5,1))        + CHR(13) +
                       c-lbl-tipo-conversao-moeda + ": " + IF (SUBSTRING(RowObject.char-1,6,1)) = "2":U THEN 
                                                               c-lbl-data-geracao-pendencia 
                                                           ELSE c-lbl-data-aprovacao                                  + CHR(13) +
                       c-lbl-perm-aprov           + ": " + string(fn-traduz-log(RowObject.perm-aprov))                + chr(13) +                                                                           
                       c-lbl-aprova-auto          + ": " + string(fn-traduz-log(RowObject.aprova-auto))               + chr(13) +                                                                           
                       c-lbl-aprova-auto-aprov    + ": " + string(fn-traduz-log(RowObject.aprova-auto-aprov))         + chr(13) +                                                                           
                       c-lbl-destino-lotacao      + ": " + string(RowObject.destino-lotacao)                          + chr(13) +                                                                                                                
                       c-lbl-libera-verba         + ": " + string(fn-traduz-log(RowObject.libera-verba))              + chr(13) +                                                                                                                
                       c-lbl-log-html             + ": " + string(fn-traduz-log(RowObject.log-html))                  + chr(13) +  
                       c-lbl-log-4                + ": " + string(fn-traduz-log(RowObject.log-4))                     + chr(13) +
                       c-lbl-usuar-mestre         + ": " + string(fn-traduz-log(RowObject.usuar-mestre))              + chr(13) +                                                                                                                                                                                                                              
                       c-lbl-envia-email          + ": " + string(fn-traduz-log(RowObject.envia-email))               + chr(13) +                                                                                                                
                       c-lbl-recebe-email         + ": " + string(fn-traduz-log(RowObject.recebe-email))              + chr(13) +                                                                                                                
                       c-lbl-e-mail               + ": " + string(RowObject.e-mail)                                   + CHR(13) +
                       c-lbl-ordenacao            + ": " + fn-desc-ordenacao(RowObject.idi-ordenacao-portal)          + CHR(13) +
                       c-lbl-todas-empresas       + ": " + STRING(fn-traduz-log(RowObject.log-pendcia-todas-empres))  + CHR(13) +
                       c-lbl-visualizacao-padrao  + ": " + fn-desc-visualizacao-padrao(RowObject.int-1)               + CHR(13) +
                       c-lbl-aprov-indvd-sem-sel  + ": " + string(fn-traduz-log(RowObject.log-aprovac-unica-pendcia)) + CHR(13) +
                       c-lbl-visualiza-detalhe-listagem + ": " + fn-traduz-char-log(SUBSTRING(RowObject.char-1,3,1)) + CHR(13) +
                       c-lbl-visualiza-contador-pendencia + ": " + fn-traduz-char-log(SUBSTRING(RowObject.char-1,4,1)) + CHR(13) +
                       c-lbl-log-usuar-config + ": " + string(fn-traduz-log(RowObject.log-usuar-config)).

                                                      
    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    FIND FIRST mla-usuar-aprov
        WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK NO-ERROR.
    RUN pi-gera-log IN h-boin769(INPUT 23, /*cod tabela*/
                                 INPUT ROWID(mla-usuar-aprov),
                                 INPUT 1, /*Inclus∆o*/
                                 INPUT c-log-reg).

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST tt-mla-usuar-aprov-antes NO-LOCK NO-ERROR.
    FIND FIRST RowObject NO-LOCK NO-ERROR.
    
    IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.

    RUN pi-traduz-labels IN THIS-PROCEDURE.

    assign c-log-reg = "".
    if  available tt-mla-usuar-aprov-antes then do:

        if  tt-mla-usuar-aprov-antes.nome-usuar <> RowObject.nome-usuar then
            assign c-log-reg = c-log-reg +
                   c-lbl-nome-usuar + "               : " + string(tt-mla-usuar-aprov-antes.nome-usuar) + chr(13) +             
                   "                   : " + string(RowObject.nome-usuar) + chr(13) + chr(13).

        if  tt-mla-usuar-aprov-antes.cod-lotacao <> RowObject.cod-lotacao then
            assign c-log-reg = c-log-reg +
                   c-lbl-cod-lotacao + "            : " + string(tt-mla-usuar-aprov-antes.cod-lotacao) + chr(13) +             
                   "                   : " + string(RowObject.cod-lotacao) + chr(13) + chr(13).

        if  tt-mla-usuar-aprov-antes.cod-estabel <> RowObject.cod-estabel then
            assign c-log-reg = c-log-reg +
                   c-lbl-cod-estabel + "    : " + string(tt-mla-usuar-aprov-antes.cod-estabel) + chr(13) +             
                   "                   : " + string(RowObject.cod-estabel) + chr(13) + chr(13).

        if  tt-mla-usuar-aprov-antes.mo-codigo <> RowObject.mo-codigo then
            assign c-log-reg = c-log-reg +
                   c-lbl-mo-codigo + "              : " + string(tt-mla-usuar-aprov-antes.mo-codigo) + chr(13) +             
                   "                   : " + string(RowObject.mo-codigo) + chr(13) + chr(13).

        if  substring(tt-mla-usuar-aprov-antes.char-1,5,1) <> SUBSTRING(RowObject.char-1,5,1) then
            assign c-log-reg = c-log-reg +
                   c-lbl-converte-para-moeda + "    : " + fn-traduz-char-log(SUBSTRING(tt-mla-usuar-aprov-antes.char-1,5,1)) + chr(13) +             
                   "                                           : " + fn-traduz-char-log(SUBSTRING(RowObject.char-1,5,1)) + chr(13) + chr(13).

        if  substring(tt-mla-usuar-aprov-antes.char-1,6,1) <> SUBSTRING(RowObject.char-1,6,1) then
            assign c-log-reg = c-log-reg +
                   c-lbl-tipo-conversao-moeda + "  : " + SUBSTRING(tt-mla-usuar-aprov-antes.char-1,6,1) + chr(13) +           
                   "                       : " + SUBSTRING(RowObject.char-1,6,1) + chr(13) + chr(13).

        if  tt-mla-usuar-aprov-antes.e-mail <> RowObject.e-mail then
            assign c-log-reg = c-log-reg +
                   c-lbl-e-mail + "             : " + string(tt-mla-usuar-aprov-antes.e-mail) + chr(13) +             
                   "                   : " + string(RowObject.e-mail) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.destino-lotacao <> RowObject.destino-lotacao then
            assign c-log-reg = c-log-reg +
                   c-lbl-destino-lotacao + "    : " + string(tt-mla-usuar-aprov-antes.destino-lotacao) + chr(13) +             
                   "                   : " + string(RowObject.destino-lotacao) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.perm-aprov <> RowObject.perm-aprov then
            assign c-log-reg = c-log-reg +
                   c-lbl-perm-aprov + "          : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.perm-aprov)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.perm-aprov)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.aprova-auto <> RowObject.aprova-auto then
            assign c-log-reg = c-log-reg +
                   c-lbl-aprova-auto + "     : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.aprova-auto)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.aprova-auto)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.aprova-auto-aprov <> RowObject.aprova-auto-aprov then
            assign c-log-reg = c-log-reg +
                   c-lbl-aprova-auto-aprov + "   : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.aprova-auto-aprov)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.aprova-auto-aprov)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.libera-verba <> RowObject.libera-verba then
            assign c-log-reg = c-log-reg +
                   c-lbl-libera-verba + "       : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.libera-verba)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.libera-verba)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.log-html <> RowObject.log-html then
            assign c-log-reg = c-log-reg +
                   c-lbl-log-html + "           : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.log-html)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.log-html)) + chr(13) + chr(13). 

        if  tt-mla-usuar-aprov-antes.log-4 <> RowObject.log-4 then
            assign c-log-reg = c-log-reg +
                   c-lbl-log-4 + "      : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.log-4)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.log-4)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.usuar-mestre <> RowObject.usuar-mestre then
            assign c-log-reg = c-log-reg +
                   c-lbl-usuar-mestre + "     : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.usuar-mestre)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.usuar-mestre)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.envia-email <> RowObject.envia-email then
            assign c-log-reg = c-log-reg +
                   c-lbl-envia-email + "       : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.envia-email)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.envia-email)) + chr(13) + chr(13).                   

        if  tt-mla-usuar-aprov-antes.recebe-email <> RowObject.recebe-email then
            assign c-log-reg = c-log-reg +
                   c-lbl-recebe-email + "      : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.recebe-email)) + chr(13) +             
                   "                   : " + string(fn-traduz-log(RowObject.recebe-email)) + chr(13) + chr(13).

        IF tt-mla-usuar-aprov-antes.idi-ordenacao-portal <> RowObject.idi-ordenacao-portal THEN
            ASSIGN c-log-reg = c-log-reg + 
                   c-lbl-ordenacao + "   : " + fn-desc-ordenacao(tt-mla-usuar-aprov-antes.idi-ordenacao-portal)+ CHR(13) +
                   "                            : " + fn-desc-ordenacao(RowObject.idi-ordenacao-portal) + chr(13) + chr(13).

        if  tt-mla-usuar-aprov-antes.log-pendcia-todas-empres <> RowObject.log-pendcia-todas-empres then
            assign c-log-reg = c-log-reg +
                   c-lbl-todas-empresas + "      : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.log-pendcia-todas-empres)) + chr(13) +             
                   "                                       : " + string(fn-traduz-log(RowObject.log-pendcia-todas-empres)) + chr(13) + chr(13).

        IF  tt-mla-usuar-aprov-antes.int-1 <> RowObject.int-1 then
            assign c-log-reg = c-log-reg +
                   c-lbl-visualizacao-padrao + "      : " + string(fn-desc-visualizacao-padrao(tt-mla-usuar-aprov-antes.int-1)) + chr(13) +             
                   "                                       : " + string(fn-desc-visualizacao-padrao(RowObject.int-1)) + chr(13) + chr(13).

        if  tt-mla-usuar-aprov-antes.log-aprovac-unica-pendcia <> RowObject.log-aprovac-unica-pendcia then
            assign c-log-reg = c-log-reg +
                   c-lbl-aprov-indvd-sem-sel + "      : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.log-aprovac-unica-pendcia)) + chr(13) +             
                   "                                  : " + string(fn-traduz-log(RowObject.log-aprovac-unica-pendcia)) + chr(13) + chr(13).

        if  SUBSTRING(tt-mla-usuar-aprov-antes.char-1,3,1) <> SUBSTRING(RowObject.char-1,3,1) THEN
            assign c-log-reg = c-log-reg +
                   c-lbl-visualiza-detalhe-listagem + "      : " + fn-traduz-char-log(SUBSTRING(tt-mla-usuar-aprov-antes.char-1,3,1)) + chr(13) +             
                   "                                  : " + fn-traduz-char-log(SUBSTRING(RowObject.char-1,3,1)) + chr(13) + chr(13).

        if  SUBSTRING(tt-mla-usuar-aprov-antes.char-1,4,1) <> SUBSTRING(RowObject.char-1,4,1) THEN
            assign c-log-reg = c-log-reg +
                   c-lbl-visualiza-contador-pendencia + "      : " + fn-traduz-char-log(SUBSTRING(tt-mla-usuar-aprov-antes.char-1,4,1)) + chr(13) +             
                   "                                  : " + fn-traduz-char-log(SUBSTRING(RowObject.char-1,4,1)) + chr(13) + chr(13).

        if tt-mla-usuar-aprov-antes.log-usuar-config <> RowObject.log-usuar-config then
            assign c-log-reg = c-log-reg +
                   c-lbl-log-usuar-config + "      : " + string(fn-traduz-log(tt-mla-usuar-aprov-antes.log-usuar-config)) + chr(13) +             
                   "                                  : " + string(fn-traduz-log(RowObject.log-usuar-config)) + chr(13) + chr(13).
    end.

    IF TRIM(c-log-reg) <> "":U THEN DO:
        FIND FIRST mla-usuar-aprov
            WHERE mla-usuar-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK NO-ERROR.
        RUN pi-gera-log IN h-boin769(INPUT 23, /*cod tabela*/
                                     INPUT ROWID(mla-usuar-aprov),
                                     INPUT 2, /*alteraá∆o*/
                                     INPUT c-log-reg).
    END.

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF NOT VALID-HANDLE(h-boin769) THEN
        RUN inbo/boin769.p PERSISTENT SET h-boin769.
     
    RUN pi-traduz-labels IN THIS-PROCEDURE.

    ASSIGN c-log-reg = entry(23,{ininc/i03in030.i 03})    + chr(13) + chr(13) +
                       c-lbl-cod-usuar                    + ": " + string(mla-usuar-aprov.cod-usuar)                                + chr(13) + 
                       c-lbl-nome-usuar                   + ": " + string(mla-usuar-aprov.nome-usuar)                               + chr(13) + 
                       c-lbl-cod-lotacao                  + ": " + string(mla-usuar-aprov.cod-lotacao)                              + chr(13) +                                      
                       c-lbl-cod-estabel                  + ": " + string(mla-usuar-aprov.cod-estabel)                              + chr(13) +                                      
                       c-lbl-mo-codigo                    + ": " + string(mla-usuar-aprov.mo-codigo)                                + chr(13) +      
                       c-lbl-converte-para-moeda          + ": " + fn-traduz-char-log(SUBSTRING(mla-usuar-aprov.char-1,5,1))        + CHR(13) +
                       c-lbl-tipo-conversao-moeda         + ": " + IF (SUBSTRING(mla-usuar-aprov.char-1,6,1)) = "2":U THEN 
                                                               c-lbl-data-geracao-pendencia 
                                                           ELSE c-lbl-data-aprovacao                                                + CHR(13) +
                       c-lbl-perm-aprov                   + ": " + string(fn-traduz-log(mla-usuar-aprov.perm-aprov))                + chr(13) +                                                                           
                       c-lbl-aprova-auto                  + ": " + string(fn-traduz-log(mla-usuar-aprov.aprova-auto))               + chr(13) +                                                                           
                       c-lbl-aprova-auto-aprov            + ": " + string(fn-traduz-log(mla-usuar-aprov.aprova-auto-aprov))         + chr(13) +                                                                           
                       c-lbl-destino-lotacao              + ": " + string(mla-usuar-aprov.destino-lotacao)                          + chr(13) +                                                                                                                
                       c-lbl-libera-verba                 + ": " + string(fn-traduz-log(mla-usuar-aprov.libera-verba))              + chr(13) +                                                                                                                
                       c-lbl-log-html                     + ": " + string(fn-traduz-log(mla-usuar-aprov.log-html))                  + chr(13) +  
                       c-lbl-log-4                        + ": " + string(fn-traduz-log(mla-usuar-aprov.log-4))                     + chr(13) +  
                       c-lbl-usuar-mestre                 + ": " + string(fn-traduz-log(mla-usuar-aprov.usuar-mestre))              + chr(13) +                                                                                                                                                                                                                              
                       c-lbl-envia-email                  + ": " + string(fn-traduz-log(mla-usuar-aprov.envia-email))               + chr(13) +                                                                                                                
                       c-lbl-recebe-email                 + ": " + string(fn-traduz-log(mla-usuar-aprov.recebe-email))              + chr(13) +                                                                                                                
                       c-lbl-e-mail                       + ": " + string(mla-usuar-aprov.e-mail)                                   + CHR(13) +
                       c-lbl-ordenacao                    + ": " + fn-desc-ordenacao(mla-usuar-aprov.idi-ordenacao-portal)          + chr(13) + 
                       c-lbl-todas-empresas               + ": " + string(fn-traduz-log(mla-usuar-aprov.log-pendcia-todas-empres))  + chr(13) +
                       c-lbl-visualizacao-padrao          + ": " + fn-desc-visualizacao-padrao(mla-usuar-aprov.int-1)               + CHR(13) + 
                       c-lbl-aprov-indvd-sem-sel          + ": " + string(fn-traduz-log(mla-usuar-aprov.log-aprovac-unica-pendcia)) + CHR(13) + 
                       c-lbl-visualiza-detalhe-listagem   + ": " + fn-traduz-char-log(SUBSTRING(mla-usuar-aprov.char-1,3,1))        + CHR(13) + 
                       c-lbl-visualiza-contador-pendencia + ": " + fn-traduz-char-log(SUBSTRING(mla-usuar-aprov.char-1,4,1))        + CHR(13) +
                       c-lbl-log-usuar-config             + ": " + string(fn-traduz-log(mla-usuar-aprov.log-usuar-config)).
    
    RUN pi-gera-log IN h-boin769(INPUT 23, /*cod tabela*/
                                 INPUT rowid(mla-usuar-aprov),
                                 INPUT 3,
                                 INPUT c-log-reg).

    IF VALID-HANDLE(h-boin769) THEN DO:
        DELETE PROCEDURE h-boin769.
        ASSIGN h-boin769 = ?.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        WHEN "char-3":U THEN ASSIGN pFieldValue = RowObject.char-3.
        WHEN "char-4":U THEN ASSIGN pFieldValue = RowObject.char-4.
        WHEN "char-5":U THEN ASSIGN pFieldValue = RowObject.char-5.
        WHEN "cod-estabel":U THEN ASSIGN pFieldValue = RowObject.cod-estabel.
        WHEN "cod-lotacao":U THEN ASSIGN pFieldValue = RowObject.cod-lotacao.
        WHEN "cod-usuar":U THEN ASSIGN pFieldValue = RowObject.cod-usuar.
        WHEN "e-mail":U THEN ASSIGN pFieldValue = RowObject.e-mail.
        WHEN "nome-usuar":U THEN ASSIGN pFieldValue = RowObject.nome-usuar.
        &IF "{&mguni_version}" >= "2.071" &THEN
            WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
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
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
        WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        WHEN "data-3":U THEN ASSIGN pFieldValue = RowObject.data-3.
        WHEN "data-4":U THEN ASSIGN pFieldValue = RowObject.data-4.
        WHEN "data-5":U THEN ASSIGN pFieldValue = RowObject.data-5.
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
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        WHEN "dec-3":U THEN ASSIGN pFieldValue = RowObject.dec-3.
        WHEN "dec-4":U THEN ASSIGN pFieldValue = RowObject.dec-4.
        WHEN "dec-5":U THEN ASSIGN pFieldValue = RowObject.dec-5.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getEmpresaEstabUsuario DBOProgram 
PROCEDURE getEmpresaEstabUsuario :
/*------------------------------------------------------------------------------
  Purpose:     Retornar a empresa e establecimento do usuario recebido como parametro 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pc-cod-usuar   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-ep-codigo   AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pc-cod-estabel AS CHARACTER NO-UNDO.

    FOR FIRST mla-usuar-aprov FIELDS(cod-usuar cod-estabel)
        WHERE mla-usuar-aprov.cod-usuar = pc-cod-usuar NO-LOCK: END.

    IF NOT AVAIL mla-usuar-aprov THEN
        RETURN "NOK":U.

    FOR FIRST estabelec FIELDS(cod-estabel ep-codigo)
        WHERE estabelec.cod-estabel = mla-usuar-aprov.cod-estabel NO-LOCK: END.
    
    ASSIGN pc-ep-codigo   = estabelec.ep-codigo WHEN AVAIL estabelec
           pc-cod-estabel = mla-usuar-aprov.cod-estabel.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "destino-lotacao":U THEN ASSIGN pFieldValue = RowObject.destino-lotacao.
        &IF "{&mguni_version}" < "2.071" &THEN
             WHEN "ep-codigo":U THEN ASSIGN pFieldValue = RowObject.ep-codigo.
        &ENDIF
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        WHEN "int-3":U THEN ASSIGN pFieldValue = RowObject.int-3.
        WHEN "int-4":U THEN ASSIGN pFieldValue = RowObject.int-4.
        WHEN "int-5":U THEN ASSIGN pFieldValue = RowObject.int-5.
        WHEN "mo-codigo":U THEN ASSIGN pFieldValue = RowObject.mo-codigo.
        WHEN "idi-ordenacao-portal":U THEN ASSIGN pFieldValue = RowObject.idi-ordenacao-portal.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do °ndice codigo
  Parameters:  
               retorna valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pcod-usuar LIKE mla-usuar-aprov.cod-usuar NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pcod-usuar = RowObject.cod-usuar.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aprova-auto":U THEN ASSIGN pFieldValue = RowObject.aprova-auto.
        WHEN "aprova-auto-aprov":U THEN ASSIGN pFieldValue = RowObject.aprova-auto-aprov.
        WHEN "envia-email":U THEN ASSIGN pFieldValue = RowObject.envia-email.
        WHEN "libera-verba":U THEN ASSIGN pFieldValue = RowObject.libera-verba.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        WHEN "log-3":U THEN ASSIGN pFieldValue = RowObject.log-3.
        WHEN "log-4":U THEN ASSIGN pFieldValue = RowObject.log-4.
        WHEN "log-5":U THEN ASSIGN pFieldValue = RowObject.log-5.
        WHEN "log-html":U THEN ASSIGN pFieldValue = RowObject.log-html.
        WHEN "log-usuar-config":U THEN ASSIGN pFieldValue = RowObject.log-usuar-config.
        WHEN "perm-aprov":U THEN ASSIGN pFieldValue = RowObject.perm-aprov.
        WHEN "recebe-email":U THEN ASSIGN pFieldValue = RowObject.recebe-email.
        WHEN "usuar-mestre":U THEN ASSIGN pFieldValue = RowObject.usuar-mestre.
        WHEN "log-pendcia-todas-empres":U THEN ASSIGN pFieldValue = RowObject.log-pendcia-todas-empres.
        WHEN "log-aprovac-unica-pendcia":U THEN ASSIGN pFieldValue = RowObject.log-aprovac-unica-pendcia.
        
        OTHERWISE RETURN "NOK":U.
    END CASE.

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
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW NO-UNDO.

    /*--- Verifica se temptable RowObject est† dispon°vel, caso n∆o esteja ser†
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getUsuarioMestre DBOProgram 
PROCEDURE getUsuarioMestre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF  NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    IF  NOT RowObject.usuar-mestre THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice codigo
  Parameters:  
               recebe valor do campo cod-usuar
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pcod-usuar LIKE mla-usuar-aprov.cod-usuar NO-UNDO.

    FIND FIRST bf-mla-usuar-aprov WHERE 
        bf-mla-usuar-aprov.cod-usuar = pcod-usuar NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bf-mla-usuar-aprov THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bf-mla-usuar-aprov)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

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
    DEF INPUT PARAMETER p-ordem AS CHAR NO-UNDO.

    RUN openQueryStatic (input "Main":U). 

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroCodigo DBOProgram 
PROCEDURE openQueryFiltroCodigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where 
                                   {&TABLENAME}.cod-usuar >= c-cod-usuar-ini AND
                                   {&TABLENAME}.cod-usuar <= c-cod-usuar-fim
                                   NO-LOCK by {&TABLENAME}.cod-usuar.
  RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryFiltroNome DBOProgram 
PROCEDURE openQueryFiltroNome :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  open query {&QUERYNAME} for each {&TABLENAME} where 
                                   {&TABLENAME}.nome-usuar >= c-nome-usuar-ini AND
                                   {&TABLENAME}.nome-usuar <= c-nome-usuar-fim
                                   NO-LOCK by {&TABLENAME}.nome-usuar.
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
    open query {&QUERYNAME} for each {&TABLENAME} 
                 NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-traduz-labels DBOProgram 
PROCEDURE pi-traduz-labels :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF NOT l-traduziu THEN DO:
        /*gerar log*/
        {utp/ut-liter.i "C¢digo" * r}
        ASSIGN c-lbl-cod-usuar = RETURN-VALUE.
        {utp/ut-liter.i "Nome" * r}
        ASSIGN c-lbl-nome-usuar = RETURN-VALUE.
        {utp/ut-liter.i "Lotaá∆o" * r}
        ASSIGN c-lbl-cod-lotacao = RETURN-VALUE.
        {utp/ut-liter.i "Estabelecimento" * r}
        ASSIGN c-lbl-cod-estabel = RETURN-VALUE.
        {utp/ut-liter.i "Moeda" * r}
        ASSIGN c-lbl-mo-codigo = RETURN-VALUE.
        {utp/ut-liter.i "Aprovador" * r}
        ASSIGN c-lbl-perm-aprov = RETURN-VALUE.
        {utp/ut-liter.i "Aprovador_Auto" * r}
        ASSIGN c-lbl-aprova-auto = RETURN-VALUE.
        {utp/ut-liter.i "Aprov_Auto_Aprov" * r}
        ASSIGN c-lbl-aprova-auto-aprov = RETURN-VALUE.
        {utp/ut-liter.i "Destino Lotaá∆o" * r}
        ASSIGN c-lbl-destino-lotacao = RETURN-VALUE.
        {utp/ut-liter.i "Libera_Verba" * r}
        ASSIGN c-lbl-libera-verba = RETURN-VALUE.
        {utp/ut-liter.i "Log_HTML" * r}
        ASSIGN c-lbl-log-html = RETURN-VALUE.
        {utp/ut-liter.i "E-mail_HTML_Palm" * r}
        ASSIGN c-lbl-log-4 = RETURN-VALUE.
        {utp/ut-liter.i "Usu†rio_Mestre" * r}
        ASSIGN c-lbl-usuar-mestre = RETURN-VALUE.
        {utp/ut-liter.i "Envia_E-mail" * r}
        ASSIGN c-lbl-envia-email = RETURN-VALUE.
        {utp/ut-liter.i "Recebe_E-mail" * r}
        ASSIGN c-lbl-recebe-email = RETURN-VALUE.
        {utp/ut-liter.i "E-mail" * r}
        ASSIGN c-lbl-e-mail = RETURN-VALUE.
        {utp/ut-liter.i "Ordenaá∆o_Portal" * r}
        ASSIGN c-lbl-ordenacao = RETURN-VALUE.
        {utp/ut-liter.i "Visualiza_Todas_Empresas" * r}
        ASSIGN c-lbl-todas-empresas = RETURN-VALUE.  
        {utp/ut-liter.i "Visualizaá∆o_Padr∆o_Portal" * r}
        ASSIGN c-lbl-visualizacao-padrao = RETURN-VALUE. 
        {utp/ut-liter.i "Aprova_individual_sem_selecionadas" * r}
        ASSIGN c-lbl-aprov-indvd-sem-sel = RETURN-VALUE.
        {utp/ut-liter.i "Visualiza_detalhes_na_listagem"}
        ASSIGN c-lbl-visualiza-detalhe-listagem = RETURN-VALUE.
        {utp/ut-liter.i "Visualiza_Contadores_de_Pendàncias"}
        ASSIGN c-lbl-visualiza-contador-pendencia = RETURN-VALUE.
        {utp/ut-liter.i "Visualiza_nesta_moeda"}
        ASSIGN c-lbl-converte-para-moeda = RETURN-VALUE.
        {utp/ut-liter.i "Converte_para"}
        ASSIGN c-lbl-tipo-conversao-moeda = RETURN-VALUE.
        {utp/ut-liter.i "Data_aprovaá∆o"}
        ASSIGN c-lbl-data-aprovacao = RETURN-VALUE.
        {utp/ut-liter.i "Data_da_geraá∆o_da_pendància"}
        ASSIGN c-lbl-data-geracao-pendencia = RETURN-VALUE.
        {utp/ut-liter.i "Configurador_visual"}
        ASSIGN c-lbl-log-usuar-config = RETURN-VALUE.

  
        ASSIGN l-traduziu = YES.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroCodigo DBOProgram 
PROCEDURE setConstraintFiltroCodigo :
/*------------------------------------------------------------------------------
  Purpose:    Seta as vari†veis de controle para queries contendo o item
              inicial e final.
  Parameters: ipar1:pcod-usuar-ini:Item Inicial
              ipar2:pcod-usuar-fim:Item Final
------------------------------------------------------------------------------*/
  def input param pcod-usuar-ini as char.
  def input param pcod-usuar-fim as char.

  assign c-cod-usuar-ini = pcod-usuar-ini
         c-cod-usuar-fim = pcod-usuar-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintFiltroNome DBOProgram 
PROCEDURE setConstraintFiltroNome :
/*------------------------------------------------------------------------------
  Purpose:    Seta as variaveis de controle para queries contendo o item
              inicial e final , descricao inicial e final,ordena.   
  Parameters: ipar1:pnome-usuar-ini:Descricao Inicial
              ipar2:pnome-usuar-fim:Descricao Final
------------------------------------------------------------------------------*/
  def input param pnome-usuar-ini     as char.
  def input param pnome-usuar-fim     as char.
  
  assign c-nome-usuar-ini = pnome-usuar-ini
         c-nome-usuar-fim = pnome-usuar-fim.

  RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*:T------------------------------------------------------------------------------
  Purpose:     Validaá‰es pertinentes ao DBO
  Parameters:  recebe o tipo de validaá∆o (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*:T--- Utilize o parÉmetro pType para identificar quais as validaá‰es a serem
          executadas ---*/
    /*:T--- Os valores poss°veis para o parÉmetro s∆o: Create, Delete e Update ---*/
    /*:T--- Devem ser tratados erros PROGRESS e erros do Produto, atravÇs do 
          include: method/svc/errors/inserr.i ---*/
    /*:T--- Inclua aqui as validaá‰es ---*/
    
    /* guardar as informaá‰es antes de alterar para poder gerar o log de modificaá∆o */
    EMPTY TEMP-TABLE tt-mla-usuar-aprov-antes.
    FIND FIRST bf-mla-usuar-aprov
        WHERE bf-mla-usuar-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK NO-ERROR.
    IF AVAIL bf-mla-usuar-aprov THEN DO:
        CREATE tt-mla-usuar-aprov-antes.
        BUFFER-COPY bf-mla-usuar-aprov TO tt-mla-usuar-aprov-antes.
    END.
    
    /* validaá‰es para criaá∆o */
    IF pType = "CREATE" THEN DO:
        IF CAN-FIND(FIRST mla-usuar-aprov
                    WHERE mla-usuar-aprov.cod-usuar  = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i "usu†rios_da_aprovaá∆o"}
            {method/svc/errors/inserr.i
                    &ErrorNumber="1"
                    &ErrorType="EMS"
                    &ErrorSubType="ERROR" 
                    &ErrorParameters=RETURN-VALUE}
        END.

        IF NOT CAN-FIND (FIRST usuar_mestre 
                         WHERE usuar_mestre.cod_usuario = RowObject.cod-usuar) THEN DO:
            {utp/ut-liter.i Usu†rio_Mestre * r}
            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS"
                              &ErrorParameters=trim(return-value)}
        END.
    END.

    /* Validaá‰es para criaá∆o e atualizaá∆o */
    IF pType = "CREATE" OR pType = "UPDATE" THEN DO:
        FOR FIRST estabelec FIELDS()
            WHERE estabelec.cod-estabel = RowObject.cod-estabel NO-LOCK: END.

        IF NOT AVAIL estabelec THEN DO:
            {utp/ut-table.i mgadm estabelec 1}
            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS"
                              &ErrorParameters=trim(return-value)}
        END.
        
        RUN cdp/cd9970.p (INPUT ROWID(estabelec),
                          OUTPUT c-empresa).

        IF NOT CAN-FIND (FIRST mla-lotacao
                         WHERE mla-lotacao.ep-codigo = c-empresa
                           AND mla-lotacao.cod-lotacao = RowObject.cod-lotacao) THEN DO:
            {utp/ut-table.i mgind mla-lotacao 1}
            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS"
                              &ErrorParameters=trim(return-value)}
        END.

        IF NOT CAN-FIND(FIRST moeda 
                        WHERE moeda.mo-codigo = RowObject.mo-codigo) THEN DO:
            {utp/ut-liter.i Moeda * r}
            {method/svc/errors/inserr.i
                              &ErrorNumber="2"
                              &ErrorType="EMS"
                              &ErrorParameters=trim(return-value)}
        END.

        /* respons†vel inv†lido */
        IF RowObject.destino-lotacao < 1 OR RowObject.destino-lotacao > 2 THEN DO:
            {utp/ut-liter.i "Opá∆o de respons†vel"}
            {method/svc/errors/inserr.i
                              &ErrorNumber="158"
                              &ErrorType="EMS"
                              &ErrorParameters=trim(return-value)}
        END.
    END.

    /* validaá‰es para remoá∆o */
    IF pType = "DELETE" THEN DO:
        FIND FIRST bf-mla-usuar-aprov 
            WHERE bf-mla-usuar-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK NO-ERROR.
        ASSIGN r-rowid = ROWID(bf-mla-usuar-aprov).
            
        /**  Permiss‰es do usu†rio
        **/
        FOR first mla-perm-aprov fields(cod-usuar) where
            mla-perm-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK:
            {method/svc/errors/inserr.i
                  &ErrorNumber=26597
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Verbas do usu†rio
        **/
        FOR first mla-verba-aprov fields(cod-usuar) where
            mla-verba-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK:

            {method/svc/errors/inserr.i
                  &ErrorNumber=26598
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Lotaá‰es do usu†rio
        **/
        FOR first mla-perm-lotacao fields(cod-usuar) where
            mla-perm-lotacao.cod-usuar = RowObject.cod-usuar NO-LOCK:
    
            {method/svc/errors/inserr.i
                  &ErrorNumber=26599
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Aprovadores da faixa
        **/
        FOR first mla-hierarquia-faixa fields(cod-usuar) where
            mla-hierarquia-faixa.cod-usuar = RowObject.cod-usuar NO-LOCK:
    
            {method/svc/errors/inserr.i
                  &ErrorNumber=26600
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Hierarquia de aprovadores
        **/
        FOR first mla-hierarquia-aprov fields(cod-usuar) where
            mla-hierarquia-aprov.cod-usuar = RowObject.cod-usuar NO-LOCK:
        
            {method/svc/errors/inserr.i
                  &ErrorNumber=26601
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Aprovadores alternativos
        **/
        FOR first mla-usuar-aprov-altern fields(cod-usuar) where
            mla-usuar-aprov-altern.cod-usuar = RowObject.cod-usuar NO-LOCK:
           
            {method/svc/errors/inserr.i
                  &ErrorNumber=26602
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        FOR first mla-usuar-aprov-altern fields(cod-usuar-altern) where
            mla-usuar-aprov-altern.cod-usuar-altern = RowObject.cod-usuar NO-LOCK:
        
            {method/svc/errors/inserr.i
                  &ErrorNumber=26602
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Lista de aprovadores do documento
        **/
        FOR first mla-lista-aprov-doc fields(cod-usuar) where
            mla-lista-aprov-doc.cod-usuar = RowObject.cod-usuar NO-LOCK:
      
            {method/svc/errors/inserr.i
                  &ErrorNumber=26603
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
    
        /**  Lista de aprovadores do item
        **/
        FOR first mla-lista-aprov-item fields(cod-usuar) where
            mla-lista-aprov-item.cod-usuar = RowObject.cod-usuar NO-LOCK:
    
            {method/svc/errors/inserr.i
                  &ErrorNumber=26603
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        
        /**  Lista de aprovadores da fam°lia
        **/
        FOR first mla-lista-aprov-fam fields(cod-usuar) where
            mla-lista-aprov-fam.cod-usuar = RowObject.cod-usuar NO-LOCK:
       
            {method/svc/errors/inserr.i
                  &ErrorNumber=26603
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
    
        /**  Lista de aprovadores da referencia
        **/
        FOR first mla-lista-aprov-ref fields(cod-usuar) where
            mla-lista-aprov-ref.cod-usuar = RowObject.cod-usuar NO-LOCK:
     
            {method/svc/errors/inserr.i
                  &ErrorNumber=26603
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
    
        /**  Aprovador padr∆o
        **/
        FOR first mla-usuar-padrao fields(cod-usuar) where
            mla-usuar-padrao.cod-usuar = RowObject.cod-usuar NO-LOCK:
       
            {method/svc/errors/inserr.i
                  &ErrorNumber=26604
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
    
        /**  Limites de aprovaá∆o da fam°lia
        **/
        FOR first mla-lim-aprov-fam fields(cod-usuar) where
            mla-lim-aprov-fam.cod-usuar = RowObject.cod-usuar NO-LOCK:
         
            {method/svc/errors/inserr.i
                  &ErrorNumber=26605
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
    
        /**  Pendàncias de aprovaá∆o
        **/
        FOR first mla-doc-pend-aprov fields(cod-usuar ind-situacao) where
            mla-doc-pend-aprov.cod-usuar    = RowObject.cod-usuar and
           (mla-doc-pend-aprov.ind-situacao = 1 or
            mla-doc-pend-aprov.ind-situacao = 3)  NO-LOCK:
       
            {method/svc/errors/inserr.i
                  &ErrorNumber=26606
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        FOR first mla-doc-pend-aprov fields(cod-usuar-doc ind-situacao) where
            mla-doc-pend-aprov.cod-usuar-doc = RowObject.cod-usuar and
           (mla-doc-pend-aprov.ind-situacao  = 1 or
            mla-doc-pend-aprov.ind-situacao  = 3)  NO-LOCK:
    
            {method/svc/errors/inserr.i
                  &ErrorNumber=26606
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
        FOR first mla-doc-pend-aprov fields(cod-usuar-trans ind-situacao) where
            mla-doc-pend-aprov.cod-usuar-trans = RowObject.cod-usuar and
           (mla-doc-pend-aprov.ind-situacao    = 1 or
            mla-doc-pend-aprov.ind-situacao    = 3)  NO-LOCK:
    
            {method/svc/errors/inserr.i
                  &ErrorNumber=26606
                  &ErrorType="EMS"
                  &ErrorParameters=RowObject.cod-usuar}
        end.
    END.

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-ordenacao DBOProgram 
FUNCTION fn-desc-ordenacao RETURNS CHARACTER
  ( i-ordenacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    /*
    Ordenaá∆o (RowObject.char-1,1,1)
     1 - Mais recentes
     2 - Mais antigas
     3 - Maior valor
     4 - Menor valor
     5 - Maior empresa
     6 - Menor empresa
    */
    CASE i-ordenacao:
        WHEN 1 THEN
            {utp/ut-liter.i "Mais recentes" * r}
        WHEN 2 THEN
            {utp/ut-liter.i "Mais antigas" * r}
        WHEN 3 THEN
            {utp/ut-liter.i "Maior valor" * r}
        WHEN 4 THEN
            {utp/ut-liter.i "Menor valor" * r}
        WHEN 5 THEN
            {utp/ut-liter.i "Maior empresa" * r}
        WHEN 6 THEN
            {utp/ut-liter.i "Menor empresa" * r}
        OTHERWISE
            {utp/ut-liter.i "Mais recentes" * r}
    END CASE.
    
    RETURN RETURN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-desc-visualizacao-padrao DBOProgram 
FUNCTION fn-desc-visualizacao-padrao RETURNS CHARACTER
  ( i-visualizacao AS INTEGER ) :
/*------------------------------------------------------------------------------
  Purpose: Apresentar a descriá∆o da visualizaá∆o padr∆o das pendàncias   
    Notes:  
------------------------------------------------------------------------------*/
    /*
    Ordenaá∆o (RowObject.int-1)
     0 - Todas Pendàncias
     1 - Minhas Pendàncias
     2 - Pendàncias como Mestre
     3 - Pendàncias alternativas
    */
    CASE i-visualizacao:
        WHEN 0 THEN
            {utp/ut-liter.i "Todas Pendàncias" * r}
        WHEN 1 THEN
            {utp/ut-liter.i "Todas Pendàncias" * r}
        WHEN 2 THEN
            {utp/ut-liter.i "Minhas Pendàncias" * r}
        WHEN 3 THEN
            {utp/ut-liter.i "Pendàncias como Mestre" * r}
        WHEN 4 THEN
            {utp/ut-liter.i "Pendàncias Alternativas" * r}
        OTHERWISE
            {utp/ut-liter.i "Todas Pendàncias" * r}
    END CASE.
    
    RETURN RETURN-VALUE.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-traduz-char-log DBOProgram 
FUNCTION fn-traduz-char-log RETURNS CHARACTER
  ( p-value AS CHAR ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
    RETURN IF p-value = "S":U THEN c-sim ELSE c-nao.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-traduz-log DBOProgram 
FUNCTION fn-traduz-log RETURNS CHARACTER
  ( l-value AS LOGICAL ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-value AS CHARACTER NO-UNDO.

  ASSIGN c-value = c-sim WHEN l-value
         c-value = c-nao WHEN NOT l-value.
  
  RETURN c-value.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

