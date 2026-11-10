&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V61IN172 2.00.00.013}  /*** 010013 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V61IN172 MUT}
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

/* Local Variable Definitions ---                                       */
def var l-ok      as logical                  no-undo.
def var c-custo   like estabelec.custo-contab no-undo.
def var c-estabel like estabelec.cod-estabel  no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.data-base item.preco-base ~
item.data-ult-ent item.preco-ul-ent item.data-ult-rep item.preco-repos 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold c-corrente c-moeda1 c-moeda2 
&Scoped-Define DISPLAYED-FIELDS item.data-base item.preco-base ~
item.data-ult-ent item.preco-ul-ent item.data-ult-rep item.preco-repos 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-cod-estabel cb-custo-contab ~
de-val-unit-mat1 de-val-unit-mat2 de-val-unit-mat3 de-val-unit-mob1 ~
de-val-unit-mob2 de-val-unit-mob3 de-val-unit-ggf1 de-val-unit-ggf2 ~
de-val-unit-ggf3 de-prc-medio1 de-prc-medio2 de-prc-medio3 c-corrente ~
c-moeda1 c-moeda2 

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
DEFINE VARIABLE cb-custo-contab AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-corrente AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-prc-medio1 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE de-prc-medio2 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE de-prc-medio3 AS DECIMAL FORMAT "->>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE de-val-unit-ggf1 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-ggf2 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-ggf3 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-mat1 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-mat2 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-mat3 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-mob1 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-mob2 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-unit-mob3 AS DECIMAL FORMAT "->>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.data-base AT ROW 1.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.preco-base AT ROW 1.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     item.data-ult-ent AT ROW 2.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.preco-ul-ent AT ROW 2.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     item.data-ult-rep AT ROW 3.17 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.preco-repos AT ROW 3.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     c-cod-estabel AT ROW 4.17 COL 24 COLON-ALIGNED
     cb-custo-contab AT ROW 4.17 COL 61 COLON-ALIGNED
     de-val-unit-mat1 AT ROW 6.33 COL 25.29 COLON-ALIGNED
     de-val-unit-mat2 AT ROW 6.33 COL 45.29 COLON-ALIGNED NO-LABEL
     de-val-unit-mat3 AT ROW 6.33 COL 65.29 COLON-ALIGNED NO-LABEL
     de-val-unit-mob1 AT ROW 7.33 COL 25.29 COLON-ALIGNED
     de-val-unit-mob2 AT ROW 7.33 COL 45.29 COLON-ALIGNED NO-LABEL
     de-val-unit-mob3 AT ROW 7.33 COL 65.29 COLON-ALIGNED NO-LABEL
     de-val-unit-ggf1 AT ROW 8.33 COL 25.29 COLON-ALIGNED
     de-val-unit-ggf2 AT ROW 8.33 COL 45.29 COLON-ALIGNED NO-LABEL
     de-val-unit-ggf3 AT ROW 8.33 COL 65.29 COLON-ALIGNED NO-LABEL
     de-prc-medio1 AT ROW 9.33 COL 25.29 COLON-ALIGNED
     de-prc-medio2 AT ROW 9.33 COL 45.29 COLON-ALIGNED NO-LABEL
     de-prc-medio3 AT ROW 9.33 COL 65.29 COLON-ALIGNED NO-LABEL
     c-corrente AT ROW 5.5 COL 25.86 COLON-ALIGNED NO-LABEL
     c-moeda1 AT ROW 5.5 COL 45.29 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 5.5 COL 65.29 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.5
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME f-main
   NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-SIZE                */
