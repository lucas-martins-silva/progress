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
{include/i-prgvrs.i V01IN529 2.00.00.011 } /*** 010011 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN529 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.

def var h-boin469b as handle no-undo.

def var de-qtd-tempo-util    like rep-parada-ctrab.qtd-tempo-parada.
def var de-qtd-segs-inic     as dec no-undo.
def var de-qtd-segs-fim      as dec no-undo.
def var de-val-refer-fim     as dec no-undo.
def var de-val-refer-inic    as dec no-undo.
def var v-dat-ult-event      as date no-undo.
def var v-qtd-segs-ult-event as dec  no-undo.
def var i-num-om             as int  no-undo.
def var h-boin529            as handle no-undo.
DEF VAR l-sfc-mudancas       AS LOG INIT NO NO-UNDO.

{cdp/cd0666.i}

{cdp/cdcfgman.i}

&IF DEFINED(bf_man_204) &THEN
    {sfc/sf0309.i} /*Funcao para tratamento de leave dos campos de hora*/
    {inbo/boin529.i tt-man-progda-ctrab}
    {method/dbotterr.i} /*  RowErrors */
&ENDIF

def var da-ini-aux as date.
def var da-fim-aux as date.
def var c-cod-calend as char no-undo.
def var c-gm-codigo  as char no-undo.
def var c-cod-area   as char no-undo.

DEFINE VARIABLE h-pag-2 AS HANDLE     NO-UNDO.

DEFINE VARIABLE hShowMsg     AS HANDLE     NO-UNDO.
DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL    NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES man-progda-ctrab
&Scoped-define FIRST-EXTERNAL-TABLE man-progda-ctrab


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR man-progda-ctrab.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS man-progda-ctrab.cod-parada ~
man-progda-ctrab.dat-progda-inic man-progda-ctrab.dat-progda-fim 
&Scoped-define ENABLED-TABLES man-progda-ctrab
&Scoped-define FIRST-ENABLED-TABLE man-progda-ctrab
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS man-progda-ctrab.cod-ctrab ~
man-progda-ctrab.num-om-progda man-progda-ctrab.cod-parada ~
man-progda-ctrab.dat-progda-inic man-progda-ctrab.dat-progda-fim 
&Scoped-define DISPLAYED-TABLES man-progda-ctrab
&Scoped-define FIRST-DISPLAYED-TABLE man-progda-ctrab
&Scoped-Define DISPLAYED-OBJECTS c-des-ctrab c-des-parada c-hra-inic ~
c-hra-fim de-tempo-util 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS man-progda-ctrab.cod-parada ~
man-progda-ctrab.dat-progda-inic c-hra-inic man-progda-ctrab.dat-progda-fim ~
c-hra-fim 

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
DEFINE VARIABLE c-des-ctrab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-fim AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-inic AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-tempo-util AS DECIMAL FORMAT "->,>>9.999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     man-progda-ctrab.cod-ctrab AT ROW 1.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-des-ctrab AT ROW 1.17 COL 42.57 COLON-ALIGNED NO-LABEL
     man-progda-ctrab.num-om-progda AT ROW 2.17 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     man-progda-ctrab.cod-parada AT ROW 3.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.14 BY .88
     c-des-parada AT ROW 3.67 COL 37.57 COLON-ALIGNED NO-LABEL
     man-progda-ctrab.dat-progda-inic AT ROW 4.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-hra-inic AT ROW 4.67 COL 38 COLON-ALIGNED NO-LABEL
     man-progda-ctrab.dat-progda-fim AT ROW 5.67 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     c-hra-fim AT ROW 5.67 COL 38 COLON-ALIGNED NO-LABEL
     de-tempo-util AT ROW 5.67 COL 55 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.man-progda-ctrab
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
         HEIGHT             = 5.83
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
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hra-fim IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN c-hra-inic IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN man-progda-ctrab.cod-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-progda-ctrab.cod-parada IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN man-progda-ctrab.dat-progda-fim IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN man-progda-ctrab.dat-progda-inic IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN de-tempo-util IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN man-progda-ctrab.num-om-progda IN FRAME f-main
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

