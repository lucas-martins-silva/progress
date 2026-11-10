&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V08IN273 2.00.00.041 } /*** "010041" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V08IN273 MUT}
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

{cdp/cdcfgmnt.i}
{mip/mi1024.i} /* tt-apont */
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var g-ord-taref  as rowid no-undo.
def new global shared var gr-mi-espec  as rowid no-undo.
def new global shared var gr-ord-manut as rowid no-undo.
def var de-par-tempo-real as decimal               no-undo.

DEFINE VARIABLE i-cont-narrativa AS INTEGER NO-UNDO.

def new global shared var c-par-cd-tecnico as char format "99999-9"    no-undo.
def new global shared var g-da-reporte     as date format "99/99/9999" no-undo.
def new global shared var c-opcao          as char                     no-undo.

/* Parameters Definitions ---                                           */



/* Local Variable Definitions ---                                       */

def temp-table tt-esp
    field indicador     as logical format "*/ "
    field cd-tarefa     like ord-taref.cd-tarefa
    field tp-especial   like ord-esp.tp-especial
    field descricao     like mi-espec.descricao
    field encerrada     like ord-esp.encerrada
    field conclusao     like ord-esp.conclusao
    index codigo is unique primary cd-tarefa tp-especial
    index cod-ind indicador.

def temp-table tt-mao-de-obra
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
    &endif 
    .
def var c-tempo-real-x as char. 
def var de-conclu    as decimal format ">>9.99"  no-undo.

def var de-tempo-real as decimal                   no-undo.
def var c-formato-1   as char init "99:99"         no-undo.
def var c-formato-2   as dec init "99.9999"       no-undo.
def var c-hora        as char no-undo.
def var de-minuto     as dec  no-undo.
def var c-tempo       as char no-undo.
def var l-primeira    as log  init yes no-undo.
def var c-combo       as char format "x(10)" no-undo.
def var i-valor       as int.
def var de-valor      as decimal.
def var i-cont        as int.
def var c-aux         as char.
DEFINE VARIABLE i-cd-turno AS INTEGER    NO-UNDO.
&if defined (bf_mnt_ems203) &then



   def var i-nr-reporte like ord-mob.nr-reporte    no-undo.

   def var hProgramZoom                      as handle no-undo.

&endif

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
&Scoped-define EXTERNAL-TABLES ord-taref ord-esp
&Scoped-define FIRST-EXTERNAL-TABLE ord-taref


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-taref, ord-esp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-hist-apont da-reporte bt-apont ~
cb-tp-relogio l-intervalo c-tempo-real c-tempo-real1 c-cd-turno ~
c-hora-inicio c-hora-termino c-hra-norm c-hra-ext bt-verif-apont ~
l-encerrada de-conclusao c-observacao rt-mold 
&Scoped-Define DISPLAYED-OBJECTS c-hist-apont c-cd-tarefa c-descricao ~
de-tempo da-reporte cb-tp-relogio l-intervalo c-tempo-real c-tempo-real1 ~
c-cd-turno c-descricao-turno c-hora-inicio c-hora-termino c-hra-norm ~
c-hra-ext c-hra-tot l-encerrada de-conclusao c-observacao 

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


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-apont 
     IMAGE-UP FILE "image~\gr-zoo":U
     IMAGE-INSENSITIVE FILE "image~\ii-zoo":U
     LABEL "" 
     SIZE 3.43 BY .88 TOOLTIP "Apontamentos do T‚cnico / Data".

DEFINE BUTTON bt-verif-apont 
     IMAGE-UP FILE "image~\gr-zoo":U
     IMAGE-INSENSITIVE FILE "image~\ii-zoo":U
     LABEL "" 
     SIZE 3.43 BY .88 TOOLTIP "Apontamentos a serem gerados".

DEFINE VARIABLE cb-tp-relogio AS CHARACTER FORMAT "X(10)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-hist-apont AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 58 BY 3.88 NO-UNDO.

DEFINE VARIABLE c-observacao AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 58 BY 3.88 NO-UNDO.

DEFINE VARIABLE c-cd-tarefa AS INTEGER FORMAT "->,>>>,>>9" INITIAL 100 
     LABEL "Tarefa Manuten‡Æo":R21 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE VARIABLE c-cd-turno AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Turno":R21 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88.

DEFINE VARIABLE c-descricao-turno AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 51 BY .88.

DEFINE VARIABLE c-hora-inicio AS CHARACTER FORMAT "99:99" INITIAL "0000" 
     LABEL "Hora In¡cio" 
     VIEW-AS FILL-IN 
     SIZE 14.29 BY .88.

