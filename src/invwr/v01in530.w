&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i V01IN530 2.00.01.015 } /*** "010115" 28/05/2026 17:00:42 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in530 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

{sfc/sfapi010.i} /** Temp-table de reporte de parada **/
{cdp/cd0666.i}   /** Temp-table de erros padr∆o **/

define variable v-row-parent as rowid  no-undo.
define variable rw-operador  as rowid  no-undo.
define variable h-boin469b   as handle no-undo.
DEFINE VARIABLE h-sfapi010   AS HANDLE NO-UNDO.

define variable de-qtd-tempo-util        as dec  no-undo.
define variable v-val-refer-inic         like tt-import-rep-parada.val-refer-inic-parada no-undo. 
define variable v-val-refer-fim          like tt-import-rep-parada.val-refer-fim-parada  no-undo.
define variable de-qtd-segs-inic-parada  as dec  no-undo.
define variable de-qtd-segs-fim-parada   as dec  no-undo.
define variable de-val-refer-fim-parada  as dec  no-undo.
define variable de-val-refer-inic-parada as dec  no-undo.
define variable v-dat-ult-event          as date no-undo.
define variable v-qtd-segs-ult-event     as dec  no-undo.
define variable l-existe-equipe          as log  no-undo.

define shared variable  c-var-program    as char no-undo.

DEFINE VARIABLE l-sfc-mudancas-mi AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-sfc-mudancas    AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-emite-ss      AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-envia-email   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-nr-ord-produ  AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-nr-soli-serv  AS INTEGER    NO-UNDO.

{sfc/sf0309.i} /*Funcao para tratamento de leave dos campos de hora*/
{sfc/sf0108.i} /*funcao de tratamento de leave do cod-operador*/

DEFINE VARIABLE h-handle-pai AS HANDLE NO-UNDO.

DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ctrab AS ROWID NO-UNDO.
DEFINE VARIABLE h-pag-2 AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-erro  AS LOGICAL    NO-UNDO.

DEFINE VARIABLE l-reanalise AS LOGICAL INIT NO   NO-UNDO.
DEFINE VARIABLE r-rowid-parada-reanalise AS ROWID      NO-UNDO.

{method/dbotterr.i}
{include/i-vrtab.i area-produc}  
DEFINE VARIABLE hShowMsg AS HANDLE     NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS i-num-om-progda dt-dat-inic-parada ~
c-hra-inic-parada dt-dat-fim-parada c-hra-fim-parada c-cod-parada rt-key ~
rt-mold 
&Scoped-Define DISPLAYED-OBJECTS c-cod-ctrab c-des-ctrab i-num-om-progda ~
dt-dat-inic-parada c-hra-inic-parada dt-dat-fim-parada c-hra-fim-parada ~
d-qtd-tempo-ext d-qtd-tempo-parada c-cod-parada c-des-parada c-operador ~
c-equipe c-des-equipe 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS dt-dat-inic-parada 
&Scoped-define ADM-MODIFY-FIELDS c-hra-inic-parada c-hra-fim-parada 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-c-equipe 
       MENU-ITEM m_Zoom_de_Equipe LABEL "Zoom de Equipe"
       MENU-ITEM m_Equipe_Automtica LABEL "Equipe Autom†tica".


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-ctrab AS CHARACTER FORMAT "x(16)" 
     LABEL "Centro Trabalho" 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE VARIABLE c-cod-parada AS CHARACTER FORMAT "x(8)" 
     LABEL "Parada" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88.

DEFINE VARIABLE c-des-ctrab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-equipe AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-parada AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE c-equipe AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-fim-parada AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-inic-parada AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE c-operador AS CHARACTER FORMAT "9999999-9":U INITIAL "00000000" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-tempo-ext AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "T. Extra" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE d-qtd-tempo-parada AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "T. Ètil" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE VARIABLE dt-dat-fim-parada AS DATE FORMAT "99/99/9999" INITIAL 03/08/02 
     LABEL "Data Fim Parada" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE dt-dat-inic-parada AS DATE FORMAT "99/99/9999" INITIAL 03/08/02 
     LABEL "Data In°cio Parada" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE i-num-om-progda AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Manutená∆o Programada" 
     VIEW-AS FILL-IN 
     SIZE 13.72 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cod-ctrab AT ROW 1.17 COL 26 COLON-ALIGNED
     c-des-ctrab AT ROW 1.17 COL 43.57 COLON-ALIGNED NO-LABEL
     i-num-om-progda AT ROW 2.17 COL 26 COLON-ALIGNED
     dt-dat-inic-parada AT ROW 3.17 COL 26 COLON-ALIGNED
     c-hra-inic-parada AT ROW 3.17 COL 39 COLON-ALIGNED NO-LABEL
     dt-dat-fim-parada AT ROW 4.67 COL 26 COLON-ALIGNED
     c-hra-fim-parada AT ROW 4.67 COL 39 COLON-ALIGNED NO-LABEL
     d-qtd-tempo-ext AT ROW 4.67 COL 75 COLON-ALIGNED
     d-qtd-tempo-parada AT ROW 4.67 COL 54 COLON-ALIGNED
     c-cod-parada AT ROW 5.67 COL 26 COLON-ALIGNED
     c-des-parada AT ROW 5.67 COL 38.43 COLON-ALIGNED NO-LABEL
     c-operador AT ROW 6.67 COL 26 COLON-ALIGNED
     c-equipe AT ROW 6.67 COL 26 COLON-ALIGNED HELP
          "F5: Zoom de Equipe~; F6: Equipe Autom†tica"
     c-des-equipe AT ROW 6.67 COL 38.43 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 6.75
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-equipe IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-equipe IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-equipe:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-equipe:HANDLE.

