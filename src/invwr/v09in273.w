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
{include/i-prgvrs.i V09IN273 2.00.00.082 } /*** "010082" 05/11/2025 12:01:16 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v09in273 MUT}
&ENDIF


/*------------------------------------------------------------------------
File: Description: from VIEWER.W - Template for SmartViewer Objects
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
{cdp/cdcfgmnt.i}
{utp/ut-glob.i}
{btb/btb008za.i0}
{mip/mi1024.i} /* tt-apont; tt-seq */


/* global variable definitions */
def new global shared var v-row-parent    as rowid no-undo.                                
def new global shared var g-ord-taref     as rowid no-undo.
def new global shared var gr-ord-manut    as rowid no-undo.
def new global shared var gr-mi-espec     as rowid no-undo.
def new global shared var gr-tecn-mi      as rowid no-undo.
def new global shared var g-da-reporte    as date  no-undo.
def new global shared var c-opcao         as char  no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def buffer b-ord-taref for ord-taref.

def temp-table tt-esp NO-UNDO
    field indicador     as logical format "*/ "
    field cd-tarefa     like ord-taref.cd-tarefa
    field tp-especial   like ord-esp.tp-especial
    field descricao     like mi-espec.descricao
    field encerrada     like ord-esp.encerrada
    field conclusao     like ord-esp.conclusao
    index codigo is unique primary cd-tarefa tp-especial
    index cod-ind indicador.

def temp-table tt-mao-de-obra NO-UNDO
    field indicador    as logical format "*/ "
    field cd-tecnico   like ord-mob.cd-tecnico
    field nome-compl   like tecn-mi.nome-compl
    field tp-especial  like ord-mob.tp-especial
    field cd-tarefa    like ord-mob.cd-tarefa    
    field c-desc-taref like ord-taref.descricao
    field cc-codigo    like ord-mob.cc-codigo
    field dt-trans     like ord-mob.dt-trans
    field horas-report like ord-mob.horas-report
    field tipo-trans   like ord-mob.tipo-trans
    &if defined (bf_mnt_ems203) &then
       field nr-ord-produ like ord-mob.nr-ord-produ
       field nr-reporte   like ord-mob.nr-reporte
       field hora-inicio  like ord-mob.hora-inicio 
       field hora-termino like ord-mob.hora-termino 
    &endif.
    
DEF VAR de-conclu     AS DEC  format ">>9.99" no-undo.
DEF VAR c-formato-1   AS CHAR init "99:99"    no-undo.
DEF VAR c-formato-2   AS CHAR init "99,9999"  no-undo.
DEF VAR c-relogio     AS CHAR format "x(10)"  no-undo.
DEF VAR l-primeira    AS LOG  init yes        no-undo.
DEF VAR c-combo       AS CHAR format "x(10)"  no-undo.
DEF VAR l-implantado  AS LOG                  no-undo.
DEF VAR l-temTurnoEspec AS LOG INITIAL YES    NO-UNDO.

DEF VAR d-hra-norm            AS DEC  NO-UNDO.
DEF VAR d-hra-ext             AS DEC  NO-UNDO.
DEF VAR d-hra-tot             AS DEC  NO-UNDO.
DEF VAR de-tempo-real         AS DEC  NO-UNDO.
DEF VAR de-par-tempo-real     AS DEC  NO-UNDO.
DEF VAR de-tempo              AS DEC  NO-UNDO.
DEF VAR de-valor              AS DEC  NO-UNDO.
DEF VAR de-minuto             AS DEC  NO-UNDO.
DEF VAR i-cont-narrativa      AS INT  NO-UNDO.
DEF VAR i-cont                AS INT  NO-UNDO.
DEF VAR i-valor               AS INT  NO-UNDO.
DEF VAR c-servidor            AS CHAR NO-UNDO.
DEF VAR c-tempo1              AS CHAR NO-UNDO.
DEF VAR c-tempo               AS CHAR NO-UNDO.
DEF VAR c-hora                AS CHAR NO-UNDO.
DEF VAR l-aux                 AS LOG  NO-UNDO.

DEF VAR c-tarefa-aux    LIKE ord-taref.cd-tarefa.
DEF VAR c-tecnico-aux   LIKE ord-mob.cd-tecnico.

def var i-nr-reporte like ord-mob.nr-reporte no-undo.

def var hDBOMovtoGGF as handle no-undo.
def var hDBOOrdProd  as handle no-undo.
def var h-movto-mob  as handle no-undo.
def var hProgramZoom as handle no-undo.

DEF VAR iNrTarefaRecebida AS INTEGER INIT 0 NO-UNDO.



{cdp/cdunif001.i}
DEFINE VARIABLE hShowMsg AS HANDLE      NO-UNDO.
DEFINE TEMP-TABLE RowErrors no-undo
       field ErrorSequence as integer
       field ErrorNumber   as integer
       field ErrorDescription as char
       field ErrorParameters as char
       field ErrorType       as char
       field Errorhelp       as char
       field Errorsubtype    as char.

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
&Scoped-define EXTERNAL-TABLES mi-espec
&Scoped-define FIRST-EXTERNAL-TABLE mi-espec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mi-espec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-cd-tecnico c-cd-tarefa ~
c-tp-especial c-cd-ccusto ~
da-reporte bt-apont cb-tp-relogio c-tempo-real c-tempo-real1 l-intervalo ~
c-cd-turno c-hora-inicio c-hora-termino c-hra-norm ~
c-hra-ext c-hra-tot bt-verif-apont l-encerrada de-conclusao c-hist-apont ~
c-observacao rt-mold 
&Scoped-Define DISPLAYED-OBJECTS c-cd-tecnico c-nome-compl c-cd-tarefa ~
c-descricao c-tp-especial c-desc-especial c-cd-ccusto c-desc-ccusto ~
da-reporte cb-tp-relogio c-tempo-real c-tempo-real1 l-intervalo c-cd-turno ~
c-descricao-turno c-hora-inicio c-hora-termino c-hra-norm c-hra-ext ~
c-hra-tot l-encerrada de-conclusao c-hist-apont c-observacao

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-tp-relogio 

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
DEFINE MENU POPUP-MENU-c-cd-turno 
       MENU-ITEM mi-zoom-turno-espec LABEL "Pesquisa Turnos da Especialidade"
       MENU-ITEM mi-zoom-turno  LABEL "Pesquisa Turnos".

DEFINE MENU POPUP-MENU-c-tp-especial
       MENU-ITEM mi-zoom-espec          LABEL "Pesquisa Especialidade"
       MENU-ITEM mi-zoom-espec-ordem    LABEL "Pesquisa Especialidade Ordem Manuten‡Æo"
       MENU-ITEM mi-zoom-espec-tecnico  LABEL "Pesquisa Especialidade T‚cnico".

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-apont 
     IMAGE-UP FILE "image\gr-zoo":U
     IMAGE-INSENSITIVE FILE "image\ii-zoo":U
     LABEL "" 
     SIZE 3.43 BY .88 TOOLTIP "Apontamentos do T‚cnico / Data".

DEFINE BUTTON bt-verif-apont 
     IMAGE-UP FILE "image\gr-zoo":U
     IMAGE-INSENSITIVE FILE "image\ii-zoo":U
     LABEL "" 
     SIZE 3.43 BY .88 TOOLTIP "Apontamentos a serem gerados".

DEFINE VARIABLE cb-tp-relogio AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-hist-apont AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 61.72 BY 3.88 NO-UNDO.

DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 61.72 BY 3.88 NO-UNDO.

DEFINE VARIABLE c-cd-ccusto AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo":R15 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-tarefa AS INTEGER FORMAT ">>>>9" INITIAL 100 
     LABEL "Tarefa Manuten‡Æo":R21 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-cd-tecnico AS CHARACTER FORMAT "99999-9" 
     LABEL "T‚cnico":R9 
     VIEW-AS FILL-IN 
     SIZE 9.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-turno AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Turno":R21 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-desc-ccusto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-especial AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 49.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 54.29 BY .88.

DEFINE VARIABLE c-descricao-turno AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 53.86 BY .88.

DEFINE VARIABLE c-hora-inicio AS CHARACTER FORMAT "99:99" INITIAL "0000" 
     LABEL "Hora In¡cio" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88.

DEFINE VARIABLE c-hora-termino AS CHARACTER FORMAT "99:99" INITIAL "0000" 
     LABEL "Hora T‚rmino" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88.

DEFINE VARIABLE c-hra-ext AS DECIMAL FORMAT " >>9.9999":U INITIAL 0 
     LABEL "Horas Extras" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-norm AS DECIMAL FORMAT " >>9.9999":U INITIAL 0 
     LABEL "Horas Normais" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-tot AS DECIMAL FORMAT " >>9.9999":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-compl AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 51.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-tempo-real AS CHARACTER FORMAT "X(8)" INITIAL "0" 
     LABEL "Tempo Real":R12 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-tempo-real1 AS DECIMAL FORMAT "99.9999":U INITIAL 0 
     LABEL "Tempo Real" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE c-tp-especial AS CHARACTER FORMAT "x(8)" 
     LABEL "Especialidade":R16 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE da-reporte AS DATE FORMAT "99/99/9999" 
     LABEL "Data Transa‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-conclusao AS DECIMAL FORMAT ">>9.99" INITIAL 0 
     LABEL "Percentual ConclusÆo":R24 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 18.

DEFINE VARIABLE l-encerrada AS LOGICAL INITIAL no 
     LABEL "Encerrada":L11 
     VIEW-AS TOGGLE-BOX
     SIZE 13 BY .75 NO-UNDO.

DEFINE VARIABLE l-intervalo AS LOGICAL INITIAL no 
     LABEL "Aponta durante intervalo?" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.43 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cd-tecnico AT ROW 1.25 COL 28.29 COLON-ALIGNED
     c-nome-compl AT ROW 1.25 COL 38.43 COLON-ALIGNED HELP
          "Nome Completo do T‚cnico" NO-LABEL
     c-cd-tarefa AT ROW 2.25 COL 28.29 COLON-ALIGNED
     c-descricao AT ROW 2.25 COL 35.57 COLON-ALIGNED NO-LABEL
     c-tp-especial AT ROW 3.25 COL 28.29 COLON-ALIGNED HELP
          "Tipo de Especialidade"
     c-desc-especial AT ROW 3.25 COL 40.57 COLON-ALIGNED NO-LABEL
     c-cd-ccusto AT ROW 4.25 COL 28.29 COLON-ALIGNED
     c-desc-ccusto AT ROW 4.25 COL 50.57 NO-LABEL
     da-reporte AT ROW 5.25 COL 28.29 COLON-ALIGNED
     bt-apont AT ROW 5.25 COL 44.43 HELP
          "Apontamentos do T‚cnico / Data"
     cb-tp-relogio AT ROW 6.33 COL 28.57 COLON-ALIGNED
     c-tempo-real AT ROW 7.5 COL 53.14 COLON-ALIGNED
     c-tempo-real1 AT ROW 7.5 COL 28.43 COLON-ALIGNED
     l-intervalo AT ROW 6.5 COL 30.43
     c-cd-turno AT ROW 7.46 COL 28.57 COLON-ALIGNED
     c-descricao-turno AT ROW 7.46 COL 36.14 COLON-ALIGNED NO-LABEL
     c-hora-inicio AT ROW 8.54 COL 28.43 COLON-ALIGNED HELP
          "Hora de In¡cio do Apontamento"
     c-hora-termino AT ROW 8.5 COL 69.72 COLON-ALIGNED HELP
          "Hora de T‚rmino do Apontamento"
     c-hra-norm AT ROW 8.54 COL 28.43 COLON-ALIGNED
     c-hra-ext AT ROW 8.5 COL 56.57 COLON-ALIGNED
     c-hra-tot AT ROW 8.5 COL 71.72 COLON-ALIGNED NO-LABEL
     bt-verif-apont AT ROW 8.54 COL 88.43 HELP
          "Apontamentos a serem gerados"
     l-encerrada AT ROW 9.83 COL 30.43
     de-conclusao AT ROW 9.63 COL 73.43 COLON-ALIGNED
     c-hist-apont AT ROW 10.83 COL 30.14 NO-LABEL WIDGET-ID 18
     c-observacao AT ROW 14.83 COL 30.14 NO-LABEL WIDGET-ID 20
     "Observa‡äes Apontamento:" VIEW-AS TEXT
          SIZE 19 BY .88 AT ROW 14.96 COL 10.72 WIDGET-ID 8
          FONT 1
     "Narrativa Tarefa:" VIEW-AS TEXT
          SIZE 12 BY .67 AT ROW 10.96 COL 18 WIDGET-ID 22
          FONT 1
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mi-espec
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
         HEIGHT             = 18
         WIDTH              = 92.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 18
       FRAME f-main:WIDTH            = 92.

