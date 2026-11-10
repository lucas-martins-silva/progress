&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wWindow


/* Temp-Table and Buffer definitions                                    */
DEFINE TEMP-TABLE tt-mab-histor-ativid NO-UNDO LIKE mab-histor-ativid
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
{include/i-prgvrs.i AB0138D1 2.00.00.002} /*** "010002" 01/11/2023 08:39:06  ***/
/*:T*******************************************************************************
** Copyright TOTVS S.A. (2009)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da TOTVS, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
&ENDIF

CREATE WIDGET-POOL.

/* Preprocessors Definitions ---                                      */
&GLOBAL-DEFINE Program        AB0138D1
&GLOBAL-DEFINE Version        2.00.00.002

&GLOBAL-DEFINE WindowType     Detail

&GLOBAL-DEFINE Folder         Yes
&GLOBAL-DEFINE InitialPage    1
&GLOBAL-DEFINE FolderLabels   P g. 1

&GLOBAL-DEFINE page0Widgets   btOK btCancel btHelp2
&GLOBAL-DEFINE page1Widgets   fi-ct-implant fi-bem-patrimonial fi-bem-indice ~
                              tg-cred-pis tg-cred-cofins fi-nro-parcelas ~
                              fi-vl-icms-destac tg-cred-csll ed-narrativa ~
                              fi-txt-inf-fiscais 

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "N£mero" column-label "Número"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsistência".

{frbo/bofr013.i2 shared}

/* Parameters Definitions ---                                           */
def input param p-ep-codigo         no-undo like mab-histor-ativid.ep-codigo.
def input param p-cod-eqpto         no-undo like mab-histor-ativid.cod-eqpto.
def input param p-dat-cadastro      no-undo like mab-histor-ativid.dat-cadastro.
def input param p-ccusto  as char   no-undo.
def input param h-bofr013 as handle no-undo.

/*def input-output param table for tt_criacao_bem_pat_api_5.*/
/*def input param p-caller        as handle    no-undo.*/
/* Local Variable Definitions ---                                       */
def var h-bofr016   as handle        no-undo.
def var h-bofr007   as handle        no-undo.
def var cAux        as char          no-undo.
def var wh-pesquisa as widget-handle no-undo.

{include/i_fncrowid.i} /* Pre-processador da substituicao do RECID pelo ROWID */

&IF {&ROWID_READY} = YES &THEN
    def new global shared variable v_rec_cta_pat      as rowid  no-undo.
    def new global shared variable v_rec_plano_ccusto as rowid  no-undo.
&ELSE
    def new global shared variable v_rec_cta_pat      as recid  no-undo format ">>>>>>9":U initial ?.
    def new global shared variable v_rec_plano_ccusto as recid  no-undo format ">>>>>>9":U.
&ENDIF

def new global shared variable adm-broker-hdl     as handle no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fpage0

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rtToolBar rtKeys btOK btCancel btHelp2 
&Scoped-Define DISPLAYED-OBJECTS fi-ep-codigo fi-cod-eqpto fiDescModelo ~
fi-dat-cadastro 

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

DEFINE VARIABLE fi-cod-eqpto AS CHARACTER FORMAT "x(16)" 
     LABEL "Equipamento":R14 
     VIEW-AS FILL-IN 
     SIZE 16.86 BY .88.

DEFINE VARIABLE fi-dat-cadastro AS DATE FORMAT "99/99/9999" 
     LABEL "Data":R5 
     VIEW-AS FILL-IN 
     SIZE 10.86 BY .88.

DEFINE VARIABLE fi-ep-codigo AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "Empresa":R9 
     VIEW-AS FILL-IN 
     SIZE 6.86 BY .88.

DEFINE VARIABLE fiDescModelo AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 37.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rtKeys
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 90 BY 3.5.

DEFINE RECTANGLE rtToolBar
     EDGE-PIXELS 2 GRAPHIC-EDGE    
     SIZE 90 BY 1.42
     BGCOLOR 7 .

DEFINE VARIABLE ed-narrativa AS CHARACTER 
     VIEW-AS EDITOR NO-WORD-WRAP MAX-CHARS 2000 SCROLLBAR-HORIZONTAL SCROLLBAR-VERTICAL
     SIZE 37.29 BY 6.75 NO-UNDO.

