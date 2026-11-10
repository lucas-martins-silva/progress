&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mgmfg            PROGRESS
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
{include/i-prgvrs.i V11IN318 2.00.01.001}  /*** 010101 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V11IN318 MUT}
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

def new global shared var gr-pl-prod as rowid no-undo.
def new global shared var i-cd-tipo like periodo.cd-tipo.
def new global shared var gr-tipo-per as rowid no-undo.
def buffer b-pl-prod  for pl-prod.

def new global shared var gr-periodo as rowid no-undo.

def var l-confirma as logical no-undo.
def var l-resposta as logical no-undo.

def var l-inclusao as logical initial "no" no-undo.

def var c-tipo-plano like pl-prod.tipo-plano no-undo.
def var c-tiplan-atu like pl-prod.tipo-plano no-undo.
def var i-lin-tiplan   as integer no-undo.

def var da-data-ini as date no-undo.
def var da-data-fim as date no-undo.

def var l-it-fora as logical initial "no" no-undo.
def var l-todos   as logical initial "no" no-undo.

def var periodo1-aux as char.
def var ano1-aux     as char.
def var pos1         as integer.

def var periodo2-aux as char.
def var ano2-aux     as char.
def var pos2         as integer.

def var l-assign-record     as logical.
def var c-dt-ini-per-i-aux  as date format "99/99/9999".
def var c-dt-fim-per-i-aux  as date format "99/99/9999".
def var c-nr-per-ini-aux    as char.
def var c-dt-ini-per-f-aux  as date format "99/99/9999".
def var c-dt-fim-per-f-aux  as date format "99/99/9999".
def var c-nr-per-fim-aux    as char.

{cdp/cdcfgman.i}

/*def var c-periodo as char format "x(07)" no-undo.*/

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
&Scoped-define EXTERNAL-TABLES pl-prod
&Scoped-define FIRST-EXTERNAL-TABLE pl-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pl-prod.descricao pl-prod.cd-tipo ~
pl-prod.horiz-fixo pl-prod.nr-dias-seg pl-prod.quant-confirm 
&Scoped-define ENABLED-TABLES pl-prod
&Scoped-define FIRST-ENABLED-TABLE pl-prod
&Scoped-define DISPLAYED-TABLES pl-prod
&Scoped-define FIRST-DISPLAYED-TABLE pl-prod
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS pl-prod.cd-plano pl-prod.descricao ~
pl-prod.cd-tipo pl-prod.horiz-fixo pl-prod.nr-dias-seg ~
pl-prod.quant-confirm 
&Scoped-Define DISPLAYED-OBJECTS tb-multi-estabel CB-tipo-plano i-nr-dia ~
c-desc-tipo-per c-nr-per-ini da-dt-ini-per-i da-dt-fim-per-i c-nr-per-fim ~
da-dt-ini-per-f da-dt-fim-per-f 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS tb-multi-estabel pl-prod.cd-plano 
&Scoped-define ADM-ASSIGN-FIELDS tb-multi-estabel CB-tipo-plano 
&Scoped-define ADM-MODIFY-FIELDS tb-multi-estabel CB-tipo-plano ~
c-nr-per-ini da-dt-ini-per-i c-nr-per-fim da-dt-ini-per-f 

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
DEFINE VARIABLE CB-tipo-plano AS CHARACTER FORMAT "!!" INITIAL "PV" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "?" 
     DROP-DOWN-LIST
     SIZE 7 BY 1.

DEFINE VARIABLE c-desc-tipo-per AS CHARACTER FORMAT "X(36)":U 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-per-fim AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-nr-per-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-fim-per-f AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-fim-per-i AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-ini-per-f AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-ini-per-i AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE i-nr-dia AS INTEGER FORMAT ">>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 5.38.

