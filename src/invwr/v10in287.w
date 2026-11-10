&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V10IN287 2.00.00.017 } /*** "010017" 09/01/2026 14:41:40 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v10in287 MUT}
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

DEF NEW GLOBAL SHARED VAR l-erro   AS LOGICAL NO-UNDO.

DEF SHARED VAR c-lb-gerencial AS CHAR FORMAT "x(36)" NO-UNDO.
DEF SHARED VAR c-lb-cod-cenario-ma-1 AS CHAR FORMAT "x(36)" NO-UNDO.
DEF SHARED VAR c-lb-cod-cenario-ma-2 AS CHAR FORMAT "x(36)" NO-UNDO.
DEF SHARED VAR l-ifrs-ma1 AS LOGICAL NO-UNDO.
DEF SHARED VAR l-ifrs-ma2 AS LOGICAL NO-UNDO.

def var l-tem-movto-geren         as logical no-undo.
def var lIntegracaoEMS5     as log    no-undo.
def var l-ifrs-contab-estoq as log    no-undo.
DEF VAR h-boin863           AS HANDLE NO-UNDO.
DEF VAR hShowMsg            AS HANDLE NO-UNDO.
DEF VAR hProgramZoom        AS HANDLE NO-UNDO.
DEF VAR l-conectou-ems5     AS LOG    NO-UNDO.

def var i-per-corrente as int  format "99"         no-undo.
def var da-iniper-x    as date format "99/99/9999" no-undo.
def var da-fimper-x    as date format "99/99/9999" no-undo.
def var da-iniper-fech as date format "99/99/9999" no-undo.
def var da-fimper-fech as date format "99/99/9999" no-undo.
def var c-per-geren    as char                     no-undo.
DEFINE VARIABLE c-lb-msg AS CHAR                     NO-UNDO.

{cdp/cdcfgmat.i}
{btb/btb009za.i}
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
{cep/ceapi001k.i7} //pi-data-per-geren

/*Temp-table EMS5 - Retorna cen†rios cont†beis v†lidos*/
def temp-table tt_cenar_ctbl_ems5 no-undo
         field tta_cod_cenar_ctbl         as character format "x(8)"  label "Cen†rio Cont†bil"          column-label "Cen†rio Cont†bil"
         field tta_des_cenar_ctbl         as character format "x(40)" label "Descriá∆o"                 column-label "Descriá∆o"
         field tta_log_cenar_ifrs         as logical format "Sim/N∆o" initial no label "Cen†rio IFRS"   column-label "Cen†rio IFRS"
         field tta_log_cenar_fisc         as logical format "Sim/N∆o" initial no label "Cen†rio Fiscal" column-label "Cen†rio Fiscal"
         field ttv_log_permis_cenar_usuar as logical format "Sim/N∆o" initial no
        .
def temp-table tt_erro_fgl no-undo
         field ttv_num_erro_fgl           as integer format "9999999"
         field ttv_des_erro_fgl           as character format "x(100)"
         field ttv_des_arq_erro           as character format "x(100)"
         field ttv_log_ctbz               as logical format "Sim/N∆o" initial yes label "Contabiliza Movto" column-label "Contabiliza Movto"
            .

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
&Scoped-define EXTERNAL-TABLES param-estoq
&Scoped-define FIRST-EXTERNAL-TABLE param-estoq


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-estoq.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-estoq.log-gera-act-geren ~
param-estoq.idi-fase-med-geren param-estoq.log-tem-moed-geren-1 ~
param-estoq.log-tem-moed-geren-2 param-estoq.cdn-moed-geren-1 ~
param-estoq.cdn-moed-geren-2 param-estoq.cod-cenar-geren ~
param-estoq.dat-fechto-geren param-estoq.num-ult-fechto-geren ~
param-estoq.dat-mensal-geren param-estoq.dat-sumar-geren ~
param-estoq.dat-ctbl-geren 
&Scoped-define ENABLED-TABLES param-estoq
&Scoped-define FIRST-ENABLED-TABLE param-estoq
&Scoped-Define ENABLED-OBJECTS i-mo-ctbz-geren l-usa-fech-geren ~
c-descricao-moeda-alt-1 c-descricao-moeda-alt-2 l-ifrs-moeda-alt-1 ~
l-ifrs-moeda-alt-2 c-cod-cenario-ma-1-geren c-cod-cenario-ma-2-geren ~
d-inicio-periodo d-fim-periodo RECT-9 RECT-11 RECT-12 RECT-8 RECT-13 ~
l-fechto-previo 
&Scoped-Define DISPLAYED-FIELDS param-estoq.log-gera-act-geren ~
param-estoq.idi-fase-med-geren param-estoq.log-tem-moed-geren-1 ~
param-estoq.log-tem-moed-geren-2 param-estoq.cdn-moed-geren-1 ~
param-estoq.cdn-moed-geren-2 param-estoq.cod-cenar-geren ~
param-estoq.dat-fechto-geren param-estoq.num-ult-fechto-geren ~
param-estoq.dat-mensal-geren param-estoq.dat-sumar-geren ~
param-estoq.dat-ctbl-geren 
&Scoped-define DISPLAYED-TABLES param-estoq
&Scoped-define FIRST-DISPLAYED-TABLE param-estoq
&Scoped-Define DISPLAYED-OBJECTS c-desc-mo-ctbz-geren i-mo-ctbz-geren ~
l-usa-fech-geren c-descricao-moeda-alt-1 c-descricao-moeda-alt-2 ~
l-ifrs-moeda-alt-1 l-ifrs-moeda-alt-2 c-cod-cenario-ma-1-geren ~
c-cod-cenario-ma-2-geren d-inicio-periodo d-fim-periodo l-fechto-previo 

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
DEFINE VARIABLE c-cod-cenario-ma-1-geren AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo Cen†rio IFRS MA 1" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-cenario-ma-2-geren AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo Cen†rio IFRS MA 2" 
     VIEW-AS FILL-IN 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE c-desc-mo-ctbz-geren AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao-moeda-alt-1 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-descricao-moeda-alt-2 AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 16.57 BY 1 NO-UNDO.

DEFINE VARIABLE d-fim-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "Fim Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE d-inicio-periodo AS DATE FORMAT "99/99/9999":U 
     LABEL "Inicio Per°odo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY 1 NO-UNDO.

DEFINE VARIABLE i-mo-ctbz-geren AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda Contab Geren" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 4.04.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 45 BY 4.08.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 1.29.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 87 BY 1.25.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 9.79.

DEFINE VARIABLE l-fechto-previo AS LOGICAL INITIAL no 
     LABEL "Fechto PrÇvio" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

DEFINE VARIABLE l-ifrs-moeda-alt-1 AS LOGICAL INITIAL no 
     LABEL "IFRS Moeda Alternativa 1" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .5 NO-UNDO.

DEFINE VARIABLE l-ifrs-moeda-alt-2 AS LOGICAL INITIAL no 
     LABEL "IFRS Moeda Alternativa 2" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .54 NO-UNDO.