DEFINE VARIABLE fi-bem-indice AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE fi-bem-patrimonial AS INTEGER FORMAT ">>>>>>>>9":U INITIAL 0 
     LABEL "Bem Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ct-implant AS CHARACTER FORMAT "X(18)":U 
     LABEL "Conta Patrimonial" 
     VIEW-AS FILL-IN 
     SIZE 21.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-exerc-cred-csll AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Exerc. Cr‚dito CSLL" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-nro-parcelas AS INTEGER FORMAT "99":U INITIAL 0 
     LABEL "Nro Parcelas" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-txt-inf-fiscais AS CHARACTER FORMAT "X(256)":U INITIAL "Informa‡äes Fiscais" 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE fi-vl-cred-cofins AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Cr‚dito COFINS" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-cred-pis AS DECIMAL FORMAT "->>>>>,>>>,>>9.99":U INITIAL 0 
     LABEL "Valor Cr‚dito PIS" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-vl-icms-destac AS DECIMAL FORMAT ">>>,>>>,>>9.99":U INITIAL 0 
     LABEL "ICMS Destacado" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82 BY 7.75.

DEFINE VARIABLE tg-cred-cofins AS LOGICAL INITIAL no 
     LABEL "Credita COFINS" 
     VIEW-AS TOGGLE-BOX
     SIZE 14.29 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cred-csll AS LOGICAL INITIAL no 
     LABEL "Credita CSLL" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-cred-pis AS LOGICAL INITIAL no 
     LABEL "Credita PIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.57 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fpage0
     fi-ep-codigo AT ROW 1.46 COL 24.14 COLON-ALIGNED
     fi-cod-eqpto AT ROW 2.46 COL 24.14 COLON-ALIGNED
     fiDescModelo AT ROW 2.46 COL 41.14 COLON-ALIGNED HELP
          "Descri‡Æo Modelo Equipamento" NO-LABEL
     fi-dat-cadastro AT ROW 3.46 COL 24.14 COLON-ALIGNED
     btOK AT ROW 18.58 COL 2
     btCancel AT ROW 18.58 COL 13
     btHelp2 AT ROW 18.58 COL 80
     rtToolBar AT ROW 18.38 COL 1
     rtKeys AT ROW 1.21 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 90.14 BY 19
         FONT 1.

DEFINE FRAME fPage1
     fi-bem-patrimonial AT ROW 1.54 COL 21.57 COLON-ALIGNED
     fi-bem-indice AT ROW 1.54 COL 33.72 COLON-ALIGNED NO-LABEL
     fi-ct-implant AT ROW 2.54 COL 21.57 COLON-ALIGNED
     tg-cred-pis AT ROW 4.5 COL 9.57
     tg-cred-cofins AT ROW 4.5 COL 25.57
     fi-nro-parcelas AT ROW 5.5 COL 23.43 COLON-ALIGNED
     fi-vl-icms-destac AT ROW 6.5 COL 23.43 COLON-ALIGNED
     fi-vl-cred-pis AT ROW 7.5 COL 23.43 COLON-ALIGNED
     fi-vl-cred-cofins AT ROW 8.5 COL 23.43 COLON-ALIGNED
     tg-cred-csll AT ROW 9.5 COL 25.43
     fi-exerc-cred-csll AT ROW 10.5 COL 23.43 COLON-ALIGNED
     ed-narrativa AT ROW 4.58 COL 45 NO-LABEL
     fi-txt-inf-fiscais AT ROW 3.71 COL 4 COLON-ALIGNED NO-LABEL
     RECT-9 AT ROW 3.96 COL 2
    WITH 1 DOWN KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 3.57 ROW 6.17
         SIZE 84.43 BY 11.75
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields,Window,Query
   Add Fields to: Neither
   Temp-Tables and Buffers:
      TABLE: tt-mab-histor-ativid T "?" NO-UNDO mgfro mab-histor-ativid
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
         TITLE              = ""
         HEIGHT             = 19.04
         WIDTH              = 90.57
         MAX-HEIGHT         = 38.63
         MAX-WIDTH          = 182.86
         VIRTUAL-HEIGHT     = 38.63
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
/* REPARENT FRAME */
ASSIGN FRAME fPage1:FRAME = FRAME fpage0:HANDLE.

/* SETTINGS FOR FRAME fpage0
   FRAME-NAME                                                           */
/* SETTINGS FOR FILL-IN fi-cod-eqpto IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dat-cadastro IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-ep-codigo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fiDescModelo IN FRAME fpage0
   NO-ENABLE                                                            */
/* SETTINGS FOR FRAME fPage1
   Custom                                                               */
