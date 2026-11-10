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
{include/i-prgvrs.i V01IN007 2.00.00.016 } /*** 010016 ***/

/* &IF "{&EMSFND_VERSION}" >= "1.00" &THEN    */
/* {include/i-license-manager.i v01in007 MUT} */
/* &ENDIF                                     */


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

/** Zoom de saldos estoque **/
def new global shared var c-it-codigo like saldo-estoq.it-codigo   no-undo.
def new global shared var c-estab     like saldo-estoq.cod-estabel no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var i-nr-ord-prod as integer no-undo.

{cdp/cdcfgman.i}

&IF DEFINED (bf_man_per_ppm) &THEN
    {cdp/cd0666.i}
    {cpp/cpapi020.i}
    {cpp/cpapi020.i1}
&ENDIF

DEFINE VARIABLE l-per-ppm AS LOGICAL INIT NO NO-UNDO.

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
def var h-ceapi030      as handle no-undo.
def var l-lote-avancado as log    no-undo.
def var l-retorno       as log    no-undo.

{cep/ceapi030.i}
&endif

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
&Scoped-define EXTERNAL-TABLES aloca-reserva
&Scoped-define FIRST-EXTERNAL-TABLE aloca-reserva


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR aloca-reserva.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS aloca-reserva.nr-ord-produ ~
aloca-reserva.cod-refer 
&Scoped-define ENABLED-TABLES aloca-reserva
&Scoped-define FIRST-ENABLED-TABLE aloca-reserva
&Scoped-Define ENABLED-OBJECTS label-concentracao label-quant-aloc ~
fi-per-ppm-item fi-per-ppm-lote fi-qt-aloc-lote rt-key rt-mold RECT-10 ~
RECT-11 RECT-12 
&Scoped-Define DISPLAYED-FIELDS aloca-reserva.nr-ord-produ ~
aloca-reserva.it-codigo aloca-reserva.cod-refer aloca-reserva.item-pai ~
aloca-reserva.op-codigo aloca-reserva.cod-roteiro aloca-reserva.cod-depos ~
aloca-reserva.cod-localiz aloca-reserva.lote-serie aloca-reserva.quant-aloc 
&Scoped-define DISPLAYED-TABLES aloca-reserva
&Scoped-define FIRST-DISPLAYED-TABLE aloca-reserva
&Scoped-Define DISPLAYED-OBJECTS label-concentracao label-quant-aloc ~
fi-saldo-reserva fi-disponivel fi-per-ppm-item fi-per-ppm-lote ~
fi-qt-aloc-lote fi-disponivel-teorica 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS aloca-reserva.nr-ord-produ ~
aloca-reserva.it-codigo aloca-reserva.item-pai aloca-reserva.op-codigo ~
aloca-reserva.cod-roteiro aloca-reserva.cod-depos aloca-reserva.cod-localiz ~
aloca-reserva.lote-serie fi-saldo-reserva fi-disponivel ~
aloca-reserva.quant-aloc fi-disponivel-teorica 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-cod-depos 
       MENU-ITEM mi_Deposito    LABEL "Pesquisa &Dep¢sitos"
       MENU-ITEM mi_Saldo       LABEL "Pesquisa &Saldos".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE fi-disponivel AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Dispon°vel" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-disponivel-teorica AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde Atual Te¢rica" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm-item AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-per-ppm-lote AS DECIMAL FORMAT ">>>>>,>>9.9999":U INITIAL 0 
     LABEL "Lote" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-qt-aloc-lote AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtde F°sica" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo-reserva AS DECIMAL FORMAT "->>>>>,>>9.9999":U INITIAL 0 
     LABEL "Saldo da Reserva" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE label-concentracao AS CHARACTER FORMAT "X(256)":U INITIAL "Concentraá∆o (%)" 
      VIEW-AS TEXT 
     SIZE 17 BY .67 NO-UNDO.

