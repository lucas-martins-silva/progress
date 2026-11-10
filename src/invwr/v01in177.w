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
{include/i-prgvrs.i V01IN177 2.00.00.013}  /*** 010013 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in177 MUT}
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

{cdp/cdcfgdis.i}

/* Parameters Definitions ---                                           */

   def new global shared var gr-item-estab as rowid no-undo.
   
/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES item-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-estab.tx-importacao ~
item-estab.niv-rest-dentro item-estab.per-rest-dentro ~
item-estab.niv-rest-fora item-estab.per-rest-fora 
&Scoped-define ENABLED-TABLES item-estab
&Scoped-define FIRST-ENABLED-TABLE item-estab
&Scoped-define DISPLAYED-TABLES item-estab
&Scoped-define FIRST-DISPLAYED-TABLE item-estab
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-estab.cod-estabel item-estab.it-codigo ~
item-estab.tx-importacao item-estab.niv-rest-dentro ~
item-estab.per-rest-dentro item-estab.niv-rest-fora ~
item-estab.per-rest-fora 
&Scoped-Define DISPLAYED-OBJECTS c-descricao-1 c-descricao-2 c-fm-codigo ~
c-descricao-3 c-nr-dcr-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS item-estab.cod-estabel ~
item-estab.it-codigo 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descricao-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-2 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-codigo AS CHARACTER FORMAT "X(256)":U 
     LABEL "c-fm-codigo" 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-dcr-item AS CHARACTER FORMAT "X(12)":U 
     LABEL "DCR Item" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 5.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-estab.cod-estabel AT ROW 1.17 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-descricao-1 AT ROW 1.17 COL 34.43 COLON-ALIGNED NO-LABEL
     item-estab.it-codigo AT ROW 2.17 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-2 AT ROW 2.17 COL 44.43 COLON-ALIGNED NO-LABEL
     c-fm-codigo AT ROW 3.63 COL 26.72 COLON-ALIGNED
     c-descricao-3 AT ROW 3.63 COL 39.43 COLON-ALIGNED NO-LABEL
     c-nr-dcr-item AT ROW 4.63 COL 26.72 COLON-ALIGNED HELP
          "N£mero DCR do item"
     item-estab.tx-importacao AT ROW 5.63 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     item-estab.niv-rest-dentro AT ROW 6.63 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     item-estab.per-rest-dentro AT ROW 6.63 COL 30.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     item-estab.niv-rest-fora AT ROW 7.63 COL 26.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     item-estab.per-rest-fora AT ROW 7.63 COL 30.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-estab
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
         HEIGHT             = 7.79
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-dcr-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-estab.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN item-estab.it-codigo IN FRAME f-main
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

