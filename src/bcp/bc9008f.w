&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
*/
&Scoped-define WINDOW-NAME wgEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS wgEmbarque 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BC9008F 2.00.00.023 } /*** "010023" 03/07/2023 09:45:13  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i bc9008f MBC}
&ENDIF

/*------------------------------------------------------------------------

  File: 

  Description: from cntnrwin.w - ADM SmartWindow Template

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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

{include/i_dbvers.i}

/* ***************************  Definitions  ************************** */
/*
def var c-nom-prog-upc-mg97  as char format "x(50)" no-undo.
def var c-nom-prog-appc-mg97 as char format "x(50)" no-undo.
def var c-nom-prog-dpc-mg97  as char format "x(50)" no-undo.
def var c-ctrl-tab           as char                no-undo.
def var h-ctrl-tab           as handle              no-undo.
def var wh-entry-field       as widget-handle       no-undo.
*/
{include/i-sysvar.i}
{utp/ut-glob.i}

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

{ftp/ftapi400.i}
{ftp/ftapi401.i}
{bcp/bc9102.i}

Define Temp-table tt-confere-aviso no-undo
    Field cdd-embarq        As DECIMAL FORMAT '>>>>>>>>>>>>>>>9' Label 'Embarque'
    Field nr-resumo         as INTEGER                       
    Field nr-ped-cli        As Character Format 'x(12)'          Label 'PedCli'
    Field cod-item          As Character Format 'x(16)'          Label 'Item'
    FIELD nr-sequencia      as INTEGER format ">>,>>9"           LABEL 'Sequencia'
    Field cod-refer         As Character Format 'x(10)'          Label 'Refer'
    Field des-item          As Character Format 'x(30)'          Label 'Descriá∆o'
    Field qtd-faturada      As Decimal                           Label 'Qtde Faturada'
    Field qtd-embarcada     As Decimal                           Label 'Qtde Embarcada'
    Field qtd-aberto        As Decimal                           Label 'Qtde Em Aberto'
    Index Aberto  cdd-embarq nr-ped-cli nr-resumo cod-item nr-sequencia.

Define Variable chTick          As Com-Handle                         No-undo.
define var      de-total-item   as DECIMAL FORMAT  "->>>>,>>9.9999"   no-undo.

def var i-time as int.
def var vUsuar as char format "x(12)".
def var vnrresumo as int.
def var c-transacao as char no-undo.
def var h-acomp as handle no-undo.

def buffer b-tt-pre-fatur     FOR tt-pre-fatur.
DEF BUFFER b-tt-it-pre-fat    FOR tt-it-pre-fat.
DEF BUFFER b-tt-confere-aviso FOR tt-confere-aviso.

def var l-sit-resumo-1 as log no-undo.
def var l-sit-resumo-2 as log no-undo.
def var l-sit-resumo-3 as log no-undo.
def var l-sit-resumo-4 as log no-undo.
def var i-sit-resumo   as int no-undo.
def var l-mostra-item as log no-undo.
def var c-atualizando as char no-undo.
def var c-ultima-atualizacao as char no-undo.
def var c-fechado           as char no-undo.
def var c-aberto            as char no-undo.
def var c-Fechar            as char no-undo.
def var c-Abrir             as char no-undo.
def var i-cont              as int.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartWindow
&Scoped-define DB-AWARE no

&Scoped-define ADM-CONTAINER WINDOW

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME fEmbarque
&Scoped-define BROWSE-NAME bConfere

/* Internal Tables (found by Frame, Query & Browse Queries)             */
&Scoped-define INTERNAL-TABLES tt-confere-aviso tt-pre-fatur

/* Definitions for BROWSE bConfere                                      */
&Scoped-define FIELDS-IN-QUERY-bConfere nr-sequencia cod-item cod-refer des-item nr-ped-cli qtd-faturada qtd-embarcada qtd-aberto   
&Scoped-define ENABLED-FIELDS-IN-QUERY-bConfere   
&Scoped-define SELF-NAME bConfere
&Scoped-define QUERY-STRING-bConfere FOR EACH tt-confere-aviso
&Scoped-define OPEN-QUERY-bConfere OPEN QUERY bConfere FOR EACH tt-confere-aviso.
&Scoped-define TABLES-IN-QUERY-bConfere tt-confere-aviso
&Scoped-define FIRST-TABLE-IN-QUERY-bConfere tt-confere-aviso


/* Definitions for BROWSE bresumo                                       */
&Scoped-define FIELDS-IN-QUERY-bresumo tt-pre-fatur.cdd-embarq tt-pre-fatur.nr-resumo tt-pre-fatur.dt-embarque tt-pre-fatur.nome-abrev tt-pre-fatur.motorista tt-pre-fatur.placa tt-pre-fatur.uf-placa vUsuar   
&Scoped-define ENABLED-FIELDS-IN-QUERY-bresumo   
&Scoped-define SELF-NAME bresumo
&Scoped-define QUERY-STRING-bresumo FOR EACH tt-pre-fatur
&Scoped-define OPEN-QUERY-bresumo OPEN QUERY bresumo FOR EACH tt-pre-fatur.
&Scoped-define TABLES-IN-QUERY-bresumo tt-pre-fatur
&Scoped-define FIRST-TABLE-IN-QUERY-bresumo tt-pre-fatur


/* Definitions for FRAME fEmbarque                                      */
&Scoped-define OPEN-BROWSERS-IN-QUERY-fEmbarque ~
    ~{&OPEN-QUERY-bConfere}~
    ~{&OPEN-QUERY-bresumo}

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-2 RECT-4 RECT-6 vNumAviso ~
vNumAvisofim btConfere btLimpa vtresumo vnrresumo-ini vnrresumo-fim vLigado ~
bresumo bConfere btlimpaitem btlistaitem btLegenda 
&Scoped-Define DISPLAYED-OBJECTS vNumAviso vNumAvisofim vtresumo ~
vnrresumo-ini vnrresumo-fim vLigado vDesStatusEmbarque vIntervalo 

/* Custom List Definitions                                              */
/* List-1,List-2,List-3,List-4,List-5,List-6                            */

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* ***********************  Control Definitions  ********************** */

/* Define the widget handle for the window                              */
DEFINE VAR wgEmbarque AS WIDGET-HANDLE NO-UNDO.

/* Menu Definitions                                                     */
DEFINE SUB-MENU m_Aviso_de_Embarque 
       MENU-ITEM m_Conferir     LABEL "&Conferir"     
       MENU-ITEM m_Sair         LABEL "&Sair"         .

