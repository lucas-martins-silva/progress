&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
*/
&Scoped-define WINDOW-NAME CURRENT-WINDOW
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS V-table-Win 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i GGCD0401-V01 2.00.00.028 } /*** "010028" ***/

{utp/ut-glob.i}

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i ggcd0401-v01 GGP}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

DEFINE VARIABLE c-mes1             AS CHARACTER NO-UNDO FORMAT "X(19)".
DEFINE VARIABLE c-mes2             AS CHARACTER NO-UNDO FORMAT "X(31)".
DEFINE VARIABLE cCpfCnpjAtual      AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCpfCnpjAterado    AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCpfCnpjCobAtual   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cCpfCnpjCobAterado AS CHARACTER NO-UNDO.


/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
DEF VAR v-row-parent  AS ROWID    NO-UNDO.
DEF VAR hprogramzoom  AS HANDLE   NO-UNDO.

DEF BUFFER b-gg-ext-emitente FOR gg-ext-emitente.

DEF BUFFER b-emitente FOR emitente.

{cdp/cd0666.i}
{ggp/ggapi048.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES emitente
&Scoped-define FIRST-EXTERNAL-TABLE emitente


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR emitente.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS emitente.char-1 
&Scoped-define ENABLED-TABLES emitente
&Scoped-define FIRST-ENABLED-TABLE emitente
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-49 RECT-50 
&Scoped-Define DISPLAYED-FIELDS emitente.char-1 
&Scoped-define DISPLAYED-TABLES emitente
&Scoped-define FIRST-DISPLAYED-TABLE emitente
&Scoped-Define DISPLAYED-OBJECTS i-cod-grupo c-desc-grupo tgNFProdNtRefer ~
c-estado-civil dt-nasc c-profissao c-rg c-orgao-rg c-estado-rg ~
c-des-perfil c-art cb-tp-prof i-cod-vinc c-des-vinc fi-cod-estab-adm ~
fiNomeEstabAdm i-cod-eng c-des-eng tg-fatura tg-logistica tb-local-chegada ~
fi-des-porto-base fi-desc-porto 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS i-cod-grupo c-estado-civil dt-nasc ~
c-profissao c-rg c-orgao-rg c-estado-rg emitente.char-1 c-art ~
cb-tp-prof i-cod-vinc i-cod-eng fi-des-porto-base 
&Scoped-define ADM-ASSIGN-FIELDS i-cod-grupo c-estado-civil dt-nasc ~
c-profissao c-rg c-orgao-rg c-estado-rg emitente.char-1 c-art ~
cb-tp-prof i-cod-vinc i-cod-eng 
&Scoped-define ADM-MODIFY-FIELDS i-cod-grupo c-estado-civil dt-nasc ~
c-profissao c-rg c-orgao-rg c-estado-rg emitente.char-1 c-art ~
cb-tp-prof i-cod-vinc i-cod-eng 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
nome-abrev|y|y|mgadm.emitente.nome-abrev
cod-emitente|y|y|mgadm.emitente.cod-emitente
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nome-abrev,cod-emitente",
     Keys-Supplied = "nome-abrev,cod-emitente"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-estado-civil AS INTEGER FORMAT ">9" INITIAL 0 
     LABEL "Estado Civil" 
     VIEW-AS COMBO-BOX 
     LIST-ITEM-PAIRS "Casado",1,
                     "Desquitado",2,
                     "Divorciado",3,
                     "Solteiro",4,
                     "Vi£vo",5,
                     "Outros",6
     DROP-DOWN-LIST
     SIZE 19 BY 1.

DEFINE VARIABLE cb-tp-prof AS INTEGER FORMAT ">9":U INITIAL 1 
     LABEL "Tipo Profissional" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEM-PAIRS "Outro",1,
                     "TÇcnico",2,
                     "Engenheiro",3
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE c-art AS CHARACTER FORMAT "X(20)":U 
     LABEL "ART" 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-eng AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-perfil AS CHARACTER FORMAT "X(15)":U 
     LABEL "Perfil" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-vinc AS CHARACTER FORMAT "X(30)":U 
     VIEW-AS FILL-IN 
     SIZE 26.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-grupo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 26 BY .88 NO-UNDO.

DEFINE VARIABLE c-estado-rg AS CHARACTER FORMAT "X(2)" 
     LABEL "Estado" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88.

DEFINE VARIABLE c-orgao-rg AS CHARACTER FORMAT "X(8)" 
     LABEL "Org∆o Emissor" 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE VARIABLE c-profissao AS CHARACTER FORMAT "X(20)" 
     LABEL "Profiss∆o" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88.

DEFINE VARIABLE c-rg AS CHARACTER FORMAT "X(19)" 
     LABEL "RG/CREA" 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE dt-nasc AS DATE FORMAT "99/99/9999" INITIAL 01/01/001 
     LABEL "Nascimento" 
     VIEW-AS FILL-IN 
     SIZE 9.57 BY .88.

DEFINE VARIABLE fi-cod-estab-adm AS CHARACTER FORMAT "x(5)" 
     LABEL "Estab Adm" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE fi-des-porto-base AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Porto" 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88.

DEFINE VARIABLE fi-desc-porto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 58.29 BY .88 NO-UNDO.

DEFINE VARIABLE fiNomeEstabAdm AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 14.72 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-eng AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Engenheiro" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-cod-grupo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "Grp Imp. Retená∆o" 
     VIEW-AS FILL-IN 
     SIZE 5.72 BY .88.

DEFINE VARIABLE i-cod-vinc AS INTEGER FORMAT ">>>>>>>>9" INITIAL 0 
     LABEL "Emitente Vinc" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 5.29.

DEFINE RECTANGLE RECT-49
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 1.42.

DEFINE RECTANGLE RECT-50
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 2.

DEFINE VARIABLE tb-local-chegada AS LOGICAL INITIAL no 
     LABEL "Local de Chegada" 
     VIEW-AS TOGGLE-BOX
     SIZE 18.72 BY .83 NO-UNDO.

DEFINE VARIABLE tg-fatura AS LOGICAL INITIAL no 
     LABEL "Local de Transbordo" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 TOOLTIP "Local de Transbordo para Transporte" NO-UNDO.

DEFINE VARIABLE tg-logistica AS LOGICAL INITIAL no 
     LABEL "Ativo p/ Log°stica" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .83 TOOLTIP "Ativo p/ Log°stica" NO-UNDO.

DEFINE VARIABLE tgNFProdNtRefer AS LOGICAL INITIAL no 
     LABEL "Envia NF Produtor para Nota Referencia" 
     VIEW-AS TOGGLE-BOX
     SIZE 31 BY .83 TOOLTIP "Envia NF do Produtor para Nota de Referencia" NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-cod-grupo AT ROW 1.38 COL 16.14 COLON-ALIGNED
     c-desc-grupo AT ROW 1.38 COL 22.29 COLON-ALIGNED NO-LABEL
     tgNFProdNtRefer AT ROW 1.42 COL 52.43
     c-estado-civil AT ROW 2.88 COL 16.14 COLON-ALIGNED HELP
          "Estado Civil do Produtor"
     dt-nasc AT ROW 2.88 COL 46 COLON-ALIGNED HELP
          "Data de Nascimento do Emitente"
     c-profissao AT ROW 2.88 COL 64.14 COLON-ALIGNED HELP
          "Profiss∆o do Produtor"
     c-rg AT ROW 3.88 COL 16.14 COLON-ALIGNED HELP
          "RG"
     c-orgao-rg AT ROW 3.88 COL 46 COLON-ALIGNED HELP
          "Orgao Emissor"
     c-estado-rg AT ROW 3.88 COL 64.14 COLON-ALIGNED HELP
          "Estado"
     emitente.char-1 AT ROW 3.96 COL 80.86 NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 2 BY .75
     c-des-perfil AT ROW 4.88 COL 46 COLON-ALIGNED WIDGET-ID 122
     c-art AT ROW 4.88 COL 64.14 COLON-ALIGNED
     cb-tp-prof AT ROW 5.88 COL 16.14 COLON-ALIGNED
     i-cod-vinc AT ROW 5.88 COL 46 COLON-ALIGNED WIDGET-ID 126
     c-des-vinc AT ROW 5.88 COL 81.72 RIGHT-ALIGNED NO-LABEL WIDGET-ID 124
     fi-cod-estab-adm AT ROW 6.88 COL 16.14 COLON-ALIGNED HELP
          "Estabelecimento Administrador"
     fiNomeEstabAdm AT ROW 6.88 COL 22.29 COLON-ALIGNED NO-LABEL
     i-cod-eng AT ROW 6.88 COL 46 COLON-ALIGNED
     c-des-eng AT ROW 6.88 COL 81.72 RIGHT-ALIGNED NO-LABEL
     tg-fatura AT ROW 8.17 COL 18.43
     tg-logistica AT ROW 8.17 COL 40.43
     tb-local-chegada AT ROW 8.17 COL 59.43
     fi-des-porto-base AT ROW 9 COL 16.14 COLON-ALIGNED WIDGET-ID 78
     fi-desc-porto AT ROW 9 COL 22.57 COLON-ALIGNED NO-LABEL WIDGET-ID 80
     "Geral" VIEW-AS TEXT
          SIZE 5.43 BY .54 AT ROW 2.58 COL 2.43
     "Fiscal" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 1.04 COL 2.43 WIDGET-ID 4
     "Log°stica" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 8 COL 2.43 WIDGET-ID 84
     RECT-1 AT ROW 2.67 COL 1.43
     RECT-49 AT ROW 1.13 COL 1.43 WIDGET-ID 2
     RECT-50 AT ROW 8.08 COL 1.43 WIDGET-ID 82
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.emitente
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.25
         WIDTH              = 83.57.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{include/i_dbtype.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-art IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-des-eng IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-des-perfil IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-vinc IN FRAME f-main
   NO-ENABLE ALIGN-R                                                    */
/* SETTINGS FOR FILL-IN c-desc-grupo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-estado-civil IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-estado-rg IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-orgao-rg IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-profissao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN c-rg IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR COMBO-BOX cb-tp-prof IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN emitente.char-1 IN FRAME f-main
   ALIGN-L 1 2 3                                                        */
ASSIGN 
       emitente.char-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN dt-nasc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-cod-estab-adm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-des-porto-base IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-desc-porto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiNomeEstabAdm IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-cod-eng IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-cod-grupo IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN i-cod-vinc IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tb-local-chegada IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-fatura IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tg-logistica IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX tgNFProdNtRefer IN FRAME f-main
   NO-ENABLE                                                            */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME c-estado-rg
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estado-rg V-table-Win
ON F5 OF c-estado-rg IN FRAME f-main /* Estado */
DO:
   {include/zoomvar.i &prog-zoom  = "unzoom/z01un007.w"
                      &campo      = c-estado-rg
                      &campozoom  = estado}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-estado-rg V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-estado-rg IN FRAME f-main /* Estado */
DO:
  APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-tp-prof
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-prof V-table-Win
ON LEAVE OF cb-tp-prof IN FRAME f-main /* Tipo Profissional */
DO:

  {utp/ut-liter.i "Engenheiro" * R}
  IF INPUT FRAME {&FRAME-NAME} cb-tp-prof = RETURN-VALUE THEN
      ENABLE c-art WITH FRAME {&FRAME-NAME}.
  ELSE
      DISABLE c-art WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tp-prof V-table-Win
ON VALUE-CHANGED OF cb-tp-prof IN FRAME f-main /* Tipo Profissional */
DO:
  {utp/ut-liter.i "Engenheiro" * R}
  IF INPUT FRAME {&FRAME-NAME} cb-tp-prof = RETURN-VALUE THEN
      ENABLE c-art WITH FRAME {&FRAME-NAME}.
  ELSE
      DISABLE c-art WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estab-adm
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-adm V-table-Win
ON F5 OF fi-cod-estab-adm IN FRAME f-main /* Estab Adm */
DO:
    {include/zoomvar.i &prog-zoom  = adzoom/z01ad107.w
                       &campo      = fi-cod-estab-adm
                       &campozoom  = cod-estabel
                       &campo2     = fiNomeEstabAdm
                       &campozoom2 = nome}            
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-adm V-table-Win
ON LEAVE OF fi-cod-estab-adm IN FRAME f-main /* Estab Adm */
DO:
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} fi-cod-estab-adm NO-ERROR.
    IF AVAIL estabelec THEN
        ASSIGN fiNomeEstabAdm = estabelec.nome.
    ELSE
        ASSIGN fiNomeEstabAdm = "":U.

    DISPLAY fiNomeEstabAdm WITH FRAME {&FRAME-NAME}.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estab-adm V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estab-adm IN FRAME f-main /* Estab Adm */
DO:
    APPLY "F5":U TO SELF.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-des-porto-base
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-des-porto-base V-table-Win
ON F5 OF fi-des-porto-base IN FRAME f-main /* Porto */
DO:
    {method/zoomfields.i &ProgramZoom  = "ggzoom/z01gg582.w"
                         &FieldZoom1   = "cod-porto"
                         &FieldScreen1 = "fi-des-porto-base"
                         &Frame1       = "{&FRAME-NAME}"
                         &FieldZoom2   = "nom-porto"
                         &FieldScreen2 = "fi-desc-porto"
                         &Frame2       = "{&FRAME-NAME}"
                         &EnableImplant= "yes"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-des-porto-base V-table-Win
ON LEAVE OF fi-des-porto-base IN FRAME f-main /* Porto */
DO:
    FIND FIRST gg-porto-base NO-LOCK
         WHERE gg-porto-base.cod-porto = INPUT FRAME {&FRAME-NAME} fi-des-porto-base NO-ERROR.
    ASSIGN fi-desc-porto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL gg-porto-base THEN gg-porto-base.nom-porto ELSE "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-des-porto-base V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-des-porto-base IN FRAME f-main /* Porto */
DO:
    APPLY "F5":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-eng
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-eng V-table-Win
ON F5 OF i-cod-eng IN FRAME f-main /* Engenheiro */
DO:
    {include/zoomvar.i &prog-zoom  = adzoom/z01ad098.w
                     &campo      = i-cod-eng
                     &campozoom  = cod-emitente
                     &campo2     = c-des-eng
                     &campozoom2 = nome-emite}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-eng V-table-Win
ON LEAVE OF i-cod-eng IN FRAME f-main /* Engenheiro */
DO:
   FIND FIRST b-emitente
         WHERE b-emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} i-cod-eng NO-LOCK NO-ERROR.
    IF AVAIL b-emitente THEN DO:
        DISPLAY b-emitente.nome-emit @ c-des-eng WITH FRAME {&FRAME-NAME}.

    END.
    ELSE DO:
        DISPLAY "":U @ c-des-eng WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-eng V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-eng IN FRAME f-main /* Engenheiro */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-grupo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grupo V-table-Win
ON F5 OF i-cod-grupo IN FRAME f-main /* Grp Imp. Retená∆o */
DO:
    {include/zoomvar.i &prog-zoom  = ggp/gg1074-z01.w
                     &campo        = i-cod-grupo
                     &campozoom    = cod-grupo 
                     &campo        = c-desc-grupo
                     &campozoom2   = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grupo V-table-Win
ON LEAVE OF i-cod-grupo IN FRAME f-main /* Grp Imp. Retená∆o */
DO:
  FIND FIRST gg-grupo-tax NO-LOCK 
      WHERE gg-grupo-tax.cod-grupo = int(i-cod-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
  IF  AVAIL gg-grupo-tax THEN
      ASSIGN c-desc-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = gg-grupo-tax.descricao.
  ELSE
      ASSIGN c-desc-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = "":U.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-grupo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-grupo IN FRAME f-main /* Grp Imp. Retená∆o */
DO:
  APPLY 'f5'TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cod-vinc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-vinc V-table-Win
ON F5 OF i-cod-vinc IN FRAME f-main /* Emitente Vinc */
DO:
    {include/zoomvar.i &prog-zoom  = adzoom/z01ad098.w
                     &campo      = i-cod-vinc
                     &campozoom  = cod-emitente
                     &campo2     = c-des-vinc
                     &campozoom2 = nome-emite}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-vinc V-table-Win
ON LEAVE OF i-cod-vinc IN FRAME f-main /* Emitente Vinc */
DO:
   FIND FIRST b-emitente
         WHERE b-emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} i-cod-vinc NO-LOCK NO-ERROR.
    IF AVAIL b-emitente THEN DO:
        DISPLAY b-emitente.nome-emit @ c-des-vinc WITH FRAME {&FRAME-NAME}.
    END.
    ELSE DO:
        DISPLAY "":U @ c-des-vinc WITH FRAME {&FRAME-NAME}.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cod-vinc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cod-vinc IN FRAME f-main /* Emitente Vinc */
DO:
  APPLY 'f5' TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


i-cod-eng        :LOAD-MOUSE-POINTER("image/lupa.cur":U).
fi-cod-estab-adm :LOAD-MOUSE-POINTER("image/lupa.cur":U).
fi-des-porto-base:LOAD-MOUSE-POINTER("image/lupa.cur":U).

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
PROCEDURE adm-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Dispatched to this procedure when the Record-
               Source has a new row available.  This procedure
               tries to get the new row (or foriegn keys) from
               the Record-Source and process it.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/row-head.i}

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "emitente"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "emitente"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
PROCEDURE disable_UI :
/*------------------------------------------------------------------------------
  Purpose:     DISABLE the User Interface
  Parameters:  <none>
  Notes:       Here we clean-up the user-interface by deleting
               dynamic widgets we have created and/or hide 
               frames.  This procedure is usually called when
               we are ready to "clean-up" after running.
------------------------------------------------------------------------------*/
  /* Hide all frames. */
  HIDE FRAME f-main.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-add-record V-table-Win 
PROCEDURE local-add-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  ASSIGN c-estado-civil:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.

  ASSIGN i-cod-grupo:SENSITIVE IN FRAME {&FRAME-NAME}             = YES
         fi-cod-estab-adm:SENSITIVE IN FRAME {&FRAME-NAME}        = YES
         fi-des-porto-base:SENSITIVE IN FRAME {&FRAME-NAME}       = YES
         i-cod-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = "0":U
         c-desc-grupo:SENSITIVE IN FRAME {&FRAME-NAME}            = NO
         c-desc-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}         = "":U
         .

  ASSIGN tg-fatura:SENSITIVE IN FRAME {&FRAME-NAME}       = YES
         tg-fatura:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = 'no':U
         tg-logistica:SCREEN-VALUE IN FRAME {&FRAME-NAME} = 'no':U
         tgNFProdNtRefer:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /*:T Ponha na pi-validate todas as validaá‰es */
    /*:T N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    ASSIGN  INPUT FRAME {&FRAME-NAME} 
            c-profissao 
            c-estado-civil 
            c-rg                                       
            c-orgao-rg                                 
            c-estado-rg                                
            dt-nasc     
            i-cod-grupo
            fi-cod-estab-adm
            tgNFProdNtRefer
            cb-tp-prof
            c-des-perfil
            i-cod-eng
            c-art
            fi-des-porto-base.


   /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    IF  RETURN-VALUE = 'ADM-ERROR':U then 
        RETURN 'ADM-ERROR':U.

    /*:T Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  

    /* Code placed here will execute AFTER standard behavior.    */

    FIND gg-ext-emitente EXCLUSIVE-LOCK
        WHERE gg-ext-emitente.cod-emitente = emitente.cod-emitente  NO-ERROR.
    IF  NOT AVAIL gg-ext-emitente THEN DO:
        CREATE gg-ext-emitente.
        ASSIGN gg-ext-emitente.cod-emitente = emitente.cod-emitente.
    END.

    ASSIGN gg-ext-emitente.profissao      = c-profissao
           gg-ext-emitente.estado-civil   = c-estado-civil
           gg-ext-emitente.rg             = c-rg       
           gg-ext-emitente.orgao-rg       = c-orgao-rg 
           gg-ext-emitente.estado-rg      = c-estado-rg
           gg-ext-emitente.dat-nascimento = dt-nasc    
           gg-ext-emitente.cod-grupo      = i-cod-grupo
           gg-ext-emitente.ind-tipo-prof  = cb-tp-prof
           gg-ext-emitente.des-perf       = c-des-perfil
           gg-ext-emitente.num-livre-5    = i-cod-vinc  /* Vincular Cliente Gest∆o comercial o campo cod-emit-vinc foi criado como char, utilizar o num-livre-5 */  
           gg-ext-emitente.cod-engenheiro = i-cod-eng
           gg-ext-emitente.art            = c-art
           gg-ext-emitente.log-1          = tgNFProdNtRefer
           gg-ext-emitente.cod-estab-adm  = fi-cod-estab-adm
           gg-ext-emitente.int-1          = fi-des-porto-base.

    FIND CURRENT gg-ext-emitente NO-LOCK NO-ERROR.

    /*********************************************************************************/
    ASSIGN tg-fatura:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    IF  AVAIL emitente THEN DO:
        FIND FIRST fat-ext-emitente EXCLUSIVE-LOCK
            WHERE fat-ext-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
        IF  AVAIL fat-ext-emitente THEN 
            ASSIGN  fat-ext-emitente.l-fatura         = LOGICAL(tg-fatura:SCREEN-VALUE IN FRAME {&FRAME-NAME})
                    fat-ext-emitente.ativo-logistica  = LOGICAL(tg-logistica:SCREEN-VALUE IN FRAME {&FRAME-NAME}).

    END.

    /* ** Melhorias Gr∆os - FO2279038 ** */
    IF tb-local-chegada:CHECKED IN FRAME {&FRAME-NAME}  THEN DO:
        FIND FIRST gg-loc-chegada EXCLUSIVE-LOCK
            WHERE gg-loc-chegada.codEmitente = emitente.cod-emitente NO-ERROR.
        IF NOT AVAIL gg-loc-chegada THEN DO:
            CREATE gg-loc-chegada.
            ASSIGN gg-loc-chegada.codEmitente = emitente.cod-emitente
                   gg-loc-chegada.nomeAbrev   = emitente.nome-abrev.
        END.
        ELSE DO:
             ASSIGN gg-loc-chegada.nomeAbrev  = emitente.nome-abrev.
        END.
    END.
    ELSE DO:
        FIND FIRST gg-loc-chegada EXCLUSIVE-LOCK
            WHERE gg-loc-chegada.codEmitente = emitente.cod-emitente NO-ERROR.
        IF AVAIL gg-loc-chegada THEN
            DELETE gg-loc-chegada.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  FIND gg-ext-emitente EXCLUSIVE-LOCK
      WHERE gg-ext-emitente.cod-emitente = emitente.cod-emitente  NO-ERROR.
  IF AVAIL gg-ext-emitente THEN
     DELETE gg-ext-emitente.

  FOR EACH gg-ext-cont-emit EXCLUSIVE-LOCK 
      WHERE gg-ext-cont-emit.cod-emitente = emitente.cod-emitente :
      DELETE gg-ext-cont-emit.
  END.
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    disable c-profissao
            c-estado-civil 
            c-rg
            c-orgao-rg
            c-estado-rg
            dt-nasc
            i-cod-grupo
            fi-cod-estab-adm
            fi-des-porto-base
            tgNFProdNtRefer
            cb-tp-prof
            i-cod-eng
            i-cod-vinc
            c-des-perfil
            c-art
            with frame {&frame-name}. 

    ASSIGN i-cod-grupo:SENSITIVE IN FRAME {&FRAME-NAME}  = NO
           c-desc-grupo:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    ASSIGN dt-nasc:SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    ASSIGN tg-fatura:SENSITIVE IN FRAME {&FRAME-NAME}        = NO
           tg-logistica:SENSITIVE IN FRAME {&FRAME-NAME}     = NO
           tb-local-chegada:SENSITIVE IN FRAME {&FRAME-NAME} = NO
           tgNFProdNtRefer:SENSITIVE IN FRAME {&FRAME-NAME}  = NO.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------            
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

   ASSIGN tg-fatura:SENSITIVE IN FRAME {&FRAME-NAME}    = NO
          tg-fatura:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "NO":U.


   IF  AVAIL emitente THEN DO:
       FIND FIRST fat-ext-emitente NO-LOCK
            WHERE fat-ext-emitente.cod-emitente = emitente.cod-emitente NO-ERROR.
       IF AVAIL fat-ext-emitente THEN 
         ASSIGN tg-fatura:SCREEN-VALUE IN FRAME {&FRAME-NAME}             = STRING(fat-ext-emitente.l-fatura)
                tg-logistica:SCREEN-VALUE IN FRAME {&FRAME-NAME}          = STRING(fat-ext-emitente.ativo-logistica)
                .
   END.

   FIND FIRST gg-loc-chegada NO-LOCK
       WHERE gg-loc-chegada.codEmitente = emitente.cod-emitente NO-ERROR.
   IF AVAIL gg-loc-chegada THEN
       ASSIGN tb-local-chegada:CHECKED IN FRAME {&FRAME-NAME} = YES.
   ELSE 
       ASSIGN tb-local-chegada:CHECKED IN FRAME {&FRAME-NAME} = NO.

   ASSIGN i-cod-grupo:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
   
   {utp/ut-liter.i Porto * r}
   ASSIGN fi-des-porto-base:LABEL IN FRAME {&FRAME-NAME} = RETURN-VALUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */

    ENABLE c-profissao
           c-estado-civil
           c-rg
           c-orgao-rg
           c-estado-rg
           dt-nasc
           fi-cod-estab-adm
           fi-des-porto-base
           i-cod-grupo
           cb-tp-prof
           i-cod-eng
           i-cod-vinc
           c-des-perfil
           c-art
           WITH FRAME {&FRAME-NAME}.    

    ASSIGN cCpfCnpjAtual    = emitente.cgc
           cCpfCnpjCobAtual = emitente.cgc-cob

           i-cod-grupo     :SENSITIVE IN FRAME {&FRAME-NAME} = YES
           c-desc-grupo    :SENSITIVE IN FRAME {&FRAME-NAME} = NO
           dt-nasc         :SENSITIVE IN FRAME {&FRAME-NAME} = YES
           tg-fatura       :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           tb-local-chegada:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           tgNFProdNtRefer :SENSITIVE IN FRAME {&FRAME-NAME} = TRUE
           tg-logistica    :SENSITIVE IN FRAME {&FRAME-NAME} = CAN-FIND(FIRST usuar_grp_usuar NO-LOCK 
                                                                        WHERE usuar_grp_usuar.cod_usuario   = c-seg-usuario 
                                                                         AND (usuar_grp_usuar.cod_grp_usuar = 'TRP' OR
                                                                              usuar_grp_usuar.cod_grp_usuar = 'SUP')).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF  AVAIL emitente THEN DO:
      FIND gg-ext-emitente NO-LOCK 
          WHERE gg-ext-emitente.cod-emitente  = emitente.cod-emitente NO-ERROR.

      FIND FIRST gg-ext-cont-emit NO-LOCK
           WHERE gg-ext-cont-emit.cod-emitente = emitente.cod-emitente  NO-ERROR.

      ASSIGN c-profissao   :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente OR gg-ext-emitente.profissao = ? THEN "":U ELSE gg-ext-emitente.profissao)
             c-estado-civil:SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "1":U ELSE STRING(gg-ext-emitente.estado-civil))
             c-rg          :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "":U  ELSE gg-ext-emitente.rg)                 
             c-orgao-rg    :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "":U  ELSE gg-ext-emitente.orgao-rg)        
             c-estado-rg   :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "":U  ELSE gg-ext-emitente.estado-rg)       
             dt-nasc       :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN ?   ELSE STRING(gg-ext-emitente.dat-nascimento))   
             i-cod-grupo   :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "0":U ELSE string(gg-ext-emitente.cod-grupo))
             fi-cod-estab-adm:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = (IF NOT AVAIL gg-ext-emitente THEN "":U ELSE STRING(gg-ext-emitente.cod-estab-adm))
             fi-des-porto-base:SCREEN-VALUE IN FRAME {&FRAME-NAME} = (IF NOT AVAIL gg-ext-emitente THEN "0":U ELSE STRING(gg-ext-emitente.int-1))
             cb-tp-prof    :SCREEN-VALUE IN FRAME {&frame-name}    = (IF NOT AVAIL gg-ext-emitente THEN "1":U ELSE string(gg-ext-emitente.ind-tipo-prof))
             c-des-perfil  :SCREEN-VALUE IN FRAME {&frame-name}    = (IF NOT AVAIL gg-ext-emitente THEN "":U ELSE string(gg-ext-emitente.des-perf))
             i-cod-eng     :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "0":U ELSE string(gg-ext-emitente.cod-engenheiro))
             i-cod-vinc     :SCREEN-VALUE IN FRAME {&FRAME-NAME}   = (IF NOT AVAIL gg-ext-emitente THEN "0":U ELSE string(gg-ext-emitente.num-livre-5))  /* Vincular Cliente Gest∆o comercial o campo cod-emit-vinc foi criado como char, utilizar o num-livre-5 */  
             c-art         :SCREEN-VALUE IN FRAME {&FRAME-NAME}    = (IF NOT AVAIL gg-ext-emitente THEN "":U  ELSE string(gg-ext-emitente.art))
             tgNFProdNtRefer:CHECKED IN FRAME {&FRAME-NAME}        = (IF     AVAIL gg-ext-emitente AND gg-ext-emitente.log-1 THEN YES ELSE NO)
             .
  END.                     

  FIND FIRST gg-grupo-tax NO-LOCK
        WHERE gg-grupo-tax.cod-grupo = INT(i-cod-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
   IF AVAIL gg-grupo-tax THEN
       ASSIGN c-desc-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = STRING(gg-grupo-tax.descricao).
   ELSE
       ASSIGN c-desc-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "":U.

   APPLY 'leave'   TO i-cod-vinc        IN FRAME {&FRAME-NAME}.
   APPLY 'leave'   TO i-cod-eng         IN FRAME {&FRAME-NAME}.
   APPLY 'leave'   TO fi-cod-estab-adm  IN FRAME {&FRAME-NAME}.
   APPLY "LEAVE":U TO fi-des-porto-base IN FRAME {&FRAME-NAME}.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.

    assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*:T------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /*:T Validaá∆o de dicion†rio */

/*:T    Segue um exemplo de validaá∆o de programa */
/*       find tabela where tabela.campo1 = c-variavel and               */
/*                         tabela.campo2 > i-variavel no-lock no-error. */

      /*:T Este include deve ser colocado sempre antes do ut-msgs.p */
/*       {include/i-vldprg.i}                                             */
/*       run utp/ut-msgs.p (input "show":U, input 7, input return-value). */
/*       return 'ADM-ERROR':U.                                            */

IF NOT CAN-FIND(FIRST gg-param) THEN RETURN "OK":U.

IF INPUT FRAME {&FRAME-NAME} i-cod-eng <> 0  THEN DO:
    FIND FIRST b-gg-ext-emitente NO-LOCK
        WHERE b-gg-ext-emitente.cod-emitente = INPUT FRAME {&FRAME-NAME} i-cod-eng NO-ERROR.
    IF NOT AVAIL b-gg-ext-emitente THEN DO:

        RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 34893,
                           INPUT "":U).

        APPLY "entry":U TO i-cod-eng IN FRAME {&FRAME-NAME}.
        RETURN "adm-error":U. 
    END.
