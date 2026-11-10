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
{include/i-prgvrs.i V05IN263 2.00.00.014} /*** "010014" 26/10/2023 17:31:44 ***/

{include/i_fncrowid.i}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN263 MUT}
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
def new global shared var gr-operacao  as rowid no-undo. 

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_video  as rowid no-undo.
&ELSE
    def new global shared var v_rec_video  as recid no-undo.
&ENDIF


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

define buffer b-operacao for operacao.

def var c-item           like item.it-codigo.
def var c-rot-fabric     like rot-fabric.cod-roteiro.

def var c-label-item      as char format "X(30)" no-undo.
def var c-label-operacao  as char format "X(30)" no-undo.
def var c-label-oper-exam as char format "X(30)" no-undo.
def var l-mod-CQ          as logical.
def var l-copia-oper-pad  as logical.

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
&Scoped-define EXTERNAL-TABLES operacao
&Scoped-define FIRST-EXTERNAL-TABLE operacao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR operacao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS operacao.data-inicio operacao.refugo-op ~
operacao.tipo-oper operacao.data-termino operacao.proporcao ~
operacao.gm-codigo operacao.pto-controle operacao.cd-mob-dir ~
operacao.nr-oper-pad operacao.emite-ficha operacao.contr-qualidade ~
operacao.fi-codigo operacao.cod-video 
&Scoped-define ENABLED-TABLES operacao
&Scoped-define FIRST-ENABLED-TABLE operacao
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-mold-3 rt-mold1 rt-mold2 rt-mold3 ~
rt-mold4 
&Scoped-Define DISPLAYED-FIELDS operacao.data-inicio operacao.refugo-op ~
operacao.tipo-oper operacao.data-termino operacao.proporcao ~
operacao.gm-codigo operacao.pto-controle operacao.cd-mob-dir ~
operacao.nr-oper-pad operacao.emite-ficha operacao.contr-qualidade ~
operacao.fi-codigo operacao.cod-video 
&Scoped-define DISPLAYED-TABLES operacao
&Scoped-define FIRST-DISPLAYED-TABLE operacao
&Scoped-Define DISPLAYED-OBJECTS c-grup-maquina-descricao ~
c-pto-controle-descricao c-descricao-mob-dir Fi-titulo-tipo 

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
DEFINE VARIABLE c-descricao-mob-dir AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-grup-maquina-descricao AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 45.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-pto-controle-descricao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE Fi-titulo-tipo AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 13.72 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.86 BY 3.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.29 BY 3.

DEFINE RECTANGLE rt-mold1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18.43 BY 2.25.

DEFINE RECTANGLE rt-mold2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32.86 BY 2.25.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.14 BY 2.25.

DEFINE RECTANGLE rt-mold4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     operacao.data-inicio AT ROW 1.29 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     operacao.refugo-op AT ROW 1.29 COL 73.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     operacao.tipo-oper AT ROW 1.63 COL 5.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Interna", 1,
"Externa", 2
          SIZE 13.43 BY 1.63
     operacao.data-termino AT ROW 2.29 COL 36 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     operacao.proporcao AT ROW 2.29 COL 73.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     operacao.gm-codigo AT ROW 3.63 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     c-grup-maquina-descricao AT ROW 3.63 COL 34.43 COLON-ALIGNED NO-LABEL
     operacao.pto-controle AT ROW 4.63 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-pto-controle-descricao AT ROW 4.63 COL 25.43 COLON-ALIGNED NO-LABEL
     operacao.cd-mob-dir AT ROW 5.63 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-descricao-mob-dir AT ROW 5.63 COL 30 COLON-ALIGNED NO-LABEL
     operacao.nr-oper-pad AT ROW 7 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     operacao.emite-ficha AT ROW 7 COL 52.57
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     operacao.contr-qualidade AT ROW 7.92 COL 52.57
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .75
     operacao.fi-codigo AT ROW 8 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     operacao.cod-video AT ROW 8.75 COL 52.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.14 BY .88
     Fi-titulo-tipo AT ROW 1 COL 2.72 NO-LABEL
     RECT-1 AT ROW 6.83 COL 1.14
     rt-mold-3 AT ROW 6.83 COL 43.43
     rt-mold1 AT ROW 1.08 COL 1
     rt-mold2 AT ROW 1.08 COL 20
     rt-mold3 AT ROW 1.08 COL 53.57
     rt-mold4 AT ROW 3.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.operacao
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
         HEIGHT             = 8.88
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao-mob-dir IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-maquina-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-pto-controle-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN Fi-titulo-tipo IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
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

