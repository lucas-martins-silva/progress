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
{include/i-prgvrs.i V03IN673 2.00.00.008}  /*** 010008 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in673 MUT}
&ENDIF

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

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var i-cod-fat-ponder as integer no-undo.
def var i-classif-abc    as integer no-undo.

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
&Scoped-define EXTERNAL-TABLES item-mat-estab
&Scoped-define FIRST-EXTERNAL-TABLE item-mat-estab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item-mat-estab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-mat-estab.cd-freq ~
item-mat-estab.cod-comprado item-mat-estab.cod-grp-compra ~
item-mat-estab.crit-cc item-mat-estab.altera-conta item-mat-estab.crit-ce ~
item-mat-estab.cod-fat-ponder item-mat-estab.consumo-prev ~
item-mat-estab.ponto-encomenda item-mat-estab.data-ult-ent ~
item-mat-estab.preco-ul-ent item-mat-estab.cod-estab-gestor 
&Scoped-define ENABLED-TABLES item-mat-estab
&Scoped-define FIRST-ENABLED-TABLE item-mat-estab
&Scoped-define DISPLAYED-TABLES item-mat-estab
&Scoped-define FIRST-DISPLAYED-TABLE item-mat-estab
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item-mat-estab.cd-freq ~
item-mat-estab.cod-comprado item-mat-estab.cod-grp-compra ~
item-mat-estab.crit-cc item-mat-estab.altera-conta item-mat-estab.crit-ce ~
item-mat-estab.cod-fat-ponder item-mat-estab.consumo-prev ~
item-mat-estab.ponto-encomenda item-mat-estab.data-ult-ent ~
item-mat-estab.preco-ul-ent item-mat-estab.cod-estab-gestor 
&Scoped-Define DISPLAYED-OBJECTS c-desc-freq c-desc-comprador ~
c-des-grp-compra c-desc-formula c-desc-gestor 

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
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-des-grp-compra AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-comprador AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-formula AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-freq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 48.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-gestor AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 50.72 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.29 BY 10.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-mat-estab.cd-freq AT ROW 1.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-freq AT ROW 1.38 COL 31.86 COLON-ALIGNED NO-LABEL
     item-mat-estab.cod-comprado AT ROW 2.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-desc-comprador AT ROW 2.38 COL 43.57 COLON-ALIGNED NO-LABEL
     item-mat-estab.cod-grp-compra AT ROW 3.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     c-des-grp-compra AT ROW 3.38 COL 43.57 COLON-ALIGNED NO-LABEL
     item-mat-estab.crit-cc AT ROW 4.38 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.29 BY .88
     item-mat-estab.altera-conta AT ROW 4.5 COL 44
          VIEW-AS TOGGLE-BOX
          SIZE 25.14 BY .83
     item-mat-estab.crit-ce AT ROW 5.38 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.29 BY .88
     item-mat-estab.cod-fat-ponder AT ROW 6.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-formula AT ROW 6.38 COL 31.72 COLON-ALIGNED NO-LABEL
     item-mat-estab.consumo-prev AT ROW 7.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     item-mat-estab.ponto-encomenda AT ROW 8.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24 BY .88
     item-mat-estab.data-ult-ent AT ROW 9.33 COL 68.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     item-mat-estab.preco-ul-ent AT ROW 9.38 COL 26.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.72 BY .88
     item-mat-estab.cod-estab-gestor AT ROW 10.38 COL 26.86 COLON-ALIGNED HELP
          "Estabelecimento Gestor"
          LABEL "Estabelecimento Gestor" FORMAT "X(3)"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-desc-gestor AT ROW 10.38 COL 32.29 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item-mat-estab
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
         HEIGHT             = 10.54
         WIDTH              = 87.31.
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

/* SETTINGS FOR FILL-IN c-des-grp-compra IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-comprador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-formula IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-freq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-gestor IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-mat-estab.cod-estab-gestor IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
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

&Scoped-define SELF-NAME item-mat-estab.cd-freq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cd-freq V-table-Win
ON F5 OF item-mat-estab.cd-freq IN FRAME f-main /* Frequˆncia Fornecimento */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad122.w
                     &campo=item-mat-estab.cd-freq
                     &campozoom=cd-freq}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cd-freq V-table-Win
