&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          rtb              PROGRESS
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
{include/i-prgvrs.i BC0118A 2.00.00.007 } /*** "010007" 09/10/2025 11:26:29 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0118A MBC}
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
&GLOBAL-DEFINE Program        BC0118A
&GLOBAL-DEFINE Version        2.00.00.007

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Local Default

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 br-tt-estrutura
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

DEF TEMP-TABLE tt-estrutura NO-UNDO /* obtido atraves do bc0201 */
    FIELD sequencia  AS INTEGER   FORMAT '>>>>9':U LABEL 'Sequˆncia'
    FIELD titulo     AS CHARACTER FORMAT 'x(50)':U LABEL 'T¡tulo'
    FIELD titulo-col AS CHARACTER FORMAT 'x(50)':U LABEL 'T¡tulo Coluna'
    FIELD atributo   AS CHARACTER FORMAT 'x(100)':U LABEL 'Atributo'
    FIELD formato    AS CHARACTER FORMAT 'x(30)':U LABEL 'Formato'
    FIELD tipo-dado  AS CHARACTER FORMAT 'x(30)':U LABEL 'Tipo Dado'
    FIELD per-alt    AS LOGICAL FORMAT 'Sim/NÆo':U LABEL 'Altera?'
    FIELD inicial    AS CHARACTER FORMAT 'x(100)':U LABEL 'Valor Inicial'
    FIELD final      AS CHARACTER FORMAT 'x(100)':U LABEL 'Valor Final'
    FIELD conteudo   AS CHARACTER FORMAT 'x(100)':U LABEL 'Conte£do'
    FIELD faixa      AS LOG 
    INDEX id IS PRIMARY sequencia.

/* Parameters Definitions ---                                           */
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-estrutura.
DEFINE BUFFER b-tt-estrutura FOR tt-estrutura.
DEFINE VAR c-contrl AS CHARACTER NO-UNDO.
DEF VAR c-armaz-dec-ini      AS CHARACTER  NO-UNDO.
DEF VAR c-armaz-dec-fim      AS CHARACTER  NO-UNDO.
DEF VAR v-date               AS DATE                     NO-UNDO.
DEF VAR v-logical            AS LOGICAL                  NO-UNDO.
DEF VAR v-integer            AS INT                      NO-UNDO.
DEF VAR v-decimal-aux        AS DEC DECIMALS 10          NO-UNDO.
DEF VAR v-character          AS CHAR                     NO-UNDO.
DEF VAR l-log-repeat         AS LOGICAL                  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME br-tt-estrutura

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-estrutura

/* Definitions for BROWSE br-tt-estrutura                               */
&Scoped-define FIELDS-IN-QUERY-br-tt-estrutura tt-estrutura.titulo-col tt-estrutura.inicial tt-estrutura.final   
&Scoped-define ENABLED-FIELDS-IN-QUERY-br-tt-estrutura tt-estrutura.inicial ~
tt-estrutura.final   
&Scoped-define ENABLED-TABLES-IN-QUERY-br-tt-estrutura tt-estrutura
&Scoped-define FIRST-ENABLED-TABLE-IN-QUERY-br-tt-estrutura tt-estrutura
&Scoped-define SELF-NAME br-tt-estrutura
&Scoped-define QUERY-STRING-br-tt-estrutura FOR EACH tt-estrutura  NO-LOCK BY tt-estrutura.sequencia  INDEXED-REPOSITION
&Scoped-define OPEN-QUERY-br-tt-estrutura OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura  NO-LOCK BY tt-estrutura.sequencia  INDEXED-REPOSITION.
&Scoped-define TABLES-IN-QUERY-br-tt-estrutura tt-estrutura
&Scoped-define FIRST-TABLE-IN-QUERY-br-tt-estrutura tt-estrutura


