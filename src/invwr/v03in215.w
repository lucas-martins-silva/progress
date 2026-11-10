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
{include/i-prgvrs.i V03IN215 2.00.00.022} /*** "010022" 03/02/2026 16:21:58 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN215 MUT}
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

/* global variable definitions */

def new global shared var v-row-parent as rowid  no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-nome like mi-taref.descricao no-undo.

/* Vari vel definida para utliza‡Æo de thinZooms */
def var hProgramZoom    as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES mi-taref
&Scoped-define FIRST-EXTERNAL-TABLE mi-taref


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mi-taref.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS mi-taref.aceite mi-taref.possui-checklist 
&Scoped-define ENABLED-TABLES mi-taref
&Scoped-define FIRST-ENABLED-TABLE mi-taref
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-4 i-fi-codigo de-tempo ~
l-exec-simul l-tar-obrigatoria i-cd-turno fiTexto 
&Scoped-Define DISPLAYED-FIELDS mi-taref.aceite mi-taref.nome-abrev ~
mi-taref.possui-checklist mi-taref.codigo-checklist 
&Scoped-define DISPLAYED-TABLES mi-taref
&Scoped-define FIRST-DISPLAYED-TABLE mi-taref
&Scoped-Define DISPLAYED-OBJECTS i-fi-codigo c-desc-ficha c-desc-nome ~
de-tempo l-exec-simul l-tar-obrigatoria c-desc-checklist i-cd-turno ~
c-desc-turno fiTexto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS mi-taref.nome-abrev de-tempo l-exec-simul ~
l-tar-obrigatoria mi-taref.possui-checklist mi-taref.codigo-checklist ~
i-cd-turno 
&Scoped-define ADM-MODIFY-FIELDS mi-taref.nome-abrev ~
mi-taref.codigo-checklist 

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
DEFINE VARIABLE c-desc-checklist AS CHARACTER FORMAT "X(200)":U 
     VIEW-AS FILL-IN 
     SIZE 63.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-ficha AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 49.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-nome AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 40.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-turno AS CHARACTER FORMAT "X(45)":U 
     VIEW-AS FILL-IN 
     SIZE 53.57 BY .88 NO-UNDO.

DEFINE VARIABLE de-tempo AS DECIMAL FORMAT "->>>>>,>>9.9999" INITIAL 0 
     LABEL "Tempo Total":R12 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88.

DEFINE VARIABLE fiTexto AS CHARACTER FORMAT "X(256)":U INITIAL "Checklist" 
      VIEW-AS TEXT 
     SIZE 10 BY .67
     FONT 1 NO-UNDO.

DEFINE VARIABLE i-cd-turno AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Turno" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE i-fi-codigo AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Ficha M‚todo":R15 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84 BY 2.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 11.

DEFINE VARIABLE l-exec-simul AS LOGICAL INITIAL yes 
     LABEL "Execu‡Æo Simultƒnea" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.57 BY .83.

DEFINE VARIABLE l-tar-obrigatoria AS LOGICAL INITIAL no 
     LABEL "Tarefa Obrigat¢ria" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.29 BY .83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-fi-codigo AT ROW 1.5 COL 22 COLON-ALIGNED
     c-desc-ficha AT ROW 1.5 COL 31.14 COLON-ALIGNED NO-LABEL
     mi-taref.aceite AT ROW 2.58 COL 24
          VIEW-AS TOGGLE-BOX
          SIZE 10.43 BY .75
     mi-taref.nome-abrev AT ROW 3.5 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-desc-nome AT ROW 3.5 COL 40.29 COLON-ALIGNED NO-LABEL
     de-tempo AT ROW 4.5 COL 22 COLON-ALIGNED HELP
          "Tempo Total para execu‡Æo da Tarefa em Horas"
     l-exec-simul AT ROW 5.5 COL 24 HELP
          "Especialidades da tarefa trabalham juntas"
     l-tar-obrigatoria AT ROW 6.5 COL 24 HELP
          "Tarefa Obrigat¢ria"
     mi-taref.possui-checklist AT ROW 8.13 COL 5.72 WIDGET-ID 4
          VIEW-AS TOGGLE-BOX
          SIZE 20.29 BY .83
     mi-taref.codigo-checklist AT ROW 9.13 COL 8.14 COLON-ALIGNED WIDGET-ID 2
          LABEL "Checklist"
          FORMAT "x(9)"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-desc-checklist AT ROW 9.13 COL 19.43 COLON-ALIGNED NO-LABEL WIDGET-ID 22
     i-cd-turno AT ROW 10.63 COL 22 COLON-ALIGNED HELP
          "C¢digo do Turno"
     c-desc-turno AT ROW 10.63 COL 26.72 COLON-ALIGNED NO-LABEL
     fiTexto AT ROW 7.33 COL 4 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     rt-mold AT ROW 1 COL 1
     RECT-4 AT ROW 7.67 COL 2 WIDGET-ID 6
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.mi-taref
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 11.04
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-checklist IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-ficha IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-ficha:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-nome IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-turno IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-desc-turno:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN de-tempo IN FRAME f-main
   2                                                                    */
