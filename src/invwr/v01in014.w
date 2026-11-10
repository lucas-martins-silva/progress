&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V01IN014 2.00.00.017 } /*** "010017" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in014 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def buffer b-mla-usuar-aprov-altern for mla-usuar-aprov-altern.
def buffer b-mla-usuar-aprov        for mla-usuar-aprov.

def var c-validade-ini as char no-undo.
def var c-validade-fim as char no-undo.


{lap/mlaapi001.i99}
{cdp/cd0666.i}
{utp/utapi019.i}
{laphtml/mlahtml.i}

def var c-ass-e-mail as char    no-undo.
def var c-men-e-mail as char    no-undo.

def var i-chave as integer no-undo.

def var i-empresa LIKE empresa.ep-codigo no-undo.

def var c-log-reg as char no-undo.

def temp-table tt-erros-geral NO-UNDO like tt-erros.
def var l-enviou-alternativos as logical no-undo.
def var c-arquivo             as char    no-undo.
def var c-arquivo-anexo       as char    no-undo.
def var c-txt-ini             as char    no-undo.
def var c-txt-acomp           as char    no-undo.

def var l-anexar-conteudo     as log     no-undo.

def var h-acomp               as handle  no-undo.

DEF BUFFER b-mla-perm-aprov FOR mla-perm-aprov.
DEF BUFFER bb-mla-usuar-aprov FOR mla-usuar-aprov.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES mla-usuar-aprov-altern
&Scoped-define FIRST-EXTERNAL-TABLE mla-usuar-aprov-altern


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-usuar-aprov-altern.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-usuar-aprov-altern.validade-ini ~
mla-usuar-aprov-altern.validade-fim 
&Scoped-define ENABLED-TABLES mla-usuar-aprov-altern
&Scoped-define FIRST-ENABLED-TABLE mla-usuar-aprov-altern
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS mla-usuar-aprov-altern.cod-usuar-altern ~
mla-usuar-aprov-altern.validade-ini mla-usuar-aprov-altern.validade-fim 
&Scoped-define DISPLAYED-TABLES mla-usuar-aprov-altern
&Scoped-define FIRST-DISPLAYED-TABLE mla-usuar-aprov-altern
&Scoped-Define DISPLAYED-OBJECTS c-desc-usuario 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-usuar-aprov-altern.cod-usuar-altern 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-usuario AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 1.63.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 79.29 BY 1.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-usuar-aprov-altern.cod-usuar-altern AT ROW 1.38 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.72 BY .88
     c-desc-usuario AT ROW 1.38 COL 35.43 COLON-ALIGNED NO-LABEL
     mla-usuar-aprov-altern.validade-ini AT ROW 3.25 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     mla-usuar-aprov-altern.validade-fim AT ROW 3.25 COL 56.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 2.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-usuar-aprov-altern
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 3.5
         WIDTH              = 79.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 3.5
       FRAME f-main:WIDTH            = 79.29.

/* SETTINGS FOR FILL-IN c-desc-usuario IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN mla-usuar-aprov-altern.cod-usuar-altern IN FRAME f-main
   NO-ENABLE 1                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME mla-usuar-aprov-altern.cod-usuar-altern
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov-altern.cod-usuar-altern V-table-Win
ON F5 OF mla-usuar-aprov-altern.cod-usuar-altern IN FRAME f-main /* Alternativo */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z02in785.w
                       &campo=mla-usuar-aprov-altern.cod-usuar-altern
                       &campozoom=cod-usuar}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov-altern.cod-usuar-altern V-table-Win
