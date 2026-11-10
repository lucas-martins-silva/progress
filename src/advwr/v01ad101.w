&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mguni            PROGRESS
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
{include/i-prgvrs.i V01AD101 2.00.00.048 } /*** "010048" 20/04/2026 16:46:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad101 MUT}
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
&GLOBAL-DEFINE PAIS_MEXICO 4

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE BUFFER b-empresa FOR empresa.

DEFINE NEW GLOBAL SHARED VAR gr-empresa AS ROWID NO-UNDO.

DEFINE VARIABLE c-formato AS CHARACTER NO-UNDO.
DEFINE VARIABLE hFluig    AS HANDLE    NO-UNDO.

{utp/ut-glob.i}
{include/i_dbvers.i}

/*************Multiplanta********************/
DEFINE VARIABLE i-tipo-movto AS INTEGER NO-UNDO.

{cdp/cd7300.i1}

{mcinc/mcapi280.i}
{cdp/cdcfgfin.i}

DEFINE TEMP-TABLE tt-dados-env-SMC   NO-UNDO LIKE tt-dados-env.
DEFINE TEMP-TABLE tt-replica-msg-SMC NO-UNDO LIKE tt-replica-msg.
DEFINE TEMP-TABLE tt-control-env-SMC NO-UNDO LIKE tt-control-env.
DEFINE TEMP-TABLE tt-integracao-SMC  NO-UNDO LIKE tt-integracao. 
/************Fim*****************************/

/***********Frotas***********************/
{cdp/cd0666.i} /** Definiá∆o da Temp-Table de tt-erro **/
{cdp/cd9043.i} /** Definiá∆o da Temp-Table RowErrors **/
/****************Fim frotas****************/

/* MINifLEXIBILIZAÄ∂O */
{cdp/cdcfgfin.i}

/* Definiá∆o da variavel l-call-ut-integration e verificaá∆o de bancos conectados */
{utp/ut-integration-database.i}

/*** MODULO RAC ********************************************************/
{btb/btb008za.i0}

DEF VAR c-endereco-aux LIKE emitente.endereco NO-UNDO.
DEF VAR c-rua          AS CHAR                NO-UNDO.
DEF VAR c-nro          AS CHAR                NO-UNDO.
DEF VAR c-comp         AS CHAR                NO-UNDO.
DEF VAR c-help         AS CHAR                NO-UNDO.
DEF VAR h-cdapi704     AS HANDLE              NO-UNDO.
DEF VAR h-handle       AS HANDLE              NO-UNDO.
DEF VAR h-bopy2001     AS HANDLE              NO-UNDO.

/*VARIµVEIS LOCALIZAÄ«O EQUADOR*/
DEF VAR h-boec011      AS HANDLE              NO-UNDO.
DEF VAR i-tipo-regime  AS INT                 NO-UNDO.
DEF VAR i-cdn-doc      AS INT FORMAT ">>9"    NO-UNDO.
DEF VAR c-nro-doc      AS CHAR FORMAT "x(13)" NO-UNDO.
DEF VAR l-log-obg-cont AS LOG                 NO-UNDO.
DEF VAR v-cod-resol    AS CHAR                NO-UNDO.
DEF VAR v-cod-emit-sri AS INT                 NO-UNDO.

/*FIM - VARIµVEIS LOCALIZAÄ«O EQUADOR*/

DEFINE TEMP-TABLE RowErrorsEAI NO-UNDO
    FIELD ErrorSequence    AS INTEGER
    FIELD ErrorNumber      AS INTEGER
    FIELD ErrorDescription AS CHARACTER
    FIELD ErrorParameters  AS CHARACTER
    FIELD ErrorType        AS CHARACTER
    FIELD ErrorHelp        AS CHARACTER
    FIELD ErrorSubType     AS CHARACTER.

DEFINE VARIABLE hShowMsg              AS HANDLE    NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES empresa
&Scoped-define FIRST-EXTERNAL-TABLE empresa


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR empresa.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS empresa.nome empresa.razao-social ~
empresa.cidade empresa.cep empresa.uf empresa.pais empresa.telefone[1] ~
empresa.telefone[2] empresa.cgc empresa.log-2 empresa.inscr-estad ~
empresa.e-mail empresa.home-page 
&Scoped-define ENABLED-TABLES empresa
&Scoped-define FIRST-ENABLED-TABLE empresa
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold c-endereco c-bairro ~
tg-log-obg-cont 
&Scoped-Define DISPLAYED-FIELDS empresa.ep-codigo empresa.nome ~
empresa.razao-social empresa.cidade empresa.cep empresa.uf empresa.pais ~
empresa.telefone[1] empresa.telefone[2] empresa.cgc empresa.log-2 ~
empresa.inscr-estad empresa.e-mail empresa.home-page 
&Scoped-define DISPLAYED-TABLES empresa
&Scoped-define FIRST-DISPLAYED-TABLE empresa
&Scoped-Define DISPLAYED-OBJECTS c-endereco c-bairro nome-estado ~
tg-log-obg-cont fi-codigo-immex 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS empresa.ep-codigo 
&Scoped-define ADM-MODIFY-FIELDS empresa.nome empresa.razao-social ~
empresa.cidade empresa.cep empresa.uf empresa.cgc empresa.inscr-estad 

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
DEFINE VARIABLE c-bairro AS CHARACTER FORMAT "X(60)":U 
     LABEL "Bairro" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-resol AS CHARACTER FORMAT "X(150)":U 
     LABEL "Resol Grande Contribuinte" 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-endereco AS CHARACTER FORMAT "X(60)":U 
     LABEL "Endereáo" 
     VIEW-AS FILL-IN 
     SIZE 58 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit-sri AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-codigo-immex AS CHARACTER FORMAT "X(30)":U 
     LABEL "C¢digo IMMEX" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE i-cdn-emitente-sri AS INTEGER FORMAT ">>>>>>>>9":U INITIAL ? 
     LABEL "Fornecedor SRI" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE nome-estado AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 42 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 15.75.

