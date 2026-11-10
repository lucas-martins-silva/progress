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
{include/i-prgvrs.i V05IN271 2.00.00.085 } /*** "010085" 17/09/2026 17:18:44 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v05in271 MUT}
&ENDIF

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

def var c-handle as char no-undo.
def var h-handle as handle no-undo.

{cdp/cdcfgman.i}   /* Vari†vel preprocessador bf_man_sfc_lc */

def var i-nr-seq        like ped-item.nr-sequencia.
/*def var i-ressup-fabri  like item.ressup-fabri.*/
DEF VAR i-ressup-fabri  AS DEC NO-UNDO.
def var i-ressup        like item.ressup-fabri.
def var i-tempo-reserv  like estrutura.tempo-reserv.
def var i-contador      as integer no-undo.
def var i-resto         as integer no-undo.
def var da-data-aux     as date format "99/99/9999" no-undo.
def var i-pedido        like ped-venda.nr-pedcli no-undo.
def var i-cod-sit-aval  like ped-venda.cod-sit-aval no-undo.
def var i-cod-sit-ped   like ped-venda.cod-sit-ped no-undo.
def var i-tam-per       as integer no-undo.
def var c-it-codigo     like ord-prod.it-codigo no-undo.
def var c-cod-refer     like ord-prod.cod-refer no-undo.

DEF VAR l-usa-unid-negoc    AS LOGICAL  NO-UNDO.
DEF VAR l-movto             AS LOGICAL  NO-UNDO.
DEF VAR h-cdapi024          AS HANDLE   NO-UNDO.

def var de-vezes           as decimal   no-undo.
def var de-qt-min          as decimal   no-undo.
def var de-qt-dlt          as decimal   no-undo.
def var i-dias-dlt         as integer   no-undo.
def var i-nr-dias          as integer   no-undo.

{cdp/cd9203.i}

DEF VAR hProgramZoom        AS HANDLE   NO-UNDO.
DEF VAR l-descon-per        AS LOGICAL  NO-UNDO.

DEFINE VARIABLE l-mudancas-sfc AS LOGICAL INIT NO NO-UNDO.
DEFINE VARIABLE i-rep-prod     AS INTEGER     NO-UNDO.

&IF DEFINED(bf_man_204) &THEN
    {sfc/sf0309.i p} /*Funcao para tratamento de leave dos campos de hora*/
&ENDIF

DEFINE VARIABLE h-handle-pai AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-erro       AS LOGICAL    NO-UNDO.
DEFINE VARIABLE h-boin029    AS HANDLE     NO-UNDO.
DEFINE VARIABLE de-maior-per AS DECIMAL    NO-UNDO.
DEFINE VARIABLE c-lbl-msg1   AS CHARACTER  NO-UNDO.

DEFINE SHARED VARIABLE l-new-ordem AS LOGICAL     NO-UNDO.

DEF TEMP-TABLE tt-matriz NO-UNDO
    FIELD cod-unid-negoc AS CHAR
    FIELD perc-rateio AS DEC.

DEF TEMP-TABLE tt-erro-aux NO-UNDO
    FIELD i-sequen AS INT             
    FIELD cd-erro  AS INT
    FIELD mensagem AS CHAR FORMAT "x(255)".
    
IF CAN-FIND(FIRST funcao
            WHERE funcao.cd-funcao = "spp-descon-per" 
              AND funcao.ativo     = YES) THEN
    ASSIGN l-descon-per = YES.

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
&Scoped-Define ENABLED-OBJECTS FILL-IN-1 fi-dat-imc fi-hra-imc fi-dat-fmt ~
fi-hra-fmt rt-mold rt-mold-2 
&Scoped-Define DISPLAYED-OBJECTS fi-dt-inicio fi-dt-termino FILL-IN-1 ~
fi-dt-orig fi-dt-emissao fi-nome-abrev fi-cod-gr-cli fi-nr-pedido ~
fi-nr-sequencia fi-nr-entrega c-unid-negocio fi-lote-serie fi-prioridade ~
fi-num-ord-inv fi-dat-imc fi-hra-imc fi-dat-fmt fi-hra-fmt tb-emite-ordem ~
tb-emite-requis c-cod-lista-compon c-cod-roteiro 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS fi-dt-inicio fi-dt-termino fi-dt-emissao ~
fi-nome-abrev fi-cod-gr-cli fi-nr-pedido fi-nr-sequencia fi-nr-entrega ~
fi-lote-serie fi-prioridade tb-emite-ordem tb-emite-requis 
&Scoped-define ADM-ASSIGN-FIELDS fi-dt-termino fi-dt-orig fi-dt-emissao ~
fi-nome-abrev fi-cod-gr-cli fi-nr-pedido fi-nr-sequencia fi-nr-entrega ~
fi-lote-serie fi-prioridade tb-emite-ordem tb-emite-requis 
&Scoped-define ADM-MODIFY-FIELDS fi-dt-termino fi-dt-emissao fi-nome-abrev ~
fi-cod-gr-cli fi-nr-pedido fi-nr-sequencia fi-nr-entrega fi-lote-serie ~
fi-prioridade tb-emite-ordem tb-emite-requis 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-formato-campo V-table-Win 
FUNCTION f-formato-campo RETURNS CHARACTER
  ( input c-campo as char,
    input i-tipo  as integer )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cod-lista-compon AS CHARACTER FORMAT "X(16)":U 
     LABEL "Lista Componentes" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-cod-roteiro AS CHARACTER FORMAT "X(16)":U 
     LABEL "Roteiro" 
     VIEW-AS FILL-IN 
     SIZE 16 BY .88 NO-UNDO.

DEFINE VARIABLE c-unid-negocio AS CHARACTER FORMAT "X(3)":U 
     LABEL "Unid. Neg¢cio" 
     VIEW-AS FILL-IN 
     SIZE 7 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-gr-cli AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Grupo Cliente":R16 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88.

DEFINE VARIABLE fi-dat-fmt AS DATE FORMAT "99/99/9999":U 
     LABEL "Fim Mais Tarde" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Data de Fim Mais Tarde" NO-UNDO.

DEFINE VARIABLE fi-dat-imc AS DATE FORMAT "99/99/9999":U 
     LABEL "In°cio Mais Cedo" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 TOOLTIP "Data de In°cio Mais Cedo" NO-UNDO.

DEFINE VARIABLE fi-dt-emissao AS DATE FORMAT "99/99/9999" INITIAL 12/22/97 
     LABEL "Data Emiss∆o":R15 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-dt-inicio AS DATE FORMAT "99/99/9999" 
     LABEL "Data Inicio":R14 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-dt-orig AS DATE FORMAT "99/99/9999" 
     LABEL "Data Original":R25 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-dt-termino AS DATE FORMAT "99/99/9999" INITIAL 12/22/97 
     LABEL "Data TÇrmino":R15 
     VIEW-AS FILL-IN 
     SIZE 12.86 BY .88.

DEFINE VARIABLE fi-hra-fmt AS CHARACTER FORMAT "99:99":U 
     LABEL "HRA FMT" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 TOOLTIP "Hora de Fim Mais Tarde" NO-UNDO.

DEFINE VARIABLE fi-hra-imc AS CHARACTER FORMAT "99:99":U 
     LABEL "HRA IMC" 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 TOOLTIP "Hora de In°cio Mais Cedo" NO-UNDO.

DEFINE VARIABLE fi-lote-serie AS CHARACTER FORMAT "x(40)" 
     LABEL "Lote/Serie":R12 
     VIEW-AS FILL-IN 
     SIZE 24 BY .88.

DEFINE VARIABLE fi-nome-abrev AS CHARACTER FORMAT "x(12)" 
     LABEL "Cliente":R9 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE fi-nr-entrega AS INTEGER FORMAT ">>>>9" INITIAL 0 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE fi-nr-pedido AS CHARACTER FORMAT "x(12)" 
     LABEL "Pedido Cliente":R17 
     VIEW-AS FILL-IN 
     SIZE 16.43 BY .88.

