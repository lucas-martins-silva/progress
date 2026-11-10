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
{include/i-prgvrs.i V03IN117 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v03in117 MUT}
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

def new global shared var v-row-parent as rowid no-undo.                                

{cdp/cdcfgmat.i} 
{cdp/cdcfgman.i} 

/** Unificaá∆o de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}  


def var i-aux as int no-undo.
&IF "{&mguni_version}" >= "2.071" &THEN
def var i-empresa-prin LIKE empresa.ep-codigo no-undo.
&ELSE
def var i-empresa-prin as integer no-undo.
&ENDIF

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
&Scoped-define EXTERNAL-TABLES centro-custo
&Scoped-define FIRST-EXTERNAL-TABLE centro-custo


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR centro-custo.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS centro-custo.tempo-ggf ~
centro-custo.ct-codigo[1] centro-custo.sc-codigo[1] ~
centro-custo.ct-codigo[2] centro-custo.sc-codigo[2] ~
centro-custo.ct-codigo[3] centro-custo.sc-codigo[3] ~
centro-custo.ct-codigo[4] centro-custo.sc-codigo[4] ~
centro-custo.ct-codigo[5] centro-custo.sc-codigo[5] ~
centro-custo.ct-codigo[6] centro-custo.sc-codigo[6] 
&Scoped-define ENABLED-TABLES centro-custo
&Scoped-define FIRST-ENABLED-TABLE centro-custo
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-8 
&Scoped-Define DISPLAYED-FIELDS centro-custo.tempo-ggf ~
centro-custo.ct-codigo[1] centro-custo.sc-codigo[1] ~
centro-custo.ct-codigo[2] centro-custo.sc-codigo[2] ~
centro-custo.ct-codigo[3] centro-custo.sc-codigo[3] ~
centro-custo.ct-codigo[4] centro-custo.sc-codigo[4] ~
centro-custo.ct-codigo[5] centro-custo.sc-codigo[5] ~
centro-custo.ct-codigo[6] centro-custo.sc-codigo[6] 
&Scoped-define DISPLAYED-TABLES centro-custo
&Scoped-define FIRST-DISPLAYED-TABLE centro-custo
&Scoped-Define DISPLAYED-OBJECTS c-texto1 c-texto2 

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
DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 23 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.43 BY 3.21.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 53.23 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     centro-custo.ct-codigo[1] AT ROW 2 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.sc-codigo[1] AT ROW 2 COL 31.47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.ct-codigo[2] AT ROW 3 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.sc-codigo[2] AT ROW 3 COL 31.47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.ct-codigo[3] AT ROW 4 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.sc-codigo[3] AT ROW 4 COL 31.47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.ct-codigo[4] AT ROW 5 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.sc-codigo[4] AT ROW 5 COL 31.47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.ct-codigo[5] AT ROW 6 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.sc-codigo[5] AT ROW 6 COL 31.47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.ct-codigo[6] AT ROW 7 COL 11 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     centro-custo.sc-codigo[6] AT ROW 7 COL 31.47 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
    centro-custo.tempo-ggf AT ROW 1.88 COL 58 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Horas Homem", 1,
"Horas M†quina", 2
          SIZE 25.43 BY 2.08
    c-texto1 AT ROW 1 COL 1 COLON-ALIGNED NO-LABEL
     c-texto2 AT ROW 1.08 COL 53.23 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1.25 COL 1
     RECT-8 AT ROW 1.29 COL 55
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.centro-custo
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 7.42
         WIDTH              = 85.29.
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

/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
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

&Scoped-define SELF-NAME centro-custo.ct-codigo[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[1] V-table-Win
ON ENTRY OF centro-custo.ct-codigo[1] IN FRAME f-main /* Conta[1] */
DO:
  ASSIGN centro-custo.ct-codigo[1]:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[1] V-table-Win
