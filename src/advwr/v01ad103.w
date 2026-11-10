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
{include/i-prgvrs.i V01AD103 2.00.00.051 } /*** "010051" 18/06/2026 13:04:21  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01AD103 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-esp-doc for esp-doc.
def var c-tipo-especie as char no-undo.
def var c-ligacao as char no-undo.
def var r-esp-doc as rowid no-undo.
def var i-tipo as integer no-undo.
def var c-tipo       like esp-doc.tipo no-undo. 
def var c-des-tipo as char format "x(25)" no-undo.

/*--- possibilita utilizar o   Modulo Multiplanta Financeiro (MMF) ---*/
def var l-ok-mmf     as logical  initial yes   no-undo.
def var c-empr       as char                   no-undo.

/****** Integraá∆o EMS 2 FIN x MG *******/
{cdp/cd0001i1.i} /* Definiá∆o tt-erros-mg */
{cdp/cd0906i1.i} /* Definiá∆o tt-esp-doc-mg */
{cdp/cdcfgfin.i} /* Definiá∆o de vari†veis */
/***************************************/

def var i-ind-tipo-movto as int no-undo.
def var i-tipo-ant       as int  no-undo.
def var c-tipo-ant       as char no-undo.
def var l-espec-comis    as logical init no no-undo.
def var l-gera-comis-cop as logical init no no-undo.
def var l-gera-comis-ant as logical init no no-undo.
def var l-flag           as logical init no no-undo.
def var c-esp-lig-aux as char format "x(2)" no-undo.
def var c-des-esp-aux as char no-undo.
/*********************************************/

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.

{cdp/cd7300.i1}
{cdp/cdapi231.i}
{cdp/cdcfgfin.i}   /* Miniflexibilizaá∆o */

/*********************************************/

{bhp/bh9999.i1}

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
&Scoped-define EXTERNAL-TABLES esp-doc
&Scoped-define FIRST-EXTERNAL-TABLE esp-doc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR esp-doc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS esp-doc.descricao 
&Scoped-define ENABLED-TABLES esp-doc
&Scoped-define FIRST-ENABLED-TABLE esp-doc
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-3 l-gera-comis 
&Scoped-Define DISPLAYED-FIELDS esp-doc.contabiliza esp-doc.atual-estat ~
esp-doc.fluxo-caixa esp-doc.cod-esp esp-doc.descricao esp-doc.emite-dup ~
esp-doc.usa-prev esp-doc.cot-emis-fasb esp-doc.usa-antec ~
esp-doc.calc-var-cmi 
&Scoped-define DISPLAYED-TABLES esp-doc
&Scoped-define FIRST-DISPLAYED-TABLE esp-doc
&Scoped-Define DISPLAYED-OBJECTS cb-tipo c-esp-ligacao ~
c-descricao-esp-ligacao l-gera-comis 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS esp-doc.contabiliza esp-doc.atual-estat ~
esp-doc.fluxo-caixa esp-doc.cod-esp cb-tipo c-esp-ligacao esp-doc.emite-dup ~
esp-doc.usa-prev esp-doc.cot-emis-fasb esp-doc.usa-antec ~
esp-doc.calc-var-cmi l-gera-comis 
&Scoped-define ADM-ASSIGN-FIELDS esp-doc.contabiliza esp-doc.atual-estat ~
esp-doc.fluxo-caixa cb-tipo c-esp-ligacao esp-doc.emite-dup ~
esp-doc.usa-prev esp-doc.cot-emis-fasb esp-doc.usa-antec ~
esp-doc.calc-var-cmi l-gera-comis 
&Scoped-define ADM-MODIFY-FIELDS esp-doc.contabiliza esp-doc.atual-estat ~
esp-doc.fluxo-caixa c-esp-ligacao esp-doc.emite-dup esp-doc.usa-prev ~
esp-doc.cot-emis-fasb esp-doc.usa-antec esp-doc.calc-var-cmi 

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
DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 21.14 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao-esp-ligacao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-esp-ligacao AS CHARACTER FORMAT "X(2)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.63.

