&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V01IN200 2.00.00.015 } /*** 010015 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in200 MUT}
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

def new global shared var gr-lote-vend as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES lote-vend
&Scoped-define FIRST-EXTERNAL-TABLE lote-vend


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR lote-vend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS lote-vend.dt-nota lote-vend.qt-faturada 
&Scoped-define ENABLED-TABLES lote-vend
&Scoped-define FIRST-ENABLED-TABLE lote-vend
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS lote-vend.it-codigo lote-vend.lote ~
lote-vend.cod-refer lote-vend.nome-abrev lote-vend.nr-nota-fis ~
lote-vend.serie lote-vend.cod-estabel lote-vend.dt-nota ~
lote-vend.qt-faturada 
&Scoped-define DISPLAYED-TABLES lote-vend
&Scoped-define FIRST-DISPLAYED-TABLE lote-vend
&Scoped-Define DISPLAYED-OBJECTS c-nome-est c-descricao c-nome-emit 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS lote-vend.it-codigo lote-vend.lote ~
lote-vend.cod-refer lote-vend.nome-abrev lote-vend.nr-nota-fis ~
lote-vend.serie lote-vend.cod-estabel lote-vend.dt-nota ~
lote-vend.qt-faturada 
&Scoped-define ADM-ASSIGN-FIELDS lote-vend.dt-nota lote-vend.qt-faturada 
&Scoped-define ADM-MODIFY-FIELDS lote-vend.dt-nota lote-vend.qt-faturada 

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
     SIZE 36.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-est AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     lote-vend.it-codigo AT ROW 1.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     lote-vend.lote AT ROW 2.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 54.57 BY .88
     lote-vend.cod-refer AT ROW 3.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     lote-vend.nome-abrev AT ROW 4.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     lote-vend.nr-nota-fis AT ROW 5.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     lote-vend.serie AT ROW 6.17 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     lote-vend.cod-estabel AT ROW 7.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     lote-vend.dt-nota AT ROW 8.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     lote-vend.qt-faturada AT ROW 9.67 COL 29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     c-nome-est AT ROW 7.67 COL 37.86 COLON-ALIGNED NO-LABEL
     c-descricao AT ROW 1.17 COL 47 COLON-ALIGNED NO-LABEL
     c-nome-emit AT ROW 4.17 COL 46.43 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 7.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.lote-vend
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
         HEIGHT             = 9.88
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
   NOT-VISIBLE Size-to-Fit L-To-R,COLUMNS                               */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN lote-vend.cod-estabel IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-vend.cod-refer IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-vend.dt-nota IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lote-vend.it-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-vend.lote IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-vend.nome-abrev IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-vend.nr-nota-fis IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN lote-vend.qt-faturada IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN lote-vend.serie IN FRAME f-main
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

&Scoped-define SELF-NAME lote-vend.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.cod-estabel V-table-Win
ON F5 OF lote-vend.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "adzoom/z01ad107.w"
                  &tabela    = lote-vend
                  &atributo  = cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.cod-estabel V-table-Win
ON LEAVE OF lote-vend.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela                         = estabelec
                   &atributo-ref                   = nome
                   &variavel-ref                   = c-nome-est
                   &where = "estabelec.cod-estabel = input frame {&frame-name} 
                   lote-vend.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-vend.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-vend.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.it-codigo V-table-Win
ON F5 OF lote-vend.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "inzoom/z02in172.w"
                  &tabela    = lote-vend
                  &atributo  = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.it-codigo V-table-Win
ON LEAVE OF lote-vend.it-codigo IN FRAME f-main /* Item */
DO:
   find item
    where item.it-codigo = input frame {&frame-name} lote-vend.it-codigo 
                                                         no-lock no-error.
if  avail item then
    display item.desc-item @ c-descricao 
                                                 with frame {&frame-name}.
else
    display "" @ c-descricao with frame {&frame-name}.

if  avail item then do:
    if  item.tipo-con-est <> 4 then do:
        disp "" @ lote-vend.cod-refer with frame {&frame-name}.
        disable lote-vend.cod-refer with frame {&frame-name}.
    end.
    else       
        enable lote-vend.cod-refer with frame {&frame-name}.
    if adm-new-record = yes then do:
           apply 'leave' to lote-vend.lote.    
    end.       
end.    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-vend.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-vend.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.lote V-table-Win
ON LEAVE OF lote-vend.lote IN FRAME f-main /* Lote */
DO:

find item where item.it-codigo = input frame {&frame-name} lote-vend.it-codigo no-lock no-error.     
if avail item then do:
  if item.tipo-con-est = 4 then do:
     find first lote-vend
          where lote-vend.it-codigo = input frame {&frame-name} lote-vend.it-codigo
            and lote-vend.lote      = input frame {&frame-name} lote-vend.lote no-lock no-error.
     if avail lote-vend then do:
        display lote-vend.cod-refer with frame {&frame-name}.
        disable lote-vend.cod-refer with frame {&frame-name}.
     end.   
     else do:
        find first saldo-estoq use-index lote 
             where saldo-estoq.it-codigo = input frame {&frame-name} lote-vend.it-codigo
               and saldo-estoq.lote      = input frame {&frame-name} lote-vend.lote no-lock no-error.
        if avail saldo-estoq 
           then do:
               disp saldo-estoq.cod-refer @ lote-vend.cod-refer with frame {&frame-name}.
           end.    
           else do:
               enable lote-vend.cod-refer with frame {&frame-name}.  
           end.    
     end. 
  end.               
