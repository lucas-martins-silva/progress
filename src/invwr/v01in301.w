&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V01IN301 2.00.00.029 } /*** "010029" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v01in301 MUT}
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

&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgman.i} /* Miniflexibiliza‡Æo */
{cpp/cpapi023.i}
{cdp/cd0666.i}

Def new global Shared Var v-row-parent as rowid no-undo.

def new global shared var gr-ord-prod as rowid no-undo.
def new global shared var i-ordem     like oper-ord.nr-ord-prod no-undo.
def new global shared var c-it-codigo like oper-ord.it-codigo   no-undo.

def var r-anterior as rowid no-undo.
def var h-boin533     as handle no-undo.

{cdp/cd9043.i} /* Defini‡Æo da tabela de erros RowErros */
{cpp/cpapi301.i} /* Defini‡Æo da temp-table */
DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai_habilit AS LOGICAL NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES pert-ordem
&Scoped-define FIRST-EXTERNAL-TABLE pert-ordem


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR pert-ordem.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS pert-ordem.overlap pert-ordem.transporte 
&Scoped-define ENABLED-TABLES pert-ordem
&Scoped-define FIRST-ENABLED-TABLE pert-ordem
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS pert-ordem.it-codigo pert-ordem.cod-roteiro ~
pert-ordem.op-codigo pert-ordem.it-predec pert-ordem.rot-predec ~
pert-ordem.op-predec pert-ordem.overlap pert-ordem.transporte 
&Scoped-define DISPLAYED-TABLES pert-ordem
&Scoped-define FIRST-DISPLAYED-TABLE pert-ordem
&Scoped-Define DISPLAYED-OBJECTS fi-item-descricao fi-rot-fabric-descricao ~
fi-oper-descricao fi-item-pred-descricao fi-rot-pred-descricao ~
fi-oper-pred-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS pert-ordem.it-codigo ~
pert-ordem.cod-roteiro pert-ordem.op-codigo pert-ordem.it-predec ~
pert-ordem.rot-predec pert-ordem.op-predec 
&Scoped-define ADM-ASSIGN-FIELDS pert-ordem.it-codigo ~
pert-ordem.cod-roteiro pert-ordem.op-codigo pert-ordem.it-predec ~
pert-ordem.rot-predec pert-ordem.op-predec 

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
DEFINE VARIABLE fi-item-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE VARIABLE fi-item-pred-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE VARIABLE fi-oper-descricao AS CHARACTER FORMAT "x(34)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE VARIABLE fi-oper-pred-descricao AS CHARACTER FORMAT "x(34)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE VARIABLE fi-rot-fabric-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE VARIABLE fi-rot-pred-descricao AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87 BY 9.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     pert-ordem.it-codigo AT ROW 1.25 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-item-descricao AT ROW 1.25 COL 45 COLON-ALIGNED NO-LABEL
     pert-ordem.cod-roteiro AT ROW 2.33 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-rot-fabric-descricao AT ROW 2.33 COL 45 COLON-ALIGNED NO-LABEL
     pert-ordem.op-codigo AT ROW 3.42 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-oper-descricao AT ROW 3.42 COL 45 COLON-ALIGNED NO-LABEL
     pert-ordem.it-predec AT ROW 4.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-item-pred-descricao AT ROW 4.5 COL 45 COLON-ALIGNED NO-LABEL
     pert-ordem.rot-predec AT ROW 5.58 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-rot-pred-descricao AT ROW 5.58 COL 45 COLON-ALIGNED NO-LABEL
     pert-ordem.op-predec AT ROW 6.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     fi-oper-pred-descricao AT ROW 6.67 COL 45 COLON-ALIGNED NO-LABEL
     pert-ordem.overlap AT ROW 7.75 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     pert-ordem.transporte AT ROW 8.79 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 3.58 COL 44.86
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 2.54 COL 44.86
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 4.67 COL 44.86
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 6.75 COL 44.86
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 1.46 COL 44.86
     "-" VIEW-AS TEXT
          SIZE 2 BY .63 AT ROW 5.75 COL 44.86
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.pert-ordem
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
         HEIGHT             = 9.33
         WIDTH              = 87.43.
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

