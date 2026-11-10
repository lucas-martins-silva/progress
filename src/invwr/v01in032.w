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
{include/i-prgvrs.i V01IN032 2.00.00.015}  /*** 010015 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN032 MUT}
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
def new global shared var gr-turno     as rowid no-undo.
def new global shared var gr-item      as rowid no-undo.
def new global shared var gr-lin-prod  as rowid no-undo.
def new global shared var gr-cap-turno as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-opcao as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES cap-turno
&Scoped-define FIRST-EXTERNAL-TABLE cap-turno


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cap-turno.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cap-turno.nr-unidades cap-turno.un-med-tempo ~
cap-turno.tempo-maquin cap-turno.eficiencia cap-turno.lote-multipl ~
cap-turno.uso-capacidade cap-turno.lote-minimo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nr-unidades ~{&FP2}nr-unidades ~{&FP3}~
 ~{&FP1}tempo-maquin ~{&FP2}tempo-maquin ~{&FP3}~
 ~{&FP1}eficiencia ~{&FP2}eficiencia ~{&FP3}~
 ~{&FP1}lote-multipl ~{&FP2}lote-multipl ~{&FP3}~
 ~{&FP1}lote-minimo ~{&FP2}lote-minimo ~{&FP3}
&Scoped-define ENABLED-TABLES cap-turno
&Scoped-define FIRST-ENABLED-TABLE cap-turno
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 RECT-2 
&Scoped-Define DISPLAYED-FIELDS cap-turno.cd-turno cap-turno.it-codigo ~
cap-turno.nr-linha cap-turno.nr-unidades cap-turno.un-med-tempo ~
cap-turno.tempo-maquin cap-turno.eficiencia cap-turno.lote-multipl ~
cap-turno.uso-capacidade cap-turno.lote-minimo 
&Scoped-Define DISPLAYED-OBJECTS f-desc1 F-desc2 F-un F-desc3 F-ret1 F-ret2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS cap-turno.cd-turno cap-turno.it-codigo ~
cap-turno.nr-linha 
&Scoped-define ADM-ASSIGN-FIELDS cap-turno.cd-turno cap-turno.it-codigo ~
cap-turno.nr-linha 

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
DEFINE VARIABLE f-desc1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE F-desc2 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE F-desc3 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE F-ret1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE F-ret2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE F-un AS CHARACTER FORMAT "X(256)":U 
     LABEL "Unidade Medida" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 1.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.29.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cap-turno.cd-turno AT ROW 1.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     f-desc1 AT ROW 1.25 COL 45 COLON-ALIGNED NO-LABEL
     cap-turno.it-codigo AT ROW 2.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     F-desc2 AT ROW 2.25 COL 45 COLON-ALIGNED NO-LABEL
     F-un AT ROW 3.17 COL 21 COLON-ALIGNED
     cap-turno.nr-linha AT ROW 4.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     F-desc3 AT ROW 4.25 COL 45 COLON-ALIGNED NO-LABEL
     cap-turno.nr-unidades AT ROW 5.83 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cap-turno.un-med-tempo AT ROW 6.5 COL 49 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Hora", 1,
"Minuto", 2,
"Segundo", 3
          SIZE 30 BY .79
     cap-turno.tempo-maquin AT ROW 7 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     cap-turno.eficiencia AT ROW 8.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     cap-turno.lote-multipl AT ROW 9.5 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     cap-turno.uso-capacidade AT ROW 9.5 COL 49 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Proporcional", 1,
"Total", 2
          SIZE 30 BY .79
     cap-turno.lote-minimo AT ROW 10.75 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     F-ret1 AT ROW 5.75 COL 46 COLON-ALIGNED NO-LABEL
     F-ret2 AT ROW 8.75 COL 46 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.25 COL 1
     RECT-1 AT ROW 6 COL 47
     RECT-2 AT ROW 9 COL 47
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.cap-turno
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
         HEIGHT             = 11
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

/* SETTINGS FOR FILL-IN cap-turno.cd-turno IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN f-desc1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-desc2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-desc3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ret1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-ret2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN F-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN cap-turno.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN cap-turno.nr-linha IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME cap-turno.cd-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.cd-turno V-table-Win
ON ENTRY OF cap-turno.cd-turno IN FRAME f-main /* Turno */
DO:
  {include/leave.i &tabela=turno
                   &atributo-ref=descri‡ao
                   &variavel-ref=f-desc1
                   &where="turno.cd-turno = input frame {&frame-name}
                           cap-turno.cd-turno"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.cd-turno V-table-Win
ON F5 OF cap-turno.cd-turno IN FRAME f-main /* Turno */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in440.w"
                  &tabela=cap-turno
                  &atributo=cd-turno}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.cd-turno V-table-Win