/* SETTINGS FOR FILL-IN c-hra-fim-parada IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN c-hra-inic-parada IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN c-operador IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-qtd-tempo-ext IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-qtd-tempo-parada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dt-dat-inic-parada IN FRAME f-main
   1                                                                    */
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

&Scoped-define SELF-NAME c-cod-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-parada V-table-Win
ON F5 OF c-cod-parada IN FRAME f-main /* Parada */
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in510.w"
                     &campo=c-cod-parada
                     &campozoom=cod-parada
                     &campo2=c-des-parada
                     &campozoom2=des-parada}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-parada V-table-Win
ON LEAVE OF c-cod-parada IN FRAME f-main /* Parada */
DO:
    {include/leave.i &tabela=motiv-parada 
                     &atributo-ref=des-parada
                     &variavel-ref=c-des-parada
                     &where="motiv-parada.cod-parada = input frame {&frame-name} c-cod-parada"}
                   
    RUN new-state ("atualiza-parada").
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-parada V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-parada IN FRAME f-main /* Parada */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-parada V-table-Win
ON RETURN OF c-cod-parada IN FRAME f-main /* Parada */
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-equipe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-equipe V-table-Win
ON F5 OF c-equipe IN FRAME f-main
DO:
  if  ctrab.ind-reporte-mod = 3 /* Reporta Equipe */ then do:

      IF AVAIL ctrab THEN
          ASSIGN gr-ctrab = ROWID(ctrab).

      {method/zoomfields.i &ProgramZoom="mfzoom/z01mf516.w"
                           &FieldZoom1=cod-equipe
                           &FieldScreen1=c-equipe
                           &Frame1=f-main
                           &FieldZoom2=des-equipe
                           &FieldScreen2=c-des-equipe
                           &Frame2=f-main}
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-equipe V-table-Win
ON F6 OF c-equipe IN FRAME f-main
DO:
    IF l-sfc-mudancas THEN DO:
        DEFINE VARIABLE var-equipe AS CHARACTER  NO-UNDO.
        DEFINE VARIABLE l-ok AS LOGICAL INIT NO NO-UNDO.
        ASSIGN var-equipe = c-equipe:SCREEN-VALUE IN FRAME f-main.
        assign {&window-name}:sensitive = no.
        RUN sfc/sf0309b.w(INPUT-OUTPUT var-equipe,
                          INPUT INPUT FRAME f-main c-cod-ctrab,
                          INPUT "":U,
                          OUTPUT l-ok).
        assign {&window-name}:sensitive = YES.
        
        IF l-ok THEN DO:
            DISPLAY var-equipe @ c-equipe WITH FRAME f-main.
            APPLY "leave":U TO c-equipe IN FRAME f-main.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-equipe V-table-Win
ON LEAVE OF c-equipe IN FRAME f-main
DO:
  if  ctrab.ind-reporte-mod = 3 /* Reporta Equipe */ then do:
      {include/leave.i &tabela=equipe-prod 
                       &atributo-ref=des-equipe
                       &variavel-ref=c-des-equipe
                       &where="equipe-prod.cod-equipe = input frame {&frame-name} c-equipe"}
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-equipe V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-equipe IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-equipe V-table-Win
ON RETURN OF c-equipe IN FRAME f-main
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-fim-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-fim-parada V-table-Win
ON ALT-O OF c-hra-fim-parada IN FRAME f-main
DO:
    APPLY "return":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-fim-parada V-table-Win
ON LEAVE OF c-hra-fim-parada IN FRAME f-main
DO:
    def var da-ini-aux   as date.
    def var da-fim-aux   as date.
    def var c-cod-area   as char no-undo.
    def var c-cod-calend as char no-undo.
    def var c-gm-codigo  as char no-undo.
    def var d-tempo-ext      as decimal no-undo.
    def var p-num-turno  as int no-undo.
    def var p-qtd-tempo-proces as decimal no-undo.

    ASSIGN l-erro = NO.
    ASSIGN c-hra-fim-parada = fnValidaHora(c-hra-fim-parada:SCREEN-VALUE IN FRAME f-main).
    IF c-hra-fim-parada = ? THEN DO:

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
    
        APPLY "ENTRY":U to c-hra-fim-parada in frame f-main.
        ASSIGN l-erro = YES.
        RETURN NO-APPLY.
    END.
    
    DISPLAY c-hra-fim-parada WITH frame f-main.

    if  input dt-dat-inic-parada = input dt-dat-fim-parada
    and input c-hra-fim-parada   < input c-hra-inic-parada then do:
        ASSIGN c-hra-fim-parada = c-hra-inic-parada.
        DISP c-hra-fim-parada WITH FRAME {&FRAME-NAME}.
    end.

    if  param-sfc.log-tipo-relogio then do:
        run pi-formatted-time-to-sec (input input frame {&frame-name} c-hra-inic-parada,
                                      output de-qtd-segs-inic-parada).
        run pi-formatted-time-to-sec (input input frame {&frame-name} c-hra-fim-parada,
                                      output de-qtd-segs-fim-parada).
    end.
    else
        assign de-qtd-segs-inic-parada = integer(input frame {&frame-name} c-hra-inic-parada) * 36
               de-qtd-segs-fim-parada  = integer(input frame {&frame-name} c-hra-fim-parada)  * 36.

    if  input frame {&frame-name} dt-dat-inic-parada <> ?
    and input frame {&frame-name} dt-dat-fim-parada  <> ? then do:
        assign de-qtd-tempo-util = ?
               da-ini-aux = date(string(input frame {&frame-name} dt-dat-inic-parada,"99/99/9999"))
               da-fim-aux = date(string(input frame {&frame-name} dt-dat-fim-parada,"99/99/9999")).

        assign c-cod-calend = ?
               c-cod-area   = ?
               c-gm-codigo  = ctrab.gm-codigo.
        run CalcularTemposCtrab in h-boin469b (input-output c-cod-area,
                                               input-output c-gm-codigo,
                                               input        ctrab.cod-ctrab,
                                               input-output c-cod-calend,
                                               Input-output da-fim-aux,
                                               Input-output de-qtd-segs-fim-parada,
                                               Input-output da-ini-aux,
                                               Input-output de-qtd-segs-inic-parada,
                                               Input-output de-qtd-tempo-util).
        assign p-qtd-tempo-proces = de-qtd-tempo-util.
        /** Tempo extra **/
        /*
         run CalcularTemposCtrabExtra in h-boin469b (input-output c-cod-area,                 
                                                input-output c-gm-codigo,                
                                                input        ctrab.cod-ctrab,
                                                input-output c-cod-calend,               
                                                Input-output da-fim-aux,                  
                                                Input-output de-qtd-segs-fim-parada,             
                                                Input-output da-ini-aux,                 
                                                Input-output de-qtd-segs-inic-parada,            
                                                input         "":U,        
                                                Input-output p-qtd-tempo-proces,
                                                output       d-tempo-ext,
                                                output       p-num-turno).
                         disp d-tempo-ext @ d-qtd-tempo-ext
             with frame {&frame-name}.
             */

        RUN piRetornaDadosExtras in h-boin469b (output       d-tempo-ext,
                                                output       p-num-turno).

        disp d-tempo-ext @ d-qtd-tempo-ext
             de-qtd-tempo-util @ d-qtd-tempo-parada
             with frame {&frame-name}.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-fim-parada V-table-Win
