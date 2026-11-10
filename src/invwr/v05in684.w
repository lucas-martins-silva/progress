&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V05IN684 2.00.00.018 } /*** 010018 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in684 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var gr-deposito  as rowid no-undo.
def new global shared var gr-planejad  as rowid no-undo.
def new global shared var gr-lin-prod  as rowid no-undo.
def new global shared var gr-estabelec as rowid no-undo.

def temp-table tt-item-2 like item-uni-estab use-index codigo.

def new shared var c-it-codigo like item.it-codigo.

def var c-cod-estabel as char no-undo.
def var r-registro    as rowid.
def var i-ind-refugo  as integer init 1 no-undo.
def var v-row-parent  as rowid no-undo.
Def Var de-preco-fiscal Like item-uni-estab.preco-fiscal No-undo.
Define Buffer bf-item-uni-estab For item-uni-estab.

/*DEF VAR c-local       AS CHAR NO-UNDO.*/

{inbo/boin684.i1 item-uni-estab tt-item-2 "not avail"}

define temp-table tt-localizacao like localizacao.

DEF VAR i-fnc-pf AS LOGICAL NO-UNDO.

{cdp/cdcfgman.i}
DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES item-uni-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-uni-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-uni-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-uni-estab.deposito-pad ~
item-uni-estab.cod-localiz item-uni-estab.cd-planejado ~
item-uni-estab.nr-linha item-uni-estab.cap-est-fabr ~
item-uni-estab.preco-fiscal 
&Scoped-define ENABLED-TABLES item-uni-estab
&Scoped-define FIRST-ENABLED-TABLE item-uni-estab
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-2 c-liter-sfc 
&Scoped-Define DISPLAYED-FIELDS item-uni-estab.deposito-pad ~
item-uni-estab.cod-localiz item-uni-estab.cd-planejado ~
item-uni-estab.nr-linha item-uni-estab.cap-est-fabr ~
item-uni-estab.preco-fiscal 
&Scoped-define DISPLAYED-TABLES item-uni-estab
&Scoped-define FIRST-DISPLAYED-TABLE item-uni-estab
&Scoped-Define DISPLAYED-OBJECTS c-dep-pad c-desc-local c-cd-plan ~
c-nr-linha tg-consid-aloc-ativid fi-perc-overlap tg-log-programac-sfc ~
c-liter-sfc 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-uni-estab.deposito-pad ~
item-uni-estab.cod-localiz item-uni-estab.cd-planejado ~
item-uni-estab.nr-linha item-uni-estab.cap-est-fabr 
&Scoped-define ADM-MODIFY-FIELDS item-uni-estab.deposito-pad ~
item-uni-estab.cod-localiz item-uni-estab.cd-planejado ~
item-uni-estab.nr-linha item-uni-estab.cap-est-fabr 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cd-plan AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-dep-pad AS CHARACTER FORMAT "x(40)":U 
     VIEW-AS FILL-IN 
     SIZE 46.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 29.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-liter-sfc AS CHARACTER FORMAT "X(50)":U INITIAL "ChÆo de F brica" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-nr-linha AS CHARACTER FORMAT "x(30)":U 
     VIEW-AS FILL-IN 
     SIZE 48.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-perc-overlap AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Overlap" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 1.88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 6.

DEFINE VARIABLE tg-consid-aloc-ativid AS LOGICAL INITIAL yes 
     LABEL "Considera Aloca‡Æo de Atividades" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 TOOLTIP "Considera Item no processo de Aloca‡Æo de Atividades" NO-UNDO.

