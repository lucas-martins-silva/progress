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
{include/i-prgvrs.i V18IN144 2.00.00.002}  /*** 010002 ***/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent    as rowid no-undo.
DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.

{cdp/cdcfgman.i} /* Vari vel preprocessador bf_man_trans_assinc */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-5 RECT-4 RECT-6 RECT-7 
&Scoped-Define DISPLAYED-OBJECTS tg-log-capac-finita rs-idi-forma-aloc ~
fi-num-nivel tg-log-reduc-setup fi-num-horiz-agrup rs-idi-tam-agrup ~
fi-num-durac-agrup rs-idi-reduc c-texto1 rs-idi-criter-agrup-reduc-setup ~
fi-vli-perc-reduc-setup c-texto2 c-texto3 c-texto4 c-texto5 ~
tg-log-control-recur-sec 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS tg-log-capac-finita rs-idi-forma-aloc ~
fi-num-nivel tg-log-reduc-setup fi-num-horiz-agrup rs-idi-tam-agrup ~
fi-num-durac-agrup rs-idi-reduc rs-idi-criter-agrup-reduc-setup ~
fi-vli-perc-reduc-setup tg-log-control-recur-sec 

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
DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U INITIAL "Aloca Centro de Trabalho" 
      VIEW-AS TEXT 
     SIZE 21.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U INITIAL "horas" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto3 AS CHARACTER FORMAT "X(256)":U INITIAL "Tamanho do Agrupamento" 
      VIEW-AS TEXT 
     SIZE 21.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto4 AS CHARACTER FORMAT "X(256)":U INITIAL "Tipo Valor Redu‡Æo" 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto5 AS CHARACTER FORMAT "X(256)":U INITIAL "Crit‚rios de Agrupamento / Redu‡Æo de Setup" 
      VIEW-AS TEXT 
     SIZE 34 BY .67 NO-UNDO.

DEFINE VARIABLE fi-num-durac-agrup AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-horiz-agrup AS INTEGER FORMAT ">>,>>>,>>9":U INITIAL 0 
     LABEL "Horizonte de Busca" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-num-nivel AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "N¡vel Aloca‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vli-perc-reduc-setup AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "% Redu‡Æo de Setup" 
     VIEW-AS FILL-IN 
     SIZE 5.86 BY .88 NO-UNDO.

DEFINE VARIABLE rs-idi-criter-agrup-reduc-setup AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Item/Opera‡Æo", 1,
"Ferramenta", 2,
"Matriz de Setup", 3
     SIZE 24.14 BY 2.25 NO-UNDO.

DEFINE VARIABLE rs-idi-forma-aloc AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Prioridade", 1,
"Uniforme", 2
     SIZE 16 BY 1.5 NO-UNDO.

DEFINE VARIABLE rs-idi-reduc AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Percentual", 1,
"Horas", 2
     SIZE 16 BY 1.5 NO-UNDO.

DEFINE VARIABLE rs-idi-tam-agrup AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Peso Prepara‡Æo", 1,
"% Prepara‡Æo", 2,
"Tempo Total", 3
     SIZE 20 BY 2.5 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.29 BY 2.25.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 33.29 BY 3.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.14 BY 10.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26 BY 2.25.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 45.29 BY 5.38.