DEFINE VARIABLE tg-log-obg-cont AS LOGICAL INITIAL no 
     LABEL "Contabilidade Obrigat¢ria" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     empresa.ep-codigo AT ROW 1.17 COL 25.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     empresa.nome AT ROW 2.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     empresa.razao-social AT ROW 3.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     c-endereco AT ROW 4.67 COL 25 COLON-ALIGNED
     c-bairro AT ROW 5.67 COL 25 COLON-ALIGNED
     empresa.cidade AT ROW 6.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 26.43 BY .88
     empresa.cep AT ROW 7.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.14 BY .88
     empresa.uf AT ROW 8.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.43 BY .88
     nome-estado AT ROW 8.67 COL 34.14 COLON-ALIGNED NO-LABEL
     empresa.pais AT ROW 9.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     empresa.telefone[1] AT ROW 10.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.72 BY .88
     empresa.telefone[2] AT ROW 10.67 COL 58.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.72 BY .88
     empresa.cgc AT ROW 11.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     empresa.log-2 AT ROW 11.67 COL 50.14
          LABEL "Agente Retená∆o de Iva"
          VIEW-AS TOGGLE-BOX
          SIZE 27 BY .83
     empresa.inscr-estad AT ROW 12.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     tg-log-obg-cont AT ROW 12.75 COL 50.14 WIDGET-ID 2
     empresa.e-mail AT ROW 13.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 43 BY .88
     empresa.home-page AT ROW 14.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 43 BY .88
     fi-codigo-immex AT ROW 15.67 COL 25 COLON-ALIGNED WIDGET-ID 10
     i-cdn-emitente-sri AT ROW 15.67 COL 25 COLON-ALIGNED WIDGET-ID 6
     c-nome-emit-sri AT ROW 15.67 COL 40 COLON-ALIGNED NO-LABEL WIDGET-ID 8
     c-cod-resol AT ROW 16.67 COL 25 COLON-ALIGNED WIDGET-ID 4
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mguni.empresa
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
         HEIGHT             = 17.54
         WIDTH              = 88.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{utp/ut-glob.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}

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

/* SETTINGS FOR FILL-IN c-cod-resol IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN c-nome-emit-sri IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-nome-emit-sri:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN empresa.cep IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN empresa.cgc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN empresa.cidade IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN empresa.ep-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-codigo-immex IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-codigo-immex:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN i-cdn-emitente-sri IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN empresa.inscr-estad IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR TOGGLE-BOX empresa.log-2 IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN empresa.nome IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN nome-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN empresa.razao-social IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN empresa.uf IN FRAME f-main
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

&Scoped-define SELF-NAME empresa.cep
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.cep V-table-Win
ON LEAVE OF empresa.cep IN FRAME f-main /* CEP */
DO:
  /* FORMATO */  
  ASSIGN c-formato = INPUT FRAME {&FRAME-NAME} empresa.cep no-error.
  IF  ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
      ASSIGN empresa.cep:format IN FRAME {&FRAME-NAME} = "x(19)".
  END.    
  /*else
 *       assign empresa.cep:format in frame {&frame-name} = param-global.formato-cep.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME empresa.cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.cgc V-table-Win
ON ENTRY OF empresa.cgc IN FRAME f-main /* CGCMF */
DO:
  ASSIGN empresa.cgc:format IN FRAME {&frame-name} = param-global.formato-id-federal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.cgc V-table-Win
ON LEAVE OF empresa.cgc IN FRAME f-main /* CGCMF */
DO:
  /* FORMATO */  
  ASSIGN c-formato = INPUT FRAME {&FRAME-NAME} empresa.cgc no-error.
  IF  ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
      ASSIGN empresa.cgc:format IN FRAME {&FRAME-NAME} = "x(19)".
  END.    
  ELSE
      ASSIGN empresa.cgc:format IN FRAME {&frame-name} = param-global.formato-id-federal.
      
  IF i-pais-impto-usuario = 1 THEN
     ASSIGN empresa.cgc:SCREEN-VALUE = CAPS(empresa.cgc:SCREEN-VALUE).
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cdn-emitente-sri
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-emitente-sri V-table-Win
ON F5 OF i-cdn-emitente-sri IN FRAME f-main /* Fornecedor SRI */
DO:
  {include/zoomvar.i &prog-zoom="adzoom/z07ad098.w"
                     &campo=i-cdn-emitente-sri
                     &campozoom=cod-emitente
                     &FRAME=f-main
                     &campo2=c-nome-emit-sri
                     &campozoom2=nome-emit
                     &FRAME=f-main}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-emitente-sri V-table-Win
ON LEAVE OF i-cdn-emitente-sri IN FRAME f-main /* Fornecedor SRI */
DO:
   FIND FIRST emitente
        WHERE emitente.cod-emitente   = INPUT FRAME {&frame-name} i-cdn-emitente-sri
        NO-LOCK NO-ERROR.
   IF AVAIL emitente THEN 
      ASSIGN c-nome-emit-sri:screen-value IN FRAME {&frame-name} = emitente.nome-emit.
   ELSE    
      ASSIGN c-nome-emit-sri:screen-value IN FRAME {&frame-name} = ?. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-emitente-sri V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cdn-emitente-sri IN FRAME f-main /* Fornecedor SRI */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME empresa.inscr-estad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.inscr-estad V-table-Win
ON LEAVE OF empresa.inscr-estad IN FRAME f-main /* Inscriá∆o Estadual */
DO:
  /* FORMATO */  
  ASSIGN c-formato = INPUT FRAME {&frame-name} empresa.inscr-estad no-error.
  IF  ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
      ASSIGN empresa.inscr-estad:format IN FRAME {&frame-name} = "x(19)".
  END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME empresa.pais
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.pais V-table-Win
ON F5 OF empresa.pais IN FRAME f-main /* Pa°s */
DO:
   ASSIGN l-implanta = YES.
   {include/zoomvar.i &prog-zoom=adzoom/z01ad276.w
                      &campo=empresa.pais
                      &campozoom=nome-pais}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.pais V-table-Win
ON MOUSE-SELECT-DBLCLICK OF empresa.pais IN FRAME f-main /* Pa°s */
DO:
    APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME empresa.uf
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.uf V-table-Win
ON F5 OF empresa.uf IN FRAME f-main /* UF */
DO:
    ASSIGN l-implanta = YES.
    {include/zoomvar.i &prog-zoom=unzoom/z01un007.w
                       &campo=empresa.uf
                       &campozoom=estado
                       &campo2=empresa.pais
                       &campozoom2=pais
                       &campo3=nome-estado
                       &campozoom3=no-estado}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.uf V-table-Win
