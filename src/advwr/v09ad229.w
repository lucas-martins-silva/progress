&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V09AD229 2.00.00.014}  /*** 010014 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09AD229 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{utp/ut-glob.i}

define var i-tipo-repres               as int             no-undo.
define new global shared var c-cod-rep as char            no-undo.
define var hProgramZoom                as handle          no-undo.
define var h_repres                    as widget-handle   no-undo.
define var h-cod-imp                   as handle          no-undo.
define var i-cod-fornec-ant            as int             no-undo.

define buffer b-repres for repres.

/* miniflexibilizaá∆o */
{cdp/cdcfgfin.i}

{cdp/cd8889.i} /* tt-cod-ir */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES repres
&Scoped-define FIRST-EXTERNAL-TABLE repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR repres scrolling.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-29 RECT-35 RECT-36 RECT-37 
&Scoped-Define DISPLAYED-OBJECTS rs-tipo-repres rs-comissao ~
tg-comis-proporcional tg-bloqueado-pagto de-valor-min i-cod-moeda ~
c-desc-moeda dt-desligam c-cod-calend i-matric i-cod-fornec c-desc-fornec ~
i-cod-imposto c-desc-imposto c-cod-retencao c-desc-retencao ~
i-cod-imp-indeniz c-desc-imp-indeniz c-cod-ret-indeniz c-desc-ret-indeniz 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,List-3,List-4,List-5,List-6      */
&Scoped-define ADM-ASSIGN-FIELDS rs-tipo-repres rs-comissao ~
tg-comis-proporcional tg-bloqueado-pagto de-valor-min i-cod-moeda ~
dt-desligam c-cod-calend i-cod-fornec i-cod-imposto c-cod-retencao 

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
DEFINE VARIABLE c-cod-calend AS CHARACTER FORMAT "X(3)":U 
     LABEL "Calend†rio Pagto." 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ret-indeniz AS CHARACTER FORMAT "X(4)":U 
     LABEL "C¢d. Retená∆o Indeniz." 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-retencao AS CHARACTER FORMAT "X(4)":U 
     LABEL "C¢digo Retená∆o" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-fornec AS CHARACTER FORMAT "X(15)":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-imp-indeniz AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-imposto AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda AS CHARACTER FORMAT "X(10)":U 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ret-indeniz AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-retencao AS CHARACTER FORMAT "X(50)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE de-valor-min AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor M°nimo" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE dt-desligam AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Desligamento" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-fornec AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-imp-indeniz AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "C¢d. Imposto Indeniz." 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-imposto AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "C¢digo Imposto" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-moeda AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE i-matric AS INTEGER FORMAT "99999999":U INITIAL 0 
     LABEL "Matr°cula Funcion†rio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE rs-comissao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Valor L°quido", 1,
"Valor Bruto", 2
     SIZE 16 BY 1.5 NO-UNDO.

DEFINE VARIABLE rs-tipo-repres AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Funcion†rio", 1,
"Autìnomo", 2
     SIZE 16 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-29
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 2.

DEFINE RECTANGLE RECT-35
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 23 BY 2.

DEFINE RECTANGLE RECT-36
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 36 BY 2.

DEFINE RECTANGLE RECT-37
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 7.29.

DEFINE VARIABLE tg-bloqueado-pagto AS LOGICAL INITIAL no 
     LABEL "Bloqueado para Pagamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 34.14 BY .63 NO-UNDO.

DEFINE VARIABLE tg-comis-proporcional AS LOGICAL INITIAL no 
     LABEL "Comiss∆o Proporcional ao Pagto." 
     VIEW-AS TOGGLE-BOX
     SIZE 34.14 BY .63 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     text-1 AT ROW 1.04 COL 1.86 COLON-ALIGNED NO-LABEL
     text-2 AT ROW 1.13 COL 24.86 COLON-ALIGNED NO-LABEL
     rs-tipo-repres AT ROW 1.71 COL 3 NO-LABEL
     rs-comissao AT ROW 1.71 COL 26.57 NO-LABEL
     tg-comis-proporcional AT ROW 1.71 COL 49.57
     tg-bloqueado-pagto AT ROW 2.46 COL 49.57
     de-valor-min AT ROW 3.58 COL 23 COLON-ALIGNED
     i-cod-moeda AT ROW 3.58 COL 54.86 COLON-ALIGNED
     c-desc-moeda AT ROW 3.58 COL 59.57 COLON-ALIGNED NO-LABEL
     dt-desligam AT ROW 4.58 COL 23 COLON-ALIGNED
     c-cod-calend AT ROW 4.58 COL 54.86 COLON-ALIGNED
     i-matric AT ROW 5.58 COL 23 COLON-ALIGNED
     i-cod-fornec AT ROW 5.58 COL 54.86 COLON-ALIGNED
     c-desc-fornec AT ROW 5.58 COL 66.57 COLON-ALIGNED NO-LABEL
     i-cod-imposto AT ROW 6.58 COL 23 COLON-ALIGNED
     c-desc-imposto AT ROW 6.58 COL 31 COLON-ALIGNED NO-LABEL
     c-cod-retencao AT ROW 7.58 COL 23 COLON-ALIGNED
     c-desc-retencao AT ROW 7.58 COL 31 COLON-ALIGNED NO-LABEL
     i-cod-imp-indeniz AT ROW 8.58 COL 23 COLON-ALIGNED
     c-desc-imp-indeniz AT ROW 8.58 COL 31 COLON-ALIGNED NO-LABEL
     c-cod-ret-indeniz AT ROW 9.58 COL 23 COLON-ALIGNED
     c-desc-ret-indeniz AT ROW 9.58 COL 31 COLON-ALIGNED NO-LABEL
     RECT-29 AT ROW 1.29 COL 1.57
     RECT-35 AT ROW 1.29 COL 25
     RECT-36 AT ROW 1.29 COL 48.57
     RECT-37 AT ROW 3.42 COL 1.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.repres
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
         HEIGHT             = 9.71
         WIDTH              = 84.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-calend IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-cod-ret-indeniz IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-retencao IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN c-desc-fornec IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-imp-indeniz IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-imposto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ret-indeniz IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-retencao IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-valor-min IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN dt-desligam IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-cod-fornec IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-cod-imp-indeniz IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-imposto IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-cod-moeda IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN i-matric IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET rs-comissao IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR RADIO-SET rs-tipo-repres IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN text-1 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN text-2 IN FRAME F-Main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR TOGGLE-BOX tg-bloqueado-pagto IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-comis-proporcional IN FRAME F-Main
   NO-ENABLE 2                                                          */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-cod-calend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-calend V-table-Win
