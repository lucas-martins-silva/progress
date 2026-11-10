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
{include/i-prgvrs.i V02IN582 2.00.00.015 } /*** "010015" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in582 MUT}
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

/* Parameters Definitions ---                                           */

{cnp/cn0601.i1}
/***********************************************
* Inicio das altera‡äes feitas por Nuno Santo  *
***********************************************/

def new global shared var i-moeda-g as integer format ">9" no-undo init 0.
def new global shared var i-conv-g as date format "99/99/9999" initial today no-undo.
def new global shared var da-conv-g as date format "99/99/9999" initial today no-undo.
def new global shared var l-cancela as logical no-undo init yes.
def new global shared var l-conv-g  as log view-as RADIO-SET horizontal RADIO-BUTTONS "Cotacao",yes,"Atual",no no-undo. 

def var de-saldo-final like contrato-for.sld-val.


/***********************************************
* Fim das altera‡äes feitas por Nuno Santo  *
***********************************************/


/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES item-contrat
&Scoped-define FIRST-EXTERNAL-TABLE item-contrat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-contrat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-contrat.cod-cond-pag ~
item-contrat.dat-cotac item-contrat.val-frete item-contrat.prazo-ent ~
item-contrat.preco-fornec item-contrat.perc-desconto item-contrat.mo-codigo ~
item-contrat.pre-unit-for item-contrat.contato item-contrat.val-total ~
item-contrat.cod-comprado item-contrat.qtd-total item-contrat.frete 
&Scoped-define ENABLED-TABLES item-contrat
&Scoped-define FIRST-ENABLED-TABLE item-contrat
&Scoped-Define ENABLED-OBJECTS RECT-13 
&Scoped-Define DISPLAYED-FIELDS item-contrat.cod-cond-pag ~
item-contrat.dat-cotac item-contrat.val-frete item-contrat.prazo-ent ~
item-contrat.preco-fornec item-contrat.perc-desconto item-contrat.mo-codigo ~
item-contrat.pre-unit-for item-contrat.contato item-contrat.val-total ~
item-contrat.cod-comprado item-contrat.qtd-total item-contrat.frete 
&Scoped-define DISPLAYED-TABLES item-contrat
&Scoped-define FIRST-DISPLAYED-TABLE item-contrat
&Scoped-Define DISPLAYED-OBJECTS fi-cond-pagto c-moeda c-un fi-moeda 

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
DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(256)":U 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 25.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 8.58.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-contrat.cod-cond-pag AT ROW 1.83 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     fi-cond-pagto AT ROW 1.83 COL 23.57 COLON-ALIGNED NO-LABEL
     c-moeda AT ROW 1.83 COL 57.86 COLON-ALIGNED
     item-contrat.dat-cotac AT ROW 2.75 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     item-contrat.val-frete AT ROW 2.92 COL 57.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     item-contrat.prazo-ent AT ROW 3.79 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     item-contrat.preco-fornec AT ROW 3.83 COL 57.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     c-un AT ROW 4.79 COL 18.43 COLON-ALIGNED
     item-contrat.perc-desconto AT ROW 4.83 COL 57.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     item-contrat.mo-codigo AT ROW 5.75 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-moeda AT ROW 5.75 COL 22.14 COLON-ALIGNED NO-LABEL
     item-contrat.pre-unit-for AT ROW 5.83 COL 57.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     item-contrat.contato AT ROW 6.75 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.57 BY .88
     item-contrat.val-total AT ROW 6.83 COL 57.86 COLON-ALIGNED FORMAT "->>,>>>,>>>,>>9.9999" 
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     item-contrat.cod-comprado AT ROW 7.75 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.72 BY .88
     item-contrat.qtd-total AT ROW 7.83 COL 57.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     item-contrat.frete AT ROW 8.79 COL 20.43
          VIEW-AS TOGGLE-BOX
          SIZE 9.43 BY .83
     RECT-13 AT ROW 1.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-contrat
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
         HEIGHT             = 8.96
         WIDTH              = 84.86.
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

/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-moeda:SELECTABLE IN FRAME f-main       = TRUE
       c-moeda:READ-ONLY IN FRAME f-main        = TRUE.

