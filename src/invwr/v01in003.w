&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V01IN003 2.00.00.001}  /*** 010001 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in003 MUT}
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

{cdp/cd0666.i}

def var c-empresa LIKE empresa.ep-codigo no-undo.
def var c-log-reg as char    no-undo.

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
&Scoped-define EXTERNAL-TABLES mla-usuar-aprov
&Scoped-define FIRST-EXTERNAL-TABLE mla-usuar-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-usuar-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-usuar-aprov.nome-usuar ~
mla-usuar-aprov.cod-estabel mla-usuar-aprov.cod-lotacao ~
mla-usuar-aprov.mo-codigo mla-usuar-aprov.destino-lotacao ~
mla-usuar-aprov.perm-aprov mla-usuar-aprov.envia-email ~
mla-usuar-aprov.log-4 mla-usuar-aprov.usuar-mestre ~
mla-usuar-aprov.recebe-email mla-usuar-aprov.aprova-auto ~
mla-usuar-aprov.libera-verba mla-usuar-aprov.log-html ~
mla-usuar-aprov.aprova-auto-aprov 
&Scoped-define ENABLED-TABLES mla-usuar-aprov
&Scoped-define FIRST-ENABLED-TABLE mla-usuar-aprov
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS mla-usuar-aprov.cod-usuar ~
mla-usuar-aprov.nome-usuar mla-usuar-aprov.cod-estabel ~
mla-usuar-aprov.cod-lotacao mla-usuar-aprov.mo-codigo ~
mla-usuar-aprov.destino-lotacao mla-usuar-aprov.perm-aprov ~
mla-usuar-aprov.envia-email mla-usuar-aprov.log-4 ~
mla-usuar-aprov.usuar-mestre mla-usuar-aprov.recebe-email ~
mla-usuar-aprov.aprova-auto mla-usuar-aprov.libera-verba ~
mla-usuar-aprov.log-html mla-usuar-aprov.aprova-auto-aprov 
&Scoped-define DISPLAYED-TABLES mla-usuar-aprov
&Scoped-define FIRST-DISPLAYED-TABLE mla-usuar-aprov
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel c-desc-lotacao c-desc-moeda ~
c-e-mail 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS mla-usuar-aprov.cod-usuar 
&Scoped-define ADM-MODIFY-FIELDS c-e-mail 

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
DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 42.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-lotacao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-e-mail AS CHARACTER FORMAT "X(80)" 
     LABEL "c-e-mail" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 2.5.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 4.38.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 1.5.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 4.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     mla-usuar-aprov.cod-usuar AT ROW 1.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     mla-usuar-aprov.nome-usuar AT ROW 2.25 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.14 BY .88
     mla-usuar-aprov.cod-estabel AT ROW 4 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.29 BY .88
     c-desc-estabel AT ROW 4 COL 33.29 COLON-ALIGNED NO-LABEL
     mla-usuar-aprov.cod-lotacao AT ROW 5 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     c-desc-lotacao AT ROW 5 COL 44.43 COLON-ALIGNED NO-LABEL
     mla-usuar-aprov.mo-codigo AT ROW 6 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .88
     c-desc-moeda AT ROW 6 COL 30.29 COLON-ALIGNED NO-LABEL
     mla-usuar-aprov.destino-lotacao AT ROW 7.13 COL 28 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Lota‡Æo", 1,
"Centro Custo", 2
          SIZE 26.29 BY .83
     mla-usuar-aprov.perm-aprov AT ROW 9.25 COL 8.14
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .83
     mla-usuar-aprov.envia-email AT ROW 9.25 COL 30.86
          VIEW-AS TOGGLE-BOX
          SIZE 15.14 BY .83
     mla-usuar-aprov.log-4 AT ROW 9.25 COL 53.29
          LABEL "E-mail HTML Palm"
          VIEW-AS TOGGLE-BOX
          SIZE 26.72 BY .83
     mla-usuar-aprov.usuar-mestre AT ROW 10.25 COL 8.14
          VIEW-AS TOGGLE-BOX
          SIZE 10 BY .83
     mla-usuar-aprov.recebe-email AT ROW 10.25 COL 30.86
          VIEW-AS TOGGLE-BOX
          SIZE 16.86 BY .83
     mla-usuar-aprov.aprova-auto AT ROW 10.25 COL 53.29
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     mla-usuar-aprov.libera-verba AT ROW 11.25 COL 8.14
          VIEW-AS TOGGLE-BOX
          SIZE 15.29 BY .83
     mla-usuar-aprov.log-html AT ROW 11.25 COL 30.86
          VIEW-AS TOGGLE-BOX
          SIZE 15.43 BY .83
     mla-usuar-aprov.aprova-auto-aprov AT ROW 11.25 COL 53.29
          VIEW-AS TOGGLE-BOX
          SIZE 34.57 BY .83
     c-e-mail AT ROW 13 COL 26 COLON-ALIGNED
     "Respons vel:" VIEW-AS TEXT
          SIZE 9.43 BY .67 AT ROW 7.17 COL 18.14
     RECT-12 AT ROW 1 COL 1
     RECT-13 AT ROW 3.75 COL 1
     RECT-14 AT ROW 12.75 COL 1
     RECT-15 AT ROW 8.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mla-usuar-aprov
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
         HEIGHT             = 13.25
         WIDTH              = 88.29.
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
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-lotacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-e-mail IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN mla-usuar-aprov.cod-usuar IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX mla-usuar-aprov.log-4 IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME mla-usuar-aprov.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-estabel V-table-Win
ON F5 OF mla-usuar-aprov.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

    {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=mla-usuar-aprov.cod-estabel
                       &campozoom=cod-estabel}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-estabel V-table-Win
ON LEAVE OF mla-usuar-aprov.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:

   {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=c-desc-estabel
                    &where="estabelec.cod-estabel = input frame {&frame-name} mla-usuar-aprov.cod-estabel"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-usuar-aprov.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
    apply 'f5' to self.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-usuar-aprov.cod-lotacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-lotacao V-table-Win
ON F5 OF mla-usuar-aprov.cod-lotacao IN FRAME f-main /* Lota‡Æo */
DO:

    {include/zoomvar.i &prog-zoom=inzoom/z01in772.w
                       &campo=mla-usuar-aprov.cod-lotacao
                       &campozoom=cod-lotacao}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-lotacao V-table-Win