ON LEAVE OF empresa.uf IN FRAME f-main /* UF */
DO:
   FIND FIRST unid-feder
        WHERE unid-feder.pais   = INPUT FRAME {&frame-name} empresa.pais
          AND unid-feder.estado = INPUT FRAME {&frame-name} empresa.uf NO-LOCK NO-ERROR.
   IF AVAIL unid-feder THEN 
      ASSIGN nome-estado:screen-value IN FRAME {&frame-name} = unid-feder.no-estado.
   ELSE    
      ASSIGN nome-estado:screen-value IN FRAME {&frame-name} = ?.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL empresa.uf V-table-Win
ON MOUSE-SELECT-DBLCLICK OF empresa.uf IN FRAME f-main /* UF */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  IF empresa.uf:load-mouse-pointer ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF empresa.pais:load-mouse-pointer ("image~\lupa.cur") IN FRAME {&frame-name} THEN.
  IF i-cdn-emitente-sri:load-mouse-pointer ("image~\lupa.cur") IN FRAME {&frame-name} THEN.

  IF SEARCH("fluig/fluigAPI.p") <> ? OR SEARCH("fluig/fluigAPI.r") <> ? THEN DO:
    RUN fluig/fluigAPI.p PERSISTENT SET hFluig.
  END.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "empresa"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "empresa"}

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

  /* Code placed here will execute AFTER standard behavior.    */
  /*if  avail param-global then do:
 *       run utp/ut-limit.p (input "MIN",
 *                           input param-global.formato-cep).
 *       assign empresa.cep:screen-value in frame {&frame-name} = return-value.
 *       run utp/ut-limit.p (input "MIN",
 *                           input param-global.formato-id-federal).
 *       assign empresa.cgc:screen-value in frame {&frame-name} = return-value.
 *   end.*/
  
  IF i-pais-impto-usuario = 21 THEN DO:   /* Equador */
       ASSIGN empresa.cgc       :HIDDEN       IN FRAME {&FRAME-NAME} = YES
              tg-log-obg-cont   :CHECKED      IN FRAME {&FRAME-NAME} = NO
              c-cod-resol       :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
              c-cod-resol                                            = ""
              i-cdn-emitente-sri:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
              i-cdn-emitente-sri                                     = 0.
  END.
  ELSE ASSIGN tg-log-obg-cont   :HIDDEN    IN FRAME {&FRAME-NAME} = YES
              c-cod-resol       :HIDDEN    IN FRAME {&FRAME-NAME} = YES 
              i-cdn-emitente-sri:HIDDEN    IN FRAME {&FRAME-NAME} = YES .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE l-ok AS LOG NO-UNDO.

    DEF VAR c-endereco-bkp LIKE c-endereco NO-UNDO.
    DEF VAR c-bairro-bkp   LIKE c-bairro   NO-UNDO.    

  /* Code placed here will execute PRIOR to standard behavior. */
    IF CAN-FIND(FIRST pais WHERE 
                     pais.nome-pais = INPUT FRAME {&FRAME-NAME} empresa.pais AND
                     pais.int-2     <> 1) THEN DO:

      IF NOT VALID-HANDLE(h-cdapi704) THEN
         RUN cdp/cdapi704.p PERSISTENT SET h-cdapi704.

      RUN pi-trata-endereco IN h-cdapi704 (INPUT INPUT FRAME {&FRAME-NAME} c-endereco, OUTPUT c-rua, OUTPUT c-nro, OUTPUT c-comp).

      ASSIGN c-endereco-aux = c-rua +
                              IF c-nro <> "" AND c-comp <> "" THEN " " + c-nro + " " + c-comp
                                                              ELSE ""
             c-endereco-aux = c-endereco-aux +
                               IF c-nro <> "" AND c-comp = "" THEN " " + c-nro ELSE ""
             c-endereco-aux = c-endereco-aux +
                               IF c-nro = "" AND c-comp <> "" THEN " " + c-comp ELSE "".

       IF c-nro = "" THEN DO:

          ASSIGN c-help = "N∆o foi poss°vel identificar no endereáo informado os componentes Logradouro e N£mero do Endereáo. Veja abaixo exemplo de formatos v†lidos:" + CHR(13) + 
                           "AV. PRESIDENTE COSTA E SILVA, 1178 - SALA 5" + CHR(13) + 
                           "AV. GETÈLIO VARGAS 1178 TêRREO"              + CHR(13) + 
                           "MARGINAL DA VIA ANCHIETA, KM 23"             + CHR(13) + 
                           "RUA MARECHAL DEODORO NR. 251"                + CHR(13) + 
                           "RUA VISCONDE DE MAUA N.1890 ED. SENTRA"      + CHR(13) + 
                           "AV ANTONIO DE CARVALHO 2600/3108"            + CHR(13) + 
                           "AV. TEODOMIRO DA FONSECA, 2173 BL1"          + CHR(13) + 
                           "RODOVIA BR 101 - KM29 - IGARASSU"            + CHR(13) + 
                           "RUA XV DE NOVEMBRO AP. 121 Nr 415"           + CHR(13) + 
                           "AV. BANDEIRA GOMES S/N - ED.MEDSERV"         + CHR(13) + 
                           "RUA 1650, NR 900, BLOCO 2".

          IF CAN-FIND(FIRST pais WHERE 
                            pais.nome-pais = INPUT FRAME {&FRAME-NAME} empresa.pais AND
                            pais.int-2     = 2) THEN DO: /* Advertencia */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Formato_do_endereáo_da_empresa_desconhecido._Deseja_continuar?" *}
              RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT  27100,
                                INPUT RETURN-VALUE + "~~" + c-help).

               IF RETURN-VALUE = "NO":U THEN DO:
                 APPLY "ENTRY" TO c-endereco IN FRAME f-main.
                 RETURN 'adm-error':U.
              END.
          END.
    
          IF CAN-FIND(FIRST pais WHERE 
                            pais.nome-pais = INPUT FRAME {&FRAME-NAME} empresa.pais AND
                            pais.int-2     = 3) THEN DO: /* Com Bloqueio */
              /* Inicio -- Projeto Internacional */
              {utp/ut-liter.i "Formato_do_endereáo_da_empresa_fiscal_inv†lido" *}
              RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT  17006,
                                INPUT RETURN-VALUE + "." + "~~" + c-help).
              APPLY "ENTRY" TO c-endereco IN FRAME f-main.
              RETURN 'adm-error':U.
          END.
       END.

  END.

  IF i-pais-impto-usuario = 9 /*Paraguai*/ THEN DO:
      RUN local/pry/pry0002.p (INPUT empresa.cgc:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               OUTPUT l-ok).

      IF l-ok = NO THEN DO:
        {utp/ut-liter.i "RUC" *}
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 158,
                           INPUT TRIM(RETURN-VALUE)).
        APPLY "ENTRY":U TO empresa.cgc IN FRAME {&FRAME-NAME}.
        RETURN 'adm-error':U.
      END.

      IF VALID-HANDLE(h-bopy2001) THEN DO:
          RUN pi-atualiza-campos IN h-bopy2001 (INPUT INPUT FRAME {&FRAME-NAME} empresa.ep-codigo,
                                                INPUT INPUT FRAME {&FRAME-NAME} empresa.cgc).

          IF RETURN-VALUE <> "OK":U THEN
              RETURN 'adm-error':U.
      END.
  END.

    ASSIGN c-endereco-bkp = INPUT FRAME {&frame-name} c-endereco 
           c-bairro-bkp   = INPUT FRAME {&frame-name} c-bairro.
           
   /*Localizaá∆o Equador*/
  IF i-pais-impto-usuario = 21 THEN DO:
      IF CAN-FIND(FIRST emitente
                      WHERE emitente.cod-emitente   = INPUT FRAME {&frame-name} i-cdn-emitente-sri
                      AND   emitente.identific      = 1)     THEN
      DO:
                  
                  run utp/ut-msgs.p (input "show",
                                     input 5477,
                                     input INPUT FRAME {&frame-name} i-cdn-emitente-sri)).
                  return "adm-error":U.
      END.
      ELSE
      IF NOT CAN-FIND(FIRST emitente
                      WHERE emitente.cod-emitente   = INPUT FRAME {&frame-name} i-cdn-emitente-sri
                      AND   emitente.identific      > 1)     AND
         (INPUT FRAME {&frame-name} i-cdn-emitente-sri <> ?  AND
          INPUT FRAME {&frame-name} i-cdn-emitente-sri <> 0) THEN
      DO:
                  
                  run utp/ut-msgs.p (input "show",
                                     input 91,
                                     input INPUT FRAME {&frame-name} i-cdn-emitente-sri)).
                  return "adm-error":U.
      END.
      
      RUN pi-retorna-valores-localiz IN h-handle (OUTPUT i-tipo-regime,
                                                  OUTPUT i-cdn-doc,
                                                  OUTPUT c-nro-doc,
                                                  OUTPUT h-boec011).

      IF c-nro-doc = "" THEN DO:
          IF AVAIL empresa THEN DO:
              IF NOT VALID-HANDLE(h-boec011) THEN
                  RUN local/ecu/ec2bo/boec011.p PERSISTENT SET h-boec011.
              
              RUN openQueryStatic IN h-boec011 (INPUT "Main":U).
              RUN goToKey IN h-boec011 (INPUT empresa.ep-codigo).
              
              IF RETURN-VALUE = "NOK" THEN DO:
                  {utp/ut-liter.i Dados_Localizaá∆o * }
                  run utp/ut-msgs.p (input "show",
                                     input 265,
                                     input RETURN-VALUE).
                  return "adm-error":U.
              END.
              ELSE DO:
                  RUN getIntField IN h-boec011 (INPUT "idi-regim-sri",
                                                OUTPUT i-tipo-regime).

                  RUN getIntField IN h-boec011 (INPUT "cdn-docto",
                                                OUTPUT i-cdn-doc).

                  RUN getCharField IN h-boec011 (INPUT "cod-docto",
                                                 OUTPUT c-nro-doc).
              END.
          END.
          ELSE DO:
              {utp/ut-liter.i Dados_Localizaá∆o * }
              run utp/ut-msgs.p (input "show",
                                 input 265,
                                 input RETURN-VALUE).
              return "adm-error":U.
          END.
      END.
      ELSE
          ASSIGN empresa.cgc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-nro-doc.

      ASSIGN l-log-obg-cont = tg-log-obg-cont:CHECKED IN FRAME {&FRAME-NAME}
             v-cod-resol    = INPUT FRAME {&frame-name} c-cod-resol.
      
  END.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  /*Localizaá∆o Equador*/
  IF i-pais-impto-usuario = 21 THEN DO:      
      IF VALID-HANDLE (h-boec011) 
          AND c-nro-doc <> "" THEN DO:
          
          ASSIGN v-cod-emit-sri = INPUT FRAME {&frame-name} i-cdn-emitente-sri.
          
          RUN pi-cria-dados-localiz IN h-boec011 (INPUT empresa.ep-codigo,
                                                  INPUT i-tipo-regime,
                                                  INPUT i-cdn-doc,
                                                  INPUT c-nro-doc,
                                                  INPUT l-log-obg-cont,
                                                  INPUT v-cod-resol,
                                                  INPUT v-cod-emit-sri).                                                  
                                                  
          IF RETURN-VALUE = "NOK":U THEN
              RETURN "adm-error":U.
          ELSE DO:
              ASSIGN empresa.cgc = c-nro-doc.
    
              RUN pi-limpa-dados-localiz IN h-handle.
          END.
      END.
  END.
  
    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN DO:
        IF AVAILABLE(empresa) THEN DO:        
            FIND FIRST empres-internac WHERE empres-internac.cod-empresa = empresa.ep-codigo EXCLUSIVE-LOCK NO-ERROR.
            IF NOT AVAILABLE(empres-internac) THEN DO:
                CREATE empres-internac.
                ASSIGN empres-internac.cod-empresa = empresa.ep-codigo.            
            END.                    
                        
            ASSIGN empres-internac.cod-auxiliar = fi-codigo-immex:INPUT-VALUE IN FRAME {&FRAME-NAME}.
            RELEASE empres-internac.
        END.
    END.  

  /*****[ Geraá∆o de Transaá∆o Multiplanta Especifica do SMC ]******/
    FOR EACH tt-smc-empresa:
        DELETE tt-smc-empresa.
    END.
    ASSIGN  c-transacao = "SMC021".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    ASSIGN  i-tipo-movto = IF empresa.ep-codigo:sensitive IN FRAME {&frame-name}
                           THEN 1 ELSE 2.
    RUN pi-cria-tt-dados-smc (i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
  /***[Fim da Geraá∆o de Transaá∆o Multiplanta Especifica do SMC]***/

  /* Code placed here will execute AFTER standard behavior.    */

    IF  AVAIL  empresa THEN
        ASSIGN empresa.endereco = c-endereco-bkp
               empresa.bairro   = c-bairro-bkp
               c-endereco:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-endereco-bkp 
               c-bairro:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = c-bairro-bkp.

    /* Sincroniza novo registro com o Identity */
    IF VALID-HANDLE(hFluig) THEN DO:    
        DEFINE VARIABLE lOK    AS LOGICAL NO-UNDO.
        RUN syncResource IN hFluig( INPUT 2, INPUT empresa.ep-codigo, INPUT "upsert", OUTPUT lOk ).        
    END.

    IF l-call-ut-integration THEN
       RUN send-eai IN THIS-PROCEDURE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cCod-empresa AS CHARACTER NO-UNDO.
    DEFINE VARIABLE h-bomx2015   AS HANDLE    NO-UNDO.

    ASSIGN cCod-empresa = empresa.ep-codigo.

  /* Code placed here will execute PRIOR to standard behavior. */

  /*****[ Geraá∆o de Transaá∆o Multiplanta Especifica do SMC ]******/
    FOR EACH tt-smc-empresa:
        DELETE tt-smc-empresa.
    END.
    ASSIGN  c-transacao = "SMC021".
    {cdp/cd7300.i5 "001" c-transacao "-SMC"}
    ASSIGN  i-tipo-movto = 3.
    RUN pi-cria-tt-dados-smc (i-tipo-movto).
    {cdp/cd7300.i6 "001" c-transacao "-SMC"}
  /***[Fim da Geraá∆o de Transaá∆o Multiplanta Especifica do SMC]***/
  /**** Validaá‰es de eliminaá∆o ***********/
  RUN pi-valida-eliminacao.
      IF  RETURN-VALUE <> "OK":U THEN
          RETURN "ADM-ERROR".

  IF  i-pais-impto-usuario = 4 /* Mexico */ THEN DO:
        RUN local/mex/bomx2015.p PERSISTENT SET h-bomx2015.
        RUN openQueryStatic IN h-bomx2015 (INPUT "Main":U).
        RUN goToKey IN h-bomx2015 (INPUT empresa.ep-codigo).
        IF  RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN h-bomx2015.
        RUN destroy IN h-bomx2015.
  END.

  IF  i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:        
        RUN goToKey IN h-bopy2001 (INPUT empresa.ep-codigo).
        IF  RETURN-VALUE = "OK":U THEN
            RUN deleteRecord IN h-bopy2001.
  END.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  /* Sincroniza a eliminaá∆o da empresa com o Identity */
  IF VALID-HANDLE(hFluig) THEN DO:
      DEFINE VARIABLE lIntegrou AS LOGICAL NO-UNDO.
      DEFINE VARIABLE lOK       AS LOGICAL NO-UNDO.
      RUN resourceIntegrated IN hFluig( INPUT 2, INPUT cCod-empresa, OUTPUT lIntegrou ).
      IF lIntegrou THEN DO:
          RUN syncResource IN hFluig( INPUT 2, INPUT cCod-empresa, INPUT "delete", OUTPUT lOK ).
      END.          
  END.
  
  IF i-pais-impto-usuario = 21 THEN DO:

      IF NOT VALID-HANDLE(h-boec011) THEN DO:
          RUN local/ecu/ec2bo/boec011.p PERSISTENT SET h-boec011.
          RUN openQueryStatic IN h-boec011 (INPUT 'Main':U).
      END.           

      RUN goToKey IN h-boec011 (INPUT cCod-empresa).
      IF RETURN-VALUE = "OK":U THEN DO:
          RUN deleteRecord in h-boec011.
          IF RETURN-VALUE = "OK":U THEN
              RUN pi-limpa-dados-localiz IN h-handle.
      END.
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
    IF VALID-HANDLE(h-cdapi704) THEN DO:
          DELETE PROCEDURE h-cdapi704.
          ASSIGN h-cdapi704 = ?.
    END.

    IF VALID-HANDLE(hFluig) THEN DO:
        DELETE PROCEDURE hFluig.
        ASSIGN hFluig = ?.
    END.

    IF i-pais-impto-usuario = 9 /*Paraguai*/ THEN
        IF VALID-HANDLE(h-bopy2001) THEN
            RUN destroy IN h-bopy2001.

    IF i-pais-impto-usuario = 21 /*Equador*/ THEN
        IF VALID-HANDLE(h-boec011) THEN
            RUN destroy IN h-boec011.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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

  DISABLE c-endereco
          c-bairro  WITH FRAME {&FRAME-NAME}.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
  &endif
  
  IF i-pais-impto-usuario = 21 THEN DO:
      run pi-habilita-localiz in h-handle (INPUT YES).
      RUN pi-limpa-dados-localiz IN h-handle.
      ASSIGN tg-log-obg-cont:SENSITIVE IN FRAME {&FRAME-NAME}    = NO
             c-cod-resol:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
             i-cdn-emitente-sri:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  
  IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN
    DISABLE fi-codigo-immex WITH FRAME {&FRAME-NAME}.
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

    ASSIGN INPUT FRAME f-main fi-codigo-immex.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  FIND FIRST unid-feder
        WHERE unid-feder.pais   = INPUT FRAME {&frame-name} empresa.pais
          AND unid-feder.estado = INPUT FRAME {&frame-name} empresa.uf NO-LOCK NO-ERROR.
   IF AVAIL unid-feder THEN 
      ASSIGN nome-estado:screen-value IN FRAME {&frame-name} = unid-feder.no-estado.
   ELSE    
      ASSIGN nome-estado:screen-value IN FRAME {&frame-name} = ?.

    IF  AVAIL empresa THEN
        ASSIGN c-endereco:screen-value IN FRAME {&frame-name} = empresa.endereco
               c-bairro  :screen-value IN FRAME {&frame-name} = empresa.bairro
               tg-log-obg-cont = NO
               c-cod-resol     = ''.

    IF i-pais-impto-usuario = 21 /* Equador */ THEN DO:
        ASSIGN empresa.cgc:HIDDEN IN FRAME {&FRAME-NAME} = YES.
        
        IF AVAIL empresa THEN DO:
            ASSIGN v-cod-emit-sri = int(i-cdn-emitente-sri:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
            
            IF NOT VALID-HANDLE(h-boec011) THEN
                RUN local/ecu/ec2bo/boec011.p PERSISTENT SET h-boec011.
                               
            RUN openQueryStatic IN h-boec011 (INPUT "Main":U).
            RUN goToKey IN h-boec011 (INPUT empresa.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}).
            
            IF RETURN-VALUE = "OK" THEN
            DO:
                
                RUN getlogField IN h-boec011 (INPUT "log-ctb-obrig":U,
                                              OUTPUT tg-log-obg-cont).           
                RUN getCharField IN h-boec011 (INPUT "cod-resol":U,
                                              OUTPUT c-cod-resol).

                RUN getIntField IN h-boec011 (INPUT "cdn-emitente-sri":U,
                                              OUTPUT v-cod-emit-sri).    
              
                           
            END.     
            ELSE
            IF c-cod-resol:SENSITIVE IN FRAME {&FRAME-NAME} = YES THEN
            DO:
           
               ASSIGN tg-log-obg-cont    = tg-log-obg-cont:CHECKED  IN FRAME {&FRAME-NAME}
                      c-cod-resol        = c-cod-resol:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                      v-cod-emit-sri = int(i-cdn-emitente-sri:SCREEN-VALUE IN FRAME {&FRAME-NAME}). 
            END. 
            ELSE
              ASSIGN tg-log-obg-cont = NO
                     c-cod-resol    = '' 
                     v-cod-emit-sri = 0. 
             
            ASSIGN tg-log-obg-cont:CHECKED  IN FRAME {&FRAME-NAME}        = tg-log-obg-cont
                   c-cod-resol:SCREEN-VALUE IN FRAME {&FRAME-NAME}        = c-cod-resol
                   i-cdn-emitente-sri:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(v-cod-emit-sri).     

           FIND FIRST emitente
                WHERE emitente.cod-emitente   = v-cod-emit-sri
                NO-LOCK NO-ERROR.
           IF AVAIL emitente THEN 
              ASSIGN c-nome-emit-sri:screen-value IN FRAME {&frame-name} = emitente.nome-emit.
           ELSE    
              ASSIGN c-nome-emit-sri:screen-value IN FRAME {&frame-name} = ?.
         
        END.
    END.
    ELSE ASSIGN tg-log-obg-cont:HIDDEN IN FRAME {&FRAME-NAME} = YES.

    IF SELF:NAME <> "bt-sav" AND 
       i-pais-impto-usuario = {&PAIS_MEXICO} THEN DO:
        ASSIGN fi-codigo-immex:SCREEN-VALUE = "".
        
        FOR FIRST empres-internac WHERE empres-internac.cod-empresa = empresa.ep-codigo NO-LOCK:                
            ASSIGN fi-codigo-immex:SCREEN-VALUE = empres-internac.cod-auxiliar.
        END.            
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
  &if  defined(ADM-MODIFY-FIELDS) &then
      ENABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&frame-name}.
  &endif
  
    ENABLE c-endereco
           c-bairro  WITH FRAME {&FRAME-NAME}.

    IF VALID-HANDLE(hFluig) THEN DO:        
        DEFINE VARIABLE lIntegrou AS LOGICAL NO-UNDO.        
        RUN resourceIntegrated IN hFluig( INPUT 2, INPUT empresa.ep-codigo, OUTPUT lIntegrou ).
        IF lIntegrou THEN
            IF NOT ADM-NEW-RECORD THEN
            DISABLE empresa.cgc 
                    empresa.inscr-estad
                    empresa.uf
                    empresa.pais
                    WITH FRAME {&frame-name}.        
    END.           
     
    IF i-pais-impto-usuario = 21 THEN DO:
      run pi-habilita-localiz in h-handle (INPUT NO).
      ASSIGN empresa.cgc    :HIDDEN    IN FRAME {&FRAME-NAME}    = YES
             c-cod-resol    :SENSITIVE IN FRAME {&FRAME-NAME}    = YES
             tg-log-obg-cont:SENSITIVE IN FRAME {&FRAME-NAME}    = YES
             i-cdn-emitente-sri:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  END.
  ELSE ASSIGN tg-log-obg-cont:HIDDEN    IN FRAME {&FRAME-NAME}    = YES
              c-cod-resol    :SENSITIVE IN FRAME {&FRAME-NAME}    = NO 
              i-cdn-emitente-sri:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN
        ENABLE fi-codigo-immex WITH FRAME {&FRAME-NAME}.
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
  FIND FIRST param-global NO-LOCK NO-ERROR.
  IF  AVAIL param-global THEN DO:
      ASSIGN empresa.cep:format IN FRAME {&frame-name} = param-global.formato-cep
             empresa.cgc:format IN FRAME {&frame-name} = param-global.formato-id-federal
             empresa.cgc:label  IN FRAME {&FRAME-NAME} = param-global.label-cgc.
  END.

  DISABLE c-endereco
          c-bairro  WITH FRAME {&FRAME-NAME}.

  IF i-pais-impto-usuario = 9 /*Paraguai*/ THEN DO:
      RUN local/pry/bopy2001.p PERSIST SET h-bopy2001.

      RUN openQueryStatic IN h-bopy2001 (INPUT "Main":U) NO-ERROR.
  END.
   
  IF i-pais-impto-usuario = 21 THEN DO:
       ASSIGN empresa.cgc    :HIDDEN    IN FRAME {&FRAME-NAME} = YES
              c-cod-resol    :HIDDEN    IN FRAME {&FRAME-NAME} = NO
              c-cod-resol    :SENSITIVE IN FRAME {&FRAME-NAME} = NO
              tg-log-obg-cont:SENSITIVE IN FRAME {&FRAME-NAME} = NO
              tg-log-obg-cont:HIDDEN    IN FRAME {&FRAME-NAME} = NO 
              c-nome-emit-sri:HIDDEN    IN FRAME {&FRAME-NAME} = NO
              i-cdn-emitente-sri:HIDDEN    IN FRAME {&FRAME-NAME} = NO.
  END.
  ELSE ASSIGN tg-log-obg-cont:HIDDEN    IN FRAME {&FRAME-NAME} = YES
              c-cod-resol    :HIDDEN    IN FRAME {&FRAME-NAME} = YES
              c-cod-resol    :SENSITIVE IN FRAME {&FRAME-NAME} = NO 
              c-nome-emit-sri:HIDDEN    IN FRAME {&FRAME-NAME} = YES
              i-cdn-emitente-sri:HIDDEN    IN FRAME {&FRAME-NAME} = YES
              i-cdn-emitente-sri:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
              
    IF i-pais-impto-usuario = {&PAIS_MEXICO} THEN DO:
        ASSIGN fi-codigo-immex:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
    END.
    
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
  IF  AVAIL empresa THEN
      ASSIGN gr-empresa = ROWID(empresa).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  {include/i-vldfrm.i}

  /* Code placed here will execute PRIOR to standard behavior. */
  IF  NOT FRAME {&frame-name}:validate() THEN
      RETURN 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */
  FIND FIRST empresa NO-LOCK
      WHERE empresa.ep-codigo = INPUT FRAME {&frame-name} empresa.ep-codigo NO-ERROR.

  IF  empresa.ep-codigo:sensitive THEN DO:
      IF AVAIL empresa THEN DO:
        {utp/ut-table.i mguni empresa 1 }
         RUN utp/ut-msgs.p (INPUT "show",
                            INPUT 1,
                            INPUT RETURN-VALUE).
          APPLY "entry" TO empresa.ep-codigo.
          RETURN 'ADM-ERROR'.
      END.
  END.

  &IF "{&mguni_version}" >= "2.07A" &THEN
  IF INPUT FRAME {&frame-name} empresa.ep-codigo = "" THEN DO:
  &ELSE
  IF INPUT FRAME {&frame-name} empresa.ep-codigo = 0 THEN DO:
  &ENDIF
     {utp/ut-table.i mguni empresa 1 }
      RUN utp/ut-msgs.p (INPUT "show",
                         INPUT 1491,
                         INPUT RETURN-VALUE).
      APPLY "entry" TO empresa.ep-codigo.
      RETURN 'ADM-ERROR'.
      END.

  /* Ponha aqui as demais validaá‰es */
  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /*--- Valida a existencia da empresa com o mesmo nome ---*/

