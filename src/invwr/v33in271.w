&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V33IN271 2.00.00.065 } /*** "010065" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v33in271 MUT}
&ENDIF



/*------------------------------------------------------------------------

  File:

  Description: from VIEWER.W - Template for SmartViewer Objects

  Input Parameters:
      <none>

  Output Parameters:f
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
def var da-dt-trans             as date                     no-undo.
def var l-encerra               as logical                  no-undo.
def var l-erro-ver              as logical                  no-undo.
def var l-reserva               as logical                  no-undo.
def var c-it-codigo-aux         as char                     no-undo.
def var c-retorno               as char                     no-undo.
def var i-retorno               as integer                  no-undo.
def var c-erro                  as char                     no-undo.
def var c-texto                 as char                     no-undo.
def var c-campo                 as char                     no-undo.
def var i-cont                  as integer                  no-undo.
def var l-cancelar              as logical                  no-undo.
def var rw-saldo-estoq          as rowid                    no-undo.
def var de-saldo-ped            as decimal                  no-undo.

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

def var l-erro-valid          as logical                no-undo.
def var l-prim-exec           as logical init yes       no-undo.
def var l-zoom                as logical                no-undo.
def var c-lista-estados-operacao as char                no-undo.
def var de-menor-prod         as decimal                no-undo.
def var de-quantidade-reporte as decimal                no-undo.
def var de-saldo-cq           as decimal                no-undo.
def var de-menor-cq           as decimal                no-undo.
def var r-b-oper-ord          as rowid                  no-undo.
def var da-data-ultimo-reporte as date                  no-undo.
def var l-message              as logical               no-undo.
def var l-repete               as logical               no-undo.

DEFINE VARIABLE de-qt-estorno AS DECIMAL     NO-UNDO.

DEFINE VARIABLE c-item-anterior   AS CHARACTER  NO-UNDO. /** pi-muda-item-reporte*/
DEFINE VARIABLE l-undo AS LOGICAL    NO-UNDO.  /** pi-muda-item-reporte, local-cancel-record***/

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
{cpp/cpapi001.i28} /* f-retorna-ult-oper */
{cdp/cd0666.i}
{cpp/cp9060.i}
{cdp/cd9203.i}     /* Function f-item-uni-estab        */

&IF DEFINED (bf_man_204) &THEN
   {mnbo/bomn161.i1} /* tt-Utiliza */
   {method/dbotterr.i} /* rowerrors */
   DEFINE NEW global shared var h-bomn161 as handle    no-undo.
   DEFINE VARIABLE hShowMsg               AS HANDLE    NO-UNDO.
   DEFINE VARIABLE l-interf-util          AS LOGICAL INITIAL NO NO-UNDO.
&endif

def new global shared var h-acomp as handle no-undo.

DEFINE VARIABLE l-first AS LOGICAL INIT YES  NO-UNDO.

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
ord-prod.cod-refer ord-prod.qt-ordem ord-prod.qt-produzida ~
ord-prod.qt-refugada 
&Scoped-define DISPLAYED-TABLES ord-prod
&Scoped-define FIRST-DISPLAYED-TABLE ord-prod
&Scoped-Define DISPLAYED-OBJECTS fi-estado fi-saldo fi-op-codigo ~
fi-descricao-operacao fi-estado-operacao fi-cod-roteiro fi-sequencia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-op-codigo fi-sequencia 
&Scoped-define ADM-MODIFY-FIELDS fi-op-codigo fi-cod-roteiro fi-sequencia 

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
DEFINE VARIABLE fi-cod-roteiro AS CHARACTER FORMAT "x(16)" 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-descricao-operacao AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(20)":U 
     VIEW-AS FILL-IN 
     SIZE 38 BY .88 NO-UNDO.

DEFINE VARIABLE fi-estado-operacao AS CHARACTER FORMAT "X(25)":U 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-op-codigo AS INTEGER FORMAT ">>>>>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE fi-saldo AS DECIMAL FORMAT "->>>>>,>>9.9999" INITIAL 0 
     LABEL "":R15 
     VIEW-AS FILL-IN 
     SIZE 18 BY .88 NO-UNDO.

DEFINE VARIABLE fi-sequencia AS INTEGER FORMAT ">>>9" INITIAL 0 
     LABEL "":R11 
     VIEW-AS FILL-IN 
     SIZE 11 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 6.75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 1.25 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-estado AT ROW 1.25 COL 44 COLON-ALIGNED NO-LABEL
     ord-prod.it-codigo AT ROW 2.33 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.cod-refer AT ROW 2.33 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-ordem AT ROW 3.42 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-produzida AT ROW 3.42 COL 64 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     ord-prod.qt-refugada AT ROW 4.5 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18 BY .88
     fi-saldo AT ROW 4.5 COL 64 COLON-ALIGNED HELP
          "Quantidade original da Reserva"
     fi-op-codigo AT ROW 5.58 COL 16 COLON-ALIGNED
     fi-descricao-operacao AT ROW 5.58 COL 25 COLON-ALIGNED NO-LABEL
     fi-estado-operacao AT ROW 5.58 COL 64 COLON-ALIGNED NO-LABEL
     fi-cod-roteiro AT ROW 6.67 COL 16 COLON-ALIGNED HELP
          "Cï¿½digo do Roteiro"
     fi-sequencia AT ROW 6.67 COL 64 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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
         HEIGHT             = 7
         WIDTH              = 89.
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

