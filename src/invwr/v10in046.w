&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V10IN046 2.00.00.020 } /*** "010020" 20/08/2026 16:06:09 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v10in046 MUT}
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

def new global shared var gr-classif-fisc as rowid no-undo.

def var de-aliq-ii-old     as decimal format ">>9.9999" no-undo.
def var c-suspensaoii-ant  as char    format "x(1)"     no-undo.
def var c-suspensaoipi-ant as char    format "x(1)"     no-undo.
DEF VAR l-log-1            AS LOG                       NO-UNDO.
DEF VAR l-log-2            AS LOG                       NO-UNDO.
DEF VAR l-ex-tarifario-ii  AS LOG                       NO-UNDO.
DEF VAR l-ex-tarifario     AS LOG                       NO-UNDO.
DEF VAR l-ex-tarifario-old AS LOG                       NO-UNDO.
def var l-executa          as logical initial no        no-undo.
def var h-de-aliq-ii       as handle                    no-undo.
DEF VAR c-ex-tarifario-old AS CHAR    FORMAT "x(1)"     NO-UNDO.

{cdp/cd4300.i3}  /* Include Tratamento Atributo Livre */
{cdp/cd0603.i50} /* Include Tratamento Atributo Livre */
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{include/i_dbvers.i}

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
&Scoped-define EXTERNAL-TABLES classif-fisc
&Scoped-define FIRST-EXTERNAL-TABLE classif-fisc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR classif-fisc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS classif-fisc.log-1
&Scoped-define ENABLED-TABLES classif-fisc
&Scoped-define FIRST-ENABLED-TABLE classif-fisc
&Scoped-Define ENABLED-OBJECTS fi-modulo-import fi-modulo-export RECT-5 ~
RECT-6
&Scoped-Define DISPLAYED-FIELDS classif-fisc.log-1
&Scoped-define DISPLAYED-TABLES classif-fisc
&Scoped-define FIRST-DISPLAYED-TABLE classif-fisc
&Scoped-Define DISPLAYED-OBJECTS de-aliq-ii tg-suspensaoII tg-suspensaoIPI tg-ex-tarifario ~
fi-modulo-import fi-modulo-export

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
<FOREIGN-KEYS></FOREIGN-KEYS>
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE d-repas-max-comis AS DECIMAL FORMAT ">>9.99":U INITIAL 0
     LABEL "Repasse M†x Comiss∆o":R25
     VIEW-AS FILL-IN
     SIZE 8 BY .88.

DEFINE VARIABLE de-aliq-ii AS DECIMAL FORMAT ">>9.9999":U INITIAL 0
     LABEL "":R20
     VIEW-AS FILL-IN
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modulo-export AS CHARACTER FORMAT "X(256)":U INITIAL "M¢dulo Exportaá∆o"
      VIEW-AS TEXT
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE fi-modulo-import AS CHARACTER FORMAT "X(256)":U INITIAL "M¢dulo Importaá∆o"
      VIEW-AS TEXT
     SIZE 14 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 49 BY 4.75.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL
     SIZE 35.29 BY 4.75.

DEFINE VARIABLE tg-suspensaoII AS LOGICAL INITIAL no
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 43 BY .83 NO-UNDO.

DEFINE VARIABLE tg-suspensaoIPI AS LOGICAL INITIAL no
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ex-tarifario AS LOGICAL INITIAL no
     LABEL ""
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .83 NO-UNDO.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-aliq-ii AT ROW 1.5 COL 38 COLON-ALIGNED
     tg-suspensaoII AT ROW 2.71 COL 38
     tg-suspensaoIPI AT ROW 3.67 COL 38
     tg-ex-tarifario AT ROW 4.59 COL 38
     d-repas-max-comis AT ROW 2.17 COL 68 COLON-ALIGNED
     fi-modulo-import AT ROW 1.08 COL 2 NO-LABEL
     fi-modulo-export AT ROW 1.08 COL 51.14 NO-LABEL
     classif-fisc.log-1 AT ROW 4.75 COL 83
          VIEW-AS TOGGLE-BOX
          SIZE 8.14 BY .83
     RECT-5 AT ROW 1.38 COL 1
     RECT-6 AT ROW 1.38 COL 49.72
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY
         SIDE-LABELS NO-UNDERLINE THREE-D
         AT COL 1 ROW 1 SCROLLABLE
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.classif-fisc
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
         HEIGHT             = 5.33
         WIDTH              = 90.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

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

