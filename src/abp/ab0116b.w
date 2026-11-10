&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgfro            PROGRESS
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE TTmab-param NO-UNDO LIKE mab-param
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
{include/i-prgvrs.i AB0116B 2.00.00.013} /* 01/11/2023 08:43:05 */
{cdp/cdcfgmnt.i} /* Versäes EMS MNT */
{cdp/cd9911.i}  /* Varifica Unidade Neg¢cio */

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i ab0116b MAB}
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
&GLOBAL-DEFINE Program        AB0116B
&GLOBAL-DEFINE Version        2.00.00.013

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE page0Widgets   cParam cDescParam cText ~
                              tgGGF-1 tgGGF-2 tgGGF-3 tgGGF-4 tgGGF-5 tgGGF-6 cbValor ~
                              btOK btCancel btHelp2 tgValor cDestinyFile tgIntegracao ~
                              tgCriabem cbDescricao fiFormato tgUn rs-formato fmvto ~
                              fdesmov rs-term rs-param3 tgAbastec tgCadastEqpto ~
                              tgCadastMotoris tgPercursoEqpto


/* Parameters Definitions ---                                           */
define input parameter  pParam        LIKE mab-param.cdn-param.
define input parameter  pDescParam    LIKE mab-param.des-label-param.
define input-output parameter pValor  AS CHAR FORMAT "x(50)" NO-UNDO.
define output parameter l-ok          as logical. 
DEFINE VARIABLE l-erro-conecta        AS LOGICAL     NO-UNDO.

define variable hDBOParam       as handle    no-undo.
define variable hDBOEvent       as handle    no-undo.
define variable hDBOSubSist     as handle    no-undo.
define variable hDBOTipoManut   as handle    no-undo.
define variable hDBOMotorista   as handle    no-undo.
define variable hDBOTrajeto     as handle    no-undo.
define variable hDBOEmp         as handle    no-undo.
define variable c-lista         as character no-undo.
define variable cAux            as character no-undo.

define VAR pValor1              AS CHAR FORMAT "x(50)" NO-UNDO.
DEFINE VARIABLE iTipo           AS INTEGER             NO-UNDO.
DEFINE VARIABLE lValorAlterado  AS LOGICAL             NO-UNDO.

DEFINE VARIABLE hDBOCatalDoctoAnexo AS HANDLE NO-UNDO.

{include/i_fncrowid.i} /* Pre-processador da substituicao do RECID pelo ROWID */

&IF {&ROWID_READY} = YES &THEN
    define new global shared var v_rec_catal_docto_anexo as rowid  no-undo.
&ELSE
    define new global shared var v_rec_catal_docto_anexo as recid  no-undo.
&ENDIF

DEFINE VARIABLE dir_name AS CHARACTER.

{abp/ab0116.i} /* defini‡Æo da temp-table ttParam */
{abp/ab9001.i} /** procedure para retorno do tipo de moeda **/
{btb/btb009za.i}
{cdp/cdunif001.i}/*Projeto 105 unifica‡Æo de conceitos*/

&IF {&ROWID_READY} = YES &THEN
    def new global shared var v_rec_motiv_desmob
        as rowid
        no-undo.
&ELSE
    def new global shared var v_rec_motiv_desmob
        as recid
        format ">>>>>>9":U
        initial ?
        no-undo.
&ENDIF

def var v_cod_motiv_desmob
    as character
    format "x(3)":U
    label "Motivo Desmobiliza‡Æo"
    column-label "Mot Desmob"
    no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-19 rtToolBar cParam cDescParam ~
tgIntegracao tgPercursoEqpto tgCadastMotoris fiFormato tgGGF-1 rs-term ~
tgGGF-4 rs-param3 tgCadastEqpto tgCriabem tgAbastec tgUn cbValor tgGGF-2 ~
tgValor tgGGF-5 rs-formato cbDescricao tgGGF-3 cDestinyFile tgGGF-6 cText ~
btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS cParam cDescParam tgIntegracao ~
tgPercursoEqpto tgCadastMotoris fiFormato tgGGF-1 rs-term tgGGF-4 rs-param3 ~
tgCadastEqpto tgCriabem tgAbastec tgUn cbValor tgGGF-2 tgValor tgGGF-5 ~
rs-formato cbDescricao tgGGF-3 cDestinyFile tgGGF-6 fmvto fdesmov cText 

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

DEFINE VARIABLE cbDescricao AS CHARACTER FORMAT "X(256)":U 
     LABEL "Descri‡Æo do Bem" 
     VIEW-AS COMBO-BOX INNER-LINES 2
     LIST-ITEMS "Descri‡Æo do Modelo","Chassi" 
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE cbValor AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 24 BY 1 NO-UNDO.

DEFINE VARIABLE cText AS CHARACTER 
     VIEW-AS EDITOR MAX-CHARS 100 SCROLLBAR-VERTICAL
     SIZE 58 BY 3.29
     BGCOLOR 15 FGCOLOR 0  NO-UNDO.

DEFINE VARIABLE cDescParam AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE cDestinyFile AS CHARACTER FORMAT "X(256)":U 
     LABEL "Cat logo Documento" 
     VIEW-AS FILL-IN 
     SIZE 30 BY .88 TOOLTIP "Informar o diret¢rio de destino do XML" NO-UNDO.

DEFINE VARIABLE cParam AS CHARACTER FORMAT "X(8)":U 
     LABEL "C¢digo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fdesmov AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26.57 BY .88 NO-UNDO.

DEFINE VARIABLE fiFormato AS CHARACTER FORMAT "x(20)":U INITIAL "0" 
     LABEL "Formato Centro Custo Atual" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fmvto AS CHARACTER FORMAT "X(3)":U 
     LABEL "Motivo Desmobiliza‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE rs-formato AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Centro Custo + Unid, Negoc.", 1,
"Unid. Negoc. + Centro Custo", 2
     SIZE 23 BY 1.75 NO-UNDO.

DEFINE VARIABLE rs-param3 AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Matr¡cula", 1,
"C¢digo de Pessoa F¡sica", 2
     SIZE 21 BY 2 NO-UNDO.

DEFINE VARIABLE rs-term AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "NÆo Permite", 1,
"Pergunta", 2,
"Permite", 3
     SIZE 12 BY 3 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 60.29 BY 9.5.

DEFINE RECTANGLE RECT-19
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 59 BY 1.38.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 61 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE tgAbastec AS LOGICAL INITIAL no 
     LABEL "Abastecimento" 
     VIEW-AS TOGGLE-BOX
     SIZE 13.72 BY .83 NO-UNDO.

DEFINE VARIABLE tgCadastEqpto AS LOGICAL INITIAL no 
     LABEL "Cadastro Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.43 BY .83 NO-UNDO.

DEFINE VARIABLE tgCadastMotoris AS LOGICAL INITIAL no 
     LABEL "Cadastro Motorista" 
     VIEW-AS TOGGLE-BOX
     SIZE 16.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgCriabem AS LOGICAL INITIAL no 
     LABEL "Criar Bem Patrimonial a partir do Frotas" 
     VIEW-AS TOGGLE-BOX
     SIZE 30.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGF-1 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.43 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGF-2 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 23.43 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGF-3 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 22.43 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGF-4 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGF-5 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgGGF-6 AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

DEFINE VARIABLE tgIntegracao AS LOGICAL INITIAL no 
     LABEL "Integra‡Æo Patrim“nio" 
     VIEW-AS TOGGLE-BOX
     SIZE 24 BY .83 NO-UNDO.

DEFINE VARIABLE tgPercursoEqpto AS LOGICAL INITIAL no 
     LABEL "Percurso Equipamento" 
     VIEW-AS TOGGLE-BOX
     SIZE 20.14 BY .83 NO-UNDO.

