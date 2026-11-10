&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V10IN271 2.00.00.023} /*** "010023" 16/07/2024 13:36:53 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10IN271 MUT}
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

/* Parameters Definitions ---                                           */

{cdp/cdcfgman.i}

/* Local Variable Definitions ---                                       */

def new global shared var v-row-parent as rowid no-undo.

def new global shared var gr-ord-prod as rowid no-undo.

def var h-cpapi013 as handle no-undo.

def var h-bosc038 as handle         no-undo. 
def var l-item-req as logical      no-undo.
DEFINE VARIABLE l-altera-reserva AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-traducao AS CHARACTER   NO-UNDO.

{cpp/cpapi013.i} /* Defini‡Æo da temp-table de aloca‡Æo */
{cdp/cd0666.i}   /* Defini‡Æo da tt-erro */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES reservas
&Scoped-define FIRST-EXTERNAL-TABLE reservas


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR reservas.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS reservas.quant-orig reservas.quant-atend ~
reservas.un reservas.dt-reserva reservas.estado 
&Scoped-define ENABLED-TABLES reservas
&Scoped-define FIRST-ENABLED-TABLE reservas
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-3 rs-tipo-sobra 
&Scoped-Define DISPLAYED-FIELDS reservas.quant-orig reservas.quant-atend ~
reservas.un reservas.dt-reserva reservas.estado 
&Scoped-define DISPLAYED-TABLES reservas
&Scoped-define FIRST-DISPLAYED-TABLE reservas
&Scoped-Define DISPLAYED-OBJECTS rs-tipo-sobra fi-ajuste fi-qt-atend-lote ~
FILL-IN-1 FILL-IN-2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS reservas.quant-orig reservas.dt-reserva 
&Scoped-define ADM-ASSIGN-FIELDS reservas.quant-orig reservas.dt-reserva 

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
DEFINE VARIABLE fi-ajuste AS DECIMAL FORMAT "->,>>>,>>9.9999" INITIAL 0 
     LABEL "Ajuste" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-atend-lote AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "qt" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 21 BY .63 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE rs-tipo-sobra AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Retorno de Requisi‡ao", 1,
"Sobra", 2,
"Co-Produto", 3,
"Normal", 4
     SIZE 25.72 BY 2.83 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27 BY 3.63.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 27 BY 1.63.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 6.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     reservas.quant-orig AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     rs-tipo-sobra AT ROW 2.17 COL 47.86 NO-LABEL
     fi-ajuste AT ROW 2.33 COL 27 COLON-ALIGNED
     reservas.quant-atend AT ROW 3.42 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     fi-qt-atend-lote AT ROW 4.25 COL 27 COLON-ALIGNED
     reservas.un AT ROW 4.5 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     reservas.dt-reserva AT ROW 5.58 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     reservas.estado AT ROW 6.13 COL 48.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 1,
"Inativo", 2
          SIZE 25 BY .79
     FILL-IN-1 AT ROW 1.25 COL 46 COLON-ALIGNED NO-LABEL
     FILL-IN-2 AT ROW 5.5 COL 46.43 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.54 COL 47
     RECT-2 AT ROW 5.58 COL 47.29
     RECT-3 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.reservas
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
         HEIGHT             = 6.63
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN reservas.dt-reserva IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR FILL-IN fi-ajuste IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-qt-atend-lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN reservas.quant-orig IN FRAME f-main
   1 2                                                                  */
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

