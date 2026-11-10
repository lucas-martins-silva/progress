&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
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
{include/i-prgvrs.i V04IN271 2.00.02.041 } /*** "010241" 01/09/2026 09:47:22 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v04in271 MUT}
&ENDIF


/*-----------------------------------------------------------------------

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

{cdp/cd9203.i}
def var teste as decimal no-undo.
def new global shared var gr-ord-prod  as rowid  no-undo.
def new global shared var h-acomp      as handle no-undo.
def new global shared var gr-op-sfc    as rowid no-undo.
def new global shared var gr-estabelec as rowid no-undo.
def new global shared var v_cod_usuar_corren like usuar_mestre.cod_usuario no-undo.
def var l-aloca    as logical no-undo.
def var l-lote-min as logical no-undo.
def var l-lote-mult as logical no-undo.
def var l-perda    as logical no-undo.
def var l-refugo   as logical no-undo.
def var i-idi-dtsul as integer no-undo.
def var c-handle   as char no-undo.
def var h-handle   as handle no-undo.
def var h-cpapi301 as handle no-undo.
def var i-aux      as integer no-undo.
def var c-retorno  as char no-undo.
def var c-erro     as char no-undo.
def var c-texto    as char no-undo.
def var c-campo    as char no-undo.
def var i-cont1    as integer no-undo.
def var i-ordem    as integer no-undo.
def var l-conta    as logical no-undo.
def var l-res-conf as logical no-undo.
def var l-ord-conf as logical no-undo.
def var i-ord-erro as integer no-undo.
def var c-conta    as char    no-undo.
def var c-linha    as char    no-undo.
def var l-linha    as logical no-undo.
def var l-copia    as logical no-undo. 
def var l-movto    as logical no-undo.
DEF VAR l-alocado  AS LOGICAL NO-UNDO.
def var l-atualiza as logical initial no no-undo.
def var i-cont     as int no-undo.
def var c-aux      as char no-undo.
def var de-qt-ordem-init  as decimal no-undo.
def var i-empresa-prin LIKE mguni.empresa.ep-codigo no-undo.
def var c-cod-estabel   like estabelec.cod-estabel no-undo.
def var c-cod-estab-aux like item.cod-estabel.
DEF VAR c-item          LIKE ITEM.it-codigo NO-UNDO.
/* FO 1307839 */
def var h-boin533     as handle no-undo.
def var h-bosc038 as handle         no-undo.
def var l-docto-wms as logical      no-undo.

/** UnificaÁ„o de Conceitos **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}  
DEFINE VARIABLE d-dt-valida AS DATE NO-UNDO.

DEFINE VARIABLE cLista AS CHARACTER  NO-UNDO.
DEFINE VARIABLE clista-aux AS CHARACTER  NO-UNDO.
DEFINE VARIABLE  i AS INTEGER INIT 0   NO-UNDO.
DEFINE VARIABLE l-habilita-qtd AS LOG INIT YES NO-UNDO.
DEF VAR i-est        AS INT NO-UNDO.
DEFINE BUFFER b-ord-prod FOR ord-prod.


/*___________________variaveis necess†rias para a integraá∆o com investimentos_________*/
def            var l-achou         as logical.
def new shared var i-ct-conta      like ord-prod.ct-codigo.
def new shared var i-sc-conta      like ord-prod.sc-codigo.
/*______________________________________________________________________________________*/
{cdp/cdcfgman.i} /* Miniflexibilizaá∆o. Utilizado no EMS 2.02 - N«O ELIMINAR */
{cdp/cdcfgmat.i} /* Preprocessador bf_mat_conta_estab */

def temp-table tt-proces-item no-undo like proces-item.  
{cpp/cpapi301.i7} /* GerarListaProcesItem */

/* API - Criaá∆o ORD-PROD */
{cpp/cpapi301.i}   /* Definiá∆o das temp-tables */
{cpp/cpapi301.i20} /* f-gera-numero-op */
{cpp/cpapi301.i23} /* f-adiciona-lista */
{cdp/cd0666.i}     /* Definiá∆o temp-table de erros */
{cpp/cpapi301.i21} /* pi-valida-ord-prod */
def temp-table tt-copia NO-UNDO like tt-ord-prod.

def var i-qtd-ant as integer format ">>>>>,>>9.9999".
DEFINE VARIABLE i-estado AS INTEGER    NO-UNDO.

DEFINE VARIABLE l-usa-unid-negoc AS LOGICAL    NO-UNDO.
DEFINE VARIABLE c-unid-negocio   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE l-upc-16415      AS LOGICAL     NO-UNDO.
DEFINE VARIABLE l-ret-gera       AS LOGICAL     NO-UNDO.
DEFINE VARIABLE c-traducao AS CHARACTER   NO-UNDO.

DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE h-pag-2 AS HANDLE     NO-UNDO.
DEF BUFFER b-reservas FOR reservas.

DEFINE SHARED VARIABLE l-new-ordem AS LOGICAL     NO-UNDO.

/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/
&scoped-define TTONLY YES
{include/i-estab-security.i}
/******************************************************************************************
** TECNICA SEGURANCA ESTABELECIMENTO
******************************************************************************************/


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
&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-OBJECTS fi-nr-ord-produ fi-it-codigo fi-qt-ordem ~
fi-un cb-tipo cb-estado fi-nr-linha fi-cod-refer fi-descricao ~
fi-conta-ordem fi-ccusto cb-rep-prod cb-sit-aloc fi-cod-estabel ~
fi-cod-depos fi-cd-planejado 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-nr-ord-produ 
&Scoped-define ADM-ASSIGN-FIELDS fi-nr-ord-produ fi-it-codigo fi-qt-ordem ~
fi-un cb-tipo cb-estado fi-nr-linha fi-cod-refer fi-conta-ordem fi-ccusto ~
cb-rep-prod cb-sit-aloc fi-cod-estabel fi-cod-depos fi-cd-planejado 
&Scoped-define ADM-MODIFY-FIELDS fi-it-codigo fi-qt-ordem fi-un cb-tipo ~
cb-estado fi-nr-linha fi-cod-refer fi-conta-ordem fi-ccusto cb-rep-prod ~
cb-sit-aloc fi-cod-estabel fi-cod-depos fi-cd-planejado 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-formato-campo V-table-Win 
FUNCTION f-formato-campo RETURNS CHARACTER
  ( input c-campo as char,
    input i-tipo  as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char)  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE cb-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE cb-rep-prod AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-sit-aloc AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 17 BY 1 NO-UNDO.

DEFINE VARIABLE fi-ccusto AS CHARACTER FORMAT "x(20)" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE fi-cd-planejado AS CHARACTER FORMAT "x(12)" 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE fi-cod-depos AS CHARACTER FORMAT "x(3)" 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE fi-cod-estabel AS CHARACTER FORMAT "x(3)" 
     LABEL "":R18 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE fi-cod-refer AS CHARACTER FORMAT "x(8)" 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 12.43 BY .88.

DEFINE VARIABLE fi-conta-ordem AS CHARACTER FORMAT "x(20)" 
     LABEL "":R14 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88.

DEFINE VARIABLE fi-descricao AS CHARACTER FORMAT "x(255)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE fi-nr-linha AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88.

DEFINE VARIABLE fi-nr-ord-produ AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "":R17 
     VIEW-AS FILL-IN 
     SIZE 17 BY .88.

DEFINE VARIABLE fi-qt-ordem AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R10 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88.

DEFINE VARIABLE fi-un AS CHARACTER FORMAT "xx" 
     LABEL "":R11 
     VIEW-AS FILL-IN 
     SIZE 5.43 BY .88.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.25.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 86 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 33 BY 6.67.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 52.72 BY 6.67.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-nr-ord-produ AT ROW 1.25 COL 23 COLON-ALIGNED
     fi-it-codigo AT ROW 2.58 COL 23 COLON-ALIGNED
     fi-qt-ordem AT ROW 4 COL 13.86 COLON-ALIGNED
     fi-un AT ROW 5 COL 13.86 COLON-ALIGNED
     cb-tipo AT ROW 6 COL 13.86 COLON-ALIGNED
     cb-estado AT ROW 7.17 COL 13.86 COLON-ALIGNED
     fi-nr-linha AT ROW 8.29 COL 13.86 COLON-ALIGNED
     fi-cod-refer AT ROW 9.29 COL 13.86 COLON-ALIGNED
     fi-descricao AT ROW 2.58 COL 43 COLON-ALIGNED NO-LABEL
     fi-conta-ordem AT ROW 4 COL 46.29 COLON-ALIGNED
     fi-ccusto AT ROW 4 COL 65.43 COLON-ALIGNED NO-LABEL WIDGET-ID 2
     cb-rep-prod AT ROW 5 COL 46.29 COLON-ALIGNED
     cb-sit-aloc AT ROW 6.13 COL 46.29 COLON-ALIGNED
     fi-cod-estabel AT ROW 7.21 COL 46.43 COLON-ALIGNED
     fi-cod-depos AT ROW 8.17 COL 46.43 COLON-ALIGNED
     fi-cd-planejado AT ROW 9.17 COL 46.43 COLON-ALIGNED
     RECT-1 AT ROW 2.42 COL 1
     rt-key AT ROW 1.08 COL 1
     rt-mold AT ROW 3.75 COL 1
     rt-mold-2 AT ROW 3.75 COL 34.29
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
         HEIGHT             = 9.58
         WIDTH              = 86.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{include/i-auxtab.i}
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}
{btb/btb008za.i0}

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

/* SETTINGS FOR COMBO-BOX cb-estado IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-rep-prod IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-sit-aloc IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR COMBO-BOX cb-tipo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-ccusto IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cd-planejado IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-depos IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-cod-refer IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-conta-ordem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-nr-linha IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-nr-ord-produ IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-qt-ordem IN FRAME f-main
   NO-ENABLE 2 3                                                        */
/* SETTINGS FOR FILL-IN fi-un IN FRAME f-main
   NO-ENABLE 2 3                                                        */
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

&Scoped-define SELF-NAME cb-estado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-estado V-table-Win
ON VALUE-CHANGED OF cb-estado IN FRAME f-main
DO:  
    
   if not adm-new-record THEN  DO:
       FOR FIRST b-ord-prod
           WHERE b-ord-prod.nr-ord-prod = int(INPUT fi-nr-ord-produ:screen-value) NO-LOCK:
       END.
       
       IF (AVAIL b-ord-prod and
           int(b-ord-prod.estado) > 2 )
          OR cb-estado:lookup (cb-estado:screen-value in frame {&frame-name}) > 2 THEN
           ASSIGN fi-qt-ordem:sensitive in frame {&frame-name} = NO.
       ELSE 
           ASSIGN fi-qt-ordem:sensitive in frame {&frame-name} = YES.
   END.

   /* if not adm-new-record and not avail aloca-reserva then do:  
        assign fi-qt-ordem:sensitive in frame {&frame-name} = 
             (cb-estado:lookup (cb-estado:screen-value in frame {&frame-name}) = 1) or
             (cb-estado:lookup (cb-estado:screen-value in frame {&frame-name}) = 3) or
             (cb-estado:lookup (cb-estado:screen-value in frame {&frame-name}) = 4) and
             (((ord-prod.it-codigo = "") or
               (ord-prod.it-codigo = ?)) or
               (item.tipo-con-est <> 0) and
                not avail aloca-reserva).

       if  can-find(first movto-estoq where movto-estoq.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) or
           can-find(first movto-mat where movto-mat.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) or
           can-find(first movto-ggf where movto-ggf.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) or
           can-find(first movto-dir where movto-dir.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) then 
           assign fi-qt-ordem:sensitive in frame {&frame-name} = no.

       if  can-find(first movto-estoq where movto-estoq.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) or
           can-find(first movto-mat where movto-mat.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) or
           can-find(first movto-ggf where movto-ggf.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) or
           can-find(first movto-dir where movto-dir.nr-ord-produ = int(fi-nr-ord-produ:screen-value in frame {&frame-name})) then 
           assign fi-cod-refer:sensitive in frame {&frame-name} = no.
    end.                                                              */
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-rep-prod
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-rep-prod V-table-Win
ON VALUE-CHANGED OF cb-rep-prod IN FRAME f-main
DO:

    IF VALID-HANDLE(h-pag-2) THEN
        RUN displayInfoSFC IN h-pag-2(INPUT {ininc/i07in271.i 06 cb-rep-prod:SCREEN-VALUE},
                                      INPUT INPUT FRAME f-main fi-nr-ord-produ).
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME cb-sit-aloc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-sit-aloc V-table-Win
ON LEAVE OF cb-sit-aloc IN FRAME f-main
DO:
  /** Chamada referente πs chamadas X do Magnus do CP0301. 
      Apenas para inclusío. **/
     IF adm-new-record    = YES AND
        adm-adding-record = YES   THEN DO:
        RUN pi-upc (INPUT "emite-ordem",
                    INPUT "emite-ordem",
                    INPUT ?,
                    INPUT ?,
                    INPUT "ord-prod",
                    INPUT ROWID(ord-prod)).
     END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-ccusto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON F5 OF fi-ccusto IN FRAME f-main