DEFINE VARIABLE c-hora-termino AS CHARACTER FORMAT "99:99" INITIAL "0000" 
     LABEL "Hora T‚rmino" 
     VIEW-AS FILL-IN 
     SIZE 12.14 BY .88.

DEFINE VARIABLE c-hra-ext AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Horas Extra" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-norm AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Horas Normais" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-hra-tot AS DECIMAL FORMAT ">>9.9999":U INITIAL 0 
     LABEL "Horas Totais" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE c-tempo-real AS CHARACTER FORMAT "x(8)" INITIAL "00:00" 
     LABEL "Tempo Real":R12 
     VIEW-AS FILL-IN 
     SIZE 11.29 BY .88.

DEFINE VARIABLE c-tempo-real1 AS DECIMAL FORMAT "99.9999":U INITIAL 0 
     LABEL "Tempo Real" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE da-reporte AS DATE FORMAT "99/99/9999" 
     LABEL "Data Transa‡Æo":R17 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-conclusao AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Percentual ConclusÆo":R24 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE de-tempo AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "Tempo":R7 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 15.5.

DEFINE VARIABLE l-encerrada AS LOGICAL INITIAL no 
     LABEL "Encerrada":L11 
     VIEW-AS TOGGLE-BOX
     SIZE 14.29 BY .88.

DEFINE VARIABLE l-intervalo AS LOGICAL INITIAL no 
     LABEL "Aponta durante intervalo?" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.43 BY .75 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-hist-apont AT ROW 8.25 COL 26 NO-LABEL WIDGET-ID 2
     c-cd-tarefa AT ROW 1.25 COL 24 COLON-ALIGNED
     c-descricao AT ROW 1.25 COL 31.14 COLON-ALIGNED NO-LABEL
     de-tempo AT ROW 2.25 COL 24 COLON-ALIGNED
     da-reporte AT ROW 3.25 COL 24 COLON-ALIGNED
     bt-apont AT ROW 3.25 COL 40.43 HELP
          "Apontamentos do T‚cnico / Data"
     cb-tp-relogio AT ROW 4.25 COL 23.86 COLON-ALIGNED
     l-intervalo AT ROW 3.08 COL 53
     c-tempo-real AT ROW 5.25 COL 24 COLON-ALIGNED
     c-tempo-real1 AT ROW 5.25 COL 24 COLON-ALIGNED
     c-cd-turno AT ROW 5.25 COL 24 COLON-ALIGNED
     c-descricao-turno AT ROW 5.25 COL 31.14 COLON-ALIGNED NO-LABEL
     c-hora-inicio AT ROW 6.25 COL 24 COLON-ALIGNED HELP
          "Hora de In¡cio do Apontamento"
     c-hora-termino AT ROW 6.25 COL 59.29 COLON-ALIGNED HELP
          "Hora de T‚rmino do Apontamento"
     c-hra-norm AT ROW 6.25 COL 24 COLON-ALIGNED
     c-hra-ext AT ROW 6.25 COL 48 COLON-ALIGNED
     c-hra-tot AT ROW 6.25 COL 70 COLON-ALIGNED
     bt-verif-apont AT ROW 6.25 COL 85 HELP
          "Apontamentos a serem gerados"
     l-encerrada AT ROW 7.29 COL 26
     de-conclusao AT ROW 7.25 COL 63.43 COLON-ALIGNED
     c-observacao AT ROW 12.25 COL 26 NO-LABEL WIDGET-ID 4
     "Narrativa Tarefa:" VIEW-AS TEXT
          SIZE 12.14 BY .88 AT ROW 8.25 COL 13.72 WIDGET-ID 6
     "Observa‡äes Apontamento:" VIEW-AS TEXT
          SIZE 19 BY .88 AT ROW 12.29 COL 6.57 WIDGET-ID 8
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-taref,movind.ord-esp
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
         HEIGHT             = 16.79
         WIDTH              = 88.72.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       bt-verif-apont:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cd-tarefa IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cd-turno:HIDDEN IN FRAME f-main           = TRUE
       c-cd-turno:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cd-turno:HANDLE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-turno IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-descricao-turno:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       c-hist-apont:READ-ONLY IN FRAME f-main        = TRUE.

ASSIGN 
       c-hora-inicio:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       c-hora-termino:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-hra-tot IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-tempo-real:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       c-tempo-real1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-tp-relogio IN FRAME f-main
   3                                                                    */
