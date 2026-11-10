&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V02IN587 2.00.00.058 } /*** 010058 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in587 MUT}
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
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgmat.i}
{cdp/cd9731.i2}

def var l-erro-ems50   as logical no-undo init no.
def var l-emsbas       as logical no-undo init no.
def var l-emsfin       as logical no-undo init no.
def var l-emsuni       as logical no-undo init no.

{btb/btb009za.i}
def var h-btb009za  as handle no-undo.

def var l-ja-conec-emsbas as logical no-undo.
def var l-ja-conec-emsfin as logical no-undo.
def var l-ja-conec-emsuni as logical no-undo.

def var i-empresa   like param-global.empresa-prin no-undo.
def var l-erro-ems5            as logical initial no no-undo.
def var l-rat-ordem-aux        as logical no-undo.
def var l-rat-medic-aux        as logical no-undo.
def var l-rat-contrat-tot-aux  as logical no-undo.
DEFINE NEW GLOBAL SHARED VARIABLE g-aditivo      AS LOGICAL NO-UNDO.

/* Engenharia Geracao Antecipacao base Evento de Compra */
DEFINE NEW GLOBAL SHARED VARIABLE gc-cod-estabel AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-boin295desc   AS HANDLE      NO-UNDO.
DEFINE VARIABLE c-descr-estabel AS CHARACTER   NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-contrat
&Scoped-define FIRST-EXTERNAL-TABLE param-contrat
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-contrat.cod-estabel ~
param-contrat.it-codigo param-contrat.num-seq-anexo-item ~
param-contrat.controle-rateio param-contrat.controle-eventos ~
param-contrat.cod-esp-prov param-contrat.provis-med ~
param-contrat.controle-reajuste param-contrat.provis-eve ~
param-contrat.conta-contabil 
&Scoped-define ENABLED-TABLES param-contrat
&Scoped-define FIRST-ENABLED-TABLE param-contrat
&Scoped-Define ENABLED-OBJECTS RECT-2 rt-key rt-key-2 rt-mold ~
i-num-seq-fim-central c-estab-central tb_icm_estabel c-serie-prov ~
l-rat-ordem l-rat-medic c-nat-op-prov c-denom l-rat-contrat-tot ~
l-libera-matriz c-label 
&Scoped-Define DISPLAYED-FIELDS param-contrat.cod-estabel ~
param-contrat.it-codigo param-contrat.num-seq-anexo-item ~
param-contrat.controle-aditivo param-contrat.controle-rateio ~
param-contrat.controle-eventos param-contrat.cod-esp-prov ~
param-contrat.provis-med param-contrat.controle-reajuste ~
param-contrat.provis-eve param-contrat.conta-contabil 
&Scoped-define DISPLAYED-TABLES param-contrat
&Scoped-define FIRST-DISPLAYED-TABLE param-contrat
&Scoped-Define DISPLAYED-OBJECTS c-desc-estabel i-num-seq-ini-central ~
i-num-seq-fim-central c-desc-item c-estab-central c-desc-estabel-2 ~
tb_icm_estabel c-serie-prov l-rat-ordem l-rat-medic c-nat-op-prov c-denom ~
l-rat-contrat-tot l-libera-matriz c-label 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS i-num-seq-ini-central ~
i-num-seq-fim-central 
&Scoped-define ADM-ASSIGN-FIELDS i-num-seq-ini-central ~
i-num-seq-fim-central param-contrat.controle-aditivo 
&Scoped-define ADM-MODIFY-FIELDS i-num-seq-ini-central ~
i-num-seq-fim-central param-contrat.it-codigo ~
param-contrat.num-seq-anexo-item 

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
DEFINE VARIABLE c-denom AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-estabel-2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 40.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-estab-central LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-label AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 13.57 BY .67 NO-UNDO.

DEFINE VARIABLE c-nat-op-prov AS CHARACTER FORMAT "X.XX-XXX":U 
     LABEL "Nat Oper Prov" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-serie-prov AS CHARACTER FORMAT "X(6)":U 
     LABEL "S²rie Prov" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-seq-fim-central AS INTEGER FORMAT "9999999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-seq-ini-central AS INTEGER FORMAT "9999999":U INITIAL 1 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65.43 BY 4.46.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22.29 BY 6.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 65.72 BY 1.17.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.54.

DEFINE VARIABLE l-libera-matriz AS LOGICAL INITIAL no 
     LABEL "Libera medi‡Æo sem matriz de rateio" 
     VIEW-AS TOGGLE-BOX
     SIZE 57 BY .71 NO-UNDO.

DEFINE VARIABLE l-rat-contrat-tot AS LOGICAL INITIAL no 
     LABEL "Controle de rateio para contratos com controle total nota" 
     VIEW-AS TOGGLE-BOX
     SIZE 58 BY .75 NO-UNDO.

