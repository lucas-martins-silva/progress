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
{include/i-prgvrs.i V05AD209 2.00.01.029 } /*** "010129" 03/02/2026 14:49:33  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05ad209 MUT}
&ENDIF

/********************************************************************************
** Copyright DATASUL S. (1997)
** Todos os Direitos Reservados.
**
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/

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

/* Banking Connect */
{cdp/cdcfgfin.i}
{include/i_dbvers.i}
{include/getdefinedfunction.i} /*** Verificar se a funcao especial est˜Ù habilitada ***/ 
/*--------*/
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
define buffer b-portador for portador.

def var p-portad             as int                no-undo.
def var p-nome               as char               no-undo.
def var p-modal              as char               no-undo.
def var c-legenda            as char               no-undo.
def var c-nr-prog-oper       as char               no-undo.
def var c-port-head          as char               no-undo.
def var c-port-interv        as char               no-undo.
def var c-nr-contrato        as char               no-undo. 
def var c-contrato           as char               no-undo.
def var l-adm-attribute      as logical            no-undo.
def var l-alterou-carteira   as logical init no    no-undo.
def var port-row             as rowid.    
def var c-cd0901             as char               no-undo.
def var wh-cd0901            as handle             no-undo.
def var i-cod-banco          as int                no-undo.
def var i-prox-remessa       as int                no-undo.
def var i-cont               as int                no-undo.
def var i-num-itens          as int     init 1     no-undo.
def var i-cod-febraban-ant   as int     init 0     no-undo.
def var i-cod-febraban-aux   as int     init 0     no-undo.
def var c-esp-cob-ant        as char               no-undo.
def var l-mesmo-febraban     as logical init no    no-undo.
def var c-cod-carteira-ant   as char               no-undo.
def var i-emite-bloq         as integer            no-undo.
def var i-emite-bloq-ant     as integer            no-undo. 
def var c-agencia            as char               no-undo.
def var c-univendor          as char               no-undo.
def var c-cod-esp            as char               no-undo.
def var h_v08ad209           as handle             no-undo.
def var h_v01ad209           as handle             no-undo.
def var h_v04ad209           as handle             no-undo.
def var h_v10ad209           as handle             no-undo.
def var c-complemento        like portador.complemento.
def var p-row-port           as rowid              no-undo.
def var i-modalidade         as int                no-undo.
def var l-enable             as log                no-undo.
def var l-vendor             as log                no-undo.
def var c-esp-cob            as char               no-undo.
def var h-handle             as handle             no-undo.
def var c-handle             as char               no-undo.
def var c-port-head-aux      as char               no-undo.
def var c-port-interv-aux    as char               no-undo.
def var c-nr-contrato-aux    as char               no-undo. 
def var c-contrato-aux       as char               no-undo.
def var c-legenda-aux        as char               no-undo.
def var c-nr-prog-oper-aux   as char               no-undo.
DEF VAR i-operacao           AS int     init 1     no-undo.
def var i-layout-bb          as int     init 1     no-undo. 
def var cLista1              as char               no-undo.
def var cLista2              as char               no-undo.
def var cfebraban            like portador.cod-febraban.
/* Banking Connect */
def var l-banking-connect    as logical initial no no-undo. /* Checa se o o usu rio possui o Banking Connect */
def var c-carteira-banking   as character          no-undo. /* Guarda a lista de Carteiras utilizadas pelo Banking Connect */
def var c-especie-banking    as character          no-undo. /* Guarda a lista de Especies utilizadas pelo Banking Connect  */
def var l-banking-checked    as logical initial no no-undo. /* Verifica na viewer v04ad209.w se o campo Integra Banking Connect foi checado */
def var l-initialize-banking as logical initial no no-undo. /* Checa se a ‚ a primeira vez que a tela foi inicializada     */
DEF VAR v_hdl_reg_produt     AS HANDLE             NO-UNDO. /* Handle para o controle de registro - cd4210b.p */
DEF VAR l-registro-ok        AS LOGICAL INITIAL NO NO-UNDO. /* Variavel auxiliar para verifica‡Æo do Registro */
DEF VAR d-limite             AS DATE               NO-UNDO. /* Data limite do registro */
DEF VAR c-empresa-banking    AS CHAR               NO-UNDO. /* Empresa do registro encontrado */

/* Banking Connect - Verifica‡Æo do Registro - Inicializando Handle */
&IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
    IF NOT VALID-HANDLE(v_hdl_reg_produt)
            OR  v_hdl_reg_produt:TYPE       <> "procedure":U
            OR  v_hdl_reg_produt:FILE-NAME  <>  "cdp/cd4210b.p":U
           THEN run cdp/cd4210b.p PERSISTENT SET v_hdl_reg_produt.
&ENDIF
/*--------*/

{crp/cr0901me.i} /* Valida VersÆo Banco Mercantil do Brasil */
{crp/cr0901as.i} /* Valida VersÆo Banco Santander Noroeste*/
{include/i_fnctrad.i}

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
&Scoped-Define ENABLED-FIELDS portador.ind-dt-cred-ret portador.usa-inter ~
portador.exige-aceite portador.cod-febraban portador.cod-parc-edi ~
portador.intervalo-head portador.prazo-min portador.intervalo-det ~
portador.prazo-max portador.cod-carteira portador.perc-part-dest ~
portador.prox-remessa-cr 
&Scoped-define ENABLED-TABLES portador
&Scoped-define FIRST-ENABLED-TABLE portador
&Scoped-Define ENABLED-OBJECTS RECT-1 RECT-10 cb-tp-layout 
&Scoped-Define DISPLAYED-FIELDS portador.ind-dt-cred-ret portador.usa-inter ~
portador.exige-aceite portador.cod-febraban portador.cod-parc-edi ~
portador.intervalo-head portador.prazo-min portador.intervalo-det ~
portador.prazo-max portador.cod-carteira portador.perc-part-dest ~
portador.prox-remessa-cr 
&Scoped-define DISPLAYED-TABLES portador
&Scoped-define FIRST-DISPLAYED-TABLE portador
&Scoped-Define DISPLAYED-OBJECTS cb-tp-layout c-carteira c-esp-cob-esc ~
c-especie fi-moeda fi-variacao fi-faixa-num fi-usu-cobr fi-contrato ~
cb-caracter fi-convenio tg-agencia tg-coligada titulo1 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS c-especie 
&Scoped-define ADM-ASSIGN-FIELDS c-especie fi-moeda fi-variacao ~
fi-faixa-num fi-contrato fi-convenio tg-agencia tg-coligada 
&Scoped-define List-4 c-especie fi-variacao titulo1 

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
DEFINE BUTTON BUTTON-1 
     LABEL "Vendor" 
     SIZE 14 BY .88.

DEFINE VARIABLE c-carteira AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 30 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE c-especie AS CHARACTER FORMAT "X(100)":U 
     VIEW-AS COMBO-BOX INNER-LINES 8
     DROP-DOWN-LIST
     SIZE 30 BY 1
     FONT 4 NO-UNDO.

DEFINE VARIABLE cb-caracter AS CHARACTER FORMAT "X(3)":U INITIAL "0" 
     LABEL "Caracter Final Arquivo" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     LIST-ITEMS "","Sim","NÆo" 
     DROP-DOWN-LIST
     SIZE 9.29 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tp-layout AS CHARACTER FORMAT "X(25)":U INITIAL "Layout 10 Mensagens" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Layout 10 Mensagens","Layout 20 Mensagens" 
     DROP-DOWN-LIST
     SIZE 20 BY 1 NO-UNDO.

DEFINE VARIABLE c-esp-cob-esc AS CHARACTER FORMAT "X(2)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4 BY .88 NO-UNDO.

DEFINE VARIABLE fi-contrato AS INTEGER FORMAT "999999999":U INITIAL 0 
     LABEL "Contrato" 
     VIEW-AS FILL-IN 
     SIZE 11.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-convenio AS CHARACTER FORMAT "X(16)":U 
     LABEL "N£mero do Convˆnio" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-faixa-num AS INTEGER FORMAT "999,999":U INITIAL 0 
     LABEL "Faixa Num‚rica Inicial" 
     VIEW-AS FILL-IN 
     SIZE 9.29 BY .88 NO-UNDO.

DEFINE VARIABLE fi-moeda AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Nr Carteira" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-usu-cobr AS INTEGER FORMAT "99999":U INITIAL 0 
     LABEL "Usuario Cobranca" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-variacao AS INTEGER FORMAT "999":U INITIAL 0 
     LABEL "Varia‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE titulo1 AS CHARACTER FORMAT "X(50)":U INITIAL "Informa‡äes Complementares" 
      VIEW-AS TEXT 
     SIZE 20.43 BY .58
     FONT 4 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.86 BY 4.42.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.86 BY 6.08.

DEFINE VARIABLE tg-agencia AS LOGICAL INITIAL no 
     LABEL "Agˆncia Cobradora do Cliente" 
     VIEW-AS TOGGLE-BOX
     SIZE 26.86 BY .75 NO-UNDO.

DEFINE VARIABLE tg-coligada AS LOGICAL INITIAL no 
     LABEL "Cobran‡a contra empresa coligada" 
     VIEW-AS TOGGLE-BOX
     SIZE 27.72 BY .75
     FONT 4 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     portador.ind-dt-cred-ret AT ROW 1.13 COL 21.86
          VIEW-AS TOGGLE-BOX
          SIZE 24.86 BY .75
          FONT 4
     portador.usa-inter AT ROW 1.13 COL 50.43
          VIEW-AS TOGGLE-BOX
          SIZE 16 BY .75
     portador.exige-aceite AT ROW 1.13 COL 71
          VIEW-AS TOGGLE-BOX
          SIZE 15.14 BY .75
          FONT 4
     portador.cod-febraban AT ROW 1.88 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     cb-tp-layout AT ROW 1.88 COL 24.86 COLON-ALIGNED NO-LABEL
     portador.cod-parc-edi AT ROW 1.92 COL 69.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.57 BY .88
     portador.intervalo-head AT ROW 2.92 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24.72 BY .88
     portador.prazo-min AT ROW 2.92 COL 69.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     portador.intervalo-det AT ROW 3.92 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 24.72 BY .88
     portador.prazo-max AT ROW 3.92 COL 69.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     portador.cod-carteira AT ROW 4.92 COL 19.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4 BY .88
     c-carteira AT ROW 4.92 COL 24 COLON-ALIGNED NO-LABEL
     portador.perc-part-dest AT ROW 4.92 COL 69.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     c-esp-cob-esc AT ROW 5.92 COL 19.86 COLON-ALIGNED
     c-especie AT ROW 5.92 COL 24 COLON-ALIGNED NO-LABEL
     portador.prox-remessa-cr AT ROW 5.92 COL 69.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     fi-moeda AT ROW 7.83 COL 19.72 COLON-ALIGNED
     fi-variacao AT ROW 7.83 COL 37 COLON-ALIGNED
     fi-faixa-num AT ROW 7.83 COL 68.86 COLON-ALIGNED
     fi-usu-cobr AT ROW 8.83 COL 19.72 COLON-ALIGNED
     fi-contrato AT ROW 8.83 COL 68.86 COLON-ALIGNED
     cb-caracter AT ROW 9.83 COL 19.72 COLON-ALIGNED HELP
          "O sistema ir  gerar o caracter especial de final de arquivo?"
     fi-convenio AT ROW 9.83 COL 68.86 COLON-ALIGNED
     BUTTON-1 AT ROW 10.88 COL 70.86
     tg-agencia AT ROW 11 COL 12
     tg-coligada AT ROW 11 COL 42
     titulo1 AT ROW 7.21 COL 1.72 NO-LABEL
     RECT-1 AT ROW 7.5 COL 1
     RECT-10 AT ROW 1 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE 
         FONT 1.


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
         HEIGHT             = 10.92
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

/* SETTINGS FOR BUTTON BUTTON-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-carteira IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-esp-cob-esc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX c-especie IN FRAME f-main
   NO-ENABLE 1 2 4                                                      */
/* SETTINGS FOR COMBO-BOX cb-caracter IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-contrato IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-convenio IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-faixa-num IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-moeda IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-usu-cobr IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-variacao IN FRAME f-main
   NO-ENABLE 2 4                                                        */
/* SETTINGS FOR TOGGLE-BOX tg-agencia IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-coligada IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN titulo1 IN FRAME f-main
   NO-ENABLE ALIGN-L 4                                                  */
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

&Scoped-define SELF-NAME BUTTON-1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL BUTTON-1 V-table-Win
ON CHOOSE OF BUTTON-1 IN FRAME f-main /* Vendor */
DO:

  assign l-adm-attribute = mgadm.portador.cod-febraban:sensitive.

  if i-cod-febraban-aux <> input frame {&FRAME-NAME} portador.cod-febraban then
     assign c-port-head = " ".     

  run pi-busca-valores in h_v01ad209 (output p-portad,
                                      output p-nome,
                                      output p-modal).  

  if input frame {&FRAME-NAME} portador.cod-febraban = 999 then do:
     run cdp/cd0901a.w (input-output l-adm-attribute,
                        input-output c-port-head,
                        input-output c-legenda, 
                        input-output c-nr-prog-oper,
                        input-output c-contrato, 
                        input(input frame {&FRAME-NAME} portador.cod-febraban),
                        input port-row,
                        input p-portad,
                        input p-nome,
                        input p-modal,
                        input-output i-operacao,
                        input-output i-layout-bb).     
  end.
  else do:
     run cdp/cd0901a.w (input-output l-adm-attribute,
                        input-output c-port-head,
                        input-output c-port-interv, 
                        input-output c-nr-contrato,
                        input-output c-contrato, 
                        input(input frame {&FRAME-NAME} portador.cod-febraban),
                        input port-row,
                        input p-portad,
                        input p-nome,
                        input p-modal,
                        input-output i-operacao,
                        input-output i-layout-bb).
  end.     



  assign i-cod-febraban-aux = input frame {&FRAME-NAME} portador.cod-febraban.

  if input frame {&FRAME-NAME} portador.cod-febraban = 275
  or input frame {&FRAME-NAME} portador.cod-febraban = 356 then
     assign fi-contrato:screen-value             = c-contrato.


  if input frame {&FRAME-NAME} portador.cod-febraban = 999 then
     assign fi-convenio:screen-value = c-contrato.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-carteira
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-carteira V-table-Win
ON VALUE-CHANGED OF c-carteira IN FRAME f-main
DO:
  if  input frame {&frame-name} c-carteira <> "" then do:  
      assign portador.cod-carteira:screen-value in frame {&frame-name} = ENTRY(1,input frame {&frame-name} c-carteira," - ").

      if  input frame {&frame-name} cod-febraban = 341 
      and portador.usa-inter:checked in frame {&FRAME-NAME} = no 
      and l-banking-checked = no then
          assign fi-moeda:screen-value in frame {&frame-name} = 
                 substring(input frame {&frame-name} c-carteira,5,3).
      
  end.
  else do:      
      assign portador.cod-carteira:screen-value in frame {&frame-name} = "".
      if portador.cod-carteira:sensitive in frame {&frame-name} = yes then
         run pi-carteira.
  end.

  if  input frame {&frame-name} cod-febraban = 001 
  and (input frame {&frame-name} portador.cod-carteira = "31"
  or   input frame {&frame-name} portador.cod-carteira = "32"
  or   input frame {&frame-name} portador.cod-carteira = "51") 
  and i-modalidade <> 7 then
      assign tg-coligada:sensitive in frame {&frame-name} = yes.
  else assign tg-coligada:sensitive in frame {&frame-name} = no.
  assign fi-faixa-num:sensitive in frame {&frame-name} = if  tg-coligada:checked in frame {&frame-name} and
                                                             tg-coligada:sensitive in frame {&frame-name}
                                                             then yes else no.
  if  input frame {&frame-name} portador.cod-febraban = 453 then do: 
      if input frame {&frame-name} portador.cod-carteira = "2"
      or input frame {&frame-name} portador.cod-carteira = "5"
      or input frame {&frame-name} portador.cod-carteira = "6" then
         assign fi-convenio:sensitive in frame {&frame-name} = yes.
      else
         assign fi-convenio:sensitive in frame {&frame-name}    = no
                fi-convenio:screen-value in frame {&frame-name} = "".
  end.
  assign l-alterou-carteira = yes.
  apply "leave" to portador.cod-febraban in frame {&FRAME-NAME}.
  assign l-alterou-carteira = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-especie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-especie V-table-Win
ON LEAVE OF c-especie IN FRAME f-main
DO:
    apply 'value-changed' to c-especie in frame {&FRAME-NAME}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-especie V-table-Win
ON VALUE-CHANGED OF c-especie IN FRAME f-main
DO:
  if  input frame {&frame-name} c-especie <> "" then
      assign c-esp-cob-esc:screen-value in frame {&frame-name} =
             substring(string(input frame {&frame-name} c-especie),1,3)
             c-esp-cob = input frame {&FRAME-NAME} c-esp-cob-esc.
  else do:
      assign c-esp-cob-esc:screen-value in frame {&frame-name} = ""
             c-esp-cob = input frame {&FRAME-NAME} c-esp-cob-esc.
      if  c-especie:sensitive in frame {&frame-name} = yes then
          run pi-esp-cob.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.cod-febraban
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.cod-febraban V-table-Win
ON ENTRY OF portador.cod-febraban IN FRAME f-main /* Sistema Banc rio */
DO:
   assign i-cod-febraban-ant = input frame {&FRAME-NAME} portador.cod-febraban     
          i-cod-febraban-aux = input frame {&FRAME-NAME} portador.cod-febraban.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.cod-febraban V-table-Win
