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
**********************************************************************************/
{include/i-prgvrs.i V30IN090 2.00.00.018 } /*** "010018" 23/06/2026 10:07:31 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v30in090 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
{cdp/cdcfgmat.i}
{rep/re0701.i}       /* pi-passa-handle */
{rep/re9800.i}       /* seta flags observaá∆o */
{cdp/cd4300.i3}      /* Variaveis para CD4300.I4 */
{cdp/cd0604.i50}     /* Variaveis para CD0604 */
{cdp/cdcfgdis.i}     /* pre-processadores */
{cdp/cd0620.i1 "''"} /* Retorna data CFOP */

def var de-base-iss         like docum-est.base-iss.
def var de-icm-complem      like item-doc-est.icm-complem extent 0.
def var de-base-subs        like item-doc-est.base-subs   extent 0.
def var de-vl-subs          like item-doc-est.vl-subs     extent 0.
def var de-valor-iss        like item-doc-est.valor-iss   extent 0.
def var de-icm-fonte        like docum-est.icm-fonte.                     
def var de-ipi-outras       like item-doc-est.ipi-outras  extent 0.
def var de-vl-subs-it       like item-doc-est.vl-subs     extent 0.
def new global shared var l-re1001a-inclui as logical no-undo.

def var de-base-icm-it              as decimal no-undo init 0.
def var de-base-ipi-it              as decimal no-undo init 0.
def var de-despesa-nota-it          as decimal no-undo init 0.
def var de-icm-deb-cre-it           as decimal no-undo init 0.
def var de-ipi-deb-cre-it           as decimal no-undo init 0.
def var de-tot-desconto-it          as decimal no-undo init 0.
def var de-tot-peso-it              as decimal no-undo init 0.
def var de-valor-mercad-it          as decimal no-undo init 0.
DEF VAR de-peso-embal               AS DECIMAL NO-UNDO INIT 0.
def var de-bicms-compl              as decimal no-undo init 0.
def var h-boin01016                 as handle no-undo.

DEFINE TEMP-TABLE tt-ext-docum-est NO-UNDO LIKE ext-docum-est
       FIELD r-Rowid AS ROWID.

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.tot-peso docum-est.tot-desconto ~
docum-est.despesa-nota docum-est.valor-mercad docum-est.base-ipi ~
docum-est.ipi-deb-cre docum-est.base-icm docum-est.icm-deb-cre ~
docum-est.tot-valor
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-key rt-button FILL-IN-1 fi-tot-nota ~
fi-tot-itens fi-diferenca 
&Scoped-Define DISPLAYED-FIELDS docum-est.tot-peso docum-est.tot-desconto ~
docum-est.despesa-nota docum-est.valor-mercad docum-est.base-ipi ~
docum-est.ipi-deb-cre docum-est.base-icm docum-est.icm-deb-cre ~
docum-est.tot-valor docum-est.valor-tot-nf-rt
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-tot-peso-it fi-tot-peso-dif ~
de-peso-bruto-tot de-tot-peso-bruto-it de-tot-peso-bruto-dif ~
fi-tot-desconto-it fi-tot-desconto-dif fi-despesa-nota-it ~
fi-despesa-nota-dif fi-valor-mercad-it fi-valor-mercad-dif fi-base-ipi-it ~
fi-base-ipi-dif fi-ipi-deb-cre-it fi-ipi-deb-cre-dif fi-base-icm-it ~
fi-base-icm-dif fi-icm-deb-cre-it fi-icm-deb-cre-dif fi-base-fcp ~
fi-base-fcp-it fi-base-fcp-dif fi-valor-fcp fi-valor-fcp-it ~
fi-valor-fcp-dif FILL-IN-1 fi-tot-nota fi-tot-itens fi-diferenca 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS fi-base-ipi-it fi-base-ipi-dif ~
fi-ipi-deb-cre-it fi-ipi-deb-cre-dif fi-base-icm-it fi-base-icm-dif ~
fi-icm-deb-cre-it fi-icm-deb-cre-dif fi-base-fcp fi-base-fcp-it ~
fi-base-fcp-dif fi-valor-fcp fi-valor-fcp-it fi-valor-fcp-dif 

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
DEFINE VARIABLE de-peso-bruto-tot AS DECIMAL FORMAT ">,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Peso Bruto Total" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-peso-bruto-dif AS DECIMAL FORMAT "->>,>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-peso-bruto-it AS DECIMAL FORMAT "->,>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-fcp AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Base FCP" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-fcp-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-fcp-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-icm-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-icm-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-ipi-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-base-ipi-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-despesa-nota-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-despesa-nota-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-diferenca AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-icm-deb-cre-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-icm-deb-cre-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-ipi-deb-cre-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-ipi-deb-cre-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-desconto-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-desconto-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-itens AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 23.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-nota AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-peso-dif AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-tot-peso-it AS DECIMAL FORMAT "->>>>,>>>,>>9.9999" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-fcp AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Valor FCP" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-fcp-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-fcp-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-mercad-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE fi-valor-mercad-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61.72 BY 1
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 13.54.