ON RETURN OF c-hra-fim-parada IN FRAME f-main
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        IF l-erro = NO THEN
            RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-inic-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inic-parada V-table-Win
ON ALT-O OF c-hra-inic-parada IN FRAME f-main
DO:
    APPLY "return":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inic-parada V-table-Win
ON LEAVE OF c-hra-inic-parada IN FRAME f-main
DO: 
   ASSIGN l-erro = NO.
   ASSIGN c-hra-inic-parada = fnValidaHora(c-hra-inic-parada:SCREEN-VALUE IN FRAME f-main).
   IF c-hra-inic-parada = ? THEN DO:

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

       APPLY "ENTRY":U to c-hra-inic-parada in frame f-main.
       ASSIGN l-erro = YES.
       RETURN NO-APPLY.
   END.

   DISPLAY c-hra-inic-parada WITH frame f-main.

    IF c-hra-fim-parada:SENSITIVE IN FRAME f-main THEN
        APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-inic-parada V-table-Win
ON RETURN OF c-hra-inic-parada IN FRAME f-main
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        IF l-erro = NO THEN
            RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-operador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-operador V-table-Win
ON F5 OF c-operador IN FRAME f-main
DO:
  if  ctrab.ind-reporte-mod = 2 /* Reporta Operador */ then do:

      IF AVAIL ctrab THEN
          ASSIGN gr-ctrab = ROWID(ctrab).

      {method/zoomfields.i &ProgramZoom="mfzoom/z02mf518.w"
                           &FieldZoom1=cod-operador
                           &FieldScreen1=c-operador
                           &Frame1=f-main
                           &FieldZoom2=nom-operador
                           &FieldScreen2=c-des-equipe
                           &Frame2=f-main}
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-operador V-table-Win
ON LEAVE OF c-operador IN FRAME f-main
DO:
  ASSIGN c-operador:SCREEN-VALUE IN FRAME f-main = fnCodOperador(c-operador:SCREEN-VALUE IN FRAME f-main).

  if  ctrab.ind-reporte-mod = 2 /* Reporta Operador */ 
  and input frame {&frame-name} c-operador <> '' then do:
      {include/leave.i &tabela=operador 
                       &atributo-ref=nom-operador
                       &variavel-ref=c-des-equipe
                       &where="operador.cod-operador = input frame {&frame-name} c-operador"}
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-operador V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-operador IN FRAME f-main
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-operador V-table-Win
ON RETURN OF c-operador IN FRAME f-main
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-dat-fim-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-dat-fim-parada V-table-Win
ON LEAVE OF dt-dat-fim-parada IN FRAME f-main /* Data Fim Parada */
DO:
    if  input dt-dat-inic-parada > input dt-dat-fim-parada then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 27312, 
                           input "").
        apply 'entry' to dt-dat-fim-parada in frame {&frame-name}.
        return no-apply.
    end.

    IF INPUT dt-dat-fim-parada > (INPUT dt-dat-inic-parada + 365 * 2) THEN DO:
        ASSIGN dt-dat-fim-parada = INPUT dt-dat-inic-parada + 365 * 2.
        DISP dt-dat-fim-parada WITH FRAME {&FRAME-NAME}.
        run utp/ut-msgs.p (input "show":U, 
                           input 27615, 
                           input "").
        apply 'entry' to dt-dat-fim-parada in frame {&frame-name}.
        return no-apply.
    END.

    IF c-hra-fim-parada:SENSITIVE IN FRAME f-main THEN
        APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-dat-fim-parada V-table-Win
ON RETURN OF dt-dat-fim-parada IN FRAME f-main /* Data Fim Parada */
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dt-dat-inic-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-dat-inic-parada V-table-Win
ON LEAVE OF dt-dat-inic-parada IN FRAME f-main /* Data In°cio Parada */
DO:
    ASSIGN INPUT FRAME f-main dt-dat-fim-parada.

    IF input frame {&frame-name} dt-dat-inic-parada > input frame {&frame-name} dt-dat-fim-parada THEN
        ASSIGN dt-dat-fim-parada = input frame {&frame-name} dt-dat-inic-parada.

    IF input frame {&frame-name} dt-dat-inic-parada = input frame {&frame-name} dt-dat-fim-parada AND 
       input frame {&frame-name} c-hra-inic-parada  > input frame {&frame-name} c-hra-fim-parada  THEN
        ASSIGN c-hra-fim-parada:SCREEN-VALUE IN FRAME {&FRAME-NAME} = input frame {&frame-name} c-hra-inic-parada.

    DISPLAY dt-dat-fim-parada WITH FRAME f-main.

    IF c-hra-fim-parada:SENSITIVE IN FRAME f-main THEN
        APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dt-dat-inic-parada V-table-Win
