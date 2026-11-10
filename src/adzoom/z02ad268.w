&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-transporte NO-UNDO LIKE mgadm.transporte
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-transporte2 NO-UNDO LIKE mgadm.transporte
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-transporte3 NO-UNDO LIKE mgadm.transporte
       field r-rowid as rowid.
DEFINE TEMP-TABLE tt-transporte4 NO-UNDO LIKE mgadm.transporte
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
{include/i-prgvrs.i Z02AD268 2.00.00.003} /*** "010003" 09/08/2024 15:41:07  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z02AD268 MUT}
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
&GLOBAL-DEFINE Program      Z02AD268
&GLOBAL-DEFINE Version      2.00.00.003

&GLOBAL-DEFINE Folder       YES
&GLOBAL-DEFINE InitialPage  1

&GLOBAL-DEFINE FolderLabels C¢digo ,Nome ,Cgc ,Nome Abrev

&GLOBAL-DEFINE Range        YES
&GLOBAL-DEFINE FieldNames   mgadm.transporte.cod-transp,mgadm.transporte.nome,mgadm.transporte.cgc,mgadm.transporte.nome-abrev

&GLOBAL-DEFINE ttTable1     tt-transporte
&GLOBAL-DEFINE hDBOTable1   h-boad268na
&GLOBAL-DEFINE DBOTable1    transporte

&GLOBAL-DEFINE ttTable2     tt-transporte2
&GLOBAL-DEFINE hDBOTable2   h-boad268na2
&GLOBAL-DEFINE DBOTable2    transporte

&GLOBAL-DEFINE ttTable3     tt-transporte3
&GLOBAL-DEFINE hDBOTable3   h-boad268na3
&GLOBAL-DEFINE DBOTable3    transporte

&GLOBAL-DEFINE ttTable4     tt-transporte4
&GLOBAL-DEFINE hDBOTable4   h-boad268na4
&GLOBAL-DEFINE DBOTable4    transporte

&GLOBAL-DEFINE page1Browse  brTable1    
&GLOBAL-DEFINE page2Browse  brTable2    
&GLOBAL-DEFINE page3Browse  brTable3    
&GLOBAL-DEFINE page4Browse  brTable4

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable3} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable4} AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-transporte tt-transporte2 tt-transporte3 ~
tt-transporte4

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-transporte.cod-transp ~
tt-transporte.nome-abrev tt-transporte.nome tt-transporte.cgc ~
tt-transporte.via-transp tt-transporte.ins-municipal tt-transporte.pais ~
tt-transporte.telefone tt-transporte.zip-code 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define FIELD-PAIRS-IN-QUERY-brTable1
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-transporte NO-LOCK.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-transporte
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-transporte


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-transporte2.nome ~
tt-transporte2.cod-transp tt-transporte2.nome-abrev tt-transporte2.cgc ~
tt-transporte2.via-transp tt-transporte2.ins-estadual tt-transporte2.pais ~
tt-transporte2.telefone tt-transporte2.zip-code 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define FIELD-PAIRS-IN-QUERY-brTable2
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-transporte2 NO-LOCK ~
    USE-INDEX nome BY tt-transporte2.nome BY tt-transporte2.nome-abrev.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-transporte2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-transporte2


/* Definitions for BROWSE brTable3                                      */
&Scoped-define FIELDS-IN-QUERY-brTable3 tt-transporte3.cgc ~
tt-transporte3.cod-transp tt-transporte3.nome tt-transporte3.nome-abrev ~
tt-transporte3.via-transp tt-transporte3.ins-estadual tt-transporte3.pais ~
tt-transporte3.telefone tt-transporte3.zip-code 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable3 
&Scoped-define FIELD-PAIRS-IN-QUERY-brTable3
&Scoped-define OPEN-QUERY-brTable3 OPEN QUERY brTable3 FOR EACH tt-transporte3 NO-LOCK ~
    BY tt-transporte3.cgc.
&Scoped-define TABLES-IN-QUERY-brTable3 tt-transporte3
&Scoped-define FIRST-TABLE-IN-QUERY-brTable3 tt-transporte3


/* Definitions for BROWSE brTable4                                      */
&Scoped-define FIELDS-IN-QUERY-brTable4 tt-transporte4.nome-abrev ~
tt-transporte4.cod-transp tt-transporte4.nome tt-transporte4.cgc ~
tt-transporte4.via-transp tt-transporte4.ins-municipal tt-transporte4.pais ~
tt-transporte4.telefone tt-transporte4.zip-code 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable4 
&Scoped-define FIELD-PAIRS-IN-QUERY-brTable4
&Scoped-define OPEN-QUERY-brTable4 OPEN QUERY brTable4 FOR EACH tt-transporte4 NO-LOCK ~
    BY tt-transporte4.nome-abrev.
&Scoped-define TABLES-IN-QUERY-brTable4 tt-transporte4
&Scoped-define FIRST-TABLE-IN-QUERY-brTable4 tt-transporte4


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brTable3}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brTable4}

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

DEFINE BUTTON btImplant3 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE BUTTON btImplant4 
     LABEL "Implantar" 
     SIZE 10 BY 1.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-transporte SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-transporte2 SCROLLING.

