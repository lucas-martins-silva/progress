&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
&Scoped-define WINDOW-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS C-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i IM0550PR 2.00.00.007}  /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i IM0550PR MIM}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters:
      <none>

  Output Parameters:
      <none>

  Author: 

  Created: 

------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.             */
/*----------------------------------------------------------------------*/

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
{cdp/cdcfgmat.i}
/* Parameters Definitions ---                                           */
def output param iatraso      as integer no-undo.
def output param isituacao    as integer no-undo.
def output param ddata-ini    as date    no-undo.
def output param ddata-fim    as date    no-undo.
def output param cest-ini     as char    no-undo.
def output param cest-fim     as char    no-undo.
def output param cproc-ini    as char    no-undo.
def output param cproc-fim    as char    no-undo.
def output param iexp-ini     as integer no-undo.
def output param iexp-fim     as integer no-undo.
def output param iitiner-ini  as integer no-undo.
def output param iitiner-fim  as integer no-undo.
def output param ipto-emb-ini as integer no-undo.
def output param ipto-emb-fim as integer no-undo.
def output param ipto-des-ini as integer no-undo.
def output param ipto-des-fim as integer no-undo.
def output param ilocal       as integer no-undo.
def output param igrupo-ini   as integer no-undo.
def output param igrupo-fim   as integer no-undo.
def output param cfam-ini     as char    no-undo.
def output param cfam-fim     as char    no-undo.
def output param citem-ini    as char    no-undo.
def output param citem-fim    as char    no-undo.
&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
    DEFINE OUTPUT PARAMETER iPtoSolicLiIni AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER iPtoSolicLiFim AS INTEGER NO-UNDO.
    DEFINE OUTPUT PARAMETER cLicencImportIni AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER cLicencImportFim AS CHARACTER NO-UNDO.
&ELSE
    def output param cdeclaracao-import-ini as char format "x(20)" no-undo.
    def output param cdeclaracao-import-fim as char format "x(20)" no-undo.
&ENDIF
def output param pok          as logical no-undo.
def input  param h-bocx150b   as handle  no-undo.

/* Local Variable Definitions ---                                       */
DEFINE TEMP-TABLE RowErrors no-undo
                      field i-sequen as int
                      field cd-erro  as int
                      field mensagem as char format "x(255)"
                      field parametros as char format "x(255)" init ""
                      field errortype as char format "x(20)"
                      field errorhelp as char format "x(20)"
                      field errorsubtype as character.
def var hshowmsg as handle no-undo.

&IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
    DEFINE VARIABLE h-12        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-14        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-16        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-18        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE h-20        AS HANDLE     NO-UNDO.
    DEFINE VARIABLE i-seq-erro  AS INTEGER    NO-UNDO.
&ENDIF

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME fPage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RADIO-SET-1 RADIO-SET-2 FILL-IN-1 FILL-IN-2 ~
FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 ~
FILL-IN-10 FILL-IN-11 fiPtoSolicLiIni fiPtoSolicLiFim FILL-IN-12 FILL-IN-13 ~
FILL-IN-14 FILL-IN-15 FILL-IN-16 FILL-IN-17 FILL-IN-18 FILL-IN-19 ~
FILL-IN-20 FILL-IN-21 c-declaracao-import-ini c-declaracao-import-fim ~
fiLicencImportIni fiLicencImportFim btOK btCancel btHelp IMAGE-1 IMAGE-10 ~
IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 IMAGE-17 IMAGE-18 ~
IMAGE-19 IMAGE-2 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-3 IMAGE-4 IMAGE-44 ~
IMAGE-45 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 RECT-5 RECT-6 rtKeys ~
rtToolBar 
&Scoped-Define DISPLAYED-OBJECTS RADIO-SET-1 RADIO-SET-2 FILL-IN-1 ~
FILL-IN-2 FILL-IN-3 FILL-IN-4 FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 ~
FILL-IN-9 FILL-IN-10 FILL-IN-11 fiPtoSolicLiIni fiPtoSolicLiFim FILL-IN-12 ~
FILL-IN-13 FILL-IN-14 FILL-IN-15 FILL-IN-16 FILL-IN-17 FILL-IN-18 ~
FILL-IN-19 FILL-IN-20 FILL-IN-21 c-declaracao-import-ini ~
c-declaracao-import-fim fiLicencImportIni fiLicencImportFim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR C-Win AS WIDGET-HANDLE NO-UNDO.

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

