&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movind           PROGRESS
          movmfg           PROGRESS
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
{include/i-prgvrs.i V03IN535 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN535 MUT}
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

{cdp/cdcfgman.i}
DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.

DEFINE VARIABLE h-handle-pag-1 AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-boin469e     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-handle-pai   AS HANDLE     NO-UNDO.

DEFINE VARIABLE c-gm-codigo       LIKE split-operac.gm-codigo      NO-UNDO.
DEFINE VARIABLE c-cod-ctrab       LIKE split-operac.cod-ctrab      NO-UNDO.
DEFINE VARIABLE c-cod-area-produc LIKE area-produc.cod-area-produc NO-UNDO.

&IF DEFINED(bf_man_204) &THEN
    {sfc/sf0309.i p} /*Funcao para tratamento de leave dos campos de hora*/
&ENDIF

DEFINE VARIABLE l-erro AS LOGICAL INIT NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES split-operac
&Scoped-define FIRST-EXTERNAL-TABLE split-operac


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR split-operac.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS split-operac.dat-imc split-operac.dat-fmt ~
split-operac.dat-progda-inic-setup split-operac.dat-progda-fim-operac ~
split-operac.dat-produt-dispon 
&Scoped-define ENABLED-TABLES split-operac
&Scoped-define FIRST-ENABLED-TABLE split-operac
&Scoped-Define ENABLED-OBJECTS rt-key rt-key-2 rt-key-3 rt-key-4 ~
fi-reporte-total fi-hra-imc fi-hra-fmt fi-hra-inic-setup fi-hra-fim-operac ~
label-reportes label-imc-fmt label-inicio-disp label-disponivel 
&Scoped-Define DISPLAYED-FIELDS split-operac.qtd-operac-aprov ~
split-operac.qtd-operac-retrab split-operac.qtd-operac-refgda ~
split-operac.dat-imc split-operac.dat-fmt ~
split-operac.dat-progda-inic-setup split-operac.dat-progda-fim-operac ~
split-operac.dat-produt-dispon 
&Scoped-define DISPLAYED-TABLES split-operac
&Scoped-define FIRST-DISPLAYED-TABLE split-operac
&Scoped-Define DISPLAYED-OBJECTS fi-reporte-total fi-hra-imc fi-hra-fmt ~
fi-hra-inic-setup fi-hra-fim-operac fi-hra-produc-disp label-reportes ~
label-imc-fmt label-inicio-disp label-disponivel 

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
DEFINE VARIABLE fi-hra-fim-operac AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-fmt AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-imc AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-inic-setup AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hra-produc-disp AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-reporte-total AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Qtd Reporte Total" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88 NO-UNDO.

DEFINE VARIABLE label-disponivel AS CHARACTER FORMAT "X(256)":U INITIAL "Data Dispon°vel Real" 
      VIEW-AS TEXT 
     SIZE 21.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-imc-fmt AS CHARACTER FORMAT "X(256)":U INITIAL "Data In°cio Mais Cedo / Data TÇrmino Mais Tarde" 
      VIEW-AS TEXT 
     SIZE 42.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-inicio-disp AS CHARACTER FORMAT "X(256)":U INITIAL "Data Disponibilidade (Alocaá∆o)" 
      VIEW-AS TEXT 
     SIZE 30.43 BY .67 NO-UNDO.

DEFINE VARIABLE label-reportes AS CHARACTER FORMAT "X(256)":U INITIAL "Reportes" 
      VIEW-AS TEXT 
     SIZE 10 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.5.

DEFINE RECTANGLE rt-key-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.04.

DEFINE RECTANGLE rt-key-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.04.

