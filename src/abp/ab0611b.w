&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttApont NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.
DEFINE TEMP-TABLE ttLubrif NO-UNDO LIKE mab-item-lubrific
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
{include/i-prgvrs.i AB0611B 2.00.00.009 } /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0611b MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0611B
&GLOBAL-DEFINE Version        2.00.00.009

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Pag. 1

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER TABLE FOR ttApont.
DEFINE INPUT PARAMETER TABLE FOR ttLubrif.
DEFINE INPUT PARAMETER rRowidSon2   AS ROWID NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo   AS CHARACTER                NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOComp      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOItem      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEvento    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOManut     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttApont.num-docto ttApont.ep-codigo ~
ttApont.cod-eqpto ttApont.dat-movto ttApont.hra-inicial ttApont.hra-final 
&Scoped-define ENABLED-TABLES ttApont
&Scoped-define FIRST-ENABLED-TABLE ttApont
&Scoped-Define ENABLED-OBJECTS rtKeys rtToolBar fiDescModelo btOK btCancel ~
btHelp2 
&Scoped-Define DISPLAYED-FIELDS ttApont.num-docto ttApont.ep-codigo ~
ttApont.cod-eqpto ttApont.dat-movto ttApont.hra-inicial ttApont.hra-final 
&Scoped-define DISPLAYED-TABLES ttApont
&Scoped-define FIRST-DISPLAYED-TABLE ttApont
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 4.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fiDeposito AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescComp AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescEvento AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescItem AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescLocal AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescManut AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttApont.num-docto AT ROW 1.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttApont.ep-codigo AT ROW 2.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApont.cod-eqpto AT ROW 3.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescModelo AT ROW 3.25 COL 41.57 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     ttApont.dat-movto AT ROW 4.25 COL 27 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttApont.hra-inicial AT ROW 4.25 COL 47 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttApont.hra-final AT ROW 4.25 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     btOK AT ROW 17.75 COL 2
     btCancel AT ROW 17.75 COL 13
     btHelp2 AT ROW 17.75 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18
         FONT 1.

DEFINE FRAME fPage1
     ttLubrif.cod-comptmento AT ROW 1.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescComp AT ROW 1.08 COL 32.57 COLON-ALIGNED HELP
          "Descri‡Æo do Compartimento" NO-LABEL
     ttLubrif.it-codigo AT ROW 2.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescItem AT ROW 2.08 COL 32.57 COLON-ALIGNED NO-LABEL
     ttLubrif.cod-refer AT ROW 3.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDeposito AT ROW 3.08 COL 61.57 COLON-ALIGNED HELP
          "C¢digo do dep¢sito"
     ttLubrif.lote AT ROW 4.08 COL 18 COLON-ALIGNED FORMAT "x(40)"
          VIEW-AS FILL-IN 
          SIZE 49.57 BY .88
     ttLubrif.cod-localiz AT ROW 5.08 COL 18 COLON-ALIGNED FORMAT "x(20)"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     fiDescLocal AT ROW 5.08 COL 38.43 COLON-ALIGNED NO-LABEL
     ttLubrif.cod-evento AT ROW 6.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescEvento AT ROW 6.08 COL 32.57 COLON-ALIGNED HELP
          "Descri‡Æo do Evento" NO-LABEL
     ttLubrif.cd-tipo AT ROW 7.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     fiDescManut AT ROW 7.08 COL 32.57 COLON-ALIGNED HELP
          "Descri‡Æo do Tipo de Manuten‡Æo" NO-LABEL
     ttLubrif.cod-cta-ctbl AT ROW 8.08 COL 18 COLON-ALIGNED WIDGET-ID 2
          LABEL "Conta Lubrifica‡Æo"
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ttLubrif.cod-ccusto AT ROW 8.08 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
          VIEW-AS FILL-IN 
          SIZE 20 BY .88
     ttLubrif.val-mater-1 AT ROW 9.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     ttLubrif.val-quant AT ROW 10.08 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.71
         SIZE 84.43 BY 10.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttApont T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: ttLubrif T "?" NO-UNDO movfro mab-item-lubrific
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
         HEIGHT             = 18
         WIDTH              = 90
         MAX-HEIGHT         = 20.67
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 20.67
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* SETTINGS FOR FILL-IN ttLubrif.cod-cta-ctbl IN FRAME fPage1
   EXP-LABEL                                                            */
