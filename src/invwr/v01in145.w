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
{include/i-prgvrs.i V01IN145 2.00.00.024 } /*** 010024 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in145 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var gr-estabelec  as rowid no-undo.
def new global shared var l-estab-comum as logical  no-undo.

/* Centro de Custo X Estabelecimento */
{cdp/cd0110.i}

def var v-row-parent as rowid no-undo.
def buffer b-gm-estab for gm-estab.
DEF VAR c-estabel LIKE gm-estab.cod-estabel.
DEF VAR c-nome LIKE estabelec.nome.
DEF BUFFER b-centro-custo FOR centro-custo.
DEF BUFFER b-ccusto-estab FOR ccusto-estab.

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}  
define variable c-ep-codigo-usuario as character no-undo.

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
&Scoped-define EXTERNAL-TABLES gm-estab
&Scoped-define FIRST-EXTERNAL-TABLE gm-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR gm-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS gm-estab.cod-estabel gm-estab.cc-codigo 
&Scoped-define ENABLED-TABLES gm-estab
&Scoped-define FIRST-ENABLED-TABLE gm-estab
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS gm-estab.cod-estabel gm-estab.cc-codigo 
&Scoped-define DISPLAYED-TABLES gm-estab
&Scoped-define FIRST-DISPLAYED-TABLE gm-estab
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-desc-cc 

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
DEFINE VARIABLE c-desc-cc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 78 BY 2.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     gm-estab.cc-codigo AT ROW 1.17 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 20.14 BY .88
     c-desc-cc AT ROW 1.17 COL 36 COLON-ALIGNED NO-LABEL
     gm-estab.cod-estabel AT ROW 2.17 COL 15 COLON-ALIGNED
          VIEW-AS FILL-IN
          SIZE 7.14 BY .88
     c-desc-estab AT ROW 2.17 COL 22.86 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.gm-estab
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
         HEIGHT             = 2.5
         WIDTH              = 78.43.
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

/* SETTINGS FOR FILL-IN c-desc-cc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
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

&Scoped-define SELF-NAME gm-estab.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cc-codigo V-table-Win
ON F5 OF gm-estab.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  find first estabelec
       where estabelec.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel no-lock no-error.
  if avail estabelec then
     assign gr-estabelec = rowid(estabelec)
            c-desc-estab = estabelec.nome.
  
  if input frame {&frame-name} gm-estab.cod-estabel = "*" then do :
     assign l-estab-comum = yes .
  end.          
  else
     assign l-estab-comum = no.
            
  assign l-implanta = yes.
    ASSIGN c-estabel = gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
           c-nome  = c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF l-funcao-ccusto-estab THEN DO:
        RUN pi-zoom-ccusto-estab.
    END. ELSE DO:
        {include/zoomvar.i &prog-zoom="inzoom/z01in042.w"
                     &campo=gm-estab.cc-codigo
                     &campozoom=cc-codigo
                     &campo2=c-desc-cc
                     &campozoom2=descricao
                     &campo3=gm-estab.cod-estabel
                     &campozoom3=cod-estabel
                     &campo4=c-desc-estab
                     &campozoom4=nome}    
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cc-codigo V-table-Win
ON LEAVE OF gm-estab.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    
    ASSIGN c-estabel = gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
    
    {include/leave.i &tabela=centro-custo
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-cc
                     &atributo-ref=cod-estabel
                     &atributo-ref=nome
                     &variavel-ref=c-desc-estab
                     &where="centro-custo.cc-codigo = input frame {&frame-name} gm-estab.cc-codigo"}  
    
    IF INPUT FRAME {&FRAME-NAME} gm-estab.cod-estabel = "" AND c-estabel <> "" THEN
        ASSIGN gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-estabel.
               c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome.
    
    FIND FIRST estabelec 
         WHERE estabelec.cod-estabel = gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = estabelec.nome.
    
    if not l-funcao-ccusto-estab then do:
        FIND FIRST b-centro-custo
            WHERE b-centro-custo.cc-codigo = gm-estab.cc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
        IF AVAIL b-centro-custo THEN DO:
            ASSIGN gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = b-centro-custo.cod-estabel.
        END.
    end.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gm-estab.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME gm-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cod-estabel V-table-Win
ON ENTRY OF gm-estab.cod-estabel IN FRAME f-main /* Estabel */
DO:
  IF INPUT FRAME {&FRAME-NAME} gm-estab.cod-estabel = "" AND c-estabel <> "" THEN
        ASSIGN gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-estabel
               c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nome .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cod-estabel V-table-Win
