&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movmnt           PROGRESS
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
{include/i-prgvrs.i V39IN270 2.00.00.013 } /*** "010013" ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v39in270 MUT}
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
def new global shared var l-solic-encerr-cs0307 as logical no-undo.                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgmnt.i}

def var r-ord        as rowid no-undo.
def var l-erro-ver   as logical no-undo.
def var c-param-aloc as char format "x(20)".
def var l-disp       as log  initial no no-undo.
def var da-data      as date format "99/99/9999" no-undo.
def var i-estado     as integer no-undo.
def var c-erro       as char    no-undo.
def var h-ord-manut  as handle  no-undo.
def var h-cpapi013   as handle  no-undo.

{cdp/cdcfgman.i}
{cpp/cpapi013.i}
{cdp/cd0666.i}
{gcp/gcapi002.i}

/** Unificaá∆o de conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}  

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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.dt-fecham 
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS RECT-13 RECT-14 RECT-15 RECT-6 RECT-7 RECT-9 
&Scoped-Define DISPLAYED-FIELDS ord-manut.dt-fecham ord-manut.dt-prev ~
ord-manut.dt-manut 
&Scoped-define DISPLAYED-TABLES ord-manut
&Scoped-define FIRST-DISPLAYED-TABLE ord-manut
&Scoped-Define DISPLAYED-OBJECTS l-estado l-valorizada c-conta-ordem fi-ccusto ~
i-calc-cs-mat i-calc-cs-mob i-calc-cs-ggf i-reporte-ggf ~
i-reporte-mob c-texto1 c-texto2 c-texto4 c-texto6 c-texto5 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-conta-ordem fi-ccusto i-calc-cs-mat i-calc-cs-mob ~
i-calc-cs-ggf i-reporte-ggf i-reporte-mob 
&Scoped-define ADM-MODIFY-FIELDS l-estado c-conta-ordem fi-ccusto i-calc-cs-mat ~
i-calc-cs-mob i-calc-cs-ggf i-reporte-ggf i-reporte-mob 

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
DEFINE VARIABLE c-conta-ordem AS CHARACTER FORMAT "x(20)" 
     LABEL "Conta Ordem":R14 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

 DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "x(20)" 
     LABEL ""
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.
	 
DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .58 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-texto5 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .58.

DEFINE VARIABLE c-texto6 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE i-calc-cs-ggf AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Proporcional", 1,
"Total", 2
     SIZE 34 BY .79.

DEFINE VARIABLE i-calc-cs-mat AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Proporcional a Requisiá∆o", 1,
"Total Requisitado", 2
     SIZE 48.14 BY .79.

DEFINE VARIABLE i-calc-cs-mob AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Proporcional", 1,
"Total", 2
     SIZE 34 BY .83.

DEFINE VARIABLE i-reporte-ggf AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Real", 1,
"Padr∆o", 2
     SIZE 37 BY .83.

DEFINE VARIABLE i-reporte-mob AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Real", 1,
"Padr∆o", 2
     SIZE 34 BY .83.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40.86 BY 1.29.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.29.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.86 BY 4.21.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.29.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 41 BY 1.29.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 57.57 BY 1.29.

DEFINE VARIABLE l-estado AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .71 NO-UNDO.

DEFINE VARIABLE l-valorizada AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.72 BY .71 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-estado AT ROW 1.17 COL 21
     l-valorizada AT ROW 1.25 COL 57.43
     ord-manut.dt-fecham AT ROW 2 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     ord-manut.dt-prev AT ROW 2 COL 55 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ord-manut.dt-manut AT ROW 3 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-conta-ordem AT ROW 4 COL 19 COLON-ALIGNED
     fi-ccusto AT ROW 4 COL 39.40 COLON-ALIGNED NO-LABEL
     i-calc-cs-mat AT ROW 5.88 COL 19.14 NO-LABEL
     i-calc-cs-mob AT ROW 7.54 COL 48 NO-LABEL
     i-calc-cs-ggf AT ROW 7.58 COL 5.43 NO-LABEL
     i-reporte-ggf AT ROW 9.25 COL 4.86 NO-LABEL
     i-reporte-mob AT ROW 9.25 COL 47 NO-LABEL
     c-texto1 AT ROW 5.29 COL 16.57 NO-LABEL
     c-texto2 AT ROW 6.88 COL 1 COLON-ALIGNED NO-LABEL
     c-texto4 AT ROW 6.88 COL 43.29 COLON-ALIGNED NO-LABEL
     c-texto6 AT ROW 8.67 COL 2.43 COLON-ALIGNED NO-LABEL
     c-texto5 AT ROW 8.67 COL 43.57 COLON-ALIGNED NO-LABEL
     RECT-13 AT ROW 8.96 COL 1.57
     RECT-14 AT ROW 8.96 COL 43.72
     RECT-15 AT ROW 1.04 COL 1.57
     RECT-6 AT ROW 7.25 COL 43.86
     RECT-7 AT ROW 7.25 COL 1.72
     RECT-9 AT ROW 5.58 COL 14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-manut
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
         HEIGHT             = 9.29
         WIDTH              = 84.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

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

/* SETTINGS FOR FILL-IN c-conta-ordem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto4 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto5 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto6 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-manut IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-manut.dt-prev IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET i-calc-cs-ggf IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET i-calc-cs-mat IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET i-calc-cs-mob IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET i-reporte-ggf IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET i-reporte-mob IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX l-estado IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-valorizada IN FRAME f-main
   NO-ENABLE                                                            */
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

