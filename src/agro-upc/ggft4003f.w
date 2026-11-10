&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS W-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGFT4003F 2.00.00.016 } /*** "010016" 04/12/2025 09:01:53 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ggft4003f GGP}
&ENDIF


/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  History: 
          
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

/* Parameters Definitions ---                                           */


/* Local Variable Definitions ---                                       */
DEF INPUT PARAM c-nome-tabela AS CHAR FORMAT "X(15)" .
DEF INPUT PARAM l-habilita    AS LOGICAL.
DEF INPUT PARAM rw-documento  AS ROWID.

{utp/ut-glob.i}

DEF VAR c-local     AS CHAR FORMAT "x(08)". 
DEF VAR c-tipo      AS CHAR FORMAT "x(10)".  
DEF VAR c-erro      AS c. 
DEF VAR c-mensagem AS CHAR FORMAT "x(50)".

DEF VAR c-num-docto AS c. 
DEF VAR c-estabel   LIKE nota-fiscal.cod-estabel INIT "".
DEF VAR c-serie     LIKE nota-fiscal.serie INIT "".
DEF VAR c-nat       LIKE nota-fiscal.nat-operacao INIT "".
DEF VAR i-emit      LIKE emitente.cod-emitente init 0.
DEF VAR i-sequencia AS INTEGER NO-UNDO.
DEF VAR de-liquido  AS DECIMAL NO-UNDO. 
DEF VAR hProgramZoom AS HANDLE NO-UNDO.

DEF VAR r-row-tt-class AS ROWID. 
DEF VAR wh-pesquisa    AS WIDGET-HANDLE.

DEF TEMP-TABLE tt-class NO-UNDO LIKE gg-classifica
    FIELD desc-exame  AS CHARACTER FORMAT "X(30)"
    INDEX ch-pri AS PRIMARY ind-local cod-exame cod-comp.

DEF BUFFER b-tt-clas FOR tt-class.

if not connected ('emsgra':U) then
	return "OK":U.