ON LEAVE OF mla-usuar-aprov-altern.cod-usuar-altern IN FRAME f-main /* Alternativo */
DO:

    {include/leave.i &tabela=mla-usuar-aprov
                     &atributo-ref=nome-usuar
                     &variavel-ref=c-desc-usuario
                     &where="mla-usuar-aprov.cod-usuar = input frame {&frame-name} mla-usuar-aprov-altern.cod-usuar-altern"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov-altern.cod-usuar-altern V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-usuar-aprov-altern.cod-usuar-altern IN FRAME f-main /* Alternativo */
DO:

    apply 'f5' to self.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  if mla-usuar-aprov-altern.cod-usuar-altern:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "mla-usuar-aprov-altern"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-usuar-aprov-altern"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}
    
    /* Ponha na pi-validate todas as validaes */
    /* No gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
   
    find first mla-usuar-aprov where
        rowid(mla-usuar-aprov) = v-row-parent
        no-lock no-error.
    if adm-new-record then do:        
        find first b-mla-usuar-aprov-altern where
            b-mla-usuar-aprov-altern.cod-usuar        = mla-usuar-aprov.cod-usuar and
            b-mla-usuar-aprov-altern.cod-usuar-altern = input frame {&frame-name} mla-usuar-aprov-altern.cod-usuar-altern
            no-lock no-error.
        if available b-mla-usuar-aprov-altern then do:
            {utp/ut-table.i mgind mla-usuar-aprov-altern 1}
            run utp/ut-msgs.p ("show",1,trim(return-value)).
            apply "entry" to mla-usuar-aprov-altern.cod-usuar-altern in frame {&frame-name}.
            return "adm-error".                    
        end.
        find first b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = input frame {&frame-name} mla-usuar-aprov-altern.cod-usuar-altern
            no-lock no-error.
        if not available b-mla-usuar-aprov then do:
            {utp/ut-table.i mgind mla-usuar-aprov 1}
            run utp/ut-msgs.p ("show",2,trim(return-value)).
            apply "entry" to mla-usuar-aprov-altern.cod-usuar-altern in frame {&frame-name}.
            return "adm-error".                    
        end.
    end.

    if avail b-mla-usuar-aprov and b-mla-usuar-aprov.perm-aprov = NO THEN DO:
        run utp/ut-msgs.p ("show",54988, b-mla-usuar-aprov.cod-usuar).
        apply "entry" to mla-usuar-aprov-altern.cod-usuar-altern in frame {&frame-name}.
        return "adm-error".
    END.
    
    if  input frame {&frame-name} mla-usuar-aprov-altern.validade-ini = ""
    or  input frame {&frame-name} mla-usuar-aprov-altern.validade-ini = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 173,
                           input "").
        apply "entry" to mla-usuar-aprov-altern.validade-ini in frame {&frame-name}.
        return "adm-error".                    
    end.

    if  input frame {&frame-name} mla-usuar-aprov-altern.validade-fim = ""
    or  input frame {&frame-name} mla-usuar-aprov-altern.validade-fim = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 173,
                           input "").
        apply "entry" to mla-usuar-aprov-altern.validade-fim in frame {&frame-name}.
        return "adm-error".                    
    end.

    if  input frame {&frame-name} mla-usuar-aprov-altern.validade-ini >
        input frame {&frame-name} mla-usuar-aprov-altern.validade-fim then do:
        {utp/ut-liter.i Validade_inicial * r}
        assign c-validade-ini = return-value.
        {utp/ut-liter.i Validade_final * r}
        assign c-validade-fim = return-value.
        run utp/ut-msgs.p ("show",1207, c-validade-fim + "~~" + c-validade-ini).
        apply "entry" to mla-usuar-aprov-altern.validade-ini in frame {&frame-name}.
        return "adm-error".                    
    end.

    if not adm-new-record then
        run pi-log-reg.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if adm-new-record then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-usuar-aprov-altern.ep-codigo
               mla-log-reg.cod-estabel = ""
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 24
               mla-log-reg.chave-reg   = string(mla-usuar-aprov-altern.cod-usuar) + " | " +
                                         string(mla-usuar-aprov-altern.cod-usuar-altern)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
        .
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {ininc/i03in030.i 03}.
            RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
            ASSIGN mla-log-reg.log-reg     = entry(24, cAuxTraducao001) + chr(13).
        &else
            ASSIGN mla-log-reg.log-reg     = entry(24,{ininc/i03in030.i 03}) + chr(13).
        &endif
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg +
                     "Usu rio            : " + string(mla-usuar-aprov-altern.cod-usuar)        + chr(13) + 
                     "Alternativo        : " + string(mla-usuar-aprov-altern.cod-usuar-altern) + chr(13) + 
                     "Validade Inicial   : " + string(mla-usuar-aprov-altern.validade-ini)     + chr(13) +                                      
                     "Validade Final     : " + string(mla-usuar-aprov-altern.validade-fim).              
    end.
    
    /**  Controlado agora pelo parmetro mla-param-aprov.log-1
    ***
    IF adm-new-record THEN DO:
       FIND FIRST bb-mla-usuar-aprov
            WHERE bb-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar
            NO-LOCK NO-ERROR.
       FOR EACH  mla-perm-aprov
           WHERE mla-perm-aprov.ep-codigo   = bb-mla-usuar-aprov.ep-codigo
           AND   mla-perm-aprov.cod-estabel = bb-mla-usuar-aprov.cod-estabel
           AND   mla-perm-aprov.cod-usuar   = bb-mla-usuar-aprov.cod-usuar
           NO-LOCK:
           FIND FIRST b-mla-perm-aprov
                WHERE b-mla-perm-aprov.ep-codigo   = mla-perm-aprov.ep-codigo
                AND   b-mla-perm-aprov.cod-estabel = mla-perm-aprov.cod-estabel
                AND   b-mla-perm-aprov.cod-usuar   = mla-usuar-aprov-altern.cod-usuar-altern
                AND   b-mla-perm-aprov.cod-tip-doc = mla-perm-aprov.cod-tip-doc
                EXCLUSIVE-LOCK NO-ERROR.
           IF NOT AVAIL b-mla-perm-aprov THEN DO:
              CREATE b-mla-perm-aprov.
              BUFFER-COPY mla-perm-aprov EXCEPT cod-usuar TO b-mla-perm-aprov.
              ASSIGN b-mla-perm-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern.
           END.
           ELSE DO:
              IF b-mla-perm-aprov.limite-aprov < mla-perm-aprov.limite-aprov THEN
                 ASSIGN b-mla-perm-aprov.limite-aprov = mla-perm-aprov.limite-aprov.
           END.
       END.
    END.
    **/
    IF mla-usuar-aprov-altern.validade-ini <= TODAY AND
       mla-usuar-aprov-altern.validade-fim >= TODAY THEN
        run pi-envia-email-alternativos.

    /* Todos os assigns no feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    find first mla-usuar-aprov where
        rowid(mla-usuar-aprov) = v-row-parent
        no-lock no-error.
    if available mla-usuar-aprov then
        assign mla-usuar-aprov-altern.cod-usuar = mla-usuar-aprov.cod-usuar
               mla-usuar-aprov-altern.ep-codigo = mla-usuar-aprov.ep-codigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available mla-usuar-aprov-altern then do:
        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
            no-lock no-error.
        if available mla-usuar-aprov then
            assign c-desc-usuario:screen-value in frame {&frame-name} = 
                   mla-usuar-aprov.nome-usuar.
    end.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-email-alternativos V-table-Win 
PROCEDURE pi-envia-email-alternativos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Envio_de_e-mail_para: * R}
    ASSIGN c-txt-ini = TRIM(RETURN-VALUE).

    {utp/ut-liter.i Documento: * R}
    ASSIGN c-txt-acomp = TRIM(RETURN-VALUE).

    find first mla-usuar-aprov where
        rowid(mla-usuar-aprov) = v-row-parent
        no-lock no-error.

    for each tt-erros-geral:
        delete tt-erros-geral.
    end.
    assign l-enviou-alternativos = no.

    FIND estabelec WHERE
         estabelec.cod-estabel = mla-usuar-aprov.cod-estabel
         NO-LOCK NO-ERROR.

    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output i-empresa).

    run utp/ut-acomp.p persistent set h-acomp.

    run pi-inicializar in h-acomp (input c-txt-ini + " " + STRING(mla-usuar-aprov-altern.cod-usuar-altern) + " ":U).

    find mla-param-aprov where
        mla-param-aprov.ep-codigo   = i-empresa and
        mla-param-aprov.cod-estabel = mla-usuar-aprov.cod-estabel
        no-lock no-error.

    for each mla-doc-pend-aprov
        where mla-doc-pend-aprov.cod-usuar    = mla-usuar-aprov.cod-usuar
        and   mla-doc-pend-aprov.ind-situacao = 1 /* pendente */
        and   mla-doc-pend-aprov.historico    = no
        no-lock:

        find first mla-param-aprov where
            mla-param-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-param-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel
            no-lock no-error.

        find first mla-tipo-doc-aprov where
            mla-tipo-doc-aprov.ep-codigo   = mla-doc-pend-aprov.ep-codigo and
            mla-tipo-doc-aprov.cod-estabel = mla-doc-pend-aprov.cod-estabel and
            mla-tipo-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc
            no-lock no-error.

        find first mla-usuar-aprov where
            mla-usuar-aprov.cod-usuar = c-seg-usuario
            no-lock no-error.

        find first b-mla-usuar-aprov where
            b-mla-usuar-aprov.cod-usuar = mla-doc-pend-aprov.cod-usuar
            no-lock no-error.

        {lap/mlaapi001.i01}
        create tt-mla-chave.
        assign i-chave = 0.
        for each mla-chave-doc-aprov where
            mla-chave-doc-aprov.cod-tip-doc = mla-doc-pend-aprov.cod-tip-doc no-lock:
            assign i-chave = i-chave + 1
                   tt-mla-chave.valor[i-chave] = substring(mla-doc-pend-aprov.chave-doc,
                                                 mla-chave-doc-aprov.posicao-ini,
                                                 ((mla-chave-doc-aprov.posicao-fim -
                                                   mla-chave-doc-aprov.posicao-ini) + 1)).
        end.        

        if  available mla-param-aprov      and
            available mla-usuar-aprov      and
            available b-mla-usuar-aprov    and
            mla-usuar-aprov.envia-email    and
            b-mla-usuar-aprov.recebe-email and 
            b-mla-usuar-aprov.e-mail <> "" then do:

            run utp/ut-msgs.p (input "msg", input 26593, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                              mla-doc-pend-aprov.chave-doc + "~~" +
                                                              mla-doc-pend-aprov.cod-usuar-trans).
            assign c-ass-e-mail = return-value.
            
            for each tt-envio2:
                delete tt-envio2.
            end.
            
            for each tt-envio:
                delete tt-envio.
            end.
            
            /*  Se o parametro "Assume Limite do Principal" estiver desmarcado, so envia e-mail caso o alternativo tenha permissÆo */
            if (mla-param-aprov.log-1 = NO AND
               can-find(first mla-perm-aprov
                        where mla-perm-aprov.ep-codigo     = mla-doc-pend-aprov.ep-codigo
                          and mla-perm-aprov.cod-estabel   = mla-doc-pend-aprov.cod-estabel
                          and mla-perm-aprov.cod-tip-doc   = mla-doc-pend-aprov.cod-tip-doc
                          and mla-perm-aprov.cod-usuar     = mla-usuar-aprov-altern.cod-usuar-altern
                          and mla-perm-aprov.limite-aprov >= mla-doc-pend-aprov.valor-doc
                          and mla-perm-aprov.validade-ini <= today
                          and mla-perm-aprov.validade-fim >= today))
                OR mla-param-aprov.log-1 = YES THEN DO:
            
                IF mla-tipo-doc-aprov.log-html AND
                   mla-usuar-aprov.log-html    THEN DO:
                    /**  HTML
                    **/
                                        
                    /**  Envia E-mail para os Alternativos
                    **/                    
                    
                    if mla-param-aprov.log-aprov-altern then do:
                        if  mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                            mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao then do:
                            
                            RUN pi-acompanhar IN h-acomp(INPUT c-txt-acomp + STRING(mla-doc-pend-aprov.ep-codigo) +
                                                         "|" + STRING(mla-doc-pend-aprov.cod-estabel) +
                                                         "|" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "|" + STRING(tt-mla-chave.valor[1]) + " ":U).

                            find first b-mla-usuar-aprov where
                                b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                                no-lock no-error.
    
                            for each tt-html:
                                delete tt-html.
                            end.
                            for each tt-mensagem:
                                delete tt-mensagem.
                            end.
                            for each tt-envio2:
                                delete tt-envio2.
                            end.
                            for each tt-erros:
                                delete tt-erros.
                            end.
                            
                            IF  mla-tipo-doc-aprov.cod-tip-doc < 10 THEN
                                RUN VALUE("laphtml/mlahtml00" + STRING(mla-tipo-doc-aprov.cod-tip-doc) + "e.p") 
                                        (input  mla-tipo-doc-aprov.cod-tip-doc,
                                         input  b-mla-usuar-aprov.cod-usuar,
                                         input  table tt-mla-chave,
                                         output TABLE tt-html).
                            ELSE 
                                RUN VALUE("laphtml/mlahtml0" + STRING(mla-tipo-doc-aprov.cod-tip-doc) + "e.p") 
                                        (input  mla-tipo-doc-aprov.cod-tip-doc,
                                         input  b-mla-usuar-aprov.cod-usuar,
                                         input  table tt-mla-chave,
                                         output TABLE tt-html).
                            
                            FIND FIRST tt-html NO-ERROR.
                            IF  AVAILABLE tt-html THEN
                                ASSIGN c-men-e-mail = tt-html.html-doc.
    
                            /* Verifica o tamanho do e-mail, caso exceda 32k, o html sempre serÿ enviado como anexo */
                            RUN verificaTamanhoEmail.
            
                            if  l-anexar-conteudo then do:
                                assign c-arquivo = SESSION:TEMP-DIRECTORY + "/" + REPLACE(mla-doc-pend-aprov.cod-usuar," ","_") + "_" + REPLACE(TRIM(mla-doc-pend-aprov.chave-doc)," ","_") + "_" + STRING(TIME) + ".htm".
                                OUTPUT TO value(c-arquivo) CONVERT TARGET "UTF-8":U APPEND.
                                FOR EACH tt-html :
                                    PUT UNFORMATTED tt-html.html-doc SKIP.
                                END.
                                OUTPUT CLOSE.
                            end.
                            else do:
                                FOR EACH tt-html:
                                    CREATE tt-mensagem.
                                    ASSIGN tt-mensagem.seq-mensagem = tt-html.seq-html
                                           tt-mensagem.mensagem     = tt-html.html-doc.
                                END.
                            end.
                    
                            create tt-envio2.
                            assign tt-envio2.versao-integracao = 1
                                   tt-envio2.exchange    = mla-param-aprov.log-exchange
                                   tt-envio2.destino     = b-mla-usuar-aprov.e-mail
                                   tt-envio2.assunto     = c-ass-e-mail
                                   tt-envio2.importancia = 2
                                   tt-envio2.log-enviada = no
                                   tt-envio2.log-lida    = no
                                   tt-envio2.acomp       = no
                                   tt-envio2.formato     = "HTML".            
                                   
                            if  l-anexar-conteudo then
                                assign tt-envio2.mensagem    = "Foi gerada uma pendncia de aprovao!" + chr(10) +
                                                               "Favor verificar o arquivo atachado."
                                       tt-envio2.arq-anexo   = c-arquivo.
                            else                           
                                assign tt-envio2.mensagem    = c-men-e-mail
                                       tt-envio2.arq-anexo   = "".
                                   
                            if  not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                                assign tt-envio2.remetente = mla-usuar-aprov.e-mail.
    
                            /* Html para Palm */
                            run lap/mlaapi012.p (input mla-doc-pend-aprov.ep-codigo,
                                                  input mla-doc-pend-aprov.cod-estabel,
                                                  input mla-tipo-doc-aprov.cod-tip-doc,
                                                  input b-mla-usuar-aprov.cod-usuar,   
                                                  input table tt-mla-chave,
                                                  output c-arquivo-anexo). 
                            if  return-value = "OK" then do:
                                if  tt-envio2.arq-anexo = "" then
                                    assign tt-envio2.arq-anexo = c-arquivo-anexo.
                                else 
                                    assign tt-envio2.arq-anexo = tt-envio2.arq-anexo + ","
                                                               + c-arquivo-anexo.
                            end.
                            /*Fim Html para Palm*/
                                               
                            run utp/utapi019.p persistent set h-utapi019.
                            
                            if  l-anexar-conteudo then
                                run pi-execute  in h-utapi019 (input table tt-envio2,                   
                                                               output table tt-erros).
                            else
                                run pi-execute2 in h-utapi019 (input table tt-envio2,                   
                                                               input table tt-mensagem,
                                                               output table tt-erros).  
                
                            /**  Output do erro (e-mail)
                            **/               
                            find first tt-envio2 no-error.                    
                            {lap/mlaapi001.i02 "v01in014.w (02)" tt-envio2.destino tt-envio2.remetente}                                    
                
                            delete procedure h-utapi019.
                            
                            if  l-anexar-conteudo then
                                os-delete value(c-arquivo).
    
                            os-delete value(c-arquivo-anexo).
                            
                            assign l-enviou-alternativos = yes.
                        end.
                    end.
                end.
                else do:
                    /**  Texto
                    **/
    
                    find first moeda
                         where moeda.mo-codigo = mla-doc-pend-aprov.mo-codigo no-lock no-error.
    
                    run utp/ut-msgs.p (input "help", input 26593, input mla-tipo-doc-aprov.des-tip-doc + "~~" +
                                                                  moeda.sigla + " " + trim(string(mla-doc-pend-aprov.valor-doc,">>>,>>>,>>>,>>>,>>9.99")) + "~~" +
                                                                  mla-doc-pend-aprov.cod-usuar-trans).
                    assign c-men-e-mail = return-value.
        
                    if mla-param-aprov.compl-email <> "" then do:
                        assign c-men-e-mail = c-men-e-mail + chr(13) + trim(mla-param-aprov.compl-email).
                    end.
                    
                    /**  Envia E-mail para os Alternativos
                    **/                    
                    if mla-param-aprov.log-aprov-altern then do:
                        if  mla-usuar-aprov-altern.validade-ini <= mla-doc-pend-aprov.dt-geracao and
                            mla-usuar-aprov-altern.validade-fim >= mla-doc-pend-aprov.dt-geracao then do:

                            RUN pi-acompanhar IN h-acomp(INPUT c-txt-acomp + STRING(mla-doc-pend-aprov.ep-codigo) +
                                                         "|" + STRING(mla-doc-pend-aprov.cod-estabel) +
                                                         "|" + STRING(mla-doc-pend-aprov.cod-tip-doc) + "|" + STRING(tt-mla-chave.valor[1]) + " ":U).
    
                            find first b-mla-usuar-aprov where
                                b-mla-usuar-aprov.cod-usuar = mla-usuar-aprov-altern.cod-usuar-altern
                                no-lock no-error.
    
                            for each tt-envio:
                                delete tt-envio.
                            end.
                            for each tt-erros:
                                delete tt-erros.
                            end.
                            
                            create tt-envio.
                            assign tt-envio.versao-integracao = 1
                                   tt-envio.exchange    = mla-param-aprov.log-exchange
                                   tt-envio.destino     = b-mla-usuar-aprov.e-mail
                                   tt-envio.assunto     = c-ass-e-mail
                                   tt-envio.mensagem    = c-men-e-mail
                                   tt-envio.importancia = 2
                                   tt-envio.log-enviada = no
                                   tt-envio.log-lida    = no
                                   tt-envio.acomp       = no
                                   tt-envio.arq-anexo   = "".
                            if not mla-param-aprov.log-exchange and mla-usuar-aprov.e-mail <> "" then
                               assign tt-envio.remetente = mla-usuar-aprov.e-mail.
                                               
                            run utp/utapi009.p (input  table tt-envio,
                                                output table tt-erros).
                                                
                            /**  Output do erro (e-mail)
                            **/               
                            find first tt-envio no-error.                    
                            {lap/mlaapi001.i02 "v01in014.w (01)" tt-envio.destino tt-envio.remetente}                                    
    
                            assign l-enviou-alternativos = yes.
                                                
                        end.
                    end.
                end.
            end.
        
            for each tt-erros:
                create tt-erros-geral.
                buffer-copy tt-erros to tt-erros-geral.
            end.
        end.
    end.

    if valid-handle(h-acomp) THEN 
        run pi-finalizar in h-acomp.

    /* "l-enviou-alternativos = yes" indica que o processo de envio de e-mails foi executado */
    if  l-enviou-alternativos then do:
        if  not can-find(first tt-erros-geral) then
            /* O E-mail foi enviado com sucesso. */
            run utp/ut-msgs.p(input "show",
                              input 6474,
                              input "").
        else do:
            find first tt-erros-geral no-error.
            if  avail tt-erros-geral then do:
                {utp/ut-liter.i O_e-mail_nao_pode_ser_enviado_!}
                run utp/ut-msgs.p(input "show",
                                  input 17242,
                                  input return-value + "~~" + tt-erros-geral.desc-erro).
            end.
        end.
    end.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-reg V-table-Win 
PROCEDURE pi-log-reg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-log-reg = "".
    
    if available mla-usuar-aprov-altern then do:
        if mla-usuar-aprov-altern.validade-ini <> input frame {&frame-name} mla-usuar-aprov-altern.validade-ini then
            assign c-log-reg = c-log-reg + 
                   "Validade Inicial   : " + string(mla-usuar-aprov-altern.validade-ini) + chr(13) +
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov-altern.validade-ini) + chr(13) + chr(13).                   
        if mla-usuar-aprov-altern.validade-fim <> input frame {&frame-name} mla-usuar-aprov-altern.validade-fim then
            assign c-log-reg = c-log-reg + 
                   "Validade Final     : " + string(mla-usuar-aprov-altern.validade-fim) + chr(13) +
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov-altern.validade-fim) + chr(13) + chr(13).                   
    end.
    
    if c-log-reg <> "" then do:
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-usuar-aprov-altern.ep-codigo
               mla-log-reg.cod-estabel = ""
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 24
               mla-log-reg.chave-reg   = string(mla-usuar-aprov-altern.cod-usuar) + " | " +
                                         string(mla-usuar-aprov-altern.cod-usuar-altern)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
        .
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {ininc/i03in030.i 03}.
            RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao002).
            ASSIGN mla-log-reg.log-reg     = entry(24, cAuxTraducao002) + chr(13).
        &else
            ASSIGN mla-log-reg.log-reg     = entry(24,{ininc/i03in030.i 03}) + chr(13).
        &endif
        ASSIGN mla-log-reg.log-reg = mla-log-reg.log-reg +
                     "Usu rio            : " + string(mla-usuar-aprov-altern.cod-usuar)        + chr(13) + 
                     "Alternativo        : " + string(mla-usuar-aprov-altern.cod-usuar-altern) + chr(13) + 
                     "Validade Inicial   : " + string(mla-usuar-aprov-altern.validade-ini)     + chr(13) +                                      
                     "Validade Final     : " + string(mla-usuar-aprov-altern.validade-fim).              
    end.

     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: No fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaes, pois neste ponto do programa o registro 
  ainda no foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validao de dicionrio */
    
/*/*    Segue um exemplo de validao de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "mla-usuar-aprov-altern"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaTamanhoEmail V-table-Win 
PROCEDURE verificaTamanhoEmail :
/* -----------------------------------------------------------
  Purpose: Validar se o tamanho do e-mail ultrapassa 32k.
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
    DEFINE VARIABLE i-tamanho-msg     AS INTEGER     NO-UNDO.

    IF NOT mla-param-aprov.log-atachado  THEN DO:
        FOR EACH tt-html:
            ASSIGN i-tamanho-msg = i-tamanho-msg + LENGTH(tt-html.html-doc).
        END.

        IF i-tamanho-msg > 32000 THEN DO:
            ASSIGN l-anexar-conteudo = YES.
        END.
    END.
    ELSE DO:
        ASSIGN l-anexar-conteudo = mla-param-aprov.log-atachado.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