DEFINE RECTANGLE rt-key-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 2.04.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     split-operac.qtd-operac-aprov AT ROW 1.63 COL 17.86 COLON-ALIGNED FORMAT "->>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     split-operac.qtd-operac-retrab AT ROW 1.63 COL 58.29 COLON-ALIGNED FORMAT ">>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     split-operac.qtd-operac-refgda AT ROW 2.63 COL 17.86 COLON-ALIGNED FORMAT "->>>,>>>,>>9.9999"
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     fi-reporte-total AT ROW 2.63 COL 58.29 COLON-ALIGNED
     split-operac.dat-imc AT ROW 4.88 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-hra-imc AT ROW 4.88 COL 29 COLON-ALIGNED NO-LABEL
     split-operac.dat-fmt AT ROW 4.88 COL 58.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-hra-fmt AT ROW 4.88 COL 69.43 COLON-ALIGNED NO-LABEL
     split-operac.dat-progda-inic-setup AT ROW 7.46 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-hra-inic-setup AT ROW 7.46 COL 29 COLON-ALIGNED NO-LABEL
     split-operac.dat-progda-fim-operac AT ROW 7.46 COL 58.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-hra-fim-operac AT ROW 7.46 COL 69.43 COLON-ALIGNED NO-LABEL
     split-operac.dat-produt-dispon AT ROW 10 COL 17.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     fi-hra-produc-disp AT ROW 10 COL 29 COLON-ALIGNED NO-LABEL
     label-reportes AT ROW 1 COL 1.57 COLON-ALIGNED NO-LABEL
     label-imc-fmt AT ROW 3.96 COL 1.57 COLON-ALIGNED NO-LABEL
     label-inicio-disp AT ROW 6.54 COL 1.57 COLON-ALIGNED NO-LABEL
     label-disponivel AT ROW 9.04 COL 1.57 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1.25 COL 1
     rt-key-2 AT ROW 4.21 COL 1
     rt-key-3 AT ROW 6.79 COL 1
     rt-key-4 AT ROW 9.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.split-operac
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
         HEIGHT             = 10.42
         WIDTH              = 85.72.
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-hra-produc-disp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.qtd-operac-aprov IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN split-operac.qtd-operac-refgda IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
/* SETTINGS FOR FILL-IN split-operac.qtd-operac-retrab IN FRAME f-main
   NO-ENABLE EXP-FORMAT                                                 */
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

&Scoped-define SELF-NAME split-operac.dat-progda-fim-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.dat-progda-fim-operac V-table-Win
ON LEAVE OF split-operac.dat-progda-fim-operac IN FRAME f-main /* Fim Progdo */
DO:
    RUN calculosDataTerminoDispon.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME split-operac.dat-progda-inic-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.dat-progda-inic-setup V-table-Win
ON LEAVE OF split-operac.dat-progda-inic-setup IN FRAME f-main /* Prog Inic Carga */
DO:
     RUN calculosDataInicDispon.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-fim-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fim-operac V-table-Win
ON ALT-O OF fi-hra-fim-operac IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fim-operac V-table-Win
ON LEAVE OF fi-hra-fim-operac IN FRAME f-main
DO:
     ASSIGN l-erro = NO.
     &IF DEFINED(bf_man_204) &THEN
         /** Consiste o hor†rio **/
         ASSIGN fi-hra-fim-operac = fnValidaHora(fi-hra-fim-operac:SCREEN-VALUE IN FRAME f-main).
         IF fi-hra-fim-operac = ? THEN DO:
    
             run utp/ut-msgs.p (input "show":U,
                                input 29520,
                                input "":U).
         
             APPLY "ENTRY":U to fi-hra-fim-operac in frame f-main.
             ASSIGN l-erro = YES.
             RETURN NO-APPLY.
         END.
         
         DISPLAY fi-hra-fim-operac WITH FRAME f-main.
     &ENDIF  
     
     RUN calculosDataTerminoDispon.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fim-operac V-table-Win
ON RETURN OF fi-hra-fim-operac IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-fmt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fmt V-table-Win
ON ALT-O OF fi-hra-fmt IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fmt V-table-Win
ON LEAVE OF fi-hra-fmt IN FRAME f-main
DO:
    ASSIGN l-erro = NO.
    &IF DEFINED(bf_man_204) &THEN
        /** Consiste o hor†rio **/
        ASSIGN fi-hra-fmt = fnValidaHora(fi-hra-fmt:SCREEN-VALUE IN FRAME f-main).
        IF fi-hra-fmt = ? THEN DO:

            run utp/ut-msgs.p (input "show":U,
                               input 29520,
                               input "":U).
        
            APPLY "ENTRY":U to fi-hra-fmt in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.
        END.
        
        DISPLAY fi-hra-fmt WITH FRAME f-main.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fmt V-table-Win
