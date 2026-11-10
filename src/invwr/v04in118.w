&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V04IN118 2.00.00.011}  /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in118 MUT}
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

def var i-moeda    as int initial 1 no-undo.
def var i-preco    as int initial 1 no-undo.
def var de-vl-mat-deb   like ext-ord.vl-mat-deb-m extent 3 no-undo.
def var de-vl-mat-cre   like ext-ord.vl-mat-cre-m extent 3 no-undo.
def var de-vl-mob-deb   like ext-ord.vl-mob-deb-m extent 3 no-undo.
def var de-vl-mob-cre   like ext-ord.vl-mob-cre-m extent 3 no-undo.
def var de-vl-ggf-cre1  like ext-ord.vl-ggf-cre-m extent 3 no-undo.
def var de-vl-ggf-deb1  like ext-ord.vl-ggf-deb-m extent 3 no-undo.
def var de-vl-ggf-cre2  like ext-ord.vl-ggf-cre-m extent 3 no-undo.
def var de-vl-ggf-deb2  like ext-ord.vl-ggf-deb-m extent 3 no-undo.
def var de-vl-ggf-cre3  like ext-ord.vl-ggf-cre-m extent 3 no-undo.
def var de-vl-ggf-deb3  like ext-ord.vl-ggf-deb-m extent 3 no-undo.
def var de-vl-ggf-cre4  like ext-ord.vl-ggf-cre-m extent 3 no-undo.
def var de-vl-ggf-deb4  like ext-ord.vl-ggf-deb-m extent 3 no-undo.
def var de-vl-ggf-cre5  like ext-ord.vl-ggf-cre-m extent 3 no-undo.
def var de-vl-ggf-deb5  like ext-ord.vl-ggf-deb-m extent 3 no-undo.
def var de-vl-ggf-cre6  like ext-ord.vl-ggf-cre-m extent 3 no-undo.
def var de-vl-ggf-deb6  like ext-ord.vl-ggf-deb-m extent 3 no-undo.
def var de-vl-ggf-db-c  like ext-ord.vl-ggf-db-c-m extent 3 no-undo.
def var de-vl-ggf-cr-c  like ext-ord.vl-ggf-cr-c-m extent 3 no-undo.

def var l-modifica as logical no-undo.

def var l-valores  as logical no-undo.
def var c-handle   as char    no-undo.
def var i-cont     as integer no-undo.