DEFINE VARIABLE l-usa-fech-geren AS LOGICAL INITIAL no 
     LABEL "Usa Fech Gerencial" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-desc-mo-ctbz-geren AT ROW 11.33 COL 24.86 COLON-ALIGNED NO-LABEL WIDGET-ID 100
     i-mo-ctbz-geren AT ROW 11.33 COL 19.29 COLON-ALIGNED WIDGET-ID 98
     param-estoq.log-gera-act-geren AT ROW 10.33 COL 5.86 WIDGET-ID 92
          VIEW-AS TOGGLE-BOX
          SIZE 21 BY .83
     param-estoq.idi-fase-med-geren AT ROW 13.13 COL 2.72 NO-LABEL WIDGET-ID 86
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "N∆o calculado", 1,
"Itens Comprados", 2,
"Ord Manutená∆o", 3,
"Ord Invest", 4,
"Ord Produá∆o", 5
          SIZE 84 BY .75
     l-usa-fech-geren AT ROW 1.17 COL 35 WIDGET-ID 2
     param-estoq.log-tem-moed-geren-1 AT ROW 2.33 COL 6.14 WIDGET-ID 30
          VIEW-AS TOGGLE-BOX
          SIZE 24.14 BY .83
     param-estoq.log-tem-moed-geren-2 AT ROW 6.42 COL 6.14 WIDGET-ID 28
          VIEW-AS TOGGLE-BOX
          SIZE 26 BY .83
     param-estoq.cdn-moed-geren-1 AT ROW 3.25 COL 19.29 COLON-ALIGNED WIDGET-ID 74
          VIEW-AS FILL-IN 
          SIZE 5.14 BY 1
     param-estoq.cdn-moed-geren-2 AT ROW 7.33 COL 19.29 COLON-ALIGNED WIDGET-ID 52
          VIEW-AS FILL-IN 
          SIZE 5.14 BY 1
     c-descricao-moeda-alt-1 AT ROW 3.25 COL 25 COLON-ALIGNED NO-LABEL WIDGET-ID 72
     c-descricao-moeda-alt-2 AT ROW 7.33 COL 24.86 COLON-ALIGNED NO-LABEL WIDGET-ID 66
     l-ifrs-moeda-alt-1 AT ROW 4.38 COL 6.29 WIDGET-ID 36
     l-ifrs-moeda-alt-2 AT ROW 8.38 COL 6.29 WIDGET-ID 54
     c-cod-cenario-ma-1-geren AT ROW 5.04 COL 45 COLON-ALIGNED WIDGET-ID 38
     c-cod-cenario-ma-2-geren AT ROW 9.04 COL 45 COLON-ALIGNED WIDGET-ID 38
     param-estoq.cod-cenar-geren AT ROW 2.63 COL 71 COLON-ALIGNED WIDGET-ID 8
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     param-estoq.dat-fechto-geren AT ROW 3.79 COL 71 COLON-ALIGNED WIDGET-ID 14
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     param-estoq.num-ult-fechto-geren AT ROW 4.92 COL 71 COLON-ALIGNED WIDGET-ID 18
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     param-estoq.dat-mensal-geren AT ROW 6.08 COL 71 COLON-ALIGNED WIDGET-ID 16
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     param-estoq.dat-sumar-geren AT ROW 7.25 COL 71 COLON-ALIGNED WIDGET-ID 24
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     param-estoq.dat-ctbl-geren AT ROW 8.42 COL 71 COLON-ALIGNED WIDGET-ID 20
          VIEW-AS FILL-IN 
          SIZE 14 BY 1
     d-inicio-periodo AT ROW 9.58 COL 71 COLON-ALIGNED WIDGET-ID 22
     d-fim-periodo AT ROW 10.75 COL 71 COLON-ALIGNED WIDGET-ID 26
     l-fechto-previo AT ROW 1.17 COL 63.86 WIDGET-ID 102
     "Fase C†lculo MÇdio Gerenc" VIEW-AS TEXT
          SIZE 25.72 BY .67 AT ROW 12.38 COL 26.29 WIDGET-ID 96
     RECT-9 AT ROW 2.21 COL 46 WIDGET-ID 12
     RECT-11 AT ROW 6.25 COL 1 WIDGET-ID 48
     RECT-12 AT ROW 2.25 COL 1 WIDGET-ID 50
     RECT-8 AT ROW 1 COL 1 WIDGET-ID 76
     RECT-13 AT ROW 12.75 COL 1 WIDGET-ID 94
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-estoq
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
         HEIGHT             = 13.13
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-mo-ctbz-geren IN FRAME f-main
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

