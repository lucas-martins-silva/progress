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
{include/i-prgvrs.i V01AD272 2.00.00.014}  /*** 040014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD272 MUT}
&ENDIF


/* y2kready */

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
define new global shared var v-row-parent as rowid no-undo.
define var c-label as character no-undo.
define var l-aux as logical no-undo.

def var de-cotacao as decimal.
def var de-vl-mo-aquis like bem-moeda.vl-mo-aquis no-undo.
def var de-nr-mo-aquis like bem-moeda.nr-mo-aquis.
def var i-per-mo   like bem.per-depr-mo.
def var i-per      like bem.per-depr-ano.
def var i-dias     as integer.
def var c-per-ano  like movto-bem.per-ano no-undo.
def var l-resp-patrim as char no-undo.
def var l-moeda-patrim like moeda-empresa.patrimonio init no.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES moeda-empresa
&Scoped-define FIRST-EXTERNAL-TABLE moeda-empresa


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR moeda-empresa.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS moeda-empresa.contabil moeda-empresa.tipo-uso ~
moeda-empresa.consulta-cb moeda-empresa.patrimonio moeda-empresa.log-1 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES moeda-empresa
&Scoped-define FIRST-ENABLED-TABLE moeda-empresa
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 
&Scoped-Define DISPLAYED-FIELDS moeda-empresa.mo-codigo ~
moeda-empresa.contabil moeda-empresa.tipo-uso moeda-empresa.consulta-cb ~
moeda-empresa.patrimonio moeda-empresa.log-1 
&Scoped-Define DISPLAYED-OBJECTS c-moeda 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS moeda-empresa.mo-codigo 
&Scoped-define ADM-MODIFY-FIELDS moeda-empresa.contabil ~
moeda-empresa.consulta-cb moeda-empresa.patrimonio 

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
DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(40)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .67 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .5 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28 BY 3.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     moeda-empresa.mo-codigo AT ROW 1.21 COL 35 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-moeda AT ROW 1.21 COL 39.57 COLON-ALIGNED NO-LABEL
     moeda-empresa.contabil AT ROW 3 COL 3.29
          VIEW-AS TOGGLE-BOX
          SIZE 27.86 BY .75
     moeda-empresa.tipo-uso AT ROW 3.42 COL 57 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Di rio", 1,
"M‚dio", 2,
"Mensal", 3
          SIZE 10.57 BY 2.29
     moeda-empresa.consulta-cb AT ROW 4 COL 3.29
          VIEW-AS TOGGLE-BOX
          SIZE 30 BY .75
     moeda-empresa.patrimonio AT ROW 4.83 COL 3.29
          VIEW-AS TOGGLE-BOX
          SIZE 24.72 BY .75
     moeda-empresa.log-1 AT ROW 5.71 COL 3.29
          LABEL "Utilizada BI"
          VIEW-AS TOGGLE-BOX
          SIZE 21.57 BY .83 TOOLTIP "Moeda ‚ utilizada para exportacao de dados para o BI"
     FILL-IN-2 AT ROW 2.75 COL 55 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 3.75 COL 32 COLON-ALIGNED NO-LABEL BLANK 
     rt-key AT ROW 1.04 COL 1
     rt-mold AT ROW 2.54 COL 1
     RECT-1 AT ROW 2.96 COL 55.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.moeda-empresa
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 5.75
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

/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX moeda-empresa.consulta-cb IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX moeda-empresa.contabil IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN FILL-IN-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN FILL-IN-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX moeda-empresa.log-1 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN moeda-empresa.mo-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX moeda-empresa.patrimonio IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME moeda-empresa.contabil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda-empresa.contabil V-table-Win
ON VALUE-CHANGED OF moeda-empresa.contabil IN FRAME f-main /* Utilizada Contabilidade */
DO:
  assign l-aux = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moeda-empresa.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda-empresa.mo-codigo V-table-Win
