&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-param NO-UNDO LIKE mab-param
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wWindow 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0101B 2.00.00.008 } /*** "010008" 31/03/2025 10:17:08  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0101b MAB}
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
&GLOBAL-DEFINE Program        AB0101B
&GLOBAL-DEFINE Version        2.00.00.008

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   cParam cDescParam ~
                              dValor cbVAlor cValor cValor1 cValor2 cText tgValor ~
                              btOK btCancel btHelp2 fi-txt-val-param fiempresa fiEstab

/* Parameters Definitions ---                                           */
define input parameter  pParam        LIKE mab-param.cdn-param.
define input parameter  pDescParam    LIKE mab-param.des-label-param.
define input parameter  pHpai         as handle no-undo.
define input-output parameter pValor  AS CHAR FORMAT "x(20)" NO-UNDO.


define variable hDBOParam       as handle  no-undo.
define variable hDBOEvent       as handle  no-undo.
define variable hDBOSubSist     as handle  no-undo.
define variable hDBOTipoManut   as handle  no-undo.
define variable hDBOMotorista   as handle  no-undo.
define variable hDBOTrajeto     as handle  no-undo.
define variable hDBOEmp         as handle  no-undo.
def var c-lista as char no-undo.

define VAR pValor1  AS CHAR FORMAT "x(20)" NO-UNDO.
define VAR pValor2  AS INT  NO-UNDO.
define VAR pValor3  AS DEC  NO-UNDO.

{abp/ab0101.i} /* defini‡Æo da temp-table ttParam */

/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS cParam cDescParam cbValor cValor1 cValor2 ~
cValor TgValor dValor cText btOK btCancel btHelp2 fiEmpresa ~
fi-txt-val-param fiEstab RECT-1 RECT-19 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cParam cDescParam cbValor cValor1 cValor2 ~
cValor TgValor dValor cText fiEmpresa fi-txt-val-param fiEstab 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cbValor AS CHARACTER FORMAT "X(30)":U INITIAL "0" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE cText AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 200 SCROLLBAR-VERTICAL
     SIZE 58 BY 4
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cDescParam AS CHARACTER FORMAT "X(80)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cParam AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE cValor AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE cValor1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE cValor2 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE dValor AS DECIMAL FORMAT ">>>,>>9.99" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-txt-val-param AS CHARACTER FORMAT "X(256)":U INITIAL "Valor Parƒmetro:" 
      VIEW-AS TEXT 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpresa AS CHARACTER FORMAT "X(256)":U INITIAL "Empresa" 
      VIEW-AS TEXT 
     SIZE 6.14 BY .67 NO-UNDO.

DEFINE VARIABLE fiEstab AS CHARACTER FORMAT "X(256)":U INITIAL "Estabel" 
      VIEW-AS TEXT 
     SIZE 6 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60.29 BY 9.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE TgValor AS LOGICAL INITIAL no 
     LABEL "Valor Parƒmetro" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cParam AT ROW 1.58 COL 7.57 COLON-ALIGNED
     cDescParam AT ROW 1.58 COL 17.57 COLON-ALIGNED NO-LABEL
     cbValor AT ROW 3 COL 15 COLON-ALIGNED NO-LABEL
     cValor1 AT ROW 5 COL 15 COLON-ALIGNED NO-LABEL
     cValor2 AT ROW 3 COL 15 COLON-ALIGNED NO-LABEL
     cValor AT ROW 4 COL 15 COLON-ALIGNED NO-LABEL
     TgValor AT ROW 4.25 COL 39.43
     dValor AT ROW 5 COL 15 COLON-ALIGNED HELP
          "Valor do Parƒmetro" NO-LABEL
     cText AT ROW 6.54 COL 3 NO-LABEL
     btOK AT ROW 11.08 COL 2
     btCancel AT ROW 11.08 COL 13.14
     btHelp2 AT ROW 11.08 COL 51.43
     fiEmpresa AT ROW 3.17 COL 8.14 COLON-ALIGNED NO-LABEL
     fi-txt-val-param AT ROW 4 COL 6 NO-LABEL
     fiEstab AT ROW 5 COL 9 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 1.25 COL 1.72
     RECT-19 AT ROW 1.38 COL 2.29
     rtToolBar AT ROW 10.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.43 BY 11.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-param T "?" NO-UNDO mgfro mab-param
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros"
         HEIGHT             = 11.58
         WIDTH              = 61.14
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN fi-txt-val-param IN FRAME fpage0
   ALIGN-L                                                              */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wWindow)