DEFINE SUB-MENU m_Ajuda 
       MENU-ITEM m_Topicos_da_Ajuda LABEL "Conteudo"      
       MENU-ITEM m_Sobre        LABEL "Sobre..."      .

DEFINE MENU MENU-BAR-wgEmbarque MENUBAR
       SUB-MENU  m_Aviso_de_Embarque LABEL "&Embarque"     
       SUB-MENU  m_Ajuda        LABEL "&Ajuda"        .


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON btConfere 
     IMAGE-UP FILE "image\im-enter":U
     LABEL "Confere" 
     SIZE 5 BY 1.

DEFINE BUTTON btFechaAviso 
     IMAGE-UP FILE "image\im-smfec":U
     IMAGE-INSENSITIVE FILE "image\ii-smfec":U
     LABEL "Fecha" 
     SIZE 10 BY 2.

DEFINE BUTTON btLegenda 
     LABEL "&Legenda" 
     SIZE 11.72 BY .88.

DEFINE BUTTON btLimpa 
     IMAGE-UP FILE "image\im-era":U
     IMAGE-INSENSITIVE FILE "image\ii-era":U
     LABEL "Limpa" 
     SIZE 10 BY 2 TOOLTIP "Reinicia Resumo Embarque".

DEFINE BUTTON btlimpaitem 
     LABEL "&Reiniciar Item" 
     SIZE 11.72 BY .88.

DEFINE BUTTON btlistaitem 
     LABEL "&Listaitem" 
     SIZE 11.72 BY .88.

DEFINE VARIABLE vDesStatusEmbarque AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 27 BY 1 NO-UNDO.

DEFINE VARIABLE vIntervalo AS INTEGER FORMAT ">>9":U INITIAL 10 
     LABEL "Tempo Atualizaá∆o (segs)" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE vnrresumo-fim AS INTEGER FORMAT ">>>>>9":U INITIAL 999999 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "N£mero do embarque" NO-UNDO.

DEFINE VARIABLE vnrresumo-ini AS INTEGER FORMAT ">>>>>9":U INITIAL 0 
     LABEL "N£mero Resumo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "N£mero do embarque" NO-UNDO.

DEFINE VARIABLE vNumAviso AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9":U INITIAL 0 
     LABEL "Embarque" 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 TOOLTIP "N£mero do Embarque" NO-UNDO.

DEFINE VARIABLE vNumAvisofim AS DECIMAL FORMAT ">>>>>>>>>>>>>>>9":U INITIAL 9999999999999999 
     VIEW-AS FILL-IN 
     SIZE 15.14 BY .88 TOOLTIP "N£mero do Embarque" NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79 BY 5.25.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.29 BY 6.88.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 79.29 BY 6.5.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 29 BY 4.5.

DEFINE VARIABLE vLigado AS LOGICAL INITIAL no 
     LABEL "At&ualizar Automaticamente" 
     VIEW-AS TOGGLE-BOX
     SIZE 23 BY .83 NO-UNDO.

DEFINE VARIABLE vtresumo AS LOGICAL INITIAL no 
     LABEL "Todos os Resumos" 
     VIEW-AS TOGGLE-BOX
     SIZE 20 BY .83 NO-UNDO.

/* Query definitions                                                    */
&ANALYZE-SUSPEND
DEFINE QUERY bConfere FOR 
      tt-confere-aviso SCROLLING.

DEFINE QUERY bresumo FOR 
      tt-pre-fatur SCROLLING.
&ANALYZE-RESUME

/* Browse definitions                                                   */
DEFINE BROWSE bConfere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS bConfere wgEmbarque _FREEFORM
  QUERY bConfere DISPLAY
      nr-sequencia
    cod-item
    cod-refer
    des-item
    nr-ped-cli
    qtd-faturada  FORMAT "->>>>,>>9.9999":U
    qtd-embarcada FORMAT "->>>>,>>9.9999":U
    qtd-aberto    FORMAT "->>>>,>>9.9999":U
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ROW-MARKERS SEPARATORS MULTIPLE SIZE 77 BY 6.42
         FONT 1.

DEFINE BROWSE bresumo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _DISPLAY-FIELDS bresumo wgEmbarque _FREEFORM
  QUERY bresumo DISPLAY
      tt-pre-fatur.cdd-embarq format ">>>>>>>>>>>>>>>9"
tt-pre-fatur.nr-resumo   format ">>>>>9" 
tt-pre-fatur.dt-embarque format "99/99/9999"
tt-pre-fatur.nome-abrev
tt-pre-fatur.motorista
tt-pre-fatur.placa
tt-pre-fatur.uf-placa
vUsuar
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
    WITH NO-BOX NO-ROW-MARKERS SEPARATORS SIZE 77 BY 6
         FONT 1.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME fEmbarque
     vNumAviso AT ROW 1.25 COL 12.14 COLON-ALIGNED
     vNumAvisofim AT ROW 1.25 COL 27.57 COLON-ALIGNED NO-LABEL
     btConfere AT ROW 1.25 COL 44.86
     btFechaAviso AT ROW 2 COL 54
     btLimpa AT ROW 2 COL 65
     vtresumo AT ROW 2.25 COL 14.14
     vnrresumo-ini AT ROW 3.17 COL 12.14 COLON-ALIGNED
     vnrresumo-fim AT ROW 3.17 COL 23.86 COLON-ALIGNED NO-LABEL
     vLigado AT ROW 4.25 COL 14.14
     vDesStatusEmbarque AT ROW 4.5 COL 51 NO-LABEL
     vIntervalo AT ROW 5.08 COL 20.57 COLON-ALIGNED
     bresumo AT ROW 6.75 COL 2
     bConfere AT ROW 13.58 COL 2
     btlimpaitem AT ROW 20.25 COL 2
     btlistaitem AT ROW 20.25 COL 14
     btLegenda AT ROW 20.25 COL 68
     "Fechar/Reiniciar Embarque" VIEW-AS TEXT
          SIZE 20 BY .54 AT ROW 1.25 COL 51
     RECT-1 AT ROW 1 COL 1
     RECT-2 AT ROW 13.25 COL 1
     RECT-4 AT ROW 6.5 COL 1
     RECT-6 AT ROW 1.5 COL 50
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1
         SIZE 81.57 BY 20.46
         FONT 1.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartWindow
   Allow: Basic,Browse,DB-Fields,Query,Smart,Window
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
IF SESSION:DISPLAY-TYPE = "GUI":U THEN
  CREATE WINDOW wgEmbarque ASSIGN
         HIDDEN             = YES
         TITLE              = "Conferància do embarque"
         HEIGHT             = 20.38
         WIDTH              = 79.43
         MAX-HEIGHT         = 28.21
         MAX-WIDTH          = 146.29
         VIRTUAL-HEIGHT     = 28.21
         VIRTUAL-WIDTH      = 146.29
         RESIZE             = no
         SCROLL-BARS        = no
         STATUS-AREA        = yes
         BGCOLOR            = ?
         FGCOLOR            = ?
         THREE-D            = yes
         MESSAGE-AREA       = no
         SENSITIVE          = yes.
