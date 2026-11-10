&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-window 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM3001B 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i im3001b MIM}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */
DEF INPUT PARAM v-row-table   AS ROWID         NO-UNDO. 
DEF INPUT PARAM p-cod-despesa AS INT           NO-UNDO.
DEF INPUT PARAM p-val-despesa AS DEC           NO-UNDO.

/* Local Variable Definitions ---                                       */
DEF VAR hProgramZoom   AS HANDLE                      NO-UNDO.
DEF VAR de-cotacao   LIKE cotacao.cotacao[0]          NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE JanelaDetalhe
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-4 i-cod-emitente i-cond-pagto ~
i-moeda-desp de-val-despesa bt-ok bt-cancelar bt-ajuda 
&Scoped-Define DISPLAYED-OBJECTS i-cod-despesa c-desc-desp i-cod-emitente ~
c-desc-emitente i-cond-pagto c-desc-cond-pagto i-moeda-desp ~
c-desc-moeda-despesa de-val-despesa i-moeda-docto c-desc-moeda-docto ~
de-val-documento 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-window AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-cancelar AUTO-END-KEY 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-desc-cond-pagto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-desp AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 31.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-moeda-docto AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 34.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-val-despesa AS DECIMAL FORMAT ">>,>>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Valor Despesa":R20 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88.

DEFINE VARIABLE de-val-documento AS DECIMAL FORMAT ">>>,>>>,>>>,>>9.99999" INITIAL 0 
     LABEL "Valor Despesa Moeda Documento":R12 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88.

DEFINE VARIABLE i-cod-despesa AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Despesa":R9 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE i-cod-emitente AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente":R10 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88.

DEFINE VARIABLE i-cond-pagto AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Condiá∆o Pagamento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE i-moeda-desp AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda Despesa" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE i-moeda-docto AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Moeda Documento" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 75 BY 1.38
     BGCOLOR 7 .

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75 BY 7.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     i-cod-despesa AT ROW 1.54 COL 25 COLON-ALIGNED HELP
          "Informe o c¢digo da despesa"
     c-desc-desp AT ROW 1.54 COL 31.29 COLON-ALIGNED NO-LABEL
     i-cod-emitente AT ROW 2.54 COL 25 COLON-ALIGNED
     c-desc-emitente AT ROW 2.54 COL 36.72 COLON-ALIGNED NO-LABEL
     i-cond-pagto AT ROW 3.54 COL 25 COLON-ALIGNED
     c-desc-cond-pagto AT ROW 3.54 COL 30.29 COLON-ALIGNED NO-LABEL
     i-moeda-desp AT ROW 4.54 COL 25 COLON-ALIGNED
     c-desc-moeda-despesa AT ROW 4.54 COL 28.29 COLON-ALIGNED NO-LABEL
     de-val-despesa AT ROW 5.54 COL 25 COLON-ALIGNED HELP
          "Valor Despesa Aduana COFINS"
     i-moeda-docto AT ROW 6.54 COL 25 COLON-ALIGNED
     c-desc-moeda-docto AT ROW 6.54 COL 28.29 COLON-ALIGNED NO-LABEL
     de-val-documento AT ROW 7.54 COL 25 COLON-ALIGNED HELP
          "Valor Despesa Aduana PIS"
     bt-ok AT ROW 9.13 COL 3
     bt-cancelar AT ROW 9.13 COL 14
     bt-ajuda AT ROW 9.13 COL 66.14
     RECT-1 AT ROW 8.92 COL 2.14
     RECT-4 AT ROW 1.25 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 76.86 BY 9.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: JanelaDetalhe
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-window ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 9.46
         WIDTH              = 77
         MAX-HEIGHT         = 21.13
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.13
         VIRTUAL-WIDTH      = 114.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-window 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-window.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-window
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
                                                                        */