ASSIGN 
       c-cd-turno:HIDDEN IN FRAME f-main           = TRUE
       c-cd-turno:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cd-turno:HANDLE
       c-tp-especial:POPUP-MENU IN FRAME f-main    = MENU POPUP-MENU-c-tp-especial:HANDLE.

/* SETTINGS FOR FILL-IN c-desc-ccusto IN FRAME f-main
   ALIGN-L                                                              */
ASSIGN c-descricao-turno:HIDDEN IN FRAME f-main = TRUE
       c-hist-apont:READ-ONLY IN FRAME f-main   = TRUE
       c-hora-inicio:HIDDEN IN FRAME f-main     = TRUE
       c-hora-termino:HIDDEN IN FRAME f-main    = TRUE
       c-tempo-real:HIDDEN IN FRAME f-main      = TRUE
       c-tempo-real1:HIDDEN IN FRAME f-main     = TRUE
       cb-tp-relogio:HIDDEN IN FRAME f-main     = TRUE
       l-intervalo:HIDDEN IN FRAME f-main       = TRUE.

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

&Scoped-define SELF-NAME bt-apont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-apont V-table-Win
ON CHOOSE OF bt-apont IN FRAME f-main
DO:
  run mip/mi0308g.w (input frame {&FRAME-NAME} c-cd-tecnico,
                     input frame {&FRAME-NAME} da-reporte,  
                     input frame {&FRAME-NAME} da-reporte).                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-verif-apont
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-verif-apont V-table-Win
ON CHOOSE OF bt-verif-apont IN FRAME f-main
DO:
 &if defined (bf_mnt_ems203) &then  
  IF CAN-FIND(FIRST tecn-mi WHERE 
                    tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                    tecn-mi.log-1      = NO NO-LOCK) THEN DO:
       if input frame {&FRAME-NAME} c-hora-inicio >= input frame {&FRAME-NAME} c-hora-termino then do:
           run utp/ut-msgs.p(input "show",
                             input 5820,
                             input c-hora-inicio:label in frame {&FRAME-NAME} + "~~" + 
                                   c-hora-termino:label in frame {&FRAME-NAME}).
           apply 'entry' to c-hora-inicio in frame {&frame-name}.
           return "error".
       end.   
  END.

   RUN pi-cria-apontamentos.
   if return-value <> "error":U then do:
            run mip/mi0308h.w (input input frame {&FRAME-NAME} c-cd-tecnico,
                         input input frame {&FRAME-NAME} c-cd-tarefa,
                         input input frame {&FRAME-NAME} c-tp-especial,
                         input input frame {&FRAME-NAME} da-reporte,
                         input table tt-apont).
   end.                         
 &endif                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cd-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-ccusto V-table-Win
ON F5 OF c-cd-ccusto IN FRAME f-main /* Centro Custo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in042.w"
                       &campo=c-cd-ccusto
                       &campozoom=cc-codigo}
    if  c-cd-ccusto <> "" then do:
        find centro-custo
            where centro-custo.cc-codigo = c-cd-ccusto
            no-lock no-error.
        if  avail centro-custo then do:
            assign c-desc-ccusto = centro-custo.descricao.
            disp c-desc-ccusto with frame {&frame-name}.
        end.
    end.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-ccusto V-table-Win
ON LEAVE OF c-cd-ccusto IN FRAME f-main /* Centro Custo */
DO:
  find centro-custo where
       centro-custo.cc-codigo = input frame {&frame-name} c-cd-ccusto
       no-lock no-error.
  if  avail centro-custo then do:
      assign c-desc-ccusto = centro-custo.descricao.
      display c-desc-ccusto with frame {&frame-name}.
  end.
  else do:
      assign c-desc-ccusto = "".
      display c-desc-ccusto with frame {&frame-name}.
  end.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-ccusto IN FRAME f-main /* Centro Custo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cd-tarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tarefa V-table-Win
ON ENTRY OF c-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
  ASSIGN c-tarefa-aux = INPUT FRAME {&FRAME-NAME} c-cd-tarefa.

  IF  iNrTarefaRecebida <> 0 AND c-cd-tarefa:SCREEN-VALUE IN FRAME f-main <> "" THEN DO:
      FIND FIRST ord-manut
           WHERE rowid(ord-manut) = gr-ord-manut NO-LOCK NO-ERROR.
      IF AVAIL ord-manut THEN DO:
          FIND FIRST ord-taref
               WHERE ord-taref.nr-ord-produ = ord-manut.nr-ord-produ
                 AND ord-taref.cd-tarefa    = iNrTarefaRecebida NO-LOCK NO-ERROR.
          IF AVAIL ord-taref THEN DO:
              ASSIGN c-cd-tarefa:SCREEN-VALUE IN FRAME f-main = string(iNrTarefaRecebida).
              ASSIGN c-descricao:SCREEN-VALUE IN FRAME f-main = ord-taref.descricao.
          END.
      END.
  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tarefa V-table-Win
ON F5 OF c-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in273.w"
                       &campo=c-cd-tarefa
                       &campozoom=cd-tarefa}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tarefa V-table-Win
ON LEAVE OF c-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
    IF c-tarefa-aux = INPUT FRAME {&FRAME-NAME} c-cd-tarefa THEN 
        RUN pi-procura-tarefa-especialidade. 

    IF    c-cd-tarefa:SCREEN-VALUE IN FRAME f-main = "0"
       OR c-cd-tarefa:SCREEN-VALUE IN FRAME f-main = ?  THEN DO:
        IF  iNrTarefaRecebida <> 0 THEN
            ASSIGN c-cd-tarefa:SCREEN-VALUE IN FRAME f-main = string(iNrTarefaRecebida).
    END.

    find ord-taref where
         ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and
         ord-taref.cd-tarefa    = input frame {&frame-name} c-cd-tarefa NO-LOCK no-error.
    if  avail ord-taref then DO:
        assign c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao
               c-hist-apont:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-taref.narrativa.     
    END.
    ELSE DO:
        assign c-descricao:screen-value in frame {&frame-name} = "".
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tarefa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cd-tecnico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tecnico V-table-Win
ON ENTRY OF c-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
    if  l-encerrada:screen-value in frame {&frame-name} = 'yes' then
        disable de-conclusao with frame {&frame-name}.
    else
        enable de-conclusao with frame {&frame-name}.

    IF  iNrTarefaRecebida <> 0 THEN DO:
        ASSIGN c-cd-tarefa:SCREEN-VALUE IN FRAME f-main = string(iNrTarefaRecebida).

        find ord-taref where
             ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and
             ord-taref.cd-tarefa    = iNrTarefaRecebida NO-LOCK no-error.
        if  avail ord-taref then DO:
            assign c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.
        END.
        ELSE DO:
            assign c-descricao:screen-value in frame {&frame-name} = "".
        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tecnico V-table-Win
ON F5 OF c-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="inzoom/z01in428.w"
                     &campo=c-cd-tecnico
                     &campozoom=cd-tecnico}
  if  c-cd-tecnico <> "" then do:
      find tecn-mi
          where tecn-mi.cd-tecnico = c-cd-tecnico
          no-lock no-error.
      if  avail tecn-mi then do:
          assign c-nome-compl = tecn-mi.nome-compl.
          disp c-nome-compl with frame {&frame-name}.
      end.
  end.                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tecnico V-table-Win
ON LEAVE OF c-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
   assign l-aux = c-cd-tecnico:modified in frame {&FRAME-NAME}.
   {cdp/cd9998.i}

   find tecn-mi where tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico
        NO-LOCK no-error.
   if avail tecn-mi then do:
      assign c-cd-ccusto  = tecn-mi.cc-codigo
             c-nome-compl = tecn-mi.nome-compl.
      find centro-custo where centro-custo.cc-codigo = c-cd-ccusto
           NO-LOCK no-error.
      if avail centro-custo then 
         assign c-desc-ccusto = centro-custo.descricao.
   end.
   else
       assign c-cd-ccusto  = ""
              c-nome-compl = ""
              c-desc-ccusto = ""
              c-tp-especial = ""
              c-desc-especial = ""
              c-descricao = ""
              c-cd-tarefa   = 0.

   disp c-cd-ccusto 
        c-nome-compl 
        c-desc-ccusto 
        with frame {&FRAME-NAME}.

   RUN pi-procura-tarefa-especialidade. 

   IF  c-cd-tarefa <> 0 THEN DO:
       find ord-taref where
            ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and
            ord-taref.cd-tarefa    = input frame {&frame-name} c-cd-tarefa NO-LOCK no-error.
       if  avail ord-taref then DO:
           assign c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao
                  c-hist-apont:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-taref.narrativa.     
       END.
   END.

   &if defined (bf_mnt_ems203) &then
       if l-aux then
          RUN pi-verifica-turno. 
       assign c-cd-tecnico:modified in frame {&FRAME-NAME} = no.
   &endif   


   /****** Comentado em 29/07/2003 por Rafael Rosario - Novo tratamento de leave dos campos
   *        para adequa‡Æo solicitada pelo PQU - FO 887755 e 887743
   *        
   *find first esp-tecn where
   *           esp-tecn.cd-tecnico = input frame {&frame-name} c-cd-tecnico and
   *           esp-tecn.atividade  = 1 no-lock no-error.
   *
   *find mi-espec where
   *     mi-espec.tp-especial = esp-tecn.tp-especial no-lock no-error.
   *  
   *if avail mi-espec then do:
   *   assign c-tp-especial:screen-value in frame {&frame-name} = esp-tecn.tp-especial
   *          c-desc-especial:screen-value in frame {&frame-name} = mi-espec.descricao.
   *end.
   *
   *find ord-manut where
   *     rowid(ord-manut) = gr-ord-manut no-lock no-error.
   *if avail ord-manut then do:
   *   find first ord-taref WHERE rowid(ord-taref) = g-ord-taref no-lock no-error.
   *   if avail ord-taref and ord-taref.encerrada = no then do:
   *      assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
   *             c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao. 
   *
   *   end.
   *   else do:
   *   end.
   ********* Fim do Comentario - 29/07/2003 ***************************************************/

            /*    
 *             find first ord-esp where
 *                                ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
 *                                ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial
 *                                no-lock no-error.
 * 
 *                     if  avail ord-esp then do:
 *                         find b-ord-taref where
 *                              b-ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and
 *                              b-ord-taref.cd-tarefa    = ord-esp.cd-tarefa 
 *                              no-lock no-error.
 *                         if  avail b-ord-taref then
 *                             assign c-cd-tarefa:screen-value in frame {&frame-name} = string(b-ord-taref.cd-tarefa)
 *                                    c-descricao:screen-value in frame {&frame-name} = b-ord-taref.descricao.
 *                         else 
 *                             assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
 *                                    c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.
 *                     end.           
 *                     else
 *                         assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
 *                                c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.
 *                 end.           
 *            /* end.*/
 *         end.
 *         else do:
 *             find ord-taref where
 *                  rowid(ord-taref) = g-ord-taref no-lock no-error.    
 *             find first ord-esp where
 *                        ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
 *                        ord-esp.cd-tarefa    = ord-taref.cd-tarefa    and
 *                        ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial 
 *                        no-lock no-error.
 *             if  avail ord-esp then
 *                 assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
 *                        c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.    */
            /*else do:
 *                  find first ord-esp where
 *                             ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
 *                             ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial 
 *                             no-lock no-error.
 *                  if  avail ord-esp then do:            
 *                      find b-ord-taref where
 *                           b-ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and
 *                           b-ord-taref.cd-tarefa    = ord-esp.cd-taref no-lock no-error.
 *                      if  avail b-ord-taref then
 *                          assign c-cd-tarefa:screen-value in frame {&frame-name} = string(b-ord-taref.cd-tarefa)
 *                                 c-descricao:screen-value in frame {&frame-name} = b-ord-taref.descricao.
 *                 end.
 *                 else do:
 *                     find ord-taref where
 *                          rowid(ord-taref) = g-ord-taref no-lock no-error.
 *                     assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
 *                            c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.     
 *                 end.
 *             end.*/

 /*       end.             */


        /*find ord-esp where
 *              ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
 *              ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial
 *              no-lock no-error.
 *         if  ambiguous ord-esp then do:     
 *             find ord-taref where
 *                  rowid(ord-taref) = g-ord-taref no-lock no-error.
 *             if  avail ord-taref then
 *                 assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
 *                        c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao. 
 *             else
 *                 assign c-cd-tarefa:screen-value in frame {&frame-name} = ""
 *                        c-descricao:screen-value in frame {&frame-name} = "".           
 *         end.
 *         else do:
 *             find first ord-esp where
 *                        ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
 *                        ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial no-lock no-error.
 *             if  avail ord-esp then do:
 *                 find ord-taref where
 *                      ord-taref.nr-ord-produ = ord-esp.nr-ord-produ and
 *                      ord-taref.cd-tarefa    = ord-esp.cd-tarefa no-lock no-error.
 *                 if  avail ord-taref then
 *                     assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)
 *                            c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.    
 *                 else           
 *                     assign c-cd-tarefa:screen-value in frame {&frame-name} = ""
 *                            c-descricao:screen-value in frame {&frame-name} = "".
 *             end.
 *         end.
     end.*/

     &if defined (bf_mnt_ems204) &then
         ASSIGN bt-verif-apont:SENSITIVE IN FRAME {&FRAME-NAME} = YES.       
         IF CAN-FIND(FIRST tecn-mi WHERE 
                           tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                           tecn-mi.log-1      = YES NO-LOCK) THEN DO:
              ASSIGN c-hra-norm:HIDDEN IN FRAME {&frame-name} = FALSE
                     c-hra-ext:HIDDEN IN FRAME {&frame-name}  = FALSE
                     c-hra-tot:HIDDEN IN FRAME {&frame-name}  = FALSE
                     c-hra-norm:screen-value IN FRAME {&frame-name} = "0000000"
                     c-hra-ext:screen-value IN FRAME {&frame-name}  = "0000000"
                     c-hra-tot:screen-value IN FRAME {&frame-name}  = "0000000"
                     c-hora-termino:HIDDEN IN FRAME {&frame-name}  = TRUE
                     c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = TRUE.
         END.
         ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                                tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                                tecn-mi.log-1      = NO NO-LOCK) THEN DO:
              ASSIGN c-hra-norm:HIDDEN IN FRAME {&frame-name} = TRUE
                     c-hra-ext:HIDDEN IN FRAME {&frame-name}  = TRUE
                     c-hra-tot:HIDDEN IN FRAME {&frame-name}  = TRUE
                     c-hora-termino:HIDDEN IN FRAME {&frame-name}  = FALSE
                     c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = FALSE.
         END.
    &else
         ASSIGN c-hra-norm:HIDDEN IN FRAME {&frame-name} = TRUE
                c-hra-ext:HIDDEN IN FRAME {&frame-name}  = TRUE
                c-hra-tot:HIDDEN IN FRAME {&frame-name}  = TRUE
                c-hora-termino:HIDDEN IN FRAME {&frame-name}  = FALSE
                c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = FALSE.
    &ENDif
    
    IF  iNrTarefaRecebida <> 0 THEN
        ASSIGN c-cd-tarefa:SCREEN-VALUE IN FRAME f-main = string(iNrTarefaRecebida).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-tecnico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-turno V-table-Win
