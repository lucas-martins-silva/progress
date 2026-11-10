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
{include/i-prgvrs.i V29IN090 2.00.00.013 } /*** "010013" 15/06/2026 14:31:49 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V29IN090 MUT}
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
def var v-row-parent as rowid   no-undo.
def new global shared var l-re1001a-inclui     as logical no-undo init no.

{rep/re0701.i}
{cdp/cdcfgmat.i}

def var de-icm-complem  like docum-est.icm-complem.
def var de-base-subs    like docum-est.base-subs.
def var de-vl-subs      like docum-est.vl-subs.                 
def var de-base-iss     like docum-est.base-iss.
def var de-valor-iss    like docum-est.iss-deb-cre.
def var de-bicms-compl  like docum-est.icm-complem.
def var h-boin01016     as handle no-undo.

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
&Scoped-Define ENABLED-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.base-subs docum-est.vl-subs docum-est.icm-complem ~
docum-est.icm-fonte 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-button rt-key fi-vl-pis-subs ~
fi-vl-pis-subs-it fi-vl-pis-subs-df fi-vl-cofins-subs ~
fi-vl-cofins-subs-it fi-vl-cofins-subs-df FILL-IN-1 fi-tot-nota ~
fi-tot-itens fi-diferenca 
&Scoped-Define DISPLAYED-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.base-subs docum-est.vl-subs docum-est.icm-complem ~
docum-est.icm-fonte 
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est
&Scoped-Define DISPLAYED-OBJECTS fi-base-iss-it fi-base-iss-dif ~
fi-iss-deb-cre-it fi-iss-deb-cre-dif fi-base-subs-it fi-base-subs-dif ~
fi-vl-subs-it fi-vl-subs-dif fi-base-fcp-st fi-base-fcp-st-it ~
fi-base-fcp-st-dif fi-valor-fcp-st fi-valor-fcp-st-it fi-valor-fcp-st-dif ~
vl-bicms-compl fi-vl-bicms-compl fi-vl-bicms-compl-dif fi-icm-complem-it ~
fi-icm-complem-dif fi-vl-simpl-nac fi-vl-simpl-nac-it fi-vl-simpl-nac-dif ~
fi-vl-pis-subs fi-vl-pis-subs-it fi-vl-pis-subs-df fi-vl-cofins-subs ~
fi-vl-cofins-subs-it fi-vl-cofins-subs-df FILL-IN-1 fi-tot-nota ~
fi-tot-itens fi-diferenca 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.base-subs docum-est.vl-subs 

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
DEFINE VARIABLE fi-base-fcp-st AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base FCP Subs" 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-fcp-st-dif AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-fcp-st-it AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-iss-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-iss-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-subs-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-base-subs-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-diferenca AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-icm-complem-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-icm-complem-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-iss-deb-cre-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-iss-deb-cre-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-itens AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 23.14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tot-nota AS CHARACTER FORMAT "X(50)":U 
      VIEW-AS TEXT 
     SIZE 21.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-fcp-st AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor FCP Subs" 
     VIEW-AS FILL-IN 
     SIZE 19.57 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-fcp-st-dif AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-valor-fcp-st-it AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-bicms-compl AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-bicms-compl-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-cofins-subs AS DECIMAL FORMAT ">>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Cofins Subst" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-cofins-subs-df AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-cofins-subs-it AS DECIMAL FORMAT ">>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-pis-subs AS DECIMAL FORMAT ">>>>,>>>,>>9.99" INITIAL 0 
     LABEL "Pis Subst" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-pis-subs-df AS DECIMAL FORMAT "->>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-pis-subs-it AS DECIMAL FORMAT ">>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-simpl-nac AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "ICMS Simples Nac." 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-simpl-nac-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-simpl-nac-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-subs-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-subs-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 5.14 BY .88 NO-UNDO.

DEFINE VARIABLE vl-bicms-compl AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base ICMS Compl" 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61.72 BY 1
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 13.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.base-iss AT ROW 2.63 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-base-iss-it AT ROW 2.63 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-base-iss-dif AT ROW 2.63 COL 63.72 COLON-ALIGNED NO-LABEL
     fi-iss-deb-cre-it AT ROW 3.54 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-iss-deb-cre-dif AT ROW 3.54 COL 63.72 COLON-ALIGNED NO-LABEL
     docum-est.iss-deb-cre AT ROW 3.58 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.base-subs AT ROW 4.54 COL 21.72 COLON-ALIGNED
          LABEL "Base ICMS Subs":R23
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-base-subs-it AT ROW 4.54 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-base-subs-dif AT ROW 4.54 COL 63.72 COLON-ALIGNED NO-LABEL
     docum-est.vl-subs AT ROW 5.5 COL 21.72 COLON-ALIGNED
          LABEL "Valor ICMS Subs":R20
          VIEW-AS FILL-IN 
          SIZE 19.57 BY .88
     fi-vl-subs-it AT ROW 5.5 COL 42.72 COLON-ALIGNED NO-LABEL
     fi-vl-subs-dif AT ROW 5.5 COL 63.72 COLON-ALIGNED NO-LABEL
     fi-base-fcp-st AT ROW 6.46 COL 21.72 COLON-ALIGNED WIDGET-ID 2
     fi-base-fcp-st-it AT ROW 6.46 COL 42.72 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     fi-base-fcp-st-dif AT ROW 6.46 COL 63.72 COLON-ALIGNED NO-LABEL WIDGET-ID 10
     fi-valor-fcp-st AT ROW 7.42 COL 21.72 COLON-ALIGNED WIDGET-ID 4
     fi-valor-fcp-st-it AT ROW 7.42 COL 42.72 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     fi-valor-fcp-st-dif AT ROW 7.42 COL 63.72 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     vl-bicms-compl AT ROW 8.38 COL 22 COLON-ALIGNED
     fi-vl-bicms-compl AT ROW 8.38 COL 42.86 COLON-ALIGNED NO-LABEL
     fi-vl-bicms-compl-dif AT ROW 8.38 COL 63.86 COLON-ALIGNED NO-LABEL
     docum-est.icm-complem AT ROW 9.33 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-icm-complem-it AT ROW 9.33 COL 42.86 COLON-ALIGNED NO-LABEL
     fi-icm-complem-dif AT ROW 9.33 COL 63.86 COLON-ALIGNED NO-LABEL
     docum-est.icm-fonte AT ROW 10.29 COL 21.86 COLON-ALIGNED
          LABEL "ICMS Subst Frete":R23
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-vl-simpl-nac AT ROW 11.25 COL 21.86 COLON-ALIGNED
     fi-vl-simpl-nac-it AT ROW 11.25 COL 42.86 COLON-ALIGNED NO-LABEL
     fi-vl-simpl-nac-dif AT ROW 11.25 COL 63.86 COLON-ALIGNED NO-LABEL
     fi-vl-pis-subs AT ROW 12.21 COL 21.86 COLON-ALIGNED HELP
          "Valor PIS Substituto"
     fi-vl-pis-subs-it AT ROW 12.21 COL 42.86 COLON-ALIGNED NO-LABEL
     fi-vl-pis-subs-df AT ROW 12.21 COL 63.86 COLON-ALIGNED NO-LABEL
     fi-vl-cofins-subs AT ROW 13.17 COL 21.86 COLON-ALIGNED HELP
          "Valor COFINS Substituto"
     fi-vl-cofins-subs-it AT ROW 13.17 COL 42.86 COLON-ALIGNED NO-LABEL
     fi-vl-cofins-subs-df AT ROW 13.17 COL 63.86 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 1.63 COL 21.86 COLON-ALIGNED NO-LABEL
     fi-tot-nota AT ROW 1.63 COL 48.29 RIGHT-ALIGNED NO-LABEL
     fi-tot-itens AT ROW 1.63 COL 45 COLON-ALIGNED NO-LABEL
     fi-diferenca AT ROW 1.63 COL 67.72 COLON-ALIGNED NO-LABEL
     rt-button AT ROW 1.58 COL 23.57
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 13.29
         WIDTH              = 85.57.
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

/* SETTINGS FOR FILL-IN docum-est.base-iss IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.base-subs IN FRAME f-main
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN fi-base-iss-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-base-iss-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-base-subs-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-base-subs-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-icm-complem-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-icm-complem-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-iss-deb-cre-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-iss-deb-cre-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-tot-nota IN FRAME f-main
   ALIGN-R                                                              */
