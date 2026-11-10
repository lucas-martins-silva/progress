&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 

*/
&Scoped-define WINDOW-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS w-cadsim 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC0103 2.00.00.032 } /*** "010032" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i BC0103 MBC}
&ENDIF




/*------------------------------------------------------------------------

  File: 

  Description: 

  Input Parameters: 
      <none>

  Output Parameters: 
      <none>

  Version: 1.00.000
  
  History: 
          
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var i-cod-campo     as inte.
def var i-sequencia     as inte.
def var c-formato       as char.
def var i-nr-inteiro    as inte.
def var i-nr-decimal    as inte.
def var i-num           as int  no-undo.
def var c-traducao      as char.

/* temp-tables e variaveis usadas na fun‡Æo Teste da etiqueta ----------*/
{bcp/bcapi002.i}
{cdp/cd0666.i}

/* variavel que indica para bcapi007 que ‚ pra gerar teste -------------*/
def new global shared var vg-teste-etiqueta     as logical no-undo init no.
/* variaveis com informa‡äes para o teste ------------------------------*/
def new global shared var vg-geracao-word       as character no-undo.
def new global shared var vg-impres-ems-teste   as character no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE w-cadsim
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-cad

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-teste bt-editor bt-va-para rt-button 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */
&Scoped-define List-1 bt-up bt-dn bt-add bt-del 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR w-cadsim AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU mi-arquivo 
       MENU-ITEM mi-primeiro    LABEL "&Primeiro"      ACCELERATOR "CTRL-HOME"
       MENU-ITEM mi-anterior    LABEL "An&terior"      ACCELERATOR "CTRL-CURSOR-LEFT"
       MENU-ITEM mi-proximo     LABEL "Pr&¢ximo"       ACCELERATOR "CTRL-CURSOR-RIGHT"
       MENU-ITEM mi-ultimo      LABEL "&éltimo"        ACCELERATOR "CTRL-END"
       MENU-ITEM mi-va-para     LABEL "&V  para"       ACCELERATOR "CTRL-T"
       MENU-ITEM mi-pesquisa    LABEL "Pes&quisa"      ACCELERATOR "CTRL-F5"
       RULE
       MENU-ITEM mi-incluir     LABEL "&Incluir"       ACCELERATOR "CTRL-INS"
       MENU-ITEM mi-copiar      LABEL "C&opiar"        ACCELERATOR "CTRL-C"
       MENU-ITEM mi-alterar     LABEL "A&lterar"       ACCELERATOR "CTRL-A"
       MENU-ITEM mi-eliminar    LABEL "&Eliminar"      ACCELERATOR "CTRL-DEL"
       RULE
       MENU-ITEM mi-desfazer    LABEL "&Desfazer"      ACCELERATOR "CTRL-U"
       MENU-ITEM mi-cancelar    LABEL "&Cancelar"      ACCELERATOR "CTRL-F4"
       RULE
       MENU-ITEM mi-salvar      LABEL "Sal&var"        ACCELERATOR "CTRL-S"
       RULE
       MENU-ITEM mi-consultas   LABEL "Co&nsultas"     ACCELERATOR "CTRL-L"
       MENU-ITEM mi-imprimir    LABEL "&Relat¢rios"    ACCELERATOR "CTRL-P"
       MENU-ITEM m_Teste        LABEL "Teste"          ACCELERATOR "CTRL-E"
       RULE
       MENU-ITEM mi-sair        LABEL "&Sair"          ACCELERATOR "CTRL-X".

DEFINE SUB-MENU mi-ajuda 
       MENU-ITEM mi-conteudo    LABEL "&Conteudo"     
       MENU-ITEM mi-sobre       LABEL "&Sobre..."     .

DEFINE MENU m-cadastro MENUBAR
       SUB-MENU  mi-arquivo     LABEL "&Arquivo"      
       SUB-MENU  mi-ajuda       LABEL "A&juda"        .