DEFINE VARIABLE fi-nr-sequencia AS INTEGER FORMAT ">>>>9" INITIAL 0 
     LABEL "Sequencia":R11 
     VIEW-AS FILL-IN 
     SIZE 7.43 BY .88.

DEFINE VARIABLE fi-num-ord-inv AS INTEGER FORMAT ">>>,>>>,>>9":U INITIAL 0 
     LABEL "Ordem Invest" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE fi-prioridade AS INTEGER FORMAT "99" INITIAL 99 
     LABEL "Prioridade":R12 
     VIEW-AS FILL-IN 
     SIZE 4.86 BY .88.

DEFINE VARIABLE FILL-IN-1 AS CHARACTER FORMAT "X(256)":U INITIAL "/" 
      VIEW-AS TEXT 
     SIZE 1 BY .67 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42 BY 9.71.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.57 BY 9.71.

DEFINE VARIABLE tb-emite-ordem AS LOGICAL INITIAL yes 
     LABEL "Emite Ordem":L14 
     VIEW-AS TOGGLE-BOX
     SIZE 18.57 BY .75.

DEFINE VARIABLE tb-emite-requis AS LOGICAL INITIAL yes 
     LABEL "Emite Requisiá∆o":L20 
     VIEW-AS TOGGLE-BOX
     SIZE 23.43 BY .75.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-dt-inicio AT ROW 1.25 COL 23 COLON-ALIGNED
     fi-dt-termino AT ROW 2.25 COL 23 COLON-ALIGNED
     FILL-IN-1 AT ROW 8.42 COL 30.86 COLON-ALIGNED NO-LABEL
     fi-dt-orig AT ROW 3.25 COL 23 COLON-ALIGNED
     fi-dt-emissao AT ROW 4.25 COL 23 COLON-ALIGNED
     fi-nome-abrev AT ROW 5.25 COL 23 COLON-ALIGNED
     fi-cod-gr-cli AT ROW 6.25 COL 23 COLON-ALIGNED
     fi-nr-pedido AT ROW 7.25 COL 23 COLON-ALIGNED
     fi-nr-sequencia AT ROW 8.25 COL 23 COLON-ALIGNED
     fi-nr-entrega AT ROW 8.25 COL 32 COLON-ALIGNED NO-LABEL
     c-unid-negocio AT ROW 9.25 COL 23 COLON-ALIGNED
     fi-lote-serie AT ROW 1.25 COL 59 COLON-ALIGNED
     fi-prioridade AT ROW 2.25 COL 59 COLON-ALIGNED
     fi-num-ord-inv AT ROW 3.25 COL 59 COLON-ALIGNED
     fi-dat-imc AT ROW 4.42 COL 59 COLON-ALIGNED HELP
          "Data de In°cio Mais Cedo"
     fi-hra-imc AT ROW 4.42 COL 78.86 COLON-ALIGNED HELP
          "Hora de In°cio Mais Cedo"
     fi-dat-fmt AT ROW 5.46 COL 59 COLON-ALIGNED HELP
          "Data de Fim Mais Tarde"
     fi-hra-fmt AT ROW 5.46 COL 78.86 COLON-ALIGNED HELP
          "Hora de Fim Mais Tarde"
     tb-emite-ordem AT ROW 6.63 COL 62.57
     tb-emite-requis AT ROW 7.42 COL 62.57
     c-cod-lista-compon AT ROW 8.25 COL 65.57 COLON-ALIGNED
     c-cod-roteiro AT ROW 9.25 COL 65.57 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
     rt-mold-2 AT ROW 1 COL 44
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
         HEIGHT             = 9.92
         WIDTH              = 86.14.
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

/* SETTINGS FOR FILL-IN c-cod-lista-compon IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-lista-compon:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-roteiro:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-unid-negocio IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-unid-negocio:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-gr-cli IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-dt-emissao IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-dt-inicio IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-dt-orig IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN fi-dt-termino IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-lote-serie IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-nome-abrev IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-nr-entrega IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-nr-pedido IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-nr-sequencia IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR FILL-IN fi-num-ord-inv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-prioridade IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tb-emite-ordem IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
/* SETTINGS FOR TOGGLE-BOX tb-emite-requis IN FRAME f-main
   NO-ENABLE 1 2 3                                                      */
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

&Scoped-define SELF-NAME c-cod-lista-compon
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-lista-compon V-table-Win
ON F5 OF c-cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    &IF DEFINED (bf_man_sfc_lc) &THEN
        {include/zoomvar.i &prog-zoom="inzoom/z01in481.w"  
                           &campo=c-cod-lista-compon
                           &campozoom=cod-lista-compon
                           &campo2=c-cod-roteiro
                           &campozoom2=cod-roteiro}
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-lista-compon V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-lista-compon IN FRAME f-main /* Lista Componentes */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-roteiro V-table-Win
ON F5 OF c-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
    &IF DEFINED (bf_man_sfc_lc) &THEN
        {include/zoomvar.i &prog-zoom="inzoom/z01in481.w"  
                           &campo=c-cod-lista-compon
                           &campozoom=cod-lista-compon
                           &campo2=c-cod-roteiro
                           &campozoom2=cod-roteiro}
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
    apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-unid-negocio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negocio V-table-Win
ON F5 OF c-unid-negocio IN FRAME f-main /* Unid. Neg¢cio */
DO:

    &IF DEFINED(bf_man_206b) &THEN
    
        {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1=cod-unid-negoc
                             &FieldScreen1=c-unid-negocio
                             &Frame1=f-main}
                           
    &ENDIF
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-unid-negocio V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-unid-negocio IN FRAME f-main /* Unid. Neg¢cio */
DO:

    APPLY "F5":U TO SELF.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-gr-cli
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-gr-cli V-table-Win
ON F5 OF fi-cod-gr-cli IN FRAME f-main /* Grupo Cliente */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="adzoom/z01ad129.w"
                     &campo=fi-cod-gr-cli
                     &campozoom=cod-gr-cli}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-gr-cli V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-gr-cli IN FRAME f-main /* Grupo Cliente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dt-inicio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-inicio V-table-Win
ON F5 OF fi-dt-inicio IN FRAME f-main /* Data Inicio */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in299.w"
                     &campo=fi-dt-inicio
                     &campozoom=dt-inicio}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-inicio V-table-Win
ON LEAVE OF fi-dt-inicio IN FRAME f-main /* Data Inicio */
DO:
  if (input frame {&frame-name} fi-dt-orig    <> fi-dt-orig     or
      input frame {&frame-name} fi-dt-termino <> fi-dt-termino  OR
      input frame {&frame-name} fi-dt-inicio  <> fi-dt-inicio   OR
      input frame {&frame-name} fi-dt-termino =  ?) and
      input frame {&frame-name} fi-dt-inicio  <> ? then do:

     assign fi-dt-orig    = input frame {&frame-name} fi-dt-orig
            fi-dt-termino = input frame {&frame-name} fi-dt-termino
            fi-dt-inicio = input frame {&frame-name} fi-dt-inicio.            

     if l-descon-per = NO then 

         run pi-atualiza-datas.
                
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-inicio V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-dt-inicio IN FRAME f-main /* Data Inicio */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-dt-termino
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-termino V-table-Win
ON F5 OF fi-dt-termino IN FRAME f-main /* Data TÇrmino */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in299.w"
                     &campo=fi-dt-termino
                     &campozoom=dt-termino}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-termino V-table-Win
