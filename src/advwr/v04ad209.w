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
{include/i-prgvrs.i V04AD209 2.00.00.080 } /*** "010080" 29/09/2026 15:57:47 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04ad209 MUT}
&ENDIF

{cdp/cdcfgfin.i}

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:
      <none>

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
&Scop adm-attribute-dlg support/viewerd.w

/* Miniflexibilizaá∆o */
{include/i_dbvers.i}

/* Banking Connect */
{include/getdefinedfunction.i} /*** Verificar se a funcao especial estòŸ habilitada ***/ 
/*--------*/


/* Definiá∆o da temp-table tt-ext-portador */
&if "{&mgadm_version}" >= "2.02" &then 
    {cdp/cd0901f.i}
    def var l-enable as log.
&endif

def new global shared var v-row-parent as rowid no-undo.                                

/*--- N∆o tirar este c¢digo, usado Grendene ---*/
def new global shared var log-hab-estab as logical init ? no-undo.

def var c-formato-conta    as char   no-undo.
def var c-cd0901           as char   no-undo.
def var wh-cd0901          as handle no-undo.
def var l-cheque-ant       as log    no-undo.
def var c-desc             as char   no-undo.
def var l-replica          as log    no-undo.
def var i-cod-febraban     as int    no-undo.
def var i-cod-febraban-ant as int    no-undo.
def var c-bloqueto         as char init " "       no-undo.
def var c-text-1           as char format "x(15)" no-undo. 
def var c-text-2           as char format "x(15)" no-undo.
def buffer bf-portador     for portador.

/* Banking Connect */
DEF VAR l-banking-connect AS LOGICAL INITIAL NO NO-UNDO. /* Possui e est† apto a usar o Banking Connect */
DEF VAR h_v05ad209        AS HANDLE NO-UNDO.             /* Handle para o TOOGLE-BOX Integra Banking Connect de v01ad209.w */
DEF VAR v_hdl_reg_produt  AS HANDLE NO-UNDO.             /* Handle para o controle de registro - cd4210b.p */
DEF VAR l-registro-ok     AS LOGICAL INITIAL NO NO-UNDO. /* Variavel auxiliar para verificaá∆o do Registro */
DEF VAR d-limite          AS DATE NO-UNDO.               /* Data limite do registro */
DEF VAR c-empresa-banking AS CHAR NO-UNDO.               /* Empresa do registro encontrado */

/* Banking Connect - Verificaá∆o do Registro - Inicializando Handle */
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    IF NOT VALID-HANDLE(v_hdl_reg_produt)
            OR  v_hdl_reg_produt:TYPE       <> "procedure":U
            OR  v_hdl_reg_produt:FILE-NAME  <>  "cdp/cd4210b.p":U
           THEN run cdp/cd4210b.p PERSISTENT SET v_hdl_reg_produt.
&ENDIF
/*--------*/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES portador
&Scoped-define FIRST-EXTERNAL-TABLE portador


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR portador.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS portador.mo-codigo portador.cod-banco ~
cb-emite-bloq portador.agencia portador.conta-corren ~
portador.conta-contabil portador.gera-disponivel portador.pr-lib-tit ~
portador.considera-fluxo-ap portador.considera-fluxo-cr permite-atualizar-acr
&Scoped-define ENABLED-TABLES portador
&Scoped-define FIRST-ENABLED-TABLE portador
&Scoped-Define ENABLED-OBJECTS RECT-4 RECT-5 RECT-6 RECT-7 RECT-8 rt-mold3 
&Scoped-Define DISPLAYED-FIELDS portador.mo-codigo portador.bancario ~
portador.cod-banco cb-emite-bloq portador.agencia ~
portador.conta-corren portador.char-2 portador.conta-contabil ~
portador.gera-disponivel portador.pr-lib-tit portador.considera-fluxo-ap ~
portador.considera-fluxo-cr permite-atualizar-acr
&Scoped-define DISPLAYED-TABLES portador
&Scoped-define FIRST-DISPLAYED-TABLE portador
&Scoped-Define DISPLAYED-OBJECTS fi-desc-moeda c-nome-banco c-nome-estabel ~
c-nome-conta integra-banking-connect text-1 text-2 permite-atualizar-acr

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS portador.mo-codigo portador.char-2
&Scoped-define ADM-ASSIGN-FIELDS portador.char-2 portador.gera-disponivel permite-atualizar-acr
&Scoped-define ADM-MODIFY-FIELDS portador.char-2 portador.gera-disponivel permite-atualizar-acr

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
DEFINE BUTTON bt-bloqueto 
     LABEL "Bloqueto" 
     SIZE 15 BY 1.

DEFINE BUTTON bt-inform 
     LABEL "Outras Inform" 
     SIZE 15 BY 1.

DEFINE VARIABLE c-nome-banco AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 25 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-conta AS CHARACTER FORMAT "X(256)" 
     VIEW-AS FILL-IN 
     SIZE 26.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE fi-desc-moeda AS CHARACTER FORMAT "X(12)":U 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE text-1 AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS TEXT 
     SIZE 12.43 BY .63 NO-UNDO.

DEFINE VARIABLE text-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 9 BY .63 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 43.29 BY 1.42.

DEFINE RECTANGLE RECT-5
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 7.38.

DEFINE RECTANGLE RECT-6
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81 BY .08.

DEFINE RECTANGLE RECT-7
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86 BY 1.38.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 41.57 BY 1.42.

DEFINE RECTANGLE rt-mold3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 26.57 BY 1.63.

DEFINE VARIABLE integra-banking-connect AS LOGICAL INITIAL no 
     LABEL "Integra Banking Connect" 
     VIEW-AS TOGGLE-BOX
     SIZE 26 BY .83 NO-UNDO.

DEFINE VARIABLE permite-atualizar-acr AS LOGICAL INITIAL no 
     LABEL "Permite atualizaá∆o do t°tulo no ACR sem impress∆o do boleto" 
     VIEW-AS TOGGLE-BOX
     SIZE 45 BY .73 NO-UNDO.

DEFINE VARIABLE cb-emite-bloq AS CHARACTER FORMAT "X(30)":U
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "Item 1"
     DROP-DOWN-LIST
     SIZE 23.14 BY .92.