ASSIGN 
       de-tempo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN i-cd-turno IN FRAME f-main
   2                                                                    */
ASSIGN 
       i-cd-turno:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       i-fi-codigo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN mi-taref.codigo-checklist IN FRAME f-main
   NO-ENABLE 2 3 EXP-FORMAT                                             */
/* SETTINGS FOR TOGGLE-BOX l-exec-simul IN FRAME f-main
   2                                                                    */
ASSIGN 
       l-exec-simul:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX l-tar-obrigatoria IN FRAME f-main
   2                                                                    */
ASSIGN 
       l-tar-obrigatoria:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN mi-taref.nome-abrev IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR TOGGLE-BOX mi-taref.possui-checklist IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME mi-taref.aceite
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.aceite V-table-Win
ON VALUE-CHANGED OF mi-taref.aceite IN FRAME f-main /* Aceite */
DO:
  if  input frame {&frame-name} mi-taref.aceite = yes then 
      enable mi-taref.nome-abrev with frame {&frame-name}.
  else do:
      disable mi-taref.nome-abrev with frame {&frame-name}.  
      assign mi-taref.nome-abrev:screen-value in frame {&frame-name} = ""
             c-desc-nome:screen-value         in frame {&frame-name} = "" .
  end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cd-turno
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-turno V-table-Win
ON F5 OF i-cd-turno IN FRAME f-main /* Turno */
DO:
  &if defined (bf_mnt_ems203)  &then 
      {method/ZoomFields.i 
           &ProgramZoom="mnzoom/z02mn015.w"
           &FieldZoom1="cd-turno"
           &FieldScreen1="i-cd-turno"
           &Frame1="{&frame-name}"
           &FieldZoom2="descricao"
           &FieldScreen2="c-desc-turno"
           &Frame2="{&frame-name}"
           &EnableImplant="YES"}
  &endif    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-turno V-table-Win
ON LEAVE OF i-cd-turno IN FRAME f-main /* Turno */
DO:
  &if defined (bf_mnt_ems203)  &then 
         {include/leave.i &tabela=mi-turno
                        &atributo-ref=descricao
                        &variavel-ref=c-desc-turno
                        &where="mi-turno.cd-turno = input frame {&frame-name} i-cd-turno"}
   &endif     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cd-turno V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cd-turno IN FRAME f-main /* Turno */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-fi-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fi-codigo V-table-Win
ON F5 OF i-fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
   assign l-implanta = yes.  /* para o botao implanta do Zoom */
   &if defined (bf_mnt_ems203) &then
      {method/ZoomFields.i 
           &ProgramZoom="mnzoom\z01mn049.w"
           &FieldZoom1="fi-codigo"
           &FieldScreen1="i-fi-codigo"
           &Frame1="f-main"
           &FieldZoom2="descricao"
           &FieldScreen2="c-desc-ficha"
           &Frame2="f-main"}
   &else
      {include/zoomvar.i &prog-zoom="inzoom/z01in125.w"
                         &campo="i-fi-codigo"
                         &campozoom="fi-codigo"
                         &frame="f-main"
                         &campo2="c-desc-ficha"
                         &campozoom2="descricao"
                         &frame2="f-main"}
   &endif                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fi-codigo V-table-Win