&Scoped-define SELF-NAME c-conta-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ordem V-table-Win
ON F5 OF c-conta-ordem IN FRAME f-main /* Conta Ordem */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.
  assign l-implanta = yes.

  if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
  if v_cod_finalid = "" then do: assign v_cod_finalid = "(nenhum)". end.
  run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
											  INPUT "CEP",
											  INPUT "",
											  INPUT v_cod_finalid,
											  INPUT TODAY,
											  OUTPUT v_cod_cta_ctbl,
											  OUTPUT v_des_cta_ctbl,
											  OUTPUT p-finalidade,
											  OUTPUT TABLE tt_log_erro).

	{cdp/cdunif001b.i1}
	
	IF v_cod_cta_ctbl <> "" THEN
		ASSIGN c-conta-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
	
	if valid-handle(h_api_cta_ctbl) then
		delete object h_api_cta_ctbl.	
		
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-ordem IN FRAME f-main /* Conta Ordem */
DO:
  apply "F5" to c-conta-ordem.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON F5 OF fi-ccusto IN FRAME f-main /* Conta Ordem */
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin.
  assign l-implanta = yes.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
	run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).

	if v_cod_ccusto <> "" then
		ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
	
    if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.	
	
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ccusto IN FRAME f-main /* Fill 1 */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-ordem V-table-Win
ON LEAVE OF c-conta-ordem IN FRAME f-main
DO:
  {cdp/cdunif001a.i c-conta-ordem fi-ccusto {&FRAME-NAME} TODAY """" """"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto wWindow
ON LEAVE OF fi-ccusto IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-ccusto {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME i-calc-cs-ggf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-calc-cs-ggf V-table-Win
ON VALUE-CHANGED OF i-calc-cs-ggf IN FRAME f-main
DO:
  run pi-atualiza-estado.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-calc-cs-mat
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-calc-cs-mat V-table-Win
ON VALUE-CHANGED OF i-calc-cs-mat IN FRAME f-main
DO:
  run  pi-atualiza-estado .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-calc-cs-mob
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-calc-cs-mob V-table-Win
ON VALUE-CHANGED OF i-calc-cs-mob IN FRAME f-main
DO:
  run pi-atualiza-estado .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-estado V-table-Win
ON VALUE-CHANGED OF l-estado IN FRAME f-main
DO:
  assign l-estado.
  
  if l-estado = yes then do:
     if ord-manut.dt-fecham:screen-value in frame {&frame-name} = ""
        and da-data = ? then
        disp today @ ord-manut.dt-fecham with frame {&frame-name}.
     else
        disp da-data @ ord-manut.dt-fecham with frame {&frame-name}.
     enable ord-manut.dt-fecham with frame {&frame-name}.
     RUN notify ('pi-desabilita,group-assign-target':U).
  end.
  else do:
    if available(ord-manut) then do:
      assign ord-manut.dt-fecham:screen-value in frame {&frame-name} = ?.
      disable ord-manut.dt-fecham with frame {&frame-name}.
      RUN notify ('pi-habilita,group-assign-target':U).
    end.
  end.
  RUN notify ('pi-alterada,group-assign-target':U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

	if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
	if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

	EMPTY TEMP-TABLE tt_log_erro.
	run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "",
													  INPUT "",
													  INPUT TODAY,
													  OUTPUT p_cod_format_cta_ctbl,
													  OUTPUT TABLE tt_log_erro).

	if valid-handle(h_api_cta_ctbl) then
		delete object h_api_cta_ctbl.	
		
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/
 if c-conta-ordem:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
 if fi-ccusto    :load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

{utp/ut-rtlbl.i mgind ord-prod calc-cs-mat c-texto1}
{utp/ut-rtlbl.i mgind ord-prod calc-cs-ggf c-texto2}
{utp/ut-rtlbl.i mgind ord-prod calc-cs-mob c-texto4}

{utp/ut-rtlbl.i mgind ord-prod reporte-mob c-texto5}
{utp/ut-rtlbl.i mgind ord-prod reporte-ggf c-texto6}

{utp/ut-liter.i Ordem_Terminada * r}
assign l-estado:label in frame {&frame-name} = trim(return-value).
{utp/ut-field.i mgind ord-prod valorizada 1}
assign l-valorizada:label in frame {&frame-name} = trim(return-value).

find first param-global no-lock no-error.
find first param-cp no-lock no-error.

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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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
    {include/i-valid.i}
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */

    {mip/integra-mobile.i}
    DEFINE VARIABLE hBoSincroniz AS HANDLE NO-UNDO.
    DEFINE VARIABLE hDBOOrdProd  AS HANDLE NO-UNDO.

    IF l-mobile THEN
        RUN mnbo/bomni00307.p PERSISTENT SET hBoSincroniz.
        
    IF  NOT VALID-HANDLE (hDBOOrdProd) OR
        hDBOOrdProd:TYPE <> "PROCEDURE":u OR
        hDBOOrdProd:FILE-NAME <> "inbo/boin271o.p":u THEN DO:
        RUN inbo/boin271o.p PERSISTENT SET hDBOOrdProd.
    END.    
    
    find first ord-prod 
         where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock no-error.
    &if defined (bf_mnt_ems203) &then
       if avail ord-manut then
          assign i-estado = ord-manut.estado. 
    &else
       if avail ord-prod then
          assign i-estado = ord-prod.estado.     
    &endif
    
    assign input frame {&FRAME-NAME} l-estado.
    if l-estado = yes and i-estado <> 8 then do:
       if avail ord-prod then do:
         &IF DEFINED (bf_man_linha_estab) &THEN
           find first lin-prod
                where lin-prod.cod-estabel = ord-prod.cod-estabel
                and   lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                
         &ELSE
           find first lin-prod
                where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
         &ENDIF
           if available(lin-prod) then
              if lin-prod.sum-requis = 2 and param-cp.ver-req then do:
                 run cpp/cp0311g.p (input rowid(ord-prod),
                                    output l-erro-ver,
                                    input "2", 
                                    input ord-prod.qt-reportada,
                                    input l-estado,
                                    input yes).
              end.
       end.       
       
       &if defined(bf_mnt_ems203) &then
           find first param-mnt no-lock no-error.       
       &endif
       
       for each reservas
           where reservas.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock:
           &IF DEFINED(bf_man_203) &THEN
                run cdp/cd7000.p (0,
                                  reservas.it-codigo,
                                  ord-manut.cod-estabel).
                             
                if avail param-mnt          and
                   param-mnt.modulo-ce      and
                   param-mnt.produto-ce = 1 then
                    
                    run cdp/cd9090.p (input rowid(reservas)).
                    
                else do:

                    if not valid-handle (h-cpapi013) then
                        run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
                                                                      input        table tt-deposito,
                                                                      input-output table tt-erro,
                                                                      input        yes).
                    
                    run pi-desaloca-reserva in h-cpapi013 (input rowid(reservas)).

                end.                             
           &ELSE
                run cdp/cd7000.p (0,
                                  reservas.it-codigo,
                                  "").

                if not valid-handle (h-cpapi013) then
                    run cpp/cpapi013.p persistent set h-cpapi013 (input        table tt-alocacao,
                                                                  input        table tt-deposito,
                                                                  input-output table tt-erro,
                                                                  input        yes).
                
                run pi-desaloca-reserva in h-cpapi013 (input rowid(reservas)).
           &ENDIF                             

           assign reservas.estado = 2.
           
       end.

       /* Atualiza contador da ordem caso ela n∆o esteja finalizada. */
       IF ord-manut.estado < 7 THEN DO:
           FOR FIRST manut NO-LOCK
               WHERE manut.cd-manut = ord-manut.cd-manut:

               if manut.controle = 2 or manut.controle = 3 THEN DO:
                  find last ut-equipto where 
                            ut-equipto.cd-equipto = ord-manut.cd-equipto  and   
                            ut-equipto.data      <= ord-manut.dt-fecham no-lock no-error.
                  if avail ut-equipto then
                     assign ord-manut.vl-contador = ut-equipto.contador
                            ord-manut.vl-cont-acum = ut-equipto.vl-contador.
               end.
           END.
       END.
       
       RUN setaEstadoOrdem IN hDBOOrdProd (INPUT ord-prod.nr-ord-produ,
                                           INPUT 8).

       assign ord-prod.valorizada = no.

       /******************************************************************************************************************
         A impress∆o somente poder† ser realizada nas funcionalidade:
           * MI1024 - Apontamento Ordem Lubrificaá∆o;
           * MI1029 - Apontamento Roteiros Inspeá∆o.
       *******************************************************************************************************************/
       IF  ord-manut.estado < 7 THEN DO:
           RUN mip/miapi101.p (INPUT ord-prod.nr-ord-produ,
                               INPUT NO, /* Impressao do Roteiro */
                               INPUT NO). /* Considera a Geraá∆o de Roteiro Automatico */
       END.
       
       assign ord-manut.estado    = 8
              ord-manut.estado-om = 4
              ord-manut.om-encerrada = yes.
       {mip/mi0309.i4}  /* desaloca as especialidades */
       
       /* encerra solicitacao servico */
       for each ordem-solic 
          where ordem-solic.nr-ord-prod = ord-manut.nr-ord-prod no-lock:
          find solic-serv
              where solic-serv.nr-soli-serv = ordem-solic.nr-soli-serv
              exclusive-lock no-error.
          if  avail solic-serv
          and solic-serv.estado <> 5 THEN DO:
              assign solic-serv.estado = 5
                     l-solic-encerr-cs0307 = YES. /*utilizada na v41in270.w*/                       
          end.
                     
       end.
       
       /*chamada a gcapi011 para manutená∆o do estado do equipamento   */
       &if defined (bf_mnt_calib) &then     /* integraá∆o com Calibraá∆o */
       
       &IF DEFINED (bf_mnt_ems208) &THEN
                        IF ord-manut.tp-manut = 3 
        &else
                        IF ord-manut.dec-1 = 3
        &endif
            &if defined (bf_mnt_ems205) &then
             and param-global.log-modul-calib   
            &else
             and substring(param-global.char-2,100,1) = '2':u
            &endif  then do:
            RUN gcp/gcapi011.p(input ord-manut.cd-equipto,
                                input 0,
                                input 2,
                                input ord-manut.nr-ord-produ,
                                input ord-manut.dt-fecham).
        END.
       &endif

    end.     
    if l-estado = no and i-estado = 8 then do:
       for each reservas use-index codigo
           where reservas.nr-ord-produ = ord-prod.nr-ord-produ exclusive-lock:
           if reservas.origem = 1 then do:
              assign reservas.estado = 1.
              run cdp/cd7000.p (0,
                                reservas.it-codigo,
                                ord-prod.cod-estabel).
           end.
       end.

       &if defined(bf_mnt_ems203) &then
        find first param-mnt no-lock no-error.
        if avail param-mnt and param-mnt.modulo-ce then do:
            case param-mnt.produto-ce:
                when 1 then do:
                    {mip/mi7000.i param-mnt modulo-ce produto-ce substring(param-mnt.char-1,1,8) mip/mi7504.p yes h-ord-manut}
                    run pi-seta-estado-ordem in h-ord-manut (input ord-manut.nr-ord-produ,
                                                             input 6, /*estado da Ordem*/
                                                             output c-erro).  
                    run pi-seta-quant-ordem  in h-ord-manut (ord-manut.nr-ord-produ,
                                                             0, /*qt-reportada*/
                                                             0, /*qt-produzida*/
                                                             2 /*calc-cs-mat*/).
                    if valid-handle(h-ord-manut) then do:
                       {btb/btb008za.i3 mip/mi7504.p h-ord-manut}
                    end.   
                end.
                when 2 then do:
                    RUN setaEstadoOrdem IN hDBOOrdProd (INPUT ord-prod.nr-ord-produ,
                                                        INPUT 6).
                                                        
                    assign ord-prod.qt-reportada = 0
                           ord-prod.qt-produzida = 0
                           ord-prod.calc-cs-mob  = 2
                           ord-prod.calc-cs-mat  = 2
                           ord-prod.reporte-mob  = 1.
                end.
            end case.
        end.
       &else 
            assign ord-prod.estado       = 6
                   ord-prod.qt-reportada = 0
                   ord-prod.qt-produzida = 0
                   ord-prod.calc-cs-mob  = 2
                   ord-prod.calc-cs-mat  = 2
                   ord-prod.reporte-mob  = 1.
       &endif
              
       if available(ord-manut) then do:
          find first manut where manut.cd-manut = ord-manut.cd-manut
               no-lock no-error.
          if ord-manut.cd-manut = "" or  
             (ord-manut.cd-manut <> "" and (manut.controle = 2 or manut.controle = 3)) then
             do  on error undo, retry:
             find last ut-equipto where 
                       ut-equipto.cd-equipto = ord-manut.cd-equipto  and   
                       ut-equipto.data      <= ord-manut.dt-fecham no-lock no-error.
             if avail ut-equipto then
                assign ord-manut.vl-contador = ut-equipto.contador
                     &if defined (bf_mnt_ems203) &then
                      ord-manut.vl-cont-acum = ut-equipto.vl-contador.
                     &else
                      ord-manut.dec-1 = ut-equipto.vl-contador.
                     &endif
             else
                assign ord-manut.vl-contador = 0
                      &if defined (bf_mnt_ems203) &then
                       ord-manut.vl-cont-acum = 0.
                      &else
                       ord-manut.dec-1 = 0.
                      &endif
                 
          end.
          
          assign ord-manut.estado       = 6
                 ord-manut.estado-om    = 2
                 ord-manut.om-encerrada = no
                 ord-manut.dt-fecham    = ?
                 l-disp                 = yes.
                 
                 
          &if defined (bf_mnt_ems203) &then
             assign ord-manut.valorizada = no.
          &endif    

          find first ord-prod where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ
               exclusive-lock no-error.
          if avail ord-prod then     
               assign ord-prod.valorizada = no.
                           
          
          {mip/mi0314.i "yes" "100"}  /* realoca as especialidades */ 
       end.
    end.

    IF VALID-HANDLE(hBoSincroniz) THEN
        DELETE OBJECT hBoSincroniz.
        
    IF VALID-HANDLE(hDBOOrdProd) THEN
        DELETE OBJECT hDBOOrdProd. 

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

    IF VALID-HANDLE(h_api_cta_ctbl) THEN
        DELETE OBJECT h_api_cta_ctbl.

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
  disable all with frame {&frame-name}.
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
   FIND FIRST ord-prod 
        where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock no-error.
   if avail ord-prod then
      assign c-conta-ordem = ord-prod.ct-codigo
             fi-ccusto     = ord-prod.sc-codigo
             i-calc-cs-ggf = ord-prod.calc-cs-ggf
             i-reporte-ggf = ord-prod.reporte-ggf
             i-calc-cs-mat = ord-prod.calc-cs-mat
             i-calc-cs-mob = ord-prod.calc-cs-mob
             i-reporte-mob = ord-prod.reporte-mob
             l-valorizada  = ord-prod.valorizada.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  disp l-valorizada with frame {&frame-name}.
  IF AVAIL ord-manut THEN
      if ord-manut.estado = 8 then
        assign l-estado = yes.
      else
        assign l-estado = no.
  disp l-estado with frame {&frame-name}.

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

  apply "value-changed" to l-estado in frame {&frame-name}.

  enable l-estado with frame {&frame-name}.

  find first ord-prod
       where ord-prod.nr-ord-produ = ord-manut.nr-ord-produ exclusive-lock no-error.
  if avail ord-prod then do:      
      &IF DEFINED (bf_man_linha_estab) &THEN
      find first lin-prod
           where lin-prod.cod-estabel = ord-prod.cod-estabel
             and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.                
      &ELSE
      find first lin-prod
           where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
      &ENDIF  
   
  end.       
     
    run notify ('pi-atualiza-estado, group-assign-target').
    
    if l-estado = yes then do:
       if ord-manut.dt-fecham = ? then do:
          disp today @ ord-manut.dt-fecham with frame {&frame-name}.
          enable ord-manut.dt-fecham with frame {&frame-name}.
          RUN notify ('pi-desabilita,group-assign-target':U).
       end.
    end.
    else do:
      if available(ord-manut) then do:
        assign ord-manut.dt-fecham:screen-value in frame {&frame-name} = ?.
        disable ord-manut.dt-fecham with frame {&frame-name}.
        RUN notify ('pi-habilita,group-assign-target':U).
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-open-query V-table-Win 
PROCEDURE local-open-query :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  &if defined (bf_mnt_ems203) &then
    find first ord-prod 
         where ord-prod.nr-ord-prod = ord-manut.nr-ord-prod exclusive-lock no-error.
  &endif       
     
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'open-query':U ) .

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
  
  if l-estado = yes then 
     assign da-data = ord-manut.dt-fecham.
  else
     assign da-data = ?.
     
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estado V-table-Win 
PROCEDURE pi-atualiza-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

  {utp/ut-liter.i atualizaá∆o * r}
  run utp/ut-msgs.p (input "show",
                     input 701,
                     input trim(return-value)).
  if return-value = "no" then return 'adm-error'.
     
  &if defined (bf_mnt_calib) &then
      FIND FIRST ord-manut 
          WHERE ord-manut.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK NO-ERROR.
      IF &IF DEFINED (bf_mnt_ems205) &THEN
                  param-global.log-modul-calib 
              &else
                  substr(param-global.char-2,100,1) = "2" 
              &endif
      AND AVAIL ord-manut 
        &IF DEFINED (bf_mnt_ems208) &THEN
                        AND ord-manut.tp-manut = 3 
        &else
                        AND ord-manut.dec-1 = 3
        &endif
        THEN DO:
          IF ord-manut.estado < 8 
          AND l-estado:checked in frame {&frame-name} = YES THEN DO:
              /* encerramento */
              if ord-manut.estado = 1 THEN DO:
                  {utp/ut-table.i mgind ord-prod 1}
                  run utp/ut-msgs.p("show", 28075, return-value).    /* ordem de calibracao nao liberada*/
                  return 'ADM-ERROR':U.
              END.
              ELSE  DO:
                  for each tt-erro:
                      delete tt-erro.
                  end.
                  for each tt-apont-calib:
                      delete tt-apont-calib.
                  end.
                  create tt-apont-calib.
                  assign tt-apont-calib.nr-ord-produ = ord-manut.nr-ord-produ
                         tt-apont-calib.cd-equipto   = ord-manut.cd-equipto
                         tt-apont-calib.acao         = 6 /* encerra */
                         tt-apont-calib.cod-versao-integracao = 001.
                  RUN gcp/gcapi002.p(input table tt-apont-calib,
                                                input        table tt-ord-gerada,
                                                input-output table tt-erro,
                                                input  NO ) .
                  if can-find (first tt-erro) then do:
                     run cdp/cd0666.w (input table tt-erro).
                     return 'ADM-ERROR':U.
                  END.
              END.
          END.
          IF ord-manut.estado >= 8 
          AND l-estado:CHECKED in frame {&frame-name} = no THEN DO:
              /* abertura */
                  {utp/ut-table.i mgind ord-prod 1}
                  run utp/ut-msgs.p("show", 28082, return-value). /* ordem de calibracao nao pode ser reaberta*/
                  return 'ADM-ERROR':U.
          END.
      END.
  &endif
    
  if c-conta-ordem:sensitive in frame {&frame-name} = yes then do:
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
	run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input string(param-global.empresa-prin),  /* EMPRESA EMS 2 */
											  input "",                                      /* PLANO DE CONTAS */
                                              input	input frame {&frame-name} c-conta-ordem, /* CONTA */
                                              input ord-prod.dt-emissao,                     /* DATA TRANSACAO */   
                                              output v_des_cta_ctbl,                         /* DESCRICAO CONTA */
                                              output v_num_tip_cta_ctbl,                     /* TIPO DA CONTA */
                                              output v_num_sit_cta_ctbl,                     /* SITUA∞ÄO DA CONTA */
                                              output v_ind_finalid_cta,                      /* FINALIDADES DA CONTA */
                                              output table tt_log_erro). 
	/** Busca finalidade conforme m¢dulo CEP **/
	RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        string(param-global.empresa-prin), /* EMPRESA EMS2 */ 
														  INPUT        "CEP"                  ,  /* MÖDULO                */
														  INPUT        ""                     ,  /* PLANO DE CONTAS       */ 
														  INPUT       input frame {&frame-name} c-conta-ordem ,  /* CONTA */ 
														  INPUT        TODAY                  ,  /* DATA TRANSACAO        */ 
														  OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */
														  OUTPUT table tt_log_erro APPEND     ). /* ERROS                 */												  


    if can-find(first tt_log_erro) then do:
        {cdp/cdunif001b.i1}
        apply "entry" to c-conta-ordem.
        return error.
    end.

    if v_num_sit_cta_ctbl <> 3 then do:
      run utp/ut-msgs.p (input "show",
                         input 638,
                         input c-conta-ordem:screen-value).
      apply "entry" to c-conta-ordem.
      return error.
    end.
    if v_num_tip_cta_ctbl <> 4 and v_num_tip_cta_ctbl <> 5 then do:
      run utp/ut-msgs.p (input "show",
                         input 638,
                         input c-conta-ordem:screen-value).
      apply "entry" to c-conta-ordem.
      return error.
    end.


    if param-global.modulo-ce = YES then do : 
        DEFINE VARIABLE v_cod_des_finalidades AS CHARACTER.
		RUN cdp/cdunif004.p (INPUT "1,2,3,5,6", OUTPUT v_cod_des_finalidades).
        if lookup(string(v_ind_finalid_cta),v_cod_des_finalidades) = 0 then do: 
                run utp/ut-msgs.p (input "show",
                             input 1884,
                             input c-conta-ordem:screen-value).
               apply "entry" to c-conta-ordem.
               return error.
            end.
         end.                  
  end. 
 
if valid-handle(h_api_cta_ctbl) then
	delete object h_api_cta_ctbl.	
	
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
  {src/adm/template/snd-list.i "ord-manut"}

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

