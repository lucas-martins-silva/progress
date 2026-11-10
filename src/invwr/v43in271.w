&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
          movind           PROGRESS
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
{include/i-prgvrs.i V43IN271 2.00.00.024 } /*** "010024" 22/03/2024 10:08:06  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v43in271 MUT}
&ENDIF

/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  vars:
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

/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
def new global shared var l-gera-ficha as log   no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var i-baixa-reservas              as int    no-undo init 1.
def var l-informa-deposito            as log    no-undo init yes.
def var l-informa-localizacao         as log    no-undo.
def var l-requisicao-automatica       as log    no-undo.
def var l-busca-saldos                as log    no-undo.
def var l-acabado-on-line             as log    no-undo init yes.
def var l-requis-on-line              as log    no-undo init yes.
def var l-gera-pedido-rpw             as log    no-undo.
def var c-arquivo-saida               as char   no-undo.

define temp-table tt-param
    field destino          as integer
    field arquivo          as char
    field usuario          as char format "x(12)"
    field data-exec        as date
    field hora-exec        as integer
    field item-ini         as char
    field item-fim         as char
    field data-ini         as date
    field data-fim         as date
    field rep-ini          as integer
    field rep-fim          as integer
    field situacao         as integer.

/* Transfer Definitions */

def var raw-param        as raw no-undo.

def temp-table tt-raw-digita
   field raw-digita      as raw.

define var c-programa-mg97       as char format "x(08)" no-undo.
define var c-versao-mg97         as char format "x(08)" no-undo.   

def var c-it-codigo             as char format "x(16)"      no-undo.
def var c-lista-estados         as char format "x(100)"     no-undo.
def var r-registro              as rowid                    no-undo.
def var l-erro                  as logical                  no-undo.
def var r-ult-oper              as rowid                    no-undo.
def var l-problema              as logical format "Sim/Nao" no-undo.
def var i-mensagem              as int                      no-undo.
def var c-msg                   as char                     no-undo.
def var l-ultima                as logical                  no-undo.
def var rw-oper-ord             as rowid                    no-undo.
def var c-cod-depos             like ord-prod.cod-depos     no-undo.
def var c-lote-serie            like ord-prod.lote-serie    no-undo.
def var c-cod-refer             like ord-prod.cod-refer     no-undo.
def var rw-erro                 as rowid                    no-undo.
def var de-reporta              like ord-prod.qt-reportada  no-undo.
def var l-atu-pl                as logical                  no-undo.
def var de-quantidade-refugo    as dec                      no-undo.
def var i-retorno               as integer                  no-undo.
def var da-dt-trans             as date                     no-undo.
def var l-encerra               as logical                  no-undo.
def var l-erro-ver              as logical                  no-undo.
def var l-reserva               as logical                  no-undo.
def var c-it-codigo-aux         as char                     no-undo.
def var c-retorno               as char                     no-undo.
def var c-erro                  as char                     no-undo.
def var c-texto                 as char                     no-undo.
def var c-campo                 as char                     no-undo.
def var i-cont                  as integer                  no-undo.
def var l-cancelar              as logical                  no-undo.
def var l-repete                as logical                  no-undo.
def var de-saldo-ped            as decimal                  no-undo.
def var h-rfid                  as handle                   no-undo.

/* Handles utilizadas para habilitar ou desabilitar os objetos do programa 
   dependendo das informacoes desta viewer                              */
def var wh-handle-window      as handle                 no-undo.   
def var c-handle              as char                   no-undo.
def var h-handle              as handle                 no-undo.
def var wh-handle-viewer-1    as handle                 no-undo.
def var wh-handle-viewer-2    as handle                 no-undo.
def var wh-handle-browse-res  as handle                 no-undo.
def var wh-handle-browse-aloc as handle                 no-undo.
def var wh-fill-in-erro       as handle                 no-undo.
def var wh-v44in271           as handle                 no-undo.

def var l-erro-valid          as logical                no-undo.
def var l-prim-exec           as logical init yes       no-undo.
def var rw-saldo-estoq        as rowid                  no-undo.
def var l-enibe-pergunta      as logical                no-undo.
def var l-finaliza-op         as logical                no-undo.

DEF VAR i-fnc-pf AS LOGICAL NO-UNDO.
/* Variavel global utilizada na construcao do zoom z02in260.w */
def new global shared var i-ordem like oper-ord.nr-ord-produ no-undo.

/* Variavel global utilizada no cd0220.p */
def new global shared var r-ord-prod as rowid no-undo.

/* Variavel para reposicionamento de registros */
def new global shared var gr-ord-prod          as rowid no-undo.
def new global shared var gr-item              as rowid no-undo.
def new global shared var gr-parametro-reporte as rowid no-undo.

def buffer b-oper-ord for oper-ord.

{cdp/cdcfgman.i} /* Include com preprocessador para release 2.02 */
{cpp/cpapi001.i}
{cdp/cd0666.i}
{cpp/cp9060.i}
{cdp/cd9203.i}     /* Function f-item-uni-estab        */
{bcp/bcapi001.i}    /* Definicao da temp-table tt-trans ---                     */
{bcp/bcapi002.i}    /*** Definicao da temp-table para a API de criacao de etiquetas tt-etiqueta ***/

&IF DEFINED (bf_man_204) &THEN
   {mnbo/bomn161.i1} /* tt-Utiliza */
   {method/dbotterr.i} /* rowerrors */
   DEFINE NEW global shared var h-bomn161 as handle             no-undo.
   DEFINE VARIABLE hShowMsg               AS HANDLE             NO-UNDO.
   DEFINE VARIABLE l-interf-util          AS LOGICAL INITIAL NO NO-UNDO.
&endif

def new global shared var h-acomp as handle no-undo.

def var h-container as handle no-undo.
def var h-browse2 as handle no-undo.
def var h-vcta	as handle no-undo.
def var c-fi-dt-validade as date no-undo.
def var c-fi-lote-serie like rep-prod.lote-serie no-undo.
DEF VAR c-dep-reciclado LIKE ord-prod.cod-depos NO-UNDO.
DEF VAR c-cod-depos-reportado LIKE ord-prod.cod-depos NO-UNDO.
DEF VAR i-estado-ord LIKE ord-prod.estado NO-UNDO.
DEF VAR l-usa-unid-negoc AS LOGICAL NO-UNDO.

&IF DEFINED (bf_man_per_ppm) &THEN
  def var l-per-ppm as log no-undo.  
&ENDIF