DEFINE VARIABLE l-gera-comis AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     esp-doc.contabiliza AT ROW 6.75 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 15.86 BY .88
     esp-doc.atual-estat AT ROW 7.58 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 23.86 BY .88
     esp-doc.fluxo-caixa AT ROW 8.42 COL 3
          VIEW-AS TOGGLE-BOX
          SIZE 16.43 BY .88
     esp-doc.cod-esp FORMAT "X(02)":U AT ROW 1.21 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     esp-doc.descricao AT ROW 2.92 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.14 BY .88
     cb-tipo AT ROW 3.92 COL 25 COLON-ALIGNED
     c-esp-ligacao AT ROW 4.96 COL 25 COLON-ALIGNED
     esp-doc.emite-dup AT ROW 6.75 COL 30
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .88
     esp-doc.usa-prev AT ROW 7.58 COL 30
          VIEW-AS TOGGLE-BOX
          SIZE 18 BY .88
     esp-doc.cot-emis-fasb AT ROW 8.42 COL 30
          VIEW-AS TOGGLE-BOX
          SIZE 35 BY .88
     c-descricao-esp-ligacao AT ROW 4.96 COL 30.57 COLON-ALIGNED NO-LABEL
     esp-doc.usa-antec AT ROW 6.75 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 20.86 BY .88
     esp-doc.calc-var-cmi AT ROW 7.58 COL 61
          VIEW-AS TOGGLE-BOX
          SIZE 26.86 BY .88
     l-gera-comis AT ROW 8.42 COL 61
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.67 COL 1
     RECT-3 AT ROW 6.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.esp-doc
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
         HEIGHT             = 8.5
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

/* SETTINGS FOR TOGGLE-BOX esp-doc.atual-estat IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-descricao-esp-ligacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-esp-ligacao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX esp-doc.calc-var-cmi IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tipo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN esp-doc.cod-esp IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX esp-doc.contabiliza IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX esp-doc.cot-emis-fasb IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX esp-doc.emite-dup IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX esp-doc.fluxo-caixa IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX l-gera-comis IN FRAME f-main
   1 2                                                                  */
