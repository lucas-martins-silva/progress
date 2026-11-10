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
{include/i-prgvrs.i AF0111A 2.00.00.005 } /*** 010005 ***/
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
&GLOBAL-DEFINE Program       AF0111A
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 iControle cCodGrpResp dPercentual ~
tg-utiliza-periodo cb-periodicidade cNarrativa

{afbo/boaf018.i ttAf-grp-avaliacao-form}
DEF BUFFER bttAf-grp-avaliacao-form FOR ttAf-grp-avaliacao-form.
{utp/ut-glob.i}
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER i-tipo              AS INT.
DEFINE INPUT PARAMETER i-cod-grp-avaliacao LIKE ttAf-grp-avaliacao-form.cod-grp-avaliacao.
DEFINE INPUT PARAMETER i-controle          LIKE ttAf-grp-avaliacao-form.nr-controle.
DEFINE INPUT PARAMETER i-nr-versao         LIKE ttAf-grp-avaliacao-form.nr-versao.
DEFINE INPUT-OUTPUT PARAMETER TABLE  FOR ttAf-grp-avaliacao-form.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf019    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf008    AS HANDLE NO-UNDO.
DEFINE VARIABLE iSeq         AS INTEGER NO-UNDO.
DEFINE VARIABLE l-habilita   AS LOGICAL NO-UNDO.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-30 RECT-31 RECT-47 rtToolBar iControle ~
cDescricao cCodGrpResp cDesGrpResp dPercentual tg-utiliza-periodo ~
cb-periodicidade cNarrativa btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS iControle cDescricao cCodGrpResp ~
cDesGrpResp dPercentual tg-utiliza-periodo cb-periodicidade cNarrativa 

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
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE cNarrativa AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 2000 SCROLLBAR-VERTICAL
     SIZE 57 BY 5.75 NO-UNDO.

DEFINE VARIABLE cCodGrpResp AS CHARACTER FORMAT "X(8)" 
     LABEL "Grupo Respons vel" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 NO-UNDO.

DEFINE VARIABLE cDesGrpResp AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 29 BY .88 NO-UNDO.

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
     SIZE 60 BY 6.5.