IF NOT AVAIL empresa THEN DO :
 FIND FIRST b-empresa NO-LOCK
      WHERE b-empresa.nome = INPUT FRAME {&frame-name} empresa.nome NO-ERROR.
  IF  AVAIL b-empresa
   THEN DO:
{utp/ut-field.i mguni empresa nome 1}
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 266,
                          INPUT RETURN-VALUE).
       APPLY "entry" TO empresa.nome.                           
       RETURN 'ADM-ERROR'.
  END.
END.
ELSE DO :
 FIND FIRST b-empresa NO-LOCK
      WHERE b-empresa.nome = INPUT FRAME {&frame-name} empresa.nome 
      AND ROWID(b-empresa) <> rowid(empresa) NO-ERROR.
  IF  AVAIL b-empresa
   THEN DO:
       {utp/ut-field.i mguni empresa nome 1}
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 266,
                          INPUT RETURN-VALUE).
       APPLY "entry" TO empresa.nome.                           
       RETURN 'ADM-ERROR'.
  END.
END. 

  /*find first b-empresa no-lock
 *       where b-empresa.nome = input frame {&frame-name} empresa.nome no-error.
 *   if avail b-empresa then do:
 *       {utp/ut-table.i mguni empresa 1}
 *         run utp/ut-msgs.p (input "show",
 *                          input 266,
 *                          input return-value).
 *       apply "entry" to empresa.nome.                           
 *       return 'ADM-ERROR'.
 *   end.*/


 /*--- Valida se nome esta em branco ---*/  
 IF INPUT FRAME {&frame-name} empresa.nome = "" THEN DO:  
    {utp/ut-field.i mguni empresa nome 1 } 
    RUN utp/ut-msgs.p (INPUT "show",
                       INPUT 164,
                       INPUT RETURN-VALUE).
    APPLY "entry" TO empresa.nome.                   
    RETURN 'ADM-ERROR'.
 END.


  /* Valida UF */ 
  IF INPUT FRAME {&frame-name} empresa.uf:sensitive then do:
     FIND FIRST unid-feder
        WHERE unid-feder.pais   = INPUT FRAME {&frame-name} empresa.pais
          AND unid-feder.estado = INPUT FRAME {&frame-name} empresa.uf NO-LOCK NO-ERROR.
     IF NOT AVAIL unid-feder THEN DO:
        {utp/ut-table.i mguni unid-feder 1}
        RUN utp/ut-msgs.p(INPUT "show",
                         INPUT 4259,
                         INPUT RETURN-VALUE).

        APPLY 'entry' TO empresa.uf IN FRAME {&frame-name}.
        RETURN 'ADM-ERROR':U. 
     END.
     ELSE ASSIGN nome-estado:screen-value IN FRAME {&frame-name} = unid-feder.no-estado.
  END.

  /*--- Valida o Pa°s ---*/
  FIND FIRST pais NO-LOCK
       WHERE pais.nome-pais = INPUT FRAME {&frame-name} empresa.pais NO-ERROR.
   IF  NOT AVAIL pais THEN DO:
      {utp/ut-table.i mguni pais 1 }
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 964,
                          INPUT RETURN-VALUE).
       APPLY "entry" TO empresa.pais.
       RETURN 'ADM-ERROR'.
   END.


   /*--- Valida Formato -----*/
    /* CGC */
    ASSIGN empresa.cgc:format IN FRAME {&FRAME-NAME} = "x(19)".

    /*Para o Pa°s Equador n∆o Ç necess†rio fazer validaá∆o de formato, 
    isso Ç feito no programa localizado*/
    IF i-pais-impto-usuario <> 21 THEN DO:
        if  input frame {&FRAME-NAME} empresa.cgc <> "" then
            assign empresa.cgc:format in frame {&frame-name} = param-global.formato-id-federal.
    
        assign c-formato = input frame {&FRAME-NAME} empresa.cgc no-error.
        if  error-status:get-number(1) <> 0 then do:
            run utp/ut-msgs.p (input "show",
                               input 8706,
                               input param-global.label-cgc).
            apply 'entry':U to empresa.cgc in frame {&FRAME-NAME}.
            return 'adm-error'.
        end.
    END.
    
    /*Validaá∆o CNPJ - D°gito Verificador*/
    IF INPUT FRAME {&frame-name} empresa.pais = "Brasil" then do
        on error undo, return 'adm-error':
        run cdp/cd6666.p (input input frame {&FRAME-NAME} empresa.cgc, input 2).

        if return-value = 'NOK' then do:
           {include/i-vldprg.i}
           apply 'entry' to empresa.cgc in frame {&frame-name}.
           return "adm-error":U.
        end.
    end.
    
    /* Inscriá∆o Estadual */ 
    ASSIGN empresa.inscr-estad:format IN FRAME {&frame-name} = "x(19)". 

    ASSIGN c-formato = INPUT FRAME {&frame-name} empresa.inscr-estad no-error.
    IF  ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 9,
                           INPUT " ").
        APPLY 'entry':U TO empresa.inscr-estad IN FRAME {&frame-name}.
        RETURN 'adm-error'.
    END.

   /* CEP */
    ASSIGN empresa.cep:format IN FRAME {&FRAME-NAME} = "x(19)".

    IF  INPUT FRAME {&FRAME-NAME} empresa.cep <> "" THEN
        ASSIGN empresa.cep:format IN FRAME {&frame-name} = param-global.formato-cep.

    ASSIGN c-formato = INPUT FRAME {&FRAME-NAME} empresa.cep no-error.
    IF  ERROR-STATUS:GET-NUMBER(1) <> 0 THEN DO:
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 9,
                           INPUT " ").
        APPLY 'entry':U TO empresa.cep IN FRAME {&FRAME-NAME}.
        RETURN 'adm-error'.
    END.

   IF RETURN-VALUE = "adm-error":U THEN
      RETURN "adm-error":U.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF i-pais-impto-usuario = 21 THEN
      ASSIGN empresa.cgc:HIDDEN   IN FRAME {&FRAME-NAME} = YES.
   ELSE ASSIGN tg-log-obg-cont:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAMETER i-tipo-movto AS INTEGER.

    IF  param-global.modulo-mp
    AND tt-replica-msg-SMC.log-replica-msg  = YES
    THEN DO:
        CREATE  tt-smc-empresa.
        BUFFER-COPY empresa TO tt-smc-empresa.
        CREATE  tt-dados-env-SMC.
        ASSIGN  tt-dados-env-SMC.num-sequencia  = i-seq
                tt-dados-env-SMC.cod-tipo-reg   = 280
                tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
                tt-dados-env-SMC.identif-msg    = STRING(empresa.ep-codigo).
        RAW-TRANSFER tt-smc-empresa TO tt-dados-env-SMC.conteudo-msg.
        ASSIGN i-seq = i-seq + 1.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-handle-mg as handle no-undo.

    assign h-handle = p-handle-mg.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-empresa V-table-Win 
