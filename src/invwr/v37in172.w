&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V37IN172 2.00.02.007 } /*** 010207 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v37in172 MUT}
&ENDIF

{include/i_fnctrad.i}
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
def new global shared var gr-it-periodo as rowid no-undo.
def new global shared var gr-item       as rowid no-undo.
def new global shared var gr-pl-prod    as rowid no-undo.
def new global shared var gr-pl-it-calc as rowid no-undo.

def new global shared var i-cd-plano      like pl-prod.cd-plano      no-undo.
def new global shared var c-estabel-plano like estabelec.cod-estabel no-undo.

def var de-saldo    like pl-it-calc.saldo no-undo.
def var wh-pesquisa as handle no-undo.
def var c-resp      as char.
def var c-cod-refer like it-periodo.cod-refer.
DEF var i-cont        as int  no-undo.
def var c-programa    as char no-undo.
def var i-horiz-liber as int  no-undo.
def var i-horiz-fixo  as int  no-undo.
def var c-label-qtde  as char no-undo.
def var c-label-tempo as char no-undo.
{cdp/cdcfgman.i}

def buffer b-rot-item for rot-item.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES pl-it-calc
&Scoped-define FIRST-EXTERNAL-TABLE pl-it-calc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pl-it-calc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.pto-repos pl-it-calc.char-2 
&Scoped-define ENABLED-TABLES item pl-it-calc
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-define SECOND-ENABLED-TABLE pl-it-calc
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.un item.pto-repos ~
pl-it-calc.char-2 
&Scoped-define DISPLAYED-TABLES item pl-it-calc
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-define SECOND-DISPLAYED-TABLE pl-it-calc
&Scoped-Define DISPLAYED-OBJECTS fi-cd-plano c-desc-plano c-cod-estabel ~
c-desc-estab c-descr cb-ref fi-quant-segur da-horiz-liber fi-saldo ~
da-horiz-fixo l-benef 

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
DEFINE VARIABLE cb-ref AS CHARACTER FORMAT "X(256)":U 
     LABEL "Referˆncia" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-estabel LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-plano AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 57.72 BY .88 NO-UNDO.

DEFINE VARIABLE da-horiz-fixo AS DATE FORMAT "99/99/9999":U 
     LABEL "Horiz Fixo:" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE da-horiz-liber AS DATE FORMAT "99/99/9999":U 
     LABEL "Horiz Liber:" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-calc-alter AS CHARACTER FORMAT "X(256)":U INITIAL "C lculo alterado" 
      VIEW-AS TEXT 
     SIZE 11.72 BY .67 NO-UNDO.

DEFINE VARIABLE fi-cd-plano AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Plano" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-quant-segur AS DECIMAL FORMAT "->>>,>>9.99" INITIAL 0 
     LABEL "Qtd Segur":R20 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Saldo":R12 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE l-benef AS LOGICAL FORMAT "Sim/NÆo":U INITIAL NO 
     LABEL "Beneficiamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.86 BY 1.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.72 BY 3.58.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.86 BY 1.42.

DEFINE VARIABLE tb-calc-alter AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 2.43 BY .67 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     fi-cd-plano AT ROW 1.42 COL 6.72 COLON-ALIGNED
     c-desc-plano AT ROW 1.42 COL 12 COLON-ALIGNED NO-LABEL
     c-cod-estabel AT ROW 1.42 COL 49 COLON-ALIGNED
          LABEL "Estabelecimento":R7
     c-desc-estab AT ROW 1.42 COL 56.43 COLON-ALIGNED NO-LABEL
     item.it-codigo AT ROW 2.92 COL 6.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-descr AT ROW 2.92 COL 23.43 COLON-ALIGNED NO-LABEL
     item.un AT ROW 2.92 COL 81.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     cb-ref AT ROW 4.42 COL 8.86 COLON-ALIGNED
     fi-quant-segur AT ROW 4.54 COL 43.14 COLON-ALIGNED
     da-horiz-liber AT ROW 4.54 COL 72 COLON-ALIGNED
     fi-saldo AT ROW 5.54 COL 8.86 COLON-ALIGNED
     item.pto-repos AT ROW 5.54 COL 43.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     da-horiz-fixo AT ROW 5.54 COL 72 COLON-ALIGNED
     l-benef AT ROW 6.54 COL 11.72 COLON-ALIGNED
     pl-it-calc.char-2 AT ROW 6.54 COL 72 COLON-ALIGNED HELP
          ""
          LABEL "Estabelec. Priori." FORMAT "x(03)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tb-calc-alter AT ROW 6.75 COL 45.29
     fi-calc-alter AT ROW 6.75 COL 46.14 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 2.67 COL 1.57
     RECT-3 AT ROW 4.17 COL 1.72
     RECT-4 AT ROW 1.13 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgmfg.pl-it-calc
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
         HEIGHT             = 6.75
         WIDTH              = 88.43.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-estabel IN FRAME F-Main
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-plano IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-ref IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pl-it-calc.char-2 IN FRAME F-Main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
ASSIGN 
       pl-it-calc.char-2:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN da-horiz-fixo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN da-horiz-liber IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-calc-alter IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       fi-calc-alter:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN fi-cd-plano IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-quant-segur IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN l-benef IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tb-calc-alter IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       tb-calc-alter:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN item.un IN FRAME F-Main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON F5 OF c-cod-estabel IN FRAME F-Main /* Estabelecimento */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=c-cod-estabel
                       &campozoom=cod-estabel
                       &campo2=c-desc-estab
                       &campozoom2=nome}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON LEAVE OF c-cod-estabel IN FRAME F-Main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=c-desc-estab
                    &where="estabelec.cod-estabel= input frame {&frame-name}
                            c-cod-estabel"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-estabel IN FRAME F-Main /* Estabelecimento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-ref
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-ref V-table-Win
ON VALUE-CHANGED OF cb-ref IN FRAME F-Main /* Referˆncia */
DO:
  assign c-cod-refer = input frame {&frame-name} cb-ref.
  run pi-calcula-saldo.
  RUN notify ('row-available, record-target':U).
  RUN new-state IN THIS-PROCEDURE ( INPUT "change-ref":U).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-plano
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano V-table-Win
ON F5 OF fi-cd-plano IN FRAME F-Main /* Plano */
DO:

   {include/zoomvar.i &prog-zoom="inzoom/z02in318.w"
                       &campo=fi-cd-plano
                       &campozoom=cd-plano
                       &campo2=c-desc-plano
                       &campozoom2=descricao}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano V-table-Win