DEFINE RECTANGLE rt-totais
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 72.5 BY 1.2.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.tot-peso AT ROW 2.46 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-tot-peso-it AT ROW 2.46 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-tot-peso-dif AT ROW 2.46 COL 63 COLON-ALIGNED NO-LABEL
     de-peso-bruto-tot AT ROW 3.42 COL 21 COLON-ALIGNED
     de-tot-peso-bruto-it AT ROW 3.42 COL 41.86 COLON-ALIGNED NO-LABEL
     de-tot-peso-bruto-dif AT ROW 3.42 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.tot-desconto AT ROW 4.38 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-tot-desconto-it AT ROW 4.38 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-tot-desconto-dif AT ROW 4.38 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.despesa-nota AT ROW 5.33 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-despesa-nota-it AT ROW 5.33 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-despesa-nota-dif AT ROW 5.33 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.valor-mercad AT ROW 6.29 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-valor-mercad-it AT ROW 6.29 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-valor-mercad-dif AT ROW 6.29 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.base-ipi AT ROW 7.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-base-ipi-it AT ROW 7.25 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-base-ipi-dif AT ROW 7.25 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.ipi-deb-cre AT ROW 8.21 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-ipi-deb-cre-it AT ROW 8.21 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-ipi-deb-cre-dif AT ROW 8.21 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.base-icm AT ROW 9.17 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-base-icm-it AT ROW 9.17 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-base-icm-dif AT ROW 9.17 COL 63 COLON-ALIGNED NO-LABEL
     docum-est.icm-deb-cre AT ROW 10.13 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-icm-deb-cre-it AT ROW 10.13 COL 41.86 COLON-ALIGNED NO-LABEL
     fi-icm-deb-cre-dif AT ROW 10.13 COL 63 COLON-ALIGNED NO-LABEL
     fi-base-fcp AT ROW 11.08 COL 21 COLON-ALIGNED WIDGET-ID 10
     fi-base-fcp-it AT ROW 11.08 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     fi-base-fcp-dif AT ROW 11.08 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-valor-fcp AT ROW 12.04 COL 21 COLON-ALIGNED WIDGET-ID 12
     fi-valor-fcp-it AT ROW 12.04 COL 41.86 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fi-valor-fcp-dif AT ROW 12.04 COL 63 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     docum-est.tot-valor AT ROW 13.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     docum-est.valor-tot-nf-rt AT ROW 13.25 col 59 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22.86 BY .88
     FILL-IN-1 AT ROW 1.33 COL 21 COLON-ALIGNED NO-LABEL
     fi-tot-nota AT ROW 1.33 COL 47.43 RIGHT-ALIGNED NO-LABEL
     fi-tot-itens AT ROW 1.33 COL 44.14 COLON-ALIGNED NO-LABEL
     fi-diferenca AT ROW 1.33 COL 66.86 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-button AT ROW 1.25 COL 22.72
     rt-totais AT ROW 13.1 COL 12
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 13.46
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

/* SETTINGS FOR FILL-IN fi-base-fcp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-base-fcp-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-base-fcp-it IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-base-icm-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-base-icm-it IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-base-ipi-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-base-ipi-it IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-despesa-nota-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-despesa-nota-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-icm-deb-cre-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-icm-deb-cre-it IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-ipi-deb-cre-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-ipi-deb-cre-it IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-tot-desconto-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-desconto-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-nota IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-tot-peso-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-peso-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-fcp IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-valor-fcp-dif IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-valor-fcp-it IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-valor-mercad-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-valor-mercad-it IN FRAME f-main
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

&Scoped-define SELF-NAME docum-est.base-icm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.base-icm V-table-Win
ON LEAVE OF docum-est.base-icm IN FRAME f-main /* Base C†lculo ICMS */
DO:
    assign  fi-base-icm-dif:screen-value     = string(input docum-est.base-icm      -
                                                      input fi-base-icm-it).
    assign fi-base-icm-dif:fgcolor =
        if input frame {&frame-name} fi-base-icm-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.base-ipi
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.base-ipi V-table-Win
ON LEAVE OF docum-est.base-ipi IN FRAME f-main /* Base C†lculo IPI */
DO:
    assign  fi-base-ipi-dif:screen-value     = string(input docum-est.base-ipi      -
                                                      input fi-base-ipi-it).
    assign fi-base-ipi-dif:fgcolor =
        if input frame {&frame-name} fi-base-ipi-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.despesa-nota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.despesa-nota V-table-Win
