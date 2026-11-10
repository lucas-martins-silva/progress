&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid
       field rownum as int
       
       .
DEFINE TEMP-TABLE tt-emitente1 NO-UNDO LIKE emitente
       field r-rowid as rowid
       field rownum as int
       
       .


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z10AD098 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z10AD098 MUT}
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
{cdp/cdcfgmat.i} /* Definicao de pre-processadores - Magnus ou EMS */
{cdp/cdcfgdis.i} /* Include uso de pre-processadores para modulo BN*/
/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program      Z10AD098
&GLOBAL-DEFINE Version      2.00.00.010
&GLOBAL-DEFINE DBOVersion   1.1

&GLOBAL-DEFINE Folder       YES
&GLOBAL-DEFINE InitialPage  1
&GLOBAL-DEFINE FramesHandle STRING(FRAME fPage1:HANDLE) + ",":U + ~
                            STRING(FRAME fPage2:HANDLE)
&GLOBAL-DEFINE FolderLabels C¢digo, Nome Abrev

&GLOBAL-DEFINE Range             YES
&GLOBAL-DEFINE FieldsRangePage1  mgadm.emitente.cod-emitente
&GLOBAL-DEFINE FieldsAnyKeyPage1 No
&GLOBAL-DEFINE FieldsRangePage2  mgadm.emitente.nome-abrev
&GLOBAL-DEFINE FieldsAnyKeyPage2 No

&GLOBAL-DEFINE ttTable1     tt-emitente
&GLOBAL-DEFINE hDBOTable1   h-boad098
&GLOBAL-DEFINE DBOTable1    emitente

&GLOBAL-DEFINE ttTable2     tt-emitente1
&GLOBAL-DEFINE hDBOTable2   h-boad0981
&GLOBAL-DEFINE DBOTable2    emitente

&GLOBAL-DEFINE page1Browse  brTable1
&GLOBAL-DEFINE page2Browse  brTable2

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE iNumPagina      AS INTEGER NO-UNDO.

/** Bloqueio de fornecedores - 205 **/
&if defined (bf_mat_bloqueio_fornec) &then

    /* Botao parametros */
    def var l-cancelado         as log  initial yes   no-undo.
    def var l-ativos            as log  initial yes   no-undo.
    def var l-restr-compr       as log  initial yes   no-undo.     
    def var l-restr-compr-receb as log  initial yes   no-undo. 
    def var l-inativos          as log  initial yes   no-undo.            
    def var dt-data-restricao   as date initial today no-undo.    
    def var h-boin682           as handle             no-undo.
    def var l-modulo-cc         as log  initial yes   no-undo.
    def var l-modulo-cn         as log  initial yes   no-undo.
    def var l-modulo-re         as log  initial yes   no-undo.

&endif

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-emitente tt-emitente1

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-emitente.cod-emitente ~
tt-emitente.nome-abrev tt-emitente.nome-emit tt-emitente.pais ~
tt-emitente.char-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-emitente NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-emitente NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-emitente
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-emitente


/* Definitions for BROWSE brtable2                                      */
&Scoped-define FIELDS-IN-QUERY-brtable2 tt-emitente1.nome-abrev ~
tt-emitente1.cod-emitente tt-emitente1.nome-emit tt-emitente1.pais ~
tt-emitente1.char-1 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brtable2 
&Scoped-define QUERY-STRING-brtable2 FOR EACH tt-emitente1 NO-LOCK ~
    BY tt-emitente1.nome-abrev
&Scoped-define OPEN-QUERY-brtable2 OPEN QUERY brtable2 FOR EACH tt-emitente1 NO-LOCK ~
    BY tt-emitente1.nome-abrev.
&Scoped-define TABLES-IN-QUERY-brtable2 tt-emitente1
&Scoped-define FIRST-TABLE-IN-QUERY-brtable2 tt-emitente1


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brtable2}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btImplant1 
     LABEL "&Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btParam1 
     LABEL "&Parƒmetros" 
     SIZE 10 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "&Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btParam2 
     LABEL "&Parƒmetros" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-emitente SCROLLING.

DEFINE QUERY brtable2 FOR 
      tt-emitente1 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-emitente.cod-emitente FORMAT ">>>>>>>>9":U
      tt-emitente.nome-abrev COLUMN-LABEL "Nome Abrev" FORMAT "X(12)":U
      tt-emitente.nome-emit FORMAT "X(40)":U
      tt-emitente.pais FORMAT "X(20)":U
      tt-emitente.char-1 COLUMN-LABEL "Situa‡Æo" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8
         FONT 2.

