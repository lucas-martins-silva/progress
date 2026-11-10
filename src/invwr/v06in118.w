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
{include/i-prgvrs.i V06IN118 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN118 MUT}
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

def var i-moeda    as int init 1 no-undo.
def var i-preco    as int init 1 no-undo.
def var l-modifica as log no-undo.

{cep/ce1234.i} /*** Defini‡Æo TTs e Vari veis - Valida‡Æo Decimais ***/

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
&Scoped-Define DISPLAYED-OBJECTS de-vl-ggf-deb-m41 de-vl-ggf-deb-m42 ~
de-vl-ggf-deb-m43 de-vl-ggf-cre-m41 de-vl-ggf-cre-m42 de-vl-ggf-cre-m43 ~
de-vl-ggf-deb-m51 de-vl-ggf-deb-m52 de-vl-ggf-deb-m53 de-vl-ggf-cre-m51 ~
de-vl-ggf-cre-m52 de-vl-ggf-cre-m53 de-vl-ggf-deb-m61 de-vl-ggf-deb-m62 ~
de-vl-ggf-deb-m63 de-vl-ggf-cre-m61 de-vl-ggf-cre-m62 de-vl-ggf-cre-m63 ~
c-ocorrencia4 c-moeda1 c-moeda2 c-moeda3 c-ocorrencia5 c-ocorrencia6 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS de-vl-ggf-deb-m41 de-vl-ggf-deb-m42 ~
de-vl-ggf-deb-m43 de-vl-ggf-cre-m41 de-vl-ggf-cre-m42 de-vl-ggf-cre-m43 ~
de-vl-ggf-deb-m51 de-vl-ggf-deb-m52 de-vl-ggf-deb-m53 de-vl-ggf-cre-m51 ~
de-vl-ggf-cre-m52 de-vl-ggf-cre-m53 de-vl-ggf-deb-m61 de-vl-ggf-deb-m62 ~
de-vl-ggf-deb-m63 de-vl-ggf-cre-m61 de-vl-ggf-cre-m62 de-vl-ggf-cre-m63 
&Scoped-define ADM-ASSIGN-FIELDS de-vl-ggf-deb-m41 de-vl-ggf-deb-m42 ~
de-vl-ggf-deb-m43 de-vl-ggf-cre-m41 de-vl-ggf-cre-m42 de-vl-ggf-cre-m43 ~
de-vl-ggf-deb-m51 de-vl-ggf-deb-m52 de-vl-ggf-deb-m53 de-vl-ggf-cre-m51 ~
de-vl-ggf-cre-m52 de-vl-ggf-cre-m53 de-vl-ggf-deb-m61 de-vl-ggf-deb-m62 ~
de-vl-ggf-deb-m63 de-vl-ggf-cre-m61 de-vl-ggf-cre-m62 de-vl-ggf-cre-m63 
&Scoped-define ADM-MODIFY-FIELDS de-vl-ggf-deb-m41 de-vl-ggf-deb-m42 ~
de-vl-ggf-deb-m43 de-vl-ggf-cre-m41 de-vl-ggf-cre-m42 de-vl-ggf-cre-m43 ~
de-vl-ggf-deb-m51 de-vl-ggf-deb-m52 de-vl-ggf-deb-m53 de-vl-ggf-cre-m51 ~
de-vl-ggf-cre-m52 de-vl-ggf-cre-m53 de-vl-ggf-deb-m61 de-vl-ggf-deb-m62 ~
de-vl-ggf-deb-m63 de-vl-ggf-cre-m61 de-vl-ggf-cre-m62 de-vl-ggf-cre-m63 

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
DEFINE VARIABLE c-moeda1 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda2 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-moeda3 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .63 NO-UNDO.