&Scoped-define SELF-NAME c-fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-codigo V-table-Win
ON LEAVE OF c-fm-codigo IN FRAME f-main /* c-fm-codigo */
DO:
  {include/leave.i &tabela=familia
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-3
                   &where="item.fm-codigo = input frame {&frame-name}
                           c-fm-codigo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON F5 OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  l-implanta = yes.
  {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                  &tabela=item-estab
                  &atributo=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON LEAVE OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-descricao-1
                   &where="estabelec.cod-estabel = input frame {&frame-name}
                           item-estab.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON F5 OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
  l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                  &tabela=item-estab
                  &atributo=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON LEAVE OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=descricao-1
                   &variavel-ref=c-descricao-2
                   &where="item.it-codigo = input frame {&frame-name}
                           item-estab.it-codigo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.niv-rest-dentro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.niv-rest-dentro V-table-Win
ON LEAVE OF item-estab.niv-rest-dentro IN FRAME f-main /* Nivel Restituicao Dentro */
DO:
  if input frame {&frame-name} item-estab.niv-rest-dentro = "A" then
     display 0 @ item-estab.per-rest-dentro with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.niv-rest-fora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.niv-rest-fora V-table-Win
ON LEAVE OF item-estab.niv-rest-fora IN FRAME f-main /* N¡vel Restitui‡Æo Fora UF */
DO:
  if input frame {&frame-name} item-estab.niv-rest-fora = "A" then
     display 0 @ item-estab.per-rest-fora with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if item-estab.cod-estabel:load-mouse-pointer("image~\lupa.cur") then.
  if item-estab.it-codigo:load-mouse-pointer("image~\lupa.cur") then.

  {utp/ut-field.i mgind item fm-codigo 1}.
   assign c-fm-codigo:label in frame {&frame-name} = return-value.  

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
  {src/adm/template/row-list.i "item-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-estab"}

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
          
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

     find item-estab where item-estab.cod-estabel =  input frame {&frame-name} item-estab.cod-estabel and
                           item-estab.it-codigo   =  input frame {&frame-name} item-estab.it-codigo no-lock no-error.
     if avail item-estab and adm-new-record then do: 
        {utp/ut-table.i mgind item-estab 1} 
        run utp/ut-msgs.p (input "show":U, input 7, input return-value).
        return 'ADM-ERROR':U.
     end.
     
   if input frame {&frame-name} item-estab.tx-importacao = ? then do:
      run utp/ut-msgs.p (input "show",
                         input 129,
                         input "").
      apply 'entry' to item-estab.tx-importacao in frame {&frame-name}.
      return 'adm-error'.
   end.

   if input frame {&frame-name} item-estab.niv-rest-dentro = ?  or 
      input frame {&frame-name} item-estab.niv-rest-dentro = "" then do:
      run utp/ut-msgs.p (input "show",
                         input 130,
                         input "").
      apply 'entry' to item-estab.niv-rest-dentro in frame {&frame-name}.
      return 'adm-error'.
   end.
  
   if input frame {&frame-name} item-estab.per-rest-dentro > 100 then do: 
      run utp/ut-msgs.p (input "show",
                         input 131,
                         input "").
      apply 'entry' to item-estab.per-rest-dentro in frame {&frame-name}.
      return 'adm-error'.
   end.
   
   if input frame {&frame-name} item-estab.niv-rest-fora = ?  or 
      input frame {&frame-name} item-estab.niv-rest-fora = "" then do:
      run utp/ut-msgs.p (input "show",
                         input 130,
                         input "").
      apply 'entry' to item-estab.niv-rest-fora in frame {&frame-name}.
      return 'adm-error'.
   end.
  
   if input frame {&frame-name} item-estab.per-rest-fora > 100 then do:
      run utp/ut-msgs.p (input "show",
                         input 131,
                         input "").
      apply 'entry' to item-estab.per-rest-fora in frame {&frame-name}.
      return 'adm-error'.
   end.
    
    
    
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    if adm-new-record then do:

       find item where item.it-codigo = 
                   input frame {&frame-name} item-estab.it-codigo
                   no-lock no-error.
                   
       if avail item then
          assign item-estab.deposito-pad = item.deposito-pad.
          
    end.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
   if available item-estab then do:
     find estabelec no-lock where
          estabelec.cod-estabel = item-estab.cod-estabel no-error.
     if available estabelec then
        assign c-descricao-1 = estabelec.nome.
     else
        assign c-descricao-1 = "".

     find item no-lock where
          item.it-codigo = item-estab.it-codigo no-error.
     if available item then do:
        assign c-fm-codigo   = item.fm-codigo
               c-descricao-2 = item.desc-item
               c-nr-dcr-item = &IF "{&bf_dis_versao_ems}" < "2.071" &THEN
                                   substr(item.char-2,217,12).
                               &ELSE
                                   item.cod-dcr-item.
                               &ENDIF

     find familia no-lock where
             familia.fm-codigo = item.fm-codigo no-error.
     if available familia then
           assign c-descricao-3 = familia.descricao .
     else
           assign c-descricao-3 = "".
     end.
     else 
        assign c-descricao-2 = "".
   end.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

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

  if avail item-estab then
     assign gr-item-estab = rowid(item-estab).
     
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

/*   if input frame {&frame-name} item-estab.tx-importacao = ? then do:
 *       run utp/ut-msgs.p (input "show",
 *                          input 129,
 *                          input "").
 *       apply 'entry' to item-estab.tx-importacao in frame {&frame-name}.
 *       return 'adm-error'.
 *    end.
 * 
 *    if input frame {&frame-name} item-estab.niv-rest-dentro = ?  or 
 *       input frame {&frame-name} item-estab.niv-rest-dentro = "" then do:
 *       run utp/ut-msgs.p (input "show",
 *                          input 130,
 *                          input "").
 *       apply 'entry' to item-estab.niv-rest-dentro in frame {&frame-name}.
 *       return 'adm-error'.
 *    end.
 *   
 *    if input frame {&frame-name} item-estab.per-rest-dentro > 100 then do: 
 *       run utp/ut-msgs.p (input "show",
 *                          input 131,
 *                          input "").
 *       apply 'entry' to item-estab.per-rest-dentro in frame {&frame-name}.
 *       return 'adm-error'.
 *    end.
 *    
 *    if input frame {&frame-name} item-estab.niv-rest-fora = ?  or 
 *       input frame {&frame-name} item-estab.niv-rest-fora = "" then do:
 *       run utp/ut-msgs.p (input "show",
 *                          input 130,
 *                          input "").
 *       apply 'entry' to item-estab.niv-rest-fora in frame {&frame-name}.
 *       return 'adm-error'.
 *    end.
 *   
 *    if input frame {&frame-name} item-estab.per-rest-fora > 100 then do:
 *       run utp/ut-msgs.p (input "show",
 *                          input 131,
 *                          input "").
 *       apply 'entry' to item-estab.per-rest-fora in frame {&frame-name}.
 *       return 'adm-error'.
 *    end.*/
   
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "item-estab"}

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