ON LEAVE OF fi-dt-termino IN FRAME f-main /* Data TÇrmino */
DO:
  {cpp/cpapi301.i17}

  DEFINE VARIABLE c-cod-estabel AS CHARACTER  NO-UNDO.
  DEFINE VARIABLE de-qt-ordem   AS DECIMAL    NO-UNDO.

  run get-field-screen-value in adm-broker-hdl (INPUT this-procedure,
                                                INPUT "fi-cod-estabel").
  ASSIGN c-cod-estabel = RETURN-VALUE.

  run get-field-screen-value in adm-broker-hdl (INPUT this-procedure,
                                                INPUT "fi-qt-ordem").
  ASSIGN de-qt-ordem = DECIMAL(RETURN-VALUE).

  if input fi-dt-inicio = ? then do:
     assign da-data-aux    = input fi-dt-termino
            fi-dt-termino  = input fi-dt-termino.

    FIND item-uni-estab WHERE item-uni-estab.it-codigo   = item.it-codigo
                          AND item-uni-estab.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL item-uni-estab THEN
        ASSIGN  i-ressup-fabri = INT (f-item-uni-estab (input item.it-codigo,
                                                         INPUT c-cod-estabel,
                                                         "ressup-fabri":U ))
                de-qt-min      = item-uni-estab.qt-min-res-fabr
                de-qt-dlt      = item-uni-estab.var-qtd-res-fabr
                i-dias-dlt     = item-uni-estab.var-tempo-res-fabr.

    
    IF de-qt-ordem >= de-qt-min THEN DO:
    
            assign de-qt-ordem = de-qt-ordem - de-qt-min
                   /*de-vezes = IF AVAIL item-uni-estab THEN      /* A adiá∆o do campo item-uni-estab.ressup-fabri a este ponto do calculo */ 
                                item-uni-estab.ressup-fabri          /* estava resultando no ressuprimento errado */                 
                              ELSE
                                ITEM.ressup-fabri*/
                   de-vezes = /*de-vezes + */(de-qt-ordem / de-qt-dlt).
            
            ASSIGN de-vezes = (if de-vezes = ? then
                                  0
                               else
                                  de-vezes).
                                  
            IF de-qt-dlt > 0 AND i-dias-dlt > 0 THEN 
                ASSIGN de-vezes = (if trunc(de-vezes,0) = de-vezes then
                                       de-vezes
                                   else
                                       trunc(de-vezes,0) + 1).                                  

            ASSIGN i-ressup-fabri = i-ressup-fabri + (de-vezes * i-dias-dlt).
            
            assign i-ressup-fabri = i-ressup-fabri + item.res-cq-fabri - i-nr-dias
                   i-resto        = if i-ressup-fabri > 0
                                   then i-ressup-fabri modulo i-tam-per
                                   else 0
                   i-ressup-fabri = if i-resto <> 0
                                    then truncate (i-ressup-fabri / i-tam-per, 0) /*+ 1*/
                                    else i-ressup-fabri / i-tam-per. 

    END.

     FIND FIRST tipo-per
          WHERE tipo-per.cd-tipo = param-cp.cd-tipo NO-LOCK NO-ERROR.
     IF AVAIL tipo-per THEN
          IF i-ressup-fabri = 0 THEN
            CASE tipo-per.tipo:
                WHEN 1 THEN
                     ASSIGN i-ressup-fabri = 1.
                WHEN 2 THEN
                     ASSIGN i-ressup-fabri = 1.
                WHEN 3 THEN 
                     ASSIGN i-ressup-fabri = 1.
            END CASE.   

     find last periodo
          where periodo.cd-tipo    = param-cp.cd-tipo
            and periodo.dt-inicio <= da-data-aux no-lock no-error.

     do i-contador = 1 to i-ressup-fabri:
        find prev periodo use-index codigo
             where periodo.cd-tipo = param-cp.cd-tipo
             no-lock no-error.
     end.

     if not avail periodo then
        find first periodo use-index codigo
             where periodo.cd-tipo = param-cp.cd-tipo
             no-lock no-error.

     if avail periodo then        
        assign da-data-aux = periodo.dt-inicio.

     find first periodo use-index ch-termino
          where periodo.cd-tipo    =  param-cp.cd-tipo
            and periodo.dt-termino >= da-data-aux NO-LOCK NO-ERROR.
     assign fi-dt-inicio:screen-value = string (periodo.dt-inicio).
  end.
  if input fi-dt-termino <> ? and (adm-new-record OR l-new-ordem) then 
     assign fi-dt-orig:screen-value = input fi-dt-termino.    

  assign fi-dt-orig    = input frame {&frame-name} fi-dt-orig
         fi-dt-termino = input frame {&frame-name} fi-dt-termino.

  RUN atualizaDatasSFC.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-dt-termino V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-dt-termino IN FRAME f-main /* Data TÇrmino */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-fmt
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fmt V-table-Win
ON ALT-O OF fi-hra-fmt IN FRAME f-main /* HRA FMT */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fmt V-table-Win
ON LEAVE OF fi-hra-fmt IN FRAME f-main /* HRA FMT */
DO:
    ASSIGN l-erro = NO.
    &IF DEFINED(bf_man_204) &THEN
    
        ASSIGN fi-hra-fmt = fnValidaHora(fi-hra-fmt:SCREEN-VALUE IN FRAME f-main).
        IF fi-hra-fmt = ? THEN DO:

            run utp/ut-msgs.p (input "show":U,
                               input 29520,
                               input "":U).

            APPLY "ENTRY":U to fi-hra-fmt in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.

        END.

        DISPLAY fi-hra-fmt WITH FRAME f-main.
    &endif  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-fmt V-table-Win
ON RETURN OF fi-hra-fmt IN FRAME f-main /* HRA FMT */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.
    &ENDIF  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-hra-imc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-imc V-table-Win
ON ALT-O OF fi-hra-imc IN FRAME f-main /* HRA IMC */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "return":U TO SELF.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-imc V-table-Win
ON LEAVE OF fi-hra-imc IN FRAME f-main /* HRA IMC */
DO:
    ASSIGN l-erro = NO.
    &IF DEFINED(bf_man_204) &THEN
    
        ASSIGN fi-hra-imc = fnValidaHora(fi-hra-imc:SCREEN-VALUE IN FRAME f-main).
        IF fi-hra-imc = ? THEN DO:

            run utp/ut-msgs.p (input "show":U,
                               input 29520,
                               input "":U).

            APPLY "ENTRY":U to fi-hra-imc in frame f-main.
            ASSIGN l-erro = YES.
            RETURN NO-APPLY.

        END.

        DISPLAY fi-hra-imc WITH FRAME f-main.
    &endif
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-hra-imc V-table-Win
ON RETURN OF fi-hra-imc IN FRAME f-main /* HRA IMC */
DO:
    &IF DEFINED(bf_man_204) &THEN
        APPLY "leave":U TO SELF.
        IF l-erro = NO AND VALID-HANDLE(h-handle-pai) THEN
            RUN acionaOk IN h-handle-pai.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-lote-serie
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-lote-serie V-table-Win
ON LEAVE OF fi-lote-serie IN FRAME f-main /* Lote/Serie */
DO:
  /** Chamada referente Ös chamadas X do Magnus do CP0301. 
      Apenas para Modificar. **/
     IF adm-new-record    = NO AND
        adm-adding-record = NO   THEN DO:
        RUN pi-upc (INPUT "lote",
                    INPUT "lote",
                    INPUT ?,
                    INPUT ?,
                    INPUT "ord-prod",
                    INPUT ROWID(ord-prod)).
     END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nome-abrev V-table-Win
ON F5 OF fi-nome-abrev IN FRAME f-main /* Cliente */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z02ad098.w"  
                     &campo=fi-nome-abrev
                     &campozoom=nome-abrev}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nome-abrev V-table-Win
