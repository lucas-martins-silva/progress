&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i V06AD205 2.00.00.021 } /*** "010021" 25/06/2025 16:21:13 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06AD205 MUT}
&ENDIF

{include/i_fncrowid.i}

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
def new global shared var v-row-parent            as rowid no-undo.                                

def new global shared var v_rec_catal_img AS &IF "{&ROWID_READY}" = "YES" &THEN ROWID &ELSE RECID &ENDIF no-undo.
def new global shared var v_rec_catal_video AS &IF "{&ROWID_READY}" = "YES" &THEN ROWID &ELSE RECID &ENDIF no-undo.
def new global shared var v_rec_catal_docto_anexo AS &IF "{&ROWID_READY}" = "YES" &THEN ROWID &ELSE RECID &ENDIF no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-texto as char no-undo.
DEF VAR cLista  AS CHAR NO-UNDO.

{cdp/cdcfgman.i}
{include/i_fnctrad.i}

DEF VAR l-funcao-spp-int-req-om AS LOG NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES param-global
&Scoped-define FIRST-EXTERNAL-TABLE param-global


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-global.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-global.consiste-sim ~
param-global.gera-narrat param-global.gera-texto param-global.tipo-texto ~
param-global.cod-catal-img-it param-global.cod-catal-video-op ~
param-global.cod-catal-docto-anexo param-global.cod-catal-img-eq 
&Scoped-define ENABLED-TABLES param-global
&Scoped-define FIRST-ENABLED-TABLE param-global
&Scoped-Define ENABLED-OBJECTS cbAvisaRec tgReqOM fiOM RECT-5 RECT-6 RECT-7 ~
RECT-8 RECT-9 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-global.consiste-sim ~
param-global.gera-narrat param-global.gera-texto param-global.tipo-texto ~
param-global.cod-catal-img-it param-global.cod-catal-video-op ~
param-global.cod-catal-docto-anexo param-global.cod-catal-img-eq 
&Scoped-define DISPLAYED-TABLES param-global
&Scoped-define FIRST-DISPLAYED-TABLE param-global
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-des-cat-imag c-des-cat-video ~
c-des-cat-docto c-des-cat-img-eq cbAvisaRec tgReqOM fiOM 

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
DEFINE VARIABLE cbAvisaRec AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE c-des-cat-docto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cat-imag AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cat-img-eq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-cat-video AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fiOM AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 22 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.5.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 1.5.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 2.5.

DEFINE VARIABLE tgReqOM AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-global.consiste-sim AT ROW 1.25 COL 26
          VIEW-AS TOGGLE-BOX
          SIZE 32 BY .83
     param-global.gera-narrat AT ROW 2.25 COL 26
          VIEW-AS TOGGLE-BOX
          SIZE 35 BY .83
     param-global.gera-texto AT ROW 3.75 COL 26
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .83
     param-global.tipo-texto AT ROW 4.75 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.14 BY .88
     c-descricao AT ROW 4.75 COL 37 COLON-ALIGNED NO-LABEL
     param-global.cod-catal-img-it AT ROW 6.5 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-cat-imag AT ROW 6.5 COL 41 COLON-ALIGNED NO-LABEL
     param-global.cod-catal-video-op AT ROW 8.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-cat-video AT ROW 8.25 COL 41 COLON-ALIGNED NO-LABEL
     param-global.cod-catal-docto-anexo AT ROW 10 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-cat-docto AT ROW 10 COL 41 COLON-ALIGNED NO-LABEL
     param-global.cod-catal-img-eq AT ROW 11.75 COL 33 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-cat-img-eq AT ROW 11.75 COL 46 COLON-ALIGNED NO-LABEL
     cbAvisaRec AT ROW 13.54 COL 60 COLON-ALIGNED
     tgReqOM AT ROW 13.75 COL 9
     fiOM AT ROW 13 COL 2 COLON-ALIGNED NO-LABEL
     RECT-5 AT ROW 6.25 COL 1
     RECT-6 AT ROW 9.75 COL 1
     RECT-7 AT ROW 8 COL 1
     RECT-8 AT ROW 11.5 COL 1
     RECT-9 AT ROW 13.25 COL 1
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mguni.param-global
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
         HEIGHT             = 13.75
         WIDTH              = 83.14.
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

/* SETTINGS FOR FILL-IN c-des-cat-docto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cat-imag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cat-img-eq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-cat-video IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
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

&Scoped-define SELF-NAME param-global.cod-catal-docto-anexo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-docto-anexo V-table-Win
ON F5 OF param-global.cod-catal-docto-anexo IN FRAME f-main /* Cat†logo Documento */
DO:
  RUN btb/btb003ka.p.                     
  IF  v_rec_catal_docto_anexo <> ? then do:
      FIND catal_docto_anexo WHERE &IF {&ROWID_READY} = YES &THEN
                                        ROWID(catal_docto_anexo) = v_rec_catal_docto_anexo 
                                   &ELSE
                                        RECID(catal_docto_anexo) = v_rec_catal_docto_anexo 
                                   &ENDIF 
                                   NO-LOCK NO-ERROR.
      DISP catal_docto_anexo.cod_catal_docto_anexo @ param-global.cod-catal-docto-anexo
           WITH FRAME {&frame-name}.
  END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-docto-anexo V-table-Win