DEFINE VARIABLE c-ocorrencia4 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE VARIABLE c-ocorrencia5 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE VARIABLE c-ocorrencia6 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 17 BY .63 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m41 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m42 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m43 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m51 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m52 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m53 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m61 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m62 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-cre-m63 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m41 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m42 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m43 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m51 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m52 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m53 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m61 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m62 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ggf-deb-m63 AS DECIMAL FORMAT ">>>>,>>>,>>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-vl-ggf-deb-m41 AT ROW 2.08 COL 21 COLON-ALIGNED
     de-vl-ggf-deb-m42 AT ROW 2.08 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-deb-m43 AT ROW 2.08 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cre-m41 AT ROW 3.17 COL 21 COLON-ALIGNED
     de-vl-ggf-cre-m42 AT ROW 3.17 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cre-m43 AT ROW 3.17 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-deb-m51 AT ROW 4.75 COL 21 COLON-ALIGNED
     de-vl-ggf-deb-m52 AT ROW 4.75 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-deb-m53 AT ROW 4.75 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cre-m51 AT ROW 5.83 COL 21 COLON-ALIGNED
     de-vl-ggf-cre-m52 AT ROW 5.83 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cre-m53 AT ROW 5.83 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-deb-m61 AT ROW 7.46 COL 21 COLON-ALIGNED
     de-vl-ggf-deb-m62 AT ROW 7.46 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-deb-m63 AT ROW 7.46 COL 65 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cre-m61 AT ROW 8.54 COL 21 COLON-ALIGNED
     de-vl-ggf-cre-m62 AT ROW 8.54 COL 43 COLON-ALIGNED NO-LABEL
     de-vl-ggf-cre-m63 AT ROW 8.54 COL 65 COLON-ALIGNED NO-LABEL
     c-ocorrencia4 AT ROW 1.25 COL 3 NO-LABEL
     c-moeda1 AT ROW 1.25 COL 21 COLON-ALIGNED NO-LABEL
     c-moeda2 AT ROW 1.25 COL 43 COLON-ALIGNED NO-LABEL
     c-moeda3 AT ROW 1.25 COL 65 COLON-ALIGNED NO-LABEL
     c-ocorrencia5 AT ROW 4.25 COL 3 NO-LABEL
     c-ocorrencia6 AT ROW 6.92 COL 3 NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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

/* SETTINGS FOR FILL-IN c-moeda1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda3 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ocorrencia4 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-ocorrencia5 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-ocorrencia6 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m41 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m42 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m43 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m51 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m52 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m53 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m61 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m62 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-cre-m63 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m41 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m42 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m43 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m51 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m52 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m53 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m61 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m62 IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN de-vl-ggf-deb-m63 IN FRAME f-main
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

{utp/ut-liter.i D‚bito * r}
assign de-vl-ggf-deb-m41:label in frame {&frame-name} = return-value
       de-vl-ggf-deb-m51:label in frame {&frame-name} = return-value
       de-vl-ggf-deb-m61:label in frame {&frame-name} = return-value.

{utp/ut-liter.i Cr‚dito * r}
assign de-vl-ggf-cre-m41:label in frame {&frame-name} = return-value
       de-vl-ggf-cre-m51:label in frame {&frame-name} = return-value
       de-vl-ggf-cre-m61:label in frame {&frame-name} = return-value.

find first param-estoq no-lock no-error.
find first param-global no-lock no-error.
find first param-cs no-lock no-error.

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

if param-cs.ocorrencia[4] <> "" then
   assign c-ocorrencia4 = "- " + param-cs.ocorrencia[4].

if param-cs.ocorrencia[5] <> "" then
   assign c-ocorrencia5 = "- " + param-cs.ocorrencia[5].

if param-cs.ocorrencia[6] <> "" then
   assign c-ocorrencia6 = "- " + param-cs.ocorrencia[6].

disp c-ocorrencia4
     c-ocorrencia5
     c-ocorrencia6
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
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  /*** Valida‡Æo Decimais ***/

  assign l-rejeita-dec  = no

         de-vl-ggf-deb-m41:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m41, 0))
         de-vl-ggf-cre-m41:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m41, 0))
         de-vl-ggf-deb-m51:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m51, 0))
         de-vl-ggf-cre-m51:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m51, 0))
         de-vl-ggf-deb-m61:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m61, 0))
         de-vl-ggf-cre-m61:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m61, 0))

         de-vl-ggf-deb-m42:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m42, param-estoq.moeda1))
         de-vl-ggf-cre-m42:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m42, param-estoq.moeda1))
         de-vl-ggf-deb-m52:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m52, param-estoq.moeda1))
         de-vl-ggf-cre-m52:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m52, param-estoq.moeda1))
         de-vl-ggf-deb-m62:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m62, param-estoq.moeda1))
         de-vl-ggf-cre-m62:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m62, param-estoq.moeda1))

         de-vl-ggf-deb-m43:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m43, param-estoq.moeda2))
         de-vl-ggf-cre-m43:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m43, param-estoq.moeda2))
         de-vl-ggf-deb-m53:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m53, param-estoq.moeda2))
         de-vl-ggf-cre-m53:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m53, param-estoq.moeda2))
         de-vl-ggf-deb-m63:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-deb-m63, param-estoq.moeda2))
         de-vl-ggf-cre-m63:screen-value  in frame {&frame-name} = string(fn_vld_ajust_dec(input frame {&frame-name} de-vl-ggf-cre-m63, param-estoq.moeda2)).

  if  l-rejeita-dec then do:
      run utp/ut-msgs.p (input "show":U, 
                         input 18100, 
                         input " ").
      return 'ADM-ERROR':U.        
  end.

  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .*/

  if  RETURN-VALUE = 'ADM-ERROR':U then 
      RETURN 'ADM-ERROR':U.

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

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

  assign l-modifica = no.

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
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
  /* Code placed here will execute AFTER standard behavior.    */
 /* &if  defined(ADM-MODIFY-FIELDS) &then
 *       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
 *   &endif*/

  assign l-modifica = yes.