ON LEAVE OF docum-est.despesa-nota IN FRAME f-main /* Despesas Nota */
DO:
    assign  fi-despesa-nota-dif:screen-value = string(input docum-est.despesa-nota  -
                                                      input fi-despesa-nota-it).
    assign fi-despesa-nota-dif:fgcolor =
        if input frame {&frame-name} fi-despesa-nota-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-icm-deb-cre-dif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-icm-deb-cre-dif V-table-Win
ON LEAVE OF fi-icm-deb-cre-dif IN FRAME f-main
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-icm-deb-cre-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-icm-deb-cre-it V-table-Win
ON LEAVE OF fi-icm-deb-cre-it IN FRAME f-main
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ipi-deb-cre-dif
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ipi-deb-cre-dif V-table-Win
ON LEAVE OF fi-ipi-deb-cre-dif IN FRAME f-main
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ipi-deb-cre-it
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ipi-deb-cre-it V-table-Win
ON LEAVE OF fi-ipi-deb-cre-it IN FRAME f-main
DO:
    find first param-global no-lock no-error.
    find empresa where
         empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
    find first param-fasb where
         param-fasb.ep-codigo = empresa.ep-codigo no-lock no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.icm-deb-cre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.icm-deb-cre V-table-Win
ON LEAVE OF docum-est.icm-deb-cre IN FRAME f-main /* Valor ICMS */
DO:
    assign  fi-icm-deb-cre-dif:screen-value  = string(input docum-est.icm-deb-cre   -
                                                      input fi-icm-deb-cre-it).
    assign fi-icm-deb-cre-dif:fgcolor =
        if input frame {&frame-name} fi-icm-deb-cre-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.ipi-deb-cre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.ipi-deb-cre V-table-Win
ON LEAVE OF docum-est.ipi-deb-cre IN FRAME f-main /* Valor IPI */
DO:
    assign  fi-ipi-deb-cre-dif:screen-value  = string(input docum-est.ipi-deb-cre   -
                                                      input fi-ipi-deb-cre-it).
    assign fi-ipi-deb-cre-dif:fgcolor =
        if input frame {&frame-name} fi-ipi-deb-cre-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.tot-desconto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.tot-desconto V-table-Win
ON LEAVE OF docum-est.tot-desconto IN FRAME f-main /* Total Descto */
DO:
    assign  fi-tot-desconto-dif:screen-value = string(input docum-est.tot-desconto  - 
                                                      input fi-tot-desconto-it)      .
    assign fi-tot-desconto-dif:fgcolor =
        if input frame {&frame-name} fi-tot-desconto-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.tot-peso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.tot-peso V-table-Win
ON LEAVE OF docum-est.tot-peso IN FRAME f-main /* Peso Total */
DO:
    IF  l-transf
    AND CAN-FIND(FIRST doc-orig-nfe 
                 WHERE doc-orig-nfe.ch-acesso-comp-nfe = docum-est.cod-chave-aces-nf-eletro
                   AND doc-orig-nfe.idi-orig-trad      = 2
                   AND doc-orig-nfe.idi-situacao       = 3) /* Atualizada Recebimento Fiscal */  THEN
        assign fi-tot-peso-dif:screen-value     = string(input docum-est.tot-peso - input docum-est.tot-peso).
    ELSE
        assign fi-tot-peso-dif:screen-value     = string(input docum-est.tot-peso - input fi-tot-peso-it).

    assign fi-tot-peso-dif:fgcolor =
        if input frame {&frame-name} fi-tot-peso-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.valor-mercad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.valor-mercad V-table-Win
ON LEAVE OF docum-est.valor-mercad IN FRAME f-main /* Valor Total Merc */
DO:
    assign  fi-valor-mercad-dif:screen-value = string(input docum-est.valor-mercad  -
                                                      input fi-valor-mercad-it).
    assign fi-valor-mercad-dif:fgcolor =
        if input frame {&frame-name} fi-valor-mercad-dif <> 0 then 12 else ?.
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

  find param-re where param-re.usuario = c-seg-usuario
        no-lock no-error.
  find first param-global no-lock no-error.
  find first param-fasb
       where param-fasb.ep-codigo = param-global.empresa-prin no-lock no-error.

  {utp/ut-liter.i Peso_L°quido_Total MRE L}  
  ASSIGN docum-est.tot-peso:LABEL IN FRAME {&FRAME-NAME}  = RETURN-VALUE.

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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_÷tens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferenáa MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  if l-re1001a-inclui then 
    RUN pi-atualiza-totais. /*se for inclus∆o, os campos despesa-nota,tot-desconto,
                              valor-mercad,tot-peso ser∆o atualizados a partir dos
                              valores informados na viewer v16in090.w */
