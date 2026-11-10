&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          movfro           PROGRESS
*/
&Scoped-define WINDOW-NAME wMaintenanceNoNavigation


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE ttApont NO-UNDO LIKE mab-abastec-lubrific
       field r-rowid as rowid.



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wMaintenanceNoNavigation 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i AB0302A 2.00.00.027 } /*** "010027" 08/08/2025 11:24:56 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0302a MAB}
&ENDIF


/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program           AB0302A
&GLOBAL-DEFINE Version        2.00.00.027

&GLOBAL-DEFINE Folder            YES
&GLOBAL-DEFINE InitialPage       1

&GLOBAL-DEFINE FolderLabels      P†g. 1

&GLOBAL-DEFINE ttTable           ttApont
&GLOBAL-DEFINE hDBOTable         hDBOApont
&GLOBAL-DEFINE DBOTable          mab-abastec-lubrific

&GLOBAL-DEFINE page0KeyFields    
&GLOBAL-DEFINE page0Fields       ttApont.ep-codigo ttApont.cod-eqpto
&GLOBAL-DEFINE page1Fields       ttApont.cod-ativid ttApont.nr-nota-fis ~
                                 ttApont.serie ttApont.cod-posto ~
                                 ttApont.cod-rota fi-cod-unid-negoc ~
                                 ttApont.dat-movto ttApont.hra-final ~
                                 ttApont.hra-inicial ttApont.cod-matr ~
                                 ttApont.val-hodom-horim ttApont.cod-usuar ~
                                 ttApont.ep-codigo-matr ttApont.cod-estabel-matr ~
                                 ttApont.val-hodom-horim-sec fiContaLub fiSubLub
/* Parameters Definitions ---                                           */
DEFINE INPUT PARAMETER prTable         AS ROWID     NO-UNDO.
DEFINE INPUT PARAMETER pcAction        AS CHARACTER NO-UNDO.
DEFINE INPUT PARAMETER phCaller        AS HANDLE    NO-UNDO.

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE cCodModelo  AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFConta     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cFSub       AS CHARACTER  NO-UNDO.
DEFINE VARIABLE cHora       AS CHARACTER format "99:99:99" NO-UNDO.
DEFINE VARIABLE cUnModelSec AS CHARACTER  NO-UNDO.
DEFINE VARIABLE lLogContSec AS LOGICAL    NO-UNDO.
DEFINE VARIABLE dAuxiliar   AS DECIMAL    NO-UNDO.
DEFINE VARIABLE iKey        AS INTEGER    NO-UNDO.

DEFINE VARIABLE cEstabEqpto AS CHARACTER NO-UNDO.

/** Zoom **/
DEFINE NEW GLOBAL SHARED VARIABLE adm-broker-hdl AS HANDLE NO-UNDO.
DEFINE VARIABLE wh-pesquisa AS HANDLE    NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable}  AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOEqpto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOModelo    AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOPosto     AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOAtiv      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOMoto      AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOTraj      AS HANDLE NO-UNDO.     
DEFINE VARIABLE hDBOApi003a   AS HANDLE NO-UNDO.
DEFINE VARIABLE hDBOHistor    AS HANDLE NO-UNDO.
{abp/ab9000.i}  /** Procedure buscaFormatoConta **/


{cdp/cdunif001.i} /*vari†veis unificaá∆o de conceito*/
/*unificaá∆o de conceito - centro de custo e conta contabil*/
DEFINE VARIABLE cEmpresaEstab AS CHARACTER   NO-UNDO.
DEFINE VARIABLE dDtMovimento  AS DATE        NO-UNDO.

/*variaveis globais para funcionamento da upc Colombo*/
DEF NEW GLOBAL SHARED VARIABLE i-glob-ep-codigo LIKE mab-abastec-lubrific.ep-codigo NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-cod-eqpto AS CHAR FORMAT "X(16)" NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-cod-posto AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-conta-contabil AS CHAR NO-UNDO.
DEF NEW GLOBAL SHARED VARIABLE c-glob-sub-conta AS CHAR NO-UNDO.

&IF DEFINED(bf_mnt_ems206b) &THEN
    {frbo/bofr133.i tt-unid-negoc-histor}
&ENDIF

{cdp/cd0031.i "MAB":U} /** Trigger on-fin da tabela estabelec **/
DEFINE BUFFER bfEquipto FOR mab-eqpto.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE MaintenanceNoNavigation
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ttApont.num-docto ttApont.ep-codigo ~
ttApont.cod-eqpto 
&Scoped-define ENABLED-TABLES ttApont
&Scoped-define FIRST-ENABLED-TABLE ttApont
&Scoped-Define ENABLED-OBJECTS btOK btSave fiDescModelo btCancel btHelp ~
rtKeys rtToolBar 
&Scoped-Define DISPLAYED-FIELDS ttApont.num-docto ttApont.ep-codigo ~
ttApont.cod-eqpto 
&Scoped-define DISPLAYED-TABLES ttApont
&Scoped-define FIRST-DISPLAYED-TABLE ttApont
&Scoped-Define DISPLAYED-OBJECTS fiDescModelo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wMaintenanceNoNavigation AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.25.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btMatriz 
     IMAGE-UP FILE "image/im-negoc.bmp":U
     IMAGE-INSENSITIVE FILE "image/ii-negoc.bmp":U
     LABEL "Matriz Unidade Neg¢cio" 
     SIZE 4 BY 1.

DEFINE VARIABLE fi-cod-unid-negoc AS CHARACTER FORMAT "X(3)" 
     LABEL "Unidade Neg¢cio":R18 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fiConta AS CHARACTER FORMAT "X(20)" 
     LABEL "Conta Abastecimento":R20 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiContaLub AS CHARACTER FORMAT "X(20)":U 
     LABEL "Conta Lubrificaá∆o" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 TOOLTIP "C¢digo Conta Lubrificaá∆o" NO-UNDO.

DEFINE VARIABLE fiDescAtiv AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescMotorista AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 35.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescPosto AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiDescTrajeto AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiSub AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fiSubLub AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 TOOLTIP "Centro de Custo" NO-UNDO.

DEFINE VARIABLE fiUn AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fiUnSec AS CHARACTER FORMAT "X(2)":U 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60 BY 1.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     ttApont.num-docto AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     ttApont.ep-codigo AT ROW 2.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApont.cod-eqpto AT ROW 3.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14 BY .88
     btOK AT ROW 17.5 COL 2
     btSave AT ROW 17.5 COL 13
     fiDescModelo AT ROW 3.25 COL 42.57 COLON-ALIGNED HELP
          "Descriá∆o Modelo Equipamento" NO-LABEL NO-TAB-STOP 
     btCancel AT ROW 17.5 COL 24
     btHelp AT ROW 17.5 COL 80
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.25 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 17.75
         FONT 1.

DEFINE FRAME fPage1
     ttApont.dat-movto AT ROW 1.75 COL 32 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     ttApont.hra-inicial AT ROW 1.75 COL 52 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttApont.hra-final AT ROW 1.75 COL 69 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     ttApont.ep-codigo-matr AT ROW 3.25 COL 18 COLON-ALIGNED
          LABEL "Motorista":R9
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     ttApont.cod-estabel-matr AT ROW 3.25 COL 22.14 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5 BY .88
     ttApont.cod-matr AT ROW 3.25 COL 27.43 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescMotorista AT ROW 3.25 COL 37.72 COLON-ALIGNED HELP
          "Nome do Motorista" NO-LABEL
     ttApont.cod-posto AT ROW 4.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescPosto AT ROW 4.25 COL 28.43 COLON-ALIGNED HELP
          "Descriá∆o do Posto de Abastecimento/Lubrificaá∆o" NO-LABEL
     ttApont.cod-ativid AT ROW 5.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescAtiv AT ROW 5.25 COL 28.43 COLON-ALIGNED HELP
          "Descriá∆o da Atividade" NO-LABEL
     ttApont.cod-rota AT ROW 6.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     fiDescTrajeto AT ROW 6.25 COL 28.43 COLON-ALIGNED HELP
          "Descriá∆o do Trajeto" NO-LABEL
     ttApont.val-hodom-horim AT ROW 7.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUn AT ROW 7.25 COL 30.57 COLON-ALIGNED NO-LABEL
     ttApont.val-hodom-horim-sec AT ROW 7.25 COL 55.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     fiUnSec AT ROW 7.25 COL 67.86 COLON-ALIGNED NO-LABEL
     fiConta AT ROW 8.25 COL 18 COLON-ALIGNED
     fiSub AT ROW 8.25 COL 38.29 COLON-ALIGNED NO-LABEL
     fi-cod-unid-negoc AT ROW 8.25 COL 72.72 COLON-ALIGNED HELP
          "C¢digo Unidade de Neg¢cio"
     fiContaLub AT ROW 9.25 COL 18 COLON-ALIGNED WIDGET-ID 2
     fiSubLub AT ROW 9.25 COL 38.29 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     btMatriz AT ROW 8.21 COL 80
     ttApont.nr-nota-fis AT ROW 10.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.57 BY .88
     ttApont.serie AT ROW 10.25 COL 35 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.57 BY .88
     ttApont.cod-usuar AT ROW 10.25 COL 62.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10 BY .88
     "Movimento" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.13 COL 22
     RECT-1 AT ROW 1.25 COL 20
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 5.71
         SIZE 84.43 BY 10.79
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: MaintenanceNoNavigation
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: ttApont T "?" NO-UNDO movfro mab-abastec-lubrific
      ADDITIONAL-FIELDS:
          field r-rowid as rowid
      END-FIELDS.
   END-TABLES.
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wMaintenanceNoNavigation ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17.75
         WIDTH              = 90
         MAX-HEIGHT         = 38.29
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.29
         VIRTUAL-WIDTH      = 182.86
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wMaintenanceNoNavigation 
/* ************************* Included-Libraries *********************** */