/* SETTINGS FOR FILL-IN d-repas-max-comis IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN
       d-repas-max-comis:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-aliq-ii IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-modulo-export IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN
       fi-modulo-export:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-modulo-import IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN
       fi-modulo-import:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN
       classif-fisc.log-1:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN
       RECT-5:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN
       RECT-6:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX tg-suspensaoII IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-suspensaoIPI IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-ex-tarifario IN FRAME f-main
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




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF

  /************************ INTERNAL PROCEDURES ********************/

  RUN eliminarSuspensao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "classif-fisc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "classif-fisc"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE eliminarSuspensao V-table-Win
PROCEDURE eliminarSuspensao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
    if i-pais-impto-usuario <> 1 then
        assign tg-suspensaoII:VISIBLE  in frame {&FRAME-NAME} = NO
               tg-suspensaoIPI:VISIBLE in frame {&FRAME-NAME} = NO.

    RETURN "OK":U.
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
  assign de-aliq-ii:screen-value in frame {&frame-name} = "0"
         tg-suspensaoII:checked in frame {&frame-name} = no
         tg-suspensaoIPI:checked in frame {&frame-name} = no
         tg-ex-tarifario:checked in frame {&frame-name} = no.

  if l-executa  then
         assign d-repas-max-comis:screen-value in frame {&frame-name} = "0,00".

  disp fi-modulo-import fi-modulo-export with frame f-main.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
    assign input frame {&frame-name} de-aliq-ii
           input frame {&frame-name} tg-suspensaoII
           input frame {&frame-name} tg-suspensaoIPI
           input frame {&frame-name} tg-ex-tarifario.


    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    /* Integracao Modulo Importacao */
    if avail classif-fisc then do:

      {cdp/cd4300.i4 "yes" classif-fisc.char-1}
      {cdp/cd0603.i51 "yes"}
      assign de-aliq-ii-old     = de-aliq-ii-i50
             l-ex-tarifario-old = IF TRIM(SUBSTRING(classif-fisc.char-2,4,1)) = "1":U THEN YES ELSE NO. /*Verifica se a informaá∆o do EX Tarif†rio II est† gravada.
                                                                                                        Utilizado para exportar a informaá∆o ao item*/
        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            assign c-suspensaoii-ant  = string(Classif-fisc.Log-suspens-impto-import)
                   c-suspensaoipi-ant = string(Classif-fisc.Log-suspens-ipi-import)
                   c-ex-tarifario-old = TRIM(SUBSTRING(classif-fisc.char-2,4,1)). /*Armazena a informaá∆o do EX Tarif†rio do II*/

            if input frame {&frame-name} tg-suspensaoII then
                /*assign Classif-fisc.Log-suspens-impto-import = '1'.*/
                assign Classif-fisc.Log-suspens-impto-import = YES.
            else
                /*assign Classif-fisc.Log-suspens-impto-import = ''.*/
                assign Classif-fisc.Log-suspens-impto-import = NO.

            if input frame {&frame-name} tg-suspensaoIPI then
                /*assign Classif-fisc.Log-suspens-ipi-import = '1'.*/
                assign Classif-fisc.Log-suspens-ipi-import = YES.
            else
                /*assign Classif-fisc.Log-suspens-ipi-import = ''.*/
                assign Classif-fisc.Log-suspens-ipi-import = NO.

            /*Grava a informaá∆o do EX Tarif†rio II na Classificaá∆o Fiscal*/
            if input frame {&frame-name} tg-ex-tarifario then
                ASSIGN overlay(classif-fisc.char-2,4,1) = "1":U.
            else
                ASSIGN overlay(classif-fisc.char-2,4,1) = "".
        &else
            assign c-suspensaoii-ant  = substring(classif-fisc.char-1,43,1)
                   c-suspensaoipi-ant = substring(classif-fisc.char-1,44,1).

            if input frame {&frame-name} tg-suspensaoII then
                overlay(classif-fisc.char-1,43,1) = '1'.
            else
                overlay(classif-fisc.char-1,43,1) = ''.

            if input frame {&frame-name} tg-suspensaoIPI then
                overlay(classif-fisc.char-1,44,1) = '1'.
            else
                overlay(classif-fisc.char-1,44,1) = ''.

            /*Grava a informaá∆o do EX Tarif†rio II na Classificaá∆o Fiscal*/
            if input frame {&frame-name} tg-ex-tarifario then
                ASSIGN overlay(classif-fisc.char-2,4,1) = "1":U.
            else
                ASSIGN overlay(classif-fisc.char-2,4,1) = "".
        &endif

        if l-executa then do:

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                assign classif-fisc.val-repas-max-comis = INPUT FRAME {&frame-name} d-repas-max-comis.
            &else
                assign substring(classif-fisc.char-1,50,6)      = d-repas-max-comis:screen-value in frame {&frame-name}.
            &endif
        end.
    end.

    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */
    /* Code placed here will execute AFTER standard behavior.    */
    assign input frame {&frame-name} de-aliq-ii.
    assign de-aliq-ii-i50 = de-aliq-ii.
    {cdp/cd0603.i51 "no"}
    {cdp/cd4300.i4 "no" classif-fisc.char-1}

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


    disable de-aliq-ii WITH FRAME {&FRAME-NAME}.
    disable tg-suspensaoII WITH FRAME {&FRAME-NAME}.
    disable tg-suspensaoIPI WITH FRAME {&FRAME-NAME}.
    disable tg-ex-tarifario WITH FRAME {&FRAME-NAME}.
    if l-executa then
        disable d-repas-max-comis WITH FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

  if avail classif-fisc and not adm-new-record then do:
        {cdp/cd4300.i4 "yes" classif-fisc.char-1}
        {cdp/cd0603.i51 "yes"}
        assign de-aliq-ii:screen-value in frame {&FRAME-NAME} = STRING(de-aliq-ii-i50).

        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            ASSIGN l-log-1 = Classif-fisc.Log-suspens-impto-import.
        &else
            IF substring(classif-fisc.char-1,43,1) = "1" THEN
                ASSIGN l-log-1 = YES.
            ELSE ASSIGN l-log-1 = NO.
        &endif

        ASSIGN tg-suspensaoII:checked in frame {&FRAME-NAME} = l-log-1.

        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            ASSIGN l-log-2 = Classif-fisc.Log-suspens-ipi-import.
        &else
            IF substring(classif-fisc.char-1,44,1) = "1" THEN
                ASSIGN l-log-2 = YES.
            ELSE ASSIGN l-log-2 = NO.
        &endif

        ASSIGN tg-suspensaoIPI:checked in frame {&FRAME-NAME} = l-log-2.

        /*Atualiza em tela a informaá∆o do EX Tarif†rio do II*/
        IF trim(substring(classif-fisc.char-2,4,1)) = "1":U THEN
            ASSIGN l-ex-tarifario-ii = YES.
        ELSE
            ASSIGN l-ex-tarifario-ii = NO.
        ASSIGN tg-ex-tarifario:CHECKED IN FRAME {&FRAME-NAME} = l-ex-tarifario-ii.

        if l-executa then do:

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                 assign d-repas-max-comis:screen-value in frame {&frame-name} = string(classif-fisc.val-repas-max-comis).
            &else
                assign d-repas-max-comis:screen-value in frame {&frame-name} = substring(classif-fisc.char-1,50,6).
            &endif

        end.
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
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

  IF not avail param-global THEN
     find first param-global no-lock no-error.

  disable de-aliq-ii tg-suspensaoII tg-suspensaoIPI d-repas-max-comis tg-ex-tarifario
          with frame f-main.

  IF AVAIL param-global THEN DO:
     IF param-global.modulo-07 THEN
        enable de-aliq-ii tg-suspensaoII tg-suspensaoIPI tg-ex-tarifario
               with frame f-main.
     IF param-global.modulo-ex THEN
        enable d-repas-max-comis
               with frame f-main.
  END.

  &IF "{&bf_mat_versao_ems}" < "2.062" &then
      &if "{&BF_CEX_VERSAO_EMS}" < "2.062" &then
         assign d-repas-max-comis:hidden in frame {&frame-name} = yes
                fi-modulo-import = ""
                fi-modulo-export = "".
         disp fi-modulo-import fi-modulo-export with frame {&frame-name}.
      &endif
  &endif

    RUN eliminarSuspensao.

    /* Para o internacional o campo de ex-tarif†rio n∆o deve ser apresentado */
    IF i-pais-impto-usuario <> 1 THEN DO:
        ASSIGN tg-ex-tarifario:HIDDEN  IN FRAME f-main = YES.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */
  define buffer b-item               for item.
  define variable h-acomp            as handle  no-undo.
  define variable i-time             as integer no-undo.
  define variable i-exporta          as integer no-undo.
  define variable l-imposto-imp      as LOGICAL no-undo.
  define variable l-ex-tarifario-imp as LOGICAL no-undo.
  define variable l-ex-tarifario     as LOGICAL no-undo.
  define variable l-suspensaoii      as log init no no-undo.
  define variable l-suspensaoipi     as log init no no-undo.

  /* Code placed here will execute AFTER standard behavior.    */
  {cdp/cd4300.i4 "yes" classif-fisc.char-1}
  {cdp/cd0603.i51 "yes"}

  if not adm-new-record then do:
      ASSIGN l-ex-tarifario = IF trim(SUBSTRING(classif-fisc.char-2,4,1)) = "1":U THEN YES ELSE NO. /*Verifica a informaá∆o do EX Tarif†rio do II para
                                                                                                      exportar aos itens da classificaá∆o fiscal*/
      if de-aliq-ii-i50 <> de-aliq-ii-old or
         l-ex-tarifario <> l-ex-tarifario-old then do:
          run cdp/cd0603b.w (OUTPUT i-exporta,
                             OUTPUT l-imposto-imp,
                             OUTPUT l-ex-tarifario-imp).
          if session:set-wait-state("general") then.
              run utp/ut-acomp.p persistent set h-acomp.
              {utp/ut-liter.i Exportaá∆o_dados_para_items *}
              run pi-inicializar in h-acomp (input  Return-value ).

            case i-exporta:
                when 1 then do:
                    for each b-item use-index class-fiscal
                        where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                        if  time - i-time > 0 then do:
                            {utp/ut-liter.i Item.: *}
                            run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                            assign i-time = time.
                        end.
                        find item where rowid(item) = rowid(b-item) exclusive-lock no-error.
                        IF AVAIL ITEM THEN DO:
                            IF l-imposto-imp THEN
                                ASSIGN OVERLAY(ITEM.char-2,22,6)  = STRING(DEC(de-aliq-ii-i50),">>9.99")
                                       OVERLAY(ITEM.char-2,278,8) = STRING(DEC(de-aliq-ii-i50),">>9.9999").
                            IF l-ex-tarifario-imp THEN
                                ASSIGN OVERLAY(ITEM.char-2,269,1)  = IF l-ex-tarifario  THEN "1":U ELSE "":U. /*Grava/Atualiza a informaá∆o do EX Tarif†rio no Item*/
                        END.
                    end.
                end.
                when 2 then do:
                    for each b-item use-index class-fiscal
                        where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                        if (dec(substring(b-item.char-2,22,6)) = de-aliq-ii-old
                        OR  dec(substring(b-item.char-2,278,8)) = de-aliq-ii-old) AND l-imposto-imp then do:
                            if  time - i-time > 0 then do:
                                {utp/ut-liter.i Item.: *}
                                run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                                assign i-time = time.
                            end.
                            find item where rowid(item) = rowid(b-item) exclusive-lock no-error.
                            assign overlay(item.char-2,22,6)  = string(dec(de-aliq-ii-i50),">>9.99")
                                   overlay(item.char-2,278,8) = string(dec(de-aliq-ii-i50),">>9.9999").
                        end.
                        /*Verifica se houve alteraá∆o da informaá∆o do EX Tarif†rio em tela para atualizar no item*/
                        if substring(b-item.char-2,269,1) = c-ex-tarifario-old AND l-ex-tarifario-imp then do:
                            if  time - i-time > 0 then do:
                                {utp/ut-liter.i Item.: *}
                                run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                                assign i-time = time.
                            end.
                            find item where rowid(item) = rowid(b-item) exclusive-lock no-error.
                            IF AVAIL ITEM THEN
                               ASSIGN OVERLAY(ITEM.char-2,269,1) = IF l-ex-tarifario THEN "1":U ELSE "":U. /*Grava/atualiza a informaá∆o do EX Tarif†rio II no Item*/
                        end.
                    end.
                end.
            end case.
            run pi-finalizar in h-acomp.
            if session:set-wait-state("") then.
        end.

        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            if c-suspensaoii-ant  <> string(Classif-fisc.Log-suspens-impto-import)  or
               c-suspensaoipi-ant <> string(Classif-fisc.Log-suspens-ipi-import) then do:
                assign l-suspensaoii  = (c-suspensaoii-ant  <> string(Classif-fisc.Log-suspens-impto-import))
                       l-suspensaoipi = (c-suspensaoipi-ant <> string(Classif-fisc.Log-suspens-ipi-import)).
        &else
            if c-suspensaoii-ant  <> substring(classif-fisc.char-1,43,1)  or
               c-suspensaoipi-ant <> substring(classif-fisc.char-1,44,1) then do:
                assign l-suspensaoii  = (c-suspensaoii-ant  <> substring(classif-fisc.char-1,43,1))
                       l-suspensaoipi = (c-suspensaoipi-ant <> substring(classif-fisc.char-1,44,1)).
        &endif

                run cdp/cd0603g.w (input-output l-suspensaoii,
                                   input-output l-suspensaoipi).

                if l-suspensaoii or l-suspensaoipi then do:
                    if session:set-wait-state("general") then.
                    run utp/ut-acomp.p persistent set h-acomp.
{utp/ut-liter.i Exportaá∆o_dados_para_items *}
                    run pi-inicializar in h-acomp (input  Return-value ).

                    for each b-item use-index class-fiscal
                        where b-item.class-fiscal = classif-fisc.class-fiscal no-lock:
                        if  time - i-time > 0 then do:
                            {utp/ut-liter.i Item.: *}
                            run pi-acompanhar in h-acomp ( Return-value  + b-item.it-codigo).
                            assign i-time = time.
                        end.
                        find item where rowid(item) = rowid(b-item) exclusive-lock no-error.

                        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                        FIND item-mat WHERE item-mat.it-codigo = ITEM.it-codigo EXCLUSIVE-LOCK NO-ERROR.
                        &endif

                        if l-suspensaoii then
                            &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                                IF AVAIL item-mat THEN
                                   assign Item-mat.Log-suspens-impto-import = Classif-fisc.Log-suspens-impto-import.
                            &else
                                overlay(item.char-1,229,1) = substring(classif-fisc.char-1,43,1).
                            &endif

                        if l-suspensaoipi then
                            &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                                IF AVAIL item-mat THEN
                                   assign Item-mat.Log-suspens-ipi-import = Classif-fisc.Log-suspens-ipi-import.
                            &else
                                overlay(item.char-1,230,1) = substring(classif-fisc.char-1,44,1).
                            &endif
                     end.
                     run pi-finalizar in h-acomp.
                     if session:set-wait-state("") then.
                end.
            end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

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
  {utp/ut-liter.i Al°quota_Imposto_Importaá∆o * R}
  assign de-aliq-ii:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Suspens∆o_Imposto_Importaá∆o * L}
  assign tg-suspensaoII:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Suspens∆o_IPI_Importaá∆o * L}
  assign tg-suspensaoIPI:label in frame {&frame-name} = trim(return-value).
  {utp/ut-liter.i Ex-Tarif†rio * L}
  assign tg-ex-tarifario:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i M¢dulo_Importaá∆o * R}
  assign fi-modulo-import:screen-value in frame f-main = return-value.
  {utp/ut-liter.i M¢dulo_Exportaá∆o * R}
  assign fi-modulo-export:screen-value in frame f-main = return-value.


