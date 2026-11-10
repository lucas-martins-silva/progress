&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V05AD268 2.00.00.053 } /*** "010053" 06/02/2026 11:11:17 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05ad268 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{cdp/cdcfgdis.i} /* pr‚-processadores */

def buffer b-trans for transporte.

&IF '{&mguni_version}' < '2.07' &THEN
    {scbo/bosc025.i "tt-imp-transp"}
&ENDIF

def var hShowMsg       as handle           no-undo.
def var h-bosc025      as handle           no-undo.
def var wh-container   as handle           no-undo.
def var c-mensagem     as character        no-undo.
def var c-cgc          as character        no-undo.
def var c-handle       as character        no-undo.
def var i-natureza     as integer          no-undo.

def var c-cgc-aux      like transporte.cgc no-undo.

def var i-nr-digito    as integer          no-undo.
def var i-digito       as integer          no-undo.
def var i-digito1      as integer          no-undo.
def var i-digito2      as integer          no-undo.
def var i-multiplic    as integer          no-undo.
def var i-result       as integer          no-undo.
def var i-cont         as integer          no-undo.
def var i-cont-1       as integer          no-undo.
def var de-total       as decimal          no-undo.
def var de-soma        as decimal          no-undo.
                                          
def var c-formato-cgc  as char             no-undo.
def var c-formato-ins  as char             no-undo.
def var h_v10ad268     as handle           no-undo.
def var c-nome-abrev   as char             no-undo.
{method/dbotterr.i}

DEFINE VARIABLE h-bofi230 AS HANDLE     NO-UNDO.

def var c-cod-erro        as   char     no-undo.
def var c-cod-ie-sai      as   char     no-undo.

def new global shared var c-ie-antiga as CHAR   no-undo.
DEF VAR c-cod-transp AS CHAR NO-UNDO.


/*VARIµVEIS LOCALIZA€ÇO EQUADOR*/
DEFINE VARIABLE h-boec012   AS HANDLE      NO-UNDO.
DEF VAR i-tipo-regime AS INT NO-UNDO.
DEF VAR i-cdn-doc     AS INT FORMAT ">>9" NO-UNDO.
DEF VAR c-nro-doc     AS CHAR FORMAT "x(13)" NO-UNDO.
DEFINE VARIABLE h-handle-container AS HANDLE      NO-UNDO.
/*FIM - VARIµVEIS LOCALIZA€ÇO EQUADOR*/

DEF VAR hProgramZoom AS HANDLE NO-UNDO.
DEF VAR i-tp-contrib   AS INT  NO-UNDO.
DEF VAR c-tp-docto-aux AS CHAR NO-UNDO.
DEF VAR c-num-mtc-aux  AS CHAR NO-UNDO.
DEF VAR i-transp-aux   AS INT  NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES transporte
&Scoped-define FIRST-EXTERNAL-TABLE transporte


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR transporte.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS transporte.natureza transporte.via-transp ~
transporte.cgc transporte.ins-estadual 
&Scoped-define ENABLED-TABLES transporte
&Scoped-define FIRST-ENABLED-TABLE transporte
&Scoped-Define ENABLED-OBJECTS RECT-7 RECT-6 rt-mold cb-tp-contrib ~
c-tp-docto c-num-mtc 
&Scoped-Define DISPLAYED-FIELDS transporte.natureza transporte.via-transp ~
transporte.cgc transporte.ins-estadual 
&Scoped-define DISPLAYED-TABLES transporte
&Scoped-define FIRST-DISPLAYED-TABLE transporte
&Scoped-Define DISPLAYED-OBJECTS cb-tp-contrib c-tp-docto c-num-mtc 

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


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-tp-contrib AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Contribuinte" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Item 1","Item 1"
     DROP-DOWN-LIST
     SIZE 20.43 BY 1 NO-UNDO.

DEFINE VARIABLE c-num-mtc AS CHARACTER FORMAT "X(20)":U 
     LABEL "N£mero MTC" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE c-tp-docto AS CHARACTER FORMAT "X(12)":U 
     LABEL "Tipo Documento" 
     VIEW-AS FILL-IN 
     SIZE 20.43 BY .88 DROP-TARGET NO-UNDO.

DEFINE VARIABLE fi-natureza AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-via-transp AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 24.72 BY 6.83.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.29 BY 1.42.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59.57 BY 6.83.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     transporte.natureza AT ROW 2.04 COL 9 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Pessoa F¡sica", 1,
"Pessoa Jur¡dica", 2,
"Estrangeiro", 3,
"Trading", 4
          SIZE 71.86 BY .75
     transporte.via-transp AT ROW 3.75 COL 63.29 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Rodovi rio", 1,
"Aerovi rio", 2,
"Mar¡timo", 3,
"Ferrovi rio", 4,
"Rodoferrovi rio", 5,
"Rodofluvial", 6,
"Rodoaerovi rio", 7,
"Outros", 8
          SIZE 21 BY 6.25
     transporte.cgc AT ROW 5.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     transporte.ins-estadual AT ROW 6.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     cb-tp-contrib AT ROW 7.25 COL 28 COLON-ALIGNED
     transporte.ins-municipal AT ROW 7.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 20.43 BY .88
     c-tp-docto AT ROW 8.33 COL 28 COLON-ALIGNED
     c-num-mtc AT ROW 8.33 COL 28 COLON-ALIGNED WIDGET-ID 2
     fi-natureza AT ROW 1.29 COL 1 COLON-ALIGNED NO-LABEL
     fi-via-transp AT ROW 3.04 COL 62 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.54 COL 1
     RECT-6 AT ROW 3.25 COL 61.43
     rt-mold AT ROW 3.29 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.transporte
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
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
         HEIGHT             = 9.13
         WIDTH              = 85.29.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit L-To-R                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

