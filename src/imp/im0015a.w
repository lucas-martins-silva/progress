&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcex            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-cot-ordem NO-UNDO LIKE mgcex.cot-ordem
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
{include/i-prgvrs.i IM0015A 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0015A MIM}
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

{cdp/cdcfgmat.i} /* Defini‡Æo de pr‚-processadores */

&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Program           IM0015A
&GLOBAL-DEFINE Version           2.00.00.009
&GLOBAL-DEFINE DBOVersion        1.1

&GLOBAL-DEFINE ttTable           tt-cot-ordem
&GLOBAL-DEFINE hDBOTable         h-bocx300
&GLOBAL-DEFINE DBOTable          cot-ordem

&GLOBAL-DEFINE page0KeyFields    tt-cot-ordem.cod-agrup ~
                                 tt-cot-ordem.numero-ordem ~
                                 tt-cot-ordem.cod-emitente ~
                                 tt-cot-ordem.data-1 ~
                                 &if defined(bf-mat-comex) &then ~
                                 &else ~
                                     tt-cot-ordem.seq-cotac ~
                                 &endif ~
                                 tt-cot-ordem.mapa-ordem
&GLOBAL-DEFINE page0Fields       tt-cot-ordem.cod-itiner

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
def var h-boad098 as handle no-undo.
def var h-boin274 as handle no-undo.
def var h-boin082 as handle no-undo.
DEFINE VARIABLE wh-pesquisa AS HANDLE NO-UNDO.
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
def var h-seq-cotac  as handle no-undo.
def var h-data       as handle no-undo.
def var c-return     as char   no-undo.
def var c-item       as char   no-undo.
def var c-unidade    as char   no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tt-cot-ordem.cod-agrup ~
tt-cot-ordem.cod-itiner tt-cot-ordem.mapa-ordem tt-cot-ordem.numero-ordem ~
tt-cot-ordem.cod-emitente tt-cot-ordem.data-1 tt-cot-ordem.seq-cotac 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-agrup ~{&FP2}cod-agrup ~{&FP3}~
 ~{&FP1}cod-itiner ~{&FP2}cod-itiner ~{&FP3}~
 ~{&FP1}mapa-ordem ~{&FP2}mapa-ordem ~{&FP3}~
 ~{&FP1}numero-ordem ~{&FP2}numero-ordem ~{&FP3}~
 ~{&FP1}cod-emitente ~{&FP2}cod-emitente ~{&FP3}~
 ~{&FP1}data-1 ~{&FP2}data-1 ~{&FP3}~
 ~{&FP1}seq-cotac ~{&FP2}seq-cotac ~{&FP3}
&Scoped-define ENABLED-TABLES tt-cot-ordem
&Scoped-define FIRST-ENABLED-TABLE tt-cot-ordem
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys c-unid btOK btSave btCancel ~
btHelp 
&Scoped-Define DISPLAYED-FIELDS tt-cot-ordem.cod-agrup ~
tt-cot-ordem.cod-itiner tt-cot-ordem.mapa-ordem tt-cot-ordem.numero-ordem ~
tt-cot-ordem.cod-emitente tt-cot-ordem.data-1 tt-cot-ordem.seq-cotac 
&Scoped-Define DISPLAYED-OBJECTS c-desc-itinerario c-desc-emitente c-unid 

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

DEFINE VARIABLE c-desc-emitente AS CHARACTER FORMAT "X(10)" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-itinerario AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid AS CHARACTER FORMAT "X(8)":U 
     LABEL "un" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .79 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 8.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-cot-ordem.cod-agrup AT ROW 1.17 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     tt-cot-ordem.cod-itiner AT ROW 2.17 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-desc-itinerario AT ROW 2.17 COL 45.29 COLON-ALIGNED NO-LABEL
     tt-cot-ordem.mapa-ordem AT ROW 3.17 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     tt-cot-ordem.numero-ordem AT ROW 4.17 COL 39 COLON-ALIGNED FORMAT "zzzzz9,99"
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     tt-cot-ordem.cod-emitente AT ROW 5.17 COL 39 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     c-desc-emitente AT ROW 5.17 COL 48.57 COLON-ALIGNED NO-LABEL
     tt-cot-ordem.data-1 AT ROW 6.17 COL 39.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.57 BY .88
     tt-cot-ordem.seq-cotac AT ROW 7.17 COL 39.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     c-unid AT ROW 8.17 COL 39.14 COLON-ALIGNED
     btOK AT ROW 9.54 COL 2
     btSave AT ROW 9.54 COL 13
     btCancel AT ROW 9.54 COL 24
     btHelp AT ROW 9.54 COL 80
     rtToolBar AT ROW 9.33 COL 1
     rtKeys AT ROW 1.04 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 9.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-cot-ordem T "?" NO-UNDO mgcex cot-ordem
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
         HEIGHT             = 9.79
         WIDTH              = 90
         MAX-HEIGHT         = 16.33
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 16.33
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN c-desc-emitente IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-itinerario IN FRAME fpage0
   NO-ENABLE                                                            */
