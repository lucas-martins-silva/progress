&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V36AD107 2.00.00.095 } /*** "010095" 29/10/2026 13:42:21 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i V36AD107 MUT}
&ENDIF


{cdp/cdcfgfin.i} /** Include de verificaá∆o de funá‰es da vers∆o **/
{include/i_prdvers.i} /* Include de versao de banco de dados */
{cdp/cdcfgdis.i}
{include/i_fnctrad.i}

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
DEF VAR l-nfe AS LOG NO-UNDO.

DEF VAR h-bodi520        AS HANDLE NO-UNDO.
DEF VAR l-tss-nfe        AS LOG    NO-UNDO.
DEF VAR l-envio-vers-tss AS LOG    NO-UNDO.
DEF VAR cTpTrans         AS CHAR   NO-UNDO.
DEF VAR c-ins-municipal  LIKE estabelec.ins-municipal NO-UNDO.

{method/dbotterr.i}

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
&Scoped-define EXTERNAL-TABLES estabelec
&Scoped-define FIRST-EXTERNAL-TABLE estabelec


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rs-nfe tb-permite-conting tb-utiliza-docto-tag ~
c-cdn-msg-contingen rs-transmissao fi-versao-layout tb-emite-cce fi-local ~
rs-extensao-arq bt-diretorio fi-versao-emissor fi-versao-cce ~
tg-log-atualiza-sit-nf-e-batch c-fuso-horario tb-permite-event-prorrog ~
fi-versao-evt-epp RECT-3 RECT-4 RECT-5 RECT-8 RECT-10 RECT-11 tb-zera-cod-chave ~
tg-atualiza-data-hora-automatica tb-emite-reg-saida tb-norma-abnt-5891 tb-demonstrar-impostos-por-item ~
tb-emissao-nfe-sem-email-dest fi-prazo-cancelamento fi-versao-evt-ator fi-versao-evt-comp-entrega 
&Scoped-Define DISPLAYED-OBJECTS tb-uf-inutiliza rs-nfe tb-permite-conting tb-utiliza-docto-tag fi-site-danfe-simp-t2 ~
c-cdn-msg-contingen rs-transmissao fi-versao-layout cbx-cdn-regim-tribut tb-contr-excl-ibscbs ~
tb-emite-cce fi-local rs-extensao-arq fi-versao-emissor fi-versao-cce ~
tg-log-atualiza-sit-nf-e-batch c-fuso-horario tb-permite-event-prorrog ~
fi-versao-evt-epp tg-atualiza-data-hora-automatica tb-emite-reg-saida tb-zera-cod-chave fi-site-danfe-simp-t2 ~
tb-norma-abnt-5891 tb-demonstrar-impostos-por-item tb-emissao-nfe-sem-email-dest fi-prazo-cancelamento fi-versao-evt-ator fi-versao-evt-comp-entrega

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS rs-nfe rs-transmissao 
&Scoped-define ADM-MODIFY-FIELDS rs-nfe rs-transmissao cbx-cdn-regim-tribut ~
fi-versao-cce fi-versao-evt-epp tb-permite-event-prorrog tb-utiliza-docto-tag ~
tg-log-atualiza-sit-nf-e-batch c-fuso-horario tg-atualiza-data-hora-automatica tb-zera-cod-chave tb-uf-inutiliza fi-site-danfe-simp-t2 tb-contr-excl-ibscbs ~
tb-norma-abnt-5891 tb-demonstrar-impostos-por-item tb-emissao-nfe-sem-email-dest fi-versao-evt-ator fi-prazo-cancelamento fi-versao-evt-comp-entrega

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "",
     Keys-Supplied = ""':U).
/**************************
</EXECUTING-CODE> */   

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-diretorio 
     IMAGE-UP FILE "image\im-sea":U
     IMAGE-INSENSITIVE FILE "image\ii-sea":U
     LABEL "" 
     SIZE 4 BY 1 TOOLTIP "Diret¢rio".

DEFINE VARIABLE c-fuso-horario AS CHARACTER FORMAT "X(60)":U 
     LABEL "Fuso Hor†rio (UTC)" 
     VIEW-AS COMBO-BOX INNER-LINES 10
     LIST-ITEMS "","-11:00","-10:00","-09:00","-08:00","-07:00","-06:00","-05:00","-04:00","-03:00","-02:00","-01:00","+00:00","+01:00","+02:00","+03:00","+04:00","+05:00","+06:00","+07:00","+08:00","+09:00","+10:00","+11:00","+12:00" 
     DROP-DOWN-LIST
     SIZE 17 BY .88 NO-UNDO.

DEFINE VARIABLE cbx-cdn-regim-tribut AS CHARACTER FORMAT "X(256)":U 
     LABEL "C¢d Regime Trib":U 
     VIEW-AS COMBO-BOX INNER-LINES 999
     DROP-DOWN-LIST
     SIZE 24 BY .88 NO-UNDO.

DEFINE VARIABLE c-cdn-msg-contingen AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "C¢digo da Mensagem" 
     VIEW-AS FILL-IN 
     SIZE 6.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-local AS CHARACTER FORMAT "X(256)":U 
     LABEL "Diret¢rio Arquivos" 
     VIEW-AS FILL-IN 
     SIZE 61.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-prazo-cancelamento AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "Prazo Alerta Cancelamento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-site-danfe-simp-t2 AS CHARACTER FORMAT "X(256)":U 
     LABEL "Site DANFE Simplificado Tipo 2" 
     VIEW-AS FILL-IN 
     SIZE 54 BY .88 TOOLTIP "Site Secretaria da Fazenda QRCode DANFE Simplificado Tipo 2" NO-UNDO.

DEFINE VARIABLE fi-versao-cce AS CHARACTER FORMAT "x(4)":U 
     LABEL "Vers∆o Evento" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-versao-emissor AS CHARACTER FORMAT "X(10)":U 
     LABEL "Vers∆o Emissor NF-e" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Vers∆o do Software Emissor Gratuito de Nota Fiscal Eletrìnica (NF-e)" NO-UNDO.

DEFINE VARIABLE fi-versao-evt-ator AS CHARACTER FORMAT "x(5)":U 
     LABEL "Vers∆o Evento (Ator Interessado)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-versao-evt-comp-entrega AS CHARACTER FORMAT "x(5)":U 
     LABEL "Vers∆o Evento (Compr Entrega)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-versao-evt-epp AS CHARACTER FORMAT "x(4)":U 
     LABEL "Vers∆o Evento (EPP)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-versao-evt-reg-saida AS CHARACTER FORMAT "x(10)":U 
     LABEL "Vers∆o Evento (Reg Sa°da)" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE fi-versao-layout AS CHARACTER FORMAT "X(10)":U 
     LABEL "Vers∆o Layout" 
     VIEW-AS FILL-IN 
     SIZE 8.86 BY .88 NO-UNDO.

DEFINE VARIABLE rs-extensao-arq AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "TXT", 1,
"XML", 2
     SIZE 13 BY .88 NO-UNDO.

DEFINE VARIABLE rs-nfe AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Nenhum", 1,
"Homologaá∆o", 2,
"Produá∆o", 3
     SIZE 15.29 BY 3 NO-UNDO.

DEFINE VARIABLE rs-transmissao AS INTEGER INITIAL 1 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Aplicaá∆o Transmiss∆o", 1,
"Transmiss∆o Manual", 2
     SIZE 19 BY 2 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 2.46.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 82.57 BY 8.21.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 15.71.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 17.72 BY 3.5.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 20.72 BY 3.5.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 3.25.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.86 BY 3.5.

DEFINE VARIABLE tb-contr-excl-ibscbs AS LOGICAL INITIAL no 
     LABEL "Contribuinte Exclusivo do IBS/CBS" 
     VIEW-AS TOGGLE-BOX
     SIZE 37.14 BY .83 NO-UNDO.

DEFINE VARIABLE tb-demonstrar-impostos-por-item AS LOGICAL INITIAL no 
     LABEL "Demonstrar Impostos Consumidor por Item" 
     VIEW-AS TOGGLE-BOX
     SIZE 33 BY .83 NO-UNDO.

DEFINE VARIABLE tb-emissao-nfe-sem-email-dest AS LOGICAL INITIAL no 
     LABEL "Bloqueia emiss∆o NF-e sem e-mail do Destin†rio do XML" 
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .83 NO-UNDO.

DEFINE VARIABLE tb-emite-cce AS LOGICAL INITIAL no 
     LABEL "Emite Carta de Correá∆o" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tb-emite-reg-saida AS LOGICAL INITIAL no 
     LABEL "Permite Evento Registro de Sa°da p/ MG" 
     VIEW-AS TOGGLE-BOX
     SIZE 30 BY .83 NO-UNDO.

DEFINE VARIABLE tb-norma-abnt-5891 AS LOGICAL INITIAL no 
     LABEL "Norma ABNT 5891 para C†lc. de ISS" 
     VIEW-AS TOGGLE-BOX
     SIZE 28 BY .83 NO-UNDO.

DEFINE VARIABLE tb-permite-conting AS LOGICAL INITIAL no 
     LABEL "Permite Contingància NF-e" 
     VIEW-AS TOGGLE-BOX
     SIZE 21 BY .83 NO-UNDO.

DEFINE VARIABLE tb-permite-event-prorrog AS LOGICAL INITIAL no 
     LABEL "Permite Evento Pedido Prorrog. Susp. ICMS" 
     VIEW-AS TOGGLE-BOX
     SIZE 32.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-uf-inutiliza AS LOGICAL INITIAL no 
     LABEL "Inutilizaá∆o Desativada - SEFAZ" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.57 BY .83 NO-UNDO.

DEFINE VARIABLE tb-utiliza-docto-tag AS LOGICAL INITIAL no 
     LABEL "Utiliza Regras Espec°ficas para Transmiss∆o de Doc. Eletrìnicos" 
     VIEW-AS TOGGLE-BOX
     SIZE 46.43 BY .83 NO-UNDO.

DEFINE VARIABLE tb-zera-cod-chave AS LOGICAL INITIAL yes 
     LABEL "Permite Zerar C¢digo da Chave NF-e" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.57 BY .83 NO-UNDO.

DEFINE VARIABLE tg-atualiza-data-hora-automatica AS LOGICAL INITIAL no 
     LABEL "Atualiza Data/Hora de Sa°da/Entrada Automaticamente" 
     VIEW-AS TOGGLE-BOX
     SIZE 41 BY .83 NO-UNDO.