ON LEAVE OF portador.cod-febraban IN FRAME f-main /* Sistema Banc rio */
DO:  
    run pi-passa-modalidade in h_v01ad209 (output i-modalidade).  
    if  not l-alterou-carteira then do:
        do  with frame {&frame-name}:
            if  avail portador
            and portador.cod-febraban <> 0
            and (portador.cod-febraban <> input frame {&frame-name} portador.cod-febraban
             or i-cod-febraban-ant    <> input frame {&FRAME-NAME} portador.cod-febraban) then do:
                assign fi-variacao:screen-value           = "000"
                       fi-moeda:screen-value              = "000"
                       fi-contrato:screen-value           = "000000000"
                       fi-faixa-num:screen-value          = "000000"
                       fi-convenio:screen-value           = ""
                       fi-usu-cobr:screen-value           = "000"
                       tg-agencia:checked                 = no
                       tg-coligada:checked                = no
                       portador.cod-carteira:screen-value = ""
                       c-especie:screen-value             = ""
                       c-esp-cob-esc:screen-value         = ""
                       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                           c-especie:LIST-ITEM-PAIRS      = ",".
                       &else
                           c-especie:list-items           = "".
                       &endif             
            end.             
        
            assign portador.intervalo-det:sensitive  = yes
                   portador.intervalo-head:sensitive = yes
                   BUTTON-1:sensitive in frame {&FRAME-NAME}    = no
                   cb-caracter:hidden in frame {&FRAME-NAME}    = yes
                   cb-caracter:sensitive in frame {&frame-name} = no.
        
            if  (input portador.cod-febraban = 291
             or input portador.cod-febraban = 999
             or input portador.cod-febraban = 399)
            and i-modalidade = 7 then do:
                /* Vendor BCN, ALFA, BB e HSBC utilizam carteira e especie fixas no programa de envio */
                assign &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                           c-especie:LIST-ITEM-PAIRS      = ","
                           c-carteira:LIST-ITEM-PAIRS     = "," 
                       &else
                           c-especie:list-items           = ""
                           c-carteira:list-items          = ""
                       &endif
                       c-carteira:screen-value            = ""
                       portador.cod-carteira:screen-value = ""
                       c-especie:screen-value             = ""
                      c-esp-cob-esc:screen-value         = "". 
                if  input frame {&FRAME-NAME} portador.cod-febraban = 999
                and i-modalidade = 7 then
                    assign portador.intervalo-det:sensitive  = yes
                           portador.intervalo-head:sensitive = no
                           portador.intervalo-head:screen-value = " ".
        
                if  input frame {&FRAME-NAME} portador.cod-febraban = 399
                and i-modalidade = 7 then
                    assign portador.intervalo-det:screen-value  = " "
                           portador.intervalo-head:screen-value = " ".          
            end.
            else do:
                if  (input frame {&FRAME-NAME} portador.cod-febraban  = 453) or 
                    (input frame {&FRAME-NAME} portador.cod-febraban  = 027) then do:
                    assign i-emite-bloq-ant = i-emite-bloq. 
                    run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
                    if  i-emite-bloq-ant <> i-emite-bloq then
                        assign i-cod-febraban-ant = - 1.
                end.
                if  portador.usa-inter:checked in frame {&FRAME-NAME} = yes then do:          
                    if  i-cod-febraban-ant <> input frame {&FRAME-NAME} portador.cod-febraban then do:
                        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                            /* Banking Connect */
                            if  l-banking-connect and l-banking-checked then do:
                                &if "{&mgadm_version}" >= "2.04" &then 
                                    assign c-carteira-banking = {varinc/var00181.i 03}
                                           c-especie-banking  = {varinc/var00182.i 03}.
                                    run utp/ut-lstit.p (input-output c-carteira-banking).
                                    run utp/ut-lstit.p (input-output c-especie-banking).
                                    assign c-carteira:LIST-ITEM-PAIRS  = c-carteira-banking
                                           c-especie:list-item-pairs   = c-especie-banking.
                                &endif
                            end.
                            else do:
                                assign cLista1 = {varinc/var00115.i 03}
                                       cLista2 = {varinc/var00126.i 03}.
                                run utp/ut-lstit.p (input-output cLista1).
                                run utp/ut-lstit.p (input-output cLista2).
                                assign c-carteira:list-item-pairs   = cLista1
                                       c-especie:list-item-pairs    = cLista2. 
                            end.
                        &else
                            /* Banking Connect */
                            if  l-banking-connect and l-banking-checked then do:
                                &if "{&mgadm_version}" >= "2.04" &then 
                                    assign c-carteira:list-items   = {varinc/var00181.i 03}
                                           c-especie:list-items    = {varinc/var00182.i 03}. 
                                &endif 
                            end.    
                            else do:
                                assign c-carteira:list-items   = {varinc/var00115.i 03}
                                       c-especie:list-items    = {varinc/var00126.i 03}. 
                            end.           
                        &endif
                        /* Banking Connect */
                        if  l-banking-connect and l-banking-checked then do:
                            &if "{&mgadm_version}" >= "2.04" &then 
                                assign c-carteira:screen-value = {varinc/var00181.i 04 1}
                                       c-especie:screen-value  = {varinc/var00182.i 04 1}.                              
                            &endif
                        end.    
                        else do:
                            assign c-carteira:screen-value = {varinc/var00115.i 04 1}
                                   c-especie:screen-value  = {varinc/var00126.i 04 1}.
                        end.           
                    end.
                end.   
                else do:
                    if  i-cod-febraban-ant <> input frame {&FRAME-NAME} portador.cod-febraban 
                     or ((input frame {&frame-name} c-esp-cob-esc = " " and not (input portador.cod-febraban = 001 and i-modalidade = 7))
                     or input frame {&frame-name} portador.cod-carteira = " ") then do:
                        run pi-carteira.
                        if  not (input portador.cod-febraban = 001 and i-modalidade = 7)  then
                            run pi-esp-cob.
                    end.
                end.
            end.
            apply 'value-changed' to c-carteira.
            apply 'value-changed' to c-especie.
        end.
    end.
    if  input frame {&frame-name} portador.cod-febraban = 001
    or  input frame {&frame-name} portador.cod-febraban = 004
    or  input frame {&frame-name} portador.cod-febraban = 008
    or  input frame {&frame-name} portador.cod-febraban = 027
    or  input frame {&frame-name} portador.cod-febraban = 033
    or  input frame {&frame-name} portador.cod-febraban = 038
    or  input frame {&frame-name} portador.cod-febraban = 041
    or  input frame {&frame-name} portador.cod-febraban = 104
    or  input frame {&frame-name} portador.cod-febraban = 215
    or  input frame {&frame-name} portador.cod-febraban = 224
    or  input frame {&frame-name} portador.cod-febraban = 230
    or  input frame {&frame-name} portador.cod-febraban = 231
    or  input frame {&frame-name} portador.cod-febraban = 237
    or  input frame {&frame-name} portador.cod-febraban = 244
    or  input frame {&frame-name} portador.cod-febraban = 275
    or  input frame {&frame-name} portador.cod-febraban = 356
    or  input frame {&frame-name} portador.cod-febraban = 291
    or  input frame {&frame-name} portador.cod-febraban = 320
    or  input frame {&frame-name} portador.cod-febraban = 341
    or  input frame {&frame-name} portador.cod-febraban = 346
    or  input frame {&frame-name} portador.cod-febraban = 347
    or  input frame {&frame-name} portador.cod-febraban = 351
    or  input frame {&frame-name} portador.cod-febraban = 353 
    or (input frame {&frame-name} portador.cod-febraban = 389
    and l-mercantil)
    or  input frame {&frame-name} portador.cod-febraban = 392
    or  input frame {&frame-name} portador.cod-febraban = 394
    or  input frame {&frame-name} portador.cod-febraban = 399
    or  input frame {&frame-name} portador.cod-febraban = 409
    or  input frame {&frame-name} portador.cod-febraban = 422
    or (input frame {&frame-name} portador.cod-febraban = 424
    and l-sant424)
    or  input frame {&frame-name} portador.cod-febraban = 456
    or  input frame {&frame-name} portador.cod-febraban = 479
    or  input frame {&frame-name} portador.cod-febraban = 634 
    or  input frame {&frame-name} portador.cod-febraban = 745
    or  input frame {&frame-name} portador.cod-febraban = 453 
    or  input frame {&frame-name} portador.cod-febraban = 641 then
        assign c-carteira:sensitive in frame {&frame-name} = yes
               c-especie:sensitive  in frame {&frame-name} = yes.

    assign fi-variacao:sensitive           in frame {&frame-name} = no
           fi-moeda:sensitive              in frame {&frame-name} = no
           fi-faixa-num:sensitive          in frame {&frame-name} = no
           fi-contrato:sensitive           in frame {&frame-name} = no
           cb-tp-layout:hidden             in frame {&FRAME-NAME} = yes
           fi-convenio:sensitive           in frame {&frame-name} = no
           tg-agencia:sensitive            in frame {&frame-name} = no
           tg-coligada:sensitive           in frame {&frame-name} = no
           fi-usu-cobr:sensitive           in frame {&frame-name} = no
           portador.exige-aceite:sensitive in frame {&frame-name} = yes
           fi-usu-cobr:format              in frame {&FRAME-NAME} = if input frame {&frame-name} portador.cod-febraban = 033 then 
                                                                        "9999999"
                                                                    ELSE if input frame {&frame-name} portador.cod-febraban <> 641 then 
                                                                        "999"
                                                                    else
                                                                        "99999"
           fi-faixa-num:format             in frame {&FRAME-NAME} = "999,999"
           fi-contrato:format              in frame {&FRAME-NAME} = "999999999"
           fi-convenio:format              in frame {&FRAME-NAME} = "X(16)"
           fi-usu-cobr:LABEL               in frame {&FRAME-NAME} = "Usu rio Cobran‡a"
           fi-faixa-num:LABEL              in frame {&FRAME-NAME} = "Faixa Num‚rica Inicial"
           fi-contrato:LABEL               in frame {&FRAME-NAME} = "Contrato"
           fi-convenio:LABEL               in frame {&FRAME-NAME} = "N£mero Convˆnio"
           cb-caracter:hidden              in frame {&FRAME-NAME} = yes
           cb-caracter:sensitive           in frame {&frame-name} = no.
    
    if  input frame {&frame-name} portador.cod-febraban = 001 then do:
        if  i-modalidade <> 7 then do:
            if  input frame {&frame-name} portador.cod-carteira = "31" or
                input frame {&frame-name} portador.cod-carteira = "32" or
                input frame {&frame-name} portador.cod-carteira = "51" then
                assign tg-coligada:sensitive in frame {&frame-name} = yes.
            assign fi-variacao:sensitive  in frame {&frame-name} = yes
                   fi-faixa-num:sensitive in frame {&frame-name} = tg-coligada:checked in frame {&frame-name}.
        end.
    end.       
    
    if input frame {&frame-name} portador.cod-febraban = 001 
    or input frame {&frame-name} portador.cod-febraban = 353 
    or input frame {&frame-name} portador.cod-febraban = 008  
    or input frame {&frame-name} portador.cod-febraban = 033  
    or input frame {&frame-name} portador.cod-febraban = 351
    or input frame {&frame-name} portador.cod-febraban = 231  
    or input frame {&frame-name} portador.cod-febraban = 275
    or input frame {&frame-name} portador.cod-febraban = 356
    or input frame {&frame-name} portador.cod-febraban = 320  
    or input frame {&frame-name} portador.cod-febraban = 341  
    or input frame {&frame-name} portador.cod-febraban = 389  
    or input frame {&frame-name} portador.cod-febraban = 399
    or input frame {&frame-name} portador.cod-febraban = 409
    or input frame {&frame-name} portador.cod-febraban = 422 
    or input frame {&frame-name} portador.cod-febraban = 230 
    or input frame {&frame-name} portador.cod-febraban = 215 
    or input frame {&frame-name} portador.cod-febraban = 291 
    or input frame {&frame-name} portador.cod-febraban = 394 
    or input frame {&frame-name} portador.cod-febraban = 641 
    or input frame {&frame-name} portador.cod-febraban = 224 
    or input frame {&frame-name} portador.cod-febraban = 104 
    or input frame {&frame-name} portador.cod-febraban = 27  
    or input frame {&frame-name} portador.cod-febraban = 392 
    or input frame {&frame-name} portador.cod-febraban = 634 
    or input frame {&frame-name} portador.cod-febraban = 424 
    or input frame {&frame-name} portador.cod-febraban = 38  
    or input frame {&frame-name} portador.cod-febraban = 347 
    or input frame {&frame-name} portador.cod-febraban = 479 
    or input frame {&frame-name} portador.cod-febraban = 244 
    or input frame {&frame-name} portador.cod-febraban = 346 
    or input frame {&frame-name} portador.cod-febraban = 004 
    or input frame {&frame-name} portador.cod-febraban = 453 
    or input frame {&frame-name} portador.cod-febraban = 745 
    or input frame {&frame-name} portador.cod-febraban = 456 
    or input frame {&frame-name} portador.cod-febraban = 41  THEN  
        assign cb-caracter:hidden              in frame {&FRAME-NAME} = no
               cb-caracter:sensitive           in frame {&frame-name} = yes.
    
    if  input frame {&frame-name} portador.cod-febraban = 275
    or  input frame {&frame-name} portador.cod-febraban = 356 then do:
        {utp/ut-liter.i Tipo_de_Cobran‡a}
        assign portador.cod-carteira:label in frame {&frame-name} = return-value.
    
        {utp/ut-liter.i C¢digo_da_Carteira}
        assign fi-contrato:sensitive       in frame {&frame-name} = yes
               fi-moeda:sensitive          in frame {&frame-name} = yes
               fi-moeda:label              in frame {&frame-name} = return-value
               cb-tp-layout:hidden         in frame {&FRAME-NAME} = no
               cb-tp-layout:sensitive      in frame {&FRAME-NAME} = yes.
    end.
    
    if  input frame {&frame-name} portador.cod-febraban = 479 
    and i-modalidade = 3 then
        assign fi-contrato:format     in frame {&frame-name} = "99999999"
               fi-contrato:sensitive  in frame {&frame-name} = yes.
    
    if  input frame {&frame-name} portador.cod-febraban = 341 then
        if  l-banking-connect = no then
          assign tg-agencia:sensitive   in frame {&frame-name} = yes.
        else
          assign tg-agencia:sensitive   in frame {&frame-name} = yes
                 fi-variacao:sensitive   in frame {&frame-name} = yes.
    
    if  input frame {&frame-name} portador.cod-febraban = 399 or 
        input frame {&frame-name} portador.cod-febraban = 392 or
        input frame {&frame-name} portador.cod-febraban = 999 or 
        input frame {&FRAME-NAME} portador.cod-febraban = 001 then
        assign fi-convenio:sensitive  in frame {&frame-name} = yes.
    
    if  input frame {&frame-name} portador.cod-febraban = 004 then
        assign fi-usu-cobr:sensitive  in frame {&frame-name} = yes.      
    
    if  input frame {&frame-name} portador.cod-febraban = 230 then
        assign portador.exige-aceite:sensitive  in frame {&frame-name} = no.
    
    if (input frame {&FRAME-NAME} portador.cod-febraban = 275
     or input frame {&FRAME-NAME} portador.cod-febraban = 356)
        and i-modalidade = 7 then
        assign BUTTON-1:sensitive = yes
               portador.intervalo-head:sensitive    = no
               portador.intervalo-head:screen-value = " " 
               portador.intervalo-det:screen-value  = " ".            
    
    if  input frame {&FRAME-NAME} portador.cod-febraban = 237 
        and i-modalidade = 7 then
        assign  BUTTON-1:sensitive                   = yes
                 fi-contrato:sensitive                = no
                 portador.intervalo-det:sensitive     = no
                 portador.intervalo-head:sensitive    = no 
                 fi-contrato:screen-value             = " "
                 portador.intervalo-det:screen-value  = " "
                 portador.intervalo-head:screen-value = " ".
    
    if  i-modalidade = 7 then 
        assign c-especie:sensitive = yes
               fi-moeda:sensitive  = yes
               mgadm.portador.usa-inter:sensitive = no.
   
    if (input frame {&FRAME-NAME} portador.cod-febraban = 291
     or input frame {&FRAME-NAME} portador.cod-febraban = 999
     or input frame {&FRAME-NAME} portador.cod-febraban = 001 ) /* BB, HSBC, BCN ou ALFA - Vendor */
    and i-modalidade = 7 then do:
        assign c-especie:sensitive  in frame {&frame-name} = no.
        if  input frame {&FRAME-NAME} portador.cod-febraban <> 001 then
            assign c-carteira:sensitive in frame {&frame-name} = no.
    end.
    
    if  input frame {&frame-name} portador.cod-febraban = 399
    and i-modalidade = 7 then
        assign BUTTON-1:sensitive                   = yes
               fi-moeda:sensitive    = no
               fi-convenio:sensitive = yes
               c-especie:sensitive   = no
               c-carteira:sensitive  = no
               portador.intervalo-head:sensitive = no
               portador.intervalo-det:sensitive = no
               fi-contrato:label = "N£mero Convˆnio"
               fi-convenio:label = "Contrato".
    else
        assign fi-contrato:label = "Contrato"
               fi-convenio:label = "N£mero Convenio".
    
    IF  INPUT FRAME {&FRAME-NAME} portador.cod-febraban = 641 THEN /*BBV*/
        ASSIGN fi-usu-cobr:LABEL       IN FRAME {&FRAME-NAME} = "Cod Cedente"
               fi-faixa-num:LABEL      IN FRAME {&FRAME-NAME} = "Produto"
               fi-contrato:LABEL       IN FRAME {&FRAME-NAME} = "Sub Produto"
               fi-convenio:LABEL       IN FRAME {&FRAME-NAME} = "Tp layout Cedente"
               fi-usu-cobr:FORMAT      IN FRAME {&FRAME-NAME} = "99999"
               fi-faixa-num:FORMAT     IN FRAME {&FRAME-NAME} = "99"
               fi-contrato:FORMAT      IN FRAME {&FRAME-NAME} = "9999"
               fi-convenio:FORMAT      IN FRAME {&FRAME-NAME} = "X(01)"
               fi-usu-cobr:SENSITIVE   IN FRAME {&FRAME-NAME} = YES
               fi-faixa-num:SENSITIVE  IN FRAME {&FRAME-NAME} = YES
               fi-contrato:SENSITIVE   IN FRAME {&FRAME-NAME} = YES
               fi-convenio:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.
    
    IF  INPUT FRAME {&FRAME-NAME} portador.cod-febraban = 033 THEN /*Santander*/
        ASSIGN fi-usu-cobr:LABEL       IN FRAME {&FRAME-NAME} = "Cod Cedente"
               fi-usu-cobr:FORMAT      IN FRAME {&FRAME-NAME} = "9999999"
               fi-usu-cobr:SENSITIVE   IN FRAME {&FRAME-NAME} = YES.

    if  input frame {&FRAME-NAME} portador.cod-febraban = 999 /* ALFA - Vendor */
    and i-modalidade = 7 then
        assign BUTTON-1:sensitive = yes
               fi-moeda:sensitive = no.
    
    if  input frame {&FRAME-NAME} portador.cod-febraban = 001 /* BB - Vendor */
        and i-modalidade = 7 then
        assign fi-moeda:sensitive = no
               fi-variacao:sensitive  in frame {&frame-name} = yes
               BUTTON-1:sensitive = yes .
    
    if  input frame {&FRAME-NAME} portador.cod-febraban = 453 then do:
        if  input frame {&frame-name} portador.cod-carteira = "2"
         or input frame {&frame-name} portador.cod-carteira = "5"
         or input frame {&frame-name} portador.cod-carteira = "6" then
            assign fi-convenio:sensitive in frame {&frame-name} = yes.
        else
            assign fi-convenio:sensitive in frame {&frame-name}    = no
                   fi-convenio:screen-value in frame {&frame-name} = "".
    end.
    
    if  input frame {&frame-name} portador.cod-febraban = 320 then do:
        {utp/ut-liter.i Agˆncia_Cobradora}
        assign fi-convenio:label                            = return-value
               fi-convenio:format    in frame {&frame-name} = "X(05)"
               fi-convenio:sensitive in frame {&frame-name} = yes.
    end.
    assign i-cod-febraban-ant = input frame {&FRAME-NAME} portador.cod-febraban.
    run pi-habilita-mostra in h_v10ad209.
    
    if  l-banking-connect then
        assign fi-variacao:sensitive in frame {&frame-name} = yes.
    
    if  input frame {&frame-name} c-especie = "" then
        assign c-especie:sensitive in frame {&frame-name} = no.
     
    if  input frame {&frame-name} c-carteira = "" then
        assign c-carteira:sensitive in frame {&frame-name} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.intervalo-head
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.intervalo-head V-table-Win
ON LEAVE OF portador.intervalo-head IN FRAME f-main /* Intervalo(27..46) Header */
DO:
   run Who-Is-The-Container IN adm-broker-hdl
       (INPUT this-procedure,
        OUTPUT c-cd0901).
   assign wh-cd0901 = widget-handle(c-cd0901).
   RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT "cod-banco"). 
   assign i-cod-banco = integer(return-value).
 /*  run select-page in wh-cd0901 (3).*/

   if  not avail portador then do:
       if  input frame {&frame-name} portador.cod-febraban <> 237 then do:
           find first b-portador use-index banco
                where b-portador.ep-codigo = i-ep-codigo-usuario
                and   b-portador.cod-banco = i-cod-banco no-lock no-error.
           if  avail portador then
               assign i-prox-remessa = b-portador.prox-remessa-cr.
       end.
       else do:
           find first b-portador use-index banco
                where b-portador.ep-codigo      = i-ep-codigo-usuario
                and   b-portador.cod-banco      = i-cod-banco
                and   b-portador.intervalo-head = input frame {&frame-name} portador.intervalo-head no-lock no-error.
            if  avail b-portador then
                assign i-prox-remessa = b-portador.prox-remessa-cr.
       end.
       assign portador.prox-remessa-cr:screen-value in frame {&frame-name} = string(i-prox-remessa).
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tg-coligada
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tg-coligada V-table-Win
ON VALUE-CHANGED OF tg-coligada IN FRAME f-main /* Cobran‡a contra empresa coligada */
DO:

do with frame {&frame-name}:
  if  tg-coligada:checked then
      assign fi-faixa-num:sensitive = yes.
  else assign fi-faixa-num:sensitive = no
              fi-faixa-num:screen-value = "000000".
end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME portador.usa-inter
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.usa-inter V-table-Win
ON LEAVE OF portador.usa-inter IN FRAME f-main /* Usa Interchange */
DO:
  apply "leave" to portador.cod-febraban.  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL portador.usa-inter V-table-Win
ON VALUE-CHANGED OF portador.usa-inter IN FRAME f-main /* Usa Interchange */
DO:
   assign i-cod-febraban-ant = -1.
  apply "leave" to portador.cod-febraban.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
      RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  assign portador.cod-carteira:FORMAT in frame {&frame-name} = "x(3)".

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

  if  i-pais-impto-usuario <> 1 then
      disable all with frame {&frame-name}.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  assign i-cod-febraban-ant = -1.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

  if  i-pais-impto-usuario <> 1 then
      disable all with frame {&frame-name}.

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (input this-procedure,
      input "bancario").

  if  avail portador and return-value = "no" then
      disable all except portador.cod-parc-edi with frame {&frame-name}.

  if  input frame {&frame-name} portador.cod-febraban = 001
  or  input frame {&frame-name} portador.cod-febraban = 004
  or  input frame {&frame-name} portador.cod-febraban = 008
  or  input frame {&FRAME-NAME} portador.cod-febraban = 027 /* BESC     */
  or  input frame {&frame-name} portador.cod-febraban = 033
  or  input frame {&frame-name} portador.cod-febraban = 038
  or  input frame {&frame-name} portador.cod-febraban = 041
  or  input frame {&frame-name} portador.cod-febraban = 224
  or  input frame {&frame-name} portador.cod-febraban = 230
  or  input frame {&frame-name} portador.cod-febraban = 231
  or  input frame {&frame-name} portador.cod-febraban = 237
  or  input frame {&frame-name} portador.cod-febraban = 244
  or  input frame {&frame-name} portador.cod-febraban = 275
  or  input frame {&frame-name} portador.cod-febraban = 356
  or  input frame {&frame-name} portador.cod-febraban = 341
  or  input frame {&frame-name} portador.cod-febraban = 346
  or  input frame {&frame-name} portador.cod-febraban = 351
  or  input frame {&frame-name} portador.cod-febraban = 353
  or (input frame {&frame-name} portador.cod-febraban = 389
  and l-mercantil)
  or  input frame {&frame-name} portador.cod-febraban = 479
  or  input frame {&frame-name} portador.cod-febraban = 394
  or  input frame {&frame-name} portador.cod-febraban = 409 
  or  input frame {&frame-name} portador.cod-febraban = 422
  or (input frame {&frame-name} portador.cod-febraban = 424
  and l-sant424)
  or  input frame {&frame-name} portador.cod-febraban = 453 /* Rural    */
  or  input frame {&frame-name} portador.cod-febraban = 456 /* Tokyo    */
  or  input frame {&frame-name} portador.cod-febraban = 479
  or  input frame {&frame-name} portador.cod-febraban = 641 then
      assign c-carteira:sensitive in frame {&frame-name} = yes
             c-especie:sensitive  in frame {&frame-name} = yes.

  assign fi-variacao:sensitive           in frame {&frame-name} = no
         fi-moeda:sensitive              in frame {&frame-name} = no
         fi-faixa-num:sensitive          in frame {&frame-name} = no
         fi-contrato:sensitive           in frame {&frame-name} = no
         fi-convenio:sensitive           in frame {&frame-name} = no
         fi-usu-cobr:sensitive           in frame {&frame-name} = no
         tg-agencia:sensitive            in frame {&frame-name} = no
         tg-coligada:sensitive           in frame {&frame-name} = no
         cb-caracter:hidden              in frame {&FRAME-NAME} = yes
         cb-caracter:sensitive           in frame {&frame-name} = no.

  assign c-especie:sensitive  in frame {&frame-name} = yes
         c-carteira:sensitive in frame {&frame-name} = yes.

  if  input frame {&frame-name} portador.cod-febraban = 392 then 
      assign fi-convenio:sensitive  in frame {&frame-name} = yes.

  if  input frame {&frame-name} portador.cod-febraban = 001 then do:
      if portador.modalidade <> 7 then do:
         if  input frame {&frame-name} portador.cod-carteira = "31" or
             input frame {&frame-name} portador.cod-carteira = "32" or
             input frame {&frame-name} portador.cod-carteira = "51" then
              assign tg-coligada:sensitive in frame {&frame-name} = yes.
         else assign tg-coligada:sensitive in frame {&frame-name} = no.
         assign fi-variacao:sensitive  in frame {&frame-name} = yes
                fi-faixa-num:sensitive in frame {&frame-name} = tg-coligada:checked in frame {&frame-name}.
      end.
  end.

  if input frame {&frame-name} portador.cod-febraban = 001 
  or input frame {&frame-name} portador.cod-febraban = 353 
  or input frame {&frame-name} portador.cod-febraban = 008 
  or input frame {&frame-name} portador.cod-febraban = 033
  or input frame {&frame-name} portador.cod-febraban = 351
  or input frame {&frame-name} portador.cod-febraban = 231  
  or input frame {&frame-name} portador.cod-febraban = 275
  or input frame {&frame-name} portador.cod-febraban = 356
  or input frame {&frame-name} portador.cod-febraban = 320  
  or input frame {&frame-name} portador.cod-febraban = 341  
  or input frame {&frame-name} portador.cod-febraban = 389  
  or input frame {&frame-name} portador.cod-febraban = 399
  or input frame {&frame-name} portador.cod-febraban = 409
  or input frame {&frame-name} portador.cod-febraban = 422
  or input frame {&frame-name} portador.cod-febraban = 230 
  or input frame {&frame-name} portador.cod-febraban = 215 
  or input frame {&frame-name} portador.cod-febraban = 291 
  or input frame {&frame-name} portador.cod-febraban = 394 
  OR input frame {&frame-name} portador.cod-febraban = 641 
  or input frame {&frame-name} portador.cod-febraban = 224 
  or input frame {&frame-name} portador.cod-febraban = 104 
  or input frame {&frame-name} portador.cod-febraban = 27  
  or input frame {&frame-name} portador.cod-febraban = 392 
  or input frame {&frame-name} portador.cod-febraban = 634 
  or input frame {&frame-name} portador.cod-febraban = 424 
  or input frame {&frame-name} portador.cod-febraban = 38  
  or input frame {&frame-name} portador.cod-febraban = 347 
  or input frame {&frame-name} portador.cod-febraban = 479 
  or input frame {&frame-name} portador.cod-febraban = 244 
  OR input frame {&frame-name} portador.cod-febraban = 346 
  or input frame {&frame-name} portador.cod-febraban = 004 
  or input frame {&frame-name} portador.cod-febraban = 453 
  or input frame {&frame-name} portador.cod-febraban = 745 
  or input frame {&frame-name} portador.cod-febraban = 456 
  or input frame {&frame-name} portador.cod-febraban = 41  THEN 
  assign cb-caracter:hidden              in frame {&FRAME-NAME} = no
         cb-caracter:sensitive           in frame {&frame-name} = yes.

  if  input frame {&frame-name} portador.cod-febraban = 275
  or  input frame {&frame-name} portador.cod-febraban = 356 then
      assign fi-contrato:sensitive in frame {&frame-name} = yes.

  if  input frame {&frame-name} portador.cod-febraban = 341 then
      if l-banking-connect = no then
        assign tg-agencia:sensitive in frame {&frame-name} = yes.
      else 
        assign tg-agencia:sensitive in frame {&frame-name} = yes
               fi-variacao:sensitive in frame {&frame-name} = yes.    
  if  input frame {&frame-name} portador.cod-febraban = 004 then
      assign fi-usu-cobr:sensitive in frame {&frame-name} = yes.    
  if  input frame {&frame-name} portador.cod-febraban = 033 then
      assign fi-usu-cobr:sensitive in frame {&frame-name} = yes.    

  if  input frame {&frame-name} portador.cod-febraban = 230 then
      assign portador.exige-aceite:sensitive  in frame {&frame-name} = no.      

  assign portador.cod-carteira:sensitive in frame {&frame-name} = no.

  if avail portador and portador.modalidade = 7
  then assign c-especie:sensitive = yes
               fi-moeda:sensitive  = yes
               mgadm.portador.usa-inter:sensitive = no.

  if  input frame {&frame-name} portador.cod-febraban = 001 
  and portador.modalidade = 7 then
      assign fi-moeda:sensitive = no
             fi-convenio:sensitive = yes.

  if  input frame {&frame-name} portador.cod-febraban = 399
  and portador.modalidade = 7 then
      assign fi-moeda:sensitive    = no
             fi-convenio:sensitive = yes
             c-especie:sensitive   = no
             c-carteira:sensitive  = no
             portador.intervalo-head:sensitive = no
             portador.intervalo-det:sensitive = no.

if input frame {&FRAME-NAME} portador.cod-febraban <> 0 then do:
   if input frame {&FRAME-NAME} c-esp-cob-esc = "" then 
      run pi-esp-cob.

   if input frame {&FRAME-NAME} portador.cod-carteira = "" then 
      run pi-carteira.

end.

