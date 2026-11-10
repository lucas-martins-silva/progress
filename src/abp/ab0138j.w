&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
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
{include/i-prgvrs.i AB0138J 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0138j MAB}
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
&GLOBAL-DEFINE Program        AB0138J
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiEpIni fiEpFim fiModelIni fiModelFim ~
                              fiEqptoIni fiEqptoFim fiMarcaIni fiMarcaFim ~
                              fiTagIni fiTagFim fiCentroCustoIni fiCentroCustoFim ~
                              fiEstabelIni fiEstabelFim

DEFINE VARIABLE hAcomp AS HANDLE     NO-UNDO.

{frbo~/bofr007.i tt-equipment}
/* Parameters Definitions ---                                           */
define input parameter p-ep-codigo  like mab-eqpto.ep-codigo no-undo.
define input parameter p-cod-eqpto  like mab-eqpto.cod-eqpto no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 RECT-21 ~
rtToolBar IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 IMAGE-10 IMAGE-11 ~
IMAGE-12 IMAGE-13 IMAGE-14 fiEpini fiEpFim fiEqptoIni fiEqptoFim fiModelIni ~
fiModelFim fiMarcaIni fiMarcaFim fiTagIni fiTagFim fiCentroCustoIni ~
fiCentroCustoFim fiEstabelIni fiEstabelFim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiEpini fiEpFim fiEqptoIni fiEqptoFim ~
fiModelIni fiModelFim fiMarcaIni fiMarcaFim fiTagIni fiTagFim ~
fiCentroCustoIni fiCentroCustoFim fiEstabelIni fiEstabelFim 

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

DEFINE VARIABLE fiCentroCustoFim AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiCentroCustoIni AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo":R15 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiEpFim LIKE mab-eqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEpini LIKE mab-eqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoFim LIKE mab-eqpto.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEqptoIni LIKE mab-eqpto.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 18 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabelFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabelIni LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiMarcaFim AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiMarcaIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Marca":R7 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiModelFim AS CHARACTER FORMAT "x(8)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiModelIni AS CHARACTER FORMAT "x(8)" 
     LABEL "Modelo":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiTagFim AS CHARACTER FORMAT "x(16)" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE VARIABLE fiTagIni AS CHARACTER FORMAT "x(16)" 
     LABEL "TAG":R4 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
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

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 63 BY 8.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 63 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiEpini AT ROW 1.75 COL 21.71 HELP
          ""
          FONT 1
     fiEpFim AT ROW 1.75 COL 41.14 HELP
          "" NO-LABEL
          FONT 1
     fiEqptoIni AT ROW 2.75 COL 5.28 HELP
          ""
          FONT 1
     fiEqptoFim AT ROW 2.75 COL 41.14 HELP
          "" NO-LABEL
          FONT 1
     fiModelIni AT ROW 3.75 COL 21.14 COLON-ALIGNED HELP
          "C¢digo do Modelo"
     fiModelFim AT ROW 3.75 COL 39.14 COLON-ALIGNED HELP
          "C¢digo do Modelo" NO-LABEL
     fiMarcaIni AT ROW 4.75 COL 21.14 COLON-ALIGNED HELP
          "C¢digo da Marca de Equipamentos, Pneus e Componentes"
     fiMarcaFim AT ROW 4.75 COL 39.14 COLON-ALIGNED HELP
          "C¢digo da Marca de Equipamentos, Pneus e Componentes" NO-LABEL
     fiTagIni AT ROW 5.75 COL 13.14 COLON-ALIGNED HELP
          "Localiza‡Æo funcional (TAG)"
     fiTagFim AT ROW 5.75 COL 39.14 COLON-ALIGNED HELP
          "Localiza‡Æo funcional (TAG)" NO-LABEL
     fiCentroCustoIni AT ROW 6.75 COL 11 COLON-ALIGNED HELP
          "C¢digo Centro Custo"
     fiCentroCustoFim AT ROW 6.75 COL 39.14 COLON-ALIGNED HELP
          "C¢digo Centro Custo" NO-LABEL
     fiEstabelIni AT ROW 7.75 COL 27.14 COLON-ALIGNED HELP
          ""
     fiEstabelFim AT ROW 7.75 COL 39.14 COLON-ALIGNED HELP
          "" NO-LABEL
     btOK AT ROW 9.54 COL 2
     btCancel AT ROW 9.54 COL 13
     btHelp2 AT ROW 9.54 COL 52.86
     IMAGE-1 AT ROW 1.75 COL 33.43
     IMAGE-2 AT ROW 1.75 COL 38
     IMAGE-3 AT ROW 2.75 COL 33.43
     IMAGE-4 AT ROW 2.75 COL 38
     RECT-21 AT ROW 1 COL 1
     rtToolBar AT ROW 9.33 COL 1
     IMAGE-5 AT ROW 3.75 COL 33.43
     IMAGE-6 AT ROW 4.75 COL 33.43
     IMAGE-7 AT ROW 5.75 COL 33.43
     IMAGE-8 AT ROW 6.75 COL 33.43
     IMAGE-9 AT ROW 7.75 COL 33.43
     IMAGE-10 AT ROW 3.75 COL 38
     IMAGE-11 AT ROW 4.75 COL 38
     IMAGE-12 AT ROW 5.75 COL 38
     IMAGE-13 AT ROW 6.75 COL 38
     IMAGE-14 AT ROW 7.75 COL 38
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 63 BY 9.79
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
         HEIGHT             = 9.79
         WIDTH              = 62.86
         MAX-HEIGHT         = 17.54
         MAX-WIDTH          = 75.29
         VIRTUAL-HEIGHT     = 17.54
         VIRTUAL-WIDTH      = 75.29
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fiEpFim IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.ep-codigo EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEpini IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.ep-codigo EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEqptoFim IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.cod-eqpto EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEqptoIni IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.cod-eqpto EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEstabelFim IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fiEstabelIni IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
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
    blk1:
    do on stop undo, return "NOK":U:    
        /** Acompanhamento **/
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
        {utp/ut-liter.i "Integra Rastreamento (XML)"}
        RUN pi-inicializar IN hAcomp (trim(return-value)).
        
       for each mab-eqpto
            where 
            &IF "{&mguni_version}" >= "2.071" &THEN
                  mab-eqpto.ep-codigo   >= fiEpIni:screen-value      in frame fPage0
            and   mab-eqpto.ep-codigo   <= fiEpFim:screen-value      in frame fPage0
            &ELSE
                  mab-eqpto.ep-codigo   >= int(fiEpIni:screen-value      in frame fPage0)
            and   mab-eqpto.ep-codigo   <= int(fiEpFim:screen-value      in frame fPage0)
            &ENDIF           
            and   mab-eqpto.cod-eqpto   >= fiEqptoIni:screen-value       in frame fPage0
            and   mab-eqpto.cod-eqpto   <= fiEqptoFim:screen-value       in frame fPage0
            and   mab-eqpto.cod-model   >= fiModelIni:screen-value       in frame fPage0
            and   mab-eqpto.cod-model   <= fiModelFim:screen-value       in frame fPage0
            and   mab-eqpto.cd-tag      >= fiTagIni:screen-value         in frame fPage0
            and   mab-eqpto.cd-tag      <= fiTagFim:screen-value         in frame fPage0
            and   mab-eqpto.cc-codigo   >= fiCentroCustoIni:screen-value in frame fPage0
            and   mab-eqpto.cc-codigo   <= fiCentroCustoFim:screen-value in frame fPage0
            and   mab-eqpto.cod-estabel >= fiEstabelIni:screen-value     in frame fPage0
            and   mab-eqpto.cod-estabel <= fiEstabelFim:screen-value     in frame fPage0
            and   mab-eqpto.log-livre-1 = yes no-lock:

            empty temp-table tt-equipment.
            create tt-equipment.
            buffer-copy mab-eqpto to tt-equipment.

            /** Acompanhamento **/
            {utp/ut-liter.i "Equipamento"}
            run pi-Acompanhar in hAcomp (return-value + ": " + string(mab-eqpto.ep-codigo) + " - " + mab-eqpto.cod-eqpto).

            run adapters/xml/mn2/axsmf012.p (input table tt-equipment,
                                             input "CREATE":U).
    
            if return-value = "NOK":U then leave.
        end.
        
        run pi-Finalizar in hAcomp.

        apply "CLOSE":U to this-procedure.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