ELSE {&WINDOW-NAME} = CURRENT-WINDOW.

ASSIGN {&WINDOW-NAME}:MENUBAR    = MENU MENU-BAR-wgEmbarque:HANDLE.
/* END WINDOW DEFINITION                                                */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB wgEmbarque 
/* ************************* Included-Libraries *********************** */

{src/adm/method/containr.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW wgEmbarque
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME fEmbarque
   FRAME-NAME                                                           */
/* BROWSE-TAB bresumo vIntervalo fEmbarque */
/* BROWSE-TAB bConfere bresumo fEmbarque */
/* SETTINGS FOR BUTTON btFechaAviso IN FRAME fEmbarque
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN vDesStatusEmbarque IN FRAME fEmbarque
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN vIntervalo IN FRAME fEmbarque
   NO-ENABLE                                                            */
IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wgEmbarque)
THEN wgEmbarque:HIDDEN = yes.

/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE bConfere
/* Query rebuild information for BROWSE bConfere
     _START_FREEFORM
OPEN QUERY bConfere FOR EACH tt-confere-aviso.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE bConfere */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _QUERY-BLOCK BROWSE bresumo
/* Query rebuild information for BROWSE bresumo
     _START_FREEFORM
OPEN QUERY bresumo FOR EACH tt-pre-fatur.
     _END_FREEFORM
     _Query            is OPENED
*/  /* BROWSE bresumo */
&ANALYZE-RESUME

 


/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME           = FRAME fEmbarque:HANDLE
       ROW             = 1.25
       COLUMN          = 4
       HEIGHT          = 1.17
       WIDTH           = 4
       HIDDEN          = yes
       SENSITIVE       = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {F0B88A90-F5DA-11CF-B545-0020AF6ED35A} type: PSTimer */

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME wgEmbarque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wgEmbarque wgEmbarque
ON END-ERROR OF wgEmbarque /* Conferància do embarque */
OR ENDKEY OF {&WINDOW-NAME} ANYWHERE DO:
  /* This case occurs when the user presses the "Esc" key.
     In a persistently run window, just ignore this.  If we did not, the
     application would exit. */
  IF THIS-PROCEDURE:PERSISTENT THEN RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL wgEmbarque wgEmbarque
ON WINDOW-CLOSE OF wgEmbarque /* Conferància do embarque */
DO:
  /* This ADM code must be left here in order for the SmartWindow
     and its descendents to terminate properly on exit. */
  APPLY "CLOSE":U TO THIS-PROCEDURE.
  RETURN NO-APPLY.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME bConfere
&Scoped-define SELF-NAME bConfere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bConfere wgEmbarque
ON ROW-DISPLAY OF bConfere IN FRAME fEmbarque
DO:
    If   tt-confere-aviso.qtd-embarcada = 0 Then Do:
         Assign tt-confere-aviso.nr-sequencia :fgcolor In Browse bConfere = 12 
                tt-confere-aviso.cod-item     :fgcolor In Browse bConfere = 12 
                tt-confere-aviso.nr-ped-cli   :fgcolor In Browse bConfere = 12
                tt-confere-aviso.cod-refer    :fgcolor In Browse bConfere = 12
                tt-confere-aviso.des-item     :fgcolor In Browse bConfere = 12
                tt-confere-aviso.qtd-faturada :fgcolor In Browse bConfere = 12
                tt-confere-aviso.qtd-embarcada:fgcolor In Browse bConfere = 12
                tt-confere-aviso.qtd-aberto   :fgcolor In Browse bConfere = 12.
    End.
    Else 
    If   tt-confere-aviso.qtd-faturada   > tt-confere-aviso.qtd-embarcada And
         tt-confere-aviso.qtd-embarcada <> 0 Then Do:
         Assign tt-confere-aviso.nr-sequencia :fgcolor In Browse bConfere = 9 
                tt-confere-aviso.cod-item     :fgcolor In Browse bConfere = 9 
                tt-confere-aviso.cod-refer    :fgcolor In Browse bConfere = 9
                tt-confere-aviso.nr-ped-cli   :fgcolor In Browse bConfere = 9
                tt-confere-aviso.des-item     :fgcolor In Browse bConfere = 9
                tt-confere-aviso.qtd-faturada :fgcolor In Browse bConfere = 9
                tt-confere-aviso.qtd-embarcada:fgcolor In Browse bConfere = 9
                tt-confere-aviso.qtd-aberto   :fgcolor In Browse bConfere = 9.
    End.
    Else
    If   tt-confere-aviso.qtd-faturada   = tt-confere-aviso.qtd-embarcada Then Do:
         Assign tt-confere-aviso.nr-sequencia :fgcolor In Browse bConfere = 2 
                tt-confere-aviso.cod-item     :fgcolor In Browse bConfere = 2 
                tt-confere-aviso.cod-refer    :fgcolor In Browse bConfere = 2
                tt-confere-aviso.nr-ped-cli   :fgcolor In Browse bConfere = 2
                tt-confere-aviso.des-item     :fgcolor In Browse bConfere = 2
                tt-confere-aviso.qtd-faturada :fgcolor In Browse bConfere = 2
                tt-confere-aviso.qtd-embarcada:fgcolor In Browse bConfere = 2
                tt-confere-aviso.qtd-aberto   :fgcolor In Browse bConfere = 2.
    End.
    Else                
    If   tt-confere-aviso.qtd-faturada   < tt-confere-aviso.qtd-embarcada Then Do:
         Assign tt-confere-aviso.nr-sequencia :fgcolor In Browse bConfere = 5 
                tt-confere-aviso.cod-item     :fgcolor In Browse bConfere = 5 
                tt-confere-aviso.cod-refer    :fgcolor In Browse bConfere = 5
                tt-confere-aviso.nr-ped-cli   :fgcolor In Browse bConfere = 5
                tt-confere-aviso.des-item     :fgcolor In Browse bConfere = 5
                tt-confere-aviso.qtd-faturada :fgcolor In Browse bConfere = 5
                tt-confere-aviso.qtd-embarcada:fgcolor In Browse bConfere = 5
                tt-confere-aviso.qtd-aberto   :fgcolor In Browse bConfere = 5.
    End.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME bresumo