if l-banking-connect then
    assign fi-variacao:sensitive           in frame {&frame-name} = yes.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-valid.i}

  case input frame {&frame-name} portador.cod-febraban:
       when 001 then do:
           assign c-complemento = string(input frame {&frame-name} fi-variacao,"999") +
                                  string(input frame {&frame-name} fi-faixa-num,"999999")             +
                                  string(input frame {&frame-name} fi-convenio, "999999999")          +
                                  string(i-layout-bb, "9"). 
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 004 then do:
            assign c-complemento = string(input frame {&frame-name} fi-usu-cobr,"999").
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 008 then
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  

       when 033 THEN DO:
           assign c-complemento = string(input frame {&frame-name} fi-usu-cobr,"9999999").
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  
       END.

       when 231 then
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  

       when 275 or when 356 then  /* Real */ DO:
            if i-modalidade = 7 then    /*informa‡äe vendor */ 
               assign c-complemento  = string(c-contrato,'999999999') + string(c-nr-contrato,'99999').
            else            
               assign c-complemento = string(input frame {&frame-name} fi-contrato,"999999999")
                                    + "     "
                                    + string(input frame {&frame-name} fi-moeda,"999").

            IF input frame {&frame-name} portador.cod-febraban = 275 OR
               input frame {&frame-name} portador.cod-febraban = 356 THEN
                assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       END.

       when 320 THEN DO:
               assign c-complemento = string(input frame {&frame-name} fi-convenio, "99999").
               assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       END.

       when 341 THEN DO:
            if NOT l-banking-checked then do: 
              assign c-complemento = string(input frame {&frame-name} fi-moeda,"999") +
                     c-agencia.
            end.
            else do:
              assign c-complemento = string(input frame {&frame-name} fi-variacao,"999") +
                     c-agencia.
            end.
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       END.

       when 351 then
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  

       when 353 then
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").

       when 389 then
          assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  

       when 399 THEN DO:
            assign c-complemento = string(input frame {&frame-name} fi-convenio,"9999999999999999") +
                                   string(i-operacao,"9").
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  
       END.

       when 392 then do: /* FINASA */
            assign c-complemento = string(input frame {&frame-name} fi-convenio,"99999") +
                                   string(input frame {&frame-name} fi-moeda,"999").
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 409 then /* Unibanco */ DO:
            assign c-complemento = string(input frame {&frame-name} fi-moeda,"999").
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  
       END.

       when 422 then
          assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  

       when 479 then do: /* Banco de Boston */
            assign c-complemento = string(input frame {&FRAME-NAME} fi-contrato,"99999999").
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 453 then do:
                     if input frame {&frame-name} portador.cod-carteira = "2"
                     or input frame {&frame-name} portador.cod-carteira = "5"
                     or input frame {&frame-name} portador.cod-carteira = "6" then
                        assign c-complemento = input frame {&frame-name} fi-convenio.
                     else    
                        assign c-complemento = "".
                     assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
                end.
       when 999 then  /* ALFA */ 
            if  i-modalidade = 7 then    /*informa»„e vendor */ 
                assign c-complemento = string(input frame {&frame-name} fi-convenio,'x(09)') /* Nœmero do Conv¼nio */ 
                                     + string(c-nr-prog-oper,"99999")                        /* Nr. Progr. Operacional */
                                     + string(c-legenda,"x(05)").                            /* Legenda */
       
       when 641 then do:
            assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 230 or when 215 OR WHEN 291 or WHEN 394 or WHEN 224 or WHEN 104 or WHEN 27 OR when 634 OR
       WHEN 424 or WHEN 38  or WHEN 347 or WHEN 244 or WHEN 346 OR WHEN 745 or WHEN 456 or WHEN 41  then 
           assign overlay(c-complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").

       otherwise assign c-complemento = "".
  end.

  assign c-port-head-aux    = c-port-head
         c-contrato-aux     = c-contrato
         c-nr-contrato-aux  = c-nr-contrato
         c-port-interv-aux  = c-port-interv
         c-nr-prog-oper-aux = c-nr-prog-oper 
         c-legenda-aux      = c-legenda.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     return 'ADM-ERROR':U.

  assign portador.esp-cob-esc = c-esp-cob.   

  if  input frame {&frame-name} portador.prox-remessa-cr <> i-prox-remessa then do:
      assign i-prox-remessa = input frame {&frame-name} portador.prox-remessa-cr.
      if  input frame {&frame-name} portador.cod-febraban <> 237 then do:
          for each b-portador use-index banco
              where b-portador.ep-codigo = i-ep-codigo-usuario
              and   b-portador.cod-banco = i-cod-banco exclusive-lock:
                assign b-portador.prox-remessa-cr = i-prox-remessa.
          end.
      end.
      else do:
          for each b-portador use-index banco
              where b-portador.ep-codigo = i-ep-codigo-usuario
              and   b-portador.cod-banco = i-cod-banco
              and   b-portador.intervalo-head = input frame {&frame-name} portador.intervalo-head exclusive-lock:
                assign b-portador.prox-remessa-cr = i-prox-remessa.
          end.
      end.
  end.

  assign c-agencia = if tg-agencia:checked in frame {&frame-name} then "S" else "N".

  case portador.cod-febraban:
       when 001 then do:
           /*Importante - Qualque altera‡Æo efetuada no campo portador.complemento deve ser tratada tbm no cr0901.i10*/
           assign portador.complemento = string(input frame {&frame-name} fi-variacao,"999")        +
                                         string(input frame {&frame-name} fi-faixa-num,"999999")    +
                                         string(input frame {&frame-name} fi-convenio, "999999999") + 
                                         string(i-layout-bb, "9").
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999"). 
       end.

       when 004 then do: /*Nordeste*/
           assign portador.complemento = string(input frame {&frame-name} fi-usu-cobr,"999").
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end. 
       when 008 then
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   

       when 033 THEN DO:
           assign portador.complemento = string(input frame {&frame-name} fi-usu-cobr,"9999999").
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   
       END.

       when 231 then
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   

       when 275 or when 356 then  /* Real */ DO:
            if i-modalidade = 7 then do:   /*informa‡äe vendor */ 
               assign portador.complemento    = string(c-contrato-aux,'999999999') + string(c-nr-contrato-aux,'99999')     
                      portador.intervalo-det  = c-port-interv-aux 
                      portador.intervalo-head = c-port-head-aux. 
            end.          
            else            
               assign portador.complemento = string(input frame {&frame-name} fi-contrato,"999999999")
                                           + "     "
                                           + string(input frame {&frame-name} fi-moeda,"999").

            IF portador.cod-febraban = 275 or
               portador.cod-febraban = 356 THEN
                assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999"). 
       END.

       when 237 then    /* Bradesco */
              if i-modalidade = 7 then
                 assign portador.intervalo-head = c-port-head-aux.      

       when 320 THEN DO:
            assign portador.complemento = string(input frame {&frame-name} fi-convenio, "99999").
            assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999"). 
       END.

       when 341 THEN DO:
            if NOT l-banking-checked then 
               assign portador.complemento = string(input frame {&frame-name} fi-moeda,"999") +
                      c-agencia.
            else 
               assign portador.complemento = string(input frame {&frame-name} fi-variacao,"999") +
                      c-agencia.
            assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  
       END.

       when 351 then
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").  

       when 353 then
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999"). 

      when 389 then
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   

       when 399 THEN DO:
           assign portador.complemento = string(input frame {&frame-name} fi-convenio,"9999999999999999") +
                                         string(i-operacao,"9").
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   
       END.

       when 392 then do: /* FINASA */
           assign portador.complemento = string(input frame {&frame-name} fi-convenio,"99999") +
                                         string(input frame {&frame-name} fi-moeda,"999").
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 409 then /* Unibanco */  DO:
            assign portador.complemento = string(input frame {&frame-name} fi-moeda,"999").
            assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   
       END.

       when 422 then
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").   

       when 479 then do: /* Banco de Boston */
            assign portador.complemento = string(input frame {&FRAME-NAME} fi-contrato,"99999999").
            assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 453 then do:
           if input frame {&frame-name} portador.cod-carteira = "2"
           or input frame {&frame-name} portador.cod-carteira = "5"
           or input frame {&frame-name} portador.cod-carteira = "6" then
              assign portador.complemento = input frame {&frame-name} fi-convenio.
           else    
              assign portador.complemento = "".
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       WHEN 641 THEN do:
           ASSIGN portador.complemento =   STRING(SUBSTR((INPUT FRAME {&FRAME-NAME}  fi-usu-cobr),1,5))
                                         + STRING(SUBSTR((INPUT FRAME {&FRAME-NAME} fi-faixa-num),1,2))
                                         + STRING(SUBSTR((INPUT FRAME {&FRAME-NAME}  fi-contrato),1,4))
                                         + STRING(SUBSTR((INPUT FRAME {&FRAME-NAME}  fi-convenio),1,1)).
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").
       end.
       when 999 then  /* Real */ 
            if i-modalidade = 7 then    /*informa»„es vendor */ 
               assign portador.complemento = string(input frame {&frame-name} fi-convenio,'x(09)') /* Nœmero do Conv¼nio */ 
                                           + string(c-nr-prog-oper-aux,"99999")                        /* Nr. Progr. Operacional */
                                           + string(c-legenda-aux,"x(05)")                             /* Legenda */
                      portador.intervalo-head = c-port-head-aux
                      portador.intervalo-det  = input frame {&frame-name} portador.intervalo-det.


       when 230 or when 215 OR WHEN 291 or WHEN 394 or WHEN 224 or WHEN 104 or WHEN 27 OR when 634 OR 
       WHEN 424 or WHEN 38  or WHEN 347 or WHEN 244 or WHEN 346 OR WHEN 745 or WHEN 456 or WHEN 41 then 
           assign overlay(portador.complemento,45,3) = string(input frame {&frame-name} cb-caracter, "999").

       otherwise assign portador.complemento = "".
  end.

  if  portador.cod-febraban = 275
  or  portador.cod-febraban = 356 then do:
      if  input frame {&FRAME-NAME} cb-tp-layout = "Layout 10 Mensagens" then
          assign portador.dec-2 = 1.
      else    
          assign portador.dec-2 = 2. 
  end.
  else
      assign portador.dec-2 = 0.

  assign i-cod-febraban-ant = -1.

  assign button-1:sensitive in frame {&frame-name} = no
         l-vendor = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  assign i-cod-febraban-ant = input frame {&FRAME-NAME} portador.cod-febraban.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
   assign i-cod-febraban-ant = -1.


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

  assign fi-variacao:sensitive  in frame {&frame-name} = no
         fi-moeda:sensitive     in frame {&frame-name} = no
         fi-faixa-num:sensitive in frame {&frame-name} = no
         fi-contrato:sensitive  in frame {&frame-name} = no
         fi-convenio:sensitive  in frame {&frame-name} = no
         fi-usu-cobr:sensitive  in frame {&frame-name} = no         
         tg-agencia:sensitive   in frame {&frame-name} = no
         tg-coligada:sensitive  in frame {&frame-name} = no
         c-carteira:sensitive   in frame {&frame-name} = no
         c-especie:sensitive    in frame {&frame-name} = no
         cb-tp-layout:sensitive in frame {&frame-name} = no
         cb-caracter:sensitive  in frame {&frame-name} = no
         i-cod-febraban-ant = -1.

  assign l-enable = no.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  assign portador.cod-carteira:screen-value in frame {&FRAME-NAME} = ""
         &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           c-carteira:LIST-ITEM-PAIRS         IN FRAME {&FRAME-NAME} = ","
           c-especie:LIST-ITEM-PAIRS          IN FRAME {&FRAME-NAME} = ","
         &else
           c-carteira:list-items              in frame {&FRAME-NAME} = ""
           c-especie:list-items               in frame {&FRAME-NAME} = ""
         &endif
         c-esp-cob-esc:screen-value         in frame {&FRAME-NAME} = ""
         c-especie:screen-value             in frame {&FRAME-NAME} = ""
         c-carteira:screen-value            in frame {&FRAME-NAME} = "".

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  assign BUTTON-1:sensitive in frame {&FRAME-NAME} = no.

  if  avail portador then do:
      if portador.cod-febraban = 001 
      or portador.cod-febraban = 353 
      or portador.cod-febraban = 008
      OR portador.cod-febraban = 033
      or portador.cod-febraban = 351
      or portador.cod-febraban = 231
      or portador.cod-febraban = 275
      or portador.cod-febraban = 356
      or portador.cod-febraban = 320
      or portador.cod-febraban = 341
      or portador.cod-febraban = 389
      or portador.cod-febraban = 399
      or portador.cod-febraban = 409
      or portador.cod-febraban = 422 
      or portador.cod-febraban = 230 
      or portador.cod-febraban = 215 
      or portador.cod-febraban = 291 
      or portador.cod-febraban = 394 
      or portador.cod-febraban = 641 
      or portador.cod-febraban = 224 
      or portador.cod-febraban = 104 
      or portador.cod-febraban = 27  
      or portador.cod-febraban = 392 
      or portador.cod-febraban = 634 
      or portador.cod-febraban = 424 
      or portador.cod-febraban = 38  
      or portador.cod-febraban = 347 
      or portador.cod-febraban = 479 
      or portador.cod-febraban = 244 
      or portador.cod-febraban = 346 
      or portador.cod-febraban = 004 
      or portador.cod-febraban = 453 
      or portador.cod-febraban = 745 
      or portador.cod-febraban = 456 
      or portador.cod-febraban = 41  THEN  
          if substring(portador.complemento,45,3) = "" then
              assign cb-caracter:screen-value in frame {&FRAME-NAME} = "   ".
          else
              assign cb-caracter:screen-value in frame {&FRAME-NAME} = substring(portador.complemento,45,3).
      if portador.cod-febraban <> 999 then do:
         assign c-esp-cob-esc:screen-value in frame {&FRAME-NAME} = portador.esp-cob-esc
                port-row      = rowid(portador)
                c-port-head   =  portador.intervalo-head
                c-port-interv =  portador.intervalo-det
                c-nr-contrato =  substring(portador.complemento,10,5)
                c-contrato    =  substring(portador.complemento,1,9)
                port-row      =  rowid(portador)
                c-complemento =  portador.complemento.
      end.          
      else do:
         assign c-esp-cob-esc:screen-value in frame {&FRAME-NAME} = portador.esp-cob-esc
                port-row       =  rowid(portador)
                c-port-head    =  portador.intervalo-head
                c-port-interv  =  portador.intervalo-det
                c-contrato     =  substring(portador.complemento,1,9)
                c-nr-prog-oper =  substring(portador.complemento,10,5)
                c-legenda      =  substring(portador.complemento,15,5)
                port-row       =  rowid(portador)
                c-complemento  =  portador.complemento.
     end.           

     if  portador.cod-febraban = 275
     or  portador.cod-febraban = 356 then 
         assign fi-moeda:screen-value in frame {&frame-name} = SUBSTRING(portador.complemento,15,3).
  end.

  if  l-enable = no then do:      
      run pi-passa-modalidade in h-handle (output i-modalidade).
      run pi-display.
  end.      

  if input frame {&FRAME-NAME} portador.cod-febraban = 275
  or input frame {&FRAME-NAME} portador.cod-febraban = 356 then
     assign cb-tp-layout:hidden in frame {&FRAME-NAME}    = no
            cb-tp-layout:sensitive in frame {&FRAME-NAME} = no.       
  else 
     assign cb-tp-layout:hidden in frame {&FRAME-NAME} = yes.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------

  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  assign i-cod-febraban-aux = input frame {&FRAME-NAME} portador.cod-febraban.

  if  (ADM-NEW-RECORD = no) then do:
      assign i-cod-febraban-ant = input frame {&FRAME-NAME} portador.cod-febraban.
      if (input frame {&FRAME-NAME} portador.cod-febraban  = 453) or 
         (input frame {&FRAME-NAME} portador.cod-febraban  = 027) then do:
         run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).                          
      end.

      if  avail portador then do:
          if portador.modalidade = 7 then do:
              if portador.cod-febraban = 1 then do:
                 assign i-layout-bb = int(substring(portador.complemento,19,1)).
                 if i-layout-bb <> 1 and i-layout-bb <> 2 then
                    assign i-layout-bb = 1.
              end.
    
              if portador.cod-febraban = 399 then do:
                 assign i-operacao = int(substring(portador.complemento,17,1)).       
                 if i-operacao <> 1 and i-operacao <> 2 then
                    assign i-operacao = 1.
              end.   
    
          end.
          if portador.cod-febraban = 001 
          or portador.cod-febraban = 353 
          or portador.cod-febraban = 008 
          or portador.cod-febraban = 033
          or portador.cod-febraban = 351
          or portador.cod-febraban = 231
          or portador.cod-febraban = 275
          or portador.cod-febraban = 356
          or portador.cod-febraban = 320
          or portador.cod-febraban = 341
          or portador.cod-febraban = 389
          or portador.cod-febraban = 399
          or portador.cod-febraban = 409
          or portador.cod-febraban = 422 
          or portador.cod-febraban = 230 
          or portador.cod-febraban = 215 
          or portador.cod-febraban = 291 
          or portador.cod-febraban = 394 
          or portador.cod-febraban = 641 
          or portador.cod-febraban = 224 
          or portador.cod-febraban = 104 
          or portador.cod-febraban = 27  
          or portador.cod-febraban = 392 
          or portador.cod-febraban = 634 
          or portador.cod-febraban = 424 
          or portador.cod-febraban = 38  
          or portador.cod-febraban = 347 
          or portador.cod-febraban = 479 
          or portador.cod-febraban = 244 
          or portador.cod-febraban = 346 
          or portador.cod-febraban = 004 
          or portador.cod-febraban = 453 
          or portador.cod-febraban = 745 
          or portador.cod-febraban = 456 
          or portador.cod-febraban = 41  THEN  
              if substring(portador.complemento,45,3) = "" then
                  assign cb-caracter:screen-value in frame {&FRAME-NAME} = "   ".
              else
                  assign cb-caracter:screen-value in frame {&FRAME-NAME} = substring(portador.complemento,45,3).
      end.
  end.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  if avail portador then
    if  i-modalidade <> portador.modalidade then
       assign i-modalidade = portador.modalidade.


  run pi-verif-vendor (input "enable").

  /* run pi-habilita-convenio in this-procedure. */

  apply 'value-changed' to c-carteira.
  apply 'value-changed' to c-especie.
  apply "leave" to portador.cod-febraban in frame {&FRAME-NAME}.

  assign l-enable = yes
         l-vendor = no.
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

  RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                              OUTPUT c-handle).

  run pi-busca-handle in widget-handle(c-handle) (output h-handle).                    
  assign h_v01ad209 = h-handle
         l-vendor   = yes.

  /* Banking Connect */
  /* Verifica se o usu ri otem persmissÆo para usar o Banking Connect */
  &if "{&mgadm_version}" >= "2.04" &then
      &IF DEFINED(BF_FIN_AUMENTO_DIGITO_CCUSTO) = 0 &THEN
          /* Procura o registro */
          run find_registro in v_hdl_reg_produt (OUTPUT l-registro-ok, OUTPUT c-empresa-banking).
    
          /* Se encontrar verifica a data limite */
          IF l-registro-ok then do:
              RUN retorna_data_limite IN v_hdl_reg_produt (OUTPUT d-limite).
    
              /* Se a data Limite ‚ valida */
              assign l-banking-connect = TODAY <= d-limite.
          end.
      &ELSE
          assign  l-banking-connect = no.
      &ENDIF
  &else
       assign  l-banking-connect = no.
  &endif.
  /*Fut35231 - Altera‡Æo em virtude da libera‡Æo da include de tradu‡Æo pela Tech*/
  if cLista1  = "" then
     assign cLista1 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif. 
  if cLista2  = "" then 
     assign cLista2 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif.

  /* OBS: Todas as strings do Banking Connect nÆo serÆo traduzidas */
  &if "{&mgadm_version}" >= "2.04" &then 
       ASSIGN c-carteira-banking  = {varinc/var00181.i 03}
              c-especie-banking   = {varinc/var00182.i 03}. 
  &endif
  /*-----------------*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  do with frame {&frame-name}:
      if  avail portador then do:
          if  cfebraban <> portador.cod-febraban then do:
              assign cLista1 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif
                     cLista2 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif
                     cfebraban = portador.cod-febraban.
          end.
          if  portador.cod-febraban <> 001 
          and portador.cod-febraban <> 353
          and portador.cod-febraban <> 008   
          and portador.cod-febraban <> 033   
          and portador.cod-febraban <> 351
          and portador.cod-febraban <> 231
          and portador.cod-febraban <> 275
          and portador.cod-febraban <> 356
          and portador.cod-febraban <> 320
          and portador.cod-febraban <> 341
          and portador.cod-febraban <> 389
          and portador.cod-febraban <> 399
          and portador.cod-febraban <> 409
          and portador.cod-febraban <> 422 
          and portador.cod-febraban <> 230 
          and portador.cod-febraban <> 215 
          and portador.cod-febraban <> 291 
          and portador.cod-febraban <> 394 
          and portador.cod-febraban <> 641 
          and portador.cod-febraban <> 224 
          and portador.cod-febraban <> 104 
          and portador.cod-febraban <> 27  
          and portador.cod-febraban <> 392 
          and portador.cod-febraban <> 634 
          and portador.cod-febraban <> 424 
          and portador.cod-febraban <> 38  
          and portador.cod-febraban <> 347 
          and portador.cod-febraban <> 479 
          and portador.cod-febraban <> 244 
          and portador.cod-febraban <> 346 
          and portador.cod-febraban <> 004 
          and portador.cod-febraban <> 453 
          and portador.cod-febraban <> 745 
          and portador.cod-febraban <> 456 
          AND portador.cod-febraban <> 41  THEN  
             assign cb-caracter:hidden in frame {&FRAME-NAME} = yes.
          else
             assign cb-caracter:hidden in frame {&FRAME-NAME} = no.

          assign &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then  c-carteira:LIST-ITEM-PAIRS IN FRAME {&FRAME-NAME} = "," &else c-carteira:list-items in frame {&FRAME-NAME} = "" &endif.
          
          if portador.usa-inter = yes then do:
             &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                  /* Banking Connect */
                  if l-banking-connect and l-banking-checked then do:
                      &if "{&mgadm_version}" >= "2.04" &then 
                          assign c-carteira-banking = {varinc/var00181.i 03}
                                 c-especie-banking  = {varinc/var00182.i 03}.
                          run utp/ut-lstit.p (input-output c-carteira-banking).
                          run utp/ut-lstit.p (input-output c-especie-banking).
                          assign c-carteira:list-item-pairs   = c-carteira-banking
                                 c-especie:list-item-pairs    = c-especie-banking. 
                      &endif
                  end.
                  else do:
                      assign cLista1 = {varinc/var00115.i 03}
                             cLista2 = {varinc/var00126.i 03}.
                      run utp/ut-lstit.p (input-output cLista1).
                      run utp/ut-lstit.p (input-output cLista2).
                      assign c-carteira:list-item-pairs   = cLista1
                             c-especie:list-item-pairs    = cLista2. 
                  end.

             &else
                  /* Banking Connect */
                  if l-banking-connect and l-banking-checked then do:
                     &if "{&mgadm_version}" >= "2.04" &then 
                         assign c-carteira:list-items   = {varinc/var00181.i 03}
                            c-especie:list-items    = {varinc/var00182.i 03}.  
                      &endif
                  end.    
                  else do:
                     assign c-carteira:list-items   = {varinc/var00115.i 03}
                            c-especie:list-items    = {varinc/var00126.i 03}. 
                  end.          
                  
             &endif 
          end.   
          else do:
                case portador.cod-febraban: 
                     when 001 then do:
                          assign cLista1 = {varinc/var00076.i 03}.
                          if portador.modalidade = 7 then
                              assign cLista2 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif.
                          else
                              assign cLista2 = {varinc/var00080.i 03}.
                     end.
                     when 004 then
                           assign cLista1 = {varinc/var00033.i 03}
                                  cLista2 = {varinc/var00047.i 03}.
                     when 008 then
                           assign cLista1 = {varinc/var00134.i 03}
                                  cLista2 = {varinc/var00127.i 03}.
                     when 033 then 
                           assign cLista1 = {varinc/var00113.i 03}
                                  cLista2 = {varinc/var00114.i 03}.
                     when 038 then
                           assign cLista1 = {varinc/var00128.i 03} 
                                  cLista2 = {varinc/var00129.i 03}.
                     when 041 then 
                           assign cLista1 = {varinc/var00085.i 03}
                                  cLista2 = {varinc/var00086.i 03}.
                     when 230 then
                           assign cLista1 = {varinc/var00101.i 03} 
                                  cLista2 = {varinc/var00100.i 03}.
                     when 231 then
                           assign cLista1 = {varinc/var00063.i 03} 
                                  cLista2 = {varinc/var00056.i 03}.
                     when 237 then
                           assign cLista1 = {varinc/var00077.i 03}
                                  cLista2 = {varinc/var00080.i 03}.
                     when 275 or when 356 then
                           assign cLista1 = {varinc/var00078.i 03}
                                  cLista2 = {varinc/var00173.i 03}.
                     when 341 then 
                           assign cLista1 = {varinc/var00079.i 03}
                                  cLista2 = {varinc/var00172.i 03}.
                     when 399 then  
                            assign cLista1 = {varinc/var00082.i 03} 
                                   cLista2 = {varinc/var00153.i 03}.
                     when 409 then 
                            assign cLista1 = {varinc/var00084.i 03} 
                                   cLista2 = {varinc/var00080.i 03}.
                     when 422 then  
                            assign cLista1 = {varinc/var00081.i 03}
                                   cLista2 = {varinc/var00080.i 03}.
                     when 479 then 
                            assign cLista1 = {varinc/var00093.i 03}
                                   cLista2 = {varinc/var00094.i 03}.
                     when 104 then  
                            assign cLista1 = {varinc/var00097.i 03}
                                   cLista2 = {varinc/var00098.i 03}.
                     when 291 then  
                            assign cLista1 = {varinc/var00099.i 03}
                                   cLista2 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif.
                     when 244 then 
                            assign cLista1 = {varinc/var00132.i 03}
                                   cLista2 = {varinc/var00133.i 03}.
                     when 394 then 
                            assign cLista1 = {varinc/var00130.i 03}
                                   cLista2 = {varinc/var00131.i 03}.
                     when 224 then 
                            assign cLista1 = {varinc/var00135.i 03} 
                                   cLista2 = {varinc/var00136.i 03}.
                     when 389 then 
                          if  l-mercantil then 
                              assign cLista1 = {varinc/var00160.i 03}
                                    cLista2 = {varinc/var00159.i 03}.
                     when 346 then 
                          assign cLista1 = {varinc/var00161.i 03}
                                 cLista2 = {varinc/var00162.i 03}.
                     when 351 then 
                          assign cLista1 = {varinc/var00134.i 03} 
                                 cLista2 = {varinc/var00127.i 03}.
                      when 353 then 
                          assign cLista1 = {varinc/var00154.i 03}
                                 cLista2 = {varinc/var00174.i 03}.
                      when 353 then 
                           if l-sant424  then
                              assign cLista1 = {varinc/var00165.i 03}
                                     cLista2 = {varinc/var00164.i 03}.               
                      when 453 then do: /* RURAL */
                            /* busca o valor do portador.emite-bloq na viewer v04ad209 *
                             * 1 - quando a empresa que emite o bloqueto               *
                             * 2 -  quando o banco emite o bloqueto                    */
                             if avail portador then
                                 assign i-emite-bloq = portador.emite-bloq.

                             if i-emite-bloq  = 1  then
                                assign cLista1   = {varinc/var00144.i 03}
                                       cLista2    = {varinc/var00145.i 03}.
                              else  
                                assign cLista1   = {varinc/var00144.i 03}
                                       cLista2    = {varinc/var00146.i 03}.
                      end.
                      when 456 then 
                            assign cLista1 = {varinc/var00143.i 03}
                                   cLista2 = {varinc/var00142.i 03}.
                      when 641 then 
                            assign cLista1 = {varinc/var00141.i 03}
                                   cLista2 = {varinc/var00140.i 03}.
                      when 027 then do: 
                            /* busca o valor do portador.emite-bloq na viewer v04ad209 *
                             * 1 - quando a empresa que emite o bloqueto             *
                             * 2 -  quando o banco emite o bloqueto                  */
                            if avail portador then
                               assign i-emite-bloq = portador.emite-bloq.

                             assign cLista1 = {varinc/var00147.i 03}.
                             if i-emite-bloq  = 1  then
                                assign cLista2 = {varinc/var00149.i 03}.
                             else  
                                assign cLista2 = {varinc/var00148.i 03}.   
                      end.
                      when 634 then 
                             assign cLista1 = {varinc/var00151.i 03}
                                    cLista2 = {varinc/var00152.i 03}.
                      otherwise
                             assign cLista1 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif
                                    cLista2 = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif.
              
                end.

                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                     /* Banking Connect */
                     if l-banking-connect and l-banking-checked then do:
                         &if "{&mgadm_version}" >= "2.04" &then 
                             assign c-carteira-banking = {varinc/var00181.i 03}
                                    c-especie-banking  = {varinc/var00182.i 03}.

                             run utp/ut-lstit.p (input-output c-carteira-banking).
                             run utp/ut-lstit.p (input-output c-especie-banking).
                             assign c-carteira:list-item-pairs   = c-carteira-banking
                                    c-especie:list-item-pairs    = c-especie-banking. 
                         &endif
                     end.
                     else do:
                         run utp/ut-lstit.p (input-output cLista1).
                         run utp/ut-lstit.p (input-output cLista2).
                         assign c-carteira:list-item-pairs   = cLista1
                                c-especie:list-item-pairs    = cLista2. 
                     end.
                &else
                     /* Banking Connect */
                     if l-banking-connect and l-banking-checked then do:
                         &if "{&mgadm_version}" >= "2.04" &then 
                             assign c-carteira-banking = {varinc/var00181.i 03}
                                    c-especie-banking  = {varinc/var00182.i 03}.
                             assign c-carteira:list-items   = c-carteira-banking
                                    c-especie:list-items    = c-especie-banking. 
                         &endif
                     end.
                     else
                         assign c-carteira:list-items   = cLista1 
                                c-especie:list-items    = cLista2.
                &endif 
          end.   
      end.
  end.

    do with frame {&frame-name}:
      {utp/ut-liter.i Nr_Carteira * L}
      assign fi-moeda:label  = return-value.

      {utp/ut-liter.i Cobran‡a_contra_empresa_coligada * r}
      assign tg-coligada:label  = return-value.

      {utp/ut-liter.i Informa‡äes_Complementares}
      assign titulo1:screen-value = trim(return-value).

      {utp/ut-liter.i Varia‡Æo * L}
      assign fi-variacao:label = return-value.
      {utp/ut-liter.i Agˆncia_Cobradora_do_Cliente * R}
      assign tg-agencia:label = return-value.
      {utp/ut-liter.i Faixa_Num‚rica_Inicial * L}
      assign fi-faixa-num:label = return-value.
      {utp/ut-liter.i Contrato * L}
      assign fi-contrato:label = return-value.
      {utp/ut-liter.i N£mero_Convˆnio * L}
      assign fi-convenio:label = return-value.

      {utp/ut-liter.i Usu rio_Cobran‡a * L}
      assign fi-usu-cobr:label = return-value.


      {utp/ut-liter.i Esp‚cie_Escritural}
      assign c-esp-cob-esc:label = trim(return-value).

      {utp/ut-liter.i Vendor * L}
      assign BUTTON-1:label = return-value.

    end.

    IF AVAIL portador THEN
        run pi-display.

    &IF DEFINED(BF_FIN_EMS2_X_MG) &THEN
        find funcao 
            where funcao.cd-funcao = "spp-ems2fin-x-mg"
              and funcao.ativo     = yes no-lock no-error.
        if  avail funcao then do:
            assign portador.cod-febraban:format in frame {&frame-name} = ">99".
        end.
    &ENDIF.

    /* Banking Connect */
    &if "{&mgadm_version}" >= "2.04" &then 
        if not l-initialize-banking then do:
            if l-banking-connect and l-banking-checked = no then do:
               if avail portador then do:
                   assign l-banking-checked = portador.log-4.
               end.
            end.

            if l-banking-checked then do:
                if l-banking-connect and l-banking-checked then do:
                    &if "{&mgadm_version}" >= "2.04" &then 
                        assign c-carteira-banking = {varinc/var00181.i 03}
                               c-especie-banking  = {varinc/var00182.i 03}.
                        {cdp/cd0901.i1 "var00181.i" "var00182.i"}.
                   &endif
                end.
            end.
            assign l-initialize-banking = yes.
        end.
    &endif
    /*-----------------*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-handle V-table-Win 
PROCEDURE pi-busca-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carteira V-table-Win 
PROCEDURE pi-carteira :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&frame-name}:

       case input portador.cod-febraban: 

            when 001 then assign cLista1   = {varinc/var00076.i 03}.
            when 004 then assign cLista1   = {varinc/var00033.i 03}.
            when 033 then assign cLista1   = {varinc/var00113.i 03}.
            when 041 then assign cLista1   = {varinc/var00085.i 03}.
            when 230 then assign cLista1   = {varinc/var00101.i 03}.
            when 231 then assign cLista1   = {varinc/var00063.i 03}.
            when 237 then assign cLista1   = {varinc/var00077.i 03}.
            when 275 or when 356 then assign cLista1   = {varinc/var00078.i 03}.
            when 341 then assign cLista1   = {varinc/var00079.i 03}.
            when 399 then assign cLista1   = {varinc/var00082.i 03}.
            when 409 then assign cLista1   = {varinc/var00084.i 03}.
            when 422 then assign cLista1   = {varinc/var00081.i 03}.
            when 479 then assign cLista1   = {varinc/var00093.i 03}.
            when 353 then assign cLista1   = {varinc/var00154.i 03}.
            when 641 then assign cLista1   = {varinc/var00141.i 03}.
            when 104 then assign cLista1   = {varinc/var00097.i 03}.
            when 291 then assign cLista1   = {varinc/var00099.i 03}.
            when 745 then assign cLista1   = {varinc/var00116.i 03}.
            when 320 then assign cLista1   = {varinc/var00118.i 03}.
            when 392 then assign cLista1   = {varinc/var00120.i 03}.
            when 347 then assign cLista1   = {varinc/var00168.i 03}.
            when 215 then assign cLista1   = {varinc/var00124.i 03}.
            when 008 then assign cLista1   = {varinc/var00134.i 03}.
            when 038 then assign cLista1   = {varinc/var00128.i 03}.
            when 244 then assign cLista1   = {varinc/var00132.i 03}.
            when 394 then assign cLista1   = {varinc/var00130.i 03}.
            when 224 then assign cLista1   = {varinc/var00135.i 03}.
            when 389 then
                          if  l-mercantil then
                              assign cLista1   = {varinc/var00160.i 03}.
            when 346 then assign cLista1   = {varinc/var00161.i 03}.
            when 351 then assign cLista1   = {varinc/var00134.i 03}.
            when 634 then assign cLista1   = {varinc/var00151.i 03}.
            when 424 then
                          if  l-sant424 then
                              assign cLista1   = {varinc/var00165.i 03}.
            when 456 then assign cLista1   = {varinc/var00143.i 03}.
            when 453 then 
                          if i-emite-bloq  = 1  then
                              assign cLista1   = {varinc/var00144.i 03}.
                          else  
                              assign cLista1   = {varinc/var00144.i 03}. 
            when 027 then assign cLista1   = {varinc/var00147.i 03}.
            otherwise 
                &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                    assign cLista1 = ",". 
                &else
                    assign cLista1 = "". 
                &endif
       end.

       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           /* Banking Connect */
           if l-banking-connect and l-banking-checked then do:
               &if "{&mgadm_version}" >= "2.04" &then 
                  run utp/ut-lstit.p (input-output c-carteira-banking).
                   assign c-carteira:list-item-pairs   = c-carteira-banking.
               &endif
           end.
           else do:
               run utp/ut-lstit.p (input-output cLista1).
               assign c-carteira:list-item-pairs = cLista1.
           end.
       &else 
           /* Banking Connect */
           if l-banking-connect and l-banking-checked then do:
               &if "{&mgadm_version}" >= "2.04" &then 
                   assign c-carteira-banking    = {varinc/var00181.i 03}.
                   assign c-carteira:list-items = c-carteira-banking.
               &endif
           end.
           else
               assign c-carteira:list-items = cLista1. 
       &endif    

       /* Banking Connect */
       if l-banking-connect and l-banking-checked then do:
          &if "{&mgadm_version}" >= "2.04" &then 
              assign c-carteira:screen-value = {varinc/var00181.i 04 1}.
          &endif
       end.
       else do:
           case input portador.cod-febraban:             
               when 001 then assign c-carteira:screen-value = {varinc/var00076.i 04 1}.
               when 004 then assign c-carteira:screen-value = {varinc/var00033.i 04 1}.
               when 033 then assign c-carteira:screen-value = {varinc/var00113.i 04 1}.
               when 041 then assign c-carteira:screen-value = {varinc/var00085.i 04 1}.                                                          
               when 230 then assign c-carteira:screen-value = {varinc/var00101.i 04 1}.                                                          
               when 231 then assign c-carteira:screen-value = {varinc/var00063.i 04 1}.
               when 237 then assign c-carteira:screen-value = {varinc/var00077.i 04 1}.
               when 275 or when 356 then c-carteira:screen-value = {varinc/var00078.i 04 1}.
               when 341 then assign c-carteira:screen-value = {varinc/var00079.i 04 1}.                                                          
               when 399 then assign c-carteira:screen-value = {varinc/var00082.i 04 1}.                                                          
               when 409 then assign c-carteira:screen-value = {varinc/var00084.i 04 1}.                                                          
               when 422 then assign c-carteira:screen-value = {varinc/var00081.i 04 1}.                                                          
               when 479 then assign c-carteira:screen-value = {varinc/var00093.i 04 1}.                                                          
               when 353 then assign c-carteira:screen-value = {varinc/var00154.i 04 1}.                                                          
               when 641 then assign c-carteira:screen-value = {varinc/var00141.i 04 1}.
               when 104 then assign c-carteira:screen-value = {varinc/var00097.i 04 1}.                                                          
               when 291 then assign c-carteira:screen-value = {varinc/var00099.i 04 1}.                                                          
               when 745 then assign c-carteira:screen-value = {varinc/var00116.i 04 1}.                                                          
               when 320 then assign c-carteira:screen-value = {varinc/var00118.i 04 1}.                                                          
               when 392 then assign c-carteira:screen-value = {varinc/var00120.i 04 1}.                                                          
               when 347 then assign c-carteira:screen-value = {varinc/var00168.i 04 1}.                                                          
               when 215 then assign c-carteira:screen-value = {varinc/var00124.i 04 1}.
               when 008 then assign c-carteira:screen-value = {varinc/var00134.i 04 1}.                                                           
               when 038 then assign c-carteira:screen-value = {varinc/var00128.i 04 1}.                                                           
               when 244 then assign c-carteira:screen-value = {varinc/var00132.i 04 1}.                                                           
               when 394 then assign c-carteira:screen-value = {varinc/var00130.i 04 1}.                                                           
               when 224 then assign c-carteira:screen-value = {varinc/var00135.i 04 1}.
               when 389 then
                             if  l-mercantil then
                                 assign c-carteira:screen-value = {varinc/var00160.i 04 1}.
               when 346 then assign c-carteira:screen-value = {varinc/var00161.i 04 1}.
               when 351 then assign c-carteira:screen-value = {varinc/var00134.i 04 1}.
               when 634 then assign c-carteira:screen-value = {varinc/var00151.i 04 1}.
               when 424 then
                             if  l-sant424 then
                                 assign c-carteira:screen-value = {varinc/var00165.i 04 1}.
               when 456 then assign c-carteira:screen-value = {varinc/var00143.i 04 1}.
               when 453 then 
                             /* busca o valor do portador.emite-bloq na wier v04ad209 *
                              * 1 - quando a empresa que emite o bloqueto             *
                              * 2 -  quando o banco emite o bloqueto                  */                                                                                 
                             if i-emite-bloq  = 1  then
                                 assign c-carteira:screen-value = {varinc/var00144.i 04 1}.
                             else  
                                 assign c-carteira:screen-value = {varinc/var00144.i 04 1}. 
               when 027 then assign c-carteira:screen-value = {varinc/var00147.i 04 1}.
               otherwise 
                        assign c-carteira:screen-value = ""
                               portador.cod-carteira:screen-value = ""
                               c-especie:screen-value  = ""
                               c-esp-cob-esc:screen-value = "". 
           end.
       end.