DEFINE VARIABLE tb-multi-estabel AS LOGICAL INITIAL no 
     LABEL "Considera Multi-estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.86 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tb-multi-estabel AT ROW 3.21 COL 56.29
     pl-prod.cd-plano AT ROW 1.25 COL 18.72 COLON-ALIGNED
          LABEL "Plano":R15
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     pl-prod.descricao AT ROW 1.25 COL 23.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     CB-tipo-plano AT ROW 1.21 COL 55.29 COLON-ALIGNED NO-LABEL
     i-nr-dia AT ROW 2.25 COL 43.72 COLON-ALIGNED NO-LABEL
     pl-prod.cd-tipo AT ROW 2.25 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-desc-tipo-per AT ROW 2.25 COL 22.72 COLON-ALIGNED NO-LABEL
     c-nr-per-ini AT ROW 3.25 COL 18.72 COLON-ALIGNED
     da-dt-ini-per-i AT ROW 3.25 COL 26.72 COLON-ALIGNED NO-LABEL
     da-dt-fim-per-i AT ROW 3.25 COL 39.72 COLON-ALIGNED NO-LABEL
     c-nr-per-fim AT ROW 4.25 COL 18.72 COLON-ALIGNED
     da-dt-ini-per-f AT ROW 4.25 COL 26.72 COLON-ALIGNED NO-LABEL
     da-dt-fim-per-f AT ROW 4.25 COL 39.72 COLON-ALIGNED NO-LABEL
     pl-prod.horiz-fixo AT ROW 5.25 COL 18.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     pl-prod.nr-dias-seg AT ROW 5.25 COL 41.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.72 BY .88
     pl-prod.quant-confirm AT ROW 4.17 COL 56.29
          VIEW-AS TOGGLE-BOX
          SIZE 23 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.pl-prod
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
         HEIGHT             = 5.5
         WIDTH              = 90.14.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-tipo-per IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-per-fim IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-nr-per-ini IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX CB-tipo-plano IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN pl-prod.cd-plano IN FRAME f-main
   NO-ENABLE 1 EXP-LABEL                                                */