ON LEAVE OF fi-nome-abrev IN FRAME f-main /* Cliente */
DO:
  find first emitente where emitente.nome-abrev = input fi-nome-abrev and
                            emitente.identific <> 2
                            no-lock no-error.
  if avail emitente 
     then assign fi-cod-gr-cli:screen-value = string (emitente.cod-gr-cli).

  if input fi-nome-abrev <> "" then
     run notify ('pi-mostra-narrativa,group-assign-target').

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-nome-abrev IN FRAME f-main /* Cliente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-pedido
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedido V-table-Win
ON F5 OF fi-nr-pedido IN FRAME f-main /* Pedido Cliente */
DO:

  assign l-implanta = NO. 
  {include/zoomvar.i &prog-zoom="dizoom/z01di149.w"
                     &campo=fi-nr-pedido
                     &campozoom=nr-pedcli
                     &campo2=fi-nome-abrev
                     &campozoom2=nome-abrev
                     &campo3=fi-nr-sequencia
                     &campozoom3=nr-sequencia
                     &campo4=fi-nr-entrega
                     &campozoom4=nr-entrega}.
                     
    &IF DEFINED(bf_man_206b) &THEN
    RUN pi-confere-unid-negoc.
    &ENDIF

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedido V-table-Win
ON LEAVE OF fi-nr-pedido IN FRAME f-main /* Pedido Cliente */
DO:
    if fi-nr-pedido:screen-value in frame f-main <> "" then do:
        find first ped-venda no-lock
             where ped-venda.nr-pedcli = trim(fi-nr-pedido:screen-value in frame f-main) no-error.

        if avail ped-venda then do:
            assign fi-nome-abrev:screen-value   in frame f-main = ped-venda.nome-abrev
                   fi-cod-gr-cli:screen-value   in frame f-main = string(ped-venda.cod-gr-cli)
                   fi-nr-sequencia:screen-value in frame f-main = "1"
                   fi-nr-entrega:screen-value   in frame f-main = "1"
                   fi-nome-abrev   = ped-venda.nome-abrev
                   fi-cod-gr-cli   = ped-venda.cod-gr-cli
                   fi-nr-sequencia = 1
                   fi-nr-entrega   = 1.

            run notify ('pi-mostra-narrativa,group-assign-target').
        end.
    end.
END.
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-pedido V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-nr-pedido IN FRAME f-main /* Pedido Cliente */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-nr-sequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-nr-sequencia V-table-Win
ON LEAVE OF fi-nr-sequencia IN FRAME f-main /* Sequencia */
DO:
        &IF DEFINED(bf_man_206b) &THEN
        RUN pi-confere-unid-negoc.
      &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-num-ord-inv
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-ord-inv V-table-Win
ON F5 OF fi-num-ord-inv IN FRAME f-main /* Ordem Invest */
DO:
    {include/zoomvar.i &prog-zoom=ivzoom/z05iv043.w
                     &campo=fi-num-ord-inv
                     &campozoom=num-ord-magnus}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-ord-inv V-table-Win
ON LEAVE OF fi-num-ord-inv IN FRAME f-main /* Ordem Invest */
DO:
  &IF DEFINED (bf_man_206b) &THEN
     IF l-usa-unid-negoc THEN DO:
         ASSIGN de-maior-per = 0.
         FIND FIRST param-global NO-LOCK NO-ERROR.
         IF AVAIL param-global THEN DO:
             IF param-global.modulo-in AND CONNECTED("mginv") THEN DO:
                 run get-field-screen-value in adm-broker-hdl (INPUT this-procedure,
                                                               INPUT "fi-it-codigo").
                 FIND FIRST ITEM WHERE ITEM.it-codigo = RETURN-VALUE NO-LOCK NO-ERROR.
                 IF AVAIL ITEM THEN DO:
                     IF ITEM.tipo-contr = 4 AND INPUT FRAME {&FRAME-NAME} fi-num-ord-inv > 0 THEN DO:
                         RUN ivbo/boiv029.p PERSISTENT SET h-boin029.
                         RUN retornaMatrizUnidNegoc IN h-boin029(INPUT INPUT FRAME {&FRAME-NAME} fi-num-ord-inv,
                                                                 OUTPUT TABLE tt-matriz,
                                                                 OUTPUT TABLE tt-erro-aux).
                         DELETE PROCEDURE h-boin029.
                         FOR EACH tt-matriz:
                             IF tt-matriz.perc-rateio > de-maior-per THEN
                                 ASSIGN de-maior-per                = tt-matriz.perc-rateio
                                        c-unid-negocio:SCREEN-VALUE = tt-matriz.cod-unid-negoc.
                         END.
                     END.
                 END.
             END.
         END.
     END.
  &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-num-ord-inv V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-num-ord-inv IN FRAME f-main /* Ordem Invest */
DO:
    apply "F5":U to self.
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

    {utp/ut-field.i movind ord-prod dt-inicio 01}
    assign fi-dt-inicio:label in frame {&frame-name} = return-value.

    {utp/ut-field.i movind ord-prod dt-termino 01}
    assign fi-dt-termino:label in frame {&frame-name} = return-value.

    {utp/ut-field.i movind ord-prod prioridade 01}
    assign fi-prioridade:label in frame {&frame-name} = return-value.

    &IF DEFINED (bf_man_sfc_lc) &THEN
        {utp/ut-liter.i Lista_Componentes * R}
        assign c-cod-lista-compon:label  in frame {&frame-name} = trim(return-value)
               c-cod-lista-compon:hidden in frame {&frame-name} = no.

        {utp/ut-liter.i Roteiro * R}
        assign c-cod-roteiro:label  in frame {&frame-name} = trim(return-value)
               c-cod-roteiro:hidden in frame {&frame-name} = no.

        c-cod-lista-compon:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name}.
        c-cod-roteiro:load-mouse-pointer      ("image/lupa.cur":U) in frame {&frame-name} .
    &ELSE
        assign c-cod-lista-compon:hidden in frame {&frame-name} = yes
               c-cod-roteiro:hidden      in frame {&frame-name} = yes.
    &ENDIF

    fi-nome-abrev:load-mouse-pointer  ("image/lupa.cur":U) in frame {&frame-name} .
    fi-cod-gr-cli:load-mouse-pointer  ("image/lupa.cur":U) in frame {&frame-name} .
    fi-nr-pedido:load-mouse-pointer   ("image/lupa.cur":U) in frame {&frame-name} .
    fi-dt-inicio:load-mouse-pointer   ("image/lupa.cur":U) in frame {&frame-name} .
    fi-dt-termino:load-mouse-pointer  ("image/lupa.cur":U) in frame {&frame-name} .
    fi-num-ord-inv:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name} .

    &IF DEFINED(bf_man_206b) &THEN
    
        ASSIGN l-usa-unid-negoc = NO.

        IF CAN-FIND (FIRST funcao
                     WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO"
                     AND   funcao.ativo     = YES) THEN DO:

            ASSIGN l-usa-unid-negoc = YES.

        END.

        IF l-usa-unid-negoc THEN DO:
            c-unid-negocio:load-mouse-pointer ("image/lupa.cur":U) in frame {&frame-name} .
        END.

    &ENDIF
    
    &IF DEFINED(bf_man_204) &THEN
        {sfc/sf9000.i}
    &ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE applyEntry V-table-Win 