/* Definitions for FRAME fpage0                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fpage0 ~
    ~{&OPEN-QUERY-br-tt-estrutura}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar br-tt-estrutura btOK btCancel ~
btHelp2 

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
DEFINE QUERY br-tt-estrutura FOR 
      tt-estrutura SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE br-tt-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS br-tt-estrutura wWindow _FREEFORM
  QUERY br-tt-estrutura NO-LOCK DISPLAY
      tt-estrutura.titulo-col   FORMAT 'x(30)'
tt-estrutura.inicial FORMAT 'x(50)' 
tt-estrutura.final   FORMAT 'x(50)'
ENABLE tt-estrutura.inicial
       tt-estrutura.final
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 89 BY 10.75
         FONT 1 ROW-HEIGHT-CHARS .62 EXPANDABLE.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     br-tt-estrutura AT ROW 1.25 COL 2
     btOK AT ROW 12.46 COL 2
     btCancel AT ROW 12.46 COL 13
     btHelp2 AT ROW 12.46 COL 80
     rtToolBar AT ROW 12.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 91.57 BY 12.96
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
         HEIGHT             = 13.04
         WIDTH              = 90.72
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
/* BROWSE-TAB br-tt-estrutura rtToolBar fpage0 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE br-tt-estrutura
/* Query rebuild information for BROWSE br-tt-estrutura
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-estrutura  NO-LOCK BY tt-estrutura.sequencia  INDEXED-REPOSITION.
     _END_FREEFORM
     _Options          = "NO-LOCK INDEXED-REPOSITION"
     _Query            is OPENED
*/  /* BROWSE br-tt-estrutura */
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


&Scoped-define BROWSE-NAME br-tt-estrutura
&Scoped-define SELF-NAME br-tt-estrutura
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL br-tt-estrutura wWindow
ON ROW-DISPLAY OF br-tt-estrutura IN FRAME fpage0
DO: 
    
  DEF VAR c-tamanho AS CHARACTER.

  IF tt-estrutura.tipo-dado = 'logical':U  THEN DO:
      ASSIGN tt-estrutura.inicial:FORMAT IN BROWSE br-tt-estrutura = 'x(03)':U.
             tt-estrutura.final:FORMAT IN BROWSE br-tt-estrutura = 'x(03)':U.
  END.
  ELSE DO:
      IF tt-estrutura.tipo-dado = 'Decimal':U OR 
         tt-estrutura.tipo-dado = 'Integer':U THEN DO:

         ASSIGN c-tamanho = 'x(':U + STRING(LENGTH(tt-estrutura.formato)) + ')':U.
         ASSIGN tt-estrutura.inicial:FORMAT IN BROWSE br-tt-estrutura = c-tamanho.
                tt-estrutura.final:FORMAT IN BROWSE br-tt-estrutura = c-tamanho. 
      END.
      ELSE DO:
          IF tt-estrutura.tipo-dado = 'date':U AND (trim(tt-estrutura.inicial) = '?' OR tt-estrutura.inicial = ? )THEN DO:
            ASSIGN tt-estrutura.inicial:FORMAT IN BROWSE br-tt-estrutura = 'x(10)'.
          END.
          IF tt-estrutura.tipo-dado = 'date':U AND (trim(tt-estrutura.final) = '?' OR tt-estrutura.final = ? ) THEN DO:
            ASSIGN tt-estrutura.final:FORMAT IN BROWSE br-tt-estrutura = 'x(10)':U.
          END.
          ELSE DO:
              ASSIGN tt-estrutura.inicial:FORMAT IN BROWSE br-tt-estrutura = tt-estrutura.formato.
                     tt-estrutura.final:FORMAT IN BROWSE br-tt-estrutura = tt-estrutura.formato.
          END.
      END.
  END.        
  ASSIGN tt-estrutura.titulo-col:FONT IN BROWSE br-tt-estrutura = 0 /* negrito */ . 
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
    RUN pi-valida-conteudo.
    IF RETURN-VALUE <> 'OK':U THEN RETURN NO-APPLY.
    ASSIGN  l-log-repeat = NO .
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/
/* {window/mainblock.i} */
&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW Method-Library ASSIGN
         HEIGHT             = 2
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */

 /* ***************************  Main Block  *************************** */
ON 'leave':U OF inicial IN BROWSE br-tt-estrutura
DO:
    DEF VAR c-aux AS CHAR.
    
    IF AVAIL tt-estrutura THEN DO:
        RUN pi-valida-conteudo-inicial.

        IF RETURN-VALUE <> 'OK':U THEN RETURN NO-APPLY.

        IF tt-estrutura.tipo-dado = 'Decimal':U  THEN DO:
           ASSIGN c-aux = tt-estrutura.atributo + '*' + 
                          trim(tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura).

           IF LOOKUP(c-aux,c-armaz-dec-ini,CHR(10)) = 0  THEN 
              ASSIGN c-armaz-dec-ini = c-armaz-dec-ini + CHR(10) + c-aux.
       END.
    END.
END.

