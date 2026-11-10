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
{include/i-prgvrs.i V04IN530 2.00.00.006 } /*** "010006" 27/08/2024 08:50:28 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in530 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

&Scop adm-attribute-dlg support/viewerd.w

{include/i-vrtab.i operador}
{include/i-vrtab.i equipe-prod}
{sfc/sfapi010.i} /** Temp Table tt-import-rep-parada **/
{cdp/cd0666.i}   /** Temp Table tt-erro **/

define variable h-boin530         as   handle                                 no-undo.
DEFINE VARIABLE h-sfapi010        AS   HANDLE                                 NO-UNDO.
define variable l-ok              as   logical                                no-undo.
define variable de-qtd-segs-inic  like rep-parada-ctrab.qtd-segs-inic         no-undo.
define variable de-qtd-segs-fim   like rep-parada-ctrab.qtd-segs-fim          no-undo.
define variable de-val-refer-inic like rep-parada-ctrab.val-refer-inic-parada no-undo.
define variable c-return          as   character                              no-undo.
define variable v-dat-ult-event          as date no-undo.
define variable v-qtd-segs-ult-event     as dec  no-undo.
define variable l-existe-equipe          as log  no-undo.

DEFINE VARIABLE rw-ctrab            AS ROWID      NO-UNDO.
DEFINE VARIABLE rw-rep-parada-ctrab AS ROWID      NO-UNDO.

DEFINE VARIABLE l-emite-ss          AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-envia-email       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE i-nr-ord-produ      AS INTEGER    NO-UNDO.
DEFINE VARIABLE i-nr-soli-serv      AS INTEGER    NO-UNDO.

DEFINE VARIABLE v-row-parent        AS ROWID      NO-UNDO.
DEFINE VARIABLE v-row-table         AS ROWID      NO-UNDO.

DEFINE VARIABLE l-sfc-mudancas-mi   AS LOGICAL    NO-UNDO.
DEFINE VARIABLE l-sfc-mudancas      AS LOGICAL    NO-UNDO.

{sfc/sf0309.i} /*Funcao para tratamento de leave dos campos de hora*/
{sfc/sf0108.i} /*funcao de tratamento de leave do cod-operador*/

define variable h-boin469b   as handle no-undo.
DEFINE VARIABLE h-handle-pai AS HANDLE  NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL NO-UNDO.

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
&Scoped-Define ENABLED-OBJECTS i-num-om-progda dat-inic-parada ~
c-hra-inic-parada dat-fim-parada c-hra-fim-parada c-cod-parada rt-key ~
rt-mold 
&Scoped-Define DISPLAYED-OBJECTS d-qtd-tempo-ext c-cod-ctrab c-des-ctrab ~
i-num-om-progda dat-inic-parada c-hra-inic-parada dat-fim-parada ~
c-hra-fim-parada de-qtd-tempo-parada c-cod-parada c-des-parada c-operador ~
c-equipe c-des-equipe 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS dat-inic-parada 
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

DEFINE VARIABLE d-qtd-tempo-ext AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "T. Extra" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE dat-fim-parada AS DATE FORMAT "99/99/9999" INITIAL 03/08/02 
     LABEL "Data Fim Parada" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE dat-inic-parada AS DATE FORMAT "99/99/9999" INITIAL 03/08/02 
     LABEL "Data In°cio Parada" 
     VIEW-AS FILL-IN 
     SIZE 12.57 BY .88.

