&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          emsdca            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-Af-controle-result-aux NO-UNDO LIKE af-controle-result
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
{include/i-prgvrs.i AF0102A 2.00.00.005 } /*** 010005 ***/
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
&GLOBAL-DEFINE Program       AF0102A
&GLOBAL-DEFINE Version        2.00.00.005

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btSalvar btCancel btHelp2 ~

{afbo/boaf021.i tt-Af-controle-result}
DEF BUFFER btt-Af-controle-result FOR tt-Af-controle-result-aux.
{utp/ut-glob.i}
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER i-tipo        AS INT.
DEFINE INPUT PARAMETER i-controle    LIKE af-controle.nr-controle.
DEFINE INPUT PARAMETER c-descricao   LIKE af-controle.descricao.
DEFINE INPUT PARAMETER i-seq-result  LIKE af-controle-result.seq-result.
DEFINE INPUT PARAMETER h-caller      AS HANDLE NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR tt-af-controle-result-aux.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE h-boaf001    AS HANDLE NO-UNDO.
DEFINE VARIABLE h-boaf021    AS HANDLE NO-UNDO.
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
&Scoped-Define ENABLED-FIELDS tt-Af-controle-result-aux.nr-controle ~
tt-Af-controle-result-aux.seq-resultado tt-Af-controle-result-aux.descricao ~
tt-Af-controle-result-aux.indice ~
tt-Af-controle-result-aux.log-justificativa 
&Scoped-define ENABLED-TABLES tt-Af-controle-result-aux
&Scoped-define FIRST-ENABLED-TABLE tt-Af-controle-result-aux
&Scoped-Define ENABLED-OBJECTS RECT-30 RECT-46 rtToolBar cDescricao btOK ~
btSalvar btCancel btHelp2 
&Scoped-Define DISPLAYED-FIELDS tt-Af-controle-result-aux.nr-controle ~
tt-Af-controle-result-aux.seq-resultado tt-Af-controle-result-aux.descricao ~
tt-Af-controle-result-aux.indice ~
tt-Af-controle-result-aux.log-justificativa 
&Scoped-define DISPLAYED-TABLES tt-Af-controle-result-aux
&Scoped-define FIRST-DISPLAYED-TABLE tt-Af-controle-result-aux
&Scoped-Define DISPLAYED-OBJECTS cDescricao 

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

DEFINE BUTTON btSalvar 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cDescricao AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 29.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-30
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 1.96.

