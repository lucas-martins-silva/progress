&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/*********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V17AD107 2.00.00.058 } /*** "010058" 19/06/2026 10:57:51 ***/
{cep/ce0101.i2}  /* Verifica Paramento Estoque Agrupa Estabelecimento Por Empresa */


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v17ad107 MUT}
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

def new global shared var v-row-parent as rowid no-undo.

def var c-verifica-cgc as char format "x(20)" no-undo.
def var c-insc         as char format "x(19)" no-undo.
def var c-formato-cgc  as char                no-undo.
def var i-dig-ver      as integer             no-undo.
DEF VAR c-cod-estabel  AS CHAR                NO-UNDO.                                             
DEF VAR c-cnpj         AS CHAR                NO-UNDO.

def var i-ep-codigo-orig like estabelec.ep-codigo no-undo.

def var oTipoEnteGovernamentalList  as cdp.list.TipoEnteGovernamentalList   no-undo.
def var c-lbl-tip-ente-gov          as char                                 no-undo.

def var c-handle  as character no-undo.
def var wh-cd0602 as handle    no-undo.

DEF VAR h-boco2008 AS HANDLE NO-UNDO.
DEF VAR h-boco2001 AS HANDLE NO-UNDO.


def buffer b-estabelec for estabelec.

{cdp/cd9900.i1}

/* Pre-Processadores Materiais */
{cdp/cdcfgmat.i}

def var c-emitente-ant like estabelec.cod-emitente no-undo.
def var l-alterou as logical init no.

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estabelec.ep-codigo estabelec.cgc ~
estabelec.ins-estadual estabelec.cod-emitente 
&Scoped-define ENABLED-TABLES estabelec
&Scoped-define FIRST-ENABLED-TABLE estabelec
&Scoped-Define ENABLED-OBJECTS RECT-5 rt-key RECT-6 RECT-7 tg-depos-fechado ~
lbl-tip-ente-gov 
&Scoped-Define DISPLAYED-FIELDS estabelec.ep-codigo estabelec.cgc ~
estabelec.ins-estadual estabelec.cod-emitente 
&Scoped-define DISPLAYED-TABLES estabelec
&Scoped-define FIRST-DISPLAYED-TABLE estabelec
&Scoped-Define DISPLAYED-OBJECTS c-empresa c-emitente tg-depos-fechado ~
rs-trib-pis idi-tip-ente-gov c-cod-atividade c-desc-atividade ~
lbl-tip-ente-gov 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS estabelec.ins-estadual 
&Scoped-define ADM-ASSIGN-FIELDS estabelec.ins-estadual rs-trib-pis 
&Scoped-define ADM-MODIFY-FIELDS estabelec.ins-estadual 

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
DEFINE VARIABLE idi-tip-ente-gov AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo ente" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 25 BY 1 NO-UNDO.

DEFINE VARIABLE c-cod-atividade AS INTEGER FORMAT ">>>>":U INITIAL 0 
     LABEL "Cod Atividade" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-atividade AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 21.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-empresa AS CHARACTER FORMAT "x(12)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE lbl-tip-ente-gov AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 16.57 BY .67 NO-UNDO.

DEFINE VARIABLE rs-trib-pis AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Tributado", 1,
"Isento", 2
     SIZE 14.86 BY 1.67 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28 BY 3.13.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.29 BY 1.13.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38.43 BY 1.54.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86.14 BY 9.75.

