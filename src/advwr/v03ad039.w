&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            MSS
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
{include/i-prgvrs.i V03AD039 2.00.00.031 } /*** "010031" 19/03/2026 16:02:06 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03AD039 MUT}
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

def var c-handle as char    no-undo.
def var h-handle-atual as handle  no-undo.
DEF VAR h_v02ad039     AS HANDLE  NO-UNDO.
DEFINE VARIABLE v_hdl_api        AS HANDLE NO-UNDO.
DEFINE VARIABLE v_log_integr_mng AS LOGICAL NO-UNDO.

def var i-valor              as integer no-undo.
def var c-cod-venc-temp      as char    no-undo.
def var c-dia-sem-base-temp  as char    no-undo.
def var c-dia-sem-venc-temp  as char    no-undo.
def var l-atualiza-indice    as logical no-undo.
DEF VAR hProgramZoom         AS HANDLE  NO-UNDO.
def var cLista1              as char    no-undo.
def var cLista2              as char    no-undo.
def var i-cont               as integer no-undo.

/**/
DEF VAR l-data-fixa          AS LOGICAL NO-UNDO.
{cdp/cdcfgdis.i}
/**/

{cdp/cdcfgdis.i}

DEF VAR l-funcao-cred-cond-pagto AS LOG NO-UNDO.

DEF VAR l-Integr-Me              AS LOGICAL NO-UNDO INIT NO.

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
&Scoped-define EXTERNAL-TABLES cond-pagto
&Scoped-define FIRST-EXTERNAL-TABLE cond-pagto


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR cond-pagto.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS cond-pagto.log-cond-pagto-mais-negoc ~
cond-pagto.dia-mes-base cond-pagto.dia-mes-venc cond-pagto.nr-dias-ante ~
cond-pagto.nr-dupdes cond-pagto.per-des-pgan cond-pagto.nr-tab-finan ~
cond-pagto.nr-ind-finan 
&Scoped-define ENABLED-TABLES cond-pagto
&Scoped-define FIRST-ENABLED-TABLE cond-pagto
&Scoped-Define ENABLED-OBJECTS RECT-14 lAtualizaIndice cbTipoAvalCredito ~
fi-metodo-pagto 
&Scoped-Define DISPLAYED-FIELDS cond-pagto.log-cond-pagto-mais-negoc ~
cond-pagto.dia-mes-base cond-pagto.dia-mes-venc cond-pagto.nr-dias-ante ~
cond-pagto.nr-dupdes cond-pagto.per-des-pgan cond-pagto.nr-tab-finan ~
cond-pagto.nr-ind-finan 
&Scoped-define DISPLAYED-TABLES cond-pagto
&Scoped-define FIRST-DISPLAYED-TABLE cond-pagto
&Scoped-Define DISPLAYED-OBJECTS cb-cod-vencto rs-metodo-pagto ~
cb-dia-sem-base cb-dia-sem-venc lAtualizaIndice cbTipoAvalCredito ~
cb-meio-pagto-NF-e cod-cond-pag-integr-me idi-situacao-cond-pag-me ~
fi-metodo-pagto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS cb-cod-vencto cb-dia-sem-base ~
cb-dia-sem-venc cb-meio-pagto-NF-e 

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
DEFINE VARIABLE cb-cod-vencto AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     LABEL "cb-cod-vencto" 
     VIEW-AS COMBO-BOX INNER-LINES 9
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-dia-sem-base AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     LABEL "cb-dia-sem-base" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-dia-sem-venc AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     LABEL "cb-dia-sem-venc" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cb-meio-pagto-NF-e AS CHARACTER FORMAT "X(20)":U INITIAL "1" 
     LABEL "Meio Pagamento" 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 36 BY 1 TOOLTIP "Meio Pagamento" NO-UNDO.

DEFINE VARIABLE cbTipoAvalCredito AS CHARACTER FORMAT "X(256)":U INITIAL "Avalia‡Æo Normal" 
     LABEL "Tipo Avalia‡Æo Cr‚dito" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Avalia‡Æo Normal","Aprova‡Æo Autom tica","Reprova‡Æo Autom tica" 
     DROP-DOWN-LIST
     SIZE 22 BY 1 NO-UNDO.

