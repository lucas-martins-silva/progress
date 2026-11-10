&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V03IN287 2.00.00.057 } /*** "010057" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in287 MUT}
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
def new global shared var l-tem-movto as logical no-undo.
def new global shared var l-inclui as logical no-undo.

def buffer b-estab-mat for estab-mat.

/* Vari veis necess rias … chamada da api cdapi005 (leitura do per¡odo atual) */
def var da-iniper      as date format "99/99/9999"   no-undo.
def var da-fimper      as date format "99/99/9999"   no-undo.
def var i-per-corrente as int  format "99"           no-undo.
def var i-ano-corrente as int  format "9999"         no-undo.
def var da-iniper-fech as date format "99/99/9999"   no-undo.
def var da-fimper-fech as date format "99/99/9999"   no-undo.
def var h_window       as handle                     no-undo.
def var h_v05in287     as handle                     no-undo.
def var h_v02in287     as handle                     no-undo.

def var i-tp-fech-ant  as int                        no-undo.

def var da-ult-fech-dia as date no-undo.
def var c-ult-per-fech  as char no-undo.
def var da-mensal-ate   as date no-undo.
def var da-data-1       as date no-undo.
def var da-contab-ate   as date no-undo.

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-estoq.log-2 param-estoq.tp-fech ~
param-estoq.nr-ord-per 
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq
&Scoped-Define ENABLED-OBJECTS l-agr-estab-emp RECT-6 RECT-7 RECT-8 
&Scoped-Define DISPLAYED-FIELDS param-estoq.log-2 param-estoq.tp-fech ~
param-estoq.ult-fech-dia param-estoq.ult-per-fech param-estoq.mensal-ate ~
param-estoq.data-1 param-estoq.contab-ate param-estoq.nr-ord-per 
&Scoped-define DISPLAYED-TABLES param-estoq
&Scoped-define FIRST-DISPLAYED-TABLE param-estoq
&Scoped-Define DISPLAYED-OBJECTS l-agr-estab-emp fi-ini-periodo ~
fi-fim-periodo c-tp-fech c-periodos 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define List-4 param-estoq.ult-fech-dia param-estoq.ult-per-fech ~
param-estoq.mensal-ate param-estoq.data-1 param-estoq.contab-ate 

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
DEFINE VARIABLE c-periodos AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19.86 BY .67 NO-UNDO.

DEFINE VARIABLE c-tp-fech AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.72 BY .67 NO-UNDO.

DEFINE VARIABLE fi-fim-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ini-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 13.13.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 6.58.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 6.09.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 2.07.

DEFINE VARIABLE l-agr-estab-emp AS LOGICAL INITIAL NO 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE rs-contabiliza AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Por Documento", 1,
          "Por Data", 2
     SIZE 31 BY 1.38 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-agr-estab-emp AT ROW 5.5 COL 8 WIDGET-ID 14
     param-estoq.log-2 AT ROW 9.38 COL 8.72
          LABEL "Estorna Referencia"
          VIEW-AS TOGGLE-BOX
          SIZE 31.72 BY 1.17
     param-estoq.tp-fech AT ROW 2.25 COL 8 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "énico", 1,
"Por Estabelecimento", 2
          SIZE 31.57 BY 3
     param-estoq.ult-fech-dia AT ROW 2.58 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     param-estoq.ult-per-fech AT ROW 3.83 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     param-estoq.mensal-ate AT ROW 5.08 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     param-estoq.data-1 AT ROW 6.33 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     param-estoq.contab-ate AT ROW 7.58 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     fi-ini-periodo AT ROW 8.83 COL 68.86 COLON-ALIGNED
     fi-fim-periodo AT ROW 10.08 COL 68.86 COLON-ALIGNED
     param-estoq.nr-ord-per AT ROW 11.33 COL 68.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     c-tp-fech AT ROW 1 COL 2.14 NO-LABEL
     c-periodos AT ROW 1 COL 43.72 COLON-ALIGNED NO-LABEL
     rs-contabiliza AT ROW 12.42 COL 8 NO-LABEL 
     "Forma Descontabiliza‡Æo" VIEW-AS TEXT
          SIZE 25.14 BY .67 AT ROW 7.75 COL 3
     RECT-6 AT ROW 1 COL 44.86
     RECT-7 AT ROW 1 COL 1.14
     RECT-8 AT ROW 8.04 COL 1.14
     RECT-9 AT ROW 12.04 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-estoq
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
         HEIGHT             = 13.13
         WIDTH              = 87.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-periodos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tp-fech IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN param-estoq.contab-ate IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN param-estoq.data-1 IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN fi-fim-periodo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ini-periodo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX param-estoq.log-2 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-estoq.mensal-ate IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN param-estoq.ult-fech-dia IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN param-estoq.ult-per-fech IN FRAME f-main
   NO-ENABLE 4                                                          */
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

