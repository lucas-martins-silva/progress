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
{include/i-prgvrs.i V02IN528 2.00.01.011}  /*** "010111" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN528 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def new global shared var gr-area-produc      as rowid no-undo.

def var v-row-parent     as rowid no-undo.
def var rw-area          as rowid no-undo.
def var c-label          as char  no-undo.
def var rw-rep-par       as rowid no-undo.
def var v-dat-ult-event  as date  no-undo.
def var v-hra-ult-event  as char  no-undo.

def buffer b-rep-parada-geral for rep-parada-geral.

{inbo/boin528.i} /*tt-rep-parada-ctrab*/

define variable h-bomf528 as handle no-undo.
DEFINE VARIABLE c-aux AS CHARACTER  NO-UNDO.
{cdp/cdcfgman.i}
{sfc/sf0309.i} /*Funcao para tratamento de leave dos campos de hora*/
DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL    NO-UNDO.

DEFINE VARIABLE l-reanalise AS LOGICAL INIT NO NO-UNDO.

{method/dbotterr.i}

DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.

DEF NEW GLOBAL SHARED VAR h-sf0304 AS HANDLE NO-UNDO.

def new global shared var gr-rep-parada-geral-reanalise as rowid no-undo.

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
&Scoped-define EXTERNAL-TABLES rep-parada-geral
&Scoped-define FIRST-EXTERNAL-TABLE rep-parada-geral


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR rep-parada-geral.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS rep-parada-geral.dat-inic-parada ~
rep-parada-geral.dat-fim-parada rep-parada-geral.cod-parada 
&Scoped-define ENABLED-TABLES rep-parada-geral
&Scoped-define FIRST-ENABLED-TABLE rep-parada-geral
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS rep-parada-geral.cod-area-produc ~
rep-parada-geral.dat-inic-parada rep-parada-geral.hra-inic-parada ~
rep-parada-geral.dat-fim-parada rep-parada-geral.hra-fim-parada ~
rep-parada-geral.cod-parada 
&Scoped-define DISPLAYED-TABLES rep-parada-geral
&Scoped-define FIRST-DISPLAYED-TABLE rep-parada-geral
&Scoped-Define DISPLAYED-OBJECTS c-desc-area c-desc-parada 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS rep-parada-geral.hra-inic-parada ~
rep-parada-geral.hra-fim-parada 
&Scoped-define ADM-MODIFY-FIELDS rep-parada-geral.dat-inic-parada ~
rep-parada-geral.hra-inic-parada rep-parada-geral.dat-fim-parada ~
rep-parada-geral.hra-fim-parada rep-parada-geral.cod-parada 

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
DEFINE VARIABLE c-desc-area AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rep-parada-geral.cod-area-produc AT ROW 1.17 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-area AT ROW 1.17 COL 33 COLON-ALIGNED NO-LABEL
     rep-parada-geral.dat-inic-parada AT ROW 2.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rep-parada-geral.hra-inic-parada AT ROW 2.75 COL 33.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rep-parada-geral.dat-fim-parada AT ROW 3.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     rep-parada-geral.hra-fim-parada AT ROW 3.75 COL 33.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     rep-parada-geral.cod-parada AT ROW 4.75 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-desc-parada AT ROW 4.75 COL 33.14 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.rep-parada-geral
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
         HEIGHT             = 5
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-desc-area IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-parada-geral.cod-area-produc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN rep-parada-geral.cod-parada IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN rep-parada-geral.dat-fim-parada IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN rep-parada-geral.dat-inic-parada IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN rep-parada-geral.hra-fim-parada IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN rep-parada-geral.hra-inic-parada IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME rep-parada-geral.cod-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.cod-parada V-table-Win
ON F5 OF rep-parada-geral.cod-parada IN FRAME f-main /* Parada */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in510.w"
                       &campo=rep-parada-geral.cod-parada
                       &campozoom=cod-parada
                       &campo=c-desc-parada
                       &campozoom=des-parada}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.cod-parada V-table-Win
ON LEAVE OF rep-parada-geral.cod-parada IN FRAME f-main /* Parada */
DO:
  {include/leave.i &tabela=motiv-parada 
                   &atributo-ref=des-parada
                   &variavel-ref=c-desc-parada
                   &where="motiv-parada.cod-parada = input frame {&frame-name} rep-parada-geral.cod-parada"}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.cod-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF rep-parada-geral.cod-parada IN FRAME f-main /* Parada */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rep-parada-geral.dat-inic-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.dat-inic-parada V-table-Win
