&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&Scoped-define FRAME-NAME bc0116c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS bc0116c 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0116C 2.00.00.011 } /*** "010011" 31/08/2023 15:08:03  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
   {include/i-license-manager.i bc0116c MBC}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{bcp/bc0116c.i} /* Os m‚todos utilizados nessa tela estÆo nessa include */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartVaPara
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME bc0116c

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-3 IMAGE-4 RECT-10 RECT-6 RECT-8 RECT-9 ~
rt-button RECT-7 RECT-11 RECT-12 RECT-13 RECT-14 RECT-15 c-inicial c-final ~
tg-tp-ler-inventario tg-tp-ler-pk-area-pk vl-ini-tp-ler-inventario ~
vl-ini-tp-ler-pk-area-pk tg-sub-tp-ler-pk-area-pk tg-tp-ler-pk-area-n ~
tg-sub-tp-ler-inventario vl-ini-tp-ler-pk-area-n tg-sub-tp-ler-pk-area-n ~
tg-tp-ler-impressao vl-ini-tp-ler-impressao tg-le-endereco-doca ~
tg-sub-tp-ler-impressao tg-tp-ler-arm-tarefa vl-ini-tp-ler-arm-tarefa ~
tg-gera-hist-etiq tg-sub-tp-ler-arm-tarefa tg-sub-gera-hist-etiq ~
tg-tp-ler-devol-pk tg-tp-ler-unidade vl-ini-tp-ler-devol-pk ~
tg-sub-tp-ler-devol-pk tg-tp-ler-visu-qtde vl-ini-tp-ler-visu ~
tg-tp-picking-packing tg-ler-endereco-item tg-picking tg-dev-pik ~
tg-ler-etiq-pack tg-pik-pak tg-arm tg-ler-tarefa-proc tg-sub-geral ~
tg-sub-params-pick-pack bt-ok bt-cancela 
&Scoped-Define DISPLAYED-OBJECTS c-inicial c-final tg-tp-ler-inventario ~
tg-tp-ler-pk-area-pk vl-ini-tp-ler-inventario vl-ini-tp-ler-pk-area-pk ~
tg-sub-tp-ler-pk-area-pk tg-tp-ler-pk-area-n tg-sub-tp-ler-inventario ~
vl-ini-tp-ler-pk-area-n tg-sub-tp-ler-pk-area-n tg-tp-ler-impressao ~
vl-ini-tp-ler-impressao tg-le-endereco-doca tg-sub-tp-ler-impressao ~
tg-tp-ler-arm-tarefa vl-ini-tp-ler-arm-tarefa tg-gera-hist-etiq ~
tg-sub-tp-ler-arm-tarefa tg-sub-gera-hist-etiq tg-tp-ler-devol-pk ~
tg-tp-ler-unidade vl-ini-tp-ler-devol-pk tg-sub-tp-ler-devol-pk ~
tg-tp-ler-visu-qtde vl-ini-tp-ler-visu tg-tp-picking-packing ~
tg-ler-endereco-item tg-picking tg-dev-pik tg-ler-etiq-pack tg-pik-pak ~
tg-arm tg-ler-tarefa-proc tg-sub-geral tg-sub-params-pick-pack 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define a dialog box                                                  */

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-cancela AUTO-END-KEY 
     LABEL "&Cancelar" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE BUTTON bt-ok AUTO-GO 
     LABEL "&OK" 
     SIZE 10 BY 1
     BGCOLOR 8 .

DEFINE VARIABLE c-final AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-inicial AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-3
     FILENAME "image/im-fir":U
     SIZE 3.57 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image/im-las":U
     SIZE 3.14 BY .88.

DEFINE VARIABLE vl-ini-tp-ler-arm-tarefa AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
      "Pedir em Tela", 1,
      "Por  Quantidade", 2,
      "Por EAN/DUM", 3,
      "Por Emb/Un", 4
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE vl-ini-tp-ler-devol-pk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
      "Pedir em Tela", 1,
      "Por  Quantidade", 2,
      "Por EAN/DUM", 3,
      "Por Emb/Un", 4
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE vl-ini-tp-ler-impressao AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
      "Por Quantidade", 2,
      "Por Emb/Un", 4
     SIZE 18 BY 1.5 NO-UNDO.