run pi-verifica-versao.
run pi-after-initialize.

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
  if avail classif-fisc and not adm-new-record then do:
        {cdp/cd4300.i4 "yes" classif-fisc.char-1}
        {cdp/cd0603.i51 "yes"}

        assign de-aliq-ii:screen-value in frame {&FRAME-NAME} = STRING(de-aliq-ii-i50).

        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            ASSIGN l-log-1 = Classif-fisc.Log-suspens-impto-import.
        &else
            IF substring(classif-fisc.char-1,43,1) = "1" THEN
                ASSIGN l-log-1 = YES.
            ELSE ASSIGN l-log-1 = NO.
        &endif

        ASSIGN tg-suspensaoII:checked in frame {&FRAME-NAME} = l-log-1.

        &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
            ASSIGN l-log-2 = Classif-fisc.Log-suspens-ipi-import.
        &else
            IF substring(classif-fisc.char-1,44,1) = "1" THEN
                ASSIGN l-log-2 = YES.
            ELSE ASSIGN l-log-2 = NO.
        &endif

        ASSIGN tg-suspensaoIPI:checked in frame {&FRAME-NAME} = l-log-2.


               /*tg-suspensaoII:checked in frame {&FRAME-NAME} = if
                                                              &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                                                                  Classif-fisc.Log-suspens-impto-import
                                                              &else
                                                                  substring(classif-fisc.char-1,43,1)
                                                              &endif
                                                               = YES then yes else no
               tg-suspensaoIPI:checked in frame {&FRAME-NAME} = if
                                                              &IF "{&bf_mat_versao_ems}" >= "2.06" &THEN
                                                                  Classif-fisc.Log-suspens-ipi-import
                                                              &else
                                                                  substring(classif-fisc.char-1,44,1)
                                                              &endif
                                                               = YES then yes else no.*/
        /*Atualiza a informaá∆o do EX Tarif†rio do II em tela*/
        IF trim(SUBSTRING(classif-fisc.char-2,4,1)) = "1":U THEN
            ASSIGN l-ex-tarifario-ii = YES.
        ELSE
            ASSIGN l-ex-tarifario-ii = NO.
        ASSIGN tg-ex-tarifario:CHECKED IN FRAME {&FRAME-NAME} = l-ex-tarifario-ii.

        if l-executa then do:

            &IF "{&bf_mat_versao_ems}" >= "2.062" &THEN
                 assign d-repas-max-comis:screen-value in frame {&frame-name} = string(classif-fisc.val-repas-max-comis).
            &else
                assign d-repas-max-comis:screen-value in frame {&frame-name} = substring(classif-fisc.char-1,50,6).
            &endif

        end.
    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-after-initialize V-table-Win
PROCEDURE pi-after-initialize :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
assign h-de-aliq-ii = de-aliq-ii:side-label-handle in frame f-main.
if l-executa  then do:

        ASSIGN RECT-5:HIDDEN IN FRAME f-main            = no
               RECT-6:HIDDEN IN FRAME f-main            = no
               fi-modulo-import:HIDDEN IN FRAME f-main  = no
               fi-modulo-export:HIDDEN IN FRAME f-main  = no
               d-repas-max-comis:HIDDEN IN FRAME f-main = no
               tg-suspensaoII:width in frame f-main     = 26
               tg-suspensaoII:ROW in frame f-main       = 3.46
               tg-suspensaoII:COL in frame f-main       = 23
               de-aliq-ii:ROW in frame f-main           = 2.17
               de-aliq-ii:COL in frame f-main           = 26.43
               tg-suspensaoIPI:ROW in frame f-main      = 4.16
               tg-suspensaoIPI:COL in frame f-main      = 23
               tg-suspensaoIPI:width in frame f-main    = 24.43
               tg-ex-tarifario:ROW in frame f-main      = 4.86
               tg-ex-tarifario:COL in frame f-main      = 23
               tg-ex-tarifario:width in frame f-main    = 24.43
               h-de-aliq-ii:row                         = 2.17
               h-de-aliq-ii:col                         = 2.43.

        /* Para o internacional o campo de ex-tarif†rio n∆o deve ser apresentado */
        IF i-pais-impto-usuario <> 1 THEN DO:
            ASSIGN tg-ex-tarifario:HIDDEN  IN FRAME f-main = YES.
        END.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro
  ainda n∆o foi criado.
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

    if l-executa  then do:
        if input frame {&frame-name} d-repas-max-comis > 100 then do:

             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Repasse_M†x_Comis" *}
             run utp/ut-msgs.p(input "show":U,
                               input 5638,
                               input RETURN-VALUE).
             apply 'entry' to d-repas-max-comis in frame {&frame-name}.
             return "adm-error":U.
        end.
    end.

/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */

      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-versao V-table-Win
PROCEDURE pi-verifica-versao :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
&If '{&BF_mat_VERSAO_EMS}' >= '2.04' &THEN

     if can-find (first funcao where funcao.cd-funcao = 'spp-comagext'
                    and funcao.ativo = yes) then
            assign l-executa = yes.
       &If '{&BF_CEX_VERSAO_EMS}' >= '2.062' &THEN
            assign l-executa = yes.
       &endif

  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "classif-fisc"}

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