PROCEDURE applyEntry :
/*------------------------------------------------------------------------------
  Purpose:     Aplica a trigger de entry para os campos da ordem SFC.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

DEF INPUT PARAM p-campo AS CHAR NO-UNDO.

CASE p-campo:
    WHEN "fi-dat-imc":U THEN
        APPLY "entry":U TO fi-dat-imc IN FRAME f-main.
    WHEN "fi-hra-imc":U THEN
        APPLY "entry":U TO fi-hra-imc IN FRAME f-main.
    WHEN "fi-dat-fmt":U THEN
        APPLY "entry":U TO fi-dat-fmt IN FRAME f-main.
    WHEN "fi-hra-fmt":U THEN
        APPLY "entry":U TO fi-hra-fmt IN FRAME f-main.
END CASE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizaDatasSFC V-table-Win 
PROCEDURE atualizaDatasSFC :
/*------------------------------------------------------------------------------
  Purpose:     Atualiza as datas da Ordem SFC conforme as datas da OP
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
&IF DEFINED(bf_man_204) &THEN
    IF l-mudancas-sfc AND i-rep-prod <> 4 THEN
        IF adm-new-record OR
           (AVAIL ord-prod AND NOT CAN-FIND(FIRST op-sfc WHERE op-sfc.nr-ord-produ = ord-prod.nr-ord-produ NO-LOCK)) 
            THEN DO WITH FRAME f-main:
            ASSIGN fi-dat-imc:SCREEN-VALUE = fi-dt-inicio:SCREEN-VALUE
                   fi-dat-fmt:SCREEN-VALUE = fi-dt-termino:SCREEN-VALUE
                   fi-hra-imc:SCREEN-VALUE = "0000":U
                   fi-hra-fmt:SCREEN-VALUE = "2359":U.
        END.
&ENDIF

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE displayInfoSFC V-table-Win 
PROCEDURE displayInfoSFC :
/*------------------------------------------------------------------------------
  Purpose:     Mostra as informacoes dos campos da OP-SFC
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-rep-prod AS INT NO-UNDO.
DEF INPUT PARAM p-nr-ord-produ AS INT NO-UNDO.

DEFINE VARIABLE c-aux AS CHARACTER  NO-UNDO.
DEF BUFFER bf-ord-prod FOR ord-prod.

&IF DEFINED(bf_man_204) &THEN
    IF l-mudancas-sfc THEN DO WITH FRAME f-main:
        ASSIGN i-rep-prod = p-rep-prod.
        IF p-rep-prod <> 4 THEN DO:

            ASSIGN fi-dat-imc:SENSITIVE = YES
                   fi-dat-fmt:SENSITIVE = YES
                   fi-hra-imc:SENSITIVE = YES
                   fi-hra-fmt:SENSITIVE = YES
                   fi-hra-imc:SCREEN-VALUE = "0000":U
                   fi-hra-fmt:SCREEN-VALUE = "2359":U.

            /*Se implantada funcao Mudancas SFC e reporte nao for por Item, entao mostra informacoes de SFC*/
            FIND FIRST op-sfc WHERE op-sfc.nr-ord-produ = p-nr-ord-produ NO-LOCK NO-ERROR.
            IF AVAIL op-sfc THEN DO:
    
                ASSIGN fi-dat-imc:SCREEN-VALUE = string(op-sfc.dat-imc)
                       fi-dat-fmt:SCREEN-VALUE = string(op-sfc.dat-fmt).
    
                run pi-sec-to-formatted-time (op-sfc.qtd-segs-imc, output c-aux).
                ASSIGN fi-hra-imc:SCREEN-VALUE = c-aux.
    
                run pi-sec-to-formatted-time (op-sfc.qtd-segs-fmt, output c-aux). 
                ASSIGN fi-hra-fmt:SCREEN-VALUE = c-aux.
            END.
        END.
        ELSE
            /*Reporte por item, nao grava as informaá‰es de SFC, desabilita os campos*/
            ASSIGN fi-dat-imc:SENSITIVE = NO
                   fi-dat-fmt:SENSITIVE = NO
                   fi-hra-imc:SENSITIVE = NO
                   fi-hra-fmt:SENSITIVE = NO
                   fi-dat-imc:SCREEN-VALUE = "":U
                   fi-dat-fmt:SCREEN-VALUE = "":U
                   fi-hra-imc:SCREEN-VALUE = "":U
                   fi-hra-fmt:SCREEN-VALUE = "":U.
    END.