{cep/ce1234.i} /*** Definiá∆o TTs e Vari†veis - Validaá∆o Decimais ***/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define DISPLAYED-OBJECTS de-vl-mat-deb-m1 de-vl-mat-deb-m2 ~
de-vl-mat-deb-m3 de-vl-mat-cre-m1 de-vl-mat-cre-m2 de-vl-mat-cre-m3 ~
de-vl-mob-deb-m1 de-vl-mob-deb-m2 de-vl-mob-deb-m3 de-vl-mob-cre-m1 ~
de-vl-mob-cre-m2 de-vl-mob-cre-m3 de-vl-ggf-db-c-m1 de-vl-ggf-db-c-m2 ~
de-vl-ggf-db-c-m3 de-vl-ggf-cr-c-m1 de-vl-ggf-cr-c-m2 de-vl-ggf-cr-c-m3 ~
c-liter-valor-material c-moeda1 c-moeda2 c-moeda3 c-liter-valor-mao-de-obra ~
c-liter-componentes 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-vl-mat-deb-m1 de-vl-mat-deb-m2 ~
de-vl-mat-deb-m3 de-vl-mat-cre-m1 de-vl-mat-cre-m2 de-vl-mat-cre-m3 ~
de-vl-mob-deb-m1 de-vl-mob-deb-m2 de-vl-mob-deb-m3 de-vl-mob-cre-m1 ~
de-vl-mob-cre-m2 de-vl-mob-cre-m3 de-vl-ggf-db-c-m1 de-vl-ggf-db-c-m2 ~
de-vl-ggf-db-c-m3 de-vl-ggf-cr-c-m1 de-vl-ggf-cr-c-m2 de-vl-ggf-cr-c-m3 
&Scoped-define ADM-ASSIGN-FIELDS de-vl-mat-deb-m1 de-vl-mat-deb-m2 ~
de-vl-mat-deb-m3 de-vl-mat-cre-m1 de-vl-mat-cre-m2 de-vl-mat-cre-m3 ~
de-vl-mob-deb-m1 de-vl-mob-deb-m2 de-vl-mob-deb-m3 de-vl-mob-cre-m1 ~
de-vl-mob-cre-m2 de-vl-mob-cre-m3 de-vl-ggf-db-c-m1 de-vl-ggf-db-c-m2 ~
de-vl-ggf-db-c-m3 de-vl-ggf-cr-c-m1 de-vl-ggf-cr-c-m2 de-vl-ggf-cr-c-m3 
&Scoped-define ADM-MODIFY-FIELDS de-vl-mat-deb-m1 de-vl-mat-deb-m2 ~
de-vl-mat-deb-m3 de-vl-mat-cre-m1 de-vl-mat-cre-m2 de-vl-mat-cre-m3 ~
de-vl-mob-deb-m1 de-vl-mob-deb-m2 de-vl-mob-deb-m3 de-vl-mob-cre-m1 ~
de-vl-mob-cre-m2 de-vl-mob-cre-m3 de-vl-ggf-db-c-m1 de-vl-ggf-db-c-m2 ~
de-vl-ggf-db-c-m3 de-vl-ggf-cr-c-m1 de-vl-ggf-cr-c-m2 de-vl-ggf-cr-c-m3 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD retorna-campo V-table-Win 
FUNCTION retorna-campo RETURNS DECIMAL
  ( input nome-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-liter-componentes AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-liter-valor-mao-de-obra AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 18 BY .63 NO-UNDO.

DEFINE VARIABLE c-liter-valor-material AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda3 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cr-c-m1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cr-c-m2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cr-c-m3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-db-c-m1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-db-c-m2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-db-c-m3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-cre-m1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-cre-m2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-cre-m3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-deb-m1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-deb-m2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mat-deb-m3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-cre-m1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-cre-m2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-cre-m3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-deb-m1 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-deb-m2 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-mob-deb-m3 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-vl-mat-deb-m1 AT ROW 2 COL 21 COLON-ALIGNED
     de-vl-mat-deb-m2 AT ROW 2 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-mat-deb-m3 AT ROW 2 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-mat-cre-m1 AT ROW 3 COL 21 COLON-ALIGNED
     de-vl-mat-cre-m2 AT ROW 3 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-mat-cre-m3 AT ROW 3 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-mob-deb-m1 AT ROW 4.75 COL 21 COLON-ALIGNED
     de-vl-mob-deb-m2 AT ROW 4.75 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-mob-deb-m3 AT ROW 4.75 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-mob-cre-m1 AT ROW 5.75 COL 21 COLON-ALIGNED
     de-vl-mob-cre-m2 AT ROW 5.75 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-mob-cre-m3 AT ROW 5.75 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-db-c-m1 AT ROW 7.5 COL 21 COLON-ALIGNED
     de-vl-ggf-db-c-m2 AT ROW 7.5 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-db-c-m3 AT ROW 7.5 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cr-c-m1 AT ROW 8.5 COL 21 COLON-ALIGNED
     de-vl-ggf-cr-c-m2 AT ROW 8.5 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cr-c-m3 AT ROW 8.5 COL 65 COLON-ALIGNED NO-LABEL
     c-liter-valor-material AT ROW 1 COL 1 COLON-ALIGNED NO-LABEL
     c-moeda1 AT ROW 1 COL 21 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 1 COL 43 COLON-ALIGNED NO-LABEL
     c-moeda3 AT ROW 1 COL 65 COLON-ALIGNED NO-LABEL
     c-liter-valor-mao-de-obra AT ROW 4 COL 1 COLON-ALIGNED NO-LABEL
     c-liter-componentes AT ROW 7 COL 1 COLON-ALIGNED NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-prod
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 8.63
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN c-liter-componentes IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-liter-valor-mao-de-obra IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-liter-valor-material IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ggf-cr-c-m1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cr-c-m2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cr-c-m3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-db-c-m1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-db-c-m2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-db-c-m3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mat-cre-m1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mat-cre-m2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mat-cre-m3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mat-deb-m1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mat-deb-m2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mat-deb-m3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mob-cre-m1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mob-cre-m2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mob-cre-m3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mob-deb-m1 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mob-deb-m2 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-mob-deb-m3 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/


{utp/ut-liter.i Debito * r}
assign de-vl-mat-deb-m1:label  in frame {&frame-name} = return-value
       de-vl-ggf-db-c-m1:label in frame {&frame-name} = return-value
       de-vl-mob-deb-m1:label  in frame {&frame-name} = return-value.

{utp/ut-liter.i Credito * r}
assign de-vl-mat-cre-m1:label  in frame {&frame-name} = return-value
       de-vl-ggf-cr-c-m1:label in frame {&frame-name} = return-value
       de-vl-mob-cre-m1:label  in frame {&frame-name} = return-value.

{utp/ut-liter.i Valor_Material * r}
assign c-liter-valor-material = return-value.

{utp/ut-liter.i Valor_M∆o_de_Obra * r}
assign c-liter-valor-mao-de-obra = return-value.

{utp/ut-liter.i GGF_Componentes * r}
assign c-liter-componentes = return-value.

find first param-estoq no-lock no-error.
find first param-global no-lock no-error.

find moeda where moeda.mo-codigo = 0 no-lock no-error.
assign c-moeda1 = moeda.descricao.

if param-estoq.tem-moeda1 = yes then do:
  find moeda where moeda.mo-codigo = param-estoq.moeda1 no-lock no-error.
  assign c-moeda2 = moeda.descricao.
end.

if param-estoq.tem-moeda2 = yes then do:
  find moeda where moeda.mo-codigo = param-estoq.moeda2 no-lock no-error.
  assign c-moeda3 = moeda.descricao.
end.

disp c-liter-valor-material
     c-liter-valor-mao-de-obra
     c-liter-componentes
     c-moeda1
     c-moeda2
     c-moeda3 with frame {&frame-name}.

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

  /*** Validaá∆o Decimais ***/

  assign l-rejeita-dec  = no

         de-vl-mat-deb-m1:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mat-deb-m1, 0))
         de-vl-mat-cre-m1:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mat-cre-m1, 0))
         de-vl-mob-deb-m1:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mob-deb-m1, 0))
         de-vl-mob-cre-m1:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mob-cre-m1, 0))
         de-vl-ggf-db-c-m1:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-db-c-m1, 0))
         de-vl-ggf-cr-c-m1:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cr-c-m1, 0))

         de-vl-mat-deb-m2:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mat-deb-m2, param-estoq.moeda1))
         de-vl-mat-cre-m2:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mat-cre-m2, param-estoq.moeda1))
         de-vl-mob-deb-m2:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mob-deb-m2, param-estoq.moeda1))
         de-vl-mob-cre-m2:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mob-cre-m2, param-estoq.moeda1))
         de-vl-ggf-db-c-m2:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-db-c-m2, param-estoq.moeda1))
         de-vl-ggf-cr-c-m2:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cr-c-m2, param-estoq.moeda1))

         de-vl-mat-deb-m3:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mat-deb-m3, param-estoq.moeda2))
         de-vl-mat-cre-m3:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mat-cre-m3, param-estoq.moeda2))
         de-vl-mob-deb-m3:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mob-deb-m3, param-estoq.moeda2))
         de-vl-mob-cre-m3:screen-value   in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-mob-cre-m3, param-estoq.moeda2))
         de-vl-ggf-db-c-m3:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-db-c-m3, param-estoq.moeda2))
         de-vl-ggf-cr-c-m3:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cr-c-m3, param-estoq.moeda2)).

  if  l-rejeita-dec then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 18100, 
                         input " ").
      return 'ADM-ERROR':U.        
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  if i-moeda <> 2 and param-estoq.tem-moeda1 then do:   
     find first ext-ord
          where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
          and ext-ord.mo-codigo      = param-estoq.moeda1 
          and ext-ord.op-seq         = 0 exclusive-lock no-error.
     if not available(ext-ord) then do:
        create ext-ord.
        assign ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
               ext-ord.mo-codigo    = param-estoq.moeda1.
     end.

    do with frame {&frame-name}:
       case i-preco:
       when 1 then 
            assign ext-ord.vl-mat-deb-m  = input de-vl-mat-deb-m2
                   ext-ord.vl-mat-cre-m  = input de-vl-mat-cre-m2
                   ext-ord.vl-mob-deb-m  = input de-vl-mob-deb-m2
                   ext-ord.vl-mob-cre-m  = input de-vl-mob-cre-m2
                   ext-ord.vl-ggf-db-c-m = input de-vl-ggf-db-c-m2
                   ext-ord.vl-ggf-cr-c-m = input de-vl-ggf-cr-c-m2

                   ext-ord.vl-ggf-deb-m[1] = retorna-campo ("de-vl-ggf-deb-m12")
                   ext-ord.vl-ggf-cre-m[1] = retorna-campo ("de-vl-ggf-cre-m12")
                   ext-ord.vl-ggf-deb-m[2] = retorna-campo ("de-vl-ggf-deb-m22")
                   ext-ord.vl-ggf-cre-m[2] = retorna-campo ("de-vl-ggf-cre-m22")
                   ext-ord.vl-ggf-deb-m[3] = retorna-campo ("de-vl-ggf-deb-m32")
                   ext-ord.vl-ggf-cre-m[3] = retorna-campo ("de-vl-ggf-cre-m32")
                   
                   ext-ord.vl-ggf-deb-m[4] = retorna-campo ("de-vl-ggf-deb-m42")
                   ext-ord.vl-ggf-cre-m[4] = retorna-campo ("de-vl-ggf-cre-m42")
                   ext-ord.vl-ggf-deb-m[5] = retorna-campo ("de-vl-ggf-deb-m52")
                   ext-ord.vl-ggf-cre-m[5] = retorna-campo ("de-vl-ggf-cre-m52")
                   ext-ord.vl-ggf-deb-m[6] = retorna-campo ("de-vl-ggf-deb-m62")
                   ext-ord.vl-ggf-cre-m[6] = retorna-campo ("de-vl-ggf-cre-m62").

       when 2 then 
            assign ext-ord.vl-mat-deb-o  = input de-vl-mat-deb-m2
                   ext-ord.vl-mat-cre-o  = input de-vl-mat-cre-m2
                   ext-ord.vl-mob-deb-o  = input de-vl-mob-deb-m2
                   ext-ord.vl-mob-cre-o  = input de-vl-mob-cre-m2
                   ext-ord.vl-ggf-db-c-o = input de-vl-ggf-db-c-m2
                   ext-ord.vl-ggf-cr-c-o = input de-vl-ggf-cr-c-m2

                   ext-ord.vl-ggf-deb-o[1] = retorna-campo ("de-vl-ggf-deb-m12")
                   ext-ord.vl-ggf-cre-o[1] = retorna-campo ("de-vl-ggf-cre-m12")
                   ext-ord.vl-ggf-deb-o[2] = retorna-campo ("de-vl-ggf-deb-m22")
                   ext-ord.vl-ggf-cre-o[2] = retorna-campo ("de-vl-ggf-cre-m22")
                   ext-ord.vl-ggf-deb-o[3] = retorna-campo ("de-vl-ggf-deb-m32")
                   ext-ord.vl-ggf-cre-o[3] = retorna-campo ("de-vl-ggf-cre-m32")
                   
                   ext-ord.vl-ggf-deb-o[4] = retorna-campo ("de-vl-ggf-deb-m42")
                   ext-ord.vl-ggf-cre-o[4] = retorna-campo ("de-vl-ggf-cre-m42")
                   ext-ord.vl-ggf-deb-o[5] = retorna-campo ("de-vl-ggf-deb-m52")
                   ext-ord.vl-ggf-cre-o[5] = retorna-campo ("de-vl-ggf-cre-m52")
                   ext-ord.vl-ggf-deb-o[6] = retorna-campo ("de-vl-ggf-deb-m62")
                   ext-ord.vl-ggf-cre-o[6] = retorna-campo ("de-vl-ggf-cre-m62").


       when 3 then 
            assign ext-ord.vl-mat-deb-p  = input de-vl-mat-deb-m2
                   ext-ord.vl-mat-cre-p  = input de-vl-mat-cre-m2
                   ext-ord.vl-mob-deb-p  = input de-vl-mob-deb-m2
                   ext-ord.vl-mob-cre-p  = input de-vl-mob-cre-m2
                   ext-ord.vl-ggf-db-c-p = input de-vl-ggf-db-c-m2
                   ext-ord.vl-ggf-cr-c-p = input de-vl-ggf-cr-c-m2

                   ext-ord.vl-ggf-deb-p[1] = retorna-campo ("de-vl-ggf-deb-m12")
                   ext-ord.vl-ggf-cre-p[1] = retorna-campo ("de-vl-ggf-cre-m12")
                   ext-ord.vl-ggf-deb-p[2] = retorna-campo ("de-vl-ggf-deb-m22")
                   ext-ord.vl-ggf-cre-p[2] = retorna-campo ("de-vl-ggf-cre-m22")
                   ext-ord.vl-ggf-deb-p[3] = retorna-campo ("de-vl-ggf-deb-m32")
                   ext-ord.vl-ggf-cre-p[3] = retorna-campo ("de-vl-ggf-cre-m32")
                   
                   ext-ord.vl-ggf-deb-p[4] = retorna-campo ("de-vl-ggf-deb-m42")
                   ext-ord.vl-ggf-cre-p[4] = retorna-campo ("de-vl-ggf-cre-m42")
                   ext-ord.vl-ggf-deb-p[5] = retorna-campo ("de-vl-ggf-deb-m52")
                   ext-ord.vl-ggf-cre-p[5] = retorna-campo ("de-vl-ggf-cre-m52")
                   ext-ord.vl-ggf-deb-p[6] = retorna-campo ("de-vl-ggf-deb-m62")
                   ext-ord.vl-ggf-cre-p[6] = retorna-campo ("de-vl-ggf-cre-m62").
  end.
  end.    