/* Definitions of handles for SmartObjects                              */
DEFINE VARIABLE h_b01cl016 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_b03cl015 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-cadsim AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-exihel AS HANDLE NO-UNDO.
DEFINE VARIABLE h_p-navega AS HANDLE NO-UNDO.
DEFINE VARIABLE h_q01cl015 AS HANDLE NO-UNDO.
DEFINE VARIABLE h_v01cl015 AS HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-add 
     IMAGE-UP FILE "image~\im-nex1":U
     IMAGE-INSENSITIVE FILE "image~\ii-nex1":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bt-del 
     IMAGE-UP FILE "image~\im-pre":U
     IMAGE-INSENSITIVE FILE "image~\ii-pre":U
     LABEL "" 
     SIZE 5 BY 1.

DEFINE BUTTON bt-dn 
     IMAGE-UP FILE "image~\im-down2":U
     IMAGE-INSENSITIVE FILE "image~\ii-down2":U
     LABEL "" 
     SIZE 3.57 BY 1.5.

DEFINE BUTTON bt-editor 
     IMAGE-UP FILE "image~\im-hist":U
     IMAGE-INSENSITIVE FILE "image~\ii-hist":U
     LABEL "" 
     SIZE 3.57 BY 1.33.

DEFINE BUTTON bt-teste 
     IMAGE-UP FILE "image~\im-teste-etq":U
     IMAGE-INSENSITIVE FILE "image~\ii-teste-etq":U
     LABEL "Test" 
     SIZE 3.57 BY 1.25 TOOLTIP "Teste".

DEFINE BUTTON bt-up 
     IMAGE-UP FILE "image~\im-up2":U
     IMAGE-INSENSITIVE FILE "image~\ii-up1":U
     LABEL "" 
     SIZE 3.57 BY 1.5.

DEFINE BUTTON bt-va-para 
     IMAGE-UP FILE "image~\im-enter":U
     IMAGE-INSENSITIVE FILE "image~\ii-enter":U
     LABEL "" 
     SIZE 3.57 BY 1.33.