if l-re1001a-inclui = no then do with frame {&FRAME-NAME}:

    /* Diferenca no Peso Total */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-tot-peso-it,
                      input input docum-est.tot-peso,
                      input 5501,
                      input input fi-tot-peso-dif = 0, /*ser for igual elimina sen∆o cria*/
                      input 0,       /*Zero para erros do documento*/
                      input 1).

    /* Diferenca no Total de Desconto */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-tot-desconto-it,
                      input input docum-est.tot-desconto,
                      input 5511,
                      input input fi-tot-desconto-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input 1).                            /*erro*/       


    /* Diferenca no Total das Despesas */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-despesa-nota-it,
                      input input docum-est.despesa-nota,
                      input 5500,
                      input input fi-despesa-nota-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input 1).                            /*erro*/       


    /* Diferenca no valor das Mercadorias */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-valor-mercad-it,
                      input input docum-est.valor-mercad,
                      input 5502,
                      input input fi-valor-mercad-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input 1).                            /*erro*/       




    /* Diferenca na base de IPI */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-base-ipi-it,
                      input input docum-est.base-ipi,
                      input 5506,
                      input input fi-base-ipi-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-base-ipi-dif) > param-re.dec-1 /*diferenáa maior que parÉmetro */
                                then 1 else 2).                       /*entao erro senao advertencia*/       

      
    /* Diferenca no valor de IPI */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-ipi-deb-cre-it,
                      input input docum-est.ipi-deb-cre,
                      input 5507,
                      input input fi-ipi-deb-cre-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-ipi-deb-cre-dif) > param-re.dec-1 /*diferenáa maior que parÉmetro */
                                then 1 else 2).                          /*entao erro senao advertencia*/       



    /* Diferenca na base de ICM */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-base-icm-it,
                      input input docum-est.base-icm,
                      input 5508,
                      input input fi-base-icm-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-base-icm-dif) > param-re.dec-1 /*diferenáa maior que parÉmetro */
                                then 1 else 2).                       /*entao erro senao advertencia*/       


    /* Diferenca no valor de ICM */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-icm-deb-cre-it,
                      input input docum-est.icm-deb-cre,
                      input 5509,
                      input input fi-icm-deb-cre-dif = 0, /*ser for igual a zero elimina sen∆o cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-icm-deb-cre-dif) > param-re.dec-1 /*diferenáa maior que parÉmetro */
                                then 1 else 2).                       /*entao erro senao advertencia*/       




end.

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

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_÷tens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferenáa MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

      
assign de-base-icm-it      = 0
       de-base-ipi-it      = 0
       de-despesa-nota-it  = 0
       de-icm-deb-cre-it   = 0        
       de-ipi-deb-cre-it   = 0            
       de-tot-desconto-it  = 0             
       de-tot-peso-it      = 0             
       de-valor-mercad-it  = 0 .
      
 
if avail docum-est then do with frame {&FRAME-NAME}:
    assign    fi-base-icm-it:screen-value       = string(de-base-icm-it)
              fi-base-ipi-it:screen-value       = string(de-base-ipi-it)
              fi-despesa-nota-it:screen-value   = string(de-despesa-nota-it)
              fi-icm-deb-cre-it:screen-value    = string(de-icm-deb-cre-it)          
              fi-ipi-deb-cre-it:screen-value    = string(de-ipi-deb-cre-it)              
              fi-tot-desconto-it:screen-value   = string(de-tot-desconto-it)              
              fi-tot-peso-it:screen-value       = string(de-tot-peso-it)                  
              fi-valor-mercad-it:screen-value   = string(de-valor-mercad-it)
              de-tot-peso-bruto-it:SCREEN-VALUE = "0".              

    &if "{&bf_dis_versao_ems}" >= "2.062" &then
        ASSIGN de-peso-bruto-tot:screen-value   = STRING(docum-est.peso-bruto-tot).
    &ELSE
        ASSIGN de-peso-bruto-tot:screen-value   = SUBSTRING(docum-est.char-1,157,17).
    &ENDIF
    
    IF NOT VALID-HANDLE(h-boin01016) THEN
       RUN inbo/boin01016.p PERSISTENT SET h-boin01016.
    RUN openQueryStatic IN h-boin01016 (INPUT "Main":U) NO-ERROR.
  
    /*FCP*/
    RUN goToKey IN h-boin01016 (INPUT docum-est.serie-docto, 
                                INPUT docum-est.nro-docto,   
                                INPUT docum-est.cod-emitente,
                                INPUT docum-est.nat-operacao,
                                INPUT "fcp":U). 
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN getRecord IN h-boin01016 (OUTPUT TABLE tt-ext-docum-est).
  
        FIND FIRST tt-ext-docum-est NO-LOCK
             WHERE tt-ext-docum-est.serie-docto  = docum-est.serie-docto
               AND tt-ext-docum-est.nro-docto    = docum-est.nro-docto
               AND tt-ext-docum-est.cod-emitente = docum-est.cod-emitente
               AND tt-ext-docum-est.nat-operacao = docum-est.nat-operacao
               AND tt-ext-docum-est.cod-param    = "fcp":U NO-ERROR.
        IF AVAIL tt-ext-docum-est THEN
            ASSIGN fi-base-fcp:SCREEN-VALUE IN FRAME {&frame-name}     = STRING(tt-ext-docum-est.val-livre-1)
                   fi-base-fcp-it:SCREEN-VALUE IN FRAME {&frame-name}  = STRING(tt-ext-docum-est.val-livre-1)
                   fi-base-fcp-dif:SCREEN-VALUE IN FRAME {&frame-name} = STRING(0)
                   fi-valor-fcp:SCREEN-VALUE IN FRAME {&frame-name}     = STRING(tt-ext-docum-est.val-livre-3)
                   fi-valor-fcp-it:SCREEN-VALUE IN FRAME {&frame-name}  = STRING(tt-ext-docum-est.val-livre-3)
                   fi-valor-fcp-dif:SCREEN-VALUE IN FRAME {&frame-name} = STRING(0).
    END.
    /*FCP*/
  
    IF  VALID-HANDLE(h-boin01016) THEN DO:
        DELETE PROCEDURE h-boin01016.
        ASSIGN h-boin01016 = ?.
    END.

    run pi-total-item (input rowid(docum-est)).
    RUN pi-calculo-diferenca.              
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
  
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