ON ENTRY OF c-cd-turno IN FRAME f-main /* Turno */
DO:
    FIND FIRST turno-espec
         WHERE turno-espec.tp-especial = c-tp-especial:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
    IF  AVAIL turno-espec THEN DO:
        ASSIGN l-temTurnoEspec = YES.
        ASSIGN c-cd-turno:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cd-turno:HANDLE.
        IF  c-cd-turno:LOAD-MOUSE-POINTER ("image/rbm.cur") IN FRAME {&FRAME-NAME} THEN.
    END.
    ELSE DO:
        ASSIGN l-temTurnoEspec = NO.
        ASSIGN MENU-ITEM mi-zoom-turno-espec:SENSITIVE IN MENU POPUP-MENU-c-cd-turno = FALSE.
        IF  c-cd-turno:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&FRAME-NAME} THEN.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME c-cd-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-turno V-table-Win
ON F5 OF c-cd-turno IN FRAME f-main /* Turno */
DO:
    IF  l-implantado AND l-temTurnoEspec THEN DO:
       {method/zoomfields.i 
               &ProgramZoom="mnzoom~\z01mn031.w"
               &FieldZoom1="cd-turno"
               &FieldScreen1="c-cd-turno"
               &Frame1="f-main"
               &FieldZoom2="descricao"
               &FieldScreen2="c-descricao-turno"
               &Frame2="f-main"
               &EnableImplant="NO"
               &RunMethod="run setConstraintMiEspec in hProgramZoom (input input frame f-main c-tp-especial)."}
    END.
    ELSE DO:
        {method/zoomfields.i 
                &ProgramZoom="mnzoom~\z02mn015.w"
                &FieldZoom1="cd-turno"
                &FieldScreen1="c-cd-turno"
                &Frame1="f-main"
                &FieldZoom2="descricao"
                &FieldScreen2="c-descricao-turno"
                &Frame2="f-main"
                &EnableImplant="NO"}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-turno V-table-Win
ON LEAVE OF c-cd-turno IN FRAME f-main /* Turno */
DO:
  &if defined (bf_mnt_ems203) &then
    find mi-turno where
         mi-turno.cd-turno    = input frame {&frame-name} c-cd-turno no-lock no-error.
    if  avail mi-turno then 
        assign c-descricao-turno:screen-value in frame {&frame-name} = mi-turno.descricao.
    else
        assign c-descricao-turno:screen-value in frame {&frame-name} = "".
    run pi-calcula-conclusao.    
  &endif      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-turno IN FRAME f-main /* Turno */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hora-inicio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hora-inicio V-table-Win
ON LEAVE OF c-hora-inicio IN FRAME f-main /* Hora In¡cio */
DO:

  {cdp/cd9998.i}
  if  substring(input frame {&frame-name} c-hora-inicio,1,2) >= "24" then do:
      run utp/ut-msgs.p(input "show",
                        input 4786,
                        input "").
      apply 'entry' to c-hora-inicio in frame {&frame-name}.
      return no-apply.
  end.



   if  substring(input frame {&frame-name} c-hora-inicio,3,2) > "59" then do:
      run utp/ut-msgs.p(input "show",
                        input 4786,
                        input "").
      apply 'entry' to c-hora-inicio in frame {&frame-name}.
      return no-apply.
  end.




  /* Verifica se foi informada a hora em quartos: 0, 15, 30 ou 45 minutos */
 /* if lookup ((substring(input frame {&FRAME-NAME} c-hora-inicio,3,2)) ,"00,15,30,45") < 1 then do: 
 *      run utp/ut-msgs.p(input "show",
 *                         input 18297,
 *                         input "").
 *       apply 'entry' to c-hora-inicio in frame {&frame-name}.
 *       return no-apply.
 *   end.  */

&if defined (bf_mnt_ems203) &then 

  run pi-calcula-conclusao.

&endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hora-termino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hora-termino V-table-Win
ON LEAVE OF c-hora-termino IN FRAME f-main /* Hora T‚rmino */
DO:

  {cdp/cd9998.i}
  if  substring(input frame {&frame-name} c-hora-termino,1,2) >= "24" then do:
      run utp/ut-msgs.p(input "show",
                        input 4786,
                        input "").
      apply 'entry' to c-hora-termino in frame {&frame-name}.
      return no-apply.
  end.


   if  substring(input frame {&frame-name} c-hora-termino,3,2) > "59" then do:
      run utp/ut-msgs.p(input "show",
                        input 4786,
                        input "").
      apply 'entry' to c-hora-inicio in frame {&frame-name}.
      return no-apply.
  end.



  /* Verifica se foi informada a hora em quartos: 0, 15, 30 ou 45 minutos */
  /*if lookup ((substring(input frame {&FRAME-NAME} c-hora-termino,3,2)),"00,15,30,45") < 1 then do: 
 *      run utp/ut-msgs.p(input "show",
 *                         input 18297,
 *                         input "").
 *       apply 'entry' to c-hora-termino in frame {&frame-name}.
 *       return no-apply.
 *   end.*/

&if defined (bf_mnt_ems203) &then    
  run pi-calcula-conclusao.
&endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-ext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-ext V-table-Win
ON LEAVE OF c-hra-ext IN FRAME f-main /* Horas Extras */
DO:
  ASSIGN c-hra-tot:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = string(input frame {&FRAME-NAME} c-hra-norm + input frame {&FRAME-NAME} c-hra-ext).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-norm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-norm V-table-Win