THEN wWindow:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wWindow
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON END-ERROR OF wWindow /* Parƒmetros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Parƒmetros */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    run getOk in pHpai (input no).
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

    EMPTY TEMP-TABLE rowErrors.
    run emptyRowErrors in hDBOParam.

    CASE pParam :
        WHEN 7 OR WHEN 8 OR WHEN 9 OR WHEN 10 OR WHEN 11 OR WHEN 12 OR WHEN 24 OR WHEN 25 OR WHEN 26 OR WHEN 28 OR WHEN 35 OR WHEN 36 OR WHEN 39 OR WHEN 45 OR WHEN 49 OR WHEN 50 OR WHEN 54 THEN DO:
            ASSIGN  pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
            RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                               INPUT cDescParam:screen-value in frame fPage0,
                                               INPUT cText:screen-value in frame fPage0,
                                               INPUT-OUTPUT pValor2).
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN piMostraErros IN THIS-PROCEDURE.
                RETURN NO-APPLY.
            END.
        END.
        WHEN 13 OR WHEN 17 OR WHEN 18 OR WHEN 19 OR WHEN 20 OR WHEN 21 OR WHEN 23 OR WHEN 27 OR WHEN 29 OR WHEN 38 OR WHEN 40 OR WHEN 41 OR WHEN 46 THEN DO:
            assign pValor1 = INPUT FRAME fPage0 cValor.
            RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                               INPUT cDescParam:screen-value in frame fPage0,
                                               INPUT cText:screen-value in frame fPage0,
                                               INPUT-OUTPUT pValor1).
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN piMostraErros IN THIS-PROCEDURE.
                RETURN NO-APPLY.
            END.
        END.
        WHEN 37 THEN DO:
            assign pValor1 =  INPUT FRAME fPage0 cValor1 + "," +
                              INPUT FRAME fPage0 cValor2 + "," +
                              INPUT FRAME fPage0 cValor.
            RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                               INPUT cDescParam:screen-value in frame fPage0,
                                               INPUT cText:screen-value in frame fPage0,
                                               INPUT-OUTPUT pValor1).
           IF RETURN-VALUE = "NOK":U THEN DO:
               RUN piMostraErros IN THIS-PROCEDURE.
               RETURN NO-APPLY.
           END.
        END.
       WHEN 43 OR WHEN 47 OR WHEN 48 OR WHEN 51 or when 52 OR WHEN 53 OR WHEN 55 OR WHEN 56 OR WHEN 57 OR WHEN 58 THEN DO:
          ASSIGN  pValor2 = IF tgValor:CHECKED IN FRAME fPage0 THEN 1 ELSE 2.
          IF pParam = 55 THEN
              ASSIGN pValor2 = 2.
          RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                             INPUT cDescParam:screen-value in frame fPage0,
                                             INPUT cText:screen-value in frame fPage0,
                                             INPUT-OUTPUT pValor2).
          IF RETURN-VALUE = "NOK":U THEN DO:
              RUN piMostraErros IN THIS-PROCEDURE.
              RETURN NO-APPLY.
          END.
       END.
       WHEN 44 THEN DO:
           /*Atualizando valores de parametro 44 - Habilita campos da ficha integrada*/
           ASSIGN  pValor2 = IF tgValor:CHECKED IN FRAME fPage0 THEN 1 ELSE 2.
            RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                               INPUT cDescParam:screen-value in frame fPage0,
                                               INPUT cText:screen-value in frame fPage0,
                                               INPUT-OUTPUT pValor2).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN piMostraErros IN THIS-PROCEDURE.
                    RETURN NO-APPLY.
                END.

      END.
      OTHERWISE DO:
            assign pValor3 = INPUT FRAME fPage0 dValor.
            RUN atualizaValor3 IN hDBOParam   (INPUT pParam,
                                               INPUT cDescParam:screen-value in frame fPage0,
                                               INPUT cText:screen-value in frame fPage0,
                                               INPUT-OUTPUT pValor3).


                IF RETURN-VALUE = "NOK":U THEN DO:
                    RUN piMostraErros IN THIS-PROCEDURE.
                    RETURN NO-APPLY.
                END.

     END.
  END CASE.

  run getOk in pHpai (input yes).

    APPLY "CLOSE":U TO THIS-PROCEDURE.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cValor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor wWindow
