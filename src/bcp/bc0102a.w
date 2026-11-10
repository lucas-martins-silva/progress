&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttBcLayout NO-UNDO LIKE bc-layout
            FIELD RowNum AS INTEGER INITIAL 1
            FIELD r-Rowid AS ROWID
            INDEX iSeq AS PRIMARY RowNum.

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0102A 2.00.00.006} /*** "010006" 14/03/2024 13:51:48 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i BC0102A MBC}
&ENDIF

&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcld            PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
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
&GLOBAL-DEFINE Program           BC0102A
&GLOBAL-DEFINE Version           2.00.00.006

&GLOBAL-DEFINE Folder            NO
&GLOBAL-DEFINE InitialPage       

&GLOBAL-DEFINE FolderLabels      

&GLOBAL-DEFINE ttTable           ttBcLayout
&GLOBAL-DEFINE hDBOTable         hDBOBcLayout
&GLOBAL-DEFINE DBOTable          Bc-Layout

&GLOBAL-DEFINE page0KeyFields    ttBcLayout.Cod-Layout
&GLOBAL-DEFINE page0Fields       ttBcLayout.Descricao
&GLOBAL-DEFINE page0ParentFields 
&GLOBAL-DEFINE page1Fields       
&GLOBAL-DEFINE page2Fields       

{cdp/cdcfgint.i}
&glob SeparadorLinhas   Separador-Linhas


/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cLayout             AS CHARACTER    FORMAT "X(500)":U  NO-UNDO.
DEFINE VARIABLE cDescricao          AS CHARACTER    FORMAT "X(1000)":U NO-UNDO.
DEFINE VARIABLE iCont               AS INTEGER                         NO-UNDO.
DEFINE VARIABLE lMethod             AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE iNumVersao          AS INTEGER                         NO-UNDO.
DEFINE VARIABLE iCodLayout          AS INTEGER                         NO-UNDO.
DEFINE VARIABLE iCodLayoutCopy      AS INTEGER                         NO-UNDO.
DEFINE VARIABLE lLogDatasulCopy     AS LOGICAL                         NO-UNDO.
DEFINE VARIABLE iNumVersaoCopy      AS INTEGER                         NO-UNDO.
DEFINE VARIABLE iCodTipoLayoutCopy  AS INTEGER                         NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}         AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOBcTipoLayout     AS HANDLE NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE NO

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttBcLayout.cod-layout ttBcLayout.num-versao ~
ttBcLayout.descricao ttBcLayout.ind-leitura-campo 
&Scoped-define ENABLED-TABLES ttBcLayout
&Scoped-define FIRST-ENABLED-TABLE ttBcLayout
&Scoped-define DISPLAYED-TABLES ttBcLayout
&Scoped-define FIRST-DISPLAYED-TABLE ttBcLayout
&Scoped-Define ENABLED-OBJECTS fi-ind-leitura-campos fi-separador-campos ~
cbTipoLayout cSeparadorLinhas cSeparadorCampos btOK btSave btCancel btHelp ~
RECT-4 RECT-5 RECT-6 rtParent rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttBcLayout.cod-layout ttBcLayout.num-versao ~
ttBcLayout.descricao ttBcLayout.ind-leitura-campo 
&Scoped-Define DISPLAYED-OBJECTS fi-ind-leitura-campos fi-separador-campos ~
cbTipoLayout cSeparadorLinhas cSeparadorCampos 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cbTipoLayout AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "Tipo Layout" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "0",0
     DROP-DOWN-LIST
     SIZE 30 BY 1 NO-UNDO.

DEFINE VARIABLE cSeparadorCampos AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE cSeparadorLinhas AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ind-leitura-campos AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 20 BY .67 NO-UNDO.

DEFINE VARIABLE fi-separador-campos AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 15 BY .67 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 7.25.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 32 BY 4.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34 BY 4.5.

DEFINE RECTANGLE rtParent
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 2.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-ind-leitura-campos AT ROW 5.75 COL 22 COLON-ALIGNED NO-LABEL
     ttBcLayout.cod-layout AT ROW 1.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     ttBcLayout.num-versao AT ROW 2.17 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     fi-separador-campos AT ROW 5.75 COL 55 COLON-ALIGNED NO-LABEL
     ttBcLayout.descricao AT ROW 3.75 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 36.86 BY .88
     cbTipoLayout AT ROW 4.75 COL 22 COLON-ALIGNED
     ttBcLayout.ind-leitura-campo AT ROW 6.29 COL 24 NO-LABEL
          VIEW-AS RADIO-SET VERTICAL
          RADIO-BUTTONS 
            "Nenhum", 1,
            "Tamanho Fixo", 2,
            "Separador", 3,
            "Identificadores", 4,
            "PadrÆo AIM Brasil", 5
          SIZE 26 BY 3.96
     cSeparadorLinhas AT ROW 7.25 COL 68 COLON-ALIGNED
     cSeparadorCampos AT ROW 8.25 COL 68 COLON-ALIGNED
     btOK AT ROW 11.25 COL 2
     btSave AT ROW 11.25 COL 13
     btCancel AT ROW 11.25 COL 24
     btHelp AT ROW 11.25 COL 80
     RECT-4 AT ROW 3.5 COL 1
     RECT-5 AT ROW 6 COL 22
     RECT-6 AT ROW 6 COL 55
     rtParent AT ROW 1 COL 1
     rtToolBar AT ROW 11 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 11.67
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: ttBcLayout T "?" NO-UNDO mgcld bc-layout
      ADDITIONAL-FIELDS:
          FIELD RowNum AS INTEGER INITIAL 1
          FIELD r-Rowid AS ROWID
          INDEX iSeq AS PRIMARY RowNum
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 11.71
         WIDTH              = 90
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 90
         RESIZE             = YES
         SCROLL-BARS        = NO
         STATUS-AREA        = YES
         BGCOLOR            = ?
         FGCOLOR            = ?
         KEEP-FRAME-Z-ORDER = YES
         THREE-D            = YES
         MESSAGE-AREA       = NO
         SENSITIVE          = YES.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = YES.

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

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
   /* This case occurs when the user presses the "Esc" key.
      In a persistently run window, just ignore this.  If we did not, the
      application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
   /* This event will close the window and terminate the procedure.  */
   APPLY "CLOSE":U TO THIS-PROCEDURE.
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
   APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
   {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
   DEFINE VARIABLE hDBOValid AS HANDLE NO-UNDO.

   RUN saveRecord IN THIS-PROCEDURE.
   IF RETURN-VALUE = "OK":U THEN DO:
      IF pcAction = "COPY":U AND iCodTipoLayoutCopy  = INPUT FRAME fPage0 cbTipoLayout THEN DO:
         RUN clbo/bocl024.p PERSISTENT SET hDBOValid.
         RUN openQueryStatic IN hDBOValid (INPUT "Main":U) NO-ERROR.
         RUN copiaBcLayoutRegistro IN hDBOValid (iCodLayoutCopy,
                                                 lLogDatasulCopy,
                                                 iNumVersaoCopy,
                                                 INPUT FRAME fPage0 ttBcLayout.cod-layout,
                                                 NO,
                                                 INPUT FRAME fPage0 ttBcLayout.num-versao).

         IF VALID-HANDLE(hDBOValid) THEN
            RUN destroy IN hDBOValid.
         
         RUN afterDisplayFields IN phCaller NO-ERROR.
      END.
      APPLY "CLOSE":U TO THIS-PROCEDURE.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
   RUN saveRecord IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cbTipoLayout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cbTipoLayout wMaintenanceNoNavigation
ON VALUE-CHANGED OF cbTipoLayout IN FRAME fpage0 /* Tipo Layout */
DO:
   IF cbtipolayout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '3':U /* tipo Controle Etiqueta */ THEN DO:
      ASSIGN ttBcLayout.Ind-Leitura-Campo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = '1':U.
      DISABLE ttBcLayout.Ind-Leitura-Campo WITH FRAME {&FRAME-NAME}.
   END.
   ELSE DO:
      ENABLE ttBcLayout.Ind-Leitura-Campo WITH FRAME {&FRAME-NAME}.
   END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcLayout.cod-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcLayout.cod-layout wMaintenanceNoNavigation
ON LEAVE OF ttBcLayout.cod-layout IN FRAME fpage0 /* Layout */
DO:
   RUN returnNextVersion IN {&hDBOTable} (INPUT FRAME fPage0 ttBcLayout.cod-layout, 
                                          NO, /* log-datasul */
                                          OUTPUT iNumVersao).

   ASSIGN ttBcLayout.num-versao:SCREEN-VALUE IN FRAME fPage0 = STRING(iNumVersao).  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttBcLayout.ind-leitura-campo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttBcLayout.ind-leitura-campo wMaintenanceNoNavigation
ON VALUE-CHANGED OF ttBcLayout.ind-leitura-campo IN FRAME fpage0
DO:
   IF INPUT FRAME fPage0 ttBcLayout.Ind-Leitura-Campo <> 3 THEN DO:
      ASSIGN cSeparadorCampos:SCREEN-VALUE IN FRAME fPage0 = "":U
             cSeparadorLinhas:SCREEN-VALUE IN FRAME fPage0 = "":U.
      
      DISABLE cSeparadorCampos
              cSeparadorLinhas
         WITH FRAME fPage0.
   END.
   ELSE 
      ENABLE cSeparadorCampos
             cSeparadorLinhas
         WITH FRAME fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*--- L¢gica para inicializa‡Æo do programam ---*/
{maintenancenonavigation/MainBlock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF VALID-HANDLE(hDBOBcTipoLayout) THEN
      RUN destroy IN hDBOBcTipoLayout.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   ENABLE cbTipoLayout ttBcLayout.Ind-Leitura-Campo WITH FRAME fPage0.
   DISPLAY fi-ind-leitura-campos fi-separador-campos WITH FRAME fPage0.

   IF pcAction = "ADD":U THEN DO:
      RUN returnNextLayout IN {&hDBOTable} (OUTPUT iCodLayout).
      ASSIGN ttBcLayout.cod-layout:SCREEN-VALUE IN FRAME fPage0        = STRING(iCodLayout)
             ttBcLayout.num-versao:SCREEN-VALUE IN FRAME fPage0        = STRING(1)
             ttBcLayout.ind-leitura-campo:SCREEN-VALUE IN FRAME fPage0 = STRING(1)
             cbTipoLayout:SCREEN-VALUE IN FRAME fPage0                 = ENTRY(1,cLayout).
   END.

   IF pcAction = "UPDATE":U OR pcAction = "COPY":U  THEN DO:
      ASSIGN ttBcLayout.num-versao:SCREEN-VALUE IN FRAME fPage0        = STRING(ttBcLayout.num-versao)
             cbTipoLayout:SCREEN-VALUE IN FRAME fPage0                 = STRING(ttBcLayout.Cod-Tipo-Layout)
             cSeparadorCampos:SCREEN-VALUE IN FRAME fPage0             = ttBcLayout.separador-campos
             cSeparadorLinhas:SCREEN-VALUE IN FRAME fPage0             = ttBcLayout.{&SeparadorLinhas}
             ttBcLayout.ind-leitura-campo:SCREEN-VALUE IN FRAME fPage0 = STRING(ttBcLayout.ind-leitura-campo).
      
      APPLY "VALUE-CHANGED":U TO cbtipolayout IN FRAME {&FRAME-NAME}.
   END.
   
   IF pcAction = "COPY":U THEN DO:
      /* Valores Iniciais do Layout */
      ASSIGN iCodTipoLayoutCopy   = ttBcLayout.cod-tipo-layout
             iCodLayoutCopy       = ttBcLayout.cod-layout
             lLogDatasulCopy      = ttBcLayout.log-datasul
             iNumVersaoCopy       = ttBcLayout.num-versao.

      RUN returnNextVersion IN {&hDBOTable} (INPUT ttBcLayout.cod-layout, 
                                             INPUT NO, /*log-datasul */ 
                                             OUTPUT iNumVersao).

      ASSIGN ttBcLayout.num-versao:SCREEN-VALUE IN FRAME fPage0 = STRING(iNumVersao).
   END.

   APPLY "VALUE-CHANGED":U TO ttBcLayout.ind-leitura-campo IN FRAME fPage0.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterSaveFields wMaintenanceNoNavigation 
PROCEDURE afterSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   IF AVAIL ttBcLayout THEN DO:
      IF pcAction = "ADD":U OR pcAction = "COPY":U THEN
          ASSIGN ttBcLayout.log-datasul = NO
                 INPUT FRAME fPage0 ttBcLayout.num-versao.

      ASSIGN INPUT FRAME fPage0 ttBcLayout.ind-leitura-campo
             ttBcLayout.Cod-Tipo-Layout    = INPUT FRAME fPage0 cbTipoLayout
             ttBcLayout.separador-campos   = INPUT FRAME fPage0 cSeparadorCampos
             ttBcLayout.{&SeparadorLinhas} = INPUT FRAME fPage0 cSeparadorLinhas.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   {utp/ut-liter.i Tipo_Tratamento MBC R}
   ASSIGN fi-ind-leitura-campos = RETURN-VALUE.

   {utp/ut-liter.i Separadores}
   ASSIGN fi-separador-campos = RETURN-VALUE.

   {utp/ut-liter.i Campos}
   ASSIGN cSeparadorCampos:LABEL IN FRAME fPage0 = RETURN-VALUE.
   
   {utp/ut-liter.i Linhas}
   ASSIGN cSeparadorLinhas:LABEL IN FRAME fPage0 = RETURN-VALUE.

   {btb/btb008za.i1 clbo/bocl026.p YES}
   {btb/btb008za.i2 clbo/bocl026.p '' hDBOBcTipoLayout}

   RUN openQueryStatic IN THIS-PROCEDURE (INPUT "Main":U) NO-ERROR.

   /* monta combo-box de Tipo Layout e posiciona no no item correspodente */
   RUN returnValues IN hDBOBcTipoLayout (OUTPUT cLayout, 
                                         OUTPUT cDescricao).

   ASSIGN lMethod = cbTipoLayout:DELETE("0") IN FRAME fPage0 NO-ERROR.
   DO iCont = 1 TO NUM-ENTRIES(cLayout):
       ASSIGN lMethod = cbTipoLayout:ADD-LAST(ENTRY(iCont,cDescricao), INTEGER(ENTRY(iCont,cLayout))) IN FRAME fPage0.
   END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveParentFields wMaintenanceNoNavigation 
PROCEDURE saveParentFields :
/*------------------------------------------------------------------------------
  Purpose:     Salva valores dos campos da tabela filho ({&ttTable}) com base 
               nos campos da tabela pai ({&ttParent})
  Parameters:  
  Notes:       Este m‚todo somente ‚ executado quando a vari vel pcAction 
               possuir os valores ADD ou COPY
------------------------------------------------------------------------------*/
    
   RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