DEFINE VARIABLE l-rat-medic AS LOGICAL INITIAL no 
     LABEL "Controle rateio para contratos controlados por medi‡Æo" 
     VIEW-AS TOGGLE-BOX
     SIZE 56 BY .75 NO-UNDO.

DEFINE VARIABLE l-rat-ordem AS LOGICAL INITIAL no 
     LABEL "Controle rateio para contratos controlados por ordem" 
     VIEW-AS TOGGLE-BOX
     SIZE 54 BY .75 NO-UNDO.

DEFINE VARIABLE tb_icm_estabel AS LOGICAL INITIAL yes 
     LABEL "Utiliza ICMS Estabelecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-contrat.cod-estabel AT ROW 1.5 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-desc-estabel AT ROW 1.5 COL 35.72 COLON-ALIGNED NO-LABEL
     i-num-seq-ini-central AT ROW 2.5 COL 28 COLON-ALIGNED
     i-num-seq-fim-central AT ROW 3.5 COL 28 COLON-ALIGNED
     param-contrat.it-codigo AT ROW 4.5 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 4.5 COL 45.72 COLON-ALIGNED NO-LABEL
     param-contrat.num-seq-anexo-item AT ROW 5.5 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-estab-central AT ROW 6.5 COL 28 COLON-ALIGNED
          LABEL "":R7
     c-desc-estabel-2 AT ROW 6.5 COL 35.72 COLON-ALIGNED NO-LABEL
     tb_icm_estabel AT ROW 7.96 COL 30.29
     param-contrat.controle-aditivo AT ROW 8 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 18.14 BY .83
     param-contrat.controle-rateio AT ROW 8.71 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 18.14 BY .83
     param-contrat.controle-eventos AT ROW 9.42 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 19.72 BY .83
     c-serie-prov AT ROW 9.5 COL 65.57 COLON-ALIGNED
     param-contrat.cod-esp-prov AT ROW 9.5 COL 81.14 COLON-ALIGNED HELP
          "C½digo da Esp²cie da Provis’o no Contas a Pagar"
          LABEL "Esp" FORMAT "!!!"
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     param-contrat.provis-med AT ROW 9.63 COL 24.86
          VIEW-AS TOGGLE-BOX
          SIZE 26.43 BY .83
     param-contrat.controle-reajuste AT ROW 10.13 COL 2.72
          VIEW-AS TOGGLE-BOX
          SIZE 20 BY .83
     param-contrat.provis-eve AT ROW 10.38 COL 24.86
          VIEW-AS TOGGLE-BOX
          SIZE 25 BY .83
     l-rat-ordem AT ROW 10.5 COL 24.86
     param-contrat.conta-contabil AT ROW 10.5 COL 65.57 COLON-ALIGNED HELP
          ""
          LABEL "Ct Contÿbil Prov":R17 FORMAT "x(17)"
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     l-rat-medic AT ROW 11.25 COL 24.86
     c-nat-op-prov AT ROW 11.46 COL 37.14 COLON-ALIGNED
     c-denom AT ROW 11.46 COL 45.14 COLON-ALIGNED NO-LABEL
     l-rat-contrat-tot AT ROW 12 COL 24.86
     l-libera-matriz AT ROW 12.75 COL 24.86
     c-label AT ROW 9.04 COL 23.29 COLON-ALIGNED NO-LABEL
     RECT-2 AT ROW 9.29 COL 24
     rt-key AT ROW 7.75 COL 1
     rt-key-2 AT ROW 7.75 COL 23.86
     rt-mold AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-contrat
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
         HEIGHT             = 12.79
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-estabel-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estab-central IN FRAME f-main
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL EXP-SIZE                */
/* SETTINGS FOR FILL-IN param-contrat.cod-esp-prov IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR FILL-IN param-contrat.conta-contabil IN FRAME f-main
   EXP-LABEL EXP-FORMAT EXP-HELP                                        */
/* SETTINGS FOR TOGGLE-BOX param-contrat.controle-aditivo IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-num-seq-fim-central IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR FILL-IN i-num-seq-ini-central IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN param-contrat.it-codigo IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN param-contrat.num-seq-anexo-item IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME c-estab-central
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON F5 OF c-estab-central IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                       &campo=c-estab-central
                       &campozoom=cod-estabel}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON LEAVE OF c-estab-central IN FRAME f-main
DO:
  &if defined(bf_mat_contratos) &then 
       if input frame {&frame-name} c-estab-central <> "" then do.
            RUN getDescEstabelec IN h-boin295desc (INPUT input frame {&frame-name} c-estab-central,
                                                   OUTPUT c-descr-estabel).
            if RETURN-VALUE = "NOK":U then do:
                run utp/ut-msgs.p ("show",13, input frame {&frame-name} c-estab-central).
                return no-apply.
            end.
            ELSE
                ASSIGN c-desc-estabel-2:SCREEN-VALUE IN FRAME {&frame-name} = c-descr-estabel.
       end.
   &endif


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estab-central IN FRAME f-main
DO:
  apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-contrat.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-estabel V-table-Win
ON F5 OF param-contrat.cod-estabel IN FRAME f-main /* Estab */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad107.w
                     &campo=param-contrat.cod-estabel
                     &campozoom=cod-estabel}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-estabel V-table-Win
