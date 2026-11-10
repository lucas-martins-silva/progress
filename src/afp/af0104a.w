&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i AF0104A 2.00.00.006 } /*** 010006 ***/
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
&GLOBAL-DEFINE Program       AF0104A
&GLOBAL-DEFINE Version        2.00.00.006

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 iControle dPercentual cNarrativa c-cod-grp-resp ~
                              l-utiliza-per-variavel cb-periodicidade 

{afbo/boaf005.i ttAf-item-contr-form}

DEF BUFFER bttAf-item-contr-form FOR ttAf-item-contr-form.

{utp/ut-glob.i}
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER i-tipo       AS INT.
DEFINE INPUT PARAMETER c-it-codigo  LIKE af-item-contr.it-codigo.
DEFINE INPUT PARAMETER c-emitente   LIKE af-item-contr.cod-emitente.
DEFINE INPUT PARAMETER i-versao     LIKE af-item-contr.nr-versao.
DEFINE INPUT PARAMETER i-controle   LIKE af-controle.nr-controle.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttAf-item-contr-form.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf019    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf008    AS HANDLE NO-UNDO.
DEFINE VARIABLE iSeq         AS INTEGER NO-UNDO.
DEFINE VARIABLE da-prox-aval AS DATE FORMAT 99/99/9999 NO-UNDO.
DEFINE VARIABLE l-habilita   AS LOGICAL NO-UNDO.
DEFINE VARIABLE c-cod-grp-resp-aux LIKE af-item-contr-form.cod-grp-resp  NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-30 RECT-31 RECT-46 rtToolBar iControle ~
cDescricao c-cod-grp-resp dPercentual l-utiliza-per-variavel ~
cb-periodicidade cNarrativa btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS iControle cDescricao c-cod-grp-resp ~
c-des-grp-resp dPercentual l-utiliza-per-variavel cb-periodicidade ~
cNarrativa 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE VARIABLE cb-periodicidade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Periodicidade" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cNarrativa AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 58 BY 6.13 NO-UNDO.

DEFINE VARIABLE c-cod-grp-resp AS CHARACTER FORMAT "X(8)":U 
     LABEL "Grupo Respons vel" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-grp-resp AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 32.72 BY .88 NO-UNDO.

DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .88 NO-UNDO.

DEFINE VARIABLE dPercentual AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Percentual" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE iControle AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "N£mero Controle" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 3.71.