/* SETTINGS FOR FILL-IN ttLubrif.cod-localiz IN FRAME fPage1
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN ttLubrif.lote IN FRAME fPage1
   EXP-FORMAT                                                           */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wWindow
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttLubrif.cd-tipo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubrif.cd-tipo wWindow
ON LEAVE OF ttLubrif.cd-tipo IN FRAME fPage1 /* Tipo Manuten‡Æo */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOManut"
        &KeyValue1="ttLubrif.cd-tipo:screen-value in frame fPage1"
        &FieldName1="descricao"
        &FieldScreen1="fiDescManut"
        &Frame1="fPage1"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubrif.cod-comptmento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubrif.cod-comptmento wWindow
ON LEAVE OF ttLubrif.cod-comptmento IN FRAME fPage1 /* Compartimento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOComp"
        &KeyValue1="ttLubrif.cod-comptmento:screen-value in frame fPage1"
        &FieldName1="des-comptmento"
        &FieldScreen1="fiDescComp"
        &Frame1="fPage1"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttApont.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-eqpto wWindow
ON LEAVE OF ttApont.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
    run buscaModelo in this-procedure.
    {method\referenceFields.i
        &HandleDBOLeave="hDBOModelo"
        &KeyValue1="cCodModelo"
        &FieldName1="des-model"
        &FieldScreen1="fiDescModelo"
        &Frame1="fPage0"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttLubrif.cod-evento
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubrif.cod-evento wWindow
ON LEAVE OF ttLubrif.cod-evento IN FRAME fPage1 /* Evento */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOEvento"
        &KeyValue1="ttLubrif.cod-evento:screen-value in frame fPage1"
        &FieldName1="des-evento"
        &FieldScreen1="fiDescEvento"
        &Frame1="fPage1"}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubrif.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubrif.cod-localiz wWindow
ON LEAVE OF ttLubrif.cod-localiz IN FRAME fPage1 /* Localiza‡Æo */
DO:
  /** Busca a descri‡Æo da localiza‡Æo **/
  assign fiDescLocal = "".
  for first localizacao fields(descricao)
      where localizacao.cod-localiz = input frame fPage1 ttLubrif.cod-localiz no-lock:
      assign fiDescLocal = localizacao.descricao.
  end.
  display fiDescLocal with frame fPage1.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttLubrif.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttLubrif.it-codigo wWindow
ON LEAVE OF ttLubrif.it-codigo IN FRAME fPage1 /* Item */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOItem"
        &KeyValue1="ttLubrif.it-codigo:screen-value in frame fPage1"
        &FieldName1="desc-item"
        &FieldScreen1="fiDescItem"
        &Frame1="fPage1"}
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
find first ttApont no-lock no-error.
find first ttLubrif WHERE ttLubrif.r-ROWID = rRowidSon2 no-lock no-error.
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finaliza‡Æo do programa
------------------------------------------------------------------------------*/
/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Compartimento **/
if valid-handle(hDBOComp) then
    run Destroy in hDBOComp.
/** Item **/
if valid-handle(hDBOItem) then
    run Destroy in hDBOItem.
/** Evento **/
if valid-handle(hDBOEvento) then
    run Destroy in hDBOEvento.
/** Tipo Manuten‡Æo  **/
if valid-handle(hDBOManut) then
    run Destroy in hDBOManut.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override Ap¢s inicializa‡Æo de tela 
------------------------------------------------------------------------------*/
/** Mostra Campos em tela **/
display ttApont.cod-eqpto 
        ttApont.dat-movto 
        ttApont.ep-codigo 
        ttApont.hra-final 
        ttApont.hra-inicial 
        ttApont.num-docto
    with frame fPage0.