ON RETURN OF fi-hra-fmt IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-imc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-imc V-table-Win
ON ALT-O OF fi-hra-imc IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-imc V-table-Win
ON LEAVE OF fi-hra-imc IN FRAME f-main
DO:
    ASSIGN l-erro = NO.
    &IF DEFINED(bf_man_204) &THEN
        /** Consiste o hor†rio **/
        ASSIGN fi-hra-imc = fnValidaHora(fi-hra-imc:SCREEN-VALUE IN FRAME f-main).
        IF fi-hra-imc = ? THEN DO:

            run utp/ut-msgs.p (input "show":U,
                               input 29520,
                               input "":U).
        
            APPLY "ENTRY":U to fi-hra-imc in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.
        END.
        
        DISPLAY fi-hra-imc WITH FRAME f-main.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-imc V-table-Win
ON RETURN OF fi-hra-imc IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-inic-setup
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-inic-setup V-table-Win
ON ALT-O OF fi-hra-inic-setup IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-inic-setup V-table-Win
ON LEAVE OF fi-hra-inic-setup IN FRAME f-main
DO:
     ASSIGN l-erro = NO.
     &IF DEFINED(bf_man_204) &THEN
         /** Consiste o hor†rio **/
         ASSIGN fi-hra-inic-setup = fnValidaHora(fi-hra-inic-setup:SCREEN-VALUE IN FRAME f-main).
         IF fi-hra-inic-setup = ? THEN DO:
    
             run utp/ut-msgs.p (input "show":U,
                                input 29520,
                                input "":U).
         
             APPLY "ENTRY":U to fi-hra-inic-setup in frame f-main.
             ASSIGN l-erro = YES.
             RETURN NO-APPLY.
         END.
         
         DISPLAY fi-hra-inic-setup WITH FRAME f-main.
     &ENDIF  

     RUN calculosDataInicDispon.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-inic-setup V-table-Win