DEFINE VARIABLE tg-log-programac-sfc AS LOGICAL INITIAL yes 
     LABEL "Programa Aloca‡Æo de Atividades" 
     VIEW-AS TOGGLE-BOX
     SIZE 33.43 BY .54 TOOLTIP "Indica se programa Aloca‡Æo de Atividades do Item" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-uni-estab.deposito-pad AT ROW 1.17 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-dep-pad AT ROW 1.17 COL 36.86 COLON-ALIGNED NO-LABEL
     item-uni-estab.cod-localiz AT ROW 2.08 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     c-desc-local AT ROW 2.08 COL 53.72 COLON-ALIGNED NO-LABEL
     item-uni-estab.cd-planejado AT ROW 3.04 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-cd-plan AT ROW 3.04 COL 45.86 COLON-ALIGNED NO-LABEL
     item-uni-estab.nr-linha AT ROW 4 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-nr-linha AT ROW 4 COL 34.29 COLON-ALIGNED NO-LABEL
     item-uni-estab.cap-est-fabr AT ROW 4.96 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-uni-estab.preco-fiscal AT ROW 5.92 COL 29.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.57 BY .88
     tg-consid-aloc-ativid AT ROW 7.54 COL 14.72 HELP
          "Considera Item no processo de Aloca‡Æo de Atividades"
     fi-perc-overlap AT ROW 7.63 COL 59.29 COLON-ALIGNED
     tg-log-programac-sfc AT ROW 8.38 COL 14.72 HELP
          "Indica se programa Aloca‡Æo de Atividades do Item"
     c-liter-sfc AT ROW 7 COL 5 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
     RECT-2 AT ROW 7.17 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-uni-estab
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
         HEIGHT             = 8.25
         WIDTH              = 85.72.
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

/* SETTINGS FOR FILL-IN c-cd-plan IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dep-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nr-linha IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-uni-estab.cap-est-fabr IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.cd-planejado IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.cod-localiz IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN item-uni-estab.deposito-pad IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR FILL-IN fi-perc-overlap IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-uni-estab.nr-linha IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX tg-consid-aloc-ativid IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-log-programac-sfc IN FRAME f-main
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

&Scoped-define SELF-NAME item-uni-estab.cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cd-planejado V-table-Win
ON F5 OF item-uni-estab.cd-planejado IN FRAME f-main /* Planejador */
DO:
    assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in321.w"
                     &campo=item-uni-estab.cd-planejado
                     &campozoom=cd-planejado}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cd-planejado V-table-Win
ON LEAVE OF item-uni-estab.cd-planejado IN FRAME f-main /* Planejador */
DO:

       {include/leave.i &tabela=planejad
                     &atributo-ref=nome
                     &variavel-ref=c-cd-plan
                     &where="planejad.cd-planejado = input frame {&frame-name} item-uni-estab.cd-planejado"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-uni-estab.cd-planejado IN FRAME f-main /* Planejador */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cod-localiz V-table-Win
ON F5 OF item-uni-estab.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom\z01in189.w"
                       &campo=item-uni-estab.cod-localiz
                       &campozoom=cod-localiz}  


  /*  ASSIGN c-local = item-uni-estab.cod-localiz:SCREEN-VALUE IN FRAME {&FRAME-NAME}.                      */


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cod-localiz V-table-Win
ON LEAVE OF item-uni-estab.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
    DEF VAR loca AS CHAR NO-UNDO.

    FIND FIRST localizacao WHERE localizacao.cod-depos = item-uni-estab.deposito-pad:SCREEN-VALUE 
        AND localizacao.cod-estabel = item-uni-estab.cod-estabel
        AND localizacao.cod-localiz = item-uni-estab.cod-localiz:SCREEN-VALUE IN FRAME {&FRAME-NAME}
        NO-LOCK NO-ERROR.

    IF AVAIL localizacao THEN DO:
        ASSIGN loca = localizacao.descricao NO-ERROR.

        {include/leave.i &tabela=localizacao
                      &atributo-ref=descricao
                      &variavel-ref=c-desc-local
                      &where="localizacao.cod-localiz = input frame {&frame-name} item-uni-estab.cod-localiz"}        


            ASSIGN c-desc-local:SCREEN-VALUE = loca.

    END.
    ELSE DO:
           run utp/ut-msgs.p (input "show",
                               input 4898,
                               input return-value). 

           RETURN NO-APPLY.           
    END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-uni-estab.cod-localiz IN FRAME f-main /* Localiza‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.deposito-pad V-table-Win
ON F5 OF item-uni-estab.deposito-pad IN FRAME f-main /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom="inzoom\z01in084.w"
                     &campo=item-uni-estab.deposito-pad
                     &campozoom=cod-depos}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.deposito-pad V-table-Win
ON LEAVE OF item-uni-estab.deposito-pad IN FRAME f-main /* Dep¢sito */
DO:
    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-dep-pad
                     &where="deposito.cod-depos = input frame {&frame-name} item-uni-estab.deposito-pad"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.deposito-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-uni-estab.deposito-pad IN FRAME f-main /* Dep¢sito */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-uni-estab.nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.nr-linha V-table-Win