/* SETTINGS FOR FILL-IN fi-txt-inf-fiscais IN FRAME fPage1
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

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME fPage1
/* Query rebuild information for FRAME fPage1
     _Options          = "SHARE-LOCK KEEP-EMPTY"
     _Query            is NOT OPENED
*/  /* FRAME fPage1 */
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
    /* if  not can-find(first tt_criacao_bem_pat_api_5)  or                                    */
    /*     tt_criacao_bem_pat_api_5.tta_des_bem_pat = "" then                                  */
    /*     run pi-cria-tt.                                                                     */
    /* else do:                                                                                */
    /*     /*Se campo de descri‡Æo estiver diferente de vazio ‚ pq deu erro na chama da api.*/ */
    /*     run pi-chama-api.                                                                   */
    /*     if  return-value = "nok" then                                                       */
    /*         return "nok".                                                                   */
    /* end.                                                                                    */
    run pi-cria-tt.

    APPLY "CLOSE":U TO THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fPage1
&Scoped-define SELF-NAME fi-ct-implant
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ct-implant wWindow
ON MOUSE-SELECT-DBLCLICK OF fi-ct-implant IN FRAME fPage1 /* Conta Patrimonial */
or "f5" of fi-ct-implant DO:
    DEF VAR h-bo-cta-pat AS HANDLE NO-UNDO.
    DEF VAR c-cod AS CHAR.
    DEF VAR c-des AS CHAR.
    
    RUN prgfin\fas\fas914wd.py PERSISTENT SET h-bo-cta-pat.
    RUN pi_zoom_cta_pat IN h-bo-cta-pat (OUTPUT c-cod,
                                         OUTPUT c-des,
                                         OUTPUT TABLE tt_log_erro).
    
    IF c-cod <> "" THEN
        ASSIGN fi-ct-implant:SCREEN-VALUE IN FRAM fPage1 = c-cod.
    

    /*mostra os erros*/
    {cdp/cdunif001b.i}

    IF VALID-HANDLE(h-bo-cta-pat) THEN
        DELETE PROCEDURE h-bo-cta-pat.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cred-cofins
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cred-cofins wWindow
ON VALUE-CHANGED OF tg-cred-cofins IN FRAME fPage1 /* Credita COFINS */
DO:
    assign fi-vl-cred-cofins:sensitive = self:checked.

    if  not fi-vl-cred-cofins:sensitive then
        assign fi-vl-cred-cofins:screen-value = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cred-csll
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cred-csll wWindow
ON VALUE-CHANGED OF tg-cred-csll IN FRAME fPage1 /* Credita CSLL */
DO:
    assign fi-exerc-cred-csll:sensitive = self:checked.

    if  not fi-exerc-cred-csll:sensitive then
        assign fi-exerc-cred-csll:screen-value = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-cred-pis
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-cred-pis wWindow
ON VALUE-CHANGED OF tg-cred-pis IN FRAME fPage1 /* Credita PIS */
DO:
    assign fi-vl-cred-pis:sensitive = self:checked.

    if  not fi-vl-cred-pis:sensitive then
        assign fi-vl-cred-pis:screen-value = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define FRAME-NAME fpage0
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wWindow 


/*:T--- L¢gica para inicializa‡Æo do programam ---*/
{window/mainblock.i}

