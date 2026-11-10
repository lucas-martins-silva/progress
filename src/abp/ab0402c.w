&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
          mguni            PROGRESS
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
{include/i-prgvrs.i AB0402C 2.00.00.002}  /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0402c MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0402C
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiDataFim fiDataIni fiEmpFim fiEmpIni ~
                              fiEqptoFim fiEqptoIni fiEstabFim fiEstabIni ~
                              fiTagFim fiTagIni fiCCFim fiCCIni

/* Parameters Definitions ---                                           */
define input-output parameter pDataIni  as   date                        no-undo.
define input-output parameter pDataFim  as   date                        no-undo.
define input-output parameter pEmpIni   like mab-eqpto.ep-codigo         no-undo.
define input-output parameter pEmpFim   like mab-eqpto.ep-codigo         no-undo.
define input-output parameter pEqptoIni like mab-eqpto.cod-eqpto         no-undo.
define input-output parameter pEqptoFim like mab-eqpto.cod-eqpto         no-undo.
define input-output parameter pEstabIni like mab-histor-ativid.cod-estab no-undo.
define input-output parameter pEstabFim like mab-histor-ativid.cod-estab no-undo.
define input-output parameter pTagIni   like mab-histor-ativid.cd-tag    no-undo.
define input-output parameter pTagFim   like mab-histor-ativid.cd-tag    no-undo.
define input-output parameter pCCIni    like mab-histor-ativid.cc-codigo no-undo.
define input-output parameter pCCFim    like mab-histor-ativid.cc-codigo no-undo.
&IF DEFINED(bf_mnt_ems206b) &THEN
define input-output parameter pUnidNegocIni like mab-histor-ativid.cod-unid-negoc no-undo.
define input-output parameter pUnidNegocFim like mab-histor-ativid.cod-unid-negoc no-undo.
&ENDIF
define       output parameter pOK       as   logical                     no-undo.

/* Local Variable Definitions ---                                       */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-10 IMAGE-2 IMAGE-3 IMAGE-4 ~
IMAGE-47 IMAGE-48 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 rtToolBar ~
IMAGE-49 IMAGE-50 fiDataIni fiDataFim fiEstabIni fiEstabFim fiEmpIni ~
fiEmpFim fiEqptoIni fiEqptoFim fiTagIni fiTagFim fiCCini fiCCfim ~
fiUnidNegocIni fiUnidNegocFim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiDataIni fiDataFim fiEstabIni fiEstabFim ~
fiEmpIni fiEmpFim fiEqptoIni fiEqptoFim fiTagIni fiTagFim fiCCini fiCCfim ~
fiUnidNegocIni fiUnidNegocFim 

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

DEFINE VARIABLE fiCCfim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fiCCini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fiDataFim AS DATE FORMAT "99/99/9999" INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999" INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data Movimento":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiEmpFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiEmpIni LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiEqptoFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiEqptoIni AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiEstabFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabIni LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88 NO-UNDO.

