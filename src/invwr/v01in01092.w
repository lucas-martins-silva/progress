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
{include/i-prgvrs.i V01IN01092 2.00.00.008} /* 15/04/2026 10:32:55 */

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN01092 MUT}
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
DEFINE VARIABLE v-row-parent AS ROWID       NO-UNDO.
DEFINE VARIABLE i-cod-domin  AS INTEGER     NO-UNDO.

DEFINE BUFFER b-classif-atrib FOR classif-atrib.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES classif-atrib
&Scoped-define FIRST-EXTERNAL-TABLE classif-atrib


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR classif-atrib.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS classif-atrib.des-atributo ~
classif-atrib.idi-forma-preench classif-atrib.num-valor ~
classif-atrib.val-valor classif-atrib.cod-valor classif-atrib.log-valor ~
classif-atrib.dat-vigenc-fim 
&Scoped-define ENABLED-TABLES classif-atrib
&Scoped-define FIRST-ENABLED-TABLE classif-atrib
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS classif-atrib.ind-modal ~
classif-atrib.cod-atributo classif-atrib.des-atributo ~
classif-atrib.idi-forma-preench classif-atrib.log-multivalorado ~
classif-atrib.num-valor classif-atrib.log-obrigatorio ~
classif-atrib.val-valor classif-atrib.log-condicionado ~
classif-atrib.cod-valor classif-atrib.dat-vigenc-ini ~
classif-atrib.log-valor classif-atrib.dat-vigenc-fim 
&Scoped-define DISPLAYED-TABLES classif-atrib
&Scoped-define FIRST-DISPLAYED-TABLE classif-atrib


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS classif-atrib.ind-modal ~
classif-atrib.cod-atributo classif-atrib.log-multivalorado ~
classif-atrib.log-obrigatorio classif-atrib.log-condicionado ~
classif-atrib.dat-vigenc-ini classif-atrib.dat-vigenc-fim 
&Scoped-define ADM-ASSIGN-FIELDS classif-atrib.ind-modal ~
classif-atrib.cod-atributo classif-atrib.log-multivalorado ~
classif-atrib.log-obrigatorio classif-atrib.log-condicionado ~
classif-atrib.dat-vigenc-ini classif-atrib.dat-vigenc-fim 
&Scoped-define ADM-MODIFY-FIELDS classif-atrib.dat-vigenc-fim 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
class-fiscal||y|mgind.classif-atrib.cod-class-fisc
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "cod-class-fisc"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 6.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89 BY 9.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     classif-atrib.ind-modal AT ROW 1.17 COL 21 NO-LABEL WIDGET-ID 12
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Exportaá∆o", 1,
"Importaá∆o", 2
          SIZE 41 BY 1
     classif-atrib.cod-atributo AT ROW 2.17 COL 19 COLON-ALIGNED WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 21 BY .88
     classif-atrib.des-atributo AT ROW 3.17 COL 19 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 62 BY .88
     classif-atrib.idi-forma-preench AT ROW 5.13 COL 19 COLON-ALIGNED WIDGET-ID 22
          VIEW-AS COMBO-BOX INNER-LINES 5
          LIST-ITEM-PAIRS "Lista Est†tica",1,
                     "N£mero Inteiro",2,
                     "N£mero Real",3,
                     "Texto",4,
                     "Booleano",5
          DROP-DOWN-LIST
          SIZE 16 BY 1
     classif-atrib.log-multivalorado AT ROW 5.13 COL 69 NO-LABEL WIDGET-ID 56
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", yes,
"N∆o", no
          SIZE 17 BY 1
     classif-atrib.num-valor AT ROW 6.13 COL 19 COLON-ALIGNED WIDGET-ID 24
          LABEL "Valor N£mero Inteiro"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     classif-atrib.log-obrigatorio AT ROW 6.13 COL 69 NO-LABEL WIDGET-ID 44
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", yes,
"N∆o", no
          SIZE 17 BY 1
     classif-atrib.val-valor AT ROW 7.13 COL 19 COLON-ALIGNED WIDGET-ID 26
          LABEL "Valor N£mero Real"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     classif-atrib.log-condicionado AT ROW 7.13 COL 69 NO-LABEL WIDGET-ID 62
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", yes,
"N∆o", no
          SIZE 17 BY 1
     classif-atrib.cod-valor AT ROW 8.13 COL 19 COLON-ALIGNED WIDGET-ID 28
          LABEL "Valor Texto"
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     classif-atrib.dat-vigenc-ini AT ROW 8.13 COL 67 COLON-ALIGNED WIDGET-ID 50
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     classif-atrib.log-valor AT ROW 9.13 COL 23 NO-LABEL WIDGET-ID 30
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Sim", yes,
"N∆o", no
          SIZE 14 BY 1
     classif-atrib.dat-vigenc-fim AT ROW 9.13 COL 67 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 13.86 BY .88
     "Condicionado:" VIEW-AS TEXT
          SIZE 10 BY .75 AT ROW 7.21 COL 58.86 WIDGET-ID 66
     "Multivalorado:" VIEW-AS TEXT
          SIZE 10 BY 1 AT ROW 5.13 COL 59 WIDGET-ID 42
     "Valor L¢gico:" VIEW-AS TEXT
          SIZE 9 BY .79 AT ROW 9.13 COL 12 WIDGET-ID 34
     "Obrigat¢rio:" VIEW-AS TEXT
          SIZE 8 BY 1 AT ROW 6.13 COL 60.43 WIDGET-ID 48
     rt-mold AT ROW 1 COL 1
     RECT-1 AT ROW 4.46 COL 2 WIDGET-ID 54
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.classif-atrib
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 9.83
         WIDTH              = 89.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN classif-atrib.cod-atributo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN classif-atrib.cod-valor IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN classif-atrib.dat-vigenc-fim IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN classif-atrib.dat-vigenc-ini IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR RADIO-SET classif-atrib.ind-modal IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR RADIO-SET classif-atrib.log-condicionado IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR RADIO-SET classif-atrib.log-multivalorado IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR RADIO-SET classif-atrib.log-obrigatorio IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN classif-atrib.num-valor IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN classif-atrib.val-valor IN FRAME f-main
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