/* Include i-epc200.i: Definiá∆o Temp-Table tt-epc e dos programas de EPCs */
/*
def var c-nom-prog-dpc-mg97  as char init "" no-undo.   
def var c-nom-prog-appc-mg97 as char init "" no-undo.
def var c-nom-prog-upc-mg97  as char init "" no-undo.
def var raw-rowObject        as raw          no-undo.
*/
  {include/i-epc200.i1}

DEFINE VARIABLE l-first AS LOGICAL INIT YES  NO-UNDO.

DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.

DEFINE VARIABLE l-bt-ok AS LOGICAL INIT NO NO-UNDO.

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
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-prod.it-codigo 
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS ord-prod.nr-ord-produ ord-prod.it-codigo ~
ord-prod.cod-refer ord-prod.cod-estabel ord-prod.qt-ordem ~
ord-prod.qt-produzida ord-prod.qt-refugada 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS fi-estado fi-descricao-item fi-saldo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-desc-unid-negoc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 50.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-negoc AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 50.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 50.43 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>>>>,>>9.9999" INITIAL 0 
     LABEL "":R15 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 6.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 1.25 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-estado AT ROW 1.25 COL 36.57 COLON-ALIGNED NO-LABEL
     ord-prod.it-codigo AT ROW 2.33 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-descricao-item AT ROW 2.33 COL 36.57 COLON-ALIGNED NO-LABEL
     ord-prod.cod-refer AT ROW 3.42 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.cod-estabel AT ROW 3.42 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     ord-prod.qt-ordem AT ROW 4.5 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-produzida AT ROW 4.5 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-saldo AT ROW 5.5 COL 64 COLON-ALIGNED HELP
          "Quantidade original da Reserva"
     ord-prod.qt-refugada AT ROW 5.58 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     c-unid-negoc AT ROW 6.67 COL 18 COLON-ALIGNED
     c-desc-unid-negoc AT ROW 6.67 COL 36.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.ord-prod
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
         HEIGHT             = 6.79
         WIDTH              = 88.57.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-desc-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-unid-negoc IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
ASSIGN 
       c-unid-negoc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN ord-prod.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-descricao-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.nr-ord-produ IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-produzida IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-refugada IN FRAME f-main
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

&Scoped-define SELF-NAME ord-prod.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON F5 OF ord-prod.it-codigo IN FRAME f-main /* Item */
DO:
   {include/zoomvar.i &prog-zoom = "inzoom/z02in172.w"
                     &campo     = ord-prod.it-codigo
                     &campozoom = it-codigo   }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON LEAVE OF ord-prod.it-codigo IN FRAME f-main /* Item */
DO:
   if input frame {&frame-name} ord-prod.it-codigo <> c-it-codigo-aux then do:
      assign c-it-codigo-aux = input frame {&frame-name} ord-prod.it-codigo.      
      find item where 
           item.it-codigo eq input frame {&frame-name} ord-prod.it-codigo
           no-lock no-error.        
      if avail(item) then do:
         run notify ('pi-habilita-campos,record-target').
         run notify ('pi-atualiza-item,record-target').
      end.
      else
          run notify ('pi-desabilita-campos,record-target').
   end.    
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-prod.it-codigo IN FRAME f-main /* Item */
DO:
   apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

/************************ INTERNAL PROCEDURES ********************/

ASSIGN l-usa-unid-negoc = FALSE.

&IF DEFINED(bf_man_206b) &THEN

    IF CAN-FIND (FIRST funcao
                 WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                 AND   funcao.ativo     = TRUE) THEN DO:

        ASSIGN l-usa-unid-negoc = TRUE.

    END.

    IF l-usa-unid-negoc THEN DO:

        ASSIGN c-unid-negoc:HIDDEN      IN FRAME {&FRAME-NAME} = FALSE
               c-desc-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
               

    END.

&ENDIF

IF NOT l-usa-unid-negoc THEN DO:

    ASSIGN c-unid-negoc:HIDDEN      IN FRAME {&FRAME-NAME} = TRUE
           c-desc-unid-negoc:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.

END.


{utp/ut-liter.i Saldo * L}
assign fi-saldo:label in frame {&frame-name} = return-value.
&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    RUN utp/ut-liter.p (trim({ininc/i01in271.i 03}), "*", "").
    assign c-lista-estados = return-value .
&else
    assign c-lista-estados = {ininc/i01in271.i 03}.
&endif