&Scoped-define SELF-NAME bresumo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bresumo wgEmbarque
ON ITERATION-CHANGED OF bresumo IN FRAME fEmbarque
DO:

  if not avail tt-pre-fatur 
    then 
        return no-apply.

  assign vnrresumo     = tt-pre-fatur.cdd-embarq
         vnrresumo     = tt-pre-fatur.nr-resumo
         l-mostra-item = yes.

  Run piConfereEmbarque.

  /*********  
  assign tt-pre-fatur.cdd-embarq   :bgcolor In Browse bresumo = i-sit-resumo
         tt-pre-fatur.nr-resumo    :bgcolor In Browse bresumo = i-sit-resumo
         tt-pre-fatur.dt-embarque  :bgcolor In Browse bresumo = i-sit-resumo
         tt-pre-fatur.nome-abrev   :bgcolor In Browse bresumo = i-sit-resumo
         tt-pre-fatur.motorista    :bgcolor In Browse bresumo = i-sit-resumo
         tt-pre-fatur.placa        :bgcolor In Browse bresumo = i-sit-resumo
         tt-pre-fatur.uf-placa     :bgcolor In Browse bresumo = i-sit-resumo
         vUsuar                    :bgcolor In Browse bresumo = i-sit-resumo.
  *******/


  assign l-mostra-item = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bresumo wgEmbarque
ON ROW-DISPLAY OF bresumo IN FRAME fEmbarque
DO:
   if not avail tt-pre-fatur then return no-apply.

   Find First bc-integracao no-lock
         Where bc-integracao.decimal-2          = tt-pre-fatur.cdd-embarq
         and   bc-integracao.inteiro-indice-2   = tt-pre-fatur.nr-resumo 
         and   bc-integracao.cd-trans           = c-transacao
         No-Error.

   Assign vUsuar = (If Avail bc-integracao 
                    Then bc-integracao.caracter-2 
                    Else "").

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btConfere
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btConfere wgEmbarque
ON CHOOSE OF btConfere IN FRAME fEmbarque /* Confere */
DO:

    Assign Input Frame {&Frame-Name} vNumAviso.
    Assign Input Frame {&Frame-Name} vNumAvisofim.
    Assign Input Frame {&Frame-Name} vnrresumo-ini.
    Assign Input Frame {&Frame-Name} vnrresumo-fim.

    If  btFechaAviso:Load-Image('image/im-f-erp.bmp') Then.

    Close Query bresumo.
    Close Query bconfere.

    {utp/ut-liter.i Em_processamento... *}
    Assign vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value
           chTick:enabled  = vligado.

    For each tt-pre-fatur:
        Delete tt-pre-fatur.
    End.

    run utp/ut-acomp.p persistent set h-acomp.

    {utp/ut-liter.i Leitura_de_Embarques *}
    run pi-inicializar in h-acomp (input  Return-value).
    {utp/ut-liter.i Lendo_Embarques... *}
    run pi-acompanhar in h-acomp (input Return-value).


    for each tt-integracao-401:
        delete tt-integracao-401.
    end.

    CREATE tt-integracao-401.
    ASSIGN tt-integracao-401.cdd-embarq-ini = vnumaviso
           tt-integracao-401.cdd-embarq-fim = vnumavisofim
           tt-integracao-401.nr-resumo-ini = vnrresumo-ini 
           tt-integracao-401.nr-resumo-fim = vnrresumo-fim
           tt-integracao-401.cod-versao-integracao = 1
           l-mostra-item = no.

    run ftp/ftapi401.p (input  table tt-integracao-401,
                        output table tt-pre-fatur,
                        input-output table tt-erro).



    Find First tt-pre-fatur No-error.

    If  Not Avail tt-pre-fatur Then Do:

        run pi-finalizar in h-acomp.

        Run utp/ut-msgs.p  (Input "show",
                            Input 19558,
                            Input '').

        Disable btFechaAviso With Frame {&Frame-Name}.
        Return No-apply.
    End. /* If  Not Avail tt */

    {utp/ut-liter.i Tratando_Embarques... *}
    run pi-acompanhar in h-acomp (input Return-value).

    for each tt-pre-fatur:

        find b-tt-pre-fatur
             where  rowid(b-tt-pre-fatur)       <> rowid(tt-pre-fatur)
             and    b-tt-pre-fatur.nr-resumo   = tt-pre-fatur.nr-resumo
             and    b-tt-pre-fatur.cdd-embarq = tt-pre-fatur.cdd-embarq
             no-lock no-error.

        if  avail b-tt-pre-fatur 
        then 
            delete tt-pre-fatur.          
    end.

    {utp/ut-liter.i Listando_Embarques... *}
    run pi-acompanhar in h-acomp (input Return-value).

    OPEN QUERY bresumo FOR EACH tt-pre-fatur.

    run pi-finalizar in h-acomp.


/* Atualiza frames automaticamente */ 
    DO:
  Assign Input Frame {&Frame-Name} vLigado
         Input Frame {&Frame-Name} vIntervalo.


           Enable  vIntervalo With Frame {&Frame-Name}.
           assign chTick:enabled = yes.              


  run ctrlframe.pSTimer.Tick.  

