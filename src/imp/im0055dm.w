&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-decl-hist-embarq-imp NO-UNDO LIKE decl-hist-embarq-imp
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0055DM 2.00.00.010 } /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im0055dm MIM}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        IM0055DM
&GLOBAL-DEFINE Version        2.00.00.010
&GLOBAL-DEFINE DBOVersion     1.1

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE InitialPage    0

&GLOBAL-DEFINE page0Widgets   tt-decl-hist-embarq-imp.int-2 ~
                              tt-decl-hist-embarq-imp.decl-emitida ~
                              tt-decl-hist-embarq-imp.int-1 ~
                              tt-decl-hist-embarq-imp.e-mail-despachante ~
                              tt-decl-hist-embarq-imp.e-mail-agente ~
                              tt-decl-hist-embarq-imp.e-mail-emitente ~
                              tt-decl-hist-embarq-imp.e-mail-fabricante ~
                              tt-decl-hist-embarq-imp.e-mail-repres ~
                              tt-decl-hist-embarq-imp.e-mail-outros ~
                              tt-decl-hist-embarq-imp.texto ~
                              btOK btCancel btHelp
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */

DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Shared Variable Definitions ---                                       */
def shared var r-row  as rowid no-undo.
def shared var c-acao as char  no-undo.

/* Local Variable Definitions ---                                       */
def var h-bocx280 as handle no-undo.
def var h-bocx010 as handle no-undo.
def var h-bocx230 as handle no-undo.
def var h-bocx225 as handle no-undo.
def var h-bocx140 as handle no-undo.
def var h-bocx110 as handle no-undo.

def var i-de-cod  as int    no-undo.
def var c-idiom-usuar   as char   no-undo.
def var c-return        as char   no-undo.
def var c-cod-estabel   as char   no-undo.
def var c-nr-proc-imp   as char   no-undo.
def var i-cod-emitente  as char   no-undo.
def var c-embarque      as char   no-undo.
DEFINE VARIABLE c-desc   AS CHARACTER   NO-UNDO.

&IF '{&mgdis_version}' >= '2.06f' &THEN
    def var h-bofn017 as handle no-undo.
    {fnbo/bofn017.i tt_usuar_mestre}
&ELSE
    def var h-boun178 as handle no-undo.
    {unbo/boun178.i tt_usuar_mestre}
&ENDIF

{include/boerrtab.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-decl-hist-embarq-imp.de-codigo ~
tt-decl-hist-embarq-imp.decl-emitida tt-decl-hist-embarq-imp.int-2 ~
tt-decl-hist-embarq-imp.e-mail-despachante tt-decl-hist-embarq-imp.int-1 ~
tt-decl-hist-embarq-imp.e-mail-agente ~
tt-decl-hist-embarq-imp.e-mail-emitente ~
tt-decl-hist-embarq-imp.e-mail-fabricante ~
tt-decl-hist-embarq-imp.e-mail-repres tt-decl-hist-embarq-imp.e-mail-outros ~
tt-decl-hist-embarq-imp.texto 
&Scoped-define ENABLED-TABLES tt-decl-hist-embarq-imp
&Scoped-define FIRST-ENABLED-TABLE tt-decl-hist-embarq-imp
&Scoped-Define ENABLED-OBJECTS RECT-1 rtToolBar fi-cod-pto-contr ~
fi-descricao-pto FILL-IN-1 btOK btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-decl-hist-embarq-imp.de-codigo ~
tt-decl-hist-embarq-imp.decl-emitida tt-decl-hist-embarq-imp.int-2 ~
tt-decl-hist-embarq-imp.e-mail-despachante tt-decl-hist-embarq-imp.int-1 ~
tt-decl-hist-embarq-imp.e-mail-agente ~
tt-decl-hist-embarq-imp.e-mail-emitente ~
tt-decl-hist-embarq-imp.e-mail-fabricante ~
tt-decl-hist-embarq-imp.e-mail-repres tt-decl-hist-embarq-imp.e-mail-outros ~
tt-decl-hist-embarq-imp.texto 
&Scoped-define DISPLAYED-TABLES tt-decl-hist-embarq-imp
&Scoped-define FIRST-DISPLAYED-TABLE tt-decl-hist-embarq-imp
&Scoped-Define DISPLAYED-OBJECTS fi-cod-pto-contr fi-descricao-pto ~
FILL-IN-1 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnPtoSeq wWindow 
FUNCTION fnPtoSeq RETURNS INTEGER
  ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-seq as int ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnSeqPto wWindow 
FUNCTION fnSeqPto RETURNS INTEGER
  ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-pto-contr as int ) FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-pto-contr AS INTEGER FORMAT ">>,>>9" INITIAL 0 
     LABEL "Ponto Controle" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .79 NO-UNDO.