ON F5 OF cValor IN FRAME fpage0
DO:
   CASE cParam:SCREEN-VALUE IN FRAME fPage0:

        WHEN "13":U THEN DO:
            {include/zoomvar.i &prog-zoom=inzoom/z01in417.w
                &campo=cValor
                &campozoom=un
                &frame=fPage0
                &EnableImplant="YES"}
        END.
        WHEN "17":U THEN DO:

          {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  

        END.
        WHEN "18":U THEN DO:
           {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  

        END.
        WHEN "19":U THEN DO:
         {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}   

        END.
        WHEN "20":U THEN DO:
           {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr025.w"
           &FieldZoom1="cod-sub-sist"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  

        END.
        WHEN "21":U THEN DO:
           {method/zoomfields.i 
           &ProgramZoom="mnzoom/z01mn158.w"
           &FieldZoom1="cd-tipo"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  

        END.
        WHEN "23":U THEN DO:
           {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr025.w"
           &FieldZoom1="cod-sub-sist"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  


        END.
         WHEN "27":U THEN DO:
           {method/zoomfields.i 
           &ProgramZoom="mnzoom/z01mn158.w"
           &FieldZoom1="cd-tipo"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}

        END.
        WHEN "29":U THEN DO:
           {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr025.w"
           &FieldZoom1="cod-sub-sist"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  

        END.
         WHEN "30":U THEN DO:
          /*{include/zoomvar.i &prog-zoom=adzoom/z01ad101.w
           &campo=cValor
           &campozoom=ep-codigo
           &frame=fPage0}  */

        END.

       WHEN "37":U THEN DO:
         {method/zoomfields.i 
         &ProgramZoom="frzoom/z01fr017.w"
         &FieldZoom1="ep-codigo"
         &FieldScreen1="cValor1"
         &Frame1="fPage0"
         &FieldZoom2="cod-estabel"
         &FieldScreen2="cValor2"
         &Frame2="fPage0"
         &FieldZoom3="cod-matr"
         &FieldScreen3="cValor"
         &Frame3="fPage0"
         &EnableImplant="YES"}

      END.
       WHEN "38":U THEN DO:
         {method/zoomfields.i 
         &ProgramZoom="frzoom/z01fr028.w"
         &FieldZoom1="cod-rota"
         &FieldScreen1="cValor"
         &Frame1="fPage0"
         &EnableImplant="YES"}

      END.
       WHEN "40":U THEN DO: /** Linha do &RunMethod habilita o tipo de evento que ser  exibido no momento do filtro. Neste caso, àleo **/
            {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &RunMethod="run setaFiltro in hProgramZoom (yes, no, no, no , no, no)."
           &EnableImplant="YES"}  
       END.
       WHEN "41":U THEN DO: /** Linha do &RunMethod habilita o tipo de evento que ser  exibido no momento do filtro. Neste caso, Manut Mecanica **/
            {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr010.w"
           &FieldZoom1="cod-evento"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &RunMethod="run setaFiltro in hProgramZoom (no, no, yes, no , no, no)."
           &EnableImplant="YES"}  
       END.
       WHEN "46":U THEN DO: /** Linha do &RunMethod habilita o tipo de evento que ser  exibido no momento do filtro. Neste caso, Manut Mecanica **/
            {method/zoomfields.i 
           &ProgramZoom="mnzoom~\z01mn082.w"
           &FieldZoom1="cd-causa-padr"
           &FieldScreen1="cValor"
           &Frame1="fPage0"
           &EnableImplant="YES"}  
       END.
   END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor wWindow
ON LEAVE OF cValor IN FRAME fpage0
DO:
   CASE cParam:SCREEN-VALUE IN FRAME fPage0 :
       
       WHEN "20":U or
         WHEN "23":U or
            WHEN "29":U THEN DO:
                  RUN pi-busca-sub-sist IN THIS-PROCEDURE.
         
        END.
        WHEN "21":U OR
            WHEN "27":U THEN DO:
                  RUN pi-busca-tp-manut IN THIS-PROCEDURE.
          
        END.
       
        
      WHEN "38":U then do:
          RUN pi-busca-cod-rota IN THIS-PROCEDURE.
       END.

    END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor wWindow
ON MOUSE-SELECT-DBLCLICK OF cValor IN FRAME fpage0
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cValor1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor1 wWindow
ON F5 OF cValor1 IN FRAME fpage0
DO:
         {method/zoomfields.i 
         &ProgramZoom="frzoom/z01fr017.w"
         &FieldZoom1="ep-codigo"
         &FieldScreen1="cValor1"
         &Frame1="fPage0"
         &FieldZoom2="cod-estabel"
         &FieldScreen2="cValor2"
         &Frame2="fPage0"
         &FieldZoom3="cod-matr"
         &FieldScreen3="cValor"
         &Frame3="fPage0"
         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor1 wWindow
ON MOUSE-SELECT-DBLCLICK OF cValor1 IN FRAME fpage0
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cValor2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor2 wWindow
ON F5 OF cValor2 IN FRAME fpage0
DO:
         {method/zoomfields.i 
         &ProgramZoom="frzoom/z01fr017.w"
         &FieldZoom1="ep-codigo"
         &FieldScreen1="cValor1"
         &Frame1="fPage0"
         &FieldZoom2="cod-estabel"
         &FieldScreen2="cValor2"
         &Frame2="fPage0"
         &FieldZoom3="cod-matr"
         &FieldScreen3="cValor"
         &Frame3="fPage0"
         &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cValor2 wWindow
ON MOUSE-SELECT-DBLCLICK OF cValor2 IN FRAME fpage0
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME dValor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dValor wWindow
ON F5 OF dValor IN FRAME fpage0
DO:
  
   CASE cParam:SCREEN-VALUE IN FRAME fPage0:
         WHEN "30":U THEN DO:
          
          {include/zoomvar.i &prog-zoom=adzoom/z01ad101.w
           &campo=dValor
           &campozoom=ep-codigo
           &frame=fPage0}  

        END.

        END CASE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL dValor wWindow
ON MOUSE-SELECT-DBLCLICK OF dValor IN FRAME fpage0
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME TgValor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL TgValor wWindow
ON VALUE-CHANGED OF TgValor IN FRAME fpage0 /* Valor Parƒmetro */
DO:
    IF pParam = 55 THEN DO:
        IF TgValor:CHECKED IN FRAME fPage0 = YES THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 54612,
                               INPUT "":U).

            ASSIGN TgValor:CHECKED IN FRAME fPage0 = NO.
        END.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


{window/mainblock.i}

cValor:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
cValor1:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
cValor2:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/
if valid-handle (hDBOParam) then
    delete procedure hDBOParam.

if valid-handle (hDBOEvent) then
    delete procedure hDBOEvent.

if valid-handle (hDBOSubSist) then
    delete procedure hDBOSubSist.

if valid-handle (hDBOTipoManut) then
    delete procedure hDBOTipoManut.

if valid-handle (hDBOMotorista) then
    delete procedure hDBOMotorista.

if valid-handle (hDBOTrajeto) then
    delete procedure hDBOTrajeto.

if valid-handle (hDBOEmp) then
    delete procedure hDBOEmp.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
disp     cParam      with frame fPage0.
disp     cDescParam  with frame fPage0.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign cText:sensitive in frame fPage0 = YES
       cText:read-only in frame fPage0 = NO.
FOR FIRST  mab-param FIELDS (cdn-param des-label-param des-param des-valor)
    WHERE mab-param.cdn-param = pParam NO-LOCK:
      {utp/ut-liter.i Valor_Parƒmetro: *}
      ASSIGN fi-txt-val-param:SCREEN-VALUE IN FRAME fPage0 = RETURN-VALUE
             cParam:SCREEN-VALUE IN FRAME fPage0     = string(mab-param.cdn-param)
             cDescParam:SCREEN-VALUE IN FRAME fPage0 = mab-param.des-label-param
             cText:SCREEN-VALUE IN FRAME fPage0      = mab-param.des-param
             cValor:SCREEN-VALUE IN FRAME fPage0     = mab-param.des-valor
             dValor:SCREEN-VALUE IN FRAME fPage0     = mab-param.des-valor
             cValor1:HIDDEN IN FRAME fPage0 = YES
             cValor2:HIDDEN IN FRAME fPage0 = YES
             fiEmpresa:HIDDEN IN FRAME fPage0 = YES
             fiEstab:HIDDEN IN FRAME fPage0 = yes no-error.
      CASE pParam :
            WHEN 7 THEN DO:
                 assign cValor:hidden in frame fPage0 = YES
                        dValor:hidden in frame fPage0 = YES
                        cbValor:hidden in frame fPage0 = NO
                        tgvalor:HIDDEN IN FRAME fPage0 = YES
                        cValor:column in frame fPage0 = 20.00
                        dValor:column in frame fPage0 = 20.00
                        cbValor:column in frame fPage0 = 20.00
                        cValor:row in frame fPage0 = 3.00 
                        dValor:row in frame fPage0 = 5.00 
                        cbValor:row in frame fPage0 = 4.00.
                 &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                     DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
                     ASSIGN cAuxTraducao001 = {frinc/i00fr019.i 03}.
                     RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao001).
                     ASSIGN    c-lista  = cAuxTraducao001.
                 &else
                     ASSIGN c-lista  = {frinc/i00fr019.i 03}.
                 &endif
            END.       
            WHEN 8 THEN DO:
               assign cValor:hidden in frame fPage0 = YES
                      dValor:hidden in frame fPage0 = YES
                      cbValor:hidden in frame fPage0 = NO
                      tgvalor:HIDDEN IN FRAME fPage0 = YES
                      cValor:column in frame fPage0 = 20.00
                      dValor:column in frame fPage0 = 20.00
                      cbValor:column in frame fPage0 = 20.00
                      cValor:row in frame fPage0 = 3.00      
                      dValor:row in frame fPage0 = 5.00   
                      cbValor:row in frame fPage0 = 4.00. 
               &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                   DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
                   ASSIGN cAuxTraducao002 = {frinc/i00fr019.i 03}.
                   RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao002).
                   ASSIGN    c-lista  = cAuxTraducao002.
               &else
                   ASSIGN c-lista  = {frinc/i00fr019.i 03}.
               &endif
            END.
            WHEN 9 THEN DO:
                assign cValor:hidden in frame fPage0 = YES
                       dValor:hidden in frame fPage0 = YES
                       cbValor:hidden in frame fPage0 = NO
                       tgvalor:HIDDEN IN FRAME fPage0 = YES
                       cValor:column in frame fPage0 = 20.00
                       dValor:column in frame fPage0 = 20.00
                       cbValor:column in frame fPage0 = 20.00
                       cValor:row in frame fPage0 = 3.00   
                       dValor:row in frame fPage0 = 5.00   
                       cbValor:row in frame fPage0 = 4.00. 
                       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                           DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
                           ASSIGN cAuxTraducao003 = {frinc/i00fr019.i 03}.
                           RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao003).
                           ASSIGN    c-lista  = cAuxTraducao003.
                       &else
                           ASSIGN c-lista  = {frinc/i00fr019.i 03}.
                       &endif
            END.
            WHEN 10 THEN DO:
                 assign cValor:hidden in frame fPage0 = YES
                        dValor:hidden in frame fPage0 = YES
                        cbValor:hidden in frame fPage0 = NO
                        tgvalor:HIDDEN IN FRAME fPage0 = YES
                        cValor:column in frame fPage0 = 20.00
                        dValor:column in frame fPage0 = 20.00
                        cbValor:column in frame fPage0 = 20.00
                        cValor:row in frame fPage0 = 3.00   
                        dValor:row in frame fPage0 = 5.00   
                        cbValor:row in frame fPage0 = 4.00.
                 &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                     DEFINE VARIABLE cAuxTraducao004 AS CHARACTER NO-UNDO.
                     ASSIGN cAuxTraducao004 = {frinc/i01fr019.i 03}.
                     RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao004).
                     ASSIGN    c-lista  = cAuxTraducao004.
                 &else
                     ASSIGN c-lista  = {frinc/i01fr019.i 03}.
                 &endif
            END.
            WHEN 11 THEN DO:
                assign  cValor:hidden in frame fPage0 = YES
                        dValor:hidden in frame fPage0 = YES
                        cbValor:hidden in frame fPage0 = NO
                        tgvalor:HIDDEN IN FRAME fPage0 = YES
                        cValor:column in frame fPage0 = 20.00
                        dValor:column in frame fPage0 = 20.00
                        cbValor:column in frame fPage0 = 20.00
                        cValor:row in frame fPage0 = 3.00   
                        dValor:row in frame fPage0 = 5.00   
                        cbValor:row in frame fPage0 = 4.00. 
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
                    ASSIGN cAuxTraducao005 = {frinc/i02fr019a.i 03}.
                    RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao005).
                    ASSIGN    c-lista  = cAuxTraducao005.
                &else
                    ASSIGN c-lista  = {frinc/i02fr019a.i 03}.
                &endif
            END.
            WHEN 12 THEN DO:
                assign cValor:hidden in frame fPage0 = YES
                       dValor:hidden in frame fPage0 = YES
                       cbValor:hidden in frame fPage0 = NO
                       tgvalor:HIDDEN IN FRAME fPage0 = YES
                       cValor:column in frame fPage0 = 20.00
                       dValor:column in frame fPage0 = 20.00
                       cbValor:column in frame fPage0 = 20.00
                       cValor:row in frame fPage0 = 3.00   
                       dValor:row in frame fPage0 = 5.00   
                       cbValor:row in frame fPage0 = 4.00. 
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    DEFINE VARIABLE cAuxTraducao006 AS CHARACTER NO-UNDO.
                    ASSIGN cAuxTraducao006 = {frinc/i03fr019.i 03}.
                    RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao006).
                    ASSIGN    c-lista = cAuxTraducao006.
                &else
                    ASSIGN c-lista = {frinc/i03fr019.i 03}.
                &endif
            END.
            /*PARAMETROS CHAR*/
            WHEN 13 OR WHEN 17 OR WHEN 18 OR WHEN 19 OR WHEN 20 OR WHEN 21 OR WHEN 23 OR WHEN 27 OR WHEN 29 OR
                    WHEN 38 OR WHEN 40 OR WHEN 41 OR WHEN 46 THEN DO:
               assign  cValor:hidden in frame fPage0 = NO
                       dValor:hidden in frame fPage0 = YES
                       cbValor:hidden in frame fPage0 = YES
                       tgvalor:HIDDEN IN FRAME fPage0 = YES
                       cValor:column in frame fPage0 = 20.00
                       dValor:column in frame fPage0 = 20.00
                       cbValor:column in frame fPage0 = 20.00
                       cValor:row in frame fPage0 = 4.00   
                       dValor:row in frame fPage0 = 5.00   
                       cbValor:row in frame fPage0 = 3.00. 
            END.
            WHEN 24 THEN DO:
             assign cValor:hidden in frame fPage0 = YES
                      dValor:hidden in frame fPage0 = YES
                      cbValor:hidden in frame fPage0 = NO
                      tgvalor:HIDDEN IN FRAME fPage0 = YES
                      cValor:column in frame fPage0 = 20.00
                      dValor:column in frame fPage0 = 20.00
                      cbValor:column in frame fPage0 = 20.00
                      cValor:row in frame fPage0 = 3.00      
                      dValor:row in frame fPage0 = 5.00   
                      cbValor:row in frame fPage0 = 4.00. 
               &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                   DEFINE VARIABLE cAuxTraducao007 AS CHARACTER NO-UNDO.
                   ASSIGN cAuxTraducao007 = {frinc/i00fr019.i 03}.
                   RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao007).
                   ASSIGN    c-lista  = cAuxTraducao007.
               &else
                   ASSIGN c-lista  = {frinc/i00fr019.i 03}.
               &endif
            END.
             WHEN 25 THEN DO:
                assign cValor:hidden in frame fPage0 = YES
                      dValor:hidden in frame fPage0 = YES
                      cbValor:hidden in frame fPage0 = NO
                      tgvalor:HIDDEN IN FRAME fPage0 = YES
                      cValor:column in frame fPage0 = 20.00
                      dValor:column in frame fPage0 = 20.00
                      cbValor:column in frame fPage0 = 20.00
                      cValor:row in frame fPage0 = 3.00      
                      dValor:row in frame fPage0 = 5.00   
                      cbValor:row in frame fPage0 = 4.00. 
               &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                   DEFINE VARIABLE cAuxTraducao008 AS CHARACTER NO-UNDO.
                   ASSIGN cAuxTraducao008 = {frinc/i00fr019.i 03}.
                   RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao008).
                   ASSIGN    c-lista  = cAuxTraducao008. 
               &else
                   ASSIGN c-lista  = {frinc/i00fr019.i 03}.
               &endif
            END.
             WHEN 26 THEN DO:
                assign cValor:hidden in frame fPage0 = YES
                      dValor:hidden in frame fPage0 = YES
                      cbValor:hidden in frame fPage0 = NO
                      tgvalor:HIDDEN IN FRAME fPage0 = YES
                      cValor:column in frame fPage0 = 20.00
                      dValor:column in frame fPage0 = 20.00
                      cbValor:column in frame fPage0 = 20.00
                      cValor:row in frame fPage0 = 3.00      
                      dValor:row in frame fPage0 = 5.00   
                      cbValor:row in frame fPage0 = 4.00. 
               &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                   DEFINE VARIABLE cAuxTraducao009 AS CHARACTER NO-UNDO.
                   ASSIGN cAuxTraducao009 = {frinc/i00fr019.i 03}.
                   RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao009).
                   ASSIGN    c-lista  = cAuxTraducao009.
               &else
                   ASSIGN c-lista  = {frinc/i00fr019.i 03}.
               &endif
            END.
            WHEN 28 THEN DO:
            assign cValor:hidden in frame fPage0 = YES
                  dValor:hidden in frame fPage0 = YES
                  cbValor:hidden in frame fPage0 = NO
                  tgvalor:HIDDEN IN FRAME fPage0 = YES
                  cValor:column in frame fPage0 = 20.00
                  dValor:column in frame fPage0 = 20.00
                  cbValor:column in frame fPage0 = 20.00
                  cValor:row in frame fPage0 = 3.00      
                  dValor:row in frame fPage0 = 5.00   
                  cbValor:row in frame fPage0 = 4.00. 
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                DEFINE VARIABLE cAuxTraducao010 AS CHARACTER NO-UNDO.
                ASSIGN cAuxTraducao010 = {frinc/i00fr019.i 03}.
                RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao010).
                ASSIGN    c-lista  = cAuxTraducao010.
            &else
                ASSIGN c-lista  = {frinc/i00fr019.i 03}.
            &endif
            END.
          WHEN 35 THEN DO:
              assign  cValor:hidden in frame fPage0 = YES
                      dValor:hidden in frame fPage0 = YES
                      cbValor:hidden in frame fPage0 = NO
                      tgvalor:HIDDEN IN FRAME fPage0 = YES
                      cValor:column in frame fPage0 = 20.00
                      dValor:column in frame fPage0 = 20.00
                      cbValor:column in frame fPage0 = 20.00
                      cValor:row in frame fPage0 = 3.00   
                      dValor:row in frame fPage0 = 5.00   
                      cbValor:row in frame fPage0 = 4.00. 
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  DEFINE VARIABLE cAuxTraducao011 AS CHARACTER NO-UNDO.
                  ASSIGN cAuxTraducao011 = {frinc/i04fr019.i 03}.
                  RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao011).
                  ASSIGN    c-lista  = cAuxTraducao011.
              &else
                  ASSIGN c-lista  = {frinc/i04fr019.i 03}.
              &endif
          END.
          /* QUANDO FOR ADICIONADO UMA NOVA CONDI€ÇO NO "CASE" DEVE SER INCLUIDO NA PROCEDURE afterInitializeInterface2
             PARA A PROCEDURE afterInitializeInterface NÇO FICAR MUITO GRANDE */
          WHEN 37 OR WHEN 36 OR WHEN 39 OR WHEN 43 OR WHEN 44 OR WHEN 45 OR WHEN 47 OR WHEN 48 OR WHEN 49 OR WHEN 50 OR WHEN 51 or when 52 OR WHEN 53 OR WHEN 54 OR WHEN 55 OR WHEN 56 OR WHEN 57 OR WHEN 58 THEN DO:
               RUN afterInitializeInterface2 (INPUT pParam).
          END.
          OTHERWISE DO:
               assign  cValor:hidden in frame fPage0 = YES
                       dValor:hidden in frame fPage0 = NO
                       cbValor:hidden in frame fPage0 = YES
                       tgvalor:HIDDEN IN FRAME fPage0 = YES
                       cValor:column in frame fPage0 = 20.00
                       dValor:column in frame fPage0 = 20.00
                       cbValor:column in frame fPage0 = 20.00
                       cValor:row in frame fPage0 = 5.00   
                       dValor:row in frame fPage0 = 4.00   
                       cbValor:row in frame fPage0 = 3.00. 
               IF pParam = 30 THEN DO:
                   ASSIGN dValor:FORMAT in frame fPage0 = ">>9":U.
                   dValor:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
               END.
               ELSE
                   IF pParam = 42 THEN
                      ASSIGN dValor:FORMAT in frame fPage0 = ">>>,>99":U.
         END. /*otherwise do*/            
      END CASE.
      RUN pi-valor IN THIS-PROCEDURE.  