ON RETURN OF fi-hra-inic-setup IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.    
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF     

  /*Procedure pi-formatted-time-to-sec*/
  {sfc/sf9000.i}

  
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
  {src/adm/template/row-list.i "split-operac"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "split-operac"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaCamposConfirmacao V-table-Win 
PROCEDURE calculaCamposConfirmacao :
/*------------------------------------------------------------------------------
  Purpose:     Recalcula o valor de alguns campos. Este recalculo eh chamado apenas na confirmaá∆o.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-dat-progda-inic-operac      LIKE split-operac.dat-progda-inic-operac NO-UNDO.
DEF OUTPUT PARAM p-qtd-segs-progdo-inic-operac LIKE split-operac.qtd-segs-progdo-inic-operac NO-UNDO.

&IF DEFINED(bf_man_204) &THEN
    DEFINE VARIABLE d-dat-inicio       AS DATE    INITIAL ?    NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-inicio  AS INTEGER INITIAL ?    NO-UNDO.
    DEFINE VARIABLE d-dat-termino      AS DATE    INITIAL ?    NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-termino AS INTEGER INITIAL ?    NO-UNDO.
    DEF VAR de-tempo-aux       AS DECIMAL DECIMALS 4 NO-UNDO.

    IF VALID-HANDLE(h-boin469e) AND CAN-FIND(FIRST grup-maquina WHERE grup-maquina.gm-codigo = c-gm-codigo NO-LOCK) THEN DO:

        /****Calcula a dat-progda-inic-operac*************/
        ASSIGN de-tempo-aux      = (split-operac.tempo-pad-setup / 3600)
               d-dat-inicio      = INPUT FRAME f-main split-operac.dat-progda-inic-setup.

        /*Se a data inicio for inv†lida, n∆o efetua os calculos*/
        IF d-dat-inicio <> ? THEN DO:
            RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-inic-setup,
                                         OUTPUT i-qtd-segs-inicio).
        
            RUN piCalculaDataHoraTempo IN h-boin469e (INPUT (IF c-cod-area-produc <> ?        /*Se area e ctrab <> "" passa a area,*/ 
                                                               AND c-cod-area-produc <> "":U  /*senao passa branco*/
                                                               AND c-cod-ctrab <> "":U THEN c-cod-area-produc ELSE "":U),     
                                                      INPUT        c-gm-codigo,  
                                                      INPUT        c-cod-ctrab,        
                                                      INPUT        ?,     /*c-cod-calend*/       
                                                      INPUT-OUTPUT d-dat-termino ,      /*output*/    
                                                      INPUT-OUTPUT i-qtd-segs-termino , /*output*/
                                                      INPUT-OUTPUT d-dat-inicio ,       /*input*/
                                                      INPUT-OUTPUT i-qtd-segs-inicio ,  /*input*/
                                                      INPUT-OUTPUT de-tempo-aux,
                                                      INPUT         YES,                /*l-cons-parada-prog*/
                                                      INPUT         YES,                /*l-cons-parada-real*/
                                                      INPUT         TODAY,              /*d-dat-corte-parada*/    
                                                      INPUT         TIME).              /*i-qtd-segs-corte-parada*/
    
            ASSIGN p-dat-progda-inic-operac      = d-dat-termino
                   p-qtd-segs-progdo-inic-operac = i-qtd-segs-termino.
        END. /*IF d-dat-inicio <> ? */
    END. /*IF VALID-HANDLE(h-boin469e) AND CAN-FIND(FIRST grup-maquina WHERE grup-maquina.gm-codigo = c-gm-codigo NO-LOCK)*/
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculosDataInicDispon V-table-Win 
PROCEDURE calculosDataInicDispon :
/*------------------------------------------------------------------------------
  Purpose:     Calcula a data Termino Disponib Alocacao com base na data Inicio
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED(bf_man_204) &THEN
    DEFINE VARIABLE d-dat-inicio       AS DATE    INITIAL ?    NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-inicio  AS INTEGER INITIAL ?    NO-UNDO.
    DEFINE VARIABLE d-dat-termino      AS DATE    INITIAL ?    NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-termino AS INTEGER INITIAL ?    NO-UNDO.
    DEF VAR de-tempo-aux       AS DECIMAL DECIMALS 4 NO-UNDO.

    /*S¢ efetua os c†lculos caso o grupo de m†quina seja v†lido*/
    IF VALID-HANDLE(h-boin469e) AND CAN-FIND(FIRST grup-maquina WHERE grup-maquina.gm-codigo = c-gm-codigo NO-LOCK) THEN DO:

        ASSIGN de-tempo-aux      = ((split-operac.tempo-pad-setup / 3600) +
                                    (split-operac.tempo-pad-operac / 3600))
               d-dat-inicio      = INPUT FRAME f-main split-operac.dat-progda-inic-setup.
    
        /*Se a data inicio for inv†lida, n∆o efetua os calculos*/
        IF d-dat-inicio <> ? THEN DO:
            RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-inic-setup,
                                         OUTPUT i-qtd-segs-inicio).

            RUN piCalculaDataHoraTempo IN h-boin469e (INPUT (IF c-cod-area-produc <> ?        /*Se area e ctrab <> "" passa a area,*/ 
                                                               AND c-cod-area-produc <> "":U  /*senao passa branco*/
                                                               AND c-cod-ctrab <> "":U THEN c-cod-area-produc ELSE "":U),     
                                                      INPUT        c-gm-codigo,  
                                                      INPUT        c-cod-ctrab,        
                                                      INPUT        ?,     /*c-cod-calend*/       
                                                      INPUT-OUTPUT d-dat-termino ,       
                                                      INPUT-OUTPUT i-qtd-segs-termino , 
                                                      INPUT-OUTPUT d-dat-inicio ,       
                                                      INPUT-OUTPUT i-qtd-segs-inicio ,  
                                                      INPUT-OUTPUT de-tempo-aux,
                                                      INPUT         YES,                /*l-cons-parada-prog*/
                                                      INPUT         YES,                /*l-cons-parada-real*/
                                                      INPUT         TODAY,              /*d-dat-corte-parada*/    
                                                      INPUT         TIME).              /*i-qtd-segs-corte-parada*/
    
            ASSIGN split-operac.dat-progda-fim-operac:SCREEN-VALUE IN FRAME f-main = STRING(d-dat-termino,"99/99/9999":U).
    
            RUN pi-sec-to-formatted-time(INPUT i-qtd-segs-termino,
                                         OUTPUT fi-hra-fim-operac).
            IF fi-hra-fim-operac = "":U THEN
                ASSIGN fi-hra-fim-operac = "0000":U.
            DISPLAY fi-hra-fim-operac WITH FRAME f-main.
        END.
    END. /*IF VALID-HANDLE(h-boin469e) AND c-gm-codigo <> "":U*/
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculosDataTerminoDispon V-table-Win 
PROCEDURE calculosDataTerminoDispon :
/*------------------------------------------------------------------------------
  Purpose:     Calcula a data Inicio Disponib Alocacao com base na data TÇrmino
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED(bf_man_204) &THEN
    DEFINE VARIABLE d-dat-inicio       AS DATE    INITIAL ?    NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-inicio  AS INTEGER INITIAL ?    NO-UNDO.
    DEFINE VARIABLE d-dat-termino      AS DATE    INITIAL ?    NO-UNDO.
    DEFINE VARIABLE i-qtd-segs-termino AS INTEGER INITIAL ?    NO-UNDO.
    DEF VAR de-tempo-aux       AS DECIMAL DECIMALS 4 NO-UNDO.

    IF VALID-HANDLE(h-boin469e) AND CAN-FIND(FIRST grup-maquina WHERE grup-maquina.gm-codigo = c-gm-codigo NO-LOCK) THEN DO:

        ASSIGN de-tempo-aux      = ((split-operac.tempo-pad-setup / 3600) +
                                    (split-operac.tempo-pad-operac / 3600))
               d-dat-termino     = INPUT FRAME f-main split-operac.dat-progda-fim-operac.

        /*Se a data inicio for inv†lida, n∆o efetua os calculos*/
        IF d-dat-termino <> ? THEN DO:
    
            RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-fim-operac,
                                         OUTPUT i-qtd-segs-termino).
        
            RUN piCalculaDataHoraTempo IN h-boin469e (INPUT (IF c-cod-area-produc <> ?        /*Se area e ctrab <> "" passa a area,*/ 
                                                               AND c-cod-area-produc <> "":U  /*senao passa branco*/
                                                               AND c-cod-ctrab <> "":U THEN c-cod-area-produc ELSE "":U),     
                                                      INPUT        c-gm-codigo,  
                                                      INPUT        c-cod-ctrab,        
                                                      INPUT        ?,     /*c-cod-calend*/       
                                                      INPUT-OUTPUT d-dat-termino ,      /*input*/  
                                                      INPUT-OUTPUT i-qtd-segs-termino , /*input*/
                                                      INPUT-OUTPUT d-dat-inicio ,       /*output*/
                                                      INPUT-OUTPUT i-qtd-segs-inicio ,  /*output*/
                                                      INPUT-OUTPUT de-tempo-aux,
                                                      INPUT         YES,                /*l-cons-parada-prog*/
                                                      INPUT         YES,                /*l-cons-parada-real*/
                                                      INPUT         TODAY,              /*d-dat-corte-parada*/    
                                                      INPUT         TIME).              /*i-qtd-segs-corte-parada*/
    
            ASSIGN split-operac.dat-progda-inic-setup:SCREEN-VALUE IN FRAME f-main = STRING(d-dat-inicio,"99/99/9999":U).
    
            RUN pi-sec-to-formatted-time(INPUT i-qtd-segs-inicio,
                                         OUTPUT fi-hra-inic-setup).
            DISPLAY fi-hra-inic-setup WITH FRAME f-main.
        END. /*IF d-dat-termino <> ?*/
    END. /*IF VALID-HANDLE(h-boin469e) */