{maintenancenonavigation/maintenancenonavigation.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wMaintenanceNoNavigation
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME Custom                                                    */

DEFINE VARIABLE XXTABVALXX AS LOGICAL NO-UNDO.

ASSIGN XXTABVALXX = FRAME fPage1:MOVE-AFTER-TAB-ITEM (ttApont.cod-eqpto:HANDLE IN FRAME fpage0)
       XXTABVALXX = FRAME fPage1:MOVE-BEFORE-TAB-ITEM (btOK:HANDLE IN FRAME fpage0)
/* END-ASSIGN-TABS */.

/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN ttApont.ep-codigo-matr IN FRAME fPage1
   EXP-LABEL                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wMaintenanceNoNavigation)
THEN wMaintenanceNoNavigation:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fpage0
/* Query rebuild information for FRAME fpage0
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fpage0 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wMaintenanceNoNavigation
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON END-ERROR OF wMaintenanceNoNavigation
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wMaintenanceNoNavigation wMaintenanceNoNavigation
ON WINDOW-CLOSE OF wMaintenanceNoNavigation
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wMaintenanceNoNavigation
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wMaintenanceNoNavigation
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btMatriz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btMatriz wMaintenanceNoNavigation
ON CHOOSE OF btMatriz IN FRAME fPage1 /* Matriz Unidade Neg¢cio */
DO:
    /*--- Seta cursor do mouse para espera ---*/
    SESSION:SET-WAIT-STATE("GENERAL":U).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = NO.

    /*--- Executa programa de manutená∆o de filho ---*/
    RUN abp/ab0302e.w (INPUT INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                       INPUT INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                       INPUT INPUT FRAME fPage1 {&ttTable}.dat-movto).

    ASSIGN {&WINDOW-NAME}:SENSITIVE = YES.
    /*--- Seta cursor do mouse para normal ---*/
    SESSION:SET-WAIT-STATE("":U).

    APPLY "ENTRY":U TO btMatriz IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wMaintenanceNoNavigation
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    /** Verifica valores de hodìmetro/hor°metro **/
    run piHodometro in this-procedure.
    if return-value = "NOK":U then do:
        return no-apply.
    end.
    FOR FIRST mab-eqpto
         WHERE mab-eqpto.ep-codigo     =  ttApont.ep-codigo:SCREEN-VALUE IN FRAME fPage0
         AND   mab-eqpto.cod-eqpto     =  ttApont.cod-eqpto:SCREEN-VALUE IN FRAME fPage0
         AND   mab-eqpto.dat-situacao  >  date(ttApont.dat-movto:SCREEN-VALUE IN FRAME fPage1) NO-LOCK:
        IF CAN-FIND (FIRST mab-sit-eqpto
                     WHERE mab-sit-eqpto.cod-sit-eqpto = mab-eqpto.cod-sit-eqpto
                     AND   mab-sit-eqpto.idi-tip       = 2) THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 26405,
                               INPUT "").
            RETURN "NOK":U.
        END.
    END.
    RUN abp/abapi003a.p PERSISTENT SET hDBOApi003a (INPUT 0,
                                                    INPUT 0,
                                                    INPUT 0,
                                                    INPUT 0,
                                                    INPUT "",
                                                    INPUT ?,
                                                    INPUT "",
                                                    INPUT "",
                                                    OUTPUT dAuxiliar,
                                                    OUTPUT dAuxiliar,
                                                    OUTPUT dAuxiliar).
    /** Salva Registro **/
    RUN saveRecord IN THIS-PROCEDURE.
    IF RETURN-VALUE = "OK":U THEN
        APPLY "CLOSE":U TO THIS-PROCEDURE.
    else do:
        if pcAction <> "UPDATE":U then do:
            /** Busca a numeraá∆o do Apontamento, pois pode ter sido 
                inclu°do um outro registro durante este erro **/
            run buscaDocumento in {&hDBOTable} (output {&ttTable}.num-docto).
            /** Mostra documento em tela **/
            display {&ttTable}.num-docto
                with frame fPage0.
            return no-apply.
        end.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btSave
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btSave wMaintenanceNoNavigation
ON CHOOSE OF btSave IN FRAME fpage0 /* Salvar */
DO:
    /** Verifica valores de hodìmetro/hor°metro **/
    run piHodometro in this-procedure.
    if return-value = "NOK":U then do:
        return no-apply.
    end.

    RUN abp/abapi003a.p PERSISTENT SET hDBOApi003a (INPUT 0,
                                                    INPUT 0,
                                                    INPUT 0,
                                                    INPUT 0,
                                                    INPUT "",
                                                    INPUT ?,
                                                    INPUT "",
                                                    INPUT "",
                                                    OUTPUT dAuxiliar,
                                                    OUTPUT dAuxiliar,
                                                    OUTPUT dAuxiliar).

    /** Salva Registro **/
    RUN saveRecord IN THIS-PROCEDURE.
    if pcAction <> "UPDATE":U then do:
        /** Busca a numeraá∆o do Apontamento, pois pode ter sido 
            inclu°do um outro registro durante este erro **/
        run buscaDocumento in {&hDBOTable} (output {&ttTable}.num-docto).
        /** Mostra documento em tela **/
        display {&ttTable}.num-docto
            with frame fPage0.
        return no-apply.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttApont.cod-ativid
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-ativid wMaintenanceNoNavigation
ON F5 OF ttApont.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr001.w"
           &FieldZoom1="cod-ativid"
           &FieldScreen1="{&ttTable}.cod-ativid"
           &Frame1="fPage1"
           &FieldZoom2="des-ativid"
           &FieldScreen2="fiDescAtiv"
           &Frame2="fPage1"
           &EnableImplant="YES"}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-ativid wMaintenanceNoNavigation
ON LEAVE OF ttApont.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOAtiv"
        &KeyValue1="{&ttTable}.cod-ativid:screen-value in frame fPage1"
        &FieldName1="des-ativid"
        &FieldScreen1="fiDescAtiv"
        &Frame1="fPage1"}     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-ativid wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.cod-ativid IN FRAME fPage1 /* Atividade */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttApont.cod-eqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-eqpto wMaintenanceNoNavigation
ON F5 OF ttApont.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr007.w"
           &FieldZoom1="ep-codigo"
           &FieldScreen1="{&ttTable}.ep-codigo"
           &Frame1="fPage0"
           &FieldZoom2="cod-eqpto"
           &FieldScreen2="{&ttTable}.cod-eqpto"
           &Frame2="fPage0"
           &EnableImplant="YES"}
        apply "LEAVE":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-eqpto wMaintenanceNoNavigation
