&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
*/
&Scoped-define WINDOW-NAME wMasterDetail


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-rota-coleta NO-UNDO LIKE rota-coleta
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMasterDetail 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AQ0202 2.00.00.019 } /*** 010019 ***/
/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i {1} MAQ}
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program          {1}
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE First            YES
&GLOBAL-DEFINE Prev             YES
&GLOBAL-DEFINE Next             YES
&GLOBAL-DEFINE Last             YES
&GLOBAL-DEFINE GoTo             YES
&GLOBAL-DEFINE Search           YES

&GLOBAL-DEFINE AddParent        no 
&GLOBAL-DEFINE CopyParent       no 
&GLOBAL-DEFINE UpdateParent     no 
&GLOBAL-DEFINE DeleteParent     no    

&GLOBAL-DEFINE ttParent         tt-rota-coleta         
&GLOBAL-DEFINE hDBOParent       hboin00975                
&GLOBAL-DEFINE DBOParentTable   rota-coleta

&GLOBAL-DEFINE page0Fields      tt-rota-coleta.cod-rota ~
                                tt-rota-coleta.des-rota

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def work-table w-equipto no-undo
    fields cd-equipto as char.

def var i-cont      as int        no-undo.
def var c-equipto   as char       no-undo.
def var r-rowid-pai as ROWID      no-undo.

def var l-validade    as logical init yes           no-undo.
def var c-format      as char    init ">>,>>9.9999" no-undo.
def var da-dt-refer   as date    init today         no-undo.
def var l-ok          as logical init no            no-undo.
def var l-consulta    as logical init no            no-undo.
def var l-expanded    as logical init no            no-undo.

def new global shared var gr-produt-rural-aq0207 as rowid no-undo.
def new global shared var gr-pto-coleta-aq0205   as rowid no-undo.
def new global shared var gr-rota-coleta-aq0204  as rowid no-undo.
DEF new global shared var gr-emitente            as rowid no-undo.

/* Local Variable Definitions (DBOs Handles) ---                        */
DEFINE VARIABLE {&hDBOParent}   AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00975-aux AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boin00962     AS HANDLE NO-UNDO.

DEFINE TEMP-TABLE ttEstrutRota NO-UNDO
    FIELD nivel        AS INT FORMAT "9"
    FIELD cdn-seq      AS INT FORMAT ">>>>>9"
    FIELD id           AS CHAR
    FIELD r-rowid      AS ROWID
    FIELD cod-reg      AS CHAR FORMAT "x(50)"
    FIELD cod-reg-pai  AS CHAR FORMAT "x(50)"
    FIELD des-reg      AS CHAR FORMAT "x(100)".

DEFINE BUFFER BFttEstrutRota FOR ttEstrutRota.
DEFINE BUFFER BFttEstrutRota-aux FOR ttEstrutRota.

