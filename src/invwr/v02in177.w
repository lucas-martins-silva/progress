&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V02IN177 2.00.00.023}  /*** 010023 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN177 MUT}
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
{include/i-vrtab.i item-estab}

/* Local Variable Definitions ---                                       */

def var     l-param          as logical init yes no-undo.
 
def new shared var i-ano-corrente                 as integer initial 0          no-undo.
def new shared var i-per-corrente                 as integer initial 0          no-undo.
def new shared var da-iniper-x                    like param-estoq.mensal-ate   NO-UNDO.
def new shared var da-fimper-x                    like param-estoq.mensal-ate   NO-UNDO.
def var            da-iniper-fech                 as date                       no-undo.
def var            da-fimper-fech                 as date                       no-undo.
def var            ct-initial                     as char format "x(20)"        no-undo.
def var            sc-initial                     as char format "x(20)"        no-undo.

def var i-param as int no-undo.

{cdp/cdcfgmat.i}
 
{cdp/cd0666.i}      /* Definicao da temp-table de erros */

{cep/ceapi007.i}    /* Definicao da temp-table tt-valores*/

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
&Scoped-define EXTERNAL-TABLES item-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-estab.atualizado 
&Scoped-define ENABLED-TABLES item-estab
&Scoped-define FIRST-ENABLED-TABLE item-estab
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-3 RECT-5 
&Scoped-Define DISPLAYED-FIELDS item-estab.cod-estabel ~
item-estab.atualizado item-estab.it-codigo 
&Scoped-define DISPLAYED-TABLES item-estab
&Scoped-define FIRST-DISPLAYED-TABLE item-estab
&Scoped-Define DISPLAYED-OBJECTS c-desc-est c-descricao c-depos-pad ~
c-desc-dep de-val-mat1 de-val-mob1 de-val-ggf1 tb-moeda-1 de-val-mat2 ~
de-val-mob2 de-val-ggf2 tb-moeda-2 de-val-mat3 de-val-mob3 de-val-ggf3 ~
tb-moeda-3 c-tit-mat c-tit-mob c-tit-ggf 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS tb-moeda-1 tb-moeda-2 tb-moeda-3 
&Scoped-define ADM-MODIFY-FIELDS c-depos-pad de-val-mat1 de-val-mob1 ~
de-val-ggf1 tb-moeda-1 de-val-mat2 de-val-mob2 de-val-ggf2 tb-moeda-2 ~
de-val-mat3 de-val-mob3 de-val-ggf3 tb-moeda-3 

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
DEFINE VARIABLE c-depos-pad AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito Acerto" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-dep AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 36.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-est AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 45.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-tit-ggf AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-mat AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-tit-mob AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE de-val-ggf1 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-ggf2 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-ggf3 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat1 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat2 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mat3 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob1 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob2 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-mob3 AS DECIMAL FORMAT "->>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 7.29.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.57 BY 2.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 4.75.