ON LEAVE OF ttApont.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:

    /* Seguranáa estabelecimento */
    IF  l-seg-ativa-modulo THEN
        RUN ValidaSegurancaEstabelecimento (input ttApont.ep-codigo:SCREEN-VALUE IN FRAME fPage0,
                                            input ttApont.cod-eqpto:SCREEN-VALUE IN FRAME fPage0).
    
    /*
        Somente ir† executar a l¢gica abaixo nas seguintes condiá‰es:
        1 - Seguranáa por estabelecimento n∆o estiver habilitada
        2 - Se Seguranáa por estabelecimento estiver habilitada E o retorno da validaá∆o for "OK", ou seja, o usu†rio tem permiss∆o ao estabelecimento em quest∆o
    */
    IF  l-seg-ativa-modulo = NO OR (l-seg-ativa-modulo AND RETURN-VALUE = "OK":U) THEN DO:
        /* A Vari†vel "cEstabEqpto" Ç utilizada no leave das contas */
        RUN piBuscaEstabelEqpto IN THIS-PROCEDURE (OUTPUT cEstabEqpto).

        run buscaModelo in this-procedure.
        {method\referenceFields.i
            &HandleDBOLeave="hDBOModelo"
            &KeyValue1="cCodModelo"
            &FieldName1="des-model"
            &FieldScreen1="fiDescModelo"
            &Frame1="fPage0"
            &FieldName2="un"
            &FieldScreen2="fiUN"
            &Frame2="fPage1"}
            
        if pcAction <> "UPDATE":U then
            run piAtividade in this-procedure.

        /*ponto de chamada da upc colombo*/
        APPLY "leave":U TO ttApont.cod-posto IN FRAME fPage1.

        RUN piValidaContadorSec IN THIS-PROCEDURE.

        /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
        IF l-usa-unid-negoc THEN
            RUN piValidaMatriz IN THIS-PROCEDURE.

        APPLY "ENTRY":U TO {&ttTable}.dat-movto IN FRAME fPage1.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-eqpto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.cod-eqpto IN FRAME fpage0 /* Equipamento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttApont.cod-estabel-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-estabel-matr wMaintenanceNoNavigation
ON F5 OF ttApont.cod-estabel-matr IN FRAME fPage1 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO {&ttTable}.cod-matr IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-estabel-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.cod-estabel-matr IN FRAME fPage1 /* cod-estabel-matr */
DO:
  APPLY "F5":U TO {&ttTable}.cod-matr IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.cod-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-matr wMaintenanceNoNavigation
ON F5 OF ttApont.cod-matr IN FRAME fPage1 /* cod-matr */
DO:
    {method/zoomfields.i 
        &ProgramZoom="frzoom/z01fr017.w"
        &FieldZoom1="ep-codigo"
        &FieldScreen1="{&ttTable}.ep-codigo-matr"
        &Frame1="fPage1"
        &FieldZoom2="cod-estabel"
        &FieldScreen2="{&ttTable}.cod-estabel-matr"
        &Frame2="fPage1"
        &FieldZoom3="cod-matr"
        &FieldScreen3="{&ttTable}.cod-matr"
        &Frame3="fPage1"
        &FieldZoom4="nom-motoris"
        &FieldScreen4="fiDescMotorista"
        &Frame4="fPage1"
        &EnableImplant="YES"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-matr wMaintenanceNoNavigation
ON LEAVE OF ttApont.cod-matr IN FRAME fPage1 /* cod-matr */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOMoto"
        &KeyValue1="{&ttTable}.ep-codigo-matr:screen-value in frame fPage1"
        &KeyValue2="{&ttTable}.cod-estabel-matr:screen-value in frame fPage1"
        &KeyValue3="{&ttTable}.cod-matr:screen-value in frame fPage1"
        &FieldName1="nom-motoris"
        &FieldScreen1="fiDescMotorista"
        &Frame1="fPage1"}
        
    IF pcAction <> "" AND c-nom-prog-upc-mg97 <> "" THEN
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "leave-cod-matr",
                                        INPUT "",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage0:HANDLE,
                                        INPUT "",
                                        INPUT ?).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.cod-matr IN FRAME fPage1 /* cod-matr */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.cod-posto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-posto wMaintenanceNoNavigation
ON F5 OF ttApont.cod-posto IN FRAME fPage1 /* Posto */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr021.w"
           &FieldZoom1="cod-posto"
           &FieldScreen1="{&ttTable}.cod-posto"
           &Frame1="fPage1"
           &FieldZoom2="des-posto"
           &FieldScreen2="fiDescPosto"
           &Frame2="fPage1"
           &EnableImplant="YES"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-posto wMaintenanceNoNavigation
ON LEAVE OF ttApont.cod-posto IN FRAME fPage1 /* Posto */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOPosto"
        &KeyValue1="{&ttTable}.cod-posto:screen-value in frame fPage1"
        &FieldName1="des-posto"
        &FieldScreen1="fiDescPosto"
        &Frame1="fPage1"}  

    if  (c-nom-prog-upc-mg97 <> "":U) and
        (trim(pcAction) = "ADD":U or trim(pcAction) = "COPY":U or trim(pcAction) = "UPDATE":U) then do:
        /*chama upc da Colombo*/
        ASSIGN i-glob-ep-codigo   = ttApont.ep-codigo:SCREEN-VALUE IN FRAME fPage0
               c-glob-cod-eqpto   = ttApont.cod-eqpto:SCREEN-VALUE IN FRAME fPage0
               c-glob-cod-posto   = ttApont.cod-posto:SCREEN-VALUE IN FRAME fPage1
               c-glob-conta-contabil = fiConta:screen-value in frame fPage1
               c-glob-sub-conta   = fiSub:screen-value in frame fPage1.

        run value(c-nom-prog-upc-mg97) (input "leave-posto",
                                        input "",
                                        input THIS-PROCEDURE,
                                        input FRAME fPage0:HANDLE,
                                        input "",
                                        input ?).

        assign fiConta:SCREEN-VALUE IN FRAME fPage1 = c-glob-conta-contabil
               fiSub:SCREEN-VALUE IN FRAME fPage1 = c-glob-sub-conta.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-posto wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.cod-posto IN FRAME fPage1 /* Posto */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.cod-rota
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-rota wMaintenanceNoNavigation
ON F5 OF ttApont.cod-rota IN FRAME fPage1 /* Trajeto */
DO:
        {method/zoomfields.i 
           &ProgramZoom="frzoom/z01fr028.w"
           &FieldZoom1="cod-rota"
           &FieldScreen1="{&ttTable}.cod-rota"
           &Frame1="fPage1"
           &FieldZoom2="des-trajeto"
           &FieldScreen2="fiDescTrajeto"
           &Frame2="fPage1"
           &EnableImplant="YES"}      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-rota wMaintenanceNoNavigation