END.

IF  int(i-cod-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) <> 0 THEN DO:
   FIND FIRST gg-grupo-tax NO-LOCK 
       WHERE gg-grupo-tax.cod-grupo = int(i-cod-grupo:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.
   IF  NOT AVAIL gg-grupo-tax THEN DO:

       {utp/ut-liter.i "n∆o cadastrado"}
       ASSIGN c-mes1 = RETURN-VALUE.
       {utp/ut-liter.i "deve estar cadastrado na tabela"}
       ASSIGN c-mes2 = RETURN-VALUE.


       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT 34894,
                          INPUT c-mes1 + "~~" + c-mes2).

       APPLY "entry":U TO i-cod-grupo IN FRAME {&FRAME-NAME}.
       RETURN "adm-error":U.
   END.
END.

IF NOT AVAIL gg-param THEN
    FIND FIRST gg-param NO-LOCK NO-ERROR.

IF INPUT FRAME {&FRAME-NAME} fi-cod-estab-adm <> "":u THEN DO:
    FIND FIRST estabelec NO-LOCK
        WHERE estabelec.cod-estabel = INPUT FRAME {&FRAME-NAME} fi-cod-estab-adm NO-ERROR.
    IF NOT AVAIL estabelec THEN DO:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Estabelecimento_Administrador" *}
        RUN utp/ut-msgs.p (INPUT "SHOW",
                           INPUT 47,
                           INPUT RETURN-VALUE).
        APPLY "ENTRY":U TO fi-cod-estab-adm IN FRAME {&FRAME-NAME}.
        RETURN "ADM-ERROR":U.
    END.