ON LEAVE OF param-global.cod-catal-docto-anexo IN FRAME f-main /* Cat†logo Documento */
DO:
  {include/leave.i &tabela=catal_docto_anexo    
                   &atributo-ref=des_catal_docto_anexo
                   &variavel-ref=c-des-cat-docto
                   &where="catal_docto_anexo.cod_catal_docto_anexo = INPUT FRAME {&frame-name}
                           param-global.cod-catal-docto-anexo"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-docto-anexo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.cod-catal-docto-anexo IN FRAME f-main /* Cat†logo Documento */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.cod-catal-img-eq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-eq V-table-Win
ON F5 OF param-global.cod-catal-img-eq IN FRAME f-main /* Cat†logo Imagens Equipamento */
DO:
    RUN btb/btb103ka.p.
    IF  v_rec_catal_img <> ? then do:
        FIND catal_img WHERE &IF {&ROWID_READY} = YES &THEN
                                  ROWID(catal_img) = v_rec_catal_img
                             &ELSE
                                  RECID(catal_img) = v_rec_catal_img
                             &ENDIF
                             NO-LOCK NO-ERROR.
        DISP catal_img.cod_catal_img @ param-global.cod-catal-img-eq WITH FRAME {&frame-name}.
    END. /* if v_rec_catal_img ... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-eq V-table-Win
ON LEAVE OF param-global.cod-catal-img-eq IN FRAME f-main /* Cat†logo Imagens Equipamento */
DO:
  {include/leave.i &tabela=catal_img
                   &atributo-ref=des_catal_img
                   &variavel-ref=c-des-cat-img-eq
                   &where="catal_img.cod_catal_img = INPUT FRAME {&frame-name} param-global.cod-catal-img-eq"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-eq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.cod-catal-img-eq IN FRAME f-main /* Cat†logo Imagens Equipamento */
DO:
    APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.cod-catal-img-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-it V-table-Win
ON F5 OF param-global.cod-catal-img-it IN FRAME f-main /* Cat†logo Imagens Item */
DO:
    RUN btb/btb103ka.p.
    IF  v_rec_catal_img <> ? then do:
        FIND catal_img WHERE &IF {&ROWID_READY} = YES &THEN
                                  ROWID(catal_img) = v_rec_catal_img
                             &ELSE
                                  RECID(catal_img) = v_rec_catal_img
                             &ENDIF
                             NO-LOCK NO-ERROR.
        DISP catal_img.cod_catal_img @ param-global.cod-catal-img-it WITH FRAME {&frame-name}.
    END. /* if v_rec_catal_img ... */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-it V-table-Win
ON LEAVE OF param-global.cod-catal-img-it IN FRAME f-main /* Cat†logo Imagens Item */
DO:
  {include/leave.i &tabela=catal_img    
                   &atributo-ref=des_catal_img
                   &variavel-ref=c-des-cat-imag
                   &where="catal_img.cod_catal_img = INPUT FRAME {&frame-name} param-global.cod-catal-img-it"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-img-it V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.cod-catal-img-it IN FRAME f-main /* Cat†logo Imagens Item */
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.cod-catal-video-op
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-video-op V-table-Win
ON F5 OF param-global.cod-catal-video-op IN FRAME f-main /* Cat†logo V°deo Operaá∆o */
DO:                     
  RUN btb/btb019ka.p.                     
  IF  v_rec_catal_video <> ? then do:
      FIND catal_video WHERE &IF {&ROWID_READY} = YES &THEN
                                  ROWID(catal_video) = v_rec_catal_video
                             &ELSE
                                  RECID(catal_video) = v_rec_catal_video
                             &ENDIF 
                             NO-LOCK NO-ERROR.
      DISP catal_video.cod_catal_video @ param-global.cod-catal-video-op WITH FRAME {&frame-name}.
  END. /* if v_rec_catal_video ... */                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-video-op V-table-Win
ON LEAVE OF param-global.cod-catal-video-op IN FRAME f-main /* Cat†logo V°deo Operaá∆o */
DO:
  {include/leave.i &tabela=catal_video    
                   &atributo-ref=des_catal_video
                   &variavel-ref=c-des-cat-video
                   &where="catal_video.cod_catal_video = INPUT FRAME {&frame-name} param-global.cod-catal-video-op"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.cod-catal-video-op V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.cod-catal-video-op IN FRAME f-main /* Cat†logo V°deo Operaá∆o */
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.gera-texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.gera-texto V-table-Win
ON VALUE-CHANGED OF param-global.gera-texto IN FRAME f-main /* Gera Texto Caracter°sticas */
DO:
  IF  INPUT FRAME {&frame-name} param-global.gera-texto = yes THEN DO:
      ASSIGN param-global.tipo-texto:HIDDEN IN FRAME {&frame-name} = no
             c-descricao:HIDDEN IN FRAME {&frame-name} = no.
      ENABLE param-global.tipo-texto WITH FRAME {&frame-name}.             
  END. /* if input frame ... */
  ELSE DO:
      ASSIGN param-global.tipo-texto:HIDDEN IN FRAME {&frame-name} = yes
             c-descricao:HIDDEN IN FRAME {&frame-name} = yes.
      DISABLE param-global.tipo-texto WITH FRAME {&frame-name}.             
  END. /* else do */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rt-key
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rt-key V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rt-key IN FRAME f-main
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.tipo-texto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.tipo-texto V-table-Win
ON F5 OF param-global.tipo-texto IN FRAME f-main /* Tipo Texto Caracter°sticas */
DO:
  ASSIGN l-implanta = yes.
  {include/zoomvar.i &prog-zoom = "inzoom/z01in437.w"
                     &campo=param-global.tipo-texto
                     &campozoom=tipo
                     &campo2=c-descricao
                     &campozoom2=descricao}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.tipo-texto V-table-Win
ON LEAVE OF param-global.tipo-texto IN FRAME f-main /* Tipo Texto Caracter°sticas */
DO:
  {include/leave.i &tabela=tipo-texto
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao
                   &where="tipo-texto.tipo = INPUT FRAME {&frame-name} param-global.tipo-texto"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.tipo-texto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-global.tipo-texto IN FRAME f-main /* Tipo Texto Caracter°sticas */
DO:
  APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  IF param-global.tipo-texto:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.
  IF param-global.cod-catal-img-it:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.
  IF param-global.cod-catal-video-op:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.
  IF param-global.cod-catal-docto-anexo:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.
  IF param-global.cod-catal-img-eq:LOAD-MOUSE-POINTER("image\lupa.cur") IN FRAME {&frame-name} THEN.

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
  {src/adm/template/row-list.i "param-global"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-global"}

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
/*  {include/i-valid.i}*/
    /** Validaá‰es - N∆o deve ser gerada a narrativa de caracter°sticas tÇcnicas
                     por duplicado */

   /*Retirada consistància conforme FO 214033  */                  
  /*IF  INPUT FRAME {&frame-name} param-global.gera-narrat AND
 *       INPUT FRAME {&frame-name} param-global.gera-texto THEN DO:
 *       {utp/ut-table.i mguni param-global 1}
 *       RUN utp/ut-msgs.p (input "show",
 *                          input 898,
 *                          input return-value).
 *       RETURN "adm-error".                            
 *   END. */

  /** Deve existir um tipo de texto para armazenar as caracter°sticas tÇcnicas
        do item **/
  IF  INPUT FRAME {&frame-name} param-global.gera-texto AND
      INPUT FRAME {&frame-name} param-global.tipo-texto = "" THEN DO:
      /*{utp/ut-field.i mguni param-global tipo-texto 1}*/
      {utp/ut-liter.i Tipo_Texto_Caracteristicas * R}
      assign c-texto = trim(return-value).
      RUN utp/ut-msgs.p (input "show",
                         input 265,
                         input c-texto /*return-value*/ ).
      RETURN "adm-error".                           
  END. /* if input ... */                                 

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */


  /******************************************************************************
  ** L¢gica necess†ria para os campos da Integraá∆o de Requisiá∆o com OM
  ******************************************************************************/
  &IF defined(bf_man_204) &THEN

      if l-funcao-spp-int-req-om = YES then do:
         &IF defined(bf_man_206) &THEN

             assign param-global.log-req-autom-recebto = input frame {&frame-name} tgReqOM
                    param-global.idi-aviso-recebto     = cbAvisaRec:lookup(input frame {&frame-name} cbAvisaRec).
         &else 
             /** Obs: Utilizada a v°rgula para incluir mais um ENTRY, para corrigir l¢gica da finanáas (CD1608.p) **/
             assign substring(param-global.char-2,23,1) = if input frame {&frame-name} tgReqOM = yes then "y":U else "n":U
                    substring(param-global.char-2,24,1) = string(cbAvisaRec:lookup(input frame {&frame-name} cbAvisaRec)).
         &ENDIF
      end.
  &ENDIF


  /******************************************************************************/


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
    IF  AVAIL param-global THEN DO:
        FIND tipo-texto WHERE tipo-texto.tipo = param-global.tipo-texto NO-LOCK NO-ERROR.
        ASSIGN c-descricao = IF  AVAIL tipo-texto THEN tipo-texto.descricao ELSE "":U.

        IF  param-global.gera-texto = yes THEN DO:
            ASSIGN param-global.tipo-texto:HIDDEN IN FRAME {&frame-name} = no
                   c-descricao:HIDDEN IN FRAME {&frame-name} = no.
            ENABLE param-global.tipo-texto WITH FRAME {&frame-name}.                 
        END. /* if param-global ... */
        ELSE DO:
            ASSIGN param-global.tipo-texto:HIDDEN IN FRAME {&frame-name} = yes
                   c-descricao:HIDDEN IN FRAME {&frame-name} = yes.
            DISABLE param-global.tipo-texto WITH FRAME {&frame-name}.
        END. /* else do */
    END. /* if avail param-global ... */
    ELSE DO:
        ASSIGN param-global.tipo-texto:HIDDEN IN FRAME {&frame-name} = yes
               c-descricao:HIDDEN IN FRAME {&frame-name} = yes.
        DISABLE param-global.tipo-texto WITH FRAME {&frame-name}.             
    END. /* else do */

    IF  AVAIL param-global THEN DO:
        FIND catal_img WHERE catal_img.cod_catal_img = param-global.cod-catal-img-it NO-LOCK NO-ERROR.
        ASSIGN c-des-cat-imag = IF  AVAIL catal_img THEN catal_img.des_catal_img ELSE "":U.    

        FIND catal_video WHERE catal_video.cod_catal_video = param-global.cod-catal-video-op NO-LOCK NO-ERROR.
        ASSIGN c-des-cat-video = IF  AVAIL catal_video THEN catal_video.des_catal_video ELSE "":U.

        FIND catal_docto_anexo WHERE catal_docto_anexo.cod_catal_docto_anexo = 
             param-global.cod-catal-docto-anexo NO-LOCK NO-ERROR.
        ASSIGN c-des-cat-docto = IF  AVAIL catal_docto_anexo THEN catal_docto_anexo.des_catal_docto_anexo ELSE "":U.

        FIND catal_img WHERE catal_img.cod_catal_img = param-global.cod-catal-img-eq NO-LOCK NO-ERROR.
        ASSIGN c-des-cat-img-eq = IF  AVAIL catal_img THEN catal_img.des_catal_img ELSE "":U.    

    END.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).

  /******************************************************************************
  ** L¢gica necess†ria para os campos da Integraá∆o de Requisiá∆o com OM
  ******************************************************************************/
  ASSIGN tgReqOm   :HIDDEN in frame {&frame-name} = YES
         cbAvisaRec:HIDDEN in frame {&frame-name} = YES
         fiOM      :HIDDEN in frame {&frame-name} = YES
         rect-9    :HIDDEN in frame {&frame-name} = YES.
  /** Somente chama esta funá∆o para EMS 2.04 em diante **/



  &IF defined(bf_man_204) &THEN



    /** Valida se parÉmetros existem **/
    IF AVAIL param-global THEN DO:
        /** Valida se a funá∆o est† no sistema **/
        run piValidaFuncao.
        /** Se estiver, busca informaá‰es para tela **/
        if l-funcao-spp-int-req-om = YES THEN do with frame {&frame-name}:
           /** Popula o combo-box de Aviso e habilita campos em tela **/

            &if "{&FNC_MULTI_IDIOMA}" = "YES" &then
                assign cLista = {adinc/i06ad205.i 3}.
                run utp/ut-lstit.p (input-output cLista).
                assign cbAvisaRec:list-item-pairs = cLista.                
            &else
                assign cbAvisaRec:list-items = {adinc/i06ad205.i 3}.
            &endif                              

            assign tgReqOm   :HIDDEN     = NO
                   cbAvisaRec:HIDDEN     = NO
                   fiOM      :HIDDEN     = NO
                   rect-9    :HIDDEN     = NO.

           /** Labels dos campos **/
           {utp/ut-liter.i _Ordens_Manutená∆o_ * R}
           ASSIGN fiOm:SCREEN-VALUE = RETURN-VALUE.
           {utp/ut-liter.i Requisiá∆o_autom†tica_no_recebimento * R}
           ASSIGN tgReqOm:LABEL = RETURN-VALUE.
           {utp/ut-liter.i Avisa_Recebimento * R}
           ASSIGN cbAvisaRec:LABEL = RETURN-VALUE.
           /** Se for EMS 2.06, pega informaá‰es dos campos existentes **/

           &IF defined(bf_man_206) &THEN

              assign tgReqOM    = param-global.log-req-autom-recebto.

              IF param-global.idi-aviso-recebto = 0 THEN do:
                ASSIGN cbAvisaRec:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 
                entry((param-global.idi-aviso-recebto * 2) + 2, cbAvisaRec:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME},",").   
              END.
              ELSE
                  assign cbAvisaRec:screen-value = {adinc/i06ad205.i 04 INT(param-global.idi-aviso-recebto)}.



           &else                      
                        /*ABAIXO DE 206*/
               /** Verifica se existe a informaá∆o, sen∆o joga padr∆o inicial **/

               if substring(param-global.char-2,23,1) = "":U then
                  assign tgReqOM    = yes.
               else
                  assign tgReqOM    = if substring(param-global.char-2,23,1) = "y":U then yes else no.
               /** Verifica se existe a informaá∆o, sen∆o joga padr∆o inicial **/

               if substring(param-global.char-2,24,1) = "":U then
                  assign cbAvisaRec:screen-value = {adinc/i06ad205.i 04 1}.
               else
                  assign cbAvisaRec:screen-value = {adinc/i06ad205.i 04 int(substring(param-global.char-2,24,1))}.
           &ENDIF
           /** Mostra valores em tela **/
           display tgReqOM.
           DISPLAY cbAvisaRec.
        end.

    end.
  &ENDIF
  /******************************************************************************/

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estado-campo V-table-Win 
PROCEDURE pi-estado-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 DEF INPUT PARAMETER p-estado AS logical NO-UNDO.

 ASSIGN param-global.cod-catal-video-op:SENSITIVE IN FRAME {&frame-name} = p-estado.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaFuncao V-table-Win 
PROCEDURE piValidaFuncao :
/*------------------------------------------------------------------------------
  Purpose:     piValidaFuncao
  Parameters:  <none>
  Notes:       Valida se a funá∆o de integraá∆o entre requisiá∆o autom†tica e 
               OM est† implantada.
               OBS: Do EMS 2.05 em diante, sempre estar† habilitada.
------------------------------------------------------------------------------*/
  /*Valida Funcao l-funcao-spp-int-req-om ativa ou release 204*/
  ASSIGN l-funcao-spp-int-req-om = NO.

  &IF DEFINED(bf_man_204) &THEN
     &IF DEFINED(bf_man_205) &THEN
     ASSIGN l-funcao-spp-int-req-om = YES.
     &ELSE
     IF CAN-FIND(FIRST funcao
                 WHERE funcao.cd-funcao = "spp-int-req-om":U
                 AND   funcao.ativo = YES) THEN
        ASSIGN l-funcao-spp-int-req-om = YES.
     &ENDIF
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
  {src/adm/template/snd-list.i "param-global"}

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