/* SETTINGS FOR TOGGLE-BOX esp-doc.usa-antec IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX esp-doc.usa-prev IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME c-esp-ligacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-esp-ligacao V-table-Win
ON F5 OF c-esp-ligacao IN FRAME f-main
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad103.w"
                     &campo=c-esp-ligacao
                     &campozoom=cod-esp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-esp-ligacao V-table-Win
ON LEAVE OF c-esp-ligacao IN FRAME f-main
DO:
  {include/leave.i &tabela=b-esp-doc
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-esp-ligacao
                   &where="b-esp-doc.cod-esp = input frame {&frame-name} c-esp-ligacao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-esp-ligacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-esp-ligacao IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo V-table-Win
ON VALUE-CHANGED OF cb-tipo IN FRAME f-main
DO:
    
    if (input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 1}
    or  input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 4}
    or  input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 5} )then do:
        enable c-esp-ligacao WITH FRAME {&frame-name}.
    end.
    else do: 
        disable c-esp-ligacao WITH FRAME {&frame-name}.
        assign c-esp-ligacao:screen-value           in frame {&FRAME-NAME} = ""
               c-descricao-esp-ligacao:screen-value in frame {&FRAME-NAME} = "".
    end.

    assign input frame {&frame-name} cb-tipo i-tipo = {adinc/i01ad103.i 06 cb-tipo}.

    assign esp-doc.emite-dup:sensitive     in frame {&FRAME-NAME} = yes
           esp-doc.contabiliza:sensitive   in frame {&FRAME-NAME} = yes
           esp-doc.usa-prev:sensitive      in frame {&FRAME-NAME} = yes 
           esp-doc.usa-antec:sensitive     in frame {&FRAME-NAME} = yes
           esp-doc.cot-emis-fasb:sensitive in frame {&FRAME-NAME} = yes
           esp-doc.atual-estat:sensitive   in frame {&FRAME-NAME} = yes
           esp-doc.fluxo-caixa:sensitive   in frame {&FRAME-NAME} = yes
           esp-doc.calc-var-cmi:sensitive  in frame {&FRAME-NAME} = yes.
    
    RUN pi-verifica-espec.
    case i-tipo:
        when 1 then do:
            run pi-gera-comis.
        end.
        when 2 then do:
            run pi-gera-comis.
            assign esp-doc.emite-dup:sensitive     in frame {&FRAME-NAME} = no
                   esp-doc.usa-antec:sensitive     in frame {&FRAME-NAME} = no.
        end.
        when 3 then
            assign esp-doc.emite-dup:sensitive     in frame {&FRAME-NAME} = no
                   esp-doc.usa-prev:sensitive      in frame {&FRAME-NAME} = no 
                   esp-doc.usa-antec:sensitive     in frame {&FRAME-NAME} = no
                   esp-doc.cot-emis-fasb:sensitive in frame {&FRAME-NAME} = no
                   esp-doc.calc-var-cmi:sensitive  in frame {&FRAME-NAME} = no
                   esp-doc.contabiliza:checked     in frame {&FRAME-NAME} = no
                   esp-doc.contabiliza:sensitive   in frame {&FRAME-NAME} = no
                   l-gera-comis:sensitive          in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        when 4 then
            assign esp-doc.emite-dup:sensitive     in frame {&FRAME-NAME} = no
                   esp-doc.cot-emis-fasb:sensitive in frame {&FRAME-NAME} = no
                   esp-doc.calc-var-cmi:sensitive  in frame {&FRAME-NAME} = no
                   esp-doc.contabiliza:sensitive   in frame {&FRAME-NAME} = no
                   esp-doc.atual-estat:sensitive   in frame {&FRAME-NAME} = no
                   esp-doc.fluxo-caixa:sensitive   in frame {&FRAME-NAME} = no
                   esp-doc.usa-prev:sensitive      in frame {&FRAME-NAME} = no
                   esp-doc.usa-antec:sensitive     in frame {&FRAME-NAME} = no
                   l-gera-comis:sensitive          in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        when 5 then
            assign esp-doc.emite-dup:sensitive     in frame {&FRAME-NAME} = no
                   esp-doc.cot-emis-fasb:sensitive in frame {&FRAME-NAME} = no
                   esp-doc.calc-var-cmi:sensitive  in frame {&FRAME-NAME} = no
                   esp-doc.contabiliza:sensitive   in frame {&FRAME-NAME} = no
                   esp-doc.atual-estat:sensitive   in frame {&FRAME-NAME} = no
                   esp-doc.fluxo-caixa:sensitive   in frame {&FRAME-NAME} = no
                   esp-doc.usa-prev:sensitive      in frame {&FRAME-NAME} = no
                   esp-doc.usa-antec:sensitive     in frame {&FRAME-NAME} = no
                   l-gera-comis:sensitive          in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        when 6 then
            assign esp-doc.cot-emis-fasb:sensitive in frame {&FRAME-NAME} = no
                   esp-doc.calc-var-cmi:sensitive  in frame {&FRAME-NAME} = no
                   l-gera-comis:sensitive          in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        when 7 then do:
            assign l-gera-comis:sensitive in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        end.
        when 8 then do:
            assign l-gera-comis:sensitive in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        end.
        when 9 then do:
            assign l-gera-comis:sensitive in frame {&FRAME-NAME} = no
                   l-gera-comis:checked = false.
        end.
    end case.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME esp-doc.cod-esp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL esp-doc.cod-esp V-table-Win
ON LEAVE OF esp-doc.cod-esp IN FRAME f-main /* EspÇcie */
DO:

  assign esp-doc.cod-esp:format in frame {&frame-name} = "x(2)".
  RUN pi-verifica-espec.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
if c-esp-ligacao:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  
{utp/ut-field.i mgadm esp-doc tipo 1}
cb-tipo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgadm esp-doc esp-ligacao 1}
c-esp-ligacao:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Gera_Comiss∆o * L}
assign l-gera-comis:label in frame {&FRAME-NAME} = TRIM(return-value).

{utp/ut-liter.i EspÇcie_Gera_Comiss∆o? * L}
assign l-gera-comis:help in frame {&FRAME-NAME} = TRIM(return-value).

/****** Integraá∆o EMS 2 FIN x MG *******/
{btb/btb008za.i0}
{include/i-freeac.i} /* include para tirar acentuaá∆o */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         
  
if can-find(first funcao 
            where funcao.cd-funcao = 'spp-espec-comis' 
            and   funcao.ativo     = yes) then do:
    assign l-espec-comis = yes.
