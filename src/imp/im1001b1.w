&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-item-doc-est NO-UNDO LIKE item-doc-est
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-item-doc-est-cex NO-UNDO LIKE item-doc-est-cex
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
{include/i-prgvrs.i IM1001B1 2.00.00.002 } /*** 010002 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM1001B1 MIM}
&ENDIF


CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           IM1001B1
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           tt-item-doc-est-cex
&GLOBAL-DEFINE hDBOTable         h-bocx100
&GLOBAL-DEFINE DBOTable          item-doc-est-cex

&GLOBAL-DEFINE ttParent          tt-item-doc-est
&GLOBAL-DEFINE DBOParentTable    item-doc-est


&GLOBAL-DEFINE page0KeyFields    tt-item-doc-est-cex.cod-emitente-desp ~
                                 tt-item-doc-est-cex.cod-desp
                                 
&GLOBAL-DEFINE page0Fields       tt-item-doc-est-cex.val-desp
                                 
&GLOBAL-DEFINE page0ParentFields 

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER prParent        AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.
DEFINE INPUT PARAMETER piSonPageNumber AS INTEGER   NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.

{include/boini.i}

def var rw-item-doc-est-cex            as rowid   no-undo.
def var r-chave                        as rowid   no-undo.
def var h-boin176                      as handle  no-undo.
def var h-bocx310                      as handle  no-undo.
def var h-bocx095                      as handle  no-undo.

/*--- Vari†veis definidas para que se possa utilizar o zoom 
      feito em Smart Objects ---*/
      
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa                      AS HANDLE NO-UNDO.
/*-----------------------------------------------------------------*/
def var i-cod-emitente  like item-doc-est.cod-emitente no-undo.
def var c-serie-docto   like item-doc-est.serie-docto  no-undo.
def var c-nro-docto     like item-doc-est.nro-docto    no-undo.
def var c-nat-operacao  like item-doc-est.nat-operacao no-undo.
def var i-sequencia     like item-doc-est.sequencia    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-item-doc-est-cex.cod-emitente-desp ~
tt-item-doc-est-cex.cod-desp tt-item-doc-est-cex.val-desp 
&Scoped-define ENABLED-TABLES tt-item-doc-est-cex
&Scoped-define FIRST-ENABLED-TABLE tt-item-doc-est-cex
&Scoped-Define ENABLED-OBJECTS RECT-11 rtToolBar btOK btCancel btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-item-doc-est-cex.cod-emitente-desp ~
tt-item-doc-est-cex.cod-desp tt-item-doc-est-cex.val-desp 
&Scoped-define DISPLAYED-TABLES tt-item-doc-est-cex
&Scoped-define FIRST-DISPLAYED-TABLE tt-item-doc-est-cex
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
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE c-despesa AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.42.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-item-doc-est-cex.cod-emitente-desp AT ROW 1.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.57 BY .88
     c-nome-abrev AT ROW 1.25 COL 29.86 COLON-ALIGNED NO-LABEL
     tt-item-doc-est-cex.cod-desp AT ROW 2.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-despesa AT ROW 2.25 COL 27.57 COLON-ALIGNED NO-LABEL
     tt-item-doc-est-cex.val-desp AT ROW 3.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.72 BY .88
     btOK AT ROW 4.96 COL 2
     btSave AT ROW 4.96 COL 13
     btCancel AT ROW 4.96 COL 24
     btHelp AT ROW 4.96 COL 79
     RECT-11 AT ROW 1.08 COL 1
     rtToolBar AT ROW 4.71 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.57 BY 5.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-item-doc-est T "?" NO-UNDO movind item-doc-est
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-item-doc-est-cex T "?" NO-UNDO mgcex item-doc-est-cex
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
         HEIGHT             = 5.25
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
/* SETTINGS FOR BUTTON btSave IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       btSave:HIDDEN IN FRAME fpage0           = TRUE.

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

    run repositionItemDocEst in phCaller.
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
  
    /* Assign dos Campos que est∆o a n°vel de vari†veis */
    
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        APPLY "CLOSE":U TO THIS-PROCEDURE.

    END.        
      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:


    /* Assign dos Campos que est∆o a n°vel de vari†veis */
    
    RUN saveRecord IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-doc-est-cex.cod-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-doc-est-cex.cod-desp wMaintenanceNoNavigation