/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     portador.mo-codigo AT ROW 1.21 COL 22.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.43 BY .88
     fi-desc-moeda AT ROW 1.21 COL 26.14 COLON-ALIGNED NO-LABEL
     portador.bancario AT ROW 2.58 COL 24.72
          VIEW-AS TOGGLE-BOX
          SIZE 22.57 BY .79
     portador.cod-banco AT ROW 3.46 COL 22.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-nome-banco AT ROW 3.46 COL 27.72 COLON-ALIGNED HELP
          "Nome do Banco" NO-LABEL

     cb-emite-bloq AT ROW 3.88 COL 59 NO-LABEL

     portador.agencia AT ROW 4.46 COL 22.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     bt-bloqueto AT ROW 5.38 COL 69
     portador.conta-corren AT ROW 5.46 COL 22.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25.14 BY .88
     permite-atualizar-acr AT ROW 6.83 COL 24.72 HELP
          "Atualiza o t°tulo no ACR sem a impress∆o do boleto."
	 portador.char-2 AT ROW 7.73 COL 17.86
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-nome-estabel AT ROW 7.73 COL 27.72 COLON-ALIGNED NO-LABEL
     portador.conta-contabil AT ROW 7.83 COL 22.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     c-nome-conta AT ROW 7.83 COL 38.86 COLON-ALIGNED NO-LABEL
     bt-inform AT ROW 8.70 COL 69 HELP
          "Outras informaá‰es do portador"
     portador.gera-disponivel AT ROW 8.75 COL 24.72
          VIEW-AS TOGGLE-BOX
          SIZE 18.29 BY .79
     integra-banking-connect AT ROW 8.75 COL 43
     portador.pr-lib-tit AT ROW 10.33 COL 22.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.86 BY .88
     portador.considera-fluxo-ap AT ROW 10.5 COL 51.14
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .75
     portador.considera-fluxo-cr AT ROW 10.5 COL 70
          VIEW-AS TOGGLE-BOX
          SIZE 13 BY .75
     text-1 AT ROW 3.21 COL 57.14 NO-LABEL
     text-2 AT ROW 9.88 COL 45.14 NO-LABEL
     RECT-4 AT ROW 10.08 COL 43.72
     RECT-5 AT ROW 2.46 COL 1
     RECT-6 AT ROW 6.58 COL 3.43
     RECT-7 AT ROW 1 COL 1.14
     RECT-8 AT ROW 10.08 COL 1
     rt-mold3 AT ROW 3.46 COL 56.29
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.portador
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
         HEIGHT             = 10.63
         WIDTH              = 86.14.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX portador.bancario IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-bloqueto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR BUTTON bt-inform IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       bt-inform:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-nome-banco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-conta IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN portador.char-2 IN FRAME f-main
   NO-ENABLE ALIGN-L 1 2 3                                              */
/* SETTINGS FOR FILL-IN fi-desc-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX portador.gera-disponivel IN FRAME f-main
   2 3                                                                  */
/* SETTINGS FOR TOGGLE-BOX integra-banking-connect IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       integra-banking-connect:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN portador.mo-codigo IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN text-1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN text-2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
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

&Scoped-define SELF-NAME portador.agencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.agencia V-table-Win
ON F5 OF portador.agencia IN FRAME f-main /* Agància */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= adzoom/z01ad009.w
                     &campo=portador.agencia
                     &campozoom=agencia
                     &parametros= "run pi-seta-inicial in wh-pesquisa (input input frame {&frame-name} portador.cod-banco)."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.agencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF portador.agencia IN FRAME f-main /* Agància */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.bancario
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.bancario V-table-Win
ON VALUE-CHANGED OF portador.bancario IN FRAME f-main /* Portador Banc†rio */
DO:

    if  portador.bancario:checked in frame {&FRAME-NAME} = yes then do:
        assign portador.conta-contabil:sensitive     in frame {&FRAME-NAME} = no
               portador.cod-banco:sensitive          in frame {&FRAME-NAME} = yes
               portador.agencia:sensitive            in frame {&FRAME-NAME} = yes
               portador.conta-corren:sensitive       in frame {&FRAME-NAME} = yes
               portador.conta-contabil:screen-value  in frame {&FRAME-NAME} = "" 
               c-nome-conta:screen-value             in frame {&FRAME-NAME} = ""
               portador.gera-disponivel:checked      in frame {&FRAME-NAME} = no
               portador.gera-disponivel:sensitive    in frame {&FRAME-NAME} = no
             /* portador.gera-disponivel:visible      in frame {&FRAME-NAME} = yes */
               portador.char-2:sensitive             in frame {&FRAME-NAME} = no
               portador.char-2:SCREEN-VALUE          IN FRAME {&FRAME-NAME} = ""
               c-nome-estabel:SCREEN-VALUE           IN FRAME {&FRAME-NAME} = ""
               cb-emite-bloq:sensitive               in frame {&FRAME-NAME} = yes.   
        run get-attribute ('adm-new-record').
        if  return-value = "yes" then
            run notify in this-procedure ('pi-desabilita,link_2-target').
    end.
    else do:
        assign portador.conta-contabil:sensitive     in frame {&FRAME-NAME} = yes
               portador.cod-banco:sensitive          in frame {&FRAME-NAME} = no
               portador.agencia:sensitive            in frame {&FRAME-NAME} = no
               portador.conta-corren:sensitive       in frame {&FRAME-NAME} = no
               portador.cod-banco:screen-value       in frame {&FRAME-NAME} = string(0)
               c-nome-banco:screen-value             in frame {&FRAME-NAME} = ""
               portador.agencia:screen-value         in frame {&FRAME-NAME} = ""
               portador.conta-corren:screen-value    in frame {&FRAME-NAME} = ""
               portador.gera-disponivel:sensitive    in frame {&FRAME-NAME} = yes              
              /* portador.gera-disponivel:visible      in frame {&FRAME-NAME} = yes */
               portador.char-2:sensitive             in frame {&FRAME-NAME} = yes
               cb-emite-bloq:sensitive               in frame {&FRAME-NAME} = no
               bt-bloqueto:sensitive                 in frame {&FRAME-NAME} = no.
        run get-attribute ('adm-new-record').
        if  return-value = "yes" then do:
            run notify in this-procedure ('pi-habilita,link_2-target').
        end.
    end.

    /*--- N∆o tirar este c¢digo, usado Grendene ---*/
    if  log-hab-estab = yes then
        assign portador.char-2:sensitive in frame {&FRAME-NAME} = yes.
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
        assign portador.conta-contabil:sensitive     in frame {&FRAME-NAME} = NO.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-bloqueto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-bloqueto V-table-Win