DEFINE VARIABLE de-qtd-tempo-parada AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "T. Ètil" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

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
     d-qtd-tempo-ext AT ROW 4.67 COL 75.43 COLON-ALIGNED
     c-cod-ctrab AT ROW 1.17 COL 26 COLON-ALIGNED
     c-des-ctrab AT ROW 1.17 COL 43.57 COLON-ALIGNED NO-LABEL
     i-num-om-progda AT ROW 2.17 COL 26 COLON-ALIGNED
     dat-inic-parada AT ROW 3.17 COL 26 COLON-ALIGNED
     c-hra-inic-parada AT ROW 3.17 COL 39 COLON-ALIGNED NO-LABEL
     dat-fim-parada AT ROW 4.67 COL 26 COLON-ALIGNED
     c-hra-fim-parada AT ROW 4.67 COL 39 COLON-ALIGNED NO-LABEL
     de-qtd-tempo-parada AT ROW 4.67 COL 53.86 COLON-ALIGNED
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
/* SETTINGS FOR FILL-IN dat-inic-parada IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN de-qtd-tempo-parada IN FRAME f-main
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
        {include/zoomvar.i &prog-zoom="inzoom/z01in516.w"
                           &campo=c-equipe
                           &campozoom=cod-equipe
                           &campo2=c-des-equipe
                           &campozoom2=des-equipe}
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
    /**************************************************************************/
                                                               /** Vari†veis **/   
    define variable da-ini-aux              as date    no-undo.
    define variable da-fim-aux              as date    no-undo.
    define variable de-qtd-segs-inic-parada as decimal no-undo.
    define variable de-qtd-segs-fim-parada  as decimal no-undo.
    define variable de-qtd-tempo-util       as decimal no-undo.
    def var d-tempo-ext                     as decimal no-undo.
    def var p-num-turno                     as int no-undo.
    def var c-cod-area                      as char no-undo.
    def var c-cod-calend                    as char initial ? no-undo.
    def var c-gm-codigo                     as char initial ? no-undo.
    /**************************************************************************/
                         /** Validaá‰es **/

    IF INPUT dat-fim-parada = 12/31/9999 THEN DO:
        if  param-sfc.log-tipo-relogio then
            run pi-sec-to-formatted-time (input 86399,
                                          output c-hra-fim-parada).
        else
            assign c-hra-fim-parada  = string(86399 / 36, "9999").
        ASSIGN c-hra-fim-parada:sensitive  in frame {&frame-name} = NO
               c-hra-fim-parada:screen-value in frame {&frame-name} = c-hra-fim-parada
               d-qtd-tempo-ext:screen-value in frame {&FRAME-NAME} = "0,00"
               de-qtd-tempo-parada:screen-value in frame {&FRAME-NAME} = "0,00".
        apply 'entry' to c-cod-parada in frame {&frame-name}.
        return no-apply.
    END.

    ASSIGN l-erro = NO.
    ASSIGN c-hra-fim-parada = fnValidaHora(c-hra-fim-parada:SCREEN-VALUE IN FRAME f-main).
    IF c-hra-fim-parada = ? THEN DO:
    
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
    
    DISPLAY c-hra-fim-parada WITH FRAME f-main.  
    
    if  input dat-inic-parada = input dat-fim-parada
    and input c-hra-fim-parada <= input c-hra-inic-parada then do:
        
        ASSIGN c-hra-fim-parada = c-hra-inic-parada.

        DISP c-hra-fim-parada WITH FRAME {&FRAME-NAME}.
    end.
    /**************************************************************************/    
                                                      /** Mostrar Tempo Ètil **/
    if  param-sfc.log-tipo-relogio then do:
        run pi-formatted-time-to-sec (input input c-hra-inic-parada,
                                      output de-qtd-segs-inic-parada).
        run pi-formatted-time-to-sec (input input c-hra-fim-parada,
                                      output de-qtd-segs-fim-parada).
    end.
    else
        assign de-qtd-segs-inic-parada = integer(input frame {&frame-name} c-hra-inic-parada) * 36
               de-qtd-segs-fim-parada  = integer(input frame {&frame-name} c-hra-fim-parada)  * 36.
    
    if  input frame {&frame-name} dat-inic-parada <> ?
    and input frame {&frame-name} dat-fim-parada  <> ? then do:
        assign de-qtd-tempo-util = ?
               da-ini-aux = date(string(input frame {&frame-name} dat-inic-parada,"99/99/9999"))
               da-fim-aux = date(string(input frame {&frame-name} dat-fim-parada,"99/99/9999")).
    
        run inbo/boin469a.p (input ctrab.gm-codigo,
                             Input ?,
                             Input-output da-fim-aux,
                             Input-output de-qtd-segs-fim-parada,
                             Input-output da-ini-aux,
                             Input-output de-qtd-segs-inic-parada,
                             input-output de-qtd-tempo-util).           

        assign c-gm-codigo = ctrab.gm-codigo.
        /** Tempo Extra **/
        run CalcularTemposCtrabExtra in h-boin469b (input-output c-cod-area,                 
                                                input-output c-gm-codigo,                
                                                input        c-cod-ctrab,
                                                input-output c-cod-calend,
                                                Input-output da-fim-aux,                  
                                                Input-output de-qtd-segs-fim-parada,             
                                                Input-output da-ini-aux,                 
                                                Input-output de-qtd-segs-inic-parada,            
                                                input         "":U,        
                                                Input-output de-qtd-tempo-util,
                                                output       d-tempo-ext,
                                                output       p-num-turno).      

        disp d-tempo-ext @ d-qtd-tempo-ext
             with frame {&frame-name}.
        disp de-qtd-tempo-util @ de-qtd-tempo-parada
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
    
    DISPLAY c-hra-inic-parada WITH FRAME f-main.    

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
      {include/zoomvar.i &prog-zoom="inzoom/z01in518.w"
                         &campo=c-operador
                         &campozoom=cod-operador
                         &campo2=c-des-equipe
                         &campozoom2=nom-operador}
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


