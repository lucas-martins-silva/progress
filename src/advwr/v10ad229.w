&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V10AD229 2.00.00.013 } /*** "010013" 25/06/2025 16:21:14  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V10AD229 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
{cdp/cdcfgdis.i}

&Scop adm-attribute-dlg support/viewerd.w
{utp/ut-glob.i}

/* miniflexibilizaá∆o */
{cdp/cdcfgfin.i}

def var v-row-parent   as rowid                no-undo.
def var c-cgc-formato  as char                 no-undo.
def var c-insc-formato as char                 no-undo.
def var c-verifica-cgc as char format "x(20)"  no-undo.
def var c-formato      as char                 no-undo.
def var i-natureza     as integer  initial 1   no-undo.
def var h-handle       as handle               no-undo.
def var c-handle       as char                 no-undo.
def var i-cod-repres   as integer              no-undo.
def var hProgramZoom   as handle               no-undo.

def new global shared var c-cod-rep   as char no-undo.

define buffer b-repres for repres.

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
&Scoped-define EXTERNAL-TABLES repres
&Scoped-define FIRST-EXTERNAL-TABLE repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR repres.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS repres.comis-min repres.comis-max ~
repres.comis-emis repres.comis-indir repres.comis-direta ~
repres.rep-indireto 
&Scoped-define ENABLED-TABLES repres
&Scoped-define FIRST-ENABLED-TABLE repres
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-mold 
&Scoped-Define DISPLAYED-FIELDS repres.comis-min repres.comis-max ~
repres.comis-emis repres.comis-indir repres.comis-direta ~
repres.rep-indireto 
&Scoped-define DISPLAYED-TABLES repres
&Scoped-define FIRST-DISPLAYED-TABLE repres
&Scoped-Define DISPLAYED-OBJECTS f-formula de-perc-abatim de-perc-ava ~
de-perc-juros de-perc-multa de-perc-desconto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-ASSIGN-FIELDS de-perc-abatim de-perc-ava de-perc-juros ~
de-perc-multa de-perc-desconto 

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
DEFINE VARIABLE de-perc-abatim AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Comiss∆o Abatimento" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-ava AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Comiss∆o Alteraá∆o Valor" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-desconto AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Comiss∆o Desconto" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-juros AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Comiss∆o Juros" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-multa AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Comiss∆o Multa" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE f-formula AS CHARACTER FORMAT "X(12)":U 
     LABEL "F¢rmula" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE mod-comissao AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 18.43 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.43 BY 3.79.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.43 BY 4.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     repres.comis-min AT ROW 1.46 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     repres.comis-max AT ROW 1.46 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     repres.comis-emis AT ROW 2.46 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     repres.comis-indir AT ROW 2.46 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     repres.comis-direta AT ROW 3.46 COL 23.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     repres.rep-indireto AT ROW 3.46 COL 58 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     f-formula AT ROW 4.46 COL 58 COLON-ALIGNED HELP
          "C¢digo F¢rmula"
     de-perc-abatim AT ROW 6.5 COL 23.14 COLON-ALIGNED
     de-perc-ava AT ROW 6.5 COL 58 COLON-ALIGNED
     de-perc-juros AT ROW 7.5 COL 23.14 COLON-ALIGNED
     de-perc-multa AT ROW 7.5 COL 58 COLON-ALIGNED
     de-perc-desconto AT ROW 8.5 COL 23.14 COLON-ALIGNED
     mod-comissao AT ROW 5.75 COL 1.43 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 6 COL 1
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.repres
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
         HEIGHT             = 8.79
         WIDTH              = 75.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

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