END. 
DISABLE  cParam with frame fPage0.
ENABLE   cDescParam with frame fPage0.
ENABLE   cText WITH FRAME fPage0.
ASSIGN   cParam:sensitive in frame  fPage0 = NO
         cDescParam:sensitive in frame  fPage0 = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface2 wWindow 
PROCEDURE afterInitializeInterface2 :
/*------------------------------------------------------------------------------  
  Purpose:     afterInitializeInterface2
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pParamAux LIKE mab-param.cdn-param.

    CASE pParamAux :
        WHEN 37 THEN DO:
           DEFINE VARIABLE aux AS CHARACTER  NO-UNDO.
           ASSIGN aux = cValor:SCREEN-VALUE IN FRAME fpage0
                  cValor:hidden             in frame fPage0 = NO
                  cValor1:hidden            in frame fPage0 = NO
                  cValor2:hidden            in frame fPage0 = NO
                  dValor:hidden             in frame fPage0 = YES
                  cbValor:hidden            in frame fPage0 = YES
                  tgvalor:HIDDEN            IN FRAME fPage0 = YES
                  fiEmpresa:HIDDEN          IN FRAME fPage0 = NO
                  fiEstab:HIDDEN            IN FRAME fPage0 = NO
                  cValor1:column            in frame fPage0 = 20.00
                  cValor:column             in frame fPage0 = 20.00
                  cValor2:column            in frame fPage0 = 20.00
                  cValor1:row               in frame fPage0 = 3.00
                  fiEmpresa:ROW             IN FRAME fPage0 = 3.00
                  cValor2:row               in frame fPage0 = 4.00
                  fiEstab:ROW               IN FRAME fPage0 = 4.00
                  cValor:row                in frame fPage0 = 5.00 
                  fi-txt-val-param:ROW      in frame fPage0 = 5.00 NO-ERROR.
           ASSIGN cValor1:SCREEN-VALUE IN FRAME fpage0 = IF ENTRY(1, aux, ",") <> "" THEN ENTRY(1, aux, ",") ELSE "0" NO-ERROR.
           ASSIGN cValor2:SCREEN-VALUE IN FRAME fpage0 = IF ENTRY(2, aux, ",") <> "" THEN ENTRY(2, aux, ",") ELSE "" NO-ERROR.
           ASSIGN cValor:SCREEN-VALUE  IN FRAME fpage0 = IF ENTRY(3, aux, ",") <> "" THEN ENTRY(3, aux, ",") ELSE "" NO-ERROR.
           for first mab-param
               where mab-param.cdn-param = 52 no-lock:
               if mab-param.des-valor = "1" then do:
                   assign cValor1:sensitive in frame fPage0 = no
                          cValor2:sensitive in frame fPage0 = no.
               end.
               else do:
                   assign cValor1:sensitive in frame fPage0 = yes
                          cValor2:sensitive in frame fPage0 = yes.
               end.
           end.


        END.
        WHEN 36 OR WHEN 39 THEN DO:
           assign cValor:hidden in frame fPage0 = YES
                 dValor:hidden in frame fPage0 = YES
                 cbValor:hidden in frame fPage0 = NO
                 tgvalor:HIDDEN IN FRAME fPage0 = YES
                 cValor:column in frame fPage0 = 20.00
                 dValor:column in frame fPage0 = 20.00
                 cbValor:column in frame fPage0 = 20.00
                 cValor:row in frame fPage0 = 3.00      
                 dValor:row in frame fPage0 = 5.00   
                 cbValor:row in frame fPage0 = 4.00. 
          &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
              DEFINE VARIABLE cAuxTraducao012 AS CHARACTER NO-UNDO.
              ASSIGN cAuxTraducao012 = {frinc/i00fr019.i 03}.
              RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao012).
              ASSIGN    c-lista  = cAuxTraducao012.
          &else
              ASSIGN c-lista  = {frinc/i00fr019.i 03}.
          &endif
       END.
        WHEN 43 THEN DO:
            /*C. Custo Componente = C. Custo Eqpto - toggle*/
          ASSIGN tgvalor:CHECKED IN FRAME fPage0 = IF mab-param.des-valor = "1":U THEN YES ELSE NO
                 cValor:hidden in frame fPage0 = YES
                 dValor:hidden in frame fPage0 = YES
                 cbValor:hidden in frame fPage0 = YES
                 tgvalor:HIDDEN IN FRAME fPage0 = NO
                 tgvalor:COLUMN IN FRAME fPage0 = 20.00
                 tgvalor:ROW IN FRAME fPage0 = 4.00
                 cValor:column in frame fPage0 = 20.00
                 dValor:column in frame fPage0 = 20.00
                 cbValor:column in frame fPage0 = 20.00
                 cValor:row in frame fPage0 = 3.00      
                 dValor:row in frame fPage0 = 5.00   
                 cbValor:row in frame fPage0 = 4.00. 
          ASSIGN fi-txt-val-param:HIDDEN IN FRAME fPage0 = YES.
        END.
        WHEN 44 THEN DO:
            /*Habilita campo da ficha integrada*/
          ASSIGN tgvalor:CHECKED IN FRAME fPage0 = IF mab-param.des-valor = "1":U THEN YES ELSE NO
                 cValor:hidden in frame fPage0 = YES
                 dValor:hidden in frame fPage0 = YES
                 cbValor:hidden in frame fPage0 = YES
                 tgvalor:HIDDEN IN FRAME fPage0 = NO
                 tgvalor:COLUMN IN FRAME fPage0 = 20.00
                 tgvalor:ROW IN FRAME fPage0 = 4.00
                 cValor:column in frame fPage0 = 20.00
                 dValor:column in frame fPage0 = 20.00
                 cbValor:column in frame fPage0 = 20.00
                 cValor:row in frame fPage0 = 3.00      
                 dValor:row in frame fPage0 = 5.00   
                 cbValor:row in frame fPage0 = 4.00. 
          ASSIGN fi-txt-val-param:HIDDEN IN FRAME fPage0 = YES.
        END.

        WHEN 45 THEN DO:
             assign  cValor:hidden in frame fPage0 = YES
                     dValor:hidden in frame fPage0 = YES
                     cbValor:hidden in frame fPage0 = NO
                     tgvalor:HIDDEN IN FRAME fPage0 = YES
                     cValor:column in frame fPage0 = 20.00
                     dValor:column in frame fPage0 = 20.00
                     cbValor:column in frame fPage0 = 20.00
                     cValor:row in frame fPage0 = 3.00   
                     dValor:row in frame fPage0 = 5.00   
                     cbValor:row in frame fPage0 = 4.00. 
             &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                 DEFINE VARIABLE cAuxTraducao013 AS CHARACTER NO-UNDO.
                 ASSIGN cAuxTraducao013 = {frinc/i05fr019.i 03}.
                 RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao013).
                 ASSIGN    c-lista  = cAuxTraducao013.
             &else
                 ASSIGN c-lista  = {frinc/i05fr019.i 03}.
             &endif
         END.

       WHEN 47 OR WHEN 48 OR WHEN 51 or when 52 OR WHEN 53 OR WHEN 55 OR WHEN 56 OR WHEN 57 OR WHEN 58 THEN DO:
           /*Autoriza a inativa‡Æo das partes do equipamento.*/
         ASSIGN tgvalor:CHECKED IN FRAME fPage0 = IF mab-param.des-valor = "1":U THEN YES ELSE NO
                cValor:hidden in frame fPage0 = YES
                dValor:hidden in frame fPage0 = YES
                cbValor:hidden in frame fPage0 = YES
                tgvalor:HIDDEN IN FRAME fPage0 = NO
                tgvalor:COLUMN IN FRAME fPage0 = 20.00
                tgvalor:ROW IN FRAME fPage0 = 4.00
                cValor:column in frame fPage0 = 20.00
                dValor:column in frame fPage0 = 20.00
                cbValor:column in frame fPage0 = 20.00
                cValor:row in frame fPage0 = 3.00      
                dValor:row in frame fPage0 = 5.00   
                cbValor:row in frame fPage0 = 4.00. 
         ASSIGN fi-txt-val-param:HIDDEN IN FRAME fPage0 = YES.

       END.
       WHEN 49 OR WHEN 50 THEN DO:
           assign cValor:hidden in frame fPage0 = YES
                  dValor:hidden in frame fPage0 = YES
                  cbValor:hidden in frame fPage0 = NO
                  tgvalor:HIDDEN IN FRAME fPage0 = YES
                  cValor:column in frame fPage0 = 20.00
                  dValor:column in frame fPage0 = 20.00
                  cbValor:column in frame fPage0 = 20.00
                  cValor:row in frame fPage0 = 3.00   
                  dValor:row in frame fPage0 = 5.00   
                  cbValor:row in frame fPage0 = 4.00. 
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
               DEFINE VARIABLE cAuxTraducao014 AS CHARACTER NO-UNDO.
               ASSIGN cAuxTraducao014 = {frinc/i06fr019.i 03}.
               RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao014).
               ASSIGN c-lista = cAuxTraducao014.
           &else
               ASSIGN c-lista = {frinc/i06fr019.i 03}.
           &endif

       END.
        WHEN 54 THEN DO:
           assign cValor:hidden in frame fPage0 = YES
                  dValor:hidden in frame fPage0 = YES
                  cbValor:hidden in frame fPage0 = NO
                  tgvalor:HIDDEN IN FRAME fPage0 = YES
                  cValor:column in frame fPage0 = 20.00
                  dValor:column in frame fPage0 = 20.00
                  cbValor:column in frame fPage0 = 20.00
                  cValor:row in frame fPage0 = 3.00   
                  dValor:row in frame fPage0 = 5.00   
                  cbValor:row in frame fPage0 = 4.00. 
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
               DEFINE VARIABLE cAuxTraducao054 AS CHARACTER NO-UNDO.
               ASSIGN cAuxTraducao054 = "Permite Sem Avisar,Avisa e Permite,NÆo Permite".
               RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao054).
               ASSIGN c-lista = cAuxTraducao054.
           &else 
               ASSIGN c-lista = "Permite Sem Avisar,Avisa e Permite,NÆo Permite".
           &endif 
        END.
        WHEN 56 THEN DO:
            ASSIGN tgvalor:CHECKED IN FRAME fPage0 = IF mab-param.des-valor = "1":U THEN YES ELSE NO
                   cValor:hidden in frame fPage0 = YES
                   dValor:hidden in frame fPage0 = YES
                   cbValor:hidden in frame fPage0 = YES
                   tgvalor:HIDDEN IN FRAME fPage0 = NO
                   tgvalor:COLUMN IN FRAME fPage0 = 20.00
                   tgvalor:ROW IN FRAME fPage0 = 4.00
                   cValor:column in frame fPage0 = 20.00
                   dValor:column in frame fPage0 = 20.00
                   cbValor:column in frame fPage0 = 20.00
                   cValor:row in frame fPage0 = 3.00      
                   dValor:row in frame fPage0 = 5.00   
                   cbValor:row in frame fPage0 = 4.00. 
            ASSIGN fi-txt-val-param:HIDDEN IN FRAME fPage0 = YES.
        END.
    END CASE.


    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE pParam:
    WHEN 17 OR 
    WHEN 18 OR
    WHEN 19 or
    when 20 or
    when 23 or
    when 21 or
    when 27 or
    when 29 or 
    when 30 or 
    when 37 or
    when 38 OR 
    WHEN 40 OR 
    WHEN 41 THEN DO:

        cValor:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.