DEFINE VARIABLE label-quant-aloc AS CHARACTER FORMAT "X(256)":U INITIAL "Qtde Te¢rica:" 
      VIEW-AS TEXT 
     SIZE 12.29 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44.72 BY 2.67.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 2.67.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.08.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.5.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     aloca-reserva.nr-ord-produ AT ROW 1.25 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     label-concentracao AT ROW 13 COL 53.14 COLON-ALIGNED NO-LABEL
     aloca-reserva.it-codigo AT ROW 2.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     aloca-reserva.cod-refer AT ROW 2.75 COL 65.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     aloca-reserva.item-pai AT ROW 3.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     label-quant-aloc AT ROW 13.92 COL 8.29 COLON-ALIGNED NO-LABEL
     aloca-reserva.op-codigo AT ROW 4.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     aloca-reserva.cod-roteiro AT ROW 5.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     aloca-reserva.cod-depos AT ROW 6.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     aloca-reserva.cod-localiz AT ROW 7.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     aloca-reserva.lote-serie AT ROW 8.75 COL 34 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 45 BY .88
     fi-saldo-reserva AT ROW 9.75 COL 34 COLON-ALIGNED
     fi-disponivel AT ROW 11.71 COL 34 COLON-ALIGNED
     fi-per-ppm-item AT ROW 13.79 COL 54.86 COLON-ALIGNED
     fi-per-ppm-lote AT ROW 14.75 COL 54.86 COLON-ALIGNED
     aloca-reserva.quant-aloc AT ROW 13.79 COL 21 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-qt-aloc-lote AT ROW 14.75 COL 21 COLON-ALIGNED
     fi-disponivel-teorica AT ROW 10.71 COL 34 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     RECT-10 AT ROW 13.25 COL 1.29
     RECT-11 AT ROW 13.25 COL 46.29
     RECT-12 AT ROW 12.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.aloca-reserva
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
         HEIGHT             = 15.04
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit 2 Custom                          */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN aloca-reserva.cod-depos IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       aloca-reserva.cod-depos:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-depos:HANDLE.

/* SETTINGS FOR FILL-IN aloca-reserva.cod-localiz IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN aloca-reserva.cod-roteiro IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-disponivel IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-disponivel-teorica IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-saldo-reserva IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN aloca-reserva.it-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN aloca-reserva.item-pai IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN aloca-reserva.lote-serie IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN aloca-reserva.nr-ord-produ IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN aloca-reserva.op-codigo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN aloca-reserva.quant-aloc IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME aloca-reserva.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-depos V-table-Win
ON F5 OF aloca-reserva.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    {include/zoomvar.i &prog-zoom   = "inzoom/z01in084.w"
                      &campo        = aloca-reserva.cod-depos
                      &campozoom    = cod-depos} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-depos V-table-Win
ON LEAVE OF aloca-reserva.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   run pi-calcula-saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
   apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-localiz V-table-Win
ON LEAVE OF aloca-reserva.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
   run pi-calcula-saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-refer V-table-Win
ON F5 OF aloca-reserva.cod-refer IN FRAME f-main /* Referància */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                     &campo=aloca-reserva.cod-refer
                     &campozoom = cod-refer
                     &parametros= "run pi-seta-inicial in wh-pesquisa
                     (aloca-reserva.it-codigo:screen-value in frame {&frame-name})." }  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.cod-refer IN FRAME f-main /* Referància */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-roteiro V-table-Win
ON F5 OF aloca-reserva.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
   apply "f5" to aloca-reserva.it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-roteiro V-table-Win
ON LEAVE OF aloca-reserva.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
   run pi-calcula-saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.cod-roteiro IN FRAME f-main /* Roteiro */
DO:
   apply "f5" to aloca-reserva.it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qt-aloc-lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qt-aloc-lote V-table-Win
ON LEAVE OF fi-qt-aloc-lote IN FRAME f-main /* Qtde F°sica */
DO:
    &IF DEFINED(bf_man_205) &THEN
        IF l-per-ppm THEN DO:
            IF fi-per-ppm-lote <> ? THEN DO:
                ASSIGN aloca-reserva.quant-aloc:SCREEN-VALUE IN FRAME f-main = 
                                  string(f-conv-qtde (INPUT FRAME f-main fi-qt-aloc-lote, 
                                                      fi-per-ppm-lote,      
                                                      fi-per-ppm-item)).
            END.
        END.
    &ENDIF /*&IF DEFINED(bf_man_205)*/  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.it-codigo V-table-Win
ON F5 OF aloca-reserva.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom  = "inzoom/z01in390.w"
                     &campo      = aloca-reserva.it-codigo
                     &campozoom  = it-codigo
                     &campo2      = aloca-reserva.item-pai
                     &campozoom2  = item-pai 
                     &campo3      = aloca-reserva.op-codigo
                     &campozoom3  = op-codigo
                     &campo4      = aloca-reserva.cod-roteiro
                     &campozoom4  = cod-roteiro}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.it-codigo V-table-Win
ON LEAVE OF aloca-reserva.it-codigo IN FRAME f-main /* Item */
DO:
   find item where 
        item.it-codigo = input frame {&frame-name} aloca-reserva.it-codigo
        no-lock no-error.
   if avail(item) then
      assign aloca-reserva.cod-localiz:sensitive = not(item.loc-unica)         
             aloca-reserva.lote-serie:sensitive  = (item.tipo-con-est <> 1)
             aloca-reserva.cod-refer:sensitive   = (item.tipo-con-est = 4).
   else
      assign aloca-reserva.cod-localiz:sensitive = no
             aloca-reserva.lote-serie:sensitive  = no
             aloca-reserva.cod-refer:sensitive   = no.
             
   run pi-calcula-saldos.          
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.it-codigo IN FRAME f-main /* Item */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.item-pai
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.item-pai V-table-Win
ON F5 OF aloca-reserva.item-pai IN FRAME f-main /* Item Pai */
DO:
   apply "F5" to aloca-reserva.it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.item-pai V-table-Win