&ENDIF

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

 do with frame {&frame-name}:
    assign fi-dt-inicio:screen-value    = f-formato-campo ("dt-inicio":U, 5)
           fi-dt-inicio                 = ?
           fi-dt-termino:screen-value   = f-formato-campo ("dt-termino":U, 5)
           fi-dt-termino                = ?
           fi-dt-orig:screen-value      = f-formato-campo ("dt-orig":U, 5)
           fi-dt-emissao:screen-value   = f-formato-campo ("dt-emissao":U, 5)
           fi-nome-abrev:screen-value   = f-formato-campo ("nome-abrev":U, 5)
           fi-cod-gr-cli:screen-value   = f-formato-campo ("cod-gr-cli":U, 5)
           fi-nr-pedido:screen-value    = f-formato-campo ("nr-pedido":U, 5)
           fi-nr-sequencia:screen-value = f-formato-campo ("nr-sequencia":U, 5)
           fi-lote-serie:screen-value   = f-formato-campo ("lote-serie":U, 5)
           fi-prioridade:screen-value   = "99"
           fi-num-ord-inv:screen-value  = f-formato-campo ("num-ord-inv":U, 5)
           tb-emite-ordem:checked       = (f-formato-campo ("emite-ordem":U, 5) = "yes":U )
           tb-emite-requis:checked      = (f-formato-campo ("emite-requis":U, 5)= "yes":U ).

 end.

 RUN atualizaDatasSFC.


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

  /* Dispatch standard ADM method.                             */
  /*RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .*/

  /* Code placed here will execute AFTER standard behavior.    */
  assign fi-dt-inicio = date(fi-dt-inicio:screen-value in frame {&frame-name}).


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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

    assign fi-dt-inicio:screen-value    = string (today)
           fi-dt-emissao                = today
           fi-dt-emissao:screen-value   = string (today)
           input frame {&frame-name} fi-nome-abrev.
	 
    if l-descon-per = NO then
    
        run pi-atualiza-datas.

  RUN atualizaDatasSFC.

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

  IF VALID-HANDLE(h-cdapi024) THEN DO:
      RUN pi-finalizar IN h-cdapi024.
      ASSIGN h-cdapi024 = ?.
  END.

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
  
  &IF DEFINED(bf_man_206b) &THEN
      IF l-usa-unid-negoc THEN DO:
          DISABLE c-unid-negocio WITH FRAME {&FRAME-NAME}.
      END.
  &ENDIF

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

    if  avail(ord-prod) and 
        not(fi-dt-inicio:sensitive in frame {&frame-name}) then
        assign fi-dt-inicio = fi-dt-inicio.

    &IF DEFINED (bf_man_sfc_lc) &THEN    
        if  avail ord-prod then 
            assign c-cod-lista-compon = ord-prod.cod-lista-compon
                   c-cod-roteiro      = ord-prod.cod-roteiro.
        else
            assign c-cod-lista-compon = ""
                   c-cod-roteiro      = "".
    &ENDIF

  /* Dispatch standard ADM method. */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */  

    if  avail ord-prod then do with frame {&frame-name}:
        assign fi-dt-inicio:screen-value    = string (ord-prod.dt-inicio)
               fi-dt-inicio                 = ord-prod.dt-inicio
               fi-dt-termino:screen-value   = string (ord-prod.dt-termino)
               fi-dt-termino                = ord-prod.dt-termino
               fi-dt-orig:screen-value      = string (ord-prod.dt-orig)
               fi-dt-emissao:screen-value   = string (ord-prod.dt-emissao)
               fi-nome-abrev:screen-value   = ord-prod.nome-abrev
               fi-cod-gr-cli:screen-value   = string (ord-prod.cod-gr-cli)
               fi-nr-pedido:screen-value    = ord-prod.nr-pedido
               fi-nr-sequencia:screen-value = string(ord-prod.nr-sequencia)
               fi-nr-entrega:screen-value = string(ord-prod.nr-entrega)
               fi-lote-serie:screen-value   = ord-prod.lote-serie
               fi-prioridade:screen-value   = string (ord-prod.prioridade)
               fi-num-ord-inv:screen-value  = string (ord-prod.num-ord-inv)
               tb-emite-ordem:checked       = ord-prod.emite-ordem
               tb-emite-requis:checked      = ord-prod.emite-requis.

        &IF DEFINED(bf_man_206b) &THEN
            IF l-usa-unid-negoc THEN DO:
                ASSIGN c-unid-negocio:SCREEN-VALUE = ord-prod.cod-unid-negoc.
            END.
        &ENDIF
        
        RUN displayInfoSFC(ord-prod.rep-prod,
                           ord-prod.nr-ord-produ).
        
    end. /*if  avail ord-prod*/

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
  run get-attribute ('adm-new-record').

  IF l-new-ordem THEN do with frame {&frame-name}: 
      ASSIGN fi-dt-inicio:screen-value    = f-formato-campo ("dt-inicio":U, 5)                
             fi-dt-inicio                 = today                                             
             fi-dt-termino:screen-value   = f-formato-campo ("dt-termino":U, 5)               
             fi-dt-termino                = today                                             
             fi-dt-orig:screen-value      = f-formato-campo ("dt-orig":U, 5)                  
             fi-dt-emissao:screen-value   = f-formato-campo ("dt-emissao":U, 5)               
             fi-nome-abrev:screen-value   = f-formato-campo ("nome-abrev":U, 5)               
             fi-cod-gr-cli:screen-value   = f-formato-campo ("cod-gr-cli":U, 5)               
             fi-nr-pedido:screen-value    = f-formato-campo ("nr-pedido":U, 5)                
             fi-nr-sequencia:screen-value = f-formato-campo ("nr-sequencia":U, 5)             
             fi-lote-serie:screen-value   = f-formato-campo ("lote-serie":U, 5)               
             fi-prioridade:screen-value   = "99"                                              
             fi-num-ord-inv:screen-value  = f-formato-campo ("num-ord-inv":U, 5)              
             tb-emite-ordem:checked       = (f-formato-campo ("emite-ordem":U, 5) = "yes":U ) 
             tb-emite-requis:checked      = (f-formato-campo ("emite-requis":U, 5)= "yes":U )
             fi-dat-imc:SCREEN-VALUE      = fi-dt-inicio:SCREEN-VALUE
             fi-dat-fmt:SCREEN-VALUE      = fi-dt-termino:SCREEN-VALUE
             fi-hra-imc:SCREEN-VALUE      = "0000":U
             fi-hra-fmt:SCREEN-VALUE      = "2359":U
             c-cod-lista-compon:SCREEN-VALUE = ""
             c-cod-roteiro:SCREEN-VALUE      = ""
             .
  END.  

  /* Dispatch standard ADM method.                               */
  /* RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ). */

  /* Code placed here will execute AFTER standard behavior.    */

    &if  defined(ADM-MODIFY-FIELDS) &then
         enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif
    run get-attribute in this-procedure ('ADM-NEW-RECORD').
    do  with frame {&frame-name}:
        if  return-value = 'no' and avail ord-prod then 
            assign fi-dt-inicio:sensitive   = (ord-prod.estado = 1 or 
                                               ord-prod.estado = 3 or
                                               ord-prod.estado = 4)
                   fi-dt-orig:sensitive     = no
                   fi-num-ord-inv:sensitive = no.

        if  return-value = "yes":U and param-global.modulo-in then
            assign fi-num-ord-inv:sensitive = yes.
        ELSE
            if  l-new-ordem and param-global.modulo-in then
                assign fi-num-ord-inv:SENSITIVE = YES 
                       fi-dt-inicio:SENSITIVE   = YES. 

        &IF DEFINED (bf_man_sfc_lc) &THEN
            if  adm-new-record = no 
                and avail ord-prod  
                and ord-prod.estado = 1 
                AND NOT l-new-ordem then
            /* S¢ permite alteraá∆o da lista se a ordem n∆o estiver iniciada */
                assign c-cod-lista-compon:sensitive = yes
                       c-cod-roteiro:sensitive      = yes.
            else
                assign c-cod-lista-compon:sensitive = no
                       c-cod-roteiro:sensitive      = no.
        &ENDIF
        
    end. 

    &IF DEFINED(bf_man_206b) &THEN
    
        IF l-usa-unid-negoc THEN DO:

            IF adm-new-record = YES AND
               adm-adding-record = YES THEN 
                ASSIGN c-unid-negocio:SENSITIVE IN FRAME {&FRAME-NAME} = YES.

        END.

    &ENDIF
    IF NOT (adm-new-record) THEN
       IF ord-prod.estado < 7 AND ord-prod.dt-inicio >= TODAY 
          THEN ASSIGN fi-dt-inicio:SENSITIVE IN frame {&frame-name} = YES.

    RUN get-link-handle IN adm-broker-hdl
       (INPUT  this-procedure,
        INPUT  "group-assign-target",
        OUTPUT c-handle).       

    assign h-handle = widget-handle(c-handle).
    if valid-handle (h-handle) then
       run dispatch in h-handle ("enable-fields").

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

  &IF DEFINED(bf_man_204) &THEN
      RUN sfc/sf9999.p(OUTPUT l-mudancas-sfc).
      IF l-mudancas-sfc = NO THEN
          /*Se funcao Mudancas SFC nao implantada, rearranja os campos em tela*/
          ASSIGN tb-emite-ordem:row in frame f-main  = 5.25
                 tb-emite-requis:row in frame f-main = 6.25
                 fi-dat-imc:HIDDEN IN FRAME f-main   = YES
                 fi-dat-fmt:HIDDEN IN FRAME f-main   = YES
                 fi-hra-imc:HIDDEN IN FRAME f-main   = YES
                 fi-hra-fmt:HIDDEN IN FRAME f-main   = YES.
      ELSE DO:
          /*Mudancas SFC implantado, entao habilita os campos.*/

          ASSIGN fi-dat-imc:HIDDEN IN FRAME f-main   = NO
                 fi-dat-fmt:HIDDEN IN FRAME f-main   = NO
                 fi-hra-imc:HIDDEN IN FRAME f-main   = NO
                 fi-hra-fmt:HIDDEN IN FRAME f-main   = NO.

      END.
  &ENDIF

  /* Code placed here will execute AFTER standard behavior.    */
  find first param-global no-lock no-error.
  find first param-cp     no-lock no-error.

  do with frame {&frame-name}:     
     run pi-inicializa-campo (fi-dt-inicio:handle,    "dt-inicio":U).            
     run pi-inicializa-campo (fi-dt-termino:handle,   "dt-termino":U). 
     run pi-inicializa-campo (fi-dt-orig:handle,      "dt-orig":U). 
     run pi-inicializa-campo (fi-dt-emissao:handle,   "dt-emissao":U). 
     run pi-inicializa-campo (fi-nome-abrev:handle,   "nome-abrev":U). 
     run pi-inicializa-campo (fi-cod-gr-cli:handle,   "cod-gr-cli":U). 
     run pi-inicializa-campo (fi-nr-pedido:handle,    "nr-pedido":U). 
     run pi-inicializa-campo (fi-nr-sequencia:handle, "nr-sequencia":U). 
     run pi-inicializa-campo (fi-lote-serie:handle,   "lote-serie":U). 
     run pi-inicializa-campo (fi-prioridade:handle,   "prioridade":U). 
     run pi-inicializa-campo (fi-num-ord-inv:handle,  "num-ord-inv":U).

     assign tb-emite-ordem:label  = f-formato-campo ("emite-ordem":U, 1)
            tb-emite-requis:label = f-formato-campo ("emite-requis":U, 1).
  end.

  &IF DEFINED(bf_man_206b) &THEN
  
      IF l-usa-unid-negoc THEN DO:

          ASSIGN c-unid-negocio:HIDDEN IN FRAME {&FRAME-NAME} = FALSE.
          RUN pi-inicializa-campo (c-unid-negocio:HANDLE IN FRAME {&FRAME-NAME}, "cod-unid-negoc":U).

          RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
      END.
      ELSE DO:
          ASSIGN c-unid-negocio:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
      END.
  &ELSE
      ASSIGN c-unid-negocio:HIDDEN IN FRAME {&FRAME-NAME} = TRUE.
  &ENDIF

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apply-entry V-table-Win 
PROCEDURE pi-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter c-campo as char no-undo.          