ON 'leave':U OF final IN BROWSE br-tt-estrutura
DO:
   DEF VAR c-aux AS CHAR.
      
   IF AVAIL tt-estrutura THEN DO:
       RUN pi-valida-conteudo-final.

       IF RETURN-VALUE <> 'OK':U THEN RETURN NO-APPLY.

       IF tt-estrutura.tipo-dado = 'Decimal':U  THEN DO:
           ASSIGN c-aux = tt-estrutura.atributo + '*' + 
                          trim(tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura).

           IF LOOKUP(c-aux,c-armaz-dec-fim,CHR(10)) = 0  THEN 
              ASSIGN c-armaz-dec-fim = c-armaz-dec-fim + CHR(10) + c-aux.

       END.
   END.
END.
/*--- Seta cursor do mouse para espera ---*/
SESSION:SET-WAIT-STATE("GENERAL":U).

/*--- Evento de CLOSE padr’o para THIS-PROCEDURE ---*/
ON CLOSE OF THIS-PROCEDURE 
   RUN destroyInterface IN THIS-PROCEDURE.

/*--- Evento de CTRL-TAB padr’o para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON CTRL-TAB ANYWHERE
        RUN nextFolder IN hFolder.
&ENDIF

/*--- Evento de SHIFT-CTRL-TAB padr’o para THIS-PROCEDURE ---*/
&IF "{&Folder}":U = "YES":U &THEN
    ON SHIFT-CTRL-TAB ANYWHERE
        RUN prevFolder IN hFolder.
&ENDIF

/*--- Seta CURRENT-WINDOW como sendo a window atual ---*/
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME}
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/*--- Padr’o para janelas GUI ---*/
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

DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:    
   ASSIGN l-log-repeat = YES.
   servidor:
   repeat on quit undo servidor, retry servidor
          on stop undo servidor, retry servidor
           on error undo servidor, retry servidor
           on endkey undo servidor, retry servidor
           while l-log-repeat = YES:
           assign l-log-repeat  = no.
           RUN pi-popula-br-tt-estrutura.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-popula-br-tt-estrutura wWindow 
PROCEDURE pi-popula-br-tt-estrutura :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/  
    {&OPEN-BROWSERS-IN-QUERY-{&FRAME-NAME}}
    APPLY "ENTRY":U TO br-tt-estrutura IN FRAME  {&FRAME-NAME}.
    RETURN 'ok':U.
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

DEF VAR c-aux               AS CHARACTER.
DEF VAR i-cont              AS INTEGER.


DEF VAR v-date               AS DATE                     NO-UNDO.
DEF VAR v-logical            AS LOGICAL                  NO-UNDO.
DEF VAR v-integer            AS INT                      NO-UNDO.
DEF VAR v-decimal-aux        AS DEC DECIMALS 10          NO-UNDO.
DEF VAR v-character          AS CHAR                     NO-UNDO.
        
DEF VAR i-linha AS INTEGER.

DO ON ERROR   UNDO, LEAVE
   ON END-KEY UNDO, LEAVE:
DO TRANSACTION:
    FOR EACH b-tt-estrutura:        
             IF  b-tt-estrutura.tipo-dado = "INTEGER":U THEN DO:   
                IF LENGTH(b-tt-estrutura.inicial) > 9 THEN
                    ASSIGN v-integer = 999999999 NO-ERROR.
                ELSE
                    ASSIGN v-integer = INT(b-tt-estrutura.inicial) NO-ERROR.
                IF ERROR-STATUS:ERROR
                THEN DO:
                    /* Erro ao salvar valores do tipo Inteiro */
                    run utp/ut-msgs.p (input "show":U,
                                       input 27796,
                                       input b-tt-estrutura.atributo).    
                    ASSIGN v-integer = 0.
                    ASSIGN l-log-repeat = YES.
                    RETURN 'nok':U.
                END.
                ASSIGN  b-tt-estrutura.inicial = string(v-integer).

                IF LENGTH(b-tt-estrutura.final) > 9 THEN
                    ASSIGN v-integer = 999999999 NO-ERROR.
                ELSE 
                    ASSIGN v-integer = INT(b-tt-estrutura.final) NO-ERROR.
                IF ERROR-STATUS:ERROR
                THEN DO:
                   /* Erro ao salvar valores do tipo Inteiro */
                    run utp/ut-msgs.p (input "show":U,
                                       input 27796,
                                       input b-tt-estrutura.atributo).    
                    ASSIGN v-integer = 0.
                    ASSIGN l-log-repeat = YES.
                    RETURN 'nok':U.
                END.
                ASSIGN  b-tt-estrutura.final = string(v-integer).
              END.
    
              IF  b-tt-estrutura.tipo-dado = "DECIMAL":U THEN DO:

                 ASSIGN i-cont = 1.
                 DO i-cont = 1 TO NUM-ENTRIES(c-armaz-dec-ini,CHR(10)):
                     IF TRIM(entry(1,ENTRY(i-cont,c-armaz-dec-ini,CHR(10)),'*':U)) = trim(b-tt-estrutura.atributo) THEN DO:
                         ASSIGN b-tt-estrutura.inicial = entry(2,ENTRY(i-cont,c-armaz-dec-ini,CHR(10)),'*':U).
                     END.
                 END.
                 ASSIGN v-decimal-aux = DEC(b-tt-estrutura.inicial) NO-ERROR.
                 IF ERROR-STATUS:ERROR
                 THEN DO:
                      /* Erro ao salvar valores do tipo Decimal */
                      run utp/ut-msgs.p (input "show":U,
                                         input 27797,
                                         input b-tt-estrutura.atributo).    
                       ASSIGN v-decimal-aux = 0.
                       ASSIGN l-log-repeat = YES.
                       RETURN 'nok':U.
                 END.
                 ASSIGN  b-tt-estrutura.inicial = string(v-decimal-aux).

                 ASSIGN i-cont = 1.
                 DO i-cont = 1 TO NUM-ENTRIES(c-armaz-dec-fim,CHR(10)):
                     IF TRIM(entry(1,ENTRY(i-cont,c-armaz-dec-fim,CHR(10)),'*')) = trim(b-tt-estrutura.atributo) THEN DO:
                         ASSIGN b-tt-estrutura.final = entry(2,ENTRY(i-cont,c-armaz-dec-fim,CHR(10)),'*').
                     END.
                 END.
                 ASSIGN v-decimal-aux = DEC(b-tt-estrutura.final) NO-ERROR.
                 IF ERROR-STATUS:ERROR
                 THEN DO:
                       /* Erro ao salvar valores do tipo Decimal */
                       run utp/ut-msgs.p (input "show":U,
                                          input 27797,
                                          input b-tt-estrutura.atributo).
                       ASSIGN v-decimal-aux = 0.
                       ASSIGN l-log-repeat = YES.
                       RETURN 'nok':U.
                 END.
                 ASSIGN b-tt-estrutura.final = STRING(v-decimal-aux).
               END.
    
               IF  b-tt-estrutura.tipo-dado = "LOGICAL":U THEN DO:
                    ASSIGN v-logical = IF b-tt-estrutura.inicial       = "yes":U 
                                     OR b-tt-estrutura.inicial          = "SIM":U 
                                     OR INDEX(b-tt-estrutura.inicial,"1") > 0
                                     THEN YES 
                                     ELSE
                                    IF b-tt-estrutura.inicial = "no":U 
                                    OR b-tt-estrutura.inicial = "NÆo":U
                                    OR b-tt-estrutura.inicial = "nao":U 
                                    OR INDEX(b-tt-estrutura.inicial,"0":U) > 0
                                    THEN NO 
                                    ELSE    
                                    IF b-tt-estrutura.inicial <> "" 
                                    THEN YES 
                                    ELSE NO 
                                    NO-ERROR.
        
                     IF ERROR-STATUS:ERROR
                     THEN DO:
                        /* Erro ao salvar valores do tipo Logical */
                        run utp/ut-msgs.p (input "show":U,
                                           input 27798,
                                           input b-tt-estrutura.atributo).
                        ASSIGN v-logical = NO.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok'.
                     END.
                     ASSIGN v-logical = IF b-tt-estrutura.final       = "yes":U 
                                     OR b-tt-estrutura.final          = "SIM":U 
                                     OR INDEX(b-tt-estrutura.final,"1":U) > 0
                                     THEN YES 
                                     ELSE
                                    IF b-tt-estrutura.final = "no":U 
                                    OR b-tt-estrutura.final = "NÆo":U
                                    OR b-tt-estrutura.final = "nao":U 
                                    OR INDEX(b-tt-estrutura.final,"0":U) > 0
                                    THEN NO 
                                    ELSE    
                                    IF b-tt-estrutura.final <> "" 
                                    THEN YES 
                                    ELSE NO 
                                    NO-ERROR.
    
                     IF ERROR-STATUS:ERROR
                     THEN DO:
                        /* Erro ao salvar valores do tipo Logical */
                        run utp/ut-msgs.p (input "show":U,
                                           input 27798,
                                           input b-tt-estrutura.atributo).
                        ASSIGN v-logical = NO.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok':U.
                     END.
                     
               END.
    
               IF  b-tt-estrutura.tipo-dado = "CHARACTER":U THEN DO:   
                  ASSIGN v-character = b-tt-estrutura.inicial NO-ERROR.
                  IF ERROR-STATUS:ERROR
                  THEN DO:
                      /* Erro ao salvar valores do tipo Character */
                      run utp/ut-msgs.p (input "show":U,
                                         input 27799,
                                         input b-tt-estrutura.atributo).
                      ASSIGN v-character = "".
                      ASSIGN l-log-repeat = YES.
                      RETURN 'nok':U.
                  END.
                  ASSIGN v-character = b-tt-estrutura.final NO-ERROR.
                  IF ERROR-STATUS:ERROR
                  THEN DO:
                     /* Erro ao salvar valores do tipo Character */
                     run utp/ut-msgs.p (input "show":U,
                                        input 27799,
                                        input b-tt-estrutura.atributo).
                     ASSIGN v-character = "".
                     ASSIGN l-log-repeat = YES.
                     RETURN 'nok':U.
                   END.
               END.
    
               IF  b-tt-estrutura.tipo-dado = "DATE":U THEN DO:

                    ASSIGN v-date = date(b-tt-estrutura.inicial) NO-ERROR.

                    IF  ERROR-STATUS:ERROR
                    THEN DO:
                         /* Erro ao salvar valores do tipo Date */
                        run utp/ut-msgs.p (input "show":U,
                                           input 27800,
                                           input b-tt-estrutura.atributo).
                        ASSIGN v-date = ?.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok':U.
                    END.

                    ASSIGN tt-estrutura.inicial = REPLACE(tt-estrutura.inicial, '/','').
                                       
                    ASSIGN v-date = date(b-tt-estrutura.final) NO-ERROR.
                    IF  ERROR-STATUS:ERROR
                    THEN DO:
                        /* Erro ao salvar valores do tipo Date */
                        run utp/ut-msgs.p (input "show":U,
                                           input 27800,
                                           input b-tt-estrutura.atributo).
                        ASSIGN v-date = ?.
                        ASSIGN l-log-repeat = YES.
                        RETURN 'nok':U.
                    END.

                    ASSIGN tt-estrutura.final = REPLACE(tt-estrutura.final, '/':U,'').

              END.
    END.