end.

             WHEN 37 THEN DO:
                cValor:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
                cValor1:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
                cValor2:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage0.
             END.
        END CASE.

 IF NOT VALID-HANDLE(hDBOParam) OR
         hDBOParam:TYPE <> "PROCEDURE":U OR
       hDBOParam:FILE-NAME <> "frbo/bofr019.p":U THEN DO:
      run frbo/bofr019.p persistent set  hDBOParam.
   END.
   RUN OpenQueryStatic IN hDBOParam (INPUT "Main":U) NO-ERROR.



IF NOT VALID-HANDLE(hDBOSubSist) OR
        hDBOSubSist:TYPE <> "PROCEDURE":U OR
      hDBOSubSist:FILE-NAME <> "frbo/bofr025.p":U THEN DO:
     run frbo/bofr025.p persistent set  hDBOSubSist.
  END.
  RUN OpenQueryStatic IN hDBOSubSist (INPUT "Main":U) NO-ERROR.


IF NOT VALID-HANDLE(hDBOEvent) OR
        hDBOEvent:TYPE <> "PROCEDURE":U OR
      hDBOEvent:FILE-NAME <> "frbo/bofr010.p":U THEN DO:
     run frbo/bofr010.p persistent set  hDBOEvent.
  END.
  RUN OpenQueryStatic IN hDBOEvent (INPUT "Main":U) NO-ERROR.