DEFINE BROWSE brtable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brtable2 wZoom _STRUCTURED
  QUERY brtable2 NO-LOCK DISPLAY
      tt-emitente1.nome-abrev FORMAT "X(12)":U
      tt-emitente1.cod-emitente FORMAT ">>>>>>>>9":U
      tt-emitente1.nome-emit FORMAT "X(40)":U
      tt-emitente1.pais FORMAT "X(20)":U
      tt-emitente1.char-1 COLUMN-LABEL "Situa‡Æo" FORMAT "x(40)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 8
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.21 COL 2
     btCancel AT ROW 14.21 COL 13
     btHelp AT ROW 14.21 COL 80
     rtToolBar AT ROW 14 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 14.88
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 10.33 COL 2
     btParam1 AT ROW 10.33 COL 12 HELP
          "Mostra Cliente/Fornecedor Conforme Parƒmetros Selecionados"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 10.63
         FONT 1.

DEFINE FRAME fPage2
     brtable2 AT ROW 2.33 COL 2
     btImplant2 AT ROW 10.33 COL 2
     btParam2 AT ROW 10.33 COL 12 HELP
          "Mostra Cliente/Fornecedor Conforme Parƒmetros Selecionados"
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 10.63
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-emitente T "?" NO-UNDO mgadm emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field rownum as int
          
          
      END-FIELDS.
      TABLE: tt-emitente1 T "?" NO-UNDO mgadm emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          field rownum as int
          
          
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 14.88
         WIDTH              = 90
         MAX-HEIGHT         = 14.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 14.88
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR BUTTON btParam1 IN FRAME fPage1
   NO-ENABLE                                                            */
ASSIGN 
       btParam1:HIDDEN IN FRAME fPage1           = TRUE.

/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brtable2 1 fPage2 */
/* SETTINGS FOR BUTTON btParam2 IN FRAME fPage2
   NO-ENABLE                                                            */
ASSIGN 
       btParam2:HIDDEN IN FRAME fPage2           = TRUE.

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-emitente"
     _Options          = "NO-LOCK"
     _FldNameList[1]   = Temp-Tables.tt-emitente.cod-emitente
     _FldNameList[2]   > Temp-Tables.tt-emitente.nome-abrev
"tt-emitente.nome-abrev" "Nome Abrev" ? "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.tt-emitente.nome-emit
     _FldNameList[4]   = Temp-Tables.tt-emitente.pais
     _FldNameList[5]   > Temp-Tables.tt-emitente.char-1
"tt-emitente.char-1" "Situa‡Æo" "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brtable2
/* Query rebuild information for BROWSE brtable2
     _TblList          = "Temp-Tables.tt-emitente1"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente1.nome-abrev|yes"
     _FldNameList[1]   = Temp-Tables.tt-emitente1.nome-abrev
     _FldNameList[2]   = Temp-Tables.tt-emitente1.cod-emitente
     _FldNameList[3]   = Temp-Tables.tt-emitente1.nome-emit
     _FldNameList[4]   = Temp-Tables.tt-emitente1.pais
     _FldNameList[5]   > Temp-Tables.tt-emitente1.char-1
"tt-emitente1.char-1" "Situa‡Æo" "x(40)" "character" ? ? ? ? ? ? no ? no no ? yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brtable2 */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brTable1 wZoom
ON ROW-DISPLAY OF brTable1 IN FRAME fPage1
DO:
   RUN utp/ut-liter.p (INPUT replace(tt-emitente.char-1," ","_"), INPUT "*", INPUT "").
   ASSIGN tt-emitente.char-1:SCREEN-VALUE IN BROWSE brtable1 = TRIM(RETURN-VALUE).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brtable2
&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME brtable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL brtable2 wZoom
ON ROW-DISPLAY OF brtable2 IN FRAME fPage2
DO:
   
   RUN utp/ut-liter.p (INPUT replace(tt-emitente1.char-1," ","_"), INPUT "*", INPUT "").
   ASSIGN tt-emitente1.char-1:SCREEN-VALUE IN BROWSE brtable2 = TRIM(RETURN-VALUE).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
    RUN cdp/cd0401.w.
    RUN openQueries.    
    
/*    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
 *                     &PageNumber="1"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    RUN cdp/cd0401.w.
    RUN openQueries.
    
/*    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
 *                      &PageNumber="1"}*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO: 
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    
    RETURN RETURN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btParam1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam1 wZoom
ON CHOOSE OF btParam1 IN FRAME fPage1 /* Parƒmetros */
DO:
    /** Bloqueio de fornecedores - 205 **/
    &if defined (bf_mat_bloqueio_fornec) &then
    
        run cdp/cd9999.w(input-output l-ativos,             
                         input-output l-restr-compr,         
                         input-output l-restr-compr-receb,          
                         input-output l-inativos,            
                         input-output dt-data-restricao,                      
                         output       l-cancelado).  
    
          
        if  l-cancelado = no then do:
            if valid-handle({&hDBOTable1}) then do:
                run atualizaParamcd9999 in {&hDBOTable1} (input l-ativos,            
                                                          input l-restr-compr,       
                                                          input l-restr-compr-receb, 
                                                          input l-inativos,           
                                                          input dt-data-restricao).   
                run setConstraints(1).
            end.
        end.

    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btParam2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btParam2 wZoom
