&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wZoom


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-contr-titulo-imp NO-UNDO LIKE contr-titulo-imp
       field r-rowid as rowid
       .
DEFINE TEMP-TABLE tt-emitente NO-UNDO LIKE emitente
       field r-rowid as rowid
       index nome nome-abrev
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
{include/i-prgvrs.i Z01AD342 2.00.00.004}  /*** "010004" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z01ad342 MUT}
&ENDIF

/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

/* Template Liberado */

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           Z01AD342
&GLOBAL-DEFINE Version           2.00.00.004

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Contrato

&GLOBAL-DEFINE Range             YES
&GLOBAL-DEFINE FieldNames        
&GLOBAL-DEFINE FieldsRangePage1  movadm.contr-titulo-imp.cod-estabel,movadm.contr-titulo-imp.cod-emitente,movadm.contr-titulo-imp.nr-docto,movadm.contr-titulo-imp.dt-vencimen
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO,NO,NO,NO

&GLOBAL-DEFINE ttTable1          tt-contr-titulo-imp
&GLOBAL-DEFINE hDBOTable1        hDBOboad342
&GLOBAL-DEFINE DBOTable1         contr-titulo-imp

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.

def var h-brTable1 as handle no-undo.

&GLOBAL-DEFINE ROW-NUM-DEFINED YES

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
&Scoped-define INTERNAL-TABLES tt-contr-titulo-imp tt-emitente

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-contr-titulo-imp.cod-estabel ~
tt-contr-titulo-imp.cod-emitente tt-emitente.nome-abrev ~
tt-contr-titulo-imp.cod-esp tt-contr-titulo-imp.serie ~
tt-contr-titulo-imp.nr-docto tt-contr-titulo-imp.parcela ~
tt-contr-titulo-imp.dt-vencimen 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-contr-titulo-imp NO-LOCK, ~
      FIRST tt-emitente WHERE tt-emitente.cod-emitente = tt-contr-titulo-imp.cod-emitente NO-LOCK ~
    BY tt-contr-titulo-imp.cod-estabel ~
       BY tt-contr-titulo-imp.cod-emitente ~
        BY tt-contr-titulo-imp.cod-esp ~
         BY tt-contr-titulo-imp.serie ~
          BY tt-contr-titulo-imp.nr-docto ~
           BY tt-contr-titulo-imp.parcela
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-contr-titulo-imp NO-LOCK, ~
      FIRST tt-emitente WHERE tt-emitente.cod-emitente = tt-contr-titulo-imp.cod-emitente NO-LOCK ~
    BY tt-contr-titulo-imp.cod-estabel ~
       BY tt-contr-titulo-imp.cod-emitente ~
        BY tt-contr-titulo-imp.cod-esp ~
         BY tt-contr-titulo-imp.serie ~
          BY tt-contr-titulo-imp.nr-docto ~
           BY tt-contr-titulo-imp.parcela.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-contr-titulo-imp tt-emitente
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-contr-titulo-imp
&Scoped-define SECOND-TABLE-IN-QUERY-brTable1 tt-emitente


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

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-contr-titulo-imp, 
      tt-emitente SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-contr-titulo-imp.cod-estabel FORMAT "x(5)":U
      tt-contr-titulo-imp.cod-emitente FORMAT ">>>>>>>>9":U
      tt-emitente.nome-abrev FORMAT "X(12)":U
      tt-contr-titulo-imp.cod-esp FORMAT "x(03)":U
      tt-contr-titulo-imp.serie FORMAT "x(5)":U
      tt-contr-titulo-imp.nr-docto FORMAT "x(16)":U
      tt-contr-titulo-imp.parcela FORMAT "x(2)":U
      tt-contr-titulo-imp.dt-vencimen FORMAT "99/99/9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.58
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
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 5.25 COL 2
     btImplant1 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-contr-titulo-imp T "?" NO-UNDO movadm contr-titulo-imp
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          
      END-FIELDS.
      TABLE: tt-emitente T "?" NO-UNDO mgadm emitente
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
          index nome nome-abrev
          
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
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
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
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR BUTTON btImplant1 IN FRAME fPage1
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-contr-titulo-imp,Temp-Tables.tt-emitente WHERE Temp-Tables.tt-contr-titulo-imp ..."
     _Options          = "NO-LOCK"
     _TblOptList       = ", FIRST"
     _OrdList          = "Temp-Tables.tt-contr-titulo-imp.cod-estabel|yes,Temp-Tables.tt-contr-titulo-imp.cod-emitente|yes,Temp-Tables.tt-contr-titulo-imp.cod-esp|yes,Temp-Tables.tt-contr-titulo-imp.serie|yes,Temp-Tables.tt-contr-titulo-imp.nr-docto|yes,Temp-Tables.tt-contr-titulo-imp.parcela|yes"
     _JoinCode[2]      = "Temp-Tables.tt-emitente.cod-emitente = Temp-Tables.tt-contr-titulo-imp.cod-emitente"
     _FldNameList[1]   = Temp-Tables.tt-contr-titulo-imp.cod-estabel
     _FldNameList[2]   = Temp-Tables.tt-contr-titulo-imp.cod-emitente
     _FldNameList[3]   = Temp-Tables.tt-emitente.nome-abrev
     _FldNameList[4]   = Temp-Tables.tt-contr-titulo-imp.cod-esp
     _FldNameList[5]   = Temp-Tables.tt-contr-titulo-imp.serie
     _FldNameList[6]   = Temp-Tables.tt-contr-titulo-imp.nr-docto
     _FldNameList[7]   = Temp-Tables.tt-contr-titulo-imp.parcela
     _FldNameList[8]   = Temp-Tables.tt-contr-titulo-imp.dt-vencimen
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
/*    {zoom/implant.i &ProgramImplant="app/ap0501.w"
                    &PageNumber="1"}*/
  
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