end.


if i-moeda <> 1 and param-estoq.tem-moeda2 then do:   
   find first ext-ord
        where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
        and ext-ord.mo-codigo      = param-estoq.moeda2 
        and ext-ord.op-seq         = 0 exclusive-lock no-error.
   if not available(ext-ord) then do:
      create ext-ord.
      assign ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
             ext-ord.mo-codigo    = param-estoq.moeda2.
   end.

  do with frame {&frame-name}:
  case i-preco:
       when 1 then 
            assign ext-ord.vl-mat-deb-m  = input de-vl-mat-deb-m3
                   ext-ord.vl-mat-cre-m  = input de-vl-mat-cre-m3
                   ext-ord.vl-mob-deb-m  = input de-vl-mob-deb-m3
                   ext-ord.vl-mob-cre-m  = input de-vl-mob-cre-m3
                   ext-ord.vl-ggf-db-c-m = input de-vl-ggf-db-c-m3
                   ext-ord.vl-ggf-cr-c-m = input de-vl-ggf-cr-c-m3

                   ext-ord.vl-ggf-deb-m[1] = retorna-campo ("de-vl-ggf-deb-m13")
                   ext-ord.vl-ggf-cre-m[1] = retorna-campo ("de-vl-ggf-cre-m13")
                   ext-ord.vl-ggf-deb-m[2] = retorna-campo ("de-vl-ggf-deb-m23")
                   ext-ord.vl-ggf-cre-m[2] = retorna-campo ("de-vl-ggf-cre-m23")
                   ext-ord.vl-ggf-deb-m[3] = retorna-campo ("de-vl-ggf-deb-m33")
                   ext-ord.vl-ggf-cre-m[3] = retorna-campo ("de-vl-ggf-cre-m33")
                   
                   ext-ord.vl-ggf-deb-m[4] = retorna-campo ("de-vl-ggf-deb-m43")
                   ext-ord.vl-ggf-cre-m[4] = retorna-campo ("de-vl-ggf-cre-m43")
                   ext-ord.vl-ggf-deb-m[5] = retorna-campo ("de-vl-ggf-deb-m53")
                   ext-ord.vl-ggf-cre-m[5] = retorna-campo ("de-vl-ggf-cre-m53")
                   ext-ord.vl-ggf-deb-m[6] = retorna-campo ("de-vl-ggf-deb-m63")
                   ext-ord.vl-ggf-cre-m[6] = retorna-campo ("de-vl-ggf-cre-m63").

       when 2 then 
            assign ext-ord.vl-mat-deb-o  = input de-vl-mat-deb-m3
                   ext-ord.vl-mat-cre-o  = input de-vl-mat-cre-m3
                   ext-ord.vl-mob-deb-o  = input de-vl-mob-deb-m3
                   ext-ord.vl-mob-cre-o  = input de-vl-mob-cre-m3
                   ext-ord.vl-ggf-db-c-o = input de-vl-ggf-db-c-m3
                   ext-ord.vl-ggf-cr-c-o = input de-vl-ggf-cr-c-m3

                   ext-ord.vl-ggf-deb-o[1] = retorna-campo ("de-vl-ggf-deb-m13")
                   ext-ord.vl-ggf-cre-o[1] = retorna-campo ("de-vl-ggf-cre-m13")
                   ext-ord.vl-ggf-deb-o[2] = retorna-campo ("de-vl-ggf-deb-m23")
                   ext-ord.vl-ggf-cre-o[2] = retorna-campo ("de-vl-ggf-cre-m23")
                   ext-ord.vl-ggf-deb-o[3] = retorna-campo ("de-vl-ggf-deb-m33")
                   ext-ord.vl-ggf-cre-o[3] = retorna-campo ("de-vl-ggf-cre-m33")
                   
                   ext-ord.vl-ggf-deb-o[4] = retorna-campo ("de-vl-ggf-deb-m43")
                   ext-ord.vl-ggf-cre-o[4] = retorna-campo ("de-vl-ggf-cre-m43")
                   ext-ord.vl-ggf-deb-o[5] = retorna-campo ("de-vl-ggf-deb-m53")
                   ext-ord.vl-ggf-cre-o[5] = retorna-campo ("de-vl-ggf-cre-m53")
                   ext-ord.vl-ggf-deb-o[6] = retorna-campo ("de-vl-ggf-deb-m63")
                   ext-ord.vl-ggf-cre-o[6] = retorna-campo ("de-vl-ggf-cre-m63").

       when 3 then 
            assign ext-ord.vl-mat-deb-p  = input de-vl-mat-deb-m3
                   ext-ord.vl-mat-cre-p  = input de-vl-mat-cre-m3
                   ext-ord.vl-mob-deb-p  = input de-vl-mob-deb-m3
                   ext-ord.vl-mob-cre-p  = input de-vl-mob-cre-m3
                   ext-ord.vl-ggf-db-c-p = input de-vl-ggf-db-c-m3
                   ext-ord.vl-ggf-cr-c-p = input de-vl-ggf-cr-c-m3

                   ext-ord.vl-ggf-deb-p[1] = retorna-campo ("de-vl-ggf-deb-m13")
                   ext-ord.vl-ggf-cre-p[1] = retorna-campo ("de-vl-ggf-cre-m13")
                   ext-ord.vl-ggf-deb-p[2] = retorna-campo ("de-vl-ggf-deb-m23")
                   ext-ord.vl-ggf-cre-p[2] = retorna-campo ("de-vl-ggf-cre-m23")
                   ext-ord.vl-ggf-deb-p[3] = retorna-campo ("de-vl-ggf-deb-m33")
                   ext-ord.vl-ggf-cre-p[3] = retorna-campo ("de-vl-ggf-cre-m33")
                   
                   ext-ord.vl-ggf-deb-p[4] = retorna-campo ("de-vl-ggf-deb-m43")
                   ext-ord.vl-ggf-cre-p[4] = retorna-campo ("de-vl-ggf-cre-m43")
                   ext-ord.vl-ggf-deb-p[5] = retorna-campo ("de-vl-ggf-deb-m53")
                   ext-ord.vl-ggf-cre-p[5] = retorna-campo ("de-vl-ggf-cre-m53")
                   ext-ord.vl-ggf-deb-p[6] = retorna-campo ("de-vl-ggf-deb-m63")
                   ext-ord.vl-ggf-cre-p[6] = retorna-campo ("de-vl-ggf-cre-m63").
  end.
  end.    
