&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-docum-est NO-UNDO LIKE docum-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-docum-est-cex NO-UNDO LIKE docum-est-cex
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM1001C 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM1001C MIM}
&ENDIF


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM1001C
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder            no
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-docum-est-cex
&GLOBAL-DEFINE hDBOTable         h-bocx090
&GLOBAL-DEFINE DBOTable          docum-est-cex

&GLOBAL-DEFINE ttParent          tt-docum-est
&GLOBAL-DEFINE DBOParentTable    docum-est

&GLOBAL-DEFINE page0KeyFields    tt-docum-est-cex.cod-emitente-desp ~
                                 tt-docum-est-cex.cod-desp

&GLOBAL-DEFINE page0Fields       tt-docum-est-cex.val-desp  
 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE h-bocx095 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-bocx310 AS HANDLE      NO-UNDO.

/*--- Vari veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-docum-est-cex.cod-emitente-desp ~
tt-docum-est-cex.cod-desp tt-docum-est-cex.val-desp 
&Scoped-define ENABLED-TABLES tt-docum-est-cex
&Scoped-define FIRST-ENABLED-TABLE tt-docum-est-cex
&Scoped-Define ENABLED-OBJECTS RECT-23 rtToolBar btOK btSave btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-docum-est-cex.cod-emitente-desp ~
tt-docum-est-cex.cod-desp tt-docum-est-cex.val-desp 
&Scoped-define DISPLAYED-TABLES tt-docum-est-cex
&Scoped-define FIRST-DISPLAYED-TABLE tt-docum-est-cex
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev c-despesa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.29 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 89.14 BY 3.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 89.57 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-docum-est-cex.cod-emitente-desp AT ROW 1.54 COL 25.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     c-nome-abrev AT ROW 1.54 COL 33.14 COLON-ALIGNED NO-LABEL
     tt-docum-est-cex.cod-desp AT ROW 2.54 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-despesa AT ROW 2.54 COL 31.43 COLON-ALIGNED NO-LABEL
     tt-docum-est-cex.val-desp AT ROW 3.54 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.72 BY .88
     btOK AT ROW 5.29 COL 2
     btSave AT ROW 5.29 COL 13
     btCancel AT ROW 5.29 COL 24
     btHelp AT ROW 5.29 COL 80
     RECT-23 AT ROW 1.17 COL 1.29
     rtToolBar AT ROW 5.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 5.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-docum-est T "?" NO-UNDO movind docum-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-docum-est-cex T "?" NO-UNDO mgcex docum-est-cex
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 5.58
         WIDTH              = 90
         MAX-HEIGHT         = 22
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 22
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
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-despesa IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN saveRecord IN THIS-PROCEDURE.    
    IF RETURN-VALUE = "OK":U THEN
         APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-docum-est-cex.cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est-cex.cod-desp wMaintenanceNoNavigation
ON F5 OF tt-docum-est-cex.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
        {method/zoomfields.i &programzoom="cxzoom/z10cx095.w"
                             &fieldZoom1="cod-desp"
                             &FieldScreen1="tt-docum-est-cex.cod-desp"
                             &frame1="fPage0"
                             &fieldZoom2="descricao"
                             &FieldScreen2="c-despesa"                             
                             &frame2="fPage0"}
                             
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est-cex.cod-desp wMaintenanceNoNavigation
ON LEAVE OF tt-docum-est-cex.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
  run displayDespesa ( input frame fpage0 tt-docum-est-cex.cod-desp).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est-cex.cod-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-docum-est-cex.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-docum-est-cex.cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est-cex.cod-emitente-desp wMaintenanceNoNavigation
ON F5 OF tt-docum-est-cex.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
    {include/zoomvar.i &prog-zoom=adzoom/z07ad098.w
                       &campo=tt-docum-est-cex.cod-emitente-desp
                       &campozoom=cod-emitente
                       &campo2=c-nome-abrev
                       &campozoom2=nome-abrev
                       &frame="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est-cex.cod-emitente-desp wMaintenanceNoNavigation
ON LEAVE OF tt-docum-est-cex.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
   run displayEmitente  ( input frame fpage0 tt-docum-est-cex.cod-emitente-desp).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-docum-est-cex.cod-emitente-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-docum-est-cex.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

tt-docum-est-cex.cod-emitente-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.
tt-docum-est-cex.cod-desp:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE(h-bocx310) THEN DO:
        DELETE PROCEDURE h-bocx310.
        ASSIGN h-bocx310 = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Mostra Descri‡Æo do Estabelecimento */
             
    assign c-despesa:screen-value in frame fPage0 = ""
           c-nome-abrev:screen-value in frame fPage0 = "".           

    if  pcAction = "UPDATE":U then do:
    
        /* Mostra Informa‡äes do Emitente */
        run displayEmitente  ( tt-docum-est-cex.cod-emitente-desp).
                
        /* Mostra Descri‡Æo da Natureza */
        run displayDespesa ( tt-docum-est-cex.cod-desp).
        
    end.        
     
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displaydespesa wMaintenanceNoNavigation 
PROCEDURE displaydespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param piCodDesp  like docum-est-cex.cod-desp no-undo.
    
    def var c-return  as char   no-undo. 
    def var c-descricao like desp-imp.descricao no-undo.

    IF AVAIL tt-docum-est THEN DO:
        RUN findDespesa IN h-bocx310 (INPUT tt-docum-est.cod-estabel,
                                      INPUT tt-docum-est.embarque,
                                      INPUT piCodDesp,
                                      OUTPUT c-return).
    END.

    IF c-return = "":U THEN DO:
        RUN getCharField IN h-bocx310(INPUT "descricao":U,
                                      OUTPUT c-descricao).
    END.
        
    IF TRIM(c-descricao) = "":U THEN DO:
        run cxbo/bocx095.p persistent set h-bocx095.
        
        run findCodigo in h-bocx095(input piCodDesp,output c-return).
        
        if c-return = "" then
            run getCharfield in h-bocx095(input "descricao",output c-descricao).
        delete procedure h-bocx095.
    END.

    assign c-despesa:screen-value in frame fPage0 = c-descricao.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayemitente wMaintenanceNoNavigation 
PROCEDURE displayemitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like docum-est-cex.cod-emitente-desp no-undo.
    
    def var c-return                as char   no-undo.
    def var h-boad098               as handle no-undo.
    def var c-desc-aux              as char   no-undo.
    
    run adbo/boad098.p persistent set h-boad098.
    
    run findCodigo in h-boad098(input picodemitente,output c-return).
    
    if c-return = "" then
        run getCharfield in h-boad098(input "nome-abrev",output c-desc-aux).  
        
    assign c-nome-abrev:screen-value in frame fPage0 = c-desc-aux.
    delete procedure h-boad098.
    
        return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 cxbo/bocx090.p}
        {btb/btb008za.i2 cxbo/bocx090.p '' {&hDBOTable}}            
    END.

    IF NOT VALID-HANDLE(h-bocx310) THEN
        RUN cxbo/bocx310.p PERSISTENT SET h-bocx310.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
    assign tt-docum-est-cex.cod-emitente = tt-docum-est.cod-emitente
           tt-docum-est-cex.serie-docto  = tt-docum-est.serie-docto
           tt-docum-est-cex.nro-docto    = tt-docum-est.nro-docto
           tt-docum-est-cex.nat-operacao = tt-docum-est.nat-operacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