ON LEAVE OF param-contrat.cod-estabel IN FRAME f-main /* Estab */
DO:
    RUN getDescEstabelec IN h-boin295desc (INPUT input frame {&frame-name} param-contrat.cod-estabel,
                                           OUTPUT c-descr-estabel).
    IF RETURN-VALUE = "NOK":U THEN DO:
            run utp/ut-msgs.p ("show",13, input frame {&frame-name} c-estab-central).
            return no-apply.
    END.
    ASSIGN c-desc-estabel:SCREEN-VALUE IN FRAME {&frame-name} = c-descr-estabel.

    /* Engenharia Geracao Antecipacao base Evento de Compra */
    ASSIGN gc-cod-estabel = INPUT FRAME {&FRAME-NAME} param-contrat.cod-estabel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-contrat.cod-estabel IN FRAME f-main /* Estab */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-contrat.controle-rateio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.controle-rateio V-table-Win
ON VALUE-CHANGED OF param-contrat.controle-rateio IN FRAME f-main /* Controle Rateio */
DO:
    if  controle-rateio:checked = no then
        assign l-rat-ordem:checked   = no
               l-rat-medic:checked   = no
               l-rat-ordem:sensitive = no
               l-rat-medic:sensitive = no.
    else
        assign l-rat-ordem:sensitive  = yes
               l-rat-medic:sensitive = yes.

    IF CAN-FIND (FIRST matriz-rat-med) THEN DO:
        ASSIGN l-rat-ordem:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               l-rat-medic:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.

    apply "VALUE-CHANGED" to l-rat-medic.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-contrat.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.it-codigo V-table-Win
ON F5 OF param-contrat.it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in172.w
                     &campo=param-contrat.it-codigo
                     &campozoom=it-codigo}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.it-codigo V-table-Win
ON LEAVE OF param-contrat.it-codigo IN FRAME f-main /* Item */
DO:
    {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name} 
                    param-contrat.it-codigo"}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-contrat.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-contrat.it-codigo IN FRAME f-main /* Item */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-rat-medic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-rat-medic V-table-Win
ON VALUE-CHANGED OF l-rat-medic IN FRAME f-main /* Controle rateio para contratos controlados por medi‡Æo */
DO:
    if  l-rat-ordem:checked = no and
        l-rat-medic:checked = no then
        assign l-libera-matriz:checked     = no
               l-libera-matriz:sensitive   = no.
    else
        assign l-libera-matriz:sensitive   = yes.

    if  l-rat-medic:checked = no then
        assign l-rat-contrat-tot:checked   = no
               l-rat-contrat-tot:sensitive = no.
    else
        assign l-rat-contrat-tot:sensitive = yes.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estab-central V-table-Win
ON VALUE-CHANGED OF param-contrat.controle-aditivo IN FRAME f-main
DO:
    /****CONTROLE DE ADITIVO****/
   if  param-contrat.controle-aditivo:checked = YES THEN DO:

       ASSIGN g-aditivo = YES.

   END.
   ELSE DO:

       ASSIGN g-aditivo = NO.

   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME l-rat-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-rat-ordem V-table-Win
ON VALUE-CHANGED OF l-rat-ordem IN FRAME f-main /* Controle rateio para contratos controlados por ordem */
DO:
  if  l-rat-ordem:checked  = no 
  and l-rat-medic:checked = no then
      assign l-libera-matriz:checked   = no
             l-libera-matriz:sensitive = no.
  else
      assign l-libera-matriz:sensitive = yes.

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

if param-contrat.cod-estabel:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name}
then.
if param-contrat.it-codigo:load-mouse-pointer ("Image~\lupa.cur") in frame {&frame-name}
then.

{utp/ut-liter.i Inicial_Contrato * L}
assign i-num-seq-ini-central:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Final_Contrato * L}
assign i-num-seq-fim-central:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Item_de_Servi»o * L}
assign param-contrat.it-codigo:label in frame {&frame-name} = "Item de Servi»o".

&if defined(bf_mat_contratos) &then 
     if c-estab-central:load-mouse-pointer("image/lupa.cur") then .
     {utp/ut-liter.i Estabelecimento_Central * r}
      assign c-estab-central:label in frame {&frame-name} = trim(return-value).
