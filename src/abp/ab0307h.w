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
{include/i-prgvrs.i AB0307H 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0307h MAB}
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
&GLOBAL-DEFINE Program        AB0307H
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 ~
                              fiReal

/* Parameters Definitions ---                                           */
define input  parameter pRowid     AS rowid     no-undo.
define input  parameter pPadrao    as decimal   no-undo.
define input  parameter pPadraoSec as decimal   no-undo.
define input  parameter pAbast     as decimal   no-undo.
define input  parameter pUN        as character no-undo.
define input  parameter pUNSec     as character no-undo.
define input  parameter pTipo      as integer   no-undo.
define input  parameter pTipoSec   as integer   no-undo.
define output parameter pReal      as decimal   no-undo.
define output parameter pRealSec   as decimal   no-undo.
define output parameter pOK        as logical   no-undo.

/* Local Variable Definitions ---                                       */
define buffer bfApont for mab-abastec-lubrific.
define buffer bfItemApont for mab-item-abastec.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-18 RECT-19 rtToolBar RECT-21 RECT-20 ~
RECT-22 RECT-23 fiAtual fiUN1 fiAtualSec fiUN1Sec fiAnterior fiUN2 ~
fiAnteriorSec fiUN2Sec fiPadrao fiUN3 fiPadraoSec fiUN3Sec fiReal fiUN4 ~
fiRealSec fiUN4Sec btOK btCancel btHelp2 fi-contadores fi-percursos 
&Scoped-Define DISPLAYED-OBJECTS fiAtual fiUN1 fiAtualSec fiUN1Sec ~
fiAnterior fiUN2 fiAnteriorSec fiUN2Sec fiPadrao fiUN3 fiPadraoSec fiUN3Sec ~
fiReal fiUN4 fiRealSec fiUN4Sec fi-contadores fi-percursos 

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

DEFINE VARIABLE fi-contadores AS CHARACTER FORMAT "X(256)":U INITIAL "Contadores" 
      VIEW-AS TEXT 
     SIZE 8.86 BY .67 NO-UNDO.

DEFINE VARIABLE fi-percursos AS CHARACTER FORMAT "X(256)":U INITIAL "Percursos" 
      VIEW-AS TEXT 
     SIZE 9.14 BY .67 NO-UNDO.

DEFINE VARIABLE fiAnterior AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Anterior":R16 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiAnteriorSec AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Anterior":R16 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiAtual AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Atual":R16 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiAtualSec AS DECIMAL FORMAT ">>>>>>9.9" INITIAL 0 
     LABEL "Atual":R16 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fiPadrao AS DECIMAL FORMAT ">>,>>>,>>9.9" INITIAL 0 
     LABEL "Padr∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fiPadraoSec AS DECIMAL FORMAT ">>,>>>,>>9.9" INITIAL 0 
     LABEL "Padr∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fiReal AS DECIMAL FORMAT "->>,>>>,>>9.9" INITIAL 0 
     LABEL "Real":R15 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fiRealSec AS DECIMAL FORMAT "->>,>>>,>>9.9" INITIAL 0 
     LABEL "Real":R15 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN1 AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN1Sec AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN2 AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN2Sec AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN3 AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN3Sec AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN4 AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fiUN4Sec AS CHARACTER FORMAT "xx":U 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-18
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.72 BY 2.75.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.72 BY 2.75.

DEFINE RECTANGLE RECT-20
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.72 BY 2.75.