&Scoped-define SELF-NAME dat-fim-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dat-fim-parada V-table-Win
ON LEAVE OF dat-fim-parada IN FRAME f-main /* Data Fim Parada */
DO:
    IF INPUT dat-fim-parada = 12/31/9999 THEN DO:
        if  param-sfc.log-tipo-relogio then
            run pi-sec-to-formatted-time (input 86399,
                                          output c-hra-fim-parada).
        else
            assign c-hra-fim-parada  = string(86399 / 36, "9999").
        ASSIGN c-hra-fim-parada:sensitive  in frame {&frame-name} = NO
               c-hra-fim-parada:screen-value in frame {&frame-name} = c-hra-fim-parada
               d-qtd-tempo-ext:screen-value in frame {&FRAME-NAME} = "0,00"
               de-qtd-tempo-parada:screen-value in frame {&FRAME-NAME} = "0,00".
    END.
    ELSE DO:
        ASSIGN c-hra-fim-parada:sensitive  in frame {&frame-name} = YES.
        IF INPUT dat-fim-parada > (INPUT dat-inic-parada + 365 * 2) THEN DO:
            ASSIGN dat-fim-parada = INPUT dat-inic-parada + 365 * 2.
            DISP dat-fim-parada WITH FRAME {&FRAME-NAME}.
            run utp/ut-msgs.p (input "show":U, 
                               input 27615, 
                               input "").
            apply 'entry' to dat-fim-parada in frame {&frame-name}.
            return no-apply.
        END.
    
        APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.
    END.
        
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dat-fim-parada V-table-Win
ON RETURN OF dat-fim-parada IN FRAME f-main /* Data Fim Parada */
DO:
    IF VALID-HANDLE(h-handle-pai) THEN DO:
        APPLY "leave":U TO SELF.
        RUN acionaOk IN h-handle-pai NO-ERROR.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dat-inic-parada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dat-inic-parada V-table-Win
ON RETURN OF dat-inic-parada IN FRAME f-main /* Data In°cio Parada */
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

find man-progda-ctrab where 
     man-progda-ctrab.cod-ctrab     = c-cod-ctrab and 
     man-progda-ctrab.num-om-progda = input frame {&frame-name} i-num-om-progda
     no-lock no-error.

    if  avail man-progda-ctrab then do:
        find last param-sfc no-lock no-error.
        if  param-sfc.log-tipo-relogio then do:
            run pi-sec-to-formatted-time (input man-progda-ctrab.qtd-segs-progda-inic,
                                          output c-hra-inic-parada).
        end.
        else
            assign c-hra-inic-parada = string(man-progda-ctrab.qtd-segs-progda-inic / 36).
        find motiv-parada where 
             motiv-parada.cod-parada = man-progda-ctrab.cod-parada 
             no-lock no-error.
        disp man-progda-ctrab.dat-progda-inic @ dat-inic-parada
             c-hra-inic-parada
             man-progda-ctrab.cod-parada @ c-cod-parada
             motiv-parada.des-parada     @ c-des-parada
           with frame {&frame-name}.
        assign c-cod-parada:sensitive in frame {&frame-name} = no.

    end.  /** If avail man-progda-ctrab **/
    else
        assign c-cod-parada:sensitive in frame {&frame-name} = yes.


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

