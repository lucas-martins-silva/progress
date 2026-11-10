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
{include/i-prgvrs.i V02AD205 2.00.01.045 } /*** "010145" 18/07/2024 10:42:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02ad205 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var c-retorno  as character     no-undo.
def var c-handle   as char          no-undo.
def var h-handle   as handle        no-undo.
def var h_v01ad205 as handle        no-undo.
def var l-retorna  as logical.

def var h-vrf-modulo as handle.
def var c-modul      as char.
def var l-ok         as logical init yes.
def var c-modul-mec  as char             no-undo.
def var l-ok-mec     as logical init yes no-undo.

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-lm.i}     
&endif
DEFINE VARIABLE h-bofn088 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bofn068 AS HANDLE      NO-UNDO.

DEFINE VARIABLE p_cod_proced_ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_proced_fin AS CHARACTER   NO-UNDO.

DEFINE VARIABLE p_cod_prog_ini AS CHARACTER   NO-UNDO.
DEFINE VARIABLE p_cod_prog_fin AS CHARACTER   NO-UNDO.

DEFINE VARIABLE c_proced_dtsul AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c_modul_dtsul AS CHARACTER   NO-UNDO.

DEFINE VARIABLE iReturn  AS INTEGER     NO-UNDO.
DEFINE VARIABLE iVersion AS INTEGER     NO-UNDO.
DEFINE VARIABLE pDate    AS DATE        NO-UNDO.

DEFINE VARIABLE d-horizontal-gap-rect-3 AS DECIMAL   NO-UNDO.
DEFINE VARIABLE d-initial-row-rect-3    AS DECIMAL   NO-UNDO.
DEFINE VARIABLE h-acerto-ems2           AS HANDLE    NO-UNDO.
DEFINE VARIABLE c-list-habilit-func     AS CHARACTER NO-UNDO.
DEFINE VARIABLE c-list-desabilit-func   AS CHARACTER NO-UNDO.
DEFINE VARIABLE l-func-integr-habilit   AS LOGICAL   NO-UNDO.

{cdp/cdcfgdis.i} /*include para prÇ-processadores*/
{cdp/cdcfgmnt.i}

/* miniflexibilizaá∆o */
{cdp/cdcfgfin.i}
{cdp/cdcfgman.i} /* miniflexibilizaá∆o manufatura */

/*EMBALAGEM*/
{cdp/cd9999.i4}

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
&Scoped-Define ENABLED-FIELDS param-global.modulo-ge param-global.modulo-ap ~
param-global.modulo-cr param-global.modulo-cb param-global.modulo-ae ~
param-global.modulo-ca param-global.modulo-pt param-global.modulo-ct ~
param-global.modulo-fc param-global.modulo-05 param-global.modulo-en ~
param-global.modulo-cp param-global.modulo-cs param-global.modulo-pl ~
param-global.modulo-dp param-global.modulo-co param-global.modulo-pc ~
param-global.modulo-pm param-global.modulo-ed param-global.modulo-bh ~
param-global.modulo-mp param-global.modulo-fp param-global.modulo-cl ~
param-global.modulo-ch param-global.modulo-sws param-global.modulo-vc ~
param-global.modulo-per-ppm param-global.modulo-mi param-global.modulo-pi ~
param-global.modulo-po 
&Scoped-define ENABLED-TABLES param-global
&Scoped-define FIRST-ENABLED-TABLE param-global
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-6 RECT-7 RECT-8 tg-modulo-bgc ~
tg-modulo-mgl tg-modulo-cfl tg-agroindustria tg-gestao-graos tg-calibracao ~
tg-preditiva 
&Scoped-Define DISPLAYED-FIELDS param-global.modulo-ge ~
param-global.modulo-ap param-global.modulo-cr param-global.modulo-cb ~
param-global.modulo-ae param-global.modulo-ca param-global.modulo-pt ~
param-global.modulo-ct param-global.modulo-fc param-global.modulo-05 ~
param-global.modulo-en param-global.modulo-cp param-global.modulo-cs ~
param-global.modulo-pl param-global.modulo-dp param-global.modulo-co ~
param-global.modulo-pc param-global.modulo-pm param-global.modulo-ed ~
param-global.modulo-bh param-global.modulo-mp param-global.modulo-fp ~
param-global.modulo-cl param-global.modulo-ch param-global.modulo-sws ~
param-global.modulo-vc param-global.modulo-per-ppm param-global.modulo-mi ~
param-global.modulo-pi param-global.modulo-po 
&Scoped-define DISPLAYED-TABLES param-global
&Scoped-define FIRST-DISPLAYED-TABLE param-global
&Scoped-Define DISPLAYED-OBJECTS tg-modulo-rac tg-modulo-mec tg-modulo-bgc ~
tg-modulo-mgl tg-modulo-cfl tg-log-business tg-datasulNet ~
tg-agroindustria tg-gestao-graos tg-calibracao tg-preditiva 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS param-global.modulo-ge ~
param-global.modulo-ap param-global.modulo-cr param-global.modulo-cb ~
param-global.modulo-ae param-global.modulo-ca param-global.modulo-pt ~
param-global.modulo-ct param-global.modulo-fc param-global.modulo-en ~
param-global.modulo-cp param-global.modulo-cs param-global.modulo-pl ~
param-global.modulo-dp param-global.modulo-co param-global.modulo-pc ~
param-global.modulo-pm param-global.modulo-ed param-global.modulo-bh ~
param-global.modulo-mp param-global.modulo-fp param-global.modulo-cl ~
param-global.modulo-ch param-global.modulo-mi param-global.modulo-pi 

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
DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 8.92.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 8.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 44 BY 6.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 43 BY 6.92.