/* SETTINGS FOR FILL-IN da-dt-fim-per-f IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-fim-per-i IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-dt-ini-per-f IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN da-dt-ini-per-i IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN i-nr-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-multi-estabel IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
ASSIGN 
       tb-multi-estabel:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-nr-per-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-per-fim V-table-Win
ON F5 OF c-nr-per-fim IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z02in299.w
                     &campo=c-nr-per-fim
                     &campozoom=nr-perano
                     &parametros="run pi-seta-inicial in wh-pesquisa (input frame {&frame-name} pl-prod.cd-tipo)."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-per-fim V-table-Win
ON LEAVE OF c-nr-per-fim IN FRAME f-main
DO:
 
  assign pos2 = index(input frame {&frame-name} c-nr-per-fim, "/").
  assign periodo2-aux = substring(string(input frame {&frame-name} c-nr-per-fim),1,pos2 - 1,"char").
  assign ano2-aux     = substring(string(input frame {&frame-name} c-nr-per-fim),pos2 + 1,8,"char").
   

  find periodo use-index codigo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                                      periodo.ano        = integer(ano2-aux) and 
                                      periodo.nr-periodo = integer(periodo2-aux) no-error.
  if  not avail periodo then do:
      {utp/ut-liter.i Ano/Per¡odo * C}
      run utp/ut-msgs.p(input "show",
                        input 56,
                        input return-value).
      return no-apply.
  end.
  if  avail periodo then do:
     assign gr-periodo = rowid(periodo).  
     assign da-dt-ini-per-f = periodo.dt-inicio
            da-dt-fim-per-f = periodo.dt-termino.
     display da-dt-ini-per-f 
             da-dt-fim-per-f with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-per-fim V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nr-per-fim IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nr-per-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-per-ini V-table-Win
ON F5 OF c-nr-per-ini IN FRAME f-main
DO:

  {include/zoomvar.i &prog-zoom=inzoom/z02in299.w
                     &campo=c-nr-per-ini
                     &campozoom=nr-perano
                     &parametros="run pi-seta-inicial in wh-pesquisa (input frame {&frame-name} pl-prod.cd-tipo)."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-per-ini V-table-Win
ON LEAVE OF c-nr-per-ini IN FRAME f-main
DO:

  assign pos1 = index(input frame {&frame-name} c-nr-per-ini, "/").
  assign periodo1-aux = substring(string(input frame {&frame-name} c-nr-per-ini),1,pos1 - 1,"char").
  assign ano1-aux     = substring(string(input frame {&frame-name} c-nr-per-ini),pos1 + 1,8,"char").
  

  find periodo use-index codigo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                                      periodo.ano        = integer(ano1-aux) and 
                                      periodo.nr-periodo = integer(periodo1-aux) no-error.
  if  not avail periodo then do:
      {utp/ut-liter.i Ano/Per¡odo * C}
      run utp/ut-msgs.p(input "show",
                        input 56,
                        input return-value).
      return no-apply.
  end.
  if  avail periodo then do:
     assign gr-periodo = rowid(periodo).  
     assign da-dt-ini-per-i = periodo.dt-inicio
            da-dt-fim-per-i = periodo.dt-termino.
     display da-dt-ini-per-i 
             da-dt-fim-per-i with frame {&frame-name}.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nr-per-ini V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nr-per-ini IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CB-tipo-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CB-tipo-plano V-table-Win
ON VALUE-CHANGED OF CB-tipo-plano IN FRAME f-main
DO:
    if {varinc/var00090.i 06 cb-tipo-plano:screen-value} = 1 then 
     assign pl-prod.quant-confirm:sensitive in frame {&frame-name} = no.
  else 
     assign pl-prod.quant-confirm:sensitive in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-prod.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-prod.cd-tipo V-table-Win
ON F5 OF pl-prod.cd-tipo IN FRAME f-main /* Tipo Per¡odo */
DO:
    {include/zoomvar.i &prog-zoom = inzoom/z01in436.w
                       &campo = pl-prod.cd-tipo
                       &campozoom= cd-tipo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-prod.cd-tipo V-table-Win
ON LEAVE OF pl-prod.cd-tipo IN FRAME f-main /* Tipo Per¡odo */
DO:
     
    find tipo-per where tipo-per.cd-tipo = input frame {&frame-name} pl-prod.cd-tipo no-lock no-error.
    
    if  avail tipo-per then do:
        assign gr-tipo-per = rowid(tipo-per).
        assign c-desc-tipo-per = tipo-per.descricao.
        case tipo-per.tipo:
           when 3 then assign i-nr-dia = 7.
           when 2 then assign i-nr-dia = 15.
           when 1 then assign i-nr-dia = 30.
           otherwise   assign i-nr-dia = tipo-per.nr-dia.
        end.
    end.
    else
        assign c-desc-tipo-per = "":U
               i-nr-dia = 0.
               
    if pl-prod.cd-plano:sensitive in frame {&frame-name} = yes then do:
       assign l-inclusao = yes.
            
       find periodo use-index codigo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                                           periodo.dt-inicio  = today no-error.

       if avail periodo then do:
          assign gr-periodo = rowid(periodo).  
          assign da-dt-ini-per-i = periodo.dt-inicio
                 da-dt-fim-per-i = periodo.dt-termino
                 da-dt-ini-per-f = periodo.dt-inicio
                 da-dt-fim-per-f = periodo.dt-termino
                 c-nr-per-ini    = string(periodo.nr-periodo) + '/' + string(periodo.ano)
                 c-nr-per-fim    = string(periodo.nr-periodo) + '/' + string(periodo.ano).
          display da-dt-ini-per-i 
                  da-dt-fim-per-i
                  da-dt-ini-per-f 
                  da-dt-fim-per-f
                  c-nr-per-ini
                  c-nr-per-fim with frame {&frame-name}.
       end.
    
    end.

    display c-desc-tipo-per i-nr-dia with frame {&frame-name}.

 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-prod.cd-tipo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pl-prod.cd-tipo IN FRAME f-main /* Tipo Per¡odo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-dt-ini-per-f
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-ini-per-f V-table-Win
ON LEAVE OF da-dt-ini-per-f IN FRAME f-main
DO:
  find periodo use-index codigo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                                      periodo.dt-inicio  = input frame {&frame-name} da-dt-ini-per-f no-error.
  
  if avail periodo then do:
     assign gr-periodo = rowid(periodo).  
     assign da-dt-ini-per-f = periodo.dt-inicio
            da-dt-fim-per-f = periodo.dt-termino
            c-nr-per-fim    = string(periodo.nr-periodo) + '/' + string(periodo.ano).
     display da-dt-ini-per-f 
             da-dt-fim-per-f 
             c-nr-per-fim with frame {&frame-name}.
  end.
  else do:
    find periodo use-index codigo where periodo.cd-tipo    =  input frame {&frame-name} pl-prod.cd-tipo and 
                                        periodo.dt-inicio  <  input frame {&frame-name} da-dt-ini-per-f and
                                        periodo.dt-termino >= input frame {&frame-name} da-dt-ini-per-f no-error.
    if  avail periodo then do:
        assign gr-periodo = rowid(periodo).  
        assign da-dt-ini-per-f = periodo.dt-inicio
               da-dt-fim-per-f = periodo.dt-termino
               c-nr-per-fim    = string(periodo.nr-periodo) + '/' + string(periodo.ano).
        display da-dt-ini-per-f 
                da-dt-fim-per-f 
                c-nr-per-fim with frame {&frame-name}.
    end.
    else do:
        {utp/ut-liter.i Data_In¡cio_do_Per¡odo_Final * C} 
        run utp/ut-msgs.p(input "show",
                          input 56,
                          input return-value).
        return no-apply.
    end.
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-dt-ini-per-i
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-dt-ini-per-i V-table-Win
ON LEAVE OF da-dt-ini-per-i IN FRAME f-main
DO:
  find periodo use-index codigo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                                      periodo.dt-inicio  = input frame {&frame-name} da-dt-ini-per-i no-error.
  
  if avail periodo then do:
     assign gr-periodo = rowid(periodo).  
     assign da-dt-ini-per-i = periodo.dt-inicio
            da-dt-fim-per-i = periodo.dt-termino
            c-nr-per-ini    = string(periodo.nr-periodo) + '/' + string(periodo.ano).
     display da-dt-ini-per-i 
             da-dt-fim-per-i 
             c-nr-per-ini with frame {&frame-name}.
  end.
  else do:
    find periodo use-index codigo where periodo.cd-tipo    =  input frame {&frame-name} pl-prod.cd-tipo and 
                                        periodo.dt-inicio  <  input frame {&frame-name} da-dt-ini-per-i and
                                        periodo.dt-termino >= input frame {&frame-name} da-dt-ini-per-i no-error.
    if  avail periodo then do:
        assign gr-periodo = rowid(periodo).  
        assign da-dt-ini-per-i = periodo.dt-inicio
               da-dt-fim-per-i = periodo.dt-termino
               c-nr-per-ini    = string(periodo.nr-periodo) + '/' + string(periodo.ano).
        display da-dt-ini-per-i 
                da-dt-fim-per-i 
                c-nr-per-ini with frame {&frame-name}.
    end.
    else do:
        {utp/ut-liter.i Data_In¡cio_do_Per¡odo_Inicial * C} 
        run utp/ut-msgs.p(input "show",
                          input 56,
                          input return-value).
        return no-apply.
    end.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pl-prod.quant-confirm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pl-prod.quant-confirm V-table-Win
ON VALUE-CHANGED OF pl-prod.quant-confirm IN FRAME f-main /* Considera Qtde Conf */
DO:

   if  input frame {&frame-name} cb-tipo-plano:screen-value = "1" then do:
       assign pl-prod.quant-confirm:checked in frame {&frame-name} = no.
       assign pl-prod.quant-confirm:sensitive in frame {&frame-name} = no.
   end.

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

if pl-prod.cd-tipo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if c-nr-per-ini:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if c-nr-per-fim:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

{utp/ut-liter.i Per¡odo_Inicial * r}
assign c-nr-per-ini:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Per¡odo_Final * r}
assign c-nr-per-fim:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Considera_Multi_Estabelecimento * r}
assign tb-multi-estabel:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Plano_C lculo *}
assign pl-prod.cd-plano:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "pl-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-prod"}

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
  
  &IF DEFINED(bf_man_203) &THEN 
      assign tb-multi-estabel:checked in frame {&frame-name} = no.
  &ENDIF
   
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
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  do with frame {&frame-name}:
     assign i-lin-tiplan = {varinc/var00090.i 06 cb-tipo-plano:screen-value}.
  end.
  
  assign c-tipo-plano = if adm-new-record = no then
                           pl-prod.tipo-plano
                        else "" 
         c-tiplan-atu = (if i-lin-tiplan = 1   
                         then "PV"
                         else "PP").

 /* Dispatch standard ADM method.                             */

 assign l-assign-record = yes.
 
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  

 assign l-assign-record = no.
 
  assign l-confirma = yes
         pl-prod.tipo-plano = c-tiplan-atu.
  if  c-tipo-plano = "PV"
  and pl-prod.tipo-plano = "PP" then
      nivel:
      for each pl-it-prod use-index codigo
          where pl-it-prod.cd-plano = pl-prod.cd-plano no-lock,
           each item use-index codigo
          where item.it-codigo = pl-it-prod.it-codigo no-lock:
          if  item.niv-mais-bai <> 0 then do:
              assign l-confirma = no.
              leave nivel.
          end.
      end.
  if  l-confirma = no then do:
      run utp/ut-msgs.p (input "show",
                         input 345,
                         input return-value).
      if  return-value = "no":U then do:
          apply 'entry' to cb-tipo-plano in frame {&frame-name}.
      end.
  end.
  if  l-confirma = yes then do:
      if  not(c-tipo-plano <> pl-prod.tipo-plano and  pl-prod.pl-estado = 1) then
          assign pl-prod.regera-plano = yes.
  end.