ON LEAVE OF ttApont.cod-rota IN FRAME fPage1 /* Trajeto */
DO:
    {method\referenceFields.i
        &HandleDBOLeave="hDBOTraj"
        &KeyValue1="{&ttTable}.cod-rota:screen-value in frame fPage1"
        &FieldName1="des-trajeto"
        &FieldScreen1="fiDescTrajeto"
        &Frame1="fPage1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.cod-rota wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.cod-rota IN FRAME fPage1 /* Trajeto */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.dat-movto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.dat-movto wMaintenanceNoNavigation
ON LEAVE OF ttApont.dat-movto IN FRAME fPage1 /* Data Movimento */
DO:
    IF pcAction <> "UPDATE":U THEN DO:
        RUN piAtividade IN THIS-PROCEDURE.
        /* A Vari†vel "cEstabEqpto" Ç utilizada no leave das contas */
        RUN piBuscaEstabelEqpto IN THIS-PROCEDURE (OUTPUT cEstabEqpto).
    END.

    /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
    IF l-usa-unid-negoc THEN
        RUN piValidaMatriz IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME ttApont.ep-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.ep-codigo wMaintenanceNoNavigation
ON ENTRY OF ttApont.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
    APPLY "leave":U TO ttApont.cod-posto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.ep-codigo wMaintenanceNoNavigation
ON F5 OF ttApont.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
apply "F5":U to ttApont.cod-eqpto in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.ep-codigo wMaintenanceNoNavigation
ON LEAVE OF ttApont.ep-codigo IN FRAME fpage0 /* Empresa */
DO:
  /*ponto de chamada da upc colombo*/
  APPLY "leave":U TO ttApont.cod-posto IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.ep-codigo wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.ep-codigo IN FRAME fpage0 /* Empresa */
OR "F5":U OF ttApont.ep-codigo IN FRAME fPage0 DO:
    apply "F5":U to ttApont.cod-eqpto in frame fPage0.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME ttApont.ep-codigo-matr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.ep-codigo-matr wMaintenanceNoNavigation
ON F5 OF ttApont.ep-codigo-matr IN FRAME fPage1 /* Motorista */
DO:
    APPLY "F5":U TO {&ttTable}.cod-matr IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.ep-codigo-matr wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF ttApont.ep-codigo-matr IN FRAME fPage1 /* Motorista */
DO:
  APPLY "F5":U TO {&ttTable}.cod-matr IN FRAME fPage1.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-unid-negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenanceNoNavigation
ON F5 OF fi-cod-unid-negoc IN FRAME fPage1 /* Unidade Neg¢cio */
DO:
    IF l-usa-unid-negoc THEN
        &IF DEFINED(bf_mnt_ems206b) &THEN
            {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                                 &FieldZoom1=cod-unid-negoc
                                 &FieldScreen1=fi-cod-unid-negoc
                                 &Frame1=fPage1}
        &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenanceNoNavigation
ON LEAVE OF fi-cod-unid-negoc IN FRAME fPage1 /* Unidade Neg¢cio */
DO:
    /** Habilita/Desabilita botao Matriz de Unidade Negocio **/
    IF l-usa-unid-negoc THEN
        RUN piValidaMatriz IN THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-unid-negoc wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fi-cod-unid-negoc IN FRAME fPage1 /* Unidade Neg¢cio */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiConta
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON ENTRY OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
DO:
    ASSIGN fiConta:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON F5 OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
DO:
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo
            dDtMovimento  = INPUT FRAME fPage1 ttApont.dat-movto.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fiConta:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON LEAVE OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
DO:
    ASSIGN dDtMovimento  = INPUT FRAME fPage1 ttApont.dat-movto
           cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo.
                                                
    {cdp/cdunif001a.i  fiConta fiSub fPage1 dDtMovimento cEmpresaEstab cEstabEqpto}

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiConta wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiConta IN FRAME fPage1 /* Conta Abastecimento */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiContaLub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiContaLub wMaintenanceNoNavigation
ON ENTRY OF fiContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
    ASSIGN fiContaLub:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiContaLub wMaintenanceNoNavigation
ON F5 OF fiContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
    IF NOT VALID-HANDLE(h_api_cta_ctbl) OR
        h_api_cta_ctbl:TYPE      <> "PROCEDURE":U OR
        h_api_cta_ctbl:FILE-NAME <> "prgint/utb/utb743za.py":U THEN DO:
        RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.    
    END.
    
    ASSIGN  cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo
            dDtMovimento  = INPUT FRAME fPage1 ttApont.dat-movto.

    RUN pi_zoom_cta_ctbl_integr IN h_api_cta_ctbl (INPUT  cEmpresaEstab,       /* EMPRESA PADR«O DO USUµRIO*/
                                                   INPUT  "CEP",               /* MODULO */                                                  
                                                   INPUT  "",                  /* PLANO DE CONTAS */
                                                   INPUT  v_cod_finalid,       /* FINALIDADES */
                                                   INPUT  dDtMovimento,        /* DATA TRANSACAO */
                                                   OUTPUT v_cod_cta_ctbl,      /* CODIGO CONTA */
                                                   OUTPUT v_des_cta_ctbl,      /* DESCRICAO CONTA */
                                                   OUTPUT v_ind_finalid_cta,   /* FINALIDADE DA CONTA */
                                                   OUTPUT TABLE tt_log_erro).  /* ERROS */
    
    IF v_cod_cta_ctbl <> "" THEN
                ASSIGN fiContaLub:SCREEN-VALUE IN FRAME fPage1 = v_cod_cta_ctbl.
    
    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_cta_ctbl) THEN DO:
        DELETE OBJECT h_api_cta_ctbl.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiContaLub wMaintenanceNoNavigation
ON LEAVE OF fiContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
    ASSIGN dDtMovimento = INPUT FRAME fPage1 ttApont.dat-movto
           cEmpresaEstab = INPUT FRAME fPage0 ttApont.ep-codigo.

    {cdp/cdunif001a.i  fiContaLub fiSubLub fPage1 dDtMovimento cEmpresaEstab cEstabEqpto}

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiContaLub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiContaLub IN FRAME fPage1 /* Conta Lubrificaá∆o */
DO:
  apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON ENTRY OF fiSub IN FRAME fPage1
DO:
  ASSIGN fiSub:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON F5 OF fiSub IN FRAME fPage1
DO:

    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab  = INPUT FRAME fPage0 ttApont.ep-codigo
            dDtMovimento   = INPUT FRAME fPage1 ttApont.dat-movto
            v_cod_cta_ctbl = INPUT FRAME fPage1 fiConta.
                        
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN fiSub:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON LEAVE OF fiSub IN FRAME fPage1
DO:
    IF fiSub:SCREEN-VALUE IN FRAME fPage1 <> "" THEN
        ASSIGN fiSub:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiSub IN FRAME fPage1
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fiSubLub
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSubLub wMaintenanceNoNavigation
ON ENTRY OF fiSubLub IN FRAME fPage1
DO:
    ASSIGN fiSubLub:FORMAT IN FRAME fPage1 = "x(20)".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSubLub wMaintenanceNoNavigation
ON F5 OF fiSubLub IN FRAME fPage1
DO:
    IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    ASSIGN  cEmpresaEstab  = INPUT FRAME fPage0 ttApont.ep-codigo
            dDtMovimento   = INPUT FRAME fPage1 ttApont.dat-movto
            v_cod_cta_ctbl = INPUT FRAME fPage1 fiContaLub.
                        
    RUN pi_zoom_ccusto_x_cta_ctbl IN h_api_ccusto( INPUT cEmpresaEstab,         /*Empresa*/
                                                   INPUT "",                    /*Estabelecimento */
                                                   INPUT YES,                   /*Considera Todos os Estabelecimentos ?*/
                                                   INPUT "",                    /*Unidade de Neg¢cio*/
                                                   INPUT "",                    /*Plano de Contas*/
                                                   INPUT v_cod_cta_ctbl,        /*C¢digo da Conta*/
                                                   INPUT "",                    /*C¢digo do Plano de Centro de Custo*/
                                                   INPUT dDtMovimento,          /*Data da Transaá∆o*/
                                                   OUTPUT v_cod_ccusto,         /*C¢digo CCusto*/
                                                   OUTPUT v_des_ccusto,         /*Descriá∆o CCusto*/
                                                   OUTPUT TABLE tt_log_erro ).  /*Erros*/

    ASSIGN fiSubLub:SCREEN-VALUE IN FRAME fPage1 = v_cod_ccusto.

    /*tratamento de erros*/
    IF CAN-FIND(FIRST tt_log_erro ) THEN DO:
      {cdp/cdunif001b.i}
    END.

    IF VALID-HANDLE(h_api_ccusto) THEN DO:
        DELETE OBJECT h_api_ccusto.
    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSubLub wMaintenanceNoNavigation
ON LEAVE OF fiSubLub IN FRAME fPage1
DO:
    IF fiSubLub:SCREEN-VALUE IN FRAME fPage1 <> "" THEN
        ASSIGN fiSubLub:FORMAT IN FRAME fPage1 = p_cod_format_ccusto.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fiSubLub wMaintenanceNoNavigation
ON MOUSE-SELECT-DBLCLICK OF fiSubLub IN FRAME fPage1
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.hra-final
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.hra-final wMaintenanceNoNavigation
ON LEAVE OF ttApont.hra-final IN FRAME fPage1 /* Hora Final */
DO:
    /** Consiste o hor†rio **/
    assign cHora = {&ttTable}.hra-final:screen-value in frame fPage1.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to {&ttTable}.hra-final in frame fPage1.
        return no-apply.
    end.
    assign {&ttTable}.hra-final:screen-value in frame fPage1 = cHora.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.hra-inicial
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.hra-inicial wMaintenanceNoNavigation
ON LEAVE OF ttApont.hra-inicial IN FRAME fPage1 /* Hora Inicial */
DO:
    /** Consiste o hor†rio **/
    assign cHora = {&ttTable}.hra-inicial:screen-value in frame fPage1.
    run piFormataHorarioSeg (input-output cHora).
    if return-value = "NOK":U then do:
        apply "ENTRY":U to {&ttTable}.hra-inicial in frame fPage1.
        return no-apply.
    end.
    assign {&ttTable}.hra-inicial:screen-value in frame fPage1 = cHora
           {&ttTable}.hra-final:screen-value in frame fPage1   = cHora.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ttApont.nr-nota-fis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ttApont.nr-nota-fis wMaintenanceNoNavigation
ON ANY-KEY OF ttApont.nr-nota-fis IN FRAME fPage1 /* Nota Fiscal */
DO:
    iKey = LASTKEY.
    IF NOT ((iKey >= 48 AND iKey <= 57) OR iKey = 8 OR iKey = 9 OR iKey = 127) THEN DO:
        BELL.
        RETURN NO-APPLY.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wMaintenanceNoNavigation 


/*:T--- L¢gica para inicializaá∆o do programam ---*/
{maintenancenonavigation/mainblock.i}

{&ttTable}.ep-codigo:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
{&ttTable}.cod-eqpto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage0.
{&ttTable}.ep-codigo-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.
{&ttTable}.cod-estabel-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.
{&ttTable}.cod-matr:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.
{&ttTable}.cod-posto:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.
{&ttTable}.cod-ativid:LOAD-MOUSE-POINTER("image/lupa.cur":U)  in frame fPage1.
{&ttTable}.cod-rota:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
fiConta:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
fiSub:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.
fiContaLub:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage1.
fiSubLub:LOAD-MOUSE-POINTER("image/lupa.cur":U)   in frame fPage1.