DEFINE VARIABLE cod-cond-pag-integr-me AS CHARACTER FORMAT "X(256)":U 
     LABEL "Id ME" 
     VIEW-AS FILL-IN 
     SIZE 9.43 BY .79 TOOLTIP "Id Correspondente no ME" NO-UNDO.

DEFINE VARIABLE fi-metodo-pagto AS CHARACTER FORMAT "X(256)":U INITIAL "M‚todo de Pagto" 
      VIEW-AS TEXT 
     SIZE 13 BY .67 NO-UNDO.

DEFINE VARIABLE idi-situacao-cond-pag-me AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 33 BY .79 TOOLTIP "Situa‡Æo da Integra‡Æo" NO-UNDO.

DEFINE VARIABLE rs-metodo-pagto AS CHARACTER INITIAL "PUE" 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "PUE", "PUE",
"PPD", "PPD"
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 21 BY 1.5.

DEFINE VARIABLE lAtualizaIndice AS LOGICAL INITIAL no 
     LABEL "Atualiza ¡ndice de acordo com prazo m‚dio" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     cb-cod-vencto AT ROW 1.25 COL 17.57 COLON-ALIGNED
     cond-pagto.log-cond-pagto-mais-negoc AT ROW 1.25 COL 49.14
          LABEL "Mais Neg¢cios"
          VIEW-AS TOGGLE-BOX
          SIZE 15 BY .83
     cond-pagto.dia-mes-base AT ROW 2.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     rs-metodo-pagto AT ROW 3.21 COL 68.14 RIGHT-ALIGNED NO-LABEL WIDGET-ID 2
     cb-dia-sem-base AT ROW 3.25 COL 17.57 COLON-ALIGNED
     cond-pagto.dia-mes-venc AT ROW 4.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     cb-dia-sem-venc AT ROW 5.25 COL 17.57 COLON-ALIGNED
     cond-pagto.nr-dias-ante AT ROW 6.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     cond-pagto.nr-dupdes AT ROW 7.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     cond-pagto.per-des-pgan AT ROW 8.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     cond-pagto.nr-tab-finan AT ROW 9.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     lAtualizaIndice AT ROW 9.25 COL 27
     cbTipoAvalCredito AT ROW 10.17 COL 41 COLON-ALIGNED
     cond-pagto.nr-ind-finan AT ROW 10.25 COL 17.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     cb-meio-pagto-NF-e AT ROW 11.25 COL 17.57 COLON-ALIGNED HELP
          "Meio Pagamento" WIDGET-ID 14
     cod-cond-pag-integr-me AT ROW 12.25 COL 17.57 COLON-ALIGNED WIDGET-ID 16
     idi-situacao-cond-pag-me AT ROW 12.25 COL 27.57 COLON-ALIGNED NO-LABEL WIDGET-ID 18
     fi-metodo-pagto AT ROW 2.5 COL 49.14 COLON-ALIGNED NO-LABEL WIDGET-ID 12
     RECT-14 AT ROW 2.75 COL 49 WIDGET-ID 10
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.cond-pagto
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
         HEIGHT             = 12.42
         WIDTH              = 76.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_fnctrad.i}
{utils/validaparamIntegraMe.i}

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

