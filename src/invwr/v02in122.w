&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V02IN122 2.00.00.018}  /*** 010018 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN122 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var l-implanta as logical init no.
def new global shared var gr-familia as rowid no-undo.

    /**  Melhorias
    **/
    {cdp/cdcfgmat.i}
    def var c-lista-prioridade   as char no-undo.
    def var c-replica-prioridade as char no-undo.
    def var c-replica-variacao   as char no-undo.
    def var i-prioridade         as inte no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.cod-comprado familia.contr-qualid ~
familia.lote-multipl familia.res-int-comp familia.res-for-comp ~
familia.res-cq-comp 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-comprado ~{&FP2}cod-comprado ~{&FP3}~
 ~{&FP1}lote-multipl ~{&FP2}lote-multipl ~{&FP3}~
 ~{&FP1}res-int-comp ~{&FP2}res-int-comp ~{&FP3}~
 ~{&FP1}res-for-comp ~{&FP2}res-for-comp ~{&FP3}~
 ~{&FP1}res-cq-comp ~{&FP2}res-cq-comp ~{&FP3}
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 rt-mold RECT-2 RECT-3 RECT-4 ~
RECT-5 RECT-6 
&Scoped-Define DISPLAYED-FIELDS familia.fm-codigo familia.descricao ~
familia.cod-comprado familia.contr-qualid familia.lote-multipl ~
familia.res-int-comp familia.demanda familia.res-for-comp ~
familia.res-cq-comp familia.tipo-lote-ec familia.periodo-fixo ~
familia.tempo-segur familia.emissao-ord familia.politica 
&Scoped-Define DISPLAYED-OBJECTS de-var-aprov fi-grupo-compras ~
c-des-grp-compra cb-prioridade 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS fi-grupo-compras 

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
DEFINE VARIABLE cb-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prior. Aprov." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 13.72 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-grp-compra AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE de-var-aprov AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Varia‡Æo Perm." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grupo-compras AS CHARACTER FORMAT "X(12)" 
     LABEL "Fill 1":R18 
     VIEW-AS FILL-IN 
     SIZE 16.29 BY .88 NO-UNDO.

DEFINE VARIABLE tg-label-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE tg-label-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE tg-label-3 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE tg-label-4 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.14 BY 1.75.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.14 BY 1.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.14 BY 1.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.14 BY 1.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.72 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 2.38.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 28.29 BY 2.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 47.14 BY 7.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.fm-codigo AT ROW 1.25 COL 11.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     familia.descricao AT ROW 1.25 COL 24.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.86 BY .88
     de-var-aprov AT ROW 1.25 COL 78.72 COLON-ALIGNED
     fi-grupo-compras AT ROW 2.25 COL 11.86 COLON-ALIGNED HELP
          "Grupo de Compras do Comprador"
     c-des-grp-compra AT ROW 2.25 COL 28.14 COLON-ALIGNED NO-LABEL
     cb-prioridade AT ROW 2.25 COL 73.14 COLON-ALIGNED
     familia.cod-comprado AT ROW 3.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     familia.contr-qualid AT ROW 4 COL 50.72
          VIEW-AS TOGGLE-BOX
          SIZE 21.14 BY .75
     familia.lote-multipl AT ROW 4.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.29 BY .88
     familia.res-int-comp AT ROW 5.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.demanda AT ROW 6.13 COL 49.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Dependente", 1,
"Independente", 2
          SIZE 31.72 BY .79
     familia.res-for-comp AT ROW 6.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.res-cq-comp AT ROW 7.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     familia.tipo-lote-ec AT ROW 8 COL 49.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Autom tica", 1,
"Manual", 2
          SIZE 25.72 BY .75
     familia.periodo-fixo AT ROW 8.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     familia.tempo-segur AT ROW 9.75 COL 22.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     familia.emissao-ord AT ROW 9.88 COL 49.86 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Autom tica", 1,
"Manual", 2
          SIZE 25.14 BY .75
     familia.politica AT ROW 11.63 COL 2.29 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Per¡odo Fixo", 1,
"Lote Econ“mico", 2,
"Ordem", 3,
"N¡vel Superior", 4,
"Configurado", 5
          SIZE 78.57 BY .88
     tg-label-1 AT ROW 5.38 COL 48.29 COLON-ALIGNED NO-LABEL
     tg-label-2 AT ROW 7.25 COL 48.29 COLON-ALIGNED NO-LABEL
     tg-label-3 AT ROW 9.13 COL 48.29 COLON-ALIGNED NO-LABEL
     tg-label-4 AT ROW 11 COL 2.72 NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-key-2 AT ROW 1 COL 61.43
     rt-mold AT ROW 3.5 COL 1
     RECT-2 AT ROW 3.5 COL 48.57
     RECT-3 AT ROW 5.63 COL 48.57
     RECT-4 AT ROW 7.5 COL 48.57
     RECT-5 AT ROW 9.38 COL 48.57
     RECT-6 AT ROW 11.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */

IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 11.79
         WIDTH              = 88.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-grp-compra IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-prioridade IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-prioridade:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-var-aprov IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-var-aprov:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET familia.demanda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN familia.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET familia.emissao-ord IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-grupo-compras IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN familia.fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN familia.periodo-fixo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET familia.politica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN familia.tempo-segur IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN tg-label-1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN tg-label-2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN tg-label-3 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN tg-label-4 IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
/* SETTINGS FOR RADIO-SET familia.tipo-lote-ec IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME familia.cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-comprado V-table-Win
ON F5 OF familia.cod-comprado IN FRAME f-main /* Comprador */
DO: 
     assign l-implanta = yes.
    {include/zoom.i &prog-zoom="inzoom/z01in055.w"
                    &tabela=familia
                    &atributo=cod-comprado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.cod-comprado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.cod-comprado IN FRAME f-main /* Comprador */
DO:
    apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-grupo-compras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-grupo-compras V-table-Win
ON F5 OF fi-grupo-compras IN FRAME f-main /* Fill 1 */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in455.w
                       &campo=fi-grupo-compras
                       &campozoom=cod-grp-compra}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-grupo-compras V-table-Win
ON LEAVE OF fi-grupo-compras IN FRAME f-main /* Fill 1 */
DO:
  {include/leave.i &tabela=grupo-compra
                   &atributo-ref=des-grp-compra
                   &variavel-ref=c-des-grp-compra
                   &where="grupo-compra.cod-grp-compra = input frame {&FRAME-NAME} fi-grupo-compras"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-grupo-compras V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-grupo-compras IN FRAME f-main /* Fill 1 */
DO:
    apply "F5" to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME familia.fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.fm-codigo V-table-Win
ON F5 OF familia.fm-codigo IN FRAME f-main /* Fam¡lia */
DO:
  {include/zoom.i &prog-zoom = "inzoom/z01in122.w"
                    &tabela    = familia
                    &atributo  = fm-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.fm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.fm-codigo IN FRAME f-main /* Fam¡lia */
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

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-rtlbl.i mgind familia demanda      tg-label-1}
  {utp/ut-rtlbl.i mgind familia tipo-lote-ec tg-label-2}
  {utp/ut-rtlbl.i mgind familia emissao-ord  tg-label-3}
  {utp/ut-rtlbl.i mgind familia politica     tg-label-4}

  If familia.cod-comprado:load-mouse-pointer("Image\lupa.cur") in frame {&frame-name} then .
  if fi-grupo-compras:load-mouse-pointer("Image\lupa.cur") in frame {&frame-name} then .

  {utp/ut-field.i mgind grupo-compra cod-grp-compra 1}
  assign fi-grupo-compras:label in frame {&frame-name} = trim(return-value).

  /**  Melhorias
  **/


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-rtlbl.i mgind familia Demanda    tg-label-1}
  {utp/ut-rtlbl.i mgind familia Ordens     tg-label-2}
  {utp/ut-rtlbl.i mgind familia LoteEcon   tg-label-3}
  {utp/ut-rtlbl.i mgind familia TipoEstSeg tg-label-4}

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade = entry(4,c-lista-prioridade).
        display cb-prioridade with frame {&frame-name}.
    &endif

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

    if fi-grupo-compras:SENSITIVE in frame {&FRAME-NAME} then do:
        find grupo-compra where 
             grupo-compra.cod-grp-compra = input frame {&FRAME-NAME} fi-grupo-compras no-lock no-error.
        if not avail grupo-compra then do:
           {utp/ut-liter.i compras *}
           run utp/ut-msgs.p (input "show", 
                              input 15262, 
                              input  Return-value ).
           apply "entry" to fi-grupo-compras in frame {&FRAME-NAME}.
           return "adm-error".  
        end. 
    end.

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign input frame {&frame-name} cb-prioridade
               input frame {&frame-name} de-var-aprov.
    &endif

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.
    &if "{&mgind_dbtype}" = "progress" &then
    assign substring(familia.char-2,188,12,"character") = input frame {&FRAME-NAME} fi-grupo-compras.
    &else
    assign substring(familia.char-2,88,12,"character") = input frame {&FRAME-NAME} fi-grupo-compras.
    &endif

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find familia-mat where
            familia-mat.fm-codigo = familia.fm-codigo
            exclusive-lock no-error.
        if available familia-mat then do:
            assign familia-mat.variacao-perm = de-var-aprov.
            case lookup(cb-prioridade,replace(c-lista-prioridade," ,",",")):
                when 1 then assign familia-mat.prioridade-aprov = 999.
                when 2 then assign familia-mat.prioridade-aprov = 750.
                when 3 then assign familia-mat.prioridade-aprov = 450.
                when 4 then assign familia-mat.prioridade-aprov = 150.
            end case.
            assign i-prioridade = familia-mat.prioridade-aprov.
        end.
        release familia-mat.
        run utp/ut-msgs.p(input "show",
                          input 17808,
                          input "").
        assign c-replica-prioridade = return-value.                          
        run utp/ut-msgs.p(input "show",
                          input 17809,
                          input "").
        assign c-replica-variacao = return-value.                          
        if c-replica-prioridade <> "no" or
            c-replica-variacao  <> "no" then do:
            for each item where
                item.fm-codigo = familia.fm-codigo no-lock:
                find item-mat where
                    item-mat.it-codigo = item.it-codigo
                    exclusive-lock no-error.
                if available item-mat then do:
                    if c-replica-prioridade <> "no" then
                        assign item-mat.prioridade-aprov = i-prioridade.
                    if c-replica-variacao <> "no" then
                        assign item-mat.variacao-perm = de-var-aprov.
                end.
                release item-mat.
            end.
        end.
    &endif

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

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:sensitive in frame {&frame-name} = no
             de-var-aprov:sensitive  in frame {&frame-name} = no.
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

    Do with frame {&frame-name}:
        if available familia then do:
            &if "{&mgind_dbtype}" = "progress" &then
            assign fi-grupo-compras= substr(familia.char-2,188,12).
            &else
            assign fi-grupo-compras= substr(familia.char-2,88,12).
            &endif
            find grupo-compra where 
                grupo-compra.cod-grp-compra = fi-grupo-compras 
                no-lock no-error.
            assign c-des-grp-compra = if avail grupo-compra then grupo-compra.des-grp-compra else "":U.
        end.
    end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find familia-mat where
            familia-mat.fm-codigo = familia.fm-codigo
            no-lock no-error.
        if available familia-mat then do:
            display familia-mat.variacao-perm @ de-var-aprov with frame {&frame-name}.
            if  familia-mat.prioridade-aprov >= 0 and
                familia-mat.prioridade-aprov <= 300 then
                assign cb-prioridade = entry(4,c-lista-prioridade).
            if  familia-mat.prioridade-aprov >  300 and
                familia-mat.prioridade-aprov <= 600 then
                assign cb-prioridade = entry(3,c-lista-prioridade).
            if  familia-mat.prioridade-aprov >  600 and
                familia-mat.prioridade-aprov <  999 then
                assign cb-prioridade = entry(2,c-lista-prioridade).
            if  familia-mat.prioridade-aprov =  999 then
                assign cb-prioridade = entry(1,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
        end.
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
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  find first param-compra no-lock no-error.
  if not avail param-compra then
     disable fi-grupo-compras with frame {&frame-name}. 
  else do:
     if param-compra.int-2 = 1
     then
         enable fi-grupo-compras with frame {&frame-name}. 
     else
         disable fi-grupo-compras with frame {&frame-name}. 
  end.

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      if adm-new-record then do:
          assign cb-prioridade = entry(4,c-lista-prioridade).
          display cb-prioridade with frame {&frame-name}.
      end.
      assign cb-prioridade:sensitive in frame {&frame-name} = yes
             de-var-aprov:sensitive  in frame {&frame-name} = yes.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

&if defined(bf_mat_aprova_eletronica) &then
      {utp/ut-liter.i Varia‡Æo_Perm. * r}
      assign de-var-aprov:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Prior._Aprov. * r}
      assign cb-prioridade:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Muito_Alta * r}
      assign c-lista-prioridade = trim(return-value).
      {utp/ut-liter.i Alta * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i M‚dia * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i Baixa * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      assign cb-prioridade:list-items in frame {&frame-name} = c-lista-prioridade.
&endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  {utp/ut-rtlbl.i mgind familia demanda      tg-label-1}
  {utp/ut-rtlbl.i mgind familia tipo-lote-ec tg-label-2}
  {utp/ut-rtlbl.i mgind familia emissao-ord  tg-label-3}
  {utp/ut-rtlbl.i mgind familia politica     tg-label-4}

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:hidden in frame {&frame-name} = no
             de-var-aprov:hidden  in frame {&frame-name} = no.
  &endif

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

  if  avail familia then
      assign gr-familia = rowid(familia).  


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

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "familia"}

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