/* SETTINGS FOR FILL-IN c-desc-cond-pagto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-desp IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda-despesa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-moeda-docto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-val-documento IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-despesa IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-moeda-docto IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
THEN w-window:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-window
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON END-ERROR OF w-window
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-window w-window
ON WINDOW-CLOSE OF w-window
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda w-window
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-cancelar w-window
ON CHOOSE OF bt-cancelar IN FRAME F-Main /* Cancelar */
DO:
  apply "close":U to this-procedure.
  RETURN "NOK".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok w-window
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    RUN pi-validate.
    IF  RETURN-VALUE = 'NOK' THEN
        RETURN NO-APPLY.
    
    FIND FIRST docum-est-cex EXCLUSIVE-LOCK
         WHERE docum-est-cex.serie-docto  = item-doc-est.serie-docto
           AND docum-est-cex.nro-docto    = item-doc-est.nro-docto
           AND docum-est-cex.cod-emitente = item-doc-est.cod-emitente
           AND docum-est-cex.nat-operacao = item-doc-est.nat-operacao
           AND docum-est-cex.cod-desp     = p-cod-despesa NO-ERROR.
    IF  NOT AVAIL docum-est-cex THEN DO:
        IF  INPUT FRAME F-Main i-moeda-desp <> 0 THEN DO:
            FIND FIRST cotacao NO-LOCK
                 WHERE cotacao.mo-codigo   = INPUT FRAME F-Main i-moeda-desp
                   AND cotacao.ano-periodo = STRING(YEAR(TODAY)) + 
                                             STRING(MONTH(TODAY),"99")
                   AND cotacao.cotacao[INT(DAY(TODAY))] <> 0 NO-ERROR.
            ASSIGN de-cotacao = IF AVAIL cotacao THEN
                                   cotacao.cotacao[INT(DAY(TODAY))]
                                ELSE 1.
        END.
        ELSE 
            ASSIGN de-cotacao = 1.
        
        CREATE docum-est-cex.
        ASSIGN docum-est-cex.serie-docto       = item-doc-est.serie-docto
               docum-est-cex.nro-docto         = item-doc-est.nro-docto
               docum-est-cex.cod-emitente      = item-doc-est.cod-emitente
               docum-est-cex.nat-operacao      = item-doc-est.nat-operacao
               docum-est-cex.cod-desp          = p-cod-despesa
               docum-est-cex.cod-emitente-desp = INPUT FRAME F-Main i-cod-emitente
               docum-est-cex.cod-cond-pag      = INPUT FRAME F-Main i-cond-pagto
               docum-est-cex.cotacao           = de-cotacao
               docum-est-cex.mo-codigo         = INPUT FRAME F-Main i-moeda-desp.
    END.

    IF  NOT AVAIL item-doc-est-cex THEN DO:
        CREATE item-doc-est-cex.
        ASSIGN item-doc-est-cex.sequencia         = item-doc-est.sequencia
               item-doc-est-cex.serie-docto       = docum-est-cex.serie-docto
               item-doc-est-cex.nro-docto         = docum-est-cex.nro-docto
               item-doc-est-cex.cod-emitente      = docum-est-cex.cod-emitente
               item-doc-est-cex.nat-operacao      = docum-est-cex.nat-operacao
               item-doc-est-cex.cod-desp          = docum-est-cex.cod-desp
               item-doc-est-cex.cod-emitente-desp = docum-est-cex.cod-emitente-desp
               item-doc-est-cex.cotacao           = docum-est-cex.cotacao
               item-doc-est-cex.mo-codigo         = docum-est-cex.mo-codigo.
    END.
    
    ASSIGN docum-est-cex.val-desp = docum-est-cex.val-desp - item-doc-est-cex.val-desp
                                                           + INPUT FRAME F-Main de-val-despesa.
    
    ASSIGN item-doc-est-cex.val-desp = INPUT FRAME F-Main de-val-despesa.
    
    APPLY "close":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME de-val-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL de-val-despesa w-window
