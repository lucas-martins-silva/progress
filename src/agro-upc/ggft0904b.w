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
{include/i-prgvrs.i GGFT0904B 2.00.00.010 } /*** "010010" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ggft0904b GGP}
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
DEF INPUT PARAM rw-documento  AS ROWID.

{utp/ut-glob.i}

DEF VAR c-local     AS CHAR FORMAT "x(08)". 
DEF VAR c-tipo      AS CHAR FORMAT "x(10)".  

DEF TEMP-TABLE tt-class NO-UNDO LIKE gg-classifica
    FIELD desc-exame  AS CHAR FORMAT "X(30)"
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

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME F-Main
&Scoped-define BROWSE-NAME br-table

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-class

/* Define KEY-PHRASE in case it is used by any query. */
&Scoped-define KEY-PHRASE TRUE

/* Definitions for BROWSE br-table                                      */
&Scoped-define FIELDS-IN-QUERY-br-table fn-local(tt-class.ind-local) @ c-local tt-class.desc-exame tt-class.des-resultado tt-class.cod-exame tt-class.seq-comp tt-class.val-perc-desc tt-class.qtd-desconto tt-class.nr-ficha fn-tipo(tt-class.tipo-result) @ c-tipo tt-class.cod-usu-clas   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-table   
&Scoped-define SELF-NAME br-table
&Scoped-define QUERY-STRING-br-table FOR EACH tt-class.             /*BY gg-mov-clas.ind-local DESCENDING.*/
&Scoped-define OPEN-QUERY-br-table OPEN QUERY {&SELF-NAME} FOR EACH tt-class.             /*BY gg-mov-clas.ind-local DESCENDING.*/.
&Scoped-define TABLES-IN-QUERY-br-table tt-class
&Scoped-define FIRST-TABLE-IN-QUERY-br-table tt-class


/* Definitions for FRAME F-Main                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-F-Main ~
    ~{&OPEN-QUERY-br-table}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-table bt-ajuda bt-ok bt-cancela RECT-1 ~
RECT-2 rt-buttom 
&Scoped-Define DISPLAYED-OBJECTS d-p-bruto l-bruto d-p-tara l-tara ~
d-p-liquido 

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

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE d-p-bruto AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso Bruto" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-p-liquido AS DECIMAL FORMAT "->>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso L¡quido" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE d-p-tara AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Peso Tara" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.29 BY 2.5.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 50.29 BY 1.29.

DEFINE RECTANGLE rt-buttom
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 50 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-bruto AS LOGICAL INITIAL no 
     LABEL "Balan‡a?" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE l-tara AS LOGICAL INITIAL no 
     LABEL "Balan‡a?" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-table FOR 
      tt-class SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-table
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-table W-Win _FREEFORM
  QUERY br-table NO-LOCK DISPLAY
      fn-local(tt-class.ind-local) @ c-local COLUMN-LABEL "Loc"
      tt-class.desc-exame    COLUMN-LABEL "Descri‡Æo" 
      tt-class.des-resultado FORMAT "X(15)":U
      tt-class.cod-exame     FORMAT ">>>>>9":U
      tt-class.seq-comp      COLUMN-LABEL "Comp" FORMAT ">>9":U 
      tt-class.val-perc-desc FORMAT "->>9.9999":U
      tt-class.qtd-desconto  FORMAT ">>>,>>>,>>9.9999":U
      tt-class.nr-ficha      COLUMN-LABEL "Roteiro" FORMAT ">>>>,>>9":U
      fn-tipo(tt-class.tipo-result) @ c-tipo COLUMN-LABEL "Tipo Res."
      tt-class.cod-usu-clas  FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ASSIGN SEPARATORS SIZE 50 BY 7.21
         FONT 4 ROW-HEIGHT-CHARS .46.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME F-Main
     d-p-bruto AT ROW 2.13 COL 12.43 COLON-ALIGNED
     l-bruto AT ROW 2.13 COL 31.57
     d-p-tara AT ROW 3.13 COL 12.43 COLON-ALIGNED
     l-tara AT ROW 3.13 COL 31.57
     d-p-liquido AT ROW 4.54 COL 12.43 COLON-ALIGNED
     br-table AT ROW 6.63 COL 1
     bt-ajuda AT ROW 14.46 COL 39
     bt-ok AT ROW 14.5 COL 1.72
     bt-cancela AT ROW 14.5 COL 12.72
     RECT-1 AT ROW 1.75 COL 1
     RECT-2 AT ROW 4.33 COL 1
     rt-buttom AT ROW 14.25 COL 1
     "Pesagem:" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.04 COL 2.43
     "Classifica‡Æo:" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 5.92 COL 2.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 50.29 BY 15
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW W-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Consulta Classifica‡Æo~\Pesagem"
         HEIGHT             = 14.71
         WIDTH              = 50.57
         MAX-HEIGHT         = 19.29
         MAX-WIDTH          = 80
         VIRTUAL-HEIGHT     = 19.29
         VIRTUAL-WIDTH      = 80
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
                                                                        */