/* Consiste tipo de periodo */
  
  if  pl-prod.cd-tipo entered then do:
      for each  pl-it-prod 
          where pl-it-prod.cd-plano = input frame {&frame-name} pl-prod.cd-plano:
          find periodo use-index codigo where
               periodo.cd-tipo    = pl-prod.cd-tipo    and
               periodo.ano        = pl-it-prod.ano     and
               periodo.nr-periodo = pl-it-prod.periodo no-lock no-error.
          if  not avail periodo then
              assign l-todos = yes.
          else 
             if avail periodo 
                and   periodo.dt-termino <> da-dt-fim-per-i then 
                assign l-todos = yes.
      end.
      if l-todos = yes then do:
         run utp/ut-msgs.p (input "show",
                            input 346,
                            input "").
         if  return-value = "yes":U then 
             for each  pl-it-prod 
                 where pl-it-prod.cd-plano = input frame {&frame-name} pl-prod.cd-plano:
                 delete pl-it-prod.
             end.
      end.
  end.

/* Consiste pl-it-prod dentro dos per¡odos do Plano */  
   
/*  assign pos1 = index(input frame {&frame-name} c-nr-per-ini, "/").
 *   assign periodo1-aux = substring(string(input frame {&frame-name} c-nr-per-ini),1,pos1 - 1,"char").
 *   assign ano1-aux     = substring(string(input frame {&frame-name} c-nr-per-ini),pos1 + 1,8,"char").
 *    
 *   assign pos2 = index(input frame {&frame-name} c-nr-per-fim, "/").
 *   assign periodo2-aux = substring(string(input frame {&frame-name} c-nr-per-fim),1,pos2 - 1,"char").
 *   assign ano2-aux     = substring(string(input frame {&frame-name} c-nr-per-fim),pos2 + 1,8,"char").*/
 
  find first periodo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                           periodo.ano        = integer(ano1-aux) and 
                           periodo.nr-periodo = integer(periodo1-aux) no-lock no-error.
                           
  assign da-data-ini = periodo.dt-inicio.
  
  find first periodo where periodo.cd-tipo = input frame {&frame-name} pl-prod.cd-tipo and
                           periodo.nr-per  = integer(periodo2-aux) and 
                           periodo.ano     = integer(ano2-aux) no-lock no-error.
                           
  assign da-data-fim = periodo.dt-termino.

  find first pl-it-prod
       where pl-it-prod.cd-plano = input frame {&frame-name} pl-prod.cd-plano
       and   pl-it-prod.dt-termino < da-data-ini no-lock no-error.
  if avail pl-it-prod then 
     assign l-it-fora = yes.
  
  find last  pl-it-prod
       where pl-it-prod.cd-plano = input frame {&frame-name} pl-prod.cd-plano
       and   pl-it-prod.dt-termino > da-data-fim no-lock no-error.
  if avail pl-it-prod then 
     assign l-it-fora = yes.

  if l-it-fora = yes and
     l-todos = no then do:
     run utp/ut-msgs.p (input "show",
                        input 346,
                        input "").
     if  return-value = "yes":U then do:
         for each  pl-it-prod 
             where pl-it-prod.cd-plano = input frame {&frame-name} pl-prod.cd-plano
             and   pl-it-prod.dt-termino < da-data-ini 
             or    pl-it-prod.dt-termino > da-data-fim:
             delete pl-it-prod.
         end.
     end.
  end.
    
  if  pl-prod.tipo-plano <> "PP" 
  and pl-prod.quant-confirm = yes then
      assign pl-prod.quant-confirm = no.

  &IF DEFINED (bf_man_sfc_lc) &THEN
  if  (pl-prod.nr-per-fim  <> integer(periodo2-aux) or  
       pl-prod.ano-per-fim <> integer(ano2-aux))    and 
       pl-prod.pl-estado    = 1 then
       assign pl-prod.regera-plano = yes.
  &ELSE
  if  (pl-prod.nr-per-fim  <> integer(periodo2-aux) or  
       pl-prod.ano-per-fim <> integer(ano2-aux))    and 
       pl-prod.pl-estado    = 1 then
       assign pl-prod.regera-plano = yes.  
  &ENDIF
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  assign pl-prod.nr-per-ini   = integer(periodo1-aux)
         pl-prod.ano-per-ini  = integer(ano1-aux)
         pl-prod.nr-per-fim   = integer(periodo2-aux)
         pl-prod.ano-per-fim  = integer(ano2-aux).
           
  &IF DEFINED(bf_man_203) &THEN
      assign pl-prod.log-multi-estabel = if  int(tb-multi-estabel) = 1 
                                         then yes
                                         else no.
  &ENDIF                                         
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
  &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
  disable {&ADM-MODIFY-FIELDS} with frame {&FRAME-NAME}.
  &ENDIF
  
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

  if  available pl-prod and not l-assign-record then do:

     find first tipo-per where tipo-per.cd-tipo = pl-prod.cd-tipo no-lock no-error.  
         
     if avail tipo-per then         
     assign c-desc-tipo-per = tipo-per.descricao
             i-nr-dia       = tipo-per.nr-dia.
               
      find first periodo where periodo.cd-tipo = pl-prod.cd-tipo and 
                               periodo.nr-per  = pl-prod.nr-per-ini and 
                               periodo.ano     = pl-prod.ano-per-ini no-lock no-error.
      
      if avail periodo then 
         assign da-dt-ini-per-i = periodo.dt-inicio
                da-dt-fim-per-i = periodo.dt-termino
                c-nr-per-ini    = string(pl-prod.nr-per-ini) + '/' + string(pl-prod.ano-per-ini).

      else
         assign da-dt-ini-per-i = ?
                da-dt-fim-per-i = ?.

      find first periodo where periodo.cd-tipo = pl-prod.cd-tipo and 
                               periodo.nr-per  = pl-prod.nr-per-fim and 
                               periodo.ano     = pl-prod.ano-per-fim no-lock no-error.
      
      if avail periodo then 
         assign da-dt-ini-per-f = periodo.dt-inicio
                da-dt-fim-per-f = periodo.dt-termino
                c-nr-per-fim    = string(pl-prod.nr-per-fim) + '/' + string(pl-prod.ano-per-fim).

      else
         assign da-dt-ini-per-f = ?
                da-dt-fim-per-f = ?.
                
                
  end.
  
  if l-assign-record then do:
      assign c-dt-ini-per-i-aux = input frame {&frame-name} da-dt-ini-per-i
             c-dt-fim-per-i-aux = input frame {&frame-name} da-dt-fim-per-i
             c-nr-per-ini-aux   = input frame {&frame-name} c-nr-per-ini
             c-dt-ini-per-f-aux = input frame {&frame-name} da-dt-ini-per-f    
             c-dt-fim-per-f-aux = input frame {&frame-name} da-dt-fim-per-f
             c-nr-per-fim-aux   = input frame {&frame-name} c-nr-per-fim.  
  end.
  
  /* Dispatch standard ADM method. */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
  if l-assign-record then do:
      assign da-dt-ini-per-i = c-dt-ini-per-i-aux
             da-dt-fim-per-i = c-dt-fim-per-i-aux
             c-nr-per-ini    = c-nr-per-ini-aux
             da-dt-ini-per-f = c-dt-ini-per-f-aux
             da-dt-fim-per-f = c-dt-fim-per-f-aux
             c-nr-per-fim    = c-nr-per-fim-aux.
      disp   da-dt-ini-per-i
             da-dt-fim-per-i
             c-nr-per-ini   
             da-dt-ini-per-f
             da-dt-fim-per-f
             c-nr-per-fim with frame {&frame-name}.           
  end.
  
  if avail pl-prod and not l-assign-record then do:
     do with frame {&frame-name}:        
        assign i-lin-tiplan = (if pl-prod.tipo-plan = "PV" then 
                                  1
                               else 
                                  2)
               cb-tipo-plano:screen-value = {varinc/var00090.i 04 i-lin-tiplan}.
     end.
     
     &IF DEFINED (bf_man_203) &THEN
     assign tb-multi-estabel:checked in frame {&frame-name} = if pl-prod.log-multi-estabel 
                                                              then yes
                                                              else no.
     &ENDIF                                                             
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  &IF DEFINED(ADM-MODIFY-FIELDS) &THEN
  enable {&ADM-MODIFY-FIELDS} with frame {&FRAME-NAME}.
  &ENDIF
  
  if {varinc/var00090.i 06 cb-tipo-plano:screen-value} = 1 then 
     assign pl-prod.quant-confirm:sensitive in frame {&frame-name} = no.
  else 
     assign pl-prod.quant-confirm:sensitive in frame {&frame-name} = yes.
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
     assign cb-tipo-plano:list-items = {varinc/var00090.i 03}.
  end.   
  
  &IF DEFINED(bf_man_203) &THEN
      assign tb-multi-estabel:hidden in frame {&frame-name} = no.
  &ELSE
      assign tb-multi-estabel:hidden in frame {&frame-name} = yes.
  &ENDIF
  
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

  /* Code placed here will execute AFTER standard behavior.    */

  find tipo-per where tipo-per.cd-tipo = input frame {&frame-name} pl-prod.cd-tipo no-lock no-error.
  if avail tipo-per then
     assign gr-tipo-per = rowid(tipo-per).   

