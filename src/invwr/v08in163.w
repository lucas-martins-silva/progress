&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V08IN163 2.00.00.004}  /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN163 MUT}
&ENDIF


CREATE WIDGET-POOL.
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.
DEF VAR h-boin01017  AS HANDLE NO-UNDO.


{inbo/boin01017.i tt-ext-item-doc-est}   /* Definiá∆o TT-EXT-ITEM-DOC-EXT - Extens∆o da item-doc-est */

def new global shared var gr-doc-fisico as rowid   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE it-doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-doc-fisico.narrativa 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES it-doc-fisico
&Scoped-define FIRST-ENABLED-TABLE it-doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key RECT-1 
&Scoped-Define DISPLAYED-FIELDS it-doc-fisico.narrativa 
&Scoped-define DISPLAYED-TABLES it-doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE it-doc-fisico
&Scoped-Define DISPLAYED-OBJECTS i-seq-xml c-desc-xml c-un-emit-xml 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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
DEFINE VARIABLE c-desc-xml AS CHARACTER FORMAT "X(120)":U 
     LABEL "Descriá∆o Item XML" 
     VIEW-AS FILL-IN 
     SIZE 60.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-emit-xml AS CHARACTER FORMAT "X(6)":U 
     LABEL "Unid Med Emit XML" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-seq-xml AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Sequància XML" 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 3.63.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 7.03.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-doc-fisico.narrativa AT ROW 1.95 COL 2.29 NO-LABEL
          VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
          SIZE 83.14 BY 5.5
     i-seq-xml AT ROW 8.75 COL 19.72 COLON-ALIGNED
     c-desc-xml AT ROW 9.75 COL 19.72 COLON-ALIGNED
     c-un-emit-xml AT ROW 10.75 COL 19.72 COLON-ALIGNED
     "Narrativa:" VIEW-AS TEXT SIZE 8 BY 0.5 AT ROW 1 COL 3.5
     rt-key AT ROW 1.2 COL 1
     RECT-1 AT ROW 8.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.it-doc-fisico
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.25
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-xml IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-emit-xml IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-seq-xml IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "it-doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-doc-fisico"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

    {include/i-valid.i}

    ASSIGN i-seq-xml = int(i-seq-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME})
           c-desc-xml = c-desc-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME}
           c-un-emit-xml = c-un-emit-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    IF AVAIL it-doc-fisico THEN DO:
        IF i-seq-xml <> 0 THEN DO:
            ASSIGN OVERLAY(it-doc-fisico.char-2,42,5) = STRING(i-seq-xml).
        END.

        IF c-desc-xml <> "" OR c-un-emit-xml <> "" THEN DO:
            EMPTY TEMP-TABLE tt-ext-item-doc-est.
            CREATE tt-ext-item-doc-est.
            ASSIGN tt-ext-item-doc-est.serie-docto  = it-doc-fisico.serie-docto
                   tt-ext-item-doc-est.nro-docto    = it-doc-fisico.nro-docto
                   tt-ext-item-doc-est.cod-emitente = it-doc-fisico.cod-emitente
                   tt-ext-item-doc-est.nat-operacao = ""
                   tt-ext-item-doc-est.sequencia    = it-doc-fisico.sequencia
                   tt-ext-item-doc-est.cod-param    = "infoXML":U.
            ASSIGN tt-ext-item-doc-est.num-livre-1 = it-doc-fisico.tipo-nota
                   OVERLAY(tt-ext-item-doc-est.cod-livre-1,1,120) = c-desc-xml
                   OVERLAY(tt-ext-item-doc-est.cod-livre-2,1,6)   = c-un-emit-xml.

            RUN goToKey IN h-boin01017 (INPUT tt-ext-item-doc-est.serie-docto, 
                                        INPUT tt-ext-item-doc-est.nro-docto,   
                                        INPUT tt-ext-item-doc-est.cod-emitente,
                                        INPUT tt-ext-item-doc-est.nat-operacao,
                                        INPUT tt-ext-item-doc-est.sequencia,   
                                        INPUT "infoXML"). 
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN emptyRowErrors IN h-boin01017. 
                RUN setRecord IN h-boin01017 (INPUT TABLE tt-ext-item-doc-est).
                RUN updateRecord IN h-boin01017.  
            END.    
            ELSE DO:
                RUN emptyRowErrors IN h-boin01017. 
                RUN setRecord IN h-boin01017 (INPUT TABLE tt-ext-item-doc-est).
                RUN createRecord IN h-boin01017.
            END.
        END.



    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF VALID-HANDLE(h-boin01017) THEN 
      RUN destroy IN h-boin01017.   

  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    DISABLE i-seq-xml
            c-desc-xml
            c-un-emit-xml WITH FRAME {&frame-name}.

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

  IF AVAILABLE it-doc-fisico THEN DO:
      ASSIGN i-seq-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME}     = SUBSTRING(it-doc-fisico.char-2,42,5)
             c-desc-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = ""
             c-un-emit-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

      FOR FIRST ext-item-doc-est NO-LOCK
          WHERE ext-item-doc-est.serie-docto  = it-doc-fisico.serie-docto
            AND ext-item-doc-est.nro-docto    = it-doc-fisico.nro-docto
            AND ext-item-doc-est.cod-emitente = it-doc-fisico.cod-emitente
            AND ext-item-doc-est.sequencia    = it-doc-fisico.sequencia
            AND ext-item-doc-est.cod-param    = "infoXML":U:
          IF ext-item-doc-est.num-livre-1  = it-doc-fisico.tipo-nota THEN
               ASSIGN c-desc-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = SUBSTRING(ext-item-doc-est.cod-livre-1,1,120)
                      c-un-emit-xml:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(ext-item-doc-est.cod-livre-2,1,6).
      END.
  END.

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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    ENABLE i-seq-xml
           c-desc-xml
           c-un-emit-xml WITH FRAME {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT VALID-HANDLE(h-boin01017) THEN
      RUN inbo/boin01017.p PERSISTENT SET h-boin01017.          
  RUN openQueryStatic IN h-boin01017 (INPUT "Main":U) NO-ERROR. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-ordem-cc V-table-Win 
PROCEDURE pi-atualiza-ordem-cc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-numero-ordem  like it-doc-fisico.numero-ordem  no-undo.
 
    find ordem-compra where 
        ordem-compra.numero-ordem = i-numero-ordem 
        no-lock no-error.
 
    if avail ordem-compra then 
        assign it-doc-fisico.narrativa:screen-value in frame {&frame-name} = ordem-compra.narrativa.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "it-doc-fisico"}

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