ON LEAVE OF c-hra-norm IN FRAME f-main /* Horas Normais */
DO:
  ASSIGN c-hra-tot:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(input frame {&FRAME-NAME} c-hra-norm + input frame {&FRAME-NAME} c-hra-ext).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tempo-real
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tempo-real V-table-Win
ON LEAVE OF c-tempo-real IN FRAME f-main /* Tempo Real */
DO:
{cdp/cd9998.i}
  if  substring(input frame {&frame-name} c-tempo-real,3,2) > "59" then do:
      run utp/ut-msgs.p(input "show",
                        input 3046,
                        input return-value).
      apply 'entry' to c-tempo-real in frame {&frame-name}.
      return no-apply.
  end.
  if  substring(input frame {&frame-name} c-tempo-real,1,2) >= "24" then do:
      run utp/ut-msgs.p(input "show",
                        input 3046,
                        input return-value).
      apply 'entry' to c-tempo-real in frame {&frame-name}.
      return no-apply.
  end.
  assign input frame {&frame-name} c-tempo-real
         c-hora = substring(c-tempo-real,1,2)
         de-minuto = dec(substring(c-tempo-real,3,2)).

  assign de-minuto     = de-minuto * 60 / 100
         c-tempo       = c-hora + string(de-minuto)
         de-tempo      = (dec(substring(c-tempo-real,1,2)) * 60 + dec(substring(c-tempo-real,3,2))) / 60
         de-tempo-real = de-tempo.

    {cdp/cd9998.i1}
    if  avail ord-esp then do:
        if  c-opcao = "Estornar" then
            assign de-conclu = (ord-esp.conclusao - (de-tempo-real / ord-esp.tempo) * 100).
        else
            assign de-conclu = (ord-esp.conclusao + (de-tempo-real / ord-esp.tempo) * 100).
        if  de-conclu > 100 then 
            assign de-conclusao:screen-value in frame {&frame-name} = string(100).
        else
            if  de-conclu < 0 then
                assign de-conclusao:screen-value in frame {&frame-name} = string(0).
            else
                assign de-conclusao:screen-value in frame {&frame-name} = string(de-conclu).
    end.
    else
        assign de-conclusao:screen-value in frame {&frame-name} = "100".




  /*{cdp/cd9998.i}
 *   if  c-tempo-real:format in frame {&frame-name} = c-formato-1 then do:
 *       if  substring(input frame {&frame-name} c-tempo-real,3,2) > "59" then do:
 *            run utp/ut-msgs.p(input "show",
 *                              input 3046,
 *                              input return-value).
 *             apply 'entry' to c-tempo-real in frame {&frame-name}.
 *             return no-apply.
 *       end.
 *       if  substring(input frame {&frame-name} c-tempo-real,1,2) > "24" then do:
 *           run utp/ut-msgs.p(input "show",
 *                             input 3046,
 *                             input return-value).
 *           apply 'entry' to c-tempo-real in frame {&frame-name}.
 *           return no-apply.
 *       end.
 *   end.
 *   else do:
 *       if  substring(input frame {&frame-name} c-tempo-real,1,2) > "24" then do:
 *           run utp/ut-msgs.p(input "show",
 *                             input 15908,
 *                             input return-value).
 *           apply 'entry' to c-tempo-real in frame {&frame-name}.
 *           return no-apply.
 *       end.
 *   end.
 *       
 *     if  c-tempo-real:format in frame {&frame-name} = c-formato-1 then do:
 *         assign input frame {&frame-name} c-tempo-real
 *                c-hora = substring(c-tempo-real,1,2)
 *                de-minuto = dec(substring(c-tempo-real,3,2)).
 *                
 *         assign de-minuto     = de-minuto * 100 / 60
 *                c-tempo       = c-hora + string(de-minuto)
 *                de-tempo      = (dec(substring(c-tempo-real,1,2)) * 60 + dec(substring(c-tempo-real,3,4))) / 60
 *                de-tempo-real = de-tempo.
 *     end.
 *     else do:
 *            assign input frame {&frame-name} c-tempo-real
 *                c-hora = substring(c-tempo-real,1,2)
 *                de-minuto = dec(substring(c-tempo-real,3,4)).
 * 
 *            assign de-tempo-real = dec(c-tempo-real) / 10000
 *                de-minuto     = de-minuto * 100 / 60
 *                c-tempo       = c-hora + string(de-minuto)
 *                de-tempo      = (dec(substring(c-tempo-real,1,2)) + dec(substring(c-tempo-real,3,4)) / 100).
 *     end.
 *     {cdp/cd9998.i1}
 * 
 *     if  avail ord-esp then do:
 *         if  c-opcao = "Estornar" then
 *             assign de-conclu = (ord-esp.conclusao - (de-tempo-real / ord-esp.tempo) * 100).
 *         else
 *             assign de-conclu = (ord-esp.conclusao + (de-tempo-real / ord-esp.tempo) * 100).
 *         if  de-conclu > 100 then 
 *             assign de-conclusao:screen-value in frame {&frame-name} = string(100).
 *         else
 *             if  de-conclu < 0 then
 *                 assign de-conclusao:screen-value in frame {&frame-name} = string(0).
 *             else
 *                 assign de-conclusao:screen-value in frame {&frame-name} = string(de-conclu).
 *     end.
 *     else
 *         assign de-conclusao:screen-value in frame {&frame-name} = "100".*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tempo-real1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tempo-real1 V-table-Win
ON LEAVE OF c-tempo-real1 IN FRAME f-main /* Tempo Real */
DO:
  {cdp/cd9998.i}
  if  substring(input frame {&frame-name} c-tempo-real1,1,2) >= "24" then do:
          run utp/ut-msgs.p(input "show",
                            input 15908,
                            input return-value).
          apply 'entry' to c-tempo-real1 in frame {&frame-name}.
          return no-apply.
  end.


    if  substring(input frame {&frame-name} c-tempo-real1,3,2) > "59" then do:
      run utp/ut-msgs.p(input "show",
                        input 3046,
                        input return-value).
      apply 'entry' to c-tempo-real1 in frame {&frame-name}.
      return no-apply.
  end.
  assign de-tempo-real = input frame {&frame-name} c-tempo-real1.
      if  avail ord-esp then do:
          if  c-opcao = "Estornar" then
              assign de-conclu = (ord-esp.conclusao - (de-tempo-real / ord-esp.tempo) * 100).
          else
              assign de-conclu = (ord-esp.conclusao + (de-tempo-real / ord-esp.tempo) * 100).
          if  de-conclu > 100 then 
              assign de-conclusao:screen-value in frame {&frame-name} = string(100).
          else
              if  de-conclu < 0 then
                  assign de-conclusao:screen-value in frame {&frame-name} = string(0).
              else
                  assign de-conclusao:screen-value in frame {&frame-name} = string(de-conclu).
      end.
      else
          assign de-conclusao:screen-value in frame {&frame-name} = "100".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tp-especial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-especial V-table-Win
ON F5 OF c-tp-especial IN FRAME f-main /* Especialidade */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="inzoom/z01in209.w"
                     &campo=c-tp-especial
                     &campozoom=tp-especial
                     &campo2=c-desc-especial
                     &campozoom2=descricao}

 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mi-zoom-espec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-zoom-espec V-table-Win
ON CHOOSE OF MENU-ITEM mi-zoom-espec /* Pesquisa Especialidade */
DO:
   apply "F5" to c-tp-especial in frame f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-especial V-table-Win
ON F7 OF c-tp-especial IN FRAME f-main /* Especialidade */
DO:
  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="inzoom/z01in267.w"
                     &campo=c-tp-especial
                     &campozoom=tp-especial}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mi-zoom-espec-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-zoom-espec-ordem V-table-Win
ON CHOOSE OF MENU-ITEM mi-zoom-espec-ordem /* Pesquisa Especialidade Ordem Manuten‡Æo */
DO:
   apply "F7" to c-tp-especial in frame f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-especial V-table-Win
ON F8 OF c-tp-especial IN FRAME f-main /* Especialidade */
DO:
  FIND FIRST tecn-mi WHERE tecn-mi.cd-tecnico = INPUT FRAME {&FRAME-NAME} c-cd-tecnico
       NO-LOCK NO-ERROR.
  IF AVAIL tecn-mi THEN
     ASSIGN gr-tecn-mi = ROWID(tecn-mi).
  ELSE
     ASSIGN gr-tecn-mi = ?.

  assign l-implanta = no.
  {include/zoomvar.i &prog-zoom="inzoom/z03in428.w"
                     &campo=c-tp-especial
                     &campozoom=tp-especial}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME mi-zoom-espec-tecnico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-zoom-espec-tecnico V-table-Win
ON CHOOSE OF MENU-ITEM mi-zoom-espec-tecnico /* Pesquisa Especialidade T‚cnico */
DO:
   apply "F8" to c-tp-especial in frame f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-especial V-table-Win
ON LEAVE OF c-tp-especial IN FRAME f-main /* Especialidade */
DO:
    IF  c-tp-especial:screen-value in frame {&frame-name} <> "" then do:
        find mi-espec where mi-espec.tp-especial = input frame {&frame-name} c-tp-especial 
             no-lock no-error.
        if  avail mi-espec then
            assign c-desc-especial:screen-value in frame {&frame-name} = mi-espec.descricao.
        else                
            assign c-desc-especial:screen-value in frame {&frame-name} = "".

   /****** Comentado em 29/07/2003 por Rafael Rosario - Novo tratamento de leave dos campos                  ******  
    ****** para adequa‡Æo solicitada pelo PQU - FO 887755 e 887743                                           ******/

/*         find ord-manut WHERE rowid(ord-manut) = gr-ord-manut no-lock no-error.                                  */
/*         find first ord-esp where                                                                                */
/*              ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and                                                  */
/*              ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial no-lock no-error.                   */
/*         if  avail ord-esp then do:                                                                              */
/*             find ord-taref WHERE rowid(ord-taref) = g-ord-taref no-lock no-error.                               */
/*             if avail ord-taref then do:                                                                         */
/*                 if avail ord-esp then do:                                                                       */
/*                    assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)         */
/*                           c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.                */
/*                 end.                                                                                            */
/*                 else do:                                                                                        */
/*                     find first ord-esp where                                                                    */
/*                                ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and                                */
/*                                ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial                   */
/*                                no-lock no-error.                                                                */
/*                            assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa) */
/*                                   c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.        */
/*                 end.                                                                                            */
/*             end.                                                                                                */
/*         end.                                                                                                    */
/*         else do:                                                                                                */
/*             find ord-taref WHERE rowid(ord-taref) = g-ord-taref no-lock no-error.                               */
/*             find first ord-esp where                                                                            */
/*                        ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and                                        */
/*                        ord-esp.cd-tarefa    = ord-taref.cd-tarefa    and                                        */
/*                        ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial                           */
/*                        no-lock no-error.                                                                        */
/*             if  avail ord-esp then do:                                                                          */
/*                 assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)            */
/*                        c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.                   */
/*             end.                                                                                                */
/*             else do:                                                                                            */
/*                  find first ord-esp where                                                                       */
/*                             ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and                                   */
/*                             ord-esp.tp-especial  = input frame {&frame-name} c-tp-especial                      */
/*                             no-lock no-error.                                                                   */
/*                  if  avail ord-esp then do:                                                                     */
/*                      find b-ord-taref where                                                                     */
/*                           b-ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and                                 */
/*                           b-ord-taref.cd-tarefa    = ord-esp.cd-taref no-lock no-error.                         */
/*                      if  avail b-ord-taref then do:                                                             */
/*                          assign c-cd-tarefa:screen-value in frame {&frame-name} = string(b-ord-taref.cd-tarefa) */
/*                                 c-descricao:screen-value in frame {&frame-name} = b-ord-taref.descricao.        */
/*                      end.                                                                                       */
/*                 end.                                                                                            */
/*                 else do:                                                                                        */
/*                     find ord-taref where                                                                        */
/*                          rowid(ord-taref) = g-ord-taref no-lock no-error.                                       */
/*                     assign c-cd-tarefa:screen-value in frame {&frame-name} = string(ord-taref.cd-tarefa)        */
/*                            c-descricao:screen-value in frame {&frame-name} = ord-taref.descricao.               */
/*                end.                                                                                             */
/*             end.                                                                                                */
/*         end.                                                                                                    */
/*************** FIM COMENTARIO 29/07/2003                                                           ***************/ 
    end.
    else
        assign c-desc-especial:screen-value in frame {&frame-name} = "".

    /* Posicionar ord-esp para uso de outros leaves e procedures que calculam
       os percentuais de conclusÆo */
    FIND FIRST ord-esp WHERE ord-esp.nr-ord-produ = ord-manut.nr-ord-produ 
                         AND ord-esp.cd-tarefa    = INPUT FRAME {&FRAME-NAME} c-cd-tarefa
                         AND ord-esp.tp-especial  = INPUT FRAME {&FRAME-NAME} c-tp-especial NO-LOCK NO-ERROR.


    &if defined (bf_mnt_ems203) &then
       if c-tp-especial:modified in frame {&FRAME-NAME} then
          RUN pi-verifica-turno. 
       assign c-tp-especial:modified in frame {&FRAME-NAME} = no.
    &endif         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-especial V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-tp-especial IN FRAME f-main /* Especialidade */
DO:
  apply 'F5' to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-relogio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-relogio V-table-Win