ON CHOOSE OF bt-bloqueto IN FRAME f-main /* Bloqueto */
DO:

  assign i-cod-febraban-ant = i-cod-febraban.
  run get-field-screen-value in adm-broker-hdl (input this-procedure,
                                                input "cod-febraban").
  assign i-cod-febraban = int(return-value).
  if  i-cod-febraban = 0 then do:                           
      run utp/ut-msgs.p(input "show",
                        input 16889,
                        input string(i-cod-febraban)).
      apply 'entry' to bt-bloqueto in frame {&frame-name}.
      return "adm-error".
  end.

  if  i-cod-febraban <> i-cod-febraban-ant and
      i-cod-febraban-ant <> 0 then
      assign c-bloqueto = " ".

  case i-cod-febraban:
      when 001 then run cdp/cd0901b.w(input-output c-bloqueto,
                                      output       l-replica).
      when 033 then run cdp/cd0901b.w(input-output c-bloqueto,
                                      output       l-replica).
      when 231 then run cdp/cd0901ac.w(input-output c-bloqueto,
                                      output       l-replica).                                      
      when 237 then run cdp/cd0901d.w(input-output c-bloqueto,
                                      output       l-replica).
      when 275 or when 356 then run cdp/cd0901m.w(input-output c-bloqueto,
                                      output       l-replica).
      when 341 then run cdp/cd0901e.w(input-output c-bloqueto,
                                      output       l-replica).
      when 346 then run cdp/cd0901e.w(input-output c-bloqueto,
                                      output       l-replica).
      when 399 then run cdp/cd0901c.w(input-output c-bloqueto,
                                      output       l-replica).
      when 422 then run cdp/cd0901s.w(input-output c-bloqueto,
                                      output       l-replica).
      otherwise run utp/ut-msgs.p(input "show",
                                  input 16890,
                                  input string(i-cod-febraban)).
  end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inform
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inform V-table-Win
ON CHOOSE OF bt-inform IN FRAME f-main /* Outras Inform */
DO:
&if "{&mgadm_version}" >= "2.02" &then  
    if  avail portador then do:
        find tt-ext-portador 
             where tt-ext-portador.cod-portador = portador.cod-portador
             and   tt-ext-portador.modalidade   = portador.modalidade no-error.
        if  not avail tt-ext-portador then do:
            create tt-ext-portador.
            assign tt-ext-portador.cod-portador           = portador.cod-portador
                   tt-ext-portador.modalidade             = portador.modalidade
                   tt-ext-portador.cod-emitente           = portador.cod-emitente
                   tt-ext-portador.ad-cliente             = portador.ad-cliente
                   tt-ext-portador.dias-car-descto        = portador.dias-car-descto
                   tt-ext-portador.dias-car-atraso-cred   = portador.dias-car-atraso-cred
                   tt-ext-portador.dias-car-juros         = portador.dias-car-juros
                   tt-ext-portador.vl-min-ad-cli-juros    = portador.vl-min-ad-cli-juros
                   tt-ext-portador.vl-min-ad-cli-descto   = portador.vl-min-ad-cli-descto
                   tt-ext-portador.vl-min-ad-cli-abat     = portador.vl-min-ad-cli-abat
                   tt-ext-portador.vl-min-ad-cli-despcart = portador.vl-min-ad-cli-despcart
                   tt-ext-portador.vl-min-ad-bco-juros    = portador.vl-min-ad-bco-juros
                   tt-ext-portador.vl-min-ad-bco-descto   = portador.vl-min-ad-bco-descto
                   tt-ext-portador.vl-min-ad-bco-abat     = portador.vl-min-ad-bco-abat           
                   tt-ext-portador.vl-min-ad-bco-atraso   = portador.vl-min-ad-bco-atraso
                   tt-ext-portador.gera-movto-dif         = portador.gera-movto-dif.
        end.    
    end.    
    else do:
        create tt-ext-portador.
        assign tt-ext-portador.cod-portador           = 0
               tt-ext-portador.modalidade             = 1
               tt-ext-portador.cod-emitente           = 0
               tt-ext-portador.ad-cliente             = 1
               tt-ext-portador.dias-car-descto        = 0
               tt-ext-portador.dias-car-atraso-cred   = 0
               tt-ext-portador.dias-car-juros         = 0
               tt-ext-portador.vl-min-ad-cli-juros    = 0
               tt-ext-portador.vl-min-ad-cli-descto   = 0
               tt-ext-portador.vl-min-ad-cli-abat     = 0
               tt-ext-portador.vl-min-ad-cli-despcart = 0
               tt-ext-portador.vl-min-ad-bco-juros    = 0
               tt-ext-portador.vl-min-ad-bco-descto   = 0
               tt-ext-portador.vl-min-ad-bco-abat     = 0           
               tt-ext-portador.vl-min-ad-bco-atraso   = 0
               tt-ext-portador.gera-movto-dif         = no.
    end.
    assign l-enable = yes. 
    run cdp/cd0901f.w (input l-enable,
                       input-output table tt-ext-portador).

&endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.char-2
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.char-2 V-table-Win
ON F5 OF portador.char-2 IN FRAME f-main /* char-2 */
DO:
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                       &campo=portador.char-2
                       &campozoom=cod-estabel}    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.char-2 V-table-Win
ON LEAVE OF portador.char-2 IN FRAME f-main /* char-2 */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-nome-estabel
                   &where="estabelec.cod-estabel = input frame {&frame-name}
                   portador.char-2"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.char-2 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF portador.char-2 IN FRAME f-main /* char-2 */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.cod-banco
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.cod-banco V-table-Win
ON F5 OF portador.cod-banco IN FRAME f-main /* Banco */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom= adzoom/z01ad018.w
                  &tabela=portador
                  &atributo=cod-banco}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.cod-banco V-table-Win