DEFINE RECTANGLE RECT-46
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 56 BY 4.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 56 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     tt-Af-controle-result-aux.nr-controle AT ROW 1.71 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     cDescricao AT ROW 1.71 COL 22 COLON-ALIGNED NO-LABEL
     tt-Af-controle-result-aux.seq-resultado AT ROW 3.75 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     tt-Af-controle-result-aux.descricao AT ROW 3.75 COL 20 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 32 BY .88
     tt-Af-controle-result-aux.indice AT ROW 4.75 COL 14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.86 BY .88
     tt-Af-controle-result-aux.log-justificativa AT ROW 5.75 COL 14 COLON-ALIGNED
          VIEW-AS TOGGLE-BOX
          SIZE 22 BY .88
     btOK AT ROW 7.46 COL 2
     btSalvar AT ROW 7.46 COL 13
     btCancel AT ROW 7.46 COL 24
     btHelp2 AT ROW 7.46 COL 46
     RECT-30 AT ROW 1.04 COL 1
     RECT-46 AT ROW 3 COL 1
     rtToolBar AT ROW 7.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 56.72 BY 7.83
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Other Settings: COMPILE
   Temp-Tables and Buffers:
      TABLE: tt-Af-controle-result-aux T "?" NO-UNDO emsdca af-controle-result
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
         TITLE              = ""
         HEIGHT             = 7.75
         WIDTH              = 56.29
         MAX-HEIGHT         = 29.29
         MAX-WIDTH          = 182.43
         VIRTUAL-HEIGHT     = 29.29
         VIRTUAL-WIDTH      = 182.43
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
/* SETTINGS FOR TOGGLE-BOX tt-Af-controle-result-aux.log-justificativa IN FRAME fpage0
   ALIGN-C                                                              */
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
    IF INPUT FRAME fpage0 tt-Af-controle-result-aux.indice > 100 THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Öndice" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 52857,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO tt-Af-controle-result-aux.indice IN FRAME fPage0.
        RETURN NO-APPLY.
    END.
    IF i-tipo = 1 THEN DO:
        CREATE tt-Af-controle-result-aux.
        ASSIGN INPUT FRAME fpage0 tt-Af-controle-result-aux.nr-controle tt-Af-controle-result-aux.descricao
             tt-Af-controle-result-aux.indice tt-Af-controle-result-aux.log-justificativa tt-Af-controle-result-aux.seq-resultado.
    END.
    ELSE DO:
        FIND tt-af-controle-result-aux
            WHERE tt-af-controle-result-aux.ep-codigo     = i-ep-codigo-usuario
            AND   tt-af-controle-result-aux.nr-controle   = i-controle 
            AND   tt-af-controle-result-aux.seq-resultado = i-seq-result NO-ERROR.
        IF AVAIL tt-af-controle-result-aux THEN DO:
            ASSIGN INPUT FRAME fpage0 tt-Af-controle-result-aux.descricao
             tt-Af-controle-result-aux.indice tt-Af-controle-result-aux.log-justificativa.
        END.
    END.
    RUN piSalva IN h-caller (INPUT TABLE tt-Af-controle-result-aux).
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSalvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSalvar wWindow
ON CHOOSE OF btSalvar IN FRAME fpage0 /* Salvar */
DO:
    IF INPUT FRAME fpage0 tt-Af-controle-result-aux.indice > 100 THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Öndice" *}
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 52857,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY" TO tt-Af-controle-result-aux.indice IN FRAME fPage0.
        RETURN NO-APPLY.
    END.
    
    IF CAN-FIND (tt-af-controle-result-aux WHERE 
          tt-af-controle-result-aux.ep-codigo     = i-ep-codigo-usuario AND 
          tt-af-controle-result-aux.nr-controle   = INPUT FRAME fpage0 tt-Af-controle-result-aux.nr-controle AND
          tt-af-controle-result-aux.seq-resultado = INPUT FRAME fpage0 tt-Af-controle-result-aux.seq-resultado)  THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-tabela-de-resultados AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tabela_de_Resultados" *}
        ASSIGN c-lbl-liter-tabela-de-resultados = TRIM(RETURN-VALUE).
        DEFINE VARIABLE c-lbl-liter-tabela-de-resultados-ja-inform AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Tabela_de_resultados_j _informada_para_o_n£mero_de_controle_e_sequncia" *}
        ASSIGN c-lbl-liter-tabela-de-resultados-ja-inform = TRIM(RETURN-VALUE).
        RUN utp/ut-msgs.p (INPUT "show",
                           INPUT 34658,
                           INPUT c-lbl-liter-tabela-de-resultados + " " + "~~" + 
                                 c-lbl-liter-tabela-de-resultados-ja-inform + ".").
        APPLY "ENTRY" TO tt-Af-controle-result-aux.seq-resultado IN FRAME fPage0.
        RETURN NO-APPLY.
    END.
    CREATE tt-Af-controle-result-aux.
    ASSIGN tt-Af-controle-result-aux.ep-codigo         = i-ep-codigo-usuario
           tt-Af-controle-result-aux.nr-controle       = INPUT FRAME fpage0 tt-Af-controle-result-aux.nr-controle
           tt-Af-controle-result-aux.seq-resultado     = INPUT FRAME fpage0 tt-Af-controle-result-aux.seq-resultado
           tt-Af-controle-result-aux.descricao         = INPUT FRAME fpage0 tt-Af-controle-result-aux.descricao
           tt-Af-controle-result-aux.indice            = INPUT FRAME fpage0 tt-Af-controle-result-aux.indice
           tt-Af-controle-result-aux.log-justificativa = INPUT FRAME fpage0 tt-Af-controle-result-aux.log-justificativa.
    
    RUN piSalva IN h-caller (INPUT TABLE tt-Af-controle-result-aux).
    ASSIGN tt-Af-controle-result-aux.descricao:SCREEN-VALUE IN FRAME fpage0 = ""
           tt-Af-controle-result-aux.indice:SCREEN-VALUE IN FRAME fpage0 = "0".
    FIND LAST tt-Af-controle-result-aux NO-LOCK NO-ERROR.
    ASSIGN iSeq = 10
           tt-Af-controle-result-aux.seq-resultado:SCREEN-VALUE IN FRAME fpage0 = string(tt-Af-controle-result-aux.seq-resultado + iSeq).


    APPLY "ENTRY" TO tt-Af-controle-result-aux.seq-resultado IN FRAME fPage0.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tt-Af-controle-result-aux.nr-controle
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tt-Af-controle-result-aux.nr-controle wWindow
ON LEAVE OF tt-Af-controle-result-aux.nr-controle IN FRAME fpage0 /* N£mero Controle */
DO:
  
    RUN gotokey      IN h-boaf001 (INPUT tt-Af-controle-result-aux.nr-controle:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "ok" THEN
       RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                      OUTPUT cDescricao).
    ELSE cDescricao = "".

    DISP cDescricao WITH FRAME fpage0.
    
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- Lgica para inicializao do programam ---*/
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