ON LEAVE OF aloca-reserva.item-pai IN FRAME f-main /* Item Pai */
DO:
   run pi-calcula-saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.item-pai V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.item-pai IN FRAME f-main /* Item Pai */
DO:
   apply "F5" to aloca-reserva.it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.lote-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.lote-serie V-table-Win
ON LEAVE OF aloca-reserva.lote-serie IN FRAME f-main /* Lote/SÇrie */
DO:
   run pi-calcula-saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi_Deposito
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi_Deposito V-table-Win
ON CHOOSE OF MENU-ITEM mi_Deposito /* Pesquisa Dep¢sitos */
DO:
  apply "f5":U to aloca-reserva.cod-depos in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi_Saldo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi_Saldo V-table-Win
ON CHOOSE OF MENU-ITEM mi_Saldo /* Pesquisa Saldos */
DO:
  def buffer b-ord-prod for ord-prod.


  for first b-ord-prod fields(cod-estabel)
      where b-ord-prod.nr-ord-produ = input frame {&FRAME-NAME} aloca-reserva.nr-ord-produ no-lock:
      assign c-estab = b-ord-prod.cod-estabel.
  end.

  assign l-implanta = yes
         c-it-codigo = input frame {&frame-name} aloca-reserva.it-codigo.
  
  {include/zoomvar.i
        &prog-zoom  = "inzoom/z02in403.w"
        &campo      = aloca-reserva.cod-depos
        &campo2     = aloca-reserva.cod-localiz
        &campo3     = aloca-reserva.lote-serie
        &campo4     = aloca-reserva.cod-refer
        &campozoom  = cod-depos
        &campozoom2 = cod-localiz
        &campozoom3 = lote
        &campozoom4 = cod-refer} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.nr-ord-produ
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.nr-ord-produ V-table-Win
ON F5 OF aloca-reserva.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:
   {include/zoomvar.i &prog-zoom   = "inzoom/z01in271.w"
                      &campo       = aloca-reserva.nr-ord-produ
                      &campozoom   = nr-ord-produ}                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.nr-ord-produ V-table-Win
ON LEAVE OF aloca-reserva.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:
   assign i-nr-ord-prod = input frame {&frame-name} aloca-reserva.nr-ord-produ.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.nr-ord-produ V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.nr-ord-produ IN FRAME f-main /* Ordem Produá∆o */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.op-codigo V-table-Win
ON F5 OF aloca-reserva.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
   apply "f5" to aloca-reserva.it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.op-codigo V-table-Win
ON LEAVE OF aloca-reserva.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
   run pi-calcula-saldos.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF aloca-reserva.op-codigo IN FRAME f-main /* Operaá∆o */
DO:
   apply "f5" to aloca-reserva.it-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME aloca-reserva.quant-aloc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL aloca-reserva.quant-aloc V-table-Win