ASSIGN 
       cb-tp-relogio:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-tempo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       l-intervalo:HIDDEN IN FRAME f-main           = TRUE.

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

  run mip/mi0308g.w (input c-par-cd-tecnico,
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
                     tecn-mi.cd-tecnico = c-par-cd-tecnico and
                     tecn-mi.log-1      = NO NO-LOCK) THEN DO:
       if input frame {&FRAME-NAME} c-hora-inicio >= input frame {&FRAME-NAME} c-hora-termino then do:
           run utp/ut-msgs.p(input "show",
                             input 5820,
                             input c-hora-inicio:label in frame {&FRAME-NAME} + "~~" + 
                                   c-hora-termino:label in frame {&FRAME-NAME}).
           apply 'entry' to c-hora-inicio in frame {&frame-name}.
           return no-apply.
       end.   
   END.

   RUN pi-cria-apontamentos.
   run mip/mi0308h.w (input c-par-cd-tecnico,
                      input input frame {&FRAME-NAME} c-cd-tarefa,
                      input mi-espec.tp-especial,
                      input input frame {&FRAME-NAME} da-reporte,
                      input table tt-apont).
 &endif                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cd-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-turno V-table-Win
ON F5 OF c-cd-turno IN FRAME f-main /* Turno */
DO:
  &if defined (bf_mnt_ems203) &then
   {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z01mn031.w"
           &FieldZoom1="cd-turno"
           &FieldScreen1="c-cd-turno"
           &Frame1="f-main"
           &FieldZoom2="descricao"
           &FieldScreen2="c-descricao-turno"
           &Frame2="f-main"
           &EnableImplant="NO"
           &RunMethod="run setConstraintMiEspec in hProgramZoom (input mi-espec.tp-especial)."}
  &endif         

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
 /* if lookup ((substring(input frame {&FRAME-NAME} c-hora-termino,3,2)),"00,15,30,45") < 1 then do: 
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
ON LEAVE OF c-hra-ext IN FRAME f-main /* Horas Extra */
DO:
  &if defined (bf_mnt_ems203) &then
    ASSIGN c-hra-tot:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(input frame {&FRAME-NAME} c-hra-norm + input frame {&FRAME-NAME} c-hra-ext).
  &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-hra-norm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-hra-norm V-table-Win
ON LEAVE OF c-hra-norm IN FRAME f-main /* Horas Normais */
DO:
  &if defined (bf_mnt_ems203) &then
     ASSIGN c-hra-tot:SCREEN-VALUE IN FRAME {&FRAME-NAME} = string(input frame {&FRAME-NAME} c-hra-norm + input frame {&FRAME-NAME} c-hra-ext).
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-tempo-real
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tempo-real V-table-Win
ON ENTRY OF c-tempo-real IN FRAME f-main /* Tempo Real */
DO:
    if  l-encerrada:screen-value in frame {&frame-name} = 'yes' then
        disable de-conclusao with frame {&frame-name}.
    else
        enable de-conclusao with frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
                 c-tempo-real:format in frame {&frame-name} = c-formato-1.
 end. 
 else do:
          assign c-tempo-real1:hidden = no
                 c-tempo-real:hidden  = yes
                 c-tempo-real1:sensitive = yes
                 c-tempo-real1:screen-value in frame {&frame-name} = "0".
  end.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME da-reporte
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL da-reporte V-table-Win
ON LEAVE OF da-reporte IN FRAME f-main /* Data Transa‡Æo */
DO:

   assign g-da-reporte = input frame {&frame-name} da-reporte.

   &if defined (bf_mnt_ems203) &then
      if da-reporte:modified in frame {&FRAME-NAME} then
         RUN pi-verifica-turno. 
      assign da-reporte:modified in frame {&FRAME-NAME} = no.   
   &endif 

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
    if  input frame {&frame-name} l-encerrada = no then do:
        enable de-conclusao with frame {&frame-name}.
        run pi-calcula-conclusao.
    end.    
    else do:
        disable de-conclusao with frame {&frame-name}.
        assign de-conclusao = 100.
        disp de-conclusao with frame {&frame-name}.
    end.
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
if c-cd-turno:load-mouse-pointer ("image/rbm.cur") in frame {&FRAME-NAME} then.

{utp/ut-liter.i Tipo_de_Rel¢gio * r} 
assign cb-tp-relogio:label in frame {&frame-name} = trim(return-value).