&endif

/* Caraiba */

     {utp/ut-liter.i Nat_Oper_Prov * r}
      assign c-nat-op-prov:label in frame {&frame-name} = trim(return-value).
     {utp/ut-liter.i Serie_Prov * r}
      assign c-serie-prov:label in frame {&frame-name} = trim(return-value).

/***********/

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
  {src/adm/template/row-list.i "param-contrat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-contrat"}
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

  def var i-num-ini like param-contrat.num-seq-ini-central no-undo.
  def var i-num-fim like param-contrat.num-seq-ini-central no-undo.
  def var l-icm as log no-undo.
  def var c-tipo as char no-undo.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida»„es */
  /* N’o gravar nada no registro antes do dispatch do assign-record e nem na PI-validate.*/  
  /* Dispatch standard ADM method.*/
  
  RUN getDescEstabelec IN h-boin295desc (INPUT input frame {&frame-name} param-contrat.cod-estabel,
                                         OUTPUT c-descr-estabel).  
  if RETURN-VALUE = "NOK":U then do:
     run utp/ut-msgs.p (input "show",
                        input 537, 
                        input " ").
     apply "entry" to param-contrat.cod-estabel in frame {&frame-name}.
     return "adm-error".
  end.                    

  /* Caraiba */
  &if defined (bf_mat_aprov_contratos) &then
      do with frame {&frame-name}:
      if input frame {&frame-name} param-contrat.provis-med 
      or input frame {&frame-name} param-contrat.provis-eve then do:

      find first param-global no-lock no-error.
      assign i-empresa = param-global.empresa-prin.

      /************************** Valida»’o da Esp²cie **************************/

         if can-find(funcao where funcao.cd-funcao = "adm-apb-ems-5.00" 
                     and funcao.ativo = yes) /*and not l-ems50-erro*/ then do:

            RUN btb/btb009za.p PERSISTENT SET h-btb009za.

            run pi-conecta-bases-EMS5 (input  yes, /* connect */
                                       input  i-empresa,
                                       output l-erro-ems5).

            if  l-erro-ems5 then 
                return.

            run prgfin/apb/apb909za.py (input 1,
                                        input param-contrat.cod-esp-prov:screen-value in frame {&frame-name},
                                        output c-tipo). 
            if  c-tipo = " " then do:
                run utp/ut-msgs.p (input "show",
                                   input 624,
                                   input param-contrat.cod-esp-prov:screen-value in frame {&frame-name}).
                run pi-conecta-bases-EMS5 (input  no, /* disconnect */
                                           input  i-empresa,
                                           output l-erro-ems5).        
                return "adm-error".
            end.        
            if  c-tipo <> "Previsao" then do:
                run utp/ut-msgs.p (input "show",
                                   input 18151,
                                   input param-contrat.cod-esp-prov:screen-value in frame {&frame-name}).
                run pi-conecta-bases-EMS5 (input  no, /* disconnect */
                                           input  i-empresa,
                                           output l-erro-ems5).        
                return "adm-error".
            end.
            run pi-conecta-bases-EMS5 (input  no, /* disconnect */
                                       input  i-empresa,
                                       output l-erro-ems5).        
        end.        
        else do:
            /* Previs’o */
            find esp-doc no-lock where
                 esp-doc.cod-esp = param-contrat.cod-esp-prov:screen-value in frame {&frame-name}
                 no-error.
            if  not avail esp-doc then do:
                run utp/ut-msgs.p (input "show",
                                   input 624,
                                   input param-contrat.cod-esp-prov:screen-value in frame {&frame-name}).
                return "adm-error".
            end.
            if  esp-doc.tipo <> 3 then do: 
                run utp/ut-msgs.p (input "show",
                                   input 18151,
                                   input param-contrat.cod-esp-prov:screen-value in frame {&frame-name}).
                return "adm-error".
            end.
        end.

        /************************** Fim Valida»’o Esp²cie **************************/

        /******************* Valida»’o Conta-Contabil Transit½ria ******************/

        if input frame {&frame-name} param-contrat.conta-contabil = "" then do:
            {utp/ut-field.i mgadm conta-contab conta-contabil 1}
            run utp/ut-msgs.p (input "show",
                               input 265,
                               input return-value).
            return "adm-error".
        end.
        if not can-find(first conta-contab 
               where conta-contab.conta-contabil = input frame {&frame-name} param-contrat.conta-contabil)
               then do:
               {utp/ut-table.i mgadm conta-contab 1}
               run utp/ut-msgs.p (input "show",
                                  input 2,
                                  input return-value).
               return "adm-error".
        end.

        /********************** Fim Valida»’o Conta-Contabil **********************/

    /************/
      end.
  &endif      
  &if defined(bf_mat_contratos) &then 
      assign input frame {&frame-name} c-estab-central.
  &endif   