DEFINE VARIABLE vl-ini-tp-ler-inventario AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
      "Pedir em Tela", 1,
      "Por Quantidade", 2,
      "Por Emb/Un", 4
     SIZE 18 BY 2.25 NO-UNDO.

DEFINE VARIABLE vl-ini-tp-ler-pk-area-n AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
      "Pedir em Tela", 1,
      "Por  Quantidade", 2,
      "Por EAN/DUM", 3,
      "Por Emb/Un", 4
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE vl-ini-tp-ler-pk-area-pk AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
      "Pedir em Tela", 1,
      "Por  Quantidade", 2,
      "Por EAN/DUM", 3,
      "Por Emb/Un", 4
     SIZE 65 BY 1 NO-UNDO.

DEFINE VARIABLE vl-ini-tp-ler-visu AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
      "Por Quantidade", 2,
      "Por Emb/Un", 4
     SIZE 18 BY 1.5 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 4.58.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 4.88.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 3.92.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 7.5.

DEFINE RECTANGLE RECT-14
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 38 BY 6.

DEFINE RECTANGLE RECT-15
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 40 BY 2.21.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 7.88.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 67 BY 6.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.96.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 70 BY 2.83.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 113 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-arm AS LOGICAL INITIAL YES 
     LABEL "Armazenamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-dev-pik AS LOGICAL INITIAL YES 
     LABEL "Devol. Picking" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-gera-hist-etiq AS LOGICAL INITIAL NO 
     LABEL "Gera Hist¢rico" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-le-endereco-doca AS LOGICAL INITIAL NO 
     LABEL "Solicitar Leitura Endere‡o da Doca" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ler-endereco-item AS LOGICAL INITIAL YES 
     LABEL "Ler Endere‡o do Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 52.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ler-etiq-pack AS LOGICAL INITIAL NO 
     LABEL "Ler Etiqueta Packing para Itens que nÆo sofrem Packing" 
     VIEW-AS TOGGLE-BOX
     SIZE 54.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-ler-tarefa-proc AS LOGICAL INITIAL NO 
     LABEL "Ler Tarefas em Processo do Usu rio como P£blicas" 
     VIEW-AS TOGGLE-BOX
     SIZE 54.14 BY .83 NO-UNDO.

DEFINE VARIABLE tg-picking AS LOGICAL INITIAL YES 
     LABEL "Picking" 
     VIEW-AS TOGGLE-BOX
     SIZE 10.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-pik-pak AS LOGICAL INITIAL YES 
     LABEL "Picking/Paking" 
     VIEW-AS TOGGLE-BOX
     SIZE 17 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-gera-hist-etiq AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-geral AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-params-pick-pack AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 34 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tp-ler-arm-tarefa AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tp-ler-devol-pk AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tp-ler-impressao AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tp-ler-inventario AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tp-ler-pk-area-n AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 39 BY .83 NO-UNDO.

DEFINE VARIABLE tg-sub-tp-ler-pk-area-pk AS LOGICAL INITIAL NO 
     LABEL "Substituir Parƒmetros Existentes" 
     VIEW-AS TOGGLE-BOX
     SIZE 35.86 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-arm-tarefa AS LOGICAL INITIAL YES 
     LABEL "Tipo de Leitura da Quantidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 37 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-devol-pk AS LOGICAL INITIAL YES 
     LABEL "Tipo de Leitura da Quantidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 50 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-impressao AS LOGICAL INITIAL YES 
     LABEL "Tipo de Leitura da Quantidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-inventario AS LOGICAL INITIAL YES 
     LABEL "Tipo de Leitura da Quantidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 32 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-pk-area-n AS LOGICAL INITIAL YES 
     LABEL "Tipo de Leitura da Quantidade na µrea de Normal" 
     VIEW-AS TOGGLE-BOX
     SIZE 52 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-pk-area-pk AS LOGICAL INITIAL YES 
     LABEL "Tipo de Leitura da Quantidade na µrea de Picking" 
     VIEW-AS TOGGLE-BOX
     SIZE 52 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-unidade AS LOGICAL INITIAL NO 
     LABEL "Habilita Unidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-ler-visu-qtde AS LOGICAL INITIAL YES 
     LABEL "Tipo Visualiza‡Æo Quantidade" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83 NO-UNDO.

