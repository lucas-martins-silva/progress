&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V18IN090 2.00.00.006}  /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V18IN090 MUT}
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

{rep/re1001a.i}

def var de-icm-complem  like docum-est.icm-complem.
def var de-base-subs    like docum-est.base-subs.
def var de-vl-subs      like docum-est.vl-subs.                 
def var de-base-iss     like docum-est.base-iss.
def var de-valor-iss    like docum-est.iss-deb-cre.
def var de-vl-frete     like item-doc-est.pr-total-cmi.
def var de-vl-pis       like item-doc-est.base-subs-cmi.
def var de-vl-cofins    like item-doc-est.vl-subs-cmi.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.base-subs docum-est.vl-subs docum-est.icm-complem ~
docum-est.icm-fonte docum-est.base-subs-fasb[1] docum-est.vl-subs-fasb[1] 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}base-iss ~{&FP2}base-iss ~{&FP3}~
 ~{&FP1}iss-deb-cre ~{&FP2}iss-deb-cre ~{&FP3}~
 ~{&FP1}base-subs ~{&FP2}base-subs ~{&FP3}~
 ~{&FP1}vl-subs ~{&FP2}vl-subs ~{&FP3}~
 ~{&FP1}icm-complem ~{&FP2}icm-complem ~{&FP3}~
 ~{&FP1}icm-fonte ~{&FP2}icm-fonte ~{&FP3}~
 ~{&FP1}base-subs-fasb[1] ~{&FP2}base-subs-fasb[1] ~{&FP3}~
 ~{&FP1}vl-subs-fasb[1] ~{&FP2}vl-subs-fasb[1] ~{&FP3}
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS rt-key rt-button FILL-IN-1 fi-tot-nota ~
fi-tot-itens fi-diferenca 
&Scoped-Define DISPLAYED-FIELDS docum-est.base-iss docum-est.iss-deb-cre ~
docum-est.base-subs docum-est.vl-subs docum-est.icm-complem ~
docum-est.icm-fonte docum-est.base-subs-fasb[1] docum-est.vl-subs-fasb[1] 
&Scoped-Define DISPLAYED-OBJECTS fi-base-iss-it fi-base-iss-dif ~
fi-iss-deb-cre-it fi-iss-deb-cre-dif fi-base-subs-it fi-base-subs-dif ~
fi-vl-subs-it fi-vl-subs-dif fi-icm-complem-it fi-icm-complem-dif ~
fi-vl-pis-it fi-vl-pis-dif fi-vl-cofins-it fi-vl-cofins-dif FILL-IN-1 ~
fi-tot-nota fi-tot-itens fi-diferenca 

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

