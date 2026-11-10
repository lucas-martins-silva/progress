&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            ORACLE
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*:T *******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V06IN024 2.00.00.015 } /*** "010015" ***/

/* Chamada a include do gerenciador de licenáas. Necessario alterar os parametros */
/*                                                                                */
/* <programa>:  Informar qual o nome do programa.                                 */
/* <m¢dulo>:  Informar qual o m¢dulo a qual o programa pertence.                  */
/*                                                                                */
/* OBS: Para os smartobjects o parametro m¢dulo dever† ser MUT                    */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v06in024 MUT}
&ENDIF

/* Create an unnamed  pool to store all the widgets created 
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
DEFINE VARIABLE v-row-parent            AS ROWID                    NO-UNDO.
DEFINE VARIABLE c-hora-execucao-default AS CHARACTER INIT "000:00"  NO-UNDO.
DEFINE VARIABLE c-hra-execucao          AS CHARACTER                NO-UNDO.
DEFINE VARIABLE h-boin784               AS HANDLE                   NO-UNDO.
DEFINE VARIABLE l-log-integr-fluig-ant  AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE l-log-praz-conclus-ant  AS LOGICAL                  NO-UNDO.
DEFINE VARIABLE c-hra-execucao-ant      AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-horas                 AS CHARACTER                NO-UNDO.
DEFINE VARIABLE c-minutos               AS CHARACTER                NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES mla-param-aprov
&Scoped-define FIRST-EXTERNAL-TABLE mla-param-aprov


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mla-param-aprov.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mla-param-aprov.cdn-rej ~
mla-param-aprov.hra-execucao mla-param-aprov.log-integr-fluig ~
mla-param-aprov.log-praz-conclus mla-param-aprov.log-aprovac-altern-dat ~
mla-param-aprov.log-priorid-aprova-docto mla-param-aprov.log-cond-pagto ~
mla-param-aprov.log-ord-recbda mla-param-aprov.log-ord-confda 
&Scoped-define ENABLED-TABLES mla-param-aprov
&Scoped-define FIRST-ENABLED-TABLE mla-param-aprov
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-6 RECT-7 RECT-8 RECT-9 RECT-10 
&Scoped-Define DISPLAYED-FIELDS mla-param-aprov.cdn-rej ~
mla-param-aprov.hra-execucao mla-param-aprov.log-integr-fluig ~
mla-param-aprov.log-praz-conclus mla-param-aprov.log-aprovac-altern-dat ~
mla-param-aprov.log-priorid-aprova-docto mla-param-aprov.log-cond-pagto ~
mla-param-aprov.log-ord-recbda mla-param-aprov.log-ord-confda 
&Scoped-define DISPLAYED-TABLES mla-param-aprov
&Scoped-define FIRST-DISPLAYED-TABLE mla-param-aprov
&Scoped-Define DISPLAYED-OBJECTS l-limite-alternativo l-lotacao-principal ~
l-perm-aprov-principal l-perm-mestre-principal i-email-solicit-compr 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnFormataHora V-table-Win 
FUNCTION fnFormataHora RETURNS CHARACTER
  (c-valor AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.57 BY 5.75.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29.57 BY 3.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 12.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 5.75.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 1.5.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 50 BY 3.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33.57 BY 5.

DEFINE VARIABLE l-limite-alternativo AS LOGICAL INITIAL no 
     LABEL "Assume Limite do Principal" 
     VIEW-AS TOGGLE-BOX
     SIZE 28.86 BY .83 NO-UNDO.

DEFINE VARIABLE l-lotacao-principal AS LOGICAL INITIAL no 
     LABEL "Assume Lotaá∆o do Principal" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE l-perm-aprov-principal AS LOGICAL INITIAL no 
     LABEL "Assume Permiss‰es de Aprovaá∆o do Principal" 
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .83 NO-UNDO.

DEFINE VARIABLE l-perm-mestre-principal AS LOGICAL INITIAL no 
     LABEL "Assume Permiss‰es de mestre como Principal" 
     VIEW-AS TOGGLE-BOX
     SIZE 47 BY .83 NO-UNDO.

DEFINE VARIABLE i-email-solicit-compr AS integer
     VIEW-AS RADIO-SET vertical
     RADIO-BUTTONS 
"Enviar para todas as aprovaá‰es/n°veis", 1,
"Enviar somente na £ltima aprovaá∆o", 2
     SIZE 30 BY 2 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     l-limite-alternativo AT ROW 2.25 COL 4.86
     mla-param-aprov.log-aprovac-altern-dat AT ROW 3.25 COL 4.86
          LABEL "Alternativo por Data"
          VIEW-AS TOGGLE-BOX
          SIZE 21.86 BY .83
     l-lotacao-principal AT ROW 4.25 COL 4.86
     l-perm-aprov-principal AT ROW 5.25 COL 4.86
     l-perm-mestre-principal AT ROW 6.25 COL 4.86
     mla-param-aprov.log-priorid-aprova-docto AT ROW 7.83 COL 4.86
          LABEL "Prioridade Aprovaá∆o Docto"
          VIEW-AS TOGGLE-BOX
          SIZE 31 BY .83
     mla-param-aprov.log-integr-fluig AT ROW 9.13 COL 4.86
          LABEL "Integraá∆o Fluig"
          VIEW-AS TOGGLE-BOX
          SIZE 17.14 BY .83 TOOLTIP "Integraá∆o Fluig"
     mla-param-aprov.log-praz-conclus AT ROW 10.13 COL 4.86
          LABEL "Prazo Conclus∆o:"
          VIEW-AS TOGGLE-BOX
          SIZE 17 BY .83
     mla-param-aprov.hra-execucao AT ROW 10.13 COL 23 NO-LABEL FORMAT "999:99"
          VIEW-AS FILL-IN 
          SIZE 12 BY .88 TOOLTIP "Horas de conclus∆o"
     mla-param-aprov.cdn-rej AT ROW 11.13 COL 23 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     mla-param-aprov.log-cond-pagto AT ROW 2.25 COL 55.57
          LABEL "Somente Cond Pagto e Valor"
          VIEW-AS TOGGLE-BOX
          SIZE 28 BY .83 TOOLTIP "Somente gerar pendencia para doctos que tiverem alteraá∆o em valor e cond. pagt"
     mla-param-aprov.log-ord-recbda AT ROW 4.5 COL 58.29
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .83
     mla-param-aprov.log-ord-confda AT ROW 5.5 COL 58.29
          VIEW-AS TOGGLE-BOX
          SIZE 23.72 BY .83
     "Aprovador Alternativo" VIEW-AS TEXT
          SIZE 26 BY .67 AT ROW 1.25 COL 5
     "Exceá∆o Pendància Aprovaá∆o" VIEW-AS TEXT
          SIZE 29.72 BY .67 AT ROW 1.25 COL 55.57
     "N∆o Gerar Para Saldo Zerado" VIEW-AS TEXT
          SIZE 27.57 BY .67 AT ROW 3.5 COL 56.29
     "hora(s)" VIEW-AS TEXT
          SIZE 8 BY .67 AT ROW 10.13 COL 36.29
     "C¢digo Rejeiá∆o Padr∆o:" VIEW-AS TEXT
          SIZE 17 BY .67 AT ROW 11.13 COL 4.86
     "E-mails Solicitante da Compra" VIEW-AS TEXT
          SIZE 24 BY .67 AT ROW 7.25 COL 55.57
     i-email-solicit-compr AT ROW 9 COL 55.57 NO-LABEL
     RECT-1 AT ROW 1.5 COL 53.29
     RECT-2 AT ROW 3.75 COL 55.29
     RECT-6 AT ROW 1 COL 2
     RECT-7 AT ROW 1.5 COL 3
     RECT-8 AT ROW 7.5 COL 3
     RECT-9 AT ROW 9.5 COL 3
     RECT-10 AT ROW 7.5 COL 53.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgcad.mla-param-aprov
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
         HEIGHT             = 12.25
         WIDTH              = 88.
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

/* SETTINGS FOR FILL-IN mla-param-aprov.cdn-rej IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN mla-param-aprov.hra-execucao IN FRAME f-main
   ALIGN-L                                                              */
