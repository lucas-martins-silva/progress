&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wReport 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0410 2.00.00.002 } /*** 010002 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0410 MAB}
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
&GLOBAL-DEFINE Program        AB0410
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE Folder         YES
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   Parƒmetros,ImpressÆo

&GLOBAL-DEFINE PGLAY          NO
&GLOBAL-DEFINE PGSEL          YES
&GLOBAL-DEFINE PGCLA          NO
&GLOBAL-DEFINE PGPAR          NO
&GLOBAL-DEFINE PGDIG          NO
&GLOBAL-DEFINE PGIMP          YES
&GLOBAL-DEFINE PGLOG          NO

&GLOBAL-DEFINE page0Widgets   btOk ~
                              btCancel ~
                              btHelp2
&GLOBAL-DEFINE page1Widgets   
&GLOBAL-DEFINE page2Widgets   
&GLOBAL-DEFINE page3Widgets   
&GLOBAL-DEFINE page4Widgets   
&GLOBAL-DEFINE page5Widgets   
&GLOBAL-DEFINE page6Widgets   rsDestiny ~
                              btConfigImpr ~
                              btFile ~
                              rsExecution
&GLOBAL-DEFINE page7Widgets   
&GLOBAL-DEFINE page8Widgets   

&GLOBAL-DEFINE page0Text      
&GLOBAL-DEFINE page1Text      
&GLOBAL-DEFINE page2Text      
&GLOBAL-DEFINE page3Text      
&GLOBAL-DEFINE page4Text      
&GLOBAL-DEFINE page5Text      
&GLOBAL-DEFINE page6Text      text-destino text-modo
&GLOBAL-DEFINE page7Text      
&GLOBAL-DEFINE page8Text   

&GLOBAL-DEFINE page1Fields    
&GLOBAL-DEFINE page2Fields    fiMovimento fiEstabFim fiEstabIni fi-depos-ini fi-depos-fim
&GLOBAL-DEFINE page3Fields    
&GLOBAL-DEFINE page4Fields    
&GLOBAL-DEFINE page5Fields    
&GLOBAL-DEFINE page6Fields    cFile
&GLOBAL-DEFINE page7Fields    
&GLOBAL-DEFINE page8Fields    

/* Parameters Definitions ---                                           */

{abp/abapi005.i} /** Defini‡Æo da tt-param **/

define temp-table tt-digita no-undo
    field ordem            as integer   format ">>>>9":U
    field exemplo          as character format "x(30)":U
    index id ordem.

define buffer b-tt-digita for tt-digita.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

def var l-ok               as logical no-undo.
def var c-arq-digita       as char    no-undo.
def var c-terminal         as char    no-undo.
def var c-arq-layout       as char    no-undo.      
def var c-arq-temp         as char    no-undo.
DEFINE VARIABLE c-texto AS CHARACTER  NO-UNDO.

/*** Inicio Projeto 118 - Seguran‡a por Estabelecimento */

/* Valida os Modulo, para ver se tem Seguran‡a por Estabelecimento */
{cdp/cdapi3003.i "MAB":U}
/* Defini‡Æo das temp-table necessaria para tratar seguran‡a por Estabelecimento */
{cdp/cdapi3003.i1}

/*** Final Projeto 118 - Seguran‡a por Estabelecimento */


/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp2 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wReport AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "&Fechar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp2 
     LABEL "&Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "&Executar" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE fi-depos-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fi-depos-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Dep¢sito" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabFim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiEstabIni LIKE estabelec.cod-estabel
     LABEL "Estabelecimento":R15 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiMovimento AS DATE FORMAT "99/99/9999":U 
     LABEL "Data Final Movimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnidNegocFim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnidNegocIni AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unidade Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

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

DEFINE IMAGE IMAGE-7
     FILENAME "image~\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btConfigImpr 
     IMAGE-UP FILE "image~\im-cfprt":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE BUTTON btFile 
     IMAGE-UP FILE "image~\im-sea":U
     IMAGE-INSENSITIVE FILE "image~\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1.

