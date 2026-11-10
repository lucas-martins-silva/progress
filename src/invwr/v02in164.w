&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V02IN164 2.00.00.016 } /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN164 MUT}
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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-it-exame for it-exame.
def buffer b-tex-exame for tex-exame.

def var l-new-record as logical.
def var l-cancela as logical.

def var c-texto-exame like exame-tex.linha-desc. 
    /* Esta variavel ² inicializada na pi-inicializa-texto.
       Se for inclusao,  ela sera inicializada com o texto padr’o do exame.
       Se for altera»’o, ela serÿ inicializada com o texto do exame deste item.
       A pi-inicializa-texto ² chamada na initialize da window e
       no leave do codigo do exame.                                     */

/***************************** Multi-Planta *****************************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.

{cqp/cqapi201.i}
{cdp/cd7300.i1}
/*************************** Fim Multi-Planta ***************************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-exame
&Scoped-define FIRST-EXTERNAL-TABLE it-exame


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-exame.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-exame.frequencia it-exame.perc-nqa ~
it-exame.nivel it-exame.situacao it-exame.responsavel 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}frequencia ~{&FP2}frequencia ~{&FP3}~
 ~{&FP1}perc-nqa ~{&FP2}perc-nqa ~{&FP3}~
 ~{&FP1}nivel ~{&FP2}nivel ~{&FP3}~
 ~{&FP1}responsavel ~{&FP2}responsavel ~{&FP3}
&Scoped-define ENABLED-TABLES it-exame
&Scoped-define FIRST-ENABLED-TABLE it-exame
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 RECT-10 bt-narrativa 
&Scoped-Define DISPLAYED-FIELDS it-exame.cod-exame it-exame.descricao ~
it-exame.frequencia it-exame.perc-nqa it-exame.nivel it-exame.situacao ~
it-exame.responsavel 
&Scoped-Define DISPLAYED-OBJECTS c-responsavel l-severa l-pref-bom l-normal ~
l-pref-oti l-atenuada l-pref-exc FILL-IN-32 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS it-exame.cod-exame 
&Scoped-define ADM-MODIFY-FIELDS l-severa l-pref-bom l-normal l-pref-oti ~
l-atenuada l-pref-exc 

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
DEFINE BUTTON bt-narrativa 
     LABEL "Narrativa" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-responsavel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-32 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 22.29 BY 1.83.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.13.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.71.

DEFINE VARIABLE l-atenuada AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE l-normal AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.43 BY .88 NO-UNDO.

DEFINE VARIABLE l-pref-bom AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE l-pref-exc AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE l-pref-oti AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.29 BY .88 NO-UNDO.

DEFINE VARIABLE l-severa AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 15.43 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-exame.cod-exame AT ROW 1.21 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     it-exame.descricao AT ROW 1.21 COL 26.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     it-exame.frequencia AT ROW 2.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     it-exame.perc-nqa AT ROW 3.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     it-exame.nivel AT ROW 4.67 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 2.57 BY .88
     it-exame.situacao AT ROW 6.67 COL 24.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Ativo", 1,
"Inativo", 2
          SIZE 18.29 BY .75
     it-exame.responsavel AT ROW 8 COL 20 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-responsavel AT ROW 8 COL 37.14 COLON-ALIGNED NO-LABEL
     l-severa AT ROW 9.46 COL 21.57
     l-pref-bom AT ROW 9.46 COL 52.86
     l-normal AT ROW 10.46 COL 21.57
     l-pref-oti AT ROW 10.46 COL 52.86
     l-atenuada AT ROW 11.46 COL 21.57
     l-pref-exc AT ROW 11.46 COL 52.86
     bt-narrativa AT ROW 12.75 COL 1.43
     FILL-IN-32 AT ROW 5.75 COL 21.72 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
     RECT-1 AT ROW 5.83 COL 22
     RECT-10 AT ROW 9.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.it-exame
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 12.88
         WIDTH              = 88.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-responsavel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-exame.cod-exame IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN it-exame.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN FILL-IN-32 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-atenuada IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-normal IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-pref-bom IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-pref-exc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-pref-oti IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR TOGGLE-BOX l-severa IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-narrativa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-narrativa V-table-Win
ON CHOOSE OF bt-narrativa IN FRAME f-main /* Narrativa */
DO:
    FIND FIRST exame NO-LOCK
         WHERE exame.cod-exame = INPUT FRAME {&FRAME-NAME} it-exame.cod-exame NO-ERROR.
    IF AVAILABLE exame THEN DO:
          run cqp/cq9016.w (INPUT-OUTPUT c-texto-exame,
                            OUTPUT l-cancela).
    END.
    ELSE DO:
        {utp/ut-table.i mgind exame 1}
        RUN utp/ut-msgs.p (INPUT "show", INPUT 47, INPUT RETURN-VALUE).
        APPLY 'ENTRY' TO  it-exame.cod-exame IN FRAME {&FRAME-NAME}.
        RETURN 'ADM-ERROR'.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-exame.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-exame.cod-exame V-table-Win