ON RETURN OF dt-dat-inic-parada IN FRAME f-main /* Data In°cio Parada */
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-num-om-progda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-om-progda V-table-Win
ON F5 OF i-num-om-progda IN FRAME f-main /* Manutená∆o Programada */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in529.w"
                     &campo=i-num-om-progda
                     &campozoom=num-om-progda}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-om-progda V-table-Win
ON LEAVE OF i-num-om-progda IN FRAME f-main /* Manutená∆o Programada */
DO:
  find first man-progda-ctrab
       where man-progda-ctrab.cod-ctrab     = c-cod-ctrab:screen-value in frame {&frame-name}
         and man-progda-ctrab.num-om-progda = input frame {&frame-name} i-num-om-progda
      no-lock no-error.

  if  avail man-progda-ctrab then do:
      find last param-sfc no-lock no-error.

      if  param-sfc.log-tipo-relogio then do:
          run pi-sec-to-formatted-time (input man-progda-ctrab.qtd-segs-progda-inic,
                                        output c-hra-inic-parada).
          run pi-sec-to-formatted-time (input man-progda-ctrab.qtd-segs-progda-fim,
                                        output c-hra-fim-parada).
      end.
      else
          assign c-hra-inic-parada = string(man-progda-ctrab.qtd-segs-progda-inic / 36)
                 c-hra-fim-parada  = string(man-progda-ctrab.qtd-segs-progda-fim / 36).

      find first motiv-parada
           where motiv-parada.cod-parada = man-progda-ctrab.cod-parada 
           no-lock no-error.

      disp man-progda-ctrab.dat-progda-inic @ dt-dat-inic-parada
           man-progda-ctrab.dat-progda-fim  @ dt-dat-fim-parada
           c-hra-inic-parada
           c-hra-fim-parada
           man-progda-ctrab.cod-parada @ c-cod-parada
           motiv-parada.des-parada     @ c-des-parada
           with frame {&frame-name}.

      disable c-cod-parada
              with frame {&frame-name}.

      apply 'leave' to c-hra-fim-parada in frame {&frame-name}.
  end.
  else
      enable c-cod-parada
             with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-om-progda V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-num-om-progda IN FRAME f-main /* Manutená∆o Programada */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-num-om-progda V-table-Win
ON RETURN OF i-num-om-progda IN FRAME f-main /* Manutená∆o Programada */
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Equipe_Automtica
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Equipe_Automtica V-table-Win
ON CHOOSE OF MENU-ITEM m_Equipe_Automtica /* Equipe Autom†tica */
DO:
    APPLY "F6":U TO c-equipe IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Zoom_de_Equipe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Zoom_de_Equipe V-table-Win
ON CHOOSE OF MENU-ITEM m_Zoom_de_Equipe /* Zoom de Equipe */
DO:
    APPLY "F5":U TO c-equipe IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
ASSIGN l-sfc-mudancas-mi = FALSE.

RUN sfc/sf9999.p(OUTPUT l-sfc-mudancas).

IF l-sfc-mudancas THEN DO:

    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global AND param-global.modulo-mi THEN 
        ASSIGN l-sfc-mudancas-mi = YES.
END.

c-cod-parada:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.
i-num-om-progda:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.
c-equipe:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.
c-operador:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.

IF l-sfc-mudancas THEN
    c-equipe:load-mouse-pointer ("image~\rbm.cur") in frame {&frame-name}.
ELSE
    ASSIGN c-equipe:POPUP-MENU IN FRAME f-main = ?
           c-equipe:HELP IN FRAME f-main       = "":U.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
{sfc/sf9000.i}   /** pi-formatted-time-to-sec, pi-sec-to-formatted-time **/
{sfc/sf9001.i}   /** pi-det-ultimo-evento-ctrab, equipe, operador **/

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

/*******************************************************************************
*
*                       PI modificada para pi-add-rep-parada
*
*******************************************************************************/

    run pi-add-rep-parada.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

/*******************************************************************************
*
*                       PI modificada para pi-assign-rep-parada
*
*******************************************************************************/

def var l-ok as logical no-undo.

run pi-assign-rep-parada (output l-ok).


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

    /** Procura registro corrente do Ctrab **/
    find first ctrab
         where rowid(ctrab) = v-row-parent no-lock no-error.
    if  avail ctrab then do:
        assign c-cod-ctrab = ctrab.cod-ctrab.
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

  IF VALID-HANDLE(h-sfapi010) THEN do:
      run finalizaAPI in h-sfapi010.
      delete procedure h-sfapi010 no-error.
  end.

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
  

    assign c-des-ctrab  = if  avail ctrab
                          then ctrab.des-ctrab
                          else "".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if  avail ctrab then
      assign c-cod-ctrab:screen-value in frame {&frame-name} = ctrab.cod-ctrab.

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
  
  find first param-sfc no-lock no-error.

  assign i-num-om-progda:screen-value in frame {&FRAME-NAME}    = "0"
                          d-qtd-tempo-ext:screen-value in frame {&FRAME-NAME} = "0,00"
         d-qtd-tempo-parada:screen-value in frame {&FRAME-NAME} = "0,00".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF param-sfc.log-tipo-relogio = NO THEN
      ASSIGN c-hra-inic-parada:FORMAT IN FRAME f-main = "99,99":U
             c-hra-fim-parada:FORMAT  IN FRAME f-main = "99,99":U.

  /* Code placed here will execute AFTER standard behavior.    */
  EMPTY TEMP-TABLE tt-import-rep-parada.
  EMPTY TEMP-TABLE tt-erro.

  run sfc/sfapi010.p PERSISTENT SET  h-sfapi010 (input  {&versao}, /*versao definida na sfapi010.i*/
                                                 input  table tt-import-rep-parada,
                                                 output table tt-erro).       

  run inbo/boin469b.p persistent set h-boin469b.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE modoConsulta V-table-Win 
