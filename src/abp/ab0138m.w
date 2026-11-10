&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttUnidNegocHist NO-UNDO LIKE mab-unid-negoc-histor-ativid
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
{include/i-prgvrs.i AB0138M 2.00.00.000}  /*** 010000 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i AB0138M MAB}
&ENDIF

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

{cdp/cdcfgmnt.i} /*Vers‰es EMS MNT*/
{cdp/cd9911.i}   /*Unidade Neg¢cio*/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0138M
&GLOBAL-DEFINE Version        2.00.00.000

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO
&GLOBAL-DEFINE InitialPage    0
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btSave btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   

/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER p-ep-codigo        LIKE mab-unid-negoc-histor-ativid.ep-codigo            NO-UNDO.
DEFINE INPUT PARAMETER p-cod-eqpto        LIKE mab-unid-negoc-histor-ativid.cod-eqpto            NO-UNDO.
DEFINE INPUT PARAMETER p-dat-cadastro     LIKE mab-unid-negoc-histor-ativid.dat-cadastro         NO-UNDO.
DEFINE INPUT PARAMETER p-cod-unid-negoc   LIKE mab-unid-negoc-histor-ativid.cod-unid-negoc       NO-UNDO.
DEFINE INPUT PARAMETER p-perc-unid-negoc  LIKE mab-unid-negoc-histor-ativid.val-perc-unid-negoc  NO-UNDO.
DEFINE INPUT PARAMETER pType              AS CHAR                                                NO-UNDO.
DEFINE INPUT-OUTPUT PARAMETER TABLE FOR ttUnidNegocHist.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-cod-unid-negoc  LIKE mab-unid-negoc-histor-ativid.cod-unid-negoc          NO-UNDO.
DEFINE VARIABLE d-perc-unid-negoc LIKE mab-unid-negoc-histor-ativid.val-perc-unid-negoc     NO-UNDO.
DEFINE VARIABLE hDBOEqpto         AS HANDLE NO-UNDO.

/* Local Temp-tables Definition ---                                     */

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar RECT-22 RECT-24 fi-ep-codigo ~
fi-cod-eqpto fi-desc-eqpto fi-dat-cadastro fi-cod-unid-negoc ~
fi-val-perc-unid-negoc btOK btSave btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-ep-codigo fi-cod-eqpto fi-desc-eqpto ~
fi-dat-cadastro fi-cod-unid-negoc fi-des-unid-negoc fi-val-perc-unid-negoc 

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

DEFINE BUTTON btSave 
     LABEL "Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE fi-cod-eqpto LIKE ttUnidNegocHist.cod-eqpto
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "x(3)" 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE VARIABLE fi-dat-cadastro LIKE ttUnidNegocHist.dat-cadastro
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-des-unid-negoc AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 47.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-eqpto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ep-codigo LIKE ttUnidNegocHist.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-val-perc-unid-negoc AS DECIMAL FORMAT ">>9.9999" INITIAL 0 
     LABEL "%Unid Negoc" 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88.