if ord-prod.it-codigo:load-mouse-pointer("image/lupa.cur") then.

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

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

  /*situaá∆o inserida para caso o exista a confirmaá∆o sem o leave do campo it-codigo*/
  IF AVAIL param-cp AND PARAM-cp.rep-item 
     AND AVAIL ord-prod 
     AND ord-prod.it-codigo  <> INPUT FRAME {&FRAME-NAME} movind.ord-prod.it-codigo 
      THEN APPLY "leave" TO movind.ord-prod.it-codigo IN FRAME {&FRAME-NAME}. 

  /* Code placed here will execute PRIOR to standard behavior. */
  &IF DEFINED(bf_man_205) &THEN
       IF param-global.modulo-per-ppm AND valid-handle(h-handle-pai) THEN DO:
           IF l-bt-ok = NO THEN DO:
               RUN desabilitaBtOk IN h-handle-pai.
               RETURN "adm-error":U.
           END.
       END.
  &ENDIF

  /* Retirado para nao executar a pi-validate automaticamente */ 
  /*  {include/i-valid.i} */
  IF VALID-HANDLE(wh-v44in271) THEN 
      RUN pi-cria-tt-reservas-alocacoes IN wh-v44in271.

  reporte:
  /** Bloco principal da confirmaá∆o do reporte **/
  do transaction on error UNDO ,return "ADM-ERROR":U 
                 on stop  UNDO ,return "ADM-ERROR":U:
      FIND CURRENT ord-prod NO-LOCK.
      ASSIGN i-fnc-pf = can-find (first funcao
                                    where funcao.cd-funcao = "spp-dep-refugo"
                                      and funcao.ativo     = yes).

      ASSIGN i-estado-ord = ord-prod.estado.

      RUN who-is-the-container in adm-broker-hdl (input this-procedure, output h-container).
      RUN pi-retorna-handle in h-container (output h-browse2).
      RUN pi-retorna-campo in h-browse2 (input "fi-dt-validade-lote-acabado", output c-fi-dt-validade).
      RUN pi-retorna-campo in h-browse2 (input "fi-lote-serie-acabado", output c-fi-lote-serie).  
      IF i-fnc-pf THEN 
         RUN pi-retorna-campo in h-browse2 (input "fi-dep-reciclado", output c-dep-reciclado).
      run get-attribute in widget-handle (c-handle) (input "tipo-reporte"). 
      run pi-valida-ordem in h-handle (input yes,
                                       input ord-prod.nr-ord-prod,
                                       input int (return-value),
                                       output c-erro,
                                       output c-texto). 

        assign c-retorno = return-value.
        if c-retorno = "nok" THEN DO:

            do i-cont = 1 to num-entries (c-erro):
               run utp/ut-msgs.p (input "show",
                                  input int (entry (i-cont, c-erro)),
                                  input entry (i-cont, c-texto)).
            end.
            undo reporte, return "ADM-ERROR":U.
        END.
      for each tt-rep-prod:
          delete tt-rep-prod.
      end.

      create tt-rep-prod.

      assign tt-rep-prod.nr-ord-prod       = ord-prod.nr-ord-prod.

      /* Assign anterior n∆o pode esta junto com a function f-retorna-campo, 
         pois ocorre erro de compilaá∆o no progress 9 */  

      assign tt-rep-prod.prog-seg          = "cp0311"
             tt-rep-prod.carrega-reservas  = l-busca-saldos
             tt-rep-prod.procura-saldos    = l-busca-saldos
             tt-rep-prod.baixa-reservas    = i-baixa-reservas
             tt-rep-prod.requis-automatica = l-requisicao-automatica
             tt-rep-prod.cod-depos-sai     = if l-informa-deposito and
                                                not param-cp.dep-fab-unico then
                                                f-retorna-campo ('fi-cod-depos')
                                             else ?
             tt-rep-prod.cod-local-sai     = if l-informa-localizacao then
                                                f-retorna-campo ('fi-cod-localiz')
                                             else ?
             tt-rep-prod.data              = date (f-retorna-campo ("fi-dt-trans"))
             tt-rep-prod.un                = ord-prod.un
             tt-rep-prod.qt-reporte        = dec (f-retorna-campo ("fi-quantidade-reporte"))
             tt-rep-prod.qt-refugo         = dec (f-retorna-campo ("fi-quantidade-refugo"))
             tt-rep-prod.it-codigo         = input frame {&frame-name} ord-prod.it-codigo
             tt-rep-prod.qt-apr-cond       = dec (f-retorna-campo ("fi-quantidade-aprov-cond"))
             tt-rep-prod.nro-docto         = f-retorna-campo ("fi-nro-docto")
             tt-rep-prod.serie-docto       = f-retorna-campo ("fi-serie-docto")
             tt-rep-prod.cod-depos         = f-retorna-campo ("fi-cod-depos-acabado")
             tt-rep-prod.lote-serie        = c-fi-lote-serie
             tt-rep-prod.cod-refer         = f-retorna-campo ("fi-cod-refer-acabado")
             tt-rep-prod.dt-vali-lote      = (c-fi-dt-validade)
             tt-rep-prod.cod-localiz       = f-retorna-campo ("fi-cod-localiz-acabado")
           &IF DEFINED (bf_man_per_ppm) &THEN
             tt-rep-prod.per-ppm           = dec (f-retorna-campo ("fi-per-ppm-acabado":u))
           &ENDIF
             .
			 
		RUN who-is-the-container in adm-broker-hdl (input this-procedure, output h-container).
		RUN pi-retorna-handle44 in h-container (output h-vcta).
        RUN pi-retorna-campo in h-vcta (input "fi-conta-refugo", output tt-rep-prod.ct-refugo).
		RUN pi-retorna-campo in h-vcta (input "fi-cc-refugo", output tt-rep-prod.sc-refugo).
		RUN pi-retorna-campo in h-vcta (input "fi-conta-debito-direto", output tt-rep-prod.cod-cta-unif).
		RUN pi-retorna-campo in h-vcta (input "fi-ccusto-dd", output tt-rep-prod.cod-ccusto-unif).
		
      IF i-fnc-pf THEN DO:
         &IF DEFINED (bf_man_sfc_lc) &THEN
            ASSIGN tt-rep-prod.dep-refugo        = c-dep-reciclado.   
         &endif 
      END.

      assign i-retorno = 1.  
      if tt-rep-prod.qt-refugo > 0  then do: 
         RUN set-cursor in adm-broker-hdl ("").      

         if param-global.modulo-cq = yes and
            param-cq.tipo-cq > 1 and
            f-item-uni-estab (input item.it-codigo,
                              input INPUT FRAME {&FRAME-NAME} ord-prod.cod-estabel,
                              "contr-qualid") = "yes":U then
            run cpp/cp9060.w (input-output table tt-ref-ordem,
                              input tt-rep-prod.qt-refugo,
                              input 1,
                              input 0,
                              output i-retorno).      
      end.  
      if i-retorno = 0 then
         undo reporte, return "ADM-ERROR":U.

      assign i-retorno = 1.   
      if tt-rep-prod.qt-apr-cond > 0 then do:      
         RUN set-cursor in adm-broker-hdl ("").
         if param-global.modulo-cq = yes and
            param-cq.tipo-cq > 1 and
            f-item-uni-estab (input item.it-codigo,
                              input INPUT FRAME {&FRAME-NAME} ord-prod.cod-estabel,
                              "contr-qualid") = "yes":U then       
             run cpp/cp9060.w (input-output table tt-ref-ordem,
                              input tt-rep-prod.qt-apr-cond,
                              input 2,
                              input 0,
                              output i-retorno).   
      end.  
      if i-retorno = 0 then
         undo reporte, return "ADM-ERROR":U.  

      for each tt-refugo:
          delete tt-refugo.
      end.   

      for each tt-ref-ordem:
          create tt-refugo.
          assign tt-refugo.nr-ord-produ = ord-prod.nr-ord-prod
                 tt-refugo.codigo-rejei = tt-ref-ordem.codigo-rejei
                 tt-refugo.qt-refugo    = tt-ref-ordem.qt-refugo
                 tt-refugo.observacao   = tt-ref-ordem.observacao.
      end.

      run pi-recebe-tt-refugo in h-handle (input table tt-refugo).

      run pi-recebe-tt-rep-prod in h-handle (input table tt-rep-prod).
      /*INCLUIR PONTO DE CHAMADA UPC*/
      if  c-nom-prog-upc-mg97 <> "":U 
      OR c-nom-prog-dpc-mg97  <> "":U
      OR c-nom-prog-appc-mg97 <> "":U then do:

           RUN pi-upc (INPUT "after-create-tt-rep-prod":U,
                       INPUT "viewer",
                       INPUT this-procedure:handle,
                       INPUT frame {&frame-name}:handle,
                       INPUT "ord-prod",
                       INPUT ROWID(ord-prod)).

           IF RETURN-VALUE = "alterado":U THEN DO:
               RUN pi-retorna-tt-rep-prod IN h-handle (OUTPUT TABLE tt-rep-prod).
               FIND FIRST tt-rep-prod NO-ERROR.
           END.
      end.

      run pi-valida-rep-prod in h-handle (input  yes,
                                          input  ord-prod.nr-ord-prod,
                                          output c-erro,
                                          output c-texto).
      assign c-retorno = return-value.       

      RUN set-cursor in adm-broker-hdl ("").                               

      /****** Verifica se j† existe ficha de CQ para Item/Lote *****/

      run pi-valida-ficha-cq in h-handle (input yes).

      if tt-rep-prod.qt-reporte - tt-rep-prod.qt-refugo > 0 then do:
          
          if param-cp.log-ficha-ord then do:

              if item.tipo-con-est = 3 or
                 item.tipo-con-est = 4 then do:

                  run pi-valida-ficha-cq in h-handle (input NO).

                  find first ficha-cq 
                       where ficha-cq.it-codigo   = tt-rep-prod.it-codigo
                         and ficha-cq.cod-estabel = ord-prod.cod-estabel
                         and ficha-cq.cod-depos   = tt-rep-prod.cod-depos
                         and ficha-cq.cod-localiz = tt-rep-prod.cod-localiz
                         and ficha-cq.lote        = tt-rep-prod.lote-serie 
                         and ficha-cq.op-seq      = 0
                         and ficha-cq.situacao    < 4 NO-LOCK NO-ERROR.
             
                  if avail ficha-cq then do: 
                      run utp/ut-msgs.p (input "show",
                                         input 19503,
                                         input "").

                      run pi-valida-ficha-cq in h-handle (input (RETURN-VALUE = "YES")).
                  end.
                  else run pi-valida-ficha-cq in h-handle (input YES).
              end.
          end.
      end.   /* Quantidade CQ > 0 */
      else 
          run pi-valida-ficha-cq in h-handle (input no).

      if c-retorno = "nok" then do:
         case int (entry (1, c-erro)):
              when 56 then do:
                   {utp/ut-table.i mgind localizacao 1}
                   if entry (1, c-texto) = return-value then
                      assign c-campo = "fi-cod-localiz-acabado".
                   {utp/ut-liter.i Conta_Cont†bil * R }
                   if entry (1, c-texto) = return-value then
                      assign c-campo = "fi-conta-debito-direto".
              end.

              when 166 or when 563 or when 693 or when 3454 then 
                   apply 'entry' to ord-prod.it-codigo in frame {&frame-name}.

              when 106 or when 6610 then assign c-campo = "fi-conta-debito-direto".

              when 530 or when 3412 then 
                   assign c-campo = "fi-cod-depos".

              when 847 or when 1234 or when 2372 or when 5808 then 
                   assign c-campo = "fi-quantidade-reporte".

              when 3428 then
                   assign c-campo = "fi-quantidade-refugo".

              when 2386 or when 2387 or when 2388 then
                   assign c-campo = "fi-conta-refugo".

              when 2389 or when 2390 then 
                   assign c-campo = "fi-quantidade-aproc-cond".

              when 2403 or when 7410 then
                   assign c-campo = "fi-cod-depos-acabado".

              when 2793 then
                   assign c-campo = "fi-dt-trans".

              when 1252 or when 2408 or when 2158 then
                   assign c-campo = "fi-lote-serie-acabado".

              when 529 or when 1235 or when 1236 then
                   assign c-campo = "fi-cod-refer-acabado".

              when 1247 or when 2409 or when 2410 then
                   assign c-campo = "fi-dt-validade-lote-acabado".

              otherwise assign c-campo = "".
         end case.

         run set-attribute-list ("campo=" + c-campo).

         if c-campo <> "" then     
            run notify ('pi-apply-entry,record-target').
      end.

      do i-cont = 1 to num-entries (c-erro):
         run utp/ut-msgs.p (input "show",
                            input int (entry (i-cont, c-erro)),
                            input entry (i-cont, c-texto)).
      end.

      if c-retorno = "nok" then undo reporte, return "ADM-ERROR":U.

      run pi-validate.

      if return-value eq "adm-error":U then 
         undo reporte, return "ADM-ERROR":U.

      run notify ('pi-validate,record-target').

      if return-value = "adm-error":U then
         undo reporte, return "ADM-ERROR":U.

      assign c-retorno = "".

      /* Chamada EPC para a assign record */
         {include/i-epc003.i}

      run notify ('pi-grava-arquivos,record-target').
      if return-value = "adm-error":U then
         undo reporte, return "ADM-ERROR":U.

      run utp/ut-acomp.p persistent set h-acomp.

      {utp/ut-liter.i Processando_Reporte *}
      run pi-inicializar in h-acomp ( Return-value ).

      run pi-desabilita-cancela in h-acomp.

      if l-acabado-on-line then do:
         run pi-processa-reportes in h-handle (input-output table tt-rep-prod,
                                               input        table tt-refugo,
                                               input        table tt-res-neg,
                                               input-output table tt-erro,
                                               input yes,
                                               input l-requis-on-line).                    
         assign c-retorno = return-value.
      end.

      if valid-handle (h-acomp) then
         run pi-finalizar in h-acomp.

      blk_erro:
      FOR EACH tt-erro:
        FIND FIRST cadast_msg
             WHERE cadast_msg.cdn_msg = tt-erro.cd-erro
             NO-LOCK NO-ERROR.

        IF (AVAIL cadast_msg AND cadast_msg.idi_tip_msg = 1)
        OR tt-erro.cd-erro = 19429 //19429 Ç msg do EMS5, 50413 Ç a msg unificada com o TOTVS 12.
        OR tt-erro.cd-erro = 20035 //20035 Ç msg do EMS5, 50413 Ç a msg unificada com o TOTVS 12.
        THEN DO:
            ASSIGN c-retorno = "NOK".
            LEAVE blk_erro.
        END.
        ELSE DO:
            ASSIGN c-retorno = "OK".
        END.
      END.
      find first tt-erro no-error.
      if avail tt-erro
      THEN DO:
         run cdp/cd0666.w (input table tt-erro).
      END.

      if c-retorno = "nok":u then
         undo reporte, return "adm-error":U.
      

      IF c-retorno = "ok":u THEN DO:
        /* UPC */
          RUN pi-upc (INPUT "after-pi-processa-reportes",
                      INPUT "after-pi-processa-reportes",
                      INPUT ?,
                      INPUT ?,
                      INPUT "ord-prod",
                      INPUT ROWID(ord-prod)).
        
        if return-value = "NOK" then
            undo, leave.

        /* UPC - before-pi-valida-movto - FO. 1779.445 */
        RUN pi-upc (INPUT "before-pi-valida-movto",
                    INPUT "before-pi-valida-movto",
                    INPUT ?,
                    INPUT ?,
                    INPUT "ord-prod",
                    INPUT ROWID(ord-prod)).

        IF RETURN-VALUE = "adm-error":U THEN
            UNDO reporte, RETURN "adm-error":U.
        
      END.
      
      /***/
      RUN pi-valida-movto.

      if return-value = "adm-error":U then
         undo reporte, return "adm-error":U.

      if l-requisicao-automatica  and
         not can-find(first al-res-op where 
                            al-res-op.nr-ord-prod = ord-prod.nr-ord-prod) and
         item.tipo-requis = 1     then do:
          find first tt-rep-prod. 
         run cpp/cp0311f.w (input rowid(ord-prod)      ,
                            input tt-rep-prod.cod-depos,
                            input tt-rep-prod.lote-serie,
                            input tt-rep-prod.cod-localiz,
                            input tt-rep-prod.data,
                            input tt-rep-prod.qt-reporte).                 
         if return-value eq "adm-error" THEN
            UNDO reporte , return "adm-error":U.

      end.                             


      FIND ITEM WHERE ITEM.it-codigo = ord-prod.it-codigo NO-LOCK NO-ERROR.


      ASSIGN c-cod-depos-reportado = f-retorna-campo ("fi-cod-depos-acabado").
      IF i-estado-ord = 1 AND c-cod-depos-reportado <> ord-prod.cod-depos AND 
         item.tipo-contr <> 4 AND item.it-codigo <> "" AND item.it-codigo <> " " THEN DO:

          run utp/ut-msgs.p (input "show":u,
                             input 31227,
                             input STRING(ord-prod.cod-depos) + "~~" + STRING(c-cod-depos-reportado)).

          IF RETURN-VALUE = "yes":U THEN DO:
              ASSIGN ord-prod.cod-depos = c-cod-depos-reportado.
          END.

      END.
      FIND CURRENT ord-prod NO-LOCK.
  end.  /** Bloco reporte **/


  /* Code placed here will execute AFTER standard behavior.    */   

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  find first tt-rep-prod.   

  /* Texto da ordem */
  if ord-prod.prototipo then do:
     find texto-ordem where 
          texto-ordem.nr-ord-prod = ord-prod.nr-ord-prod 
          no-lock no-error.
     if avail(texto-ordem) 
     then     
        assign gr-parametro-reporte = rowid(texto-ordem).
     else 
        assign gr-parametro-reporte = ? .   
     run cpp/cp0328.w.
  end.   


  if tt-rep-prod.qt-reporte - tt-rep-prod.qt-refugo > 0 then do: 
     if can-find(first al-pr-op where al-pr-op.nr-ord-prod = ord-prod.nr-ord-prod) then do:
        find first saldo-estoq use-index dep-estabel where
                   saldo-estoq.cod-depos   = tt-rep-prod.cod-depos   and
                   saldo-estoq.cod-estabel = ord-prod.cod-estabel    and
                   saldo-estoq.cod-localiz = tt-rep-prod.cod-localiz and
                   saldo-estoq.lote        = tt-rep-prod.lote-serie  and
                   saldo-estoq.it-codigo   = ord-prod.it-codigo
                   no-lock no-error.
        assign rw-saldo-estoq = if avail(saldo-estoq) then rowid(saldo-estoq)
                                                      else ?.
        assign l-repete = yes.
        do while l-repete :                                                    
           run cpp/cp9042.w (input (tt-rep-prod.qt-reporte -
                                    tt-rep-prod.qt-refugo),
                             input  rw-saldo-estoq  ,
                             output de-saldo-ped    ).
           if de-saldo-ped > 0 then do:
              /* Pedidos nao foram totalmente atendidos. retorna para alocacao?. */                                            
              run utp/ut-msgs.p (input "show",
                                 input 6030  ,
                                 input ""    ).
              if return-value eq "yes" then assign l-repete = yes.
                                       else assign l-repete = no .                
           end.                             
           else assign l-repete = no.
        end.              
     end.                                                             
  end.          

  RUN pi-utilizacao.  /* a partir da 2.04 */

    IF CONNECTED("mgcld")THEN DO:
        
        RUN rfid/rfidapi001.p PERSISTENT SET h-rfid.        
          
        RUN pi-valida-impressao IN h-rfid(BUFFER tt-rep-prod,
                                          INPUT c-it-codigo-aux,
                                          INPUT ROWID(ord-prod),
                                          INPUT f-retorna-campo ("fi-nro-docto"),
                                          INPUT f-retorna-campo ("fi-serie-docto"),
                                          INPUT c-fi-lote-serie,
                                          INPUT c-fi-dt-validade,
                                          INPUT c-seg-usuario).
        
        IF VALID-HANDLE(h-rfid)THEN 
            DELETE PROCEDURE h-rfid.        
    END.
  RUN set-cursor in adm-broker-hdl ("").

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-cancel-record V-table-Win 
PROCEDURE local-cancel-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  assign l-cancelar = yes.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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

  &IF DEFINED(bf_man_205) &THEN
      IF VALID-HANDLE(h-handle-pai) THEN
          RUN pi-local-disable IN h-handle-pai.  
      ASSIGN l-bt-ok = NO.
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  run notify ('pi-desabilita-campos,record-target').
  run notify ('pi-desabilita-browse-mob,record-target').                                                                  

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

  if avail(ord-prod) then do:

     /* Esse FIND CURRENT atualiza o registro para que nos casos de alteracao externa via AppServer (APP mobile, TOTVS MES), 
     essas modificacoes fiquem disponiveis imediatamente nessa viewer */                              
     FIND CURRENT ord-prod NO-LOCK.   

     assign fi-estado = entry(ord-prod.estado,c-lista-estados).  
     assign fi-saldo  = if   ord-prod.qt-ordem - ord-prod.qt-produzida > 0
                        then ord-prod.qt-ordem - ord-prod.qt-produzida
                        else 0.                                                              
     find item where 
          item.it-codigo = ord-prod.it-codigo                     
          no-lock no-error.
     if avail(item) then do:
         assign fi-descricao-item = item.desc-item.
         &IF DEFINED (bf_man_per_ppm) &THEN
             assign l-per-ppm = (param-global.modulo-per-ppm and
                                 item.tipo-formula >= 2      and
                                 item.tipo-formula <= 3).
             RUN who-is-the-container in adm-broker-hdl (input this-procedure, output h-container).
             RUN pi-retorna-handle in h-container (output h-browse2).
             if valid-handle (h-browse2) then
                 run pi-formata-tela in h-browse2 (input if not l-per-ppm then 1
                                                                          else 2,
                                                   input if not l-per-ppm then 0
                                                                          else item.tipo-formula).
         &ENDIF
     end.

     &IF DEFINED(bf_man_206b) &THEN
     
        IF l-usa-unid-negoc THEN DO:

            ASSIGN c-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = ord-prod.cod-unid-negoc.

            FIND unid-negoc WHERE unid-negoc.cod-unid-negoc = ord-prod.cod-unid-negoc NO-LOCK NO-ERROR.
            IF AVAIL unid-negoc THEN
                ASSIGN c-desc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = unid-negoc.des-unid-negoc.
            ELSE
                ASSIGN c-desc-unid-negoc:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "".

        END.

     &ENDIF

  end.        

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE c-erro    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-texto   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-retorno AS CHARACTER  NO-UNDO.

  def var c-handle as char no-undo.
  /* Code placed here will execute PRIOR to standard behavior. */

  IF ord-prod.origem = "MV":U THEN DO:
     run utp/ut-msgs.p (input "show",
                        input 29505 ,
                        input ""    ).
     RUN Who-Is-The-Container IN adm-broker-hdl
                     (INPUT this-procedure,
                      OUTPUT c-handle).
     run pi-cancela in widget-handle(c-handle).
     return "adm-error":U.
  END.
  
  &IF defined(bf_man_sfc_lc) &THEN

     IF NOT AVAIL param-sfc THEN
         FIND FIRST param-sfc NO-LOCK NO-ERROR.
     IF CAN-FIND(FIRST rep-oper-ctrab WHERE rep-oper-ctrab.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK)
     &IF DEFINED (bf_man_sfc_magnus) &THEN 
       &IF DEFINED (bf_man_sfc_ref_oper) &THEN  
       &ELSE
            AND AVAIL param-sfc AND param-sfc.ind-integracao-mfg = 1 
       &ENDIF
     &ENDIF
     THEN do:
         /*Esta ordem j† possui reportes no Ch∆o de F†brica. Por este motivo, 
         o reporte de todas as operaá‰es da ordem deve ser feito atravÇs do m¢dulo Ch∆o de F†brica.*/
        IF l-first THEN DO:
            run utp/ut-msgs.p (input "show":u,
                               input 29377,
                               input "").
            ASSIGN l-first = NO.
        END.
        ELSE
            ASSIGN l-first = YES.

        RUN Who-Is-The-Container IN adm-broker-hdl
                        (INPUT this-procedure,
                         OUTPUT c-handle).
        run pi-cancela in widget-handle(c-handle).
        return "adm-error":U.
     end.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .  

  &IF DEFINED(bf_man_205) &THEN
      IF VALID-HANDLE(h-handle-pai) THEN
          RUN pi-local-enable IN h-handle-pai.  
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif    

  for each tt-ref-ordem:
      delete tt-ref-ordem.
  end.

  if ord-prod.it-codigo:sensitive in frame {&frame-name} then do :

     run notify ('pi-habilita-campos,record-target').   

     if ord-prod.reporte-mob = 1 or
        ord-prod.reporte-ggf = 1 then do:
        run notify ('pi-habilita-browse-mob,record-target').
     end.
     else
         run notify ('pi-desabilita-browse-mob,record-target').

     assign ord-prod.it-codigo:sensitive in frame {&frame-name} = 
            param-cp.pede-item and ord-prod.estado < 6.
  end. 

  assign c-it-codigo-aux = ord-prod.it-codigo.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /*Chamada UPC para que se possa enibir a pergunta 5604 - FO 1.051.542*/
  run pi-upc (input "ANTES-FINALIZA-ORDEM",
              input "BT-OK",
              input ?,
              input ?,
              input "ord-prod",
              input rowid(ord-prod)).

  IF RETURN-VALUE = "ENIBE" THEN
     ASSIGN l-enibe-pergunta = YES
            l-finaliza-op    = YES.  /*A pergunta Ç enibida e a OP Ç finalizada*/
  
  /* Altera Estado da Ordem de Producao para Terminada/Finalizada ? */
  IF NOT l-enibe-pergunta THEN
  run utp/ut-msgs.p (input "show",
                     input (if not param-global.modulo-cs then
                              5603
                            else 5604),
                     input trim(STRING(ord-prod.nr-ord-produ,">>>,>>>,>>9"))).
  if return-value = "yes" OR l-finaliza-op then do:
    run pi-cria-upc.  /*FO-998823*/
    IF RETURN-VALUE <> "ADM-ERROR":U THEN DO:

     &IF DEFINED (bf_man_linha_estab) &THEN
     find first lin-prod
          where lin-prod.cod-estabel = ord-prod.cod-estabel
            and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.        
     &ELSE
     find first lin-prod
          where lin-prod.nr-linha = ord-prod.nr-linha no-lock no-error.
     &ENDIF  
     if avail lin-prod then do:           
        if param-cp.ver-req and lin-prod.sum-requis = 2 then do:
           run cpp/cp0311g.p (input rowid(ord-prod)      ,
                              output l-erro-ver          ,
                              input "2"                  ,
                              input ord-prod.qt-reportada,
                              input yes                  ,
                              input i-baixa-reservas      ).
           if l-erro-ver then return "adm-error".
        end.
     end.
     run pi-finaliza-ordem in h-handle (input ord-prod.nr-ord-prod).
	 
	 run pi-retorna-tt-erro in h-handle (output table tt-erro).
		find first tt-erro no-lock no-error.
        if avail(tt-erro) then do:
			run utp/ut-msgs.p (input "show", 
							   input tt-erro.cd-erro, 
							   input STRING(ord-prod.nr-ord-prod)).

            RUN Who-Is-The-Container IN adm-broker-hdl
                            (INPUT this-procedure,
                             OUTPUT c-handle).
            run pi-cancela in widget-handle(c-handle).
            return "adm-error":U.
			//undo, return "adm-error":U.
        end.  
  end.
  end.
  /*/* Dispatch standard ADM method.                             */    
 *   RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .  
 * if RETURN-VALUE = 'ADM-ERROR':U then 
 *    RETURN 'ADM-ERROR':U.*/

  if l-gera-pedido-rpw then do:
     for each tt-param:
         delete tt-param.
     end.
     create tt-param.
     assign tt-param.usuario   = c-seg-usuario
            tt-param.destino   = 2
            tt-param.data-exec = today
            tt-param.hora-exec = time
            tt-param.arquivo   = if c-arquivo-saida = "" then
                                    "op" + string (ord-prod.nr-ord-prod, "999999")
                                 else c-arquivo-saida
            tt-param.item-ini  = ord-prod.it-codigo
            tt-param.item-fim  = ord-prod.it-codigo
            tt-param.data-ini  = date (f-retorna-campo ("fi-dt-trans"))
            tt-param.data-fim  = date (f-retorna-campo ("fi-dt-trans"))
            tt-param.rep-ini   = 0
            tt-param.rep-fim   = 0
            tt-param.situacao  = 1.

     raw-transfer tt-param    to raw-param.
     RUN Who-Is-The-Container IN adm-broker-hdl
        (INPUT this-procedure,
         OUTPUT c-handle).
     run pi-retorna-nome-versao in widget-handle (c-handle) (output c-programa-mg97,
                                                             output c-versao-mg97)
                                                             no-error.
     run btb/btb911zb.p (input c-programa-mg97,
                         input "cpp/cp0332rp.p",
                         input c-versao-mg97,
                         input 97,
                         input tt-param.arquivo,
                         input tt-param.destino,
                         input raw-param,
                         input table tt-raw-digita,
                         output i-num-ped-exec-rpw).

     if i-num-ped-exec-rpw <> 0 then                     
        run utp/ut-msgs.p (input "show", 
                           input 4169, 
                           input string(i-num-ped-exec-rpw)).                      
  end. 
  run dispatch ('display-fields').                       

  RUN pi-finalizar-cp0311 IN h-handle.

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.
  if  param-global.modulo-ce then do:
     find first param-estoq no-lock no-error.
     find first param-cq    no-lock no-error.     
  end.
  find first param-cp no-lock no-error.

  &IF DEFINED (bf_man_204) &THEN
      IF param-global.modulo-mi THEN DO:
         FIND FIRST param-mi NO-LOCK NO-ERROR.

         IF AVAIL (param-mi) THEN DO:
  &endif
         &IF DEFINED (bf_man_206) &THEN
             ASSIGN l-interf-util = param-mi.log-interf-util.
         &ELSEIF DEFINED(bf_man_204) &then
             ASSIGN l-interf-util = param-mi.log-1.
         &endif

  &IF DEFINED (bf_man_204) &THEN
         END.
      END.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-reset-record V-table-Win 
