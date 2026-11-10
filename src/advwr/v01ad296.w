&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD296 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD296 MUT}
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
def buffer b-ocor-bcia-bco for ocor-bcia-bco.
def var i-tip-ocor-bcia as integer format "99"    no-undo.
def var c-tip-ocor      as char    format "x(20)" no-undo.
def var i-modulo        as integer format "99"    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ocor-bcia-bco
&Scoped-define FIRST-EXTERNAL-TABLE ocor-bcia-bco


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ocor-bcia-bco.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ocor-bcia-bco.cod-ocor-bcia-bco ~
ocor-bcia-bco.vl-ocor-bcia-bco 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-ocor-bcia-bco ~{&FP2}cod-ocor-bcia-bco ~{&FP3}~
 ~{&FP1}vl-ocor-bcia-bco ~{&FP2}vl-ocor-bcia-bco ~{&FP3}
&Scoped-define ENABLED-TABLES ocor-bcia-bco
&Scoped-define FIRST-ENABLED-TABLE ocor-bcia-bco
&Scoped-Define ENABLED-OBJECTS rt-key RECT-1 rt-mold 
&Scoped-Define DISPLAYED-FIELDS ocor-bcia-bco.cod-banco ~
ocor-bcia-bco.ind-ocor-bcia ocor-bcia-bco.cod-ocor-bcia-bco ~
ocor-bcia-bco.vl-ocor-bcia-bco 
&Scoped-Define DISPLAYED-OBJECTS c-desc-banco cb-modulo c-tip-ocor-bcia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS ocor-bcia-bco.cod-banco cb-modulo ~
ocor-bcia-bco.ind-ocor-bcia c-tip-ocor-bcia 

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
DEFINE VARIABLE c-tip-ocor-bcia AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Ocor. Bancaria" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE 32 BY 1 NO-UNDO.

DEFINE VARIABLE cb-modulo AS CHARACTER FORMAT "X(256)":U INITIAL "0" 
     LABEL "M¢dulo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS " "
     SIZE-PIXELS 147 BY 24 NO-UNDO.

DEFINE VARIABLE c-desc-banco AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27.43 BY 1.13.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.17.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ocor-bcia-bco.cod-banco AT ROW 1.54 COL 25.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-banco AT ROW 1.54 COL 30.72 COLON-ALIGNED NO-LABEL
     cb-modulo AT Y 36 X 170 COLON-ALIGNED
     ocor-bcia-bco.ind-ocor-bcia AT ROW 3.79 COL 28.72 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Remessa", 1,
"Retorno", 2
          SIZE 23.57 BY .83
     c-tip-ocor-bcia AT ROW 4.96 COL 25.29 COLON-ALIGNED
     ocor-bcia-bco.cod-ocor-bcia-bco AT ROW 6.46 COL 25.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     ocor-bcia-bco.vl-ocor-bcia-bco AT ROW 7.46 COL 25.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     rt-key AT ROW 1 COL 1
     RECT-1 AT ROW 3.63 COL 27.29
     rt-mold AT ROW 6.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.ocor-bcia-bco
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
         HEIGHT             = 7.63
         WIDTH              = 88.72.
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

/* SETTINGS FOR FILL-IN c-desc-banco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-tip-ocor-bcia IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR COMBO-BOX cb-modulo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN ocor-bcia-bco.cod-banco IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR RADIO-SET ocor-bcia-bco.ind-ocor-bcia IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-modulo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-modulo V-table-Win
ON VALUE-CHANGED OF cb-modulo IN FRAME f-main /* M¢dulo */
DO:
apply 'value-changed' to ocor-bcia-bco.ind-ocor-bcia in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ocor-bcia-bco.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.cod-banco V-table-Win
ON F5 OF ocor-bcia-bco.cod-banco IN FRAME f-main /* Banco */
DO:
 assign l-implanta = yes. 
{include/zoomvar.i &prog-zoom=adzoom/z01ad018.w
                   &campo=ocor-bcia-bco.cod-banco
                   &campozoom=cod-banco}
                   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.cod-banco V-table-Win
ON LEAVE OF ocor-bcia-bco.cod-banco IN FRAME f-main /* Banco */
DO:
 
  find banco where banco.cod-banco = input frame {&FRAME-NAME} ocor-bcia-bco.cod-banco no-error.
  if avail banco 
   then assign c-desc-banco:screen-value = banco.nome-banco.
   else assign c-desc-banco:screen-value = "".
   
   assign cb-modulo:list-items   = {adinc/i04ad296.i 03}
          cb-modulo:screen-value = {adinc/i04ad296.i 04 1}
          c-tip-ocor-bcia:list-items   = {adinc/i02ad296.i 03}
          c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 1}.
       
    
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.cod-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ocor-bcia-bco.cod-banco IN FRAME f-main /* Banco */
DO:
      apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ocor-bcia-bco.ind-ocor-bcia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ocor-bcia-bco.ind-ocor-bcia V-table-Win