if  param-cs.ocorrencia[4] <> "" and param-estoq.tem-moeda1 
and i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 
and de-vl-ggf-deb-m41 <> 0 then
  enable de-vl-ggf-deb-m42
         with frame {&frame-name}.

if  param-cs.ocorrencia[5] <> "" and param-estoq.tem-moeda1 
and i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 
and de-vl-ggf-deb-m51 <> 0 then
  enable de-vl-ggf-deb-m52
         with frame {&frame-name}.

if  param-cs.ocorrencia[6] <> "" and param-estoq.tem-moeda1
and i-moeda <> 2 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-deb-m61 <> 0 then
  enable de-vl-ggf-deb-m62
         with frame {&frame-name}.

if  param-cs.ocorrencia[4] <> "" and param-estoq.tem-moeda2
and i-moeda <> 1 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-deb-m41 <> 0 then
  enable de-vl-ggf-deb-m43
         with frame {&frame-name}.

if  param-cs.ocorrencia[5] <> "" and param-estoq.tem-moeda2
and i-moeda <> 1 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-deb-m51 <> 0 then
  enable de-vl-ggf-deb-m53
         with frame {&frame-name}.

if  param-cs.ocorrencia[6] <> "" and param-estoq.tem-moeda2
and i-moeda <> 1 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-deb-m61 <> 0 then
  enable de-vl-ggf-deb-m63
         with frame {&frame-name}.

if  param-cs.ocorrencia[4] <> "" and param-estoq.tem-moeda1 
and i-moeda <> 2 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-cre-m41 <> 0 then
  enable de-vl-ggf-cre-m42
         with frame {&frame-name}.

if  param-cs.ocorrencia[5] <> "" and param-estoq.tem-moeda1
and i-moeda <> 2 and ord-prod.nr-ord-produ <> 0 
and de-vl-ggf-cre-m51 <> 0 then
  enable de-vl-ggf-cre-m52
         with frame {&frame-name}.

if  param-cs.ocorrencia[6] <> "" and param-estoq.tem-moeda1
and i-moeda <> 2 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-cre-m61 <> 0 then
  enable de-vl-ggf-cre-m62
         with frame {&frame-name}.

