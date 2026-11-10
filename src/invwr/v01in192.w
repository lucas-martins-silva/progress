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
{include/i-prgvrs.i V01IN192 2.00.00.015 } /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN192 MUT}
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

/* Local Variable Definitions ---                                       */

def new global shared var gr-lote-compr as rowid no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES lote-compr
&Scoped-define FIRST-EXTERNAL-TABLE lote-compr


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lote-compr.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lote-compr.dt-recebimento ~
lote-compr.qtd-recebida 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}dt-recebimento ~{&FP2}dt-recebimento ~{&FP3}~
 ~{&FP1}qtd-recebida ~{&FP2}qtd-recebida ~{&FP3}
&Scoped-define ENABLED-TABLES lote-compr
&Scoped-define FIRST-ENABLED-TABLE lote-compr
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS lote-compr.it-codigo lote-compr.lote ~
lote-compr.cod-refer lote-compr.cod-emitente lote-compr.nr-nota-fis ~
lote-compr.serie-nf lote-compr.cod-estabel lote-compr.dt-recebimento ~
lote-compr.qtd-recebida 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-nome-emit c-nome-est 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lote-compr.it-codigo lote-compr.lote ~
lote-compr.cod-refer lote-compr.cod-emitente lote-compr.nr-nota-fis ~
lote-compr.serie-nf lote-compr.cod-estabel lote-compr.dt-recebimento ~
lote-compr.qtd-recebida 
&Scoped-define ADM-ASSIGN-FIELDS lote-compr.dt-recebimento ~
lote-compr.qtd-recebida 
&Scoped-define ADM-MODIFY-FIELDS lote-compr.dt-recebimento ~
lote-compr.qtd-recebida 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-est AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 46.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     lote-compr.it-codigo AT ROW 1.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 1.17 COL 47.57 COLON-ALIGNED NO-LABEL
     lote-compr.lote AT ROW 2.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45.43 BY .88
     lote-compr.cod-refer AT ROW 3.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     lote-compr.cod-emitente AT ROW 4.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-nome-emit AT ROW 4.17 COL 42 COLON-ALIGNED NO-LABEL
     lote-compr.nr-nota-fis AT ROW 5.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     lote-compr.serie-nf AT ROW 6.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     lote-compr.cod-estabel AT ROW 7.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-nome-est AT ROW 7.67 COL 37.29 COLON-ALIGNED NO-LABEL
     lote-compr.dt-recebimento AT ROW 8.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     lote-compr.qtd-recebida AT ROW 9.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 7.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.lote-compr
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
         HEIGHT             = 9.88
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lote-compr.cod-emitente IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-compr.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-compr.cod-refer IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-compr.dt-recebimento IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lote-compr.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-compr.lote IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-compr.nr-nota-fis IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-compr.qtd-recebida IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lote-compr.serie-nf IN FRAME f-main
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

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME lote-compr.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.cod-emitente V-table-Win
ON F5 OF lote-compr.cod-emitente IN FRAME f-main /* Emitente */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "adzoom/z01ad098.w"
                  &tabela    = lote-compr
                  &atributo  = cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.cod-emitente V-table-Win