DEFINE VARIABLE c-declaracao-import-fim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-declaracao-import-ini AS CHARACTER FORMAT "X(20)":U 
     LABEL "Declara‡Æo Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88 NO-UNDO.

DEFINE VARIABLE fiLicencImportFim AS CHARACTER FORMAT "X(20)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE fiLicencImportIni AS CHARACTER FORMAT "X(20)":U 
     LABEL "Licenciamento Importa‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-1 AS INTEGER FORMAT ">>>,>>9":U INITIAL 0 
     LABEL "Localiza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-10 AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Itiner rio" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-11 AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-12 AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto de Embarque" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-13 AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-14 AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto de Nacionaliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-15 AS INTEGER FORMAT ">>>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-16 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-17 AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-18 AS CHARACTER FORMAT "X(8)":U 
     LABEL "Fam¡lia" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-19 AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-2 AS DATE FORMAT "99/99/9999":U INITIAL &IF "{&ems_dbtype}":U = "MSS":U &THEN 01/01/1800 &ELSE 01/01/001  &ENDIF 
     LABEL "Data de Chegada" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-20 AS CHARACTER FORMAT "X(16)":U 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-21 AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-3 AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-4 AS CHARACTER FORMAT "X(3)":U 
     LABEL "Estabelecimento" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-5 AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-6 AS CHARACTER FORMAT "X(12)":U 
     LABEL "Processo" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-7 AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-8 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Fornecedor" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE FILL-IN-9 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtoSolicLiFim AS INTEGER FORMAT ">>,>>9":U INITIAL 99999 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE VARIABLE fiPtoSolicLiIni AS INTEGER FORMAT ">>,>>9":U INITIAL 0 
     LABEL "Ponto Solicita LI" 
     VIEW-AS FILL-IN 
     SIZE 6.72 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-1
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-10
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-17
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-18
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-2
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-3
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-4
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE VARIABLE RADIO-SET-1 AS INTEGER INITIAL 3 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Atrasados", 1,
"Adiantados", 2,
"Todos", 3
     SIZE 10.86 BY 2.96 NO-UNDO.