/* SETTINGS FOR COMBO-BOX cb-cod-vencto IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-dia-sem-base IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-dia-sem-venc IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-meio-pagto-NF-e IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       cbTipoAvalCredito:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN cod-cond-pag-integr-me IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN idi-situacao-cond-pag-me IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       lAtualizaIndice:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR RADIO-SET rs-metodo-pagto IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
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

&Scoped-define SELF-NAME cb-cod-vencto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-cod-vencto V-table-Win
ON VALUE-CHANGED OF cb-cod-vencto IN FRAME f-main /* cb-cod-vencto */
DO:
  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     assign cLista1 = {diinc/i02di165.i 03}.  
     run utp/ut-lstit.p (input-output cLista1).

     If  lookup(self:screen-value,",") mod 2 <> 0 Then
         ASSIGN i-valor = (lookup(self:screen-value,cLista1) + 1) / 2.
     else 
         ASSIGN i-valor = lookup(self:screen-value,cLista1) / 2.
  &else
     assign i-valor = lookup(self:screen-value,{diinc/i02di165.i 03}).
  &endif                                                              

  if i-valor = 2 or i-valor = 3 or i-valor = 4 then
     run PI-TRATA-A-VISTA in h-handle-atual.
  else
     run PI-APPLY-CAMPO-PARCELA-2 in h-handle-atual.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME lAtualizaIndice
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL lAtualizaIndice V-table-Win
ON VALUE-CHANGED OF lAtualizaIndice IN FRAME f-main /* Atualiza ¡ndice de acordo com prazo m‚dio */
DO:

  &IF DEFINED(bf_dis_gradiente) &THEN
      IF lAtualizaIndice:CHECKED IN FRAME {&FRAME-NAME} THEN
          ASSIGN cond-pagto.nr-ind-finan:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
                 cond-pagto.nr-ind-finan:SENSITIVE    IN FRAME {&FRAME-NAME} = NO.
      ELSE
          ASSIGN cond-pagto.nr-ind-finan:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.log-cond-pagto-mais-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.log-cond-pagto-mais-negoc V-table-Win
ON VALUE-CHANGED OF cond-pagto.log-cond-pagto-mais-negoc IN FRAME f-main /* Mais Neg¢cios */
DO:
  
    IF cond-pagto.log-cond-pagto-mais-negoc:CHECKED IN FRAME {&FRAME-NAME} THEN DO:
        run utp/ut-msgs.p (input "show",
                           input 57171,
                           input return-value).
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.nr-ind-finan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.nr-ind-finan V-table-Win
ON F5 OF cond-pagto.nr-ind-finan IN FRAME f-main /* Num Öndice Finan */
DO:
    ASSIGN l-implanta = NO.
    DEF VAR i-nr-ind-finan AS INTEGER NO-UNDO.

    FIND tab-finan WHERE
         tab-finan.nr-tab-finan = INPUT FRAME {&FRAME-NAME} cond-pagto.nr-tab-finan NO-LOCK NO-ERROR.
    IF  AVAIL tab-finan THEN DO:
        IF  cond-pagto.nr-tab-finan:SCREEN-VALUE IN FRAME  {&FRAME-NAME} <> "0" THEN DO:

            &IF DEFINED(bf_dis_gradiente) &THEN
                {method/zoomfields.i &ProgramZoom="dizoom/z02di388.w"
                                     &FieldZoom1="num-seq"
                                     &FieldScreen1="cond-pagto.nr-ind-finan"
                                     &Frame1="{&frame-name}"
                                     &RunMethod="RUN piSetTabFinan IN hProgramZoom (INPUT input frame {&frame-name} cond-pagto.nr-tab-finan)."
                                     &EnableImplant="NO"}
            &ELSE
                RUN dizoom/z02di187.w (INPUT INTEGER(cond-pagto.nr-tab-finan:SCREEN-VALUE),
                                       OUTPUT i-nr-ind-finan).
                IF  i-nr-ind-finan <> 0 THEN
                    DISPLAY i-nr-ind-finan @ cond-pagto.nr-ind-finan WITH FRAME {&FRAME-NAME}.
            &ENDIF
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.nr-ind-finan V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cond-pagto.nr-ind-finan IN FRAME f-main /* Num Öndice Finan */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cond-pagto.nr-tab-finan
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.nr-tab-finan V-table-Win
ON F5 OF cond-pagto.nr-tab-finan IN FRAME f-main /* Tab Financ */
DO:

    ASSIGN l-implanta = YES.

    {include/zoomvar.i &prog-zoom=dizoom/z01di187.w
                       &campo=cond-pagto.nr-tab-finan
                       &campozoom=nr-tab-finan}                         

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cond-pagto.nr-tab-finan V-table-Win
ON MOUSE-SELECT-DBLCLICK OF cond-pagto.nr-tab-finan IN FRAME f-main /* Tab Financ */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  //Chamada da procedure que verifica se o ME est  ativo, via include
   RUN pi-check-integr-me.
    
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