ON F5 OF it-exame.cod-exame IN FRAME f-main /* Exame */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom=inzoom/z01in114.w
                  &tabela=it-exame  
                  &atributo=cod-exame}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-exame.cod-exame V-table-Win
ON LEAVE OF it-exame.cod-exame IN FRAME f-main /* Exame */
DO:
  {include/leave.i &tabela=exame
                   &atributo-ref=descricao
                   &variavel-ref=it-exame.descricao
                   &where="exame.cod-exame = INPUT FRAME {&FRAME-NAME} it-exame.cod-exame AND exame.cdn-sit-vers = 2"}

  if  avail exame then do:
      assign it-exame.frequencia:screen-value  in frame {&FRAME-NAME} = string(exame.frequencia)
             it-exame.situacao:screen-value    in frame {&FRAME-NAME} = string(exame.situacao)
             it-exame.responsavel:screen-value in frame {&FRAME-NAME} = string(exame.cod-resp).
      RUN pi-inicializa-texto IN this-procedure (INPUT yes).
  end.
  else
      assign it-exame.frequencia:screen-value  in frame {&FRAME-NAME} = string(0)
             it-exame.responsavel:screen-value in frame {&FRAME-NAME} = string(0)
             c-texto-exame = ''.

  /* find item no-lock where rowid(item) = v-row-parent no-error. */

  if  avail item then
      assign it-exame.perc-nqa:screen-value in frame {&FRAME-NAME} = string(item.perc-nqa)
             it-exame.nivel:screen-value    in frame {&FRAME-NAME} = string(item.nivel).
  else
      assign it-exame.perc-nqa:screen-value in frame {&FRAME-NAME} = string(0)
             it-exame.nivel:screen-value    in frame {&FRAME-NAME} = string(0).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-exame.cod-exame V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-exame.cod-exame IN FRAME f-main /* Exame */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME it-exame.responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-exame.responsavel V-table-Win
ON F5 OF it-exame.responsavel IN FRAME f-main /* Responsÿvel */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=inzoom/z01in391.w
                     &campo=it-exame.responsavel
                     &campozoom=cod-resp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-exame.responsavel V-table-Win