DEFINE RECTANGLE rt-button
     EDGE-PIXELS 2 GRAPHIC-EDGE  
     SIZE 89 BY 1.46
     BGCOLOR 7 .


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-cad
     bt-teste AT ROW 1.13 COL 70.29
     bt-up AT ROW 8.5 COL 86
     bt-dn AT ROW 10.5 COL 86
     bt-add AT ROW 11 COL 36
     bt-del AT ROW 12.5 COL 36
     bt-editor AT ROW 12.5 COL 86
     bt-va-para AT ROW 14.25 COL 86
     rt-button AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 89.14 BY 16.29.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: w-cadsim
   Allow: Basic,Browse,DB-Fields,Smart,Window,Query
   Container Links: 
   Other Settings: COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW w-cadsim ASSIGN
         HIDDEN             = YES
         TITLE              = "Manuten‡Æo de Tipo de Etiqueta"
         HEIGHT             = 16.33
         WIDTH              = 89
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = yes
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU m-cadastro:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB w-cadsim 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}
{include/w-cadsim.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW w-cadsim
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-cad
                                                                        */
/* SETTINGS FOR BUTTON bt-add IN FRAME f-cad
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON bt-del IN FRAME f-cad
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON bt-dn IN FRAME f-cad
   NO-ENABLE 1                                                          */
/* SETTINGS FOR BUTTON bt-up IN FRAME f-cad
   NO-ENABLE 1                                                          */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
THEN w-cadsim:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME w-cadsim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON END-ERROR OF w-cadsim /* Manuten‡Æo de Tipo de Etiqueta */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
   RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL w-cadsim w-cadsim
ON WINDOW-CLOSE OF w-cadsim /* Manuten‡Æo de Tipo de Etiqueta */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-add
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-add w-cadsim
ON CHOOSE OF bt-add IN FRAME f-cad
DO:
  /*
    run pi-posicao-query  in h_q-<query>(output v-row-1).
    run pi-posicao-browse in h_b-<browse>(output v-row-2).
    run pi-add-browse     in h_b-<browse-formacao>(input v-row-1, input v-row-2).
    RUN dispatch IN h_b-<browse-formacao> ('open-query':U).
  */
  
    run pi-busca-campo in h_b03cl015.
    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-del
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-del w-cadsim
ON CHOOSE OF bt-del IN FRAME f-cad
DO:
    run pi-busca-campo in h_b01cl016.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-dn
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-dn w-cadsim
ON CHOOSE OF bt-dn IN FRAME f-cad
DO:
    run pi-down in h_b01cl016.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-editor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-editor w-cadsim
ON CHOOSE OF bt-editor IN FRAME f-cad
DO:
  run pi-apply in h_b01cl016.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-teste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-teste w-cadsim
ON CHOOSE OF bt-teste IN FRAME f-cad /* Test */
DO:
    def var v-registro        as character no-undo.
    def var v-quant-registros as integer   no-undo.
    def var v-tipo-dados      as integer   no-undo.
    def var v-arquivo-saida   as character no-undo.
    def var v-geracao-word    as character no-undo.
    def var h-acomp           as handle    no-undo.
    def var c-rel-arq         as character no-undo.
    def var v-impres-ems      as character no-undo.

    /* Localiza registro atual --------------------------------------------------*/  
    run send-records in h_q01cl015 ('tipo-etiqueta':U, output v-registro).
    find tipo-etiqueta no-lock
        where rowid(tipo-etiqueta) = to-rowid(v-registro) no-error.

    if  not avail tipo-etiqueta then
        return.
    
    /* Solicita informa‡äes para o teste ----------------------------------------*/
    run bcp/bc0103h.w (tipo-etiqueta.tipo-etiq,
                       output v-quant-registros,
                       output v-tipo-dados,
                       output v-arquivo-saida,
                       output v-geracao-word,
                       output v-impres-ems).
    if  v-quant-registros = 0 then
        return.    

    /* Inicializa acompanhamento do processo ------------------------------------*/
    session:set-wait-state("general":U).
    run utp/ut-acomp.p persistent set h-acomp.
    {utp/ut-liter.i Executando_teste_do_tipo_etiqueta}
    run pi-inicializar in h-acomp (trim(return-value)).

    do  on stop undo, leave:
        /* Executa API que gera a massa de dados para teste --------------------*/
        {utp/ut-liter.i Gerando_dados_para_teste...}
        run pi-acompanhar in h-acomp (trim(return-value)).
        run bcp/bcapi015.p (tipo-etiqueta.tipo-etiq,
                            v-quant-registros,
                            v-tipo-dados,
                            v-arquivo-saida,
                            input-output table tt-etiqueta,
                            input-output table tt-erro).
        if  return-value = 'nok':U then do:
            run cdp/cd0666.w (input table tt-erro).
            stop.
        end.
    
        /* Executa API de gera‡Æo de etiquetas determinando a execu‡Æo do teste */
        {utp/ut-liter.i Gerando_etiqueta...}
        run pi-acompanhar in h-acomp (trim(return-value)).
        vg-teste-etiqueta   = yes.
        vg-geracao-word     = v-geracao-word.
        vg-impres-ems-teste = v-impres-ems.
        do  on error undo, leave   /* para garantir que vg-teste-etiqueta volte a 'no' */
            on endkey undo, leave  /* apos execu‡Æo de bcapi007.p */
            on stop undo, leave
            on quit undo, leave:
            run bcp/bcapi007.p (input-output table tt-etiqueta, 
                                input-output table tt-erro,
                                output c-rel-arq).
            find first tt-erro no-error.
            if  avail tt-erro then
                run cdp/cd0666.w (input table tt-erro).
        end.
        vg-teste-etiqueta = no.
    end.

    /* fim do acomponhamento -------------------------------------------------*/
    run pi-finalizar in h-acomp.
    session:set-wait-state("":U).  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-up
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-up w-cadsim
ON CHOOSE OF bt-up IN FRAME f-cad
DO:
    run pi-up in h_b01cl016.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-va-para w-cadsim
ON CHOOSE OF bt-va-para IN FRAME f-cad
DO:
  run pi-va-para in h_b01cl016.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-alterar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-alterar w-cadsim
ON CHOOSE OF MENU-ITEM mi-alterar /* Alterar */
DO:
  RUN pi-alterar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-anterior
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-anterior w-cadsim
ON CHOOSE OF MENU-ITEM mi-anterior /* Anterior */
DO:
  RUN pi-anterior IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-arquivo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-arquivo w-cadsim
ON MENU-DROP OF MENU mi-arquivo /* Arquivo */
DO:
  run pi-disable-menu.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-cancelar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-cancelar w-cadsim
ON CHOOSE OF MENU-ITEM mi-cancelar /* Cancelar */
DO:
  RUN pi-cancelar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-consultas
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-consultas w-cadsim
ON CHOOSE OF MENU-ITEM mi-consultas /* Consultas */
DO:
  RUN pi-consulta IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-conteudo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-conteudo w-cadsim
ON CHOOSE OF MENU-ITEM mi-conteudo /* Conteudo */
OR HELP OF FRAME {&FRAME-NAME}
DO:
  RUN pi-ajuda IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-copiar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-copiar w-cadsim
ON CHOOSE OF MENU-ITEM mi-copiar /* Copiar */
DO:
  RUN pi-copiar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-desfazer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-desfazer w-cadsim
ON CHOOSE OF MENU-ITEM mi-desfazer /* Desfazer */
DO:
  RUN pi-desfazer IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-eliminar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-eliminar w-cadsim
ON CHOOSE OF MENU-ITEM mi-eliminar /* Eliminar */
DO:
  RUN pi-eliminar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-imprimir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-imprimir w-cadsim
ON CHOOSE OF MENU-ITEM mi-imprimir /* Relat¢rios */
DO:
  RUN pi-imprimir IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-incluir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-incluir w-cadsim
ON CHOOSE OF MENU-ITEM mi-incluir /* Incluir */
DO:
  RUN pi-incluir IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-pesquisa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-pesquisa w-cadsim
ON CHOOSE OF MENU-ITEM mi-pesquisa /* Pesquisa */
DO:
  RUN pi-pesquisa IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-primeiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-primeiro w-cadsim
ON CHOOSE OF MENU-ITEM mi-primeiro /* Primeiro */
DO:
  RUN pi-primeiro IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-proximo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-proximo w-cadsim
ON CHOOSE OF MENU-ITEM mi-proximo /* Pr¢ximo */
DO:
  RUN pi-proximo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sair w-cadsim
ON CHOOSE OF MENU-ITEM mi-sair /* Sair */
DO:
  RUN pi-sair IN h_p-exihel.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-salvar
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-salvar w-cadsim
ON CHOOSE OF MENU-ITEM mi-salvar /* Salvar */
DO:
  RUN pi-salvar IN h_p-cadsim.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-sobre w-cadsim
ON CHOOSE OF MENU-ITEM mi-sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-ultimo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-ultimo w-cadsim
ON CHOOSE OF MENU-ITEM mi-ultimo /* éltimo */
DO:
  RUN pi-ultimo IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME mi-va-para
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL mi-va-para w-cadsim
ON CHOOSE OF MENU-ITEM mi-va-para /* V  para */
DO:
  RUN pi-vapara IN h_p-navega.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Teste
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Teste w-cadsim
ON CHOOSE OF MENU-ITEM m_Teste /* Teste */
DO:
  apply "choose":U to bt-teste in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK w-cadsim 


/* ***************************  Main Block  *************************** */

/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects w-cadsim  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/
  DEFINE VARIABLE adm-current-page  AS INTEGER NO-UNDO.

  RUN get-attribute IN THIS-PROCEDURE ('Current-Page':U).
  ASSIGN adm-current-page = INTEGER(RETURN-VALUE).

  CASE adm-current-page: 

    WHEN 0 THEN DO:
       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-navega.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-navega ).
       RUN set-position IN h_p-navega ( 1.13 , 1.72 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 24.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-cadsim.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = Update,
                     AddFunction = One-Record':U ,
             OUTPUT h_p-cadsim ).
       RUN set-position IN h_p-cadsim ( 1.13 , 27.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 28.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'panel/p-exihel.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Edge-Pixels = 0,
                     SmartPanelType = NAV-ICON,
                     Right-to-Left = First-On-Left':U ,
             OUTPUT h_p-exihel ).
       RUN set-position IN h_p-exihel ( 1.13 , 73.86 ) NO-ERROR.
       /* Size in UIB:  ( 1.25 , 16.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clvwr/v01cl015.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_v01cl015 ).
       RUN set-position IN h_v01cl015 ( 2.50 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 5.50 , 89.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clbrw/b03cl015.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b03cl015 ).
       RUN set-position IN h_b03cl015 ( 8.25 , 1.00 ) NO-ERROR.
       /* Size in UIB:  ( 8.88 , 34.00 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clbrw/b01cl016.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'Layout = ':U ,
             OUTPUT h_b01cl016 ).
       RUN set-position IN h_b01cl016 ( 8.25 , 42.00 ) NO-ERROR.
       /* Size in UIB:  ( 8.88 , 43.29 ) */

       RUN init-object IN THIS-PROCEDURE (
             INPUT  'clqry/q01cl015.w':U ,
             INPUT  FRAME f-cad:HANDLE ,
             INPUT  'ProgPesquisa = clzoom/z01cl015.w,
                     ProgVaPara = clgo/g01cl015.w,
                     ProgIncMod = ':U ,
             OUTPUT h_q01cl015 ).
       RUN set-position IN h_q01cl015 ( 1.00 , 58.00 ) NO-ERROR.
       /* Size in UIB:  ( 1.67 , 8.29 ) */

       /* Links to SmartPanel h_p-exihel. */
       RUN add-link IN adm-broker-hdl ( h_p-cadsim , 'State':U , h_p-exihel ).

       /* Links to SmartViewer h_v01cl015. */
       RUN add-link IN adm-broker-hdl ( h_p-cadsim , 'TableIO':U , h_v01cl015 ).
       RUN add-link IN adm-broker-hdl ( h_q01cl015 , 'Record':U , h_v01cl015 ).
       RUN add-link IN adm-broker-hdl ( h_v01cl015 , 'habilita':U , THIS-PROCEDURE ).

       /* Links to SmartBrowser h_b03cl015. */
       RUN add-link IN adm-broker-hdl ( h_q01cl015 , 'Record':U , h_b03cl015 ).
       RUN add-link IN adm-broker-hdl ( h_v01cl015 , 'habilita':U , h_b03cl015 ).

       /* Links to SmartBrowser h_b01cl016. */
       RUN add-link IN adm-broker-hdl ( h_q01cl015 , 'Record':U , h_b01cl016 ).
       RUN add-link IN adm-broker-hdl ( h_v01cl015 , 'elimina-tt-seq':U , h_b01cl016 ).
       RUN add-link IN adm-broker-hdl ( h_v01cl015 , 'habilita':U , h_b01cl016 ).
       RUN add-link IN adm-broker-hdl ( h_v01cl015 , 'valida-campos':U , h_b01cl016 ).

       /* Links to SmartQuery h_q01cl015. */
       RUN add-link IN adm-broker-hdl ( h_p-exihel , 'State':U , h_q01cl015 ).
       RUN add-link IN adm-broker-hdl ( h_p-navega , 'Navigation':U , h_q01cl015 ).
       RUN add-link IN adm-broker-hdl ( h_p-navega , 'State':U , h_q01cl015 ).

       /* Adjust the tab order of the smart objects. */
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-navega ,
             bt-teste:HANDLE IN FRAME f-cad , 'BEFORE':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-cadsim ,
             h_p-navega , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_p-exihel ,
             bt-teste:HANDLE IN FRAME f-cad , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_v01cl015 ,
             h_p-exihel , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b03cl015 ,
             h_v01cl015 , 'AFTER':U ).
       RUN adjust-tab-order IN adm-broker-hdl ( h_b01cl016 ,
             h_b03cl015 , 'AFTER':U ).
    END. /* Page 0 */

  END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available w-cadsim  _ADM-ROW-AVAILABLE
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

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI w-cadsim  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(w-cadsim)
  THEN DELETE WIDGET w-cadsim.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI w-cadsim  _DEFAULT-ENABLE
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
  ENABLE bt-teste bt-editor bt-va-para rt-button 
      WITH FRAME f-cad IN WINDOW w-cadsim.
  {&OPEN-BROWSERS-IN-QUERY-f-cad}
  VIEW w-cadsim.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy w-cadsim 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
  {include/i-logfin.i}

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit w-cadsim 
PROCEDURE local-exit :
/* -----------------------------------------------------------
  Purpose:  Starts an "exit" by APPLYing CLOSE event, which starts "destroy".
  Parameters:  <none>
  Notes:    If activated, should APPLY CLOSE, *not* dispatch adm-exit.   
-------------------------------------------------------------*/
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  
  RETURN.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize w-cadsim 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/win-size.i}
  run pi-before-initialize.
  
  /* Dispatch standard ADM method.                             */
{utp/ut9000.i "BC0103" "2.00.00.032"}

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    assign  bt-editor   :sensitive = no
            bt-va-para  :sensitive = no.
  
  run pi-recebe-handle in h_b03cl015 (input h_b01cl016).
  run pi-recebe-handle in h_b01cl016 (input h_b03cl015).