/* SETTINGS FOR COMBO-BOX cb-custo-contab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-prc-medio1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-prc-medio2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-prc-medio3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-ggf1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-ggf2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-ggf3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-mat1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-mat2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-mat3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-mob1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-mob2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-unit-mob3 IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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

    /* Code placed here will execute AFTER standard behavior.    */
    assign de-prc-medio1    = 0
           de-prc-medio2    = 0
           de-prc-medio3    = 0
           de-val-unit-mat1 = 0
           de-val-unit-mat2 = 0
           de-val-unit-mat3 = 0
           de-val-unit-mob1 = 0
           de-val-unit-mob2 = 0
           de-val-unit-mob3 = 0
           de-val-unit-ggf1 = 0
           de-val-unit-ggf2 = 0
           de-val-unit-ggf3 = 0.

    if  l-ok = no then do:
        assign c-cod-estabel:screen-value in frame {&frame-name} = item.cod-estabel.
        find estabelec
            where estabelec.cod-estabel = item.cod-estabel no-lock no-error.
        if  avail estabelec then
            assign cb-custo-contab:screen-value in frame {&frame-name} =
                                   {adinc/i01ad107.i 04 estabelec.custo-contab}.
    end.
    else
        assign c-cod-estabel:screen-value   in frame {&frame-name} = c-estabel
               cb-custo-contab:screen-value in frame {&frame-name} = {adinc/i01ad107.i 04 c-custo}
               l-ok = no.

    find first item-estab
        where item-estab.it-codigo   = item.it-codigo
        and   item-estab.cod-estabel = item.cod-estabel no-lock no-error.
    if  avail item-estab then do:
        if  c-custo = 1 then
            assign de-prc-medio1    = item-estab.val-unit-mat-m[1]
                                    + item-estab.val-unit-mob-m[1]
                                    + item-estab.val-unit-ggf-m[1]
                   de-prc-medio2    = item-estab.val-unit-mat-m[2]
                                    + item-estab.val-unit-mob-m[2]
                                    + item-estab.val-unit-ggf-m[2]
                   de-prc-medio3    = item-estab.val-unit-mat-m[3]
                                    + item-estab.val-unit-mob-m[3]
                                    + item-estab.val-unit-ggf-m[3]
                   de-val-unit-mat1 = item-estab.val-unit-mat-m[1] 
                   de-val-unit-mat2 = item-estab.val-unit-mat-m[2]
                   de-val-unit-mat3 = item-estab.val-unit-mat-m[3]
                   de-val-unit-mob1 = item-estab.val-unit-mob-m[1]
                   de-val-unit-mob2 = item-estab.val-unit-mob-m[2]
                   de-val-unit-mob3 = item-estab.val-unit-mob-m[3]
                   de-val-unit-ggf1 = item-estab.val-unit-ggf-m[1]
                   de-val-unit-ggf2 = item-estab.val-unit-ggf-m[2]
                   de-val-unit-ggf3 = item-estab.val-unit-ggf-m[3].
        else
        if  c-custo = 2 then
            assign de-prc-medio1    = item-estab.val-unit-mat-o[1]
                                    + item-estab.val-unit-mob-o[1]
                                    + item-estab.val-unit-ggf-o[1]
                   de-prc-medio2    = item-estab.val-unit-mat-o[2]
                                    + item-estab.val-unit-mob-o[2]
                                    + item-estab.val-unit-ggf-o[2]
                   de-prc-medio3    = item-estab.val-unit-mat-o[3]
                                    + item-estab.val-unit-mob-o[3]
                                    + item-estab.val-unit-ggf-o[3]
                   de-val-unit-mat1 = item-estab.val-unit-mat-o[1]
                   de-val-unit-mat2 = item-estab.val-unit-mat-o[2]
                   de-val-unit-mat3 = item-estab.val-unit-mat-o[3]
                   de-val-unit-mob1 = item-estab.val-unit-mob-o[1]
                   de-val-unit-mob2 = item-estab.val-unit-mob-o[2]
                   de-val-unit-mob3 = item-estab.val-unit-mob-o[3]
                   de-val-unit-ggf1 = item-estab.val-unit-ggf-o[1]
                   de-val-unit-ggf2 = item-estab.val-unit-ggf-o[2]
                   de-val-unit-ggf3 = item-estab.val-unit-ggf-o[3].
        else
        if  c-custo = 3 then
            assign de-prc-medio1    = item-estab.val-unit-mat-p[1]
                                    + item-estab.val-unit-mob-p[1]
                                    + item-estab.val-unit-ggf-p[1]
                   de-prc-medio2    = item-estab.val-unit-mat-p[2]
                                    + item-estab.val-unit-mob-p[2]
                                    + item-estab.val-unit-ggf-p[2]
                   de-prc-medio3    = item-estab.val-unit-mat-p[3]
                                    + item-estab.val-unit-mob-p[3]
                                    + item-estab.val-unit-ggf-p[3]
                   de-val-unit-mat1 = item-estab.val-unit-mat-p[1]
                   de-val-unit-mat2 = item-estab.val-unit-mat-p[2]
                   de-val-unit-mat3 = item-estab.val-unit-mat-p[3]
                   de-val-unit-mob1 = item-estab.val-unit-mob-p[1]
                   de-val-unit-mob2 = item-estab.val-unit-mob-p[2]
                   de-val-unit-mob3 = item-estab.val-unit-mob-p[3]
                   de-val-unit-ggf1 = item-estab.val-unit-ggf-p[1]
                   de-val-unit-ggf2 = item-estab.val-unit-ggf-p[2]
                   de-val-unit-ggf3 = item-estab.val-unit-ggf-p[3].
    end.
    else
        assign de-prc-medio1    = 0
               de-prc-medio2    = 0
               de-prc-medio3    = 0
               de-val-unit-mat1 = 0
               de-val-unit-mat2 = 0
               de-val-unit-mat3 = 0
               de-val-unit-mob1 = 0
               de-val-unit-mob2 = 0
               de-val-unit-mob3 = 0
               de-val-unit-ggf1 = 0
               de-val-unit-ggf2 = 0
               de-val-unit-ggf3 = 0.

    disp de-val-unit-mat1
         de-val-unit-mat2
         de-val-unit-mat3
         de-val-unit-mob1
         de-val-unit-mob2
         de-val-unit-mob3
         de-val-unit-ggf1
         de-val-unit-ggf2
         de-val-unit-ggf3
         de-prc-medio1 
         de-prc-medio2 
         de-prc-medio3 with frame {&frame-name}.

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
  {utp/ut-liter.i Corrente * L}
  assign c-corrente = return-value.
  {utp/ut-liter.i Pre‡o_Item * r}
  assign cb-custo-contab:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Valor_Unit_Material * L}
  assign de-val-unit-mat1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Valor_Unit_MÆo_Obra * L}
  assign de-val-unit-mob1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Valor_Unit_GGF * L}
  assign de-val-unit-ggf1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Valor_Total * L}
  assign de-prc-medio1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Estab * L}
  assign c-cod-estabel:label in frame {&FRAME-NAME} = return-value.

  find first param-global no-lock no-error.
  find first param-estoq  no-lock no-error.

  if  param-estoq.tem-moeda1 then do:
      find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
      if  avail moeda then assign c-moeda1 = moeda.descricao. 
  end.
  if  param-estoq.tem-moeda2 then do:
      find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
      if  avail moeda then assign c-moeda2 = moeda.descricao.
  end.

  do  with frame {&frame-name}:
      assign cb-custo-contab:list-items = {adinc/i01ad107.i 03}
             l-ok = no.
  end.

  disp de-val-unit-mat1
       de-val-unit-mob1
       de-val-unit-ggf1
       de-prc-medio1
       c-corrente with frame {&frame-name}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-preco V-table-Win 
PROCEDURE pi-atualiza-preco :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input        parameter p-rw-item as rowid                    no-undo.
    def input-output parameter p-estabel like estabelec.cod-estabel  no-undo.
    def input-output parameter p-custo   like estabelec.custo-contab no-undo.

    assign c-estabel = p-estabel
           c-custo   = p-custo
           l-ok      = yes
           c-cod-estabel:screen-value in frame {&frame-name} = c-estabel.
    cb-custo-contab:entry(c-custo).

    run local-display-fields.

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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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

