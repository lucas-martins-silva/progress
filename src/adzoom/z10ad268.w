&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-transporte NO-UNDO LIKE transporte
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-transporte2 NO-UNDO LIKE transporte
       field r-rowid as rowid.


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z10AD268 2.00.00.005}  /*** 010005 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z10AD268 MUT}
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
&GLOBAL-DEFINE Program      Z10AD268
&GLOBAL-DEFINE Version      2.00.00.005
&GLOBAL-DEFINE DBOVersion   1.1

&GLOBAL-DEFINE Folder       YES
&GLOBAL-DEFINE InitialPage  1

&GLOBAL-DEFINE FolderLabels Codigo ,Nome Abrev

&GLOBAL-DEFINE Range        YES
&GLOBAL-DEFINE FieldNames   mgadm.transporte.cod-transp,mgadm.transporte.nome-abrev

&GLOBAL-DEFINE ttTable1     tt-transporte
&GLOBAL-DEFINE hDBOTable1   h-boad268
&GLOBAL-DEFINE DBOTable1    transporte

&GLOBAL-DEFINE ttTable2     tt-transporte2
&GLOBAL-DEFINE hDBOTable2   h-boad2682
&GLOBAL-DEFINE DBOTable2    transporte

&GLOBAL-DEFINE page1Browse  brTable1    
&GLOBAL-DEFINE page2Browse  brTable2    

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

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
&Scoped-define INTERNAL-TABLES tt-transporte tt-transporte2

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-transporte.cod-transp ~
tt-transporte.nome-abrev tt-transporte.nome tt-transporte.cgc ~
tt-transporte.via-transp tt-transporte.estado tt-transporte.ins-estadual ~
tt-transporte.pais tt-transporte.telefone tt-transporte.zip-code 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-transporte NO-LOCK
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-transporte NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-transporte
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-transporte


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-transporte2.cod-transp ~
tt-transporte2.nome-abrev tt-transporte2.nome tt-transporte2.cgc ~
tt-transporte2.via-transp tt-transporte2.estado tt-transporte2.ins-estadual ~
tt-transporte2.pais tt-transporte2.telefone tt-transporte2.zip-code 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-transporte2 NO-LOCK ~
    BY tt-transporte2.nome-abrev
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-transporte2 NO-LOCK ~
    BY tt-transporte2.nome-abrev.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-transporte2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-transporte2


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

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
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-transporte SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-transporte2 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 DISPLAY
      tt-transporte.cod-transp FORMAT ">>,>>9":U
      tt-transporte.nome-abrev FORMAT "X(12)":U
      tt-transporte.nome FORMAT "X(40)":U
      tt-transporte.cgc FORMAT "x(19)":U
      tt-transporte.via-transp FORMAT "9":U
      tt-transporte.estado FORMAT "x(04)":U
      tt-transporte.ins-estadual FORMAT "X(19)":U
      tt-transporte.pais FORMAT "X(20)":U
      tt-transporte.telefone FORMAT "x(15)":U
      tt-transporte.zip-code FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 DISPLAY
      tt-transporte2.cod-transp FORMAT ">>,>>9":U
      tt-transporte2.nome-abrev FORMAT "X(12)":U
      tt-transporte2.nome FORMAT "X(40)":U
      tt-transporte2.cgc FORMAT "x(19)":U
      tt-transporte2.via-transp FORMAT "9":U
      tt-transporte2.estado FORMAT "x(04)":U
      tt-transporte2.ins-estadual FORMAT "X(19)":U
      tt-transporte2.pais FORMAT "X(20)":U
      tt-transporte2.telefone FORMAT "x(15)":U
      tt-transporte2.zip-code FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.5
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 12.83 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.13
         FONT 1.

DEFINE FRAME fPage2
     brTable2 AT ROW 2.33 COL 2
     btImplant2 AT ROW 12.83 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.13
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-transporte T "?" NO-UNDO mgadm transporte
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-transporte2 T "?" NO-UNDO mgadm transporte
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
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
         HEIGHT             = 17
         WIDTH              = 90
         MAX-HEIGHT         = 28.96
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.96
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
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 1 fPage2 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-transporte"
     _FldNameList[1]   = Temp-Tables.tt-transporte.cod-transp
     _FldNameList[2]   = Temp-Tables.tt-transporte.nome-abrev
     _FldNameList[3]   = Temp-Tables.tt-transporte.nome
     _FldNameList[4]   = Temp-Tables.tt-transporte.cgc
     _FldNameList[5]   = Temp-Tables.tt-transporte.via-transp
     _FldNameList[6]   = Temp-Tables.tt-transporte.estado
     _FldNameList[7]   = Temp-Tables.tt-transporte.ins-estadual
     _FldNameList[8]   = Temp-Tables.tt-transporte.pais
     _FldNameList[9]   = Temp-Tables.tt-transporte.telefone
     _FldNameList[10]   = Temp-Tables.tt-transporte.zip-code
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-transporte2"
     _OrdList          = "Temp-Tables.tt-transporte2.nome-abrev|yes"
     _FldNameList[1]   = Temp-Tables.tt-transporte2.cod-transp
     _FldNameList[2]   = Temp-Tables.tt-transporte2.nome-abrev
     _FldNameList[3]   = Temp-Tables.tt-transporte2.nome
     _FldNameList[4]   = Temp-Tables.tt-transporte2.cgc
     _FldNameList[5]   = Temp-Tables.tt-transporte2.via-transp
     _FldNameList[6]   = Temp-Tables.tt-transporte2.estado
     _FldNameList[7]   = Temp-Tables.tt-transporte2.ins-estadual
     _FldNameList[8]   = Temp-Tables.tt-transporte2.pais
     _FldNameList[9]   = Temp-Tables.tt-transporte2.telefone
     _FldNameList[10]   = Temp-Tables.tt-transporte2.zip-code
     _Query            is OPENED
*/  /* BROWSE brTable2 */
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
    DEFINE VARIABLE hProg AS HANDLE     NO-UNDO.
 
    run cdp/cd0402.w persistent set hProg.
     
    run dispatch in hProg (input 'initialize').
     
    wait-for close of hProg.
     IF VALID-HANDLE(hProg) THEN
        delete procedure hProg.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
  DEFINE VARIABLE hProg AS HANDLE     NO-UNDO.
 
    run cdp/cd0402.w persistent set hProg.
     
    run dispatch in hProg (input 'initialize').
     
    wait-for close of hProg.
    IF VALID-HANDLE(hProg) THEN
        delete procedure hProg.
      
  
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
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
  
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
       RUN adbo/boad268.p persistent set h-boad268.
       RUN setConstraint1 in h-boad268 (input "0",
                                        input "999999",
                                        input "",
                                        input "ZZZZZZZZ").
    END.
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) THEN DO:
       RUN adbo/boad268.p persistent set h-boad2682.
       RUN setConstraint1 in h-boad2682 (input "0",
                                        input "999999",
                                        input "",
                                        input "ZZZZZZZZ").
    END.
    
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
    
    {zoom/openqueries.i &Query="Cod-Transp"
                        &PageNumber="1"
                        &QueryNumber="1"}
    
    {zoom/openqueries.i &Query="Nome-abrev"
                        &PageNumber="2"
                        &QueryNumber="2"}
    
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
            WHEN "cod-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-transp).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cgc).
            WHEN "via-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.via-transp).
            WHEN "estado":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.estado).
            WHEN "ins-estadual":U THEN
                ASSIGN pcFieldValue = STRING({&tttable1}.ins-estadual).
            WHEN "pais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.pais).
            WHEN "telefone":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.telefone).
            WHEN "zip-code":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.zip-code).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "cod-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-transp).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cgc).
            WHEN "via-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.via-transp).
            WHEN "estado":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.estado).
            WHEN "ins-estadual":U THEN
                ASSIGN pcFieldValue = STRING({&tttable2}.ins-estadual).
            WHEN "pais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.pais).
            WHEN "telefone":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.telefone).
            WHEN "zip-code":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.zip-code).
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
            /*--- Seta Constraints para o DBOTable1 ---*/
            RUN setConstraint1 IN {&hDBOTable1}
                        (INPUT fnIniRangeChar(INPUT 1),
                         INPUT fnEndRangeChar(INPUT 1),
                         Input "",
                         INPUT "ZZZZZZZZZ").
        &ELSE
            /*--- Seta Constraints para o DBOTable2 ---*/
            RUN setConstraintCustNum IN {&hDBOTable2} 
                        (INPUT fnIniRangeInt(INPUT 1),
                         INPUT fnEndRangeInt(INPUT 1)).
        &ENDIF
        WHEN 2 THEN
        &IF DEFINED(DBOVersion) <> 0 &THEN
            /*--- Seta Constraints para o DBOTable2 ---*/
            RUN setConstraint1 IN {&hDBOTable2}
                        (INPUT "0",
                         INPUT "999999",
                         INPUT fnIniRangeChar(INPUT 2),
                         INPUT fnEndRangeChar(INPUT 2)).
        &ELSE
            /*--- Seta Constraints para o DBOTable1 ---*/
            RUN setConstraintCustNum IN {&hDBOTable1} 
                        (INPUT fnIniRangeInt(INPUT 1),
                         INPUT fnEndRangeInt(INPUT 1)).
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