/* Code placed here will execute AFTER standard behavior.    */
 
  run pi-after-initialize.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita-bt w-cadsim 
PROCEDURE pi-desabilita-bt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

disable bt-add bt-del bt-up bt-dn bt-editor bt-va-para with frame f-cad.
enable bt-teste with frame f-cad.

run pi-habilita-browse in h_b01cl016 (input no).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-bt w-cadsim 
PROCEDURE pi-habilita-bt :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

enable bt-add bt-del bt-up bt-dn bt-editor bt-va-para with frame f-cad.
disable bt-teste with frame f-cad.

run pi-habilita-browse in h_b01cl016 (input yes).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-button w-cadsim 
PROCEDURE pi-habilita-button :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param l-visible as logical.

assign  bt-editor   :sensitive in frame {&frame-name} = l-visible
        bt-va-para  :sensitive in frame {&frame-name} = l-visible.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_ems_xref w-cadsim 
PROCEDURE pi_ems_xref :
/*------------------------------------------------------------------------------
  Purpose:     Referˆncias XRef
  Parameters:  <none> 
  Notes:       NÆo altere/elimine o c¢digo abaixo.
------------------------------------------------------------------------------*/
RUN clzoom/z01cl015.w.
RUN clgo/g01cl015.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE RTB_xref_generator w-cadsim 
PROCEDURE RTB_xref_generator :
/* -----------------------------------------------------------
Purpose:    Generate RTB xrefs for SMARTOBJECTS.
Parameters: <none>
Notes:      This code is generated by the UIB.  DO NOT modify it.
            It is included for Roundtable Xref generation. Without
            it, Xrefs for SMARTOBJECTS could not be maintained by
            RTB.  It will in no way affect the operation of this
            program as it never gets executed.
-------------------------------------------------------------*/
  RUN clbrw/b01cl016.w.
  RUN panel/p-cadsim.w.
  RUN panel/p-navega.w.
  RUN clvwr/v01cl015.w.
  RUN panel/p-exihel.w.
  RUN clbrw/b03cl015.w.
  RUN clqry/q01cl015.w.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records w-cadsim  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this w-cadsim, and there are no
     tables specified in any contained Browse, Query, or Frame. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed w-cadsim 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     Manuseia trocas de estado dos SmartObjects
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.

  run pi-trata-state (p-issuer-hdl, p-state).
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

