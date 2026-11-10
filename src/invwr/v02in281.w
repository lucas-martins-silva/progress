&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME

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
{include/i-prgvrs.i V02IN281 2.00.00.010 } /*** "010010" 08/04/2024 14:03:32 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in281 MUT}
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

{cdp/cdcfgman.i}

DEFINE VARIABLE l-usa-param-linha AS LOGICAL INITIAL NO NO-UNDO.

/** Unifica‡Æo de conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}

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
&Scoped-define EXTERNAL-TABLES param-cp
&Scoped-define FIRST-EXTERNAL-TABLE param-cp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-cp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-cp.ct-trans param-cp.sc-trans ~
param-cp.ct-ordem param-cp.sc-ordem param-cp.ct-refugo param-cp.sc-refugo ~
param-cp.var-rep param-cp.var-transf param-cp.var-req-menor ~
param-cp.var-requis 
&Scoped-define ENABLED-TABLES param-cp
&Scoped-define FIRST-ENABLED-TABLE param-cp
&Scoped-Define ENABLED-OBJECTS RECT-2 RECT-3 RECT-4 RECT-5 RECT-6 RECT-7 ~
tg-usa-param-linha 
&Scoped-Define DISPLAYED-FIELDS param-cp.ct-trans param-cp.sc-trans ~
param-cp.ct-ordem param-cp.sc-ordem param-cp.ct-refugo param-cp.sc-refugo ~
param-cp.var-rep param-cp.var-transf param-cp.var-req-menor ~
param-cp.var-requis 
&Scoped-define DISPLAYED-TABLES param-cp
&Scoped-define FIRST-DISPLAYED-TABLE param-cp
&Scoped-Define DISPLAYED-OBJECTS c-conta-aplicacao c-ccusto-aplicacao ~
tg-usa-param-linha 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS c-conta-aplicacao c-ccusto-aplicacao 

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
DEFINE VARIABLE c-ccusto-aplicacao AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE c-conta-aplicacao AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.29 BY 1.33.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.29 BY 1.33.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.29 BY 1.33.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69.29 BY 1.33.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 3.42.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 3.42.

DEFINE VARIABLE tg-usa-param-linha AS LOGICAL INITIAL no 
     LABEL "Usa Dep¢sito e Varia‡Æo da Linha" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-cp.ct-trans AT ROW 1.5 COL 19.86 COLON-ALIGNED
          LABEL "Conta Transferˆncia"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     param-cp.sc-trans AT ROW 1.5 COL 40.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     param-cp.ct-ordem AT ROW 2.83 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     param-cp.sc-ordem AT ROW 2.83 COL 40.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     param-cp.ct-refugo AT ROW 4.17 COL 19.86 COLON-ALIGNED
          LABEL "Conta Refugo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     param-cp.sc-refugo AT ROW 4.17 COL 40.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     c-conta-aplicacao AT ROW 5.5 COL 19.86 COLON-ALIGNED
     c-ccusto-aplicacao AT ROW 5.5 COL 40 COLON-ALIGNED NO-LABEL
     tg-usa-param-linha AT ROW 6.79 COL 1.14 WIDGET-ID 10
     param-cp.var-rep AT ROW 8.92 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-cp.var-transf AT ROW 9.92 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-cp.var-req-menor AT ROW 8.92 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     param-cp.var-requis AT ROW 9.92 COL 54 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     "% Varia‡Æo" VIEW-AS TEXT
          SIZE 15 BY .67 AT ROW 7.83 COL 3 WIDGET-ID 4
     "Requisi‡Æo" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 7.92 COL 37 WIDGET-ID 8
     RECT-2 AT ROW 1.25 COL 1
     RECT-3 AT ROW 2.63 COL 1
     RECT-4 AT ROW 3.96 COL 1
     RECT-5 AT ROW 5.29 COL 1
     RECT-6 AT ROW 8.17 COL 1 WIDGET-ID 2
     RECT-7 AT ROW 8.17 COL 35 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-cp
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
         HEIGHT             = 11.63
         WIDTH              = 72.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-ccusto-aplicacao IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       c-ccusto-aplicacao:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-conta-aplicacao IN FRAME f-main
   NO-ENABLE 2                                                          */
