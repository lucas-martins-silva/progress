&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V08IN087 2.00.00.003 } /*** "010003" 28/01/2026 17:25:41 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN087 MRE}
&ENDIF

/*          This .W file was created with the Progress UIB.             */
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
&Scoped-define EXTERNAL-TABLES despesa-aces
&Scoped-define FIRST-EXTERNAL-TABLE despesa-aces


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR despesa-aces.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key RECT-21 RECT-27 
&Scoped-Define DISPLAYED-OBJECTS c-class-trib-ibs-mun c-cst-ibs-mun ~
c-class-trib-ibs-mun-reg c-cst-ibs-mun-reg c-combo-tribut-ibs-mun ~
de-vl-base-calc-ibs-mun-reg de-vl-base-calc-ibs-mun de-aliq-ibs-mun-reg ~
de-aliq-ibs-mun de-aliq-ibs-mun-red-reg de-perc-red-ibs-mun ~
de-aliq-ibs-mun-efet-reg de-perc-efetivo-ibs-mun de-vl-ibs-mun-reg ~
de-perc-difer-ibs-mun de-vl-difer-ibs-mun de-vl-ibs-mun 

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
DEFINE VARIABLE c-combo-tribut-ibs-mun AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tributa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibs-mun AS CHARACTER FORMAT "X(6)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-class-trib-ibs-mun-reg AS CHARACTER FORMAT "X(6)":U 
     LABEL "Class Trib" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibs-mun AS CHARACTER FORMAT "X(3)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-cst-ibs-mun-reg AS CHARACTER FORMAT "X(3)":U 
     LABEL "CST" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE de-aliq-ibs-mun AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliquota" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88.

DEFINE VARIABLE de-aliq-ibs-mun-efet-reg AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliq. Efetiva" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88.

DEFINE VARIABLE de-aliq-ibs-mun-red-reg AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliq. Red." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88.

DEFINE VARIABLE de-aliq-ibs-mun-reg AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "Aliquota" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88.

DEFINE VARIABLE de-perc-difer-ibs-mun AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Perc. Difer." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-efetivo-ibs-mun AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Aliq. Efetiva" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-red-ibs-mun AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Aliq. Red." 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-base-calc-ibs-mun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base Calc" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-base-calc-ibs-mun-reg AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Base Calc" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-difer-ibs-mun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Difer." 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ibs-mun AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE de-vl-ibs-mun-reg AS DECIMAL FORMAT ">>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.
     
DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 31 BY 9.96.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 6.54.
     
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 11.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-class-trib-ibs-mun AT ROW 2.08 COL 12.86 COLON-ALIGNED WIDGET-ID 386
     c-cst-ibs-mun AT ROW 2.08 COL 24.86 COLON-ALIGNED WIDGET-ID 384
     c-class-trib-ibs-mun-reg AT ROW 2.08 COL 43 COLON-ALIGNED WIDGET-ID 394
     c-cst-ibs-mun-reg AT ROW 2.08 COL 55 COLON-ALIGNED WIDGET-ID 396
     c-combo-tribut-ibs-mun AT ROW 3.08 COL 12.86 COLON-ALIGNED WIDGET-ID 388
     de-vl-base-calc-ibs-mun-reg AT ROW 3.08 COL 42.86 COLON-ALIGNED WIDGET-ID 398
     de-vl-base-calc-ibs-mun AT ROW 4.13 COL 12.86 COLON-ALIGNED WIDGET-ID 380
     de-aliq-ibs-mun-reg AT ROW 4.13 COL 42.86 COLON-ALIGNED WIDGET-ID 400
     de-aliq-ibs-mun AT ROW 5.08 COL 12.86 COLON-ALIGNED WIDGET-ID 306
     de-aliq-ibs-mun-red-reg AT ROW 5.13 COL 42.86 COLON-ALIGNED WIDGET-ID 406
     de-perc-red-ibs-mun AT ROW 6.08 COL 12.86 COLON-ALIGNED WIDGET-ID 314
     de-aliq-ibs-mun-efet-reg AT ROW 6.13 COL 42.86 COLON-ALIGNED WIDGET-ID 404
     de-perc-efetivo-ibs-mun AT ROW 7.08 COL 12.86 COLON-ALIGNED WIDGET-ID 312
     de-vl-ibs-mun-reg AT ROW 7.08 COL 42.86 COLON-ALIGNED WIDGET-ID 402
     de-perc-difer-ibs-mun AT ROW 8.08 COL 12.86 COLON-ALIGNED WIDGET-ID 316
     de-vl-difer-ibs-mun AT ROW 9.08 COL 12.86 COLON-ALIGNED WIDGET-ID 326
     de-vl-ibs-mun AT ROW 10.08 COL 12.86 COLON-ALIGNED WIDGET-ID 330
     "Tributa‡Æo Regular" VIEW-AS TEXT
          SIZE 12.86 BY .67 AT ROW 1.42 COL 34.72 WIDGET-ID 392
     rt-key AT ROW 1 COL 1
     RECT-21 AT ROW 1.71 COL 2.29 WIDGET-ID 300
     RECT-27 AT ROW 1.71 COL 34 WIDGET-ID 390
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.despesa-aces
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
         HEIGHT             = 11.17
         WIDTH              = 86.14.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-class-trib-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-class-trib-ibs-mun-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-combo-tribut-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cst-ibs-mun-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliq-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliq-ibs-mun-efet-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliq-ibs-mun-red-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-aliq-ibs-mun-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-difer-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-efetivo-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-red-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-base-calc-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-base-calc-ibs-mun-reg IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-difer-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ibs-mun IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-vl-ibs-mun-reg IN FRAME f-main
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
  
    ASSIGN c-combo-tribut-ibs-mun:LIST-ITEMS IN FRAME {&FRAME-NAME} = {diinc/i01di628.i 03}.

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
  {src/adm/template/row-list.i "despesa-aces"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "despesa-aces"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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

    /* Code placed here will execute AFTER standard behavior.    */
    IF AVAIL despesa-aces
    AND CAN-FIND(FIRST despesa-aces-tribut NO-LOCK
                 WHERE despesa-aces-tribut.cod-emitente       = despesa-aces.cod-emitente 
                   AND despesa-aces-tribut.serie-docto        = despesa-aces.serie-docto      
                   AND despesa-aces-tribut.nro-docto          = despesa-aces.nro-docto    
                   AND despesa-aces-tribut.nat-operacao       = despesa-aces.nat-operacao 
                   AND despesa-aces-tribut.cod-emitente-ac    = despesa-aces.cod-forn-ac 
                   AND despesa-aces-tribut.serie-docto-ac     = despesa-aces.ser-docto-ac
                   AND despesa-aces-tribut.nro-docto-ac       = despesa-aces.nro-docto-ac
                   AND despesa-aces-tribut.nat-operacao-ac    = despesa-aces.nat-oper-ac) THEN DO WITH FRAME {&FRAME-NAME}:
        FOR EACH  despesa-aces-tribut NO-LOCK
            WHERE despesa-aces-tribut.cod-emitente       = despesa-aces.cod-emitente 
              AND despesa-aces-tribut.serie-docto        = despesa-aces.serie-docto      
              AND despesa-aces-tribut.nro-docto          = despesa-aces.nro-docto    
              AND despesa-aces-tribut.nat-operacao       = despesa-aces.nat-operacao 
              AND despesa-aces-tribut.cod-emitente-ac    = despesa-aces.cod-forn-ac 
              AND despesa-aces-tribut.serie-docto-ac     = despesa-aces.ser-docto-ac
              AND despesa-aces-tribut.nro-docto-ac       = despesa-aces.nro-docto-ac
              AND despesa-aces-tribut.nat-operacao-ac    = despesa-aces.nat-oper-ac
              AND despesa-aces-tribut.nom-trib           = rep.imp.Imposto:IBS-MUN:
           
            CASE despesa-aces-tribut.cod-campo:
                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB  THEN
                    ASSIGN c-class-trib-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:CST THEN
                    ASSIGN c-cst-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:COD-TRIB THEN
                   ASSIGN c-combo-tribut-ibs-mun:SCREEN-VALUE = {diinc/i01di628.i 04 INT(despesa-aces-tribut.cod-conteudo)}.
                WHEN rep.imp.AtributoImposto:BASE  THEN
                   ASSIGN de-vl-base-calc-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:ALIQUOTA THEN
                   ASSIGN de-aliq-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.   
                WHEN rep.imp.AtributoImposto:ALIQ-RED THEN
                    ASSIGN de-perc-red-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:ALIQ-EFETIVA THEN
                    ASSIGN de-perc-efetivo-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:PERC-DIFER THEN
                    ASSIGN de-perc-difer-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:VALOR-DIFER THEN
                    ASSIGN de-vl-difer-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:VALOR THEN
                    ASSIGN de-vl-ibs-mun:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.   
                WHEN rep.imp.AtributoImposto:C-CLASS-TRIB-REG THEN
                   ASSIGN c-class-trib-ibs-mun-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN  rep.imp.AtributoImposto:CST-REG THEN
                   ASSIGN c-cst-ibs-mun-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:BASE-REG  THEN
                   ASSIGN de-vl-base-calc-ibs-mun-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.
                WHEN rep.imp.AtributoImposto:ALIQUOTA-REG THEN
                   ASSIGN de-aliq-ibs-mun-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.   
                WHEN rep.imp.AtributoImposto:ALIQ-RED-REG THEN
                   ASSIGN de-aliq-ibs-mun-red-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.  
                WHEN rep.imp.AtributoImposto:ALIQ-EFETIVA-REG THEN
                   ASSIGN de-aliq-ibs-mun-efet-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.  
                WHEN rep.imp.AtributoImposto:VALOR-REG THEN
                   ASSIGN de-vl-ibs-mun-reg:SCREEN-VALUE = despesa-aces-tribut.cod-conteudo.  
            END CASE.
        END. //FOR EACH
    END.
    ELSE DO WITH FRAME {&FRAME-NAME}:
        ASSIGN c-class-trib-ibs-mun       :SCREEN-VALUE = "":U
               c-cst-ibs-mun              :SCREEN-VALUE = "000":U
               c-combo-tribut-ibs-mun     :SCREEN-VALUE = "Tributado":U
               de-vl-base-calc-ibs-mun    :SCREEN-VALUE = "0,00"
               de-aliq-ibs-mun            :SCREEN-VALUE = "0,00"
               de-perc-red-ibs-mun        :SCREEN-VALUE = "0,00"
               de-perc-efetivo-ibs-mun    :SCREEN-VALUE = "0,00"
               de-perc-difer-ibs-mun      :SCREEN-VALUE = "0,00"
               de-vl-difer-ibs-mun        :SCREEN-VALUE = "0,00"
               de-vl-ibs-mun              :SCREEN-VALUE = "0,00"
               c-class-trib-ibs-mun-reg   :SCREEN-VALUE = "":U
               c-cst-ibs-mun-reg          :SCREEN-VALUE = "000":U
               de-vl-base-calc-ibs-mun-reg:SCREEN-VALUE = "0,00"
               de-aliq-ibs-mun-reg        :SCREEN-VALUE = "0,00"
               de-aliq-ibs-mun-red-reg    :SCREEN-VALUE = "0,00"
               de-aliq-ibs-mun-efet-reg   :SCREEN-VALUE = "0,00"
               de-vl-ibs-mun-reg          :SCREEN-VALUE = "0,00". 
               
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
  
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