/* SETTINGS FOR FILL-IN ord-prod.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cod-roteiro IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN fi-descricao-operacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado-operacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-op-codigo IN FRAME f-main
   NO-ENABLE 1 3                                                        */
/* SETTINGS FOR FILL-IN fi-saldo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-sequencia IN FRAME f-main
   NO-ENABLE 1 3                                                        */
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

&Scoped-define SELF-NAME f-main
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL f-main V-table-Win
ON LEAVE OF FRAME f-main
DO:
   apply "leave":u to fi-op-codigo in frame {&frame-name}. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON F5 OF fi-cod-roteiro IN FRAME f-main
DO:
   apply "F5":u to fi-op-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON LEAVE OF fi-cod-roteiro IN FRAME f-main
DO:    
   apply "leave":u to fi-op-codigo .
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-roteiro IN FRAME f-main
DO:
   apply "F5":u to fi-op-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON F5 OF fi-op-codigo IN FRAME f-main
DO:
  assign i-ordem = ord-prod.nr-ord-prod 
         l-zoom  = yes.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = fi-op-codigo
                     &campozoom  = op-codigo
                     &campo2     = fi-cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = fi-sequencia
                     &campozoom3 = sequencia}
  assign l-zoom = no.                   
  return no-apply.                 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON LEAVE OF fi-op-codigo IN FRAME f-main
DO:

   if (input frame {&frame-name} fi-op-codigo   <> fi-op-codigo   or
       input frame {&frame-name} fi-cod-roteiro <> fi-cod-roteiro or
       input frame {&frame-name} fi-sequencia   <> fi-sequencia)  and
       not(l-zoom) then do:
      assign fi-op-codigo
             fi-cod-roteiro.      

      if input frame {&frame-name} fi-sequencia > 0 
      then do :    
         find first oper-ord 
              where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ                    
                and oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo   
                and oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro 
                and oper-ord.sequencia    = input frame {&frame-name} fi-sequencia
                no-lock no-error. 
         if not avail oper-ord then 
            find oper-ord where
                 oper-ord.nr-ord-prod = ord-prod.nr-ord-prod                      and
                 oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo   and 
                 oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro
                 no-lock no-error.                            
      end.                    
      else do :                     
         for each  oper-ord 
             where oper-ord.nr-ord-prod  = ord-prod.nr-ord-produ no-lock
             by oper-ord.sequencia :
             /* Este for each serve para encontrar a primeira operaï¿½ï¿½o com o codigo
                e o roteiro informados pelo usuï¿½rio com a menor sequencia        */              
             if oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo   and 
                oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro then     
                leave.
         end.         
      end.              
      if avail(oper-ord) 
      then do :              
         assign rw-oper-ord           = rowid(oper-ord)                                                         
                fi-descricao-operacao = oper-ord.descricao
                fi-estado-operacao    = (entry(oper-ord.estado,c-lista-estados-operacao))
                fi-sequencia          = oper-ord.sequencia 
                l-ultima              = if rowid(oper-ord) = r-ult-oper then yes
                                                                        else no.
      end.                                                                  
      else do:
          find oper-ord where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod and
               oper-ord.op-codigo = input frame {&frame-name} fi-op-codigo   no-lock no-error.

          if avail oper-ord then do:
               assign fi-descricao-operacao = oper-ord.descricao
                      fi-estado-operacao    = (entry(oper-ord.estado,c-lista-estados-operacao))
                      fi-cod-roteiro:screen-value in frame {&frame-name} = oper-ord.cod-roteiro
                      fi-sequencia          = oper-ord.sequencia 
                      l-ultima              = no
                      rw-oper-ord           = rowid(oper-ord). 

          end.
          else 
              assign fi-descricao-operacao = ""
                fi-estado-operacao    = ""
                fi-sequencia          = 0 
                l-ultima              = no
                rw-oper-ord           = ? . 
      end.
      run pi-trata-operacoes.
   end.     

   if l-zoom then
      return no-apply.      

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-op-codigo IN FRAME f-main
DO:
   apply "F5":u to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sequencia V-table-Win
ON F5 OF fi-sequencia IN FRAME f-main
DO:
   apply "F5":u to fi-op-codigo.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sequencia V-table-Win
ON LEAVE OF fi-sequencia IN FRAME f-main
DO:
   if (input frame {&frame-name} fi-sequencia <> fi-sequencia) then do :

      assign fi-sequencia.

      find first oper-ord where 
                 oper-ord.nr-ord-prod = ord-prod.nr-ord-prod                     and
                 oper-ord.op-codigo   = input frame {&frame-name} fi-op-codigo   and        
                 oper-ord.cod-roteiro = input frame {&frame-name} fi-cod-roteiro and
                 oper-ord.sequencia   = input frame {&frame-name} fi-sequencia
                 no-lock no-error.
      if avail(oper-ord) then do :
         assign rw-oper-ord           = rowid(oper-ord)                                                         
                fi-descricao-operacao = oper-ord.descricao
                fi-estado-operacao    = (entry(oper-ord.estado,c-lista-estados-operacao))
                l-ultima              = if rowid(oper-ord) = r-ult-oper then yes
                                                                        else no.                        
      end.
      else
         assign rw-oper-ord           = ? 
                fi-descricao-operacao = ""
                fi-estado-operacao    = ""
                l-ultima              = no.      

      run pi-trata-operacoes.          
      if l-zoom or return-value = "ok":u then
         return no-apply.
   end.                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-sequencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-sequencia IN FRAME f-main