end.
apply 'value-changed' to c-especie.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-vendor V-table-Win 
PROCEDURE pi-consiste-vendor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&FRAME-NAME}:
    assign c-especie:sensitive = yes
           fi-moeda:sensitive  = yes
           mgadm.portador.usa-inter:sensitive = no.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display V-table-Win 
PROCEDURE pi-display :
/*------------------------------------------------------------------------------
    Purpose:     
    Parameters:  <none>
    Notes:       
------------------------------------------------------------------------------*/

     do  with frame {&frame-name}:
        assign fi-variacao:screen-value  = "000"
               fi-moeda:screen-value     = "000"
               fi-contrato:screen-value  = "000000000"
               fi-faixa-num:screen-value = "000000"
               fi-convenio:screen-value  = ""
               fi-usu-cobr:screen-value  = "000"
               tg-agencia:checked        = no
               tg-coligada:checked       = no
               fi-usu-cobr:format        in frame {&FRAME-NAME} = "999"
               fi-faixa-num:format       in frame {&FRAME-NAME} = "999,999"
               fi-contrato:format        in frame {&FRAME-NAME} = "999999999"
               fi-convenio:format        in frame {&FRAME-NAME} = "X(16)"
               fi-usu-cobr:LABEL         in frame {&FRAME-NAME} = "Usu rio Cobran‡a" 
               fi-faixa-num:LABEL        in frame {&FRAME-NAME} = "Faixa Num‚rica Inicial"
               fi-contrato:LABEL         in frame {&FRAME-NAME} = "Contrato"
               fi-convenio:LABEL         in frame {&FRAME-NAME} = "N£mero Convˆnio".

        if input frame {&FRAME-NAME} portador.cod-febraban = 001 
        or input frame {&FRAME-NAME} portador.cod-febraban = 353 
        or input frame {&FRAME-NAME} portador.cod-febraban = 008  
        or input frame {&FRAME-NAME} portador.cod-febraban = 033  
        or input frame {&FRAME-NAME} portador.cod-febraban = 351 
        or input frame {&FRAME-NAME} portador.cod-febraban = 231
        or input frame {&FRAME-NAME} portador.cod-febraban = 275
        or input frame {&FRAME-NAME} portador.cod-febraban = 356
        or input frame {&FRAME-NAME} portador.cod-febraban = 320
        or input frame {&FRAME-NAME} portador.cod-febraban = 341
        or input frame {&FRAME-NAME} portador.cod-febraban = 389
        or input frame {&FRAME-NAME} portador.cod-febraban = 399
        or input frame {&FRAME-NAME} portador.cod-febraban = 409
        or input frame {&FRAME-NAME} portador.cod-febraban = 422 
        or input frame {&FRAME-NAME} portador.cod-febraban = 230 
        or input frame {&FRAME-NAME} portador.cod-febraban = 215 
        or input frame {&FRAME-NAME} portador.cod-febraban = 291 
        or input frame {&FRAME-NAME} portador.cod-febraban = 394 
        or input frame {&FRAME-NAME} portador.cod-febraban = 641 
        or input frame {&FRAME-NAME} portador.cod-febraban = 224 
        or input frame {&FRAME-NAME} portador.cod-febraban = 104 
        or input frame {&FRAME-NAME} portador.cod-febraban = 27  
        or input frame {&FRAME-NAME} portador.cod-febraban = 392 
        or input frame {&FRAME-NAME} portador.cod-febraban = 634 
        or input frame {&FRAME-NAME} portador.cod-febraban = 424 
        or input frame {&FRAME-NAME} portador.cod-febraban = 38  
        or input frame {&FRAME-NAME} portador.cod-febraban = 347 
        or input frame {&FRAME-NAME} portador.cod-febraban = 479 
        or input frame {&FRAME-NAME} portador.cod-febraban = 244 
        or input frame {&FRAME-NAME} portador.cod-febraban = 346 
        or input frame {&FRAME-NAME} portador.cod-febraban = 004 
        or input frame {&FRAME-NAME} portador.cod-febraban = 453 
        or input frame {&FRAME-NAME} portador.cod-febraban = 745 
        or input frame {&FRAME-NAME} portador.cod-febraban = 456 
        or input frame {&FRAME-NAME} portador.cod-febraban = 41  then do:  
            assign cb-caracter:hidden in frame {&FRAME-NAME} = no.

            if substring(c-complemento,45,3) = "" then 
                assign cb-caracter:screen-value in frame {&FRAME-NAME} = "   ".
            else
                assign cb-caracter:screen-value in frame {&FRAME-NAME} = substring(c-complemento,45,3).

        end.
        else 
            assign cb-caracter:hidden in frame {&FRAME-NAME} = yes.

        if (input frame {&FRAME-NAME} portador.cod-febraban = 291 
        or  input frame {&FRAME-NAME} portador.cod-febraban = 999) /* BCN e ALFA - Vendor */
            and i-modalidade = 7 then do:
        end.
        else do:
            if portador.usa-inter:checked in frame {&FRAME-NAME} = yes then do:
               /* Banking Connect */
               if l-banking-connect and l-banking-checked then do:
                   &if "{&mgadm_version}" >= "2.04" &then 
                       {cdp/cd0901.i1 "var00181.i" "var00182.i"}.
                   &endif
               end.
               else do:
                   {cdp/cd0901.i1 "var00115.i" "var00126.i"}.
               end.

               if input frame {&FRAME-NAME} c-esp-cob-esc = "" then do:
                  &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                       /* Banking Connect */
                       if l-banking-connect and l-banking-checked then do:
                           &if "{&mgadm_version}" >= "2.04" &then 
                               assign c-carteira-banking = {varinc/var00181.i 03}
                                      c-especie-banking  = {varinc/var00182.i 03}.
                               run utp/ut-lstit.p (input-output c-carteira-banking).
                               run utp/ut-lstit.p (input-output c-especie-banking).
                               assign c-carteira:list-item-pairs = c-carteira-banking
                                      c-especie:list-item-pairs  = c-especie-banking.
                           &endif
                       end.
                       else do:
                           assign cLista1 = {varinc/var00115.i 03}
                                  cLista2 = {varinc/var00126.i 03}.
                           run utp/ut-lstit.p (input-output cLista1).
                           run utp/ut-lstit.p (input-output cLista2).
                           assign c-carteira:list-item-pairs   = cLista1
                                  c-especie:list-item-pairs    = cLista2. 
                       end.
                  &else
                       /* Banking Connect */
                       if l-banking-connect and l-banking-checked then do:
                           &if "{&mgadm_version}" >= "2.04" &then 
                               assign c-carteira:list-items   = {varinc/var00181.i 03}
                                      c-especie:list-items    = {varinc/var00182.i 03}.
                           &endif
                       end.
                       else do:
                           assign c-carteira:list-items   = {varinc/var00115.i 03}
                                  c-especie:list-items    = {varinc/var00126.i 03}.
                       end.           
                  &endif                
               end.
               case input portador.cod-febraban:
                    when 275 or when 356 then
                          do: 
                              /* Banking Connect */
                              if l-banking-connect and l-banking-checked then do:
                                  &if "{&mgadm_version}" >= "2.04" &then 
                                      {cdp/cd0901.i1 "var00181.i" "var00182.i"}.
                                  &endif
                              end.
                              else do:
                                  {cdp/cd0901.i1 "var00078.i" "var00173.i"}.
                              end.
                              assign fi-contrato:screen-value = substring(c-complemento,1,9).
                              if  avail portador then do:
                                  if  portador.dec-2 = 2 then
                                      assign cb-tp-layout:screen-value = "Layout 20 Mensagens".                                           
                                  else
                                      assign cb-tp-layout:screen-value = "Layout 10 Mensagens".                                           
                              end.
                              else
                                  assign cb-tp-layout:screen-value = "Layout 10 Mensagens".

                          end.    
                    when 479 then
                             do:
                                assign fi-contrato:screen-value = substring(c-complemento,1,8). 
                                /* Banking Connect */
                                if l-banking-connect and l-banking-checked then do:
                                    &if "{&mgadm_version}" >= "2.04" &then 
                                        {cdp/cd0901.i1 "var00181.i" "var00182.i"}.
                                    &endif
                                end.
                                else do:
                                    {cdp/cd0901.i1 "var00093.i" "var00094.i"}.
                                end.
                             end.
               end.
            end.
            else do:
               if input frame {&FRAME-NAME} portador.cod-febraban <> 0 then do:
                   /* Banking Connect */
                   if l-banking-connect and l-banking-checked then do:
                       &if "{&mgadm_version}" >= "2.04" &then 
                           {cdp/cd0901.i1 "var00181.i" "var00182.i"}.
                           case input portador.cod-febraban:
                                 when 001 then do: 
                                     if i-modalidade = 7 then
                                         &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then assign c-especie:list-item-pairs in frame {&frame-name} = "," &else assign c-especie:list-items in frame {&frame-name} = "" &endif.
                                     assign fi-variacao:screen-value  = substring(c-complemento,1,3)
                                            fi-faixa-num:screen-value = substring(c-complemento,4,6)
                                            fi-convenio:screen-value  = substring(c-complemento,10,9). 
                                     assign tg-coligada:checked = if int(substring(c-complemento,4,6)) <> 0 then yes else no.
                                 end.
                                 when 004 then
                                          do: 
                                            assign fi-usu-cobr:screen-value = substring(c-complemento,1,3).
                                          end.
                                 when 033 then
                                          do:
                                              ASSIGN fi-usu-cobr:LABEL            IN FRAME {&FRAME-NAME} = "Cod Cedente"
                                                     fi-usu-cobr:FORMAT           IN FRAME {&FRAME-NAME} = "9999999"
                                                     fi-usu-cobr:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,1,7).
                                          end.
                                 when 275 or when 356 then
                                          do: 
                                              assign fi-contrato:screen-value = substring(c-complemento,1,9)
                                                     fi-moeda:screen-value in frame {&frame-name} = SUBSTRING(portador.complemento,15,3).

                                              if  avail portador then do:
                                                  if  portador.dec-2 = 2 then
                                                      assign cb-tp-layout:screen-value = "Layout 20 Mensagens".                                           
                                                  else
                                                      assign cb-tp-layout:screen-value = "Layout 10 Mensagens".                                           
                                              end.
                                              else
                                                  assign cb-tp-layout:screen-value = "Layout 10 Mensagens".
                                          end.    
                                 when 341 then
                                          do: 
                                               assign fi-variacao:screen-value = substring(c-complemento,1,3).
                                               assign tg-agencia:checked = if substring(c-complemento,4,1) = "S" then yes else no.
                                          end.
                                 when 399 then
                                          do:
                                               assign fi-convenio:screen-value = substring(c-complemento,1,16).
                                          end.
                                 when 409 then
                                          do:
                                             assign fi-moeda:screen-value    = substring(c-complemento,1,3).
                                          end. 
                                 when 479 then
                                          do:
                                             assign fi-contrato:screen-value = substring(c-complemento,1,8). 
                                          end.
                                 when 392 then
                                          do: 
                                            assign fi-convenio:screen-value = substring(c-complemento,1,5)
                                                   fi-moeda:screen-value    = substring(c-complemento,6,3).
                                          end.
                                 when 320 then do: 
                                             {utp/ut-liter.i Agˆncia_Cobradora}
                                             assign fi-convenio:label        = return-value
                                                    fi-convenio:screen-value = substring(c-complemento,1,5).
                                          end.
                                 when 389 then
                                          do:
                                          if  l-mercantil then
                                          end.
                                 otherwise 
                                     RUN pi-display02(INPUT portador.cod-febraban).
                           end.
                       &endif
                   end.
                   else do:
                       case input portador.cod-febraban:
                             when 001 then do: 
                                 {cdp/cd0901.i1 "var00076.i" "var00080.i"}.
                                 if i-modalidade = 7 then
                                     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then assign c-especie:list-item-pairs in frame {&frame-name} = "," &else assign c-especie:list-items in frame {&frame-name} = "" &endif.
                                 assign fi-variacao:screen-value  = substring(c-complemento,1,3)
                                        fi-faixa-num:screen-value = substring(c-complemento,4,6)
                                        fi-convenio:screen-value  = substring(c-complemento,10,9). 
                                 assign tg-coligada:checked = if int(substring(c-complemento,4,6)) <> 0 then yes else no.
                             end.
                             when 004 then
                                      do: {cdp/cd0901.i1 "var00033.i" "var00047.i"}.
                                           assign fi-usu-cobr:screen-value = substring(c-complemento,1,3).
                                      end.
                             when 008 then
                                      do: {cdp/cd0901.i1 "var00134.i" "var00127.i"}.
                                      end.
                             when 033 then
                                      do: 
                                          {cdp/cd0901.i2 "var00113.i" "var00114.i"}.

                                           ASSIGN fi-usu-cobr:LABEL            IN FRAME {&FRAME-NAME} = "Cod Cedente"
                                                  fi-usu-cobr:FORMAT           IN FRAME {&FRAME-NAME} = "9999999"
                                                  fi-usu-cobr:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,1,7).
                                      end.
                             when 038 then
                                      do: {cdp/cd0901.i1 "var00128.i" "var00129.i"}.
                                      end.
                             when 041 then 
                                      do: {cdp/cd0901.i1 "var00085.i" "var00086.i"}.
                                      end.
                             when 230 then 
                                      do: {cdp/cd0901.i1 "var00101.i" "var00100.i"}.
                                      end.
                             when 231 then
                                      do: {cdp/cd0901.i1 "var00063.i" "var00056.i"}.
                                      end.
                             when 237 then
                                      do: {cdp/cd0901.i1 "var00077.i" "var00080.i"}.
                                      end.
                             when 275 or when 356 then
                                      do: 
                                          {cdp/cd0901.i1 "var00078.i" "var00173.i"}.
                                          assign fi-contrato:screen-value = substring(c-complemento,1,9)
                                                 fi-moeda:screen-value in frame {&frame-name} = SUBSTRING(portador.complemento,15,3).

                                          if  avail portador then do:
                                              if  portador.dec-2 = 2 then
                                                  assign cb-tp-layout:screen-value = "Layout 20 Mensagens".                                           
                                              else
                                                  assign cb-tp-layout:screen-value = "Layout 10 Mensagens".                                           
                                          end.
                                          else
                                              assign cb-tp-layout:screen-value = "Layout 10 Mensagens".
                                      end.    
                             when 341 then
                                      do: 
                                          assign fi-moeda:screen-value = substring(c-complemento,1,3).
                                          assign tg-agencia:checked = if substring(c-complemento,4,1) = "S" then yes else no.
                                          {cdp/cd0901.i1 "var00079.i" "var00172.i"}.
                                      end.
                             when 399 then
                                      do: {cdp/cd0901.i1 "var00082.i" "var00153.i"}.
                                           assign fi-convenio:screen-value = substring(c-complemento,1,16).
                                      end.
                             when 409 then
                                      do:
                                         assign fi-moeda:screen-value    = substring(c-complemento,1,3).
                                         {cdp/cd0901.i1 "var00084.i" "var00080.i"}.
                                      end. 
                             when 422 then
                                      do: {cdp/cd0901.i1 "var00081.i" "var00080.i"}.
                                      end.
                             when 479 then
                                      do:
                                         assign fi-contrato:screen-value = substring(c-complemento,1,8). 
                                         {cdp/cd0901.i1 "var00093.i" "var00094.i"}.
                                      end.
                             when 104 then
                                      do: {cdp/cd0901.i1 "var00097.i" "var00098.i"}.
                                      end.
                             when 291 then
                                      do: {cdp/cd0901.i1 "var00099.i" "var00133.i"}.
                                      end.
                             when 392 then
                                      do: {cdp/cd0901.i1 "var00120.i" "var00121.i"}.
                                        assign fi-convenio:screen-value = substring(c-complemento,1,5)
                                               fi-moeda:screen-value    = substring(c-complemento,6,3).
                                      end.
                             when 745 then
                                      do: {cdp/cd0901.i1 "var00116.i" "var00117.i"}.
                                      end.
                             when 320 then do: 
                                         {cdp/cd0901.i1 "var00118.i" "var00119.i"}.
                                         {utp/ut-liter.i Agˆncia_Cobradora}
                                         assign fi-convenio:label        = return-value
                                                fi-convenio:screen-value = substring(c-complemento,1,5).
                                      end.
                             when 347 then
                                      do: {cdp/cd0901.i1 "var00168.i" "var00169.i"}.
                                      end.
                             when 215 then
                                      do: {cdp/cd0901.i1 "var00124.i" "var00125.i"}.
                                      end.
                             when 244 then
                                      do: {cdp/cd0901.i1 "var00132.i" "var00133.i"}.
                                      end.
                             when 394 then
                                      do: {cdp/cd0901.i1 "var00130.i" "var00131.i"}.
                                      end.
                             when 224 then
                                      do: {cdp/cd0901.i1 "var00135.i" "var00136.i"}.
                                      end.
                             when 389 then
                                      do:
                                      if  l-mercantil then
                                          {cdp/cd0901.i1 "var00160.i" "var00159.i"}.
                                      end.
                             otherwise 
                                 RUN pi-display02(INPUT portador.cod-febraban).
                       end.
                end.
               end.
            end.
       end.
       if (input frame {&FRAME-NAME} portador.cod-febraban = 275 or
           input frame {&FRAME-NAME} portador.cod-febraban = 356 or
           input frame {&FRAME-NAME} portador.cod-febraban = 237 or
           input frame {&FRAME-NAME} portador.cod-febraban = 999)
           and i-modalidade = 7 then do:
           if input frame {&FRAME-NAME} portador.cod-febraban = 237 then
              disp " " @ mgadm.portador.intervalo-head.   
           else
              disp " " @ mgadm.portador.intervalo-head
                   " " @ mgadm.portador.intervalo-det
                   " " @ fi-contrato.    

           assign fi-contrato:screen-value = substring(c-complemento,1,9).
       end.
       else
          assign BUTTON-1:sensitive = no.

       if  input frame {&FRAME-NAME} portador.cod-febraban = 453 then do:
           if input frame {&frame-name} portador.cod-carteira = "2"
           or input frame {&frame-name} portador.cod-carteira = "5"
           or input frame {&frame-name} portador.cod-carteira = "6" then
              assign fi-convenio:screen-value   = portador.complemento.
           else
              assign fi-convenio:screen-value in frame {&frame-name} = "".
       end.

       if  input frame {&FRAME-NAME} portador.cod-febraban = 999 and i-modalidade = 7 then
           assign fi-convenio:screen-value = substring(c-complemento,1,9).

       if  input frame {&FRAME-NAME} portador.cod-febraban = 001 /* BB   - Vendor */
       and i-modalidade = 7 then do:
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                /* Banking Connect */
                if l-banking-connect and l-banking-checked then do:
                    &if "{&mgadm_version}" >= "2.04" &then                
                        assign c-carteira-banking = ",".
                        run utp/ut-lstit.p (input-output c-especie-banking).
                        assign c-especie:list-item-pairs  = c-especie-banking.
                    &endif
                end.
                else do:
                    assign cLista1 = ",".
                    run utp/ut-lstit.p (input-output cLista1).  
                    assign c-especie:list-item-pairs  = cLista1.
                end.
           &else
                assign c-especie:list-items  = "". 
           &endif    
           assign c-especie:screen-value     = ""
                  c-esp-cob-esc:screen-value = ""
                  fi-variacao:screen-value   = substring(c-complemento,1,3)
                  fi-faixa-num:screen-value  = substring(c-complemento,4,6)
                  fi-convenio:screen-value   = substring(c-complemento,10,9).
       end.

       if  input frame {&FRAME-NAME} portador.cod-febraban = 399 /* HSBC - Vendor */
       and i-modalidade = 7 then do:
           &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
                /* Banking Connect */
                if l-banking-connect and l-banking-checked then do:
                    &if "{&mgadm_version}" >= "2.04" &then 
                        assign c-carteira-banking = ",".
                        run utp/ut-lstit.p (input-output c-carteira-banking).
                        run utp/ut-lstit.p (input-output c-especie-banking).
                        assign c-carteira:list-item-pairs = c-carteira-banking
                               c-especie:list-item-pairs  = c-especie-banking.
                    &endif
                end.
                else do:
                    assign cLista1 = ",".
                    run utp/ut-lstit.p (input-output cLista1).  
                    assign c-especie:list-item-pairs  = cLista1
                           c-carteira:list-item-pairs = cLista1.
                end.
           &else
                assign c-especie:list-items  = ""
                       c-carteira:list-items = "". 
           &endif
           assign portador.cod-carteira:screen-value   = ""
                  c-carteira:screen-value              = ""
                  c-esp-cob-esc:screen-value           = ""
                  c-especie:screen-value               = ""
                  portador.intervalo-head:screen-value = " "
                  portador.intervalo-det:screen-value  = " ".
       end.


    end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-display02 V-table-Win 