if  param-cs.ocorrencia[4] <> "" and param-estoq.tem-moeda2
and i-moeda <> 1 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-cre-m41 <> 0 then
  enable de-vl-ggf-cre-m43
         with frame {&frame-name}.

if  param-cs.ocorrencia[5] <> "" and param-estoq.tem-moeda2
and i-moeda <> 1 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-cre-m51 <> 0 then
  enable de-vl-ggf-cre-m53
         with frame {&frame-name}.

if  param-cs.ocorrencia[6] <> "" and param-estoq.tem-moeda2
and i-moeda <> 1 and ord-prod.nr-ord-produ <> 0
and de-vl-ggf-cre-m61 <> 0 then
  enable de-vl-ggf-cre-m63
         with frame {&frame-name}.

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

  assign de-vl-ggf-deb-m41 = 0       de-vl-ggf-cre-m41 = 0
         de-vl-ggf-deb-m51 = 0       de-vl-ggf-cre-m51 = 0
         de-vl-ggf-deb-m61 = 0       de-vl-ggf-cre-m61 = 0

         de-vl-ggf-deb-m42 = 0       de-vl-ggf-cre-m42 = 0
         de-vl-ggf-deb-m52 = 0       de-vl-ggf-cre-m52 = 0
         de-vl-ggf-deb-m62 = 0       de-vl-ggf-cre-m62 = 0

         de-vl-ggf-deb-m43 = 0       de-vl-ggf-cre-m43 = 0
         de-vl-ggf-deb-m53 = 0       de-vl-ggf-cre-m53 = 0
         de-vl-ggf-deb-m63 = 0       de-vl-ggf-cre-m63 = 0.

  find first param-cs no-lock no-error.
  find first param-estoq no-lock no-error.
  find first param-global no-lock no-error.

  for each ext-ord
     where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
       and ext-ord.mo-codigo    = 0 no-lock:
     case i-preco:
          when 1 then
               assign de-vl-ggf-deb-m41 = de-vl-ggf-deb-m41 + ext-ord.vl-ggf-deb-m[4]
                      de-vl-ggf-cre-m41 = de-vl-ggf-cre-m41 + ext-ord.vl-ggf-cre-m[4]
                      de-vl-ggf-deb-m51 = de-vl-ggf-deb-m51 + ext-ord.vl-ggf-deb-m[5]
                      de-vl-ggf-cre-m51 = de-vl-ggf-cre-m51 + ext-ord.vl-ggf-cre-m[5]
                      de-vl-ggf-deb-m61 = de-vl-ggf-deb-m61 + ext-ord.vl-ggf-deb-m[6]
                      de-vl-ggf-cre-m61 = de-vl-ggf-cre-m61 + ext-ord.vl-ggf-cre-m[6].
          when 2 then
               assign de-vl-ggf-deb-m41 = de-vl-ggf-deb-m41 + ext-ord.vl-ggf-deb-o[4]
                      de-vl-ggf-cre-m41 = de-vl-ggf-cre-m41 + ext-ord.vl-ggf-cre-o[4]
                      de-vl-ggf-deb-m51 = de-vl-ggf-deb-m51 + ext-ord.vl-ggf-deb-o[5]
                      de-vl-ggf-cre-m51 = de-vl-ggf-cre-m51 + ext-ord.vl-ggf-cre-o[5]
                      de-vl-ggf-deb-m61 = de-vl-ggf-deb-m61 + ext-ord.vl-ggf-deb-o[6]
                      de-vl-ggf-cre-m61 = de-vl-ggf-cre-m61 + ext-ord.vl-ggf-cre-o[6].
          when 3 then
               assign de-vl-ggf-deb-m41 = de-vl-ggf-deb-m41 + ext-ord.vl-ggf-deb-p[4]
                      de-vl-ggf-cre-m41 = de-vl-ggf-cre-m41 + ext-ord.vl-ggf-cre-p[4]
                      de-vl-ggf-deb-m51 = de-vl-ggf-deb-m51 + ext-ord.vl-ggf-deb-p[5]
                      de-vl-ggf-cre-m51 = de-vl-ggf-cre-m51 + ext-ord.vl-ggf-cre-p[5]
                      de-vl-ggf-deb-m61 = de-vl-ggf-deb-m61 + ext-ord.vl-ggf-deb-p[6]
                      de-vl-ggf-cre-m61 = de-vl-ggf-cre-m61 + ext-ord.vl-ggf-cre-p[6].
      end.
  end.

  for each ext-ord
     where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
       and ext-ord.mo-codigo    = param-estoq.moeda1 no-lock:
     case i-preco:
          when 1 then
               assign de-vl-ggf-deb-m42 = de-vl-ggf-deb-m42 + ext-ord.vl-ggf-deb-m[4]
                      de-vl-ggf-cre-m42 = de-vl-ggf-cre-m42 + ext-ord.vl-ggf-cre-m[4]
                      de-vl-ggf-deb-m52 = de-vl-ggf-deb-m52 + ext-ord.vl-ggf-deb-m[5]
                      de-vl-ggf-cre-m52 = de-vl-ggf-cre-m52 + ext-ord.vl-ggf-cre-m[5]
                      de-vl-ggf-deb-m62 = de-vl-ggf-deb-m62 + ext-ord.vl-ggf-deb-m[6]
                      de-vl-ggf-cre-m62 = de-vl-ggf-cre-m62 + ext-ord.vl-ggf-cre-m[6].
          when 2 then
               assign de-vl-ggf-deb-m42 = de-vl-ggf-deb-m42 + ext-ord.vl-ggf-deb-o[4]
                      de-vl-ggf-cre-m42 = de-vl-ggf-cre-m42 + ext-ord.vl-ggf-cre-o[4]
                      de-vl-ggf-deb-m52 = de-vl-ggf-deb-m52 + ext-ord.vl-ggf-deb-o[5]
                      de-vl-ggf-cre-m52 = de-vl-ggf-cre-m52 + ext-ord.vl-ggf-cre-o[5]
                      de-vl-ggf-deb-m62 = de-vl-ggf-deb-m62 + ext-ord.vl-ggf-deb-o[6]
                      de-vl-ggf-cre-m62 = de-vl-ggf-cre-m62 + ext-ord.vl-ggf-cre-o[6].
          when 3 then
               assign de-vl-ggf-deb-m42 = de-vl-ggf-deb-m42 + ext-ord.vl-ggf-deb-p[4]
                      de-vl-ggf-cre-m42 = de-vl-ggf-cre-m42 + ext-ord.vl-ggf-cre-p[4]
                      de-vl-ggf-deb-m52 = de-vl-ggf-deb-m52 + ext-ord.vl-ggf-deb-p[5]
                      de-vl-ggf-cre-m52 = de-vl-ggf-cre-m52 + ext-ord.vl-ggf-cre-p[5]
                      de-vl-ggf-deb-m62 = de-vl-ggf-deb-m62 + ext-ord.vl-ggf-deb-p[6]
                      de-vl-ggf-cre-m62 = de-vl-ggf-cre-m62 + ext-ord.vl-ggf-cre-p[6].
     end.
  end.

  for each ext-ord
     where ext-ord.nr-ord-produ = ord-prod.nr-ord-produ
       and ext-ord.mo-codigo    = param-estoq.moeda2 no-lock:
     case i-preco:
          when 1 then
               assign de-vl-ggf-deb-m43 = de-vl-ggf-deb-m43 + ext-ord.vl-ggf-deb-m[4]
                      de-vl-ggf-cre-m43 = de-vl-ggf-cre-m43 + ext-ord.vl-ggf-cre-m[4]
                      de-vl-ggf-deb-m53 = de-vl-ggf-deb-m53 + ext-ord.vl-ggf-deb-m[5]
                      de-vl-ggf-cre-m53 = de-vl-ggf-cre-m53 + ext-ord.vl-ggf-cre-m[5]
                      de-vl-ggf-deb-m63 = de-vl-ggf-deb-m63 + ext-ord.vl-ggf-deb-m[6]
                      de-vl-ggf-cre-m63 = de-vl-ggf-cre-m63 + ext-ord.vl-ggf-cre-m[6].
          when 2 then
               assign de-vl-ggf-deb-m43 = de-vl-ggf-deb-m43 + ext-ord.vl-ggf-deb-o[4]
                      de-vl-ggf-cre-m43 = de-vl-ggf-cre-m43 + ext-ord.vl-ggf-cre-o[4]
                      de-vl-ggf-deb-m53 = de-vl-ggf-deb-m53 + ext-ord.vl-ggf-deb-o[5]
                      de-vl-ggf-cre-m53 = de-vl-ggf-cre-m53 + ext-ord.vl-ggf-cre-o[5]
                      de-vl-ggf-deb-m63 = de-vl-ggf-deb-m63 + ext-ord.vl-ggf-deb-o[6]
                      de-vl-ggf-cre-m63 = de-vl-ggf-cre-m63 + ext-ord.vl-ggf-cre-o[6].
          when 3 then
               assign de-vl-ggf-deb-m43 = de-vl-ggf-deb-m43 + ext-ord.vl-ggf-deb-p[4]
                      de-vl-ggf-cre-m43 = de-vl-ggf-cre-m43 + ext-ord.vl-ggf-cre-p[4]
                      de-vl-ggf-deb-m53 = de-vl-ggf-deb-m53 + ext-ord.vl-ggf-deb-p[5]
                      de-vl-ggf-cre-m53 = de-vl-ggf-cre-m53 + ext-ord.vl-ggf-cre-p[5]
                      de-vl-ggf-deb-m63 = de-vl-ggf-deb-m63 + ext-ord.vl-ggf-deb-p[6]
                      de-vl-ggf-cre-m63 = de-vl-ggf-cre-m63 + ext-ord.vl-ggf-cre-p[6].
     end.
  end.

  disp de-vl-ggf-deb-m41 de-vl-ggf-cre-m41
       de-vl-ggf-deb-m51 de-vl-ggf-cre-m51
       de-vl-ggf-deb-m61 de-vl-ggf-cre-m61

       de-vl-ggf-deb-m42 de-vl-ggf-cre-m42
       de-vl-ggf-deb-m52 de-vl-ggf-cre-m52
       de-vl-ggf-deb-m62 de-vl-ggf-cre-m62

       de-vl-ggf-deb-m43 de-vl-ggf-cre-m43
       de-vl-ggf-deb-m53 de-vl-ggf-cre-m53
       de-vl-ggf-deb-m63 de-vl-ggf-cre-m63 with frame {&frame-name}.

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
   run dispatch in this-procedure ("enable-fields").

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-valores V-table-Win 
PROCEDURE pi-verifica-valores :
/*------------------------------------------------------------------------------
  Purpose: Retorna se h  algum campo com valor para implantacao de Saldo
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define output parameter l-valor as logical no-undo.

if  de-vl-ggf-deb-m42:sensitive in frame {&frame-name} = no and
    de-vl-ggf-deb-m52:sensitive in frame {&frame-name} = no and
    de-vl-ggf-deb-m62:sensitive in frame {&frame-name} = no and
    de-vl-ggf-deb-m43:sensitive in frame {&frame-name} = no and
    de-vl-ggf-deb-m53:sensitive in frame {&frame-name} = no and
    de-vl-ggf-deb-m63:sensitive in frame {&frame-name} = no and
    de-vl-ggf-cre-m42:sensitive in frame {&frame-name} = no and
    de-vl-ggf-cre-m52:sensitive in frame {&frame-name} = no and
    de-vl-ggf-cre-m62:sensitive in frame {&frame-name} = no and
    de-vl-ggf-cre-m43:sensitive in frame {&frame-name} = no and
    de-vl-ggf-cre-m53:sensitive in frame {&frame-name} = no and
    de-vl-ggf-cre-m63:sensitive in frame {&frame-name} = no then
    assign l-valor = no.
else
    assign l-valor = yes.    

return "OK":U.    

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