end.

assign de-vl-mat-deb-m1  = fn_vld_ajust_dec(de-vl-mat-deb-m1, 0)
       de-vl-mat-cre-m1  = fn_vld_ajust_dec(de-vl-mat-cre-m1, 0)
       de-vl-mob-cre-m1  = fn_vld_ajust_dec(de-vl-mob-cre-m1, 0)
       de-vl-mob-deb-m1  = fn_vld_ajust_dec(de-vl-mob-deb-m1, 0)
       de-vl-ggf-db-c-m1 = fn_vld_ajust_dec(de-vl-ggf-db-c-m1, 0)
       de-vl-ggf-cr-c-m1 = fn_vld_ajust_dec(de-vl-ggf-cr-c-m1, 0).

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

  assign l-modifica = no.

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
 /* &if  defined(ADM-MODIFY-FIELDS) &then
 *       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
 *   &endif*/

  disable all with frame {&frame-name}.

  assign l-modifica = yes.

if  i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 and de-vl-mat-deb-m1 <> 0 then
    enable de-vl-mat-deb-m2 with frame {&frame-name}.
if  i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 and de-vl-mat-cre-m1 <> 0 then
    enable de-vl-mat-cre-m2 with frame {&frame-name}.
if  i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 and de-vl-mob-deb-m1 <> 0 then
    enable de-vl-mob-deb-m2 with frame {&frame-name}.