/* Caraiba */
  if avail param-contrat then 
     assign substring(param-contrat.char-1,91,8)  = string(input frame {&frame-name} c-nat-op-prov, "x(8)")
            substring(param-contrat.char-1,93,6) = string(input frame {&frame-name} c-serie-prov, "x(6)").
/***********/

  if  l-matriz-medicao    and
      avail param-contrat then do:

      &IF '{&bf_mat_versao_ems}' >= '2.06' &THEN
          assign param-contrat.log-rat-ord         = if l-rat-ordem:checked in frame {&frame-name} = yes then yes
                                                                                                       else no
                 param-contrat.log-rat-medi        = if l-rat-medic:checked in frame {&frame-name} = yes then yes
                                                                                                        else no
                 param-contrat.log-rat-contrat-tot = if l-rat-contrat-tot:checked in frame {&frame-name} = yes then yes
                                                                                                               else no
                 param-contrat.log-libera-matriz   = if l-libera-matriz:checked in frame {&frame-name} = yes then yes
                                                                                                             else no.
      &ELSE
          assign substr(param-contrat.char-2,1,1) = if l-rat-ordem:checked in frame {&frame-name} = yes then "S":U
                                                                                                      else "N":U
                 substr(param-contrat.char-2,2,1) = if l-rat-medic:checked in frame {&frame-name} = yes then "S":U
                                                                                                       else "N":U
                 substr(param-contrat.char-2,3,1) = if l-rat-contrat-tot:checked in frame {&frame-name} = yes then "S":U
                                                                                                              else "N":U
                 substr(param-contrat.char-2,4,1) = if l-libera-matriz:checked in frame {&frame-name} = yes then "S":U
                                                                                                            else "N":U.
      &ENDIF
  end.

/****************************************************/

  find item 
       where item.it-codigo = input frame {&frame-name} param-contrat.it-codigo
       no-lock no-error.
  if not avail item then do:
     run utp/ut-msgs.p (input "show",
                        input 90,
                        input input frame {&frame-name} param-contrat.it-codigo).
     apply "entry" to param-contrat.cod-estabel in frame {&frame-name}.
     return "adm-error".
  end. 

  if item.tipo-contr <> 4 or 
     item.it-codigo = "" then do:
     run utp/ut-msgs.p (input "show", 
                        input 17653, 
                        input ""). /* Item deve ser D²bito Direto e Codificado. */
      apply "entry" to param-contrat.it-codigo in frame {&frame-name}.
      return "adm-error".
  end.

  /** Verifica»’o se n’o esta  cadastrado como item de algum Contrato **/
  IF  INPUT FRAME {&frame-name} param-contrat.it-codigo <> param-contrat.it-codigo THEN DO:
      IF CAN-FIND(FIRST item-contrat 
                  WHERE item-contrat.it-codigo = param-contrat.it-codigo)
      OR CAN-FIND(FIRST evento-ped
                  WHERE evento-ped.nr-contrato > 0
                    AND evento-ped.it-codigo = param-contrat.it-codigo)
      THEN DO:
          run   utp/ut-msgs.p (input "show", input 8838 , input "").
          /* Item jÿ possui contrato. */
          apply "entry" to param-contrat.it-codigo in frame {&frame-name}.
          return "adm-error".
      END.
  END.

  find first item-contrat 
       where item-contrat.it-codigo = input frame {&frame-name} param-contrat.it-codigo
       no-lock no-error.
  if available item-contrat then do:
       run   utp/ut-msgs.p (input "show", input 8838 , input "").
       /* Item jÿ possui contrato. */
       apply "entry" to param-contrat.it-codigo in frame {&frame-name}.
       return "adm-error".
  end.

  /*--------------------------------------------------------------------*/

  if integer(input frame {&frame-name} i-num-seq-ini-central) = 0 then do:

     {utp/ut-liter.i Inicial_Contrato * L}
     
     run utp/ut-msgs.p (input "show",
                        input 1491,
                        input return-value).

     apply "entry" to i-num-seq-ini-central in frame {&frame-name}.                                          

     return "adm-error".
  end.   

  if input frame {&frame-name} i-num-seq-fim-central < input frame {&frame-name} i-num-seq-ini-central 
     then do:
     run utp/ut-msgs.p (input "show",
                        input 7843,
                        input " ").
     apply "entry" to param-contrat.cod-estabel in frame {&frame-name}.                                          
     return "adm-error".
  end.   

  assign i-num-ini = input frame {&frame-name} i-num-seq-ini-central
         i-num-fim = input frame {&frame-name} i-num-seq-fim-central.

  if  i-pais-impto-usuario = 1 then /* Brasil */
      assign l-icm     = input frame {&frame-name} tb_icm_estabel.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .  
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Todos os assign‹s n’o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */


  if  avail param-contrat then
      assign param-contrat.num-seq-ini-central = i-num-ini
             param-contrat.num-seq-fim-central = i-num-fim.

  &if defined(bf_mat_contratos) &then 
     if  avail param-contrat then 
         assign param-contrat.cod-estab-central = c-estab-central.
  &endif   

  if l-icm then 
     assign param-contrat.int-1 = 1.     
  else 
     assign param-contrat.int-1 = 0.  

  if valid-handle(h-btb009za) then
     DELETE PROCEDURE h-btb009za.

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
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  IF VALID-HANDLE(h-boin295desc) THEN DO:
      DELETE PROCEDURE h-boin295desc.
      ASSIGN h-boin295desc = ?.
  END.

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