&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN
        fi-cod-unid-negoc:LOAD-MOUSE-POINTER("image/lupa.cur":U) IN FRAME fPage1.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wMaintenanceNoNavigation 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterDestroyInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) finalizaá∆o do programa
------------------------------------------------------------------------------*/

/** Equipamento **/
if valid-handle(hDBOEqpto) then
    run Destroy in hDBOEqpto.
/** Modelo **/
if valid-handle(hDBOModelo) then
    run Destroy in hDBOModelo.
/** Posto **/
if valid-handle(hDBOPosto) then
    run Destroy in hDBOPosto.
/** Atividade **/
if valid-handle(hDBOAtiv) then
    run Destroy in hDBOAtiv.
/** Motorista **/
if valid-handle(hDBOMoto) then
    run Destroy in hDBOMoto.
/** Trajeto **/
if valid-handle(hDBOTraj) then
    run Destroy in hDBOTraj.
/** Api003a**/
IF  VALID-HANDLE(hDBOApi003a) THEN DO:
    DELETE PROCEDURE hDBOApi003a.
    ASSIGN hDBOApi003a = ?.
END.
/** Historico **/
IF VALID-HANDLE(hDBOHistor) THEN
    RUN Destroy IN hDBOHistor.

{method/showmessage.i3}

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDisplayFields wMaintenanceNoNavigation 
PROCEDURE afterDisplayFields :
/*------------------------------------------------------------------------------
  Purpose:     afterDisplayFields
  Parameters:  <none>
  Notes:       Override (ap¢s) mostrar campos em tela
------------------------------------------------------------------------------*/
    IF  pcAction <> "UPDATE":U THEN DO:
        /** Busca a numeraá∆o do Apontamento **/
        RUN buscaDocumento IN {&hDBOTable} (OUTPUT {&ttTable}.num-docto).
        /** Data Atual **/
        ASSIGN {&ttTable}.dat-movto = TODAY
               {&ttTable}.cod-usuar = c-seg-usuario.
        DISPLAY {&ttTable}.dat-movto
                {&ttTable}.cod-usuar
            WITH FRAME fPage1.
        /** Hora Atual **/
        RUN piMostraHorario IN THIS-PROCEDURE.
    END.
    ASSIGN {&ttTable}.cod-usuar:SENSITIVE IN FRAME fPage1 = NO.
    /** Mostra documento em tela **/
    DISPLAY {&ttTable}.num-docto
        WITH FRAME fPage0.
    
    IF  pcAction <> "ADD":U THEN DO:
        /** C¢digo da Conta Cont†bil **/
        ASSIGN fiConta    = {&ttTable}.ct-codigo
               fiSub      = {&ttTable}.cc-codigo
               fiContaLub = {&ttTable}.cod-cta-ctbl-lubrific
               fiSubLub   = {&ttTable}.cod-ccusto-lubrific.
        DISPLAY fiConta fiSub  fiContaLub fiSubLub
            WITH FRAME fPage1.
    END.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN fi-cod-unid-negoc = {&ttTable}.cod-unid-negoc.

            DISPLAY fi-cod-unid-negoc
                WITH FRAME fPage1.            
        END.        
    &ELSE
        ASSIGN fi-cod-unid-negoc = {&ttTable}.cod_unid_negoc.

        DISPLAY fi-cod-unid-negoc
            WITH FRAME fPage1.
    &ENDIF    

    /** Mostra campos conforme parÉmetros do m¢dulo **/
    RUN piParametros IN THIS-PROCEDURE.

    /** Descriá‰es dos campos **/
    APPLY "LEAVE":U TO {&ttTable}.cod-eqpto   IN FRAME fPage0.
    APPLY "LEAVE":U TO {&ttTable}.cod-matr    IN FRAME fPage1.
    /* apply "LEAVE":U to {&ttTable}.cod-posto   in frame fPage1.  */
    APPLY "LEAVE":U TO {&ttTable}.cod-ativid  IN FRAME fPage1.
    APPLY "LEAVE":U TO {&ttTable}.cod-rota    IN FRAME fPage1.
    /** Seta foco no campo correto **/
    APPLY "ENTRY":U to {&ttTable}.ep-codigo   IN FRAME fPage0.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterEnableFields wMaintenanceNoNavigation 
PROCEDURE afterEnableFields :
/*------------------------------------------------------------------------------
  Purpose:     afterEnableFields
  Parameters:  <none>
  Notes:       Override ap¢s habilitar os campos em tela
------------------------------------------------------------------------------*/
    /** Mostra campos conforme parÉmetros do m¢dulo **/
    RUN piParametros IN THIS-PROCEDURE.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wMaintenanceNoNavigation 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     afterInitializeInterface
  Parameters:  <none>
  Notes:       Override (ap¢s) inicializaá∆o de tela
------------------------------------------------------------------------------*/
/** Busca os formatos da conta e sub-conta **/
EMPTY TEMP-TABLE tt_log_erro.


IF NOT VALID-HANDLE(h_api_cta_ctbl) THEN RUN prgint/utb/utb743za.py PERSISTENT SET h_api_cta_ctbl.  
IF NOT VALID-HANDLE(h_api_ccusto) THEN RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

ASSIGN dDtMovimento = INPUT FRAME fPage1 ttApont.dat-movto.

RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT "",  /* EMPRESA EMS2 */
                                               INPUT "",          /* PLANO CCUSTO */
                                               INPUT dDtMovimento,               /* DATA DE TRANSACAO */
                                               OUTPUT p_cod_format_ccusto,      /* FORMATO CCUSTO */
                                               OUTPUT TABLE tt_log_erro). /* ERROS */


RUN pi_retorna_formato_cta_ctbl IN h_api_cta_ctbl (INPUT "",
                                                   INPUT "",
                                                   INPUT dDtMovimento,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro).

IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.
IF VALID-HANDLE(h_api_ccusto) THEN DELETE OBJECT h_api_ccusto.

assign fiConta:format in frame fPage1                 = p_cod_format_cta_ctbl
       fiSub:format in frame fPage1                   = p_cod_format_ccusto
       fiConta:sensitive in frame fPage1              = yes
       fiSub:sensitive in frame fPage1                = yes
       fiContaLub:FORMAT IN FRAME fPage1              = p_cod_format_cta_ctbl
       fiSubLub:FORMAT IN FRAME fPage1                = p_cod_format_ccusto
       fiContaLub:SENSITIVE IN FRAME fPage1           = YES
       fiSubLub:SENSITIVE IN FRAME fPage1             = YES.

if pcAction = "COPY":U then
    assign {&ttTable}.r-rowid = ?.

/** Mostra campos conforme parÉmetros do m¢dulo **/
run piParametros in this-procedure.

/** Seta foco no campo correto **/
apply "ENTRY":U to {&ttTable}.ep-codigo in frame fPage0.

run piIntegracaoEMS in this-procedure.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN fi-cod-unid-negoc:VISIBLE IN FRAME fPage1 = l-usa-unid-negoc.
&ENDIF

ASSIGN btMatriz:VISIBLE IN FRAME fPage1 = l-usa-unid-negoc.

/** Habilita/Desabilita botao Matriz de Unidade Negocio **/
IF l-usa-unid-negoc THEN
    RUN piValidaMatriz IN THIS-PROCEDURE.

assign v_cod_finalid = {adinc/i05ad049.i 4 1 }                       /* 1 - Consumo       */ 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}  /* 3 - Ordem serviáo */ 
       v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}. /* 5 - M∆o-de-obra   */ 

APPLY "ENTRY":U TO fiConta              IN FRAME fPage1.
APPLY "LEAVE":U TO fiConta              IN FRAME fPage1.
APPLY "ENTRY":U TO fiContaLub           IN FRAME fPage1.
APPLY "LEAVE":U TO fiContaLub           IN FRAME fPage1.
APPLY "ENTRY":U TO fiSubLub             IN FRAME fPage1.
APPLY "LEAVE":U TO fiSubLub             IN FRAME fPage1.
APPLY "ENTRY":U TO ttApont.cod-posto    IN FRAME fPage1.

IF pcAction = "ADD":U THEN
    APPLY "ENTRY":U TO ttApont.ep-codigo IN FRAME fPage0.

FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF mab-param.des-valor = "2" THEN DO:
        ASSIGN fiContaLub:SENSITIVE IN FRAME fPage1 = NO
               fiSubLub:SENSITIVE   IN FRAME fPage1 = NO.
    END.
