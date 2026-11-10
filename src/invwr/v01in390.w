&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V01IN390 2.00.00.012 } /*** 010012 ***/

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

{cdp/cdcfgman.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var da-hoje as date init today format "99/99/9999".

DEF NEW GLOBAL SHARED VAR gr-reservas AS rowid NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-deposito AS rowid NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES reservas
&Scoped-define FIRST-EXTERNAL-TABLE reservas


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR reservas.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS reservas.it-codigo reservas.cod-refer ~
reservas.item-pai reservas.cod-roteiro reservas.op-codigo ~
reservas.quant-orig reservas.un reservas.quant-atend reservas.cod-depos ~
reservas.cod-localiz reservas.quant-requis reservas.dt-reserva ~
reservas.quant-aloc 
&Scoped-define ENABLED-TABLES reservas
&Scoped-define FIRST-ENABLED-TABLE reservas
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS reservas.it-codigo reservas.cod-refer ~
reservas.item-pai reservas.cod-roteiro reservas.op-codigo ~
reservas.quant-orig reservas.un reservas.quant-atend reservas.cod-depos ~
reservas.cod-localiz reservas.quant-requis reservas.dt-reserva ~
reservas.quant-aloc 
&Scoped-define DISPLAYED-TABLES reservas
&Scoped-define FIRST-DISPLAYED-TABLE reservas
&Scoped-Define DISPLAYED-OBJECTS fi-descricao-item-reserva ~
fi-descricao-item-pai fi-saldo fi-atraso fi-qt-aloc-lote 

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
DEFINE VARIABLE fi-atraso AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-item-pai AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-item-reserva AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-aloc-lote AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Aloc F°sica" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 10.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     reservas.it-codigo AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-descricao-item-reserva AT ROW 1.25 COL 46 NO-LABEL
     reservas.cod-refer AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     reservas.item-pai AT ROW 3.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-descricao-item-pai AT ROW 3.25 COL 44 COLON-ALIGNED NO-LABEL
     reservas.cod-roteiro AT ROW 4.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     reservas.op-codigo AT ROW 4.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     reservas.quant-orig AT ROW 5.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     reservas.un AT ROW 5.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     reservas.quant-atend AT ROW 6.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     reservas.cod-depos AT ROW 6.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     fi-saldo AT ROW 7.17 COL 25 COLON-ALIGNED
     reservas.cod-localiz AT ROW 7.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 23 BY .88
     reservas.quant-requis AT ROW 8.17 COL 25 COLON-ALIGNED FORMAT "->>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     reservas.dt-reserva AT ROW 8.17 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     reservas.quant-aloc AT ROW 9.17 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-atraso AT ROW 9.17 COL 61 COLON-ALIGNED
     fi-qt-aloc-lote AT ROW 10.17 COL 24.86 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.reservas
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
         HEIGHT             = 10.25
         WIDTH              = 86.
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

/* SETTINGS FOR FILL-IN fi-atraso IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-item-pai IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-item-reserva IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-qt-aloc-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN reservas.quant-requis IN FRAME f-main
   EXP-FORMAT                                                           */
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

{utp/ut-liter.i "Atraso" "MCP" "R"}
assign fi-atraso:label in frame {&frame-name} = return-value.

{utp/ut-liter.i "Saldo" "MCP" "R"}
assign fi-saldo:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "reservas"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "reservas"}

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
  if avail reservas then do:

   find item where item.it-codigo eq reservas.it-codigo no-lock no-error.
   if avail item then do:
       &if defined(bf_man_205) &then
       FIND FIRST param-global NO-LOCK NO-ERROR.
       IF param-global.modulo-per-ppm THEN DO:
           CASE ITEM.tipo-formula:
               /** Se for concentraá∆o ou PPM, mostra quantidade alocada fisica **/
               WHEN 2 OR WHEN 3 OR WHEN 4 THEN DO:
                   ASSIGN fi-qt-aloc-lote:VISIBLE IN FRAME {&FRAME-NAME} = YES
                          fi-qt-aloc-lote = reservas.qt-aloc-lote.
               END.
               /** Se for N∆o_Utiliza n∆o mostra quantidade alocada fisica **/
               OTHERWISE 
                   ASSIGN fi-qt-aloc-lote:VISIBLE IN FRAME {&FRAME-NAME} = NO.
           END CASE.
       END.
       &ENDIF
       assign fi-descricao-item-reserva = item.desc-item.
   end.
   else do:
      assign fi-descricao-item-reserva = "".
      &if defined(bf_man_205) &then
      FIND FIRST param-global NO-LOCK NO-ERROR.
      IF param-global.modulo-per-ppm THEN
          ASSIGN fi-qt-aloc-lote:VISIBLE IN FRAME {&FRAME-NAME} = NO.
      &ENDIF
   end.

   find item where item.it-codigo eq reservas.item-pai no-lock no-error.
   if avail item then   
      assign fi-descricao-item-pai = item.desc-item.
   else 
      assign fi-descricao-item-pai = "".
   
   assign fi-saldo  = reservas.quant-orig - reservas.quant-atend.
  
   assign fi-atraso = 0.
   find ord-prod where ord-prod.nr-ord-prod eq reservas.nr-ord-prod no-lock no-error.
   if (avail(ord-prod)) then do:
      if ( (reservas.quant-atend lt reservas.quant-orig)   and
           (ord-prod.dt-termino lt da-hoje             ) ) then 
         assign fi-atraso = da-hoje - ord-prod.dt-termino.
   end.
   
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

  /* Code placed here will execute AFTER standard behavior.    */
  
  &if defined(bf_man_205) &then
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF NOT param-global.modulo-per-ppm THEN 
  &ENDIF
      ASSIGN fi-qt-aloc-lote:HIDDEN IN FRAME {&FRAME-NAME} = YES.

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
  if avail reservas then 
     assign gr-reservas = rowid(reservas) .
     
  FIND deposito WHERE deposito.cod-depos = reservas.cod-depos NO-LOCK NO-ERROR.
  IF  AVAIL deposito THEN
      ASSIGN gr-deposito = ROWID(deposito).    

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
  
  /* Ponha aqui a validaá∆o de chave duplicada */
  
  /* Ponha aqui as demais validaá‰es */
  
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "reservas"}

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