end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lote-vend.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.nome-abrev V-table-Win
ON F5 OF lote-vend.nome-abrev IN FRAME f-main /* Cliente */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom = "adzoom/z02ad098.w"
                  &tabela    = lote-vend
                  &atributo  = nome-abrev}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.nome-abrev V-table-Win
ON LEAVE OF lote-vend.nome-abrev IN FRAME f-main /* Cliente */
DO:
  {include/leave.i &tabela                         = emitente
                   &atributo-ref                   = nome-emit
                   &variavel-ref                   = c-nome-emit
                   &where = "emitente.nome-abrev = input frame {&frame-name} 
                   lote-vend.nome-abrev"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lote-vend.nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF lote-vend.nome-abrev IN FRAME f-main /* Cliente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  if lote-vend.nome-abrev:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if lote-vend.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if lote-vend.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.


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
  {src/adm/template/row-list.i "lote-vend"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "lote-vend"}

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


  {utp/ut-field.i mgind lote-vend it-codigo 1}
  find first item where item.it-codigo = input frame {&frame-name} lote-vend.it-codigo no-lock no-error.     
  if not avail item then do:    
     run utp/ut-msgs.p (input "show", input 47, input return-value).
     return 'adm-error'.
  end.   

  if item.tipo-con-est = 1 then do:
     run utp/ut-msgs.p (input "show", input 944, input "").
     return 'adm-error'.
  end.

  {utp/ut-field.i mgadm cliente cod-cliente 1}
  find first emitente where emitente.nome-abrev = input frame {&frame-name} lote-vend.nome-abrev 
       and emitente.identific <> 2 no-lock no-error.
  if not avail emitente then do:
     run utp/ut-msgs.p (input "show", input 47, input return-value).
     return 'adm-error'.
  end.

  {utp/ut-field.i mgind lote-vend cod-estabel 1}  
  find first estabelec where estabelec.cod-estabel = input frame {&frame-name} lote-vend.cod-estabel no-lock no-error.
  if not avail estabelec then do:
     run utp/ut-msgs.p (input "show", input 47, input return-value).
     return 'adm-error'.
  end.   

  if lote-vend.it-codigo:sensitive in frame {&frame-name} = no then do:
     find first lote-vend where
                lote-vend.it-codigo = input frame {&frame-name} lote-vend.it-codigo and
                lote-vend.lote      = input frame {&frame-name} lote-vend.lote no-lock no-error.
     if not avail lote-vend then do:
        run utp/ut-msgs.p (input "show", input 956, input "").
        return 'adm-error'.
     end.   
  end.


  find first lote-vend 
     where lote-vend.it-codigo   = input frame {&frame-name} lote-vend.it-codigo 
     and   lote-vend.lote        = input frame {&frame-name} lote-vend.lote 
     and   lote-vend.cod-refer   = input frame {&frame-name} lote-vend.cod-refer
     and   lote-vend.nome-abrev  = input frame {&frame-name} lote-vend.nome-abrev
     and   lote-vend.nr-nota-fis = input frame {&frame-name} lote-vend.nr-nota-fis
     and   lote-vend.serie       = input frame {&frame-name} lote-vend.serie    
     no-lock no-error.
  if avail lote-vend and adm-new-record = yes then do:
     run utp/ut-msgs.p (input "show",
                        input 7533, 
                        input "").
     return 'adm-error'.
  end.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
  FOR FIRST emitente FIELDS(cod-emitente) where emitente.nome-abrev = input frame {&frame-name} lote-vend.nome-abrev 
         and emitente.identific <> 2 no-lock :
      
      ASSIGN lote-vend.cod-emitente = emitente.cod-emitente .
  
  END.

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

  if available lote-vend then do:
     find emitente 
         where emitente.cod-emitente = lote-vend.cod-emitente 
                                                 no-lock no-error.
     assign c-nome-emit = if avail emitente then emitente.nome-emit else "":U.
  end.                                                    

  if available lote-vend then do:
     find estabelec where estabelec.cod-estabel = lote-vend.cod-estabel 
                                                  no-lock no-error.
     assign c-nome-est = if avail estabelec then estabelec.nome else "":U.
  end.                                                         

  if available lote-vend then do:
     find item where item.it-codigo = lote-vend.it-codigo
                                                 no-lock no-error.
     assign c-descricao = if avail item then 
                          item.desc-item else "":U.
  end.                                                         


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  if gr-lote-vend <> ?
   then find lote-vend where gr-lote-vend = rowid(lote-vend) no-lock no-error.

  
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

  if  avail lote-vend then
      assign gr-lote-vend = rowid(lote-vend).

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
  {src/adm/template/snd-list.i "lote-vend"}

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

