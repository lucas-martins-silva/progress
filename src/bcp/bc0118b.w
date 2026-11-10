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
{include/i-prgvrs.i BC0118B 2.00.00.011 } /*** "010011" 09/10/2025 11:26:30 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc0118b MBC}
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
&GLOBAL-DEFINE Program        BC0118B
&GLOBAL-DEFINE Version        2.00.00.011

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Local Default

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 br-tt-bc-etiqueta-mod
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

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
    FIELD faixa      AS LOG .

{bcp/bcproxy.i2}    /* DefiniáÑes das procedures para integraá∆o com o Magnus i.00 */
{cdp/cdcfgint.i} /* versao de produto */

DEF BUFFER b-tt-estrutura   FOR tt-estrutura.
/* Parameters Definitions ---                                           */
DEFINE INPUT        PARAMETER p-modifica AS LOGICAL.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-estrutura.
DEFINE INPUT        PARAMETER p-chave  AS CHARACTER.

DEFINE VARIABLE c-contrl AS CHARACTER NO-UNDO.
DEFINE VARIABLE h-query AS WIDGET-HANDLE.
DEFINE VARIABLE h-buffer AS WIDGET-HANDLE.
DEFINE VARIABLE v-cont-registro AS INTEGER.
DEFINE VARIABLE l-log-repeat AS LOGICAL INITIAL YES.

DEF VAR v-date               AS DATE                     NO-UNDO.
DEF VAR v-logical            AS LOGICAL                  NO-UNDO.
DEF VAR v-integer            AS INT                      NO-UNDO.
DEF VAR v-decimal-aux        AS DEC DECIMALS 10          NO-UNDO.
DEF VAR v-character          AS CHAR                     NO-UNDO.
DEF VAR c-formato            AS CHAR.
DEF VAR c-armaz-dec          AS CHARACTER  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-bc-etiqueta-mod

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estrutura

/* Definitions for BROWSE br-tt-bc-etiqueta-mod                         */
&Scoped-define FIELDS-IN-QUERY-br-tt-bc-etiqueta-mod tt-estrutura.titulo-col tt-estrutura.conteudo   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-bc-etiqueta-mod tt-estrutura.conteudo   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-tt-bc-etiqueta-mod tt-estrutura
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-tt-bc-etiqueta-mod tt-estrutura
&Scoped-define SELF-NAME br-tt-bc-etiqueta-mod
&Scoped-define OPEN-QUERY-br-tt-bc-etiqueta-mod OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura NO-LOCK  BY tt-estrutura.sequencia INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tt-bc-etiqueta-mod tt-estrutura
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-bc-etiqueta-mod tt-estrutura


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-tt-bc-etiqueta-mod}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS br-tt-bc-etiqueta-mod btOK btCancel btHelp2 ~
rtToolBar 

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
DEFINE QUERY br-tt-bc-etiqueta-mod FOR
                tt-estrutura SCROLLING.

&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-bc-etiqueta-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-bc-etiqueta-mod wWindow _FREEFORM
  QUERY br-tt-bc-etiqueta-mod NO-LOCK DISPLAY
      tt-estrutura.titulo-col
tt-estrutura.conteudo
ENABLE tt-estrutura.conteudo
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 88 BY 14.5
         FONT 1 ROW-HEIGHT-CHARS .62 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-tt-bc-etiqueta-mod AT ROW 1.25 COL 2
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
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
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
/* BROWSE-TAB br-tt-bc-etiqueta-mod 1 fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-bc-etiqueta-mod
/* Query rebuild information for BROWSE br-tt-bc-etiqueta-mod
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura NO-LOCK  BY tt-estrutura.sequencia INDEXED-REPOSITION.
     _END_FREEFORM
     _START_FREEFORM_DEFINE
DEFINE QUERY br-tt-bc-etiqueta-mod FOR
                tt-estrutura SCROLLING.
     _END_FREEFORM_DEFINE
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-tt-bc-etiqueta-mod */
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