c-cod-parada:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name}.
i-num-om-progda:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.
c-equipe:load-mouse-pointer        ("image~\lupa.cur") in frame {&frame-name}.
c-operador:load-mouse-pointer      ("image~\lupa.cur") in frame {&frame-name}.


  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
{sfc/sf9000.i}   /** pi-formatted-time-to-sec, pi-sec-to-formatted-time **/
{sfc/sf9001.i}   /** pi-det-ultimo-evento-ctrab, equipe, operador **/


ASSIGN l-sfc-mudancas-mi = FALSE.

RUN sfc/sf9999.p(OUTPUT l-sfc-mudancas).

IF l-sfc-mudancas THEN DO:
    FIND FIRST param-global NO-LOCK NO-ERROR.
    IF AVAIL param-global AND param-global.modulo-mi THEN
        ASSIGN l-sfc-mudancas-mi = TRUE.
END.

IF l-sfc-mudancas THEN
    c-equipe:load-mouse-pointer ("image/rbm.cur") in frame {&frame-name}.
ELSE
    ASSIGN c-equipe:POPUP-MENU IN FRAME f-main = ?
           c-equipe:HELP IN FRAME f-main       = "":U.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

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

  IF VALID-HANDLE(h-boin530) THEN
      delete procedure h-boin530.

  IF VALID-HANDLE(h-sfapi010) THEN do:
      run finalizaAPI in h-sfapi010.
      delete procedure h-sfapi010 no-error.
  end.

  IF VALID-HANDLE(h-boin469b) THEN
      delete procedure h-boin469b.


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

    {utp/ut-field.i mgind rep-parada-ctrab cod-ctrab        01} assign c-cod-ctrab:label     in frame {&frame-name} = return-value.
    {utp/ut-field.i mgind rep-parada-ctrab num-om-progda    01} assign i-num-om-progda:label in frame {&frame-name} = return-value.
    {utp/ut-field.i mgind rep-parada-ctrab dat-inic-parada  01} assign dat-inic-parada:label in frame {&frame-name} = return-value.
    {utp/ut-field.i mgind rep-parada-ctrab dat-fim-parada   01} assign dat-fim-parada:label  in frame {&frame-name} = return-value.
    {utp/ut-field.i mgind rep-parada-ctrab cod-parada       01} assign c-cod-parada:label    in frame {&frame-name} = return-value.
    {utp/ut-field.i mgind rep-parada-ctrab qtd-tempo-parada 01} assign de-qtd-tempo-parada:label in frame {&frame-name} = return-value.
                assign d-qtd-tempo-ext:screen-value in frame {&FRAME-NAME} = "0,00".
        
    run inbo/boin469b.p persistent set h-boin469b.
    /********************************************************************************/
                                                       /** Procura Centro Trabalho **/
    find last param-sfc no-lock no-error.

    find ctrab where rowid(ctrab) = rw-ctrab no-lock no-error.

    IF AVAIL ctrab THEN DO:

        assign c-cod-ctrab = ctrab.cod-ctrab
               c-des-ctrab = ctrab.des-ctrab.
    
        if  rw-rep-parada-ctrab <> ? then
            find rep-parada-ctrab where 
                    rowid(rep-parada-ctrab) = rw-rep-parada-ctrab EXCLUSIVE-LOCK no-error.

        if  avail rep-parada-ctrab then do:

            find motiv-parada where 
                    motiv-parada.cod-parada = rep-parada-ctrab.cod-parada no-lock no-error.

            assign i-num-om-progda = rep-parada-ctrab.num-om-progda
                   dat-inic-parada = rep-parada-ctrab.dat-inic-parada
                   dat-fim-parada  = today
                   c-cod-parada    = rep-parada-ctrab.cod-parada
                   c-des-parada    = if  avail motiv-parada 
                                     then motiv-parada.des-parada
                                     else "".
        
            if  param-sfc.log-tipo-relogio then do:
                run pi-sec-to-formatted-time (input rep-parada-ctrab.qtd-segs-inic,
                                              output c-hra-inic-parada).
                run pi-sec-to-formatted-time (input time,
                                              output c-hra-fim-parada).
            end.
            else
                assign c-hra-inic-parada = string(rep-parada-ctrab.qtd-segs-inic / 36, "9999")
                       c-hra-fim-parada  = string(time / 36, "9999").

            /*Caso a data e hora ini e fim tenham ficado iguais, recalcula a hora fim para 1 minuto depois.*/
            IF dat-inic-parada = dat-fim-parada AND substring(c-hra-inic-parada,1,4) = substring(c-hra-fim-parada,1,4) THEN DO:
                if  param-sfc.log-tipo-relogio THEN
                    run pi-sec-to-formatted-time (input rep-parada-ctrab.qtd-segs-inic + 60,
                                                  output c-hra-fim-parada).
                else
                    assign c-hra-fim-parada = string(rep-parada-ctrab.qtd-segs-inic + 60 / 36, "9999").
            END.
        
            if  ctrab.ind-reporte-mod = 2 then do:  /* operador */
                find operador
                    where operador.cod-operador = rep-parada-ctrab.cod-equipe no-lock no-error.
                if  avail operador then
                    assign c-operador   = operador.cod-operador
                           c-des-equipe = operador.nom-operador.
                else
                    assign c-operador   = ""
                           c-des-equipe = "".
            end.
            else do:
                find equipe-prod
                    where equipe-prod.cod-equipe = rep-parada-ctrab.cod-equipe no-lock no-error.
                if  avail equipe-prod then
                    assign c-equipe     = equipe-prod.cod-equipe
                           c-des-equipe = equipe-prod.des-equipe.
                else
                    assign c-equipe     = ""
                           c-des-equipe = "".
            end.
        end.    /***** if avail rep-parada-ctrab *******/
        else do:
            if  param-sfc.log-tipo-relogio then
                run pi-sec-to-formatted-time (input time,
                                              output c-hra-inic-parada).
            else
                assign c-hra-inic-parada  = string(time / 36, "9999").
        
            if  param-sfc.log-tipo-relogio then
                run pi-sec-to-formatted-time (input 86399,
                                              output c-hra-fim-parada).
            else
                assign c-hra-fim-parada  = string(86399 / 36, "9999").

            assign dat-inic-parada = TODAY
                   dat-fim-parada  = 12/31/9999.
        end.
        
        if ctrab.ind-reporte-mod = 2 then do:      /* operador */
            {utp/ut-field.i mgind operador cod-operador 01} 
            assign c-operador:label in frame {&frame-name} = return-value.
        end.
        else do:
            {utp/ut-field.i mgind equipe-prod cod-equipe 01} 
            assign c-equipe:label in frame {&frame-name} = return-value.
        end.   
    
        /* Dispatch standard ADM method.                             */
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
    
        /* Code placed here will execute AFTER standard behavior.    */
        if  ctrab.ind-reporte-mod = 2 then              /* Operador */
            assign c-operador:hidden in frame {&frame-name} = no
                   c-equipe:hidden   in frame {&frame-name} = yes.  
        else if ctrab.ind-reporte-mod = 3 then          /* Equipe */
            assign c-operador:hidden in frame {&frame-name} = yes
                   c-equipe:hidden   in frame {&frame-name} = no.  
        else
            assign c-operador:hidden     in frame {&frame-name} = yes
                   c-equipe:hidden       in frame {&frame-name} = yes
                   c-des-equipe:hidden   in frame {&frame-name} = yes.
        
        if  avail rep-parada-ctrab then
            assign i-num-om-progda:sensitive   in frame {&frame-name} = no
                   c-cod-parada:sensitive      in frame {&frame-name} = no
                   dat-inic-parada:sensitive   in frame {&frame-name} = no
                   c-hra-inic-parada:sensitive in frame {&frame-name} = no
                   c-equipe:sensitive          in frame {&frame-name} = no
                   c-operador:sensitive        in frame {&frame-name} = no
                   dat-fim-parada:sensitive    in frame {&frame-name} = yes
                   c-hra-fim-parada:sensitive  in frame {&frame-name} = yes.
        ELSE DO:

            IF l-sfc-mudancas = YES THEN DO:
                {utp/ut-liter.i Data_Fim_Prevista * }
                ASSIGN dat-fim-parada:LABEL IN FRAME {&frame-name} = return-value.
            END.

            assign i-num-om-progda:sensitive   in frame {&frame-name} = yes
                   c-cod-parada:sensitive      in frame {&frame-name} = yes
                   dat-inic-parada:sensitive   in frame {&frame-name} = yes
                   c-hra-inic-parada:sensitive in frame {&frame-name} = yes
                   c-equipe:sensitive          in frame {&frame-name} = yes
                   c-operador:sensitive        in frame {&frame-name} = yes
                   dat-fim-parada:sensitive    in frame {&frame-name} = l-sfc-mudancas
                   c-hra-fim-parada:sensitive  in frame {&frame-name} = l-sfc-mudancas.

        END.
        
        run inbo/boin530.p persistent set h-boin530.
    
        EMPTY TEMP-TABLE tt-import-rep-parada.
        EMPTY TEMP-TABLE tt-erro.
        run sfc/sfapi010.p PERSISTENT SET  h-sfapi010 (input  {&versao}, /*versao definida na sfapi010.i*/
                                                       input  table tt-import-rep-parada,
                                                       output table tt-erro).       

        DO WITH FRAME {&FRAME-NAME}:

            DISP c-cod-ctrab
                 c-des-ctrab
                 i-num-om-progda
                 dat-inic-parada
                 c-hra-inic-parada
                 dat-fim-parada
                 c-hra-fim-parada
                 de-qtd-tempo-parada
                 c-cod-parada
                 c-des-parada.

            IF dat-fim-parada = ? THEN
                DISPLAY "":U @ dat-fim-parada.

            IF c-operador:VISIBLE THEN
                DISP c-operador.

            IF c-equipe:VISIBLE THEN
                DISP c-equipe.

            IF c-des-equipe:VISIBLE THEN
                DISP c-des-equipe.

        END.

        IF l-sfc-mudancas-mi THEN DO:
            RUN new-state ("exibe-manutencao").
        END.

        IF AVAIL rep-parada-ctrab THEN
            APPLY "leave":U TO c-hra-fim-parada IN FRAME f-main.
    END.

    IF param-sfc.log-tipo-relogio = NO THEN 
        ASSIGN c-hra-inic-parada:FORMAT IN FRAME f-main = "99,99":U
               c-hra-fim-parada:FORMAT  IN FRAME f-main = "99,99":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-rep-parada V-table-Win 