ON F5 OF tt-item-doc-est-cex.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
        {method/zoomfields.i &programzoom="cxzoom/z10cx095.w"
                             &fieldZoom1="cod-desp"
                             &FieldScreen1="tt-item-doc-est-cex.cod-desp"
                             &frame1="fPage0"
                             &fieldZoom2="descricao"
                             &FieldScreen2="c-despesa"                             
                             &frame2="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-doc-est-cex.cod-desp wMaintenanceNoNavigation
ON LEAVE OF tt-item-doc-est-cex.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
  run displayDespesa ( input tt-item-doc-est-cex.cod-estabel,
                       input tt-item-doc-est-cex.embarque,
                       INPUT INPUT FRAME fpage0 tt-item-doc-est-cex.cod-desp).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-doc-est-cex.cod-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-item-doc-est-cex.cod-desp IN FRAME fpage0 /* C¢digo Despesa */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-item-doc-est-cex.cod-emitente-desp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-doc-est-cex.cod-emitente-desp wMaintenanceNoNavigation
ON F5 OF tt-item-doc-est-cex.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
      {include/zoomvar.i &prog-zoom=adzoom/z07ad098.w
                         &campo=tt-item-doc-est-cex.cod-emitente-desp
                         &campozoom=cod-emitente
                         &campo2=c-nome-abrev
                         &campozoom2=nome-abrev
                         &frame="fPage0"}
                       
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-doc-est-cex.cod-emitente-desp wMaintenanceNoNavigation
ON LEAVE OF tt-item-doc-est-cex.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
  run displayEmitente  ( input frame fpage0 tt-item-doc-est-cex.cod-emitente-desp).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-item-doc-est-cex.cod-emitente-desp wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-item-doc-est-cex.cod-emitente-desp IN FRAME fpage0 /* Fornec Despesa */
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializaá∆o do programa ---*/
{maintenancenonavigation/MainBlock.i}

tt-item-doc-est-cex.cod-emitente-desp:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
tt-item-doc-est-cex.cod-desp:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.

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
                  
    RETURN "OK":U.
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
    def var c-desc-aux  as char no-undo.

    /* Mostra Descriá∆o do Estabelecimento */
    
    assign c-nome-abrev:screen-value in frame fpage0 = ""
           c-despesa:screen-value in frame fpage0 = "".
           
    if  pcAction = "UPDATE":U then do:
    
        /* Mostra Informaá‰es do Emitente */
        run displayEmitente  ( tt-item-doc-est-cex.cod-emitente-desp).

        run displayDespesa ( input tt-item-doc-est-cex.cod-estabel,
                             input tt-item-doc-est-cex.embarque,
                             INPUT tt-item-doc-est-cex.cod-desp).
    end.        
     
    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayDespesa wMaintenanceNoNavigation 
PROCEDURE displayDespesa :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param pcCodEst   like item-doc-est-cex.cod-estabel    no-undo.
    def input param pcCodEmb   like item-doc-est-cex.embarque       no-undo.
    def input param piCodDesp  like item-doc-est-cex.cod-desp       no-undo.
    
    def var c-return  as char   no-undo. 
    def var c-descricao like desp-imp.descricao init "" no-undo.

    RUN findDespesa IN h-bocx310 (INPUT pcCodEst,
                                  INPUT pcCodEmb,
                                  INPUT piCodDesp,
                                  OUTPUT c-return).
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

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayEmitente wMaintenanceNoNavigation 
PROCEDURE displayEmitente :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param piCodEmitente   like item-doc-est-cex.cod-emitente-desp no-undo.
    
    def var c-return                as char          no-undo.
    def var h-boad098               as handle        no-undo.
    def var c-desc-aux              as char init ""  no-undo.
    
    run adbo/boad098.p persistent set h-boad098.
    
    run findCodigo in h-boad098(input picodemitente,output c-return).
    
    if c-return = "" then
        run getCharfield in h-boad098(input "nome-abrev",output c-desc-aux).  
        
    assign c-nome-abrev:screen-value in frame fPage0 = c-desc-aux.
    delete procedure h-boad098.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   /*--- Verifica se o DBO j† est† inicializado ---*/
    
    IF NOT VALID-HANDLE({&hDBOTable}) THEN DO:
        {btb/btb008za.i1 inbo/bocx100.p}
        {btb/btb008za.i2 inbo/bocx100.p '' {&hDBOTable}}            
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
  Notes:       Este mÇtodo somente Ç executado quando a vari†vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
 

    assign tt-item-doc-est-cex.cod-emitente      = tt-item-doc-est.cod-emitente
           tt-item-doc-est-cex.serie-docto       = tt-item-doc-est.serie-docto
           tt-item-doc-est-cex.nro-docto         = tt-item-doc-est.nro-docto
           tt-item-doc-est-cex.nat-operacao      = tt-item-doc-est.nat-operacao
           tt-item-doc-est-cex.sequencia         = tt-item-doc-est.sequencia.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

