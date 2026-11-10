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
{include/i-prgvrs.i IM0994A-V03 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im0994a-v02 MIM}
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
DEFINE TEMP-TABLE tt-dados NO-UNDO
    FIELD cdn-tip-comprov-afip AS INTEGER
    FIELD cdd-cai              AS DECIMAL
    FIELD dat-vencto-cai       AS DATE
    FIELD log-emitid-cf        AS LOGICAL
    FIELD cdn-aduana           AS INTEGER
    FIELD cod-destinac         AS CHARACTER
    FIELD cod-despch           AS CHARACTER
    FIELD cod-verfdor          AS CHARACTER
    FIELD dat-despch           AS DATE
    FIELD cdn-ano-import       AS INTEGER
    FIELD idi-operac-import    AS INTEGER.

DEFINE TEMP-TABLE tt-dados-aux NO-UNDO LIKE tt-dados.

DEFINE VARIABLE h-boar2033 AS HANDLE      NO-UNDO.
DEFINE VARIABLE i-combo    AS INTEGER     NO-UNDO.
DEFINE VARIABLE c-lista    AS CHARACTER   NO-UNDO.
DEFINE VARIABLE c-emitente AS CHARACTER   NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES docum-est
&Scoped-define FIRST-EXTERNAL-TABLE docum-est


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR docum-est.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS 
&Scoped-define ENABLED-TABLES docum-est
&Scoped-define FIRST-ENABLED-TABLE docum-est
&Scoped-Define ENABLED-OBJECTS RECT-6 RECT-1 RECT-2 v-cdn-tip-comprov-afip ~
v-cdd-cai v-log-emitid-cf v-cdn-aduana v-cod-destinac v-cod-despch ~
v-cod-verfdor v-dat-despch v-cdn-ano-import cb-idi-operac-import 
&Scoped-Define DISPLAYED-OBJECTS v-cdn-tip-comprov-afip ~
des-tip-comprov-afip v-cdd-cai v-dat-vencto-cai v-log-emitid-cf ~
v-cdn-aduana des-aduana v-cod-destinac des-destinac v-cod-despch ~
v-cod-verfdor v-dat-despch v-cdn-ano-import cb-idi-operac-import 
&Scoped-Define DISPLAYED-FIELDS  
&Scoped-define DISPLAYED-TABLES docum-est
&Scoped-define FIRST-DISPLAYED-TABLE docum-est

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS v-cdn-tip-comprov-afip 

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
DEFINE VARIABLE cb-idi-operac-import AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tp. Oper. Importa‡Æo" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 31 BY .88 NO-UNDO.

DEFINE VARIABLE des-aduana AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 52.29 BY .88 NO-UNDO.

DEFINE VARIABLE des-destinac AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 50.29 BY .88 NO-UNDO.

DEFINE VARIABLE des-tip-comprov-afip AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE v-cdd-cai AS DECIMAL FORMAT "99999999999999" INITIAL 0 
     LABEL "CAI" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE v-cdn-aduana AS INTEGER FORMAT "999" INITIAL 0 
     LABEL "Cod. Aduana" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE v-cdn-ano-import AS INTEGER FORMAT "9999" INITIAL 0 
     LABEL "Ano Doc. Import" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE v-cdn-tip-comprov-afip AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "T/C AFIP" 
     VIEW-AS FILL-IN 
     SIZE 3.43 BY .88.

DEFINE VARIABLE v-cod-despch AS CHARACTER FORMAT "X(6)" 
     LABEL "Nro Despacho" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE VARIABLE v-cod-destinac AS CHARACTER FORMAT "X(4)" 
     LABEL "Cod. Destino" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE v-cod-verfdor AS CHARACTER FORMAT "x(1)" 
     LABEL "Dig. Verific" 
     VIEW-AS FILL-IN 
     SIZE 3.14 BY .88.

DEFINE VARIABLE v-dat-despch AS DATE FORMAT "99/99/9999" 
     LABEL "Data Despacho" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88 NO-UNDO.

DEFINE VARIABLE v-dat-vencto-cai AS DATE FORMAT "99/99/9999" 
     LABEL "Data Vencimento" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 2.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 80 BY 6.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 81.86 BY 10.75.