ON LEAVE OF portador.cod-banco IN FRAME f-main /* Banco */
DO:
  {include/leave.i &tabela=banco
                   &atributo-ref=nome-banco
                   &variavel-ref=c-nome-banco
                   &where="banco.cod-banco = input frame {&frame-name}
                   portador.cod-banco"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.cod-banco V-table-Win
ON MOUSE-SELECT-DBLCLICK OF portador.cod-banco IN FRAME f-main /* Banco */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.conta-contabil
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.conta-contabil V-table-Win
ON ENTRY OF portador.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
      if avail param-global then 
      assign portador.conta-contabil:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil no-error.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.conta-contabil V-table-Win
ON F5 OF portador.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    assign l-implanta = yes.  
    {include/zoomvar.i &prog-zoom="adzoom/z01ad049.w"
                       &campo=portador.conta-contabil
                       &campozoom=conta-contabil}
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.conta-contabil V-table-Win
ON LEAVE OF portador.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
   &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
       assign c-formato-conta = input frame {&FRAME-NAME} portador.conta-contabil no-error.
       if avail param-global then 
       assign portador.conta-contabil:format in frame {&FRAME-NAME} = if error-status:get-number(1) <> 0 then "x(17)"
                                                                        else param-global.formato-conta-contabil.
    
       {include/leave.i &tabela=conta-contab
                        &atributo-ref=titulo
                        &variavel-ref=c-nome-conta
                        &where="conta-contab.ep-codigo = i-ep-codigo-usuario
                            AND conta-contab.conta-contabil = input frame {&frame-name} portador.conta-contabil"}
   &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.conta-contabil V-table-Win
ON MOUSE-SELECT-DBLCLICK OF portador.conta-contabil IN FRAME f-main /* Conta Cont†bil */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.conta-corren
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.conta-corren V-table-Win
ON F5 OF portador.conta-corren IN FRAME f-main /* Conta Corrente */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= adzoom/z01ad057.w
                     &campo=portador.cod-banco
                     &campozoom=cod-banco
                     &campo2=portador.agencia
                     &campozoom2=agencia
                     &campo3=portador.conta-corren
                     &campozoom3=conta-corren
                     &parametros= "run pi-seta-inicial in wh-pesquisa (input input frame {&frame-name} portador.cod-banco,
                                                                       input input frame {&frame-name} portador.agencia)."}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.conta-corren V-table-Win
ON MOUSE-SELECT-DBLCLICK OF portador.conta-corren IN FRAME f-main /* Conta Corrente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-emite-bloq V-table-Win
/* Evento para atualizacao do combo-box */
ON VALUE-CHANGED OF cb-emite-bloq IN FRAME f-main DO: /* Emit Bloq */

  ASSIGN bt-bloqueto:SENSITIVE IN FRAME f-main = cb-emite-bloq:screen-value in frame {&frame-name} = {adinc/i02ad209.i 04 1}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME integra-banking-connect
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL integra-banking-connect V-table-Win
ON VALUE-CHANGED OF integra-banking-connect IN FRAME f-main /* Integra Banking Connect */
DO:
  /*     RUN pi-banking-checked IN h_v05ad209(integra-banking-connect:checked in frame {&FRAME-NAME}). */
  /*     RUN pi-valida-banking-connect IN h_v05ad209.                                                  */
  IF  VALID-HANDLE(h_v05ad209) THEN
      RUN pi-retorna-banking-connect IN h_v05ad209(integra-banking-connect:checked in frame {&FRAME-NAME}).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.mo-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.mo-codigo V-table-Win
ON F5 OF portador.mo-codigo IN FRAME f-main /* Moeda */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= unzoom/z01un005.w
                     &campo=portador.mo-codigo
                     &campozoom=mo-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.mo-codigo V-table-Win
ON LEAVE OF portador.mo-codigo IN FRAME f-main /* Moeda */
DO:
  {include/leave.i &tabela=moeda
                   &atributo-ref=descricao
                   &variavel-ref=fi-desc-moeda
                   &where="moeda.mo-codigo=input frame {&FRAME-NAME} portador.mo-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.mo-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF portador.mo-codigo IN FRAME f-main /* Moeda */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
portador.mo-codigo:load-mouse-pointer      ("image~\lupa.cur") in frame {&frame-name}.        
portador.cod-banco:load-mouse-pointer      ("image~\lupa.cur") in frame {&frame-name}.
portador.agencia:load-mouse-pointer        ("image~\lupa.cur") in frame {&frame-name}.
portador.conta-corren:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name}.
portador.conta-contabil:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name}.
portador.char-2:load-mouse-pointer         ("image~\lupa.cur") in frame {&frame-name}.

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
  {src/adm/template/row-list.i "portador"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "portador"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  assign text-1:screen-value in frame {&frame-name} = c-text-1
         text-2:screen-value in frame {&frame-name} = c-text-2
         c-bloqueto = " "
         cb-emite-bloq:screen-value in frame {&frame-name} = {adinc/i02ad209.i 04 1}.

  /* Banking Connect */
  assign integra-banking-connect:sensitive in frame {&FRAME-NAME} = l-banking-connect
         integra-banking-connect:CHECKED in frame {&FRAME-NAME} = NO.

/*  if l-banking-connect then
     assign integra-banking-connect:checked in frame {&FRAME-NAME} = no.*/
  APPLY 'value-changed' TO integra-banking-connect.
  /*--------*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  assign portador.char-2:sensitive in frame {&frame-name} = NOT portador.bancario:checked in frame {&frame-name}.
  IF  NOT portador.char-2:sensitive in frame {&frame-name} THEN
      ASSIGN portador.char-2:SCREEN-VALUE in frame {&frame-name} = ""
             c-nome-estabel:SCREEN-VALUE  IN FRAME {&FRAME-NAME} = "".

  if  avail portador then
      assign c-bloqueto = portador.char-1.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
/* Banking Connect*/
DEFINE VARIABLE l-integra-banking-connect-tmp AS LOGICAL    NO-UNDO.
run pi-validate.

ASSIGN l-integra-banking-connect-tmp = integra-banking-connect:CHECKED IN FRAME {&FRAME-NAME}.
RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

&if "{&mgadm_version}" >= "2.04" &then 
   if l-banking-connect then
      assign portador.log-4 = l-integra-banking-connect-tmp.
&endif

/*--------*/

if RETURN-VALUE = 'ADM-ERROR':U then 
   return 'ADM-ERROR':U.


  assign l-cheque-ant = ?.
  assign fi-desc-moeda:screen-value in frame {&FRAME-NAME} = if avail moeda then moeda.descricao
                                                                else "".


  if  portador.modalidade = 6 or
      portador.modalidade = 8 or
      portador.modalidade = 9 then
      assign portador.bancario = no.
  else
      assign portador.bancario = yes.

  assign portador.char-1 = c-bloqueto.
  if l-replica = yes then do:
     run pi-replica-bloqueto.
  end.

  run pi-versao (input 4).

  assign overlay(portador.char-3,1,1) = if permite-atualizar-acr:checked in frame {&frame-name} then "S" else "N".
  
  ASSIGN input frame {&frame-name} cb-emite-bloq portador.emite-bloq = {adinc/i02ad209.i 06 cb-emite-bloq}.

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
  IF VALID-HANDLE(v_hdl_reg_produt) THEN
      DELETE PROCEDURE v_hdl_reg_produt.
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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

      run pi-versao (input 2).


  assign bt-bloqueto:sensitive in frame {&FRAME-NAME} = no.

  /* Banking Connect */
  if l-banking-connect then
      assign integra-banking-connect:sensitive in frame {&FRAME-NAME} = no.
  /*--------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  assign text-1:screen-value in frame {&frame-name} = c-text-1
         text-2:screen-value in frame {&frame-name} = c-text-2.

  if avail portador then do:

     run get-attribute('adm-new-record').
     if  return-value = 'no' then do:  

         if avail param-global and param-global.modulo-cb = yes then do:
            if  input frame {&FRAME-NAME} portador.bancario:checked = yes then do:
                find first movto-banco
                     where movto-banco.banco        = portador.cod-banco
                     and   movto-banco.agencia      = portador.agencia
                     and   movto-banco.cta-corrente = portador.conta-corren
                     no-lock no-error.
                if avail movto-banco then
                   assign portador.bancario:sensitive in frame {&FRAME-NAME} = no.               
            end.
            else do:
                 find first movto-banco
                      where movto-banco.ep-codigo  = portador.ep-codigo
                      and   movto-banco.cod-portador   = portador.cod-portador
                      and   movto-banco.modalidade = portador.modalidade
                      no-lock no-error.
                 if  avail movto-banco then
                     assign portador.bancario:sensitive in frame {&FRAME-NAME} = no.               
            end.
         end.                          

         if portador.bancario:checked in frame {&FRAME-NAME} = yes then
             assign portador.gera-disponivel:checked in frame {&FRAME-NAME} = no.
         else do:           
             /*
             assign portador.gera-disponivel:visible      in frame {&FRAME-NAME} = yes.
             */
             if  portador.gera-disponivel = yes then
                 assign portador.gera-disponivel:checked in frame {&FRAME-NAME} = yes.
             else
                 assign portador.gera-disponivel:checked in frame {&FRAME-NAME} = no.             
         end.
         
         if portador.emite-bloq >= 1 and portador.emite-bloq <= 3 then
             ASSIGN cb-emite-bloq:screen-value = {adinc/i02ad209.i 04 portador.emite-bloq}.
         else
             ASSIGN cb-emite-bloq:screen-value = {adinc/i02ad209.i 04 1}.
     end.    
     ELSE DO:
        if portador.emite-bloq = ? THEN
          ASSIGN cb-emite-bloq:screen-value = {adinc/i02ad209.i 04 1}.
     END.

     find first moeda where 
                moeda.mo-codigo = input frame {&FRAME-NAME} portador.mo-codigo no-lock no-error.
     assign fi-desc-moeda:screen-value in frame {&FRAME-NAME} = if avail moeda then moeda.descricao
                                                                else "".

     find first banco where 
                banco.cod-banco = input frame {&frame-name} portador.cod-banco no-lock no-error.
     assign c-nome-banco:screen-value in frame {&frame-name} = if avail banco then banco.nome-banco
                                                               else "".
   &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
     find first conta-contab where
                conta-contab.ep-codigo      = i-ep-codigo-usuario and
                conta-contab.conta-contabil = input frame {&frame-name} portador.conta-contabil no-lock no-error.
     assign c-nome-conta:screen-value in frame {&frame-name} = if avail conta-contab then conta-contab.titulo
                                                               else "".
   &ELSE
    assign portador.conta-contabil:SENSITIVE in frame {&FRAME-NAME} = NO
           portador.conta-contabil:VISIBLE   in frame {&FRAME-NAME} = NO
           c-nome-conta:SENSITIVE            in frame {&FRAME-NAME} = NO
           c-nome-conta:VISIBLE              in frame {&FRAME-NAME} = NO.
   &ENDIF

     find estabelec where estabelec.cod-estabel = portador.char-2 no-lock no-error.
     assign c-nome-estabel:screen-value in frame {&frame-name} = if avail estabelec then estabelec.nome
                                                                 else "".
    /* Banking Connect */
   &if "{&mgadm_version}" >= "2.04" &then 
       if l-banking-connect then
          assign integra-banking-connect:checked   in frame {&FRAME-NAME} = portador.log-4.

       IF valid-handle(h_v05ad209) THEN
            RUN pi-retorna-banking-connect IN h_v05ad209(integra-banking-connect:checked in frame {&FRAME-NAME}).
   &endif
    /*--------*/

  end.
  
  assign permite-atualizar-acr:checked in frame {&frame-name} = avail portador and TRIM(substr(portador.char-3,1,1)) = "S":U.

/*  apply 'value-changed' to portador.emite-bloq in frame {&frame-name}.*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  run pi-versao(input 3).

  run get-attribute ('adm-new-record').

  run get-field-screen-value in adm-broker-hdl (input this-procedure,
                                                input "cod-febraban").

  assign i-cod-febraban-ant = 0
         i-cod-febraban     = int(return-value).

  if  avail portador then DO:
      assign portador.mo-codigo:sensitive in frame {&frame-name} = if return-value = 'no' then no
                                                                   else yes.
    
      if  portador.bancario:checked in frame {&FRAME-NAME} = yes then do:
          assign portador.conta-contabil:sensitive     in frame {&FRAME-NAME} = no
                 portador.cod-banco:sensitive          in frame {&FRAME-NAME} = yes
                 portador.agencia:sensitive            in frame {&FRAME-NAME} = yes
                 portador.conta-corren:sensitive       in frame {&FRAME-NAME} = yes
                 cb-emite-bloq:sensitive               in frame {&FRAME-NAME} = yes
                 bt-bloqueto:sensitive                 in frame {&FRAME-NAME} = yes
                 portador.conta-contabil:screen-value  in frame {&FRAME-NAME} = "" 
                 c-nome-conta:screen-value             in frame {&FRAME-NAME} = ""
                 portador.gera-disponivel:checked      in frame {&FRAME-NAME} = no
                 portador.gera-disponivel:sensitive    in frame {&FRAME-NAME} = no
              /* portador.gera-disponivel:visible      in frame {&FRAME-NAME} = no */
                 portador.char-2:sensitive             in frame {&FRAME-NAME} = no.    
         end.
      else do:
           assign portador.conta-contabil:sensitive     in frame {&FRAME-NAME} = yes
                 portador.cod-banco:sensitive          in frame {&FRAME-NAME} = no
                 portador.agencia:sensitive            in frame {&FRAME-NAME} = no
                 portador.conta-corren:sensitive       in frame {&FRAME-NAME} = no
                 cb-emite-bloq:sensitive               in frame {&FRAME-NAME} = no
                 bt-bloqueto:sensitive                 in frame {&FRAME-NAME} = no
                 portador.cod-banco:screen-value       in frame {&FRAME-NAME} = string(0)
                 c-nome-banco:screen-value             in frame {&FRAME-NAME} = ""
                 portador.agencia:screen-value         in frame {&FRAME-NAME} = ""
                 portador.conta-corren:screen-value    in frame {&FRAME-NAME} = ""
                 portador.gera-disponivel:sensitive    in frame {&FRAME-NAME} = yes
               /* portador.gera-disponivel:visible      in frame {&FRAME-NAME} = yes */
                 portador.char-2:sensitive             in frame {&FRAME-NAME} = yes
                 bt-bloqueto:sensitive                 in frame {&frame-name} = no.
      end.
    
      APPLY "VALUE-CHANGED":U TO cb-emite-bloq IN FRAME {&FRAME-NAME}.
      
      assign c-bloqueto = portador.char-1.

      /*--- N∆o tirar este c¢digo, usado Grendene ---*/
      if  log-hab-estab = yes then
          assign portador.char-2:sensitive in frame {&FRAME-NAME} = yes.

      /* Banking Connect - Inicializa campos. O Campo integra-banking-connect s¢ ser† abilitado se a modalidade for diferente de 7 e o client epossuir o banking connect */
      if portador.modalidade <> 7 then
         assign integra-banking-connect:sensitive in frame {&FRAME-NAME} = l-banking-connect.
      /*--------*/
  END.

  &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) &THEN
      assign portador.conta-contabil:sensitive     in frame {&FRAME-NAME} = NO.
  &ENDIF
  
  assign permite-atualizar-acr:checked in frame {&frame-name} = avail portador and substr(portador.char-3,1,1) = "S":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-exit V-table-Win 
