&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
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
{include/i-prgvrs.i AB0608A 2.00.00.013 } /*** 010013 ***/
{cdp/cdcfgmnt.i}
{cdp/cd9911.i}
&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0608a MAB}
&ENDIF


/********************************************************************************
** Copyright DATASUL S.A. (1999)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0608A
&GLOBAL-DEFINE Version        2.00.00.013

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         NO

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2 fi-estab-ini fi-estab-fim fi-empresa-ini ~
                              fi-empresa-fim fi-equipto-ini fi-equipto-fim fi-hora-ini fi-hora-fim ~
                              fi-grupo-ini fi-grupo-fim fi-modelo-ini fi-modelo-fim fi-docto-ini ~
                              fi-docto-fim fi-posto-ini fi-posto-fim fi-bomba-ini fi-bomba-fim fi-matrl-ini ~
                              fi-matrl-fim fi-periodo-ini fi-periodo-fim fi-item-ini fi-item-fim ~
                              fi-emitente-ini fi-emitente-fim fi-nota-fis-ini fi-nota-fis-fim fi-evento-ini fi-evento-fim ~
                              fi-centro-custo-ini fi-centro-custo-fim fi-comptmento-ini fi-comptmento-fim fi-ativid-ini fi-ativid-fim ~
                              fi-tag-ini fi-tag-fim fi-estabeqpto-ini fi-estabeqpto-fim ~
                              fi-motorista-ini fi-motorista-fim fi-propri-ini fi-propri-fim fi-trajeto-ini fi-trajeto-fim

{abp/ab0608.i} /** Defini‡Æo da ttSelecao **/

/* Parameters Definitions ---                                           */
define input-output parameter table for ttSelecao.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS IMAGE-10 IMAGE-11 IMAGE-12 IMAGE-13 IMAGE-14 ~
IMAGE-15 IMAGE-16 IMAGE-19 IMAGE-20 IMAGE-21 IMAGE-22 IMAGE-23 IMAGE-24 ~
IMAGE-25 IMAGE-26 IMAGE-29 IMAGE-30 IMAGE-31 IMAGE-32 IMAGE-33 IMAGE-34 ~
IMAGE-35 IMAGE-36 IMAGE-37 IMAGE-38 IMAGE-39 IMAGE-40 IMAGE-41 IMAGE-42 ~
IMAGE-43 IMAGE-44 IMAGE-45 IMAGE-46 IMAGE-47 IMAGE-48 IMAGE-5 IMAGE-6 ~
IMAGE-7 IMAGE-8 IMAGE-9 RECT-23 rtToolBar IMAGE-49 IMAGE-50 IMAGE-53 ~
IMAGE-54 IMAGE-55 IMAGE-56 IMAGE-57 IMAGE-58 IMAGE-59 IMAGE-60 ~
fi-periodo-ini fi-periodo-fim fi-hora-ini fi-hora-fim fi-empresa-ini ~
fi-empresa-fim fi-estabeqpto-ini fi-estabeqpto-fim fi-equipto-ini ~
fi-equipto-fim fi-grupo-ini fi-grupo-fim fi-modelo-ini fi-modelo-fim ~
fi-docto-ini fi-docto-fim fi-estab-ini fi-estab-fim fi-posto-ini ~
fi-posto-fim fi-bomba-ini fi-bomba-fim fi-matrl-ini fi-matrl-fim ~
fi-item-ini fi-item-fim fi-emitente-ini fi-emitente-fim fi-nota-fis-ini ~
fi-nota-fis-fim fi-evento-ini fi-evento-fim fi-centro-custo-ini ~
fi-centro-custo-fim fi-comptmento-ini fi-comptmento-fim fi-ativid-ini ~
fi-ativid-fim fi-trajeto-ini fi-trajeto-fim fi-tag-ini fi-tag-fim ~
fi-motorista-ini fi-motorista-fim fi-propri-ini fi-propri-fim ~
fi-unid-negoc-eqpto-ini fi-unid-negoc-eqpto-fim fi-unid-negoc-ficha-ini ~
fi-unid-negoc-ficha-fim btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-periodo-ini fi-periodo-fim fi-hora-ini ~
fi-hora-fim fi-empresa-ini fi-empresa-fim fi-estabeqpto-ini ~
fi-estabeqpto-fim fi-equipto-ini fi-equipto-fim fi-grupo-ini fi-grupo-fim ~
fi-modelo-ini fi-modelo-fim fi-docto-ini fi-docto-fim fi-estab-ini ~
fi-estab-fim fi-posto-ini fi-posto-fim fi-bomba-ini fi-bomba-fim ~
fi-matrl-ini fi-matrl-fim fi-item-ini fi-item-fim fi-emitente-ini ~
fi-emitente-fim fi-nota-fis-ini fi-nota-fis-fim fi-evento-ini fi-evento-fim ~
fi-centro-custo-ini fi-centro-custo-fim fi-comptmento-ini fi-comptmento-fim ~
fi-ativid-ini fi-ativid-fim fi-trajeto-ini fi-trajeto-fim fi-tag-ini ~
fi-tag-fim fi-motorista-ini fi-motorista-fim fi-propri-ini fi-propri-fim ~
fi-unid-negoc-eqpto-ini fi-unid-negoc-eqpto-fim fi-unid-negoc-ficha-ini ~
fi-unid-negoc-ficha-fim 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wWindow AS WIDGET-HANDLE NO-UNDO.