ON F5 OF gm-estab.cod-estabel IN FRAME f-main /* Estabel */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=gm-estab.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-desc-estab
                     &campozoom2=nome}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cod-estabel V-table-Win
ON LEAVE OF gm-estab.cod-estabel IN FRAME f-main /* Estabel */
DO:
    
    
    IF input frame {&frame-name} gm-estab.cod-estabel = "*" THEN DO:
        {utp/ut-liter.i "Comum_a_Todos_os_Estabelecimentos" *}
        ASSIGN c-desc-estab = RETURN-VALUE.
        
        DISP c-desc-estab WITH FRAME f-main.
        
    END. ELSE DO:
        {include/leave.i &tabela=estabelec
                         &atributo-ref=nome
                         &variavel-ref=c-desc-estab
                         &where="estabelec.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel"}  
	END.
	
	find estabelec
		where estabelec.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel no-lock no-error.
	if  avail estabelec then
		assign c-ep-codigo-usuario = estabelec.ep-codigo.
	else
		assign c-ep-codigo-usuario = "".
	
	if not valid-handle(h_api_ccusto) then 
		run prgint/utb/utb742za.py persistent set h_api_ccusto.
	
	run pi_retorna_formato_ccusto in h_api_ccusto (INPUT c-ep-codigo-usuario,
												   INPUT "",
												   INPUT TODAY,
												   OUTPUT p_cod_format_ccusto,
												   OUTPUT TABLE tt_log_erro).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL gm-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF gm-estab.cod-estabel IN FRAME f-main /* Estabel */
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
  

  if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
  

  /************************ INTERNAL PROCEDURES ********************/
  if gm-estab.cod-estabel:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name}  then.
  if gm-estab.cc-codigo:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name}  then.

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

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "gm-estab"}

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

	find first gm-estab where gm-estab.gm-codigo   = grup-maquina.gm-codigo and
							  gm-estab.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel no-lock no-error.
	if avail gm-estab then do:
		{utp/ut-table.i mgind gm-estab 01}
		run utp/ut-msgs.p (input 'show':u,
						   input 1,
						   input return-value).
		return 'adm-error':u.
	end.

	if input frame {&frame-name} gm-estab.cod-estabel <> "*" then do:
		
		find first gm-estab 
			where gm-estab.cod-estabel = "*"
			and  gm-estab.gm-codigo = grup-maquina.gm-codigo  no-lock no-error.
		if avail gm-estab then do :
			run utp/ut-msgs.p (input 'show',
							   input 26926,
							   input return-value).
			return 'ADM-ERROR':U.
		end.

		find first estabelec
			 where estabelec.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel no-lock no-error.
		if  not avail estabelec then do:
			  {utp/ut-table.i mgadm estabelec 01}
			  run utp/ut-msgs.p (input 'show',
								 input 56,
								 input return-value).
			  apply 'entry' to gm-estab.cod-estabel in frame {&frame-name}.
			  return 'ADM-ERROR':U.
		end.
		
		IF l-funcao-ccusto-estab THEN DO:
			find first ccusto-estab
				 where ccusto-estab.cc-codigo    = input frame {&frame-name} gm-estab.cc-codigo 
				   and (ccusto-estab.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel /*
					 or ccusto-estab.cod-estabel = "*" */ ) no-lock no-error.
			if  not avail ccusto-estab then do:
				{utp/ut-table.i mgind ccusto-estab 01}
				run utp/ut-msgs.p (input 'show',
								   input 56,
								   input return-value).
				apply 'entry' to gm-estab.cod-estabel in frame {&frame-name}.
				return 'ADM-ERROR':U.
			end.
		end.
		else do:
			find first centro-custo
				 where centro-custo.cc-codigo   = input frame {&frame-name} gm-estab.cc-codigo
				 and   centro-custo.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel no-lock no-error.
			if  not avail centro-custo then do:
				{utp/ut-table.i mgind centro-custo 01}
				run utp/ut-msgs.p (input 'show',
								   input 56,
								   input return-value).
				apply 'entry' to gm-estab.cc-codigo in frame {&frame-name}.
				return 'ADM-ERROR':U.
			end.
		end.
	end.
	if input frame {&frame-name} gm-estab.cod-estabel = "*" then do:
		find first gm-estab where
				   gm-estab.cod-estabel <> "*" and
				   gm-estab.gm-codigo = grup-maquina.gm-codigo no-lock no-error.
		if avail gm-estab then do:
			 {utp/ut-table.i mgind gm-estab 01}
			 run utp/ut-msgs.p (input 'show',
							   input 26930,
							   input return-value).
			 return 'ADM-ERROR':U.
		end.
		
		IF l-funcao-ccusto-estab THEN DO:
			find first ccusto-estab
				 where ccusto-estab.cc-codigo    = input frame {&frame-name} gm-estab.cc-codigo 
				   and (ccusto-estab.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel /*
					 or ccusto-estab.cod-estabel = "*" */ ) no-lock no-error.        
			if  not avail ccusto-estab then do:
				{utp/ut-table.i mgind ccusto-estab 01}
				run utp/ut-msgs.p (input 'show',
								   input 56,
								   input return-value).
				apply 'entry' to gm-estab.cod-estabel in frame {&frame-name}.
				return 'ADM-ERROR':U.
			end.
		end.
		else do:
			find first centro-custo
				 where centro-custo.cc-codigo   = input frame {&frame-name} gm-estab.cc-codigo
				 and   centro-custo.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel no-lock no-error.
			if  not avail centro-custo then do:
				{utp/ut-table.i mgind centro-custo 01}
				run utp/ut-msgs.p (input 'show',
								   input 56,
								   input return-value).
				apply 'entry' to gm-estab.cc-codigo in frame {&frame-name}.
				return 'ADM-ERROR':U.
			end.
		end.
	end.
	   
	/* Dispatch standard ADM method.                             */
	RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
	if RETURN-VALUE = 'ADM-ERROR':U then
		return 'ADM-ERROR':U.

	/* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
	/* Code placed here will execute AFTER standard behavior.    */

	if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.
		
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail gm-estab then
     assign gm-estab.gm-codigo = grup-maquina.gm-codigo.
     
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
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
    find first grup-maquina
         where rowid(grup-maquina) = v-row-parent no-lock no-error.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-zoom-ccusto-estab V-table-Win