ON LEAVE OF rep-parada-geral.dat-inic-parada IN FRAME f-main /* Data In¡cio Parada */
DO:
    ASSIGN rep-parada-geral.dat-fim-parada:screen-value in frame {&frame-name} =
        string(input frame {&frame-name} rep-parada-geral.dat-inic-parada) 
        WHEN input frame {&frame-name} rep-parada-geral.dat-inic-parada > input frame {&frame-name} rep-parada-geral.dat-fim-parada.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rep-parada-geral.hra-fim-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.hra-fim-parada V-table-Win
ON ALT-O OF rep-parada-geral.hra-fim-parada IN FRAME f-main /* Hora Fim Parada */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.hra-fim-parada V-table-Win
ON LEAVE OF rep-parada-geral.hra-fim-parada IN FRAME f-main /* Hora Fim Parada */
DO:
        ASSIGN l-erro = NO.
        ASSIGN c-aux = fnValidaHora(rep-parada-geral.hra-fim-parada:SCREEN-VALUE IN FRAME f-main).
        IF c-aux = ? THEN DO:
        
             IF NOT AVAIL param-sfc THEN
                 FIND FIRST param-sfc NO-LOCK NO-ERROR.
        
             if param-sfc.log-tipo-relogio THEN       
                 run utp/ut-msgs.p (input "show":U,
                                    input 29520,
                                    input "":U).
             ELSE                                            
                 run utp/ut-msgs.p (input "show":U,
                                    input 32081,
                                    input "":U).
        
            APPLY "ENTRY":U to rep-parada-geral.hra-fim-parada in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.
        END.
        
        DISPLAY c-aux @ rep-parada-geral.hra-fim-parada WITH frame f-main.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.hra-fim-parada V-table-Win
ON RETURN OF rep-parada-geral.hra-fim-parada IN FRAME f-main /* Hora Fim Parada */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rep-parada-geral.hra-inic-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.hra-inic-parada V-table-Win
ON ALT-O OF rep-parada-geral.hra-inic-parada IN FRAME f-main /* Hora In¡cio Parada */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.hra-inic-parada V-table-Win
ON LEAVE OF rep-parada-geral.hra-inic-parada IN FRAME f-main /* Hora In¡cio Parada */
DO:
        ASSIGN l-erro = NO.
        ASSIGN c-aux = fnValidaHora(rep-parada-geral.hra-inic-parada:SCREEN-VALUE IN FRAME f-main).
        IF c-aux = ? THEN DO:
        
             IF NOT AVAIL param-sfc THEN
                 FIND FIRST param-sfc NO-LOCK NO-ERROR.
        
             if param-sfc.log-tipo-relogio THEN       
                 run utp/ut-msgs.p (input "show":U,
                                    input 29520,
                                    input "":U).
             ELSE                                            
                 run utp/ut-msgs.p (input "show":U,
                                    input 32081,
                                    input "":U).
        
            APPLY "ENTRY":U to rep-parada-geral.hra-inic-parada in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.
        END.
        
        DISPLAY c-aux @ rep-parada-geral.hra-inic-parada WITH frame f-main.
  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rep-parada-geral.hra-inic-parada V-table-Win
ON RETURN OF rep-parada-geral.hra-inic-parada IN FRAME f-main /* Hora In¡cio Parada */
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

rep-parada-geral.cod-parada:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "rep-parada-geral"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "rep-parada-geral"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE efetivaReanalise V-table-Win 
PROCEDURE efetivaReanalise :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
EMPTY TEMP-TABLE rowErrors.

RUN reanaliseParadaGeral in h-bomf528(INPUT ROWID(rep-parada-geral),
                                      INPUT rep-parada-geral.cod-parada:SCREEN-VALUE IN FRAME f-main,
                                      OUTPUT TABLE rowErrors).
IF RETURN-VALUE = "NOK":U THEN DO:
    
    IF CAN-FIND(FIRST rowErrors) THEN DO:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="''"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.  
    END.

    APPLY "entry":U TO rep-parada-geral.cod-parada IN FRAME f-main.

    RETURN "NOK":U.
END.

IF VALID-HANDLE(h-sf0304) THEN DO:
    ASSIGN gr-rep-parada-geral-reanalise = ROWID(rep-parada-geral).
    RUN reposiciona IN h-sf0304 NO-ERROR.