&Scoped-define SELF-NAME c-hra-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-fim V-table-Win
ON ALT-O OF c-hra-fim IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-fim V-table-Win
ON LEAVE OF c-hra-fim IN FRAME f-main
DO:
    find last param-sfc no-lock no-error.

    ASSIGN l-erro = NO.
    &IF DEFINED(bf_man_204) &THEN
        ASSIGN c-hra-fim = fnValidaHora(c-hra-fim:SCREEN-VALUE IN FRAME f-main).
        IF c-hra-fim = ? THEN DO:
        
             if param-sfc.log-tipo-relogio THEN       
                 run utp/ut-msgs.p (input "show":U,
                                    input 29520,
                                    input "":U).
             ELSE                                            
                 run utp/ut-msgs.p (input "show":U,
                                    input 32081,
                                    input "":U).
        
            APPLY "ENTRY":U to c-hra-fim in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.
        END.
        
        DISPLAY c-hra-fim WITH FRAME f-main.    
    &else

        if  substr(input c-hra-fim,1,2) > '23'
        or (param-sfc.log-tipo-relogio
        and substr(input c-hra-fim,3,2) > '59') then do:
            run utp/ut-msgs.p (input "show":U, 
                               input 3046, 
                               input return-value).
            apply 'entry' to c-hra-fim in frame {&frame-name}.
            return no-apply.
        end.

    &ENDIF
    
    if  param-sfc.log-tipo-relogio then do:
        run pi-formatted-time-to-sec (input input c-hra-inic,
                                      output de-qtd-segs-inic).
        run pi-formatted-time-to-sec (input input c-hra-fim,
                                      output de-qtd-segs-fim).
    end.
    else
        assign de-qtd-segs-inic = integer(input frame {&frame-name} c-hra-inic) * 36
               de-qtd-segs-fim  = integer(input frame {&frame-name} c-hra-fim)  * 36.

    if  input frame {&frame-name} man-progda-ctrab.dat-progda-inic <> ?
    and input frame {&frame-name} man-progda-ctrab.dat-progda-fim  <> ? then do:
        assign de-qtd-tempo-util = ?
               da-ini-aux = date(string(input frame {&frame-name} man-progda-ctrab.dat-progda-inic,"99/99/9999"))
               da-fim-aux = date(string(input frame {&frame-name} man-progda-ctrab.dat-progda-fim,"99/99/9999")).

        assign c-cod-calend = ?
               c-cod-area   = ?
               c-gm-codigo  = ctrab.gm-codigo.
        run CalcularTemposCtrab in h-boin469b (input-output c-cod-area,
                                               input-output c-gm-codigo,
                                               input        ctrab.cod-ctrab,
                                               input-output c-cod-calend,
                                               Input-output da-fim-aux,
                                               Input-output de-qtd-segs-fim,
                                               Input-output da-ini-aux,
                                               Input-output de-qtd-segs-inic,
                                               Input-output de-qtd-tempo-util).

        disp de-qtd-tempo-util @ de-tempo-util
             with frame {&frame-name}.
    end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-fim V-table-Win
ON RETURN OF c-hra-fim IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-inic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inic V-table-Win
ON ALT-O OF c-hra-inic IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inic V-table-Win
ON LEAVE OF c-hra-inic IN FRAME f-main
DO:
  ASSIGN l-erro = NO.
  &IF DEFINED(bf_man_204) &THEN
       ASSIGN c-hra-inic = fnValidaHora(c-hra-inic:SCREEN-VALUE IN FRAME f-main).
       IF c-hra-inic = ? THEN DO:
    
            if param-sfc.log-tipo-relogio THEN       
                run utp/ut-msgs.p (input "show":U,
                                   input 29520,
                                   input "":U).
            ELSE                                            
                run utp/ut-msgs.p (input "show":U,
                                   input 32081,
                                   input "":U).
    
           APPLY "ENTRY":U to c-hra-inic in frame f-main.
           ASSIGN l-erro = YES.
           RETURN NO-APPLY.
       END.
    
       DISPLAY c-hra-inic WITH FRAME f-main.
  &else
       IF NOT AVAIL param-sfc THEN
           find last param-sfc no-lock no-error.
      
       if (param-sfc.log-tipo-relogio 
       and substr(input c-hra-inic,3,2) > '59')
       or  substr(input c-hra-inic,1,2) > '23' then do:
    
           run utp/ut-msgs.p (input "show":U, 
                              input 3046, 
                              input return-value).
           apply 'entry' to c-hra-inic in frame {&frame-name}.
           return no-apply.
       end.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inic V-table-Win