DO:
   apply "F5":u to fi-op-codigo in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


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
           item.it-codigo eq ord-prod.it-codigo:SCREEN-VALUE IN  frame {&frame-name} 
           no-lock no-error.   


      RUN pi-muda-item-reporte.

      if avail(item) then do:
         run notify ('pi-habilita-campos,record-target':u).
         run notify ('pi-atualiza-item,record-target':u).
      end.
      else
          run notify ('pi-desabilita-campos,record-target':u).
   end.      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-prod.it-codigo IN FRAME f-main /* Item */
DO:
   apply "F5":u to self.
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

{utp/ut-liter.i Saldo * L}
assign fi-saldo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-ord op-codigo 1}
assign fi-op-codigo:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-ord cod-roteiro 1}
assign fi-cod-roteiro:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind oper-ord sequencia 1}
assign fi-sequencia:label in frame {&frame-name} = RETURN-VALUE.

&if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
    RUN utp/ut-liter.p (trim({ininc/i01in260.i 03}), "*", "").
    assign c-lista-estados-operacao = return-value.
    RUN utp/ut-liter.p (trim({ininc/i01in271.i 03}), "*", "").
    assign c-lista-estados = return-value.
&else
    assign c-lista-estados-operacao = {ininc/i01in260.i 03}
           c-lista-estados          = {ininc/i01in271.i 03}.
&endif