if avail param-contrat then do:
   assign i-num-seq-ini-central = if param-contrat.num-seq-ini-central <> 0 then param-contrat.num-seq-ini-central else 1
          i-num-seq-fim-central = param-contrat.num-seq-fim-central.

   &if defined(bf_mat_contratos) &then     
   if  not adm-new-record then
       assign c-estab-central = param-contrat.cod-estab-central.
       display c-estab-central with frame {&frame-name}.
   &endif    

/* Caraiba */   

   assign c-nat-op-prov = substring(param-contrat.char-1,91,8).
   display c-nat-op-prov with frame {&frame-name}.
   assign c-serie-prov = substring(param-contrat.char-1,93,6).
   display c-serie-prov with frame {&frame-name}.

find natur-oper where natur-oper.nat-operacao = c-nat-op-prov no-lock no-error.
if avail natur-oper then do:
   assign c-denom = natur-oper.denominacao. 
   display c-denom with frame {&frame-name}.
end.

/***********/
   display i-num-seq-ini-central
           i-num-seq-fim-central
           param-contrat.controle-aditivo
           with frame {&frame-name}.
   find item where item.it-codigo = param-contrat.it-codigo no-lock no-error.
   assign c-desc-item = if avail item then item.desc-item else "":U.
   find estabelec where estabelec.cod-estabel = param-contrat.cod-estabel no-lock no-error.
   assign c-desc-estabel = if avail estabelec then estabelec.nome else "":U.

   &if defined(bf_mat_contratos) &then 
       find estabelec where estabelec.cod-estabel = param-contrat.cod-estab-central no-lock no-error.
       assign c-desc-estabel-2 = if avail estabelec then estabelec.nome else "":U.
   &endif 

   if param-contrat.int-1 = 1 then 
      assign tb_icm_estabel = yes. 
   else assign tb_icm_estabel = no. 

  end.  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if avail param-contrat then
     disp param-contrat.controle-aditivo with frame {&frame-name}.

/*========================================================================*/
  if l-matriz-medicao then do:
    {utp/ut-liter.i Controle_Rateio}
    assign c-label:screen-value in frame {&frame-name} = TRIM(RETURN-VALUE).

    do with frame {&frame-name}:
        {utp/ut-liter.i Controle_rateio_para_contratos_controlados_por_ordem}  
        ASSIGN l-rat-ordem:LABEL in frame {&frame-name} = TRIM(RETURN-VALUE). 
        {utp/ut-liter.i Controle_rateio_para_contratos_controlados_por_medi‡Æo}  
        ASSIGN l-rat-medic:LABEL in frame {&frame-name} = TRIM(RETURN-VALUE). 
        {utp/ut-liter.i Controle_rateio_para_contratos_com_controle_total_nota}  
        ASSIGN l-rat-contrat-tot:LABEL in frame {&frame-name} = TRIM(RETURN-VALUE). 
        {utp/ut-liter.i Libera_medi‡Æo_sem_matriz_de_rateio}  
        ASSIGN l-libera-matriz:LABEL in frame {&frame-name} = TRIM(RETURN-VALUE). 
        assign param-contrat.provis-med    :hidden = yes
              param-contrat.provis-eve    :hidden = yes
              c-serie-prov                :hidden = yes
              param-contrat.cod-esp-prov  :hidden = yes
              param-contrat.conta-contabil:hidden = yes
              c-nat-op-prov               :hidden = yes
              c-denom                     :hidden = yes
              rect-2                      :hidden = no
              c-label                     :hidden = no
              l-rat-ordem                 :hidden = no
              l-rat-medic                 :hidden = no
              l-rat-contrat-tot           :hidden = no
              l-libera-matriz             :hidden = no
              param-contrat.controle-rateio:column   = 24.86
              param-contrat.controle-rateio:row      = 9.75
              param-contrat.controle-eventos:row     = 8.71
              param-contrat.controle-reajuste:row    = 9.42.
    end.
    if avail param-contrat then do:
      &IF '{&bf_mat_versao_ems}' >= '2.06' &THEN
          do with frame {&frame-name}:
             assign l-rat-ordem:checked       in frame {&frame-name} = if param-contrat.log-rat-ord  = yes then yes
                                                                                                           else no
                    l-rat-medic:checked       in frame {&frame-name} = if param-contrat.log-rat-medi = yes then yes
                                                                                                           else no
                    l-rat-contrat-tot:checked in frame {&frame-name} = if param-contrat.log-rat-contrat-tot = yes then yes
                                                                                                                  else no
                    l-libera-matriz:checked   in frame {&frame-name} = if param-contrat.log-libera-matriz = yes then yes
                                                                                                                else no.
          end.
      &ELSE
          do with frame {&frame-name}:
             assign l-rat-ordem:checked       in frame {&frame-name} = (substr(param-contrat.char-2,1,1) = "S":U)
                    l-rat-medic:checked       in frame {&frame-name} = (substr(param-contrat.char-2,2,1) = "S":U)
                    l-rat-contrat-tot:checked in frame {&frame-name} = (substr(param-contrat.char-2,3,1) = "S":U)
                    l-libera-matriz:checked   in frame {&frame-name} = (substr(param-contrat.char-2,4,1) = "S":U).
          end.
      &ENDIF
      assign l-rat-ordem-aux       = l-rat-ordem:checked         
             l-rat-medic-aux       = l-rat-medic:checked        
             l-rat-contrat-tot-aux = l-rat-contrat-tot:checked.

      apply "value-changed" to controle-rateio.
      apply "value-changed" to l-rat-ordem.
    end.
  end.