else IF NOT can-find( FIRST param-global WHERE param-global.log-modul-gg = yes) then
    return "OK":U. 

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-class

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table fn-local(tt-class.ind-local) @ c-local tt-class.desc-exame tt-class.des-resultado tt-class.cod-exame tt-class.seq-comp fn-tipo(tt-class.tipo-result) @ c-tipo tt-class.cod-usu-clas   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-class
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-class.
&Scoped-define TABLES-IN-QUERY-br-table tt-class
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-class


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS c-resultado bt-Mod br-table bt-classificador ~
bt-ajuda bt-ok bt-cancela RECT-7 RECT-8 rt-buttom 
&Scoped-Define DISPLAYED-OBJECTS c-resultado de-peso-desc de-peso-liq ~
c-text-2 c-text 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-local W-Win 
FUNCTION fn-local RETURNS CHARACTER
  ( i-local AS int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fn-tipo W-Win 
FUNCTION fn-tipo RETURNS CHARACTER
  ( i-tipo AS int )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR W-Win AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-ajuda 
     LABEL "&Ajuda" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 FONT 4.

DEFINE BUTTON bt-classificador 
     IMAGE-UP FILE "image/im-clean.bmp":U
     LABEL "C&lassificador" 
     SIZE 4 BY 1 TOOLTIP "Informar Classificador".

DEFINE BUTTON bt-Mod 
     IMAGE-UP FILE "IMAGE/im-chck1.bmp":U
     LABEL "&Modificar" 
     SIZE 4.57 BY 1.

DEFINE BUTTON bt-ok 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-resultado AS CHARACTER FORMAT "X(30)":U 
     LABEL "Res" 
     VIEW-AS FILL-IN 
     SIZE 18.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-text AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-text-2 AS CHARACTER FORMAT "X(15)":U 
      VIEW-AS TEXT 
     SIZE 15.29 BY .67 NO-UNDO.

DEFINE VARIABLE de-peso-desc AS DECIMAL FORMAT "->>,>>>,>>9.9999":U INITIAL 0 
     LABEL "Desc" 
     VIEW-AS FILL-IN 
     SIZE 11.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-peso-liq AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Liq - Desc" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 1.46.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 71 BY 1.21.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 70.72 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-class SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table W-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      fn-local(tt-class.ind-local) @ c-local COLUMN-LABEL "Loc" WIDTH 5
      tt-class.desc-exame    COLUMN-LABEL "Descriá∆o" 
      tt-class.des-resultado FORMAT "X(30)":U
      tt-class.cod-exame     FORMAT ">>>>>9":U
      tt-class.seq-comp      COLUMN-LABEL "Comp" FORMAT ">>9":U 
      fn-tipo(tt-class.tipo-result) @ c-tipo COLUMN-LABEL "Tipo Res."
      tt-class.cod-usu-clas  FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 71 BY 7.21
         FONT 4 ROW-HEIGHT-CHARS .5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     c-resultado AT ROW 1.17 COL 44 COLON-ALIGNED
     bt-Mod AT ROW 1.08 COL 64.86
     br-table AT ROW 2.25 COL 1
     bt-classificador AT ROW 9.83 COL 2.43
     de-peso-desc AT ROW 9.92 COL 10.14 COLON-ALIGNED
     de-peso-liq AT ROW 9.96 COL 52.72 COLON-ALIGNED
     bt-ajuda AT ROW 11.58 COL 60.14
     bt-ok AT ROW 11.63 COL 2
     bt-cancela AT ROW 11.63 COL 13
     c-text-2 AT ROW 1.25 COL 3 NO-LABEL
     c-text AT ROW 1.29 COL 3 NO-LABEL
     RECT-7 AT ROW 9.63 COL 1
     RECT-8 AT ROW 1 COL 1
     rt-buttom AT ROW 11.38 COL 1.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 71.72 BY 12.33
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Classificaá∆o"
         HEIGHT             = 12.29
         WIDTH              = 71.72
         MAX-HEIGHT         = 40.5
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 40.5
         VIRTUAL-WIDTH      = 182.86
         MAX-BUTTON         = no
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = no
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB W-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW W-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME F-Main
   FRAME-NAME Custom                                                    */
/* BROWSE-TAB br-table bt-Mod F-Main */
/* SETTINGS FOR FILL-IN c-text IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-text-2 IN FRAME F-Main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN de-peso-desc IN FRAME F-Main
   NO-ENABLE                                                            */
ASSIGN 
       de-peso-desc:HIDDEN IN FRAME F-Main           = TRUE.

/* SETTINGS FOR FILL-IN de-peso-liq IN FRAME F-Main
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
THEN W-Win:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-table
/* Query rebuild information for BROWSE br-table
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-class.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Query            is OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Classificaá∆o */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Classificaá∆o */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME br-table
&Scoped-define SELF-NAME br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON MOUSE-SELECT-CLICK OF br-table IN FRAME F-Main
DO:
  RUN pi-texto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON ROW-ENTRY OF br-table IN FRAME F-Main
DO:
  /* This code displays initial values for newly added or copied rows. */
  {src/adm/template/brsentry.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON ROW-LEAVE OF br-table IN FRAME F-Main
DO:
    /* Do not disable this code or no updates will take place except
     by pressing the Save button on an Update SmartPanel. */
   /*{src/adm/template/brsleave.i}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-table W-Win
ON VALUE-CHANGED OF br-table IN FRAME F-Main
DO:
  /* This ADM trigger code must be preserved in order to notify other
     objects when the browser's current row changes. */
  {src/adm/template/brschnge.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ajuda W-Win
ON CHOOSE OF bt-ajuda IN FRAME F-Main /* Ajuda */
OR HELP OF FRAME {&FRAME-NAME}
DO: /* Call Help Function (or a simple message). */
  {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-classificador
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-classificador W-Win
ON CHOOSE OF bt-classificador IN FRAME F-Main /* Classificador */
DO:
   FIND FIRST tt-class NO-LOCK NO-ERROR.
   IF  AVAIL tt-class THEN DO:
       RUN agro-upc/ggft4003g.w(INPUT-OUTPUT TABLE tt-class ,
                                INPUT c-nome-tabela ).
       
       {&OPEN-QUERY-{&BROWSE-NAME}}
       RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) . 
       RUN pi-texto.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-Mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Mod W-Win
ON CHOOSE OF bt-Mod IN FRAME F-Main /* Modificar */
DO:
   DEFINE VARIABLE lAchou AS LOGICAL   NO-UNDO.
   IF  AVAIL tt-class THEN DO:

       /* Cadastro de Classificaá∆o e Tabela de Resultado estiver marcada */
       IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:

           FIND FIRST gg-exame NO-LOCK
                WHERE gg-exame.cod-exame = tt-class.cod-exame NO-ERROR.
           ASSIGN lAchou = AVAIL gg-exame.

           IF  lAchou THEN
               RUN pi-valida-assign-novo.
       END.
       ELSE DO:

           FIND FIRST comp-exame NO-LOCK
                WHERE comp-exame.cod-exame = tt-class.cod-exame
                  AND comp-exame.cod-comp  = tt-class.cod-comp NO-ERROR.
           ASSIGN lAchou = AVAIL comp-exame.

           IF  lAchou THEN
               RUN pi-valida-assign.
       END.

       IF  lAchou THEN DO:
           APPLY "entry" TO BROWSE br-table.
           RUN pi-display-total.
       END.
       ELSE DO:
          APPLY "entry" TO BROWSE br-table.
          RUN pi-display-total.
       END.

       FIND NEXT tt-class NO-ERROR.
       IF AVAIL tt-class THEN DO:
          APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
          RUN pi-texto.
       END.
   END.
   RUN pi-display-total.
   
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-Mod W-Win
ON RETURN OF bt-Mod IN FRAME F-Main /* Modificar */
DO:
  APPLY "choose" TO bt-mod IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok W-Win
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
    IF l-habilita = YES THEN DO: 
       RUN pi-atualiza-gg-clas.
       RUN pi-valida-class.
       IF RETURN-VALUE = "NOK":U THEN
           RETURN NO-APPLY.
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-resultado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-resultado W-Win
ON ENTRY OF c-resultado IN FRAME F-Main /* Res */
DO:
    
    IF NOT AVAIL tt-class THEN DO:
         APPLY "entry" TO BROWSE br-table.
         RUN pi-texto.
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-resultado W-Win
ON f5 OF c-resultado IN FRAME F-Main /* Res */
DO:
     
    IF  AVAIL tt-class THEN DO:

        /* Cadastro de Classificaá∆o e Tabela de Resultado estiver marcada */
        IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:

            FIND FIRST gg-exame NO-LOCK
                 WHERE gg-exame.cod-exame = tt-class.cod-exame NO-ERROR.
            IF  AVAIL gg-exame THEN DO:
                IF  gg-exame.tipo-result = 2 THEN DO:
                    FIND FIRST gg-tab-resultado NO-LOCK
                         WHERE gg-tab-resultado.nr-tabela = gg-exame.nr-tabela NO-ERROR.

                    IF  AVAIL gg-tab-resultado THEN DO:
                        IF  gg-tab-resultado.tipo-result = 1 /** NumÇrico **/ THEN DO:
                            {method/zoomfields.i &ProgramZoom   = "ggzoom/z01gg00648.w"
                                                 &FieldZoom1    = "num-faixa-ini"
                                                 &FieldScreen1  = "c-resultado"
                                                 &Frame1        = {&FRAME-NAME}
                                                 &RunMethod     = "run piRecebeTabela in hProgramZoom (gg-tab-resultado.nr-tabela)."
                                                 &EnableImplant = "NO"}

                            WAIT-FOR CLOSE OF hProgramZoom.
                        END.
                        ELSE DO: /** Texto **/
                            {method/zoomfields.i &ProgramZoom   = "ggzoom/z01gg00648.w"
                                                 &FieldZoom1    = "des-faixa-ini"
                                                 &FieldScreen1  = "c-resultado"
                                                 &Frame1        = {&FRAME-NAME}
                                                 &RunMethod     = "run piRecebeTabela in hProgramZoom (gg-tab-resultado.nr-tabela)."
                                                 &EnableImplant = "NO"}

                            WAIT-FOR CLOSE OF hProgramZoom.
                        END.
                    END.
                END.
            END.
        END.
        ELSE DO:
            FIND FIRST comp-exame NO-LOCK
                 WHERE comp-exame.cod-exame = tt-class.cod-exame
                   AND comp-exame.cod-comp  = tt-class.cod-comp NO-ERROR.
            IF  AVAIL comp-exame THEN DO:
                IF  comp-exame.tipo-result = 2 THEN DO:
                    {include/zoomvar.i &prog-zoom   = "inzoom/z03in052.w"
                                       &campo       = c-resultado
                                       &campozoom   = descricao
                                       &parametros  = "run pi-seta-inicial in wh-pesquisa (tt-class.nr-tabela)."}
                END.
            END.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-resultado W-Win
ON LEAVE OF c-resultado IN FRAME F-Main /* Res */
DO:
  /*APPLY "entry" TO bt-mod IN FRAME {&FRAME-NAME}.
  RETURN NO-APPLY.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-resultado W-Win
ON MOUSE-SELECT-DBLCLICK OF c-resultado IN FRAME F-Main /* Res */
DO:
  APPLY "f5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-resultado W-Win
ON RETURN OF c-resultado IN FRAME F-Main /* Res */
DO:
  APPLY "choose" TO bt-mod IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects W-Win  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available W-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI W-Win  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(W-Win)
  THEN DELETE WIDGET W-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI W-Win  _DEFAULT-ENABLE
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
  DISPLAY c-resultado de-peso-desc de-peso-liq c-text-2 c-text 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE c-resultado bt-Mod br-table bt-classificador bt-ajuda bt-ok bt-cancela 
         RECT-7 RECT-8 rt-buttom 
      WITH FRAME F-Main IN WINDOW W-Win.
  {&OPEN-BROWSERS-IN-QUERY-F-Main}
  VIEW W-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable W-Win 
PROCEDURE local-enable :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable':U ) .
  
  IF  l-habilita = NO THEN DO:
      DISABLE bt-Mod c-resultado bt-classificador WITH FRAME {&FRAME-NAME}.   
  END.
  
  IF CAN-FIND(FIRST gg-mov-contr NO-LOCK 
              WHERE gg-mov-contr.cod-estabel   = c-estabel 
                AND gg-mov-contr.serie-docto   = c-serie       
                AND gg-mov-contr.nro-docto     = c-num-docto    
                AND gg-mov-contr.cod-emitente  = i-emit 
                AND gg-mov-contr.nat-operacao  = c-nat) THEN DO:
          
      DISABLE bt-Mod c-resultado bt-classificador WITH FRAME {&FRAME-NAME}.   
                  
  END.


  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit W-Win 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize W-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */

  FIND FIRST gg-param NO-LOCK NO-ERROR.

  RUN ggp/ggapi002a.p (INPUT c-nome-tabela, 
                       INPUT rw-documento, 
                       OUTPUT c-erro).
  IF c-erro <> "" THEN DO:

      RUN utp/ut-msgs.p (INPUT "SHOW":U,
                         INPUT 34901,
                         INPUT c-erro).

     RETURN ERROR.
  END.
  ELSE DO: 
        CASE c-nome-tabela:
            WHEN "wt-docto" THEN DO:
                FOR FIRST wt-docto NO-LOCK 
                  WHERE ROWID(wt-docto) = rw-documento:
                  ASSIGN c-num-docto = string(wt-docto.seq-wt-docto).
                  FOR FIRST gg-ext-wt-docto OF wt-docto NO-LOCK:
                      ASSIGN de-peso-liq = gg-ext-wt-docto.qtd-peso-liq
                             de-liquido  = de-peso-liq.
                  END.
                  RUN pi-cria-clas. 
                END.
            END.
            WHEN "nota-fiscal" THEN DO:
                FOR FIRST nota-fiscal NO-LOCK 
                  WHERE ROWID(nota-fiscal) = rw-documento:
                  FOR FIRST gg-ext-nota-fiscal OF nota-fiscal NO-LOCK: 
                      ASSIGN de-peso-liq = gg-ext-nota-fiscal.qtd-peso-liq
                             de-liquido  = de-peso-liq.
                  END.
                END.

                ASSIGN c-num-docto = nota-fiscal.nr-nota-fis
                     c-estabel   = nota-fiscal.cod-estabel
                     c-serie     = nota-fiscal.serie 
                     c-nat       = nota-fiscal.nat-operacao
                     i-emit      = nota-fiscal.cod-emitente.   
                RUN pi-cria-clas.
            END.
            WHEN "docum-est" THEN DO:
                FOR FIRST docum-est NO-LOCK 
                  WHERE ROWID(docum-est) = rw-documento:
                  /*FOR FIRST gg-ext-docum-est OF docum-est NO-LOCK: */
                  FOR FIRST gg-ext-docum-est NO-LOCK
                      WHERE gg-ext-docum-est.serie-docto  = docum-est.serie-docto
                        AND gg-ext-docum-est.nro-docto    = docum-est.nro-docto
                        AND gg-ext-docum-est.cod-emitente = docum-est.cod-emitente
                        AND gg-ext-docum-est.nat-operacao = docum-est.nat-operacao
                        AND gg-ext-docum-est.cod-estabel  = docum-est.cod-estabel :
                
                      ASSIGN de-peso-liq = gg-ext-docum-est.qtd-peso-liq
                             de-liquido  = de-peso-liq.
                  END.
                  IF  de-peso-liq = 0 THEN DO:
                      FOR EACH item-doc-est OF docum-est NO-LOCK:
                        ASSIGN de-peso-liq = item-doc-est.quantidade
                                 de-liquido  = de-peso-liq.
                      END.
                  END.
                
                  ASSIGN c-num-docto = docum-est.nro-docto
                         c-estabel   = docum-est.cod-estabel
                         c-serie     = docum-est.serie-docto 
                         c-nat       = docum-est.nat-operacao
                         i-emit      = docum-est.cod-emitente.   
                  RUN pi-cria-clas.
                END.
            END.
            WHEN "item-doc-est" THEN DO:
                FOR FIRST item-doc-est NO-LOCK 
                    WHERE ROWID(item-doc-est) = rw-documento,
                    FIRST docum-est OF item-doc-est NO-LOCK :
                    
                    /*IF  de-peso-liq = 0 THEN DO:
                        FOR EACH item-doc-est OF docum-est NO-LOCK:*/
                          ASSIGN de-peso-liq = item-doc-est.quantidade
                                   de-liquido  = de-peso-liq.
                        /*END.
                    END.*/

                    ASSIGN  /*c-item      = item-doc-est.it-codigo */
                            c-num-docto = item-doc-est.nro-docto
                            c-estabel   = docum-est.cod-estabel
                            c-serie     = docum-est.serie-docto 
                            c-nat       = item-doc-est.nat-operacao
                            i-emit      = item-doc-est.cod-emitente
                            i-sequencia = item-doc-est.sequencia. 
                END.
                RUN pi-cria-clas.
            END.
        END CASE.
  END.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  FIND FIRST tt-class NO-LOCK NO-ERROR. 
  APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
  RUN pi-texto.
  RUN pi-display-total.

          /*
  {&OPEN-QUERY-{&BROWSE-NAME}}
            */
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-gg-clas W-Win 
PROCEDURE pi-atualiza-gg-clas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

FOR EACH tt-class
   WHERE tt-class.des-resultado <> "": 

    FOR FIRST gg-classifica exclusive-LOCK 
        WHERE gg-classifica.des-tipo-docto = tt-class.des-tipo-docto 
          AND gg-classifica.cod-estabel    = tt-class.cod-estabel 
          AND gg-classifica.num-docto      = tt-class.num-docto 
          AND gg-classifica.serie          = tt-class.serie 
          AND gg-classifica.nat-operacao   = tt-class.nat-operacao
          AND gg-classifica.cod-emitente   = tt-class.cod-emitente
          AND gg-classifica.ind-local      = tt-class.ind-local 
          AND gg-classifica.cod-exame      = tt-class.cod-exame 
          and gg-classifica.cod-comp       = tt-class.cod-comp
          AND gg-classifica.num-sequencia  = tt-class.num-sequencia  :

        BUFFER-COPY tt-class TO gg-classifica.
        
    END.

    DELETE tt-class.
END.


IF c-nome-tabela =  "docum-est" THEN DO:
    FIND FIRST item-doc-est OF docum-est EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL item-doc-est THEN DO:
        IF de-liquido - de-peso-desc <> item-doc-est.quantidade THEN DO:

           RUN utp/ut-msgs.p (INPUT "SHOW":U,
                              INPUT 34902,
                              INPUT "":U).

        END.
    END.
END.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-clas W-Win 
PROCEDURE pi-cria-clas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    FOR EACH tt-class :
        DELETE tt-class. 
    END.
    

    
        
        
        FOR EACH gg-classifica NO-LOCK 
           WHERE gg-classifica.des-tipo-docto = c-nome-tabela
             AND gg-classifica.cod-estabel    = c-estabel 
             AND gg-classifica.num-docto      = c-num-docto 
             AND gg-classifica.serie          = c-serie 
             AND gg-classifica.nat-operacao   = c-nat
             AND gg-classifica.cod-emitente   = i-emit
             AND gg-classifica.num-sequencia  = i-sequencia:
             
             
           
           CREATE tt-class.
           BUFFER-COPY gg-classifica TO tt-class.
           
           FOR FIRST gg-mov-contr NO-LOCK 
                WHERE gg-mov-contr.cod-estabel   = c-estabel 
                  AND gg-mov-contr.serie-docto   = c-serie       
                  AND gg-mov-contr.nro-docto     = c-num-docto    
                  AND gg-mov-contr.cod-emitente  = i-emit 
                  AND gg-mov-contr.nat-operacao  = c-nat,
                FIRST gg-mov NO-LOCK 
                WHERE gg-mov.cod-estabel  = gg-mov-contr.cod-estabel 
                  AND gg-mov.num-romaneio = gg-mov-contr.num-romaneio:
                  
                  FOR FIRST  gg-mov-clas OF gg-mov NO-LOCK
                      WHERE gg-mov-clas.cod-exame = gg-classifica.cod-exame:
                      
                      ASSIGN tt-class.des-resultado = gg-mov-clas.des-resultado .
                  END.    
              
           END.   
           
           
           /* Cadastro de Classificaá∆o e Tabela de Resultado estiver marcada */
           IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:
               FIND FIRST gg-exame NO-LOCK
                    WHERE gg-exame.cod-exame  = gg-classifica.cod-exame NO-ERROR.
               ASSIGN tt-class.desc-exame =  IF AVAIL gg-exame THEN gg-exame.descricao ELSE "".
           END.
           ELSE DO:
               FIND FIRST exame NO-LOCK
                   WHERE exame.cod-exame  = gg-classifica.cod-exame NO-ERROR.
               ASSIGN tt-class.desc-exame =  IF AVAIL exame THEN exame.descricao ELSE "".
           END.
        
        END. /* for each */
   
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display-total W-Win 
PROCEDURE pi-display-total :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN de-peso-desc       = 0.

FOR EACH b-tt-clas NO-LOCK: 
    ASSIGN de-peso-desc = de-peso-desc + b-tt-clas.qtd-desconto.
END.

DISPLAY de-peso-desc       
        de-peso-liq - de-peso-desc @ de-peso-liq      
        WITH FRAME {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-texto W-Win 
PROCEDURE pi-texto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF  AVAIL tt-class THEN DO:
        IF  tt-class.ind-local = 1 THEN
            {utp/ut-liter.i "ORIG - " * R}
        ELSE
            {utp/ut-liter.i "DEST - " * R}

        ASSIGN c-text = RETURN-VALUE.

        REPOSITION br-table TO ROWID ROWID(tt-class).
        ASSIGN c-resultado:SCREEN-VALUE IN FRAME {&FRAME-NAME} = tt-class.des-resultado.

        /* Cadastro de Classificaá∆o e Tabela de Resultado estiver marcada */
        IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:
            FIND FIRST gg-exame NO-LOCK
                 WHERE gg-exame.cod-exame = tt-class.cod-exame NO-ERROR.
            ASSIGN c-text = c-text + STRING(gg-exame.descricao).
        END.
        ELSE DO:
            FIND FIRST exame NO-LOCK
                 WHERE exame.cod-exame = tt-class.cod-exame NO-ERROR.
            ASSIGN c-text = c-text + STRING(exame.descricao).
        END.

        DISPLAY c-text WITH FRAME {&FRAME-NAME}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-assign W-Win 
PROCEDURE pi-valida-assign :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
------------------------------------------------------------------------------*/

    IF  de-liquido = 0 THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 34903,
                           INPUT "":U).

        APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
        RETURN ERROR.
    END.

    ASSIGN  INPUT FRAME {&frame-name} c-resultado.
    
    if  comp-exame.tipo-result = 2 then do:
        IF  c-resultado <> "" THEN DO:

            FIND FIRST gg-ext-tab-result NO-LOCK
                 WHERE gg-ext-tab-result.nr-tabela = tt-class.nr-tabela NO-ERROR.
            IF  AVAIL gg-ext-tab-result THEN DO:

                IF gg-ext-tab-result.log-faixa THEN DO:

                   FIND FIRST gg-ext-comp-tab-res NO-LOCK
                        WHERE gg-ext-comp-tab-res.nr-tabela      = tt-class.nr-tabela
                          AND gg-ext-comp-tab-res.num-faixa-ini <= dec(c-resultado) 
                          AND gg-ext-comp-tab-res.num-faixa-fim >= dec(c-resultado)  NO-ERROR.
                   IF  NOT AVAIL gg-ext-comp-tab-res THEN DO:

                       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                          INPUT 8171,
                                          INPUT "":U).

                        APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
                        RETURN error.
                   END.

                   ASSIGN tt-class.seq-comp = gg-ext-comp-tab-res.seq-comp.

                END.
                ELSE DO:

                    FIND FIRST comp-tab-res NO-LOCK
                         WHERE comp-tab-res.nr-tabela = tt-class.nr-tabela
                           AND comp-tab-res.descricao = c-resultado NO-ERROR.
                   IF  NOT AVAIL comp-tab-res THEN DO:
                    
                       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                          INPUT 8171,
                                          INPUT "":U).

                        APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
                        RETURN error.
                   END.

                   assign tt-class.seq-comp = comp-tab-res.seq-comp.
                END.
               
            END.
            ELSE DO:

                FIND FIRST comp-tab-res NO-LOCK
                     WHERE comp-tab-res.nr-tabela = tt-class.nr-tabela
                       AND comp-tab-res.descricao = c-resultado NO-ERROR.
               IF NOT AVAIL comp-tab-res THEN DO:

                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 8171,
                                       INPUT "":U).

                    APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
                    RETURN error.
               END.
    
               assign tt-class.seq-comp      = comp-tab-res.seq-comp.
            END.
       END.
       ELSE DO:
           assign tt-class.seq-comp = 0.
       END.
    END.
    
    if  comp-exame.tipo-result = 4 then do:
        if  dec(c-resultado) > comp-exame.result-max
            AND DEC(c-resultado) < comp-exame.result-min then do:
            run utp/ut-msgs.p (input "show", input 17150, input "").            
            APPLY 'entry' to c-resultado in frame {&frame-name}. 
            return error.                
        end.
        assign tt-class.res-max       = STRING(c-resultado).
    end.

    ASSIGN tt-class.des-resultado                                 = c-resultado
           tt-class.des-resultado:SCREEN-VALUE IN BROWSE br-table = string(c-resultado).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-assign-novo W-Win 