IF NOT VALID-HANDLE(hDBOTipoManut) OR
        hDBOTipoManut:TYPE <> "PROCEDURE":U OR
      hDBOTipoManut:FILE-NAME <> "mnbo/bomn158.p":U THEN DO:
     run mnbo/bomn158.p persistent set  hDBOTipoManut.
  END.
  RUN OpenQueryStatic IN hDBOTipoManut (INPUT "Default":U) NO-ERROR.


  IF NOT VALID-HANDLE(hDBOMotorista) OR
          hDBOMotorista:TYPE <> "PROCEDURE":U OR
        hDBOMotorista:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
       run frbo/bofr017.p persistent set  hDBOMotorista.
    END.
    RUN OpenQueryStatic IN hDBOMotorista (INPUT "Main":U) NO-ERROR.
    
    IF NOT VALID-HANDLE(hDBOTrajeto) OR
            hDBOTrajeto:TYPE <> "PROCEDURE":U OR
          hDBOTrajeto:FILE-NAME <> "frbo/bofr028.p":U THEN DO:
         run frbo/bofr028.p persistent set  hDBOTrajeto.
      END.
      RUN OpenQueryStatic IN hDBOTrajeto (INPUT "Main":U) NO-ERROR.


  IF NOT VALID-HANDLE(hDBOEmp) OR
          hDBOEmp:TYPE <> "PROCEDURE":U OR
        hDBOEmp:FILE-NAME <> "mnbo/bomn158.p":U THEN DO:
       run mnbo/bomn158.p persistent set  hDBOEmp.
    END.
    RUN OpenQueryStatic IN hDBOEmp (INPUT "Default":U) NO-ERROR.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-cod-rota wWindow 