ON F5 OF centro-custo.ct-codigo[1] IN FRAME f-main /* Conta[1] */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.

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
	if v_cod_cta_ctbl <> "" then
		ASSIGN centro-custo.ct-codigo[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
			 
	          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[1] V-table-Win
ON LEAVE OF centro-custo.ct-codigo[1] IN FRAME f-main /* Conta[1] */
DO:
   IF centro-custo.cod-estabel <> "*" THEN DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[1] centro-custo.sc-codigo[1] {&FRAME-NAME} TODAY i-empresa-prin centro-custo.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[1] centro-custo.sc-codigo[1] {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[1] wWindow
ON LEAVE OF centro-custo.sc-codigo[1] IN FRAME f-main
DO:
   {cdp/cdunif001d.i centro-custo.sc-codigo[1] {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[1] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.ct-codigo[1] IN FRAME f-main /* Conta[1] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.ct-codigo[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[2] V-table-Win
ON ENTRY OF centro-custo.ct-codigo[2] IN FRAME f-main /* Conta[2] */
DO:
  ASSIGN centro-custo.ct-codigo[2]:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[2] V-table-Win
ON F5 OF centro-custo.ct-codigo[2] IN FRAME f-main /* Conta[2] */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.

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
    if v_cod_cta_ctbl <> "" then
		ASSIGN centro-custo.ct-codigo[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
             
	                            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[2] V-table-Win
ON LEAVE OF centro-custo.ct-codigo[2] IN FRAME f-main /* Conta[2] */
DO:
    IF centro-custo.cod-estabel <> "*" THEN DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[2] centro-custo.sc-codigo[2] {&FRAME-NAME} TODAY i-empresa-prin centro-custo.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[2] centro-custo.sc-codigo[2] {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[2] wWindow
ON LEAVE OF centro-custo.sc-codigo[2] IN FRAME f-main
DO:
   {cdp/cdunif001d.i centro-custo.sc-codigo[2] {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[2] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.ct-codigo[2] IN FRAME f-main /* Conta[2] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.ct-codigo[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[3] V-table-Win
ON ENTRY OF centro-custo.ct-codigo[3] IN FRAME f-main /* Conta[3] */
DO:
  ASSIGN centro-custo.ct-codigo[3]:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[3] V-table-Win
ON F5 OF centro-custo.ct-codigo[3] IN FRAME f-main /* Conta[3] */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.
         
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
    if v_cod_cta_ctbl <> "" then
            ASSIGN centro-custo.ct-codigo[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
    	                                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[3] V-table-Win
ON LEAVE OF centro-custo.ct-codigo[3] IN FRAME f-main /* Conta[3] */
DO:
    IF centro-custo.cod-estabel <> "*" THEN DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[3] centro-custo.sc-codigo[3] {&FRAME-NAME} TODAY i-empresa-prin centro-custo.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[3] centro-custo.sc-codigo[3] {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[3] wWindow
ON LEAVE OF centro-custo.sc-codigo[3] IN FRAME f-main
DO:
   {cdp/cdunif001d.i centro-custo.sc-codigo[3] {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[3] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.ct-codigo[3] IN FRAME f-main /* Conta[3] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.ct-codigo[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[4] V-table-Win
ON ENTRY OF centro-custo.ct-codigo[4] IN FRAME f-main /* Conta[4] */
DO:
  ASSIGN centro-custo.ct-codigo[4]:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[4] V-table-Win
ON F5 OF centro-custo.ct-codigo[4] IN FRAME f-main /* Conta[4] */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.

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
    if v_cod_cta_ctbl <> "" then
		ASSIGN centro-custo.ct-codigo[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
    	
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[4] V-table-Win
ON LEAVE OF centro-custo.ct-codigo[4] IN FRAME f-main /* Conta[4] */
DO:
   IF centro-custo.cod-estabel <> "*" THEN DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[4] centro-custo.sc-codigo[4] {&FRAME-NAME} TODAY i-empresa-prin centro-custo.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[4] centro-custo.sc-codigo[4] {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[4] wWindow
ON LEAVE OF centro-custo.sc-codigo[4] IN FRAME f-main
DO:
   {cdp/cdunif001d.i centro-custo.sc-codigo[4] {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[4] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.ct-codigo[4] IN FRAME f-main /* Conta[4] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.ct-codigo[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[5] V-table-Win
ON ENTRY OF centro-custo.ct-codigo[5] IN FRAME f-main /* Conta[5] */
DO:
  ASSIGN centro-custo.ct-codigo[5]:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[5] V-table-Win
ON F5 OF centro-custo.ct-codigo[5] IN FRAME f-main /* Conta[5] */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.

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
    if v_cod_cta_ctbl <> "" then
		ASSIGN centro-custo.ct-codigo[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
    	               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[5] V-table-Win
ON LEAVE OF centro-custo.ct-codigo[5] IN FRAME f-main /* Conta[5] */
DO:
    IF centro-custo.cod-estabel <> "*" THEN DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[5] centro-custo.sc-codigo[5] {&FRAME-NAME} TODAY i-empresa-prin centro-custo.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[5] centro-custo.sc-codigo[5] {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[5] wWindow
ON LEAVE OF centro-custo.sc-codigo[5] IN FRAME f-main
DO:
   {cdp/cdunif001d.i centro-custo.sc-codigo[5] {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[5] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.ct-codigo[5] IN FRAME f-main /* Conta[5] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.ct-codigo[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[6] V-table-Win
ON ENTRY OF centro-custo.ct-codigo[6] IN FRAME f-main /* Conta[6] */
DO:
  ASSIGN centro-custo.ct-codigo[6]:FORMAT IN FRAME {&FRAME-NAME} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[6] V-table-Win
ON F5 OF centro-custo.ct-codigo[6] IN FRAME f-main /* Conta[6] */
DO:
  assign i-ep-codigo-usuario = i-empresa-prin
         l-implanta          = yes.

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
	if v_cod_cta_ctbl <> "" then
		ASSIGN centro-custo.ct-codigo[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
	                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[6] V-table-Win
ON LEAVE OF centro-custo.ct-codigo[6] IN FRAME f-main /* Conta[6] */
DO:
   IF centro-custo.cod-estabel <> "*" THEN DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[6] centro-custo.sc-codigo[6] {&FRAME-NAME} TODAY i-empresa-prin centro-custo.cod-estabel}
    END.
    ELSE DO:
        {cdp/cdunif001a.i centro-custo.ct-codigo[6] centro-custo.sc-codigo[6] {&FRAME-NAME} TODAY """" """"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[6] wWindow
ON LEAVE OF centro-custo.sc-codigo[6] IN FRAME f-main
DO:
   {cdp/cdunif001d.i centro-custo.sc-codigo[6] {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.ct-codigo[6] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.ct-codigo[6] IN FRAME f-main /* Conta[6] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.sc-codigo[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[1] V-table-Win
ON F5 OF centro-custo.sc-codigo[1] IN FRAME f-main /* SC[1] */
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
                ASSIGN centro-custo.sc-codigo[1]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[1] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.sc-codigo[1] IN FRAME f-main /* SC[1] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.sc-codigo[2]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[2] V-table-Win
ON F5 OF centro-custo.sc-codigo[2] IN FRAME f-main /* SC[2] */
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
                ASSIGN centro-custo.sc-codigo[2]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[2] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.sc-codigo[2] IN FRAME f-main /* SC[2] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.sc-codigo[3]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[3] V-table-Win
ON F5 OF centro-custo.sc-codigo[3] IN FRAME f-main /* SC[3] */
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
                ASSIGN centro-custo.sc-codigo[3]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
    
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[3] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.sc-codigo[3] IN FRAME f-main /* SC[3] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.sc-codigo[4]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[4] V-table-Win
ON F5 OF centro-custo.sc-codigo[4] IN FRAME f-main /* SC[4] */
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
                ASSIGN centro-custo.sc-codigo[4]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[4] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.sc-codigo[4] IN FRAME f-main /* SC[4] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.sc-codigo[5]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[5] V-table-Win
ON F5 OF centro-custo.sc-codigo[5] IN FRAME f-main /* SC[5] */
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
                ASSIGN centro-custo.sc-codigo[5]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[5] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.sc-codigo[5] IN FRAME f-main /* SC[5] */
DO:
    apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME centro-custo.sc-codigo[6]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[6] V-table-Win
ON F5 OF centro-custo.sc-codigo[6] IN FRAME f-main /* SC[6] */
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
                ASSIGN centro-custo.sc-codigo[6]:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL centro-custo.sc-codigo[6] V-table-Win
ON MOUSE-SELECT-DBLCLICK OF centro-custo.sc-codigo[6] IN FRAME f-main /* SC[6] */
DO:
    apply "F5" to self.
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

    assign v_cod_finalid = {adinc/i05ad049.i 4 5}. /* Mao de Obra - GGF */
        
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

find first param-global no-lock no-error.
find first param-cs no-lock no-error.

assign i-empresa-prin = param-global.empresa-prin.

assign centro-custo.ct-codigo[1]:label  in frame {&frame-name} = param-cs.ocorrencia[1]
       centro-custo.ct-codigo[2]:label  in frame {&frame-name} = param-cs.ocorrencia[2]
       centro-custo.ct-codigo[3]:label  in frame {&frame-name} = param-cs.ocorrencia[3]
       centro-custo.ct-codigo[4]:label  in frame {&frame-name} = param-cs.ocorrencia[4]
       centro-custo.ct-codigo[5]:label  in frame {&frame-name} = param-cs.ocorrencia[5]
       centro-custo.ct-codigo[6]:label  in frame {&frame-name} = param-cs.ocorrencia[6].
       
{utp/ut-rtlbl.i mgind centro-custo ct-codigo c-texto1}
{utp/ut-rtlbl.i mgind centro-custo tempo-ggf c-texto2}

if centro-custo.ct-codigo[1]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.ct-codigo[2]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.ct-codigo[3]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.ct-codigo[4]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.ct-codigo[5]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.ct-codigo[6]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

if centro-custo.sc-codigo[1]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.sc-codigo[2]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.sc-codigo[3]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.sc-codigo[4]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.sc-codigo[5]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.
if centro-custo.sc-codigo[6]:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "centro-custo"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "centro-custo"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  if  param-cs.ocorrencia[1] <> "" then
      enable centro-custo.ct-codigo[1] with frame {&frame-name}.
  if  param-cs.ocorrencia[2] <> "" then
      enable centro-custo.ct-codigo[2] with frame {&frame-name}.
  if  param-cs.ocorrencia[3] <> "" then
      enable centro-custo.ct-codigo[3] with frame {&frame-name}.
  if  param-cs.ocorrencia[4] <> "" then
      enable centro-custo.ct-codigo[4] with frame {&frame-name}.
  if  param-cs.ocorrencia[5] <> "" then
      enable centro-custo.ct-codigo[5] with frame {&frame-name}.
  if  param-cs.ocorrencia[6] <> "" then
      enable centro-custo.ct-codigo[6] with frame {&frame-name}.
  
  enable centro-custo.tempo-ggf with frame {&frame-name}.

  /*assign centro-custo.ct-codigo[1]:format  in frame {&frame-name} = p_cod_format_cta_ctbl
       centro-custo.ct-codigo[2]:format  in frame {&frame-name} = p_cod_format_cta_ctbl
       centro-custo.ct-codigo[3]:format  in frame {&frame-name} = p_cod_format_cta_ctbl
       centro-custo.ct-codigo[4]:format  in frame {&frame-name} = p_cod_format_cta_ctbl
       centro-custo.ct-codigo[5]:format  in frame {&frame-name} = p_cod_format_cta_ctbl
       centro-custo.ct-codigo[6]:format  in frame {&frame-name} = p_cod_format_cta_ctbl.*/
	   
	apply "leave":u to centro-custo.ct-codigo[1]  in frame {&frame-name}.
	apply "leave":u to centro-custo.ct-codigo[2]  in frame {&frame-name}.
	apply "leave":u to centro-custo.ct-codigo[3]  in frame {&frame-name}.
	apply "leave":u to centro-custo.ct-codigo[4]  in frame {&frame-name}.
	apply "leave":u to centro-custo.ct-codigo[5]  in frame {&frame-name}.
	apply "leave":u to centro-custo.ct-codigo[6]  in frame {&frame-name}.
       
        /*DEFINE VARIABLE accountIterator AS INTEGER NO-UNDO.
        
        do accountIterator = 1 to 6:
			if not valid-handle(h_api_ccusto) 
				then run prgint/utb/utb742za.py persistent set h_api_ccusto.
			IF INPUT FRAME {&frame-name} centro-custo.ct-codigo[accountIterator] <> "" THEN DO:
				run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
																   INPUT "",
																   INPUT "",
																   INPUT FRAME {&frame-name} centro-custo.ct-codigo[accountIterator],
																   INPUT today,
																   OUTPUT p_log_ccusto,
																   OUTPUT TABLE tt_log_erro).
																   
				/* Necessario fazer CASE, centro-custo.sc-codigo[accountIterator] ocorre erro na compilacao */
				case accountIterator:
					when 1 then
							ASSIGN centro-custo.sc-codigo[1]:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
					when 2 then
							ASSIGN centro-custo.sc-codigo[2]:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
					when 3 then
							ASSIGN centro-custo.sc-codigo[3]:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
					when 4 then
							ASSIGN centro-custo.sc-codigo[4]:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
					when 5 then
							ASSIGN centro-custo.sc-codigo[5]:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
					when 6 then
							ASSIGN centro-custo.sc-codigo[6]:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
				end.
			END.
        end.*/
		
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
  assign i-empresa-prin = param-global.empresa-prin.

  find first estabelec
       where estabelec.cod-estabel = centro-custo.cod-estabel no-lock no-error.
  if avail estabelec then
     run cdp/cd9970.p (input rowid(estabelec),
                       output i-empresa-prin).

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

  do i-aux = 1 to 6: 
     if  param-cs.ocorrencia[i-aux] <> "" then do:
         
         /* Retorna Dados da Conta. */
         if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
         
         DEFINE VARIABLE c-conta AS CHARACTER   NO-UNDO.
         DEFINE VARIABLE c-ccusto AS CHARACTER  NO-UNDO.
         ASSIGN c-conta  = input frame {&frame-name} centro-custo.ct-codigo[i-aux]
                c-ccusto = input frame {&frame-name} centro-custo.sc-codigo[i-aux].

         {cdp/cdunif001c.i i-empresa-prin c-conta today}

         IF centro-custo.cod-estabel <> "*" THEN DO:

              run pi_valida_conta_contabil in h_api_cta_ctbl (input  i-empresa-prin,
                                                              input  centro-custo.cod-estabel,
                                                              input  "",
                                                              input  "",   
                                                              input  c-conta,
                                                              input  "",   
                                                              input  c-ccusto,
                                                              input  TODAY,
                                                              output table tt_log_erro append). 

         END.

         if  can-find(first tt_log_erro) then do:
             {cdp/cdunif001b.i1}

             case i-aux:
                 when 1 then apply "entry" to centro-custo.ct-codigo[1] in frame {&frame-name}.
                 when 2 then apply "entry" to centro-custo.ct-codigo[2] in frame {&frame-name}.
                 when 3 then apply "entry" to centro-custo.ct-codigo[3] in frame {&frame-name}.
                 when 4 then apply "entry" to centro-custo.ct-codigo[4] in frame {&frame-name}.
                 when 5 then apply "entry" to centro-custo.ct-codigo[5] in frame {&frame-name}.
                 when 6 then apply "entry" to centro-custo.ct-codigo[6] in frame {&frame-name}.
             end.
             return "ADM-ERROR":U.
         end.
         
         if  lookup({adinc/i05ad049.i 4 5},STRING(v_ind_finalid_cta)) = 0 then do:
             {utp/ut-liter.i G.G.F. * r}
             
             case i-aux:
                 when 1 then  run utp/ut-msgs.p (input "show",
                              input 2851,
                              input input frame {&frame-name} centro-custo.ct-codigo[1]
                                      + "~~" + trim(return-value)).
                 when 2 then  run utp/ut-msgs.p (input "show",
                              input 2851,
                              input input frame {&frame-name} centro-custo.ct-codigo[2]
                                      + "~~" + trim(return-value)).
                 when 3 then  run utp/ut-msgs.p (input "show",
                              input 2851,
                              input input frame {&frame-name} centro-custo.ct-codigo[3]
                                      + "~~" + trim(return-value)).
                 when 4 then  run utp/ut-msgs.p (input "show",
                              input 2851,
                              input input frame {&frame-name} centro-custo.ct-codigo[4]
                                      + "~~" + trim(return-value)).
                 when 5 then  run utp/ut-msgs.p (input "show",
                              input 2851,
                              input input frame {&frame-name} centro-custo.ct-codigo[5]
                                      + "~~" + trim(return-value)).
                 when 6 then  run utp/ut-msgs.p (input "show",
                              input 2851,
                              input input frame {&frame-name} centro-custo.ct-codigo[6]
                                      + "~~" + trim(return-value)).
             end.
                 
             case i-aux:
                 when 1 then apply "entry" to centro-custo.ct-codigo[1] in frame {&frame-name}.
                 when 2 then apply "entry" to centro-custo.ct-codigo[2] in frame {&frame-name}.
                 when 3 then apply "entry" to centro-custo.ct-codigo[3] in frame {&frame-name}.
                 when 4 then apply "entry" to centro-custo.ct-codigo[4] in frame {&frame-name}.
                 when 5 then apply "entry" to centro-custo.ct-codigo[5] in frame {&frame-name}.
                 when 6 then apply "entry" to centro-custo.ct-codigo[6] in frame {&frame-name}.
             end.
             return "ADM-ERROR":U.
         end. else do:

             if not valid-handle(h_api_ccusto) then 
                 run prgint/utb/utb742za.py persistent set h_api_ccusto.
                
                 case i-aux:
                     when 1 THEN ASSIGN log_controla_sensitive = centro-custo.sc-codigo[1]:SENSITIVE IN FRAME {&FRAME-NAME}.
                     when 2 THEN ASSIGN log_controla_sensitive = centro-custo.sc-codigo[2]:SENSITIVE IN FRAME {&FRAME-NAME}.
                     when 3 THEN ASSIGN log_controla_sensitive = centro-custo.sc-codigo[3]:SENSITIVE IN FRAME {&FRAME-NAME}.
                     when 4 THEN ASSIGN log_controla_sensitive = centro-custo.sc-codigo[4]:SENSITIVE IN FRAME {&FRAME-NAME}.
                     when 5 THEN ASSIGN log_controla_sensitive = centro-custo.sc-codigo[5]:SENSITIVE IN FRAME {&FRAME-NAME}.
                     when 6 THEN ASSIGN log_controla_sensitive = centro-custo.sc-codigo[6]:SENSITIVE IN FRAME {&FRAME-NAME}.
                 end.

                 IF log_controla_sensitive THEN DO:
                     run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                             INPUT "",
                                                             input input frame {&frame-name} centro-custo.sc-codigo[i-aux],
                                                             INPUT TODAY,
                                                             output p_des_titulo,
                                                             OUTPUT TABLE tt_log_erro).
                    
                     if can-find (first tt_log_erro) then do:
                         {cdp/cdunif001b.i1}
                    
                         case i-aux:
                             when 1 then apply "entry" to centro-custo.sc-codigo[1] in frame {&frame-name}.
                             when 2 then apply "entry" to centro-custo.sc-codigo[2] in frame {&frame-name}.
                             when 3 then apply "entry" to centro-custo.sc-codigo[3] in frame {&frame-name}.
                             when 4 then apply "entry" to centro-custo.sc-codigo[4] in frame {&frame-name}.
                             when 5 then apply "entry" to centro-custo.sc-codigo[5] in frame {&frame-name}.
                             when 6 then apply "entry" to centro-custo.sc-codigo[6] in frame {&frame-name}.
                         end.
        
                         return 'ADM-ERROR':U.
                     end.
                 END.

             END.
    
      END.
    END.
   
            
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
  {src/adm/template/snd-list.i "centro-custo"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .


  if valid-handle(h_api_ccusto) then
      delete procedure h_api_ccusto.
	  
  if valid-handle(h_api_cta_ctbl) then
      delete procedure h_api_cta_ctbl.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME