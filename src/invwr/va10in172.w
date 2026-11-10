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
{include/i-prgvrs.i VA10IN172 2.00.00.002}  /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i VA10IN172 MUT}
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
/* Integracao Modulo Importacao */
def var l-modulo-imp       as logical             no-undo.

{cdp/cdcfgmat.i}  /* pre-processadores */
{include/i_dbvers.i}

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS label-pis-imp label-cof-imp RECT-1 RECT-2 ~
RECT-3 RECT-4 RECT-5 
&Scoped-Define DISPLAYED-OBJECTS rs-trib-pis rs-trib-cofins d-val-unit-pis ~
d-val-unit-cofins d-red-pis d-red-cofins cb-trib-pis cb-trib-cofins ~
d-vl-pis-volum d-vl-cofins-volum d-perc-reduc-pis d-perc-reduc-cofins ~
d-perc-ext-pis d-perc-ext-cofins label-pis-imp label-cof-imp 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS rs-trib-pis rs-trib-cofins d-aliq-pis ~
d-aliq-cofins d-val-unit-pis d-val-unit-cofins d-red-pis d-red-cofins ~
cb-trib-pis cb-trib-cofins d-vl-pis-volum d-vl-cofins-volum ~
d-perc-reduc-pis d-perc-reduc-cofins d-perc-ext-pis d-perc-ext-cofins 
&Scoped-define ADM-MODIFY-FIELDS rs-trib-pis rs-trib-cofins d-aliq-pis ~
d-aliq-cofins d-val-unit-pis d-val-unit-cofins d-red-pis d-red-cofins ~
cb-trib-pis cb-trib-cofins d-vl-pis-volum d-vl-cofins-volum ~
d-perc-reduc-pis d-perc-reduc-cofins d-perc-ext-pis d-perc-ext-cofins 

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
DEFINE VARIABLE cb-trib-cofins AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-trib-pis AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE d-aliq-cofins AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 8.29 BY .88 NO-UNDO.

DEFINE VARIABLE d-aliq-pis AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "Al¡quota" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-perc-ext-cofins AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Externo" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-perc-ext-pis AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Externo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-perc-reduc-cofins AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-perc-reduc-pis AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "% Redu‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE d-red-cofins AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Redu‡Æo Cofins" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-red-pis AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "% Redu‡Æo Pis" 
     VIEW-AS FILL-IN 
     SIZE 8.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-unit-cofins AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "Valor Unit" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-val-unit-pis AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "Valor Unit" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-vl-cofins-volum AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "Valor Unit por Volume" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE d-vl-pis-volum AS DECIMAL FORMAT ">>>9.99999":U INITIAL 0 
     LABEL "Valor Unit por Volume" 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE label-cof-imp AS CHARACTER FORMAT "X(256)":U INITIAL "COFINS Importa‡Æo" 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE label-pis-imp AS CHARACTER FORMAT "X(256)":U INITIAL "PIS Importa‡Æo" 
      VIEW-AS TEXT 
     SIZE 11 BY .67 NO-UNDO.

DEFINE VARIABLE rs-trib-cofins AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Item", 1,
"Natureza", 2
     SIZE 19 BY 1 NO-UNDO.

DEFINE VARIABLE rs-trib-pis AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Item", 1,
"Natureza", 2
     SIZE 20 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 13.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 5.5.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 5.5.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 5.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 35 BY 5.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     rs-trib-pis AT ROW 2.5 COL 16 NO-LABEL
     rs-trib-cofins AT ROW 2.5 COL 59 NO-LABEL
     d-aliq-pis AT ROW 3.5 COL 14 COLON-ALIGNED
     d-aliq-cofins AT ROW 3.5 COL 57 COLON-ALIGNED
     d-val-unit-pis AT ROW 4.5 COL 14 COLON-ALIGNED
     d-val-unit-cofins AT ROW 4.5 COL 57 COLON-ALIGNED
     d-red-pis AT ROW 5.5 COL 14 COLON-ALIGNED
     d-red-cofins AT ROW 5.5 COL 57 COLON-ALIGNED
     cb-trib-pis AT ROW 8.5 COL 14 COLON-ALIGNED
     cb-trib-cofins AT ROW 8.5 COL 56 COLON-ALIGNED
     d-vl-pis-volum AT ROW 9.5 COL 20.14 COLON-ALIGNED
     d-vl-cofins-volum AT ROW 9.5 COL 62 COLON-ALIGNED
     d-perc-reduc-pis AT ROW 10.5 COL 20 COLON-ALIGNED
     d-perc-reduc-cofins AT ROW 10.5 COL 62 COLON-ALIGNED
     d-perc-ext-pis AT ROW 11.5 COL 20 COLON-ALIGNED
     d-perc-ext-cofins AT ROW 11.5 COL 62 COLON-ALIGNED
     label-pis-imp AT ROW 7.25 COL 3 COLON-ALIGNED NO-LABEL
     label-cof-imp AT ROW 7.25 COL 44 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 1.5 COL 3
     RECT-3 AT ROW 7.5 COL 3
     RECT-4 AT ROW 1.5 COL 44
     RECT-5 AT ROW 7.5 COL 44
     "Origem Al¡q:" VIEW-AS TEXT
          SIZE 9 BY .67 AT ROW 2.5 COL 49
     "Origem Al¡q:" VIEW-AS TEXT
          SIZE-PIXELS 63 BY 16 AT Y 36 X 104 RIGHT-ALIGNED
     "PIS" VIEW-AS TEXT
          SIZE-PIXELS 21 BY 16 AT Y 6 X 48 RIGHT-ALIGNED
     "COFINS" VIEW-AS TEXT
          SIZE-PIXELS 49 BY 16 AT Y 6 X 363 RIGHT-ALIGNED
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
         HEIGHT             = 13.25
         WIDTH              = 86.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i-auxtab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME F-Main:SCROLLABLE       = FALSE
       FRAME F-Main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-trib-cofins IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-trib-pis IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-aliq-cofins IN FRAME F-Main
   NO-DISPLAY NO-ENABLE 2 3                                             */
/* SETTINGS FOR FILL-IN d-aliq-pis IN FRAME F-Main
   NO-DISPLAY NO-ENABLE 2 3                                             */
/* SETTINGS FOR FILL-IN d-perc-ext-cofins IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-perc-ext-pis IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-perc-reduc-cofins IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-perc-reduc-pis IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-red-cofins IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-red-pis IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-val-unit-cofins IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-val-unit-pis IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-vl-cofins-volum IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN d-vl-pis-volum IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET rs-trib-cofins IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR RADIO-SET rs-trib-pis IN FRAME F-Main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TEXT-LITERAL "PIS"
          SIZE 3 BY .67 AT ROW 1.25 COL 7 RIGHT-ALIGNED                 */

/* SETTINGS FOR TEXT-LITERAL "COFINS"
          SIZE 7 BY .67 AT ROW 1.25 COL 52 RIGHT-ALIGNED                */

/* SETTINGS FOR TEXT-LITERAL "Origem Al¡q:"
          SIZE 9 BY .67 AT ROW 2.5 COL 15 RIGHT-ALIGNED                 */

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME F-Main
/* Query rebuild information for FRAME F-Main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME F-Main */
&ANALYZE-RESUME




&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  HIDE FRAME F-Main.
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

  IF  NOT FRAME {&FRAME-NAME}:VALIDATE() THEN
      RETURN 'ADM-ERROR':U.

  DO WITH FRAME {&FRAME-NAME}:
     ASSIGN rs-trib-pis
            rs-trib-cofins
            d-aliq-pis
            d-aliq-cofins
            d-val-unit-pis
            d-val-unit-cofins
            d-red-pis
            d-red-cofins.
  END.

  IF  l-modulo-imp THEN DO:
    DO WITH FRAME {&FRAME-NAME}:
       ASSIGN cb-trib-pis
              cb-trib-cofins   
              d-vl-pis-volum
              d-vl-cofins-volum
              d-perc-reduc-pis
              d-perc-reduc-cofins
              d-perc-ext-pis
              d-perc-ext-cofins.
    END.
  END.

/*
   Posto em coment rio devido a viewer nÆo possuir campos de tabela.
   Desta forma o run dispatch nÆo poder  ser executado.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
*/

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN OVERLAY(ITEM.char-2,052,01) = string(rs-trib-pis)
         OVERLAY(ITEM.char-2,053,01) = string(rs-trib-cofins)
         OVERLAY(ITEM.char-2,031,05) = STRING(d-aliq-pis,">9.99")
         OVERLAY(ITEM.char-2,036,05) = STRING(d-aliq-cofins,">9.99")
         OVERLAY(ITEM.char-2,054,10) = STRING(d-val-unit-pis,">>>9.99999")
         OVERLAY(ITEM.char-2,064,10) = STRING(d-val-unit-cofins,">>>9.99999")
         OVERLAY(ITEM.char-2,200,6)  = STRING(d-red-pis,">>9.99":U)
         OVERLAY(ITEM.char-2,206,6)  = STRING(d-red-cofins,">>9.99":U).

  /* Integracao Modulo Importacao */
  IF  l-modulo-imp THEN DO:
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.06' &THEN 
        ASSIGN item-mat.idi-tributac-pis    = cb-trib-pis
               item-mat.idi-tributac-cofins = cb-trib-cofins
               item-mat.val-unit-vol-pis    = d-vl-pis-volum
               item-mat.val-unit-vol-cofins = d-vl-cofins-volum
               item-mat.val-aliq-ext-pis    = d-perc-ext-pis
               item-mat.val-aliq-ext-cofins = d-perc-ext-cofins.
    &ELSE
        ASSIGN OVERLAY(ITEM.char-1,195,01) = IF cb-trib-pis    = "" THEN "" ELSE STRING({ininc/i04in176.i 06 cb-trib-pis})
               OVERLAY(ITEM.char-1,196,01) = IF cb-trib-cofins = "" THEN "" ELSE STRING({ininc/i04in176.i 06 cb-trib-cofins})
               OVERLAY(ITEM.char-1,197,10) = STRING(d-vl-pis-volum,">>>9.99999")
               OVERLAY(ITEM.char-1,207,10) = STRING(d-vl-cofins-volum,">>>9.99999")
               OVERLAY(ITEM.char-2,041,05) = STRING(d-perc-reduc-pis,">9.99")
               OVERLAY(ITEM.char-2,046,05) = STRING(d-perc-reduc-cofins,">9.99")
               OVERLAY(ITEM.char-1,217,06) = STRING(d-perc-ext-pis,">>9.99")
               OVERLAY(ITEM.char-1,223,06) = STRING(d-perc-ext-cofins,">>9.99").
    &ENDIF
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

  /* Code placed here will execute AFTER standard behavior.    */

  DISABLE rs-trib-pis   rs-trib-cofins d-aliq-pis 
          d-aliq-cofins d-val-unit-pis d-val-unit-cofins d-red-pis d-red-cofins
          WITH FRAME {&frame-name}.

  IF  l-modulo-imp THEN
      DISABLE cb-trib-pis cb-trib-cofins d-vl-pis-volum d-vl-cofins-volum d-perc-reduc-pis
              d-perc-reduc-cofins d-perc-ext-pis d-perc-ext-cofins
              WITH FRAME {&frame-name}.

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

  DO  WITH FRAME {&frame-name}:
      ASSIGN cb-trib-pis:LIST-ITEMS         = {ininc/i04in176.i 03} + "," + " "
             cb-trib-cofins:LIST-ITEMS      = {ininc/i04in176.i 03} + "," + " "
             d-aliq-pis:SCREEN-VALUE        = SUBSTR(ITEM.char-2,31,5)
             d-aliq-cofins:SCREEN-VALUE     = SUBSTR(ITEM.char-2,36,5)
             d-val-unit-pis:SCREEN-VALUE    = SUBSTR(ITEM.char-2,54,10)
             d-val-unit-cofins:SCREEN-VALUE = SUBSTR(ITEM.char-2,64,10)
             d-red-pis:SCREEN-VALUE         = SUBSTR(ITEM.char-2,200,6)
             d-red-cofins:SCREEN-VALUE      = SUBSTR(ITEM.char-2,206,6).

      /* PIS */
      IF SUBSTR(ITEM.CHAR-2,52,1) = "" THEN        
         ASSIGN rs-trib-pis:SCREEN-VALUE = "2".
      ELSE
         ASSIGN rs-trib-pis:SCREEN-VALUE = SUBSTR(ITEM.CHAR-2,52,1).

      /* COFINS */
      IF SUBSTR(ITEM.CHAR-2,53,1) = "" THEN        
         ASSIGN rs-trib-cofins:SCREEN-VALUE = "2".
      ELSE
         ASSIGN rs-trib-cofins:SCREEN-VALUE = SUBSTR(ITEM.CHAR-2,53,1).

     &IF '{&BF_DIS_VERSAO_EMS}' >= '2.06' &THEN
      IF  AVAIL item-mat THEN
          ASSIGN cb-trib-pis:SCREEN-VALUE         = {ininc/i04in176.i 04 item-mat.idi-tributac-pis}
                 cb-trib-cofins:SCREEN-VALUE      = {ininc/i04in176.i 04 item-mat.idi-tributac-cofins}
                 d-vl-pis-volum:SCREEN-VALUE      = item-mat.val-unit-vol-pis
                 d-vl-cofins-volum:SCREEN-VALUE   = item-mat.val-unit-vol-cofins
                 d-perc-reduc-pis:SCREEN-VALUE    = SUBSTR(ITEM.char-2,41,5)
                 d-perc-reduc-cofins:SCREEN-VALUE = SUBSTR(ITEM.char-2,46,5)
                 d-perc-ext-pis:SCREEN-VALUE      = item-mat.val-aliq-ext-pis
                 d-perc-ext-cofins:SCREEN-VALUE   = item-mat.val-aliq-ext-cofins.
     &ELSE
      IF  AVAIL ITEM THEN DO:
          IF  SUBSTR(ITEM.char-1,195,1) = "" THEN
              ASSIGN cb-trib-pis:SCREEN-VALUE = "".
          ELSE
              ASSIGN cb-trib-pis:SCREEN-VALUE    = {ininc/i04in176.i 04 INT(SUBSTR(ITEM.char-1,195,1))}.

          IF  SUBSTR(ITEM.char-1,196,1) = "" THEN
              ASSIGN cb-trib-cofins:SCREEN-VALUE = "".
          ELSE
             ASSIGN cb-trib-cofins:SCREEN-VALUE = {ininc/i04in176.i 04 INT(SUBSTR(ITEM.char-1,196,1))}.

          ASSIGN d-vl-pis-volum:SCREEN-VALUE      = SUBSTR(ITEM.char-1,197,10)
                 d-vl-cofins-volum:SCREEN-VALUE   = SUBSTR(ITEM.char-1,207,10)
                 d-perc-reduc-pis:SCREEN-VALUE    = SUBSTR(ITEM.char-2,041,05)
                 d-perc-reduc-cofins:SCREEN-VALUE = SUBSTR(ITEM.char-2,046,05)
                 d-perc-ext-pis:SCREEN-VALUE      = SUBSTR(ITEM.char-1,217,06)
                 d-perc-ext-cofins:SCREEN-VALUE   = SUBSTR(ITEM.char-1,223,06).
      END.
     &ENDIF
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ENABLE rs-trib-pis   rs-trib-cofins d-aliq-pis 
         d-aliq-cofins d-val-unit-pis d-val-unit-cofins d-red-pis d-red-cofins
         WITH FRAME {&frame-name}.

  IF  l-modulo-imp THEN
      ENABLE cb-trib-pis cb-trib-cofins d-vl-pis-volum d-vl-cofins-volum d-perc-reduc-pis
             d-perc-reduc-cofins d-perc-ext-pis d-perc-ext-cofins rs-trib-pis rs-trib-cofins
             d-aliq-pis d-aliq-cofins d-val-unit-pis d-val-unit-cofins
             WITH FRAME {&frame-name}.
  ELSE
      DISABLE cb-trib-pis cb-trib-cofins d-vl-pis-volum d-vl-cofins-volum d-perc-reduc-pis
              d-perc-reduc-cofins d-perc-ext-pis d-perc-ext-cofins
              WITH FRAME {&frame-name}.

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

  find first param-global no-lock no-error.
  if  not avail param-global then do:
      run utp/ut-msgs.p (input "show",
                         input 2314,
                         input "").
      return 'ADM-ERROR':U.
  end.
  if avail param-global and param-global.modulo-07 then
     assign l-modulo-imp = yes.
  else
     assign l-modulo-imp = no.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