ON VALUE-CHANGED OF ocor-bcia-bco.ind-ocor-bcia IN FRAME f-main /* Remessa/Retorno */
DO:
   do  with frame {&FRAME-NAME}:
       assign input frame {&frame-name} cb-modulo i-modulo = {adinc/i04ad296.i 06 cb-modulo}.
       if  i-modulo = 1 and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then do:
            assign c-tip-ocor-bcia:list-items   = {adinc/i02ad296.i 03}
                  c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 1}.
       end.
       else do: 
            if  i-modulo = 1 and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then do:
              assign c-tip-ocor-bcia:list-items   = {adinc/i03ad296.i 03}
                     c-tip-ocor-bcia:screen-value = {adinc/i03ad296.i 04 1}.
           end.          
            else do:         
                if  i-modulo = 2 and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then do:
                  assign c-tip-ocor-bcia:list-items   = {adinc/i05ad296.i 03}
                         c-tip-ocor-bcia:screen-value = {adinc/i05ad296.i 04 1}.
                 end.        
                else do:
                  if  i-modulo = 2 and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then do:
                    assign c-tip-ocor-bcia:list-items   = {adinc/i06ad296.i 03}
                           c-tip-ocor-bcia:screen-value = {adinc/i06ad296.i 04 1}.         
                  end.
                 end.
            end.
      end.
    end.             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  IF INput FRAME {&FRAME-NAME} ocor-bcia-bco.cod-banco:LOAD-MOUSE-POINTER ("image\lupa.cur")  THEN.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "ocor-bcia-bco"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ocor-bcia-bco"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

   RUN get-attribute ('adm-new-record':U).
   if  return-value = "yes":U
    then do:
       assign input frame {&frame-name} cb-modulo i-modulo = {adinc/i04ad296.i 06 cb-modulo}.
       
       if i-modulo = 1 and
          input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then do:
          assign input frame {&frame-name} c-tip-ocor-bcia 
                 i-tip-ocor-bcia = {adinc/i02ad296.i 06 c-tip-ocor-bcia}.
        end.  
        else do:
             if i-modulo = 1 and 
                input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then do:
                assign input frame {&frame-name} c-tip-ocor-bcia 
                       i-tip-ocor-bcia = {adinc/i03ad296.i 06 c-tip-ocor-bcia}.
              end.  
              else do:
                  if  i-modulo = 2 and 
                      input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then do:
                      assign input frame {&frame-name} c-tip-ocor-bcia 
                             i-tip-ocor-bcia = {adinc/i05ad296.i 06 c-tip-ocor-bcia}.
                  end.     
                  else do:                  
                      if i-modulo = 2 and 
                         input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then do:
                         assign input frame {&frame-name} c-tip-ocor-bcia 
                                i-tip-ocor-bcia = {adinc/i06ad296.i 06 c-tip-ocor-bcia}.
                      end.   
                  end.
               end.    
        end.     

        find first b-ocor-bcia-bco 
            where  b-ocor-bcia-bco.cod-banco         = input frame {&FRAME-NAME} ocor-bcia-bco.cod-banco 
             and   b-ocor-bcia-bco.ind-modul-dtsul   = i-modulo
             and   b-ocor-bcia-bco.ind-ocor-bcia     = input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia 
             and   b-ocor-bcia-bco.ind-tip-ocor-bcia = i-tip-ocor-bcia no-lock no-error.

            if available b-ocor-bcia-bco then do:       
                 run utp/ut-msgs.p (input "show",
                                    input 5293,    
                                    input "").
                 apply 'entry' to ocor-bcia-bco.cod-banco in frame {&FRAME-NAME}.
                 return ("adm-error":U).                 
             end.     
   
            find banco where banco.cod-banco = input frame {&FRAME-NAME} ocor-bcia-bco.cod-banco no-error.
                if  not available banco then do:        
                    run utp/ut-msgs.p (input "show",
                                       input 230,    
                                       input "").
                    apply 'entry' to ocor-bcia-bco.cod-banco in frame {&FRAME-NAME}.
                    return ("adm-error":U).                 
                 end. 
                
             if input frame {&FRAME-NAME} c-tip-ocor-bcia = "" then do:  
                {utp/ut-field.i mgadm ocor-bcia-bco ind-tip-ocor-bcia 1}
                run utp/ut-msgs.p (input "show",
                                   input 164,    
                                   input return-value).
                    apply 'entry' to c-tip-ocor-bcia in frame {&FRAME-NAME}.
                    return ("adm-error":U).                 
             end. 
        
             if input frame {&FRAME-NAME} ocor-bcia-bco.cod-ocor-bcia-bco = "" then do:  
                {utp/ut-field.i mgadm ocor-bcia-bco cod-ocor-bcia-bco 1}
                run utp/ut-msgs.p (input "show",
                                   input 164,    
                                   input return-value).
                    apply 'entry' to ocor-bcia-bco.cod-ocor-bcia-bco in frame {&FRAME-NAME}.
                    return ("adm-error":U).                 
             end. 
    end.    
             
    /* Dispatch standard ADM method.                             */
       RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
       
   RUN get-attribute ('adm-new-record':U).
   if  return-value = "yes":U
    then do:   
        if  i-modulo = 1 
        and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then
            assign ocor-bcia-bco.ind-tip-ocor-bcia = i-tip-ocor-bcia
                   ocor-bcia-bco.ind-modul-dtsul = i-modulo.
        else 
             if  i-modulo = 1 
             and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then 
                 assign ocor-bcia-bco.ind-tip-ocor-bcia = i-tip-ocor-bcia
                        ocor-bcia-bco.ind-modul-dtsul = i-modulo.
             else
                 if  i-modulo = 2 
                 and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then 
                     assign ocor-bcia-bco.ind-tip-ocor-bcia =  i-tip-ocor-bcia
                            ocor-bcia-bco.ind-modul-dtsul = i-modulo.                             
                 else
                     if  i-modulo = 2 
                     and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then 
                         assign ocor-bcia-bco.ind-tip-ocor-bcia =  i-tip-ocor-bcia
                                ocor-bcia-bco.ind-modul-dtsul = i-modulo.
    END.
    
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

  find banco 
      where banco.cod-banco = input frame {&FRAME-NAME} ocor-bcia-bco.cod-banco no-error.
  if  avail banco then
      assign c-desc-banco:screen-value = banco.nome-banco.
  else 
      assign c-desc-banco:screen-value = "".
                    
  assign input frame {&frame-name} cb-modulo 
         i-modulo = {adinc/i04ad296.i 06 cb-modulo}.

       if  i-modulo = 1
       and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then
           assign c-tip-ocor-bcia:list-items in frame {&FRAME-NAME} = {adinc/i02ad296.i 03}
                  c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 ocor-bcia-bco.ind-tip-ocor-bcia}
                  cb-modulo:list-items in frame {&FRAME-NAME} = {adinc/i04ad296.i 03}
                  cb-modulo:screen-value = {adinc/i04ad296.i 04 ocor-bcia-bco.ind-modul-dtsul}. 
       else 
            if  i-modulo = 1
            and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then
                assign c-tip-ocor-bcia:list-items in frame {&FRAME-NAME} = {adinc/i03ad296.i 03}
                       c-tip-ocor-bcia:screen-value = {adinc/i03ad296.i 04 ocor-bcia-bco.ind-tip-ocor-bcia}
                       cb-modulo:list-items in frame {&FRAME-NAME} = {adinc/i04ad296.i 03}
                       cb-modulo:screen-value = {adinc/i04ad296.i 04 ocor-bcia-bco.ind-modul-dtsul}.
            else
                if  i-modulo = 2
                and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 1 then
                    assign c-tip-ocor-bcia:list-items in frame {&FRAME-NAME} = {adinc/i05ad296.i 03}
                           c-tip-ocor-bcia:screen-value = {adinc/i05ad296.i 04 ocor-bcia-bco.ind-tip-ocor-bcia}
                           cb-modulo:list-items in frame {&FRAME-NAME} = {adinc/i04ad296.i 03}
                           cb-modulo:screen-value = {adinc/i04ad296.i 04 ocor-bcia-bco.ind-modul-dtsul}. 
                else
                    if  i-modulo = 2 
                    and input frame {&FRAME-NAME} ocor-bcia-bco.ind-ocor-bcia = 2 then
                        assign c-tip-ocor-bcia:list-items in frame {&FRAME-NAME} = {adinc/i06ad296.i 03}
                               c-tip-ocor-bcia:screen-value = {adinc/i06ad296.i 04 ocor-bcia-bco.ind-tip-ocor-bcia}
                               cb-modulo:list-items in frame {&FRAME-NAME} = {adinc/i04ad296.i 03}
                               cb-modulo:screen-value = {adinc/i04ad296.i 04 ocor-bcia-bco.ind-modul-dtsul}.


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

 assign input frame {&FRAME-NAME} cb-modulo:list-items         = {adinc/i04ad296.i 03}
        input frame {&FRAME-NAME} cb-modulo:screen-value       = {adinc/i04ad296.i 04 1}
        input frame {&FRAME-NAME} c-tip-ocor-bcia:list-items   = {adinc/i02ad296.i 03}
        input frame {&FRAME-NAME} c-tip-ocor-bcia:screen-value = {adinc/i02ad296.i 04 1}.

 /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( input 'initialize':U ) .



  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "ocor-bcia-bco"}

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