ON VALUE-CHANGED OF cb-tp-relogio IN FRAME f-main
DO:
   if  input frame {&frame-name} cb-tp-relogio = "Hor rio" then do:
          assign c-tempo-real:hidden  = no
                 c-tempo-real1:hidden = yes
                 c-tempo-real:sensitive = yes
                 c-tempo-real:format in frame {&frame-name} = c-formato-1
                 c-tempo-real:screen-value in frame {&frame-name} = "0000".

 end. 
 else do:
          assign c-tempo-real1:hidden = no
                 c-tempo-real:hidden  = yes
                 c-tempo-real1:sensitive = yes
                 c-tempo-real1:screen-value in frame {&frame-name} = "0".
  end.


  /*assign c-combo = input frame {&frame-name} cb-tp-relogio.
 *   
 *     if  input frame {&frame-name} cb-tp-relogio = "Hor rio" then
 *         assign c-tempo-real:format in frame {&frame-name} = c-formato-1 no-error.
 *     else
 *         assign c-tempo-real:format in frame {&frame-name} = c-formato-2 no-error.
 * 
 *     if  c-combo <> input frame {&frame-name} cb-tp-relogio then do:
 *         assign input frame {&frame-name} c-tempo-real
 *                c-hora = substring(c-tempo-real,1,2)
 *                de-minuto = dec(substring(c-tempo-real,3,4)).
 * 
 *         if  c-combo = "Hor rio" then
 *             assign de-minuto     = de-minuto * 100 / 60
 *                    de-tempo      = dec(c-hora) + (de-minuto / 100)
 *                    de-tempo-real = de-tempo.
 *         else
 *             assign de-tempo-real = dec(c-tempo-real) / 10000
 *                    de-minuto     = de-minuto * 60 / 100
 *                    de-tempo      = dec(c-hora) + (de-minuto / 100).
 *         {cdp/cd9998.i}
 * 
 *         assign i-valor  = truncate(de-tempo,0)
 *                de-valor = (de-tempo - i-valor) * 100.
 *                c-tempo = string(i-valor,"99") + string(de-valor,"99").
 *         disp c-tempo @ c-tempo-real with frame {&frame-name}.
 *         assign c-combo = input frame {&frame-name} cb-tp-relogio.
 *     end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-reporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-reporte V-table-Win
ON LEAVE OF da-reporte IN FRAME f-main /* Data Transa‡Æo */
DO:
   assign g-da-reporte = input frame {&frame-name} da-reporte
          da-reporte   = g-da-reporte.
   disp da-reporte with frame {&frame-name}.           

   &if defined (bf_mnt_ems203) &then
      if da-reporte:modified in frame {&FRAME-NAME} then
         RUN pi-verifica-turno. 
      assign da-reporte:modified in frame {&FRAME-NAME} = no.   
   &endif 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-conclusao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-conclusao V-table-Win
ON ENTRY OF de-conclusao IN FRAME f-main /* Percentual ConclusÆo */
DO:
    if  avail ord-esp then do:

        &if defined (bf_mnt_ems203) &then  

        if  c-opcao = "Estornar" then
            assign de-conclu = if  ord-esp.tipo-tempo = 1 then
                                   (ord-esp.conclusao - (de-tempo-real / (ord-esp.tempo * ord-esp.nr-homens)) * 100)
                               else
                                   (ord-esp.conclusao - (de-tempo-real / (ord-esp.tempo / ord-esp.nr-homens)) * 100).
        else
            assign de-conclu = if  ord-esp.tipo-tempo = 1 then
                                   (ord-esp.conclusao + (de-tempo-real / (ord-esp.tempo * ord-esp.nr-homens)) * 100)
                               else
                                   (ord-esp.conclusao + (de-tempo-real / (ord-esp.tempo / ord-esp.nr-homens)) * 100).
        &else

        if  c-opcao = "Estornar" then
            assign de-conclu = (ord-esp.conclusao - (de-tempo-real / ord-esp.tempo) * 100).
        else
            assign de-conclu = (ord-esp.conclusao + (de-tempo-real / ord-esp.tempo) * 100).
        if  de-conclu > 100 then
            if  input frame {&frame-name} de-conclusao < 100 then
                assign de-conclusao = input frame {&frame-name} de-conclusao.
            else   
                assign de-conclusao:screen-value in frame {&frame-name} = string(100).
        &endif
        if  de-conclu > 100 then
            if  input frame {&frame-name} de-conclusao < 100 then
                assign de-conclusao = input frame {&frame-name} de-conclusao.
            else   
                assign de-conclusao:screen-value in frame {&frame-name} = string(100).
        else
        if  de-conclu < 0 then
            assign de-conclusao:screen-value in frame {&frame-name} = string(0).
        else
            assign de-conclusao:screen-value in frame {&frame-name} = string(de-conclu).
    end.
    else
        assign de-conclusao = input frame {&frame-name} de-conclusao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-encerrada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-encerrada V-table-Win
ON VALUE-CHANGED OF l-encerrada IN FRAME f-main /* Encerrada */
DO:
    if  input frame {&frame-name} l-encerrada = no then
        enable de-conclusao with frame {&frame-name}.
    else do:
        disable de-conclusao with frame {&frame-name}.
        assign de-conclusao = 100.
        disp de-conclusao with frame {&frame-name}.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-intervalo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-intervalo V-table-Win
ON VALUE-CHANGED OF l-intervalo IN FRAME f-main /* Aponta durante intervalo? */
DO:
    run pi-calcula-conclusao.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-zoom-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-zoom-turno V-table-Win
ON CHOOSE OF MENU-ITEM mi-zoom-turno /* Pesquisa Turnos */
DO:
  &if defined (bf_mnt_ems203) &then
   {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z02mn015.w"
           &FieldZoom1="cd-turno"
           &FieldScreen1="c-cd-turno"
           &Frame1="f-main"
           &FieldZoom2="descricao"
           &FieldScreen2="c-descricao-turno"
           &Frame2="f-main"
           &EnableImplant="NO"}
  &endif    

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-zoom-turno-espec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-zoom-turno-espec V-table-Win
ON CHOOSE OF MENU-ITEM mi-zoom-turno-espec /* Pesquisa Turnos da Especialidade */
DO:
   apply "F5" to c-cd-turno in frame f-main.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
assign c-tempo-real:screen-value  in frame {&frame-name}  = "0000"
       c-tempo-real1:screen-value in frame {&frame-name}  = "000000".

if c-cd-tecnico:load-mouse-pointer ("Image~\lupa.cur") in frame {&FRAME-NAME} then.
if c-cd-ccusto:load-mouse-pointer ("Image~\lupa.cur") in frame {&FRAME-NAME} then.
if c-tp-especial:load-mouse-pointer ("Image~\rbm.cur") in frame {&FRAME-NAME} then.
if c-cd-tarefa:load-mouse-pointer ("Image~\lupa.cur") in frame {&FRAME-NAME} then.
if c-cd-turno:load-mouse-pointer ("image/rbm.cur") in frame {&FRAME-NAME} then.
{cdp/cdcfgmnt.i}

{utp/ut-liter.i Tipo_de_Rel¢gio * r} 
assign cb-tp-relogio:label in frame {&frame-name} = trim(return-value).

&if defined (bf_mnt_ems203)  &then
  {utp/ut-field.i mgind ord-mob hora-inicio 1} 
   assign c-hora-inicio:label in frame {&frame-name} = trim(return-value).

  {utp/ut-field.i mgind ord-mob hora-termino 1} 
   assign c-hora-termino:label in frame {&frame-name} = trim(return-value).
&endif   

find first param-mi no-lock no-error.
find mi-espec where 
     rowid(mi-espec) = gr-mi-espec  no-lock no-error.
find ord-taref where 
     rowid(ord-taref) = g-ord-taref no-lock no-error.

/* ASSIGN c-hist-apont:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-taref.narrativa. */

&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF      

ASSIGN i-cont-narrativa = LENGTH(ord-taref.narrativa).

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
  {src/adm/template/row-list.i "mi-espec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mi-espec"}

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
  /* N’o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

 /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

    &if defined (bf_mnt_ems204) &then
         ASSIGN c-hra-norm:SENSITIVE IN FRAME {&frame-name} = YES
                c-hra-ext:SENSITIVE  IN FRAME {&frame-name}  = YES
                c-hra-tot:SENSITIVE  IN FRAME {&frame-name}  = YES.
    &ENDif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
assign c-tempo-real:screen-value  in frame {&frame-name}  = "0000"
       c-tempo-real1:screen-value in frame {&frame-name}  = "000000".

     /* Code placed here will execute PRIOR to standard behavior. */

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE c-lista1 AS CHARACTER  NO-UNDO.
       DEFINE VARIABLE c-lista2 AS CHARACTER  NO-UNDO.
       assign c-lista1 = {ininc/i01in289.i 04 1}.
           run utp/ut-lstit.p (input-output c-lista1).
       assign c-lista2 = {ininc/i01in289.i 04 3}.
           run utp/ut-lstit.p (input-output c-lista2).
       assign cb-tp-relogio:list-item-pairs in frame {&frame-name} = c-lista1 + "," + c-lista2.
   &else
       cb-tp-relogio:add-last({ininc/i01in289.i 04 1}) in frame {&frame-name}.
       cb-tp-relogio:add-last({ininc/i01in289.i 04 3}) in frame {&frame-name}.
   &endif


    if c-opcao = "Reportar" then do:

        if  avail param-mi 
        and param-mi.tp-relogio = 1 then
            assign c-tempo-real:screen-value in frame {&frame-name}  = "0000".

        if  avail param-mi 
        and param-mi.tp-relogio = 3 then
            assign c-tempo-real1:screen-value in frame {&frame-name}  = "000000".

    assign cb-tp-relogio:screen-value in frame {&frame-name} = {ininc/i01in289.i 04 param-mi.tp-relogio}
    .
    &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
        DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
        ASSIGN cAuxTraducao001 = {ininc/i01in289.i 04 param-mi.tp-relogio}.
        run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                            INPUT "",
                            INPUT "").
        ASSIGN c-combo                                           = RETURN-VALUE.
    &else
        ASSIGN c-combo                                           = {ininc/i01in289.i 04 param-mi.tp-relogio}.
    &endif

        assign da-reporte:screen-value in frame {&frame-name} = string(today).
        &if defined (bf_mnt_ems203)  &then
             assign c-hora-inicio:hidden  in frame {&FRAME-NAME} = no
                    c-hora-termino:hidden in frame {&FRAME-NAME} = no
                    l-intervalo:hidden    in frame {&FRAME-NAME} = no 
                    c-cd-turno:hidden     in frame {&FRAME-NAME} = no
                    c-descricao-turno:hidden in frame {&FRAME-NAME} = no
                    bt-verif-apont:SENSITIVE    in frame {&FRAME-NAME} = YES.
             disp   c-hora-inicio c-hora-termino 
                    l-intervalo   c-cd-turno c-descricao-turno with frame {&FRAME-NAME}.    
         &if defined (bf_mnt_ems204)  &then 
            IF param-mi.tp-turno = 1 THEN
               ASSIGN c-cd-turno:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(param-mi.cd-turno).
         &endif
         &else
            assign cb-tp-relogio:hidden in frame {&FRAME-NAME} = no.

             if  param-mi.tp-relogio = 1 then do:
                 assign c-tempo-real1:hidden = yes
                        c-tempo-real1:sensitive = yes
                        c-tempo-real1:sensitive = no
                        c-tempo-real:hidden  = no
                        c-tempo-real:format in frame {&frame-name} = c-formato-1.
             end. 
             else do:
                 assign c-tempo-real1:hidden = no
                        c-tempo-real:hidden  = yes
                        c-tempo-real1:sensitive = yes.
             end.
         &endif

     end.
    if c-opcao = "Estornar" then do:
       &if defined (bf_mnt_ems203)  &then
          assign c-hora-inicio:hidden  in frame {&FRAME-NAME} = no
                 c-hora-termino:hidden in frame {&FRAME-NAME} = no
                 l-intervalo:hidden    in frame {&FRAME-NAME} = no 
                 c-cd-turno:hidden     in frame {&FRAME-NAME} = no
                 c-descricao-turno:hidden in frame {&FRAME-NAME} = no
                 bt-verif-apont:SENSITIVE in frame {&FRAME-NAME} = YES.


          assign c-hora-inicio:sensitive in frame {&FRAME-NAME} = yes
                 c-hora-termino:sensitive in frame {&FRAME-NAME} = yes.

          disp   c-hora-inicio c-hora-termino 
                 l-intervalo   c-cd-turno c-descricao-turno with frame {&FRAME-NAME}.    



       &else
         assign cb-tp-relogio:screen-value in frame {&frame-name} = {ininc/i01in289.i 04 3}
         .
         &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
             DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
             ASSIGN cAuxTraducao002 = {ininc/i01in289.i 04 3}.
             run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                 INPUT "",
                                 INPUT "").
             ASSIGN c-combo                                           = RETURN-VALUE.
         &else
             ASSIGN c-combo                                           = {ininc/i01in289.i 04 3}.
         &endif
         assign c-tempo-real1:screen-value in frame {&frame-name}  = "000000".

         assign da-reporte:screen-value in frame {&frame-name} = string(today).

         assign cb-tp-relogio:hidden in frame {&FRAME-NAME} = no.
         assign c-tempo-real:hidden  = yes
                c-tempo-real1:hidden = no
                c-tempo-real1:sensitive = yes.

       &endif.

       if c-opcao <> "ESTORNAR":U then
           RUN pi-verifica-turno.
    end.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    if c-opcao = "Estornar" then do:
        disable cb-tp-relogio with frame {&frame-name}.
        assign cb-tp-relogio:sensitive in frame {&FRAME-NAME} = no.
    end.
    /* Code placed here will execute AFTER standard behavior.    */

    &if defined (bf_mnt_ems204) &then

         IF trim(string(c-cd-tecnico:screen-value in frame {&frame-name})) = "-" THEN DO:
             ASSIGN c-hra-norm:HIDDEN IN FRAME {&frame-name} = TRUE
                    c-hra-ext:HIDDEN IN FRAME {&frame-name}  = TRUE
                    c-hra-tot:HIDDEN IN FRAME {&frame-name}  = TRUE
                    c-hora-termino:HIDDEN IN FRAME {&frame-name}  = TRUE
                    c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = TRUE
                    bt-verif-apont:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

         END.


    &else
         ASSIGN c-hra-norm:HIDDEN IN FRAME {&frame-name} = TRUE
                c-hra-ext:HIDDEN IN FRAME {&frame-name}  = TRUE
                c-hra-tot:HIDDEN IN FRAME {&frame-name}  = TRUE
                c-hora-termino:HIDDEN IN FRAME {&frame-name}  = FALSE
                c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = FALSE.
    &ENDif

   APPLY "value-changed":U TO c-observacao IN frame {&FRAME-NAME} .
   
   FIND FIRST param-global NO-LOCK NO-ERROR.
       ASSIGN l-implantado = param-global.modulo-po.

    IF l-implantado = NO THEN DO:
      if c-cd-turno:load-mouse-pointer ("image/lupa.cur") in frame {&FRAME-NAME} then.
          ASSIGN  MENU-ITEM mi-zoom-turno-espec:SENSITIVE IN MENU POPUP-MENU-c-cd-turno = FALSE.
   
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estorno V-table-Win 
PROCEDURE pi-atualiza-estorno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter raw-tt-mdobra as raw no-undo.