fi-op-codigo:load-mouse-pointer("image/lupa.cur":u).
fi-cod-roteiro:load-mouse-pointer("image/lupa.cur":u).
fi-sequencia:load-mouse-pointer("image/lupa.cur":u).
ord-prod.it-codigo:load-mouse-pointer("image/lupa.cur":u).

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

   /* Code placed here will execute PRIOR to standard behavior. */

  /* Retirado para nao executar a pi-validate automaticamente */ 
  /*  {include/i-valid.i} */

  reporte:
  /** Bloco principal da confirmaï¿½ï¿½o do reporte **/
  do transaction on error undo on stop undo:

      if not avail oper-ord then do:
         {utp/ut-table.i mgind oper-ord 1}
         run utp/ut-msgs.p (input "show":u,
                            input 47,
                            input return-value).
         apply 'entry':u to fi-op-codigo in frame {&frame-name}.
         undo reporte, return "ADM-ERROR":U.
      end.

      RUN set-cursor in adm-broker-hdl ("WAIT":u).

      for each tt-rep-prod:
          delete tt-rep-prod.
      end.

      create tt-rep-prod.
      assign tt-rep-prod.nr-ord-prod       = ord-prod.nr-ord-prod. 

      /* Assign anterior nï¿½o pode esta junto com a function f-retorna-campo, 
         pois ocorre erro de compilaï¿½ï¿½o no progress 9 */  


      assign tt-rep-prod.prog-seg          = "cp0320":u
             tt-rep-prod.tipo              = 2
             tt-rep-prod.carrega-reservas  = l-busca-saldos
             tt-rep-prod.procura-saldos    = l-busca-saldos
             tt-rep-prod.requis-automatica = l-requisicao-automatica
             tt-rep-prod.data              = date (f-retorna-campo ("fi-dt-trans":u))
             tt-rep-prod.un                = ord-prod.un 
             tt-rep-prod.cod-depos-sai     = if l-informa-deposito and
                                                not param-cp.dep-fab-unico then
                                                f-retorna-campo ('fi-cod-depos':u)
                                             else ?
             tt-rep-prod.cod-local-sai     = if l-informa-localizacao then
                                                f-retorna-campo ('fi-cod-localiz':u)
                                             else ?
             tt-rep-prod.op-codigo         = oper-ord.op-codigo
             tt-rep-prod.cod-roteiro       = oper-ord.cod-roteiro
             tt-rep-prod.it-oper           = oper-ord.it-codigo
             tt-rep-prod.qt-reporte        = dec (f-retorna-campo ("fi-quantidade-reporte":u))
             tt-rep-prod.qt-refugo         = dec (f-retorna-campo ("fi-quantidade-refugo":u))
             tt-rep-prod.it-codigo         = INPUT FRAME {&frame-name} ord-prod.it-codigo
             tt-rep-prod.qt-apr-cond       = dec (f-retorna-campo ("fi-quantidade-aprov-cond":u))
             tt-rep-prod.nro-docto         = f-retorna-campo ("fi-nro-docto":u)
             tt-rep-prod.serie-docto       = f-retorna-campo ("fi-serie-docto":u)
             tt-rep-prod.cod-depos         = f-retorna-campo ("fi-cod-depos-acabado":u)
             tt-rep-prod.lote-serie        = f-retorna-campo ("fi-lote-serie-acabado":u)
             tt-rep-prod.cod-refer         = f-retorna-campo ("fi-cod-refer-acabado":u)
             tt-rep-prod.dt-vali-lote      = date (f-retorna-campo ("fi-dt-validade-lote-acabado":u))
             tt-rep-prod.cod-localiz       = f-retorna-campo ("fi-cod-localiz-acabado":u)
             tt-rep-prod.ct-refugo         = f-retorna-campo ("fi-conta-refugo")
             tt-rep-prod.sc-refugo         = f-retorna-campo ("fi-cc-refugo")
             tt-rep-prod.cod-cta-unif	   = f-retorna-campo ("fi-conta-debito-direto")
			 tt-rep-prod.cod-ccusto-unif   = f-retorna-campo ("fi-ccusto-dd")
           &IF DEFINED (bf_man_per_ppm) &THEN
             tt-rep-prod.per-ppm           = dec (f-retorna-campo ("fi-per-ppm-acabado":u))
           &ENDIF
             .

      assign i-retorno = 1.  
      if tt-rep-prod.qt-refugo > 0  then do: 
         RUN set-cursor in adm-broker-hdl ("").      

         if param-global.modulo-cq = yes and
            param-cq.tipo-cq > 1 and
            f-item-uni-estab (input item.it-codigo,
                             input ord-prod.cod-estabel,
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
                             input ord-prod.cod-estabel,
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

      run pi-valida-rep-prod in h-handle (input  yes,
                                          input  ord-prod.nr-ord-prod,
                                          output c-erro,
                                          output c-texto).

      assign c-retorno = return-value.       

      RUN set-cursor in adm-broker-hdl ("").                               

      /****** Verifica se jï¿½ existe ficha de CQ para Item/Lote *****/
      run pi-valida-ficha-cq in h-handle (input yes).

      if tt-rep-prod.qt-reporte - tt-rep-prod.qt-refugo > 0 then do:

          if param-cp.log-ficha-ord then do:

              run pi-valida-ficha-cq in h-handle (input NO).

              if item.tipo-con-est = 3 or
                 item.tipo-con-est = 4 then do:

                  find first oper-ord 
                    where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ                    
                    and oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo   
                    and oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro 
                    and oper-ord.sequencia    = input frame {&frame-name} fi-sequencia
                    no-lock no-error. 

                  find first ficha-cq 
                       where ficha-cq.it-codigo   = tt-rep-prod.it-codigo
                       and   ficha-cq.cod-estabel = ord-prod.cod-estabel
                       and   ficha-cq.cod-depos   = tt-rep-prod.cod-depos
                       and   ficha-cq.cod-localiz = tt-rep-prod.cod-localiz
                       and   ficha-cq.lote        = tt-rep-prod.lote-serie
                       AND   ficha-cq.situacao    < 4 
                       AND   ficha-cq.op-seq      = oper-ord.sequencia 
                       NO-LOCK no-error.

                  if avail ficha-cq then do: 
                      run utp/ut-msgs.p (input "show":u,
                                         input 19503,
                                         input "").

                      run pi-valida-ficha-cq in h-handle (input (RETURN-VALUE = "YES")).
                  end.
              end.
          end.
      end. /* Quantidade CQ > 0 */
      else
          run pi-valida-ficha-cq in h-handle (input  no).

      if c-retorno = "nok":u then do:
         case int (entry (1, c-erro)):
              when 56 then do:
                   {utp/ut-table.i mgind localizacao 1}
                   if entry (1, c-texto) = return-value then
                      assign c-campo = "fi-cod-localiz-acabado":u.
                   {utp/ut-liter.i Conta_Cont bil * R }
                   if entry (1, c-texto) = return-value then
                      assign c-campo = "fi-conta-debito-direto":u.
              end.

              when 166 or when 563 or when 693 or when 3454 then 
                   apply 'entry':u to ord-prod.it-codigo in frame {&frame-name}.

              when 106 or when 6610 then assign c-campo = "fi-conta-debito-direto":u.

              when 530 or when 3412 then 
                   assign c-campo = "fi-cod-depos":u.

              when 847 or when 1234 or when 2372 or when 5808 then 
                   assign c-campo = "fi-quantidade-reporte":u.

              when 3428 then
                   assign c-campo = "fi-quantidade-refugo":u.

              when 2386 or when 2387 or when 2388 then
                   assign c-campo = "fi-conta-refugo":u.

              when 2389 or when 2390 then 
                   assign c-campo = "fi-quantidade-aproc-cond":u.

              when 2403 or when 7410 then
                   assign c-campo = "fi-cod-depos-acabado":u.

              when 2793 then
                   assign c-campo = "fi-dt-trans":u.

              when 1252 or when 2408 or when 2158 then
                   assign c-campo = "fi-lote-serie-acabado":u.

              when 529 or when 1235 or when 1236 then
                   assign c-campo = "fi-cod-refer-acabado":u.

              when 1247 or when 2409 or when 2410 then
                   assign c-campo = "fi-dt-validade-lote-acabado":u.

              otherwise assign c-campo = "".
         end case.

         run set-attribute-list ("campo=":u + c-campo).

         if c-campo <> "" then     
            run notify ('pi-apply-entry,record-target':u).
      end.

      do i-cont = 1 to num-entries (c-erro):
         run utp/ut-msgs.p (input "show":u,
                            input int (entry (i-cont, c-erro)),
                            input entry (i-cont, c-texto)).
      end.

      if c-retorno = "nok":u then undo reporte, return "ADM-ERROR":U.

      run pi-validate.
      if return-value eq "adm-error":u then undo reporte, return "ADM-ERROR":U.

      run notify ('pi-validate,record-target':u).

      if return-value = "adm-error":u then
         undo reporte, return "ADM-ERROR":U.

      assign c-retorno = "".

      /* Chamada EPC para a assign record */
         {include/i-epc003.i}

      run notify ('pi-grava-arquivos,record-target':u). 

      run utp/ut-acomp.p persistent set h-acomp.

      run pi-inicializar in h-acomp ("Processando Reporte":u).

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

      find first tt-erro no-error.
      if avail tt-erro then
         run cdp/cd0666.w (input table tt-erro).
      else do:
          /********************* CHAMADA UPC *********************/
{utp/ut-liter.i Qtde-rep *}
          /** Chamada referente ï¿½s chamadas X do Magnus do CP0320
              "Ficha-cq" e  Return-value  FO 825.431 - Magistral **/

          RUN pi-upc (INPUT "row-ord-prod",
                      INPUT "row-ord-prod",
                      INPUT ?,
                      INPUT ?,
                      INPUT "ord-prod",
                      INPUT ROWID(ord-prod)).

          RUN pi-upc (INPUT "row-oper-ord",
                      INPUT "row-oper-ord",
                      INPUT ?,
                      INPUT ?,
                      INPUT "oper-ord",
                      INPUT ROWID(oper-ord)).

          if return-value = "NOK":U then
             undo reporte, return "adm-error":U.

          /******************************************************/
      end.

      if c-retorno = "nok":u then
          undo reporte, return "adm-error":U.

      RUN pi-valida-movto.

      if return-value = "adm-error":U then
         undo reporte, return "adm-error":U.

  end.  /** Bloco reporte **/

  /* Code placed here will execute AFTER standard behavior.    */

  RUN dispatch IN THIS-PROCEDURE ('display-fields':U).

  find first tt-rep-prod.

  if rowid (oper-ord) = f-retorna-ult-oper (input ord-prod.nr-ord-prod) then do:   

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

     if l-requisicao-automatica  and
        not can-find(first al-res-op where 
                           al-res-op.nr-ord-prod = ord-prod.nr-ord-prod) and
        item.tipo-requis = 1     then do:
        run cpp/cp0311f.w (input rowid(ord-prod)      ,
                           input tt-rep-prod.cod-depos,
                           input tt-rep-prod.lote-serie,
                           input tt-rep-prod.cod-localiz,
                           input tt-rep-prod.data,
                           input tt-rep-prod.qt-reporte).                 
        if return-value eq "adm-error":u then return return-value.
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
                 run utp/ut-msgs.p (input "show":u,
                                    input 6030  ,
                                    input ""    ).
                 if return-value eq "yes":u then assign l-repete = yes.
                                          else assign l-repete = no .                
              end.                             
              else assign l-repete = no.
           end.              
        end.                                                             
     end. 
  end.         

  RUN pi-utilizacao.  /* a partir da 2.04 */

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

  assign l-cancelar = YES
         l-undo = YES.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'cancel-record':U ) .

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
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  assign fi-cod-roteiro:screen-value        = ""
         fi-cod-roteiro                     = ""  
         fi-descricao-operacao:screen-value = ""
         fi-descricao-operacao              = ""
         fi-estado-operacao:screen-value    = ""
         fi-estado-operacao                 = "" 
         fi-op-codigo:screen-value          = ""
         fi-op-codigo                       = 0 
         fi-sequencia:screen-value          = ""
         fi-sequencia                       = 0.        

  run notify ('pi-desabilita-campos,record-target':u).
  run notify ('pi-desabilita-browse-mob,record-target':u).                                                                       

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

  &IF DEFINED (bf_man_per_ppm) &THEN
    def var h-viewer  as handle no-undo.
    def var l-per-ppm as log    no-undo.
  &ENDIF

  if avail(ord-prod) then do:
     assign fi-estado = entry(ord-prod.estado,c-lista-estados).  
     assign fi-saldo  = if ord-prod.qt-ordem - ord-prod.qt-produzida > 0
                           then ord-prod.qt-ordem - ord-prod.qt-produzida
                           else 0.                                         
     &IF DEFINED (bf_man_per_ppm) &THEN
         find item where 
              item.it-codigo = ord-prod.it-codigo                     
              no-lock no-error.
         if avail(item) then do:
             assign l-per-ppm = (param-global.modulo-per-ppm and
                                 item.tipo-formula >= 2      and
                                 item.tipo-formula <= 3).
             run pi-retorna-handle (output h-viewer).
             if valid-handle (h-viewer) then
                 run pi-formata-tela in h-viewer (input if not l-per-ppm then 1
                                                                         else 2,
                                                  input if not l-per-ppm then 0
                                                                         else item.tipo-formula).
         end.
     &ENDIF

  end.                           

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
   IF NOT l-undo AND AVAIL ord-prod THEN
        ASSIGN c-item-anterior = ord-prod.it-codigo.

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
     return "adm-error":u.
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
             /*Esta ordem jï¿½ possui reportes no Chï¿½o de Fï¿½brica. Por este motivo, 
             o reporte de todas as operaï¿½ï¿½es da ordem deve ser feito atravï¿½s do mï¿½dulo Chï¿½o de Fï¿½brica.*/
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
            return "adm-error":u.
         end.
  &ENDIF


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  for each tt-ref-ordem:
      delete tt-ref-ordem.
  end.

  IF NOT AVAIL param-cp THEN
     FIND FIRST param-cp NO-LOCK NO-ERROR.

  IF AVAIL param-cp THEN
  assign ord-prod.it-codigo:sensitive in frame {&frame-name} = (param-cp.pede-item and NOT can-find(movto-estoq where
                                                                                                    movto-estoq.nr-ord-produ = ord-prod.nr-ord-produ and
                                                                                                    movto-estoq.esp-docto = 1)).
  ASSIGN c-it-codigo-aux = ord-prod.it-codigo.

  find item where item.it-codigo = ord-prod.it-codigo no-lock no-error.

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

  if rowid (oper-ord) = f-retorna-ult-oper (input ord-prod.nr-ord-prod) then do:  
     /* Altera Estado da Ordem de Producao para Terminada/Finalizada ? */
     run utp/ut-msgs.p (input "show":u,
                        input (if not param-global.modulo-cs then
                                 5603
                               else 5604),
                        input trim(STRING(ord-prod.nr-ord-produ,">>>,>>>,>>9"))).
     if return-value = "yes":u then do:
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
                                 input "2":u                ,
                                 input ord-prod.qt-reportada,
                                 input yes                  ,
                                 input i-baixa-reservas      ).
              if l-erro-ver then return "adm-error":u.
           end.
        end.
        for each  b-oper-ord
            where b-oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
            no-lock by b-oper-ord.sequencia:
            leave.
        end.
        if can-find (first oper-ord 
                     where oper-ord.nr-ord-prod  = ord-prod.nr-ord-prod
                       and oper-ord.qt-produzida < b-oper-ord.qt-produzida) then do:
           run utp/ut-msgs.p (input "show":u,
                              input 16715,
                              input "").
           if return-value = "yes":u then
              run pi-finaliza-ordem in h-handle (input ord-prod.nr-ord-prod).
           else do:
                if oper-ord.estado <> 3 then do:
                   find current oper-ord exclusive-lock.
                   /* Finaliza Operacao da Ordem ? */
                   run utp/ut-msgs.p (input "show",
                                      input 3446  ,
                                      input ""    ).
                   assign oper-ord.estado = if return-value = "yes":u then 3 else 2.
                end.
           end.           
        end.
        else run pi-finaliza-ordem in h-handle (input ord-prod.nr-ord-prod).
     end.
     else do:     
          if oper-ord.estado <> 3 then do:
             find current oper-ord exclusive-lock.
             /* Finaliza Operacao da Ordem ? */
             run utp/ut-msgs.p (input "show":u,
                                input 3446  ,
                                input ""    ).
             assign oper-ord.estado = if return-value = "yes":u then 3 else 2.
          end.
     end. 
  end.
  else do:
       if oper-ord.estado <> 3 then do:
          find current oper-ord exclusive-lock.
          /* Finaliza Operacao da Ordem ? */
          run utp/ut-msgs.p (input "show":u,
                             input 3446  ,
                             input ""    ).
          assign oper-ord.estado = if return-value = "yes":u then 3 else 2.                             
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
                                    "op":u + string (ord-prod.nr-ord-prod, "999999")
                                 else c-arquivo-saida
            tt-param.item-ini  = ord-prod.it-codigo
            tt-param.item-fim  = ord-prod.it-codigo
            tt-param.data-ini  = date (f-retorna-campo ("fi-dt-trans":u))
            tt-param.data-fim  = date (f-retorna-campo ("fi-dt-trans":u))
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
                         input "cpp/cp0332rp.p":u,
                         input c-versao-mg97,
                         input 97,
                         input tt-param.arquivo,
                         input tt-param.destino,
                         input raw-param,
                         input table tt-raw-digita,
                         output i-num-ped-exec-rpw).

     if i-num-ped-exec-rpw <> 0 then                     
        run utp/ut-msgs.p (input "show":u, 
                           input 4169, 
                           input string(i-num-ped-exec-rpw)).                      
  end.   

  run dispatch ('display-fields':u).                      

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

  if not l-cancelar then do:
     assign fi-op-codigo   = 0
            fi-cod-roteiro = ""
            fi-sequencia   = 0.
     run dispatch ('display-fields':u).
     run dispatch ('enable-fields':u).
     run notify ('pi-desabilita-campos,record-target':u).
  end.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-muda-item-reporte V-table-Win 