DEFINE VARIABLE tg-agroindustria AS LOGICAL INITIAL no 
     LABEL "Agroind£stria" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-calibracao AS LOGICAL INITIAL no 
     LABEL "Calibracao" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-datasulNet AS LOGICAL INITIAL no 
     LABEL "DatasulNet" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tg-gestao-graos AS LOGICAL INITIAL no 
     LABEL "Gest∆o de Gr∆os" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-business AS LOGICAL INITIAL no 
     LABEL "Business-to-Business" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE tg-modulo-bgc AS LOGICAL INITIAL no 
     LABEL "Execuá∆o Oráament†ria" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .75 NO-UNDO.

DEFINE VARIABLE tg-modulo-cfl AS LOGICAL INITIAL no 
     LABEL "Fluxo de Caixa" 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE tg-modulo-mec AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.

DEFINE VARIABLE tg-modulo-mgl AS LOGICAL INITIAL no 
     LABEL "Contabilidade Gerencial" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.29 BY .75 NO-UNDO.

DEFINE VARIABLE tg-modulo-rac AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-preditiva AS LOGICAL INITIAL no 
     LABEL "Preditiva" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-global.modulo-ge AT ROW 1.29 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 12.57 BY .75
     param-global.modulo-ap AT ROW 1.96 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 17.86 BY .75
     param-global.modulo-cr AT ROW 2.67 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 20.14 BY .75
     param-global.modulo-cb AT ROW 3.38 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 18.29 BY .75
     param-global.modulo-ae AT ROW 4.04 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .83
     param-global.modulo-ca AT ROW 4.75 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 25.29 BY .75
     param-global.modulo-pt AT ROW 5.46 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 13.72 BY .75
     param-global.modulo-ct AT ROW 6.17 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 16.43 BY .75
     param-global.modulo-fc AT ROW 6.88 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 13.29 BY .75
     param-global.modulo-05 AT ROW 7.54 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 14.43 BY .83
     tg-modulo-rac AT ROW 8.25 COL 2.72
     tg-modulo-mec AT ROW 8.96 COL 2.72
     tg-modulo-bgc AT ROW 9.5 COL 2.72 WIDGET-ID 6
     tg-modulo-mgl AT ROW 9.5 COL 2.72 WIDGET-ID 4
     tg-modulo-cfl AT ROW 9.75 COL 2.72 WIDGET-ID 2
     param-global.modulo-en AT ROW 10.33 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .75
     param-global.modulo-cp AT ROW 11.04 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 12.43 BY .75
     param-global.modulo-cs AT ROW 11.75 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 10.14 BY .71
     param-global.modulo-pl AT ROW 12.42 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 16.43 BY .75
     param-global.modulo-dp AT ROW 13.13 COL 2.72
          LABEL "Desenv. Produtos":L29
          VIEW-AS TOGGLE-BOX
          SIZE 25.43 BY .75
     param-global.modulo-co AT ROW 13.83 COL 2.72
          LABEL "Configurador Produtos":L29
          VIEW-AS TOGGLE-BOX
          SIZE 24.57 BY .75
     param-global.modulo-pc AT ROW 14.54 COL 2.72
          LABEL "Planej. da Capacidade":L31
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .75
     param-global.modulo-pm AT ROW 15.25 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .75
     param-global.modulo-ed AT ROW 1.29 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .75
     param-global.modulo-bh AT ROW 1.92 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     param-global.modulo-mp AT ROW 2.67 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .75
     param-global.modulo-fp AT ROW 3.38 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .75
     param-global.modulo-cl AT ROW 4.04 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .75
     tg-log-business AT ROW 4.71 COL 48
     tg-datasulNet AT ROW 5.42 COL 48
     tg-agroindustria AT ROW 6.13 COL 48
     tg-gestao-graos AT ROW 6.83 COL 48
     param-global.modulo-ch AT ROW 9.58 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .75
     param-global.modulo-sws AT ROW 10.17 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 12.14 BY .83 TOOLTIP "4"

     param-global.modulo-vc AT ROW 10.83 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 24 BY .83
     param-global.modulo-per-ppm AT ROW 11.54 COL 48
          LABEL "Concentraá∆o/PPM":L15
          VIEW-AS TOGGLE-BOX
          SIZE 25.72 BY .83
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.
/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     param-global.modulo-mi AT ROW 12.25 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 23.43 BY .75
     param-global.modulo-pi AT ROW 12.96 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 22.43 BY .75
     param-global.modulo-po AT ROW 13.63 COL 48
          VIEW-AS TOGGLE-BOX
          SIZE 23.72 BY .83
     tg-calibracao AT ROW 14.33 COL 48
     tg-preditiva AT ROW 15.04 COL 48
     RECT-3 AT ROW 1.17 COL 1
     RECT-6 AT ROW 1.17 COL 46
     RECT-7 AT ROW 10.25 COL 1
     RECT-8 AT ROW 9.33 COL 46
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


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
         HEIGHT             = 15.33
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
   NOT-VISIBLE Size-to-Fit 3 L-To-R,COLUMNS                             */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ae IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ap IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-bh IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ca IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cb IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ch IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cl IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-co IN FRAME f-main
   3 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cp IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-cs IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ct IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-dp IN FRAME f-main
   3 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ed IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-en IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-fc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-fp IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-ge IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-mi IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-mp IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pc IN FRAME f-main
   3 EXP-LABEL                                                          */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-per-ppm IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pi IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pl IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pm IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX param-global.modulo-pt IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX tg-datasulNet IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-log-business IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-modulo-bgc:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       tg-modulo-cfl:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-modulo-mec IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-modulo-mgl:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-modulo-rac IN FRAME f-main
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