END.
IF NOT AVAIL mab-param THEN DO:
    ASSIGN fiContaLub:SENSITIVE IN FRAME fPage1 = NO
           fiSubLub:SENSITIVE   IN FRAME fPage1 = NO.
END.


RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wMaintenanceNoNavigation 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     beforeInitializeInterface
  Parameters:  <none>
  Notes:       Override (antes) inicializaá∆o de tela
------------------------------------------------------------------------------*/
/** Inicializaá∆o das DBOs **/
run initializeDBOs in this-procedure.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeSaveFields wMaintenanceNoNavigation 
PROCEDURE beforeSaveFields :
/*------------------------------------------------------------------------------
  Purpose:     beforeSaveFields
  Parameters:  <none>
  Notes:       Override (antes) de salvar dados em tabela
------------------------------------------------------------------------------*/

APPLY "ENTRY":U TO fiConta  IN FRAME fPage1.
APPLY "LEAVE":U TO fiConta  IN FRAME fPage1.

assign {&ttTable}.ct-codigo             = input frame fPage1 fiConta
       {&ttTable}.cc-codigo             = input frame fPage1 fiSub.


FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF mab-param.des-valor = "1" THEN DO:
        APPLY "ENTRY":U TO fiSubLub IN FRAME fPage1.
        APPLY "LEAVE":U TO fiSubLub IN FRAME fPage1.
        assign {&ttTable}.cod-cta-ctbl-lubrific = INPUT FRAME fPage1 fiContaLub
               {&ttTable}.cod-ccusto-lubrific   = INPUT FRAME fPage1 fiSubLub.
    END.
END.

&IF DEFINED(bf_mnt_ems206b) &THEN
    ASSIGN {&ttTable}.cod-unid-negoc = input frame fPage1 fi-cod-unid-negoc.
&ELSE
    ASSIGN {&ttTable}.cod_unid_negoc = input frame fPage1 fi-cod-unid-negoc.
&ENDIF

/** Busca Novamente a numeraá∆o, para n∆o ocorrer chave duplicada **/
if pcAction <> "UPDATE":U then do:
    run buscaDocumento in {&hDBOTable} (output {&ttTable}.num-docto).
    assign {&tttable}.idi-consist = 1
           {&tttable}.idi-integr  = 1
           {&ttTable}.log-consist = no.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE buscaModelo wMaintenanceNoNavigation 
PROCEDURE buscaModelo :
/*------------------------------------------------------------------------------
  Purpose:     buscaModelo
  Parameters:  <none>
  Notes:       Busca o c¢digo do modelo no equipamento
------------------------------------------------------------------------------*/

    {method\referenceFields.i
        &HandleDBOLeave="hDBOEqpto"
        &KeyValue1="input frame fPage0 {&ttTable}.ep-codigo"
        &KeyValue2="input frame fPage0 {&ttTable}.cod-eqpto"
        &FieldName1="cod-model"
        &Variable1="cCodModelo"}
        
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wMaintenanceNoNavigation 
PROCEDURE initializeDBOs :
/*------------------------------------------------------------------------------
  Purpose:     Inicializa as BOs
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    /*--- DBO Equipamento ---*/
    IF NOT VALID-HANDLE(hDBOEqpto) OR
       hDBOEqpto:TYPE <> "PROCEDURE":U OR
       hDBOEqpto:FILE-NAME <> "frbo/bofr007.p":U THEN DO:
        run frbo/bofr007.p persistent set  hDBOEqpto.
    END.
    
    RUN openQueryStatic IN hDBOEqpto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Modelo ---*/
    IF NOT VALID-HANDLE(hDBOModelo) OR
       hDBOModelo:TYPE <> "PROCEDURE":U OR
       hDBOModelo:FILE-NAME <> "frbo/bofr016.p":U THEN DO:
        run frbo/bofr016.p persistent set  hDBOModelo.
    END.
    
    RUN openQueryStatic IN hDBOModelo (INPUT "Main":U) NO-ERROR.

    /*--- DBO Posto  ---*/
    IF NOT VALID-HANDLE(hDBOPosto) OR
       hDBOPosto:TYPE <> "PROCEDURE":U OR
       hDBOPosto:FILE-NAME <> "frbo/bofr021.p":U THEN DO:
        run frbo/bofr021.p persistent set  hDBOPosto.
    END.
    
    RUN openQueryStatic IN hDBOPosto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Atividade  ---*/
    IF NOT VALID-HANDLE(hDBOAtiv) OR
       hDBOAtiv:TYPE <> "PROCEDURE":U OR
       hDBOAtiv:FILE-NAME <> "frbo/bofr001.p":U THEN DO:
        run frbo/bofr001.p persistent set  hDBOAtiv.
    END.
    
    RUN openQueryStatic IN hDBOAtiv (INPUT "Main":U) NO-ERROR.

    /*--- DBO Motorista  ---*/
    IF NOT VALID-HANDLE(hDBOMoto) OR
       hDBOMoto:TYPE <> "PROCEDURE":U OR
       hDBOMoto:FILE-NAME <> "frbo/bofr017.p":U THEN DO:
        run frbo/bofr017.p persistent set  hDBOMoto.
    END.
    
    RUN openQueryStatic IN hDBOMoto (INPUT "Main":U) NO-ERROR.

    /*--- DBO Trajeto  ---*/
    IF NOT VALID-HANDLE(hDBOTraj) OR
       hDBOTraj:TYPE <> "PROCEDURE":U OR
       hDBOTraj:FILE-NAME <> "frbo/bofr028.p":U THEN DO:
        run frbo/bofr028.p persistent set  hDBOTraj.
    END.
    
    RUN openQueryStatic IN hDBOTraj (INPUT "Main":U) NO-ERROR.

    /*--- DBO Hist¢rico Atividade  ---*/
    IF NOT VALID-HANDLE(hDBOHistor)           OR
        hDBOHistor:TYPE      <> "PROCEDURE":U OR
        hDBOHistor:FILE-NAME <> "frbo/bofr013.p":U THEN DO:
        RUN frbo/bofr013.p PERSISTENT SET hDBOHistor.
    END.   
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtividade wMaintenanceNoNavigation 
PROCEDURE piAtividade :
/*------------------------------------------------------------------------------
  Purpose:     piAtividade
  Parameters:  <none>
  Notes:       Busca Atividade e Conta Corrente do hist¢rico Atividade do Eqpto
------------------------------------------------------------------------------*/
DEFINE VARIABLE cCodUnidNegoc AS CHARACTER FORMAT "x(3)"  NO-UNDO.
DEFINE VARIABLE cCodContaLub  AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE cCodCCustoLub AS CHARACTER FORMAT "x(20)" NO-UNDO.
DEFINE VARIABLE cEstabHist  AS CHARACTER NO-UNDO.

/** Busca Atividade e Conta Cont†bil do Hist¢rico Atividade Equipamento **/    
run buscaAtividade in {&hDBOTable} (input  input frame fPage0 {&ttTable}.ep-codigo,
                                    input  input frame fPage0 {&ttTable}.cod-eqpto,
                                    input  input frame fPage1 {&ttTable}.dat-movto,
                                    output {&ttTable}.cod-ativid,
                                    output fiConta,
                                    output fiSub,
                                    output cCodUnidNegoc,
                                    OUTPUT cCodContaLub,
                                    OUTPUT cCodCCustoLub,
                                    OUTPUT cEstabHist).

/** Verifica se Atividade deve ser informada **/
if not({&ttTable}.cod-ativid:sensitive in frame fPage1) then do:
    if return-value = "OK":U then do:
        /** Mostra Campo em tela **/
        display {&ttTable}.cod-ativid
            with frame fPage1.
        apply "LEAVE":U to {&ttTable}.cod-ativid in frame fPage1.
    end.
end.

/** Mostra Campos em tela **/
display fiConta fiSub
    with frame fPage1.

FOR FIRST mab-param WHERE mab-param.cdn-param = 55 NO-LOCK:
    IF mab-param.des-valor = "1" THEN DO:
        ASSIGN fiContaLub = cCodContaLub
               fiSubLub   = cCodCCustoLub.

       DISPLAY fiContaLub fiSubLub
           WITH FRAME fPage1.
    END.
END.


&IF DEFINED(bf_mnt_ems206b) &THEN
    IF l-usa-unid-negoc THEN DO:
        ASSIGN fi-cod-unid-negoc = cCodUnidNegoc.
        
        DISPLAY fi-cod-unid-negoc
            WITH FRAME fPage1.
    END.
&ELSE
    ASSIGN fi-cod-unid-negoc = cCodUnidNegoc.

    DISPLAY fi-cod-unid-negoc
        WITH FRAME fPage1.