ON RETURN OF c-hra-inic IN FRAME f-main
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-progda-ctrab.cod-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-progda-ctrab.cod-parada V-table-Win
ON F5 OF man-progda-ctrab.cod-parada IN FRAME f-main /* Parada */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in510.w"
                     &campo=man-progda-ctrab.cod-parada
                     &campozoom=cod-parada
                     &campo2=c-des-parada
                     &campozoom2=des-parada}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-progda-ctrab.cod-parada V-table-Win
ON LEAVE OF man-progda-ctrab.cod-parada IN FRAME f-main /* Parada */
DO:
  {include/leave.i &tabela=motiv-parada 
                   &atributo-ref=des-parada
                   &variavel-ref=c-des-parada
                   &where="motiv-parada.cod-parada = input frame {&frame-name} man-progda-ctrab.cod-parada"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-progda-ctrab.cod-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF man-progda-ctrab.cod-parada IN FRAME f-main /* Parada */
DO:
  apply 'F5' to self. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-progda-ctrab.dat-progda-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-progda-ctrab.dat-progda-fim V-table-Win
ON LEAVE OF man-progda-ctrab.dat-progda-fim IN FRAME f-main /* Fim */
DO:
    IF INPUT FRAME f-main man-progda-ctrab.dat-progda-fim > (INPUT FRAME f-main man-progda-ctrab.dat-progda-inic + 365 * 2) THEN DO:
        DISP man-progda-ctrab.dat-progda-inic + 365 * 2 @ man-progda-ctrab.dat-progda-fim WITH FRAME {&FRAME-NAME}.
        run utp/ut-msgs.p (input "show":U, 
                           input 27615, 
                           input "").
        apply 'entry' to man-progda-ctrab.dat-progda-fim in frame {&frame-name}.
        return no-apply.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME man-progda-ctrab.dat-progda-inic
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL man-progda-ctrab.dat-progda-inic V-table-Win
ON LEAVE OF man-progda-ctrab.dat-progda-inic IN FRAME f-main /* In¡cio */
DO:
    assign man-progda-ctrab.dat-progda-fim:screen-value in frame {&frame-name} = 
        input frame {&frame-name} man-progda-ctrab.dat-progda-inic WHEN
        input frame {&frame-name} man-progda-ctrab.dat-progda-inic > input frame {&frame-name} man-progda-ctrab.dat-progda-fim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Parada_Programada * R}
assign man-progda-ctrab.num-om-progda:label in frame {&frame-name} = trim(return-value).

{utp/ut-field.i movind man-progda-ctrab qtd-tempo-maq 01}
assign de-tempo-util:label in frame {&frame-name} = return-value.

man-progda-ctrab.cod-parada:load-mouse-pointer ("image~\lupa.cur":U) in frame {&frame-name}.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

{sfc/sf9000.i} /* pi-formatted-time-to-sec */
{sfc/sf9002.i} /* pi-converte-data-segs-valor */


ASSIGN l-sfc-mudancas = FALSE.

FIND FIRST param-global NO-LOCK NO-ERROR.

&IF DEFINED(bf_man_204) &THEN
    RUN sfc/sf9999.p(OUTPUT l-sfc-mudancas).