PROCEDURE pi-muda-item-reporte :
/*------------------------------------------------------------------------------
  Purpose: mudar o item da ordem atraves da cpapi001(h-handle)    
  Parameters:  buffer de registro da tt-rep-prod e 
               byffer de registro da ordem de producao
  Notes:       
------------------------------------------------------------------------------*/
    FIND ord-prod WHERE rowid(ord-prod) = gr-ord-prod NO-LOCK NO-ERROR.

    IF NOT l-undo THEN DO:
        ASSIGN c-item-anterior = ord-prod.it-codigo.
    END.
    RUN pi-muda-item-reporte IN h-handle(INPUT ord-prod.nr-ord-produ,
                                         INPUT IF l-undo 
                                               THEN c-item-anterior 
                                               ELSE ord-prod.it-codigo:SCREEN-VALUE IN FRAME {&frame-name},
                                         OUTPUT c-erro,
                                         OUTPUT c-texto ).

    IF RETURN-VALUE <> "OK" THEN DO:
       do i-cont = 1 to num-entries (c-erro):
          run utp/ut-msgs.p (input "show":U,
                             input int (entry (i-cont, c-erro)),
                             input entry (i-cont, c-texto)).
       end.

       RETURN "ADM-ERROR":U.
    END.
    ASSIGN l-undo = NO.

    RETURN "OK".


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