DEFINE VARIABLE tb-moeda-1 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-moeda-2 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-moeda-3 AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-estab.cod-estabel AT ROW 1.25 COL 20.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.86 BY .88
     c-desc-est AT ROW 1.25 COL 26.72 COLON-ALIGNED NO-LABEL
     item-estab.atualizado AT ROW 1.29 COL 81.14
          VIEW-AS TOGGLE-BOX
          SIZE 3.72 BY .83
     item-estab.it-codigo AT ROW 2.25 COL 20.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 2.25 COL 38.29 COLON-ALIGNED NO-LABEL
     c-depos-pad AT ROW 4.5 COL 20.72 COLON-ALIGNED
     c-desc-dep AT ROW 4.5 COL 26.86 COLON-ALIGNED NO-LABEL
     de-val-mat1 AT ROW 7.33 COL 11.29 COLON-ALIGNED
     de-val-mob1 AT ROW 7.38 COL 31.86 COLON-ALIGNED NO-LABEL
     de-val-ggf1 AT ROW 7.38 COL 52.43 COLON-ALIGNED NO-LABEL
     tb-moeda-1 AT ROW 7.33 COL 74.29
     de-val-mat2 AT ROW 8.33 COL 11.29 COLON-ALIGNED
     de-val-mob2 AT ROW 8.38 COL 31.86 COLON-ALIGNED NO-LABEL
     de-val-ggf2 AT ROW 8.38 COL 52.43 COLON-ALIGNED NO-LABEL
     tb-moeda-2 AT ROW 8.33 COL 74.29
     de-val-mat3 AT ROW 9.33 COL 11.29 COLON-ALIGNED
     de-val-mob3 AT ROW 9.38 COL 31.86 COLON-ALIGNED NO-LABEL
     de-val-ggf3 AT ROW 9.38 COL 52.43 COLON-ALIGNED NO-LABEL
     tb-moeda-3 AT ROW 9.33 COL 74.29
     c-tit-mat AT ROW 6.33 COL 13.29 COLON-ALIGNED NO-LABEL
     c-tit-mob AT ROW 6.38 COL 32.86 COLON-ALIGNED NO-LABEL
     c-tit-ggf AT ROW 6.38 COL 53.43 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 3.75 COL 1
     RECT-3 AT ROW 1 COL 1
     RECT-5 AT ROW 6.08 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-estab
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
         HEIGHT             = 10.04
         WIDTH              = 86.86.
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

ASSIGN 
       item-estab.atualizado:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-depos-pad IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-desc-dep IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-ggf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-mat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tit-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-estab.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-ggf1 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-ggf2 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-ggf3 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-mat1 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-mat2 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-mat3 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-mob1 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-mob2 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-val-mob3 IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN item-estab.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-moeda-1 IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX tb-moeda-2 IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX tb-moeda-3 IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME c-depos-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-pad V-table-Win
ON F5 OF c-depos-pad IN FRAME f-main /* Dep¢sito Acerto */
DO:
  
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=c-depos-pad
                     &campo2=c-desc-dep
                     &campozoom=cod-depos
                     &campozoom2=c-desc-dep}    
                     
                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-pad V-table-Win
ON LEAVE OF c-depos-pad IN FRAME f-main /* Dep¢sito Acerto */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=c-desc-dep
                   &where="deposito.cod-depos = input frame {&frame-name} c-depos-pad"}              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-depos-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-depos-pad IN FRAME f-main /* Dep¢sito Acerto */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON F5 OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=item-estab.cod-estabel
                     &campo2=c-desc-est
                     &campozoom=cod-estabel
                     &campozoom2=nome}    
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON LEAVE OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-est
                   &where="estabelec.cod-estabel = input frame {&frame-name} 
                           item-estab.cod-estabel"}  

end.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  apply "F5" to self.
  find first estabelec where 
       estabelec.cod-estabel = input frame {&frame-name} item-estab.cod-estabel 
       no-lock no-error.
  if avail estabelec then do with frame {&frame-name}:
      assign c-desc-est = estabelec.nome.       
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON F5 OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=item-estab.it-codigo
                     &campo2=c-descricao
                     &campozoom=it-codigo
                     &campozoom2=desc-item}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON LEAVE OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
   
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-descricao
                   &where="item.it-codigo = input frame {&frame-name}
                                                  item-estab.it-codigo"}
 find first item where 
       item.it-codigo = input frame {&frame-name} item-estab.it-codigo 
       no-lock no-error.
  if available item then do with frame {&frame-name}: 
      assign c-depos-pad:screen-value in frame {&frame-name} = item.deposito-pad.
  end.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-moeda-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-moeda-1 V-table-Win
ON VALUE-CHANGED OF tb-moeda-1 IN FRAME f-main
DO:
  assign de-val-mat1:sensitive = tb-moeda-1:checked
         de-val-mob1:sensitive = tb-moeda-1:checked
         de-val-ggf1:sensitive = tb-moeda-1:checked.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-moeda-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-moeda-2 V-table-Win
