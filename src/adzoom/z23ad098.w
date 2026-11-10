&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wZoom 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i Z23AD098 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i Z23AD098 MUT}
&ENDIF

/*:T*******************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
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
&GLOBAL-DEFINE Program           Z23AD098
&GLOBAL-DEFINE Version        2.00.00.004

&GLOBAL-DEFINE InitialPage       1
&GLOBAL-DEFINE FolderLabels      C¢digo,Nome Abrev,CNPJ,Grupo,Matriz,Nome,Inicia com

&GLOBAL-DEFINE Range             NO

&GLOBAL-DEFINE FieldsRangePage1  f-inicial1, ~
                                 f-final1
&GLOBAL-DEFINE FieldsRangePage2  f-inicial2, ~
                                 f-final2
&GLOBAL-DEFINE FieldsRangePage3  f-inicial3, ~
                                 f-final3
&GLOBAL-DEFINE FieldsRangePage4  f-inicial4, ~
                                 f-final4
&GLOBAL-DEFINE FieldsRangePage5  f-inicial5, ~
                                 f-final5
&GLOBAL-DEFINE FieldsRangePage6  f-inicial6, ~
                                 f-final6
&GLOBAL-DEFINE FieldsRangePage7  f-inicial7
&GLOBAL-DEFINE FieldsAnyKeyPage1 NO
&GLOBAL-DEFINE FieldsAnyKeyPage2 NO
&GLOBAL-DEFINE FieldsAnyKeyPage3 NO
&GLOBAL-DEFINE FieldsAnyKeyPage4 NO
&GLOBAL-DEFINE FieldsAnyKeyPage5 NO
&GLOBAL-DEFINE FieldsAnyKeyPage6 NO
&GLOBAL-DEFINE FieldsAnyKeyPage7 NO

&GLOBAL-DEFINE ttTable1          tt-emitente-1
&GLOBAL-DEFINE hDBOTable1        h-boad098-1
&GLOBAL-DEFINE DBOTable1         emitente

&GLOBAL-DEFINE ttTable2          tt-emitente-2
&GLOBAL-DEFINE hDBOTable2        h-boad098-2
&GLOBAL-DEFINE DBOTable2         emitente

&GLOBAL-DEFINE ttTable3          tt-emitente-3
&GLOBAL-DEFINE hDBOTable3        h-boad098-3
&GLOBAL-DEFINE DBOTable3         emitente

&GLOBAL-DEFINE ttTable4          tt-emitente-4
&GLOBAL-DEFINE hDBOTable4        h-boad098-4
&GLOBAL-DEFINE DBOTable4         emitente

&GLOBAL-DEFINE ttTable5          tt-emitente-5
&GLOBAL-DEFINE hDBOTable5        h-boad098-5
&GLOBAL-DEFINE DBOTable5         emitente

&GLOBAL-DEFINE ttTable6          tt-emitente-6
&GLOBAL-DEFINE hDBOTable6        h-boad098-6
&GLOBAL-DEFINE DBOTable6         emitente

&GLOBAL-DEFINE ttTable7          tt-emitente-7
&GLOBAL-DEFINE hDBOTable7        h-boad098-7
&GLOBAL-DEFINE DBOTable7         emitente

&GLOBAL-DEFINE page1Browse       brTable1
&GLOBAL-DEFINE page2Browse       brTable2
&GLOBAL-DEFINE page3Browse       brTable3
&GLOBAL-DEFINE page4Browse       brTable4
&GLOBAL-DEFINE page5Browse       brTable5
&GLOBAL-DEFINE page6Browse       brTable6
&GLOBAL-DEFINE page7Browse       brTable7

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEFINE VARIABLE l-initial AS   LOG.
DEFINE VARIABLE c-cgc     LIKE emitente.cgc.
DEFINE VARIABLE c-form1   LIKE param-global.formato-id-pessoal.
DEFINE VARIABLE c-form2   LIKE param-global.formato-id-federal.
DEFINE VARIABLE h-boin682 AS HANDLE NO-UNDO.

/* Local Variable Definitions (DBOs Handles) --- */
DEFINE VARIABLE {&hDBOTable1} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable2} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable3} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable4} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable5} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable6} AS HANDLE NO-UNDO.
DEFINE VARIABLE {&hDBOTable7} AS HANDLE NO-UNDO.

/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-emitente-1 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.
DEFINE TEMP-TABLE tt-emitente-2 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.
DEFINE TEMP-TABLE tt-emitente-3 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.
DEFINE TEMP-TABLE tt-emitente-4 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.
DEFINE TEMP-TABLE tt-emitente-5 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.
DEFINE TEMP-TABLE tt-emitente-6 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.
DEFINE TEMP-TABLE tt-emitente-7 NO-UNDO
       FIELD r-rowid      AS ROWID
       FIELD cgc          LIKE emitente.cgc
       FIELD cod-emitente LIKE emitente.cod-emitente
       FIELD cod-gr-forn  LIKE emitente.cod-gr-forn
       FIELD identific    LIKE emitente.identific
       FIELD natureza     LIKE emitente.natureza
       FIELD nome-abrev   LIKE emitente.nome-abrev
       FIELD nome-emit    LIKE emitente.nome-emit
       FIELD nome-matriz  LIKE emitente.nome-matriz.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Zoom
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0
&Scoped-define BROWSE-NAME brTable1

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-emitente-1 tt-emitente-2 tt-emitente-3 ~
tt-emitente-4 tt-emitente-5 tt-emitente-6 tt-emitente-7

/* Definitions for BROWSE brTable1                                      */
&Scoped-define FIELDS-IN-QUERY-brTable1 tt-emitente-1.cod-emitente ~
tt-emitente-1.nome-abrev tt-emitente-1.nome-emit ~
if tt-emitente-1.natureza = 1 then    string(tt-emitente-1.cgc , c-form1) else string(tt-emitente-1.cgc , c-form2) @ c-cgc ~
tt-emitente-1.cod-gr-forn tt-emitente-1.nome-matriz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable1 
&Scoped-define QUERY-STRING-brTable1 FOR EACH tt-emitente-1 NO-LOCK ~
    BY tt-emitente-1.cod-emitente ~
       BY tt-emitente-1.nome-abrev
&Scoped-define OPEN-QUERY-brTable1 OPEN QUERY brTable1 FOR EACH tt-emitente-1 NO-LOCK ~
    BY tt-emitente-1.cod-emitente ~
       BY tt-emitente-1.nome-abrev.