ASSIGN 
       tt-cot-ordem.data-1:HIDDEN IN FRAME fpage0           = TRUE.

/* SETTINGS FOR FILL-IN tt-cot-ordem.numero-ordem IN FRAME fpage0
   EXP-FORMAT                                                           */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
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
    
    run SetaAcaoPrograma in h-bocx300 (input pcAction).
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


&Scoped-define SELF-NAME tt-cot-ordem.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.cod-emitente wMaintenanceNoNavigation
ON LEAVE OF tt-cot-ordem.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
    def var c-nome-abrev like emitente.nome-abrev no-undo.
    def var h-boad098 as handle no-undo.
    
    assign input frame {&frame-name} tt-cot-ordem.cod-emitente.
    run adbo/boad098.p persistent set h-boad098.        
    run findCodigo in h-boad098(input tt-cot-ordem.cod-emitente, output c-return).
    if c-return = "" then do:
        run getCharfield in h-boad098(input "nome-abrev", output c-nome-abrev).
        assign c-desc-emitente:screen-value = c-nome-abrev.
    end.
    delete procedure h-boad098.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.cod-emitente wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-cot-ordem.cod-emitente IN FRAME fpage0 /* Fornecedor */
DO:
  {method/ZoomFields.i 
     &ProgramZoom="adzoom/z10ad098.w"
     &FieldZoom1="cod-emitente"
     &FieldScreen1="tt-cot-ordem.cod-emitente"
     &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cot-ordem.cod-itiner
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.cod-itiner wMaintenanceNoNavigation
ON LEAVE OF tt-cot-ordem.cod-itiner IN FRAME fpage0 /* C¢digo Itiner rio */
DO:
    def var c-descricao like itinerario.descricao no-undo.
    def var h-bocx115 as handle no-undo.
    
    assign input frame {&frame-name} tt-cot-ordem.cod-itiner.
    run cxbo/bocx115.p persistent set h-bocx115.        
    run findCodigo in h-bocx115(input tt-cot-ordem.cod-itiner, output c-return).
    if c-return = "" then do:
        run getCharfield in h-bocx115(input "descricao", output c-descricao).
        assign c-desc-itinerario:screen-value = c-descricao.
    end.        
    delete procedure h-bocx115.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.cod-itiner wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-cot-ordem.cod-itiner IN FRAME fpage0 /* C¢digo Itiner rio */
DO:
    {method/ZoomFields.i 
     &ProgramZoom="cxzoom/z10cx115.w"
     &FieldZoom1="cod-itiner"
     &FieldScreen1="tt-cot-ordem.cod-itiner"
     &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cot-ordem.data-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.data-1 wMaintenanceNoNavigation
ON LEAVE OF tt-cot-ordem.data-1 IN FRAME fpage0 /* data-1 */
DO:
    def var c-it-codigo like item.it-codigo no-undo.
    
    run findOrdem in h-boin274 (input tt-cot-ordem.numero-ordem,
                                output c-return).
    if c-return = "" then
        run getCharfield in h-boin274 (input "it-codigo":U,output c-it-codigo).                                         
    
    &if defined(bf-mat-comex) &then
        assign input frame {&frame-name} tt-cot-ordem.numero-ordem
                                         tt-cot-ordem.cod-emitente                                         
                                         tt-cot-ordem.data-1.
        run findCotacao in h-boin082 (input tt-cot-ordem.numero-ordem,
                                      input tt-cot-ordem.cod-emitente,
                                      input c-it-codigo,
                                      input tt-cot-ordem.data-1,
                                      output c-return).
    &else                                      
        assign input frame {&frame-name} tt-cot-ordem.numero-ordem
                                         tt-cot-ordem.cod-emitente
                                         tt-cot-ordem.seq-cotac.
        run findCotacao in h-boin082 (input tt-cot-ordem.numero-ordem,
                                      input tt-cot-ordem.cod-emitente,
                                      input c-it-codigo,
                                      input tt-cot-ordem.seq-cotac,
                                      output c-return).
    &endif
                                  
    if c-return = "" then
        run getCharfield in h-boin082 (input "un":U,output c-unid).
        
    disp c-unid with frame {&frame-name}.      
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cot-ordem.numero-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.numero-ordem wMaintenanceNoNavigation
ON LEAVE OF tt-cot-ordem.numero-ordem IN FRAME fpage0 /* Ordem Compra */
DO:
/*    RUN findOrdem in h-boin274 (input tt-cot-ordem.numero-ordem:screen-value, output c-return).
 *     if c-return = "" then  
 *         RUN getCharField in h-boin274 (input "it-codigo", output c-item).
 * 
 *     run findCotacao in h-boin082(input tt-cot-ordem.numero-ordem:screen-value,
 *                                  input tt-cot-ordem.cod-emitente:screen-value,
 *                                  input c-item,
 *                                  &if defined(bf-mat-comex) &then
 *                                     input tt-cot-ordem.data-1:screen-value,
 *                                  &else
 *                                     input tt-cot-ordem.seq-cotac:screen-value,
 *                                  &endif
 *                                  output c-return).
 *                                    
 *        
 *     run getcharfield in h-boin082(input "un", output c-unidade).
 *     assign c-unid:screen-value in frame fpage0 = c-unidade. message*/

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.numero-ordem wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF tt-cot-ordem.numero-ordem IN FRAME fpage0 /* Ordem Compra */
DO:
    &if defined(bf-mat-comex) &then
         
        {method/ZoomFields.i 
         &ProgramZoom="inzoom/z10in082.w"
         &FieldZoom1="numero-ordem"
         &FieldScreen1="tt-cot-ordem.numero-ordem"
         &Frame1="fPage0"
         &FieldZoom2="cod-emitente"
         &FieldScreen2="tt-cot-ordem.cod-emitente"
         &Frame2="fPage0"
         &FieldZoom3="data-cotacao"
         &FieldScreen3="tt-cot-ordem.data-1"
         &Frame3="fPage0"
         &EnableImplant="no"}
         
    &else
        {method/ZoomFields.i 
         &ProgramZoom="inzoom/z10in082.w"
         &FieldZoom1="numero-ordem"
         &FieldScreen1="tt-cot-ordem.numero-ordem"
         &Frame1="fPage0"
         &FieldZoom2="cod-emitente"
         &FieldScreen2="tt-cot-ordem.cod-emitente"
         &Frame2="fPage0"
         &FieldZoom3="data-cotacao"
         &FieldScreen3="tt-cot-ordem.data-1"
         &Frame3="fPage0"
         &FieldZoom4="seq-cotac"
         &FieldScreen4="tt-cot-ordem.seq-cotac"
         &Frame4="fPage0"
         &FieldZoom5="un"
         &FieldScreen5="c-unid"
         &Frame5="fPage0"
         &EnableImplant="no"}
    
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-cot-ordem.seq-cotac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-cot-ordem.seq-cotac wMaintenanceNoNavigation
ON LEAVE OF tt-cot-ordem.seq-cotac IN FRAME fpage0 /* Seq Cota‡Æo */
DO:
    def var c-it-codigo like item.it-codigo no-undo.
    
    run findOrdem in h-boin274 (input tt-cot-ordem.numero-ordem,
                                output c-return).
    if c-return = "" then
        run getCharfield in h-boin274 (input "it-codigo":U,output c-it-codigo).                                         
    
    &if defined(bf-mat-comex) &then
        assign input frame {&frame-name} tt-cot-ordem.numero-ordem
                                         tt-cot-ordem.cod-emitente                                         
                                         tt-cot-ordem.data-1.
        run findCotacao in h-boin082 (input tt-cot-ordem.numero-ordem,
                                      input tt-cot-ordem.cod-emitente,
                                      input c-it-codigo,
                                      input tt-cot-ordem.data-1,
                                      output c-return).
    &else                                      
        assign input frame {&frame-name} tt-cot-ordem.numero-ordem
                                         tt-cot-ordem.cod-emitente
                                         tt-cot-ordem.seq-cotac.
        run findCotacao in h-boin082 (input tt-cot-ordem.numero-ordem,
                                      input tt-cot-ordem.cod-emitente,
                                      input c-it-codigo,
                                      input tt-cot-ordem.seq-cotac,
                                      output c-return).
    &endif
                                  
    if c-return = "" then
        run getCharfield in h-boin082 (input "un":U,output c-unid).
        
    disp c-unid with frame {&frame-name}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
    tt-cot-ordem.numero-ordem:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    tt-cot-ordem.cod-emitente:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    tt-cot-ordem.cod-itiner:LOAD-MOUSE-POINTER("image/lupa.cur":U) 
    IN FRAME fPage0.
    
  {utp/ut-field.i movind cotacao-item un 2}
  assign c-unid:label in frame {&frame-name} = return-value.

{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyinterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    delete procedure h-boad098.
    delete procedure h-boin274.
    delete procedure h-boin082.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeinterface wMaintenanceNoNavigation 
PROCEDURE afterinitializeinterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    assign h-seq-cotac  = tt-cot-ordem.seq-cotac:side-label-handle in frame fPage0
           h-data       = tt-cot-ordem.data-1:side-label-handle    in frame fPage0.
       
    {utp/ut-field.i mgcex cotacao-item-cex data-cotacao 1}
    assign tt-cot-ordem.data-1:label in frame fPage0 = return-value.

    &if defined(bf-mat-comex) &then
        assign tt-cot-ordem.seq-cotac:hidden in frame fPage0 = yes
               h-seq-cotac:hidden                            = yes.
    &else
        assign tt-cot-ordem.seq-cotac:hidden in frame fPage0 = no
               h-seq-cotac:hidden                            = no.
    &endif
    
    RETURN "OK":U.
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
        RUN cxbo/bocx300.p persistent set h-bocx300.
    END.
    
    
    RUN adbo/boad098.p persistent set h-boad098.
    RUN inbo/boin082.p persistent set h-boin082.
    RUN inbo/boin274.p persistent set h-boin274.
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
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