// Definiá‰es de v†riaveis e procedures facilidadors para montar o treeview sem OCX
{utp/ut-4gltreeview.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MasterDetail
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-rota-coleta.cod-rota ~
tt-rota-coleta.des-rota 
&Scoped-define ENABLED-TABLES tt-rota-coleta
&Scoped-define FIRST-ENABLED-TABLE tt-rota-coleta
&Scoped-Define ENABLED-OBJECTS rtToolBar rtParent btFirst btPrev btNext ~
btLast btGoTo btSearch btExpande btMapaRota btQueryJoins btReportsJoins ~
btExit btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-rota-coleta.cod-rota ~
tt-rota-coleta.des-rota 
&Scoped-define DISPLAYED-TABLES tt-rota-coleta
&Scoped-define FIRST-DISPLAYED-TABLE tt-rota-coleta


/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD fnDescFilho wMasterDetail 
FUNCTION fnDescFilho RETURNS CHARACTER
   (INPUT pcEquipto AS CHARACTER)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMasterDetail AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU smFile 
       MENU-ITEM miFirst        LABEL "&Primeiro"     
       MENU-ITEM miPrev         LABEL "&Anterior"      
       MENU-ITEM miNext         LABEL "&Pr¢ximo"       
       MENU-ITEM miLast         LABEL "&Èltimo"        
       RULE
       MENU-ITEM miGoTo         LABEL "&V† Para"      
       MENU-ITEM miSearch       LABEL "&Pesquisa"     
       RULE       
       MENU-ITEM miExpande      LABEL "E&xpande"
       RULE
       MENU-ITEM miQueryJoins   LABEL "&Consultas"    
       MENU-ITEM miReportsJoins LABEL "&Relat¢rios"   
       RULE
       MENU-ITEM miExit         LABEL "&Sair".         

DEFINE SUB-MENU smHelp 
       MENU-ITEM miContents     LABEL "&Conte£do"     
       RULE
       MENU-ITEM miAbout        LABEL "&Sobre..."     .

DEFINE MENU mbMain MENUBAR
       SUB-MENU  smFile         LABEL "&Arquivo"      
       SUB-MENU  smHelp         LABEL "&Ajuda"        .



/* Definitions of the field level widgets                               */
DEFINE BUTTON btEndereco 
     LABEL "&Endereáo" 
     SIZE 10 BY 1.

DEFINE BUTTON btExit 
     IMAGE-UP FILE "image\im-exi":U
     IMAGE-INSENSITIVE FILE "image\ii-exi":U
     LABEL "Exit" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btExpande 
     IMAGE-UP FILE "image\im-crit":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Expandir/Contrair".

DEFINE BUTTON btFirst 
     IMAGE-UP FILE "image\im-fir":U
     IMAGE-INSENSITIVE FILE "image\ii-fir":U
     LABEL "First":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btGoTo 
     IMAGE-UP FILE "image\im-enter":U
     IMAGE-INSENSITIVE FILE "image\ii-enter":U
     LABEL "Go To" 
     SIZE 4 BY 1.25.

DEFINE BUTTON btHelp 
     IMAGE-UP FILE "image\im-hel":U
     IMAGE-INSENSITIVE FILE "image\ii-hel":U
     LABEL "Help" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btLast 
     IMAGE-UP FILE "image\im-las":U
     IMAGE-INSENSITIVE FILE "image\ii-las":U
     LABEL "Last":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btMapaRota 
     IMAGE-UP FILE "image\im-f-ibt.bmp":U
     LABEL "" 
     SIZE 4 BY 1.25 TOOLTIP "Exibe o mapa da rota no navegador".

DEFINE BUTTON btNext 
     IMAGE-UP FILE "image\im-nex":U
     IMAGE-INSENSITIVE FILE "image\ii-nex":U
     LABEL "Next":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btPrev 
     IMAGE-UP FILE "image\im-pre":U
     IMAGE-INSENSITIVE FILE "image\ii-pre":U
     LABEL "Prev":L 
     SIZE 4 BY 1.25.

DEFINE BUTTON btProdutor 
     LABEL "P&rodutor" 
     SIZE 10 BY 1.

DEFINE BUTTON btPtoColeta 
     LABEL "&Ponto Coleta" 
     SIZE 10 BY 1.

DEFINE BUTTON btQueryJoins 
     IMAGE-UP FILE "image\im-joi":U
     IMAGE-INSENSITIVE FILE "image\ii-joi":U
     LABEL "Query Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btReportsJoins 
     IMAGE-UP FILE "image\im-pri":U
     IMAGE-INSENSITIVE FILE "image\ii-pri":U
     LABEL "Reports Joins" 
     SIZE 4 BY 1.25
     FONT 4.

DEFINE BUTTON btRotaCol 
     LABEL "&Rota Coleta" 
     SIZE 10 BY 1.

DEFINE BUTTON btSearch 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "Search" 
     SIZE 4 BY 1.25.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 1.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.5
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     btFirst AT ROW 1.13 COL 1.57 HELP
          "Primeira ocorrància"
     btPrev AT ROW 1.13 COL 5.57 HELP
          "Ocorrància anterior"
     btNext AT ROW 1.13 COL 9.57 HELP
          "Pr¢xima ocorrància"
     btLast AT ROW 1.13 COL 13.57 HELP
          "Èltima ocorrància"
     btGoTo AT ROW 1.13 COL 17.57 HELP
          "V† Para"
     btSearch AT ROW 1.13 COL 21.57 HELP
          "Pesquisa"
     btExpande AT ROW 1.13 COL 32.72 HELP
          "Expande/Contrai Estrutura"
     btMapaRota AT ROW 1.13 COL 36.86 HELP
          "Expande/Contrai Estrutura" WIDGET-ID 8
     btQueryJoins AT ROW 1.13 COL 74.86 HELP
          "Consultas relacionadas"
     btReportsJoins AT ROW 1.13 COL 78.86 HELP
          "Relat¢rios relacionados"
     btExit AT ROW 1.13 COL 82.86 HELP
          "Sair"
     btHelp AT ROW 1.13 COL 86.86 HELP
          "Ajuda"
     tt-rota-coleta.cod-rota AT ROW 2.92 COL 13.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     tt-rota-coleta.des-rota AT ROW 2.92 COL 32.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 50.43 BY .88
     btRotaCol AT ROW 16.75 COL 1.72
     btPtoColeta AT ROW 16.75 COL 11.86 WIDGET-ID 4
     btProdutor AT ROW 16.75 COL 22 WIDGET-ID 6
     btEndereco AT ROW 16.75 COL 32 WIDGET-ID 2
     rtToolBar AT ROW 1 COL 1
     rtParent AT ROW 2.67 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MasterDetail
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-rota-coleta T "?" NO-UNDO mgind rota-coleta
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMasterDetail ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 16.96
         WIDTH              = 90
         MAX-HEIGHT         = 21.21
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 21.21
         VIRTUAL-WIDTH      = 114.29
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

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU mbMain:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMasterDetail 
/* ************************* Included-Libraries *********************** */

{masterdetail/masterdetail.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMasterDetail
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fPage0
   FRAME-NAME                                                           */
/* SETTINGS FOR BUTTON btEndereco IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btProdutor IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btPtoColeta IN FRAME fPage0
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON btRotaCol IN FRAME fPage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMasterDetail)
THEN wMasterDetail:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage0
/* Query rebuild information for FRAME fPage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage0 */
&ANALYZE-RESUME

 

/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMasterDetail
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON END-ERROR OF wMasterDetail
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMasterDetail wMasterDetail
ON WINDOW-CLOSE OF wMasterDetail
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btEndereco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btEndereco wMasterDetail
ON CHOOSE OF btEndereco IN FRAME fPage0 /* Endereáo */
DO:
  
    IF NOT l-consulta THEN DO:
        DEF VAR r-rowid-emit AS ROWID NO-UNDO.
          
        ASSIGN gr-emitente = ?.
        FIND FIRST BFttEstrutRota WHERE BFttEstrutRota.id = c-codigo-node NO-LOCK NO-ERROR.
        IF AVAIL BFttEstrutRota THEN DO:
    
            RUN getRowidEmitente IN h-boin00962 (INPUT  BFttEstrutRota.r-rowid,
                                                 OUTPUT r-rowid-emit).
            
            ASSIGN gr-emitente = r-rowid-emit.
    
            run cdp/cd0705.w.    
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExit
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExit wMasterDetail
ON CHOOSE OF btExit IN FRAME fPage0 /* Exit */
OR CHOOSE OF MENU-ITEM miExit IN MENU mbMain DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btExpande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btExpande wMasterDetail
ON CHOOSE OF btExpande IN FRAME fPage0
DO:
  
  ASSIGN l-expanded = NOT l-expanded.
  RUN piExpande IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFirst
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFirst wMasterDetail
ON CHOOSE OF btFirst IN FRAME fPage0 /* First */
OR CHOOSE OF MENU-ITEM miFirst IN MENU mbMain DO:
    RUN getFirst IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btGoTo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btGoTo wMasterDetail
ON CHOOSE OF btGoTo IN FRAME fPage0 /* Go To */
OR CHOOSE OF MENU-ITEM miGoTo IN MENU mbMain DO:
    RUN goToRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMasterDetail
ON CHOOSE OF btHelp IN FRAME fPage0 /* Help */
OR CHOOSE OF MENU-ITEM miContents IN MENU mbMain DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLast
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLast wMasterDetail
ON CHOOSE OF btLast IN FRAME fPage0 /* Last */
OR CHOOSE OF MENU-ITEM miLast IN MENU mbMain DO:
    RUN getLast IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btMapaRota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMapaRota wMasterDetail
ON CHOOSE OF btMapaRota IN FRAME fPage0
DO:

    IF VALID-HANDLE({&hDBOParent}) THEN DO: /*mostra o mapa da rota no navegador*/
        
        RUN emptyRowErrors IN ({&hDBOParent}).

        RUN mostraRotaMapa IN ({&hDBOParent})(INPUT tt-rota-coleta.cod-rota).

        IF RETURN-VALUE = "NOK":U THEN DO:

            RUN getRowErrors IN ({&hDBOParent}) (OUTPUT TABLE RowErrors).

            FOR EACH RowErrors WHERE RowErrors.ErrorType = "INTERNAL":U EXCLUSIVE-LOCK:
                DELETE RowErrors.
            END.
            IF CAN-FIND (FIRST RowErrors) THEN DO:
                {method/showmessage.i1}
                {method/showmessage.i2 &Modal="YES"}

                EMPTY TEMP-TABLE RowErrors.

            END.
        END.

    END.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btNext
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btNext wMasterDetail
ON CHOOSE OF btNext IN FRAME fPage0 /* Next */
OR CHOOSE OF MENU-ITEM miNext IN MENU mbMain DO:
    RUN getNext IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPrev wMasterDetail
ON CHOOSE OF btPrev IN FRAME fPage0 /* Prev */
OR CHOOSE OF MENU-ITEM miPrev IN MENU mbMain DO:
    RUN getPrev IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btProdutor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btProdutor wMasterDetail
ON CHOOSE OF btProdutor IN FRAME fPage0 /* Produtor */
DO:

  DEF VAR h-program AS HANDLE NO-UNDO.

  ASSIGN gr-produt-rural-aq0207 = ?.
  FIND FIRST BFttEstrutRota WHERE BFttEstrutRota.id = c-codigo-node NO-LOCK NO-ERROR.
  IF AVAIL BFttEstrutRota THEN
      ASSIGN gr-produt-rural-aq0207 = BFttEstrutRota.r-rowid.

  {&window-name}:sensitive = no.

  session:set-wait-state( "general":U ).

  if  not valid-handle(h-program) then
     IF l-consulta THEN   
        run aqp/aq0407.w persistent set h-program no-error.
     ELSE
        run aqp/aq0207.w persistent set h-program no-error.

  run initializeInterface in h-program no-error.
  
  session:set-wait-state( "":U ).
  
  wait-for CLOSE of h-program focus current-window.   
  
  {&window-name}:sensitive = yes.

  if valid-handle(h-program) then
      delete procedure h-program.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btPtoColeta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btPtoColeta wMasterDetail
ON CHOOSE OF btPtoColeta IN FRAME fPage0 /* Ponto Coleta */
DO:
  
  DEF VAR h-program AS HANDLE NO-UNDO.

  ASSIGN gr-pto-coleta-aq0205 = ?.
  FIND FIRST BFttEstrutRota WHERE BFttEstrutRota.id = c-codigo-node NO-LOCK NO-ERROR.
  IF AVAIL BFttEstrutRota THEN
      ASSIGN gr-pto-coleta-aq0205 = BFttEstrutRota.r-rowid.

  {&window-name}:sensitive = no.

  session:set-wait-state( "general":U ).

  IF NOT VALID-HANDLE(h-program) then 
      RUN aqp/aq0405.w PERSISTENT SET h-program NO-ERROR.

  run initializeInterface in h-program no-error.
  
  session:set-wait-state( "":U ).
  
  wait-for CLOSE of h-program focus current-window.   
  
  {&window-name}:sensitive = yes.
  ASSIGN gr-pto-coleta-aq0205 = ?.
  if valid-handle(h-program) then
      delete procedure h-program.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btQueryJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btQueryJoins wMasterDetail
ON CHOOSE OF btQueryJoins IN FRAME fPage0 /* Query Joins */
OR CHOOSE OF MENU-ITEM miQueryJoins IN MENU mbMain DO:
    RUN showQueryJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btReportsJoins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btReportsJoins wMasterDetail
ON CHOOSE OF btReportsJoins IN FRAME fPage0 /* Reports Joins */
OR CHOOSE OF MENU-ITEM miReportsJoins IN MENU mbMain DO:
    RUN showReportsJoins IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btRotaCol
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btRotaCol wMasterDetail
ON CHOOSE OF btRotaCol IN FRAME fPage0 /* Rota Coleta */
DO:
  
  DEF VAR h-program AS HANDLE NO-UNDO.

  DEFINE VARIABLE c-program AS CHARACTER NO-UNDO.
  
  IF AVAIL tt-rota-coleta then DO: 
     ASSIGN gr-rota-coleta-aq0204 = tt-rota-coleta.r-rowid.
     
     {&WINDOW-NAME}:SENSITIVE = NO.

     SESSION:SET-WAIT-STATE( "general":U ).

     IF NOT VALID-HANDLE(h-program) then
        IF l-consulta THEN            
            RUN aqp/aq0404.w PERSISTENT SET h-program NO-ERROR.
        ELSE
            RUN aqp/aq0204.w PERSISTENT SET h-program NO-ERROR.

     RUN initializeInterface in h-program NO-ERROR.

     SESSION:SET-WAIT-STATE( "":U ).

     WAIT-FOR CLOSE OF h-program FOCUS CURRENT-WINDOW.   

     {&WINDOW-NAME}:SENSITIVE = YES.

     IF VALID-HANDLE(H-PROGRAM) THEN
         DELETE PROCEDURE H-PROGRAM.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSearch
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSearch wMasterDetail
ON CHOOSE OF btSearch IN FRAME fPage0 /* Search */
OR CHOOSE OF MENU-ITEM miSearch IN MENU mbMain DO:
    {method/zoomreposition.i &ProgramZoom="inzoom/z01in00975.w"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&Scoped-define SELF-NAME miExpande
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL miExpande wMasterDetail
ON CHOOSE OF MENU-ITEM miExpande /* Expande */
DO:
    apply "choose":U to btExpande in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMasterDetail 


/*--- L¢gica para inicializaá∆o do programam ---*/
{masterdetail/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMasterDetail 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-boin00975-aux)
       THEN RUN destroy IN h-boin00975-aux.

    IF VALID-HANDLE(h-boin00962)
       THEN RUN destroy IN h-boin00962.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMasterDetail 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN l-expanded = NO.

    RUN carregaTreeView IN THIS-PROCEDURE.
    RUN piMontaEstrutura IN THIS-PROCEDURE (INPUT NO ).
    
    IF AVAIL BFttEstrutRota THEN DO:
        ENABLE btExpande with frame fPage0.
    END.
    ELSE DO:
        DISABLE btExpande with frame fPage0.
        DISABLE btEndereco btProdutor btPtoColeta WITH FRAME fpage0.
    END.

    ASSIGN btMapaRota:SENSITIVE IN FRAME fPage0 = tt-rota-coleta.cod-rota <> "":U.
    
    RETURN "OK":U.      

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToRecord wMasterDetail 
PROCEDURE goToRecord :
/*------------------------------------------------------------------------------
  Purpose:     Exibe dialog de V† Para
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE BUTTON btGoToCancel AUTO-END-KEY 
         LABEL "&Cancelar" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE BUTTON btGoToOK AUTO-GO 
         LABEL "&OK" 
         SIZE 10 BY 1
         BGCOLOR 8.
    
    DEFINE RECTANGLE rtGoToButton
         EDGE-PIXELS 2 GRAPHIC-EDGE  
         SIZE 58 BY 1.42
         BGCOLOR 7.
    
    DEFINE VARIABLE rGoTo AS ROWID NO-UNDO.
    
    DEFINE VARIABLE cCodRota      LIKE {&ttParent}.cod-rota NO-UNDO
           VIEW-AS FILL-IN SIZE 18 BY 0.88 .

    
    DEFINE FRAME fGoToRecord
        cCodRota        AT ROW 1.75 COL 23 COLON-ALIGNED
        btGoToOK          AT ROW 3.63 COL 2.14
        btGoToCancel      AT ROW 3.63 COL 13
        rtGoToButton      AT ROW 3.38 COL 1
        SPACE(0.28)
        WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER SIDE-LABELS NO-UNDERLINE 
             THREE-D SCROLLABLE TITLE "V† Para Equipamento" FONT 1
             DEFAULT-BUTTON btGoToOK CANCEL-BUTTON btGoToCancel.
    /* Inicio -- Projeto Internacional -- ut-trfrrp.p adicionado */
    RUN utp/ut-trfrrp.p (INPUT FRAME fGoToRecord:HANDLE).
    
    ON "CHOOSE":U OF btGoToOK IN FRAME fGoToRecord DO:
        ASSIGN cCodRota.
        
        RUN goToKey   IN {&hDBOParent} (INPUT cCodRota).
        IF RETURN-VALUE = "NOK":U THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Regi∆o Abrangància" *}
            RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 2, INPUT RETURN-VALUE).
            
            RETURN NO-APPLY.
        END.
        
        /* Retorna rowid do registro corrente do DBO */
        RUN getRowid IN {&hDBOParent} (OUTPUT rGoTo).
        
        /* Reposiciona registro com base em um rowid */
        RUN repositionRecord IN THIS-PROCEDURE (INPUT rGoTo).

        APPLY "GO":U TO FRAME fGoToRecord.
    END.
    
    ENABLE cCodRota btGoToOK btGoToCancel 
        WITH FRAME fGoToRecord. 
    
    WAIT-FOR "GO":U OF FRAME fGoToRecord.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMasterDetail 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOParent}) THEN DO:
        {btb/btb008za.i1 inbo/boin00975.p}
        {btb/btb008za.i2 inbo/boin00975.p '' {&hDBOParent}} 
    END.
    
    RUN openQueryStatic IN {&hDBOParent} (INPUT "Main":U) NO-ERROR.
    
    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00975-aux) THEN DO:
        {btb/btb008za.i1 inbo/boin00975.p}
        {btb/btb008za.i2 inbo/boin00975.p '' h-boin00975-aux} 
    END.

    /*--- Verifica se o DBO j† est† inicializado ---*/
    IF NOT VALID-HANDLE(h-boin00962) THEN DO:
        {btb/btb008za.i1 inbo/boin00962.p}
        {btb/btb008za.i2 inbo/boin00962.p '' h-boin00962} 
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueriesSon wMasterDetail 
PROCEDURE openQueriesSon :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers filhos
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
                                                      

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