DEFINE VARIABLE tgUn AS LOGICAL INITIAL no 
     LABEL "Com Unidade Neg¢cio" 
     VIEW-AS TOGGLE-BOX
     SIZE 19 BY .83 NO-UNDO.

DEFINE VARIABLE tgValor AS LOGICAL INITIAL no 
     LABEL "Valor Parƒmetro" 
     VIEW-AS TOGGLE-BOX
     SIZE 15 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     cParam AT ROW 1.58 COL 7.57 COLON-ALIGNED
     cDescParam AT ROW 1.58 COL 17.57 COLON-ALIGNED NO-LABEL
     tgIntegracao AT ROW 2.92 COL 25
     tgPercursoEqpto AT ROW 2.96 COL 9.86
     tgCadastMotoris AT ROW 2.96 COL 30
     fiFormato AT ROW 3 COL 23 COLON-ALIGNED
     tgGGF-1 AT ROW 3.25 COL 4.57
     rs-term AT ROW 3.25 COL 23 NO-LABEL
     tgGGF-4 AT ROW 3.25 COL 33.43
     rs-param3 AT ROW 3.63 COL 18.72 NO-LABEL
     tgCadastEqpto AT ROW 3.96 COL 9.86
     tgCriabem AT ROW 3.96 COL 25
     tgAbastec AT ROW 3.96 COL 30
     tgUn AT ROW 4.08 COL 25
     cbValor AT ROW 4.21 COL 19.43 COLON-ALIGNED
     tgGGF-2 AT ROW 4.25 COL 4.57
     tgValor AT ROW 4.25 COL 20.14
     tgGGF-5 AT ROW 4.25 COL 33.43
     rs-formato AT ROW 4.96 COL 25 NO-LABEL
     cbDescricao AT ROW 5.04 COL 23.14 COLON-ALIGNED
     tgGGF-3 AT ROW 5.25 COL 4.57
     cDestinyFile AT ROW 5.25 COL 17.72 COLON-ALIGNED
     tgGGF-6 AT ROW 5.25 COL 33.43
     fmvto AT ROW 6.25 COL 23.14 COLON-ALIGNED
     fdesmov AT ROW 6.25 COL 30.43 COLON-ALIGNED NO-LABEL
     cText AT ROW 7.25 COL 3 NO-LABEL
     btOK AT ROW 11.08 COL 2
     btCancel AT ROW 11.08 COL 13.14
     btHelp2 AT ROW 11.08 COL 51.43
     RECT-1 AT ROW 1.25 COL 2
     RECT-19 AT ROW 1.38 COL 2.29
     rtToolBar AT ROW 10.88 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 61.43 BY 11.71
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: TTmab-param T "?" NO-UNDO mgfro mab-param
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
         TITLE              = "Parƒmetros"
         HEIGHT             = 11.5
         WIDTH              = 62
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
/* SETTINGS FOR FILL-IN fdesmov IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fmvto IN FRAME fpage0
   NO-ENABLE                                                            */
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
ON END-ERROR OF wWindow /* Parƒmetros */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wWindow wWindow
ON WINDOW-CLOSE OF wWindow /* Parƒmetros */
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
    {method/showmessage.i1}
    
    ASSIGN l-ok    = yes
           pValor1 = "":U.
    
    CASE pParam:
        WHEN 1 THEN DO:
            IF tgGGF-1:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim }
                ASSIGN pValor1 = pValor1 + return-value.
            END.
            else do:
                {utp/ut-liter.i NÆo }
                ASSIGN pValor1 = pValor1  + return-value.
            END.
            IF tgGGF-2:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            else do:
                {utp/ut-liter.i NÆo }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            IF tgGGF-3:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            else do:
                {utp/ut-liter.i NÆo }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            IF tgGGF-4:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            else do:
                {utp/ut-liter.i NÆo }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            IF tgGGF-5:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            else do:
                {utp/ut-liter.i NÆo }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            IF tgGGF-6:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
            else do:
                {utp/ut-liter.i NÆo }
                ASSIGN pValor1 = pValor1 + ",":U + return-value.
            END.
        END. /*when 1*/
        WHEN 2 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
        WHEN 3 THEN DO:
            ASSIGN pValor1 = STRING(INPUT FRAME fPage0 rs-param3).
        END.
        WHEN 4 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
        WHEN 5 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
        WHEN 6 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
        WHEN 7 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
        WHEN 8 THEN DO:
             ASSIGN pValor1 = string(cbValor:lookup(cbValor:screen-value in frame fPage0)). 
        END.
        when 9 then do:
            ASSIGN pValor1 = STRING(INPUT FRAME fPage0 rs-term).
        end.
        when 10 then do:
            if tgPercursoEqpto:checked in frame fPage0 then do:
                {utp/ut-liter.i Sim}
                assign pValor1 = pValor1 + return-value.
            end.
            else do:
                {utp/ut-liter.i NÆo}
                assign pValor1 = pValor1 + return-value.
            end.
            if tgCadastEqpto:checked in frame fPage0 then do:
                {utp/ut-liter.i Sim}
                assign pValor1 = pValor1 + ",":U + return-value.
            end.
            else do:
                {utp/ut-liter.i NÆo}
                assign pValor1 = pValor1 + ",":U + return-value.
            end.
            if tgCadastMotoris:checked in frame fPage0 then do:
                {utp/ut-liter.i Sim}
                assign pValor1 = pValor1 + ",":U + return-value.
            end.
            else do:
                {utp/ut-liter.i NÆo}
                assign pValor1 = pValor1 + ",":U + return-value.
            end.
            if tgAbastec:checked in frame fPage0 then do:
                {utp/ut-liter.i Sim}
                assign pValor1 = pValor1 + ",":U + return-value.
            end.
            else do:
                {utp/ut-liter.i NÆo}
                assign pValor1 = pValor1 + ",":U + return-value.
            end.
            assign pValor1 = pValor1 + ",":U + cDestinyFile:screen-value in frame fPage0.
            DO:           
                FOR FIRST catal_docto_anexo
                    WHERE catal_docto_anexo.cod_catal_docto_anexo = cDestinyFile:SCREEN-VALUE IN FRAME fPage0:
                END.

                if can-find (first catal_docto_anexo
                    where catal_docto_anexo.cod_catal_docto_anexo = cDestinyFile:SCREEN-VALUE IN FRAME fPage0) THEN DO:         
                        ASSIGN dir_name = catal_docto_anexo.cod_path_catal. 
                               FILE-INFO:FILE-NAME = dir_name.
                        IF FILE-INFO:full-pathname <> ? THEN DO:
                             ASSIGN dir_name = catal_docto_anexo.cod_path_catal + "~\INP":U.
                             OS-CREATE-DIR VALUE(dir_name).
                             IF OS-ERROR = 10 THEN do:
                                {utp/ut-liter.i " NÆo_foi_possivel_criar_o_diret¢rio_de_INP"}
                                CREATE RowErrors.
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-nao-foi-possivel-criar-o-diret AS CHARACTER NO-UNDO.
                                ASSIGN c-lbl-liter-nao-foi-possivel-criar-o-diret = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-verifique-se-existe-arquivo-co AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Verifique_se_existe_arquivo_com_o_nome_INP_no_cat logo_de_documento_anexo" *}
                                ASSIGN c-lbl-liter-verifique-se-existe-arquivo-co = TRIM(RETURN-VALUE).
                                ASSIGN RowErrors.ErrorNumber = 17006
                                       RowErrors.ErrorSubType = "ERROR"
                                       RowErrors.ErrorType = "EMS"
                                       RowErrors.ErrorHelp = c-lbl-liter-verifique-se-existe-arquivo-co
                                       RowErrors.ErrorDescription = c-lbl-liter-nao-foi-possivel-criar-o-diret.
                               END.

                             ASSIGN dir_name = catal_docto_anexo.cod_path_catal + "~\EXP":U.
                             OS-CREATE-DIR VALUE(dir_name).
                              IF OS-ERROR = 10 THEN do:
                               {utp/ut-liter.i NÆo_foi_possivel_criar_o_diret¢rio_de_EXP }  
                                CREATE RowErrors.
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter AS CHARACTER NO-UNDO.
                                ASSIGN c-lbl-liter = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-verifique-se-existe-arquivo-co-2 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Verifique_se_existe_arquivo_com_o_nome_EXP_no_cat logo_de_documento_anexo" *}
                                ASSIGN c-lbl-liter-verifique-se-existe-arquivo-co-2 = TRIM(RETURN-VALUE).
                                ASSIGN RowErrors.ErrorNumber = 17006
                                       RowErrors.ErrorSubType = "ERROR"
                                       RowErrors.ErrorType = "EMS"
                                       RowErrors.ErrorHelp = c-lbl-liter-verifique-se-existe-arquivo-co-2
                                       RowErrors.ErrorDescription = c-lbl-liter. 
                              END.

                             ASSIGN dir_name = catal_docto_anexo.cod_path_catal + "~\BKP":U.
                             OS-CREATE-DIR VALUE(dir_name).
                             IF OS-ERROR = 10 THEN do:
                                {utp/ut-liter.i NÆo_foi_possivel_criar_o_diret¢rio_de_BKP } 
                                CREATE RowErrors.
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-2 AS CHARACTER NO-UNDO.
                                ASSIGN c-lbl-liter-2 = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-liter-verifique-se-existe-arquivo-co-3 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Verifique_se_existe_arquivo_com_o_nome_BKP_no_cat logo_de_documento_anexo" *}
                                ASSIGN c-lbl-liter-verifique-se-existe-arquivo-co-3 = TRIM(RETURN-VALUE).
                                ASSIGN RowErrors.ErrorNumber = 17006
                                       RowErrors.ErrorSubType = "ERROR"
                                       RowErrors.ErrorType = "EMS"
                                       RowErrors.ErrorHelp = c-lbl-liter-verifique-se-existe-arquivo-co-3
                                       RowErrors.ErrorDescription = c-lbl-liter-2.
                             END.

                             IF CAN-FIND(FIRST RowErrors
                                         WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK) THEN DO:
                                        {method/showmessage.i2 &Modal="YES"}
                             END.
                             {method/showmessage.i3}
                             Empty temp-table RowErrors.
                        END.
                        
                    ELSE DO:
                        {utp/ut-liter.i Diret¢rio_informado_no_cat logo_nÆo_foi_encontrado } 
                        CREATE RowErrors.
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-3 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-liter-3 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-liter-verifique-o-diretorio-informad AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Verifique_o_diret¢rio_informado_no_cat logo_de_endere‡o" *}
                        ASSIGN c-lbl-liter-verifique-o-diretorio-informad = TRIM(RETURN-VALUE).
                        ASSIGN RowErrors.ErrorNumber = 17006
                               RowErrors.ErrorSubType = "ERROR"
                               RowErrors.ErrorType = "EMS"
                               RowErrors.ErrorHelp = c-lbl-liter-verifique-o-diretorio-informad
                               RowErrors.ErrorDescription = c-lbl-liter-3.
                        IF CAN-FIND(FIRST RowErrors
                                     WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK) THEN DO:
                                     {method/showmessage.i2 &Modal="YES"}
                        END.
                        {method/showmessage.i3}
                        Empty temp-table RowErrors.
                        RETURN "NOK":U.
                    END.
                END.
                else do:
                     IF  cDestinyFile:SENSITIVE IN FRAME fPage0 = YES THEN DO:
                         {utp/ut-liter.i Cat logo_de_documento_inv lido} 
                         CREATE RowErrors.
                         /* Inicio -- Projeto Internacional */
                         DEFINE VARIABLE c-lbl-liter-4 AS CHARACTER NO-UNDO.
                         ASSIGN c-lbl-liter-4 = TRIM(RETURN-VALUE).
                         DEFINE VARIABLE c-lbl-liter-verifique-se-existe-o-nome-do AS CHARACTER NO-UNDO.
                         {utp/ut-liter.i "Verifique_se_existe_o_nome_do_cat logo_de_documento" *}
                         ASSIGN c-lbl-liter-verifique-se-existe-o-nome-do = TRIM(RETURN-VALUE).
                         ASSIGN RowErrors.ErrorNumber = 17006
                                RowErrors.ErrorSubType = "ERROR"
                                RowErrors.ErrorType = "EMS"
                                RowErrors.ErrorHelp = c-lbl-liter-verifique-se-existe-o-nome-do
                                RowErrors.ErrorDescription = c-lbl-liter-4.
                         IF CAN-FIND(FIRST RowErrors
                                     WHERE RowErrors.ErrorSubType = "ERROR" NO-LOCK) THEN DO:
                                        {method/showmessage.i2 &Modal="YES"}
                         END.
                         {method/showmessage.i3}
                         Empty temp-table RowErrors.
                         RETURN "NOK":U.
                     END.
                END.
            END.
        end.
        WHEN 11 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
        WHEN 12 THEN DO:
            if  fmvto:sensitive in frame fPage0 then do:
                if  fmvto:screen-value = "" then do:
                    {utp/ut-liter.i Motivo_de_desmobiliza‡Æo_inv lido *}
                    create RowErrors.
                    assign RowErrors.ErrorNumber      = 17006
                           RowErrors.ErrorSubType     = "ERROR"
                           RowErrors.ErrorType        = "EMS"
                           RowErrors.ErrorDescription = return-value.
                    {utp/ut-liter.i Motivo_de_desmobliza‡Æo_deve_existir *}
                    assign RowErrors.ErrorHelp = return-value.
                end.
                else do:
                    IF  NOT CONNECTED("emsbas") OR 
                        NOT CONNECTED("emsfin") OR 
                        NOT CONNECTED("emsuni") THEN
                        RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
                    ELSE
                        RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
                    assign cAux = "log_motiv_transf".
                    run pi-busca-ems5(input "motiv_desmob",
                                      input "motiv_desmob.cod_motiv_desmob = ~"" + fmvto:screen-value + "~"",
                                      input-output cAux).
            
                    if  entry(1,cAux) = "no" then do:
                        {utp/ut-liter.i Motivo_de_desmobiliza‡Æo_inv lido *}
                        create RowErrors.
                        assign RowErrors.ErrorNumber      = 17006
                               RowErrors.ErrorSubType     = "ERROR"
                               RowErrors.ErrorType        = "EMS"
                               RowErrors.ErrorDescription = return-value.
                        {utp/ut-liter.i Motivo_de_desmobliza‡Æo_deve_ser_de_transferˆncia *}
                        assign RowErrors.ErrorHelp = return-value.
                    end.
                    IF  NOT CONNECTED("emsbas") OR 
                        NOT CONNECTED("emsfin") OR 
                        NOT CONNECTED("emsuni") THEN
                        RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
                    ELSE
                        RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
                end.
            end.

            if can-find(first RowErrors
                        where RowErrors.ErrorSubType = "ERROR") then do:
                {method/showmessage.i2 &Modal="YES"}
                empty temp-table RowErrors.
                return "nok".
            end.

            IF tgIntegracao:CHECKED IN FRAME fPage0 THEN DO:
                {utp/ut-liter.i Sim}
                ASSIGN pValor1 = TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i NÆo}
                ASSIGN pValor1 =  TRIM(RETURN-VALUE).
            END.
       
            IF tgCriabem:CHECKED IN FRAME fPage0 THEN DO:
            
                {utp/ut-liter.i Sim}
                ASSIGN  pValor1 = pValor1 + ",":U + TRIM(RETURN-VALUE).
            END.
            ELSE DO:
                {utp/ut-liter.i NÆo}
                ASSIGN  pValor1 = pValor1 + ",":U + TRIM(RETURN-VALUE).
            END.

            ASSIGN pValor1 =  pValor1 + ",":U + string(cbDescricao:lookup(cbDescricao:screen-value in frame fPage0)). 

            assign pValor1 = pValor1 + ",":U + fmvto:screen-value in frame fPage0.
        END.
        WHEN 13 THEN DO:
            IF tgUn:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.

            ASSIGN pValor1 = pValor1 + ",":U + STRING(INPUT FRAME fPage0 rs-formato).
        END.
        WHEN 14 THEN DO:
            IF tgValor:CHECKED IN FRAME fPage0 THEN
                ASSIGN pValor1 = "1":U.
            ELSE
                ASSIGN pValor1 = "2":U.
        END.
    end case.
    RUN atualizaValor1 IN hDBOParam   (INPUT pParam,
                                       INPUT cDescParam:screen-value in frame fPage0,
                                       INPUT cText:screen-value in frame fPage0,
                                       INPUT-OUTPUT pValor1).

    IF  RETURN-VALUE = "NOK":U THEN DO:
        RUN piMostraErros IN THIS-PROCEDURE.
        
        RETURN NO-APPLY.
    END.
    ELSE DO:
        IF  pValor1 = "1" THEN
            ASSIGN lValorAlterado = YES.
        ELSE
            ASSIGN lValorAlterado = NO.
        
        CASE pParam:
            WHEN 5 THEN DO:
                FIND FIRST funcao
                     WHERE funcao.cd-funcao = "spp-mab-nf":U EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL funcao THEN DO:
                    IF  funcao.ativo <> lValorAlterado THEN
                        ASSIGN funcao.ativo = lValorAlterado.
                END.
                ELSE DO:
                    IF  lValorAlterado THEN DO:
                        CREATE funcao.
                        ASSIGN funcao.cd-funcao = "spp-mab-nf":U
                               funcao.ativo     = lValorAlterado.
                    END.
                END.
            END.
            WHEN 6 THEN DO:
                FIND FIRST funcao
                     WHERE funcao.cd-funcao = "spp-int-req-om":U EXCLUSIVE-LOCK NO-ERROR.
                IF  AVAIL funcao THEN DO:
                    IF  funcao.ativo <> lValorAlterado THEN
                        ASSIGN funcao.ativo = lValorAlterado.
                END.
                ELSE DO:
                    IF  lValorAlterado THEN DO:
                        CREATE funcao.
                        ASSIGN funcao.cd-funcao = "spp-int-req-om":U
                               funcao.ativo     = lValorAlterado.
                    END.
                END.
            END.           
        END CASE.
    END.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cDestinyFile
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cDestinyFile wWindow
ON MOUSE-SELECT-DBLCLICK OF cDestinyFile IN FRAME fpage0 /* Cat logo Documento */
DO:
    define variable cCaminho as character  no-undo.
    run btb/btb003ka.p.
    if  v_rec_catal_docto_anexo <> ? then do:
        run goToRecid in hDBOCatalDoctoAnexo (input v_rec_catal_docto_anexo).
        run getCharField in hDBOCatalDoctoAnexo (input "cod_catal_docto_anexo":U, output cCaminho).

        assign cDestinyFile:screen-value in frame fPage0 = cCaminho.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fmvto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fmvto wWindow