&Scoped-define BROWSE-NAME br-tt-bc-etiqueta-mod
&Scoped-define SELF-NAME br-tt-bc-etiqueta-mod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-bc-etiqueta-mod wWindow
ON ROW-DISPLAY OF br-tt-bc-etiqueta-mod IN FRAME fpage0
DO:
    ASSIGN tt-estrutura.titulo-col:FONT IN BROWSE br-tt-bc-etiqueta-mod = 0 /* negrito */ .
    IF tt-estrutura.per-alt = YES THEN DO:
        ASSIGN tt-estrutura.conteudo:FGCOLOR IN BROWSE br-tt-bc-etiqueta-mod = 9.
        ASSIGN tt-estrutura.titulo-col:FGCOLOR IN BROWSE br-tt-bc-etiqueta-mod = 9.
    END.
    IF tt-estrutura.tipo-dado = 'logical':U  THEN DO:
        ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-mod = 'x(03)':U.
    END.
    ELSE DO:
        IF tt-estrutura.tipo-dado = 'Decimal':U OR 
           tt-estrutura.tipo-dado = 'Integer':U THEN DO:

           ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-mod = 'x(50)':U.
             
        END.
        ELSE DO:
            ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-mod = tt-estrutura.formato.
        END.

        IF  (   p-modifica           = NO
             OR tt-estrutura.per-alt = no)
        AND (   tt-estrutura.atributo = "bc-etiqueta.it-codigo":U
             OR tt-estrutura.atributo = "bc-etiqueta.cod-estado":U)
        THEN DO:

            ASSIGN tt-estrutura.conteudo:FORMAT IN BROWSE br-tt-bc-etiqueta-mod = 'x(50)':U.

        END.

    END.  


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-bc-etiqueta-mod wWindow
ON VALUE-CHANGED OF br-tt-bc-etiqueta-mod IN FRAME fpage0
DO:
  IF p-modifica = YES THEN do:
    IF tt-estrutura.per-alt = NO THEN DO:
        ASSIGN tt-estrutura.conteudo:READ-ONLY IN BROWSE br-tt-bc-etiqueta-mod = YES.
    END.
    ELSE DO:
        ASSIGN tt-estrutura.conteudo:READ-ONLY IN BROWSE br-tt-bc-etiqueta-mod = NO.
    END.
  END.
  ELSE DO:
      ASSIGN tt-estrutura.conteudo:READ-ONLY IN BROWSE br-tt-bc-etiqueta-mod = NO.
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

    RUN pi-atualiza-dados (INPUT p-chave).
    IF RETURN-VALUE <> 'OK':U THEN RETURN NO-APPLY.
    
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

 /* ***************************  Main Block  *************************** */

/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).
/* klemke 
/*--- Evento de CLOSE padr∆o para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.
klemke */
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
    
ON 'leave':U OF conteudo IN BROWSE br-tt-bc-etiqueta-mod
DO:
   DEF VAR c-aux AS CHAR.
   DEF VAR i-cont AS INTEGER.
   DEF VAR l-controle AS LOGICAL.
   
   ASSIGN tt-estrutura.conteudo = tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod.

   RUN pi-valida-conteudo.

   IF RETURN-VALUE <> 'OK':U THEN RETURN NO-APPLY.
   IF tt-estrutura.tipo-dado = 'Decimal':U  THEN DO:
       ASSIGN c-aux = tt-estrutura.atributo + '*' + 
                      trim(tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod).

       IF LOOKUP(c-aux,c-armaz-dec,CHR(10)) = 0  THEN 
          ASSIGN c-armaz-dec = c-armaz-dec + CHR(10) + c-aux.
      
   END.
END. 


/*--- Block principal do programa ---*/
DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
    ASSIGN l-log-repeat  = YES.
    servidor:
    repeat on quit undo servidor, retry servidor
           on stop undo servidor, retry servidor
           on error undo servidor, retry servidor
           on endkey undo servidor, retry servidor
           while l-log-repeat = YES:

        assign l-log-repeat  = no.
        RUN pi-popula-br-tt-bc-etiqueta-mod.
        SESSION:SET-WAIT-STATE("":U).
        
        IF NOT THIS-PROCEDURE:PERSISTENT THEN
            WAIT-FOR CLOSE OF THIS-PROCEDURE.
        
    END.
    RUN destroyInterface IN THIS-PROCEDURE.
END.
RETURN 'ok':U.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-dados wWindow 
PROCEDURE pi-atualiza-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER p-chave AS CHARACTER.