run get-attribute in widget-handle (c-handle) (input 'HANDLE':u).

assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-handle V-table-Win 
PROCEDURE pi-retorna-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def output param p-handle as handle.

def var c-handle as char   no-undo.
def var h-handle as handle no-undo.
def var h-frame  as handle no-undo.
def var i-cont   as int    no-undo.

    run who-is-the-container in adm-broker-hdl (input this-procedure, output c-handle).
    assign h-handle = widget-handle(c-handle).

    run get-link-handle in adm-broker-hdl (input  h-handle, 
                                           input  "container-target":U,
                                           output c-handle).
    do i-cont = 1 to num-entries(c-handle):
        assign h-handle = widget-handle(entry(i-cont,c-handle)).
        if h-handle:file-name = "invwr/v38in271.w":u then
            assign p-handle = h-handle.
    end.    

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-trata-operacoes V-table-Win 
PROCEDURE pi-trata-operacoes :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

      display fi-descricao-operacao 
              fi-estado-operacao
              fi-sequencia
              with frame {&frame-name}.                                       

      if rw-oper-ord <> ? 
         then do:
             run set-attribute-list in this-procedure (input "RW-OPER=":u + string (rw-oper-ord)).  

             /* Calcula quantidade a ser reportada */
             find first pert-ordem where
                        pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ and 
                        pert-ordem.it-codigo    = oper-ord.it-codigo    and 
                        pert-ordem.cod-roteiro  = oper-ord.cod-roteiro  and 
                        pert-ordem.op-codigo    = oper-ord.op-codigo
                        no-lock no-error.
             find first b-oper-ord where 
                        b-oper-ord.nr-ord-produ = pert-ordem.nr-ord-produ and 
                        b-oper-ord.it-codigo    = pert-ordem.it-predec    and 
                        b-oper-ord.cod-roteiro  = pert-ordem.rot-predec   and 
                        b-oper-ord.op-codigo    = pert-ordem.op-predec
                        no-lock no-error.
             if avail b-oper-ord then 
                assign de-menor-prod = b-oper-ord.qt-produzida.                       

             assign de-quantidade-reporte = 0
                    de-saldo-cq           = 0
                    de-menor-cq           = 0
                    r-b-oper-ord          = if avail b-oper-ord then rowid(b-oper-ord)
                                                                else ?.                        
             for each pert-ordem where 
                      pert-ordem.nr-ord-produ = ord-prod.nr-ord-produ and
                      pert-ordem.it-codigo    = oper-ord.it-codigo    and
                      pert-ordem.cod-roteiro  = oper-ord.cod-roteiro  and
                      pert-ordem.op-codigo    = oper-ord.op-codigo    
                      no-lock:
                find first b-oper-ord where 
                           b-oper-ord.nr-ord-produ = pert-ordem.nr-ord-produ and
                           b-oper-ord.it-codigo    = pert-ordem.it-predec    and
                           b-oper-ord.cod-roteiro  = pert-ordem.rot-predec   and
                           b-oper-ord.op-codigo    = pert-ordem.op-predec
                           no-lock no-error.

                if b-oper-ord.qt-produzida < de-menor-prod then
                   assign de-menor-prod = b-oper-ord.qt-produzida
                          r-b-oper-ord  = rowid(b-oper-ord).                            

                
                FOR EACH ficha-cq FIELDS(nr-ficha nr-ord-produ origem op-seq qt-aprovada qt-apr-cond situacao)
                    WHERE ficha-cq.nr-ord-produ = b-oper-ord.nr-ord-prod
                      AND ficha-cq.op-seq       = b-oper-ord.sequencia
                      AND ficha-cq.origem       = 3
                      AND ficha-cq.situacao    <> 5 NO-LOCK:

                    FOR EACH ord-rep FIELDS(nr-ord-produ nr-ficha nr-reporte)
                        WHERE ord-rep.nr-ord-produ = ficha-cq.nr-ord-produ
                          AND ord-rep.nr-ficha     = ficha-cq.nr-ficha NO-LOCK:

                        FOR EACH rep-prod FIELDS(nr-reporte qt-estorno)
                            WHERE rep-prod.nr-reporte = ord-rep.nr-reporte
                              AND rep-prod.qt-estorno > 0 NO-LOCK:
                            ASSIGN de-qt-estorno = de-qt-estorno + rep-prod.qt-estorno.
                        END.
                    END.

                    ASSIGN de-saldo-cq   = de-saldo-cq + ficha-cq.qt-aprovada + ficha-cq.qt-apr-cond - de-qt-estorno
                           de-qt-estorno = 0.
                END.

                if de-saldo-cq < de-menor-cq or de-menor-cq = 0 then
                      assign de-menor-cq = de-saldo-cq.
             end.

             assign de-saldo-cq = de-menor-cq.                     

             /* Busca a operacao anterior com menor quantidade reportada */
             find b-oper-ord where rowid(b-oper-ord) = r-b-oper-ord no-lock no-error.   
             if not avail b-oper-ord then
                assign de-quantidade-reporte  = ord-prod.qt-ordem - oper-ord.qt-produzida.
             else do:
                if de-saldo-cq <> 0 
                then                             
                   assign de-quantidade-reporte  = de-saldo-cq - oper-ord.qt-produzida.
                else                             
                   assign de-quantidade-reporte  = b-oper-ord.qt-produzida - oper-ord.qt-produzida.

                assign da-data-ultimo-reporte    = b-oper-ord.dt-reporte .               
             end.

             if de-quantidade-reporte < 0 then 
                assign de-quantidade-reporte = 0.

             ASSIGN de-quantidade-reporte = de-quantidade-reporte * 10000.

             /* de-quantidade-reporte*/

             run set-attribute-list in this-procedure ('quant-reporte=':u + string (de-quantidade-reporte)).

             run notify ('pi-habilita-campos,record-target':u).

             /* So habilita o browse de MOB para operacoes internas */                                                 
             if param-global.modulo-cs      and 
                param-global.modulo-ce      and
                ((ord-prod.reporte-mob = 1  and oper-ord.cd-mob-dir <> "") or
                  ord-prod.reporte-ggf = 1) and
                oper-ord.tipo = 1        
             then              
                 run notify ('pi-habilita-browse-mob,record-target':u).                                                                                                  
             else                                                 
                 run notify ('pi-desabilita-browse-mob,record-target':u).
             return "ok":u.
         end.                                                            
         else do:
              run notify ('pi-desabilita-campos,record-target':u).
              run notify ('pi-desabilita-browse-mob,record-target':u).
              return "nok":u.
         end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-upc V-table-Win 