&Scoped-define SELF-NAME reservas.quant-orig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL reservas.quant-orig V-table-Win
ON LEAVE OF reservas.quant-orig IN FRAME f-main /* Qtde Reserva */
DO:
    if input frame {&frame-name} reservas.quant-orig > 0 then do:
        assign rs-tipo-sobra:screen-value in frame {&frame-name}  = '4'.
        disable rs-tipo-sobra with frame {&frame-name}.
    end.
    else do:
        enable rs-tipo-sobra with frame {&frame-name}.
        apply 'entry' to rs-tipo-sobra in frame {&frame-name}.
        return no-apply.
    end.
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
  {utp/ut-rdset.i rs-tipo-sobra }
  {utp/ut-rtlbl.i mgind reservas tipo-sobra fill-in-1}.
  {utp/ut-rtlbl.i mgind reservas estado fill-in-2}.
  {utp/ut-liter.i Ajuste *}
  assign fi-ajuste:label in frame {&frame-name} = return-value.

  &IF DEFINED (bf_man_per_ppm) &THEN
    {utp/ut-field.i movind reservas qt-atend-lote 1}
    assign fi-qt-atend-lote:label in frame {&frame-name} = trim(return-value).
  &ENDIF

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

  {utp/ut-rtlbl.i mgind reservas tipo-sobra fill-in-1}.
  {utp/ut-rtlbl.i mgind reservas estado fill-in-2}.

  reservas.dt-reserva:screen-value = string (today).

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

  &IF DEFINED (bf_man_per_ppm) &THEN
    if param-global.modulo-per-ppm and
       input frame {&frame-name} reservas.quant-orig < 0 then do:

        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT this-procedure,
             INPUT "it-codigo":u).

        for first item fields (item.it-codigo item.tipo-formula) where
                  item.it-codigo = return-value: end.

        if avail item and
           item.tipo-formula >= 2 and
           item.tipo-formula <= 4 then do:
            run utp/ut-msgs.p (input "show",
                               input 27296,
                               input item.it-codigo + "~~" + 
                                     {ininc/i25in172.i 04 item.tipo-formula}).
            apply 'entry' to reservas.quant-orig in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.

    end.   
  &ENDIF

  assign rs-tipo-sobra = integer(rs-tipo-sobra:screen-value in frame {&frame-name}).
  if  rs-tipo-sobra = 4 and input frame {&frame-name} reservas.quant-orig < 0 then do:
       {utp/ut-liter.i Tipo_de_Sobra}
       run utp/ut-msgs.p (input "show", input 158,input return-value).                                            
       apply 'entry' to rs-tipo-sobra in frame {&frame-name}.
       return 'adm-error':U.
  end.  

  IF param-cp.log-integr-wms 
      AND NOT adm-new-record
      AND INPUT FRAME {&FRAME-NAME} reservas.quant-orig <> reservas.quant-orig THEN DO:

     RUN verificaDoctoProdReserva IN h-bosc038 (INPUT reservas.nr-ord-prod,
                                                INPUT reservas.it-codigo,
                                                INPUT reservas.cod-refer,
                                                OUTPUT l-item-req,
                                                OUTPUT l-altera-reserva).
     IF l-item-req = YES THEN DO:
        IF l-altera-reserva THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 57850,
                               INPUT c-traducao).
            IF RETURN-VALUE = "NO" THEN DO:
                RETURN "ADM-ERROR":U.        
            END.            
        END.
        ELSE DO:
            {utp/ut-liter.i Item_da_Reserva mcp l}
            ASSIGN c-traducao = RETURN-VALUE.
                        
            {utp/ut-liter.i integra‡Æo_com_WMS mcp l}
            ASSIGN c-traducao = c-traducao + "~~" + RETURN-VALUE.
            
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 34995,
                               INPUT c-traducao).
        
            RETURN 'ADM-ERROR':U.          
        END.
     END.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

 if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

 assign reservas.tipo-sobra = rs-tipo-sobra.

 /* Code placed here will execute AFTER standard behavior.    */  

 /* Elimina saldos de alocacao da ordem */      

 find first param-global no-lock no-error.

 if reservas.estado = 2 then do:

    if not valid-handle (h-cpapi013) then 
        run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
                                                      input        table tt-deposito,
                                                      input-output table tt-erro,
                                                      input        yes).

    run pi-desaloca-reserva in h-cpapi013 (input rowid(reservas)).

 end.                 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if valid-handle (h-cpapi013) then
    run pi-finalizar in h-cpapi013.

  IF VALID-HANDLE(h-bosc038) THEN
    DELETE PROCEDURE h-bosc038.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  if avail(reservas) and not(adm-new-record) then do:
     assign rs-tipo-sobra = reservas.tipo-sobra.
     disp   rs-tipo-sobra with frame {&frame-name}.
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

  run get-attribute ('adm-new-record').
  if return-value = "no" then do:
     assign rs-tipo-sobra:sensitive in frame {&frame-name} = if avail reservas and (reservas.quant-orig < 0) then yes
                                                             else no.                 

     RUN get-attribute IN adm-broker-hdl
        (INPUT "l-digitacao").
     if return-value = "no" then do:
        enable fi-ajuste with frame {&frame-name}.
        disable reservas.quant-orig with frame {&frame-name}.
        disable reservas.dt-reserva with frame {&frame-name}.
     end.
  end.


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
  FOR FIRST param-cp NO-LOCK:
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  assign fi-qt-atend-lote:visible in frame {&frame-name} = false.

  &IF DEFINED (bf_man_per_ppm) &THEN
    find first param-global no-lock.    
  &ENDIF
  
  IF param-cp.log-integr-wms
    AND NOT VALID-HANDLE(h-bosc038) THEN
        RUN scbo/bosc038.p PERSISTENT SET h-bosc038.  

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-unidade V-table-Win 
PROCEDURE pi-inicializa-unidade :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "it-codigo").