DEF VAR c-aux               AS CHARACTER.
DEF VAR i-cont              AS INTEGER.
DEF VAR h-buffer            AS HANDLE.
DEF VAR h-field             AS HANDLE.
DEF VAR v-campo             AS CHARACTER.
DEF VAR h-query             AS HANDLE.

DEF VAR  v-cont-field    AS INT NO-UNDO.

DEF VAR v-date               AS DATE                     NO-UNDO.
DEF VAR v-logical            AS LOGICAL                  NO-UNDO.
DEF VAR v-integer            AS INT                      NO-UNDO.
DEF VAR v-decimal-aux        AS DEC DECIMALS 10          NO-UNDO.
DEF VAR v-character          AS CHAR                     NO-UNDO.
        
DEF VAR i-linha AS INTEGER.

ASSIGN i-linha = CURRENT-RESULT-ROW("br-tt-bc-etiqueta-mod":U).

DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
DO TRANSACTION:

    CREATE BUFFER h-buffer FOR TABLE "bc-etiqueta":U.
    CREATE QUERY h-query.          

    h-query:SET-BUFFERS(h-buffer).                     
    h-query:query-prepare("for each bc-etiqueta where bc-etiqueta.nr-etiq = ":U +  "integer(":U + p-chave + ")":U)/*NO-lock*/. 
    h-query:query-open().
    h-query:get-first(EXCLUSIVE-LOCK).
       
    ASSIGN h-buffer        = h-query:get-buffer-handle(1)
           v-cont-registro = 1.
    
    REPEAT v-cont-field = 1 TO h-buffer:NUM-FIELDS:
         
         h-field = h-buffer:BUFFER-FIELD(v-cont-field).
    
         v-campo = "bc-etiqueta":U + ".":U + trim(h-field:NAME).
         

         FIND b-tt-estrutura WHERE b-tt-estrutura.atributo = v-campo NO-LOCK NO-ERROR.

         IF  AVAILABLE b-tt-estrutura 
         AND b-tt-estrutura.per-alt = YES
         THEN DO:
           
             IF  h-field:DATA-TYPE = "INTEGER":U THEN DO:   
                ASSIGN v-integer = INT(b-tt-estrutura.conteudo) NO-ERROR.
                IF ERROR-STATUS:ERROR
                THEN DO:
                    /* Erro ao salvar valores do tipo Inteiro*/
                    RUN utp/ut-msgs.p (input "show":U,
                                       input 27796,
                                       input CAPS(v-campo)).
                    ASSIGN v-integer = 0.
                    ASSIGN l-log-repeat = YES.
                    RETURN 'nok':U.
                END.
                ASSIGN  h-field:BUFFER-VALUE() = v-integer.
              END.
    
              IF  h-field:DATA-TYPE = "DECIMAL":U THEN DO:
                 ASSIGN i-cont = 1.
                 DO i-cont = 1 TO NUM-ENTRIES(c-armaz-dec,CHR(10)):
                     IF TRIM(entry(1,ENTRY(i-cont,c-armaz-dec,CHR(10)),'*')) = trim(b-tt-estrutura.atributo) THEN DO:
                         ASSIGN b-tt-estrutura.conteudo = entry(2,ENTRY(i-cont,c-armaz-dec,CHR(10)),'*').
                     END.
                 END.
                 ASSIGN v-decimal-aux = DEC(b-tt-estrutura.conteudo) NO-ERROR.
                  IF ERROR-STATUS:ERROR
                  THEN DO:
                        /* Erro ao salvar valores do tipo decimal */
                        RUN utp/ut-msgs.p (input "show":U,
                                           input 27797,
                                           input CAPS(v-campo)).
                        ASSIGN v-decimal-aux = 0.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok':U.
                  END.
                  ASSIGN  h-field:BUFFER-VALUE() = v-decimal-aux.
               END.
    
               IF  h-field:DATA-TYPE = "LOGICAL":U THEN DO:
    
                    ASSIGN v-logical = IF b-tt-estrutura.conteudo       = "yes":U 
                                     OR b-tt-estrutura.conteudo          = "SIM":U
                                     OR INDEX(b-tt-estrutura.conteudo,"1":U) > 0
                                     THEN YES 
                                     ELSE
                                    IF b-tt-estrutura.conteudo = "no":U
                                    OR b-tt-estrutura.conteudo = "N∆o":U
                                    OR b-tt-estrutura.conteudo = "nao":U 
                                    OR INDEX(b-tt-estrutura.conteudo,"0":U) > 0
                                    THEN NO 
                                    ELSE    
                                    IF b-tt-estrutura.conteudo <> "" 
                                    THEN YES 
                                    ELSE NO 
                                    NO-ERROR.
    
                     IF ERROR-STATUS:ERROR
                     THEN DO:
                        /* Erro ao salvar valores do tipo Logico */
                        RUN utp/ut-msgs.p (input "show":U,
                                           input 27798,
                                           input CAPS(v-campo)).
                        ASSIGN v-logical = NO.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok':U.
                     END.
                     ASSIGN h-field:BUFFER-VALUE() = v-logical.
               END.
    
               IF  h-field:DATA-TYPE = "CHARACTER":U THEN DO:
            
                  ASSIGN v-character = b-tt-estrutura.conteudo NO-ERROR.
        
                  IF ERROR-STATUS:ERROR
                  THEN DO:
                      /* Erro ao salvar valores do tipo Caracter */
                      RUN utp/ut-msgs.p (input "show":U,
                                         input 27799,
                                         input CAPS(v-campo)).
                      ASSIGN v-character = "".
                      ASSIGN l-log-repeat = YES.
                      RETURN 'nok':U.
                  END.
                  ASSIGN h-field:BUFFER-VALUE() = v-character.
               END.
    
               IF  h-field:DATA-TYPE = "DATE":U THEN DO:
                    
                    ASSIGN v-date = date(b-tt-estrutura.conteudo) NO-ERROR.
                           
                    IF  ERROR-STATUS:ERROR
                    THEN DO:
                        /* Erro ao salvar valores do tipo Date */
                        RUN utp/ut-msgs.p (input "show":U,
                                           input 27800,
                                           input CAPS(v-campo)).
                        ASSIGN v-date = ?.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok':U.
                    END.

                    ASSIGN h-field:BUFFER-VALUE() = v-date .

               END.
       END.
    END.