ON F5 OF fmvto IN FRAME fpage0 /* Motivo Desmobiliza‡Æo */
DO:
    IF  NOT CONNECTED("emsbas") OR 
        NOT CONNECTED("emsfin") OR 
        NOT CONNECTED("emsuni") THEN
        RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
    ELSE
        RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
    if  search("prgfin/fas/fas028ka.r") = ? and search("prgfin/fas/fas028ka.p") = ? then do:
        run utp/ut-msgs.p (input "show",
                           input 3984,
                           input "prgfin/fas/fas028ka.p").
    end.
    else
        run prgfin/fas/fas028ka.p /*prg_sea_motiv_desmob*/.

    if  v_rec_motiv_desmob <> ? then do:

        assign cAux = "cod_motiv_desmob,des_motiv_desmob,log_motiv_transf".

        &IF {&ROWID_READY} = YES &THEN
        run pi-busca-ems5(input "motiv_desmob",
                          input "rowid(motiv_desmob) = " + string(v_rec_motiv_desmob),
                          input-output cAux).
        &ELSE
        run pi-busca-ems5(input "motiv_desmob",
                          input "recid(motiv_desmob) = " + string(v_rec_motiv_desmob),
                          input-output cAux).
        &ENDIF
        
        assign fmvto  :screen-value = entry(1,cAux)
               fdesmov:screen-value = entry(2,cAux).
    end.
    IF  NOT CONNECTED("emsbas") OR 
        NOT CONNECTED("emsfin") OR 
        NOT CONNECTED("emsuni") THEN
        RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
    ELSE
        RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fmvto wWindow
