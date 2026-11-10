&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V01IN535 2.00.00.017 } /*** "010017" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in535 MUT}
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

def var c-hra        as char  no-undo.

{cdp/cdcfgman.i}

DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE l-modificacao  AS LOGICAL INIT NO NO-UNDO.
{include/i-vrtab.i grup-maquina}
{include/i-vrtab.i area-produc-ctrab}
{include/i-vrtab.i split-operac}

DEF VAR h-pg-3 AS HANDLE NO-UNDO.

DEF NEW GLOBAL SHARED VAR glob-estabel-zoom AS CHAR INIT ? NO-UNDO.

DEFINE VARIABLE hProgramZoom AS HANDLE     NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES split-operac
&Scoped-define FIRST-EXTERNAL-TABLE split-operac


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR split-operac.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS split-operac.nr-ord-produ ~
split-operac.cod-ferr-prod 
&Scoped-define ENABLED-TABLES split-operac
&Scoped-define FIRST-ENABLED-TABLE split-operac
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS split-operac.nr-ord-produ ~
split-operac.it-codigo split-operac.cod-roteiro split-operac.op-codigo ~
split-operac.num-split-operac split-operac.gm-codigo split-operac.cod-ctrab ~
split-operac.cod-area-produc split-operac.cod-ferr-prod ~
split-operac.qtd-previs-operac 
&Scoped-define DISPLAYED-TABLES split-operac
&Scoped-define FIRST-DISPLAYED-TABLE split-operac
&Scoped-Define DISPLAYED-OBJECTS c-desc-item c-refer c-desc-rot ~
c-desc-operacao c-desc-gm c-desc-ctrab fi-des-area-produc c-des-ferr-prod ~
c-un-med-tempo c-estado dat-liber c-hora 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-cod-ctrab 
       MENU-ITEM m_CTs_do_Grupo_de_Mquina LABEL "CTs do Grupo de M†quina"
       MENU-ITEM m_Centros_de_Trabalho LABEL "Centros de Trabalho".

DEFINE MENU POPUP-MENU-cod-ferr-prod 
       MENU-ITEM m_Ferramentas_do_Centro_de_Tr LABEL "Ferramentas do Centro de Trabalho"
       MENU-ITEM m_Ferramentas  LABEL "Ferramentas"   .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-des-ferr-prod AS CHARACTER FORMAT "X(200)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ctrab AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-gm AS CHARACTER FORMAT "X(32)":U 
     VIEW-AS FILL-IN 
     SIZE 28 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 37.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-operacao AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 34 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-rot AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-hora AS CHARACTER FORMAT "99:99":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE c-refer AS CHARACTER FORMAT "x(08)":U 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-un-med-tempo AS CHARACTER FORMAT "X(20)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14.86 BY .88 NO-UNDO.

DEFINE VARIABLE dat-liber AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-refugo AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE de-perc-retrab AS DECIMAL FORMAT ">9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-area-produc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 4.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 8.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     split-operac.nr-ord-produ AT ROW 1.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13.72 BY .88
     split-operac.it-codigo AT ROW 2.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-item AT ROW 2.17 COL 36.86 COLON-ALIGNED NO-LABEL
     c-refer AT ROW 2.17 COL 74 COLON-ALIGNED NO-LABEL
     split-operac.cod-roteiro AT ROW 3.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     c-desc-rot AT ROW 3.17 COL 36.86 COLON-ALIGNED NO-LABEL
     split-operac.op-codigo AT ROW 4.17 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     split-operac.num-split-operac AT ROW 4.17 COL 26.86 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-desc-operacao AT ROW 4.17 COL 36.86 COLON-ALIGNED NO-LABEL
     split-operac.gm-codigo AT ROW 5.79 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-desc-gm AT ROW 5.79 COL 37 COLON-ALIGNED NO-LABEL
     split-operac.cod-ctrab AT ROW 6.79 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-desc-ctrab AT ROW 6.79 COL 36.86 COLON-ALIGNED NO-LABEL
     split-operac.cod-area-produc AT ROW 7.71 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     fi-des-area-produc AT ROW 7.71 COL 37 COLON-ALIGNED NO-LABEL
     split-operac.cod-ferr-prod AT ROW 8.63 COL 19.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17 BY .88
     c-des-ferr-prod AT ROW 8.63 COL 37 COLON-ALIGNED NO-LABEL
     split-operac.qtd-previs-operac AT ROW 9.58 COL 19.57 COLON-ALIGNED FORMAT ">,>>>,>>>,>>9.9999":U
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     de-perc-refugo AT ROW 9.63 COL 70 COLON-ALIGNED
     c-un-med-tempo AT ROW 10.58 COL 19.57 COLON-ALIGNED
     de-perc-retrab AT ROW 10.63 COL 70 COLON-ALIGNED
     c-estado AT ROW 11.58 COL 19.57 COLON-ALIGNED
     dat-liber AT ROW 12.58 COL 19.57 COLON-ALIGNED
     c-hora AT ROW 12.58 COL 34 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 5.5 COL 1
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
         HEIGHT             = 13.08
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-des-ferr-prod IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-gm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-operacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-rot IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-hora IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-med-tempo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.cod-area-produc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.cod-ctrab IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       split-operac.cod-ctrab:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-ctrab:HANDLE.

ASSIGN 
       split-operac.cod-ferr-prod:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-cod-ferr-prod:HANDLE.

/* SETTINGS FOR FILL-IN split-operac.cod-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN dat-liber IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-perc-refugo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       de-perc-refugo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-perc-retrab IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       de-perc-retrab:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-des-area-produc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.gm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.num-split-operac IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.op-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN split-operac.qtd-previs-operac IN FRAME f-main
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

&Scoped-define SELF-NAME split-operac.cod-area-produc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-area-produc V-table-Win
ON F5 OF split-operac.cod-area-produc IN FRAME f-main /* µrea Produá∆o */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in511.w"
                       &campo=split-operac.cod-area-produc
                       &campozoom=cod-area-produc
                       &campo2=fi-des-area-produc
                       &campozoom2=des-area-produc}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-area-produc V-table-Win