ON LEAVE OF aloca-reserva.quant-aloc IN FRAME f-main /* Qtde Aloc */
DO:
    &IF DEFINED(bf_man_205) &THEN
        IF l-per-ppm THEN DO:
            IF fi-per-ppm-lote <> ? THEN DO:
                ASSIGN fi-qt-aloc-lote = f-conv-qtde (INPUT FRAME f-main aloca-reserva.quant-aloc, 
                                                      fi-per-ppm-item,      
                                                      fi-per-ppm-lote).
                DISPLAY fi-qt-aloc-lote WITH FRAME f-main.
            END.
            ELSE
                ASSIGN fi-qt-aloc-lote:SCREEN-VALUE IN FRAME f-main = aloca-reserva.quant-aloc:SCREEN-VALUE IN FRAME f-main.
        END.
    &ENDIF /*&IF DEFINED(bf_man_205)*/
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

  {utp/ut-liter.i Saldo_da_Reserva * L}
  assign fi-saldo-reserva:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i Dispon°vel * L}
  assign fi-disponivel:label in frame {&frame-name} = return-value.
  
  if aloca-reserva.nr-ord-produ:load-mouse-pointer("image/lupa.cur") then.
  if aloca-reserva.it-codigo:load-mouse-pointer("image/lupa.cur")    then.
  if aloca-reserva.op-codigo:load-mouse-pointer("image/lupa.cur")    then.
  if aloca-reserva.cod-roteiro:load-mouse-pointer("image/lupa.cur")  then.
  if aloca-reserva.item-pai:load-mouse-pointer("image/lupa.cur")     then.
  if aloca-reserva.cod-depos:load-mouse-pointer("image/rbm.cur")     then.
  if aloca-reserva.cod-refer:load-mouse-pointer("image/lupa.cur")    then.

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
  {src/adm/template/row-list.i "aloca-reserva"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "aloca-reserva"}

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

  DISPLAY label-quant-aloc WITH FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  DEFINE VARIABLE de-qtd-fisica AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE de-qtd-fisica-antiga  AS DECIMAL     NO-UNDO.
  DEFINE VARIABLE de-qtd-teorica-antiga AS DECIMAL     NO-UNDO.
  define variable de-qtidade            like saldo-estoq.qtidade-atu no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  
  find ord-prod where 
       ord-prod.nr-ord-prod = input frame {&frame-name} aloca-reserva.nr-ord-produ
       no-lock no-error.       
  if not avail(ord-prod) then do:
     {utp/ut-table.i mgind ord-prod 1}
     run utp/ut-msgs.p (input "show"      ,
                        input 56          ,
                        input return-value).
     apply "entry" to aloca-reserva.nr-ord-prod.
     return "adm-error".
  end.                                              
            
  if ord-prod.estado = 8 and param-global.modulo-cs = yes then do:
     /* Ordem terminada. Somente custos pode reabri-la. */
     run utp/ut-msgs.p (input "show",
                        input 3809  ,
                        input ""    ).
     apply "entry" to aloca-reserva.nr-ord-prod.                   
     return "adm-error".                   
  end.            
  if ord-prod.estado = 7 or ord-prod.estado = 8 then do:
     /* Ordem terminada ou finalizada. */
     run utp/ut-msgs.p (input "show",
                        input 1311  ,
                        input ""    ).
     apply "entry" to aloca-reserva.nr-ord-prod.                        
     return "adm-error".                   
  end.     
  
  find reservas where 
       reservas.nr-ord-produ = input frame {&frame-name} aloca-reserva.nr-ord-produ and
       reservas.item-pai     = input frame {&frame-name} aloca-reserva.item-pai     and
       reservas.cod-roteiro  = input frame {&frame-name} aloca-reserva.cod-roteiro  and
       reservas.op-codigo    = input frame {&frame-name} aloca-reserva.op-codigo    and
       reservas.it-codigo    = input frame {&frame-name} aloca-reserva.it-codigo    and
       reservas.estado       = 1
       no-lock no-error.
  if not avail(reservas) then do:
     {utp/ut-table.i mgind reservas 1}
     run utp/ut-msgs.p (input "show"      ,
                        input 56          ,
                        input return-value).
     apply "entry" to aloca-reserva.it-codigo in frame {&frame-name}.
     return "adm-error".
  end.                      

  find deposito where 
       deposito.cod-depos = input frame {&frame-name} aloca-reserva.cod-depos
       no-lock no-error.
  if not avail(deposito) then do:
     {utp/ut-table.i mgind deposito 1}
     run utp/ut-msgs.p (input "show"      ,
                        input 56          ,
                        input return-value).
     apply "entry" to aloca-reserva.cod-depos in frame {&frame-name}.
     return "adm-error".
  end.
                             
  if deposito.alocado = no then do:
     /* Deposito nao permite alocacao */
     run utp/ut-msgs.p (input "show",
                        input 5302  ,
                        input ""    ).
     apply "entry" to aloca-reserva.cod-depos in frame {&frame-name}.
     return "adm-error".                                                
  end.      

  ASSIGN de-qtd-fisica = &IF DEFINED(bf_man_205) &THEN
                            IF l-per-ppm THEN INPUT FRAME f-main fi-qt-aloc-lote ELSE input frame {&frame-name} aloca-reserva.quant-aloc.
                         &ELSE
                            input frame {&frame-name} aloca-reserva.quant-aloc.
                         &ENDIF

  /* Cria registro aloca-reserva */
  if adm-new-record then do:
     find first aloca-reserva 
     where aloca-reserva.nr-ord-produ = input frame {&frame-name} aloca-reserva.nr-ord-produ
     and   aloca-reserva.item-pai     = input frame {&frame-name} aloca-reserva.item-pai
     and   aloca-reserva.cod-roteiro  = input frame {&frame-name} aloca-reserva.cod-roteiro
     and   aloca-reserva.op-codigo    = input frame {&frame-name} aloca-reserva.op-codigo
     and   aloca-reserva.it-codigo    = input frame {&frame-name} aloca-reserva.it-codigo
     and   aloca-reserva.cod-estabel  = ord-prod.cod-estabel
     and   aloca-reserva.cod-depos    = input frame {&frame-name} aloca-reserva.cod-depos
     and   aloca-reserva.cod-localiz  = input frame {&frame-name} aloca-reserva.cod-localiz
     and   aloca-reserva.lote-serie   = input frame {&frame-name} aloca-reserva.lote-serie
     and   aloca-reserva.nr-req-sum   = ord-prod.nr-req-sum
     exclusive-lock no-error.
     if avail(aloca-reserva) then do:
        if aloca-reserva.quant-aloc > 0 then do:
           /* Alocacao das reservas ja existente */
           {utp/ut-table.i mgind aloca-reserva 1}
           run utp/ut-msgs.p (input "show"      ,
                              input 1           ,
                              input return-value).
           apply "entry" to aloca-reserva.it-codigo.
           return "adm-error".                              
        end.                           
     end.

     run pi-calcula-saldos.   

     if de-qtd-fisica > fi-disponivel then do:
        /* Quantidade a alocar excede saldo disponivel p/alocacao */
        run utp/ut-msgs.p (input "show",
                           input 5275  ,
                           input ""    ).
        apply "entry" to aloca-reserva.quant-aloc.
        return "adm-error".
     end.                           
     if (reservas.quant-orig  - reservas.quant-aloc       - 
         reservas.quant-atend) < 
         input frame {&frame-name} aloca-reserva.quant-aloc
     then do:
        /* Qt.Alocada maior que a reservada. Alocacao nao realizada */
        run utp/ut-msgs.p (input "show",
                           input 5295  ,
                           input ""    ).
        apply "entry" to aloca-reserva.quant-aloc.
        return "adm-error".
     end.                                               
  end.   
  else do :
     if aloca-reserva.quant-aloc > fi-disponivel then do :
        /* Quantidade a alocar excede saldo disponivel para alocacao */
        run utp/ut-msgs.p (input "show",
                           input 5275  ,
                           input ""    ).
        apply "entry" to aloca-reserva.quant-aloc.
        return "adm-error".
     end.
     
     if (reservas.quant-orig  - reservas.quant-aloc 
       - reservas.quant-atend + aloca-reserva.quant-aloc)
       < input frame {&frame-name} aloca-reserva.quant-aloc then do :
        /* Qt.Alocada maior que a reservada. Alocacao nao realizada */
        run utp/ut-msgs.p (input "show",
                           input 5295  ,
                           input ""    ).
        apply "entry" to aloca-reserva.quant-aloc.
        return "adm-error".
     end.                                                          

   &if '{&bf_lote_avancado_liberado}' = 'yes' &then
     assign l-retorno = yes.

     find first item where item.it-codigo = saldo-estoq.it-codigo no-lock no-error.
     if l-lote-avancado and
        avail item and
        item.tipo-con-est > 2 then do:

         run pi-identifica-saldo in h-ceapi030 (input 1,
                                                input saldo-estoq.it-codigo,
                                                input saldo-estoq.cod-estabel,
                                                input saldo-estoq.lote,
                                                input 0,
                                                output l-retorno,
                                                output table tt-valores2,
                                                output table tt-erro).
         if return-value = "nok":u then do:
             run cdp/cd0666.w (input table tt-erro).
             return "adm-error".
         end.
     end.

     if not l-retorno then do:
         assign de-qtidade = 0.
         run utp/ut-msgs.p (input "show",
                            input 36669,
                            input saldo-estoq.lote).
         apply "entry" to aloca-reserva.quant-aloc.
         return "adm-error".
     end.
     else
   &endif
     
     if not avail saldo-estoq
     or ((saldo-estoq.qtidade-atu
        - saldo-estoq.qt-alocada
        - saldo-estoq.qt-aloc-prod 
        - aloca-reserva.quant-aloc 
        - saldo-estoq.qt-aloc-ped) 
        < de-qtd-fisica - 
         &IF DEFINED(bf_man_205) &THEN
            (IF aloca-reserva.qt-aloc-lote <> 0 THEN aloca-reserva.qt-aloc-lote ELSE aloca-reserva.quant-aloc)
         &ELSE
            aloca-reserva.quant-aloc
         &ENDIF )
         then do :
        /* Nao ha saldo disponivel para alocacao */
        run utp/ut-msgs.p (input "show",
                           input 5275  ,
                           input ""    ).
        apply "entry" to aloca-reserva.quant-aloc.
        return "adm-error".
     end.                      
  end.   

  IF adm-new-record = NO AND AVAIL aloca-reserva THEN
  ASSIGN de-qtd-teorica-antiga = aloca-reserva.quant-aloc
       &IF DEFINED(bf_man_205) &THEN
         de-qtd-fisica-antiga  = aloca-reserva.qt-aloc-lote
       &ENDIF
      .

  &IF DEFINED(bf_man_205) &THEN
       /*Caso n∆o seja um componente per-ppm, e o usu†rio n∆o tenha efetuado nenhuma alteraá∆o em relaá∆o ao valor inicial, 
         n∆o far† gravaá∆o alguma.*/
       IF adm-new-record = NO AND 
          l-per-ppm = NO and
           (input frame {&frame-name} aloca-reserva.quant-aloc = 
              (IF aloca-reserva.qt-aloc-lote <> 0 THEN aloca-reserva.qt-aloc-lote ELSE aloca-reserva.quant-aloc)
            ) THEN
           RETURN "":U.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
  /* Code placed here will execute AFTER standard behavior.    */

  find current saldo-estoq exclusive-lock no-error.
  find current reservas    exclusive-lock no-error.

  if adm-new-record then do :

     assign aloca-reserva.cod-estabel  = ord-prod.cod-estabel
            aloca-reserva.nr-req-sum   = ord-prod.nr-req-sum
            reservas.quant-aloc        = reservas.quant-aloc +
                                         input frame {&frame-name} aloca-reserva.quant-aloc.
     &IF DEFINED(bf_man_205) &THEN
        IF l-per-ppm THEN
            ASSIGN aloca-reserva.qt-aloc-lote = INPUT FRAME f-main fi-qt-aloc-lote.
        ELSE
            ASSIGN aloca-reserva.qt-aloc-lote = input frame {&frame-name} aloca-reserva.quant-aloc.

        ASSIGN reservas.qt-aloc-lote    = reservas.qt-aloc-lote + aloca-reserva.qt-aloc-lote
               saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod + aloca-reserva.qt-aloc-lote.
     &ELSE
        ASSIGN saldo-estoq.qt-aloc-prod   = saldo-estoq.qt-aloc-prod +
                                            input frame {&frame-name} aloca-reserva.quant-aloc.
     &ENDIF

  end.                                                    
  else do :

     ASSIGN reservas.quant-aloc  = reservas.quant-aloc      
                                 - de-qtd-teorica-antiga                                 
                                 + input frame {&frame-name} aloca-reserva.quant-aloc.   
     &IF DEFINED(bf_man_205) &THEN
        IF l-per-ppm THEN
            ASSIGN aloca-reserva.qt-aloc-lote = INPUT FRAME f-main fi-qt-aloc-lote.
        ELSE
            ASSIGN aloca-reserva.qt-aloc-lote = input frame {&frame-name} aloca-reserva.quant-aloc.

        ASSIGN reservas.qt-aloc-lote    = reservas.qt-aloc-lote - de-qtd-fisica-antiga + aloca-reserva.qt-aloc-lote
               saldo-estoq.qt-aloc-prod = saldo-estoq.qt-aloc-prod - de-qtd-fisica-antiga + aloca-reserva.qt-aloc-lote.
     &ELSE
        ASSIGN saldo-estoq.qt-aloc-prod   = saldo-estoq.qt-aloc-prod - de-qtd-teorica-antiga + 
                                            input frame {&frame-name} aloca-reserva.quant-aloc.
     &ENDIF
  end.                                     

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  &IF DEFINED (bf_man_per_ppm) &THEN
    if valid-handle (h-cpapi020) then
        run pi-finalizar in h-cpapi020.
  &ENDIF

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  if valid-handle(h-ceapi030) then
      delete procedure h-ceapi030.