DEFINE QUERY brTable3 FOR 
      tt-transporte3 SCROLLING.

DEFINE QUERY brTable4 FOR 
      tt-transporte4 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 DISPLAY
      tt-transporte.cod-transp
      tt-transporte.nome-abrev
      tt-transporte.nome
      tt-transporte.cgc
      tt-transporte.via-transp
      tt-transporte.ins-municipal
      tt-transporte.pais
      tt-transporte.telefone
      tt-transporte.zip-code
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.5
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 DISPLAY
      tt-transporte2.nome
      tt-transporte2.cod-transp
      tt-transporte2.nome-abrev
      tt-transporte2.cgc
      tt-transporte2.via-transp
      tt-transporte2.ins-estadual
      tt-transporte2.pais
      tt-transporte2.telefone
      tt-transporte2.zip-code
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.5
         FONT 2.

DEFINE BROWSE brTable3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable3 wZoom _STRUCTURED
  QUERY brTable3 DISPLAY
      tt-transporte3.cgc
      tt-transporte3.cod-transp
      tt-transporte3.nome
      tt-transporte3.nome-abrev
      tt-transporte3.via-transp
      tt-transporte3.ins-estadual
      tt-transporte3.pais
      tt-transporte3.telefone
      tt-transporte3.zip-code
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.5
         FONT 2.

DEFINE BROWSE brTable4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable4 wZoom _STRUCTURED
  QUERY brTable4 DISPLAY
      tt-transporte4.nome-abrev
      tt-transporte4.cod-transp
      tt-transporte4.nome
      tt-transporte4.cgc
      tt-transporte4.via-transp
      tt-transporte4.ins-municipal
      tt-transporte4.pais
      tt-transporte4.telefone
      tt-transporte4.zip-code
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
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage4
     brTable4 AT ROW 2.33 COL 2
     btImplant4 AT ROW 12.83 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.13
         FONT 1.

DEFINE FRAME fPage3
     brTable3 AT ROW 2.33 COL 2
     btImplant3 AT ROW 12.83 COL 2
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