ON LEAVE OF split-operac.cod-area-produc IN FRAME f-main /* µrea Produá∆o */
DO:
     {include/leave.i &tabela=area-produc 
                 &atributo-ref=des-area-produc
                 &variavel-ref=fi-des-area-produc
                 &where="area-produc.cod-area-produc = input frame {&frame-name} split-operac.cod-area-produc"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-area-produc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF split-operac.cod-area-produc IN FRAME f-main /* µrea Produá∆o */
DO:
    APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME split-operac.cod-ctrab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-ctrab V-table-Win
ON F5 OF split-operac.cod-ctrab IN FRAME f-main /* Centro Trabalho */
DO:

    /*Zoom de Centros de Trabalho do Grupo M†quina*/

    IF NOT AVAIL grup-maquina OR grup-maquina.gm-codigo <> split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main THEN
        find first grup-maquina
             where grup-maquina.gm-codigo = split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main no-lock no-error.

    assign l-implanta = no.
    if avail grup-maquina THEN DO:

        FIND FIRST ord-prod WHERE ord-prod.nr-ord-produ = split-operac.nr-ord-produ NO-LOCK NO-ERROR.
        ASSIGN glob-estabel-zoom = ord-prod.cod-estabel. 

        assign gr-grup-maquina = rowid(grup-maquina).
        {include/zoomvar.i &prog-zoom="inzoom/z02in513.w"
                           &campo=split-operac.cod-ctrab
                           &campozoom=cod-ctrab
                           &campo2=c-desc-ctrab
                           &campozoom2=des-ctrab}     
                           
        wait-for close of wh-pesquisa.                
        ASSIGN glob-estabel-zoom = ?.

    END.
    ELSE
        APPLY "CHOOSE":U TO MENU-ITEM m_Centros_de_Trabalho IN MENU POPUP-MENU-cod-ctrab.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-ctrab V-table-Win
ON LEAVE OF split-operac.cod-ctrab IN FRAME f-main /* Centro Trabalho */
DO:
    IF split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main <> "":U THEN DO:
        IF split-operac.cod-ctrab:SENSITIVE IN FRAME f-main 
           AND CAN-FIND(FIRST ctrab WHERE ctrab.cod-ctrab = input frame f-main split-operac.cod-ctrab NO-LOCK) THEN DO:
        {include/leave.i 
                 &tabela=ctrab 
                 &atributo-ref=des-ctrab
                 &variavel-ref=c-desc-ctrab
                 &atributo-ref2=gm-codigo
                 &variavel-ref2=split-operac.gm-codigo
                 &where="ctrab.cod-ctrab = input frame f-main split-operac.cod-ctrab"}  
        END.
        ELSE DO:
            {include/leave.i 
                     &tabela=ctrab 
                     &atributo-ref=des-ctrab
                     &variavel-ref=c-desc-ctrab
                     &where="ctrab.cod-ctrab = input frame f-main split-operac.cod-ctrab"}  
        END.
    END.
    ELSE
        ASSIGN c-desc-ctrab:SCREEN-VALUE IN FRAME f-main = "":U.
             
     /*Atualiza a descricao do GM e reenvia as informaá‰es para a pag 3*/
     APPLY "leave":U TO split-operac.gm-codigo IN FRAME f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-ctrab V-table-Win
ON MOUSE-SELECT-DBLCLICK OF split-operac.cod-ctrab IN FRAME f-main /* Centro Trabalho */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME split-operac.cod-ferr-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-ferr-prod V-table-Win
ON F5 OF split-operac.cod-ferr-prod IN FRAME f-main /* Ferramenta */
DO:

    
    IF CAN-FIND(FIRST ctrab-ferram                                                           
                WHERE ctrab-ferram.cod-ctrab = split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main NO-LOCK) THEN DO:

        IF AVAIL split-operac THEN                                            
             find first oper-ord                                                                     
                  where oper-ord.nr-ord-produ   = split-operac.nr-ord-produ                          
                    and oper-ord.num-operac-sfc = split-operac.num-operac-sfc no-lock no-error.      

        IF l-mudancas-sfc THEN DO:                                                                                   
                                                                                                                     
            {method/zoomfields.i &ProgramZoom="mfzoom/z01mf514.w"                                                    
                                 &FieldZoom1="cod-ferr-prod"                                                         
                                 &FieldScreen1="split-operac.cod-ferr-prod"                                                 
                                 &Frame1="f-main"                                                                    
                                 &RunMethod="RUN recebeCtrabOper IN hProgramZoom (INPUT input frame f-main split-operac.cod-ctrab, 
                                                                                  INPUT IF AVAIL oper-ord THEN oper-ord.num-id-operacao ELSE ?,    
                                                                                  INPUT IF AVAIL oper-ord THEN oper-ord.op-altern ELSE ?)."        
                                 &EnableImplant="NO"}                                                                
            WAIT-FOR CLOSE OF hProgramZoom.
            APPLY "leave":U TO SELF.
        END.  
        ELSE DO:
            FIND FIRST area-produc-ctrab
                 WHERE area-produc-ctrab.cod-ctrab      = split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main
                   AND area-produc-ctrab.dat-inic-valid <= TODAY
                   AND area-produc-ctrab.dat-fim-valid  > TODAY NO-LOCK NO-ERROR.

            ASSIGN gr-area-produc-ctrab = IF AVAIL area-produc-ctrab THEN ROWID(area-produc-ctrab) ELSE ? 
                   gr-split-operac      = IF AVAIL split-operac THEN ROWID(split-operac) ELSE ?.  

            IF AVAIL split-operac AND NOT AVAIL oper-ord THEN
                 find first oper-ord
                      where oper-ord.nr-ord-produ   = split-operac.nr-ord-produ
                        and oper-ord.num-operac-sfc = split-operac.num-operac-sfc no-lock no-error.

            /*Caso haja dados para o zoom de Ferramentas do Ctrab, carrega este zoom. Sen∆o carrega zoom simples de Ferramenta.*/
            IF gr-area-produc-ctrab <> ? AND gr-split-operac <> ? AND
                CAN-FIND(FIRST ctrab-ferram 
                         WHERE ctrab-ferram.cod-ctrab = area-produc-ctrab.cod-ctrab 
                           AND CAN-FIND(FIRST op-ferram 
                                        WHERE op-ferram.num-id-operacao = oper-ord.num-id-operacao
                                          AND op-ferram.ferramenta      = ctrab-ferram.cod-ferr-prod NO-LOCK) NO-LOCK) THEN DO:
                /*Zoom de Ferramentas do Centro de Trabalho*/
                assign l-implanta = no.
                {include/zoomvar.i &prog-zoom="inzoom/z01in514.w"
                                   &campo=split-operac.cod-ferr-prod
                                   &campozoom=cod-ferr-prod
                                   &campo2=c-des-ferr-prod
                                   &campozoom2=des-ferr-prod}
            END.
            ELSE
                APPLY "CHOOSE":U TO MENU-ITEM m_Ferramentas IN MENU POPUP-MENU-cod-ferr-prod.  
        END.
    END.
    ELSE 
        /*Caso contr†rio, ou abaixo da 204, abre o zoom de Ferramentas simples*/    
        APPLY "CHOOSE":U TO MENU-ITEM m_Ferramentas IN MENU POPUP-MENU-cod-ferr-prod.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-ferr-prod V-table-Win