ASSIGN 
       c-conta-aplicacao:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN param-cp.ct-refugo IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN param-cp.ct-trans IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME c-ccusto-aplicacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplicacao V-table-Win
ON F5 OF c-ccusto-aplicacao IN FRAME f-main
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN c-ccusto-aplicacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplicacao V-table-Win
ON LEAVE OF c-ccusto-aplicacao IN FRAME f-main
DO:
   {cdp/cdunif001d.i c-ccusto-aplicacao {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ccusto-aplicacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ccusto-aplicacao IN FRAME f-main
DO:
   APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-conta-aplicacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-aplicacao V-table-Win
ON ENTRY OF c-conta-aplicacao IN FRAME f-main
DO:
  ASSIGN c-conta-aplicacao:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-aplicacao V-table-Win
ON F5 OF c-conta-aplicacao IN FRAME f-main
DO:
  find first param-global no-lock no-error.
  assign i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = yes.

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        assign v_cod_finalid = {adinc/i05ad049.i 4 1} /* 1 - Consumo */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2} /* 2 - Não Consumo */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3} /* 3 - Ordem servi‡o */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 4} /* 4 - Transferencia */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5} /* 5 - MÆo-de-obra */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6} /* 6 - Custo mercadoria vendida */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 7}
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 8}
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 9}
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 10}.
        
        run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                                                                  INPUT "CEP",
                                                                                                  INPUT "",
                                                                                                  INPUT v_cod_finalid,
                                                                                                  INPUT TODAY,
                                                                                                  OUTPUT v_cod_cta_ctbl,
                                                                                                  OUTPUT v_des_cta_ctbl,
                                                                                                  OUTPUT p-finalidade,
                                                                                                  OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}
        
        IF v_cod_cta_ctbl <> "" THEN
                        ASSIGN c-conta-aplicacao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

        if valid-handle(h_api_cta_ctbl) then
                                        delete object h_api_cta_ctbl.                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-aplicacao V-table-Win
ON LEAVE OF c-conta-aplicacao IN FRAME f-main
DO:
  {cdp/cdunif001a.i c-conta-aplicacao c-ccusto-aplicacao {&FRAME-NAME} TODAY """" """"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-conta-aplicacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-conta-aplicacao IN FRAME f-main
DO:
   APPLY "F5" TO self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.ct-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-ordem V-table-Win
ON ENTRY OF param-cp.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
  ASSIGN param-cp.ct-ordem:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-ordem V-table-Win
ON F5 OF param-cp.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = YES.

    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

        assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}.
           
        run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                                                          INPUT "CEP",
                                                                                          INPUT "",
                                                                                          INPUT v_cod_finalid,
                                                                                          INPUT TODAY,
                                                                                          OUTPUT v_cod_cta_ctbl,
                                                                                          OUTPUT v_des_cta_ctbl,
                                                                                          OUTPUT p-finalidade,
                                                                                          OUTPUT TABLE tt_log_erro).
    
    
    {cdp/cdunif001b.i1}
        
        IF v_cod_cta_ctbl <> "" THEN
                        ASSIGN param-cp.ct-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.
        
        if valid-handle(h_api_cta_ctbl) then
                                        delete object h_api_cta_ctbl.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-ordem V-table-Win