/*--- L½gica para inicializa»’o do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterinitializeInterface wZoom 
PROCEDURE afterinitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   enable btImplant1 with frame fpage1.
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

   /*--- Verifica se o DBO jÿ estÿ inicializado ---*/
   IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
       {btb/btb008za.i1 adbo/boad342.p "YES"}
       {btb/btb008za.i2 adbo/boad342.p '' {&hDBOTable1}} 
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

    RUN GetNomeAbrev IN {&hDBOTable1} (input 2,
                                       input 0,
                                       input &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF,
                                       INPUT-OUTPUT table tt-emitente) NO-ERROR. 

    {zoom/openqueries.i &Query="contr-titulo-imp"
                        &PageNumber="1"}

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da pÿgina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.

    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-estabel":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-estabel).
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "nr-docto":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nr-docto).
            WHEN "dt-vencimen":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.dt-vencimen).
        END CASE.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme nœmero da pÿgina
               passado como par³metro
  Parameters:  recebe nœmero da pÿgina
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.

    /*--- Seta constraints conforme nœmero da pÿgina ---*/
    CASE pPageNumber:
        WHEN 1 THEN do:
            /*--- Seta Constraints para o DBO Table1 ---*/

            RUN setConstraintcontrato IN {&hDBOTable1} (INPUT fnIniRangeCharPage(INPUT 1,1), 
                                                      INPUT fnEndRangeCharPage(INPUT 1,1),
                                                      INPUT fnIniRangeIntPage(INPUT 1,2),
                                                      INPUT fnEndRangeIntPage(INPUT 1,2),
                                                      INPUT fnIniRangeCharPage(INPUT 1,3),
                                                      INPUT fnEndRangeCharPage(INPUT 1,3),
                                                      INPUT fnIniRangeDatePage(INPUT 1,4),
                                                      INPUT fnEndRangeDatePage(INPUT 1,4)).
        end.
    END CASE.

    /*--- Seta variÿvel iConstraintPageNumber com o nœmero da pÿgina atual 
          Esta variÿvel ² utilizada no m²todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.

    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