ON LEAVE OF fi-cd-plano IN FRAME F-Main /* Plano */
DO:
  {include/leave.i &tabela=pl-prod
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-plano
                    &where="pl-prod.cd-plano= input frame {&frame-name}
                            fi-cd-plano"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-plano V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-plano IN FRAME F-Main /* Plano */
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
    RUN pi-carrega-combo.      
  &ENDIF 
  
  ASSIGN cb-ref:DELIMITER = "".
  
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
  {src/adm/template/row-list.i "pl-it-calc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pl-it-calc"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  for first pl-prod fields (cd-plano descricao) NO-LOCK where 
       pl-prod.cd-plano = i-cd-plano:
     assign fi-cd-plano:screen-value   in frame {&FRAME-NAME} = string(i-cd-plano)
            c-desc-plano:screen-value  in frame {&FRAME-NAME} = pl-prod.descricao.
  end.

  for first estabelec fields (cod-estabel nome) NO-LOCK where 
       estabelec.cod-estabel = c-estabel-plano:
     assign c-cod-estabel:screen-value in frame {&FRAME-NAME} = c-estabel-plano
            c-desc-estab:screen-value  in frame {&FRAME-NAME} = estabelec.nome.
  end.

  if avail pl-it-calc then
  for FIRST item fields (it-codigo desc-item un tipo-con-est 
                         compr-fabric quant-segur pto-repos) NO-LOCK WHERE 
       item.it-codigo = pl-it-calc.it-codigo:

      if  c-programa = "PL0713":U then do:
        if  avail item then
            assign i-horiz-liber = int(substr(item.char-1,129,3)) 
                   i-horiz-fixo  = item.horiz-fixo no-error.
        else 
            assign i-horiz-liber = 0
                   i-horiz-fixo  = 0.

        assign da-horiz-liber = today + i-horiz-liber
               da-horiz-fixo  = today + i-horiz-fixo.
    end.

     assign item.it-codigo:screen-value in frame {&frame-name} = pl-it-calc.it-codigo
            c-descr:screen-value        in frame {&FRAME-NAME} = item.desc-item
            item.un:screen-value        in frame {&FRAME-NAME} = item.un
            item.pto-repos:screen-value in frame {&FRAME-NAME} = string(item.pto-repos). 
   end.  

    /* Code placed here will execute AFTER standard behavior.    */

  if avail pl-it-calc then do:
     if substring(pl-it-calc.char-2,1,3) <> " " then
        assign pl-it-calc.char-2:hidden = no.
     else
        assign pl-it-calc.char-2:hidden = yes.

     &if defined(bf_man_mrp_override) &then
     assign tb-calc-alter:checked in frame {&frame-name} = pl-it-calc.calc-alter.
     &endif

  end.
  else
     &if defined(bf_man_mrp_override) &then
     assign tb-calc-alter:checked in frame {&frame-name} = no.
     &endif
  RUN pi-carrega-combo.
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

  {utp/ut-liter.i Sim/NÆo *}
  ASSIGN l-benef:FORMAT IN FRAME {&frame-name} = return-value.

  {utp/ut-field.i mgind item cod-refer 1}
  assign cb-ref:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgmfg pl-it-calc saldo 1}
  assign fi-saldo:label in frame {&frame-name} = return-value.

  {utp/ut-field.i mgmfg pl-it-calc quant-segur 1}
  assign fi-quant-segur:label in frame {&frame-name} = return-value.
  &if defined(bf_man_mrp_override) &then
  {utp/ut-field.i mgmfg pl-it-calc calc-alter 1}
  assign tb-calc-alter:hidden in frame {&frame-name} = no
         fi-calc-alter:hidden in frame {&frame-name} = no
         fi-calc-alter:screen-value in frame {&frame-name} = trim(return-value).
  &endif
  assign c-programa = "".
    do  i-cont = 1 to 5:
        if  index(program-name(i-cont),"pl0713") > 0 then do:
            assign c-programa = "pl0713":U.
            leave.
        end.
    end.
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
  /*Code placed here will execute AFTER standard behavior.*/

  if avail item THEN
      assign c-descr = item.desc-item
             c-descr:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ITEM.desc-item
             gr-item = rowid(item).
  else 
      ASSIGN c-descr = "".

  assign l-benef = no.

  for first b-rot-item fields (it-codigo cod-roteiro) where 
            b-rot-item.it-codigo = item.it-codigo no-lock:
      for each rot-item where 
               rot-item.it-codigo = item.it-codigo no-lock:
          find rot-fabric where 
               rot-fabric.cod-roteiro = rot-item.cod-roteiro AND 
               NOT (rot-fabric.situacao = 2 ) no-lock no-error.
          IF AVAIL rot-fabric AND 
             CAN-FIND (FIRST operacao where 
                             operacao.it-codigo     = "" and 
                             operacao.cod-roteiro   = rot-item.cod-roteiro and   
                             operacao.tipo   = 2) THEN DO:
             assign l-benef = yes.
             leave.
          end.
      end.
  end.
  if not avail rot-item then 
      FOR FIRST operacao fields (it-codigo cod-roteiro tipo)
          WHERE operacao.it-codigo = item.it-codigo and   
                operacao.cod-roteiro  = " " and   
                operacao.tipo   = 2  no-lock:
           assign l-benef = yes.
      end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-saldo V-table-Win 
PROCEDURE pi-calcula-saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


if avail item then do:
     IF pl-prod.log-multi-estabel OR item.tipo-con-est = 4 THEN DO:
         FIND first pl-ext-item where 
                    pl-ext-item.it-codigo = item.it-codigo AND 
                    pl-ext-item.cod-refer = c-cod-refer AND
                    pl-ext-item.num-calc-plano = pl-prod.num-calc-plano AND
                    pl-ext-item.cod-estabel = INPUT FRAME {&FRAME-NAME} c-cod-estabel  no-lock no-error.
         if avail pl-ext-item then 
            assign fi-saldo = pl-ext-item.qt-saldo.                           
        else 
           assign fi-saldo = 0.

     END.
     ELSE DO:
         for first  pl-it-calc fields (it-codigo cd-plano saldo) where 
                    pl-it-calc.it-codigo = item.it-codigo and
                    pl-it-calc.cd-plano = pl-prod.cd-plano no-lock :
            assign fi-saldo = pl-it-calc.saldo.
         end.
         if not avail pl-it-calc then
            assign fi-saldo = 0.
     END.  
     /*c lculo da quantidade de seguranca*/
     for FIRST item-uni-estab fields (it-codigo cod-estabel nr-linha quant-segur) WHERE 
                item-uni-estab.it-codigo = ITEM.it-codigo AND
                item-uni-estab.cod-estabel = INPUT FRAME {&FRAME-NAME} c-cod-estabel NO-LOCK:
        IF  AVAIL item-uni-estab then
            IF ITEM.compr-fabric = 1  THEN
               ASSIGN fi-quant-segur = item.quant-segur.
            ELSE 
                 IF CAN-FIND(FIRST lin-prod WHERE
                                   lin-prod.nr-linha = item-uni-estab.nr-linha AND
                                   lin-prod.cod-estabel = item-uni-estab.cod-estabel) THEN
                    ASSIGN fi-quant-segur = item-uni-estab.quant-segur.
                 ELSE
                    ASSIGN fi-quant-segur = 0.
        ELSE 
            ASSIGN fi-quant-segur = 0.
     end.
     IF NOT AVAIL item-uni-estab OR NOT pl-prod.log-multi-estabel THEN 
           ASSIGN fi-quant-segur = item.quant-segur.

END.

DISPLAY fi-saldo fi-quant-segur WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-combo V-table-Win 
PROCEDURE pi-carrega-combo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*populando o combo*/

  &IF "{&fnc_multi_idioma}" = "yes" &THEN
      ASSIGN cb-ref:LIST-ITEM-PAIRS in frame {&frame-name} = ? .
  &else
      ASSIGN cb-ref:list-items in frame {&frame-name} = ? .
  &endif

  if  available(item) AND item.tipo-con-est = 4 THEN DO:
      for  each ref-item fields (it-codigo cod-refer) where
                ref-item.it-codigo = item.it-codigo no-lock:
          &if "{&FNC_Multi_Idioma}" = "yes" &then
            cb-ref:add-last(ref-item.cod-refer,ref-item.cod-refer) in frame {&frame-name} .
          &else
            cb-ref:add-last(ref-item.cod-refer) in frame {&frame-name} .
          &endif
      end.
      for first ref-item fields (it-codigo cod-refer) where
                ref-item.it-codigo = item.it-codigo no-lock:
          assign cb-ref:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ref-item.cod-refer.
      end.
      enable cb-ref with frame {&frame-name}.
  end.
  ELSE
     &IF "{&FNC_MULTI_IDIOMA}" = "yes"  &THEN
      ASSIGN  cb-ref:LIST-ITEM-PAIRS in frame {&frame-name} = ?
              cb-ref:SENSITIVE IN frame {&frame-name} = NO.
      &else
      ASSIGN  cb-ref:list-items in frame {&frame-name} = ?
              cb-ref:SENSITIVE IN frame {&frame-name} = NO.
      &ENDIF
/*   disp cb-ref with frame {&frame-name}. */
  &IF "{&FNC_MULTI_IDIOMA}" = "yes"  &THEN
      assign c-cod-refer = IF NOT (cb-ref:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = ?)
                           THEN cb-ref:SCREEN-VALUE ELSE " ":U.  
  &else
      assign c-cod-refer = IF NOT (cb-ref:LIST-ITEMS IN FRAME {&FRAME-NAME} = ?)
                           THEN cb-ref:SCREEN-VALUE ELSE " ":U.
  &endif
  if avail item then
     APPLY 'value-changed' to cb-ref in frame {&frame-name}.
/*fim populando combo*/

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
  {src/adm/template/snd-list.i "pl-it-calc"}

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

