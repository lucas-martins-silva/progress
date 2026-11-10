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
{include/i-prgvrs.i AO0302G 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ao0302g MAO}
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
&GLOBAL-DEFINE Program        AO0302G
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE WindowType     Master/Detail

&GLOBAL-DEFINE Folder         no
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   

&GLOBAL-DEFINE page0Widgets   btOK btSave btHelp btCancel fiData fiHora cbTabela fiResultado-num fiResultado-txt fiResultado-dat
/* Parameters Definitions ---                                           */
DEFINE VARIABLE hDBOResult AS HANDLE     NO-UNDO.
DEFINE VARIABLE hDBOAmostra AS HANDLE     NO-UNDO.
DEFINE VARIABLE cAction    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE rwResult   AS ROWID      NO-UNDO.
DEFINE VARIABLE cReturnAux AS CHARACTER  NO-UNDO.
DEFINE VARIABLE HoraInv    AS DEC  NO-UNDO.
DEFINE VARIABLE cHora      AS CHARACTER format "00:00:00" NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE c-lista AS CHARACTER format "x(100)" NO-UNDO.
DEFINE VARIABLE l-controle AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE i-tip-restdo AS INTEGER    NO-UNDO.
DEFINE VARIABLE l-not-avail-mao-restdo-ensaio AS LOGICAL INITIAL NO NO-UNDO.

{aop/ao0302.i3 ttDados} /** Defini‡Æo da ttDados **/

def temp-table ttDadosAux no-undo like ttDados .
def temp-table tt-Result no-undo like mao-restdo-ensaio
    field r-rowid as rowid.

def temp-table tt-Amostra no-undo like mao-amostra-oleo
    field r-rowid as rowid.
def temp-table tt-Result-aux no-undo like mao-restdo-ensaio
    field r-rowid as rowid.

define input parameter table for ttDadosAux.


{abp/ab9000.i} /** Procedures de conversÆo de tempo:
                   piFormataHoraParaSegundo
                   piFormataSegundoParaHora **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-23 IMAGE-24 RECT-27 rtToolBar ~
fiNumAmostra fiCodAmostra fiCodEnsaio fiDescEnsaio fiNumTabela fiDescTabela ~
fiValMin fiValMax fiData fiHora fiResultado-num fiResultado-dat cbTabela ~
fiResultado-txt btOK btSave btCancel btHelp 
&Scoped-Define DISPLAYED-OBJECTS fiNumAmostra fiCodAmostra fiCodEnsaio ~
fiDescEnsaio fiNumTabela fiDescTabela fiValMin fiValMax fiData fiHora ~
fiResultado-num fiResultado-dat cbTabela fiResultado-txt 

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

DEFINE BUTTON btHelp 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&OK" 
     SIZE 10 BY 1.

DEFINE BUTTON btSave 
     LABEL "&Salvar" 
     SIZE 10 BY 1.

DEFINE VARIABLE cbTabela AS CHARACTER FORMAT "X(256)":U 
     LABEL "Resultado" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 30.29 BY 1 NO-UNDO.

DEFINE VARIABLE fiCodAmostra AS CHARACTER FORMAT "x(12)" 
     LABEL "N£mero Amostra":R17 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fiCodEnsaio AS CHARACTER FORMAT "x(8)" 
     LABEL "Ensaio":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiData AS DATE FORMAT "99/99/9999" 
     LABEL "Data":R11 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiDescEnsaio AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescTabela AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fiHora AS CHARACTER FORMAT "99:99:99" INITIAL "00:00:00" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88.

DEFINE VARIABLE fiNumAmostra AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Documento":R15 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiNumTabela AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Tabela":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fiResultado-dat AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiResultado-num AS DECIMAL FORMAT "->>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 18.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiResultado-txt AS CHARACTER FORMAT "X(60)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 48.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiValMax AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE fiValMin AS CHARACTER FORMAT "x(60)" 
     LABEL "Faixa":R8 
     VIEW-AS FILL-IN 
     SIZE 19.29 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-27
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 61 BY 8.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 61 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fiNumAmostra AT ROW 1.5 COL 10.72 COLON-ALIGNED HELP
          "N£mero do Documento da  Ficha de Amostra àleo"
     fiCodAmostra AT ROW 1.5 COL 46.86 COLON-ALIGNED HELP
          "N£mero/C¢digo da Amostra F¡sica do àleo"
     fiCodEnsaio AT ROW 2.5 COL 10.72 COLON-ALIGNED HELP
          "C¢digo do ensaio"
     fiDescEnsaio AT ROW 2.5 COL 21 COLON-ALIGNED NO-LABEL
     fiNumTabela AT ROW 3.5 COL 10.72 COLON-ALIGNED
     fiDescTabela AT ROW 3.5 COL 21 COLON-ALIGNED NO-LABEL
     fiValMin AT ROW 4.5 COL 10.72 COLON-ALIGNED HELP
          "Valor m¡nimo do resultado"
     fiValMax AT ROW 4.5 COL 40 COLON-ALIGNED HELP
          "Valor m ximo do resultado" NO-LABEL
     fiData AT ROW 6.08 COL 10.72 COLON-ALIGNED HELP
          "Data Resultado Ensaio"
     fiHora AT ROW 6.08 COL 20.86 COLON-ALIGNED HELP
          "Hora Resultado Ensaio" NO-LABEL
     fiResultado-num AT ROW 7.08 COL 10.72 COLON-ALIGNED
     fiResultado-dat AT ROW 7.08 COL 10.72 COLON-ALIGNED
     cbTabela AT ROW 7.08 COL 10.72 COLON-ALIGNED
     fiResultado-txt AT ROW 7.08 COL 10.72 COLON-ALIGNED
     btOK AT ROW 9.33 COL 2
     btSave AT ROW 9.33 COL 13
     btCancel AT ROW 9.33 COL 24
     btHelp AT ROW 9.33 COL 50.43
     IMAGE-23 AT ROW 4.5 COL 39
     IMAGE-24 AT ROW 4.5 COL 32.14
     RECT-27 AT ROW 1 COL 1
     rtToolBar AT ROW 9.08 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.72 BY 9.71
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
         HEIGHT             = 9.58
         WIDTH              = 61.43
         MAX-HEIGHT         = 29
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 29
         VIRTUAL-WIDTH      = 146.29
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
    RETURN "NOK":U.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wWindow
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wWindow
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    run salvaRegistro in THIS-PROCEDURE.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wWindow
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    run salvaRegistro in THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiHora
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiHora wWindow
ON LEAVE OF fiHora IN FRAME fpage0
DO:
   assign cHora = fiHora:screen-value in frame fPage0.
     run piFormataHorarioSeg (input-output cHora).
     if return-value = "NOK":U then do:
         apply "ENTRY":U to fiHora in frame fPage0.
         return no-apply.
     end.
     assign fiHora:screen-value in frame fPage0 = cHora.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

{window/mainblock.i}

{abp/abapi001.i2}  /** Cria‡Æo de erros **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wWindow 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override ap¢s finalizar o programa
------------------------------------------------------------------------------*/
/** Erros **/
{method/showmessage.i3}

