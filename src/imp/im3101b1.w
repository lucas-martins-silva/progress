&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i IM3101B1 2.00.00.001 } /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i im3101b1 MIM}
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
&GLOBAL-DEFINE Program        IM3101B1
&GLOBAL-DEFINE Version        1.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 cEmbarqueIni cEmbarqueFim ~
                              dtNacionalizacaoIni dtNacionalizacaoFim ~
                              cProcessoIni cProcessoFim dtDiIni dtDiFim ~
                              iItinerarioIni iItinerarioFim iExportadorIni iExportadorFim ~
                              tg-mostra-embarq-sem-despesa
{cdp/cdcfgmat.i}
{cdp/cdcfgcex.i}
{cxbo/bocx220h.i tt-selecao-embarque}

/* Parameters Definitions ---                                           */
define input        parameter c-cod-estabel               LIKE estabelec.cod-estabel  no-undo.     
define input-output parameter c-embarque-ini              LIKE embarque-imp.embarque  no-undo. 
define input-output parameter c-embarque-fim              LIKE embarque-imp.embarque  no-undo. 
define input-output parameter dt-nacionalizacao-ini       as date format "99/99/9999" no-undo. 
define input-output parameter dt-nacionalizacao-fim       as date format "99/99/9999" no-undo. 
define input-output parameter c-processo-ini              as char format "x(12)"      no-undo. 
define input-output parameter c-processo-fim              as char format "x(12)"      no-undo. 
define input-output parameter dt-di-ini                   as date format "99/99/9999" no-undo. 
define input-output parameter dt-di-fim                   as date format "99/99/9999" no-undo. 
define input-output parameter i-itinerario-ini            as int  format ">>,>>9"     no-undo. 
define input-output parameter i-itinerario-fim            as int  format ">>,>>9"     no-undo. 
define input-output parameter i-exportador-ini            as int  format ">>>>>>>>9"  no-undo. 
define input-output parameter i-exportador-fim            as int  format ">>>>>>>>9"  no-undo. 
define input-output parameter l-mostra-embarq-sem-despesa as log                      no-undo. 
define input  parameter table for tt-selecao-embarque. 
define output parameter l-ok                              as log                      no-undo. 

                        

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
&Scoped-Define ENABLED-OBJECTS cEmbarqueIni cEmbarqueFim ~
dtNacionalizacaoIni dtNacionalizacaoFim cProcessoIni cProcessoFim dtDiIni ~
dtDiFim iItinerarioIni iItinerarioFim iExportadorIni iExportadorFim ~
tg-mostra-embarq-sem-despesa btOK btCancel IMAGE-10 btHelp2 IMAGE-11 ~
IMAGE-13 IMAGE-15 IMAGE-16 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-25 IMAGE-27 ~
IMAGE-28 IMAGE-9 rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS cestabelecimento cEmbarqueIni cEmbarqueFim ~
dtNacionalizacaoIni dtNacionalizacaoFim cProcessoIni cProcessoFim dtDiIni ~
dtDiFim iItinerarioIni iItinerarioFim iExportadorIni iExportadorFim ~
tg-mostra-embarq-sem-despesa 

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

DEFINE VARIABLE cEmbarqueFim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cEmbarqueIni AS CHARACTER FORMAT "X(16)":U 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cestabelecimento LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R7 
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88 NO-UNDO.