ON LEAVE OF param-cp.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
    {cdp/cdunif001a.i param-cp.ct-ordem param-cp.sc-ordem {&FRAME-NAME} TODAY """" """"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.ct-ordem IN FRAME f-main /* Conta Ordem */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.ct-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-refugo V-table-Win
ON ENTRY OF param-cp.ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
  ASSIGN param-cp.ct-refugo:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-refugo V-table-Win
ON F5 OF param-cp.ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
        FIND FIRST param-global NO-LOCK NO-ERROR.
        
        ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
           l-implanta          = YES.
        
    if not valid-handle(h_api_cta_ctbl) then 
                run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
        assign v_cod_finalid = "(nenhum)".
        
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                  INPUT "CEP",
                                                  INPUT "",
                                                  INPUT v_cod_finalid,
                                                  INPUT TODAY,
                                                  OUTPUT v_cod_cta_ctbl,
                                                  OUTPUT v_des_cta_ctbl,
                                                  OUTPUT p-finalidade,
                                                  OUTPUT TABLE tt_log_erro).
    
    
    {cdp/cdunif001b.i1}
        
        IF v_cod_cta_ctbl <> "" THEN
                        ASSIGN param-cp.ct-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

        if valid-handle(h_api_cta_ctbl) then
                                        delete object h_api_cta_ctbl.   
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-refugo V-table-Win
ON LEAVE OF param-cp.ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
    {cdp/cdunif001a.i param-cp.ct-refugo param-cp.sc-refugo {&FRAME-NAME} TODAY """" """"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.ct-refugo IN FRAME f-main /* Conta Refugo */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.ct-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-trans V-table-Win
ON ENTRY OF param-cp.ct-trans IN FRAME f-main /* Conta Transferˆncia */
DO:
  ASSIGN param-cp.ct-trans:FORMAT IN FRAME {&frame-name} = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-trans V-table-Win
ON F5 OF param-cp.ct-trans IN FRAME f-main /* Conta Transferˆncia */
DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = YES.
                     
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        assign v_cod_finalid = {adinc/i05ad049.i 4 4} /* 4 - Transferˆncia */.
    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT "",
                                                  INPUT "CEP",
                                                  INPUT "",
                                                  INPUT v_cod_finalid,
                                                  INPUT TODAY,
                                                  OUTPUT v_cod_cta_ctbl,
                                                  OUTPUT v_des_cta_ctbl,
                                                  OUTPUT p-finalidade,
                                                  OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}
        
        if v_cod_cta_ctbl <> "" then
                        ASSIGN param-cp.ct-trans:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.

        if valid-handle(h_api_cta_ctbl) then
                                        delete object h_api_cta_ctbl.           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-trans V-table-Win