PROCEDURE local-exit :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  IF VALID-HANDLE(v_hdl_reg_produt) THEN
      DELETE PROCEDURE v_hdl_reg_produt.
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'exit':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
    Purpose:     Override standard ADM method
    Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-liter.i Emite_Bloqueto MCR R}
    assign c-text-1 = return-value.
    {utp/ut-liter.i Considera MCR R}
    assign c-text-2 = return-value.

    find first param-global no-lock no-error.
    find first param-cr where param-cr.ep-codigo = i-ep-codigo-usuario no-lock no-error.

    /* banking Connect */
    /* Verifica se o usu†ri otem persmiss∆o para usar o Banking Connect */
    &if "{&mgadm_version}" >= "2.04" &then
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
            /* Procura o registro */
            run find_registro in v_hdl_reg_produt (OUTPUT l-registro-ok, OUTPUT c-empresa-banking).
    
            /* Se encontrar verifica a data limite */
            IF l-registro-ok then do:
                RUN retorna_data_limite IN v_hdl_reg_produt (OUTPUT d-limite).
    
                /* Se a data Limite Ç valida */
                assign l-banking-connect = (d-limite <> ? AND TODAY <= d-limite).
    
                /* Mensagem 30 dias antes do prazo do termino da licenáa */
                IF ((d-limite - 30) <= TODAY) and (today <= d-limite) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31436,
                                       input STRING(d-limite - TODAY)).
                end.
    
                /* Mensagem de vencimento do Banking */
                if (today > d-limite) then do:
                    run utp/ut-msgs.p (input "show",
                                       input 31456,
                                       input STRING(d-limite - TODAY)).
                end.
            end.
        &ELSE
            assign  l-banking-connect = no.
        &ENDIF
    &else
         assign  l-banking-connect = no.
    &endif.
    /*----------*/
    /* Exibe as opcoes */
    ASSIGN cb-emite-bloq:LIST-ITEMS in frame {&frame-name} = {adinc/i02ad209.i 03}.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

    run pi-versao(input 1).

    assign text-1:screen-value in frame {&frame-name} = c-text-1.
           text-2:screen-value in frame {&frame-name} = c-text-2.

    /* Banking Connect - Inicializa campos */
    if l-banking-connect then
       assign integra-banking-connect:visible in frame {&FRAME-NAME} = yes
              integra-banking-connect:sensitive in frame {&FRAME-NAME} = no.
    else
        assign integra-banking-connect:visible in frame {&FRAME-NAME} = no
               integra-banking-connect:sensitive in frame {&FRAME-NAME} = no.
    /*--------*/
    &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
        if avail param-global then 
           assign portador.conta-contabil:format in frame {&frame-name} = param-global.formato-conta-contabil.
    &ELSE
		assign portador.conta-contabil:SENSITIVE in frame {&FRAME-NAME} = NO
			   portador.conta-contabil:VISIBLE   in frame {&FRAME-NAME} = NO
			   c-nome-conta:SENSITIVE            in frame {&FRAME-NAME} = NO
			   c-nome-conta:VISIBLE              in frame {&FRAME-NAME} = NO.
    &ENDIF

    &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
        find funcao 
            where funcao.cd-funcao = "spp-ems2fin-x-mg"
              and funcao.ativo     = yes no-lock no-error.
        if  avail funcao then do:
            assign portador.agencia:format      in frame {&frame-name} = "999999-X"
                   portador.conta-corren:format in frame {&frame-name} = "999999999-XX".
        end.
    &ENDIF.

    {utp/ut-field.i mgadm estabelec cod-estabel 1}
    assign portador.char-2:label in frame {&frame-name} = return-value.
    
    assign bt-bloqueto:sensitive in frame {&FRAME-NAME} = no.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-emite-bloq V-table-Win 