DEFINE VARIABLE tg-log-atualiza-sit-nf-e-batch AS LOGICAL INITIAL no 
     LABEL "Atualiza Situaá∆o NF-e Batch" 
     VIEW-AS TOGGLE-BOX
     SIZE 24.43 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     rs-nfe AT ROW 2.13 COL 3.43 HELP
          "Selecione o processo de emiss∆o de NF-e" NO-LABEL
     rs-transmissao AT ROW 2.42 COL 21.86 HELP
          "Tipo de Transmiss∆o" NO-LABEL
     fi-versao-layout AT ROW 2.21 COL 53 COLON-ALIGNED HELP
          "Vers∆o do Layout (XML ou TXT)"
     cbx-cdn-regim-tribut AT ROW 3.21 COL 53 COLON-ALIGNED HELP
          "Selecione o Regime Tribut†rio para o Estabelecimento"
     tb-contr-excl-ibscbs AT ROW 4.21 COL 42.86 HELP
          "Indica se Ç Contribuinte Exclusivo do IBS/CBS, conforme regras da NT 2026.007" WIDGET-ID 18
     fi-local AT ROW 6.08 COL 15.72 COLON-ALIGNED HELP
          "Diret¢rio para armazenar arquivos TXT de notas"
     bt-diretorio AT ROW 6.04 COL 79.29 HELP
          "Selecione Diret¢rio"
     rs-extensao-arq AT ROW 7.08 COL 17.72 HELP
          "Tipo de arquivo gerado para transmiss∆o manual" NO-LABEL
     fi-versao-emissor AT ROW 7.08 COL 67 COLON-ALIGNED HELP
          "Vers∆o do Software Emissor Gratuito de Nota Fiscal Eletrìnica"
     tb-permite-conting AT ROW 9.13 COL 3.14 HELP
          "Permite Contingància NF-e"
     tb-emite-cce AT ROW 10.04 COL 3.14 HELP
          "Marcar caso o Estabelecimento permite Emitir Carta de Correá∆o Eletrìnica"
     tb-permite-event-prorrog AT ROW 11 COL 3.14 HELP
          "Indica que o Estabelec. permite solicitar Ped. Prorrog. Suspens∆o ICMS Remessas"
     tb-emite-reg-saida AT ROW 11.92 COL 3.14 HELP
          "Permitir emiss∆o do Registro de Sa°da para MG (TSS/TC2)"
     tg-log-atualiza-sit-nf-e-batch AT ROW 12.83 COL 3.14 HELP
          "Indicar a forma de atualizaá∆o da situaá∆o da NF-e":U
     tg-atualiza-data-hora-automatica AT ROW 13.79 COL 3.14 HELP
          "Atualiza data/hora de sa°da com a data/hora de emiss∆o da nota":U
     tb-emissao-nfe-sem-email-dest AT ROW 14.71 COL 3.14 HELP
          "Verifica e-mail dos contatos do cliente e transportador":U
     tb-zera-cod-chave AT ROW 15.63 COL 3.14 HELP
          "Permite zerar C¢digo Aleat¢rio Chave NF-e Docto Referenciado"
     c-cdn-msg-contingen AT ROW 8.75 COL 68.14 COLON-ALIGNED HELP
          "Informar o c¢digo da mensagem de Contingància"
     fi-versao-cce AT ROW 9.71 COL 68.14 COLON-ALIGNED HELP
          "Informar a vers∆o dos eventos da NF-e"
     fi-versao-evt-epp AT ROW 10.71 COL 68.14 COLON-ALIGNED HELP
          "Indica a vers∆o utilizada no Evento Pedido Prorrogaá∆o"
     fi-versao-evt-reg-saida AT ROW 11.71 COL 68.14 COLON-ALIGNED HELP
          "Indica a vers∆o utilizada no Evento Registro de Sa°da (TSS/TC2)"
     fi-versao-evt-comp-entrega AT ROW 12.71 COL 68.14 COLON-ALIGNED HELP
          "Vers∆o utilizada no Evento de Comprovante de Entrega(TSS/TC2)"
     fi-versao-evt-ator AT ROW 13.71 COL 68.14 COLON-ALIGNED HELP
          "Vers∆o utilizada no Evento Ator Interessado(TSS/TC2)"
     fi-prazo-cancelamento AT ROW 14.71 COL 68.14 COLON-ALIGNED HELP
          "N£mero de horas para alerta de prazo de cancelamento"
     c-fuso-horario AT ROW 15.71 COL 60 COLON-ALIGNED HELP
          "Informar o Fuso Hor†rio no padr∆o UTC para o Estabelecimento":U
     tb-utiliza-docto-tag AT ROW 17.79 COL 3 HELP
          "Utiliza Regras Espec°ficas para Transmiss∆o de Doc. Eletrìnicos"
     tb-demonstrar-impostos-por-item AT ROW 18.71 COL 3 HELP
          "Demonstra Impostos Consumidor por item no XML/DANFE"
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 4.

/* DEFINE FRAME statement is approaching 4K Bytes.  Breaking it up   */
DEFINE FRAME f-main
     tb-norma-abnt-5891 AT ROW 17.79 COL 50.43 HELP
          "Utiliza Arredondamento conforme Norma ABNT 5891"
     tb-uf-inutiliza AT ROW 18.63 COL 50.43 HELP
          "Indica que a UF N∆o Possui Pedido de Inutilizaá∆o na SEFAZ"
     fi-site-danfe-simp-t2 AT ROW 19.58 COL 22.72 COLON-ALIGNED HELP
          "Site Secretaria da Fazenda QRCode DANFE Simplificado Tipo 2" WIDGET-ID 16
     " Ambiente" VIEW-AS TEXT
          SIZE 8 BY .54 AT ROW 1.54 COL 3.57
     "Formato Arquivo:" VIEW-AS TEXT
          SIZE 11.72 BY .54 AT ROW 7.17 COL 5.43
     " Processos NF-e" VIEW-AS TEXT
          SIZE 12.43 BY .54 AT ROW 8.29 COL 3.57
     " Identificaá∆o" VIEW-AS TEXT
          SIZE 9.72 BY .54 AT ROW 1.54 COL 43.29
     " Para Emiss∆o com Transmiss∆o Manual" VIEW-AS TEXT
          SIZE 28.14 BY .54 AT ROW 5.38 COL 3.57
     " Transmiss∆o" VIEW-AS TEXT
          SIZE 10 BY .54 AT ROW 1.83 COL 22 WIDGET-ID 10
     "NF-e" VIEW-AS TEXT
          SIZE 4 BY .54 AT ROW 1 COL 3.57 WIDGET-ID 14
     " Gerais" VIEW-AS TEXT
          SIZE 5 BY .54 AT ROW 17.17 COL 3.57
     RECT-3 AT ROW 1.38 COL 1
     RECT-4 AT ROW 1.75 COL 2.29
     RECT-5 AT ROW 1.75 COL 20.72
     RECT-8 AT ROW 1.75 COL 42
     RECT-10 AT ROW 5.67 COL 2.29
     RECT-11 AT ROW 8.58 COL 2.29
     RECT-7 AT ROW 17.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COLUMN 1 ROW 1 SCROLLABLE 
         FONT 4.


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.estabelec
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
         HEIGHT             = 19.83
         WIDTH              = 84.86.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cbx-cdn-regim-tribut IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET rs-nfe IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR RADIO-SET rs-transmissao IN FRAME f-main
   2 3                                                                  */
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

&Scoped-define SELF-NAME bt-diretorio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-diretorio V-table-Win
ON CHOOSE OF bt-diretorio IN FRAME f-main
DO:
    {utp/ut-liter.i Selecione_o_diret¢rio:}
    SYSTEM-DIALOG GET-DIR fi-local     
                  TITLE RETURN-VALUE.

    DISPLAY fi-local WITH FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cdn-msg-contingen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cdn-msg-contingen V-table-Win
ON F5 OF c-cdn-msg-contingen IN FRAME f-main /* C¢digo da Mensagem */
DO:
    {include/zoomvar.i &prog-zoom="adzoom/z01ad176.w"
                      &campo=c-cdn-msg-contingen
                      &campozoom=cod-mensagem}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cdn-msg-contingen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cdn-msg-contingen IN FRAME f-main /* C¢digo da Mensagem */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-cce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-cce V-table-Win
ON ENTRY OF fi-versao-cce IN FRAME f-main /* Vers∆o Evento */
DO:
    ASSIGN fi-versao-cce:FORMAT IN FRAME {&FRAME-NAME} = "9.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-cce V-table-Win
ON LEAVE OF fi-versao-cce IN FRAME f-main /* Vers∆o Evento */
DO:
    assign fi-versao-cce = input frame {&FRAME-NAME} fi-versao-cce no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-cce:format in frame {&FRAME-NAME} = "x(4)".
    end.
    else do:
        assign fi-versao-cce:format in frame {&FRAME-NAME} = "9.99".
    end.  

    IF       fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-cce:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-emissor
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-emissor V-table-Win
ON ENTRY OF fi-versao-emissor IN FRAME f-main /* Vers∆o Emissor NF-e */
DO:
    ASSIGN fi-versao-emissor:FORMAT IN FRAME {&FRAME-NAME} = "9.9X.9XX".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-emissor V-table-Win
ON LEAVE OF fi-versao-emissor IN FRAME f-main /* Vers∆o Emissor NF-e */
DO:
    assign fi-versao-emissor = input frame {&FRAME-NAME} fi-versao-emissor no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-emissor:format in frame {&FRAME-NAME} = "x(10)".
    end.
    else do:
        assign fi-versao-emissor:format in frame {&FRAME-NAME} = "9.9X.9XX".
    end.

    IF       fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-emissor:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-evt-ator
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-ator V-table-Win
ON ENTRY OF fi-versao-evt-ator IN FRAME f-main /* Vers∆o Evento (Ator Interessado) */
DO:
    ASSIGN fi-versao-evt-ator:FORMAT IN FRAME {&FRAME-NAME} = "9.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-ator V-table-Win
ON LEAVE OF fi-versao-evt-ator IN FRAME f-main /* Vers∆o Evento (Ator Interessado) */
DO:
    assign fi-versao-evt-ator = input frame {&FRAME-NAME} fi-versao-evt-ator no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-evt-ator:format in frame {&FRAME-NAME} = "x(5)".
    end.
    else do:
        assign fi-versao-evt-ator:format in frame {&FRAME-NAME} = "9.99".
    end.  

    IF       fi-versao-evt-ator:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-evt-ator:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-evt-ator:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-evt-ator:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-evt-comp-entrega
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-comp-entrega V-table-Win
ON ENTRY OF fi-versao-evt-comp-entrega IN FRAME f-main /* Vers∆o Evento (Compr Entrega) */
DO:
    ASSIGN fi-versao-evt-comp-entrega:FORMAT IN FRAME {&FRAME-NAME} = "9.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-comp-entrega V-table-Win
ON LEAVE OF fi-versao-evt-comp-entrega IN FRAME f-main /* Vers∆o Evento (Compr Entrega) */
DO:
    assign fi-versao-evt-comp-entrega = input frame {&FRAME-NAME} fi-versao-evt-comp-entrega no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-evt-comp-entrega:format in frame {&FRAME-NAME} = "x(5)".
    end.
    else do:
        assign fi-versao-evt-comp-entrega:format in frame {&FRAME-NAME} = "9.99".
    end.  

    IF       fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-evt-comp-entrega:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-evt-epp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-epp V-table-Win