ON VALUE-CHANGED OF tb-moeda-2 IN FRAME f-main
DO:
  assign de-val-mat2:sensitive = tb-moeda-2:checked
         de-val-mob2:sensitive = tb-moeda-2:checked
         de-val-ggf2:sensitive = tb-moeda-2:checked.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-moeda-3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-moeda-3 V-table-Win
ON VALUE-CHANGED OF tb-moeda-3 IN FRAME f-main
DO:
  assign de-val-mat3:sensitive = tb-moeda-3:checked
         de-val-mob3:sensitive = tb-moeda-3:checked
         de-val-ggf3:sensitive = tb-moeda-3:checked.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if c-depos-pad:load-mouse-pointer ("image~\lupa.cur")            in frame {&frame-name} then.
  
  if item-estab.cod-estabel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.  
  
  if item-estab.it-codigo:load-mouse-pointer ("image\lupa.cur")   in frame {&frame-name} then.
  
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
  {src/adm/template/row-list.i "item-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-estab"}

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

  for each tt-valores:
      delete tt-valores.
  end.

  FOR EACH tt-erro:
      DELETE tt-erro.
  END.

  &if defined (bf_mat_fech_estab) &then
    
    IF  param-estoq.tp-fech = 2  THEN DO: /* 1 - unico 2 - estabelecimento */
        FOR FIRST estab-mat FIELDS(cod-estabel mensal-ate tipo-pr-med ult-per-fech)
            WHERE estab-mat.cod-estabel = input frame {&frame-name} item-estab.cod-estabel NO-LOCK:

            run cdp/cdapi005.p (input estab-mat.ult-per-fech,
                                output da-iniper-x,
                                output da-fimper-x,
                                output i-per-corrente,
                                output i-ano-corrente,
                                output da-iniper-fech,
                                output da-fimper-fech).

            if (estab-mat.tipo-pr-med = 2 and estab-mat.mensal-ate > da-iniper-x)  or
               (estab-mat.tipo-pr-med = 1 and estab-mat.mensal-ate >= da-fimper-x) then do:
                run utp/ut-msgs.p(input "msg", input 6466, input "").    
                CREATE tt-erro.
                ASSIGN tt-erro.i-sequen = 1
                       tt-erro.cd-erro  = 6466
                       tt-erro.mensagem = TRIM(RETURN-VALUE).
            end.
        END.
    END.    

   /* FOR FIRST estab-mat FIELDS(conta-act-medio) */
    FOR FIRST estab-mat FIELDS(cod-cta-act-unif cod-ccusto-act-unif)
        WHERE estab-mat.cod-estabel = input frame {&frame-name} item-estab.cod-estabel NO-LOCK:
       /* if  estab-mat.conta-act-medio = ct-initial + sc-initial  then do: */
        if  estab-mat.cod-cta-act-unif    = ct-initial and
            estab-mat.cod-ccusto-act-unif = sc-initial  then do: 
            run utp/ut-msgs.p(input "msg", input 6476, input "").    
            CREATE tt-erro.
            ASSIGN tt-erro.i-sequen = 1
                   tt-erro.cd-erro  = 6476
                   tt-erro.mensagem = TRIM(RETURN-VALUE).
        end.
    END.

  &ENDIF

  find first tt-erro no-lock no-error.
  if avail tt-erro 
  then do: run cdp/cd0666.w (input table tt-erro).
           apply "entry" to c-depos-pad in frame {&frame-name}.
           return 'ADM-ERROR':U.
  end.


