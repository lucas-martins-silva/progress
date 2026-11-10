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
{include/i-prgvrs.i V03IN172 2.00.01.005 } /*** 010105 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v03in172 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent    as rowid   no-undo.
def var i-politica      as integer no-undo.
def var c-handle        as char    no-undo.
def var i-ind-lista-mrp as int     no-undo.
def var h-handle        as handle  no-undo.

{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.res-int-comp 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-22 RECT-32 RECT-31 
&Scoped-Define DISPLAYED-FIELDS item.res-int-comp item.res-for-comp ~
item.res-cq-comp item.ressup-fabri item.res-cq-fabri item.horiz-fixo 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS cb-classe-repro cb-emissao-ord ~
cb-contr-plan cb-div-ordem cb-ind-lista-mrp l-demanda-item ~
fi-qtd-min-ressup fi-dias-dlt-ressup fi-qtd-dlt-ressup i-horiz-lib 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-classe-repro cb-emissao-ord ~
cb-contr-plan cb-div-ordem cb-ind-lista-mrp l-demanda-item ~
item.res-int-comp item.res-for-comp item.res-cq-comp item.ressup-fabri ~
item.res-cq-fabri fi-qtd-min-ressup fi-dias-dlt-ressup fi-qtd-dlt-ressup ~
i-horiz-lib item.horiz-fixo 
&Scoped-define ADM-MODIFY-FIELDS cb-classe-repro cb-emissao-ord ~
cb-contr-plan cb-div-ordem l-demanda-item item.res-int-comp ~
item.res-for-comp item.res-cq-comp item.ressup-fabri item.res-cq-fabri ~
fi-qtd-min-ressup fi-dias-dlt-ressup fi-qtd-dlt-ressup i-horiz-lib ~
item.horiz-fixo 

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
DEFINE VARIABLE cb-classe-repro AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 18.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-contr-plan AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 18.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-div-ordem AS CHARACTER FORMAT "X(40)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 18.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-emissao-ord AS CHARACTER FORMAT "X(30)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 18.43 BY 1 NO-UNDO.

DEFINE VARIABLE cb-ind-lista-mrp AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 18.43 BY 1 NO-UNDO.

DEFINE VARIABLE fi-dias-dlt-ressup AS INTEGER FORMAT ">>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5.29 BY .88.

DEFINE VARIABLE fi-qtd-dlt-ressup AS DECIMAL FORMAT ">>>>>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qtd-min-ressup AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-horiz-lib AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.72 BY 7.79.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46 BY 2.92.

DEFINE RECTANGLE RECT-32
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.14 BY 4.75.

DEFINE VARIABLE l-demanda-item AS LOGICAL INITIAL no 
     LABEL "Represa Demanda" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.72 BY .83 TOOLTIP "Represa Demanda" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-classe-repro AT ROW 1.38 COL 17.29 COLON-ALIGNED
     cb-emissao-ord AT ROW 2.75 COL 17 COLON-ALIGNED
     cb-contr-plan AT ROW 4 COL 17 COLON-ALIGNED
     cb-div-ordem AT ROW 5.25 COL 17 COLON-ALIGNED
     cb-ind-lista-mrp AT ROW 6.5 COL 17 COLON-ALIGNED
     l-demanda-item AT ROW 7.71 COL 19
     item.res-int-comp AT ROW 1.29 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     item.res-for-comp AT ROW 2.54 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     item.res-cq-comp AT ROW 2.54 COL 78.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     item.ressup-fabri AT ROW 4.33 COL 56.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .88
     item.res-cq-fabri AT ROW 4.29 COL 78 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.29 BY .92
     fi-qtd-min-ressup AT ROW 5.42 COL 56.86 COLON-ALIGNED
     fi-dias-dlt-ressup AT ROW 6.5 COL 56.86 COLON-ALIGNED
     fi-qtd-dlt-ressup AT ROW 6.5 COL 65 COLON-ALIGNED NO-LABEL
     i-horiz-lib AT ROW 7.5 COL 56.86 COLON-ALIGNED
     item.horiz-fixo AT ROW 7.5 COL 65 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     " /" VIEW-AS TEXT
          SIZE 1.57 BY .96 AT ROW 7.5 COL 64.43
     " /" VIEW-AS TEXT
          SIZE 1.57 BY .96 AT ROW 6.5 COL 65
     RECT-22 AT ROW 1 COL 1
     RECT-32 AT ROW 4.08 COL 40
     RECT-31 AT ROW 1 COL 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 7.83
         WIDTH              = 85.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-classe-repro IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-contr-plan IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-div-ordem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-emissao-ord IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-ind-lista-mrp IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       cb-ind-lista-mrp:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-dias-dlt-ressup IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR FILL-IN fi-qtd-dlt-ressup IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR FILL-IN fi-qtd-min-ressup IN FRAME f-main
   NO-ENABLE 2 3 DEF-LABEL                                              */
