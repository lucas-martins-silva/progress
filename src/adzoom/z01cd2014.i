&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
/* Procedure Description
"Method Library principal para Zoom Template, que cont‚m defini‡äes e chamadas a outras Method Libraries."
*/
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS Method-Library 
/*--------------------------------------------------------------------------
    Library    : zoom/Zoom.i
    Purpose    : Method Library principal para Zoom Template, que cont‚m 
                 defini‡äes e chamadas a outras Method Libraries 

    Authors    : John Cleber Jaraceski, Sergio Weber

    Notes      :   
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ****************************  Definitions  *************************** */

/* Global Variable Definitions ---                                        */
DEFINE NEW GLOBAL SHARED VARIABLE hWindowStyles AS HANDLE NO-UNDO.

&IF "{&DBOTable1}":U <> "":U &THEN
    &GLOBAL-DEFINE rTable1 gr-{&DBOTable1}
    
    DEFINE NEW GLOBAL SHARED VARIABLE gr-{&DBOTable1} AS ROWID NO-UNDO.
&ENDIF





/* Definir utilização de folder */
&IF DEFINED(folder) = 0 &THEN
    &GLOBAL-DEFINE Folder      YES
&ENDIF

/* Local Temp-Table Definitions ---                                       */
/*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
&IF DEFINED(DBOVersion) <> 0 &THEN
    DEFINE TEMP-TABLE RowErrors NO-UNDO
        FIELD ErrorSequence    AS INTEGER
        FIELD ErrorNumber      AS INTEGER
        FIELD ErrorDescription AS CHARACTER
        FIELD ErrorParameters  AS CHARACTER
        FIELD ErrorType        AS CHARACTER
        FIELD ErrorHelp        AS CHARACTER
        FIELD ErrorSubType     AS CHARACTER.
&ELSE
    {method/dbotterr.i}
&ENDIF

/*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
/*&IF DEFINED(DBOVersion) <> 0 &THEN*/
    &IF "{&page1browse}":U <> "":U &THEN
        DEFINE TEMP-TABLE ttTable1Aux NO-UNDO LIKE {&ttTable1}.
    &ENDIF
    
/*&ELSE*/
    {method/dbottraw.i}
/*&ENDIF*/

/* Local Variable Definitions ---                                         */
DEFINE VARIABLE cEventBrowse          AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldNames           AS CHARACTER NO-UNDO.
DEFINE VARIABLE cFieldHandles         AS CHARACTER NO-UNDO.
DEFINE VARIABLE hFolder               AS HANDLE    NO-UNDO.
DEFINE VARIABLE hProgramImplant       AS HANDLE    NO-UNDO.
DEFINE VARIABLE hRange                AS HANDLE    NO-UNDO.
DEFINE VARIABLE hShowMsg              AS HANDLE    NO-UNDO.
DEFINE VARIABLE hWindowParent         AS HANDLE    NO-UNDO.
DEFINE VARIABLE iConstraintPageNumber AS INTEGER   NO-UNDO.
DEFINE VARIABLE iRepositionPageNumber AS INTEGER   NO-UNDO.
DEFINE VARIABLE iRowsReturned         AS INTEGER   NO-UNDO.
DEFINE VARIABLE lCustomExecuted       AS LOGICAL   NO-UNDO.
DEFINE VARIABLE lOverrideExecuted     AS LOGICAL   NO-UNDO.
DEFINE VARIABLE rRepositionTable      AS ROWID     NO-UNDO.
DEFINE VARIABLE hFirstField           AS handle     NO-UNDO.


DEFINE VARIABLE c-nom-prog-dpc-mg97  AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nom-prog-appc-mg97 AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-nom-prog-upc-mg97  AS CHARACTER NO-UNDO.
DEFINE VARIABLE lDisableUPC          AS LOGICAL   NO-UNDO.

DEFINE VARIABLE epc-rowid1           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid2           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid3           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid4           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid5           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid6           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid7           AS ROWID     NO-UNDO.
DEFINE VARIABLE epc-rowid8           AS ROWID     NO-UNDO.

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
    define new global shared variable h-facelift as handle no-undo.
    if not valid-handle(h-facelift) then run btb/btb901zo.p persistent set h-facelift.
&ENDIF

/*--- Vari veis utilizadas nos eventos de CURSOR-DOWN, END, OFF-END e PAGE-DOWN ---*/
&IF "{&page1browse}":U <> "":U &THEN
    DEFINE VARIABLE rCurrent1 AS ROWID NO-UNDO.
&ENDIF