ON LEAVE OF fmvto IN FRAME fpage0 /* Motivo Desmobiliza‡Æo */
DO:
    if  fmvto:screen-value in frame fPage0 ne "" then do:
        IF  NOT CONNECTED("emsbas") OR 
            NOT CONNECTED("emsfin") OR 
            NOT CONNECTED("emsuni") THEN
            RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
        ELSE
            RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
        assign cAux = "cod_motiv_desmob,des_motiv_desmob,log_motiv_transf".
        run pi-busca-ems5(input "motiv_desmob",
                          input "motiv_desmob.cod_motiv_desmob = ~"" + fmvto:screen-value in frame fPage0 + "~"",
                          input-output cAux).

        IF  NOT CONNECTED("emsbas") OR 
            NOT CONNECTED("emsfin") OR 
            NOT CONNECTED("emsuni") THEN
            RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
        ELSE
            RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).

        if  return-value = "ok" and num-entries(cAux) >= 3 then
            assign fmvto  :screen-value in frame fpage0 = entry(1,cAux)
                   fdesmov:screen-value in frame fpage0 = entry(2,cAux).
        else 
            assign fdesmov:screen-value in frame fpage0 = "".
    end.
    else 
        assign fdesmov:screen-value = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fmvto wWindow
ON MOUSE-SELECT-DBLCLICK OF fmvto IN FRAME fpage0 /* Motivo Desmobiliza‡Æo */
DO:
  APPLY "F5" TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgAbastec
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgAbastec wWindow
ON VALUE-CHANGED OF tgAbastec IN FRAME fpage0 /* Abastecimento */
DO:
    run piHabilitaCampos in this-procedure.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgCadastEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgCadastEqpto wWindow
ON VALUE-CHANGED OF tgCadastEqpto IN FRAME fpage0 /* Cadastro Equipamento */
DO:
    run piHabilitaCampos in this-procedure.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgCadastMotoris
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgCadastMotoris wWindow
ON VALUE-CHANGED OF tgCadastMotoris IN FRAME fpage0 /* Cadastro Motorista */
DO:
    run piHabilitaCampos in this-procedure.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgCriabem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgCriabem wWindow
ON VALUE-CHANGED OF tgCriabem IN FRAME fpage0 /* Criar Bem Patrimonial a partir do Frotas */
DO:
   run piHabilitaCampos in this-procedure.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgIntegracao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgIntegracao wWindow
ON VALUE-CHANGED OF tgIntegracao IN FRAME fpage0 /* Integra‡Æo Patrim“nio */
DO:
    IF  NOT CONNECTED("emsbas") OR 
        NOT CONNECTED("emsfin") OR 
        NOT CONNECTED("emsuni") THEN
        RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
    ELSE
        RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
    if  search("prgfin/fas/fas028ka.r") = ? and search("prgfin/fas/fas028ka.p") = ? then do:
        ASSIGN tgCriabem:SENSITIVE      IN FRAME fPage0 = NO.
          
    end.
    else
        run piHabilitaCampos in this-procedure.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgPercursoEqpto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgPercursoEqpto wWindow