/* SETTINGS FOR FILL-IN item.horiz-fixo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN i-horiz-lib IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-demanda-item IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.res-cq-comp IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.res-cq-fabri IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.res-for-comp IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN item.res-int-comp IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item.ressup-fabri IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME cb-ind-lista-mrp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ind-lista-mrp V-table-Win
ON VALUE-CHANGED OF cb-ind-lista-mrp IN FRAME f-main
DO:
    run notify ('pi-atualiza,state-source').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  assign cb-emissao-ord:list-items in frame {&frame-name}   = {ininc/i03in122.i 3}
         cb-contr-plan:list-items in frame {&frame-name}    = {ininc/i15in172.i 3}.
         
                 
/************************ INTERNAL PROCEDURES ********************/
  {utp/ut-field.i mgind item classe-repro 1}
  assign cb-classe-repro:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item div-ordem 1}
  assign cb-div-ordem:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item contr-plan 01}
  assign cb-contr-plan:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item emissao-ord 01}
  assign cb-emissao-ord:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Ressupr_min_Fabric * R}
  assign item.ressup-fabri:label = trim(return-value).
  {utp/ut-liter.i Qtd_min_Ressup * R}
  assign fi-qtd-min-ressup:label = trim(return-value).
  {utp/ut-liter.i Var_Tempo_/_Qtd_Ressup * R}
  assign fi-dias-dlt-ressup:label = trim(return-value).
  {utp/ut-liter.i Horizonte_Liber_/_Fixo * R}
  assign i-horiz-lib:label = trim(return-value).
  {utp/ut-liter.i Represa_Demanda * R}
  assign l-demanda-item:label = return-value.