&if defined (bf_mnt_ems203)  &then
  {utp/ut-field.i mgind ord-mob hora-inicio 1} 
   assign c-hora-inicio:label in frame {&frame-name} = trim(return-value).
          /* c-hra-norm:HIDDEN IN FRAME {&FRAME-NAME} = YES    */
          /* c-hra-ext:HIDDEN IN FRAME {&FRAME-NAME} = YES     */
          /* c-hra-tot:HIDDEN IN FRAME {&FRAME-NAME} = YES.    */
  {utp/ut-field.i mgind ord-mob hora-termino 1} 
   assign c-hora-termino:label in frame {&frame-name} = trim(return-value).
&endif  

find first param-mi no-lock no-error.
find mi-espec
    where rowid(mi-espec) = gr-mi-espec
    no-lock no-error.
find ord-taref where 
     rowid(ord-taref) = g-ord-taref
     no-lock no-error.
if  avail ord-taref then do:
    find ord-esp
        where ord-esp.nr-ord-produ = ord-taref.nr-ord-produ
        and   ord-esp.cd-tarefa    = ord-taref.cd-tarefa
        and   ord-esp.tp-especial  = mi-espec.tp-especial
        no-lock no-error.
    assign c-cd-tarefa   = ord-taref.cd-tarefa
           c-descricao   = ord-taref.descricao
           de-tempo      = ord-esp.tempo when avail ord-esp
           de-tempo      = 0 when not avail ord-esp
           l-encerrada   = ord-esp.encerrada when avail ord-esp
           de-conclusao  = ord-esp.conclusao when avail ord-esp
           c-hist-apont  = ord-taref.narrativa.


ASSIGN i-cont-narrativa = LENGTH(c-hist-apont).

    disp c-cd-tarefa
         c-descricao
         de-tempo
         l-encerrada
         de-conclusao
         c-hist-apont
         with frame {&frame-name}.    
end.

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
  {src/adm/template/row-list.i "ord-taref"}
  {src/adm/template/row-list.i "ord-esp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-taref"}
  {src/adm/template/row-find.i "ord-esp"}

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
    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
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

   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE c-lista1 AS CHARACTER  NO-UNDO.
       DEFINE VARIABLE c-lista2 AS CHARACTER  NO-UNDO.
       assign c-lista1 = {ininc/i01in289.i 04 3}.
           run utp/ut-lstit.p (input-output c-lista1).
       assign c-lista2 = {ininc/i01in289.i 04 1}.
           run utp/ut-lstit.p (input-output c-lista2).
       assign cb-tp-relogio:list-item-pairs in frame {&frame-name} = c-lista1 + "," + c-lista2.
   &else
       cb-tp-relogio:add-last({ininc/i01in289.i 04 3}) in frame {&frame-name}.
       cb-tp-relogio:add-last({ininc/i01in289.i 04 1}) in frame {&frame-name}.
   &endif