&Scoped-define SELF-NAME c-cod-cenario-ma-1-geren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-1-geren V-table-Win
ON F5 OF c-cod-cenario-ma-1-geren IN FRAME f-main /* C¢digo Cen†rio IFRS MA 1 */
DO:
          
    {method/zoomfields.i 
            &ProgramZoom="inzoom/z01in863.w"
            &FieldZoom1="cod-cenar-ctbl"
            &FieldScreen1="c-cod-cenario-ma-1-geren"
            &Frame1="f-main"
            &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-1-geren V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cenario-ma-1-geren IN FRAME f-main /* C¢digo Cen†rio IFRS MA 1 */
DO:
  APPLY "F5" TO c-cod-cenario-ma-1-geren IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-cenario-ma-2-geren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-2-geren V-table-Win
ON F5 OF c-cod-cenario-ma-2-geren IN FRAME f-main /* C¢digo Cen†rio IFRS MA 2 */
DO:
   {method/zoomfields.i 
          &ProgramZoom="inzoom/z01in863.w"
          &FieldZoom1="cod-cenar-ctbl"
          &FieldScreen1="c-cod-cenario-ma-2-geren"
          &Frame1="f-main"
          &EnableImplant="NO"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-cenario-ma-2-geren V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-cenario-ma-2-geren IN FRAME f-main /* C¢digo Cen†rio IFRS MA 2 */
DO:
  APPLY "F5" TO c-cod-cenario-ma-2-geren IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.cdn-moed-geren-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.cdn-moed-geren-1 V-table-Win
ON F5 OF param-estoq.cdn-moed-geren-1 IN FRAME f-main /* Moeda Gerencial 1 */
DO:
  //assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=param-estoq.cdn-moed-geren-1
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.cdn-moed-geren-1 V-table-Win
ON LEAVE OF param-estoq.cdn-moed-geren-1 IN FRAME f-main /* Moeda Gerencial 1 */
DO:
  {include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-moeda-alt-1
                   &where="moeda.mo-codigo = input frame {&frame-name} param-estoq.cdn-moed-geren-1"}               
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.dat-fechto-geren V-table-Win
ON LEAVE OF param-estoq.dat-fechto-geren IN FRAME f-main /* Moeda Gerencial 1 */
DO:
    
    FIND FIRST param-estoq EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL param-estoq THEN
        ASSIGN param-estoq.dat-fechto-geren = INPUT FRAME {&FRAME-NAME} param-estoq.dat-fechto-geren.
    
    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    
    RUN pi-data-per-geren(INPUT  INPUT FRAME {&FRAME-NAME} param-estoq.cod-cenar-geren,
                          INPUT  INPUT FRAME {&FRAME-NAME} param-estoq.dat-fechto-geren,
                          OUTPUT c-per-geren).

    
    ASSIGN param-estoq.num-ult-fechto-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTR(c-per-geren,5,2).
    
    RUN cdp/cdapi3020.p (INPUT  INPUT FRAME {&FRAME-NAME} param-estoq.cod-cenar-geren,
                         INPUT  INT(SUBSTR(c-per-geren,1,4)),
                         INPUT  INPUT FRAME {&FRAME-NAME} param-estoq.num-ult-fechto-geren,
                         OUTPUT i-per-corrente, /* 1o periodo aberto */
                         OUTPUT da-iniper-x,    /* Dt Ini - 1o periodo aberto */
                         OUTPUT da-fimper-x,    /* Dt Fim - 1o periodo aberto */
                         OUTPUT da-iniper-fech, /* Dt Ini - ult per fechado */
                         OUTPUT da-fimper-fech). /* Dt Fim - Ult per fechado */
    
    ASSIGN d-inicio-periodo:SCREEN-VALUE             IN FRAME {&FRAME-NAME} = STRING(da-iniper-x)
           d-fim-periodo:SCREEN-VALUE                IN FRAME {&FRAME-NAME} = STRING(da-fimper-x)
           param-estoq.dat-mensal-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(da-fimper-fech)
           param-estoq.dat-sumar-geren:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = STRING(da-fimper-fech)
           param-estoq.dat-ctbl-geren:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = STRING(da-fimper-fech).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.cdn-moed-geren-1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.cdn-moed-geren-1 IN FRAME f-main /* Moeda Gerencial 1 */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.cdn-moed-geren-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.cdn-moed-geren-2 V-table-Win
ON F5 OF param-estoq.cdn-moed-geren-2 IN FRAME f-main /* Moeda Gerencial 2 */
DO:
  //assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="unzoom/z01un005.w"
                     &campo=param-estoq.cdn-moed-geren-2
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.cdn-moed-geren-2 V-table-Win
ON LEAVE OF param-estoq.cdn-moed-geren-2 IN FRAME f-main /* Moeda Gerencial 2 */
DO:
  {include/leave.i &tabela=moeda 
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-moeda-alt-2
                   &where="moeda.mo-codigo = input frame {&frame-name} param-estoq.cdn-moed-geren-2"}                 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.cdn-moed-geren-2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-estoq.cdn-moed-geren-2 IN FRAME f-main /* Moeda Gerencial 2 */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-ctbz-geren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-ctbz-geren V-table-Win
ON LEAVE OF i-mo-ctbz-geren IN FRAME f-main /* Moeda Contab Geren */
DO:
    {include/leave.i &tabela=moeda 
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-mo-ctbz-geren
                     &where="moeda.mo-codigo = input frame {&frame-name} i-mo-ctbz-geren"}                 
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-mo-ctbz-geren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-mo-ctbz-geren V-table-Win
ON LEAVE OF param-estoq.cod-cenar-geren IN FRAME f-main /* Moeda Contab Geren */
DO:
   IF (l-ifrs-ma1 = YES OR l-ifrs-ma2 = yes) THEN DO:
   
      ASSIGN c-lb-gerencial = PARAM-estoq.cod-cenar-geren:SCREEN-VALUE IN FRAME f-main.
      
      IF (c-lb-cod-cenario-ma-1 = c-lb-gerencial AND c-lb-cod-cenario-ma-1 <> "") 
      OR (c-lb-cod-cenario-ma-2 = c-lb-gerencial AND c-lb-cod-cenario-ma-2 <> "") THEN DO:
          run utp/ut-msgs.p (input "show":U, 
                                input 57732, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
          ASSIGN l-erro = YES.
          return "adm-error".        
      END.
      
      IF AVAIL param-estoq THEN DO:
          IF (param-estoq.cod-cenar-ifrs-1 = c-lb-gerencial) OR (param-estoq.cod-cenar-ifrs-2 = c-lb-gerencial) THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                                  input 57732, 
                                  INPUT c-lb-msg + "~~" + RETURN-VALUE).
            ASSIGN l-erro = YES.
            return "adm-error".         
          END.
      END.

   END.
   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-fechto-previo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-fechto-previo V-table-Win
ON VALUE-CHANGED OF l-fechto-previo IN FRAME f-main /* Fechto PrÇvio */
DO:
   IF SELF:CHECKED AND NOT l-tem-movto-geren THEN DO:

      ASSIGN param-estoq.log-tem-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = YES
             param-estoq.log-tem-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = YES
             param-estoq.cod-cenar-geren:SENSITIVE IN FRAME {&frame-name}      = YES
             param-estoq.dat-fechto-geren:SENSITIVE IN FRAME {&FRAME-NAME}     = YES.

      IF param-estoq.log-tem-moed-geren-1 THEN
        ASSIGN param-estoq.cdn-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = YES
               l-ifrs-moeda-alt-1:SENSITIVE IN FRAME {&frame-name}           = YES
               /* r-tipo-cotacao-moeda-1:SENSITIVE IN FRAME {&frame-name}       = YES*/ .

      IF param-estoq.log-tem-moed-geren-2 THEN
        ASSIGN param-estoq.cdn-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = YES
               l-ifrs-moeda-alt-2:SENSITIVE IN FRAME {&frame-name}           = YES
               /*r-tipo-cotacao-moeda-2:SENSITIVE IN FRAME {&frame-name}       = YES */ .

      IF l-ifrs-moeda-alt-1 THEN
        ASSIGN c-cod-cenario-ma-1-geren:SENSITIVE IN FRAME {&frame-name}     = YES.

      IF l-ifrs-moeda-alt-2 THEN
        ASSIGN c-cod-cenario-ma-2-geren:SENSITIVE IN FRAME {&FRAME-NAME }    = YES.

   END.

   IF NOT SELF:CHECKED AND NOT l-tem-movto-geren THEN
       RUN local-enable-fields IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ifrs-moeda-alt-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ifrs-moeda-alt-1 V-table-Win
ON VALUE-CHANGED OF l-ifrs-moeda-alt-1 IN FRAME f-main /* IFRS Moeda Alternativa 1 */
DO:
   IF SELF:CHECKED THEN
      ASSIGN c-cod-cenario-ma-1-geren:SENSITIVE IN FRAME {&frame-name} = YES.
   ELSE
      ASSIGN c-cod-cenario-ma-1-geren:SCREEN-VALUE IN FRAME {&frame-name} = ""
             c-cod-cenario-ma-1-geren:SENSITIVE IN FRAME {&frame-name}    = NO.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-ifrs-moeda-alt-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-ifrs-moeda-alt-2 V-table-Win
ON VALUE-CHANGED OF l-ifrs-moeda-alt-2 IN FRAME f-main /* IFRS Moeda Alternativa 2 */
DO:
   IF SELF:CHECKED THEN
      ASSIGN c-cod-cenario-ma-2-geren:SENSITIVE IN FRAME {&frame-name} = YES.
   ELSE
      ASSIGN c-cod-cenario-ma-2-geren:SENSITIVE IN FRAME {&frame-name}    = NO
             c-cod-cenario-ma-2-geren:SCREEN-VALUE IN FRAME {&frame-name} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-usa-fech-geren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-usa-fech-geren V-table-Win
ON VALUE-CHANGED OF l-usa-fech-geren IN FRAME f-main /* Usa Fech Gerencial */
DO:

   DEF VAR c-texto1 AS CHAR NO-UNDO.

   IF  SELF:CHECKED
   AND "{&product_version}" < "12.1.X.2311" THEN DO:
    
       {utp/ut-liter.i "Fechamento_Gerencial_n∆o_pode_ser_ativado_em_vers‰es_menores_que_12.1.2311"}
       ASSIGN c-texto1 = TRIM(RETURN-VALUE).
       {utp/ut-liter.i "Entre em contato com o suporte Totvs -> Linha Datasul" }
       RUN utp/ut-msgs.p("show",17242,c-texto1 + "~~" + TRIM(RETURN-VALUE)).
       SELF:CHECKED = NO.
       RETURN NO-APPLY.
   END.

   IF SELF:CHECKED AND NOT l-tem-movto-geren THEN DO:

      ASSIGN param-estoq.log-tem-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = YES
             param-estoq.log-tem-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = YES
             param-estoq.cod-cenar-geren:SENSITIVE IN FRAME {&frame-name}      = YES
             i-mo-ctbz-geren:SENSITIVE             IN FRAME {&frame-name}      = YES
             param-estoq.dat-fechto-geren:SENSITIVE IN FRAME {&frame-name}     = YES.

      IF AVAIL param-estoq THEN DO:
        IF param-estoq.log-tem-moed-geren-1 THEN
          ASSIGN param-estoq.cdn-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = YES
                 l-ifrs-moeda-alt-1:SENSITIVE IN FRAME {&frame-name}           = YES
                 /* r-tipo-cotacao-moeda-1:SENSITIVE IN FRAME {&frame-name}       = YES*/ .

        IF param-estoq.log-tem-moed-geren-2 THEN
          ASSIGN param-estoq.cdn-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = YES
                 l-ifrs-moeda-alt-2:SENSITIVE IN FRAME {&frame-name}           = YES
                 /*r-tipo-cotacao-moeda-2:SENSITIVE IN FRAME {&frame-name}       = YES */ .         
      END.

      IF l-ifrs-moeda-alt-1 THEN
        ASSIGN c-cod-cenario-ma-1-geren:SENSITIVE IN FRAME {&frame-name}     = YES.

      IF l-ifrs-moeda-alt-2 THEN
        ASSIGN c-cod-cenario-ma-2-geren:SENSITIVE IN FRAME {&frame-name }    = YES.

   END.
   
   IF NOT SELF:CHECKED AND NOT l-tem-movto-geren THEN DO:  
       ASSIGN i-mo-ctbz-geren:SENSITIVE             IN FRAME {&frame-name}      = no
             param-estoq.dat-fechto-geren:SENSITIVE IN FRAME {&frame-name}     = no.
       RUN local-enable-fields IN THIS-PROCEDURE.
   END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.log-tem-moed-geren-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.log-tem-moed-geren-1 V-table-Win
ON VALUE-CHANGED OF param-estoq.log-tem-moed-geren-1 IN FRAME f-main /* Tem Moeda Geren 1 */
DO:
   IF SELF:CHECKED THEN
      ASSIGN param-estoq.cdn-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = YES
             l-ifrs-moeda-alt-1:SENSITIVE IN FRAME {&frame-name}           = YES
             /* r-tipo-cotacao-moeda-1:SENSITIVE IN FRAME {&frame-name}       = YES */ .
   ELSE
      ASSIGN param-estoq.cdn-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = NO
             l-ifrs-moeda-alt-1:SENSITIVE IN FRAME {&frame-name}           = NO
             /* r-tipo-cotacao-moeda-1:SENSITIVE IN FRAME {&frame-name}       = NO */
             c-cod-cenario-ma-1-geren:SENSITIVE IN FRAME {&frame-name}     = NO
             l-ifrs-moeda-alt-1:checked in frame {&frame-name}             = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-estoq.log-tem-moed-geren-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-estoq.log-tem-moed-geren-2 V-table-Win
ON VALUE-CHANGED OF param-estoq.log-tem-moed-geren-2 IN FRAME f-main /* Tem Moeda Geren 2 */
DO:
   IF SELF:CHECKED THEN
      ASSIGN param-estoq.cdn-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = YES
             l-ifrs-moeda-alt-2:SENSITIVE IN FRAME {&frame-name}           = YES
             /* r-tipo-cotacao-moeda-2:SENSITIVE IN FRAME {&frame-name}       = YES*/ .
   ELSE
      ASSIGN param-estoq.cdn-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = NO
             l-ifrs-moeda-alt-2:SENSITIVE IN FRAME {&frame-name}           = NO
             /* r-tipo-cotacao-moeda-2:SENSITIVE IN FRAME {&frame-name}       = NO */
             c-cod-cenario-ma-2-geren:SENSITIVE IN FRAME {&frame-name}     = NO
             l-ifrs-moeda-alt-2:checked in frame {&frame-name}             = NO.

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

if param-estoq.cdn-moed-geren-1:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if param-estoq.cdn-moed-geren-2:load-mouse-pointer('image~\lupa.cur') in frame {&frame-name} then.
if c-cod-cenario-ma-1-geren:load-mouse-pointer('image~\lupa.cur')     in frame {&frame-name} then.
if c-cod-cenario-ma-2-geren:load-mouse-pointer('image~\lupa.cur')     in frame {&frame-name} then.

ASSIGN c-cod-cenario-ma-1-geren:VISIBLE IN FRAME {&FRAME-NAME} = NO
       c-cod-cenario-ma-2-geren:VISIBLE IN FRAME {&FRAME-NAME} = NO
       l-ifrs-moeda-alt-1:VISIBLE       IN FRAME {&FRAME-NAME} = NO
       l-ifrs-moeda-alt-2:VISIBLE       IN FRAME {&FRAME-NAME} = NO.

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
  {src/adm/template/row-list.i "param-estoq"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-estoq"}

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

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR l-usa-fech-geren-aux LIKE l-usa-fech-geren.
DEF VAR i-mo-ctbz-geren-aux  LIKE i-mo-ctbz-geren.


    run pi-validate.
    if  return-value = "ADM-ERROR":U then
        undo, return "ADM-ERROR":U.
    
    IF AVAIL param-estoq THEN DO:

        ASSIGN param-estoq.log-fechto-geren = l-usa-fech-geren:CHECKED IN FRAME {&frame-name} /*Usa Fech Gerencial*/
              /* overlay(param-estoq.char-2,129,1) = r-tipo-cotacao-moeda-1:screen-value in frame {&frame-name}             /*Cotacao Moeda 1*/
               overlay(param-estoq.char-2,130,1) = r-tipo-cotacao-moeda-2:screen-value in frame {&frame-name}*/ .           /*Cotacao Moeda 2*/

        if l-ifrs-contab-estoq and lIntegracaoEMS5 then /*IFRS e Integraá∆o EMS5*/
            assign param-estoq.log-tem-moed-geren-1 = l-ifrs-moeda-alt-1:CHECKED IN FRAME {&FRAME-NAME}  /*IFRS Moeda Alternativa 1*/
                   param-estoq.log-tem-moed-geren-2 = l-ifrs-moeda-alt-2:CHECKED IN FRAME {&FRAME-NAME}  /*IFRS Moeda Alternativa 2*/
                   param-estoq.cod-cenar-geren-1    = c-cod-cenario-ma-1-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME}             /*Codigo Cen·rio IFRS MA 1*/
                   param-estoq.cod-cenar-geren-2    = c-cod-cenario-ma-2-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME}             /*Codigo Cen·rio IFRS MA 2*/
                   param-estoq.cdn-moed-geren       = INT(i-mo-ctbz-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME}).                /*Moeda que serah gravada no lote contabil*/
    END.
    
    /* Code placed here will execute PRIOR to standard behavior. */
    ASSIGN l-usa-fech-geren-aux = l-usa-fech-geren:CHECKED IN FRAME {&frame-name}
           i-mo-ctbz-geren-aux  = INT(i-mo-ctbz-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
    ASSIGN l-usa-fech-geren = l-usa-fech-geren-aux
           i-mo-ctbz-geren  = i-mo-ctbz-geren-aux.
    
    if RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.

    /* Code placed here will execute AFTER standard behavior.    */
    
    ASSIGN param-estoq.log-fechto-geren     = l-usa-fech-geren
           param-estoq.cdn-moed-geren       = i-mo-ctbz-geren
           param-estoq.cod-cenar-geren      = param-estoq.cod-cenar-geren:SCREEN-VALUE IN FRAME {&frame-name}
           param-estoq.log-tem-moed-geren-1 = param-estoq.log-tem-moed-geren-1:checked in frame {&frame-name}
           param-estoq.log-tem-moed-geren-2 = param-estoq.log-tem-moed-geren-2:checked in frame {&frame-name}
           param-estoq.cdn-moed-geren-1     = INT(param-estoq.cdn-moed-geren-1:SCREEN-VALUE IN FRAME {&frame-name})
           param-estoq.cdn-moed-geren-2     = INT(param-estoq.cdn-moed-geren-2:SCREEN-VALUE IN FRAME {&frame-name}).

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

  if available param-estoq then do:
    
      find moeda where moeda.mo-codigo = param-estoq.cdn-moed-geren-1 no-lock no-error.
      assign c-descricao-moeda-alt-1 = if avail moeda then moeda.descricao else "":U.
  
      find moeda where moeda.mo-codigo = param-estoq.cdn-moed-geren-2 no-lock no-error.
      assign c-descricao-moeda-alt-2 = if avail moeda THEN moeda.descricao else "":U.

      assign l-usa-fech-geren = IF param-estoq.log-fechto-geren THEN YES ELSE NO.

      /*************** CotaÁ„o Moeda 1 **********************
      IF SUBSTRING(param-estoq.char-2,129,1) = "1" THEN
          assign r-tipo-cotacao-moeda-1:screen-value in frame {&FRAME-NAME} =  "1".
      ELSE IF SUBSTRING(param-estoq.char-2,129,1) = "2" THEN
          assign r-tipo-cotacao-moeda-1:screen-value in frame {&FRAME-NAME} =  "2".
      ELSE
          assign r-tipo-cotacao-moeda-1:screen-value in frame {&FRAME-NAME} =  "3".*/

      /*************** CotaÁ„o Moeda 2 **********************
      IF SUBSTRING(param-estoq.char-2,130,1) = "1" THEN
          assign r-tipo-cotacao-moeda-2:screen-value in frame {&FRAME-NAME} =  "1".
      ELSE IF SUBSTRING(param-estoq.char-2,130,1) = "2" THEN
          assign r-tipo-cotacao-moeda-2:screen-value in frame {&FRAME-NAME} =  "2".
      ELSE
          assign r-tipo-cotacao-moeda-2:screen-value in frame {&FRAME-NAME} =  "3".*/
            
      if l-ifrs-contab-estoq AND lIntegracaoEMS5 THEN /*Funá∆o IFRS*/
          assign l-ifrs-moeda-alt-1        = param-estoq.log-tem-moed-geren-1
                 l-ifrs-moeda-alt-2        = param-estoq.log-tem-moed-geren-2
                 c-cod-cenario-ma-1-geren  = param-estoq.cod-cenar-geren-1 
                 c-cod-cenario-ma-2-geren  = param-estoq.cod-cenar-geren-2.
        
  END.
  ELSE DO:
      assign c-descricao-moeda-alt-1 = ""
             c-descricao-moeda-alt-2 = ""
             l-usa-fech-geren = NO.
  END.
    

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  if available param-estoq then do:

      ASSIGN i-mo-ctbz-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(param-estoq.cdn-moed-geren).
      APPLY "leave":U TO i-mo-ctbz-geren IN FRAME {&FRAME-NAME}.

      if param-estoq.log-tem-moed-geren-1 = no THEN
          ASSIGN c-descricao-moeda-alt-1:screen-value in frame {&frame-name}      = ""
                 c-cod-cenario-ma-1-geren:screen-value in frame {&frame-name}     = ""
                 l-ifrs-moeda-alt-1:CHECKED IN FRAME {&FRAME-NAME}                = NO
                 param-estoq.cdn-moed-geren-1:screen-value in frame {&frame-name} = "".

      if param-estoq.log-tem-moed-geren-2 = no THEN
          assign c-descricao-moeda-alt-2:screen-value in frame {&frame-name}      = ""
                 c-cod-cenario-ma-2-geren:screen-value in frame {&frame-name}     = ""
                 l-ifrs-moeda-alt-2:CHECKED IN FRAME {&FRAME-NAME}                = NO
                 param-estoq.cdn-moed-geren-2:screen-value in frame {&frame-name} = "".

      IF l-ifrs-contab-estoq AND lIntegracaoEMS5 then /*funá‰es: IFRS ativa e integraá∆o contabilidade EMS 5.00 ativa*/
          ASSIGN l-ifrs-moeda-alt-1:sensitive in frame {&FRAME-NAME}       = IF param-estoq.log-tem-moed-geren-1 <> ? THEN param-estoq.log-tem-moed-geren-1 ELSE NO
                 l-ifrs-moeda-alt-2:sensitive in frame {&FRAME-NAME}       = IF param-estoq.log-tem-moed-geren-2 <> ? THEN param-estoq.log-tem-moed-geren-2 ELSE NO
                 c-cod-cenario-ma-1-geren:sensitive IN FRAME {&FRAME-NAME} = IF param-estoq.log-tem-moed-geren-1 <> ? AND param-estoq.log-tem-moed-geren-1 AND l-ifrs-moeda-alt-1:CHECKED in frame {&FRAME-NAME} THEN YES ELSE NO
                 c-cod-cenario-ma-2-geren:sensitive IN FRAME {&FRAME-NAME} = IF param-estoq.log-tem-moed-geren-2 <> ? AND param-estoq.log-tem-moed-geren-2 AND l-ifrs-moeda-alt-2:CHECKED in frame {&FRAME-NAME} THEN YES ELSE NO.
      ELSE
          ASSIGN l-ifrs-moeda-alt-1:sensitive in frame {&FRAME-NAME} = NO
                 l-ifrs-moeda-alt-2:sensitive in frame {&FRAME-NAME} = NO
                 c-cod-cenario-ma-1-geren:sensitive IN FRAME {&FRAME-NAME} = NO
                 c-cod-cenario-ma-2-geren:sensitive IN FRAME {&FRAME-NAME} = NO.

  END.
  ELSE DO :
          ASSIGN c-descricao-moeda-alt-1:screen-value in frame {&frame-name}      = ""
                 c-cod-cenario-ma-1-geren:screen-value in frame {&frame-name}     = ""
                 l-ifrs-moeda-alt-1:CHECKED IN FRAME {&FRAME-NAME}                = NO
                 param-estoq.cdn-moed-geren-1:screen-value in frame {&frame-name} = "" 
                 c-descricao-moeda-alt-2:screen-value in frame {&frame-name}      = ""
                 c-cod-cenario-ma-2-geren:screen-value in frame {&frame-name}     = ""
                 l-ifrs-moeda-alt-2:CHECKED IN FRAME {&FRAME-NAME}                = NO
                 param-estoq.cdn-moed-geren-2:screen-value in frame {&frame-name} = ""    
                 l-ifrs-moeda-alt-1:sensitive in frame {&FRAME-NAME} = NO
                 l-ifrs-moeda-alt-2:sensitive in frame {&FRAME-NAME} = NO
                 c-cod-cenario-ma-1-geren:sensitive IN FRAME {&FRAME-NAME} = NO
                 c-cod-cenario-ma-2-geren:sensitive IN FRAME {&FRAME-NAME} = NO .                 
  END.


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

  ASSIGN param-estoq.log-tem-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = NO
         param-estoq.log-tem-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = NO
         param-estoq.cdn-moed-geren-1:SENSITIVE IN FRAME {&frame-name}     = NO
         param-estoq.cdn-moed-geren-2:SENSITIVE IN FRAME {&frame-name}     = NO
         c-descricao-moeda-alt-1:SENSITIVE IN FRAME {&frame-name}          = NO
         c-descricao-moeda-alt-2:SENSITIVE IN FRAME {&frame-name}          = NO
         l-ifrs-moeda-alt-1:SENSITIVE IN FRAME {&frame-name}               = NO
         l-ifrs-moeda-alt-2:SENSITIVE IN FRAME {&frame-name}               = NO
         c-cod-cenario-ma-1-geren:SENSITIVE IN FRAME {&frame-name}         = NO
         c-cod-cenario-ma-2-geren:SENSITIVE IN FRAME {&frame-name}         = NO
        /* r-tipo-cotacao-moeda-1:SENSITIVE IN FRAME {&frame-name}           = NO
         r-tipo-cotacao-moeda-2:SENSITIVE IN FRAME {&frame-name}           = NO */
         param-estoq.cod-cenar-geren:SENSITIVE IN FRAME {&frame-name}      = NO
         param-estoq.dat-fechto-geren:SENSITIVE IN FRAME {&frame-name}     = NO
         param-estoq.num-ult-fechto-geren:SENSITIVE IN FRAME {&frame-name} = NO
         param-estoq.dat-mensal-geren:SENSITIVE IN FRAME {&frame-name}     = NO
         param-estoq.dat-sumar-geren:SENSITIVE IN FRAME {&frame-name}      = NO
         param-estoq.dat-ctbl-geren:SENSITIVE IN FRAME {&frame-name}       = NO
         d-inicio-periodo:SENSITIVE IN FRAME {&frame-name}                 = NO
         d-fim-periodo:SENSITIVE IN FRAME {&frame-name}                    = NO
         param-estoq.log-gera-act-geren:SENSITIVE IN FRAME {&frame-name}   = NO
         param-estoq.idi-fase-med-geren:SENSITIVE IN FRAME {&frame-name}   = NO
         i-mo-ctbz-geren:SENSITIVE             IN FRAME {&FRAME-NAME}      = NO.


  ASSIGN l-tem-movto-geren = CAN-FIND(FIRST ext-movto-estoq USE-INDEX ch-codigo
                                      WHERE ext-movto-estoq.nr-transacao   > 0 
                                        AND ext-movto-estoq.seq-custeio = 0 NO-LOCK).
  IF AVAIL param-estoq THEN DO:
      IF  param-estoq.dat-fechto-geren = ? 
      OR  NOT l-tem-movto-geren THEN
          ASSIGN param-estoq.dat-fechto-geren:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  END.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
    
    /*Funá∆o IFRS*/
    assign l-ifrs-contab-estoq = yes
    
    /*Integraá∆o Contabilidade EMS5*/
         lIntegracaoEMS5 =  CAN-FIND(first funcao 
                                     WHERE funcao.cd-funcao = "adm-fgl-ems-5.00"
                                       AND funcao.ativo = YES
                                       AND funcao.log-1 = YES).

    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
    IF AVAIL param-estoq THEN DO:
        IF param-estoq.cod-cenar-geren = "" OR param-estoq.cod-cenar-geren = ? THEN
            ASSIGN d-inicio-periodo:SCREEN-VALUE IN FRAME {&frame-name}                 = ""
                   d-fim-periodo:SCREEN-VALUE IN FRAME {&frame-name}                    = ""
                   param-estoq.cod-cenar-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME}      = ""
                   param-estoq.dat-fechto-geren:screen-value in frame {&FRAME-NAME}     = ""
                   param-estoq.num-ult-fechto-geren:screen-value in frame {&FRAME-NAME} = ""
                   param-estoq.dat-mensal-geren:screen-value in frame {&FRAME-NAME}     = ""
                   param-estoq.dat-sumar-geren:screen-value in frame {&FRAME-NAME}      = ""
                   param-estoq.dat-ctbl-geren:screen-value in frame {&FRAME-NAME}       = "".
        ELSE DO:

            RUN pi-data-per-geren(INPUT  param-estoq.cod-cenar-geren,
                                  INPUT  param-estoq.dat-fechto-geren,
                                  OUTPUT c-per-geren).

            RUN cdp/cdapi3020.p (INPUT  param-estoq.cod-cenar-geren,
                                 INPUT  INT(SUBSTR(c-per-geren,1,4)),
                                 INPUT  param-estoq.num-ult-fechto-geren,
                                 OUTPUT i-per-corrente, /* 1o periodo aberto */
                                 OUTPUT da-iniper-x,    /* Dt Ini - 1o periodo aberto */
                                 OUTPUT da-fimper-x,    /* Dt Fim - 1o periodo aberto */
                                 OUTPUT da-iniper-fech, /* Dt Ini - ult per fechado */
                                 OUTPUT da-fimper-fech). /* Dt Fim - Ult per fechado */

            ASSIGN d-inicio-periodo:SCREEN-VALUE IN FRAME {&frame-name} = string(da-iniper-x)
                   d-fim-periodo:SCREEN-VALUE IN FRAME {&frame-name}    = string(da-fimper-x).

             IF  param-estoq.num-ult-fechto-geren = 0 THEN 
                 ASSIGN param-estoq.num-ult-fechto-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTR(c-per-geren,5,2).

             IF  param-estoq.dat-mensal-geren = ? THEN
                 ASSIGN param-estoq.dat-mensal-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(da-fimper-x).

             IF  param-estoq.dat-sumar-geren = ? THEN
                 ASSIGN param-estoq.dat-sumar-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(da-fimper-x).

             IF  param-estoq.dat-ctbl-geren = ? THEN
                 ASSIGN param-estoq.dat-ctbl-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(da-fimper-x).

        END.
    END.
    ELSE DO:
            ASSIGN d-inicio-periodo:SCREEN-VALUE IN FRAME {&frame-name}                 = ""
                   d-fim-periodo:SCREEN-VALUE IN FRAME {&frame-name}                    = ""
                   param-estoq.cod-cenar-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME}      = ""
                   param-estoq.dat-fechto-geren:screen-value in frame {&FRAME-NAME}     = ""
                   param-estoq.num-ult-fechto-geren:screen-value in frame {&FRAME-NAME} = ""
                   param-estoq.dat-mensal-geren:screen-value in frame {&FRAME-NAME}     = ""
                   param-estoq.dat-sumar-geren:screen-value in frame {&FRAME-NAME}      = ""
                   param-estoq.dat-ctbl-geren:screen-value in frame {&FRAME-NAME}       = "".    
    END.

    IF  CAN-FIND(FIRST ext-movto-estoq USE-INDEX ch-codigo
                 WHERE ext-movto-estoq.nr-transacao   > 0 
                   AND ext-movto-estoq.seq-custeio = 0 NO-LOCK) THEN
        ASSIGN l-tem-movto-geren = YES.
    ELSE
      ASSIGN l-tem-movto-geren = NO.

    ASSIGN param-estoq.cod-cenar-geren:SENSITIVE      IN FRAME {&frame-name} = NOT l-tem-movto-geren AND l-usa-fech-geren
           param-estoq.log-tem-moed-geren-1:SENSITIVE IN FRAME {&frame-name} = NOT l-tem-movto-geren AND l-usa-fech-geren
           param-estoq.log-tem-moed-geren-2:SENSITIVE IN FRAME {&frame-name} = NOT l-tem-movto-geren AND l-usa-fech-geren
           i-mo-ctbz-geren:SENSITIVE                  IN FRAME {&FRAME-NAME} = NOT l-tem-movto-geren AND l-usa-fech-geren. 

    IF param-estoq.log-tem-moed-geren-1:CHECKED = NO THEN
        ASSIGN param-estoq.cdn-moed-geren-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
                    c-descricao-moeda-alt-1:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
    ELSE DO:
        IF l-tem-movto-geren = NO  THEN
          ENABLE param-estoq.cdn-moed-geren-1
                 /*r-tipo-cotacao-moeda-1  */ WITH FRAME {&FRAME-NAME}.
        ELSE 
          DISABLE param-estoq.cdn-moed-geren-1
                  /* r-tipo-cotacao-moeda-1 */ WITH FRAME {&FRAME-NAME} . 
    END.
        
    IF param-estoq.log-tem-moed-geren-2:CHECKED = NO THEN
        ASSIGN param-estoq.cdn-moed-geren-2:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               c-descricao-moeda-alt-2:SCREEN-VALUE IN FRAME {&FRAME-NAME}      = " ".
    ELSE
        IF l-tem-movto-geren = NO AND l-usa-fech-geren THEN
          ENABLE param-estoq.cdn-moed-geren-2
                 /* r-tipo-cotacao-moeda-2 */ WITH FRAME {&FRAME-NAME}.
        ELSE 
          DISABLE param-estoq.cdn-moed-geren-2
                 /* r-tipo-cotacao-moeda-2 */ WITH FRAME {&FRAME-NAME}. 

     ASSIGN l-fechto-previo = CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "fechto-previo":U).

     DISP l-fechto-previo WITH FRAME {&FRAME-NAME}.

     DISABLE l-fechto-previo WITH FRAME {&FRAME-NAME}.
     

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

  /* Ponha aqui a validaá∆o de chave duplicada */

  /* Ponha aqui as demais validaá‰es */

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

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
  {src/adm/template/snd-list.i "param-estoq"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-conecta-ems50 V-table-Win 
PROCEDURE Pi-conecta-ems50 :
def input param i-conect as integer no-undo.
    DEF VAR h-btb009za AS HANDLE NO-UNDO.
    find first param-global no-lock no-error.
    if not valid-handle (h-btb009za) or
       h-btb009za:TYPE <> "PROCEDURE":U or
       h-btb009za:FILE-NAME <> "btb/btb009za.p":U  then
       RUN btb/btb009za.p PERSISTENT SET h-btb009za.
    
    if i-conect = 1 then do:
       if not connected("emsbas") or 
          not connected("emsuni") or 
          not connected("emsfin") then do:          
         
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U AND 
               AVAIL param-global then do:
               ASSIGN l-conectou-ems5 = YES.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.
        else
    end.
    else do:
        if connected("emsbas") or 
           connected("emsfin") or 
           connected("emsuni") then do:
           
            if  valid-handle (h-btb009za) AND
               h-btb009za:TYPE = "PROCEDURE":U AND
               h-btb009za:FILE-NAME = "btb/btb009za.p":U AND 
               AVAIL param-global then do:
               ASSIGN l-conectou-ems5 = NO.
               run pi-conecta-bco IN h-btb009za (Input 1,                         /*contem a vers„o de integraå„o da Api*/
                                                 Input i-conect,                  /*contem a opå„o desejada (1-Conex„o, 2-Desconex„o)*/
                                                 Input param-global.empresa-prin, /*contem o c©digo da empresa*/
                                                 Input "all",                     /*contem o c©digo do banco externo*/ 
                                                 Output Table tt_erros_conexao).  /*retorna erros caso existam*/
            end.
        end.    
    end.
    
    if valid-handle(h-btb009za) then do:
        delete procedure h-btb009za no-error.
        assign h-btb009za = ?.
    end.
    if return-value <> "OK":U then do:
        FIND FIRST tt_erros_conexao NO-ERROR.
        IF AVAIL tt_erros_conexao THEN DO:
            run utp/ut-msgs.p (input "show":U, 
                               input tt_erros_conexao.cd-erro, 
                               INPUT tt_erros_conexao.param-1).

            assign l-erro = yes.
            undo, return "NOK":U.
        END.
    end.    
    RETURN "OK":U.

End Procedure. /*Pi-conecta-ems50*/


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/* -----------------------------------------------------------
  Purpose:     Validaá∆o executada no momento da gravaá∆o dos
               dados na base
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
 DEFINE VARIABLE i-mo-fasb  AS INTEGER     NO-UNDO.
 DEFINE VARIABLE i-mo-cmi   AS INTEGER     NO-UNDO.
 DEFINE VARIABLE l-fasb     AS LOGICAL     NO-UNDO.
 DEFINE VARIABLE l-cmi      AS LOGICAL     NO-UNDO.
 define variable v_hdl_cenar as handle     no-undo.
 DEFINE VARIABLE c-msg      AS CHAR        NO-UNDO.

 ASSIGN l-erro = NO.
 {cep/ce9990.i} /*FASB*/ 
 {cep/ce9991.i}/*CMI*/


  IF  l-usa-fech-geren:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "yes":U THEN DO:
      RUN Get-Field-Screen-Value IN adm-broker-hdl(THIS-PROCEDURE,"tipo-pr-med").
      IF  RETURN-VALUE = "1" THEN DO:
          {utp/ut-liter.i "MÇdio_Di†rio"}
          ASSIGN c-msg = TRIM(RETURN-VALUE).
          {utp/ut-liter.i "Fechamento_Gerencial" *}
          RUN utp/ut-msgs.p("show",56972,c-msg + "~~" + TRIM(RETURN-VALUE)).
          RETURN "ADM-ERROR":U.
      END.
  END.

 if lIntegracaoEMS5 and l-ifrs-contab-estoq then do: /*Integraá∆o Contabilizaá∆o e Funá∆o IFRS*/

     if l-ifrs-moeda-alt-1:checked in frame {&frame-name} and
        ((l-fasb and                 /*Moeda parametrizada como Fasb*/
          i-mo-fasb = 2) or          /*Moeda1 = moeda Fasb */
        (l-cmi  and                  /*Moeda parametrizada como CMI*/
         i-mo-cmi = 2)) then do:     /*Moeda1 = moeda CMI */

        run utp/ut-msgs.p (input "show":U, 
                          input 51923, 
                          input INPUT frame {&frame-name} c-descricao-moeda-alt-1).
        ASSIGN l-erro = YES.
        return "adm-error".
     end.
     if l-ifrs-moeda-alt-2:checked in frame {&frame-name} and
        ((l-fasb and               /*Moeda parametrizada como Fasb*/
          i-mo-fasb = 3) or        /*Moeda2 = moeda Fasb */         
         (l-cmi  and               /*Moeda parametrizada como CMI*/ 
          i-mo-cmi = 3)) then do:  /*Moeda2 = moeda CMI */          
        run utp/ut-msgs.p (input "show":U, 
                          input 51923, 
                          input INPUT frame {&frame-name} c-descricao-moeda-alt-2).
        ASSIGN l-erro = YES.
        return "adm-error".
     end.
     
     IF AVAIL param-estoq THEN DO:
     
         IF (c-lb-cod-cenario-ma-1 <> "") OR (c-lb-cod-cenario-ma-2 <> "")
         OR (param-estoq.cod-cenar-ifrs-1 <> "") OR (param-estoq.cod-cenar-ifrs-2 <> "")
         THEN DO:
           IF (c-lb-cod-cenario-ma-1 = c-lb-gerencial) 
           OR (c-lb-cod-cenario-ma-2 = c-lb-gerencial)
           OR (param-estoq.cod-cenar-ifrs-1 = c-lb-gerencial)
           OR (param-estoq.cod-cenar-ifrs-2 = c-lb-gerencial)
           THEN DO:
              run utp/ut-msgs.p (input "show":U, 
                                    input 57732, 
                                    INPUT c-lb-msg + "~~" + RETURN-VALUE).
              ASSIGN l-erro = YES.
              return "adm-error".
           END.
         END.
     
     END.

     Run  pi-conecta-ems50( 1). /*Conecta bancos EMS5*/
     IF RETURN-VALUE = "NOK":U THEN
         RETURN "adm-error".
     ELSE DO:
         run prgfin/fgl/fgl920za.py persistent set v_hdl_cenar.
    
         run  pi_main_retorna_cenar_ctbl_empres_1 in v_hdl_cenar(input i-ep-codigo-usuario,
                                                                 input today,
                                                                 output table tt_cenar_ctbl_ems5,
                                                                 output table tt_erro_fgl).
         delete procedure v_hdl_cenar.
         assign v_hdl_cenar = ?.
    
         if  c-cod-cenario-ma-1-geren:sensitive IN FRAME {&FRAME-NAME} and
             not can-find (first tt_cenar_ctbl_ems5
                          where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-1-geren:screen-value IN FRAME {&FRAME-NAME}) then do:
             {utp/ut-liter.i "Cen†rio Cont†bil"}
             run utp/ut-msgs.p (input "show":U, 
                               input 2, 
                               INPUT return-value + "~~" + c-cod-cenario-ma-1-geren:screen-value IN FRAME {&FRAME-NAME}).
             ASSIGN l-erro = YES.
             return "adm-error".
         end.
         ELSE IF can-find (first tt_cenar_ctbl_ems5
                           where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-1-geren:screen-value IN FRAME {&FRAME-NAME}
                            AND NOT tt_cenar_ctbl_ems5.tta_log_cenar_ifrs) THEN DO:
            {utp/ut-liter.i "Cen†rio Cont†bil n∆o Ç IFRS"}
                ASSIGN c-lb-msg = RETURN-VALUE.
            {utp/ut-liter.i "O Cen†rio Cont†bil informado n∆o est† parametrizado como IFRS."}
             run utp/ut-msgs.p (input "show":U, 
                               input 17006, 
                               INPUT c-lb-msg + "~~" + RETURN-VALUE).
             ASSIGN l-erro = YES.
             return "adm-error".

         END.
         if  c-cod-cenario-ma-2-geren:sensitive IN FRAME {&FRAME-NAME} and
             not can-find (first tt_cenar_ctbl_ems5
                          where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-2-geren:screen-value IN FRAME {&FRAME-NAME}) then do:
             {utp/ut-liter.i "Cen†rio Cont†bil"}
             run utp/ut-msgs.p (input "show":U, 
                               input 2, 
                               INPUT return-value + "~~" + c-cod-cenario-ma-2-geren:screen-value IN FRAME {&FRAME-NAME}).
             ASSIGN l-erro = YES.
             return "adm-error".
         end.
         ELSE IF can-find (first tt_cenar_ctbl_ems5
                          where tt_cenar_ctbl_ems5.tta_cod_cenar_ctbl = c-cod-cenario-ma-2-geren:screen-value IN FRAME {&FRAME-NAME}
                            AND NOT tt_cenar_ctbl_ems5.tta_log_cenar_ifrs) THEN DO:
             {utp/ut-liter.i "Cen†rio Cont†bil n∆o Ç IFRS"}
                ASSIGN c-lb-msg = RETURN-VALUE.
             {utp/ut-liter.i "O Cen†rio Cont†bil informado n∆o est† parametrizado como IFRS."}
              run utp/ut-msgs.p (input "show":U, 
                                input 17006, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
              ASSIGN l-erro = YES.
              return "adm-error".

         END.
            
         IF  c-cod-cenario-ma-1-geren:screen-value IN FRAME {&FRAME-NAME} = c-cod-cenario-ma-2-geren:screen-value IN FRAME {&FRAME-NAME} AND
             l-ifrs-moeda-alt-1:checked in frame {&frame-name} AND
             l-ifrs-moeda-alt-2:checked in frame {&frame-name} THEN DO:
             {utp/ut-liter.i "Cen†rio Cont†bil j† informado"}
                ASSIGN c-lb-msg = RETURN-VALUE.
             {utp/ut-liter.i "N∆o Ç permitido cadastrar o mesmo Cen†rio Cont†bil para as duas moedas alternativas."}
              run utp/ut-msgs.p (input "show":U, 
                                input 17006, 
                                INPUT c-lb-msg + "~~" + RETURN-VALUE).
              ASSIGN l-erro = YES.
              return "adm-error".
         END.
     END.

     IF l-conectou-ems5 THEN
        Run  pi-conecta-ems50( 2). /*Desconecta bancos EMS5*/

     FIND moeda WHERE mo-codigo = int(param-estoq.cdn-moed-geren-1:SCREEN-VALUE IN FRAME {&frame-name})  no-lock no-error.
     IF NOT AVAILABLE moeda THEN DO:

         {utp/ut-liter.i "Moeda_Funcional"}                                    
         run utp/ut-msgs.p (input "show":U,                                           
                            input 495,                                              
                            input return-value).
         ASSIGN l-erro = YES.
         RETURN "adm-error".
     END.

     FIND moeda WHERE mo-codigo = int(param-estoq.cdn-moed-geren-2:SCREEN-VALUE IN FRAME {&frame-name})  no-lock no-error.
     IF NOT AVAILABLE moeda THEN DO:
         {utp/ut-liter.i "Moeda_Alternativa_2"}                                    
         run utp/ut-msgs.p (input "show":U,                                           
                            input 495,                                              
                            input return-value).
         ASSIGN l-erro = YES.
         RETURN "adm-error".
     END.

 end.


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