DEFINE VARIABLE tg-depos-fechado AS LOGICAL INITIAL no 
     LABEL "Estabelecimento Dep¢sito Fechado" 
     VIEW-AS TOGGLE-BOX
     SIZE 36 BY .5 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estabelec.ep-codigo AT ROW 1.63 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     c-empresa AT ROW 1.63 COL 35.72 COLON-ALIGNED HELP
          "Nome Abreviado da Empresa" NO-LABEL
     estabelec.cgc AT ROW 2.63 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.14 BY .88
     estabelec.ins-estadual AT ROW 3.63 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.14 BY .88
     estabelec.cod-emitente AT ROW 4.63 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     c-emitente AT ROW 4.63 COL 42 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor" NO-LABEL
     tg-depos-fechado AT ROW 6.71 COL 45.57 HELP
          "Informa que o Estabelecimento ‚ um Dep¢sito Fechado" WIDGET-ID 6
     rs-trib-pis AT ROW 6.96 COL 17.72 NO-LABEL
     idi-tip-ente-gov AT ROW 8.25 COL 54 COLON-ALIGNED WIDGET-ID 12
     c-cod-atividade AT ROW 9.63 COL 31 COLON-ALIGNED
     c-desc-atividade AT ROW 9.63 COL 37.14 COLON-ALIGNED NO-LABEL
     lbl-tip-ente-gov AT ROW 7.54 COL 44 COLON-ALIGNED NO-LABEL WIDGET-ID 14
     "Tributa‡Æo PIS/COFINS" VIEW-AS TEXT
          SIZE 16.14 BY .67 AT ROW 6.04 COL 16.86
     "Dep¢sito Fechado" VIEW-AS TEXT
          SIZE 12.72 BY .67 AT ROW 6.04 COL 45.57 WIDGET-ID 4
     RECT-5 AT ROW 6.38 COL 15.57
     rt-key AT ROW 1 COL 1
     RECT-6 AT ROW 6.38 COL 44.29 WIDGET-ID 2
     RECT-7 AT ROW 7.92 COL 44.29 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 10.33
         WIDTH              = 87.14.
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

/* SETTINGS FOR FILL-IN c-cod-atividade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-atividade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-empresa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX idi-tip-ente-gov IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN estabelec.ins-estadual IN FRAME f-main
   1 2 3                                                                */
/* SETTINGS FOR RADIO-SET rs-trib-pis IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME c-cod-atividade
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-atividade V-table-Win
ON F5 OF c-cod-atividade IN FRAME f-main /* Cod Atividade */
DO:
  {include/zoomvar.i &prog-zoom="local/col/colz001.w" 
                     &campo=c-cod-atividade
                     &campozoom=cdn-actividad} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-atividade V-table-Win
ON LEAVE OF c-cod-atividade IN FRAME f-main /* Cod Atividade */
DO:
     IF i-pais-impto-usuario = 17 THEN DO: /*Colombia*/        
        RUN openQueryStatic IN h-boco2001 (INPUT "Main":U) NO-ERROR.
        
        RUN goToKey IN h-boco2001 (INPUT input frame {&frame-name} c-cod-atividade).
        
        IF RETURN-VALUE = "OK":U THEN
            RUN getCharField IN h-boco2001 (INPUT "des-actividad":U,
                                            OUTPUT c-desc-atividade).
        ELSE
            ASSIGN c-desc-atividade = "".
        
        DISP c-desc-atividade WITH FRAME {&FRAME-NAME}.       
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-atividade V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-atividade IN FRAME f-main /* Cod Atividade */
DO:
  APPLY "F5" TO c-cod-atividade IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cgc V-table-Win
ON ENDKEY OF estabelec.cgc IN FRAME f-main /* CGC */
DO:
if avail param-global then
  assign mgadm.estabelec.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cgc V-table-Win
ON ENTRY OF estabelec.cgc IN FRAME f-main /* CGC */
DO:
  if avail param-global and param-global.formato-id-federal <> " " then
     assign estabelec.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cgc V-table-Win
ON LEAVE OF estabelec.cgc IN FRAME f-main /* CGC */
DO:
        {cdp/cd9998.i}
    
    IF i-pais-impto-usuario = 1 THEN DO: /* Brasil */
       /* For‡ar letras para ma¡usculo */
       ASSIGN estabelec.cgc:SCREEN-VALUE = CAPS(estabelec.cgc:SCREEN-VALUE). 
    END.
    ELSE DO:
         
       assign c-formato-cgc = input frame {&FRAME-NAME} mgadm.estabelec.cgc no-error.
       if error-status:error /*error-status:get-number(1) <> 0*/ then
          assign mgadm.estabelec.cgc:format in frame {&FRAME-NAME} = "x(19)".
       else do:
          if avail param-global and param-global.formato-id-federal <> " " then
             assign estabelec.cgc:format in frame {&FRAME-NAME} = param-global.formato-id-federal.
       end.
        
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-emitente V-table-Win
ON ENTRY OF estabelec.cod-emitente IN FRAME f-main /* Fornecedor */
DO:
  assign c-emitente-ant = input frame {&frame-name} estabelec.cod-emitente.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-emitente V-table-Win
ON F5 OF estabelec.cod-emitente IN FRAME f-main /* Fornecedor */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom=adzoom/z01ad098.w
                     &campo=estabelec.cod-emitente
                     &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-emitente V-table-Win