&ENDIF

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaEstabelEqpto wMaintenanceNoNavigation 
PROCEDURE piBuscaEstabelEqpto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAM cCodEstabelEqpto LIKE mab-histor-ativid.cod-estabel NO-UNDO.

    ASSIGN cEstabEqpto = "".
    FOR LAST mab-histor-ativid
       WHERE mab-histor-ativid.ep-codigo     = ttApont.ep-codigo:SCREEN-VALUE IN FRAME fPage0
         AND mab-histor-ativid.cod-eqpto     = ttApont.cod-eqpto:SCREEN-VALUE IN FRAME fPage0
         AND mab-histor-ativid.dat-cadastro <= date(ttApont.dat-movto:SCREEN-VALUE IN FRAME fPage1) NO-LOCK:
         ASSIGN cCodEstabelEqpto = mab-histor-ativid.cod-estabel.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHodometro wMaintenanceNoNavigation 
PROCEDURE piHodometro :
/*------------------------------------------------------------------------------
  Purpose:     piHodometro
  Parameters:  <none>
  Notes:       Verifica se hodìmetro est† com valor correto
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-sec-aux AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-texto   AS CHARACTER  NO-UNDO.
/** Atualiza o campo hora invertida. Ser† gravado no 
    formato "AAAAMMDDHHMM" (Ano+Màs+Dia+Hora+Minuto) **/
run converteParaHoraInvertida in {&hDBOTable} (input  string(input frame fPage1 {&ttTable}.dat-movto,"99/99/9999"),
                                               input  input frame fPage1 {&ttTable}.hra-inicial,
                                               output {&ttTable}.val-dat-hora-invrtda).

/** Busca ultimo apontamento para verificar se hodìmetro est† menor **/
run buscaUltimoApontamento in {&hDBOTable} (input {&ttTable}.r-rowid,
                                            input {&ttTable}.val-dat-hora-invrtda,
                                            input input frame fPage0 {&ttTable}.ep-codigo,
                                            input input frame fPage0 {&ttTable}.cod-eqpto,
                                            input input frame fPage1 {&ttTable}.val-hodom-horim,
                                            input input frame fPage1 {&ttTable}.val-hodom-horim-sec,
                                            OUTPUT l-sec-aux).
if return-value = "MENOR":U then do:
    ASSIGN c-texto = "".
    IF l-sec-aux THEN DO:
        {utp/ut-liter.i "Secund†rio"}
        ASSIGN c-texto = RETURN-VALUE.
    END.
    run utp/ut-msgs.p (input "SHOW":U,
                       input 28449,
                       input c-texto).
    if return-value = "NO" then
        return "NOK":U.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracaoEMS wMaintenanceNoNavigation 
PROCEDURE piIntegracaoEMS :
/*------------------------------------------------------------------------------
  Purpose:     piIntegracaoEMS
  Parameters:  <none>
  Notes:       Verifica se o apontamento est† integrado com o almoxarifado.
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-altera AS LOGICAL    NO-UNDO.

if pcAction = "UPDATE":U then do:
    /** Verifica integraá∆o com EMS **/
    run buscaIntegracao in {&hDBOTable}.
    if return-value = "NOK":U then do:
        ASSIGN l-altera = NO.
        FOR FIRST mab-param fields(des-valor cdn-param)
            where mab-param.cdn-param = 44 no-lock:
            ASSIGN l-altera = if mab-param.des-valor = "1" 
                              then yes
                              else no.
        END.
        /** Desabilita Campos em tela para n∆o serem modificados **/
        assign fiConta:sensitive                    in frame fPage1 = no
               fiSub:sensitive                      in frame fPage1 = no
               {&ttTable}.cod-ativid:sensitive      in frame fPage1 = l-altera
               {&ttTable}.ep-codigo:sensitive       in frame fPage0 = no
               {&ttTable}.cod-eqpto:sensitive       in frame fPage0 = no
               {&ttTable}.nr-nota-fis:sensitive     in frame fPage1 = no
               {&ttTable}.serie:sensitive           in frame fPage1 = no
               {&ttTable}.cod-posto:sensitive       in frame fPage1 = no
               {&ttTable}.cod-rota:sensitive        in frame fPage1 = l-altera
               fi-cod-unid-negoc:sensitive          in frame fPage1 = no
               {&ttTable}.ep-codigo-matr:sensitive  in frame fPage1 = l-altera
               {&ttTable}.cod-estabel-matr:SENSITIVE IN frame fPage1 = l-altera
               {&ttTable}.cod-matr:sensitive        in frame fPage1 = l-altera
               {&ttTable}.cod-usuar:sensitive       in frame fPage1 = no
               fiContaLub:SENSITIVE                 IN FRAME fPage1 = NO
               fiSubLub:SENSITIVE                   IN FRAME fPage1 = NO.

        IF l-usa-unid-negoc THEN
            ASSIGN fi-cod-unid-negoc:SENSITIVE IN FRAME fPage1 = NO.

        IF l-altera THEN DO:
            RUN piparametros IN THIS-PROCEDURE.
        END.
        /** Mostra erros em tela **/
        run piMostraErros in this-procedure.
    end.
end.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wMaintenanceNoNavigation 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/