&Scoped-define SELF-NAME param-global.modulo-bh
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.modulo-bh V-table-Win
ON VALUE-CHANGED OF param-global.modulo-bh IN FRAME f-main /* Bancos Hist¢ricos */
DO:

  assign l-retorna = param-global.modulo-bh:checked.
  run pi-muda-valor in h_v01ad205 (input l-retorna).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.modulo-dp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.modulo-dp V-table-Win
ON VALUE-CHANGED OF param-global.modulo-dp IN FRAME f-main /* Desenv. Produtos */
DO:
  RUN get-link-handle IN adm-broker-hdl (input  this-procedure,
                                         input  "state-target",
                                         output c-handle).
  ASSIGN h-handle = widget-handle(c-handle).
  RUN pi-estado-campo IN h-handle (input (PARAM-GLOBAL.MODULO-EN:CHECKED OR 
                                          PARAM-GLOBAL.MODULO-DP:CHECKED)).   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-global.modulo-en
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-global.modulo-en V-table-Win
ON VALUE-CHANGED OF param-global.modulo-en IN FRAME f-main /* Engenharia */
DO:
  RUN get-link-handle IN adm-broker-hdl (input  this-procedure,
                                         input  "state-target",
                                         output c-handle).
  ASSIGN h-handle = widget-handle(c-handle).
  RUN pi-estado-campo IN h-handle (input (PARAM-GLOBAL.MODULO-EN:CHECKED OR 
                                          PARAM-GLOBAL.MODULO-DP:CHECKED)).                                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-modulo-rac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-modulo-rac V-table-Win
ON VALUE-CHANGED OF tg-modulo-rac IN FRAME f-main
DO:

/*
    if input frame {&FRAME-NAME} tg-modulo-rac = no then do:
        run utp/ut-msgs.p (input "show",
                           input 19367,
                           input "").
        if return-value = "no" then
            assign tg-modulo-rac:screen-value in frame {&FRAME-NAME} = "yes".
    end.
*/
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

{utp/ut-liter.i Comiss‰es_-_RAC * R}
assign tg-modulo-rac:label in frame {&FRAME-NAME} = return-value.

{utp/ut-liter.i CÉmbio * R}
assign tg-modulo-mec:label in frame {&FRAME-NAME} = return-value.

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
/*----------------------f--------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  /********Calibraá∆o*****/

   &IF DEFINED (bf_mnt_ems205) &THEN
      if  tg-calibracao:checked in frame {&frame-name} then
          assign param-global.log-modul-calib = yes.
      else
          assign param-global.log-modul-calib = no.
  &else
      if  tg-calibracao:checked in frame {&frame-name} then
          assign substring(param-global.char-2,100,1)= "2".
      else
          assign substring(param-global.char-2,100,1)= "1".
  &endif


  /***** Antes da 2.06 utiliza atributo livre ********/
  &IF DEFINED (bf_man_206) &THEN
      if  tg-agroindustria:checked in frame {&frame-name} then
          assign param-global.ind-int-agro = YES.
      else
          assign param-global.ind-int-agro = NO.
  &ELSE
     if  tg-agroindustria:checked in frame {&frame-name} THEN 
          assign substring(param-global.char-2,21,1)= "1".
      else
          assign substring(param-global.char-2,21,1)= "0".
  &endif
     
/* Validaá∆o para o modulo de EMBALAGEM */

/*if l-embalagem and tg-embalagem:checked in frame {&frame-name} then
 *    assign param-global.dec-2 = 1.
 *    else assign param-global.dec-2 = 0. */