ON ENTRY OF fi-versao-evt-epp IN FRAME f-main /* Vers∆o Evento (EPP) */
DO:
    ASSIGN fi-versao-evt-epp:FORMAT IN FRAME {&FRAME-NAME} = "9.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-epp V-table-Win
ON LEAVE OF fi-versao-evt-epp IN FRAME f-main /* Vers∆o Evento (EPP) */
DO:
    assign fi-versao-evt-epp = input frame {&FRAME-NAME} fi-versao-evt-epp no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-evt-epp:format in frame {&FRAME-NAME} = "x(4)".
    end.
    else do:
        assign fi-versao-evt-epp:format in frame {&FRAME-NAME} = "9.99".
    end.  

    IF       fi-versao-evt-epp:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-evt-epp:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-evt-epp:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-evt-epp:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-evt-reg-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-reg-saida V-table-Win
ON ENTRY OF fi-versao-evt-reg-saida IN FRAME f-main /* Vers∆o Evento (Reg Sa°da) */
DO:
    ASSIGN fi-versao-evt-reg-saida:FORMAT IN FRAME {&FRAME-NAME} = "9.99".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-evt-reg-saida V-table-Win
ON LEAVE OF fi-versao-evt-reg-saida IN FRAME f-main /* Vers∆o Evento (Reg Sa°da) */
DO:
    assign fi-versao-evt-reg-saida = input frame {&FRAME-NAME} fi-versao-evt-reg-saida no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-evt-reg-saida:format in frame {&FRAME-NAME} = "x(4)".
    end.
    else do:
        assign fi-versao-evt-reg-saida:format in frame {&FRAME-NAME} = "9.99".
    end.  

    IF       fi-versao-evt-reg-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-evt-reg-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-evt-reg-saida:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-evt-reg-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-versao-layout
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-layout V-table-Win
ON ENTRY OF fi-versao-layout IN FRAME f-main /* Vers∆o Layout */
DO:
    ASSIGN fi-versao-layout:FORMAT IN FRAME {&FRAME-NAME} = "9.99XXX".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-versao-layout V-table-Win
ON LEAVE OF fi-versao-layout IN FRAME f-main /* Vers∆o Layout */
DO:
    assign fi-versao-layout = input frame {&FRAME-NAME} fi-versao-layout no-error.
    
    if  error-status:get-number(1) <> 0 then do:
        assign fi-versao-layout:format in frame {&FRAME-NAME} = "x(10)".
    end.
    else do:
        assign fi-versao-layout:format in frame {&FRAME-NAME} = "9.99XXX".
    end.  

    IF       fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME}  = ""
    OR  TRIM(fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME}) = "." THEN
        ASSIGN fi-versao-layout:FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

    ASSIGN cbx-cdn-regim-tribut      :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           tb-emite-cce              :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           tb-emite-reg-saida        :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           tb-permite-event-prorrog  :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-reg-saida   :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-comp-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-ator        :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00").
    
    IF fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} < "2.00" THEN
        ASSIGN tb-emite-reg-saida:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tb-emite-reg-saida:CHECKED   IN FRAME {&FRAME-NAME} = NO.

    APPLY "VALUE-CHANGED":U TO tb-emite-cce             IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-permite-event-prorrog IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-emite-reg-saida       IN FRAME {&FRAME-NAME}.

    IF cTpTrans <> "TC2":U AND cTpTrans <> "TPF":U THEN
        DISABLE fi-versao-cce 
            WITH FRAME {&FRAME-NAME}.

    IF cTpTrans <> "TC2":U THEN
        DISABLE fi-versao-evt-epp 
               WITH FRAME {&FRAME-NAME}.
        
    IF cTpTrans = "TPF":U THEN
        DISABLE fi-versao-evt-reg-saida 
                fi-versao-evt-comp-entrega
            WITH FRAME {&FRAME-NAME}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-extensao-arq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-extensao-arq V-table-Win
ON ENTRY OF rs-extensao-arq IN FRAME f-main
DO:
    APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-extensao-arq V-table-Win
ON VALUE-CHANGED OF rs-extensao-arq IN FRAME f-main
DO:
    IF INPUT FRAME {&FRAME-NAME} rs-transmissao = 2 THEN DO: /* Transmiss∆o Manual */

        IF  INPUT FRAME {&FRAME-NAME} rs-extensao-arq = 1 THEN DO: /* TXT */
            
            ENABLE fi-versao-emissor 
                WITH FRAME {&FRAME-NAME}.
    
            {utp/ut-liter.i "Geraá∆o de Arquivo TXT em Transmiss∆o Manual" *}
    
        END.
        ELSE DO:  /* XML */
            DISABLE fi-versao-emissor
                WITH FRAME {&FRAME-NAME}.
    
            {utp/ut-liter.i "Geraá∆o de Arquivo XML em Transmiss∆o Manual" *}
        END.
       
        ASSIGN rs-extensao-arq:HELP IN FRAME {&FRAME-NAME} = RETURN-VALUE.
    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-nfe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-nfe V-table-Win