if  valid-handle (h-boaf021) then do:
    delete procedure h-boaf021.
    assign h-boaf021 = ?.
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
                                   INPUT tt-Af-controle-result-aux.nr-controle:SCREEN-VALUE IN FRAME fpage0).
    IF RETURN-VALUE = "ok" THEN
       RUN getcharfield IN h-boaf001 (INPUT "descricao",
                                      OUTPUT cDescricao).
    ELSE cDescricao = "".

    DISP cDescricao WITH FRAME fpage0.
    
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
    DISABLE tt-Af-controle-result-aux.nr-controle WITH FRAME fPage0.
    IF i-tipo = 2 THEN DO:
       FIND tt-af-controle-result-aux
           WHERE tt-af-controle-result-aux.ep-codigo     = i-ep-codigo-usuario
           AND   tt-af-controle-result-aux.nr-controle   = i-controle 
           AND   tt-af-controle-result-aux.seq-resultado = i-seq-result NO-ERROR.
       IF AVAIL tt-af-controle-result-aux THEN DO:
          ASSIGN tt-af-controle-result-aux.nr-controle:SCREEN-VALUE IN FRAME fPage0   = STRING(i-controle)
                 tt-af-controle-result-aux.seq-resultado:SCREEN-VALUE IN FRAME fPage0 = STRING(tt-af-controle-result-aux.seq-resultado)
                 tt-af-controle-result-aux.descricao:SCREEN-VALUE IN FRAME fPage0 = tt-af-controle-result-aux.descricao
                 tt-af-controle-result-aux.indice:SCREEN-VALUE IN FRAME fPage0  = string(tt-af-controle-result-aux.indice)
                 tt-af-controle-result-aux.log-justificativa:CHECKED IN FRAME fPage0  = tt-af-controle-result-aux.log-justificativa.
          DISABLE tt-af-controle-result-aux.nr-controle 
                  tt-af-controle-result-aux.seq-resultado WITH FRAME fPage0.
          ENABLE  tt-af-controle-result-aux.descricao
                  tt-af-controle-result-aux.indice
                  tt-af-controle-result-aux.log-justificativa WITH FRAME fPage0.
       END.
       
       ASSIGN cDescricao = c-descricao.
       DISP cDescricao WITH FRAME fpage0.
       DISABLE tt-af-controle-result-aux.seq-resultado WITH FRAME fPage0.
    END.
    ELSE DO:
       ENABLE tt-Af-controle-result-aux.seq-resultado
              tt-Af-controle-result-aux.descricao 
              tt-Af-controle-result-aux.log-justificativa 
              tt-Af-controle-result-aux.indice WITH FRAME fpage0.

       ASSIGN tt-Af-controle-result-aux.seq-resultado:SCREEN-VALUE IN FRAME fpage0 = string(i-seq-result + 10).

       ASSIGN tt-af-controle-result-aux.nr-controle:SCREEN-VALUE IN FRAME fPage0   = STRING(i-controle).

       ASSIGN cDescricao = c-descricao.

       DISP cDescricao WITH FRAME fpage0.

       DISABLE tt-af-controle-result-aux.nr-controle WITH FRAME fPage0.
    END.
    RUN openQueryStatic IN h-boaf001 (INPUT "Main":U) NO-ERROR.

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
IF NOT VALID-HANDLE(h-boaf001) OR
   h-boaf001:TYPE <> "PROCEDURE":U OR
   h-boaf001:FILE-NAME <> "afbo/boaf001.p":U THEN DO:
   
   RUN afbo/boaf001.p PERSISTENT SET h-boaf001.

END.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