ON F5 OF c-cod-calend IN FRAME F-Main /* Calend†rio Pagto. */
DO:
    {method/Zoomfields.i &ProgramZoom="rczoom/z01rc011.w"
                         &FieldZoom1="cod_calend_comis"
                         &FieldScreen1="c-cod-calend"
                         &Frame1="F-Main"                   
                         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-calend V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-calend IN FRAME F-Main /* Calend†rio Pagto. */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-ret-indeniz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ret-indeniz V-table-Win
ON F5 OF c-cod-ret-indeniz IN FRAME F-Main /* C¢d. Retená∆o Indeniz. */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad999.w"
                       &campo=c-cod-ret-indeniz
                       &campozoom=tt-cod-ir.c-cod}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ret-indeniz V-table-Win
ON LEAVE OF c-cod-ret-indeniz IN FRAME F-Main /* C¢d. Retená∆o Indeniz. */
DO:
    {include/leave.i &tabela=tt-cod-ir
                     &atributo-ref=c-desc
                     &variavel-ref=c-desc-ret-indeniz
                     &where="tt-cod-ir.c-cod = input frame {&frame-name} c-cod-ret-indeniz"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-ret-indeniz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-ret-indeniz IN FRAME F-Main /* C¢d. Retená∆o Indeniz. */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-retencao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-retencao V-table-Win
ON F5 OF c-cod-retencao IN FRAME F-Main /* C¢digo Retená∆o */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad999.w"
                       &campo=c-cod-retencao
                       &campozoom=tt-cod-ir.c-cod}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-retencao V-table-Win
ON LEAVE OF c-cod-retencao IN FRAME F-Main /* C¢digo Retená∆o */
DO:
    {include/leave.i &tabela=tt-cod-ir
                     &atributo-ref=c-desc
                     &variavel-ref=c-desc-retencao
                     &where="tt-cod-ir.c-cod = input frame {&frame-name} c-cod-retencao"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-retencao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-retencao IN FRAME F-Main /* C¢digo Retená∆o */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-fornec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fornec V-table-Win
ON F5 OF i-cod-fornec IN FRAME F-Main /* Fornecedor */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad098.w"
                       &campo=i-cod-fornec
                       &campozoom=cod-emitente
                       &campo2=c-desc-fornec
                       &campozoom2=nome-abrev}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fornec V-table-Win