PROCEDURE local-reset-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'reset-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if not l-cancelar then
     run dispatch ('enable-fields').

  assign l-cancelar = no.

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
  if avail(ord-prod) then 
     assign gr-ord-prod = rowid(ord-prod) .

  if avail(item) then 
     assign gr-item = rowid(item).   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter p-baixa-reservas        as int    no-undo.
    def input parameter p-informa-deposito      as log    no-undo.
    def input parameter p-informa-localizacao   as log    no-undo.
    def input parameter p-requisicao-automatica as log    no-undo.
    def input parameter p-busca-saldos          as log    no-undo.
    def input parameter p-acabado-on-line       as log    no-undo.
    def input parameter p-requis-on-line        as log    no-undo.
    def input parameter p-gera-pedido-rpw       as log    no-undo.
    def input parameter p-arquivo-saida         as char   no-undo.

    assign i-baixa-reservas        = p-baixa-reservas
           l-informa-deposito      = p-informa-deposito
           l-informa-localizacao   = p-informa-localizacao
           l-requisicao-automatica = p-requisicao-automatica
           l-busca-saldos          = p-busca-saldos
           l-acabado-on-line       = p-acabado-on-line
           l-requis-on-line        = p-requis-on-line
           l-gera-pedido-rpw       = p-gera-pedido-rpw
           c-arquivo-saida         = p-arquivo-saida.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-upc V-table-Win 