PROCEDURE pi-display02 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER i-param LIKE portador.cod-febraban.
do  with frame {&frame-name}:
    /* Banking Connect */  
    if l-banking-connect and l-banking-checked then do:
        &if "{&mgadm_version}" >= "2.04" &then 
            {cdp/cd0901.i1 "var00181.i" "var00182.i"}.
            case i-param:
                 when 641 then do: 
                     ASSIGN fi-usu-cobr:LABEL            IN FRAME {&FRAME-NAME} = "Cod Cedente"
                            fi-faixa-num:LABEL           IN FRAME {&FRAME-NAME} = "Produto"
                            fi-contrato:LABEL            IN FRAME {&FRAME-NAME} = "Sub Produto"
                            fi-convenio:LABEL            IN FRAME {&FRAME-NAME} = "Tp layout Cedente"
                            fi-usu-cobr:FORMAT           IN FRAME {&FRAME-NAME} = "99999"
                            fi-faixa-num:FORMAT          IN FRAME {&FRAME-NAME} = "99"
                            fi-contrato:FORMAT           IN FRAME {&FRAME-NAME} = "9999"
                            fi-convenio:FORMAT           IN FRAME {&FRAME-NAME} = "X(01)"
                            fi-usu-cobr:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,1,5)
                            fi-faixa-num:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,6,2)
                            fi-contrato:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,8,4)
                            fi-convenio:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,12,1).
                 end.
                 when 453 then /* RURAL */ do:
                      /* busca o valor do portador.emite-bloq na viewer v04ad209 *
                      * 1 - quando a empresa que emite o bloqueto             *
                      * 2 - quando o banco emite o bloqueto                   */
                     if h_v04ad209 <> ? then 
                         run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
                     else do:
                         if avail portador then
                             assign i-emite-bloq = portador.emite-bloq.
                      end.
                      if input frame {&frame-name} portador.cod-carteira = "2"
                      or input frame {&frame-name} portador.cod-carteira = "5"
                      or input frame {&frame-name} portador.cod-carteira = "6" then
                         assign fi-convenio:screen-value   = portador.complemento.
                      else
                         assign fi-convenio:screen-value in frame {&frame-name} = "".
                      end.
                      when 027 then do:
                          if h_v04ad209 <> ? then 
                             run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
                          else do:
                              if avail portador then assign i-emite-bloq = portador.emite-bloq.
                          end.
                      end.
            end case.
        &endif
    end.
    else do:
        case i-param:
            when 346 then do: 
                 {cdp/cd0901.i1 "var00161.i" "var00162.i"}.
             end.  
             when 351 then do:  
                 {cdp/cd0901.i1 "var00134.i" "var00127.i"}.
             end.
             when 353 then do: 
                 {cdp/cd0901.i1 "var00154.i" "var00174.i"}.
             end.
             when 424 then do:
                 if  l-sant424 then
                     {cdp/cd0901.i1 "var00165.i" "var00164.i"}.
             end.
             when 456 then do: 
                 {cdp/cd0901.i1 "var00143.i" "var00142.i"}.
             end.
             when 641 then do: 
                 {cdp/cd0901.i1 "var00141.i" "var00140.i"}.
                 ASSIGN fi-usu-cobr:LABEL            IN FRAME {&FRAME-NAME} = "Cod Cedente"
                        fi-faixa-num:LABEL           IN FRAME {&FRAME-NAME} = "Produto"
                        fi-contrato:LABEL            IN FRAME {&FRAME-NAME} = "Sub Produto"
                        fi-convenio:LABEL            IN FRAME {&FRAME-NAME} = "Tp layout Cedente"
                        fi-usu-cobr:FORMAT           IN FRAME {&FRAME-NAME} = "99999"
                        fi-faixa-num:FORMAT          IN FRAME {&FRAME-NAME} = "99"
                        fi-contrato:FORMAT           IN FRAME {&FRAME-NAME} = "9999"
                        fi-convenio:FORMAT           IN FRAME {&FRAME-NAME} = "X(01)"
                        fi-usu-cobr:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,1,5)
                        fi-faixa-num:SCREEN-VALUE    IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,6,2)
                        fi-contrato:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,8,4)
                        fi-convenio:SCREEN-VALUE     IN FRAME {&FRAME-NAME} = SUBSTR(portador.complemento,12,1).
             end.
             when 453 then /* RURAL */ do:
                  /* busca o valor do portador.emite-bloq na viewer v04ad209 *
                  * 1 - quando a empresa que emite o bloqueto             *
                  * 2 - quando o banco emite o bloqueto                   */
                 if h_v04ad209 <> ? then 
                     run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
                 else do:
                     if avail portador then
                         assign i-emite-bloq = portador.emite-bloq.
                  end.
                  if i-emite-bloq  = 1  then do:
                      {cdp/cd0901.i1 "var00144.i" "var00145.i"}.
                  end.
                  else  do:
                      {cdp/cd0901.i1 "var00144.i" "var00146.i"}.
                  end.
                  if input frame {&frame-name} portador.cod-carteira = "2"
                  or input frame {&frame-name} portador.cod-carteira = "5"
                  or input frame {&frame-name} portador.cod-carteira = "6" then
                     assign fi-convenio:screen-value   = portador.complemento.
                  else
                     assign fi-convenio:screen-value in frame {&frame-name} = "".
                  end.
                  when 634 then do: 
                      {cdp/cd0901.i1 "var00151.i" "var00152.i"}.
                  end.
                  when 027 then do:
                      if h_v04ad209 <> ? then 
                         run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
                      else do:
                          if avail portador then assign i-emite-bloq = portador.emite-bloq.
                      end.

                      if i-emite-bloq  = 1  then do:
                         {cdp/cd0901.i1 "var00147.i" "var00149.i"}.
                      end.
                      else do:
                          {cdp/cd0901.i1 "var00147.i" "var00148.i"}.
                      end.
                  end.
                  otherwise do: 
                      {cdp/cd0901.i1 "var00080.i" "var00080.i"}.
                  end.
        end case.
    end.