END.
END.
ASSIGN l-log-repeat = NO.
RETURN 'ok':U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-br-tt-bc-etiqueta-mod wWindow 
PROCEDURE pi-popula-br-tt-bc-etiqueta-mod :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VARIABLE c-atributo AS CHARACTER NO-UNDO.
DEF VARIABLE i-nr-etiq  LIKE bc-etiqueta.nr-etiq.

ASSIGN i-nr-etiq = integer(p-chave).
FIND bc-etiqueta WHERE bc-etiqueta.nr-etiq = i-nr-etiq NO-LOCK NO-ERROR.
IF AVAILABLE bc-etiqueta THEN DO:
    FOR EACH tt-estrutura NO-LOCK:
        {bcp/bc0118b.i bc-etiqueta.ativo}
        {bcp/bc0118b.i bc-etiqueta.caracter-livre-1}
        {bcp/bc0118b.i bc-etiqueta.caracter-livre-2}
        {bcp/bc0118b.i bc-etiqueta.caracter-livre-3}
        {bcp/bc0118b.i bc-etiqueta.caracter-livre-4}
        {bcp/bc0118b.i bc-etiqueta.caracter-livre-5}
        {bcp/bc0118b.i bc-etiqueta.cd-trans}
        {bcp/bc0118b.i bc-etiqueta.char-1}
        {bcp/bc0118b.i bc-etiqueta.char-2}
        {bcp/bc0118b.i bc-etiqueta.check-sum}
        {bcp/bc0118b.i bc-etiqueta.cod-depos}
        {bcp/bc0118b.i bc-etiqueta.cod-estabel}
        {bcp/bc0118b.i bc-etiqueta.cod-estado}
        {bcp/bc0118b.i bc-etiqueta.cod-layout}
        {bcp/bc0118b.i bc-etiqueta.cod-transp}
        {bcp/bc0118b.i bc-etiqueta.data-1}
        {bcp/bc0118b.i bc-etiqueta.data-2}
        {bcp/bc0118b.i bc-etiqueta.data-livre-1}
        {bcp/bc0118b.i bc-etiqueta.data-livre-2}
        {bcp/bc0118b.i bc-etiqueta.data-livre-3}
        {bcp/bc0118b.i bc-etiqueta.data-livre-4}
        {bcp/bc0118b.i bc-etiqueta.data-livre-5}
        {bcp/bc0118b.i bc-etiqueta.dec-1}
        {bcp/bc0118b.i bc-etiqueta.dec-2}
        {bcp/bc0118b.i bc-etiqueta.decimal-livre-1}
        {bcp/bc0118b.i bc-etiqueta.decimal-livre-2}
        {bcp/bc0118b.i bc-etiqueta.decimal-livre-3}
        {bcp/bc0118b.i bc-etiqueta.decimal-livre-4}
        {bcp/bc0118b.i bc-etiqueta.decimal-livre-5}
        {bcp/bc0118b.i bc-etiqueta.detalhe}
        {bcp/bc0118b.i bc-etiqueta.dt-criacao}
        {bcp/bc0118b.i bc-etiqueta.dt-expedicao}
        {bcp/bc0118b.i bc-etiqueta.dt-producao}
        {bcp/bc0118b.i bc-etiqueta.dt-separacao}
        {bcp/bc0118b.i bc-etiqueta.dt-validade}
        {bcp/bc0118b.i bc-etiqueta.fm-codigo}
        {bcp/bc0118b.i bc-etiqueta.ge-codigo}
        {bcp/bc0118b.i bc-etiqueta.hr-criacao}
        {bcp/bc0118b.i bc-etiqueta.hr-expedicao}
        {bcp/bc0118b.i bc-etiqueta.hr-producao}
        {bcp/bc0118b.i bc-etiqueta.hr-separacao}
        {bcp/bc0118b.i bc-etiqueta.it-codigo}
        {bcp/bc0118b.i bc-etiqueta.int-1}
        {bcp/bc0118b.i bc-etiqueta.int-2}
        {bcp/bc0118b.i bc-etiqueta.inteiro-livre-1}
        {bcp/bc0118b.i bc-etiqueta.inteiro-livre-2}
        {bcp/bc0118b.i bc-etiqueta.inteiro-livre-3}
        {bcp/bc0118b.i bc-etiqueta.inteiro-livre-4}
        {bcp/bc0118b.i bc-etiqueta.inteiro-livre-5}
        {bcp/bc0118b.i bc-etiqueta.linha-prod}
        {bcp/bc0118b.i bc-etiqueta.localizacao}
        {bcp/bc0118b.i bc-etiqueta.log-1}
        {bcp/bc0118b.i bc-etiqueta.log-2}
        {bcp/bc0118b.i Bc-etiqueta.log-datasul}
        {bcp/bc0118b.i bc-etiqueta.logico-livre-1}
        {bcp/bc0118b.i bc-etiqueta.logico-livre-2}
        {bcp/bc0118b.i bc-etiqueta.logico-livre-3}
        {bcp/bc0118b.i bc-etiqueta.logico-livre-4}
        {bcp/bc0118b.i bc-etiqueta.logico-livre-5}
        {bcp/bc0118b.i bc-etiqueta.lote}      
        {bcp/bc0118b.i bc-etiqueta.nat-operacao}
        {bcp/bc0118b.i bc-etiqueta.nome-abrev}
        {bcp/bc0118b.i bc-etiqueta.cdd-embarq}
        {bcp/bc0118b.i bc-etiqueta.nr-entrega}
        {bcp/bc0118b.i bc-etiqueta.nr-etiq}
        {bcp/bc0118b.i bc-etiqueta.nr-etiq-pai}
        {bcp/bc0118b.i bc-etiqueta.nr-nota-fis}
        {bcp/bc0118b.i bc-etiqueta.nr-ord-produ}
        {bcp/bc0118b.i bc-etiqueta.nr-pedcli}                        
        {bcp/bc0118b.i bc-etiqueta.nr-pedido}
        {bcp/bc0118b.i bc-etiqueta.nr-resumo}                        
        {bcp/bc0118b.i bc-etiqueta.nr-seq-fat}
        {bcp/bc0118b.i bc-etiqueta.nr-trans}                        
        {bcp/bc0118b.i bc-etiqueta.num-versao}
        {bcp/bc0118b.i bc-etiqueta.progressivo}                        
        {bcp/bc0118b.i bc-etiqueta.qt-item}
        {bcp/bc0118b.i bc-etiqueta.qt-un-1}                        
        {bcp/bc0118b.i bc-etiqueta.qt-un-2}
        {bcp/bc0118b.i bc-etiqueta.qt-un-3}                        
        {bcp/bc0118b.i bc-etiqueta.qt-un-4}
        {bcp/bc0118b.i bc-etiqueta.qt-un-5}
        {bcp/bc0118b.i bc-etiqueta.referencia}
        {bcp/bc0118b.i bc-etiqueta.serie}
        {bcp/bc0118b.i bc-etiqueta.turno}
        {bcp/bc0118b.i bc-etiqueta.un}
        {bcp/bc0118b.i bc-etiqueta.un-1}
        {bcp/bc0118b.i bc-etiqueta.un-2}
        {bcp/bc0118b.i bc-etiqueta.un-3}
        {bcp/bc0118b.i bc-etiqueta.un-4}
        {bcp/bc0118b.i bc-etiqueta.un-5}
        {bcp/bc0118b.i bc-etiqueta.usuar-criacao}
        {bcp/bc0118b.i bc-etiqueta.usuar-expedicao}
        {bcp/bc0118b.i bc-etiqueta.usuar-producao}
        {bcp/bc0118b.i Bc-etiqueta.usuar-separacao}
        {bcp/bc0118b.i Bc-etiqueta.nr-romaneio}
        /*Vagner*/
        /*{bcp/bc0118b.i Bc-etiqueta.raw-livre}*/
        {bcp/bc0118b.i Bc-etiqueta.dt-inventario}
        {bcp/bc0118b.i Bc-etiqueta.nr-contagem}
        {bcp/bc0118b.i Bc-etiqueta.usuar-inventario}
        {bcp/bc0118b.i Bc-etiqueta.hr-inventario}
        {bcp/bc0118b.i Bc-etiqueta.nr-operacao}

        &IF  '{&mgcld_version}' >= '2.04' 
        &THEN
            {bcp/bc0118b.i Bc-etiqueta.id-docto}
            {bcp/bc0118b.i Bc-etiqueta.cod-controle-serie}
            {bcp/bc0118b.i Bc-etiqueta.cod-embalagem}
            {bcp/bc0118b.i Bc-etiqueta.cod-montadora}
            {bcp/bc0118b.i Bc-etiqueta.cod-idioma}
            {bcp/bc0118b.i Bc-etiqueta.cod-agrupador1}
            {bcp/bc0118b.i Bc-etiqueta.cod-agrupador2}
            {bcp/bc0118b.i Bc-etiqueta.cod-agrupador3}
            {bcp/bc0118b.i Bc-etiqueta.cod-agrupador4}
            {bcp/bc0118b.i Bc-etiqueta.cod-agrupador5}
            {bcp/bc0118b.i Bc-etiqueta.ep-codigo}
            {bcp/bc0118b.i Bc-etiqueta.numero-ordem}
            {bcp/bc0118b.i Bc-etiqueta.parcela}
            {bcp/bc0118b.i Bc-etiqueta.num-pedido}
            {bcp/bc0118b.i Bc-etiqueta.nro-docto}
            {bcp/bc0118b.i Bc-etiqueta.serie-docto}
            {bcp/bc0118b.i Bc-etiqueta.nat-operacao-docto}
            {bcp/bc0118b.i Bc-etiqueta.cod-emitente-docto}
            {bcp/bc0118b.i Bc-etiqueta.id-box}
            {bcp/bc0118b.i Bc-etiqueta.cod-local}
            {bcp/bc0118b.i Bc-etiqueta.sequencia-docto}
            {bcp/bc0118b.i Bc-etiqueta.dt-recebimento}
            {bcp/bc0118b.i Bc-etiqueta.hr-recebimento}
            {bcp/bc0118b.i Bc-etiqueta.usuar-recebimento}
            {bcp/bc0118b.i Bc-etiqueta.nr-volume}
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