/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cond-pagto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
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
  {src/adm/template/row-list.i "item-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-contrat"}

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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  find cond-pagto where
       cond-pagto.cod-cond-pag = item-contrat.cod-cond-pag
       no-lock no-error.
  if avail cond-pagto THEN
     assign fi-cond-pagto  = cond-pagto.descricao.

  else assign fi-cond-pagto = "".
    
  find moeda where 
       moeda.mo-codigo = item-contrat.mo-codigo
       no-lock no-error.
  if avail moeda then     
     assign fi-moeda = moeda.descricao.  
  else
     assign fi-moeda = "".
  
  {utp/ut-field.i mgind item-fornec unid-med-for 1}
  assign c-un:label in frame {&frame-name} = return-value.
  

  find item-fornec where
       item-fornec.it-codigo = item-contrat.it-codigo and 
       item-fornec.cod-emitente = item-contrat.cod-emitente 
       no-lock no-error.
  
  IF avail item-fornec THEN
      ASSIGN c-un = item-fornec.unid-med-for.
 
  ELSE 
      ASSIGN c-un = item-contrat.un.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

 {cdp/cdcfgmat.i}

&if defined (bf_mat_contrato_moedas) &then

/***********************************************
* Inicio das altera‡äes feitas por Nuno Santo  *
***********************************************/

if avail item-contrat then do:

    find first moeda where moeda.mo-codigo = i-moeda-g no-lock no-error.
           assign c-moeda:screen-value IN FRAME {&FRAME-NAME} = moeda.descricao.
    
    if l-conv-g = yes THEN DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.val-frete,
                            input item-contrat.dat-cotac,
                            output de-saldo-final).
        assign item-contrat.val-frete:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    END.
    ELSE DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.val-frete,
                            input da-conv-g,
                            output de-saldo-final).
        assign item-contrat.val-frete:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    END.       
    
    if l-conv-g = yes THEN DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.preco-fornec,
                            input item-contrat.dat-cotac,
                            output de-saldo-final).
        assign item-contrat.preco-fornec:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    END.
    ELSE DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.preco-fornec,
                            input da-conv-g,
                            output de-saldo-final).
        assign item-contrat.preco-fornec:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    END.
    
    if l-conv-g = yes THEN DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.pre-unit-for,
                            input item-contrat.dat-cotac,
                            output de-saldo-final).
        assign item-contrat.pre-unit-for:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    END.
    ELSE DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.pre-unit-for,
                            input da-conv-g,
                            output de-saldo-final).
        assign item-contrat.pre-unit-for:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    END.
    if l-conv-g = yes THEN DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.val-total,
                            input item-contrat.dat-cotac,
                            output de-saldo-final).                
        assign item-contrat.val-total:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).
    end.
    ELSE DO:
        run "cdp/cd0812.p" (input item-contrat.mo-codigo,
                            input i-moeda-g,
                            input item-contrat.val-total,
                            input da-conv-g,
                            output de-saldo-final). 
        assign item-contrat.val-total:screen-value in frame {&FRAME-NAME} = string(de-saldo-final).

        FIND FIRST param-contrat NO-LOCK NO-ERROR.
        IF AVAIL param-contrat 
             AND param-contrat.controle-aditivo THEN
            RUN pi-atualizaCamposAditivo.
    END.
END.

/***********************************************
* Fim das altera‡äes feitas por Nuno Santo     *
***********************************************/
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
  
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualizaCamposAditivo V-table-Win 
PROCEDURE pi-atualizaCamposAditivo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR c-valor-alter AS CHAR FORMAT "X(100)" NO-UNDO.

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.cod-cond-pag",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.cod-cond-pag:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).


 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.dat-cotac",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.dat-cotac:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.prazo-ent",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.prazo-ent:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.mo-codigo",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.mo-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).
   

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.contato",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.contato:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).


 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.cod-comprado",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.cod-comprado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.frete",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.frete:CHECKED IN FRAME {&FRAME-NAME} = trim(c-valor-alter) = "yes":U.

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.val-frete",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.val-frete:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.preco-fornec",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.preco-fornec:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.perc-desconto",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.perc-desconto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.preco-fornec",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.pre-unit-for:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).


 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.val-total",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.val-total:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).
 
 ASSIGN c-valor-alter = f-retornaCampoAlter(INPUT item-contrat.nr-contrato,
                                            INPUT "item-contrat.qtd-total",
                                            INPUT item-contrat.it-codigo,
                                            INPUT item-contrat.num-seq-item).
 IF c-valor-alter <> "" THEN
     ASSIGN item-contrat.qtd-total:SCREEN-VALUE IN FRAME {&FRAME-NAME} = trim(c-valor-alter).

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

  {cdp/cdcfgmat.i}

  &if defined (bf_mat_contrato_moedas) &then
  &else
    c-moeda:hidden in frame {&FRAME-NAME} = yes.
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
  {src/adm/template/snd-list.i "item-contrat"}

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

