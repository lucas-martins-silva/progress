&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V04IN042 2.00.00.013 } /*** "010013" ***/
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
def new global shared var gr-pl-carga-maq as rowid no-undo.
def new global shared var gr-centro-custo as rowid no-undo.
def new global shared var gr-periodo      as rowid no-undo.

/* Local Variable Definitions ---                                       */

def buffer b-pl-carga-maq for pl-carga-maq.
def buffer b-gm-estab for gm-estab. /* Ativ. 155845 */
{cdp/cdcfgman.i}

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
&Scoped-define EXTERNAL-TABLES gm-estab centro-custo pl-carga-maq
&Scoped-define FIRST-EXTERNAL-TABLE gm-estab /* Ativ. 155845 */


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gm-estab, centro-custo, pl-carga-maq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS centro-custo.cc-codigo centro-custo.descricao 
&Scoped-define ENABLED-TABLES centro-custo
&Scoped-define FIRST-ENABLED-TABLE centro-custo
&Scoped-define DISPLAYED-TABLES centro-custo pl-carga-maq
&Scoped-define FIRST-DISPLAYED-TABLE centro-custo
&Scoped-define SECOND-DISPLAYED-TABLE pl-carga-maq
&Scoped-Define ENABLED-OBJECTS RECT-14 RECT-15 
&Scoped-Define DISPLAYED-FIELDS centro-custo.cc-codigo ~
centro-custo.descricao pl-carga-maq.periodo pl-carga-maq.ano 
&Scoped-Define DISPLAYED-OBJECTS de-hor-prep de-hor-men de-hor-maqn c-horas 

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
DEFINE VARIABLE c-horas AS CHARACTER FORMAT "X(256)":U INITIAL "Total Horas" 
      VIEW-AS TEXT 
     SIZE 9.14 BY .63 NO-UNDO.

DEFINE VARIABLE de-hor-maqn AS DECIMAL FORMAT ">>>>>>9.999":U INITIAL 0 
     LABEL "M†quina" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-hor-men AS DECIMAL FORMAT ">>>>>>9.999":U INITIAL 0 
     LABEL "Homen" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE de-hor-prep AS DECIMAL FORMAT ">>>>>>9.999":U INITIAL 0 
     LABEL "Preparaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-plano AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Plano" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabel":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-plano AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 42.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.33.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     centro-custo.cc-codigo AT ROW 1.17 COL 16.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     centro-custo.descricao AT ROW 1.17 COL 29.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 35.43 BY .88
     pl-carga-maq.periodo AT ROW 1.17 COL 75.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     pl-carga-maq.ano AT ROW 1.17 COL 81 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     fi-cd-plano AT ROW 2.17 COL 16.72 COLON-ALIGNED
     fi-desc-plano AT ROW 2.17 COL 22.29 COLON-ALIGNED NO-LABEL
     fi-cod-estabel AT ROW 2.17 COL 75.57 COLON-ALIGNED
          LABEL "Estabel":R7
     de-hor-prep AT ROW 3.29 COL 12.43 COLON-ALIGNED
     de-hor-men AT ROW 3.29 COL 42 COLON-ALIGNED
     de-hor-maqn AT ROW 3.29 COL 74 COLON-ALIGNED
     c-horas AT ROW 2.42 COL 2.72 NO-LABEL
     RECT-14 AT ROW 1 COL 1
     RECT-15 AT ROW 2.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.gm-estab,mgcad.centro-custo,mgcad.pl-carga-maq
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
         HEIGHT             = 3.88
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN pl-carga-maq.ano IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-horas IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-hor-maqn IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-hor-men IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-hor-prep IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cd-plano IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-cd-plano:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME F-Main
   NO-DISPLAY NO-ENABLE LIKE = mgcad.estabelec.cod-estabel EXP-LABEL    */