PROCEDURE modoConsulta :
/*------------------------------------------------------------------------------
  Purpose:     Chamada pelo sf0301a.w, indica que a viewer est† sendo chamada em modo consulta, 
               com todos os campos desabilitados.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-row-rep-parada-ctrab AS ROWID NO-UNDO.

FIND FIRST rep-parada-ctrab WHERE ROWID(rep-parada-ctrab) = p-row-rep-parada-ctrab NO-LOCK NO-ERROR.
FIND FIRST ctrab WHERE ctrab.cod-ctrab = rep-parada-ctrab.cod-ctrab NO-LOCK NO-ERROR.
find last param-sfc no-lock no-error.

if  param-sfc.log-tipo-relogio then do:
  run pi-sec-to-formatted-time (input rep-parada-ctrab.qtd-segs-inic,
                                output c-hra-inic-parada).
  run pi-sec-to-formatted-time (input rep-parada-ctrab.qtd-segs-fim,
                                output c-hra-fim-parada).
end.
else
  assign c-hra-inic-parada = string(rep-parada-ctrab.qtd-segs-inic / 36)
         c-hra-fim-parada  = string(rep-parada-ctrab.qtd-segs-fim / 36).

DISPLAY ctrab.cod-ctrab @ c-cod-ctrab
        ctrab.des-ctrab @ c-des-ctrab
        rep-parada-ctrab.num-om-progda   @ i-num-om-progda
        rep-parada-ctrab.dat-inic-parada @ dt-dat-inic-parada
        c-hra-inic-parada
        rep-parada-ctrab.dat-fim-parada  @ dt-dat-fim-parada        
        c-hra-fim-parada 
        rep-parada-ctrab.cod-parada      @ c-cod-parada
    WITH FRAME f-main.


IF rep-parada-ctrab.dat-fim-parada = 12/31/9998 THEN DO:
    /*Parada iniciada, muda a data e hora de fim de parada para ?*/
    ASSIGN dt-dat-fim-parada  = ?
           c-hra-fim-parada   = ?
           d-qtd-tempo-parada = ?.
    DISP "":U @ dt-dat-fim-parada
         "":U @ c-hra-fim-parada 
         "":U @ d-qtd-tempo-parada WITH FRAME f-main.
END.
ELSE
    APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.

APPLY "leave":U TO c-cod-parada IN FRAME f-main.

if ctrab.ind-reporte-mod = 1 /* nao reporta */ then
    assign c-equipe:hidden     in frame {&frame-name} = yes
           c-operador:hidden   in frame {&frame-name} = yes
           c-des-equipe:hidden in frame {&frame-name} = yes.
else do:
    enable c-operador
           c-equipe
           with frame {&frame-name}.

    if ctrab.ind-reporte-mod = 2 /* operador */ then do:
        {utp/ut-liter.i Operador * R}
        assign c-equipe:hidden   in frame {&frame-name} = yes
               c-operador:hidden in frame {&frame-name} = no
               c-operador:label  in frame {&frame-name} = trim(return-value)
               c-operador                               = rep-parada-ctrab.cod-equipe.
        DISPLAY c-operador WITH FRAME f-main.

        APPLY "leave":U TO c-operador IN FRAME f-main.
    end.
    else do:
        {utp/ut-liter.i Equipe * R}
        assign c-equipe:hidden   in frame {&frame-name} = no
               c-operador:hidden in frame {&frame-name} = yes
               c-equipe:label    in frame {&frame-name} = trim(return-value)
               c-equipe:SCREEN-VALUE IN FRAME f-main    = rep-parada-ctrab.cod-equipe.

        APPLY "leave":U TO c-equipe IN FRAME f-main.
    end. 
end.

DISABLE ALL WITH FRAME f-main.

IF VALID-HANDLE(h-pag-2) THEN
    RUN modoConsulta  IN h-pag-2(INPUT p-row-rep-parada-ctrab).

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-rep-parada V-table-Win 
PROCEDURE pi-add-rep-parada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
if  avail ctrab then do:
    disp ctrab.cod-ctrab @ c-cod-ctrab
         ctrab.des-ctrab @ c-des-ctrab
       with frame {&frame-name}.

    if  ctrab.ind-tip-ctrab <> 4 then  /** posto manual **/
        run pi-det-ultimo-evento-ctrab (output v-dat-ult-event,
                                        output v-qtd-segs-ult-event).
    ELSE DO:
        /*Se ctrab for manual, desabilita pagina Manutencao.*/
        IF l-sfc-mudancas-mi AND valid-handle(h-handle-pai) THEN 
            RUN desabilitaPagManut IN h-handle-pai.
    END.

    if  ctrab.ind-reporte-mod = 2 then do:  /** operador **/
/*        if c-var-program = "sf0303g.w" then do :     
 *             find operador
 *                     where rowid(operador)  = gr-operador no-lock no-error.
 *                 if  not available operador then 
 *                     assign c-des-equipe    = ""
 *                            l-existe-equipe = no.
 *                 else
 *                     assign c-des-equipe    = operador.nom-operador
 *                            c-operador      = operador.cod-operador
 *                            l-existe-equipe = yes.
 *         end.*/
        if  ctrab.ind-tip-ctrab = 4 then  /** posto manual **/
            run pi-det-ultimo-evento-operador (output v-dat-ult-event,
                                               output v-qtd-segs-ult-event).
     end.
     else do:
/*        if c-var-program = "sf0303g.w" then do :
 *             find equipe-prod
 *                     where rowid(equipe-prod) = gr-equipe-prod no-lock no-error.
 *             if  not available equipe-prod then
 *                 assign c-des-equipe    = ""
 *                        l-existe-equipe = no.
 *             else 
 *                 assign c-des-equipe    = equipe-prod.des-equipe
 *                        c-equipe        = equipe-prod.cod-operador
 *                        l-existe-equipe = yes. 
 *         end.*/
        if  ctrab.ind-tip-ctrab = 4 then  /** posto manual **/
            run pi-det-ultimo-evento-equipe (output v-dat-ult-event,
                                             output v-qtd-segs-ult-event).
    end.

    if  v-dat-ult-event = ? then  
        assign v-dat-ult-event      = today
               v-qtd-segs-ult-event = 0.

    if  param-sfc.log-tipo-relogio then do:
        run pi-sec-to-formatted-time (Input v-qtd-segs-ult-event,
                                      output c-hra-inic-parada).
    end.    
    else
        assign c-hra-inic-parada = string(int(v-qtd-segs-ult-event / 36), "9999").

    if  param-sfc.log-tipo-relogio then do:
        run pi-sec-to-formatted-time (Input TIME,
                                      output c-hra-fim-parada).
    end.    
    else
        assign c-hra-fim-parada = string(int(TIME / 36), "9999").

    assign dt-dat-inic-parada = v-dat-ult-event.
           dt-dat-fim-parada  = TODAY.

    /*Caso a data/hora fim seja menor ou igual data/hora inicial, coloca a hora inicial em mais um minuto.*/
    IF dt-dat-fim-parada < dt-dat-inic-parada OR
       (dt-dat-fim-parada = dt-dat-inic-parada AND
        SUBSTRING(c-hra-fim-parada,1,4) <= SUBSTRING(c-hra-inic-parada,1,4)) THEN DO:

        ASSIGN dt-dat-fim-parada = dt-dat-inic-parada.
               
        if  param-sfc.log-tipo-relogio then do:
            run pi-sec-to-formatted-time (Input v-qtd-segs-ult-event + 60,
                                          output c-hra-fim-parada).
        end.    
        else
            assign c-hra-fim-parada = string(int((v-qtd-segs-ult-event + 60) / 36), "9999").
    END.

    display dt-dat-inic-parada
            dt-dat-fim-parada
            c-hra-inic-parada
            c-hra-fim-parada
            c-des-equipe
          with frame {&FRAME-NAME}.

    if l-existe-equipe = yes
    or  ctrab.ind-reporte-mod = 1 /* nao reporta */ then
        assign c-equipe:hidden     in frame {&frame-name} = yes
               c-operador:hidden   in frame {&frame-name} = yes
               c-des-equipe:hidden in frame {&frame-name} = yes.
    else do:
        enable c-operador
               c-equipe
               with frame {&frame-name}.
        if ctrab.ind-reporte-mod = 2 /* operador */ then do:
            {utp/ut-liter.i Operador * R}
            assign c-equipe:hidden   in frame {&frame-name} = yes
                   c-operador:hidden in frame {&frame-name} = no
                   c-operador:label  in frame {&frame-name} = trim(return-value).
        end.
        else do:
            {utp/ut-liter.i Equipe * R}
            assign c-equipe:hidden   in frame {&frame-name} = no
                   c-operador:hidden in frame {&frame-name} = yes
                   c-equipe:label    in frame {&frame-name} = trim(return-value).
        end. 
    end.

    IF c-hra-fim-parada:SENSITIVE IN FRAME f-main THEN
        APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.

end.  /* ctrab */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-rep-parada V-table-Win 
PROCEDURE pi-assign-rep-parada :
/*------------------------------------------------------------------------------
  Purpose:     Grava os registros na temp-table tt-import-rep-parada.
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
define output parameter p-ok as logical no-undo.
/** variaveis CDAPI005 **/
def var    da-iniper-x        as date no-undo.      
def var    da-fimper-x        as date no-undo.    
def var    i-per-corrente     as int no-undo.  
def var    i-ano-corrente     as int no-undo. 
def var    da-aux-ini         as date no-undo.
def var    da-aux-fim         as date no-undo.
DEF VAR    c-ult-per-fech     AS CHAR NO-UNDO.

/** variaveis para validacao de horario futuro **/
DEF VAR    de-segs-inic-parada AS DECIMAL NO-UNDO.
DEF VAR    de-segs-fim-parada  AS DECIMAL NO-UNDO.
DEF VAR    de-segs-time-atual  AS DECIMAL NO-UNDO.

EMPTY TEMP-TABLE tt-erro.

assign c-hra-inic-parada  = input frame {&frame-name} c-hra-inic-parada
       c-hra-fim-parada   = input frame {&frame-name} c-hra-fim-parada
       c-cod-ctrab        = input frame {&frame-name} c-cod-ctrab
       c-cod-parada       = input frame {&frame-name} c-cod-parada
       i-num-om-progda    = input frame {&frame-name} i-num-om-progda
       dt-dat-inic-parada = input frame {&frame-name} dt-dat-inic-parada
       dt-dat-fim-parada  = input frame {&frame-name} dt-dat-fim-parada
            d-qtd-tempo-ext    = input frame {&frame-name} d-qtd-tempo-ext
       p-ok               = yes.