DEFINE VARIABLE v-param-55 AS LOGICAL INITIAL FALSE.

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

DEFINE VARIABLE fi-ativid-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ativid-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Atividade" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-bomba-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-bomba-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Bomba" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-centro-custo-fim AS CHARACTER FORMAT "x(20)" INITIAL "ZZZZZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-centro-custo-ini AS CHARACTER FORMAT "x(20)" 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-comptmento-fim AS CHARACTER FORMAT "x(08)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-comptmento-ini AS CHARACTER FORMAT "x(08)" 
     LABEL "Compartimento" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-docto-fim AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-docto-ini AS INTEGER FORMAT ">>>,>>>,>>9" INITIAL 0 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88.

DEFINE VARIABLE fi-emitente-fim AS INTEGER FORMAT ">>>>>>>>9" INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-emitente-ini AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Fornecedor":R10 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-empresa-fim LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-empresa-ini LIKE empresa.ep-codigo
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-fim AS CHARACTER FORMAT "X(16)":U INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-equipto-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Equipamento" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estab-ini LIKE estabelec.cod-estabel
     LABEL "Estabel Posto":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabeqpto-fim LIKE estabelec.cod-estabel
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estabeqpto-ini LIKE estabelec.cod-estabel
     LABEL "Estabel Eqpto":R15 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-evento-fim AS CHARACTER FORMAT "x(08)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-evento-ini AS CHARACTER FORMAT "x(08)" 
     LABEL "Evento":R8 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88.