if  i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 and de-vl-mob-cre-m1 <> 0 then
    enable de-vl-mob-cre-m2 with frame {&frame-name}.
if  i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 and de-vl-ggf-db-c-m1 <> 0 then
    enable de-vl-ggf-db-c-m2 with frame {&frame-name}.
if  i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 and de-vl-ggf-cr-c-m1 <> 0 then
    enable de-vl-ggf-cr-c-m2 with frame {&frame-name}.

if i-moeda <> 1 and ord-prod.nr-ord-produ <> 0 and de-vl-mat-deb-m1 <> 0 then
    enable de-vl-mat-deb-m3 with frame {&frame-name}.
if i-moeda <> 1 and ord-prod.nr-ord-produ <> 0 and de-vl-mat-cre-m1 <> 0 then
    enable de-vl-mat-cre-m3 with frame {&frame-name}.
if i-moeda <> 1 and ord-prod.nr-ord-produ <> 0 and de-vl-mob-deb-m1 <> 0 then
    enable de-vl-mob-deb-m3 with frame {&frame-name}.
if i-moeda <> 1 and ord-prod.nr-ord-produ <> 0 and de-vl-mob-cre-m1 <> 0 then
    enable de-vl-mob-cre-m3 with frame {&frame-name}.
if i-moeda <> 1 and ord-prod.nr-ord-produ <> 0 and de-vl-ggf-db-c-m1 <> 0 then
    enable de-vl-ggf-db-c-m3 with frame {&frame-name}.