PROCEDURE pi-cria-upc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF

/* DPC */
if  c-nom-prog-dpc-mg97 <> "" then do:

    run value(c-nom-prog-dpc-mg97) (input "FINALIZA-ORDEM",
                                    input "BT-OK",
                                    input this-procedure,
                                    input frame f-main:handle,
                                    input "ord-prod",
                                    input rowid(ord-prod)).
    if  return-value = "NOK":U then
        return "ADM-ERROR":U.
end.                                       


/* APPC */
if  c-nom-prog-appc-mg97 <> "" then do:
    run value(c-nom-prog-appc-mg97) (input "FINALIZA-ORDEM",
                                    input "BT-OK",
                                    input this-procedure,
                                    input frame f-main:handle,
                                    input "ord-prod",
                                    input rowid(ord-prod)).
    if  return-value = "NOK":U then
        return "ADM-ERROR":U.
end.

/* UPC */
if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

    run value(c-nom-prog-upc-mg97) (input "FINALIZA-ORDEM",
                                    input "BT-OK",
                                    input this-procedure,
                                    input frame f-main:handle,
                                    input "ord-prod",
                                    input rowid(ord-prod)).
    if  return-value = "NOK":U then
        return "ADM-ERROR":U.
end.                                       

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

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-handle).

run get-attribute in widget-handle (c-handle) (input 'HANDLE').

assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-handle-pai V-table-Win 
PROCEDURE pi-seta-handle-pai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.

ASSIGN h-handle-pai = p-handle.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc V-table-Win 
PROCEDURE pi-upc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-h-object         as handle        no-undo.
def input param p-h-frame          as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

&IF DEFINED(OriginalName) <> 0 &THEN
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = "{&OriginalName}".
&ELSE
     ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:file-name.
&ENDIF

/* DPC */
if  c-nom-prog-dpc-mg97 <> "" then do:

    run value(c-nom-prog-dpc-mg97) (input p-ind-event,
                                    input p-ind-object,
                                    input THIS-PROCEDURE,
                                    input FRAME f-main:HANDLE,
                                    input p-cod-table,
                                    input p-row-table).
    if  return-value = "NOK":U then
        return "ADM-ERROR":U.
end.                                       


/* APPC */
if  c-nom-prog-appc-mg97 <> "" then do:
    run value(c-nom-prog-appc-mg97)(input p-ind-event,
                                    input p-ind-object,
                                    input THIS-PROCEDURE,
                                    input FRAME f-main:HANDLE,
                                    input p-cod-table,
                                    input p-row-table).
    if  return-value = "NOK":U then
        return "ADM-ERROR":U.
end.

/* UPC */
if  c-nom-prog-upc-mg97 <> ""
and c-nom-prog-upc-mg97 <> ? then do:

    run value(c-nom-prog-upc-mg97) (input p-ind-event,
                                    input p-ind-object,
                                    input THIS-PROCEDURE,
                                    input FRAME f-main:HANDLE,
                                    input p-cod-table,
                                    input p-row-table).
    if  return-value = "NOK":U then
        return "ADM-ERROR":U.