PROCEDURE pi-valida-assign-novo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
  
------------------------------------------------------------------------------*/

    IF  de-liquido = 0 THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 34903,
                           INPUT "":U).

        APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
        RETURN ERROR.
    END.

    ASSIGN  INPUT FRAME {&frame-name} c-resultado.

    IF  gg-exame.tipo-result = 2 THEN DO:
        IF  c-resultado <> "" THEN DO:

            FIND FIRST gg-tab-resultado EXCLUSIVE-LOCK
                 WHERE gg-tab-resultado.nr-tabela = tt-class.nr-tabela NO-ERROR.
            IF  AVAIL gg-tab-resultado THEN DO:

                IF  gg-tab-resultado.log-faixa THEN DO:

                    IF  gg-tab-resultado.tipo-result = 1 /*NUMêRICO*/ THEN
                        FIND FIRST gg-tab-result-comp EXCLUSIVE-LOCK
                             WHERE gg-tab-result-comp.nr-tabela      = tt-class.nr-tabela
                               AND gg-tab-result-comp.num-faixa-ini <= DEC(c-resultado) 
                               AND gg-tab-result-comp.num-faixa-fim >= DEC(c-resultado)  NO-ERROR.
                    ELSE /*TEXTO*/
                        FIND FIRST gg-tab-result-comp EXCLUSIVE-LOCK
                             WHERE gg-tab-result-comp.nr-tabela      = tt-class.nr-tabela
                               AND gg-tab-result-comp.des-faixa-ini <= c-resultado
                               AND gg-tab-result-comp.des-faixa-fim >= c-resultado  NO-ERROR.
                END.
                ELSE DO:

                    IF  gg-tab-resultado.tipo-result = 1 /*NUMêRICO*/ THEN
                        FIND FIRST gg-tab-result-comp EXCLUSIVE-LOCK
                             WHERE gg-tab-result-comp.nr-tabela     = tt-class.nr-tabela
                               AND gg-tab-result-comp.num-faixa-ini = DEC(c-resultado) NO-ERROR.
                    ELSE /*TEXTO*/
                        FIND FIRST gg-tab-result-comp EXCLUSIVE-LOCK
                             WHERE gg-tab-result-comp.nr-tabela     = tt-class.nr-tabela
                               AND gg-tab-result-comp.des-faixa-ini = c-resultado NO-ERROR.
                END.

                IF  NOT AVAIL gg-tab-result-comp THEN DO:                    
                    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                       INPUT 8171,
                                       INPUT "":U).

                    APPLY "entry" TO c-resultado IN FRAME {&FRAME-NAME}.
                    RETURN ERROR.
                END.

                ASSIGN tt-class.seq-comp = gg-tab-result-comp.seq-comp.

            END.
            ELSE
                ASSIGN tt-class.seq-comp = 0.
        END.
    END.

    IF  gg-exame.tipo-result = 4 THEN DO:
        IF  DEC(c-resultado) > gg-exame.result-max
        AND DEC(c-resultado) < gg-exame.result-min THEN DO:
            RUN utp/ut-msgs.p (INPUT "show", INPUT 17150, INPUT "").
            IF  RETURN-VALUE = 'no' THEN DO:
                APPLY 'entry' TO c-resultado IN FRAME {&FRAME-NAME}.
                RETURN ERROR.
            END.
        END.

        ASSIGN tt-class.res-max = STRING(c-resultado).
    END.

    ASSIGN tt-class.des-resultado                                 = c-resultado
           tt-class.des-resultado:SCREEN-VALUE IN BROWSE br-table = string(c-resultado).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-class W-Win 
