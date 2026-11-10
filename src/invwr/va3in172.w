&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i VA3IN172 2.00.00.050 } /*** "010050" 15/10/2025 17:41:25 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i VA3IN172 MUT}
&ENDIF


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
def var c-handle1         as character no-undo.
def var wh-cd0903         as handle    no-undo.

/* Vari†veis Localizaá∆o Argentina */
{method/dbotterr.i}
DEFINE VARIABLE hShowMsg            AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boar2006          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boco2005          AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-boin01073         AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bomx2005          AS HANDLE      NO-UNDO. 
DEFINE VARIABLE i-idi-tip-item      AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-combo             AS CHARACTER   NO-UNDO.
DEFINE VARIABLE wg-lb-cod-tax       AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE wg-lb-c-desc-tax    AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE h-bomx2012          AS HANDLE        NO-UNDO.
DEFINE VARIABLE c-cod-livre-1       AS CHAR          NO-UNDO.
DEFINE VARIABLE c-lista             AS CHAR          NO-UNDO.
DEFINE VARIABLE c-lista2            AS CHAR          NO-UNDO.
DEFINE VARIABLE c-liter             AS CHAR          NO-UNDO.
DEFINE VARIABLE c-label             AS CHAR          NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.class-fiscal item.cod-tax 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS cb-tipo-mat-prim tg-isento c-impto-rf ~
cb-idi-tip-item tg-cod-padrao c-cod-ident-item i-cdn-impto-percep-iva ~
c-desc-impto-percep-iva c-cod-tipo-codfic tg-log-exento-iibb-mntrib-caba ~
tg-usa-desc-item-nfe c-modelo tg-promovido c-cod-prod i-cod-atividade tg-ativo-fixo cb-objeto-imp ~
c-text-arg c-ind-tipo-item RECT-ind-tipo-item RECT-1 
&Scoped-Define DISPLAYED-FIELDS item.class-fiscal item.cod-tax 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-descr-mat-prima cb-tipo-mat-prim ~
i-cod-ncm c-desc-classif-fisc tg-isento c-desc-tax c-imposto-mex ~
c-clave-prod-serv c-impto-rf c-desc-impto-rf cb-idi-tip-item ~
c-nro-identific tg-cod-padrao tg-log-percibe-iva c-cod-ident-item ~
c-cod-nico rs-ind-tipo-item i-cdn-impto-percep-iva c-desc-impto-percep-iva ~
c-cod-chave c-cod-tipo-codfic i-cod-imp-percep c-desc-imp-percep tg-log-exento-iibb-mntrib-caba ~
tg-usa-desc-item-nfe c-cod-chave-mater-peri c-modelo tg-promovido i-cod-atividade tg-ativo-fixo ~
c-cod-chave-carta-porte c-cod-prod c-embalagem cb-objeto-imp c-text-arg ~
c-ind-tipo-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS i-cod-ncm 
&Scoped-define ADM-MODIFY-FIELDS i-cod-ncm item.cod-tax rs-ind-tipo-item 

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
DEFINE VARIABLE cb-idi-tip-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Item" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-objeto-imp AS CHARACTER FORMAT "X(256)":U 
     LABEL "Objeto de Imposto" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 38.57 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-mat-prim AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo MatÇria" 
     VIEW-AS COMBO-BOX INNER-LINES 6
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-clave-prod-serv AS CHARACTER FORMAT "X(100)":U 
     LABEL "Clave Prod/Serv" 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-chave AS CHARACTER FORMAT "X(12)":U 
     LABEL "Chave STCC" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-chave-carta-porte AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cod Prod Serv CP" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-chave-mater-peri AS CHARACTER FORMAT "X(12)":U 
     LABEL "Cod Mat Perigoso" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-ident-item AS CHARACTER FORMAT "X(35)":U 
     LABEL "Cod Identif. Item" 
     VIEW-AS FILL-IN 
     SIZE 32.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-nico AS CHARACTER FORMAT "X(2)":U 
     LABEL "Cod NICO" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-prod AS CHARACTER FORMAT "x(14)":U 
     LABEL "Codificaá∆o de Produto" 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-tipo-codfic AS CHARACTER FORMAT "X(10)":U 
     LABEL "Tipo de Codificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-classif-fisc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-impto-percep-iva AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-impto-rf AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tax AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.57 BY .88 NO-UNDO.
     
DEFINE VARIABLE i-cod-imp-percep AS INTEGER FORMAT ">>>9":U INITIAL 0  
     LABEL "Cod Imposto Percepá∆o"
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.
     
DEFINE VARIABLE c-desc-imp-percep AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 32.57 BY .88 NO-UNDO.      

DEFINE VARIABLE c-descr-mat-prima AS CHARACTER FORMAT "X(50)":U 
     LABEL "Descriá∆o" 
     VIEW-AS FILL-IN 
     SIZE 33 BY .79 NO-UNDO.

DEFINE VARIABLE c-embalagem AS CHARACTER FORMAT "X(12)":U 
     LABEL "Embalagem" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-imposto-mex AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE c-impto-rf AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Impto RF" 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-ind-tipo-item AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9.43 BY .67 NO-UNDO.

DEFINE VARIABLE c-modelo AS CHARACTER FORMAT "X(100)":U 
     LABEL "Modelo" 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-nro-identific AS CHARACTER FORMAT "X(100)":U 
     LABEL "Nro. Identificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 54.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-arg AS CHARACTER FORMAT "X(10)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .67 NO-UNDO.

DEFINE VARIABLE i-cdn-impto-percep-iva AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "Impto Percep. IVA" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE i-cod-ncm AS INTEGER FORMAT "99":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE VARIABLE rs-ind-tipo-item AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Gravado", 1,
"N∆o Gravado", 2,
"Isento", 3
     SIZE 16.29 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63.14 BY 8.25.

DEFINE RECTANGLE RECT-ind-tipo-item
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20 BY 5.67.

DEFINE VARIABLE tg-cod-padrao AS LOGICAL INITIAL no 
     LABEL "Codificaá∆o Padr∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-isento AS LOGICAL INITIAL no 
     LABEL "Isento" 
     VIEW-AS TOGGLE-BOX
     SIZE 9.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-exento-iibb-mntrib-caba AS LOGICAL INITIAL no 
     LABEL "Isento IIBB Autìnomo CABA" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .83.

DEFINE VARIABLE tg-log-percibe-iva AS LOGICAL INITIAL no 
     LABEL "Percebe IVA" 
     VIEW-AS TOGGLE-BOX
     SIZE 14 BY .83.

DEFINE VARIABLE tg-promovido AS LOGICAL INITIAL no 
     LABEL "Item Projeto Promovido" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .88.

DEFINE VARIABLE tg-usa-desc-item-nfe AS LOGICAL INITIAL no 
     LABEL "Usa Forma Desc Item como Nome do item na NFE" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.57 BY .83 NO-UNDO.
     
DEFINE VARIABLE i-cod-atividade AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "C¢digo Atividade" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.     
     