&endif

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
  
  assign aloca-reserva.cod-depos:sensitive    in frame {&frame-name} = adm-new-record
         aloca-reserva.cod-localiz:sensitive  in frame {&frame-name} = adm-new-record
         aloca-reserva.cod-roteiro:sensitive  in frame {&frame-name} = adm-new-record
         aloca-reserva.it-codigo:sensitive    in frame {&frame-name} = adm-new-record
         aloca-reserva.item-pai:sensitive     in frame {&frame-name} = adm-new-record
         aloca-reserva.lote-serie:sensitive   in frame {&frame-name} = adm-new-record
         aloca-reserva.nr-ord-produ:sensitive in frame {&frame-name} = adm-new-record 
         aloca-reserva.op-codigo:sensitive    in frame {&frame-name} = adm-new-record
         aloca-reserva.quant-aloc:sensitive   in frame {&frame-name} = yes.   
  
  if not(adm-new-record) then do:
     find ord-prod where 
          ord-prod.nr-ord-prod = aloca-reserva.nr-ord-prod
          no-lock no-error.                
          
     find reservas where 
          reservas.nr-ord-produ = input frame {&frame-name} aloca-reserva.nr-ord-produ and
          reservas.item-pai     = input frame {&frame-name} aloca-reserva.item-pai     and
          reservas.cod-roteiro  = input frame {&frame-name} aloca-reserva.cod-roteiro  and
          reservas.op-codigo    = input frame {&frame-name} aloca-reserva.op-codigo    and
          reservas.it-codigo    = input frame {&frame-name} aloca-reserva.it-codigo    and
          reservas.estado       = 1
          no-lock no-error.  
     if avail(reservas)
     then 
        assign fi-saldo-reserva = reservas.quant-orig 
                                - reservas.quant-atend
                                - reservas.quant-aloc.         
     else 
        assign fi-saldo-reserva = 0.

     if avail(ord-prod) then do:     
        find first saldo-estoq where 
                   saldo-estoq.cod-depos   = input frame {&frame-name} aloca-reserva.cod-depos   and
                   saldo-estoq.cod-estabel = ord-prod.cod-estabel                                and
                   saldo-estoq.cod-localiz = input frame {&frame-name} aloca-reserva.cod-localiz and
                   saldo-estoq.it-codigo   = input frame {&frame-name} aloca-reserva.it-codigo   and
                   saldo-estoq.lote        = input frame {&frame-name} aloca-reserva.lote-serie
                   no-lock no-error.
        if avail(saldo-estoq)
        then 
           assign fi-disponivel = saldo-estoq.qtidade-atu
                                - saldo-estoq.qt-alocada
                                - saldo-estoq.qt-aloc-prod
                                - saldo-estoq.qt-aloc-ped.
        else 
           assign fi-disponivel = 0.
     end.     
     else 
        assign fi-disponivel = 0.
      
     disp fi-disponivel 
          fi-saldo-reserva
          with frame {&frame-name}.   

     RUN pi-calcula-saldos.

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

  /* Code placed here will execute AFTER standard behavior.    */