fi-ct-implant:load-mouse-pointer("image/lupa.cur").

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

    
    assign fi-ep-codigo   :screen-value in frame fpage0 = string(p-ep-codigo)
           fi-cod-eqpto   :screen-value in frame fpage0 = p-cod-eqpto   
           fi-dat-cadastro:screen-value in frame fpage0 = string(p-dat-cadastro).

    run frbo/bofr016.p persistent set h-bofr016.
    run frbo/bofr007.p persistent set h-bofr007.
    run openQueryStatic in h-bofr016 ("Main").
    run openQueryStatic in h-bofr007 ("Main").
    run goToKey         in h-bofr007 (input p-ep-codigo,
                                      input p-cod-eqpto).

    if  return-value = "ok" then do:
        run getCharField in h-bofr007 (input  "cod-model",
                                       output cAux).

        {method/referencefields.i &HandleDBOLeave="h-bofr016"
                                  &KeyValue1="cAux"
                                  &FieldName1="des-model"
                                  &FieldScreen1="fiDescModelo"
                                  &Frame1="fPage0"} 

    end.
    run destroy in h-bofr016.
    run destroy in h-bofr007.

    find first tt_criacao_bem_pat_api_5 no-error.
    if  avail tt_criacao_bem_pat_api_5 then do with frame fPage1:
        assign fi-ct-implant     :screen-value = string(tt_criacao_bem_pat_api_5.tta_cod_cta_pat)
               fi-bem-patrimonial:screen-value = string(tt_criacao_bem_pat_api_5.tta_num_bem_pat)
               fi-bem-indice     :screen-value = string(tt_criacao_bem_pat_api_5.tta_num_seq_bem_pat)
               fi-nro-parcelas   :screen-value = string(tt_criacao_bem_pat_api_5.ttv_num_parc_pis_cofins)
               fi-vl-cred-pis    :screen-value = string(tt_criacao_bem_pat_api_5.tta_val_cr_pis)
               fi-vl-cred-cofins :screen-value = string(tt_criacao_bem_pat_api_5.tta_val_cr_cofins)
               fi-exerc-cred-csll:screen-value = string(tt_criacao_bem_pat_api_5.ttv_num_exerc_cr_csll)
               ed-narrativa      :screen-value = tt_criacao_bem_pat_api_5.tta_des_narrat_bem_pat
               fi-vl-icms-destac :screen-value = string(tt_criacao_bem_pat_api_5.ttv_val_aquis_bem_pat)
               tg-cred-pis       :checked      = tt_criacao_bem_pat_api_5.tta_log_cr_pis
               tg-cred-cofins    :checked      = tt_criacao_bem_pat_api_5.tta_log_cr_cofins
               tg-cred-csll      :checked      = tt_criacao_bem_pat_api_5.ttv_log_cr_csll.

        /*apply "leave" to fi-conta-patrimonial.
        apply "leave" to fi-plano-cc.*/
    end.
    apply "leave"         to fi-cod-eqpto         in frame fpage0.
    apply "value-changed" to tg-cred-pis          in frame fpage1.
    apply "value-changed" to tg-cred-cofins       in frame fpage1.
    apply "value-changed" to tg-cred-csll         in frame fpage1.
    /*apply "entry"         to fi-conta-patrimonial in frame fpage1.*/

    return "ok".
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

    if  not valid-handle(h-bofr016)        or 
        h-bofr016:type      <> "procedure" or
        h-bofr016:file-name <> "frbo~\bofr016.p" then
        run frbo/bofr016.p persistent set h-bofr016.

    run openQueryStatic in h-bofr016 (input "Main":U) no-error.

    return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt wWindow 
PROCEDURE pi-cria-tt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first tt_criacao_bem_pat_api_5 no-error.
    if  not avail tt_criacao_bem_pat_api_5 then
        create tt_criacao_bem_pat_api_5.

    assign /*tt_criacao_bem_pat_api_5.tta_cod_unid_organ_ext   = fi-ep-codigo:screen-value in frame fPage0*/
           tt_criacao_bem_pat_api_5.tta_cod_cta_pat          = input frame fPage1 fi-ct-implant
           tt_criacao_bem_pat_api_5.tta_num_bem_pat          = input frame fpage1 fi-bem-patrimonial
           tt_criacao_bem_pat_api_5.tta_num_seq_bem_pat      = input frame fPage1 fi-bem-indice
           tt_criacao_bem_pat_api_5.tta_log_cr_pis           = tg-cred-pis   :checked in frame fPage1
           tt_criacao_bem_pat_api_5.tta_log_cr_cofins        = tg-cred-cofins:checked in frame fPage1
           tt_criacao_bem_pat_api_5.ttv_num_parc_pis_cofins  = input frame fPage1 fi-nro-parcelas
           tt_criacao_bem_pat_api_5.tta_val_cr_pis           = input frame fPage1 fi-vl-cred-pis
           tt_criacao_bem_pat_api_5.tta_val_cr_cofins        = input frame fPage1 fi-vl-cred-cofins
           tt_criacao_bem_pat_api_5.ttv_log_cr_csll          = tg-cred-csll:checked in frame fPage1
           tt_criacao_bem_pat_api_5.ttv_num_exerc_cr_csll    = input frame fPage1 fi-exerc-cred-csll
           tt_criacao_bem_pat_api_5.tta_des_narrat_bem_pat   = input frame fPage1 ed-narrativa
           tt_criacao_bem_pat_api_5.tta_qtd_bem_pat_represen = 1
           tt_criacao_bem_pat_api_5.tta_log_bem_imptdo       = no
           tt_criacao_bem_pat_api_5.tta_cod_finalid_econ_ext = "0"
           tt_criacao_bem_pat_api_5.tta_log_bem_imptdo       = no
           tt_criacao_bem_pat_api_5.ttv_log_erro             = no
           tt_criacao_bem_pat_api_5.tta_num_id_bem_pat       = 0
           tt_criacao_bem_pat_api_5.ttv_val_aquis_bem_pat    = input frame fPage1 fi-vl-icms-destac.

    return "ok".
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