DEFINE VARIABLE tg-ativo-fixo AS LOGICAL INITIAL no 
     LABEL "Ativo Fixo" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .88.     


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-descr-mat-prima AT ROW 11.25 COL 42.72 COLON-ALIGNED WIDGET-ID 74
     cb-tipo-mat-prim AT ROW 11.25 COL 18.29 COLON-ALIGNED WIDGET-ID 72
     item.class-fiscal AT ROW 1.25 COL 18.43 COLON-ALIGNED WIDGET-ID 28
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .88
     i-cod-ncm AT ROW 1.25 COL 30.29 COLON-ALIGNED HELP
          "Extens∆o NCM para Produtos Qu°micos e Petroqu°micos" NO-LABEL WIDGET-ID 30
     c-desc-classif-fisc AT ROW 1.25 COL 34.14 COLON-ALIGNED NO-LABEL WIDGET-ID 26
     tg-isento AT ROW 2.25 COL 20.72 WIDGET-ID 54
     item.cod-tax AT ROW 2.25 COL 18.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-desc-tax AT ROW 2.25 COL 23.86 COLON-ALIGNED NO-LABEL        
     c-imposto-mex AT ROW 2.25 COL 56.72 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-clave-prod-serv AT ROW 3.25 COL 18.43 COLON-ALIGNED WIDGET-ID 32
     c-impto-rf AT ROW 3.25 COL 18.43 COLON-ALIGNED
     c-desc-impto-rf AT ROW 3.25 COL 23.86 COLON-ALIGNED NO-LABEL
     cb-idi-tip-item AT ROW 4.13 COL 29.14 COLON-ALIGNED WIDGET-ID 2
     c-nro-identific AT ROW 4.25 COL 18.43 COLON-ALIGNED WIDGET-ID 34
     tg-cod-padrao AT ROW 4.25 COL 20.72 WIDGET-ID 56
     tg-log-percibe-iva AT ROW 5.21 COL 31.14 WIDGET-ID 20
     c-cod-ident-item AT ROW 5.25 COL 18.43 COLON-ALIGNED WIDGET-ID 50
     c-cod-nico AT ROW 5.25 COL 18.43 COLON-ALIGNED
     rs-ind-tipo-item AT ROW 5.75 COL 24.14 NO-LABEL
     i-cdn-impto-percep-iva AT ROW 6.04 COL 29.14 COLON-ALIGNED WIDGET-ID 8
     c-desc-impto-percep-iva AT ROW 6.04 COL 35.29 COLON-ALIGNED NO-LABEL WIDGET-ID 6
     c-cod-chave AT ROW 6.25 COL 18.43 COLON-ALIGNED WIDGET-ID 60
     c-cod-tipo-codfic AT ROW 6.25 COL 18.43 COLON-ALIGNED WIDGET-ID 48
     i-cod-imp-percep AT ROW 4.25 COL 18.43 COLON-ALIGNED          
     c-desc-imp-percep AT ROW 4.25 COL 23.86 COLON-ALIGNED NO-LABEL 
     tg-log-exento-iibb-mntrib-caba AT ROW 7 COL 31.14 WIDGET-ID 16
     tg-usa-desc-item-nfe AT ROW 7.25 COL 20.43 WIDGET-ID 70
     c-cod-chave-mater-peri AT ROW 7.25 COL 18.43 COLON-ALIGNED WIDGET-ID 66
     c-modelo AT ROW 7.25 COL 18.43 COLON-ALIGNED WIDGET-ID 58
     tg-promovido AT ROW 7.75 COL 31.14 WIDGET-ID 14
     c-cod-chave-carta-porte AT ROW 8.25 COL 18.43 COLON-ALIGNED WIDGET-ID 62
     c-cod-prod AT ROW 8.75 COL 29.14 COLON-ALIGNED HELP
          "Codificaci¢n del Producto" WIDGET-ID 12          
     i-cod-atividade AT ROW 9.75 COL 18.90 WIDGET-ID 14
     tg-ativo-fixo AT ROW 10.75 COL 31.14 WIDGET-ID 14    
     c-embalagem AT ROW 9.25 COL 18.43 COLON-ALIGNED WIDGET-ID 68
     cb-objeto-imp AT ROW 10.25 COL 18.43 COLON-ALIGNED
     c-text-arg AT ROW 3.42 COL 6.14 COLON-ALIGNED NO-LABEL WIDGET-ID 24
     c-ind-tipo-item AT ROW 3.75 COL 21.14 COLON-ALIGNED NO-LABEL
     RECT-ind-tipo-item AT ROW 4.08 COL 22.14
     RECT-1 AT ROW 3.75 COL 8 WIDGET-ID 22
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
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
         HEIGHT             = 12.08
         WIDTH              = 77.86.
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

/* SETTINGS FOR FILL-IN c-clave-prod-serv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cod-chave IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-chave:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-chave-carta-porte IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-chave-carta-porte:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-chave-mater-peri IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-chave-mater-peri:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-nico IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-nico:HIDDEN IN FRAME f-main           = TRUE.
       
/* SETTINGS FOR FILL-IN i-cod-imp-percep IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       i-cod-imp-percep:HIDDEN IN FRAME f-main           = TRUE.     
       
/* SETTINGS FOR FILL-IN c-desc-imp-percep IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-imp-percep:HIDDEN IN FRAME f-main           = TRUE. 

/* SETTINGS FOR FILL-IN c-desc-classif-fisc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-impto-rf IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tax IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-mat-prima IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-descr-mat-prima:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-embalagem IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-embalagem:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-imposto-mex IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-imposto-mex:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       c-ind-tipo-item:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-nro-identific IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-objeto-imp:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       cb-tipo-mat-prim:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN item.cod-tax IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN i-cod-ncm IN FRAME f-main
   NO-ENABLE 2 3                                                        */
ASSIGN 
       RECT-ind-tipo-item:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-ind-tipo-item IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       rs-ind-tipo-item:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-log-percibe-iva IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       tg-usa-desc-item-nfe:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-embalagem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-embalagem V-table-Win
ON F5 OF c-embalagem IN FRAME f-main /* Embalagem */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di040.w
                     &campo=c-embalagem
                     &campozoom=embalagem}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-embalagem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-embalagem IN FRAME f-main /* Embalagem */
DO:
   APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-impto-rf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-impto-rf V-table-Win
ON F5 OF c-impto-rf IN FRAME f-main /* Impto RF */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di217.w 
                     &campo=c-impto-rf
                     &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-impto-rf V-table-Win