&if '{&bf_lote_avancado_liberado}' = 'yes' &then
  if can-find(funcao where funcao.cd-funcao = "lote-avancado":u and
                           funcao.ativo) then do:
      assign l-lote-avancado = yes.

      if not valid-handle(h-ceapi030) then
          run cep/ceapi030.p persistent set h-ceapi030 (input table tt-dados-fda,
                                                        output table tt-valores,
                                                        output table tt-erro).
  end.
&endif

  &IF DEFINED(bf_man_205) &THEN
      find first param-global no-lock.
      if param-global.modulo-per-ppm then  
          run cpp/cpapi020.p persistent set h-cpapi020(INPUT-OUTPUT table tt-balanceia,
                                                       input-output table tt-erro,
                                                       INPUT        yes,
                                                       INPUT-OUTPUT TABLE tt-veiculos).
  &ENDIF

  {utp/ut-liter.i Qtde_Aloc *}
  ASSIGN fi-qt-aloc-lote:HIDDEN    IN FRAME f-main     = YES
         fi-per-ppm-item:HIDDEN    IN FRAME f-main     = YES
         fi-per-ppm-lote:HIDDEN    IN FRAME f-main     = YES
         label-concentracao:HIDDEN IN FRAME f-main     = YES
         fi-disponivel-teorica:HIDDEN IN FRAME f-main  = YES
         label-quant-aloc:HIDDEN IN FRAME f-main       = NO
         aloca-reserva.quant-aloc:COL IN FRAME f-main  = 36
         label-quant-aloc:COL IN FRAME f-main          = 28
         label-quant-aloc                              = RETURN-VALUE + ":":U
         l-per-ppm                                     = NO.

  DISPLAY label-quant-aloc WITH FRAME f-main.
  HIDE RECT-10 rect-11 IN FRAME f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-saldos V-table-Win 