/* BROWSE-TAB br-table d-p-liquido F-Main */
/* SETTINGS FOR FILL-IN d-p-bruto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-p-liquido IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN d-p-tara IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-bruto IN FRAME F-Main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX l-tara IN FRAME F-Main
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

           /*BY gg-mov-clas.ind-local DESCENDING.*/
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION KEY-PHRASE SORTBY-PHRASE"
     _Query            is OPENED
*/  /* BROWSE br-table */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME W-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON END-ERROR OF W-Win /* Consulta Classifica‡Æo~\Pesagem */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL W-Win W-Win
ON WINDOW-CLOSE OF W-Win /* Consulta Classifica‡Æo~\Pesagem */
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


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok W-Win
ON CHOOSE OF bt-ok IN FRAME F-Main /* OK */
DO:
  APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK W-Win 


/* ***************************  Main Block  *************************** */

ASSIGN    d-p-tara    = 0
          d-p-bruto   = 0
          d-p-liquido = 0.


FIND FIRST nota-fiscal NO-LOCK 
    WHERE rowid(nota-fiscal) = rw-documento NO-ERROR.
IF  AVAIL nota-fiscal THEN  DO:

    FIND FIRST gg-ext-nota-fiscal NO-LOCK                                       
         WHERE gg-ext-nota-fiscal.serie           = nota-fiscal.serie           
           AND gg-ext-nota-fiscal.nr-nota-fis     = nota-fiscal.nr-nota-fis             
           AND gg-ext-nota-fiscal.cod-estabel     = nota-fiscal.cod-estabel NO-ERROR.
    
    IF  AVAIL gg-ext-nota-fiscal AND ( gg-ext-nota-fiscal.qtd-peso-tara <> 0 OR gg-ext-nota-fiscal.qtd-peso-bruto <> 0 )  THEN DO:
        ASSIGN d-p-tara    = gg-ext-nota-fiscal.qtd-peso-tara
               d-p-bruto   = gg-ext-nota-fiscal.qtd-peso-bruto
               d-p-liquido = gg-ext-nota-fiscal.qtd-peso-liq
               l-bruto     = gg-ext-nota-fiscal.log-liq 
               l-tara      = gg-ext-nota-fiscal.log-tara.

    END.
  
END.

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
  DISPLAY d-p-bruto l-bruto d-p-tara l-tara d-p-liquido 
      WITH FRAME F-Main IN WINDOW W-Win.
  ENABLE br-table bt-ajuda bt-ok bt-cancela RECT-1 RECT-2 rt-buttom 
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
  FIND FIRST gg-param NO-LOCK NO-ERROR.

  RUN pi-cria-clas. 

  /* Dispatch standard ADM method.                             */
  
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   
 
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
FIND FIRST nota-fiscal NO-LOCK 
    WHERE rowid(nota-fiscal) = rw-documento NO-ERROR.

IF  AVAIL nota-fiscal THEN DO:
    
    {utp/ut-liter.i "nota-fiscal" * R}
    FOR EACH gg-classifica NO-LOCK                                       
        WHERE gg-classifica.des-tipo-docto  = RETURN-VALUE
          AND gg-classifica.serie           = nota-fiscal.serie           
          AND gg-classifica.num-docto       = nota-fiscal.nr-nota-fis            
          AND gg-classifica.cod-estabel     = nota-fiscal.cod-estabel :

        CREATE tt-class.
        BUFFER-COPY gg-classifica TO tt-class.

        /* Cadastro de Classifica‡Æo e Tabela de Resultado estiver marcada */
        IF  SUBSTR(gg-param.cod-livre-3,4,1) = "S":U THEN DO:
            FIND FIRST gg-exame NO-LOCK
                 WHERE gg-exame.cod-exame = gg-classifica.cod-exame NO-ERROR.
            ASSIGN tt-class.desc-exame = IF AVAIL gg-exame THEN gg-exame.descricao ELSE "".
        END.
        ELSE DO:
            FIND FIRST exame NO-LOCK
                 WHERE exame.cod-exame = gg-classifica.cod-exame NO-ERROR.
            ASSIGN tt-class.desc-exame = IF AVAIL exame THEN exame.descricao ELSE "".
        END.
   END.
   {&OPEN-QUERY-{&BROWSE-NAME}}
END.


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
        {utp/ut-liter.i "Num‚rica" * R}
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