ON LEAVE OF c-impto-rf IN FRAME f-main /* Impto RF */
DO:
  {include/leave.i &tabela=tipo-tax 
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-impto-rf
                    &where="tipo-tax.cod-tax = input frame {&frame-name} c-impto-rf"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-impto-rf V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-impto-rf IN FRAME f-main /* Impto RF */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-imp-percep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imp-percep V-table-Win
ON F5 OF i-cod-imp-percep IN FRAME f-main /* Impto Percep */
DO:
  {include/zoomvar.i &prog-zoom=dizoom/z01di217.w 
                     &campo=i-cod-imp-percep
                     &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imp-percep V-table-Win
ON LEAVE OF i-cod-imp-percep IN FRAME f-main /* Impto Percep */
DO:
  {include/leave.i &tabela=tipo-tax 
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-imp-percep
                    &where="tipo-tax.cod-tax = input frame {&frame-name} i-cod-imp-percep"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-imp-percep V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-imp-percep IN FRAME f-main /* Impto Percep */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-idi-tip-item
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-idi-tip-item V-table-Win
ON VALUE-CHANGED OF cb-idi-tip-item IN FRAME f-main /* Tipo Item */
DO:
    ASSIGN c-combo = ""
           c-combo = cb-idi-tip-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF  {local/arg/ar2inc/i01ar2006.i 06 c-combo} = 1 THEN
        ASSIGN tg-log-percibe-iva:SENSITIVE = YES.
    ELSE
        ASSIGN c-desc-impto-percep-iva:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               i-cdn-impto-percep-iva:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "0"
               tg-log-percibe-iva:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
               i-cdn-impto-percep-iva:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
               c-desc-impto-percep-iva:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
               tg-log-percibe-iva:CHECKED           IN FRAME {&FRAME-NAME} = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tipo-mat-prim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-mat-prim V-table-Win
ON VALUE-CHANGED OF cb-tipo-mat-prim IN FRAME f-main /* Tipo MatÇria */
DO:
  
    ASSIGN c-combo = ""
           c-combo = cb-tipo-mat-prim:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

    IF  {varinc/var00196.i 06 c-combo} = 5 THEN
    DO:
       ASSIGN c-descr-mat-prima:SENSITIVE     IN FRAME {&FRAME-NAME} = YES.
       APPLY "entry"   TO c-descr-mat-prima   IN FRAME {&FRAME-NAME}.
    END.
    ELSE
       ASSIGN c-descr-mat-prima:SENSITIVE        IN FRAME {&FRAME-NAME} = NO
              c-descr-mat-prima:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON ENTRY OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  ASSIGN item.class-fiscal:FORMAT IN FRAME {&FRAME-NAME} = "x(08)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON F5 OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in046.w
                     &campo=item.class-fiscal
                     &campozoom=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON LEAVE OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
    IF LENGTH(input frame {&frame-name} item.class-fiscal) >= 8 THEN
        ASSIGN item.class-fiscal:FORMAT IN FRAME {&FRAME-NAME} = "9999.99.99":U.
    ELSE
        ASSIGN item.class-fiscal:FORMAT IN FRAME {&FRAME-NAME} = "x(08)":U.

    find first classif-fisc no-lock
        where  classif-fisc.class-fiscal = input frame {&frame-name} item.class-fiscal no-error.
    assign c-desc-classif-fisc:screen-value in frame {&frame-name} = if avail classif-fisc then classif-fisc.descricao else "":U.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.class-fiscal IN FRAME f-main /* Classificaá∆o Fiscal */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-tax
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax V-table-Win
ON F5 OF item.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=dizoom/z01di217.w
                     &campo=item.cod-tax
                     &campozoom=cod-tax}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax V-table-Win
ON LEAVE OF item.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:

    DEF VAR i-retencao AS INT NO-UNDO.
    DEF VAR i-agregado AS INT NO-UNDO.

  {include/leave.i &tabela = tipo-tax
                   &atributo-ref = descricao
                   &variavel-ref = c-desc-tax
                   &where = "tipo-tax.cod-tax = input frame {&FRAME-NAME} item.cod-tax"}

    IF  i-pais-impto-usuario = 4 /* Mexico */ THEN DO:
        IF VALID-HANDLE(h-bomx2012) THEN DO:
            ASSIGN i-retencao = 0
                   i-agregado = 0
                   c-imposto-mex:screen-value = "".
    
            RUN goToKey IN h-bomx2012 (INPUT int(ITEM.cod-tax:SCREEN-VALUE IN FRAME {&FRAME-NAME})).
            IF  RETURN-VALUE = "OK":U THEN DO:
                IF  tipo-tax.tipo = 1 THEN DO:
                    RUN getIntField IN h-bomx2012 (INPUT "idi-impuesto-retenc":U,
                                                   OUTPUT i-retencao).
                    IF  i-retencao <> 0 THEN
                        ASSIGN c-imposto-mex:screen-value = {local/mex/mx2inc/i01mx2012.i 04 i-retencao}.
                END.
    
                IF  tipo-tax.tipo = 2 THEN DO:
                    RUN getIntField IN h-bomx2012 (INPUT "idi-impuesto-val-agreg":U,
                                                   OUTPUT i-agregado).
                    IF  i-agregado <> 0 THEN
                        ASSIGN c-imposto-mex:screen-value = {local/mex/mx2inc/i02mx2012.i 04 i-agregado}.
                END.
            END.    
        END.

        IF SELF:SENSITIVE THEN
            RUN pi-trata-campos-imp.

    END.

    /*RETURN  NO-APPLY.*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-tax V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-tax IN FRAME f-main /* C¢digo Imposto */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cdn-impto-percep-iva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-impto-percep-iva V-table-Win
ON ENTRY OF i-cdn-impto-percep-iva IN FRAME f-main /* Impto Percep. IVA */
DO:
    /*FOR FIRST  tipo-tax WHERE tipo-tax.cod-tax = INT( argext-item.cdn-impto-percep-iva:SCREEN-VALUE IN FRAME f-main)  NO-LOCK:
    END.

    IF  AVAIL tipo-tax THEN
        ASSIGN c-desc-impto-percep-iva:SCREEN-VALUE = tipo-tax.descricao.
    ELSE
        ASSIGN c-desc-impto-percep-iva:SCREEN-VALUE = "".*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-impto-percep-iva V-table-Win
ON F5 OF i-cdn-impto-percep-iva IN FRAME f-main /* Impto Percep. IVA */
DO:
    IF  tg-log-percibe-iva:CHECKED IN FRAME {&FRAME-NAME} THEN 
        {include/zoomvar.i &prog-zoom="dizoom/z01di217.w" 
                           &campo=i-cdn-impto-percep-iva            
                           &campozoom=cod-tax}
                           
    /*{include/zoomvar.i &prog-zoom="local/arg/z01di217.w" 
                       &campo=i-cdn-impto-percep-iva            
                       &campozoom=cod-tax}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-impto-percep-iva V-table-Win
ON LEAVE OF i-cdn-impto-percep-iva IN FRAME f-main /* Impto Percep. IVA */
DO:
    FOR FIRST tipo-tax WHERE tipo-tax.cod-tax = INT(i-cdn-impto-percep-iva:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK: 
    END.

    IF  AVAIL tipo-tax THEN
        ASSIGN c-desc-impto-percep-iva:SCREEN-VALUE = tipo-tax.descricao.
    ELSE
        ASSIGN c-desc-impto-percep-iva:SCREEN-VALUE = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-impto-percep-iva V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cdn-impto-percep-iva IN FRAME f-main /* Impto Percep. IVA */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cod-padrao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cod-padrao V-table-Win
ON VALUE-CHANGED OF tg-cod-padrao IN FRAME f-main /* Codificaá∆o Padr∆o */
DO:
    IF tg-cod-padrao:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN c-cod-tipo-codfic:SENSITIVE IN FRAME f-main = YES
               c-cod-ident-item:SENSITIVE IN FRAME  f-main = YES.
    ELSE
        ASSIGN c-cod-tipo-codfic:SENSITIVE IN FRAME f-main = NO
               c-cod-ident-item:SENSITIVE IN FRAME  f-main = NO
               c-cod-tipo-codfic:SCREEN-VALUE IN FRAME f-main = ""
               c-cod-ident-item:SCREEN-VALUE IN FRAME f-main = "".
                                        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-isento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-isento V-table-Win
ON VALUE-CHANGED OF tg-isento IN FRAME f-main /* Isento */
DO:
   IF  tg-isento:CHECKED IN FRAME {&FRAME-NAME} 
   AND i-pais-impto-usuario <> 6 /* Uruguai*/ THEN DO:
   
       ASSIGN ITEM.cod-tax:SENSITIVE IN FRAME f-main = NO
              c-desc-tax:SCREEN-VALUE IN FRAME f-main = ""    
              item.cod-tax:SCREEN-VALUE IN FRAME f-main = "0".
   END.  
   ELSE DO:
       ASSIGN ITEM.cod-tax:SENSITIVE IN FRAME f-main = YES.
   END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-log-percibe-iva
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-log-percibe-iva V-table-Win
ON VALUE-CHANGED OF tg-log-percibe-iva IN FRAME f-main /* Percebe IVA */
DO:
    IF  tg-log-percibe-iva:CHECKED IN FRAME {&FRAME-NAME} THEN
        ASSIGN i-cdn-impto-percep-iva:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN i-cdn-impto-percep-iva:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
               i-cdn-impto-percep-iva:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "0"
               c-desc-impto-percep-iva:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" 
               c-desc-impto-percep-iva:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
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

item.cod-tax:load-mouse-pointer("image~\lupa.cur")      in frame {&frame-name}.
item.class-fiscal:load-mouse-pointer("image~\lupa.cur") in frame {&frame-name}.

{utp/ut-rdset.i rs-ind-tipo-item mft}
{utp/ut-field.i lcarg ext-item ind-tipo-item 1}
assign c-ind-tipo-item:screen-value in frame {&frame-name} = return-value.

IF i-pais-impto-usuario = 17 THEN
    c-impto-rf:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME}.

IF i-pais-impto-usuario = 4 THEN
    c-embalagem:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME}.
    
IF i-pais-impto-usuario = 33 /* Peru*/ THEN
    i-cod-imp-percep:LOAD-MOUSE-POINTER("image/lupa.cur") IN FRAME {&FRAME-NAME}.    

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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

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
{utp/ut-field.i lcarg ext-item ind-tipo-item 1}
  assign c-ind-tipo-item:screen-value in frame {&frame-name} = return-value.

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
    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  

    /* Code placed here will execute AFTER standard behavior.    */

    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        IF  VALID-HANDLE(h-boar2006) THEN DO:
            ASSIGN c-combo = INPUT FRAME {&FRAME-NAME} cb-idi-tip-item.

            RUN emptyRowErrors   IN h-boar2006.
            RUN gravaArgext-item IN h-boar2006 (INPUT item.it-codigo,
                                                INPUT {local/arg/ar2inc/i01ar2006.i 06 c-combo},
                                                INPUT INPUT FRAME {&FRAME-NAME} tg-log-percibe-iva,
                                                INPUT INPUT FRAME {&FRAME-NAME} i-cdn-impto-percep-iva,
                                                INPUT INPUT FRAME {&FRAME-NAME} tg-log-exento-iibb-mntrib-caba,
                                                INPUT INPUT FRAME {&FRAME-NAME} tg-promovido,
                                                INPUT INPUT FRAME {&FRAME-NAME} c-cod-prod,
                                                INPUT INPUT FRAME {&FRAME-NAME} i-cod-atividade,
                                                INPUT INPUT FRAME {&FRAME-NAME} tg-ativo-fixo).                                                
                                                
            IF  RETURN-VALUE <> "OK":U THEN DO:
                RUN getRowErrors IN h-boar2006 (OUTPUT TABLE rowErrors).
                IF CAN-FIND(FIRST rowErrors) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"}
                    {method/showmessage.i3}
                END.

                RETURN "adm-error":U.
            END.
        END.
    END.

    IF i-pais-impto-usuario = 17 THEN DO:
        IF VALID-HANDLE(h-boco2005) THEN
            RUN pi-atualiza-campos IN h-boco2005 (INPUT item.it-codigo,
                                                  INPUT INT(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                                                  INPUT "MFT":U).
        IF VALID-HANDLE(h-boin01073) THEN 
            RUN pi-salva-item-internac IN h-boin01073 (INPUT ITEM.it-codigo,
                                                       FALSE, /*tg-isento*/
                                                       FALSE, /*tg-cod-padrao*/
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-cod-tipo-codfic,
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-cod-ident-item,
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-modelo,
                                                       INPUT '',
                                                       INPUT '').
    END.
    IF  i-pais-impto-usuario = 4 THEN DO: /* MÇxico */
    
            IF VALID-HANDLE(h-bomx2005) THEN
            RUN pi-salva-item IN h-bomx2005 (INPUT item.it-codigo,
                                             INPUT 0,
                                             INPUT INPUT FRAME {&FRAME-NAME} c-clave-prod-serv,
                                             INPUT INPUT FRAME {&FRAME-NAME} c-nro-identific,
                                             INPUT INPUT FRAME {&FRAME-NAME} c-cod-nico,
                                             INPUT INPUT FRAME {&FRAME-NAME} c-cod-chave,
                                             INPUT INPUT FRAME {&FRAME-NAME} c-cod-chave-mater-peri,
                                             INPUT INPUT FRAME {&FRAME-NAME} c-cod-chave-carta-porte,
                                             INPUT STRING({varinc/var00192.i 06 cb-objeto-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME}}),
                                             INPUT STRING({varinc/var00196.i 06 cb-tipo-mat-prim:SCREEN-VALUE IN FRAME {&FRAME-NAME}}),
                                             INPUT INPUT FRAME {&FRAME-NAME}    c-descr-mat-prima).    


        find item-dist where item-dist.it-codigo = item.it-codigo exclusive-lock no-error.
        if  not avail item-dist then do:
            create item-dist.
            assign item-dist.it-codigo = item.it-codigo.
        end.
        ASSIGN item-dist.cod-grp-embal = INPUT FRAME {&FRAME-NAME} c-embalagem.
    END.

    IF i-pais-impto-usuario = 6 THEN DO:
        IF VALID-HANDLE(h-boin01073) THEN 
            RUN pi-salva-item-internac IN h-boin01073 (INPUT ITEM.it-codigo,
                                                       tg-isento:CHECKED IN FRAME f-main,
                                                       tg-cod-padrao:CHECKED IN FRAME f-main, 
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-cod-tipo-codfic,
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-cod-ident-item,
                                                       INPUT '',
                                                       INPUT '',
                                                       INPUT '').
    END.
    
    IF i-pais-impto-usuario = 33 THEN DO:
        IF VALID-HANDLE(h-boin01073) THEN 
           RUN pi-salva-item-internac IN h-boin01073 (INPUT ITEM.it-codigo,
                                                      tg-isento:CHECKED IN FRAME f-main,
                                                      tg-cod-padrao:CHECKED IN FRAME f-main, 
                                                      INPUT INPUT FRAME {&FRAME-NAME} c-cod-tipo-codfic,
                                                      INPUT INPUT FRAME {&FRAME-NAME} c-cod-ident-item,
                                                      INPUT '',
                                                      INPUT '',
                                                      INPUT INPUT FRAME {&FRAME-NAME} i-cod-imp-percep). 
                                                     
    END.    
    IF i-pais-impto-usuario = 7 THEN DO:
        IF VALID-HANDLE(h-boin01073) THEN 
            RUN pi-salva-item-internac IN h-boin01073 (INPUT ITEM.it-codigo,
                                                       tg-isento:CHECKED IN FRAME f-main,
                                                       tg-cod-padrao:CHECKED IN FRAME f-main, 
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-cod-tipo-codfic,
                                                       INPUT INPUT FRAME {&FRAME-NAME} c-cod-ident-item,
                                                       INPUT '',
                                                       INPUT IF INPUT FRAME {&FRAME-NAME} tg-usa-desc-item-nfe THEN 'Y' ELSE 'N',
                                                       INPUT '').
    END.
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

  IF  VALID-HANDLE(h-bomx2012) THEN RUN destroy IN h-bomx2012.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  VALID-HANDLE(h-boar2006) THEN DO:
          RUN destroy IN h-boar2006.
          ASSIGN h-boar2006 = ?.
      END.
  END.

  IF  i-pais-impto-usuario = 17 /* Colìmbia */ THEN DO:
      IF  VALID-HANDLE(h-boco2005) THEN DO:
          RUN destroy IN h-boco2005.
          ASSIGN h-boco2005 = ?.
      END.
  END.
  IF i-pais-impto-usuario = 4 THEN  /*MÇxico*/
      IF  VALID-HANDLE(h-bomx2005) THEN DO:
          RUN destroy IN h-bomx2005.
          ASSIGN h-bomx2005 = ?.
      END.

  IF i-pais-impto-usuario = 6 /* Uruguai*/ OR i-pais-impto-usuario = 7 /* Chile*/ OR i-pais-impto-usuario = 17 /* Colombia */ THEN DO:
      IF  VALID-HANDLE(h-boin01073) THEN DO:
          RUN destroy IN h-boin01073.
          ASSIGN h-boin01073 = ?.
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
      assign rs-ind-tipo-item:sensitive in frame {&frame-name} = no.

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        ASSIGN cb-idi-tip-item:SENSITIVE                IN FRAME {&FRAME-NAME} = NO
               tg-log-percibe-iva:SENSITIVE             IN FRAME {&FRAME-NAME} = NO
               i-cdn-impto-percep-iva:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
               tg-log-exento-iibb-mntrib-caba:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tg-promovido:SENSITIVE                   IN FRAME {&FRAME-NAME} = NO
               c-cod-prod:SENSITIVE                     IN FRAME {&FRAME-NAME} = NO
               i-cod-atividade :SENSITIVE               IN FRAME {&FRAME-NAME} = NO
               tg-ativo-fixo:SENSITIVE                  IN FRAME {&FRAME-NAME} = NO.
    END.

    IF i-pais-impto-usuario = 17 THEN  /*Colìmbia*/
       ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
    IF i-pais-impto-usuario = 4 THEN  /*MÇxico*/
       ASSIGN c-clave-prod-serv:SENSITIVE       IN FRAME {&FRAME-NAME} = NO
              c-nro-identific:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
              c-cod-nico:SENSITIVE              IN FRAME {&FRAME-NAME} = NO
              c-cod-chave:SENSITIVE             IN FRAME {&FRAME-NAME} = NO
              c-cod-chave-mater-peri:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
              c-cod-chave-carta-porte:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              c-embalagem:SENSITIVE             IN FRAME {&FRAME-NAME} = NO
              cb-objeto-imp:SENSITIVE           IN FRAME {&FRAME-NAME} = NO
              cb-tipo-mat-prim:SENSITIVE        IN FRAME {&FRAME-NAME} = NO
              c-descr-mat-prima:SENSITIVE        IN FRAME {&FRAME-NAME} = NO.

    IF i-pais-impto-usuario = 7 /* Chile */ THEN DO:
        ASSIGN tg-usa-desc-item-nfe:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.
    
    IF i-pais-impto-usuario = 33 THEN  /* Peru*/
       ASSIGN i-cod-imp-percep:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  
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

  if  avail item then do:
      find tipo-tax where tipo-tax.cod-tax = item.cod-tax no-lock no-error.
      assign c-desc-tax = if avail tipo-tax then tipo-tax.descricao else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  {utp/ut-field.i lcarg ext-item ind-tipo-item 1}
  assign c-ind-tipo-item:screen-value in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  VALID-HANDLE(h-boar2006) THEN DO:
          RUN setConstraintItem IN h-boar2006 (INPUT item.it-codigo).
          RUN openQueryStatic   IN h-boar2006 (INPUT "Item":U).
          RUN getFirst          IN h-boar2006.
          RUN getIntField       IN h-boar2006 (INPUT  "idi-tip-item":U,                OUTPUT i-idi-tip-item).
          RUN getLogField       IN h-boar2006 (INPUT  "log-percibe-iva":U,             OUTPUT tg-log-percibe-iva).
          RUN getIntField       IN h-boar2006 (INPUT  "cdn-impto-percep-iva":U,        OUTPUT i-cdn-impto-percep-iva).
          RUN getLogField       IN h-boar2006 (INPUT  "log-exento-iibb-mntrib-caba":U, OUTPUT tg-log-exento-iibb-mntrib-caba).
          RUN getLogField       IN h-boar2006 (INPUT  "log-proj-promov":U,             OUTPUT tg-promovido).
          RUN getCharField      IN h-boar2006 (INPUT  "cod-produt-comerc":U,           OUTPUT c-cod-prod).
          RUN getIntField       IN h-boar2006 (INPUT  "int-1":U,                       OUTPUT i-cod-atividade).
          RUN getLogField       IN h-boar2006 (INPUT  "log-2":U,                       OUTPUT tg-ativo-fixo).
         
      END.
      ELSE DO:
          ASSIGN i-idi-tip-item                 = 0
                 tg-log-percibe-iva             = no
                 i-cdn-impto-percep-iva         = 0
                 tg-log-exento-iibb-mntrib-caba = no
                 tg-promovido                   = no
                 c-cod-prod                     = ""
                 i-cod-atividade                = 0
                 tg-ativo-fixo                  = NO.
      END.

      IF  i-idi-tip-item = 0 THEN
          ASSIGN i-idi-tip-item = 1.

      ASSIGN cb-idi-tip-item:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {local/arg/ar2inc/i01ar2006.i 04 i-idi-tip-item}.

      DISPLAY tg-log-percibe-iva
              i-cdn-impto-percep-iva
              tg-log-exento-iibb-mntrib-caba
              tg-promovido
              c-cod-prod
              i-cod-atividade                
              tg-ativo-fixo
          WITH FRAME {&FRAME-NAME}.

      APPLY "LEAVE":U TO i-cdn-impto-percep-iva IN FRAME {&FRAME-NAME}.
  END.

  IF  i-pais-impto-usuario = 17 /*Colìmbia*/
  AND VALID-HANDLE(h-boco2005) THEN DO:
      RUN goToKey IN h-boco2005 (INPUT item.it-codigo).

      IF RETURN-VALUE = "OK":U THEN
          RUN getIntField IN h-boco2005 (INPUT "cdn-impto-rf-faturam":U, OUTPUT c-impto-rf).
      ELSE
          ASSIGN c-impto-rf = 0.
    
      DISP c-impto-rf WITH FRAME {&FRAME-NAME}.

      APPLY "LEAVE":U TO c-impto-rf IN FRAME {&FRAME-NAME}.
  END.

  IF  i-pais-impto-usuario = 4 THEN DO: /*MÇxico*/
      ASSIGN c-clave-prod-serv       = ""
             c-nro-identific         = ""
             c-cod-livre-1           = ""
             c-cod-chave             = ""
             c-cod-chave-mater-peri  = ""
             c-cod-chave-carta-porte = "".

      IF  VALID-HANDLE(h-bomx2005) THEN DO:
          RUN goToKey IN h-bomx2005 (INPUT item.it-codigo).
       
          IF  RETURN-VALUE = "OK":U THEN DO:
              RUN getCharField IN h-bomx2005 (INPUT "cod-chave-produt-serv", OUTPUT c-clave-prod-serv).
              RUN getCharField IN h-bomx2005 (INPUT "cod-ident",             OUTPUT c-nro-identific).
              RUN getCharField IN h-bomx2005 (INPUT "cod-livre-1",           OUTPUT c-cod-livre-1).
              RUN getCharField IN h-bomx2005 (INPUT "cod-chave",             OUTPUT c-cod-chave).
              RUN getCharField IN h-bomx2005 (INPUT "cod-chave-mater-peri",  OUTPUT c-cod-chave-mater-peri).
              RUN getCharField IN h-bomx2005 (INPUT "cod-chave-carta-porte", OUTPUT c-cod-chave-carta-porte).
          END.          
      END.

      ASSIGN c-cod-nico = SUBSTRING(c-cod-livre-1,1,2)
             cb-objeto-imp:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
             cb-tipo-mat-prim:SENSITIVE  IN FRAME {&FRAME-NAME} = NO
             c-descr-mat-prima:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
             
      IF SUBSTRING(c-cod-livre-1,3,2) <> "" AND SUBSTRING(c-cod-livre-1,3,2) <> ? AND SUBSTRING(c-cod-livre-1,3,2) <> "0" THEN
          ASSIGN cb-objeto-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {varinc/var00192.i 04 int(SUBSTRING(c-cod-livre-1,3,2))}.
      ELSE
          ASSIGN cb-objeto-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".

      
      IF SUBSTRING(c-cod-livre-1,5,2) <> "" AND SUBSTRING(c-cod-livre-1,5,2) <> ? AND SUBSTRING(c-cod-livre-1,5,2) <> "0" THEN
         ASSIGN cb-tipo-mat-prim:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = {varinc/var00196.i 04 int(SUBSTRING(c-cod-livre-1,5,2))}
                c-descr-mat-prima:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(c-cod-livre-1,7,50).
      ELSE
          ASSIGN cb-tipo-mat-prim:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = " "
                 c-descr-mat-prima:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " ".
      
      FIND FIRST item-dist NO-LOCK
           WHERE item-dist.it-codigo = ITEM.it-codigo NO-ERROR.
      ASSIGN c-embalagem = IF  AVAIL item-dist THEN item-dist.cod-grp-embal ELSE "".

      DISPLAY c-clave-prod-serv
              c-nro-identific
              c-cod-nico
              c-cod-chave
              c-cod-chave-mater-peri
              c-cod-chave-carta-porte
              c-embalagem
              WITH FRAME {&FRAME-NAME}.
  END.
                          
  IF i-pais-impto-usuario <> 33 AND i-pais-impto-usuario <> 6 AND i-pais-impto-usuario <> 7 AND i-pais-impto-usuario <> 17 THEN DO:
      ASSIGN c-cod-tipo-codfic:HIDDEN IN FRAME f-main = TRUE
             c-cod-ident-item:HIDDEN  IN FRAME f-main = TRUE
             tg-isento:HIDDEN         IN FRAME f-main = TRUE
             tg-cod-padrao:HIDDEN     IN FRAME f-main = TRUE
             c-modelo:HIDDEN          IN FRAME f-main = TRUE.
  END.
  ELSE DO:
      ASSIGN c-cod-tipo-codfic:HIDDEN IN FRAME f-main = NO
             c-cod-ident-item:HIDDEN IN FRAME f-main = NO.

      IF i-pais-impto-usuario = 17 THEN
          ASSIGN c-modelo:ROW IN FRAME f-main = 6.25
                c-cod-tipo-codfic:ROW IN FRAME f-main = 5.25
                c-cod-ident-item:ROW IN FRAME f-main = 4.25
                c-modelo:SIDE-LABEL-HANDLE:ROW IN FRAME f-main = 6.25
                c-cod-tipo-codfic:SIDE-LABEL-HANDLE:ROW IN FRAME f-main = 5.25
                c-cod-ident-item:SIDE-LABEL-HANDLE:ROW IN FRAME f-main = 4.25
                c-modelo:SENSITIVE IN FRAME f-main = NO.
      ELSE
          ASSIGN c-modelo:HIDDEN IN FRAME f-main = TRUE.     
          
      IF i-pais-impto-usuario = 6 OR i-pais-impto-usuario = 7 THEN
          ASSIGN tg-isento:HIDDEN IN FRAME f-main = NO
                 tg-cod-padrao:HIDDEN IN FRAME f-main = NO
                 wg-lb-cod-tax  = item.cod-tax:SIDE-LABEL-HANDLE
                 wg-lb-cod-tax:ROW = 3.25
                 item.cod-tax:ROW = 3.25
                 c-desc-tax:ROW = 3.25.
      ELSE
          ASSIGN tg-isento:HIDDEN IN FRAME f-main = TRUE
                 tg-cod-padrao:HIDDEN IN FRAME f-main = TRUE.
      
      FIND FIRST item-internac 
        WHERE item-internac.it-codigo = item.it-codigo NO-LOCK NO-ERROR.
     
      IF AVAIL item-internac THEN DO:

          ASSIGN c-cod-tipo-codfic:SCREEN-VALUE IN FRAME f-main = item-internac.cod-tipo-codific
                 c-cod-ident-item:SCREEN-VALUE IN FRAME f-main  = item-internac.cod-ident-item.

          IF i-pais-impto-usuario = 17 THEN
              ASSIGN c-modelo:SCREEN-VALUE IN FRAME f-main = TRIM(SUBSTRING(item-internac.cod-livre-1, 1, 100)).
              
          ELSE
              IF i-pais-impto-usuario = 6 OR i-pais-impto-usuario = 7 THEN
                  ASSIGN tg-isento:CHECKED         IN FRAME f-main = item-internac.log-isento       
                         tg-cod-padrao:CHECKED     IN FRAME f-main = item-internac.log-codific-padr
                         ITEM.cod-tax:SCREEN-VALUE IN FRAME f-main = STRING(ITEM.cod-tax).
              IF i-pais-impto-usuario = 7 THEN
                  ASSIGN tg-usa-desc-item-nfe:CHECKED IN FRAME f-main = IF SUBSTRING(item-internac.cod-livre-1,101,1) = 'Y' THEN TRUE ELSE FALSE.
      END.

      ASSIGN c-cod-tipo-codfic:SENSITIVE IN FRAME f-main = NO
             c-cod-ident-item:SENSITIVE IN FRAME  f-main = NO. 

      IF i-pais-impto-usuario = 6 OR i-pais-impto-usuario = 7 THEN
          ASSIGN tg-isento:SENSITIVE     IN FRAME f-main = NO
                 tg-cod-padrao:SENSITIVE IN FRAME f-main = NO.
                 
      IF i-pais-impto-usuario = 33 THEN DO:  /* Peru*/
      
          ASSIGN c-cod-tipo-codfic:ROW IN FRAME f-main = 3.25
                 c-cod-tipo-codfic:SIDE-LABEL-HANDLE:ROW IN FRAME f-main = 3.25
                 c-cod-ident-item:HIDDEN IN FRAME f-main = YES
                 i-cod-imp-percep:SCREEN-VALUE IN FRAME f-main = IF AVAIL item-internac THEN STRING(item-internac.num-livre-1) ELSE "0".
                 
                 APPLY "LEAVE":U TO i-cod-imp-percep IN FRAME {&FRAME-NAME}.
      END.                  
                 
  END.
                     
  APPLY "leave":U TO item.cod-tax      IN FRAME {&FRAME-NAME}.
  APPLY "leave":U TO item.class-fiscal IN FRAME {&FRAME-NAME}.
  
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
      assign rs-ind-tipo-item:sensitive in frame {&frame-name} = yes.

    /* Code placed here will execute AFTER standard behavior.    */
    if adm-new-record = yes then
    &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
        ASSIGN cb-idi-tip-item:SENSITIVE                IN FRAME {&FRAME-NAME} = YES
               tg-log-percibe-iva:SENSITIVE             IN FRAME {&FRAME-NAME} = YES
               i-cdn-impto-percep-iva:SENSITIVE         IN FRAME {&FRAME-NAME} = YES
               tg-log-exento-iibb-mntrib-caba:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               tg-promovido:SENSITIVE                   IN FRAME {&FRAME-NAME} = YES
               c-cod-prod:SENSITIVE                     IN FRAME {&FRAME-NAME} = YES
               i-cod-atividade:SENSITIVE                IN FRAME {&FRAME-NAME} = YES
               tg-ativo-fixo:SENSITIVE                  IN FRAME {&FRAME-NAME} = YES.

        APPLY "VALUE-CHANGED" TO cb-idi-tip-item    IN FRAME {&FRAME-NAME}.
        APPLY "VALUE-CHANGED" TO tg-log-percibe-iva IN FRAME {&FRAME-NAME}.
    END.

    IF i-pais-impto-usuario = 17 THEN  /*Colìmbia*/
       ASSIGN c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = YES
              c-modelo:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.

    IF i-pais-impto-usuario = 4 THEN DO: /*MÇxico*/
        ASSIGN c-clave-prod-serv:SENSITIVE       IN FRAME {&FRAME-NAME}   = YES
               c-nro-identific:SENSITIVE         IN FRAME {&FRAME-NAME}   = YES
               c-cod-nico:SENSITIVE              IN FRAME {&FRAME-NAME}   = YES
               c-cod-chave:SENSITIVE             IN FRAME {&FRAME-NAME}   = YES
               c-cod-chave-mater-peri:SENSITIVE  IN FRAME {&FRAME-NAME}   = YES
               c-cod-chave-carta-porte:SENSITIVE IN FRAME {&FRAME-NAME}   = YES
               c-embalagem:SENSITIVE             IN FRAME {&FRAME-NAME}   = YES
               cb-tipo-mat-prim:SENSITIVE        IN FRAME {&FRAME-NAME}   = YES.   
               
        IF INT(SUBSTRING(c-cod-livre-1,5,2)) = 5 THEN
        DO:
           ASSIGN c-descr-mat-prima:SENSITIVE        IN FRAME {&FRAME-NAME} = YES. 
        END.
        ELSE
        DO:
           ASSIGN c-descr-mat-prima:SENSITIVE        IN FRAME {&FRAME-NAME} = NO
                  c-descr-mat-prima:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = "".        
        END.
               
              
        RUN pi-trata-campos-imp.
    END.
   
    IF i-pais-impto-usuario = 6 /*Uruguai*/ OR i-pais-impto-usuario = 7 /*Chile*/ THEN 
         ASSIGN tg-isento:SENSITIVE     IN FRAME {&FRAME-NAME} = YES
                tg-cod-padrao:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    IF i-pais-impto-usuario = 7 /* Chile */ THEN DO:
        ASSIGN tg-usa-desc-item-nfe:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.
    
    IF i-pais-impto-usuario = 33 /* Peru */ THEN DO:
        ASSIGN c-cod-tipo-codfic:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               i-cod-imp-percep:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    END.    
    
    IF tg-cod-padrao:CHECKED IN FRAME {&FRAME-NAME} OR i-pais-impto-usuario = 17 /*Colìmbia*/ THEN
        ASSIGN c-cod-tipo-codfic:SENSITIVE IN FRAME f-main = YES
               c-cod-ident-item:SENSITIVE  IN FRAME f-main = YES.
    
    IF tg-isento:CHECKED IN FRAME {&FRAME-NAME} AND i-pais-impto-usuario <> 6 /*Uruguai*/ THEN
        ASSIGN item.cod-tax:SENSITIVE IN FRAME f-main = NO
               c-desc-tax:SENSITIVE   IN FRAME f-main = NO.

    ASSIGN item.class-fiscal:FORMAT IN FRAME {&FRAME-NAME} = "x(08)":U.
       
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

    IF i-pais-impto-usuario = 33 /* Peru*/  OR i-pais-impto-usuario = 6 /*Uruguai*/ OR i-pais-impto-usuario = 7 /*Chile*/ OR i-pais-impto-usuario = 17 /* Colombia*/ THEN
        IF NOT VALID-HANDLE(h-boin01073) THEN 
            RUN inbo/boin01073.p PERSISTENT SET h-boin01073.

    IF  i-pais-impto-usuario = 4 /* Mexico */ THEN DO:
        RUN local/mex/bomx2012.p PERSISTENT SET h-bomx2012.
        RUN openQueryStatic IN h-bomx2012 (INPUT "main":U).

        ASSIGN c-imposto-mex:HIDDEN IN FRAME {&FRAME-NAME} = NO.

        IF NOT VALID-HANDLE(h-bomx2005) THEN 
           RUN local/mex/bomx2005.p PERSISTENT SET h-bomx2005.

       RUN openQueryStatic IN h-bomx2005 (INPUT "main":U).

       ASSIGN c-clave-prod-serv:HIDDEN       IN FRAME {&FRAME-NAME} = NO
              c-nro-identific:HIDDEN         IN FRAME {&FRAME-NAME} = NO
              c-cod-nico:HIDDEN              IN FRAME {&FRAME-NAME} = NO
              c-cod-chave:HIDDEN             IN FRAME {&FRAME-NAME} = NO
              c-cod-chave-mater-peri:HIDDEN  IN FRAME {&FRAME-NAME} = NO
              c-cod-chave-carta-porte:HIDDEN IN FRAME {&FRAME-NAME} = NO
              c-embalagem:HIDDEN             IN FRAME {&FRAME-NAME} = NO
              cb-objeto-imp:HIDDEN           IN FRAME {&FRAME-NAME} = NO
              cb-objeto-imp:SENSITIVE        IN FRAME {&FRAME-NAME} = NO
              cb-tipo-mat-prim:HIDDEN        IN FRAME {&FRAME-NAME} = NO
              cb-tipo-mat-prim:SENSITIVE     IN FRAME {&FRAME-NAME} = NO
              c-descr-mat-prima:HIDDEN       IN FRAME {&FRAME-NAME} = NO
              c-descr-mat-prima:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.

        ASSIGN c-lista = {varinc/var00192.i 03} + ", ".
                  
         &IF "{&fnc_multi_idioma}" = "yes" &THEN
            RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).
            ASSIGN cb-objeto-imp:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = c-lista.
        &ELSE
            ASSIGN cb-objeto-imp:LIST-ITEMS IN FRAME {&FRAME-NAME} = c-lista.
        &ENDIF


        ASSIGN c-lista2 = STRING({varinc/var00196.i 03}) + ", ".
         
        &IF "{&fnc_multi_idioma}" = "yes" &THEN
            RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista2).
            ASSIGN cb-tipo-mat-prim:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = c-lista2.
        &ELSE
            ASSIGN cb-tipo-mat-prim:LIST-ITEMS IN FRAME {&FRAME-NAME} = c-lista2.
        &ENDIF        
    END.
    ELSE
        ASSIGN c-clave-prod-serv:HIDDEN       IN FRAME {&FRAME-NAME} = YES
               c-nro-identific:HIDDEN         IN FRAME {&FRAME-NAME} = YES
               c-cod-nico:HIDDEN              IN FRAME {&FRAME-NAME} = YES
               c-cod-chave:HIDDEN             IN FRAME {&FRAME-NAME} = YES
               c-cod-chave-mater-peri:HIDDEN  IN FRAME {&FRAME-NAME} = YES
               c-cod-chave-carta-porte:HIDDEN IN FRAME {&FRAME-NAME} = YES
               c-embalagem:HIDDEN             IN FRAME {&FRAME-NAME} = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      {utp/ut-liter.i Argentina *}
      ASSIGN c-text-arg = RETURN-VALUE.
      DISP c-text-arg WITH FRAME {&FRAME-NAME}.

      IF  NOT VALID-HANDLE(h-boar2006) THEN
          RUN local/arg/boar2006.p PERSISTENT SET h-boar2006.

      RUN setConstraintItem IN h-boar2006 (INPUT item.it-codigo).
      RUN openQueryStatic   IN h-boar2006 (INPUT "Item").
      RUN getIntField       IN h-boar2006 (INPUT  "idi-tip-item",
                                           OUTPUT i-idi-tip-item).

      ASSIGN cb-idi-tip-item:LIST-ITEMS IN FRAME {&FRAME-NAME} = {local/arg/ar2inc/i01ar2006.i 03 i-idi-tip-item}.

      ASSIGN cb-idi-tip-item:SENSITIVE                IN FRAME {&FRAME-NAME} = NO
             tg-log-percibe-iva:SENSITIVE             IN FRAME {&FRAME-NAME} = NO
             i-cdn-impto-percep-iva:SENSITIVE         IN FRAME {&FRAME-NAME} = NO
             c-desc-impto-percep-iva:SENSITIVE        IN FRAME {&FRAME-NAME} = NO
             tg-log-exento-iibb-mntrib-caba:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             tg-promovido:SENSITIVE                   IN FRAME {&FRAME-NAME} = NO
             c-cod-prod:SENSITIVE                     IN FRAME {&FRAME-NAME} = NO
             i-cod-atividade:SENSITIVE                IN FRAME {&FRAME-NAME} = NO
             tg-ativo-fixo:SENSITIVE                  IN FRAME {&FRAME-NAME} = NO.

      i-cdn-impto-percep-iva:LOAD-MOUSE-POINTER('image~\lupa.cur') IN FRAME {&FRAME-NAME}.
  END.
  ELSE
      ASSIGN c-text-arg:HIDDEN                     IN FRAME {&FRAME-NAME} = YES
             RECT-1:HIDDEN                         IN FRAME {&FRAME-NAME} = YES
             cb-idi-tip-item:HIDDEN                IN FRAME {&FRAME-NAME} = YES
             tg-log-percibe-iva:HIDDEN             IN FRAME {&FRAME-NAME} = YES
             i-cdn-impto-percep-iva:HIDDEN         IN FRAME {&FRAME-NAME} = YES
             c-desc-impto-percep-iva:HIDDEN        IN FRAME {&FRAME-NAME} = YES
             tg-log-exento-iibb-mntrib-caba:HIDDEN IN FRAME {&FRAME-NAME} = YES
             tg-promovido:HIDDEN                   IN FRAME {&FRAME-NAME} = YES
             c-cod-prod:HIDDEN                     IN FRAME {&FRAME-NAME} = YES
             i-cod-atividade:HIDDEN                IN FRAME {&FRAME-NAME} = YES
             tg-ativo-fixo:HIDDEN                  IN FRAME {&FRAME-NAME} = YES.   

   IF i-pais-impto-usuario = 7 /* Chile */ THEN DO:
       ASSIGN tg-usa-desc-item-nfe:HIDDEN IN FRAME {&FRAME-NAME} = NO.
   END.

   IF i-pais-impto-usuario = 17 THEN DO: /*Colìmbia*/

       IF NOT VALID-HANDLE(h-boco2005) THEN
           RUN local/col/boco2005.p PERSISTENT SET h-boco2005.

       RUN openQueryStatic IN h-boco2005 (INPUT "Main":U).

       ASSIGN c-impto-rf:HIDDEN IN FRAME {&FRAME-NAME} = NO
              c-desc-impto-rf:HIDDEN IN FRAME {&FRAME-NAME} = NO
              c-impto-rf:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    
       RUN goToKey IN h-boco2005 (INPUT item.it-codigo).

       IF RETURN-VALUE = "OK":U THEN
           RUN getIntField IN h-boco2005 (INPUT "cdn-impto-rf-faturam":U,
                                          OUTPUT c-impto-rf).
       ELSE
           ASSIGN c-impto-rf = 0.
    
       DISP c-impto-rf WITH FRAME {&FRAME-NAME}.
    
       APPLY "LEAVE":U TO c-impto-rf IN FRAME {&FRAME-NAME}.
   END.
   ELSE DO:
       ASSIGN c-impto-rf:HIDDEN IN FRAME {&FRAME-NAME} = YES 
              c-desc-impto-rf:HIDDEN IN FRAME {&FRAME-NAME} = YES.
   END.
   
   IF i-pais-impto-usuario = 33 /* Peru*/  THEN 
   DO:
       {utp/ut-liter.i Cod_Produto_SUNAT * R}
       ASSIGN c-label                                           = RETURN-VALUE
              c-cod-tipo-codfic:LABEL IN FRAME f-main           = c-label
              i-cod-imp-percep:HIDDEN IN FRAME {&FRAME-NAME}    = NO
              i-cod-imp-percep:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              c-desc-imp-percep:HIDDEN IN FRAME {&FRAME-NAME}   = NO.
   END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-destroy V-table-Win 