ASSIGN fiEpFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF
       fiEstabelFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializa‡Æo da tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i "Empresa"}
ASSIGN fiEpIni:LABEL IN FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "Equipamento"}
ASSIGN fiEqptoIni:LABEL IN FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "Modelo"}
ASSIGN fiModelIni:LABEL IN FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "Marca"}
ASSIGN fiMarcaIni:LABEL IN FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "TAG"}
ASSIGN fiTagIni:LABEL IN FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "Centro Custo"}
ASSIGN fiCentroCustoIni:LABEL IN FRAME fPage0 = trim(return-value).
{utp/ut-liter.i "Estabelecimento"}
ASSIGN fiEstabelIni:LABEL IN FRAME fPage0 = trim(return-value).

assign fiEpIni:screen-value    in frame fPage0       = string(p-ep-codigo)
       fiEpFim:screen-value    in frame fPage0       = string(p-ep-codigo)
       fiEqptoIni:screen-value in frame fPage0       = p-cod-eqpto
       fiEqptoFim:screen-value in frame fPage0       = p-cod-eqpto
       fiModelIni:screen-value in frame fPage0       = "":U
       fiModelFim:screen-value in frame fPage0       = "ZZZZZZZZ":U
       fiMarcaIni:screen-value in frame fPage0       = "":U
       fiMarcaFim:screen-value in frame fPage0       = "ZZZZZZZZ":U
       fiTagIni:screen-value in frame fPage0         = "":U
       fiTagFim:screen-value in frame fPage0         = "ZZZZZZZZZZZZZZZZ":U
       fiCentroCustoIni:screen-value in frame fPage0 = "":U
       fiCentroCustoFim:screen-value in frame fPage0 = "ZZZZZZZZZZZZZZZZZZZZ":U
       fiEstabelIni:screen-value in frame fPage0     = "":U
&IF "{&mguni_version}" >= "2.071" &THEN
       fiEstabelFim:screen-value in frame fPage0     = "ZZZZZ":U.
&ELSE
       fiEstabelFim:screen-value in frame fPage0     = "ZZZ":U.
&ENDIF

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