ON LEAVE OF lote-compr.cod-emitente IN FRAME f-main /* Emitente */
DO:
  {include/leave.i &tabela                         = emitente
                   &atributo-ref                   = nome-emit
                   &variavel-ref                   = c-nome-emit
                   &where = "emitente.cod-emitente = input frame {&frame-name} 
                   lote-compr.cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-compr.cod-emitente IN FRAME f-main /* Emitente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-compr.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.cod-estabel V-table-Win
ON F5 OF lote-compr.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes.  
  {include/zoom.i &prog-zoom = "adzoom/z01ad107.w"
                  &tabela    = lote-compr
                  &atributo  = cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.cod-estabel V-table-Win
ON LEAVE OF lote-compr.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela                         = estabelec
                   &atributo-ref                   = nome
                   &variavel-ref                   = c-nome-est
                   &where = "estabelec.cod-estabel = input frame {&frame-name} 
                   lote-compr.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-compr.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-compr.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.it-codigo V-table-Win
ON F5 OF lote-compr.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "inzoom/z02in172.w"
                  &tabela    = lote-compr
                  &atributo  = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.it-codigo V-table-Win
ON LEAVE OF lote-compr.it-codigo IN FRAME f-main /* Item */
DO:
   find item
    where item.it-codigo = input frame {&frame-name} lote-compr.it-codigo 
                                                         no-lock no-error.
if  avail item then
    display item.desc-item @ c-descricao 
                                                 with frame {&frame-name}.
else
    display "" @ c-descricao with frame {&frame-name}.
    
if  avail item then do:
    if  item.tipo-con-est <> 4 then do:
        disp "" @ lote-compr.cod-refer with frame {&frame-name}.
        disable lote-compr.cod-refer with frame {&frame-name}.
    end.
    else enable lote-compr.cod-refer with frame {&frame-name}.
    if adm-new-record = yes then apply 'leave' to lote-compr.lote.
    
end.
            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-compr.it-codigo IN FRAME f-main /* Item */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-compr.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-compr.lote V-table-Win
ON LEAVE OF lote-compr.lote IN FRAME f-main /* Lote */
DO:
find item where item.it-codigo = input frame {&frame-name} lote-compr.it-codigo no-lock no-error.     
if avail item then do:
  if item.tipo-con-est = 4 then do:
     find first lote-compr
          where lote-compr.it-codigo = input frame {&frame-name} lote-compr.it-codigo
            and lote-compr.lote      = input frame {&frame-name} lote-compr.lote no-lock no-error.
     if avail lote-compr then do:
        display lote-compr.cod-refer with frame {&frame-name}.
        disable lote-compr.cod-refer with frame {&frame-name}.
     end.   
     else do:
        find first saldo-estoq use-index lote 
             where saldo-estoq.it-codigo = input frame {&frame-name} lote-compr.it-codigo
               and saldo-estoq.lote      = input frame {&frame-name} lote-compr.lote no-lock no-error.
        if avail saldo-estoq 
           then disp saldo-estoq.cod-refer @ lote-compr.cod-refer with frame {&frame-name}.
           else enable lote-compr.cod-refer with frame {&frame-name}.  
     end. 
  end.               
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
  
  if lote-compr.cod-emitente:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if lote-compr.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if lote-compr.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  
  disable lote-compr.cod-refer with frame {&frame-name}.
  
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
  {src/adm/template/row-list.i "lote-compr"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lote-compr"}

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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
 
  {utp/ut-field.i mgind lote-compr it-codigo 1}
  find item where item.it-codigo = input frame {&frame-name} lote-compr.it-codigo no-lock no-error.     
  if not avail item then do:    
     run utp/ut-msgs.p (input "show", input 47, input return-value).
     return 'adm-error'.
  end.   
  
  if item.tipo-con-est = 1 then do:
     run utp/ut-msgs.p (input "show", input 944, input "").
     return 'adm-error'.
  end. 

  
  {utp/ut-field.i mgadm fornecedor cod-fornec 1}
  find first emitente where emitente.cod-emitente = input frame {&frame-name} lote-compr.cod-emitente 
       and emitente.identific <> 1 no-lock no-error.
  if not avail emitente then do:
     run utp/ut-msgs.p (input "show", input 47, input return-value).
     return 'adm-error'.
  end.     
  
  {utp/ut-field.i mgind lote-compr cod-estabel 1}  
  find first estabelec where estabelec.cod-estabel = input frame {&frame-name} lote-compr.cod-estabel no-lock no-error.
  if not avail estabelec then do:
     run utp/ut-msgs.p (input "show", input 47, input return-value).
     return 'adm-error'.
  end.   
 
  if lote-compr.it-codigo:sensitive in frame {&frame-name} = no then do:
     find first lote-compr where
                lote-compr.it-codigo = input frame {&frame-name} lote-compr.it-codigo and
                lote-compr.lote      = input frame {&frame-name} lote-compr.lote no-lock no-error.
     if not avail lote-compr then do:
        run utp/ut-msgs.p (input "show", input 956, input "").
        return 'adm-error'.
     end.   
  end. 
  
  if ADM-NEW-RECORD then do:
      find first lote-compr no-lock 
          where lote-compr.it-codigo    = input frame {&frame-name} lote-compr.it-codigo 
            and lote-compr.lote         = input frame {&frame-name} lote-compr.lote 
            and lote-compr.cod-refer    = input frame {&frame-name} lote-compr.cod-refer 
            and lote-compr.cod-emitente = input frame {&frame-name} lote-compr.cod-emitente 
            and lote-compr.nr-nota-fis  = input frame {&frame-name} lote-compr.nr-nota-fis 
            and lote-compr.serie-nf     = input frame {&frame-name} lote-compr.serie-nf no-error.
      if avail lote-compr then do:
          run utp/ut-msgs.p (input "show", 
                             input 7539, 
                             input "").
          return 'adm-error'.
      end.
  end.
  else do:
      find first rat-lote  no-lock
          where rat-lote.serie-docto  = input frame {&frame-name} lote-compr.serie-nf     
            and rat-lote.nro-docto    = input frame {&frame-name} lote-compr.nr-nota-fis  
            and rat-lote.cod-emitente = input frame {&frame-name} lote-compr.cod-emitente    
            and rat-lote.it-codigo    = input frame {&frame-name} lote-compr.it-codigo    
            and rat-lote.lote         = input frame {&frame-name} lote-compr.lote no-error.
      if avail rat-lote then do:
          run utp/ut-msgs.p (input "show", 
                             input 33209, 
                             input "").
          return 'adm-error'.
      end.
  end.

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
  
  if available lote-compr then do:
     find emitente where emitente.cod-emitente = lote-compr.cod-emitente 
                                                 no-lock no-error.
     assign c-nome-emit = if avail emitente then emitente.nome-emit else "":U.
  end.                                                    
                                                  
  if available lote-compr then do:
     find estabelec where estabelec.cod-estabel = lote-compr.cod-estabel 
                                                  no-lock no-error.
     assign c-nome-est = if avail estabelec then estabelec.nome else "":U.
  end.                                                         
  
  if available lote-compr then do:
     find item where item.it-codigo = lote-compr.it-codigo
                                                 no-lock no-error.
     assign c-descricao = if avail item then 
                          item.desc-item else "":U.
  end.                                                         

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if input frame {&frame-name} lote-compr.cod-emitente = 0 then do:
     assign c-nome-emit = " ".
     disp c-nome-emit with frame {&frame-name}.
  end.   

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
  
  if avail lote-compr then
     assign gr-lote-compr = rowid(lote-compr).

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
  {src/adm/template/snd-list.i "lote-compr"}

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