/* SETTINGS FOR TOGGLE-BOX l-limite-alternativo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-lotacao-principal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-perm-aprov-principal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-perm-mestre-principal IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-param-aprov.log-aprovac-altern-dat IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-param-aprov.log-cond-pagto IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-param-aprov.log-integr-fluig IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-param-aprov.log-praz-conclus IN FRAME f-main
   EXP-LABEL                                                            */
/* SETTINGS FOR TOGGLE-BOX mla-param-aprov.log-priorid-aprova-docto IN FRAME f-main
   EXP-LABEL                                                            */
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

&Scoped-define SELF-NAME l-limite-alternativo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-limite-alternativo V-table-Win
ON VALUE-CHANGED OF l-limite-alternativo IN FRAME f-main /* Assume Limite do Principal */
DO:
    ASSIGN l-limite-alternativo     = l-limite-alternativo:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-lotacao-principal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-lotacao-principal V-table-Win
ON VALUE-CHANGED OF l-lotacao-principal IN FRAME f-main /* Assume Lotaá∆o do Principal */
DO:
  ASSIGN l-lotacao-principal      = l-lotacao-principal:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-perm-aprov-principal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-perm-aprov-principal V-table-Win
ON VALUE-CHANGED OF l-perm-aprov-principal IN FRAME f-main /* Assume Permiss‰es de Aprovaá∆o do Principal */
DO:
  ASSIGN l-perm-aprov-principal   = l-perm-aprov-principal:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-perm-mestre-principal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-perm-mestre-principal V-table-Win