/*  {utp/ut-liter.i Varia‡Æo_qtd_Ressup * R}
  assign fi-qtd-dlt-ressup:label = return-value. */

  &if defined (bf_man_sfc_lc) &then
      {utp/ut-field.i mgind item-man ind-lista-mrp 01}
      assign cb-ind-lista-mrp:label      in frame {&frame-name} = return-value
             cb-ind-lista-mrp:list-items in frame {&frame-name} = {ininc/i03in180.i 3}.
  &endif

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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

  run pi-validate.
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
                   
  ASSIGN fi-qtd-min-ressup  = IF fi-qtd-min-ressup  = ? THEN 0 ELSE fi-qtd-min-ressup
         fi-dias-dlt-ressup = IF fi-dias-dlt-ressup = ? THEN 0 ELSE fi-dias-dlt-ressup
         fi-qtd-dlt-ressup  = IF fi-qtd-dlt-ressup  = ? THEN 0 ELSE fi-qtd-dlt-ressup
         i-horiz-lib        = IF i-horiz-lib        = ? THEN 0 ELSE i-horiz-lib.
                     
  /* Code placed here will execute AFTER standard behavior.    */

  if int(i-horiz-lib) > item.horiz-fixo then do:
        run utp/ut-msgs.p( input "Show" ,
                           input 26550 ,
                           input string(i-horiz-lib) + "~~" + string(item.horiz-fixo)).
        APPLY "ENTRY" to i-horiz-lib in frame {&frame-name}.
        return "ADM-ERROR":U.
  end.

  assign OVERLAY(item.char-1,20,12) = string(fi-qtd-min-ressup, ">>>>>>9.9999")
         OVERLAY(item.char-1,15,4)  = string(fi-dias-dlt-ressup, ">>>9")
         OVERLAY(item.char-1,35,12) = string(fi-qtd-dlt-ressup, ">>>>>>9.9999")
         OVERLAY(item.char-1,129,3) = string(i-horiz-lib, ">>9").   /* horizonte de libera‡Æo*/

  if input frame {&frame-name} l-demanda-item = yes then
     assign OVERLAY(item.char-1,132,1) = "1" . /* represa demanda       */
  else
     assign OVERLAY(item.char-1,132,1) = "2" .
      
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
  
  &if defined (bf_man_sfc_lc) &then
      assign cb-ind-lista-mrp:sensitive in frame {&frame-name} = no.
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

  &if defined (bf_man_sfc_lc) &then
      assign cb-ind-lista-mrp:hidden in frame {&frame-name} = no.
  &endif
  
  if avail item then do with frame {&frame-name}: 
     assign cb-classe-repro:screen-value   = {ininc/i06in122.i 04 item.classe-repro}
            cb-contr-plan:screen-value     = {ininc/i15in172.i 04 item.contr-plan}
            cb-emissao-ord:screen-value    = {ininc/i03in122.i 04 item.emissao-ord}
            cb-div-ordem:screen-value      = {ininc/i12in122.i 04 item.div-ordem}
            cb-classe-repro                = cb-classe-repro:screen-value
            cb-contr-plan                  = cb-contr-plan:screen-value
            cb-emissao-ord                 = cb-emissao-ord:screen-value
            cb-div-ordem                   = cb-div-ordem:screen-value
            fi-qtd-min-ressup              = dec(substring(item.char-1,20,12))
            fi-dias-dlt-ressup             = int(substring(item.char-1,15,4))
            fi-qtd-dlt-ressup              = dec(substring(item.char-1,35,12))
            i-horiz-lib                    = int(substring(item.char-1,129,3)).
      
      if substring(item.char-1,132,1) = "1" then
         assign l-demanda-item = yes.
      else 
         assign l-demanda-item = no.
   end.         
   else do:
       assign cb-classe-repro:screen-value  = {ininc/i06in122.i 04 1}
              cb-div-ordem:screen-value     = {ininc/i12in122.i 04 1}
              cb-contr-plan:screen-value    = {ininc/i15in172.i 04 1}
              cb-emissao-ord:screen-value   = {ininc/i03in122.i 04 1}.
   end.    
   
   display fi-qtd-min-ressup  with frame {&frame-name}.
   display fi-dias-dlt-ressup with frame {&frame-name}.
   display fi-qtd-dlt-ressup  with frame {&frame-name}.
   display i-horiz-lib        with frame {&frame-name}.
   display l-demanda-item     with frame {&frame-name}.

   
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

   if avail item then do with frame {&frame-name}: 
      &if defined (bf_man_sfc_lc) &then
          find first item-man
               where item-man.it-codigo = item.it-codigo no-lock no-error.
          if avail item-man then
               assign cb-ind-lista-mrp:screen-value = {ininc/i03in180.i 04 item-man.ind-lista-mrp}.
          else assign cb-ind-lista-mrp:screen-value = {ininc/i03in180.i 04 1}.
      &endif            
   end.         
   else do:
      &if defined (bf_man_sfc_lc) &then
          assign cb-ind-lista-mrp:screen-value = {ininc/i03in180.i 04 1}.
      &endif              
   end.
   
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
    
  &if defined (bf_man_sfc_lc) &then
      assign cb-ind-lista-mrp:sensitive in frame {&frame-name} = yes.
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
 
  do  with frame {&frame-name}:
      assign cb-classe-repro:list-items  = {ininc/i06in122.i 03} 
             cb-div-ordem:list-items     = {ininc/i12in122.i 03}
             cb-contr-plan:list-items    = {ininc/i15in172.i 03}
             cb-emissao-ord:list-items   = {ininc/i03in122.i 03}.
             
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.
  

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
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */
     
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
  {src/adm/template/snd-list.i "item"}

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