ON LEAVE OF it-exame.responsavel IN FRAME f-main /* Responsÿvel */
DO:
  {include/leave.i &tabela=responsavel
                   &atributo-ref=nome-resp
                   &variavel-ref=c-responsavel
                   &where="responsavel.cod-resp = input frame {&FRAME-NAME} it-exame.responsavel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-exame.responsavel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF it-exame.responsavel IN FRAME f-main /* Responsÿvel */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  assign l-severa:label   in frame {&frame-name} = {ininc/i01in115.i 04 1}
         l-normal:label   in frame {&frame-name} = {ininc/i01in115.i 04 2}
         l-atenuada:label in frame {&frame-name} = {ininc/i01in115.i 04 3}
         l-pref-bom:label in frame {&frame-name} = {ininc/i01in115.i 04 4}
         l-pref-oti:label in frame {&frame-name} = {ininc/i01in115.i 04 5}
         l-pref-exc:label in frame {&frame-name} = {ininc/i01in115.i 04 6}.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
      RUN dispatch IN THIS-PROCEDURE ('initialize':U).
  &ENDIF         

  {utp/ut-rtlbl.i mgind it-exame situacao fill-in-32}

  if it-exame.responsavel:load-mouse-pointer ("image~\lupa.cur") in frame {&FRAME-NAME} then.
  if it-exame.cod-exame:load-mouse-pointer ("image~\lupa.cur") in frame {&FRAME-NAME} then.

 /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "it-exame"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-exame"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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
  assign l-severa:checked   in frame {&frame-name} = yes
         l-normal:checked   in frame {&frame-name} = yes
         l-atenuada:checked in frame {&frame-name} = yes
         l-pref-bom:checked in frame {&frame-name} = yes
         l-pref-oti:checked in frame {&frame-name} = yes
         l-pref-exc:checked in frame {&frame-name} = yes.
    
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .
  
  {utp/ut-rtlbl.i mgind it-exame situacao fill-in-32}
  
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
      
  /* Ponha aqui a valida»’o de chave duplicada */
  
  /* find item no-lock where rowid(item) = v-row-parent no-error.  */
  if adm-new-record = yes then do:
      FIND FIRST exame NO-LOCK
           WHERE exame.cod-exame = INPUT FRAME {&FRAME-NAME} it-exame.cod-exame 
             AND exame.cdn-sit-vers = 2 /* Liberado */ NO-ERROR.
           
      IF AVAILABLE exame THEN DO:
          IF it-exame.cod-exame:SENSITIVE IN FRAME {&FRAME-NAME} = YES
          AND CAN-FIND(FIRST b-it-exame
                       WHERE b-it-exame.it-codigo = item.it-codigo
                         AND b-it-exame.cod-exame = INPUT FRAME {&FRAME-NAME} it-exame.cod-exame) THEN DO:
      
              {utp/ut-table.i mgind it-exame 1}
              run utp/ut-msgs.p (INPUT "SHOW":U, 
                                 INPUT 1, /* ja existe ocorrência &1 informada */
                                 INPUT RETURN-VALUE).
              APPLY 'ENTRY' TO it-exame.cod-exame IN FRAME {&FRAME-NAME}.
              RETURN 'ADM-ERROR'.
          END.
      END.
      ELSE DO:
          RUN utp/ut-msgs.p (INPUT "SHOW", 
                             INPUT 55445, /*  Exame não possui versão liberada!*/
                             INPUT ""). 
          APPLY 'ENTRY' TO it-exame.cod-exame IN FRAME {&FRAME-NAME}.
          RETURN 'adm-error'.
      END.
   END.

  /* Ponha aqui as demais valida»„es */

  if  exame.amostragem = yes
  and exame.homogeneo  = no  then do:
      if not can-find(first nivel-insp where 
         nivel-insp.nivel = input frame {&FRAME-NAME} it-exame.nivel no-lock) then do:
          {utp/ut-table.i mgind nivel-insp 1}
          run utp/ut-msgs.p (input "show", input 47, input return-value).
          apply 'entry' to  it-exame.nivel in frame {&FRAME-NAME}.
          return 'adm-error'.
      end.
  end.

  if  l-severa:checked   in frame {&FRAME-NAME} = no
  and l-normal:checked   in frame {&FRAME-NAME} = no
  and l-atenuada:checked in frame {&FRAME-NAME} = no
  and l-pref-bom:checked in frame {&FRAME-NAME} = no
  and l-pref-oti:checked in frame {&FRAME-NAME} = no
  and l-pref-exc:checked in frame {&FRAME-NAME} = no then do:
      run utp/ut-msgs.p (input "show", input 191, input "").
      apply 'entry' to l-severa in frame {&FRAME-NAME}.
      return 'adm-error'.
  end.

  if not can-find(responsavel where 
     responsavel.cod-resp = input frame {&frame-name} it-exame.responsavel no-lock) then do:
      {utp/ut-table.i mgind responsavel 1}
      run utp/ut-msgs.p (input "show", input 47, input return-value).
      apply 'entry' to  it-exame.responsavel in frame {&FRAME-NAME}.
      return 'adm-error':U.
  end.

  /* Obs.: CASO A VALIDA°€O FALHE, DEVERæ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  ASSIGN it-exame.it-codigo = ITEM.it-codigo.

  /* Code placed here will execute AFTER standard behavior.    */
  
  /******************** In­cio Multi-Planta ********************/
  assign c-transacao = "MAT041".
  {cdp/cd7300.i5 "001" c-transacao}
  if  it-exame.cod-exame:sensitive in frame {&frame-name} = yes then
      assign i-tipo-movto = 1.
  else
      assign i-tipo-movto = 2.

  if  param-global.modulo-mp = yes and tt-replica-msg.log-replica-msg = yes then do:
      create tt-it-exame-aux.
      buffer-copy it-exame to tt-it-exame-aux
      assign tt-it-exame-aux.tp-insp-1 = input frame {&frame-name} l-severa
             tt-it-exame-aux.tp-insp-2 = input frame {&frame-name} l-normal
             tt-it-exame-aux.tp-insp-3 = input frame {&frame-name} l-atenuada
             tt-it-exame-aux.tp-insp-4 = input frame {&frame-name} l-pref-bom
             tt-it-exame-aux.tp-insp-5 = input frame {&frame-name} l-pref-oti
             tt-it-exame-aux.tp-insp-6 = input frame {&frame-name} l-pref-exc.

      create tt-dados-env.
      assign tt-dados-env.num-sequencia  = i-seq
             tt-dados-env.cod-tipo-reg   = 123
             tt-dados-env.ind-tipo-movto = i-tipo-movto
             tt-dados-env.identif-msg    = string(it-exame.cod-exame) + " , " + string(it-exame.it-codigo).

      raw-transfer tt-it-exame-aux to tt-dados-env.conteudo-msg.
      assign i-seq = i-seq + 1.

      {cdp/cd7300.i6 "001" c-transacao}
  end.
  /********************* Fim Multi-Planta **********************/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail item then 
      assign it-exame.it-codigo = item.it-codigo.

  if  avail exame then 
      assign it-exame.descricao = exame.descricao.

  /* Grava»’o do exame-tex */
  find tex-exame
      where tex-exame.cod-exame = it-exame.cod-exame
      and   tex-exame.it-codigo = it-exame.it-codigo EXCLUSIVE-LOCK no-error.
  if  not avail tex-exame then do:
      create tex-exame.
      assign tex-exame.cod-exame  = it-exame.cod-exame
             tex-exame.it-codigo  = it-exame.it-codigo.
  end.
  assign tex-exame.linha-desc = c-texto-exame.

  /* Atualiza»’o do exame-insp */
  RUN pi-atualiza-exame-insp (input it-exame.it-codigo,
                              input it-exame.cod-exame,
                              input 1,
                              input l-severa:checked in frame {&FRAME-NAME}).

  RUN pi-atualiza-exame-insp (input it-exame.it-codigo,
                              input it-exame.cod-exame,
                              input 2,
                              input l-normal:checked in frame {&FRAME-NAME}).

  RUN pi-atualiza-exame-insp (input it-exame.it-codigo,
                              input it-exame.cod-exame,
                              input 3,
                              input l-atenuada:checked in frame {&FRAME-NAME}).

  RUN pi-atualiza-exame-insp (input it-exame.it-codigo,
                              input it-exame.cod-exame,
                              input 4,
                              input l-pref-bom:checked in frame {&FRAME-NAME}).

  RUN pi-atualiza-exame-insp (input it-exame.it-codigo,
                              input it-exame.cod-exame,
                              input 5,
                              input l-pref-oti:checked in frame {&FRAME-NAME}).

  RUN pi-atualiza-exame-insp (input it-exame.it-codigo,
                              input it-exame.cod-exame,
                              input 6,
                              input l-pref-exc:checked in frame {&FRAME-NAME}).
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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail it-exame then do:
      for first responsavel fields(cod-resp nome-resp)
           where responsavel.cod-resp = it-exame.responsavel no-lock: end.
      assign c-responsavel = if avail responsavel
                                then responsavel.nome-resp else "":U.
                                
      disp c-responsavel with frame {&frame-name}.                                     
      FIND FIRST exame NO-LOCK
           WHERE exame.cod-exame = it-exame.cod-exame 
             AND exame.cdn-sit-vers = 2 /* Liberado */ NO-ERROR.
      assign it-exame.descricao:screen-value in frame {&FRAME-NAME} =
             if avail exame then exame.descricao else "":U.

      for each exame-insp fields(it-codigo cod-exame tp-inspecao)
          where exame-insp.it-codigo = it-exame.it-codigo
          and   exame-insp.cod-exame = it-exame.cod-exame NO-LOCK:
          
            ASSIGN l-severa:CHECKED   IN FRAME {&FRAME-NAME} = exame-insp.tp-inspecao = 1
                   l-normal:CHECKED   IN FRAME {&FRAME-NAME} = exame-insp.tp-inspecao = 2
                   l-atenuada:CHECKED IN FRAME {&FRAME-NAME} = exame-insp.tp-inspecao = 3
                   l-pref-bom:CHECKED IN FRAME {&FRAME-NAME} = exame-insp.tp-inspecao = 4
                   l-pref-oti:CHECKED IN FRAME {&FRAME-NAME} = exame-insp.tp-inspecao = 5
                   l-pref-exc:CHECKED IN FRAME {&FRAME-NAME} = exame-insp.tp-inspecao = 6.
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  run get-attribute ('adm-new-record').
  if return-value = 'no' then do:
     RUN pi-inicializa-texto  (INPUT no).
  end.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  find item no-lock where rowid(item) = v-row-parent no-error.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-exame-insp V-table-Win 
PROCEDURE pi-atualiza-exame-insp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter c-it-codigo   as character no-undo.
  def input parameter i-cod-exame   as integer   no-undo.
  def input parameter i-tp-inspecao as integer   no-undo.
  def input parameter l-checked     as logical   no-undo.

  find exame-insp
      where exame-insp.it-codigo   = c-it-codigo
      and   exame-insp.cod-exame   = i-cod-exame
      and   exame-insp.tp-inspecao = i-tp-inspecao EXCLUSIVE-LOCK no-error.
  if  avail exame-insp then do:
      if  l-checked = no then delete exame-insp.
  end.
  else do:
      if  l-checked = yes then do:
          create exame-insp.
          assign exame-insp.cod-exame   = i-cod-exame
                 exame-insp.it-codigo   = c-it-codigo
                 exame-insp.tp-inspecao = i-tp-inspecao.
      end.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-texto V-table-Win 
PROCEDURE pi-inicializa-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter l-inclui as logical no-undo.
  
  if  l-inclui = no then do:
      for first tex-exame fields(cod-exame it-codigo linha-desc)
          where tex-exame.cod-exame = it-exame.cod-exame
          and   tex-exame.it-codigo = it-exame.it-codigo
          no-lock: end.
      if  avail tex-exame then
          assign c-texto-exame = tex-exame.linha-desc.
      else
          assign c-texto-exame = ''.

      for each exame-insp fields(it-codigo cod-exame tp-inspecao)
          where exame-insp.it-codigo = it-exame.it-codigo
          and   exame-insp.cod-exame = it-exame.cod-exame NO-LOCK:

          CASE exame-insp.tp-inspecao:
              WHEN 1 THEN assign l-severa:checked   in frame {&FRAME-NAME} = yes.
              WHEN 2 THEN assign l-normal:checked   in frame {&FRAME-NAME} = yes.
              WHEN 3 THEN assign l-atenuada:checked in frame {&FRAME-NAME} = yes.
              WHEN 4 THEN assign l-pref-bom:checked in frame {&FRAME-NAME} = yes.
              WHEN 5 THEN assign l-pref-oti:checked in frame {&FRAME-NAME} = yes.
              WHEN 6 THEN assign l-pref-exc:checked in frame {&FRAME-NAME} = yes.
          END CASE.
      end.
  end.  
  else do:
    
      for first exame-tex fields(cod-exame linha-desc)
          where exame-tex.cod-exame  = input frame {&FRAME-NAME} it-exame.cod-exame
            AND exame-tex.cdn-versao = exame.cdn-versao NO-LOCK: END. /* Exame posicionado no leave do campo (Só entra se estiver avail)*/
      if  avail exame-tex then
          assign c-texto-exame = exame-tex.linha-desc.
      else
          assign c-texto-exame = ''.
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Salvar_Chave V-table-Win 
PROCEDURE Salvar_Chave :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if  avail it-exame then
        assign it-exame.it-codigo = ITEM.it-codigo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "it-exame"}

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


