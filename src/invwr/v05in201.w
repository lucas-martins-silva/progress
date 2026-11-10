&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmnt            PROGRESS
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
{include/i-prgvrs.i V05IN201 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN201 MUT}
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
{cdp/cdcfgmnt.i}
CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */
def new global shared var v-row-parent  as rowid no-undo.                                
def new global shared var gr-equipto    as rowid  no-undo.
def new global shared var gr-tag        as rowid  no-undo.
def new global shared var gr-manut      as rowid  no-undo.
def new global shared var gr-man-eq-tag as rowid  no-undo.

/* Parameters Definitions ---                            */

/* Local Variable Definitions ---                        */
  def buffer b-man-eq-tag for man-eq-tag.
  def var c-query-hdl    as char    no-undo.
  def var h-query-hdl    as handle  no-undo.
  def var i-cont         as integer no-undo.
  def var c-viewer-hdl   as char    no-undo.
  def var h-viewer-hdl   as handle  no-undo.

{cdp/cd0666.i} /*Definiá∆o tt-erro*/

{bhp/bh9999.i1} /* Definiá∆o Temp-Table TT-TABELA   */

{cdp/cd9911.i}

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
&Scoped-define EXTERNAL-TABLES man-eq-tag
&Scoped-define FIRST-EXTERNAL-TABLE man-eq-tag


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-eq-tag.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-eq-tag.descricao 
&Scoped-define ENABLED-TABLES man-eq-tag
&Scoped-define FIRST-ENABLED-TABLE man-eq-tag
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS man-eq-tag.cd-equipto man-eq-tag.cd-tag ~
man-eq-tag.cd-manut man-eq-tag.descricao 
&Scoped-define DISPLAYED-TABLES man-eq-tag
&Scoped-define FIRST-DISPLAYED-TABLE man-eq-tag
&Scoped-Define DISPLAYED-OBJECTS c-desc-equipto c-desc-tag 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS man-eq-tag.cd-equipto man-eq-tag.cd-tag ~
man-eq-tag.cd-manut 

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
DEFINE VARIABLE c-cod-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88.

DEFINE VARIABLE c-desc-equipto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tag AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.43 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-eq-tag.cd-equipto AT ROW 1.13 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-desc-equipto AT ROW 1.13 COL 44 NO-LABEL
     man-eq-tag.cd-tag AT ROW 2.13 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     c-desc-tag AT ROW 2.13 COL 42 COLON-ALIGNED NO-LABEL
     man-eq-tag.cd-manut AT ROW 3.13 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     man-eq-tag.descricao AT ROW 3.13 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 42 BY .88
     c-cod-unid-negoc AT ROW 4.13 COL 22 COLON-ALIGNED
     c-des-unid-negoc AT ROW 4.13 COL 42 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.man-eq-tag
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
         HEIGHT             = 4.25
         WIDTH              = 88.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-desc-equipto IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-desc-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-eq-tag.cd-equipto IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN man-eq-tag.cd-manut IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN man-eq-tag.cd-tag IN FRAME f-main
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

&Scoped-define SELF-NAME man-eq-tag.cd-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-equipto V-table-Win
ON F5 OF man-eq-tag.cd-equipto IN FRAME f-main /* Equipamento */
DO:
   assign l-implanta = yes. /* para o botao implanta do Zoom */
   {include/zoom.i &prog-zoom="inzoom/z01in095.w"
                   &tabela=man-eq-tag
                   &atributo=cd-equipto}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-equipto V-table-Win