DEFINE VARIABLE tg-log-capac-finita AS LOGICAL INITIAL yes 
     LABEL "Capacidade Finita" 
     VIEW-AS TOGGLE-BOX
     SIZE 22 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-control-recur-sec AS LOGICAL INITIAL yes 
     LABEL "Controla Recurso Secund rio" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-reduc-setup AS LOGICAL INITIAL no 
     LABEL "Apenas Redu‡Æo Setup" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tg-log-capac-finita AT ROW 9.96 COL 42.29
     rs-idi-forma-aloc AT ROW 2 COL 4 NO-LABEL
     fi-num-nivel AT ROW 3.96 COL 20.14 COLON-ALIGNED
     tg-log-reduc-setup AT ROW 5.13 COL 2
     fi-num-horiz-agrup AT ROW 6.13 COL 20.14 COLON-ALIGNED
     rs-idi-tam-agrup AT ROW 8 COL 4 NO-LABEL
     fi-num-durac-agrup AT ROW 9.54 COL 26 COLON-ALIGNED NO-LABEL
     rs-idi-reduc AT ROW 2 COL 42.57 NO-LABEL
     c-texto1 AT ROW 1.17 COL 2.72 NO-LABEL
     rs-idi-criter-agrup-reduc-setup AT ROW 5.46 COL 41.86 NO-LABEL
     fi-vli-perc-reduc-setup AT ROW 8.13 COL 62.57 COLON-ALIGNED
     c-texto2 AT ROW 6.29 COL 31.43 NO-LABEL
     c-texto3 AT ROW 7.25 COL 2.72 NO-LABEL
     c-texto4 AT ROW 1.17 COL 41 NO-LABEL
     c-texto5 AT ROW 4.08 COL 41 NO-LABEL
     tg-log-control-recur-sec AT ROW 9.96 COL 60.72
     RECT-3 AT ROW 1.5 COL 1.72
     RECT-5 AT ROW 1 COL 1
     RECT-4 AT ROW 7.5 COL 1.72
     RECT-6 AT ROW 1.5 COL 40
     RECT-7 AT ROW 4.38 COL 40
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
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
         HEIGHT             = 10.21
         WIDTH              = 85.29.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto3 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto4 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto5 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN fi-num-durac-agrup IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-num-horiz-agrup IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-num-nivel IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-vli-perc-reduc-setup IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-idi-criter-agrup-reduc-setup IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-idi-forma-aloc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-idi-reduc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-idi-tam-agrup IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-log-capac-finita IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-log-control-recur-sec IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-log-reduc-setup IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME fi-num-durac-agrup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-durac-agrup V-table-Win
ON RETURN OF fi-num-durac-agrup IN FRAME f-main
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-horiz-agrup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-horiz-agrup V-table-Win
ON RETURN OF fi-num-horiz-agrup IN FRAME f-main /* Horizonte de Busca */
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-nivel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-nivel V-table-Win
ON RETURN OF fi-num-nivel IN FRAME f-main /* N¡vel Aloca‡Æo */
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-vli-perc-reduc-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-vli-perc-reduc-setup V-table-Win
ON RETURN OF fi-vli-perc-reduc-setup IN FRAME f-main /* % Redu‡Æo de Setup */
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-idi-criter-agrup-reduc-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-idi-criter-agrup-reduc-setup V-table-Win
ON RETURN OF rs-idi-criter-agrup-reduc-setup IN FRAME f-main
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-idi-criter-agrup-reduc-setup V-table-Win
ON VALUE-CHANGED OF rs-idi-criter-agrup-reduc-setup IN FRAME f-main
DO:
    IF INPUT FRAME f-main rs-idi-criter-agrup-reduc-setup = 3 THEN
        ASSIGN fi-vli-perc-reduc-setup:SENSITIVE IN FRAME f-main = NO
               rs-idi-reduc:SENSITIVE IN FRAME f-main            = YES.
    ELSE
        ASSIGN fi-vli-perc-reduc-setup:SENSITIVE IN FRAME f-main = YES
               rs-idi-reduc:SENSITIVE IN FRAME f-main            = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-idi-forma-aloc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-idi-forma-aloc V-table-Win
ON RETURN OF rs-idi-forma-aloc IN FRAME f-main
DO:
    RUN salvar IN h-handle-pai NO-ERROR.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-idi-reduc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-idi-reduc V-table-Win
ON RETURN OF rs-idi-reduc IN FRAME f-main
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-idi-tam-agrup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-idi-tam-agrup V-table-Win
ON RETURN OF rs-idi-tam-agrup IN FRAME f-main
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-log-capac-finita
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-log-capac-finita V-table-Win
ON RETURN OF tg-log-capac-finita IN FRAME f-main /* Capacidade Finita */
DO:
    RUN salvar IN h-handle-pai NO-ERROR.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-log-control-recur-sec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-log-control-recur-sec V-table-Win
ON RETURN OF tg-log-control-recur-sec IN FRAME f-main /* Controla Recurso Secund rio */
DO:
    RUN salvar IN h-handle-pai NO-ERROR.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-log-reduc-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-log-reduc-setup V-table-Win