ON VALUE-CHANGED OF l-perm-mestre-principal IN FRAME f-main /* Assume Permiss‰es de mestre como Principal */
DO:
  ASSIGN l-perm-mestre-principal  = l-perm-mestre-principal:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-param-aprov.log-integr-fluig
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.log-integr-fluig V-table-Win
ON VALUE-CHANGED OF mla-param-aprov.log-integr-fluig IN FRAME f-main /* Integraá∆o Fluig */
DO:
  IF mla-param-aprov.log-integr-fluig:CHECKED IN FRAME {&FRAME-NAME} THEN
      ENABLE mla-param-aprov.cdn-rej
             mla-param-aprov.log-praz-conclus WITH FRAME {&FRAME-NAME}.
  ELSE DO:
      DISABLE mla-param-aprov.cdn-rej
              mla-param-aprov.hra-execucao
              mla-param-aprov.log-praz-conclus WITH FRAME {&FRAME-NAME}.
      
      ASSIGN mla-param-aprov.log-praz-conclus:CHECKED  IN FRAME {&FRAME-NAME} = NO.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-param-aprov.log-praz-conclus
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.log-praz-conclus V-table-Win
ON VALUE-CHANGED OF mla-param-aprov.log-praz-conclus IN FRAME f-main /* Integraá∆o Fluig */
DO:
  IF mla-param-aprov.log-praz-conclus:CHECKED IN FRAME {&FRAME-NAME} THEN
      ENABLE mla-param-aprov.hra-execucao WITH FRAME {&FRAME-NAME}.
  ELSE DO:
      DISABLE mla-param-aprov.hra-execucao WITH FRAME {&FRAME-NAME}.
  END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-param-aprov.cdn-rej
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.cdn-rej V-table-Win
ON F5 OF mla-param-aprov.cdn-rej IN FRAME f-main /* Rej */
DO:

  {include/zoomvar.i &prog-zoom="inzoom/z01in778.w"
                       &campo="mla-param-aprov.cdn-rej"
                       &campozoom="cod-rejeicao"
                       &frame="f-main"}  



END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.cdn-rej V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mla-param-aprov.cdn-rej IN FRAME f-main /* Rej */
DO:

    apply 'f5' to self.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mla-param-aprov.hra-execucao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mla-param-aprov.hra-execucao V-table-Win
ON LEAVE OF mla-param-aprov.hra-execucao IN FRAME f-main /* Hora de conclus∆o */
DO:

    ASSIGN c-hra-execucao = mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main
           mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main = fnFormataHora(c-hra-execucao).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 