ON VALUE-CHANGED OF tgPercursoEqpto IN FRAME fpage0 /* Percurso Equipamento */
DO:
    run piHabilitaCampos in this-procedure.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tgUn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tgUn wWindow
ON VALUE-CHANGED OF tgUn IN FRAME fpage0 /* Com Unidade Neg¢cio */
DO:
    IF tgUn:CHECKED IN FRAME fPage0 THEN
        ASSIGN rs-formato:SENSITIVE IN FRAME fpage0 = YES.
    ELSE
        ASSIGN rs-formato:SENSITIVE IN FRAME fpage0 = NO.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


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

if  valid-handle(hDBOParam) then
    delete procedure hDBOParam.

if  valid-handle (hDBOCatalDoctoAnexo) then
    RUN destroy in hDBOCatalDoctoAnexo.

{method/showmessage.i3}

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
DISPLAY cParam
        cDescParam with frame fPage0.

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
define variable cAux as character  no-undo.

cDestinyFile:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.
fmvto:LOAD-MOUSE-POINTER("image/lupa.cur":U) in frame fPage0.

assign cText:sensitive in frame fPage0 = YES
       cText:read-only in frame fPage0 = NO.

FOR FIRST mab-param-integr FIELDS(cdn-param des-label-param des-param des-valor)
    WHERE mab-param-integr.cdn-param = pParam NO-LOCK:

    ASSIGN cParam:SCREEN-VALUE IN FRAME fPage0     = string(mab-param-integr.cdn-param)
           cDescParam:SCREEN-VALUE IN FRAME fPage0 = mab-param-integr.des-label-param
           cText:SCREEN-VALUE IN FRAME fPage0      = mab-param-integr.des-param no-error.

    /** Busca Parƒmtros **/
    CASE mab-param-integr.cdn-param:
        WHEN 1 THEN DO:
            /** Esconde toggle do Parƒmetro 2 **/
            ASSIGN tgValor:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   cbValor:HIDDEN IN FRAME                fPage0 = yes
                   rs-term:hidden in frame                fPage0 = YES
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fPage0 = YES
                   tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = YES
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes.
                   
           
            /** Verifica se m¢dulo de Custos Implantado **/
            for first param-global fields(modulo-cs) no-lock:
                IF param-global.modulo-cs THEN DO:
                    FOR FIRST param-cs fields(ocorrencia) NO-LOCK:
                        IF param-cs.ocorrencia[1] <> "" THEN DO:
                            ASSIGN tgGGF-1:SENSITIVE IN FRAME fPage0 = YES
                                   tgGGF-1:LABEL IN FRAME fPage0     = param-cs.ocorrencia[1]
                                   tgGGF-1:CHECKED IN FRAME fPage0   = NO
                                   tgGGF-1:HIDDEN IN FRAME fPage0 = NO.
                        END.
                        else do:
                            ASSIGN tgGGF-1:HIDDEN IN FRAME fPage0 = YES.
                        END.
                        IF param-cs.ocorrencia[2] <> "" THEN DO:
                            ASSIGN tgGGF-2:SENSITIVE IN FRAME fPage0 = YES
                                   tgGGF-2:LABEL IN FRAME fPage0     = param-cs.ocorrencia[2]
                                   tgGGF-2:CHECKED IN FRAME fPage0   = NO
                                   tgGGF-2:HIDDEN IN FRAME fPage0 = NO.
                        END.
                        else do:
                            ASSIGN tgGGF-2:HIDDEN IN FRAME fPage0 = YES.
                        END.
                        IF param-cs.ocorrencia[3] <> "" THEN DO:
                            ASSIGN tgGGF-3:SENSITIVE IN FRAME fPage0 = YES
                                   tgGGF-3:LABEL IN FRAME fPage0     = param-cs.ocorrencia[3]
                                   tgGGF-3:CHECKED IN FRAME fPage0   = NO
                                   tgGGF-3:HIDDEN IN FRAME fPage0 = NO.
                        END.
                        else do:
                            ASSIGN tgGGF-3:HIDDEN IN FRAME fPage0 = YES.
                        END.
                        IF param-cs.ocorrencia[4] <> "" THEN DO:
                            ASSIGN tgGGF-4:SENSITIVE IN FRAME fPage0 = YES
                                   tgGGF-4:LABEL IN FRAME fPage0     = param-cs.ocorrencia[4]
                                   tgGGF-4:CHECKED IN FRAME fPage0   = NO
                                   tgGGF-4:HIDDEN IN FRAME fPage0 = NO.
                        END.
                        else do:
                            ASSIGN tgGGF-4:HIDDEN IN FRAME fPage0 = YES.
                        END.
                        IF param-cs.ocorrencia[5] <> "" THEN DO:
                            ASSIGN tgGGF-5:SENSITIVE IN FRAME fPage0 = YES
                                   tgGGF-5:LABEL IN FRAME fPage0     = param-cs.ocorrencia[5]
                                   tgGGF-5:CHECKED IN FRAME fPage0   = NO
                                   tgGGF-5:HIDDEN IN FRAME fPage0 = NO.
                        END.
                        else do:
                            ASSIGN tgGGF-5:HIDDEN IN FRAME fPage0 = YES.
                        END.
                        IF param-cs.ocorrencia[6] <> "" THEN DO:
                            ASSIGN tgGGF-6:SENSITIVE IN FRAME fPage0 = YES
                                   tgGGF-6:LABEL IN FRAME fPage0     = param-cs.ocorrencia[6]
                                   tgGGF-6:CHECKED IN FRAME fPage0   = NO
                                   tgGGF-6:HIDDEN IN FRAME fPage0 = NO.
                        END.
                        else do:
                            ASSIGN tgGGF-6:HIDDEN IN FRAME fPage0 = YES.
                        END.
                    END.
                END.
            END.
            RUN pi-valor IN THIS-PROCEDURE.
        END. /* WHEN 1 */
        WHEN 2 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME         fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.

        END. /* WHEN 2 */
        WHEN 3 THEN DO:
            /** Desabilita toggles dos outros parametros e habilita campo desse **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = YES
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   rs-param3:HIDDEN IN FRAME              fPage0 = NO
                   rs-param3:SENSITIVE IN FRAME           fPage0 = YES
                   rs-param3 = INT(mab-param-integr.des-valor)
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
            DISP rs-param3 WITH FRAME fPage0.
        END. /* WHEN 3 */
        WHEN 4 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME      fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
        END. /* WHEN 4 */
        WHEN 5 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME      fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
        END. /* WHEN 5 or 6*/
        WHEN 6 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME      fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
        END. /* WHEN 5 or 6*/
        WHEN 7 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME      fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
        END. /* WHEN 7 */
        WHEN 8 THEN DO:
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   tgValor:HIDDEN IN FRAME                fPage0 = YES
                   cbValor:HIDDEN IN FRAME                fPage0 = NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
            {utp/ut-liter.i "Valor_Parƒmetros"}
            ASSIGN cbValor:LABEL = RETURN-VALUE.
            &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                 DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
                 ASSIGN cAuxTraducao005 = {frinc/i02fr019.i 03}.
                 RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao005).
                 ASSIGN    c-lista  = cAuxTraducao005.
            &else
                 ASSIGN c-lista  = {frinc/i02fr019.i 03}.
            &endif
            ASSIGN cbValor:LIST-ITEMS IN FRAME fPage0 = c-lista
                   cbValor:screen-value in frame fPage0 = cbValor:entry(1).
        END.
        when 9 then do:
            assign tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = yes
                   tgValor:HIDDEN IN FRAME                fPage0 = YES
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   rs-term:hidden in frame                fPage0 = no
                   rs-term:SENSITIVE IN FRAME             fPage0 = YES
                   rs-term = INT(mab-param-integr.des-valor)
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
            DISP rs-term WITH FRAME fPage0.
        end.
        when 10 then do:
            assign  tgGGF-1:hidden in frame                   fPage0 = yes
                    tgGGF-2:hidden in frame                   fPage0 = yes
                    tgGGF-3:hidden in frame                   fPage0 = yes
                    tgGGF-4:hidden in frame                   fPage0 = yes
                    tgGGF-5:hidden in frame                   fPage0 = yes
                    tgGGF-6:hidden in frame                   fPage0 = yes
                    rs-param3:hidden in frame                 fPage0 = yes
                    tgValor:hidden in frame                   fPage0 = yes
                    cbValor:hidden in frame                   fPage0 = yes
                    rs-term:hidden in frame                   fPage0 = yes
                    tgPercursoEqpto:visible in frame          fPage0 = yes
                    tgPercursoEqpto:sensitive in frame        fPage0 = yes
                    tgCadastEqpto:visible in frame            fPage0 = yes
                    tgCadastEqpto:sensitive in frame          fPage0 = yes
                    tgCadastMotoris:visible in frame          fPage0 = yes
                    tgCadastMotoris:sensitive in frame        fPage0 = yes
                    tgAbastec:visible in frame                fPage0 = yes
                    tgAbastec:sensitive in frame              fPage0 = yes
                    cDestinyFile:visible in frame      {&frame-name} = yes
                    cDestinyFile:sensitive in frame    {&frame-name} = yes
                    cDestinyFile:screen-value in frame {&frame-name} = entry(5,mab-param-integr.des-valor)
                    tgIntegracao:HIDDEN IN FRAME              fpage0 = yes
                    tgCriabem:HIDDEN IN FRAME                 fpage0 = yes
                    cbDescricao:HIDDEN IN FRAME               fpage0 = yes
                    fmvto:HIDDEN in frame                     fPage0 = yes
                    fdesmov:HIDDEN in frame                   fPage0 = YES
                    fiFormato:HIDDEN IN FRAME                 fPage0 = yes
                    tgUn:HIDDEN IN FRAME                      fPage0 = yes
                    rs-formato:HIDDEN IN FRAME                fPage0 = yes.

            if num-entries(mab-param-integr.des-valor) > 0 then do:
                {utp/ut-liter.i Sim *}
                assign cAux = trim(return-value).
                if entry(1,mab-param-integr.des-valor) = cAux then do:
                    assign tgPercursoEqpto:checked in frame fPage0 = yes.
                end.
                else do:
                    assign tgPercursoEqpto:checked in frame fPage0 = no.
                end.
                if entry(2,mab-param-integr.des-valor) = cAux then do:
                    assign tgCadastEqpto:checked in frame fPage0 = yes.
                end.
                else do:
                    assign tgCadastEqpto:checked in frame fPage0 = no.
                end.
                if entry(3,mab-param-integr.des-valor) = cAux then do:
                    assign tgCadastMotoris:checked in frame fPage0 = yes.
                end.
                else do:
                    assign tgCadastMotoris:checked in frame fPage0 = no.
                end.
                if entry(4,mab-param-integr.des-valor) = cAux then do:
                    assign tgAbastec:checked in frame fPage0 = yes.
                end.
                else do:
                    assign tgAbastec:checked in frame fPage0 = no.
                end.            
            end.
            run piHabilitaCampos in this-procedure.
        end.
        WHEN 11 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME               fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
        END. /* WHEN 11 */
        WHEN 12 THEN DO:
            run piHabilitaCampos in this-procedure.
            RUN piIntegracao.
        END.
        WHEN 13 THEN DO:
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   tgValor:HIDDEN IN FRAME                fPage0 = YES
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = NO
                   fiFormato:SENSITIVE IN FRAME           fPage0 = NO
                   tgUn:HIDDEN IN FRAME                   fPage0 = NO
                   tgUn:CHECKED IN FRAME                  fPage0 = IF ENTRY(1,mab-param-integr.des-valor) = "1":U THEN YES ELSE NO
                   rs-formato:HIDDEN IN FRAME             fPage0 = NO
                   rs-formato                                    = INT(ENTRY(2,mab-param-integr.des-valor)).
                   .

            RUN piBuscaFormatoCCusto IN THIS-PROCEDURE.

            DISP rs-formato WITH FRAME fPage0.

            APPLY "VALUE-CHANGED":U TO tgUn IN FRAME fPage0.
        END.
        WHEN 14 THEN DO:
            /** Desabilita toggles do Parƒmetro 1 e Habilita o toggle desse parametro **/
            ASSIGN tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
                   tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
                   rs-param3:HIDDEN IN FRAME              fPage0 = YES
                   rs-term:hidden in frame                fPage0 = yes
                   cbValor:HIDDEN IN FRAME                fPage0 = YES
                   tgValor:HIDDEN IN FRAME                fPage0 = NO
                   tgValor:SENSITIVE IN FRAME             fPage0 = YES
                   tgValor:CHECKED IN FRAME      fPage0 = IF mab-param-integr.des-valor = "1":U THEN YES ELSE NO
                   tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
                   tgCadastEqpto:HIDDEN in frame          fPage0 = yes
                   tgCadastMotoris:HIDDEN in frame        fPage0 = yes
                   tgAbastec:HIDDEN in frame              fPage0 = yes
                   cDestinyFile:hidden in frame           fPage0 = yes
                   tgIntegracao:HIDDEN IN FRAME           fpage0 = yes
                   tgCriabem:HIDDEN IN FRAME              fpage0 = yes
                   cbDescricao:HIDDEN IN FRAME            fpage0 = yes
                   fmvto:HIDDEN in frame                  fPage0 = yes
                   fdesmov:HIDDEN in frame                fPage0 = YES
                   fiFormato:HIDDEN IN FRAME              fPage0 = yes
                   tgUn:HIDDEN IN FRAME                   fPage0 = yes
                   rs-formato:HIDDEN IN FRAME             fPage0 = yes.
        END. /* WHEN 14 */
    end case.