DEFINE VARIABLE fi-descricao-pto AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .79 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 23.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 28.72 BY 6.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-cod-pto-contr AT ROW 1.5 COL 19 COLON-ALIGNED HELP
          "Informe C¢digo do Ponto de Controle" WIDGET-ID 2
     fi-descricao-pto AT ROW 1.5 COL 28 COLON-ALIGNED HELP
          "Informe a descri‡Æo do ponto de controle" NO-LABEL WIDGET-ID 4
     tt-decl-hist-embarq-imp.de-codigo AT ROW 2.38 COL 19 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7 BY .88
     FILL-IN-1 AT ROW 2.38 COL 26.14 COLON-ALIGNED NO-LABEL
     tt-decl-hist-embarq-imp.decl-emitida AT ROW 3.29 COL 27.14
          VIEW-AS TOGGLE-BOX
          SIZE 17.29 BY .83
     tt-decl-hist-embarq-imp.int-2 AT ROW 3.33 COL 19.14 COLON-ALIGNED
          LABEL "Dias de Tolerƒncia"
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-decl-hist-embarq-imp.e-mail-despachante AT ROW 4.29 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-embarq-imp.int-1 AT ROW 4.63 COL 56.43 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
                    "Processo/Embarque Atrasado", 1,
"Processo/Embarque Adiantado", 2,
"Processo/Embarque Prazo", 3,
"Processo/Embarque Fora do Prazo", 4,
"Sempre Emite", 5
          SIZE 27 BY 4.63
     tt-decl-hist-embarq-imp.e-mail-agente AT ROW 5.29 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-embarq-imp.e-mail-emitente AT ROW 6.29 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-embarq-imp.e-mail-fabricante AT ROW 7.29 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-embarq-imp.e-mail-repres AT ROW 8.29 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-embarq-imp.e-mail-outros AT ROW 9.29 COL 18.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 29.72 BY .88
     tt-decl-hist-embarq-imp.texto AT ROW 10.96 COL 20.86 NO-LABEL
          VIEW-AS EDITOR NO-WORD-WRAP SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
          SIZE 54.43 BY 5.92
     btOK AT ROW 18.13 COL 2
     btCancel AT ROW 18.13 COL 13
     btHelp AT ROW 18.13 COL 80
     "Emite Declara‡Æo:" VIEW-AS TEXT
          SIZE 12.86 BY .88 AT ROW 3.08 COL 56.14
     "Texto:" VIEW-AS TEXT
          SIZE 4.57 BY .88 AT ROW 10.63 COL 16.29
     RECT-1 AT ROW 3.46 COL 55.29
     rtToolBar AT ROW 17.92 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18.5
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-decl-hist-embarq-imp T "?" NO-UNDO mgcex decl-hist-embarq-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 18.54
         WIDTH              = 90
         MAX-HEIGHT         = 18.54
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.54
         VIRTUAL-WIDTH      = 90
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = yes
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wWindow 
/* ************************* Included-Libraries *********************** */