for each tt-mao-de-obra:
    delete tt-mao-de-obra.
end.

create tt-mao-de-obra.
raw-transfer raw-tt-mdobra to tt-mao-de-obra.

find first tt-mao-de-obra NO-ERROR.


      IF CAN-FIND(FIRST tecn-mi WHERE 
                        tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                        tecn-mi.log-1      = NO NO-LOCK) THEN DO:
           ASSIGN   c-hra-norm:HIDDEN IN FRAME {&frame-name}     = TRUE
                    c-hra-ext:HIDDEN IN FRAME {&frame-name}      = TRUE
                    c-hra-tot:HIDDEN IN FRAME {&frame-name}      = TRUE
                    c-hora-termino:HIDDEN IN FRAME {&frame-name} = FALSE
                    c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = FALSE.

      END.
      ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                             tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                             tecn-mi.log-1      = YES NO-LOCK) THEN DO: 
          ASSIGN   c-hra-norm:HIDDEN IN FRAME {&frame-name}      = FALSE
                   c-hra-ext:HIDDEN IN FRAME {&frame-name}       = FALSE
                   c-hra-tot:HIDDEN IN FRAME {&frame-name}       = FALSE
                   c-hora-termino:HIDDEN IN FRAME {&FRAME-NAME}  = TRUE
                   c-hora-inicio:HIDDEN IN FRAME {&frame-name}   = TRUE.
      END.




find centro-custo where centro-custo.cc-codigo = tt-mao-de-obra.cc-codigo 
     no-lock no-error.
assign c-cd-tecnico    = tt-mao-de-obra.cd-tecnico
       c-nome-compl    = tt-mao-de-obra.nome-compl
       c-tp-especial   = tt-mao-de-obra.tp-especial
       c-cd-tarefa     = tt-mao-de-obra.cd-tarefa
       c-cd-ccusto     = tt-mao-de-obra.cc-codigo
       c-desc-ccusto   = centro-custo.descricao
       de-tempo-real   = 0
       c-tempo-real1    = 0000
       da-reporte      = tt-mao-de-obra.dt-trans
       &if defined (bf_mnt_ems203) &then
          c-hora-inicio  = substr(tt-mao-de-obra.hora-inicio,1,2)  + substr(tt-mao-de-obra.hora-inicio,4,2)
          c-hora-termino = substr(tt-mao-de-obra.hora-termino,1,2) + substr(tt-mao-de-obra.hora-termino,4,2)
          i-nr-reporte   = tt-mao-de-obra.nr-reporte
       &endif
       .

       &if defined (bf_mnt_ems204) &then
         IF CAN-FIND(FIRST tecn-mi WHERE 
                           tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                           tecn-mi.log-1      = YES NO-LOCK) THEN DO:

           FIND FIRST ord-mob WHERE 
                      ord-mob.nr-ord-produ =  tt-mao-de-obra.nr-ord-produ AND
                      ord-mob.cd-tarefa    =  tt-mao-de-obra.cd-tarefa    AND
                      ord-mob.dt-trans     =  tt-mao-de-obra.dt-trans     and
                      ord-mob.cd-tecnico   =  tt-mao-de-obra.cd-tecnico   AND
                      ord-mob.horas-report =  tt-mao-de-obra.horas-report AND
                      ord-mob.tipo-trans   =  tt-mao-de-obra.tipo-trans     NO-LOCK NO-ERROR.
           IF AVAIL ord-mob THEN DO:
              ASSIGN c-hra-norm = ord-mob.hora-norm
                     c-hra-ext  = ord-mob.hora-extra
                     c-hra-tot  = ord-mob.horas-report
                     c-hra-norm:SENSITIVE IN FRAME {&frame-name}   = NO
                     c-hra-ext:SENSITIVE IN FRAME {&frame-name}    = NO
                     c-hra-tot:SENSITIVE IN FRAME {&frame-name}    = NO.
           END.
       END.
       &endif

find mi-espec  where 
     mi-espec.tp-especial = c-tp-especial no-lock no-error.
find ord-manut where
     rowid(ord-manut) = gr-ord-manut no-lock no-error.
find ord-taref where 
     ord-taref.nr-ord-produ = ord-manut.nr-ord-produ and
     ord-taref.cd-tarefa    = c-cd-tarefa  NO-LOCK no-error.
assign c-desc-especial = mi-espec.descricao when avail mi-espec
       c-descricao = ord-taref.descricao when avail ord-taref.       
find ord-esp where
     ord-esp.nr-ord-produ  = ord-manut.nr-ord-produ and
     ord-esp.cd-tarefa     = ord-taref.cd-tarefa    and
     ord-esp.tp-especial   = c-tp-especial no-lock no-error.

if  avail ord-esp then do:
    assign l-encerrada   = ord-esp.encerrada
           de-conclusao  = ord-esp.conclusao.
    IF  de-conclusao < 0 THEN
        ASSIGN de-conclusao = 0.
    disp l-encerrada de-conclusao with frame {&frame-name}.           
    if  l-encerrada = yes then
        disable de-conclusao with frame {&frame-name}.
    else
        enable de-conclusao with frame {&frame-name}.     
end.    
IF CAN-FIND(FIRST tecn-mi WHERE 
                  tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                  tecn-mi.log-1      = NO NO-LOCK) THEN DO:
disp c-cd-tecnico
     c-nome-compl
     c-tp-especial
     c-desc-especial
     c-cd-tarefa
     c-descricao
     c-cd-ccusto  
     c-desc-ccusto
     da-reporte 
     &if defined (bf_mnt_ems203) &then
        c-hora-inicio 
        c-hora-termino
     &else
        c-tempo-real1       
     &endif   
     with frame {&frame-name}.    
END.
ELSE  IF CAN-FIND(FIRST tecn-mi WHERE 
                        tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                        tecn-mi.log-1      = YES NO-LOCK) THEN DO:
    disp c-cd-tecnico
     c-nome-compl
     c-tp-especial
     c-desc-especial
     c-cd-tarefa
     c-descricao
     c-cd-ccusto  
     c-desc-ccusto
     da-reporte 
     &if defined (bf_mnt_ems204) &then
        c-hra-norm
        c-hra-ext
        c-hra-tot
     &else
        c-tempo-real1       
     &endif   
     with frame {&frame-name}.    

END.
disable c-cd-tecnico
        c-cd-ccusto
        c-cd-tarefa
        c-tp-especial
        da-reporte
        &if defined (bf_mnt_ems203) &then
           l-intervalo 
           c-cd-turno
           c-hora-inicio
           c-hora-termino
           bt-verif-apont
        &endif   
        with frame {&frame-name}.

assign g-da-reporte = input frame {&frame-name} da-reporte.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-variaveis V-table-Win 
PROCEDURE pi-atualiza-variaveis :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter raw-tt-espec   as raw  no-undo.

   for each tt-esp:
       delete tt-esp.
   end.    
   create tt-esp.
   raw-transfer raw-tt-espec to tt-esp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-valores V-table-Win 