DEFINE VARIABLE tg-tp-picking-packing AS LOGICAL INITIAL YES 
     LABEL "Parametrizar Picking ~\ Packing Simultƒneos" 
     VIEW-AS TOGGLE-BOX
     SIZE 56.72 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME bc0116c
     c-inicial AT ROW 1.63 COL 32.72 COLON-ALIGNED HELP
          "Item inicial"
     c-final AT ROW 1.63 COL 63.29 COLON-ALIGNED HELP
          "Item final" NO-LABEL
     tg-tp-ler-inventario AT ROW 3.63 COL 75
     tg-tp-ler-pk-area-pk AT ROW 3.92 COL 5
     vl-ini-tp-ler-inventario AT ROW 4.58 COL 92 RIGHT-ALIGNED NO-LABEL
     vl-ini-tp-ler-pk-area-pk AT ROW 4.67 COL 69 RIGHT-ALIGNED NO-LABEL
     tg-sub-tp-ler-pk-area-pk AT ROW 5.58 COL 5
     tg-tp-ler-pk-area-n AT ROW 6.96 COL 5
     tg-sub-tp-ler-inventario AT ROW 7 COL 75
     vl-ini-tp-ler-pk-area-n AT ROW 7.71 COL 69 RIGHT-ALIGNED NO-LABEL
     tg-sub-tp-ler-pk-area-n AT ROW 8.63 COL 5
     tg-tp-ler-impressao AT ROW 8.83 COL 75
     vl-ini-tp-ler-impressao AT ROW 9.79 COL 92.14 RIGHT-ALIGNED NO-LABEL
     tg-le-endereco-doca AT ROW 9.96 COL 5
     tg-sub-tp-ler-impressao AT ROW 11.42 COL 75
     tg-tp-ler-arm-tarefa AT ROW 12 COL 5
     vl-ini-tp-ler-arm-tarefa AT ROW 12.79 COL 69 RIGHT-ALIGNED NO-LABEL
     tg-gera-hist-etiq AT ROW 13.63 COL 75 WIDGET-ID 6
     tg-sub-tp-ler-arm-tarefa AT ROW 13.75 COL 5
     tg-sub-gera-hist-etiq AT ROW 14.5 COL 75 WIDGET-ID 8
     tg-tp-ler-devol-pk AT ROW 15.71 COL 5
     tg-tp-ler-unidade AT ROW 16.21 COL 75
     vl-ini-tp-ler-devol-pk AT ROW 16.46 COL 69 RIGHT-ALIGNED NO-LABEL
     tg-sub-tp-ler-devol-pk AT ROW 17.38 COL 5
     tg-tp-ler-visu-qtde AT ROW 17.42 COL 75
     vl-ini-tp-ler-visu AT ROW 18.42 COL 92 RIGHT-ALIGNED NO-LABEL
     tg-tp-picking-packing AT ROW 19.29 COL 5
     tg-ler-endereco-item AT ROW 20 COL 7.86
     tg-picking AT ROW 20.17 COL 75
     tg-dev-pik AT ROW 20.17 COL 92
     tg-ler-etiq-pack AT ROW 20.79 COL 7.86
     tg-pik-pak AT ROW 21.04 COL 75
     tg-arm AT ROW 21.08 COL 92
     tg-ler-tarefa-proc AT ROW 21.67 COL 7.86
     tg-sub-geral AT ROW 22.04 COL 75
     tg-sub-params-pick-pack AT ROW 22.42 COL 5
     bt-ok AT ROW 23.96 COL 2.14
     bt-cancela AT ROW 23.96 COL 13
     "Parƒmetros Gerais" VIEW-AS TEXT
          SIZE 18 BY .67 AT ROW 15.5 COL 75
     "Hist¢rico Etiquetas" VIEW-AS TEXT
          SIZE 16 BY .67 AT ROW 12.83 COL 75 WIDGET-ID 4
     "Picking" VIEW-AS TEXT
          SIZE 7 BY .67 AT ROW 2.83 COL 4
     "Devolu‡Æo de Picking" VIEW-AS TEXT
          SIZE 20 BY .67 AT ROW 15.04 COL 4
     "ImpressÆo de Etiquetas" VIEW-AS TEXT
          SIZE 22 BY .67 AT ROW 8.21 COL 75
     "Picking ~\ Packing" VIEW-AS TEXT
          SIZE 16 BY .67 AT ROW 18.46 COL 4
     "Armazenamento por Tarefa" VIEW-AS TEXT
          SIZE 25 BY .67 AT ROW 11.33 COL 4
     "Invent rio" VIEW-AS TEXT
          SIZE 10 BY .67 AT ROW 2.75 COL 75
     IMAGE-3 AT ROW 1.63 COL 56.57
     IMAGE-4 AT ROW 1.63 COL 61.29
     RECT-10 AT ROW 18.83 COL 2
     RECT-6 AT ROW 3.13 COL 2
     RECT-8 AT ROW 11.75 COL 2
     RECT-9 AT ROW 15.5 COL 2
     rt-button AT ROW 23.75 COL 1
     RECT-7 AT ROW 3.75 COL 4
     RECT-11 AT ROW 3.13 COL 73
     RECT-12 AT ROW 8.67 COL 73
     RECT-13 AT ROW 15.92 COL 73
     RECT-14 AT ROW 17.17 COL 74
     RECT-15 AT ROW 13.17 COL 73 WIDGET-ID 2
     SPACE(1.00) SKIP(9.94)
    WITH VIEW-AS DIALOG-BOX KEEP-TAB-ORDER 
         SIDE-LABELS NO-UNDERLINE THREE-D  SCROLLABLE 
         TITLE "Inicializa‡Æo Parametros PadrÆo"
         DEFAULT-BUTTON bt-ok CANCEL-BUTTON bt-cancela.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartVaPara
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB bc0116c 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/d-vapara.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR DIALOG-BOX bc0116c
   FRAME-NAME L-To-R                                                    */
