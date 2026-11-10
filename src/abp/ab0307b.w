&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i AB0307B 2.00.00.004 } /*** 010004 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0307b MAB}
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
&GLOBAL-DEFINE Program        AB0307B
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiDataIni fiDataFim fiEpCodigoIni fiEpCodigoFim ~
                              fiEstabEqptoIni fiEstabEqptoFim fiTagIni fiTagFim ~
                              fiCCIni fiCCFim fiEqptoIni fiEqptoFim ~
                              fiEstabPostoIni fiEstabPostoFim fiPostoIni fiPostoFim ~
                              fiBombaIni fiBombaFim fiDeposIni fiDeposFim fiModelIni fiModelFim ~

{abp/ab0307.i} /** Defini‡Æo da ttSelecao **/

DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.

/* Parameters Definitions ---             */
define input-output parameter table for ttSelecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS fiDataIni fiDataFim fiEpCodigoIni ~
fiEpCodigoFim fiEstabEqptoIni fiEstabEqptoFim fiTagIni fiTagFim fiCCini ~
fiCCfim fiEqptoIni fiEqptoFim fiEstabPostoIni fiEstabPostoFim fiPostoIni ~
fiPostoFim fiBombaIni fiBombaFim fiDeposIni fiDeposFim fiModelIni ~
fiModelFim fiUnidNegocIni fiUnidNegocFim btOK btCancel btHelp2 IMAGE-1 ~
IMAGE-10 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-47 IMAGE-48 IMAGE-49 IMAGE-5 ~
IMAGE-50 IMAGE-51 IMAGE-52 IMAGE-53 IMAGE-54 IMAGE-55 IMAGE-56 IMAGE-57 ~
IMAGE-58 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 rtToolBar IMAGE-59 IMAGE-60 
&Scoped-Define DISPLAYED-OBJECTS fiDataIni fiDataFim fiEpCodigoIni ~
fiEpCodigoFim fiEstabEqptoIni fiEstabEqptoFim fiTagIni fiTagFim fiCCini ~
fiCCfim fiEqptoIni fiEqptoFim fiEstabPostoIni fiEstabPostoFim fiPostoIni ~
fiPostoFim fiBombaIni fiBombaFim fiDeposIni fiDeposFim fiModelIni ~
fiModelFim fiUnidNegocIni fiUnidNegocFim 

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

DEFINE VARIABLE fiBombaFim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiBombaIni AS CHARACTER FORMAT "X(256)":U 
     LABEL "Bomba" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

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