&Scoped-define TABLES-IN-QUERY-brTable1 tt-emitente-1
&Scoped-define FIRST-TABLE-IN-QUERY-brTable1 tt-emitente-1


/* Definitions for BROWSE brTable2                                      */
&Scoped-define FIELDS-IN-QUERY-brTable2 tt-emitente-2.nome-abrev ~
tt-emitente-2.nome-emit tt-emitente-2.cod-emitente ~
if tt-emitente-2.natureza = 1 then    string(tt-emitente-2.cgc, c-form1) else    string(tt-emitente-2.cgc,c-form2) @ c-cgc ~
tt-emitente-2.cod-gr-forn tt-emitente-2.nome-matriz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable2 
&Scoped-define QUERY-STRING-brTable2 FOR EACH tt-emitente-2 NO-LOCK ~
    BY tt-emitente-2.nome-abrev ~
       BY tt-emitente-2.cod-emitente
&Scoped-define OPEN-QUERY-brTable2 OPEN QUERY brTable2 FOR EACH tt-emitente-2 NO-LOCK ~
    BY tt-emitente-2.nome-abrev ~
       BY tt-emitente-2.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable2 tt-emitente-2
&Scoped-define FIRST-TABLE-IN-QUERY-brTable2 tt-emitente-2


/* Definitions for BROWSE brTable3                                      */
&Scoped-define FIELDS-IN-QUERY-brTable3 ~
if tt-emitente-3.natureza = 1 then    string(tt-emitente-3.cgc , c-form1) else string(tt-emitente-3.cgc , c-form2) @ c-cgc ~
tt-emitente-3.cod-emitente tt-emitente-3.nome-abrev tt-emitente-3.nome-emit ~
tt-emitente-3.nome-matriz tt-emitente-3.cod-gr-forn 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable3 
&Scoped-define QUERY-STRING-brTable3 FOR EACH tt-emitente-3 NO-LOCK ~
    BY tt-emitente-3.cgc ~
       BY tt-emitente-3.cod-emitente
&Scoped-define OPEN-QUERY-brTable3 OPEN QUERY brTable3 FOR EACH tt-emitente-3 NO-LOCK ~
    BY tt-emitente-3.cgc ~
       BY tt-emitente-3.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable3 tt-emitente-3
&Scoped-define FIRST-TABLE-IN-QUERY-brTable3 tt-emitente-3


/* Definitions for BROWSE brTable4                                      */
&Scoped-define FIELDS-IN-QUERY-brTable4 tt-emitente-4.cod-gr-forn ~
tt-emitente-4.cod-emitente tt-emitente-4.nome-abrev ~
if tt-emitente-4.natureza = 1 then    string(tt-emitente-4.cgc , c-form1) else string(tt-emitente-4.cgc , c-form2) @ c-cgc ~
tt-emitente-4.nome-emit tt-emitente-4.nome-matriz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable4 
&Scoped-define QUERY-STRING-brTable4 FOR EACH tt-emitente-4 NO-LOCK ~
    BY tt-emitente-4.cod-gr-forn ~
       BY tt-emitente-4.cod-emitente
&Scoped-define OPEN-QUERY-brTable4 OPEN QUERY brTable4 FOR EACH tt-emitente-4 NO-LOCK ~
    BY tt-emitente-4.cod-gr-forn ~
       BY tt-emitente-4.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable4 tt-emitente-4
&Scoped-define FIRST-TABLE-IN-QUERY-brTable4 tt-emitente-4


/* Definitions for BROWSE brTable5                                      */
&Scoped-define FIELDS-IN-QUERY-brTable5 tt-emitente-5.nome-matriz ~
tt-emitente-5.cod-emitente tt-emitente-5.nome-abrev ~
if tt-emitente-5.natureza = 1 then    string(tt-emitente-5.cgc , c-form1) else string(tt-emitente-5.cgc , c-form2) @ c-cgc ~
tt-emitente-5.nome-emit tt-emitente-5.cod-gr-forn 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable5 
&Scoped-define QUERY-STRING-brTable5 FOR EACH tt-emitente-5 NO-LOCK ~
    BY tt-emitente-5.nome-matriz ~
       BY tt-emitente-5.cod-emitente
&Scoped-define OPEN-QUERY-brTable5 OPEN QUERY brTable5 FOR EACH tt-emitente-5 NO-LOCK ~
    BY tt-emitente-5.nome-matriz ~
       BY tt-emitente-5.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable5 tt-emitente-5
&Scoped-define FIRST-TABLE-IN-QUERY-brTable5 tt-emitente-5


/* Definitions for BROWSE brTable6                                      */
&Scoped-define FIELDS-IN-QUERY-brTable6 tt-emitente-6.nome-emit ~
tt-emitente-6.nome-abrev tt-emitente-6.cod-emitente ~
if tt-emitente-6.natureza = 1 then    string(tt-emitente-6.cgc , c-form1) else string(tt-emitente-6.cgc , c-form2) @ c-cgc ~
tt-emitente-6.cod-gr-forn tt-emitente-6.nome-matriz 
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable6 
&Scoped-define QUERY-STRING-brTable6 FOR EACH tt-emitente-6 NO-LOCK ~
    BY tt-emitente-6.nome-emit ~
       BY tt-emitente-6.cod-emitente
&Scoped-define OPEN-QUERY-brTable6 OPEN QUERY brTable6 FOR EACH tt-emitente-6 NO-LOCK ~
    BY tt-emitente-6.nome-emit ~
       BY tt-emitente-6.cod-emitente.
&Scoped-define TABLES-IN-QUERY-brTable6 tt-emitente-6
&Scoped-define FIRST-TABLE-IN-QUERY-brTable6 tt-emitente-6