DEFINE VARIABLE cFile AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 256
     SIZE 40 BY .88
     BGCOLOR 15  NO-UNDO.

DEFINE VARIABLE text-destino AS CHARACTER FORMAT "X(256)":U INITIAL " Destino" 
      VIEW-AS TEXT 
     SIZE 8.14 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE text-modo AS CHARACTER FORMAT "X(256)":U INITIAL "Execu‡Æo" 
      VIEW-AS TEXT 
     SIZE 10.86 BY .63
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsDestiny AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Impressora", 1,
"Arquivo", 2,
"Terminal", 3
     SIZE 44 BY 1.08
     FONT 1 NO-UNDO.

DEFINE VARIABLE rsExecution AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "On-Line", 1,
"Batch", 2
     SIZE 27.72 BY .92
     FONT 1 NO-UNDO.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 2.92.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 46.29 BY 1.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 14.75 COL 2
     btCancel AT ROW 14.75 COL 13
     btHelp2 AT ROW 14.75 COL 80
     rtToolBar AT ROW 14.54 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 15
         FONT 1.

DEFINE FRAME fPage2
     fiMovimento AT ROW 2.5 COL 27 COLON-ALIGNED
     fiEstabIni AT ROW 3.5 COL 27.14 COLON-ALIGNED HELP
          "C¢digo do estabelecimento"
          LABEL "Estabelecimento":R15
     fiEstabFim AT ROW 3.5 COL 43.57 COLON-ALIGNED HELP
          "C¢digo do estabelecimento" NO-LABEL
     fi-depos-ini AT ROW 4.5 COL 27.14 COLON-ALIGNED
     fi-depos-fim AT ROW 4.5 COL 43.57 COLON-ALIGNED NO-LABEL
     fiUnidNegocIni AT ROW 5.5 COL 27.14 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio"
     fiUnidNegocFim AT ROW 5.5 COL 43.57 COLON-ALIGNED HELP
          "C¢digo Unidade Neg¢cio" NO-LABEL
     IMAGE-3 AT ROW 3.5 COL 35.86
     IMAGE-4 AT ROW 3.5 COL 42.57
     IMAGE-5 AT ROW 4.5 COL 35.86
     IMAGE-6 AT ROW 4.5 COL 42.57
     IMAGE-7 AT ROW 5.5 COL 35.86
     IMAGE-8 AT ROW 5.5 COL 42.57
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
         FONT 1.

DEFINE FRAME fPage6
     rsDestiny AT ROW 2.38 COL 3.29 HELP
          "Destino de ImpressÆo do Relat¢rio" NO-LABEL
     btFile AT ROW 3.58 COL 43.29 HELP
          "Escolha do nome do arquivo"
     btConfigImpr AT ROW 3.58 COL 43.29 HELP
          "Configura‡Æo da impressora"
     cFile AT ROW 3.63 COL 3.29 HELP
          "Nome do arquivo de destino do relat¢rio" NO-LABEL
     rsExecution AT ROW 5.75 COL 3 HELP
          "Modo de Execu‡Æo" NO-LABEL
     text-destino AT ROW 1.63 COL 1.86 COLON-ALIGNED NO-LABEL
     text-modo AT ROW 5 COL 1.29 COLON-ALIGNED NO-LABEL
     RECT-7 AT ROW 1.92 COL 2.14
     RECT-9 AT ROW 5.29 COL 2.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.81
         SIZE 84.43 BY 10.15
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
  CREATE WINDOW wReport ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 15
         WIDTH              = 90
         MAX-HEIGHT         = 15
         MAX-WIDTH          = 90
         VIRTUAL-HEIGHT     = 15
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wReport 
/* ************************* Included-Libraries *********************** */