END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-esp-cob V-table-Win 
PROCEDURE pi-esp-cob :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
do with frame {&frame-name}:


     case input portador.cod-febraban: 
         when 001 then do: 
             if portador.modalidade = 7 then
                 assign cLista1    = &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then "," &else "" &endif.
             else
                 assign cLista1    = {varinc/var00080.i 03}.
         end.
         when 004 then assign cLista1    = {varinc/var00047.i 03}.
         when 033 then assign cLista1    = {varinc/var00114.i 03}.
         when 041 then assign cLista1    = {varinc/var00086.i 03}.
         when 230 then assign cLista1    = {varinc/var00100.i 03}.
         when 231 then assign cLista1    = {varinc/var00056.i 03}.
         when 237 then assign cLista1    = {varinc/var00080.i 03}.
         when 275 or when 356 then assign cLista1    = {varinc/var00173.i 03}.
         when 341 then assign cLista1    = {varinc/var00172.i 03}.
         when 399 then assign cLista1    = {varinc/var00153.i 03}.
         when 409 then assign cLista1    = {varinc/var00080.i 03}.
         when 422 then assign cLista1    = {varinc/var00080.i 03}.
         when 479 then assign cLista1    = {varinc/var00094.i 03}.
         when 353 then assign cLista1    = {varinc/var00174.i 03}.
         when 641 then assign cLista1    = {varinc/var00140.i 03}.
         when 104 then assign cLista1    = {varinc/var00098.i 03}.
         when 291 then assign cLista1    = {varinc/var00133.i 03}.
         when 745 then assign cLista1    = {varinc/var00117.i 03}.
         when 320 then assign cLista1    = {varinc/var00119.i 03}.
         when 392 then assign cLista1    = {varinc/var00121.i 03}.
         when 347 then assign cLista1    = {varinc/var00169.i 03}.
         when 215 then assign cLista1    = {varinc/var00125.i 03}.
         when 008 then assign cLista1    = {varinc/var00127.i 03}.
         when 038 then assign cLista1    = {varinc/var00129.i 03}.
         when 244 then assign cLista1    = {varinc/var00133.i 03}.
         when 394 then assign cLista1    = {varinc/var00131.i 03}.
         when 224 then assign cLista1    = {varinc/var00136.i 03}.
         when 389 then if  l-mercantil then assign cLista1    = {varinc/var00159.i 03}.
         when 346 then assign cLista1    = {varinc/var00162.i 03}.
         when 351 then assign cLista1    = {varinc/var00127.i 03}.
         when 634 then assign cLista1    = {varinc/var00152.i 03}.
         when 424 then if  l-sant424 then assign cLista1    = {varinc/var00164.i 03}.
         when 456 then assign cLista1    = {varinc/var00142.i 03}.
         when 453 then 
                       if i-emite-bloq  = 1  then 
                          assign cLista1    = {varinc/var00145.i 03}.
                       else assign cLista1    = {varinc/var00146.i 03}. 
         when 027 then 
                       if i-emite-bloq  = 1  then
                          assign   cLista1    = {varinc/var00149.i 03}.
                       else  
                          assign   cLista1    = {varinc/var00148.i 03}. 
         otherwise
              &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then 
                  assign cLista1 = ","
                         cLista2 =  ",".
              &else
                  assign cLista1 = ""
                         cLista2 = "".
              &endif
     end.     

         &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then 
             /* Banking Connect */
             if l-banking-connect and l-banking-checked then do:
                 &if "{&mgadm_version}" >= "2.04" &then 
                      run utp/ut-lstit.p (input-output c-especie-banking).
                      assign c-especie:list-item-pairs IN FRAME {&FRAME-NAME} = c-especie-banking.
                  &endif
             end.
             else do:
                 run utp/ut-lstit.p (input-output cLista1).
                 assign c-especie:list-item-pairs =  cLista1.
             end.
         &else 
             /* Banking Connect */
             if l-banking-connect and l-banking-checked then do:
                 &if "{&mgadm_version}" >= "2.04" &then 
                     assign c-especie-banking    = {varinc/var00182.i 03}. 
                     assign c-especie:list-items = c-especie-banking.
                 &endif
             end.
             else
                 assign c-especie:list-items = cLista1.
         &endif

         /* Banking Connect */
         if l-banking-connect and l-banking-checked then do:
             &if "{&mgadm_version}" >= "2.04" &then 
                 assign c-especie:screen-value  = {varinc/var00182.i 04 1}.
             &endif
         end.
         else do:
             case input portador.cod-febraban: 
                when 001 then do:
                    if portador.modalidade = 7 then
                        assign c-especie:screen-value = "".
                    else
                        assign c-especie:screen-value  = {varinc/var00080.i 04 1}.
                end.
                when 004 then assign c-especie:screen-value  = {varinc/var00047.i 04 1}.
                when 033 then assign c-especie:screen-value  = {varinc/var00114.i 04 1}.
                when 041 then assign c-especie:screen-value  = {varinc/var00086.i 04 1}.
                when 230 then assign c-especie:screen-value  = {varinc/var00100.i 04 1}.
                when 231 then assign c-especie:screen-value  = {varinc/var00056.i 04 1}.
                when 237 then assign c-especie:screen-value  = {varinc/var00080.i 04 1}.
                when 275 or when 356 then c-especie:screen-value  = {varinc/var00173.i 04 1}.
                when 341 then assign c-especie:screen-value  = {varinc/var00172.i 04 1}.
                when 399 then assign c-especie:screen-value  = {varinc/var00153.i 04 1}.
                when 409 then assign c-especie:screen-value  = {varinc/var00080.i 04 1}.
                when 422 then assign c-especie:screen-value  = {varinc/var00080.i 04 1}.
                when 479 then assign c-especie:screen-value  = {varinc/var00094.i 04 1}.
                when 353 then assign c-especie:screen-value  = {varinc/var00174.i 04 1}.
                when 641 then assign c-especie:screen-value  = {varinc/var00140.i 04 1}.
                when 104 then assign c-especie:screen-value  = {varinc/var00098.i 04 1}.
                when 291 then assign c-especie:screen-value  = {varinc/var00133.i 04 1}.
                when 745 then assign c-especie:screen-value  = {varinc/var00117.i 04 1}.
                when 320 then assign c-especie:screen-value  = {varinc/var00119.i 04 1}.
                when 392 then assign c-especie:screen-value  = {varinc/var00121.i 04 1}.
                when 347 then assign c-especie:screen-value  = {varinc/var00169.i 04 1}.                                                            
                when 215 then assign c-especie:screen-value  = {varinc/var00125.i 04 1}.                                                            
                when 008 then assign c-especie:screen-value  = {varinc/var00127.i 04 1}.                                                            
                when 038 then assign c-especie:screen-value  = {varinc/var00129.i 04 1}.                                                            
                when 244 then assign c-especie:screen-value  = {varinc/var00133.i 04 1}.                                                            
                when 394 then assign c-especie:screen-value  = {varinc/var00131.i 04 1}.                                                            
                when 224 then assign c-especie:screen-value  = {varinc/var00136.i 04 1}.
                when 389 then 
                              if  l-mercantil then
                                  assign c-especie:screen-value  = {varinc/var00159.i 04 1}.
                when 346 then assign c-especie:screen-value  = {varinc/var00162.i 04 1}.                                                            
                when 351 then assign c-especie:screen-value  = {varinc/var00127.i 04 1}.                                                            
                when 634 then assign c-especie:screen-value  = {varinc/var00152.i 04 1}.
                when 424 then 
                              if  l-sant424 then
                                  assign c-especie:screen-value  = {varinc/var00164.i 04 1}.
                when 456 then assign c-especie:screen-value  = {varinc/var00142.i 04 1}.
                when 453 then /* busca o valor do portador.emite-bloq na wier v04ad209 *
                               * 1 - quando a empresa que emite o bloqueto             *
                               * 2 -  quando o banco emite o bloqueto                  */                                                                                 
                              if i-emite-bloq  = 1  then
                                  assign c-especie:screen-value  = {varinc/var00145.i 04 1}.
                              else  
                                  assign c-especie:screen-value  = {varinc/var00146.i 04 1}. 
                when 027 then    /* busca o valor do portador.emite-bloq na wier v04ad209 *
                                  * 1 - quando a empresa que emite o bloqueto             *
                                  * 2 -  quando o banco emite o bloqueto                  */
                              if i-emite-bloq  = 1  then
                                 assign  c-especie:screen-value  = {varinc/var00149.i 04 1}.
                              else  
                                 assign c-especie:screen-value  = {varinc/var00148.i 04 1}. 
                otherwise  
                        assign c-carteira:screen-value = ""
                               portador.cod-carteira:screen-value = ""
                               c-especie:screen-value  = ""
                               c-esp-cob-esc:screen-value = "".
             end.
         end.
     end.

