&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmrp            PROGRESS
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
{include/i-prgvrs.i V59IN172 2.00.01.005} /*** "010105" 25/01/2024 16:49:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V59IN172 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def new global shared var gr-pl-prod    as rowid no-undo.
def new global shared var gr-item       as rowid no-undo.
def new global shared var gr-it-periodo as rowid no-undo.

def var c-handle      as char   no-undo.
DEF VAR h-handle      AS HANDLE NO-UNDO.
def var c-label-per   as char   no-undo.
def var c-label-segur as char   no-undo.

DEFINE VARIABLE i-compr-fabric AS INTEGER NO-UNDO.

{utp/ut-liter.i Per¡odo * L}
assign c-label-per = return-value.

{utp/ut-liter.i Seguran‡a * L}
assign c-label-segur = "(+" + trim(return-value) + ")".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-periodo
&Scoped-define FIRST-EXTERNAL-TABLE it-periodo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-periodo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-periodo.it-codigo it-periodo.cod-refer ~
i-compr-fabric
&Scoped-define ENABLED-TABLES it-periodo item
&Scoped-define FIRST-ENABLED-TABLE it-periodo
&Scoped-define SECOND-ENABLED-TABLE item
&Scoped-define DISPLAYED-TABLES it-periodo item
&Scoped-define FIRST-DISPLAYED-TABLE it-periodo
&Scoped-define SECOND-DISPLAYED-TABLE item
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS it-periodo.it-codigo it-periodo.cod-refer ~
i-compr-fabric 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-un c-periodo c-datas ~
de-quant 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */

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
DEFINE VARIABLE c-datas AS CHARACTER FORMAT "X(28)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 59 BY .88 NO-UNDO.

DEFINE VARIABLE c-periodo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-quant AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     it-periodo.it-codigo AT ROW 1.21 COL 5 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 1.21 COL 22.43 COLON-ALIGNED NO-LABEL
     c-un AT ROW 1.21 COL 81.57 COLON-ALIGNED HELP
          "Unidade de medida do item" NO-LABEL
     it-periodo.cod-refer AT ROW 2.63 COL 16.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     i-compr-fabric AT ROW 2.75 COL 32.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Comprado", 1,
"Fabricado", 2
          SIZE 26.29 BY .75
     c-periodo AT ROW 3.63 COL 16.43 COLON-ALIGNED
     c-datas AT ROW 3.63 COL 28.57 COLON-ALIGNED NO-LABEL
     de-quant AT ROW 4.63 COL 16.43 COLON-ALIGNED
     RECT-3 AT ROW 1 COL 1
     RECT-4 AT ROW 2.38 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.it-periodo
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
         HEIGHT             = 4.75
         WIDTH              = 88.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-datas IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-periodo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-quant IN FRAME F-Main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "it-periodo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-periodo"}

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
  HIDE FRAME F-Main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
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

  IF AVAIL it-periodo THEN DO:

      FIND FIRST pl-it-calc NO-LOCK
           WHERE pl-it-calc.cd-plano  = pl-prod.cd-plano 
             AND pl-it-calc.it-codigo = it-periodo.it-codigo  NO-ERROR.

      FIND FIRST ITEM WHERE ITEM.it-codigo = it-periodo.it-codigo no-lock NO-ERROR.

      ASSIGN i-compr-fabric = IF AVAILABLE pl-it-calc 
                              THEN pl-it-calc.compr-fabric
                              ELSE ITEM.compr-fabric.

      DISP i-compr-fabric WITH FRAME {&FRAME-NAME}.

      IF VALID-HANDLE(h-handle) AND AVAILABLE ITEM THEN 
            run pi-atualiza-pagina IN h-handle (input i-compr-fabric).    
      
  END.

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

  IF AVAIL it-periodo THEN
     ASSIGN gr-it-periodo = ROWID(it-periodo). 
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /*If avail it-periodo then
     assign de-qt-ord = it-periodo.qt-ord-plan + it-periodo.qt-ord-comp.*/

  {utp/ut-liter.i Quantidade * L }
  assign de-quant:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Per¡odo * L }
  assign c-periodo:label in frame {&frame-name} = return-value.
 
 
  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail it-periodo then do:
     assign c-periodo = string(it-periodo.periodo) + "/" + string(it-periodo.ano).
     
     if (it-periodo.data-1 = ?) or (it-periodo.data-1 = it-periodo.data) then do:
        assign c-datas = string(it-periodo.data, "99/99/9999").
     end.
     else do:
        assign c-datas = string(string(it-periodo.data-1, "99/99/9999") + "  " + "-" + "  " + string(it-periodo.data, "99/99/9999")).

     end.  

  end.

  IF NOT AVAILABLE pl-prod THEN
    FIND FIRST pl-prod NO-LOCK WHERE ROWID(pl-prod) = gr-pl-prod NO-ERROR.



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
  
    IF  AVAIL it-periodo THEN
        FIND FIRST ITEM WHERE ITEM.it-codigo = it-periodo.it-codigo no-lock NO-ERROR.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  
    IF  AVAIL it-periodo THEN
        FIND FIRST ITEM WHERE ITEM.it-codigo = it-periodo.it-codigo no-lock NO-ERROR.

  if avail item then do:
     assign gr-item = rowid(item).
     assign c-descricao = item.desc-item
            c-un        = ITEM.un.
     if  item.tipo-est-seg = 2 then do:
         
         assign c-periodo:label in frame {&frame-name} = trim(c-label-per) + trim(c-label-segur).
     end.
     else
         assign c-periodo:label in frame {&frame-name} = trim(c-label-per).
  end.   
  else assign c-descricao = ""
              c-un        = "".

  assign gr-it-periodo = rowid(it-periodo). 

  If avail it-periodo then do:
     run pi-calc-quant.  
     assign c-periodo = string(it-periodo.periodo) + "/" + string(it-periodo.ano).
     if (it-periodo.data-1 = ?) or (it-periodo.data-1 = it-periodo.data) then do:
        assign c-datas = string(it-periodo.data, "99/99/9999").
     end.
     else do:
        assign c-datas = string(string(it-periodo.data-1, "99/99/9999") + "  " + "-" + "  " + string(it-periodo.data, "99/99/9999")).

     end.  

/*     assign gr-it-periodo = rowid(it-periodo).  */

  end.
  
  disp c-descricao
       c-un
       de-quant 
       c-periodo
       i-compr-fabric 
       c-datas with frame {&frame-name}.
     
  if avail item then do:
    RUN set-attribute-list (INPUT "ComprFabric=" + string(item.compr-fabric)).
  end.   

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calc-quant V-table-Win 
PROCEDURE pi-calc-quant :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN get-attribute IN this-procedure
   (INPUT "TIPO-VIEWER").
   
case return-value:
     when "ORDENS" then 
          assign de-quant = it-periodo.qt-ord-plan + it-periodo.qt-ord-comp.
     when "RESERVAS" then 
          assign de-quant = it-periodo.qt-res-plan + it-periodo.qt-res-comp.
end case.
     
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-set-handle V-table-Win 
PROCEDURE pi-set-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-handle AS HANDLE NO-UNDO.

ASSIGN h-handle = p-handle.

     
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
  {src/adm/template/snd-list.i "it-periodo"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