// Procedure executada toda vez que ocorrer um evento de click em um node
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-ClickTreeView wMasterDetail 
PROCEDURE pi-ClickTreeView :

   
   IF DYNAMIC-FUNCTION('hasNodes' IN h-4gltreeview) THEN DO:
        FIND FIRST BFttEstrutRota WHERE BFttEstrutRota.id = c-codigo-node NO-LOCK NO-ERROR.
        IF AVAIL BFttEstrutRota THEN DO:
            ASSIGN btRotaCol:SENSITIVE IN FRAME fpage0 = YES.
    
            IF BFttEstrutRota.nivel = 1 THEN
                ASSIGN btEndereco:SENSITIVE IN FRAME fpage0 = NO
                       btProdutor:SENSITIVE IN FRAME fpage0 = NO
                       btPtoColeta:SENSITIVE IN FRAME fpage0 = YES.
            ELSE IF BFttEstrutRota.nivel = 2 OR BFttEstrutRota.nivel = 3 THEN
                ASSIGN btEndereco:SENSITIVE IN FRAME fpage0 = YES
                       btProdutor:SENSITIVE IN FRAME fpage0 = YES
                       btPtoColeta:SENSITIVE IN FRAME fpage0 = NO.
    
        END.
        ELSE
            ASSIGN btRotaCol:SENSITIVE IN FRAME fpage0 = NO.

    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExpande wMasterDetail 