if l-param then assign i-param = 1.
           else assign i-param = 2.

 create tt-valores.
 assign tt-valores.cod-versao-integracao = 1
        tt-valores.cod-prog-orig   = "v02in177"
        tt-valores.item  = input frame {&frame-name} item-estab.it-codigo
        tt-valores.estab = input frame {&frame-name} item-estab.cod-estabel
        tt-valores.depos = input frame {&frame-name} c-depos-pad
        tt-valores.atu-1 = input frame {&frame-name} tb-moeda-1
        tt-valores.atu-2 = input frame {&frame-name} tb-moeda-2
        tt-valores.atu-3 = input frame {&frame-name} tb-moeda-3
        tt-valores.de-val-mat-1 = input frame {&frame-name} de-val-mat1
        tt-valores.de-val-mob-1 = input frame {&frame-name} de-val-mob1
        tt-valores.de-val-ggf-1 = input frame {&frame-name} de-val-ggf1
        tt-valores.de-val-mat-2 = input frame {&frame-name} de-val-mat2
        tt-valores.de-val-mob-2 = input frame {&frame-name} de-val-mob2
        tt-valores.de-val-ggf-2 = input frame {&frame-name} de-val-ggf2
        tt-valores.de-val-mat-3 = input frame {&frame-name} de-val-mat3
        tt-valores.de-val-mob-3 = input frame {&frame-name} de-val-mob3
        tt-valores.de-val-ggf-3 = input frame {&frame-name} de-val-ggf3
        tt-valores.i-inifim     = i-param.

 run cep/ceapi007.p (input-output table tt-valores,
                     input-output table tt-erro).
                     
if session:set-wait-state ("") then.      

find first tt-erro no-lock no-error.
if avail tt-erro 
then do: run cdp/cd0666.w (input table tt-erro).
         apply "entry" to c-depos-pad in frame {&frame-name}.
         return 'ADM-ERROR':U.
end.

 /* Dispatch standard ADM method.                             
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.*/
  /* Code placed here will execute AFTER standard behavior.    */
  
  run dispatch in this-procedure (input "disable-fields").
  RUN new-state('update-complete':U). 
  
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
  
  /* Dispatch standard ADM meth*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-liter.i Material * L}  
  assign c-tit-mat  =  return-value.
         
  {utp/ut-liter.i MÆo-de-Obra * L}  
  assign c-tit-mob = return-value.
  
  {utp/ut-liter.i GGF * L}  
  assign c-tit-ggf = return-value.
  
  disp c-tit-mat
       c-tit-mob
       c-tit-ggf with frame {&frame-name}.
   
  IF avail item-estab THEN DO with frame {&frame-name}:
    
    find first item where item.it-codigo = item-estab.it-codigo no-lock no-error.
    if avail item then      
        assign c-descricao:screen-value = item.desc-item.
    
    find first estabelec where estabelec.cod-estabel = item-estab.cod-estabel no-lock no-error.
    if avail estabelec then
         assign c-desc-est:screen-value = estabelec.nome.     
                       
  END.
 
  /*assign item-estab.it-codigo 
 *          item-estab.cod-estabel:sensitive in frame {&frame-name} = no .*/
 
 if avail item-estab then
    run pi-mostra-valores.
  
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
  if param-estoq.tem-moeda1 = no then do:
     assign de-val-mat2:visible in frame {&frame-name} = no.
     assign de-val-mob2:visible in frame {&frame-name} = no.
     assign de-val-ggf2:visible in frame {&frame-name} = no.
     assign tb-moeda-2:visible in frame {&frame-name} = no.
  end.
   
  if param-estoq.tem-moeda2 = no then do:
     assign de-val-mat3:visible in frame {&frame-name} = no.
     assign de-val-mob3:visible in frame {&frame-name} = no.
     assign de-val-ggf3:visible in frame {&frame-name} = no.
     assign tb-moeda-3:visible in frame {&frame-name} = no.
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
  
  find first param-estoq no-lock no-error.

  {utp/ut-liter.i Dep¢sito_Acerto}
  assign c-depos-pad:label in frame {&FRAME-NAME} = trim(return-value).
  
  {utp/ut-liter.i Material * L}  
  assign c-tit-mat:screen-value in frame {&frame-name} =  return-value.
        
  {utp/ut-liter.i MÆo-de-Obra * L}  
  assign c-tit-mob:screen-value in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i GGF * L}  
  assign c-tit-ggf:screen-value in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Atualiza * l}
  assign tb-moeda-1:label in frame {&frame-name} = return-value
         tb-moeda-2:label in frame {&frame-name} = return-value
         tb-moeda-3:label in frame {&frame-name} = return-value.
 
  find moeda where moeda.mo-codigo = 0 no-lock no-error.
  if avail moeda then do:
     assign de-val-mat1:label in frame {&frame-name} = moeda.descricao.
  end.
  
  if param-estoq.tem-moeda1 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
     if avail moeda then do:
        assign de-val-mat2:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-val-mat2:visible in frame {&frame-name} = no.
      assign de-val-mob2:visible in frame {&frame-name} = no.
      assign de-val-ggf2:visible in frame {&frame-name} = no.
      assign tb-moeda-2:visible  in frame {&frame-name} = no.
  end.
   
  if param-estoq.tem-moeda2 then do:
     find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
     if avail moeda then do:
        assign de-val-mat3:label in frame {&frame-name} = moeda.descricao.
     end.
  end.
  else do:
      assign de-val-mat3:visible in frame {&frame-name} = no.
      assign de-val-mob3:visible in frame {&frame-name} = no.
      assign de-val-ggf3:visible in frame {&frame-name} = no.
      assign tb-moeda-3:visible  in frame {&frame-name} = no.
  end.
  if  avail item-estab 
  then  run pi-mostra-valores in this-procedure.
        
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
  
  if avail item-estab then
     assign gr-item-estab = rowid(item-estab).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-valores V-table-Win 