end.
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
  {src/adm/template/row-list.i "esp-doc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "esp-doc"}

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
  do with frame {&frame-name}:
     assign cb-tipo:screen-value = {adinc/i01ad103.i 04 1}.
  end.  
  assign c-esp-ligacao:sensitive  in frame {&FRAME-NAME} = yes.
  run pi-gera-comis.
  assign l-flag = yes.
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
    if not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    /* Ponha na pi-validate todas as validaá‰es */

    if input frame {&FRAME-NAME} esp-doc.cod-esp = "" then do:
        run utp/ut-msgs.p (input "show",
                           input 5164,
                           input "").
        apply 'entry' to esp-doc.cod-esp in frame {&frame-name} .
        return 'adm-error':U.
    end.

    if  esp-doc.cod-esp:sensitive in frame {&frame-name} = yes then do:
        if  length(input frame {&FRAME-NAME} esp-doc.cod-esp) < 2 then do:
            run utp/ut-msgs.p (input "show",
                               input 15156,
                               input "").
            apply 'entry' to esp-doc.cod-esp in frame {&frame-name} .
            return 'adm-error':U.
        end.
    end.
    
    if  esp-doc.cod-esp:sensitive in frame {&FRAME-NAME} = yes
    and can-find (esp-doc where esp-doc.cod-esp = input frame {&frame-name} esp-doc.cod-esp) then do:
        {utp/ut-table.i mgadm esp-doc 1}
        run utp/ut-msgs.p (input "show",
                          input 1,
                          input return-value).
        apply 'entry' to esp-doc.cod-esp in frame {&frame-name}.
        return 'adm-error':U.                
    end.
        
    if input frame {&Frame-name} esp-doc.descricao = "" then do:
      run utp/ut-msgs.p (input "show",
                         input 190,
                         input "").
      apply 'entry' to esp-doc.descricao in frame {&frame-name} .
      return 'adm-error':U.
    end.                       


    if (input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 4} 
    or input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 5}) then do:
        find b-esp-doc no-lock
            where b-esp-doc.cod-esp = input frame {&frame-name} c-esp-ligacao no-error.
        if not avail b-esp-doc then do:
            run utp/ut-msgs.p (input "show",
                               input  652,
                               input c-tipo-especie).
            apply "entry" to c-esp-ligacao in frame {&frame-name}.
            return 'adm-error':U.
        end.
        else do:
            if input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 4} then
                if b-esp-doc.tipo <> 1 then do:
                    assign c-tipo-especie = {adinc/i01ad103.i 04 1}.
                    run utp/ut-msgs.p (input "show",
                                       input  144,
                                       input c-tipo-especie).
                    apply "entry" to c-esp-ligacao in frame {&frame-name}.
                    return 'adm-error':U.
                end.
            if input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 5} then
                if b-esp-doc.tipo <> 2 then do:
                    assign c-tipo-especie = {adinc/i01ad103.i 04 2}.
                    run utp/ut-msgs.p (input "show",
                                       input  144,
                                       input c-tipo-especie).
                    apply "entry" to c-esp-ligacao in frame {&frame-name}.
                    return 'adm-error':U.
                end.
        end.
    end.
    
    if input frame {&frame-name} cb-tipo = {adinc/i01ad103.i 04 1} then do:
        find b-esp-doc no-lock
             where b-esp-doc.cod-esp = input frame {&frame-name} c-esp-ligacao
             no-error.
        if not avail b-esp-doc then do:
            run utp/ut-msgs.p (input "show",
                               input  652,
                               input c-tipo-especie).
            apply "entry" to c-esp-ligacao in frame {&frame-name}.
            return 'adm-error':U.
        end.
        else do:
            if b-esp-doc.tipo <> 6 then do:
                assign c-tipo-especie = {adinc/i01ad103.i 04 6}.
                run utp/ut-msgs.p (input "show",
                                   input 144,
                                   input c-tipo-especie).
                apply "entry" to c-esp-ligacao in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.
    end.
    assign input frame {&FRAME-NAME} cb-tipo
           c-tipo = {adinc/i01ad103.i 06 cb-tipo}.       
    RUN get-attribute ('adm-new-record':U).
    
    if return-value = "no":U then do:
        if c-tipo <> esp-doc.tipo then do:
            find first titulo
                 where titulo.cod-esp = esp-doc.cod-esp
                 no-lock no-error.
            if avail titulo then do:
                run utp/ut-msgs.p (input "show",
                                   input 6222,
                                   input "").
                apply "entry" to cb-tipo in frame {&frame-name}.
                return 'adm-error':U.
            end.
        end.
    end.
    assign c-ligacao = input frame {&frame-name} c-esp-ligacao.
          
    /* N∆o gravar nada no registro antes do
    dispatch do assign-record e nem na PI-validate. */  

    IF RETURN-VALUE = "ADM-ERROR" THEN RETURN "ADM-ERROR".
    
    
    assign c-esp-lig-aux = input frame {&frame-name} c-esp-ligacao
           c-des-esp-aux = input frame {&frame-name} c-descricao-esp-ligacao.
          
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

    assign c-esp-ligacao:screen-value = string(c-esp-lig-aux)
           c-descricao-esp-ligacao:screen-value = string(c-des-esp-aux).
    
    assign r-esp-doc = rowid(esp-doc).   
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
   
    if avail esp-doc then  do:
        assign esp-doc.esp-ligacao = c-ligacao  
               esp-doc.tipo        = {adinc/i01ad103.i 06 cb-tipo}.

        if (esp-doc.tipo <> 1 or esp-doc.tipo <> 4 or esp-doc.tipo <> 5) then
            assign c-descricao-esp-ligacao = " ".

        find first titulo
             where titulo.cod-esp = esp-doc.cod-esp
             no-lock no-error.        
        if avail titulo then do:
            &if defined(BF_FIN_RAC) &then
               find param-global no-lock no-error.
               if param-global.modulo-rac = yes then do:
                    if l-gera-comis <> l-gera-comis-ant and l-gera-comis = no then do:
                        run utp/ut-msgs.p (input "show",
                                           input 25087,
                                           input "").
                        apply "entry" to l-gera-comis in frame {&frame-name}.
                        return 'adm-error':U.
                    end.
                    else do:
                        assign l-gera-comis-ant = l-gera-comis.
                    end.
                end.
            &endif
        end.        
        
        &if defined(BF_FIN_RAC) &then
            if l-flag = yes then
                assign esp-doc.gera-comis = l-gera-comis-cop
                       l-flag             = no.
            else
                assign esp-doc.gera-comis = input frame {&frame-name} l-gera-comis.
        &endif
    end.    
    
    /* N∆o retirar essa linha pois o campo cb-tipo Ç atualizado somente 
       depois do "assign-record" */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
   
    /* Code placed here will execute AFTER standard behavior.    */
       
    /****** Integraá∆o EMS 2 FIN x MG *******/
    {cdp/cd0002i1.i "esp-doc"}
    
    if  l-ok-mmf = yes then do:
        /********************Multiplanta***********************/
        assign c-transacao = "ADM028".
        {cdp/cd7300.i5 "001" c-transacao}
      
        assign i-tipo-movto = if esp-doc.cod-esp:sensitive in frame {&frame-name} = yes 
                                  then 1 
                                  else 2.
        run pi-cria-tt-dados (input i-tipo-movto).
      
        {cdp/cd7300.i6 "001" c-transacao}
      
        /******************Fim-Multiplanta********************/   
    end.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/ 
  
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  apply "value-changed" to cb-tipo in frame {&FRAME-NAME}.
  assign l-flag = yes.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  
  FIND FIRST b-esp-doc WHERE b-esp-doc.esp-ligacao = INPUT FRAME {&frame-name} esp-doc.cod-esp NO-LOCK NO-ERROR.
  IF  AVAIL b-esp-doc THEN DO:
      RUN utp/ut-msgs.p (input "show",
                         input 53,
                         input ""). 
      RETURN "adm-error".
  END. /* if avail ... */
  
  if can-find(first titulo
              where titulo.cod-esp = INPUT FRAME {&frame-name} esp-doc.cod-esp) then do:
      RUN utp/ut-msgs.p (input "show",
                         input 6222,
                         input "").
      RETURN "adm-error".
  end.