PROCEDURE piExpande :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    RUN piMontaEstrutura ( INPUT l-expanded).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMasterDetail 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   
    ASSIGN l-consulta = "{1}":U = "aq0402":U.
   
    IF l-consulta THEN 
        ASSIGN btEndereco:HIDDEN IN FRAME fPage0 = YES.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMontaEstrutura wMasterDetail 
PROCEDURE piMontaEstrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   DEFINE INPUT PARAM lExpanded AS LOGICAL NO-UNDO.

   DEFINE VARIABLE i-reg   AS INTEGER   NO-UNDO.
   DEFINE VARIABLE i-reg-2 AS INTEGER   NO-UNDO.
   DEFINE VARIABLE c-id    AS CHARACTER NO-UNDO.
   DEFINE VARIABLE cOptions AS CHARACTER   NO-UNDO.

   ASSIGN cOptions = IF lExpanded THEN 'expanded' ELSE ''.
   for each ttEstrutRota:
       delete ttEstrutRota.
   end.
   RUN emptyTree IN h-4gltreeview.

   RUN retornaEstruturaRota IN h-boin00975-aux (input input frame fPage0 tt-rota-coleta.cod-rota,
                                                input-output table ttEstrutRota).   
   ASSIGN c-codigo-node = ''.
   /*Pai*/
   FOR EACH ttEstrutRota
      BREAK BY ttEstrutRota.nivel
            BY ttEstrutRota.cdn-seq:

       IF ttEstrutRota.cod-reg-pai = "":U THEN DO:
           ASSIGN i-reg          = i-reg + 1
                  c-id            = "t" + STRING(i-reg)
                  ttEstrutRota.id = c-id.

           RUN pi-create-node (STRING(ttEstrutRota.id),'',  ttEstrutRota.des-reg,'image/treeview/tvpics/separator.bmp',cOptions).
           IF c-codigo-node = '' THEN
              assign c-codigo-node = STRING(ttEstrutRota.id).
       END.
       
       /*Filhos*/
       FOR EACH BFttEstrutRota exclusive-lock
          WHERE BFttEstrutRota.cod-reg-pai = ttEstrutRota.cod-reg
           BREAK BY BFttEstrutRota.cod-reg-pai:

           IF ttEstrutRota.id = "" THEN NEXT.

           ASSIGN i-reg-2           = i-reg-2 + 1
                  c-id              = "i" + STRING(i-reg-2)
                  BFttEstrutRota.id = c-id.

           RUN pi-create-node (STRING(BFttEstrutRota.id),STRING(ttEstrutRota.id),  BFttEstrutRota.des-reg,'image/treeview/tvpics/separator.bmp',cOptions).
       END.
   END.
    
   // Faz o refresh do treeview
   RUN pi-atualizaTreeview.
 
   // Coloca o cursor no treeview
   RUN applyEntry IN h-4gltreeview (INPUT c-codigo-node).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE carregaTreeView wMasterDetail 