END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btFechaAviso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btFechaAviso wgEmbarque
ON CHOOSE OF btFechaAviso IN FRAME fEmbarque /* Fecha */
DO:
   Define Variable vLogFechado         As Logical          No-undo.

   If  btFechaAviso:Load-Image('image/im-f-erp.bmp') Then.

   Find First bc-integracao no-lock
      Where bc-integracao.decimal-2          = vNumAviso 
      and   bc-integracao.inteiro-indice-2   = vnrresumo 
      and   bc-integracao.cd-trans           = c-transacao      
      No-Error.

   If  Not AvailAble bc-integracao Then Do:
      Run utp/ut-msgs.p  (Input "show",
                          Input 19562,
                          Input '').
      return no-apply.
   End.

   Run 'btb/btb910zz.p' (Input v_cod_usuar_corren,
                          Input Yes).

   If  Return-Value = 'NOK' Then Do:
       Return No-apply.
   End.

   If  bc-integracao.logico-1 = Yes Then Do:

       Assign vLogFechado = Yes.
       Run utp/ut-msgs.p  (Input "show",
                           Input 19557,
                           Input '').
   End.
   Else Do:

       Assign vLogFechado = No.
       Run utp/ut-msgs.p  (Input "show",
                           Input 19556,
                           Input '').
   End.

   If  Return-Value <> 'Yes' 
   Then 
        return no-apply.

   if  bc-integracao.logico-1 = no then do:

       for each  tt-pre-fatur
           where tt-pre-fatur.nr-resumo   = vnrresumo
           and   tt-pre-fatur.cdd-embarq = vnumaviso
            break by tt-pre-fatur.cdd-embarq:     

            If  tt-pre-fatur.log-2     = No 
            Then Do:

                 Run utp/ut-msgs.p  (Input "show",
                                     Input 19561,
                                     Input '').

                 If  Return-Value <> 'Yes' Then 
                     return no-apply.

            End. /* If  vLogFechado = No */

         end.
   end.

   For each bc-integracao EXCLUSIVE-LOCK
       Where bc-integracao.decimal-2        = vNumAviso
       and   bc-integracao.inteiro-indice-2 = vnrresumo       
       and   bc-integracao.cd-trans         = c-transacao:

       Assign bc-integracao.logico-1   = If vLogFechado = Yes Then No Else Yes
              bc-integracao.caracter-2 = v_cod_usuar_corren.

   End. /* each bc-integracao */

   Apply 'Choose' To btConfere In Frame {&Frame-Name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLegenda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLegenda wgEmbarque
ON CHOOSE OF btLegenda IN FRAME fEmbarque /* Legenda */
DO:
  Run 'bcp/bc9008g.w'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btLimpa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btLimpa wgEmbarque
ON CHOOSE OF btLimpa IN FRAME fEmbarque /* Limpa */
DO:
    Define Variable vLogFechado         As Logical          No-undo.

    Find First bc-integracao no-lock
         Where bc-integracao.decimal-2          = vNumAviso
         and   bc-integracao.inteiro-indice-2   = vnrresumo         
         and   bc-integracao.cd-trans           = c-transacao
         No-Error.

    If  not avail bc-integracao Then
        Return no-apply.

    Assign vLogFechado = bc-integracao.logico-1.

    If  vLogFechado Then Do:
        Run utp/ut-msgs.p  (Input "show",
                            Input 19622,
                            Input '').
        Return No-Apply.
    End.

    Run utp/ut-msgs.p  (Input "show",
                        Input 19620,
                        Input '').

    If  Return-Value <> 'Yes' Then Do:
        Return No-Apply.
    End. /* Return-Value <> 'Yes' */

    Assign Input Frame {&Frame-Name} vNumAviso.

    If  btFechaAviso:Load-Image('image/im-f-erp.bmp') Then.

    For each bc-integracao EXCLUSIVE-LOCK
        Where bc-integracao.decimal-2          = vNumAviso
        and   bc-integracao.inteiro-indice-2   = vnrresumo       
        and   bc-integracao.cd-trans           = c-transacao:

        delete bc-integracao.

    End. /* each bc-integracao */

    Apply 'Choose' To btConfere In Frame {&Frame-Name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btlimpaitem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btlimpaitem wgEmbarque
ON CHOOSE OF btlimpaitem IN FRAME fEmbarque /* Reiniciar Item */
DO:
  if bconfere:num-selected-rows in frame {&FRAME-NAME} = 0 
  then
      Return no-apply. 

  Find First bc-integracao no-lock
       Where bc-integracao.decimal-2          = vNumAviso 
       and   bc-integracao.inteiro-indice-2   = vnrresumo
       and   bc-integracao.cd-trans           = c-transacao
       No-Error.

  If  not avail bc-integracao Then
      Return no-apply.

  If  bc-integracao.logico-1 Then Do:
      Run utp/ut-msgs.p  (Input "show",
                          Input 19622,
                          Input '').
      Return No-Apply.
  End.

  do i-cont = 1 to bconfere:num-selected-rows in frame {&FRAME-NAME}:

     if  bconfere:fetch-selected-row(i-cont) in frame {&FRAME-NAME}
     then do trans:

         find current tt-confere-aviso no-lock no-error.

         find first bc-integracao EXCLUSIVE-LOCK
              where bc-integracao.decimal-2         = tt-confere-aviso.cdd-embarq
              and   bc-integracao.inteiro-indice-2  = tt-confere-aviso.nr-resumo
              and   bc-integracao.caracter-indice-1 = tt-confere-aviso.cod-item
              and   bc-integracao.caracter-indice-2 = tt-confere-aviso.cod-refer
              and   bc-integracao.cd-trans          = c-transacao              
              no-error.

         if  avail bc-integracao
         then 
             delete bc-integracao. 

     end.

  end.

  OPEN QUERY bresumo FOR EACH tt-pre-fatur.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME btlistaitem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL btlistaitem wgEmbarque
ON CHOOSE OF btlistaitem IN FRAME fEmbarque /* Listaitem */
DO:
  assign l-mostra-item = yes.
  run piConfereEmbarque.
  assign l-mostra-item = no.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Conferir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Conferir wgEmbarque
ON CHOOSE OF MENU-ITEM m_Conferir /* Conferir */
DO:
  Apply 'Choose' To btConfere In Frame {&Frame-Name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sair
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sair wgEmbarque
ON CHOOSE OF MENU-ITEM m_Sair /* Sair */
DO:
/*   Apply 'Close' To wgEmbarque. */
  Apply 'Close' To THIS-PROCEDURE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Sobre
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Sobre wgEmbarque
ON CHOOSE OF MENU-ITEM m_Sobre /* Sobre... */
DO:
  {include/sobre.i}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME m_Topicos_da_Ajuda
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL m_Topicos_da_Ajuda wgEmbarque
ON CHOOSE OF MENU-ITEM m_Topicos_da_Ajuda /* Conteudo */
OR HELP OF FRAME fEmbarque ANYWHERE DO:

    run men/men900za.p (Input self:handle,
                        Input this-procedure:handle) /*prg_fnc_chamar_help_context*/.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vIntervalo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vIntervalo wgEmbarque
ON LEAVE OF vIntervalo IN FRAME fEmbarque /* Tempo Atualizaá∆o (segs) */
DO:
    Assign Input Frame {&Frame-Name} vIntervalo.

    Assign chTick:Interval = (vIntervalo * 1000)
           chTick:enabled  = yes.

    run ctrlframe.pSTimer.Tick.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vLigado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vLigado wgEmbarque
ON VALUE-CHANGED OF vLigado IN FRAME fEmbarque /* Atualizar Automaticamente */
DO:
  Assign Input Frame {&Frame-Name} vLigado
         Input Frame {&Frame-Name} vIntervalo.

  Case vLigado:
    When Yes 
    Then do:
           Enable  vIntervalo With Frame {&Frame-Name}.
           assign chTick:enabled = yes.           
         end.     
    When No  
    Then do:
           Disable vIntervalo With Frame {&Frame-Name}.
           assign chTick:enabled = no.
         end.
  End. /* Case */

  run ctrlframe.pSTimer.Tick.  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vnrresumo-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vnrresumo-fim wgEmbarque
ON RETURN OF vnrresumo-fim IN FRAME fEmbarque
DO:
  Apply 'choose' To btConfere In Frame {&Frame-Name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vnrresumo-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vnrresumo-ini wgEmbarque
ON RETURN OF vnrresumo-ini IN FRAME fEmbarque /* N£mero Resumo */
DO:
  Apply 'choose' To btConfere In Frame {&Frame-Name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vNumAviso
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vNumAviso wgEmbarque
ON RETURN OF vNumAviso IN FRAME fEmbarque /* Embarque */
DO:

  Apply 'choose' To btConfere In Frame {&Frame-Name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vNumAvisofim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vNumAvisofim wgEmbarque
ON RETURN OF vNumAvisofim IN FRAME fEmbarque
DO:

  Apply 'choose' To btConfere In Frame {&Frame-Name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME vtresumo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL vtresumo wgEmbarque
ON VALUE-CHANGED OF vtresumo IN FRAME fEmbarque /* Todos os Resumos */
DO:
  Assign Input Frame {&Frame-Name} vtresumo.
  Case vtresumo:
    When Yes 
    Then do:
           Disable vnrresumo-ini With Frame {&Frame-Name}.
           Disable vnrresumo-fim With Frame {&Frame-Name}.           
         end.     
    When No  
    Then do:
           Enable vnrresumo-ini With Frame {&Frame-Name}.
           Enable vnrresumo-fim With Frame {&Frame-Name}.           
         end.
  End. /* Case */

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define BROWSE-NAME bConfere
&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK wgEmbarque 


/* ***************************  Main Block  *************************** */


/* Include custom  Main Block code for SmartWindows. */
{src/adm/template/windowmn.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-create-objects wgEmbarque  _ADM-CREATE-OBJECTS
PROCEDURE adm-create-objects :
/*------------------------------------------------------------------------------
  Purpose:     Create handles for all SmartObjects used in this procedure.
               After SmartObjects are initialized, then SmartLinks are added.
  Parameters:  <none>
------------------------------------------------------------------------------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available wgEmbarque  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load wgEmbarque  _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "bc9008f.wrx":U ).
IF OCXFile = ? THEN
  OCXFile = SEARCH(SUBSTRING(THIS-PROCEDURE:FILE-NAME, 1,
                     R-INDEX(THIS-PROCEDURE:FILE-NAME, ".":U), "CHARACTER":U) + "wrx":U).

IF OCXFile <> ? THEN
DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.
ELSE MESSAGE "bc9008f.wrx":U SKIP(1)
             "The binary control file could not be found. The controls cannot be loaded."
             VIEW-AS ALERT-BOX TITLE "Controls Not Loaded".

&ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE CtrlFrame.PSTimer.Tick wgEmbarque 
PROCEDURE CtrlFrame.PSTimer.Tick :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  apply "CHOOSE":U to btlistaitem in frame {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI wgEmbarque  _DEFAULT-DISABLE
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
  IF SESSION:DISPLAY-TYPE = "GUI":U AND VALID-HANDLE(wgEmbarque)
  THEN DELETE WIDGET wgEmbarque.
  IF THIS-PROCEDURE:PERSISTENT THEN DELETE PROCEDURE THIS-PROCEDURE.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE enable_UI wgEmbarque  _DEFAULT-ENABLE
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
  DISPLAY vNumAviso vNumAvisofim vtresumo vnrresumo-ini vnrresumo-fim vLigado 
          vDesStatusEmbarque vIntervalo 
      WITH FRAME fEmbarque IN WINDOW wgEmbarque.
  ENABLE RECT-1 RECT-2 RECT-4 RECT-6 vNumAviso vNumAvisofim btConfere btLimpa 
         vtresumo vnrresumo-ini vnrresumo-fim vLigado bresumo bConfere 
         btlimpaitem btlistaitem btLegenda 
      WITH FRAME fEmbarque IN WINDOW wgEmbarque.
  {&OPEN-BROWSERS-IN-QUERY-fEmbarque}
  VIEW wgEmbarque.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit wgEmbarque 
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize wgEmbarque 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/


  If  v_cod_usuar_corren = '' Then 
      Run 'btb/btb910za.p'.

  /* Code placed here will execute PRIOR to standard behavior. */


{utp/ut9000.i "BC9008F" "2.00.00.023"} /* 03/07/2023 09:45:13 */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .


  Assign chTick = chCtrlFrame:Controls:Item(1).

  /* Code placed here will execute AFTER standard behavior.    */

{utp/ut-liter.i "Embarque" * L}
assign tt-pre-fatur.cdd-embarq:label in browse bresumo = trim(return-value).

{utp/ut-liter.i "Resumo" * L}
assign tt-pre-fatur.nr-resumo:label in browse bresumo = trim(return-value).

{utp/ut-liter.i "Dt Embar" * L}
assign tt-pre-fatur.dt-embarque:label in browse bresumo = return-value.

{utp/ut-liter.i "Motorista" * L}
assign tt-pre-fatur.motorista:label in browse bresumo = return-value.

{utp/ut-liter.i "Placa" * L}
assign tt-pre-fatur.placa:label in browse bresumo = return-value.

{utp/ut-liter.i "UF" * L}
assign tt-pre-fatur.uf-placa:label in browse bresumo = return-value.

{utp/ut-liter.i "Cliente" * L}
assign tt-pre-fatur.nome-abrev:label in browse bresumo = return-value.

{utp/ut-liter.i "Usu†rio" * L}
assign vUsuar:label in browse bresumo = return-value.

{utp/ut-liter.i "Atualizando" * L}
assign c-atualizando = return-value.

{utp/ut-liter.i "Ultima Atualizaá∆o" * L}
assign c-ultima-atualizacao = return-value.

{utp/ut-liter.i "Resumo do Embarque Liberado" * L}
assign c-fechado = return-value.

{utp/ut-liter.i "Resumo do Embarque n∆o Liberado" * L}
assign c-aberto = return-value.

{utp/ut-liter.i "Fechar Resumo do Embarque" * L}
assign c-fechar = return-value.

{utp/ut-liter.i "Abrir  Resumo do Embarque" * L}
assign c-abrir = return-value.

Find First bc-prog-trans no-lock 
     where bc-prog-trans.cod_prog_dtsul = 'bc9008' No-error.

If  Not AvailAble bc-prog-trans Then Do:

    {utp/ut-liter.i Progama_bc9008_n∆o_esta_relacionado_com_nemhuma_transaá∆o *}
    message Return-value. 

    return no-apply.

End.
assign c-transacao = bc-prog-trans.cd-trans.

{utp/ut-liter.i Resumo_Aberto... *}
assign  vDesStatusEmbarque:bgcolor In Frame {&Frame-Name}       = 12
         vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piConfereEmbarque wgEmbarque 
PROCEDURE piConfereEmbarque :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define var v-qtd-embarcada-seq  as decimal FORMAT  "->>>>,>>9.9999"      no-undo. 
DEF VAR d-qtd-item AS DEC NO-UNDO.
DEF VAR d-qtd-comp AS DEC NO-UNDO.
DEFINE VARIABLE i-cont AS INTEGER     NO-UNDO.
If Session:Set-Wait-State('general') Then.

Status Input c-atualizando.

if not avail tt-pre-fatur 
then 
    return no-apply.


assign vNumAviso = tt-pre-fatur.cdd-embarq
       vnrresumo = tt-pre-fatur.nr-resumo.

Enable btFechaAviso With Frame {&Frame-Name}.

For each tt-confere-aviso:
    Delete tt-confere-aviso.
End.

for each tt-integracao-400:
    delete tt-integracao-400.
end.

for each tt-it-pre-fat:
    delete tt-it-pre-fat.
end.

create tt-integracao-400.
assign 
       tt-integracao-400.cdd-embarq            = vnumaviso
       tt-integracao-400.nr-resumo-ini         = vnrresumo
       tt-integracao-400.nr-resumo-fim         = vnrresumo
       tt-integracao-400.cod-versao-integracao = 1
       tt-integracao-400.ler-it-dep-fat        = no
       l-sit-resumo-1 = no 
       l-sit-resumo-2 = no
       l-sit-resumo-3 = no
       l-sit-resumo-4 = no.

run ftp/ftapi400.p (input  table tt-integracao-400,
                    output table tt-it-pre-fat,
                    output table tt-it-dep-fat,
                    input-output table tt-erro).

For each tt-it-pre-fat:

    assign de-total-item = 0
           d-qtd-item    = 0
           i-cont        = 0.

    FOR EACH b-tt-it-pre-fat WHERE
             b-tt-it-pre-fat.cdd-embarq   = tt-it-pre-fat.cdd-embarq   AND
             b-tt-it-pre-fat.nr-resumo    = tt-it-pre-fat.nr-resumo    AND
             b-tt-it-pre-fat.it-codigo    = tt-it-pre-fat.it-codigo    AND
             b-tt-it-pre-fat.nr-sequencia = tt-it-pre-fat.nr-sequencia NO-LOCK:   
        ASSIGN d-qtd-item = d-qtd-item + b-tt-it-pre-fat.qt-faturada
               i-cont = i-cont + 1.
    END.

    for each  bc-integracao 
         Where bc-integracao.decimal-2          = tt-it-pre-fat.cdd-embarq
         and   bc-integracao.inteiro-indice-2   = tt-it-pre-fat.nr-resumo
         And   bc-integracao.caracter-indice-1  = tt-it-pre-fat.it-codigo 
         and   bc-integracao.caracter-indice-2  = tt-it-pre-fat.cod-refer
         and   bc-integracao.cd-trans           = c-transacao
         no-lock:

         assign de-total-item = de-total-item  + bc-integracao.decimal-1.  
    end.     

    Find First Item No-lock         
        Where Item.it-codigo = tt-it-pre-fat.it-codigo NO-ERROR.
                
    /* calculo do que ja adicionado nas sequencias anteriores */
    FOR EACH b-tt-confere-aviso WHERE
             b-tt-confere-aviso.cdd-embarq   = tt-it-pre-fat.cdd-embarq AND
             b-tt-confere-aviso.nr-resumo    = tt-it-pre-fat.nr-resumo  AND
             b-tt-confere-aviso.nr-ped-cli   = tt-it-pre-fat.nr-pedcli  AND
             b-tt-confere-aviso.cod-item     = tt-it-pre-fat.it-codigo  AND
             b-tt-confere-aviso.nr-sequencia < tt-it-pre-fat.nr-sequencia:
             ASSIGN v-qtd-embarcada-seq = v-qtd-embarcada-seq + b-tt-confere-aviso.qtd-embarcada.
    END.
    /* calculo do total menos o que ja fora aplicado */
    IF v-qtd-embarcada-seq <> 0 THEN DO:
         FOR EACH b-tt-confere-aviso WHERE
                  b-tt-confere-aviso.cdd-embarq   = tt-it-pre-fat.cdd-embarq   AND
                  b-tt-confere-aviso.nr-resumo    = tt-it-pre-fat.nr-resumo    AND
                  b-tt-confere-aviso.nr-ped-cli   = tt-it-pre-fat.nr-pedcli    AND
                  b-tt-confere-aviso.cod-item     = tt-it-pre-fat.it-codigo    AND
                  b-tt-confere-aviso.nr-sequencia < tt-it-pre-fat.nr-sequencia :
              
            IF b-tt-confere-aviso.qtd-embarcada <=  b-tt-confere-aviso.qtd-aberto THEN DO:
                ASSIGN de-total-item = 0.
            END.
            ELSE DO:
                ASSIGN de-total-item = de-total-item - b-tt-confere-aviso.qtd-embarcada
                       /*d-qtd-item    = d-qtd-item - b-tt-confere-aviso.qtd-embarcada*/.
            END.
         END.
    END.

    /* para descobrir qual a ultima sequencia, pois a ultima recebera a sobra */
    FIND FIRST b-tt-it-pre-fat WHERE
               b-tt-it-pre-fat.cdd-embarq   = tt-it-pre-fat.cdd-embarq AND
               b-tt-it-pre-fat.nr-resumo    = tt-it-pre-fat.nr-resumo  AND
               b-tt-it-pre-fat.nr-pedcli    = tt-it-pre-fat.nr-pedcli  AND
               b-tt-it-pre-fat.it-codigo    = tt-it-pre-fat.it-codigo  AND
               b-tt-it-pre-fat.nr-sequencia > tt-it-pre-fat.nr-sequencia NO-ERROR .
        
    /* existem prox sequencias p mesmo item */
    IF AVAILABLE b-tt-it-pre-fat THEN DO:
         DO WHILE de-total-item > tt-it-pre-fat.qt-faturada:
               IF de-total-item > (tt-it-pre-fat.qt-faturada + 1) THEN DO:
                   ASSIGN de-total-item = de-total-item - 1.
               END.
               ELSE DO:
                   ASSIGN de-total-item = de-total-item - 0.0001.
               END.
         END.
    END.

    Find First Item No-lock         
         Where Item.it-codigo = tt-it-pre-fat.it-codigo NO-ERROR.

    Create tt-confere-aviso.
    Assign tt-confere-aviso.cdd-embarq    = tt-it-pre-fat.cdd-embarq
           tt-confere-aviso.cod-item      = tt-it-pre-fat.it-codigo
           tt-confere-aviso.nr-sequencia  = tt-it-pre-fat.nr-sequencia
           tt-confere-aviso.cod-refer     = tt-it-pre-fat.cod-refer
           tt-confere-aviso.nr-ped-cli    = tt-it-pre-fat.nr-pedcli
           tt-confere-aviso.des-item      = if avail item Then item.desc-item Else ''
           tt-confere-aviso.qtd-faturada  = tt-it-pre-fat.qt-faturada 
           tt-confere-aviso.qtd-embarcada = IF (de-total-item = d-qtd-item) THEN tt-it-pre-fat.qt-faturada ELSE (de-total-item / i-cont)
           de-total-item                  = IF (de-total-item - tt-it-pre-fat.qt-faturada) > 0 THEN de-total-item - tt-it-pre-fat.qt-faturada ELSE 0
           tt-confere-aviso.qtd-aberto    = (tt-it-pre-fat.qt-faturada - tt-confere-aviso.qtd-embarcada)
           tt-confere-aviso.nr-resumo     = tt-it-pre-fat.nr-resumo.

    /*DELETE tt-it-pre-fat.*/

    If   tt-confere-aviso.qtd-embarcada = 0 Then Do:
         Assign l-sit-resumo-1 = yes.
    End.
    Else 
    If   tt-confere-aviso.qtd-faturada   > tt-confere-aviso.qtd-embarcada And
         tt-confere-aviso.qtd-embarcada <> 0 Then Do:
         Assign l-sit-resumo-2 = yes.
    End.
    Else
    If   tt-confere-aviso.qtd-faturada   = tt-confere-aviso.qtd-embarcada Then Do:
         Assign l-sit-resumo-3 = yes.
    End.
    Else                
    If   tt-confere-aviso.qtd-faturada   < tt-confere-aviso.qtd-embarcada Then Do:
         Assign l-sit-resumo-4 = yes.
    End.

End. /* For each tt-aviso-enbarque */


if  l-sit-resumo-1 = yes 
and l-sit-resumo-2 = no
and l-sit-resumo-3 = no
and l-sit-resumo-4 = no
then 
   assign i-sit-resumo = 12.
else 
if  l-sit-resumo-1 = no
and l-sit-resumo-2 = yes
and l-sit-resumo-3 = no
and l-sit-resumo-4 = no
then 
    assign i-sit-resumo = 9.
else 
if  l-sit-resumo-1 = no
and l-sit-resumo-2 = no
and l-sit-resumo-3 = yes
and l-sit-resumo-4 = no
then 
    assign i-sit-resumo = 2
           tt-pre-fatur.log-2 = yes.
else 
if  l-sit-resumo-1 = no
and l-sit-resumo-2 = no
and l-sit-resumo-3 = no
and l-sit-resumo-4 = yes
then 
    assign i-sit-resumo = 5.
else
if  l-sit-resumo-1 = no
and l-sit-resumo-2 = no
and l-sit-resumo-3 = yes
and l-sit-resumo-4 = yes
then 
    assign i-sit-resumo = 5.
else     
    assign i-sit-resumo = 9.

Find First bc-integracao no-lock
     Where bc-integracao.decimal-2          = vNumAviso 
     and   bc-integracao.inteiro-indice-2   = vnrresumo
     and   bc-integracao.cd-trans           = c-transacao
     No-Error.

If  Available bc-integracao Then Do:

    If  bc-integracao.logico-1 = Yes Then Do: /* Embarque Fechado */

        If  btFechaAviso:Load-Image('image/im-smabe.bmp') Then.
        Assign vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = c-fechado.
        Assign btFechaAviso:ToolTip In Frame {&Frame-Name} = c-abrir
               vDesStatusEmbarque:bgcolor In Frame {&Frame-Name} = 2.

    End. /* bc-integracao.logico-1 = Yes */

    If  bc-integracao.logico-1 = No Then Do: /* Embarque Aberto */

        btFechaAviso:ToolTip In Frame {&Frame-Name} = c-fechar.

        if  i-sit-resumo = 2 
        Then Do:
            {utp/ut-liter.i Resumo_Atendido_Total... *}
            assign  vDesStatusEmbarque:bgcolor In Frame {&Frame-Name}      = i-sit-resumo
                    vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value.
        End.

        if  i-sit-resumo = 12 
        Then Do:
            {utp/ut-liter.i Resumo_Aberto... *}
            assign  vDesStatusEmbarque:bgcolor In Frame {&Frame-Name}      = i-sit-resumo
                    vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value. 
        End.
        if  i-sit-resumo = 5
        Then Do:
            {utp/ut-liter.i Resumo_com_Divergàncias... *}
            assign  vDesStatusEmbarque:bgcolor In Frame {&Frame-Name}      = i-sit-resumo
                    vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value.
        End.

        if  i-sit-resumo = 9 
        Then Do:
            {utp/ut-liter.i Resumo_Atendido_Parcial... *}
            assign  vDesStatusEmbarque:bgcolor In Frame {&Frame-Name}      = i-sit-resumo
                    vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value.
        End.
        If  btFechaAviso:Load-Image('image/im-smfec.bmp') Then.

    End. /* bc-integracao.logico-1 = No */

End. /* Available bc-integracao */      
Else
Do: /* Embarque Aberto */

    If  btFechaAviso:Load-Image('image/im-smfec.bmp') Then.

    {utp/ut-liter.i Resumo_Aberto... *}
    assign  vDesStatusEmbarque:bgcolor In Frame {&Frame-Name}      = i-sit-resumo
            vDesStatusEmbarque:Screen-Value In Frame {&Frame-Name} = Return-value. 


End. /* bc-integracao.logico-1 = No */

if  l-mostra-item then do:
    CLOSE QUERY bConfere.
    OPEN QUERY bConfere FOR EACH tt-confere-aviso.

    Status Input c-ultima-atualizacao + " " + String(Today,'99/99/9999') + ' ' + String(Time,'HH:MM:SS').

end.

If Session:Set-Wait-State('') Then.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records wgEmbarque  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "tt-pre-fatur"}
  {src/adm/template/snd-list.i "tt-confere-aviso"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed wgEmbarque 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE NO-UNDO.
  DEFINE INPUT PARAMETER p-state AS CHARACTER NO-UNDO.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