ASSIGN 
       fi-cod-estabel:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN fi-desc-plano IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-desc-plano:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN pl-carga-maq.periodo IN FRAME F-Main
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
  {src/adm/template/row-list.i "gm-estab"}
  {src/adm/template/row-list.i "centro-custo"}
  {src/adm/template/row-list.i "pl-carga-maq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gm-estab"}
  {src/adm/template/row-find.i "centro-custo"}
  {src/adm/template/row-find.i "pl-carga-maq"}

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

  if avail pl-carga-maq then 
     assign gr-pl-carga-maq = rowid(pl-carga-maq).
     
  

  if avail centro-custo then
     assign gr-centro-custo = rowid(centro-custo).

  find first pl-prod where 
       pl-prod.pl-estado = 1 no-lock no-error.

  if avail pl-prod and
     avail pl-carga-maq then do:
     find first periodo
        where periodo.cd-tipo = pl-prod.cd-tipo
          and periodo.ano     = pl-carga-maq.ano
          and periodo.nr-per  = pl-carga-maq.periodo
     no-lock no-error.   

     if avail periodo then
        assign gr-periodo = rowid(periodo).
  end.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  assign de-hor-prep = 0
         de-hor-maqn = 0
         de-hor-men  = 0.

  for each b-gm-estab NO-LOCK /* Ativ. 155845 */
     where b-gm-estab.cc-codigo = centro-custo.cc-codigo,  
      each b-pl-carga-maq 
       where b-pl-carga-maq.gm-codigo =  b-gm-estab.gm-codigo
         and b-pl-carga-maq.periodo   = periodo.nr-per
         and b-pl-carga-maq.ano       = periodo.ano no-lock:
       assign de-hor-prep = b-pl-carga-maq.horas-prepar + de-hor-prep        
              de-hor-maqn = b-pl-carga-maq.horas-maquin + de-hor-maqn
              de-hor-men  = b-pl-carga-maq.horas-homem  + de-hor-men.
  end.        
      
  display c-horas de-hor-prep de-hor-maqn de-hor-men with frame {&frame-name}.   

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  &IF DEFINED (bf_man_203) &THEN
  define variable h-wHandle as WIDGET-HANDLE no-undo. 
  &endif

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  do  with frame {&frame-name}:
      {utp/ut-liter.i Preparaá∆o *}
      Assign de-hor-prep:label  = return-value.
      {utp/ut-liter.i M†quina *}
      assign de-hor-maqn:label = return-value.
      {utp/ut-liter.i Homem *}
      assign de-hor-men:label = return-value.
      {utp/ut-liter.i Total_Horas *}
      Assign c-horas = return-value.

 /*posisionamento de campos para a release 2.03*/
  &IF DEFINED (bf_man_203) &THEN
      assign rect-15:height = 1.46
             rect-15:row = 3.4
             c-horas:row = 3.3
             rect-14:height = 2.21
             de-hor-prep:col = 14.43
             de-hor-prep:row = 3.71
             h-wHandle = de-hor-prep:side-label-handle
             h-wHandle:row = de-hor-prep:row
             h-wHandle:column = de-hor-prep:column - 8.6
             de-hor-men:column = 44
             de-hor-men:row = 3.71
             h-wHandle = de-hor-men:side-label-handle
             h-wHandle:row = de-hor-men:row
             h-wHandle:column = de-hor-men:column - 6.7
             de-hor-maqn:column = 73.72
             de-hor-maqn:row = 3.71
             h-wHandle = de-hor-maqn:side-label-handle
             h-wHandle:row = de-hor-maqn:row
             h-wHandle:column = de-hor-maqn:column - 6.8
             fi-cd-plano:column = 18.72
             fi-cd-plano:row = 2.17
             h-wHandle = fi-cd-plano:side-label-handle
             h-wHandle:row = fi-cd-plano:row
             h-wHandle:column = fi-cd-plano:column - 4.7
             fi-desc-plano:column = 24.30
             fi-desc-plano:row = 2.17
             fi-cod-estabel:column = 77.57
             fi-cod-estabel:row = 2.17
             h-wHandle = fi-cod-estabel:side-label-handle
             h-wHandle:row = fi-cod-estabel:row
             h-wHandle:column = fi-cod-estabel:column - 6 
			 
             fi-cd-plano:hidden = no
             fi-desc-plano:hidden = no
             fi-cod-estabel:hidden = no. 
      
      {utp/ut-field.i mgind pl-prod cd-plano 1}
      assign fi-cd-plano:label = trim(return-value). 
      {utp/ut-field.i mgadm estabelec cod-estabel 2}
      assign fi-cod-estabel:label = trim(return-value). 
    
    &endif
      
        
  end.
  
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
IF AVAIL(centro-custo)  THEN
  &IF DEFINED (bf_man_203) &THEN
    ASSIGN fi-cd-plano:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
           fi-desc-plano:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''
           fi-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ''.

   blk_ccusto:
   FOR EACH gm-estab 
      WHERE gm-estab.cc-codigo = centro-custo.cc-codigo,
       FIRST grup-maquina 
       WHERE grup-maquina.gm-codigo = gm-estab.gm-codigo,
       FIRST pl-carga-maq 
       WHERE pl-carga-maq.gm-codigo = gm-estab.gm-codigo NO-LOCK: 

       FIND FIRST pl-prod NO-LOCK 
            WHERE pl-prod.num-calc-plano = pl-carga-maq.num-calc-plano 
              AND pl-prod.pl-estado      = 1 NO-ERROR.
       IF AVAILABLE pl-prod THEN DO:
           assign fi-cd-plano:screen-value in frame {&frame-name} = string(pl-prod.cd-plano)
                  fi-desc-plano:screen-value in frame {&frame-name} = pl-prod.descricao.
       
           find LAST it-periodo where
                 it-periodo.num-id-it-periodo = pl-carga-maq.num-id-it-periodo and
                 it-periodo.num-calc-plano = pl-carga-maq.num-calc-plano no-lock no-error.
           if avail it-periodo then
               assign fi-cod-estabel:screen-value in frame {&frame-name} = it-periodo.cod-estabel.           

           /*Encontrou plano calculado ent∆o pode sair do bloco*/
           LEAVE blk_ccusto.

       END.
   END.                    
  &endif

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
  {src/adm/template/snd-list.i "gm-estab"}
  {src/adm/template/snd-list.i "centro-custo"}
  {src/adm/template/snd-list.i "pl-carga-maq"}

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