ON F5 OF item-uni-estab.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                       &campo=item-uni-estab.nr-linha
                       &campozoom=nr-linha}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.nr-linha V-table-Win
ON LEAVE OF item-uni-estab.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
    {include/leave.i &tabela=lin-prod
                     &atributo-ref=descricao
                     &variavel-ref=c-nr-linha
                     &where="lin-prod.cod-estabel = item-uni-estab.cod-estabel and 
                             lin-prod.nr-linha    = input frame {&frame-name} item-uni-estab.nr-linha"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-uni-estab.nr-linha V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-uni-estab.nr-linha IN FRAME f-main /* Linha Produ‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-consid-aloc-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-consid-aloc-ativid V-table-Win
ON VALUE-CHANGED OF tg-consid-aloc-ativid IN FRAME f-main /* Considera Aloca‡Æo de Atividades */
DO:
    IF tg-consid-aloc-ativid:CHECKED IN FRAME f-main = NO THEN
        ASSIGN tg-log-programac-sfc:CHECKED   IN FRAME f-main = NO 
               tg-log-programac-sfc:SENSITIVE IN FRAME f-main = NO.
    ELSE
        ASSIGN tg-log-programac-sfc:SENSITIVE IN FRAME f-main = YES.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    do  with frame {&frame-name}:
        IF item-uni-estab.deposito-pad:LOAD-MOUSE-POINTER ("image~\lupa.cur") THEN.
        IF item-uni-estab.cod-localiz:LOAD-MOUSE-POINTER  ("image~\lupa.cur") THEN.
        IF item-uni-estab.cd-planejado:LOAD-MOUSE-POINTER ("image~\lupa.cur") THEN.
        IF item-uni-estab.nr-linha:LOAD-MOUSE-POINTER     ("image~\lupa.cur") THEN.    
    end.

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
  {src/adm/template/row-list.i "item-uni-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-uni-estab"}

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
    If Not i-fnc-pf
    Then Do:
        Assign item-uni-estab.preco-fiscal = de-preco-fiscal .
    End.

    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /*OBS: O assign do campo tg-consid-aloc-ativid ocorre no local-assign-record do v02in684.w
           Inicialmente iria ser feito aqui, mas a viewer v02in684.w sobrepäe todas as informa‡äes gravadas no char-1.
           Assim, qualquer novo campo que seja colocado nessa viewer, que seja gravado no char-1, deve ser dado assign atrav‚s da v02in684*/

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
    
    IF l-mudancas-sfc THEN 
         ASSIGN tg-consid-aloc-ativid:SENSITIVE IN FRAME f-main = NO
                tg-log-programac-sfc:SENSITIVE IN FRAME f-main  = NO
                fi-perc-overlap:SENSITIVE       IN FRAME f-main = NO.

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

    DEF VAR local AS CHAR NO-UNDO.

    if  avail item-uni-estab then do:


    Find First bf-item-uni-estab Of item-uni-estab NO-LOCK NO-ERROR.
    ASSIGN de-preco-fiscal = item-uni-estab.preco-fiscal.

        find deposito
            where deposito.cod-depos = item-uni-estab.deposito-pad no-lock no-error.

        /*find tt-localizacao
            where tt-localizacao.cod-localiz = item-uni-estab.cod-localiz no-error.
        if not avail tt-localizacao then do:
            find localizacao
                where localizacao.cod-localiz = item-uni-estab.cod-localiz no-lock no-error.
            if avail localizacao then do:
                create tt-localizacao.
                buffer-copy localizacao to tt-localizacao.
            end.
        end.        
        */
        find planejad
            where planejad.cd-planejado = item-uni-estab.cd-planejado no-lock no-error.

        find first lin-prod
             where lin-prod.cod-estabel = item-uni-estab.cod-estabel
               and lin-prod.nr-linha    = item-uni-estab.nr-linha no-lock no-error.

        assign c-dep-pad    = if  avail deposito       then deposito.nome          else "":U
               c-cd-plan    = if  avail planejad       then planejad.nome          else "":U
               c-nr-linha   = if  avail lin-prod       then lin-prod.descricao     else "":U.
    end.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
    
    if  avail item-uni-estab then do:
        FIND FIRST localizacao WHERE localizacao.cod-depos = item-uni-estab.deposito-pad
                 AND localizacao.cod-estabel = item-uni-estab.cod-estabel
                 AND localizacao.cod-localiz = item-uni-estab.cod-localiz
                 NO-LOCK NO-ERROR.
        
        IF AVAIL localizacao THEN DO:
            ASSIGN local = localizacao.descricao NO-ERROR.
            ASSIGN c-desc-local:SCREEN-VALUE IN FRAME {&FRAME-NAME} = local.                   
        END.
    END.

    &IF DEFINED(bf_man_204) &THEN
        IF l-mudancas-sfc THEN DO:
            DISPLAY c-liter-sfc WITH FRAME f-main.
            ASSIGN tg-consid-aloc-ativid:CHECKED IN FRAME f-main = IF AVAIL item-uni-estab THEN  
                                                        &IF DEFINED(bf_man_207) &THEN
                                                             (item-uni-estab.log-consid-aloc-ativid)
                                                        &ELSE
                                                             (IF SUBSTRING(item-uni-estab.char-1,134,1) = "N":U THEN NO ELSE YES)
                                                        &ENDIF
                                                            ELSE NO
                   tg-log-programac-sfc:CHECKED IN FRAME f-main = IF AVAIL item-uni-estab THEN  
                                                        &IF DEFINED(bf_man_207) &THEN
                                                             (item-uni-estab.log-programac-sfc)
                                                        &ELSE
                                                             (IF SUBSTRING(item-uni-estab.char-1,140,1) = "N":U THEN NO ELSE YES)
                                                        &ENDIF
                                                            ELSE NO
                   fi-perc-overlap:SCREEN-VALUE IN FRAME f-main  = IF AVAIL item-uni-estab THEN
                                                        &IF DEFINED(bf_man_207) &THEN
                                                             STRING(item-uni-estab.val-overlap)
                                                        &ELSE
                                                             STRING(int(SUBSTRING(item-uni-estab.char-1,135,5)) / 100,"999,99":U)
                                                        &ENDIF
                                                             ELSE "0":U
                                                           .
        END.
        ELSE  
    &ENDIF
            ASSIGN rect-2:HIDDEN                IN FRAME f-main = YES
                   c-liter-sfc:HIDDEN           IN FRAME f-main = YES
                   tg-consid-aloc-ativid:HIDDEN IN FRAME f-main = YES
                   tg-log-programac-sfc:HIDDEN  IN FRAME f-main = YES
                   fi-perc-overlap:HIDDEN       IN FRAME f-main = YES.

   /* Code placed here will execute AFTER standard behavior.    */

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
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF l-mudancas-sfc THEN DO:
        ASSIGN tg-consid-aloc-ativid:SENSITIVE IN FRAME f-main = YES
               tg-log-programac-sfc:SENSITIVE  IN FRAME f-main = YES
               fi-perc-overlap:SENSITIVE       IN FRAME f-main = YES.
        APPLY "value-changed":U TO tg-consid-aloc-ativid IN FRAME f-main.
    END.


    find first tt-localizacao use-index codigo
        where tt-localizacao.cod-estabel = item-uni-estab.cod-estabel
          and tt-localizacao.cod-depos   = item-uni-estab.deposito-pad 
          and tt-localizacao.cod-localiz = item-uni-estab.cod-localiz no-lock no-error.
    if not avail tt-localizacao then do:
        find first localizacao use-index codigo
            where localizacao.cod-estabel = item-uni-estab.cod-estabel
              and localizacao.cod-depos   = item-uni-estab.deposito-pad 
              and localizacao.cod-localiz = item-uni-estab.cod-localiz no-lock no-error.
        if avail localizacao then do:
            create tt-localizacao.
            buffer-copy localizacao to tt-localizacao.
        end.
    end.

/*    if   param-global.modulo-ce
 *     and (available tt-localizacao
 *     or   item-uni-estab.cod-localiz = "") then 
 *         assign item-uni-estab.deposito-pad:sensitive in frame {&frame-name} = no
 *                item-uni-estab.cod-localiz:sensitive  in frame {&frame-name} = no. */

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
  ASSIGN i-fnc-pf = can-find (first funcao 
                              where funcao.cd-funcao = "spp-pr-fiscal-estab" 
                                and funcao.ativo     = yes). 

  &IF DEFINED(bf_man_204) &THEN
      RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    find first param-global no-lock no-error.

    ASSIGN item-uni-estab.preco-fiscal:VISIBLE IN FRAME {&FRAME-NAME} = i-fnc-pf.

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

  FIND deposito WHERE deposito.cod-depos = item-uni-estab.deposito-pad NO-LOCK NO-ERROR.
  IF  AVAIL deposito THEN
      ASSIGN gr-deposito = ROWID(deposito).

  FIND planejad WHERE planejad.cd-planejado = item-uni-estab.cd-planejado NO-LOCK NO-ERROR.    
  IF  AVAIL planejad THEN
      ASSIGN gr-planejad = ROWID(planejad).

  find first lin-prod
       where lin-prod.cod-estabel = item-uni-estab.cod-estabel
         and lin-prod.nr-linha    = item-uni-estab.nr-linha no-lock no-error.
  IF  AVAIL lin-prod THEN
      ASSIGN gr-lin-prod = ROWID(lin-prod).

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

  ASSIGN r-registro = ROWID(item). 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza V-table-Win 
PROCEDURE pi-atualiza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    &IF DEFINED(bf_man_sfc_lc) &THEN
        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT this-procedure,
             INPUT "cb-ind-refugo").

        assign i-ind-refugo = {ininc/i01in180.i 06 return-value}.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estab V-table-Win 