END.
END.
ASSIGN l-log-repeat = NO.
RETURN 'ok':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conteudo-final wWindow 
PROCEDURE pi-valida-conteudo-final :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN ERROR-STATUS:ERROR = NO.
IF tt-estrutura.tipo-dado = "INTEGER":U THEN DO:  
    IF LENGTH(tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura) > 9 THEN
        ASSIGN v-integer = 999999999 NO-ERROR.
    ELSE 
        ASSIGN v-integer = INT(tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura) NO-ERROR.
    IF ERROR-STATUS:ERROR
    THEN DO:
        /* Erro ao salvar valores do tipo Inteiro*/
        RUN utp/ut-msgs.p (input "show":U,
                           input 27796,
                           input tt-estrutura.atributo).
        ASSIGN v-integer = 0.
        ASSIGN l-log-repeat = YES.
        RETURN NO-APPLY.
    END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "DECIMAL":U THEN DO:  
     ASSIGN v-decimal-aux = DEC(tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura) NO-ERROR.
     IF ERROR-STATUS:ERROR
     THEN DO:
        /* Erro ao salvar valores do tipo Decimal */
        RUN utp/ut-msgs.p (input "show":U,
                           input 27797,
                           input tt-estrutura.atributo).
        ASSIGN l-log-repeat = YES.
        ASSIGN v-decimal-aux = 0.
        RETURN NO-APPLY.
     END.