DEFINE VARIABLE fi-grupo-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-grupo-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Grupo Eqpto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-fim AS CHARACTER FORMAT "99:99:99":U INITIAL "999999" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-hora-ini AS CHARACTER FORMAT "99:99:99":U INITIAL "000000" 
     LABEL "Hora" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-item-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Item" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-matrl-fim AS CHARACTER FORMAT "x(8)" INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-matrl-ini AS CHARACTER FORMAT "x(8)" 
     LABEL "Material":R11 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modelo-fim AS CHARACTER FORMAT "X(8)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-modelo-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Modelo" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-motorista-fim AS CHARACTER FORMAT "X(10)":U INITIAL "ZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-motorista-ini AS CHARACTER FORMAT "X(10)":U 
     LABEL "Motorista" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nota-fis-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-nota-fis-ini AS CHARACTER FORMAT "x(16)" 
     LABEL "Nota Fiscal":R17 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-periodo-fim AS DATE FORMAT "99/99/9999":U INITIAL 12/31/9999 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-periodo-ini AS DATE FORMAT "99/99/9999":U INITIAL 01/01/1800 
     LABEL "Data" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-posto-fim AS CHARACTER FORMAT "X(08)":U INITIAL "ZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-posto-ini AS CHARACTER FORMAT "X(08)":U 
     LABEL "Posto" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-propri-fim AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 999999999 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-propri-ini AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Propriet rio" 
     VIEW-AS FILL-IN 
     SIZE 9.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-tag-fim AS CHARACTER FORMAT "x(16)" INITIAL "ZZZZZZZZZZZZZZZZ" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-tag-ini AS CHARACTER FORMAT "X(16)":U 
     LABEL "Tag" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE fi-trajeto-fim AS CHARACTER FORMAT "X(8)":U 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-trajeto-ini AS CHARACTER FORMAT "X(8)":U 
     LABEL "Trajeto" 
     VIEW-AS FILL-IN 
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-eqpto-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-eqpto-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Negoc Eqpto" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ficha-fim AS CHARACTER FORMAT "X(3)":U INITIAL "ZZZ" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-unid-negoc-ficha-ini AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid Negoc Ficha" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE IMAGE IMAGE-10
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-11
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-12
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-13
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-14
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-15
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-16
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-19
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-20
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-21
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-22
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-23
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-24
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-25
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-26
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-29
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-30
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-31
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-32
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-33
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-34
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-35
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-36
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-37
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-38
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-39
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-40
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-41
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-42
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-43
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-44
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-45
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-46
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-47
     FILENAME "image\im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-48
     FILENAME "image\im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-49
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-5
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-50
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-53
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-54
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-55
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-56
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-57
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-58
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-59
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-6
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-60
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-7
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-8
     FILENAME "image/im-las":U
     SIZE 3 BY .88.