&Scoped-define SELF-NAME operacao.cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cd-mob-dir V-table-Win
ON F5 OF operacao.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="inzoom/z01in566.w" 
                     &campo=operacao.cd-mob-dir
                     &campozoom=cd-mob-dir}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cd-mob-dir V-table-Win
ON LEAVE OF operacao.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  {include/leave.i &tabela=tab-mob-dir 
                   &atributo-ref=descricao 
                   &variavel-ref=c-descricao-mob-dir 
                   &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} operacao.cd-mob-dir"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.cd-mob-dir IN FRAME f-main /* C¢digo Mob Direta */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.cod-video
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cod-video V-table-Win
ON F5 OF operacao.cod-video IN FRAME f-main /* V¡deo */
DO:
{utp/ut-liter.i operacao *}
  run btb/btb020ka.p ( Return-value ).
    &IF {&ROWID_READY} = YES &THEN
        find video no-lock where rowid(video) = v_rec_video no-error.
    &ELSE
        find video no-lock where recid(video) = v_rec_video no-error.
    &ENDIF


  if  avail video then
      assign operacao.cod-video:screen-value = string(video.cod_video).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.cod-video V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.cod-video IN FRAME f-main /* V¡deo */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.gm-codigo V-table-Win
ON F5 OF operacao.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in144.w" 
                     &campo=operacao.gm-codigo
                     &campozoom=gm-codigo
                     &campo2=c-grup-maquina-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.gm-codigo V-table-Win
ON LEAVE OF operacao.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
  {include/leave.i &tabela=grup-maquina 
                   &atributo-ref=descricao 
                   &variavel-ref=c-grup-maquina-descricao 
                   &where="grup-maquina.gm-codigo = input frame {&frame-name} operacao.gm-codigo"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME operacao.pto-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.pto-controle V-table-Win
ON F5 OF operacao.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in364.w" 
                     &campo=operacao.pto-controle
                     &campozoom=codigo
                     &campo2=c-pto-controle-descricao
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.pto-controle V-table-Win
ON LEAVE OF operacao.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  {include/leave.i &tabela=pto-controle 
                   &atributo-ref=descricao
                   &variavel-ref=c-pto-controle-descricao 
                   &where="pto-controle.codigo = input frame {&frame-name} operacao.pto-controle"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL operacao.pto-controle V-table-Win
ON MOUSE-SELECT-DBLCLICK OF operacao.pto-controle IN FRAME f-main /* Ponto Controle */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
 /*** titulo do retangulo para o campo operacao.tipo-oper ***/
  {utp/ut-rtlbl.i mgind operacao tipo-oper fi-titulo-tipo} 

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
  {src/adm/template/row-list.i "operacao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "operacao"}

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

  if input frame {&frame-name} operacao.cod-video <> "" then do:
     find first param-global no-lock no-error.
     if not avail param-global then do:
        run utp/ut-msgs.p (input "show",
                           input  16 ,
                           input return-value).
        return 'ADM-ERROR':U.
     end.

     find video 
          where video.cod_video = operacao.cod-video 
          no-lock no-error.
     if avail video then do:
        if video.cod_catal_video <> param-global.cod-catal-video-op then do:
           run utp/ut-msgs.p (input "show":U,
                              input 6854,
                              input "":U).
           return 'ADM-ERROR':U.
        end.
     end.
     else do:
          run utp/ut-msgs.p (input "show":U,
                             input 3154,
                             input "").
          return 'ADM-ERROR':U.
     end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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

   /* Code placed here will execute AFTER standard behavior.    */
   if avail operacao then do with frame {&frame-name}:
      find grup-maquina where grup-maquina.gm-codigo = operacao.gm-codigo    no-lock no-error.
      find pto-controle where pto-controle.codigo    = operacao.pto-controle no-lock no-error.
      find tab-mob-dir where tab-mob-dir.cd-mob-dir  = operacao.cd-mob-dir   no-lock no-error.  

      assign c-grup-maquina-descricao:screen-value = if avail grup-maquina then grup-maquina.descricao else "":U
             c-pto-controle-descricao:screen-value = if avail pto-controle then pto-controle.descricao else "":U
             c-descricao-mob-dir:screen-value      = if avail tab-mob-dir  then tab-mob-dir.descricao  else "":U.       
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
  {src/adm/template/snd-list.i "operacao"}

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