DO:
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

    ASSIGN d-dt-valida = date(f-retorna-campo("fi-dt-emissao":U)).
    IF d-dt-valida = ? THEN
        ASSIGN d-dt-valida = TODAY.

    run pi_zoom_ccusto in h_api_ccusto (INPUT i-empresa-prin,
                                        INPUT "",
                                        INPUT "",
                                        INPUT d-dt-valida,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}

    if v_cod_ccusto <> "" then
        ASSIGN fi-ccusto:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto.
        
    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.     
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-ccusto IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-planejado
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-planejado V-table-Win
ON F5 OF fi-cd-planejado IN FRAME f-main
DO:   
  assign l-implanta = yes.    
  {include/zoomvar.i &prog-zoom="inzoom/z01in321.w"
                     &campo=fi-cd-planejado
                     &campozoom=cd-planejado}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-planejado V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-planejado IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON F5 OF fi-cod-depos IN FRAME f-main
DO:
  assign l-implanta = yes.  
  {include/zoomvar.i &prog-zoom="inzoom/z01in084.w"
                     &campo=fi-cod-depos
                     &campozoom=cod-depos}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON LEAVE OF fi-cod-depos IN FRAME f-main
DO:
  /* Chamada UPC, referente a Chamada X do Magnus para o cp0301 */
  RUN pi-upc (INPUT "deposito",
              INPUT "deposito",
              INPUT ?,
              INPUT ?,
              INPUT "ord-prod",
              INPUT ROWID(ord-prod)).

    IF l-usa-unid-negoc THEN DO:

        FIND ITEM WHERE ITEM.it-codigo = INPUT FRAME {&frame-name} fi-it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:

            IF ITEM.tipo-contr <> 1 AND
               ITEM.tipo-contr <> 4 THEN DO:

                RUN notify ('pi-atualiza-unid-negoc,group-assign-target').

            END.

        END.

    END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-depos IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON F5 OF fi-cod-estabel IN FRAME f-main
DO:
   assign l-implanta = yes.  
   {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=fi-cod-estabel
                     &campozoom=cod-estabel}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON LEAVE OF fi-cod-estabel IN FRAME f-main
DO:

     find first estabelec
         where estabelec.cod-estabel = fi-cod-estabel:screen-value in frame {&frame-name} no-lock no-error.
     if avail estabelec then
     run cdp/cd9970.p (input rowid(estabelec),
                      output i-empresa-prin).
                      
     if c-cod-estab-aux <> fi-cod-estabel:screen-value in frame {&frame-name} THEN DO:
             
        {utp/ut-liter.i Planejador,_Dep¢sito,_Conta,_Linha_e_Unidade_de_Neg¢cio *}
    
        RUN utp/ut-msgs(INPUT "show", INPUT 55531, INPUT RETURN-VALUE).
    
        IF RETURN-VALUE = "YES":U THEN   
           RUN pi-initial-item.
    
        RUN notify ('pi-atualiza-datas,group-assign-target').
    
        /*FO 1793.171, Retiradas as validaá‰es de alteraá∆o de valores de campos ao navegar pelos demais utilizando "TAB" ou mouse*/
        /*run pi-initial-item.*/.
    
        IF return-value = "ADM-ERROR":U THEN DO:
                 RETURN NO-APPLY.
        END.     
     END.

     IF c-cod-estab-aux <> fi-cod-estabel:SCREEN-VALUE IN FRAME {&FRAME-NAME} THEN DO:

        IF l-usa-unid-negoc THEN DO:

            FIND ITEM WHERE ITEM.it-codigo = INPUT FRAME {&frame-name} fi-it-codigo NO-LOCK NO-ERROR.
            IF AVAIL ITEM THEN DO:

                IF (ITEM.tipo-contr <> 1 AND
                   ITEM.tipo-contr <> 4 ) OR 
                    /*Se estiver incluindo um registro novo/c¢pia, o c¢digo abaixo ser† executando sempre para que se recarregue 
                    a unidade de neg¢cio se houver alteraá∆o do estabelecimento*/
                   adm-new-record    = YES THEN DO:

                    RUN notify ('pi-atualiza-unid-negoc,group-assign-target').

                END.

            END.

        END.

     END.

  /** Chamada referente πs chamadas X do Magnus do CP0301. 
      Apenas para inclusío. **/
     IF adm-new-record    = YES AND
        adm-adding-record = YES   THEN DO:
        RUN pi-upc (INPUT "inclui-conta",
                    INPUT "inclui-conta",
                    INPUT ?,
                    INPUT ?,
                    INPUT "ord-prod",
                    INPUT ROWID(ord-prod)).
     END.
    /** Chamada referente πs chamadas X do Magnus do CP0301. 
      Apenas para Modificar. **/
     IF adm-new-record    = NO AND
        adm-adding-record = NO   THEN DO:
        RUN pi-upc (INPUT "modif-conta",
                    INPUT "modif-conta",
                    INPUT ?,
                    INPUT ?,
                    INPUT "ord-prod",
                    INPUT ROWID(ord-prod)).
     END.
     
     if fi-cod-estabel:screen-value in frame {&frame-name} <> "" then do:
         find first estabelec
              where estabelec.cod-estabel = fi-cod-estabel:screen-value in frame {&frame-name} no-lock no-error.
         if avail estabelec then
             run cdp/cd9970.p (input rowid(estabelec),
                               output i-empresa-prin).
         else
             assign i-empresa-prin = ''.
     end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-refer V-table-Win
ON F5 OF fi-cod-refer IN FRAME f-main
DO:  
   assign l-implanta = yes.   
   {include/zoomvar.i &prog-zoom=inzoom/z01in375.w
                    &campo=fi-cod-refer
                    &campozoom = cod-refer
                    &parametros= "run pi-seta-inicial in wh-pesquisa
                    (fi-it-codigo:screen-value)." }
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-refer IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-conta-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-ordem V-table-Win
ON 'ENTRY' OF fi-conta-ordem IN FRAME f-main
DO:
   /*{cdp/cd9998.i1}*/
   if input frame {&frame-name} fi-conta-ordem <> c-conta then
      assign l-conta = yes.
   assign c-conta = input frame {&frame-name} fi-conta-ordem
          fi-conta-ordem:FORMAT IN FRAME {&frame-name} = "x(20)".


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-ordem V-table-Win
ON F5 OF fi-conta-ordem IN FRAME f-main
DO:
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
                
    assign v_cod_finalid = {adinc/i05ad049.i 4 1} 
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 2}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 3}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 5}
           v_cod_finalid = v_cod_finalid + "," + {adinc/i05ad049.i 4 6}. 

    ASSIGN d-dt-valida = date(f-retorna-campo("fi-dt-emissao":U)).
    IF d-dt-valida = ? THEN
        ASSIGN d-dt-valida = TODAY.

    run pi_zoom_cta_ctbl_integr in h_api_cta_ctbl (INPUT i-empresa-prin,
                                               INPUT "CEP",
                                               INPUT "",
                                               INPUT v_cod_finalid,
                                               INPUT d-dt-valida,
                                               OUTPUT v_cod_cta_ctbl,
                                               OUTPUT v_des_cta_ctbl,
                                               OUTPUT p-finalidade,
                                               OUTPUT TABLE tt_log_erro).
    
    {cdp/cdunif001b.i1}
    
    if v_cod_cta_ctbl <> "" then
        ASSIGN fi-conta-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_cta_ctbl.  
        
    if valid-handle(h_api_cta_ctbl) then
        delete object h_api_cta_ctbl.    
                                        
    APPLY "leave":U TO SELF.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-ordem V-table-Win
ON LEAVE OF fi-conta-ordem IN FRAME f-main
DO:
    if input frame {&frame-name} fi-conta-ordem <> c-conta then
      assign l-conta = yes.
	  
    RUN pi-unif-ccusto (input ?).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-ccusto wWindow
ON LEAVE OF fi-ccusto IN FRAME f-main
DO:
   {cdp/cdunif001d.i fi-ccusto {&frame-name}}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-conta-ordem V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-conta-ordem IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON ENTRY OF fi-it-codigo IN FRAME f-main
DO:
/** Verifica o item escolhido no Zoom para trazer os dados padr‰es da item-uni-estab **/
ASSIGN c-item = fi-it-codigo.
if c-item <> fi-it-codigo:screen-value in frame {&frame-name} then do:

    assign fi-cod-estabel:screen-value in frame {&frame-name} = "".
    run pi-initial-item.
    
end.  
/*******************/

if input fi-it-codigo <> fi-it-codigo THEN DO:
    run pi-initial-item.
END.



  find item where item.it-codigo = input fi-it-codigo no-lock no-error.

  if avail item then do:
     assign fi-descricao = item.desc-item.

     if input fi-it-codigo <> fi-it-codigo then do:

        assign fi-it-codigo = item.it-codigo.

        if input fi-qt-ordem = 0 then
           if item.tipo-con-est = 2 then
              assign fi-qt-ordem:screen-value = "1".  
           else 
              if item.it-codigo <> "" and item.it-codigo <> ? then
                 assign fi-qt-ordem:screen-value = string (dec(f-item-uni-estab (input item.it-codigo,
                                                                                 input ?,
                                                                                 "lote-economi":U))).
        if input fi-un = "" then 
           assign fi-un:screen-value = item.un.      
        if input fi-cod-estabel = "" then
           assign fi-cod-estabel:screen-value = if f-item-uni-estab (input item.it-codigo,
                                                                     input ?,
                                                                     "cod-estabel":U) <> "" 
                                                         then f-item-uni-estab (input item.it-codigo,
                                                                                input ?,
                                                                                "cod-estabel":U)
                                                         else param-cp.cod-estabel.
        if input fi-cod-depos = "" then                                             
           assign fi-cod-depos:screen-value = f-item-uni-estab (input item.it-codigo,
                                                                input ?,
                                                                "deposito-pad":U).                                                          
        assign i-aux = if int(f-item-uni-estab (input item.it-codigo,
                                                input ?,
                                                "sit-aloc":U)) <> 1 and
                          int(f-item-uni-estab (input item.it-codigo,
                                                input ?,
                                                "sit-aloc":U)) <> 2 and
                          int(f-item-uni-estab (input item.it-codigo,
                                                input ?,
                                                "sit-aloc":U)) <> 3 then 1
                       else 
                          int(f-item-uni-estab (input item.it-codigo,
                                                input ?,
                                                "sit-aloc":U)).
        cb-sit-aloc:screen-value = {ininc/i09in271.i 04 i-aux}.
     end.     
  end.
  else
      assign fi-descricao = "".

  disp fi-descricao with frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON F5 OF fi-it-codigo IN FRAME f-main
DO:
   assign l-implanta = YES.   
   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo=fi-it-codigo
                      &campozoom=it-codigo}.

   IF fi-it-codigo <> fi-it-codigo:screen-value in frame {&frame-name} THEN do:
        assign fi-cod-estabel:screen-value in frame {&frame-name} = "".


        run pi-initial-item.
   END.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON LEAVE OF fi-it-codigo IN FRAME f-main