DEFINE VARIABLE RADIO-SET-2 AS INTEGER INITIAL 5 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Embarcado", 1,
"Embarcado Parcial", 2,
"Embarcado Total", 3,
"Encerrado", 4,
"Todos", 5
     SIZE 16 BY 4.92 NO-UNDO.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 13 BY 3.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 18 BY 5.5.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 18.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fPage0
     RADIO-SET-1 AT ROW 3.25 COL 78 NO-LABEL
     RADIO-SET-2 AT ROW 7.5 COL 73 NO-LABEL
     FILL-IN-1 AT ROW 2.25 COL 19 COLON-ALIGNED
     FILL-IN-2 AT ROW 3.25 COL 19 COLON-ALIGNED
     FILL-IN-3 AT ROW 3.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-4 AT ROW 4.25 COL 19 COLON-ALIGNED
     FILL-IN-5 AT ROW 4.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-6 AT ROW 5.25 COL 19 COLON-ALIGNED
     FILL-IN-7 AT ROW 5.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-8 AT ROW 6.25 COL 19 COLON-ALIGNED
     FILL-IN-9 AT ROW 6.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-10 AT ROW 7.25 COL 19 COLON-ALIGNED
     FILL-IN-11 AT ROW 7.25 COL 49 COLON-ALIGNED NO-LABEL
     fiPtoSolicLiIni AT ROW 8.25 COL 19 COLON-ALIGNED
     fiPtoSolicLiFim AT ROW 8.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-12 AT ROW 8.25 COL 19 COLON-ALIGNED
     FILL-IN-13 AT ROW 8.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-14 AT ROW 9.25 COL 19 COLON-ALIGNED
     FILL-IN-15 AT ROW 9.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-16 AT ROW 10.25 COL 19 COLON-ALIGNED
     FILL-IN-17 AT ROW 10.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-18 AT ROW 11.25 COL 19 COLON-ALIGNED
     FILL-IN-19 AT ROW 11.25 COL 49 COLON-ALIGNED NO-LABEL
     FILL-IN-20 AT ROW 12.25 COL 19 COLON-ALIGNED
     FILL-IN-21 AT ROW 12.25 COL 49 COLON-ALIGNED NO-LABEL
     c-declaracao-import-ini AT ROW 13.25 COL 19 COLON-ALIGNED
     c-declaracao-import-fim AT ROW 13.25 COL 49 COLON-ALIGNED NO-LABEL
     fiLicencImportIni AT ROW 14.25 COL 19 COLON-ALIGNED
     fiLicencImportFim AT ROW 14.25 COL 49 COLON-ALIGNED NO-LABEL
     btOK AT ROW 17.75 COL 2
     btCancel AT ROW 17.75 COL 13
     btHelp AT ROW 17.75 COL 80
     IMAGE-1 AT ROW 3.25 COL 43
     IMAGE-10 AT ROW 7.25 COL 47
     IMAGE-11 AT ROW 8.25 COL 43
     IMAGE-12 AT ROW 8.25 COL 47
     IMAGE-13 AT ROW 9.25 COL 43
     IMAGE-14 AT ROW 9.25 COL 47
     IMAGE-15 AT ROW 10.25 COL 43
     IMAGE-16 AT ROW 10.25 COL 47
     IMAGE-17 AT ROW 11.25 COL 43
     IMAGE-18 AT ROW 11.25 COL 47
     IMAGE-19 AT ROW 12.25 COL 43
     IMAGE-2 AT ROW 3.25 COL 47
     IMAGE-20 AT ROW 12.25 COL 47
     IMAGE-21 AT ROW 13.25 COL 43
     IMAGE-22 AT ROW 13.25 COL 47
     IMAGE-3 AT ROW 4.25 COL 43
     IMAGE-4 AT ROW 4.25 COL 47
     IMAGE-44 AT ROW 14.25 COL 43
     IMAGE-45 AT ROW 14.25 COL 47
     IMAGE-5 AT ROW 5.25 COL 43
     IMAGE-6 AT ROW 5.25 COL 47
     IMAGE-7 AT ROW 6.25 COL 43
     IMAGE-8 AT ROW 6.25 COL 47
     IMAGE-9 AT ROW 7.25 COL 43
     RECT-5 AT ROW 3 COL 77
     RECT-6 AT ROW 7 COL 72
     rtKeys AT ROW 1 COL 1
     rtToolBar AT ROW 17.5 COL 1
     "Situa‡Æo:" VIEW-AS TEXT
          SIZE 6.72 BY .88 AT ROW 6.5 COL 73
     "Processos:" VIEW-AS TEXT
          SIZE 7.57 BY .88 AT ROW 2.5 COL 78
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 18
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW C-Win ASSIGN
         HIDDEN             = YES
         TITLE              = "Parƒmetros Consulta Processo Importa‡Æo - 2.00.00.004"
         HEIGHT             = 18
         WIDTH              = 90
         MAX-HEIGHT         = 23.04
         MAX-WIDTH          = 114.29
         VIRTUAL-HEIGHT     = 23.04
         VIRTUAL-WIDTH      = 114.29
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



/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW C-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fPage0
   Custom                                                               */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
THEN C-Win:HIDDEN = no.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME





/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME C-Win
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON END-ERROR OF C-Win /* Parƒmetros Consulta Processo Importa‡Æo - 2.00.00.004 */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL C-Win C-Win
ON WINDOW-CLOSE OF C-Win /* Parƒmetros Consulta Processo Importa‡Æo - 2.00.00.004 */
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel C-Win
ON CHOOSE OF btCancel IN FRAME fPage0 /* Cancelar */
DO: 
    assign pok = no.
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp C-Win
ON CHOOSE OF btHelp IN FRAME fPage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK C-Win
ON CHOOSE OF btOK IN FRAME fPage0 /* OK */
DO:
    assign frame fPage0 
          radio-set-1
          radio-set-2
          fill-in-2
          fill-in-3
          fill-in-4
          fill-in-5
          fill-in-6
          fill-in-7
          fill-in-8
          fill-in-9
          fill-in-10
          fill-in-11
          fill-in-12
          fill-in-13
          fill-in-14
          fill-in-15
          fill-in-1
          fill-in-16
          fill-in-17
          fill-in-18
          fill-in-19
          fill-in-20
          fill-in-21
          &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
              fiPtoSolicLiIni
              fiPtoSolicLiFim
              fiLicencImportIni 
              fiLicencImportFim 
          &ELSE
              c-declaracao-import-ini
              c-declaracao-import-fim
          &ENDIF.


    RUN validateParametros in h-bocx150b (input string(fill-in-2),
                                          input string(fill-in-3),
                                          input fill-in-4,
                                          input fill-in-5,
                                          input fill-in-6,
                                          input fill-in-7,
                                          input string(fill-in-8),
                                          input string(fill-in-9),
                                          input string(fill-in-10),
                                          input string(fill-in-11),
                                          input string(fill-in-12),
                                          input string(fill-in-13),
                                          input string(fill-in-14),
                                          input string(fill-in-15),
                                          input string(fill-in-1),
                                          input string(fill-in-16),
                                          input string(fill-in-17),
                                          input string(fill-in-18),
                                          input string(fill-in-19),
                                          input string(fill-in-20),
                                          input string(fill-in-21),
                                          output table RowErrors).   

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
        IF fiPtoSolicLiIni > fiPtoSolicLiFim THEN DO:
            FIND LAST RowErrors NO-ERROR.
            IF AVAIL RowErrors THEN
                ASSIGN i-seq-erro = RowErrors.i-sequen + 1.
            ELSE 
                ASSIGN i-seq-erro = 1.

            {utp/ut-field.i mgcex itinerario cdn-pto-solic-licenciam-import 1}
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 142,
                               INPUT RETURN-VALUE).
            CREATE RowErrors.
            ASSIGN RowErrors.i-sequen = i-seq-erro
                   RowErrors.cd-erro  = 142
                   RowErrors.mensagem = RETURN-VALUE.
        END.
        IF fiLicencImportIni  > fiLicencImportFim THEN DO:
            FIND LAST RowErrors NO-ERROR.
            IF AVAIL RowErrors THEN
                ASSIGN i-seq-erro = RowErrors.i-sequen + 1.
            ELSE 
                ASSIGN i-seq-erro = 1.

            {utp/ut-liter.i Licenciamento_Importa‡Æo}
            RUN utp/ut-msgs.p (INPUT "msg",
                               INPUT 142,
                               INPUT RETURN-VALUE).
            CREATE RowErrors.
            ASSIGN RowErrors.i-sequen = i-seq-erro
                   RowErrors.cd-erro  = 142
                   RowErrors.mensagem = RETURN-VALUE.
        END.
    &ENDIF

    IF CAN-FIND(FIRST RowErrors) THEN DO:
        IF NOT VALID-HANDLE(hShowMsg) THEN
            RUN utp/ut-show-msgs.w PERSISTENT SET hShowMsg.
        ELSE
            DELETE PROCEDURE hShowMsg.

        RUN showMessages IN hShowMsg (INPUT TABLE RowErrors).

        LEAVE.
    END.
    ELSE DO:
        assign iatraso = radio-set-1
               isituacao = radio-set-2
               ddata-ini = fill-in-2
               ddata-fim = fill-in-3
               cest-ini = fill-in-4
               cest-fim = fill-in-5
               cproc-ini = fill-in-6
               cproc-fim = fill-in-7
               iexp-ini = fill-in-8
               iexp-fim = fill-in-9
               iitiner-ini = fill-in-10
               iitiner-fim = fill-in-11
               ipto-emb-ini = fill-in-12
               ipto-emb-fim = fill-in-13
               ipto-des-ini = fill-in-14
               ipto-des-fim = fill-in-15
               ilocal = fill-in-1
               igrupo-ini = fill-in-16
               igrupo-fim = fill-in-17
               cfam-ini = fill-in-18
               cfam-fim = fill-in-19
               citem-ini = fill-in-20
               citem-fim = fill-in-21
               &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
                   iPtoSolicLiIni = fiPtoSolicLiIni
                   iPtoSolicLiFim = fiPtoSolicLiFim
                   cLicencImportIni  = fiLicencImportIni 
                   cLicencImportFim  = fiLicencImportFim 
               &ELSE
                   cdeclaracao-import-ini = c-declaracao-import-ini
                   cdeclaracao-import-fim = c-declaracao-import-fim
               &ENDIF
               pok                    = yes.

       APPLY "CLOSE":U TO THIS-PROCEDURE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK C-Win 