DEFINE IMAGE IMAGE-9
     FILENAME "image/im-fir":U
     SIZE 3 BY .88.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 69 BY 25.75.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 69 BY 1.42
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-periodo-ini AT ROW 1.5 COL 15 COLON-ALIGNED
     fi-periodo-fim AT ROW 1.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-hora-ini AT ROW 2.5 COL 15 COLON-ALIGNED
     fi-hora-fim AT ROW 2.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-empresa-ini AT ROW 3.5 COL 15 COLON-ALIGNED HELP
          ""
     fi-empresa-fim AT ROW 3.5 COL 45.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-estabeqpto-ini AT ROW 4.5 COL 15 COLON-ALIGNED HELP
          ""
          LABEL "Estabel Eqpto":R15
     fi-estabeqpto-fim AT ROW 4.5 COL 45.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-equipto-ini AT ROW 5.5 COL 15 COLON-ALIGNED
     fi-equipto-fim AT ROW 5.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-grupo-ini AT ROW 6.5 COL 15 COLON-ALIGNED
     fi-grupo-fim AT ROW 6.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-modelo-ini AT ROW 7.5 COL 15 COLON-ALIGNED
     fi-modelo-fim AT ROW 7.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-docto-ini AT ROW 8.5 COL 15 COLON-ALIGNED HELP
          "N£mero do Documento de Abastecimentos/Lubrifica‡äes"
     fi-docto-fim AT ROW 8.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-estab-ini AT ROW 9.5 COL 15 COLON-ALIGNED HELP
          ""
          LABEL "Estabel Posto":R15
     fi-estab-fim AT ROW 9.5 COL 45.72 COLON-ALIGNED HELP
          "" NO-LABEL
     fi-posto-ini AT ROW 10.5 COL 15 COLON-ALIGNED
     fi-posto-fim AT ROW 10.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-bomba-ini AT ROW 11.5 COL 15 COLON-ALIGNED
     fi-bomba-fim AT ROW 11.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-matrl-ini AT ROW 12.5 COL 15 COLON-ALIGNED HELP
          "C¢digo da Atividade"
     fi-matrl-fim AT ROW 12.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo da Atividade" NO-LABEL
     fi-item-ini AT ROW 13.5 COL 15 COLON-ALIGNED HELP
          "C¢digo do Trajeto que o Equipamento est  percorrendo"
     fi-item-fim AT ROW 13.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo do Trajeto que o Equipamento est  percorrendo" NO-LABEL
     fi-emitente-ini AT ROW 14.5 COL 15 COLON-ALIGNED HELP
          "C¢digo do emitente"
     fi-emitente-fim AT ROW 14.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo do emitente" NO-LABEL
     fi-nota-fis-ini AT ROW 15.5 COL 15 COLON-ALIGNED HELP
          "N£mero da nota fiscal"
     fi-nota-fis-fim AT ROW 15.5 COL 45.72 COLON-ALIGNED HELP
          "N£mero da nota fiscal" NO-LABEL
     fi-evento-ini AT ROW 16.5 COL 15 COLON-ALIGNED HELP
          "C¢digo do evento"
     fi-evento-fim AT ROW 16.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo do evento" NO-LABEL
     fi-centro-custo-ini AT ROW 17.5 COL 15 COLON-ALIGNED HELP
          "Centro de Custo"
     fi-centro-custo-fim AT ROW 17.5 COL 45.72 COLON-ALIGNED HELP
          "Centro de Custo" NO-LABEL
     fi-comptmento-ini AT ROW 18.5 COL 15 COLON-ALIGNED HELP
          "Centro de Custo"
     fi-comptmento-fim AT ROW 18.5 COL 45.72 COLON-ALIGNED HELP
          "Centro de Custo" NO-LABEL
     fi-ativid-ini AT ROW 19.5 COL 15 COLON-ALIGNED
     fi-ativid-fim AT ROW 19.5 COL 45.72 COLON-ALIGNED NO-LABEL
     fi-trajeto-ini AT ROW 20.5 COL 15 COLON-ALIGNED WIDGET-ID 2
     fi-trajeto-fim AT ROW 20.5 COL 45.72 COLON-ALIGNED NO-LABEL WIDGET-ID 4
     fi-tag-ini AT ROW 21.5 COL 15 COLON-ALIGNED
     fi-tag-fim AT ROW 21.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo da TAG" NO-LABEL
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.43 BY 27.33
         FONT 1.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME fpage0
     fi-motorista-ini AT ROW 22.5 COL 15 COLON-ALIGNED
     fi-motorista-fim AT ROW 22.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo do motorista" NO-LABEL
     fi-propri-ini AT ROW 23.5 COL 15 COLON-ALIGNED HELP
          "C¢digo do Propriet rio"
     fi-propri-fim AT ROW 23.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo do Propriet rio" NO-LABEL
     fi-unid-negoc-eqpto-ini AT ROW 24.5 COL 15.43 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio"
     fi-unid-negoc-eqpto-fim AT ROW 24.5 COL 45.72 COLON-ALIGNED HELP
          "C¢digo da Unidade de Neg¢cio" NO-LABEL
     fi-unid-negoc-ficha-ini AT ROW 25.5 COL 15.14 COLON-ALIGNED
     fi-unid-negoc-ficha-fim AT ROW 25.5 COL 45.72 COLON-ALIGNED NO-LABEL
     btOK AT ROW 27.04 COL 2
     btCancel AT ROW 27.04 COL 13
     btHelp2 AT ROW 27.04 COL 59
     IMAGE-10 AT ROW 9.5 COL 42.72
     IMAGE-11 AT ROW 5.5 COL 42.72
     IMAGE-12 AT ROW 5.5 COL 37.72
     IMAGE-13 AT ROW 7.5 COL 42.72
     IMAGE-14 AT ROW 7.5 COL 37.72
     IMAGE-15 AT ROW 8.5 COL 37.72
     IMAGE-16 AT ROW 8.5 COL 42.72
     IMAGE-19 AT ROW 10.5 COL 42.72
     IMAGE-20 AT ROW 10.5 COL 37.72
     IMAGE-21 AT ROW 1.5 COL 42.72
     IMAGE-22 AT ROW 1.5 COL 37.72
     IMAGE-23 AT ROW 11.5 COL 42.72
     IMAGE-24 AT ROW 11.5 COL 37.72
     IMAGE-25 AT ROW 12.5 COL 42.72
     IMAGE-26 AT ROW 12.5 COL 37.72
     IMAGE-29 AT ROW 6.5 COL 42.72
     IMAGE-30 AT ROW 6.5 COL 37.72
     IMAGE-31 AT ROW 13.5 COL 42.72
     IMAGE-32 AT ROW 13.5 COL 37.72
     IMAGE-33 AT ROW 14.5 COL 37.72
     IMAGE-34 AT ROW 15.5 COL 37.72
     IMAGE-35 AT ROW 14.5 COL 42.72
     IMAGE-36 AT ROW 15.5 COL 42.72
     IMAGE-37 AT ROW 16.5 COL 37.72
     IMAGE-38 AT ROW 16.5 COL 42.72
     IMAGE-39 AT ROW 17.5 COL 37.72
     IMAGE-40 AT ROW 17.5 COL 42.72
     IMAGE-41 AT ROW 18.5 COL 37.72
     IMAGE-42 AT ROW 18.5 COL 42.72
     IMAGE-43 AT ROW 19.5 COL 37.72
     IMAGE-44 AT ROW 19.5 COL 42.72
     IMAGE-45 AT ROW 20.5 COL 37.72
     IMAGE-46 AT ROW 20.5 COL 42.72
     IMAGE-47 AT ROW 4.5 COL 42.72
     IMAGE-48 AT ROW 4.5 COL 37.72
     IMAGE-5 AT ROW 2.5 COL 37.72
     IMAGE-6 AT ROW 2.5 COL 42.72
     IMAGE-7 AT ROW 3.5 COL 37.72
     IMAGE-8 AT ROW 3.5 COL 42.72
     IMAGE-9 AT ROW 9.5 COL 37.72
     RECT-23 AT ROW 1 COL 1
     rtToolBar AT ROW 26.83 COL 1
     IMAGE-49 AT ROW 21.5 COL 37.72
     IMAGE-50 AT ROW 21.5 COL 42.72
     IMAGE-53 AT ROW 22.5 COL 37.72
     IMAGE-54 AT ROW 22.5 COL 42.72
     IMAGE-55 AT ROW 23.5 COL 37.72
     IMAGE-56 AT ROW 23.5 COL 42.72
     IMAGE-57 AT ROW 24.5 COL 37.72
     IMAGE-58 AT ROW 24.5 COL 42.72
     IMAGE-59 AT ROW 25.5 COL 37.72 WIDGET-ID 6
     IMAGE-60 AT ROW 25.5 COL 42.72 WIDGET-ID 8
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 69.43 BY 27.33
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wWindow ASSIGN
         HIDDEN             = YES
         TITLE              = ""
         HEIGHT             = 27.33
         WIDTH              = 69
         MAX-HEIGHT         = 28.08
         MAX-WIDTH          = 74.86
         VIRTUAL-HEIGHT     = 28.08
         VIRTUAL-WIDTH      = 74.86
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
   FRAME-NAME L-To-R                                                    */