PROCEDURE pi-atualiza-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-estabel as char no-undo.

    find first estabelec
         where estabelec.cod-estabel = p-estabel no-lock no-error.
    if  avail estabelec then
        assign gr-estabelec = rowid(estabelec)
               c-cod-estabel = estabelec.cod-estabel.
    else
        assign c-cod-estabel = "".

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tipo-report V-table-Win 
PROCEDURE pi-tipo-report :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

RUN Get-Field-Screen-Value IN adm-broker-hdl
       (INPUT this-procedure,
        INPUT 'cb-report-prod').     /* Busca o valor do atributo na viewer v11in172*/
{include/i-lgcode.i}

&IF "{&LANGUAGE-CODE}" = "POR" &THEN
     case return-value:
          when 'Ordem'             then return '1'.
          when 'Opera‡Æo'          then return '2'.
          when 'Ponte de Controle' then return '3'.
          when 'Item'              then return '4'.
     end .
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ESP" &THEN
     case return-value:
          when 'Orden'              then return '1'.
          when 'Operaci¢n'          then return '2'.
          when 'Punto de Control'   then return '3'.
          when 'Item'               then return '4'.
     end .
&ENDIF
&IF "{&LANGUAGE-CODE}" = "ING" &THEN
     case return-value:
          when 'Req'             then return '1'.
          when 'Operation'       then return '2'.
          when 'Control Point'   then return '3'.
          when 'Item'            then return '4'.
     end .