ON LEAVE OF param-cp.ct-trans IN FRAME f-main /* Conta Transferˆncia */
DO:
    {cdp/cdunif001a.i param-cp.ct-trans param-cp.sc-trans {&FRAME-NAME} TODAY """" """"} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.ct-trans V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.ct-trans IN FRAME f-main /* Conta Transferˆncia */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.sc-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-ordem V-table-Win
ON F5 OF param-cp.sc-ordem IN FRAME f-main /* C.Custo Ordem */
DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = YES.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN param-cp.sc-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.

    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.     
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-ordem V-table-Win
ON LEAVE OF param-cp.sc-ordem IN FRAME f-main /* C.Custo Ordem */
DO:
   {cdp/cdunif001d.i param-cp.sc-ordem {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.sc-ordem IN FRAME f-main /* C.Custo Ordem */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.sc-refugo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-refugo V-table-Win
ON F5 OF param-cp.sc-refugo IN FRAME f-main /* C.Custo Refugo Padr */
DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = YES.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN param-cp.sc-refugo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.     

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-refugo V-table-Win
ON LEAVE OF param-cp.sc-refugo IN FRAME f-main /* C.Custo Refugo Padr */
DO:
   {cdp/cdunif001d.i param-cp.sc-refugo {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-refugo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.sc-refugo IN FRAME f-main /* C.Custo Refugo Padr */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-cp.sc-trans
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-trans V-table-Win
ON F5 OF param-cp.sc-trans IN FRAME f-main /* C.Custo Transfer. */
DO:
  FIND FIRST param-global NO-LOCK NO-ERROR.
  ASSIGN i-ep-codigo-usuario = param-global.empresa-prin
         l-implanta          = YES.

    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT today,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    if v_cod_ccusto <> "" then
                ASSIGN param-cp.sc-trans:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-trans V-table-Win
ON LEAVE OF param-cp.sc-trans IN FRAME f-main /* C.Custo Transfer. */
DO:
   {cdp/cdunif001d.i param-cp.sc-trans {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-cp.sc-trans V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-cp.sc-trans IN FRAME f-main /* C.Custo Transfer. */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-usa-param-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-usa-param-linha V-table-Win
ON VALUE-CHANGED OF tg-usa-param-linha IN FRAME f-main /* Usa Dep¢sito e Varia‡Æo da Linha */
DO:
  ASSIGN param-cp.var-rep:SENSITIVE IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME} = NO
                 param-cp.var-transf:SENSITIVE  IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME}= NO
                 param-cp.var-req-menor:SENSITIVE IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME} = NO
                 param-cp.var-requis:SENSITIVE  IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME}= NO.
		      
  END.    

  /* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

        if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

        EMPTY TEMP-TABLE tt_log_erro.
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                                                                          INPUT "",
                                                                                                          INPUT TODAY,
                                                                                                          OUTPUT p_cod_format_cta_ctbl,
                                                                                                          OUTPUT TABLE tt_log_erro).

        assign v_cod_finalid = {adinc/i05ad049.i 4 4} /* 4 - Transferˆncia */
                   v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* MÆo-de-obra */

        if valid-handle(h_api_cta_ctbl) then
                        delete object h_api_cta_ctbl.   
                
  IF  param-cp.ct-trans:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.ct-refugo:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.ct-ordem:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.sc-trans:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.sc-refugo:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
  IF  param-cp.sc-ordem:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
  
  
  ASSIGN param-cp.ct-trans:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
         param-cp.ct-refugo:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
         param-cp.ct-ordem:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
         &if defined (bf_man_sfc_lc) &then
         c-conta-aplicacao:FORMAT IN FRAME {&frame-name} = p_cod_format_cta_ctbl
         &endif.
         
  {utp/ut-liter.i Reporte_Acabado *}
  assign param-cp.var-rep:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Requisi‡Æo_Transferˆncia *}
  assign param-cp.var-transf:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i %_Varia‡Æo_M¡nima *}
  assign param-cp.var-req-menor:label in frame {&frame-name} = return-value. 

  {utp/ut-liter.i %_Varia‡Æo_M xima *}
  assign param-cp.var-requis:label in frame {&frame-name} = return-value. 

&if defined (bf_man_sfc_lc) &then
    {utp/ut-field.i mgind param-cp conta-aplicacao 01}
    assign c-conta-aplicacao:label in frame {&frame-name} = return-value.
    IF c-conta-aplicacao:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
    IF c-ccusto-aplicacao:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.
&endif

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
  {src/adm/template/row-list.i "param-cp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-cp"}

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
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */
    ASSIGN param-cp.ct-trans      = INPUT FRAME {&frame-name} param-cp.ct-trans
           param-cp.sc-trans      = INPUT FRAME {&frame-name} param-cp.sc-trans
           param-cp.ct-ordem      = INPUT FRAME {&frame-name} param-cp.ct-ordem
           param-cp.sc-ordem      = INPUT FRAME {&frame-name} param-cp.sc-ordem
           param-cp.ct-refugo     = INPUT FRAME {&frame-name} param-cp.ct-refugo
           param-cp.sc-refugo     = INPUT FRAME {&frame-name} param-cp.sc-refugo
           param-cp.var-rep       = INPUT FRAME {&frame-name} param-cp.var-rep
           param-cp.var-requis    = INPUT FRAME {&frame-name} param-cp.var-requis
           param-cp.var-req-menor = INPUT FRAME {&frame-name} param-cp.var-req-menor
           param-cp.var-transf    = INPUT FRAME {&frame-name} param-cp.var-transf.

    &if defined (bf_man_sfc_lc) &then
        assign param-cp.cod-cta-unif = INPUT FRAME {&frame-name} c-conta-aplicacao.
        assign param-cp.cod-ccusto-unif = INPUT FRAME {&frame-name} c-ccusto-aplicacao.
    &endif
    
    ASSIGN l-usa-param-linha = INPUT FRAME {&FRAME-NAME} tg-usa-param-linha.
    
    RUN pi-assign-param-manuf.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/




  IF VALID-HANDLE(h_api_cta_ctbl) THEN
      DELETE OBJECT h_api_cta_ctbl.

  IF VALID-HANDLE(h_api_ccusto) THEN
      DELETE OBJECT h_api_ccusto.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  
  if avail param-cp then do:
        &if defined (bf_man_sfc_lc) &then
            assign c-conta-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = param-cp.cod-cta-unif
                   c-ccusto-aplicacao:SCREEN-VALUE IN FRAME {&frame-name} = param-cp.cod-ccusto-unif.
        &endif
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
        
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        IF INPUT FRAME {&frame-name} param-cp.ct-trans <> "" THEN DO:
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT FRAME {&frame-name} param-cp.ct-trans,
                                                       INPUT today,
                                                       OUTPUT p_log_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
                                                                                                           
    ASSIGN param-cp.sc-trans:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
        END.
        
        IF INPUT FRAME {&frame-name} param-cp.ct-refugo <> "" THEN DO:
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT FRAME {&frame-name} param-cp.ct-refugo,
                                                       INPUT today,
                                                       OUTPUT p_log_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
                                                                                                           
    ASSIGN param-cp.sc-refugo:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
        END.
        
        IF INPUT FRAME {&frame-name} param-cp.ct-ordem <> "" THEN DO:
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT FRAME {&frame-name} param-cp.ct-ordem,
                                                       INPUT today,
                                                       OUTPUT p_log_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
                                                                                                           
    ASSIGN param-cp.sc-ordem:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
        END.
        
        &if defined (bf_man_sfc_lc) &then
        IF INPUT FRAME {&frame-name} c-conta-aplicacao <> "" THEN DO:
        run pi_verifica_utilizacao_ccusto in h_api_ccusto (INPUT "",
                                                       INPUT "",
                                                       INPUT "",
                                                       INPUT FRAME {&frame-name} c-conta-aplicacao,
                                                       INPUT today,
                                                       OUTPUT p_log_ccusto,
                                                       OUTPUT TABLE tt_log_erro).
                                                                                                           
    ASSIGN c-ccusto-aplicacao:SENSITIVE IN FRAME {&frame-name} = p_log_ccusto.
        END.
        &endif
        
    RUN pi-trata-param-manuf.

    ASSIGN tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME} = l-usa-param-linha
                   param-cp.var-rep:SENSITIVE IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME} = NO
                   param-cp.var-transf:SENSITIVE  IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME}= NO
                   param-cp.var-req-menor:SENSITIVE IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME} = NO
                   param-cp.var-requis:SENSITIVE  IN FRAME {&FRAME-NAME} = tg-usa-param-linha:CHECKED IN FRAME {&FRAME-NAME}= NO.
        
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
  
  &if defined (bf_man_sfc_lc) &then
        assign c-conta-aplicacao:hidden in frame {&frame-name}    = no
               c-conta-aplicacao:sensitive in frame {&frame-name} = yes
               c-ccusto-aplicacao:hidden in frame {&frame-name}    = no
               c-ccusto-aplicacao:sensitive in frame {&frame-name} = yes.

        APPLY "leave" TO c-conta-aplicacao IN FRAME {&FRAME-NAME}.

  &endif
  
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  NOT AVAILABLE param-global THEN DO:
      BELL.
      RUN utp/utmsgs.p (input "show", input 16, input "").
      RETURN 'adm-error'.
  END.

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
  
  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* VALIDA€åES */  

   /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-param-manuf V-table-Win 
