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
{include/i-prgvrs.i AB0111C 2.00.00.001}  /*** 010001 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0111c MAB}
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
&GLOBAL-DEFINE Program        AB0111C
&GLOBAL-DEFINE Version        2.00.00.001

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiEpIni fiEpFim ~
                              fiEstabelIni fiEstabelFim ~
                              fiMatrIni fiMatrFim

define variable hAcomp  as handle  no-undo.
{frbo~/bofr017.i tt-driver}

/* Parameters Definitions ---                                           */
define input parameter p-ep-codigo    like mab-motoris.ep-codigo   no-undo.
define input parameter p-cod-estabel  like mab-motoris.cod-estabel no-undo.
define input parameter p-cod-matr     like mab-motoris.cod-matr    no-undo.

DEFINE VARIABLE c-msg AS CHARACTER  NO-UNDO.
DEFINE VARIABLE dir_name AS CHARACTER.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-1 IMAGE-2 IMAGE-3 IMAGE-4 IMAGE-5 ~
IMAGE-6 RECT-21 rtToolBar fiEpini fiEpFim fiEstabelIni fiEstabelFim ~
fiMatrIni fiMatrFim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fiEpini fiEpFim fiEstabelIni fiEstabelFim ~
fiMatrIni fiMatrFim 

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

DEFINE VARIABLE fiEpFim LIKE mab-eqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEpini LIKE mab-eqpto.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabelFim LIKE mab-motoris.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiEstabelIni LIKE mab-motoris.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7.14 BY .88
     FONT 1 NO-UNDO.

DEFINE VARIABLE fiMatrFim LIKE mab-motoris.cod-matr
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiMatrIni LIKE mab-motoris.cod-matr
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 63 BY 4.71.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 63 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiEpini AT ROW 1.83 COL 19.15
          FONT 1
     fiEpFim AT ROW 1.83 COL 39.29 NO-LABEL
          FONT 1
     fiEstabelIni AT ROW 2.83 COL 10.85
          FONT 1
     fiEstabelFim AT ROW 2.83 COL 39.29 NO-LABEL
          FONT 1
     fiMatrIni AT ROW 3.83 COL 19.14 COLON-ALIGNED
     fiMatrFim AT ROW 3.83 COL 37.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 5.96 COL 2
     btCancel AT ROW 5.96 COL 13
     btHelp2 AT ROW 5.96 COL 52.86
     IMAGE-1 AT ROW 1.83 COL 31.57
     IMAGE-2 AT ROW 1.83 COL 36.14
     IMAGE-3 AT ROW 2.83 COL 31.57
     IMAGE-4 AT ROW 2.83 COL 36.14
     IMAGE-5 AT ROW 3.83 COL 31.57
     IMAGE-6 AT ROW 3.83 COL 36.14
     RECT-21 AT ROW 1 COL 1
     rtToolBar AT ROW 5.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1.04
         SIZE 63 BY 6.21
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
         TITLE              = "Exporta‡Æo Motorista"
         HEIGHT             = 6.25
         WIDTH              = 62.86
         MAX-HEIGHT         = 27.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 27.21
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fiEpFim IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.ep-codigo EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEpini IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-eqpto.ep-codigo EXP-SIZE                    */
/* SETTINGS FOR FILL-IN fiEstabelFim IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-motoris.cod-estabel EXP-SIZE                */
/* SETTINGS FOR FILL-IN fiEstabelIni IN FRAME fpage0
   ALIGN-L LIKE = mgfro.mab-motoris.cod-estabel EXP-SIZE                */
/* SETTINGS FOR FILL-IN fiMatrFim IN FRAME fpage0
   LIKE = mgfro.mab-motoris.cod-matr EXP-SIZE                           */