END.
IF  tt-estrutura.tipo-dado = "Logical":U THEN DO:  
    IF tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'sim' AND
       tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'yes' AND
       tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'no' AND
       tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'NÆo' AND
       tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'Nao' THEN
       ASSIGN ERROR-STATUS:ERROR = YES.
    
     IF ERROR-STATUS:ERROR
     THEN DO:
        /* Erro ao salvar valores do tipo Logical */
        RUN utp/ut-msgs.p (input "show":U,
                           input 27798,
                           input tt-estrutura.atributo). 
        ASSIGN v-logical = NO.
        ASSIGN l-log-repeat = YES.
        RETURN NO-APPLY.           
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "character":U THEN DO:  
     ASSIGN v-character = tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura NO-ERROR.
     IF ERROR-STATUS:ERROR
     THEN DO:
         /* Erro ao salvar valores do tipo Character */
         RUN utp/ut-msgs.p (input "show":U,
                            input 27799,
                            input tt-estrutura.atributo).
         ASSIGN v-character = '' .
         ASSIGN l-log-repeat = YES.
         RETURN NO-APPLY.
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "date":U THEN DO:  
     ASSIGN v-date = date(tt-estrutura.final:SCREEN-VALUE IN BROWSE br-tt-estrutura) NO-ERROR.
     IF ERROR-STATUS:ERROR /* OR v-date = ? */
     THEN DO:
        /* Erro ao salvar valores do tipo Date */
        RUN utp/ut-msgs.p (input "show":U,
                           input 27800,
                           input tt-estrutura.atributo).
        ASSIGN v-date = ?.
        ASSIGN l-log-repeat = YES.
        RETURN NO-APPLY.
     END.
END.
RETURN 'ok':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-conteudo-inicial wWindow 
PROCEDURE pi-valida-conteudo-inicial :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "INTEGER":U THEN DO:  
    IF LENGTH(tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura) > 9 THEN
        ASSIGN v-integer = 999999999 NO-ERROR.
    ELSE
        ASSIGN v-integer = INT(tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura) NO-ERROR.
    IF ERROR-STATUS:ERROR 
    THEN DO:
        /* Erro ao salvar valores do tipo Inteiro*/
        RUN utp/ut-msgs.p (input "show":U,
                           input 27796,
                           input tt-estrutura.atributo).
        ASSIGN v-integer = 0.
        ASSIGN l-log-repeat = YES.
        RETURN NO-APPLY.
    END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "DECIMAL":U THEN DO:  
     ASSIGN v-decimal-aux = DEC(tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura) NO-ERROR.
     IF ERROR-STATUS:ERROR
     THEN DO:
         /* Erro ao salvar valores do tipo Decimal */
         RUN utp/ut-msgs.p (input "show":U,
                            input 27797,
                            input tt-estrutura.atributo).
         ASSIGN v-decimal-aux = 0.
         ASSIGN l-log-repeat = YES.
         RETURN NO-APPLY.
     END.
END.
IF  tt-estrutura.tipo-dado = "Logical":U THEN DO:  
    IF tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'sim' AND
       tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'yes' AND
       tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'no' AND
       tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'NÆo' AND
       tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura <> 'Nao' THEN
       ASSIGN ERROR-STATUS:ERROR = YES.
    
     IF ERROR-STATUS:ERROR
     THEN DO:
         /* Erro ao salvar valores do tipo Logical */
         RUN utp/ut-msgs.p (input "show":U,
                            input 27798,
                            input tt-estrutura.atributo).
         ASSIGN v-logical = NO.
         ASSIGN l-log-repeat = YES.
         RETURN NO-APPLY.          
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "character":U THEN DO:  
     ASSIGN v-character = tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura NO-ERROR.
     IF ERROR-STATUS:ERROR
     THEN DO:
         /* Erro ao salvar valores do tipo Character */
         RUN utp/ut-msgs.p (input "show":U,
                            input 27799,
                            input tt-estrutura.atributo).
         ASSIGN v-character = '' .
         ASSIGN l-log-repeat = YES.
         RETURN NO-APPLY.
     END.
END.
ASSIGN ERROR-STATUS:ERROR = NO.
IF  tt-estrutura.tipo-dado = "date":U THEN DO:  
     ASSIGN v-date = date(tt-estrutura.inicial:SCREEN-VALUE IN BROWSE br-tt-estrutura) NO-ERROR.
     IF ERROR-STATUS:ERROR /* or v-date = ? */
     THEN DO:
         /* Erro ao salvar valores do tipo Date */
         RUN utp/ut-msgs.p (input "show":U,
                            input 27800,
                            input tt-estrutura.atributo).
         ASSIGN v-date = ?.
         ASSIGN l-log-repeat = YES.
         RETURN NO-APPLY.
     END.
END.
RETURN 'ok':U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