FIND FIRST param-mi no-lock.
if c-opcao = "Reportar" then do:
    ASSIGN da-reporte  = TODAY.                      
    if  avail param-mi and param-mi.tp-relogio = 1 or 
        param-mi.tp-relogio = 3 then do:
        assign c-tempo-real:screen-value in frame {&frame-name}  = "0000"
               c-tempo-real1:screen-value in frame {&frame-name} = "000000"
               cb-tp-relogio:screen-value in frame {&frame-name} = {ininc/i01in289.i 04 param-mi.tp-relogio} 
               c-combo                                           = {ininc/i01in289.i 04 param-mi.tp-relogio}.

    end.

       assign da-reporte:screen-value in frame {&frame-name} = string(today)
              c-tempo-real:format in frame {&frame-name} = c-formato-1.  

    &if defined (bf_mnt_ems203)  &then
        assign c-hora-inicio:hidden in frame {&FRAME-NAME} = no
               c-hora-termino:hidden in frame {&FRAME-NAME} = no
               l-intervalo:hidden in frame {&FRAME-NAME} = no
               c-cd-turno:hidden in frame {&FRAME-NAME} = no
               c-descricao-turno:hidden in frame {&FRAME-NAME} = no
               bt-verif-apont:hidden in frame {&FRAME-NAME} = no.
        disp   c-hora-inicio c-hora-termino 
               l-intervalo c-cd-turno c-descricao-turno with frame {&FRAME-NAME}.    
    &else
        assign cb-tp-relogio:hidden = no.
        if  param-mi.tp-relogio = 1 then do:
            assign c-tempo-real:hidden  = no
                   c-tempo-real1:hidden = yes
                   c-tempo-real1:sensitive = yes 
                   c-tempo-real:format in frame {&frame-name} = c-formato-1.
        end. 
        else do:
            assign c-tempo-real1:hidden = no
                   c-tempo-real:hidden  = yes
                   c-tempo-real1:sensitive = yes.
        end.

    &endif       

    &if defined (bf_mnt_ems204) &then
      IF CAN-FIND(FIRST tecn-mi WHERE 
                        tecn-mi.cd-tecnico = c-par-cd-tecnico and
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
                                tecn-mi.cd-tecnico = c-par-cd-tecnico and
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


end.

    &if defined (bf_mnt_ems204) &then
      IF CAN-FIND(FIRST tecn-mi WHERE 
                        tecn-mi.cd-tecnico = c-par-cd-tecnico and
                        tecn-mi.log-1      = YES NO-LOCK) THEN DO:
              ASSIGN c-hra-norm:HIDDEN IN FRAME {&frame-name} = FALSE
                     c-hra-ext:HIDDEN IN FRAME {&frame-name}  = FALSE
                     c-hra-tot:HIDDEN IN FRAME {&frame-name}  = FALSE
                     c-hora-termino:HIDDEN IN FRAME {&frame-name}  = TRUE
                     c-hora-inicio:HIDDEN IN FRAME {&frame-name}  = TRUE.
         END.
         ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                                tecn-mi.cd-tecnico = c-par-cd-tecnico and
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

/* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign da-reporte:modified in frame {&FRAME-NAME} = yes.

  disp da-reporte with  frame {&frame-name}.
  apply "leave":U to da-reporte in frame {&FRAME-NAME}.
  APPLY "value-changed":U TO c-observacao IN frame {&FRAME-NAME}.

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

find first tt-mao-de-obra.
&if defined (bf_mnt_ems204) &then
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

&ENDIF

assign de-tempo-real = tt-mao-de-obra.horas-report
       da-reporte    = tt-mao-de-obra.dt-trans
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

IF CAN-FIND(FIRST tecn-mi WHERE 
                  tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                  tecn-mi.log-1      = NO NO-LOCK) THEN DO:

disp da-reporte
     &if defined (bf_mnt_ems203) &then
           c-hora-inicio
           c-hora-termino
     &endif
     with frame {&frame-name}.

END.
ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                       tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                       tecn-mi.log-1      = YES NO-LOCK) THEN DO:
    disp da-reporte
         &if defined (bf_mnt_ems204) &then
               c-hra-norm
               c-hra-ext
               c-hra-tot 
         &endif
         with frame {&frame-name}.

END.

 IF CAN-FIND(FIRST tecn-mi WHERE 
                   tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                   tecn-mi.log-1      = NO NO-LOCK) THEN DO:
    disable da-reporte 
            &if defined (bf_mnt_ems203) &then
               c-hora-inicio
               c-hora-termino
               l-intervalo
               c-cd-turno
               bt-verif-apont
            &endif
            with frame {&frame-name}.

 END.
 ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                        tecn-mi.cd-tecnico = tt-mao-de-obra.cd-tecnico and
                        tecn-mi.log-1      = YES NO-LOCK) THEN DO:
     disable da-reporte 
            &if defined (bf_mnt_ems204) &then
               c-hra-norm
               c-hra-ext
               c-hra-tot
               l-intervalo
               c-cd-turno
               bt-verif-apont
            &endif
            with frame {&frame-name}.
 END.
&if defined (bf_mnt_ems203) &then
&else
     disp c-tempo-real1 with frame {&frame-name}.
     assign c-tempo-real1:sensitive in frame {&frame-name} = yes
            cb-tp-relogio:hidden = no
            cb-tp-relogio:screen-value in frame {&frame-name} = {ininc/i01in289.i 04 3}. 
&endif

assign g-da-reporte = input frame {&frame-name} da-reporte.

apply 'value-changed' to l-encerrada in frame {&FRAME-NAME}.

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
define output parameter de-tempo-real as decimal format ">9,9999" no-undo.
define output parameter l-par-encerrada   as logical                    no-undo.
define output parameter de-par-conclusao  as decimal format "->>>>9,99" no-undo.
define output parameter i-cd-turno        as INT no-undo.
DEFINE OUTPUT PARAMETER p-c-hist-apont AS CHARACTER NO-UNDO.
DEF VAR d-fim AS DEC NO-UNDO.
DEF VAR d-ini AS DEC NO-UNDO.
&if defined (bf_mnt_ems203) &then
   define output parameter i-num-reporte  like ord-mob.nr-reporte       no-undo.
   define output param table for tt-apont.
&endif

ASSIGN i-cd-turno = input frame {&FRAME-NAME} c-cd-turno.

&if defined (bf_mnt_ems203) &then
   IF CAN-FIND(FIRST tecn-mi WHERE 
                     tecn-mi.cd-tecnico = c-par-cd-tecnico and
                     tecn-mi.log-1      = NO NO-LOCK) THEN DO:
       if input frame {&FRAME-NAME} c-hora-inicio >= input frame {&FRAME-NAME} c-hora-termino then do:
           run utp/ut-msgs.p(input "show",
                             input 5820,
                             input c-hora-inicio:label in frame {&FRAME-NAME} + "~~" + 
                                   c-hora-termino:label in frame {&FRAME-NAME}).
           apply 'entry' to c-hora-inicio in frame {&frame-name}.
           return error.
       end.
   END.
   RUN pi-cria-apontamentos.    
   assign de-tempo-real = 0. 
   for each tt-apont:
      &if defined (bf_mnt_ems204) &then
      assign de-tempo-real = de-tempo-real + 
                             tt-apont.hora-normal + tt-apont.hora-extra.
      &else
      assign de-tempo-real = de-tempo-real + (dec(substring(tt-apont.hora-term,1,2)) +
                                             (dec(substring(tt-apont.hora-term,4,2))) / 60) -
                                             (dec(substring(tt-apont.hora-ini,1,2))  +
                                             (dec(substring(tt-apont.hora-ini,4,2))) / 60).
      &endif
   end.  
   assign i-num-reporte = i-nr-reporte.
&else
   if  input frame {&frame-name} cb-tp-relogio = "Hor rio" THEN DO:
       assign de-tempo-real = (dec(substring(c-hora-termino:SCREEN-VALUE IN FRAME {&frame-name} ,1,2)) * 60 + 
                               dec(substring(c-hora-termino:SCREEN-VALUE IN FRAME {&frame-name} ,4,2))) / 60 - 
                              (dec(substring(c-hora-inicio:SCREEN-VALUE IN FRAME {&frame-name} ,1,2)) * 60 + 
                               dec(substring(c-hora-inicio:SCREEN-VALUE IN FRAME {&frame-name} ,4,2))) / 60.
   END.
   else
       assign de-tempo-real = input frame {&frame-name} c-tempo-real1.

&endif

assign l-par-encerrada   = input frame {&frame-name} l-encerrada
       de-par-conclusao  = input frame {&frame-name} de-conclusao.

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
&IF DEFINED (bf_mnt_ems203) &THEN  
  IF  AVAIL ord-esp THEN DO:
      RUN pi-cria-apontamentos.
      ASSIGN de-tempo-real = 0.
      FOR EACH tt-apont:
          ASSIGN de-tempo-real = de-tempo-real + tt-apont.hora-normal + tt-apont.hora-extra.
      END.

      ASSIGN de-conclu = IF ord-esp.tipo-tempo = 1 THEN
                             (ord-esp.conclusao + (de-tempo-real / (ord-esp.tempo * ord-esp.nr-homens)) * 100)
                         ELSE
                             (ord-esp.conclusao + (de-tempo-real / (ord-esp.tempo / ord-esp.nr-homens)) * 100).

      IF ord-esp.tempo = 0 OR ord-esp.nr-homens = 0 THEN
            assign de-conclu = 0.

      IF de-conclu > 100 THEN 
          ASSIGN de-conclusao:screen-value in frame {&frame-name} = string(100).
      ELSE
          if  de-conclu < 0 THEN
              ASSIGN de-conclusao:screen-value in frame {&frame-name} = string(0).
          ELSE
              ASSIGN de-conclusao:screen-value in frame {&frame-name} = string(de-conclu).
  END.
  ELSE
      ASSIGN de-conclusao:screen-value in frame {&frame-name} = "100".

&ENDIF

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

    find first tt-mao-de-obra NO-ERROR.
    IF AVAIL tt-mao-de-obra THEN DO:
       assign c-hora-ini  = substr(tt-mao-de-obra.hora-inicio,1,2)  + substr(tt-mao-de-obra.hora-inicio,4,2)
              c-hora-term = substr(tt-mao-de-obra.hora-TERMINO,1,2) + substr(tt-mao-de-obra.hora-TERMINO,4,2).
    END.

    IF C-OPCAO = "Reportar":U THEN
        assign C-HORA-INICIO  = INPUT FRAME {&FRAME-NAME} C-HORA-INICIO
               C-HORA-TERMINO = INPUT FRAME {&FRAME-NAME} C-HORA-TERMINO
               c-hora-ini  = C-HORA-INICIO 
               c-hora-term = C-HORA-TERMINO.

    if c-opcao = "Estornar" then do:
       IF CAN-FIND(FIRST tecn-mi WHERE 
                         tecn-mi.cd-tecnico = c-par-cd-tecnico and
                         tecn-mi.log-1      = NO NO-LOCK) THEN DO: 
           FIND FIRST ord-mob WHERE 
                      ord-mob.nr-ord-produ =  tt-mao-de-obra.nr-ord-produ AND
                      ord-mob.cd-tarefa    =  tt-mao-de-obra.cd-tarefa    AND
                      ord-mob.dt-trans     =  tt-mao-de-obra.dt-trans     and
                      ord-mob.cd-tecnico   =  tt-mao-de-obra.cd-tecnico   AND
                      ord-mob.horas-report =  tt-mao-de-obra.horas-report AND
                      ord-mob.tipo-trans   =  1                          
                      &if defined (bf_mnt_ems203) &then
                          AND ord-mob.hora-inicio   = tt-mao-de-obra.hora-inicio
                          AND ord-mob.hora-termino  = tt-mao-de-obra.hora-termino 
                      &endif         

               NO-LOCK NO-ERROR.
           IF AVAIL ord-mob THEN DO:
                
               create tt-apont.
               assign tt-apont.hora-ini    = string(c-hora-ini,"99:99")
                      tt-apont.hora-term   = string(c-hora-term,"99:99")
                      &if defined (bf_mnt_ems204) &then
                      tt-apont.hora-normal = ord-mob.hora-norm   
                      tt-apont.hora-extra  = ord-mob.hora-extra 
                      &endif
                   .  
               return "OK":U.
           END.
       END.
       ELSE IF CAN-FIND(FIRST tecn-mi WHERE 
                              tecn-mi.cd-tecnico = c-par-cd-tecnico and
                              tecn-mi.log-1      = YES NO-LOCK) THEN DO: 
           create tt-apont.
           assign tt-apont.hora-ini    = "00:00"
                  tt-apont.hora-term   = "00:00"
                  &if defined (bf_mnt_ems204) &then
                  tt-apont.hora-normal =  input frame {&FRAME-NAME} c-hra-norm
                  tt-apont.hora-extra  =  input frame {&FRAME-NAME} c-hra-ext
                  &endif
                  .
          RETURN "OK":U.
       END.
    end.
    /* Carrega as sequencias a serem consideradas */        
    find first tecn-mi where tecn-mi.cd-tecnico = c-par-cd-tecnico 
         no-lock no-error.
    if not avail tecn-mi then do:
       {utp/ut-table.i mgind tecn-mi 1}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).
       return 'error'.
    end.
    for each tt-seq:
       delete tt-seq.
    end.
    for each data-turno-calen
        where data-turno-calen.cd-calen = tecn-mi.cd-calen
        and   data-turno-calen.cd-turno = input frame {&FRAME-NAME} c-cd-turno
        and   data-turno-calen.data     = input frame {&FRAME-NAME} da-reporte no-lock:
        if data-turno-calen.hora-ini < data-turno-calen.hora-term then do:
           create tt-seq.
           assign tt-seq.hora-ini  = substring(data-turno-calen.hora-ini,1,2)  + substring(data-turno-calen.hora-ini,4,2)
                  tt-seq.hora-term = substring(data-turno-calen.hora-term,1,2) + substring(data-turno-calen.hora-term,4,2)
                  tt-seq.tipo-hora = data-turno-calen.tipo-hora.
        end.          
    end.
    for each tt-seq where tt-seq.hora-term <= c-hora-ini:
        delete tt-seq.
    end.

    /* Cria os apontamentos conforme sequencias do turno */
    do while c-hora-ini < c-hora-term:
       find first tt-seq where tt-seq.hora-ini <= c-hora-ini use-index main no-error.
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
                assign c-hora-ini = minimum (tt-seq.hora-term,c-hora-term).
                delete tt-seq.
             end.
          end.   
          else do:
             run pi-cria-tt-apont(c-hora-ini,c-hora-term,2).
             assign c-hora-ini = c-hora-term.
          end.
       end.
    end.

    IF CAN-FIND(FIRST tecn-mi WHERE 
                      tecn-mi.cd-tecnico = c-par-cd-tecnico and
                      tecn-mi.log-1      = YES  NO-LOCK) THEN DO:
        run pi-cria-tt-apont(c-hora-ini,minimum(0,0),0).
    END.

    /* Agrupa apontamentos criados */
    def var l-aux as log init yes.
    do while l-aux:
       assign l-aux = no. 

       IF CAN-FIND(FIRST tecn-mi WHERE 
                         tecn-mi.cd-tecnico = c-par-cd-tecnico and
                         tecn-mi.log-1      = NO NO-LOCK) THEN DO:

           for each tt-apont use-index main:
               find first b-tt-apont where b-tt-apont.hora-ini = tt-apont.hora-term no-error.
               if avail b-tt-apont then do:
                  assign tt-apont.hora-term   = b-tt-apont.hora-term
                         tt-apont.hora-normal = tt-apont.hora-normal + b-tt-apont.hora-normal
                         tt-apont.hora-extra  = tt-apont.hora-extra  + b-tt-apont.hora-extra.
                  delete b-tt-apont.
                  assign l-aux = yes.
                  leave.
               end.
           end.
       END.
    end.