&Scoped-define SELF-NAME l-agr-estab-emp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-agr-estab-emp V-table-Win
ON VALUE-CHANGED OF l-agr-estab-emp IN FRAME f-main
DO:
   IF l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = NO THEN DO:
       
       RUN utp/ut-msgs.p (INPUT 'show', 
                          INPUT 35111, 
                          INPUT '').

       IF RETURN-VALUE = 'NO' THEN DO:
           ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = YES.  
       END. 
       ELSE DO:      
          IF CAN-FIND(FIRST movto-estoq NO-LOCK
                      WHERE movto-estoq.esp-docto = 23 /* NFT */
                        AND movto-estoq.dt-trans  > param-estoq.mensal-ate)
                       THEN DO:
                
              RUN utp/ut-msgs.p (INPUT 'show', 
                                 INPUT 35110, 
                                 INPUT '').
    
              ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = YES.                        
          END.
       END.       
       
       IF l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = NO THEN
          RUN pi-desabilita IN h_v05in287(INPUT 2,
                                          INPUT l-agr-estab-emp:CHECKED IN FRAME {&frame-name},
                                          INPUT YES).             
   END.
   ELSE DO:

       IF CAN-FIND(FIRST estab-mat
                   WHERE estab-mat.idi-val-transf = 1) THEN
           RUN utp/ut-msgs.p (INPUT 'show', 
                              INPUT 56536, 
                              INPUT '').
   END.
      
   RUN pi-habilita IN h_v05in287(INPUT FRAME {&frame-name} l-agr-estab-emp ).
   
   ASSIGN l-agr-estab-emp.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.tp-fech
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.tp-fech V-table-Win
ON VALUE-CHANGED OF param-estoq.tp-fech IN FRAME f-main /* Tp Fech */
DO:  
    IF INPUT FRAME {&frame-name} param-estoq.tp-fech = 2 THEN
       ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = YES
              l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = YES.
    
    IF param-estoq.tp-fech:screen-value IN FRAME {&frame-name} = '2' THEN DO:        
        RUN utp/ut-msgs.p (INPUT 'show', 
                           INPUT 53959, 
                           INPUT '').

        IF RETURN-VALUE = 'NO' THEN DO:
            ASSIGN param-estoq.tp-fech:screen-value IN FRAME {&frame-name} = '1'.
        END.
    END.    

    RUN pi-desabilita IN h_v05in287(INPUT FRAME {&frame-name} param-estoq.tp-fech,
                                    INPUT l-agr-estab-emp:CHECKED IN FRAME {&frame-name},
                                    INPUT YES).

    &if "{&bf_mat_versao_ems}" >= "2.062" &then
    RUN pi-habilita-rateio-un IN h_v02in287(INPUT (INPUT FRAME {&frame-name} param-estoq.tp-fech = 1)).
    &endif
    
    IF INPUT FRAME {&frame-name} param-estoq.tp-fech = 1 THEN
       ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = NO
              l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = NO.                         
    ELSE
       ASSIGN l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = YES. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.ult-per-fech
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.ult-per-fech V-table-Win
ON LEAVE OF param-estoq.ult-per-fech IN FRAME f-main /* Ultimo Periodo Fechado */
DO:
    run cdp/cdapi005.p (input  input frame {&frame-name} param-estoq.ult-per-fech,
                        output da-iniper,   
                        output da-fimper,
                        output i-per-corrente,
                        output i-ano-corrente,
                        output da-iniper-fech,
                        output da-fimper-fech).

    assign param-estoq.ult-fech-dia:screen-value             in frame {&frame-name} = string(da-fimper-fech)
           param-estoq.mensal-ate:screen-value               in frame {&frame-name} = string(da-fimper-fech)
           param-estoq.data-1:screen-value                   in frame {&frame-name} = string(da-fimper-fech)
           param-estoq.contab-ate:screen-value               in frame {&frame-name} = string(da-fimper-fech).

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