PROCEDURE carregaTreeView :
    
   IF NOT VALID-HANDLE(h-4gltreeview) THEN DO:
      // Instancia o treeview
      RUN utp/ut-4gltreeview.w PERSISTENT SET h-4gltreeview.
    
      // Indica a Frame "Pai" do componente
      RUN setParentFrame IN h-4gltreeview (INPUT FRAME fPage0:HANDLE).
 
      // Inicializa o treeview
      RUN initializeObject IN h-4gltreeview.
    
      // Faz a subscricao dos eventos do treeview
      SUBSCRIBE TO "tvNodeEvent" IN h-4gltreeview.
 
      // Reposiciona o treeview
      RUN repositionObject IN h-4gltreeview (4.35, 1.86).
 
      // Ajusta o tamanho do treeview
      RUN resizeObject IN h-4gltreeview (12.25, 87.57).
   END.
END PROCEDURE.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION fnDescFilho wMasterDetail 
FUNCTION fnDescFilho RETURNS CHARACTER
   (INPUT pcEquipto AS CHARACTER) :

DEFINE VARIABLE cDesc AS CHARACTER NO-UNDO.

{method/referencefields.i 
      &HandleDBOLeave="hboin00975"
      &KeyValue1="pcEquipto"
      &FieldName1="descricao"
      &Variable1="cDesc"}

RETURN cDesc.
END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