{utp/ut-field.i mgadm cond-pagto cod-vencto 1}
assign cb-cod-vencto:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgadm cond-pagto dia-sem-base 1}
assign cb-dia-sem-base:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgadm cond-pagto dia-sem-venc 1}
assign cb-dia-sem-venc:label in frame {&frame-name} = return-value.

if cond-pagto.nr-tab-finan:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
if cond-pagto.nr-ind-finan:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "cond-pagto"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "cond-pagto"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then

      assign cb-cod-vencto:screen-value   in frame {&frame-name} = entry(2,cb-cod-vencto:list-item-pairs)
             cb-dia-sem-base:screen-value in frame {&frame-name} = entry(16,cb-dia-sem-base:list-item-pairs)
             cb-dia-sem-venc:screen-value in frame {&frame-name} = entry(16,cb-dia-sem-venc:list-item-pairs).
    &else

      assign cb-cod-vencto:screen-value   in frame {&frame-name} = entry(1,cb-cod-vencto:list-items)
             cb-dia-sem-base:screen-value in frame {&frame-name} = entry(8,cb-dia-sem-base:list-items)
             cb-dia-sem-venc:screen-value in frame {&frame-name} = entry(8,cb-dia-sem-venc:list-items).

  &endif


  &IF DEFINED(bf_dis_gradiente) &THEN
      ASSIGN lAtualizaIndice:CHECKED IN FRAME {&FRAME-NAME} = NO.
      APPLY "value-changed":U TO lAtualizaIndice IN FRAME {&FRAME-NAME}.
  &ENDIF
 
  IF i-pais-impto-usuario = 4 THEN DO:
     {utp/ut-liter.i M‚todo_de_Pagto * R}
     assign fi-metodo-pagto:screen-value in frame {&frame-name} = return-value
            rs-metodo-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "PUE":U.

  END.

  IF  i-pais-impto-usuario = 1 THEN
      assign cb-meio-pagto-NF-e:screen-value = "":U NO-ERROR.

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

  DEF VAR icbTipoAvalCreditoAux AS INT NO-UNDO.
  DEF VAR c-metodo-pagto        AS CHAR NO-UNDO.

  IF  l-funcao-cred-cond-pagto THEN
      ASSIGN icbTipoAvalCreditoAux = IF cbTipoAvalCredito:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "Aprova‡Æo Autom tica"
                                     THEN 2
                                     ELSE IF cbTipoAvalCredito:SCREEN-VALUE = "Reprova‡Æo Autom tica"
                                          THEN 3
                                          ELSE 1.

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

    assign
          &IF DEFINED(bf_dis_gradiente) &THEN
          l-atualiza-indice   = lAtualizaIndice:checked in frame {&frame-name}
          &ENDIF
          c-cod-venc-temp     = input frame {&frame-name} cb-cod-vencto
          c-dia-sem-base-temp = input frame {&frame-name} cb-dia-sem-base
          c-dia-sem-venc-temp = input frame {&frame-name} cb-dia-sem-venc.

    IF i-pais-impto-usuario = 4 THEN
       ASSIGN c-metodo-pagto = INPUT FRAME {&FRAME-NAME} rs-metodo-pagto.


    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    
    assign
           &IF DEFINED(bf_dis_gradiente) &THEN
           cond-pagto.log-atual-idx = l-atualiza-indice
           &ENDIF
           cb-cod-vencto:screen-value in frame {&frame-name}   = c-cod-venc-temp
           cb-dia-sem-base:screen-value in frame {&frame-name} = c-dia-sem-base-temp 
           cb-dia-sem-venc:screen-value in frame {&frame-name} = c-dia-sem-venc-temp.
               
    do with frame {&frame-name}:
    
       assign cond-pagto.cod-vencto   = cb-cod-vencto:lookup(cb-cod-vencto:screen-value).
       assign cond-pagto.dia-sem-base = cb-dia-sem-base:lookup(cb-dia-sem-base:screen-value).
       assign cond-pagto.dia-sem-venc = cb-dia-sem-venc:lookup(cb-dia-sem-venc:screen-value).
    
       IF  l-funcao-cred-cond-pagto THEN
           &IF "{&bf_dis_versao_ems}" >= "2.062" 
           &THEN ASSIGN cond-pagto.idi-forma-avaliac-cr  = icbTipoAvalCreditoAux.
           &ELSE ASSIGN cond-pagto.int-1                 = icbTipoAvalCreditoAux.
           &ENDIF      
    end.
       

    IF i-pais-impto-usuario = 4 THEN
       ASSIGN overlay(cond-pagto.char-1,21,23) = c-metodo-pagto.


    IF  i-pais-impto-usuario = 1 THEN DO:
    
        ASSIGN INPUT FRAME {&FRAME-NAME} cb-meio-pagto-NF-e.
    
        ASSIGN OVERLAY(cond-pagto.char-1,44,2) = ENTRY(1,cb-meio-pagto-NF-e," - ")
               OVERLAY(cond-pagto.char-1,44,2) = (IF TRIM(SUBSTRING(cond-pagto.char-1,44,2)) = "0"
                                                  THEN "":U
                                                  ELSE TRIM(SUBSTRING(cond-pagto.char-1,44,2))) NO-ERROR.
    END.

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

  &IF DEFINED(bf_dis_gradiente) &THEN
      DISABLE lAtualizaIndice WITH FRAME {&FRAME-NAME}.
  &ENDIF

  IF  l-funcao-cred-cond-pagto THEN
      DISABLE cbTipoAvalCredito WITH FRAME {&FRAME-NAME}.

  IF i-pais-impto-usuario = 4 THEN
     ASSIGN rs-metodo-pagto:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF  i-pais-impto-usuario <> 1 THEN
      ASSIGN cb-meio-pagto-NF-e:HIDDEN IN FRAME {&FRAME-NAME} = yes.

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  &IF DEFINED(bf_dis_gradiente) &THEN
      ASSIGN lAtualizaIndice:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  &ELSE
      ASSIGN lAtualizaIndice:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF


  if avail cond-pagto then do with frame {&frame-name}:

    IF cond-pagto.log-cond-pagto-mais-negoc = ? THEN DO:
        ASSIGN cond-pagto.log-cond-pagto-mais-negoc:CHECKED = FALSE.
    END.

    &IF DEFINED(bf_dis_gradiente) &THEN
        ASSIGN lAtualizaIndice:CHECKED = cond-pagto.log-atual-idx.
    &ENDIF
    if  cond-pagto.dia-sem-base <> 0 then
        assign cb-cod-vencto:screen-value     = {diinc/i02di165.i 04 cond-pagto.cod-vencto}
               cb-dia-sem-base:screen-value   = {adinc/i01ad039.i 04 cond-pagto.dia-sem-base}
               cb-dia-sem-venc:screen-value   = {adinc/i01ad039.i 04 cond-pagto.dia-sem-venc} . 
    ELSE
        assign cb-cod-vencto:screen-value   = {diinc/i02di165.i 04 1}
               cb-dia-sem-base:screen-value = {adinc/i01ad039.i 04 1}     
               cb-dia-sem-venc:screen-value = {adinc/i01ad039.i 04 1}.

    IF  l-funcao-cred-cond-pagto THEN
         &IF "{&bf_dis_versao_ems}" >= "2.062" 
         &THEN ASSIGN cbTipoAvalCredito:SCREEN-VALUE IN FRAME {&frame-name} = IF  cond-pagto.idi-forma-avaliac-cr = 2
                                                                              THEN "Aprova‡Æo Autom tica"
                                                                              ELSE IF  cond-pagto.idi-forma-avaliac-cr = 3
                                                                                   THEN "Reprova‡Æo Autom tica"
                                                                                   ELSE "Avalia‡Æo Normal".
         &ELSE ASSIGN cbTipoAvalCredito:SCREEN-VALUE IN FRAME {&frame-name} = IF  cond-pagto.int-1 = 2
                                                                              THEN "Aprova‡Æo Autom tica"
                                                                              ELSE IF  cond-pagto.int-1 = 3
                                                                                   THEN "Reprova‡Æo Autom tica"
                                                                                   ELSE "Avalia‡Æo Normal".
         &ENDIF      
  end.
  else do:
      assign cb-cod-vencto:screen-value   = {diinc/i02di165.i 04 1}
             cb-dia-sem-base:screen-value = {adinc/i01ad039.i 04 1}     
             cb-dia-sem-venc:screen-value = {adinc/i01ad039.i 04 1}
             &IF DEFINED(bf_dis_gradiente) &THEN
             lAtualizaIndice:CHECKED = NO
             &ENDIF  .
  end.
  IF i-pais-impto-usuario = 4 THEN
       ASSIGN rs-metodo-pagto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(cond-pagto.char-1,21,23).

  
  IF  i-pais-impto-usuario = 1 THEN DO:
  
      DEFINE VARIABLE cLista AS CHARACTER   NO-UNDO.
      ASSIGN cLista = "":U
             cLista = "    ," + TRIM({adinc/i03ad039.i 03}).
    
      &if "{&FNC_MULTI_IDIOMA}" = "Yes":U &then
          RUN utp/ut-lstit.p (input-output cLista).
          ASSIGN cb-meio-pagto-NF-e:LIST-ITEM-PAIRS = cLista.
      &else
          ASSIGN cb-meio-pagto-NF-e:LIST-ITEMS      = cLista.
      &endif
      
      REPEAT i-cont = 1 TO NUM-ENTRIES(cLista):
          if  ENTRY(1,ENTRY(i-cont, cLista)," - ") = TRIM(SUBSTRING(cond-pagto.char-1,44,2)) then do:
              assign cb-meio-pagto-NF-e:screen-value = ENTRY(i-cont, cLista) NO-ERROR.
              leave.
          end.
          else
              assign cb-meio-pagto-NF-e:screen-value = "" NO-ERROR.
      END.
  END.

  IF SEARCH("hbbo/boParamFuncaoProdut.r")  <> ? THEN DO:  
      RUN hbbo/boParamFuncaoProdut.p PERSISTENT SET v_hdl_api.
      RUN pi_existe_funcao in v_hdl_api (INPUT "TOTVS Mais Negocios",
                                         OUTPUT v_log_integr_mng).

      IF v_log_integr_mng THEN DO:
        ASSIGN cond-pagto.log-cond-pagto-mais-negoc:HIDDEN IN FRAME {&FRAME-NAME} = NO.
      END.
      ELSE DO:
        ASSIGN cond-pagto.log-cond-pagto-mais-negoc:HIDDEN IN FRAME {&FRAME-NAME} = YES.
      END.

      DELETE PROCEDURE v_hdl_api.
  END.
  
  IF l-Integr-Me THEN DO:
    FIND FIRST cond-pagto-integr-me WHERE cond-pagto-integr-me.cod-cond-pag = cond-pagto.cod-cond-pag NO-LOCK NO-ERROR.
    IF AVAIL cond-pagto-integr-me THEN DO:
        ASSIGN cod-cond-pag-integr-me:SCREEN-VALUE IN FRAME {&FRAME-NAME}   = STRING(cond-pagto-integr-me.cod-cond-pag-integr).  
        ASSIGN idi-situacao-cond-pag-me:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {ininc/i01in01077.i 04 cond-pagto-integr-me.idi-situacao}.
    END.
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF DEFINED(bf_dis_gradiente) &THEN
      ENABLE lAtualizaIndice WITH FRAME {&FRAME-NAME}.
      APPLY "value-changed":U TO lAtualizaIndice IN FRAME {&FRAME-NAME}.
  &ENDIF

  /**/
  &IF "{&bf_dis_versao_ems}" >= "2.04" &THEN
  /** Verifica se existe a fun‡Æo e se est  ativa **/
  IF CAN-FIND(funcao NO-LOCK WHERE
              funcao.cd-funcao = "spp-data-fixa" AND
              funcao.ativo)                      THEN DO:
      RUN pi-habilita-campos IN THIS-PROCEDURE.
  END.
  &ENDIF
  /**/

  IF  l-funcao-cred-cond-pagto THEN
      ENABLE cbTipoAvalCredito WITH FRAME {&FRAME-NAME}.


  IF i-pais-impto-usuario = 4 THEN
     ASSIGN rs-metodo-pagto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  IF  i-pais-impto-usuario <> 1 THEN
      ASSIGN cb-meio-pagto-NF-e:HIDDEN IN FRAME {&FRAME-NAME} = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  ASSIGN l-funcao-cred-cond-pagto = CAN-FIND(FIRST funcao
                                             WHERE funcao.cd-funcao = "spp-CredCondPag"
                                             AND   funcao.ativo     = YES NO-LOCK).

  /* Code placed here will execute PRIOR to standard behavior. */
 do  with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
         assign cLista1 = {diinc/i02di165.i 03}
                cLista2 = {adinc/i01ad039.i 03}.          
         run utp/ut-lstit.p (input-output cLista1).
         run utp/ut-lstit.p (input-output cLista2).
         assign cb-cod-vencto:list-item-pairs         = cLista1
                cb-dia-sem-base:list-item-pairs       = cLista2
                cb-dia-sem-venc:list-item-pairs       = cLista2.
     &else
         assign cb-cod-vencto:list-items         = {diinc/i02di165.i 03}
                cb-dia-sem-base:list-items       = {adinc/i01ad039.i 03}
                cb-dia-sem-venc:list-items       = {adinc/i01ad039.i 03}.
     &endif
 end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.   

  &IF DEFINED(bf_dis_gradiente) &THEN
      ASSIGN lAtualizaIndice:HIDDEN IN FRAME {&FRAME-NAME} = NO.
  &ELSE
      ASSIGN lAtualizaIndice:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  &ENDIF

  ASSIGN cbTipoAvalCredito:HIDDEN IN FRAME {&FRAME-NAME} = NOT l-funcao-cred-cond-pagto.

  IF i-pais-impto-usuario = 4 THEN DO:
     ASSIGN rs-metodo-pagto:HIDDEN IN FRAME {&FRAME-NAME} = NO
            fi-metodo-pagto:HIDDEN IN FRAME {&FRAME-NAME} = NO
            rect-14:HIDDEN IN FRAME {&FRAME-NAME}         = NO.

     {utp/ut-liter.i M‚todo_de_Pagto * R}
     assign fi-metodo-pagto:screen-value in frame {&frame-name} = return-value.
  END.
  ELSE
     ASSIGN rs-metodo-pagto:HIDDEN IN FRAME {&FRAME-NAME} = YES
            fi-metodo-pagto:HIDDEN IN FRAME {&FRAME-NAME} = YES
            rect-14:HIDDEN IN FRAME {&FRAME-NAME}         = YES.

  IF  i-pais-impto-usuario <> 1 THEN
      ASSIGN cb-meio-pagto-NF-e:HIDDEN IN FRAME {&FRAME-NAME} = yes.
  ELSE
      ASSIGN cb-meio-pagto-NF-e:HIDDEN IN FRAME {&FRAME-NAME} = NO.
      
  IF l-Integr-Me = NO THEN DO:
    ASSIGN cod-cond-pag-integr-me:HIDDEN IN FRAME {&FRAME-NAME} = YES.
    ASSIGN idi-situacao-cond-pag-me:HIDDEN IN FRAME {&FRAME-NAME} = YES.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-campos V-table-Win 