/* Definitions for BROWSE brTable7                                      */
&Scoped-define FIELDS-IN-QUERY-brTable7 tt-emitente-7.nome-emit tt-emitente-7.nome-abrev tt-emitente-7.cod-emitente if tt-emitente-7.natureza = 1 then string(tt-emitente-7.cgc, c-form1) else string(tt-emitente-7.cgc,c-form2) @ c-cgc tt-emitente-7.cod-gr-forn tt-emitente-7.nome-matriz   
&Scoped-define ENABLED-FIELDS-IN-QUERY-brTable7   
&Scoped-define SELF-NAME brTable7
&Scoped-define OPEN-QUERY-brTable7 IF INPUT FRAME fPage7 rs-forma = 1 THEN     OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente-7 NO-LOCK         WHERE tt-emitente-7.nome-emit BEGINS f-inicial7         BY tt-emitente-7.nome-emit. ELSE    OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente-7 NO-LOCK         WHERE tt-emitente-7.nome-abrev BEGINS f-inicial7         BY tt-emitente-7.nome-abrev.
&Scoped-define TABLES-IN-QUERY-brTable7 tt-emitente-7
&Scoped-define FIRST-TABLE-IN-QUERY-brTable7 tt-emitente-7


/* Definitions for FRAME fPage1                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage1 ~
    ~{&OPEN-QUERY-brTable1}

/* Definitions for FRAME fPage2                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage2 ~
    ~{&OPEN-QUERY-brTable2}

/* Definitions for FRAME fPage3                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage3 ~
    ~{&OPEN-QUERY-brTable3}

/* Definitions for FRAME fPage4                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage4 ~
    ~{&OPEN-QUERY-brTable4}

/* Definitions for FRAME fPage5                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage5 ~
    ~{&OPEN-QUERY-brTable5}

/* Definitions for FRAME fPage6                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage6 ~
    ~{&OPEN-QUERY-brTable6}

/* Definitions for FRAME fPage7                                         */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fPage7 ~
    ~{&OPEN-QUERY-brTable7}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar btOK btCancel btHelp 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wZoom AS WIDGET-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btCancel 
     LABEL "Cancelar" 
     SIZE 10 BY 1.

DEFINE BUTTON btHelp 
     LABEL "Ajuda" 
     SIZE 10 BY 1.

DEFINE BUTTON btOK 
     LABEL "OK" 
     SIZE 10 BY 1.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE BUTTON btCheck1 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant1 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-final1 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 99999999 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE f-inicial1 AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-31
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck2 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant2 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-final2 AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88 NO-UNDO.

DEFINE VARIABLE f-inicial2 AS CHARACTER FORMAT "X(12)":U 
     LABEL "Nome Abreviado" 
     VIEW-AS FILL-IN 
     SIZE 13.86 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-33
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck3 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant3 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-final3 AS CHARACTER FORMAT "X(19)":U INITIAL "ZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE f-inicial3 AS CHARACTER FORMAT "X(19)":U 
     LABEL "CNPJ/CPF" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-14
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck4 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant4 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-final4 AS INTEGER FORMAT ">9":U INITIAL 99 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE f-inicial4 AS INTEGER FORMAT ">9":U INITIAL 0 
     LABEL "Grupo" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-35
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck5 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant5 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-final5 AS CHARACTER FORMAT "X(12)":U INITIAL "ZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE f-inicial5 AS CHARACTER FORMAT "X(12)":U 
     LABEL "Matriz" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-37
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck6 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant6 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-final6 AS CHARACTER FORMAT "X(40)":U INITIAL "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE f-inicial6 AS CHARACTER FORMAT "X(40)":U 
     LABEL "Nome" 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-39
     FILENAME "image~\im-fir":U
     SIZE 4 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image~\im-las":U
     SIZE 3 BY .88.

DEFINE BUTTON btCheck7 
     IMAGE-UP FILE "image~\im-sav":U
     IMAGE-INSENSITIVE FILE "image~\ii-sav":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON btImplant7 
     LABEL "Implantar" 
     SIZE 10 BY 1.

DEFINE VARIABLE f-inicial7 AS CHARACTER FORMAT "X(20)":U 
     LABEL "Inicia com" 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE rs-forma AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Nome", 1,
"Nome Abrev.", 2
     SIZE 22.29 BY .88 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY brTable1 FOR 
      tt-emitente-1 SCROLLING.

DEFINE QUERY brTable2 FOR 
      tt-emitente-2 SCROLLING.

DEFINE QUERY brTable3 FOR 
      tt-emitente-3 SCROLLING.

DEFINE QUERY brTable4 FOR 
      tt-emitente-4 SCROLLING.

DEFINE QUERY brTable5 FOR 
      tt-emitente-5 SCROLLING.

DEFINE QUERY brTable6 FOR 
      tt-emitente-6 SCROLLING.

DEFINE QUERY brTable7 FOR 
      tt-emitente-7 SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE brTable1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable1 wZoom _STRUCTURED
  QUERY brTable1 NO-LOCK DISPLAY
      tt-emitente-1.cod-emitente WIDTH 10.43
      tt-emitente-1.nome-abrev WIDTH 15.43
      tt-emitente-1.nome-emit WIDTH 28.43
      if tt-emitente-1.natureza = 1 then
   string(tt-emitente-1.cgc , c-form1) 
else string(tt-emitente-1.cgc , c-form2) @ c-cgc 
           COLUMN-LABEL "CNPJ/CPF" WIDTH 18.43
      tt-emitente-1.cod-gr-forn WIDTH 3.43
      tt-emitente-1.nome-matriz WIDTH 9.14
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable2 wZoom _STRUCTURED
  QUERY brTable2 NO-LOCK DISPLAY
      tt-emitente-2.nome-abrev WIDTH 15.43
      tt-emitente-2.nome-emit
      tt-emitente-2.cod-emitente WIDTH 10.29
      if tt-emitente-2.natureza = 1 then
   string(tt-emitente-2.cgc, c-form1) 
else
   string(tt-emitente-2.cgc,c-form2) @ c-cgc 
           COLUMN-LABEL "CNPJ/CPF" WIDTH 13.43
      tt-emitente-2.cod-gr-forn WIDTH 4.43
      tt-emitente-2.nome-matriz
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable3 wZoom _STRUCTURED
  QUERY brTable3 NO-LOCK DISPLAY
      if tt-emitente-3.natureza = 1 then
   string(tt-emitente-3.cgc , c-form1) 
else string(tt-emitente-3.cgc , c-form2) @ c-cgc 
           COLUMN-LABEL "CNPJ/CPF" WIDTH 17.43
      tt-emitente-3.cod-emitente WIDTH 11.43
      tt-emitente-3.nome-abrev WIDTH 15.43
      tt-emitente-3.nome-emit
      tt-emitente-3.nome-matriz
      tt-emitente-3.cod-gr-forn
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable4 wZoom _STRUCTURED
  QUERY brTable4 NO-LOCK DISPLAY
      tt-emitente-4.cod-gr-forn WIDTH 4.43
      tt-emitente-4.cod-emitente WIDTH 10.43
      tt-emitente-4.nome-abrev WIDTH 15.43
      if tt-emitente-4.natureza = 1 then
   string(tt-emitente-4.cgc , c-form1) 