ON LEAVE OF de-val-despesa IN FRAME F-Main /* Valor Despesa */
DO:
    
    RUN cdp/cd0812.p (INPUT  INPUT FRAME F-Main i-moeda-desp,
                      INPUT  INPUT FRAME F-Main i-moeda-docto,
                      INPUT  INPUT FRAME F-Main de-val-despesa,
                      INPUT  TODAY,
                      OUTPUT de-val-documento).
    ASSIGN de-val-documento:SCREEN-VALUE IN FRAME F-Main = STRING(de-val-documento).
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-despesa w-window
ON LEAVE OF i-cod-despesa IN FRAME F-Main /* Despesa */
DO:
  {include/leave.i &tabela=despesa
                   &atributo-ref=des-despesa
                   &variavel-ref=c-desc-desp
                   &where="despesa.cod-despesa = input frame {&frame-name} i-cod-despesa"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente w-window
ON F5 OF i-cod-emitente IN FRAME F-Main /* Emitente */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z07ad098.w
                     &campo=i-cod-emitente
                     &campozoom=cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente w-window
ON LEAVE OF i-cod-emitente IN FRAME F-Main /* Emitente */
DO:
  {include/leave.i &tabela=emitente
                   &atributo-ref=nome-abrev
                   &variavel-ref=c-desc-emitente
                   &where="emitente.cod-emitente = input frame {&frame-name} i-cod-emitente"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-emitente w-window
ON MOUSE-SELECT-DBLCLICK OF i-cod-emitente IN FRAME F-Main /* Emitente */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cond-pagto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cond-pagto w-window
ON F5 OF i-cond-pagto IN FRAME F-Main /* Condiá∆o Pagamento */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad039.w
                     &campo=i-cond-pagto
                     &campozoom=cod-cond-pag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cond-pagto w-window
ON LEAVE OF i-cond-pagto IN FRAME F-Main /* Condiá∆o Pagamento */
DO:
  {include/leave.i &tabela=cond-pagto
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-cond-pagto
                   &where="cond-pagto.cod-cond-pag = input frame {&frame-name} i-cond-pagto"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cond-pagto w-window
ON MOUSE-SELECT-DBLCLICK OF i-cond-pagto IN FRAME F-Main /* Condiá∆o Pagamento */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-desp w-window
ON F5 OF i-moeda-desp IN FRAME F-Main /* Moeda Despesa */
DO:
  {include/zoomvar.i &prog-zoom=adzoom/z01ad178.w
                     &campo=i-moeda-desp
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-desp w-window
ON LEAVE OF i-moeda-desp IN FRAME F-Main /* Moeda Despesa */
DO:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-moeda-despesa
                   &where="moeda.mo-codigo = input frame {&frame-name} i-moeda-desp"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-desp w-window
ON MOUSE-SELECT-DBLCLICK OF i-moeda-desp IN FRAME F-Main /* Moeda Despesa */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda-docto w-window
ON LEAVE OF i-moeda-docto IN FRAME F-Main /* Moeda Documento */
DO:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-moeda-docto
                   &where="moeda.mo-codigo = input frame {&frame-name} i-moeda-docto"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-window 


/* ***************************  Main Block  *************************** */

i-cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME F-Main.
i-cond-pagto:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME F-Main.
i-moeda-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME F-Main.

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-window  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-window  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-window  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-window)
  THEN DELETE WIDGET w-window.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-window  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY i-cod-despesa c-desc-desp i-cod-emitente c-desc-emitente i-cond-pagto 
          c-desc-cond-pagto i-moeda-desp c-desc-moeda-despesa de-val-despesa 
          i-moeda-docto c-desc-moeda-docto de-val-documento 
      WITH FRAME F-Main IN WINDOW w-window.
  ENABLE RECT-1 RECT-4 i-cod-emitente i-cond-pagto i-moeda-desp de-val-despesa 
         bt-ok bt-cancelar bt-ajuda 
      WITH FRAME F-Main IN WINDOW w-window.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW w-window.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-window 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-window 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   
   RETURN.
       
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-window 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  
{utp/ut9000.i "IM3001B" "2.00.00.000"}
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  ASSIGN i-cod-despesa:SCREEN-VALUE IN FRAME F-Main = STRING(p-cod-despesa).
  
  FIND FIRST item-doc-est NO-LOCK
       WHERE ROWID(item-doc-est) = v-row-table NO-ERROR.
  FIND FIRST docum-est OF item-doc-est NO-LOCK NO-ERROR.
  
  /* ***** Verifica se j† houve alguma inclus∆o para a chave ***** */
  FIND FIRST docum-est-cex NO-LOCK
       WHERE docum-est-cex.serie-docto  = item-doc-est.serie-docto
         AND docum-est-cex.nro-docto    = item-doc-est.nro-docto
         AND docum-est-cex.cod-emitente = item-doc-est.cod-emitente
         AND docum-est-cex.nat-operacao = item-doc-est.nat-operacao
         AND docum-est-cex.cod-desp     = p-cod-despesa NO-ERROR.
  IF  AVAIL docum-est-cex THEN DO:
      ASSIGN i-cod-emitente:SCREEN-VALUE IN FRAME F-Main = STRING(docum-est-cex.cod-emitente-desp)
             i-cod-emitente:SENSITIVE    IN FRAME F-Main = NO.
      
      ASSIGN i-cond-pagto:SCREEN-VALUE IN FRAME F-Main = STRING(docum-est-cex.cod-cond-pag).
      
      /* ***** Se Encontrar item indica que Ç Alteraá∆o ***** */
      FIND FIRST item-doc-est-cex
           WHERE item-doc-est-cex.sequencia     = item-doc-est.sequencia
             AND item-doc-est-cex.serie-docto   = docum-est-cex.serie-docto
             AND item-doc-est-cex.nro-docto     = docum-est-cex.nro-docto
             AND item-doc-est-cex.cod-emitente  = docum-est-cex.cod-emitente
             AND item-doc-est-cex.nat-operacao  = docum-est-cex.nat-operacao
             AND item-doc-est-cex.cod-desp      = p-cod-despesa EXCLUSIVE-LOCK NO-ERROR.
      
      IF  AVAIL item-doc-est-cex THEN DO:
          ASSIGN i-moeda-desp  :SCREEN-VALUE IN FRAME F-Main = STRING(item-doc-est-cex.mo-codigo).
          
          DISABLE i-cond-pagto i-moeda-desp WITH FRAME F-Main.
      END.
      ELSE
          ASSIGN i-moeda-desp:SCREEN-VALUE IN FRAME F-Main = STRING(docum-est-cex.mo-codigo).
  END.
  ELSE
      ASSIGN i-moeda-desp:SCREEN-VALUE IN FRAME F-Main = STRING(docum-est.mo-codigo).
  
  ASSIGN i-moeda-docto:SCREEN-VALUE IN FRAME F-Main = STRING(docum-est.mo-codigo).
  
  RUN cdp/cd0812.p (INPUT  INPUT FRAME F-Main i-moeda-docto,
                    INPUT  INPUT FRAME F-Main i-moeda-desp,
                    INPUT  p-val-despesa,
                    INPUT  TODAY,
                    OUTPUT de-val-despesa).
  
  ASSIGN de-val-documento:SCREEN-VALUE IN FRAME F-Main = STRING(p-val-despesa)
         de-val-despesa:SCREEN-VALUE IN FRAME F-Main = STRING(de-val-despesa).
  
  APPLY 'leave' TO i-cod-despesa  IN FRAME F-Main.
  APPLY 'leave' TO i-cod-emitente IN FRAME F-Main.
  APPLY 'leave' TO i-cond-pagto   IN FRAME F-Main.
  APPLY 'leave' TO i-moeda-desp   IN FRAME F-Main.
  APPLY 'leave' TO i-moeda-docto  IN FRAME F-Main.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate w-window 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF  NOT CAN-FIND(FIRST emitente
                   WHERE emitente.cod-emitente = INPUT FRAME F-Main i-cod-emitente) THEN DO:
      {utp/ut-table.i mgind emitente 1}
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
      RETURN 'NOK'.
  END.
  
  IF  NOT CAN-FIND(FIRST cond-pagto
                   WHERE cond-pagto.cod-cond-pag = INPUT FRAME F-Main i-cond-pagto) THEN DO:
      {utp/ut-table.i mgadm cond-pagto 1}
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
      RETURN 'NOK'.
  END.
  
  IF  NOT CAN-FIND(FIRST moeda
                   WHERE moeda.mo-codigo = INPUT FRAME F-Main i-moeda-desp) THEN DO:
      {utp/ut-table.i mguni moeda 1}
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
      RETURN 'NOK'.
  END.
  
  IF  INPUT FRAME F-Main de-val-despesa = 0 THEN DO:
      RUN utp/ut-msgs.p (INPUT "show":U, INPUT 206, INPUT RETURN-VALUE).
      RETURN 'NOK'.
  END.
  
  RETURN 'OK'.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-window  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this JanelaDetalhe, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-window 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