/* Validaá∆o para o m¢dulo Gest∆o de Gr∆os */
 DEFINE VARIABLE l-graos-desmarcado AS LOGICAL INIT NO NO-UNDO.

  &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then
      &if '{&BF_DIS_VERSAO_EMS}' >= '2.08' &then
          if tg-gestao-graos:checked in frame {&FRAME-NAME} then
              assign param-global.log-modul-gg = YES.
          else
              assign param-global.log-modul-gg = NO
                     l-graos-desmarcado = YES.
      &ELSE
          if tg-gestao-graos:checked in frame {&FRAME-NAME} THEN
              ASSIGN OVERLAY(param-global.char-2,33,1)= "1". /*** 1-Sim ***/
          ELSE
              ASSIGN OVERLAY(param-global.char-2,33,1)= "0"  /*** 0-N∆o ***/
                     l-graos-desmarcado = YES. 
      &endif 
      
      IF l-graos-desmarcado THEN DO:
          FOR EACH user-coml EXCLUSIVE-LOCK:
              &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then
                  &if '{&BF_DIS_VERSAO_EMS}' < '2.08' &then
                      ASSIGN SUBSTR(user-coml.char-1,36,1) = "n".
                  &ELSE
                      ASSIGN user-coml.log-inf-safra = NO.         
                  &ENDIF.
              &ENDIF. 
          END.  
      END.
  &endif   

  /* Datasulnet */
  if tg-datasulNet:checked in frame {&frame-name} then
     assign param-global.log-datasulnet = yes.
  else
     assign param-global.log-datasulnet = no.

  /* Neogrid */
  if tg-log-business:checked in frame {&frame-name} then
     assign param-global.log-business = yes.
  else
     assign param-global.log-business = no.

  RUN pi-preditiva (INPUT 1).
  run pi-funcao (input 1).
  run pi-funcao-mec (input 1).

  &IF DEFINED(BF_FIN_FIXAR_PARAM) &THEN
      
      RUN cdp/cd0027.p PERSISTENT SET h-acerto-ems2.
      
      ASSIGN c-list-habilit-func   = ""
             c-list-desabilit-func = "".  
     
      IF tg-modulo-mgl:CHECKED IN FRAME {&FRAME-NAME} THEN
          ASSIGN c-list-habilit-func = c-list-habilit-func + "adm-mdl-ems-5.00,".                                    
      ELSE
          ASSIGN c-list-desabilit-func = c-list-desabilit-func + "adm-mdl-ems-5.00,".
                              
      IF tg-modulo-bgc:CHECKED IN FRAME {&FRAME-NAME} THEN
          ASSIGN c-list-habilit-func = c-list-habilit-func + "spp-bgc-ems-5.00".                             
      ELSE
          ASSIGN c-list-desabilit-func = c-list-desabilit-func + "spp-bgc-ems-5.00".
                                   
      
      RUN pi-habilita-funcoes-integr IN h-acerto-ems2(INPUT c-list-habilit-func,
                                                      INPUT YES).

      RUN pi-habilita-funcoes-integr IN h-acerto-ems2(INPUT c-list-desabilit-func,
                                                      INPUT NO).

      DELETE PROCEDURE h-acerto-ems2.

  &ENDIF


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
  
  /******Calibraá∆o****/
    &IF DEFINED (bf_mnt_ems205) &THEN
         if  connected("mgmnt")
              and connected("movmnt") then do:
                ASSIGN tg-calibracao = param-global.log-modul-calib.
         end.
     &ELSE
               ASSIGN tg-calibracao = SUBSTRING(param-global.char-2,100,1) = "2".

     &ENDIF
     
     &IF DEFINED (bf_man_206) &THEN
         IF param-global.ind-int-agro = NO THEN
            ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
         ELSE 
            ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
     &ELSE
         IF int(SUBSTRING(param-global.char-2,21,1)) = 0 THEN
            ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
         ELSE IF int(SUBSTRING(param-global.char-2,21,1)) = 1 THEN
            ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
     &endif
     
    /* Validaá∆o para o m¢dulo Gest∆o de Gr∆os */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then
        &if '{&BF_DIS_VERSAO_EMS}' >= '2.08' &then
            IF param-global.log-modul-gg = NO THEN
                ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
            ELSE
                ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
        &ELSE
            IF SUBSTRING(param-global.char-2,33,1) = "1" THEN
                ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
            ELSE
                ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
        &ENDIF  
    &ENDIF  
    
  /* DatasulNet */
  if  param-global.log-datasulnet then
      assign tg-datasulNet = true.
  else
      assign tg-datasulNet = false.

  /* DatasulNet */

  /* NeoGrid */

  if  param-global.log-business then
      assign tg-log-business = true.
  else
      assign tg-log-business = false.

  /* NeoGrid */

  &IF DEFINED (BF_FIN_FIXAR_PARAM) &THEN
        RUN cdp/cd0027.p PERSISTENT SET h-acerto-ems2.

        RUN pi-verifica-habilit-funcao-integr IN h-acerto-ems2(INPUT "adm-cfl-ems-5.00",
                                                               OUTPUT l-func-integr-habilit).
        IF l-func-integr-habilit THEN
            ASSIGN tg-modulo-cfl:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
        ELSE
            ASSIGN tg-modulo-cfl:CHECKED IN FRAME {&FRAME-NAME} = FALSE.

        
        RUN pi-verifica-habilit-funcao-integr IN h-acerto-ems2(INPUT "adm-mdl-ems-5.00",
                                                               OUTPUT l-func-integr-habilit).
        IF l-func-integr-habilit THEN
            ASSIGN tg-modulo-mgl:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
        ELSE
            ASSIGN tg-modulo-mgl:CHECKED IN FRAME {&FRAME-NAME} = FALSE.


        RUN pi-verifica-habilit-funcao-integr IN h-acerto-ems2(INPUT "spp-bgc-ems-5.00",
                                                               OUTPUT l-func-integr-habilit).
        IF l-func-integr-habilit THEN
            ASSIGN tg-modulo-bgc:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
        ELSE
            ASSIGN tg-modulo-bgc:CHECKED IN FRAME {&FRAME-NAME} = FALSE. 

        DELETE PROCEDURE h-acerto-ems2.
  &ENDIF
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
/* Pre-processor para o modulo de EMBALAGEM */
/*if l-embalagem = yes then do:
 *    assign tg-embalagem:sensitive in frame {&frame-name} = yes.
 *    if param-global.dec-2 = 1 then
 *       assign tg-embalagem:checked in frame {&frame-name} = yes.
 *    else assign tg-embalagem:checked in frame {&frame-name} = no.
 * end.   
 * else assign tg-embalagem:sensitive in frame {&frame-name} = no.
 *  */

  RUN pi-preditiva (INPUT 2).  
  run pi-funcao (input 2).
  run pi-funcao-mec (input 2).
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

    def var l-modulo-ap as log no-undo.
    def var l-modulo-cr as log no-undo.
    def var l-modulo-cb as log no-undo.
    def var l-modulo-ae as log no-undo.
    def var l-modulo-pt as log no-undo.
    def var l-modulo-ct as log no-undo.
    def var l-modulo-fc as log no-undo.

    def var l-modulo-in as log no-undo.

    def var l-modulo-ce as log no-undo.
    def var l-modulo-cp as log no-undo.
    def var l-modulo-cc as log no-undo.
    def var l-modulo-re as log no-undo.
    def var l-modulo-cs as log no-undo.
    def var l-modulo-cq as log no-undo.
    def var l-modulo-cn as log no-undo.

    def var l-modulo-mi as log no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  run pi-funcao (input 3).
  run pi-funcao-mec (input 3).

  /* Code placed here will execute AFTER standard behavior.    */

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
    do  with frame {&frame-name}:
        if  connected("mgadm") 
        and connected("movadm")
        and ldbname("movadm") = "movadm" then do:
            run cdp/cd0101c.p (buffer param-global,
                               output l-modulo-ap,
                               output l-modulo-cr,
                               output l-modulo-cb,
                               output l-modulo-ae,
                               output l-modulo-pt,
                               output l-modulo-ct,
                               output l-modulo-fc).

            assign param-global.modulo-ap:sensitive in frame {&frame-name} = l-modulo-ap
                   param-global.modulo-cr:sensitive in frame {&frame-name} = l-modulo-cr
                   param-global.modulo-cb:sensitive in frame {&frame-name} = l-modulo-cb
                   param-global.modulo-ae:sensitive in frame {&frame-name} = l-modulo-ae        
                   param-global.modulo-pt:sensitive in frame {&frame-name} = l-modulo-pt
                   param-global.modulo-ct:sensitive in frame {&frame-name} = l-modulo-ct
                   param-global.modulo-fc:sensitive in frame {&frame-name} = l-modulo-fc.
        end.

        if  connected("mgdis")
        and connected("movdis") then do:
            
             &IF DEFINED (bf_mnt_ems203) &THEN
                 if  connected("mgmnt")
                     and connected("movmnt") then do:
                         assign tg-calibracao           = SUBSTRING(param-global.char-2,100,1) = "2"
                                tg-calibracao:sensitive = yes.
                 end.
            &ELSE
                assign tg-calibracao:sensitive = no. 
            &ENDIF

            &IF DEFINED (bf_man_206) &THEN
                IF param-global.ind-int-agro = NO THEN
                   ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
                ELSE 
                   ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
            &ELSE
                IF int(SUBSTRING(param-global.char-2,21,1)) = 0 THEN
                   ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
                ELSE IF int(SUBSTRING(param-global.char-2,21,1)) = 1 THEN
                   ASSIGN tg-agroindustria:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
            &endif

        end.

        /*** Validaá∆o para o m¢dulo Gest∆o de Gr∆os ***/
        if connected("emsgra") then do:            
            /* Validaá∆o para o m¢dulo Gest∆o de Gr∆os */
            &if '{&BF_DIS_VERSAO_EMS}' >= '2.062' &then
                ASSIGN tg-gestao-graos:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
                &if '{&BF_DIS_VERSAO_EMS}' >= '2.08' &then
                    IF param-global.log-modul-gg = NO THEN
                        ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
                    ELSE
                        ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
                &ELSE
                    IF SUBSTRING(param-global.char-2,33,1) = "1" THEN
                        ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = TRUE.
                    ELSE
                        ASSIGN tg-gestao-graos:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
                &ENDIF 
            &ELSE
                ASSIGN tg-gestao-graos:SENSITIVE IN FRAME {&FRAME-NAME} = NO.                
            &ENDIF
        end.
        ELSE
            ASSIGN tg-gestao-graos:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
        /*** Fim ***/

        if  connected("mgind")
        and connected("movind") then do:
            run cdp/cd0101e.p (buffer param-global,
                               output l-modulo-ce,
                               output l-modulo-cp,
                               output l-modulo-cc,
                               output l-modulo-re,
                               output l-modulo-cs,
                               output l-modulo-cq,
                               output l-modulo-cn).

            assign param-global.modulo-cp:sensitive in frame {&frame-name} = l-modulo-cp 
                   param-global.modulo-cs:sensitive in frame {&frame-name} = l-modulo-cs.

            /* DatasulNet */

            if  param-global.log-datasulnet then
                assign tg-datasulNet = true.
            else
                assign tg-datasulNet = false.

            assign tg-datasulNet:sensitive = yes.

            /* DatasulNet */

            /* NeoGrid */

            if  param-global.log-business then
                assign tg-log-business = true.
            else
                assign tg-log-business = false.

            assign tg-log-business:sensitive = yes.

            /* NeoGrid */


        end.

        &IF DEFINED (bf_mnt_ems203) &THEN
            if  connected("mgmnt")
            and connected("movmnt") then do:
                run cdp/cd0101g.p (buffer param-global,
                                   output l-modulo-mi).

                assign param-global.modulo-mi:sensitive in frame {&frame-name} = l-modulo-mi.
            end.
        &ELSE
            if  connected("mgind")
            and connected("movind") then do:
                run cdp/cd0101g.p (buffer param-global,
                                   output l-modulo-mi).

                assign param-global.modulo-mi:sensitive in frame {&frame-name} = l-modulo-mi.
            end.
        &ENDIF
        
        assign l-retorna = param-global.modulo-bh:checked.
        run pi-muda-valor in h_v01ad205 (input l-retorna).

        &IF "{&mguni_version} " >= "2.08" &THEN
            assign param-global.modulo-mp:SENSITIVE in frame {&frame-name} = no
                   param-global.modulo-mp:CHECKED IN FRAME {&FRAME-NAME} = FALSE.
        &ELSE
            assign param-global.modulo-mp:SENSITIVE in frame {&frame-name} = YES.
        &ENDIF
        
       &IF DEFINED (BF_FIN_FIXAR_PARAM) &THEN
            
            HIDE param-global.modulo-ge IN FRAME {&FRAME-NAME}
                 param-global.modulo-ca IN FRAME {&FRAME-NAME}
                 tg-modulo-rac          IN FRAME {&FRAME-NAME}.

            ENABLE tg-modulo-cfl 
                   tg-modulo-mgl 
                   tg-modulo-bgc WITH FRAME {&FRAME-NAME}.
            
            ASSIGN d-initial-row-rect-3    = 1.30
                   d-horizontal-gap-rect-3 = 0.70.
                
            assign param-global.modulo-ap:row in frame {&FRAME-NAME} = d-initial-row-rect-3
                   param-global.modulo-cr:row in frame {&FRAME-NAME} = param-global.modulo-ap:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   param-global.modulo-cb:row in frame {&FRAME-NAME} = param-global.modulo-cr:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   tg-modulo-cfl:row in frame {&FRAME-NAME}          = param-global.modulo-cb:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   param-global.modulo-ae:row in frame {&FRAME-NAME} = tg-modulo-cfl:row in frame {&FRAME-NAME}          + d-horizontal-gap-rect-3
                   param-global.modulo-pt:row in frame {&FRAME-NAME} = param-global.modulo-ae:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   param-global.modulo-ct:row in frame {&FRAME-NAME} = param-global.modulo-pt:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   tg-modulo-mgl:row in frame {&FRAME-NAME}          = param-global.modulo-ct:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   param-global.modulo-fc:row in frame {&FRAME-NAME} = tg-modulo-mgl:row in frame {&FRAME-NAME}          + d-horizontal-gap-rect-3
                   param-global.modulo-05:row in frame {&FRAME-NAME} = param-global.modulo-fc:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   tg-modulo-bgc:row in frame {&FRAME-NAME}          = param-global.modulo-05:row in frame {&FRAME-NAME} + d-horizontal-gap-rect-3
                   tg-modulo-mec:row in frame {&FRAME-NAME}          = tg-modulo-bgc:row in frame {&FRAME-NAME}          + d-horizontal-gap-rect-3.
                   
        &ENDIF
   
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

  {utp/ut-liter.i Vendor * R}
  assign param-global.modulo-05:label in frame {&FRAME-NAME} = trim(return-value).

  {utp/ut-liter.i FASB/CMCAC}
  assign param-global.modulo-fc:label in frame {&frame-name} = trim(return-value).

  {utp/ut-liter.i Desenvolvimento_de_Produtos * R}
  assign param-global.modulo-dp:label in frame {&frame-name} = trim(return-value). 

  {utp/ut-liter.i Configurador_de_Produtos * R}
  assign param-global.modulo-co:label in frame {&frame-name} = trim(return-value).   

  {utp/ut-liter.i Planejamento_da_Capacidade * R}
  assign param-global.modulo-pc:label in frame {&frame-name} = trim(return-value).   

  {utp/ut-liter.i Controle_de_Potància * R}
  assign param-global.modulo-per-ppm:label in frame {&frame-name} = trim(return-value).   

  {utp/ut-liter.i Admin._do_Valor_do_Configurador * R}
  assign param-global.modulo-vc:label in frame {&frame-name} = trim(return-value).   

    &IF DEFINED (bf_man_sfc_lc) &THEN
        if  connected("mgaps") then do:
            {utp/ut-liter.i APS}
            assign param-global.modulo-sws:label in frame {&frame-name} = trim(return-value).

            {utp/ut-liter.i Indica_se_o_APS_est†_implantado}
            assign param-global.modulo-sws:help in frame {&frame-name} = trim(return-value).
        end.
        ELSE
            assign param-global.modulo-sws:visible in frame {&frame-name} = no.            
    &ELSE
        assign param-global.modulo-sws:visible in frame {&frame-name} = no.
    &ENDIF
    
  &IF "{&EMSFND_VERSION}" >= "1.00" &THEN
  ASSIGN p_cod_prog_ini = "rc0101"
         p_cod_prog_fin = "rc0101".

  IF  v_log_license_manager THEN DO:
      IF VALID-HANDLE(v_hdl_license_manager) THEN DO:
    
      /*Programa*/
      RUN fnbo/bofn068.p PERSISTENT SET h-bofn068.
    
      IF VALID-HANDLE(h-bofn068) THEN DO:
          RUN setConstraintByCodProg IN h-bofn068 
              (INPUT p_cod_prog_ini, INPUT p_cod_prog_fin).
          RUN openQueryStatic IN h-bofn068 (INPUT "ByCodProg":U).
          IF  RETURN-VALUE = 'OK' THEN
              RUN getCharField IN h-bofn068
                  (INPUT "cod_proced", OUTPUT c_proced_dtsul).
    
          ASSIGN p_cod_proced_ini = c_proced_dtsul
                 p_cod_proced_fin = c_proced_dtsul.
          
          RUN destroy IN h-bofn068.
      END.
    
      /*Procedimento*/
      RUN fnbo/bofn088.p PERSISTENT SET h-bofn088.
        
      IF  VALID-HANDLE(h-bofn088) THEN DO:
          RUN setConstraintByCodProced IN h-bofn088 
              (INPUT p_cod_proced_ini, INPUT p_cod_proced_fin).
          RUN openQueryStatic IN h-bofn088 (INPUT "ByCodProced":U).
        
          IF  RETURN-VALUE = 'OK' THEN
              RUN getCharField IN h-bofn088
                  (INPUT "cod_modul_dtsul", OUTPUT c_modul_dtsul).
        
              RUN destroy IN h-bofn088.
          END. 
    
          /*  Executar checkModule LM */
          RUN checkModule IN v_hdl_license_manager
              (INPUT  c_modul_dtsul,
               OUTPUT iReturn,
               OUTPUT pDate,
               OUTPUT iVersion).
    
    /*      Tipo de retorno =    0: modulo nao contratado
                                 1: data invalida
                                 2: versao invalida
                                 3: OK
    */
      END.
       ASSIGN l-ok = (iReturn = 3).
  END.
  &else
  
  run cdp/cdapi524.p persistent set h-vrf-modulo.

  run verifica_modulo in h-vrf-modulo (input "rc0101", /*procedimento*/
                                       input "", /*programa*/
                                       output c-modul,
                                       output l-ok).
  delete procedure h-vrf-modulo.
  &endif
  run pi-funcao (input 3).
  ASSIGN l-ok-mec = YES.
  run pi-funcao-mec (input 3).

  &IF DEFINED (BF_FIN_FIXAR_PARAM) &THEN

      ASSIGN param-global.modulo-pt:LABEL IN FRAME {&FRAME-NAME} = "Ativo Fixo"
             param-global.modulo-ct:LABEL IN FRAME {&FRAME-NAME} = "Contabilidade Fiscal".

  &ENDIF
  
  

  /* FO - 1537834 e 1541560 */
  /* Retirar campo da tela cd0101 release 2.05 e 2.06b*/
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-funcao V-table-Win 
PROCEDURE pi-funcao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define input param p-ind as int no-undo.