PROCEDURE pi-retorna-empresa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-ep-codigo LIKE empresa.ep-codigo NO-UNDO.

ASSIGN p-ep-codigo = empresa.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-uf V-table-Win 
PROCEDURE pi-retorna-uf :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def output param p-unid-feder like empresa.uf.

    assign p-unid-feder = input frame {&FRAME-NAME} empresa.uf.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-eliminacao V-table-Win 
PROCEDURE pi-valida-eliminacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*****[ LOCALIZAÄ«O EQUADOR ]**********************************************************************************/
IF i-pais-impto-usuario = 21 THEN DO:

    IF NOT VALID-HANDLE(h-boec011) THEN DO:
        RUN local/ecu/ec2bo/boec011.p PERSISTENT SET h-boec011.
        RUN openQueryStatic IN h-boec011 (INPUT 'Main':U).
    END.            

    RUN goToKey IN h-boec011 (INPUT INPUT FRAME {&FRAME-NAME} empresa.ep-codigo).

    IF RETURN-VALUE = "OK":U THEN DO:
        RUN emptyRowErrors IN h-boec011.
        RUN validateRecord IN h-boec011 (INPUT "DELETE":U).
        RUN getRowErrors   IN h-boec011 (OUTPUT TABLE RowErrors).
        
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            RETURN "ADM-ERROR":U.
        END.
    END.
END. 
/************************************************************************************************************/

{database/tgun/tdp/tdun004.i 'show'}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-eai V-table-Win 
PROCEDURE send-eai :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    DEFINE VARIABLE h-ut-integration AS HANDLE      NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.  
    RUN eai-integration IN h-ut-integration (INPUT "Company",              /* Nome da transaªío     */
                                                                                         INPUT ROWID(empresa),         /* Registro da transaá∆o */
                                                                                         INPUT 'CREATE',               /* Evento da transaá∆o   */
                                                                                         OUTPUT TABLE RowErrorsEAI).   /* Erros da transaá∆o    */

    IF VALID-HANDLE(h-ut-integration) THEN DO:
        DELETE PROCEDURE h-ut-integration.
        ASSIGN h-ut-integration = ?.
    END.

    IF CAN-FIND(FIRST RowErrorsEAI) THEN DO:
                FOR EACH RowErrorsEAI:
                        CREATE RowErrors.
                        BUFFER-COPY rowerrorseai TO RowErrors.
                END. 
                
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="Yes"}

                RETURN "ADM-ERROR":U.
        END.

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
  {src/adm/template/snd-list.i "empresa"}

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
  RUN pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