DO:
    if fi-it-codigo <> fi-it-codigo:screen-value in frame {&frame-name} then do:
    
        assign fi-cod-estabel:screen-value in frame {&frame-name} = "".
        run pi-initial-item.
        
    end.   
    /** Chamada referente πs chamadas X do Magnus do CP0301. 
        Para inclusío, cΩpia ou modificaªío. **/
    RUN pi-upc (INPUT "item",
                INPUT "item",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME f-main
DO:
   apply 'F5' to self.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON TAB OF fi-it-codigo IN FRAME f-main
DO:   
    if fi-it-codigo <> fi-it-codigo:screen-value in frame {&frame-name} then do:
      assign fi-cod-estabel:screen-value in frame {&frame-name} = "". 

      run pi-initial-item.    

    END.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-linha
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha V-table-Win
ON ENTRY OF fi-nr-linha IN FRAME f-main
DO:
   assign c-linha = input frame {&frame-name} fi-nr-linha.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha V-table-Win
ON F5 OF fi-nr-linha IN FRAME f-main
DO:

  find first estabelec
       where estabelec.cod-estabel = fi-cod-estabel:screen-value in frame {&frame-name} no-lock no-error.
  if avail estabelec then
     assign gr-estabelec = rowid(estabelec).

   assign l-implanta = yes.  
   {include/zoomvar.i &prog-zoom="inzoom/z01in186.w"
                      &campo=fi-nr-linha
                      &campozoom=nr-linha}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha V-table-Win
ON LEAVE OF fi-nr-linha IN FRAME f-main
DO:
  find item 
      where item.it-codigo = input frame {&frame-name} fi-it-codigo no-lock no-error.

  if fi-cod-estabel:screen-value <> "" then
      assign c-cod-estab-aux = fi-cod-estabel:screen-value in frame {&frame-name}.
  /* else assign c-cod-estab-aux = ? */ .        

  find lin-prod 
      where lin-prod.cod-estabel = fi-cod-estabel:screen-value in frame {&frame-name}
        and lin-prod.nr-linha    = input fi-nr-linha no-lock no-error.
  
   if avail lin-prod then do:
       if lin-prod.sum-requis = 1 then do:    /* OP */
          assign fi-cd-planejado:screen-value = if param-cp.planej-op = 2
                                                   then lin-prod.cd-planejado
                                                   else f-item-uni-estab (input item.it-codigo,
                                                                          c-cod-estab-aux,
                                                                          "cd-planejado").
       end.   
       else do:                               /* OS */
            assign fi-cd-planejado:screen-value = if param-cp.planej-os = 2
                                                     then lin-prod.cd-planejado
                                                     else f-item-uni-estab (input item.it-codigo,
                                                                            c-cod-estab-aux,
                                                                            "cd-planejado").
       end.
   end.

/*   if avail lin-prod then do:
 *      if lin-prod.sum-requis = 1 then do:    /* OP */
 *         assign fi-cd-planejado:screen-value = if param-cp.log-1 = no
 *                                                then lin-prod.cd-planejado
 *                                                else item.cd-planejado.
 *       end.
 *       else do:                                /* OS */
 *          assign fi-cd-planejado:screen-value = if param-cp.log-2 = no
 *                                                then lin-prod.cd-planejado
 *                                                else item.cd-planejado.
 *       end.
 *    end.
 *    else assign fi-cd-planejado:screen-value = item.cd-planejado.*/

	if  l-conta = no OR
        (AVAIL lin-prod AND (lin-prod.ct-ordem <> fi-conta-ordem:SCREEN-VALUE OR lin-prod.sc-ordem = fi-ccusto:screen-value))
        then do:

       if  avail lin-prod then
         assign fi-conta-ordem:screen-value = lin-prod.ct-ordem
                fi-ccusto:screen-value      = lin-prod.sc-ordem.
       else do:
          assign fi-conta-ordem:screen-value = param-cp.ct-ordem
                 fi-ccusto:screen-value      = param-cp.sc-ordem.
       end.
       RUN pi-unif-ccusto (INPUT ?).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-linha V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-nr-linha IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-qt-ordem
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-qt-ordem V-table-Win
ON LEAVE OF fi-qt-ordem IN FRAME f-main
DO:
    RUN notify ('pi-atualiza-datas,group-assign-target').
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

  {utp/ut-field.i mgind ord-prod tipo 1}.
  assign cb-tipo:label = return-value.

  {utp/ut-field.i mgind ord-prod estado 1}.
  assign cb-estado:label = return-value.

  {utp/ut-field.i mgind ord-prod rep-prod 1}.
  assign cb-rep-prod:label = return-value. 

  {utp/ut-field.i mgind ord-prod sit-aloc 1}.
  assign cb-sit-aloc:label = return-value.

  fi-it-codigo:load-mouse-pointer    ("image/lupa.cur":U) in frame {&frame-name}.
  fi-nr-linha:load-mouse-pointer     ("image/lupa.cur":U) in frame {&frame-name}.
  fi-cd-planejado:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name}.
  fi-conta-ordem:load-mouse-pointer  ("image/lupa.cur":U) in frame {&frame-name}.
  fi-ccusto:load-mouse-pointer  ("image/lupa.cur":U) in frame {&frame-name}.
  fi-cod-refer:load-mouse-pointer    ("image/lupa.cur":U) in frame {&frame-name}.
  fi-cod-depos:load-mouse-pointer    ("image/lupa.cur":U) in frame {&frame-name}.
  fi-cod-estabel:load-mouse-pointer  ("image/lupa.cur":U) in frame {&frame-name}.

  assign l-conta = no.

  ASSIGN l-usa-unid-negoc = NO.

  IF CAN-FIND (FIRST funcao
               WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
               AND   funcao.ativo     = YES) THEN DO:

      ASSIGN l-usa-unid-negoc = YES.

  END.

  /*Procedure pi-formatted-time-to-sec*/
  {sfc/sf9000.i}

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

  find first param-cp    no-lock no-error.
  find first param-estoq no-lock no-error.
  assign cb-tipo:screen-value         in frame {&frame-name} = {ININC/I10IN271.I 04 1}
         cb-estado:screen-value       in frame {&frame-name} = {ININC/I01IN271.I 04 1}
         cb-rep-prod:screen-value     in frame {&frame-name} = {ININC/I07IN271.I 04 1}
         cb-sit-aloc:screen-value     in frame {&frame-name} = {ININC/I09IN271.I 04 1}
         fi-nr-ord-produ:screen-value in frame {&frame-name} = string (i-ordem)
         l-conta = no.

  &IF DEFINED (bf_mat_conta_ordem) &THEN
      find first estab-mfg
           where estab-mfg.cod-estab = fi-cod-estabel:screen-value in frame {&frame-name} no-lock no-error.
      if avail estab-mfg and
         estab-mfg.ct-ordem <> ? then
         assign fi-conta-ordem:screen-value in frame {&frame-name} = estab-mfg.ct-ordem
                        fi-ccusto:screen-value in frame {&frame-name} = estab-mfg.sc-ordem.
      else
  &ENDIF
      assign fi-conta-ordem:screen-value in frame {&frame-name} = param-cp.ct-ordem
                 fi-ccusto:screen-value in frame {&frame-name} = param-cp.sc-ordem.


  run pi-initial-item.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
def var i-num-registro as int no-undo.
def var i-sequencia    as integer no-undo.
def var l-ok           as logical no-undo.

{include/i-vldfrm.i} 


/* Code placed here will execute PRIOR to standard behavior. */

/* Dispatch standard ADM method.                             */
/*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .*/

/* Code placed here will execute AFTER standard behavior.    */
do  with frame {&frame-name}:

    def var de-qt-ordem  as decimal no-undo.
    def var de-lote-mult as decimal no-undo.
    def var de-nr-lotes  as decimal no-undo.

    for each tt-ord-prod:  delete tt-ord-prod.  end.
    for each tt-reapro:    delete tt-reapro.    end.
    FOR EACH tt-copia:     DELETE tt-copia.     END.

    assign cb-tipo
           cb-estado
           cb-rep-prod
           cb-sit-aloc.
           
    assign de-qt-ordem = input fi-qt-ordem.

    FIND FIRST item-uni-estab WHERE item-uni-estab.cod-estabel = input fi-cod-estabel AND
                                    item-uni-estab.it-codigo = input fi-it-codigo NO-LOCK NO-ERROR.
    
    /* Busca o ID do cÛdigo do usu·rio Datasul */
    FOR FIRST usuar_mestre WHERE usuar_mestre.cod_usuario = v_cod_usuar_corren NO-LOCK:
        ASSIGN i-idi-dtsul = usuar_mestre.idi_dtsul.
    END.
    
    RUN pi-recupera-param.
    
    
    IF AVAIL item-uni-estab THEN DO:
        if adm-new-record or
           de-qt-ordem-init <> input fi-qt-ordem and not adm-new-record then do:

            /* Se Considera Perda */
            if l-perda then
                assign de-qt-ordem = de-qt-ordem + item-uni-estab.quant-perda.

            /* considera refugo */
            if l-refugo THEN 
                ASSIGN de-qt-ordem = de-qt-ordem / (1 - (item-uni-estab.fator-refugo / 100)).
            
            /* Se Considera Lote Minimo */
            if l-lote-min THEN
                if de-qt-ordem < item-uni-estab.lote-minimo then
                    assign de-qt-ordem = item-uni-estab.lote-minimo.
        
            /* Se Considera Lote Multiplo */
            if l-lote-mult then do:
                ASSIGN de-lote-mult = item-uni-estab.lote-multipl.

                if de-qt-ordem < de-lote-mult then
                    assign de-qt-ordem = de-lote-mult.
                ELSE
                    IF de-lote-mult = 0 THEN
                        ASSIGN de-lote-mult =  1.

                ASSIGN de-nr-lotes = de-qt-ordem / de-lote-mult.

                IF de-nr-lotes - TRUNCATE(de-nr-lotes, 0) > 0 THEN
                    ASSIGN de-nr-lotes = TRUNCATE(de-nr-lotes, 0) + 1.

                ASSIGN de-qt-ordem = de-lote-mult * de-nr-lotes.
            end.

            /* item fraciona */
            IF NOT AVAIL item THEN
                FIND item WHERE item.it-codigo = INPUT FRAME {&frame-name} fi-it-codigo NO-LOCK NO-ERROR.
            if (item.fraciona = no and (de-qt-ordem - truncate(de-qt-ordem, 0)) > 0) then
                assign de-qt-ordem = truncate(de-qt-ordem, 0) + 1.
            else
                assign de-qt-ordem = truncate(de-qt-ordem, 4).
        end.
                        
                
        if l-refugo or l-perda or l-lote-min or l-lote-mult then do: 
            if de-qt-ordem <> input fi-qt-ordem then do:
                run utp/ut-msgs.p (input "show",
                                   input 54279,  
                                   input input fi-qt-ordem + "~~" + STRING(de-qt-ordem)).
                IF RETURN-VALUE = "No":U THEN
                    ASSIGN de-qt-ordem = input fi-qt-ordem.
            end.
        end.
    END.

    run pi-validate.

    if  return-value = "ADM-ERROR":U then
        return return-value.

    create tt-ord-prod.
    if  not adm-new-record then
        buffer-copy ord-prod to tt-ord-prod.

    assign tt-ord-prod.cod-versao-integracao = 003
           tt-ord-prod.prog-seg              = "cp0301"
            tt-ord-prod.cod-prog-orig         = "CP0301"
           tt-ord-prod.aloca-reserva         = l-aloca
           tt-ord-prod.ind-tipo-movto        = if l-copia then 4
                                               else if adm-new-record then 1 
                                                    else 2
           tt-ord-prod.nr-ord-produ          = input fi-nr-ord-produ
           tt-ord-prod.it-codigo             = input fi-it-codigo
           tt-ord-prod.qt-ordem              = de-qt-ordem 
           tt-ord-prod.un                    = input fi-un
           tt-ord-prod.tipo                  = {ininc/i10in271.i 06 cb-tipo}
           tt-ord-prod.estado                = {ininc/i01in271.i 06 cb-estado}
           i-estado                          = tt-ord-prod.estado
           tt-ord-prod.nr-linha              = input fi-nr-linha
           tt-ord-prod.cod-refer             = input fi-cod-refer
           tt-ord-prod.rep-prod              = {ininc/i07in271.i 06 cb-rep-prod}
           tt-ord-prod.sit-aloc              = {ininc/i09in271.i 06 cb-sit-aloc}
           tt-ord-prod.cod-estabel           = input fi-cod-estabel
           tt-ord-prod.cod-depos             = input fi-cod-depos
           tt-ord-prod.cd-planejado          = input fi-cd-planejado
           tt-ord-prod.ct-codigo             = input fi-conta-ordem
           tt-ord-prod.sc-codigo             = input fi-ccusto.

    assign tt-ord-prod.dt-inicio             = date (f-retorna-campo ("fi-dt-inicio":U))
           tt-ord-prod.dt-termino            = date (f-retorna-campo ("fi-dt-termino":U))
           tt-ord-prod.dt-orig               = date (f-retorna-campo ("fi-dt-orig":U))
           tt-ord-prod.dt-emissao            = date (f-retorna-campo ("fi-dt-emissao":U))
           tt-ord-prod.nome-abrev            = f-retorna-campo ("fi-nome-abrev":U)
           tt-ord-prod.cod-gr-cli            = int (f-retorna-campo ("fi-cod-gr-cli":U))
           tt-ord-prod.nr-pedido             = f-retorna-campo ("fi-nr-pedido":U)
           tt-ord-prod.nr-sequencia          = int (f-retorna-campo ("fi-nr-sequencia":U))
           tt-ord-prod.nr-entrega            = int (f-retorna-campo ("fi-nr-entrega":U))
           tt-ord-prod.lote-serie            = f-retorna-campo ("fi-lote-serie":U)
           tt-ord-prod.prioridade            = int (f-retorna-campo ("fi-prioridade":U))
           tt-ord-prod.reporte-mob           = if adm-new-record then ? else ord-prod.reporte-mob
           tt-ord-prod.reporte-ggf           = if adm-new-record then ? else ord-prod.reporte-ggf
           tt-ord-prod.calc-cs-mob           = if adm-new-record then ? else ord-prod.calc-cs-mob
           tt-ord-prod.calc-cs-mat           = if adm-new-record then ? else ord-prod.calc-cs-mat
           tt-ord-prod.calc-cs-ggf           = if adm-new-record then ? else ord-prod.calc-cs-ggf

           /* Integracao com Investimentos */
           tt-ord-prod.num-ord-inv           = int (f-retorna-campo ("fi-num-ord-inv":U))
           tt-ord-prod.ep-codigo-usuario     = i-ep-codigo-usuario
           tt-ord-prod.seg-usuario           = c-seg-usuario
        /* tt-ord-prod.prog-seg              = "IN2215" */
           /* Fim integracao com Investimentos */
           tt-ord-prod.narrativa             = f-retorna-campo ("ed-narrativa":U)       
           tt-ord-prod.emite-ordem           = (f-retorna-campo ("tb-emite-ordem":U) = "yes":U)
           tt-ord-prod.emite-requis          = (f-retorna-campo ("tb-emite-requis":U) = "yes":U).    

     if tt-ord-prod.estado = 1 then 
        assign tt-ord-prod.log-1 = no.
     if tt-ord-prod.estado = 2 then
        assign tt-ord-prod.log-1 = yes.

    if  adm-new-record then
        assign tt-ord-prod.reporte-mob = ?
               tt-ord-prod.reporte-ggf = ?
               tt-ord-prod.origem      = "CP":U.
    else
        assign tt-ord-prod.cod-lista-compon = f-retorna-campo ("c-cod-lista-compon":U)  
               tt-ord-prod.cod-roteiro      = f-retorna-campo ("c-cod-roteiro":U).

    /*Atualiza o estado da op-sfc, caso a mesma exista*/
    if avail ord-prod THEN
      FOR first op-sfc FIELDS (nr-ord-produ ind-estado-op) where  
                op-sfc.nr-ord-produ = ord-prod.nr-ord-produ EXCLUSIVE-LOCK:
         if tt-ord-prod.estado = 6 /*Iniciado*/ then
            assign op-sfc.ind-estado-op = 3 /*Iniciado*/ .
      end.

    IF l-usa-unid-negoc THEN DO:
        run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "c-unid-negocio":U).
        ASSIGN c-unid-negocio = RETURN-VALUE
               tt-ord-prod.cod-unid-negoc = c-unid-negocio.
    END.
   
    run pi-valida-ord-prod (input tt-ord-prod.ind-tipo-movto,
                            input yes,
                            input tt-ord-prod.nr-ord-produ,
                            output c-erro,
                            output c-texto).

    if return-value = "nok" and
       c-erro = "" then do:
    
        for each tt-erro:
    
            assign c-erro  = if c-erro = "" then string(tt-erro.cd-erro) else "," + string(tt-erro.cd-erro)
                   c-texto = if c-texto = "" then tt-erro.mensagem else "," + tt-erro.mensagem.
    
        end.
    
    end.

    ELSE IF return-value = "ok" THEN
        if  tt-ord-prod.nr-pedido <> ""
            and tt-ord-prod.nr-pedido <> string(tt-ord-prod.nr-estrut)
            AND c-erro <> "56" then do:
            for first ped-venda fields (nr-pedido 
                                        nome-abrev
                                        nr-pedcli
                                        cod-sit-aval
                                        cod-sit-ped)
                where ped-venda.nome-abrev = tt-ord-prod.nome-abrev
                and ped-venda.nr-pedcli  = tt-ord-prod.nr-pedido no-lock: end.
                /* Alterado FO 1296345 */      
                if not avail ped-venda and 
                    param-global.modulo-pd then do: 
                    IF c-erro = "8609" then
                        ASSIGN c-erro = "".
                    {utp/ut-liter.i n∆o_cadastrado mcp l}
                    run utp/ut-msgs.p ('show',31831,return-value). 
                    IF RETURN-VALUE = "no" THEN
                        assign c-erro  = "31831":U.
                end.
        END.