DEFINE RECTANGLE RECT-21
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74 BY 4.38.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 74 BY 4.38.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 34.72 BY 2.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 74 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiAtual AT ROW 2.67 COL 12.57 COLON-ALIGNED HELP
          "Hodìmetro/Hor°metro Inicial"
     fiUN1 AT ROW 2.67 COL 25.14 COLON-ALIGNED NO-LABEL
     fiAtualSec AT ROW 2.67 COL 48.43 COLON-ALIGNED HELP
          "Hodìmetro/Hor°metro Inicial"
     fiUN1Sec AT ROW 2.67 COL 61 COLON-ALIGNED NO-LABEL
     fiAnterior AT ROW 3.67 COL 12.57 COLON-ALIGNED HELP
          "Hodìmetro/Hor°metro Inicial"
     fiUN2 AT ROW 3.67 COL 25.14 COLON-ALIGNED NO-LABEL
     fiAnteriorSec AT ROW 3.67 COL 48.43 COLON-ALIGNED HELP
          "Hodìmetro/Hor°metro Inicial"
     fiUN2Sec AT ROW 3.67 COL 61 COLON-ALIGNED NO-LABEL
     fiPadrao AT ROW 7.5 COL 11.57 COLON-ALIGNED HELP
          "Valor Quilometragem Inicial"
     fiUN3 AT ROW 7.5 COL 27.14 COLON-ALIGNED NO-LABEL
     fiPadraoSec AT ROW 7.5 COL 47.72 COLON-ALIGNED HELP
          "Valor Quilometragem Inicial"
     fiUN3Sec AT ROW 7.5 COL 63.29 COLON-ALIGNED NO-LABEL
     fiReal AT ROW 8.5 COL 11.57 COLON-ALIGNED HELP
          "Valor Quilometragem Inicial"
     fiUN4 AT ROW 8.5 COL 27.14 COLON-ALIGNED NO-LABEL
     fiRealSec AT ROW 8.5 COL 47.72 COLON-ALIGNED HELP
          "Valor Quilometragem Inicial"
     fiUN4Sec AT ROW 8.5 COL 63.29 COLON-ALIGNED NO-LABEL
     btOK AT ROW 10.96 COL 2
     btCancel AT ROW 10.96 COL 13
     btHelp2 AT ROW 10.96 COL 63.57
     fi-contadores AT ROW 1.08 COL 2.86 NO-LABEL
     fi-percursos AT ROW 6.04 COL 2.86 NO-LABEL
     "Prim†rio" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 1.96 COL 3.72
     "Secund†rio" VIEW-AS TEXT
          SIZE 9.14 BY .54 AT ROW 6.79 COL 39.86
     "Prim†rio" VIEW-AS TEXT
          SIZE 7.57 BY .54 AT ROW 6.79 COL 3.72
     "Secund†rio" VIEW-AS TEXT
          SIZE 9.29 BY .54 AT ROW 2 COL 39.57
     RECT-18 AT ROW 2.17 COL 2.29
     RECT-19 AT ROW 7 COL 2.29
     rtToolBar AT ROW 10.75 COL 1
     RECT-21 AT ROW 1.38 COL 1
     RECT-20 AT ROW 2.17 COL 38.14
     RECT-22 AT ROW 6.29 COL 1
     RECT-23 AT ROW 7 COL 38.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 74 BY 11.25
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
         HEIGHT             = 11.25
         WIDTH              = 74
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
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-contadores IN FRAME fpage0
   ALIGN-L                                                              */
/* SETTINGS FOR FILL-IN fi-percursos IN FRAME fpage0
   ALIGN-L                                                              */
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
    /** Validaá∆o **/
    run piValidate in this-procedure.
    if return-value = "OK" then do:
        assign pReal = input frame fPage0 fiReal
               pRealSec = INPUT FRAME fPage0 fiRealSec
               pOK   = yes.
    end.
    else 
        return no-apply.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wWindow 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF AVAIL mab-eqpto THEN DO:
    IF mab-eqpto.log-cont-sec THEN DO:
        assign fiRealSec:SENSITIVE IN FRAME fPage0 = YES.
    END.
    ELSE DO:
        ASSIGN fiRealSec:SENSITIVE IN FRAME fPage0 = NO.
    END.
END.
ELSE DO:
    if pRowid <> ? then do:
        for first mab-abastec-lubrific
            where rowid(mab-abastec-lubrific) = pRowid no-lock:
            /* Busca Equipamento do Apontamento */
            FOR FIRST mab-eqpto
                WHERE mab-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo
                AND   mab-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto NO-LOCK:
            END.
            IF NOT AVAIL mab-eqpto THEN RETURN "NOK":U.
            IF mab-eqpto.log-cont-sec THEN DO:
                assign fiRealSec:SENSITIVE IN FRAME fPage0 = YES.
            END.
            ELSE DO:
                ASSIGN fiRealSec:SENSITIVE IN FRAME fPage0 = NO.
            END.
        END.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s incializaá∆o da tela
------------------------------------------------------------------------------*/
assign fiUN1 = pUN
       fiUN2 = pUN
       fiUN3 = pUN
       fiUN4 = pUN
       fiUN1Sec = pUNSec
       fiUN2Sec = pUNSec
       fiUN3Sec = pUNSec
       fiUN4Sec = pUNSec.

display fiAtual    fiAnterior    fiPadrao    fiReal    fiUN1    fiUN2    fiUN3    fiUN4
        fiAtualSec fiAnteriorSec fiPadraoSec fiRealSec fiUN1Sec fiUN2Sec fiUN3Sec fiUN4Sec with frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializaá∆o da tela