/* SETTINGS FOR FILL-IN fi-vl-bicms-compl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-bicms-compl-dif IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-vl-cofins-subs:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-vl-cofins-subs-df:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-vl-cofins-subs-it:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-vl-pis-subs:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-vl-pis-subs-df:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       fi-vl-pis-subs-it:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-vl-subs-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-subs-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.icm-fonte IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN docum-est.iss-deb-cre IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN vl-bicms-compl IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.vl-subs IN FRAME f-main
   2 EXP-LABEL                                                          */
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

&Scoped-define SELF-NAME docum-est.base-iss
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.base-iss V-table-Win
ON LEAVE OF docum-est.base-iss IN FRAME f-main /* Base C lculo ISS */
DO:
    assign
        fi-base-iss-dif:screen-value    = string(input  docum-est.base-iss      - 
                                          input  fi-base-iss-it).
    assign fi-base-iss-dif:fgcolor in frame {&frame-name} = 
        if input frame {&frame-name} fi-base-iss-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.base-subs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.base-subs V-table-Win
ON LEAVE OF docum-est.base-subs IN FRAME f-main /* Base ICMS Subs */
DO:
    assign
        fi-base-subs-dif:screen-value   = string(input  docum-est.base-subs     - 
                                          input  fi-base-subs-it).
    assign fi-base-subs-dif:fgcolor in frame {&frame-name} = 
                if input frame {&frame-name} fi-base-subs-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.icm-complem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.icm-complem V-table-Win