{utp/ut-field.i mgadm ano-fiscal ini-periodo 1}
assign fi-ini-periodo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgadm ano-fiscal fim-periodo 1}
ASSIGN fi-fim-periodo:label IN FRAME {&frame-name} = RETURN-VALUE.

{utp/ut-liter.i Agrupa_Por_Empresa * L}
ASSIGN l-agr-estab-emp:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

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
  
  /********************** Validacao fechamento por Empresa *********************/
  RUN pi-valida-fech-por-emp.
  IF RETURN-VALUE = "NOK":U THEN RETURN "ADM-ERROR".
  /*****************************************************************************/

  if  l-inclui then
      assign da-ult-fech-dia = input frame {&frame-name} param-estoq.ult-fech-dia
             c-ult-per-fech  = input frame {&frame-name} param-estoq.ult-per-fech
             da-mensal-ate   = input frame {&frame-name} param-estoq.mensal-ate
             da-data-1       = input frame {&frame-name} param-estoq.data-1
             da-contab-ate   = input frame {&frame-name} param-estoq.contab-ate.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  avail param-estoq
  and l-inclui then
      assign param-estoq.ult-fech-dia = da-ult-fech-dia
             param-estoq.ult-per-fech = c-ult-per-fech
             param-estoq.mensal-ate   = da-mensal-ate
             param-estoq.dat-inic-calc-med-diario = da-mensal-ate
             param-estoq.data-1       = da-data-1
             param-estoq.contab-ate   = da-contab-ate.

  if i-tp-fech-ant <> param-estoq.tp-fech then do:
      if param-estoq.tp-fech = 2 then
          FOR EACH estab-mat EXCLUSIVE-LOCK:
              ASSIGN estab-mat.mensal-ate               = param-estoq.mensal-ate
                     estab-mat.dat-inic-calc-med-diario = param-estoq.dat-inic-calc-med-diario
                     estab-mat.sumar-ate                = param-estoq.data-1
                     estab-mat.contab-ate               = param-estoq.contab-ate
                     estab-mat.ult-per-fech             = param-estoq.ult-per-fech
                     estab-mat.ult-fech-dia             = param-estoq.ult-fech-dia
                     estab-mat.cod-cenar-geren          = param-estoq.cod-cenar-geren        
                     estab-mat.num-ult-fechto-geren     = param-estoq.num-ult-fechto-geren    
                     estab-mat.dat-mensal-geren         = param-estoq.dat-mensal-geren        
                     estab-mat.log-med-geren-ja-inic    = param-estoq.log-med-geren-ja-inic  
                     estab-mat.idi-fase-med-geren       = param-estoq.idi-fase-med-geren      
                     estab-mat.dat-sumar-geren          = param-estoq.dat-sumar-geren        
                     estab-mat.dat-ctbl-geren           = param-estoq.dat-ctbl-geren          
                     estab-mat.idi-fase-ctbl-geren      = param-estoq.idi-fase-ctbl-geren    
                     estab-mat.dat-fechto-geren         = param-estoq.dat-fechto-geren        
                     estab-mat.log-fechto-geren-ja-inic = param-estoq.log-fechto-geren-ja-inic
                     estab-mat.log-gera-act-geren       = param-estoq.log-gera-act-geren.
          END. 
      else if not l-inclui then do:
          find first estab-mat no-lock no-error.
          if avail estab-mat then
              ASSIGN param-estoq.mensal-ate   = estab-mat.mensal-ate
                     param-estoq.dat-inic-calc-med-diario = estab-mat.dat-inic-calc-med-diario
                     param-estoq.data-1       = estab-mat.sumar-ate
                     param-estoq.contab-ate   = estab-mat.contab-ate
                     param-estoq.ult-per-fech = estab-mat.ult-per-fech
                     param-estoq.ult-fech-dia = estab-mat.ult-fech-dia.
      END.
  END.
  ASSIGN i-tp-fech-ant = param-estoq.tp-fech.

  ASSIGN OVERLAY(param-estoq.CHAR-2,67,1) = (IF l-agr-estab-emp:CHECKED IN FRAME {&frame-name} THEN "S" ELSE "N").

  if  i-pais-impto-usuario <> 1 THEN DO:
      ASSIGN OVERLAY(param-estoq.char-2,131,1) = rs-contabiliza:SCREEN-VALUE IN FRAME {&frame-name}.
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
  {utp/ut-liter.i Sumarizado_at‚ * L}
  assign param-estoq.data-1:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind param-estoq tp-fech 1}
  ASSIGN c-tp-fech:screen-value IN FRAME {&frame-name} = RETURN-VALUE.
  
  ASSIGN l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = NO.
   
  {utp/ut-liter.i Datas_Fechamento * L}
  assign c-periodos:screen-value in frame {&frame-name} = return-value.
  IF AVAIL param-estoq THEN DO:
      ASSIGN param-estoq.ult-fech-dia:SENSITIVE IN FRAME {&frame-name} = NO
             param-estoq.ult-per-fech:SENSITIVE IN FRAME {&frame-name} = NO
             param-estoq.mensal-ate:SENSITIVE IN FRAME {&frame-name}   = NO
             param-estoq.data-1:SENSITIVE IN FRAME {&frame-name}       = NO
             param-estoq.contab-ate:SENSITIVE IN FRAME {&frame-name}   = NO.
             
      IF SUBSTRING(param-estoq.CHAR-2,67,1) = "S" THEN DO:
         ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = YES.
         RUN pi-habilita IN h_v05in287(INPUT FRAME {&frame-name} l-agr-estab-emp ).
      END.   
      ELSE
         ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = NO.       
             
      IF param-estoq.tp-fech = 1 THEN DO:
          ASSIGN param-estoq.tp-fech:sensitive IN FRAME {&frame-name}  =  
                                     param-estoq.mensal-ate = param-estoq.ult-fech-dia AND
                                     param-estoq.data-1     = param-estoq.ult-fech-dia.                              
          RUN pi-habilita IN h_v05in287(INPUT YES).                           
      END.    
      ELSE DO:          
          FOR FIRST estab-mat FIELDS(cod-estabel mensal-ate sumar-ate contab-ate
                                     ult-fech-dia) NO-LOCK: END.
          IF AVAIL estab-mat THEN DO:
              IF param-estoq.log-1 THEN
                  ASSIGN param-estoq.tp-fech:sensitive IN FRAME {&frame-name}  =   
                                     NOT CAN-FIND (FIRST b-estab-mat WHERE
                                                         b-estab-mat.cod-estabel  <> estab-mat.cod-estabel    AND
                                                         (b-estab-mat.mensal-ate  <> estab-mat.mensal-ate     OR 
                                                         b-estab-mat.sumar-ate    <> estab-mat.sumar-ate      OR
                                                         b-estab-mat.contab-ate   <> estab-mat.contab-ate     OR
                                                         b-estab-mat.ult-fech-dia <> estab-mat.ult-fech-dia)) AND
                                     NOT CAN-FIND (FIRST b-estab-mat WHERE
                                                         b-estab-mat.mensal-ate <> estab-mat.mensal-ate  OR
                                                         b-estab-mat.mensal-ate <> estab-mat.sumar-ate   OR
                                                         b-estab-mat.mensal-ate <> estab-mat.contab-ate  OR
                                                         b-estab-mat.mensal-ate <> estab-mat.ult-fech-dia).
              else
                  assign param-estoq.tp-fech:sensitive in frame {&frame-name}  =   
                                     NOT CAN-FIND (FIRST b-estab-mat WHERE 
                                                         b-estab-mat.cod-estabel  <> estab-mat.cod-estabel    AND 
                                                         (b-estab-mat.sumar-ate   <> estab-mat.sumar-ate      OR 
                                                         b-estab-mat.contab-ate   <> estab-mat.contab-ate     OR 
                                                         b-estab-mat.ult-fech-dia <> estab-mat.ult-fech-dia)) AND
                                     NOT CAN-FIND (FIRST b-estab-mat WHERE
                                                         b-estab-mat.mensal-ate <> estab-mat.sumar-ate   OR
                                                         b-estab-mat.mensal-ate <> estab-mat.contab-ate  OR
                                                         b-estab-mat.mensal-ate <> estab-mat.ult-fech-dia).
          end.
     end.    
     IF l-inclui = YES or l-tem-movto = NO
     THEN ASSIGN param-estoq.ult-fech-dia:SENSITIVE IN FRAME {&frame-name} = YES
                  param-estoq.ult-per-fech:SENSITIVE IN FRAME {&frame-name} = YES
                  param-estoq.mensal-ate:SENSITIVE IN FRAME {&frame-name}   = YES
                  param-estoq.data-1:SENSITIVE IN FRAME {&frame-name}       = YES
                  param-estoq.contab-ate:SENSITIVE IN FRAME {&frame-name}   = YES
                  param-estoq.tp-fech:sensitive in frame {&frame-name}      = YES.    

      RUN pi-desabilita IN h_v05in287(INPUT FRAME {&frame-name} param-estoq.tp-fech,
                                      INPUT l-agr-estab-emp:CHECKED IN FRAME {&frame-name},
                                      INPUT NO). 

  END.
  ELSE
    ENABLE {&list-4} WITH FRAME {&FRAME-NAME}.
    
  IF param-estoq.tp-fech:screen-value IN FRAME {&frame-name} = '2' THEN   
     ASSIGN l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = param-estoq.tp-fech:sensitive IN FRAME {&frame-name}.  

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
  {utp/ut-field.i mgind param-estoq tp-fech 1}
  assign c-tp-fech:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Datas_Fechamento * L}
  ASSIGN c-periodos:screen-value IN FRAME {&frame-name} = RETURN-VALUE.
         
  ASSIGN l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = NO.   

  if  i-pais-impto-usuario <> 1 THEN DO:
      ASSIGN rs-contabiliza:VISIBLE IN FRAME {&frame-name} = YES
             rs-contabiliza:SENSITIVE IN FRAME {&frame-name} = YES
             RECT-9:VISIBLE IN FRAME {&frame-name} = YES
             RECT-8:HEIGHT IN FRAME {&frame-name} = 3.56.
      {utp/ut-liter.i Contabiliza‡Æo * L}
      DISP RETURN-VALUE VIEW-AS TEXT SIZE 18.14 BY .67 AT ROW 11.72 COL 3
           WITH FRAME {&frame-name}.
  END.
  ELSE DO:
      ASSIGN rs-contabiliza:VISIBLE IN FRAME {&frame-name} = NO
             param-estoq.log-2:ROW IN FRAME {&frame-name} = 10.38
             RECT-9:VISIBLE IN FRAME {&frame-name} = NO.
  END.

  {utp/ut-field.i mgind param-estoq tp-fech 1}
  assign c-tp-fech = return-value.
  {utp/ut-liter.i Datas_Fechamento * L}
  assign c-periodos = return-value.
  IF AVAIL param-estoq THEN DO:
     ASSIGN param-estoq.ult-fech-dia:SENSITIVE IN FRAME {&frame-name} = NO
            param-estoq.ult-per-fech:SENSITIVE IN FRAME {&frame-name} = NO
            param-estoq.mensal-ate:SENSITIVE IN FRAME {&frame-name}   = NO
            param-estoq.data-1:SENSITIVE IN FRAME {&frame-name}       = NO
            param-estoq.contab-ate:SENSITIVE IN FRAME {&frame-name}   = NO
            i-tp-fech-ant                                             = param-estoq.tp-fech.
            
     IF SUBSTRING(param-estoq.CHAR-2,67,1) = "S" THEN
        ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = YES.
     ELSE
        ASSIGN l-agr-estab-emp:CHECKED IN FRAME {&frame-name} = NO.         

     IF param-estoq.tp-fech = 1 THEN DO:
         ASSIGN param-estoq.tp-fech:sensitive IN FRAME {&frame-name}  =  
                                    param-estoq.mensal-ate = param-estoq.ult-fech-dia.    
     END.    
     ELSE DO:
         FOR FIRST estab-mat FIELDS(cod-estabel mensal-ate sumar-ate contab-ate
                                    ult-fech-dia) NO-LOCK: END.
         IF AVAIL estab-mat THEN DO:
             IF param-estoq.log-1 THEN
                 ASSIGN param-estoq.tp-fech:sensitive IN FRAME {&frame-name}  =   
                                    NOT CAN-FIND (FIRST b-estab-mat WHERE
                                                        b-estab-mat.cod-estabel  <> estab-mat.cod-estabel   AND
                                                        b-estab-mat.mensal-ate   <> estab-mat.mensal-ate    AND
                                                        b-estab-mat.sumar-ate    <> estab-mat.sumar-ate     AND
                                                        b-estab-mat.contab-ate   <> estab-mat.contab-ate    AND
                                                        b-estab-mat.ult-fech-dia <> estab-mat.ult-fech-dia) AND
                                    NOT CAN-FIND (FIRST b-estab-mat WHERE
                                                        b-estab-mat.mensal-ate <> estab-mat.mensal-ate  OR
                                                        b-estab-mat.mensal-ate <> estab-mat.sumar-ate   OR
                                                        b-estab-mat.mensal-ate <> estab-mat.contab-ate  OR
                                                        b-estab-mat.mensal-ate <> estab-mat.ult-fech-dia).
             else
                 assign param-estoq.tp-fech:sensitive in frame {&frame-name}  =   
                                    NOT CAN-FIND (FIRST b-estab-mat WHERE 
                                                        b-estab-mat.cod-estabel  <> estab-mat.cod-estabel   AND 
                                                        b-estab-mat.sumar-ate    <> estab-mat.sumar-ate     AND 
                                                        b-estab-mat.contab-ate   <> estab-mat.contab-ate    AND 
                                                        b-estab-mat.ult-fech-dia <> estab-mat.ult-fech-dia) AND
                                    NOT CAN-FIND (FIRST b-estab-mat WHERE
                                                        b-estab-mat.mensal-ate <> estab-mat.sumar-ate   OR
                                                        b-estab-mat.mensal-ate <> estab-mat.contab-ate  OR
                                                        b-estab-mat.mensal-ate <> estab-mat.ult-fech-dia).
         end.
     end.

     IF l-inclui = YES or l-tem-movto = NO
     THEN ASSIGN param-estoq.ult-fech-dia:SENSITIVE IN FRAME {&frame-name} = YES
                 param-estoq.ult-per-fech:SENSITIVE IN FRAME {&frame-name} = YES
                 param-estoq.mensal-ate:SENSITIVE IN FRAME {&frame-name}   = YES
                 param-estoq.data-1:SENSITIVE IN FRAME {&frame-name}       = YES
                 param-estoq.contab-ate:SENSITIVE IN FRAME {&frame-name}   = YES
                 param-estoq.tp-fech:sensitive in frame {&frame-name}      = YES.    

     run cdp/cdapi005.p (input  param-estoq.ult-per-fech,
                         output da-iniper               ,   
                         output da-fimper               ,
                         output i-per-corrente          ,
                         output i-ano-corrente          ,
                         output da-iniper-fech          ,
                         output da-fimper-fech          ).
     assign fi-ini-periodo:screen-value in frame {&frame-name} = string(da-iniper)
            fi-fim-periodo:screen-value in frame {&frame-name} = string(da-fimper).

     if  i-pais-impto-usuario <> 1 THEN DO:
         ASSIGN rs-contabiliza = int(substr(param-estoq.char-2,131,1)).
         DISP rs-contabiliza WITH FRAME {&FRAME-NAME}.
     END.
  END.                
  ELSE
    ENABLE {&list-4} WITH FRAME {&FRAME-NAME}.

  IF param-estoq.tp-fech:screen-value IN FRAME {&frame-name} = '2' THEN   
     ASSIGN l-agr-estab-emp:SENSITIVE IN FRAME {&frame-name} = param-estoq.tp-fech:sensitive IN FRAME {&frame-name}.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-altera-tp-fech V-table-Win 