ON CHOOSE OF btParam2 IN FRAME fPage2 /* Parƒmetros */
DO:
    /** Bloqueio de fornecedores - 205 **/
    &if defined (bf_mat_bloqueio_fornec) &then
    
        run cdp/cd9999.w(input-output l-ativos,              
                         input-output l-restr-compr,         
                         input-output l-restr-compr-receb,          
                         input-output l-inativos,            
                         input-output dt-data-restricao,                      
                         output       l-cancelado).          
    
        if  l-cancelado = no then do:
            if valid-handle({&hDBOTable2}) then do:
                run atualizaParamcd9999 in {&hDBOTable2} (input l-ativos,            
                                                          input l-restr-compr,       
                                                          input l-restr-compr-receb, 
                                                          input l-inativos,           
                                                          input dt-data-restricao).  
                run setConstraints(2).
            end.
        end.

    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wZoom 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /** Bloqueio de fornecedores - 205 **/
    &if defined (bf_mat_bloqueio_fornec) &then
    
        if valid-handle (h-boin682) then do:
            delete procedure h-boin682.
                             h-boin682 = ?.
        end.

    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    /** Bloqueio de fornecedores - 205 **/
    &if defined (bf_mat_bloqueio_fornec) &then
    
        if valid-handle (h-boin682) then do:
            run openQueryStatic in h-boin682 (input "Main":U) no-error.
            run findFirst       in h-boin682.
            run getLogField     in h-boin682 (input "modulo-cc":U, output l-modulo-cc).
            run getLogField     in h-boin682 (input "modulo-cn":U, output l-modulo-cn).
            run getLogField     in h-boin682 (input "modulo-re":U, output l-modulo-re).
        end.

        if  l-modulo-re = yes
        or  l-modulo-cc = yes
        or  l-modulo-cn = yes then
    
            assign btParam1:hidden in frame fpage1    = no
                   btParam2:hidden in frame fpage2    = no
                   btParam1:sensitive in frame fpage1 = yes
                   btParam2:sensitive in frame fpage2 = yes.
        else

            assign tt-emitente.char-1:label in browse brTable1  = "":U
                   tt-emitente1.char-1:label in browse brTable2 = "":U .
    
    &else
    
        assign tt-emitente.char-1:label in browse brTable1  = "":U
               tt-emitente1.char-1:label in browse brTable2 = "":U .

    &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*----- -------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
       RUN adbo/boad098q01.p persistent set h-boad098.
       
       RUN setConstraint19 IN {&hDBOTable1}
                        (INPUT 0,
                         INPUT 999999999).

    END.

    IF NOT VALID-HANDLE({&hDBOTable2}) THEN DO:
       RUN adbo/boad098q01.p persistent set h-boad0981.
       
       RUN setConstraint18 IN {&hDBOTable2}
                        (INPUT 0,
                         INPUT 999999999,
                         INPUT "":U,
                         INPUT "ZZZZZZZZZZZZ").

    END.    

    /** Bloqueio de fornecedores - 205 **/
    &if defined (bf_mat_bloqueio_fornec) &then
    
        if not valid-handle(h-boin682) then
            run inbo/boin682.p persistent set h-boin682. 
        
    &endif

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
     /*--- seta o cursor do mouse para espera ---*/
     session:set-wait-state("general":U).

     {zoom/openqueries.i &Query="C¢digo"
                        &PageNumber="1"
                        &QueryNumber="19"}
                        
     {zoom/openqueries.i &Query="Nome-abrev"
                        &PageNumber="2"
                        &QueryNumber="18"}                        
                        
     /*--- seta o cursor do mouse para normal ---*/
     session:set-wait-state("":U).                   

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).                
        END CASE.
    END.    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-emitente).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).                
        END CASE.
    END.    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN
        &IF DEFINED(DBOVersion) <> 0 &THEN
            if valid-handle({&hDBOTable1}) then 
                /*--- Seta Constraints para o DBOTable1 ---*/
                RUN setConstraint19 IN {&hDBOTable1}(INPUT fnIniRangeIntPage(input 1, input 1),
                                                     INPUT fnEndRangeIntPage(input 1, input 1)).
        &ENDIF
       WHEN 2 THEN 
       &IF DEFINED(DBOVersion) <> 0 &THEN 
            if valid-handle({&hDBOTable2}) then 
                /*--- Seta Constraints para o DBOTable1 ---*/
                RUN setConstraint18 IN {&hDBOTable2}
                            (input 0,
                             input 999999999,
                             INPUT fnIniRangeCharPage(input 2, input 1),
                             INPUT fnEndRangeCharPage(input 2, input 1)).
       &ENDIF                     
    END CASE.
    
    /*--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