PROCEDURE pi-valida-class :
/*------------------------------------------------------------------------------
  Purpose: Validaá∆o de classificaá∆o    
  Parameters:  <none>
  Notes: A l¢gica disposta abaixo Ç a mesma aplicada na atualizaá∆o do documento 
         para validar a integridade das classificaá‰es.      
------------------------------------------------------------------------------*/
    DEFINE BUFFER b1-item-doc-est FOR item-doc-est.

    DEFINE VARIABLE lContrClassif AS LOGICAL     NO-UNDO.

    IF c-nome-tabela = "item-doc-est" THEN DO:
        FIND FIRST b1-item-doc-est NO-LOCK
            WHERE ROWID(b1-item-doc-est) = rw-documento NO-ERROR.
        IF AVAIL b1-item-doc-est THEN DO:

            FIND FIRST docum-est OF
                item-doc-est NO-LOCK NO-ERROR.
            IF NOT AVAIL docum-est THEN
                RETURN NO-APPLY.

            /* Cadastro de Classificaá∆o e Tabela de Resultado estiver marcada */
            IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:
                FIND FIRST gg-param-item NO-LOCK
                     WHERE gg-param-item.it-codigo = item-doc-est.it-codigo NO-ERROR.

                ASSIGN lContrClassif = (AVAIL gg-param-item AND gg-param-item.log-1 = YES). /** controle classificaá∆o **/
            END.
            ELSE DO:
                FIND FIRST gg-ext-item NO-LOCK
                    WHERE gg-ext-item.it-codigo = item-doc-est.it-codigo NO-ERROR.

                ASSIGN lContrClassif = (AVAIL gg-ext-item AND gg-ext-item.log-controle-clas = YES).
            END.

             IF lContrClassif THEN DO:

                 FOR EACH tt-class:
                    FIND FIRST gg-classifica NO-LOCK
                        WHERE gg-classifica.des-tipo-docto   = tt-class.des-tipo-docto       
                          AND gg-classifica.cod-estabel      = tt-class.cod-estabel          
                          AND gg-classifica.num-docto        = tt-class.num-docto            
                          AND gg-classifica.serie            = tt-class.serie                
                          AND gg-classifica.nat-operacao     = tt-class.nat-operacao         
                          AND gg-classifica.cod-emitente     = tt-class.cod-emitente         
                          AND gg-classifica.cod-exame        = tt-class.cod-exame            
                          AND gg-classifica.cod-comp         = tt-class.cod-comp             
                          AND gg-classifica.num-sequencia    = tt-class.num-sequencia      NO-ERROR.
                     IF AVAIL gg-classifica THEN DO:                                         
    
                        IF gg-classifica.des-resultado = "" THEN DO:
                           /* Todas as classificaá‰es devem ser informadas */
                           RUN utp/ut-msgs.p (INPUT "SHOW",
                                               INPUT 51678,
                                               INPUT "").
                           RETURN "NOK":U.
                        END.
                     end.
                     else do:    
                        /* Todas as classificaá‰es devem ser informadas */
                        RUN utp/ut-msgs.p (INPUT "SHOW",
                                            INPUT 51678,
                                            INPUT "").
                        RETURN "NOK":U.
                     end.
                 END.
             END.
        END.
    END.
    ELSE DO:
        FIND docum-est WHERE
             ROWID(docum-est) = rw-documento NO-LOCK NO-ERROR.
        IF AVAIL docum-est THEN DO:
    
            FOR EACH item-doc-est OF docum-est NO-LOCK:

                /* Cadastro de Classificaá∆o e Tabela de Resultado estiver marcada */
                IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:
                    FIND FIRST gg-param-item NO-LOCK
                         WHERE gg-param-item.it-codigo = item-doc-est.it-codigo NO-ERROR.

                    ASSIGN lContrClassif = (AVAIL gg-param-item AND gg-param-item.log-1 = YES). /** controle classificaá∆o **/
                END.
                ELSE DO:
                    FIND FIRST gg-ext-item NO-LOCK
                         WHERE gg-ext-item.it-codigo = item-doc-est.it-codigo NO-ERROR.
    
                     ASSIGN lContrClassif = (AVAIL gg-ext-item AND gg-ext-item.log-controle-clas = YES).
                END.

                IF  lContrClassif THEN DO:

                    FOR EACH tt-class:
                        FIND FIRST gg-classifica no-lock
                             WHERE gg-classifica.des-tipo-docto   = tt-class.des-tipo-docto  
                               AND gg-classifica.cod-estabel      = tt-class.cod-estabel     
                               AND gg-classifica.num-docto        = tt-class.num-docto       
                               AND gg-classifica.serie            = tt-class.serie           
                               AND gg-classifica.nat-operacao     = tt-class.nat-operacao    
                               AND gg-classifica.cod-emitente     = tt-class.cod-emitente    
                               AND gg-classifica.cod-exame        = tt-class.cod-exame       
                               AND gg-classifica.cod-comp         = tt-class.cod-comp        
                               AND gg-classifica.num-sequencia    = tt-class.num-sequencia    no-error.
                        IF  AVAIL gg-classifica THEN DO:
    
                             IF gg-classifica.des-resultado = "" THEN DO:
                                /* Todas as classificaá‰es devem ser informadas */
                                RUN utp/ut-msgs.p (INPUT "SHOW",
                                                    INPUT 51678,
                                                    INPUT "").
                                RETURN "NOK":U.
                             END.
                        end.
                        else do:    
                             /* Todas as classificaá‰es devem ser informadas */
                             RUN utp/ut-msgs.p (INPUT "SHOW",
                                                 INPUT 51678,
                                                 INPUT RETURN-VALUE).
                             RETURN "NOK":U.
                        end.
                    END.
                 END.    
            END.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records W-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-class"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed W-Win 
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

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-local W-Win 
FUNCTION fn-local RETURNS CHARACTER
  ( i-local AS int ) :

    define variable c-local as char no-undo.

    IF i-local = 1 THEN        
        {utp/ut-liter.i "Orig" * R}
    IF i-local = 2 THEN
        {utp/ut-liter.i "Dest" * R}

    ASSIGN c-local = RETURN-VALUE.

    RETURN c-local.  
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fn-tipo W-Win 
FUNCTION fn-tipo RETURNS CHARACTER
  ( i-tipo AS int ) :

    define variable c-tipo as char no-undo.

    IF i-tipo = 1 THEN
        {utp/ut-liter.i "NumÇrica" * R}        
    IF i-tipo = 2 THEN
        {utp/ut-liter.i "Tabela" * R}
    IF i-tipo = 3 THEN
        {utp/ut-liter.i "Texto" * R}
    IF i-tipo = 4 THEN
        {utp/ut-liter.i "Faixa" * R}

    ASSIGN c-local = RETURN-VALUE.

    RETURN c-local.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