PROCEDURE pi-assign-param-manuf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-cp"
        AND param-manuf.cod-param = "l-usa-param-linha" EXCLUSIVE-LOCK:

     ASSIGN param-manuf.param-logico = l-usa-param-linha.
 END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-clear-formats V-table-Win 
PROCEDURE pi-clear-formats :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
        
        ASSIGN c-conta-aplicacao:FORMAT  IN FRAME {&frame-name} = "x(20)".
    ASSIGN param-cp.ct-ordem:FORMAT  IN FRAME {&frame-name} = "x(20)".
    ASSIGN param-cp.ct-refugo:FORMAT IN FRAME {&frame-name} = "x(20)".
    ASSIGN param-cp.ct-trans:FORMAT  IN FRAME {&frame-name} = "x(20)".
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-param-manuf V-table-Win 
PROCEDURE pi-trata-param-manuf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  FOR FIRST param-manuf
      WHERE param-manuf.cod-entid = "param-cp"
        AND param-manuf.cod-param = "l-usa-param-linha" NO-LOCK:
  END.

  IF NOT AVAIL param-manuf THEN DO:

      CREATE param-manuf.
      ASSIGN param-manuf.cod-entid = "param-cp"                      
             param-manuf.cod-param = "l-usa-param-linha"
             param-manuf.dsl-help-msg = "Se ativado, usa a fun‡Æo, obrigatoriamente o campo de dep¢sito ser  validado quanto a existˆncia."
             param-manuf.desc-param = "Usar a fun‡Æo, valida o campo de dep¢sito."
             param-manuf.titulo = "Usa Dep¢sito e Varia‡Æo da Linha".
  END.

  ASSIGN l-usa-param-linha = param-manuf.param-logico.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {include/i-vldfrm.i}
        
    DEFINE VARIABLE conta-trans AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE conta-ordem AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE conta-refugo AS CHARACTER   NO-UNDO.
    DEFINE VARIABLE conta-unif AS CHARACTER   NO-UNDO.
    
    ASSIGN conta-trans  = input frame {&frame-name} param-cp.ct-trans
           conta-ordem  = input frame {&frame-name} param-cp.ct-ordem
           conta-refugo = input frame {&frame-name} param-cp.ct-refugo
           conta-unif   = input frame {&frame-name} c-conta-aplicacao.
    
        
    /** TRANSFERENCIA **/
    empty temp-table tt_log_erro.
    if not valid-handle(h_api_cta_ctbl) then 
                run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                                                                   INPUT "",
                                                                                                   input-output conta-trans,
                                                                                                   INPUT TODAY,
                                                                                                   output p_des_titulo,
                                                                                                   output v_num_tip_cta_ctbl,
                                                                                                   output v_num_sit_cta_ctbl,
                                                                                                   output v_ind_finalid_cta,
                                                                                                   OUTPUT TABLE tt_log_erro).
        /** Busca finalidade conforme m¢dulo CEP **/
        RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        ""                     ,  /* EMPRESA EMS2          */ 
                                                                                                                  INPUT        "CEP"                  ,  /* M…DULO                */
                                                                                                                  INPUT        ""                     ,  /* PLANO DE CONTAS       */ 
                                                                                                                  INPUT        conta-trans            ,  /* CONTA                 */ 
                                                                                                                  INPUT        TODAY                  ,  /* DATA TRANSACAO        */ 
                                                                                                                  OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */
                                                                                                                  OUTPUT table tt_log_erro APPEND     ). /* ERROS                 */    
                                                                                                                  
    if can-find (first tt_log_erro) then do:
        {include/i-vldprg.i}
                {cdp/cdunif001b.i1}
        APPLY "entry" TO param-cp.ct-trans IN FRAME {&frame-name}.
        RETURN "adm-error".                           
    END.
        

    IF  param-global.modulo-ce = yes THEN DO:
        IF  LOOKUP({adinc/i05ad049.i 4 4},STRING(v_ind_finalid_cta)) = 0 THEN DO:
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (input "show",
                               input 747,
                               input "").
            APPLY "entry" TO param-cp.ct-trans IN FRAME {&frame-name}.
            RETURN "adm-error".
        END.
    END.
    

    /** ORDEM **/
    empty temp-table tt_log_erro.
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                                                          INPUT "",
                                                                                          input-output conta-ordem,
                                                                                          INPUT TODAY,
                                                                                          output p_des_titulo,
                                                                                          output v_num_tip_cta_ctbl,
                                                                                          output v_num_sit_cta_ctbl,
                                                                                          output v_ind_finalid_cta,
                                                                                          OUTPUT TABLE tt_log_erro).
        /** Busca finalidade conforme m¢dulo CEP **/
        RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        ""                     ,  /* EMPRESA EMS2          */ 
                                                                                                                  INPUT        "CEP"                  ,  /* M…DULO                */
                                                                                                                  INPUT        ""                     ,  /* PLANO DE CONTAS       */ 
                                                                                                                  INPUT        conta-ordem            ,  /* CONTA                 */ 
                                                                                                                  INPUT        TODAY                  ,  /* DATA TRANSACAO        */ 
                                                                                                                  OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */
                                                                                                                  OUTPUT table tt_log_erro APPEND     ). /* ERROS                 */                                                                                              
    
    if can-find (first tt_log_erro) then do:
        {include/i-vldprg.i}
        {cdp/cdunif001b.i1}
        APPLY "entry" TO param-cp.ct-ordem IN FRAME {&frame-name}.
        RETURN "adm-error".                           
    END.
    
    IF  param-global.modulo-ce = yes THEN DO:    
                DEFINE VARIABLE v_cod_des_finalidades AS CHARACTER.
                RUN cdp/cdunif004.p (INPUT "1,2,3,5,6", OUTPUT v_cod_des_finalidades).
                
                IF  LOOKUP(STRING(v_ind_finalid_cta),v_cod_des_finalidades) = 0 THEN DO:
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (input "show",
                               input 107,
                               input "").
            APPLY "entry" TO param-cp.ct-ordem IN FRAME {&frame-name}.
            RETURN "adm-error".
        END.
    END.
  

    /** REFUGO **/
    empty temp-table tt_log_erro.
    if not valid-handle(h_api_cta_ctbl) then 
                run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                                                                   INPUT "",
                                                   input-output conta-refugo,
                                                                                                   INPUT TODAY,
                                                                                                   output p_des_titulo,
                                                                                                   output v_num_tip_cta_ctbl,
                                                                                                   output v_num_sit_cta_ctbl,
                                                                                                   output v_ind_finalid_cta,
                                                                                                   OUTPUT TABLE tt_log_erro).
        /** Busca finalidade conforme m¢dulo CEP **/
        RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        ""                     ,  /* EMPRESA EMS2          */ 
                                                                                                                  INPUT        "CEP"                  ,  /* M…DULO                */
                                                                                                                  INPUT        ""                     ,  /* PLANO DE CONTAS       */ 
                                                                                                                  INPUT        conta-refugo           ,  /* CONTA                 */ 
                                                                                                                  INPUT        TODAY                  ,  /* DATA TRANSACAO        */ 
                                                                                                                  OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */
                                                                                                                  OUTPUT table tt_log_erro APPEND     ). /* ERROS                 */                                                                                                       
                                                                                                   
    if can-find (first tt_log_erro) then do:
        {include/i-vldprg.i}
        {cdp/cdunif001b.i1}
        APPLY "entry" TO param-cp.ct-refugo IN FRAME {&frame-name}.
        RETURN "adm-error".                           
    END.
    
    &if defined (bf_man_sfc_lc) &then
        /** REFUGO **/
        empty temp-table tt_log_erro.
        if not valid-handle(h_api_cta_ctbl) then 
                        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
                        
                run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (INPUT "",
                                                                                                           INPUT "",
                                                                                                           input-output conta-unif,
                                                                                                           INPUT TODAY,
                                                                                                           output p_des_titulo,
                                                                                                           output v_num_tip_cta_ctbl,
                                                                                                           output v_num_sit_cta_ctbl,
                                                                                                           output v_ind_finalid_cta,
                                                                                                           OUTPUT TABLE tt_log_erro).
                                                                                                           
                /** Busca finalidade conforme m¢dulo CEP **/
                RUN pi_busca_dados_cta_ctbl_integr IN h_api_cta_ctbl (INPUT        ""                     ,  /* EMPRESA EMS2          */ 
                                                                                                                          INPUT        "CEP"                  ,  /* M…DULO                */
                                                                                                                          INPUT        ""                     ,  /* PLANO DE CONTAS       */ 
                                                                                                                          INPUT        conta-unif             ,  /* CONTA                 */ 
                                                                                                                          INPUT        TODAY                  ,  /* DATA TRANSACAO        */ 
                                                                                                                          OUTPUT       v_ind_finalid_cta      ,  /* FINALIDADES DA CONTA  */
                                                                                                                          OUTPUT table tt_log_erro APPEND     ). /* ERROS                 */                                                                                                               
                                                                                                           
        if can-find (first tt_log_erro) then do:
            {include/i-vldprg.i}
            {cdp/cdunif001b.i1}
            apply 'entry' to c-conta-aplicacao in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
                
        IF  LOOKUP({adinc/i05ad049.i 4 2},STRING(v_ind_finalid_cta)) = 0 THEN DO:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show", input 15888, input "").
            apply "entry" to c-conta-aplicacao in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
                
                IF c-ccusto-aplicacao:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            empty temp-table tt_log_erro.
                        
            if not valid-handle(h_api_ccusto) then 
                                run prgint/utb/utb742za.py persistent set h_api_ccusto.
                                
                        run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                                                                           INPUT "",
                                                                                                           input frame {&frame-name} c-ccusto-aplicacao,
                                                                                                           INPUT TODAY,
                                                                                                           output p_des_titulo,
                                                                                                           OUTPUT TABLE tt_log_erro).
                                                                                                           
            if can-find (first tt_log_erro) then do:
                /** Centro de Custo nao cadastrado **/
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Centro_de_Custo_/_Aplica‡Æo" *}
                run utp/ut-msgs.p (input "show":U, input 56, input RETURN-VALUE).
                apply 'entry' to c-ccusto-aplicacao in frame {&frame-name}.
                                return 'ADM-ERROR':U.
            end.
        END.
                
    &endif

    IF param-cp.sc-trans:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
        empty temp-table tt_log_erro.
        if not valid-handle(h_api_ccusto) then 
                        run prgint/utb/utb742za.py persistent set h_api_ccusto.
                
                run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                                                                   INPUT "",
                                                                                                   input frame {&frame-name} param-cp.sc-trans,
                                                                                                   INPUT TODAY,
                                                                                                   output p_des_titulo,
                                                                                                   OUTPUT TABLE tt_log_erro).
                                                                                                   
        if can-find (first tt_log_erro) then do:
            /** Centro de Custo nao cadastrado **/
                        {cdp/cdunif001b.i1}
                        
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_de_Custo_/_Transferˆncia" *}
            run utp/ut-msgs.p (input "show":U, input 56, input RETURN-VALUE).
            return 'ADM-ERROR':U.
        end.
    END.    

    IF param-cp.sc-ordem:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
        empty temp-table tt_log_erro.
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
                run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                   INPUT "",
                                                   input frame {&frame-name} param-cp.sc-ordem,
                                                   INPUT TODAY,
                                                   output p_des_titulo,
                                                   OUTPUT TABLE tt_log_erro).
    
        if can-find (first tt_log_erro) then do:
            /** Centro de Custo nao cadastrado **/
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_de_Custo_/_Ordem" *}
            run utp/ut-msgs.p (input "show":U, input 56, input RETURN-VALUE).
            return 'ADM-ERROR':U.
        end.
    END. 

    IF param-cp.sc-refugo:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
        empty temp-table tt_log_erro.
        if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
                run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                                                   INPUT "",
                                                                                   input frame {&frame-name} param-cp.sc-refugo,
                                                                                   INPUT TODAY,
                                                                                   output p_des_titulo,
                                                                                   OUTPUT TABLE tt_log_erro).
    
        if can-find (first tt_log_erro) then do:
            /** Centro de Custo nao cadastrado **/
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Centro_de_Custo_/_Refugo" *}
            run utp/ut-msgs.p (input "show":U, input 56, input RETURN-VALUE).
            return 'ADM-ERROR':U.
        end.
    END. 


    find current param-cp exclusive-lock no-error.
    assign param-cp.ct-trans     = input frame {&frame-name} param-cp.ct-trans
           param-cp.sc-trans     = input frame {&frame-name} param-cp.sc-trans
           param-cp.ct-ordem     = input frame {&frame-name} param-cp.ct-ordem
           param-cp.sc-ordem     = input frame {&frame-name} param-cp.sc-ordem
           param-cp.ct-refugo    = input frame {&frame-name} param-cp.ct-refugo
           param-cp.sc-refugo    = input frame {&frame-name} param-cp.sc-refugo.
    &if defined (bf_man_sfc_lc) &then
        ASSIGN param-cp.cod-cta-unif = input frame {&frame-name} c-conta-aplicacao
               param-cp.cod-ccusto-unif = input frame {&frame-name} c-ccusto-aplicacao.
    &endif
      
        if valid-handle(h_api_cta_ctbl) then
                        delete object h_api_cta_ctbl.   
    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
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
  {src/adm/template/snd-list.i "param-cp"}

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