&endif
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
                         tecn-mi.cd-tecnico = c-par-cd-tecnico and
                         tecn-mi.log-1      = NO NO-LOCK) THEN DO:
           if p-hora-term > p-hora-ini then do:
             create tt-apont.
             assign tt-apont.hora-ini  = string(p-hora-ini,"99:99")
                    tt-apont.hora-term = string(p-hora-term,"99:99").
             if p-tipo-hora = 1 then
                assign tt-apont.hora-normal = ((dec(substring(p-hora-term,1,2)) * 60 + dec(substring(p-hora-term,3,2))) / 60) -
                                              ((dec(substring(p-hora-ini ,1,2)) * 60 + dec(substring(p-hora-ini ,3,2))) / 60)
                       tt-apont.hora-extra  = 0.
             else 
                assign tt-apont.hora-normal = 0
                       tt-apont.hora-extra  = ((dec(substring(p-hora-term,1,2)) * 60 + dec(substring(p-hora-term,3,2))) / 60) -
                                              ((dec(substring(p-hora-ini ,1,2)) * 60 + dec(substring(p-hora-ini ,3,2))) / 60).      
           end.         
       END.
       ELSE DO: 
           &if defined (bf_mnt_ems203) &then       
               IF CAN-FIND(FIRST tecn-mi WHERE 
                                  tecn-mi.cd-tecnico = c-par-cd-tecnico and
                                  tecn-mi.log-1      = YES NO-LOCK) THEN DO:
                   create tt-apont.
                   assign tt-apont.hora-ini  = "00:00"
                          tt-apont.hora-term = "00:00"
                          tt-apont.hora-normal = input frame {&FRAME-NAME} c-hra-norm
                          tt-apont.hora-extra  = input frame {&FRAME-NAME} c-hra-ext.
               END.
            &ENDIF
       END.

   &endif       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-campo V-table-Win 