PROCEDURE pi-altera-tp-fech :
/*------------------------------------------------------------------------------
  Purpose: verificacoes relativas a NFTs    
  Parameters: nao se aplica.
  Notes:    
  
     Quando o usuario alterar o tipo de fechamento unico -> estabelecimento
  as notas fiscais de transferencia passam a ser valorizadas ao informado,
  entao torna-se necessario informar sobre esta situacao para que o mesmo
  tenha ciencia da alteracao. Se houver alguma nota-fiscal de transferencia
  no periodo em aberto, o programa nao permite a alteracao para que nao seja
  gerada inconsistencia de base: notas de transferencia valorizadas ao medio
  e ao informado no mesmo periodo.    
------------------------------------------------------------------------------*/

    if param-estoq.tp-fech:screen-value in frame {&frame-name} = '2' then do:
        
        run utp/ut-msgs.p (input 'show', 
                           input 35111, 
                           input '').

        IF RETURN-VALUE = 'no' THEN DO:
            ASSIGN param-estoq.tp-fech:screen-value IN FRAME {&frame-name} = '1'.
        END.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-contab-ate V-table-Win 
PROCEDURE pi-contab-ate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'entry' TO param-estoq.contab-ate in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-guarda-handle V-table-Win 
PROCEDURE pi-guarda-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param h_1 as handle no-undo.
def input param h_2 as handle no-undo.
&if "{&bf_mat_versao_ems}" >= "2.062" &then
def input param h_3 as handle no-undo.
&endif