&ENDIF

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

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
  
  /*Elimina o handle*/
  IF VALID-HANDLE(h-boin469e) THEN
      DELETE PROCEDURE h-boin469e.  

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
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DISPLAY label-reportes
        label-imc-fmt
        split-operac.qtd-operac-aprov  
        split-operac.qtd-operac-refgda 
        split-operac.qtd-operac-retrab 
        split-operac.dat-imc
        split-operac.dat-fmt
        WITH FRAME f-main.

ASSIGN fi-reporte-total:SCREEN-VALUE IN FRAME f-main = STRING(split-operac.qtd-operac-aprov  + 
                                                              split-operac.qtd-operac-refgda).

{utp/ut-liter.i In°cio *}
ASSIGN split-operac.dat-imc:LABEL IN FRAME f-main = RETURN-VALUE.
{utp/ut-liter.i TÇrmino *}
ASSIGN split-operac.dat-fmt:LABEL IN FRAME f-main = RETURN-VALUE.

run pi-sec-to-formatted-time (input int(split-operac.qtd-segs-imc),
                              output fi-hra-imc).
DISPLAY fi-hra-imc WITH FRAME f-main.

run pi-sec-to-formatted-time (input int(split-operac.qtd-segs-fmt),
                              output fi-hra-fmt).