do with frame {&FRAME-NAME}:
    assign     docum-est.tot-peso:sensitive        = no
               docum-est.tot-desconto:sensitive    = no
               docum-est.despesa-nota:sensitive    = no
               docum-est.valor-mercad:sensitive    = no
               docum-est.base-ipi:sensitive        = no
               docum-est.ipi-deb-cre:sensitive     = no
               docum-est.base-icm:sensitive        = no
               docum-est.icm-deb-cre:sensitive     = no
               docum-est.tot-valor:sensitive       = no
               docum-est.valor-tot-nf-rt:sensitive = no.
end.               
if l-re1001a-inclui = no and avail docum-est then 
    run pi-habilita-campos.

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
  
   if not can-find(first funcao
                   where funcao.cd-funcao = "spp-NT2024002") or
      can-find(first funcao
               where funcao.cd-funcao = "spp-NT2024002"
                 and not funcao.ativo) then 
      assign docum-est.valor-tot-nf-rt:hidden in frame {&frame-name} = yes.

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_÷tens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferenáa MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-docto V-table-Win 
PROCEDURE pi-atualiza-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/* Atualiza valores no documento */
do with frame {&FRAME-NAME}:
    if  input docum-est.tot-peso      = 0 then 
        assign docum-est.tot-peso:screen-value = fi-tot-peso-it:screen-value.
    if  input docum-est.tot-desconto  = 0 then 
        assign docum-est.tot-desconto:screen-value  = fi-tot-desconto-it:screen-value .
    if  input docum-est.despesa-nota  = 0 then 
        assign docum-est.despesa-nota:screen-value    = fi-despesa-nota-it:screen-value .
    if  input docum-est.valor-mercad  = 0 then 
        assign docum-est.valor-mercad:screen-value    = fi-valor-mercad-it:screen-value .

    assign docum-est.base-ipi:screen-value        = fi-base-ipi-it:screen-value
           docum-est.ipi-deb-cre:screen-value     = fi-ipi-deb-cre-it:screen-value
           docum-est.base-icm:screen-value        = fi-base-icm-it:screen-value
           docum-est.icm-deb-cre:screen-value     = fi-icm-deb-cre-it:screen-value.

    assign de-icm-fonte = 0.
    if can-do("16,26",substring(natur-oper.nat-operacao,1,2)) and natur-oper.subs-trib then do:
        assign de-icm-fonte = input frame {&FRAME-NAME} fi-icm-deb-cre-it.
    
        /* Calculo do credito presumido*/
        {rep/re1001.i06 de-icm-fonte}
    end.

    run pi-atualiza-docto in h_v29in090 (input de-icm-fonte).
    
end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-totais V-table-Win 
PROCEDURE pi-atualiza-totais :
/*------------------------------------------------------------------------------
  Purpose:      
  Parameters:  <none>
  Notes: Esta Rotina Ç utilizada, pois as viewers v16in090.w e v30in090.w tem 
         definidos os mesmos campos (despesa-nota,tot-desconto,valor-mercad,
         tot-peso). Ent∆o quando for inclus∆o ser∆o gravados os campos da viewer
         v16in090.w. 
         Quando for alteraá∆o ser∆o gravados os campos da viewer v30in090.w e os 
         campos da outra viewer ficar∆o escondidos(hide).
------------------------------------------------------------------------------*/