/*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
    if  not available(param-global) then
        find first param-global no-lock no-error.
    
    if  param-global.modulo-bh = yes
    then do:
        {bhp/bh9999.i 1 Esp-Doc esp-doc.cod-esp '' '' '' '' ''}
        if  return-value <> "OK"
        then return "ADM-ERROR".
    end.
/************************************************************************************************************/
  
  {cdp/cd0002i1.i1 "esp-doc" "no"}  /****** Integraá∆o EMS 2 FIN x MG *******/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
  
  if return-value = 'ADM-ERROR':U then 
             return 'ADM-ERROR':U.

  {cdp/cd0002i1.i1 "esp-doc" "yes"} /****** Integraá∆o EMS 2 FIN x MG *******/

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
  assign l-flag = no.

 
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
  
  assign l-gera-comis-cop = l-gera-comis.  
  If avail esp-doc then do:
    assign c-esp-ligacao = esp-doc.esp-ligacao.
    &if defined(BF_FIN_RAC) &then
        assign l-gera-comis-ant = esp-doc.gera-comis
               l-gera-comis     = esp-doc.gera-comis.    
    &endif    
    find b-esp-doc no-lock
        where b-esp-doc.cod-esp = esp-doc.esp-ligacao no-error.
    assign c-descricao-esp-ligacao = if avail b-esp-doc then
                                         b-esp-doc.descricao 
                                     else 
                                         " ":U.
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail esp-doc then do with frame {&frame-name}:
     assign cb-tipo:screen-value = {adinc/i01ad103.i 04 esp-doc.tipo}
            i-tipo = esp-doc.tipo.
  end.
  else do:
     assign cb-tipo:screen-value = {adinc/i01ad103.i 04 1}  
            i-tipo = 1. 
  end.

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
  if  return-value = 'yes' then do:
      run get-attribute ('adm-adding-record').
      if  return-value = 'yes' then
          assign cb-tipo:screen-value in frame {&frame-name} = {adinc/i01ad103.i 04 1}
                 i-tipo = 1.
      else do:
          assign i-tipo = {adinc/i01ad103.i 06 cb-tipo:screen-value in frame {&FRAME-NAME}}.
      end.    
  end.          
            
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  assign cb-tipo:sensitive in frame {&frame-name} = yes.

  apply "value-changed" to cb-tipo in frame {&FRAME-NAME}.

  assign c-tipo-ant = cb-tipo:screen-value in frame {&FRAME-NAME}.
         i-tipo-ant = {adinc/i01ad103.i 06 c-tipo-ant}.

        
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
  
    do with frame {&frame-name}:
        assign cb-tipo:list-items = {adinc/i01ad103.i 03 }.
    end.   

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    l-implanta = no.
    assign l-gera-comis:sensitive in frame {&frame-name} = no
           l-flag = no.
    
    /*---  Modulo Multiplanta Financeiro (MMF) ---*/
    {cdp/cdapi531.i1 "ADM028" "NO"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /****** Integraá∆o EMS 2 FIN x MG *******/
    {cdp/cd0003i1.i "esp-doc" "cdp/cd0906i1.p"}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-esp-doc-aux.
    buffer-copy esp-doc to tt-esp-doc-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 75
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(esp-doc.cod-esp).
    raw-transfer tt-esp-doc-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-esp-doc-mg V-table-Win 
PROCEDURE pi-cria-tt-esp-doc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /****** Integraá∆o EMS 2 FIN x MG *******/

    def input param p-ind-tipo-movto as int  no-undo.
    def input param p-atualiza       as log  no-undo.
    
    for each tt-esp-doc-mg:
        delete tt-esp-doc-mg.
    end.

    create tt-esp-doc-mg.
    assign tt-esp-doc-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-esp-doc-mg.l-atualiza     = p-atualiza.

    /* campos iguais */
    assign tt-esp-doc-mg.cod-esp      = fn-free-accent(esp-doc.cod-esp).
    assign tt-esp-doc-mg.descricao    = fn-free-accent(esp-doc.descricao).
    assign tt-esp-doc-mg.esp-cob-esc  = fn-free-accent(esp-doc.esp-cob-esc).
            
    assign tt-esp-doc-mg.contabiliza  = esp-doc.contabiliza
           tt-esp-doc-mg.fluxo-caixa  = esp-doc.fluxo-caixa
           tt-esp-doc-mg.usa-antec    = esp-doc.usa-antec
           tt-esp-doc-mg.emite-dup    = esp-doc.emite-dup
           tt-esp-doc-mg.calc-var-cmi = esp-doc.calc-var-cmi
           tt-esp-doc-mg.atual-estat  = esp-doc.atual-estat
           tt-esp-doc-mg.usa-prev     = esp-doc.usa-prev
           tt-esp-doc-mg.ind-abat-ft  = esp-doc.ind-abat-ft.

    case esp-doc.tipo:
        when 1 then assign tt-esp-doc-mg.tipo = "N".
        when 2 then assign tt-esp-doc-mg.tipo = "A".
        when 3 then assign tt-esp-doc-mg.tipo = "P".
    end case.

    /* campos diferentes */
    assign tt-esp-doc-mg.log-1      = esp-doc.cot-emis-fasb
           tt-esp-doc-mg.cod-esp-ad = esp-doc.esp-ligacao.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-comis V-table-Win 
PROCEDURE pi-gera-comis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     
    assign l-gera-comis:sensitive in frame {&FRAME-NAME} = no.
    &if defined(BF_FIN_RAC) &then
        find param-global no-lock no-error.        
        if param-global.modulo-rac = yes then
            assign l-gera-comis:sensitive in frame {&FRAME-NAME} = yes.
        else do:
            if l-espec-comis = yes then
                assign l-gera-comis:sensitive in frame {&FRAME-NAME} = yes.
            else do:
                assign l-gera-comis:sensitive in frame {&FRAME-NAME} = no
                       l-gera-comis:checked = false.                                    
            end.
        end.
    &endif


    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
        
    /****** Integraá∆o EMS 2 FIN x MG *******/

    {cdp/cd0004i1.i "cd0906"
                    "esp-doc"
                    "esp-doc.cod-esp"
                    "tt-esp-doc-mg.ind-tipo-movto"
                    "tt-erros-mg.help-msg"}
    if return-value = "NOK" then
       return.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-esp-doc-mg V-table-Win 
PROCEDURE pi-valida-esp-doc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    /****** Integraá∆o EMS 2 FIN x MG *******/
    
    def input-output param p-ind-tipo-movto as int no-undo.
    
    /* Se tipo da EspÇcie for diferente de Normal/Antecipaá∆o/Previs∆o n∆o deve ser
       integrado com o Magnus, pois os outros tipos n∆o s∆o tratados por ele. */
       
    if  esp-doc.tipo <> 1
    and esp-doc.tipo <> 2
    and esp-doc.tipo <> 3 then do:
        assign c-des-tipo    = {adinc/i01ad103.i 4 esp-doc.tipo}
               c-esp-ligacao:screen-value in frame {&FRAME-NAME} = esp-doc.esp-ligacao
               cb-tipo:screen-value in frame {&frame-name} = {adinc/i01ad103.i 04 esp-doc.tipo}.
        
        if p-ind-tipo-movto = 3 then 
           assign p-ind-tipo-movto = 0.
           
        if p-ind-tipo-movto = 1 then do:       
           run utp/ut-msgs.p (input "show",
                              input 19446,
                              input c-des-tipo). 
           assign p-ind-tipo-movto = 0.
        end.   

        if p-ind-tipo-movto = 2 then do:
           if esp-doc.tipo <> i-tipo-ant then do:

              assign c-tipo-ant = {adinc/i01ad103.i 4 i-tipo-ant}.
              run utp/ut-msgs.p (input "show",
                                 input 19485,
                                 input c-des-tipo + "~~" + c-tipo-ant).
              if return-value = "yes" then
                 assign p-ind-tipo-movto = 3.
              else
                 return "NOK".
           end.
           else
              assign p-ind-tipo-movto = 0.
        end.
    end.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-espec V-table-Win 
PROCEDURE pi-verifica-espec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FIND FIRST titulo NO-LOCK
         WHERE titulo.cod-esp = esp-doc.cod-esp NO-ERROR.
    IF  AVAIL titulo 
    AND  esp-doc.contabiliza:sensitive in frame {&FRAME-NAME} <> NO THEN
        ASSIGN esp-doc.contabiliza:sensitive in frame {&FRAME-NAME} = NO.
    ELSE 
        ASSIGN esp-doc.contabiliza:sensitive in frame {&FRAME-NAME} = YES.

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
  {src/adm/template/snd-list.i "esp-doc"}

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