&IF DEFINED(BF_FIN_RAC) &THEN
    if l-ok then do:
        case p-ind:
            when 1 then do:   /* assign-record */ 
                if  tg-modulo-rac:checked in frame {&frame-name} = yes then
                    assign param-global.modulo-rac = yes.
                else do:
                    if tg-modulo-rac:checked in frame {&frame-name} = no 
                    and param-global.modulo-rac = yes then do:
                        run utp/ut-msgs.p (input "show",
                                           input 19367,
                                           input "").
                        if return-value = "no" then
                            assign param-global.modulo-rac = yes.
                        else
                            assign param-global.modulo-rac = no.
                    end.
                    else
                        assign param-global.modulo-rac = no.
                end.
            end.
            when 2 then /* display */
            do:
                if avail param-global then 
                    assign tg-modulo-rac:screen-value in frame {&FRAME-NAME} = string(param-global.modulo-rac).
            end.
            when 3 then /* initialize */
            do:
                assign tg-modulo-rac:sensitive in frame {&FRAME-NAME} = yes.
            end.
        end.
    end.
    else 
        if avail param-global and
           p-ind = 1 then assign param-global.modulo-rac = no.
&ENDIF          

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-funcao-mec V-table-Win 
PROCEDURE pi-funcao-mec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input param p-ind as int no-undo.

    &IF DEFINED(BF_FIN_MODUL_CAMBIO) &THEN
        if l-ok-mec then do:
            case p-ind:
                when 1 then do:   /* assign-record */
                    assign param-global.modulo-mec = tg-modulo-mec:checked in frame {&frame-name}.
                end.
                when 2 then do:   /* display */
                    if avail param-global then
                        assign tg-modulo-mec:screen-value in frame {&FRAME-NAME} = string(param-global.modulo-mec).
                end.
                when 3 then do:   /* initialize */
                    assign tg-modulo-mec:sensitive in frame {&FRAME-NAME} = yes.
                end.
            end.
        end.
        else
            if avail param-global and p-ind = 1 then
                assign param-global.modulo-mec = no.
    &ELSE
        assign tg-modulo-mec:visible in frame {&FRAME-NAME} = no.
    &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-preditiva V-table-Win 