end.

 /*run pi-atualiza-estado.*/
assign fi-conta-ordem:screen-value in frame {&frame-name} = tt-ord-prod.ct-codigo
       fi-ccusto:screen-value in frame {&frame-name} = tt-ord-prod.sc-codigo.

if  return-value = "nok" OR c-erro = "31831" then do with frame {&frame-name}:
    assign c-campo = "".
    case int (entry (num-entries (c-erro), c-erro)):
        when 8 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-nr-ord-produ.
        end.
        when 7071 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-qt-ordem.
        end.
        when 19 or when 106 or when 107 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-conta-ordem.
        end.
        when 999 or when 693 or when 1601 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-it-codigo.
        end.
        when 846 or when 848 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-un.
        end.
        when 847 or when 16090 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-qt-ordem.
        end.
        when 529 or when 678 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-cod-refer.
        end.

        when 860 or when 1104 or when 8400 or when 8401 then do:
            {include/i-vldprg.i}
            apply 'entry':U to cb-estado.
        end.
        when 851 or when 856 or when 1608 then do:
            {include/i-vldprg.i}
            apply 'entry':U to cb-tipo.
        end.
        when 861 then do:
            {include/i-vldprg.i}
            apply 'entry':U to fi-nr-linha.
        end.
        when 671 then do:
            {include/i-vldprg.i}
            apply 'entry':U to cb-rep-prod.
        end.
        when 56 then do:
            {include/i-vldprg.i}
            {utp/ut-table.i mgind lin-prod 1}
            if c-texto = return-value then apply 'entry':U to fi-nr-linha.
            {utp/ut-table.i mgind item 1}
            if c-texto = return-value then apply 'entry':U to fi-it-codigo.
            {utp/ut-table.i mgind deposito 1}
            if c-texto = return-value then apply 'entry':U to fi-cod-depos.
        end.

        when 36 then do:
            {utp/ut-field.i mgind ord-prod nr-sequencia 1}
            if c-texto = return-value then assign c-campo = "fi-nr-sequencia":U.
        end.

        when 1166 then assign c-campo = "fi-dt-termino":U.
        when 864 or when 1322 then assign c-campo = "fi-dt-inicio":U.
        when 569 or when 8608 OR WHEN 31831 then assign c-campo = "fi-nr-pedido":U.
        when 14 then assign c-campo = "fi-cod-gr-cli":U.
        when 18217 then assign c-campo = "c-cod-lista-compon":U.
    end case.

    if  c-campo <> "" then do:
        RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                               INPUT "group-assign-target",
                                               OUTPUT c-handle).
        do  i-cont1 = 1 to num-entries (c-handle):
            run pi-apply-entry in widget-handle (entry(i-cont1, c-handle))
                                                (input c-campo).
        end.
    end.
    do  i-cont1 = 1 to num-entries (c-erro):
        IF c-erro <> "31831" THEN
        run utp/ut-msgs.p (input "show":U,
                           input int (entry (i-cont1, c-erro)),
                           input entry (i-cont1, c-texto)).
    end.
    if  int (entry (num-entries(c-erro), c-erro)) = 8 then
         assign fi-nr-ord-produ:screen-value = string (f-gera-numero-op-manual()).            
    return "adm-error".


end. /*if  return-value = "nok" OR c-erro = "31831"*/
else do:

    /*Mostra os erros que estiverem acumulados no c-erro*/
    do i-cont1 = 1 to num-entries (c-erro):
       run utp/ut-msgs.p (input "show":U,
                          input int (entry (i-cont1, c-erro)),
                          input entry (i-cont1, c-texto)).

    end.

    /*O "if" abaixo foi modificado pois em casos de que exista 
    lista de componentes em processos do item, h† a necessidade
    de atualiz†-la quando uma linha de produá∆o est† vinculada 
    a esta lista de componentes e os roteiro e ele Ç modificada neste programa*/

    /* S¢ procura a lista de componentes se a ordem ainda n∆o possuir nenhuma. */
    /*if  tt-ord-prod.cod-lista-compon = "" then do:*/
        /* Procura a lista de componente p/ geraá∆o das reservas da ordem */
     IF tt-ord-prod.estado < 3 THEN DO:    
        run GerarListaProcesItem (input tt-ord-prod.it-codigo,
                                  input tt-ord-prod.qt-ordem,
                                  input tt-ord-prod.cod-estabel,
                                  input tt-ord-prod.cod-refer,
                                  input tt-ord-prod.dt-inicio,
                                  input tt-ord-prod.nr-linha,
                                  input yes,
                                  INPUT tt-ord-prod.cod-unid-negoc,
                                  input-output table tt-proces-item).
        assign i-num-registro = 0.

        for each tt-proces-item:
            assign i-num-registro = i-num-registro + 1.
        end.

        case i-num-registro:
            when 1 then do:
                FIND FIRST tt-proces-item NO-ERROR.
                assign tt-ord-prod.cod-lista-compon = tt-proces-item.cod-lista-compon
                       tt-ord-prod.cod-roteiro      = tt-proces-item.cod-roteiro.
            end.
            when 0 then do.
                if  can-find (first proces-item
                              where proces-item.it-codigo = tt-ord-prod.it-codigo) then do:

                    run utp/ut-msgs.p (input "show":U,
                                       input 17830,
                                       input "").
                    if  return-value = 'no':U then
                        return 'ADM-ERROR':U.
                end.
            end.

            otherwise do:

                run cpp/cp0301d2.w (input table tt-proces-item,
                                    output i-sequencia,
                                    output l-ok).
                if  l-ok = no then
                    return 'ADM-ERROR':U.

                find tt-proces-item
                    where tt-proces-item.it-codigo = tt-ord-prod.it-codigo
                      and tt-proces-item.sequencia = i-sequencia no-error.
                if  avail tt-proces-item then
                    assign tt-ord-prod.cod-lista-compon = tt-proces-item.cod-lista-compon
                           tt-ord-prod.cod-roteiro      = tt-proces-item.cod-roteiro.
            end.
        end case.
    end.
    
    if  tt-ord-prod.tipo = 9 then do:
        for each  reservas
            where reservas.nr-ord-produ = ord-prod.nr-ord-produ
              and reservas.tp-atualiza  = 9 no-lock:
            find item where item.it-codigo = reservas.it-codigo no-lock no-error.
            create tt-reapro.
            assign tt-reapro.it-codigo  = reservas.it-codigo
                   tt-reapro.cod-refer  = reservas.cod-refer
                   tt-reapro.quant-orig = reservas.quant-orig
                   tt-reapro.un         = reservas.un
                   tt-reapro.descricao  = item.desc-item
                                          when avail item.               
        end.

        run cpp/cp0301b1.w (input tt-ord-prod.nr-ord-produ,
                            input tt-ord-prod.qt-ordem,
                            input tt-ord-prod.un,
                            input tt-ord-prod.it-codigo,
                            input tt-ord-prod.rep-prod, 
                            input-output table tt-reapro). /* Reservas p/ Reaproveitamento */
    end.

    if  l-copia then do:
        assign tt-ord-prod.rw-ord-prod = gr-ord-prod.

        ASSIGN l-upc-16415 = YES
               l-ret-gera  = YES.

        IF c-nom-prog-upc-mg97 <> "" THEN DO:

            RUN VALUE(c-nom-prog-upc-mg97) (INPUT "Before-16415",
                                            INPUT "viewer",
                                            INPUT THIS-PROCEDURE,
                                            INPUT FRAME f-main:HANDLE,
                                            INPUT ?,
                                            INPUT ?).

            IF NUM-ENTRIES(RETURN-VALUE, "|") = 1
            AND RETURN-VALUE = "InibePergunta"
            THEN DO:
                ASSIGN l-upc-16415 = NO.
            END.
            ELSE DO:
                IF NUM-ENTRIES(RETURN-VALUE, "|") > 1
                AND ENTRY(1,RETURN-VALUE,"|") = "InibePergunta"
                THEN DO:
                    ASSIGN l-upc-16415 = NO
                           l-ret-gera  = ENTRY(2,RETURN-VALUE,"|") = "yes".
                END.
            END.

        END.

        IF l-upc-16415 = YES THEN DO:
            RUN utp/ut-msgs.p (INPUT "show":U,
                               INPUT 16415,
                               INPUT "").
           
    	    ASSIGN tt-ord-prod.gera-relacionamentos = (RETURN-VALUE = "yes":U).
        END.
        ELSE 
            ASSIGN tt-ord-prod.gera-relacionamentos = l-ret-gera.

        IF NOT tt-ord-prod.gera-relacionamentos THEN DO:
            if not avail ord-prod then
                find ord-prod where rowid(ord-prod) = tt-ord-prod.rw-ord-prod no-lock no-error.
            IF CAN-FIND (FIRST reservas 
                          WHERE reservas.nr-ord-produ = ord-prod.nr-ord-produ
                          AND reservas.it-codigo = tt-ord-prod.it-codigo
                          AND tt-ord-prod.tipo <> 5 ) /* (Tipo:Conserto) */ THEN DO:
                run utp/ut-msgs.p (input "show":U,
                                  input 1677,
                                  input return-value).
               return "adm-error".
            END.
        END.
 
        if tt-ord-prod.narrativa <> " " then do:
           {utp/ut-field.i mgind item narrativa 1}
           run utp/ut-msgs.p (input "show":U,
                              input 17475,
                              input return-value).
        end.
    end. 

    if return-value = "no":U then
       assign tt-ord-prod.narrativa = " ".
    assign l-copia = no.

 /******* fim *********/

    do on error undo, return "adm-error":U: 

        /* Chamada EPC para a assign record */
           {include/i-epc003.i}
        run utp/ut-acomp.p persistent set h-acomp.
        if adm-new-record THEN DO:
            {utp/ut-liter.i Criando_Ordem_de_Produá∆o *}
        END.
        run pi-inicializar in h-acomp (input (if adm-new-record then
                                                 RETURN-VALUE
                                              else "":U)).

        run pi-desabilita-cancela in h-acomp.
        if  adm-new-record then do:
            case {ininc/i10in271.i 06 cb-tipo}:
                when 2 then do:
                    {utp/ut-liter.i Gerando_Reservas... mcp l} 
                    run pi-acompanhar in h-acomp (input trim (return-value)).
                end.
                when 1 or when 3 or when 9 then do:
                    {utp/ut-liter.i Gerando_Reservas,_Operaá‰es_e_Rede_PERT... mcp l} 
                    run pi-acompanhar in h-acomp (input trim (return-value)).
                end.
                when 5 then do:
                    {utp/ut-liter.i Gerando_Reservas_p/item_da_Ordem... mcp l} 
                    run pi-acompanhar in h-acomp (input trim (return-value)).
                end.
            end case.
        end.
        else do:
            {utp/ut-liter.i Atualizando_Ordem_de_Produá∆o... mcp l}
            run pi-acompanhar in h-acomp (input trim(return-value)).
        end.

        if  adm-new-record = NO 
             and avail ord-prod 
             /*  o cliente n∆o Ç obrigado a usar a lista de componentes */
             AND (ord-prod.cod-lista-compon <> tt-ord-prod.cod-lista-compon OR
                  ord-prod.cod-roteiro <> tt-ord-prod.cod-roteiro) then DO TRANS ON ERROR UNDO,LEAVE:
                  
             run pi-alteracao-processo in h-cpapi301 (input yes).

             create tt-copia.
             buffer-copy tt-ord-prod to tt-copia.
             assign tt-ord-prod.ind-tipo-movto = 3.

             run pi-processa-ordens in h-cpapi301 (input-output table tt-ord-prod,
                                                   input-output table tt-reapro,
                                                   input-output table tt-erro,
                                                   input yes).
                                                      
             run pi-alteracao-processo in h-cpapi301 (input no).                                                      

             for each tt-ord-prod: delete tt-ord-prod. end.
             create tt-ord-prod.
             buffer-copy tt-copia to tt-ord-prod.
             assign tt-ord-prod.ind-tipo-movto = 1
                      tt-ord-prod.cod-prog-orig = "CP0301"
                    tt-ord-prod.nr-req-sum = 0.

             run pi-processa-ordens in h-cpapi301 (input-output table tt-ord-prod,
                                                   input-output table tt-reapro,
                                                   input-output table tt-erro,
                                                   input yes).

            assign c-retorno = return-value.
            find first tt-erro no-lock no-error.
            if  avail tt-erro THEN DO:
                run cdp/cd0666.w (input table tt-erro).
                ASSIGN c-retorno = "".
                EMPTY TEMP-TABLE tt-erro.
                UNDO,LEAVE.               
            END.
            
            FIND FIRST tt-ord-prod NO-ERROR.    
        end.
        
        IF c-retorno = "nok":U THEN DO:
           run pi-finalizar in h-acomp.
           ASSIGN c-retorno = "".
           return "adm-error".
        END.
        if l-res-conf then do:
            run pi-reservas-config in h-cpapi301 (input ord-prod.nr-ord-produ,
                                                  input dec(fi-qt-ordem:screen-value in frame {&frame-name}),
                                                  input l-ord-conf).
            assign l-res-conf = no
                   l-ord-conf = no.
        end.
        
        FIND FIRST tt-ord-prod NO-ERROR.
        
        if  adm-new-record = NO THEN assign tt-ord-prod.ind-tipo-movto = 2.

        run pi-processa-ordens in h-cpapi301 (input-output table tt-ord-prod,
                                              input-output table tt-reapro,
                                              input-output table tt-erro,
                                              input yes).

        assign c-retorno = return-value.
        run pi-finalizar in h-acomp.

        find first tt-erro no-lock no-error.
        if  avail tt-erro then
            run cdp/cd0666.w (input table tt-erro).
        if  c-retorno = "ok" then do:

            FIND FIRST tt-ord-prod NO-ERROR.
            find ord-prod
                 where rowid (ord-prod) = tt-ord-prod.rw-ord-prod no-lock no-error.
            assign adm-first-table = tt-ord-prod.rw-ord-prod
                   gr-ord-prod     = rowid(ord-prod).

            if avail ord-prod then do :
                find op-sfc where 
                     op-sfc.nr-ord-produ = ord-prod.nr-ord-produ no-lock no-error.
                 if  avail op-sfc then
                       assign gr-op-sfc = rowid(op-sfc). 
            end.

            /* programa chamado abaixo ir† setar o pl-it-calc para que o 
               plano de produá∆o seja replanejado                       */
            if  param-global.modulo-pl or param-global.modulo-pi then
                run cdp/cd7000.p (input 0, 
                                  tt-ord-prod.it-codigo,
                                  tt-ord-prod.cod-estabel). /* usado p/planejamento */

            IF ITEM.politica = 5 THEN DO:
                FOR EACH b-reservas WHERE
                    b-reservas.nr-ord-prod = tt-ord-prod.nr-ord-prod EXCLUSIVE-LOCK:
                    run cdp/cd7000.p (input 0, 
                                      b-reservas.it-codigo,
                                      tt-ord-prod.cod-estabel). /* usado p/planejamento */
                END.
            END.

        end.
        else do:
            find first tt-erro
                where tt-erro.cd-erro = 8 no-lock no-error.
            if  avail tt-erro then
                assign fi-nr-ord-produ:screen-value = string (f-gera-numero-op-manual()).
            ASSIGN c-retorno = "".
            return "adm-error".
        end.
    end.   