end.

disable cParam with frame fPage0.
enable cDescParam
       cText with frame fPage0.
assign cParam:sensitive in frame     fPage0 = NO
       cDescParam:sensitive in frame fPage0 = YES.

return "OK":U.

end procedure.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeInitializeInterface wWindow 
PROCEDURE beforeInitializeInterface :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
IF  NOT CONNECTED("emsbas") OR 
    NOT CONNECTED("emsfin") OR 
    NOT CONNECTED("emsuni") THEN
    RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
ELSE
    RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
IF NOT VALID-HANDLE(hDBOParam)           OR
    hDBOParam:TYPE      <> "PROCEDURE":U OR
    hDBOParam:FILE-NAME <> "frbo/bofr122.p":U THEN DO:
    run frbo/bofr122.p persistent set  hDBOParam.
END.

RUN OpenQueryStatic IN hDBOParam (INPUT "Main":U) NO-ERROR.

/** Cat logo de Documentos **/
if not valid-handle(hDBOCatalDoctoAnexo)            OR
     hDBOCatalDoctoAnexo:TYPE      <> "PROCEDURE":U OR
     hDBOCatalDoctoAnexo:FILE-NAME <> "unbo/boun014.p":U THEN DO:
     run unbo/boun014.p persistent set hDBOCatalDoctoAnexo.
end.