ON LEAVE OF docum-est.icm-complem IN FRAME f-main /* ICMS Complementar */
DO:
    assign
        fi-icm-complem-dif:screen-value = string(input  docum-est.icm-complem   -   
                                          input  fi-icm-complem-it)   .
    assign fi-icm-complem-dif:fgcolor in frame {&frame-name} = 
            if input frame {&frame-name} fi-icm-complem-dif <> 0 then 12 else ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.iss-deb-cre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.iss-deb-cre V-table-Win
ON LEAVE OF docum-est.iss-deb-cre IN FRAME f-main /* Valor ISS */
DO:
    assign
        fi-iss-deb-cre-dif:screen-value = string(input  docum-est.iss-deb-cre   - 
                                          input  fi-iss-deb-cre-it).

    assign fi-iss-deb-cre-dif:fgcolor in frame {&frame-name} = 
        if input frame {&frame-name} fi-iss-deb-cre-dif <> 0 then 12 else ?.
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

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Base_ICMS_Subs MRE L}  
  assign docum-est.base-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_ICMS_Subs MRE L}  
  assign docum-est.vl-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i ICMS_Subst_Frete MRE L}  
  assign docum-est.icm-fonte:label in frame {&frame-name}  = return-value.

 
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
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

if l-re1001a-inclui = no then do with frame {&FRAME-NAME}:

    /* Diferenca na base de ISS */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-base-iss-it,
                      input input  docum-est.base-iss,
                      input 5504,
                      input input fi-base-iss-dif = 0,          /*ser for igual a zero elimina senÆo cria*/
                      input 0,                                  /*Zero para erros do documento*/
                      input if abs(input fi-base-iss-dif) > param-re.dec-1
                               then 1 else 2).                  /*se maior ‚ erro senao advertencia */       


    /* Diferenca no valor de ISS */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-iss-deb-cre-it ,
                      input input docum-est.iss-deb-cre,
                      input 5505,
                      input input fi-iss-deb-cre-dif = 0,          /*ser for igual a zero elimina senÆo cria*/
                      input 0,                                  /*Zero para erros do documento*/
                      input if abs(input fi-iss-deb-cre-dif) > param-re.dec-1
                               then 1 else 2).                  /*se maior ‚ erro senao advertencia */       

    /* Diferenca na base de ICM Substituto */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-base-subs-it,
                      input input docum-est.base-subs,
                      input 5515,
                      input input fi-base-subs-dif = 0, /*ser for igual a zero elimina senÆo cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-base-subs-dif) > param-re.dec-1 /*diferen‡a maior que parƒmetro */
                                then 1 else 2).                          /*entao erro senao advertencia*/       


    /* Diferenca no valor de ICM Substituto */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-vl-subs-it,
                      input input docum-est.vl-subs,
                      input 5516,
                      input input fi-vl-subs-dif = 0, /*ser for igual a zero elimina senÆo cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-vl-subs-dif) > param-re.dec-1 /*diferen‡a maior que parƒmetro */
                                then 1 else 2).                          /*entao erro senao advertencia*/       

    /* Diferenca no valor da Base do ICMS Complementar */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-vl-bicms-compl,
                      input input vl-bicms-compl,
                      input 54695,
                      input input fi-vl-bicms-compl-dif = 0, /*ser for igual a zero elimina senÆo cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-vl-bicms-compl-dif) > param-re.dec-1 /*diferen‡a maior que parƒmetro */
                                then 1 else 2).                       /*entao erro senao advertencia*/   

    /* Diferenca no valor de ICM Complementar */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-icm-complem-it,
                      input input docum-est.icm-complem,
                      input 5499,
                      input input fi-icm-complem-dif = 0, /*ser for igual a zero elimina senÆo cria*/
                      input 0,                             /*Zero para erros do documento*/
                      input if abs(input fi-icm-complem-dif) > param-re.dec-1 /*diferen‡a maior que parƒmetro */
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

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Base_ICMS_Subs MRE L}  
  assign docum-est.base-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_ICMS_Subs MRE L}  
  assign docum-est.vl-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i ICMS_Subst_Frete MRE L}  
  assign docum-est.icm-fonte:label in frame {&frame-name}  = return-value.

  &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
      IF AVAIL docum-est THEN DO WITH FRAME {&FRAME-NAME}:
          /*Total da Nota*/
          ASSIGN fi-vl-pis-subs:SCREEN-VALUE    = STRING(docum-est.vl-pis-subs)
                 fi-vl-cofins-subs:SCREEN-VALUE = STRING(docum-est.vl-cofins-subs).
 
          /*Total dos Itens*/
          FOR EACH item-doc-est {cdp/cd8900.i item-doc-est docum-est} NO-LOCK:
      
              ACCUM  item-doc-est.vl-pis-subs    (TOTAL)
                     item-doc-est.vl-cofins-subs (TOTAL).
              ASSIGN fi-vl-pis-subs-it:SCREEN-VALUE    = STRING(ACCUM TOTAL item-doc-est.vl-pis-subs)    
                     fi-vl-cofins-subs-it:SCREEN-VALUE = STRING(ACCUM TOTAL item-doc-est.vl-cofins-subs).
          END.

          /*Base ICMS Complementar*/
          ASSIGN vl-bicms-compl:SCREEN-VALUE IN FRAME {&frame-name} = SUBSTRING(docum-est.char-2,191,20). 

      END.
  &ENDIF
  
  IF  NOT VALID-HANDLE(h-boin01016) THEN
    RUN inbo/boin01016.p PERSISTENT SET h-boin01016.
  RUN openQueryStatic IN h-boin01016 (INPUT "Main":U) NO-ERROR.

  /* Simples Nacional */
  RUN goToKey IN h-boin01016 (INPUT docum-est.serie-docto, 
                              INPUT docum-est.nro-docto,   
                              INPUT docum-est.cod-emitente,
                              INPUT docum-est.nat-operacao,
                              INPUT "simplesnacional":U). 
  IF RETURN-VALUE = "OK":U THEN DO:
      RUN getRecord IN h-boin01016 (OUTPUT TABLE tt-ext-docum-est).

      FIND FIRST tt-ext-docum-est NO-LOCK
           WHERE tt-ext-docum-est.serie-docto  = docum-est.serie-docto
             AND tt-ext-docum-est.nro-docto    = docum-est.nro-docto
             AND tt-ext-docum-est.cod-emitente = docum-est.cod-emitente
             AND tt-ext-docum-est.nat-operacao = docum-est.nat-operacao
             AND tt-ext-docum-est.cod-param    = "simplesnacional":U NO-ERROR.
      IF AVAIL tt-ext-docum-est THEN
          ASSIGN fi-vl-simpl-nac:SCREEN-VALUE IN FRAME {&frame-name}     = STRING(tt-ext-docum-est.val-livre-3)
                 fi-vl-simpl-nac-it:SCREEN-VALUE IN FRAME {&frame-name}  = STRING(tt-ext-docum-est.val-livre-3)
                 fi-vl-simpl-nac-dif:SCREEN-VALUE IN FRAME {&frame-name} = STRING(0).
  END.
  /*Simples Nacional*/

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
          ASSIGN fi-base-fcp-st:SCREEN-VALUE IN FRAME {&frame-name}     = STRING(tt-ext-docum-est.val-livre-4)
                 fi-base-fcp-st-it:SCREEN-VALUE IN FRAME {&frame-name}  = STRING(tt-ext-docum-est.val-livre-4)
                 fi-base-fcp-st-dif:SCREEN-VALUE IN FRAME {&frame-name} = STRING(0)
                 fi-valor-fcp-st:SCREEN-VALUE IN FRAME {&frame-name}     = STRING(tt-ext-docum-est.val-livre-6)
                 fi-valor-fcp-st-it:SCREEN-VALUE IN FRAME {&frame-name}  = STRING(tt-ext-docum-est.val-livre-6)
                 fi-valor-fcp-st-dif:SCREEN-VALUE IN FRAME {&frame-name} = STRING(0).
  END.
  /*FCP*/

  IF  VALID-HANDLE(h-boin01016) THEN DO:
      DELETE PROCEDURE h-boin01016.
      ASSIGN h-boin01016 = ?.
  END.

  if l-re1001a-inclui = no and 
     avail docum-est then do with frame {&FRAME-NAME}:
        assign
            fi-base-iss-it:screen-value     = string(de-base-iss)
            fi-iss-deb-cre-it:screen-value  = string(de-valor-iss)
            fi-base-subs-it:screen-value    = string(de-base-subs)
            fi-vl-subs-it:screen-value      = string(de-vl-subs)
            fi-vl-bicms-compl:screen-value  = string(de-bicms-compl)
            fi-icm-complem-it:screen-value  = string(de-icm-complem).

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
    assign     docum-est.base-iss:sensitive       = no
               docum-est.iss-deb-cre:sensitive    = no
               docum-est.base-subs:sensitive      = no
               docum-est.vl-subs:sensitive        = no
               vl-bicms-compl:sensitive           = no
               docum-est.icm-complem:sensitive    = no
               docum-est.icm-fonte:sensitive      = no.
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

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Base_ICMS_Subs MRE L}  
  assign docum-est.base-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_ICMS_Subs MRE L}  
  assign docum-est.vl-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i ICMS_Subst_Frete MRE L}  
  assign docum-est.icm-fonte:label in frame {&frame-name}  = return-value.

    &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
        ASSIGN fi-vl-pis-subs:HIDDEN    IN FRAME {&FRAME-NAME} = NO
               fi-vl-cofins-subs:HIDDEN IN FRAME {&FRAME-NAME} = NO
               fi-vl-pis-subs-it:HIDDEN    IN FRAME {&FRAME-NAME} = NO
               fi-vl-cofins-subs-it:HIDDEN IN FRAME {&FRAME-NAME} = NO
               fi-vl-pis-subs-df:HIDDEN    IN FRAME {&FRAME-NAME} = NO
               fi-vl-cofins-subs-df:HIDDEN IN FRAME {&FRAME-NAME} = NO.
    &ENDIF

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
def input param de-icm-fonte    like docum-est.icm-fonte.