ON LEAVE OF split-operac.cod-ferr-prod IN FRAME f-main /* Ferramenta */
DO:
    {include/leave.i 
             &tabela=ferr-prod
             &atributo-ref=des-ferr-prod
             &variavel-ref=c-des-ferr-prod
             &where="ferr-prod.cod-ferr-prod = input frame f-main split-operac.cod-ferr-prod"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.cod-ferr-prod V-table-Win
ON MOUSE-SELECT-DBLCLICK OF split-operac.cod-ferr-prod IN FRAME f-main /* Ferramenta */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME split-operac.gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.gm-codigo V-table-Win
ON F5 OF split-operac.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom/z01in144.w"
                       &campo=split-operac.gm-codigo
                       &campozoom=gm-codigo
                       &campo2=c-desc-gm
                       &campozoom2=descricao}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.gm-codigo V-table-Win
ON LEAVE OF split-operac.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
    {include/leave.i 
             &tabela=grup-maquina 
             &atributo-ref=descricao
             &variavel-ref=c-desc-gm
             &where="grup-maquina.gm-codigo = input frame f-main split-operac.gm-codigo"}
             
    IF l-mudancas-sfc AND valid-handle(h-pg-3) THEN DO:

        IF split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main <> "":U THEN DO:
    
            FIND FIRST area-produc-ctrab
                 WHERE area-produc-ctrab.cod-ctrab = split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main
                   AND area-produc-ctrab.dat-inic-valid <= TODAY
                   AND area-produc-ctrab.dat-fim-valid  >  TODAY NO-LOCK NO-ERROR.
    
            IF AVAIL area-produc-ctrab THEN
                ASSIGN split-operac.cod-area-produc:SCREEN-VALUE IN FRAME f-main = area-produc-ctrab.cod-area-produc.
            ELSE
                ASSIGN split-operac.cod-area-produc:SCREEN-VALUE IN FRAME f-main = "".
        END.
        ELSE DO:
    
            IF NOT CAN-FIND(FIRST area-produc-ctrab NO-LOCK
                            WHERE area-produc-ctrab.gm-codigo       = split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main
                              AND area-produc-ctrab.cod-area-produc = split-operac.cod-area-produc:SCREEN-VALUE IN FRAME f-main
                              AND area-produc-ctrab.dat-inic-valid <= TODAY
                              AND area-produc-ctrab.dat-fim-valid  >  TODAY) THEN DO:
                FOR FIRST area-produc-ctrab NO-LOCK
                    WHERE area-produc-ctrab.gm-codigo       = split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main
                      AND area-produc-ctrab.dat-inic-valid <= TODAY
                      AND area-produc-ctrab.dat-fim-valid  >  TODAY:
                    ASSIGN split-operac.cod-area-produc:SCREEN-VALUE IN FRAME f-main = area-produc-ctrab.cod-area-produc.
                END.
            END.
    
        END.
    
        APPLY "leave":U TO split-operac.cod-area-produc IN FRAME f-main.

        RUN enviaInfoPag3.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL split-operac.gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF split-operac.gm-codigo IN FRAME f-main /* Grupo M†quina */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Centros_de_Trabalho
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Centros_de_Trabalho V-table-Win
ON CHOOSE OF MENU-ITEM m_Centros_de_Trabalho /* Centros de Trabalho */
DO:
    
    FIND FIRST ord-prod WHERE ord-prod.nr-ord-produ = split-operac.nr-ord-produ NO-LOCK NO-ERROR.
    ASSIGN glob-estabel-zoom = ord-prod.cod-estabel. 

    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom/z01in513.w"
                       &campo=split-operac.cod-ctrab
                       &campozoom=cod-ctrab
                       &campo2=c-desc-ctrab
                       &campozoom2=des-ctrab}   
                          
    wait-for close of wh-pesquisa.                
    ASSIGN glob-estabel-zoom = ?.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_CTs_do_Grupo_de_Mquina
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_CTs_do_Grupo_de_Mquina V-table-Win
ON CHOOSE OF MENU-ITEM m_CTs_do_Grupo_de_Mquina /* CTs do Grupo de M†quina */
DO:
    /*Zoom de Centros de Trabalho do Grupo M†quina*/

    IF NOT AVAIL grup-maquina OR grup-maquina.gm-codigo <> split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main THEN
        find first grup-maquina
             where grup-maquina.gm-codigo = split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main no-lock no-error.

    if avail grup-maquina then
        assign gr-grup-maquina = rowid(grup-maquina).
    ELSE
        ASSIGN gr-grup-maquina = ?.

    FIND FIRST ord-prod WHERE ord-prod.nr-ord-produ = split-operac.nr-ord-produ NO-LOCK NO-ERROR.
    ASSIGN glob-estabel-zoom = ord-prod.cod-estabel. 

    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom/z02in513.w"
                       &campo=split-operac.cod-ctrab
                       &campozoom=cod-ctrab
                       &campo2=c-desc-ctrab
                       &campozoom2=des-ctrab}
                       
    wait-for close of wh-pesquisa.                
    ASSIGN glob-estabel-zoom = ?.                           
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ferramentas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ferramentas V-table-Win
ON CHOOSE OF MENU-ITEM m_Ferramentas /* Ferramentas */
DO:
    
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="inzoom/z02in465.w"
                       &campo=split-operac.cod-ferr-prod
                       &campozoom=cod-ferr-prod
                       &campo2=c-des-ferr-prod
                       &campozoom2=des-ferr-prod} 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Ferramentas_do_Centro_de_Tr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Ferramentas_do_Centro_de_Tr V-table-Win