PROCEDURE pi-upc :
/**********************************************************************
** UPC Especifica
** Podem ser passados parametros para ela afim de reutilizar o codigo
** se houver necessidade.
**********************************************************************/ 
def input param p-ind-event        as char          no-undo.
def input param p-ind-object       as char          no-undo.
def input param p-wgh-object       as handle        no-undo.
def input param p-wgh-frame        as widget-handle no-undo.
def input param p-cod-table        as char          no-undo.
def input param p-row-table        as rowid         no-undo.

    /* DPC */
    if  c-nom-prog-dpc-mg97 <> ""
    and c-nom-prog-dpc-mg97 <> ? then do:

        run value(c-nom-prog-dpc-mg97) (input p-ind-event,
                                        input p-ind-object,
                                        input THIS-PROCEDURE,
                                        input FRAME f-main:HANDLE,
                                        input p-cod-table,
                                        input p-row-table).

    end.

    /* APPC */
    if  c-nom-prog-appc-mg97 <> ""
    and c-nom-prog-appc-mg97 <> ? then do:

        run value(c-nom-prog-appc-mg97) (input p-ind-event,
                                         input p-ind-object,
                                         input THIS-PROCEDURE,
                                         input FRAME f-main:HANDLE,
                                         input p-cod-table,
                                         input p-row-table).

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

      IF l-interf-util THEN DO: /* Caso interfira, permitira o usuï¿½rio alterar as informaï¿½ï¿½es */
         DO WHILE l-ok:
            RUN cpp/cp0311mi.w (input-output table tt-utiliza,
                                input  1,
                                input  h-bomn161,
                                output l-ok).
            IF l-ok = NO THEN DO: /* pressionado botï¿½o cancela */
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
      ELSE DO: /* Caso nï¿½o interfira, serï¿½ gerada a utilizaï¿½ï¿½o automaticamente */
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
  Purpose:     Validaï¿½ï¿½o da existï¿½ncia de movimentaï¿½ï¿½es de MOB, GGF e materiais
               para a ordem que estï¿½ sendo reportada.
  Parameters: 
  Notes:       