DEFINE VARIABLE fiDataIni AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Data Movimento":R17 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDeposFim AS CHARACTER FORMAT "x(3)" INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiDeposIni AS CHARACTER FORMAT "x(3)" 
     LABEL "Dep¢sito":R10 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEpCodigoFim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiEpCodigoIni LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiEqptoFim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiEqptoIni AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiEstabEqptoFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabEqptoIni LIKE estabelec.cod-estabel
     LABEL "Estab. Eqpto":R14 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabPostoFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabPostoIni LIKE estabelec.cod-estabel
     LABEL "Estab. Posto":R14 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiModelFim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiModelIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Modelo":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiPostoFim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiPostoIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Posto":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-51
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-52
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-55
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-56
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-57
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-58
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-59
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-60
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
     SIZE 60 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiDataIni AT ROW 1.25 COL 19.86 COLON-ALIGNED HELP
          "Data do movimento inicial"
     fiDataFim AT ROW 1.25 COL 38.72 COLON-ALIGNED HELP
          "Data do movimento final" NO-LABEL
     fiEpCodigoIni AT ROW 2.17 COL 25.29 COLON-ALIGNED HELP
          ""
     fiEpCodigoFim AT ROW 2.17 COL 38.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fiEstabEqptoIni AT ROW 3.17 COL 24.86 COLON-ALIGNED HELP
          ""
          LABEL "Estab. Eqpto":R14
     fiEstabEqptoFim AT ROW 3.13 COL 38.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fiTagIni AT ROW 4.08 COL 11.86 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG inicial"
     fiTagFim AT ROW 4.08 COL 38.72 COLON-ALIGNED HELP
          "Localiza‡Æo Funcional - TAG final" NO-LABEL
     fiCCini AT ROW 5.04 COL 10 COLON-ALIGNED HELP
          "C¢digo Centro de Custo"
     fiCCfim AT ROW 5.04 COL 38.72 COLON-ALIGNED HELP
          "C¢digo Centro de Custo" NO-LABEL
     fiEqptoIni AT ROW 6.04 COL 11.86 COLON-ALIGNED HELP
          "C¢digo do Equipamento inicial"
     fiEqptoFim AT ROW 6 COL 38.57 COLON-ALIGNED HELP
          "C¢digo do Equipamento final" NO-LABEL
     fiEstabPostoIni AT ROW 7.04 COL 24.86 COLON-ALIGNED HELP
          ""
          LABEL "Estab. Posto":R14
     fiEstabPostoFim AT ROW 7.04 COL 38.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fiPostoIni AT ROW 8.04 COL 19.86 COLON-ALIGNED HELP
          "C¢digo posto inicial"
     fiPostoFim AT ROW 8 COL 38.72 COLON-ALIGNED HELP
          "C¢digo posto final" NO-LABEL
     fiBombaIni AT ROW 9.04 COL 21 COLON-ALIGNED HELP
          "C¢digo da bomba inicial"
     fiBombaFim AT ROW 9 COL 38.72 COLON-ALIGNED HELP
          "C¢digo da bomba final" NO-LABEL
     fiDeposIni AT ROW 10.13 COL 24.86 COLON-ALIGNED HELP
          "C¢digo do dep¢sito inicial"
     fiDeposFim AT ROW 10.08 COL 38.72 COLON-ALIGNED HELP
          "C¢digo do dep¢sito final" NO-LABEL
     fiModelIni AT ROW 11.13 COL 19.86 COLON-ALIGNED HELP
          "C¢digo do modelo inicial"
     fiModelFim AT ROW 11.08 COL 38.72 COLON-ALIGNED HELP
          "C¢digo do modelo final" NO-LABEL
     fiUnidNegocIni AT ROW 12.13 COL 24.72 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 12.08 COL 38.72 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio" NO-LABEL
     btOK AT ROW 13.46 COL 2
     btCancel AT ROW 13.46 COL 13
     btHelp2 AT ROW 13.5 COL 50.14
     IMAGE-1 AT ROW 1.29 COL 32
     IMAGE-10 AT ROW 4.08 COL 37.57
     IMAGE-2 AT ROW 1.25 COL 37.57
     IMAGE-3 AT ROW 3.17 COL 32
     IMAGE-4 AT ROW 3.13 COL 37.57
     IMAGE-47 AT ROW 5.08 COL 32
     IMAGE-48 AT ROW 5.04 COL 37.57
     IMAGE-49 AT ROW 7.08 COL 32
     IMAGE-5 AT ROW 2.21 COL 32
     IMAGE-50 AT ROW 7.04 COL 37.57
     IMAGE-51 AT ROW 8.04 COL 32
     IMAGE-52 AT ROW 8 COL 37.57
     IMAGE-53 AT ROW 9.04 COL 32
     IMAGE-54 AT ROW 9 COL 37.57
     IMAGE-55 AT ROW 10.08 COL 32
     IMAGE-56 AT ROW 10.04 COL 37.57
     IMAGE-57 AT ROW 11.08 COL 32
     IMAGE-58 AT ROW 11.04 COL 37.57
     IMAGE-6 AT ROW 2.17 COL 37.57
     IMAGE-7 AT ROW 6.04 COL 32
     IMAGE-8 AT ROW 6 COL 37.57
     IMAGE-9 AT ROW 4.13 COL 32
     rtToolBar AT ROW 13.25 COL 1
     IMAGE-59 AT ROW 12.08 COL 32
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 13.79
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     IMAGE-60 AT ROW 12.04 COL 37.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 13.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 13.75
         WIDTH              = 60.14
         MAX-HEIGHT         = 37.58
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 37.58
         VIRTUAL-WIDTH      = 182.86
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
   FRAME-NAME Custom                                                    */
/* SETTINGS FOR FILL-IN fiEpCodigoFim IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiEpCodigoIni IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fiEstabEqptoFim IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fiEstabEqptoIni IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FILL-IN fiEstabPostoFim IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fiEstabPostoIni IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
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
    {utp/ut-liter.i "Final"}
    assign cTexto = return-value.

    /** Valida‡Æo para a Data Final maior que data atual **/
    if input frame fPage0 fiDataFim > TODAY then do:
        {utp/ut-liter.i "de Hoje"}
        RUN utp/ut-msgs.p (INPUT "SHOW":U, INPUT 26584, INPUT cTexto + "~~" + return-value).
        RETURN NO-APPLY.
    end.
    run piGrava in this-procedure.  
    apply "CLOSE":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*--- L¢gica para inicializa‡Æo do programam ---*/

ASSIGN fiEpCodigoIni = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fiEpCodigoFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fiEstabPostoFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF
       fiEstabEqptoFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Data Movimento"}
ASSIGN fiDataIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Empresa"}
ASSIGN fiEpCodigoIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Estab.Eqpto"}
ASSIGN fiEstabEqptoIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "TAG"}
ASSIGN fiTagIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Centro Custo"}
ASSIGN fiCCini:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Equipamento"}
ASSIGN fiEqptoIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Estab.Posto"}
ASSIGN fiEstabPostoIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Posto"}
ASSIGN fiPostoIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Bomba"}
ASSIGN fiBombaIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Dep¢sito"}
ASSIGN fiDeposIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i "Modelo"}
ASSIGN fiModelIni:LABEL IN FRAME fPage0 = RETURN-VALUE.
{utp/ut-liter.i Unidade_Neg¢cio}
ASSIGN fiUnidNegocIni:LABEL IN FRAME fPage0 = RETURN-VALUE.

ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-59:VISIBLE         IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-60:VISIBLE         IN FRAME fPage0 = l-usa-unid-negoc.