end.

RUN ordemSFC.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recupera-param D-Dialog 
PROCEDURE pi-recupera-param:
/*------------------------------------------------------------------------------
  Purpose:     Restaura os parametros: l-aloca, l-lote-min, l-lote-mult, l-refugo e 
               l-perda de acordo com o usuario logado.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  /* Procura parametros cadastrados para esse usuario - l-aloca */
  FIND FIRST configur USE-INDEX configur_user WHERE configur.idi_dtsul_usuar_mestre = i-idi-dtsul AND configur.nom_configur = "cp0301a1_l-aloca":U NO-LOCK NO-ERROR.
  /* Se ja existir parametros para esse usuario, atualizar valores */
  IF AVAIL configur THEN DO: 
      ASSIGN l-aloca = logical(configur.des_val_configur).
  END.
  
  /* Procura parametros cadastrados para esse usuario - l-lote-min */
  FIND FIRST configur USE-INDEX configur_user WHERE configur.idi_dtsul_usuar_mestre = i-idi-dtsul AND configur.nom_configur = "cp0301a1_l-lote-min":U NO-LOCK NO-ERROR.
  /* Se ja existir parametros para esse usuario, atualizar valores */
  IF AVAIL configur THEN DO: 
      ASSIGN l-lote-min = logical(configur.des_val_configur).
  END.
  
  /* Procura parametros cadastrados para esse usuario - l-lote-mult */
  FIND FIRST configur USE-INDEX configur_user WHERE configur.idi_dtsul_usuar_mestre = i-idi-dtsul AND configur.nom_configur = "cp0301a1_l-lote-mult":U NO-LOCK NO-ERROR.
  /* Se ja existir parametros para esse usuario, atualizar valores */
  IF AVAIL configur THEN DO: 
      ASSIGN l-lote-mult = logical(configur.des_val_configur).
  END.
  
  /* Procura parametros cadastrados para esse usuario - l-refugo */
  FIND FIRST configur USE-INDEX configur_user WHERE configur.idi_dtsul_usuar_mestre = i-idi-dtsul AND configur.nom_configur = "cp0301a1_l-refugo":U NO-LOCK NO-ERROR.
  /* Se ja existir parametros para esse usuario, atualizar valores */
  IF AVAIL configur THEN DO: 
      ASSIGN l-refugo = logical(configur.des_val_configur).
  END.
  
  /* Procura parametros cadastrados para esse usuario - l-perda */
  FIND FIRST configur USE-INDEX configur_user WHERE configur.idi_dtsul_usuar_mestre = i-idi-dtsul AND configur.nom_configur = "cp0301a1_l-perda":U NO-LOCK NO-ERROR.
  /* Se ja existir parametros para esse usuario, atualizar valores */
  IF AVAIL configur THEN DO: 
      ASSIGN l-perda = logical(configur.des_val_configur).
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

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */


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

  assign l-copia = yes.

  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign input frame {&frame-name} fi-it-codigo
         input frame {&frame-name} fi-nr-linha.

  find item
      where item.it-codigo = input frame {&frame-name} fi-it-codigo
      no-lock no-error.       

  assign cb-estado:screen-value = {ininc/i01in271.i 04 1}
         fi-cod-refer:sensitive = if  avail item 
                                  then (item.tipo-con-est = 4)
                                  else yes.

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

  if valid-handle (h-cpapi301) then do:
    run finalizaAPI in h-cpapi301.
    DELETE PROCEDURE h-cpapi301.
  end.

  IF VALID-HANDLE(h-bosc038) THEN
      DELETE PROCEDURE h-bosc038.

  IF VALID-HANDLE(h-boin533) THEN
      DELETE PROCEDURE h-boin533.

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
  &if  defined(ADM-MODIFY-FIELDS) &then
      disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

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
  if avail ord-prod then do with frame {&frame-name}:
     find item no-lock
         where item.it-codigo = ord-prod.it-codigo no-error.
     if avail item then 
        assign fi-descricao:screen-value = item.desc-item.
     else assign fi-descricao:screen-value = "".

     assign cb-tipo:Screen-value         = {ininc/i10in271.i 04 ord-prod.tipo}
            cb-estado:screen-value       = {ininc/i01in271.i 04 ord-prod.estado}
            cb-rep-prod:screen-value     = {ininc/i07in271.i 04 ord-prod.rep-prod}
            cb-sit-aloc:screen-value     = {ininc/i09in271.i 04 ord-prod.sit-aloc}
            fi-nr-ord-produ:screen-value = string (ord-prod.nr-ord-produ)
            fi-it-codigo:screen-value    = ord-prod.it-codigo
            fi-it-codigo                 = ord-prod.it-codigo
            fi-qt-ordem:screen-value     = string (ord-prod.qt-ordem)
            fi-un:screen-value           = ord-prod.un
            fi-nr-linha:screen-value     = string (ord-prod.nr-linha)
            fi-cod-refer:screen-value    = ord-prod.cod-refer
            fi-conta-ordem:screen-value  = ord-prod.ct-codigo
            fi-ccusto:screen-value       = ord-prod.sc-codigo
            fi-cod-estabel:screen-value  = ord-prod.cod-estabel
            fi-cod-depos:screen-value    = ord-prod.cod-depos
            fi-cd-planejado:screen-value = ord-prod.cd-planejado.    

        RUN pi-unif-ccusto (input ord-prod.dt-emissao).

        if p_cod_format_cta_ctbl <> "" then                
            assign fi-conta-ordem:format in frame {&frame-name} = p_cod_format_cta_ctbl.


        
  end.
        
        else do with frame {&frame-name}:
                assign cb-tipo:screen-value         = {ininc/i10in271.i 04 1}
               cb-estado:screen-value       = {ininc/i01in271.i 04 1}
               cb-rep-prod:screen-value     = {ininc/i07in271.i 04 1}
               cb-sit-aloc:screen-value     = {ininc/i09in271.i 04 1}
               fi-descricao:screen-value    = ""
               fi-it-codigo:screen-value    = f-formato-campo ("it-codigo":U, 5)
               fi-qt-ordem:screen-value     = f-formato-campo ("qt-ordem":U, 5)
               fi-un:screen-value           = f-formato-campo ("un":U, 5)
               fi-nr-linha:screen-value     = f-formato-campo ("nr-linha":U, 5)
               fi-cod-refer:screen-value    = f-formato-campo ("cod-refer":U, 5)
               fi-conta-ordem:screen-value  = f-formato-campo ("ct-codigo":U, 5)
               fi-ccusto:screen-value       = f-formato-campo ("sc-codigo":U, 5)
               fi-cod-estabel:screen-value  = f-formato-campo ("cod-estabel":U, 5)
               fi-cod-depos:screen-value    = f-formato-campo ("cod-depos":U, 5)
               fi-cd-planejado:screen-value = f-formato-campo ("cd-planejado":U, 5)           
               fi-nr-ord-produ:screen-value = f-formato-campo ("nr-ord-produ":U, 5).
        end.
  

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
  /*  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) . */

  /* Code placed here will execute AFTER standard behavior.    */
  

  &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  do with frame {&frame-name}:
     find first param-cp no-lock no-error.
     run get-attribute in this-procedure ('ADM-NEW-RECORD').
     assign adm-new-record = (return-value = "yes")
            l-movto        = no
            l-alocado      = NO.

     IF CAN-FIND(FIRST param_seg_estab NO-LOCK
                 WHERE param_seg_estab.cdn_param = 2001
                   AND param_seg_estab.des_valor = "SIM":U ) THEN 
         IF adm-new-record AND adm-adding-record THEN 
             ASSIGN cb-tipo:screen-value         = {ininc/i10in271.i 04 1}
                    cb-estado:screen-value       = {ininc/i01in271.i 04 1}
                    cb-rep-prod:screen-value     = {ininc/i07in271.i 04 1}
                    cb-sit-aloc:screen-value     = {ininc/i09in271.i 04 1}
                    fi-descricao:screen-value    = ''
                    fi-it-codigo:screen-value    = ''
                    fi-qt-ordem:screen-value     = ''
                    fi-un:screen-value           = ''
                    fi-nr-linha:screen-value     = ''
                    fi-cod-refer:screen-value    = ''
                    fi-conta-ordem:screen-value  = ''
                    fi-ccusto:screen-value       = ''
                    fi-cod-estabel:screen-value  = ''
                    fi-cod-depos:screen-value    = ''
                    fi-cd-planejado:screen-value = ''
                    fi-nr-ord-produ:screen-value = '' .
     
     FIND FIRST b-ord-prod
           WHERE b-ord-prod.nr-ord-prod = int(INPUT fi-nr-ord-produ:screen-value)
           AND   b-ord-prod.it-codigo   = INPUT fi-it-codigo:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF AVAIL b-ord-prod THEN DO:
          if not adm-new-record 
             AND b-ord-prod.estado > 2  THEN DO:

             &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
              
                      assign cLista = {ininc/i01in271.i 03}.
                      
                    IF b-ord-prod.estado > 2
                       AND b-ord-prod.estado < 6 THEN DO:  /*caso nao seja iniciada */
                          ASSIGN clista-aux = clista-aux + STRING(entry(b-ord-prod.estado,clista,",")).
                          ASSIGN clista-aux = clista-aux + "," + STRING(ENTRY(6,clista,",")).
    
                    END.
                    ELSE  /* caso j† seja iniciada */ 
                       ASSIGN clista-aux = clista-aux + STRING(entry(6,clista,",")).
                  
    
                    DO i = 7 TO 8:
                       ASSIGN clista-aux = clista-aux + "," + STRING(entry(i,clista,",")).
                    END.
                    run utp/ut-lstit.p(INPUT-OUTPUT clista-aux).
                    ASSIGN cb-estado:List-item-pairs = clista-aux.
                    ASSIGN cb-estado:screen-value       = {ininc/i01in271.i 04 b-ord-prod.estado}.
    

              
             &ELSE 
                  ASSIGN l-habilita-qtd = NO.
                  ASSIGN clista = {ininc/i01in271.i 03}.
    
                  IF b-ord-prod.estado > 2
                     AND b-ord-prod.estado < 6 THEN DO:  /*caso nao seja iniciada */
                     ASSIGN clista-aux = clista-aux + STRING(entry(b-ord-prod.estado,clista,",")).
                     ASSIGN clista-aux = clista-aux + "," + STRING(ENTRY(6,clista,",")).
    
                  END.
                  ELSE  /* caso j† seja iniciada */ 
                      ASSIGN clista-aux = clista-aux + STRING(entry(6,clista,",")).
                  
    
                  DO i = 7 TO 8:
                    ASSIGN clista-aux = clista-aux + "," + STRING(entry(i,clista,",")).
                  END.
                    ASSIGN cb-estado:List-items = clista-aux.
                    ASSIGN cb-estado:screen-value       = {ininc/i01in271.i 04 b-ord-prod.estado}.
             &endif
            END.
     END.

     if not adm-new-record then do:

        find lin-prod 
        where lin-prod.cod-estabel = ord-prod.cod-estabel
          and lin-prod.nr-linha    = ord-prod.nr-linha no-lock no-error.

        find item where item.it-codigo = ord-prod.it-codigo no-lock no-error.

        assign l-alocado = CAN-FIND(FIRST aloca-reserva
                                    WHERE aloca-reserva.nr-ord-prod = ord-prod.nr-ord-prod)
               l-movto   = can-find (first movto-estoq
                                     where movto-estoq.nr-ord-prod = ord-prod.nr-ord-prod) or
                           can-find (first movto-ggf
                                     where movto-ggf.nr-ord-prod   = ord-prod.nr-ord-prod) or
                           can-find (first movto-dir
                                     where movto-dir.nr-ord-prod   = ord-prod.nr-ord-prod).
        find first oper-ord 
            where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
              and oper-ord.qt-produzida > 0 no-lock no-error.
        if  avail lin-prod then
            assign fi-nr-linha:sensitive = (lin-prod.sum-requis = 2 or ord-prod.nr-req-sum = 0).
        else
            assign fi-nr-linha:sensitive = yes.

        find first aloca-reserva
            where aloca-reserva.nr-ord-prod = ord-prod.nr-ord-prod no-lock no-error. 

        assign fi-it-codigo:sensitive = (ord-prod.estado = 1 or 
                                         ord-prod.estado = 3 or
                                         ord-prod.estado = 4)  

               fi-un:sensitive = (ord-prod.it-codigo = "" or
                                  ord-prod.it-codigo = ?) or
                                 (item.tipo-con-est <> 0) and
                                  not avail aloca-reserva

               fi-conta-ordem:sensitive = not l-movto
               fi-ccusto:sensitive = not l-movto

               cb-rep-prod:sensitive = not avail oper-ord or
                                      (ord-prod.qt-produzida = 0 and 
                                       ord-prod.rep-prod = 1) .                                                 

        find aloca-reserva where
             ord-prod.nr-ord-prod = aloca-reserva.nr-ord-prod no-lock no-error.
             if not avail aloca-reserva then do:
                 assign fi-qt-ordem:sensitive = ((ord-prod.it-codigo = ""  or
                                                  ord-prod.it-codigo = ?)  or
                                                 (item.tipo-con-est <> 0)  or 
                                                 (ord-prod.estado = 1      or
                                                  ord-prod.estado = 3      or
                                                  ord-prod.estado = 4)).
                 assign fi-cod-refer:sensitive = ((ord-prod.it-codigo = ""  OR ord-prod.it-codigo = ?)   or
                                                  (ord-prod.estado = 1  OR ord-prod.estado = 3  OR ord-prod.estado = 4)) AND 
                                                  (ITEM.tipo-con-est = 4).  /* Ativ. 158674 */                                                
             END.
             ELSE DO:
                 assign fi-qt-ordem:sensitive = no.
                 assign fi-cod-refer:sensitive = no.
             END.
     end.
     else do: 
         assign i-ordem = f-gera-numero-op-manual().

         if i-ordem = -1 then do:
            run utp/ut-msgs.p (input "show":U,
                               input 841,
                               input "").
            assign i-ordem = param-cp.prim-ord-man.
         end.                  
         assign fi-nr-ord-produ:screen-value = string (i-ordem).

     end.

    assign  cLista = {ininc/i01in271.i 03}
            fi-cod-estabel:sensitive = if (lookup(cb-estado:screen-value in frame {&frame-name},cLista) = 3) then no 
                                       else not param-cp.est-unico and not l-movto AND NOT l-alocado
            fi-cod-depos:sensitive   = not l-movto
            cb-tipo:sensitive        = not l-movto
            fi-nr-linha:sensitive    = not l-movto
            cb-rep-prod:sensitive    = not l-movto.

  end. 

   IF l-habilita-qtd = NO THEN
      assign fi-qt-ordem:sensitive IN FRAME {&FRAME-NAME} = no.


   run pi-unif-ccusto (input ?).

   IF l-movto = YES THEN
       ASSIGN fi-conta-ordem:sensitive = NO
              fi-ccusto:sensitive      = NO.



  RUN get-link-handle IN adm-broker-hdl (INPUT  this-procedure,
                                         INPUT  "group-assign-target",
                                         OUTPUT c-handle).       

  assign h-handle = widget-handle (c-handle).

  if valid-handle (h-handle) then do:
     run dispatch in h-handle ("enable-fields").
     run pi-atualiza-datas in h-handle.
  end.

  IF l-habilita-qtd = YES THEN
     apply "value-changed":U to cb-estado in frame {&FRAME-NAME}.
     
  assign de-qt-ordem-init = input fi-qt-ordem.

  {include/i-epc004.i} /*** evento de ENABLE ***/
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  find first param-cp    no-lock no-error.

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /*Verifica se a funcao Mudancas SFC est† implantada*/
  RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).

  IF param-cp.log-integr-wms 
    AND NOT VALID-HANDLE(h-bosc038) THEN  
       RUN scbo/bosc038.p PERSISTENT SET h-bosc038.  

  do with frame {&frame-name}:
     &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
     
         DEFINE VARIABLE cLista AS CHARACTER  NO-UNDO.

         assign cLista = {ininc/i10in271.i 03}.
         run utp/ut-lstit.p (input-output cLista).
         assign cb-tipo:List-item-pairs = cLista.

         assign cLista = {ininc/i01in271.i 03}.
         run utp/ut-lstit.p (input-output cLista).
         assign cb-estado:List-item-pairs = cLista.   

         assign cLista = {ininc/i07in271.i 03}.
         run utp/ut-lstit.p (input-output cLista).
         assign cb-rep-prod:list-item-pairs = cLista.

         assign cLista = {ininc/i09in271.i 03}.
         run utp/ut-lstit.p (input-output cLista).
         assign cb-sit-aloc:list-item-pairs = cLista.

     &else
         assign cb-tipo:List-items     = {ininc/i10in271.i 03}
                cb-estado:List-items   = {ininc/i01in271.i 03}     
                cb-rep-prod:list-items = {ininc/i07in271.i 03}
                cb-sit-aloc:list-items = {ininc/i09in271.i 03}.
     &endif

     run pi-inicializa-campo (fi-nr-ord-produ:handle, "nr-ord-produ":U).            
     run pi-inicializa-campo (fi-it-codigo:handle,    "it-codigo":U). 
     run pi-inicializa-campo (fi-qt-ordem:handle,     "qt-ordem":U). 
     run pi-inicializa-campo (fi-un:handle,           "un":U). 
     run pi-inicializa-campo (fi-nr-linha:handle,     "nr-linha":U). 
     run pi-inicializa-campo (fi-cod-refer:handle,    "cod-refer":U). 
     run pi-inicializa-campo (fi-conta-ordem:handle,  "ct-codigo":U). 
     /*run pi-inicializa-campo (fi-ccusto:handle,       "sc-codigo":U). */
     run pi-inicializa-campo (fi-cod-estabel:handle,  "cod-estabel":U). 
     run pi-inicializa-campo (fi-cod-depos:handle,    "cod-depos":U). 
     run pi-inicializa-campo (fi-cd-planejado:handle, "cd-planejado":U). 
  end.


  if not valid-handle (h-cpapi301) then
    run cpp/cpapi301.p persistent set h-cpapi301 (input-output table tt-ord-prod,
                                                  input-output table tt-reapro,
                                                  input-output table tt-erro,
                                                  input yes).  
    RUN ativaExecPersistente IN h-cpapi301.



  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  find first param-global no-lock no-error.
  find first param-cp     no-lock no-error.
  find first param-cs     no-lock no-error.

  RUN get-attribute IN adm-broker-hdl
    (INPUT "l-aloca").  
  if return-value <> ? then 
     assign l-aloca = if return-value = "yes" then yes
                                              else no.

  assign l-linha = yes.

  assign i-empresa-prin = param-global.empresa-prin.
  &IF DEFINED (bf_mat_conta_estab) &THEN
      if avail ord-prod then do:
         find first estabelec
              where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
         if avail estabelec then
            run cdp/cd9970.p (input rowid(estabelec),
                              output i-empresa-prin).
      end.
  &ENDIF
  


    /** Unificaá∆o de Conceito **/
    if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
        
    ASSIGN d-dt-valida = date(f-retorna-campo ("fi-dt-emissao":U)).
    IF d-dt-valida = ? THEN
        ASSIGN d-dt-valida = TODAY.

    EMPTY TEMP-TABLE tt_log_erro.
    run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                       INPUT "",
                                                       INPUT d-dt-valida,
                                                       OUTPUT p_cod_format_cta_ctbl,
                                                       OUTPUT TABLE tt_log_erro).
    
    apply "value-changed":U to cb-estado in frame {&FRAME-NAME}.
    
    
         
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
  assign gr-ord-prod    = rowid (ord-prod).


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ordemSFC V-table-Win 
PROCEDURE ordemSFC :
/*------------------------------------------------------------------------------
  Purpose:     Trata a Ordem SFC
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE de-hra-imc AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-hra-fmt AS DECIMAL    NO-UNDO.

IF AVAIL ord-prod AND ord-prod.rep-prod <> 4 and l-mudancas-sfc THEN DO:

    FIND FIRST op-sfc WHERE op-sfc.nr-ord-produ = ord-prod.nr-ord-produ EXCLUSIVE-LOCK NO-ERROR.
    IF AVAIL op-sfc THEN DO:
        /*Se a funcao Mudancas SFC implantada entao grava campos da viewer pag 2*/
        RUN pi-formatted-time-to-sec(INPUT SUBSTRING(f-retorna-campo("fi-hra-imc":U),1,2) + 
                                           SUBSTRING(f-retorna-campo("fi-hra-imc":U),4,2),
                                     OUTPUT de-hra-imc).
        RUN pi-formatted-time-to-sec(INPUT SUBSTRING(f-retorna-campo("fi-hra-fmt":U),1,2) + 
                                           SUBSTRING(f-retorna-campo("fi-hra-fmt":U),4,2),
                                     OUTPUT de-hra-fmt).  

        IF NOT VALID-HANDLE(h-boin533) THEN
            run inbo/boin533.p persistent set h-boin533.

        RUN alterarDatasOrdemSFC IN h-boin533(BUFFER op-sfc,
                                              date(f-retorna-campo("fi-dat-imc")),
                                              de-hra-imc,
                                              date(f-retorna-campo("fi-dat-fmt")),
                                              de-hra-fmt).

        RUN alterarPriorOrdemSFC IN h-boin533(BUFFER op-sfc,
                                              ord-prod.prioridade).
    END.
    ELSE DO:

        IF NOT AVAIL param-sfc THEN FIND FIRST param-sfc NO-LOCK NO-ERROR.
        IF avail param-sfc AND param-sfc.log-alerta-integr THEN DO:
            /*Emite mensagem avisando que as informaá‰es de In°cio Mais Cedo e Fim Mais Tarde n∆o ser∆o 
              armazenadas devido a ordem n∆o possuir operaá‰es que sejam reportadas pelo Ch∆o de F†brica*/
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 31979,
                                INPUT RETURN-VALUE).
        END.
    END.