DEFINE VARIABLE cProcessoFim AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE cProcessoIni AS CHARACTER FORMAT "X(12)":U 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE dtDiFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtDiIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Data DI" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtNacionalizacaoFim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE dtNacionalizacaoIni AS DATE FORMAT "99/99/9999":U 
     LABEL "Dt Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE iExportadorFim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iExportadorIni AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Exportador" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE iItinerarioFim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE iItinerarioIni AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-27
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-28
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-mostra-embarq-sem-despesa AS LOGICAL INITIAL no 
     LABEL "Mostra Embarque Sem Despesa" 
     VIEW-AS TOGGLE-BOX
     SIZE 25.86 BY .76 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cestabelecimento AT ROW 1.92 COL 17.86 COLON-ALIGNED HELP
          ""
          LABEL "Estabelecimento":R7
     cEmbarqueIni AT ROW 2.92 COL 17.86 COLON-ALIGNED
     cEmbarqueFim AT ROW 2.92 COL 56.14 COLON-ALIGNED NO-LABEL
     dtNacionalizacaoIni AT ROW 3.92 COL 17.86 COLON-ALIGNED
     dtNacionalizacaoFim AT ROW 3.92 COL 56.14 COLON-ALIGNED NO-LABEL
     cProcessoIni AT ROW 4.92 COL 17.86 COLON-ALIGNED
     cProcessoFim AT ROW 4.92 COL 56.14 COLON-ALIGNED NO-LABEL
     dtDiIni AT ROW 5.92 COL 18 COLON-ALIGNED
     dtDiFim AT ROW 5.92 COL 56.29 COLON-ALIGNED NO-LABEL
     iItinerarioIni AT ROW 6.92 COL 18 COLON-ALIGNED
     iItinerarioFim AT ROW 6.92 COL 56.29 COLON-ALIGNED NO-LABEL
     iExportadorIni AT ROW 7.92 COL 18 COLON-ALIGNED
     iExportadorFim AT ROW 7.92 COL 56.29 COLON-ALIGNED NO-LABEL
     tg-mostra-embarq-sem-despesa AT ROW 8.92 COL 20.14 WIDGET-ID 2
     btOK AT ROW 10.29 COL 2
     btCancel AT ROW 10.29 COL 13
     btHelp2 AT ROW 10.29 COL 80
     IMAGE-10 AT ROW 6.92 COL 46.72
     IMAGE-11 AT ROW 5.92 COL 46.72
     IMAGE-13 AT ROW 4.92 COL 46.57
     IMAGE-15 AT ROW 3.92 COL 46.57
     IMAGE-16 AT ROW 2.92 COL 46.57
     IMAGE-21 AT ROW 7.92 COL 55.29
     IMAGE-22 AT ROW 6.92 COL 55.29
     IMAGE-23 AT ROW 5.92 COL 55.29
     IMAGE-25 AT ROW 4.92 COL 55.14
     IMAGE-27 AT ROW 3.92 COL 55.14
     IMAGE-28 AT ROW 2.92 COL 55.14
     IMAGE-9 AT ROW 7.92 COL 46.72
     rtToolBar AT ROW 10.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 10.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 10.71
         WIDTH              = 90
         MAX-HEIGHT         = 18.46
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 18.46
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
/* SETTINGS FOR FILL-IN cestabelecimento IN FRAME fpage0
   NO-ENABLE LIKE = mgadm.estabelec.cod-estabel EXP-LABEL EXP-SIZE      */
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
    assign l-ok = no.
    apply "CLOSE":U to this-procedure.
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
    if  can-find (first  tt-selecao-embarque 
                   where tt-selecao-embarque.marca = "X":U) then do:
        run utp/ut-msgs.p (input "show":U,
                           input 29405,
                           input "").
        if  return-value = "NO" then do:
            apply "close":U to this-procedure.
            return no-apply.
        end.
    end.

    assign  c-embarque-ini              = input frame fPage0 cEmbarqueIni
            c-embarque-fim              = input frame fPage0 cEmbarqueFim
            dt-nacionalizacao-ini       = input frame fPage0 dtNacionalizacaoIni
            dt-nacionalizacao-fim       = input frame fPage0 dtNacionalizacaoFim
            c-processo-ini              = input frame fPage0 cProcessoIni
            c-processo-fim              = input frame fPage0 cProcessoFim
            dt-di-ini                   = input frame fPage0 dtDiIni
            dt-di-fim                   = input frame fPage0 dtDiFim
            i-itinerario-ini            = input frame fPage0 iItinerarioIni
            i-itinerario-fim            = input frame fPage0 iItinerarioFim
            i-exportador-ini            = input frame fPage0 iExportadorIni
            i-exportador-fim            = input frame fPage0 iExportadorFim
            l-mostra-embarq-sem-despesa = input frame fPage0 tg-mostra-embarq-sem-despesa
            l-ok                        = yes.


    apply "close":U to this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
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
    
    assign cEstabelecimento             = c-cod-estabel
           cEmbarqueIni                 = c-embarque-ini        
           cEmbarqueFim                 = c-embarque-fim 
           dtNacionalizacaoIni          = dt-nacionalizacao-ini 
           dtNacionalizacaoFim          = dt-nacionalizacao-fim 
           cProcessoIni                 = c-processo-ini        
           cProcessoFim                 = c-processo-fim        
           dtDiIni                      = dt-di-ini             
           dtDiFim                      = dt-di-fim             
           iItinerarioIni               = i-itinerario-ini      
           iItinerarioFim               = i-itinerario-fim      
           iExportadorIni               = i-exportador-ini      
           iExportadorFim               = i-exportador-fim
           tg-mostra-embarq-sem-despesa = l-mostra-embarq-sem-despesa.

    display {&page0Widgets} cEstabelecimento with frame fPage0.
    
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