ON RETURN OF tg-log-reduc-setup IN FRAME f-main /* Apenas Redu‡Æo Setup */
DO:
    RUN salvar IN h-handle-pai NO-ERROR.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-log-reduc-setup V-table-Win
ON VALUE-CHANGED OF tg-log-reduc-setup IN FRAME f-main /* Apenas Redu‡Æo Setup */
DO:
    IF  tg-log-reduc-setup:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
        ASSIGN fi-num-horiz-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
               fi-num-durac-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
               fi-num-horiz-agrup:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
               rs-idi-tam-agrup:SENSITIVE      IN FRAME {&FRAME-NAME} = NO
               fi-num-durac-agrup:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
    END.
    ELSE DO:
        ASSIGN fi-num-horiz-agrup:SENSITIVE    IN FRAME {&FRAME-NAME} = YES
               rs-idi-tam-agrup:SENSITIVE      IN FRAME {&FRAME-NAME} = YES
               fi-num-durac-agrup:SENSITIVE    IN FRAME {&FRAME-NAME} = YES.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Aloca_Centro_de_Trabalho * R}
ASSIGN c-texto1 = RETURN-VALUE.

{utp/ut-liter.i Horas * R}
ASSIGN c-texto2 = RETURN-VALUE.

{utp/ut-liter.i Tamanho_do_Agrupamento * R}
ASSIGN c-texto3 = RETURN-VALUE.

{utp/ut-liter.i Tipo_Valor_Redu‡Æo * R}
ASSIGN c-texto4 = RETURN-VALUE.