/* SETTINGS FOR FILL-IN de-perc-abatim IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-perc-ava IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-perc-desconto IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-perc-juros IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN de-perc-multa IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN f-formula IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       f-formula:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN mod-comissao IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME f-formula
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-formula V-table-Win
ON F5 OF f-formula IN FRAME F-Main /* F¢rmula */
DO:

  {method/zoomfields.i &ProgramZoom="dizoom/z01di389.w"
                         &FieldZoom1="cod-formula"
                         &FieldScreen1="f-formula"
                         &Frame1="f-main"
                         &RunMethod="run getIdiAplic in hProgramZoom (input 1)."
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-formula V-table-Win
ON MOUSE-SELECT-DBLCLICK OF f-formula IN FRAME F-Main /* F¢rmula */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME repres.rep-indireto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.rep-indireto V-table-Win
ON F5 OF repres.rep-indireto IN FRAME F-Main /* Repres Indireto */
DO:   
   assign l-implanta = no.
   {include/zoomvar.i &prog-zoom = "adzoom/z01ad229.w"
                      &campo=repres.rep-indireto
                      &campozoom=cod-rep}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.rep-indireto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF repres.rep-indireto IN FRAME F-Main /* Repres Indireto */
DO:
    apply "F5" to self.
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

repres.rep-indireto:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.
f-formula:load-mouse-pointer("image/lupa.cur":U) in frame {&frame-name}.

{utp/ut-liter.i Comiss∆o_M°nima * L}
assign repres.comis-min:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Comiss∆o_Emiss∆o * L}
assign repres.comis-emis:label in frame {&frame-name} = return-value.
{utp/ut-liter.i %_Comiss∆o * L}
assign repres.comis-direta:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Comiss∆o_M†xima * L}
assign repres.comis-max:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Comiss∆o_Indireta * L}
assign repres.comis-indir:label in frame {&frame-name} = return-value.
{utp/ut-liter.i Representante_Indireto * L}
assign repres.rep-indireto:label in frame {&frame-name} = return-value.