PROCEDURE pi-seta-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define input parameter i-campo as integer.

do with frame {&frame-name}:
   case i-campo :
        when 1 then apply 'entry' to c-cd-tarefa. 
        when 2 then apply 'entry' to de-tempo.
        when 3 then apply 'entry' to da-reporte.
        when 4 then apply 'entry' to cb-tp-relogio.
        when 5 then apply 'entry' to c-tempo-real.
        when 6 then apply 'entry' to de-conclusao.
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
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/


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
   assign input frame {&FRAME-NAME} da-reporte.
   find last cap-tecn-turno where cap-tecn-turno.cd-tecnico     = c-par-cd-tecnico
                            and   cap-tecn-turno.dt-efetivacao <= da-reporte
        use-index tecn-data no-lock no-error.                    
   if not avail cap-tecn-turno then do:
      find turno-espec where turno-espec.tp-especial = mi-espec.tp-especial
           no-lock no-error.
      if avail turno-espec then
         assign c-cd-turno = turno-espec.cd-turno.
      else 
         assign c-cd-turno = param-mi.cd-turno.       
   end.
   else
      assign c-cd-turno = cap-tecn-turno.cd-turno.

   display c-cd-turno with frame {&FRAME-NAME}.
   apply "leave":U to c-cd-turno in frame {&FRAME-NAME}.    

&endif

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
  {src/adm/template/snd-list.i "ord-taref"}
  {src/adm/template/snd-list.i "ord-esp"}

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