PROCEDURE pi-preditiva :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza ParÉmetro da Preditiva
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input param p-origem as int no-undo.

CASE p-origem:
    WHEN 1 THEN DO:
        /*ASSIGN*/
        &IF DEFINED (bf_mnt_ems206b) &THEN
              /*caso esteja acima de 206b*/
              if  tg-preditiva:checked in frame {&FRAME-NAME} then
                  assign param-global.log-modul-predit = yes.
              else
                  assign param-global.log-modul-predit = no.
        &ELSE
              /*caso esteja abaixo de 206b*/
              if  tg-preditiva:checked in frame {&FRAME-NAME} then
                  assign substring(param-global.char-2,25,1) = "y".
              else
                  assign substring(param-global.char-2,25,1) = "n".
        &endif        
    END.
    WHEN 2 THEN DO:
        /*DISPLAY*/
        &IF DEFINED (bf_mnt_ems206b) &THEN
            IF AVAIL param-global THEN
                ASSIGN tg-preditiva:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(param-global.log-modul-predit).
        &ELSE
            IF AVAIL param-global THEN
                ASSIGN tg-preditiva:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF substring(param-global.char-2,25,1) = "y":U THEN "YES":U ELSE "NO":U.
        &endif
        {utp/ut-liter.i Preditiva *}
        ASSIGN tg-preditiva:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    END.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param h-v01ad205 as handle no-undo.