DEFINE RECTANGLE RECT-47
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 2.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 60 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tg-utiliza-periodo AS LOGICAL INITIAL no 
     LABEL "Utiliza Per¡odo Avalia‡Æo Vari vel" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .88 TOOLTIP "Utiliza Per¡odo Avalia‡Æo Vari vel" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     iControle AT ROW 1.71 COL 14 COLON-ALIGNED
     cDescricao AT ROW 1.71 COL 22 COLON-ALIGNED NO-LABEL
     cCodGrpResp AT ROW 2.75 COL 14 COLON-ALIGNED
     cDesGrpResp AT ROW 2.75 COL 23 COLON-ALIGNED HELP
          "Descri‡Æo do grupo respons vel pela avalia‡Æo" NO-LABEL
     dPercentual AT ROW 3.71 COL 14 COLON-ALIGNED
     tg-utiliza-periodo AT ROW 5 COL 17
     cb-periodicidade AT ROW 6 COL 15 COLON-ALIGNED
     cNarrativa AT ROW 7.75 COL 58 RIGHT-ALIGNED NO-LABEL
     btOK AT ROW 14.46 COL 2
     btCancel AT ROW 14.46 COL 13
     btHelp2 AT ROW 14.5 COL 50
     RECT-30 AT ROW 1.04 COL 1
     RECT-31 AT ROW 7.5 COL 1
     RECT-47 AT ROW 4.75 COL 1
     rtToolBar AT ROW 14.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 60.14 BY 14.83
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
         HEIGHT             = 14.79
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

        RUN validaGrupoResp IN h-boaf019 (INPUT INPUT FRAME fPage0 cCodGrpResp, INPUT INPUT FRAME fPage0 iControle).
        IF RETURN-VALUE = "NOK" THEN DO:
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Grupo_Respons vel" *}
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 56,
                                INPUT RETURN-VALUE).
             APPLY "ENTRY" TO cCodGrpResp IN FRAME fPage0.
             RETURN.
        END.

        FIND FIRST bttAf-grp-avaliacao-form
            WHERE bttAf-grp-avaliacao-form.ep-codigo          = i-ep-codigo-usuario
            AND   bttAf-grp-avaliacao-form.cod-grp-avaliacao  = i-cod-grp-avaliacao
            AND   bttAf-grp-avaliacao-form.nr-versao          = i-nr-versao
            AND   bttAf-grp-avaliacao-form.nr-controle        = INPUT FRAME fPage0 iControle
            NO-LOCK NO-ERROR.
        IF AVAIL bttAf-grp-avaliacao-form THEN DO:
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
        FIND LAST ttAf-grp-avaliacao-form NO-LOCK NO-ERROR.
        IF AVAIL ttAf-grp-avaliacao-form THEN
            ASSIGN iSeq = ttAf-grp-avaliacao-form.seq + 10.
        ELSE
           ASSIGN iSeq = 10.  

        CREATE ttAf-grp-avaliacao-form.
        ASSIGN ttAf-grp-avaliacao-form.ep-codigo         = i-ep-codigo-usuario
               ttAf-grp-avaliacao-form.cod-grp-avaliacao = i-cod-grp-avaliacao
               ttAf-grp-avaliacao-form.nr-versao         = i-nr-versao
               ttAf-grp-avaliacao-form.nr-controle       = INPUT FRAME fPage0 iControle
               ttAf-grp-avaliacao-form.cod-grp-resp      = INPUT FRAME fPage0 cCodGrpResp
               ttAf-grp-avaliacao-form.percentual        = INPUT FRAME fPage0 dPercentual
               ttAf-grp-avaliacao-form.seq               = iSeq
               ttAf-grp-avaliacao-form.narrativa         = INPUT FRAME fPage0 cNarrativa
               ttAf-grp-avaliacao-form.ind-tipo-periodo  = {afinc/i01af017.i 06 cb-periodicidade:screen-value in frame fPage0 }
               ttAf-grp-avaliacao-form.log-per-variavel  = INPUT FRAME fPage0 tg-utiliza-periodo.
        IF ttAf-grp-avaliacao-form.ind-tipo-periodo = 0 THEN
            ASSIGN ttAf-grp-avaliacao-form.ind-tipo-periodo = 1.
    END.
    ELSE  DO:

        RUN validaGrupoResp IN h-boaf019 (INPUT INPUT FRAME fPage0 cCodGrpResp,INPUT INPUT FRAME fPage0 iControle).
        IF RETURN-VALUE = "NOK" THEN DO:        
             /* Inicio -- Projeto Internacional */
             {utp/ut-liter.i "Grupo_Respons vel" *}
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 56,
                                INPUT RETURN-VALUE).
             APPLY "ENTRY" TO cCodGrpResp IN FRAME fPage0.
             RETURN.
        END.
        
        IF INPUT FRAME fpage0 tg-utiliza-periodo = YES THEN DO:            
            IF INPUT FRAME fpage0 cb-periodicidade = "" THEN DO:
                /* Inicio -- Projeto Internacional */
                {utp/ut-liter.i "Periodicidade_de_AvaliacÆo_deve_ser_informada" *}
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT RETURN-VALUE).
                APPLY "ENTRY" TO cb-periodicidade IN FRAME fPage0.
                RETURN NO-APPLY.
            END.
        END.

        IF AVAIL ttAf-grp-avaliacao-form THEN DO:           
            ASSIGN ttAf-grp-avaliacao-form.dt-alter        = TODAY
                  ttAf-grp-avaliacao-form.hora-alter       = STRING(TIME,"HH:MM:SS")
                  ttAf-grp-avaliacao-form.usuar-alter      = c-seg-usuario
                  ttAf-grp-avaliacao-form.cod-grp-resp     = INPUT FRAME fPage0 cCodGrpResp
                  ttAf-grp-avaliacao-form.percentual       = INPUT FRAME fPage0 dPercentual
                  ttAf-grp-avaliacao-form.narrativa        = INPUT FRAME fPage0 cNarrativa
                  ttAf-grp-avaliacao-form.ind-tipo-periodo = {afinc/i01af017.i 06 cb-periodicidade:screen-value in frame fPage0 }
                  ttAf-grp-avaliacao-form.log-per-variavel = INPUT FRAME fPage0 tg-utiliza-periodo.
        END.

    END.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cCodGrpResp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodGrpResp wWindow