DEFINE VARIABLE fi-vl-cofins-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-cofins-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-pis-dif AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 19.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-pis-it AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
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

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 61.72 BY 1
     BGCOLOR 7 .

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 13.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     docum-est.base-iss AT ROW 3.04 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-base-iss-it AT ROW 3.04 COL 43 COLON-ALIGNED NO-LABEL
     fi-base-iss-dif AT ROW 3.04 COL 64 COLON-ALIGNED NO-LABEL
     docum-est.iss-deb-cre AT ROW 4.04 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-iss-deb-cre-it AT ROW 4.04 COL 43 COLON-ALIGNED NO-LABEL
     fi-iss-deb-cre-dif AT ROW 4.04 COL 64 COLON-ALIGNED NO-LABEL
     docum-est.base-subs AT ROW 5.71 COL 22 COLON-ALIGNED
          LABEL "Base ICMS Subs":R23
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-base-subs-it AT ROW 5.71 COL 43 COLON-ALIGNED NO-LABEL
     fi-base-subs-dif AT ROW 5.71 COL 64 COLON-ALIGNED NO-LABEL
     docum-est.vl-subs AT ROW 6.71 COL 22 COLON-ALIGNED
          LABEL "Valor ICMS Subs":R20
          VIEW-AS FILL-IN 
          SIZE 19.57 BY .88
     fi-vl-subs-it AT ROW 6.71 COL 43 COLON-ALIGNED NO-LABEL
     fi-vl-subs-dif AT ROW 6.71 COL 64 COLON-ALIGNED NO-LABEL
     docum-est.icm-complem AT ROW 8.38 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-icm-complem-it AT ROW 8.38 COL 43 COLON-ALIGNED NO-LABEL
     fi-icm-complem-dif AT ROW 8.38 COL 64 COLON-ALIGNED NO-LABEL
     docum-est.icm-fonte AT ROW 9.38 COL 22 COLON-ALIGNED
          LABEL "ICMS Subst Frete":R23
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     docum-est.base-subs-fasb[1] AT ROW 11.04 COL 22 COLON-ALIGNED
          LABEL "Vl PIS Subs":R23 FORMAT "->>>>>,>>>,>>9.99"
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-vl-pis-it AT ROW 11.04 COL 43 COLON-ALIGNED NO-LABEL
     fi-vl-pis-dif AT ROW 11.04 COL 64 COLON-ALIGNED NO-LABEL
     docum-est.vl-subs-fasb[1] AT ROW 12.04 COL 22 COLON-ALIGNED
          LABEL "Vl COFINS Subs":R25
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     fi-vl-cofins-it AT ROW 12.04 COL 43 COLON-ALIGNED NO-LABEL
     fi-vl-cofins-dif AT ROW 12.04 COL 64 COLON-ALIGNED NO-LABEL
     FILL-IN-1 AT ROW 1.67 COL 21.86 COLON-ALIGNED NO-LABEL
     fi-tot-nota AT ROW 1.67 COL 48.29 RIGHT-ALIGNED NO-LABEL
     fi-tot-itens AT ROW 1.67 COL 45 COLON-ALIGNED NO-LABEL
     fi-diferenca AT ROW 1.67 COL 67.72 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1.29
     rt-button AT ROW 1.58 COL 23.57
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
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 13.29
         WIDTH              = 86.29.
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

/* SETTINGS FOR FILL-IN docum-est.base-iss IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.base-subs IN FRAME f-main
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN docum-est.base-subs-fasb[1] IN FRAME f-main
   EXP-LABEL EXP-FORMAT                                                 */
ASSIGN 
       docum-est.base-subs-fasb[1]:HIDDEN IN FRAME f-main           = TRUE.

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
/* SETTINGS FOR FILL-IN fi-vl-cofins-dif IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-vl-cofins-dif:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-vl-cofins-it IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-vl-cofins-it:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-vl-pis-dif IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-vl-pis-dif:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-vl-pis-it IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-vl-pis-it:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-vl-subs-dif IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-vl-subs-it IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN docum-est.icm-fonte IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN docum-est.iss-deb-cre IN FRAME f-main
   2                                                                    */
/* SETTINGS FOR FILL-IN docum-est.vl-subs IN FRAME f-main
   2 EXP-LABEL                                                          */
/* SETTINGS FOR FILL-IN docum-est.vl-subs-fasb[1] IN FRAME f-main
   EXP-LABEL                                                            */