end.   

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-utilizacao V-table-Win 
PROCEDURE pi-utilizacao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF VAR pic-cd-tecnico-ant AS CHAR INITIAL ""  NO-UNDO.
DEF VAR l-ok               AS LOGICAL INIT YES NO-UNDO.

&IF DEFINED (bf_man_204) &THEN        
 if  valid-handle (h-bomn161) THEN DO:
   RUN emptyRowErrors in h-bomn161.

   RUN getTTUtiliza IN h-bomn161(OUTPUT TABLE tt-utiliza).
   IF CAN-FIND(FIRST tt-utiliza) THEN DO:

      IF l-interf-util THEN DO: /* Caso interfira, permitira o usu†rio alterar as informaá‰es */
         DO WHILE l-ok:
            RUN cpp/cp0311mi.w (input-output table tt-utiliza,
                                input  1,
                                input  h-bomn161,
                                output l-ok).
            IF l-ok = NO THEN DO: /* pressionado bot∆o cancela */
               run utp/ut-msgs.p (input "show":u,
                                  input 30133,
                                  input "").
               IF RETURN-VALUE = "YES":U THEN DO:
                  ASSIGN l-ok = YES.
               END.
            END.
            ELSE DO:
               ASSIGN l-ok = NO.
            END.
         END.
      END.
      ELSE DO: /* Caso n∆o interfira, ser† gerada a utilizaá∆o automaticamente */
         FOR EACH tt-utiliza NO-LOCK:
             IF pic-cd-tecnico-ant <> tt-utiliza.cd-tecnico THEN DO:
                RUN verificaTecnicoMI in h-bomn161 (input tt-utiliza.cd-tecnico).
                ASSIGN pic-cd-tecnico-ant = tt-utiliza.cd-tecnico.
             END.
         END.

         RUN getRowErrors IN h-bomn161 (OUTPUT TABLE RowErrors).
         find first rowErrors no-error.
         IF AVAIL rowErrors then do:
               /*{method/showmessage.i1}
               {method/showmessage.i2 &modal=yes}*/
             run utp/ut-msgs.p (input "show":u,
                                input 30132,
                                input "").
         end.
         ELSE DO:
            RUN PropagaUtilizacaoEquipto IN h-bomn161 (INPUT TABLE tt-utiliza, INPUT 1).
         END.
      END.
   END.
 END.
&endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-movto V-table-Win 
PROCEDURE pi-valida-movto :
/*------------------------------------------------------------------------------
  Purpose:     Validaá∆o da existància de movimentaá‰es de MOB, GGF e materiais
               para a ordem que est† sendo reportada.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
define buffer b-movto-dir for movto-dir.
define buffer b-movto-ggf for movto-ggf.
define buffer b-movto-mat for movto-mat.

/** Verificado que no Magnus n∆o utiliza esta validaá∆o **/
/* if ord-prod.reporte-mob = 1 and  */
/*    ord-prod.reporte-ggf = 1 then */

    IF NOT CAN-FIND(FIRST b-movto-dir WHERE   /** MOB **/
                          b-movto-dir.nr-ord-produ = ord-prod.nr-ord-prod NO-LOCK) AND
       NOT CAN-FIND(FIRST b-movto-ggf WHERE   /** GGF **/
                          b-movto-ggf.nr-ord-produ = ord-prod.nr-ord-prod NO-LOCK) AND 
       NOT CAN-FIND(FIRST b-movto-mat WHERE   /** Materiais **/
                          b-movto-mat.nr-ord-produ = ord-prod.nr-ord-prod and 
                          b-movto-mat.esp-doct    <> 1 NO-LOCK) THEN DO:
        RUN utp/ut-msgs.p (INPUT "show":U,
                           INPUT 27731,
                           INPUT STRING(ord-prod.nr-ord-prod)).
        IF RETURN-VALUE = "no":U THEN
            RETURN "adm-error":U.
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem V-table-Win 
PROCEDURE pi-valida-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN Who-Is-The-Container IN adm-broker-hdl
       (INPUT this-procedure,
        OUTPUT c-handle).
    run get-attribute in widget-handle (c-handle) (input "tipo-reporte").           
    run pi-valida-ordem in h-handle (input yes,
                                     input ord-prod.nr-ord-prod,
                                     input int (return-value),
                                     output c-erro,
                                     output c-texto).           
    assign c-retorno = return-value.
    do i-cont = 1 to num-entries (c-erro):
       run utp/ut-msgs.p (input "show",
                          input int (entry (i-cont, c-erro)),
                          input entry (i-cont, c-texto)).
    end.


/************************************
    &IF DEFINED (bf_man_sfc_lc) &THEN

        find first param-global no-lock no-error.
        if  param-global.modulo-ch = yes then do:

            find op-sfc
                where op-sfc.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
            if  avail op-sfc then do:

                find last oper-ord
                    where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
                if  avail oper-ord then do:

                    find grup-maquina
                        where grup-maquina.gm-codigo = oper-ord.gm-codigo no-lock no-error.
                    if  avail grup-maquina
                    and grup-maquina.log-pto-control = yes then do:
                        assign c-retorno = "nok".
                        run utp/ut-msgs.p (input "show",
                                           input 18932,
                                           input "").
                    end.
                end.            
            end.
        end.

    &ENDIF
*******************************/


    return c-retorno.

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

  /* Chamada EPC para a pi-validate */
     {include/i-epc002.i}  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebe-handle V-table-Win 
PROCEDURE recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT PARAMETER h-v44in271 AS HANDLE NO-UNDO.


    ASSIGN wh-v44in271 = h-v44in271.
    
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
  {src/adm/template/snd-list.i "ord-prod"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaBtOk V-table-Win 
PROCEDURE setaBtOk :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
ASSIGN l-bt-ok = YES.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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

  /* Include com os tratamentos necess†rios Ö validaá∆o antes que se 
     habilite os campos                                           */

 {cpp/cp9100.i}
 END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/
  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