PROCEDURE pi-busca-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define output parameter cd-par-tecnico    like ord-taref.cd-tecnico     no-undo.
    define output parameter cd-par-ccusto     like centro-custo.cc-codigo   no-undo.
    define output parameter de-tempo-real     as decimal format "->>>>9,9999" no-undo.  
    define output parameter l-par-encerrada   as logical                    no-undo.
    define output parameter de-par-conclusao  as decimal format "->>>>9,99" no-undo.
    define output parameter c-tipo-especial   like mi-espec.tp-especial     no-undo.
    define output parameter c-cod-taref       like ord-taref.cd-tarefa      no-undo.
    define output parameter i-cd-turno        AS INTEGER                    no-undo.
    DEFINE OUTPUT PARAMETER p-c-hist-apont    AS CHAR                       NO-UNDO.
    &if defined (bf_mnt_ems203) &then
       define output parameter i-num-reporte  like ord-mob.nr-reporte       no-undo.
       define output param table for tt-apont. 
    &endif

    &if defined (bf_mnt_ems203) &then
       IF CAN-FIND(FIRST tecn-mi WHERE 
                         tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                         tecn-mi.log-1      = NO NO-LOCK) THEN DO:
           if input frame {&FRAME-NAME} c-hora-inicio >= input frame {&FRAME-NAME} c-hora-termino then do:
               run utp/ut-msgs.p(input "show",
                                 input 5820,
                                 input c-hora-inicio:label in frame {&FRAME-NAME} + "~~" + 
                                       c-hora-termino:label in frame {&FRAME-NAME}).
               apply 'entry' to c-hora-inicio in frame {&frame-name}.
               return "nok".
           end.
       END.
       RUN pi-cria-apontamentos.    
       if return-value = "error":U then
          return "nok":U. 

       assign de-tempo-real = 0. 
       for each tt-apont:
          assign de-tempo-real = de-tempo-real + 
                                 tt-apont.hora-normal + tt-apont.hora-extra.
          IF tt-apont.hora-normal + tt-apont.hora-extra <= 0 THEN DELETE tt-apont.
       end.             
       assign i-num-reporte = i-nr-reporte.
    &else
       if  input frame {&frame-name} cb-tp-relogio = "Hor rio" then
           assign de-tempo-real = (dec(substring(c-tempo-real,1,2)) * 60 + dec(substring(c-tempo-real,3,2))) / 60.
       else
           assign de-tempo-real = input frame {&frame-name} c-tempo-real1.
    &endif       


    assign cd-par-tecnico    = input frame {&frame-name} c-cd-tecnico
           cd-par-ccusto     = input frame {&frame-name} c-cd-ccusto
           l-par-encerrada   = input frame {&frame-name} l-encerrada
           de-par-conclusao  = input frame {&frame-name} de-conclusao
           c-tipo-especial   = input frame {&frame-name} c-tp-especial
           c-cod-taref       = input frame {&frame-name} c-cd-tarefa
           g-da-reporte      = input frame {&frame-name} da-reporte
           i-cd-turno        = input frame {&frame-name} c-cd-turno.

IF INPUT FRAME {&FRAME-NAME} c-hist-apont = "" THEN DO:
    IF INPUT FRAME {&FRAME-NAME} c-observacao <> "" THEN
        ASSIGN p-c-hist-apont = INPUT FRAME {&FRAME-NAME} c-observacao.
END.
ELSE DO:
    IF INPUT FRAME {&FRAME-NAME} c-observacao = "" THEN
         ASSIGN p-c-hist-apont = INPUT FRAME {&FRAME-NAME} c-hist-apont.
    ELSE
        ASSIGN p-c-hist-apont = INPUT FRAME {&FRAME-NAME} c-hist-apont + "~r~n" + 
                                INPUT FRAME {&FRAME-NAME} c-observacao.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula-conclusao V-table-Win 
PROCEDURE pi-calcula-conclusao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mnt_ems203) &then  
  if  avail ord-esp then do:
      run pi-cria-apontamentos.
      assign de-tempo-real = 0.
      for each tt-apont:
           assign de-tempo-real = de-tempo-real + tt-apont.hora-normal + tt-apont.hora-extra.
      end.

      assign de-conclu = if  ord-esp.tipo-tempo = 1 then
                             (ord-esp.conclusao + (de-tempo-real / (ord-esp.tempo * ord-esp.nr-homens)) * 100)
                         else
                             (ord-esp.conclusao + (de-tempo-real / (ord-esp.tempo / ord-esp.nr-homens)) * 100).

      if  de-conclu > 100 then 
          assign de-conclusao:screen-value in frame {&frame-name} = string(100).
      else
          if  de-conclu < 0 then
              assign de-conclusao:screen-value in frame {&frame-name} = string(0).
          else
              assign de-conclusao:screen-value in frame {&frame-name} = IF de-conclu = ? THEN "0" ELSE string(de-conclu).
  end.
  else
      assign de-conclusao:screen-value in frame {&frame-name} = "100".
&endif      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-apontamentos V-table-Win 
PROCEDURE pi-cria-apontamentos :
/*------------------------------------------------------------------------------
  Purpose: Crias os apontamentos de mÆo-de-obra na temp-table tt-apont    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mnt_ems203) &then
    def var c-hora-ini  as char no-undo.
    def var c-hora-term as char no-undo.
    def buffer b-tt-apont for tt-apont.

    for each tt-apont:
       delete tt-apont.
    end.

    ASSIGN c-hora-ini  = input frame {&FRAME-NAME} c-hora-inicio
           c-hora-term = input frame {&FRAME-NAME} c-hora-termino. 

    if c-opcao = "Estornar" then do:
       IF CAN-FIND(FIRST tecn-mi WHERE 
                         tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                         tecn-mi.log-1      = NO NO-LOCK) THEN DO: 
               FIND   FIRST data-turno-calen where 
                           data-turno-calen.cd-calen = tecn-mi.cd-calen and   
                           data-turno-calen.cd-turno = input frame {&FRAME-NAME} c-cd-turno and   
                           data-turno-calen.data     = input frame {&FRAME-NAME} da-reporte NO-LOCK NO-ERROR.
           FIND FIRST ord-mob WHERE 
                      ord-mob.nr-ord-produ =  tt-mao-de-obra.nr-ord-produ AND
                      ord-mob.cd-tarefa    =  tt-mao-de-obra.cd-tarefa    AND
                      ord-mob.dt-trans     =  tt-mao-de-obra.dt-trans     and
                      ord-mob.cd-tecnico   =  tt-mao-de-obra.cd-tecnico   AND
                      ord-mob.horas-report =  tt-mao-de-obra.horas-report AND
                      ord-mob.tipo-trans   =  1                          
                      &if defined (bf_mnt_ems204) &then
                          AND ord-mob.hora-inicio   = tt-mao-de-obra.hora-inicio
                          AND ord-mob.hora-termino  = tt-mao-de-obra.hora-termino 
                      &endif         

               NO-LOCK NO-ERROR.

           IF AVAIL ord-mob THEN DO:
               create tt-apont. 
               assign tt-apont.hora-ini    = tt-mao-de-obra.hora-inicio
                      tt-apont.hora-term   = tt-mao-de-obra.hora-termino
                      &if defined (bf_mnt_ems204) &then
                      tt-apont.hora-normal = ord-mob.hora-norm   
                      tt-apont.hora-extra  = ord-mob.hora-extra 
                      &endif

                   .  
            &if defined (bf_mnt_ems204) &then
            return "OK":U.
            &endif
           END.
       END.
       ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                              tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                              tecn-mi.log-1      = YES NO-LOCK) THEN DO: 
           create tt-apont.
           assign tt-apont.hora-ini    = "00:00"
                  tt-apont.hora-term   = "00:00"
                  tt-apont.hora-normal =  input frame {&FRAME-NAME} c-hra-norm
                  tt-apont.hora-extra  =  input frame {&FRAME-NAME} c-hra-ext.
           &if defined (bf_mnt_ems203) &then
           return "OK":U.
           &endif
       END.
    end.


    /* Carrega as sequencias a serem consideradas */   
    IF input frame {&FRAME-NAME} c-cd-tecnico <> "000000" THEN DO:
        find first tecn-mi where tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico 
             no-lock no-error.
        if not avail tecn-mi then do:
           {utp/ut-table.i mgind tecn-mi 1}
           run utp/ut-msgs.p (input "show",
                              input 47,
                              input return-value).
           apply "entry":U to c-cd-tecnico in frame {&FRAME-NAME}.
           return "error".
        end.
    END.
    for each tt-seq:
       delete tt-seq.
    end.

    for each data-turno-calen
        where data-turno-calen.cd-calen = tecn-mi.cd-calen
        and   data-turno-calen.cd-turno = input frame {&FRAME-NAME} c-cd-turno
        and   data-turno-calen.data     = input frame {&FRAME-NAME} da-reporte no-lock:

        if data-turno-calen.hora-inicio < data-turno-calen.hora-termino then do:
           create tt-seq.
           assign tt-seq.hora-ini  = substring(data-turno-calen.hora-inicio,1,2)  + substring(data-turno-calen.hora-inicio,4,2)
                  tt-seq.hora-term = substring(data-turno-calen.hora-termino,1,2) + substring(data-turno-calen.hora-termino,4,2)
                  tt-seq.tipo-hora = data-turno-calen.tipo-hora.

        end.          

    end.
    for each tt-seq where tt-seq.hora-term <= c-hora-ini:
        delete tt-seq.
    end.

    /* Cria os apontamentos conforme sequencias do turno */
    do while c-hora-ini < c-hora-term:
        
        find first tt-seq where 
                  tt-seq.hora-ini <= c-hora-ini use-index main no-error.
       if avail tt-seq then do:
          run pi-cria-tt-apont (c-hora-ini, minimum(c-hora-term,tt-seq.hora-term), tt-seq.tipo-hora). 
          assign c-hora-ini = minimum (c-hora-term,tt-seq.hora-term).   
         delete tt-seq.
       end.
       else do:
          find first tt-seq use-index main no-error.

          if avail tt-seq then do:
             if c-hora-ini = input frame {&FRAME-NAME} c-hora-inicio or 
                input frame {&FRAME-NAME} l-intervalo then do:
                run pi-cria-tt-apont(c-hora-ini,minimum(tt-seq.hora-ini,c-hora-term),2).
                assign c-hora-ini = minimum(tt-seq.hora-ini,c-hora-term).
             end.
             else do:
                run pi-cria-tt-apont(tt-seq.hora-ini, minimum(tt-seq.hora-term,c-hora-term), tt-seq.tipo-hora).
                IF input frame {&FRAME-NAME} l-intervalo THEN DO:
                    assign c-hora-ini = minimum (tt-seq.hora-ini,c-hora-term).
                END.
                ELSE DO:
                    assign c-hora-ini = minimum (tt-seq.hora-term,c-hora-term).
                END.
                delete tt-seq.
             end.
          end.   
          else do:
            run pi-cria-tt-apont(c-hora-ini,c-hora-term,2).
            assign c-hora-ini = c-hora-term.
          end.
       end.
    end.

    &if defined (bf_mnt_ems204) &then
        IF CAN-FIND(FIRST tecn-mi WHERE 
                          tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                          tecn-mi.log-1      = YES NO-LOCK) THEN DO: 
            run pi-cria-tt-apont(c-hora-ini,c-hora-term,0).
        END.
    &endif


    /* Agrupa apontamentos criados */
    def var l-aux as log init yes.
    do while l-aux:
       assign l-aux = no. 
       for each tt-apont use-index main:

         IF CAN-FIND(FIRST tecn-mi WHERE 
                           tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                           tecn-mi.log-1      = NO NO-LOCK) THEN DO:
           find first b-tt-apont where b-tt-apont.hora-ini = tt-apont.hora-term no-error.
           if avail b-tt-apont then do:
              assign tt-apont.hora-term   = b-tt-apont.hora-term
                     tt-apont.hora-normal = tt-apont.hora-normal + b-tt-apont.hora-normal
                     tt-apont.hora-extra  = tt-apont.hora-extra  + b-tt-apont.hora-extra.

              delete b-tt-apont.

              assign l-aux = yes.
              leave.
           end.
         END.
       end.
    end.
&endif

    RETURN "OK":U. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-apont V-table-Win 