END.

RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-estado V-table-Win 
PROCEDURE pi-atualiza-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE nr-ord AS INTEGER    NO-UNDO.

assign nr-ord = int(fi-nr-ord-produ:SCREEN-VALUE IN FRAME {&FRAME-NAME}).


FOR EACH reservas fields(nr-ord-pro estado) 
        WHERE reservas.nr-ord-pro = nr-ord exclusive-lock.

IF  i-estado = 7 OR i-estado = 8 THEN    
    ASSIGN reservas.estado = 2.
 else   
    ASSIGN reservas.estado = 1.

 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter wh-handle as handle no-undo.
def input parameter c-campo as char no-undo.

run utp/ut-field.p (input "mgind", 
                    input "ord-prod", 
                    input c-campo, 
                    input "1"). /* Label */
assign wh-handle:label = return-value.
run utp/ut-field.p (input "mgind", 
                    input "ord-prod", 
                    input c-campo, 
                    input "4"). /* Formato */
assign wh-handle:format = return-value.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-initial-item V-table-Win 
PROCEDURE pi-initial-item :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE l-int AS LOGICAL  NO-UNDO.
DEFINE VARIABLE l-ext AS LOGICAL  NO-UNDO.

do with frame {&frame-name}:

   if fi-cod-estabel:screen-value <> "" then 
      assign c-cod-estab-aux = fi-cod-estabel:screen-value.
   else 
      assign c-cod-estab-aux = ?.   

   for first item fields (it-codigo cod-estabel desc-item un tipo-con-est) where item.it-codigo = input fi-it-codigo no-lock: end.

   if avail item then do:

      if c-cod-estab-aux <> ? then do:
         if not can-find (first item-uni-estab where 
                                item-uni-estab.it-codigo = item.it-codigo and
                                item-uni-estab.cod-estabel = fi-cod-estabel:screen-value) then do:
            for first item-uni-estab 
                where item-uni-estab.it-codigo = item.it-codigo no-lock:
                assign fi-cod-estabel:screen-value in frame {&frame-name} = item-uni-estab.cod-estabel.
            end.
         end.
      end.
      else do:
         if not can-find (first item-uni-estab where 
                                item-uni-estab.it-codigo = item.it-codigo and 
                                item-uni-estab.cod-estabel = item.cod-estabel) then do:
            for first item-uni-estab 
                where item-uni-estab.it-codigo = item.it-codigo no-lock:
                assign fi-cod-estabel:screen-value in frame {&frame-name} = item-uni-estab.cod-estabel.
            end.
         end.
      end.

      assign fi-descricao              = item.desc-item
             fi-it-codigo              = item.it-codigo
             fi-un:screen-value        = item.un
             fi-nr-linha:screen-value  = (if l-linha then string(int(f-item-uni-estab (input item.it-codigo,
                                                                                       c-cod-estab-aux,
                                                                                       "nr-linha":U)))
                                                     else fi-nr-linha:screen-value)
             fi-cod-refer:sensitive    = (item.tipo-con-est = 4)
             fi-cod-refer:screen-value = (if item.tipo-con-est = 4 
                                             then fi-cod-refer:screen-value
                                             else "")
             fi-cod-depos:screen-value = f-item-uni-estab (input item.it-codigo,
                                                           c-cod-estab-aux,
                                                           "deposito-pad":U).                                  

      apply "leave":U to fi-nr-linha in frame {&frame-name}.

      assign c-cod-estabel = if f-item-uni-estab (input item.it-codigo,
                                                  c-cod-estab-aux,
                                                  "cod-estabel":U) <> ""
                             then f-item-uni-estab (input item.it-codigo,
                                                    c-cod-estab-aux,
                                                    "cod-estabel":U)
                             else param-cp.cod-estabel.
      find lin-prod 
           where lin-prod.cod-estabel = c-cod-estabel
             and lin-prod.nr-linha    = input fi-nr-linha no-lock no-error.

      if avail lin-prod then do:
         if lin-prod.sum-requis = 1 then do:    /* OP */
            assign fi-cd-planejado:screen-value = if param-cp.planej-op = 2
                                                     then lin-prod.cd-planejado
                                                     else f-item-uni-estab (input item.it-codigo,
                                                                            c-cod-estab-aux,
                                                                            "cd-planejado":U).
         end.   
         else do:                               /* OS */

              assign fi-cd-planejado:screen-value = if param-cp.planej-os = 2
                                                       then lin-prod.cd-planejado
                                                       else f-item-uni-estab (input item.it-codigo,
                                                                              c-cod-estab-aux,
                                                                              "cd-planejado":U).

         end.     
      end.

      if input fi-qt-ordem = 0 then
         if item.tipo-con-est = 2 then
            assign fi-qt-ordem:screen-value = "1".  
         else 
           if item.it-codigo <> "" and item.it-codigo <> ? then
              assign fi-qt-ordem:screen-value = string (dec(f-item-uni-estab (input item.it-codigo,
                                                                                 input ?,
                                                                                 "lote-economi":U))).    

      if   fi-qt-ordem:screen-value <> string (dec(f-item-uni-estab (input item.it-codigo,
                                                                                 input ?,
                                                                                 "lote-economi":U)))
       then
          assign fi-qt-ordem:screen-value =  fi-qt-ordem:screen-value .
      else 
         assign fi-qt-ordem:screen-value = fi-qt-ordem:screen-value.  

       if l-conta = no then do:
          if  avail lin-prod then
             assign fi-conta-ordem:screen-value = lin-prod.ct-ordem
                    fi-ccusto:SCREEN-VALUE = lin-prod.sc-ordem.
          else do:
              assign fi-conta-ordem:screen-value = param-cp.ct-ordem
                    fi-ccusto:SCREEN-VALUE = param-cp.sc-ordem.
          end.
       END.


      assign i-aux                       = int(f-item-uni-estab (input item.it-codigo,
                                                                 c-cod-estab-aux,
                                                                 "rep-prod":U)).

      assign cb-rep-prod:screen-value    = if i-aux = 0 then {ininc/i07in271.i 04 1} 

                                                       else {ininc/i07in271.i 04 i-aux}.


      assign fi-cod-estabel:screen-value = if f-item-uni-estab (input item.it-codigo,
                                                                c-cod-estab-aux,
                                                                "cod-estabel":U) <> ""
                                           then f-item-uni-estab (input item.it-codigo,
                                                                  c-cod-estab-aux,
                                                                  "cod-estabel":U)
                                           else param-cp.cod-estabel.   


       assign fi-cod-depos:screen-value   = f-item-uni-estab (input item.it-codigo,
                                                             c-cod-estab-aux,
                                                             "deposito-pad":U)
              i-aux = if int(f-item-uni-estab (input item.it-codigo,
                                              c-cod-estab-aux,
                                              "sit-aloc":U)) <> 1 and
                        int(f-item-uni-estab (input item.it-codigo,
                                              c-cod-estab-aux,
                                              "sit-aloc":U)) <> 2 and
                        int(f-item-uni-estab (input item.it-codigo,
                                              c-cod-estab-aux,
                                              "sit-aloc":U)) <> 3 then 1
                     else 
                         int(f-item-uni-estab (input item.it-codigo,
                                               c-cod-estab-aux,
                                               "sit-aloc":U))
             cb-sit-aloc:screen-value = {ininc/i09in271.i 04 i-aux}. 



        assign cLista = {ininc/i01in271.i 03}
               fi-cod-estabel:sensitive = if (lookup(cb-estado:screen-value in frame {&frame-name},cLista) = 3) then no 
                                       else not param-cp.est-unico and not l-movto AND NOT l-alocado.

        IF l-usa-unid-negoc THEN DO:
            RUN notify ('pi-atualiza-unid-negoc,group-assign-target').
        END.

        RUN notify ('pi-atualiza-datas,group-assign-target').

        ASSIGN l-int = NO
               l-ext = NO.
        
        if can-find (first rot-item where
                    rot-item.it-codigo = input frame {&frame-name} fi-it-codigo) then do:
            
           for each rot-item WHERE 
                    rot-item.it-codigo = fi-it-codigo and
                    rot-item.data-inicio <= TODAY and
                    rot-item.data-termino > TODAY NO-LOCK,
               each operacao fields (it-codigo cod-roteiro data-inicio data-termino tipo-oper) where
                    operacao.cod-roteiro = rot-item.cod-roteiro and
                    operacao.it-codigo = ""  and 
                    operacao.data-inicio <= today and
                    operacao.data-termino > today no-lock:
                       
                       IF operacao.tipo-oper = 1 then 
                          assign l-int = YES. 
                    
                       IF operacao.tipo-oper = 2 then   
                          assign l-ext = YES.
                       ELSE IF operacao.tipo-oper = 1 then 
                          assign l-int = YES.   
            end.
        end.
        else do:
           if input frame {&frame-name} fi-it-codigo <> "" then do:
             for each operacao fields (it-codigo data-inicio data-termino tipo-oper op-codigo) where
                 operacao.it-codigo = input frame {&frame-name} fi-it-codigo and
                 operacao.data-inicio <= today and
                 operacao.data-termino > today no-lock:
                 IF operacao.tipo-oper = 2 then   
                    assign l-ext = YES.
                 else if operacao.tipo-oper = 1 then 
                    assign l-int = YES.
             end.
           end.
        end. 

      IF l-ext = YES then 
         cb-tipo:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i10in271.i 04 2}. 
      IF l-int = YES then 
         cb-tipo:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i10in271.i 04 1}.
      IF l-int = YES and
         l-ext = YES then   
         cb-tipo:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i10in271.i 04 3}. 
    end.
    else
       assign fi-descricao = "".
       disp fi-descricao.
       
    if fi-cod-estabel:screen-value <> "" then do:
        find first estabelec
            where estabelec.cod-estabel = fi-cod-estabel:screen-value no-lock no-error.
        if avail estabelec then
            run cdp/cd9970.p (input rowid(estabelec),
                              output i-empresa-prin).
	end.
    RUN pi-unif-ccusto (input ?).