ON VALUE-CHANGED OF rs-nfe IN FRAME f-main
DO:
    IF INPUT FRAME {&FRAME-NAME} rs-nfe = 2 
    OR INPUT FRAME {&FRAME-NAME} rs-nfe = 3 THEN DO:
        ENABLE tb-permite-conting 
               tb-zera-cod-chave
               c-cdn-msg-contingen 
               fi-versao-layout 
               fi-local 
               bt-diretorio 
               rs-extensao-arq 
               fi-versao-emissor 
               rs-transmissao 
               tg-log-atualiza-sit-nf-e-batch 
               tg-atualiza-data-hora-automatica 
               tb-emite-reg-saida 
               c-fuso-horario 
            WITH FRAME {&FRAME-NAME}.

        ASSIGN cbx-cdn-regim-tribut      :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               fi-versao-cce             :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               tb-emite-cce              :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               fi-versao-evt-epp         :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               tb-permite-event-prorrog  :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               tb-emite-reg-saida        :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               fi-versao-evt-reg-saida   :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               fi-versao-evt-comp-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               fi-versao-evt-ator        :SENSITIVE IN FRAME {&FRAME-NAME} = (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
               fi-versao-layout          :FORMAT    IN FRAME {&FRAME-NAME} = "9.99XXX"
               fi-versao-emissor         :FORMAT    IN FRAME {&FRAME-NAME} = "9.9X.9XX".

        IF cTpTrans <> "TC2":U AND cTpTrans <> "TPF":U THEN
            DISABLE fi-versao-cce 
                WITH FRAME {&FRAME-NAME}.
        
            IF cTpTrans <> "TC2":U THEN
            DISABLE fi-versao-evt-epp 
                    WITH FRAME {&FRAME-NAME}.
        
        IF cTpTrans = "TPF":U THEN
            DISABLE fi-versao-evt-reg-saida 
                    fi-versao-evt-comp-entrega
                WITH FRAME {&FRAME-NAME}.

        FOR FIRST param-gener NO-LOCK 
            WHERE param-gener.cod-chave-1 = "param-comunic" 
              AND param-gener.cod-chave-2 = estabelec.cod-estabel   
              AND param-gener.cod-param   = "NF-e" :
            ASSIGN rs-transmissao = IF param-gener.cod-valor = "2" THEN 2 ELSE 1.
    
            DO WITH FRAME {&FRAME-NAME}:
                DISP rs-transmissao.
                DISABLE rs-transmissao.
            END.
        END.
    END.
    ELSE DO:
        ASSIGN tb-permite-conting        :CHECKED      IN FRAME {&FRAME-NAME} = NO
               tb-zera-cod-chave         :CHECKED      IN FRAME {&FRAME-NAME} = NO
               tb-emite-cce              :CHECKED      IN FRAME {&FRAME-NAME} = NO
               tb-emite-reg-saida        :CHECKED      IN FRAME {&FRAME-NAME} = NO
               c-cdn-msg-contingen       :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "0"
               rs-transmissao            :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1"
               fi-versao-layout          :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-versao-emissor         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-versao-evt-reg-saida   :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-versao-evt-ator        :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               rs-extensao-arq           :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1"
               fi-local                  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               c-fuso-horario            :SCREEN-VALUE IN FRAME {&FRAME-NAME} = " "
               fi-versao-layout          :FORMAT       IN FRAME {&FRAME-NAME} = "XX"
               fi-versao-emissor         :FORMAT       IN FRAME {&FRAME-NAME} = "XX".

        DISABLE tb-permite-conting 
                tb-zera-cod-chave
                tb-emite-cce 
                tb-permite-event-prorrog 
                tb-emite-reg-saida
                c-cdn-msg-contingen 
                fi-versao-layout 
                fi-local 
                bt-diretorio 
                rs-extensao-arq 
                fi-versao-emissor 
                fi-versao-cce 
                fi-versao-evt-epp 
                fi-versao-evt-reg-saida
                fi-versao-evt-comp-entrega
                fi-versao-evt-ator
                cbx-cdn-regim-tribut 
                rs-transmissao 
                tg-log-atualiza-sit-nf-e-batch 
                tg-atualiza-data-hora-automatica 
                c-fuso-horario 
            WITH FRAME {&FRAME-NAME}.
    END.

    APPLY "VALUE-CHANGED":U TO rs-transmissao           IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-emite-cce             IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-permite-conting       IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-zera-cod-chave        IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-permite-event-prorrog IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-emite-reg-saida       IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME rs-transmissao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-transmissao V-table-Win
ON ENTRY OF rs-transmissao IN FRAME f-main
DO:
    APPLY "VALUE-CHANGED":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL rs-transmissao V-table-Win
ON VALUE-CHANGED OF rs-transmissao IN FRAME f-main
DO:
    IF  INPUT FRAME {&FRAME-NAME} rs-transmissao = 1 THEN DO: /* Aplicaá∆o Transmiss∆o */
    
        DISABLE fi-local
                rs-extensao-arq
                fi-versao-emissor
                bt-diretorio WITH FRAME {&FRAME-NAME}.

        ASSIGN fi-local         :SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ""
               rs-extensao-arq  :SCREEN-VALUE IN FRAME {&FRAME-NAME} = "1".
    END.
    ELSE  /* Transmiss∆o Manual - informar diret¢rio reposit¢rio dos arquivos TXT */
        ENABLE  fi-local
                rs-extensao-arq
                fi-versao-emissor
                bt-diretorio WITH FRAME {&FRAME-NAME}.
        
    IF  INPUT FRAME {&FRAME-NAME} rs-transmissao = 1 THEN DO:  /* Aplicaá∆o Transmiss∆o */
        {utp/ut-liter.i "Aplicaá∆o de Transmiss∆o - Formato de Layout XML" *}
    END.
    ELSE DO:  /* Transmiss∆o Manual - informar diret¢rio reposit¢rio dos arquivos TXT */
        {utp/ut-liter.i "Transmiss∆o Manual - Formato de Layout TXT" *}
    END.
   
    ASSIGN rs-transmissao:HELP IN FRAME {&FRAME-NAME} = RETURN-VALUE.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-emite-cce
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-emite-cce V-table-Win
ON VALUE-CHANGED OF tb-emite-cce IN FRAME f-main /* Emite Carta de Correá∆o */
DO:
    IF cTpTrans = "TC2":U OR cTpTrans = "TPF":U THEN
        ASSIGN fi-versao-cce:SENSITIVE IN FRAME {&FRAME-NAME} = SELF:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-emite-reg-saida
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-emite-reg-saida V-table-Win
ON VALUE-CHANGED OF tb-emite-reg-saida IN FRAME f-main /* Permite Evento Registro de Sa°da p/ MG */
DO:
    IF cTpTrans = "TPF" THEN
        ASSIGN tb-emite-reg-saida:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
    ELSE
        ASSIGN fi-versao-evt-reg-saida:SENSITIVE IN FRAME {&FRAME-NAME} = SELF:CHECKED IN FRAME {&FRAME-NAME}.
        
    IF fi-versao-evt-reg-saida:SENSITIVE IN FRAME {&FRAME-NAME} = NO THEN
        ASSIGN fi-versao-evt-reg-saida:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-permite-conting
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-permite-conting V-table-Win
ON VALUE-CHANGED OF tb-permite-conting IN FRAME f-main /* Permite Contingància NF-e */
DO:
    ASSIGN c-cdn-msg-contingen:SENSITIVE IN FRAME {&FRAME-NAME} = SELF:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tb-permite-event-prorrog
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tb-permite-event-prorrog V-table-Win
ON VALUE-CHANGED OF tb-permite-event-prorrog IN FRAME f-main /* Permite Evento Pedido Prorrog. Susp. ICMS */
DO:
    IF cTpTrans = "TC2":U THEN
        ASSIGN fi-versao-evt-epp:SENSITIVE IN FRAME {&FRAME-NAME} = SELF:CHECKED IN FRAME {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  IF c-cdn-msg-contingen:LOAD-MOUSE-POINTER ("IMAGE~\lupa.cur") IN FRAME {&FRAME-NAME} THEN.

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
  {src/adm/template/row-list.i "estabelec"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estabelec"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE cArqSchema                        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDirSchema                        AS CHARACTER NO-UNDO.
    DEFINE VARIABLE cDirSchemaAux                     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-prazo-cancelamento              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE c-site-danfe-simp-t2              AS CHARACTER NO-UNDO.
    DEFINE VARIABLE iCont                             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE cVersaoLayout                     AS CHARACTER NO-UNDO.
    DEFINE VARIABLE i-rs-nfe                          AS INTEGER   NO-UNDO.
    DEFINE VARIABLE l-tb-permite-conting              AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-tb-emite-cce                    AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-permite-event-prorrog           AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE i-c-cdn-msg-contingen             AS INTEGER   NO-UNDO.
    DEFINE VARIABLE tp-integ                          AS CHARACTER NO-UNDO.
    DEFINE VARIABLE l-tb-utiliza-docto-tag            AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-tb-norma-abnt-5891              AS LOGICAL   NO-UNDO.       
    DEFINE VARIABLE l-tb-emissao-nfe-sem-email-dest   AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-tb-demonstrar-impostos-por-item AS LOGICAL   NO-UNDO.
    DEFINE VARIABLE l-tb-uf-inutiliza                 AS LOGICAL   NO-UNDO.

    ASSIGN i-rs-nfe                          = INT(rs-nfe                      :SCREEN-VALUE IN FRAME {&FRAME-NAME})
           i-c-cdn-msg-contingen             = INT(c-cdn-msg-contingen         :SCREEN-VALUE IN FRAME {&FRAME-NAME})
           l-tb-permite-conting              = tb-permite-conting              :CHECKED      IN FRAME {&FRAME-NAME}
           l-tb-emite-cce                    = tb-emite-cce                    :CHECKED      IN FRAME {&FRAME-NAME}
           l-permite-event-prorrog           = tb-permite-event-prorrog        :CHECKED      IN FRAME {&FRAME-NAME}
           l-tb-utiliza-docto-tag            = tb-utiliza-docto-tag            :CHECKED      IN FRAME {&FRAME-NAME}
           l-tb-demonstrar-impostos-por-item = tb-demonstrar-impostos-por-item :CHECKED      IN FRAME {&FRAME-NAME}
           l-tb-norma-abnt-5891              = tb-norma-abnt-5891              :CHECKED      IN FRAME {&FRAME-NAME} 
           l-tb-emissao-nfe-sem-email-dest   = tb-emissao-nfe-sem-email-dest   :CHECKED      IN FRAME {&FRAME-NAME}    
           l-tb-uf-inutiliza                 = tb-uf-inutiliza                 :CHECKED      IN FRAME {&FRAME-NAME}
           c-prazo-cancelamento              = INPUT FRAME {&FRAME-NAME} fi-prazo-cancelamento
           c-site-danfe-simp-t2              = INPUT FRAME {&FRAME-NAME} fi-site-danfe-simp-t2        
           cVersaoLayout           = fi-versao-layout        :SCREEN-VALUE IN FRAME {&FRAME-NAME}                  
           cVersaoLayout           = TRIM(cVersaoLayout).

    /* Code placed here will execute PRIOR to standard behavior. */
    if not frame {&frame-name}:validate() then
        return 'ADM-ERROR':U.

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e
       nem na PI-validate. */

    IF CAN-FIND(FIRST funcao
                WHERE funcao.cd-funcao = 'spp-nfe':U 
                  AND funcao.ativo) THEN DO:

        FIND FIRST mensagem NO-LOCK
             WHERE mensagem.cod-mensagem = INT(c-cdn-msg-contingen:SCREEN-VALUE IN FRAME {&FRAME-NAME}) NO-ERROR.              
             
        IF NOT AVAIL mensagem 
        AND c-cdn-msg-contingen:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> "0"
        AND c-cdn-msg-contingen:SCREEN-VALUE IN FRAME {&FRAME-NAME} <> " " THEN DO: /*0*/
            DEFINE VARIABLE c-lbl-liter-codigo-da-mensagem AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_da_mensagem_inv†lido" *}
            ASSIGN c-lbl-liter-codigo-da-mensagem = TRIM(RETURN-VALUE).

            DEFINE VARIABLE c-lbl-liter-codigo-da-mensagem-2 AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "C¢digo_da_mensagem_n∆o_corresponde_a_uma_mensagem_cadastrada_no_programa_CD0405_(Cadastro_de_Mensagem)" *}
            ASSIGN c-lbl-liter-codigo-da-mensagem-2 = TRIM(RETURN-VALUE).

            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 17006,
                               INPUT c-lbl-liter-codigo-da-mensagem + "~~" + c-lbl-liter-codigo-da-mensagem-2 + ".").

            APPLY 'entry':U to c-cdn-msg-contingen in frame {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
        END.
    END.

    IF  INPUT FRAME {&FRAME-NAME} rs-transmissao = 2 THEN DO: /*Tranmiss∆o Manual*/

        /* Verifica se o Diret¢rio informado existe - validar quando for informado ou quando deixar "" branco */
        ASSIGN FILE-INFO:FILENAME = INPUT FRAME {&FRAME-NAME} fi-local.

        IF  FILE-INFO:FULL-PATHNAME = ? THEN DO:

            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 4715,
                               INPUT INPUT FRAME {&FRAME-NAME} fi-local).

            APPLY "ENTRY":U TO INPUT FRAME {&FRAME-NAME} fi-local IN FRAME {&FRAME-NAME}.
            RETURN 'adm-error':U.
        END.

        /*Vers∆o do Software Emissor x Vers∆o Layout NF-e (Ex.: Versao Layout 2.00 com Versao Emissor 2.0.3) - s∆o validados os primeiros d°gitos das vers‰es informadas em tela */
        IF  STRING(REPLACE(REPLACE(TRIM(fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}),".",""),",","")) <> ""
        AND ( INT(SUBSTRING(TRIM(fi-versao-layout :SCREEN-VALUE IN FRAME {&FRAME-NAME}) ,1,1)) > INT(SUBSTRING(TRIM(fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}) ,1,1))
        OR    INT(SUBSTRING(TRIM(fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}) ,1,1)) > INT(SUBSTRING(TRIM(fi-versao-layout :SCREEN-VALUE IN FRAME {&FRAME-NAME}) ,1,1)) ) THEN DO:

            DEFINE VARIABLE c-lbl-liter-versao-software-em AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Vers∆o_Software_Emissor_NF-e_Inv†lida" *}
            ASSIGN c-lbl-liter-versao-software-em = TRIM(RETURN-VALUE).

            DEFINE VARIABLE c-lbl-liter-para-a-versao-layo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Para_a_Vers∆o_Layout_informada" *}
            ASSIGN c-lbl-liter-para-a-versao-layo = TRIM(RETURN-VALUE).
            
            DEFINE VARIABLE c-lbl-liter-a-versao-do-emisso AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "a_Vers∆o_do_Emissor_NF-e_Ç_inv†lida._D£vidas_sobre_vers‰es_vigentes_no_site_www.fazenda.sp.gov.br_ou_com_o_fornecedor_da_soluá∆o_de_Emissor_Gratuito_de_NF-e" *}
            ASSIGN c-lbl-liter-a-versao-do-emisso = TRIM(RETURN-VALUE).
            
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT c-lbl-liter-versao-software-em + "."
                                     + "~~" +
                                     c-lbl-liter-para-a-versao-layo + " " + "(" + TRIM(fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME}) + ")" + " " + c-lbl-liter-a-versao-do-emisso + "." ).

            APPLY 'entry':U to fi-versao-emissor in frame {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
        END.

    END.

    /*Elton - NFe 3.10*/
    IF i-rs-nfe <> 1 THEN DO: /* Somente SEFAZ */

        /* Vers∆o de Layout deve ser informada para layout SEFAZ, tanto para Aplicaá∆o Transmiss∆o como para Transmiss∆o Manual */
        IF (cVersaoLayout = ""
        OR  cVersaoLayout = ".") THEN DO:

            {utp/ut-liter.i "Vers∆o_de_Layout" *}
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 265,
                               INPUT RETURN-VALUE).

            APPLY "ENTRY":U TO fi-versao-layout IN FRAME {&FRAME-NAME}.
            RETURN 'adm-error':U.
        END.

        IF fi-versao-layout:FORMAT IN FRAME {&FRAME-NAME} <> "9.99XXX"
        AND cVersaoLayout <> "."
        AND INPUT FRAME {&FRAME-NAME} rs-transmissao = 2 THEN DO:

            DEFINE VARIABLE c-lbl-liter-conteudo-digitado AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Conte£do_digitado_inv†lido" *}
            ASSIGN c-lbl-liter-conteudo-digitado = TRIM(RETURN-VALUE).
            
            DEFINE VARIABLE c-lbl-liter-conteudo-do-campo AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Conte£do_do_campo_possui_formato_inv†lido" *}
            ASSIGN c-lbl-liter-conteudo-do-campo = TRIM(RETURN-VALUE).
            
            RUN utp/ut-msgs.p (INPUT "show",
                               INPUT 17006,
                               INPUT c-lbl-liter-conteudo-digitado + "."
                                     + "~~" +
                                     c-lbl-liter-conteudo-do-campo + ".").

            APPLY 'entry':U to fi-versao-layout in frame {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
        END.

        /* Valida vers∆o de layout x schema */
        IF (cVersaoLayout <> ""
        AND cVersaoLayout <> ".")
        AND INPUT FRAME {&FRAME-NAME} rs-transmissao = 1 THEN DO: /*Aplicaá∆o Transmiss∆o*/
            IF fi-versao-layout:FORMAT IN FRAME {&FRAME-NAME} <> "9.99XXX" THEN DO:

               DEFINE VARIABLE c-lbl-liter-conteudo-digitado-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Conte£do_digitado_inv†lido" *}
               ASSIGN c-lbl-liter-conteudo-digitado-2 = TRIM(RETURN-VALUE).

               DEFINE VARIABLE c-lbl-liter-conteudo-do-campo-2 AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Conte£do_do_campo_possui_formato_inv†lido" *}
               ASSIGN c-lbl-liter-conteudo-do-campo-2 = TRIM(RETURN-VALUE).
               
               RUN utp/ut-msgs.p (INPUT "show",
                                  INPUT 17006,
                                  INPUT c-lbl-liter-conteudo-digitado-2 + "."
                                        + "~~" +
                                        c-lbl-liter-conteudo-do-campo-2 + ".").

               APPLY 'entry':U to fi-versao-layout in frame {&FRAME-NAME}.
               RETURN 'ADM-ERROR':U.
            END.
        END.
    END.  

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

    if RETURN-VALUE = 'ADM-ERROR':U then
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */
    /* Code placed here will execute AFTER standard behavior.    */
    IF  AVAIL estabelec THEN DO:
        
        /* Regras espec°ficas para transmiss∆o de documentos eletrìnicos */
        FOR FIRST funcao EXCLUSIVE-LOCK
                WHERE funcao.cd-funcao = "spp-utiliza-docto-tag-" + estabelec.cod-estabel:
                ASSIGN funcao.ativo = l-tb-utiliza-docto-tag.       
        END.
        IF NOT AVAIL funcao THEN DO:
                CREATE funcao.
                ASSIGN funcao.cd-funcao = "spp-utiliza-docto-tag-" + estabelec.cod-estabel
                           funcao.descricao = "Tratamento tempor†rio para pacotes retroativos"
                           funcao.ativo = l-tb-utiliza-docto-tag.       
        END.    
        ASSIGN estabelec.log-utiliza-docto-tag = l-tb-utiliza-docto-tag.
                                
        &IF "{&product_version}" >= "12.1.X.034" &THEN
            ASSIGN estabelec.log-impto-consum = l-tb-demonstrar-impostos-por-item.
        &ELSE 
            ASSIGN OVERLAY(estabelec.char-2,279,1) = IF l-tb-demonstrar-impostos-por-item THEN
                                                                   "1"
                                                               ELSE 
                                                                   "2".
        &ENDIF 

        ASSIGN OVERLAY(estabelec.char-1,399,1) = IF tb-zera-cod-chave:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N".
                                                                
        /* Integraá∆o NFe X TSS */
        RUN cdp/cd0360b.p (INPUT  estabelec.cod-estabel,
                           INPUT  "NF-e",
                           OUTPUT tp-integ).
    
        IF (tp-integ = "TC":U 
        OR  tp-integ = "TSS":U) THEN DO:
    
            ASSIGN l-tss-nfe        = CAN-FIND (FIRST funcao 
                                                WHERE funcao.cd-funcao = "SPP-NFE"
                                                  AND funcao.ativo) AND             /* Funá∆o NF-e ativa */
                                      INPUT FRAME {&FRAME-NAME} rs-transmissao = 1  /* Transmiss∆o: 1-Aplicativo Transmiss∆o */
                   l-envio-vers-tss = NO.
    
            IF CAN-FIND(FIRST param-nf-estab WHERE
                              param-nf-estab.cod-estabel = estabelec.cod-estabel) THEN DO:
    
              IF estabelec.des-vers-layout <> STRING(cVersaoLayout) THEN
                   ASSIGN l-envio-vers-tss = YES. /* CfgVersao */
    
            END.
        END.

        ASSIGN estabelec.idi-tip-emis-nf-eletro = i-rs-nfe.
        
        IF cTpTrans = "TC2":U or cTpTrans = "TPF":U THEN DO:
            FIND FIRST param-manif-destin
                 WHERE param-manif-destin.cod-estab = estabelec.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            IF AVAIL param-manif-destin THEN DO:
                IF estabelec.idi-tip-emis-nf-eletro = 1 OR estabelec.idi-tip-emis-nf-eletro = 2 THEN
                   ASSIGN param-manif-destin.idi-md-ambien = 2.
                ELSE
                   ASSIGN param-manif-destin.idi-md-ambien = 1.
            END.
        END.
        
        ASSIGN estabelec.log-emite-danfe      = l-tb-permite-conting
               estabelec.idi-tip-layout       = 2
               estabelec.idi-tip-transm       = INPUT FRAME {&frame-name} rs-transmissao
               estabelec.des-vers-layout      = STRING(cVersaoLayout)
               estabelec.des-local-arq        = INPUT FRAME {&FRAME-NAME} fi-local
               estabelec.idi-control-emis-nfe = 2.

        ASSIGN OVERLAY(estabelec.char-1,381,1)   = INPUT FRAME {&FRAME-NAME} rs-extensao-arq
               OVERLAY(estabelec.char-1,392,4)   = c-prazo-cancelamento
               OVERLAY(estabelec.char-1,401,150) = c-site-danfe-simp-t2
               OVERLAY(estabelec.char-2,281,1)   = IF l-tb-uf-inutiliza THEN "S" ELSE "N".

        &if  "{&bf_dis_versao_ems}" >= "2.09":U &then
            ASSIGN estabelec.des-vers-software-emissor = STRING(TRIM(fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}))
                   estabelec.log-emite-carta-correc    = l-tb-emite-cce.
        &else 
            ASSIGN OVERLAY(estabelec.char-1,251,10)    = STRING(TRIM(fi-versao-emissor:SCREEN-VALUE IN FRAME {&FRAME-NAME}))
                   OVERLAY(estabelec.char-1,261,1)     = IF l-tb-emite-cce          THEN "S" ELSE "N"
                   OVERLAY(estabelec.char-1,380,1)     = IF l-permite-event-prorrog THEN "S" ELSE "N".
        &endif
        
        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
            FIND  reg-inf-compl
            WHERE reg-inf-compl.cod-tab-inform   = "estabelec"
            AND   reg-inf-compl.cod-campo-inform = "cdn-msg-contingen" NO-LOCK NO-ERROR.
    
            IF  NOT AVAIL reg-inf-compl THEN DO:
                CREATE reg-inf-compl.
                ASSIGN reg-inf-compl.cdn-identif        = 1
                       reg-inf-compl.cod-tab-inform     = "estabelec"
                       reg-inf-compl.cod-campo-inform   = "cdn-msg-contingen" 
                       reg-inf-compl.des-campo-inform   = "Cod Mensagem Contingància"
                       reg-inf-compl.idi-tipo           = 1 /* inteiro */
                       reg-inf-compl.num-decimal        = 0
                       reg-inf-compl.cod-format-campo   = ">>9". 
            END.
            
            FIND  inf-compl
            WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
              AND inf-compl.cod-indice = estabelec.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            
                        IF AVAIL inf-compl THEN
                                DELETE inf-compl.
                                
            CREATE inf-compl.
            ASSIGN inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                   inf-compl.cod-indice  = estabelec.cod-estabel
                   inf-compl.num-campo   = i-c-cdn-msg-contingen.
        &ENDIF

        IF i-pais-impto-usuario = 1 THEN
            ASSIGN OVERLAY(estabelec.char-1,262,6) = TRIM(INPUT FRAME {&FRAME-NAME} c-fuso-horario).
    END.                                                   

    IF  l-tss-nfe THEN DO:
            
        IF  INPUT FRAME {&FRAME-NAME} rs-nfe <> 1 THEN DO:
                        DEFINE VARIABLE l-modify-estab AS LOGICAL INITIAL NO    NO-UNDO.
                        /* se a ins municipal foi alterada, enviar YES para que o mÈtodo SPEDADM_ADMEMPRESAS seja executado (TVCNSP) */
                        IF c-ins-municipal <> estabelec.ins-municipal THEN
                                ASSIGN l-modify-estab = YES.

           /* Envia XML (CfgVersao) para o TSS */
           IF NOT VALID-HANDLE(h-bodi520) THEN DO:
               RUN dibo/bodi520.p PERSISTENT SET h-bodi520.
               RUN openQueryStatic IN h-bodi520 (INPUT "Main":U).
           END.
    
           EMPTY TEMP-TABLE RowErrors.
           RUN emptyRowErrors IN h-bodi520.
           RUN runAdaptersTSS IN h-bodi520 (INPUT estabelec.cod-estabel,
                                            INPUT l-modify-estab,
                                            INPUT NO,
                                            INPUT YES,
                                            INPUT NO,
                                            INPUT NO,
                                            INPUT NO,
                                            INPUT NO,
                                            INPUT NO,
                                            INPUT NO,
                                            INPUT NO,
                                            OUTPUT TABLE RowErrors).
           FOR FIRST RowErrors
               WHERE RowErrors.ErrorType <> "INTERNAL":U NO-LOCK:
    
               RUN utp/ut-msgs.p(INPUT "show":U,
                                INPUT 17006,
                                INPUT RowErrors.ErrorDescription + '~~' + RowErrors.ErrorHelp).
               UNDO, RETURN 'ADM-ERROR':U.
           END.
        END.

    END.
    
    FIND FIRST param-nf-estab 
         WHERE param-nf-estab.cod-estabel = estabelec.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
    
    IF AVAIL param-nf-estab THEN DO:
        IF fi-versao-cce:SENSITIVE IN FRAME {&FRAME-NAME} THEN DO:
            ASSIGN param-nf-estab.idi-tip-emis-nf-eletro = 1 /* Tipo de Emissao = Normal, para o caso de inclusao, pois este campo ≤ alimentado somente no FT0912 */
                   &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
                       param-nf-estab.des-vers-carta-correc = fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   &ELSE 
                       OVERLAY(param-nf-estab.cod-livre-1,219,10)= fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   &ENDIF.
        END.

        ASSIGN &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                   param-nf-estab.log-atualiza-sit-nf-eletro-batch = tg-log-atualiza-sit-nf-e-batch:CHECKED IN FRAME {&FRAME-NAME}
               &ELSE
                   param-nf-estab.log-livre-1 = tg-log-atualiza-sit-nf-e-batch:CHECKED IN FRAME {&FRAME-NAME}
               &ENDIF
               OVERLAY(param-nf-estab.cod-livre-1,232,10) = fi-versao-evt-epp         :SCREEN-VALUE IN FRAME {&FRAME-NAME}
               OVERLAY(param-nf-estab.cod-livre-1,486,10) = fi-versao-evt-reg-saida   :SCREEN-VALUE IN FRAME {&FRAME-NAME}
               OVERLAY(param-nf-estab.cod-livre-1,596,5)  = fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME}
               OVERLAY(param-nf-estab.cod-livre-1,601,5)  = fi-versao-evt-ator        :SCREEN-VALUE IN FRAME {&FRAME-NAME}
               OVERLAY(param-nf-estab.cod-livre-1,484,1)  = IF tg-atualiza-data-hora-automatica:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-1,485,1)  = IF tb-emite-reg-saida              :CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-4,386,1)  = IF l-tb-norma-abnt-5891            THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-4,387,1)  = IF l-tb-emissao-nfe-sem-email-dest THEN "S" ELSE "N"               
               OVERLAY(param-nf-estab.cod-livre-4,388,1)  = IF tb-contr-excl-ibscbs            :CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N".
    END.
    ELSE DO:
        CREATE param-nf-estab.
        ASSIGN param-nf-estab.cod-estabel            = estabelec.cod-estabel
               param-nf-estab.ind-empresa            = estabelec.cod-estabel
               param-nf-estab.idi-tip-emis-nf-eletro = 1 /* Tipo de Emissao = Normal, para o caso de inclusao, pois este campo ≤ alimentado somente no FT0912 */

               &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                   param-nf-estab.log-atualiza-sit-nf-eletro-batch = tg-log-atualiza-sit-nf-e-batch:CHECKED IN FRAME {&FRAME-NAME}
               &ELSE
                   param-nf-estab.log-livre-1 = tg-log-atualiza-sit-nf-e-batch:CHECKED IN FRAME {&FRAME-NAME}
               &ENDIF
               
               OVERLAY(param-nf-estab.cod-livre-1,232,10) = fi-versao-evt-epp         :SCREEN-VALUE IN FRAME {&FRAME-NAME} WHEN fi-versao-evt-epp         :SCREEN-VALUE IN FRAME {&FRAME-NAME} > ""
               OVERLAY(param-nf-estab.cod-livre-1,486,10) = fi-versao-evt-reg-saida   :SCREEN-VALUE IN FRAME {&FRAME-NAME} WHEN fi-versao-evt-reg-saida   :SCREEN-VALUE IN FRAME {&FRAME-NAME} > ""
               OVERLAY(param-nf-estab.cod-livre-1,596,5)  = fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} WHEN fi-versao-evt-comp-entrega:SCREEN-VALUE IN FRAME {&FRAME-NAME} > ""
               OVERLAY(param-nf-estab.cod-livre-1,601,5)  = fi-versao-evt-ator        :SCREEN-VALUE IN FRAME {&FRAME-NAME} WHEN fi-versao-evt-ator        :SCREEN-VALUE IN FRAME {&FRAME-NAME} > ""
               OVERLAY(param-nf-estab.cod-livre-1,484,1)  = IF tg-atualiza-data-hora-automatica:CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-1,485,1)  = IF tb-emite-reg-saida              :CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-4,386,1)  = IF l-tb-norma-abnt-5891            THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-4,387,1)  = IF l-tb-emissao-nfe-sem-email-dest THEN "S" ELSE "N"
               OVERLAY(param-nf-estab.cod-livre-4,388,1)  = IF tb-contr-excl-ibscbs            :CHECKED IN FRAME {&FRAME-NAME} THEN "S" ELSE "N".

        IF  fi-versao-cce:SENSITIVE IN FRAME {&FRAME-NAME} 
        AND fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "" THEN DO:

            ASSIGN &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
                       param-nf-estab.des-vers-carta-correc = fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   &ELSE 
                       OVERLAY(param-nf-estab.cod-livre-1,219,10)= fi-versao-cce:SCREEN-VALUE IN FRAME {&FRAME-NAME}
                   &ENDIF.
        END.
    END.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

   /*Dispatch standard ADM method.  */                           
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .
   
    IF  AVAIL estabelec THEN DO:

        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
        
            FIND reg-inf-compl
                 WHERE reg-inf-compl.cod-tab-inform = "estabelec"
                 AND   reg-inf-compl.cod-campo-inform = "cdn-regim-tribut" NO-LOCK NO-ERROR.

            IF  NOT AVAIL reg-inf-compl THEN DO:
                CREATE reg-inf-compl.
                ASSIGN reg-inf-compl.cdn-identif        = 3
                       reg-inf-compl.cod-tab-inform     = "estabelec"
                       reg-inf-compl.cod-campo-inform   = "cdn-regim-tribut" 
                       reg-inf-compl.des-campo-inform   = "C¢digo Regime Tribut†rio"
                       reg-inf-compl.idi-tipo           = 1 /* inteiro */
                       reg-inf-compl.num-decimal        = 0
                       reg-inf-compl.cod-format-campo   = ">>9". 
            END.
            
            ASSIGN INPUT FRAME {&FRAME-NAME} cbx-cdn-regim-tribut.
                        
            FIND inf-compl
            WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
              AND inf-compl.cod-indice = estabelec.cod-estabel EXCLUSIVE-LOCK NO-ERROR.
            
            IF AVAIL inf-compl THEN
                DELETE inf-compl.
                                
            CREATE inf-compl.
            ASSIGN inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                   inf-compl.cod-indice  = estabelec.cod-estabel.
                   inf-compl.num-campo = IF cbx-cdn-regim-tribut = "" THEN 0 ELSE {adinc/i06ad107.i 06 cbx-cdn-regim-tribut}.
        &ENDIF
   END.

  /* Code placed here will execute AFTER standard behavior.    */
    
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

  IF VALID-HANDLE(h-bodi520) THEN DO:
     DELETE PROCEDURE h-bodi520.
     ASSIGN h-bodi520 = ?.
  END.

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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */

    &if  defined(ADM-CREATE-FIELDS) &then
        disable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
    &endif

    &if  defined(ADM-MODIFY-FIELDS) &then
        disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    DISABLE rs-nfe
            tb-permite-conting
            tb-emite-cce
            tb-emite-reg-saida
            tb-utiliza-docto-tag
            tb-demonstrar-impostos-por-item
            tb-norma-abnt-5891
            tb-zera-cod-chave
            tb-emissao-nfe-sem-email-dest
            tb-contr-excl-ibscbs
            fi-versao-evt-reg-saida
            c-cdn-msg-contingen
            rs-transmissao
            fi-versao-layout
            rs-extensao-arq
            fi-versao-emissor
            bt-diretorio
            fi-local
            fi-prazo-cancelamento            
            c-fuso-horario 
        WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
    IF AVAIL estabelec THEN DO:
        ASSIGN rs-nfe                   = estabelec.idi-tip-emis-nf-eletro
               tb-permite-conting       = estabelec.log-emite-danfe
               tb-permite-event-prorrog = SUBSTRING(estabelec.char-1,380,1) = "S"
               tb-uf-inutiliza          = IF SUBSTRING(estabelec.char-2,281,1) = "S" THEN YES ELSE NO

               tb-emite-cce             = (&if "{&BF_DIS_VERSAO_EMS}" >= "2.09"
                                           &then estabelec.log-emite-carta-correc
                                           &else SUBSTR(estabelec.char-1,261,1) = "S" &endif)
                                       
               rs-transmissao           = (IF estabelec.idi-tip-transm > 0 THEN estabelec.idi-tip-transm ELSE 1)
                                           
               fi-versao-layout         = estabelec.des-vers-layout
               fi-versao-layout         = REPLACE(fi-versao-layout,".","")
               fi-versao-layout         = REPLACE(fi-versao-layout,",","")
               fi-versao-layout:FORMAT IN FRAME {&FRAME-NAME} = "9.99XXX"

               fi-local                 = estabelec.des-local-arq
               rs-extensao-arq          = IF INT(SUBSTRING(estabelec.char-1,381,1)) > 0 THEN INT(SUBSTRING(estabelec.char-1,381,1)) ELSE 1
                                           
               fi-versao-emissor        = (&if  "{&bf_dis_versao_ems}" >= "2.09"
                                           &then estabelec.des-vers-software-emissor
                                           &else TRIM(SUBSTRING(estabelec.char-1,251,10)) &endif)
               fi-versao-emissor        = REPLACE(fi-versao-emissor,".","")
               fi-versao-emissor        = REPLACE(fi-versao-emissor,",","")
               fi-prazo-cancelamento    = INT(SUBSTRING(estabelec.char-1,392,4))
               fi-site-danfe-simp-t2    = SUBSTRING(estabelec.char-1,401,150).
        
        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "estabelec"
                AND   reg-inf-compl.cod-campo-inform = "cdn-msg-contingen",
               
                FIRST inf-compl NO-LOCK
                WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                AND   inf-compl.cod-indice = estabelec.cod-estabel:
      
            END.
            /* c¢digo da mensagem de contingencia */
            ASSIGN c-cdn-msg-contingen = IF AVAIL inf-compl THEN inf-compl.num-campo ELSE 0.
            
            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "estabelec"
                AND   reg-inf-compl.cod-campo-inform = "cdn-regim-tribut",
        
                FIRST inf-compl NO-LOCK
                WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                AND   inf-compl.cod-indice  = estabelec.cod-estabel:
            END.
    
            FOR FIRST param-gener NO-LOCK 
                WHERE param-gener.cod-chave-1 = "param-comunic" 
                AND   param-gener.cod-chave-2 = estabelec.cod-estabel   
                AND   param-gener.cod-param   = "NF-e" :
                ASSIGN rs-transmissao = IF param-gener.cod-valor = "2":U THEN 2 ELSE 1.
           
            END.
            /* C¢digo Regime Tribut†rio */
            IF  AVAIL reg-inf-compl
            AND AVAIL inf-compl
            AND inf-compl.num-campo > 0 THEN
                ASSIGN cbx-cdn-regim-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {ADINC/I06AD107.I 04 inf-compl.num-campo}.
            ELSE
                ASSIGN cbx-cdn-regim-tribut:SCREEN-VALUE IN FRAME {&FRAME-NAME} = {ADINC/I06AD107.I 04 3}.
   
        &ENDIF 
    
        ASSIGN c-fuso-horario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(estabelec.char-1,262,6).

        /* Regras espec°ficas para transmiss∆o de documentos eletrìnicos */
        ASSIGN tb-utiliza-docto-tag = estabelec.log-utiliza-docto-tag.

        FOR FIRST funcao NO-LOCK
            WHERE funcao.cd-funcao = "spp-utiliza-docto-tag-" + estabelec.cod-estabel:
            ASSIGN tb-utiliza-docto-tag = funcao.ativo.
        END.
        IF NOT AVAIL funcao THEN
            ASSIGN tb-utiliza-docto-tag  = NO.

        /* Default marcado, ent∆o mesmo que o campo esteja vazio ser† considerado como marcado desde que esteja como produá∆o ou homologaá∆o */
        ASSIGN tb-zera-cod-chave = IF (   SUBSTRING(estabelec.char-1,399,1) = "" 
                                       AND rs-nfe <> 1 ) /* Nenhum */
                                   OR SUBSTRING(estabelec.char-1,399,1) = "S" THEN YES ELSE NO.

        ASSIGN tb-demonstrar-impostos-por-item = &IF "{&product_version}" >= "12.1.X.034" &THEN
                                                    IF estabelec.log-impto-consum = ? THEN
                                                        YES
                                                    ELSE
                                                        estabelec.log-impto-consum
                                                 &ELSE
                                                    IF SUBSTRING(estabelec.char-2,279,1) <> "" THEN
                                                        SUBSTRING(estabelec.char-2,279,1) = "1"
                                                    ELSE 
                                                        SUBSTRING(estabelec.char-2,257,1) = "" OR SUBSTRING(estabelec.char-2,257,1) = "1" OR SUBSTRING(estabelec.char-2,257,1) <> "2".                                                          
                                                 &ENDIF.
    END.  
   
    FIND FIRST param-nf-estab 
         WHERE param-nf-estab.cod-estabel = estabelec.cod-estabel NO-LOCK NO-ERROR.
   
    IF AVAIL param-nf-estab THEN DO:
        ASSIGN tg-log-atualiza-sit-nf-e-batch:CHECKED IN FRAME {&FRAME-NAME} = &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                                                                                   param-nf-estab.log-atualiza-sit-nf-eletro-batch
                                                                               &ELSE
                                                                                   param-nf-estab.log-livre-1
                                                                               &ENDIF
               tg-atualiza-data-hora-automatica:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-nf-estab.cod-livre-1,484,1) = "S" THEN YES ELSE NO
               tb-emite-reg-saida              :CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-nf-estab.cod-livre-1,485,1) = "S" THEN YES ELSE NO
               tb-norma-abnt-5891                                              = IF SUBSTRING(param-nf-estab.cod-livre-4,386,1) = "S" THEN YES ELSE NO
               tb-emissao-nfe-sem-email-dest                                   = IF SUBSTRING(param-nf-estab.cod-livre-4,387,1) = "S" THEN YES ELSE NO
               tb-contr-excl-ibscbs            :CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-nf-estab.cod-livre-4,388,1) = "S" THEN YES ELSE NO.

        &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
            ASSIGN fi-versao-cce          = param-nf-estab.des-vers-carta-correc.
        &ELSE 
            ASSIGN fi-versao-cce          = SUBSTRING(param-nf-estab.cod-livre-1,219,10).
        &ENDIF.
        
        ASSIGN fi-versao-evt-epp          = SUBSTRING(param-nf-estab.cod-livre-1,232,10)
               fi-versao-evt-reg-saida    = SUBSTRING(param-nf-estab.cod-livre-1,486,10)
               fi-versao-evt-comp-entrega = SUBSTRING(param-nf-estab.cod-livre-1,596,5)
               fi-versao-evt-ator         = SUBSTRING(param-nf-estab.cod-livre-1,601,5).
   
        ASSIGN fi-versao-cce              = REPLACE(fi-versao-cce,".","")
               fi-versao-cce              = REPLACE(fi-versao-cce,",","")
               fi-versao-evt-epp          = REPLACE(fi-versao-evt-epp,".","")
               fi-versao-evt-epp          = REPLACE(fi-versao-evt-epp,",","")
               fi-versao-evt-reg-saida    = REPLACE(fi-versao-evt-reg-saida,".","")
               fi-versao-evt-reg-saida    = REPLACE(fi-versao-evt-reg-saida,",","")
               fi-versao-evt-comp-entrega = REPLACE(fi-versao-evt-comp-entrega,".","")
               fi-versao-evt-comp-entrega = REPLACE(fi-versao-evt-comp-entrega,",","")
               fi-versao-evt-ator         = REPLACE(fi-versao-evt-ator,".","")
               fi-versao-evt-ator         = REPLACE(fi-versao-evt-ator,",","")

               fi-versao-cce             :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-cce              <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-epp         :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-epp          <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-reg-saida   :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-reg-saida    <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-comp-entrega:FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-comp-entrega <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-ator        :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-ator         <> "" THEN "9.99" ELSE "X".
    END.
    ELSE
        ASSIGN tg-log-atualiza-sit-nf-e-batch  :CHECKED IN FRAME {&FRAME-NAME} = NO
               tg-atualiza-data-hora-automatica:CHECKED IN FRAME {&FRAME-NAME} = NO
               tb-emite-reg-saida              :CHECKED IN FRAME {&FRAME-NAME} = NO
               tb-norma-abnt-5891                                              = NO
               tb-emissao-nfe-sem-email-dest                                   = NO
               tb-contr-excl-ibscbs            :CHECKED IN FRAME {&FRAME-NAME} = NO
               fi-versao-cce              = ""
               fi-versao-evt-epp          = ""
               fi-versao-evt-reg-saida    = ""
               fi-versao-evt-comp-entrega = ""
               fi-versao-evt-ator         = "".

    DISP rs-nfe
         tb-permite-conting
         tb-permite-event-prorrog
         tb-emite-cce
         tb-utiliza-docto-tag
         tb-demonstrar-impostos-por-item
         tb-zera-cod-chave
         tb-norma-abnt-5891
         tb-emissao-nfe-sem-email-dest
         tb-uf-inutiliza
         c-cdn-msg-contingen
         rs-transmissao
         fi-versao-layout
         fi-versao-cce
         fi-versao-evt-epp
         fi-versao-evt-reg-saida
         fi-versao-evt-comp-entrega
         fi-versao-evt-ator
         fi-local
         rs-extensao-arq
         fi-versao-emissor
         fi-prazo-cancelamento
         fi-site-danfe-simp-t2
         c-fuso-horario 
        WITH FRAME {&FRAME-NAME}.

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
    /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .*/
    
    /* Code placed here will execute AFTER standard behavior.    */

    &if  defined(ADM-MODIFY-FIELDS) &then
        /*if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    
    ENABLE rs-nfe 
           tb-permite-conting 
           tb-emite-cce 
           c-cdn-msg-contingen 
        WITH FRAME {&FRAME-NAME}.

    APPLY "VALUE-CHANGED":U TO rs-nfe          IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO rs-transmissao  IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO rs-extensao-arq IN FRAME {&FRAME-NAME}.

    ASSIGN cbx-cdn-regim-tribut      :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-cce             :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           tb-emite-cce              :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-epp         :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           tb-permite-event-prorrog  :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-reg-saida   :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           tb-emite-reg-saida        :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-reg-saida   :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-comp-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00")
           fi-versao-evt-ator        :SENSITIVE IN FRAME {&FRAME-NAME} = IF adm-new-record THEN NO ELSE (fi-versao-layout:SCREEN-VALUE IN FRAME {&FRAME-NAME} >= "2.00").

    IF adm-new-record THEN
        ASSIGN rs-nfe:SCREEN-VALUE IN FRAME {&FRAME-NAME} =  "1".

    IF rs-nfe:SCREEN-VALUE IN FRAME {&FRAME-NAME} > "1" THEN
        ASSIGN rs-transmissao            :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               fi-versao-cce             :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               fi-versao-layout          :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               fi-versao-evt-epp         :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               fi-versao-evt-reg-saida   :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               fi-versao-evt-comp-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = YES
               fi-versao-evt-ator        :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               tb-permite-event-prorrog  :SENSITIVE IN FRAME {&FRAME-NAME} = YES
               tb-emite-reg-saida        :SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    ELSE
        ASSIGN rs-transmissao            :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-versao-cce             :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-versao-layout          :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-versao-evt-epp         :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-versao-evt-reg-saida   :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-versao-evt-comp-entrega:SENSITIVE IN FRAME {&FRAME-NAME} = NO
               fi-versao-evt-ator        :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tb-permite-event-prorrog  :SENSITIVE IN FRAME {&FRAME-NAME} = NO
               tb-emite-reg-saida        :SENSITIVE IN FRAME {&FRAME-NAME} = NO.

    FOR FIRST param-gener NO-LOCK 
        WHERE param-gener.cod-chave-1 = "param-comunic" 
        AND   param-gener.cod-chave-2 = estabelec.cod-estabel   
        AND   param-gener.cod-param   = "NF-e" :

        DO WITH FRAME {&FRAME-NAME}:
            DISP rs-transmissao.
            DISABLE rs-transmissao.
        END.
    END.

    RUN cdp/cd0360b.p (INPUT  estabelec.cod-estabel,
                       INPUT  "NF-e",
                       OUTPUT cTpTrans).

    IF cTpTrans <> "TC2":U AND cTpTrans <> "TPF":U THEN
        DISABLE fi-versao-cce 
            WITH FRAME {&FRAME-NAME}.
    
    IF cTpTrans <> "TC2":U THEN
        DISABLE fi-versao-evt-epp 
               WITH FRAME {&FRAME-NAME}.
   
    IF cTpTrans = "TPF":U THEN 
        DISABLE fi-versao-evt-reg-saida
                fi-versao-evt-comp-entrega                
            WITH FRAME {&FRAME-NAME}.
    
    APPLY "VALUE-CHANGED":U TO tb-emite-cce             IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-permite-conting       IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-permite-event-prorrog IN FRAME {&FRAME-NAME}.
    APPLY "VALUE-CHANGED":U TO tb-emite-reg-saida       IN FRAME {&FRAME-NAME}.

    /* armazenar a ins-muncipal antes da alteraÁ„o */
    ASSIGN c-ins-municipal = estabelec.ins-municipal.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

    DEFINE VARIABLE cLista AS CHARACTER   NO-UNDO.

    ASSIGN cLista = "".
    ASSIGN cLista = {ADINC/I06AD107.I 03}.
    
    &if "{&FNC_MULTI_IDIOMA}" = "Yes":U &then
        RUN utp/ut-lstit.p (input-output cLista).
        ASSIGN cbx-cdn-regim-tribut:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = cLista.
    &else
        ASSIGN cbx-cdn-regim-tribut:LIST-ITEMS      IN FRAME {&FRAME-NAME} = cLista.
    &endif
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
   
    /* Code placed here will execute AFTER standard behavior.    */
    IF AVAIL estabelec THEN DO:
        ASSIGN rs-nfe                   = (IF estabelec.idi-tip-emis-nf-eletro    > 0 THEN estabelec.idi-tip-emis-nf-eletro    ELSE 1)
               tb-permite-conting       = estabelec.log-emite-danfe
               tb-emite-cce             = (&if "{&BF_DIS_VERSAO_EMS}" >= "2.09"
                                           &then estabelec.log-emite-carta-correcao
                                           &else SUBSTR(estabelec.char-1,261,1) = "S" &endif)
               tb-permite-event-prorrog = SUBSTRING(estabelec.char-1,380,1) = "S"
               rs-transmissao           = (IF estabelec.idi-tip-transm > 0 THEN estabelec.idi-tip-transm ELSE 1)
               fi-versao-evt-epp        = TRIM(SUBSTRING(estabelec.char-1,382,10))
               fi-versao-evt-epp        = REPLACE(fi-versao-evt-epp,".","")
               fi-versao-evt-epp        = REPLACE(fi-versao-evt-epp,",","")
               fi-versao-layout         = estabelec.des-vers-layout
               fi-versao-layout         = REPLACE(fi-versao-layout,".","")
               fi-versao-layout         = REPLACE(fi-versao-layout,",","")                      
               fi-local                 = estabelec.des-local-arq
               rs-extensao-arq          = (IF INT(SUBSTRING(estabelec.char-1,381,1)) > 0 THEN INT(SUBSTRING(estabelec.char-1,381,1)) ELSE 1)
               fi-versao-emissor        = (&if  "{&bf_dis_versao_ems}" >= "2.09"
                                           &then estabelec.des-vers-software-emissor
                                           &else TRIM(SUBSTRING(estabelec.char-1,251,10)) &endif)
               fi-versao-emissor        = REPLACE(fi-versao-emissor,".","")
               fi-versao-emissor        = REPLACE(fi-versao-emissor,",","").
                                                                     
        ASSIGN fi-versao-layout :FORMAT IN FRAME {&FRAME-NAME} = "9.99XXX"
               fi-versao-emissor:FORMAT IN FRAME {&FRAME-NAME} = "9.9X.9XX".
                                           
        &IF INTEGER(ENTRY(1,PROVERSION,".")) >= 10 &THEN
                  
            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "estabelec"
                  AND reg-inf-compl.cod-campo-inform = "cdn-msg-contingen",
                FIRST inf-compl NO-LOCK
                WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                  AND inf-compl.cod-indice  = estabelec.cod-estabel:
                          
                /* c¢digo da mensagem de contingencia */
                ASSIGN c-cdn-msg-contingen = inf-compl.num-campo.
            END.
                  
            FOR FIRST reg-inf-compl NO-LOCK
                WHERE reg-inf-compl.cod-tab-inform   = "estabelec"
                  AND reg-inf-compl.cod-campo-inform = "cdn-regim-tribut",
                FIRST inf-compl NO-LOCK
                WHERE inf-compl.cdn-identif = reg-inf-compl.cdn-identif
                  AND inf-compl.cod-indice  = estabelec.cod-estabel:
                    
                /* C¢digo Regime Tribut†rio */
                ASSIGN cbx-cdn-regim-tribut:SCREEN-VALUE IN FRAME {&frame-name} = {ADINC/I06AD107.I 04 inf-compl.num-campo}.
            END.
        &ENDIF
            
        ASSIGN c-fuso-horario:SCREEN-VALUE IN FRAME {&FRAME-NAME} = SUBSTRING(estabelec.char-1,262,6).

        /* Regras espec°ficas para transmiss∆o de documentos eletrìnicos */
        ASSIGN tb-utiliza-docto-tag = estabelec.log-utiliza-docto-tag.

        FOR FIRST funcao NO-LOCK
            WHERE funcao.cd-funcao = "spp-utiliza-docto-tag-" + estabelec.cod-estabel:
            ASSIGN tb-utiliza-docto-tag = funcao.ativo.
        END.
        IF NOT AVAIL funcao THEN
            ASSIGN tb-utiliza-docto-tag = NO.
                                                
        /* Default marcado, ent∆o mesmo que o campo esteja vazio ser† considerado como marcado desde que esteja como produá∆o ou homologaá∆o */
        ASSIGN tb-zera-cod-chave = IF (    SUBSTRING(estabelec.char-1,399,1) = "" 
                                       AND rs-nfe <> 1 ) /* Nenhum */
                                   OR SUBSTRING(estabelec.char-1,399,1) = "S" THEN YES ELSE NO.

        ASSIGN tb-demonstrar-impostos-por-item = &IF "{&product_version}" >= "12.1.X.034" &THEN
                                                    IF estabelec.log-impto-consum = ? THEN
                                                        YES
                                                    ELSE
                                                        estabelec.log-impto-consum
                                                 &ELSE
                                                    IF SUBSTRING(estabelec.char-2,279,1) <> "" THEN
                                                        SUBSTRING(estabelec.char-2,279,1) = "1"
                                                    ELSE 
                                                        SUBSTRING(estabelec.char-2,257,1) = "" OR SUBSTRING(estabelec.char-2,257,1) = "1" OR SUBSTRING(estabelec.char-2,257,1) <> "2".                                                          
                                                 &ENDIF.
    END.    
   
    FOR FIRST param-nf-estab 
        WHERE param-nf-estab.cod-estabel = estabelec.cod-estabel NO-LOCK:

        &IF '{&bf_dis_versao_ems}' >= '2.09':U &THEN
            ASSIGN fi-versao-cce = param-nf-estab.des-vers-carta-correc.
        &ELSE 
            ASSIGN fi-versao-cce = SUBSTRING(param-nf-estab.cod-livre-1,219,10).
        &ENDIF.
        
        ASSIGN fi-versao-evt-epp          = SUBSTRING(param-nf-estab.cod-livre-1,232,10)
               fi-versao-evt-reg-saida    = SUBSTRING(param-nf-estab.cod-livre-1,286,10)
               fi-versao-evt-comp-entrega = SUBSTRING(param-nf-estab.cod-livre-1,596,5)
               fi-versao-evt-ator         = SUBSTRING(param-nf-estab.cod-livre-1,601,5).
            
        ASSIGN fi-versao-cce              = REPLACE(fi-versao-cce,".","")
               fi-versao-cce              = REPLACE(fi-versao-cce,",","")
               fi-versao-evt-epp          = REPLACE(fi-versao-evt-epp,".","")
               fi-versao-evt-epp          = REPLACE(fi-versao-evt-epp,",","")
               fi-versao-evt-reg-saida    = REPLACE(fi-versao-evt-reg-saida,".","")
               fi-versao-evt-reg-saida    = REPLACE(fi-versao-evt-reg-saida,",","")
               fi-versao-evt-comp-entrega = REPLACE(fi-versao-evt-reg-saida,".","")
               fi-versao-evt-comp-entrega = REPLACE(fi-versao-evt-reg-saida,",","")
               fi-versao-evt-ator         = REPLACE(fi-versao-evt-ator,".","")
               fi-versao-evt-ator         = REPLACE(fi-versao-evt-ator,",","")

               fi-versao-evt-epp         :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-epp          <> "" THEN "9.99" ELSE "X"
               fi-versao-cce             :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-cce              <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-reg-saida   :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-reg-saida    <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-comp-entrega:FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-comp-entrega <> "" THEN "9.99" ELSE "X"
               fi-versao-evt-ator        :FORMAT IN FRAME {&FRAME-NAME} = IF fi-versao-evt-ator         <> "" THEN "9.99" ELSE "X".
        
        ASSIGN tg-log-atualiza-sit-nf-e-batch  :CHECKED IN FRAME {&FRAME-NAME} = &IF "{&bf_dis_versao_ems}":U >= "2.09":U &THEN
                                                                                     param-nf-estab.log-atualiza-sit-nf-eletro-batch
                                                                                 &ELSE
                                                                                     param-nf-estab.log-livre-1
                                                                                 &ENDIF
               tg-atualiza-data-hora-automatica:CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-nf-estab.cod-livre-1,484,1) = "S" THEN YES ELSE NO
               tb-emite-reg-saida              :CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-nf-estab.cod-livre-1,485,1) = "S" THEN YES ELSE NO
               tb-norma-abnt-5891                                              = IF SUBSTRING(param-nf-estab.cod-livre-4,386,1) = "S" THEN YES ELSE NO
               tb-emissao-nfe-sem-email-dest                                   = IF SUBSTRING(param-nf-estab.cod-livre-4,387,1) = "S" THEN YES ELSE NO
               tb-contr-excl-ibscbs            :CHECKED IN FRAME {&FRAME-NAME} = IF SUBSTRING(param-nf-estab.cod-livre-4,388,1) = "S" THEN YES ELSE NO.
    END.
                                 
    DISP rs-nfe
         tb-permite-conting
         tb-permite-event-prorrog
         tb-emite-cce
         tb-emite-reg-saida
         tb-utiliza-docto-tag
         tb-demonstrar-impostos-por-item
         tb-zera-cod-chave
         tb-norma-abnt-5891
         tb-emissao-nfe-sem-email-dest
         tb-contr-excl-ibscbs
         tb-uf-inutiliza
         c-cdn-msg-contingen
         rs-transmissao
         fi-versao-layout
         fi-versao-cce
         fi-versao-evt-epp
         fi-versao-evt-reg-saida
         fi-versao-evt-comp-entrega
         fi-versao-evt-ator
         fi-versao-emissor
         fi-prazo-cancelamento
         fi-site-danfe-simp-t2
         rs-extensao-arq
         fi-local WITH FRAME {&FRAME-NAME}.
   
    DISABLE rs-nfe
            tb-permite-conting
            tb-permite-event-prorrog
            tb-emite-cce
            tb-emite-reg-saida
            tb-utiliza-docto-tag
            tb-demonstrar-impostos-por-item
            tb-zera-cod-chave
            tb-norma-abnt-5891
            tb-emissao-nfe-sem-email-dest
            c-cdn-msg-contingen
            rs-transmissao
            fi-versao-layout
            fi-versao-emissor
            fi-versao-cce
            fi-versao-evt-epp
            fi-versao-evt-reg-saida
            fi-versao-evt-comp-entrega
            fi-versao-evt-ator
            rs-extensao-arq
            fi-local
            bt-diretorio
            tg-log-atualiza-sit-nf-e-batch
            tg-atualiza-data-hora-automatica
            fi-prazo-cancelamento
            c-fuso-horario
        WITH FRAME {&FRAME-NAME}.

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
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "estabelec"}

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