PROCEDURE pi-busca-cod-rota :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{method/referenceFields.i
    &HandleDBOLeave="hDBOTrajeto"
    &KeyValue1="cValor:screen-value in frame fPage0"
    &FieldName1="cod-rota"
    &FieldScreen1="cValor"
    &Frame1="fPage0"}
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-sub-sist wWindow 
PROCEDURE pi-busca-sub-sist :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{method/referenceFields.i
    &HandleDBOLeave="hDBOSubSist"
    &KeyValue1="cValor:screen-value in frame fPage0"
    &FieldName1="cod-sub-sist"
    &FieldScreen1="cValor"
    &Frame1="fPage0"}
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-tp-manut wWindow 
PROCEDURE pi-busca-tp-manut :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{method/referenceFields.i
    &HandleDBOLeave="hDBOTipoManut"
    &KeyValue1="cValor:screen-value in frame fPage0"
    &FieldName1="cd-tipo"
    &FieldScreen1="cValor"
    &Frame1="fPage0"}
    
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valor wWindow 
PROCEDURE pi-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
CASE pParam:
    WHEN 7 THEN DO:
        assign cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    WHEN 8 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 =  c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    WHEN 9 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 =  c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    WHEN 10 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam  (INPUT pParam,
                                          INPUT cDescParam:screen-value in frame fPage0,
                                          INPUT cText:screen-value in frame fPage0,
                                          INPUT-OUTPUT pValor2).
    end.
    WHEN 11 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    WHEN 12 OR WHEN 49 OR WHEN 50 OR WHEN 54 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
        
    end.
    WHEN 13 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    end.
    WHEN 17 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    end.
    WHEN 18 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam  (INPUT pParam,
                                          INPUT cDescParam:screen-value in frame fPage0,
                                          INPUT cText:screen-value in frame fPage0,
                                          INPUT-OUTPUT pValor1).
    end.
    WHEN 19 OR
    when 38 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    end.
    WHEN 20 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    end.
    WHEN 21 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    end.
    WHEN 23 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    end.
    WHEN 24 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    WHEN 25 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    WHEN 26 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    END.
    WHEN 27 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    END.
    WHEN 28 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    END.
    WHEN 29 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    END.
    WHEN 35 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    END.
    when 37 THEN DO:
        assign pValor1 =  INPUT FRAME fPage0 cValor1 + "," +
                          INPUT FRAME fPage0 cValor2 + "," +
                          INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    END.
    WHEN 36 OR WHEN 39 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    END.
    /**Atualizando valores de parametro do cod 40 **/
    WHEN 40 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    END.
    /**Atualizando valores de parametro 41 - Evento PadrÆo de Transferˆncia **/
    WHEN 41 THEN DO:
        assign pValor1 = INPUT FRAME fPage0 cValor.
        RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor1).
    END.
    WHEN 45 THEN DO:
        ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbValor:sensitive    in frame fPage0 = yes
               cbValor:screen-value in frame fPage0 = IF AVAIL mab-param THEN ENTRY(INT(mab-param.des-valor),c-lista,",") ELSE cbValor:entry(1)
               pValor2 = cbValor:lookup(cbValor:screen-value in frame fPage0).
        RUN atualizaValor2 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor2).
    end.
    OTHERWISE DO:
        assign pValor3 = INPUT FRAME fPage0 dValor.
        RUN atualizaValor3 IN hDBOParam   (INPUT pParam,
                                           INPUT cDescParam:screen-value in frame fPage0,
                                           INPUT cText:screen-value in frame fPage0,
                                           INPUT-OUTPUT pValor3).
    END.
END CASE.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wWindow 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------  
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in hDBOParam (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in hDBOParam.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