DEFINE RECTANGLE RECT-31
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 6.63.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.46.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 60 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE l-utiliza-per-variavel AS LOGICAL INITIAL no 
     LABEL "Utiliza Per¡odo Avalia‡Æo Vari vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .88 TOOLTIP "Utiliza Per¡odo Avalia‡Æo Variavel" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     iControle AT ROW 1.5 COL 14 COLON-ALIGNED
     cDescricao AT ROW 1.5 COL 22.14 COLON-ALIGNED NO-LABEL
     c-cod-grp-resp AT ROW 2.5 COL 14 COLON-ALIGNED
     c-des-grp-resp AT ROW 2.5 COL 25.29 COLON-ALIGNED NO-LABEL
     dPercentual AT ROW 3.5 COL 14 COLON-ALIGNED
     l-utiliza-per-variavel AT ROW 5 COL 19.14
     cb-periodicidade AT ROW 6 COL 9
     cNarrativa AT ROW 7.71 COL 59 RIGHT-ALIGNED NO-LABEL
     btOK AT ROW 14.46 COL 2
     btCancel AT ROW 14.46 COL 13
     btHelp2 AT ROW 14.46 COL 50.29
     RECT-30 AT ROW 1.08 COL 1
     RECT-31 AT ROW 7.5 COL 1
     RECT-46 AT ROW 4.79 COL 1
     rtToolBar AT ROW 14.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 14.88
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
         HEIGHT             = 14.83
         WIDTH              = 60.14
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
/* SETTINGS FOR FILL-IN c-des-grp-resp IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX cb-periodicidade IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR EDITOR cNarrativa IN FRAME fpage0
   ALIGN-R                                                              */
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
    
    RUN validaGrupoResp IN h-boaf019 (INPUT FRAME fPage0 c-cod-grp-resp, INPUT INPUT FRAME fPage0 iControle).
    IF RETURN-VALUE = "NOK" THEN DO:
       /* Inicio -- Projeto Internacional */
       {utp/ut-liter.i "Grupo_Respons vel" *}
       RUN utp/ut-msgs.p (INPUT "show",
                          INPUT 56,
                          INPUT RETURN-VALUE).
      APPLY "ENTRY" TO c-cod-grp-resp IN FRAME fPage0.
      RETURN NO-APPLY.
    END.    

    IF i-tipo = 1 THEN DO:
        RUN gotokey IN h-boaf001 (INPUT FRAME fPage0 iControle).
        IF RETURN-VALUE = "NOK" THEN DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Ponto_de_Controle" *}
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 56,
                              INPUT RETURN-VALUE).
          APPLY "ENTRY" TO iControle IN FRAME fPage0.
          RETURN.
        END.
        FIND FIRST bttAf-item-contr-form
            WHERE bttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
            AND   bttAf-item-contr-form.it-codigo    = c-it-codigo
            AND   bttAf-item-contr-form.cod-emitente = c-emitente
            AND   bttAf-item-contr-form.nr-controle  = INPUT FRAME fPage0 iControle
            NO-LOCK NO-ERROR.
        IF AVAIL bttAf-item-contr-form THEN DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Ponto_de_Controle" *}
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT 7,
                              INPUT RETURN-VALUE).
          APPLY "ENTRY" TO iControle IN FRAME fPage0.
          RETURN.
        END.
        IF INPUT FRAME fPage0 iControle >= 1 AND INPUT FRAME fPage0 iControle <= 4 THEN DO:
           /* Inicio -- Projeto Internacional */
           {utp/ut-liter.i "Ponto_de_Controle_dever_ser_inclu¡do_na_tela_principal" *}
           RUN utp/ut-msgs.p (INPUT "show",
                              INPUT  17567,
                              INPUT RETURN-VALUE + ".").
           APPLY "ENTRY" TO iControle IN FRAME fPage0.
           RETURN.
        END.
        FIND LAST ttAf-item-contr-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-item-contr-form THEN
           ASSIGN iSeq = ttAf-item-contr-form.seq + 10.
        ELSE 
           ASSIGN iSeq = 10.
        CREATE ttAf-item-contr-form.
        ASSIGN ttAf-item-contr-form.ep-codigo        = i-ep-codigo-usuario
               ttAf-item-contr-form.it-codigo        = c-it-codigo
               ttAf-item-contr-form.cod-emitente     = c-emitente
               ttAf-item-contr-form.nr-controle      = INPUT FRAME fPage0 iControle
               ttAf-item-contr-form.percentual       = INPUT FRAME fPage0 dPercentual
               ttAf-item-contr-form.seq              = iSeq 
               ttAf-item-contr-form.narrativa        = INPUT FRAME fPage0 cNarrativa
               ttAf-item-contr-form.cod-grp-resp     = input frame fPage0 c-cod-grp-resp
               ttAf-item-contr-form.log-per-variavel = l-utiliza-per-variavel:checked in frame fPage0 
               ttAf-item-contr-form.ind-tipo-periodo = {afinc/i01af017.i 06 cb-periodicidade:screen-value in frame fPage0}.
    END.
    ELSE  DO:
        IF AVAIL ttAf-item-contr-form THEN DO:
           ASSIGN ttAf-item-contr-form.dt-alter         = TODAY
                  ttAf-item-contr-form.hora-alter       = STRING(TIME,"HH:MM:SS")
                  ttAf-item-contr-form.usuar-alter      = c-seg-usuario
                  ttAf-item-contr-form.percentual       = INPUT FRAME fPage0 dPercentual
                  ttAf-item-contr-form.narrativa        = INPUT FRAME fPage0 cNarrativa
                  ttAf-item-contr-form.cod-grp-resp     = input frame fPage0 c-cod-grp-resp
                  ttAf-item-contr-form.log-per-variavel = l-utiliza-per-variavel:checked in frame fPage0 
                  ttAf-item-contr-form.ind-tipo-periodo = {afinc/i01af017.i 06 cb-periodicidade:screen-value in frame fPage0}.
        END.
    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-grp-resp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-resp wWindow