def var c-tipo       as char init "Fill-in,Radio-set,Combo-box,Editor,Selection-List,Toggle-box,Slider":U.
def var wh-frame     as handle  no-undo.
def var wh-container as handle  no-undo.
def var i-pag-viewer as integer no-undo.
def var i-pag-atual  as integer no-undo.

RUN get-attribute ("W-Page").
assign i-pag-viewer = int(return-value).

RUN get-attribute ("W-Container-Source").
assign wh-container = widget-handle (return-value).

RUN get-attribute in wh-container ("current-page").
assign i-pag-atual = int(return-value)
       wh-frame = frame {&frame-name}:handle
       wh-frame = wh-frame:first-child
       wh-frame = wh-frame:first-child.

do while wh-frame <> ? :
   if lookup(wh-frame:Type, c-tipo) <> 0 and
      lookup(wh-frame:name, c-campo) <> 0 then do:
      run select-page in wh-container (string (i-pag-viewer)).
      apply 'entry':U to wh-frame.
   end.
   assign wh-frame = wh-frame:next-sibling.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-datas V-table-Win 
PROCEDURE pi-atualiza-datas :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
{cpp/cpapi301.i17}
DEFINE VARIABLE c-cod-estabel   AS CHARACTER  NO-UNDO.
DEFINE VARIABLE de-qt-ordem     AS DECIMAL    NO-UNDO.
DEFINE VARIABLE de-ressup-estab AS DECIMAL    NO-UNDO.

run get-field-screen-value in adm-broker-hdl (INPUT this-procedure,
                                              INPUT "fi-cod-estabel").
ASSIGN c-cod-estabel = RETURN-VALUE.

run get-field-screen-value in adm-broker-hdl (INPUT this-procedure,
                                              INPUT "fi-qt-ordem").
ASSIGN de-qt-ordem = DECIMAL(RETURN-VALUE).

IF  fi-dt-inicio:SENSITIVE IN FRAME {&frame-name} THEN DO:
    find first periodo use-index ch-termino
        where periodo.cd-tipo     = param-cp.cd-tipo
        and periodo.dt-termino >= input frame {&frame-name} fi-dt-inicio no-lock no-error.

 if avail periodo and ( l-descon-per = NO  or (adm-new-record OR l-new-ordem)) then  
        assign fi-dt-inicio:screen-value in frame {&frame-name} = string(periodo.dt-inicio).     
END.

run get-field-screen-value in adm-broker-hdl (INPUT this-procedure,
                                              INPUT "fi-it-codigo").
find item 
    where item.it-codigo = return-value no-lock no-error.
run pi-verifica-tipo-con-est.
if  adm-new-record 
or (not adm-new-record 
    and avail item   
    and avail ord-prod and ord-prod.it-codigo <> 
                           item.it-codigo) then do:
    FIND item-uni-estab WHERE item-uni-estab.it-codigo   = item.it-codigo
                          AND item-uni-estab.cod-estabel = c-cod-estabel NO-LOCK NO-ERROR.
    IF AVAIL item-uni-estab THEN
        ASSIGN  i-ressup-fabri  = INT (f-item-uni-estab (input item.it-codigo,
                                                         INPUT c-cod-estabel,
                                                         "ressup-fabri":U ))
                de-qt-min       = item-uni-estab.qt-min-res-fabr
                de-qt-dlt       = item-uni-estab.var-qtd-res-fabr
                i-dias-dlt      = item-uni-estab.var-tempo-res-fabr
                de-ressup-estab = item-uni-estab.ressup-fabri.
    
    IF de-qt-ordem >= de-qt-min THEN DO:
            assign de-qt-ordem = de-qt-ordem - de-qt-min
                   /*de-vezes = IF AVAIL item-uni-estab THEN
                                de-ressup-estab
                              ELSE
                                ITEM.ressup-fabri    */                  /* A adiá∆o da vari†vel de-ressup-estab a este ponto do calculo */
                   de-vezes = /*de-vezes + */ (de-qt-ordem / de-qt-dlt).    /* estava resultando no ressuprimento errado */
            
            ASSIGN de-vezes = (if de-vezes = ? then
                                  0
                               else
                                  de-vezes).
                                  
            IF de-qt-dlt > 0 AND i-dias-dlt > 0 THEN 
                ASSIGN de-vezes = (if trunc(de-vezes,0) = de-vezes then
                                       de-vezes
                                   else
                                       trunc(de-vezes,0) + 1).
            
            ASSIGN i-ressup-fabri = i-ressup-fabri + (de-vezes * i-dias-dlt).

            assign i-ressup-fabri = i-ressup-fabri - i-nr-dias
                   i-resto        = if i-ressup-fabri > 0
                                   then i-ressup-fabri modulo i-tam-per
                                   else 0
                   i-ressup-fabri = if i-resto <> 0
                                    then truncate (i-ressup-fabri / i-tam-per, 0) /*+ 1 */
                                    else i-ressup-fabri / i-tam-per. 
    END.

   do i-contador = 1 to i-ressup-fabri :
      find next periodo use-index codigo
           where periodo.cd-tipo = param-cp.cd-tipo
           no-lock no-error.
   end.

   if not avail periodo then
      find last  periodo use-index codigo
           where periodo.cd-tipo = param-cp.cd-tipo no-lock no-error.

   assign da-data-aux = if  avail periodo
                        then periodo.dt-termino
                        else today.
   
   ASSIGN fi-dt-termino:screen-value = string(da-data-aux)
          fi-dt-orig:screen-value    = string(da-data-aux).

    if fi-dt-termino:SENSITIVE IN FRAME {&frame-name} THEN DO:
        find first periodo use-index ch-termino
            where periodo.cd-tipo     = param-cp.cd-tipo and
                  periodo.dt-termino >= input frame {&frame-name} fi-dt-termino no-lock no-error.

        if  avail periodo and l-descon-per = NO then do:
            if periodo.dt-inicio <> input fi-dt-termino then do:
                assign fi-dt-termino:screen-value = string (periodo.dt-termino)
                       fi-dt-orig:screen-value    = string (periodo.dt-termino).
            end.
        end.
    end.
end.

RUN atualizaDatasSFC.

