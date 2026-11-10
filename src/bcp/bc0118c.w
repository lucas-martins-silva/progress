&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0118C 2.00.00.010 } /*** "010010" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0118c MBC}
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
&GLOBAL-DEFINE Program        BC0118C
&GLOBAL-DEFINE Version        2.00.00.010

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Local Default

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 br-tt-bc-etiqueta-det
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

DEF TEMP-TABLE tt-bc-etiqueta   NO-UNDO LIKE bc-etiqueta
    FIELD estado-des AS CHARACTER FORMAT 'x(30)':U LABEL 'Descriá∆o':U
    FIELD item-des   AS CHARACTER FORMAT 'x(60)':U LABEL 'Descriá∆o':U.

DEF TEMP-TABLE tt-estrutura NO-UNDO /* obtido atraves do bc0201 */
    FIELD sequencia  AS INTEGER   FORMAT '>>>>9':U LABEL 'Sequància'
    FIELD titulo     AS CHARACTER FORMAT 'x(50)':U LABEL 'T°tulo'
    FIELD titulo-col AS CHARACTER FORMAT 'x(50)':U LABEL 'T°tulo Coluna'
    FIELD atributo   AS CHARACTER FORMAT 'x(100)':U LABEL 'Atributo'
    FIELD formato    AS CHARACTER FORMAT 'x(30)':U LABEL 'Formato'
    FIELD tipo-dado  AS CHARACTER FORMAT 'x(30)':U LABEL 'Tipo Dado'
    FIELD per-alt    AS LOGICAL FORMAT 'Sim/N∆o':U LABEL 'Altera?'
    FIELD inicial    AS CHARACTER FORMAT 'x(100)':U LABEL 'Valor Inicial'
    FIELD final      AS CHARACTER FORMAT 'x(100)':U LABEL 'Valor Final'
    FIELD conteudo   AS CHARACTER FORMAT 'x(100)':U LABEL 'Conte£do'
    FIELD faixa      AS LOG 
    .

{bcp/bcproxy.i2}    /* DefiniáÑes das procedures para integraá∆o com o Magnus i.00 */
{cdp/cdcfgint.i} /* versao de produto */

DEF BUFFER b-tt-bc-etiqueta FOR tt-bc-etiqueta.
/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER p-modifica AS LOGICAL.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-estrutura.
DEFINE INPUT        PARAMETER p-chave  AS CHARACTER.

DEFINE VARIABLE c-contrl AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-query AS WIDGET-HANDLE.
DEFINE VARIABLE h-buffer AS WIDGET-HANDLE.
DEFINE VARIABLE v-cont-registro AS INTEGER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-bc-etiqueta-det

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estrutura

/* Definitions for BROWSE br-tt-bc-etiqueta-det                         */
&Scoped-define FIELDS-IN-QUERY-br-tt-bc-etiqueta-det tt-estrutura.titulo-col tt-estrutura.conteudo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-bc-etiqueta-det   
&Scoped-define SELF-NAME br-tt-bc-etiqueta-det
&Scoped-define OPEN-QUERY-br-tt-bc-etiqueta-det OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura NO-LOCK BY tt-estrutura.sequencia INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tt-bc-etiqueta-det tt-estrutura
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-bc-etiqueta-det tt-estrutura


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-tt-bc-etiqueta-det}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp2 rtToolBar 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY br-tt-bc-etiqueta-det FOR
                tt-estrutura SCROLLING.

&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-bc-etiqueta-det
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-bc-etiqueta-det wWindow _FREEFORM
  QUERY br-tt-bc-etiqueta-det NO-LOCK DISPLAY
      tt-estrutura.titulo-col
tt-estrutura.conteudo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 14.5
         FONT 1 ROW-HEIGHT-CHARS .6 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-tt-bc-etiqueta-det AT ROW 1.5 COL 2
     btOK AT ROW 16.75 COL 2
     btCancel AT ROW 16.75 COL 13
     btHelp2 AT ROW 16.75 COL 80
     rtToolBar AT ROW 16.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
