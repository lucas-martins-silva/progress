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
**********************************************************************************/
{include/i-prgvrs.i BOIN767C 2.00.01.060 } /*** "010160" 12/08/2026 12:02:40 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i boin767c MUT}
&ENDIF


/*:T--------------------------------------------------------------------------
    File       : BOIN767C.P
    Purpose    : Aprovacoes de documentos MLA
    Parameters : 
    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*:T--- Diretrizes de definiá∆o ---*/
&GLOBAL-DEFINE DBOName boin767c
&GLOBAL-DEFINE DBOVersion 
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName mla-doc-pend-aprov
&GLOBAL-DEFINE TableLabel 
&GLOBAL-DEFINE QueryName qr{&TableName} 

&GLOBAL-DEFINE excludeFrameDefinition YES

{include/i_dbvers.i} /* PrÇ processedaores com a vers∆o do produto. Ex.: movind_version*/


/*:T--- Include com definiá∆o da temptable RowObject ---*/
{inbo/boin767.i RowObject}

/*:T--- Include com definiá∆o da query para tabela {&TableName} ---*/
{method/dboqry.i}

/*:T--- Definiá∆o de buffer que ser† utilizado pelo mÇtodo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.


{utp/ut-glob.i}  /* Variaveis e temp-tables globais Ex.: v_cod_usuar_corren, ttprog_dtsul */


/*--------------------------- Definiá∆o de Temp Table's Locais ---------------------------*/

{cdp/cd0666.i}       /* l-multi, l-del-erros, v-nom-arquivo-cb, c-mensagem-cb, tt-erro */
{inbo/boin767.i2}    /* tt-mla-chave */
{laphtml/mlahtml.i}  /* tt-html */
{utp/utapi019.i}     /* tt-envio, tt-envio2, tt-mensagem, tt-erros, h-utapi019 */
{cdp/cd1001.i}       /* tt_xml_input_1, tt_log_erros, v_sequencia, i-log-exec*/       

{include/i-epc200.i "boin767c"}            /* tt-epc, c-nom-prog-dpc-mg97, c-nom-prog-appc-mg97, c-nom-prog-upc-mg97, raw-rowObject */
{inbo/boin786.i tt-mla-usuar-aprov-altern} /* tt-mla-usuar-aprov-altern, tt-mla-alternativos-def */

/*---- Temp-Table's "Like" Tabela -----*/
{inbo/boin789.i "tt-mla-chave-doc"}      
{inbo/boin782.i "tt-mla-tipo-aprov-item"}
{inbo/boin781.i "tt-mla-tipo-aprov-fam"} 
{inbo/boin780.i "tt-mla-tipo-aprov-doc"} 

DEFINE TEMP-TABLE tt{&TableName} NO-UNDO
    LIKE {&TableName}
    FIELD rrowid AS ROWID.

{inbo/boin767c.i}

/*-------------------------- Definiá∆o de Vari†veis Locais -------------------------------*/
{inbo/boin767c.i1}
DEFINE VARIABLE de-valor-baixa   LIKE mla-doc-pend-aprov.valor-doc           NO-UNDO.
DEFINE VARIABLE de-valor-doc-ant LIKE mla-doc-pend-aprov.valor-doc INITIAL 0 NO-UNDO.

/*-------------------------- Definiá∆o de Vari†veis Globais ------------------------------*/
DEFINE NEW GLOBAL SHARED VAR gi-prox-prior                 AS INTEGER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gc-mla-cod-usuar              AS CHARACTER FORMAT "x(16)":U.
DEFINE NEW GLOBAL SHARED VAR gi-mla-cod-rejeicao           AS INTEGER.
DEFINE NEW GLOBAL SHARED VAR gc-mla-narrativa              AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR gc-mla-senha                  AS CHARACTER FORMAT "x(32)":U.
DEFINE NEW GLOBAL SHARED VAR gi-mla-origem                 AS INTEGER.
DEFINE NEW GLOBAL SHARED VAR gc-mla-notifica               AS CHARACTER.
DEFINE NEW GLOBAL SHARED VAR gr-mla-rowid-pend             AS ROWID.
DEFINE NEW GLOBAL SHARED VAR gl-mla-gera-proxima           AS LOGICAL.
DEFINE NEW GLOBAL SHARED VAR gde-mla-limite                AS DECIMAL.
DEFINE NEW GLOBAL SHARED VAR gi-mla-prox-prior             AS INTEGER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gl-mla-email-faixa-hierarquia AS LOGICAL.
DEFINE NEW GLOBAL SHARED VAR gl-mla-auto-aprovador         AS LOGICAL.
DEFINE NEW GLOBAL SHARED VAR c-seg-usuario                 AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gc-mla-dominioSO              AS CHARACTER NO-UNDO.
DEFINE NEW GLOBAL SHARED VAR gc-mla-usuarioSO              AS CHARACTER NO-UNDO.

/*-------------------------- Definiá∆o de Buffer's ---------------------------------------*/
DEFINE BUFFER b-mla-doc-pend-aprov  FOR mla-doc-pend-aprov.
DEFINE BUFFER b2-mla-doc-pend-aprov FOR mla-doc-pend-aprov.
DEFINE BUFFER b-mla-chave-doc-aprov FOR mla-chave-doc-aprov.
DEFINE BUFFER b-mla-usuar-aprov     FOR mla-usuar-aprov.
DEFINE BUFFER btt-mla-chave-doc     FOR tt-mla-chave-doc.


/*-------------------------- Boot de Temp Table's e Vari†veis ----------------------------*/

{inbo/boin789.i1} /* Criacao da tt-mla-chave-doc */

{utp/ut-liter.i "Chave_doc" *}
ASSIGN c-chave-mla-aux = RETURN-VALUE.


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
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 20.96
         WIDTH              = 38.29.
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **************************  Internal Procedures  ************************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyBO DBOProgram 
PROCEDURE destroyBO :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF VALID-HANDLE(hmla-emails)             THEN DELETE PROCEDURE hmla-emails.
    IF VALID-HANDLE(hmla-doc-pend-aprov)     THEN DELETE PROCEDURE hmla-doc-pend-aprov.
    IF VALID-HANDLE(hmla-doc-pend-verif)     THEN DELETE PROCEDURE hmla-doc-pend-verif.
    IF VALID-HANDLE(hmla-doc-sit)            THEN DELETE PROCEDURE hmla-doc-sit.
    IF VALID-HANDLE(hmla-param-aprov)        THEN DELETE PROCEDURE hmla-param-aprov.
    IF VALID-HANDLE(hmla-tipo-doc-aprov)     THEN DELETE PROCEDURE hmla-tipo-doc-aprov.
    IF VALID-HANDLE(hmla-chave-doc)          THEN DELETE PROCEDURE hmla-chave-doc.
    IF VALID-HANDLE(hmla-usuar-aprov)        THEN DELETE PROCEDURE hmla-usuar-aprov.
    IF VALID-HANDLE(hmla-perm-aprov)         THEN DELETE PROCEDURE hmla-perm-aprov.
    IF VALID-HANDLE(hmla-verba-aprov)        THEN DELETE PROCEDURE hmla-verba-aprov.
    IF VALID-HANDLE(hmla-usuar-aprov-altern) THEN DELETE PROCEDURE hmla-usuar-aprov-altern.
    IF VALID-HANDLE(hmla-tipo-aprov)         THEN DELETE PROCEDURE hmla-tipo-aprov.
    IF VALID-HANDLE(hmla-tipo-aprov-item)    THEN DELETE PROCEDURE hmla-tipo-aprov-item.
    IF VALID-HANDLE(hmla-tipo-aprov-fam)     THEN DELETE PROCEDURE hmla-tipo-aprov-fam.
    IF VALID-HANDLE(hmla-tipo-aprov-doc)     THEN DELETE PROCEDURE hmla-tipo-aprov-doc.
    IF VALID-HANDLE(hmla-hierarquia-aprov)   THEN DELETE PROCEDURE hmla-hierarquia-aprov.
    IF VALID-HANDLE(hmla-hierarquia-faixa)   THEN DELETE PROCEDURE hmla-hierarquia-faixa.
    IF VALID-HANDLE(hmla-lim-aprov-fam)      THEN DELETE PROCEDURE hmla-lim-aprov-fam.
    IF VALID-HANDLE(hmla-rej-aprov)          THEN DELETE PROCEDURE hmla-rej-aprov.
    IF VALID-HANDLE(hmla-email-aprov)        THEN DELETE PROCEDURE hmla-email-aprov.
    IF VALID-HANDLE(hmla-perm-lotacao)       THEN DELETE PROCEDURE hmla-perm-lotacao.
    IF VALID-HANDLE(hmla-tipo-aprov-ref)     THEN DELETE PROCEDURE hmla-tipo-aprov-ref.
    IF VALID-HANDLE(h-metricasMLA)           THEN DELETE PROCEDURE h-metricasMLA.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE errorValidate DBOProgram 
PROCEDURE errorValidate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-cd-erro  AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-mensagem AS CHARACTER NO-UNDO.

    {utp/ut-liter.i p-mensagem}

    {method/svc/errors/inserr.i &ErrorNumber=STRING(p-cd-erro)
                                &ErrorType="EMS":U
                                &ErrorSubType="ERROR":U
                                &ErrorParameters=RETURN-VALUE}

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

    IF  NOT VALID-HANDLE(hmla-emails) THEN DO:
        RUN inbo/boin790.p PERSISTENT SET hmla-emails.
        /*run openQueryStatic in hmla-emails (input "Main").*/
    END.
    IF  NOT VALID-HANDLE(hmla-doc-pend-aprov) THEN DO:
        RUN inbo/boin767b.p PERSISTENT SET hmla-doc-pend-aprov.
        /*run openQueryStatic in hmla-doc-pend-aprov (input "Main").*/
    END.
    IF  NOT VALID-HANDLE(hmla-doc-pend-verif) THEN DO:
        RUN inbo/boin767a.p PERSISTENT SET hmla-doc-pend-verif.
        /*run openQueryStatic in hmla-doc-pend-verif (input "Main").*/
    END.
    IF  NOT VALID-HANDLE(hmla-doc-sit) THEN DO:
        RUN inbo/boin768.p PERSISTENT SET hmla-doc-sit.
        /*run openQueryStatic in hmla-doc-sit (input "Main").*/
    END.
    IF  NOT VALID-HANDLE(hmla-param-aprov) THEN DO:
        RUN inbo/boin773.p PERSISTENT SET hmla-param-aprov.    
        run openQueryStatic in hmla-param-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-doc-aprov) THEN DO:
        RUN inbo/boin784.p PERSISTENT SET hmla-tipo-doc-aprov.
        run openQueryStatic in hmla-tipo-doc-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-chave-doc) THEN DO:
        RUN inbo/boin789.p PERSISTENT SET hmla-chave-doc.
        run openQueryStatic in hmla-chave-doc (input "Main":U).
        RUN getFirst IN hmla-chave-doc.
        RUN getBatchRecords IN hmla-chave-doc (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-chave-doc).
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-aprov) THEN DO:
        RUN inbo/boin785.p PERSISTENT SET hmla-usuar-aprov.
        run openQueryStatic in hmla-usuar-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-perm-aprov) THEN DO:
        RUN inbo/boin774.p PERSISTENT SET hmla-perm-aprov.
        run openQueryStatic in hmla-perm-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-verba-aprov) THEN DO:
        RUN inbo/boin788.p PERSISTENT SET hmla-verba-aprov.
        run openQueryStatic in hmla-verba-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-usuar-aprov-altern) THEN DO:
        RUN inbo/boin786.p PERSISTENT SET hmla-usuar-aprov-altern.
        run openQueryStatic in hmla-usuar-aprov-altern (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov) THEN DO:
        RUN inbo/boin779.p PERSISTENT SET hmla-tipo-aprov.
        run openQueryStatic in hmla-tipo-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-rej-aprov) THEN DO:
        RUN inbo/boin778.p PERSISTENT SET hmla-rej-aprov.
        run openQueryStatic in hmla-rej-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov-item) THEN DO:
        RUN inbo/boin782.p PERSISTENT SET hmla-tipo-aprov-item.
        run openQueryStatic in hmla-tipo-aprov-item (input "Main":U).
        RUN getFirst IN hmla-tipo-aprov-item.
        RUN getBatchRecords IN hmla-tipo-aprov-item (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-item).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov-fam) THEN DO:
        RUN inbo/boin781.p PERSISTENT SET hmla-tipo-aprov-fam.
        run openQueryStatic in hmla-tipo-aprov-fam (input "Main":U).
        RUN getFirst IN hmla-tipo-aprov-fam.
        RUN getBatchRecords IN hmla-tipo-aprov-fam (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-fam).
    END.
    IF  NOT VALID-HANDLE(hmla-tipo-aprov-doc) THEN DO:
        RUN inbo/boin780.p PERSISTENT SET hmla-tipo-aprov-doc.
        run openQueryStatic in hmla-tipo-aprov-doc (input "Main":U).
        RUN getFirst IN hmla-tipo-aprov-doc.
        RUN getBatchRecords IN hmla-tipo-aprov-doc (INPUT ?,
                                          INPUT NO,
                                          INPUT ?,
                                          OUTPUT iRowsReturned,
                                          OUTPUT TABLE tt-mla-tipo-aprov-doc).
    END.
    IF  NOT VALID-HANDLE(hmla-hierarquia-aprov) THEN DO:
        RUN inbo/boin792.p PERSISTENT SET hmla-hierarquia-aprov.
        run openQueryStatic in hmla-hierarquia-aprov (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-hierarquia-faixa) THEN DO:
        RUN inbo/boin793.p PERSISTENT SET hmla-hierarquia-faixa.
        run openQueryStatic in hmla-hierarquia-faixa (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-lim-aprov-fam) THEN DO:
        RUN inbo/boin794.p PERSISTENT SET hmla-lim-aprov-fam.
        run openQueryStatic in hmla-lim-aprov-fam (input "Main":U).
    END.
    IF  NOT VALID-HANDLE(hmla-email-aprov) THEN DO:
        RUN inbo/boin767c1.p PERSISTENT SET hmla-email-aprov.
        /*run openQueryStatic in hmla-email-aprov (input "Main").*/
    END.
    IF  NOT VALID-HANDLE(hmla-perm-lotacao) THEN DO:
        RUN inbo/boin775.p PERSISTENT SET hmla-perm-lotacao.
        run openQueryStatic in hmla-perm-lotacao (input "Main":U).
    END.

    IF NOT VALID-HANDLE(hmla-tipo-aprov-ref) THEN DO:
        RUN inbo/boin783.p PERSISTENT SET hmla-tipo-aprov-ref.
        run openQueryStatic in hmla-tipo-aprov-ref (input "Main":U).
    END.

    RUN initializeHandles IN hmla-email-aprov  (INPUT hmla-usuar-aprov,    
                                                INPUT hmla-tipo-doc-aprov,
                                                INPUT hmla-param-aprov,
                                                INPUT hmla-chave-doc).

    RUN initializeHandles IN hmla-doc-pend-verif  (INPUT hmla-usuar-aprov,   
                                                   INPUT hmla-tipo-doc-aprov,
                                                   INPUT hmla-param-aprov,   
                                                   INPUT hmla-chave-doc).     

     RUN initializeHandles IN hmla-doc-pend-aprov  (INPUT hmla-lim-aprov-fam,            
                                                    INPUT hmla-hierarquia-faixa,         
                                                    INPUT hmla-hierarquia-aprov,         
                                                    INPUT hmla-tipo-aprov,               
                                                    INPUT hmla-usuar-aprov-altern,       
                                                    INPUT hmla-verba-aprov,              
                                                    INPUT hmla-perm-aprov,               
                                                    INPUT hmla-usuar-aprov,              
                                                    INPUT hmla-tipo-doc-aprov,           
                                                    INPUT hmla-param-aprov,              
                                                    INPUT hmla-tipo-aprov-item,          
                                                    INPUT hmla-tipo-aprov-fam,           
                                                    INPUT hmla-tipo-aprov-doc,           
                                                    INPUT hmla-chave-doc).               

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

    RUN openQueryStatic (input "Main":U). 

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
        FOR EACH {&TABLENAME} NO-LOCK INDEXED-REPOSITION.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAprovViaPortal DBOFunction 