DEFINE VARIABLE v-log-emitid-cf AS LOGICAL INITIAL no 
     LABEL "Emitido por CF" 
     VIEW-AS TOGGLE-BOX
     SIZE 17.14 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     v-cdn-tip-comprov-afip AT ROW 2.67 COL 9.14 COLON-ALIGNED WIDGET-ID 24
     des-tip-comprov-afip AT ROW 2.67 COL 13.14 COLON-ALIGNED NO-LABEL WIDGET-ID 16
     v-cdd-cai AT ROW 2.67 COL 31.72 COLON-ALIGNED WIDGET-ID 22
     v-dat-vencto-cai AT ROW 2.67 COL 65 COLON-ALIGNED WIDGET-ID 26
     v-log-emitid-cf AT ROW 3.67 COL 11 WIDGET-ID 28
     v-cdn-aduana AT ROW 6 COL 16.29 COLON-ALIGNED WIDGET-ID 40
     des-aduana AT ROW 6 COL 21.72 COLON-ALIGNED NO-LABEL WIDGET-ID 32
     v-cod-destinac AT ROW 7 COL 16.29 COLON-ALIGNED WIDGET-ID 46
     des-destinac AT ROW 7 COL 23.72 COLON-ALIGNED NO-LABEL WIDGET-ID 34
     v-cod-despch AT ROW 8 COL 16.29 COLON-ALIGNED WIDGET-ID 44
     v-cod-verfdor AT ROW 8 COL 36.29 COLON-ALIGNED WIDGET-ID 48
     v-dat-despch AT ROW 9 COL 16.29 COLON-ALIGNED WIDGET-ID 50
     v-cdn-ano-import AT ROW 9 COL 45.57 COLON-ALIGNED WIDGET-ID 42
     cb-idi-operac-import AT ROW 10 COL 20.29 COLON-ALIGNED WIDGET-ID 30
     "Comprovantes Nacionais" VIEW-AS TEXT
          SIZE 18.86 BY .54 AT ROW 1.58 COL 6.14 WIDGET-ID 20
     "Comprovantes do Exterior" VIEW-AS TEXT
          SIZE 18.86 BY .54 AT ROW 4.92 COL 6.14 WIDGET-ID 38
     RECT-6 AT ROW 1.25 COL 1.14
     RECT-1 AT ROW 1.92 COL 2.14 WIDGET-ID 18
     RECT-2 AT ROW 5.25 COL 2.14 WIDGET-ID 36
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.docum-est
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
         HEIGHT             = 11.17
         WIDTH              = 82.57.
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

/* SETTINGS FOR FILL-IN des-aduana IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-destinac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN des-tip-comprov-afip IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN v-cdn-tip-comprov-afip IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN v-dat-vencto-cai IN FRAME f-main
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

&Scoped-define SELF-NAME v-cdn-aduana
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-aduana V-table-Win
ON F5 OF v-cdn-aduana IN FRAME f-main /* Cod. Aduana */
DO:
   DEF VAR hprogramzoom AS HANDLE NO-UNDO.
  {method/zoomfields.i &ProgramZoom="local/arg/ar2z014.w"
                         &FieldZoom1="cdn-aduana"
                         &FieldScreen1="v-cdn-aduana"
                         &Frame1="{&FRAME-NAME}" }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-aduana V-table-Win
ON LEAVE OF v-cdn-aduana IN FRAME f-main /* Cod. Aduana */
DO:
    IF  VALID-HANDLE(h-boar2033) THEN DO:
        RUN aplicaLeaveTela IN h-boar2033 (INPUT  "arg-aduana-afip",
                                           INPUT  v-cdn-aduana:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           OUTPUT des-aduana).

        DISPLAY des-aduana WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-aduana V-table-Win
ON MOUSE-SELECT-DBLCLICK OF v-cdn-aduana IN FRAME f-main /* Cod. Aduana */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cdn-tip-comprov-afip
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-tip-comprov-afip V-table-Win
ON F5 OF v-cdn-tip-comprov-afip IN FRAME f-main /* T/C AFIP */
DO:
    DEF VAR hprogramzoom AS HANDLE NO-UNDO.
    {method/zoomfields.i &ProgramZoom="local/arg/ar2z013.w"
                         &FieldZoom1="cdn-tip-comprov-afip"
                         &FieldScreen1="v-cdn-tip-comprov-afip"
                         &Frame1="{&FRAME-NAME}" }
                         /*&FieldZoom2="des-tip-comprov-afip"
                         &FieldScreen2="des-tip-comprov-afip" 
                         &Frame2= "{&FRAME-NAME}"}*/
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-tip-comprov-afip V-table-Win
ON LEAVE OF v-cdn-tip-comprov-afip IN FRAME f-main /* T/C AFIP */
DO:
    IF  VALID-HANDLE(h-boar2033) THEN DO:
        RUN aplicaLeaveTela IN h-boar2033 (INPUT  "arg-tip-comprov-afip",
                                           INPUT  v-cdn-tip-comprov-afip:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           OUTPUT des-tip-comprov-afip).

        DISPLAY des-tip-comprov-afip WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cdn-tip-comprov-afip V-table-Win