ASSIGN 
       FRAME bc0116c:SCROLLABLE       = FALSE
       FRAME bc0116c:HIDDEN           = TRUE.

/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-arm-tarefa IN FRAME bc0116c
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-devol-pk IN FRAME bc0116c
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-impressao IN FRAME bc0116c
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-inventario IN FRAME bc0116c
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-pk-area-n IN FRAME bc0116c
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-pk-area-pk IN FRAME bc0116c
   ALIGN-R                                                              */
/* SETTINGS FOR RADIO-SET vl-ini-tp-ler-visu IN FRAME bc0116c
   ALIGN-R                                                              */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK DIALOG-BOX bc0116c
/* Query rebuild information for DIALOG-BOX bc0116c
     _Options          = "SHARE-LOCK"
     _Query            is NOT OPENED
*/  /* DIALOG-BOX bc0116c */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bc0116c
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bc0116c bc0116c
ON WINDOW-CLOSE OF FRAME bc0116c /* Inicializa‡Æo Parametros PadrÆo */
DO:  
   /* Add Trigger to equate WINDOW-CLOSE to END-ERROR. */
   APPLY "END-ERROR":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-ok
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-ok bc0116c
ON CHOOSE OF bt-ok IN FRAME bc0116c /* OK */
DO:
   RUN pi-executar.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK bc0116c 


/* ***************************  Main Block  *************************** */