DEFINE FRAME fPage1
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 12.83 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
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
      TABLE: tt-transporte3 T "?" NO-UNDO mgadm transporte
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
      TABLE: tt-transporte4 T "?" NO-UNDO mgadm transporte
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


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage4:MOVE-BEFORE-TAB-ITEM (FRAME fPage2:HANDLE)
       XXTABVALXX = FRAME fPage3:MOVE-BEFORE-TAB-ITEM (FRAME fPage4:HANDLE)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (FRAME fPage3:HANDLE)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 1 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brTable3 1 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brTable4 1 fPage4 */
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
     _FldNameList[6]   = Temp-Tables.tt-transporte.ins-municipal
     _FldNameList[7]   = Temp-Tables.tt-transporte.pais
     _FldNameList[8]   = Temp-Tables.tt-transporte.telefone
     _FldNameList[9]   = Temp-Tables.tt-transporte.zip-code
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-transporte2"
     _OrdList          = "Temp-Tables.tt-transporte2.nome|yes"
     _FldNameList[1]   = Temp-Tables.tt-transporte2.nome
     _FldNameList[2]   = Temp-Tables.tt-transporte2.cod-transp
     _FldNameList[3]   = Temp-Tables.tt-transporte2.nome-abrev
     _FldNameList[4]   = Temp-Tables.tt-transporte2.cgc
     _FldNameList[5]   = Temp-Tables.tt-transporte2.via-transp
     _FldNameList[6]   = Temp-Tables.tt-transporte2.ins-estadual
     _FldNameList[7]   = Temp-Tables.tt-transporte2.pais
     _FldNameList[8]   = Temp-Tables.tt-transporte2.telefone
     _FldNameList[9]   = Temp-Tables.tt-transporte2.zip-code
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable3
/* Query rebuild information for BROWSE brTable3
     _TblList          = "Temp-Tables.tt-transporte3"
     _OrdList          = "Temp-Tables.tt-transporte3.cgc|yes"
     _FldNameList[1]   = Temp-Tables.tt-transporte3.cgc
     _FldNameList[2]   = Temp-Tables.tt-transporte3.cod-transp
     _FldNameList[3]   = Temp-Tables.tt-transporte3.nome
     _FldNameList[4]   = Temp-Tables.tt-transporte3.nome-abrev
     _FldNameList[5]   = Temp-Tables.tt-transporte3.via-transp
     _FldNameList[6]   = Temp-Tables.tt-transporte3.ins-estadual
     _FldNameList[7]   = Temp-Tables.tt-transporte3.pais
     _FldNameList[8]   = Temp-Tables.tt-transporte3.telefone
     _FldNameList[9]   = Temp-Tables.tt-transporte3.zip-code
     _Query            is OPENED
*/  /* BROWSE brTable3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable4
/* Query rebuild information for BROWSE brTable4
     _TblList          = "Temp-Tables.tt-transporte4"
     _OrdList          = "Temp-Tables.tt-transporte4.nome-abrev|yes"
     _FldNameList[1]   = Temp-Tables.tt-transporte4.nome-abrev
     _FldNameList[2]   = Temp-Tables.tt-transporte4.cod-transp
     _FldNameList[3]   = Temp-Tables.tt-transporte4.nome
     _FldNameList[4]   = Temp-Tables.tt-transporte4.cgc
     _FldNameList[5]   = Temp-Tables.tt-transporte4.via-transp
     _FldNameList[6]   = Temp-Tables.tt-transporte4.ins-municipal
     _FldNameList[7]   = Temp-Tables.tt-transporte4.pais
     _FldNameList[8]   = Temp-Tables.tt-transporte4.telefone
     _FldNameList[9]   = Temp-Tables.tt-transporte4.zip-code
     _Query            is OPENED
*/  /* BROWSE brTable4 */
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
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
    run cdp/cd0402.w.

    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    run cdp/cd0402.w.
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btImplant3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant3 wZoom
ON CHOOSE OF btImplant3 IN FRAME fPage3 /* Implantar */
DO:
    run cdp/cd0402.w.
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btImplant4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant4 wZoom
ON CHOOSE OF btImplant4 IN FRAME fPage4 /* Implantar */
DO:
    run cdp/cd0402.w.
    /*--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) THEN DO:
        {btb/btb008za.i1 adbo/boad268na.p}
        {btb/btb008za.i2 adbo/boad268na.p '' {&hDBOTable1}} 
    END.
    
    RUN setConstraintFaixaTransporte IN {&hDBOTable1} (input 0,
                                                       input 99999).
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) THEN DO:
        {btb/btb008za.i1 adbo/boad268na.p}
        {btb/btb008za.i2 adbo/boad268na.p '' {&hDBOTable2}} 
    END.
    
    RUN setConstraintFaixaNome IN {&hDBOTable2} (input "",
                                                 input "ZZZZZZZZZZZZZZZZZZZZ").
    
        /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable3}) THEN DO:
        {btb/btb008za.i1 adbo/boad268na.p}
        {btb/btb008za.i2 adbo/boad268na.p '' {&hDBOTable3}} 
    END.
    
    RUN setConstraintFaixaCGC IN {&hDBOTable3} (input "",
                                                     input "ZZZZZZZZZZZZZ").
    
    /*--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable4}) THEN DO:
        {btb/btb008za.i1 adbo/boad268na.p}
        {btb/btb008za.i2 adbo/boad268na.p '' {&hDBOTable4}} 
    END.
    
    RUN setConstraintFaixaNomeAbrev IN {&hDBOTable4} (input "",
                                                      input "ZZZZZZZZZZZZZZ").
    
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
    
    {zoom/OpenQueries.i &Query="FaixaTransporte"
                        &PageNumber="1"}
    
    {zoom/OpenQueries.i &Query="FaixaNome"
                        &PageNumber="2"}

    {zoom/OpenQueries.i &Query="FaixaCGC"
                        &PageNumber="3"}
    
    {zoom/OpenQueries.i &Query="FaixaNomeAbrev"
                        &PageNumber="4"}
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
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cgc).
            WHEN "via-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.via-transp).
            WHEN "ins-estadual":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.ins-estadual).
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
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cgc).
            WHEN "via-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.via-transp).
            WHEN "ins-estadual":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.ins-estadual).
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage3 wZoom 
PROCEDURE returnFieldsPage3 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 3
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable3} THEN DO:
        CASE pcField:
            WHEN "cod-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cod-transp).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cgc).
            WHEN "via-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.via-transp).
            WHEN "ins-estadual":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.ins-estadual).
            WHEN "pais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.pais).
            WHEN "telefone":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.telefone).
            WHEN "zip-code":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.zip-code).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage4 wZoom 
PROCEDURE returnFieldsPage4 :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 4
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable4} THEN DO:
        CASE pcField:
            WHEN "cod-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.cod-transp).
            WHEN "nome":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.nome).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.cgc).
            WHEN "via-transp":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.via-transp).
            WHEN "ins-estadual":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.ins-estadual).
            WHEN "pais":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.pais).
            WHEN "telefone":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.telefone).
            WHEN "zip-code":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.zip-code).
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
            /*--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintFaixaTransporte IN {&hDBOTable1} (INPUT FnIniRangeInt(INPUT 1),
                                                               INPUT FnEndRangeInt(INPUT 1)).
        
        WHEN 2 THEN
            /*--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintFaixaNome IN {&hDBOTable2} (INPUT FnIniRangeChar(INPUT 2),
                                                         INPUT FnEndRangeChar(INPUT 2)).
        WHEN 3 THEN
            /*--- Seta Constraints para o DBO Table3 ---*/
            RUN setConstraintFaixaCGC IN {&hDBOTable3} (INPUT FnIniRangeChar(INPUT 3),
                                                        INPUT FnEndRangeChar(INPUT 3)).
        WHEN 4 THEN
            /*--- Seta Constraints para o DBO Table3 ---*/
            RUN setConstraintFaixaNomeAbrev IN {&hDBOTable4} (INPUT FnIniRangeChar(INPUT 4),
                                                             INPUT FnEndRangeChar(INPUT 4)).
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