ON F5 OF c-cod-grp-resp IN FRAME fpage0 /* Grupo Respons vel */
DO:
  
    {method/zoomfields.i &ProgramZoom="afzoom/z01af019.w"
                         &FieldZoom1="cod-grp-resp"
                         &FieldScreen1="c-cod-grp-resp"
                         &Frame1="fPage0"
                         &FieldZoom2="des-grp-resp"
                         &FieldScreen2="c-des-grp-resp"
                         &Frame2="fPage0"                         
                         &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-resp wWindow
ON LEAVE OF c-cod-grp-resp IN FRAME fpage0 /* Grupo Respons vel */
DO:
  
    {method/referencefields.i &HandleDBOLeave="h-boaf019"
                              &KeyValue1="input frame fPage0 c-cod-grp-resp"
                              &FieldName1="des-grp-resp"
                              &FieldScreen1="c-des-grp-resp"
                              &Frame1="fPage0"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-grp-resp wWindow
ON MOUSE-SELECT-DBLCLICK OF c-cod-grp-resp IN FRAME fpage0 /* Grupo Respons vel */
DO:
    apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME iControle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iControle wWindow
ON F5 OF iControle IN FRAME fpage0 /* N£mero Controle */
DO:
 {method/zoomfields.i &ProgramZoom="afzoom/z01af001.w"
                      &FieldZoom1="Nr-controle"
                      &FieldScreen1="iControle"
                      &Frame1="fPage0"
                      &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iControle wWindow
ON LEAVE OF iControle IN FRAME fpage0 /* N£mero Controle */
DO:
    ASSIGN c-cod-grp-resp = ttAf-item-contr-form.cod-grp-resp WHEN AVAIL  ttAf-item-contr-form.
    RUN gotokey      IN h-boaf001 (INPUT iControle:SCREEN-VALUE IN FRAME fpage0).
    IF  RETURN-VALUE = "ok" THEN do:
        RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                       OUTPUT cDescricao).
        IF i-tipo = 1 THEN
            RUN getcharfield IN h-boaf001 (INPUT "cod-grp-resp",
                                           OUTPUT c-cod-grp-resp).
    end.
    ELSE 
        assign cDescricao     = ""
               c-cod-grp-resp = "".

    DISP cDescricao c-cod-grp-resp WITH FRAME fpage0.
    apply "leave" to c-cod-grp-resp in frame fPage0.

    RUN getGrupoRespon IN h-boaf001 ( INPUT FRAME fPage0 iControle,
                                      OUTPUT c-cod-grp-resp-aux,
                                      OUTPUT l-utiliza-per-variavel,
                                      OUTPUT cb-periodicidade ).
    ASSIGN c-cod-grp-resp = c-cod-grp-resp-aux WHEN i-tipo = 1.

    ASSIGN c-cod-grp-resp:SCREEN-VALUE IN FRAME fPage0 = c-cod-grp-resp
           l-utiliza-per-variavel:CHECKED IN FRAME fPage0 = l-utiliza-per-variavel
           cb-periodicidade:SCREEN-VALUE IN FRAME fPage0 = {afinc/i01af017.i 04 INT(cb-periodicidade)}.

    RUN piHabilitaPeriodoAvaliacao IN h-boaf001 (INPUT FRAME fPage0 iControle,
                                                 OUTPUT l-habilita).
    IF l-habilita THEN
        ENABLE l-utiliza-per-variavel 
               cb-periodicidade WITH FRAME fpage0.
    ELSE
        DISABLE l-utiliza-per-variavel
                cb-periodicidade WITH FRAME fpage0.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL iControle wWindow
ON MOUSE-SELECT-DBLCLICK OF iControle IN FRAME fpage0 /* N£mero Controle */
DO:
  APPLY "f5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME l-utiliza-per-variavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL l-utiliza-per-variavel wWindow
ON VALUE-CHANGED OF l-utiliza-per-variavel IN FRAME fpage0 /* Utiliza Per¡odo Avalia‡Æo Vari vel */
DO:
    if  l-utiliza-per-variavel:checked in frame fPage0 then 
        assign cb-periodicidade:sensitive in frame fPage0 = yes.
    else
        assign cb-periodicidade:sensitive in frame fPage0 = no.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    if  valid-handle (h-boaf019) then do:
        delete procedure h-boaf019.
        assign h-boaf019 = ?.
    end.

    if  valid-handle (h-boaf008) then do:
        delete procedure h-boaf008.
        assign h-boaf008 = ?.
    end.

    if  valid-handle (h-boaf001) then do:
        delete procedure h-boaf001.
        assign h-boaf001 = ?.
    end.

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

    RUN gotokey      IN h-boaf001 (INPUT i-ep-codigo-usuario, 
                                   INPUT iControle:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "ok" THEN
       RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                      OUTPUT cDescricao).
    ELSE cDescricao = "".

    DISP cDescricao WITH FRAME fpage0.

    apply "leave" to c-cod-grp-resp in frame fPage0. 

    return "OK":U.
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
    c-cod-grp-resp:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.

    assign cb-periodicidade:list-items in frame fPage0 = {afinc/i01af017.i 03} no-error.

    IF i-tipo = 2 THEN DO:
       FIND ttAf-item-contr-form
           WHERE ttAf-item-contr-form.ep-codigo    = i-ep-codigo-usuario
           AND   ttAf-item-contr-form.it-codigo    = c-it-codigo
           AND   ttAf-item-contr-form.cod-emitente = c-emitente
           AND   ttAf-item-contr-form.nr-versao    = i-versao
           AND   ttAf-item-contr-form.nr-controle  = i-controle
           NO-ERROR.
       IF AVAIL ttAf-item-contr-form THEN DO:
          ASSIGN iControle:SCREEN-VALUE         IN FRAME fPage0 = STRING(i-controle)
                 dPercentual:SCREEN-VALUE       IN FRAME fPage0 = STRING(ttAf-item-contr-form.percentual)
                 cNarrativa:SCREEN-VALUE        IN FRAME fPage0 = ttAf-item-contr-form.narrativa
                 c-cod-grp-resp:screen-value    in frame fPage0 = ttAf-item-contr-form.cod-grp-resp
                 l-utiliza-per-variavel:checked in frame fPage0 = ttAf-item-contr-form.log-per-variavel.
          assign cb-periodicidade:screen-value  in frame fPage0 = {afinc/i01af017.i 04 ttAf-item-contr-form.ind-tipo-periodo}.

          DISABLE iControle WITH FRAME fPage0.
       END.
       RUN gotokey      IN h-boaf001 (INPUT i-Controle).
       IF RETURN-VALUE = "ok" THEN
          RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                         OUTPUT cDescricao).
       ELSE cDescricao = "".
       DISP cDescricao WITH FRAME fpage0.
       apply "leave" to c-cod-grp-resp in frame fpage0.
    END.
    else do: 
        iControle:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
        assign cb-periodicidade:screen-value  in frame fPage0 = {afinc/i01af017.i 04 1}.
    end.

    IF NOT VALID-HANDLE(h-boaf001) OR
       h-boaf001:TYPE <> "PROCEDURE":U OR
       h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
       
       RUN afbo/boaf001.p PERSISTENT SET h-boaf001.
    
    END.
    RUN openQueryStatic IN h-boaf001 (INPUT "Main":U) NO-ERROR.
    RUN openQueryStatic IN h-boaf019 (INPUT "Main":U) NO-ERROR.

    RUN piHabilitaPeriodoAvaliacao IN h-boaf001 (INPUT i-Controle,
                                                 OUTPUT l-habilita).
    IF l-habilita THEN
        ENABLE l-utiliza-per-variavel WITH FRAME fpage0.
    ELSE
        DISABLE l-utiliza-per-variavel WITH FRAME fpage0.

    apply "value-changed" to l-utiliza-per-variavel in frame fPage0.
    APPLY "leave":U TO iControle IN FRAME fPage0.

    return "OK":U.
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
    IF NOT VALID-HANDLE(h-boaf001) OR
       h-boaf001:TYPE <> "PROCEDURE":U OR
       h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
       RUN afbo/boaf001.p PERSISTENT SET h-boaf001.      
    END.
    
    if  not valid-handle(h-boaf019)
    or  h-boaf019:type      <> "PROCEDURE":U 
    or  h-boaf019:file-name <> "afbo/boaf019.p":U then 
       run afbo/boaf019.p persistent set h-boaf019.
    
    if  not valid-handle(h-boaf008)
    or  h-boaf008:type      <> "PROCEDURE":U 
    or  h-boaf008:file-name <> "afbo/boaf008.p":U then 
       run afbo/boaf008.p persistent set h-boaf008.

    return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