{src/adm/template/dialogmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects bc0116c  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available bc0116c  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

   /* Define variables needed by this internal procedure.             */
   {src/adm/template/row-head.i}

   /* Process the newly available records (i.e. display fields,
      open queries, and/or pass records on to any RECORD-TARGETS).    */
   {src/adm/template/row-end.i}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI bc0116c  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
   /* Hide all frames. */
   HIDE FRAME bc0116c.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI bc0116c  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
   DISPLAY c-inicial
           c-final
           tg-tp-ler-inventario
           tg-tp-ler-pk-area-pk 
           vl-ini-tp-ler-inventario
           vl-ini-tp-ler-pk-area-pk 
           tg-sub-tp-ler-pk-area-pk
           tg-tp-ler-pk-area-n
           tg-sub-tp-ler-inventario 
           vl-ini-tp-ler-pk-area-n
           tg-sub-tp-ler-pk-area-n
           tg-tp-ler-impressao 
           vl-ini-tp-ler-impressao
           tg-le-endereco-doca
           tg-sub-tp-ler-impressao 
           tg-tp-ler-arm-tarefa
           vl-ini-tp-ler-arm-tarefa
           tg-gera-hist-etiq 
           tg-sub-tp-ler-arm-tarefa
           tg-sub-gera-hist-etiq
           tg-tp-ler-devol-pk 
           tg-tp-ler-unidade
           vl-ini-tp-ler-devol-pk
           tg-sub-tp-ler-devol-pk 
           tg-tp-ler-visu-qtde
           vl-ini-tp-ler-visu
           tg-tp-picking-packing 
           tg-ler-endereco-item
           tg-picking
           tg-dev-pik
           tg-ler-etiq-pack
           tg-pik-pak 
           tg-arm tg-ler-tarefa-proc
           tg-sub-geral
           tg-sub-params-pick-pack 
       WITH FRAME bc0116c.
   
   ENABLE IMAGE-3
          IMAGE-4
          RECT-10
          RECT-6
          RECT-8
          RECT-9
          rt-button
          RECT-7
          RECT-11 
          RECT-12
          RECT-13
          RECT-14
          RECT-15
          c-inicial
          c-final
          tg-tp-ler-inventario 
          tg-tp-ler-pk-area-pk
          vl-ini-tp-ler-inventario
          vl-ini-tp-ler-pk-area-pk 
          tg-sub-tp-ler-pk-area-pk
          tg-tp-ler-pk-area-n
          tg-sub-tp-ler-inventario 
          vl-ini-tp-ler-pk-area-n
          tg-sub-tp-ler-pk-area-n
          tg-tp-ler-impressao 
          vl-ini-tp-ler-impressao
          tg-le-endereco-doca
          tg-sub-tp-ler-impressao 
          tg-tp-ler-arm-tarefa
          vl-ini-tp-ler-arm-tarefa
          tg-gera-hist-etiq 
          tg-sub-tp-ler-arm-tarefa
          tg-sub-gera-hist-etiq
          tg-tp-ler-devol-pk 
          tg-tp-ler-unidade
          vl-ini-tp-ler-devol-pk
          tg-sub-tp-ler-devol-pk 
          tg-tp-ler-visu-qtde
          vl-ini-tp-ler-visu
          tg-tp-picking-packing 
          tg-ler-endereco-item
          tg-picking tg-dev-pik
          tg-ler-etiq-pack
          tg-pik-pak 
          tg-arm tg-ler-tarefa-proc
          tg-sub-geral
          tg-sub-params-pick-pack
          bt-ok 
          bt-cancela 
       WITH FRAME bc0116c.
   VIEW FRAME bc0116c.

   {&OPEN-BROWSERS-IN-QUERY-bc0116c}
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy bc0116c 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */
   IF VALID-HANDLE(gh-bofn068) THEN DO:
      DELETE PROCEDURE gh-bofn068 NO-ERROR.
      ASSIGN gh-bofn068 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn088) THEN DO:
      DELETE PROCEDURE gh-bofn088 NO-ERROR.
      ASSIGN gh-bofn088 = ?.
   END.
   
   IF VALID-HANDLE(gh-bofn116) THEN DO:
      DELETE PROCEDURE gh-bofn116 NO-ERROR.
      ASSIGN gh-bofn116 = ?.
   END.
   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
   {include/i-logfin.i}

   /* Code placed here will execute AFTER standard behavior.    */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize bc0116c 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

   /* Code placed here will execute PRIOR to standard behavior. */

{utp/ut9000.i "BC0116C" "2.00.00.011"} /* 31/08/2023 15:08:03 */

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

   /* Code placed here will execute AFTER standard behavior.    */

   /* Se for do bc-tipo-trans, desabilita o campo de selecao do item */
   ASSIGN c-inicial:SENSITIVE IN FRAME {&FRAME-NAME} = (c-tabela <> 'BC-TIPO-TRANS')
          c-final:SENSITIVE IN FRAME {&FRAME-NAME}   = (c-tabela <> 'BC-TIPO-TRANS').

   /* Se for por familia, muda o label */
   IF c-tabela = 'BC-EXT-FAMILIA' THEN DO:
      ASSIGN c-inicial:LABEL IN FRAME {&FRAME-NAME} = "Fam¡lia".
   END.

   /* Se nÆo for bc-tipo-trans, desmarca todas as op‡äes - Inicio */
   IF c-tabela <> 'BC-TIPO-TRANS' THEN DO:
      ASSIGN tg-tp-ler-pk-area-pk:CHECKED  = NO
             tg-tp-ler-pk-area-n:CHECKED   = NO
             tg-tp-ler-arm-tarefa:CHECKED  = NO
             tg-tp-ler-devol-pk:CHECKED    = NO
             tg-tp-picking-packing:CHECKED = NO
             tg-tp-ler-inventario:CHECKED  = NO
             tg-tp-ler-impressao:CHECKED   = NO
             tg-tp-ler-visu-qtde:CHECKED   = NO
             tg-picking:CHECKED            = NO
             tg-dev-pik:CHECKED            = NO
             tg-pik-pak:CHECKED            = NO
             tg-arm:CHECKED                = NO.

   END.
   /* Se nÆo for bc-tipo-trans, desmarca todas as op‡äes - Fim */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-executar bc0116c 