PROCEDURE pi-habilita-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-get-screen-value IN h_v02ad039 (OUTPUT l-data-fixa).

    IF l-data-fixa THEN DO:
        DISABLE cb-cod-vencto
                cond-pagto.dia-mes-base
                cb-dia-sem-base
                cond-pagto.dia-mes-venc
                cb-dia-sem-venc WITH FRAME {&FRAME-NAME}.
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            ASSIGN cb-cod-vencto  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,cb-cod-vencto  :list-item-pairs)
                   cb-dia-sem-base:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(16,cb-dia-sem-base:list-item-pairs)
                   cb-dia-sem-venc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(16,cb-dia-sem-venc:list-item-pairs).
        &else
            ASSIGN cb-cod-vencto  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(1,cb-cod-vencto  :LIST-ITEMS)
                   cb-dia-sem-base:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(8,cb-dia-sem-base:LIST-ITEMS)
                   cb-dia-sem-venc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(8,cb-dia-sem-venc:LIST-ITEMS).
        &endif
    END.
    ELSE DO:
        ENABLE cb-cod-vencto
               cond-pagto.dia-mes-base
               cb-dia-sem-base
               cond-pagto.dia-mes-venc
               cb-dia-sem-venc WITH FRAME {&FRAME-NAME}.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAMETER h-v02ad039 AS HANDLE NO-UNDO.