/* SETTINGS FOR FILL-IN pert-ordem.cod-roteiro IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-item-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-item-pred-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-oper-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-oper-pred-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-rot-fabric-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-rot-pred-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN pert-ordem.it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN pert-ordem.it-predec IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN pert-ordem.op-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN pert-ordem.op-predec IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN pert-ordem.rot-predec IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME pert-ordem.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.cod-roteiro V-table-Win
ON ENTRY OF pert-ordem.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  find rot-item where rot-item.it-codigo = input pert-ordem.it-predec 
                and   rot-item.cod-roteiro = input pert-ordem.rot-predec NO-LOCK no-error.
  if avail rot-item then do: find rot-fabric of rot-item NO-LOCK no-error.
                             if avail rot-fabric
                                then fi-rot-pred-descricao:screen-value = rot-fabric.descricao.
                         end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.cod-roteiro V-table-Win
ON F5 OF pert-ordem.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  find ord-prod where rowid(ord-prod) = gr-ord-prod no-lock no-error.                   
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = pert-ordem.op-codigo
                     &campozoom  = op-codigo
                     &campo2     = pert-ordem.cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = pert-ordem.it-codigo
                     &campozoom3 = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.cod-roteiro V-table-Win
ON LEAVE OF pert-ordem.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  find rot-item where rot-item.it-codigo = input pert-ordem.it-codigo 
                and   rot-item.cod-roteiro = input pert-ordem.cod-roteiro NO-LOCK no-error.
  if avail rot-item then do: find rot-fabric of rot-item NO-LOCK no-error.
                             if avail rot-fabric
                                then fi-rot-fabric-descricao:screen-value = rot-fabric.descricao.
                         end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pert-ordem.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pert-ordem.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-codigo V-table-Win
ON ENTRY OF pert-ordem.it-codigo IN FRAME f-main /* Item */
DO:
  find item where item.it-codigo = input frame {&frame-name} pert-ordem.it-codigo
       no-lock no-error.
  if avail item then do:
     assign fi-item-descricao = item.desc-item.
     if input frame {&frame-name} pert-ordem.it-codigo = "" then
        assign pert-ordem.it-codigo:screen-value = item.it-codigo.
  end.
  else
      assign fi-item-descricao = "".
  display fi-item-descricao with frame {&frame-name}.
  apply "leave" to pert-ordem.cod-roteiro.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-codigo V-table-Win
ON F5 OF pert-ordem.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=pert-ordem.it-codigo
                     &campozoom=it-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-codigo V-table-Win
ON LEAVE OF pert-ordem.it-codigo IN FRAME f-main /* Item */
DO:
  find item where item.it-codigo = input frame {&frame-name} pert-ordem.it-codigo
       no-lock no-error.
  if avail item then do:
     assign fi-item-descricao = item.desc-item.
     if input frame {&frame-name} pert-ordem.it-codigo = "" then
        assign pert-ordem.it-codigo:screen-value = item.it-codigo.
  end.
  else
      assign fi-item-descricao = "".
  display fi-item-descricao with frame {&frame-name}.
  apply "leave" to pert-ordem.cod-roteiro.                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pert-ordem.it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pert-ordem.it-predec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-predec V-table-Win
ON ENTRY OF pert-ordem.it-predec IN FRAME f-main /* Item Predecessor */
DO:
   find item where item.it-codigo = input frame {&frame-name} pert-ordem.it-predec
       no-lock no-error.
  if avail item then
     assign fi-item-pred-descricao = item.desc-item.
  else
      assign fi-item-pred-descricao = "".
  display fi-item-pred-descricao with frame {&frame-name}.
  apply "leave" to pert-ordem.rot-pred.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-predec V-table-Win
