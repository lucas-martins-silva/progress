&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V07IN223 2.00.00.004}  /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v07in223 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

def new global shared var gr-docum as rowid no-undo.

/* Local Variable Definitions ---                                       */
def new global shared var de-quantidade as decimal.
def new global shared var c-un as char.
def new global shared var de-aux-1 as decimal.
def new global shared var de-aux-2 as decimal.
def new global shared var gr-item as rowid no-undo.

def var l-primeira-vez as logical initial yes.

def var de-valor as decimal no-undo.
def var de-vl-mat-env as decimal no-undo.

def var d-valor-mat-m-1 as decimal no-undo.
def var d-valor-mat-m-2 as decimal no-undo.
def var d-valor-mat-m-3 as decimal no-undo.
def var d-valor-mob-m-1 as decimal no-undo.
def var d-valor-mob-m-2 as decimal no-undo.
def var d-valor-mob-m-3 as decimal no-undo.
def var d-valor-ggf-m-1 as decimal no-undo.
def var d-valor-ggf-m-2 as decimal no-undo.
def var d-valor-ggf-m-3 as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-pend
&Scoped-define FIRST-EXTERNAL-TABLE movto-pend


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-pend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-pend.quantidade movto-pend.un 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS rt-mold de-valor-mat-m-1 de-valor-mob-m-1 ~
de-valor-ggf-m-1 
&Scoped-Define DISPLAYED-FIELDS movto-pend.quantidade movto-pend.un 
&Scoped-Define DISPLAYED-OBJECTS de-valor-mat-m-1 de-valor-mat-m-2 ~
de-valor-mat-m-3 de-valor-mob-m-1 de-valor-mob-m-2 de-valor-mob-m-3 ~
de-valor-ggf-m-1 de-valor-ggf-m-2 de-valor-ggf-m-3 

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
DEFINE VARIABLE de-valor-ggf-m-1 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-ggf-m-2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-ggf-m-3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mat-m-1 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mat-m-2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mat-m-3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mob-m-1 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mob-m-2 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE VARIABLE de-valor-mob-m-3 AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R20 
     VIEW-AS FILL-IN 
     SIZE 20.57 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 12.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-pend.quantidade AT ROW 1.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     movto-pend.un AT ROW 2.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     de-valor-mat-m-1 AT ROW 3.75 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-mat-m-2 AT ROW 4.75 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-mat-m-3 AT ROW 5.75 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-mob-m-1 AT ROW 7 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-mob-m-2 AT ROW 8 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-mob-m-3 AT ROW 9 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-ggf-m-1 AT ROW 10.25 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-ggf-m-2 AT ROW 11.25 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     de-valor-ggf-m-3 AT ROW 12.25 COL 43 COLON-ALIGNED HELP
          "Valor Material Mensal"
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-pend
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
         HEIGHT             = 12.79
         WIDTH              = 85.
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