if i-moeda <> 1 and ord-prod.nr-ord-produ <> 0 and de-vl-ggf-cr-c-m1 <> 0 then
    enable de-vl-ggf-cr-c-m3 with frame {&frame-name}.

  if ord-prod.nr-ord-produ = 0 or
     (de-vl-mat-deb-m1  = 0 and  
      de-vl-mat-cre-m1  = 0 and
      de-vl-mob-deb-m1  = 0 and
      de-vl-mob-cre-m1  = 0 and
      de-vl-ggf-db-c-m1 = 0 and
      de-vl-ggf-cr-c-m1 = 0) then do:

      RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                             INPUT "group-assign-target",
                                             OUTPUT c-handle).
      do i-cont = 1 to num-entries (c-handle):
         run pi-verifica-valores in widget-handle (entry(i-cont, c-handle))
                                                    (output l-valores).
         if l-valores = yes then leave.                                                
      end.     

      if l-valores = no then do:
          run utp/ut-msgs.p (input "show":U, 
                             input 2150, 
                             input "":U).
          return 'ADM-ERROR':U.        
      end.
  end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign de-vl-mat-deb-m1  = 0           de-vl-mat-cre-m1  = 0
         de-vl-ggf-db-c-m1 = 0           de-vl-ggf-cr-c-m1 = 0
         de-vl-mob-cre-m1  = 0           de-vl-mob-deb-m1  = 0

         de-vl-mat-deb-m2  = 0           de-vl-mat-cre-m2  = 0
         de-vl-ggf-db-c-m2 = 0           de-vl-ggf-cr-c-m2 = 0
         de-vl-mob-cre-m2  = 0           de-vl-mob-deb-m2  = 0

         de-vl-mat-deb-m3  = 0           de-vl-mat-cre-m3  = 0
         de-vl-ggf-db-c-m3 = 0           de-vl-ggf-cr-c-m3 = 0
         de-vl-mob-cre-m3  = 0           de-vl-mob-deb-m3  = 0.

  find first param-estoq no-lock no-error.
  find first param-global no-lock no-error.

  for each ext-ord
      where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
        and ext-ord.mo-codigo    = 0 no-lock:
      case i-preco:
           when 1 then
                assign de-vl-mat-deb-m1  = de-vl-mat-deb-m1 + ext-ord.vl-mat-deb-m
                       de-vl-mat-cre-m1  = de-vl-mat-cre-m1 + ext-ord.vl-mat-cre-m
                       de-vl-ggf-db-c-m1 = de-vl-ggf-db-c-m1 + ext-ord.vl-ggf-db-c-m
                       de-vl-ggf-cr-c-m1 = de-vl-ggf-cr-c-m1 + ext-ord.vl-ggf-cr-c-m
                       de-vl-mob-cre-m1  = de-vl-mob-cre-m1 + ext-ord.vl-mob-cre-m
                       de-vl-mob-deb-m1  = de-vl-mob-deb-m1 + ext-ord.vl-mob-deb-m.
           when 2 then
                assign de-vl-mat-deb-m1  = de-vl-mat-deb-m1 + ext-ord.vl-mat-deb-o
                       de-vl-mat-cre-m1  = de-vl-mat-cre-m1 + ext-ord.vl-mat-cre-o
                       de-vl-ggf-db-c-m1 = de-vl-ggf-db-c-m1 + ext-ord.vl-ggf-db-c-o
                       de-vl-ggf-cr-c-m1 = de-vl-ggf-cr-c-m1 + ext-ord.vl-ggf-cr-c-o
                       de-vl-mob-cre-m1  = de-vl-mob-cre-m1 + ext-ord.vl-mob-cre-o
                       de-vl-mob-deb-m1  = de-vl-mob-deb-m1 + ext-ord.vl-mob-deb-o.
           when 3 then
                assign de-vl-mat-deb-m1  = de-vl-mat-deb-m1 + ext-ord.vl-mat-deb-p
                       de-vl-mat-cre-m1  = de-vl-mat-cre-m1 + ext-ord.vl-mat-cre-p
                       de-vl-ggf-db-c-m1 = de-vl-ggf-db-c-m1 + ext-ord.vl-ggf-db-c-p
                       de-vl-ggf-cr-c-m1 = de-vl-ggf-cr-c-m1 + ext-ord.vl-ggf-cr-c-p
                       de-vl-mob-cre-m1  = de-vl-mob-cre-m1 + ext-ord.vl-mob-cre-p
                       de-vl-mob-deb-m1  = de-vl-mob-deb-m1 + ext-ord.vl-mob-deb-p.
      end.
  end.

  for each ext-ord
      where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
        and ext-ord.mo-codigo    = param-estoq.moeda1 no-lock:
      case i-preco:
           when 1 then
                assign de-vl-mat-deb-m2  = de-vl-mat-deb-m2 + ext-ord.vl-mat-deb-m
                       de-vl-mat-cre-m2  = de-vl-mat-cre-m2 + ext-ord.vl-mat-cre-m
                       de-vl-ggf-db-c-m2 = de-vl-ggf-db-c-m2 + ext-ord.vl-ggf-db-c-m
                       de-vl-ggf-cr-c-m2 = de-vl-ggf-cr-c-m2 + ext-ord.vl-ggf-cr-c-m
                       de-vl-mob-cre-m2  = de-vl-mob-cre-m2 + ext-ord.vl-mob-cre-m
                       de-vl-mob-deb-m2  = de-vl-mob-deb-m2 + ext-ord.vl-mob-deb-m.
           when 2 then
                assign de-vl-mat-deb-m2  = de-vl-mat-deb-m2 + ext-ord.vl-mat-deb-o
                       de-vl-mat-cre-m2  = de-vl-mat-cre-m2 + ext-ord.vl-mat-cre-o
                       de-vl-ggf-db-c-m2 = de-vl-ggf-db-c-m2 + ext-ord.vl-ggf-db-c-o
                       de-vl-ggf-cr-c-m2 = de-vl-ggf-cr-c-m2 + ext-ord.vl-ggf-cr-c-o
                       de-vl-mob-cre-m2  = de-vl-mob-cre-m2 + ext-ord.vl-mob-cre-o
                       de-vl-mob-deb-m2  = de-vl-mob-deb-m2 + ext-ord.vl-mob-deb-o.
           when 3 then
                assign de-vl-mat-deb-m2  = de-vl-mat-deb-m2 + ext-ord.vl-mat-deb-p
                       de-vl-mat-cre-m2  = de-vl-mat-cre-m2 + ext-ord.vl-mat-cre-p
                       de-vl-ggf-db-c-m2 = de-vl-ggf-db-c-m2 + ext-ord.vl-ggf-db-c-p
                       de-vl-ggf-cr-c-m2 = de-vl-ggf-cr-c-m2 + ext-ord.vl-ggf-cr-c-p
                       de-vl-mob-cre-m2  = de-vl-mob-cre-m2 + ext-ord.vl-mob-cre-p
                       de-vl-mob-deb-m2  = de-vl-mob-deb-m2 + ext-ord.vl-mob-deb-p.
      end.
  end.

  for each ext-ord
      where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
        and ext-ord.mo-codigo    = param-estoq.moeda2 no-lock:
      case i-preco:
           when 1 then
                assign de-vl-mat-deb-m3  = de-vl-mat-deb-m3 + ext-ord.vl-mat-deb-m
                       de-vl-mat-cre-m3  = de-vl-mat-cre-m3 + ext-ord.vl-mat-cre-m
                       de-vl-ggf-db-c-m3 = de-vl-ggf-db-c-m3 + ext-ord.vl-ggf-db-c-m
                       de-vl-ggf-cr-c-m3 = de-vl-ggf-cr-c-m3 + ext-ord.vl-ggf-cr-c-m
                       de-vl-mob-cre-m3  = de-vl-mob-cre-m3 + ext-ord.vl-mob-cre-m
                       de-vl-mob-deb-m3  = de-vl-mob-deb-m3 + ext-ord.vl-mob-deb-m.
           when 2 then
                assign de-vl-mat-deb-m3  = de-vl-mat-deb-m3 + ext-ord.vl-mat-deb-o
                       de-vl-mat-cre-m3  = de-vl-mat-cre-m3 + ext-ord.vl-mat-cre-o
                       de-vl-ggf-db-c-m3 = de-vl-ggf-db-c-m3 + ext-ord.vl-ggf-db-c-o
                       de-vl-ggf-cr-c-m3 = de-vl-ggf-cr-c-m3 + ext-ord.vl-ggf-cr-c-o
                       de-vl-mob-cre-m3  = de-vl-mob-cre-m3 + ext-ord.vl-mob-cre-o
                       de-vl-mob-deb-m3  = de-vl-mob-deb-m3 + ext-ord.vl-mob-deb-o.
           when 3 then
                assign de-vl-mat-deb-m3  = de-vl-mat-deb-m3 + ext-ord.vl-mat-deb-p
                       de-vl-mat-cre-m3  = de-vl-mat-cre-m3 + ext-ord.vl-mat-cre-p
                       de-vl-ggf-db-c-m3 = de-vl-ggf-db-c-m3 + ext-ord.vl-ggf-db-c-p
                       de-vl-ggf-cr-c-m3 = de-vl-ggf-cr-c-m3 + ext-ord.vl-ggf-cr-c-p
                       de-vl-mob-cre-m3  = de-vl-mob-cre-m3 + ext-ord.vl-mob-cre-p
                       de-vl-mob-deb-m3  = de-vl-mob-deb-m3 + ext-ord.vl-mob-deb-p.
      end.
  end.