RUN pi-retorna-totais IN h_v28in090
  (output table tt-inicializa).

find first tt-inicializa no-error.
assign
    docum-est.despesa-nota  = tt-inicializa.despesa-nota
    docum-est.tot-peso      = tt-inicializa.tot-peso
    docum-est.tot-desconto  = tt-inicializa.tot-desconto
    docum-est.valor-mercad  = tt-inicializa.valor-mercad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calculo-diferenca V-table-Win 
PROCEDURE pi-calculo-diferenca :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Calculo da Diferenca */
do with frame {&FRAME-NAME}:
    
    assign  fi-tot-peso-dif:screen-value       = IF  l-transf
                                                 AND CAN-FIND(FIRST doc-orig-nfe 
                                                              WHERE doc-orig-nfe.ch-acesso-comp-nfe = docum-est.cod-chave-aces-nf-eletro
                                                                AND doc-orig-nfe.idi-orig-trad      = 2
                                                                AND doc-orig-nfe.idi-situacao       = 3) /* Atualizada Recebimento Fiscal */ THEN
                                                      string(input docum-est.tot-peso - input docum-est.tot-peso) 
                                                 ELSE string(input docum-est.tot-peso - input fi-tot-peso-it)
            de-tot-peso-bruto-dif:SCREEN-VALUE = string(input docum-est.tot-peso      - 
                                                        input fi-tot-peso-it) 
            fi-tot-desconto-dif:screen-value   = string(input docum-est.tot-desconto  - 
                                                      input fi-tot-desconto-it)      
            fi-despesa-nota-dif:screen-value   = string(input docum-est.despesa-nota  -
                                                      input fi-despesa-nota-it)
            fi-valor-mercad-dif:screen-value   = string(input docum-est.valor-mercad  -
                                                      input fi-valor-mercad-it)
            fi-base-ipi-dif:screen-value       = string(input docum-est.base-ipi      -
                                                      input fi-base-ipi-it)
            fi-ipi-deb-cre-dif:screen-value    = string(input docum-est.ipi-deb-cre   -
                                                      input fi-ipi-deb-cre-it)
            fi-base-icm-dif:screen-value       = string(input docum-est.base-icm      -
                                                      input fi-base-icm-it)
            fi-icm-deb-cre-dif:screen-value    = string(input docum-est.icm-deb-cre   -
                                                      input fi-icm-deb-cre-it).
    assign fi-tot-peso-dif:fgcolor =
        if input frame {&frame-name} fi-tot-peso-dif <> 0 then 12 else ?
           de-tot-peso-bruto-dif:fgcolor =
        if input frame {&frame-name} de-tot-peso-bruto-dif <> 0 then 12 else ?   
           fi-tot-desconto-dif:fgcolor =
        if input frame {&frame-name} fi-tot-desconto-dif <> 0 then 12 else ?
           fi-despesa-nota-dif:fgcolor =
        if input frame {&frame-name} fi-despesa-nota-dif <> 0 then 12 else ?
           fi-valor-mercad-dif:fgcolor =
        if input frame {&frame-name} fi-valor-mercad-dif <> 0 then 12 else ?
           fi-base-ipi-dif:fgcolor =
        if input frame {&frame-name} fi-base-ipi-dif <> 0 then 12 else ?
           fi-ipi-deb-cre-dif:fgcolor =
        if input frame {&frame-name} fi-ipi-deb-cre-dif <> 0 then 12 else ?
           fi-base-icm-dif:fgcolor =
        if input frame {&frame-name} fi-base-icm-dif <> 0 then 12 else ?
           fi-icm-deb-cre-dif:fgcolor =
        if input frame {&frame-name} fi-icm-deb-cre-dif <> 0 then 12 else ?.
    if  (valid-handle(h_v29in090)) then 
        run pi-calculo-diferenca in h_v29in090.        
end.            

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-docto V-table-Win 
PROCEDURE pi-consiste-docto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&FRAME-NAME}:
    assign     docum-est.tot-peso:sensitive       = yes 
               docum-est.tot-desconto:sensitive   = yes
               docum-est.valor-mercad:sensitive   = yes
               docum-est.base-ipi:sensitive       = (param-re.ped-imp-nota)
               docum-est.ipi-deb-cre:sensitive    = (param-re.ped-imp-nota)
               docum-est.base-icm:sensitive       = (param-re.ped-imp-nota)
               docum-est.icm-deb-cre:sensitive    = (param-re.ped-imp-nota)
               docum-est.tot-valor:sensitive      = yes.
end.               

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param table for tt-inicializa.

find first tt-inicializa no-error.


if tt-inicializa.despesa-nota <> ? then do with frame {&FRAME-NAME}:
    assign docum-est.despesa-nota:screen-value = string(tt-inicializa.despesa-nota).
    apply 'leave'  to docum-est.despesa-nota.
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-totais V-table-Win 
PROCEDURE pi-retorna-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param table for tt-inicializa.