else string(tt-emitente-4.cgc , c-form2) @ c-cgc 
           COLUMN-LABEL "CNPJ/CPF" WIDTH 19.43
      tt-emitente-4.nome-emit
      tt-emitente-4.nome-matriz
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable5 wZoom _STRUCTURED
  QUERY brTable5 NO-LOCK DISPLAY
      tt-emitente-5.nome-matriz WIDTH 14.43
      tt-emitente-5.cod-emitente WIDTH 9.43
      tt-emitente-5.nome-abrev WIDTH 16.43
      if tt-emitente-5.natureza = 1 then
   string(tt-emitente-5.cgc , c-form1) 
else string(tt-emitente-5.cgc , c-form2) @ c-cgc 
           COLUMN-LABEL "CNPJ/CPF" WIDTH 19.43
      tt-emitente-5.nome-emit WIDTH 23.43
      tt-emitente-5.cod-gr-forn WIDTH 4.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable6 wZoom _STRUCTURED
  QUERY brTable6 NO-LOCK DISPLAY
      tt-emitente-6.nome-emit
      tt-emitente-6.nome-abrev WIDTH 16.29
      tt-emitente-6.cod-emitente
      if tt-emitente-6.natureza = 1 then
   string(tt-emitente-6.cgc , c-form1) 
else string(tt-emitente-6.cgc , c-form2) @ c-cgc 
           COLUMN-LABEL "CNPJ/CPF" WIDTH 18.14
      tt-emitente-6.cod-gr-forn WIDTH 4
      tt-emitente-6.nome-matriz WIDTH 13.72
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.

DEFINE BROWSE brTable7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS brTable7 wZoom _FREEFORM
  QUERY brTable7 NO-LOCK DISPLAY
      tt-emitente-7.nome-emit
    tt-emitente-7.nome-abrev
    tt-emitente-7.cod-emitente
    if tt-emitente-7.natureza = 1 then
        string(tt-emitente-7.cgc, c-form1) 
    else
        string(tt-emitente-7.cgc,c-form2) @ c-cgc 
            COLUMN-LABEL "CNPJ/CPF"
    tt-emitente-7.cod-gr-forn
    tt-emitente-7.nome-matriz
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-ROW-MARKERS SEPARATORS SIZE 82 BY 10.67
         FONT 2.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     btOK AT ROW 16.71 COL 2
     btCancel AT ROW 16.71 COL 13
     btHelp AT ROW 16.71 COL 80
     rtToolBar AT ROW 16.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90 BY 16.98
         FONT 1.

DEFINE FRAME fPage6
     f-inicial6 AT ROW 1.17 COL 12 COLON-ALIGNED
     f-final6 AT ROW 1.17 COL 43.57 COLON-ALIGNED NO-LABEL
     btCheck6 AT ROW 1.17 COL 78.72
     brTable6 AT ROW 2.33 COL 2
     btImplant6 AT ROW 13 COL 2
     IMAGE-39 AT ROW 1.17 COL 36.57
     IMAGE-40 AT ROW 1.17 COL 42.29
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage5
     f-inicial5 AT ROW 1.17 COL 12 COLON-ALIGNED
     f-final5 AT ROW 1.17 COL 35.43 COLON-ALIGNED NO-LABEL
     btCheck5 AT ROW 1.17 COL 78.72
     brTable5 AT ROW 2.33 COL 2
     btImplant5 AT ROW 13 COL 2
     IMAGE-37 AT ROW 1.17 COL 28.57
     IMAGE-38 AT ROW 1.17 COL 34.14
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage4
     f-inicial4 AT ROW 1.17 COL 12 COLON-ALIGNED
     f-final4 AT ROW 1.17 COL 34 COLON-ALIGNED NO-LABEL
     btCheck4 AT ROW 1.17 COL 78.72
     brTable4 AT ROW 2.33 COL 2
     btImplant4 AT ROW 13 COL 2
     IMAGE-35 AT ROW 1.17 COL 18.57
     IMAGE-36 AT ROW 1.17 COL 32.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage3
     f-inicial3 AT ROW 1.17 COL 12 COLON-ALIGNED
     f-final3 AT ROW 1.17 COL 41.14 COLON-ALIGNED NO-LABEL
     btCheck3 AT ROW 1.17 COL 78.72
     brTable3 AT ROW 2.33 COL 2
     btImplant3 AT ROW 13 COL 2
     IMAGE-14 AT ROW 1.17 COL 35.57
     IMAGE-15 AT ROW 1.17 COL 39.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage1
     f-inicial1 AT ROW 1.17 COL 14 COLON-ALIGNED
     f-final1 AT ROW 1.17 COL 34 COLON-ALIGNED NO-LABEL
     btCheck1 AT ROW 1.17 COL 78.72
     brTable1 AT ROW 2.33 COL 2
     btImplant1 AT ROW 13 COL 2
     IMAGE-31 AT ROW 1.17 COL 25.43
     IMAGE-32 AT ROW 1.17 COL 32.72
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage7
     f-inicial7 AT ROW 1.17 COL 12 COLON-ALIGNED HELP
          "Nome abreviado do cliente/fornecedor"
     rs-forma AT ROW 1.17 COL 42.43 NO-LABEL
     btCheck7 AT ROW 1.17 COL 78.72
     brTable7 AT ROW 2.33 COL 2
     btImplant7 AT ROW 13 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.5 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.

DEFINE FRAME fPage2
     f-inicial2 AT ROW 1.17 COL 14 COLON-ALIGNED
     f-final2 AT ROW 1.17 COL 36.14 COLON-ALIGNED NO-LABEL
     btCheck2 AT ROW 1.17 COL 78.72
     brTable2 AT ROW 2.33 COL 2
     btImplant2 AT ROW 13 COL 2
     IMAGE-33 AT ROW 1.17 COL 30.43
     IMAGE-34 AT ROW 1.17 COL 34.86
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 2.45
         SIZE 84.43 BY 13.29
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Zoom
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wZoom ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 17
         WIDTH              = 90
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wZoom 
/* ************************* Included-Libraries *********************** */