END.

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

    ASSIGN THIS-PROCEDURE:PRIVATE-DATA = THIS-PROCEDURE:FILE-NAME.    

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


 {include/i-vldfrm.i} 

    RUN pi-upc (INPUT "before-validate",
                INPUT "viewer",
                INPUT ?,
                INPUT ?,
                INPUT "ord-prod",
                INPUT ROWID(ord-prod)).

 assign c-campo = ""
        l-res-conf = no
        l-ord-conf = no.

 find item where 
      item.it-codigo = input frame {&frame-name} fi-it-codigo 
      no-lock no-error.

 RUN pi-upc (INPUT "before-validate-item",
             INPUT "viewer",
             INPUT ?,
             INPUT ?,
             INPUT "item",
             INPUT ROWID(ITEM)).
 IF RETURN-VALUE = "adm-error":U THEN
     RETURN "adm-error":U.

 if adm-new-record then do:
    if avail item and item.compr-fabric = 1 then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U,
                          input 1086,
                          input "").
       if return-value = "no" then do:
          apply 'entry':U to fi-it-codigo in frame {&frame-name}. 
          return 'ADM-ERROR':U.
       end.

    end.
 end.
 else do:

    IF param-cp.log-integr-wms 
        AND input frame {&frame-name} fi-qt-ordem <> ord-prod.qt-ordem THEN DO:
    
        IF VALID-HANDLE(h-bosc038) THEN
           RUN verificaDoctoProd IN h-bosc038(INPUT  ord-prod.nr-ord-prod,
                                              OUTPUT l-docto-wms).
         
        IF l-docto-wms = YES THEN DO:
    
           {utp/ut-liter.i Ordem_de_Produá∆o mcp l}
           assign c-traducao = return-value.
                       
           {utp/ut-liter.i Integraá∆o_com_WMS mcp l}
           assign c-traducao = c-traducao + "~~" + return-value.
           
           run utp/ut-msgs.p (input "show":U,
                              INPUT 34995,
                              input c-traducao).
         
           return 'ADM-ERROR':U.
        END.
    END.    
    
    if input frame {&frame-name} fi-cod-refer <> ord-prod.cod-refer and
       not item.alt-refer then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U,
                           input 1232,
                           input "").
        return 'ADM-ERROR':U.       
    end.
    if  input frame {&frame-name} fi-it-codigo <> ord-prod.it-codigo or
        input frame {&frame-name} fi-cod-refer <> ord-prod.cod-refer then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U,
                           input 26654,
                           input "").
        if  return-value = "no":U then 
            return 'ADM-ERROR':U.
    end.
    else if input frame {&frame-name} fi-qt-ordem <> ord-prod.qt-ordem and
            item.politica                          = 5 then do:
        run utp/ut-msgs.p (input "show":U,
                           input 27176,
                           input "").
        if return-value = "yes":U then do:
            run pi-valida-reservas-config in h-cpapi301 (input ord-prod.nr-ord-produ,
                                                         output i-ord-erro).
            if return-value = 'nok':U then do:
                run utp/ut-msgs.p (input "show":U,
                                   input 27177,
                                   input string(i-ord-erro)).
                return 'ADM-ERROR':U.
            end.
            assign l-res-conf = yes
                   l-ord-conf = yes.
        end.
        else
            assign l-res-conf = yes
                   l-ord-conf = no.
    end.