DISPLAY fi-hra-fmt WITH FRAME f-main.

ASSIGN fi-reporte-total:SENSITIVE IN FRAME f-main = NO.

&IF DEFINED(bf_man_204) &THEN 
    IF l-mudancas-sfc THEN DO:

        DISPLAY label-inicio-disp
                split-operac.dat-progda-inic-setup
                split-operac.dat-progda-fim-operac
                label-disponivel
                split-operac.dat-produt-dispon WITH FRAME f-main.                

        {utp/ut-liter.i In°cio *}
        ASSIGN split-operac.dat-progda-inic-setup:LABEL IN FRAME f-main = RETURN-VALUE
               split-operac.dat-produt-dispon:LABEL      IN FRAME f-main = RETURN-VALUE.
        {utp/ut-liter.i TÇrmino *}
        ASSIGN split-operac.dat-progda-fim-operac:LABEL IN FRAME f-main = RETURN-VALUE.

        run pi-sec-to-formatted-time (input int(split-operac.qtd-segs-progdo-inic-setup),
                                      output fi-hra-inic-setup).
        DISPLAY fi-hra-inic-setup WITH FRAME f-main.
        
        run pi-sec-to-formatted-time (input int(split-operac.qtd-segs-progdo-fim-operac),
                                      output fi-hra-fim-operac).
        DISPLAY fi-hra-fim-operac WITH FRAME f-main.

        run pi-sec-to-formatted-time (input int(split-operac.qtd-segs-produt-dispon),
                                      output fi-hra-produc-disp).
        DISPLAY fi-hra-produc-disp WITH FRAME f-main.

        ASSIGN fi-hra-imc:SENSITIVE        IN FRAME f-main = NO
               fi-hra-fmt:SENSITIVE        IN FRAME f-main = NO
               fi-hra-inic-setup:SENSITIVE IN FRAME f-main = NO
               fi-hra-fim-operac:SENSITIVE IN FRAME f-main = NO.
    END.
    ELSE DO:
&ENDIF
        /*Esconde campos que pertencem a funcao Mudancas SFC*/
        ASSIGN label-inicio-disp:HIDDEN                   IN FRAME f-main = YES
               split-operac.dat-progda-inic-setup:HIDDEN  IN FRAME f-main = YES
               fi-hra-inic-setup:HIDDEN                   IN FRAME f-main = YES
               split-operac.dat-progda-fim-operac:HIDDEN  IN FRAME f-main = YES    
               fi-hra-fim-operac:HIDDEN                   IN FRAME f-main = YES
               label-disponivel:HIDDEN                    IN FRAME f-main = YES
               split-operac.dat-produt-dispon:HIDDEN      IN FRAME f-main = YES    
               fi-hra-produc-disp:HIDDEN                  IN FRAME f-main = YES
               fi-hra-imc:SENSITIVE                       IN FRAME f-main = NO
               fi-hra-fmt:SENSITIVE                       IN FRAME f-main = NO.

        HIDE rt-key-3
             rt-key-4 IN FRAME f-main.