PROCEDURE pi-zoom-ccusto-estab :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
  if input frame {&frame-name} gm-estab.cod-estabel = "*" then do :
     assign l-estab-comum = yes .
  end.
  else
     assign l-estab-comum = no.

  assign l-implanta = yes.
  ASSIGN c-estabel = gm-estab.cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
         c-nome  = c-desc-estab:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  {include/zoomvar.i &prog-zoom="inzoom/z01in734.w"
               &campo=gm-estab.cc-codigo
               &campozoom=cc-codigo
               &campo2=c-desc-cc
               &campozoom2=descricao
               &campo3=gm-estab.cod-estabel
               &campozoom3=cod-estabel
               &campo4=c-desc-estab
               &campozoom4=nome}

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

/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/
 
	if not can-find(first centro-custo 
					where centro-custo.cc-codigo = input frame {&frame-name} gm-estab.cc-codigo) then do:
		{utp/ut-table.i mgind centro-custo 01}
		run utp/ut-msgs.p (input "show":U, 
						   input 56, 
						   input return-value).
		return 'ADM-ERROR':U.
	end.
	
	IF l-funcao-ccusto-estab THEN DO:
		if not can-find(first ccusto-estab 
						where ccusto-estab.cc-codigo  = input frame {&frame-name} gm-estab.cc-codigo
						and (ccusto-estab.cod-estabel = input frame {&frame-name} gm-estab.cod-estabel
						or ccusto-estab.cod-estabel = "*")) then do:
			{utp/ut-table.i mgind ccusto-estab 01}
			run utp/ut-msgs.p (input "show":U, 
							   input 56, 
							   input return-value).
			return 'ADM-ERROR':U.
		end.
	end.
	else do:
		if centro-custo.cod-estabel <> input frame {&frame-name} gm-estab.cod-estabel then do:
			{utp/ut-table.i mgind ccusto-estab 01}
			run utp/ut-msgs.p (input "show":U, 
							   input 56, 
							   input return-value).
			return 'ADM-ERROR':U.
		end.
	end.
 
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