display de-vl-mat-deb-m1           de-vl-mat-cre-m1  
        de-vl-ggf-db-c-m1          de-vl-ggf-cr-c-m1 
        de-vl-mob-cre-m1           de-vl-mob-deb-m1  

        de-vl-mat-deb-m2           de-vl-mat-cre-m2  
        de-vl-ggf-db-c-m2          de-vl-ggf-cr-c-m2 
        de-vl-mob-cre-m2           de-vl-mob-deb-m2  

        de-vl-mat-deb-m3           de-vl-mat-cre-m3  
        de-vl-ggf-db-c-m3          de-vl-ggf-cr-c-m3 
        de-vl-mob-cre-m3           de-vl-mob-deb-m3   with frame {&frame-name}.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-moeda as integer no-undo.
def input parameter p-preco as integer no-undo.

assign i-moeda = p-moeda
       i-preco = p-preco.

run dispatch in this-procedure ("row-available").

if l-modifica then
   run dispatch in this-procedure ("enable-fields":U).

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

 find first estab-mat
      where estab-mat.cod-estabel = ord-prod.cod-estabel no-lock no-error.
 if  (estab-mat.custo-contab <> 1 /* mensal */  and i-preco = 1)
     or  (estab-mat.usa-on-line = no and i-preco = 2) then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 7026,
                          input "").
       return 'ADM-ERROR'.
 end.


 find first ext-ord
      where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
      and ext-ord.mo-codigo = 0 no-lock no-error.
 if not available(ext-ord) then do:
   {include/i-vldprg.i}
   {utp/ut-liter.i Saldo * r}
   run utp/ut-msgs.p (input "show",
                      input 667,
                      input return-value).
   return 'ADM-ERROR'.
 end.