/*  assign pos1 = index(input frame {&frame-name} c-nr-per-ini, "/").
 *   assign periodo1-aux = substring(string(input frame {&frame-name} c-nr-per-ini),1,pos1 - 1,"char").
 *   assign ano1-aux     = substring(string(input frame {&frame-name} c-nr-per-ini),pos1 + 1,8,"char").
 *    
 *   assign pos2 = index(input frame {&frame-name} c-nr-per-fim, "/").
 *   assign periodo2-aux = substring(string(input frame {&frame-name} c-nr-per-fim),1,pos2 - 1,"char").
 *   assign ano2-aux     = substring(string(input frame {&frame-name} c-nr-per-fim),pos2 + 1,8,"char").*/
  
  find first periodo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                           periodo.ano        = integer(ano1-aux) and 
                           periodo.nr-periodo = integer(periodo1-aux) no-lock no-error.
  if  avail periodo then 
      assign gr-periodo = rowid(periodo).     

  if avail pl-prod then
     assign gr-pl-prod = rowid(pl-prod).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
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

  if  pl-prod.cd-plano:sensitive in frame {&frame-name} = yes
  and can-find(b-pl-prod
      where b-pl-prod.cd-plano = input frame {&frame-name} pl-prod.cd-plano) then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind pl-prod 1}
      run utp/ut-msgs.p (input "show",
                         input 7,
                         input return-value).
      return 'adm-error':U.
  end.
  
  assign l-resposta = no.

  /****** Acha Per¡odo e Ano Inicial ************/

  assign pos1 = index(input frame {&frame-name} c-nr-per-ini, "/").
  assign periodo1-aux = substring(string(input frame {&frame-name} c-nr-per-ini),1,pos1 - 1,"char").
  assign ano1-aux     = substring(string(input frame {&frame-name} c-nr-per-ini),pos1 + 1,8,"char").
   
  /****** Acha Per¡odo e Ano Final **************/

  assign pos2 = index(input frame {&frame-name} c-nr-per-fim, "/").
  assign periodo2-aux = substring(string(input frame {&frame-name} c-nr-per-fim),1,pos2 - 1,"char").
  assign ano2-aux     = substring(string(input frame {&frame-name} c-nr-per-fim),pos2 + 1,8,"char").
   
  find first periodo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                           periodo.ano        = integer(ano1-aux) and 
                           periodo.nr-periodo = integer(periodo1-aux) no-lock no-error.


  if  not avail periodo then do:
      {include/i-vldprg.i}
      {utp/ut-liter.i Ano/Per¡odo * C}
      run utp/ut-msgs.p(input "show",
                        input 56,
                        input return-value).
      apply 'entry' to c-nr-per-ini in frame {&frame-name}.
      return 'adm-error':U.
  end.

  find periodo use-index codigo where periodo.cd-tipo    = input frame {&frame-name} pl-prod.cd-tipo and 
                                      periodo.ano        = integer(ano2-aux) and 
                                      periodo.nr-periodo = integer(periodo2-aux) no-error.
  if  not avail periodo then do:
      {utp/ut-liter.i Ano/Per¡odo * R}
      {include/i-vldprg.i}
      run utp/ut-msgs.p(input "show",
                        input 56,
                        input return-value).
      apply 'entry' to c-nr-per-fim in frame {&frame-name}.
      return 'adm-error':U.
  end.
  
  if  integer(ano2-aux) < integer(ano1-aux) then do:
      {utp/ut-liter.i Per¡odo/Ano * R}
      {include/i-vldprg.i}
      run utp/ut-msgs.p(input "show",
                        input 354,
                        input return-value).
      apply 'entry' to c-nr-per-fim in frame {&frame-name}.
      return 'adm-error':U.
  end.
  if  integer(ano2-aux) = integer(ano1-aux) then
      if  integer(periodo2-aux) < integer(periodo1-aux) then do:
          {utp/ut-liter.i Per¡odo/Ano * R}
          {include/i-vldprg.i}
          run utp/ut-msgs.p(input "show",
                            input 354,
                            input return-value).
          apply 'entry' to c-nr-per-fim in frame {&frame-name}.
          return 'adm-error':U.
      end.