ON CHOOSE OF MENU-ITEM m_Ferramentas_do_Centro_de_Tr /* Ferramentas do Centro de Trabalho */
DO:
  
      IF l-mudancas-sfc THEN DO:
            IF AVAIL split-operac THEN                                                               
                 find first oper-ord                                                                 
                      where oper-ord.nr-ord-produ   = split-operac.nr-ord-produ                      
                        and oper-ord.num-operac-sfc = split-operac.num-operac-sfc no-lock no-error.  

            {method/zoomfields.i &ProgramZoom="mfzoom/z01mf514.w"                                                             
                                 &FieldZoom1="cod-ferr-prod"                                                                  
                                 &FieldScreen1="split-operac.cod-ferr-prod"                                                          
                                 &Frame1="f-main"                                                                             
                                 &RunMethod="RUN recebeCtrabOper IN hProgramZoom (INPUT input frame f-main split-operac.cod-ctrab,          
                                                                                  INPUT IF AVAIL oper-ord THEN oper-ord.num-id-operacao ELSE ?,
                                                                                  INPUT IF AVAIL oper-ord THEN oper-ord.op-altern ELSE ?)."
                                 &EnableImplant="NO"}   
            WAIT-FOR CLOSE OF hProgramZoom.
            APPLY "leave":U TO SELF.                                 
      END.
      ELSE DO:
          IF split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main <> "":U THEN
              FIND FIRST area-produc-ctrab
                   WHERE area-produc-ctrab.cod-ctrab      = split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main
                     AND area-produc-ctrab.dat-inic-valid <= TODAY
                     AND area-produc-ctrab.dat-fim-valid  > TODAY NO-LOCK NO-ERROR.
          
          ASSIGN gr-area-produc-ctrab = IF AVAIL area-produc-ctrab THEN ROWID(area-produc-ctrab) ELSE ?
                 gr-split-operac      = IF AVAIL split-operac THEN ROWID(split-operac) ELSE ?.
          
          /*Zoom de Ferramentas do Centro de Trabalho*/
          assign l-implanta = no.
          {include/zoomvar.i &prog-zoom="inzoom/z01in514.w"
                             &campo=split-operac.cod-ferr-prod
                             &campozoom=cod-ferr-prod
                             &campo2=c-des-ferr-prod
                             &campozoom2=des-ferr-prod}
      END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