ON LEAVE OF mla-usuar-aprov.cod-lotacao IN FRAME f-main /* Lota‡Æo */
DO:


    FIND estabelec WHERE
         estabelec.cod-estabel = input frame {&frame-name} mla-usuar-aprov.cod-estabel
         NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
       run cdp/cd9970.p (input  ROWID(estabelec),
                         output c-empresa).

   {include/leave.i &tabela=mla-lotacao
                    &atributo-ref=desc-lotacao
                    &variavel-ref=c-desc-lotacao
                    &where="mla-lotacao.ep-codigo = c-empresa and
                            mla-lotacao.cod-lotacao = input frame {&frame-name} mla-usuar-aprov.cod-lotacao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-lotacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-usuar-aprov.cod-lotacao IN FRAME f-main /* Lota‡Æo */
DO:
    apply 'f5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-usuar-aprov.cod-usuar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-usuar V-table-Win
ON F5 OF mla-usuar-aprov.cod-usuar IN FRAME f-main /* Usu rio */
DO:

    {include/zoomvar.i &prog-zoom=unzoom/z01un178.w
                       &campo=mla-usuar-aprov.cod-usuar
                       &campozoom=cod_usuario}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-usuar V-table-Win
ON LEAVE OF mla-usuar-aprov.cod-usuar IN FRAME f-main /* Usu rio */
DO:

  {include/leave.i &tabela=usuar_mestre
                   &atributo-ref=nom_usuario
                   &variavel-ref=mla-usuar-aprov.nome-usuar
                   &where="usuar_mestre.cod_usuario = input frame {&frame-name} mla-usuar-aprov.cod-usuar"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.cod-usuar V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-usuar-aprov.cod-usuar IN FRAME f-main /* Usu rio */
DO:

    apply 'f5' to self.  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mla-usuar-aprov.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.mo-codigo V-table-Win
ON F5 OF mla-usuar-aprov.mo-codigo IN FRAME f-main /* Moeda */
DO:

    {include/zoomvar.i &prog-zoom=unzoom/z01un005.w
                       &campo=mla-usuar-aprov.mo-codigo
                       &campozoom=mo-codigo}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.mo-codigo V-table-Win
ON LEAVE OF mla-usuar-aprov.mo-codigo IN FRAME f-main /* Moeda */
DO:

   {include/leave.i &tabela=mguni.moeda
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-moeda
                    &where="mguni.moeda.mo-codigo = input frame {&frame-name} mla-usuar-aprov.mo-codigo"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-usuar-aprov.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-usuar-aprov.mo-codigo IN FRAME f-main /* Moeda */
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

  if mla-usuar-aprov.cod-usuar:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then.
  if mla-usuar-aprov.cod-estabel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if mla-usuar-aprov.cod-lotacao:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if mla-usuar-aprov.mo-codigo:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then.

  ASSIGN c-e-mail:LABEL IN FRAME {&FRAME-NAME} = "E-mail".

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
  {src/adm/template/row-list.i "mla-usuar-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-usuar-aprov"}

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
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    if  adm-new-record = yes then do: 
        find first mla-usuar-aprov where 
            mla-usuar-aprov.cod-usuar = input frame {&frame-name} mla-usuar-aprov.cod-usuar
            no-lock no-error.
        if  avail mla-usuar-aprov then do:
            {utp/ut-table.i mgind mla-usuar-aprov 1}
            run utp/ut-msgs.p ("show",1,trim(return-value)).
            apply "entry" to mla-usuar-aprov.cod-usuar in frame {&frame-name}.
            return "adm-error".                    
        end.
        find usuar_mestre where 
            usuar_mestre.cod_usuario = input frame {&frame-name} mla-usuar-aprov.cod-usuar
            no-lock no-error.
        if  not avail usuar_mestre then do:
            {utp/ut-table.i mguni usuar_mestre 1}
            run utp/ut-msgs.p ("show",2,return-value).
            apply "entry" to mla-usuar-aprov.cod-usuar in frame {&frame-name}.
            return "adm-error".  
        end.                    
    end.   

    find first estabelec where
        estabelec.cod-estabel = input frame {&frame-name} mla-usuar-aprov.cod-estabel
        no-lock no-error.
    if not available estabelec then do:
        {utp/ut-table.i mgadm estabelec 1}
        run utp/ut-msgs.p ("show",2,return-value).
        apply "entry" to mla-usuar-aprov.cod-estabel in frame {&frame-name}.
        return "adm-error".  
    end.            
    
    run cdp/cd9970.p (input  ROWID(estabelec),
                      output c-empresa).
    find first mla-lotacao where
        mla-lotacao.ep-codigo   = c-empresa and
        mla-lotacao.cod-lotacao = input frame {&frame-name} mla-usuar-aprov.cod-lotacao
        no-lock no-error.
    if not available mla-lotacao then do:
        {utp/ut-table.i mgind mla-lotacao 1}
        run utp/ut-msgs.p ("show",2,return-value).
        apply "entry" to mla-usuar-aprov.cod-lotacao in frame {&frame-name}.
        return "adm-error".  
    end.            
    find first mguni.moeda where
        mguni.moeda.mo-codigo = input frame {&frame-name} mla-usuar-aprov.mo-codigo
        no-lock no-error.
    if not available mguni.moeda then do:
        {utp/ut-liter.i Moeda * r}
        run utp/ut-msgs.p ("show",2,return-value).
        apply "entry" to mla-usuar-aprov.mo-codigo in frame {&frame-name}.
        return "adm-error".  
    end.

    if not adm-new-record then
        run pi-log-reg.

    ASSIGN INPUT FRAME {&FRAME-NAME} c-e-mail.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    ASSIGN mla-usuar-aprov.e-mail                       = c-e-mail
           c-e-mail:screen-value in frame {&frame-name} = c-e-mail.
    
    if adm-new-record then do:
        assign mla-usuar-aprov.ep-codigo = c-empresa.

        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-usuar-aprov.ep-codigo
               mla-log-reg.cod-estabel = ""
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 23
               mla-log-reg.chave-reg   = string(mla-usuar-aprov.cod-usuar)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 1
               mla-log-reg.log-reg     = entry(23,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         "C¢digo             : " + string(mla-usuar-aprov.cod-usuar)         + chr(13) + 
                                         "Nome               : " + string(mla-usuar-aprov.nome-usuar)        + chr(13) + 
                                         "Lota‡Æo            : " + string(mla-usuar-aprov.cod-lotacao)       + chr(13) +                                      
                                         "Estabelecimento    : " + string(mla-usuar-aprov.cod-estabel)       + chr(13) +                                      
                                         "Moeda              : " + string(mla-usuar-aprov.mo-codigo)         + chr(13) +                                                                           
                                         "Aprovador          : " + string(mla-usuar-aprov.perm-aprov)        + chr(13) +                                                                           
                                         "Aprova‡Æo Auto     : " + string(mla-usuar-aprov.aprova-auto)       + chr(13) +                                                                           
                                         "Aprov Auto Aprov   : " + string(mla-usuar-aprov.aprova-auto-aprov) + chr(13) +                                                                           
                                         "Destino Lota‡Æo    : " + string(mla-usuar-aprov.destino-lotacao)   + chr(13) +                                                                                                                
                                         "Libera Verba       : " + string(mla-usuar-aprov.libera-verba)      + chr(13) +                                                                                                                
                                         "Log HTML           : " + string(mla-usuar-aprov.log-html)          + chr(13) +  
                                         "E-mail HTML Palm   : " + string(mla-usuar-aprov.log-4)             + chr(13) +
                                         "Usu rio Mestre     : " + string(mla-usuar-aprov.usuar-mestre)      + chr(13) +                                                                                                                                                                                                                              
                                         "Envia E-mail       : " + string(mla-usuar-aprov.envia-email)       + chr(13) +                                                                                                                
                                         "Recebe E-mail      : " + string(mla-usuar-aprov.recebe-email)      + chr(13) +                                                                                                                
                                         "E-mail             : " + string(mla-usuar-aprov.e-mail).
    end.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    run lap/mlaapi003.p (mla-usuar-aprov.cod-usuar,
                          output table tt-erro).
    find first tt-erro no-lock no-error.
    if avail tt-erro then do: 
        run cdp/cd0666.w (input table tt-erro).
        return "adm-error".
    end.    

    create mla-log-reg.
    assign mla-log-reg.ep-codigo   = mla-usuar-aprov.ep-codigo
           mla-log-reg.cod-estabel = ""
           mla-log-reg.cod-usuar   = c-seg-usuario
           mla-log-reg.cod-tabela  = 23
           mla-log-reg.chave-reg   = string(mla-usuar-aprov.cod-usuar)
           mla-log-reg.data-reg    = today
           mla-log-reg.hora-reg    = string(time,"hh:mm")
           mla-log-reg.tipo-reg    = 3
           mla-log-reg.log-reg     = entry(23,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                     "C¢digo             : " + string(mla-usuar-aprov.cod-usuar)         + chr(13) + 
                                     "Nome               : " + string(mla-usuar-aprov.nome-usuar)        + chr(13) + 
                                     "Lota‡Æo            : " + string(mla-usuar-aprov.cod-lotacao)       + chr(13) +                                      
                                     "Estabelecimento    : " + string(mla-usuar-aprov.cod-estabel)       + chr(13) +                                      
                                     "Moeda              : " + string(mla-usuar-aprov.mo-codigo)         + chr(13) +                                                                           
                                     "Aprovador          : " + string(mla-usuar-aprov.perm-aprov)        + chr(13) +                                                                           
                                     "Aprova‡Æo Auto     : " + string(mla-usuar-aprov.aprova-auto)       + chr(13) +                                                                           
                                     "Aprov Auto Aprov   : " + string(mla-usuar-aprov.aprova-auto-aprov) + chr(13) +                                                                           
                                     "Destino Lota‡Æo    : " + string(mla-usuar-aprov.destino-lotacao)   + chr(13) +                                                                                                                
                                     "Libera Verba       : " + string(mla-usuar-aprov.libera-verba)      + chr(13) +                                                                                                                
                                     "Log HTML           : " + string(mla-usuar-aprov.log-html)          + chr(13) +  
                                     "E-mail HTML Palm   : " + string(mla-usuar-aprov.log-4)             + chr(13) +  
                                     "Usu rio Mestre     : " + string(mla-usuar-aprov.usuar-mestre)      + chr(13) +                                                                                                                                                                                                                              
                                     "Envia E-mail       : " + string(mla-usuar-aprov.envia-email)       + chr(13) +                                                                                                                
                                     "Recebe E-mail      : " + string(mla-usuar-aprov.recebe-email)      + chr(13) +                                                                                                                
                                     "E-mail             : " + string(mla-usuar-aprov.e-mail).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

    if available mla-usuar-aprov then do:
    
        {include/leave.i &tabela=estabelec
                         &atributo-ref=nome
                         &variavel-ref=c-desc-estabel
                         &where="estabelec.cod-estabel = input frame {&frame-name} mla-usuar-aprov.cod-estabel"}
    
        FIND estabelec WHERE
             estabelec.cod-estabel = mla-usuar-aprov.cod-estabel
             NO-LOCK NO-ERROR.
        IF AVAIL estabelec THEN
           run cdp/cd9970.p (input  ROWID(estabelec),
                             output c-empresa).
    
        find first mla-lotacao where
            mla-lotacao.ep-codigo   = c-empresa and
            mla-lotacao.cod-lotacao = mla-usuar-aprov.cod-lotacao
            no-lock no-error.
        assign c-desc-lotacao:screen-value in frame {&frame-name} =
            if available mla-lotacao then mla-lotacao.desc-lotacao
            else "".
            
        find first mguni.moeda where
            mguni.moeda.mo-codigo = mla-usuar-aprov.mo-codigo
            no-lock no-error.
        assign c-desc-moeda:screen-value in frame {&frame-name} =
            if available mguni.moeda then mguni.moeda.descricao
            else "".            

        ASSIGN c-e-mail:SCREEN-VALUE IN FRAME {&FRAME-NAME} = mla-usuar-aprov.e-mail.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-log-reg V-table-Win 
PROCEDURE pi-log-reg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign c-log-reg = "".
    
    if  available mla-usuar-aprov then do:

        if  mla-usuar-aprov.nome-usuar <> input frame {&frame-name} mla-usuar-aprov.nome-usuar then
            assign c-log-reg = c-log-reg +
                   "Nome               : " + string(mla-usuar-aprov.nome-usuar) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov.nome-usuar) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.cod-lotacao <> input frame {&frame-name} mla-usuar-aprov.cod-lotacao then
            assign c-log-reg = c-log-reg +
                   "Lota‡Æo            : " + string(mla-usuar-aprov.cod-lotacao) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov.cod-lotacao) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.cod-estabel <> input frame {&frame-name} mla-usuar-aprov.cod-estabel then
            assign c-log-reg = c-log-reg +
                   "Estabelecimento    : " + string(mla-usuar-aprov.cod-estabel) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov.cod-estabel) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.mo-codigo <> input frame {&frame-name} mla-usuar-aprov.mo-codigo then
            assign c-log-reg = c-log-reg +
                   "Moeda              : " + string(mla-usuar-aprov.mo-codigo) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov.mo-codigo) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.e-mail <> input frame {&frame-name} c-e-mail then
            assign c-log-reg = c-log-reg +
                   "E-mail             : " + string(mla-usuar-aprov.e-mail) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} c-e-mail) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.destino-lotacao <> input frame {&frame-name} mla-usuar-aprov.destino-lotacao then
            assign c-log-reg = c-log-reg +
                   "Destino Lota‡Æo    : " + string(mla-usuar-aprov.destino-lotacao) + chr(13) +             
                   "                   : " + string(input frame {&frame-name} mla-usuar-aprov.destino-lotacao) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.perm-aprov <> mla-usuar-aprov.perm-aprov:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Aprovador          : " + string(mla-usuar-aprov.perm-aprov) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.perm-aprov:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.aprova-auto <> mla-usuar-aprov.aprova-auto:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Aprova‡Æo Auto     : " + string(mla-usuar-aprov.aprova-auto) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.aprova-auto:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.aprova-auto-aprov <> mla-usuar-aprov.aprova-auto-aprov:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Aprov Auto Aprov   : " + string(mla-usuar-aprov.aprova-auto-aprov) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.aprova-auto-aprov:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.libera-verba <> mla-usuar-aprov.libera-verba:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Libera Verba       : " + string(mla-usuar-aprov.libera-verba) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.libera-verba:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.log-html <> mla-usuar-aprov.log-html:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Log HTML           : " + string(mla-usuar-aprov.log-html) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.log-html:checked in frame {&frame-name}) + chr(13) + chr(13). 
        if  mla-usuar-aprov.log-4 <> mla-usuar-aprov.log-4:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Log HTML Palm      : " + string(mla-usuar-aprov.log-4) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.log-4:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.usuar-mestre <> mla-usuar-aprov.usuar-mestre:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Usu rio Mestre     : " + string(mla-usuar-aprov.usuar-mestre) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.usuar-mestre:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.envia-email <> mla-usuar-aprov.envia-email:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Envia E-mail       : " + string(mla-usuar-aprov.envia-email) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.envia-email:checked in frame {&frame-name}) + chr(13) + chr(13).                   
        if  mla-usuar-aprov.recebe-email <> mla-usuar-aprov.recebe-email:checked in frame {&frame-name} then
            assign c-log-reg = c-log-reg +
                   "Recebe E-mail      : " + string(mla-usuar-aprov.recebe-email) + chr(13) +             
                   "                   : " + string(mla-usuar-aprov.recebe-email:checked in frame {&frame-name}) + chr(13) + chr(13).                   
    end.

    if c-log-reg <> "" then do:    
        create mla-log-reg.
        assign mla-log-reg.ep-codigo   = mla-usuar-aprov.ep-codigo
               mla-log-reg.cod-estabel = ""
               mla-log-reg.cod-usuar   = c-seg-usuario
               mla-log-reg.cod-tabela  = 23
               mla-log-reg.chave-reg   = string(mla-usuar-aprov.cod-usuar)
               mla-log-reg.data-reg    = today
               mla-log-reg.hora-reg    = string(time,"hh:mm")
               mla-log-reg.tipo-reg    = 2
               mla-log-reg.log-reg     = entry(23,{ininc/i03in030.i 03}) + chr(13) + chr(13) +
                                         c-log-reg.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
    
/*/*    Segue um exemplo de valida‡Æo de programa */
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
  {src/adm/template/snd-list.i "mla-usuar-aprov"}

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