DEFINE RECTANGLE RECT-22
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 3.5.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 76 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 77 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-ep-codigo AT ROW 1.5 COL 15 COLON-ALIGNED HELP
          "C¢digo Empresa Equipamento"
     fi-cod-eqpto AT ROW 2.5 COL 15 COLON-ALIGNED HELP
          "C¢digo do Equipamento"
     fi-desc-eqpto AT ROW 2.5 COL 32 COLON-ALIGNED NO-LABEL
     fi-dat-cadastro AT ROW 3.5 COL 15 COLON-ALIGNED HELP
          "Data do Cadastro"
     fi-cod-unid-negoc AT ROW 5.58 COL 15.14 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fi-des-unid-negoc AT ROW 5.58 COL 26.14 COLON-ALIGNED NO-LABEL
     fi-val-perc-unid-negoc AT ROW 6.58 COL 15.14 COLON-ALIGNED HELP
          "Percentual da Unidade de Neg¢cio"
     btOK AT ROW 8.71 COL 1.86
     btSave AT ROW 8.71 COL 12.86
     btCancel AT ROW 8.71 COL 23.86
     btHelp2 AT ROW 8.71 COL 66.86
     rtToolBar AT ROW 8.5 COL 1
     RECT-22 AT ROW 4.88 COL 2
     RECT-24 AT ROW 1.25 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 77.14 BY 9.04
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttUnidNegocHist T "?" NO-UNDO mgfro mab-unid-negoc-histor-ativid
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
         TITLE              = "Manutená∆o Unidade Neg¢cio e Percentual"
         HEIGHT             = 9
         WIDTH              = 77.72
         MAX-HEIGHT         = 17
         MAX-WIDTH          = 96.86
         VIRTUAL-HEIGHT     = 17
         VIRTUAL-WIDTH      = 96.86
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
{btb/btb008za.i0}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wWindow
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-cod-eqpto IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocHist.cod-eqpto EXP-SIZE                */
/* SETTINGS FOR FILL-IN fi-dat-cadastro IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocHist.dat-cadastro EXP-SIZE             */
/* SETTINGS FOR FILL-IN fi-des-unid-negoc IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ep-codigo IN FRAME fpage0
   LIKE = Temp-Tables.ttUnidNegocHist.ep-codigo                         */
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
ON END-ERROR OF wWindow /* Manutená∆o Unidade Neg¢cio e Percentual */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Manutená∆o Unidade Neg¢cio e Percentual */
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
    /** Grava os campos em tela nas variaveis responsaveis por guardar o codigo e o percentual da UN **/
    ASSIGN c-cod-unid-negoc  = fi-cod-unid-negoc:SCREEN-VALUE              IN FRAME {&FRAME-NAME} 
           d-perc-unid-negoc = DECIMAL(fi-val-perc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    RUN validateRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        /** Procedure responsavel por gravar os registros na temp-table e chamar a BO **/
        RUN saveFields IN THIS-PROCEDURE.
        IF RETURN-VALUE = "OK" THEN
            APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    ASSIGN c-cod-unid-negoc  = fi-cod-unid-negoc:SCREEN-VALUE              IN FRAME {&FRAME-NAME} 
           d-perc-unid-negoc = DECIMAL(fi-val-perc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    RUN validateRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN DO:
        RUN saveFields IN THIS-PROCEDURE.

        ASSIGN fi-cod-unid-negoc:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = "":U
               fi-des-unid-negoc:SCREEN-VALUE      IN FRAME {&FRAME-NAME} = "":U.
               fi-val-perc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.
    END.

    APPLY "ENTRY" TO fi-cod-unid-negoc.

    RETURN "OK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wWindow
ON F5 OF fi-cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
    {method/ZoomFields.i
            &ProgramZoom="inzoom/z01in745.w"
            &FieldZoom1="cod-unid-negoc"
            &FieldScreen1="fi-cod-unid-negoc"
            &Frame1="{&frame-name}"
            &FieldZoom2="des-unid-negoc"
            &FieldScreen2="fi-des-unid-negoc"
            &Frame2="{&frame-name}"
            &EnableImplant="no"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wWindow
ON LEAVE OF fi-cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
    &IF DEFINED(bf_mnt_ems206b) &THEN
        {include/leave.i &tabela=unid-negoc
                         &atributo-ref=des-unid-negoc
                         &variavel-ref=fi-des-unid-negoc
                         &where="unid-negoc.cod-unid-negoc = input frame {&FRAME-NAME} fi-cod-unid-negoc"}
    &ENDIF                         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-cod-unid-negoc IN FRAME fpage0 /* Unidade Neg¢cio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
fi-cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage0.

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

    IF VALID-HANDLE(hDBOEqpto) THEN
        RUN destroy IN hDBOEqpto.

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
    IF pType = "UPDATE":U THEN
        ASSIGN btSave:SENSITIVE            IN FRAME {&FRAME-NAME} = NO
               fi-cod-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    
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

    IF NOT VALID-HANDLE (hDBOEqpto) THEN DO:
        {btb/btb008za.i1 frbo/bofr007.p}
        {btb/btb008za.i2 frbo/bofr007.p '' hDBOEqpto}
    END.

    ASSIGN fi-cod-unid-negoc:SENSITIVE      IN FRAME {&FRAME-NAME} = YES
           fi-val-perc-unid-negoc:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

    ASSIGN fi-ep-codigo    = p-ep-codigo   
           fi-cod-eqpto    = p-cod-eqpto   
           fi-dat-cadastro = p-dat-cadastro.

    RUN buscaModelo IN hDBOEqpto (INPUT p-ep-codigo,
                                  INPUT p-cod-eqpto,
                                  OUTPUT fi-desc-eqpto).
    DISP fi-ep-codigo   
         fi-cod-eqpto   
         fi-dat-cadastro 
         fi-desc-eqpto WITH FRAME {&FRAME-NAME}. 

    IF pType = "UPDATE":U THEN DO:
        ASSIGN fi-cod-unid-negoc      = p-cod-unid-negoc   
               fi-val-perc-unid-negoc = p-perc-unid-negoc.

        DISP fi-cod-unid-negoc
             fi-val-perc-unid-negoc WITH FRAME {&FRAME-NAME}.

        APPLY "LEAVE":U TO fi-cod-unid-negoc      IN FRAME {&FRAME-NAME}.
        APPLY "ENTRY":U TO fi-val-perc-unid-negoc IN FRAME {&FRAME-NAME}.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE saveFields wWindow 
PROCEDURE saveFields :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF pType = "ADD":U THEN DO:
        /** Cria Temp-table **/
        CREATE ttUnidNegocHist.
        /** Grava na temp-table os dados que foram inseridos em tela **/
        ASSIGN ttUnidNegocHist.ep-codigo           = p-ep-codigo   
               ttUnidNegocHist.cod-eqpto           = p-cod-eqpto   
               ttUnidNegocHist.dat-cadastro        = p-dat-cadastro
               ttUnidNegocHist.cod-unid-negoc      = c-cod-unid-negoc 
               ttUnidNegocHist.val-perc-unid-negoc = d-perc-unid-negoc.
    END.
    ELSE DO:
        /** Altera registro **/
        FOR FIRST ttUnidNegocHist 
            WHERE ttUnidNegocHist.ep-codigo      = p-ep-codigo     
            AND   ttUnidNegocHist.cod-eqpto      = p-cod-eqpto     
            AND   ttUnidNegocHist.dat-cadastro   = p-dat-cadastro  
            AND   ttUnidNegocHist.cod-unid-negoc = c-cod-unid-negoc EXCLUSIVE-LOCK:
            ASSIGN ttUnidNegocHist.val-perc-unid-negoc = d-perc-unid-negoc.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wWindow 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF pType = "ADD":U OR pType = "UPDATE":U THEN DO:
        /*--- Verifica se o campo da Unidade Neg¢cio esta em branco ---*/
        IF c-cod-unid-negoc = "":U THEN DO:
            {utp/ut-liter.i Unidade_Neg¢cio}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 25144,
                               INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            /*--- Verifica se a Unidade Neg¢cio digitada Ç valida ---*/
            IF NOT CAN-FIND (FIRST unid-negoc
                             WHERE unid-negoc.cod-unid-negoc = c-cod-unid-negoc) THEN DO:
                RUN utp/ut-msgs.p (INPUT "SHOW":U,
                                   INPUT 25590,
                                   INPUT "":U).
                RETURN "NOK":U.
            END.
        &ENDIF

        /*--- Percentual da Unidade Neg¢cio nao pode ser maior que 100% e menor que 0% ---*/
        IF  d-perc-unid-negoc <= 0 OR
            d-perc-unid-negoc > 100 THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 5376,
                               INPUT "":U).
            RETURN "NOK":U.
        END.
    END.

    /*--- Verifica se a Unidade Neg¢cio j† n∆o foi inserida para essa Ordem de Manutená∆o ---*/
    IF pType = "ADD":U THEN DO:
        IF CAN-FIND (FIRST ttUnidNegocHist
                     WHERE ttUnidNegocHist.ep-codigo      = p-ep-codigo
                     AND   ttUnidNegocHist.cod-eqpto      = p-cod-eqpto
                     AND   ttUnidNegocHist.dat-cadastro   = p-dat-cadastro
                     AND   ttUnidNegocHist.cod-unid-negoc = c-cod-unid-negoc) THEN DO:
            {utp/ut-liter.i Unidade_de_Neg¢cio}
            RUN utp/ut-msgs.p (INPUT "SHOW":U,
                               INPUT 1,
                               INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