ON LEAVE OF i-cod-fornec IN FRAME F-Main /* Fornecedor */
DO:
    {include/leave.i &tabela=emitente
                   &atributo-ref=nome-abrev
                   &variavel-ref=c-desc-fornec
                   &where="emitente.cod-emitente = input frame {&frame-name}
                   i-cod-fornec"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-fornec V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-fornec IN FRAME F-Main /* Fornecedor */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-imp-indeniz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imp-indeniz V-table-Win
ON F5 OF i-cod-imp-indeniz IN FRAME F-Main /* C¢d. Imposto Indeniz. */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                       &campo=i-cod-imp-indeniz
                       &campozoom=cod-tax
                       &campo2=c-desc-imp-indeniz
                       &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imp-indeniz V-table-Win
ON LEAVE OF i-cod-imp-indeniz IN FRAME F-Main /* C¢d. Imposto Indeniz. */
DO:
    {include/leave.i &tabela=tipo-tax
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-imp-indeniz
                     &where="tipo-tax.cod-tax = input frame {&frame-name} i-cod-imp-indeniz"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imp-indeniz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-imp-indeniz IN FRAME F-Main /* C¢d. Imposto Indeniz. */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-imposto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imposto V-table-Win
ON F5 OF i-cod-imposto IN FRAME F-Main /* C¢digo Imposto */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="dizoom/z01di217.w"
                       &campo=i-cod-imposto
                       &campozoom=cod-tax
                       &campo2=c-desc-imposto
                       &campozoom2=descricao}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imposto V-table-Win
ON LEAVE OF i-cod-imposto IN FRAME F-Main /* C¢digo Imposto */
DO:
    {include/leave.i &tabela=tipo-tax
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-imposto
                     &where="tipo-tax.cod-tax = input frame {&frame-name} i-cod-imposto"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imposto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-imposto IN FRAME F-Main /* C¢digo Imposto */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-moeda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-moeda V-table-Win
ON F5 OF i-cod-moeda IN FRAME F-Main /* Moeda */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom='unzoom/z01un005.w'
                       &campo=i-cod-moeda
                       &campozoom=mo-codigo
                       &campo2=c-desc-moeda
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-moeda V-table-Win
ON LEAVE OF i-cod-moeda IN FRAME F-Main /* Moeda */
DO:
    {include/leave.i &tabela=moeda
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-moeda
                     &where="moeda.mo-codigo=input frame {&FRAME-NAME} i-cod-moeda"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-moeda V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-moeda IN FRAME F-Main /* Moeda */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-tipo-repres
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-tipo-repres V-table-Win
ON VALUE-CHANGED OF rs-tipo-repres IN FRAME F-Main
DO:
    run pi-funcao (input 4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

    {btb/btb008za.i0} 

    &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         

    /************************ INTERNAL PROCEDURES ********************/

    i-cod-fornec:load-mouse-pointer      ('image/lupa.cur').
    i-cod-imposto:load-mouse-pointer     ('image/lupa.cur').
    i-cod-moeda:load-mouse-pointer       ('image/lupa.cur').  
    c-cod-calend:load-mouse-pointer      ('image/lupa.cur').  
    c-cod-retencao:load-mouse-pointer    ('image/lupa.cur').
    i-cod-imp-indeniz:load-mouse-pointer ('image/lupa.cur').
    c-cod-ret-indeniz:load-mouse-pointer ('image/lupa.cur').

    {utp/ut-liter.i Bloqueado_para_Pagamento * R}
    assign tg-bloqueado-pagto:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Comiss∆o_Proporcional_ao_Pagamento * R}
    assign tg-comis-proporcional:label in frame {&FRAME-NAME} = return-value.

    {utp/ut-liter.i Valor_M°nimo * L}
    assign de-valor-min:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Moeda * L}
    assign i-cod-moeda:label in frame {&FRAME-NAME} = return-value.

    {utp/ut-liter.i Data_Desligamento * L}
    assign dt-desligam:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Calend†rio_Pagto. * L}
    assign c-cod-calend:label in frame {&FRAME-NAME} = return-value.

    {utp/ut-liter.i Matr°cula_Funcion†rio * L}
    assign i-matric:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i Fornecedor * L}
    assign i-cod-fornec:label in frame {&FRAME-NAME} = return-value.

    {utp/ut-liter.i C¢digo_Imposto * L}
    assign i-cod-imposto:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i C¢digo_de_Retená∆o * L}
    assign c-cod-retencao:label in frame {&FRAME-NAME} = return-value.

    {utp/ut-liter.i C¢d._Imposto_Indeniz. * R}
    assign i-cod-imp-indeniz:label in frame {&FRAME-NAME} = return-value.
    {utp/ut-liter.i C¢d._Retená∆o_Indeniz. * R}
    assign c-cod-ret-indeniz:label in frame {&FRAME-NAME} = return-value.

    {utp/ut-rdset.i rs-tipo-repres *}

    {utp/ut-rdset.i rs-comissao *}