/* SETTINGS FOR FILL-IN fi-empresa-fim IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo                                     */
/* SETTINGS FOR FILL-IN fi-empresa-ini IN FRAME fpage0
   LIKE = ems2cad.empresa.ep-codigo EXP-SIZE                            */
/* SETTINGS FOR FILL-IN fi-estab-fim IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estab-ini IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL EXP-SIZE              */
/* SETTINGS FOR FILL-IN fi-estabeqpto-fim IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel                                 */
/* SETTINGS FOR FILL-IN fi-estabeqpto-ini IN FRAME fpage0
   LIKE = ems2cad.estabelec.cod-estabel EXP-LABEL                       */
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

 
/* ************************ IRM01380 ********************************* */

ASSIGN v-param-55 = FALSE.
FOR FIRST mab-param
    WHERE mab-param.cdn-param = 55 AND mab-param.des-valor = "1":U NO-LOCK:
    ASSIGN v-param-55 = TRUE.
END.

IF v-param-55 THEN DO:
    /* Inicio -- Projeto Internacional */
    DEFINE VARIABLE c-lbl-liter-revisao-2 AS CHARACTER NO-UNDO.
    {utp/ut-liter.i "Centro_Custo_Item" *}
    ASSIGN c-lbl-liter-revisao-2 = TRIM(RETURN-VALUE).

    ASSIGN fi-centro-custo-ini:LABEL IN FRAME fpage0 = c-lbl-liter-revisao-2.