IF (dt-dat-fim-parada = TODAY) OR (dt-dat-inic-parada = TODAY) THEN DO:
    
    if param-sfc.log-tipo-relogio then do:
        run pi-formatted-time-to-sec (input c-hra-inic-parada,
                                      output de-segs-inic-parada).
        run pi-formatted-time-to-sec (input c-hra-fim-parada,
                                      output de-segs-fim-parada).
        assign de-segs-time-atual = TIME.
    end.
    else do:
        assign de-segs-inic-parada = int(c-hra-inic-parada) * 36
               de-segs-fim-parada  = int(c-hra-fim-parada) * 36
               de-segs-time-atual  = TIME.
    end.
    
    IF (dt-dat-fim-parada = TODAY AND de-segs-fim-parada > (de-segs-time-atual + 300)) OR
       (dt-dat-inic-parada = TODAY AND de-segs-inic-parada > (de-segs-time-atual + 300)) THEN DO:
        
        RUN utp/ut-msgs.p(INPUT "show",
                      INPUT 58141,
                      INPUT RETURN-VALUE).
        
        IF RETURN-VALUE <> "YES":U THEN DO:
            ASSIGN p-ok = NO.
            RETURN "NOK":U.
        END.
    END.
END.

find last param-estoq no-lock no-error.

ASSIGN c-ult-per-fech = param-estoq.ult-per-fech.

IF avail param-estoq AND param-estoq.tp-fech = 2 THEN DO:

    IF NOT AVAILABLE area-produc THEN
    FIND FIRST area-produc
		WHERE ROWID(area-produc)= gr-area-produc NO-LOCK NO-ERROR.

    IF AVAILABLE area-produc THEN
    FIND FIRST estab-mat 
         WHERE estab-mat.cod-estabel = area-produc.cod-estabel NO-LOCK NO-ERROR.

    IF AVAIL estab-mat THEN DO:
        ASSIGN c-ult-per-fech = estab-mat.ult-per-fech.
    END.
END.

IF param-sfc.log-parada-atualiza-ggf = NO THEN DO:

    run cdp/cdapi005.p (input  c-ult-per-fech ,
                        output da-iniper-x    ,
                        output da-fimper-x    ,
                        output i-per-corrente ,
                        output i-ano-corrente ,
                        output da-aux-ini     ,
                        output da-aux-fim     ).
    
    IF dt-dat-fim-parada < da-aux-fim then do:
    
        {utp/ut-liter.i TÇrmino * }
    
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 56451,
                          INPUT RETURN-VALUE).
    
        IF RETURN-VALUE <> "YES":U THEN DO:
            ASSIGN p-ok = NO.
            RETURN "NOK":U.
        END.
    END.
    ELSE IF dt-dat-inic-parada < da-aux-fim THEN DO:

        {utp/ut-liter.i "In°cio" * }
    
        RUN utp/ut-msgs.p(INPUT "show",
                          INPUT 56451,
                          INPUT RETURN-VALUE).
    
        IF RETURN-VALUE <> "YES":U THEN DO:
            ASSIGN p-ok = NO.
            RETURN "NOK":U.
        END.
    END.
END.

if avail param-estoq then do:
end.

if avail ctrab then do:
    case ctrab.ind-reporte-mod:
        when 1 then
            assign c-equipe   = ""
                   c-operador = "".
        when 2 then 
            assign c-equipe   = ""
                   c-operador:SCREEN-VALUE IN FRAME f-main = fnCodOperador(c-operador:SCREEN-VALUE IN FRAME f-main)
                   c-operador = input frame {&frame-name} c-operador.
        otherwise
            assign c-equipe   = input frame {&frame-name} c-equipe
                   c-operador = "".
    end case.
end.

for each tt-import-rep-parada exclusive-lock:
    delete tt-import-rep-parada.
end.

/** Criaá∆o da temp table **/
create tt-import-rep-parada.

if param-sfc.log-tipo-relogio then do:
    run pi-formatted-time-to-sec (input  c-hra-inic-parada,
                                  output tt-import-rep-parada.hr-inic-parada).
    run pi-formatted-time-to-sec (input  c-hra-fim-parada,
                                  output tt-import-rep-parada.hr-fim-parada).
end.
else 
    assign tt-import-rep-parada.hr-inic-parada = int(c-hra-inic-parada) * 36
           tt-import-rep-parada.hr-fim-parada  = int(c-hra-fim-parada) * 36.

assign tt-import-rep-parada.tipo-rep        = 1
       tt-import-rep-parada.cod-ctrab       = c-cod-ctrab
       tt-import-rep-parada.cod-parada      = c-cod-parada
       tt-import-rep-parada.num-om-progda   = i-num-om-progda
       tt-import-rep-parada.dat-inic-parada = dt-dat-inic-parada
       tt-import-rep-parada.dat-fim-parada  = dt-dat-fim-parada
       tt-import-rep-parada.cod-equipe      = c-equipe
       tt-import-rep-parada.cod-operador    = c-operador.

IF l-sfc-mudancas-mi THEN DO:
    RUN new-state ("atualiza-dados-manutencao").
END.

assign {&window-name}:sensitive = no. 

DO TRANS ON ERROR UNDO, LEAVE:

    run pi-inicializa IN h-sfapi010 (INPUT  TRUE,
                                     INPUT  TRUE,
                                     INPUT  l-emite-ss,
                                     INPUT  l-envia-email,
                                     INPUT  FALSE,
                                     INPUT  i-nr-ord-produ,
                                     INPUT  TABLE tt-import-rep-parada,
                                     OUTPUT TABLE tt-erro).


    IF RETURN-VALUE = "NOK":u OR CAN-FIND(FIRST tt-erro) THEN DO:
        assign p-ok = no.
        UNDO, LEAVE.
    END.

END.

if not(p-ok) THEN 
    run cdp/cd0666.w (input table tt-erro).