PROCEDURE pi-add-rep-parada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
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

    assign c-hra-fim-parada = c-hra-inic-parada
           dat-inic-parada:screen-value in frame {&frame-name} = string(v-dat-ult-event,"99/99/9999")
           dat-fim-parada:screen-value in frame {&frame-name}  = string(v-dat-ult-event,"99/99/9999").

    display c-hra-inic-parada
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
end.  /* ctrab */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-assign-rep-parada V-table-Win 
PROCEDURE pi-assign-rep-parada :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
define output parameter p-ok as logical initial yes no-undo.

/** variaveis CDAPI005 **/
def var    da-iniper-x        as date no-undo.      
def var    da-fimper-x        as date no-undo.    
def var    i-per-corrente     as int no-undo.  
def var    i-ano-corrente     as int no-undo. 
def var    da-aux-ini         as date no-undo.
def var    da-aux-fim         as date no-undo.
DEF VAR    c-ult-per-fech     AS CHAR NO-UNDO.

for each tt-import-rep-parada:
    delete tt-import-rep-parada.
end.

/*******************************************************************************/
                                                                  /** Iniciar **/

IF param-sfc.log-parada-atualiza-ggf = NO THEN DO:

    FIND LAST param-estoq NO-LOCK NO-ERROR.

    ASSIGN c-ult-per-fech = param-estoq.ult-per-fech.

    IF avail param-estoq AND param-estoq.tp-fech = 2 THEN DO:

        FOR FIRST estab-mat FIELDS(ult-per-fech)
             WHERE estab-mat.cod-estabel = area-produc.cod-estabel NO-LOCK:
        END.
    
        IF AVAIL estab-mat THEN 
            ASSIGN c-ult-per-fech = estab-mat.ult-per-fech.
    END.

    run cdp/cdapi005.p (input  c-ult-per-fech ,
                        output da-iniper-x    ,
                        output da-fimper-x    ,
                        output i-per-corrente ,
                        output i-ano-corrente ,
                        output da-aux-ini     ,
                        output da-aux-fim     ).
    