/*Verifica se funcao Mudancas SFC est† implantada*/
RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).

{utp/ut-field.i movind oper-ord un-med-tempo 01}
assign c-un-med-tempo:label in frame {&frame-name} = return-value.

{utp/ut-field.i movind split-operac ind-estado-split 01}
assign c-estado:label in frame {&frame-name} = return-value.

{utp/ut-field.i movind oper-ord dat-liber-operac 01}
assign dat-liber:label in frame {&frame-name} = return-value.

IF l-mudancas-sfc THEN DO:
    {utp/ut-liter.i Perc._Padr∆o_Refugo * R}
    assign de-perc-refugo:label in frame {&frame-name} = return-value.
    {utp/ut-liter.i Perc._Padr∆o_Retrabalho * R}
    assign de-perc-retrab:label in frame {&frame-name} = return-value.
END.

/*Cursores campos com zoom*/
if split-operac.cod-ctrab:load-mouse-pointer ("image/rbm.cur":U) in frame {&frame-name} then.  
if split-operac.gm-codigo:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name} then.
if split-operac.cod-ferr-prod:load-mouse-pointer ("image/rbm.cur":U) in frame {&frame-name} then.
if split-operac.cod-area-produc:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

{sfc/sf9000.i}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enviaInfoPag3 V-table-Win 
PROCEDURE enviaInfoPag3 :
/*------------------------------------------------------------------------------
  Purpose:     Envia as informaá‰es necess†rias ao processamento da Pag 3
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR p-gm-codigo       LIKE split-operac.gm-codigo NO-UNDO.
DEF VAR p-cod-ctrab       LIKE split-operac.cod-ctrab NO-UNDO.
DEF VAR p-cod-ferr-prod   LIKE split-operac.cod-ferr-prod NO-UNDO.
DEF VAR p-cod-area-produc LIKE area-produc.cod-area-produc NO-UNDO.

RUN retornaCamposEditaveis(OUTPUT p-gm-codigo      ,
                           OUTPUT p-cod-ctrab      ,
                           OUTPUT p-cod-ferr-prod  ,
                           OUTPUT p-cod-area-produc).

RUN recebeInfoPag1 IN h-pg-3(INPUT p-gm-codigo,
                             INPUT p-cod-ctrab,
                             INPUT p-cod-area-produc).
RETURN "OK":U.
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

    FOR FIRST param-cp FIELDS(param-cp.log-integr-ppi-mes) NO-LOCK :
    END.
     
    if param-cp.log-integr-ppi-mes then do:         
      if not avail ord-prod then
          FIND FIRST ord-prod 
              WHERE ord-prod.nr-ord-produ = split-operac.nr-ord-produ NO-LOCK NO-ERROR.
      run cpp/cpapi301b.p ( input rowid(ord-prod),
                            input ord-prod.nr-ord-produ, 
                            input 2). /*alteracao*/
      if return-value = "NOK" then do:
      END.
    end.



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
    
    IF l-mudancas-sfc THEN DO WITH FRAME {&FRAME-NAME}:
        DISABLE de-perc-refugo
                de-perc-retrab.
    END.

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
  
  assign split-operac.nr-ord-produ:sensitive in frame {&frame-name} = no.

  if avail split-operac then do with frame {&frame-name}:
     find first item
          where item.it-codigo = split-operac.it-codigo no-lock no-error.
     assign c-desc-item = if avail item then item.desc-item else "":U.

     find first rot-fabric
          where rot-fabric.cod-roteiro = split-operac.cod-roteiro no-lock no-error.
     assign c-desc-rot = if avail rot-fabric then rot-fabric.descricao else "":U.

     find first oper-ord
          where oper-ord.nr-ord-produ   = split-operac.nr-ord-produ
            and oper-ord.num-operac-sfc = split-operac.num-operac-sfc no-lock no-error.
     assign c-desc-operacao = if avail oper-ord then oper-ord.descricao else "":U
            c-un-med-tempo  = if avail oper-ord then {ininc/i03in260.i 04 oper-ord.un-med-tempo} else "":U
            dat-liber       = if avail oper-ord then oper-ord.dat-liber-operac else ?.
     FIND FIRST ord-prod
         WHERE ord-prod.nr-ord-produ = split-operac.nr-ord-produ NO-LOCK NO-ERROR.
     ASSIGN c-refer = IF AVAIL ord-prod THEN ord-prod.cod-refer ELSE "".

     DISPLAY split-operac.cod-ferr-prod WITH FRAME f-main.