PROCEDURE pi-cria-tt-apont :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   &if defined (bf_mnt_ems203) &then
       def input param p-hora-ini  as char.
       def input param p-hora-term as char.
       def input param p-tipo-hora as integer.

      IF CAN-FIND(FIRST tecn-mi WHERE 
                        tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                        tecn-mi.log-1      = NO NO-LOCK) THEN DO:

           IF p-hora-term > p-hora-ini then do:
             CREATE tt-apont.
             ASSIGN tt-apont.hora-ini  = string(p-hora-ini,"99:99")
                    tt-apont.hora-term = string(p-hora-term,"99:99").
                    
             IF p-tipo-hora = 1 THEN DO:
             
                ASSIGN tt-apont.hora-normal = ((dec(substring(p-hora-term,1,2)) * 60 + dec(substring(p-hora-term,3,2))) / 60) -
                                              ((dec(substring(p-hora-ini ,1,2)) * 60 + dec(substring(p-hora-ini ,3,2))) / 60)
                       tt-apont.hora-extra  = 0.
                      
                ASSIGN
                       tt-apont.hora-normal = round(tt-apont.hora-normal, 4)
                       tt-apont.hora-extra  = round(tt-apont.hora-extra, 4).          
             END.
                
             ELSE DO:
                ASSIGN tt-apont.hora-normal = 0
                       tt-apont.hora-extra  = ((dec(substring(p-hora-term,1,2)) * 60 + dec(substring(p-hora-term,3,2))) / 60) -
                                              ((dec(substring(p-hora-ini ,1,2)) * 60 + dec(substring(p-hora-ini ,3,2))) / 60).      
                ASSIGN
                       tt-apont.hora-normal = round(tt-apont.hora-normal, 4)
                       tt-apont.hora-extra  = round(tt-apont.hora-extra, 4).
             END.
           END.         
      END.
      
      ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                             tecn-mi.cd-tecnico = input frame {&FRAME-NAME} c-cd-tecnico and
                             tecn-mi.log-1      = YES  NO-LOCK) THEN DO:
             create tt-apont.
             assign tt-apont.hora-ini  = "00"
                    tt-apont.hora-term = "00"
                    tt-apont.hora-normal =  input frame {&FRAME-NAME} c-hra-norm
                    tt-apont.hora-extra  =  input frame {&FRAME-NAME} c-hra-ext.

      END.
   &endif       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-limpa-tela V-table-Win 
PROCEDURE pi-limpa-tela :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign c-cd-tecnico:screen-value in frame {&frame-name} = "000000" 
       c-nome-compl:screen-value in frame {&frame-name} = ""
       c-tp-especial:screen-value in frame {&frame-name} = ""
       c-desc-especial:screen-value in frame {&frame-name} = ""
       c-cd-tarefa:screen-value in frame {&frame-name} = ""
       c-descricao:screen-value in frame {&frame-name} = ""
       c-cd-ccusto:screen-value in frame {&frame-name} = ""
       c-desc-ccusto:screen-value in frame {&frame-name} = ""
       da-reporte:screen-value in frame {&frame-name} = string(today)
       c-tempo-real:screen-value in frame {&frame-name} = "0000"
       c-tempo-real1:screen-value in frame {&frame-name} = "000000"
       de-conclusao:screen-value in frame {&frame-name} = "0"
       c-hist-apont:SCREEN-VALUE IN FRAME {&frame-name} = ""
       c-observacao:SCREEN-VALUE IN FRAME {&frame-name} = ""
       &if defined (bf_mnt_ems203) &then
          c-hora-inicio:screen-value in frame {&frame-name} = "0000"
          c-hora-termino:screen-value in frame {&frame-name} = "0000"
       &endif
       .

apply 'entry' to c-cd-tecnico in frame {&frame-name}.       


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-procura-tarefa-especialidade V-table-Win 
PROCEDURE pi-procura-tarefa-especialidade :
/*------------------------------------------------------------------------------
  Purpose: Procedure a ser rodada no leave do campos Tarefa e Especialidade.
           Objetivo ‚ sugerir uma tarefa e especialidade previstas na OM,
           conforme as especialidades do t²cnico    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEF VAR l-achou-esp AS LOGICAL NO-UNDO.

   find ord-manut WHERE rowid(ord-manut) = v-row-parent no-lock no-error.
   
   IF iNrTarefaRecebida = 0 THEN
       find ord-taref WHERE rowid(ord-taref) = g-ord-taref  no-lock no-error.
   ELSE
       find ord-taref WHERE ord-taref.nr-ord-produ = ord-manut.nr-ord-produ
                        AND ord-taref.cd-tarefa = iNrTarefaRecebida  no-lock no-error.

   if avail ord-manut then do:
      /* Navega nas especialidades do t‚cnico, come‡ando pela principal, at‚ encontrar uma que ‚ prevista na OM */
      ASSIGN l-achou-esp = NO.
      FOR EACH  esp-tecn NO-LOCK
          WHERE esp-tecn.cd-tecnico = input frame {&frame-name} c-cd-tecnico
          BY esp-tecn.atividade:

          find ord-esp where
               ord-esp.nr-ord-produ = ord-manut.nr-ord-produ AND 
               ord-esp.cd-tarefa    = ord-taref.cd-tarefa    AND
               ord-esp.tp-especial  = esp-tecn.tp-especial   AND 
               ord-esp.encerrada    = NO                     no-lock no-error.

          if ambiguous ord-esp then do:     
             /* Verifica se existe essa especialidade na Tarefa marcada */
             if avail ord-taref and ord-taref.encerrada = NO THEN DO:
                find ord-esp where
                     ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
                     ord-esp.cd-tarefa    = ord-taref.cd-tarefa    AND
                     ord-esp.tp-especial  = esp-tecn.tp-especial   AND
                     ord-esp.encerrada    = NO                     no-lock no-error.
                IF AVAIL ord-esp THEN
                   assign c-cd-tarefa   = ord-esp.cd-tarefa
                          c-tp-especial = ord-esp.tp-especial
                          l-achou-esp = YES. 
             END.
             /* Se nÆo existe para tarefa principal, pode ser para qualquer tarefa nao encerrada*/
             IF l-achou-esp = NO THEN DO:
               FIND FIRST ord-esp where
                    ord-esp.nr-ord-produ = ord-manut.nr-ord-produ and
                    ord-esp.tp-especial  = esp-tecn.tp-especial   AND
                    ord-esp.encerrada    = NO                     AND 
                    CAN-FIND (FIRST ord-taref WHERE 
                              ord-taref.nr-ord-produ = ord-esp.nr-ord-produ AND
                              ord-taref.cd-tarefa    = ord-esp.cd-tarefa    AND
                              ord-taref.encerrada    = NO) no-lock no-error.
               IF AVAIL ord-esp THEN
                  assign c-cd-tarefa   = ord-esp.cd-tarefa
                         c-tp-especial = ord-esp.tp-especial
                         l-achou-esp = YES. 
             END.
          end.
          else 
             IF AVAIL ord-esp THEN DO:
                 assign c-cd-tarefa   = ord-esp.cd-tarefa
                        c-tp-especial = ord-esp.tp-especial
                        l-achou-esp = YES. 
             END.

           IF l-achou-esp THEN
             LEAVE.

      END.
   END.

   /* Se nÆo achou nenhuma das especialidades do t‚cnico como prevista para OM,
      assume a especialidade como a principal do t²cnico e a Tarefa como a marcada */
   IF l-achou-esp = NO THEN DO:
      find first esp-tecn where
                 esp-tecn.cd-tecnico = input frame {&frame-name} c-cd-tecnico and
                 esp-tecn.atividade  = 1 no-lock no-error.

      IF AVAIL esp-tecn THEN
         ASSIGN c-tp-especial = esp-tecn.tp-especial.

      IF (INPUT FRAME {&FRAME-NAME} c-cd-tarefa = "" OR INPUT FRAME {&FRAME-NAME} c-cd-tarefa = "0") AND AVAIL ord-taref and ord-taref.encerrada = no THEN DO:
         ASSIGN c-cd-tarefa = ord-taref.cd-tarefa.
      END.
   END.   
   /* Escrever descricao da Especialidade e Tarefa*/
   FIND mi-espec WHERE mi-espec.tp-especial = c-tp-especial
        no-lock no-error.
   IF AVAIL mi-espec THEN
      ASSIGN c-desc-especial = mi-espec.descricao.
   FIND FIRST ord-taref WHERE 
       ord-taref.nr-ord-produ = ord-manut.nr-ord-produ AND
       ord-taref.cd-tarefa    = c-cd-tarefa NO-LOCK NO-ERROR.
   IF AVAIL ord-taref THEN
      ASSIGN c-descricao = ord-taref.descricao. 

   disp c-tp-especial
        c-desc-especial
        c-cd-tarefa
        c-descricao
        with frame {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-campo V-table-Win 
PROCEDURE pi-seta-campo :
/*------------------------------------------------------------------------------
  Purpose:     Setar o foco no campo desejado.
  Parameters:  i-campo
  Notes:       
------------------------------------------------------------------------------*/
define input parameter i-campo as integer.

do with frame {&frame-name}:
   case i-campo :
        when 1  then apply 'entry' to c-cd-tecnico. 
        when 2  then apply 'entry' to c-tp-especial.
        when 3  then apply 'entry' to c-cd-tarefa.
        when 4  then apply 'entry' to c-cd-ccusto.
        when 5  then apply 'entry' to da-reporte.
        when 6  then apply 'entry' to cb-tp-relogio.
        when 7  then apply 'entry' to c-tempo-real.
        when 8  then apply 'entry' to l-encerrada.
        when 9  then apply 'entry' to de-conclusao.
        when 10 then apply 'entry' to c-hora-inicio.
        when 11 then apply 'entry' to c-hora-termino.
   end case.     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida»„es, pois neste ponto do programa o registro 
  ainda n’o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-turno V-table-Win 
PROCEDURE pi-verifica-turno :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&if defined (bf_mnt_ems203) &then
   assign input frame {&FRAME-NAME} c-cd-tecnico
          input frame {&FRAME-NAME} c-tp-especial
          input frame {&FRAME-NAME} da-reporte.
       find last cap-tecn-turno where cap-tecn-turno.cd-tecnico     = c-cd-tecnico
                                and   cap-tecn-turno.dt-efetivacao <= da-reporte
            use-index tecn-data no-lock no-error.                    
       if not avail cap-tecn-turno then do:
          find turno-espec where turno-espec.tp-especial = c-tp-especial
               no-lock no-error.
          if avail turno-espec then
             assign c-cd-turno = turno-espec.cd-turno.
          else 
             assign c-cd-turno = param-mi.cd-turno.       
        end.
        IF l-implantado AND AVAIL cap-tecn-turno THEN DO:
               assign c-cd-turno = cap-tecn-turno.cd-turno.
        END.
          ELSE
            ASSIGN c-cd-turno:screen-value in frame {&frame-name} = "".
            
       if c-opcao = "ESTORNAR":U then do:
           FIND FIRST ord-mob WHERE 
             ord-mob.nr-ord-produ =  tt-mao-de-obra.nr-ord-produ AND
             ord-mob.cd-tarefa    =  tt-mao-de-obra.cd-tarefa    AND
             ord-mob.dt-trans     =  tt-mao-de-obra.dt-trans     AND
             ord-mob.cd-tecnico   =  tt-mao-de-obra.cd-tecnico   AND
             ord-mob.horas-report =  tt-mao-de-obra.horas-report AND
             ord-mob.tipo-trans   =  tt-mao-de-obra.tipo-trans   AND
             ord-mob.hora-inicio  = tt-mao-de-obra.hora-inicio   AND
             ord-mob.hora-termino = tt-mao-de-obra.hora-termino NO-LOCK NO-ERROR.
           IF AVAIL ord-mob then
               assign c-cd-turno = ord-mob.int-1.	   
       end.

       display c-cd-turno with frame {&FRAME-NAME}.
       apply "leave":U to c-cd-turno in frame {&FRAME-NAME}.    
&endif



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piSetaTarefa V-table-Win 
PROCEDURE piSetaTarefa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER piTarefa AS INTEGER NO-UNDO.

    ASSIGN iNrTarefaRecebida = piTarefa.
    
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
  {src/adm/template/snd-list.i "mi-espec"}

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