assign {&window-name}:sensitive = YES.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados-manut V-table-Win 
PROCEDURE pi-atualiza-dados-manut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER p-emite-ss       AS LOGICAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-envia-email    AS LOGICAL  NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-ord-produ   AS INTEGER  NO-UNDO.
    DEFINE INPUT PARAMETER p-nr-soli-serv   AS INTEGER  NO-UNDO.


    ASSIGN l-emite-ss       = p-emite-ss
           l-envia-email    = p-envia-email
           i-nr-ord-produ   = p-nr-ord-produ
           i-nr-soli-serv   = p-nr-soli-serv.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.


    assign v-row-parent = v-row-parent-externo.

    find ctrab
        where rowid(ctrab) = v-row-parent no-lock no-error.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-parada V-table-Win 
PROCEDURE pi-busca-parada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p-cod-parada AS CHARACTER NO-UNDO.


    ASSIGN p-cod-parada = INPUT FRAME {&FRAME-NAME} c-cod-parada.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-initiate V-table-Win 
PROCEDURE pi-initiate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
apply 'entry':U to i-num-om-progda in frame {&FRAME-NAME}.

assign i-num-om-progda:screen-value in frame {&FRAME-NAME}    = "0"
       c-cod-parada:screen-value in frame {&FRAME-NAME}       = ""
       c-des-parada:screen-value in frame {&FRAME-NAME}       = ""
       c-equipe:screen-value in frame {&FRAME-NAME}           = ""
       c-operador:screen-value in frame {&FRAME-NAME}         = ""
       c-des-equipe:screen-value in frame {&FRAME-NAME}       = ""
       d-qtd-tempo-parada:screen-value in frame {&FRAME-NAME} = "0,00".

run pi-add-rep-parada.

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

/*******************************************************************************
*
*                      Validaá‰es feitas na API sfapi010.p
*
*******************************************************************************/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piEfetivaReanalise V-table-Win 
PROCEDURE piEfetivaReanalise :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-ok AS LOG INIT YES NO-UNDO.
DEF VAR i-qtd-segs-fim AS INTEGER NO-UNDO.

RUN setaGeraRowErrors IN h-sfapi010.

if param-sfc.log-tipo-relogio then do:
    run pi-formatted-time-to-sec (input  c-hra-fim-parada,
                                  output i-qtd-segs-fim).
end.
else 
    assign i-qtd-segs-fim = int(c-hra-fim-parada) * 36.

IF l-sfc-mudancas-mi THEN DO:
    RUN new-state ("atualiza-dados-manutencao").
END.

RUN pi-re-analise-parada IN h-sfapi010(INPUT r-rowid-parada-reanalise,
                                       INPUT c-cod-parada:SCREEN-VALUE IN FRAME f-main,
                                       INPUT dt-dat-fim-parada:SCREEN-VALUE IN FRAME f-main,
                                       INPUT i-qtd-segs-fim,
                                       INPUT i-nr-ord-produ).
IF RETURN-VALUE = "NOK":U THEN DO:

    EMPTY TEMP-TABLE rowErrors.
    RUN retornaRowErrors IN h-sfapi010(OUTPUT TABLE rowErrors).

    IF CAN-FIND(FIRST rowErrors) THEN DO:
        /** Instancia aplicativo **/
        {method/showmessage.i1}
        /** Mostra caixa com erros **/
        {method/showmessage.i2 &Modal="''"}
        /** Limpa temp-tables de erros **/
        empty temp-table RowErrors.  
    END.

    ASSIGN p-ok = NO.

    RETURN "NOK":U.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaReanalise V-table-Win 
PROCEDURE piSetaReanalise :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-row-parada AS ROWID NO-UNDO.
DEF BUFFER bf-rep-parada-ctrab FOR rep-parada-ctrab.

ASSIGN r-rowid-parada-reanalise = p-row-parada.

/*Mostra as informaá‰es da parada*/
RUN modoConsulta(INPUT p-row-parada).

/*Habilita o campo do motivo de Parada*/
ASSIGN l-reanalise = YES.

IF dt-dat-fim-parada = ? THEN DO:
    {utp/ut-liter.i Data_Fim_Prevista * }
    ASSIGN dt-dat-fim-parada:LABEL IN FRAME f-main = return-value.

    ASSIGN dt-dat-fim-parada:SENSITIVE IN FRAME f-main = YES
           c-hra-fim-parada:SENSITIVE IN FRAME f-main = YES.

    FIND bf-rep-parada-ctrab NO-LOCK
        WHERE ROWID(bf-rep-parada-ctrab) = p-row-parada NO-ERROR.
    
    if  param-sfc.log-tipo-relogio THEN
          run pi-sec-to-formatted-time (input bf-rep-parada-ctrab.int-1,
                                        output c-hra-fim-parada).
      else
          ASSIGN c-hra-fim-parada  = string(bf-rep-parada-ctrab.int-1 / 36).

    DISP bf-rep-parada-ctrab.data-1 @ dt-dat-fim-parada 
         c-hra-fim-parada
        WITH FRAME f-main.
    
END.

ASSIGN c-cod-parada:SENSITIVE IN FRAME f-main = YES.

IF dt-dat-fim-parada:SENSITIVE IN FRAME f-main = TRUE THEN
    APPLY "entry":U TO dt-dat-fim-parada IN FRAME f-main.
ELSE
    APPLY "entry":U TO c-cod-parada IN FRAME f-main.

IF VALID-HANDLE(h-pag-2) THEN
    RUN setaReanalise IN h-pag-2(INPUT YES).


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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHandlePag2 V-table-Win 
PROCEDURE setaHandlePag2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle-pag-2 AS HANDLE NO-UNDO.

ASSIGN h-pag-2 = p-handle-pag-2.

RETURN "OK":U.
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