{utp/ut-liter.i %_Comiss∆o_Abatimento * L}
assign de-perc-abatim:label in frame {&frame-name} = return-value.
{utp/ut-liter.i %_Comiss∆o_Juros * L}
assign de-perc-juros:label in frame {&frame-name} = return-value.
{utp/ut-liter.i %_Comiss∆o_Desconto * L}
assign de-perc-desconto:label in frame {&frame-name} = return-value.
{utp/ut-liter.i %_Comiss∆o_Alteraá∆o_Valor * L}
assign de-perc-ava:label in frame {&frame-name} = return-value.
{utp/ut-liter.i %_Comiss∆o_Multa * L}
assign de-perc-multa:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "repres"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  {utp/ut-liter.i M¢dulo_Comiss‰es * R}
  assign mod-comissao:screen-value in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */
    run pi-funcao (input 1).
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
    do  on error undo, return 'adm-error':
        run pi-validate.
    end.  
    /* Code placed here will execute PRIOR to standard behavior. */
    if  return-value = 'ADM-ERROR':U THEN
        return 'ADM-ERROR':U.            
    if  avail param-global then do:  
        if  param-global.modulo-pd = yes then do:      
            find first para-ped no-lock no-error.        
            if avail para-ped then do:
                if input frame {&FRAME-NAME} repres.comis-max > para-ped.perc-max-com then do:
                   run utp/ut-msgs.p (input "show",
                                      input 15260,
                                      input " ").
                   apply 'entry':U to repres.comis-max in frame {&FRAME-NAME}.
                   return 'adm-error'.
                end.
                if (input frame {&FRAME-NAME} repres.comis-direta + 
                    input frame {&FRAME-NAME} repres.comis-indir) > para-ped.perc-max-com then do:
                   run utp/ut-msgs.p (input "show",
                                      input 15260,
                                      input " ").
                   apply 'entry':U to repres.comis-indir in frame {&FRAME-NAME}.
                   return 'adm-error'.
                end.
            end.
        end.
    end.

    &if "{&bf_dis_gradiente}" = "yes" &then
        assign input frame {&frame-name} f-formula.
    &endif

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    run pi-funcao (input 2).

    &if defined (bf_dis_gradiente) &then
        &if '{&bf_dis_gradiente}' = 'yes' &then
            assign repres.cod-formula = f-formula.
        &endif
    &endif

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
    run pi-funcao (input 2).

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

    &if defined (bf_dis_gradiente) &then
        &if '{&bf_dis_gradiente}' = 'yes' &then
            assign f-formula:sensitive in frame f-main = no.
        &endif
    &endif

    /* Code placed here will execute AFTER standard behavior.    */
    run pi-funcao (input 6).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    find first param-global no-lock no-error. 

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    {utp/ut-liter.i M¢dulo_Comiss‰es * R}
    assign mod-comissao:screen-value in frame {&frame-name} = return-value.

    &if defined (bf_dis_gradiente) &then
        &if '{&bf_dis_gradiente}' = 'yes' &then
            assign f-formula:screen-value in frame f-main = repres.cod-formula.
        &endif
    &endif

    run pi-funcao (input 3).

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

  if NOT can-find (
      first funcao 
      where funcao.cd-funcao = "Repres 2.00" 
      or funcao.cd-funcao = "Representantes 2.00") then do:

      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

      /* Code placed here will execute AFTER standard behavior.    */
      run pi-funcao (input 4).

  END.

  &if defined (bf_dis_gradiente) &then
    &if '{&bf_dis_gradiente}' = 'yes' &then
        enable f-formula with frame f-main.
    &endif
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

    find first param-global no-lock no-error.

    &if defined (bf_dis_gradiente) &then
        &if '{&bf_dis_gradiente}' = 'yes' &then
            assign f-formula:hidden in frame f-main = false.
        &endif
    &endif

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    run pi-funcao (input 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-view V-table-Win 
PROCEDURE local-view :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'view':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-funcao V-table-Win 
PROCEDURE pi-funcao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param p-ind as int no-undo.

	case p-ind:
		when 1 then do:   /* initialize */
			assign de-perc-abatim:screen-value   in frame {&FRAME-NAME} = "0,00"
				   de-perc-juros:screen-value    in frame {&FRAME-NAME} = "0,00"
				   de-perc-desconto:screen-value in frame {&FRAME-NAME} = "0,00"                                                        
				   de-perc-ava:screen-value      in frame {&FRAME-NAME} = "0,00"                           
				   de-perc-multa:screen-value    in frame {&FRAME-NAME} = "0,00".
		end.

		when 2 then do:   /* assign records*/
			assign repres.perc-abatimento = input frame {&FRAME-NAME} de-perc-abatim
				   repres.perc-juros      = input frame {&FRAME-NAME} de-perc-juros
				   repres.perc-desconto   = input frame {&FRAME-NAME} de-perc-desconto
				   repres.perc-ava        = input frame {&FRAME-NAME} de-perc-ava
				   repres.perc-multa      = input frame {&FRAME-NAME} de-perc-multa.
		end.

		when 3 then do:   /* display */
			if avail repres then do:
				assign de-perc-abatim:screen-value in frame {&FRAME-NAME}   = string(repres.perc-abatimento)
					   de-perc-juros:screen-value in frame {&FRAME-NAME}    = string(repres.perc-juros)
					   de-perc-desconto:screen-value in frame {&FRAME-NAME} = string(repres.perc-desconto)
					   de-perc-ava:screen-value in frame {&FRAME-NAME}      = string(repres.perc-ava)
					   de-perc-multa:screen-value in frame {&FRAME-NAME}    = string(repres.perc-multa).
			end.
		end.

		when 4 then do:   /* enable */
			assign de-perc-abatim:sensitive in frame {&FRAME-NAME}   = yes
				   de-perc-juros:sensitive in frame {&FRAME-NAME}    = yes
				   de-perc-desconto:sensitive in frame {&FRAME-NAME} = yes
				   de-perc-ava:sensitive in frame {&FRAME-NAME}      = yes
				   de-perc-multa:sensitive in frame {&FRAME-NAME}    = yes.
		end. 

		when 5 then do:   /* pi-validate */
		end.

		when 6 then do:    /* disable */
			assign  de-perc-abatim:sensitive   in frame {&FRAME-NAME} = no
					de-perc-juros:sensitive    in frame {&FRAME-NAME} = no
					de-perc-desconto:sensitive in frame {&FRAME-NAME} = no
					de-perc-ava:sensitive      in frame {&FRAME-NAME} = no
					de-perc-multa:sensitive    in frame {&FRAME-NAME} = no.
		end.
	end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/


    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                OUTPUT c-handle).

    run pi-busca-handle in widget-handle(c-handle) (output h-handle).                    

    run pi-busca-repres in h-handle (output i-cod-repres).

    {include/i-vldfrm.i} 

    RUN get-attribute('adm-new-record':U). 

    /* Comissao Direta excedeu a Comissao Maxima estipulada */
    if  input frame {&FRAME-NAME} repres.comis-direta > 
        input frame {&FRAME-NAME} repres.comis-max then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 7644,
                           input "").
        apply "entry" to repres.comis-direta in frame {&frame-name}.
        Return 'adm-error':U.
    end.      

    /* Comissao Direta deve ser maior que a Comissao Minima estipulada */
    if  input frame {&FRAME-NAME} repres.comis-direta < 
        input frame {&FRAME-NAME} repres.comis-min then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 7645,
                           input "").
        apply "entry" to repres.comis-direta in frame {&frame-name}.
        Return 'adm-error':U.
    end.      

    /* Comissao na Emissao nao pode ser maior de 100% */
    if  input frame {&FRAME-NAME} repres.comis-emis > 100 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 4310,
                           input "").
        assign repres.comis-emis:screen-value in frame {&FRAME-NAME} = string(100).
        apply "entry" to repres.comis-emis in frame {&frame-name}.
        Return 'adm-error':U.
    end.      

    /* Valida Representante Indireto */
    if  input frame {&FRAME-NAME} repres.rep-indireto <> 0 then do:
        find first b-repres
             where b-repres.cod-rep = input frame {&FRAME-NAME} repres.rep-indireto
             no-lock no-error.

        if  not avail b-repres then do:
            /* Representante nao Cadastrado */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 372,
                               input string(input frame {&FRAME-NAME} repres.rep-indireto)).
            apply "entry" to repres.rep-indireto in frame {&frame-name}.
            Return 'adm-error':U.
        end.      

        if input frame {&FRAME-NAME} repres.rep-indireto = i-cod-repres then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 25982,
                               input "").
            apply "entry" to repres.rep-indireto in frame {&frame-name}.
            Return 'adm-error':U.
        end.
    end.
    /* Comissao no Abatimento nao pode ser maior de 100% */
    if input frame {&FRAME-NAME} de-perc-abatim > 100 then do:
       {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show",
                           input 19205,
                           input de-perc-abatim:label in frame {&frame-name}).
        apply "entry" to de-perc-abatim in frame {&frame-name}.
        Return 'adm-error':U.
    end.

    /* Comiss∆o Juros n∆o pode ser maior que 100% */
    if input frame {&FRAME-NAME} de-perc-juros > 100 then do:
       {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show",
                           input 19205,
                           input de-perc-juros:label in frame {&frame-name}).
        apply "entry" to de-perc-juros in frame {&frame-name}.
        Return 'adm-error':U.
    end.                                        

    /* Comiss∆o de Desconto n∆o pode ser maior que 100% */
    if input frame {&FRAME-NAME} de-perc-desconto > 100 then do:
        {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show",
                           input 19205,
                           input de-perc-desconto:label in frame {&frame-name}).
        apply "entry" to de-perc-desconto in frame {&frame-name}.
        Return 'adm-error':U.
    end.                                        

    /* Comiss∆o de AVA n∆o pode ser maior que 100% */
    if input frame {&FRAME-NAME} de-perc-ava > 100 then do:
       {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show",
                           input 19205,
                           input de-perc-ava:label in frame {&frame-name}).
        apply "entry" to de-perc-ava in frame {&frame-name}.
        Return 'adm-error':U.
    end.                                        

    /* Comiss∆o de Multa n∆o pode ser maior que 100% */
    if input frame {&FRAME-NAME} de-perc-multa > 100 then do:
       {include/i-vldprg.i} 
        run utp/ut-msgs.p (input "show",
                           input 19205,
                           input de-perc-multa:label in frame {&frame-name}).
        apply "entry" to de-perc-multa in frame {&frame-name}.
        Return 'adm-error':U.
    end.

    &if defined (bf_dis_gradiente) &then
        &if '{&bf_dis_gradiente}' = 'yes' &then
            find first formul-distrib
                 where formul-distrib.cod-formula = input frame {&FRAME-NAME} f-formula and
                 formul-distrib.idi-aplic = 1
                 no-lock no-error.
            if  not avail formul-distrib then do:
                /* F¢rmula n∆o Cadastrada */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 7381,
                                   input f-formula:label in frame {&frame-name}).
                apply "entry" to f-formula in frame {&frame-name}.
                Return 'adm-error':U.
            end.
        &endif
    &endif

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
  {src/adm/template/snd-list.i "repres"}

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