ON F5 OF cCodGrpResp IN FRAME fpage0 /* Grupo Respons vel */
DO:
  
     {method/zoomfields.i &ProgramZoom="afzoom/z01af019.w"
                      &FieldZoom1="cod-grp-resp"
                      &FieldScreen1="cCodGrpResp"
                      &Frame1="fPage0"
                      &EnableImplant="no"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodGrpResp wWindow
ON LEAVE OF cCodGrpResp IN FRAME fpage0 /* Grupo Respons vel */
DO:
  
    run getDesGrupoRespon in h-boaf019 ( input frame fPage0 cCodGrpResp,
                                         output cDesGrpResp ).
    assign cDesGrpResp:screen-value in frame fPage0 = cDesGrpResp.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cCodGrpResp wWindow
ON MOUSE-SELECT-DBLCLICK OF cCodGrpResp IN FRAME fpage0 /* Grupo Respons vel */
DO:
  
    APPLY "f5":U TO SELF.

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
  
    RUN gotokey      IN h-boaf001 (INPUT iControle:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "ok" THEN
       RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                      OUTPUT cDescricao).
    ELSE cDescricao = "".

    DISP cDescricao WITH FRAME fpage0.

    RUN getGrupoRespon IN h-boaf001 ( INPUT FRAME fPage0 iControle,
                                      OUTPUT cCodGrpResp,
                                      OUTPUT tg-utiliza-periodo,
                                      OUTPUT cb-periodicidade ).

    ASSIGN cCodGrpResp:SCREEN-VALUE IN FRAME fPage0 = cCodGrpResp
           tg-utiliza-periodo:CHECKED IN FRAME fPage0 = tg-utiliza-periodo
           cb-periodicidade:SCREEN-VALUE IN FRAME fPage0 = {afinc/i01af017.i 04 INT(cb-periodicidade)}.

    RUN piHabilitaPeriodoAvaliacao IN h-boaf001 (INPUT FRAME fPage0 iControle,
                                                 OUTPUT l-habilita).
    IF l-habilita THEN
        ENABLE tg-utiliza-periodo 
               cb-periodicidade WITH FRAME fpage0.
    ELSE
        DISABLE tg-utiliza-periodo
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


&Scoped-define SELF-NAME tg-utiliza-periodo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-utiliza-periodo wWindow
ON VALUE-CHANGED OF tg-utiliza-periodo IN FRAME fpage0 /* Utiliza Per¡odo Avalia‡Æo Vari vel */
DO:
  
    IF INPUT FRAME fPage0 tg-utiliza-periodo = NO THEN
        DISABLE cb-periodicidade WITH FRAME fPage0. 
    ELSE
        ENABLE cb-periodicidade WITH FRAME fPage0. 

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

    run getDesGrupoRespon in h-boaf019 ( input frame fPage0 cCodGrpResp,
                                         output cDesGrpResp ).
    assign cDesGrpResp:screen-value in frame fPage0 = cDesGrpResp.

    run getGrupoRespon in h-boaf001 ( input frame fPage0 iControle,
                                      output cCodGrpResp ).
    assign cCodGrpResp:screen-value in frame fPage0 = cCodGrpResp.

    assign cb-periodicidade:screen-value in frame fPage0 = {afinc/i01af017.i 04 ttAf-grp-avaliacao-form.ind-tipo-periodo} NO-ERROR.       
    
    apply "leave" to cCodGrpResp in frame fPage0.

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

    IF i-tipo = 2 THEN DO:
       FIND ttAf-grp-avaliacao-form
           WHERE ttAf-grp-avaliacao-form.ep-codigo          = i-ep-codigo-usuario
           AND   ttAf-grp-avaliacao-form.cod-grp-avaliacao  = i-cod-grp-avaliacao
           AND   ttAf-grp-avaliacao-form.nr-controle        = i-controle
           AND   ttAf-grp-avaliacao-form.nr-versao          = i-nr-versao
           NO-ERROR.
       IF AVAIL ttAf-grp-avaliacao-form THEN DO:
          ASSIGN iControle:SCREEN-VALUE IN FRAME fPage0           = STRING(i-controle)
                 cCodGrpResp:SCREEN-VALUE IN FRAME fPage0         = ttAf-grp-avaliacao-form.cod-grp-resp
                 dPercentual:SCREEN-VALUE IN FRAME fPage0         = STRING(ttAf-grp-avaliacao-form.percentual)
                 cNarrativa:SCREEN-VALUE IN FRAME fPage0          = ttAf-grp-avaliacao-form.narrativa
                 cb-periodicidade:SCREEN-VALUE IN FRAME fPage0    = {afinc/i01af017.i 04 ttAf-grp-avaliacao-form.ind-tipo-periodo}   
                 tg-utiliza-periodo:SCREEN-VALUE IN FRAME fPage0  = STRING(ttAf-grp-avaliacao-form.log-per-variavel).
          DISABLE iControle WITH FRAME fPage0.
       END.
       RUN gotokey      IN h-boaf001 (INPUT i-Controle).
      
       IF RETURN-VALUE = "OK" THEN
          RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                         OUTPUT cDescricao).
       ELSE cDescricao = "".      
      
       DISP cDescricao WITH FRAME fpage0.

       ASSIGN  cDescricao:SCREEN-VALUE IN FRAME fpage0 = cDescricao.

       run getDesGrupoRespon in h-boaf019 ( input frame fPage0 cCodGrpResp,
                                         output cDesGrpResp ).

       assign cDesGrpResp:screen-value in frame fPage0 = cDesGrpResp.
      
       IF INPUT FRAME fPage0 tg-utiliza-periodo = NO THEN
           DISABLE cb-periodicidade WITH FRAME fPage0. 
    END.
    ELSE iControle:load-mouse-pointer("image/lupa.cur":U) in frame fPage0.
         cCodGrpResp:load-mouse-pointer("image/lupa.cur":U) in frame fPage0. 

    
    
    IF NOT VALID-HANDLE(h-boaf001) OR
       h-boaf001:TYPE <> "PROCEDURE":U OR
       h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
       
       RUN afbo/boaf001.p PERSISTENT SET h-boaf001.
    
    END.


    RUN piHabilitaPeriodoAvaliacao IN h-boaf001 (INPUT i-Controle,
                                                 OUTPUT l-habilita).
    IF l-habilita THEN
        ENABLE tg-utiliza-periodo WITH FRAME fpage0.
    ELSE
        DISABLE tg-utiliza-periodo WITH FRAME fpage0.
   
    APPLY "value-changed" TO tg-utiliza-periodo IN FRAME fPage0.    

    ASSIGN iControle:SCREEN-VALUE IN FRAME fPage0  = STRING(i-controle).

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
assign cb-periodicidade:list-items in frame fPage0 = {afinc/i01af017.i 03} NO-ERROR.

IF NOT VALID-HANDLE(h-boaf001) OR
   h-boaf001:TYPE <> "PROCEDURE":U OR
   h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:

   RUN afbo/boaf001.p PERSISTENT SET h-boaf001.

   RUN openQueryStatic IN h-boaf001 (INPUT "Main":U) NO-ERROR.

END.

IF NOT VALID-HANDLE(h-boaf019) OR
   h-boaf019:TYPE <> "PROCEDURE":U OR
   h-boaf019:FILE-NAME <> "afbo/boaf019.p":U THEN DO:
   
   RUN afbo/boaf019.p PERSISTENT SET h-boaf019.
   RUN openQueryStatic IN h-boaf019 (INPUT "Main":U) NO-ERROR.
END.

IF  NOT VALID-HANDLE(h-boaf008) OR 
    h-boaf008:TYPE      <> "PROCEDURE":U OR 
    h-boaf008:FILE-NAME <> "afbo/boaf008.p":U THEN DO:

    run afbo/boaf008.p PERSISTENT SET h-boaf008.
    RUN openQueryStatic IN h-boaf008 (INPUT "Main":U) NO-ERROR.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