run pi-recria-tt-inicializa.
assign tt-inicializa.despesa-nota = input frame {&FRAME-NAME} docum-est.despesa-nota
       tt-inicializa.tot-peso     = input frame {&FRAME-NAME} docum-est.tot-peso   
       tt-inicializa.tot-desconto  = input frame {&FRAME-NAME} docum-est.tot-desconto     
       tt-inicializa.valor-mercad = input frame {&FRAME-NAME} docum-est.valor-mercad.
            
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-total-item V-table-Win 
PROCEDURE pi-total-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param rw-docum-est as rowid no-undo.

DEF VAR de-valor-desc-icms AS DEC NO-UNDO.

/* Totalizacao dos Itens */
find docum-est where rowid(docum-est) = rw-docum-est
     no-lock no-error.

find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao
     no-lock no-error.      
run pi-seta-flags-observacao in this-procedure    /* criada no re9800.i */
        (input docum-est.cod-observa, input docum-est.nat-operacao).    

IF AVAIL natur-oper THEN DO:
    {cdp/cd4300.i4  yes natur-oper.char-2}
    {cdp/cd0604.i51 yes}
END.

do with frame {&FRAME-NAME}:
    assign de-base-icm-it     = 0
           de-base-ipi-it     = 0
           de-base-iss        = 0
           de-ipi-outras      = 0
           de-peso-embal      = 0
           de-bicms-compl     = 0
           de-valor-desc-icms = 0.
    

    for each item-doc-est {cdp/cd8900.i item-doc-est docum-est}
         no-lock:




          accum item-doc-est.peso-liquido       (total).
          accum item-doc-est.desconto[1]        (total).
          accum item-doc-est.despesas[1]        (total).
          accum item-doc-est.preco-total[1]     (total).
          accum item-doc-est.valor-ipi[1]       (total).
          accum item-doc-est.valor-icm[1]       (total).

          accum item-doc-est.icm-complem[1]     (total).
          accum item-doc-est.base-subs[1]       (total).
          accum item-doc-est.vl-subs[1]         (total).
          accum item-doc-est.valor-iss[1]       (total).

          assign de-base-icm-it  =   de-base-icm-it 
                                 +  (item-doc-est.base-icm[1] 
                                 *  int(((item-doc-est.cd-trib-icm = 1 /*T*/)   or
                                         (item-doc-est.cd-trib-icm = 4 /*R*/)   or
                                         (item-doc-est.cd-trib-icm = 5 /*D*/)))   
                                     /**** int(can-do(1,4,9 /*"T,R,D"*/, item-doc-est.cd-trib-icm)) ***/
                                 +  (item-doc-est.icm-outras[1]
                                 *  int(item-doc-est.cd-trib-icm = 3 /*"O"*/)))

                 de-base-ipi-it  =  de-base-ipi-it
                                 +  (item-doc-est.base-ipi[1] 
                                 *  int(((item-doc-est.cd-trib-ipi = 1 /*T*/)   or
                                         (item-doc-est.cd-trib-ipi = 4 /*R*/)))
                                     /**** int(can-do("T,R", item-doc-est.cd-trib-ipi)))****/
                                 +  (item-doc-est.ipi-outras[1]
                                 *  int(item-doc-est.cd-trib-ipi = 3 /*O*/ or 
                                       (item-doc-est.cd-trib-ipi = 1 /*T*/ and 
                                        item-doc-est.aliquota-ipi = 0 ) )))
                 
                 de-base-iss     =  de-base-iss
                                 +  item-doc-est.base-iss[1]
                                 *  int(((item-doc-est.cd-trib-iss = 1 /*T*/)   or
                                     (item-doc-est.cd-trib-iss = 4 /*R*/)))
                                     /**** int(can-do("T,R", item-doc-est.cd-trib-iss))****/
                                 +  item-doc-est.iss-outras[1]
                                 *  int(item-doc-est.cd-trib-iss = 3 /*"O"*/)

                 de-ipi-outras   =  de-ipi-outras
                                 +  item-doc-est.valor-ipi[1]
                                 *  int(item-doc-est.cd-trib-ipi = 3 /*"O"*/)

                 de-bicms-compl  = de-bicms-compl 
                                 + DECIMAL(TRIM(SUBSTRING(item-doc-est.char-2,860,20))). 

        /***ICMS Desonerado***/
        FOR FIRST ext-item-doc-est NO-LOCK
            WHERE ext-item-doc-est.serie-docto  = item-doc-est.serie-docto 
              AND ext-item-doc-est.nro-docto    = item-doc-est.nro-docto   
              AND ext-item-doc-est.cod-emitente = item-doc-est.cod-emitente
              AND ext-item-doc-est.nat-operacao = item-doc-est.nat-operacao
              AND ext-item-doc-est.sequencia    = item-doc-est.sequencia
              AND ext-item-doc-est.cod-param    = "icms-deson":U
              AND ext-item-doc-est.log-livre-1  = yes: /*aplica como desconto*/
            ASSIGN de-valor-desc-icms = de-valor-desc-icms + ext-item-doc-est.val-livre-2. /*valor desconto icms*/
        END.
        /********************/

        FIND FIRST docto-estoq-embal NO-LOCK
             WHERE docto-estoq-embal.cod-ser-docto    = docum-est.serie-docto   
             AND   docto-estoq-embal.cod-docto        = docum-est.nro-docto     
             AND   docto-estoq-embal.cdn-emitente     = docum-est.cod-emitente  
             AND   docto-estoq-embal.cod-natur-operac = docum-est.nat-operacao   NO-ERROR.
        IF AVAIL docto-estoq-embal THEN
           ASSIGN de-peso-embal = de-peso-embal + docto-estoq-embal.val-peso-embal.

        ASSIGN fi-tot-peso-it:screen-value       = string(accum total item-doc-est.peso-liquido)
               de-tot-peso-bruto-it:SCREEN-VALUE = STRING(de-peso-embal + accum total item-doc-est.peso-liquido)
               fi-tot-desconto-it:screen-value   = string(accum total item-doc-est.desconto[1])
               fi-despesa-nota-it:screen-value   = string(accum total item-doc-est.despesas[1])
               fi-valor-mercad-it:screen-value   = string((accum total item-doc-est.preco-total[1]) - de-valor-desc-icms)
               fi-ipi-deb-cre-it:screen-value    = string(accum total item-doc-est.valor-ipi[1])
               fi-icm-deb-cre-it:screen-value    = string(accum total item-doc-est.valor-icm[1])
               de-icm-complem                    = accum total item-doc-est.icm-complem[1]
               de-base-subs                      = accum total item-doc-est.base-subs[1]
               de-vl-subs                        = accum total item-doc-est.vl-subs[1]
               de-valor-iss                      = accum total item-doc-est.valor-iss[1]
               fi-base-icm-it:screen-value       = string(de-base-icm-it)
               fi-base-ipi-it:screen-value       = string(de-base-ipi-it)
               de-despesa-nota-it                = accum total item-doc-est.despesas[1]
               de-icm-deb-cre-it                 = accum total item-doc-est.valor-icm[1]
               de-ipi-deb-cre-it                 = accum total item-doc-est.valor-ipi[1]
               de-tot-desconto-it                = accum total item-doc-est.desconto[1]
               de-tot-peso-it                    = accum total item-doc-est.peso-liquido
               de-valor-mercad-it                = accum total item-doc-est.preco-total[1].

    end.