------------------------------------------------------------------------------*/
DEFINE VARIABLE iConsumo AS INTEGER    NO-UNDO.

if pRowid <> ? then do:
    for first mab-abastec-lubrific
        where rowid(mab-abastec-lubrific) = pRowid no-lock:

        /* Busca Equipamento do Apontamento */
        FOR FIRST mab-eqpto
            WHERE mab-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo
            AND   mab-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto NO-LOCK:
        END.
        IF NOT AVAIL mab-eqpto THEN RETURN "NOK":U.

        IF mab-eqpto.log-cont-sec THEN DO:
            assign fiRealSec:SENSITIVE IN FRAME fPage0 = YES
                   fiAtualSec = mab-abastec-lubrific.val-hodom-horim-sec
                   fiRealSec  = mab-abastec-lubrific.val-livre-1.
        END.
        ELSE DO:
            ASSIGN fiRealSec:SENSITIVE IN FRAME fPage0 = NO.
        END.

        assign fiAtual = mab-abastec-lubrific.val-hodom-horim
               fiReal  = mab-abastec-lubrific.val-km-percur.
        /** Verifica se existem apontamentos anteriores para equipamento por data **/
        if can-find(first bfitemApont
                    where bfitemApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
                    and   bfitemApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                    AND   bfitemApont.log-abastec-prim    
                    and   bfItemApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock) then do:
            for last  bfItemApont
                where bfItemApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
                and   bfItemApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                AND   bfitemApont.log-abastec-prim   
                and   bfitemApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock:

                FOR FIRST bfApont WHERE bfApont.num-docto = bfItemapont.num-docto NO-LOCK:
                    /** Compara com hodìmetro do £ltimo apontamento **/
                    assign fiAnterior = bfApont.val-hodom-horim.
                    IF mab-eqpto.log-cont-sec THEN DO:
                        ASSIGN fiAnteriorSec = bfApont.val-hodom-horim-sec.
                    END.
                END.
            end.
        end.
        else do:
            IF mab-eqpto.idi-tip-eqpto = 1 THEN DO:
                IF mab-eqpto.log-cont-sec THEN DO:
                    ASSIGN fiAnteriorSec = mab-eqpto.val-hodom-horim-sec.
                END.
               assign fiAnterior = mab-eqpto.val-hodom-horim-inicial.
            END.
            ELSE DO:
                if can-find(first bfApont
                            where bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
                            and   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                            and   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock) then do:
                    for last  bfApont
                        where bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
                        and   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
                        and   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock:
                        assign fiAnterior = bfApont.val-hodom-horim.
                        IF mab-eqpto.log-cont-sec THEN DO:
                            ASSIGN fiAnteriorSec = bfApont.val-hodom-horim-sec.
                        END.
                    END.
                END.
                ELSE DO:
                    IF mab-eqpto.log-cont-sec THEN DO:
                        assign fiAnteriorSec = mab-eqpto.val-hodom-horim-sec.
                    END.
                    assign fiAnterior = mab-eqpto.val-hodom-horim-inicial.
                END.
            END.
        end.
    end.
    /* Primario */
    /** 2 - Percurso/Qtd **/
    if pTipo = 2 THEN DO:
        assign fiPadrao = if (pAbast * pPadrao = ?) then 0 else pAbast * pPadrao.
    END.
    /** 3 - Qtd/Percurso **/
    ELSE DO:
        assign fiPadrao = if (pAbast / pPadrao = ?) then 0 else pAbast / pPadrao.  
    END.

    IF mab-eqpto.log-cont-sec THEN DO:
        /* Secund†rio */
        /** 2 - Percurso/Qtd **/
        if pTipoSec = 2 THEN DO:
            assign fiPadraoSec = if (pAbast * pPadraoSec = ?) then 0 else pAbast * pPadraoSec.
        END.
        /** 3 - Qtd/Percurso **/
        ELSE DO:
            assign fiPadraoSec = if (pAbast / pPadraoSec = ?) then 0 else pAbast / pPadraoSec.  
        END.
    END.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidate wWindow 
PROCEDURE piValidate :
/*------------------------------------------------------------------------------
  Purpose:     piValidate
  Parameters:  <none>
  Notes:       Valida campos em tela.
------------------------------------------------------------------------------*/
define variable cTexto as character no-undo.