ON F5 OF pert-ordem.it-predec IN FRAME f-main /* Item Predecessor */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                     &campo=pert-ordem.it-pred
                     &campozoom=it-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-predec V-table-Win
ON LEAVE OF pert-ordem.it-predec IN FRAME f-main /* Item Predecessor */
DO:
  find item where item.it-codigo = input frame {&frame-name} pert-ordem.it-predec
       no-lock no-error.
  if avail item then
     assign fi-item-pred-descricao = item.desc-item.
  else
      assign fi-item-pred-descricao = "".
  display fi-item-pred-descricao with frame {&frame-name}.
  apply "leave" to pert-ordem.rot-pred.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.it-predec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pert-ordem.it-predec IN FRAME f-main /* Item Predecessor */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pert-ordem.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-codigo V-table-Win
ON ENTRY OF pert-ordem.op-codigo IN FRAME f-main /* Operacao */
DO:
  {include/leave.i &tabela=oper-ord
                   &atributo-ref=descricao
                   &variavel-ref=fi-oper-descricao
                   &where="oper-ord.op-codigo    = input frame {&frame-name} pert-ordem.op-codigo
                     and   oper-ord.it-codigo    = input frame {&frame-name} pert-ordem.it-codigo
                     and   oper-ord.cod-roteiro  = input frame {&frame-name} pert-ordem.cod-roteiro
                     and   oper-ord.nr-ord-produ = ord-prod.nr-ord-produ"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-codigo V-table-Win
ON F5 OF pert-ordem.op-codigo IN FRAME f-main /* Operacao */
DO:
  find ord-prod where rowid(ord-prod) = gr-ord-prod no-lock no-error.                   
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = pert-ordem.op-codigo
                     &campozoom  = op-codigo
                     &campo2     = pert-ordem.cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = pert-ordem.it-codigo
                     &campozoom3 = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-codigo V-table-Win
ON LEAVE OF pert-ordem.op-codigo IN FRAME f-main /* Operacao */
DO:
  {include/leave.i &tabela=oper-ord
                   &atributo-ref=descricao
                   &variavel-ref=fi-oper-descricao
                   &where="oper-ord.op-codigo    = input frame {&frame-name} pert-ordem.op-codigo
                     and   oper-ord.it-codigo    = input frame {&frame-name} pert-ordem.it-codigo
                     and   oper-ord.cod-roteiro  = input frame {&frame-name} pert-ordem.cod-roteiro
                     and   oper-ord.nr-ord-produ = ord-prod.nr-ord-produ"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pert-ordem.op-codigo IN FRAME f-main /* Operacao */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pert-ordem.op-predec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-predec V-table-Win
ON ENTRY OF pert-ordem.op-predec IN FRAME f-main /* Opera‡Æo Predecessora */
DO:
  {include/leave.i &tabela=oper-ord
                   &atributo-ref=descricao
                   &variavel-ref=fi-oper-pred-descricao
                   &where="oper-ord.op-codigo    = input frame {&frame-name} pert-ordem.op-predec
                     and   oper-ord.it-codigo    = input frame {&frame-name} pert-ordem.it-predec
                     and   oper-ord.cod-roteiro  = input frame {&frame-name} pert-ordem.rot-predec
                     and   oper-ord.nr-ord-produ = ord-prod.nr-ord-produ"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-predec V-table-Win
ON F5 OF pert-ordem.op-predec IN FRAME f-main /* Opera‡Æo Predecessora */
DO:
  find ord-prod where rowid(ord-prod) = gr-ord-prod no-lock no-error.                   
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = pert-ordem.op-predec
                     &campozoom  = op-codigo
                     &campo2     = pert-ordem.rot-predec
                     &campozoom2 = cod-roteiro
                     &campo3     = pert-ordem.it-predec
                     &campozoom3 = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-predec V-table-Win
ON LEAVE OF pert-ordem.op-predec IN FRAME f-main /* Opera‡Æo Predecessora */
DO:
  {include/leave.i &tabela=oper-ord
                   &atributo-ref=descricao
                   &variavel-ref=fi-oper-pred-descricao
                   &where="oper-ord.op-codigo    = input frame {&frame-name} pert-ordem.op-predec
                     and   oper-ord.it-codigo    = input frame {&frame-name} pert-ordem.it-predec
                     and   oper-ord.cod-roteiro  = input frame {&frame-name} pert-ordem.rot-predec
                     and   oper-ord.nr-ord-produ = ord-prod.nr-ord-produ"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.op-predec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pert-ordem.op-predec IN FRAME f-main /* Opera‡Æo Predecessora */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME pert-ordem.rot-predec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.rot-predec V-table-Win
ON ENTRY OF pert-ordem.rot-predec IN FRAME f-main /* Roteiro Predecessor */
DO:
  find rot-item where rot-item.it-codigo = input pert-ordem.it-predec 
                and   rot-item.cod-roteiro = input pert-ordem.rot-predec NO-LOCK no-error.
  if avail rot-item then do: find rot-fabric of rot-item NO-LOCK no-error.
                             if avail rot-fabric
                                then fi-rot-pred-descricao:screen-value = rot-fabric.descricao.
                         end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.rot-predec V-table-Win
ON F5 OF pert-ordem.rot-predec IN FRAME f-main /* Roteiro Predecessor */
DO:
  find ord-prod where rowid(ord-prod) = gr-ord-prod no-lock no-error.                   
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = pert-ordem.op-predec
                     &campozoom  = op-codigo
                     &campo2     = pert-ordem.rot-predec
                     &campozoom2 = cod-roteiro
                     &campo3     = pert-ordem.it-predec
                     &campozoom3 = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.rot-predec V-table-Win
ON LEAVE OF pert-ordem.rot-predec IN FRAME f-main /* Roteiro Predecessor */
DO:
  find rot-item where rot-item.it-codigo = input pert-ordem.it-predec 
                and   rot-item.cod-roteiro = input pert-ordem.rot-predec NO-LOCK no-error.
  if avail rot-item then do: find rot-fabric of rot-item NO-LOCK no-error.
                             if avail rot-fabric
                                then fi-rot-pred-descricao:screen-value = rot-fabric.descricao.
                         end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL pert-ordem.rot-predec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF pert-ordem.rot-predec IN FRAME f-main /* Roteiro Predecessor */
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

  if pert-ordem.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if pert-ordem.it-predec:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if pert-ordem.cod-roteiro:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if pert-ordem.rot-predec:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if pert-ordem.op-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if pert-ordem.op-predec:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  {inbo/boin301.i1}  /*** Procedures Negocio Pert-Ordem ***/    

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE actOperacInicFim V-table-Win 
PROCEDURE actOperacInicFim :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF BUFFER b-pert-ordem FOR pert-ordem.

for each oper-ord exclusive-lock where
    oper-ord.nr-ord-produ = ord-prod.nr-ord-produ:

    if can-find (first b-pert-ordem WHERE
                 b-pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ and 
                 b-pert-ordem.it-codigo    = oper-ord.it-codigo    and 
                 b-pert-ordem.cod-roteiro  = oper-ord.cod-roteiro  and 
                 b-pert-ordem.op-codigo    = oper-ord.op-codigo) then
        assign oper-ord.log-operac-ini = false.
    else
        assign oper-ord.log-operac-ini = true.

    if can-find (first b-pert-ordem WHERE
                 b-pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ and 
                 b-pert-ordem.it-predec    = oper-ord.it-codigo    and 
                 b-pert-ordem.rot-predec   = oper-ord.cod-roteiro  and 
                 b-pert-ordem.op-predec    = oper-ord.op-codigo) then
        assign oper-ord.log-operac-final = false.
    else
        assign oper-ord.log-operac-final = true.
end.

return 'ok':u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "pert-ordem"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "pert-ordem"}

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

  /* Code placed here will execute AFTER standard behavior.    */

  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.

  do with frame {&frame-name}:
     assign pert-ordem.it-codigo:screen-value = ord-prod.it-codigo
            pert-ordem.it-predec:screen-value = ord-prod.it-codigo.      
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
DO TRANSACTION:
  /* Code placed here will execute PRIOR to standard behavior. */

  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U. 

  find ord-prod where rowid(ord-prod) = gr-ord-prod no-lock no-error.
  find first param-global no-lock.
  find first param-cp no-lock.

  if pert-ordem.it-codigo:sensitive in frame {&frame-name} then do:    
     find pert-ordem where pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ
                       and pert-ordem.it-codigo    = input pert-ordem.it-codigo
                       and pert-ordem.cod-roteiro  = input pert-ordem.cod-roteiro
                       and pert-ordem.op-codigo    = input pert-ordem.op-codigo
                       and pert-ordem.it-predec    = input pert-ordem.it-predec
                       and pert-ordem.rot-predec   = input pert-ordem.rot-predec
                       and pert-ordem.op-predec    = input pert-ordem.op-predec
          NO-LOCK no-error.
     if avail pert-ordem then do:
        run utp/ut-msgs.p (input "show",
                           input 2787,
                           input "").
        return 'ADM-ERROR':U.
     end.
  end.

  find oper-ord where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                  and oper-ord.it-codigo    = input pert-ordem.it-codigo
                  and oper-ord.cod-roteiro  = input pert-ordem.cod-roteiro
                  and oper-ord.op-codigo    = input pert-ordem.op-codigo
       no-lock no-error.
  if not avail oper-ord then do:
     run utp/ut-msgs.p (input "show",
                        input 1220,
                        input "").
     return 'ADM-ERROR':U.
  end.

  assign r-anterior = rowid (oper-ord).

  find oper-ord where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                  and oper-ord.it-codigo    = input pert-ordem.it-predec
                  and oper-ord.cod-roteiro  = input pert-ordem.rot-predec
                  and oper-ord.op-codigo    = input pert-ordem.op-predec
       no-lock no-error.
  if not avail oper-ord then do:
     run utp/ut-msgs.p (input "show",
                        input 2789,
                        input "").
     return 'ADM-ERROR':U.
  end.

  if r-anterior = rowid (oper-ord) then do:
     run utp/ut-msgs.p (input "show",
                        input 2791,
                        input "").
     return 'ADM-ERROR':U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  assign pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ.

  run IncluirPertOrdem (buffer pert-ordem).
  RUN actOperacInicFim.

  empty temp-table tt-gera-rede.

  /* Valida se nao houve reportes nas operacoes */
  create tt-gera-rede.
  assign tt-gera-rede.nr-ord-produ   = ord-prod.nr-ord-produ
         tt-gera-rede.tipo-exec      = 4
         tt-gera-rede.rw-pert-ordem  = rowid(pert-ordem)
         tt-gera-rede.cod-prog-orig  = "v01in301"
         tt-gera-rede.cod-versao-integracao = 001.

  DEFINE VARIABLE h-cpapi023 AS HANDLE      NO-UNDO.

  run cpp/cpapi023.p PERSISTENT SET h-cpapi023 (input-output table tt-gera-rede,
                                                input-output table tt-erro,
                                                input        true).
  
  IF VALID-HANDLE(h-cpapi023)
  THEN DO:
        RUN validRedePertInc IN h-cpapi023 (adm-new-record).
        run geraPertOrdem IN h-cpapi023 (   input-output table tt-gera-rede,
                                            input-output table tt-erro,
                                            input        true).
        DELETE OBJECT h-cpapi023.
        ASSIGN h-cpapi023 = ?.
  END.

  if return-value <> 'ok':u or
     temp-table tt-erro:has-records then do:

      run cdp/cd0666.w (input table tt-erro).
      undo, return 'ADM-ERROR':U.

  end.  

  /*** Cria‡Æo de Opera‡äes Para Ordem de Produ‡Æo ***/
  FIND FIRST op-sfc WHERE op-sfc.nr-ord-produ = ord-prod.nr-ord-produ EXCLUSIVE-LOCK NO-ERROR.
  if  available op-sfc THEN DO:
      run inbo/boin533.p persistent set h-boin533.
      run GerarSplitOperac in h-boin533 (buffer op-sfc).
      delete procedure h-boin533.
  END.

  /* Chamada do adapter sender de Ordem de Produ‡Æo EAI */
  /* Execucao caso usuario possua integracao EAI */
  IF v_log_eai_habilit AND
     return-value <> "ADM-ERROR":U  THEN DO:
      IF AVAIL ord-prod THEN DO:
          CREATE tt-ord-prod.
          BUFFER-COPY ord-prod TO tt-ord-prod.
          RUN adapters/xml/ma2/axsma007.p (INPUT "upd",
                                           INPUT "b01in301.w",
                                           INPUT STRING(c-prg-vrs),
                                           INPUT TABLE tt-ord-prod,
                                           OUTPUT TABLE RowErrors).  

          DELETE tt-ord-prod.
          FIND FIRST RowErrors WHERE
              RowErrors.ErrorSubType = "ERROR":U NO-LOCK NO-ERROR.

          IF AVAIL RowErrors THEN DO:
              run utp/ut-msgs.p (input "show",
                                 input RowErrors.ErrorNumber,
                                 input RowErrors.ErrorDescription).

              UNDO,RETURN.
          END.
      END.
  END.
  IF param-cp.log-integr-ppi-mes  = YES THEN DO :
     run cpp/cpapi301b.p ( input rowid(ord-prod),
                           input ord-prod.nr-ord-prod, 
                           input 2).
     if return-value = "NOK" then do:
         {utp/ut-liter.i Ordem_de_produ‡Æo *}
         run utp/ut-msgs.p (input "show",
                            input 54436,
                            input RETURN-VALUE).
     end.
  END.



END.
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

  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.

  if avail pert-ordem then do:
     find item no-lock where
          item.it-codigo = pert-ordem.it-codigo no-error.
     if avail item then 
        assign fi-item-descricao = item.desc-item.
        else 
            assign fi-item-descricao = "".

     find rot-fabric no-lock where
          rot-fabric.cod-roteiro = pert-ordem.cod-roteiro no-error.
     if avail rot-fabric 
        then assign fi-rot-fabric-descricao = rot-fabric.descricao.
     else assign fi-rot-fabric-descricao = "".

     find oper-ord no-lock where
          oper-ord.nr-ord-produ = ord-prod.nr-ord-produ and
          oper-ord.op-codigo    = pert-ordem.op-codigo and
          oper-ord.it-codigo    = pert-ordem.it-codigo and
          oper-ord.cod-roteiro  = pert-ordem.cod-roteiro no-error.
     if avail oper-ord 
        then assign fi-oper-descricao = oper-ord.descricao.
     else assign fi-oper-descricao = "".

     find item no-lock where
          item.it-codigo = pert-ordem.it-predec no-error.
     if avail item then
        assign fi-item-pred-descricao = item.desc-item.
        else 
            assign fi-item-pred-descricao = "".

     find rot-fabric no-lock where
          rot-fabric.cod-roteiro = pert-ordem.rot-predec no-error.
     if avail rot-fabric 
        then assign fi-rot-pred-descricao = rot-fabric.descricao.
     else assign fi-rot-pred-descricao = "".             

     find oper-ord no-lock where
          oper-ord.nr-ord-produ = ord-prod.nr-ord-produ and
          oper-ord.op-codigo    = pert-ordem.op-predec and
          oper-ord.it-codigo    = pert-ordem.it-predec and
          oper-ord.cod-roteiro  = pert-ordem.rot-predec no-error.
     if avail oper-ord 
        then assign fi-oper-pred-descricao = oper-ord.descricao.
     else assign fi-oper-pred-descricao = "".     

  end.

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  /* Ponha aqui a valida‡Æo de chave duplicada */
  /* Ponha aqui as demais valida‡äes */
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "pert-ordem"}

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