do with frame fPage0:
    find first ttSelecao no-lock no-error.
    if avail ttSelecao then do:
        assign fiDataIni:SCREEN-VALUE       IN FRAME fPage0 = string(ttSelecao.dat-ini)
               fiDataFim:SCREEN-VALUE       IN FRAME fPage0 = string(ttSelecao.dat-fim)
               fiEpCodigoIni:SCREEN-VALUE   IN FRAME fPage0 = string(ttSelecao.ep-codigo-ini)
               fiEpCodigoFim:SCREEN-VALUE   IN FRAME fPage0 = string(ttSelecao.ep-codigo-fim)
               fiEstabEqptoIni:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.estab-eqpto-ini
               fiEstabEqptoFim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.estab-eqpto-fim
               fiTagIni:SCREEN-VALUE        IN FRAME fPage0 = ttSelecao.tag-ini
               fiTagFim:SCREEN-VALUE        IN FRAME fPage0 = ttSelecao.tag-fim
               fiCCini:SCREEN-VALUE         IN FRAME fPage0 = ttSelecao.cc-codigo-ini
               fiCCfim:SCREEN-VALUE         IN FRAME fPage0 = ttSelecao.cc-codigo-fim
               fiEqptoIni:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.cod-eqpto-ini
               fiEqptoFim:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.cod-eqpto-fim
               fiEstabPostoIni:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.estab-posto-ini
               fiEstabPostoFim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.estab-posto-fim
               fiPostoIni:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.posto-ini
               fiPostoFim:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.posto-fim
               fiBombaIni:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.bomba-ini
               fiBombaFim:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.bomba-fim
               fiDeposIni:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.deposito-ini
               fiDeposFim:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.deposito-fim
               fiModelIni:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.cod-model-ini
               fiModelFim:SCREEN-VALUE      IN FRAME fPage0 = ttSelecao.cod-model-fim.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN fiUnidNegocIni:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-ini
                       fiUnidNegocFim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-fim.
            END.
        &ENDIF
    end.
end.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os dados de tela na temp-table 
------------------------------------------------------------------------------*/
find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    ASSIGN ttSelecao.dat-ini       = date(fiDataIni:screen-value    in frame fPage0)
           ttSelecao.dat-fim       = date(fiDataFim:screen-value    in frame fPage0)
           &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.ep-codigo-ini = fiEpCodigoIni:screen-value in frame fPage0
           ttSelecao.ep-codigo-fim = fiEpCodigoFim:screen-value in frame fPage0
           &ELSE
           ttSelecao.ep-codigo-ini = int(fiEpCodigoIni:screen-value in frame fPage0)
           ttSelecao.ep-codigo-fim = int(fiEpCodigoFim:screen-value in frame fPage0)
           &ENDIF
           ttSelecao.estab-eqpto-ini = fiEstabEqptoIni:screen-value in frame fPage0
           ttSelecao.estab-eqpto-fim = fiEstabEqptoFim:screen-value in frame fPage0
           ttSelecao.tag-ini = fiTagIni:screen-value                in frame fPage0
           ttSelecao.tag-fim = fiTagFim:screen-value                in frame fPage0
           ttSelecao.cc-codigo-ini = fiCCini:screen-value           in frame fPage0
           ttSelecao.cc-codigo-fim = fiCCfim:screen-value           in frame fPage0
           ttSelecao.cod-eqpto-ini = fiEqptoIni:screen-value        in frame fPage0
           ttSelecao.cod-eqpto-fim = fiEqptoFim:screen-value        in frame fPage0
           ttSelecao.estab-posto-ini = fiEstabPostoIni:screen-value in frame fPage0
           ttSelecao.estab-posto-fim = fiEstabPostoFim:screen-value in frame fPage0
           ttSelecao.posto-ini = fiPostoIni:screen-value            in frame fPage0
           ttSelecao.posto-fim = fiPostoFim:screen-value            in frame fPage0
           ttSelecao.bomba-ini = fiBombaIni:screen-value            in frame fPage0
           ttSelecao.bomba-fim = fiBombaFim:screen-value            in frame fPage0
           ttSelecao.deposito-ini = fiDeposIni:screen-value         in frame fPage0
           ttSelecao.deposito-fim = fiDeposFim:screen-value         in frame fPage0
           ttSelecao.cod-model-ini = fiModelIni:screen-value        in frame fPage0
           ttSelecao.cod-model-fim = fiModelFim:screen-value        in frame fPage0.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN ttSelecao.cod-unid-negoc-ini = fiUnidNegocIni:screen-value in frame fPage0
                   ttSelecao.cod-unid-negoc-fim = fiUnidNegocFim:screen-value in frame fPage0.
        END.
    &ENDIF
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