run openQueryStatic in hDBOCatalDoctoAnexo (input "Default":U) NO-ERROR.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-ems5 wWindow 
PROCEDURE pi-busca-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input        param p-tabela  as char no-undo.
    def input        param p-where   as char no-undo.
    def input-output param p-retorna as char no-undo.

    def var hQuery  as widget-handle no-undo.
    def var hBuffer as widget-handle no-undo.
    def var hField  as widget-handle no-undo.
    def var cQuery  as char          no-undo.
    def var cReturn as char          no-undo.
    def var iCont   as integer       no-undo.

    assign cQuery    = "for each " + p-tabela + " no-lock where " + replace (p-where,","," and ")
           cReturn   = p-retorna
           p-retorna = "".

    create buffer hBuffer for table p-tabela no-error.
    create query  hQuery                     no-error.

    if  error-status:error then
        return "nok".

    hQuery:set-buffers(hBuffer)  no-error. 
    hQuery:query-prepare(cQuery) no-error.
    hQuery:query-open            no-error.

    if  not error-status:error   and 
        not hQuery:query-off-end then do:
        hQuery:get-first() no-error.
        
        if  hBuffer:avail then do:
            do  iCont = 1 to num-entries(cReturn):
                hField = hBuffer:buffer-field(entry(iCont,cReturn)) no-error.
    
                if  not error-status:error then
                    assign p-retorna = if p-retorna = "" then hField:buffer-value else p-retorna + "," + hField:buffer-value.
                else if p-retorna <> "" then
                    assign p-retorna = ",".
            end.
        end.
    end.
    else
        return "nok".

    return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-conecta-ems5 wWindow 
PROCEDURE pi-conecta-ems5 :
/*------------------------------------------------------------------------------
  Purpose:     pi-conecta-ems5
  Parameters:  Entrada l-conecta = Sim - Conecta Bancos
                                   NÆo - Desconecta Bancos
               Sa¡da   i-erro-conecta = Se ocorreram erros de conexÆo
  Notes:       Conecta bancos do EMS5
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER l-conecta      as logical no-undo.
DEFINE OUTPUT PARAMETER l-erro-conecta as logical no-undo init no.
DEF VAR h-btb009za AS HANDLE NO-UNDO.
DEF VAR l-conectado AS LOGICAL NO-UNDO.

RUN btb/btb009za.p PERSISTENT SET h-btb009za.

for first param-global no-lock:
end.

if not avail param-global then do:
    /** Parƒmetros Globais nÆo Cadastrados **/
    run piCriaErro (input 16, 
                    input 'EMS':U, 
                    input "":U).

    assign l-erro-conecta = yes.

    return "NOK":U.

end.

/** Solicita‡Æo para Conectar bancos do Financeiro **/
if  l-conecta then do:
    /** Verifica se bancos do Financeiro nÆo estÆo conectados **/
    if  not connected("emsbas") or 
        not connected("emsfin") or 
        not connected("emsuni") then do:
        run pi-conecta-bco IN h-btb009za (Input 1,                          /*versao api */
                                          Input 1,                          /* 1 - conexÆo, 2 - desconexÆo */
                                          Input param-global.empresa-prin,  /* cod empresa*/
                                          Input "all", 
                                          Output Table tt_erros_conexao).

        if  return-value <> "OK":U then do:
            FOR EACH tt_erros_conexao no-lock:
                /** Erro **/
                /* run piCriaErro (INPUT tt_erros_conexao.cd-erro, */
                /*                 INPUT 'EMS':U,                  */
                /*                 INPUT tt_erros_conexao.param-1) */.
                assign l-erro-conecta = yes.
            end.
        end.
    END.
    else do:
        assign l-conectado = yes.
    end.
end.
/** Solicita‡Æo para Desconectar bancos do Financeiro **/
if not l-conecta or l-erro-conecta then do:
    if not l-conectado then do:
        if  connected("emsbas") or 
            connected("emsfin") or 
            connected("emsuni") then do:
            run pi-conecta-bco IN h-btb009za (Input 1,          /*versao api */
                                              Input 2,          /* 1 - conexÆo, 2 - desconexÆo */
                                              Input param-global.empresa-prin,  /* cod empresa*/
                                              Input "all", 
                                              Output Table tt_erros_conexao).

            if return-value <> "OK":U then do:
                FOR EACH tt_erros_conexao no-lock:
                    /** Erro **/
                    /* run piCriaErro (INPUT tt_erros_conexao.cd-erro,  */
                    /*                 INPUT 'EMS':U,                   */
                    /*                 INPUT tt_erros_conexao.param-1). */
                    assign l-erro-conecta = yes.
                end.
            end.
        end.
    end.
end.

IF VALID-HANDLE(h-btb009za) THEN
   DELETE PROCEDURE h-btb009za.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valor wWindow 
PROCEDURE pi-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define variable cAux as character  no-undo.

run buscaValor IN hDBOParam (INPUT pParam,
                             INPUT-OUTPUT pValor1).

IF num-entries(pValor1) > 0  then do:
    {utp/ut-liter.i NÆo * }
    assign cAux = trim(return-value).
    if entry(1,pValor1) = cAux then do:
        assign tgGGF-1:CHECKED IN FRAME fPage0 = no.
    end.
    else do:
        if tgGGF-1:sensitive in frame fPage0 then
            ASSIGN tgGGF-1:CHECKED IN FRAME fPage0 = yes.
        else 
            assign tgGGF-1:CHECKED IN FRAME fPage0 = no.
    end.

    if entry(2,pValor1) = cAux then do:
        assign tgGGF-2:CHECKED IN FRAME fPage0 = no.
    end.
    else do:
        if tgGGF-2:sensitive in frame fPage0 then
            assign tgGGF-2:CHECKED IN FRAME fPage0 = yes.
        else 
            assign tgGGF-2:CHECKED IN FRAME fPage0 = no.
    END.

    if entry(3,pValor1) = cAux then do:
        assign tgGGF-3:CHECKED IN FRAME fPage0 = no.
    END.
    else do:
        if tgGGF-3:sensitive in frame fPage0 then
            assign tgGGF-3:CHECKED IN FRAME fPage0 = yes.
        else 
            assign tgGGF-3:CHECKED IN FRAME fPage0 = no.
    END.

    if entry(4,pValor1) = cAux then do:
        assign tgGGF-4:CHECKED IN FRAME fPage0 = no.
    END.
    else do:
        if tgGGF-4:sensitive in frame fPage0 then
            assign tgGGF-4:CHECKED IN FRAME fPage0 = yes.
        else 
            assign tgGGF-4:CHECKED IN FRAME fPage0 = no.
    END.

    if entry(5,pValor1) = cAux then do:
        assign tgGGF-5:CHECKED IN FRAME fPage0 = no.
    END.
    else do:
        if tgGGF-5:sensitive in frame fPage0 then
            assign tgGGF-5:CHECKED IN FRAME fPage0 = yes.
        else 
            assign tgGGF-5:CHECKED IN FRAME fPage0 = no.
    END.

    if entry(6,pValor1) = cAux then do:
        assign tgGGF-6:CHECKED IN FRAME fPage0 = no.
    END.
    else do:
        if tgGGF-6:sensitive in frame fPage0 then
            assign tgGGF-6:CHECKED IN FRAME fPage0 = yes.
        else 
            assign tgGGF-6:CHECKED IN FRAME fPage0 = no.
    END.
END.

RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piBuscaFormatoCCusto wWindow 
PROCEDURE piBuscaFormatoCCusto :
/*------------------------------------------------------------------------------  
  Purpose:     piBuscaFormatoCCusto projeto 105
  Parameters:  <none>
  Notes:       busca o formato de centro de custo no ems5
------------------------------------------------------------------------------*/
    /*este handle ‚ destruido dentra da rpocedure pi_retorna_formato_ccusto */
    IF NOT VALID-HANDLE(h_api_ccusto) THEN 
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    RUN pi_retorna_formato_ccusto IN h_api_ccusto (INPUT "",                    /* EMPRESA EMS2 */
                                                   INPUT "",                    /* PLANO CCUSTO */
                                                   INPUT TODAY,                 /* DATA DE TRANSACAO */
                                                   OUTPUT p_cod_format_cta_ctbl,/* FORMATO CCUSTO */
                                                   OUTPUT TABLE tt_log_erro).   /* ERROS */
    
    IF CAN-FIND (FIRST tt_log_erro NO-LOCK)THEN DO:
        {cdp/cdunif001b.i}
    END.
    ELSE 
        ASSIGN fiFormato = p_cod_format_cta_ctbl.
    
    DISP fiFormato WITH FRAME fPage0.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piHabilitaCampos wWindow 