/** Valida‡Æo retirada pois campo configurado nÆo faz mais parte do planejamento **/
/*   if  input frame {&frame-name} cb-tipo-plano:row = 2         */
/*   and tb-config:checked in frame {&frame-name} = yes then do: */
/*       run utp/ut-msgs.p(input "show",                         */
/*                        input 16233,                           */
/*                        input return-value).                   */
/*       apply 'entry' to tb-config in frame {&frame-name}.      */
/*       return 'adm-error':U.                                   */
/*   end.                                                        */
  
  &IF DEFINED(bf_man_203) &THEN
      if input frame {&frame-name} tb-multi-estabel = yes then do:
         find first pl-it-prod where pl-it-prod.cd-plano 
                                   = input frame {&frame-name} pl-prod.cd-plano
                                 and pl-it-prod.cod-estabel = ""
                               no-lock no-error.
         if available pl-it-prod then do:                   
            run utp/ut-msgs.p(input "show",
                              input 16233,
                              input return-value).
            apply 'entry' to tb-multi-estabel in frame {&frame-name}.
            return 'adm-error':U.
         end.
      end.
      else do:
         find first pl-it-prod where pl-it-prod.cd-plano 
                                   = input frame {&frame-name} pl-prod.cd-plano
                                 and pl-it-prod.cod-estabel > ""
                               no-lock no-error.
         if available pl-it-prod then do:
            run utp/ut-msgs.p(input "show",
                              input 16233,
                              input return-value).
            apply 'entry' to tb-multi-estabel in frame {&frame-name}.
            return 'adm-error':U.
         end.
      end.
  &ENDIF       








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
  {src/adm/template/snd-list.i "pl-prod"}

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