for first mab-eqpto
    where mab-eqpto.ep-codigo = mab-abastec-lubrific.ep-codigo
    and   mab-eqpto.cod-eqpto = mab-abastec-lubrific.cod-eqpto no-lock:

    IF mab-eqpto.log-cont-sec THEN DO:
        /** Real n∆o pode ser menor que zero **/
        if input frame fPage0 fiReal < 0 then do:
            {utp/ut-liter.i "Percurso Real"}
            run utp/ut-msgs.p (input "show":U,
                               input 7017,
                               input return-value + "~~" + "0").
            apply "entry":U to fiReal in frame fPage0.
            return "NOK":U.
        end.
        /** Secund†rio **/
        if input frame fPage0 fiRealSec < 0 then do:
            {utp/ut-liter.i "Percurso Real Secund†rio"}
            run utp/ut-msgs.p (input "show":U,
                               input 7017,
                               input return-value + "~~" + "0").
            apply "entry":U to fiReal in frame fPage0.
            return "NOK":U.
        END.
    END.
    ELSE DO:
        /** Real n∆o pode ser menor que zero **/
        if input frame fPage0 fiReal < 0 then do:
            {utp/ut-liter.i "Percurso Real"}
            run utp/ut-msgs.p (input "show":U,
                               input 7017,
                               input return-value + "~~" + "0").
            apply "entry":U to fiReal in frame fPage0.
            return "NOK":U.
        end.
    END.

    /*--------------------------------------------------------------------------------*/
    /* Caso £ltima ficha anterior ao apontamento em quest∆o n∆o for de abastecimento, */
    /* km real (ap¢s £ltimo abastecimento) informado n∆o pode ser menor que km real   */
    /* informado nesta £ltima ficha. Caso ficha anterior seja de abastecimento,       */
    /* este tipo de consistància n∆o precisa ser realizada.                           */
    /*--------------------------------------------------------------------------------*/
    /** Somente motorizados **/
    if mab-eqpto.idi-tip-eqpto = 1 then do:
        for last  bfApont
            where bfApont.ep-codigo            = mab-abastec-lubrific.ep-codigo
            and   bfApont.cod-eqpto            = mab-abastec-lubrific.cod-eqpto
            and   bfApont.val-dat-hora-invrtda < mab-abastec-lubrific.val-dat-hora-invrtda no-lock:

            IF mab-eqpto.log-cont-sec THEN DO:
                /* Secund†rio */
                if not can-find(FIRST mab-item-abastec 
                                WHERE mab-item-abastec.num-docto = bfApont.num-docto
                                AND mab-item-abastec.log-abastec-prim NO-LOCK) then do:
                    if input frame fPage0 fiRealSec < bfapont.val-livre-1 then do:
                        {utp/ut-liter.i "Percurso Real Secund†rio"}
                        assign cTexto = return-value.
                        {utp/ut-liter.i "Percurso do Èltimo Apontamento"}
                        run utp/ut-msgs.p (input "show":U,
                                           input 7017,
                                           input cTexto + "~~" + return-value + " " + string(bfapont.val-livre-1)).
                        apply "entry":U to fiReal in frame fPage0.
                        return "NOK":U.
                    end.
                END.
                /* Prim†rio */
                if not can-find(FIRST mab-item-abastec 
                                WHERE mab-item-abastec.num-docto = bfApont.num-docto
                                AND mab-item-abastec.log-abastec-prim NO-LOCK) then do:
                    if input frame fPage0 fiReal < bfapont.val-km-percur then do:
                        {utp/ut-liter.i "Percurso Real"}
                        assign cTexto = return-value.
                        {utp/ut-liter.i "Percurso do Èltimo Apontamento"}
                        run utp/ut-msgs.p (input "show":U,
                                           input 7017,
                                           input cTexto + "~~" + return-value + " " + string(bfapont.val-km-percur)).
                        apply "entry":U to fiReal in frame fPage0.
                        return "NOK":U.
                    end.
                END.
            END.
            ELSE DO:
                /* Prim†rio */
                if not can-find(FIRST mab-item-abastec 
                                WHERE mab-item-abastec.num-docto = bfApont.num-docto
                                AND mab-item-abastec.log-abastec-prim NO-LOCK) then do:
                    if input frame fPage0 fiReal < bfapont.val-km-percur then do:
                        {utp/ut-liter.i "Percurso Real"}
                        assign cTexto = return-value.
                        {utp/ut-liter.i "Percurso do Èltimo Apontamento"}
                        run utp/ut-msgs.p (input "show":U,
                                           input 7017,
                                           input cTexto + "~~" + return-value + " " + string(bfapont.val-km-percur)).
                        apply "entry":U to fiReal in frame fPage0.
                        return "NOK":U.
                    end.
                END.
            END.
        END.        
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