ASSIGN 
       c-num-mtc:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       c-tp-docto:HIDDEN IN FRAME f-main           = TRUE.

ASSIGN 
       cb-tp-contrib:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-natureza IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-via-transp IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN transporte.ins-municipal IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       transporte.ins-municipal:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME c-tp-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-docto V-table-Win
ON F5 OF c-tp-docto IN FRAME f-main /* Tipo Documento */
DO:
  {method/zoomfields.i &ProgramZoom="adzoom/z01ad00593.w"
                       &FieldZoom1="cod-tip-docto-ident"
                       &FieldScreen1="c-tp-docto"
                       &Frame1="f-main"
                       &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-tp-docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-tp-docto IN FRAME f-main /* Tipo Documento */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-contrib
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-contrib V-table-Win
ON VALUE-CHANGED OF cb-tp-contrib IN FRAME f-main /* Tipo Contribuinte */
DO:  
    IF {adinc/i01ad00598pry.i 06 SELF:SCREEN-VALUE IN FRAME {&FRAME-NAME}} = 2 THEN
        ASSIGN c-tp-docto:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE 
        ASSIGN c-tp-docto:SENSITIVE    IN FRAME {&FRAME-NAME} = NO
               c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".                
             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.cgc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cgc V-table-Win
ON ENDKEY OF transporte.cgc IN FRAME f-main /* CGC */
DO:
  ASSIGN i-natureza = input frame {&frame-name} transporte.natureza
         c-formato-cgc = input frame {&FRAME-NAME} transporte.cgc no-error.
  if error-status:ERROR then do:
      assign transporte.cgc:format in frame {&FRAME-NAME} = "x(19)".
  end.
  else
  IF param-global.id-federal-obrigatorio THEN DO:
     CASE i-natureza:
          WHEN 1 THEN
                 ASSIGN transporte.cgc:format in frame {&frame-name} = param-global.formato-id-pessoal.
          WHEN 2 THEN
                 ASSIGN transporte.cgc:format in frame {&frame-name} = param-global.formato-id-federal.
          OTHERWISE
                 ASSIGN transporte.cgc:format in frame {&frame-name} = "x(19)".
     END CASE.
  END.

  /*Para a localiza‡Æo Equador nÆo ‚ necess rio formata‡Æo*/
  IF i-pais-impto-usuario = 21 THEN
      ASSIGN transporte.cgc:format          in frame {&frame-name} = "x(13)".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cgc V-table-Win
ON ENTRY OF transporte.cgc IN FRAME f-main /* CGC */
DO:

  if input frame {&frame-name} transporte.natureza = 1 then 
      assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-pessoal.
  else 
      if input frame {&frame-name} transporte.natureza = 2 then 
          assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-federal.
      else 
          assign transporte.cgc:format = "x(19)".

    /*Para a localiza‡Æo Equador nÆo ‚ necess rio formata‡Æo*/
    IF i-pais-impto-usuario = 21 THEN
        ASSIGN transporte.cgc:format          in frame {&frame-name} = "x(13)".


    assign i-natureza = input frame {&frame-name} transporte.natureza
           c-formato-cgc = input frame {&FRAME-NAME} transporte.cgc no-error.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.cgc V-table-Win
ON LEAVE OF transporte.cgc IN FRAME f-main /* CGC */
DO:
	{cdp/cd9998.i}
	   
	IF i-pais-impto-usuario = 1 THEN
	   ASSIGN transporte.cgc:SCREEN-VALUE = CAPS(transporte.cgc:SCREEN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.ins-estadual
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.ins-estadual V-table-Win
ON ENDKEY OF transporte.ins-estadual IN FRAME f-main /* Inscri‡Æo Estadual */
DO:
  ASSIGN c-formato-ins = input frame {&frame-name} transporte.ins-estadual no-error.
  if error-status:ERROR then do:
      assign transporte.ins-estadual:format in frame {&frame-name} = "x(19)".
  end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.ins-estadual V-table-Win
ON ENTRY OF transporte.ins-estadual IN FRAME f-main /* Inscri‡Æo Estadual */
DO:
   assign transporte.ins-estadual:format in frame {&frame-name} = "x(19)".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.ins-estadual V-table-Win
ON LEAVE OF transporte.ins-estadual IN FRAME f-main /* Inscri‡Æo Estadual */
DO:    
   {cdp/cd9998.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME transporte.natureza
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL transporte.natureza V-table-Win
ON VALUE-CHANGED OF transporte.natureza IN FRAME f-main /* Nat */
DO:
    assign i-natureza = INPUT FRAME {&frame-name} transporte.natureza
           transporte.cgc:screen-value = "".
    apply 'entry' to transporte.cgc in frame {&FRAME-NAME}.
    apply 'leave' to transporte.cgc in frame {&FRAME-NAME}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-rtlbl.i mgadm transporte natureza   fi-natureza}
  {utp/ut-rtlbl.i mgadm transporte via-transp fi-via-transp}

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
  {src/adm/template/row-list.i "transporte"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "transporte"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE grava-campo-livre V-table-Win 
PROCEDURE grava-campo-livre :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT-OUTPUT PARAM p-des-campo
    AS CHARACTER
    FORMAT "x(40)"
    NO-UNDO.

DEF INPUT PARAM p-des-valor
    AS CHARACTER
    FORMAT "x(20)"
    NO-UNDO.

DEF INPUT PARAM p-cdn-pos
    AS INTEGER
    FORMAT "99999999"
    NO-UNDO.

IF NUM-ENTRIES(p-des-campo , ';':U ) > p-cdn-pos THEN
    ASSIGN ENTRY(p-cdn-pos,p-des-campo , ';':U) = p-des-valor.
ELSE
DO:    
    DO WHILE NUM-ENTRIES(p-des-campo , ';':U ) < p-cdn-pos + 1:
        ASSIGN p-des-campo = p-des-campo + ';'.
    END. 
        
    ASSIGN ENTRY(p-cdn-pos,p-des-campo , ';':U) = p-des-valor.            
END. 

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

 {utp/ut-field.i mgadm transporte natureza  1}
 display return-value @ fi-natureza with frame {&frame-name}.

 {utp/ut-field.i mgadm transporte via-transp 1}
 display return-value @ fi-via-transp with frame {&frame-name}.

 IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
     ASSIGN cb-tp-contrib:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i01ad00598pry.i 04 1}.
     APPLY "VALUE-CHANGED":U TO cb-tp-contrib IN FRAME {&FRAME-NAME}.
 END.

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
   def var c-transp like transporte.cod-transp.

   find first param-global no-lock no-error.

   {include/i-valid.i}


    /************* Verifica se ouve altera‡Æo nos seguintes campos: cpf, cnpj, ins-estadual
                           Chama o programa para atualiza‡Æo dos dados do transporte **********************/

    IF AVAIL transporte
    AND i-pais-impto-usuario = 1
    AND CONNECTED("mgfis") THEN
    DO:
        /*CPF*/
        IF transporte.natureza = 1
        AND transporte.cgc <> transporte.cgc:INPUT-VALUE IN FRAME {&FRAME-NAME} THEN
        DO:
            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp). 
            RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                            INPUT 4,
                                            INPUT transporte.cgc,
                                            INPUT transporte.cgc:INPUT-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT 05).
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.
        
        /*CNPJ*/
        IF transporte.natureza = 2
        AND transporte.cgc <> transporte.cgc:INPUT-VALUE IN FRAME {&FRAME-NAME} THEN
        DO:
            RUN fibo/bofi230.p PERSISTENT SET h-bofi230.
            ASSIGN c-cod-transp = "T" + STRING(transporte.cod-transp). 
            RUN gravaAlteracao IN h-bofi230(INPUT c-cod-transp,
                                            INPUT 4,
                                            INPUT transporte.cgc,
                                            INPUT transporte.cgc:INPUT-VALUE IN FRAME {&FRAME-NAME},
                                            INPUT 06).
            DELETE PROCEDURE h-bofi230.
            ASSIGN h-bofi230 = ?.
        END.
            
        /*Grava Inscri‡Æo Estadual antiga*/
        ASSIGN c-ie-antiga = transporte.ins-estadual.

    END.

  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */
  RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-handle).

  assign wh-container = widget-handle(c-handle).


  RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure,
         INPUT "c-cod-transp").             

  assign c-transp = integer(trim(return-value)).  

  IF i-pais-impto-usuario = 9 THEN
      ASSIGN i-tp-contrib   = {adinc/i01ad00598pry.i 06 cb-tp-contrib:SCREEN-VALUE IN FRAME {&FRAME-NAME}}
             c-tp-docto-aux = c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}.
             
  IF i-pais-impto-usuario = 33 /* Peru */ THEN 
     ASSIGN c-tp-docto-aux = c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}
             c-num-mtc-aux = c-num-mtc:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /*Localiza‡Æo Equador*/
  IF i-pais-impto-usuario = 21 THEN DO:
      RUN pi-retorna-valores-localiz IN h-handle-container (OUTPUT i-tipo-regime,
                                                            OUTPUT i-cdn-doc,
                                                            OUTPUT c-nro-doc,
                                                            OUTPUT h-boec012).

      IF c-nro-doc = "" THEN DO:
          IF AVAIL transporte THEN DO:
              IF NOT VALID-HANDLE(h-boec012) THEN
                  RUN local/ecu/ec2bo/boec012.p PERSISTENT SET h-boec012.
              
              RUN openQueryStatic IN h-boec012 (INPUT "Main":U).
              RUN goToKey IN h-boec012 (INPUT transporte.cod-transp).
              
              IF RETURN-VALUE = "NOK" THEN DO:
                  {utp/ut-liter.i Dados_Localiza‡Æo * }
                  run utp/ut-msgs.p (input "show",
                                     input 265,
                                     input RETURN-VALUE).
                  return "adm-error":U.
              END.
          END.
          ELSE DO:
              {utp/ut-liter.i Dados_Localiza‡Æo * }
              run utp/ut-msgs.p (input "show",
                                 input 265,
                                 input RETURN-VALUE).
              return "adm-error":U.
          END.
      END.
      ELSE
          ASSIGN transporte.cgc:screen-value in frame {&frame-name} = c-nro-doc.
  END.         

  if param-global.id-federal-obrigatorio = yes then do:
     if param-global.bloqueio-cgc = 2 then do: /** adverte **/
        if can-find(first transporte where transporte.cgc         = input frame {&frame-name} transporte.cgc
                                        and transporte.cod-transp <> c-transp) and
           (transporte.natureza:screen-value in frame {&frame-name} <> "3") and
           (transporte.natureza:screen-value in frame {&frame-name} <> "4") then do:
           run select-page in wh-container (1).

           run utp/ut-msgs.p (input "show",
                              input 27580,
                              input "").

           if return-value = 'no' then do:
             apply "entry" to transporte.cgc in frame {&frame-name}.
             return "adm-error":U.
           end.  
        end.
     end.
     else if param-global.bloqueio-cgc = 3 then do: /** bloqueia **/
        if (can-find(first transporte where transporte.cgc         = input frame {&frame-name} transporte.cgc
                                        and transporte.cod-transp <> c-transp) and
            (transporte.natureza:screen-value in frame {&frame-name} <> "3") and
            (transporte.natureza:screen-value in frame {&frame-name} <> "4")) then do:

            for first transporte 
                where transporte.cgc = input frame {&frame-name} transporte.cgc no-lock:
            end.    
            run select-page in wh-container (1).

            run utp/ut-msgs.p (input "message",
                               input 27579,
                               input transporte.nome-abrev ).
            apply "entry" to transporte.cgc in frame {&frame-name}.
            return "adm-error":U.
        end.    
     end.
     else do: /** NÆo adverte/Nem bloqueia, mas a informa‡Æo ‚ obrigat¢ria **/
          if (transporte.cgc:screen-value in frame {&frame-name} = ""          or 
              transporte.cgc:screen-value in frame {&frame-name} = ?)         and 
             (transporte.natureza:screen-value in frame {&frame-name} <> "3") and
             (transporte.natureza:screen-value in frame {&frame-name} <> "4") then do:
              run select-page in wh-container (1).                 
              run utp/ut-msgs.p (input "show", input 972, input "").
              apply 'entry' to transporte.cgc in frame {&frame-name}.
              return "adm-error":U.                   
          end.
      end.   
  end. /** CGC Obrigat¢rio **/

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  IF i-pais-impto-usuario = 9 /* Paraguai */ OR
     i-pais-impto-usuario = 33 /* Peru */   THEN DO:
      FIND FIRST transp-internac EXCLUSIVE-LOCK
           WHERE transp-internac.cod-transp = transporte.cod-transp NO-ERROR.

      IF NOT AVAIL transp-internac THEN DO:
          CREATE transp-internac.
          ASSIGN transp-internac.cod-transp = transporte.cod-transp.
      END.
      
      IF i-pais-impto-usuario = 9 THEN     
      RUN grava-campo-livre (INPUT-OUTPUT transp-internac.cod-livre-1,
                             INPUT STRING(i-tp-contrib),
                             INPUT 1).
                             
      RUN grava-campo-livre (INPUT-OUTPUT transp-internac.cod-livre-1,
                             INPUT c-tp-docto-aux,
                             INPUT 2).
                             
      IF i-pais-impto-usuario = 33 THEN
      RUN grava-campo-livre (INPUT-OUTPUT transp-internac.cod-livre-1,
                             INPUT c-num-mtc-aux,
                             INPUT 3).
  END.
  
  IF i-pais-impto-usuario = 33 THEN
     ASSIGN c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}  =  c-tp-docto-aux
            c-num-mtc :SCREEN-VALUE IN FRAME {&FRAME-NAME}   =  c-num-mtc-aux.

  IF i-pais-impto-usuario = 21 THEN DO:
      IF VALID-HANDLE (h-boec012) 
          AND c-nro-doc <> "" THEN DO:
          RUN pi-cria-dados-localiz      IN h-boec012 (INPUT transporte.cod-transp,
                                                       INPUT i-tipo-regime,
                                                       INPUT i-cdn-doc,
                                                       INPUT c-nro-doc).
          IF RETURN-VALUE = "NOK":U THEN
              RETURN "adm-error":U.
          ELSE DO:
              ASSIGN transporte.cgc:screen-value in frame {&frame-name} = c-nro-doc.
    
              RUN pi-limpa-dados-localiz IN h-handle-container.
    
          END.         
      END.
  END.
      
  /* Code placed here will execute AFTER standard behavior.    */


  /**** Atualiza‡Æo da tabela transporte-tf *****/
  &IF '{&mguni_version}' < '2.07' &THEN
      if  avail param-global then do:
         if  param-global.modulo-tf = yes then do:
    
             find first emitente where
                    emitente.cgc = transporte.cgc no-lock no-error.
             create tt-imp-transp.
             assign tt-imp-transp.nome-transp      = transporte.nome-abrev
                    tt-imp-transp.nome             = transporte.nome
                    tt-imp-transp.cgc              = transporte.cgc
                    tt-imp-transp.cod-emitente     = if avail emitente then emitente.cod-emitente else 0
                    tt-imp-transp.nome-abrev-emit  = if avail emitente then emitente.nome-abrev   else ""
                    tt-imp-transp.log-ativo        = yes
                    tt-imp-transp.log-edi          = transporte.log-edi
                    tt-imp-transp.des-ident-transp = transporte.des-ident-transp
                    tt-imp-transp.cdn-parcei-edi   = transporte.cdn-parcei-edi.
    
             if  not valid-handle(h-bosc025) then
                 run scbo/bosc025.p persistent set h-bosc025.
    
             run openQueryStatic in h-bosc025 (input "Main":U).
    
             IF  adm-new-record THEN DO: 
                 run setRecord in h-bosc025 (input table tt-imp-transp).
                 run createRecord in h-bosc025.
             END.
             ELSE DO:
                 run pi-retorna-nome-abrev in h_v10ad268 (output c-nome-abrev).
                 run EmptyRowErrors in h-bosc025.
                 run gotokey in h-bosc025(INPUT c-nome-abrev).
                 run setRecord in h-bosc025 (input table tt-imp-transp).
                 run UpdateRecord in h-bosc025. 
                 run getRowErrors in h-bosc025 (output table RowErrors).
             END.
             for each RowErrors no-lock:
                 if  RowErrors.ErrorNumber = 2 or 
                     RowErrors.ErrorNumber = 15425 or
                     RowErrors.ErrorNumber = 25311 then do:
                     RUN utp/ut-msgs.p (INPUT "show",
                                        INPUT 28001,
                                        INPUT transporte.cgc).
                     leave.
                 end.
             end.
    
             IF  VALID-HANDLE(h-bosc025) THEN 
                 DELETE PROCEDURE h-bosc025.
    
             FOR each tt-imp-transp EXCLUSIVE-LOCK:
                 delete tt-imp-transp.
             end.
         end.
      end. /* avail param-global */
  &ENDIF
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
  
  IF i-pais-impto-usuario = 9 THEN DO:
      ASSIGN cb-tp-contrib:SENSITIVE IN FRAME {&FRAME-NAME} = NO
             c-tp-docto   :SENSITIVE IN FRAME {&FRAME-NAME} = NO.
  END.
  
  IF i-pais-impto-usuario = 33 /* Peru */ THEN
    ASSIGN c-tp-docto:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           c-num-mtc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

  IF i-pais-impto-usuario = 21 THEN DO:
      run pi-habilita-localiz in h-handle-container (INPUT YES).
      RUN pi-limpa-dados-localiz IN h-handle-container.
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
  DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
  
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */

  find first param-global no-lock no-error.

  if  avail transporte then do with frame {&frame-name}: 
      assign transporte.ins-estadual:format in frame {&frame-name} = "x(18)"  
             transporte.cgc:format          in frame {&frame-name} = "x(19)".

      if  transporte.cgc <> "" then 
          if  transporte.natureza = 1 then 
              assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-pessoal no-error.
           else 
              if  transporte.natureza = 2 then 
                  assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-federal no-error.

      if  transporte.ins-estadual <> "" then       
          assign transporte.ins-estadual:format in frame {&frame-name} = "x(19)".

      /*Para a localiza‡Æo Equador nÆo ‚ necess rio formata‡Æo*/
      IF i-pais-impto-usuario = 21 THEN
          ASSIGN transporte.cgc:format          in frame {&frame-name} = "x(13)".

  end.  

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  {utp/ut-field.i mgadm transporte natureza  1}  
  display return-value @ fi-natureza with frame {&frame-name}.

  {utp/ut-field.i mgadm transporte via-transp 1}
  display return-value @ fi-via-transp with frame {&frame-name}.

  IF i-pais-impto-usuario = 9 AND NOT cb-tp-contrib:SENSITIVE IN FRAME {&FRAME-NAME} THEN
      ASSIGN i-tp-contrib   = 1
             c-tp-docto-aux = "".

  if  avail transporte then do with frame {&frame-name}:
      assign i-natureza = input frame {&frame-name} transporte.natureza
             c-cgc-aux  = transporte.cgc:screen-value.  

      IF i-pais-impto-usuario = 9 /* Paraguai */  OR
         i-pais-impto-usuario = 33 /* Peru */ THEN DO:             
          FIND FIRST transp-internac NO-LOCK
               WHERE transp-internac.cod-transp = transporte.cod-transp NO-ERROR.
         
          IF AVAIL transp-internac THEN DO:
              IF i-pais-impto-usuario = 9 AND NUM-ENTRIES(transp-internac.cod-livre-1,";") >= 1 THEN                
                  ASSIGN i-tp-contrib = INT(ENTRY(1,transp-internac.cod-livre-1,";")).

              IF i-tp-contrib = 0 THEN
                  ASSIGN i-tp-contrib = 1.
                  
             IF i-pais-impto-usuario = 9 AND NUM-ENTRIES(transp-internac.cod-livre-1,";") >= 2 THEN
                  ASSIGN c-tp-docto-aux = ENTRY(2,transp-internac.cod-livre-1,";").            
             
             IF i-pais-impto-usuario = 33 AND NUM-ENTRIES(transp-internac.cod-livre-1,";") >= 2 THEN
                  ASSIGN c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(2,transp-internac.cod-livre-1,";"). 
   
              IF i-pais-impto-usuario = 33 AND NUM-ENTRIES(transp-internac.cod-livre-1,";") >= 3 THEN
                  ASSIGN c-num-mtc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ENTRY(3,transp-internac.cod-livre-1,";").    
                  
          END.         
      END.       
  end.

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
      ASSIGN cAuxTraducao001 = {adinc/i01ad00598pry.i 03}.
      &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
          ASSIGN cb-tp-contrib:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cAuxTraducao001.
      &else
          ASSIGN cb-tp-contrib:LIST-ITEMS IN FRAME {&FRAME-NAME} = cAuxTraducao001.
      &endif
      
      ASSIGN cb-tp-contrib:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {adinc/i01ad00598pry.i 04 i-tp-contrib}
             c-tp-docto   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-tp-docto-aux.      
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ).

  /* Code placed here will execute AFTER standard behavior.    */  
  assign transporte.cgc:format          in frame {&frame-name} = "x(19)"
         transporte.ins-estadual:format in frame {&frame-name} = "x(19)".  

  if  not adm-new-record then do:
      if  input frame {&frame-name} transporte.cgc <> "" then 
          if  input frame {&frame-name} transporte.natureza = 1 then 
              assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-pessoal.
          else 
              if  input frame {&frame-name} transporte.natureza = 2 then 
                  assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-federal.

      if  input frame {&frame-name} transporte.ins-estadual <> "" then       
          assign transporte.ins-estadual:format in frame {&frame-name} = "x(19)".            

      /*Para a localiza‡Æo Equador nÆo ‚ necess rio formata‡Æo*/
      IF i-pais-impto-usuario = 21 THEN
          ASSIGN transporte.cgc:format          in frame {&frame-name} = "x(13)".

  end.         

  &if  defined(ADM-MODIFY-FIELDS) &then
    enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  IF i-pais-impto-usuario = 9 THEN DO:
      ASSIGN cb-tp-contrib:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
      APPLY "VALUE-CHANGED":U TO cb-tp-contrib IN FRAME {&FRAME-NAME}.
  END.
  
  IF i-pais-impto-usuario = 33 /* Peru*/ THEN 
      ASSIGN c-tp-docto:SENSITIVE IN FRAME {&FRAME-NAME} = YES
             c-num-mtc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

  IF i-pais-impto-usuario = 21 THEN
      run pi-habilita-localiz in h-handle-container (INPUT NO).

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
  find first param-global no-lock no-error.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign transporte.ins-municipal:hidden in frame {&frame-name} = yes
         transporte.cgc:label            in frame {&FRAME-NAME} = param-global.label-cgc.

  IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:

      c-tp-docto:load-mouse-pointer ('image/lupa.cur').

      ASSIGN cb-tp-contrib:HIDDEN IN FRAME {&FRAME-NAME} = NO
             c-tp-docto   :HIDDEN IN FRAME {&FRAME-NAME} = NO.                               

  END.
  
  IF i-pais-impto-usuario = 33 /* Peru */ THEN DO:

      c-tp-docto:load-mouse-pointer ('image/lupa.cur').

      ASSIGN c-tp-docto:HIDDEN IN FRAME {&FRAME-NAME} = NO
             c-tp-docto:SIDE-LABEL-HANDLE:ROW         = 7.25
             c-tp-docto:ROW IN FRAME {&FRAME-NAME}    = 7.25
             c-num-mtc :HIDDEN IN FRAME {&FRAME-NAME} = NO.                               

  END.

  IF i-pais-impto-usuario = 21 THEN
      ASSIGN transporte.cgc:HIDDEN IN FRAME {&FRAME-NAME} = YES.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-digito-verificador V-table-Win 