&ENDIF

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
  {src/adm/template/row-list.i "man-progda-ctrab"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "man-progda-ctrab"}

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

  def buffer b-man-progda-ctrab for man-progda-ctrab.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    if  avail ctrab then do:
        disp ctrab.cod-ctrab @ man-progda-ctrab.cod-ctrab
             ctrab.des-ctrab @ c-des-ctrab
             with frame {&frame-name}.

        find last b-man-progda-ctrab
            where b-man-progda-ctrab.cod-ctrab = ctrab.cod-ctrab no-lock no-error.
        if  not avail b-man-progda-ctrab then
            assign man-progda-ctrab.num-om-progda:screen-value in frame {&frame-name} = '1'
                   i-num-om = 1.
        else
            assign man-progda-ctrab.num-om-progda:screen-value in frame {&frame-name} = 
                                                  string(b-man-progda-ctrab.num-om-progda + 1)
                   i-num-om = b-man-progda-ctrab.num-om-progda + 1.

        run pi-det-ultimo-evento (output v-dat-ult-event,
                                  output v-qtd-segs-ult-event).
            
        if  v-dat-ult-event = ? then  
            assign v-dat-ult-event      = today
                   v-qtd-segs-ult-event = 0.

        find last param-sfc no-lock.
          
        if  param-sfc.log-tipo-relogio then do:
            run pi-sec-to-formatted-time (Input v-qtd-segs-ult-event,
                                          output c-hra-inic).
        end.    
        else
            assign c-hra-inic = string(int(v-qtd-segs-ult-event / 36),"9999").
            
        assign c-hra-fim = c-hra-inic
               man-progda-ctrab.dat-progda-inic:screen-value in frame {&frame-name} = string(v-dat-ult-event,"99/99/9999")
               man-progda-ctrab.dat-progda-fim:screen-value in frame {&frame-name} = string(v-dat-ult-event,"99/99/9999").

        disp c-hra-inic
             c-hra-fim
             with frame {&frame-name}.


        IF l-sfc-mudancas THEN
            RUN new-state ("display-manut").

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

def var da-ini-aux as date.
def var da-fim-aux as date.
DEFINE VARIABLE i-nr-ord-produ AS INTEGER    NO-UNDO.

DEFINE VARIABLE l-modif AS LOGICAL INIT NO NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    if  not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.
    
    /* Ponha na pi-validate todas as valida‡äes */
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

  &IF DEFINED(bf_man_204) &THEN
/*     IF l-sfc-mudancas THEN DO: */

        /*Valida e efetiva via BO quando funcao Mudancas SFC implantado.*/

        FOR EACH tt-man-progda-ctrab: DELETE tt-man-progda-ctrab. END.

        RUN openQueryStatic IN h-boin529("Main":U).

        RUN goToKey IN h-boin529(INPUT INPUT FRAME f-main man-progda-ctrab.cod-ctrab,
                                 INPUT INPUT FRAME f-main man-progda-ctrab.num-om-progda).

        IF RETURN-VALUE = "OK":U THEN DO:
            ASSIGN l-modif = YES.
            RUN getRecord IN h-boin529(OUTPUT TABLE tt-man-progda-ctrab).
            FIND FIRST tt-man-progda-ctrab NO-ERROR.
        END.
        ELSE DO:
            ASSIGN l-modif = NO.
            CREATE tt-man-progda-ctrab.
            ASSIGN tt-man-progda-ctrab.cod-ctrab     = INPUT FRAME f-main man-progda-ctrab.cod-ctrab
                   tt-man-progda-ctrab.num-om-progda = INPUT FRAME f-main man-progda-ctrab.num-om-progda.
        END.

        ASSIGN tt-man-progda-ctrab.cod-parada      = INPUT FRAME f-main man-progda-ctrab.cod-parada
               tt-man-progda-ctrab.dat-progda-inic = INPUT FRAME f-main man-progda-ctrab.dat-progda-inic
               tt-man-progda-ctrab.dat-progda-fim  = INPUT FRAME f-main man-progda-ctrab.dat-progda-fim.

        IF NOT AVAIL param-sfc THEN
            find last param-sfc no-lock no-error.                                             
                                                                                          
        if  param-sfc.log-tipo-relogio then do:                                           
            run pi-formatted-time-to-sec (input INPUT FRAME f-main c-hra-inic,                               
                                          output tt-man-progda-ctrab.qtd-segs-progda-inic).  
            run pi-formatted-time-to-sec (input INPUT FRAME f-main c-hra-fim,                                
                                          output tt-man-progda-ctrab.qtd-segs-progda-fim).   
        end.                                                                              
        else                                                                              
            assign tt-man-progda-ctrab.qtd-segs-progda-inic = int(INPUT FRAME f-main c-hra-inic) * 36           
                   tt-man-progda-ctrab.qtd-segs-progda-fim  = int(INPUT FRAME f-main c-hra-fim)  * 36. 

        IF l-sfc-mudancas AND VALID-HANDLE(h-pag-2) AND param-global.modulo-mi THEN DO:
            RUN retornaOrdManut IN h-pag-2(OUTPUT i-nr-ord-produ).
            RUN setaOrdManut IN h-boin529(INPUT i-nr-ord-produ).
        END.

        RUN emptyRowErrors IN h-boin529.

        RUN setRecord IN h-boin529(INPUT TABLE tt-man-progda-ctrab).

        IF l-modif THEN
            RUN updateRecord IN h-boin529.
        ELSE
            RUN createRecord IN h-boin529.

        IF RETURN-VALUE = "NOK":U THEN DO:
            EMPTY TEMP-TABLE rowErrors.
            RUN getRowErrors IN h-boin529(OUTPUT TABLE rowErrors).
            {method/showmessage.i1}
            {method/showmessage.i2 &Modal="YES"}
            run emptyRowErrors in h-boin529.
            RETURN "adm-error":U.
        END.