END.

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

  if avail area-produc then do:
        disp area-produc.cod-area-produc @ rep-parada-geral.cod-area-produc
             area-produc.des-area-produc @ c-desc-area with frame {&frame-name}.
          
        run pi-det-ultimo-event (output v-dat-ult-event,
                                 output v-hra-ult-event).
            
        if v-dat-ult-event = ? then  
            assign v-dat-ult-event = today
                   v-hra-ult-event = "0000".
    
        assign rep-parada-geral.dat-inic-parada:screen-value in frame {&frame-name} = string(v-dat-ult-event,"99/99/9999")
               rep-parada-geral.dat-fim-parada:screen-value in frame {&frame-name} = string(v-dat-ult-event,"99/99/9999").
    
        disp v-hra-ult-event @ rep-parada-geral.hra-inic-parada
             v-hra-ult-event @ rep-parada-geral.hra-fim-parada
             with frame {&frame-name}.
  end.          
          
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /** variaveis CDAPI005 **/
    def var    da-iniper-x        as date no-undo.      
    def var    da-fimper-x        as date no-undo.    
    def var    i-per-corrente     as int no-undo.  
    def var    i-ano-corrente     as int no-undo. 
    def var    da-aux-ini         as date no-undo.
    def var    da-aux-fim         as date no-undo.
    DEF VAR    c-ult-per-fech     AS CHAR NO-UNDO.
    DEF VAR    l-permite-mov-period-fech  AS LOGICAL NO-UNDO.

    find last param-estoq no-lock no-error.
    
    ASSIGN c-ult-per-fech = param-estoq.ult-per-fech.
    
    IF avail param-estoq AND param-estoq.tp-fech = 2 THEN DO:
        FIND FIRST estab-mat 
             WHERE estab-mat.cod-estabel = area-produc.cod-estabel NO-LOCK NO-ERROR.
    
        IF AVAIL estab-mat THEN DO:
            ASSIGN c-ult-per-fech = estab-mat.ult-per-fech.
        END.
    END.

    /* Code placed here will execute PRIOR to standard behavior. */
    /*{include/i-valid.i}*/
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.    

    ASSIGN l-permite-mov-period-fech = param-sfc.log-parada-atualiza-ggf = NO AND SUBSTRING(param-sfc.char-1,34,1) = "N":U.
 
    RUN cdp/cdapi005.p (input  c-ult-per-fech ,
                        output da-iniper-x    ,
                        output da-fimper-x    ,
                        output i-per-corrente ,
                        output i-ano-corrente ,
                        output da-aux-ini     ,
                        output da-aux-fim     ).
    
    IF input frame {&frame-name} rep-parada-geral.dat-fim-parada < da-aux-fim THEN DO:

        IF l-permite-mov-period-fech THEN DO:
    
            {utp/ut-liter.i T‚rmino * }
        
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 56451,
                              INPUT RETURN-VALUE).
        
            IF RETURN-VALUE <> "YES":U THEN DO:
                return 'ADM-ERROR':U.
            END.
        END.
        ELSE DO:
            run utp/ut-msgs.p (input 'show',
                                INPUT 2598,
                                input "").
            return 'ADM-ERROR':U.
        END.
    END.
    ELSE IF input frame {&frame-name} rep-parada-geral.dat-inic-parada < da-aux-fim THEN DO:

        IF l-permite-mov-period-fech THEN DO:
    
            {utp/ut-liter.i "In¡cio * }
        
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 56451,
                              INPUT RETURN-VALUE).
        
            IF RETURN-VALUE <> "YES":U THEN DO:
               return 'ADM-ERROR':U.
            END.
        END.
        ELSE do:
             run utp/ut-msgs.p (input 'show',
                                INPUT 2598,
                                input "").
            return 'ADM-ERROR':U.
        END.
    END.
    
    if input frame {&frame-name} rep-parada-geral.dat-inic-parada > today then do:
       {utp/ut-table.i movind rep-parada-geral 01}
       run utp/ut-msgs.p (input 'show',
                          input 18016,
                          input return-value).
       apply 'entry' to rep-parada-geral.dat-inic-parada in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    
    if input frame {&frame-name} rep-parada-geral.dat-inic-parada > 
       input frame {&frame-name} rep-parada-geral.dat-fim-parada then do:
       {utp/ut-field.i movind rep-parada-geral dat-fim-parada 01}
       assign c-label = trim(return-value).
       {utp/ut-field.i movind rep-parada-geral dat-inic-parada 01}
       run utp/ut-msgs.p (input 'show',
                          input 416,
                          input c-label + "~~" + return-value).
       apply 'entry' to rep-parada-geral.dat-fim-parada in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    
    if input frame {&frame-name} rep-parada-geral.dat-inic-parada  =
       input frame {&frame-name} rep-parada-geral.dat-fim-parada  and
       input frame {&frame-name} rep-parada-geral.hra-inic-parada >=
       input frame {&frame-name} rep-parada-geral.hra-fim-parada then do:
       {utp/ut-field.i movind rep-parada-geral hra-fim-parada 01}
       assign c-label = trim(return-value).
       {utp/ut-field.i movind rep-parada-geral hra-inic-parada 01}
       run utp/ut-msgs.p (input 'show',
                          input 416,
                          input c-label + "~~" + return-value).
       apply 'entry' to rep-parada-geral.hra-fim-parada in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.    
    
    /* Area Producao */
    find motiv-parada 
       where motiv-parada.cod-parada = rep-parada-geral.cod-parada:screen-value in frame {&frame-name} 
       no-lock no-error.
    if not avail motiv-parada then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 2, 
                           input trim(rep-parada-geral.cod-parada:label in frame {&frame-name}) +
                                 "~~" + 
                                 rep-parada-geral.cod-parada:screen-value in frame {&frame-name} ).
        apply 'entry' to rep-parada-geral.cod-parada in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    if motiv-parada.parada-setup then do:                            
       run utp/ut-msgs.p (input "show",
                          input 27139,
                          input "").
       apply 'entry' to rep-parada-geral.cod-parada in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
     
    assign rw-rep-par  = rowid(rep-parada-geral).
    run goToRowid in h-bomf528(input rw-rep-par). 
    run CriarReporteParadaGeral in h-bomf528 (buffer rep-parada-geral).
    
    if avail rep-parada-geral then
        run sfc/sf0304b.w (input rw-rep-par).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign rep-parada-geral.cod-area-produc = area-produc.cod-area-produc.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  run EliminarReporteParadaGeral(buffer rep-parada-geral).
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
{method/showmessage.i3}

  /* Code placed here will execute PRIOR to standard behavior. */