PROCEDURE pi-digito-verificador :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

/*   def var i-dig-ver  as integer . /* armazena o digito verificador informado pelo usuario */
 *    {cdp/cd9900.i1} /*definicao de variavies para calculo do cgc/cpf*/
 *    
 *    assign c-cgc      = input frame {&frame-name} transporte.cgc
 *           i-natureza = input frame {&frame-name} transporte.natureza.
 *    
 *    /* verifica se foi digitado algum caracter invalido no cgc/cpf */
 *        if  i-natureza = 2 then do:
 *            do i-cont = 1 to 14:
 *               if  not can-do("0,1,2,3,4,5,6,7,8,9",substr(c-cgc,i-cont,1))
 *                   or c-cgc = ? then do:
 *                   run utp/ut-msgs.p (input "show", input 972, input "").
 *                   run select-page in wh-container (1).                   
 *                   apply 'entry' to transporte.cgc in frame {&frame-name}.
 *                   return "adm-error":U.                                   
 *               end.
 *            end.   
 *        end.
 *        if i-natureza = 1 then do:
 *           do i-cont = 1 to 11:
 *              if  not can-do("0,1,2,3,4,5,6,7,8,9",substr(c-cgc,i-cont,1)) 
 *                  or c-cgc = ? then do:
 *                   run utp/ut-msgs.p (input "show", input 972, input "").
 *                   run select-page in wh-container (1).                                     
 *                   apply 'entry' to transporte.cgc in frame {&frame-name}.
 *                   return "adm-error":U.                                   
 *              end.
 *           end.   
 *        end.                 
 *    /*fim da verificacao de caracter invalido no cgc/cpf*/
 *        
 *    if  i-natureza = 2 then do:   /*pessoa juridica*/
 *        {cdp/cd9900.i2} /* include de calculo do digito verificador do cgc */
 *        assign i-dig-ver = dec(substring(c-cgc,18,2)).
 *    end. 
 *    
 *    assign i-cont = 0 .
 *    
 *    if  i-natureza = 1 then do:
 *        {cdp/cd9900.i3}  /* include de calculo do digito verificador do cpf */
 *        assign i-dig-ver = dec(substring(c-cgc,10,2)).
 *    end.
 *    message i-digito i-dig-ver.   
 *    IF  i-digito  <> i-dig-ver then do:
 *        if  param-global.bloqueio-cgc = 2 then do:
 *            run utp/ut-msgs.p (input "show", input 1008, input "").
 *            if  return-value = "no" then do:
 *                run select-page in wh-container (1).
 *                apply "entry" to transporte.cgc in frame {&frame-name}.
 *                return "adm-error":U.
 *            end.                            
 *        end. 
 *        
 *        if  param-global.bloqueio-cgc = 3 then do:
 *            run utp/ut-msgs.p (input "show", input 1007, input "").
 *            run select-page in wh-container (1).
 *            apply "entry" to transporte.cgc in frame {&frame-name}.
 *            return "adm-error":U.
 *        end.                            
 *    end. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-hv10ad268 as handle NO-UNDO.

  assign h_v10ad268 = p-hv10ad268.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-pega-valor-natureza V-table-Win 