PROCEDURE setAprovViaPortal :
/*------------------------------------------------------------------------------
  Purpose: Seta que a aprovaá∆o foi realizada pelo Portal MLA
  Parameters: pl-via-portal (INPUT - Logical): Indica que a aprovaá∆o ocorreu pelo portal
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pl-via-portal AS LOGICAL NO-UNDO.  
    
    ASSIGN l-aprov-via-portal = pl-via-portal.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAnalysPend DBOProgram 
PROCEDURE setAnalysPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-cod-usuar    AS CHARACTER FORMAT "x(16)":U NO-UNDO.  
    DEFINE INPUT  PARAMETER p-cod-rejeicao AS INTEGER                    NO-UNDO.
    DEFINE INPUT  PARAMETER p-narrativa    AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER p-senha        AS CHARACTER FORMAT "x(32)":U NO-UNDO.
    DEFINE INPUT  PARAMETER p-dominioSO    AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER p-usuarioSO    AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER p-notif-trans  AS LOGICAL                    NO-UNDO.
    DEFINE INPUT  PARAMETER p-notif-docto  AS LOGICAL                    NO-UNDO.
    DEFINE INPUT  PARAMETER p-origem       AS INTEGER                    NO-UNDO.
    DEFINE INPUT  PARAMETER p-notifica     AS CHARACTER                  NO-UNDO.
    DEFINE INPUT  PARAMETER TABLE FOR tt-pendencia.
 
    ASSIGN gc-mla-cod-usuar    = p-cod-usuar
           gi-mla-cod-rejeicao = p-cod-rejeicao
           gc-mla-narrativa    = p-narrativa
           gc-mla-senha        = p-senha
           gi-mla-origem       = p-origem
           gc-mla-notifica     = p-notifica
           gc-mla-dominioSO    = p-dominioSO
           gc-mla-usuarioSO    = p-usuarioSO.

    FIND FIRST param-global NO-LOCK NO-ERROR.
    FIND FIRST tt-pendencia         NO-ERROR.

    IF NOT AVAILABLE tt-pendencia THEN DO:
        {method/svc/errors/inserr.i &ErrorNumber="28928"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="''"}
        RETURN "NOK":U.
    END.

    /* Ponto UPC */
    IF c-nom-prog-upc-mg97 <> "" THEN DO:    

        FOR EACH tt-epc
           WHERE tt-epc.cod-event = "beforeSetAnalysPend":U:
            DELETE tt-epc.
        END.
    
        {include/i-epc200.i2 &CodEvent='"beforeSetAnalysPend"'
                             &CodParameter='"handle_tt-pendencia"'
                             &ValueParameter="string(temp-table tt-pendencia:handle)"}
                             
        {include/i-epc201.i "beforeSetAnalysPend"}
    END.

    /* Narrativa n∆o pode conter mais de 152 caracteres */
    IF tt-pendencia.cod-tip-doc = 21 AND LENGTH(gc-mla-narrativa) > 152 THEN DO:

        {method/svc/errors/inserr.i &ErrorNumber="54471"
                                    &ErrorType="EMS":U                     
                                    &ErrorSubType="ERROR":U                
                                    &ErrorParameters="''"}       
                                             
        RETURN "NOK":U.                      
    END.  

    /* Preenche temp-table com usuˇrios alternativos a serem utilizados abaixo */
    IF  NOT VALID-HANDLE(hmla-usuar-aprov-altern) THEN DO:
        RUN inbo/boin786.p PERSISTENT SET hmla-usuar-aprov-altern.
        RUN openQueryStatic IN hmla-usuar-aprov-altern (INPUT "Main":U).
    END.

    RUN getAlternativos IN hmla-usuar-aprov-altern (INPUT tt-pendencia.cod-usuar,
                                                    OUTPUT TABLE tt-mla-alternativos-def). 

    /* Todos os pontos que faziam a leitura da mla-usuar-aprov para o usu†rio aprovador (gc-mla-cod-usuar) 
    utilizar∆o essa leitura realizada neste ponto, as demais leituras para a mla-usuar-aprov (para outros 
    usu†rios utilizam o buffer para n∆o desposicionar essa leitura */
    FOR FIRST mla-usuar-aprov FIELDS (cod-usuar e-mail envia-email recebe-email 
                                      nome-usuar usuar-mestre perm-aprov) 
        WHERE mla-usuar-aprov.cod-usuar = gc-mla-cod-usuar NO-LOCK: 
    END.

    IF NOT AVAIL mla-usuar-aprov THEN DO:
         {method/svc/errors/inserr.i &ErrorNumber="18553"
                                     &ErrorType="EMS":U
                                     &ErrorSubType="ERROR":U
                                     &ErrorParameters="gc-mla-cod-usuar + '~~~~' + 'MLA'"}
         RETURN "NOK":U.
    END.

    IF NOT VALID-HANDLE(h-utapi019) THEN DO:
        RUN utp/utapi019.p PERSISTENT SET h-utapi019.
    END.

    IF NOT VALID-HANDLE(h-mlaapi014) THEN DO:
        RUN lap/mlaapi014.p PERSISTENT SET h-mlaapi014.
    END.

    /* Inicia o handle da api de integraá∆o com Fluig apenas uma vez, melhorando a performance da integraá∆o. */
    RUN setHandleFluig IN h-mlaapi014.

    IF NOT VALID-HANDLE(h-metricasMLA) THEN 
        RUN lap/metricasMLA.p PERSISTENT SET h-metricasMLA.

    
    /**  Pendàncias
    **/
    EMPTY TEMP-TABLE RowErrors.
    EMPTY TEMP-TABLE RowErrorsAux.
    tt-pendencia:
    FOR EACH tt-pendencia:
        LOG-MANAGER:WRITE-MESSAGE (">>> Tp.Transacao: ":U + STRING(tt-pendencia.tipo-trans))          NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Documento   : ":U + STRING(tt-pendencia.cod-tip-doc))         NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Chave       : ":U + STRING(tt-pendencia.chave-doc))           NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Aprovador   : ":U + STRING(gc-mla-cod-usuar))                 NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Empresa     : ":U + STRING(tt-pendencia.ep-codigo))           NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Estabelec   : ":U + STRING(tt-pendencia.cod-estabel))         NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Nr_Trans    : ":U + STRING(tt-pendencia.nr-trans))            NO-ERROR.
        LOG-MANAGER:WRITE-MESSAGE (">>> Origem      : ":U + STRING(ENTRY(gi-mla-origem,"EMS,WEB":U))) NO-ERROR.

        FOR EACH RowErrors:
            CREATE RowErrorsAux.
            BUFFER-COPY RowErrors TO RowErrorsAux.
        END.
        EMPTY TEMP-TABLE RowErrors.

        /* Atualiza a vari†vel a cada pendància, pois ela pode ter sido modificada no processamento */
        ASSIGN l-mestre = mla-usuar-aprov.usuar-mestre.

        /* Verifica se j† foi utilizada a parametrizaá∆o para empresa/estabelecimento, pois se j† foi, n∆o Ç 
        necess†rio ler o banco de dados novamente, usa da temp-table */
        FIND FIRST tt-param-aprov 
             WHERE tt-param-aprov.ep-codigo   = tt-pendencia.ep-codigo
               AND tt-param-aprov.cod-estabel = tt-pendencia.cod-estabel NO-LOCK NO-ERROR. 

        IF NOT AVAIL tt-param-aprov THEN DO:
            FOR FIRST mla-param-aprov FIELDS (ep-codigo cod-estabel destino-verba log-exchange log-email 
                                              compl-email servidor-email porta-email log-email-altern log-1
                                              log-atachado char-1 log-aprovac-altern-dat log-integr-fluig cdn-rej)
                 WHERE mla-param-aprov.ep-codigo   = tt-pendencia.ep-codigo 
                   AND mla-param-aprov.cod-estabel = tt-pendencia.cod-estabel NO-LOCK: END.

            IF AVAIL mla-param-aprov THEN DO:
                CREATE tt-param-aprov.
                ASSIGN tt-param-aprov.ep-codigo                = mla-param-aprov.ep-codigo      
                       tt-param-aprov.cod-estabel              = mla-param-aprov.cod-estabel    
                       tt-param-aprov.destino-verba            = mla-param-aprov.destino-verba  
                       tt-param-aprov.log-exchange             = mla-param-aprov.log-exchange   
                       tt-param-aprov.log-email                = mla-param-aprov.log-email      
                       tt-param-aprov.compl-email              = mla-param-aprov.compl-email    
                       tt-param-aprov.servidor-email           = mla-param-aprov.servidor-email 
                       tt-param-aprov.porta-email              = mla-param-aprov.porta-email
                       tt-param-aprov.log-1                    = mla-param-aprov.log-1
                       tt-param-aprov.log-email-altern         = mla-param-aprov.log-email-altern
                       tt-param-aprov.log-atachado             = mla-param-aprov.log-atachado
                       tt-param-aprov.assume-perm-prin         = IF SUBSTRING(mla-param-aprov.char-1,3,1) = "S":U THEN YES ELSE NO
                       tt-param-aprov.assume-perm-lotacao-prin = IF SUBSTRING(mla-param-aprov.char-1,2,1) = "S":U THEN YES ELSE NO
                       tt-param-aprov.assume-perm-mestre-prin  = IF SUBSTRING(mla-param-aprov.char-1,4,1) = "S":U THEN YES ELSE NO
                       tt-param-aprov.log-aprovac-altern-dat   = mla-param-aprov.log-aprovac-altern-dat
                       tt-param-aprov.log-integr-fluig         = mla-param-aprov.log-integr-fluig
                       tt-param-aprov.cdn-rej                  = mla-param-aprov.cdn-rej.   
            END.
        END.

        IF NOT AVAIL tt-param-aprov THEN DO:
            IF c-lbl-liter-nao-exi-par-empr = "" THEN DO:
                {utp/ut-liter.i "N∆o_existe_parametrizaá∆o_Empresa/Estabelecimento" *}
                ASSIGN c-lbl-liter-nao-exi-par-empr = TRIM(RETURN-VALUE).
            END.
            
            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT tt-pendencia.cod-tip-doc,
                                                   INPUT tt-pendencia.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.

            {method/svc/errors/inserr.i &ErrorNumber="32504"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(tt-pendencia.cod-tip-doc) + c-chave-mla + '~~~~' + 
                                                          string(tt-pendencia.ep-codigo)  + '~~~~' + 
                                                          tt-pendencia.cod-estabel + '~~~~' + 
                                                          string(tt-pendencia.cod-tip-doc) + '~~~~' + 
                                                          c-lbl-liter-nao-exi-par-empr + ' ' "}
        END. 
        ELSE 
            ASSIGN i-param-destino-verba  = tt-param-aprov.destino-verba
                   l-param-log-exchange   = tt-param-aprov.log-exchange
                   l-param-log-email      = tt-param-aprov.log-email
                   c-param-compl-email    = tt-param-aprov.compl-email 
                   c-param-servidor-email = tt-param-aprov.servidor-email
                   i-param-porta-email    = tt-param-aprov.porta-email
                   gi-mla-cod-rejeicao    = tt-param-aprov.cdn-rej WHEN lUsaRejeicaoPadrao. /* quando usa o c¢digo de rejeiá∆o padr∆o, busca o valor da tabela de parÉmetros */

        FIND FIRST tt-mla-tipo-doc-aprov 
             WHERE tt-mla-tipo-doc-aprov.ep-codigo   = tt-pendencia.ep-codigo   
               AND tt-mla-tipo-doc-aprov.cod-estabel = tt-pendencia.cod-estabel 
               AND tt-mla-tipo-doc-aprov.cod-tip-doc = tt-pendencia.cod-tip-doc NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-mla-tipo-doc-aprov THEN DO:
            FOR FIRST mla-tipo-doc-aprov FIELDS(ep-codigo cod-estabel cod-tip-doc verba-aprov prog-aprova
                                                prog-rejeita prioridade-aprov des-tip-doc log-2 char-1 log-integr-fluig) 
                WHERE mla-tipo-doc-aprov.ep-codigo   = tt-pendencia.ep-codigo    
                  AND mla-tipo-doc-aprov.cod-estabel = tt-pendencia.cod-estabel
                  AND mla-tipo-doc-aprov.cod-tip-doc = tt-pendencia.cod-tip-doc NO-LOCK:
                CREATE tt-mla-tipo-doc-aprov.
                ASSIGN tt-mla-tipo-doc-aprov.ep-codigo        = mla-tipo-doc-aprov.ep-codigo        
                       tt-mla-tipo-doc-aprov.cod-estabel      = mla-tipo-doc-aprov.cod-estabel      
                       tt-mla-tipo-doc-aprov.cod-tip-doc      = mla-tipo-doc-aprov.cod-tip-doc      
                       tt-mla-tipo-doc-aprov.verba-aprov      = mla-tipo-doc-aprov.verba-aprov      
                       tt-mla-tipo-doc-aprov.prog-aprova      = mla-tipo-doc-aprov.prog-aprova      
                       tt-mla-tipo-doc-aprov.prog-rejeita     = mla-tipo-doc-aprov.prog-rejeita     
                       tt-mla-tipo-doc-aprov.prioridade-aprov = mla-tipo-doc-aprov.prioridade-aprov 
                       tt-mla-tipo-doc-aprov.des-tip-doc      = mla-tipo-doc-aprov.des-tip-doc      
                       tt-mla-tipo-doc-aprov.log-2            = mla-tipo-doc-aprov.log-2
                       tt-mla-tipo-doc-aprov.char-1           = mla-tipo-doc-aprov.char-1
                       tt-mla-tipo-doc-aprov.log-integr-fluig = mla-tipo-doc-aprov.log-integr-fluig.     
            END.  
        END.

        IF NOT AVAIL tt-mla-tipo-doc-aprov THEN DO:
            IF c-lbl-liter-nao-exi-par-empr-2 = "" THEN DO:
                {utp/ut-liter.i "N∆o_existe_parametrizaá∆o_Empresa_Estabeleciemnto_para_documento_movimentado" *}
                ASSIGN c-lbl-liter-nao-exi-par-empr-2 = TRIM(RETURN-VALUE).
            END.

            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT tt-pendencia.cod-tip-doc,
                                                   INPUT tt-pendencia.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.

            {method/svc/errors/inserr.i &ErrorNumber="32504"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(tt-pendencia.cod-tip-doc) + c-chave-mla + '~~~~' + 
                                                          STRING(tt-pendencia.ep-codigo)  + '~~~~' + 
                                                          tt-pendencia.cod-estabel + '~~~~' + 
                                                          STRING(tt-pendencia.cod-tip-doc) + '~~~~' + 
                                                          c-lbl-liter-nao-exi-par-empr-2 + ' ' "}
        END.
        ELSE 
            ASSIGN l-tipo-doc-verba-aprov  = tt-mla-tipo-doc-aprov.verba-aprov
                   c-tipo-doc-prog-aprova  = tt-mla-tipo-doc-aprov.prog-aprova
                   c-tipo-doc-prog-rejeita = tt-mla-tipo-doc-aprov.prog-rejeita
                   i-prioridade-aprov      = tt-mla-tipo-doc-aprov.prioridade-aprov
                   c-tipo-doc-des-tip-doc  = tt-mla-tipo-doc-aprov.des-tip-doc
                   l-rej-log-1             = tt-mla-tipo-doc-aprov.log-2.          

        IF NOT AVAIL mla-usuar-aprov THEN DO:
            IF c-lbl-liter-usu-nao-cad-no-mla = "" THEN DO:
                {utp/ut-liter.i "Usu†rio_n∆o_cadastrado_no_MLA_(MLA0103)" *}
                ASSIGN c-lbl-liter-usu-nao-cad-no-mla = TRIM(RETURN-VALUE).
            END.

            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT tt-pendencia.cod-tip-doc,
                                                   INPUT tt-pendencia.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.

            {method/svc/errors/inserr.i &ErrorNumber="32504"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(tt-pendencia.cod-tip-doc) + c-chave-mla + '~~~~' + 
                                                          STRING(tt-pendencia.ep-codigo)  + '~~~~' + 
                                                          tt-pendencia.cod-estabel + '~~~~' + 
                                                          STRING(tt-pendencia.cod-tip-doc) + '~~~~' + 
                                                          c-lbl-liter-usu-nao-cad-no-mla + ' ' "}
        END.
        ELSE 
            IF NOT mla-usuar-aprov.perm-aprov THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="54656"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="mla-usuar-aprov.cod-usuar"}
            END.

        ASSIGN c-usuar-perm-aprov = "".

        /*Facilitador de parametrizaá∆o do MLA - Assume Permiss∆o de aprovaá∆o como Principal*/
        IF tt-param-aprov.assume-perm-prin AND gc-mla-cod-usuar <> tt-pendencia.cod-usuar THEN DO:

            FIND FIRST tt-mla-usuar-aprov-altern
                 WHERE tt-mla-usuar-aprov-altern.cod-usuar        = tt-pendencia.cod-usuar
                   AND tt-mla-usuar-aprov-altern.cod-usuar-altern = gc-mla-cod-usuar NO-ERROR. 
        
            IF NOT AVAIL tt-mla-usuar-aprov-altern THEN DO:
                FOR FIRST mla-usuar-aprov-altern FIELDS (cod-usuar cod-usuar-altern validade-ini validade-fim)
                     WHERE mla-usuar-aprov-altern.cod-usuar        = tt-pendencia.cod-usuar
                       AND mla-usuar-aprov-altern.cod-usuar-altern = gc-mla-cod-usuar NO-LOCK: 
                    CREATE tt-mla-usuar-aprov-altern.
                    ASSIGN tt-mla-usuar-aprov-altern.cod-usuar        = mla-usuar-aprov-altern.cod-usuar        
                           tt-mla-usuar-aprov-altern.cod-usuar-altern = mla-usuar-aprov-altern.cod-usuar-altern 
                           tt-mla-usuar-aprov-altern.validade-ini     = mla-usuar-aprov-altern.validade-ini     
                           tt-mla-usuar-aprov-altern.validade-fim     = mla-usuar-aprov-altern.validade-fim 
                           c-usuar-perm-aprov                         = tt-pendencia.cod-usuar.
                END.
            END.
            ELSE
                ASSIGN c-usuar-perm-aprov = tt-pendencia.cod-usuar.
        END.
        IF c-usuar-perm-aprov = "" THEN
            ASSIGN c-usuar-perm-aprov = gc-mla-cod-usuar.

        FIND FIRST tt-mla-perm-aprov NO-LOCK
             WHERE tt-mla-perm-aprov.ep-codigo   = tt-pendencia.ep-codigo 
               AND tt-mla-perm-aprov.cod-estabel = tt-pendencia.cod-estabel 
               AND tt-mla-perm-aprov.cod-usuar   = c-usuar-perm-aprov       
               AND tt-mla-perm-aprov.cod-tip-doc = tt-pendencia.cod-tip-doc  NO-ERROR.

        IF NOT AVAIL tt-mla-perm-aprov THEN DO:
            FOR FIRST mla-perm-aprov FIELDS (ep-codigo cod-estabel cod-usuar cod-tip-doc limite-aprov validade-ini validade-fim)
                 WHERE mla-perm-aprov.ep-codigo   = tt-pendencia.ep-codigo 
                   AND mla-perm-aprov.cod-estabel = tt-pendencia.cod-estabel 
                   AND mla-perm-aprov.cod-usuar   = c-usuar-perm-aprov       
                   AND mla-perm-aprov.cod-tip-doc = tt-pendencia.cod-tip-doc  NO-LOCK:

                CREATE tt-mla-perm-aprov.
                ASSIGN tt-mla-perm-aprov.ep-codigo    = mla-perm-aprov.ep-codigo     
                       tt-mla-perm-aprov.cod-estabel  = mla-perm-aprov.cod-estabel   
                       tt-mla-perm-aprov.cod-usuar    = mla-perm-aprov.cod-usuar     
                       tt-mla-perm-aprov.cod-tip-doc  = mla-perm-aprov.cod-tip-doc   
                       tt-mla-perm-aprov.limite-aprov = mla-perm-aprov.limite-aprov  
                       tt-mla-perm-aprov.validade-ini = mla-perm-aprov.validade-ini  
                       tt-mla-perm-aprov.validade-fim = mla-perm-aprov.validade-fim.  
            END.
        END.

        IF NOT AVAIL tt-mla-perm-aprov THEN DO:
            IF c-lbl-liter-usu-sem-per-mov = "" THEN DO:
                {utp/ut-liter.i "Usu†rio_sem_permiss∆o_para_movimentar_o_documento" *}
                ASSIGN c-lbl-liter-usu-sem-per-mov = TRIM(RETURN-VALUE).
            END.

            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT tt-pendencia.cod-tip-doc,
                                                   INPUT tt-pendencia.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.

            {method/svc/errors/inserr.i &ErrorNumber="32504"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(tt-pendencia.cod-tip-doc) + c-chave-mla + '~~~~' + 
                                                          STRING(tt-pendencia.ep-codigo)  + '~~~~' + 
                                                          tt-pendencia.cod-estabel + '~~~~' + 
                                                          STRING(tt-pendencia.cod-tip-doc) + '~~~~' + 
                                                          c-lbl-liter-usu-sem-per-mov + ' ' "}
        END. 
        ELSE 
            ASSIGN l-limite-aprov = YES.

        /* Alternativo assume permiss∆o de mestre do principal */
        IF NOT l-mestre AND tt-param-aprov.assume-perm-mestre-prin THEN DO:
            
            IF NOT VALID-HANDLE(hmla-usuar-aprov) THEN DO:
                RUN inbo/boin785.p PERSISTENT SET hmla-usuar-aprov.
                RUN openQueryStatic IN hmla-usuar-aprov (INPUT "Main":U).
            END.


            IF tt-param-aprov.log-aprovac-altern-dat THEN DO:
                
                FOR EACH tt-mla-alternativos-def
                   WHERE tt-mla-alternativos-def.da-inicial <= tt-pendencia.dt-geracao
                     AND tt-mla-alternativos-def.da-final   >= tt-pendencia.dt-geracao:

                    RUN goToKey IN hmla-usuar-aprov (INPUT tt-pendencia.cod-usuar).
                    RUN getUsuarioMestre IN hmla-usuar-aprov.

                    /* Se o usu†rio para o qual ele Ç alternativo Ç mestre  */
                    IF RETURN-VALUE = "OK":U THEN DO:
                        ASSIGN l-mestre = YES.
                        LEAVE.
                    END.
                END.
            END.
            ELSE DO:
                FOR EACH tt-mla-alternativos-def
                   WHERE tt-mla-alternativos-def.da-inicial <= TODAY
                     AND tt-mla-alternativos-def.da-final   >= TODAY:

                    RUN goToKey IN hmla-usuar-aprov (INPUT tt-pendencia.cod-usuar).
                    RUN getUsuarioMestre IN hmla-usuar-aprov.

                    /* Se o usu†rio para o qual ele Ç alternativo Ç mestre  */
                    IF RETURN-VALUE = "OK":U THEN DO:
                        ASSIGN l-mestre = YES.
                        LEAVE.
                    END.
                END.
            END.
        END.

        ASSIGN c-usuar-limite       = ''               
               c-usuar-perm-lotacao = ''. 

        IF AVAIL tt-param-aprov THEN DO:
            /* Caso esteja parametrizado para assumir o limite ou lotaá∆o do principal */
            IF tt-param-aprov.log-1 OR tt-param-aprov.assume-perm-lotacao-prin THEN DO:

                FIND FIRST tt-mla-usuar-aprov-altern
                     WHERE tt-mla-usuar-aprov-altern.cod-usuar        = tt-pendencia.cod-usuar
                       AND tt-mla-usuar-aprov-altern.cod-usuar-altern = gc-mla-cod-usuar NO-ERROR. 
            
                IF NOT AVAIL tt-mla-usuar-aprov-altern THEN DO:
                    FOR FIRST mla-usuar-aprov-altern FIELDS (cod-usuar cod-usuar-altern validade-ini validade-fim)
                         WHERE mla-usuar-aprov-altern.cod-usuar        = tt-pendencia.cod-usuar
                           AND mla-usuar-aprov-altern.cod-usuar-altern = gc-mla-cod-usuar NO-LOCK: 
                        CREATE tt-mla-usuar-aprov-altern.
                        ASSIGN tt-mla-usuar-aprov-altern.cod-usuar        = mla-usuar-aprov-altern.cod-usuar        
                               tt-mla-usuar-aprov-altern.cod-usuar-altern = mla-usuar-aprov-altern.cod-usuar-altern 
                               tt-mla-usuar-aprov-altern.validade-ini     = mla-usuar-aprov-altern.validade-ini     
                               tt-mla-usuar-aprov-altern.validade-fim     = mla-usuar-aprov-altern.validade-fim.
                    END.
                END.
            END.

            /* Usa Limite de aprovaá∆o principal */
            IF tt-param-aprov.log-1 THEN DO:
                IF AVAIL tt-mla-usuar-aprov-altern THEN 
                    ASSIGN c-usuar-limite = tt-pendencia.cod-usuar.
            END.             
            /* Assume lotaá‰es do usu†rio principal */
            IF tt-param-aprov.assume-perm-lotacao-prin THEN DO:
                IF AVAIL tt-mla-usuar-aprov-altern THEN                           
                    ASSIGN c-usuar-perm-lotacao = tt-pendencia.cod-usuar.
            END.
        END.
        IF c-usuar-limite = '' THEN
            ASSIGN c-usuar-limite = gc-mla-cod-usuar.
        IF c-usuar-perm-lotacao = ""  THEN
            ASSIGN c-usuar-perm-lotacao = gc-mla-cod-usuar.

        /**  (B) Procura pendància  
        **/
        RUN setProcuraPend IN THIS-PROCEDURE (OUTPUT i-cod-erro, OUTPUT c-desc-erro).

        IF  RETURN-VALUE = "NOK":U THEN DO:
            LOG-MANAGER:WRITE-MESSAGE (">>> Erro: ":U + STRING(i-cod-erro)) NO-ERROR.
            ASSIGN tt-pendencia.cod-erro  = i-cod-erro
                   tt-pendencia.desc-erro = c-desc-erro.

            FIND FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-ERROR.
            IF AVAIL RowErrors THEN
                NEXT.
        END.

        ASSIGN tt-pendencia.rowid-pend = tt-pendencia.rowid-pend
               gr-mla-rowid-pend       = tt-pendencia.rowid-pend.  

        RUN setConsistPend IN THIS-PROCEDURE (OUTPUT i-cod-erro, OUTPUT c-desc-erro).
        IF i-cod-erro = 15540 THEN
            RETURN "NOK".
        
        FIND FIRST mla-doc-pend-aprov 
             WHERE  ROWID(mla-doc-pend-aprov) = tt-pendencia.rowid-pend  NO-LOCK NO-ERROR.
        
        /**  (C) (D) Consistàncias  
        **/
        IF  RETURN-VALUE = "NOK":U THEN DO:
            LOG-MANAGER:WRITE-MESSAGE (">>> Erro: ":U + STRING(i-cod-erro)) NO-ERROR.
            ASSIGN tt-pendencia.cod-erro  = i-cod-erro
                   tt-pendencia.desc-erro = c-desc-erro.

            FIND FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-ERROR.
            IF AVAIL RowErrors THEN
                NEXT.
        END.
        
        /**  (G) Baixa Verba do Aprovador  
        **/
        RUN setBaixaVerba IN THIS-PROCEDURE.

        FIND FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U NO-ERROR.
        IF AVAIL RowErrors THEN
            NEXT.

        tt-block:
        DO TRANSACTION ON ERROR UNDO, NEXT:

            ASSIGN iNrTransacaoAux = 0. /* vari†vel auxiliar que guarda o n£mero da transaá∆o que deve gerar uma solicitaá∆o no fluig */

            /**  (E) Seta Campos  
            **/
            RUN setAssignPend IN THIS-PROCEDURE.        
    
            IF RETURN-VALUE = "NOK":U THEN
                UNDO tt-block.
    
            /**  (F) Gera Novas Pendàncias  
            **/
            RUN setGeraPend IN THIS-PROCEDURE.

            IF RETURN-VALUE = "NOK" THEN
                UNDO tt-block.

            /* Ponto UPC */
            IF c-nom-prog-dpc-mg97  <> "" 
            OR c-nom-prog-appc-mg97 <> ""
            OR c-nom-prog-upc-mg97  <> "" THEN DO: 

                EMPTY TEMP-TABLE tt-epc.

                /*rowid da tabela mla-doc-pend-aprov*/
                {include/i-epc200.i2 &CodEvent='"afterSetGeraPend"'
                                     &CodParameter='"TABLE-ROWID"'
                                     &ValueParameter="string(rowid(mla-doc-pend-aprov))"}
                                     
                {include/i-epc201.i "afterSetGeraPend"}
           
                IF  RETURN-VALUE = 'NOK':U THEN DO:
                    UNDO tt-block.                  
                END.
            END.
    
            IF mla-doc-pend-aprov.cod-tip-doc = 24
            OR mla-doc-pend-aprov.cod-tip-doc = 25
            OR mla-doc-pend-aprov.cod-tip-doc = 26
            OR mla-doc-pend-aprov.cod-tip-doc = 28 THEN DO:
                
                /**  (I) Seta outros Campos  
                **/
                RUN setAssignFields IN THIS-PROCEDURE.
                /**  (J) Executa Programa  
                **/
                ASSIGN v_log_erro = NO.
                RUN setExecuteProg IN THIS-PROCEDURE (OUTPUT i-cod-erro).

                IF  RETURN-VALUE = "NOK":U THEN DO:
                    LOG-MANAGER:WRITE-MESSAGE (">>> Erro: ":U + STRING(i-cod-erro)) NO-ERROR. 
                    ASSIGN tt-pendencia.cod-erro  = i-cod-erro
                           tt-pendencia.desc-erro = "".
                    ASSIGN v_log_erro = YES.
                    UNDO tt-block, NEXT tt-pendencia.
                END.
    
                IF v_log_erro AND i-cod-erro <> 0 THEN DO:
                    
                    FOR FIRST mla-doc-pend-aprov FIELDS (dt-aprova narrativa-apr dt-rejeita narrativa-rej
                                                         cod-rejeicao dt-reaprova ind-situacao cod-usuar-altern 
                                                         char-1)
                         WHERE ROWID(mla-doc-pend-aprov) = gr-mla-rowid-pend EXCLUSIVE-LOCK: END. 
                    CASE mla-doc-pend-aprov.ind-situacao:
                        WHEN 2 THEN
                            ASSIGN mla-doc-pend-aprov.dt-aprova     = ?
                                   mla-doc-pend-aprov.narrativa-apr = "".
                        WHEN 3 THEN 
                            ASSIGN mla-doc-pend-aprov.dt-rejeita    = ?
                                   mla-doc-pend-aprov.narrativa-rej = ""
                                   mla-doc-pend-aprov.cod-rejeicao  = 0.
                        WHEN 4 THEN 
                            ASSIGN mla-doc-pend-aprov.dt-reaprova   = ?
                                   mla-doc-pend-aprov.narrativa-apr = "".
                    END CASE.

                    ASSIGN mla-doc-pend-aprov.ind-situacao        = i-situacao-ant
                           mla-doc-pend-aprov.cod-usuar-altern    = ""
                           OVERLAY(mla-doc-pend-aprov.char-1,1,8) = "".

                    RELEASE mla-doc-pend-aprov.

                    FIND FIRST mla-doc-pend-aprov 
                         WHERE ROWID(mla-doc-pend-aprov) = gr-mla-rowid-pend NO-LOCK NO-ERROR.
                END.
                    
                /**  (H) Notifica Usu†rios  
                **/
                IF NOT gl-mla-gera-proxima THEN DO:
                    RUN setNotificaUsuar IN THIS-PROCEDURE.
                END.
                       
                /**  (K) E-mail Alternativo  
                **/
                RUN setEmailAltern IN THIS-PROCEDURE.
        
                /** (L) Re-an†lise das Pendàncias  
                **/
                RUN setReanalisePend IN THIS-PROCEDURE.
            END.
    
            ELSE DO:
                IF mla-doc-pend-aprov.cod-tip-doc = 5 /* cotaá∆o */ THEN DO:
                    RUN pi-bgc-cotacao.
                    IF RETURN-VALUE = "NOK":U THEN DO:
                        UNDO tt-block, NEXT. 
                    END.
                END.
                
                /**  (I) Seta outros Campos  
                **/
                RUN setAssignFields IN THIS-PROCEDURE.
                /**  (J) Executa Programa  
                **/
          
                RUN setExecuteProg IN THIS-PROCEDURE (OUTPUT i-cod-erro).

                IF  RETURN-VALUE = "NOK":U THEN DO:
                    LOG-MANAGER:WRITE-MESSAGE (">>> Erro: ":U + STRING(i-cod-erro)) NO-ERROR. 
                    ASSIGN tt-pendencia.cod-erro  = i-cod-erro
                           tt-pendencia.desc-erro = "".

                    UNDO tt-block, NEXT tt-pendencia.
                END.
                /**  (H) Notifica Usu†rios  
                **/
                RUN setNotificaUsuar IN THIS-PROCEDURE.

                /**  (K) E-mail Alternativo  
                **/
                RUN setEmailAltern IN THIS-PROCEDURE.
        
                /** (L) Re-an†lise das Pendàncias  
                **/
                RUN setReanalisePend IN THIS-PROCEDURE.
            END.

            /*************************************************************************/
            /******************** INICIO - INTEGRAÄ«O COM O FLUIG ********************/
            /*************************************************************************/
            /** Verifica se a execuá∆o est† sendo feita por uma chamada do Fluig - (a mlaapi014 s¢ Ç chamada pelo fluig) **/
            ASSIGN i-nivel = 1.
            REPEAT WHILE PROGRAM-NAME(i-nivel) <> ?:
                IF PROGRAM-NAME(i-nivel) MATCHES "*mlaapi014*":U THEN DO:
                    ASSIGN l-exec-fluig = YES.
                    LEAVE.
                END.
                ASSIGN i-nivel = i-nivel + 1.
            END.
    
            /* S¢ executa essa l¢gica se o documento estiver parametrizado para integrar com o Fluig */
            IF tt-mla-tipo-doc-aprov.log-integr-fluig AND tt-param-aprov.log-integr-fluig THEN DO:
                /* Quando a execuá∆o Ç chamada pelo fluig n∆o precisa movimentar o Workflow, o Fluig faz isso. 
                   PorÇm, quando a execuá∆o Ç pelo progress/menu/portal, Ç necess†rio movimentar o workflow manualmente */
                IF NOT l-exec-fluig THEN DO:
                    CASE tt-pendencia.tipo-trans:
                        WHEN 1 THEN DO:
                            RUN changeStateFluig IN h-mlaapi014 (INPUT tt-pendencia.nr-trans,
                                                                 INPUT 6,
                                                                 OUTPUT TABLE RowErrorsAux2).
                            ASSIGN lErrorChangeStateFluig = (RETURN-VALUE = "NOK":U).
                        END.
                        WHEN 2 THEN DO:
                            RUN changeStateFluig IN h-mlaapi014 (INPUT tt-pendencia.nr-trans,
                                                                 INPUT 7,
                                                                 OUTPUT TABLE RowErrorsAux2).
                            ASSIGN lErrorChangeStateFluig = (RETURN-VALUE = "NOK":U).
                        END.
                    END CASE.
            
                    IF lErrorChangeStateFluig THEN DO:
                        RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 54790, INPUT "").
                        ASSIGN cErrorDescription = RETURN-VALUE.
                        RUN utp/ut-msgs.p(INPUT "help":U, INPUT 54790, INPUT "").
                        ASSIGN cErrorHelp = RETURN-VALUE.
                
                        IF NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = cErrorDescription + " - ":U + cErrorHelp.
                                   tt-erro.cd-erro  = 54790.
                
                            {method/svc/errors/inserr.i &ErrorNumber="54790"
                                                        &ErrorType="EMS":U
                                                        &ErrorSubType="WARNING":U
                                                        &ErrorParameters="''"}
                                                        
                            ASSIGN RowErrors.ErrorDescription = cErrorDescription
                                   RowErrors.ErrorHelp        = cErrorHelp.
                        END.
                    END.
                END.

                /* Geraá∆o das novas solictaá‰es Fluig, caso necess†rio */
                IF iNrTransacaoAux <> 0 THEN DO:
                    /* Inicia o handle da api de integraá∆o com Fluig apenas uma vez, melhorando a performance da integraá∆o. */
                    RUN setHandleFluig IN h-mlaapi014.
                    RUN startProcessFluig IN h-mlaapi014(INPUT iNrTransacaoAux,
                                                         OUTPUT iNrSolicFluig,
                                                         OUTPUT TABLE RowErrorsAux2).
                    IF CAN-FIND(FIRST RowErrorsAux) THEN DO:
                        RUN utp/ut-msgs.p(INPUT "msg":U, INPUT 54790, INPUT "").
                        ASSIGN cErrorDescription = return-value.
                        RUN utp/ut-msgs.p(INPUT "help":U, INPUT 54790, INPUT "").
                        ASSIGN cErrorHelp = return-value.
                
                        IF NOT CAN-FIND(FIRST tt-erro WHERE tt-erro.cd-erro = 54790) THEN DO:
                            CREATE tt-erro.
                            ASSIGN tt-erro.mensagem = cErrorDescription + " - ":U + cErrorHelp.
                                   tt-erro.cd-erro  = 54790.
                        END.
                    END.
                END.
            END. /* Fim - integraá∆o com o Fluig */
            
            ASSIGN l-aprovou-pendencia = YES.
    
            /* Atualizar detalhe da pendància e hist¢rico de aprovaá∆o do documento caso documento esteja integrado com o fluig */
            IF l-aprovou-pendencia THEN DO:
                IF AVAIL tt-param-aprov AND AVAIL tt-mla-tipo-doc-aprov AND tt-mla-tipo-doc-aprov.log-integr-fluig AND tt-param-aprov.log-integr-fluig THEN DO:
                    RUN gerarCopiaDetalhePendencia   IN h-mlaapi014 (INPUT tt-pendencia.nr-trans).
                    RUN gerarCopiaHistoricoDocumento IN h-mlaapi014 (INPUT tt-pendencia.nr-trans).
                END.
            END.
            /*************************************************************************/
            /********************* FIM - INTEGRAÄ«O COM O FLUIG **********************/
            /*************************************************************************/
        END. /*do trans*/

        IF NOT CAN-FIND(funcao WHERE funcao.cd-funcao = "spp-desabilita-metricas-mla" AND funcao.ativo) THEN DO:
            RUN approvalsTime IN h-metricasMLA (INPUT tt-pendencia.nr-trans). /* Gera metrica para o license service */
            RUN enviaMetrica  IN h-metricasMLA.
        END.

    END.  /*FOR-EACH tt-pendencia*/

    
    
    IF CAN-FIND(FIRST RowErrors) THEN DO:
        FOR EACH RowErrors:
            CREATE RowErrorsAux.
            BUFFER-COPY RowErrors TO RowErrorsAux.
        END.
    END.
    EMPTY TEMP-TABLE RowErrors.

    FOR EACH RowErrorsAux:
        CREATE RowErrors.
        BUFFER-COPY RowErrorsAux TO RowErrors.
    END.
    EMPTY TEMP-TABLE RowErrorsAux.

    IF gi-mla-origem <> 2 AND CAN-FIND(FIRST RowErrors) THEN DO:
        IF CAN-FIND(FIRST RowErrors) THEN DO:
            {method/showmessage.i1}
            /*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
            {method/showmessage.i2}
        END.
    END.

    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    IF VALID-HANDLE(h-utapi019) THEN DO:
        DELETE PROCEDURE h-utapi019.
        ASSIGN h-utapi019 = ?.
    END.

    /* Elimina o handle da api de integraá∆o com Fluig apenas uma vez, melhorando a performance da integraá∆o. */
    RUN unsetHandleFluig IN h-mlaapi014.

    IF VALID-HANDLE(h-mlaapi014) THEN DO:
        DELETE PROCEDURE h-mlaapi014.
        ASSIGN h-mlaapi014 = ?.
    END.

    IF  VALID-HANDLE(hmla-emails) THEN DO:
        DELETE PROCEDURE hmla-emails.
        ASSIGN hmla-emails = ?.
    END.
            

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAssignFields DBOProgram 
PROCEDURE setAssignFields :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DO TRANSACTION:

        IF mla-doc-pend-aprov.cod-tip-doc = 13 THEN DO: /*Contrato*/
            CASE tt-pendencia.tipo-trans:
                WHEN 1 THEN DO:
                    IF gl-mla-gera-proxima = NO THEN DO:
                        FOR FIRST mla-doc-sit FIELDS (ind-situacao)
                            WHERE mla-doc-sit.ep-codigo   = mla-doc-pend-aprov.ep-codigo
                              AND mla-doc-sit.cod-estabel = mla-doc-pend-aprov.cod-estabel
                              AND mla-doc-sit.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                              AND mla-doc-sit.chave-doc   = mla-doc-pend-aprov.chave-doc EXCLUSIVE-LOCK:
                            ASSIGN mla-doc-sit.ind-situacao = 3.
                        END.
                    END.
                END.
                WHEN 2 THEN DO:
                    IF gl-mla-gera-proxima = NO THEN DO:
                        FOR FIRST mla-doc-sit FIELDS (ind-situacao)
                            WHERE mla-doc-sit.ep-codigo   = mla-doc-pend-aprov.ep-codigo
                              AND mla-doc-sit.cod-estabel = mla-doc-pend-aprov.cod-estabel
                              AND mla-doc-sit.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                              AND mla-doc-sit.chave-doc   = mla-doc-pend-aprov.chave-doc EXCLUSIVE-LOCK:
                            ASSIGN mla-doc-sit.ind-situacao = 4.
                        END.
                    END.
                END.
                WHEN 3 THEN DO:
                    FOR FIRST mla-doc-sit FIELDS (ind-situacao)
                        WHERE mla-doc-sit.ep-codigo   = mla-doc-pend-aprov.ep-codigo
                          AND mla-doc-sit.cod-estabel = mla-doc-pend-aprov.cod-estabel
                          AND mla-doc-sit.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                          AND mla-doc-sit.chave-doc   = mla-doc-pend-aprov.chave-doc EXCLUSIVE-LOCK:
                        ASSIGN mla-doc-sit.ind-situacao = 3.
                    END.
                END.
            END CASE.
        END.

        IF gl-mla-email-faixa-hierarquia THEN
            RUN setEnviaEmail IN THIS-PROCEDURE (gc-mla-cod-usuar, gEmail-cod-usuar, 1).

        IF gl-mla-auto-aprovador THEN DO:

            RUN setGeraPendAprov IN THIS-PROCEDURE.

            IF gl-mla-email-faixa-hierarquia THEN 
                RUN setEnviaEmail IN THIS-PROCEDURE (gc-mla-cod-usuar, gEmail-cod-usuar, 1).

        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setAssignPend DBOProgram 
PROCEDURE setAssignPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF mla-doc-pend-aprov.ind-situacao <> 1 AND mla-doc-pend-aprov.ind-situacao <> 3 THEN DO:

        /*Emite mensagem: Documento &1. A operaá∆o n∆o pode ser executada pois o documento eest† &1.*/
        ASSIGN c-lbl-sit-desc = {ininc/i01in767.i 4 mla-doc-pend-aprov.ind-situacao}.

        {method/svc/errors/inserr.i &ErrorNumber="54879"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-lbl-sit-desc"}
        RETURN "NOK":U.
    END.
    
    ASSIGN gi-prox-prior  = mla-doc-pend-aprov.prioridade-aprov
           i-situacao-ant = mla-doc-pend-aprov.ind-situacao.

    FIND CURRENT mla-doc-pend-aprov EXCLUSIVE-LOCK NO-ERROR.

    CASE tt-pendencia.tipo-trans:
        WHEN 1 THEN DO:   
            ASSIGN mla-doc-pend-aprov.dt-aprova           = TODAY
                   mla-doc-pend-aprov.ind-situacao        = 2
                   mla-doc-pend-aprov.dec-1               = de-valor-doc-ant
                   mla-doc-pend-aprov.narrativa-apr       = gc-mla-narrativa.
            ASSIGN OVERLAY(mla-doc-pend-aprov.char-1,1,8) = STRING(TIME,"hh:mm:ss":U).                            

            IF gc-mla-cod-usuar <> mla-doc-pend-aprov.cod-usuar THEN 
                ASSIGN mla-doc-pend-aprov.cod-usuar-altern = gc-mla-cod-usuar.                   
        END.
        WHEN 2 THEN DO:
            ASSIGN mla-doc-pend-aprov.dt-rejeita          = TODAY
                   mla-doc-pend-aprov.ind-situacao        = 3
                   mla-doc-pend-aprov.dec-1               = de-valor-doc-ant
                   mla-doc-pend-aprov.narrativa-rej       = gc-mla-narrativa
                   mla-doc-pend-aprov.cod-rejeicao        = gi-mla-cod-rejeicao.
            ASSIGN OVERLAY(mla-doc-pend-aprov.char-1,9,8) = STRING(TIME,"hh:mm:ss":U).                            

            IF gc-mla-cod-usuar <> mla-doc-pend-aprov.cod-usuar THEN 
                ASSIGN mla-doc-pend-aprov.cod-usuar-altern = gc-mla-cod-usuar.                   
        END.
        WHEN 3 THEN DO:
            /*Verifica se integraá∆o com fluig est† ativa*/
            IF CAN-FIND (FIRST tt-param-aprov NO-LOCK
                         WHERE tt-param-aprov.ep-codigo        = mla-doc-pend-aprov.ep-codigo 
                           AND tt-param-aprov.cod-estabel      = mla-doc-pend-aprov.cod-estabel
                           AND tt-param-aprov.log-integr-fluig = YES) AND
               CAN-FIND (FIRST tt-mla-tipo-doc-aprov NO-LOCK
                         WHERE tt-mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo    
                           AND tt-mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel  
                           AND tt-mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                           AND tt-mla-tipo-doc-aprov.log-integr-fluig) AND
               (mla-doc-pend-aprov.cdn-workflow-fluig > 0 OR (mla-doc-pend-aprov.cdn-workflow-fluig = 0 AND 
                                                              CAN-FIND(FIRST mla-docto-pend-fluig 
                                                                       WHERE mla-docto-pend-fluig.nr-trans = mla-doc-pend-aprov.nr-trans))) THEN DO:
                /*Emite mensagem: Reaprovaá∆o n∆o permitida para pendàncias integradas com o Fluig*/
                {method/svc/errors/inserr.i &ErrorNumber="54860"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}

                RETURN "NOK":U.
            END.

            ASSIGN mla-doc-pend-aprov.dt-reaprova   = TODAY
                   mla-doc-pend-aprov.ind-situacao  = 4
                   mla-doc-pend-aprov.dec-1         = de-valor-doc-ant
                   mla-doc-pend-aprov.narrativa-apr = gc-mla-narrativa.

            ASSIGN OVERLAY(mla-doc-pend-aprov.char-1,17,8) = STRING(TIME,"hh:mm:ss":U).                            

            IF gc-mla-cod-usuar <> mla-doc-pend-aprov.cod-usuar THEN
                ASSIGN mla-doc-pend-aprov.cod-usuar-altern = gc-mla-cod-usuar.                   
        END.
    END CASE.

    RELEASE mla-doc-pend-aprov.

    FIND FIRST mla-doc-pend-aprov 
         WHERE ROWID(mla-doc-pend-aprov) = gr-mla-rowid-pend NO-LOCK NO-ERROR.      

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setBaixaVerba DBOProgram 
PROCEDURE setBaixaVerba :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>               
  Notes:       
------------------------------------------------------------------------------*/

    IF tt-pendencia.tipo-trans <> 2 THEN DO:

        IF l-tipo-doc-verba-aprov THEN DO TRANSACTION:

            IF  i-param-destino-verba = 1 THEN
                FIND FIRST mla-verba-aprov 
                    WHERE  mla-verba-aprov.ep-codigo    =  mla-doc-pend-aprov.ep-codigo   AND               
                           mla-verba-aprov.cod-estabel  =  mla-doc-pend-aprov.cod-estabel AND           
                           mla-verba-aprov.cod-usuar    =  mla-doc-pend-aprov.cod-usuar   AND               
                           mla-verba-aprov.cod-tip-doc  =  mla-doc-pend-aprov.cod-tip-doc AND           
                           mla-verba-aprov.periodo-ini <=  TODAY                          AND              
                           mla-verba-aprov.periodo-fim >=  TODAY                          EXCLUSIVE-LOCK NO-ERROR.
            ELSE
                FIND FIRST mla-verba-aprov 
                    WHERE  mla-verba-aprov.ep-codigo    =  mla-doc-pend-aprov.ep-codigo   AND               
                           mla-verba-aprov.cod-estabel  =  mla-doc-pend-aprov.cod-estabel AND           
                           mla-verba-aprov.cod-usuar    =  gc-mla-cod-usuar               AND               
                           mla-verba-aprov.cod-tip-doc  =  mla-doc-pend-aprov.cod-tip-doc AND           
                           mla-verba-aprov.periodo-ini <=  TODAY                          AND              
                           mla-verba-aprov.periodo-fim >=  TODAY                          EXCLUSIVE-LOCK NO-ERROR.
                
            IF AVAIL mla-verba-aprov THEN DO:
                /* Ponto UPC */
                EMPTY TEMP-TABLE tt-epc.
            
                IF c-nom-prog-dpc-mg97  <> "" 
                OR c-nom-prog-appc-mg97 <> ""
                OR c-nom-prog-upc-mg97  <> "" THEN DO: 

                    CREATE tt-epc.
                    ASSIGN tt-epc.cod-event     = "beforeDebitaVerba":U
                           tt-epc.cod-parameter = "rowid-pendencia":U
                           tt-epc.val-parameter = STRING(ROWID(mla-doc-pend-aprov)) + "/":U + STRING(THIS-PROCEDURE).
    
                    {include/i-epc201.i "beforeDebitaVerba"}

                    IF  RETURN-VALUE = 'NOK':U THEN DO:
                        RETURN "OK":U.                      
                    END.
                END.

                ASSIGN de-valor-baixa = mla-doc-pend-aprov.valor-doc.
                
                FOR LAST b-mla-doc-pend-aprov
                   WHERE b-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo
                     AND b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel
                     AND b-mla-doc-pend-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc
                     AND b-mla-doc-pend-aprov.chave-doc    = mla-doc-pend-aprov.chave-doc
                     AND b-mla-doc-pend-aprov.historico    = YES NO-LOCK:
                    
                    IF b-mla-doc-pend-aprov.ind-situacao = 2 /* aprovada */
                    OR b-mla-doc-pend-aprov.ind-situacao = 4 /* reaprovada */ THEN
                        ASSIGN de-valor-doc-ant = b-mla-doc-pend-aprov.valor-doc.
                    ELSE
                        ASSIGN de-valor-doc-ant = b-mla-doc-pend-aprov.dec-1.
                    
                    ASSIGN de-valor-baixa = de-valor-baixa - de-valor-doc-ant.
                END.
                
                IF mla-verba-aprov.valor-verba >= (mla-verba-aprov.verba-utilizada + de-valor-baixa) THEN DO: 
                    ASSIGN mla-verba-aprov.verba-utilizada = mla-verba-aprov.verba-utilizada + de-valor-baixa.
                    LOG-MANAGER:WRITE-MESSAGE (">>> Baixou Verba: ":U + STRING(de-valor-baixa,"->,>>>,>>>,>>>,>>9.99":U)) NO-ERROR.
                END.
                ELSE DO:
                    RUN pi-formata-chave IN THIS-PROCEDURE(INPUT mla-doc-pend-aprov.cod-tip-doc,
                                                           INPUT mla-doc-pend-aprov.chave-doc,
                                                           OUTPUT c-chave-mla-formatada).
                    ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.       
                    {method/svc/errors/inserr.i &ErrorNumber="54406"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="c-chave-mla"}
                END.
            END.
            ELSE DO:
                RUN pi-formata-chave IN THIS-PROCEDURE(INPUT mla-doc-pend-aprov.cod-tip-doc,
                                                       INPUT mla-doc-pend-aprov.chave-doc,
                                                       OUTPUT c-chave-mla-formatada).

                ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.       

                {method/svc/errors/inserr.i &ErrorNumber="54406"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-chave-mla"}
            END.
        END.
    END.
    ELSE DO:
        IF l-tipo-doc-verba-aprov THEN DO:
            
            ASSIGN de-valor-doc-ant = 0.
            
            FOR LAST b2-mla-doc-pend-aprov
               WHERE b2-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo
                 AND b2-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel
                 AND b2-mla-doc-pend-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc
                 AND b2-mla-doc-pend-aprov.chave-doc    = mla-doc-pend-aprov.chave-doc
                 AND b2-mla-doc-pend-aprov.historico    = YES NO-LOCK:

                IF b2-mla-doc-pend-aprov.ind-situacao = 2 /* aprovada */
                OR b2-mla-doc-pend-aprov.ind-situacao = 4 /* reaprovada */ THEN
                    ASSIGN de-valor-doc-ant = b2-mla-doc-pend-aprov.valor-doc.
                ELSE
                    ASSIGN de-valor-doc-ant = b2-mla-doc-pend-aprov.dec-1.
            END.
            
            FOR EACH b-mla-doc-pend-aprov
               WHERE b-mla-doc-pend-aprov.ep-codigo    = mla-doc-pend-aprov.ep-codigo
                 AND b-mla-doc-pend-aprov.cod-estabel  = mla-doc-pend-aprov.cod-estabel
                 AND b-mla-doc-pend-aprov.cod-tip-doc  = mla-doc-pend-aprov.cod-tip-doc
                 AND b-mla-doc-pend-aprov.chave-doc    = mla-doc-pend-aprov.chave-doc
                 AND b-mla-doc-pend-aprov.ind-situacao = 2 /* aprovada */
                 AND b-mla-doc-pend-aprov.historico    = NO NO-LOCK:

                ASSIGN de-valor-baixa =  b-mla-doc-pend-aprov.valor-doc - de-valor-doc-ant.

                IF i-param-destino-verba = 1 THEN DO: /* baixa verba do principal */
                    FIND FIRST mla-verba-aprov 
                         WHERE mla-verba-aprov.ep-codigo    =  b-mla-doc-pend-aprov.ep-codigo                  
                           AND mla-verba-aprov.cod-estabel  =  b-mla-doc-pend-aprov.cod-estabel            
                           AND mla-verba-aprov.cod-usuar    =  b-mla-doc-pend-aprov.cod-usuar                  
                           AND mla-verba-aprov.cod-tip-doc  =  b-mla-doc-pend-aprov.cod-tip-doc
                           AND mla-verba-aprov.periodo-ini <=  TODAY 
                           AND mla-verba-aprov.periodo-fim >=  TODAY EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL mla-verba-aprov THEN
                        ASSIGN mla-verba-aprov.verba-utilizada = mla-verba-aprov.verba-utilizada - de-valor-baixa.
                END.
                ELSE DO:
                    FIND FIRST mla-verba-aprov 
                         WHERE mla-verba-aprov.ep-codigo    =  b-mla-doc-pend-aprov.ep-codigo                  
                           AND mla-verba-aprov.cod-estabel  =  b-mla-doc-pend-aprov.cod-estabel            
                           AND mla-verba-aprov.cod-usuar    =  b-mla-doc-pend-aprov.cod-usuar-altern                  
                           AND mla-verba-aprov.cod-tip-doc  =  b-mla-doc-pend-aprov.cod-tip-doc 
                           AND mla-verba-aprov.periodo-ini <=  TODAY
                           AND mla-verba-aprov.periodo-fim >=  TODAY EXCLUSIVE-LOCK NO-ERROR.
                    IF AVAIL mla-verba-aprov THEN
                        ASSIGN mla-verba-aprov.verba-utilizada = mla-verba-aprov.verba-utilizada - de-valor-baixa.
                END.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConsistPend DBOProgram 
PROCEDURE setConsistPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-cod-erro   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-erro  AS CHARACTER NO-UNDO.

    {inbo/boin767c.i2}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEmailAltern DBOProgram 
PROCEDURE setEmailAltern :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF AVAIL tt-param-aprov AND tt-param-aprov.log-email-altern THEN DO:
        
        EMPTY TEMP-TABLE tt-mla-chave.
        CREATE tt-mla-chave.
        ASSIGN i-chave = 0.

        FOR EACH  tt-mla-chave-doc NO-LOCK
           WHERE tt-mla-chave-doc.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc :

            ASSIGN i-chave = i-chave + 1
                   tt-mla-chave.valor[i-chave] = SUBSTRING(mla-doc-pend-aprov.chave-doc,
                                                           tt-mla-chave-doc.posicao-ini,
                                                         ((tt-mla-chave-doc.posicao-fim -
                                                           tt-mla-chave-doc.posicao-ini) + 1)).
        END. 

        /* Para o portal do MLA ser† chamada a procedure da pr¢pria BO - Performance */
        IF gi-mla-origem <> 2 THEN DO:
            IF NOT VALID-HANDLE(hmla-emails) THEN
                RUN inbo/boin790.p PERSISTENT SET hmla-emails.
    
            /** Aprovaá∆o e Rejeiá∆o 
            **/
            RUN setEnviaEmailAltern IN hmla-emails ((tt-pendencia.tipo-trans + 1), 
                                                    gi-mla-origem,
                                                    gc-mla-cod-usuar,
                                                    gr-mla-rowid-pend,
                                                    INPUT TABLE tt-mla-chave).
    
            /** Documento 
            **/
            IF tt-pendencia.tipo-trans = 1 THEN
                RUN setEnviaEmailAltern IN hmla-emails (4, 
                                                        gi-mla-origem,
                                                        gc-mla-cod-usuar,
                                                        gr-mla-rowid-pend,
                                                        INPUT TABLE tt-mla-chave).
        END.
        ELSE DO:
             /** Aprovaá∆o e Rejeiá∆o 
            **/
            RUN setEnviaEmailAltern IN THIS-PROCEDURE ((tt-pendencia.tipo-trans + 1), 
                                                       gc-mla-cod-usuar,
                                                       gr-mla-rowid-pend).
    
            /** Documento 
            **/
            IF tt-pendencia.tipo-trans = 1 THEN
                RUN setEnviaEmailAltern IN THIS-PROCEDURE (4, 
                                                           gc-mla-cod-usuar,
                                                           gr-mla-rowid-pend).           
        END.
    END.

    RETURN "OK":U. 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmailAltern DBOProgram 
PROCEDURE setEnviaEmailAltern :
/*------------------------------------------------------------------------------
  Purpose: Procedure c¢pia da boin790 setEnviaEmailAltern, com adaptaá‰es    
  Parameters:  
  Notes: Necess†rio trazer para essa BO para evitar leituras duplicadas e 
  aproveitar registros j† posicionados (estava causando problema de performance 
  na aprovaá∆o em "lote") - especialmente do portal do MLA      
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-tipo-mov       AS INTEGER   NO-UNDO.
    DEFINE INPUT PARAMETER p-cod-aprovador  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-rowid-doc-pend AS ROWID     NO-UNDO.

    DEFINE VARIABLE l-log-email    AS LOGICAL     NO-UNDO.
    DEFINE VARIABLE c-prog-html    AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-titulo-email AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-texto-email  AS CHARACTER   NO-UNDO.

    DEFINE BUFFER b-mla-doc-pend-aprov-email-1  FOR mla-doc-pend-aprov.
    DEFINE BUFFER b-mla-doc-pend-aprov-email-2  FOR mla-doc-pend-aprov.

    FOR FIRST b-mla-doc-pend-aprov-email-1 FIELDS (ep-codigo cod-estabel cod-tip-doc chave-doc 
                                                   cod-usuar-doc cod-usuar-trans cod-usuar-altern 
                                                   cod-usuar valor-doc cod-rejeicao narrativa-rej 
                                                   narrativa-apr)
        WHERE ROWID(b-mla-doc-pend-aprov-email-1) = p-rowid-doc-pend NO-LOCK: END.

    FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = p-cod-aprovador NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-mla-usuar-aprov THEN DO:

        FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
            WHERE b-mla-usuar-aprov.cod-usuar = p-cod-aprovador NO-LOCK: 

            CREATE tt-mla-usuar-aprov.
            ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                   tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                   tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                   tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
        END. 
    END.

    FIND FIRST tt-mla-tipo-doc-aprov 
         WHERE tt-mla-tipo-doc-aprov.ep-codigo   = tt-pendencia.ep-codigo   
           AND tt-mla-tipo-doc-aprov.cod-estabel = tt-pendencia.cod-estabel 
           AND tt-mla-tipo-doc-aprov.cod-tip-doc = tt-pendencia.cod-tip-doc NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-mla-tipo-doc-aprov THEN DO:
        FOR FIRST mla-tipo-doc-aprov FIELDS(ep-codigo cod-estabel cod-tip-doc verba-aprov prog-aprova
                                            prog-rejeita prioridade-aprov des-tip-doc log-2 char-1 log-integr-fluig) 
            WHERE mla-tipo-doc-aprov.ep-codigo   = tt-pendencia.ep-codigo    
              AND mla-tipo-doc-aprov.cod-estabel = tt-pendencia.cod-estabel
              AND mla-tipo-doc-aprov.cod-tip-doc = tt-pendencia.cod-tip-doc NO-LOCK:
            CREATE tt-mla-tipo-doc-aprov.
            ASSIGN tt-mla-tipo-doc-aprov.ep-codigo        = mla-tipo-doc-aprov.ep-codigo        
                   tt-mla-tipo-doc-aprov.cod-estabel      = mla-tipo-doc-aprov.cod-estabel      
                   tt-mla-tipo-doc-aprov.cod-tip-doc      = mla-tipo-doc-aprov.cod-tip-doc      
                   tt-mla-tipo-doc-aprov.verba-aprov      = mla-tipo-doc-aprov.verba-aprov      
                   tt-mla-tipo-doc-aprov.prog-aprova      = mla-tipo-doc-aprov.prog-aprova      
                   tt-mla-tipo-doc-aprov.prog-rejeita     = mla-tipo-doc-aprov.prog-rejeita     
                   tt-mla-tipo-doc-aprov.prioridade-aprov = mla-tipo-doc-aprov.prioridade-aprov 
                   tt-mla-tipo-doc-aprov.des-tip-doc      = mla-tipo-doc-aprov.des-tip-doc      
                   tt-mla-tipo-doc-aprov.log-2            = mla-tipo-doc-aprov.log-2
                   tt-mla-tipo-doc-aprov.char-1           = mla-tipo-doc-aprov.char-1
                   tt-mla-tipo-doc-aprov.log-integr-fluig = mla-tipo-doc-aprov.log-integr-fluig.     
        END.  
    END.

    FIND FIRST tt-mla-rej-aprov WHERE tt-mla-rej-aprov.cod-rejeicao = gi-mla-cod-rejeicao NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-mla-rej-aprov THEN DO:
        FOR FIRST mla-rej-aprov FIELDS (cod-rejeicao des-rejeicao obriga-narrativa log-1)
             WHERE mla-rej-aprov.cod-rejeicao = gi-mla-cod-rejeicao NO-LOCK:
            CREATE tt-mla-rej-aprov.
            ASSIGN tt-mla-rej-aprov.cod-rejeicao     = mla-rej-aprov.cod-rejeicao       
                   tt-mla-rej-aprov.des-rejeicao     = mla-rej-aprov.des-rejeicao       
                   tt-mla-rej-aprov.obriga-narrativa = mla-rej-aprov.obriga-narrativa
                   tt-mla-rej-aprov.log-1            = mla-rej-aprov.log-1.  
        END.
    END.

    FOR EACH mla-emails 
       WHERE mla-emails.ep-codigo   = b-mla-doc-pend-aprov-email-1.ep-codigo   
         AND mla-emails.cod-estabel = b-mla-doc-pend-aprov-email-1.cod-estabel 
         AND mla-emails.cod-tip-doc = b-mla-doc-pend-aprov-email-1.cod-tip-doc NO-LOCK:

        CASE p-tipo-mov:
            WHEN 1 THEN
                ASSIGN l-log-email    = mla-emails.log-geracao
                       c-prog-html    = mla-emails.html-geracao
                       c-titulo-email = mla-emails.titulo-email-gera
                       c-texto-email  = mla-emails.texto-email-gera.
            WHEN 2 THEN
                ASSIGN l-log-email    = mla-emails.log-aprovacao
                       c-prog-html    = mla-emails.html-aprovacao
                       c-titulo-email = mla-emails.titulo-email-aprova
                       c-texto-email  = mla-emails.texto-email-aprova.
            WHEN 3 THEN
                ASSIGN l-log-email    = mla-emails.log-rejeicao
                       c-prog-html    = mla-emails.html-rejeicao
                       c-titulo-email = mla-emails.titulo-email-rej
                       c-texto-email  = mla-emails.texto-email-rej.
            WHEN 4 THEN
                ASSIGN l-log-email    = mla-emails.log-documento
                       c-prog-html    = mla-emails.html-documento
                       c-titulo-email = mla-emails.titulo-email-doc
                       c-texto-email  = mla-emails.texto-email-doc.
        END CASE.

        IF l-log-email THEN DO:
    
            IF p-tipo-mov = 4 THEN DO:

                /** Aprovaá∆o Documento 
                **/
                FIND FIRST b-mla-doc-pend-aprov-email-2 
                     WHERE b-mla-doc-pend-aprov-email-2.ep-codigo     = b-mla-doc-pend-aprov-email-1.ep-codigo   
                       AND b-mla-doc-pend-aprov-email-2.cod-estabel   = b-mla-doc-pend-aprov-email-1.cod-estabel 
                       AND b-mla-doc-pend-aprov-email-2.cod-tip-doc   = b-mla-doc-pend-aprov-email-1.cod-tip-doc 
                       AND b-mla-doc-pend-aprov-email-2.chave-doc     = b-mla-doc-pend-aprov-email-1.chave-doc   
                       AND (b-mla-doc-pend-aprov-email-2.ind-situacao = 1 OR b-mla-doc-pend-aprov-email-2.ind-situacao = 3) 
                       AND b-mla-doc-pend-aprov-email-2.historico     = NO NO-LOCK NO-ERROR.

                IF AVAILABLE b-mla-doc-pend-aprov-email-2 THEN
                    RETURN.
            END.
    
            IF  c-prog-html <> "" AND c-prog-html <> ?  THEN DO:

                EMPTY TEMP-TABLE tt-html.
                EMPTY TEMP-TABLE tt-mensagem.
                
                RUN VALUE("laphtml/":U + TRIM(c-prog-html)) (p-tipo-mov,
                                                             p-cod-aprovador,
                                                             INPUT  TABLE tt-mla-chave,
                                                             OUTPUT TABLE tt-html).
                                                           
                IF tt-param-aprov.log-exchange THEN DO:
                    OUTPUT TO VALUE(SESSION:TEMP-DIRECTORY + "/":U 
                                                           + REPLACE(p-cod-aprovador," ","_":U) + "_":U 
                                                           + STRING(b-mla-doc-pend-aprov-email-1.nr-trans) + "_":U 
                                                           + STRING(TIME) + ".htm":U) CONVERT TARGET "UTF-8":U APPEND.
                    FOR EACH tt-html :
                        PUT UNFORMATTED tt-html.html-doc SKIP.
                    END.
                    OUTPUT CLOSE.
                END.
                ELSE DO:
                    FOR EACH tt-html:
                        CREATE tt-mensagem.
                        ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
                               tt-mensagem.mensagem     = tt-html.html-doc.
                    END.
                END.
                
                EMPTY TEMP-TABLE tt-envio2.

                CREATE tt-envio2.
                ASSIGN tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = tt-param-aprov.log-exchange
                       tt-envio2.destino     = mla-emails.e-mail
                       tt-envio2.assunto     = c-titulo-email
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = NO
                       tt-envio2.log-lida    = NO
                       tt-envio2.acomp       = NO
                       tt-envio2.formato     = "HTML":U
                       tt-envio2.remetente   = tt-mla-usuar-aprov.e-mail.
    
                IF tt-param-aprov.log-exchange THEN DO:

                    IF c-lbl-liter-gera-pend-aprov = "" THEN DO:
                        {utp/ut-liter.i "Foi_gerada_uma_pendància_de_aprovaá∆o"}
                        ASSIGN c-lbl-liter-gera-pend-aprov = RETURN-VALUE.
                    END.
                    IF c-lbl-liter-arq-atachado = "" THEN DO:
                        {utp/ut-liter.i "Favor_verificar_o_arquivo_atachado"}
                        ASSIGN c-lbl-liter-arq-atachado = RETURN-VALUE.
                    END.
                
                    ASSIGN tt-envio2.mensagem    = c-lbl-liter-gera-pend-aprov + CHR(13) + c-lbl-liter-arq-atachado
                           tt-envio2.arq-anexo   = STRING(SESSION:TEMP-DIRECTORY)                + "/":U 
                                                 + REPLACE(p-cod-aprovador," ","_":U)            + "_":U 
                                                 + STRING(b-mla-doc-pend-aprov-email-1.nr-trans) + "_":U 
                                                 + STRING(TIME)                                  + ".htm":U.
                END.
                ELSE                           
                    ASSIGN tt-envio2.mensagem = c-texto-email.
    
                IF NOT tt-param-aprov.log-exchange THEN
                    ASSIGN tt-envio2.servidor = tt-param-aprov.servidor-email
                           tt-envio2.porta    = tt-param-aprov.porta-email.
                
                IF tt-param-aprov.log-exchange THEN
                    RUN pi-cria-tt-mensagem IN THIS-PROCEDURE(INPUT TABLE tt-envio2,
                                                              OUTPUT TABLE tt-mensagem).
                
                RUN pi-execute2 IN h-utapi019 (INPUT TABLE tt-envio2,                   
                                               INPUT TABLE tt-mensagem,
                                               OUTPUT TABLE tt-erros).                                                                           
    
                /**  Output do erro (e-mail)
                **/               
                FIND FIRST tt-envio2 NO-ERROR.
                {lap/mlaapi001.i02 "aed0130a.p (01)" tt-envio2.destino tt-envio2.remetente}                                    
                
                IF tt-param-aprov.log-exchange THEN
                    OS-DELETE value(SESSION:TEMP-DIRECTORY + "/":U 
                                                           + REPLACE(p-cod-aprovador," ","_":U) + "_":U 
                                                           + STRING(b-mla-doc-pend-aprov-email-1.nr-trans) + "_":U 
                                                           + STRING(TIME) + ".htm":U).
            END.
            ELSE DO:
                EMPTY TEMP-TABLE tt-envio.

                CREATE tt-envio.
                ASSIGN tt-envio.versao-integracao = 1
                       tt-envio.exchange          = tt-param-aprov.log-exchange
                       tt-envio.destino           = mla-emails.e-mail
                       tt-envio.assunto           = c-titulo-email
                       tt-envio.mensagem          = c-texto-email
                       tt-envio.importancia       = 2
                       tt-envio.log-enviada       = NO
                       tt-envio.log-lida          = NO
                       tt-envio.acomp             = NO
                       tt-envio.arq-anexo         = ""
                       tt-envio.remetente         = tt-mla-usuar-aprov.e-mail.
    
                IF NOT l-exchange THEN
                    ASSIGN tt-envio.servidor = tt-param-aprov.servidor-email
                           tt-envio.porta    = tt-param-aprov.porta-email.

                ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$01":U,STRING(b-mla-doc-pend-aprov-email-1.ep-codigo))
                       tt-envio.assunto = REPLACE(tt-envio.assunto,"$02":U,b-mla-doc-pend-aprov-email-1.cod-estabel)
                       tt-envio.assunto = REPLACE(tt-envio.assunto,"$03":U,b-mla-doc-pend-aprov-email-1.cod-usuar-doc)
                       tt-envio.assunto = REPLACE(tt-envio.assunto,"$04":U,b-mla-doc-pend-aprov-email-1.cod-usuar-trans).

                IF mla-doc-pend-aprov.cod-usuar-altern <> "" THEN
                    ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$05":U,b-mla-doc-pend-aprov-email-1.cod-usuar-altern).
                ELSE
                    ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$05":U,b-mla-doc-pend-aprov-email-1.cod-usuar).

                ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$06":U,STRING(b-mla-doc-pend-aprov-email-1.cod-tip-doc)).
                ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$07":U,tt-mla-tipo-doc-aprov.des-tip-doc).
                ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$08":U,STRING(b-mla-doc-pend-aprov-email-1.valor-doc))
                       tt-envio.assunto = REPLACE(tt-envio.assunto,"$09":U,STRING(b-mla-doc-pend-aprov-email-1.cod-rejeicao)).
                ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$10":U,IF AVAIL tt-mla-rej-aprov THEN tt-mla-rej-aprov.des-rejeicao ELSE "").
                ASSIGN tt-envio.assunto = REPLACE(tt-envio.assunto,"$11":U,b-mla-doc-pend-aprov-email-1.narrativa-rej)
                       tt-envio.assunto = REPLACE(tt-envio.assunto,"$12":U,b-mla-doc-pend-aprov-email-1.narrativa-apr)
                       tt-envio.assunto = REPLACE(tt-envio.assunto,"$13":U,b-mla-doc-pend-aprov-email-1.chave-doc).
    
                ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$01":U,STRING(b-mla-doc-pend-aprov-email-1.ep-codigo))
                       tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$02":U,b-mla-doc-pend-aprov-email-1.cod-estabel)
                       tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$03":U,b-mla-doc-pend-aprov-email-1.cod-usuar-doc)
                       tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$04":U,b-mla-doc-pend-aprov-email-1.cod-usuar-trans).

                IF mla-doc-pend-aprov.cod-usuar-altern <> "" THEN
                    ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$05":U,b-mla-doc-pend-aprov-email-1.cod-usuar-altern).
                ELSE
                    ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$05":U,b-mla-doc-pend-aprov-email-1.cod-usuar).

                ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$06":U,STRING(b-mla-doc-pend-aprov-email-1.cod-tip-doc)).
                ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$07":U,tt-mla-tipo-doc-aprov.des-tip-doc).
                ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$08":U,STRING(b-mla-doc-pend-aprov-email-1.valor-doc))
                       tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$09":U,STRING(b-mla-doc-pend-aprov-email-1.cod-rejeicao)).
                ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$10":U,IF AVAIL tt-mla-rej-aprov THEN tt-mla-rej-aprov.des-rejeicao ELSE "").
    
                ASSIGN tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$11":U,b-mla-doc-pend-aprov-email-1.narrativa-rej)
                       tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$12":U,b-mla-doc-pend-aprov-email-1.narrativa-apr)
                       tt-envio.mensagem = REPLACE(tt-envio.mensagem,"$13":U,b-mla-doc-pend-aprov-email-1.chave-doc).
                   
                RUN utp/utapi009.p (INPUT  TABLE tt-envio, OUTPUT TABLE tt-erros). 
                                    
                /**  Output do erro (e-mail)
                **/               
                FIND FIRST tt-envio NO-ERROR.
                {lap/mlaapi001.i02 "aed0130a.p (02)" tt-envio.destino tt-envio.remetente}
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setEnviaEmail DBOProgram 
PROCEDURE setEnviaEmail :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-usuar-origem  AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-usuar-destino AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER p-tipo-envio    AS INTEGER   NO-UNDO.

    RUN inbo/boin767c1.p PERSISTENT SET hmla-email-aprov.
    RUN setEnviaEmail IN hmla-email-aprov (INPUT p-usuar-origem,     
                                           INPUT p-usuar-destino,
                                           INPUT p-tipo-envio,
                                           INPUT IF r-prox-pend <> ? THEN r-prox-pend ELSE gr-mla-rowid-pend,
                                           INPUT IF gi-mla-origem = 2 THEN "NO":U ELSE "":U). /*Identificar se a aprovacao esta sendo feito via web ou client */
    ASSIGN r-prox-pend = ?.

    DELETE PROCEDURE hmla-email-aprov.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setExecuteProg DBOProgram 
PROCEDURE setExecuteProg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-cod-erro AS INTEGER NO-UNDO.

    DEFINE VARIABLE c-tipo-doc-prog-aprova-aux  AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE c-tipo-doc-prog-rejeita-aux AS CHARACTER   NO-UNDO.

    ASSIGN c-tipo-doc-prog-aprova-aux  = c-tipo-doc-prog-aprova.
           c-tipo-doc-prog-rejeita-aux = c-tipo-doc-prog-rejeita.
           
    IF LENGTH(c-tipo-doc-prog-aprova-aux) > 2 THEN DO:
        IF SUBSTRING(c-tipo-doc-prog-aprova-aux, LENGTH(c-tipo-doc-prog-aprova-aux) - 1, 2) = ".p":U THEN
            ASSIGN OVERLAY(c-tipo-doc-prog-aprova-aux, LENGTH(c-tipo-doc-prog-aprova-aux) - 1, 2) = ".r":U.
    END.

    IF LENGTH(c-tipo-doc-prog-rejeita-aux) > 2 THEN DO:
        IF SUBSTRING(c-tipo-doc-prog-rejeita-aux, LENGTH(c-tipo-doc-prog-rejeita-aux) - 1, 2) = ".p":U THEN
            ASSIGN OVERLAY(c-tipo-doc-prog-rejeita-aux, LENGTH(c-tipo-doc-prog-rejeita-aux) - 1, 2) = ".r":U.
    END.

    EMPTY TEMP-TABLE tt-log-erros-atualiz.
    EMPTY TEMP-TABLE tt-mla014e.

    IF tt-pendencia.tipo-trans = 2 THEN DO:
        IF c-tipo-doc-prog-rejeita <> "" THEN DO:
            IF SEARCH(c-tipo-doc-prog-rejeita-aux) = ? THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="34349"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-tipo-doc-prog-rejeita"}
                RETURN "NOK":U.
            END.

            IF mla-doc-pend-aprov.cod-tip-doc = 24
            OR mla-doc-pend-aprov.cod-tip-doc = 25
            OR mla-doc-pend-aprov.cod-tip-doc = 26
            OR mla-doc-pend-aprov.cod-tip-doc = 28 THEN DO: /*Tratamento para os Documentos de Finanáas (temp-table de erros)*/
                
                RUN VALUE(c-tipo-doc-prog-rejeita) (gr-mla-rowid-pend,
                                                    gc-mla-cod-usuar,
                                                    NOT gl-mla-gera-proxima,
                                                    INPUT-OUTPUT TABLE tt-log-erros-atualiz).
                FOR EACH tt-log-erros-atualiz:
                    ASSIGN p-cod-erro = tt-log-erros-atualiz.ttv-num-mensagem.
                    {method/svc/errors/inserr.i &ErrorNumber="tt-log-erros-atualiz.ttv-num-mensagem"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
                    ASSIGN RowErrors.ErrorDescription = tt-log-erros-atualiz.ttv-des-msg-erro
                           RowErrors.ErrorHelp        = tt-log-erros-atualiz.ttv-des-msg-ajuda.                                                
                END.

                FIND FIRST RowErrors NO-ERROR.
                IF AVAIL RowErrors THEN DO:
                    RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE rowErrors).
                      IF  gi-mla-origem <> 2 THEN DO:
						{method/showmessage.i1}
						/*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
						{method/showmessage.i2}
					END.
                    RETURN "NOK":U.
                END.
            END.
            ELSE DO:
                IF  mla-doc-pend-aprov.cod-tip-doc = 32 /* Originaá∆o - Adiantamento Valor    */ OR
                    mla-doc-pend-aprov.cod-tip-doc = 33 /* Originaá∆o - Fechamento Financeiro */ THEN DO:
                    RUN VALUE(c-tipo-doc-prog-rejeita) (INPUT  gr-mla-rowid-pend,
                                                        INPUT  gc-mla-cod-usuar,
                                                        INPUT  NOT gl-mla-gera-proxima,
                                                        OUTPUT TABLE RowErrors APPEND).
                END.
                ELSE DO:
                    RUN VALUE(c-tipo-doc-prog-rejeita) (gr-mla-rowid-pend,
                                                        gc-mla-cod-usuar,
                                                        NOT gl-mla-gera-proxima) no-error.
					/* Caso tenha retornado erro na execuá∆o, Ç porque tem problema na passagem de parÉmetro e precisa retornar a RowErros */
					IF  ERROR-STATUS:ERROR THEN DO:
						RUN VALUE(c-tipo-doc-prog-rejeita) (INPUT  gr-mla-rowid-pend,
														    INPUT  gc-mla-cod-usuar,
														    INPUT  NOT gl-mla-gera-proxima,
														    OUTPUT TABLE RowErrors APPEND).
					END.
                END.
            END.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                ASSIGN p-cod-erro = 999998.
                {method/svc/errors/inserr.i &ErrorNumber="34030"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}

                RETURN "NOK":U.
            END.
        END.
    END.
    ELSE DO:
        IF c-tipo-doc-prog-aprova <> "" THEN DO:
            IF SEARCH(c-tipo-doc-prog-aprova-aux) = ? THEN DO:
                {method/svc/errors/inserr.i &ErrorNumber="34349"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="c-tipo-doc-prog-aprova"}
                RETURN "NOK":U.
            END.

            ASSIGN gi-mla-prox-prior = 0.
            IF mla-doc-pend-aprov.cod-tip-doc = 24
            OR mla-doc-pend-aprov.cod-tip-doc = 25
            OR mla-doc-pend-aprov.cod-tip-doc = 26
            OR mla-doc-pend-aprov.cod-tip-doc = 28 THEN DO: /*Tratamento para os Documentos de Finanáas (temp-table de erros)*/
                
                RUN VALUE(c-tipo-doc-prog-aprova) (gr-mla-rowid-pend,
                                                   gc-mla-cod-usuar,
                                                   not gl-mla-gera-proxima,
                                                   INPUT-OUTPUT TABLE tt-log-erros-atualiz).
                FOR EACH tt-log-erros-atualiz: 
                    ASSIGN p-cod-erro = tt-log-erros-atualiz.ttv-num-mensagem.
                    {method/svc/errors/inserr.i &ErrorNumber="tt-log-erros-atualiz.ttv-num-mensagem"
                                                &ErrorType="EMS":U
                                                &ErrorSubType="ERROR":U
                                                &ErrorParameters="''"}
                    ASSIGN RowErrors.ErrorDescription = tt-log-erros-atualiz.ttv-des-msg-erro
                           RowErrors.ErrorHelp        = tt-log-erros-atualiz.ttv-des-msg-ajuda.
                END.

                FIND FIRST RowErrors NO-ERROR.
                IF AVAIL RowErrors THEN DO:
                    RUN getRowErrors IN this-procedure (OUTPUT TABLE rowErrors).
                     IF gi-mla-origem <> 2 THEN DO:
						{method/showmessage.i1}
						/*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
						{method/showmessage.i2}
					END.
                    RETURN "NOK":U.
                END.
            END.
            ELSE DO:
                /*Verifica se o tipo de documento Ç Mediá∆o*/
                IF mla-doc-pend-aprov.cod-tip-doc = 14 THEN DO: /*cod-tip-doc = 14*/
                    /*Executa o programa sem a nossa temp-table como parÉmetro*/
                    RUN VALUE(c-tipo-doc-prog-aprova) (gr-mla-rowid-pend,
                                                        gc-mla-cod-usuar,
                                                        NOT gl-mla-gera-proxima) NO-ERROR.
                    /*Se ocorrer erro na execuá∆o e o programa chamado foi o lapepc\mla014e.r
                        ent∆o chama o programa passando a Temp-Table de erro*/
                    /*ERROR-STATUS*/
                    IF ERROR-STATUS:ERROR AND c-tipo-doc-prog-aprova MATCHES "*mla014e.*":U THEN DO:
                        RUN VALUE(c-tipo-doc-prog-aprova) (gr-mla-rowid-pend,
                                                        gc-mla-cod-usuar,
                                                        NOT gl-mla-gera-proxima,
                                                        OUTPUT TABLE tt-mla014e).
                        /*Se Retornou algum erro na Temp-table de erro passa para a RowErros*/
                        FIND FIRST tt-mla014e NO-LOCK NO-ERROR.
                        IF AVAIL tt-mla014e THEN DO: /*AVAIL tt-mla014e*/
                            FOR EACH tt-mla014e NO-LOCK: /*FOR EACH*/
                                {method/svc/errors/inserr.i &ErrorNumber="tt-mla014e.ErrorNumber"
                                                            &ErrorParameters="tt-mla014e.ErrorParameters"
                                                            &ErrorType="EMS":U
                                                            &ErrorSubType="ERROR":U
                                                            &vErrorDescription="tt-mla014e.ErrorDescription"
                                                            &vErrorHelp="tt-mla014e.ErrorHelp"}
                                                
                            END. /*FOR EACH*/
                        END. /*AVAIL tt-mla014e*/
                    END. /*ERROR-STATUS*/
                END. /*cod-tip-doc = 14*/
                ELSE DO: /*ELSE cod-tip-doc = 14*/
                    IF  mla-doc-pend-aprov.cod-tip-doc = 21 /* Avaliaá∆o de CrÇdito               */ OR
                        mla-doc-pend-aprov.cod-tip-doc = 32 /* Originaá∆o - Adiantamento Valor    */ OR
                        mla-doc-pend-aprov.cod-tip-doc = 33 /* Originaá∆o - Fechamento Financeiro */ THEN DO: /*cod-tip-doc = 21 ou 32 ou 33*/

                        RUN VALUE(c-tipo-doc-prog-aprova) (INPUT  gr-mla-rowid-pend,
                                                           INPUT  gc-mla-cod-usuar,
                                                           INPUT  NOT gl-mla-gera-proxima,
                                                           OUTPUT TABLE RowErrors APPEND).
                    END.
                    ELSE DO:
                        /*Se n∆o for o documento de Aprovaá∆o de pedido de venda (mla-doc-pend-aprov = 21), e nem de originaá∆o, segue a execuá∆o normal */
                        RUN VALUE(c-tipo-doc-prog-aprova) (INPUT gr-mla-rowid-pend,
                                                           INPUT gc-mla-cod-usuar,
                                                           INPUT NOT gl-mla-gera-proxima) NO-ERROR.

                        /* Caso tenha retornado erro na execuá∆o, Ç porque tem problema na passagem de parÉmetro e precisa retornar a RowErros */
                        IF  ERROR-STATUS:ERROR THEN DO:
                            RUN VALUE(c-tipo-doc-prog-aprova) (INPUT  gr-mla-rowid-pend,
                                                               INPUT  gc-mla-cod-usuar,
                                                               INPUT  NOT gl-mla-gera-proxima,
                                                               OUTPUT TABLE RowErrors APPEND).
                        END.
                    END.
                END. /*ELSE cod-tip-doc = 14*/
            END.
            IF  RETURN-VALUE = "NOK":U THEN DO:
                ASSIGN p-cod-erro = 999998.
                {method/svc/errors/inserr.i &ErrorNumber="34030"
                                            &ErrorType="EMS":U
                                            &ErrorSubType="ERROR":U
                                            &ErrorParameters="''"}
                RETURN "NOK":U.
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPend DBOProgram 
PROCEDURE setGeraPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /**  Gera pr¢xima pendància **/
    ASSIGN gl-mla-gera-proxima = NO
           gde-mla-limite      = 0.

    IF tt-pendencia.tipo-trans <> 2 THEN DO:
        
        FIND FIRST tt-item WHERE tt-item.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-item THEN DO:
            FOR FIRST item FIELD(it-codigo desc-item fm-codigo) 
                WHERE item.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK:

                CREATE tt-item.
                ASSIGN tt-item.it-codigo = item.it-codigo
                       tt-item.desc-item = item.desc-item
                       tt-item.fm-codigo = item.fm-codigo.
            END.
        END.
        IF AVAILABLE tt-item THEN DO:

            FIND FIRST tt-mla-lim-aprov-fam 
                 WHERE tt-mla-lim-aprov-fam.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                   AND tt-mla-lim-aprov-fam.fm-codigo   = tt-item.fm-codigo               
                   AND tt-mla-lim-aprov-fam.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                   AND tt-mla-lim-aprov-fam.cod-usuar   = gc-mla-cod-usuar NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-mla-lim-aprov-fam THEN DO:
                FOR FIRST mla-lim-aprov-fam FIELDS (ep-codigo fm-codigo cod-tip-doc 
                                                cod-usuar limite-aprov)  
                     WHERE mla-lim-aprov-fam.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                       AND mla-lim-aprov-fam.fm-codigo   = tt-item.fm-codigo               
                       AND mla-lim-aprov-fam.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                       AND mla-lim-aprov-fam.cod-usuar   = gc-mla-cod-usuar NO-LOCK: 
                    CREATE tt-mla-lim-aprov-fam.
                    ASSIGN tt-mla-lim-aprov-fam.ep-codigo     = mla-lim-aprov-fam.ep-codigo  
                           tt-mla-lim-aprov-fam.fm-codigo     = mla-lim-aprov-fam.fm-codigo  
                           tt-mla-lim-aprov-fam.cod-tip-doc   = mla-lim-aprov-fam.cod-tip-doc
                           tt-mla-lim-aprov-fam.cod-usuar     = mla-lim-aprov-fam.cod-usuar  
                           tt-mla-lim-aprov-fam.limite-aprov  = mla-lim-aprov-fam.limite-aprov.
                END.
            END.
        END.

        RUN setConsistPend IN THIS-PROCEDURE (OUTPUT i-cod-erro, OUTPUT c-desc-erro).
        IF i-cod-erro = 15540 THEN
            RETURN "NOK".

        IF AVAIL tt-item AND AVAIL tt-mla-lim-aprov-fam THEN
            ASSIGN gde-mla-limite = tt-mla-lim-aprov-fam.limite-aprov.
        ELSE DO:
            IF da-perm-validade-ini <= TODAY AND da-perm-validade-fim >= TODAY THEN DO:
                ASSIGN gde-mla-limite = de-perm-limite-aprov.
            END.
            ELSE DO:
                IF l-mestre THEN
                    ASSIGN gde-mla-limite = 999999999.99.
                ELSE
                    ASSIGN gde-mla-limite = 0.
            END.
        END.
        RUN setGeraPendAprov IN THIS-PROCEDURE.
    END.
    ELSE
        RUN setPendRejeitaLista IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setPendRejeitaLista DBOProgram 
PROCEDURE setPendRejeitaLista :
/*------------------------------------------------------------------------------
  Purpose:     Alterar a situaá∆o de todas Pendàncias Criadas quando o tipo de 
               aprovaá∆o Ç por lista e uma delas for rejeitada pelo usu†rio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /*Ap¢s um usu†rio rejeitar uma pendància, alterar todas as outras que foram 
     geradas para o mesmo prop¢sito para rejeitado tambem, 
     isso quando se trabalha por Lista */

    IF mla-doc-pend-aprov.ind-tip-aprov = 2 THEN DO:

        FOR EACH  b-mla-doc-pend-aprov EXCLUSIVE-LOCK
            WHERE b-mla-doc-pend-aprov.ep-codigo     = mla-doc-pend-aprov.ep-codigo
              AND b-mla-doc-pend-aprov.cod-estabel   = mla-doc-pend-aprov.cod-estabel
              AND b-mla-doc-pend-aprov.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc   
              AND b-mla-doc-pend-aprov.ind-tip-aprov = mla-doc-pend-aprov.ind-tip-aprov 
              AND b-mla-doc-pend-aprov.chave-doc     = mla-doc-pend-aprov.chave-doc     
              AND b-mla-doc-pend-aprov.ind-situacao  = 1                                
              AND b-mla-doc-pend-aprov.historico     = NO:
            ASSIGN b-mla-doc-pend-aprov.dt-rejeita    = TODAY
                   b-mla-doc-pend-aprov.ind-situacao  = 3
                   b-mla-doc-pend-aprov.narrativa-rej = gc-mla-narrativa
                   b-mla-doc-pend-aprov.cod-rejeicao  = gi-mla-cod-rejeicao
                   b-mla-doc-pend-aprov.aprov-auto    = YES.

            ASSIGN OVERLAY(b-mla-doc-pend-aprov.char-1,9,8) = STRING(TIME,"hh:mm:ss":U).   

            IF b-mla-doc-pend-aprov.cod-usuar <> gc-mla-cod-usuar THEN
                ASSIGN b-mla-doc-pend-aprov.cod-usuar-altern = gc-mla-cod-usuar.

            /********* [ Intergraá∆o com Fluig ] *********/
            IF tt-mla-tipo-doc-aprov.log-integr-fluig AND tt-param-aprov.log-integr-fluig THEN DO:
                {lap/mlaapi014.i4 7} /* Reprova (no Fluig) a pendància corrente */
            END.
            /*********************************************/
        END.
    END.
END PROCEDURE.
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendAprov DBOProgram 
PROCEDURE setGeraPendAprov :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /**  Aprovaá∆o automaticamente da lista 
    **/
    IF mla-doc-pend-aprov.ind-tip-aprov = 2 THEN DO:
        /*Verifica se È por Documento, Item ou Referencia*/
        CASE i-prioridade-aprov:         
            WHEN 1 THEN DO: /* Documento */
                FIND FIRST tt-tipo-aprov-doc NO-LOCK
                     WHERE tt-tipo-aprov-doc.ep-codigo     = mla-doc-pend-aprov.ep-codigo   
                       AND tt-tipo-aprov-doc.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc 
                       AND tt-tipo-aprov-doc.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-ERROR.

                IF NOT AVAIL tt-tipo-aprov-doc THEN DO:
                    FOR FIRST mla-tipo-aprov-doc FIELDS (ep-codigo cod-tip-doc cod-tip-aprov nr-min-aprov)
                         WHERE mla-tipo-aprov-doc.ep-codigo     = mla-doc-pend-aprov.ep-codigo   
                           AND mla-tipo-aprov-doc.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc 
                           AND mla-tipo-aprov-doc.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK:
                        CREATE tt-tipo-aprov-doc.
                        ASSIGN tt-tipo-aprov-doc.ep-codigo     = mla-tipo-aprov-doc.ep-codigo      
                               tt-tipo-aprov-doc.cod-tip-doc   = mla-tipo-aprov-doc.cod-tip-doc    
                               tt-tipo-aprov-doc.cod-tip-aprov = mla-tipo-aprov-doc.cod-tip-aprov  
                               tt-tipo-aprov-doc.nr-min-aprov  = mla-tipo-aprov-doc.nr-min-aprov.  
                    END.
                END.
                IF AVAIL tt-tipo-aprov-doc THEN
                    ASSIGN i-tipo-doc-nr-min-aprov = tt-tipo-aprov-doc.nr-min-aprov.
            END.
            WHEN 2 THEN DO: /* Item */     
                FIND FIRST tt-tipo-aprov-item NO-LOCK
                     WHERE tt-tipo-aprov-item.ep-codigo     = mla-doc-pend-aprov.ep-codigo   
                       AND tt-tipo-aprov-item.it-codigo     = mla-doc-pend-aprov.it-codigo   
                       AND tt-tipo-aprov-item.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-ERROR.

                IF NOT AVAIL tt-tipo-aprov-item THEN DO:
                    FOR FIRST mla-tipo-aprov-item FIELDS (ep-codigo it-codigo cod-tip-aprov nr-min-aprov)
                         WHERE mla-tipo-aprov-item.ep-codigo     = mla-doc-pend-aprov.ep-codigo   
                           AND mla-tipo-aprov-item.it-codigo     = mla-doc-pend-aprov.it-codigo   
                           AND mla-tipo-aprov-item.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK:
                        CREATE tt-tipo-aprov-item.
                        ASSIGN tt-tipo-aprov-item.ep-codigo     = mla-tipo-aprov-item.ep-codigo     
                               tt-tipo-aprov-item.it-codigo     = mla-tipo-aprov-item.it-codigo     
                               tt-tipo-aprov-item.cod-tip-aprov = mla-tipo-aprov-item.cod-tip-aprov 
                               tt-tipo-aprov-item.nr-min-aprov  = mla-tipo-aprov-item.nr-min-aprov.  
                    END.
                END.

                IF AVAIL tt-tipo-aprov-item THEN
                    ASSIGN i-tipo-doc-nr-min-aprov = tt-tipo-aprov-item.nr-min-aprov.
                ELSE DO:
                    IF NOT AVAIL tt-item THEN DO:
                        FIND FIRST tt-item WHERE tt-item.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK NO-ERROR.
            
                        IF NOT AVAIL tt-item THEN DO:
                            FOR FIRST ITEM FIELD(it-codigo desc-item fm-codigo) where
                                item.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK:
            
                                CREATE tt-item.
                                ASSIGN tt-item.it-codigo = ITEM.it-codigo
                                       tt-item.desc-item = ITEM.desc-item
                                       tt-item.fm-codigo = ITEM.fm-codigo.
                            END.
                        END.
                    END.

                    FIND FIRST tt-tipo-aprov-fam NO-LOCK
                         WHERE tt-tipo-aprov-fam.ep-codigo     = mla-doc-pend-aprov.ep-codigo   
                           AND tt-tipo-aprov-fam.fm-codigo     = tt-item.fm-codigo                 
                           AND tt-tipo-aprov-fam.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-ERROR.

                    IF NOT AVAIL tt-tipo-aprov-fam THEN DO:
                        FOR FIRST mla-tipo-aprov-fam FIELDS (ep-codigo fm-codigo cod-tip-aprov nr-min-aprov)
                             WHERE mla-tipo-aprov-fam.ep-codigo     = mla-doc-pend-aprov.ep-codigo   
                               AND mla-tipo-aprov-fam.fm-codigo     = tt-item.fm-codigo                 
                               AND mla-tipo-aprov-fam.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK:

                            CREATE tt-tipo-aprov-fam.
                            ASSIGN tt-tipo-aprov-fam.ep-codigo     = mla-tipo-aprov-fam.ep-codigo     
                                   tt-tipo-aprov-fam.fm-codigo     = mla-tipo-aprov-fam.fm-codigo     
                                   tt-tipo-aprov-fam.cod-tip-aprov = mla-tipo-aprov-fam.cod-tip-aprov 
                                   tt-tipo-aprov-fam.nr-min-aprov  = mla-tipo-aprov-fam.nr-min-aprov.  
                        END.
                    END.

                    IF AVAIL tt-tipo-aprov-fam THEN
                        ASSIGN i-tipo-doc-nr-min-aprov = tt-tipo-aprov-fam.nr-min-aprov.
                END.
            END.
            WHEN 3 THEN DO: /* Referencia */
                FIND FIRST tt-tipo-aprov-ref 
                     WHERE tt-tipo-aprov-ref.ep-codigo     = mla-doc-pend-aprov.ep-codigo    
                       AND tt-tipo-aprov-ref.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc  
                       AND tt-tipo-aprov-ref.codigo        = mla-doc-pend-aprov.cod-referencia
                       AND tt-tipo-aprov-ref.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-tipo-aprov-ref THEN DO:
                    FOR FIRST mla-tipo-aprov-ref FIELDS (ep-codigo cod-tip-doc codigo cod-tip-aprov nr-min-aprov)
                         WHERE mla-tipo-aprov-ref.ep-codigo     = mla-doc-pend-aprov.ep-codigo    
                           AND mla-tipo-aprov-ref.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc  
                           AND mla-tipo-aprov-ref.codigo        = mla-doc-pend-aprov.cod-referencia
                           AND mla-tipo-aprov-ref.cod-tip-aprov = mla-doc-pend-aprov.cod-tip-aprov NO-LOCK: 

                        CREATE tt-tipo-aprov-ref.
                        ASSIGN tt-tipo-aprov-ref.ep-codigo     = mla-tipo-aprov-ref.ep-codigo     
                               tt-tipo-aprov-ref.codigo        = mla-tipo-aprov-ref.codigo   
                               tt-tipo-aprov-ref.cod-tip-doc   = mla-tipo-aprov-ref.cod-tip-doc        
                               tt-tipo-aprov-ref.cod-tip-aprov = mla-tipo-aprov-ref.cod-tip-aprov 
                               tt-tipo-aprov-ref.nr-min-aprov  = mla-tipo-aprov-ref.nr-min-aprov.
                    END.
                END.

                IF AVAIL tt-tipo-aprov-ref THEN
                    ASSIGN i-tipo-doc-nr-min-aprov = tt-tipo-aprov-ref.nr-min-aprov.
            END.
        END CASE.

        ASSIGN i-nr-min-aprov = 0.
        FOR EACH  b-mla-doc-pend-aprov 
            WHERE b-mla-doc-pend-aprov.ep-codigo     = mla-doc-pend-aprov.ep-codigo
            AND   b-mla-doc-pend-aprov.cod-estabel   = mla-doc-pend-aprov.cod-estabel
            AND   b-mla-doc-pend-aprov.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc   
            AND   b-mla-doc-pend-aprov.ind-tip-aprov = mla-doc-pend-aprov.ind-tip-aprov 
            AND   b-mla-doc-pend-aprov.chave-doc     = mla-doc-pend-aprov.chave-doc     
            AND   b-mla-doc-pend-aprov.historico     = NO 
            AND  (b-mla-doc-pend-aprov.ind-situacao  = 2 OR b-mla-doc-pend-aprov.ind-situacao  = 4) NO-LOCK:
            ASSIGN i-nr-min-aprov = i-nr-min-aprov + 1.
        END.
        DO TRANSACTION:
            IF i-nr-min-aprov >= i-tipo-doc-nr-min-aprov THEN DO:
                FOR EACH  b-mla-doc-pend-aprov EXCLUSIVE-LOCK
                    WHERE b-mla-doc-pend-aprov.ep-codigo     = mla-doc-pend-aprov.ep-codigo
                    AND   b-mla-doc-pend-aprov.cod-estabel   = mla-doc-pend-aprov.cod-estabel
                    AND   b-mla-doc-pend-aprov.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc   
                    AND   b-mla-doc-pend-aprov.ind-tip-aprov = mla-doc-pend-aprov.ind-tip-aprov 
                    AND   b-mla-doc-pend-aprov.chave-doc     = mla-doc-pend-aprov.chave-doc     
                    AND   b-mla-doc-pend-aprov.ind-situacao  = 1                                
                    AND   b-mla-doc-pend-aprov.historico     = NO:
                    
                    ASSIGN b-mla-doc-pend-aprov.dt-aprova        = TODAY
                           b-mla-doc-pend-aprov.ind-situacao     = 2
                           b-mla-doc-pend-aprov.narrativa-apr    = gc-mla-narrativa
                           b-mla-doc-pend-aprov.aprov-auto       = YES.

                    ASSIGN OVERLAY(b-mla-doc-pend-aprov.char-1,1,8) = STRING(TIME,"hh:mm:ss":U).                            

                    IF b-mla-doc-pend-aprov.cod-usuar <> gc-mla-cod-usuar THEN
                        ASSIGN b-mla-doc-pend-aprov.cod-usuar-altern = gc-mla-cod-usuar.

                    /********* [ Intergraá∆o com Fluig ] *********/
                    IF tt-mla-tipo-doc-aprov.log-integr-fluig AND tt-param-aprov.log-integr-fluig THEN DO:
                        {lap/mlaapi014.i4 6} /* Aprova (no Fluig) a pendància corrente */
                    END.
                    /*********************************************/
                END.
            END.
            ELSE
                RETURN.
        END.
    END.

    /**  EPC para tratar limite de aprovaá∆o **/
    RUN lap/mlaapi060.p (INPUT  ROWID(mla-doc-pend-aprov), INPUT  gde-mla-limite, OUTPUT gde-mla-limite).

    /**  Gera pr¢xima pendància 
    **/
    ASSIGN gl-mla-email-faixa-hierarquia = NO. 
    IF  mla-doc-pend-aprov.ind-tip-aprov = 1 THEN DO:
        RUN setGeraPendHierarquia IN THIS-PROCEDURE.
    END.
    IF mla-doc-pend-aprov.ind-tip-aprov = 5 THEN DO:
        RUN setGeraPendFaixa IN THIS-PROCEDURE.
    END.

    /** 16741457 - Ponto Customizado Santher **/
    EMPTY TEMP-TABLE tt-epc.
    
    IF c-nom-prog-dpc-mg97  <> "" 
    OR c-nom-prog-appc-mg97 <> ""
    OR c-nom-prog-upc-mg97  <> "" THEN DO: 
    
        CREATE tt-epc.
        ASSIGN tt-epc.cod-event     = "afterGeraProximaPend":U
               tt-epc.cod-parameter = "rowid-pendencia":U
               tt-epc.val-parameter = STRING(ROWID(mla-doc-pend-aprov)).
    
        {include/i-epc201.i "afterGeraProximaPend"}
    
        IF  RETURN-VALUE = 'NOK':U THEN DO:
            RETURN "OK":U.                      
        END.
    END.


    /**  IF para tratar aprovaá∆o tÇcnica e aprovaá∆o por lista
    ***  Zerado o limite de aprovaá∆o.
    ***  Isto se faz necess†rio para os casos em que o aprovador tÇcnico Ç aprovador
    ***  de outro tipo de aprovaá∆o(Faixa por exemplo), fazendo com que o limite do mesmo seja
    ***  ignorado caso esta seja uma aprovaá∆o tÇcnica ou por lista
    **/
    IF  mla-doc-pend-aprov.ind-tip-aprov = 4 OR mla-doc-pend-aprov.ind-tip-aprov = 2 THEN DO:
        ASSIGN gde-mla-limite = 0.
    END.

    /**  Gera pr¢ximo tipo de aprovaá∆o **/
    IF NOT gl-mla-gera-proxima AND mla-doc-pend-aprov.prioridade-aprov <> 0 THEN DO:

        EMPTY TEMP-TABLE tt-mla-chave.
        EMPTY TEMP-TABLE tt-erro.

        CREATE tt-mla-chave.
        ASSIGN i-chave = 0.

        FOR EACH tt-mla-chave-doc NO-LOCK
           WHERE tt-mla-chave-doc.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc :

            ASSIGN i-chave = i-chave + 1
                   tt-mla-chave.valor[i-chave] = SUBSTRING(mla-doc-pend-aprov.chave-doc,
                                                           tt-mla-chave-doc.posicao-ini,
                                                         ((tt-mla-chave-doc.posicao-fim -
                                                           tt-mla-chave-doc.posicao-ini) + 1)).
        END.        

        ASSIGN gi-mla-prox-prior = mla-doc-pend-aprov.prioridade-aprov.

        IF  gi-mla-prox-prior > 0 THEN DO:
            ASSIGN gi-mla-prox-prior = gi-mla-prox-prior + 10.

            RUN inbo/boin767b.p PERSISTENT SET hmla-doc-pend-aprov.
            RUN geraPend IN hmla-doc-pend-aprov (INPUT  mla-doc-pend-aprov.cod-tip-doc,
                                                 INPUT  1,
                                                 INPUT  mla-doc-pend-aprov.chave-doc,
                                                 INPUT  mla-doc-pend-aprov.nr-trans,
                                                 OUTPUT TABLE tt-erro).
            DELETE PROCEDURE hmla-doc-pend-aprov.

            RUN inbo/boin767a.p PERSISTENT SET hmla-doc-pend-verif.
            RUN checkPend IN hmla-doc-pend-verif (INPUT  mla-doc-pend-aprov.cod-tip-doc,
                                                  INPUT  mla-doc-pend-aprov.chave-doc,
                                                  OUTPUT TABLE tt-erro).
            DELETE PROCEDURE hmla-doc-pend-verif.

            FIND FIRST tt-erro NO-LOCK NO-ERROR.
            IF AVAILABLE tt-erro THEN
                ASSIGN gl-mla-gera-proxima = YES. 
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendFaixa DBOProgram 
PROCEDURE setGeraPendFaixa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.

    LOG-MANAGER:WRITE-MESSAGE (">>> Lotacao: ":U + STRING(TRIM(c-lotacao))) NO-ERROR.

    FIND FIRST tt-mla-hierarquia-faixa 
         WHERE tt-mla-hierarquia-faixa.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
           AND tt-mla-hierarquia-faixa.cod-estabel = mla-doc-pend-aprov.cod-estabel
           AND tt-mla-hierarquia-faixa.cod-lotacao = c-lotacao
           AND tt-mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
           AND tt-mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa 
           AND tt-mla-hierarquia-faixa.seq-aprov   = mla-doc-pend-aprov.seq-aprov NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-mla-hierarquia-faixa THEN DO:
        FOR FIRST mla-hierarquia-faixa FIELDS (ep-codigo cod-estabel cod-lotacao cod-tip-doc num-faixa
                                               seq-aprov log-depend cod-usuar) 
             WHERE mla-hierarquia-faixa.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
               AND mla-hierarquia-faixa.cod-estabel = mla-doc-pend-aprov.cod-estabel
               AND mla-hierarquia-faixa.cod-lotacao = c-lotacao
               AND mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
               AND mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa 
               AND mla-hierarquia-faixa.seq-aprov   = mla-doc-pend-aprov.seq-aprov NO-LOCK:
            CREATE tt-mla-hierarquia-faixa.
            ASSIGN tt-mla-hierarquia-faixa.ep-codigo    = mla-hierarquia-faixa.ep-codigo  
                   tt-mla-hierarquia-faixa.cod-estabel  = mla-hierarquia-faixa.cod-estabel
                   tt-mla-hierarquia-faixa.cod-lotacao  = mla-hierarquia-faixa.cod-lotacao
                   tt-mla-hierarquia-faixa.cod-tip-doc  = mla-hierarquia-faixa.cod-tip-doc
                   tt-mla-hierarquia-faixa.num-faixa    = mla-hierarquia-faixa.num-faixa  
                   tt-mla-hierarquia-faixa.seq-aprov    = mla-hierarquia-faixa.seq-aprov  
                   tt-mla-hierarquia-faixa.log-depend   = mla-hierarquia-faixa.log-depend 
                   tt-mla-hierarquia-faixa.cod-usuar    = mla-hierarquia-faixa.cod-usuar. 
        END.
    END.

    IF AVAIL tt-mla-hierarquia-faixa THEN DO:
        ASSIGN l-achou-faixa = YES
               l-hierarquia-faixa-log-depend = tt-mla-hierarquia-faixa.log-depend.
    END.

    IF  l-achou-faixa AND
       (l-hierarquia-faixa-log-depend = YES OR (l-hierarquia-faixa-log-depend = NO  AND
        gde-mla-limite < mla-doc-pend-aprov.valor-doc)) THEN DO:

        FIND FIRST tt-mla-hierarquia-faixa 
             WHERE tt-mla-hierarquia-faixa.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
               AND tt-mla-hierarquia-faixa.cod-estabel = mla-doc-pend-aprov.cod-estabel
               AND tt-mla-hierarquia-faixa.cod-lotacao = c-lotacao
               AND tt-mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
               AND tt-mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa 
               AND tt-mla-hierarquia-faixa.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1) NO-LOCK NO-ERROR.
    
        IF NOT AVAIL tt-mla-hierarquia-faixa THEN DO:
            FOR FIRST mla-hierarquia-faixa FIELDS (ep-codigo cod-estabel cod-lotacao cod-tip-doc num-faixa
                                                   seq-aprov log-depend cod-usuar log-depend) 
                 WHERE mla-hierarquia-faixa.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                   AND mla-hierarquia-faixa.cod-estabel = mla-doc-pend-aprov.cod-estabel
                   AND mla-hierarquia-faixa.cod-lotacao = c-lotacao
                   AND mla-hierarquia-faixa.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                   AND mla-hierarquia-faixa.num-faixa   = mla-doc-pend-aprov.num-faixa 
                   AND mla-hierarquia-faixa.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1) NO-LOCK:
                CREATE tt-mla-hierarquia-faixa.
                ASSIGN tt-mla-hierarquia-faixa.ep-codigo    = mla-hierarquia-faixa.ep-codigo  
                       tt-mla-hierarquia-faixa.cod-estabel  = mla-hierarquia-faixa.cod-estabel
                       tt-mla-hierarquia-faixa.cod-lotacao  = mla-hierarquia-faixa.cod-lotacao
                       tt-mla-hierarquia-faixa.cod-tip-doc  = mla-hierarquia-faixa.cod-tip-doc
                       tt-mla-hierarquia-faixa.num-faixa    = mla-hierarquia-faixa.num-faixa  
                       tt-mla-hierarquia-faixa.seq-aprov    = mla-hierarquia-faixa.seq-aprov  
                       tt-mla-hierarquia-faixa.log-depend   = mla-hierarquia-faixa.log-depend 
                       tt-mla-hierarquia-faixa.cod-usuar    = mla-hierarquia-faixa.cod-usuar. 
            END.
        END.

        IF AVAIL tt-mla-hierarquia-faixa THEN DO:
          
            ASSIGN l-achou-faixa = YES
                   c-hierarquia-faixa-cod-usuar  = tt-mla-hierarquia-faixa.cod-usuar
                   l-hierarquia-faixa-log-depend = tt-mla-hierarquia-faixa.log-depend
                   i-hierarquia-faixa-seq-aprov  = tt-mla-hierarquia-faixa.seq-aprov.   

            /* In°cio Ponto UPC - 12431495 */
            if  c-nom-prog-upc-mg97 <> "" then do:    
        
                for each tt-epc
                    where tt-epc.cod-event = "before-aprovacao-pendente".
                    delete tt-epc.
                end.
            
                {include/i-epc200.i2 &CodEvent='"before-aprovacao-pendente"'
                                     &CodParameter='"handle_tt-mla-hierarquia-faixa"'
                                     &ValueParameter="string(temp-table tt-mla-hierarquia-faixa:handle)"}
                                     
                {include/i-epc201.i "before-aprovacao-pendente"}
            END.
            /* Fim Ponto UPC */
        END.

       IF l-achou-faixa AND AVAIL tt-mla-hierarquia-faixa THEN DO:

           CREATE b-mla-doc-pend-aprov.
           ASSIGN b-mla-doc-pend-aprov.ep-codigo            = mla-doc-pend-aprov.ep-codigo
                  b-mla-doc-pend-aprov.cod-estabel          = mla-doc-pend-aprov.cod-estabel
                  b-mla-doc-pend-aprov.chave-doc            = mla-doc-pend-aprov.chave-doc
                  b-mla-doc-pend-aprov.cod-lotacao-doc      = mla-doc-pend-aprov.cod-lotacao-doc
                  b-mla-doc-pend-aprov.cod-lotacao-trans    = mla-doc-pend-aprov.cod-lotacao-trans
                  b-mla-doc-pend-aprov.cod-tip-aprov        = mla-doc-pend-aprov.cod-tip-aprov
                  b-mla-doc-pend-aprov.cod-tip-doc          = mla-doc-pend-aprov.cod-tip-doc
                  b-mla-doc-pend-aprov.cod-usuar            = c-hierarquia-faixa-cod-usuar
                  b-mla-doc-pend-aprov.cod-usuar-doc        = mla-doc-pend-aprov.cod-usuar-doc
                  b-mla-doc-pend-aprov.cod-usuar-trans      = mla-doc-pend-aprov.cod-usuar-trans
                  b-mla-doc-pend-aprov.dt-geracao           = TODAY
                  b-mla-doc-pend-aprov.ind-situacao         = 1
                  b-mla-doc-pend-aprov.ind-tip-aprov        = mla-doc-pend-aprov.ind-tip-aprov
                  b-mla-doc-pend-aprov.it-codigo            = mla-doc-pend-aprov.it-codigo
                  b-mla-doc-pend-aprov.mo-codigo            = mla-doc-pend-aprov.mo-codigo
                  b-mla-doc-pend-aprov.motivo-doc           = mla-doc-pend-aprov.motivo-doc
                  b-mla-doc-pend-aprov.num-faixa            = mla-doc-pend-aprov.num-faixa
                  b-mla-doc-pend-aprov.seq-aprov            = i-hierarquia-faixa-seq-aprov
                  b-mla-doc-pend-aprov.valor-doc            = mla-doc-pend-aprov.valor-doc
                  b-mla-doc-pend-aprov.prioridade-aprov     = mla-doc-pend-aprov.prioridade-aprov
                  b-mla-doc-pend-aprov.hora-geracao         = STRING(TIME,"HH:MM:SS":U)
                  b-mla-doc-pend-aprov.cod-referencia       = mla-doc-pend-aprov.cod-referencia
                  b-mla-doc-pend-aprov.char-2               = mla-doc-pend-aprov.char-2
                  OVERLAY(b-mla-doc-pend-aprov.char-1,25,4) = TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)) /*condiá∆o de pagamento*/
                  gl-mla-gera-proxima                       = YES
                  gl-mla-email-faixa-hierarquia             = YES
                  gEmail-cod-usuar                          = c-hierarquia-faixa-cod-usuar
                  r-prox-pend                               = ROWID(b-mla-doc-pend-aprov).

            /*************************************************************************/
            /*** IN÷CIO CHAMADA EPC - Cliente: Grendene                            ***/
            /*************************************************************************/
            /*** Prop¢sito: Identificar os pontos onde s∆o geradas pendàncias      ***/
            /*************************************************************************/

            IF c-nom-prog-upc-mg97 <> "" THEN DO:
                FOR EACH tt-epc
                   WHERE tt-epc.cod-event = "aprovacao-pendente":U:
                    DELETE tt-epc.
                END.
            
                /*rowid da tabela mla-doc-pend-aprov*/
                {include/i-epc200.i2 &CodEvent='"aprovacao-pendente"'
                                     &CodParameter='"TABLE-ROWID"'
                                     &ValueParameter="string(rowid(b-mla-doc-pend-aprov))"}
                                     
                {include/i-epc201.i "aprovacao-pendente"}
            END.
            /*************************************************************************/
            /*** FIM CHAMADA EPC - Grendene                                        ***/
            /*************************************************************************/

            /*************************************************************************/
            /*** INICIO - INTEGRAÄ«O COM O FLUIG                                   ***/
            /*************************************************************************/
            ASSIGN iNrTransacaoAux = b-mla-doc-pend-aprov.nr-trans.            
            /*************************************************************************/
            /*** FIM - INTEGRAÄ«O COM O FLUIG                                   ***/
            /*************************************************************************/

            /**  E-mail's Alternativos
            **/
            IF l-param-log-email-altern THEN DO:

                EMPTY TEMP-TABLE tt-mla-chave.
                CREATE tt-mla-chave.
                ASSIGN i-chave = 0.

                FOR EACH tt-mla-chave-doc NO-LOCK
                   WHERE tt-mla-chave-doc.cod-tip-doc = b-mla-doc-pend-aprov.cod-tip-doc :

                    ASSIGN i-chave = i-chave + 1
                           tt-mla-chave.valor[i-chave] = SUBSTRING(b-mla-doc-pend-aprov.chave-doc,
                                                                   tt-mla-chave-doc.posicao-ini,
                                                                 ((tt-mla-chave-doc.posicao-fim -
                                                                   tt-mla-chave-doc.posicao-ini) + 1)).
                END.
                /* Para o portal do MLA ser† chamada a procedure da pr¢pria BO - Performance */
                IF gi-mla-origem <> 2 THEN DO:
                    IF NOT VALID-HANDLE(hmla-emails) THEN
                        RUN inbo/boin790.p PERSISTENT SET hmla-emails.

                    RUN setEnviaEmailAltern IN hmla-emails (1, 
                                                            gi-mla-origem,
                                                            c-hierarquia-faixa-cod-usuar,
                                                            ROWID(b-mla-doc-pend-aprov),
                                                            INPUT TABLE tt-mla-chave).
                    IF  VALID-HANDLE(hmla-emails) THEN
                        DELETE PROCEDURE hmla-emails.
                END.
                ELSE DO:
                    RUN setEnviaEmailAltern IN THIS-PROCEDURE (1, 
                                                               c-hierarquia-faixa-cod-usuar,
                                                               rowid(b-mla-doc-pend-aprov)).
                END.
            END.            

            RELEASE b-mla-doc-pend-aprov.       
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setGeraPendHierarquia DBOProgram 
PROCEDURE setGeraPendHierarquia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN c-lotacao = mla-doc-pend-aprov.cod-lotacao-doc.

    ASSIGN l-achou-faixa = NO.

    LOG-MANAGER:WRITE-MESSAGE (">>> Lotacao: ":U + STRING(trim(c-lotacao))) NO-ERROR.

    FIND FIRST tt-mla-hierarquia-aprov 
         WHERE tt-mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
           AND tt-mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
           AND tt-mla-hierarquia-aprov.cod-lotacao = c-lotacao
           AND tt-mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
           AND tt-mla-hierarquia-aprov.seq-aprov   = mla-doc-pend-aprov.seq-aprov  NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-mla-hierarquia-aprov THEN DO:
        FOR FIRST mla-hierarquia-aprov FIELDS (ep-codigo cod-estabel cod-lotacao cod-tip-doc 
                                               seq-aprov log-depend cod-usuar) 
             WHERE mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
               AND mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
               AND mla-hierarquia-aprov.cod-lotacao = c-lotacao
               AND mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
               AND mla-hierarquia-aprov.seq-aprov   = mla-doc-pend-aprov.seq-aprov  NO-LOCK:
            CREATE tt-mla-hierarquia-aprov.
            ASSIGN tt-mla-hierarquia-aprov.ep-codigo   = mla-hierarquia-aprov.ep-codigo   
                   tt-mla-hierarquia-aprov.cod-estabel = mla-hierarquia-aprov.cod-estabel 
                   tt-mla-hierarquia-aprov.cod-lotacao = mla-hierarquia-aprov.cod-lotacao 
                   tt-mla-hierarquia-aprov.cod-tip-doc = mla-hierarquia-aprov.cod-tip-doc 
                   tt-mla-hierarquia-aprov.seq-aprov   = mla-hierarquia-aprov.seq-aprov   
                   tt-mla-hierarquia-aprov.log-depend  = mla-hierarquia-aprov.log-depend  
                   tt-mla-hierarquia-aprov.cod-usuar   = mla-hierarquia-aprov.cod-usuar.  
        END.
    END.

    IF AVAIL tt-mla-hierarquia-aprov THEN DO:
        ASSIGN l-achou-faixa = YES
               l-hierarquia-faixa-log-depend = tt-mla-hierarquia-aprov.log-depend.
    END.
    
    IF mla-doc-pend-aprov.cod-tip-doc <> 20  THEN DO: /*solicitaá∆o de serviáo pode ser gerado com valor zerado*/
        IF  l-achou-faixa 
        AND (    l-hierarquia-faixa-log-depend = YES 
                 OR (    l-hierarquia-faixa-log-depend = NO 
                         AND gde-mla-limite < mla-doc-pend-aprov.valor-doc)) THEN DO:
    

            FIND FIRST tt-mla-hierarquia-aprov 
                 WHERE tt-mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                   AND tt-mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
                   AND tt-mla-hierarquia-aprov.cod-lotacao = c-lotacao
                   AND tt-mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                   AND tt-mla-hierarquia-aprov.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1) NO-LOCK NO-ERROR.
        
            IF NOT AVAIL tt-mla-hierarquia-aprov THEN DO:
                FOR FIRST mla-hierarquia-aprov FIELDS (ep-codigo cod-estabel cod-lotacao cod-tip-doc 
                                                       seq-aprov log-depend cod-usuar) 
                     WHERE mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                       AND mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
                       AND mla-hierarquia-aprov.cod-lotacao = c-lotacao
                       AND mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                       AND mla-hierarquia-aprov.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1) NO-LOCK:
                    CREATE tt-mla-hierarquia-aprov.
                    ASSIGN tt-mla-hierarquia-aprov.ep-codigo   = mla-hierarquia-aprov.ep-codigo   
                           tt-mla-hierarquia-aprov.cod-estabel = mla-hierarquia-aprov.cod-estabel 
                           tt-mla-hierarquia-aprov.cod-lotacao = mla-hierarquia-aprov.cod-lotacao 
                           tt-mla-hierarquia-aprov.cod-tip-doc = mla-hierarquia-aprov.cod-tip-doc 
                           tt-mla-hierarquia-aprov.seq-aprov   = mla-hierarquia-aprov.seq-aprov   
                           tt-mla-hierarquia-aprov.log-depend  = mla-hierarquia-aprov.log-depend  
                           tt-mla-hierarquia-aprov.cod-usuar   = mla-hierarquia-aprov.cod-usuar.  
                END.
            END.

            IF AVAIL tt-mla-hierarquia-aprov THEN
               ASSIGN l-achou-faixa = YES           
                      c-hierarquia-faixa-cod-usuar  = tt-mla-hierarquia-aprov.cod-usuar
                      l-hierarquia-faixa-log-depend = tt-mla-hierarquia-aprov.log-depend
                      i-hierarquia-faixa-seq-aprov  = tt-mla-hierarquia-aprov.seq-aprov.
    
           IF l-achou-faixa AND AVAIL tt-mla-hierarquia-aprov THEN DO:
               CREATE b-mla-doc-pend-aprov.
               ASSIGN b-mla-doc-pend-aprov.ep-codigo            = mla-doc-pend-aprov.ep-codigo
                      b-mla-doc-pend-aprov.cod-estabel          = mla-doc-pend-aprov.cod-estabel
                      b-mla-doc-pend-aprov.chave-doc            = mla-doc-pend-aprov.chave-doc
                      b-mla-doc-pend-aprov.cod-lotacao-doc      = mla-doc-pend-aprov.cod-lotacao-doc
                      b-mla-doc-pend-aprov.cod-lotacao-trans    = mla-doc-pend-aprov.cod-lotacao-trans
                      b-mla-doc-pend-aprov.cod-tip-aprov        = mla-doc-pend-aprov.cod-tip-aprov
                      b-mla-doc-pend-aprov.cod-tip-doc          = mla-doc-pend-aprov.cod-tip-doc
                      b-mla-doc-pend-aprov.cod-usuar            = c-hierarquia-faixa-cod-usuar /*c-hierarquia-aprov-cod-usuar*/
                      b-mla-doc-pend-aprov.cod-usuar-doc        = mla-doc-pend-aprov.cod-usuar-doc
                      b-mla-doc-pend-aprov.cod-usuar-trans      = mla-doc-pend-aprov.cod-usuar-trans
                      b-mla-doc-pend-aprov.dt-geracao           = TODAY
                      b-mla-doc-pend-aprov.ind-situacao         = 1
                      b-mla-doc-pend-aprov.ind-tip-aprov        = mla-doc-pend-aprov.ind-tip-aprov
                      b-mla-doc-pend-aprov.it-codigo            = mla-doc-pend-aprov.it-codigo
                      b-mla-doc-pend-aprov.mo-codigo            = mla-doc-pend-aprov.mo-codigo
                      b-mla-doc-pend-aprov.motivo-doc           = mla-doc-pend-aprov.motivo-doc
                      b-mla-doc-pend-aprov.num-faixa            = mla-doc-pend-aprov.num-faixa
                      b-mla-doc-pend-aprov.seq-aprov            = i-hierarquia-faixa-seq-aprov
                      b-mla-doc-pend-aprov.valor-doc            = mla-doc-pend-aprov.valor-doc
                      b-mla-doc-pend-aprov.prioridade-aprov     = mla-doc-pend-aprov.prioridade-aprov
                      b-mla-doc-pend-aprov.hora-geracao         = STRING(TIME,"HH:MM:SS":U)
                      b-mla-doc-pend-aprov.char-2               = mla-doc-pend-aprov.char-2
                      OVERLAY(b-mla-doc-pend-aprov.char-1,25,4) = TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)). /*condiá∆o de pagamento*/

               ASSIGN gl-mla-gera-proxima           = YES 
                      gl-mla-email-faixa-hierarquia = YES
                      gEmail-cod-usuar              = c-hierarquia-faixa-cod-usuar
                      r-prox-pend                   = ROWID(b-mla-doc-pend-aprov).
    
                /*************************************************************************/
                /*** IN÷CIO CHAMADA EPC - Cliente: Grendene                            ***/
                /*************************************************************************/
                /*** Prop¢sito: Identificar os pontos onde s∆o geradas pendàncias      ***/
                /*************************************************************************/

                IF c-nom-prog-upc-mg97 <> "" THEN DO:
                    FOR EACH tt-epc
                       WHERE tt-epc.cod-event = "aprovacao-pendente":U:
                        DELETE tt-epc.
                    END.
                
                    /*rowid da tabela mla-doc-pend-aprov*/
                    {include/i-epc200.i2 &CodEvent='"aprovacao-pendente"'
                                         &CodParameter='"TABLE-ROWID"'
                                         &ValueParameter="string(rowid(b-mla-doc-pend-aprov))"}
                                         
                    {include/i-epc201.i "aprovacao-pendente"}
                END.
                /*************************************************************************/
                /*** FIM CHAMADA EPC - Grendene                                        ***/
                /*************************************************************************/

                /*************************************************************************/
                /*** INICIO - INTEGRAÄ«O COM O FLUIG                                   ***/
                /*************************************************************************/
                ASSIGN iNrTransacaoAux = b-mla-doc-pend-aprov.nr-trans.
                /*************************************************************************/
                /*** FIM - INTEGRAÄ«O COM O FLUIG                                   ***/
                /*************************************************************************/

                /**  E-mail's Alternativos
                **/
                IF l-param-log-email-altern THEN DO:

                    EMPTY TEMP-TABLE tt-mla-chave.
                    CREATE tt-mla-chave.
                    ASSIGN i-chave = 0.

                    FOR EACH tt-mla-chave-doc NO-LOCK
                       WHERE tt-mla-chave-doc.cod-tip-doc = b-mla-doc-pend-aprov.cod-tip-doc :
                        ASSIGN i-chave = i-chave + 1
                               tt-mla-chave.valor[i-chave] = SUBSTRING(b-mla-doc-pend-aprov.chave-doc,
                                                                       tt-mla-chave-doc.posicao-ini,
                                                                     ((tt-mla-chave-doc.posicao-fim -
                                                                       tt-mla-chave-doc.posicao-ini) + 1)).
                    END.
                    /* Para o portal do MLA ser† chamada a procedure da pr¢pria BO - Performance */
                    IF gi-mla-origem <> 2 THEN DO:
                        IF NOT VALID-HANDLE(hmla-emails) THEN
                            RUN inbo/boin790.p PERSISTENT SET hmla-emails.

                        RUN setEnviaEmailAltern IN hmla-emails (1, 
                                                                gi-mla-origem,
                                                                c-hierarquia-aprov-cod-usuar,
                                                                ROWID(b-mla-doc-pend-aprov),
                                                                INPUT TABLE tt-mla-chave).
                        IF  VALID-HANDLE(hmla-emails) THEN
                            DELETE PROCEDURE hmla-emails.
                    END.
                    ELSE DO:
                        RUN setEnviaEmailAltern IN THIS-PROCEDURE (1, 
                                                                   c-hierarquia-aprov-cod-usuar,
                                                                   ROWID(b-mla-doc-pend-aprov)).
                    END.
                END.            
    
                RELEASE b-mla-doc-pend-aprov.       
           END.
        END.
    END.
    ELSE /*entra nessa logica somente para documentos 20 - solicitacao de serviáo*/
    IF  l-achou-faixa 
    AND (    l-hierarquia-faixa-log-depend = YES 
         OR (    l-hierarquia-faixa-log-depend = NO  
             AND gde-mla-limite < mla-doc-pend-aprov.valor-doc)) THEN DO:
        
        FIND FIRST tt-mla-hierarquia-aprov 
             WHERE tt-mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
               AND tt-mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
               AND tt-mla-hierarquia-aprov.cod-lotacao = c-lotacao
               AND tt-mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
               AND tt-mla-hierarquia-aprov.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1) NO-LOCK NO-ERROR.
    
        IF NOT AVAIL tt-mla-hierarquia-aprov THEN DO:
            FOR FIRST mla-hierarquia-aprov FIELDS (ep-codigo cod-estabel cod-lotacao cod-tip-doc 
                                                   seq-aprov log-depend cod-usuar) 
                 WHERE mla-hierarquia-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                   AND mla-hierarquia-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
                   AND mla-hierarquia-aprov.cod-lotacao = c-lotacao
                   AND mla-hierarquia-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
                   AND mla-hierarquia-aprov.seq-aprov   = (mla-doc-pend-aprov.seq-aprov + 1) NO-LOCK:
                CREATE tt-mla-hierarquia-aprov.
                ASSIGN tt-mla-hierarquia-aprov.ep-codigo   = mla-hierarquia-aprov.ep-codigo   
                       tt-mla-hierarquia-aprov.cod-estabel = mla-hierarquia-aprov.cod-estabel 
                       tt-mla-hierarquia-aprov.cod-lotacao = mla-hierarquia-aprov.cod-lotacao 
                       tt-mla-hierarquia-aprov.cod-tip-doc = mla-hierarquia-aprov.cod-tip-doc 
                       tt-mla-hierarquia-aprov.seq-aprov   = mla-hierarquia-aprov.seq-aprov   
                       tt-mla-hierarquia-aprov.log-depend  = mla-hierarquia-aprov.log-depend  
                       tt-mla-hierarquia-aprov.cod-usuar   = mla-hierarquia-aprov.cod-usuar.  
            END.
        END.

        IF AVAIL tt-mla-hierarquia-aprov THEN
           ASSIGN l-achou-faixa = YES           
                  c-hierarquia-faixa-cod-usuar  = tt-mla-hierarquia-aprov.cod-usuar
                  l-hierarquia-faixa-log-depend = tt-mla-hierarquia-aprov.log-depend
                  i-hierarquia-faixa-seq-aprov  = tt-mla-hierarquia-aprov.seq-aprov.

       IF l-achou-faixa AND AVAIL tt-mla-hierarquia-aprov THEN DO:
           CREATE b-mla-doc-pend-aprov.
           ASSIGN b-mla-doc-pend-aprov.ep-codigo            = mla-doc-pend-aprov.ep-codigo
                  b-mla-doc-pend-aprov.cod-estabel          = mla-doc-pend-aprov.cod-estabel
                  b-mla-doc-pend-aprov.chave-doc            = mla-doc-pend-aprov.chave-doc
                  b-mla-doc-pend-aprov.cod-lotacao-doc      = mla-doc-pend-aprov.cod-lotacao-doc
                  b-mla-doc-pend-aprov.cod-lotacao-trans    = mla-doc-pend-aprov.cod-lotacao-trans
                  b-mla-doc-pend-aprov.cod-tip-aprov        = mla-doc-pend-aprov.cod-tip-aprov
                  b-mla-doc-pend-aprov.cod-tip-doc          = mla-doc-pend-aprov.cod-tip-doc
                  b-mla-doc-pend-aprov.cod-usuar            = c-hierarquia-faixa-cod-usuar /*c-hierarquia-aprov-cod-usuar*/
                  b-mla-doc-pend-aprov.cod-usuar-doc        = mla-doc-pend-aprov.cod-usuar-doc
                  b-mla-doc-pend-aprov.cod-usuar-trans      = mla-doc-pend-aprov.cod-usuar-trans
                  b-mla-doc-pend-aprov.dt-geracao           = TODAY
                  b-mla-doc-pend-aprov.ind-situacao         = 1
                  b-mla-doc-pend-aprov.ind-tip-aprov        = mla-doc-pend-aprov.ind-tip-aprov
                  b-mla-doc-pend-aprov.it-codigo            = mla-doc-pend-aprov.it-codigo
                  b-mla-doc-pend-aprov.mo-codigo            = mla-doc-pend-aprov.mo-codigo
                  b-mla-doc-pend-aprov.motivo-doc           = mla-doc-pend-aprov.motivo-doc
                  b-mla-doc-pend-aprov.num-faixa            = mla-doc-pend-aprov.num-faixa
                  b-mla-doc-pend-aprov.seq-aprov            = i-hierarquia-faixa-seq-aprov
                  b-mla-doc-pend-aprov.valor-doc            = mla-doc-pend-aprov.valor-doc
                  b-mla-doc-pend-aprov.prioridade-aprov     = mla-doc-pend-aprov.prioridade-aprov
                  b-mla-doc-pend-aprov.hora-geracao         = STRING(TIME,"HH:MM:SS":U)
                  b-mla-doc-pend-aprov.char-2               = mla-doc-pend-aprov.char-2
                  OVERLAY(b-mla-doc-pend-aprov.char-1,25,4) = TRIM(SUBSTRING(mla-doc-pend-aprov.char-1,25,4)). /*condiá∆o de pagamento*/

           ASSIGN gl-mla-gera-proxima           = YES 
                  gl-mla-email-faixa-hierarquia = YES
                  gEmail-cod-usuar              = c-hierarquia-faixa-cod-usuar
                  r-prox-pend                   = ROWID(b-mla-doc-pend-aprov).

            /**  E-mail's Alternativos
            **/
            IF l-param-log-email-altern THEN DO:

                EMPTY TEMP-TABLE tt-mla-chave.
                CREATE tt-mla-chave.
                ASSIGN i-chave = 0.

                FOR EACH tt-mla-chave-doc NO-LOCK
                   WHERE tt-mla-chave-doc.cod-tip-doc = b-mla-doc-pend-aprov.cod-tip-doc :

                    ASSIGN i-chave = i-chave + 1
                           tt-mla-chave.valor[i-chave] = SUBSTRING(b-mla-doc-pend-aprov.chave-doc,
                                                                   tt-mla-chave-doc.posicao-ini,
                                                                 ((tt-mla-chave-doc.posicao-fim -
                                                                   tt-mla-chave-doc.posicao-ini) + 1)).
                END.

                /* Para o portal do MLA ser† chamada a procedure da pr¢pria BO - Performance */
                IF gi-mla-origem <> 2 THEN DO:
                    
                    IF NOT VALID-HANDLE(hmla-emails) THEN
                        RUN inbo/boin790.p PERSISTENT SET hmla-emails.

                    RUN setEnviaEmailAltern IN hmla-emails (1, 
                                                            gi-mla-origem,
                                                            c-hierarquia-aprov-cod-usuar,
                                                            rowid(b-mla-doc-pend-aprov),
                                                            input table tt-mla-chave).
                    IF  VALID-HANDLE(hmla-emails) THEN
                        DELETE PROCEDURE hmla-emails.
                END.
                ELSE DO:
                    RUN setEnviaEmailAltern IN THIS-PROCEDURE (1, 
                                                               c-hierarquia-aprov-cod-usuar,
                                                               rowid(b-mla-doc-pend-aprov)).
                END.
            END.
            RELEASE b-mla-doc-pend-aprov.       
       END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setNotificaUsuar DBOProgram 