if input fi-nome-abrev <> "" then
   run notify ('pi-mostra-narrativa,group-assign-target').

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-unid-negoc V-table-Win 
PROCEDURE pi-atualiza-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-cod-estabel   AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-it-codigo     AS CHARACTER    NO-UNDO.
    DEFINE VARIABLE c-cod-depos     AS CHARACTER    NO-UNDO.

    &IF DEFINED(bf_man_206b) &THEN
    
        run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "fi-it-codigo").
        ASSIGN c-it-codigo = RETURN-VALUE.
        run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "fi-cod-estabel").
        ASSIGN c-cod-estabel = RETURN-VALUE.
        run get-field-screen-value in adm-broker-hdl (INPUT this-procedure, INPUT "fi-cod-depos").
        ASSIGN c-cod-depos = RETURN-VALUE.
    
        FIND ITEM WHERE ITEM.it-codigo = c-it-codigo NO-LOCK NO-ERROR.
        IF AVAIL ITEM THEN DO:
            
            RUN retornaUnidadeNegocio IN h-cdapi024 (INPUT c-cod-estabel,
                                                         INPUT c-it-codigo,
                                                         INPUT c-cod-depos,
                                                         OUTPUT c-unid-negocio).
            
             ASSIGN c-unid-negocio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = c-unid-negocio.
             
             if item.tipo-contr = 1 or
                item.tipo-contr = 3 or
                item.tipo-contr = 4 then do:
                    
                assign c-unid-negocio:SENSITIVE    IN FRAME {&FRAME-NAME} = TRUE.
             end.
             else do:
                assign c-unid-negocio:SENSITIVE    IN FRAME {&FRAME-NAME} = FALSE.
             end. 
             RUN pi-confere-unid-negoc.
        END.

    &ENDIF


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-confere-unid-negoc V-table-Win 
PROCEDURE pi-confere-unid-negoc :
/*------------------------------------------------------------------------------
  Purpose: Conferir se a Unidade de Neg¢cio no pedido Ç a mesma da padr∆o
  cadastrada no Item, se n∆o for, substitui pela do Pedido
  Parameters:  <none>
  Notes: Esta pi deve ser executada no LEAVE dos campos: fi-nome-abrev, fi-nr-pedido
  fi-nr-sequencia
------------------------------------------------------------------------------*/
DEF VAR c-nome-abrev AS CHAR FORMAT "x(12)" NO-UNDO.
DEF VAR c-nr-pedido AS CHAR FORMAT "x(12)" NO-UNDO.
DEF VAR i-nr-seq AS INT FORMAT "->,>>>,>>9" NO-UNDO.

DEF VAR c-it-codigo AS CHAR FORMAT "x(16)" NO-UNDO.
DEF VAR c-cod-refer AS CHAR FORMAT "x(8)" NO-UNDO.

    &IF DEFINED (bf_man_206b) &THEN
    
        IF (CAN-FIND(funcao WHERE funcao.cd-funcao = "EMS2-UNIDADE-NEGOCIO" AND funcao.ativo )) THEN DO:

            FIND FIRST ped-venda
                WHERE ped-venda.nr-pedcli = fi-nr-pedido:SCREEN-VALUE IN FRAME {&FRAME-NAME} 
                AND ped-venda.nome-abrev = fi-nome-abrev:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.

            IF AVAIL ped-venda THEN DO:
                
                FIND FIRST unid-negoc WHERE unid-negoc.cod-unid-negoc = ped-venda.cod-unid-negoc NO-LOCK NO-ERROR.

                IF AVAIL unid-negoc THEN DO:
                    ASSIGN c-unid-negocio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = unid-negoc.cod-unid-negoc
                        c-unid-negocio:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
                END.
                ELSE DO:
                    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "fi-it-codigo").
                    ASSIGN c-it-codigo = RETURN-VALUE.
        
                    RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "fi-cod-refer").
                    ASSIGN c-cod-refer = RETURN-VALUE.
        
                    ASSIGN c-nome-abrev = fi-nome-abrev:SCREEN-VALUE IN FRAME {&frame-name}
                        c-nr-pedido = fi-nr-pedido:SCREEN-VALUE IN FRAME {&frame-name}
                        i-nr-seq = INPUT FRAME {&frame-name} fi-nr-sequencia.
        
                    FIND FIRST ped-item
                        WHERE ped-item.nome-abrev = c-nome-abrev
                        AND ped-item.nr-pedcli = c-nr-pedido
                        AND ped-item.nr-sequencia = i-nr-seq
                        AND ped-item.it-codigo = c-it-codigo
                        AND ped-item.cod-refer = c-cod-refer
                        NO-LOCK NO-ERROR.
    
                    IF AVAIL ped-item THEN DO:
                        
                        FIND FIRST unid-negoc WHERE unid-negoc.cod-unid-negoc = ped-item.cod-unid-negoc NO-LOCK NO-ERROR. 
    
                        IF AVAIL unid-negoc THEN DO:
                            ASSIGN c-unid-negocio:SCREEN-VALUE IN FRAME {&FRAME-NAME} = unid-negoc.cod-unid-negoc
                                c-unid-negocio:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
                        END.
                    END.
                    ELSE DO:
    
                        ASSIGN c-unid-negocio:SENSITIVE IN FRAME {&FRAME-NAME} = YES.
    
                    END.
                END.
            END.
        END.
    &ENDIF
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

if c-campo = "prioridade" then
    assign wh-handle:format = "99".
else do:
    run utp/ut-field.p (input "mgind", 
                        input "ord-prod", 
                        input c-campo, 
                        input "4"). /* Formato */
    assign wh-handle:format = return-value.
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

if l-descon-per = YES then do:

    if fi-dt-inicio:SENSITIVE IN FRAME {&frame-name} then do:
        find first periodo 
             where periodo.cd-tipo   = param-cp.cd-tipo 
             and periodo.dt-inicio  = input frame {&frame-name} fi-dt-inicio no-lock no-error.

        if avail periodo then
            assign fi-dt-inicio:screen-value in frame {&frame-name} = string(periodo.dt-inicio).
        else do:   

            {utp/ut-liter.i Data_In°cio_ *}	  
            ASSIGN c-lbl-msg1 = TRIM(RETURN-VALUE).

            run utp/ut-msgs.p(input "show",
                              input 57846,
                              input c-lbl-msg1 + '~~' + frame {&frame-name} fi-dt-inicio  + '~~' +
                              string(param-cp.cd-tipo)).	

            if return-value = "no" then do:

                find first periodo use-index ch-termino
                    where periodo.cd-tipo   = param-cp.cd-tipo 
                    and periodo.dt-termino  >= input frame {&frame-name} fi-dt-inicio no-lock no-error.

                if avail periodo then 
                    assign fi-dt-inicio:screen-value in frame {&frame-name} = string(periodo.dt-inicio).	  
            end.  
        end.	
    end. 

    if fi-dt-termino:SENSITIVE IN FRAME {&frame-name} then do:
        find first periodo use-index ch-termino
            where periodo.cd-tipo   = param-cp.cd-tipo 
            and periodo.dt-termino  = input frame {&frame-name} fi-dt-termino no-lock no-error.

        if avail periodo then
            assign fi-dt-termino:screen-value in frame {&frame-name} = string(periodo.dt-termino).
        else do:   

            {utp/ut-liter.i Data_TÇrmino_ *}	  
            ASSIGN c-lbl-msg1 = TRIM(RETURN-VALUE).

            run utp/ut-msgs.p(input "show",
                              input 57846,
                              input c-lbl-msg1 + '~~' + frame {&frame-name} fi-dt-termino + '~~' +
                              string(param-cp.cd-tipo)).					  

            if return-value = "no" then do:
    
                find first periodo use-index ch-termino
                    where periodo.cd-tipo   = param-cp.cd-tipo 
                    and periodo.dt-termino  >= input frame {&frame-name} fi-dt-termino no-lock no-error.

                if avail periodo then 
                    assign fi-dt-termino:screen-value in frame {&frame-name} = string(periodo.dt-termino).	
            end.  
        end.	
    end.
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-tipo-con-est V-table-Win 
PROCEDURE pi-verifica-tipo-con-est :
/*------------------------------------------------------------------------------
  Purpose: Habilitar ou desabilitar o campo lote/sÇrie    
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  if  avail(item) then do:
      if  item.tipo-con-est = 2
      or  item.tipo-con-est = 3
      or  item.tipo-con-est = 4 then
          assign fi-lote-serie:sensitive    in frame {&frame-name} = yes.
      else 
          assign fi-lote-serie:screen-value in frame {&frame-name} = "" 
                 fi-lote-serie:sensitive    in frame {&frame-name} = no.   
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
  {src/adm/template/snd-list.i "ord-prod"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaHandlePai V-table-Win 
PROCEDURE setaHandlePai :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-handle-pai AS HANDLE NO-UNDO.

ASSIGN h-handle-pai = p-handle-pai.

RETURN "OK":U.
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