END.
ELSE DO:
    IF gg-param.idi-estab-adm = 3 THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW",
                          INPUT 53579,
                          INPUT "").
    END.
END.

IF INPUT FRAME {&FRAME-NAME} fi-des-porto-base <> 0 AND
    NOT CAN-FIND(FIRST gg-porto-base
                 WHERE gg-porto-base.cod-porto = INPUT FRAME {&FRAME-NAME} fi-des-porto-base) THEN DO:

    {utp/ut-liter.i "Porto" *}
    RUN utp/ut-msgs.p (INPUT "SHOW",
                       INPUT 47,
                       INPUT RETURN-VALUE).
    APPLY "ENTRY":U TO fi-des-porto-base IN FRAME {&FRAME-NAME}.
    RETURN "ADM-ERROR":U.
END.


RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "cgc").
ASSIGN cCpfCnpjAterado = RETURN-VALUE.
ASSIGN cCpfCnpjAterado = REPLACE(cCpfCnpjAterado,".","")
       cCpfCnpjAterado = REPLACE(cCpfCnpjAterado,"/","")
       cCpfCnpjAterado = REPLACE(cCpfCnpjAterado,"-","").

RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE, INPUT "cgc-cob").
ASSIGN cCpfCnpjCobAterado = RETURN-VALUE.
ASSIGN cCpfCnpjCobAterado = REPLACE(cCpfCnpjCobAterado,".","")
       cCpfCnpjCobAterado = REPLACE(cCpfCnpjCobAterado,"/","")
       cCpfCnpjCobAterado = REPLACE(cCpfCnpjCobAterado,"-","").