APPLY "VALUE-CHANGED":U TO br-tt-bc-etiqueta-mod IN FRAME  {&FRAME-NAME}.
RETURN 'ok':u.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conteudo wWindow 
PROCEDURE pi-valida-conteudo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "INTEGER":U THEN DO:  
     ASSIGN v-integer = INT(tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod) NO-ERROR .
     IF ERROR-STATUS:ERROR
     THEN DO:
         /* Erro ao salvar valores do tipo Inteiro*/
        RUN utp/ut-msgs.p (input "show":U,
                           input 27796,
                           input CAPS(tt-estrutura.atributo)).
        ASSIGN v-integer = 0.
        RETURN NO-APPLY.
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "DECIMAL":U THEN DO:  
     ASSIGN v-decimal-aux = DEC(tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod) NO-ERROR.
     IF ERROR-STATUS:ERROR
     THEN DO:
        /* Erro ao salvar valores do tipo Decimal */
        RUN utp/ut-msgs.p (input "show":U,
                           input 27797,
                           input CAPS(tt-estrutura.atributo)).
         ASSIGN v-decimal-aux = 0.
         RETURN NO-APPLY.
     END.
END.
IF  tt-estrutura.tipo-dado = "Logical":U THEN DO:  
    IF tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod <> 'sim' AND
       tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod <> 'yes' AND
       tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod <> 'no' AND
       tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod <> 'N∆o' AND
       tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod <> 'Nao' THEN
       ASSIGN ERROR-STATUS:ERROR = YES.
    
     IF ERROR-STATUS:ERROR
     THEN DO:
        /* Erro ao salvar valores do tipo Logical */
        RUN utp/ut-msgs.p (input "show":U,
                           input 27798,
                           input CAPS(tt-estrutura.atributo)).
        ASSIGN v-logical = NO.
        RETURN NO-APPLY.
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "character":U THEN DO:  
     ASSIGN v-character = tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod NO-ERROR.
     IF ERROR-STATUS:ERROR
     THEN DO:
         /* Erro ao salvar valores do tipo Caracter */
         RUN utp/ut-msgs.p (input "show":U,
                            input 27799,
                            input CAPS(tt-estrutura.atributo)).
         ASSIGN v-character = '' .
         RETURN NO-APPLY.
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "date":U THEN DO:  
     ASSIGN v-date = date(tt-estrutura.conteudo:SCREEN-VALUE IN BROWSE br-tt-bc-etiqueta-mod) NO-ERROR.
     IF ERROR-STATUS:ERROR OR v-date = ?
     THEN DO:
        /* Erro ao salvar valores do tipo Date */
        RUN utp/ut-msgs.p (input "show":U,
                           input 27800,
                           input CAPS(tt-estrutura.atributo)).
         ASSIGN v-date = ?.
         RETURN NO-APPLY.
     END.