&IF DEFINED(bf_man_204) &THEN
    END.
&ENDIF
    
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
  
  &IF DEFINED(bf_man_204) &THEN
      /*Verifica se funcao Mudancas SFC est† implantada*/
      RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).
      IF l-mudancas-sfc THEN
          RUN inbo/boin469e.p PERSISTENT SET h-boin469e.
  &ENDIF  

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
    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

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

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeInfoPag1 V-table-Win 
PROCEDURE recebeInfoPag1 :
/*------------------------------------------------------------------------------
  Purpose:     Chamada pela viewer da P†g 1 para setar informaá‰es digitadas l†
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-gm-codigo       LIKE split-operac.gm-codigo NO-UNDO.
DEF INPUT PARAM p-cod-ctrab       LIKE split-operac.cod-ctrab NO-UNDO.
DEF INPUT PARAM p-cod-area-produc LIKE area-produc.cod-area-produc NO-UNDO.
                         
ASSIGN c-gm-codigo       = p-gm-codigo      
       c-cod-ctrab       = p-cod-ctrab      
       c-cod-area-produc = p-cod-area-produc.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCamposEditaveis V-table-Win 
PROCEDURE retornaCamposEditaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/*Data IMC e FMT*/
DEF OUTPUT PARAM p-dat-imc      LIKE split-operac.dat-imc NO-UNDO.
DEF OUTPUT PARAM p-hra-imc      AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-qtd-segs-imc LIKE split-operac.qtd-segs-imc NO-UNDO.
DEF OUTPUT PARAM p-dat-fmt      LIKE split-operac.dat-fmt NO-UNDO.
DEF OUTPUT PARAM p-hra-fmt      AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-qtd-segs-fmt LIKE split-operac.qtd-segs-fmt NO-UNDO.

/*Data Inicio Disponibilidade Alocacao*/
DEF OUTPUT PARAM p-dat-progda-inic-setup      LIKE split-operac.dat-progda-inic-setup NO-UNDO.
DEF OUTPUT PARAM p-hra-inic-operac             AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-qtd-segs-progdo-inic-setup LIKE split-operac.qtd-segs-progdo-inic-setup NO-UNDO.
DEF OUTPUT PARAM p-dat-progda-fim-operac       LIKE split-operac.dat-progda-fim-operac NO-UNDO.
DEF OUTPUT PARAM p-hra-fim-operac              AS CHAR NO-UNDO.
DEF OUTPUT PARAM p-qtd-segs-progdo-fim-operac  LIKE split-operac.qtd-segs-progdo-fim-operac NO-UNDO.

/*Campos calculados apenas na confirmaá∆o*/
DEF OUTPUT PARAM p-dat-progda-inic-operac      LIKE split-operac.dat-progda-inic-operac NO-UNDO.
DEF OUTPUT PARAM p-qtd-segs-progdo-inic-operac LIKE split-operac.qtd-segs-progdo-inic-operac NO-UNDO.

/*Variaveis campos da Pag 1*/
DEF VARIABLE c-cod-ferr-prod LIKE split-operac.cod-ferr-prod NO-UNDO.