EMPTY TEMP-TABLE ttEmitentes  NO-ERROR.
EMPTY TEMP-TABLE ttParametros NO-ERROR.


IF  cCpfCnpjAtual <> cCpfCnpjAterado THEN DO:
    CREATE ttEmitentes.
    ASSIGN ttEmitentes.cod-cpf-cnpj = cCpfCnpjAterado
           ttEmitentes.log-avaliado = NO.
END.

IF  cCpfCnpjCobAterado <> ""
AND cCpfCnpjAterado  <> cCpfCnpjCobAterado
AND cCpfCnpjCobAtual <> cCpfCnpjCobAterado THEN DO:
    CREATE ttEmitentes.
    ASSIGN ttEmitentes.cod-cpf-cnpj = cCpfCnpjCobAterado
           ttEmitentes.log-avaliado = NO.
END.

IF  CAN-FIND(FIRST ttEmitentes) THEN DO:
    CREATE ttParametros.
    ASSIGN ttParametros.processo   = 8  /* Indicar qual processo est† sendo executado, gginc/i01gg00726.i */
           ttParametros.enviaEmail = YES
           ttParametros.corpoEmail = "".

    RUN ggp/ggapi048.p (INPUT-OUTPUT TABLE ttEmitentes,
                        INPUT        TABLE ttParametros,
                        OUTPUT       TABLE tt-erro).

    FOR EACH ttEmitentes
        WHERE ttEmitentes.idi-avaliac > 1: /* 1 Inativo, 2 Alerta, 3 Bloqueio */
        CREATE tt-erro.
        ASSIGN tt-erro.i-sequen = 0
               tt-erro.cd-erro  = IF ttEmitentes.idi-avaliac = 2 THEN 56450 ELSE 56457
               tt-erro.mensagem = ttEmitentes.mensagem.
    END.

    IF  CAN-FIND(FIRST tt-erro) THEN DO:
        RUN cdp/cd0666.w (INPUT TABLE tt-erro).

        /* Se encontrar mensagem diferente 56450 - Alerta ent∆o parar processo */
        IF  CAN-FIND (FIRST tt-erro WHERE tt-erro.cd-erro <> 56450) THEN
            RETURN "ADM-ERROR":U.
    END.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "nome-abrev" "emitente" "nome-abrev"}
  {src/adm/template/sndkycas.i "cod-emitente" "emitente" "cod-emitente"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "emitente"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