PROCEDURE piHabilitaCampos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if      not tgPercursoEqpto:checked   in frame fPage0
    and not tgCadastEqpto:checked     in frame fPage0
    and not tgCadastMotoris:CHECKED   in frame fPage0
    and not tgAbastec:checked         in frame fPage0 then do:
    assign  cDestinyFile:sensitive    in frame fPage0 = no
            cDestinyFile:screen-value in frame fPage0 = "".
end.
else do:
    assign cDestinyFile:sensitive    in frame fPage0 = yes.
end.

if  can-find(first funcao 
             where funcao.cd-funcao = "adm-fas-ems-5.00":U 
               and funcao.ativo) then do:
    IF        tgIntegracao:checked     IN FRAME fPage0 THEN 
       ASSIGN tgCriabem:SENSITIVE      IN FRAME fPage0 = YES.
    ELSE DO: 
       ASSIGN tgCriabem:SENSITIVE      IN FRAME fPage0 = NO
              tgCriabem:CHECKED        IN FRAME fPage0 = NO.
    END.
    
    IF        tgCriabem:CHECKED        IN FRAME fPage0 THEN DO:
       ASSIGN cbDescricao:SENSITIVE    IN FRAME fPage0 = YES
              fmvto:sensitive          IN FRAME fpage0 = YES.
    END.
    ELSE DO:
       ASSIGN cbDescricao:SENSITIVE    IN FRAME fPage0 = NO
              fmvto      :sensitive    IN FRAME fpage0 = NO
              fmvto      :screen-value IN FRAME fpage0 = ""
              fdesmov    :screen-value IN FRAME fpage0 = "".
    END.
end.
else
    assign tgCriabem  :sensitive    in frame {&frame-name} = no
           cbDescricao:sensitive    in frame {&frame-name} = no
           fmvto      :sensitive    in frame {&frame-name} = no
           fdesmov    :sensitive    in frame {&frame-name} = no
           tgCriabem  :checked      in frame {&frame-name} = no
           cbDescricao:screen-value in frame {&frame-name} = cbDescricao:entry(1)
           fmvto      :screen-value in frame {&frame-name} = ""
           fdesmov    :screen-value in frame {&frame-name} = "".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao wWindow 
PROCEDURE piIntegracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define variable cAux as character  no-undo.
   {utp/ut-liter.i Sim}
   

      ASSIGN   tgGGF-1:HIDDEN IN FRAME                fPage0 = YES
               tgGGF-2:HIDDEN IN FRAME                fPage0 = YES
               tgGGF-3:HIDDEN IN FRAME                fPage0 = YES
               tgGGF-4:HIDDEN IN FRAME                fPage0 = YES
               tgGGF-5:HIDDEN IN FRAME                fPage0 = YES
               tgGGF-6:HIDDEN IN FRAME                fPage0 = YES
               tgValor:HIDDEN IN FRAME                fPage0 = YES
               cbValor:HIDDEN IN FRAME                fPage0 = YES
               rs-term:hidden in frame                fPage0 = yes
               rs-param3:HIDDEN IN FRAME              fPage0 = YES
               tgPercursoEqpto:HIDDEN in frame        fPage0 = yes
               tgCadastEqpto:HIDDEN in frame          fPage0 = yes
               tgCadastMotoris:HIDDEN in frame        fPage0 = yes
               tgAbastec:HIDDEN in frame              fPage0 = yes
               cDestinyFile:hidden in frame           fPage0 = YES
               tgIntegracao:VISIBLE IN FRAME          fpage0 = YES
               tgCriabem:VISIBLE IN FRAME             fpage0 = YES
               cbDescricao:VISIBLE IN FRAME           fpage0 = YES
               fdesmov:VISIBLE in frame               fPage0 = yes
               fmvto:visible in frame                 {&frame-name} = yes
               fmvto:sensitive in frame               {&frame-name} = yes
               fmvto:screen-value in FRAME            {&frame-name} = entry(4,mab-param-integr.des-valor)
               fiFormato:HIDDEN IN FRAME              fPage0 = yes
               tgUn:HIDDEN IN FRAME                   fPage0 = yes
               rs-formato:HIDDEN IN FRAME             fPage0 = yes.        
       
        {utp/ut-liter.i "Descri‡Æo_do_Bem"}
        ASSIGN cbDescricao:LABEL = RETURN-VALUE.
        &if "{&FNC_MULTI_IDIOMA}" = "POR" &then
             DEFINE VARIABLE cAuxTraducao005 AS CHARACTER NO-UNDO.
             ASSIGN cAuxTraducao005 = {frinc/i00fr122.i 03}.
             RUN utp/ut-list.p (INPUT-OUTPUT cAuxTraducao005).
             ASSIGN    c-lista  = cAuxTraducao005.
        &else
             ASSIGN c-lista  = {frinc/i00fr122.i 03}.
        &endif
        ASSIGN cbDescricao:LIST-ITEMS IN FRAME fPage0 = c-lista
               cbDescricao:screen-value in frame fPage0 = cbDescricao:entry(int(entry(3,mab-param-integr.des-valor))).
        
    /* VALIDAR O MOTIVO DE DESMOBILIZA€ÇO E O INDICADOR ECONâMICO */
    if  fmvto:screen-value in frame fPage0 ne "" then do:
        IF  NOT CONNECTED("emsbas") OR 
            NOT CONNECTED("emsfin") OR 
            NOT CONNECTED("emsuni") THEN
            RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
        ELSE
            RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
        assign cAux = "cod_motiv_desmob,des_motiv_desmob".
        run pi-busca-ems5(input "motiv_desmob",
                          input "motiv_desmob.cod_motiv_desmob = ~"" + fmvto:screen-value in frame fPage0 + "~"",
                          input-output cAux).

        if  return-value = "ok" and num-entries(cAux) = 2 then
            assign fmvto  :screen-value in frame fpage0 = entry(1,cAux)
                   fdesmov:screen-value in frame fpage0 = entry(2,cAux).

        IF  NOT CONNECTED("emsbas") OR 
            NOT CONNECTED("emsfin") OR 
            NOT CONNECTED("emsuni") THEN
            RUN  pi-conecta-ems5(INPUT NO, OUTPUT l-erro-conecta).
        ELSE
            RUN  pi-conecta-ems5(INPUT YES, OUTPUT l-erro-conecta).
    end.

    apply "entry" to fmvto in frame fpage0.

    if  num-entries(mab-param-integr.des-valor) > 0 then do:
        {utp/ut-liter.i Sim}
        assign cAux = trim(return-value).
        if entry(1,mab-param-integr.des-valor) = cAux then do:
            assign tgIntegracao:checked in frame fPage0 = yes.
        end.
        else do:
            assign tgIntegracao:checked in frame fPage0 = no.
        end.
        if entry(2,mab-param-integr.des-valor) = cAux then do:
            assign tgCriabem:checked in frame fPage0 = yes.
        end.
        else do:
            assign tgCriabem:checked in frame fPage0 = no.
        end.
    END.

    run piHabilitaCampos in this-procedure.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piMostraErros wWindow 
PROCEDURE piMostraErros :
/*------------------------------------------------------------------------------  
  Purpose:     piMostraErros
  Parameters:  <none>
  Notes:       Verifica a temp-table de erros da BO e mostra em tela as mensagens
------------------------------------------------------------------------------*/
/** Instancia aplicativo **/
{method/showmessage.i1}
/** Busca erros na BO **/
run getRowErrors in hDBOParam (output table RowErrors).
/** Mostra caixa com erros **/
{method/showmessage.i2 &Modal="YES"}
/** Limpa temp-tables de erros **/
run emptyRowErrors in hDBOParam.

return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