/* SETTINGS FOR FILL-IN de-valor-ggf-m-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-ggf-m-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mat-m-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mat-m-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mob-m-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-mob-m-3 IN FRAME f-main
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




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME de-valor-ggf-m-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-ggf-m-1 V-table-Win
ON LEAVE OF de-valor-ggf-m-1 IN FRAME f-main
DO:
  
    assign d-valor-ggf-m-1 = input frame {&frame-name} de-valor-ggf-m-1.
  
    if input frame {&frame-name} de-valor-ggf-m-1 <> 0 then do:  
        if param-estoq.tem-moeda1 then do:
            run cdp/cd0813.p (input 0, 
                              input 1, 
                              input frame {&frame-name} de-valor-ggf-m-1,
                              input docum-est.dt-trans,
                              output de-valor).
            display de-valor @ de-valor-ggf-m-2 with frame {&frame-name}.                              
            enable de-valor-ggf-m-2 with frame {&frame-name}.
        end.
        if param-estoq.tem-moeda2 then do:
            run cdp/cd0813.p (input 0, 
                              input 2, 
                              input frame {&frame-name} de-valor-ggf-m-1,
                              input docum-est.dt-trans,
                              output de-valor).
            display de-valor @ de-valor-ggf-m-3 with frame {&frame-name}.                              
            enable de-valor-ggf-m-3 with frame {&frame-name}.
        end.            
    end.        
    if de-valor-ggf-m-2:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to de-valor-ggf-m-2 in frame {&frame-name}.
        return no-apply.
    end.
    if de-valor-ggf-m-3:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to de-valor-ggf-m-3 in frame {&frame-name}.
        return no-apply.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-ggf-m-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-ggf-m-2 V-table-Win
ON LEAVE OF de-valor-ggf-m-2 IN FRAME f-main
DO:

    assign d-valor-ggf-m-2 = input frame {&frame-name} de-valor-ggf-m-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-ggf-m-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-ggf-m-3 V-table-Win
ON LEAVE OF de-valor-ggf-m-3 IN FRAME f-main
DO:
  
    assign d-valor-ggf-m-3 = input frame {&frame-name} de-valor-ggf-m-3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mat-m-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mat-m-1 V-table-Win
ON F5 OF de-valor-mat-m-1 IN FRAME f-main
DO:

    run rep/re9016.w (input gr-docum, output de-vl-mat-env).  

    if de-vl-mat-env <> ? and de-vl-mat-env <> 0 then 
        display de-vl-mat-env @ de-valor-mat-m-1 with frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mat-m-1 V-table-Win
ON LEAVE OF de-valor-mat-m-1 IN FRAME f-main
DO:
  
    assign d-valor-mat-m-1 = input frame {&frame-name} de-valor-mat-m-1.
  
    if input frame {&frame-name} de-valor-mat-m-1 <> 0 then do:  
        if param-estoq.tem-moeda1 then do:
            run cdp/cd0813.p (input 0, 
                              input 1, 
                              input frame {&frame-name} de-valor-mat-m-1,
                              input docum-est.dt-trans,
                              output de-valor).
            display de-valor @ de-valor-mat-m-2 with frame {&frame-name}.                              
            enable de-valor-mat-m-2 with frame {&frame-name}.
        end.
        if param-estoq.tem-moeda2 then do:
            run cdp/cd0813.p (input 0, 
                              input 2, 
                              input frame {&frame-name} de-valor-mat-m-1,
                              input docum-est.dt-trans,
                              output de-valor).
            display de-valor @ de-valor-mat-m-3 with frame {&frame-name}.                              
            enable de-valor-mat-m-3 with frame {&frame-name}.
        end.            
    end.        
    if de-valor-mat-m-2:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to de-valor-mat-m-2 in frame {&frame-name}.
        return no-apply.
    end.
    if de-valor-mat-m-3:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to de-valor-mat-m-3 in frame {&frame-name}.
        return no-apply.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mat-m-1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF de-valor-mat-m-1 IN FRAME f-main
DO:
        apply "F5" to self.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mat-m-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mat-m-2 V-table-Win
ON LEAVE OF de-valor-mat-m-2 IN FRAME f-main
DO:
  
    assign d-valor-mat-m-2 = input frame {&frame-name} de-valor-mat-m-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mat-m-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mat-m-3 V-table-Win
ON LEAVE OF de-valor-mat-m-3 IN FRAME f-main
DO:

    assign d-valor-mat-m-3 = input frame {&frame-name} de-valor-mat-m-3.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mob-m-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mob-m-1 V-table-Win
ON LEAVE OF de-valor-mob-m-1 IN FRAME f-main
DO:
  
    assign d-valor-mob-m-1 = input frame {&frame-name} de-valor-mob-m-1.
  
    if input frame {&frame-name} de-valor-mob-m-1 <> 0 then do:  
        if param-estoq.tem-moeda1 then do:
            run cdp/cd0813.p (input 0, 
                              input 1, 
                              input frame {&frame-name} de-valor-mob-m-1,
                              input docum-est.dt-trans,
                              output de-valor).
            display de-valor @ de-valor-mob-m-2 with frame {&frame-name}.                              
            enable de-valor-mob-m-2 with frame {&frame-name}.
        end.
        if param-estoq.tem-moeda2 then do:
            run cdp/cd0813.p (input 0, 
                              input 2, 
                              input frame {&frame-name} de-valor-mob-m-1,
                              input docum-est.dt-trans,
                              output de-valor).
            display de-valor @ de-valor-mob-m-3 with frame {&frame-name}.                              
            enable de-valor-mob-m-3 with frame {&frame-name}.
        end.            
    end.        
    if de-valor-mob-m-2:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to de-valor-mob-m-2 in frame {&frame-name}.
        return no-apply.
    end.
    if de-valor-mob-m-3:sensitive in frame {&frame-name} = yes then do:
        apply "entry" to de-valor-mob-m-3 in frame {&frame-name}.
        return no-apply.
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mob-m-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mob-m-2 V-table-Win
ON LEAVE OF de-valor-mob-m-2 IN FRAME f-main
DO:

    assign d-valor-mob-m-2 = input frame {&frame-name} de-valor-mob-m-2.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-valor-mob-m-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-valor-mob-m-3 V-table-Win
ON LEAVE OF de-valor-mob-m-3 IN FRAME f-main
DO:

    assign d-valor-mob-m-3 = input frame {&frame-name} de-valor-mob-m-3.
  
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

    if de-valor-mat-m-1:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "movto-pend"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-pend"}

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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

    if estab-mat.custo-contab = 1 then do:
        assign movto-pend.valor-mat-m[1] = d-valor-mat-m-1
               movto-pend.valor-mat-m[2] = d-valor-mat-m-2
               movto-pend.valor-mat-m[3] = d-valor-mat-m-3
               movto-pend.valor-mob-m[1] = d-valor-mob-m-1
               movto-pend.valor-mob-m[2] = d-valor-mob-m-2
               movto-pend.valor-mob-m[3] = d-valor-mob-m-3
               movto-pend.valor-ggf-m[1] = d-valor-ggf-m-1
               movto-pend.valor-ggf-m[2] = d-valor-ggf-m-2
               movto-pend.valor-ggf-m[3] = d-valor-ggf-m-3.
    end.
    if estab-mat.custo-contab = 2 then do:
        assign movto-pend.valor-mat-o[1] = d-valor-mat-m-1
               movto-pend.valor-mat-o[2] = d-valor-mat-m-2
               movto-pend.valor-mat-o[3] = d-valor-mat-m-3
               movto-pend.valor-mob-o[1] = d-valor-mob-m-1
               movto-pend.valor-mob-o[2] = d-valor-mob-m-2
               movto-pend.valor-mob-o[3] = d-valor-mob-m-3
               movto-pend.valor-ggf-o[1] = d-valor-ggf-m-1
               movto-pend.valor-ggf-o[2] = d-valor-ggf-m-2
               movto-pend.valor-ggf-o[3] = d-valor-ggf-m-3.
    end.

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

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

    find first param-estoq
        no-lock no-error.

    find item where 
        rowid(item) = gr-item
        no-lock no-error.

    if l-primeira-vez = yes then do:
        display de-quantidade @ movto-pend.quantidade with frame {&frame-name}.
        display c-un @ movto-pend.un with frame {&frame-name}.
        assign l-primeira-vez = no.
    end.
    
    find docum-est where
        rowid(docum-est) = gr-docum
        no-lock no-error.
        
    find estab-mat where 
        estab-mat.cod-estabel = docum-est.cod-estabel
        no-lock no-error.

    {utp/ut-liter.i Valor_do_material * R}
    assign de-valor-mat-m-1:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Valor_do_material_moeda_1 * R}
    assign de-valor-mat-m-2:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Valor_do_material_moeda_2 * R}
    assign de-valor-mat-m-3:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Valor_do_mobilizado * R}
    assign de-valor-mob-m-1:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Valor_do_mobilizado_moeda_1 * R}
    assign de-valor-mob-m-2:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Valor_do_mobilizado_moeda_2 * R}
    assign de-valor-mob-m-3:label in frame {&frame-name} = trim(return-value).

    {utp/ut-liter.i Valor_do_ggf * R}
    assign de-valor-ggf-m-1:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Valor_do_ggf_moeda_1 * R}
    assign de-valor-ggf-m-2:label in frame {&frame-name} = trim(return-value).
    
    {utp/ut-liter.i Valor_do_ggf_moeda_2 * R}
    assign de-valor-ggf-m-3:label in frame {&frame-name} = trim(return-value).

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

    if input frame {&frame-name} movto-pend.quantidade > de-aux-1 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 6916, input "").
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 6917, input "").
        if return-value = "yes" then do:
            apply "entry" to movto-pend.quantidade in frame {&frame-name}.
            return error.
        end.
    end.
    
    if item.it-codigo <> "" and
        input frame {&frame-name} movto-pend.un <> item.un then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show", input 1571, input "").
        apply "entry" to movto-pend.un in frame {&frame-name}.
        return error.
    end.

 
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
  {src/adm/template/snd-list.i "movto-pend"}

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