/*     END.     */
/*     ELSE DO: */
  &else  
        /*Se abaixo da 204, faz a efetivacao direto via tela*/
        run pi-validate.
    
        if  return-value = 'ADM-ERROR':U then
            return 'ADM-ERROR':U.
    
        assign c-hra-inic = input frame {&frame-name} c-hra-inic
               c-hra-fim  = input frame {&frame-name} c-hra-fim.
    
        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
        if RETURN-VALUE = 'ADM-ERROR':U then 
            return 'ADM-ERROR':U.
        
        /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
        /* Code placed here will execute AFTER standard behavior.    */
    
        if  adm-new-record then
            assign man-progda-ctrab.num-om-progda = i-num-om.
    
        find last param-sfc no-lock no-error.
    
        if  param-sfc.log-tipo-relogio then do:
            run pi-formatted-time-to-sec (input c-hra-inic,
                                          output man-progda-ctrab.qtd-segs-progda-inic).
            run pi-formatted-time-to-sec (input c-hra-fim,
                                          output man-progda-ctrab.qtd-segs-progda-fim).
        end.
        else
            assign man-progda-ctrab.qtd-segs-progda-inic = int(c-hra-inic) * 36 
                   man-progda-ctrab.qtd-segs-progda-fim  = int(c-hra-fim)  * 36.
    
        run executarAssignTabela in h-boin529 (input rowid(man-progda-ctrab)).
  &ENDIF

/*   &IF DEFINED(bf_man_204) &THEN */
/*     END.                        */
/*   &ENDIF                        */

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
    find ctrab
        where rowid(ctrab) = v-row-parent EXCLUSIVE-LOCK no-error.
    if  avail ctrab then do:
        assign man-progda-ctrab.cod-ctrab = ctrab.cod-ctrab.
    end.
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

  IF VALID-HANDLE(h-boin469b) THEN
      delete procedure h-boin469b.
  {method/showmessage.i3}
  
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

  if  avail man-progda-ctrab then do:
      find ctrab where 
           ctrab.cod-ctrab = man-progda-ctrab.cod-ctrab no-lock no-error.
      find motiv-parada where 
           motiv-parada.cod-parada = man-progda-ctrab.cod-parada no-lock no-error.
          
      assign c-des-ctrab = if  avail ctrab
                           then ctrab.des-ctrab
                           else ""
             c-des-parada = if  avail motiv-parada 
                            then motiv-parada.des-parada
                            else "".
    
      if  NOT adm-new-record then do:
      
          find last param-sfc no-lock no-error.
      
          if  param-sfc.log-tipo-relogio then do:
              run pi-sec-to-formatted-time (input man-progda-ctrab.qtd-segs-progda-inic,
                                            output c-hra-inic).
              run pi-sec-to-formatted-time (input man-progda-ctrab.qtd-segs-progda-fim,
                                            output c-hra-fim).
              
          end.
          else
              assign c-hra-inic = string(man-progda-ctrab.qtd-segs-progda-inic / 36,'9999')
                     c-hra-fim  = string(man-progda-ctrab.qtd-segs-progda-fim / 36,'9999').
          
      end.
    
      IF param-sfc.log-tipo-relogio THEN
         ASSIGN 
                c-hra-inic = string(c-hra-inic,"9999")
                c-hra-fim  = string(c-hra-fim,"9999").

  end.   

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF NOT AVAIL man-progda-ctrab THEN DO:
      APPLY "leave":U TO c-hra-inic IN FRAME f-main.
      APPLY "leave":U TO c-hra-fim  IN FRAME f-main.
  END.

  if  avail ctrab then
      assign man-progda-ctrab.cod-ctrab:screen-value in frame {&frame-name} = ctrab.cod-ctrab.
  
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
/*    if adm-new-record = yes then */
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    IF l-sfc-mudancas THEN
        RUN new-state ("display-manut").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run inbo/boin469b.p persistent set h-boin469b.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF NOT AVAIL param-sfc THEN
      FIND FIRST param-sfc NO-LOCK NO-ERROR.

  IF param-sfc.log-tipo-relogio = NO THEN 
      ASSIGN c-hra-inic:FORMAT IN FRAME f-main = "99,99":U
             c-hra-fim:FORMAT IN FRAME f-main = "99,99":U.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-handle V-table-Win 