PROCEDURE pi-destroy :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ('destroy':U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-campos-imp V-table-Win 
PROCEDURE pi-trata-campos-imp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN cb-objeto-imp:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    RETURN "OK":U.
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
 /*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/


/*  Quando estiver cadastrada essa DPC n∆o validar o codigo do imposto*/
        

RUN Who-Is-The-Container IN adm-broker-hdl (INPUT THIS-PROCEDURE, OUTPUT c-handle1).
ASSIGN wh-cd0903 = WIDGET-HANDLE(c-handle1).


IF INPUT FRAME {&FRAME-NAME} item.class-fiscal <> "" THEN DO:
    {cdp/cd9998.i}
    FIND FIRST classif-fisc 
         WHERE classif-fisc.class-fiscal = INPUT FRAME {&FRAME-NAME} item.class-fiscal NO-LOCK NO-ERROR.
    IF NOT AVAIL classif-fisc THEN DO:
          {utp/ut-liter.i Classificaá∆o_Fiscal *}
          RUN utp/ut-msgs.p(INPUT "show":U,
                            INPUT 3657,
                            INPUT TRIM(RETURN-VALUE)).
          RUN select-page IN wh-cd0903 (3).                  
          APPLY "entry":U TO item.class-fiscal IN FRAME {&FRAME-NAME}.
          RETURN "adm-error":U.    
    END.
END.

find prog_dtsul where prog_dtsul.cod_prog_dtsul = "cd0903" NO-LOCK no-error.
if NOT avail prog_dtsul then DO:
    find tipo-tax where tipo-tax.cod-tax = input frame {&frame-name} item.cod-tax no-lock no-error.
    if not avail tipo-tax then do:
           {include/i-vldprg.i}
                 run utp/ut-msgs.p(input "show",
                             input 8512,
                             input return-value).
           apply "entry" to item.cod-tax in frame {&frame-name}.
           return 'ADM-ERROR':U.
    end.
END.

IF i-pais-impto-usuario = 17 THEN DO:
    IF int(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:
        FIND FIRST tipo-tax WHERE tipo-tax.cod-tax = int(c-impto-rf:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK NO-ERROR. 
        IF NOT AVAIL tipo-tax THEN DO:
            {utp/ut-liter.i "Imposto_RF" *}
            run utp/ut-msgs.p (input "show":U, 
                               INPUT 3549,
                               input TRIM(RETURN-VALUE)).
            return 'ADM-ERROR':U.
        END.
        ELSE DO:
            IF tipo-tax.tipo <> 1 THEN DO:
                run utp/ut-msgs.p (input "show":U, 
                                   INPUT 7267, 
                                   input "").
                return 'ADM-ERROR':U.
            END.
        END.
    END.
END.

IF  i-pais-impto-usuario = 4 THEN DO:
    IF  c-embalagem:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "" THEN DO:
        find embalag where embalag.embalagem = input frame {&frame-name} c-embalagem no-lock no-error.
        if  not avail embalag then do:
            {utp/ut-liter.i "embalagem" *}
            run utp/ut-msgs.p (input "show",
                               input 2,
                               input return-value).
            apply "entry" to c-embalagem in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    END.

    IF cb-objeto-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = " " THEN DO:
        {utp/ut-liter.i "objeto de imposto" *}
        run utp/ut-msgs.p (input "show",
                           input 164,
                           input return-value). /* &1 n∆o pode ser branco */
        apply "entry" to cb-objeto-imp in frame {&frame-name}.
        return 'ADM-ERROR':U.
    END.
    ELSE DO:
    
        FIND FIRST tipo-tax WHERE tipo-tax.cod-tax = int(item.cod-tax:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-LOCK NO-ERROR. 
        IF  NOT AVAIL tipo-tax THEN DO:
            {utp/ut-liter.i "Imposto" *}
            run utp/ut-msgs.p (input "show":U, 
                               INPUT 3549,
                               input TRIM(RETURN-VALUE)).
            apply "entry" to item.cod-tax in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
        
        /* Quando o item Ç "n∆o objeto de imposto" deve ser informado um imposto de 0% */
        IF  {varinc/var00192.i 06 cb-objeto-imp:SCREEN-VALUE IN FRAME {&FRAME-NAME}} = 1 
        AND NOT CAN-FIND(FIRST tipo-tax 
                         WHERE tipo-tax.cod-tax = INT(item.cod-tax:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                           AND tipo-tax.tax-perc = 0) THEN DO:
            
            {utp/ut-liter.i "Al°quota_do_Imposto" *}
            ASSIGN c-liter = TRIM(RETURN-VALUE) + "~~" + "0".
            run utp/ut-msgs.p (input "show",
                               input 32387,
                               input c-liter). /* &1 deve ser &2 ~~ &1 deve ser &2. &3 */
            apply "entry" to item.cod-tax in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
    END.
END.

IF i-pais-impto-usuario = 33 THEN DO:

    IF INPUT FRAME {&FRAME-NAME} i-cod-imp-percep <> 0 THEN DO:
        
        FIND FIRST tipo-tax-internac
             WHERE tipo-tax-internac.cod-tax = INPUT FRAME {&FRAME-NAME} i-cod-imp-percep AND 
                   tipo-tax-internac.log-livre-1 = YES NO-LOCK NO-ERROR.
        IF NOT AVAIL tipo-tax-internac THEN DO:
        
            {utp/ut-liter.i "Cod Imposto Percepá∆o" *}
            ASSIGN c-liter = TRIM(RETURN-VALUE).
            {utp/ut-liter.i "do tipo Imposto de Percepá∆o" *}
            ASSIGN c-liter = c-liter + "~~" + TRIM(RETURN-VALUE).
            {utp/ut-liter.i "Imposto informado deve estar marcado como Imposto Percepá∆o no CD0182" *}
            ASSIGN c-liter = c-liter + "~~" + TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p(INPUT "show":U,
                              INPUT 32387,
                              INPUT c-liter). /* &1 deve ser &2 ~~ &1 deve ser &2. &3 */
            RUN select-page IN wh-cd0903 (3).                  
            APPLY "entry":U TO i-cod-imp-percep IN FRAME {&FRAME-NAME}.
            RETURN "adm-error":U.    
        END.  
    END.

END.

IF  i-pais-impto-usuario = 6 /*Uruguai*/ THEN DO:
    IF tg-isento:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
        IF NOT CAN-FIND(FIRST tipo-tax 
                        WHERE tipo-tax.cod-tax = INT(item.cod-tax:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                          AND tipo-tax.tax-perc = 0) THEN DO: 
                
            {utp/ut-liter.i "Al°quota_do_Imposto" *}
            ASSIGN c-liter = TRIM(RETURN-VALUE) + "~~" + "0".
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 32387,
                               INPUT c-liter). /* &1 deve ser &2 ~~ &1 deve ser &2. &3 */
            APPLY "entry" TO item.cod-tax IN FRAME {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
                
        END.
    END.
END.

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
  {src/adm/template/snd-list.i "item"}

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