{report/report.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wReport
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   NOT-VISIBLE FRAME-NAME                                               */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* SETTINGS FOR FILL-IN fiEstabFim IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL                       */
/* SETTINGS FOR FILL-IN fiEstabIni IN FRAME fPage2
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FRAME fPage6
                                                                        */
ASSIGN 
       text-destino:PRIVATE-DATA IN FRAME fPage6     = 
                "Destino".

ASSIGN 
       text-modo:PRIVATE-DATA IN FRAME fPage6     = 
                "Execu‡Æo".

IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wReport)
THEN wReport:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wReport
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON END-ERROR OF wReport
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wReport wReport
ON WINDOW-CLOSE OF wReport
DO:
  /* This event will close the window and terminate the procedure.  */
  {report/logfin.i}  
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wReport
ON CHOOSE OF btCancel IN FRAME fpage0 /* Fechar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btConfigImpr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfigImpr wReport
ON CHOOSE OF btConfigImpr IN FRAME fPage6
DO:
   {report/rpimp.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFile wReport
ON CHOOSE OF btFile IN FRAME fPage6
DO:
    {report/rparq.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp2 wReport
ON CHOOSE OF btHelp2 IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wReport
ON CHOOSE OF btOK IN FRAME fpage0 /* Executar */
DO:
   do  on error undo, return no-apply:
       /*** Projeto 118 - Seguran‡a por Estabelecimento */
       IF  l-seg-ativa-modulo THEN
           RUN piValidaSegPorEstabel IN THIS-PROCEDURE.
       run piExecute.
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME rsDestiny
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsDestiny wReport
ON VALUE-CHANGED OF rsDestiny IN FRAME fPage6
DO:
do  with frame fPage6:
    case self:screen-value:
        when "1":U then do:
            assign cFile:sensitive       = no
                   cFile:visible         = yes
                   btFile:visible        = no
                   btConfigImpr:visible  = yes.
        end.
        when "2":U then do:
            assign cFile:sensitive       = yes
                   cFile:visible         = yes
                   btFile:visible        = yes
                   btConfigImpr:visible  = no.
        end.
        when "3":U then do:
            assign cFile:visible         = no
                   cFile:sensitive       = no
                   btFile:visible        = no
                   btConfigImpr:visible  = no.
        end.
    end case.