do with frame {&FRAME-NAME}:
    assign 
        docum-est.base-subs:screen-value       = fi-base-subs-it:screen-value
        docum-est.vl-subs:screen-value         = fi-vl-subs-it:screen-value
        vl-bicms-compl:screen-value            = fi-vl-bicms-compl:screen-value
        docum-est.icm-complem:screen-value     = fi-icm-complem-it:screen-value
        docum-est.base-iss:screen-value        = fi-base-iss-it:screen-value
        docum-est.iss-deb-cre:screen-value     = fi-iss-deb-cre-it:screen-value
        docum-est.icm-fonte:screen-value       = string(de-icm-fonte).
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-totais V-table-Win 
PROCEDURE pi-busca-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param de-icm-fonte like docum-est.icm-fonte.
def output param de-vl-subs-it like docum-est.vl-subs.

assign de-icm-fonte  = input frame {&frame-name} docum-est.icm-fonte
       de-vl-subs-it = input frame {&FRAME-NAME} docum-est.vl-subs.

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
    
do  with frame {&FRAME-NAME}:
    assign
        fi-base-iss-dif:screen-value       = string(input  docum-est.base-iss       - 
                                             input  fi-base-iss-it) 
        fi-base-subs-dif:screen-value      = string(input  docum-est.base-subs      - 
                                             input  fi-base-subs-it)  
        fi-vl-bicms-compl-dif:screen-value = string(input vl-bicms-compl            - 
                                             input  fi-vl-bicms-compl)   
        fi-icm-complem-dif:screen-value    = string(input  docum-est.icm-complem    -   
                                             input  fi-icm-complem-it)              
        fi-iss-deb-cre-dif:screen-value    = string(input  docum-est.iss-deb-cre    - 
                                             input  fi-iss-deb-cre-it)              
        fi-vl-subs-dif:screen-value        = string(input  docum-est.vl-subs        - 
                                              input  fi-vl-subs-it)
        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN
            fi-vl-pis-subs-df:screen-value    = string(input  fi-vl-pis-subs    - 
                                                input  fi-vl-pis-subs-it) 
            fi-vl-cofins-subs-df:screen-value = string(input  fi-vl-cofins-subs - 
                                                input  fi-vl-cofins-subs-it)
        &ENDIF
        .
    
    assign fi-base-iss-dif:fgcolor in frame {&frame-name}    = 
        if input frame {&frame-name} fi-base-iss-dif <> 0 then 12 else ?
           fi-base-subs-dif:fgcolor in frame {&frame-name}   = 
        if input frame {&frame-name} fi-base-subs-dif <> 0 then 12 else ? 
           fi-vl-bicms-compl-dif:fgcolor in frame {&frame-name} = 
        if input frame {&frame-name} fi-vl-bicms-compl-dif <> 0 then 12 else ?   
           fi-icm-complem-dif:fgcolor in frame {&frame-name} = 
        if input frame {&frame-name} fi-icm-complem-dif <> 0 then 12 else ?   
           fi-iss-deb-cre-dif:fgcolor in frame {&frame-name} = 
        if input frame {&frame-name} fi-iss-deb-cre-dif <> 0 then 12 else ?   
           fi-vl-subs-dif:fgcolor in frame {&frame-name}     = 
        if input frame {&frame-name} fi-vl-subs-dif <> 0 then 12 else ?
        &IF "{&bf_mat_versao_ems}" >= "2.04" &THEN   
                fi-vl-pis-subs-df:fgcolor in frame {&frame-name}     = 
            if input frame {&frame-name} fi-vl-pis-subs-df <> 0 then 12 else ?
               fi-vl-cofins-subs-df:fgcolor in frame {&frame-name}     = 
            if input frame {&frame-name} fi-vl-cofins-subs-df <> 0 then 12 else ?
         &ENDIF
         .