assign h_v01ad205 = h-v01ad205.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-vendor V-table-Win 
PROCEDURE pi-verifica-vendor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define OUTPUT param p-vendor as LOGICAL no-undo.

IF param-global.modulo-05:checked in frame {&frame-name} then
    ASSIGN p-vendor = YES.
ELSE
    ASSIGN p-vendor = NO.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validaPerPPM V-table-Win 
PROCEDURE validaPerPPM :
/*------------------------------------------------------------------------------
  Purpose:     Procedure chamada a partir da trigger do botao ok da tela chamadora.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE i-cod-obsoleto AS INTEGER     NO-UNDO.
DEFINE VARIABLE l-achou        AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-itens        AS CHARACTER   NO-UNDO.

  IF AVAIL param-global
       AND param-global.modulo-per-ppm
       AND param-global.modulo-per-ppm:CHECKED IN FRAME f-main = NO THEN DO:

      /*O usu†rio somente poder† desabilitar o Fator de Concentraá∆o caso n∆o haja nenhum item
        ou item DP com tipo de formulaá∆o diferente de Nao Utiliza.*/

      /*Para desabilitar a funá∆o Tratamento Concentraá∆o/PPM, Ç necess†rio que todos os Itens da base
      (cadastrado via m¢dulos de Engenharia ou Desenvolvimento de Produtos) estejam configurados com
      a opá∆o Componente para Formulaá∆o igual a N∆o Utiliza.
      O sistema far† a referida validaá∆o neste momento. Tal validaá∆o poder† levar alguns instantes. Deseja Continuar?*/
      run utp/ut-msgs.p (input "show":U,
                         input 33960,
                         input "").
      IF RETURN-VALUE = "yes":U THEN DO:

          ASSIGN l-achou = NO.

          /*Varre os Itens da Engenharia (Todos menos os Totalmente Obsoletos (cod-obsoleto = 4)*/
          DO i-cod-obsoleto = 1 TO 3:
              FOR EACH ITEM FIELDS(cod-obsoleto tipo-formula) NO-LOCK
                 WHERE ITEM.cod-obsoleto = i-cod-obsoleto:
                  IF ITEM.tipo-formula > 1 THEN DO:
                      ASSIGN l-achou = YES.
                      LEAVE.
                  END.
              END.
              IF l-achou THEN
                  LEAVE.
          END.

          IF l-achou = NO THEN DO:
              /*Varre os Itens do DP*/

              FOR EACH dp-item FIELDS( &IF DEFINED(bf_man_207A) &THEN           
                                         dp-item.tipo-formula
                                       &ELSE                                    
                                         dp-item.char-1
                                       &ENDIF ) NO-LOCK:

                  IF &IF DEFINED(bf_man_207A) &THEN
                        dp-item.tipo-formula > 1
                     &ELSE
                        int(SUBSTRING(dp-item.char-1,7,1)) > 1
                     &ENDIF
                     THEN DO:
                          ASSIGN l-achou = YES.
                          LEAVE.
                  END.
              END.
          END.

          /*Encontrou, ent∆o emite msg de erro e retorna error*/
          IF l-achou THEN DO:
              run utp/ut-msgs.p (input "show":U,
                                 input 33962,
                                 input "").
              return 'ADM-ERROR':U.
          END.
      END.
      ELSE
          return 'ADM-ERROR':U.
  END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