/*========================================================================*/  
  else do:
      assign c-label:screen-value in frame {&frame-name} = "Provisäes:".
      &if  defined (bf_mat_aprov_contratos) &then
          do with frame {&frame-name}:
             assign param-contrat.provis-med    :hidden = no
                    param-contrat.provis-eve    :hidden = no
                    c-serie-prov                :hidden = no
                    param-contrat.cod-esp-prov  :hidden = no
                    param-contrat.conta-contabil:hidden = no
                    c-nat-op-prov               :hidden = no
                    c-denom                     :hidden = no
                    rect-2                      :hidden = no
                    c-label                     :hidden = no
                    l-rat-ordem                 :hidden = yes
                    l-rat-medic                 :hidden = yes
                    l-rat-contrat-tot           :hidden = yes
                    l-libera-matriz             :hidden = yes.

          end.
      &else
          do with frame {&frame-name}:
             assign param-contrat.provis-med    :hidden = yes
                    param-contrat.provis-eve    :hidden = yes
                    c-serie-prov                :hidden = yes
                    param-contrat.cod-esp-prov  :hidden = yes
                    param-contrat.conta-contabil:hidden = yes
                    c-nat-op-prov               :hidden = yes
                    c-denom                     :hidden = yes
                    rect-2                      :hidden = yes
                    c-label                     :hidden = yes
                    l-rat-ordem                 :hidden = yes
                    l-rat-medic                 :hidden = yes
                    l-rat-contrat-tot           :hidden = yes
                    l-libera-matriz             :hidden = yes.

          end.
      &endif   
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

&if defined(bf_mat_contratos) &then
enable param-contrat.controle-aditivo with frame {&frame-name}.
&endif

  IF CAN-FIND (FIRST matriz-rat-med) THEN DO:
      ASSIGN param-contrat.controle-rateio:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if defined(bf_mat_contratos) &then 
       assign param-contrat.controle-aditivo:sensitive  in frame {&frame-name} = yes
              c-estab-central:hidden in frame {&frame-name} = FALSE.
       if avail param-contrat then 
          assign c-estab-central:screen-value  in frame {&frame-name} = param-contrat.cod-estab-central.    
  &else
       assign c-estab-central:hidden in frame {&frame-name} = TRUE
              c-desc-estabel-2:hidden in frame {&frame-name} = TRUE.    
  &endif

  if  i-pais-impto-usuario = 1 /* Brasil */
  then
       assign tb_icm_estabel:hidden in frame {&frame-name} = no.
  else
       assign tb_icm_estabel:hidden    in frame {&frame-name} = yes
              rt-key-2:hidden          in frame {&frame-name} = yes   
              tb_icm_estabel:sensitive in frame {&frame-name} = no.

  IF NOT VALID-HANDLE(h-boin295desc) THEN
      RUN inbo/boin295desc.p PERSISTENT SET h-boin295desc.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-bases-EMS5 V-table-Win 