end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rsExecution
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rsExecution wReport
ON VALUE-CHANGED OF rsExecution IN FRAME fPage6
DO:
   {report/rprse.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wReport 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/

ASSIGN fiEstabFim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.

{report/mainblock.i}

FOR FIRST mab-param-integr
    WHERE mab-param-integr.cdn-param = 8 NO-LOCK:
END.

IF AVAIL mab-param-integr AND mab-param-integr.des-valor = "1" THEN DO:
    {utp/ut-liter.i "O programa AB0410 nÆo pode ser executado porque o parƒmetro 08, dos parƒmetros de integra‡Æo (AB0116), est  selecionado para nÆo integrar com o estoque."}
    ASSIGN c-texto = RETURN-VALUE.
    {utp/ut-liter.i "Integra‡Æo com Estoque Inativa"}
    RUN utp/ut-msgs.p (INPUT "SHOW":U,
                       INPUT 17006,
                       INPUT RETURN-VALUE + "~~" + c-texto).
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wReport 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializa‡Æo de tela
------------------------------------------------------------------------------*/
{utp/ut-liter.i Dep¢sito}
assign fi-depos-ini:label in frame fPage2 = return-value.

assign fiMovimento = today.
display fiMovimento 
    with frame fPage2.

ASSIGN fiUnidNegocIni:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocIni:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:VISIBLE   IN FRAME fPage2 = l-usa-unid-negoc
       fiUnidNegocFim:SENSITIVE IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-7:VISIBLE          IN FRAME fPage2 = l-usa-unid-negoc
       IMAGE-8:VISIBLE          IN FRAME fPage2 = l-usa-unid-negoc.

IF l-usa-unid-negoc THEN DO:
    {utp/ut-liter.i Unidade_Neg¢cio}
    ASSIGN fiUnidNegocIni:LABEL IN FRAME fPage2 = TRIM(RETURN-VALUE).

    ASSIGN fiUnidNegocFim:SCREEN-VALUE IN FRAME fPage2 = fiUnidNegocFim.
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piExecute wReport 
PROCEDURE piExecute :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

define var r-tt-digita as rowid no-undo.

&IF DEFINED(PGIMP) <> 0 AND "{&PGIMP}":U = "YES":U &THEN
/*:T** Relatorio ***/
do on error undo, return error on stop  undo, return error:
    {report/rpexa.i}
    
    if input frame fPage6 rsDestiny = 2 and
       input frame fPage6 rsExecution = 1 then do:
        run utp/ut-vlarq.p (input input frame fPage6 cFile).
        
        if return-value = "NOK":U then do:
            run utp/ut-msgs.p (input "show":U, input 73, input "":U).
            apply "ENTRY":U to cFile in frame fPage6.
            return error.
        end.
    end.

    /*:T Aqui sÆo gravados os campos da temp-table que ser  passada como parƒmetro
       para o programa RP.P */
    
    create tt-param.
    assign tt-param.usuario         = c-seg-usuario
           tt-param.destino         = input frame fPage6 rsDestiny
           tt-param.data-exec       = today
           tt-param.hora-exec       = time
           tt-param.dataMovimento   = input frame fPage2 fiMovimento
           tt-param.estabInicial    = input frame fPage2 fiEstabIni
           tt-param.estabFinal      = input frame fPage2 fiEstabFim
           /** Este parƒmetro nÆo ‚ mais utilizado **/
           tt-param.lAcumula        = NO   /*tgAcumula:checked in frame fPage2*/
           tt-param.depositoIni     = input frame fPage2 fi-depos-ini
           tt-param.depositoFim     = input frame fPage2 fi-depos-fim.
    
    if tt-param.destino = 1 
    then 
        assign tt-param.arquivo = "":U.
    else if  tt-param.destino = 2 
         then assign tt-param.arquivo = input frame fPage6 cFile.
         else assign tt-param.arquivo = session:temp-directory + c-programa-mg97 + ".tmp":U.
    
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN tt-param.unidNegocIni = input frame fPage2 fiUnidNegocIni
                   tt-param.unidNegocFim = input frame fPage2 fiUnidNegocFim.
        END.
    &ENDIF

    /*:T Coloque aqui a l¢gica de grava‡Æo dos demais campos que devem ser passados
       como parƒmetros para o programa RP.P, atrav‚s da temp-table tt-param */
        
    
    /*:T Executar do programa RP.P que ir  criar o relat¢rio */
    {report/rpexb.i}
    
    SESSION:SET-WAIT-STATE("GENERAL":U).
    
    {report/rprun.i abp/ab0410rp.p}
    
    {report/rpexc.i}
    
    SESSION:SET-WAIT-STATE("":U).
    
    {report/rptrm.i}
end.
&ELSE
/*:T** Importacao/Exportacao ***/
&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaSegPorEstabel wReport 
PROCEDURE piValidaSegPorEstabel :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Valida Seguran‡a por Estabelecimento
  
  Referente ao Projeto 118 - Seguran‡a por Estabelecimento 
  
------------------------------------------------------------------------------*/
    /* Definicao de Variaveis */
    DEFINE VARIABLE i-cont-erro-seg   AS INTEGER   NO-UNDO.
    DEFINE VARIABLE c-help-erro-seg   AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cFinalidade       AS CHARACTER NO-UNDO.
    DEFINE VARIABLE lTemRestricao     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE lErroExecucao     AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE h_api_perm_estab  AS HANDLE    NO-UNDO.

    EMPTY TEMP-TABLE tt_log_erro.
    EMPTY TEMP-TABLE tt_estab_ems2.
    EMPTY TEMP-TABLE ttEmpEstabelSemSeg.


    /* Executa api de Finan¯as */
    RUN prgint/utb/utb746za.py PERSISTENT SET h_api_perm_estab.
    RUN pi_retorna_estab_sem_permissao_ems2 IN h_api_perm_estab (OUTPUT TABLE tt_estab_ems2,
                                                                 OUTPUT TABLE tt_log_erro).
    /* Destroi handle */
    DELETE OBJECT h_api_perm_estab.

    FOR EACH tt_estab_ems2 NO-LOCK:
        FIND FIRST estabelec
             WHERE estabelec.cod-estabel = tt_estab_ems2.tta_cod_estab NO-LOCK NO-ERROR.
        IF  AVAIL estabelec THEN DO:
            CREATE ttEmpEstabelSemSeg.
            ASSIGN ttEmpEstabelSemSeg.ep-codigo   = estabelec.ep-codigo
                   ttEmpEstabelSemSeg.cod-estabel = estabelec.cod-estabel.
        END.
    END.

    /* Verifica se dentro da faixa de Empresa existe algum Estabelecimento no qual o usuario nao tem acesso */
    ASSIGN i-cont-erro-seg = 0
           c-help-erro-seg = ""
           lTemRestricao   = NO.
    FOR EACH ttEmpEstabelSemSeg
        WHERE ttEmpEstabelSemSeg.cod-estabel >= input frame fPage2 fiEstabIni
        AND   ttEmpEstabelSemSeg.cod-estabel <= input frame fPage2 fiEstabFim NO-LOCK
        BY ttEmpEstabelSemSeg.ep-codigo
        BY ttEmpEstabelSemSeg.cod-estabel:
        IF  i-cont-erro-seg <> 0 THEN DO:
            ASSIGN c-help-erro-seg = c-help-erro-seg + ", " + ttEmpEstabelSemSeg.cod-estabel.
        END.
        ELSE DO:
            ASSIGN c-help-erro-seg = c-help-erro-seg + ttEmpEstabelSemSeg.cod-estabel.
            assign i-cont-erro-seg = 1. 
        END.
        ASSIGN lTemRestricao = YES.
    END.

    /* Se houver algum Estabelecimento no qual o usuario nao tem acesso ‚ exibido uma mensagem informando os Estabelecimentos com Restri‡Æo */
    {utp/ut-liter.i "Cria_Requisi‡Æo_Estoque_para_Abastecimento_/_Lubrifica‡Æo"}
    ASSIGN cFinalidade = RETURN-VALUE.
    EMPTY TEMP-TABLE RowErrors.
    IF  lTemRestricao THEN DO:
        CREATE RowErrors.
        ASSIGN RowErrors.ErrorSequence = 1.
        ASSIGN RowErrors.ErrorNumber  = 52047.

        RUN utp/ut-msgs.p (INPUT "msg",
                           INPUT 52047,
                           INPUT cFinalidade + "~~" + c-help-erro-seg + "~~" + "").
        ASSIGN RowErrors.ErrorDescription  = RETURN-VALUE.

        RUN utp/ut-msgs.p (INPUT "help",
                           INPUT 52047,
                           INPUT cFinalidade + "~~" + c-help-erro-seg + "~~" + "").
        ASSIGN RowErrors.ErrorHelp = RETURN-VALUE.

        ASSIGN RowErrors.ErrorType = "EMS":U.
        ASSIGN RowErrors.ErrorSubType = "ERROR":U.

        RUN piMostraErros IN THIS-PROCEDURE.

        run setFolder in hFolder (input 1).
        apply "ENTRY":U to fiEstabIni in frame fPage2.
        RETURN ERROR.
    END.

    RETURN "OK":U.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wReport 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Exibe Erro da temp-table RowErrors
------------------------------------------------------------------------------*/
    
    /** Instancia aplicativo **/
    {method/showmessage.i1}
    /** Mostra caixa com erros existes na RowErrors **/
    {method/showmessage.i2 &Modal="YES"}
    /*--- Destroi tela de mensagens de erros ---*/
    {method/showmessage.i3}

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