/*      find first grup-maquina                                                         */
/*           where grup-maquina.gm-codigo = split-operac.gm-codigo no-lock no-error.    */
/*      assign c-desc-gm = if avail grup-maquina then grup-maquina.descricao else "":U. */

/*      find first ctrab                                                      */
/*           where ctrab.cod-ctrab = split-operac.cod-ctrab no-lock no-error. */
/*      assign c-desc-ctrab = if avail ctrab then ctrab.des-ctrab else "":U.  */

     assign c-estado = {ininc/i01in535.i 04 split-operac.ind-estado-split}.

     IF AVAIL oper-ord THEN
        run pi-sec-to-formatted-time (oper-ord.qtd-segs-liber-operac, output c-hra).

     assign c-hora = c-hra.
     
     IF l-mudancas-sfc THEN DO:
         ASSIGN de-perc-refugo:SCREEN-VALUE = STRING(split-operac.val-perc-refugo)
                de-perc-retrab:SCREEN-VALUE = STRING(split-operac.val-perc-retrab).
     END.

  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  APPLY "leave":U TO split-operac.gm-codigo       IN FRAME f-main.
  APPLY "leave":U TO split-operac.cod-ctrab       IN FRAME f-main.
  APPLY "leave":U TO split-operac.cod-ferr-prod   IN FRAME f-main.
  APPLY "leave":U TO split-operac.cod-area-produc IN FRAME f-main.

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

    IF l-mudancas-sfc THEN DO WITH FRAME {&FRAME-NAME}:
        ENABLE de-perc-refugo
               de-perc-retrab.
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
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  IF l-mudancas-sfc THEN DO WITH FRAME {&FRAME-NAME}:
      ASSIGN de-perc-refugo:HIDDEN = FALSE
             de-perc-retrab:HIDDEN = FALSE.
  END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCamposEditaveis V-table-Win 