/* ***************************  Main Block  *************************** */

/* Set CURRENT-WINDOW: this will parent dialog-boxes and frames.        */
ASSIGN CURRENT-WINDOW                = {&WINDOW-NAME} 
       THIS-PROCEDURE:CURRENT-WINDOW = {&WINDOW-NAME}.

/* The CLOSE event can be used from inside or outside the procedure to  */
/* terminate it.                                                        */
ON CLOSE OF THIS-PROCEDURE 
   RUN disable_UI.   

/* Best default for GUI applications is...                              */
PAUSE 0 BEFORE-HIDE.

/* Now enable the interface and wait for the exit condition.            */
/* (NOTE: handle ERROR and END-KEY so cleanup code will always fire.    */
MAIN-BLOCK:
DO ON ERROR   UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK
    ON END-KEY UNDO MAIN-BLOCK, LEAVE MAIN-BLOCK:
    RUN enable_UI.

    &IF "{&BF_MAT_VERSAO_EMS}" >= "2.062"&THEN
        ASSIGN fiPtoSolicLiIni:HIDDEN         IN FRAME fPage0 = NO
               fiPtoSolicLiFim:HIDDEN         IN FRAME fPage0 = NO
               fiLicencImportIni:HIDDEN       IN FRAME fPage0 = NO
               fiLicencImportFim:HIDDEN       IN FRAME fPage0 = NO
               image-44:HIDDEN                IN FRAME fPage0 = NO
               image-45:HIDDEN                IN FRAME fPage0 = NO
               c-declaracao-import-ini:HIDDEN IN FRAME fPage0 = YES 
               c-declaracao-import-fim:HIDDEN IN FRAME fPage0 = YES.

        ASSIGN h-12 = fill-in-12:SIDE-LABEL-HANDLE 
               h-14 = fill-in-14:SIDE-LABEL-HANDLE
               h-16 = fill-in-16:SIDE-LABEL-HANDLE
               h-18 = fill-in-18:SIDE-LABEL-HANDLE
               h-20 = fill-in-20:SIDE-LABEL-HANDLE.

        ASSIGN fill-in-12:ROW IN FRAME fPage0 = 09.25
               fill-in-13:ROW IN FRAME fPage0 = 09.25
               fill-in-14:ROW IN FRAME fPage0 = 10.25
               fill-in-15:ROW IN FRAME fPage0 = 10.25
               fill-in-16:ROW IN FRAME fPage0 = 11.25
               fill-in-17:ROW IN FRAME fPage0 = 11.25
               fill-in-18:ROW IN FRAME fPage0 = 12.25
               fill-in-19:ROW IN FRAME fPage0 = 12.25
               fill-in-20:ROW IN FRAME fPage0 = 13.25
               fill-in-21:ROW IN FRAME fPage0 = 13.25.

        ASSIGN h-12:ROW = 09.25 
               h-14:ROW = 10.25
               h-16:ROW = 11.25
               h-18:ROW = 12.25
               h-20:ROW = 13.25.
    &ELSE
        ASSIGN fiPtoSolicLiIni:HIDDEN         IN FRAME fPage0 = YES
               fiPtoSolicLiFim:HIDDEN         IN FRAME fPage0 = YES
               fiLicencImportIni:HIDDEN       IN FRAME fPage0 = YES
               fiLicencImportFim:HIDDEN       IN FRAME fPage0 = YES
               image-44:HIDDEN                IN FRAME fPage0 = YES
               image-45:HIDDEN                IN FRAME fPage0 = YES
               c-declaracao-import-ini:HIDDEN IN FRAME fPage0 = NO 
               c-declaracao-import-fim:HIDDEN IN FRAME fPage0 = NO.
    &ENDIF

    IF NOT THIS-PROCEDURE:PERSISTENT THEN
        WAIT-FOR CLOSE OF THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI C-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Delete the WINDOW we created */
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(C-Win)
  THEN DELETE WIDGET C-Win.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI C-Win  _DEFAULT-ENABLE