{zoom/zoom.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wZoom
  NOT-VISIBLE,,RUN-PERSISTENT                                           */
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE
       FRAME fPage2:FRAME = FRAME fpage0:HANDLE
       FRAME fPage3:FRAME = FRAME fpage0:HANDLE
       FRAME fPage4:FRAME = FRAME fpage0:HANDLE
       FRAME fPage5:FRAME = FRAME fpage0:HANDLE
       FRAME fPage6:FRAME = FRAME fpage0:HANDLE
       FRAME fPage7:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FRAME fPage1
                                                                        */
/* BROWSE-TAB brTable1 btCheck1 fPage1 */
/* SETTINGS FOR FRAME fPage2
                                                                        */
/* BROWSE-TAB brTable2 btCheck2 fPage2 */
/* SETTINGS FOR FRAME fPage3
                                                                        */
/* BROWSE-TAB brTable3 btCheck3 fPage3 */
/* SETTINGS FOR FRAME fPage4
                                                                        */
/* BROWSE-TAB brTable4 btCheck4 fPage4 */
/* SETTINGS FOR FRAME fPage5
                                                                        */
/* BROWSE-TAB brTable5 btCheck5 fPage5 */
/* SETTINGS FOR FRAME fPage6
                                                                        */
/* BROWSE-TAB brTable6 btCheck6 fPage6 */
/* SETTINGS FOR FRAME fPage7
                                                                        */
/* BROWSE-TAB brTable7 btCheck7 fPage7 */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wZoom)
THEN wZoom:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable1
/* Query rebuild information for BROWSE brTable1
     _TblList          = "Temp-Tables.tt-emitente-1"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente-1.cod-emitente|yes,Temp-Tables.tt-emitente-1.nome-abrev|yes"
     _FldNameList[1]   > Temp-Tables.tt-emitente-1.cod-emitente
"tt-emitente-1.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-emitente-1.nome-abrev
"tt-emitente-1.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-emitente-1.nome-emit
"tt-emitente-1.nome-emit" ? ? "character" ? ? ? ? ? ? no ? no no "28.43" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"if tt-emitente-1.natureza = 1 then
   string(tt-emitente-1.cgc , c-form1)
else string(tt-emitente-1.cgc , c-form2) @ c-cgc" ? ? ? ? ? ? ? ? ? no ? no no "18.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-emitente-1.cod-gr-forn
"tt-emitente-1.cod-gr-forn" ? ? "integer" ? ? ? ? ? ? no ? no no "3.43" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.tt-emitente-1.nome-matriz
"tt-emitente-1.nome-matriz" ? ? "character" ? ? ? ? ? ? no ? no no "9.14" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTable1 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable2
/* Query rebuild information for BROWSE brTable2
     _TblList          = "Temp-Tables.tt-emitente-2"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente-2.nome-abrev|yes,Temp-Tables.tt-emitente-2.cod-emitente|yes"
     _FldNameList[1]   > Temp-Tables.tt-emitente-2.nome-abrev
"tt-emitente-2.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" ""
     _FldNameList[2]   = Temp-Tables.tt-emitente-2.nome-emit
     _FldNameList[3]   > Temp-Tables.tt-emitente-2.cod-emitente
"tt-emitente-2.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "10.29" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"if tt-emitente-2.natureza = 1 then
   string(tt-emitente-2.cgc, c-form1)
else
   string(tt-emitente-2.cgc,c-form2) @ c-cgc" ? ? ? ? ? ? ? ? ? no ? no no "13.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-emitente-2.cod-gr-forn
"tt-emitente-2.cod-gr-forn" ? ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" ""
     _FldNameList[6]   = Temp-Tables.tt-emitente-2.nome-matriz
     _Query            is OPENED
*/  /* BROWSE brTable2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable3
/* Query rebuild information for BROWSE brTable3
     _TblList          = "Temp-Tables.tt-emitente-3"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente-3.cgc|yes,Temp-Tables.tt-emitente-3.cod-emitente|yes"
     _FldNameList[1]   > "_<CALC>"
"if tt-emitente-3.natureza = 1 then
   string(tt-emitente-3.cgc , c-form1)
else string(tt-emitente-3.cgc , c-form2) @ c-cgc" ? ? ? ? ? ? ? ? ? no ? no no "17.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-emitente-3.cod-emitente
"tt-emitente-3.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "11.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-emitente-3.nome-abrev
"tt-emitente-3.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" ""
     _FldNameList[4]   = Temp-Tables.tt-emitente-3.nome-emit
     _FldNameList[5]   = Temp-Tables.tt-emitente-3.nome-matriz
     _FldNameList[6]   = Temp-Tables.tt-emitente-3.cod-gr-forn
     _Query            is OPENED
*/  /* BROWSE brTable3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable4
/* Query rebuild information for BROWSE brTable4
     _TblList          = "Temp-Tables.tt-emitente-4"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente-4.cod-gr-forn|yes,Temp-Tables.tt-emitente-4.cod-emitente|yes"
     _FldNameList[1]   > Temp-Tables.tt-emitente-4.cod-gr-forn
"tt-emitente-4.cod-gr-forn" ? ? "integer" ? ? ? ? ? ? no ? no no "4.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-emitente-4.cod-emitente
"tt-emitente-4.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "10.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-emitente-4.nome-abrev
"tt-emitente-4.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "15.43" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"if tt-emitente-4.natureza = 1 then
   string(tt-emitente-4.cgc , c-form1)
else string(tt-emitente-4.cgc , c-form2) @ c-cgc" ? ? ? ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" ""
     _FldNameList[5]   = Temp-Tables.tt-emitente-4.nome-emit
     _FldNameList[6]   = Temp-Tables.tt-emitente-4.nome-matriz
     _Query            is OPENED
*/  /* BROWSE brTable4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable5
/* Query rebuild information for BROWSE brTable5
     _TblList          = "Temp-Tables.tt-emitente-5"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente-5.nome-matriz|yes,Temp-Tables.tt-emitente-5.cod-emitente|yes"
     _FldNameList[1]   > Temp-Tables.tt-emitente-5.nome-matriz
"tt-emitente-5.nome-matriz" ? ? "character" ? ? ? ? ? ? no ? no no "14.43" yes no no "U" "" ""
     _FldNameList[2]   > Temp-Tables.tt-emitente-5.cod-emitente
"tt-emitente-5.cod-emitente" ? ? "integer" ? ? ? ? ? ? no ? no no "9.43" yes no no "U" "" ""
     _FldNameList[3]   > Temp-Tables.tt-emitente-5.nome-abrev
"tt-emitente-5.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "16.43" yes no no "U" "" ""
     _FldNameList[4]   > "_<CALC>"
"if tt-emitente-5.natureza = 1 then
   string(tt-emitente-5.cgc , c-form1)
else string(tt-emitente-5.cgc , c-form2) @ c-cgc" ? ? ? ? ? ? ? ? ? no ? no no "19.43" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-emitente-5.nome-emit
"tt-emitente-5.nome-emit" ? ? "character" ? ? ? ? ? ? no ? no no "23.43" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.tt-emitente-5.cod-gr-forn
"tt-emitente-5.cod-gr-forn" ? ? "integer" ? ? ? ? ? ? no ? no no "4.72" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTable5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable6
/* Query rebuild information for BROWSE brTable6
     _TblList          = "Temp-Tables.tt-emitente-6"
     _Options          = "NO-LOCK"
     _OrdList          = "Temp-Tables.tt-emitente-6.nome-emit|yes,Temp-Tables.tt-emitente-6.cod-emitente|yes"
     _FldNameList[1]   = Temp-Tables.tt-emitente-6.nome-emit
     _FldNameList[2]   > Temp-Tables.tt-emitente-6.nome-abrev
"tt-emitente-6.nome-abrev" ? ? "character" ? ? ? ? ? ? no ? no no "16.29" yes no no "U" "" ""
     _FldNameList[3]   = Temp-Tables.tt-emitente-6.cod-emitente
     _FldNameList[4]   > "_<CALC>"
"if tt-emitente-6.natureza = 1 then
   string(tt-emitente-6.cgc , c-form1)
else string(tt-emitente-6.cgc , c-form2) @ c-cgc" ? ? ? ? ? ? ? ? ? no ? no no "18.14" yes no no "U" "" ""
     _FldNameList[5]   > Temp-Tables.tt-emitente-6.cod-gr-forn
"tt-emitente-6.cod-gr-forn" ? ? "integer" ? ? ? ? ? ? no ? no no "4" yes no no "U" "" ""
     _FldNameList[6]   > Temp-Tables.tt-emitente-6.nome-matriz
"tt-emitente-6.nome-matriz" ? ? "character" ? ? ? ? ? ? no ? no no "13.72" yes no no "U" "" ""
     _Query            is OPENED
*/  /* BROWSE brTable6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE brTable7
/* Query rebuild information for BROWSE brTable7
     _START_FREEFORM
IF INPUT FRAME fPage7 rs-forma = 1 THEN
    OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente-7 NO-LOCK
        WHERE tt-emitente-7.nome-emit BEGINS f-inicial7
        AND   tt-emitente-7.identific <> 1
        BY tt-emitente-7.nome-emit.
ELSE
   OPEN QUERY {&SELF-NAME} FOR EACH tt-emitente-7 NO-LOCK
        WHERE tt-emitente-7.nome-abrev BEGINS f-inicial7
        AND   tt-emitente-7.identific <> 1
        BY tt-emitente-7.nome-abrev.
     _END_FREEFORM
     _Options          = "NO-LOCK"
     _Query            is OPENED
*/  /* BROWSE brTable7 */
&ANALYZE-RESUME

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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage2
/* Query rebuild information for FRAME fPage2
     _Query            is NOT OPENED
*/  /* FRAME fPage2 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage3
/* Query rebuild information for FRAME fPage3
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage3 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage4
/* Query rebuild information for FRAME fPage4
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage4 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage5
/* Query rebuild information for FRAME fPage5
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage5 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage6
/* Query rebuild information for FRAME fPage6
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage6 */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage7
/* Query rebuild information for FRAME fPage7
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage7 */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wZoom
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON END-ERROR OF wZoom
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wZoom wZoom
ON WINDOW-CLOSE OF wZoom
DO:
  /* This event will close the window and terminate the procedure.  */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btCancel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCancel wZoom