/* ***************************  Main Block  *************************** */
  mla-param-aprov.cdn-rej:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame f-main.

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
  {src/adm/template/row-list.i "mla-param-aprov"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mla-param-aprov"}

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

  ASSIGN l-lotacao-principal     :CHECKED IN FRAME {&FRAME-NAME} = FALSE
         l-perm-aprov-principal  :CHECKED IN FRAME {&FRAME-NAME} = FALSE
         l-perm-mestre-principal :CHECKED IN FRAME {&FRAME-NAME} = FALSE
         l-lotacao-principal     = FALSE
         l-perm-aprov-principal  = FALSE
         l-perm-mestre-principal = FALSE
         mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-hora-execucao-default.

  DISABLE mla-param-aprov.cdn-rej
          mla-param-aprov.hra-execucao
          mla-param-aprov.log-praz-conclus WITH FRAME {&FRAME-NAME}.

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
    IF mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" then
        ASSIGN mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-hora-execucao-default.

    IF NOT adm-new-record THEN DO:
        ASSIGN l-log-integr-fluig-ant = mla-param-aprov.log-integr-fluig
               l-log-praz-conclus-ant = mla-param-aprov.log-praz-conclus
               c-hra-execucao-ant     = mla-param-aprov.hra-execucao.
    END.

    ASSIGN i-email-solicit-compr    = INPUT FRAME {&FRAME-NAME} i-email-solicit-compr.

    {include/i-valid.i}
    
    APPLY "leave":U TO mla-param-aprov.hra-execucao in frame {&frame-name}.

    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    IF NOT VALID-HANDLE(h-boin784) THEN
      RUN inbo/boin784.p PERSISTENT SET h-boin784.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    assign overlay(mla-param-aprov.char-1,5,1) = string(i-email-solicit-compr).

    ASSIGN l-limite-alternativo     = l-limite-alternativo:CHECKED IN FRAME {&FRAME-NAME}
           l-lotacao-principal      = l-lotacao-principal:CHECKED IN FRAME {&FRAME-NAME}
           l-perm-aprov-principal   = l-perm-aprov-principal:CHECKED IN FRAME {&FRAME-NAME}
           l-perm-mestre-principal  = l-perm-mestre-principal:CHECKED IN FRAME {&FRAME-NAME}.    

    ASSIGN mla-param-aprov.log-1 = l-limite-alternativo
           OVERLAY(mla-param-aprov.char-1,2,1) = IF l-lotacao-principal     THEN "S":U ELSE "N":U
           OVERLAY(mla-param-aprov.char-1,3,1) = IF l-perm-aprov-principal  THEN "S":U ELSE "N":U
           OVERLAY(mla-param-aprov.char-1,4,1) = IF l-perm-mestre-principal THEN "S":U ELSE "N":U.
    
    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */


    /*Valida minutos*/
    ASSIGN c-hra-execucao = mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME f-main
           c-minutos      = ENTRY(2, c-hra-execucao, ":").

    if int(c-minutos) > 59 then do:
        run utp/ut-msgs.p (input "show",
                           input 3073,
                           input "").
        apply "ENTRY":U to mla-param-aprov.hra-execucao in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    IF NOT adm-new-record THEN DO:
        /*Se houver alteraá‰es nos campos referente ao fluig questiona se replica 
          alteraá‰es para os tipos de documentos*/
        IF l-log-integr-fluig-ant = YES AND mla-param-aprov.log-integr-fluig = NO  THEN DO:
            /*Ao desmarcar a opá∆o de integraá∆o com o Fluig esse parÉmetro ser† automaticamente 
            replicado para os documentos desse estabelecimento. Caso existam solicitaá‰es em aberto 
            no Fluig as mesmas n∆o poder∆o ser movimentadas. Deseja continuar? */
            {utp/ut-liter.i "Caso existam solicitaá‰es em aberto no Fluig as mesmas n∆o poder∆o ser movimentadas" }
            run utp/ut-msgs.p (input "show":U, 
                                 input 54789, 
                                 input RETURN-VALUE).
        
            IF RETURN-VALUE = "YES":U THEN DO:
                
                RUN pi-replica-integracao-fluig IN h-boin784(INPUT mla-param-aprov.ep-codigo,
                                                             INPUT mla-param-aprov.cod-estabel,
                                                             INPUT mla-param-aprov.log-integr-fluig,
                                                             INPUT mla-param-aprov.log-praz-conclus,
                                                             INPUT mla-param-aprov.hra-execucao).
            END.
            ELSE
                return 'ADM-ERROR':U.
        END.
        ELSE IF l-log-integr-fluig-ant <> mla-param-aprov.log-integr-fluig OR 
                l-log-praz-conclus-ant <> mla-param-aprov.log-praz-conclus OR
                c-hra-execucao-ant     <> mla-param-aprov.hra-execucao THEN DO:
            /*Deseja replicar as informaá‰es de integraá∆o com o Fluig para os 
              documentos desse estabelecimento? */
            run utp/ut-msgs.p (input "show":U, 
                                 input 54780, 
                                 input "").
        
            IF RETURN-VALUE = "YES":U THEN DO:
                
                RUN pi-replica-integracao-fluig IN h-boin784(INPUT mla-param-aprov.ep-codigo,
                                                             INPUT mla-param-aprov.cod-estabel,
                                                             INPUT mla-param-aprov.log-integr-fluig,
                                                             INPUT mla-param-aprov.log-praz-conclus,
                                                             INPUT mla-param-aprov.hra-execucao).
            END.
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
    
    DISABLE l-limite-alternativo   
            l-lotacao-principal    
            l-perm-aprov-principal 
            l-perm-mestre-principal 
            mla-param-aprov.cdn-rej         
            mla-param-aprov.hra-execucao    
            mla-param-aprov.log-praz-conclus
            i-email-solicit-compr WITH FRAME {&FRAME-NAME}.

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
    
  IF AVAILABLE mla-param-aprov AND adm-new-record = NO THEN DO:
      IF mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" then
        ASSIGN mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-hora-execucao-default.
      if substring(mla-param-aprov.char-1,5,1) = "" then
        assign i-email-solicit-compr = 1.
      else
        assign i-email-solicit-compr = int(substring(mla-param-aprov.char-1,5,1)).

      ASSIGN l-limite-alternativo    = mla-param-aprov.log-1             
             l-lotacao-principal     = IF SUBSTRING(mla-param-aprov.char-1,2,1) = "S":U THEN TRUE ELSE FALSE
             l-perm-aprov-principal  = IF SUBSTRING(mla-param-aprov.char-1,3,1) = "S":U THEN TRUE ELSE FALSE
             l-perm-mestre-principal = IF SUBSTRING(mla-param-aprov.char-1,4,1) = "S":U THEN TRUE ELSE FALSE.
          
      DISPLAY l-limite-alternativo   
              l-lotacao-principal    
              l-perm-aprov-principal 
              l-perm-mestre-principal
              i-email-solicit-compr WITH FRAME {&FRAME-NAME}.
  END.

  /* Code placed here will execute AFTER standard behavior.    */

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
    
    ENABLE l-limite-alternativo   
           l-lotacao-principal    
           l-perm-aprov-principal 
           l-perm-mestre-principal
           i-email-solicit-compr WITH FRAME {&FRAME-NAME}.

    IF mla-param-aprov.log-integr-fluig:CHECKED IN FRAME {&FRAME-NAME} THEN
        ENABLE mla-param-aprov.cdn-rej         
               mla-param-aprov.log-praz-conclus WITH FRAME {&FRAME-NAME}.
    ELSE
        DISABLE mla-param-aprov.cdn-rej         
                mla-param-aprov.log-praz-conclus WITH FRAME {&FRAME-NAME}.

    IF mla-param-aprov.log-praz-conclus:CHECKED IN FRAME {&FRAME-NAME} THEN
        ENABLE mla-param-aprov.hra-execucao WITH FRAME {&FRAME-NAME}.
    ELSE
        DISABLE mla-param-aprov.hra-execucao WITH FRAME {&FRAME-NAME}.


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
    IF VALID-HANDLE(h-boin784) THEN DO:
        DELETE PROCEDURE h-boin784.
        ASSIGN h-boin784 = ?.
    END.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-log-excec-val V-table-Win 
PROCEDURE pi-atualiza-log-excec-val :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/

    FOR EACH mla-tipo-doc-aprov
       WHERE mla-tipo-doc-aprov.ep-codigo   = mla-param-aprov.ep-codigo
         AND mla-tipo-doc-aprov.cod-estabel = mla-param-aprov.cod-estabel EXCLUSIVE-LOCK:
        
        ASSIGN mla-tipo-doc-aprov.log-excec-val = NO.
    END.
    RELEASE mla-tipo-doc-aprov.


    RETURN "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-valores-log V-table-Win 
PROCEDURE pi-passa-valores-log :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar os valores dos campos para gravar no log
  Parameters:  p-campo - Nome do campo
               p-valor - valor retornado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-campo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor AS LOGICAL NO-UNDO.

    CASE p-campo:
        WHEN "l-limite-alternativo":U THEN
            ASSIGN p-valor = l-limite-alternativo:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-aprovac-altern-dat":U THEN
            ASSIGN p-valor = mla-param-aprov.log-aprovac-altern-dat:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "l-perm-aprov-principal":U THEN
            ASSIGN p-valor = l-perm-aprov-principal:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "l-perm-mestre-principal":U THEN
            ASSIGN p-valor = l-perm-mestre-principal:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "l-lotacao-principal":U THEN
            ASSIGN p-valor = l-lotacao-principal:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-cond-pagto":U THEN
            ASSIGN p-valor = mla-param-aprov.log-cond-pagto:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-ord-recbda":U THEN
            ASSIGN p-valor = mla-param-aprov.log-ord-recbda:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-ord-confda":U THEN
            ASSIGN p-valor = mla-param-aprov.log-ord-confda:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-priorid-aprova-docto" THEN
            ASSIGN p-valor = mla-param-aprov.log-priorid-aprova-docto:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-integr-fluig" THEN
            ASSIGN p-valor = mla-param-aprov.log-integr-fluig:CHECKED IN FRAME {&FRAME-NAME}.
        WHEN "log-praz-conclus" THEN
            ASSIGN p-valor = mla-param-aprov.log-praz-conclus:CHECKED IN FRAME {&FRAME-NAME}.
         
        OTHERWISE
            ASSIGN p-valor = NO.       
    END CASE.

    RETURN "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-valores-char V-table-Win 
PROCEDURE pi-passa-valores-char :
/*------------------------------------------------------------------------------
  Purpose:     Procedure para retornar os valores dos campos para gravar no log
  Parameters:  p-campo - Nome do campo
               p-valor - valor retornado
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER p-campo AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER p-valor AS CHARACTER NO-UNDO.

    CASE p-campo:
        WHEN "hra-execucao" THEN
            ASSIGN p-valor = mla-param-aprov.hra-execucao:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
        WHEN "cdn-rej" THEN
            ASSIGN p-valor = mla-param-aprov.cdn-rej:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
         
        OTHERWISE
            ASSIGN p-valor = "".       
    END CASE.

    RETURN "OK".

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
    
      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
      {include/i-vldprg.i}
      
      IF  INPUT FRAME {&FRAME-NAME} mla-param-aprov.log-cond-pagto = NO
      AND CAN-FIND(FIRST mla-tipo-doc-aprov
                   WHERE mla-tipo-doc-aprov.ep-codigo     = mla-param-aprov.ep-codigo
                     AND mla-tipo-doc-aprov.cod-estabel   = mla-param-aprov.cod-estabel
                     AND mla-tipo-doc-aprov.log-excec-val = YES) THEN DO:
          run utp/ut-msgs.p (input "show":U, 
                             input 53575, 
                             input "").
          IF RETURN-VALUE = "YES":U THEN 
              RUN pi-atualiza-log-excec-val.
          ELSE DO:
              ASSIGN mla-param-aprov.log-cond-pagto:CHECKED IN FRAME {&FRAME-NAME} = YES.
              return 'ADM-ERROR':U.
          END.
      END.
      /*Valida c¢digo de rejeiá∆o*/
     
      IF INPUT FRAME {&FRAME-NAME} mla-param-aprov.cdn-rej <> 0 AND 
        NOT CAN-FIND (FIRST mla-rej-aprov 
                      WHERE mla-rej-aprov.cod-rejeicao = INPUT FRAME {&FRAME-NAME} mla-param-aprov.cdn-rej) THEN DO:
        {utp/ut-table.i mgind mla-rej-aprov 1}
        run utp/ut-msgs.p (input "show":U, 
                             input 2, 
                             input RETURN-VALUE).
        return 'ADM-ERROR':U.
      END.

      RETURN "OK":U.
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
  {src/adm/template/snd-list.i "mla-param-aprov"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnFormataHora V-table-Win 
FUNCTION fnFormataHora RETURNS CHARACTER
  (c-valor AS CHARACTER) :
/*------------------------------------------------------------------------------
  Purpose: Retorna o valor formatado da hora para ser preenchida conforme o formato 999:99
  Parameters: c-valor - Valor digitado
    Notes:  
------------------------------------------------------------------------------*/
  DEFINE VARIABLE c-valor-formatado AS CHARACTER   NO-UNDO.
  
  ASSIGN c-horas   = trim(ENTRY(1,c-valor,":"))
         c-minutos = trim(ENTRY(2,c-valor,":")).
  
  IF c-horas = "" AND c-minutos = "" THEN DO:
      ASSIGN c-valor-formatado = "000:00".
  END.
  ELSE DO:
     ASSIGN c-horas   = FILL("0", 3 - LENGTH(c-horas)) + c-horas
            c-minutos = c-minutos + FILL("0", 2 - LENGTH(c-minutos))
            c-valor-formatado = c-horas + ":" + c-minutos. 
  END.
  
  RETURN c-valor-formatado.

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