{window/window.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN tt-decl-hist-embarq-imp.int-2 IN FRAME fpage0
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    IF VALID-HANDLE(h-bocx280) THEN DO:
        delete procedure h-bocx280.
    END.
    IF VALID-HANDLE(h-bocx010) THEN DO:
        delete procedure h-bocx010.
    END.
    IF VALID-HANDLE(h-bocx230) THEN DO:
        delete procedure h-bocx230.
    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:

   for each tt-bo-erro:
       delete tt-bo-erro.
   end.    

   run findRowid in h-bocx230(input prParent).
   run getCharfield in h-bocx230(input "cod-estabel",output tt-decl-hist-embarq-imp.cod-estabel).
   run getCharfield in h-bocx230(input "embarque"   ,output tt-decl-hist-embarq-imp.embarque).
   run getIntfield in h-bocx230 (input "cod-itiner" ,output tt-decl-hist-embarq-imp.cod-itiner).
   assign frame fPage0
          tt-decl-hist-embarq-imp.de-codigo
          tt-decl-hist-embarq-imp.int-2
          tt-decl-hist-embarq-imp.int-1
          tt-decl-hist-embarq-imp.e-mail-despachante
          tt-decl-hist-embarq-imp.e-mail-agente
          tt-decl-hist-embarq-imp.e-mail-emitente
          tt-decl-hist-embarq-imp.e-mail-fabricante
          tt-decl-hist-embarq-imp.e-mail-repres
          tt-decl-hist-embarq-imp.e-mail-outros
          tt-decl-hist-embarq-imp.texto
          tt-decl-hist-embarq-imp.decl-emitida
          tt-decl-hist-embarq-imp.descricao = fill-in-1:SCREEN-VALUE IN FRAME fPage0
          tt-decl-hist-embarq-imp.sequencia = fnSeqPto(tt-decl-hist-embarq-imp.cod-estabel,
                                                       tt-decl-hist-embarq-imp.embarque,
                                                       tt-decl-hist-embarq-imp.cod-itiner,
                                                       INT(fi-cod-pto-contr:SCREEN-VALUE IN FRAME fPage0)).

   if  c-acao = "ADD":u then do:        

       run validaDeclaracao in h-bocx280 (input tt-decl-hist-embarq-imp.cod-estabel,
                                          input tt-decl-hist-embarq-imp.embarque,
                                          input tt-decl-hist-embarq-imp.cod-itiner,
                                          input tt-decl-hist-embarq-imp.de-codigo,
                                          output table tt-bo-erro).

       IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
          IF NOT VALID-HANDLE(hShowMsg) THEN
              RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
          ELSE
              DELETE PROCEDURE hShowMsg.

          RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).

          leave.
       end.
       else do:
            RUN validateCreate IN h-bocx280 (INPUT TABLE tt-decl-hist-embarq-imp,
                                             OUTPUT TABLE tt-bo-erro APPEND,
                                             OUTPUT tt-decl-hist-embarq-imp.r-rowid).
       end.                                      
   end.
   else if  c-acao = "UPDATE":u then do:
            RUN validateUpdate IN h-bocx280 (INPUT  TABLE tt-decl-hist-embarq-imp,
                                             input tt-decl-hist-embarq-imp.r-rowid,
                                             OUTPUT TABLE tt-bo-erro APPEND).

   end.   

   /*valida as vari veis do texto  das declara‡äes */
   run validaTexto in h-bocx010 (input tt-decl-hist-embarq-imp.texto,
                                 output table tt-bo-erro APPEND).

    IF CAN-FIND(FIRST tt-bo-erro) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.

        RUN showMessages IN hShowMsg (INPUT TABLE tt-bo-erro).

        LEAVE.
    END.
    ELSE DO:
        RUN getRowid IN h-bocx280 (OUTPUT tt-decl-hist-embarq-imp.r-rowid).
        /*RUN bringParent IN phCaller.*/
        RUN repositionRecord IN phCaller (INPUT prParent).
        IF VALID-HANDLE(h-bocx280) THEN DO:
            delete procedure h-bocx280.
        END.
        IF VALID-HANDLE(h-bocx010) THEN DO:
            delete procedure h-bocx010.
        END.
        IF VALID-HANDLE(h-bocx230) THEN DO:
            delete procedure h-bocx230.
        END.
        IF VALID-HANDLE(h-bocx110) THEN DO:
            DELETE PROCEDURE h-bocx110.
            ASSIGN h-bocx110 = ?.
        END.
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-decl-hist-embarq-imp.de-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decl-hist-embarq-imp.de-codigo wWindow
ON F5 OF tt-decl-hist-embarq-imp.de-codigo IN FRAME fpage0 /* Cod Declara‡Æo */
DO:
   {method/zoomfields.i 
     &ProgramZoom="cxzoom/z01cx010.w"
     &FieldZoom1="de-codigo"
     &FieldScreen1="tt-decl-hist-embarq-imp.de-codigo"
     &Frame1="fPage0"
     &FieldZoom2="descricao"
     &FieldScreen2="fill-in-1"
     &Frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decl-hist-embarq-imp.de-codigo wWindow
ON LEAVE OF tt-decl-hist-embarq-imp.de-codigo IN FRAME fpage0 /* Cod Declara‡Æo */
DO:
    /**
    * DESCRI€ÇO DA DESPESA 
    ***/
    RUN findCodigo IN h-bocx280 (INPUT tt-decl-hist-embarq-imp.cod-estabel,
                                 INPUT tt-decl-hist-embarq-imp.embarque,
                                 INPUT tt-decl-hist-embarq-imp.cod-itiner,
                                 INPUT tt-decl-hist-embarq-imp.sequencia,
                                 INPUT INT(tt-decl-hist-embarq-imp.de-codigo:SCREEN-VALUE IN FRAME fPage0),
                                 OUTPUT c-return).
        
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-bocx280 (INPUT "descricao":U, 
                                       OUTPUT c-desc).
        IF c-desc <> "":U THEN
            ASSIGN fill-in-1:SCREEN-VALUE IN FRAME fPage0 = c-desc.
    END.

    IF TRIM(c-desc) = "":U OR c-return <> "":U THEN DO:
          {method/referencefields.i 
              &HandleDBOLeave="h-bocx010"
              &FindMethod="findPk_de_codigo"
              &KeyValue1="tt-decl-hist-embarq-imp.de-codigo:SCREEN-VALUE IN FRAME fPage0"
              &FieldName1="descricao"
              &FieldScreen1="fill-in-1"
              &Frame1="fPage0"}
    END.

    if  c-acao = "ADD":u then do:
      &IF '{&mgdis_version}' >= '2.06f' &THEN
          run fnbo/bofn017.p persistent set h-bofn017.
          run goTokey in h-bofn017 (input v_cod_usuar_corren).
          IF RETURN-VALUE = "OK" THEN DO:
              run getCurrent in h-bofn017 (output table tt_usuar_mestre).
              find first tt_usuar_mestre no-error.
              if   avail tt_usuar_mestre then
                  assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
          END.
          delete procedure h-bofn017.
      &ELSE
          run unbo/boun178.p persistent set h-boun178.
          run findSrmstr_id in h-boun178 (input v_cod_usuar_corren, output c-return).
          if  c-return = "" then do:
              run getCurrent in h-boun178 (output table tt_usuar_mestre).
              find first tt_usuar_mestre no-error.
              if   avail tt_usuar_mestre then
                   assign c-idiom-usuar = tt_usuar_mestre.cod_idiom_orig.
          end.
          delete procedure h-boun178.
      &ENDIF
      
      run findRowid in h-bocx230(input prParent).
      run getCharfield in h-bocx230(input "embarque":u,output c-embarque).
      run getCharfield in h-bocx230(input "cod-estabel":u,output c-cod-estabel).

      run cxbo/bocx225.p persistent set h-bocx225.
      run findEmbarque in h-bocx225(input c-cod-estabel,
                                    input c-embarque,
                                    output c-return).
      if c-return = "" then 
         run getCharfield in h-bocx225(input "nr-proc-imp":u,output c-nr-proc-imp).
      delete procedure h-bocx225.

      run cxbo/bocx140.p persistent set h-bocx140.
      run findPk_nr_processo in h-bocx140(input c-nr-proc-imp,output c-return).        
      if c-return = "" then 
         run getIntfield in h-bocx140 (input "cod-exportador",output i-cod-emitente).
      delete procedure h-bocx140.


      run retornaTexto in h-bocx280 (input c-embarque,
                                     input c-cod-estabel,
                                     input i-cod-emitente,  
                                     input int(tt-decl-hist-embarq-imp.de-codigo:screen-value in frame fpage0),    
                                     input c-idiom-usuar,
                                     output tt-decl-hist-embarq-imp.e-mail-agente,
                                     output tt-decl-hist-embarq-imp.e-mail-despachante,
                                     output tt-decl-hist-embarq-imp.e-mail-emitente,
                                     output tt-decl-hist-embarq-imp.e-mail-fabricante,
                                     output tt-decl-hist-embarq-imp.e-mail-repres,
                                     output tt-decl-hist-embarq-imp.texto).


    assign    tt-decl-hist-embarq-imp.e-mail-despachante:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-despachante
              tt-decl-hist-embarq-imp.e-mail-agente:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-agente
              tt-decl-hist-embarq-imp.e-mail-emitente:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-emitente
              tt-decl-hist-embarq-imp.e-mail-fabricante:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-fabricante
              tt-decl-hist-embarq-imp.e-mail-repres:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-repres
              tt-decl-hist-embarq-imp.e-mail-outros:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-outros
              tt-decl-hist-embarq-imp.texto:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.texto.                                  

  end.       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-decl-hist-embarq-imp.de-codigo wWindow
ON MOUSE-SELECT-DBLCLICK OF tt-decl-hist-embarq-imp.de-codigo IN FRAME fpage0 /* Cod Declara‡Æo */
DO:

  apply "F5" to self.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-pto-contr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-pto-contr wWindow
ON F5 OF fi-cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
    {method/zoomfields.i &ProgramZoom="cxzoom/z01cx310.w"
                     &FieldZoom1="cod-pto-contr"
                     &FieldScreen1="fi-cod-pto-contr"
                     &frame1=fPage0
                     &RunMethod="RUN setaVariable IN hProgramZoom (INPUT prParent)."
                     &EnableImplant="no"}
    WAIT-FOR "CLOSE":U OF hProgramZoom.
    APPLY "LEAVE":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-pto-contr wWindow
ON LEAVE OF fi-cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO: 
   run findRowid in h-bocx230(input prParent).
   run getCharfield in h-bocx230(input "cod-estabel",output tt-decl-hist-embarq-imp.cod-estabel).
   run getCharfield in h-bocx230(input "embarque"   ,output tt-decl-hist-embarq-imp.embarque).
   run getIntfield in h-bocx230 (input "cod-itiner" ,output tt-decl-hist-embarq-imp.cod-itiner).

    /* Descri‡Æo do ponto de controle */
    RUN findCh-itiner IN h-bocx230 (INPUT tt-decl-hist-embarq-imp.cod-estabel,
                                    INPUT tt-decl-hist-embarq-imp.embarque,
                                    INPUT tt-decl-hist-embarq-imp.cod-itiner,
                                    INPUT INT(fi-cod-pto-contr:SCREEN-VALUE IN FRAME fPage0),
                                    OUTPUT c-return).
    IF c-return = "":U THEN DO:
        RUN getCharField IN h-bocx230 (INPUT "descricao":U, 
                                       OUTPUT c-desc).
        RUN getIntField IN h-bocx230(INPUT "sequencia":U,
                                     OUTPUT tt-decl-hist-embarq-imp.sequencia).
        IF c-desc <> "":U THEN
            ASSIGN fi-descricao-pto:SCREEN-VALUE IN FRAME fPage0 = c-desc.
    END.

    IF TRIM(c-desc) = "":U OR c-return <> "":U THEN DO:
        {method/referencefields.i &HandleDBOLeave="h-bocx110"
                                  &FindMethod="findCodigo"
                                  &KeyValue1="fi-cod-pto-contr:SCREEN-VALUE IN FRAME fPage0"
                                  &FieldName1="descricao"
                                  &FieldScreen1="fi-descricao-pto"
                                  &Frame1="fPage0"}
    END.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-pto-contr wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-pto-contr IN FRAME fpage0 /* Ponto Controle */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/* ***************************  Main Block  *************************** */

tt-decl-hist-embarq-imp.de-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
fi-cod-pto-contr:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/*--- L¢gica para inicializa‡Æo do programam ---*/
RUN cxbo/bocx280.p persistent set h-bocx280.
RUN cxbo/bocx010.p persistent set h-bocx010.
RUN cxbo/bocx230.p persistent set h-bocx230.
RUN cxbo/bocx110.p persistent set h-bocx110.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE AfterdisplayWidgets wWindow 
PROCEDURE AfterdisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

if c-acao = "UPDATE":u then do:
    run findRowid in h-bocx280 (input r-row).
    run getCurrent in h-bocx280 (output table tt-decl-hist-embarq-imp).
    find first tt-decl-hist-embarq-imp no-error.
    if   avail tt-decl-hist-embarq-imp then do:
         assign  
              tt-decl-hist-embarq-imp.de-codigo:screen-value in frame fpage0 = string(tt-decl-hist-embarq-imp.de-codigo)
              tt-decl-hist-embarq-imp.int-2:screen-value in frame fpage0 = string(tt-decl-hist-embarq-imp.int-2)
              tt-decl-hist-embarq-imp.decl-emitida:screen-value in frame fpage0 = string(tt-decl-hist-embarq-imp.decl-emitida)
              tt-decl-hist-embarq-imp.int-1:screen-value in frame fpage0 = string(tt-decl-hist-embarq-imp.int-1)
              tt-decl-hist-embarq-imp.e-mail-despachante:screen-value in frame fpage0 =  tt-decl-hist-embarq-imp.e-mail-despachante
              tt-decl-hist-embarq-imp.e-mail-agente:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-agente
              tt-decl-hist-embarq-imp.e-mail-emitente:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-emitente
              tt-decl-hist-embarq-imp.e-mail-fabricante:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-fabricante
              tt-decl-hist-embarq-imp.e-mail-repres:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-repres
              tt-decl-hist-embarq-imp.e-mail-outros:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.e-mail-outros
              tt-decl-hist-embarq-imp.texto:screen-value in frame fpage0 = tt-decl-hist-embarq-imp.texto
              fi-cod-pto-contr:SCREEN-VALUE IN FRAME fPage0 = STRING(fnPtoSeq(tt-decl-hist-embarq-imp.cod-estabel,
                                                                              tt-decl-hist-embarq-imp.embarque,
                                                                              tt-decl-hist-embarq-imp.cod-itiner,
                                                                              tt-decl-hist-embarq-imp.sequencia)).
        apply "leave" to tt-decl-hist-embarq-imp.de-codigo in frame fpage0.
        apply "leave" to fi-cod-pto-contr in frame fpage0.
        apply "entry" to tt-decl-hist-embarq-imp.int-2 in frame fpage0.              
        disable tt-decl-hist-embarq-imp.de-codigo
                fi-cod-pto-contr WITH FRAME fPage0.
    end.
end.    
else if c-acao = "ADD":u then 
     enable tt-decl-hist-embarq-imp.de-codigo
            fi-cod-pto-contr with frame fpage0.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE BeforedisplayWidgets wWindow 
PROCEDURE BeforedisplayWidgets :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    create tt-decl-hist-embarq-imp.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnPtoSeq wWindow 
FUNCTION fnPtoSeq RETURNS INTEGER
  ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-seq as int ):