&IF DEFINED(bf_man_204) &THEN
    /*Retorna as informaá‰es da P†gina 1*/
    RUN retornaCamposEditaveis IN h-handle-pag-1(OUTPUT c-gm-codigo     ,
                                                 OUTPUT c-cod-ctrab     ,
                                                 OUTPUT c-cod-ferr-prod ,
                                                 OUTPUT c-cod-area-produc).
    /*Reaplica os leaves neste ponto*/
    RUN calculosDataInicDispon.
    RUN calculosDataTerminoDispon.
    RUN calculaCamposConfirmacao(OUTPUT p-dat-progda-inic-operac,     
                                 OUTPUT p-qtd-segs-progdo-inic-operac).
    
    /****************Data IMC e FMT**********************************/
    ASSIGN p-dat-imc       = INPUT FRAME f-main split-operac.dat-imc
           p-hra-imc       = fi-hra-imc:SCREEN-VALUE IN FRAME f-main
           p-dat-fmt       = INPUT FRAME f-main split-operac.dat-fmt
           p-hra-fmt       = fi-hra-fmt:SCREEN-VALUE IN FRAME f-main.
    
    RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-imc,
                                 OUTPUT p-qtd-segs-imc).
    
    RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-fmt,
                                 OUTPUT p-qtd-segs-fmt).
    
    
    /****************Data Disponibilidade Alocacao******************/
    ASSIGN p-dat-progda-inic-setup        = INPUT FRAME f-main split-operac.dat-progda-inic-setup
           p-hra-inic-operac              = fi-hra-inic-setup:SCREEN-VALUE IN FRAME f-main
           p-dat-progda-fim-operac        = INPUT FRAME f-main split-operac.dat-progda-fim-operac
           p-hra-fim-operac               = fi-hra-fim-operac:SCREEN-VALUE IN FRAME f-main.
    
    RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-inic-setup,
                                 OUTPUT p-qtd-segs-progdo-inic-setup).
    
    RUN pi-formatted-time-to-sec(INPUT INPUT FRAME f-main fi-hra-fim-operac,
                                 OUTPUT p-qtd-segs-progdo-fim-operac).
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaDatInicDisponib V-table-Win 
PROCEDURE retornaDatInicDisponib :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-dat-progda-inic-setup AS DATE INIT ? NO-UNDO.

IF INPUT FRAME f-main split-operac.dat-progda-inic-setup <> ? THEN
    ASSIGN p-dat-progda-inic-setup = INPUT FRAME f-main split-operac.dat-progda-inic-setup.

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
  {src/adm/template/snd-list.i "split-operac"}

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
DEF INPUT PARAM p-handle-pai AS HANDLE NO-UNDO.

ASSIGN h-handle-pai = p-handle-pai.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaModificacao V-table-Win 
PROCEDURE setaModificacao :
/*------------------------------------------------------------------------------
  Purpose:     chamada pelo sf0311c.w, quando o mesmo Ç chamado do CP0301 - Funcao Mudancas SFC
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle-pag-1 AS HANDLE NO-UNDO.

&IF DEFINED(bf_man_204) &THEN
    IF l-mudancas-sfc AND 
        AVAIL split-operac AND 
        split-operac.ind-estado-split < 4 THEN DO WITH FRAME f-main:
        ASSIGN h-handle-pag-1                                                =  p-handle-pag-1
               split-operac.dat-imc:SENSITIVE                IN FRAME f-main = YES
               split-operac.dat-fmt:SENSITIVE                IN FRAME f-main = YES
               fi-hra-imc:SENSITIVE                          IN FRAME f-main = YES
               fi-hra-fmt:SENSITIVE                          IN FRAME f-main = YES
               split-operac.dat-progda-inic-setup:SENSITIVE IN FRAME f-main  = YES 
               split-operac.dat-progda-fim-operac:SENSITIVE  IN FRAME f-main = YES 
               fi-hra-inic-setup:SENSITIVE                  IN FRAME f-main  = YES 
               fi-hra-fim-operac:SENSITIVE                   IN FRAME f-main = YES.

        IF VALID-HANDLE(p-handle-pag-1) THEN
            /*Faz a viewer da pag 1 enviar as informacoes para a pag 3. As mesmas 
              informaá‰es ser∆o sempre atualizadas nos leaves dos campos*/
            RUN enviaInfoPag3 IN p-handle-pag-1.
    END.
    ELSE
&ENDIF
        ASSIGN fi-hra-imc:SENSITIVE IN FRAME f-main = NO
               fi-hra-fmt:SENSITIVE IN FRAME f-main = NO
               fi-hra-inic-setup:SENSITIVE IN FRAME f-main = NO
               fi-hra-fim-operac:SENSITIVE IN FRAME f-main = NO
               fi-hra-produc-disp:SENSITIVE IN FRAME f-main = NO.

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