ON LEAVE OF i-fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
  &if defined (bf_mnt_ems203) &then
     {include/leave.i &tabela=mnt-ficha-metodo
                      &atributo-ref=descricao
                      &variavel-ref=c-desc-ficha
                      &where="mnt-ficha-metodo.fi-codigo = input frame {&frame-name} 
                                                   i-fi-codigo"}
  &else
     {include/leave.i &tabela=ficha-metodo
                      &atributo-ref=descricao
                      &variavel-ref=c-desc-ficha
                      &where="ficha-metodo.fi-codigo = input frame {&frame-name} 
                                                       i-fi-codigo"}
  &endif                                                   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-fi-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-fi-codigo IN FRAME f-main /* Ficha M‚todo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-taref.codigo-checklist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.codigo-checklist V-table-Win
ON F5 OF mi-taref.codigo-checklist IN FRAME f-main /* Checklist */
DO:
    {method/zoomfields.i 
       &ProgramZoom="mnzoom/z01mn00321.w"
       &FieldZoom1="codigo"
       &FieldScreen1="mi-taref.codigo-checklist"
       &Frame1="f-main"
       &FieldZoom2="descricao"
       &FieldScreen2="c-desc-checklist"
       &Frame2="f-main"
       &EnableImplant="NO"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.codigo-checklist V-table-Win
ON LEAVE OF mi-taref.codigo-checklist IN FRAME f-main /* Checklist */
DO:

    FOR EACH checklist-modelos NO-LOCK
       WHERE checklist-modelos.codigo = input frame {&frame-name} mi-taref.codigo-checklist
          BY checklist-modelos.versao DESC:
          
          ASSIGN c-desc-checklist:SCREEN-VALUE IN frame {&frame-name} = checklist-modelos.descricao.
          LEAVE.
    END.
          
    IF NOT AVAIL checklist-modelos THEN
        ASSIGN c-desc-checklist:SCREEN-VALUE IN frame {&frame-name} = "".                  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.codigo-checklist V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mi-taref.codigo-checklist IN FRAME f-main /* Checklist */
DO:
    APPLY 'F5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-taref.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.nome-abrev V-table-Win
ON F5 OF mi-taref.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:
assign l-implanta = yes. 

{include/zoomvar.i &prog-zoom=inzoom/z01in627.w
                   &campo=mi-taref.nome-abrev
                   &campozoom=cod-usuario}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.nome-abrev V-table-Win
ON LEAVE OF mi-taref.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:

{include/leave.i &tabela=usuar-mater
                 &atributo-ref=nome-usuar
                 &variavel-ref=c-desc-nome
                 &where="usuar-mater.cod-usuario = input frame {&frame-name}
                                                   mi-taref.nome-abrev"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF mi-taref.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:
    apply 'F5' to self.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-taref.possui-checklist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-taref.possui-checklist V-table-Win
ON VALUE-CHANGED OF mi-taref.possui-checklist IN FRAME f-main /* Possui Checklist */
DO:
    IF  INPUT FRAME {&frame-name} mi-taref.possui-checklist = YES THEN
        ENABLE mi-taref.codigo-checklist WITH FRAME {&frame-name}.
    ELSE DO:
        DISABLE mi-taref.codigo-checklist WITH FRAME {&frame-name}.
        ASSIGN mi-taref.codigo-checklist:SCREEN-VALUE IN FRAME {&frame-name} = ""
               c-desc-checklist:SCREEN-VALUE IN FRAME {&frame-name} = "".
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  find first param-mi no-lock no-error.
  find first param-global no-lock no-error.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  if  i-fi-codigo:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
  if  mi-taref.nome-abrev:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  IF  mi-taref.codigo-checklist:LOAD-MOUSE-POINTER ("image/lupa.cur") IN FRAME {&frame-name} THEN.

  &if defined (bf_mnt_ems203)  &then
  
      {utp/ut-field.i mgind mi-taref cd-turno 1}
      assign i-cd-turno:label in frame {&FRAME-NAME} = trim(return-value).
      
      {utp/ut-field.i mgind mi-taref tempo 1}
      assign de-tempo:label in frame {&FRAME-NAME} = trim(return-value).
  
      {utp/ut-field.i mgind mi-taref exec-simul 1}
      assign l-exec-simul:label in frame {&FRAME-NAME} = trim(return-value).

      {utp/ut-field.i mgind mi-taref tar-obrigatoria 1}
      assign l-tar-obrigatoria:label in frame {&FRAME-NAME} = trim(return-value).
      
      {utp/ut-field.i mgind mi-taref possui-checklist 1}
      assign mi-taref.possui-checklist:label in frame {&FRAME-NAME} = trim(return-value).

      if i-cd-turno:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
      
  &endif    

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
  {src/adm/template/row-list.i "mi-taref"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mi-taref"}

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if defined (bf_mnt_ems204)  &then          
  &else
     assign i-fi-codigo = 0
            i-fi-codigo:screen-value in frame {&FRAME-NAME} = "0".
     apply "leave":U to i-fi-codigo.
  &endif

  assign  l-tar-obrigatoria = no
          l-tar-obrigatoria:checked in frame {&FRAME-NAME} = no.
          
  &if defined (bf_mnt_ems203)  &then
     assign l-exec-simul = no
            l-exec-simul:checked in frame {&FRAME-NAME} = no
            de-tempo:screen-value in frame {&FRAME-NAME} = "0,0000".

    &if defined (bf_mnt_ems204)  &then          
    &else
     find first param-mi no-lock no-error.
     if avail param-mi then
        assign i-cd-turno = param-mi.cd-turno
               i-cd-turno:screen-value in frame {&FRAME-NAME} = string(i-cd-turno).       
     apply "leave":U to i-cd-turno.          
    &endif /* 2.04 */ 
  &endif          

  if  avail mi-taref and mi-taref.aceite = yes then 
      enable mi-taref.nome-abrev with frame {&frame-name}.
  else do with frame {&frame-name}:
      disable mi-taref.nome-abrev with frame {&frame-name}.  
      assign mi-taref.nome-abrev:screen-value in frame {&frame-name} = ""
             c-desc-nome:screen-value         in frame {&frame-name} = "" .
  end.     
        
  DO WITH FRAME {&frame-name}:
      DISABLE mi-taref.codigo-checklist WITH FRAME {&frame-name}.
      ASSIGN mi-taref.codigo-checklist:SCREEN-VALUE IN FRAME {&frame-name} = ""
             c-desc-checklist:SCREEN-VALUE             IN FRAME {&frame-name} = "".
  END.     

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
  
  &if defined (bf_mnt_ems204)  &then
  &else
      assign input frame {&FRAME-NAME} i-fi-codigo.
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  
  &if defined (bf_mnt_ems204)  &then
  &else
      assign mi-taref.fi-codigo = input frame {&FRAME-NAME} i-fi-codigo.
  &endif
  
  &if defined (bf_mnt_ems203)  &then 
     if avail mi-taref then do:
        assign mi-taref.exec-simul      = input frame {&FRAME-NAME} l-exec-simul
               mi-taref.tempo           = input frame {&FRAME-NAME} de-tempo 
               mi-taref.tar-obrigatoria = input frame {&FRAME-NAME} l-tar-obrigatoria.
        &if defined (bf_mnt_ems204)  &then
        &else 
           assign mi-taref.cd-turno        = input frame {&FRAME-NAME} i-cd-turno.       
        &endif   
     end.          
  &endif   
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
  
  if avail mi-taref then do:
     find first usuar-mater where
          usuar-mater.cod-usuario = mi-taref.nome-abrev no-lock no-error.
     assign c-desc-nome = if avail usuar-mater then usuar-mater.nome-usuar else "":U.
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
           
  /* Code placed here will execute AFTER standard behavior.    */
  
  &if defined (bf_mnt_ems204)  &then
  &else
     apply "leave":U to i-fi-codigo in frame {&FRAME-NAME}.
     &if defined (bf_mnt_ems203)  &then
        apply "leave":U to i-cd-turno in frame {&FRAME-NAME}. 
     &endif   
  &endif 

  if  avail mi-taref then do:
      apply "leave":U to mi-taref.codigo-checklist in frame {&FRAME-NAME}.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
if  input frame {&frame-name} mi-taref.aceite = no then do :
    disable mi-taref.nome-abrev with frame {&frame-name}.  
    assign mi-taref.nome-abrev:screen-value in frame {&frame-name} = ""
           c-desc-nome:screen-value         in frame {&frame-name} = "" .
end. 
else 
    enable mi-taref.nome-abrev with frame {&frame-name}.

if  input frame {&frame-name} mi-taref.possui-checklist = no then do :
    disable mi-taref.codigo-checklist with frame {&frame-name}.  
    assign mi-taref.codigo-checklist:screen-value in frame {&frame-name} = ""
           c-desc-checklist:screen-value         in frame {&frame-name} = "" .
end. 
else 
    enable mi-taref.codigo-checklist with frame {&frame-name}.
    
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
  &if defined (bf_mnt_ems204)  &then
  &else
      assign i-fi-codigo:hidden   in frame {&FRAME-NAME} = no
             c-desc-ficha:hidden  in frame {&FRAME-NAME} = no.
  &endif
  
  &if defined (bf_mnt_ems203)  &then
     assign de-tempo:hidden     in frame {&FRAME-NAME}      = no
            l-exec-simul:hidden in frame {&FRAME-NAME}      = no
            l-tar-obrigatoria:hidden in frame {&FRAME-NAME} = no.
     &if defined (bf_mnt_ems204)  &then
     &else       
        assign i-cd-turno:hidden   in frame {&FRAME-NAME}      = no
               c-desc-turno:hidden in frame {&FRAME-NAME}      = no.
     &endif               
  &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  
  if avail mi-taref then do:
     &if defined (bf_mnt_ems204) &then
     &else
         assign i-fi-codigo = mi-taref.fi-codigo.
     &endif

     &if defined (bf_mnt_ems203)  &then
         assign l-tar-obrigatoria = mi-taref.tar-obrigatoria
                l-exec-simul      = mi-taref.exec-simul
                de-tempo          = mi-taref.tempo.
         &if defined (bf_mnt_ems204)  &then
         &else
            assign i-cd-turno = mi-taref.cd-turno.
         &endif 
     &endif
     RUN dispatch IN THIS-PROCEDURE ('display-fields':U).
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
   
  if input frame {&frame-name} mi-taref.nome-abrev <> "":U then do:
     find usuar-mater where
          usuar-mater.cod-usuario = input frame {&frame-name} mi-taref.nome-abrev
          no-lock no-error.
     if  not avail usuar-mater then do:
         {include/i-vldprg.i}
         {utp/ut-field.i mgind mi-taref nome-abrev 1}
         run utp/ut-msgs.p (input "show",
                            input 2,
                            input return-value).
         return 'ADM-ERROR':U.         
     end.
  end.
 
  &if defined (bf_mnt_ems204)  &then
  &else
     &if defined (bf_mnt_ems203)  &then  
        if not can-find (first mi-turno where mi-turno.cd-turno = 
                         input frame {&FRAME-NAME} i-cd-turno) then do:
           {include/i-vldprg.i}
           {utp/ut-table.i mgind mi-turno 1} 
           RUN utp/ut-msgs.p (input "show",
                              input 2,
                              input trim(return-value)).
           apply "entry" to i-cd-turno in frame {&frame-name}.
           RETURN 'ADM-ERROR':U.
        end.
        
        if input frame {&FRAME-NAME} i-fi-codigo <> 0 and
           not can-find (first mnt-ficha-metodo where mnt-ficha-metodo.fi-codigo = 
                         input frame {&FRAME-NAME} i-fi-codigo) then do:
           {include/i-vldprg.i}
           {utp/ut-table.i mgind mnt-ficha-metodo 1} 
           RUN utp/ut-msgs.p (input "show",
                              input 2,
                              input trim(return-value)).
           apply "entry" to i-fi-codigo in frame {&frame-name}.
           RETURN 'ADM-ERROR':U.
        end.   
     &endif 
  &endif
  
 /*Checklist*/
  IF  INPUT FRAME {&frame-name} mi-taref.possui-checklist = YES THEN DO:
      IF  NOT CAN-FIND (FIRST checklist-modelos WHERE checklist-modelos.codigo = INPUT FRAME {&frame-name} mi-taref.codigo-checklist) THEN DO: 
          {utp/ut-liter.i "CheckList"}
          {include/i-vldprg.i}
          RUN utp/ut-msgs.p (INPUT "show",
                             INPUT 2,
                             INPUT RETURN-VALUE).
          APPLY 'entry' TO  mi-taref.codigo-checklist in frame {&frame-name}.
          RETURN 'ADM-ERROR'.
      END.
  END.

  
 
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
  {src/adm/template/snd-list.i "mi-taref"}

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