/*------------------------------------------------------------------------------
  Purpose:  Retornar o c¢digo do ponto de controle de acordo com a sequencia do mesmo.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-pto AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findPto-Controle-por-sequencia IN h-bocx230(INPUT p-cod-est,  
                                                    INPUT p-embarque,  
                                                    INPUT p-cod-itiner,                                                 
                                                    INPUT p-seq,                                               
                                                    OUTPUT c-return).

    IF TRIM(c-return) = "":U THEN
        RUN getIntField in h-bocx230 (input "cod-pto-contr":U, output i-pto). 

    RETURN i-pto.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnSeqPto wWindow 
FUNCTION fnSeqPto RETURNS INTEGER
  ( INPUT p-cod-est AS CHAR,
    INPUT p-embarque AS CHAR,
    INPUT p-cod-itiner AS INT,
    input p-pto-contr as int ):
/*------------------------------------------------------------------------------
  Purpose:  Retornar o c¢digo do ponto de controle de acordo com a sequencia do mesmo.
    Notes:  
------------------------------------------------------------------------------*/
    DEFINE VARIABLE i-seq AS INTEGER     NO-UNDO.
    DEFINE VARIABLE c-return    AS CHARACTER NO-UNDO.

    RUN findCh-itiner IN h-bocx230(INPUT p-cod-est,  
                                   INPUT p-embarque,  
                                   INPUT p-cod-itiner,                                                 
                                   INPUT p-pto-contr,                                               
                                   OUTPUT c-return).

    IF TRIM(c-return) = "":U THEN
        RUN getIntField in h-bocx230 (input "sequencia":U, output i-seq). 

    RETURN i-seq.   /* Function return value. */
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