ON F5 OF moeda-empresa.mo-codigo IN FRAME f-main /* Moeda */
DO:
   assign l-implanta = yes. 
   {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                     &campo=moeda-empresa.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda-empresa.mo-codigo V-table-Win
ON LEAVE OF moeda-empresa.mo-codigo IN FRAME f-main /* Moeda */
DO:
   {include/leave.i &tabela=moeda
                 &atributo-ref=descricao
                 &variavel-ref=c-moeda
                 &where="moeda.mo-codigo =  input frame {&frame-name} moeda-empresa.mo-codigo"}

   if input frame {&frame-name} moeda-empresa.mo-codigo = 0 then
      assign moeda-empresa.log-1:checked in frame {&frame-name} = yes
             moeda-empresa.log-1:sensitive in frame {&frame-name} = no.
   else
      assign moeda-empresa.log-1:sensitive in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda-empresa.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF moeda-empresa.mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME moeda-empresa.patrimonio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL moeda-empresa.patrimonio V-table-Win
ON VALUE-CHANGED OF moeda-empresa.patrimonio IN FRAME f-main /* Utilizada Patrim“nio */
DO:
  if  input frame {&frame-name} moeda-empresa.patrimonio = yes then
      moeda-empresa.tipo-uso:sensitive in frame {&frame-name} = yes.
  else
      moeda-empresa.tipo-uso:sensitive in frame {&frame-name} = no.

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

  {utp/ut-rtlbl.i mgadm moeda-empresa tipo-uso fill-in-1}
  {utp/ut-liter.i "Patrim." MPT R}
  assign fill-in-2:screen-value in frame {&frame-name} = fill-in-1 + " " + return-value.

  if moeda-empresa.mo-codigo:load-mouse-pointer ('image/lupa.cur') in frame {&frame-name} then.

  assign l-aux = no.

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
  {src/adm/template/row-list.i "moeda-empresa"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "moeda-empresa"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  if  available moeda-empresa then do:
      find moeda where moeda.mo-codigo = input frame {&frame-name} moeda-empresa.mo-codigo no-lock no-error.
      assign c-moeda:screen-value in frame {&frame-name} = if  avail moeda then moeda.descricao
                                                           else "":U.
      assign l-moeda-patrim = moeda-empresa.patrimonio. 
  end. 

  {utp/ut-rtlbl.i mgadm moeda-empresa tipo-uso fill-in-1}
  {utp/ut-liter.i "Patrim“nio" MPT R}
  assign fill-in-2:screen-value in frame {&frame-name} = fill-in-1 + " " + return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if input frame {&frame-name} moeda-empresa.patrimonio = "" then 
      assign moeda-empresa.tipo-uso:sensitive in frame {&frame-name} = no.
  else
     if input frame {&frame-name} moeda-empresa.patrimonio = yes then
         assign moeda-empresa.tipo-uso:sensitive in frame {&frame-name} = yes.
     else
         assign moeda-empresa.tipo-uso:sensitive in frame {&frame-name} = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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

  if  input frame {&frame-name} moeda-empresa.patrimonio = no 
  and l-moeda-patrim = yes then do:
      run utp/ut-msgs.p (input "show":U,
                         input 16346,
                         input return-value).
      assign l-resp-patrim = return-value.                   

      if  l-resp-patrim = "yes" then do:
          for each bem-moeda
              where bem-moeda.ep-codigo = i-ep-codigo-usuario
              and   bem-moeda.mo-codigo = input frame {&frame-name} moeda-empresa.mo-codigo:
                  delete bem-moeda.
          end.
      end.    
      else
          assign moeda-empresa.patrimonio:checked in frame {&frame-name} = yes.
  end.
  else do:
      if  input frame {&frame-name} moeda-empresa.patrimonio = yes 
      and l-moeda-patrim = no then do:
          run utp/ut-msgs.p (input "show":U,
                             input 16414,
                             input return-value). 
      end.
  end.


  find moeda 
       where moeda.mo-codigo = input frame {&frame-name} moeda-empresa.mo-codigo no-lock no-error.
  if  not avail moeda then do:
      {utp/ut-field.i mgadm moeda-empresa mo-codigo 1}
      run utp/ut-msgs.p (input "show":U,
                         input 47,
                         input return-value).
      return 'adm-error'.    
  end.   

  find mgadm.moeda-empresa
       where moeda-empresa.ep-codigo = i-ep-codigo-usuario and
             moeda-empresa.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo
       no-lock no-error.

  {utp/ut-field.i mgadm moeda-empresa mo-codigo 1}
  c-label = return-value.
  {utp/ut-field.i mguni empresa ep-codigo 1}

  if  moeda-empresa.mo-codigo:sensitive then do:

      if  input frame {&frame-name} moeda-empresa.mo-codigo = 0 THEN DO:
          run utp/ut-msgs.p (input "show":U,
                             input 30534,
                             input return-value).
          return 'adm-error'.
      END.

      if  avail moeda-empresa then do:
          run utp/ut-msgs.p (input "show":U,
                             input 428,
                             input c-label + "~~" + return-value).
          return 'adm-error'.       
      end.
      else if  input moeda-empresa.contabil then do:          
               find first moeda-conv where moeda-conv.ep-codigo = i-ep-codigo-usuario and
                                           moeda-conv.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo
                                           no-lock no-error.
               if  not avail moeda-conv then do:
                   for  each ano-fiscal where ano-fiscal.ep-codigo = i-ep-codigo-usuario:
                        create moeda-conv.
                        assign moeda-conv.ep-codigo = i-ep-codigo-usuario
                               moeda-conv.ano-fiscal = ano-fiscal.ano-fiscal
                               moeda-conv.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo
                               moeda-conv.convertido = no.
                   end.
               end. 
      end.          
  end.       
  else do:
    if  input frame {&frame-name} moeda-empresa.contabil = yes and 
        input frame {&frame-name} moeda-empresa.contabil entered then do:
        find first moeda-conv where moeda-conv.ep-codigo = i-ep-codigo-usuario and
                   moeda-conv.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo
                   no-lock no-error.
        if  not avail moeda-conv then                       
            for  each ano-fiscal where ano-fiscal.ep-codigo = i-ep-codigo-usuario:
                 create moeda-conv.
                 assign moeda-conv.ep-codigo = i-ep-codigo-usuario
                        moeda-conv.ano-fiscal = ano-fiscal.ano-fiscal
                        moeda-conv.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo
                        moeda-conv.convertido = no.
             end.
    end.
    if  input frame {&frame-name} moeda-empresa.contabil = no and 
        input frame {&frame-name} moeda-empresa.contabil entered AND moeda-empresa.mo-codigo <> 0 then do:    
        run utp/ut-msgs.p (input 'show', input 451, input '').
        if  return-value = "yes":U then do:
            for  each saldo-conta where saldo-conta.ep-codigo = i-ep-codigo-usuario and
                      saldo-conta.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo:
                 delete saldo-conta.
            end.
            for  each moeda-conv where moeda-conv.ep-codigo = i-ep-codigo-usuario and
                      moeda-conv.mo-codigo = input frame {&frame-name} mgadm.moeda-empresa.mo-codigo:
                 delete moeda-conv.              
            end.
         end.                                                                 
    end.      
  end. 

  if  input moeda-empresa.mo-codigo = "" then do:
      run utp/ut-msgs.p ("show", 7883, "").
      apply 'entry':U to moeda-empresa.mo-codigo in frame {&frame-name}.   
      return 'ADM-ERROR':U.
  end.

  if  input c-moeda = "" then do:
      run utp/ut-msgs.p ("show", 7884, "").
      apply 'entry':U to c-moeda in frame {&frame-name}.   
      return 'ADM-ERROR':U.
  end.     

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  find empresa  where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.
  if  available empresa  then 
     assign moeda-empresa.ep-codigo = empresa.ep-codigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {utp/ut-rtlbl.i mgadm moeda-empresa tipo-uso fill-in-1}
  {utp/ut-liter.i "Patrim“nio" MPT R}
  assign fill-in-2:screen-value in frame {&frame-name} = fill-in-1 + " " + return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgadm moeda-empresa tipo-uso fill-in-1}
  {utp/ut-liter.i "Patrim“nio" MPT R}
  assign fill-in-2:screen-value in frame {&frame-name} = fill-in-1 + " " + return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

 for  each bem
      where bem.ep-codigo = param-patrim.ep-codigo no-lock:
      find first bem-moeda
           where bem-moeda.ep-codigo = bem.ep-codigo
             and bem-moeda.bm-codigo = bem.bm-codigo
             and bem-moeda.bm-indice = bem.bm-indice
             and bem-moeda.mo-codigo = moeda-empresa.mo-codigo
             EXCLUSIVE-LOCK no-error.

      if  avail bem-moeda then 
          delete bem-moeda.
  end.    

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if available moeda-empresa then 
  do:
     find moeda where moeda.mo-codigo = input frame {&frame-name} moeda-empresa.mo-codigo no-lock no-error.
     assign c-moeda:screen-value in frame {&frame-name} = if avail moeda then moeda.descricao
                                     else "":U.
     assign l-moeda-patrim = moeda-empresa.patrimonio.    
  end.     

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-rtlbl.i mgadm moeda-empresa tipo-uso fill-in-1}
  {utp/ut-liter.i "Patrim“nio" MPT R}
  assign fill-in-2:screen-value in frame {&frame-name} = fill-in-1 + " " + return-value.

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
  apply 'leave':U to moeda-empresa.mo-codigo in frame {&frame-name}.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var h-prog as handle no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

/*  if  input frame {&frame-name} moeda-empresa.patrimonio = yes 
 *   and l-moeda-patrim = no then do:
 *       run ptp/pt0512.w persistent set h-prog.
 *       run pi-parametro in h-prog (moeda-empresa.mo-codigo).
 *       run dispatch in h-prog ('initialize').
 *       /*delete procedure h-prog.*/
 *   end.    */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign l-moeda-patrim = moeda-empresa.patrimonio.
  assign moeda-empresa.tipo-uso:sensitive in frame {&frame-name} = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  find first param-patrim where param-patrim.ep-codigo = i-ep-codigo-usuario no-lock no-error.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

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
  {src/adm/template/snd-list.i "moeda-empresa"}

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