/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in {&hDBOTable} (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in {&hDBOTable}.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraHorario wMaintenanceNoNavigation 
PROCEDURE piMostraHorario :
/*------------------------------------------------------------------------------
  Purpose:     piMostraHorario
  Parameters:  <none>
  Notes:       Busca hora atual e mostra em tela
------------------------------------------------------------------------------*/

/** Busca a hora atual **/
run piFormataSegundoParaHora (input  time,
                              output {&ttTable}.hra-inicial).
run piFormataSegundoParaHora (input  time,
                              output {&ttTable}.hra-final).

disp {&ttTable}.hra-inicial
     {&ttTable}.hra-final
    with frame fPage1.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piParametros wMaintenanceNoNavigation 
PROCEDURE piParametros :
/*------------------------------------------------------------------------------
  Purpose:     piParametros
  Parameters:  <none>
  Notes:       Busca ParÉmetros e habilita/desabilita campos em tela
------------------------------------------------------------------------------*/

assign {&ttTable}.cod-usuar:sensitive in frame fPage1 = no.

for each  mab-param fields(des-valor cdn-param)
    where mab-param.cdn-param >= 7 
    and   mab-param.cdn-param <= 9 no-lock:
    case mab-param.cdn-param:
        /** Motorista **/
        when 7 THEN DO:
            assign {&ttTable}.ep-codigo-matr:sensitive in frame fPage1 = if mab-param.des-valor = "1" 
                                                                   then yes
                                                                   else no.
            ASSIGN {&ttTable}.cod-estabel-matr:sensitive in frame fPage1 = if mab-param.des-valor = "1" 
                                                                   then yes
                                                                   else no.
            ASSIGN {&ttTable}.cod-matr:sensitive in frame fPage1 = if mab-param.des-valor = "1" 
                                                                   then yes
                                                                   else no.
        END.


        /** Atividade **/
        when 8 then 
            assign {&ttTable}.cod-ativid:sensitive in frame fPage1 = if mab-param.des-valor = "1" 
                                                                     then no
                                                                     else yes.
        /** Trajeto **/
        when 9 then
            assign {&ttTable}.cod-rota:sensitive in frame fPage1 = if mab-param.des-valor = "1" 
                                                                      then yes
                                                                      else no.
    end case.
end.

    IF pcAction <> "" AND c-nom-prog-upc-mg97 <> "" THEN
        RUN VALUE(c-nom-prog-upc-mg97) (INPUT "AFTER-PARAMETROS",
                                        INPUT "",
                                        INPUT THIS-PROCEDURE,
                                        INPUT FRAME fpage0:HANDLE,
                                        INPUT "",
                                        INPUT ?).




return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaContadorSec wMaintenanceNoNavigation 
PROCEDURE piValidaContadorSec :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    ASSIGN lLogContSec = NO.
    IF  cCodModelo <> "" THEN DO:
        RUN gotokey IN hDBOEqpto (INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                  INPUT FRAME fPage0 {&ttTable}.cod-eqpto).
        IF  RETURN-VALUE = "OK":U THEN DO:
            RUN getLogField   IN hDBOEqpto (INPUT "log-cont-sec":U,
                                            OUTPUT lLogContSec).
        END.
        IF  lLogContSec THEN DO:
            RUN gotokey IN hDBOModelo (INPUT cCodModelo).
            IF  RETURN-VALUE = "OK":U THEN DO:
                RUN getCharField  IN hDBOModelo (INPUT "cod-livre-1":U,
                                                 OUTPUT cUnModelSec).
                ASSIGN cUnModelSec = SUBSTRING(cUnModelSec, 1, 2).
            END.
        END.
    END.
    
    IF  lLogContSec THEN
        ASSIGN ttApont.val-hodom-horim-sec:SENSITIVE IN FRAME fPage1 = YES
               fiUnSec:SCREEN-VALUE                  IN FRAME fPage1 = cUnModelSec.
    ELSE
        ASSIGN ttApont.val-hodom-horim-sec:SCREEN-VALUE IN FRAME fPage1 = "0,0"
               fiUnSec:SCREEN-VALUE                     IN FRAME fPage1 = ""
               ttApont.val-hodom-horim-sec:SENSITIVE    IN FRAME fPage1 = NO.

        APPLY "ENTRY":U TO ttApont.dat-movto IN FRAME fPage1.
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piValidaMatriz wMaintenanceNoNavigation 
PROCEDURE piValidaMatriz :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE lTemMatriz AS LOGICAL                 NO-UNDO.
DEFINE VARIABLE cUnidNegoc AS CHARACTER FORMAT "x(3)" NO-UNDO.

    &IF DEFINED(bf_mnt_ems206b) &THEN
        RUN piRetornaUnidNegoc IN hDBOHistor (INPUT  INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                              INPUT  INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                                              INPUT  INPUT FRAME fPage1 {&ttTable}.dat-movto,
                                              OUTPUT cUnidNegoc,
                                              OUTPUT lTemMatriz,
                                              OUTPUT TABLE tt-unid-negoc-histor).

        IF lTemMatriz AND cUnidNegoc = INPUT FRAME fPage1 fi-cod-unid-negoc THEN
            ASSIGN btMatriz:SENSITIVE IN FRAME fPage1 = YES.
        ELSE
            ASSIGN btMatriz:SENSITIVE IN FRAME fPage1 = NO.
    &ENDIF

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidaSegurancaEstabelecimento wMaintenanceNoNavigation 
PROCEDURE ValidaSegurancaEstabelecimento :
/*------------------------------------------------------------------------------
  Purpose: ValidaSegurancaEstabelecimento
  Parameters:  <none>
  Notes: 
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM pep-codigo LIKE mab-eqpto.ep-codigo NO-UNDO.
    DEFINE INPUT PARAM pcod-eqpto LIKE mab-eqpto.cod-eqpto NO-UNDO.

    FOR FIRST bfEquipto FIELDS (ep-codigo cod-eqpto cod-estabel)
        WHERE bfEquipto.ep-codigo = pep-codigo
        AND   bfEquipto.cod-eqpto = pcod-eqpto NO-LOCK:
        /* Se o estabelecimento atual do equipamento n∆o se encontra na tt_estab_ems2, o usu†rio n∆o tem permiss∆o para o mesmo,
           sendo assim deve informar que o equipamento n∆o esta cadastrada */
        IF  NOT CAN-FIND(FIRST tt_estab_ems2 WHERE tt_estab_ems2.tta_cod_estab = bfEquipto.cod-estabel NO-LOCK) THEN DO:
            RETURN "NOK":U.
        END.
    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord wMaintenanceNoNavigation 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE VARIABLE deValContAnt   AS DEC        NO-UNDO.
    DEFINE VARIABLE dePerRod       AS DEC        NO-UNDO.
    DEFINE VARIABLE deMaxPer       AS DEC        NO-UNDO.
    DEFINE VARIABLE lUsaContSec    AS LOG        NO-UNDO.
    DEFINE VARIABLE lTemModelxAtiv AS LOG        NO-UNDO.
    DEFINE VARIABLE cMsg1          AS CHAR       NO-UNDO.
    DEFINE VARIABLE cMsg2          AS CHAR       NO-UNDO.
    DEFINE VARIABLE lRetorno       AS LOGICAL    NO-UNDO.
    DEFINE VARIABLE cRetorno       AS CHARACTER  NO-UNDO.


    {utp/ut-liter.i "Atividade"}
    if ttApont.cod-ativid:screen-value in frame fPage1 = "" then do:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 3145,
                           INPUT return-value).
        RETURN "NOK":U.
    END.
    else do:
        /** Atividade deve estar cadastrada **/
        if not can-find(first mab-ativid
                        where mab-ativid.cod-ativid = ttApont.cod-ativid:screen-value in frame fPage1 no-lock) then do:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 56,
                               INPUT return-value).
            RETURN "NOK":U.
        END.
    END.


    IF {&ttTable}.cod-rota:sensitive in frame fPage1 = YES THEN DO:
        IF NOT CAN-FIND(FIRST mab-trajeto
                        WHERE mab-trajeto.cod-rota = {&ttTable}.cod-rota:SCREEN-VALUE IN FRAME fPage1 NO-LOCK)  THEN DO:
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Trajeto_informado_inv†lido" *}
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 17006,
                              INPUT RETURN-VALUE + ".").
            RETURN "NOK":U.
        END.
    END.
    RUN validaAtividade IN hDBOApi003a (INPUT INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                        INPUT INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                                        INPUT INPUT FRAME fPage1 {&ttTable}.cod-ativid,
                                        OUTPUT cRetorno, /* Retorna o modelo*/
                                        OUTPUT lRetorno).
    IF  lRetorno = NO THEN DO:
        RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                            INPUT 32480,
                            INPUT STRING(cRetorno) + '~~' + STRING(INPUT FRAME fPage1 {&ttTable}.cod-ativid)).
        IF  RETURN-VALUE = "NO":U THEN DO:
            RETURN "NOK":U.
        END.
    END.

    /*Chama a Api de c†lculo do km informado > que o permitido*/
    RUN validaQuilometragem  IN hDBOApi003a (INPUT 1,
                                             INPUT INPUT FRAME fPage1 {&ttTable}.val-hodom-horim,
                                             INPUT INPUT FRAME fPage1 {&ttTable}.val-hodom-horim-sec,
                                             INPUT INPUT FRAME fPage0 {&ttTable}.ep-codigo,
                                             INPUT INPUT FRAME fPage0 {&ttTable}.cod-eqpto,
                                             INPUT INPUT FRAME fPage1 {&ttTable}.dat-movto,
                                             INPUT INPUT FRAME fPage1 {&ttTable}.hra-inicial,
                                             INPUT INPUT FRAME fPage1 {&ttTable}.cod-ativid,
                                             OUTPUT deValContAnt,
                                             OUTPUT dePerRod,
                                             OUTPUT deMaxPer).
     /*Mensagem com os dados informados x os dados gravados*/  
    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN retornaLogical IN hDBOApi003a (OUTPUT lUsaContSec,
                                           OUTPUT lTemModelxAtiv).

        IF  lTemModelxAtiv THEN DO:
            {utp/ut-liter.i Validaá∆o_Contra_o_Consumo_Padr∆o_do_Modelo_de_Equipamento_x_Atividade_(AB0104) * }
            ASSIGN cMsg2 = TRIM(RETURN-VALUE).
        END.
        ELSE DO:
            {utp/ut-liter.i Validaá∆o_Contra_o_Consumo_do_Hist¢rico_de_Combust°vel_do_Equipamento * }
            ASSIGN cMsg2 = TRIM(RETURN-VALUE).
        END.

        IF  NOT lUsaContSec THEN DO:
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 30381,
                               INPUT STRING({&ttTable}.ep-codigo,"999") + '~~' + {&ttTable}.cod-eqpto + '~~' + "" + '~~' + 
                                      STRING({&ttTable}.val-hodom-horim,">>,>>>,>>9.99") + '~~' + STRING(deValContAnt,">>,>>>,>>9.99") + '~~' +
                                      STRING(dePerRod,">>,>>>,>>9.99") + '~~' + STRING(deMaxPer,">>,>>>,>>9.99") + '~~' + cMsg2 ).
        END.
        ELSE DO:
            {utp/ut-liter.i Secund†rio * }
            ASSIGN cMsg1 = " " + TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (INPUT "SHOW":U, 
                               INPUT 30381,
                               INPUT STRING({&ttTable}.ep-codigo,"999") + '~~' + {&ttTable}.cod-eqpto + '~~' + cMsg1 + '~~' +
                                      STRING({&ttTable}.val-hodom-horim-sec,">>,>>>,>>9.99") + '~~' + STRING(deValContAnt,">>,>>>,>>9.99") + '~~' +
                                      STRING(dePerRod,">>,>>>,>>9.99") + '~~' + STRING(deMaxPer,">>,>>>,>>9.99") + '~~' + cMsg2 ).
        END.

        IF  RETURN-VALUE = "NO":U THEN
            RETURN "NOK":U.
    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