&Scoped-define SELF-NAME classif-atrib.idi-forma-preench
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL classif-atrib.idi-forma-preench V-table-Win
ON VALUE-CHANGED OF classif-atrib.idi-forma-preench IN FRAME f-main /* Forma Preenchimento */
DO:
  CASE input frame {&frame-name} classif-atrib.idi-forma-preench :
                WHEN 1 THEN DO: /* Lista Est†tica */
                    classif-atrib.num-valor:SENSITIVE = FALSE.
                    classif-atrib.val-valor:SENSITIVE = FALSE.
                    classif-atrib.cod-valor:SENSITIVE = FALSE.
                    classif-atrib.log-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.num-valor:SENSITIVE THEN classif-atrib.num-valor:screen-value = "0".
                    IF NOT classif-atrib.val-valor:SENSITIVE THEN classif-atrib.val-valor:screen-value = "0".
                    IF NOT classif-atrib.cod-valor:SENSITIVE THEN classif-atrib.cod-valor:screen-value = "".
                    IF NOT classif-atrib.log-valor:SENSITIVE THEN classif-atrib.log-valor:screen-value = "NO".
 
                END.

                WHEN 2 THEN DO: /* N£mero Inteiro */
                    classif-atrib.num-valor:SENSITIVE = TRUE.
                    
                    classif-atrib.val-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.val-valor:SENSITIVE THEN classif-atrib.val-valor:screen-value = "0".
                    
                    classif-atrib.cod-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.cod-valor:SENSITIVE THEN classif-atrib.cod-valor:screen-value = "".
                    
                    classif-atrib.log-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.log-valor:SENSITIVE THEN classif-atrib.log-valor:screen-value = "NO".

                END.

                WHEN 3 THEN DO: /* N£mero Real */
                    classif-atrib.num-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.num-valor:SENSITIVE THEN classif-atrib.num-valor:screen-value = "0".
                    
                    classif-atrib.val-valor:SENSITIVE = TRUE.
                    
                    classif-atrib.cod-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.cod-valor:SENSITIVE THEN classif-atrib.cod-valor:screen-value = "".
                    
                    classif-atrib.log-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.log-valor:SENSITIVE THEN classif-atrib.log-valor:screen-value = "NO".

                END.

                WHEN 4 THEN DO: /* Texto */
                    classif-atrib.num-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.num-valor:SENSITIVE THEN classif-atrib.num-valor:screen-value = "0".
                    
                    classif-atrib.val-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.val-valor:SENSITIVE THEN classif-atrib.val-valor:screen-value = "0".
                    
                    classif-atrib.cod-valor:SENSITIVE = TRUE.
                    
                    classif-atrib.log-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.log-valor:SENSITIVE THEN classif-atrib.log-valor:screen-value = "NO".

                END.

                WHEN 5 THEN DO: /* Booleano */
                    classif-atrib.num-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.num-valor:SENSITIVE THEN classif-atrib.num-valor:screen-value = "0".
                    
                    classif-atrib.val-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.val-valor:SENSITIVE THEN classif-atrib.val-valor:screen-value = "0".
                    
                    classif-atrib.cod-valor:SENSITIVE = FALSE.
                    IF NOT classif-atrib.cod-valor:SENSITIVE THEN classif-atrib.cod-valor:screen-value = "".
                    
                    classif-atrib.log-valor:SENSITIVE = TRUE.
                    
                END.

                OTHERWISE DO:
                    classif-atrib.num-valor:SENSITIVE = false.
                    classif-atrib.val-valor:SENSITIVE = false.
                    classif-atrib.cod-valor:SENSITIVE = false.
                    classif-atrib.log-valor:SENSITIVE = false.
                    
                END.
            END CASE.   
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "classif-atrib"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "classif-atrib"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
        
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
       
  DO WITH FRAME {&frame-name} :
     APPLY "value-changed":U TO classif-atrib.idi-forma-preench IN FRAME {&frame-name}.
  end.
        
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
        
    IF  adm-new-record THEN DO:

        /* C¢digo do Atributo deve ser obrigat¢rio */
        IF  INPUT FRAME {&FRAME-NAME} classif-atrib.cod-atributo = "" THEN DO:
            {utp/ut-field.i mgind classif-atrib cod-atributo 1}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 5793, INPUT return-value).
            APPLY "entry":U TO classif-atrib.cod-atributo IN FRAME {&FRAME-NAME}.
            RETURN "ADM-ERROR":U.
        END.

        /* Valida se o registro j† foi informado para esta classificaá∆o fiscal */
        FIND FIRST classif-fisc NO-LOCK
            WHERE  ROWID(classif-fisc) = v-row-parent NO-ERROR.
        IF  AVAIL  classif-fisc THEN DO:
            IF  CAN-FIND (FIRST b-classif-atrib NO-LOCK 
                          WHERE b-classif-atrib.cod-class-fisc = classif-fisc.class-fiscal
                          AND   b-classif-atrib.cod-atributo   = INPUT FRAME {&FRAME-NAME} classif-atrib.cod-atributo
                          AND   b-classif-atrib.cod-domin      = ""
                          AND   b-classif-atrib.ind-modal      = INPUT FRAME {&FRAME-NAME} classif-atrib.ind-modal) THEN DO:
                {utp/ut-table.i mgind classif-atrib 1}
                RUN utp/ut-msgs.p (INPUT "show":U, INPUT 1, INPUT RETURN-VALUE).
                APPLY "entry":U TO classif-atrib.cod-atributo IN FRAME {&FRAME-NAME}.
                RETURN "ADM-ERROR":U.
            END.
        END.

    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */    

    RETURN "OK":U.
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

  IF  NOT AVAIL classif-fisc OR ROWID(classif-fisc) <> v-row-parent THEN
      FIND FIRST classif-fisc NO-LOCK WHERE ROWID(classif-fisc) = v-row-parent NO-ERROR.

  IF  AVAIL  classif-fisc THEN
      ASSIGN classif-atrib.cod-class-fisc = classif-fisc.class-fiscal.

  /* Code placed here will execute AFTER standard behavior.    */

  RETURN "OK":U.
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

  /* Code placed here will execute AFTER standard behavior.    */

  RETURN "OK":U.
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
    DO WITH FRAME {&frame-name} :
       APPLY "value-changed":U TO classif-atrib.idi-forma-preench IN FRAME {&frame-name}.
    end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "class-fiscal" "classif-atrib" "cod-class-fisc"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "classif-atrib"}

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