apply 'value-changed' to c-carteira.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita V-table-Win 
PROCEDURE pi-habilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  &if  defined(LIST-4) &then
      enable {&LIST-4} with frame {&frame-name}.
  &endif
  assign portador.cod-febraban:screen-value in frame {&frame-name} = "000".
  apply 'leave' to portador.cod-febraban.

   if i-modalidade = 7 then 
      assign c-especie:sensitive = yes
             fi-moeda:sensitive  = yes
              mgadm.portador.usa-inter:sensitive = no.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-convenio V-table-Win 
PROCEDURE pi-habilita-convenio :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  if  input frame {&frame-name} portador.cod-febraban = 453 then do: 
      if input frame {&frame-name} portador.cod-carteira = "2"
      or input frame {&frame-name} portador.cod-carteira = "5"
      or input frame {&frame-name} portador.cod-carteira = "6" then
         assign fi-convenio:sensitive in frame {&frame-name} = yes.
      else
         assign fi-convenio:sensitive in frame {&frame-name}    = no
                fi-convenio:screen-value in frame {&frame-name} = "".
  end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-handle V-table-Win 
PROCEDURE pi-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle  as handle no-undo.

assign h_v04ad209 = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter h-handle  as handle no-undo.

 assign h_v01ad209 = h-handle.


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

def input param p_v10ad209 as handle.

assign h_v10ad209 = p_v10ad209.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-banking-connect V-table-Win 
PROCEDURE pi-retorna-banking-connect :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input param l-retorna-banking-connect as logical no-undo.

    assign l-banking-checked = l-retorna-banking-connect.

    RUN local-initialize.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-cod-febraban V-table-Win 
PROCEDURE pi-retorna-cod-febraban :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param p-cod-febraban as int.

    assign p-cod-febraban = input frame {&FRAME-NAME} portador.cod-febraban.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
    Purpose:Validar a viewer     
    Parameters:  <none>
    Notes: NÆo fazer assign aqui. Nesta procedure
    devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
    ainda nÆo foi criado.       
------------------------------------------------------------------------------*/

    {include/i-vldfrm.i}

    run Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure, OUTPUT c-cd0901).                   
    assign wh-cd0901 = widget-handle(c-cd0901).

    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "usa-inter"). 
    if return-value = "no" and input frame {&frame-name} portador.cod-febraban <> 0 then do:
        if  input frame {&frame-name} portador.cod-febraban <>   1 and      /* Brasil         */
            input frame {&frame-name} portador.cod-febraban <>   4 and      /* Nordeste       */        
            input frame {&frame-name} portador.cod-febraban <>   8 and      /* Meridional     */
            input frame {&frame-name} portador.cod-febraban <>  27 and      /* BESC           */
            input frame {&frame-name} portador.cod-febraban <>  33 and      /* Banespa        */
            input frame {&frame-name} portador.cod-febraban <>  38 and      /* Banestado      */
            input frame {&frame-name} portador.cod-febraban <>  41 and      /* Banrisul       */
            input frame {&frame-name} portador.cod-febraban <> 104 and      /* C.E.F.         */
            input frame {&frame-name} portador.cod-febraban <> 215 and      /* America do Sul */
            input frame {&frame-name} portador.cod-febraban <> 224 and      /* Fibra          */
            input frame {&frame-name} portador.cod-febraban <> 230 and      /* Bandeirantes   */
            input frame {&frame-name} portador.cod-febraban <> 231 and      /* Boavista       */
            input frame {&frame-name} portador.cod-febraban <> 237 and      /* Bradesco       */
            input frame {&frame-name} portador.cod-febraban <> 244 and      /* Cidade         */
            input frame {&frame-name} portador.cod-febraban <> 275 and      /* Real           */
            input frame {&frame-name} portador.cod-febraban <> 356 and      /* Abn Amro Real  */
            input frame {&frame-name} portador.cod-febraban <> 291 and      /* B.C.N          */
            input frame {&frame-name} portador.cod-febraban <> 320 and      /* Bicbanco       */
            input frame {&frame-name} portador.cod-febraban <> 334 and      /* Economico      */
            input frame {&frame-name} portador.cod-febraban <> 341 and      /* Itau           */
            input frame {&frame-name} portador.cod-febraban <> 346 and      /* Frances        */
            input frame {&frame-name} portador.cod-febraban <> 347 and      /* Sudameris      */
            input frame {&frame-name} portador.cod-febraban <> 351 and      /* Bozano         */
            input frame {&frame-name} portador.cod-febraban <> 353 and      /* Bangeral       */
           (input frame {&frame-name} portador.cod-febraban <> 389 and      /* Mercantil do Brasil */
            l-mercantil) and
            input frame {&frame-name} portador.cod-febraban <> 394 and      /* B.M.C.         */
            input frame {&frame-name} portador.cod-febraban <> 399 and      /* Bamerindus     */
            input frame {&frame-name} portador.cod-febraban <> 409 and      /* Unibanco       */
            input frame {&frame-name} portador.cod-febraban <> 415 and      /* Nacional       */
            input frame {&frame-name} portador.cod-febraban <> 422 and      /* Safra          */
           (input frame {&frame-name} portador.cod-febraban <> 424 and      /* Santander Noroeste  */
            l-sant424)   and
            input frame {&frame-name} portador.cod-febraban <> 453 and      /* Rural          */
            input frame {&frame-name} portador.cod-febraban <> 456 and      /* Tokyo          */
            input frame {&frame-name} portador.cod-febraban <> 745 and      /* Citibank       */
            input frame {&frame-name} portador.cod-febraban <> 479 and      /* Boston         */
            input frame {&frame-name} portador.cod-febraban <> 641 then do: /* Excel          */
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U,
                               input 49, 
                               input "").
            run select-page in wh-cd0901 (3).
            apply "entry" to portador.cod-febraban.
            return "adm-error":U.
        end.
    end.

    if  input frame {&frame-name} portador.perc-part-dest > 100 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 272,
                           input "").
        run select-page in wh-cd0901 (3). 
        apply "entry" to portador.perc-part-dest.
        return "adm-error":U.
    end.

    find param-cr where param-cr.ep-codigo = i-ep-codigo-usuario no-lock no-error.
    if  avail param-cr and param-cr.usa-escrit = yes and
        input frame {&frame-name} portador.cod-febraban <> 0 then do:
        run utp/ut-msgs.p (input "show":U,
                           input 274, 
                           input "").                  
    end.

    if  input frame {&frame-name} portador.cod-febraban = 001 and
        input frame {&frame-name} fi-faixa-num < 900000       and
        tg-coligada:sensitive in frame {&frame-name} = yes    and
        tg-coligada:checked   in frame {&frame-name} = yes    then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, 
                           input 15641,
                           input "").
        run select-page in wh-cd0901 (3). 
        apply "entry" to fi-faixa-num.
        return "adm-error":U.
    end.

    if  input frame {&frame-name} portador.cod-febraban = 004 and
         input frame {&frame-name} fi-usu-cobr  = 0 then do:
         run utp/ut-msgs.p (input "show":U, 
                            input 1491,  
                            input fi-usu-cobr:label).
         run select-page in wh-cd0901 (3). 
         apply "entry" to fi-usu-cobr.
         return "adm-error":U.
    end.
    if  input frame {&frame-name} portador.cod-febraban = 033 and
         input frame {&frame-name} fi-usu-cobr  = 0 then do:
         run utp/ut-msgs.p (input "show":U, 
                            input 1491,  
                            input fi-usu-cobr:label).
         run select-page in wh-cd0901 (3). 
         apply "entry" to fi-usu-cobr.
         return "adm-error":U.
    end.


   if (input frame {&frame-name} portador.cod-febraban = 275
   or  input frame {&frame-name} portador.cod-febraban = 356 
   or  input frame {&frame-name} portador.cod-febraban = 237)
       and i-modalidade = 7 then
       assign BUTTON-1:sensitive in frame {&FRAME-NAME} = yes. 

   if  input frame {&FRAME-NAME} portador.cod-febraban = 27  then 
    do:
      /* busca o valor do portador.emite-bloq na wier v04ad209 *
       * 1 - quando a empresa que emite o bloqueto             *
       * 2 -  quando o banco emite o bloqueto                  */

      run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
      if ((i-emite-bloq  <> 1 ) and (lookup(c-esp-cob-esc:screen-value,"21,22,23,24,25,30,31,39") <> 0))
      or (( i-emite-bloq = 1 ) and  (lookup(c-esp-cob-esc:screen-value,"01,02,03,04,05,10,11,99") <> 0))    then
        do:   
          run utp/ut-msgs.p (input "show":U, 
                             input 18416,  
                             input "").
          run select-page in wh-cd0901 (4). 
          assign i-cod-febraban-ant = -1. 
          apply "leave" to portador.cod-febraban.
          apply "entry" to c-especie.
          return "adm-error":U.       
        end. 
    end.

    if (input frame {&FRAME-NAME} portador.cod-febraban = 453) and
       (input frame {&FRAME-NAME} portador.usa-inter = no ) then do: /* RURAL */

       /* busca o valor do portador.emite-bloq na wier v04ad209 *
        * 1 - quando a empresa que emite o bloqueto             *
        * 2 -  quando o banco emite o bloqueto                  */

      run pi-busca-emite-bloq in h_v04ad209 (output i-emite-bloq).
      if ((i-emite-bloq  <> 1 ) and (lookup(c-esp-cob-esc:screen-value,"01,02,03,04,05,06,08,09,10,11,12") <> 0))
      or (( i-emite-bloq = 1 ) and  (lookup(c-esp-cob-esc:screen-value,"21,22,23,24,25,26,28,29,30,31,32") <> 0))    then
        do:   
          run utp/ut-msgs.p (input "show":U, 
                             input 18416,  
                             input "").
          run select-page in wh-cd0901 (4). 
          assign i-cod-febraban-ant = -1. 
          apply "leave" to portador.cod-febraban.
          apply "entry" to c-especie.
          return "adm-error":U.       
        end. 
    end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verif-vendor V-table-Win 
PROCEDURE pi-verif-vendor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param c-executa as char no-undo.

  run pi-passa-modalidade in h_v01ad209 (output i-modalidade).
  assign portador.intervalo-det:sensitive in frame {&frame-name} = yes
         portador.intervalo-head:sensitive in frame {&frame-name}  = yes
         mgadm.portador.usa-inter:sensitive in frame {&FRAME-NAME} = yes
         BUTTON-1:sensitive in frame {&FRAME-NAME} = no.

  if (input frame {&FRAME-NAME} portador.cod-febraban = 275
  or  input frame {&FRAME-NAME} portador.cod-febraban = 356)
    and i-modalidade = 7 then do:
    assign BUTTON-1:sensitive = yes
           portador.intervalo-head:sensitive    = no
           portador.intervalo-head:screen-value = " " 
           portador.intervalo-det:screen-value  = " ".   
  end.         

  if  input frame {&FRAME-NAME} portador.cod-febraban = 237 
      and i-modalidade = 7 then
      assign  BUTTON-1:sensitive                   = yes
               fi-contrato:sensitive                = no
               portador.intervalo-det:sensitive     = no
               portador.intervalo-head:sensitive    = no 
               fi-contrato:screen-value             = " "
               portador.intervalo-det:screen-value  = " "
               portador.intervalo-head:screen-value = " ".

  if i-modalidade = 7 then
        assign c-especie:sensitive = yes
               fi-moeda:sensitive  = yes
               mgadm.portador.usa-inter:sensitive = no.

   if (input frame {&FRAME-NAME} portador.cod-febraban = 291 
      or  input frame {&FRAME-NAME} portador.cod-febraban = 999
      or  input frame {&FRAME-NAME} portador.cod-febraban = 399
      or  input frame {&FRAME-NAME} portador.cod-febraban = 001) /* BB, BCN e ALFA - Vendor */
      and i-modalidade = 7 then do:
       assign c-especie:sensitive  = no.
       if input frame {&FRAME-NAME} portador.cod-febraban <> 001 then
           assign c-carteira:sensitive = no.
   end.


   if input frame {&FRAME-NAME} portador.cod-febraban = 399           
      and i-modalidade = 7 then
       assign fi-moeda:sensitive = no.

  if  input frame {&FRAME-NAME} portador.cod-febraban = 999
       and i-modalidade = 7 then do:
       assign  BUTTON-1:sensitive                           = yes
               fi-contrato:sensitive                        = no
               portador.intervalo-det:sensitive             = yes
               portador.intervalo-head:sensitive            = no 
               fi-contrato:screen-value                     = " "
               fi-moeda:sensitive                           = no
               fi-convenio:sensitive in frame {&frame-name} = yes.
   end.

   if  input frame {&FRAME-NAME} portador.cod-febraban = 001 /* BB */
       and i-modalidade = 7 then do:                                 
       assign  BUTTON-1:sensitive                            = no
               fi-contrato:sensitive                         = no
               portador.intervalo-det:sensitive              = yes
               portador.intervalo-head:sensitive             = yes
               fi-contrato:screen-value                      = " "
               fi-moeda:sensitive                            = no
               fi-convenio:sensitive in frame {&frame-name}  = yes
               fi-variacao:sensitive in frame {&frame-name}  = yes
               fi-faixa-num:sensitive in frame {&frame-name} = no.
   end.



  if c-executa = "vendor" then do:
     if  input frame {&frame-name} portador.cod-febraban = 001
     and i-modalidade <> 7 then do:
        if  input frame {&frame-name} portador.cod-carteira = "31" or
            input frame {&frame-name} portador.cod-carteira = "32" or
            input frame {&frame-name} portador.cod-carteira = "51" then
             assign tg-coligada:sensitive in frame {&frame-name} = yes.
        assign fi-variacao:sensitive  in frame {&frame-name} = yes
               fi-faixa-num:sensitive in frame {&frame-name} = tg-coligada:checked in frame {&frame-name}.
     end.

     if  input frame {&frame-name} portador.cod-febraban = 399
     and i-modalidade = 7 then
        assign fi-moeda:sensitive    = no
               fi-convenio:sensitive = yes
               c-especie:sensitive   = no
               c-carteira:sensitive  = no
               portador.intervalo-head:sensitive = no
               portador.intervalo-det:sensitive = no
               fi-contrato:label = "N£mero Convˆnio"
               fi-convenio:label = "Contrato".
     else
         assign fi-contrato:label = "Contrato"
                fi-convenio:label = "N£mero Convenio".
  end. 

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