ASSIGN 
       docum-est.vl-subs-fasb[1]:HIDDEN IN FRAME f-main           = TRUE.

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
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
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
        fi-base-subs-dif:screen-value  = string(input  docum-est.base-subs     - 
                                         input  fi-base-subs-it)
        fi-base-subs-dif:fgcolor in frame {&frame-name} = 
                if input frame {&frame-name} fi-base-subs-dif <> 0 then 12 else ?
                
        docum-est.icm-fonte:sensitive  =   natur-oper.subs-trib 
                                       and input frame {&frame-name} docum-est.base-subs = 0
                                       and input frame {&frame-name} docum-est.vl-subs = 0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.base-subs-fasb[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.base-subs-fasb[1] V-table-Win
ON LEAVE OF docum-est.base-subs-fasb[1] IN FRAME f-main /* Vl PIS Subs */
DO:
    assign fi-vl-pis-dif:screen-value = string( input docum-est.base-subs-fasb[1] - 
                                                input fi-vl-pis-it )
                                                
           fi-vl-pis-dif:fgcolor in frame {&frame-name} = 
                  if input frame {&frame-name} fi-vl-pis-dif <> 0 then 12 else ?.
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


&Scoped-define SELF-NAME docum-est.icm-fonte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.icm-fonte V-table-Win
ON LEAVE OF docum-est.icm-fonte IN FRAME f-main /* ICMS Subst Frete */
DO:
    run pi-total-nota in h_v20in090.  
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


&Scoped-define SELF-NAME docum-est.vl-subs
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.vl-subs V-table-Win
ON LEAVE OF docum-est.vl-subs IN FRAME f-main /* Valor ICMS Subs */
DO:
    assign
        fi-vl-subs-dif:screen-value   = string(input  docum-est.vl-subs       - 
                                          input  fi-vl-subs-it)
        fi-vl-subs-dif:fgcolor in frame {&frame-name} = 
                      if input frame {&frame-name} fi-vl-subs-dif <> 0 then 12 else ?.

        docum-est.icm-fonte:sensitive =   natur-oper.subs-trib 
                                      and input frame {&frame-name} docum-est.vl-subs = 0
                                      and input frame {&frame-name} docum-est.base-subs = 0.

    run pi-total-nota in h_v20in090.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME docum-est.vl-subs-fasb[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL docum-est.vl-subs-fasb[1] V-table-Win
ON LEAVE OF docum-est.vl-subs-fasb[1] IN FRAME f-main /* Vl COFINS Subs */
DO:
    assign fi-vl-cofins-dif:screen-value = string( input docum-est.vl-subs-fasb[1] - 
                                                   input fi-vl-cofins-it )
                                                
           fi-vl-cofins-dif:fgcolor in frame {&frame-name} = 
                  if input frame {&frame-name} fi-vl-cofins-dif <> 0 then 12 else ?.
                  
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
  {utp/ut-liter.i Total_da_Nota MRE L}  
  assign fi-tot-nota:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Total_dos_Ötens MRE L}  
  assign fi-tot-itens:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Diferen‡a MRE L}  
  assign fi-diferenca:screen-value in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_PIS_Subs MRE L}  
  assign docum-est.base-subs-fasb[1]:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_COFINS_Subs MRE L}  
  assign docum-est.vl-subs-fasb[1]:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Base_ICMS_Subs MRE L}  
  assign docum-est.base-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_ICMS_Subs MRE L}  
  assign docum-est.vl-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i ICMS_Subst_Frete MRE L}  
  assign docum-est.icm-fonte:label in frame {&FRAME-NAME}  = return-value.

 
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

if l-re1001a-inclui = no then do with frame {&FRAME-NAME}:

/*
    /* Diferenca no valor do PIS */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-vl-pis-it,
                      input input docum-est.base-subs-fasb[1],
                      input 5504,
                      input input fi-vl-pis-dif = 0,            /*ser for igual a zero elimina senÆo cria*/
                      input 0,                                  /*Zero para erros do documento*/
                      input if abs(input fi-vl-pis-dif) > param-re.dec-1
                               then 1 else 2).                  /*se maior ‚ erro senao advertencia */   
                               
    /* Diferenca no valor do COFINS */
    run rep/re9995.p (input rowid(docum-est),
                      input input fi-vl-cofins-it,
                      input input docum-est.vl-subs-fasb[1],
                      input 5504,
                      input input fi-vl-cofins-dif = 0,         /*ser for igual a zero elimina senÆo cria*/
                      input 0,                                  /*Zero para erros do documento*/
                      input if abs(input fi-vl-cofins-dif) > param-re.dec-1
                               then 1 else 2).                  /*se maior ‚ erro senao advertencia */   