assign de-vl-mat-deb[1]  = if ext-ord.vl-mat-deb-m > 0
                              then ext-ord.vl-mat-deb-m
                           else 0
       de-vl-mat-cre[1]  = if ext-ord.vl-mat-cre-m > 0
                              then ext-ord.vl-mat-cre-m
                           else 0
       de-vl-mob-deb[1]  = if ext-ord.vl-mob-deb-m > 0
                              then ext-ord.vl-mob-deb-m
                           else 0
       de-vl-mob-cre[1]  = if ext-ord.vl-mob-cre-m > 0
                              then ext-ord.vl-mob-cre-m
                           else 0                                                         
       de-vl-ggf-deb1[1] = if ext-ord.vl-ggf-deb-m[1] > 0
                              then ext-ord.vl-ggf-deb-m[1]
                           else 0
       de-vl-ggf-deb2[1] = if ext-ord.vl-ggf-deb-m[2] > 0
                              then ext-ord.vl-ggf-deb-m[2]
                           else 0
       de-vl-ggf-deb3[1] = if ext-ord.vl-ggf-deb-m[3] > 0
                              then ext-ord.vl-ggf-deb-m[3]
                           else 0
       de-vl-ggf-deb4[1] = if ext-ord.vl-ggf-deb-m[4] > 0
                              then ext-ord.vl-ggf-deb-m[4]
                           else 0
       de-vl-ggf-deb5[1] = if ext-ord.vl-ggf-deb-m[5] > 0
                              then ext-ord.vl-ggf-deb-m[5]
                           else 0
       de-vl-ggf-deb6[1] = if ext-ord.vl-ggf-deb-m[6] > 0
                              then ext-ord.vl-ggf-deb-m[6]
                           else 0
       de-vl-ggf-cre1[1] = if ext-ord.vl-ggf-cre-m[1] > 0
                              then ext-ord.vl-ggf-cre-m[1]
                           else 0
       de-vl-ggf-cre2[1] = if ext-ord.vl-ggf-cre-m[2] > 0
                              then ext-ord.vl-ggf-cre-m[2]
                           else 0
       de-vl-ggf-cre3[1] = if ext-ord.vl-ggf-cre-m[3] > 0
                              then ext-ord.vl-ggf-cre-m[3]
                           else 0
       de-vl-ggf-cre4[1] = if ext-ord.vl-ggf-cre-m[4] > 0
                              then ext-ord.vl-ggf-cre-m[4]
                           else 0
       de-vl-ggf-cre5[1] = if ext-ord.vl-ggf-cre-m[5] > 0
                              then ext-ord.vl-ggf-cre-m[5]
                           else 0
       de-vl-ggf-cre6[1] = if ext-ord.vl-ggf-cre-m[6] > 0
                              then ext-ord.vl-ggf-cre-m[6]
                           else 0
       de-vl-ggf-db-c[1] = if ext-ord.vl-ggf-db-c-m > 0
                              then ext-ord.vl-ggf-db-c-m
                           else 0
       de-vl-ggf-cr-c[1] = if ext-ord.vl-ggf-cr-c-m > 0
                              then ext-ord.vl-ggf-cr-c-m
                           else 0.

    if  de-vl-mat-deb[1]  +    de-vl-mat-cre[1] +
        de-vl-mob-deb[1]  +    de-vl-mob-cre[1] +
        de-vl-ggf-deb1[1] +    de-vl-ggf-deb2[1] +
        de-vl-ggf-deb3[1] +    de-vl-ggf-deb4[1] +
        de-vl-ggf-deb5[1] +    de-vl-ggf-deb6[1] +
        de-vl-ggf-cre1[1] +    de-vl-ggf-cre2[1] +
        de-vl-ggf-cre3[1] +    de-vl-ggf-cre4[1] +
        de-vl-ggf-cre5[1] +    de-vl-ggf-cre6[1] +
        de-vl-ggf-db-c[1] +    de-vl-ggf-cr-c[1] 
        = 0 then do:

          {include/i-vldprg.i}
          {utp/ut-liter.i Valores_para_Implantaá∆o * r}
          run utp/ut-msgs.p (input "show",
                             input 667,
                             input return-value).
          return 'ADM-ERROR'.
    end.

    find first item-estab
         where item-estab.cod-estabel = ord-prod.cod-estabel
           and item-estab.it-codigo   = ord-prod.it-codigo no-lock no-error.

    case i-preco:
        when 1 then
            if  param-estoq.ult-fech-dia < item-estab.mensal-ate then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 2052,
                                   input string(param-estoq.ult-fech-dia,"99/99/9999")
                                   + "~~" + string(item-estab.mensal-ate,"99/99/9999")).
                return "ADM-ERROR":U.
            end.
        when 2 then
            if  param-estoq.ult-fech-dia < item-estab.on-line-ate then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 2052,
                                   input string(param-estoq.ult-fech-dia,"99/99/9999")
                                   + "~~" + string(item-estab.on-line-ate,"99/99/9999")).
                return "ADM-ERROR":U.
            end.
        when 3 then
            if  param-estoq.ult-fech-dia < item-estab.padrao-ate then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 2052,
                                   input string(param-estoq.ult-fech-dia,"99/99/9999")
                                   + "~~" + string(item-estab.padrao-ate,"99/99/9999")).
                return "ADM-ERROR":U.
            end.
    end.


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
  {src/adm/template/snd-list.i "ord-prod"}

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION retorna-campo V-table-Win 
FUNCTION retorna-campo RETURNS DECIMAL
  ( input nome-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT nome-campo).
  RETURN decimal (return-value).   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