PROCEDURE pi-conecta-bases-EMS5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param l-conecta   as logical no-undo.
    def input  param p-empresa   like param-global.empresa-prin no-undo.
    def output param l-erro-ems5 as logical no-undo.   

    assign l-erro-ems5 = no.

    if  l-conecta then do:
        if  search("prgint/utb/utb907za.py") = ? 
        and search("prgint/utb/utb907za.r")  = ? then do:
            run utp/ut-msgs.p ( input "show":U, input 6246,
                                input "prgint/utb/utb907za.py" ).
            assign l-erro-ems5 = yes.        
        end.
        else do:
            if  connected("emsbas") 
                then assign l-ja-conec-emsbas = yes.
                else assign l-ja-conec-emsbas = no.

            if  connected("emsfin") 
                then assign l-ja-conec-emsfin = yes.
                else assign l-ja-conec-emsfin = no.

            if  connected("emsuni")
                then assign l-ja-conec-emsuni = yes.
                else assign l-ja-conec-emsuni = no.   

            if  l-ja-conec-emsbas = no or 
                l-ja-conec-emsfin = no or
                l-ja-conec-emsuni = no then do:
                run pi-conecta-bco IN h-btb009za (input  1,                       /* Versao API          */
                                                  input  1,                       /* 1 - Conexao, 2 - Desconexao */
                                                  input  p-empresa,               /* Codigo da Empresa   */
                                                  input  "all":U,                 /* Nome do Banco       */
                                                  output table tt_erros_conexao). /* Temp-Table de Erros */
                if  return-value <> "OK":U then do:
                    find first tt_erros_conexao no-lock no-error.
                    if avail tt_erros_conexao then do:
                        run utp/ut-msgs.p (input "msg":U,
                                           input tt_erros_conexao.cd-erro,
                                           input tt_erros_conexao.param-1).
                        assign l-erro-ems5 = yes.        
                        {utp/ut-liter.i Erros_Progress }
                    end.               
                end.            
                else do:
                    if  not connected("emsbas") then do: 
                        run utp/ut-msgs.p (input "msg":U, input 17718, input "EMSBAS").
                        assign l-erro-ems5 = yes.        
                        {utp/ut-liter.i Erros_Progress}                    
                    end.

                    if  not connected("emsfin") then do: 
                        run utp/ut-msgs.p (input "msg":U, input 17718, input "EMSFIN").
                        assign l-erro-ems5 = yes.        
                        {utp/ut-liter.i Erros_Progress }                    
                    end.

                    if  not connected("emsuni") then do:
                        run utp/ut-msgs.p (input "msg":U, input 17718, input "EMSUNI").
                        assign l-erro-ems5 = yes.        
                        {utp/ut-liter.i Erros_Progress }
                    end.
                end.  
            end.
        end.
    end.

    if  not l-conecta or l-erro-ems5 then do:
        if  l-ja-conec-emsuni = no or 
            l-ja-conec-emsbas = no or  
            l-ja-conec-emsfin = no then do: 
            run pi-conecta-bco IN h-btb009za (input 1,                        /* Versao API          */
                                              input 2,                        /* 1 - Conexao, 2 - Desconexao */
                                              input p-empresa,                /* Codigo da Empresa   */
                                              input "all":U,                  /* Nome do Banco       */
                                              output table tt_erros_conexao). /* Temp-Table de Erros */
            if return-value <> "OK":U then do:
                find first tt_erros_conexao no-lock no-error.
                if avail tt_erros_conexao then do:
                   run utp/ut-msgs.p ( input "msg":U,
                                       input tt_erros_conexao.cd-erro,
                                       input tt_erros_conexao.param-1).
                   assign l-erro-ems5 = yes.
                   {utp/ut-liter.i Erros_Progress }                    
                end.
            end.
        end.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mensagem V-table-Win 
PROCEDURE pi-mensagem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if l-rat-ordem-aux = no then
      if l-rat-ordem:checked in frame {&frame-name} <> l-rat-ordem-aux then do:
          run utp/ut-msgs.p (input "show":U, 
                             input 28595, 
                             input ?).
          return return-value.
      end.

  if l-rat-medic-aux = no then
      if l-rat-medic:checked in frame {&frame-name} <> l-rat-medic-aux  then do:
          run utp/ut-msgs.p (input "show":U, 
                             input 28595, 
                             input ?).
          return return-value.
      end.

  if l-rat-contrat-tot-aux = no then
      if l-rat-contrat-tot:checked in frame {&frame-name} <> l-rat-contrat-tot-aux then do:
          run utp/ut-msgs.p (input "show":U, 
                             input 28595, 
                             input ?).
          return return-value.
      end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-mat-beta V-table-Win 
PROCEDURE pi-valida-mat-beta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N’o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida»’o de dicionÿrio */

   /*Segue um exemplo de valida»’o de programa 
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
  {src/adm/template/snd-list.i "param-contrat"}

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