END.

/** CONSISTE ESTADO DA ETIQUETA  E ITEM **/

IF  tt-estrutura.atributo = "bc-etiqueta.it-codigo":U
THEN DO:

    run pi-verifica-item ( input TRIM(tt-estrutura.conteudo),
                           input TRIM(tt-estrutura.conteudo),
                           input 0,   /* Tipo de Acesso 0=Currente .... */
                           input 1).

    if avail ttReturnMessages
    THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Item" *}
        RUN utp/ut-msgs.p (input "show",
                           input 56,
                           input RETURN-VALUE + " " + tt-estrutura.conteudo).

        RETURN NO-APPLY.

    END.
        

END.

IF  tt-estrutura.atributo = "bc-etiqueta.cod-estado":U
THEN DO:

    FIND bc-estado-etiq
         WHERE bc-estado-etiq.cod-estado = INT(tt-estrutura.conteudo)
         NO-LOCK NO-ERROR.

    IF NOT AVAIL bc-estado-etiq THEN DO:

        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estado_Etiqueta" *}
        RUN utp/ut-msgs.p (input "show",
                           input 56,
                           input RETURN-VALUE + " " + tt-estrutura.conteudo).
    
        RETURN NO-APPLY.

    END.
    
END.   

/** CONSISTE ESTADO DA ETIQUETA **/

RETURN 'ok':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