/**INI-LEON*******************************/
    If  ord-prod.tipo <> cb-tipo:lookup(cb-tipo:Screen-value)
    And ord-prod.tipo = 9   /*Reaproveitamento*/
    Then Do:
        For Each b-reservas No-lock
            Where b-reservas.nr-ord-prod = ord-prod.nr-ord-prod:
            If b-reservas.it-codigo = ord-prod.it-codigo
            Then Do:
                Run utp/ut-msgs.p (Input "show",
                                   Input 52562,
                                   Input "").
                Apply "entry" To cb-tipo in frame {&frame-name}.
                Return "adm-error":U.
            End.
        End.
    End.
/**FIM-LEON*******************************/

 end. 
 
 /******************************************************************************************
 ** SEGURANCA ESTABELECIMENTO
 ******************************************************************************************/
 IF l-estab-security-active = YES THEN DO:
     IF NOT CAN-FIND(FIRST {&ESTAB-SEC-TT} 
                     WHERE {&ESTAB-SEC-TT-FIELD} = fi-cod-estabel:screen-value in frame {&frame-name} NO-LOCK) THEN DO:
         {utp/ut-liter.i Estabelecimento *}
         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 2,
                            INPUT trim(return-value)).
         apply 'entry':U to fi-cod-estabel in frame {&frame-name}.
         return 'ADM-ERROR':U.
     END.
 END.
 /******************************************************************************************
 ** SEGURANCA ESTABELECIMENTO
 ******************************************************************************************/
 
 find first item-uni-estab 
    where item-uni-estab.it-codigo = fi-it-codigo:screen-value in frame {&frame-name}
    and   item-uni-estab.cod-estabel = fi-cod-estabel:screen-value in frame {&frame-name} no-lock no-error.
 if not avail item-uni-estab then do:
    run utp/ut-msgs.p (input "show":U,input 25904, input fi-it-codigo:screen-value + "~~" + fi-cod-estabel:screen-value).
    apply 'entry':U to fi-cod-estabel in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.

 if cb-estado:screen-value = {ininc/i01in271.i 04 8} and 
                             param-global.modulo-cs then do:
    run utp/ut-msgs.p (input "show":U,
                       input 8999,
                       input "").
    apply "entry":U to cb-estado in frame {&frame-name}.
    return "adm-error":U.
 end.

 find lin-prod where 
      lin-prod.nr-linha =    int(fi-nr-linha:screen-value) and
      lin-prod.cod-estabel = fi-cod-estabel:SCREEN-VALUE no-lock no-error.

  if cb-rep-prod:SCREEN-VALUE = {ininc/i07in271.i 04 4} and 
     avail lin-prod AND 
     lin-prod.sum-requis <> 1 THEN DO:
     run utp/ut-msgs.p (input "show":U,
                        input 28158,
                        input "").
     apply "entry":U to cb-rep-prod in frame {&frame-name}.
     return "adm-error":U.
 END.

 IF l-usa-unid-negoc THEN DO:

     run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "c-unid-negocio").
     ASSIGN c-unid-negocio = RETURN-VALUE.

     IF NOT CAN-FIND (FIRST unid-negoc
                      WHERE unid-negoc.cod-unid-negoc = c-unid-negocio) THEN DO:

         {utp/ut-liter.i Unidade_de_Neg¢cio *}
         RUN utp/ut-msgs.p (INPUT "show":U,
                            INPUT 56,
                            INPUT RETURN-VALUE).
         RETURN "adm-error":U.
     END.
 END.
 
 RUN validateInfoSFC.
  
  if {ininc/i01in271.i 06 cb-estado} = 7 then do:
      if avail param-cp and param-cp.log-finaliza-op then do:
          for each reservas where reservas.nr-ord-produ = input fi-nr-ord-produ:
              if ord-prod.qt-produzida = 0 then do:
                  if reservas.quant-atend > 0 then do:			  
                      RUN utp/ut-msgs.p (INPUT "show":U,
                                         INPUT 54454,
                                         INPUT STRING(reservas.nr-ord-prod)).									   
                      RETURN "adm-error":U.
                  end.					  
              end.
              else do:
                  if reservas.quant-atend = 0 then do:
                      RUN utp/ut-msgs.p (INPUT "show":U,
                                         INPUT 54455,
                                         INPUT STRING(reservas.nr-ord-prod) + "~~" + STRING(reservas.it-codigo)).
                      RETURN "adm-error":U.
                  end.
              end.
          end.  
      end.
  end.

 run notify ('pi-validate,group-assign-target').

  RUN pi-upc (INPUT "after-validate",
               INPUT "viewer",
               INPUT ?,
               INPUT ?,
               INPUT "ord-prod",
               INPUT ROWID(ord-prod)).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE recebeHandlePag2 V-table-Win 
PROCEDURE recebeHandlePag2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle AS HANDLE NO-UNDO.

ASSIGN h-pag-2 = p-handle.

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

  CASE p-state:
      /* Object instance CASEs can go here to replace standard behavior
         or add new cases. */
      {src/adm/template/vstates.i}
  END CASE.
  run pi-trata-state (p-issuer-hdl, p-state).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateInfoSFC V-table-Win 
PROCEDURE validateInfoSFC :
/*------------------------------------------------------------------------------
  Purpose:     Valida dados da Ordem SFC
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
     DEFINE VARIABLE dat-imc AS DATE NO-UNDO.
     DEFINE VARIABLE dat-fmt AS DATE NO-UNDO.
     DEFINE VARIABLE hra-imc AS CHARACTER NO-UNDO.
     DEFINE VARIABLE hra-fmt AS CHARACTER NO-UNDO.
     DEFINE VARIABLE c-aux   AS CHARACTER   NO-UNDO. 

 
     IF l-mudancas-sfc AND cb-rep-prod:SCREEN-VALUE IN FRAME f-main <> {ininc/i07in271.i 04 4} THEN DO:
         /*Se mudancas sfc implantado e Tipo Reporte diferente de Item, valida os campos:*/

         ASSIGN dat-imc = DATE(f-retorna-campo("fi-dat-imc":U))
                dat-fmt = DATE(f-retorna-campo("fi-dat-fmt":U))
                hra-imc = SUBSTRING(f-retorna-campo("fi-hra-imc":U),1,2) + 
                          SUBSTRING(f-retorna-campo("fi-hra-imc":U),4,2)
                hra-fmt = SUBSTRING(f-retorna-campo("fi-hra-fmt":U),1,2) + 
                          SUBSTRING(f-retorna-campo("fi-hra-fmt":U),4,2).

         IF dat-imc = ? THEN DO:
             /*Data in°cio mais cedo deve ser informada*/
             {utp/ut-liter.i Data_In°cio_Mais_Cedo *}
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 31044,
                                INPUT RETURN-VALUE).
             IF VALID-HANDLE(h-pag-2) THEN
                 RUN applyEntry IN h-pag-2("fi-dat-imc":U).
             RETURN "adm-error":U.
         END.

         IF dat-fmt = ? THEN DO:
             /*Data fim mais tarde deve ser informada*/
             {utp/ut-liter.i Data_TÇrmino_Mais_Tarde *}
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 31044,
                                INPUT RETURN-VALUE).
             IF VALID-HANDLE(h-pag-2) THEN
                 RUN applyEntry IN h-pag-2("fi-dat-fmt":U).
             RETURN "adm-error":U.
         END.

         IF hra-imc = "":U THEN DO:
             /*Hora inicio mais cedo deve ser informada*/
             {utp/ut-liter.i Hora_In°cio_Mais_Cedo *}
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 31044,
                                INPUT RETURN-VALUE).
             IF VALID-HANDLE(h-pag-2) THEN
                 RUN applyEntry IN h-pag-2("fi-hra-imc":U).
             RETURN "adm-error":U.
         END.

         IF hra-fmt = "":U THEN DO:
             /*Hora inicio mais cedo deve ser informada*/
             {utp/ut-liter.i Hora_TÇrmino_Mais_Tarde *}
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 31044,
                                INPUT RETURN-VALUE).
             IF VALID-HANDLE(h-pag-2) THEN
                 RUN applyEntry IN h-pag-2("fi-hra-fmt":U).
             RETURN "adm-error":U.
         END.

         IF hra-imc > "2400":U THEN DO:
             /*Hora inicio mais cedo deve ser menor q 24*/
             {utp/ut-liter.i Hora_In°cio_Mais_Cedo *}
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 16445,
                                INPUT RETURN-VALUE + "~~ 24:00":U).
             IF VALID-HANDLE(h-pag-2) THEN
                 RUN applyEntry IN h-pag-2("fi-hra-imc":U).
             RETURN "adm-error":U.
         END.

         IF hra-imc > "2400":U THEN DO:
             /*Hora inicio mais cedo deve ser menor q 24*/
             {utp/ut-liter.i Hora_TÇrmino_Mais_Tarde *}
             RUN utp/ut-msgs.p (INPUT "show":U,
                                INPUT 16445,
                                INPUT RETURN-VALUE + "~~ 24:00":U).
             IF VALID-HANDLE(h-pag-2) THEN
                 RUN applyEntry IN h-pag-2("fi-hra-fmt":U).
             RETURN "adm-error":U.
         END.
     END.
 
RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-unif-ccusto V-table-Win 
PROCEDURE pi-unif-ccusto :
define input parameter pDt-valida as date no-undo.


IF fi-conta-ordem:SCREEN-VALUE IN FRAME {&FRAME-NAME} = "" THEN RETURN.

assign d-dt-valida = pdt-valida.

if d-dt-valida = ? then
	ASSIGN d-dt-valida = date(f-retorna-campo("fi-dt-emissao":U)).
	
IF d-dt-valida = ? THEN
    ASSIGN d-dt-valida = TODAY.


if not valid-handle(h_api_cta_ctbl) then run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.    
run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (INPUT i-empresa-prin,
                                                   INPUT "",
                                                   INPUT d-dt-valida,
                                                   OUTPUT p_cod_format_cta_ctbl,
                                                   OUTPUT TABLE tt_log_erro).


if p_cod_format_cta_ctbl <> "" then                
    assign fi-conta-ordem:format in frame {&frame-name} = p_cod_format_cta_ctbl.


find first estabelec no-lock 
     where estabelec.cod-estabel = input frame {&frame-name} fi-cod-estabel no-error.


if avail estabelec then do:
    {cdp/cdunif001a.i fi-conta-ordem fi-ccusto {&FRAME-NAME} d-dt-valida i-empresa-prin estabelec.cod-estabel}
end. 
else do:
    {cdp/cdunif001a.i fi-conta-ordem fi-ccusto {&FRAME-NAME} d-dt-valida i-empresa-prin """"}
end.



END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME
/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-formato-campo V-table-Win 
FUNCTION f-formato-campo RETURNS CHARACTER
  ( input c-campo as char,
    input i-tipo  as integer ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  run utp/ut-field.p (input "mgind", 
                      input "ord-prod", 
                      input c-campo, 
                      input string (i-tipo)).

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char) :
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