DEFINE VARIABLE fiTagFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiTagIni AS CHARACTER FORMAT "x(16)" 
     LABEL "TAG":R4 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiUnidNegocFim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnidNegocIni AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-47
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-48
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 75 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDataIni AT ROW 1.25 COL 22 COLON-ALIGNED HELP
          "Data do movimento inicial"
     fiDataFim AT ROW 1.25 COL 44 COLON-ALIGNED HELP
          "Data do movimento final" NO-LABEL
     fiEstabIni AT ROW 2.25 COL 22.86 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
     fiEstabFim AT ROW 2.25 COL 44 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     fiEmpIni AT ROW 3.25 COL 24.86 COLON-ALIGNED HELP
          "C¢digo da empresa"
     fiEmpFim AT ROW 3.25 COL 44 COLON-ALIGNED HELP
          "C¢digo da empresa" NO-LABEL
     fiEqptoIni AT ROW 4.25 COL 14 COLON-ALIGNED HELP
          "C¢digo do Equipamento inicial"
     fiEqptoFim AT ROW 4.25 COL 44 COLON-ALIGNED HELP
          "C¢digo do Equipamento final" NO-LABEL
     fiTagIni AT ROW 5.25 COL 14 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG inicial"
     fiTagFim AT ROW 5.25 COL 44 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG final" NO-LABEL
     fiCCini AT ROW 6.25 COL 11.86 COLON-ALIGNED
     fiCCfim AT ROW 6.25 COL 44 COLON-ALIGNED NO-LABEL
     fiUnidNegocIni AT ROW 7.25 COL 27 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 7.25 COL 44 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio" NO-LABEL
     btOK AT ROW 8.71 COL 2
     btCancel AT ROW 8.71 COL 13
     btHelp2 AT ROW 8.71 COL 65.14
     IMAGE-1 AT ROW 1.25 COL 34
     IMAGE-10 AT ROW 5.25 COL 43
     IMAGE-2 AT ROW 1.25 COL 43
     IMAGE-3 AT ROW 2.25 COL 34
     IMAGE-4 AT ROW 2.25 COL 43
     IMAGE-47 AT ROW 6.25 COL 34
     IMAGE-48 AT ROW 6.25 COL 43
     IMAGE-5 AT ROW 3.25 COL 34
     IMAGE-6 AT ROW 3.25 COL 43
     IMAGE-7 AT ROW 4.25 COL 34
     IMAGE-8 AT ROW 4.25 COL 43
     IMAGE-9 AT ROW 5.25 COL 34
     rtToolBar AT ROW 8.5 COL 1
     IMAGE-49 AT ROW 7.25 COL 34
     IMAGE-50 AT ROW 7.25 COL 43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 75.72 BY 8.96
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 8.96
         WIDTH              = 75.72
         MAX-HEIGHT         = 9.33
         MAX-WIDTH          = 75.72
         VIRTUAL-HEIGHT     = 9.33
         VIRTUAL-WIDTH      = 75.72
         MAX-BUTTON         = no
         RESIZE             = no
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fiEmpFim IN FRAME fpage0
   LIKE = mguni.empresa.ep-codigo                                       */
/* SETTINGS FOR FILL-IN fiEmpIni IN FRAME fpage0
   LIKE = mguni.empresa.ep-codigo EXP-SIZE                              */
/* SETTINGS FOR FILL-IN fiEstabFim IN FRAME fpage0
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
/* SETTINGS FOR FILL-IN fiEstabIni IN FRAME fpage0
   LIKE = mgadm.estabelec.cod-estabel EXP-SIZE                          */
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


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wWindow
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    assign pOK = no.

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

assign pDataIni  = input frame fPage0 fiDataIni
       pDataFim  = input frame fPage0 fiDataFim 
       pEmpIni   = input frame fPage0 fiEmpIni
       pEmpFim   = input frame fPage0 fiEmpFim
       pEqptoIni = input frame fPage0 fiEqptoIni
       pEqptoFim = input frame fPage0 fiEqptoFim
       pEstabIni = input frame fPage0 fiEstabIni
       pEstabFim = input frame fPage0 fiEstabFim
       pTagIni   = input frame fPage0 fiTagIni  
       pTagFim   = input frame fPage0 fiTagFim
       pCCIni    = input frame fPage0 fiCCIni  
       pCCFim    = input frame fPage0 fiCCFim
       pOK       = yes.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN pUnidNegocIni = input frame fPage0 fiUnidNegocIni
                   pUnidNegocFim = input frame fPage0 fiUnidNegocFim.
        END.
    &ENDIF

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN fiEstabFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ" &ENDIF
       fiEmpIni   = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fiEmpFim   = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo da tela
------------------------------------------------------------------------------*/
ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-49:VISIBLE         IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-50:VISIBLE         IN FRAME fPage0 = l-usa-unid-negoc.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        ASSIGN fiUnidNegocIni = pUnidNegocIni
               fiUnidNegocFim = pUnidNegocFim.

        DISPLAY fiUnidNegocIni fiUnidNegocFim WITH FRAME fPage0.
    END.
&ENDIF

assign fiDataFim  = pDataFim 
       fiDataIni  = pDataIni 
       fiEmpFim   = pEmpFim
       fiEmpIni   = pEmpIni  
       fiEqptoFim = pEqptoFim
       fiEqptoIni = pEqptoIni
       fiEstabFim = pEstabFim
       fiEstabIni = pEstabIni
       fiTagFim   = pTagFim  
       fiTagIni   = pTagIni
       fiCCFim   = pCCfim
       fiCCIni   = pCCini.

display fiDataFim
        fiDataIni
        fiEmpFim
        fiEmpIni
        fiEqptoFim
        fiEqptoIni
        fiEstabFim
        fiEstabIni
        fiTagFim
        fiTagIni
        fiTagFim
        fiTagIni
        fiCCFim
        fiCCIni
    with frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