ON LEAVE OF estabelec.cod-emitente IN FRAME f-main /* Fornecedor */
DO:
  {include/leave.i &tabela=emitente
                   &atributo-ref=nome-abrev
                   &variavel-ref=c-emitente
                   &where="emitente.cod-emitente = input frame {&frame-name}
                                                    estabelec.cod-emitente"}

if avail estabelec then 
    assign l-alterou = estabelec.cod-emitente <> input frame {&frame-name} estabelec.cod-emitente.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.cod-emitente V-table-Win
ON LEFT-MOUSE-DBLCLICK OF estabelec.cod-emitente IN FRAME f-main /* Fornecedor */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON ENTRY OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
    apply 'leave' to mgadm.estabelec.ep-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON F5 OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
  {include/zoomvar.i &prog-zoom=unzoom/z01un004.w
                     &campo=estabelec.ep-codigo
                     &campozoom=ep-codigo}


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON LEAVE OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
  {include/leave.i &tabela=empresa
                   &atributo-ref=nome
                   &variavel-ref=c-empresa
                   &where="empresa.ep-codigo = input frame {&frame-name}
                                                   estabelec.ep-codigo"}
  FOR FIRST empresa FIELDS(ep-codigo cgc) NO-LOCK 
      WHERE empresa.ep-codigo = input frame {&frame-name} estabelec.ep-codigo: END.
      

  IF AVAIL empresa THEN DO:
      IF estabelec.cgc:screen-value in frame {&frame-name} = "" THEN
          ASSIGN estabelec.cgc:screen-value in frame {&frame-name} = empresa.cgc.
  END.
  ELSE
      ASSIGN estabelec.cgc:screen-value in frame {&frame-name} = "".


  {cep/ce0101.i2}
  IF l-agr-estab-emp AND estabelec.ep-codigo <> estabelec.ep-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:
     
        run utp/ut-msgs.p (input "show", input 53954, input "").
      
  END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ep-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estabelec.ep-codigo IN FRAME f-main /* Empresa */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estabelec.ins-estadual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ins-estadual V-table-Win
ON ENDKEY OF estabelec.ins-estadual IN FRAME f-main /* Inscri‡Æo Estadual */
DO:
     assign estabelec.ins-estadual:format in frame {&frame-name} = "x(19)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ins-estadual V-table-Win
ON ENTRY OF estabelec.ins-estadual IN FRAME f-main /* Inscri‡Æo Estadual */
DO:
     assign estabelec.ins-estadual:format in frame {&frame-name} = "x(19)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estabelec.ins-estadual V-table-Win
ON LEAVE OF estabelec.ins-estadual IN FRAME f-main /* Inscri‡Æo Estadual */
DO:
  assign c-insc = input frame {&frame-name} estabelec.ins-estadual no-error.
  if error-status:error then
     assign estabelec.ins-estadual:format in frame {&frame-name} = "x(19)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if  estabelec.ep-codigo:load-mouse-pointer    ("image~\lupa.cur") in frame {&frame-name} then.
  if  estabelec.cod-emitente:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

  IF i-pais-impto-usuario = 17 THEN
    if  c-cod-atividade:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ).

  assign estabelec.ep-codigo:screen-value in frame {&frame-name} = string(param-global.empresa-prin).
  find empresa where empresa.ep-codigo = param-global.empresa-prin no-lock no-error.
  assign c-empresa:screen-value in frame {&frame-name} = if avail empresa then empresa.nome else "":U.

    if i-pais-impto-usuario = 1 then
        assign lbl-tip-ente-gov:screen-value in frame {&frame-name} = c-lbl-tip-ente-gov.
  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/
  def var c-idi-tip-ente-gov as char format 'x(1)' no-undo.
  DEFINE VARIABLE i-trib-pis AS INT NO-UNDO.
  ASSIGN i-trib-pis = INPUT FRAME {&FRAME-NAME} rs-trib-pis.
  {include/i-valid.i}

  IF i-pais-impto-usuario = 17 THEN DO: /*Colombia*/

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                  INPUT "cod-estabel":U).
    assign  c-cod-estabel   = RETURN-VALUE.

    RUN pi-atualiza-campos IN h-boco2008 (INPUT c-cod-estabel,
                                          INPUT INT(c-cod-atividade:SCREEN-VALUE IN FRAME {&FRAME-NAME})).

    IF RETURN-VALUE <> "OK":U THEN
        RETURN 'ADM-ERROR':U.

  END.
  
  assign c-idi-tip-ente-gov = IF i-pais-impto-usuario = 1 THEN idi-tip-ente-gov:screen-value in frame {&FRAME-NAME} ELSE ' '.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).

  IF  RETURN-VALUE = 'ADM-ERROR':U THEN
      RETURN 'ADM-ERROR':U.

  IF AVAIL estabelec THEN 
      ASSIGN estabelec.idi-tributac-cofins   = i-trib-pis
             OVERLAY(estabelec.char-1,396,1) = IF tg-depos-fechado:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
             OVERLAY(estabelec.char-1,397,1) = IF NOT tg-depos-fechado:CHECKED IN FRAME {&FRAME-NAME} THEN "N" ELSE SUBSTRING(estabelec.char-1,397,1)
             overlay(estabelec.char-1,400,1) = c-idi-tip-ente-gov.

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

  IF i-pais-impto-usuario = 17 THEN DO:
    IF VALID-HANDLE(h-boco2001) THEN
        RUN destroy IN h-boco2001.

    IF VALID-HANDLE(h-boco2008) THEN
        RUN destroy IN h-boco2008.
  END.

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

   ASSIGN rs-trib-pis:SENSITIVE IN FRAME {&FRAME-NAME} = NO
          tg-depos-fechado:SENSITIVE IN FRAME {&FRAME-NAME} = NO
          idi-tip-ente-gov:sensitive in frame {&frame-name} = no.

   IF i-pais-impto-usuario = 17 THEN
       ASSIGN c-cod-atividade:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.

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
/*  find empresa where empresa.ep-codigo = i-ep-codigo-usuario no-lock no-error.*/
def var c-char-1-400 as char format 'x(1)'  no-undo.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "cod-estabel":U).
  assign  c-cod-estabel   = RETURN-VALUE.

  if  avail estabelec then do:
      find  emitente
      where emitente.cod-emitente = estabelec.cod-emitente no-lock no-error.
            assign c-emitente = if avail emitente then emitente.nome-abrev else "":U.        
  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).

  IF  AVAIL estabelec THEN
      ASSIGN rs-trib-pis = estabelec.idi-tributac-cofins
             tg-depos-fechado:CHECKED IN FRAME {&frame-name} = IF SUBSTRING(estabelec.char-1,396,1) = "S" THEN YES ELSE NO.  
   

    if i-pais-impto-usuario = 1 then do:

        assign lbl-tip-ente-gov:screen-value in frame {&frame-name} = c-lbl-tip-ente-gov
               idi-tip-ente-gov:screen-value in frame {&FRAME-NAME} = '0'.

        assign c-char-1-400 = substring(estabelec.char-1,400,1).
        if c-char-1-400 <> ''  and
           c-char-1-400 <> ' ' AND
           c-char-1-400 <> ?   and
           can-do(idi-tip-ente-gov:list-item-pairs in frame {&FRAME-NAME}, c-char-1-400) then
            assign idi-tip-ente-gov:screen-value in frame {&FRAME-NAME} = c-char-1-400.

        display idi-tip-ente-gov with frame {&FRAME-NAME}.
    end.
    else
        assign idi-tip-ente-gov:hidden in frame {&FRAME-NAME} = yes.
  
  DISPLAY rs-trib-pis WITH FRAME {&FRAME-NAME}.
  

  find empresa 
      where empresa.ep-codigo = input frame {&frame-name} estabelec.ep-codigo no-lock no-error.
  if avail empresa then
     assign c-empresa = empresa.nome. 
  else 
     assign c-empresa = "".

  disp (c-empresa) @ c-empresa with frame {&frame-name}.

  IF i-pais-impto-usuario = 17 THEN DO: /*Colombia*/

    RUN openQueryStatic IN h-boco2008 (INPUT "Main":U) NO-ERROR.

    RUN goToKey IN h-boco2008 (INPUT c-cod-estabel).

    IF RETURN-VALUE = "OK":U THEN
        RUN getIntField IN h-boco2008 (INPUT "cdn-actividad":U,
                                       OUTPUT c-cod-atividade).
    ELSE 
        ASSIGN c-cod-atividade = 0.

    DISP c-cod-atividade WITH FRAME {&FRAME-NAME}.

    APPLY "LEAVE":U TO c-cod-atividade IN FRAME {&FRAME-NAME}.

  END.

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

  ASSIGN rs-trib-pis:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         tg-depos-fechado:SENSITIVE IN FRAME {&FRAME-NAME} = YES
         idi-tip-ente-gov:sensitive in frame {&frame-name} = yes.

  IF i-pais-impto-usuario = 17 THEN
       ASSIGN c-cod-atividade:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign l-alterou = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  find first param-global no-lock no-error.
  if  avail param-global then
      assign estabelec.cgc:format          in frame {&frame-name} = param-global.formato-id-federal
             estabelec.cgc:label           in frame {&frame-name} = param-global.label-cgc
             estabelec.ins-estadual:format in frame {&frame-name} = "x(19)".  
       
  IF i-pais-impto-usuario = 1 THEN DO: /* Brasil */
     {utp/ut-liter.i "CNPJ" * R}
     ASSIGN estabelec.cgc:LABEL IN FRAME {&frame-name} = RETURN-VALUE.       
  END.
  ELSE DO:
    IF param-global.label-cgc = "" THEN DO:
       {utp/ut-liter.i "CGC" * R}
       ASSIGN estabelec.cgc:LABEL IN FRAME {&frame-name} = RETURN-VALUE.
    END.  
  END.  
     
  IF i-pais-impto-usuario = 17 THEN
       ASSIGN c-cod-atividade:HIDDEN IN FRAME {&FRAME-NAME}  = NO
              c-desc-atividade:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  ELSE
       ASSIGN c-cod-atividade:HIDDEN IN FRAME {&FRAME-NAME}  = YES
              c-desc-atividade:HIDDEN IN FRAME {&FRAME-NAME} = YES.

  IF i-pais-impto-usuario = 17 THEN DO:
    IF NOT VALID-HANDLE(h-boco2001) THEN
        RUN local/col/boco2001.p PERSISTENT SET h-boco2001.

    IF NOT VALID-HANDLE(h-boco2008) THEN
        RUN local/col/boco2008.p PERSISTENT SET h-boco2008.
  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ).
  
  {utp/ut-liter.i "CNPJ" * R}
  assign estabelec.cgc:label in frame {&frame-name} = return-value.

    if i-pais-impto-usuario = 1 then do: 

        {utp/ut-liter.i "Compra_Governamental" *}
        assign c-lbl-tip-ente-gov                                   = return-value
               lbl-tip-ente-gov:screen-value in frame {&frame-name} = c-lbl-tip-ente-gov.     

        oTipoEnteGovernamentalList = new cdp.list.TipoEnteGovernamentalList().
        assign idi-tip-ente-gov:list-item-pairs in frame {&FRAME-NAME} = oTipoEnteGovernamentalList:getLista().
        assign idi-tip-ente-gov:screen-value in frame {&FRAME-NAME}    = '0'.    
    end.
    else
        assign rect-7          :hidden in frame {&frame-name} = yes
               lbl-tip-ente-gov:hidden in frame {&frame-name} = yes.


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
  def input parameter v-row-parent-externo as rowid no-undo.

  assign v-row-parent = v-row-parent-externo.

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

  {include/i-vldfrm.i}

  RUN Who-Is-The-Container IN adm-broker-hdl
     (INPUT this-procedure, OUTPUT c-handle).
  assign wh-cd0602 = widget-handle(c-handle).
  
  &IF "{&mguni_version}" >= "2.071" &THEN
  if not can-find(empresa
                  where empresa.ep-codigo = STRING(input frame {&frame-name} estabelec.ep-codigo)) then do:
  &ELSE
  if not can-find(empresa
                  where empresa.ep-codigo = int(input frame {&frame-name} estabelec.ep-codigo)) then do:
  &ENDIF
      run utp/ut-msgs.p (input "show",
                         input 15642,
                         input input frame {&frame-name} estabelec.ep-codigo). /*Empresa &1 nÆo encontrada*/
      run select-page in wh-cd0602 (2).
      apply "entry" to estabelec.ep-codigo in frame {&frame-name}.
      return "adm-error":U.
  end.


  if not adm-new-record then do:
      assign i-ep-codigo-orig = estabelec.ep-codigo.  

      if input frame {&frame-name} estabelec.ep-codigo <> i-ep-codigo-orig then do:

         /*verificar se o m¢dulo de investimentos est  implantado*/
         find first param-global no-lock no-error.
         if avail param-global then do:

            /*if param-global.modulo-in = yes then do:    
                 verifica se existem registros com o c¢digo da empresa original 

                find first ordem-inv 
                    where ordem-inv.ep-codigo    = i-ep-codigo-orig  and 
                          ordem-inv.cod-est-exec = estabelec.cod-estabel
                          no-lock no-error.

                if avail ordem-inv then do:
                    run utp/ut-msgs.p (input "show", input 19440, input ""). 
                    run select-page in wh-cd0602 (2).
                    apply "entry" to estabelec.ep-codigo.
                    return "adm-error":U.
                end.

            end. */


         end.
     end.
  end.

  IF i-pais-impto-usuario = 1 THEN DO: /* Brasil */

     IF TRIM(estabelec.cgc:SCREEN-VALUE) <> "" THEN DO:
        
        ASSIGN estabelec.cgc:format in frame {&FRAME-NAME} =  param-global.formato-id-federal.
                    
        /** Valida digitação CNPJ **/
        ASSIGN c-cnpj = TRIM(REPLACE(REPLACE(REPLACE(
                        REPLACE(estabelec.cgc:SCREEN-VALUE, ".", ""), "-", ""), "/", ""), " ", "")).
                        
        IF LENGTH(c-cnpj) < 14 OR LENGTH(c-cnpj) > 19 THEN DO:
                       {include/i-vldprg.i}
                       RUN utp/ut-msgs.p ("show", 2744, "").
                       APPLY "ENTRY" TO estabelec.cgc IN FRAME {&FRAME-NAME}.
                       RETURN 'ADM-ERROR':U.
        END.                    
           
        /* Forçar letras para maiúsculo */
        ASSIGN estabelec.cgc:SCREEN-VALUE = CAPS(estabelec.cgc:SCREEN-VALUE).
        
     END.
  
  END.
  ELSE DO:
       
     assign c-formato-cgc = input frame {&FRAME-NAME} mgadm.estabelec.cgc no-error.
     if (error-status:error or
         estabelec.cgc:format in frame {&frame-name} <> param-global.formato-id-federal) 
     then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show", input 2744, input "").
         run select-page in wh-cd0602 (2).
         apply 'entry' to estabelec.cgc in frame {&frame-name}.
         return "adm-error":U.
     end.

  END.

  /* Verifica se o Emitente j  existe para outro Estabelecimento */
  if  input frame {&FRAME-NAME} estabelec.cod-emitente <> 0 
  and (adm-new-record or l-alterou = yes) then do:
      find first b-estabelec
          where b-estabelec.cod-emitente = input frame {&FRAME-NAME} estabelec.cod-emitente
          no-lock no-error.
      if  avail b-estabelec then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show", input 15741, input "").
          run select-page in wh-cd0602 (2).
          apply 'entry' to estabelec.cod-emitente in frame {&frame-name}.
          return "adm-error":U.
      end.
  end.

  /* Verifica se o Emitente existe na base  */
  find first emitente 
       where emitente.cod-emitente = input frame {&FRAME-NAME} estabelec.cod-emitente 
       no-lock no-error.
  if not avail emitente then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show", input 91, input "").
      apply 'entry' to estabelec.cod-emitente in frame {&frame-name}.
      return "adm-error":U.
  end.

  /* Verifica se o CGC j  existe para outro Estabelecimento */
  RUN get-attribute ('adm-new-record').
  if  return-value = "yes":U then do:
      find first b-estabelec
          where b-estabelec.cgc = input frame {&FRAME-NAME} estabelec.cgc
          no-lock no-error.
      if  avail b-estabelec then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show", input 7617, input "").
      end.
  end.


  find empresa where empresa.ep-codigo = input frame {&frame-name} estabelec.ep-codigo no-lock no-error.
  if  avail empresa and empresa.pais = "Brasil" then do: 
        do  on error undo, return 'adm-error':
            run cdp/cd6666.p (input input frame {&FRAME-NAME} estabelec.cgc, 
                              input 2).
            if  return-value = 'NOK' then do:
                {include/i-vldprg.i}
                run select-page in wh-cd0602 (2).
                apply 'entry' to estabelec.cgc in frame {&frame-name}.
                return "adm-error":U.
            end.
        end.          
  end.


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
  {src/adm/template/snd-list.i "estabelec"}

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