/*    run pi-funcao (6).*/

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
  {src/adm/template/row-list.i "repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "repres"}

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
  HIDE FRAME F-Main.
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
    /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).

    {utp/ut-liter.i Tipo_Representante * R}
    assign text-1:screen-value in frame {&frame-name} = return-value.

    {utp/ut-liter.i Comiss∆o_Sobre * R}
    assign text-2:screen-value in frame {&frame-name} = return-value.

    apply "value-changed" to rs-tipo-repres in frame {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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
    run pi-validate.
    if return-value = 'adm-error' then
        return 'adm-error'.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    run pi-funcao (input 2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method.                                 */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) . 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    run pi-funcao (input 2).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
    if  valid-handle(h_repres) then
        delete procedure h_repres.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method.                         */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .  

    run pi-funcao (input 1).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 

    {utp/ut-liter.i Tipo_Representante * R}
    assign text-1:screen-value in frame {&frame-name} = return-value.

    {utp/ut-liter.i Comiss∆o_Sobre * R}
    assign text-2:screen-value in frame {&frame-name} = return-value.

    run pi-funcao (input 3).
    apply "leave" to i-cod-imposto  in frame {&FRAME-NAME}.
    apply "leave" to c-cod-retencao in frame {&FRAME-NAME}.
    apply "leave" to i-cod-fornec   in frame {&FRAME-NAME}.

    assign i-cod-fornec-ant = input frame {&FRAME-NAME} i-cod-fornec.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method. */
    if NOT can-find (
        first funcao 
        where funcao.cd-funcao = "Repres 2.00" 
        or funcao.cd-funcao = "Representantes 2.00") then do:

        &IF DEFINED(BF_FIN_RAC) &THEN
            RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . 

            if adm-new-record = yes then do:
                &if defined(ADM-MODIFY-FIELDS) &then
                    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
                &endif
            end.
            run pi-funcao (input 4).
        &ELSE
            run pi-funcao (input 1).
        &ENDIF
    END.
/* RUN notify ('enable-fields, GROUP-ASSIGN-TARGET':U). */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    /* Dispatch standard ADM method.                             */

    run cdp/cd8889.p (output table tt-cod-ir). /* cria tt-cod-ir - C¢digos de Retená∆o */

    /*----- Verifica se o DBO j†ˇ est† inicializado -----*/
    &IF DEFINED(BF_FIN_RAC) &THEN
        find param-global no-lock no-error.
        if param-global.modulo-rac = yes then do:
            IF NOT VALID-HANDLE(h_repres) THEN DO:
                run rcbo/borc006.p persistent set h_repres no-error.
            end.
        end.
    &ENDIF
    /*-----------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ). 

    run pi-funcao (input 1). /* desabilita os campos na tela */

/* **********
    if adm-new-record = yes then
       &if defined(ADM-MODIFY-FIELDS) &then
           enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
       &endif
********** */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atz-dt-deslig V-table-Win 
PROCEDURE pi-atz-dt-deslig :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-dt-desligam AS CHAR NO-UNDO.

assign dt-desligam:SCREEN-VALUE IN FRAME {&FRAME-NAME} = p-dt-desligam.

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
case p-ind:
    when 1 then do: /*initialize-disable*/
        assign i-matric:sensitive              in frame {&FRAME-NAME} = no
               i-cod-fornec:sensitive          in frame {&FRAME-NAME} = no
               c-desc-fornec:sensitive         in frame {&FRAME-NAME} = no
               i-cod-imposto:sensitive         in frame {&FRAME-NAME} = no
               c-desc-imposto:sensitive        in frame {&FRAME-NAME} = no
               c-cod-retencao:sensitive        in frame {&FRAME-NAME} = no
               c-desc-retencao:sensitive       in frame {&FRAME-NAME} = no
               c-cod-calend:sensitive          in frame {&FRAME-NAME} = no
               de-valor-min:sensitive          in frame {&FRAME-NAME} = no
               i-cod-moeda:sensitive           in frame {&FRAME-NAME} = no
               c-desc-moeda:sensitive          in frame {&FRAME-NAME} = no
               rs-comissao:sensitive           in frame {&FRAME-NAME} = no
               rs-tipo-repres:sensitive        in frame {&FRAME-NAME} = no
               dt-desligam:sensitive           in frame {&FRAME-NAME} = no
               tg-bloqueado-pagto:sensitive    in frame {&FRAME-NAME} = no
               tg-comis-proporcional:sensitive in frame {&FRAME-NAME} = no
               i-cod-imp-indeniz:sensitive     in frame {&FRAME-NAME} = no
               c-desc-imp-indeniz:sensitive    in frame {&FRAME-NAME} = no
               c-cod-ret-indeniz:sensitive     in frame {&FRAME-NAME} = no
               c-desc-ret-indeniz:sensitive    in frame {&FRAME-NAME} = no.
    end.
end.
&IF DEFINED(BF_FIN_RAC) &THEN
  find param-global no-lock no-error.
  if param-global.modulo-rac = yes then do:
    case p-ind:
        when 2 then do: /*assign*/
            assign repres.fc-codigo          = input frame {&FRAME-NAME} i-matric
                   repres.cod-emitente       = input frame {&FRAME-NAME} i-cod-fornec 
                   repres.cod-tax            = input frame {&FRAME-NAME} i-cod-imposto
                   repres.calendario-pagto   = input frame {&FRAME-NAME} c-cod-calend
                   repres.tipo-repres        = input frame {&FRAME-NAME} rs-tipo-repres
                   repres.tipo-comis         = input frame {&FRAME-NAME} rs-comissao
                   repres.dt-deslig          = input frame {&FRAME-NAME} dt-desligam
                   repres.bloqueado-pagto    = input frame {&FRAME-NAME} tg-bloqueado-pagto
                   repres.comis-propor       = input frame {&FRAME-NAME} tg-comis-proporcional
                   repres.cod-retencao       = integer(input frame {&FRAME-NAME} c-cod-retencao)
                   repres.cod-tax-indeniz    = input frame {&FRAME-NAME} i-cod-imp-indeniz
                   repres.cod-retenc-indeniz = integer(input frame {&FRAME-NAME} c-cod-ret-indeniz)
                   repres.mo-codigo          = input frame {&FRAME-NAME} i-cod-moeda
                   repres.vl-minimo-comis    = input frame {&FRAME-NAME} de-valor-min.
        end.
        when 3 then do: /*display*/
            if avail repres then do:
                assign i-matric:screen-value              in frame {&FRAME-NAME} = string(repres.fc-codigo)
                       i-cod-fornec:screen-value          in frame {&FRAME-NAME} = string(repres.cod-emitente)
                       i-cod-imposto:screen-value         in frame {&FRAME-NAME} = string(repres.cod-tax)
                       c-cod-calend:screen-value          in frame {&FRAME-NAME} = string(repres.calendario-pagto)
                       rs-tipo-repres:screen-value        in frame {&FRAME-NAME} = string(repres.tipo-repres)
                       rs-comissao:screen-value           in frame {&FRAME-NAME} = string(repres.tipo-comis)
                       dt-desligam:screen-value           in frame {&FRAME-NAME} = string(repres.dt-deslig)
                       tg-bloqueado-pagto:screen-value    in frame {&FRAME-NAME} = string(repres.bloqueado-pagto)
                       tg-comis-proporcional:screen-value in frame {&FRAME-NAME} = string(repres.comis-propor)
                       c-cod-retencao:screen-value        in frame {&FRAME-NAME} = string(repres.cod-retencao, "9999")
                       i-cod-imp-indeniz:screen-value     in frame {&FRAME-NAME} = string(repres.cod-tax-indeniz)
                       c-cod-ret-indeniz:screen-value     in frame {&FRAME-NAME} = string(repres.cod-retenc-indeniz, "9999")
                       i-cod-moeda:screen-value           in frame {&FRAME-NAME} = string(repres.mo-codigo)
                       de-valor-min:screen-value          in frame {&FRAME-NAME} = string(repres.vl-minimo-comis).
             end.
             /*Descriá∆o da Moeda*/
             find first moeda
                 where moeda.mo-codigo = repres.mo-codigo no-lock no-error.
             if avail moeda then assign c-desc-moeda:screen-value in frame {&FRAME-NAME} = moeda.descricao.
             else assign c-desc-moeda:screen-value in frame {&FRAME-NAME} = "".
             /*Descriá∆o do Imposto*/
             find first tipo-tax 
                 where tipo-tax.cod-tax = repres.cod-tax no-lock no-error.
             if avail tipo-tax then assign c-desc-imposto:screen-value in frame {&FRAME-NAME} = tipo-tax.descricao.
             else assign c-desc-imposto:screen-value in frame {&FRAME-NAME} = "".
             /*Descriá∆o do Imposto Indenizaá∆o*/
             find first tipo-tax 
                 where tipo-tax.cod-tax = repres.cod-tax-indeniz no-lock no-error.
             if avail tipo-tax then assign c-desc-imp-indeniz:screen-value in frame {&FRAME-NAME} = tipo-tax.descricao.
             else assign c-desc-imp-indeniz:screen-value in frame {&FRAME-NAME} = "".                               
             /*Descriá∆o do Fornecedor*/
             if avail emitente then assign c-desc-fornec:screen-value in frame {&FRAME-NAME} = emitente.nome-abrev.
             else assign c-desc-fornec:screen-value in frame {&FRAME-NAME} = "".
             /*Descriá∆o do C¢d. de Retená∆o*/
             find first tt-cod-ir
                 where tt-cod-ir.c-cod = string(repres.cod-retencao, "9999") no-lock no-error.
             if avail tt-cod-ir then assign c-desc-retencao:screen-value in frame {&FRAME-NAME} = tt-cod-ir.c-desc.
             else assign c-desc-retencao:screen-value in frame {&FRAME-NAME} = "".
             /*Descriá∆o do C¢d. de Retená∆o Indenizaá∆o*/
             find first tt-cod-ir
                 where tt-cod-ir.c-cod = string(repres.cod-retenc-indeniz, "9999") no-lock no-error.
             if avail tt-cod-ir then assign c-desc-ret-indeniz:screen-value in frame {&FRAME-NAME} = tt-cod-ir.c-desc.
             else assign c-desc-ret-indeniz:screen-value in frame {&FRAME-NAME} = "".
         end.
         when 4 then do:   /* value-changed rs-tipo-repres - enable */
             if rs-tipo-repres:screen-value in frame {&FRAME-NAME} = "1" then do:
                 assign i-matric:sensitive              in frame {&FRAME-NAME} = yes
                        i-cod-fornec:sensitive          in frame {&FRAME-NAME} = no 
                        i-cod-imposto:sensitive         in frame {&FRAME-NAME} = no
                        c-cod-retencao:sensitive        in frame {&FRAME-NAME} = no
                        c-cod-calend:sensitive          in frame {&FRAME-NAME} = no
                        de-valor-min:sensitive          in frame {&FRAME-NAME} = no
                        i-cod-moeda:sensitive           in frame {&FRAME-NAME} = no
                        i-cod-imp-indeniz:sensitive     in frame {&FRAME-NAME} = no
                        c-desc-imp-indeniz:sensitive    in frame {&FRAME-NAME} = no
                        c-cod-ret-indeniz:sensitive     in frame {&FRAME-NAME} = no
                        c-desc-ret-indeniz:sensitive    in frame {&FRAME-NAME} = no
                        i-cod-fornec:screen-value       in frame {&FRAME-NAME} = "0"
                        c-desc-fornec:screen-value      in frame {&FRAME-NAME} = ""
                        i-cod-imposto:screen-value      in frame {&FRAME-NAME} = "0"
                        c-desc-imposto:screen-value     in frame {&FRAME-NAME} = ""
                        c-cod-retencao:screen-value     in frame {&FRAME-NAME} = "0"
                        c-desc-retencao:screen-value    in frame {&FRAME-NAME} = ""
                        c-cod-calend:screen-value       in frame {&FRAME-NAME} = ""
                        de-valor-min:screen-value       in frame {&FRAME-NAME} = "0"
                        i-cod-moeda:screen-value        in frame {&FRAME-NAME} = ""
                        c-desc-moeda:screen-value       in frame {&FRAME-NAME} = ""
                        i-cod-imp-indeniz:screen-value  in frame {&FRAME-NAME} = "0"
                        c-desc-imp-indeniz:screen-value in frame {&FRAME-NAME} = ""
                        c-cod-ret-indeniz:screen-value  in frame {&FRAME-NAME} = "0"
                        c-desc-ret-indeniz:screen-value in frame {&FRAME-NAME} = "".
             end.
             else do:
                 assign i-matric:sensitive           in frame {&FRAME-NAME} = no
                        i-cod-fornec:sensitive       in frame {&FRAME-NAME} = yes
                        c-cod-calend:sensitive       in frame {&FRAME-NAME} = yes
                        de-valor-min:sensitive       in frame {&FRAME-NAME} = yes
                        i-cod-moeda:sensitive        in frame {&FRAME-NAME} = yes
                        i-cod-imp-indeniz:sensitive  in frame {&FRAME-NAME} = yes
                        c-cod-ret-indeniz:sensitive  in frame {&FRAME-NAME} = yes
                        i-cod-imposto:sensitive      in frame {&FRAME-NAME} = yes
                        c-cod-retencao:sensitive     in frame {&FRAME-NAME} = yes
                        i-matric:screen-value        in frame {&FRAME-NAME} = "0".
             end.   
         end.
     end.
  end.
  else do:
    case p-ind:
        when 2 then do:   /* assign records */
            assign repres.cod-tax      = input frame {&FRAME-NAME} i-cod-imposto
                   repres.tipo-repres  = integer(rs-tipo-repres:screen-value in frame {&FRAME-NAME})
                   repres.cod-retencao = integer(input frame {&FRAME-NAME} c-cod-retencao).
        end.
        when 3 then do:   /* display */
            if avail repres then do:
                assign i-cod-imposto:screen-value  in frame {&FRAME-NAME} = string(repres.cod-tax)
                       rs-tipo-repres:screen-value in frame {&FRAME-NAME} = string(repres.tipo-repres)
                       c-cod-retencao:screen-value in frame {&FRAME-NAME} = string(repres.cod-retencao, "9999").
            end.
            assign i-matric:sensitive          in frame {&FRAME-NAME} = no
                   i-cod-fornec:sensitive      in frame {&FRAME-NAME} = no
                   c-desc-fornec:sensitive     in frame {&FRAME-NAME} = no
                   i-cod-imposto:sensitive     in frame {&FRAME-NAME} = no
                   c-desc-imposto:sensitive    in frame {&FRAME-NAME} = no
                   c-cod-retencao:sensitive    in frame {&FRAME-NAME} = no
                   c-desc-retencao:sensitive   in frame {&FRAME-NAME} = no
                   c-cod-calend:sensitive      in frame {&FRAME-NAME} = no
                   de-valor-min:sensitive      in frame {&FRAME-NAME} = no
                   i-cod-moeda:sensitive       in frame {&FRAME-NAME} = no
                   c-desc-moeda:sensitive      in frame {&FRAME-NAME} = no
                   rs-comissao:sensitive       in frame {&FRAME-NAME} = no
                   dt-desligam:sensitive       in frame {&FRAME-NAME} = no
                   tg-bloqueado-pagto:sensitive    in frame {&FRAME-NAME} = no
                   tg-comis-proporcional:sensitive in frame {&FRAME-NAME} = no
                   i-cod-imp-indeniz:sensitive     in frame {&FRAME-NAME} = no
                   c-desc-imp-indeniz:sensitive    in frame {&FRAME-NAME} = no
                   c-cod-ret-indeniz:sensitive     in frame {&FRAME-NAME} = no
                   c-desc-ret-indeniz:sensitive    in frame {&FRAME-NAME} = no.
            /*Descriá∆o do Imposto*/
            find first tipo-tax
                where tipo-tax.cod-tax = repres.cod-tax no-lock no-error.
            if avail tipo-tax then assign c-desc-imposto:screen-value in frame {&FRAME-NAME} = tipo-tax.descricao.
            else assign c-desc-imposto:screen-value in frame {&FRAME-NAME} = "".
            /*Descriá∆o do C¢d. de Retená∆o*/
            find first tt-cod-ir
                where tt-cod-ir.c-cod = string(repres.cod-retencao, "9999") no-lock no-error.
            if avail tt-cod-ir then assign c-desc-retencao:screen-value in frame {&FRAME-NAME} = tt-cod-ir.c-desc.
            else assign c-desc-retencao:screen-value in frame {&FRAME-NAME} = "".
        end.
        when 4 then do:   /* value-changed rs-tipo-repres - enable */
            if i-cod-imposto:auto-resize in frame {&FRAME-NAME} = yes then
                rs-tipo-repres:sensitive in frame {&FRAME-NAME} = yes.
            else
                rs-tipo-repres:sensitive in frame {&FRAME-NAME} = no.
            assign i-matric:sensitive              in frame {&FRAME-NAME} = no
                   i-cod-fornec:sensitive          in frame {&FRAME-NAME} = no
                   c-desc-fornec:sensitive         in frame {&FRAME-NAME} = no
                   i-cod-imposto:sensitive         in frame {&FRAME-NAME} = no
                   c-desc-imposto:sensitive        in frame {&FRAME-NAME} = no
                   c-cod-retencao:sensitive        in frame {&FRAME-NAME} = no
                   c-desc-retencao:sensitive       in frame {&FRAME-NAME} = no
                   c-cod-calend:sensitive          in frame {&FRAME-NAME} = no
                   de-valor-min:sensitive          in frame {&FRAME-NAME} = no
                   i-cod-moeda:sensitive           in frame {&FRAME-NAME} = no
                   c-desc-moeda:sensitive          in frame {&FRAME-NAME} = no
                   rs-comissao:sensitive           in frame {&FRAME-NAME} = no
                   dt-desligam:sensitive           in frame {&FRAME-NAME} = no
                   tg-bloqueado-pagto:sensitive    in frame {&FRAME-NAME} = no
                   tg-comis-proporcional:sensitive in frame {&FRAME-NAME} = no
                   i-cod-imp-indeniz:sensitive     in frame {&FRAME-NAME} = no
                   c-desc-imp-indeniz:sensitive    in frame {&FRAME-NAME} = no
                   c-cod-ret-indeniz:sensitive     in frame {&FRAME-NAME} = no
                   c-desc-ret-indeniz:sensitive    in frame {&FRAME-NAME} = no.
            if rs-tipo-repres:screen-value in frame {&FRAME-NAME} = "2" then do:
                if i-cod-imposto:auto-resize in frame {&FRAME-NAME} = yes then
                    assign i-cod-imposto:sensitive  in frame {&FRAME-NAME} = yes
                           c-cod-retencao:sensitive in frame {&FRAME-NAME} = yes.
                else
                    assign i-cod-imposto:sensitive  in frame {&FRAME-NAME} = no
                           c-cod-retencao:sensitive in frame {&FRAME-NAME} = no.
            end.
        end.
    end.
  end.
&ENDIF
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-ir V-table-Win 
PROCEDURE pi-retorna-ir :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    &IF DEFINED(BF_FIN_RAC) &THEN
        find param-global no-lock no-error.
        if param-global.modulo-rac = yes then do:
            def output param p-cod-retencao as char format "x(4)"  no-undo.
            assign p-cod-retencao = input frame {&FRAME-NAME} c-cod-retencao.
        end.
    &ENDIF         

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    &IF DEFINED(BF_FIN_RAC) &THEN
        find param-global no-lock no-error.
        if param-global.modulo-rac = yes then do:

            if input frame {&FRAME-NAME} i-cod-fornec <> 0 then do:
                find first emitente
                    where emitente.cod-emitente = input frame {&FRAME-NAME} i-cod-fornec
                    no-lock no-error.

                /* Fornecedor n∆o Cadastrado */
                if not avail emitente then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",
                                       input 91,
                                       input string(input frame {&FRAME-NAME} i-cod-fornec)).
                    apply "entry" to i-cod-fornec in frame {&frame-name}.
                    Return 'adm-error':U.
                end.
                else do:
                    if emitente.identific = 1 then do:
                        {include/i-vldprg.i}
                        run utp/ut-msgs.p (input "show",
                                           input 15180,
                                           input string(input frame {&FRAME-NAME} i-cod-fornec)).
                        apply "entry" to i-cod-fornec in frame {&frame-name}.
                        Return 'adm-error':U.
                    end.    
                end.        

                if  i-cod-fornec-ant <> input frame {&FRAME-NAME} i-cod-fornec then do:
                    /* Verifica se existe movto para o Fornecedor, caso n∆o exista, o 
                       c¢digo do fornecedor pode ser trocado */

                    find first tit-ap
                         where tit-ap.cod-fornec = input frame {&FRAME-NAME} i-cod-fornec
                           and (tit-ap.origem    = 5
                            or  tit-ap.origem    = 6
                            or  tit-ap.origem    = 7)
                         no-lock no-error.

                    if avail tit-ap then do:
                       {include/i-vldprg.i}
                       run utp/ut-msgs.p (input "show",
                                          input 19236,
                                          input string(input frame {&FRAME-NAME} i-cod-fornec)).
                       apply "entry" to i-cod-fornec in frame {&frame-name}.
                       Return 'adm-error':U.
                    end.
                end.
            end.

            /* Moeda nao Cadastrado */
            if  input frame {&frame-name} i-cod-moeda <> 0 then do:
                find first moeda
                     where moeda.mo-codigo = 
                           input frame {&frame-name} i-cod-moeda no-lock no-error.
                if  not avail moeda then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",
                                       input 495,
                                       input string(input frame {&FRAME-NAME} i-cod-moeda)).
                    apply "entry" to i-cod-moeda in frame {&frame-name}.
                    Return 'adm-error':U.
                 end.
             end.

            /* Imposto nao Cadastrado */
            if input frame {&FRAME-NAME} i-cod-imposto <> 0 then do:
                find first tipo-tax
                    where tipo-tax.cod-tax = input frame {&FRAME-NAME} i-cod-imposto
                    no-lock no-error.

                if not avail tipo-tax then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",
                                       input 17509,
                                       input string(input frame {&FRAME-NAME} i-cod-imposto)).
                    apply "entry" to i-cod-imposto in frame {&frame-name}.
                    Return 'adm-error':U.
                end.
            end.

            /* Calend†rio n∆o Cadastrado */
            if input frame {&FRAME-NAME} c-cod-calend <> "" then do:
                run piValidaCalend in h_repres (input c-cod-calend:screen-value in frame {&FRAME-NAME}).
                if return-value = "NOK":U then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",
                                       input 19651,
                                       input string(input frame {&FRAME-NAME} c-cod-calend)).
                    apply "entry" to c-cod-calend in frame {&frame-name}.
                    Return 'adm-error':U.
                end.                    
            end.

            /* Imposto Indenizaá∆o n∆o Cadastrado */
            if input frame {&FRAME-NAME} i-cod-imp-indeniz <> 0 then do:
                find first tipo-tax
                    where tipo-tax.cod-tax = input frame {&FRAME-NAME} i-cod-imp-indeniz
                    no-lock no-error.

                if not avail tipo-tax then do:
                    {include/i-vldprg.i}
                    run utp/ut-msgs.p (input "show",
                                       input 17509,
                                       input string(input frame {&FRAME-NAME} i-cod-imp-indeniz)).
                    apply "entry" to i-cod-imp-indeniz in frame {&frame-name}.
                    Return 'adm-error':U.
                end.
            end.


        end.        

        /* Imposto deve ser do tipo retená∆o */       
        if input frame {&FRAME-NAME} i-cod-imposto <> 0 then do:
            find first tipo-tax
                where tipo-tax.cod-tax = input frame {&FRAME-NAME} i-cod-imposto
                and   tipo-tax.tipo    = 1
                no-lock no-error.

            if not avail tipo-tax then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 7267,
                                   input string(input frame {&FRAME-NAME} i-cod-imposto)).
                apply "entry" to i-cod-imposto in frame {&frame-name}.
                Return 'adm-error':U.
            end.
        end.

        if integer(input frame {&FRAME-NAME} c-cod-retencao) <> 0 then do:
            find first tt-cod-ir
                where tt-cod-ir.c-cod = input frame {&FRAME-NAME} c-cod-retencao
                no-lock no-error.
            if not avail tt-cod-ir then do:
                /* Tipo de Rendimento inv†lido. Deseja Continuar ? */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U,
                                   input 19650,
                                   input input frame {&FRAME-NAME} c-cod-retencao).
                apply 'entry' to c-cod-retencao in frame {&FRAME-NAME}.
                return "adm-error":U.
            end.
            else do:
                find first emitente no-lock
                     where emitente.cod-emitente =  input frame {&FRAME-NAME} i-cod-fornec
                      no-error.    
                if  avail emitente then do:                
                    {include/i-vldprg.i}
                    {cdp/cd8889.i2 show tt-cod-ir.i-pessoa emitente.natureza "c-cod-retencao in frame {&FRAME-NAME}" "'adm-error':U" emitente.cod-emitente tt-cod-ir.c-cod }
                end. 
           end.         
        end.

        if integer(input frame {&FRAME-NAME} c-cod-ret-indeniz) <> 0 then do:
            find first tt-cod-ir
                where tt-cod-ir.c-cod = input frame {&FRAME-NAME} c-cod-ret-indeniz
                no-lock no-error.
            if not avail tt-cod-ir then do:
                /* Tipo de Rendimento inv†lido. Deseja Continuar ? */
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U,
                                   input 19650,
                                   input input frame {&FRAME-NAME} c-cod-ret-indeniz).
                apply 'entry' to c-cod-ret-indeniz in frame {&FRAME-NAME}.
                return "adm-error":U.
            end.
            else do:
                find first emitente no-lock
                     where emitente.cod-emitente =  input frame {&FRAME-NAME} i-cod-fornec
                      no-error.    
                if  avail emitente then do:                
                    {include/i-vldprg.i}
                    {cdp/cd8889.i2 show tt-cod-ir.i-pessoa emitente.natureza "c-cod-ret-indeniz in frame {&FRAME-NAME}" "'adm-error':U" emitente.cod-emitente tt-cod-ir.c-cod }
                end. 
            end.         
        end.
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
  {src/adm/template/snd-list.i "repres"}

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