PROCEDURE pi-mostra-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/     
     assign de-val-mat1 = item-estab.val-unit-mat-m[1]
            de-val-mat2 = item-estab.val-unit-mat-m[2]
            de-val-mat3 = item-estab.val-unit-mat-m[3]
            de-val-mob1 = item-estab.val-unit-mob-m[1]
            de-val-mob2 = item-estab.val-unit-mob-m[2]
            de-val-mob3 = item-estab.val-unit-mob-m[3]
            de-val-ggf1 = item-estab.val-unit-ggf-m[1]
            de-val-ggf2 = item-estab.val-unit-ggf-m[2]
            de-val-ggf3 = item-estab.val-unit-ggf-m[3].
            
     if param-estoq.tem-moeda1 = yes and param-estoq.tem-moeda2 = yes then 
        display de-val-mat1
                de-val-mat2 
                de-val-mat3
                de-val-mob1
                de-val-mob2
                de-val-mob3
                de-val-ggf1
                de-val-ggf2
                de-val-ggf3   with frame {&frame-name}.

     if param-estoq.tem-moeda1 = no and param-estoq.tem-moeda2 = no then
        display de-val-mat1
                de-val-mob1
                de-val-ggf1 with frame {&frame-name}.

     if param-estoq.tem-moeda1 = no and param-estoq.tem-moeda2 = yes then
        display de-val-mat1 
                de-val-mat3
                de-val-mob1
                de-val-mob3
                de-val-ggf1
                de-val-ggf3 with frame {&frame-name}.

     if param-estoq.tem-moeda1 = yes and  param-estoq.tem-moeda2 = no then 
        display de-val-mat1 
                de-val-mat2
                de-val-mob1
                de-val-mob2
                de-val-ggf1
                de-val-ggf2
                with frame {&frame-name}.
  
  if param-estoq.tem-moeda1 = no then do:
     assign de-val-mat2:visible in frame {&frame-name} = no.
     assign de-val-mob2:visible in frame {&frame-name} = no.
     assign de-val-ggf2:visible in frame {&frame-name} = no.
  end.
   
  if param-estoq.tem-moeda2 = no then do:
     assign de-val-mat3:visible in frame {&frame-name} = no.
     assign de-val-mob3:visible in frame {&frame-name} = no.
     assign de-val-ggf3:visible in frame {&frame-name} = no.
     
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-valores V-table-Win 
PROCEDURE pi-seta-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter p-param  as logical  no-undo.

assign l-param = p-param.
       
run pi-mostra-valores in this-procedure.

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
  {src/adm/template/snd-list.i "item-estab"}

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