/* SETTINGS FOR FILL-IN fiMatrIni IN FRAME fpage0
   LIKE = mgfro.mab-motoris.cod-matr EXP-SIZE                           */
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
ON END-ERROR OF wWindow /* Exporta‡Æo Motorista */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Exporta‡Æo Motorista */
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
do:
    blk1:
    do on stop undo, return "NOK":U:
        /** Verifica parametro de integracao do AB0116 **/
        {utp/ut-liter.i Sim}
        for first mab-param-integr
            where mab-param-integr.cdn-param = 10
              and trim(entry(3,mab-param-integr.des-valor)) = trim(return-value) no-lock:
        end.
        if not avail mab-param-integr then return.
        
        /** Busca catalogo de Documentos **/
        for first catal_docto_anexo
            where catal_docto_anexo.cod_catal_docto_anexo = trim(entry(5,mab-param-integr.des-valor)) no-lock:
        end.

        ASSIGN dir_name = catal_docto_anexo.cod_path_catal + "~\EXP".
        
        if not avail catal_docto_anexo then return.
        
        FILE-INFO:FILE-NAME = dir_name.
        
        IF FILE-INFO:full-pathname = ? THEN DO: 

            {utp/ut-liter.i "Arquivo(s)_nÆo_podem_ser_gerado(s)_verifique_o_catalogo"}
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-arquivos-nao-podem-ser-gerados AS CHARACTER NO-UNDO.
            ASSIGN c-lbl-liter-arquivos-nao-podem-ser-gerados = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-verifique-se-o-diretorio-de-ex AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Verifique_se_o_diretorio_de_exporta‡Æo_foi_criado_ou_modificado" *}
            ASSIGN c-lbl-liter-verifique-se-o-diretorio-de-ex = TRIM(RETURN-VALUE).
            run utp/ut-msgs.p (input "show",
                               input 27979,
                               input c-lbl-liter-arquivos-nao-podem-ser-gerados + "~~" + c-lbl-liter-verifique-se-o-diretorio-de-ex).
          
                            
             
            RETURN "NOK":U.
        END.

        /** Acompanhamento **/
        RUN utp/ut-acomp.p PERSISTENT SET hAcomp.
        {utp/ut-liter.i "Integra Rastreamento (XML)"}
        RUN pi-inicializar IN hAcomp (trim(return-value)).
    
        {utp/ut-liter.i Alguns_registros_nÆo_foram_gerados}
         ASSIGN c-msg = RETURN-VALUE.

        for each mab-motoris
            where mab-motoris.ep-codigo   >= &IF "{&mguni_version}" >= "2.071" &THEN fiEpIni:screen-value in frame fPage0 &else int(fiEpIni:screen-value in frame fPage0) &ENDIF
            and   mab-motoris.ep-codigo   <= &IF "{&mguni_version}" >= "2.071" &THEN fiEpFim:screen-value in frame fPage0 &else int(fiEpFim:screen-value in frame fPage0) &ENDIF
            and   mab-motoris.cod-estabel >= fiEstabelIni:screen-value in frame fPage0
            and   mab-motoris.cod-estabel <= fiEstabelFim:screen-value in frame fPage0
            and   mab-motoris.cod-matr    >= fiMatrIni:screen-value in frame fPage0
            and   mab-motoris.cod-matr    <= fiMatrFim:screen-value in frame fPage0 no-lock:

            empty temp-table tt-driver.
            create tt-driver.
            BUFFER-COPY mab-motoris to tt-driver.

            {utp/ut-liter.i Arquivo(s)_gerado(s)_com_sucesso}
            ASSIGN c-msg = RETURN-VALUE.

            /** Acompanhamento **/
            {utp/ut-liter.i "Motorista"}
            RUN pi-Acompanhar IN hAcomp (return-value + ": " + string(mab-motoris.ep-codigo) + " - " + mab-motoris.cod-estabel + " - " + mab-motoris.cod-matr).
            if return-value = "NOK":U then leave.
            /** Chamada do adpter de gera‡Æo do arquivo XML **/
            run adapters/xml/mn2/axsmf013.p (input table tt-driver,
                                                    input "ADD":U).
            if return-value = "NOK":U THEN DO: 
                {utp/ut-liter.i Alguns_registros_nÆo_foram_gerados}
                ASSIGN c-msg = RETURN-VALUE.
                leave.
            END.
            ELSE DO:
                {utp/ut-liter.i Arquivo(s)_gerado(s)_com_sucesso}
                ASSIGN c-msg = RETURN-VALUE.
            END.

        end.
        run utp/ut-msgs.p (input "show",
                           input 27979,
                           input RETURN-VALUE + ".").
        run pi-Finalizar in hAcomp.
 
               

        apply "CLOSE":U to this-procedure.

    end.    
end.

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
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializa‡Æo da tela
------------------------------------------------------------------------------*/
    {utp/ut-liter.i "Empresa"}
    ASSIGN fiEpIni:LABEL IN FRAME fPage0 = trim(return-value).
    {utp/ut-liter.i "Estabelecimento"}
    ASSIGN fiEstabelIni:LABEL IN FRAME fPage0 = trim(return-value).
    {utp/ut-liter.i "Motorista"}
    ASSIGN fiMatrIni:LABEL IN FRAME fPage0 = trim(return-value).
    
    assign fiEpIni:screen-value      in frame fPage0 = string(p-ep-codigo)
           fiEpFim:screen-value      in frame fPage0 = string(p-ep-codigo)
           fiEstabelIni:screen-value in frame fPage0 = p-cod-estabel
           fiEstabelFim:screen-value in frame fPage0 = p-cod-estabel
           fiMatrIni:screen-value    in frame fPage0 = p-cod-matr
           fiMatrFim:screen-value    in frame fPage0 = p-cod-matr.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