PROCEDURE setNotificaUsuar :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-funcao-doc AS CHARACTER                  NO-UNDO.
    DEFINE VARIABLE i-solic-ant  LIKE requisicao.nr-requisicao NO-UNDO.

    ASSIGN c-destinatarios = "" /* Quando feito por lote(mla0301), valor tem que iniciar branco a cada pendencia aprovada/rejeitada */
           c-men-e-mail    = "".

    IF (tt-pendencia.tipo-trans = 1 AND SUBSTRING(tt-mla-tipo-doc-aprov.char-1,1,1) = "Y":U) OR
       (tt-pendencia.tipo-trans = 2 AND SUBSTRING(tt-mla-tipo-doc-aprov.char-1,2,1) = "Y":U) OR 
       (tt-pendencia.tipo-trans = 3 AND SUBSTRING(tt-mla-tipo-doc-aprov.char-1,1,1) = "Y":U) THEN DO:

        IF gi-mla-origem = 2 THEN
            ASSIGN l-exchange = NO.
        ELSE
            ASSIGN l-exchange = l-param-log-exchange.

        /**  Aprovador
        **/
        IF AVAIL mla-usuar-aprov THEN
            ASSIGN l-usuar-aprov       = YES
                   c-usuar-email-aprov = mla-usuar-aprov.e-mail   
                   l-usuar-envia-email = mla-usuar-aprov.envia-email
                   c-usuar-nome-usuar  = mla-usuar-aprov.nome-usuar.

        /**  Transaá∆o
        **/
        FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-trans NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-mla-usuar-aprov THEN DO:

            FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                WHERE b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-trans NO-LOCK: 

                CREATE tt-mla-usuar-aprov.
                ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                       tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                       tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                       tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
            END. 
        END.

        IF AVAIL tt-mla-usuar-aprov THEN
            ASSIGN l-usuar-trans        = YES
                   c-usuar-email-trans  = tt-mla-usuar-aprov.e-mail   
                   l-usuar-recebe-email = tt-mla-usuar-aprov.recebe-email.

        /**  Documento
        **/
        FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-mla-usuar-aprov THEN DO:

            FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                WHERE b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-doc NO-LOCK: 

                CREATE tt-mla-usuar-aprov.
                ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                       tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                       tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                       tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
            END. 
        END.

        IF AVAIL tt-mla-usuar-aprov THEN
            ASSIGN l-usuar-doc        = YES
                   c-usuar-email-doc  = IF tt-mla-usuar-aprov.recebe-email THEN tt-mla-usuar-aprov.e-mail ELSE "".

        IF tt-pendencia.tipo-trans = 2 THEN
            ASSIGN l-notifica-usuar-trans = SUBSTRING(tt-mla-tipo-doc-aprov.char-1,7,1) = "Y":U
                   l-notifica-usuar-doc   = SUBSTRING(tt-mla-tipo-doc-aprov.char-1,8,1) = "Y":U.
            ELSE
            ASSIGN l-notifica-usuar-trans = SUBSTRING(tt-mla-tipo-doc-aprov.char-1,3,1) = "Y":U
                   l-notifica-usuar-doc   = SUBSTRING(tt-mla-tipo-doc-aprov.char-1,4,1) = "Y":U.


        IF  i-cod-erro = 0       AND 
            l-param-log-email    AND  
            l-usuar-aprov        AND 
            l-usuar-trans        AND
            l-usuar-envia-email  AND  
            l-usuar-recebe-email AND 
            c-usuar-email-trans <> "" THEN DO:
            
            FIND FIRST tt-moeda WHERE tt-moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo NO-LOCK NO-ERROR.

            IF NOT AVAIL tt-moeda THEN DO:
                FOR FIRST moeda FIELDS (mo-codigo sigla)
                    WHERE moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo NO-LOCK: 
                    CREATE tt-moeda.
                    ASSIGN tt-moeda.mo-codigo = moeda.mo-codigo
                           tt-moeda.sigla     = moeda.sigla.
                END.
            END.

            IF tt-pendencia.tipo-trans = 2 THEN DO:

                FIND FIRST tt-mla-rej-aprov WHERE tt-mla-rej-aprov.cod-rejeicao = mla-doc-pend-aprov.cod-rejeicao NO-LOCK NO-ERROR.
        
                IF NOT AVAIL tt-mla-rej-aprov THEN DO:
                    FOR FIRST mla-rej-aprov FIELDS (cod-rejeicao des-rejeicao obriga-narrativa log-1)
                         WHERE mla-rej-aprov.cod-rejeicao = mla-doc-pend-aprov.cod-rejeicao NO-LOCK:
                        CREATE tt-mla-rej-aprov.
                        ASSIGN tt-mla-rej-aprov.cod-rejeicao     = mla-rej-aprov.cod-rejeicao       
                               tt-mla-rej-aprov.des-rejeicao     = mla-rej-aprov.des-rejeicao       
                               tt-mla-rej-aprov.obriga-narrativa = mla-rej-aprov.obriga-narrativa
                               tt-mla-rej-aprov.log-1            = mla-rej-aprov.log-1.  
                    END.
                END.

                IF AVAIL tt-mla-rej-aprov THEN
                   ASSIGN c-rej-des-rejeicao = tt-mla-rej-aprov.des-rejeicao.
                /**  Rejeiá∆o
                **/
                RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 26635, INPUT c-tipo-doc-des-tip-doc                  + "~~":U  +
                                                                     mla-doc-pend-aprov.chave-doc            + "~~":U  +
                                                                     STRING(mla-doc-pend-aprov.cod-rejeicao) + " - ":U + 
                                                                     c-rej-des-rejeicao                      + "~~":U  +
                                                                     mla-doc-pend-aprov.narrativa-rej).
            END.                                                    
            ELSE 
                /**  Aprovaá∆o e Reaprovaá∆o
                **/
                RUN utp/ut-msgs.p (INPUT "msg":U, INPUT 26652, INPUT c-tipo-doc-des-tip-doc + "~~":U + mla-doc-pend-aprov.chave-doc).

            ASSIGN c-ass-e-mail = RETURN-VALUE.

            IF tt-pendencia.tipo-trans = 2 THEN DO:

                FIND FIRST tt-mla-rej-aprov WHERE tt-mla-rej-aprov.cod-rejeicao = mla-doc-pend-aprov.cod-rejeicao NO-LOCK NO-ERROR.
        
                IF NOT AVAIL tt-mla-rej-aprov THEN DO:
                    FOR FIRST mla-rej-aprov FIELDS (cod-rejeicao des-rejeicao obriga-narrativa log-1)
                         WHERE mla-rej-aprov.cod-rejeicao = mla-doc-pend-aprov.cod-rejeicao NO-LOCK:
                        CREATE tt-mla-rej-aprov.
                        ASSIGN tt-mla-rej-aprov.cod-rejeicao     = mla-rej-aprov.cod-rejeicao       
                               tt-mla-rej-aprov.des-rejeicao     = mla-rej-aprov.des-rejeicao       
                               tt-mla-rej-aprov.obriga-narrativa = mla-rej-aprov.obriga-narrativa
                               tt-mla-rej-aprov.log-1            = mla-rej-aprov.log-1.  
                    END.
                END.

                IF AVAIL tt-mla-rej-aprov THEN DO:
                   ASSIGN c-rej-des-rejeicao = tt-mla-rej-aprov.des-rejeicao.
                END.
                /**  Rejeiá∆o
                **/
                RUN utp/ut-msgs.p (INPUT "help":U, INPUT 26635, INPUT c-tipo-doc-des-tip-doc + "~~":U +
                                                              mla-doc-pend-aprov.chave-doc + "~~":U +
                                                              tt-moeda.sigla + TRIM(STRING(mla-doc-pend-aprov.valor-doc,"->>>,>>>,>>>,>>>,>>9.99":U)) + "~~":U +
                                                              gc-mla-cod-usuar + " - ":U + c-usuar-nome-usuar + "~~":U +
                                                              STRING(mla-doc-pend-aprov.cod-rejeicao) + " - ":U + c-rej-des-rejeicao + "~~":U +
                                                              mla-doc-pend-aprov.narrativa-rej).
            END.                                                      
            ELSE
                /**  Aprovaá∆o e Reaprovaá∆o
                **/
                RUN utp/ut-msgs.p (INPUT "help":U, INPUT 26652, INPUT c-tipo-doc-des-tip-doc + "~~":U +
                                                              mla-doc-pend-aprov.chave-doc + "~~":U +
                                                              tt-moeda.sigla + TRIM(STRING(mla-doc-pend-aprov.valor-doc,"->>>,>>>,>>>,>>>,>>9.99":U)) + "~~":U +
                                                              gc-mla-cod-usuar + " - ":U + c-usuar-nome-usuar).

            ASSIGN c-men-e-mail = RETURN-VALUE.

            ASSIGN c-men-e-mail = c-men-e-mail + CHR(10).

            IF AVAIL mla-doc-pend-aprov AND
                    (mla-doc-pend-aprov.cod-tip-doc = 1 OR mla-doc-pend-aprov.cod-tip-doc = 2  OR
                     mla-doc-pend-aprov.cod-tip-doc = 3 OR mla-doc-pend-aprov.cod-tip-doc = 4) THEN 
                FOR FIRST tt-mla-chave-doc fields( posicao-ini posicao-fim )  
                    WHERE tt-mla-chave-doc.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK
                 BREAK BY tt-mla-chave-doc.posicao-ini :

                    ASSIGN i-posicao       =  tt-mla-chave-doc.posicao-fim + 1
                           i-nr-requisicao = INT(SUBSTR(mla-doc-pend-aprov.chave-doc,tt-mla-chave-doc.posicao-ini,
                                                      ((tt-mla-chave-doc.posicao-fim -
                                                        tt-mla-chave-doc.posicao-ini) + 1))).

                     FOR FIRST btt-mla-chave-doc FIELDS( posicao-ini posicao-fim )   
                         WHERE btt-mla-chave-doc.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc  
                           AND btt-mla-chave-doc.posicao-ini = i-posicao              NO-LOCK
                      BREAK BY btt-mla-chave-doc.posicao-ini :
                         ASSIGN i-posicao   =  btt-mla-chave-doc.posicao-fim + 1
                                i-sequencia = INT(SUBSTR(mla-doc-pend-aprov.chave-doc,btt-mla-chave-doc.posicao-ini,
                                                       ((btt-mla-chave-doc.posicao-fim -
                                                         btt-mla-chave-doc.posicao-ini) + 1))).

                     END.

                     FOR FIRST btt-mla-chave-doc FIELDS( posicao-ini posicao-fim ) 
                         WHERE btt-mla-chave-doc.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc  
                           AND btt-mla-chave-doc.posicao-ini = i-posicao              NO-LOCK
                      BREAK BY btt-mla-chave-doc.posicao-ini:
                        ASSIGN c-it-codigo = SUBSTR(mla-doc-pend-aprov.chave-doc,btt-mla-chave-doc.posicao-ini,
                                                  ((btt-mla-chave-doc.posicao-fim -
                                                    btt-mla-chave-doc.posicao-ini) + 1)).

                     END.
                END. 

            EMPTY TEMP-TABLE tt-item.

            IF mla-doc-pend-aprov.cod-tip-doc = 2 OR mla-doc-pend-aprov.cod-tip-doc = 4 THEN DO:

               FOR EACH it-requisicao FIELDS (nr-requisicao it-codigo qt-requisitada narrativa)
                  WHERE it-requisicao.nr-requisicao = i-nr-requisicao NO-LOCK:

                    FIND FIRST tt-item WHERE tt-item.it-codigo = it-requisicao.it-codigo NO-LOCK NO-ERROR.
        
                    IF NOT AVAIL tt-item THEN DO:
                        FOR FIRST item FIELD(it-codigo desc-item fm-codigo) where
                            item.it-codigo = it-requisicao.it-codigo NO-LOCK:
        
                            CREATE tt-item.
                            ASSIGN tt-item.it-codigo = item.it-codigo
                                   tt-item.desc-item = item.desc-item
                                   tt-item.fm-codigo = item.fm-codigo.
                        END.
                    END.

                    IF c-lbl-liter-item = "" THEN DO:
                        {utp/ut-liter.i "Item" *}
                        ASSIGN c-lbl-liter-item = RETURN-VALUE.
                    END.
                    IF c-lbl-liter-qtd = "" THEN DO:
                        {utp/ut-liter.i "Qtde" *}
                        ASSIGN c-lbl-liter-qtd = RETURN-VALUE.
                    END.


                   ASSIGN c-men-e-mail = c-men-e-mail + c-lbl-liter-item + ": ":U + it-requisicao.it-codigo + " - ":U + tt-item.desc-item + CHR(10) +
                                                        c-lbl-liter-qtd  + ": ":U + STRING(it-requisicao.qt-requisitada,'>>>>>,>>>,>>9.9999':U) + CHR(10) +
                                                        SUBSTRING(it-requisicao.narrativa,1,76) + CHR(10) + CHR(10).
               END.
            END.

            IF mla-doc-pend-aprov.cod-tip-doc = 1 OR mla-doc-pend-aprov.cod-tip-doc = 3 THEN DO:

               FOR EACH it-requisicao FIELDS (nr-requisicao it-codigo qt-requisitada narrativa)
                  WHERE it-requisicao.nr-requisicao = i-nr-requisicao
                    AND it-requisicao.sequencia     = i-sequencia
                    AND it-requisicao.it-codigo     = c-it-codigo NO-LOCK:

                    FIND FIRST tt-item WHERE tt-item.it-codigo = it-requisicao.it-codigo NO-LOCK NO-ERROR.
        
                    IF NOT AVAIL tt-item THEN DO:
                        FOR FIRST ITEM FIELD(it-codigo desc-item fm-codigo) where
                            item.it-codigo = it-requisicao.it-codigo NO-LOCK:
        
                            CREATE tt-item.
                            ASSIGN tt-item.it-codigo = ITEM.it-codigo
                                   tt-item.desc-item = ITEM.desc-item
                                   tt-item.fm-codigo = ITEM.fm-codigo.
                        END.
                    END.

                    IF c-lbl-liter-item = "" THEN DO:
                        {utp/ut-liter.i "Item" *}
                        ASSIGN c-lbl-liter-item = RETURN-VALUE.
                    END.
                    IF c-lbl-liter-qtd = "" THEN DO:
                        {utp/ut-liter.i "Qtde" *}
                        ASSIGN c-lbl-liter-qtd = RETURN-VALUE.
                    END.

                   ASSIGN c-men-e-mail = c-men-e-mail + c-lbl-liter-item + ": ":U + it-requisicao.it-codigo + " - ":U + tt-item.desc-item + CHR(10) +
                                                        c-lbl-liter-qtd  + ": ":U + STRING(it-requisicao.qt-requisitada,'>>>>>,>>>,>>9.9999':U) + CHR(10) +
                                                        it-requisicao.narrativa + CHR(10) + CHR(10).
               END.
            END.

            ASSIGN c-funcao-doc = "AED_motivo_doc_":U + STRING(mla-doc-pend-aprov.cod-tip-doc).

            IF CAN-FIND(funcao WHERE funcao.cd-funcao = c-funcao-doc AND funcao.ativo) THEN DO:

                IF tt-pendencia.tipo-trans = 2 THEN
                    ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + "Narrativa Rejeiá∆o:":U + mla-doc-pend-aprov.narrativa-rej + CHR(10).
                ELSE
                    ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + "Narrativa Aprovaá∆o:":U + mla-doc-pend-aprov.narrativa-apr + CHR(10).
            END.

            IF c-param-compl-email <> "" THEN
                ASSIGN c-men-e-mail = c-men-e-mail + CHR(10) + TRIM(c-param-compl-email).

            IF l-usuar-trans AND l-usuar-aprov THEN DO:

                IF (SUBSTRING(tt-mla-tipo-doc-aprov.char-1,3,1) = "Y":U OR
                    SUBSTRING(tt-mla-tipo-doc-aprov.char-1,7,1) = "Y":U) AND l-notifica-usuar-trans THEN  /* Envia notificaá∆o para uru†rio da transaá∆o*/
                    ASSIGN c-destinatarios = c-usuar-email-trans.

                IF (SUBSTRING(tt-mla-tipo-doc-aprov.char-1,4,1) = "Y":U OR
                    SUBSTRING(tt-mla-tipo-doc-aprov.char-1,8,1) = "Y":U)  AND l-notifica-usuar-doc THEN DO: /* Envia notificaá∆o para uru†rio do documento*/

                    LOG-MANAGER:WRITE-MESSAGE (">>> Notifica Usuarios (Transacao/Documento)":U) NO-ERROR.

                    IF c-destinatarios = "" THEN 
                        ASSIGN c-destinatarios = c-usuar-email-doc.
                    ELSE DO:
                        IF INDEX(c-destinatarios, c-usuar-email-doc) = 0 THEN
                            ASSIGN c-destinatarios = c-destinatarios + ",":U + c-usuar-email-doc.
                    END.
                END.
            END.
            
            /* Envia notificaá∆o para todos aprovadores envolvidos */
            IF (tt-pendencia.tipo-trans <> 2 AND SUBSTRING(tt-mla-tipo-doc-aprov.char-1,5,1) = "Y":U) OR
               (tt-pendencia.tipo-trans = 2 AND SUBSTRING(tt-mla-tipo-doc-aprov.char-1,9,1) = "Y":U) THEN DO:

                ASSIGN i-cont = 0
                       l-todos-aprovadores = NO.

                IF  (tt-pendencia.tipo-trans = 1 OR tt-pendencia.tipo-trans = 3) 
                AND (SUBSTRING(tt-mla-tipo-doc-aprov.char-1,6,1) = "Y":U OR SUBSTRING(tt-mla-tipo-doc-aprov.char-1,5,1) = "Y":U) THEN 
                    ASSIGN l-todos-aprovadores = yes.
                ELSE               
                IF  tt-pendencia.tipo-trans = 2 
                AND (SUBSTRING(tt-mla-tipo-doc-aprov.char-1,10,1) = "Y":U OR SUBSTRING(tt-mla-tipo-doc-aprov.char-1,9,1) = "Y":U) THEN 
                    ASSIGN l-todos-aprovadores = yes. 

                ASSIGN c-lista-email-aprovadores = "".
                FOR EACH b-mla-doc-pend-aprov 
                   WHERE b-mla-doc-pend-aprov.ep-codigo    = tt-pendencia.ep-codigo
                     AND b-mla-doc-pend-aprov.cod-estabel  = tt-pendencia.cod-estabel
                     AND b-mla-doc-pend-aprov.cod-tip-doc  = tt-pendencia.cod-tip-doc
                     AND b-mla-doc-pend-aprov.chave-doc    = tt-pendencia.chave-doc 
                     AND b-mla-doc-pend-aprov.ind-situacao = 2
                     AND b-mla-doc-pend-aprov.historico    = NO NO-LOCK /*USE-INDEX pend-18 BY mla-doc-pend-aprov.nr-trans*/ : 

                    ASSIGN i-cont = i-cont + 1.

                    FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.

                    IF NOT AVAIL tt-mla-usuar-aprov THEN DO:

                        FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                            WHERE b-mla-usuar-aprov.cod-usuar = b-mla-doc-pend-aprov.cod-usuar NO-LOCK: END.

                        IF AVAIL b-mla-usuar-aprov THEN DO:
                            CREATE tt-mla-usuar-aprov.
                            ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                                   tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                                   tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                                   tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
                        END. 
                    END.

                    ASSIGN c-usuar-email-lista-aprov = IF AVAIL mla-usuar-aprov AND mla-usuar-aprov.recebe-email THEN mla-usuar-aprov.e-mail ELSE "".

                    IF l-todos-aprovadores THEN DO:
                        IF c-lista-email-aprovadores <> "" THEN DO:
                            IF INDEX(c-lista-email-aprovadores, c-usuar-email-aprov) = 0 THEN
                                ASSIGN c-lista-email-aprovadores = c-lista-email-aprovadores + ",":U + c-usuar-email-aprov.
                        END.
                        ELSE 
                            ASSIGN c-lista-email-aprovadores = c-usuar-email-lista-aprov.
                    END.
                    ELSE DO:
                        IF NUM-ENTRIES(gc-mla-notifica,"|":U) >= (i-cont + 2) THEN DO:
                            IF ENTRY(i-cont + 2,gc-mla-notifica,"|":U) = "Y":U and i-cont < 3 THEN DO:
                                IF c-lista-email-aprovadores <> "" THEN DO:
                                    IF INDEX(c-lista-email-aprovadores, c-usuar-email-aprov) = 0 THEN
                                        ASSIGN c-lista-email-aprovadores = c-lista-email-aprovadores + ",":U + c-usuar-email-aprov.
                                END.
                                ELSE 
                                    ASSIGN c-lista-email-aprovadores = c-usuar-email-lista-aprov.
                            END.
                        END.
                    END.
                END.

                IF c-lista-email-aprovadores <> "" THEN DO:
                    
                    LOG-MANAGER:WRITE-MESSAGE (">>> Notifica Aprovadores":U) NO-ERROR.

                    IF c-destinatarios = "" THEN 
                        ASSIGN c-destinatarios = c-lista-email-aprovadores.
                    ELSE DO:
                        IF INDEX(c-destinatarios, c-lista-email-aprovadores) = 0 THEN
                            ASSIGN c-destinatarios = c-destinatarios + ",":U + c-lista-email-aprovadores. 
                    END.
                END.
            END.

            IF c-destinatarios <> "" THEN DO:  
                LOG-MANAGER:WRITE-MESSAGE (">>> Notifica Usuarios (Transacao/Documento)":U) NO-ERROR.                
                EMPTY TEMP-TABLE tt-envio2.

                CREATE tt-envio2.
                ASSIGN tt-envio2.versao-integracao = 1
                       tt-envio2.exchange    = l-exchange
                       tt-envio2.destino     = c-destinatarios
                       tt-envio2.assunto     = c-ass-e-mail
                       tt-envio2.mensagem    = c-men-e-mail
                       tt-envio2.importancia = 2
                       tt-envio2.log-enviada = NO
                       tt-envio2.log-lida    = NO
                       tt-envio2.acomp       = NO
                       tt-envio2.arq-anexo   = "".

                IF NOT l-exchange THEN
                    ASSIGN tt-envio2.servidor = c-param-servidor-email
                           tt-envio2.porta    = i-param-porta-email.

                IF c-usuar-email-aprov <> "" THEN
                   ASSIGN tt-envio2.remetente = c-usuar-email-aprov.

                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.exchange : ":U + STRING(tt-envio2.exchange) ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.servidor : ":U + STRING(tt-envio2.servidor) ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.porta    : ":U + STRING(tt-envio2.porta)    ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.remetente: ":U + STRING(tt-envio2.remetente)) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.destino  : ":U + STRING(tt-envio2.destino)  ) NO-ERROR.
                LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.assunto  : ":U + STRING(tt-envio2.assunto)  ) NO-ERROR.
                
                RUN pi-cria-tt-mensagem IN THIS-PROCEDURE(INPUT TABLE tt-envio2,
                                                          OUTPUT TABLE tt-mensagem).
                
                RUN pi-execute2  IN h-utapi019 (INPUT  TABLE tt-envio2,                   
                                                INPUT  TABLE tt-mensagem,
                                                OUTPUT TABLE tt-erros).
            END.
            /****** MANDA E-MAIL PARA USUµRIO DA SOLICITAÄ«O DE COMPRA RELACIONADA AO PEDIDO QUE ESTµ SENDO APROVADO **********/
            IF mla-doc-pend-aprov.cod-tip-doc = 7 THEN DO:
                FIND FIRST pedido-compr 
                     WHERE pedido-compr.num-pedido = integer(mla-doc-pend-aprov.chave-doc) NO-LOCK NO-ERROR.

                IF AVAIL pedido-compr THEN DO:
                    FOR EACH ordem-compra
                        WHERE ordem-compra.num-pedido = pedido-compr.num-pedido NO-LOCK:
                        
                        IF i-solic-ant <> ordem-compra.nr-requisicao THEN DO:
                            
                            ASSIGN i-solic-ant = ordem-compra.nr-requisicao.
                            
                            FIND FIRST requisicao 
                                 WHERE requisicao.nr-requisicao = ordem-compra.nr-requisicao NO-LOCK NO-ERROR.
    
                            IF AVAIL requisicao THEN DO:
                                
                                LOG-MANAGER:WRITE-MESSAGE (">>> Notifica Solicitantes":U) NO-ERROR.
    
                                ASSIGN de-total-requis = 0.
                                FOR EACH it-requisicao WHERE it-requisicao.nr-requisicao = requisicao.nr-requisicao NO-LOCK:
                                    ASSIGN de-total-requis = de-total-requis + it-requisicao.val-item.
                                END.
    
                                ASSIGN c-men-e-mail = c-men-e-mail 
                                                    + CHR(10) 
                                                    + "Referente a  Solicitaá∆o de Compra:":U 
                                                    + STRING(requisicao.nr-requisicao) 
                                                    + " Valor:":U 
                                                    + TRIM(STRING(de-total-requis,">>>,>>>,>>>,>>>,>>9.9999":U)).
    
                                FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = requisicao.nome-abrev NO-LOCK NO-ERROR.
                
                                IF NOT AVAIL tt-mla-usuar-aprov THEN DO:
                
                                    FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                                        WHERE b-mla-usuar-aprov.cod-usuar = requisicao.nome-abrev NO-LOCK: END.
                
                                    IF AVAIL b-mla-usuar-aprov THEN DO:
                                        CREATE tt-mla-usuar-aprov.
                                        ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                                               tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                                               tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                                               tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
                                    END. 
                                END.
    
                                ASSIGN c-usuar-email-requis = IF AVAIL tt-mla-usuar-aprov AND tt-mla-usuar-aprov.recebe-email THEN tt-mla-usuar-aprov.e-mail ELSE "".
    
                                IF c-usuar-email-requis <> "" THEN DO:
                                    EMPTY TEMP-TABLE tt-envio2.
    
                                    CREATE tt-envio2.
                                    ASSIGN tt-envio2.versao-integracao = 1
                                           tt-envio2.exchange    = l-exchange
                                           tt-envio2.destino     = c-usuar-email-requis
                                           tt-envio2.assunto     = c-ass-e-mail
                                           tt-envio2.mensagem    = c-men-e-mail
                                           tt-envio2.importancia = 2
                                           tt-envio2.log-enviada = NO
                                           tt-envio2.log-lida    = NO
                                           tt-envio2.acomp       = NO
                                           tt-envio2.arq-anexo   = "".
    
                                    IF NOT l-exchange THEN 
                                        ASSIGN tt-envio2.servidor = c-param-servidor-email
                                               tt-envio2.porta    = i-param-porta-email.
    
                                    IF c-usuar-email-aprov <> "" THEN
                                       ASSIGN tt-envio2.remetente = c-usuar-email-aprov.
    
                                    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.exchange : ":U + STRING(tt-envio2.exchange) ) NO-ERROR.
                                    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.servidor : ":U + STRING(tt-envio2.servidor) ) NO-ERROR.
                                    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.porta    : ":U + STRING(tt-envio2.porta)    ) NO-ERROR.
                                    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.remetente: ":U + STRING(tt-envio2.remetente)) NO-ERROR.
                                    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.destino  : ":U + STRING(tt-envio2.destino)  ) NO-ERROR.
                                    LOG-MANAGER:WRITE-MESSAGE (">>> tt-envio2.assunto  : ":U + STRING(tt-envio2.assunto)  ) NO-ERROR.
    
    
                                    RUN pi-cria-tt-mensagem IN THIS-PROCEDURE(INPUT TABLE tt-envio2,
                                                                              OUTPUT TABLE tt-mensagem).
    
                                    RUN pi-execute2 IN h-utapi019 (INPUT  TABLE tt-envio2,                   
                                                                   INPUT  TABLE tt-mensagem,
                                                                   OUTPUT TABLE tt-erros).
    
    
                                END.
                            END.
                        END. /* i-solic-ant <> ordem-compra.nr-requisicao */
                    END. /* For each */
                END. /* Avail pedido-compr */
            END. /*Doc 7*/
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setProcuraPend DBOProgram 
PROCEDURE setProcuraPend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-cod-erro   AS INTEGER   NO-UNDO.
    DEFINE OUTPUT PARAMETER p-desc-erro  AS CHARACTER NO-UNDO.

    /**  Procura pendància pela transaá∆o
    **/
    FIND FIRST mla-doc-pend-aprov 
         WHERE mla-doc-pend-aprov.nr-trans     = tt-pendencia.nr-trans 
           AND mla-doc-pend-aprov.ind-situacao = 1 
           AND mla-doc-pend-aprov.historico    = NO NO-LOCK NO-ERROR.

    LOG-MANAGER:WRITE-MESSAGE (">>> Achou pendencia pela transacao?: ":U + STRING(AVAILABLE mla-doc-pend-aprov)) NO-ERROR.

    IF  AVAIL mla-doc-pend-aprov AND mla-doc-pend-aprov.cod-usuar <> gc-mla-cod-usuar THEN DO:
        /**  Permiss∆o do aprovador alternativo
        **/
        FIND FIRST tt-mla-usuar-aprov-altern
             WHERE tt-mla-usuar-aprov-altern.cod-usuar        = mla-doc-pend-aprov.cod-usuar
               AND tt-mla-usuar-aprov-altern.cod-usuar-altern = gc-mla-cod-usuar
               AND tt-mla-usuar-aprov-altern.validade-ini    <= TODAY
               AND tt-mla-usuar-aprov-altern.validade-fim    >= TODAY NO-LOCK NO-ERROR. 

        IF NOT AVAIL tt-mla-usuar-aprov-altern THEN DO:
            FOR FIRST mla-usuar-aprov-altern FIELDS (cod-usuar cod-usuar-altern validade-ini validade-fim)
                 WHERE mla-usuar-aprov-altern.cod-usuar        = mla-doc-pend-aprov.cod-usuar
                   AND mla-usuar-aprov-altern.cod-usuar-altern = gc-mla-cod-usuar
                   AND mla-usuar-aprov-altern.validade-ini    <= TODAY
                   AND mla-usuar-aprov-altern.validade-fim    >= TODAY NO-LOCK: 
                CREATE tt-mla-usuar-aprov-altern.
                ASSIGN tt-mla-usuar-aprov-altern.cod-usuar        = mla-usuar-aprov-altern.cod-usuar        
                       tt-mla-usuar-aprov-altern.cod-usuar-altern = mla-usuar-aprov-altern.cod-usuar-altern 
                       tt-mla-usuar-aprov-altern.validade-ini     = mla-usuar-aprov-altern.validade-ini     
                       tt-mla-usuar-aprov-altern.validade-fim     = mla-usuar-aprov-altern.validade-fim.     

            END.
        END.

        IF NOT AVAIL tt-mla-usuar-aprov-altern AND NOT l-mestre THEN DO:
            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT tt-pendencia.cod-tip-doc,
                                                   INPUT tt-pendencia.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            IF c-lbl-liter-usua-alter-sem-per = "":U THEN DO:
                {utp/ut-liter.i "Usu†rio_alternativo_sem_permiss∆o_para_movimentar_o_documento" *}
                ASSIGN c-lbl-liter-usua-alter-sem-per = TRIM(RETURN-VALUE).
            END.
                
            ASSIGN c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.

            {method/svc/errors/inserr.i &ErrorNumber="32504"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="string(tt-pendencia.cod-tip-doc) + c-chave-mla + '~~~~' + 
                                                          string(tt-pendencia.ep-codigo)  + '~~~~' + 
                                                          tt-pendencia.cod-estabel + '~~~~' + 
                                                          string(tt-pendencia.cod-tip-doc) + '~~~~' + 
                                                          c-lbl-liter-usua-alter-sem-per + ' ' "}
            RETURN "NOK":U.
        END.
    END.

    /**  Procura pendància pelo aprovador
    **/
    IF NOT AVAILABLE mla-doc-pend-aprov THEN DO:
        FIND FIRST mla-doc-pend-aprov NO-LOCK 
             WHERE mla-doc-pend-aprov.ep-codigo    = tt-pendencia.ep-codigo
               AND mla-doc-pend-aprov.cod-estabel  = tt-pendencia.cod-estabel
               AND mla-doc-pend-aprov.cod-tip-doc  = tt-pendencia.cod-tip-doc 
               AND mla-doc-pend-aprov.chave-doc    = tt-pendencia.chave-doc
               AND mla-doc-pend-aprov.ind-situacao = 1             
               AND mla-doc-pend-aprov.cod-usuar    = gc-mla-cod-usuar
               AND mla-doc-pend-aprov.historico    = NO NO-ERROR.

        LOG-MANAGER:WRITE-MESSAGE (">>> Achou pendencia pelo aprovador?: ":U + STRING(AVAILABLE mla-doc-pend-aprov)) NO-ERROR.
    END.

    /**  Procura pendància, independente do aprovador
    **/
    IF NOT AVAILABLE mla-doc-pend-aprov THEN DO:
        FIND FIRST mla-doc-pend-aprov NO-LOCK 
             WHERE mla-doc-pend-aprov.ep-codigo    = tt-pendencia.ep-codigo
             AND   mla-doc-pend-aprov.cod-estabel  = tt-pendencia.cod-estabel
             AND   mla-doc-pend-aprov.cod-tip-doc  = tt-pendencia.cod-tip-doc 
             AND   mla-doc-pend-aprov.chave-doc    = tt-pendencia.chave-doc
             AND   mla-doc-pend-aprov.ind-situacao = 1             
             AND   mla-doc-pend-aprov.historico    = NO NO-ERROR.

        LOG-MANAGER:WRITE-MESSAGE (">>> Achou pendencia independente do aprovador?: ":U + STRING(AVAILABLE mla-doc-pend-aprov)) NO-ERROR.
    END.

    /**  Procura pendància, independente da situaá∆o
    **/
    IF  NOT AVAILABLE mla-doc-pend-aprov THEN DO:
        FIND FIRST mla-doc-pend-aprov NO-LOCK 
             WHERE mla-doc-pend-aprov.ep-codigo    = tt-pendencia.ep-codigo
               AND mla-doc-pend-aprov.cod-estabel  = tt-pendencia.cod-estabel
               AND mla-doc-pend-aprov.cod-tip-doc  = tt-pendencia.cod-tip-doc 
               AND mla-doc-pend-aprov.chave-doc    = tt-pendencia.chave-doc
               AND mla-doc-pend-aprov.cod-usuar    = gc-mla-cod-usuar
               AND mla-doc-pend-aprov.ind-situacao <> 1
               AND mla-doc-pend-aprov.aprov-auto   = YES
               AND mla-doc-pend-aprov.historico    = NO NO-ERROR.

        LOG-MANAGER:WRITE-MESSAGE (">>> Achou pendencia independente da situacao?: ":U + STRING(AVAILABLE mla-doc-pend-aprov)) NO-ERROR.

        IF  AVAIL(mla-doc-pend-aprov) THEN DO:
            ASSIGN p-cod-erro = 999996. 

            IF mla-doc-pend-aprov.cod-usuar-altern <> "" THEN DO:

                FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-altern NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-mla-usuar-aprov THEN DO:

                    FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                        WHERE b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar-altern NO-LOCK: 

                        CREATE tt-mla-usuar-aprov.
                        ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                               tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                               tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                               tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
                    END. 
                END.

                ASSIGN c-usuar-nome-usuar = IF AVAIL tt-mla-usuar-aprov THEN tt-mla-usuar-aprov.nome-usuar ELSE "".
            
                IF c-lbl-liter-doc-aprov-auto = "" THEN DO:
                    {utp/ut-liter.i "Documento_Aprovado_Automaticamente_pelo_usu†rio"}
                    ASSIGN c-lbl-liter-doc-aprov-auto = RETURN-VALUE.
                END.
                IF c-lbl-liter-no-dia = "" THEN DO:
                    {utp/ut-liter.i "no_dia"}
                    ASSIGN c-lbl-liter-no-dia = RETURN-VALUE.
                END.

                IF AVAIL tt-mla-usuar-aprov THEN DO:
                   ASSIGN p-desc-erro = c-lbl-liter-doc-aprov-auto
                                        + mla-doc-pend-aprov.cod-usuar-altern
                                        + " (":U
                                        + c-usuar-nome-usuar
                                        + ")":U
                                        + " " + c-lbl-liter-no-dia + " "
                                        + STRING(mla-doc-pend-aprov.dt-aprova,"99/99/9999":U).
                   {method/svc/errors/inserr.i &ErrorNumber="34026"
                                               &ErrorType="EMS":U
                                               &ErrorSubType="ERROR":U
                                               &ErrorParameters="mla-doc-pend-aprov.cod-usuar + ' (' + c-usuar-nome-usuar + ')' + '~~~~' + 
                                                                 STRING(mla-doc-pend-aprov.dt-aprova,'99/99/9999') "}

                END.
            END.
            ELSE DO:
                FIND FIRST tt-mla-usuar-aprov WHERE tt-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.

                IF NOT AVAIL tt-mla-usuar-aprov THEN DO:

                    FOR FIRST b-mla-usuar-aprov FIELDS (cod-usuar nome-usuar e-mail recebe-email)
                        WHERE b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar NO-LOCK: END.

                    IF AVAIL b-mla-usuar-aprov THEN DO:
                        CREATE tt-mla-usuar-aprov.
                        ASSIGN tt-mla-usuar-aprov.cod-usuar    = b-mla-usuar-aprov.cod-usuar      
                               tt-mla-usuar-aprov.nome-usuar   = b-mla-usuar-aprov.nome-usuar     
                               tt-mla-usuar-aprov.e-mail       = b-mla-usuar-aprov.e-mail         
                               tt-mla-usuar-aprov.recebe-email = b-mla-usuar-aprov.recebe-email. 
                    END. 
                END.

                ASSIGN c-usuar-nome-usuar = IF AVAIL tt-mla-usuar-aprov THEN tt-mla-usuar-aprov.nome-usuar ELSE "".

                 IF c-lbl-liter-doc-aprov-auto = "" THEN DO:
                    {utp/ut-liter.i "Documento_Aprovado_Automaticamente_pelo_usu†rio"}
                    ASSIGN c-lbl-liter-doc-aprov-auto = RETURN-VALUE.
                END.
                IF c-lbl-liter-no-dia = "" THEN DO:
                    {utp/ut-liter.i "no_dia"}
                    ASSIGN c-lbl-liter-no-dia = RETURN-VALUE.
                END.

                IF AVAIL tt-mla-usuar-aprov THEN DO:
                   ASSIGN p-desc-erro = c-lbl-liter-doc-aprov-auto
                                        + mla-doc-pend-aprov.cod-usuar
                                        + " (":U
                                        + c-usuar-nome-usuar
                                        + ")":U
                                        + " " + c-lbl-liter-no-dia + " "
                                        + STRING(mla-doc-pend-aprov.dt-aprova,"99/99/9999":U).
                   {method/svc/errors/inserr.i &ErrorNumber="34026"
                                               &ErrorType="EMS":U
                                               &ErrorSubType="ERROR":U
                                               &ErrorParameters="mla-doc-pend-aprov.cod-usuar + ' (' + c-usuar-nome-usuar + ')' + '~~~~' + 
                                                                 STRING(mla-doc-pend-aprov.dt-aprova,'99/99/9999') "}

                END.
            END.
            RETURN "NOK":U.
        END.
    END.

    ASSIGN gr-mla-rowid-pend = ROWID(mla-doc-pend-aprov).


    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setReanalisePend DBOProgram 
PROCEDURE setReanalisePend :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  tt-pendencia.tipo-trans = 2 THEN DO:

        FIND FIRST tt-mla-rej-aprov WHERE tt-mla-rej-aprov.cod-rejeicao = gi-mla-cod-rejeicao NO-LOCK NO-ERROR.

        IF NOT AVAIL tt-mla-rej-aprov THEN DO:
            FOR FIRST mla-rej-aprov FIELDS (cod-rejeicao des-rejeicao obriga-narrativa log-1)
                 WHERE mla-rej-aprov.cod-rejeicao = gi-mla-cod-rejeicao NO-LOCK:
                CREATE tt-mla-rej-aprov.
                ASSIGN tt-mla-rej-aprov.cod-rejeicao     = mla-rej-aprov.cod-rejeicao       
                       tt-mla-rej-aprov.des-rejeicao     = mla-rej-aprov.des-rejeicao       
                       tt-mla-rej-aprov.obriga-narrativa = mla-rej-aprov.obriga-narrativa
                       tt-mla-rej-aprov.log-1            = mla-rej-aprov.log-1.  
            END.
        END.

        IF  NOT AVAIL tt-mla-rej-aprov OR  (AVAIL tt-mla-rej-aprov AND NOT tt-mla-rej-aprov.log-1) THEN DO:
            RETURN "NOK":U.
        END.

        IF  NOT l-rej-log-1 THEN DO:
            RETURN "NOK":U.
        END.             

        FIND FIRST mla-doc-pend-aprov 
             WHERE ROWID(mla-doc-pend-aprov) = gr-mla-rowid-pend  NO-LOCK NO-ERROR.

        IF AVAIL mla-doc-pend-aprov THEN DO:
            
            {lap/mlaapi001.i01}
            CREATE tt-mla-chave.
            ASSIGN i-chave = 0.

            FOR EACH  tt-mla-chave-doc 
                WHERE tt-mla-chave-doc.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK:
                ASSIGN i-chave = i-chave + 1
                       tt-mla-chave.valor[i-chave] = SUBSTRING(mla-doc-pend-aprov.chave-doc,tt-mla-chave-doc.posicao-ini,
                                                                                          ((tt-mla-chave-doc.posicao-fim -
                                                                                            tt-mla-chave-doc.posicao-ini) + 1)).
            END.        

            FOR EACH  b-mla-doc-pend-aprov 
                WHERE b-mla-doc-pend-aprov.ep-codigo      = mla-doc-pend-aprov.ep-codigo
                  AND b-mla-doc-pend-aprov.cod-estabel    = mla-doc-pend-aprov.cod-estabel
                  AND b-mla-doc-pend-aprov.cod-tip-doc    = mla-doc-pend-aprov.cod-tip-doc   
                  AND b-mla-doc-pend-aprov.chave-doc      = mla-doc-pend-aprov.chave-doc     
                  AND b-mla-doc-pend-aprov.historico      = NO EXCLUSIVE-LOCK:

                IF (b-mla-doc-pend-aprov.ind-situacao  = 2 OR 
                    b-mla-doc-pend-aprov.ind-situacao  = 3 OR 
                    b-mla-doc-pend-aprov.ind-situacao  = 4) THEN DO:
                    ASSIGN b-mla-doc-pend-aprov.historico   = YES
                           b-mla-doc-pend-aprov.motivo-hist = "C¢d. Rejeiá∆o: ":U + STRING(gi-mla-cod-rejeicao) + " - Re-an†lise":U.
                END.
                ELSE 
                    DELETE b-mla-doc-pend-aprov.

            END.

            RUN lap/mlaapi101.p (INPUT ROWID(mla-doc-pend-aprov),
                                 INPUT gi-mla-cod-rejeicao). /* re-an†lise das pendàncias de acordo com o c¢digo de rejeicao */
        END.
        ELSE 
            RETURN "NOK":U.
    END.

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

    /*:T--- Verifica ocorrància de erros ---*/
    IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setTTpendencia DBOProgram 
PROCEDURE setTTpendencia :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice transacao
  Parameters:  

  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pnr-trans  LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.
    DEFINE INPUT  PARAMETER pTipoTrans AS INTEGER                       NO-UNDO.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-pendencia.

    FOR FIRST mla-doc-pend-aprov FIELDS (ep-codigo cod-estabel cod-tip-doc chave-doc dt-geracao cod-usuar)
        WHERE mla-doc-pend-aprov.nr-trans = pnr-trans NO-LOCK: END.

    IF AVAIL mla-doc-pend-aprov then do:
        CREATE tt-pendencia.
        ASSIGN tt-pendencia.tipo-trans  = pTipoTrans
               tt-pendencia.ep-codigo   = mla-doc-pend-aprov.ep-codigo
               tt-pendencia.cod-estabel = mla-doc-pend-aprov.cod-estabel 
               tt-pendencia.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
               tt-pendencia.chave-doc   = mla-doc-pend-aprov.chave-doc 
               tt-pendencia.nr-trans    = pnr-trans
               tt-pendencia.cod-erro    = 0
               tt-pendencia.desc-erro   = ""
               tt-pendencia.cod-usuar   = mla-doc-pend-aprov.cod-usuar
               tt-pendencia.dt-geracao  = mla-doc-pend-aprov.dt-geracao
               tt-pendencia.rowid-pend  = ROWID(mla-doc-pend-aprov).
    END.

    RETURN "OK":U.

END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setUsoRejeicaoPadrao DBOProgram 
PROCEDURE setUsoRejeicaoPadrao :
/*------------------------------------------------------------------------------
  Purpose: Informa se deve usar o c¢digo de rejeiá∆o padr∆o
  Parameters: pUsaRejeicaoPadrao: logical
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pUsaRejeicaoPadrao AS LOGICAL NO-UNDO.
    
    ASSIGN lUsaRejeicaoPadrao = pUsaRejeicaoPadrao.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaLimite DBOProgram 
PROCEDURE verificaLimite :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice transacao
  Parameters:  

  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT  PARAMETER l-semlimite  AS LOGICAL   NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-cod-erro   AS INTEGER   NO-UNDO.

    FOR FIRST mla-perm-aprov FIELDS (ep-codigo cod-estabel cod-usuar cod-tip-doc limite-aprov validade-ini validade-fim)
        WHERE  mla-perm-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo
        AND    mla-perm-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
        AND    mla-perm-aprov.cod-usuar   = mla-doc-pend-aprov.cod-usuar
        AND    mla-perm-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc NO-LOCK: END.
    
    IF AVAIL mla-perm-aprov THEN DO:

        ASSIGN de-limite-aprovacao = mla-perm-aprov.limite-aprov.

        IF  mla-perm-aprov.validade-ini > TODAY OR  mla-perm-aprov.validade-fim < TODAY THEN DO:

            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT mla-doc-pend-aprov.cod-tip-doc,
                                                   INPUT mla-doc-pend-aprov.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN p-cod-erro = 54407
                   c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.
            {method/svc/errors/inserr.i &ErrorNumber="54407"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-chave-mla"}

        END.
    END.
    ELSE
        ASSIGN de-limite-aprovacao = 0.

    FIND FIRST tt-item WHERE tt-item.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-item THEN DO:
        FOR FIRST item FIELD(it-codigo desc-item fm-codigo) 
            WHERE item.it-codigo = mla-doc-pend-aprov.it-codigo NO-LOCK:

            CREATE tt-item.
            ASSIGN tt-item.it-codigo = item.it-codigo
                   tt-item.desc-item = item.desc-item
                   tt-item.fm-codigo = item.fm-codigo.
        END.
    END.

    FIND FIRST tt-mla-lim-aprov-fam 
         WHERE tt-mla-lim-aprov-fam.ep-codigo   = mla-doc-pend-aprov.ep-codigo   
           AND tt-mla-lim-aprov-fam.fm-codigo   = tt-item.fm-codigo
           AND tt-mla-lim-aprov-fam.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
           AND tt-mla-lim-aprov-fam.cod-usuar   = mla-doc-pend-aprov.cod-usuar NO-LOCK NO-ERROR.

    IF NOT AVAIL tt-mla-lim-aprov-fam THEN DO:

        FOR FIRST mla-lim-aprov-fam FIELDS (ep-codigo fm-codigo cod-tip-doc cod-usuar limite-aprov) 
            WHERE mla-lim-aprov-fam.ep-codigo   = mla-doc-pend-aprov.ep-codigo   
              AND mla-lim-aprov-fam.fm-codigo   = tt-item.fm-codigo              
              AND mla-lim-aprov-fam.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc 
              AND mla-lim-aprov-fam.cod-usuar   = mla-doc-pend-aprov.cod-usuar NO-LOCK: 

            CREATE tt-mla-lim-aprov-fam.
            ASSIGN tt-mla-lim-aprov-fam.ep-codigo     = mla-lim-aprov-fam.ep-codigo  
                   tt-mla-lim-aprov-fam.fm-codigo     = mla-lim-aprov-fam.fm-codigo  
                   tt-mla-lim-aprov-fam.cod-tip-doc   = mla-lim-aprov-fam.cod-tip-doc
                   tt-mla-lim-aprov-fam.cod-usuar     = mla-lim-aprov-fam.cod-usuar  
                   tt-mla-lim-aprov-fam.limite-aprov  = mla-lim-aprov-fam.limite-aprov.
        END.
    END.

    IF AVAIL tt-mla-lim-aprov-fam THEN DO:
        ASSIGN de-limite-aprovacao = tt-mla-lim-aprov-fam.limite-aprov.
    END.
	/**  EPC para tratar limite de aprovaá∆o do alternativo**/
    RUN lap/mlaapi060.p (INPUT  ROWID(mla-doc-pend-aprov),
                         INPUT  de-limite-aprovacao,
                         OUTPUT de-limite-aprovacao).

    IF  AVAILABLE mla-doc-pend-aprov AND de-limite-aprovacao < mla-doc-pend-aprov.valor-doc THEN DO:

        ASSIGN l-semlimite = YES.
        RUN lap/mla0301b.p (INPUT  ROWID(mla-doc-pend-aprov),
                            OUTPUT l-semlimite-prox). 

        IF l-semlimite-prox THEN DO:
            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT mla-doc-pend-aprov.cod-tip-doc,
                                                   INPUT mla-doc-pend-aprov.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN p-cod-erro = 54407
                   c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.
            {method/svc/errors/inserr.i &ErrorNumber="54407"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-chave-mla"}
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice transacao
  Parameters:  
               recebe valor do campo nr-trans
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnr-trans LIKE mla-doc-pend-aprov.nr-trans NO-UNDO.

    FIND FIRST {&TableName} 
         WHERE {&TableName}.nr-trans = pnr-trans NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser† retornada flag "NOK":U ---*/
    IF NOT AVAILABLE {&TableName} THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atravÇs de rowid e verifica a ocorrància de erros, caso
          existam erros ser† retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID({&TableName})).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE trocaEstabEmpresa DBOProgram 
PROCEDURE trocaEstabEmpresa: 
/*------------------------------------------------------------------------------
  Purpose:     Indica que houve troca de empresa ou estabelecimento, Ç necess†rio
  atualizar algumas leituras
  Parameters:  

  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-troca-estab-empresa = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificalotacao DBOProgram 
PROCEDURE verificalotacao :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no °ndice transacao
  Parameters:  

  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT  PARAMETER l-semlotacao AS LOGICAL INITIAL NO  NO-UNDO.
    DEFINE OUTPUT  PARAMETER p-cod-erro   AS INTEGER             NO-UNDO.

    DEFINE VARIABLE c-usuario-lotacao AS CHARACTER   NO-UNDO.

    /* Verifica se j† foi utilizada a parametrizaá∆o para empresa/estabelecimento, pois se j† foi, n∆o Ç 
    necess†rio ler o banco de dados novamente, usa da temp-table */
    IF NOT AVAIL tt-param-aprov OR l-troca-estab-empresa THEN DO:

        FIND FIRST tt-param-aprov 
              WHERE tt-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo
                AND tt-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel NO-LOCK NO-ERROR. 
    
        IF NOT AVAIL tt-param-aprov THEN DO:
            FOR FIRST mla-param-aprov FIELDS (ep-codigo cod-estabel destino-verba log-exchange log-email 
                                              compl-email servidor-email porta-email log-email-altern log-1
                                              log-atachado char-1 log-aprovac-altern-dat log-integr-fluig cdn-rej)
                 WHERE mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo 
                   AND mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel NO-LOCK: 
                
                CREATE tt-param-aprov.
                ASSIGN tt-param-aprov.ep-codigo                = mla-param-aprov.ep-codigo      
                       tt-param-aprov.cod-estabel              = mla-param-aprov.cod-estabel    
                       tt-param-aprov.destino-verba            = mla-param-aprov.destino-verba  
                       tt-param-aprov.log-exchange             = mla-param-aprov.log-exchange   
                       tt-param-aprov.log-email                = mla-param-aprov.log-email      
                       tt-param-aprov.compl-email              = mla-param-aprov.compl-email    
                       tt-param-aprov.servidor-email           = mla-param-aprov.servidor-email 
                       tt-param-aprov.porta-email              = mla-param-aprov.porta-email
                       tt-param-aprov.log-1                    = mla-param-aprov.log-1
                       tt-param-aprov.log-email-altern         = mla-param-aprov.log-email-altern
                       tt-param-aprov.log-atachado             = mla-param-aprov.log-atachado
                       tt-param-aprov.assume-perm-prin         = IF SUBSTRING(mla-param-aprov.char-1,3,1) = "S":U THEN YES ELSE NO
                       tt-param-aprov.assume-perm-lotacao-prin = IF SUBSTRING(mla-param-aprov.char-1,2,1) = "S":U THEN YES ELSE NO
                       tt-param-aprov.assume-perm-mestre-prin  = IF SUBSTRING(mla-param-aprov.char-1,4,1) = "S":U THEN YES ELSE NO
                       tt-param-aprov.log-aprovac-altern-dat   = mla-param-aprov.log-aprovac-altern-dat
                       tt-param-aprov.log-integr-fluig         = mla-param-aprov.log-integr-fluig
                       tt-param-aprov.cdn-rej                  = mla-param-aprov.cdn-rej.
                
            END.
        END.
    END.

    RUN pi-gerar-dados-extrato (INPUT " c-seg-usuario <> mla-doc-pend-aprov.cod-usuar AND tt-param-aprov.assume-perm-lotacao-prin ":U).
    RUN pi-gerar-dados-extrato (INPUT " cod-usuar ":U + STRING(mla-doc-pend-aprov.cod-usuar) + " / ":U + STRING(tt-param-aprov.assume-perm-lotacao-prin)).

    IF c-seg-usuario <> mla-doc-pend-aprov.cod-usuar AND tt-param-aprov.assume-perm-lotacao-prin THEN DO:
        ASSIGN c-usuario-lotacao = mla-doc-pend-aprov.cod-usuar.
    END.
    ELSE DO:
        ASSIGN c-usuario-lotacao = c-seg-usuario.
    END.

    RUN pi-gerar-dados-extrato (INPUT " c-usuario-lotacao ":U + STRING(c-usuario-lotacao)).
    RUN pi-gerar-dados-extrato (INPUT " lotacao ":U + STRING(mla-doc-pend-aprov.cod-lotacao-doc)).

    FIND FIRST tt-mla-perm-lotacao NO-LOCK
         WHERE tt-mla-perm-lotacao.ep-codigo   = mla-doc-pend-aprov.ep-codigo
           AND tt-mla-perm-lotacao.cod-usuar   = c-usuario-lotacao
           AND tt-mla-perm-lotacao.cod-lotacao = mla-doc-pend-aprov.cod-lotacao-doc NO-ERROR.

    IF NOT AVAIL tt-mla-perm-lotacao THEN DO:
        FOR FIRST mla-perm-lotacao FIELDS (ep-codigo cod-usuar cod-lotacao validade-ini validade-fim) 
             WHERE mla-perm-lotacao.ep-codigo   = mla-doc-pend-aprov.ep-codigo
               AND mla-perm-lotacao.cod-usuar   = c-usuario-lotacao
               AND mla-perm-lotacao.cod-lotacao = mla-doc-pend-aprov.cod-lotacao-doc NO-LOCK:

            CREATE tt-mla-perm-lotacao.
            ASSIGN tt-mla-perm-lotacao.ep-codigo    = mla-perm-lotacao.ep-codigo      
                   tt-mla-perm-lotacao.cod-usuar    = mla-perm-lotacao.cod-usuar     
                   tt-mla-perm-lotacao.cod-lotacao  = mla-perm-lotacao.cod-lotacao   
                   tt-mla-perm-lotacao.validade-ini = mla-perm-lotacao.validade-ini  
                   tt-mla-perm-lotacao.validade-fim = mla-perm-lotacao.validade-fim. 
        END.
    END.

    IF AVAIL tt-mla-perm-lotacao THEN DO:

        IF  tt-mla-perm-lotacao.validade-ini > TODAY OR  tt-mla-perm-lotacao.validade-fim < TODAY THEN DO:

            RUN pi-formata-chave IN THIS-PROCEDURE(INPUT mla-doc-pend-aprov.cod-tip-doc,
                                                   INPUT mla-doc-pend-aprov.chave-doc,
                                                   OUTPUT c-chave-mla-formatada).

            ASSIGN p-cod-erro = 54408
                   c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.   

            RUN pi-gerar-dados-extrato (INPUT " 1 cod-erro = 54408 : ":U + c-chave-mla ).

            {method/svc/errors/inserr.i &ErrorNumber="54408"
                                        &ErrorType="EMS":U
                                        &ErrorSubType="ERROR":U
                                        &ErrorParameters="c-chave-mla"}
           ASSIGN l-semlotacao = YES.
        END.
    END.
    ELSE DO:
        RUN pi-formata-chave IN THIS-PROCEDURE(INPUT mla-doc-pend-aprov.cod-tip-doc,
                                               INPUT mla-doc-pend-aprov.chave-doc,
                                               OUTPUT c-chave-mla-formatada).
        ASSIGN p-cod-erro = 54408
               c-chave-mla = " (":U + c-chave-mla-aux + ": ":U + c-chave-mla-formatada + ")":U.

        RUN pi-gerar-dados-extrato (INPUT " 2 cod-erro = 54408 : ":U + c-chave-mla ).

        {method/svc/errors/inserr.i &ErrorNumber="54408"
                                    &ErrorType="EMS":U
                                    &ErrorSubType="ERROR":U
                                    &ErrorParameters="c-chave-mla"}
        ASSIGN l-semlotacao = YES.
    END.

    ASSIGN l-troca-estab-empresa = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-bgc-cotacao DBOFunction 
PROCEDURE pi-bgc-cotacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
   FOR FIRST cotacao-item FIELDS (numero-ordem cod-emitente it-codigo seq-cotac cot-aprovada aprovador)                                                                       
       WHERE cotacao-item.numero-ordem = int(substring(mla-doc-pend-aprov.chave-doc,1,8))            
         AND cotacao-item.cod-emitente = int(substring(mla-doc-pend-aprov.chave-doc,9,8))            
         AND cotacao-item.it-codigo    = substring(mla-doc-pend-aprov.chave-doc,18,16)               
         AND cotacao-item.seq-cotac    = int(substring(mla-doc-pend-aprov.chave-doc,34,3)) NO-LOCK. END.

   IF AVAIL cotacao-item THEN DO:

       RUN cdp/cdapi172.p (3,rowid(cotacao-item),output l-pendente).
       IF NOT l-pendente THEN DO:
           FOR FIRST ordem-compra NO-LOCK
               WHERE ordem-compra.numero-ordem = cotacao-item.numero-ordem:
                
               RUN cdp/cdapi184.p(rowid(ordem-compra),rowid(cotacao-item), output table rowerrors APPEND).
               
               FIND FIRST RowErrors NO-ERROR.
               IF AVAIL RowErrors THEN DO:
                   FIND CURRENT cotacao-item EXCLUSIVE-LOCK NO-ERROR.
                   ASSIGN cotacao-item.cot-aprovada = NO
                          cotacao-item.aprovador    = "".

                   FIND CURRENT cotacao-item NO-LOCK NO-ERROR.
                   RUN getRowErrors IN THIS-PROCEDURE (OUTPUT TABLE rowErrors).
                    IF  gi-mla-origem <> 2 THEN DO:
						{method/showmessage.i1}
						/*--- Transfere temp-table RowErrors para a tela de mensagens de erros ---*/
						{method/showmessage.i2}
					END.
                   RETURN "NOK":U.
               END.
           END.
       END.
   END.

   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gerar-dados-extrato DBOFunction 
    
    {cdp/cd0020.i}       /* PROCEDURE pi-gerar-dados-extrato */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-aprovacao DBOFunction 
PROCEDURE pi-retorna-aprovacao :
/*------------------------------------------------------------------------------
  Purpose: Retorna se houve a aprovaá∆o de alguma pendàncias 
  Parameters: p-aprovou-pendencia (logical) - Indica a aprovaá∆o de alguma pendància
  Notes:      
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER p-aprovou-pendencia AS LOGICAL NO-UNDO.

    ASSIGN p-aprovou-pendencia = l-aprovou-pendencia.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-formata-chave DBOFunction 
PROCEDURE pi-formata-chave :
/*------------------------------------------------------------------------------
  Purpose: Formata a chave dos documentos, conforme o tipo    
  Parameters: p-tipo-doc (inteiro) - INPUT: C¢digo do documento 
              p-chave-doc (caracter) - INPUT: Chave do documento
              p-chave-formatada (caracter) - OUTPUT: Chave do documento formatada
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER p-tipo-doc         AS INTEGER   NO-UNDO.
    DEFINE INPUT  PARAMETER p-chave-doc        AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-chave-formatada  AS CHARACTER NO-UNDO.

    FOR EACH mla-chave-doc-aprov 
        WHERE mla-chave-doc-aprov.cod-tip-doc = p-tipo-doc NO-LOCK:
        ASSIGN p-chave-formatada = p-chave-formatada + 
                SUBSTRING(p-chave-doc,mla-chave-doc-aprov.posicao-ini,
                    ((mla-chave-doc-aprov.posicao-fim - mla-chave-doc-aprov.posicao-ini) + 1)) +
                    " | ":U.
    END.
    ASSIGN p-chave-formatada = SUBSTRING(p-chave-formatada,1,(LENGTH(p-chave-formatada) - 3)).
    

    RETURN p-chave-formatada.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-mensagem DBOFunction 
PROCEDURE pi-cria-tt-mensagem :
/*------------------------------------------------------------------------------
  Purpose: Cria a temp-table tt-mensagem para envio de e-mail pela utapi019  
  Parameters: tt-envio2: Informaá‰es da mensagem
              tt-mensagem: Informaá‰es da mensagem na temp-table para ser 
              usada pela pi-execute2
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER TABLE FOR tt-envio2.
    DEFINE OUTPUT PARAMETER TABLE FOR tt-mensagem.
    
    EMPTY TEMP-TABLE tt-mensagem.
    FOR EACH tt-envio2:
        CREATE tt-mensagem.
        ASSIGN tt-mensagem.mensagem = tt-envio2.mensagem.
    END.

    RETURN "OK":U.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