PROCEDURE pi-executar :
/*------------------------------------------------------------------------------
  Purpose:     Executa o m‚todo de inicializa‡Æo dos parametros
  Parameters:  <none>
  Notes:       Os m‚todos estÆo no arquivo bcp/bc0116c.i
------------------------------------------------------------------------------*/
   DEFINE VARIABLE i-vl-param-pickpack AS INTEGER    NO-UNDO.
   DEFINE VARIABLE i-le-endereco-doca  AS INTEGER    NO-UNDO.

   /* Picking Tipo de leitura na area de picking */
   IF tg-tp-ler-pk-area-pk:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN DO:
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                            INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                            INPUT c-id-tabela  ,           /*Transacao (ex.: wmsai001)*/
                            INPUT "LEIT-QTD-AREA-PICKIN" , /*Nome parametro*/
                            INPUT INTEGER(vl-ini-tp-ler-pk-area-pk:SCREEN-VALUE IN FRAME {&FRAME-NAME}), /*Valor Parametro*/
                            INPUT (tg-sub-tp-ler-pk-area-pk:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")). /*Substitui, caso j  exista*/

      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                    INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                    INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                    INPUT "WMSAI001"  ,           /*Transacao (ex.: wmsai001)*/
                    INPUT "HABILITA-UNIDADE" ,   /*Nome parametro*/
                    INPUT INTEGER(IF tg-tp-ler-unidade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN 1 ELSE 2), /*Valor Parametro*/
                    INPUT YES). /*Substitui, caso j  exista*/
   END.

   /* Picking Tipo de leitura normal */
   IF tg-tp-ler-pk-area-n:SCREEN-VALUE = "YES" THEN DO:
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-tabela ,
                            INPUT c-id-tabela  ,
                            INPUT "LEIT-QTD-AREA-NORMAL" ,
                            INPUT INTEGER(vl-ini-tp-ler-pk-area-n:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                            INPUT (tg-sub-tp-ler-pk-area-N:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                            INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                            INPUT "WMSAI001"  ,           /*Transacao (ex.: wmsai001)*/
                            INPUT "HABILITA-UNIDADE" ,   /*Nome parametro*/
                            INPUT INTEGER(IF tg-tp-ler-unidade:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN 1 ELSE 2), /*Valor Parametro*/
                            INPUT YES). /*Substitui, caso j  exista*/
   END.
   
   IF tg-le-endereco-doca:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN ASSIGN i-le-endereco-doca = 1. ELSE ASSIGN i-le-endereco-doca = 0.

   RUN pi-criaParametro ( INPUT 'NONE',               /* Ext Familia Ini */
                          INPUT 'NONE',               /* Ext Familia Fim */
                          INPUT 'BC-TIPO-TRANS',      /* Entidade        */
                          INPUT 'WMSai001',           /* Transacao       */
                          INPUT 'LE-ENDERECO-DOCA',   /* Nome Parametro  */
                          INPUT i-le-endereco-doca,   /*Valor Parametro  */
                          INPUT TRUE).

   /* Por Tarefa  */
   IF tg-tp-ler-arm-tarefa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN DO:
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-tabela ,
                            INPUT c-id-tabela  ,
                            INPUT "LEIT-QTD-ARMAZEN-TAR" ,
                            INPUT INTEGER(vl-ini-tp-ler-arm-tarefa:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                            INPUT (tg-sub-tp-ler-arm-tarefa:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                            INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                            INPUT "WMENT003"  ,           /*Transacao (ex.: wmsai001)*/
                            INPUT "HABILITA-UNIDADE" ,   /*Nome parametro*/
                            INPUT INTEGER(IF tg-tp-ler-unidade:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN 1 ELSE 2), /*Valor Parametro*/
                            INPUT YES). /*Substitui, caso j  exista*/
   END.

   /* Por devolucao de picking  */
   IF tg-tp-ler-devol-pk:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'YES' THEN DO:
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-tabela ,
                            INPUT c-id-tabela  ,
                            INPUT "LEIT-QTD-DEVOL-PICK" ,
                            INPUT INTEGER(vl-ini-tp-ler-devol-pk:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                            INPUT (tg-sub-tp-ler-devol-pk:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                            INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                            INPUT "WMSAI004"  ,           /*Transacao (ex.: wmsai001)*/
                            INPUT "HABILITA-UNIDADE" ,   /*Nome parametro*/
                            INPUT INTEGER(IF tg-tp-ler-unidade:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN 1 ELSE 2), /*Valor Parametro*/
                            INPUT YES). /*Substitui, caso j  exista*/
   END.

   /* Parametros para Picking ~\ Packing Simultƒneos - Inicio */

   IF tg-tp-picking-packing:SCREEN-VALUE = 'YES' THEN DO:
      /* Parametro de Leitura do Endere‡o do Item */
      IF (tg-ler-endereco-item:SCREEN-VALUE = "YES") THEN
          ASSIGN i-vl-param-pickpack = 1.
      ELSE
          ASSIGN i-vl-param-pickpack = 2.
      
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-tabela ,
                            INPUT "WMSai009",
                            INPUT "LER-ENDERECO-ITEM",
                            INPUT i-vl-param-pickpack,
                            INPUT (tg-sub-params-pick-pack:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).


      /* Parametro de Leitura da Etiqueta de Packing */
      IF (tg-ler-etiq-pack:SCREEN-VALUE = "YES") THEN
         ASSIGN i-vl-param-pickpack = 1.
      ELSE
         ASSIGN i-vl-param-pickpack = 2.

      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-tabela ,
                            INPUT "WMSai009",
                            INPUT "LER-ETIQUETA-PACKING",
                            INPUT i-vl-param-pickpack,
                            INPUT (tg-sub-params-pick-pack:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).


      /* Parametro de Leitura das Tarefas em Processo */
      IF (tg-ler-tarefa-proc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES") THEN
         ASSIGN i-vl-param-pickpack = 1.
      ELSE
         ASSIGN i-vl-param-pickpack = 2.

      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-tabela ,
                            INPUT "WMSai009",
                            INPUT "LER-TAREFAS-PROCESSO",
                            INPUT i-vl-param-pickpack,
                            INPUT (tg-sub-params-pick-pack:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
   END.

   /* Parametros para Picking ~\ Packing Simultƒneos - Final */

   /* Novos Parametro */ 
   /* Parametros para Inventario - Inicio */
   IF tg-tp-ler-inventario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN DO:
       /*  */
       RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                             INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                             INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                             INPUT c-id-tabela  ,           /*Transacao (ex.: wmsai001)*/
                             INPUT "LEIT-QTD-INVENTARIO" , /*Nome parametro*/
                             INPUT INTEGER(vl-ini-tp-ler-inventario:SCREEN-VALUE), /*Valor Parametro*/
                             INPUT (tg-sub-tp-ler-inventario:SCREEN-VALUE  = "YES")). /*Substitui, caso j  exista*/
       
       /*IF tg-tp-ler-unidade :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN */

       RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                             INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                             INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                             INPUT "WMOUT003"  ,           /*Transacao (ex.: wmsai001)*/
                             INPUT "HABILITA-UNIDADE" ,   /*Nome parametro*/
                             INPUT INTEGER(IF tg-tp-ler-unidade:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN 1 ELSE 2), /*Valor Parametro*/
                             INPUT YES). /*Substitui, caso j  exista*/


   END.
   /* Parametros para Inventario - Fim */


   /* Parametros para Impressao - Inicio */
   IF tg-tp-ler-impressao:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN DO:
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                            INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                            INPUT c-id-tabela  ,           /*Transacao (ex.: wmsai001)*/
                            INPUT "LEIT-QTD-IMPRESSAO" ,   /*Nome parametro*/
                            INPUT INTEGER(vl-ini-tp-ler-impressao:SCREEN-VALUE), /*Valor Parametro*/
                            INPUT (tg-sub-tp-ler-impressao:SCREEN-VALUE  = "YES")). /*Substitui, caso j  exista*/
      
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                            INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                            INPUT "WMOUT004"  ,           /*Transacao (ex.: wmsai001)*/
                            INPUT "HABILITA-UNIDADE" ,   /*Nome parametro*/
                            INPUT INTEGER(IF tg-tp-ler-unidade:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN 1 ELSE 2), /*Valor Parametro*/
                            INPUT YES). /*Substitui, caso j  exista*/
   END.
   /* Parametros para Impressao - Fim */

   /* Parametros Gerais - Inicio */

   IF tg-tp-ler-visu-qtde:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN DO:
      IF c-tabela <> "BC-TIPO-TRANS" THEN DO:
         RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},  /*Valor inicial*/
                               INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},    /*Valor final*/
                               INPUT c-tabela ,               /*Entidade (ex.: bc-tipo-trans)*/
                               INPUT c-id-tabela  ,           /*Transacao (ex.: wmsai001)*/
                               INPUT "DISP-QTDE" ,   /*Nome parametro*/
                               INPUT INTEGER(vl-ini-tp-ler-impressao:SCREEN-VALUE IN FRAME {&FRAME-NAME}), /*Valor Parametro*/
                               INPUT (tg-sub-geral:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")). /*Substitui, caso j  exista*/
      END.

      /* Cria parametro para Transa‡Æo Picking - Inicio */
      IF tg-picking:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN DO:
         RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT "BC-TIPO-TRANS" ,
                               INPUT "WMSai001",
                               INPUT "DISP-QTDE",
                               INPUT INTEGER(vl-ini-tp-ler-visu:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                               INPUT (tg-sub-geral:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      END.
      /* Cria parametro para Transa‡Æo Picking - Fim */

      /* Cria parametro para Transa‡Æo Devol Picking - Inicio */
      IF tg-dev-pik:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN DO:
         RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT "BC-TIPO-TRANS" ,
                               INPUT "WMSai004",
                               INPUT "DISP-QTDE",
                               INPUT INTEGER(vl-ini-tp-ler-visu:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                               INPUT (tg-sub-geral:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      END.
      /* Cria parametro para Transa‡Æo Devol Picking - Fim */

      /* Cria parametro para Transa‡Æo Picking/Paking - Inicio */
      IF tg-pik-pak:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN DO:
         RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT "BC-TIPO-TRANS" ,
                               INPUT "WMSai009",
                               INPUT "DISP-QTDE",
                               INPUT INTEGER(vl-ini-tp-ler-visu:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                               INPUT (tg-sub-geral:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      END.
      /* Cria parametro para Transa‡Æo Picking/Paking - Fim */

      /* Cria parametro para Transa‡Æo Armazenamento - Inicio */
      IF tg-arm:SCREEN-VALUE IN FRAME  {&FRAME-NAME} = "YES" THEN DO:
         RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                               INPUT "BC-TIPO-TRANS" ,
                               INPUT "WMEnt003",
                               INPUT "DISP-QTDE",
                               INPUT INTEGER(vl-ini-tp-ler-visu:SCREEN-VALUE IN FRAME {&FRAME-NAME}),
                               INPUT (tg-sub-geral:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      END.
      /* Cria parametro para Transa‡Æo Armazenamento - Fim */
      
      /* Cria parametro para Gerar Historico Etiqueta Serial - Inicio */
      RUN pi-criaParametro (INPUT c-inicial:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT c-final:SCREEN-VALUE IN FRAME {&FRAME-NAME},
                            INPUT "BC-TIPO-TRANS" ,
                            INPUT "WMEnt003",
                            INPUT "GERA_HISTORICO",
                            INPUT IF tg-gera-hist-etiq:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES" THEN 1 ELSE 0,
                            INPUT (tg-sub-gera-hist-etiq:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "YES")).
      /* Cria parametro para Gerar Historico Etiqueta Serial - Fim */
   END.
   /* Parametros Gerais - Fim */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records bc0116c  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/
   /* SEND-RECORDS does nothing because there are no External
      Tables specified for this SmartVaPara, and there are no
      tables specified in any contained Browse, Query, or Frame. */
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed bc0116c 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
   DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
   DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

   RUN pi-trata-state ( INPUT p-issuer-hdl,
                        INPUT p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