PROCEDURE pi-busca-emite-bloq :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param p-emite-bloq as int no-undo.

  ASSIGN input frame {&frame-name} cb-emite-bloq p-emite-bloq = {adinc/i02ad209.i 06 cb-emite-bloq}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-portador-bancario V-table-Win 
PROCEDURE pi-portador-bancario :
/*------------------------------------------------------------------------------
     Purpose:     
     Parameters:  <none>
     Notes:       
------------------------------------------------------------------------------*/

     def input param p-modalidade as integer no-undo.

     run Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-cd0901).                   
     assign wh-cd0901 = widget-handle(c-cd0901).
     run select-page in wh-cd0901 (1).

     /* Banking Connect */
     if l-banking-connect then do:
         if  p-modalidade = 7 then do:
             assign integra-banking-connect:sensitive in frame {&FRAME-NAME} = no.
             assign integra-banking-connect:checked   in frame {&FRAME-NAME} = no.
         end.
         else
             assign integra-banking-connect:sensitive in frame {&FRAME-NAME} = yes.
     end.
     /*--------*/

     if  p-modalidade = 8 then 
         assign portador.gera-disponivel:sensitive in frame {&FRAME-NAME} = yes
            /*  portador.gera-disponivel:visible   in frame {&FRAME-NAME} = yes */
                portador.bancario:checked          in frame {&FRAME-NAME} = no
                portador.bancario:sensitive        in frame {&FRAME-NAME} = no.
     else do:
         if  p-modalidade = 6 then do:
             assign portador.gera-disponivel:sensitive in frame {&FRAME-NAME} = yes
                 /* portador.gera-disponivel:visible   in frame {&FRAME-NAME} = yes */
                    portador.bancario:checked          in frame {&FRAME-NAME} = no
                    portador.bancario:sensitive        in frame {&FRAME-NAME} = no.
         end.           
         else 
             assign portador.gera-disponivel:sensitive in frame {&FRAME-NAME} = no
                    portador.gera-disponivel:checked   in frame {&FRAME-NAME} = no                      
                  /*  portador.gera-disponivel:visible   in frame {&FRAME-NAME} = no */
                    portador.bancario:checked        in frame {&FRAME-NAME} = yes
                    portador.bancario:sensitive      in frame {&FRAME-NAME} = no.
     end.

     if p-modalidade = 9 then 
        assign portador.bancario:sensitive in frame {&FRAME-NAME} = no
               portador.bancario:checked in frame {&FRAME-NAME} = no.

     apply 'value-changed':U to portador.bancario in frame {&FRAME-NAME}. 

     IF valid-handle(h_v05ad209) THEN
          RUN pi-retorna-banking-connect IN h_v05ad209(integra-banking-connect:checked in frame {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p_v05ad209 as handle.

assign h_v05ad209 = p_v05ad209.
    
IF valid-handle(h_v05ad209) THEN
    RUN pi-retorna-banking-connect IN h_v05ad209(integra-banking-connect:checked in frame {&FRAME-NAME}).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-replica-bloqueto V-table-Win 
PROCEDURE pi-replica-bloqueto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  
for each  bf-portador 
    where bf-portador.cod-febraban = i-cod-febraban
    and   bf-portador.emite-bloq   = 1 exclusive-lock:
      assign bf-portador.char-1 = c-bloqueto. 
end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
    Purpose:Validar a viewer     
    Parameters:  <none>
    Notes: N∆o fazer assign aqui. Nesta procedure
    devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
    ainda n∆o foi criado.       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i}

    run Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-cd0901).                   
    assign wh-cd0901 = widget-handle(c-cd0901).

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "cod-portador"). 

    find first moeda where 
          moeda.mo-codigo = input frame {&FRAME-NAME} portador.mo-codigo no-lock no-error.
     if not avail moeda then do:
            run utp/ut-msgs.p (input "show",
                               input 151,
                               input string(input frame {&FRAME-NAME} portador.mo-codigo)).
            run select-page in wh-cd0901 (1).
            apply 'entry' to portador.mo-codigo.
            return 'adm-error'.      
     end.


     RUN get-attribute ('adm-new-record':U). 
     if  return-value = "no":U 
     AND PROGRAM-NAME(2) MATCHES "*v01ad209.w" then do:  

            IF input frame {&frame-name} portador.cod-banco    <> portador.cod-banco      
            OR input frame {&frame-name} portador.agencia      <> portador.agencia    
            OR input frame {&frame-name} portador.conta-corren <> portador.conta-corren THEN DO:                
                 run utp/ut-msgs.p (input "show":U, 
                                    input 28453,
                                    input "").
                 IF RETURN-VALUE = "no" THEN 
                    RETURN 'adm-error':U. 

            END.
     end.  


     /*--- N∆o tirar este c¢digo, colocado para atender a Grendene ---*/
     if input frame {&frame-name} portador.char-2 <> "" then do:
        find estabelec 
             where estabelec.cod-estabel = input frame {&frame-name} portador.char-2
             no-lock no-error.
        if  not avail estabelec then do:
            run utp/ut-msgs.p (input "show",
                               input 13,
                               input frame {&frame-name} portador.char-2).
            run select-page in wh-cd0901 (1).
            apply 'entry' to portador.char-2.
            return 'adm-error'.
        end.
      end.

        if  input frame {&FRAME-NAME} portador.bancario = no then do:

        if  input frame {&frame-name} portador.char-2 = " " then do:
            {utp/ut-liter.i Estabelecimento * R}
            assign c-desc = return-value.
            run utp/ut-msgs.p (input "show",
                               input 54,
                               input c-desc).
            run select-page in wh-cd0901 (1).
            apply 'entry' to portador.char-2.
            return 'adm-error'.
        end.
        else do:
            find estabelec 
                 where estabelec.cod-estabel = input frame {&frame-name} portador.char-2
                 no-lock no-error.
            if  not avail estabelec then do:
                run utp/ut-msgs.p (input "show",
                                   input 13,
                                   input frame {&frame-name} portador.char-2).
                run select-page in wh-cd0901 (1).
                apply 'entry' to portador.char-2.
                return 'adm-error'.
            end.
        end.
        &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
            assign portador.conta-contabil:format in frame {&FRAME-NAME} = "x(17)".

            if input frame {&FRAME-NAME} portador.conta-contabil = "" then do:
               {utp/ut-table.i mgadm conta-contab 1}
               run utp/ut-msgs.p (input "show",
                                  input 164,
                                  input return-value).
               run select-page in wh-cd0901 (1).
               apply 'entry' to portador.conta-contab.
               return 'adm-error'.
            end.
    
    
            find first conta-contab
                 where conta-contab.ep-codigo      = i-ep-codigo-usuario       
                 and   conta-contab.conta-contabil = input frame {&FRAME-NAME} portador.conta-contabil 
                 no-lock no-error.
    
            if  not avail conta-contab then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 1060,
                                   input "").
                run select-page in wh-cd0901 (1).
                apply 'entry' to portador.conta-contab.
                return 'adm-error'.
            end.
    
            if conta-contab.tipo = 6 then do:
               run utp/ut-msgs.p (input "show",
                                  input 911,
                                  input "").
               run select-page in wh-cd0901 (1).
               apply 'entry' to portador.conta-contab.
               return 'adm-error'.
            end.
    
            if  conta-contab.estado <> 3 then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show",
                                   input 638,
                                   input conta-contab.conta-contabil).
                run select-page in wh-cd0901 (1).
                apply 'entry' to portador.conta-contab.
                return 'adm-error'.
            end.
    
            if  conta-contab.caixa-bancos = 1 then do:
                run utp/ut-msgs.p (input "show",
                                   input 7037,
                                   input "").
                run select-page in wh-cd0901 (1).
                apply 'entry' to portador.conta-contab.
                return 'adm-error':U.
            end.
    
            if  conta-contab.caixa-bancos <> 3 then do:
                 run utp/ut-msgs.p (input "show",
                                   input 16722,
                                   input " ").
                 run select-page in wh-cd0901 (1).
                 apply 'entry' to portador.conta-contab.
                 return 'adm-error'.
            end.
          if avail param-global then 
             assign portador.conta-contabil:format in frame {&FRAME-NAME} = param-global.formato-conta-contabil no-error.  
        &ENDIF
        end.
        else do:
            find banco where 
                 banco.cod-banco = input frame {&frame-name} portador.cod-banco no-lock no-error.
    
            if  not avail banco then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U, 
                                   input 230,
                                   input "").
                run select-page in wh-cd0901 (1).
                apply "entry" to portador.cod-banco.
                return 'adm-error':U.
            end.
    
            find agencia 
                 where agencia.cod-banco = input frame {&frame-name} portador.cod-banco 
                 and agencia.agencia     = input frame {&frame-name} portador.agencia
                 no-lock no-error.
    
            if  not avail agencia then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U, 
                                   input 41,
                                   input "").
                run select-page in wh-cd0901 (1).
                APPLY "entry" to portador.agencia.
                return 'adm-error':U.
           end.
    
            find first cta-corrente 
                 where cta-corrente.ep-codigo    = i-ep-codigo-usuario 
                 and   cta-corrente.cod-banco    = input frame {&frame-name} portador.cod-banco 
                 and   cta-corrente.agencia      = input frame {&frame-name} portador.agencia 
                 and   cta-corrente.conta-corren = input frame {&frame-name} portador.conta-corren
                 no-lock no-error.
    
            if  not avail cta-corrente then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show":U,
                                   input 27853,
                                   input "").
                run select-page in wh-cd0901 (1).
                apply "entry" to portador.conta-corren.
                return 'adm-error':U.
            end.
        end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-versao V-table-Win 