def input parameter h-handle   as handle no-undo.

ASSIGN h_v02ad039     = h-v02ad039
       h-handle-atual = h-handle.

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
  DEFINE VARIABLE c-traduz AS CHARACTER   NO-UNDO.

  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

      if param-global.modulo-pd or 
         input frame {&frame-name} cond-pagto.nr-tab-finan <> 0 then do:
               find first tab-finan use-index ch-finan where tab-finan.nr-tab-finan = 
                                    input frame {&frame-name} cond-pagto.nr-tab-finan
                                    no-lock no-error.
               if avail tab-finan then do:
                  if  tab-finan.dt-ini-val <= today and
                      tab-finan.dt-fim-val >= today then
                              /* OK */.
                  else do:
                      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
                      run utp/ut-msgs.p (input "show":U, input 3952, input " ").
                      apply 'entry' to cond-pagto.nr-tab-finan in frame {&frame-name}.                      
                      return 'ADM-ERROR':U.
                  end.
               end.
      end.


 /* Teste de tabela de financiamento */

   find tab-finan where tab-finan.nr-tab-finan = 
                input frame {&frame-name} cond-pagto.nr-tab-finan no-lock no-error.
   if not avail tab-finan then do:
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
      {utp/ut-table.i  mgdis tab-finan 1}
      run utp/ut-msgs.p (input "show":U, input 158, input return-value).
      apply 'entry' to cond-pagto.nr-tab-finan in frame {&frame-name}.                      
      return 'ADM-ERROR':U.
   end.


 /* Teste de indice de financiamento */

   &IF DEFINED(bf_dis_gradiente) &THEN
   if input frame {&frame-name} cond-pagto.nr-ind-finan <> 0 THEN
       IF NOT CAN-FIND(FIRST tab-finan-indice NO-LOCK
                       WHERE tab-finan-indice.nr-tab-finan = input frame {&frame-name} cond-pagto.nr-tab-finan
                       AND   tab-finan-indice.num-seq      = INPUT FRAME {&FRAME-NAME} cond-pagto.nr-ind-finan) THEN DO:
           {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
           {utp/ut-liter.i Seq?ˆncia_Tabela_Financiamento}
           run utp/ut-msgs.p (input "show":U, input 158, input return-value).
           apply 'entry' to cond-pagto.nr-ind-finan in frame {&frame-name}.                      
           return 'ADM-ERROR':U.
       END.
   &ELSE
   if input frame {&frame-name} cond-pagto.nr-ind-finan > 12 then do:
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
      {utp/ut-field.i mgadm cond-pagto nr-ind-finan 1 }
      run utp/ut-msgs.p (input "show":U, input 158, input return-value).
      apply 'entry' to cond-pagto.nr-ind-finan in frame {&frame-name}.                      
      return 'ADM-ERROR':U.
   end.
   &ENDIF
   
   IF  cond-pagto.log-cond-pagto-mais-negoc:CHECKED IN FRAME {&FRAME-NAME}
   AND  (cb-cod-vencto:lookup(cb-cod-vencto:screen-value) = 2
      OR cb-cod-vencto:lookup(cb-cod-vencto:screen-value) = 3
      OR cb-cod-vencto:lookup(cb-cod-vencto:screen-value) = 4) THEN DO:
      {utp/ut-liter.i ·_Vista,_Antecipado_e_Contra_Entrega * R}
      ASSIGN c-traduz = RETURN-VALUE.
      {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
      run utp/ut-msgs.p (input "show":U, input 57274, input c-traduz).
        apply 'entry' to cond-pagto.log-cond-pagto-mais-negoc in frame {&frame-name}.                      
        return 'ADM-ERROR':U.

        
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
  {src/adm/template/snd-list.i "cond-pagto"}

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