find item where
     item.it-codigo = return-value no-lock no-error.

if avail item then      
   assign reservas.un:screen-value in frame {&frame-name} = item.un.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-tipo-formula V-table-Win 
PROCEDURE pi-valida-tipo-formula :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED (bf_man_per_ppm) &THEN

  def var h-handle as handle no-undo.

  if param-global.modulo-per-ppm then do:

    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "it-codigo":u).

    for first item fields (item.tipo-formula) where
              item.it-codigo = return-value: end.

    case item.tipo-formula:
        when 1 or
        when 4 then
            assign reservas.quant-orig:row  in frame {&frame-name} = 1.25
                   h-handle                                        = reservas.quant-orig:side-label-handle
                   h-handle:row                                    = 1.25
                   fi-ajuste:row            in frame {&frame-name} = 2.33
                   h-handle                                        = fi-ajuste:side-label-handle
                   h-handle:row                                    = 2.33
                   reservas.quant-atend:row in frame {&frame-name} = 3.42
                   h-handle                                        = reservas.quant-atend:side-label-handle
                   h-handle:row                                    = 3.42
                   reservas.un:row          in frame {&frame-name} = 4.50
                   h-handle                                        = reservas.un:side-label-handle
                   h-handle:row                                    = 4.50
                   reservas.dt-reserva:row  in frame {&frame-name} = 5.58
                   h-handle                                        = reservas.dt-reserva:side-label-handle
                   h-handle:row                                    = 5.58
                   fi-qt-atend-lote:hidden  in frame {&frame-name} = true.
        when 2 or
        when 3 then
            assign reservas.quant-orig:row  in frame {&frame-name} = 1.25
                   h-handle                                        = reservas.quant-orig:side-label-handle
                   h-handle:row                                    = 1.25
                   fi-ajuste:row            in frame {&frame-name} = 2.25
                   h-handle                                        = fi-ajuste:side-label-handle
                   h-handle:row                                    = 2.25
                   reservas.quant-atend:row in frame {&frame-name} = 3.25
                   h-handle                                        = reservas.quant-atend:side-label-handle
                   h-handle:row                                    = 3.25
                   fi-qt-atend-lote:row     in frame {&frame-name} = 4.25
                   reservas.un:row          in frame {&frame-name} = 5.25
                   h-handle                                        = reservas.un:side-label-handle
                   h-handle:row                                    = 5.25
                   reservas.dt-reserva:row  in frame {&frame-name} = 6.25
                   h-handle                                        = reservas.dt-reserva:side-label-handle
                   h-handle:row                                    = 6.25
                   fi-qt-atend-lote:hidden  in frame {&frame-name} = false.
    end case.

    if item.tipo-formula <> 1 then
        assign reservas.quant-atend:sensitive in frame {&frame-name} = false
               fi-qt-atend-lote:sensitive     in frame {&frame-name} = false
               fi-qt-atend-lote:screen-value  in frame {&frame-name} = if avail reservas then string(reservas.qt-atend-lote)
                                                                                         else "0":u.
    else
        assign reservas.quant-atend:sensitive in frame {&frame-name} = true.

  end.

&ENDIF    

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