END.



if  rw-rep-parada-ctrab = ? then do:

    assign i-num-om-progda   = input frame {&frame-name} i-num-om-progda
           c-hra-inic-parada = input frame {&frame-name} c-hra-inic-parada
           c-cod-parada      = input frame {&frame-name} c-cod-parada.

    IF param-sfc.log-parada-atualiza-ggf = NO THEN DO:

        IF input frame {&frame-name} dat-inic-parada < da-aux-fim THEN DO:
    
            {utp/ut-liter.i In°cio * }
        
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 56451,
                              INPUT RETURN-VALUE).
        
            IF RETURN-VALUE <> "YES":U THEN DO:
                ASSIGN p-ok = NO.
                RETURN "NOK":U.
            END.
        END.
    END.

    IF NOT(c-operador:HIDDEN IN FRAME {&FRAME-NAME}) THEN
        ASSIGN c-operador    = input frame {&frame-name} c-operador.

    IF NOT(c-equipe:HIDDEN IN FRAME {&FRAME-NAME}) THEN
        ASSIGN c-equipe      = input frame {&frame-name} c-equipe.

    if  param-sfc.log-tipo-relogio then do:    /**** Hexadecimal ****/
        run pi-formatted-time-to-sec ( input input frame {&frame-name} c-hra-inic-parada,
                                       output de-qtd-segs-inic).
        run pi-formatted-time-to-sec ( input input frame {&frame-name} c-hra-fim-parada,
                                       output de-qtd-segs-fim).
    end.
    else            /**** Centesimal ****/
        assign de-qtd-segs-inic = int(input frame {&frame-name} c-hra-inic-parada) * 36
               de-qtd-segs-fim  = int(input frame {&frame-name} c-hra-fim-parada) * 36.

    /** Verificar se j† existe Registro para esta chave **/
    run pi-converte-data-segs-valor (input input frame {&frame-name} dat-inic-parada,
                                     input de-qtd-segs-inic,
                                     output de-val-refer-inic).

    run findId in h-boin530 (input  c-cod-ctrab,
                             input  de-val-refer-inic,
                             output c-return).

    if c-return = "" then do:    /** Registro Encontrado **/

        &IF DEFINED (bf_man_trans_assinc) &THEN
            {utp/ut-table.i movmfg rep-parada-ctrab 1}
        &ELSE
            {utp/ut-table.i movind rep-parada-ctrab 1}
        &ENDIF
        run utp/ut-msgs.p (input "show",
                           input 7,
                           input return-value).
        apply 'entry' to i-num-om-progda in frame {&frame-name}.
       /* return 'ADM-ERROR':U.*/
        assign p-ok = no.
        RETURN NO-APPLY.

    end.
    else do:        /** Registro n∆o encontrado **/

        create tt-import-rep-parada.
        assign tt-import-rep-parada.tipo-rep        = 2 /** Iniciar **/
               tt-import-rep-parada.cod-ctrab       = c-cod-ctrab
               tt-import-rep-parada.cod-parada      = c-cod-parada
               tt-import-rep-parada.cod-operador    = c-operador
               tt-import-rep-parada.cod-equipe      = c-equipe
               tt-import-rep-parada.dat-inic-parada = input frame {&frame-name} dat-inic-parada
               tt-import-rep-parada.hr-inic-parada  = de-qtd-segs-inic
               tt-import-rep-parada.dat-fim-parada  = input frame {&frame-name} dat-fim-parada
               tt-import-rep-parada.hr-fim-parada   = de-qtd-segs-fim.
               tt-import-rep-parada.num-om-progda   = i-num-om-progda.
    end.