END.

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
    run piGrava in this-procedure.  
    apply "CLOSE":U to this-procedure.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


ASSIGN     fi-periodo-ini     = today - 7
           fi-periodo-fim     = today .

ASSIGN fi-empresa-ini = &IF "{&mguni_version}" >= "2.071" &THEN "":U &ELSE 0 &ENDIF
       fi-empresa-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZ":U &ELSE 999 &ENDIF.

ASSIGN fi-estabeqpto-fim = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF
       fi-estab-fim      = &IF "{&mguni_version}" >= "2.071" &THEN "ZZZZZ":U &ELSE "ZZZ":U &ENDIF.


/*--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterInitializeInterface wWindow 
PROCEDURE afterInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

ASSIGN fi-unid-negoc-eqpto-ini:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-eqpto-ini:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-eqpto-fim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-eqpto-fim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-57:VISIBLE                  IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-58:VISIBLE                  IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ficha-ini:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ficha-ini:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ficha-fim:VISIBLE   IN FRAME fPage0 = l-usa-unid-negoc
       fi-unid-negoc-ficha-fim:SENSITIVE IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-59:VISIBLE                  IN FRAME fPage0 = l-usa-unid-negoc
       IMAGE-60:VISIBLE                  IN FRAME fPage0 = l-usa-unid-negoc.

do with frame fPage0:
find first ttSelecao no-lock no-error.
    if avail ttSelecao then do:
        assign fi-empresa-ini:screen-value      = string(ttSelecao.empresa-ini) 
               fi-empresa-fim:screen-value      = string(ttSelecao.empresa-fim) 
               fi-equipto-ini:screen-value      = ttSelecao.equipto-ini 
               fi-equipto-fim:screen-value      = ttSelecao.equipto-fim 
               fi-grupo-ini:screen-value        = ttSelecao.grupo-ini   
               fi-grupo-fim:screen-value        = ttSelecao.grupo-fim   
               fi-modelo-ini:screen-value       = ttSelecao.modelo-ini  
               fi-modelo-fim:screen-value       = ttSelecao.modelo-fim  
               fi-estab-ini:screen-value        = ttSelecao.estab-ini   
               fi-estab-fim:screen-value        = ttSelecao.estab-fim   
               fi-estabeqpto-ini:screen-value   = ttSelecao.estabeqpto-ini   
               fi-estabeqpto-fim:screen-value   = ttSelecao.estabeqpto-fim   
               fi-hora-ini:screen-value         = ttSelecao.hora-ini    
               fi-hora-fim:screen-value         = ttSelecao.hora-fim    
               fi-docto-ini:screen-value        = string(ttSelecao.docto-ini)   
               fi-docto-fim:screen-value        = string(ttSelecao.docto-fim)  
               fi-posto-ini:screen-value        = ttSelecao.posto-ini   
               fi-posto-fim:screen-value        = ttSelecao.posto-fim   
               fi-bomba-ini:screen-value        = ttSelecao.bomba-ini   
               fi-bomba-fim:screen-value        = ttSelecao.bomba-fim   
               fi-matrl-ini:screen-value        = ttSelecao.matrl-ini   
               fi-matrl-fim:screen-value        = ttSelecao.matrl-fim   
               fi-periodo-ini:screen-value      = string(ttSelecao.periodo-ini) 
               fi-periodo-fim:screen-value      = string(ttSelecao.periodo-fim) 
               fi-item-ini:screen-value         = ttSelecao.item-ini
               fi-item-fim:screen-value         = ttSelecao.item-fim
               fi-emitente-ini:screen-value     = string(ttSelecao.emitente-ini)
               fi-emitente-fim:screen-value     = string(ttSelecao.emitente-fim)
               fi-nota-fis-ini:screen-value     = ttSelecao.nota-ini    
               fi-nota-fis-fim:screen-value     = ttSelecao.nota-fim
               fi-evento-ini:screen-value       = ttSelecao.evento-ini    
               fi-evento-fim:screen-value       = ttSelecao.evento-fim
               fi-centro-custo-ini:screen-value = ttSelecao.ccusto-ini-item
               fi-centro-custo-fim:screen-value = ttSelecao.ccusto-fim-item
               fi-comptmento-ini:screen-value   = ttSelecao.comptmento-ini
               fi-comptmento-fim:screen-value   = ttSelecao.comptmento-fim
               fi-ativid-ini:screen-value       = ttSelecao.cod-ativid-ini
               fi-ativid-fim:screen-value       = ttSelecao.cod-ativid-fim
               fi-tag-ini:screen-value          = ttSelecao.cod-tag-ini
               fi-tag-fim:screen-value          = ttSelecao.cod-tag-fim
               fi-motorista-ini:SCREEN-VALUE    = ttSelecao.cod-motorista-ini 
               fi-motorista-fim:SCREEN-VALUE    = ttSelecao.cod-motorista-fim
               fi-propri-ini:screen-value       = string(ttSelecao.cod-emitente-ini)  
               fi-propri-fim:screen-value       = string(ttSelecao.cod-emitente-fim)
               fi-trajeto-ini:SCREEN-VALUE      = ttSelecao.trajeto-ini
               fi-trajeto-fim:SCREEN-VALUE      = ttSelecao.trajeto-fim.

        &IF DEFINED(bf_mnt_ems206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN fi-unid-negoc-eqpto-ini:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-eqpto-ini
                       fi-unid-negoc-eqpto-fim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-eqpto-fim
                       fi-unid-negoc-ficha-ini:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-ficha-ini
                       fi-unid-negoc-ficha-fim:SCREEN-VALUE IN FRAME fPage0 = ttSelecao.cod-unid-negoc-ficha-fim.                      
            END.
        &ENDIF
    END.
END.
RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piGrava wWindow 
PROCEDURE piGrava :
/*------------------------------------------------------------------------------
  Purpose:     piGrava
  Parameters:  <none>
  Notes:       Grava os dados de tela na temp-table 
------------------------------------------------------------------------------*/
find first ttSelecao exclusive-lock no-error.
if avail ttSelecao then do:
    assign &IF "{&mguni_version}" >= "2.071" &THEN
           ttSelecao.empresa-ini        =  fi-empresa-ini:screen-value in frame fPage0
           ttSelecao.empresa-fim        =  fi-empresa-fim:screen-value in frame fPage0
           &ELSE
           ttSelecao.empresa-ini        =  int(fi-empresa-ini:screen-value in frame fPage0)    
           ttSelecao.empresa-fim        =  int(fi-empresa-fim:screen-value in frame fPage0)    
           &ENDIF
           ttSelecao.equipto-ini        =  fi-equipto-ini:screen-value in frame fPage0    
           ttSelecao.equipto-fim        =  fi-equipto-fim:screen-value in frame fPage0    
           ttSelecao.grupo-ini          =  fi-grupo-ini:screen-value in frame fPage0      
           ttSelecao.grupo-fim          =  fi-grupo-fim:screen-value in frame fPage0      
           ttSelecao.modelo-ini         =  fi-modelo-ini:screen-value in frame fPage0     
           ttSelecao.modelo-fim         =  fi-modelo-fim:screen-value in frame fPage0     
           ttSelecao.estab-ini          =  fi-estab-ini:screen-value in frame fPage0
           ttSelecao.estab-fim          =  fi-estab-fim:screen-value in frame fPage0      
           ttSelecao.estabeqpto-ini     =  fi-estabeqpto-ini:screen-value in frame fPage0   
           ttSelecao.estabeqpto-fim     =  fi-estabeqpto-fim:screen-value in frame fPage0
           ttSelecao.hora-ini           =  fi-hora-ini:screen-value in frame fPage0        
           ttSelecao.hora-fim           =  fi-hora-fim:screen-value in frame fPage0        
           ttSelecao.docto-ini          =  int(fi-docto-ini:screen-value in frame fPage0)     
           ttSelecao.docto-fim          =  int(fi-docto-fim:screen-value in frame fPage0)     
           ttSelecao.posto-ini          =  fi-posto-ini:screen-value in frame fPage0     
           ttSelecao.posto-fim          =  fi-posto-fim:screen-value in frame fPage0     
           ttSelecao.bomba-ini          =  fi-bomba-ini:screen-value in frame fPage0        
           ttSelecao.bomba-fim          =  fi-bomba-fim:screen-value in frame fPage0        
           ttSelecao.matrl-ini          =  fi-matrl-ini:screen-value in frame fPage0
           ttSelecao.matrl-fim          =  fi-matrl-fim:screen-value in frame fPage0
           ttSelecao.periodo-ini        =  date(fi-periodo-ini:screen-value in frame fPage0)  
           ttSelecao.periodo-fim        =  date(fi-periodo-fim:screen-value in frame fPage0)
           ttSelecao.item-ini           =  fi-item-ini:screen-value in frame fPage0
           ttSelecao.item-fim           =  fi-item-fim:screen-value in frame fPage0
           ttSelecao.emitente-ini       =  int(fi-emitente-ini:screen-value in frame fPage0)
           ttSelecao.emitente-fim       =  int(fi-emitente-fim:screen-value in frame fPage0)
           ttSelecao.nota-ini           =  fi-nota-fis-ini:screen-value in frame fPage0
           ttSelecao.nota-fim           =  fi-nota-fis-fim:screen-value in frame fPage0
           ttSelecao.evento-ini         =  fi-evento-ini:screen-value in frame fPage0       
           ttSelecao.evento-fim         =  fi-evento-fim:screen-value in frame fPage0
           ttSelecao.ccusto-ini         =  fi-centro-custo-ini:screen-value in frame fPage0
           ttSelecao.ccusto-fim         =  fi-centro-custo-fim:screen-value in frame fPage0
           ttSelecao.comptmento-ini     =  fi-comptmento-ini:screen-value in frame fPage0
           ttSelecao.comptmento-fim     =  fi-comptmento-fim:screen-value in frame fPage0
           ttSelecao.cod-ativid-ini     =  fi-ativid-ini:screen-value in frame fPage0
           ttSelecao.cod-ativid-fim     =  fi-ativid-fim:screen-value in frame fPage0
           ttSelecao.cod-tag-ini        =  fi-tag-ini:screen-value in frame fPage0
           ttSelecao.cod-tag-fim        =  fi-tag-fim:screen-value in frame fPage0
           ttSelecao.cod-motorista-ini  =  fi-motorista-ini:SCREEN-VALUE IN FRAME fPage0
           ttSelecao.cod-motorista-fim  =  fi-motorista-fim:SCREEN-VALUE IN FRAME fPage0
           ttSelecao.cod-emitente-ini   =  int(fi-propri-ini:SCREEN-value in frame fPage0)
           ttSelecao.cod-emitente-fim   =  int(fi-propri-fim:SCREEN-value in frame fPage0)
           ttSelecao.trajeto-ini        =  fi-trajeto-ini:SCREEN-VALUE IN FRAME fPage0
           ttSelecao.trajeto-fim        =  fi-trajeto-fim:SCREEN-VALUE IN FRAME fPage0.                
    &IF DEFINED(bf_mnt_ems206b) &THEN
        IF l-usa-unid-negoc THEN DO:
            ASSIGN ttSelecao.cod-unid-negoc-eqpto-ini = fi-unid-negoc-eqpto-ini:screen-value in frame fPage0
                   ttSelecao.cod-unid-negoc-eqpto-fim = fi-unid-negoc-eqpto-fim:screen-value in frame fPage0
                   ttSelecao.cod-unid-negoc-ficha-ini = fi-unid-negoc-ficha-ini:screen-value in frame fPage0
                   ttSelecao.cod-unid-negoc-ficha-fim = fi-unid-negoc-ficha-fim:screen-value in frame fPage0.
        END.
    &ENDIF
END.

return "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