ON LEAVE OF man-eq-tag.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  {include/leave.i &tabela=equipto
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-equipto
                   &where="equipto.cd-equipto = input frame {&frame-name} 
                                                man-eq-tag.cd-equipto"}

  RUN pi-mostra-un-negoc.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-equipto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-eq-tag.cd-equipto IN FRAME f-main /* Equipamento */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-eq-tag.cd-manut
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-manut V-table-Win
ON F5 OF man-eq-tag.cd-manut IN FRAME f-main /* Manutená∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in205.w"
                  &tabela=man-eq-tag
                  &atributo=cd-manut}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-manut V-table-Win
ON LEAVE OF man-eq-tag.cd-manut IN FRAME f-main /* Manutená∆o */
DO:
  {include/leave.i &tabela=manut
                   &atributo-ref=descricao
                   &variavel-ref=man-eq-tag.descricao
                   &where="manut.cd-manut = input frame {&frame-name} 
                                                        man-eq-tag.cd-manut"}.
  if avail manut then do:
    RUN get-link-handle IN adm-broker-hdl
         (INPUT this-procedure,
          INPUT "Record-source",
          OUTPUT c-query-hdl).
      RUN get-link-handle in adm-broker-hdl
         (INPUT widget-handle(c-query-hdl),
          INPUT "Record-target",
          OUTPUT c-viewer-hdl).
      DO i-cont = 1 To num-entries(c-viewer-hdl):
         assign h-viewer-hdl = widget-handle(entry (i-cont, c-viewer-hdl)).
         if h-viewer-hdl <> this-procedure then
            run pi-dado-inicial in h-viewer-hdl(input rowid (manut)).
      end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-manut V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-eq-tag.cd-manut IN FRAME f-main /* Manutená∆o */
DO:
   APPLY 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-eq-tag.cd-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-tag V-table-Win
ON F5 OF man-eq-tag.cd-tag IN FRAME f-main /* TAG */
DO:
   assign l-implanta = yes.  /* para o botao implanta do Zoom */
   {include/zoom.i &prog-zoom="inzoom/z01in419.w"
                   &tabela=man-eq-tag
                   &atributo=cd-tag}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-tag V-table-Win
ON LEAVE OF man-eq-tag.cd-tag IN FRAME f-main /* TAG */
DO:
  {include/leave.i &tabela=tag
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-tag
                   &where="tag.cd-tag = input frame {&frame-name} 
                                        man-eq-tag.cd-tag"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-eq-tag.cd-tag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-eq-tag.cd-tag IN FRAME f-main /* TAG */
DO:
   APPLY 'F5' to self.  
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

  if  man-eq-tag.cd-manut:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-eq-tag.cd-equipto:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
  if  man-eq-tag.cd-tag:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} 
      then.
      
{database/tgin/tdp/tdin201.i}

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
  {src/adm/template/row-list.i "man-eq-tag"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-eq-tag"}

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .


  /* Code placed here will execute AFTER standard behavior.    */
  DISABLE  man-eq-tag.cd-manut  with frame {&frame-name}.   


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
 
  run pi-valida-eliminacao-man-eq-tag.
  if  return-value <> "ok" then do:
      run pi-mostra-erros.
      return "ADM-ERROR".
  end.
  
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
  if  avail man-eq-tag then do:
      find equipto
          where equipto.cd-equipto = man-eq-tag.cd-equipto
          no-lock no-error.
      assign c-desc-equipto = if avail equipto then equipto.descricao else "":U
             gr-equipto     = if avail equipto then rowid(equipto) else ?.
      disp c-desc-equipto with frame {&frame-name}.
      find tag
          where tag.cd-tag = man-eq-tag.cd-tag
          no-lock no-error.
      assign c-desc-tag = if avail tag then tag.descricao else "":U
             gr-tag     = if avail tag then rowid(tag) else ?.
      disp c-desc-tag with frame {&frame-name}.      
      find manut
          where manut.cd-manut = man-eq-tag.cd-manut
          no-lock no-error.
      assign man-eq-tag.descricao:screen-value = if avail manut then manut.descricao else "":U
             gr-manut                          = if avail manut then rowid(manut) else ?.
      disp   man-eq-tag.descricao with frame {&frame-name}.

      RUN pi-mostra-un-negoc.

  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-mi
      no-lock no-error.
  if  avail param-mi then do:
      if  param-mi.formato-cd-equipto <> " " then
          assign man-eq-tag.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
      if  param-mi.formato-cd-tag <> " " then
          assign man-eq-tag.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
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

  ASSIGN c-cod-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = l-usa-unid-negoc
         c-des-unid-negoc:VISIBLE IN FRAME {&FRAME-NAME} = l-usa-unid-negoc.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if avail man-eq-tag then
     assign gr-man-eq-tag = rowid(man-eq-tag).  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
for each tt-erro:
    delete tt-erro.
end.

{database/tgin/tdp/tdin201.i1}
   
run cdp/cd0666.w (input table tt-erro).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-un-negoc V-table-Win 
PROCEDURE pi-mostra-un-negoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
      IF  l-usa-unid-negoc THEN DO WITH FRAME {&FRAME-NAME}:
          IF AVAIL equipto THEN DO:
              ASSIGN c-cod-unid-negoc:SCREEN-VALUE = &IF DEFINED(bf_mnt_ems207) &THEN equipto.cod-unid-negoc &ELSE SUBSTRING(equipto.char-1,1,3) &ENDIF.

              &IF DEFINED(bf_mnt_ems206b) &THEN
                  FOR FIRST unid-negoc NO-LOCK
                      WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc:SCREEN-VALUE:
                  END.
                  ASSIGN c-des-unid-negoc:SCREEN-VALUE = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
              &ENDIF
          END.
          ELSE ASSIGN c-cod-unid-negoc:SCREEN-VALUE = "":U
                      c-des-unid-negoc:SCREEN-VALUE = "":U.
      END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-manut V-table-Win 
PROCEDURE pi-passa-manut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param r-manut2 as rowid no-undo.

assign r-manut2 = gr-manut.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
  
  /* valida a nao existencia das chaves estrangeiras */
  /*Equipamento*/
  if  man-eq-tag.cd-equipto:sensitive in frame {&frame-name} = yes 
  and not can-find (equipto where equipto.cd-equipto = input frame {&frame-name}
                                                       man-eq-tag.cd-equipto)
  then do: 
      {utp/ut-table.i mgind equipto 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-eq-tag.cd-equipto.
      return 'ADM-ERROR'.
  end.  
  
  
  /*TAG*/
  if  man-eq-tag.cd-tag:sensitive in frame {&frame-name} = yes 
  and not can-find (tag where tag.cd-tag = input frame {&frame-name} man-eq-tag.cd-tag)
  then do: 
      {utp/ut-table.i mgind tag 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-eq-tag.cd-tag.
      return 'ADM-ERROR'.
  end.  
  
  
  /*Manutená∆o*/
  if  man-eq-tag.cd-manut:sensitive in frame {&frame-name} = yes 
  and not can-find (manut where manut.cd-manut = man-eq-tag.cd-manut:screen-value 
  in frame {&frame-name} )   then do: 
      {utp/ut-table.i mgind manut 1}
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */
      run utp/ut-msgs.p(input "show",
                        input 2,
                        input return-value).
      apply 'entry' to man-eq-tag.cd-manut.
      return 'ADM-ERROR'.
  end.    
  
  
  
  /* Ponha aqui a validaá∆o de chave duplicada */  
     if  man-eq-tag.cd-equipto:sensitive in frame {&frame-name} = yes  and 
     can-find (b-man-eq-tag where b-man-eq-tag.cd-equipto = 
                                     input frame {&frame-name} man-eq-tag.cd-equipto
           and b-man-eq-tag.cd-manut = 
                                     input frame {&frame-name} man-eq-tag.cd-manut
           and b-man-eq-tag.cd-tag = 
                                     input frame {&frame-name} man-eq-tag.cd-tag)
     then do: 
         {utp/ut-table.i mgind man-eq-tag 1}
         {include/i-vldprg.i}   /* posiciona p†gina */
         run utp/ut-msgs.p(input "show",
                           input 1,
                           input return-value).
         apply 'entry' to man-eq-tag.cd-equipto.
         return 'ADM-ERROR'.
     end. 
  
  
    /* validaá∆o de nivel de TAG = 999 */    
     if  man-eq-tag.cd-equipto:sensitive in frame {&frame-name} = yes then
     do:
         find tag where tag.cd-tag = input frame {&frame-name} man-eq-tag.cd-tag.
         if  tag.cod-tipo <> 999 then do:
             {include/i-vldprg.i}   /* posiciona p†gina */
             run utp/ut-msgs.p(input "show",
                               input 6221,
                               input "").
             apply 'entry' to man-eq-tag.cd-tag.
             return 'ADM-ERROR'.
         end.
     end.      
     
     
  /*Segue um exemplo de validaá∆o de programa 
  *    find tabela where tabela.campo1 = c-variavel and
  *                      tabela.campo2 > i-variavel no-lock no-error.
  *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
  *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
  *    return 'ADM-ERROR':U.*/
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
  {src/adm/template/snd-list.i "man-eq-tag"}

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