end.  /** If rw-rep-parada-ctrab **/

/*******************************************************************************/
                                                                /** Finalizar **/
else do:

    IF param-sfc.log-parada-atualiza-ggf = NO THEN DO:
        IF input frame {&frame-name} dat-fim-parada < da-aux-fim then do:
            
            {utp/ut-liter.i TÇrmino * }
            
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 56451,
                              INPUT RETURN-VALUE).
            
            IF RETURN-VALUE <> "YES":U THEN DO:
                ASSIGN p-ok = NO.
                RETURN "NOK":U.
            END.
        END.
    END.

    assign c-hra-fim-parada = input frame {&frame-name} c-hra-fim-parada.

    if  param-sfc.log-tipo-relogio then do:    /**** Hexadecimal ****/
        run pi-formatted-time-to-sec ( input input frame {&frame-name} c-hra-inic-parada,
                                       output de-qtd-segs-inic).
        run pi-formatted-time-to-sec ( input input frame {&frame-name} c-hra-fim-parada,
                                       output de-qtd-segs-fim).
    end.
    else            /**** Centesimal ****/
        assign de-qtd-segs-inic = int(input frame {&frame-name} c-hra-inic-parada) * 36
               de-qtd-segs-fim  = int(input frame {&frame-name} c-hra-fim-parada) * 36.

    create tt-import-rep-parada.
    assign tt-import-rep-parada.tipo-rep        = 3  /** Finalizar **/
           tt-import-rep-parada.cod-ctrab       = c-cod-ctrab
           tt-import-rep-parada.cod-parada      = c-cod-parada
           tt-import-rep-parada.cod-operador    = c-operador
           tt-import-rep-parada.cod-equipe      = c-equipe
           tt-import-rep-parada.dat-inic-parada = input frame {&frame-name} dat-inic-parada
           tt-import-rep-parada.hr-inic-parada  = de-qtd-segs-inic
           tt-import-rep-parada.num-om-progda   = i-num-om-progda
           tt-import-rep-parada.dat-fim-parada  = input frame {&frame-name} dat-fim-parada
           tt-import-rep-parada.hr-fim-parada   = de-qtd-segs-fim.