assign h_v05in287 = h_2
       h_window   = h_1
       &if "{&bf_mat_versao_ems}" >= "2.062" &then
       h_v02in287 = h_3
       &endif
       .

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mensal-ate V-table-Win 
PROCEDURE pi-mensal-ate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'entry' TO param-estoq.mensal-ate in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ult-fech-dia V-table-Win 
PROCEDURE pi-ult-fech-dia :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'entry' TO param-estoq.ult-fech-dia in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ult-per-fech V-table-Win 
PROCEDURE pi-ult-per-fech :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

APPLY 'entry' TO param-estoq.ult-per-fech in frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-fech-por-emp V-table-Win
PROCEDURE pi-valida-fech-por-emp :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    DEFINE VARIABLE lErro AS LOGICAL INITIAL FALSE NO-UNDO.

    IF NOT l-agr-estab-emp:CHECKED IN FRAME {&frame-name} THEN RETURN "OK":U.

    FOR EACH empresa NO-LOCK:

        FIND FIRST estabelec NO-LOCK 
           WHERE estabelec.ep-codigo = empresa.ep-codigo NO-ERROR.

        IF NOT AVAILABLE estabelec THEN NEXT.
          
        FIND FIRST b-estab-mat NO-LOCK 
             WHERE b-estab-mat.cod-estabel = estabelec.cod-estabel NO-ERROR.
        
        IF NOT AVAILABLE b-estab-mat THEN NEXT. 

        FOR EACH estabelec NO-LOCK 
           WHERE estabelec.ep-codigo = empresa.ep-codigo:
            
            FOR EACH estab-mat NO-LOCK
               WHERE estab-mat.cod-estabel = estabelec.cod-estabel:

                /* Parametros e Datas */ 
                IF estab-mat.tipo-pr-med  <> b-estab-mat.tipo-pr-med  OR   
                   estab-mat.acerto-aut   <> b-estab-mat.acerto-aut   OR 
                   estab-mat.gera-act     <> b-estab-mat.gera-act     OR 
                   estab-mat.num-dec      <> b-estab-mat.num-dec      OR
                   estab-mat.mensal-ate   <> b-estab-mat.mensal-ate   OR 
                   estab-mat.sumar-ate    <> b-estab-mat.sumar-ate    OR 
                   estab-mat.contab-ate   <> b-estab-mat.contab-ate   OR 
                   estab-mat.ult-fech-dia <> b-estab-mat.ult-fech-dia OR 
                   estab-mat.ult-per-fech <> b-estab-mat.ult-per-fech THEN DO:
               
                   RUN utp/ut-msgs.p (INPUT 'show',
                                      INPUT 54410,                                      
                                      INPUT estabelec.ep-codigo).               
                   RETURN "NOK":U.
                END.
                  
                IF estab-mat.cdn-rat-un <> b-estab-mat.cdn-rat-un THEN DO:                   
                   RUN utp/ut-msgs.p (INPUT 'show',
                                      INPUT 54427,                                      
                                      INPUT estabelec.ep-codigo).               
                   RETURN "NOK":U.                                       
                END.      
            END.     
        END.
    END.
    
    RETURN "OK":U.
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
  {src/adm/template/snd-list.i "param-estoq"}

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