display ttLubrif.cd-tipo 
        ttLubrif.cod-comptmento 
        ttLubrif.cod-evento 
        ttLubrif.cod-localiz 
        ttLubrif.cod-refer 
        ttLubrif.it-codigo 
        ttLubrif.lote 
        ttLubrif.val-mater-1 
        ttLubrif.val-quant
        ttLubrif.cod-cta-ctbl
        ttLubrif.cod-ccusto
    with frame fPage1.

/** Mostra C¢digo Dep¢sito em tela **/
run buscaDeposito in this-procedure.

/** Descri‡äes dos campos **/
apply "LEAVE":U to ttApont.cod-eqpto     in frame fPage0.
apply "LEAVE":U to ttLubrif.it-codigo      in frame fPage1.
apply "LEAVE":U to ttLubrif.cod-evento     in frame fPage1.
apply "LEAVE":U to ttLubrif.cd-tipo        in frame fPage1.
apply "LEAVE":U to ttLubrif.cod-comptmento in frame fPage1.
apply "LEAVE":U to ttLubrif.cod-localiz    in frame fPage1.
apply "LEAVE":U to ttLubrif.cod-cta-ctbl   in frame fPage1.
apply "LEAVE":U to ttLubrif.cod-ccusto     in frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializa‡Æo de tela
------------------------------------------------------------------------------*/
/** Inicializa‡Æo das DBOs **/
run initializeDBOs in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaDeposito wWindow 
PROCEDURE buscaDeposito :
/*------------------------------------------------------------------------------
  Purpose:     buscaDeposito
  Parameters:  <none>
  Notes:       Busca o C¢digo do dep¢sito pelo posto do apontamento.
------------------------------------------------------------------------------*/
{method\referenceFields.i
    &HandleDBOLeave="hDBOPosto"
    &KeyValue1="ttApont.cod-posto"
    &FieldName1="cod-depos"
    &FieldScreen1="fiDeposito"
    &Frame1="fPage1"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wWindow 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

{method\referenceFields.i
    &HandleDBOLeave="hDBOEqpto"
    &KeyValue1="input frame fPage0 ttApont.ep-codigo"
    &KeyValue2="input frame fPage0 ttApont.cod-eqpto"
    &FieldName1="cod-model"
    &Variable1="cCodModelo"}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wWindow 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa as BOs
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo~\bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo~\bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Compartimento ---*/
    IF NOT VALID-HANDLE(hDBOComp) OR
       hDBOComp:TYPE <> "PROCEDURE":U OR
       hDBOComp:FILE-NAME <> "frbo~\bofr003.p":U THEN DO:
        run frbo/bofr003.p persistent set  hDBOComp.
    END.
    
    RUN openQueryStatic IN hDBOComp (INPUT "Main":U) NO-ERROR.

    /*--- DBO Item ---*/
    IF NOT VALID-HANDLE(hDBOItem) OR
       hDBOItem:TYPE <> "PROCEDURE":U OR
       hDBOItem:FILE-NAME <> "inbo~\boin172.p":U THEN DO:
        run inbo/boin172.p persistent set  hDBOItem.
    END.
    
    RUN openQueryStatic IN hDBOItem (INPUT "Main":U) NO-ERROR.

    /*--- DBO Evento ---*/
    IF NOT VALID-HANDLE(hDBOEvento) OR
       hDBOEvento:TYPE <> "PROCEDURE":U OR
       hDBOEvento:FILE-NAME <> "frbo~\bofr010.p":U THEN DO:
        run frbo/bofr010.p persistent set  hDBOEvento.
    END.
    
    RUN openQueryStatic IN hDBOEvento (INPUT "Main":U) NO-ERROR.

    /*--- DBO Tipo Manuten‡Æo ---*/
    IF NOT VALID-HANDLE(hDBOManut) OR
       hDBOManut:TYPE <> "PROCEDURE":U OR
       hDBOManut:FILE-NAME <> "mnbo~\bomn158.p":U THEN DO:
        run mnbo/bomn158.p persistent set  hDBOManut.
    END.
    
    RUN openQueryStatic IN hDBOManut (INPUT "Default":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo~\bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