end.

/*Deve efetuar esta aá∆o tanto em Iniciar como Finalizar, pois o campo Ordem de Produá∆o da p†gina 2 estar† dispon°vel
  para ediá∆o nos dois casos.*/
IF l-sfc-mudancas-mi THEN DO:
    RUN new-state ("atualiza-dados-manutencao").
END.

run pi-inicializa IN h-sfapi010 (INPUT  TRUE,
                                 INPUT  TRUE,
                                 INPUT  l-emite-ss,
                                 INPUT  l-envia-email,
                                 INPUT  FALSE,
                                 INPUT  i-nr-ord-produ,
                                 INPUT  TABLE tt-import-rep-parada,
                                 OUTPUT TABLE tt-erro).

for each tt-erro exclusive-lock:
    assign p-ok = no.
end.
if not(p-ok) then
    run cdp/cd0666.w (input table tt-erro).

RETURN "OK":U.
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
    DEFINE INPUT PARAMETER v-row-table-externo  AS ROWID NO-UNDO.


    assign v-row-parent = v-row-parent-externo
           v-row-table  = v-row-table-externo.

    ASSIGN rw-ctrab            = v-row-parent
           rw-rep-parada-ctrab = v-row-table.

    find ctrab
        where rowid(ctrab) = v-row-parent no-lock no-error.

    FIND rep-parada-ctrab 
        WHERE ROWID(rep-parada-ctrab) = v-row-table NO-LOCK NO-ERROR.


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

    DEFINE OUTPUT PARAMETER p-cod-ctrab                 AS CHARACTER    NO-UNDO.
    DEFINE OUTPUT PARAMETER p-val-refer-inic-parada     AS DECIMAL      NO-UNDO.


    IF AVAIL rep-parada-ctrab THEN DO:
        ASSIGN p-cod-ctrab             = rep-parada-ctrab.cod-ctrab
               p-val-refer-inic-parada = rep-parada-ctrab.val-refer-inic-parada.
    END.

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