*/  
                               
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

  {utp/ut-liter.i Valor_PIS_Subs MRE L}  
  assign docum-est.base-subs-fasb[1]:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_COFINS_Subs MRE L}  
  assign docum-est.vl-subs-fasb[1]:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Base_ICMS_Subs MRE L}  
  assign docum-est.base-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_ICMS_Subs MRE L}  
  assign docum-est.vl-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i ICMS_Subst_Frete MRE L}  
  assign docum-est.icm-fonte:label in frame {&FRAME-NAME}  = return-value.

  if l-re1001a-inclui = no and 
     avail docum-est then do with frame {&FRAME-NAME}:
        assign
            fi-base-iss-it:screen-value     = string(de-base-iss)
            fi-iss-deb-cre-it:screen-value  = string(de-valor-iss)
            fi-base-subs-it:screen-value    = string(de-base-subs)
            fi-vl-subs-it:screen-value      = string(de-vl-subs)
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

  do  with frame {&FRAME-NAME}:
      assign docum-est.base-subs-fasb[1]:sensitive = no
             docum-est.vl-subs-fasb[1]:sensitive   = no
             docum-est.base-iss:sensitive          = no
             docum-est.iss-deb-cre:sensitive       = no
             docum-est.base-subs:sensitive         = no
             docum-est.vl-subs:sensitive           = no
             docum-est.icm-complem:sensitive       = no
             docum-est.icm-fonte:sensitive         = no.
  end.
  
  if  l-re1001a-inclui = no and avail docum-est then 
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

  {utp/ut-liter.i Valor_PIS_Subs MRE L}  
  assign docum-est.base-subs-fasb[1]:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_COFINS_Subs MRE L}  
  assign docum-est.vl-subs-fasb[1]:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Base_ICMS_Subs MRE L}  
  assign docum-est.base-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i Valor_ICMS_Subs MRE L}  
  assign docum-est.vl-subs:label in frame {&FRAME-NAME}  = return-value.

  {utp/ut-liter.i ICMS_Subst_Frete MRE L}  
  assign docum-est.icm-fonte:label in frame {&FRAME-NAME}  = return-value.


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
/*        docum-est.base-subs-fasb[1]:screen-value = fi-vl-pis-it:screen-value
        docum-est.vl-subs-fasb[1]:screen-value   = fi-vl-cofins-it:screen-value */
        docum-est.base-subs:screen-value         = fi-base-subs-it:screen-value
        docum-est.vl-subs:screen-value           = fi-vl-subs-it:screen-value
        docum-est.icm-complem:screen-value       = fi-icm-complem-it:screen-value
        docum-est.base-iss:screen-value          = fi-base-iss-it:screen-value
        docum-est.iss-deb-cre:screen-value       = fi-iss-deb-cre-it:screen-value
        docum-est.icm-fonte:screen-value         = string(de-icm-fonte).
end.

/* Atualiza valor do frete da nota */
assign docum-est.valor-frete = if  docum-est.valor-frete = 0
                               then de-vl-frete
                               else docum-est.valor-frete.

/* Habilita o campo ICMS Subs Frete */
run pi-habilita-campos.


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

assign de-icm-fonte  = input frame {&FRAME-NAME} docum-est.icm-fonte
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
/*        fi-vl-pis-dif:screen-value      = string( input docum-est.base-subs-fasb[1] -
                                                  input fi-vl-pis-it )
        fi-vl-cofins-dif:screen-value   = string( input docum-est.vl-subs-fasb[1]   -
                                                  input fi-vl-cofins-it ) */
        fi-base-iss-dif:screen-value    = string( input docum-est.base-iss          - 
                                                  input fi-base-iss-it ) 
        fi-base-subs-dif:screen-value   = string( input docum-est.base-subs         - 
                                                  input fi-base-subs-it )     
        fi-icm-complem-dif:screen-value = string( input docum-est.icm-complem       -   
                                                  input fi-icm-complem-it )   
        fi-iss-deb-cre-dif:screen-value = string( input docum-est.iss-deb-cre       - 
                                                  input fi-iss-deb-cre-it)   
        fi-vl-subs-dif:screen-value     = string( input docum-est.vl-subs           - 
                                                  input  fi-vl-subs-it ).

    assign 