/** Resultados **/
if valid-handle(hDBOResult) THEN   
    run Destroy in hDBOResult.

/** Amostra **/
if valid-handle(hDBOAmostra) THEN   
    run Destroy in hDBOAmostra.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override ap¢s inicializa‡Æo da tela
------------------------------------------------------------------------------*/

{utp/ut-liter.i Resultado *  }
assign fiResultado-txt:label in frame fPage0 = trim(return-value)
       fiResultado-num:label in frame fPage0 = trim(return-value)
       fiResultado-dat:label in frame fPage0 = trim(return-value).

 for first ttDadosAux exclusive-lock:
 end.

 if avail ttDadosAux AND CAN-FIND(FIRST mao-amostra-oleo 
                                  WHERE mao-amostra-oleo.num-amostra-oleo = ttDadosAux.num-amostra-oleo 
                                    AND mao-amostra-oleo.idi-estado-amostra = 1 NO-LOCK) then do:
 
   
     /*se a amostra ainda estiver pendente, usar dados da ttDadosAux*/
    assign fiNumAmostra = int(ttDadosAux.cod-oficial)
           fiCodAmostra = ttDadosAux.cod-amostra-fisic
           fiCodEnsaio  = ttDadosAux.cod-ensaio
           fiDescEnsaio = ttDadosAux.desc-dimensao 
           fiNumTabela  = ttDadosAux.num-tabela
           fiValMin     = ttDadosAux.des-val-min 
           fiValMax     = ttDadosAux.des-val-max 
           fiData       = today
           fiHora       = replace(string(time,"HH:MM:SS"),":","")
           l-controle   = NO.

   /*Busca descri‡Æo da tabela*/
   IF fiNumTabela <> 0 THEN DO:
       for first mab-tab-restdo fields (des-tabela num-tabela )
           where mab-tab-restdo.num-tabela = int(ttDadosAux.num-tabela) no-lock:  
       end.
       if avail mab-tab-restdo then do:
           assign fiDescTabela   = mab-tab-restdo.des-tabela.
       end.
   END.

     /*** Mostra campos em tela com formato correto em fun‡Æo do tipo de Resultado ****/
     run atualizaCampos in this-procedure.
 end.
 ELSE DO:
     /*Usar dados direto da tabela, pois a ttDados vai possuir apenas os dados dos resultados pendentes.*/
     FIND FIRST mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo = ttDadosAux.num-amostra-oleo NO-LOCK NO-ERROR.
     IF AVAIL mao-restdo-ensaio THEN DO:

         assign fiNumAmostra = int(ttDadosAux.cod-oficial)
                   fiCodAmostra = ttDadosAux.cod-amostra-fisic
                   fiCodEnsaio  = mao-restdo-ensaio.cod-ensaio
                   fiNumTabela  = mao-restdo-ensaio.num-tabela
                   fiValMin     = mao-restdo-ensaio.des-val-min 
                   fiValMax     = mao-restdo-ensaio.des-val-max 
                   fiData       = today
                   fiHora       = replace(string(time,"HH:MM:SS"),":","")
                   l-controle   = YES.

           /*Busca descri‡Æo da tabela*/
           IF fiNumTabela <> 0 THEN DO:
               for first mab-tab-restdo fields (des-tabela num-tabela )
                   where mab-tab-restdo.num-tabela = int(mao-restdo-ensaio.num-tabela) no-lock:  
               end.
               if avail mab-tab-restdo then
                   assign fiDescTabela   = mab-tab-restdo.des-tabela.
               ELSE
                   ASSIGN fiDescTabela   = "":U.
           END.

           /*Busca Descricao Ensaio*/
           FIND FIRST mao-ensaio WHERE mao-ensaio.cod-ensaio = fiCodEnsaio NO-LOCK NO-ERROR.
           IF AVAIL mao-ensaio THEN
               ASSIGN fiDescEnsaio = mao-ensaio.des-ensaio.
           ELSE
               ASSIGN fiDescEnsaio = "":U.

             /*** Mostra campos em tela com formato correto em fun‡Æo do tipo de Resultado ****/
             run atualizaCampos in this-procedure.
     END.

 END.