/* Function Definitions ---                                               */
&IF "{&Range}":U = "YES":U &THEN
    FUNCTION fnIniRangeChar RETURN CHAR    (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnEndRangeChar RETURN CHAR    (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnIniRangeInt  RETURN INTEGER (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnEndRangeInt  RETURN INTEGER (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnIniRangeDate RETURN DATE    (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnEndRangeDate RETURN DATE    (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnIniRangeDec  RETURN DECIMAL (INPUT pPageNumber AS INTEGER) IN hRange.
    FUNCTION fnEndRangeDec  RETURN DECIMAL (INPUT pPageNumber AS INTEGER) IN hRange.

    FUNCTION fnIniRangeCharPage RETURN CHAR    (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnEndRangeCharPage RETURN CHAR    (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnIniRangeIntPage  RETURN INTEGER (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnEndRangeIntPage  RETURN INTEGER (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnIniRangeDatePage RETURN DATE    (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnEndRangeDatePage RETURN DATE    (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnIniRangeDecPage  RETURN DECIMAL (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.
    FUNCTION fnEndRangeDecPage  RETURN DECIMAL (INPUT pPageNumber AS INTEGER, INPUT pFieldNum AS INTEGER) IN hRange.

&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Method-Library
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: INCLUDE-ONLY
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2.01
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB Method-Library 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{include/i-sysvar.i}
{btb/btb008za.i0}
{zoom/buttons.i}
/*** Alterado por Farley - em 23/07/2003 ***/
{include/i_fnctrad.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK Method-Library 


/* ***************************  Main Block  *************************** */

&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
run pi_aplica_facelift in this-procedure.
&ENDIF

/*Alterado por Valdir (tech264) para fazer tratamento da trigger de help*/
ON HELP OF wZoom DO:
    apply "choose":U to btHelp in frame fPage0.
END.

/* Atualizar janela corrente no evento de entry MFRWJOI-1345 */
ON ENTRY OF wZoom DO:
	IF VALID-HANDLE (wZoom) THEN DO:
		ASSIGN CURRENT-WINDOW = wZoom.
	END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

PROCEDURE GetSystemTime EXTERNAL "KERNEL32.DLL":U PERSISTENT:
    DEFINE OUTPUT PARAMETER lpSystemTime AS MEMPTR NO-UNDO.
END.

&IF DEFINED(EXCLUDE-applyCursorDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyCursorDown Method-Library 
PROCEDURE applyCursorDown :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de CURSOR-DOWN
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyCursorUp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyCursorUp Method-Library 
PROCEDURE applyCursorUp :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de CURSOR-UP
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyValueChanged) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyValueChanged Method-Library 
PROCEDURE applyValueChanged :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de VALUE-CHANGED
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyDblClick) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyDblClick Method-Library 
PROCEDURE applyDblClick :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de DBL-CLICK
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEnd Method-Library 
PROCEDURE applyEnd :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de END
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyHome) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyHome Method-Library 
PROCEDURE applyHome :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de HOME
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyOffEnd) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffEnd Method-Library 
PROCEDURE applyOffEnd :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de OFF-END
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
        
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF


&IF DEFINED(EXCLUDE-applyOffHome) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyOffHome Method-Library 
PROCEDURE applyOffHome :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de OFF-HOME
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.        
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyPageDown) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyPageDown Method-Library 
PROCEDURE applyPageDown :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de PAGE-DOWN
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-applyPageUp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyPageUp Method-Library 
PROCEDURE applyPageUp :
/*------------------------------------------------------------------------------
  Purpose:     L¢gica para trigger de PAGE-UP
  Parameters:  recebe o n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-destroyInterface) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE destroyInterface Method-Library 
PROCEDURE destroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     Destr¢i programa
  Parameters:  
  Notes:       Destr¢i programas de: Folder e DBOs
------------------------------------------------------------------------------*/
    
    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/override.i &Position="Before"
                       &Procedure="destroyInterface"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Executa programas de customiza‡Æo (before/after) ---*/
    {method/custom.i &Event="BEFORE-DESTROY-INTERFACE"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="?"
                     &RowidTable="?"}
                     
    /*Inserida a chamada da include i-logfin1.i
    devido aos thintemplates nÆo gerarem log de 
    execucao de programas*/
    {include/i-logfin1.i}
    
    /*--- Manter compatibilidade dos thinTemplates com BO 1.1 e DBO 2.0 ---*/
    &IF DEFINED(DBOVersion) <> 0 &THEN
        /*--- Destr¢i BO 1.1 ---*/
        &IF "{&hDBOTable1}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable1}) THEN
                DELETE PROCEDURE {&hDBOTable1}.
        &ENDIF
    &ELSE
        /*--- Destr¢i DBO Table1 ---*/
        &IF "{&hDBOTable1}":U <> "":U &THEN
            IF VALID-HANDLE({&hDBOTable1}) THEN
                RUN destroy IN {&hDBOTable1}.
        &ENDIF
    &ENDIF
    
        
    /*--- Destr¢i programa de range ---*/
    &IF "{&Range}":U = "YES":U &THEN
        IF VALID-HANDLE(hRange) THEN
            DELETE PROCEDURE hRange.
    &ENDIF
    
    /*--- Destr¢i programa de folder ---*/
    &IF "{&Folder}":U = "YES":U &THEN
        IF VALID-HANDLE(hFolder) THEN
            DELETE PROCEDURE hFolder.
    &ENDIF
    
    /*--- Executa programas de customiza‡Æo (before/after) ---*/
    {method/custom.i &Event="AFTER-DESTROY-INTERFACE"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="?"
                     &RowidTable="?"}
    
    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/override.i &Position="After"
                       &Procedure="destroyInterface"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    /*--- Retira estilo de janela (modal) para thinMaintenace ---*/
    IF VALID-HANDLE(hWindowParent) THEN DO:
        ASSIGN hWindowParent:SENSITIVE = YES.
        /* Atualizar janela corrente MFRWJOI-1345 */
        ASSIGN CURRENT-WINDOW = hWindowParent.
    END.
    
    /*--- Destr¢i os Servidores RPC inicializados pelos DBOs ---*/
    {btb/btb008za.i3}

    /*Alteracao para deletar da mem¢ria o WindowStyles e o btb008za.p*/
    IF VALID-HANDLE(h-servid-rpc) THEN
    DO:
       DELETE PROCEDURE h-servid-rpc.
       ASSIGN h-servid-rpc = ?. /*Garantir que a vari vel nÆo vai mais apontar para nenhum handle de outro objeto - este problema apareceu na v9.1B com Windows2000*/
    END.

    /*--- Destr¢i janela associada ao programa ---*/
    IF VALID-HANDLE(wZoom) THEN
        DELETE WIDGET wZoom.
    
    /*--- Destr¢i programa ---*/
    IF THIS-PROCEDURE:PERSISTENT THEN
        DELETE PROCEDURE THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-dispatch) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE dispatch Method-Library 
PROCEDURE dispatch :
/*------------------------------------------------------------------------------
  Purpose:     Manter compatibilidade com SmartObjects
  Parameters:  recebe m‚todo a ser executado
  Notes:       Somente haver  tratamento para o m‚todo initialize, quando a 
               execu‡Æo deste m‚todo for solicitada ser  executado o m‚todo
               initializeInterface
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pMethod AS CHARACTER NO-UNDO.
    
    IF pMethod = "INITIALIZE":U THEN
        RUN initializeInterface IN THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-enableImplant) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enableImplant Method-Library 
PROCEDURE enableImplant :
/*------------------------------------------------------------------------------
  Purpose:     Habilita botäes de implantar
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-initializeInterface) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeInterface Method-Library 
PROCEDURE initializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     Inicialize programa
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*Alterado por Anderson (tech485) para o template mostrar o nome da empresa*/

    def var c_cod_empres_usuar as char no-undo.
    def var c_nom_razao_social as char no-undo.

    /*fim alteracao Anderson*/

    /*--- Inicializa‡Æo de OCXs ---*/
    IF THIS-PROCEDURE:GET-SIGNATURE("control_load":U) <> "":U THEN DO:
        RUN control_load IN THIS-PROCEDURE NO-ERROR.
        VIEW FRAME fPage0 IN WINDOW wZoom.
    END.
    
    /*--- Executa valida‡äes de inicializa‡Æo ---*/
    ASSIGN c-programa-mg97 = CAPS("{&Program}":U)
           c-versao-mg97   = "{&Version}":U.
    {utp/ut-vfsec.i}

    /*Inserida a chamada da include i-logini.i
    devido aos thintemplates nÆo gerarem log de 
    execucao de programas*/
    {include/i-logini.i}    

    /*Alterado por Anderson (tech485) para o template mostrar o nome da empresa*/
    /*{utp/ut9000.i "{&Program}" "{&Version}"} *//*esta foi comentada por estar causando erro nos thintemplates*/
    /*rodar pi-rsocial persistent para verifica»’o empresa usuario*/
   
    /* Alterado por Valdir (tech264) para novo m‚todo de teste do handle,
       testando tamb‚m os atributos TYPE e FILE-NAME do handle */
       
    if not valid-handle(h-rsocial) or
       h-rsocial:TYPE <> "PROCEDURE":U or
       h-rsocial:FILE-NAME <> "utp/ut-rsocial.p":U then do:
        if l-achou-prog then
            run utp/ut-rsocial.p persistent set h-rsocial.
    end.
    if l-achou-prog then
        run pi-rsocial in h-rsocial (output c_cod_empres_usuar, output c_nom_razao_social).
    
    find prog_dtsul no-lock
        where prog_dtsul.cod_prog_dtsul = c-programa-mg97 no-error.
    if  avail prog_dtsul then do:
        assign c-titulo-prog-mg97    = prog_dtsul.des_prog_dtsul
               c-nom-prog-upc-mg97   = prog_dtsul.nom_prog_upc
               c-nom-prog-appc-mg97  = prog_dtsul.nom_prog_appc
               c-nom-prog-dpc-mg97   = prog_dtsul.nom_prog_dpc
               i-num-topico-hlp-mg97 = prog_dtsul.num_topico.

        IF (c-nom-prog-upc-mg97 <> "") THEN DO:
            RUN men/verifyDisableUPC.p (OUTPUT lDisableUPC).
            IF lDisableUPC THEN
                ASSIGN c-nom-prog-upc-mg97 = "".
	    END.

       &IF DEFINED(TransformacaoWindow) <> 0 &THEN
          if session:window-system <> "TTY":U then 
             assign i-template          = prog_dtsul.idi_template.
       &ENDIF

        find procedimento no-lock
            where procedimento.cod_proced = prog_dtsul.cod_proced no-error.
        if  avail procedimento then do:
            find modul_dtsul no-lock
                where modul_dtsul.cod_modul_dtsul = procedimento.cod_modul_dtsul no-error. 
            if  avail modul_dtsul then do:
                assign c-modulo-mg97         = caps(modul_dtsul.nom_modul_dtsul_menu)
                       c-cod-mod-mg97        = caps(modul_dtsul.cod_modul_dtsul)
                       c-nom-manual-hlp-mg97 = "dochlp~/":U + string(modul_dtsul.num_manual_documen, "999999":U) + ".hlp":U.
            end.
        end.
    end.                                                      
    else do:
        assign c-titulo-prog-mg97    = caps(c-programa-mg97)
               c-nom-prog-upc-mg97   = ""
               c-nom-prog-appc-mg97  = ""
               i-num-topico-hlp-mg97 = 0
               c-nom-manual-hlp-mg97 = "dochlp~/000000.hlp":U.
    end.                 

    /* Tradu‡Æo T¡tulo dos Programas */
    /* FO 1354855  - 11/08/2006 - tech1139 */
    run utp/ut-liter.p (input replace(c-titulo-prog-mg97, " ", "_") ,
                        input "*":U,
                        input "":U). 
    /* FO 1354855  - 11/08/2006 - tech1139 */

    Assign c-titulo-prog-mg97 = Return-value.

    &IF "{&mguni_version}" >= "2.07A" &THEN
     
        &IF "{&INCLUDE_LM}" = "TRUE" &THEN
        
            RUN btb/btb970aa.p PERSISTENT SET h_btb970aa.
            RUN pi-retorna-inf-modulo IN h_btb970aa (INPUT c-lm-modulo,
                                                     OUTPUT c_id_modulo_ls,
                                                     OUTPUT c_desc_modulo_ls).
    
            IF VALID-HANDLE(h_btb970aa) THEN
                DELETE PROCEDURE h_btb970aa.
    
        &ELSE 
        
            DEF VAR c_id_modulo_ls        AS CHAR NO-UNDO.
            DEF VAR c_desc_modulo_ls      AS CHAR NO-UNDO.
    
            IF INDEX(PROGRAM-NAME(1),"btb") > 0 OR
               INDEX(PROGRAM-NAME(1),"sec") > 0 OR
               INDEX(PROGRAM-NAME(1),"men") > 0 OR
               INDEX(PROGRAM-NAME(1),"utp") > 0 THEN DO:
                IF INDEX(PROGRAM-NAME(1),"btb") > 0 THEN
                    ASSIGN c_id_modulo_ls = "5550"
                           c_desc_modulo_ls = "B sico (NPS)".
                ELSE IF INDEX(PROGRAM-NAME(1),"sec") > 0 THEN
                    ASSIGN c_id_modulo_ls = "5551"
                           c_desc_modulo_ls = "Seguran‡a".
                ELSE IF INDEX(PROGRAM-NAME(1),"men") > 0 THEN
                    ASSIGN c_id_modulo_ls = "5549"
                           c_desc_modulo_ls = "Menu".
                ELSE IF INDEX(PROGRAM-NAME(1),"utp") > 0 THEN
                    ASSIGN c_id_modulo_ls = "5553"
                           c_desc_modulo_ls = "Utilit rios".
            END.
            ELSE DO:
                ASSIGN c_id_modulo_ls = "????"
                       c_desc_modulo_ls = "????????????????????".
            END.
        &ENDIF       
    
         
        &IF  "{&WINDOW-NAME}" <> "" AND "{&WINDOW-NAME}" <> "CURRENT-WINDOW" &THEN 
             assign {&WINDOW-NAME}:title = if l-achou-prog then
                                           "06.9."
                                         + c_id_modulo_ls
                                         + " - "
                                         + c-programa-mg97 
                                         + " - " 
                                         + c-versao-mg97  
                                         + " - "
                                         + c-titulo-prog-mg97
                                         + " - " 
                                         + c_cod_empres_usuar
                                         + " - " 
                                         + c_nom_razao_social
                                         else 
                                           "06.9."
                                         + c_id_modulo_ls
                                         + " - "                                    
                                         + c-programa-mg97 
                                         + " - " 
                                         + c-versao-mg97
                                         + " - " 
                                         + c-titulo-prog-mg97.
        &ELSE
             assign frame {&FRAME-NAME}:title = if l-achou-prog THEN
                                                  "06.9."
                                                + c_id_modulo_ls
                                                + " - "
                                                + c-programa-mg97 
                                                + " - " 
                                                + c-versao-mg97
                                                + " - "                                 
                                                + c-titulo-prog-mg97  
                                                + " - " 
                                                + c_cod_empres_usuar
                                                + " - " 
                                                + c_nom_razao_social
                                                else
                                                 "06.9."
                                                + c_id_modulo_ls
                                                + " - "                                                                                  
                                                + c-programa-mg97
                                                + " - " 
                                                + c-versao-mg97 
                                                + " - " 
                                                + c-titulo-prog-mg97.
    
        &ENDIF
    &ELSE
        &IF  "{&WINDOW-NAME}":U <> "" AND "{&WINDOW-NAME}":U <> "CURRENT-WINDOW":U &THEN 
             assign {&WINDOW-NAME}:title = if l-achou-prog then
                                           c-titulo-prog-mg97
                                         + " - ":U 
                                         + c-programa-mg97 
                                         + " - ":U 
                                         + c-versao-mg97  
                                         + " - ":U 
                                         + c_cod_empres_usuar
                                         + " - ":U 
                                         + c_nom_razao_social
                                         else 
                                           c-titulo-prog-mg97
                                         + " - ":U 
                                         + c-programa-mg97 
                                         + " - ":U 
                                         + c-versao-mg97.
        &ELSE
             assign frame {&FRAME-NAME}:title = if l-achou-prog then
                                                  c-titulo-prog-mg97  
                                                + " - ":U 
                                                + c-programa-mg97 
                                                + " - ":U 
                                                + c-versao-mg97
                                                + " - ":U 
                                                + c_cod_empres_usuar
                                                + " - ":U 
                                                + c_nom_razao_social
                                                else
                                                  c-titulo-prog-mg97  
                                                + " - ":U 
                                                + c-programa-mg97 
                                                + " - ":U 
                                                + c-versao-mg97.
    
        &ENDIF
    
    &ENDIF
    

    /*fim alteracao Anderson(tech485)*/



    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/override.i &Position="Before"
                       &Procedure="initializeInterface"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
        /*--- Destr¢i programa ---*/
        RUN destroyInterface IN THIS-PROCEDURE.
        
        RETURN "NOK":U.
    END.
    
    /*--- Executa programas de customiza‡Æo (before/after) ---*/
    {method/custom.i &Event="BEFORE-INITIALIZE"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="?"
                     &RowidTable="?"}
    
    DO WITH FRAME fPage0:
        
        /*--- Habilitar/Desabilitar botäes ---*/
        ASSIGN
            btOK:SENSITIVE     = YES
            btCancel:SENSITIVE = YES
            btHelp:SENSITIVE   = YES.
        
        /*--- Definir tamanhos e posicionar widgets ---*/
        ASSIGN 
            rtToolBar:WIDTH  = FRAME fPage0:WIDTH
            rtToolBar:HEIGHT = 1.46
            rtToolBar:COL    = 1
            rtToolBar:ROW    = FRAME fPage0:HEIGHT - 0.63
            btOK:WIDTH       = 10
            btOK:HEIGHT      = 1
            btOK:COL         = 2
            btOK:ROW         = rtToolBar:ROW + 0.23
            btCancel:WIDTH   = 10
            btCancel:HEIGHT  = 1
            btCancel:COL     = 13
            btCancel:ROW     = rtToolBar:ROW + 0.23
            btHelp:WIDTH     = 10
            btHelp:HEIGHT    = 1
            btHelp:COL       = 80
            btHelp:ROW       = rtToolBar:ROW + 0.23.
    END.
    
    /*--- Executa programa de range ---*/
    &IF "{&Range}":U = "YES":U &THEN
        RUN utp/makerange.p PERSISTENT SET hRange.
    &ENDIF
    
    /*--- Executa programa de folder ---*/
    &IF "{&Folder}":U = "YES":U &THEN
        RUN utp/thinfolder.w PERSISTENT SET hFolder.
        
        RUN setProgramParent IN hFolder (INPUT THIS-PROCEDURE).
        
        RUN setOCX IN hFolder (INPUT THIS-PROCEDURE:GET-SIGNATURE("control_load":U) <> "":U) NO-ERROR.
        
        RUN initializeFolders IN hFolder (INPUT FRAME fPage0:HANDLE,
                                          INPUT &IF NUM-ENTRIES("{&FolderLabels}":U) >= 1 &THEN
                                                    STRING(FRAME fPage1:HANDLE)
                                                &ENDIF

                                                &IF NUM-ENTRIES("{&FolderLabels}":U) >= 2 &THEN
                                                        + ",":U + STRING(FRAME fPage2:HANDLE)
                                                &ENDIF

                                                &IF NUM-ENTRIES("{&FolderLabels}":U) >= 3 &THEN
                                                    + ",":U + STRING(FRAME fPage3:HANDLE)
                                                &ENDIF

                                                &IF NUM-ENTRIES("{&FolderLabels}":U) >= 4 &THEN
                                                    + ",":U + STRING(FRAME fPage4:HANDLE)
                                                &ENDIF

                                                &IF NUM-ENTRIES("{&FolderLabels}":U) >= 5 &THEN
                                                    + ",":U + STRING(FRAME fPage5:HANDLE)
                                                &ENDIF                     
 
                                                &IF NUM-ENTRIES("{&FolderLabels}":U) >= 6 &THEN
                                                    + ",":U + STRING(FRAME fPage6:HANDLE)
                                                &ENDIF                     
 
                                                &IF NUM-ENTRIES("{&FolderLabels}":U) >= 7 &THEN
                                                    + ",":U + STRING(FRAME fPage7:HANDLE)
                                                &ENDIF                     
 
                                                &IF NUM-ENTRIES("{&FolderLabels}":U) = 8 &THEN
                                                    + ",":U + STRING(FRAME fPage8:HANDLE)
                                                &ENDIF,
                                          INPUT "{&FolderLabels}":U,
                                          INPUT NUM-ENTRIES("{&FolderLabels}":U),
                                          INPUT ?,
                                          INPUT ?,
                                          INPUT ?,
                                          
                                          /*--- Est  sendo utilizada a f¢rmula abaixo porquˆ 
                                                a barra de botäes fica na parte inferior da frame ---*/
                                          INPUT FRAME fPage0:HEIGHT - FRAME fPage1:ROW - 0.75 ).

        &IF "{&Range}":U = "YES":U &THEN
            RUN setVariable in hFolder (input hRange).
        &ENDIF

    &ENDIF
    
    /*--- Habilitar browse contido no {&page1Browse} ---*/
    &IF "{&page1Browse}":U <> "":U &THEN
        DO WITH FRAME fPage1:
            ENABLE {&page1Browse}.
        END.
    &ENDIF
    
    
    
    /*--- Executa programa de estilo de janelas ---*/
    IF  VALID-HANDLE(hWindowStyles) = NO OR
        hWindowStyles:TYPE <> "PROCEDURE":U OR
        (hWindowStyles:FILE-NAME <> "utp/WindowStyles.p":U AND
        hWindowStyles:FILE-NAME <> "utp/WindowStyles.r":U) THEN
        RUN utp/windowstyles.p PERSISTENT SET hWindowStyles.
    
    /*--- Seta estilo de janela para thinMaintenance ---*/
    RUN deleteMinMax IN hWindowStyles (INPUT wZoom:hWnd).

    /*Colocado esta l¢gica para caso o desenvolvedor passar o handle da bo j  
     estartado o mesmo nÆo mostrar erros de execu‡äes antigas sa inicializa‡Æo 
     do programa Feita por Anderson tech485 28/08/2202*/
    &IF DEFINED(DBOVersion) = 0 &THEN
        &IF "{&hDBOTable1}":U <> "":U &THEN
             IF VALID-HANDLE({&hDBOTable1}) THEN
                 RUN emptyrowerrors IN {&hDBOTable1} NO-ERROR.
        &ENDIF
       
    &ENDIF
    /*fim altera‡Æo Anderson tech485 28/08/2202*/
    
    /*--- Inicializa DBOs ---*/
    if session:set-wait-state("general":U) then.
    RUN initializeDBOs IN THIS-PROCEDURE.
    if session:set-wait-state("") then.
    
    /*--- Verifica se a inicializa‡Æo dos DBOs foi feita com sucesso ---*/
    IF NO
        &IF "{&hDBOTable1}":U <> "":U &THEN
            OR NOT VALID-HANDLE({&hDBOTable1}) 
        &ENDIF
            
       
        
    THEN DO:
        /*--- Exibir mensagem de finaliza‡Æo do programa ---*/
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                           INPUT 18881, 
                           INPUT CAPS("{&Program}":U) + "~~":U + CAPS("{&Version}":U)).
        
        /*--- Destr¢i programa ---*/
        RUN destroyInterface IN THIS-PROCEDURE.
        
        RETURN "NOK":U.
    END.
    &IF DEFINED(DBOVersion) = 0 &THEN
    ELSE DO:
        /*Foi inclu¡da esta l¢gica para verifica‡Æo de erros relacionados com 
         a permissÆo de execu‡Æo do programa de dbo Altera‡Æo em 17/06/2002 por Anderson(tech540)*/
         &IF "{&hDBOTable1}":U <> "":U &THEN
              RUN getrowerrors IN {&hDBOTable1} (OUTPUT TABLE rowerrors).
                IF CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorNumber <> 3 AND
                                                  RowErrors.ErrorNumber <> 8 AND
                                                  RowErrors.ErrorNumber <> 10 AND
                                                  RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                  {method/showmessage.i1}
                  {method/showmessage.i2}
                   /****
                    TECH14187 - 1538059
                    Problema da ShowMessage Modal
                    ****/
                   &IF "{&Modal}":U = "":U &THEN
                        WAIT-FOR CLOSE OF hShowMsg.
                   &ENDIF
                  {method/showmessage.i3}
                  RUN destroyInterface IN THIS-PROCEDURE.
                  RETURN "NOK":U.
              END.
         &ENDIF
         
         
    END.
    &ENDIF

    /*--- Atualiza browsers ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    &IF "{&Range}":U = "YES":U &THEN
        &IF "{&FieldNames}":U <> "" &THEN
            RUN initializeRange IN hRange (INPUT THIS-PROCEDURE:HANDLE,
                                   INPUT &IF NUM-ENTRIES("{&FolderLabels}":U) >= 1 &THEN
                                                STRING(FRAME fPage1:HANDLE)
                                            &ENDIF

                                            &IF NUM-ENTRIES("{&FolderLabels}":U) >= 2 &THEN
                                                    + ",":U + STRING(FRAME fPage2:HANDLE)
                                            &ENDIF

                                            &IF NUM-ENTRIES("{&FolderLabels}":U) >= 3 &THEN
                                                + ",":U + STRING(FRAME fPage3:HANDLE)
                                            &ENDIF

                                            &IF NUM-ENTRIES("{&FolderLabels}":U) >= 4 &THEN
                                                + ",":U + STRING(FRAME fPage4:HANDLE)
                                            &ENDIF

                                            &IF NUM-ENTRIES("{&FolderLabels}":U) >= 5 &THEN
                                                + ",":U + STRING(FRAME fPage5:HANDLE)
                                            &ENDIF                     
 
                                            &IF NUM-ENTRIES("{&FolderLabels}":U) >= 6 &THEN
                                                + ",":U + STRING(FRAME fPage6:HANDLE)
                                            &ENDIF                     
 
                                            &IF NUM-ENTRIES("{&FolderLabels}":U) >= 7 &THEN
                                                + ",":U + STRING(FRAME fPage7:HANDLE)
                                            &ENDIF                     
 
                                            &IF NUM-ENTRIES("{&FolderLabels}":U) = 8 &THEN
                                                + ",":U + STRING(FRAME fPage8:HANDLE)
                                            &ENDIF,
                                   INPUT "{&FieldNames}":U,
                                   INPUT NUM-ENTRIES("{&FolderLabels}":U),
                                   OUTPUT hFirstField).
        &ENDIF
        &IF "{&Range}":U = "YES":U &THEN
        IF VALID-HANDLE(hRange) THEN 
            run setahandlefolder in hRange (input hFolder).
        &ENDIF
        &IF "{&FieldsRangePage1}":U <> "" and
            "{&FieldNames}":U   = "" &THEN
            RUN initializeMultipleRange IN hRange (INPUT THIS-PROCEDURE:HANDLE,
                                                   INPUT STRING(FRAME fPage1:HANDLE),
                                                   INPUT "{&FieldsRangePage1}":U,
                                                   INPUT "{&FieldsAnyKeyPage1}",
                                                   OUTPUT hFirstField).
        &ENDIF
        
    &ENDIF
    
    &IF "{&Folder}":U = "YES":U &THEN
        RUN setFolder IN hFolder (INPUT {&InitialPage}).
    &ENDIF
    
    /*--- Executa programas de customiza‡Æo (before/after) ---*/
    {method/custom.i &Event="AFTER-INITIALIZE"
                     &Object="CONTAINER"
                     &ObjectHandle="THIS-PROCEDURE:HANDLE"
                     &FrameHandle="FRAME fPage0:HANDLE"
                     &Table="?"
                     &RowidTable="?"}
    
    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/override.i &Position="After"
                       &Procedure="initializeInterface"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN DO:
        /*--- Destr¢i programa ---*/
        RUN destroyInterface IN THIS-PROCEDURE.
        
        RETURN "NOK":U.
    END.

    /*** Alterado por Farley - em 23/07/2003 ***/
    &IF "{&FNC_MULTI_IDIOMA}":U = "YES":U &THEN
        /*** Alterado por Paulo H. Lazzarotti em 09/07/2003
             Esta valida‡Æo ‚ provis¢ria, at‚ que todos os clientes
             tenham este utilit rio em seus ambientes ****/
        IF SEARCH("utp/ut-trcampos.r":U) <> ? OR 
           SEARCH("utp/ut-trcampos.p":U) <> ? THEN
            /*ALtera‡Æo Anderson  tech540 em 12/05/2003 para o projeto de 
            tradu‡Æo onde este ir  traduzir os valores (labels) dos objetos em telas*/
            RUN utp/ut-trcampos.p.
            /*fim altera‡Æo Anderson 12/05/2003*/
    &ENDIF
    
    /*--- Visualiza janela ---*/
    VIEW wZoom.

    /*Alteracao 24/01/2006 - tech14207 - Alterado para desabilitar o programa pai*/
    /*O c¢digo foi alterado para permitir que o mesmo programa fosse executado mais de uma vez corretamente*/
    
    DEFINE VAR h-source AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-this AS HANDLE     NO-UNDO.

    ASSIGN h-source = SOURCE-PROCEDURE.
    ASSIGN h-this = THIS-PROCEDURE.
    
    IF (THIS-PROCEDURE <> SOURCE-PROCEDURE) THEN DO:
        ASSIGN h-source = SOURCE-PROCEDURE.
        /*26/09/2006 - tech30713 - FO: 1309021*/
        IF VALID-HANDLE(h-source) AND  VALID-HANDLE(h-source:CURRENT-WINDOW) THEN DO:
            ASSIGN hWindowParent           = h-source:CURRENT-WINDOW
                   hWindowParent:SENSITIVE = NO.
        END.
    END.
    
    /*Fim da altera‡Æo 24/01/2006 - tech14207*/

    
    IF  VALID-HANDLE(hFirstField) THEN
        APPLY "ENTRY":U TO hFirstField.

    /*Alteracao 24/01/2006 - tech14207 - Alterado para desabilitar o programa pai*/
    /*O c¢digo foi alterado para permitir que o mesmo programa fosse executado mais de uma vez corretamente*/    
    /*--- Seta estilo de janela modal para thinMaintenance ---*/
/*     ASSIGN hWindowParent           = SESSION:FIRST-CHILD        */
/*            hWindowParent           = hWindowParent:NEXT-SIBLING */
/*            hWindowParent:SENSITIVE = NO.                        */
    /*Fim da altera‡Æo 24/01/2006 - tech14207*/
    
    APPLY "ENTRY":U TO FRAME fPage0.
    APPLY "ENTRY":U TO wZoom.
    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-repositionRecordInPage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE repositionRecordInPage Method-Library 
PROCEDURE repositionRecordInPage :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona DBO table atrav‚s de um rowid
  Parameters:  recebe rowid
               recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pRowid      AS ROWID   NO-UNDO.
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*--- Seta vari vel iRepositionPageNumber com o n£mero da p gina na qual
          o browse filho ser  reposicionado ---*/
    /*--- Seta vari vel rReposition com o rowid a ser reposicionado no 
          browse filho ---*/
    ASSIGN iRepositionPageNumber = pPageNumber
           rRepositionTable      = pRowid.
    
    /*--- Atualiza browse mas somente da p gina iRepositionPageNumber ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-setFieldNamesHandles) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setFieldNamesHandles Method-Library 
PROCEDURE setFieldNamesHandles :
/*------------------------------------------------------------------------------
  Purpose:     Seta nome dos campos a serem retornados
  Parameters:  recebe nome dos campos
               recebe handle dos campos
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldNames   AS CHARACTER NO-UNDO.
    DEFINE INPUT PARAMETER pFieldHandles AS CHARACTER NO-UNDO.
    
    /*--- Atualiza vari vel cFieldNames com o nome dos campos a serem 
          retornados ---*/
    ASSIGN cFieldNames   = pFieldNames
           cFieldHandles = pFieldHandles.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-changePage) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE changePage Method-Library 
PROCEDURE changePage :
/*------------------------------------------------------------------------------
  Purpose:     M‚todo executado pelo programa de Folder, quando h  troca de 
               p gina
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
def var pageN as integer no-undo.
    
    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/override.i &Position="Before"
                       &Procedure="changePage"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RUN GetCurrentFolder IN hFolder (OUTPUT PageN).
    
    Case pageN:
    &IF "{&page1Browse}":U <> "" &THEN
    when 1 then do:
        IF AVAILABLE {&ttTable1} THEN 
            ASSIGN epc-rowid1 = {&ttTable1}.r-Rowid.
        ELSE 
            ASSIGN epc-rowid1 = ?.
    
        /*--- Executa programas de customiza‡Æo (before/after) ---*/
        {method/custom.i &Event="BEFORE-CHANGE-PAGE"
                         &Object="CONTAINER"
                         &ObjectHandle="THIS-PROCEDURE:HANDLE"
                         &FrameHandle="FRAME fPage0:HANDLE"
                         &Table="{&ttTable1}"
                         &RowidTable="epc-rowid1"}
        
        /*--- Executa programas de customiza‡Æo (before/after) ---*/
        {method/custom.i &Event="AFTER-CHANGE-PAGE"
                         &Object="CONTAINER"
                         &ObjectHandle="THIS-PROCEDURE:HANDLE"
                         &FrameHandle="FRAME fPage0:HANDLE"
                         &Table="{&ttTable1}"
                         &RowidTable="epc-rowid1"}
    end.
    &ENDIF
    
    end case.

    /*--- Executa m‚todos sobrepostos (before/after) ---*/
    {method/override.i &Position="After"
                       &Procedure="changePage"}
    IF lOverrideExecuted AND RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF

&IF DEFINED(EXCLUDE-piTooltipHelp) = 0 &THEN

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piTooltipHelp Method-Library 
PROCEDURE piTooltipHelp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*Os botäes desta tela nÆo tem pr‚-processadores, entÆo eles podem ser exclu¡dos
     por isso, para traduzir o label deles estamos buscando os que estiverem na tela
     e traduzindo o label*/
  DEFINE VARIABLE h_Frame AS HANDLE     NO-UNDO.

  ASSIGN h_Frame = FRAME fPage0:FIRST-CHILD. /* pegando o Field-Group */
  ASSIGN h_Frame = h_Frame:FIRST-CHILD.       /* pegando o 1o. Campo */
  DO WHILE h_Frame <> ? :
       if h_Frame:type <> "field-group" then do:  
          IF h_Frame:TYPE = "button" THEN
          DO :
             ASSIGN h_Frame:TOOLTIP = h_Frame:LABEL.
          END.
          ASSIGN h_Frame = h_Frame:NEXT-SIBLING.
       end. 
       else do:
         assign h_frame = h_frame:first-child.
       end.    
  END.

  
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_aplica_facelift Method-Library 
PROCEDURE pi_aplica_facelift :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
&IF "{&mguni_version}" >= "2.06b" OR "{&aplica_facelift}" = "YES" &THEN
/**** Alteracao efetuada por tech14187/tech1007/tech38629 para o projeto Facelift ****/
    run pi_aplica_facelift_thin in h-facelift ( input frame fPage0:handle ).
    &IF "{&page1browse}":U <> "":U &THEN
    run pi_aplica_facelift_thin in h-facelift ( input frame fPage1:handle ).
    &ENDIF
    
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ENDIF
/*Fim Alteracao 27/07/2005*/