end.

if valid-handle (h_v29in090) then
run pi-total-item in h_v29in090 (input de-icm-complem,
                                 input de-base-subs,
                                 input de-vl-subs,                       
                                 input de-base-iss,
                                 input de-valor-iss,
                                 INPUT de-bicms-compl).


if avail param-fasb and ((input fi-ipi-deb-cre-it <> 0 or 
                          input fi-icm-deb-cre-it <> 0 or
                          de-valor-iss <> 0) or l-retorno) then do:

end.                                          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-total-nota V-table-Win 
PROCEDURE pi-total-nota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var de-tot-valor like docum-est.tot-valor.

/* Calcula total da nota */
run pi-busca-totais in h_v29in090 (output de-icm-fonte,
                                   output de-vl-subs-it).
do with frame {&FRAME-NAME}:
    assign de-tot-valor  = input fi-valor-mercad-it
                         + input fi-despesa-nota-it
                         - input fi-tot-desconto-it
                         + de-vl-subs-it.

    if  l-industria or l-devolucao then do:

        /* IPI Tributado */
        assign de-tot-valor = de-tot-valor
                           + (input fi-ipi-deb-cre-it - de-ipi-outras).

        /* IPI Outros */        
        assign de-tot-valor = de-tot-valor
                            + de-ipi-outras
                            * int(    l-ipi-tot-nota         or
                                 (not natur-oper.terceiros   and
                                  not natur-oper.transf)).
    end.
    /*  SUBSTITUICAO TRIBUTARIA DO FRETE */
    if  can-do("16,26",substring(natur-oper.nat-operacao,1,2)) then do:
        if  natur-oper.usa-nota-ent then 
            assign de-tot-valor = de-tot-valor - de-icm-fonte.
    end.
    if  de-tot-valor < 0 then 
        assign docum-est.tot-valor:screen-value = "0".
    else 
        assign docum-est.tot-valor:screen-value = string(de-tot-valor).
    
end.

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
  {src/adm/template/snd-list.i "docum-est"}

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

