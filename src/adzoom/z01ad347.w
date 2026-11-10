&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME

{include/i_dbvers.i}

/* Connected Databases 
          rtb              PROGRESS
          movadm           PROGRESS
*/
&Scoped-define WINDOW-NAME wZoom

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-contr-titulo-exp NO-UNDO LIKE contr-titulo-exp
       field r-rowid as rowid
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
{include/i-prgvrs.i Z01AD347 2.00.00.006}  /*** "010006" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i z01ad347 MUT}
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
&GLOBAL-DEFINE Program           Z01AD347
&GLOBAL-DEFINE Version           2.00.00.006

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      Contrato

&GLOBAL-DEFINE Range             YES
&GLOBAL-DEFINE FieldNames        
&if "{&mgadm_version}":U < "2.06":U &then
    &GLOBAL-DEFINE FieldsRangePage1  movadm.contr-titulo-exp.cod-estabel,movadm.contr-titulo-exp.cod-emitente,movadm.contr-titulo-exp.nr-docto,movadm.contr-titulo-exp.dt-vencimen,movadm.contr-titulo-exp.char-1
&else
    &GLOBAL-DEFINE FieldsRangePage1  movadm.contr-titulo-exp.cod-estabel,movadm.contr-titulo-exp.cod-emitente,movadm.contr-titulo-exp.nr-docto,movadm.contr-titulo-exp.dt-vencimen,movadm.contr-titulo-exp.nr-proc-exp
&endif  
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO,NO,NO,NO,NO

&GLOBAL-DEFINE ttTable1          tt-contr-titulo-exp
&GLOBAL-DEFINE hDBOTable1        hDBOboad347
&GLOBAL-DEFINE DBOTable1         contr-titulo-exp

&GLOBAL-DEFINE page1Browse       brTable1

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
/*
    &IF "{&mgadm_version}":U < "2.06":U &THEN
        movadm.contr-titulo-exp.char-1
    &ELSE
        movadm.contr-titulo-exp.nr-proc-exp
    &ENDIF
*/

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
&Scoped-define INTERNAL-TABLES tt-contr-titulo-exp

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-contr-titulo-exp.cod-estabel tt-contr-titulo-exp.cod-emitente tt-contr-titulo-exp.cod-esp tt-contr-titulo-exp.serie tt-contr-titulo-exp.nr-docto tt-contr-titulo-exp.parcela tt-contr-titulo-exp.dt-vencimen &if "{&mgadm_version}":U < "2.06":U &then tt-contr-titulo-exp.char-1 &else tt-contr-titulo-exp.nr-proc-exp &endif   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1   
&Scoped-define SELF-NAME brTable1
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-contr-titulo-exp NO-LOCK     BY tt-contr-titulo-exp.cod-estabel      BY tt-contr-titulo-exp.cod-emitente       BY tt-contr-titulo-exp.cod-esp        BY tt-contr-titulo-exp.serie         BY tt-contr-titulo-exp.nr-docto          BY tt-contr-titulo-exp.parcela
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY {&SELF-NAME} FOR EACH tt-contr-titulo-exp NO-LOCK     BY tt-contr-titulo-exp.cod-estabel      BY tt-contr-titulo-exp.cod-emitente       BY tt-contr-titulo-exp.cod-esp        BY tt-contr-titulo-exp.serie         BY tt-contr-titulo-exp.nr-docto          BY tt-contr-titulo-exp.parcela.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-contr-titulo-exp
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-contr-titulo-exp


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS btOK btCancel btHelp rtToolBar 

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
      tt-contr-titulo-exp SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _FREEFORM
  QUERY brTable1 DISPLAY
&IF "{&mguni_version}" >= "2.071" &THEN
      tt-contr-titulo-exp.cod-estabel format "x(05)":U
&ELSE
      tt-contr-titulo-exp.cod-estabel FORMAT "x(3)":U
&ENDIF
      tt-contr-titulo-exp.cod-emitente FORMAT ">>>>>>>>9":U
      tt-contr-titulo-exp.cod-esp FORMAT "x(03)":U
      tt-contr-titulo-exp.serie FORMAT "x(5)":U
      tt-contr-titulo-exp.nr-docto FORMAT "x(16)":U
      tt-contr-titulo-exp.parcela FORMAT "x(2)":U
      tt-contr-titulo-exp.dt-vencimen FORMAT "99/99/9999":U
      &if "{&mgadm_version}":U < "2.06":U &then tt-contr-titulo-exp.char-1 &else tt-contr-titulo-exp.nr-proc-exp &endif COLUMN-LABEL "Nr Proc Exp" FORMAT "x(12)":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 7.58
         FONT 2 ROW-HEIGHT-CHARS .67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 17.46 COL 2
     btCancel AT ROW 17.46 COL 13
     btHelp AT ROW 17.46 COL 80
     rtToolBar AT ROW 17.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.83
         FONT 1.

DEFINE FRAME fPage1
     brTable1 AT ROW 6.25 COL 2.14
     btImplant1 AT ROW 13.92 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.46
         SIZE 84.43 BY 14.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-contr-titulo-exp T "?" NO-UNDO movadm contr-titulo-exp
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
         HEIGHT             = 17.83
         WIDTH              = 90
         MAX-HEIGHT         = 17.88
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17.88
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
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _START_FREEFORM
OPEN QUERY {&SELF-NAME} FOR EACH tt-contr-titulo-exp NO-LOCK
    BY tt-contr-titulo-exp.cod-estabel
     BY tt-contr-titulo-exp.cod-emitente
      BY tt-contr-titulo-exp.cod-esp
       BY tt-contr-titulo-exp.serie
        BY tt-contr-titulo-exp.nr-docto
         BY tt-contr-titulo-exp.parcela.
     _END_FREEFORM
     _OrdList          = "Temp-Tables.tt-contr-titulo-exp.cod-estabel|yes,Temp-Tables.tt-contr-titulo-exp.cod-emitente|yes,Temp-Tables.tt-contr-titulo-exp.cod-esp|yes,Temp-Tables.tt-contr-titulo-exp.serie|yes,Temp-Tables.tt-contr-titulo-exp.nr-docto|yes,Temp-Tables.tt-contr-titulo-exp.parcela|yes"
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
       {btb/btb008za.i1 adbo/boad347.p "YES"}
       {btb/btb008za.i2 adbo/boad347.p '' {&hDBOTable1}} 
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
    
    {zoom/openqueries.i &Query="contr-titulo-exp"
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
            &IF "{&mgadm_version}":U < "2.06":U &THEN
                WHEN "char-1":U THEN 
                    ASSIGN pcFieldValue = STRING({&ttTable1}.char-1).
            &ELSE
                WHEN "nr-proc-exp":U THEN
                    ASSIGN pcFieldValue = STRING({&ttTable1}.nr-proc-exp).
            &ENDIF
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
                                                      INPUT fnEndRangeDatePage(INPUT 1,4),
                                                      INPUT fnIniRangeCharPage(INPUT 1,5),
                                                      INPUT fnEndRangeCharPage(INPUT 1,5)).
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

