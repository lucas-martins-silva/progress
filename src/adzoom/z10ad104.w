&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-espec-ap NO-UNDO LIKE mgadm.espec-ap
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
{include/i-prgvrs.i Z10AD104 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z10AD104 MUT}
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
&GLOBAL-DEFINE Program      Z10AD104
&GLOBAL-DEFINE Version      2.00.00.003
&GLOBAL-DEFINE DBOVersion   1.1

&GLOBAL-DEFINE Folder       YES
&GLOBAL-DEFINE InitialPage  1
&GLOBAL-DEFINE FramesHandle STRING(FRAME fPage1:HANDLE)
&GLOBAL-DEFINE FolderLabels Espec Ap

&GLOBAL-DEFINE Range        NO

&GLOBAL-DEFINE ttTable1     tt-espec-ap
&GLOBAL-DEFINE hDBOTable1   h-boad104
&GLOBAL-DEFINE DBOTable1    espec-ap

&GLOBAL-DEFINE page1Browse  brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-espec-ap

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-espec-ap.cod-esp ~
tt-espec-ap.descricao tt-espec-ap.tipo tt-espec-ap.contabiliza 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define FIELD-PAIRS-IN-QUERY-brTable1
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-espec-ap NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-espec-ap
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-espec-ap


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

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

DEFINE BUTTON btConfirma 
     IMAGE-UP FILE "image\im-cq":U
     IMAGE-INSENSITIVE FILE "image\ii-cq":U
     LABEL "Confirma" 
     SIZE 5 BY 1.22 TOOLTIP "Confirma"
     FONT 4.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cEspecieFim AS CHARACTER FORMAT "X(2)":U INITIAL "ZZ" 
     VIEW-AS FILL-IN 
     SIZE 3.5 BY .88 NO-UNDO.

DEFINE VARIABLE cEspecieIni AS CHARACTER FORMAT "X(2)":U 
     LABEL "Esp‚cie" 
     VIEW-AS FILL-IN 
     SIZE 3.57 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-espec-ap SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 DISPLAY
      tt-espec-ap.cod-esp
      tt-espec-ap.descricao
      tt-espec-ap.tipo
      tt-espec-ap.contabiliza
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
         SIZE 90 BY 14.48
         FONT 1.

DEFINE FRAME fPage1
     cEspecieIni AT ROW 1.25 COL 6.57 COLON-ALIGNED
     cEspecieFim AT ROW 1.25 COL 23.14 COLON-ALIGNED NO-LABEL
     btConfirma AT ROW 1.08 COL 79 HELP
          "Altera ocorrˆncia corrente"
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 10.33 COL 2
     IMAGE-1 AT ROW 1.25 COL 12.43
     IMAGE-2 AT ROW 1.25 COL 21.72
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
      TABLE: tt-espec-ap T "?" NO-UNDO mgadm espec-ap
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
         HEIGHT             = 14.5
         WIDTH              = 90
         MAX-HEIGHT         = 14.5
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 14.5
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
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* BROWSE-TAB brTable1 btConfirma fPage1 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-espec-ap"
     _FldNameList[1]   = Temp-Tables.tt-espec-ap.cod-esp
     _FldNameList[2]   = Temp-Tables.tt-espec-ap.descricao
     _FldNameList[3]   = Temp-Tables.tt-espec-ap.tipo
     _FldNameList[4]   = Temp-Tables.tt-espec-ap.contabiliza
     _Query            is OPENED
*/  /* BROWSE brTable1 */
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
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


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btConfirma
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfirma wZoom
ON CHOOSE OF btConfirma IN FRAME fPage1 /* Confirma */
DO:
  RUN setConstraints (input 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
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
   RUN cdp/cd1502.w.
   /*{zoom/Implant.i &ProgramImplant="cdp/cd1502.w"
 *                    &PageNumber="1"}*/
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
{Zoom/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisableFields wZoom 
PROCEDURE afterDisableFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wZoom 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitilizaInterface wZoom 
PROCEDURE afterInitilizaInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
       RUN adbo/boad104.p persistent set h-boad104.
       RUN setConstraint3 IN {&hDBOTable1}
                        (INPUT "",
                         INPUT "ZZ").
       enable cEspecieIni cEspecieFim btConfirma with frame fpage1.
       apply "entry" to cEspecieIni in frame fpage1.
       assign cEspecieFim:screen-value in frame fpage1 = "ZZ".
       
       /*{btb/btb008za.i1 C:/Programs/DBOCustomer.p}
 *        {btb/btb008za.i2 C:/Programs/DBOCustomer.p '' {&hDBOTable1}}*/
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
    
    {zoom/OpenQueries.i &Query="Espec_AP"
                        &PageNumber="1"
                        &QueryNumber="3"}
    
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
            WHEN "cod-esp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-esp).
            WHEN "descricao":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.descricao).
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
            RUN setConstraint3 IN {&hDBOTable1}
                        (INPUT cEspecieIni:screen-value in frame fPage1,
                         INPUT cEspecieFim:screen-value in frame fPage1).
        &ELSE
            /*--- Seta Constraints para o DBOTable1 ---*/
            RUN setConstraintCustNum IN {&hDBOTable1} 
                        (INPUT fnIniRangeInt(INPUT 1),
                         INPUT fnEndRangeInt(INPUT 1))
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