------------------------------------------------------------------------------*/
define buffer b-movto-dir for movto-dir.
define buffer b-movto-ggf for movto-ggf.
define buffer b-movto-mat for movto-mat.

/** Verificado que no Magnus nï¿½o utiliza esta validaï¿½ï¿½o **/
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

    RUN Who-Is-The-Container IN adm-broker-hdl (INPUT this-procedure,
                                                OUTPUT c-handle).

    run get-attribute in widget-handle (c-handle) (input "tipo-reporte":u).           

    run pi-valida-ordem in h-handle (input yes,
                                     input ord-prod.nr-ord-prod,
                                     input int (return-value),
                                     output c-erro,
                                     output c-texto).
    assign c-retorno = return-value.

    do i-cont = 1 to num-entries (c-erro):
       run utp/ut-msgs.p (input "show":u,
                          input int (entry (i-cont, c-erro)),
                          input entry (i-cont, c-texto)).
    end.

/***************
    &IF DEFINED (bf_man_sfc_lc) &THEN

        find first param-global no-lock no-error.
        if  param-global.modulo-ch = yes then do:

            find op-sfc
                where op-sfc.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
            if  avail op-sfc then do:
                assign c-retorno = "nok":u.
                run utp/ut-msgs.p (input "show":u,
                                   input 18932,
                                   input "").
            end.
        end.

    &ENDIF
********************/

    return c-retorno.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: Nï¿½o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaï¿½ï¿½es, pois neste ponto do programa o registro 
  ainda nï¿½o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaï¿½ï¿½o de dicionï¿½rio */

  /* Chamada EPC para a pi-validate */
     {include/i-epc002.i}  

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE state-changed V-table-Win 
PROCEDURE state-changed :
/* -----------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
-------------------------------------------------------------*/
  DEFINE INPUT PARAMETER p-issuer-hdl AS HANDLE    NO-UNDO.
  DEFINE INPUT PARAMETER p-state      AS CHARACTER NO-UNDO.

  /* Include com os tratamentos necessï¿½rios ï¿½ validaï¿½ï¿½o antes que se 
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