&ENDIF

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

    if  input frame {&frame-name} item-uni-estab.deposito-pad <> "" then do:
        if  not can-find(deposito 
                   where deposito.cod-depos = input frame {&frame-name} item-uni-estab.deposito-pad) then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind deposito 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value). 
            apply "entry" to item-uni-estab.deposito-pad in frame {&frame-name}.
            return "adm-error". 
        end.
    end.   

    if  input frame {&frame-name} item-uni-estab.cd-planejad <> "" then do:
        if  not can-find(planejad 
            where planejad.cd-planejado = input frame {&frame-name} item-uni-estab.cd-planejad) then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind planejad 1}
            run utp/ut-msgs.p (input "show",
                               input 56,
                               input return-value). 
            apply "entry" to item-uni-estab.cd-planejad in frame {&frame-name}.
            return "adm-error".
        end.
    end.   

    if avail param-global and param-global.modulo-cp then do:  
        if  avail item-uni-estab then
            if  not can-find(lin-prod 
                       where lin-prod.cod-estabel = item-uni-estab.cod-estabel
                         and lin-prod.nr-linha    = input frame {&frame-name} item-uni-estab.nr-linha) then do:
                {include/i-vldprg.i}
                {utp/ut-table.i mgind lin-prod 1}
                run utp/ut-msgs.p (input "show",
                                   input 56,
                                   input return-value). 
                apply "entry" to item-uni-estab.nr-linha in frame {&frame-name}.
                return "adm-error".
            end.
    end. 

    if  input frame {&frame-name} item-uni-estab.cod-localiz  <> "" then do:
        find first tt-localizacao 
            where tt-localizacao.cod-depos    = input frame {&frame-name} item-uni-estab.deposito-pad 
              and tt-localizacao.cod-localiz  = input frame {&frame-name} item-uni-estab.cod-localiz
                          and tt-localizacao.cod-estabel  = item-uni-estab.cod-estabel
            no-error.

        if not avail tt-localizacao then do:
            find first localizacao 
                  where localizacao.cod-depos  = input frame {&frame-name} item-uni-estab.deposito-pad 
                  and localizacao.cod-localiz  = input frame {&frame-name} item-uni-estab.cod-localiz
                                  and localizacao.cod-estabel  = item-uni-estab.cod-estabel
                  no-lock no-error.
            if avail localizacao then do:
                create tt-localizacao.
                buffer-copy localizacao to tt-localizacao.
            end.
        end.    

        if  not available tt-localizacao then do:
            {include/i-vldprg.i} 
            {utp/ut-table.i mgind localizacao 1}
            run utp/ut-msgs.p (input "show",
                               input 4898,
                               input return-value). 
            apply "entry" to item-uni-estab.cod-localiz in frame {&frame-name}.
            return "adm-error".
        end.
    end.

    RUN pi-tipo-report.   /* verifica o tipo de reporte do item-uni-estab*/

    if  return-value = '4' then do:
        if  avail item-uni-estab then do:
            find first lin-prod
                 where lin-prod.cod-estabel = item-uni-estab.cod-estabel
                   and lin-prod.nr-linha    = input frame {&frame-name} item-uni-estab.nr-linha no-lock no-error.
            if  not avail lin-prod then do:
                {include/i-vldprg.i} 
                {utp/ut-table.i mgind lin-prod 1}
                run utp/ut-msgs.p (input "show",
                                   input 56,
                                   input return-value). 
                apply "entry" to item-uni-estab.nr-linha in frame {&frame-name}.
                return "adm-error".
            end.
            else 
                if  lin-prod.sum-requis <> 1 then do:
                    {include/i-vldprg.i} 
                    run utp/ut-msgs.p (input "show",
                                       input 17534,  /* item-uni-estab requer linha de processo*/
                                       input ''). 
                    apply "entry" to item-uni-estab.nr-linha in frame {&frame-name}.
                    return "adm-error".
                end.
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
  {src/adm/template/snd-list.i "item-uni-estab"}

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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