PROCEDURE pi-pega-valor-natureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter i-nat-aux     like transporte.natureza.

assign i-nat-aux = INT(transporte.natureza:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle-container V-table-Win 
PROCEDURE pi-recebe-handle-container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-container as handle no-undo.

assign h-handle-container  = h-container.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF VAR c-inscricao  AS CHAR NO-UNDO.
    DEF VAR c-unid-feder AS CHAR NO-UNDO.
    DEF VAR i-contador   AS INT  NO-UNDO.
    DEF VAR l-letras     AS LOG  NO-UNDO.

    {include/i-vldfrm.i}
	
    IF i-pais-impto-usuario = 1 THEN DO:  
       /** Valida Formato CPF - transporte-cgc **/
       IF i-natureza = 1 THEN DO: /*CPF*/
          IF transporte.cgc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "X" THEN
             ASSIGN transporte.cgc:FORMAT IN FRAME {&FRAME-NAME} = "X(20)":U.
          ELSE
             ASSIGN transporte.cgc:FORMAT IN FRAME {&FRAME-NAME} =  param-global.formato-id-pessoal
             c-formato-cgc = INPUT FRAME {&FRAME-NAME} transporte.cgc NO-ERROR.			   	
          
          /** Valida digitação CPF **/	
          IF LENGTH(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(transporte.cgc:SCREEN-VALUE, ".", ""), "-", ""), "/", ""), " ", ""))) <> 11 THEN DO:	   
             {include/i-vldprg.i}	   
              RUN utp/ut-msgs.p ("show", 2744, "").	   
              APPLY "ENTRY" TO transporte.cgc IN FRAME {&FRAME-NAME}.	   
              RETURN 'ADM-ERROR':U.	
          END.
       END. 
        
       /** Valida Formato CNPJ - transporte-cgc **/
       IF i-natureza = 2 THEN DO: /*CNPJ*/
          IF transporte.cgc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "X" THEN
             ASSIGN transporte.cgc:FORMAT IN FRAME {&FRAME-NAME} = "X(20)":U.
          ELSE
             assign transporte.cgc:FORMAT IN FRAME {&FRAME-NAME} =  param-global.formato-id-federal
                    c-formato-cgc = INPUT FRAME {&FRAME-NAME} transporte.cgc NO-ERROR.			
              
          /** Valida digitação CNPJ **/	
          IF LENGTH(TRIM(REPLACE(REPLACE(REPLACE(REPLACE(transporte.cgc:SCREEN-VALUE, ".", ""), "-", ""), "/", ""), " ", ""))) <> 14 THEN DO:
             {include/i-vldprg.i}
              RUN utp/ut-msgs.p ("show", 2744, "").
              APPLY "ENTRY" TO transporte.cgc IN FRAME {&FRAME-NAME}.
              RETURN 'ADM-ERROR':U.	
          END.
          
          /* Forçar letras para maiúsculo */
          ASSIGN transporte.cgc:SCREEN-VALUE = CAPS(transporte.cgc:SCREEN-VALUE).	
       END.              
       ELSE
          ASSIGN transporte.cgc:FORMAT IN FRAME {&FRAME-NAME} =  "x(19)"
                 c-formato-cgc = INPUT FRAME {&FRAME-NAME} transporte.cgc NO-ERROR.
    END.
			  		  
    find first param-global no-lock no-error.
    if   avail param-global then do:
         find empresa where empresa.ep-codigo = param-global.empresa-prin 
                            no-lock no-error.
         if   avail empresa and empresa.pais = "Brasil" 
         then do  on error undo, return 'adm-error':
         if input frame {&frame-name} transporte.natureza = 1 then
            run cdp/cd6666.p (input input frame {&FRAME-NAME} transporte.cgc, input 1).
         if input frame {&frame-name} transporte.natureza = 2 then
            run cdp/cd6666.p (input input frame {&FRAME-NAME} transporte.cgc, input 2).

         if  return-value = 'NOK' then do:
             {include/i-vldprg.i}
             apply 'entry' to transporte.cgc in frame {&frame-name}.
             return "adm-error":U.
         end.
         end.
    end.    

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                  INPUT "estado").             
    ASSIGN c-unid-feder = TRIM(RETURN-VALUE).

    IF  AVAIL param-global
    AND AVAIL empresa
    AND INPUT  FRAME {&FRAME-NAME} transporte.natureza = 2
    AND i-pais-impto-usuario                           = 1 /* Brasil */
    AND INPUT FRAME {&frame-name} transporte.ins-estadual <> 'Isento'
    AND INPUT FRAME {&frame-name} transporte.ins-estadual <> 'Isento' THEN DO:
        /* Verifica a existencia de letras na inscricao estadual */
        ASSIGN c-inscricao = INPUT FRAME {&frame-name} transporte.ins-estadual.
        DO  i-contador = 1 TO LENGTH(c-inscricao):
            IF  c-unid-feder = "SP" THEN DO:
                ASSIGN l-letras = NO.
                IF  R-INDEX("ABCDEFGHIJKLMNOQRSTUVWXYZ",SUBSTR(c-inscricao,i-contador,1)) > 0 THEN DO:
                    ASSIGN l-letras = YES.
                    LEAVE.
                END.
            END.
            ELSE DO:
                ASSIGN l-letras = NO.
                IF  R-INDEX("ABCDEFGHIJKLMNOPQRSTUVWXYZ",SUBSTR(c-inscricao,i-contador,1)) > 0 THEN DO:
                    ASSIGN l-letras = YES.
                    LEAVE.
                END.
            END.
        END.
        IF  l-letras THEN DO:
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 25652,
                               INPUT "").
            IF  RETURN-VALUE = 'no':U THEN DO:                                   
                APPLY 'ENTRY':U TO transporte.ins-estadual IN FRAME {&frame-name}.
                RETURN 'ADM-ERROR':U.
            END.
        END.

        DEF VAR c-cod-erro     AS CHAR NO-UNDO.
        DEF VAR c-cod-ie-sai   AS CHAR NO-UNDO.
        DEF VAR i-num-mensagem AS INT  NO-UNDO.

        RUN cdp/cd6667.p(INPUT  empresa.pais,
                         INPUT  c-unid-feder,
                         INPUT  INPUT FRAME {&frame-name} transporte.ins-estadual,
                         OUTPUT c-cod-erro,
                         OUTPUT c-cod-ie-sai).
         
        IF  c-cod-erro <> "OK" THEN DO:                         
            IF  c-cod-erro = "ERRO FORMATO" THEN
                ASSIGN i-num-mensagem = IF   param-global.id-estadual-obrigatorio = NO
                                        THEN 19101
                                        ELSE 19104.
            ELSE
                IF  c-cod-erro = "ERRO PRIM DIG" then
                    ASSIGN i-num-mensagem = IF   param-global.id-estadual-obrigatorio = NO
                                            THEN 19102
                                            ELSE 19105.
                ELSE
                    ASSIGN i-num-mensagem = IF   param-global.id-estadual-obrigatorio = NO
                                            THEN 19103
                                            ELSE 19106.    
            {include/i-vldprg.i}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT i-num-mensagem,
                               INPUT "").
            IF  param-global.id-estadual-obrigatorio = NO THEN DO:
                IF  RETURN-VALUE = 'no':U THEN DO:                                   
                    APPLY 'entry':U TO transporte.ins-estadual IN FRAME {&frame-name}.
                    RETURN 'ADM-ERROR':U.
                END.
            END.    
            ELSE DO:
                APPLY 'entry':U TO transporte.ins-estadual IN FRAME {&frame-name}.
                RETURN 'ADM-ERROR':U.                                      
            END.    
        END.    
    END.

    IF i-pais-impto-usuario = 9 /* Paraguai */ THEN DO:
        IF {adinc/i01ad00598pry.i 06 cb-tp-contrib:SCREEN-VALUE IN FRAME {&FRAME-NAME}} = 2 THEN DO: 
             
            IF c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
                {utp/ut-liter.i "Tipo Documento" *}
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 265,
                                   INPUT TRIM(RETURN-VALUE)). /* &1 deve ser informado(a). */
                APPLY 'ENTRY':U TO c-tp-docto IN FRAME {&frame-name}.
                RETURN 'ADM-ERROR':U.
            END.
            ELSE DO:
                IF NOT CAN-FIND (FIRST internac-tipo-docto-ident 
                                 WHERE internac-tipo-docto-ident.cod-tip-docto-ident = c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
                    {utp/ut-liter.i "Tipo Documento" *}
                    RUN utp/ut-msgs.p (INPUT "show",
                                       INPUT 7488,
                                       INPUT TRIM(RETURN-VALUE)). /*    &1 nÆo existe */
                    APPLY 'ENTRY':U TO c-tp-docto IN FRAME {&frame-name}.
                    RETURN 'ADM-ERROR':U.
                END.
            END.
        END.
    END.
    
    IF i-pais-impto-usuario = 33 /* Peru */ THEN DO:         
             
        IF c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN DO:
            {utp/ut-liter.i "Tipo Documento" *}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 265,
                               INPUT TRIM(RETURN-VALUE)). /* &1 deve ser informado(a). */
            APPLY 'ENTRY':U TO c-tp-docto IN FRAME {&frame-name}.
            RETURN 'ADM-ERROR':U.
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST internac-tipo-docto-ident 
                             WHERE internac-tipo-docto-ident.cod-tip-docto-ident = c-tp-docto:SCREEN-VALUE IN FRAME {&FRAME-NAME}) THEN DO:
                {utp/ut-liter.i "Tipo Documento" *}
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 7488,
                                   INPUT TRIM(RETURN-VALUE)). /*    &1 nÆo existe */
                APPLY 'ENTRY':U TO c-tp-docto IN FRAME {&frame-name}.
                RETURN 'ADM-ERROR':U.
            END.
        END.
       
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
  {src/adm/template/snd-list.i "transporte"}

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

  IF p-state = "add-record"  OR
     p-state = "update-begin"  THEN DO:
       assign transporte.cgc:format in frame {&frame-name} = param-global.formato-id-pessoal
              transporte.ins-estadual:format in frame {&frame-name} = "x(19)".

       /*Para a localiza‡Æo Equador nÆo ‚ necess rio formata‡Æo*/
       IF i-pais-impto-usuario = 21 THEN
           ASSIGN transporte.cgc:format          in frame {&frame-name} = "x(13)".

  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