PROCEDURE enable_UI :
/*------------------------------------------------------------------------------
  Purpose:     ENABLE the User Interface
  Parameters:  <none>
  Notes:       Here we display/view/enable the widgets in the
               user-interface.  In addition, OPEN all queries
               associated with each FRAME and BROWSE.
               These statements here are based on the "Other 
               Settings" section of the widget Property Sheets.
------------------------------------------------------------------------------*/
  DISPLAY RADIO-SET-1 RADIO-SET-2 FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 
          FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 FILL-IN-10 
          FILL-IN-11 fiPtoSolicLiIni fiPtoSolicLiFim FILL-IN-12 FILL-IN-13 
          FILL-IN-14 FILL-IN-15 FILL-IN-16 FILL-IN-17 FILL-IN-18 FILL-IN-19 
          FILL-IN-20 FILL-IN-21 c-declaracao-import-ini c-declaracao-import-fim 
          fiLicencImportIni fiLicencImportFim 
      WITH FRAME fPage0 IN WINDOW C-Win.
  ENABLE RADIO-SET-1 RADIO-SET-2 FILL-IN-1 FILL-IN-2 FILL-IN-3 FILL-IN-4 
         FILL-IN-5 FILL-IN-6 FILL-IN-7 FILL-IN-8 FILL-IN-9 FILL-IN-10 
         FILL-IN-11 fiPtoSolicLiIni fiPtoSolicLiFim FILL-IN-12 FILL-IN-13 
         FILL-IN-14 FILL-IN-15 FILL-IN-16 FILL-IN-17 FILL-IN-18 FILL-IN-19 
         FILL-IN-20 FILL-IN-21 c-declaracao-import-ini c-declaracao-import-fim 
         fiLicencImportIni fiLicencImportFim btOK btCancel btHelp IMAGE-1 
         IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 IMAGE-15 IMAGE-16 
         IMAGE-17 IMAGE-18 IMAGE-19 IMAGE-2 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-3 
         IMAGE-4 IMAGE-44 IMAGE-45 IMAGE-5 IMAGE-6 IMAGE-7 IMAGE-8 IMAGE-9 
         RECT-5 RECT-6 rtKeys rtToolBar 
      WITH FRAME fPage0 IN WINDOW C-Win.
  {&OPEN-BROWSERS-IN-QUERY-fPage0}
  VIEW C-Win.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