if valid-handle(h-bomf528) then
    run destroy in h-bomf528.
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
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  if avail rep-parada-geral and not adm-new-record then do:
     find first motiv-parada
          where motiv-parada.cod-parada = rep-parada-geral.cod-parada no-lock no-error.
     assign c-desc-parada = if avail motiv-parada 
                            then motiv-parada.des-parada
                            else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first motiv-parada
       where motiv-parada.cod-parada = input frame {&frame-name} rep-parada-geral.cod-parada no-lock no-error.
  assign c-desc-parada:screen-value in frame {&frame-name} = if avail motiv-parada 
                                                                then motiv-parada.des-parada
                                                                else "":U.

  if avail area-produc then 
     disp area-produc.cod-area-produc @ rep-parada-geral.cod-area-produc
          area-produc.des-area-produc @ c-desc-area with frame {&frame-name}.

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
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF l-reanalise THEN DO:

        DISABLE ALL WITH FRAME f-main.
        ASSIGN rep-parada-geral.cod-parada:SENSITIVE IN FRAME f-main = YES.

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

  /* Code placed here will execute PRIOR to standard behavior. */
 
  assign rep-parada-geral.cod-parada:sensitive in frame {&frame-name} = no
         rw-area = gr-area-produc.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    if not valid-handle(h-bomf528) then
        run mfbo/bomf528.p persistent set h-bomf528.
     run openQueryStatic in h-bomf528(input "Main":U).
     
  /* Code placed here will execute AFTER standard behavior.    */

  if rw-area <> ? then
     find first area-produc
          where rowid(area-produc) = rw-area no-lock no-error.
  
  find first param-sfc no-lock no-error.

  IF param-sfc.log-tipo-relogio = NO THEN
      ASSIGN rep-parada-geral.hra-inic-parada:FORMAT IN FRAME f-main = "99,99":U
             rep-parada-geral.hra-fim-parada:FORMAT  IN FRAME f-main = "99,99":U.
  
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-det-ultimo-event V-table-Win 
PROCEDURE pi-det-ultimo-event :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param v-dat-ult-event as date no-undo.
    def output param v-hra-ult-event as char no-undo.

    def var v-val-dat-atual as decimal no-undo.

    find first b-rep-parada-geral use-index area
        where  b-rep-parada-geral.cod-area-produc = area-produc.cod-area-produc no-lock no-error.
     
    if  not avail b-rep-parada-geral or b-rep-parada-geral.dat-fim-parada < today then  
        assign v-dat-ult-event = today
               v-hra-ult-event = "0000".
    else
        assign v-dat-ult-event = b-rep-parada-geral.dat-fim-parada
               v-hra-ult-event = b-rep-parada-geral.hra-fim-parada.
               
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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
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
  {src/adm/template/snd-list.i "rep-parada-geral"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaReanalise V-table-Win 
PROCEDURE setaReanalise :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN l-reanalise = YES.

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