ON LEAVE OF item-mat-estab.cd-freq IN FRAME f-main /* Frequˆncia Fornecimento */
DO:
  {include/leave.i &tabela=frequencia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-freq
                   &where="frequencia.cd-freq = input frame {&frame-name}
                           item-mat-estab.cd-freq"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cd-freq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.cd-freq IN FRAME f-main /* Frequˆncia Fornecimento */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.cod-comprado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-comprado V-table-Win
ON F5 OF item-mat-estab.cod-comprado IN FRAME f-main /* Comprador */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z01in055.w
                       &campo=item-mat-estab.cod-comprado
                       &campozoom=cod-comprado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-comprado V-table-Win
ON LEAVE OF item-mat-estab.cod-comprado IN FRAME f-main /* Comprador */
DO:
  {include/leave.i &tabela=comprador
                     &atributo-ref=nome
                     &variavel-ref=c-desc-comprador
                     &where="comprador.cod-comprado = input frame {&frame-name}
                             item-mat-estab.cod-comprado"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-comprado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.cod-comprado IN FRAME f-main /* Comprador */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.cod-estab-gestor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-estab-gestor V-table-Win
ON F5 OF item-mat-estab.cod-estab-gestor IN FRAME f-main /* Estabelecimento Gestor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=item-mat-estab.cod-estab-gestor
                       &campozoom=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-estab-gestor V-table-Win
ON LEAVE OF item-mat-estab.cod-estab-gestor IN FRAME f-main /* Estabelecimento Gestor */
DO:
{include/leave.i &tabela=estabelec
                 &atributo-ref=nome
                 &variavel-ref=c-desc-gestor
                 &where="estabelec.cod-estabel = input frame {&frame-name} 
                         item-mat-estab.cod-estab-gestor"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-estab-gestor V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.cod-estab-gestor IN FRAME f-main /* Estabelecimento Gestor */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=item-mat-estab.cod-estab-gestor
                       &campozoom=cod-estabel}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.cod-fat-ponder
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-fat-ponder V-table-Win
ON F5 OF item-mat-estab.cod-fat-ponder IN FRAME f-main /* F¢rmulas Pondera‡äes */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in659.w
                       &campo=item-mat-estab.cod-fat-ponder 
                       &campozoom=cod-fat-ponder}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-fat-ponder V-table-Win
ON LEAVE OF item-mat-estab.cod-fat-ponder IN FRAME f-main /* F¢rmulas Pondera‡äes */
DO:
  {include/leave.i &tabela=fat-ponder
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-formula
                     &where="fat-ponder.cod-fat-ponder = input frame {&frame-name}
                             item-mat-estab.cod-fat-ponder"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-fat-ponder V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.cod-fat-ponder IN FRAME f-main /* F¢rmulas Pondera‡äes */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.cod-grp-compra
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-grp-compra V-table-Win
ON F5 OF item-mat-estab.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in455.w
                       &campo=item-mat-estab.cod-grp-compra 
                       &campozoom=cod-grp-compra}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-grp-compra V-table-Win
ON LEAVE OF item-mat-estab.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  {include/leave.i &tabela=grupo-compra
                     &atributo-ref=des-grp-compra
                     &variavel-ref=c-des-grp-compra
                     &where="grupo-compra.cod-grp-compra = input frame {&frame-name}
                             item-mat-estab.cod-grp-compra"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.cod-grp-compra V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-mat-estab.cod-grp-compra IN FRAME f-main /* Grupo Compra */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.crit-cc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.crit-cc V-table-Win
ON LEAVE OF item-mat-estab.crit-cc IN FRAME f-main /* Criticidade Compra */
DO:
  if adm-new-record then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT THIS-PROCEDURE,
          INPUT "cb-classificacao-abc").
      assign i-classif-abc = {ininc/i01in598.i 06 return-value}.
      for first recalc-fat-ponder fields (classif-abc crit-cc crit-ce cod-fat-ponder) where
            recalc-fat-ponder.classif-abc = i-classif-abc and
            recalc-fat-ponder.crit-cc     = input frame {&frame-name} item-mat-estab.crit-cc and
            recalc-fat-ponder.crit-ce     = input frame {&frame-name} item-mat-estab.crit-ce no-lock: end.
      if avail recalc-fat-ponder then
           assign item-mat-estab.cod-fat-ponder:screen-value in frame {&frame-name} = string(recalc-fat-ponder.cod-fat-ponder).
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-mat-estab.crit-ce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-mat-estab.crit-ce V-table-Win
ON LEAVE OF item-mat-estab.crit-ce IN FRAME f-main /* Criticidade Estocagem */
DO:
  if adm-new-record then do:
      RUN Get-Field-Screen-Value IN adm-broker-hdl
         (INPUT THIS-PROCEDURE,
          INPUT "cb-classificacao-abc").
      assign i-classif-abc = {ininc/i01in598.i 06 return-value}.
      for first recalc-fat-ponder fields (classif-abc crit-cc crit-ce cod-fat-ponder) where
            recalc-fat-ponder.classif-abc = i-classif-abc and
            recalc-fat-ponder.crit-cc     = input frame {&frame-name} item-mat-estab.crit-cc and
            recalc-fat-ponder.crit-ce     = input frame {&frame-name} item-mat-estab.crit-ce no-lock: end.
      if avail recalc-fat-ponder then
           assign item-mat-estab.cod-fat-ponder:screen-value in frame {&frame-name} = string(recalc-fat-ponder.cod-fat-ponder).
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
  if item-mat-estab.cod-estab-gestor:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.         
  if item-mat-estab.cd-freq:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.       
  if item-mat-estab.cod-comprado:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if item-mat-estab.cod-grp-compra:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if item-mat-estab.cod-fat-ponder:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.       
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
  {src/adm/template/row-list.i "item-mat-estab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item-mat-estab"}

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
        return 'ADM-ERROR':U.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  if avail item-mat-estab then do with frame {&frame-name}:
      for first frequencia fields (cd-freq descricao) where
          frequencia.cd-freq = item-mat-estab.cd-freq no-lock: end.
      if avail frequencia then 
          assign c-desc-freq:screen-value  = frequencia.descricao.
      for first comprador fields (cod-comprado nome) where
          comprador.cod-comprado = item-mat-estab.cod-comprado no-lock: end.          
      if avail comprador then 
          assign c-desc-comprador:screen-value = comprador.nome.
      for first estabelec fields (cod-estabel nome) where
          estabelec.cod-estabel = item-mat-estab.cod-estab-gestor no-lock: end.          
      if avail estabelec then 
         assign c-desc-gestor:screen-value in frame {&frame-name} = estabelec.nome.
      /*for first fat-ponder fields (cod-fat-ponder nome) where
          fat-ponder.cod-fat-ponder = item-mat-estab.cod-fat-ponder no-lock: end.          
      if avail fat-ponder then 
          assign c-desc-formula:screen-value = fat-ponder.nome.*/
  end.
  else 
      assign c-desc-freq:screen-value in frame {&frame-name} = " "
             c-desc-comprador:screen-value in frame {&frame-name} = " "      
             c-desc-formula:screen-value in frame {&frame-name} = " ".

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
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if avail param-compra then do:
        if  param-compra.int-2 = 1 then
            assign item-mat-estab.cod-grp-compra:sensitive in frame {&frame-name} = yes.
        else
            assign item-mat-estab.cod-grp-compra:sensitive in frame {&frame-name} = no.
    end.

    if avail param-compra then do:
        if  substring(param-compra.char-2,97,3) = "YES" then
            assign item-mat-estab.cod-estab-gestor:sensitive in frame {&frame-name} = yes.
        else
            assign item-mat-estab.cod-estab-gestor:sensitive in frame {&frame-name} = no.
    end.

    assign item-mat-estab.cod-comprado:sensitive in frame {&frame-name}   = yes.

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
   find first param-compra no-lock no-error.

   {utp/ut-field.i mgind item-mat cod-fat-ponder 1}
   assign item-mat-estab.cod-fat-ponder:label in frame {&frame-name} = trim(return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Classifica‡Æo_Cont bil * R}
  assign item-mat-estab.altera-conta:label in frame {&frame-name} = return-value.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita V-table-Win 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter cb-tp-ressup as char no-undo.
if cb-tp-ressup <> {ininc/i01in598.i 04 3} then 
    assign item-mat-estab.cd-freq:screen-value in frame {&frame-name} = "0"
           c-desc-freq:screen-value              in frame {&frame-name} = " "
           item-mat-estab.cd-freq:sensitive    in frame {&frame-name} = no.
else 
    assign item-mat-estab.cd-freq:sensitive    in frame {&frame-name} = yes.


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

  if  avail param-compra and param-compra.int-2 <> 1 and
      not can-find (comprador where comprador.cod-comprado = 
      input frame {&frame-name} item-mat-estab.cod-comprado) then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind comprador 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to item-mat-estab.cod-comprado in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  not can-find (frequencia where
      frequencia.cd-freq = input frame {&frame-name} item-mat-estab.cd-freq) and
      item-mat-estab.cd-freq:sensitive in frame {&frame-name} then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm frequencia 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to item-mat-estab.cd-freq in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  not can-find (fat-ponder where
      fat-ponder.cod-fat-ponder = input frame {&frame-name} item-mat-estab.cod-fat-ponder) and
      input frame {&frame-name} item-mat-estab.cod-fat-ponder <> 0 then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind fat-ponder 1}
      run utp/ut-msgs.p (input "show":U, input 56, input return-value).
      apply "entry" to item-mat-estab.cod-fat-ponder in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  param-compra.int-2 = 1 and
      not can-find(grupo-compra where grupo-compra.cod-grp-compra = 
      input frame {&frame-name} item-mat-estab.cod-grp-compra) and 
      item-mat-estab.cod-grp-compra:sensitive in frame {&frame-name} then do:
      {include/i-vldprg.i}
      {utp/ut-liter.i Grupo_Compras * C}
      run utp/ut-msgs.p (input "show", input 47, input trim(return-value)).
      apply "entry" to item-mat-estab.cod-grp-compra.
      return "adm-error".
  end.

  find first param-compra no-lock no-error.
  if avail param-compra then do:
    if substring(param-compra.char-2,97,3) = "YES" then do:
       if  not can-find (estabelec where
           estabelec.cod-estabel = input frame {&frame-name} item-mat-estab.cod-estab-gestor) and
           item-mat-estab.cod-estab-gestor:sensitive in frame {&frame-name} then do:
           {include/i-vldprg.i}
           {utp/ut-liter.i Estabelecimento_Gestor * C}
           run utp/ut-msgs.p (input "show":U, input 56, input return-value).
           apply "entry" to item-mat-estab.cod-estab-gestor in frame {&frame-name}.
           return 'ADM-ERROR':U.
       end.
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
  {src/adm/template/snd-list.i "item-mat-estab"}

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