PROCEDURE retornaCamposEditaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF OUTPUT PARAM p-gm-codigo        LIKE split-operac.gm-codigo         NO-UNDO.
DEF OUTPUT PARAM p-cod-ctrab        LIKE split-operac.cod-ctrab         NO-UNDO.
DEF OUTPUT PARAM p-cod-ferr-prod    LIKE split-operac.cod-ferr-prod     NO-UNDO.
DEF OUTPUT PARAM p-cod-area-produc  LIKE area-produc.cod-area-produc    NO-UNDO.

    ASSIGN p-gm-codigo       = split-operac.gm-codigo:SCREEN-VALUE IN FRAME f-main
           p-cod-ctrab       = split-operac.cod-ctrab:SCREEN-VALUE IN FRAME f-main
           p-cod-ferr-prod   = split-operac.cod-ferr-prod:SCREEN-VALUE IN FRAME f-main
           p-cod-area-produc = split-operac.cod-area-produc:SCREEN-VALUE IN FRAME f-main.

RETURN "OK".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE retornaCamposSfc V-table-Win 
PROCEDURE retornaCamposSfc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEFINE OUTPUT PARAMETER p-val-perc-refugo   AS DECIMAL  NO-UNDO.
DEFINE OUTPUT PARAMETER p-val-perc-retrab   AS DECIMAL  NO-UNDO.

IF l-mudancas-sfc THEN DO:

    ASSIGN p-val-perc-refugo = INPUT FRAME {&FRAME-NAME} de-perc-refugo
           p-val-perc-retrab = INPUT FRAME {&FRAME-NAME} de-perc-retrab.

END.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaModificacao V-table-Win 
PROCEDURE setaModificacao :
/*------------------------------------------------------------------------------
  Purpose:     chamada pelo sf0311c.w, quando o mesmo Ç chamado do CP0301 - Funcao Mudancas SFC
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-h-pg-3 AS HANDLE NO-UNDO.

ASSIGN h-pg-3 = p-h-pg-3.
IF AVAIL split-operac 
    AND l-mudancas-sfc 
    AND AVAIL split-operac 
    AND split-operac.ind-estado-split < 4 THEN DO WITH FRAME f-main:

    ASSIGN split-operac.gm-codigo:SENSITIVE       = YES
           split-operac.cod-ctrab:SENSITIVE       = YES
           split-operac.cod-ferr-prod:SENSITIVE   = YES
           split-operac.cod-area-produc:SENSITIVE = YES
           de-perc-refugo:SENSITIVE               = YES
           de-perc-retrab:SENSITIVE               = YES.
END.

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