PROCEDURE pi-atualiza-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param p-h-boin529 as handle no-undo.

assign h-boin529 = p-h-boin529.

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
    
    find ctrab where 
         rowid(ctrab) = v-row-parent no-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-chave V-table-Win 
PROCEDURE pi-busca-chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p-cod-ctrab     AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-num-om-progda AS INTEGER      NO-UNDO.


    ASSIGN p-cod-ctrab     = INPUT FRAME {&FRAME-NAME} man-progda-ctrab.cod-ctrab
           p-num-om-progda = INPUT FRAME {&FRAME-NAME} man-progda-ctrab.num-om-progda.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-det-ultimo-evento V-table-Win 
PROCEDURE pi-det-ultimo-evento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param v-dat-ult-event as date no-undo.
    def output param v-qtd-segs-ult-event as dec no-undo.

    def var v-val-dat-atual as decimal no-undo.

    find last man-progda-ctrab
        where man-progda-ctrab.cod-ctrab       = ctrab.cod-ctrab no-lock no-error.

    if  not avail man-progda-ctrab or man-progda-ctrab.dat-progda-fim < today then  
        assign v-dat-ult-event      = today
               v-qtd-segs-ult-event = 0.
    else
        assign v-dat-ult-event      = man-progda-ctrab.dat-progda-fim
               v-qtd-segs-ult-event = man-progda-ctrab.qtd-segs-progda-fim.
               
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-erros V-table-Win 
PROCEDURE pi-envia-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER TABLE FOR tt-erro.

    RETURN "OK":U.


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
    
    /*** Valida‡Æo da manuten‡Æo programada ***/
    def buffer b-man-progda-ctrab for man-progda-ctrab.

    def var c-hra-inic-aux as char.
    def var c-hra-fim-aux  as char.
        
    if  adm-new-record then do:    
        find man-progda-ctrab where 
             man-progda-ctrab.cod-ctrab     = ctrab.cod-ctrab and 
             man-progda-ctrab.num-om-progda = input frame {&frame-name} man-progda-ctrab.num-om-progda
             no-lock no-error.
        if  avail man-progda-ctrab then do:
            {utp/ut-table.i mgind man-progda-ctrab 01}
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 8, 
                               input return-value).
            apply 'entry':U to man-progda-ctrab.num-om-progda in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.

    /*** Valida‡Æo da Parada ***/
    
    find motiv-parada where 
         motiv-parada.cod-parada = input frame {&frame-name} man-progda-ctrab.cod-parada
         no-lock no-error.

    if  not avail motiv-parada then do:
        {utp/ut-table.i mgind motiv-parada 01}
        
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 47, 
                           input return-value).
        apply 'entry':U to man-progda-ctrab.cod-parada in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.
    
    /** Valida‡Æo do botÆo ok ***/
    
    if  input man-progda-ctrab.dat-progda-inic > input man-progda-ctrab.dat-progda-fim then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 198, 
                           input return-value).
        apply 'entry':U to man-progda-ctrab.dat-progda-inic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if (input man-progda-ctrab.dat-progda-inic = ""  and 
        input man-progda-ctrab.dat-progda-fim  = "") 
        or  (input man-progda-ctrab.dat-progda-inic = ? and 
             input man-progda-ctrab.dat-progda-fim  = ?) then do:

        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 173, 
                           input return-value).
        apply 'entry':U to man-progda-ctrab.dat-progda-inic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if  input man-progda-ctrab.dat-progda-inic = input man-progda-ctrab.dat-progda-fim and 
        input c-hra-fim <= input c-hra-inic then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 3074, 
                           input return-value).
        apply 'entry':U to man-progda-ctrab.dat-progda-inic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if  input man-progda-ctrab.dat-progda-inic < TODAY or  
        input man-progda-ctrab.dat-progda-fim < today then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 16301, 
                           input string(today) + "~~" + string(date(12,31,9999))).
        apply 'entry':U to man-progda-ctrab.dat-progda-inic in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    /*** Tenta encontrar reportes que tem overlap com o reporte de parada cadastrado ***/

    find last param-sfc no-lock no-error.
    if  param-sfc.log-tipo-relogio then do:
        run pi-formatted-time-to-sec (input input c-hra-inic,
                                      output de-qtd-segs-inic).
        run pi-formatted-time-to-sec (input input c-hra-fim,
                                      output de-qtd-segs-fim).
    end.
    else
        assign de-qtd-segs-inic = integer(input frame {&frame-name} c-hra-inic) * 36
               de-qtd-segs-fim  = integer(input frame {&frame-name} c-hra-fim)  * 36.

    run pi-converte-data-segs-valor (Input input man-progda-ctrab.dat-progda-inic,
                                     Input de-qtd-segs-inic,
                                     output de-val-refer-inic).
    run pi-converte-data-segs-valor (Input input man-progda-ctrab.dat-progda-fim,
                                     Input de-qtd-segs-fim,
                                     output de-val-refer-fim).
                                     
    if  ctrab.ind-tip-ctrab <> 4 /* Posto Manual */ then do:
        find last b-man-progda-ctrab where 
                  b-man-progda-ctrab.cod-ctrab = ctrab.cod-ctrab and 
                  b-man-progda-ctrab.val-refer-inic-parada < de-val-refer-inic no-lock no-error.
        
        if  not available b-man-progda-ctrab or  
            b-man-progda-ctrab.val-refer-fim-parada <= de-val-refer-inic THEN
            find first b-man-progda-ctrab where 
                       b-man-progda-ctrab.cod-ctrab = ctrab.cod-ctrab and 
                       b-man-progda-ctrab.val-refer-inic-parada > de-val-refer-inic                 
                       no-lock no-error.
        
        if  avail b-man-progda-ctrab and 
           ((b-man-progda-ctrab.val-refer-inic-parada > de-val-refer-inic and   
             b-man-progda-ctrab.val-refer-inic-parada < de-val-refer-fim)
            or (b-man-progda-ctrab.val-refer-fim-parada  > de-val-refer-inic  and   
                b-man-progda-ctrab.val-refer-fim-parada  < de-val-refer-fim)
            or (b-man-progda-ctrab.val-refer-inic-parada < de-val-refer-inic and   
                b-man-progda-ctrab.val-refer-fim-parada  > de-val-refer-fim)) then do:
            {utp/ut-table.i movind man-progda-ctrab 01}
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 17557, 
                               input return-value).
            apply 'entry':U to c-hra-inic in frame {&frame-name}.
            return 'ADM-ERROR':U.
        end.
    end.    
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeHandlePag2 V-table-Win 
PROCEDURE recebeHandlePag2 :
/*------------------------------------------------------------------------------
  Purpose:     Recebe o handle da pag 2 - Manuten‡Æo.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.


ASSIGN h-pag-2 = p-handle.

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
  {src/adm/template/snd-list.i "man-progda-ctrab"}

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