PROCEDURE pi-versao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
/* Miniflexibilizaá∆o */
    def input param p-ind as int no-undo.

    &if "{&mgadm_version}" >= "2.02" &then 
          vers_block:
          do:
              &if "{&mgadm_version}" = "2.02" &then
                  find first histor_exec_especial no-lock
                       where histor_exec_especial.cod_modul_dtsul = 'CRP'
                      and   histor_exec_especial.cod_prog_dtsul  = 'EMS_202_GERA_AD_BANCO' no-error.
                  if  not avail histor_exec_especial then
                      leave vers_block.  
              &endif

              case p-ind:
                  when 1 then  /* initialize */
                      assign bt-inform:visible           in frame {&FRAME-NAME} = yes 
                             bt-inform:sensitive         in frame {&FRAME-NAME} = no
                             bt-inform:hidden            in frame {&FRAME-NAME} = no.
                  when 2 then do: /* disable */
                      assign bt-inform:sensitive         in frame {&FRAME-NAME} = no.
                      for each tt-ext-portador no-lock:
                          delete tt-ext-portador.
                      end.
                  end.    
                  when 3 then do: /* enable */
                      assign bt-inform:sensitive         in frame {&FRAME-NAME} = yes.
                      if avail param-cr and param-cr.gera-movto = 1 then 
                         disable bt-inform with frame {&FRAME-NAME}.
                  end.    
                  when 4 then do: /* assign-records */
                      find first tt-ext-portador no-lock no-error.
                      if  avail tt-ext-portador then do:
                          assign portador.cod-emitente           = tt-ext-portador.cod-emitente
                                 portador.ad-cliente             = tt-ext-portador.ad-cliente
                                 portador.dias-car-descto        = tt-ext-portador.dias-car-descto
                                 portador.dias-car-atraso-cred   = tt-ext-portador.dias-car-atraso-cred
                                 portador.dias-car-juros         = tt-ext-portador.dias-car-juros
                                 portador.vl-min-ad-cli-juros    = tt-ext-portador.vl-min-ad-cli-juros
                                 portador.vl-min-ad-cli-descto   = tt-ext-portador.vl-min-ad-cli-descto
                                 portador.vl-min-ad-cli-abat     = tt-ext-portador.vl-min-ad-cli-abat
                                 portador.vl-min-ad-cli-despcart = tt-ext-portador.vl-min-ad-cli-despcart
                                 portador.vl-min-ad-bco-juros    = tt-ext-portador.vl-min-ad-bco-juros
                                 portador.vl-min-ad-bco-descto   = tt-ext-portador.vl-min-ad-bco-descto
                                 portador.vl-min-ad-bco-abat     = tt-ext-portador.vl-min-ad-bco-abat           
                                 portador.vl-min-ad-bco-atraso   = tt-ext-portador.vl-min-ad-bco-atraso
                                 portador.gera-movto-dif         = tt-ext-portador.gera-movto-dif.
                      end.           
                  end.    
              end case.     
         end.
    &endif.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE replica_bloqueto V-table-Win 
PROCEDURE replica_bloqueto :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  {src/adm/template/snd-list.i "portador"}

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