ON LEAVE OF cap-turno.cd-turno IN FRAME f-main /* Turno */
DO:
  {include/leave.i &tabela=turno
                   &atributo-ref=descri‡ao
                   &variavel-ref=f-desc1
                   &where="turno.cd-turno = input frame {&frame-name}
                           cap-turno.cd-turno"}
                           
  find turno where 
       turno.cd-turno = cap-turno.cd-turno
       no-lock no-error.
  if avail turno then 
     assign gr-turno = rowid(turno).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.cd-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cap-turno.cd-turno IN FRAME f-main /* Turno */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cap-turno.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.it-codigo V-table-Win
ON F5 OF cap-turno.it-codigo IN FRAME f-main /* Item */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                  &tabela=cap-turno
                  &atributo=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.it-codigo V-table-Win
ON LEAVE OF cap-turno.it-codigo IN FRAME f-main /* Item */
DO:                           
  find item where
       item.it-codigo = input frame {&frame-name} cap-turno.it-codigo                           
       no-lock no-error.
  if avail item then do:
     assign  gr-item = rowid(item)
             f-desc2 = item.desc-item
             f-un    = item.un .
     display f-desc2
             f-un
             with frame {&frame-name}.       
  end.           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cap-turno.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cap-turno.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.nr-linha V-table-Win
ON ENTRY OF cap-turno.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
  {include/leave.i &tabela=lin-prod
                   &atributo-ref=descri‡ao
                   &variavel-ref=f-desc3
                   &where="lin-prod.nr-linha = input frame {&frame-name}
                           cap-turno.nr-linha"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.nr-linha V-table-Win
ON F5 OF cap-turno.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in186.w"
                  &tabela=cap-turno
                  &atributo=nr-linha}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.nr-linha V-table-Win
ON LEAVE OF cap-turno.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
  {include/leave.i &tabela=lin-prod
                   &atributo-ref=descri‡ao
                   &variavel-ref=f-desc3
                   &where="lin-prod.nr-linha = input frame {&frame-name}
                           cap-turno.nr-linha"}
                           
   find lin-prod where
        lin-prod.nr-linha = cap-turno.nr-linha
        no-lock no-error.
   if avail lin-prod then
      assign gr-lin-prod = rowid(lin-prod).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cap-turno.nr-linha V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cap-turno.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
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
  
  /************************ INTERNAL PROCEDURES ********************/

if cap-turno.cd-turno:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cap-turno.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if cap-turno.nr-linha:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "cap-turno"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cap-turno"}

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
       
  {utp/ut-rtlbl.i mgind cap-turno un-med-tempo f-ret1}
  {utp/ut-rtlbl.i mgind cap-turno uso-capacidade f-ret2}

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
  /* Ponha na pi-validate todas as valida‡äes */
  
  find turno where turno.cd-turno = input frame {&frame-name} cap-turno.cd-turno no-lock no-error.
  if not avail turno then do:
      {utp/ut-table.i mgind turno 1}
      run utp/ut-msgs.p (input "show",
                         input 56,
                         input return-value).
      apply "entry" to mgind.cap-turno.cd-turno in frame {&frame-name}. 
      return "adm-error".
  end.  
  
  find item where item.it-codigo = input frame {&frame-name} cap-turno.it-codigo no-lock no-error.
  if not avail item then do:
     {utp/ut-table.i mgind item 1}
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     apply "entry" to mgind.cap-turno.it-codigo in frame {&frame-name}.  
     return "adm-error".
  end.  
  
  find lin-prod where lin-prod.nr-linha = input frame {&frame-name} cap-turno.nr-linha no-lock no-error.
  if not avail lin-prod then do:
      {utp/ut-table.i mgind lin-prod 1}
      run utp/ut-msgs.p (input "show",
                         input 56,
                         input return-value).
      apply "entry" to mgind.cap-turno.nr-linha in frame {&frame-name}. 
      return "adm-error".
  end.  

  IF  cap-turno.cd-turno:SENSITIVE IN FRAME {&frame-name} THEN DO:
      find cap-turno where
          cap-turno.cd-turno  = input frame {&frame-name} cap-turno.cd-turno and
          cap-turno.it-codigo = input frame {&frame-name} cap-turno.it-codigo and 
          cap-turno.nr-linha  = input frame {&frame-name} cap-turno.nr-linha 
          no-lock no-error.
      if avail cap-turno then do:
         run utp/ut-msgs.p (input "show",
                            input 6279,
                            input string(cap-turno.cd-turno)  + "~~" +
                                  string(cap-turno.it-codigo) + "~~" +
                                  string(cap-turno.nr-linha)).
         return 'ADM-ERROR':U.
      end.    
  END.    
  
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  
  /* Code placed here will execute AFTER standard behavior.    */
         
     assign c-opcao = " ".

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
   
   find turno where turno.cd-turno =  cap-turno.cd-turno no-lock no-error.
    if avail turno then 
        assign f-desc1 = turno.descricao.
    else assign f-desc1 = " ".
    
   find item where item.it-codigo = cap-turno.it-codigo no-lock no-error.
    if avail item then do:
        assign f-desc2 = item.desc-item.
        assign f-un = item.un.
    end.
    else assign f-desc2 = " "
                f-un = " ".
        
   find lin-prod where lin-prod.nr-linha =  cap-turno.nr-linha no-lock no-error.
    if avail lin-prod then
        assign f-desc3 = lin-prod.descricao.
    else assign f-desc3 = " ".  
        
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    {utp/ut-rtlbl.i mgind cap-turno un-med-tempo f-ret1}
    {utp/ut-rtlbl.i mgind cap-turno uso-capacidade f-ret2}
    
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
  
    {utp/ut-rtlbl.i mgind cap-turno un-med-tempo f-ret1}
    {utp/ut-rtlbl.i mgind cap-turno uso-capacidade f-ret2}    
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  
  if avail cap-turno then
     assign gr-cap-turno = rowid(cap-turno).

  find turno where 
       turno.cd-turno = cap-turno.cd-turno
       no-lock no-error.
  if avail turno then 
     assign gr-turno = rowid(turno).

  find item where
       item.it-codigo = cap-turno.it-codigo                           
       no-lock no-error.
  if avail item then 
     assign gr-item = rowid(item). 
                           
   find lin-prod where
        lin-prod.nr-linha = cap-turno.nr-linha
        no-lock no-error.
   if avail lin-prod then
      assign gr-lin-prod = rowid(lin-prod).
      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   
  /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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
  {src/adm/template/snd-list.i "cap-turno"}

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