/*        fi-vl-pis-dif:fgcolor in frame {&frame-name}      = if input frame {&frame-name} fi-vl-pis-dif <> 0 
                                                            then 12 else ?
        fi-vl-cofins-dif:fgcolor in frame {&frame-name}   = if input frame {&frame-name} fi-vl-cofins-dif <> 0 
                                                            then 12 else ?  */
        fi-base-iss-dif:fgcolor in frame {&frame-name}    = if input frame {&frame-name} fi-base-iss-dif <> 0 
                                                            then 12 else ?
        fi-base-subs-dif:fgcolor in frame {&frame-name}   = if input frame {&frame-name} fi-base-subs-dif <> 0 
                                                            then 12 else ?   
        fi-icm-complem-dif:fgcolor in frame {&frame-name} = if input frame {&frame-name} fi-icm-complem-dif <> 0 
                                                            then 12 else ?   
        fi-iss-deb-cre-dif:fgcolor in frame {&frame-name} = if input frame {&frame-name} fi-iss-deb-cre-dif <> 0 
                                                            then 12 else ?   
        fi-vl-subs-dif:fgcolor in frame {&frame-name}     = if input frame {&frame-name} fi-vl-subs-dif <> 0 
                                                            then 12 else ?.
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
do  with frame {&FRAME-NAME}:
   
    find natur-oper 
        where natur-oper.nat-operacao = docum-est.nat-operacao no-lock no-error.
    
    assign /* docum-est.base-subs-fasb[1]:sensitive = yes
           docum-est.vl-subs-fasb[1]:sensitive   = yes */
           docum-est.base-iss:sensitive          = (param-re.ped-imp-nota and docum-est.cod-observa = 4)
           docum-est.iss-deb-cre:sensitive       = (param-re.ped-imp-nota and docum-est.cod-observa = 4)
           docum-est.base-subs:sensitive         = (param-re.ped-imp-nota and natur-oper.subs-trib and not
                                                    can-do("16,26",substr(natur-oper.nat-operacao,1,2)))
           docum-est.vl-subs:sensitive           = (param-re.ped-imp-nota and natur-oper.subs-trib and not
                                                    can-do("16,26",substr(natur-oper.nat-operacao,1,2)))
           docum-est.icm-complem:sensitive       = (param-re.ped-imp-nota and docum-est.icm-complem <> 0)
           docum-est.icm-fonte:sensitive         =   natur-oper.subs-trib 
                                                 and (   can-do("16,26",substr(natur-oper.nat-operacao,1,2))
                                                      or (    input docum-est.base-subs = 0 
                                                          and input docum-est.vl-subs   = 0 )).
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
def input param p-de-vl-frete     like item-doc-est.pr-total-cmi.
def input param p-de-vl-pis       like item-doc-est.base-subs-cmi.
def input param p-de-vl-cofins    like item-doc-est.vl-subs-cmi.

assign  de-icm-complem = p-de-icm-complem 
        de-base-subs   = p-de-base-subs  
        de-vl-subs     = p-de-vl-subs     
        de-base-iss    = p-de-base-iss 
        de-valor-iss   = p-de-valor-iss
        de-vl-frete    = p-de-vl-frete
        de-vl-pis      = p-de-vl-pis
        de-vl-cofins   = p-de-vl-cofins.

do  with frame {&FRAME-NAME}:
    assign
        fi-base-iss-it:screen-value     = string(de-base-iss)
        fi-iss-deb-cre-it:screen-value  = string(de-valor-iss)
        fi-base-subs-it:screen-value    = string(de-base-subs)
        fi-vl-subs-it:screen-value      = string(de-vl-subs)
        fi-icm-complem-it:screen-value  = string(de-icm-complem).
/*        fi-vl-pis-it:screen-value       = string(de-vl-pis)
        fi-vl-cofins-it:screen-value    = string(de-vl-cofins). */
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