assign  fiCodEnsaio:sensitive in frame fPage0  = no 
        fiDescEnsaio:sensitive in frame fPage0 = no
        fiNumTabela:sensitive in frame fPage0  = no 
        fiValMin:sensitive in frame fPage0     = no    
        fiValMax:sensitive in frame fPage0     = no    
        fiData:sensitive in frame fPage0       = yes      
        fiHora:sensitive in frame fPage0       = yes  
        fiDescTabela:sensitive in frame fPage0 = no.

disp   fiNumAmostra
       fiCodAmostra
       fiCodEnsaio 
       fiDescEnsaio
       fiNumTabela 
       fiDescTabela
       fiValMin    
       fiValMax    
       fiData      
       fiHora with frame fPage0.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE aprovaAmostraOleo wWindow 
PROCEDURE aprovaAmostraOleo :
/*------------------------------------------------------------------------------
  Purpose:    aprova a amostra de oleo conforme o parametro passado 
  Parameters: input pEstadoAmostra, input pNumAmostraOleo
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM pEstadoAmostra LIKE mao-amostra-oleo.idi-estado-amostra NO-UNDO.
DEF INPUT PARAM pNumAmostraOleo LIKE mao-amostra-oleo.num-amostra-oleo NO-UNDO.

    SESSION:SET-WAIT-STATE("general":U).
    EMPTY TEMP-TABLE tt-Amostra.
   /*:T Posiciona query, do DBO, atrav‚s dos valores do ¡ndice £nico */
    RUN goToKey   IN hDBOAmostra     (INPUT pNumAmostraOleo).  
    run getRecord in   hDBOAmostra  (output table tt-Amostra).
    FIND FIRST tt-amostra EXCLUSIVE-LOCK NO-ERROR.
    /*grava o valor do estado da amostra conforme valor passado por parametro*/
    ASSIGN tt-Amostra.idi-estado-amostra = pEstadoAmostra.
    /*--- Limpa temp-table RowErrors no DBO ---*/
    RUN emptyRowErrors IN hDBOAmostra.
    /*--- Transfere temp-table tt-requisicao para o DBO ---*/
    RUN setRecord IN hDBOAmostra (INPUT TABLE tt-Amostra).
    /*--- Altera o registro corrente do DBO ---*/
    RUN updateRecord IN hDBOAmostra.
    /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
    ASSIGN cReturnAux = RETURN-VALUE.
    /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
    IF cReturnAux = "NOK":U THEN DO:
        /*--- Retorna temp-table RowErrors do DBO ---*/
        RUN getRowErrors IN hDBOAmostra (OUTPUT TABLE RowErrors).
        /** Elimina todos os erros intrnos da BO (Navega‡Æo) **/
        for each  RowErrors
            where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
            delete RowErrors.
        end.
       IF CAN-FIND(FIRST RowErrors 
                WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
           /** Instancia aplicativo **/              
           {method/showmessage.i1}                   
           /** Mostra caixa com erros **/            
           {method/showmessage.i2 &Modal="YES"}      
           /** Limpa temp-tables de erros **/        
           empty temp-table RowErrors.               
           RETURN "NOK":U.
       end.
    END.
   
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaCampos wWindow 
PROCEDURE atualizaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  IF l-controle = NO THEN
      ASSIGN i-tip-restdo = ttDadosAux.idi-tip-restdo.
  ELSE DO:
      IF NOT AVAIL mao-ensaio OR mao-ensaio.cod-ensaio <> mao-restdo-ensaio.cod-ensaio THEN
          FIND FIRST mao-ensaio WHERE mao-ensaio.cod-ensaio = mao-restdo-ensaio.cod-ensaio NO-LOCK NO-ERROR.

      IF AVAIL mao-ensaio THEN
          ASSIGN i-tip-restdo = mao-ensaio.idi-tip-restdo.
  END.
   
   case i-tip-restdo:
         when 1 then do:
         assign cbTabela:sensitive in frame fPage0            = no
                cbTabela:hidden in frame fPage0               = yes
                fiResultado-txt:hidden in frame fPage0        = yes
                fiResultado-num:hidden in frame fPage0        = no
                fiResultado-dat:hidden in frame fPage0        = yes
                fiResultado-txt:sensitive in frame fPage0     = no
                fiResultado-num:sensitive in frame fPage0     = yes
                fiResultado-dat:sensitive in frame fPage0     = no
                fiResultado-num:FORMAT IN FRAME fPage0        = IF l-controle THEN mao-restdo-ensaio.des-formato
                                                                              ELSE ttDadosAux.des-formato.
         end.
         when 2 then do:
         assign fiResultado-txt:hidden in frame fPage0        = yes
                fiResultado-num:hidden in frame fPage0        = yes 
                fiResultado-dat:hidden in frame fPage0        = yes
                fiResultado-txt:sensitive in frame fPage0     = no
                fiResultado-num:sensitive in frame fPage0     = no
                fiResultado-dat:sensitive in frame fPage0     = no
                cbTabela:sensitive in frame fPage0            = yes
                cbTabela:hidden in frame fPage0               = no.
                run buscaResultados in this-procedure (INPUT IF l-controle THEN mao-restdo-ensaio.num-tabela 
                                                                           ELSE ttDadosAux.num-tabela,
                                                       output c-lista). 
                assign cbTabela:LIST-ITEM-PAIRS in frame fPage0    = c-lista.
/*                        cbTabela:SCREEN-VALUE IN FRAME fPage0  = IF l-controle THEN string(mao-restdo-ensaio.num-tabela) */
/*                                                                               ELSE string(ttDadosAux.num-tabela).       */
                ASSIGN cbTabela:SCREEN-VALUE IN FRAME fPage0 = IF l-controle THEN string(mao-restdo-ensaio.des-val-restdo) 
                                                                             ELSE string(ttDadosAux.des-val-restdo).       
         end.
         when 3 then do:
         assign cbTabela:sensitive in frame fPage0            = no
                cbTabela:hidden in frame fPage0               = yes
                fiResultado-txt:hidden in frame fPage0        = no
                fiResultado-num:hidden in frame fPage0        = yes
                fiResultado-dat:hidden in frame fPage0        = yes
                fiResultado-txt:sensitive in frame fPage0     = yes 
                fiResultado-num:sensitive in frame fPage0     = no 
                fiResultado-dat:sensitive in frame fPage0     = no
                fiResultado-txt:FORMAT IN FRAME fPage0        = IF l-controle THEN mao-restdo-ensaio.des-formato
                                                                              ELSE ttDadosAux.des-formato. 
         end.
         when 4 then do:
         assign cbTabela:sensitive in frame fPage0            = no
                cbTabela:hidden in frame fPage0               = yes
                fiResultado-txt:hidden in frame fPage0        = yes
                fiResultado-num:hidden in frame fPage0        = yes
                fiResultado-dat:hidden in frame fPage0        = no
                fiResultado-txt:sensitive in frame fPage0     = no
                fiResultado-num:sensitive in frame fPage0     = no 
                fiResultado-dat:sensitive in frame fPage0     = yes
                fiResultado-dat:FORMAT IN FRAME fPage0        = "99/99/9999":U. 
         end.
   end case.

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
/***** Label para os campos ****/
{utp/ut-liter.i Documento * }
assign fiNumAmostra:label in frame fpage0  =    trim(return-value).
{utp/ut-liter.i N£mero_Amostra * }
assign fiCodAmostra:label in frame fpage0  =    trim(return-value).
{utp/ut-liter.i Ensaio * }
assign fiCodEnsaio:label in frame fpage0  =    trim(return-value).
{utp/ut-liter.i Data * }
assign fiData:label in frame fpage0  =    trim(return-value).
{utp/ut-liter.i Tabela * }
assign fiNumTabela:label in frame fpage0  =    trim(return-value).
{utp/ut-liter.i Faixa * }
assign fiValMin:label in frame fpage0  =    trim(return-value).
{utp/ut-liter.i Resultado * }
assign cbTabela:label in frame fpage0  =    trim(return-value).


  /*:T--- BO da tabela resultado do ensaio ---*/
     IF NOT VALID-HANDLE(hDBOResult) OR
        hDBOResult:TYPE <> "PROCEDURE":U OR
        hDBOResult:FILE-NAME <> "frbo/bofr106.p":U THEN DO:
        run frbo/bofr106.p persistent set hDBOResult.
     END.
     RUN openQueryStatic IN hDBOResult (INPUT "Main":U) NO-ERROR.

  /*:T--- BO da tabela resultado do ensaio ---*/
     IF NOT VALID-HANDLE(hDBOAmostra) OR
        hDBOAmostra:TYPE <> "PROCEDURE":U OR
        hDBOAmostra:FILE-NAME <> "frbo/bofr105.p":U THEN DO:
        run frbo/bofr105.p persistent set hDBOAmostra.
     END.
     RUN openQueryStatic IN hDBOAmostra (INPUT "Main":U) NO-ERROR.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaProximo wWindow 
PROCEDURE buscaProximo :
/*------------------------------------------------------------------------------
  Purpose:     busca o proximo resultado a ser atualizado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE dData AS date format "99/99/9999":U NO-UNDO.
DEFINE VARIABLE cHora AS character format "HH:MM:SS":U  NO-UNDO.

    assign dData =  date(fiData:screen-value in frame fPage0)
           cHora =  fiHora:screen-value in frame fPage0.  

    if cReturnAux  = "OK":U then do:
        IF l-controle = NO THEN DO:
            find next ttDadosAux exclusive-lock no-error.
              if avail ttDadosAux then do:
                 assign fiNumAmostra = int(ttDadosAux.cod-oficial)       
                        fiCodAmostra = ttDadosAux.cod-amostra-fisic      
                        fiCodEnsaio = ttDadosAux.cod-ensaio          
                        fiDescEnsaio = ttDadosAux.desc-dimensao       
                        fiNumTabela = ttDadosAux.num-tabela          
                        fiValMin = ttDadosAux.des-val-min         
                        fiValMax = ttDadosAux.des-val-max         
                        fiData = dData   
                        fiHora = replace(cHora,":","").  
                for first mab-tab-restdo fields (des-tabela num-tabela )
                    where mab-tab-restdo.num-tabela = int(ttDadosAux.num-tabela) no-lock:  
                end.
                if avail mab-tab-restdo then do:
                    assign fiDescTabela   = mab-tab-restdo.des-tabela.
                end.
                assign fiResultado-num = 0.000
                       fiResultado-txt = "":u
                       fiResultado-dat = &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/0001 &ENDIF .
                case ttDadosAux.idi-tip-restdo:
                    when 1 then
                      disp fiResultado-num with frame fPage0.
                    when 3 then
                      disp fiResultado-txt with frame fPage0.
                    when 4 then
                      disp fiResultado-dat with frame fPage0.
                end case.
            END. /*if avail ttDadosAux*/
        END. /*IF l-controle = NO*/
        ELSE DO:
            FIND NEXT mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo = ttDadosAux.num-amostra-oleo NO-LOCK NO-ERROR.
            IF AVAIL mao-restdo-ensaio THEN DO:
                
                assign fiNumAmostra = int(ttDadosAux.cod-oficial)       
                       fiCodAmostra = ttDadosAux.cod-amostra-fisic      
                       fiCodEnsaio  = mao-restdo-ensaio.cod-ensaio          
                       fiNumTabela  = mao-restdo-ensaio.num-tabela          
                       fiValMin     = mao-restdo-ensaio.des-val-min         
                       fiValMax     = mao-restdo-ensaio.des-val-max         
                       fiData       = dData   
                       fiHora       = replace(cHora,":","")
                       l-not-avail-mao-restdo-ensaio = NO.  

               /*Busca descri‡Æo da tabela*/
               IF fiNumTabela <> 0 THEN DO:
                   for first mab-tab-restdo fields (des-tabela num-tabela )
                       where mab-tab-restdo.num-tabela = int(mao-restdo-ensaio.num-tabela) no-lock:  
                   end.
                   if avail mab-tab-restdo then
                       assign fiDescTabela   = mab-tab-restdo.des-tabela.
                   ELSE
                       ASSIGN fiDescTabela   = "":U.
               END.
    
               /*Busca Descricao Ensaio*/
               FIND FIRST mao-ensaio WHERE mao-ensaio.cod-ensaio = fiCodEnsaio NO-LOCK NO-ERROR.
               IF AVAIL mao-ensaio THEN
                   ASSIGN fiDescEnsaio = mao-ensaio.des-ensaio.
               ELSE
                   ASSIGN fiDescEnsaio = "":U.
    
               assign fiResultado-num = dec(mao-restdo-ensaio.des-val-restdo) 
                      fiResultado-txt = mao-restdo-ensaio.des-val-restdo
                      fiResultado-dat = DATE(mao-restdo-ensaio.des-val-restdo) NO-ERROR.

               IF AVAIL mao-ensaio THEN
                   case mao-ensaio.idi-tip-restdo:
                       when 1 then
                         disp fiResultado-num with frame fPage0.
                       when 3 then
                         disp fiResultado-txt with frame fPage0.
                       when 4 then
                         disp fiResultado-dat with frame fPage0.
                   end case.

            END. /*FIND NEXT mao-restdo-ensaio*/
            ELSE ASSIGN l-not-avail-mao-restdo-ensaio = YES. /*variavel de controle que indica que nao tem mais amostras disponiveis.*/
        END. /*ELSE DO if l-controle*/ 
        IF (l-controle = YES AND /*AVAIL mao-restdo-ensaio*/ l-not-avail-mao-restdo-ensaio = NO) OR 
           (l-controle = NO  AND AVAIL ttDadosAux)        THEN DO:
        
          /*** Display dos Campos em tela***/
          disp fiNumAmostra
               fiCodAmostra
               fiCodEnsaio 
               fiDescEnsaio
               fiNumTabela 
               fiDescTabela
               fiValMin    
               fiValMax    
               fiData      
               fiHora  with frame fPage0.   

          /*** Mostra campos em tela com formato correto em fun‡Æo do tipo de Resultado ****/
          run atualizaCampos in this-procedure.
        
        END.
        else do:
             {utp/ut-liter.i Foram_atualizados_todos_os_resultados! * }
             run utp/ut-msgs.p (input "Show":U,
                           input 17006,
                           input return-value).
              RUN verificaAprovacaoAmostra IN THIS-PROCEDURE.
        END.
    END. /*if cReturnAux  = "OK"*/

    

RETURN "OK":U.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaResultados wWindow 
PROCEDURE buscaResultados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pNumTabela as int                 no-undo.
def output param pLista   as char format "x(60)" no-undo.
if can-find (first mab-tab-restdo                       
             where mab-tab-restdo.num-tabela = pNumTabela no-lock ) then do:
    for first mab-tab-restdo fields (num-tabela)
        where mab-tab-restdo.num-tabela = pNumTabela no-lock:
    end.
    if avail mab-tab-restdo then do:
       for each mab-restdo-tab
           where  mab-restdo-tab.num-tabela = mab-tab-restdo.num-tabela no-lock:
           IF pLista = "" then
               assign pLista = mab-restdo-tab.des-restdo + "," + mab-restdo-tab.des-restdo.
           else
               assign pLista = pLista + "," + mab-restdo-tab.des-restdo + "," + mab-restdo-tab.des-restdo.
       end.
    end.
    else do:
        assign pLista = "":U.
    end.
end.
else do:
    assign pLista = "":U.
end.




return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE calculaDataHoraInvert wWindow 
PROCEDURE calculaDataHoraInvert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


define input  parameter pData      as character format "99/99/9999" no-undo.
define input  parameter pHora      as character format "999999"   no-undo.
define output parameter pInvertida as decimal   format "999999999999" no-undo.

assign pInvertida = decimal(trim(substring(pData,7,4)    /** Ano **/
                               + substring(pData,4,2)    /** Mˆs **/
                               + substring(pData,1,2)    /** Dia **/
                               + substring(pHora,1,2)    /** Hora **/
                               + substring(pHora,4,2))). /** Minuto **/

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE salvaRegistro wWindow 
PROCEDURE salvaRegistro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
empty temp-table tt-Result.

DEFINE VARIABLE cTexto AS CHARACTER  NO-UNDO.

for first ttDadosAux 
    where trim(ttDadosAux.cod-oficial) = REPLACE(trim(input frame fpage0 fiNumAmostra),".","")
    and   trim(ttDadosAux.cod-ensaio)  = trim(input frame fpage0 fiCodEnsaio) no-lock:
end.
if avail ttDadosAux then do:
  /****Atualiza informa‡äes da Temp-table com as informa‡äes digitadas pelo usu rio ***/
  create  tt-Result.
  IF l-controle = NO THEN
      /*gravando com base na TT */
      assign  tt-Result.num-amostra-oleo        = int(fiNumAmostra:screen-value in frame fPage0)
              tt-Result.cod-ensaio              = fiCodEnsaio:screen-value in frame fPage0
              tt-Result.dat-restdo-ensaio       = input frame fPage0 fiData
              tt-Result.hra-restdo-ensaio       = fiHora:screen-value in frame fPage0
              tt-Result.log-padrao              = ttDadosAux.log-padrao
              tt-Result.des-formato             = ttDadosAux.des-formato
              tt-Result.des-val-max             = fiValMax:screen-value in frame fPage0
              tt-Result.des-val-min             = fiValMin:screen-value in frame fPage0
              tt-Result.dsl-obs                 = ttDadosAux.dsl-obs
              tt-Result.num-tabela              = int(fiNumTabela:screen-value in frame fPage0)
              tt-Result.r-rowid                 = ttDadosAux.r-rowid.

  ELSE do: /*gravando dados com base na tabela*/
      BUFFER-COPY mao-restdo-ensaio TO tt-Result.
      ASSIGN tt-Result.num-amostra-oleo        = int(fiNumAmostra:screen-value in frame fPage0) 
             tt-Result.cod-ensaio              = fiCodEnsaio:screen-value in frame fPage0       
             tt-Result.dat-restdo-ensaio       = input frame fPage0 fiData                      
             tt-Result.hra-restdo-ensaio       = fiHora:screen-value in frame fPage0                                   
             tt-Result.des-val-max             = fiValMax:screen-value in frame fPage0          
             tt-Result.des-val-min             = fiValMin:screen-value in frame fPage0                                     
             tt-Result.num-tabela              = int(fiNumTabela:screen-value in frame fPage0).     
  END. /*ELSE do*/
          
  IF l-controle = NO THEN
      ASSIGN i-tip-restdo = ttDadosAux.idi-tip-restdo.
  ELSE DO:
      
      IF NOT AVAIL mao-ensaio OR mao-ensaio.cod-ensaio <> tt-Result.cod-ensaio THEN
          FIND FIRST mao-ensaio WHERE mao-ensaio.cod-ensaio = tt-Result.cod-ensaio NO-LOCK NO-ERROR.

      IF AVAIL mao-ensaio THEN
          ASSIGN i-tip-restdo = mao-ensaio.idi-tip-restdo.
  END.

  /*VALIDANDO O RESULTADO DIGITADO, PARA APROVAR OU NÇO O MESMO*/
  case i-tip-restdo:
        when 1 then do:   
              assign tt-Result.des-val-restdo =  input frame fPage0 fiResultado-num.
              if dec(fiResultado-num:screen-value in frame fPage0)  >= dec(fiValMin:screen-value in frame fPage0) and     
                 dec(fiResultado-num:screen-value in frame fPage0)  <= dec(fiValMax:screen-value in frame fPage0) then do:
                 assign tt-Result.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
              end.
              else do:
                  {utp/ut-liter.i Ensaio: * }
                  assign cTexto = return-value +  tt-Result.cod-ensaio.
                  run utp/ut-msgs.p (input "show":U,
                                      input 30268,
                                      input tt-Result.des-val-restdo + '~~' + cTexto).
                   IF return-value = "yes":U THEN DO:
                      assign tt-Result.idi-estado-ensaio = 3.   /*** Aprovado pelo Usu rio ***/
                   end.
                   else do:
                       assign tt-Result.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                   end.
              end.
        end.
        when 3 then do:
              assign tt-Result.des-val-restdo =  input frame fPage0 fiResultado-txt.
              if fiResultado-txt:screen-value in frame fPage0  >= fiValMin:screen-value in frame fPage0  and     
                 fiResultado-txt:screen-value in frame fPage0  <= fiValMax:screen-value in frame fPage0 then do:
                 assign tt-Result.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
              end.
              else do:
                  {utp/ut-liter.i Ensaio: * }
                  assign cTexto = return-value +  tt-Result.cod-ensaio.
                  run utp/ut-msgs.p (input "show":U,
                                      input 30268,
                                      input tt-Result.des-val-restdo + '~~' + cTexto).
                   IF return-value = "yes":U THEN DO:
                       assign tt-Result.idi-estado-ensaio = 3. /*** Aprovado pelo Usu rio ***/
                   end.
                   else do:
                       assign tt-Result.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                   end.
              end.
        end.
        when 2 then do:
           for first mab-restdo-tab
               where  mab-restdo-tab.num-tabela = int(fiNumTabela:screen-value in frame fPage0)
               and   mab-restdo-tab.des-restdo  = cbTabela:screen-value in frame fPage0 no-lock:
               assign tt-Result.des-val-restdo  = cbTabela:screen-value in frame fPage0.
           end.
           if avail mab-restdo-tab then do:
               if mab-restdo-tab.log-admit = true then do:
                  assign tt-Result.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
               end.
               else do:
                  {utp/ut-liter.i Ensaio: * }
                  assign cTexto = return-value +  tt-Result.cod-ensaio.
                  run utp/ut-msgs.p (input "show":U,
                                      input 30268,
                                      input tt-Result.des-val-restdo + '~~' + cTexto).
                   IF return-value = "yes":U THEN DO:
                       assign tt-Result.idi-estado-ensaio = 3. /*** Aprovado pelo Usu rio ***/
                   end.
                   else do:
                       assign tt-Result.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                   end.
               end.
           end. /*** if avail mab-restdo-tab ****/
        end.  
        when 4 then do:
              assign tt-Result.des-val-restdo =  input frame fPage0 fiResultado-dat.
              if date(fiResultado-dat:screen-value in frame fPage0) >= date(fiValMin:screen-value in frame fPage0)  and    
                 date(fiResultado-dat:screen-value in frame fPage0) <= date(fiValMax:screen-value in frame fPage0)  then do:
                 assign tt-Result.idi-estado-ensaio = 2. /*** Ensaio aprovado ***/
              end.
              else do:
                  {utp/ut-liter.i Ensaio: * }
                  assign cTexto = return-value +  tt-Result.cod-ensaio.
                  run utp/ut-msgs.p (input "show":U,
                                      input 30268,
                                      input tt-Result.des-val-restdo + '~~' + cTexto).
                   IF return-value = "yes":U THEN DO:
                       assign tt-Result.idi-estado-ensaio = 3. /*** Aprovado pelo Usu rio ***/
                   end.
                   else do:
                       assign tt-Result.idi-estado-ensaio = 4. /*** Ensaio Reprovado ***/
                   end.
              end.
        end.
  end case.  
        /** Atualiza o campo hora invertida. Ser  gravado no 
            formato "AAAAMMDDHHMMSS" (Ano+Mˆs+Dia+Hora+Minuto+Segundo) **/
        run calculaDataHoraInvert  in this-procedure (input  fiData:screen-value in frame fPage0,
                                                      input  fiHora:screen-value in frame fPage0,
                                                      output HoraInv).
        ASSIGN  tt-Result.val-dat-hora-invrtda  = HoraInv. 

         SESSION:SET-WAIT-STATE("general":U).
          /*** Posiciona no Registro Lido ****/
         RUN goToKey IN hDBOResult (INPUT tt-Result.num-amostra-oleo,
                                    INPUT tt-Result.cod-ensaio).       
         /*--- Limpa temp-table RowErrors no DBO ---*/
         RUN emptyRowErrors IN hDBOResult.
         /*--- Transfere temp-table tt-requisicao para o DBO ---*/
         RUN setRecord IN hDBOResult (INPUT TABLE tt-Result).
        /*--- Altera o registro corrente do DBO ---*/
         RUN updateRecord IN hDBOResult.
         /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
         ASSIGN cReturnAux = RETURN-VALUE.
         /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
         IF cReturnAux = "NOK":U THEN DO:
             /*--- Retorna temp-table RowErrors do DBO ---*/
             RUN getRowErrors IN hDBOResult (OUTPUT TABLE RowErrors).
             /** Elimina todos os erros intrnos da BO (Navega‡Æo) **/
             for each  RowErrors
                 where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
                 delete RowErrors.
             end.
            IF CAN-FIND(FIRST RowErrors 
                     WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
                /** Instancia aplicativo **/              
                {method/showmessage.i1}                   
                /** Mostra caixa com erros **/            
                {method/showmessage.i2 &Modal="YES"}      
                /** Limpa temp-tables de erros **/        
                empty temp-table RowErrors.               
                RETURN "NOK":U.
            end.
         END.
         /*--- Seta cursor do mouse para normal ---*/
         SESSION:SET-WAIT-STATE("":U).

    /*****Busca o pr¢ximo resultado para ser atualizado  *****************************/
    RUN buscaProximo IN THIS-PROCEDURE.

end. /*** IF AVAIL ttDadosAux ********/

/* RUN verificaAprovacaoAmostra IN THIS-PROCEDURE. */

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE verificaAprovacaoAmostra wWindow 
PROCEDURE verificaAprovacaoAmostra :
/*------------------------------------------------------------------------------
  Purpose:     verificaAprovacaoAmostra
  Parameters:  <none>
  Notes:       verifica se amostra ser  aprovada automaticamente, aprovada pelo usuario ou reprovada.
------------------------------------------------------------------------------*/

IF l-controle = NO OR 
  (l-controle = YES AND l-not-avail-mao-restdo-ensaio = YES) THEN DO:

   IF NOT CAN-FIND (FIRST mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo   = tt-Result.num-amostra-oleo
                                               AND mao-restdo-ensaio.idi-estado-ensaio  = 1 NO-LOCK) THEN DO:
        /*verifica se ainda h  algum registro pendente (1)*/

        IF NOT CAN-FIND (FIRST mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo  = tt-Result.num-amostra-oleo
                                                   AND mao-restdo-ensaio.idi-estado-ensaio <> 2 NO-LOCK) THEN DO:
            /**********Se todos os resultados estiverem Aprovados (2), entao aprovar a Amostra***********/
            RUN aprovaAmostraOleo IN THIS-PROCEDURE (INPUT 2, /*idi-estado-ensaio*/
                                                     INPUT tt-Result.num-amostra-oleo).
            IF RETURN-VALUE = "NOK":U THEN
                RETURN "NOK":U.
        END.
        ELSE DO:
            IF NOT CAN-FIND (FIRST mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo  = tt-Result.num-amostra-oleo
                                                       AND mao-restdo-ensaio.idi-estado-ensaio <> 2 
                                                       AND mao-restdo-ensaio.idi-estado-ensaio <> 3 NO-LOCK) THEN DO:
                /**********Se todos os resultados estiverem Aprovados (2) ou Aprovados pelo Usu rio (3), 
                                   entao aprovar a Amostra pelo Usuario (3)***********/
                         RUN aprovaAmostraOleo IN THIS-PROCEDURE (INPUT 3, /*idi-estado-ensaio*/
                                                             INPUT tt-Result.num-amostra-oleo).
                         IF RETURN-VALUE = "NOK":U THEN
                         RETURN "NOK":U.
           
            END.
            ELSE DO:
                
                IF NOT CAN-FIND (FIRST mao-restdo-ensaio
                                 WHERE mao-restdo-ensaio.num-amostra-oleo  = tt-Result.num-amostra-oleo
                                   AND mao-restdo-ensaio.idi-estado-ensaio = 1) THEN DO:
                    /*******nÆo h  nenhum pendente, mas h  reprovados. Questionar usu rio se ele deseja aprovar ou reprovar a amostra**********/
                    run utp/ut-msgs.p (input "Show":U,
                                       input 30272,
                                       input tt-Result.num-amostra-oleo).
                    IF RETURN-VALUE = "YES":U THEN DO:
                        /*aprovando pelo Usuario (3). Busca todos os resultados reprovados e aprova pelo usuario. Em seguida, aprova a amostra*/
                        FOR EACH mao-restdo-ensaio  WHERE mao-restdo-ensaio.num-amostra-oleo  = tt-Result.num-amostra-oleo
                                                      AND mao-restdo-ensaio.idi-estado-ensaio = 4 EXCLUSIVE-LOCK:
                            SESSION:SET-WAIT-STATE("general":U).
                            /*** Posiciona no Registro Lido ****/
                            run repositionRecord in hDBOResult (input ROWID(mao-restdo-ensaio)).
                            /*pega o registro*/
                            run getRecord in   hDBOResult  (output table tt-Result-aux).
                            /*grava o valor do estado da resultado para APROVADO PELO USUARIO (3)*/
                            FIND FIRST tt-Result-aux EXCLUSIVE-LOCK NO-ERROR.
                            ASSIGN tt-Result-aux.idi-estado-ensaio = 3.
                            /*--- Limpa temp-table RowErrors no DBO ---*/
                            RUN emptyRowErrors IN hDBOResult.
                            /*--- Transfere temp-table tt-requisicao para o DBO ---*/
                            RUN setRecord IN hDBOResult (INPUT TABLE tt-Result-aux).
                           /*--- Altera o registro corrente do DBO ---*/
                            RUN updateRecord IN hDBOResult.
                            /*--- Atualiza vari vel cReturnAux com o conte£do do RETURN-VALUE ---*/
                            ASSIGN cReturnAux = RETURN-VALUE.
                            /*--- Verifica ocorrˆncia de erros durante a grava‡Æo ---*/
                            IF cReturnAux = "NOK":U THEN DO:
                                /*--- Retorna temp-table RowErrors do DBO ---*/
                                RUN getRowErrors IN hDBOResult (OUTPUT TABLE RowErrors).
                                /** Elimina todos os erros intrnos da BO (Navega‡Æo) **/
                                for each  RowErrors
                                    where RowErrors.ErrorSubType <> "ERROR":U exclusive-lock:
                                    delete RowErrors.
                                END.
                                IF CAN-FIND(FIRST RowErrors 
                                        WHERE RowErrors.ErrorSubType = "ERROR":U ) then do:
                                   /** Instancia aplicativo **/              
                                   {method/showmessage.i1}                   
                                   /** Mostra caixa com erros **/            
                                   {method/showmessage.i2 &Modal="YES"}      
                                   /** Limpa temp-tables de erros **/        
                                   empty temp-table RowErrors.               
                                   RETURN "NOK":U.
                               END.
                            END.
                        
                            /*--- Seta cursor do mouse para normal ---*/
                            SESSION:SET-WAIT-STATE("":U).
                        END. /*FOR EACH mao-restdo-ensaio*/
    
                        /*aprova a amostra de oleo pelo Usuario, ap¢s ter aprovado os resultado que estavam reprovados*/
    
                        RUN aprovaAmostraOleo IN THIS-PROCEDURE (INPUT 3, /*idi-estado-ensaio*/
                                                                 INPUT tt-Result.num-amostra-oleo).
                        IF RETURN-VALUE = "NOK":U THEN
                            RETURN "NOK":U.
    
                    END. /*IF RETURN-VALUE = YES (questionamento ao usuario)*/
                    ELSE DO:
                        /*Usuario respondeu NAO, entao reprovar a Amostra*/
                        FOR EACH mao-restdo-ensaio WHERE mao-restdo-ensaio.num-amostra-oleo  = tt-Result.num-amostra-oleo
                                                     AND mao-restdo-ensaio.idi-estado-ensaio <> 2 EXCLUSIVE-LOCK:
    
                        RUN aprovaAmostraOleo IN THIS-PROCEDURE (INPUT 4, /*idi-estado-ensaio*/
                                                                 INPUT tt-Result.num-amostra-oleo).
                        IF RETURN-VALUE = "NOK":U THEN
                            RETURN "NOK":U.
                        END.
                    END.
                END.
            END.
        END. /*else do 1o not can-find*/

        APPLY "CLOSE":U TO THIS-PROCEDURE.
        RETURN "OK":U.

    END. /*if not can-find first amostra onde estado = 1*/
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