//liga o facelift
&GLOBAL-DEFINE aplica_facelift YES
{include/i_fcldef.i}
{include/i_fclfrm.i fpage0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* BROWSE-TAB br-tt-bc-etiqueta-det 1 fpage0 */
/* SETTINGS FOR BROWSE br-tt-bc-etiqueta-det IN FRAME fpage0
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-bc-etiqueta-det
/* Query rebuild information for BROWSE br-tt-bc-etiqueta-det
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura NO-LOCK BY tt-estrutura.sequencia INDEXED-REPOSITION.
     _END_FREEFORM
     _START_FREEFORM_DEFINE
DEFINE QUERY br-tt-bc-etiqueta-det FOR
                tt-estrutura SCROLLING.
     _END_FREEFORM_DEFINE
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-tt-bc-etiqueta-det */
&ANALYZE-RESUME

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


&Scoped-define BROWSE-NAME br-tt-bc-etiqueta-det
&Scoped-define SELF-NAME br-tt-bc-etiqueta-det
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-bc-etiqueta-det wWindow
ON ROW-DISPLAY OF br-tt-bc-etiqueta-det IN FRAME fpage0
DO:
   ASSIGN tt-estrutura.titulo-col:FONT IN BROWSE br-tt-bc-etiqueta-det = 0 /* negrito */ .

   IF tt-estrutura.tipo-dado = 'logical':U  THEN DO:
         ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-det = 'x(03)'.
   END.
   ELSE DO:
        IF tt-estrutura.tipo-dado = 'Decimal':U OR 
           tt-estrutura.tipo-dado = 'Integer':U THEN DO:
           ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-det = 'x(50)'.
        END.
        ELSE DO:
          ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-det = tt-estrutura.formato.
        END.

        IF  (   p-modifica           = NO
             OR tt-estrutura.per-alt = no)
        AND (   tt-estrutura.atributo = "bc-etiqueta.it-codigo"
             OR tt-estrutura.atributo = "bc-etiqueta.cod-estado")
        THEN DO:

            ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-det = 'x(50)'.

        END.

   END.  
   
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


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializaá∆o do programam ---*/
/* {window/mainblock.i} */
&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */

ON 'leave':U OF conteudo IN BROWSE br-tt-bc-etiqueta-det
DO:
   
   IF tt-estrutura.tipo-dado = 'logical' THEN DO:
      ASSIGN c-contrl = trim(INPUT BROWSE br-tt-bc-etiqueta-det conteudo).
      IF c-contrl <> 'sim':U AND
         c-contrl <> 'YES':U and
         c-contrl <> 'N∆o':U AND
         c-contrl <> 'No':U  AND
         c-contrl <> 'Nao':U THEN DO:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-informe-um-valor-valido-para-o AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Informe_um_valor_v†lido_para_o_atributo_(Sim/N∆o/Nao/No/YES)" *}
         ASSIGN c-lbl-liter-informe-um-valor-valido-para-o = TRIM(RETURN-VALUE).
         DEFINE VARIABLE c-lbl-liter-informe-esta-mensagem-ao-supor AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Informe_esta_mensagem_ao_Suporte_Datasul_Tecnologia" *}
         ASSIGN c-lbl-liter-informe-esta-mensagem-ao-supor = TRIM(RETURN-VALUE).
         MESSAGE c-lbl-liter-informe-um-valor-valido-para-o SKIP
         c-lbl-liter-informe-esta-mensagem-ao-supor + ' ' VIEW-AS ALERT-BOX ERROR.
         RETURN NO-APPLY.
      END.
    END.
END.
/* ***************************  Main Block  *************************** */

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Evento de CLOSE padr∆o para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.

/*--- Evento de CTRL-TAB padr∆o para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON CTRL-TAB ANYWHERE
        RUN nextFolder IN hFolder.
&ENDIF

/*--- Evento de SHIFT-CTRL-TAB padr∆o para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON SHIFT-CTRL-TAB ANYWHERE
        RUN prevFolder IN hFolder.
&ENDIF

/*--- Seta CURRENT-WINDOW como sendo a window atual ---*/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*--- Padr∆o para janelas GUI ---*/
PAUSE 0 BEFORE-HIDE.

&IF "{&UIB_is_Running}":U <> "":U &THEN
    /*--- Inicializa programa ---*/
    RUN initializeInterface IN THIS-PROCEDURE.
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.
&ELSE
    IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
        /*--- Inicializa programa ---*/
        RUN initializeInterface IN THIS-PROCEDURE.
        IF RETURN-VALUE = "NOK":U THEN
            RETURN "NOK":U.
    END.
&ENDIF
    

/*--- Block principal do programa ---*/
DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
   

   RUN pi-popula-br-tt-bc-etiqueta-det.
    
   /*--- Seta cursor do mouse para normal ---*/
   SESSION:SET-WAIT-STATE("":U).
    
   IF NOT THIS-PROCEDURE:PERSISTENT THEN
       WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-br-tt-bc-etiqueta-det wWindow 
PROCEDURE pi-popula-br-tt-bc-etiqueta-det :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VARIABLE c-atributo AS CHARACTER NO-UNDO.

FIND bc-etiqueta WHERE bc-etiqueta.nr-etiq = integer(p-chave) NO-LOCK NO-ERROR.
IF AVAILABLE bc-etiqueta THEN DO:
    FOR EACH tt-estrutura:
        {bcp/bc0118c.i bc-etiqueta.ativo}
        {bcp/bc0118c.i bc-etiqueta.it-codigo}
        {bcp/bc0118c.i bc-etiqueta.caracter-livre-1}
        {bcp/bc0118c.i bc-etiqueta.caracter-livre-2}
        {bcp/bc0118c.i bc-etiqueta.caracter-livre-3}
        {bcp/bc0118c.i bc-etiqueta.caracter-livre-4}
        {bcp/bc0118c.i bc-etiqueta.caracter-livre-5}
        {bcp/bc0118c.i bc-etiqueta.cd-trans}
        {bcp/bc0118c.i bc-etiqueta.char-1}
        {bcp/bc0118c.i bc-etiqueta.char-2}
        {bcp/bc0118c.i bc-etiqueta.check-sum}
        {bcp/bc0118c.i bc-etiqueta.cod-depos}
        {bcp/bc0118c.i bc-etiqueta.cod-estabel}
        {bcp/bc0118c.i bc-etiqueta.cod-estado}
        {bcp/bc0118c.i bc-etiqueta.cod-layout}
        {bcp/bc0118c.i bc-etiqueta.cod-transp}
        {bcp/bc0118c.i bc-etiqueta.data-1}
        {bcp/bc0118c.i bc-etiqueta.data-2}
        {bcp/bc0118c.i bc-etiqueta.data-livre-1}
        {bcp/bc0118c.i bc-etiqueta.data-livre-2}
        {bcp/bc0118c.i bc-etiqueta.data-livre-3}
        {bcp/bc0118c.i bc-etiqueta.data-livre-4}
        {bcp/bc0118c.i bc-etiqueta.data-livre-5}
        {bcp/bc0118c.i bc-etiqueta.dec-1}
        {bcp/bc0118c.i bc-etiqueta.dec-2}
        {bcp/bc0118c.i bc-etiqueta.decimal-livre-1}
        {bcp/bc0118c.i bc-etiqueta.decimal-livre-2}
        {bcp/bc0118c.i bc-etiqueta.decimal-livre-3}
        {bcp/bc0118c.i bc-etiqueta.decimal-livre-4}
        {bcp/bc0118c.i bc-etiqueta.decimal-livre-5}
        {bcp/bc0118c.i bc-etiqueta.detalhe}
        {bcp/bc0118c.i bc-etiqueta.dt-criacao}
        {bcp/bc0118c.i bc-etiqueta.dt-expedicao}
        {bcp/bc0118c.i bc-etiqueta.dt-producao}
        {bcp/bc0118c.i bc-etiqueta.dt-separacao}
        {bcp/bc0118c.i bc-etiqueta.dt-validade}
        {bcp/bc0118c.i bc-etiqueta.fm-codigo}
        {bcp/bc0118c.i bc-etiqueta.ge-codigo}
        {bcp/bc0118c.i bc-etiqueta.hr-criacao}
        {bcp/bc0118c.i bc-etiqueta.hr-expedicao}
        {bcp/bc0118c.i bc-etiqueta.hr-producao}
        {bcp/bc0118c.i bc-etiqueta.hr-separacao}
        {bcp/bc0118c.i bc-etiqueta.int-1}
        {bcp/bc0118c.i bc-etiqueta.int-2}
        {bcp/bc0118c.i bc-etiqueta.inteiro-livre-1}
        {bcp/bc0118c.i bc-etiqueta.inteiro-livre-2}
        {bcp/bc0118c.i bc-etiqueta.inteiro-livre-3}
        {bcp/bc0118c.i bc-etiqueta.inteiro-livre-4}
        {bcp/bc0118c.i bc-etiqueta.inteiro-livre-5}
        {bcp/bc0118c.i bc-etiqueta.linha-prod}
        {bcp/bc0118c.i bc-etiqueta.localizacao}
        {bcp/bc0118c.i bc-etiqueta.log-1}
        {bcp/bc0118c.i bc-etiqueta.log-2}
        {bcp/bc0118c.i Bc-etiqueta.log-datasul}
        {bcp/bc0118c.i bc-etiqueta.logico-livre-1}
        {bcp/bc0118c.i bc-etiqueta.logico-livre-2}
        {bcp/bc0118c.i bc-etiqueta.logico-livre-3}
        {bcp/bc0118c.i bc-etiqueta.logico-livre-4}
        {bcp/bc0118c.i bc-etiqueta.logico-livre-5}
        {bcp/bc0118c.i bc-etiqueta.lote}      
        {bcp/bc0118c.i bc-etiqueta.nat-operacao}
        {bcp/bc0118c.i bc-etiqueta.nome-abrev}
        {bcp/bc0118c.i bc-etiqueta.cdd-embarq}
        {bcp/bc0118c.i bc-etiqueta.nr-entrega}
        {bcp/bc0118c.i bc-etiqueta.nr-etiq}
        {bcp/bc0118c.i bc-etiqueta.nr-etiq-pai}
        {bcp/bc0118c.i bc-etiqueta.nr-nota-fis}
        {bcp/bc0118c.i bc-etiqueta.nr-ord-produ}
        {bcp/bc0118c.i bc-etiqueta.nr-pedcli}                        
        {bcp/bc0118c.i bc-etiqueta.nr-pedido}
        {bcp/bc0118c.i bc-etiqueta.nr-resumo}                        
        {bcp/bc0118c.i bc-etiqueta.nr-seq-fat}
        {bcp/bc0118c.i bc-etiqueta.nr-trans}                        
        {bcp/bc0118c.i bc-etiqueta.num-versao}
        {bcp/bc0118c.i bc-etiqueta.progressivo}                        
        {bcp/bc0118c.i bc-etiqueta.qt-item}
        {bcp/bc0118c.i bc-etiqueta.qt-un-1}                        
        {bcp/bc0118c.i bc-etiqueta.qt-un-2}
        {bcp/bc0118c.i bc-etiqueta.qt-un-3}                        
        {bcp/bc0118c.i bc-etiqueta.qt-un-4}
        {bcp/bc0118c.i bc-etiqueta.qt-un-5}
        {bcp/bc0118c.i bc-etiqueta.referencia}
        {bcp/bc0118c.i bc-etiqueta.serie}
        {bcp/bc0118c.i bc-etiqueta.turno}
        {bcp/bc0118c.i bc-etiqueta.un}
        {bcp/bc0118c.i bc-etiqueta.un-1}
        {bcp/bc0118c.i bc-etiqueta.un-2}
        {bcp/bc0118c.i bc-etiqueta.un-3}
        {bcp/bc0118c.i bc-etiqueta.un-4}
        {bcp/bc0118c.i bc-etiqueta.un-5}
        {bcp/bc0118c.i bc-etiqueta.usuar-criacao}
        {bcp/bc0118c.i bc-etiqueta.usuar-expedicao}
        {bcp/bc0118c.i bc-etiqueta.usuar-producao}
        {bcp/bc0118c.i Bc-etiqueta.usuar-separacao}
        {bcp/bc0118c.i Bc-etiqueta.nr-romaneio}
        /*Vagner*/
        /*{bcp/bc0118c.i Bc-etiqueta.raw-livre}*/
        {bcp/bc0118c.i Bc-etiqueta.dt-inventario}
        {bcp/bc0118c.i Bc-etiqueta.nr-contagem}
        {bcp/bc0118c.i Bc-etiqueta.usuar-inventario}
        {bcp/bc0118c.i Bc-etiqueta.hr-inventario}
        {bcp/bc0118c.i Bc-etiqueta.nr-operacao}

        &IF  '{&mgcld_version}' >= '2.04' 
        &THEN
            {bcp/bc0118c.i Bc-etiqueta.id-docto}
            {bcp/bc0118c.i Bc-etiqueta.cod-controle-serie}
            {bcp/bc0118c.i Bc-etiqueta.cod-embalagem}
            {bcp/bc0118c.i Bc-etiqueta.cod-montadora}
            {bcp/bc0118c.i Bc-etiqueta.cod-idioma}
            {bcp/bc0118c.i Bc-etiqueta.cod-agrupador1}
            {bcp/bc0118c.i Bc-etiqueta.cod-agrupador2}
            {bcp/bc0118c.i Bc-etiqueta.cod-agrupador3}
            {bcp/bc0118c.i Bc-etiqueta.cod-agrupador4}
            {bcp/bc0118c.i Bc-etiqueta.cod-agrupador5}
            {bcp/bc0118c.i Bc-etiqueta.ep-codigo}
            {bcp/bc0118c.i Bc-etiqueta.numero-ordem}
            {bcp/bc0118c.i Bc-etiqueta.parcela}
            {bcp/bc0118c.i Bc-etiqueta.num-pedido}
            {bcp/bc0118c.i Bc-etiqueta.nro-docto}
            {bcp/bc0118c.i Bc-etiqueta.serie-docto}
            {bcp/bc0118c.i Bc-etiqueta.nat-operacao-docto}
            {bcp/bc0118c.i Bc-etiqueta.cod-emitente-docto}
            {bcp/bc0118c.i Bc-etiqueta.id-box}
            {bcp/bc0118c.i Bc-etiqueta.cod-local}
            {bcp/bc0118c.i Bc-etiqueta.sequencia-docto}
            {bcp/bc0118c.i Bc-etiqueta.dt-recebimento}
            {bcp/bc0118c.i Bc-etiqueta.hr-recebimento}
            {bcp/bc0118c.i Bc-etiqueta.usuar-recebimento}
            {bcp/bc0118c.i Bc-etiqueta.nr-volume}
        &ELSE
        &ENDIF

        IF  tt-estrutura.per-alt = NO
        OR  P-MODIFICA           = NO
        THEN DO:

            IF  tt-estrutura.atributo = "bc-etiqueta.it-codigo":U
            THEN DO:

                run pi-verifica-item ( input TRIM(tt-estrutura.conteudo),
                                       input TRIM(tt-estrutura.conteudo),
                                       input 0,   /* Tipo de Acesso 0=Currente .... */
                                       input 1).

                if NOT avail ttReturnMessages
                THEN
                    ASSIGN tt-estrutura.conteudo = tt-estrutura.conteudo + " - " + ttItem.desc-item.

            END.

            IF  tt-estrutura.atributo = "bc-etiqueta.cod-estado":U
            THEN DO:

                FIND bc-estado-etiq
                     WHERE bc-estado-etiq.cod-estado = INT(tt-estrutura.conteudo)
                     NO-LOCK NO-ERROR.

                ASSIGN tt-estrutura.conteudo = tt-estrutura.conteudo + (IF AVAIL bc-estado-etiq THEN " - " + bc-estado-etiq.descricao ELSE ""). 

            END.


        END.


    END.
END.
{&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}

APPLY "VALUE-CHANGED":U TO br-tt-bc-etiqueta-det IN FRAME  {&FRAME-NAME}.
RETURN 'ok':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