end.

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
    find natur-oper where natur-oper.nat-operacao = docum-est.nat-operacao 
            no-lock no-error.
    
    assign     docum-est.base-iss:sensitive       = (param-re.ped-imp-nota and docum-est.cod-observa = 4)
               docum-est.iss-deb-cre:sensitive    = (param-re.ped-imp-nota and docum-est.cod-observa = 4)
               docum-est.base-subs:sensitive      = (param-re.ped-imp-nota and natur-oper.subs-trib)
               docum-est.vl-subs:sensitive        = (param-re.ped-imp-nota and natur-oper.subs-trib)
               docum-est.icm-complem:sensitive    = (param-re.ped-imp-nota and docum-est.icm-complem <> 0)
               docum-est.icm-fonte:sensitive      = (natur-oper.subs-trib and 
                                                     can-do("16,26",substring(natur-oper.nat-operacao,1,2))).
end.

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
def input param p-de-icm-complem  like docum-est.icm-complem.
def input param p-de-base-subs    like docum-est.base-subs.
def input param p-de-vl-subs      like docum-est.vl-subs.                 
def input param p-de-base-iss     like docum-est.base-iss.
def input param p-de-valor-iss    like docum-est.iss-deb-cre.
def input param p-de-bicms-compl  like docum-est.icm-complem.

assign  de-icm-complem = p-de-icm-complem 
        de-base-subs   = p-de-base-subs  
        de-vl-subs     = p-de-vl-subs     
        de-base-iss    = p-de-base-iss 
        de-valor-iss   = p-de-valor-iss
        de-bicms-compl = p-de-bicms-compl. 

do with frame {&FRAME-NAME}:
    assign
        fi-base-iss-it:screen-value     = string(de-base-iss)
        fi-iss-deb-cre-it:screen-value  = string(de-valor-iss)
        fi-base-subs-it:screen-value    = string(de-base-subs)
        fi-vl-subs-it:screen-value      = string(de-vl-subs)
        fi-icm-complem-it:screen-value  = string(de-icm-complem)
        fi-vl-bicms-compl:screen-value  = string(de-bicms-compl).
end.

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
   
   /*Segue um exemplo de valida‡Æo de programa 
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