ON MOUSE-SELECT-DBLCLICK OF v-cdn-tip-comprov-afip IN FRAME f-main /* T/C AFIP */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-cod-destinac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-destinac V-table-Win
ON F5 OF v-cod-destinac IN FRAME f-main /* Cod. Destino */
DO:
    DEF VAR hprogramzoom AS HANDLE NO-UNDO.
    {method/zoomfields.i &ProgramZoom="local/arg/ar2z015.w"
                         &FieldZoom1="cod-destinac"
                         &FieldScreen1="v-cod-destinac"
                         &Frame1="{&FRAME-NAME}"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-destinac V-table-Win
ON LEAVE OF v-cod-destinac IN FRAME f-main /* Cod. Destino */
DO:
    IF  VALID-HANDLE(h-boar2033) THEN DO:
        RUN aplicaLeaveTela IN h-boar2033 (INPUT  "arg-destinac-afip",
                                           INPUT  v-cod-destinac:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                                           OUTPUT des-destinac).

        DISPLAY des-destinac WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-cod-destinac V-table-Win
ON MOUSE-SELECT-DBLCLICK OF v-cod-destinac IN FRAME f-main /* Cod. Destino */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME v-dat-despch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL v-dat-despch V-table-Win
ON LEAVE OF v-dat-despch IN FRAME f-main /* Data Despacho */
DO:
  IF  INPUT FRAME {&FRAME-NAME} v-dat-despch <> ? THEN
      ASSIGN v-cdn-ano-import:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(YEAR(INPUT FRAME {&FRAME-NAME} v-dat-despch),"9999").
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
  {src/adm/template/row-list.i "docum-est"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "docum-est"}

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
 
  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:

      RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "cod-emitente").
      ASSIGN c-emitente = TRIM(RETURN-VALUE).

        ASSIGN INPUT FRAME {&FRAME-NAME} v-cdn-tip-comprov-afip
               INPUT FRAME {&FRAME-NAME} v-cdd-cai
               INPUT FRAME {&FRAME-NAME} v-dat-vencto-cai
               INPUT FRAME {&FRAME-NAME} v-log-emitid-cf
               INPUT FRAME {&FRAME-NAME} v-cdn-aduana
               INPUT FRAME {&FRAME-NAME} v-cod-destinac
               INPUT FRAME {&FRAME-NAME} v-cod-despch
               INPUT FRAME {&FRAME-NAME} v-cod-verfdor
               INPUT FRAME {&FRAME-NAME} v-dat-despch
               INPUT FRAME {&FRAME-NAME} v-cdn-ano-import
               INPUT FRAME {&FRAME-NAME} cb-idi-operac-import.
    
        ASSIGN i-combo = {local/arg/ar2inc/i01ar2016.i 06 cb-idi-operac-import}.

        FIND FIRST emitente NO-LOCK WHERE 
                   emitente.cod-emitente = INT(c-emitente) NO-ERROR.
        IF  AVAIL emitente AND emitente.natureza = 3 OR emitente.natureza = 4 THEN DO:
            IF v-cod-destinac = '' THEN DO:
                {utp/ut-liter.i Destino *}
                RUN utp/ut-msgs.p(input "WARNING":U,INPUT 164,INPUT RETURN-VALUE).
                APPLY "entry" TO v-cod-destinac IN FRAME {&FRAME-NAME}.
                RETURN 'ADM-ERROR':U.
            END.
           
            IF  v-cod-despch = '' THEN DO:
                {utp/ut-liter.i Despachante *}
                RUN utp/ut-msgs.p(input "WARNING":U,INPUT 164,INPUT RETURN-VALUE).
                APPLY "entry" TO v-cod-despch IN FRAME {&FRAME-NAME}.
                RETURN 'ADM-ERROR':U.
            END.
           
            IF  v-cod-verfdor = '' THEN DO:
                {utp/ut-liter.i C¢digo_Verificador *}
                RUN utp/ut-msgs.p(input "WARNING":U,INPUT 164,INPUT RETURN-VALUE).
                APPLY "entry" TO v-cod-verfdor IN FRAME {&FRAME-NAME}.
                RETURN 'ADM-ERROR':U.
            END.
           
            IF  v-cdn-ano-import = 0000 THEN DO:
                {utp/ut-liter.i Ano_Documento *}
                RUN utp/ut-msgs.p(input "WARNING":U,INPUT 164,INPUT RETURN-VALUE).
                APPLY "entry" TO v-cdn-ano-import IN FRAME {&FRAME-NAME}.
                RETURN 'ADM-ERROR':U.
            END.
        END.
        
        IF  VALID-HANDLE(h-boar2033) THEN DO:
            EMPTY TEMP-TABLE tt-dados-aux.
    
            CREATE tt-dados-aux.
            ASSIGN tt-dados-aux.cdn-tip-comprov-afip = v-cdn-tip-comprov-afip
                   tt-dados-aux.cdd-cai              = v-cdd-cai
                   tt-dados-aux.dat-vencto-cai       = v-dat-vencto-cai
                   tt-dados-aux.log-emitid-cf        = v-log-emitid-cf
                   tt-dados-aux.cdn-aduana           = v-cdn-aduana
                   tt-dados-aux.cod-destinac         = v-cod-destinac
                   tt-dados-aux.cod-despch           = v-cod-despch
                   tt-dados-aux.cod-verfdor          = v-cod-verfdor
                   tt-dados-aux.dat-despch           = v-dat-despch
                   tt-dados-aux.cdn-ano-import       = v-cdn-ano-import
                   tt-dados-aux.idi-operac-import    = i-combo.
        END.
  END.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
      return 'ADM-ERROR':U.

  IF i-pais-impto-usuario = 2 THEN DO:
       IF  VALID-HANDLE(h-boar2033) THEN DO:    
            RUN gravaDados IN h-boar2033 (INPUT ROWID(docum-est),
                                          INPUT TABLE tt-dados-aux).
       END.
  END.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
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

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  VALID-HANDLE(h-boar2033) THEN DO:
          RUN destroy IN h-boar2033.
          ASSIGN h-boar2033 = ?.
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      EMPTY TEMP-TABLE tt-dados.

      IF  VALID-HANDLE(h-boar2033) THEN DO:
          RUN buscaDados IN h-boar2033 (INPUT  ROWID(docum-est),
                                        OUTPUT TABLE tt-dados).

          FIND FIRST tt-dados NO-LOCK NO-ERROR.
          IF  AVAIL  tt-dados THEN
              ASSIGN v-cdn-tip-comprov-afip = tt-dados.cdn-tip-comprov-afip
                     v-cdd-cai              = tt-dados.cdd-cai
                     v-dat-vencto-cai       = tt-dados.dat-vencto-cai
                     v-log-emitid-cf        = tt-dados.log-emitid-cf
                     v-cdn-aduana           = tt-dados.cdn-aduana
                     v-cod-destinac         = tt-dados.cod-destinac
                     v-cod-despch           = tt-dados.cod-despch
                     v-cod-verfdor          = tt-dados.cod-verfdor
                     v-dat-despch           = tt-dados.dat-despch
                     v-cdn-ano-import       = tt-dados.cdn-ano-import
                     i-combo                = tt-dados.idi-operac-import.

          DISPLAY v-cdn-tip-comprov-afip
                  v-cdd-cai
                  v-dat-vencto-cai
                  v-log-emitid-cf
                  v-cdn-aduana
                  v-cod-destinac
                  v-cod-despch
                  v-cod-verfdor
                  v-dat-despch
                  v-cdn-ano-import
              WITH FRAME {&FRAME-NAME}.
      END.

      IF  i-combo = 0 THEN
          ASSIGN i-combo = 1.
    
      ASSIGN cb-idi-operac-import:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {local/arg/ar2inc/i01ar2016.i 04 i-combo}.

      APPLY "LEAVE" TO v-cdn-tip-comprov-afip IN FRAME {&FRAME-NAME}.
      APPLY "LEAVE" TO v-cdn-aduana           IN FRAME {&FRAME-NAME}.
      APPLY "LEAVE" TO v-cod-destinac         IN FRAME {&FRAME-NAME}.
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
 
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

  IF  i-pais-impto-usuario = 2 /* Argentina */ THEN DO:
      IF  NOT VALID-HANDLE(h-boar2033) THEN
          RUN local/arg/boar2033.p PERSISTENT SET h-boar2033.
    
      ASSIGN c-lista = ""
             c-lista = {local/arg/ar2inc/i01ar2016.i 03}.
    
      RUN utp/ut-lstit.p (INPUT-OUTPUT c-lista).
      ASSIGN cb-idi-operac-import:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = c-lista.
  END.

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
  {src/adm/template/snd-list.i "docum-est"}

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