{utp/ut-liter.i Crit‚rios_de_Agrupamento_/_Redu‡Æo_de_Setup * R}
ASSIGN c-texto5 = RETURN-VALUE.

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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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

    /* Dispatch standard ADM method.                             */
    /*
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF  RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.
    */
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    IF  AVAIL grup-maquina THEN DO:
        /*Aloca Centro de Trabalho*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.idi-forma-aloc = INPUT FRAME {&frame-name} rs-idi-forma-aloc.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,6,1) = INPUT FRAME {&FRAME-NAME} rs-idi-forma-aloc.
        &ENDIF
        
        /*Tipo Valor Redu‡Æo*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.idi-forma-reduc = INPUT FRAME {&frame-name} rs-idi-reduc.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,7,1) = INPUT FRAME {&FRAME-NAME} rs-idi-reduc.
        &ENDIF
        
        /*Apenas Redu‡Æo de Setup*/
        /*Quando estiver como NÆo este campo ir  desabilitar os seguintes campos:
          Horizonte de Busca e Tamanho do Agrupamento*/

        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.log-reduc-setup = IF  INPUT FRAME {&FRAME-NAME} tg-log-reduc-setup = YES THEN
                                                       YES
                                                   ELSE
                                                       NO.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,8,1) = IF  INPUT FRAME {&FRAME-NAME} tg-log-reduc-setup = YES THEN
                                                           "S":U
                                                       ELSE "N":U.
        &ENDIF
        
        /*Horizonte de Busca*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.num-horiz-agrup = INPUT FRAME {&FRAME-NAME} fi-num-horiz-agrup.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,9,8) = INPUT FRAME {&FRAME-NAME} fi-num-horiz-agrup.
        &ENDIF
        
        /*Tamanho do Agrupamento*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.idi-tam-agrup   = INPUT FRAME {&frame-name} rs-idi-tam-agrup
                    grup-maquina.num-durac-agrup = INPUT FRAME {&FRAME-NAME} fi-num-durac-agrup.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,26,1) = INPUT FRAME {&FRAME-NAME} rs-idi-tam-agrup
                    OVERLAY(grup-maquina.char-1,17,8) = INPUT FRAME {&FRAME-NAME} fi-num-durac-agrup.
        &ENDIF
        
        /*Crit‚rios de Agrupamento/Redu‡Æo de Setup*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.idi-criter-agrup-reduc-setup = INPUT FRAME {&frame-name} rs-idi-criter-agrup-reduc-setup.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,25,1) = INPUT FRAME {&FRAME-NAME} rs-idi-criter-agrup-reduc-setup.
        &ENDIF
        
        /*% Redu‡Æo de Setup*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.vli-perc-reduc-setup = INPUT FRAME {&FRAME-NAME} fi-vli-perc-reduc-setup.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,27,3) = INPUT FRAME {&FRAME-NAME} fi-vli-perc-reduc-setup.
        &ENDIF
        
         IF  tg-log-reduc-setup:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
             &IF  DEFINED(bf_man_207) &THEN
                  /*Tamanho do Agrupamento*/
                  ASSIGN grup-maquina.idi-tam-agrup   = 0
                         grup-maquina.num-durac-agrup = 0.
                  /*Horizonte de Busca*/
                  ASSIGN grup-maquina.num-horiz-agrup = 0.
             &ELSE
                  /*Tamanho do Agrupamento*/
                  ASSIGN OVERLAY(grup-maquina.char-1,26,1) = "0"
                         OVERLAY(grup-maquina.char-1,17,8) = "0".
                  /*Tamanho do Agrupamento*/
                  ASSIGN OVERLAY(grup-maquina.char-1,9,8)  = "0".
             &ENDIF
         END.

        /*N¡vel Aloca‡Æo*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.num-nivel = INPUT FRAME {&FRAME-NAME} fi-num-nivel.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,30,4) = string(INPUT FRAME {&FRAME-NAME} fi-num-nivel).
        &ENDIF
        
       /*Capacidade Finita*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.log-capac-finita = IF  INPUT FRAME {&FRAME-NAME} tg-log-capac-finita = YES THEN
                                                       YES
                                                   ELSE
                                                       NO.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,34,1) = IF  INPUT FRAME {&FRAME-NAME} tg-log-capac-finita = YES THEN
                                                           "S":U
                                                       ELSE "N":U.
        &ENDIF
        
       /*Controla Recurso Secund rio*/
        &IF  DEFINED(bf_man_207) &THEN
             ASSIGN grup-maquina.log-control-recur-sec = IF  INPUT FRAME {&FRAME-NAME} tg-log-control-recur-sec = YES THEN
                                                             YES
                                                         ELSE
                                                             NO.
        &ELSE
             ASSIGN OVERLAY(grup-maquina.char-1,35,1) = IF  INPUT FRAME {&FRAME-NAME} tg-log-control-recur-sec = YES THEN
                                                             "S":U
                                                         ELSE "N":U.
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
    &if DEFINED(ADM-MODIFY-FIELDS) &then
        DISABLE {&ADM-MODIFY-FIELDS} WITH FRAME {&FRAME-NAME}.
    &ENDIF
    
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

  IF  AVAILABLE grup-maquina THEN DO:
      /*Aloca Centro de Trabalho*/
      ASSIGN rs-idi-forma-aloc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN rs-idi-forma-aloc:SCREEN-VALUE IN FRAME {&frame-name} = STRING(grup-maquina.idi-forma-aloc).
      &ELSE
           ASSIGN rs-idi-forma-aloc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,6,1).
      &ENDIF
      /*Tipo Valor Redu‡Æo*/
      ASSIGN rs-idi-reduc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN rs-idi-reduc:SCREEN-VALUE IN FRAME {&frame-name} = STRING(grup-maquina.idi-forma-reduc).
      &ELSE
           ASSIGN rs-idi-reduc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,7,1).
      &ENDIF
      
      /*Apenas Redu‡Æo de Setup*/
      /*Quando estiver como NÆo este campo ir  desabilitar os seguintes campos:
        Horizonte de Busca e Tamanho do Agrupamento*/
      ASSIGN tg-log-reduc-setup:CHECKED IN FRAME {&FRAME-NAME} = NO.
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN tg-log-reduc-setup:CHECKED IN FRAME {&FRAME-NAME} = grup-maquina.log-reduc-setup.
      &ELSE
           ASSIGN tg-log-reduc-setup:CHECKED IN FRAME {&FRAME-NAME} = IF  SUBSTRING(grup-maquina.char-1,8,1) = "S" THEN
                                                                           YES
                                                                       ELSE
                                                                           NO.
      &ENDIF
      
      /*Horizonte de Busca*/
      ASSIGN fi-num-horiz-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN fi-num-horiz-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(grup-maquina.num-horiz-agrup).
      &ELSE
           ASSIGN fi-num-horiz-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,9,8).
      &ENDIF
      
      /*Tamanho do Agrupamento*/
      ASSIGN rs-idi-tam-agrup:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = "1"
             fi-num-durac-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0".
      &IF  DEFINED(bf_man_207) &THEN
           IF  grup-maquina.idi-tam-agrup <> 0 THEN
               ASSIGN rs-idi-tam-agrup:SCREEN-VALUE   IN FRAME {&frame-name} = STRING(grup-maquina.idi-tam-agrup).
           ASSIGN fi-num-durac-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(grup-maquina.num-durac-agrup).
      &ELSE
           IF  TRIM(SUBSTRING(grup-maquina.char-1,26,1)) <> "0" THEN
               ASSIGN rs-idi-tam-agrup:SCREEN-VALUE   IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,26,1).
           ASSIGN fi-num-durac-agrup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,17,8).
      &ENDIF
      
      /*Crit‚rios de Agrupamento/Redu‡Æo de Setup*/
      ASSIGN rs-idi-criter-agrup-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN rs-idi-criter-agrup-reduc-setup:SCREEN-VALUE IN FRAME {&frame-name} = STRING(grup-maquina.idi-criter-agrup-reduc-setup).
      &ELSE
           ASSIGN rs-idi-criter-agrup-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,25,1).
      &ENDIF
      
      /*% Redu‡Æo de Setup*/
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(grup-maquina.vli-perc-reduc-setup).
      &ELSE
           ASSIGN fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,27,3).
      &ENDIF
      IF  fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0" OR
          fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN
          ASSIGN fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "100".

      /*N¡vel Aloca‡Æo*/
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN fi-num-nivel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(grup-maquina.num-nivel).
      &ELSE
           ASSIGN fi-num-nivel:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(grup-maquina.char-1,30,4).
      &ENDIF
      IF fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U THEN
          ASSIGN fi-vli-perc-reduc-setup:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0":U.

      /*Capacidade Finita*/
      ASSIGN tg-log-capac-finita:CHECKED IN FRAME {&FRAME-NAME} = NO.
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN tg-log-capac-finita:CHECKED IN FRAME {&FRAME-NAME} = grup-maquina.log-capac-finita.
      &ELSE
           ASSIGN tg-log-capac-finita:CHECKED IN FRAME {&FRAME-NAME} = IF  SUBSTRING(grup-maquina.char-1,34,1) = "N":U THEN
                                                                           NO
                                                                       ELSE
                                                                           YES.
      &ENDIF
      
      /*Controla Recurso Secund rio*/
      ASSIGN tg-log-control-recur-sec:CHECKED IN FRAME {&FRAME-NAME} = NO.
      &IF  DEFINED(bf_man_207) &THEN
           ASSIGN tg-log-control-recur-sec:CHECKED IN FRAME {&FRAME-NAME} = grup-maquina.log-control-recur-sec.
      &ELSE
           ASSIGN tg-log-control-recur-sec:CHECKED IN FRAME {&FRAME-NAME} = IF  SUBSTRING(grup-maquina.char-1,35,1) <> "S":U THEN
                                                                                 NO
                                                                             ELSE
                                                                                 YES.
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
    &if  defined(ADM-MODIFY-FIELDS) &then
    /*if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF  tg-log-reduc-setup:CHECKED IN FRAME {&FRAME-NAME} = YES THEN DO:
        ASSIGN fi-num-horiz-agrup:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               rs-idi-tam-agrup:SENSITIVE   IN FRAME {&FRAME-NAME} = NO
               fi-num-durac-agrup:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    END.

    APPLY "value-changed":U TO rs-idi-criter-agrup-reduc-setup IN FRAME f-main.

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
    DEFINE INPUT PARAMETER v-row-parent-externo AS ROWID NO-UNDO.

    ASSIGN v-row-parent = v-row-parent-externo.

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
  {src/adm/template/snd-list.i "grup-maquina"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHandlePai V-table-Win 
PROCEDURE setaHandlePai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.

ASSIGN h-handle-pai = p-handle.

RETURN "OK":U.
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