PROCEDURE pi-calcula-saldos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  find reservas where 
       reservas.nr-ord-produ = input frame {&frame-name} aloca-reserva.nr-ord-produ and
       reservas.item-pai     = input frame {&frame-name} aloca-reserva.item-pai     and
       reservas.cod-roteiro  = input frame {&frame-name} aloca-reserva.cod-roteiro  and
       reservas.op-codigo    = input frame {&frame-name} aloca-reserva.op-codigo    and
       reservas.it-codigo    = input frame {&frame-name} aloca-reserva.it-codigo    and
       reservas.estado       = 1
       no-lock no-error.  
  if avail(reservas)
  then 
     assign fi-saldo-reserva = reservas.quant-orig 
                             - reservas.quant-atend
                             - reservas.quant-aloc.         
  else 
     assign fi-saldo-reserva = 0.

  find ord-prod where
       ord-prod.nr-ord-prod = input frame {&frame-name} aloca-reserva.nr-ord-produ
       no-lock no-error.
  if avail(ord-prod) then do:     
     find first saldo-estoq where 
                saldo-estoq.cod-depos   = input frame {&frame-name} aloca-reserva.cod-depos   and
                saldo-estoq.cod-estabel = ord-prod.cod-estabel                                and
                saldo-estoq.cod-localiz = input frame {&frame-name} aloca-reserva.cod-localiz and
                saldo-estoq.it-codigo   = input frame {&frame-name} aloca-reserva.it-codigo   and
                saldo-estoq.lote        = input frame {&frame-name} aloca-reserva.lote-serie
                no-lock no-error.
     if avail(saldo-estoq)
     then 
        assign fi-disponivel = saldo-estoq.qtidade-atu
                             - saldo-estoq.qt-alocada
                             - saldo-estoq.qt-aloc-prod
                             - saldo-estoq.qt-aloc-ped.
     else 
        assign fi-disponivel = 0.
  end.     
  else 
     assign fi-disponivel = 0.
      
  disp fi-disponivel 
       fi-saldo-reserva
       with frame {&frame-name}.

  HIDE RECT-10 rect-11 IN FRAME f-main.

  &IF DEFINED(bf_man_205) &THEN
      IF param-global.modulo-per-ppm THEN DO:
          IF NOT AVAIL ITEM OR ITEM.it-codigo <> aloca-reserva.it-codigo:SCREEN-VALUE IN FRAME f-main THEN
              FIND FIRST ITEM NO-LOCK
                   WHERE ITEM.it-codigo = aloca-reserva.it-codigo:SCREEN-VALUE IN FRAME f-main NO-ERROR.

          IF AVAIL ITEM AND
             ITEM.tipo-formula >= 2 AND
             ITEM.tipo-formula <= 3 THEN DO:

              DISPLAY RECT-10 rect-11 WITH FRAME f-main.

              {utp/ut-liter.i Qtde_Te¢rica *}
              ASSIGN label-quant-aloc = RETURN-VALUE + ":":U.
              {utp/ut-liter.i Qtde_F°sica *}
              ASSIGN fi-qt-aloc-lote:LABEL IN FRAME f-main = RETURN-VALUE.

              CASE ITEM.tipo-formula:
                  WHEN 2 THEN DO:
                      {utp/ut-liter.i Concentraá∆o_(%) *}
                  END.
                  WHEN 3 THEN DO:
                      {utp/ut-liter.i PPM *}
                  END.
              END CASE.

              ASSIGN label-concentracao = RETURN-VALUE
                     fi-per-ppm-item    = ITEM.per-ppm
                     fi-per-ppm-lote    = IF AVAIL saldo-estoq THEN saldo-estoq.per-ppm ELSE ?.

              DISPLAY label-concentracao
                      fi-per-ppm-item
                      fi-per-ppm-lote
                      fi-qt-aloc-lote
                      label-quant-aloc
                  WITH FRAME f-main.

              ASSIGN fi-qt-aloc-lote:SENSITIVE IN FRAME f-main     = IF AVAIL saldo-estoq THEN YES ELSE NO
                     fi-per-ppm-item:SENSITIVE IN FRAME f-main     = NO
                     fi-per-ppm-lote:SENSITIVE IN FRAME f-main     = NO
                     l-per-ppm                                     = YES
                     aloca-reserva.quant-aloc:COL IN FRAME f-main  = fi-qt-aloc-lote:COL IN FRAME f-main
                     aloca-reserva.quant-aloc:ROW IN FRAME f-main  = fi-per-ppm-item:ROW IN FRAME f-main
                     label-quant-aloc:COL IN FRAME f-main          = 13.5
                     label-quant-aloc:ROW IN FRAME f-main          = fi-per-ppm-item:ROW IN FRAME f-main.

              APPLY "leave":U TO aloca-reserva.quant-aloc IN FRAME f-main.

              {utp/ut-liter.i Qtde_Atual_F°sica *}
              ASSIGN fi-disponivel:LABEL IN FRAME f-main = RETURN-VALUE.

              IF NOT AVAIL saldo-estoq THEN
                  ASSIGN fi-disponivel-teorica = fi-disponivel.
              ELSE 
                  ASSIGN fi-disponivel-teorica = round((saldo-estoq.per-ppm / reservas.per-ppm) * fi-disponivel,4).

              DISPLAY fi-disponivel-teorica WITH FRAME f-main.
          END.
          ELSE DO:
              {utp/ut-liter.i Qtde_Aloc *}
              ASSIGN fi-qt-aloc-lote:HIDDEN    IN FRAME f-main       = YES
                     fi-per-ppm-item:HIDDEN    IN FRAME f-main       = YES
                     fi-per-ppm-lote:HIDDEN    IN FRAME f-main       = YES
                     fi-disponivel-teorica:HIDDEN    IN FRAME f-main = YES
                     label-concentracao:HIDDEN IN FRAME f-main       = YES
                     aloca-reserva.quant-aloc:COL IN FRAME f-main    = 36   
/*                      aloca-reserva.quant-aloc:ROW IN FRAME f-main    = 11.75 */
                     label-quant-aloc:COL IN FRAME f-main            = 28   
/*                      label-quant-aloc:ROW IN FRAME f-main            = 11.8 */
                     label-quant-aloc:SCREEN-VALUE IN FRAME f-main   = RETURN-VALUE + ":":U
                     l-per-ppm                                       = NO.
              {utp/ut-liter.i Dispon°vel *}
              ASSIGN fi-disponivel:LABEL IN FRAME f-main = RETURN-VALUE.

              HIDE RECT-10 rect-11 IN FRAME f-main.

              IF adm-new-record = NO AND AVAIL aloca-reserva AND aloca-reserva.qt-aloc-lote <> 0 THEN
                  DISPLAY aloca-reserva.qt-aloc-lote @ aloca-reserva.quant-aloc WITH FRAME f-main.
          END.
      END.
      ELSE
          ASSIGN l-per-ppm = NO.
  &ENDIF /*&IF DEFINED(bf_man_205)*/

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
  {src/adm/template/snd-list.i "aloca-reserva"}

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