ON CHOOSE OF btCancel IN FRAME fpage0 /* Cancelar */
DO:
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btCheck1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck1 wZoom
ON CHOOSE OF btCheck1 IN FRAME fPage1
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 1).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btCheck2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck2 wZoom
ON CHOOSE OF btCheck2 IN FRAME fPage2
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 2).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btCheck3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck3 wZoom
ON CHOOSE OF btCheck3 IN FRAME fPage3
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 3).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btCheck4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck4 wZoom
ON CHOOSE OF btCheck4 IN FRAME fPage4
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 4).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btCheck5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck5 wZoom
ON CHOOSE OF btCheck5 IN FRAME fPage5
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 5).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btCheck6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck6 wZoom
ON CHOOSE OF btCheck6 IN FRAME fPage6
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 6).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btCheck7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btCheck7 wZoom
ON CHOOSE OF btCheck7 IN FRAME fPage7
DO:
  RUN setConstraints IN THIS-PROCEDURE (INPUT 7).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btHelp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btHelp wZoom
ON CHOOSE OF btHelp IN FRAME fpage0 /* Ajuda */
DO:
    {include/ajuda.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME btImplant1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant1 wZoom
ON CHOOSE OF btImplant1 IN FRAME fPage1 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage2
&Scoped-define SELF-NAME btImplant2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant2 wZoom
ON CHOOSE OF btImplant2 IN FRAME fPage2 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="2"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage3
&Scoped-define SELF-NAME btImplant3
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant3 wZoom
ON CHOOSE OF btImplant3 IN FRAME fPage3 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="3"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage4
&Scoped-define SELF-NAME btImplant4
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant4 wZoom
ON CHOOSE OF btImplant4 IN FRAME fPage4 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="4"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage5
&Scoped-define SELF-NAME btImplant5
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant5 wZoom
ON CHOOSE OF btImplant5 IN FRAME fPage5 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="5"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage6
&Scoped-define SELF-NAME btImplant6
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant6 wZoom
ON CHOOSE OF btImplant6 IN FRAME fPage6 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="6"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage7
&Scoped-define SELF-NAME btImplant7
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btImplant7 wZoom
ON CHOOSE OF btImplant7 IN FRAME fPage7 /* Implantar */
DO:
    {zoom/implant.i &ProgramImplant="cdp/cd0401.w"
                    &PageNumber="7"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&Scoped-define SELF-NAME btOK
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btOK wZoom
ON CHOOSE OF btOK IN FRAME fpage0 /* OK */
DO:
    RUN returnValues IN THIS-PROCEDURE.
    
    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME brTable1
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wZoom 


/* ***************************  Main Block  *************************** */

/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{zoom/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDestroyInterface wZoom 
PROCEDURE afterDestroyInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF VALID-HANDLE (h-boin682) THEN DO:
        DELETE PROCEDURE h-boin682.
                         h-boin682 = ?.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wZoom 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    ASSIGN f-inicial1:SENSITIVE     IN FRAME fPage1 = YES
        f-final1:SENSITIVE          IN FRAME fPage1 = YES
        f-inicial2:SENSITIVE        IN FRAME fPage2 = YES
        f-final2:SENSITIVE          IN FRAME fPage2 = YES
        f-inicial3:SENSITIVE        IN FRAME fPage3 = YES
        f-final3:SENSITIVE          IN FRAME fPage3 = YES
        f-inicial4:SENSITIVE        IN FRAME fPage4 = YES
        f-final4:SENSITIVE          IN FRAME fPage4 = YES
        f-inicial5:SENSITIVE        IN FRAME fPage5 = YES
        f-final5:SENSITIVE          IN FRAME fPage5 = YES
        f-inicial6:SENSITIVE        IN FRAME fPage6 = YES
        f-final6:SENSITIVE          IN FRAME fPage6 = YES
        f-inicial7:SENSITIVE        IN FRAME fPage7 = YES
        btCheck1:SENSITIVE          IN FRAME fPage1 = YES
        btCheck2:SENSITIVE          IN FRAME fPage2 = YES
        btCheck3:SENSITIVE          IN FRAME fPage3 = YES
        btCheck4:SENSITIVE          IN FRAME fPage4 = YES
        btCheck5:SENSITIVE          IN FRAME fPage5 = YES
        btCheck6:SENSITIVE          IN FRAME fPage6 = YES
        btCheck7:SENSITIVE          IN FRAME fPage7 = YES
        rs-forma:SENSITIVE          IN FRAME fPage7 = YES
                                             
        f-inicial1:SCREEN-VALUE     IN FRAME fPage1 = string("0")
        f-final1:SCREEN-VALUE       IN FRAME fPage1 = string("999999999")
        f-inicial2:SCREEN-VALUE     IN FRAME fPage2 = ""
        f-final2:SCREEN-VALUE       IN FRAME fPage2 = "ZZZZZZZZZZZZ"
        f-inicial3:SCREEN-VALUE     IN FRAME fPage3 = ""
        f-final3:SCREEN-VALUE       IN FRAME fPage3 = "ZZZZZZZZZZZZZZZZZZZ"
        f-inicial4:SCREEN-VALUE     IN FRAME fPage4 = string("0")
        f-final4:SCREEN-VALUE       IN FRAME fPage4 = string("99")
        f-inicial5:SCREEN-VALUE     IN FRAME fPage5 = ""
        f-final5:SCREEN-VALUE       IN FRAME fPage5 = "ZZZZZZZZZZZZ"
        f-inicial6:SCREEN-VALUE     IN FRAME fPage6 = ""
        f-final6:SCREEN-VALUE       IN FRAME fPage6 = "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"
        f-inicial7:SCREEN-VALUE     IN FRAME fPage7 = "".
    
    APPLY "entry":U TO f-inicial1 IN FRAME fPage1.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wZoom 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    IF NOT VALID-HANDLE(h-boin682) THEN
        RUN inbo/boin682.p PERSISTENT SET h-boin682.
    IF VALID-HANDLE (h-boin682) THEN DO:
            RUN openQueryStatic in h-boin682 (INPUT "Main":U) NO-ERROR.
            RUN findFirst       in h-boin682.
            RUN getCharField    in h-boin682 (INPUT "formato-id-pessoal":U, OUTPUT c-form1).
            RUN getCharField    in h-boin682 (INPUT "formato-id-federal":U, OUTPUT c-form2).
    END.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initializeDBOs wZoom 
PROCEDURE initializeDBOs :
/*:T------------------------------------------------------------------------------
  Purpose:     Inicializa DBOs
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable1}) OR
       {&hDBOTable1}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable1}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:
           {btb/btb008za.i1 adbo/boad098na2.p YES}
           {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable1}}
    END.
    RUN todosEmitentes IN {&hDBOTable1} NO-ERROR.
    RUN setConstraintCodEmitente IN {&hDBOTable1} (INPUT 0, INPUT 999999999) NO-ERROR.

    /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable2}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad098na2.p YES}
        {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable2}}
    END.
    RUN todosEmitentes IN {&hDBOTable2} NO-ERROR.
    RUN setConstraintNomeAbrev IN {&hDBOTable2} (INPUT "", INPUT "ZZZZZZZZZZZZ") NO-ERROR.

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable3}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:
        {btb/btb008za.i1 adbo/boad098na2.p YES}
        {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable3}}
    END.
    RUN todosEmitentes IN {&hDBOTable3} NO-ERROR.
    RUN setConstraintCGC IN {&hDBOTable3} (INPUT "", INPUT c-form1) NO-ERROR.

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable4}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:
           {btb/btb008za.i1 adbo/boad098na2.p YES}
           {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable4}}
    END.
    RUN todosEmitentes IN {&hDBOTable4} NO-ERROR.
    RUN setConstraintGrupo IN {&hDBOTable4} (INPUT 0, INPUT 99) NO-ERROR.

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable5}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:
           {btb/btb008za.i1 adbo/boad098na2.p YES}
           {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable5}}
    END.
    RUN todosEmitentes IN {&hDBOTable5} NO-ERROR.
    RUN setConstraintNomeMatriz IN {&hDBOTable5} (INPUT "", INPUT "ZZZZZZZZZZZZ") NO-ERROR.

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable6}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:

        {btb/btb008za.i1 adbo/boad098na2.p YES}
        {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable6}}
    END.
    RUN todosEmitentes IN {&hDBOTable6} NO-ERROR.
    RUN setConstraintNomeEmitente IN {&hDBOTable6} (INPUT "", INPUT "ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ") NO-ERROR.

        /*:T--- Verifica se o DBO j  est  inicializado ---*/
    IF NOT VALID-HANDLE({&hDBOTable7}) OR
       {&hDBOTable2}:TYPE <> "PROCEDURE":U OR
       {&hDBOTable2}:FILE-NAME <> "adbo/boad098na2.p":U THEN DO:
       
        {btb/btb008za.i1 adbo/boad098na2.p YES}
        {btb/btb008za.i2 adbo/boad098na2.p '' {&hDBOTable7}} 
    END.
    RUN todosEmitentes IN {&hDBOTable7} NO-ERROR.
    RUN setConstraintIniciaCom IN {&hDBOTable7} (INPUT "", INPUT 0) NO-ERROR.

    IF NOT VALID-HANDLE(h-boin682) THEN
        RUN inbo/boin682.p PERSISTENT SET h-boin682.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueries wZoom 
PROCEDURE openQueries :
/*:T------------------------------------------------------------------------------
  Purpose:     Atualiza browsers
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    
    IF l-initial = NO THEN
        ASSIGN rs-forma:SCREEN-VALUE IN FRAME fPage7 = "1"
            l-initial = YES.

    case iConstraintPageNumber:
        when 1 then do:
            {zoom/openqueries.i &Query="CodEmitente"
                                &PageNumber="1"}
        end.
        when 2 then do:
            {zoom/openqueries.i &Query="NomeAbrev"
                                &PageNumber="2"}
        end.
        when 3 then do:
            {zoom/openqueries.i &Query="CGC"
                                &PageNumber="3"}
        end.
        when 4 then do:
            {zoom/openqueries.i &Query="Grupo"
                                &PageNumber="4"}
        end.
        when 5 then do:
            {zoom/openqueries.i &Query="NomeMatriz"
                                &PageNumber="5"}
        end.
        when 6 then do:
            {zoom/openqueries.i &Query="NomeEmitente"
                                &PageNumber="6"}
        end.
        when 7 then do:
            {zoom/openqueries.i &Query="IniciaCom"
                                &PageNumber="7"}
        end.
    end case.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage1 wZoom 
PROCEDURE returnFieldsPage1 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 1
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable1} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable1}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage2 wZoom 
PROCEDURE returnFieldsPage2 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable2} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable2}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage3 wZoom 
PROCEDURE returnFieldsPage3 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable3} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable3}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage4 wZoom 
PROCEDURE returnFieldsPage4 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable4} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable4}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage5 wZoom 
PROCEDURE returnFieldsPage5 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable5} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable5}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage6 wZoom 
PROCEDURE returnFieldsPage6 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable6} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable6}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnFieldsPage7 wZoom 
PROCEDURE returnFieldsPage7 :
/*:T------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos da p gina 2
  Parameters:  recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE  INPUT PARAMETER pcField      AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pcFieldValue AS CHARACTER NO-UNDO.
    
    IF AVAILABLE {&ttTable7} THEN DO:
        CASE pcField:
            WHEN "cod-emitente":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.cod-emitente).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.nome-abrev).
            WHEN "cgc":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.cgc).
            WHEN "cod-gr-forn":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.cod-gr-forn).
            WHEN "nome-matriz":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.nome-matriz).
            WHEN "nome-emit":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.nome-emit).
            WHEN "nome-abrev":U THEN
                ASSIGN pcFieldValue = STRING({&ttTable7}.nome-abrev).
        END CASE.
    END.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraints wZoom 
PROCEDURE setConstraints :
/*:T------------------------------------------------------------------------------
  Purpose:     Seta constraints e atualiza o browse, conforme n£mero da p gina
               passado como parƒmetro
  Parameters:  recebe n£mero da p gina
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pPageNumber AS INTEGER NO-UNDO.
    
    /*:T--- Seta constraints conforme n£mero da p gina ---*/
    CASE pPageNumber:
        WHEN 1 THEN
            /*:T--- Seta Constraints para o DBO Table1 ---*/
            RUN setConstraintCodEmitente IN {&hDBOTable1} (INPUT INPUT FRAME fPage1 f-inicial1,
                                                           INPUT INPUT FRAME fPage1 f-final1).
        WHEN 2 THEN
            /*:T--- Seta Constraints para o DBO Table2 ---*/
            RUN setConstraintNomeAbrev IN {&hDBOTable2} (INPUT INPUT FRAME fPage2 f-inicial2,
                                                         INPUT INPUT FRAME fPage2 f-final2).
        WHEN 3 THEN
            /*:T--- Seta Constraints para o DBO Table3 ---*/
            RUN setConstraintCGC IN {&hDBOTable3} (INPUT INPUT FRAME fPage3 f-inicial3,
                                                   INPUT INPUT FRAME fPage3 f-final3).
        WHEN 4 THEN
            /*:T--- Seta Constraints para o DBO Table4 ---*/
            RUN setConstraintGrupo IN {&hDBOTable4} (INPUT INPUT FRAME fPage4 f-inicial4,
                                                     INPUT INPUT FRAME fPage4 f-final4).
        WHEN 5 THEN
            /*:T--- Seta Constraints para o DBO Table5 ---*/
            RUN setConstraintNomeMatriz IN {&hDBOTable5} (INPUT INPUT FRAME fPage5 f-inicial5,
                                                          INPUT INPUT FRAME fPage5 f-final5).
        WHEN 6 THEN
            /*:T--- Seta Constraints para o DBO Table6 ---*/
            RUN setConstraintNomeEmitente IN {&hDBOTable6} (INPUT INPUT FRAME fPage6 f-inicial6,
                                                            INPUT INPUT FRAME fPage6 f-final6).
        WHEN 7 THEN
            /*:T--- Seta Constraints para o DBO Table7 ---*/
            RUN setConstraintIniciaCom IN {&hDBOTable7} (INPUT INPUT FRAME fPage7 f-inicial7,
                                                         INPUT INPUT FRAME fPage7 rs-forma).
    END CASE.
    
    /*:T--- Seta vari vel iConstraintPageNumber com o n£mero da p gina atual 
          Esta vari vel ‚ utilizada no m‚todo openQueries ---*/
    ASSIGN iConstraintPageNumber = pPageNumber.
    
    /*:T--- Atualiza browse ---*/
    RUN openQueries IN THIS-PROCEDURE.
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

