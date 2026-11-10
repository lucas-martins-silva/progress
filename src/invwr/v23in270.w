&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          movmnt           PROGRESS
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
{include/i-prgvrs.i V23IN270 2.00.01.055 } /*** "010155" 25/09/2026 16:07:34 ***/


{cdp/cdcfgmnt.i}
{cdp/cdcfgman.i}
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

{utp/ut-glob.i}
{btb/btb008za.i0}


/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-ord-manut for ord-manut.
def var c-label-1   as char.
def var c-label-2   as char.
def var de-cont-ant as dec format ">>>,>>>,>>>,>>9" init 0.
def var de-tot-util as dec format ">>>,>>>,>>>,>>9" init 0.
def var l-ok        as   log init no.

def new global shared var gr-causa        as rowid no-undo.
def new global shared var gr-sintoma      as rowid no-undo.
def new global shared var gr-intervencao  as rowid no-undo.
def new global shared var gr-ord-manut    as rowid no-undo.
def var h-handle as handle no-undo.
def var h-query  as handle no-undo.
def var c-handle as char   no-undo.

def var da-data-ini       as date  no-undo.
def var da-data-fim       as date  no-undo.
def var c-cod-estabel-ini as char  no-undo.
def var c-cod-estabel-fim as char  no-undo.
def var l-aceite          as log   no-undo.
def var l-antecipa        as log   no-undo.
def var l-oc-pend         as log   no-undo.
DEF VAR l-req-pend        AS LOG   NO-UNDO.
def var l-tarefa          as log   no-undo.
def var l-movimenta       as log   no-undo.
def var rw-ord-manut      as rowid no-undo.
def var da-dt-fecham      like ord-manut.dt-fecham no-undo.
def var h-reserva         as handle  no-undo.

/******************************************************************************************************************
  Story: MANCORE1-2235 - Geraá∆o autom†tica de Roteiros de Inspeá∆o/Lubrificaá∆o
  ------------------------------------------------------------------------------
  - A variavel "l-imp-roteiro" Ç utilizada na mi0309.i3, ela Ç utilizada para realizar a impress∆o do resultado da
    geraá∆o autom†tica do roteiro.
  - Essa vari†vel Ç solicitada na funcionalidade "mi1024h.w", que por sua vez Ç executada nas funcionalidade:
        * MI1024 - Apontamento Ordem Lubrificaá∆o;
        * MI1029 - Apontamento Roteiros Inspeá∆o.
*******************************************************************************************************************/
DEF VAR l-imp-roteiro     AS LOGICAL INITIAL NO NO-UNDO.

{include/i_fncrowid.i} /* Pre-processador da substituicao do RECID pelo ROWID */

&IF {&ROWID_READY} = YES &THEN
   def new global shared var v_rec_docto_anexo as ROWID no-undo.
&ELSE
   def new global shared var v_rec_docto_anexo as recid no-undo.
&ENDIF

   def var hDBOOrdProd     as handle no-undo.   
   def var hDBOOrdemCompra as handle no-undo.
   def var hDBOParamEstoq  as handle no-undo.
   def var l-encontrado    as logical .
   def var c-servidor      as char .
   def var c-erro          as char.
   def var h-bomn161       as handle.


def var h-reservas         as handle no-undo.
def var h-agenda-tec       as handle no-undo.

{cdp/cd9982.i}

/*PREDITIVA*/
DEFINE VARIABLE l-log-modul-preditiva    AS LOGICAL  INIT NO  NO-UNDO.
DEFINE VARIABLE l-ems204              AS LOGICAL  INIT NO  NO-UNDO.
DEF NEW GLOBAL SHARED VAR gr-ord-manut AS ROWID NO-UNDO.
DEFINE VARIABLE hDBOMipParamPredit AS HANDLE     NO-UNDO.
DEFINE VARIABLE l-acoes-ativas AS LOGICAL INITIAL NO NO-UNDO.

{mnbo/bomn150.i1} /*TT envio email, parametros email MI0101*/
{mnbo/bomn150.i2} /*pi-envia-email, pi-email-encerrar*/		

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
&Scoped-define EXTERNAL-TABLES ord-manut
&Scoped-define FIRST-EXTERNAL-TABLE ord-manut


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-manut.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS ord-manut.cd-causa-padr ~
ord-manut.cd-sint-padr ord-manut.cd-interv-padr 
&Scoped-define ENABLED-TABLES ord-manut
&Scoped-define FIRST-ENABLED-TABLE ord-manut
&Scoped-Define ENABLED-OBJECTS RECT-3 rt-mold bt-docto 
&Scoped-Define DISPLAYED-FIELDS ord-manut.cd-causa-padr ~
ord-manut.cd-sint-padr ord-manut.cd-interv-padr 
&Scoped-define DISPLAYED-TABLES ord-manut
&Scoped-define FIRST-DISPLAYED-TABLE ord-manut
&Scoped-Define DISPLAYED-OBJECTS c-descr-causa c-descr-sint c-descr-interv ~
c-nome c-descr-tecnico c-cod-docto-anexo de-tot-cont de-contador da-movto ~
de-utilizacao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS ord-manut.cd-causa-padr ~
ord-manut.cd-sint-padr ord-manut.cd-interv-padr 
&Scoped-define List-4 c-nome de-tot-cont de-contador da-movto de-utilizacao 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS>
al-codigo||y|movind.ord-manut.al-codigo
cd-causa-padr||y|movind.ord-manut.cd-causa-padr
cd-equipto||y|movind.ord-manut.cd-equipto
nr-ord-produ||y|movind.ord-manut.nr-ord-produ
cd-inspecao||y|movind.ord-manut.cd-inspecao
cd-interv-padr||y|movind.ord-manut.cd-interv-padr
cd-manut||y|movind.ord-manut.cd-manut
sequencia||y|movind.ord-manut.sequencia
cd-parada||y|movind.ord-manut.cd-parada
cd-tag||y|movind.ord-manut.cd-tag
cd-pend-padr||y|movind.ord-manut.cd-pend-padr
cd-planejado||y|movind.ord-manut.cd-planejado
cd-projeto||y|movind.ord-manut.cd-projeto
nr-rot-insp||y|movind.ord-manut.nr-rot-insp
nr-rot-lubr||y|movind.ord-manut.nr-rot-lubr
cd-sint-padr||y|movind.ord-manut.cd-sint-padr
cd-tipo||y|movind.ord-manut.cd-tipo
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = "al-codigo,cd-causa-padr,cd-equipto,nr-ord-produ,cd-inspecao,cd-interv-padr,cd-manut,sequencia,cd-parada,cd-tag,cd-pend-padr,cd-planejado,cd-projeto,nr-rot-insp,nr-rot-lubr,cd-sint-padr,cd-tipo"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-docto 
     IMAGE-UP FILE "Image\im-show":U
     IMAGE-INSENSITIVE FILE "image\ii-show":U
     LABEL "" 
     SIZE 4 BY .88.

DEFINE VARIABLE c-cod-docto-anexo AS CHARACTER FORMAT "X(30)" 
     LABEL "Documento Anexo" 
     VIEW-AS FILL-IN 
     SIZE 31.14 BY .88.

DEFINE VARIABLE c-descr-causa AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 54.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-interv AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 54.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-sint AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 54.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-tecnico AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome AS CHARACTER FORMAT "99999-9":U INITIAL "000000" 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE da-movto AS DATE FORMAT "99/99/9999":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE de-contador AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-tot-cont AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE VARIABLE de-utilizacao AS DECIMAL FORMAT "->>>,>>>,>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 19 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.57 BY 3.42.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.43 BY 5.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-manut.cd-causa-padr AT ROW 1.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-causa AT ROW 1.25 COL 29.72 COLON-ALIGNED NO-LABEL
     ord-manut.cd-sint-padr AT ROW 2.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-sint AT ROW 2.25 COL 29.72 COLON-ALIGNED NO-LABEL
     ord-manut.cd-interv-padr AT ROW 3.25 COL 17 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-interv AT ROW 3.29 COL 29.72 COLON-ALIGNED NO-LABEL
     c-nome AT ROW 4.25 COL 17 COLON-ALIGNED
     c-descr-tecnico AT ROW 4.25 COL 31.29 COLON-ALIGNED NO-LABEL
     c-cod-docto-anexo AT ROW 5.25 COL 17 COLON-ALIGNED HELP
          "C¢digo do Documento em Anexo"
     bt-docto AT ROW 5.25 COL 50.57
     de-tot-cont AT ROW 6.58 COL 29.43 COLON-ALIGNED
     de-contador AT ROW 7.58 COL 29.43 COLON-ALIGNED
     da-movto AT ROW 8.58 COL 29.43 COLON-ALIGNED
     de-utilizacao AT ROW 8.58 COL 56.43 COLON-ALIGNED
     RECT-3 AT ROW 6.25 COL 1
     rt-mold AT ROW 1.13 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movmnt.ord-manut
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
         HEIGHT             = 8.67
         WIDTH              = 85.57.
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

ASSIGN 
       bt-docto:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-cod-docto-anexo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       c-cod-docto-anexo:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN c-descr-causa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-interv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-sint IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-tecnico IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN ord-manut.cd-causa-padr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ord-manut.cd-interv-padr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ord-manut.cd-sint-padr IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN da-movto IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN de-contador IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN de-tot-cont IN FRAME f-main
   NO-ENABLE 4                                                          */
/* SETTINGS FOR FILL-IN de-utilizacao IN FRAME f-main
   NO-ENABLE 4                                                          */
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

&Scoped-define SELF-NAME bt-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-docto V-table-Win
ON CHOOSE OF bt-docto IN FRAME f-main
DO:


  if input frame {&frame-name} c-cod-docto-anexo <> "" then do:


     find docto_anexo where docto_anexo.cod_docto_anexo = input frame {&frame-name} 
          c-cod-docto-anexo no-lock no-error.
     if avail docto_anexo then do:
        IF AVAILABLE param-mi AND param-mi.cod-catal-docto-anexo <> "" THEN DO:
            IF docto_anexo.cod_catal_docto_anexo <> param-mi.cod-catal-docto-anexo THEN DO:
                run utp/ut-msgs.p (input 'show':U,
                                   input 7596,
                                   input string (param-mi.cod-catal-docto-anexo)).
                return no-apply.
            END.
        END.    
        ELSE DO:
           IF docto_anexo.cod_catal_docto_anexo <> param-global.cod-catal-docto-anexo then do: 
               run utp/ut-msgs.p (input 'show':U,
                                  input 7596,
                                  input string (param-global.cod-catal-docto-anexo)).
               return no-apply.

           END.
        END.
     end.
     else do:
          {utp/ut-table.i mguni docto_anexo 1}
          run utp/ut-msgs.p (input 'show':U,
                             input 558,
                             input return-value).
          return no-apply.
     end.
     find catal_docto_anexo
          where catal_docto_anexo.cod_catal_docto_anexo = docto_anexo.cod_catal_docto_anexo 
          no-lock no-error.                              
     if avail catal_docto_anexo then do:
        run btb/btb915za.p(input search(trim(catal_docto_anexo.cod_path_catal) + "/":U +
            trim(docto_anexo.nom_arq_ext_docto_anexo))).
     end.       
  end.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-cod-docto-anexo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-docto-anexo V-table-Win
ON F5 OF c-cod-docto-anexo IN FRAME f-main /* Documento Anexo */
DO:
  
    IF AVAILABLE param-mi AND
       param-mi.cod-catal-docto-anexo <> "" THEN DO:
         run btb/btb002ka.p (input param-mi.cod-catal-docto-anexo).
    END.
    ELSE DO:
        if avail param-global then 
         run btb/btb002ka.p (input param-global.cod-catal-docto-anexo).
    END.
    &IF {&ROWID_READY} = YES &THEN
        find docto_anexo where ROWID(docto_anexo) = v_rec_docto_anexo 
             no-lock no-error.
    &ELSE
        find docto_anexo where recid(docto_anexo) = v_rec_docto_anexo 
             no-lock no-error.
    &ENDIF
          assign c-cod-docto-anexo:screen-value = if avail docto_anexo then
          string(docto_anexo.cod_docto_anexo) else "":U.   
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-docto-anexo V-table-Win
ON LEAVE OF c-cod-docto-anexo IN FRAME f-main /* Documento Anexo */
DO:
  if input frame {&FRAME-NAME} c-cod-docto-anexo = "" then
     assign bt-docto:sensitive in frame {&FRAME-NAME} = no.
  else
     assign bt-docto:sensitive in frame {&FRAME-NAME} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cod-docto-anexo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cod-docto-anexo IN FRAME f-main /* Documento Anexo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-descr-causa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-descr-causa V-table-Win
ON LEAVE OF c-descr-causa IN FRAME f-main
DO:

  assign de-utilizacao = input frame {&frame-name} de-utilizacao.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME c-nome
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome V-table-Win
ON F5 OF c-nome IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="inzoom/z01in428.w"
                     &campo=c-nome
                     &campozoom=cd-tecnico} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome V-table-Win
ON LEAVE OF c-nome IN FRAME f-main
DO:
  {include/leave.i &tabela=tecn-mi
                   &atributo-ref=nome-compl
                   &variavel-ref=c-descr-tecnico
                   &where="tecn-mi.cd-tecnico = input frame {&frame-name} c-nome"}

  {cdp/cd9998.i}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-nome V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-nome IN FRAME f-main
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.cd-causa-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-causa-padr V-table-Win
ON F5 OF ord-manut.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in040.w"
                  &tabela=ord-manut
                  &atributo=cd-causa-padr} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-causa-padr V-table-Win
ON LEAVE OF ord-manut.cd-causa-padr IN FRAME f-main /* Causa */
DO:
      {include/leave.i &tabela=causa-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-causa
                   &where="causa-padrao.cd-causa-padr = input frame {&frame-name} ord-manut.cd-causa-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-causa-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-manut.cd-causa-padr IN FRAME f-main /* Causa */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.cd-interv-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-interv-padr V-table-Win
ON F5 OF ord-manut.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in153.w"
                  &tabela=ord-manut
                  &atributo=cd-interv-padr} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-interv-padr V-table-Win
ON LEAVE OF ord-manut.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
   {include/leave.i &tabela=interv-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-interv
                   &where="interv-padrao.cd-interv-padr = input frame {&frame-name} ord-manut.cd-interv-padr"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-interv-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-manut.cd-interv-padr IN FRAME f-main /* Intervená∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-manut.cd-sint-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-sint-padr V-table-Win
ON F5 OF ord-manut.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in408.w"
                  &tabela=ord-manut
                  &atributo=cd-sint-padr} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-sint-padr V-table-Win
ON LEAVE OF ord-manut.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   {include/leave.i &tabela=sint-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-sint
                   &where="sint-padrao.cd-sint-padr = input frame {&frame-name} ord-manut.cd-sint-padr"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-manut.cd-sint-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF ord-manut.cd-sint-padr IN FRAME f-main /* Sintoma Padr∆o */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

find first param-global
    no-lock no-error.

FIND FIRST param-mi
    NO-LOCK NO-ERROR.


{utp/ut-liter.i Matr_TÇcnico * r}
assign c-nome:label in frame {&frame-name} = trim(return-value).  
{utp/ut-liter.i Ult_Valor_Contador  * r}
assign de-tot-cont:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Valor_Contador * r}
assign de-contador:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Data * r}
assign da-movto:label in frame {&frame-name} = trim(return-value).
{utp/ut-liter.i Utilizaá∆o * r}
assign de-utilizacao:label in frame {&frame-name} = trim(return-value).


{utp/ut-field.i mgind ord-manut cod-docto-anexo 1}
assign c-cod-docto-anexo:label in frame {&FRAME-NAME} = trim(return-value).

  /************************ INTERNAL PROCEDURES ********************/

if  ord-manut.cd-causa-padr:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
if  ord-manut.cd-sint-padr:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
if  ord-manut.cd-interv-padr:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
if  c-nome:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

 /************************ MODULO PREDITIVA ********************/
 
 ASSIGN l-ems204 = YES.
 

 IF l-ems204 THEN DO:
 /*cosulta em parametros globais se o modulo MI PREDITIVA esta disponivel*/
    FIND FIRST param-global NO-LOCK NO-ERROR.
        IF AVAIL param-global THEN DO:
            &IF DEFINED (bf_mnt_ems206b) &THEN
                ASSIGN l-log-modul-preditiva = param-global.log-modul-predit.
            &else
                assign l-log-modul-preditiva = if substring(param-global.char-2,25,1) = "y":U then yes else no.
            &ENDIF         
        END.
 END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "ord-manut"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-manut"}

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
def var c-label1 as char no-undo.
def var c-label2 as char no-undo.
DEFINE VARIABLE C-TECNICO-AUX AS CHARACTER  NO-UNDO.

    /* Code placed here will execute PRIOR to standard behavior. */
    {include/i-valid.i}

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */   

find first param-mi no-lock no-error.

    assign da-data-ini = today - 15
           da-data-fim = today + 15.
    run mip/mi0309b.w (input-output da-data-ini,
                       input-output da-data-fim,
                       input-output c-cod-estabel-ini,
                       input-output c-cod-estabel-fim,
                       input-output l-aceite,
                       input-output l-antecipa,
                       input-output l-oc-pend,
                       INPUT-OUTPUT l-req-pend,
                       input-output l-tarefa,
                       input-output l-movimenta,
                       output       l-ok).

    if l-ok = no then
       return 'ADM-ERROR'.

    run pi-verifica-ordem. 

    if  return-value = "nok" then
        return 'ADM-ERROR'.

    ASSIGN C-TECNICO-AUX = input frame {&frame-name} c-nome.
    &if defined (bf_mnt_ems203) &then
       assign input frame {&FRAME-NAME} c-cod-docto-anexo.
    &endif  
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ).
    if RETURN-VALUE = 'ADM-ERROR':U then 
       RETURN 'ADM-ERROR':U.
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */

    assign da-movto = input frame {&frame-name} da-movto 
           ord-manut.cod-docto-anexo = c-cod-docto-anexo 
           c-nome = C-TECNICO-AUX.

    if  (ord-manut.cd-manut <> "" and (avail manut and (manut.controle = 2 OR manut.controle = 3))) 
    and  c-nome <> "000000"
    AND (avail grup-maquina and not grup-maquina.ind-utiliz) then do:
        if  equipto.tp-apont = 1 then 
            assign de-tot-util = input frame {&frame-name} de-contador - de-cont-ant.
        else do:
            if  equipto.tp-contador <> "Ne" then 
                assign de-tot-util = input frame {&frame-name} de-utilizacao * equipto.fator-conversao.
            if  de-tot-util - truncate(de-tot-util,0) > 0 then
                assign de-tot-util = truncate(de-tot-util,0) + 1.
            else
                assign de-tot-util = truncate(de-tot-util,0)
                       de-contador:screen-value in frame {&frame-name} =
                        string(input frame {&frame-name} de-contador + de-tot-util).
        end.

        if  de-tot-util > 0 then do:
            for each tt-utiliza exclusive:
                delete tt-utiliza.
            end. 
            assign l-prod-mi = no.
            
            if param-mi.prop-utiliz then do:

               run mip/mi1007b.p (input-output table tt-utiliza,
                                  input da-movto,
                                  input equipto.cd-equipto,
                                  input de-tot-util,
                                  input C-NOME,
                                  input 1,
                                  input l-prod-mi).
                run mip/mi1007c.w (input-output table tt-utiliza,
                                   input 1,
                                   input h-bomn161,
                                   output l-ok).

            end.                       
            for each tt-utiliza exclusive:
                delete tt-utiliza.
            end. 
        end.    

        find last ut-equipto where 
                  ut-equipto.cd-equipto = ord-manut.cd-equipto and 
                  ut-equipto.data <= ord-manut.dt-fecham no-lock no-error.
        IF  de-contador:sensitive in frame {&frame-name}  THEN DO:
            assign ord-manut.vl-contador = if avail ut-equipto 
                                           then ut-equipto.contador 
                                           else input frame {&frame-name} de-contador
                   ord-manut.vl-cont-acum = if avail ut-equipto then (input frame {&frame-name} de-contador - 
                                                                      input frame {&frame-name} de-tot-cont + 
                                                                      ut-equipto.vl-contador )  
                                            else (input frame {&frame-name} de-contador + 
                                                  input frame {&frame-name} de-contador - 
                                                  input frame {&frame-name} de-tot-cont ) . 
            &if defined (bf_mnt_ems203) &then
            if NOT param-mi.prop-utiliz then
            &else
            if  param-mi.log-1 = NO then
            &endif
                ASSIGN ord-manut.vl-contador  = input frame {&frame-name} de-contador.
        END.
        else
            assign ord-manut.vl-contador = if avail ut-equipto 
                                           then ut-equipto.contador 
                                           else input frame {&frame-name} de-tot-cont
                                              + input frame {&frame-name} de-utilizacao
                   ord-manut.vl-cont-acum = input frame {&frame-name} de-tot-cont
                                          + input frame {&frame-name} de-utilizacao.
    end. 
    ELSE DO:
        IF  (ord-manut.cd-manut <> "" AND (AVAIL manut AND (manut.controle = 2 OR manut.controle = 3))) 
            AND  c-nome <> "000000"
            AND (AVAIL grup-maquina and grup-maquina.ind-utiliz) THEN DO:

            FIND LAST ut-equipto WHERE
                      ut-equipto.cd-equipto = ord-manut.cd-equipto AND
                      ut-equipto.data <= ord-manut.dt-fecham NO-LOCK NO-ERROR.
            IF  AVAIL ut-equipto THEN DO:
                assign ord-manut.vl-contador = if avail ut-equipto 
                                               then ut-equipto.contador +  input frame {&frame-name} de-utilizacao
                                               else input frame {&frame-name} de-utilizacao
                       ord-manut.vl-cont-acum = IF AVAIL ut-equipto THEN ut-equipto.vl-contador + input frame {&frame-name} de-utilizacao
                                                ELSE input frame {&frame-name} de-utilizacao.
            END.
        END.
    END.
    IF  ord-manut.cd-manut = "" THEN DO:
        IF  de-contador:sensitive in frame {&frame-name}  THEN DO:
            assign ord-manut.vl-contador = input frame {&frame-name} de-contador
                   ord-manut.vl-cont-acum = IF AVAIL ut-equipto THEN 
                                                (input frame {&frame-name} de-contador - ut-equipto.contador) + ut-equipto.vl-contador
                                            ELSE input frame {&frame-name} de-contador.  
            &if defined (bf_mnt_ems203) &then
            if not param-mi.prop-utiliz then
            &else
            if  param-mi.log-1 = NO then
            &endif
                ASSIGN ord-manut.vl-contador = input frame {&frame-name} de-contador.
        END.
        ELSE DO:
            assign ord-manut.vl-contador = if avail ut-equipto 
                                           then ut-equipto.contador +  input frame {&frame-name} de-utilizacao
                                           else input frame {&frame-name} de-utilizacao
                   ord-manut.vl-cont-acum = IF AVAIL ut-equipto THEN ut-equipto.vl-contador + input frame {&frame-name} de-utilizacao
                                            ELSE input frame {&frame-name} de-utilizacao.
        END.
    END.

    IF  AVAIL tecn-mi THEN DO:
        ASSIGN ord-manut.cd-tecnico = tecn-mi.cd-tecnico.    
    END.

    {mip/mi0309.i4}  
    {mip/mi0309.i3} /* Fechamento da Ordem */

    find tipo-manut where 
         tipo-manut.cd-tipo = ord-manut.cd-tipo no-lock no-error.
    if  avail tipo-manut and tipo-manut.forma-ajuste = 1 then do:

        for each reservas where 
                 reservas.nr-ord-produ =  ord-manut.nr-ord-produ and
                 reservas.quant-atend  <> reservas.quant-aplic EXCLUSIVE-LOCK:
            assign reservas.quant-aplic = reservas.quant-atend.                       
        end.
        
    end.

    ASSIGN c-cod-estabel-ini       = ord-manut.cod-estabel
           c-cod-estabel-fim       = ord-manut.cod-estabel.
    {utp/ut-field.i mgind equipto cd-equipto 1}
    assign c-label1 = trim(return-value).
    {utp/ut-field.i mgind ord-manut nr-ord-produ 1}
    assign c-label2 = trim(return-value).
    run utp/ut-msgs.p(input "show",
                      input 15958,
                      input c-label1 + "~~" +
                            c-label2).

    if  return-value = "yes" then
        run mip/mi0309a.w (input da-data-ini,
                           input da-data-fim,
                           input c-cod-estabel-ini,
                           input c-cod-estabel-fim,
                           input l-aceite,
                           input l-antecipa,
                           input l-oc-pend,
                           INPUT l-req-pend,
                           input l-tarefa,
                           input rw-ord-manut).

    find first ord-manut where rowid(ord-manut) = gr-ord-manut NO-LOCK NO-ERROR.
    if  avail ord-manut then
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ).
    /* Code placed here will execute AFTER standard behavior.    */

    
     assign c-cod-docto-anexo:screen-value in frame {&FRAME-NAME} = "".

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

  if valid-handle(h-agenda-tec) then
    run destroy in h-agenda-tec.

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

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
       disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.

      &if defined (bf_mnt_ems203) &then
         disable c-cod-docto-anexo with frame {&FRAME-NAME}.
      &endif.
  &endif 

  disable {&List-4} with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:
------------------------------------------------------------------------------*/
    assign rw-ord-manut = gr-ord-manut.

    /* Code placed here will execute PRIOR to standard behavior. */
    if  available ord-manut then do:
         find causa-padrao
            where causa-padrao.cd-causa-padr = ord-manut.cd-causa-padr
            no-lock no-error.
        assign c-descr-causa = if avail causa-padrao then causa-padrao.descricao else "":U
               gr-causa      = if avail causa-padrao then rowid(causa-padrao)
                                 else ?.                 

        find sint-padrao 
            where sint-padrao.cd-sint-padr = ord-manut.cd-sint-padr
            no-lock no-error.
        assign c-descr-sint = if avail sint-padrao then sint-padrao.descricao else "":U
               gr-sintoma   =  if avail sint-padrao then rowid(sint-padrao)
                                 else ?.                 

        find interv-padrao
            where interv-padrao.cd-interv-padr = ord-manut.cd-interv-padr
            no-lock no-error.
        assign c-descr-interv = if avail interv-padrao then interv-padrao.descricao else "":U
               gr-intervencao = if avail interv-padrao then rowid(interv-padrao)
                                else ?.                 

        if avail ord-manut then
           assign c-cod-estabel-ini = ord-manut.cod-estabel
                  c-cod-estabel-fim = ord-manut.cod-estabel.
    end.
    /* Dispatch standard ADM method.                             */

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    IF  AVAIL ord-manut THEN DO:
        FIND FIRST tecn-mi
             WHERE tecn-mi.cd-tecnico = ord-manut.cd-tecnico NO-LOCK NO-ERROR.
        IF  AVAIL tecn-mi THEN DO:
            DISP ord-manut.cd-tecnico @ c-nome with frame {&frame-name}.
            DISP nome-compl @ c-descr-tecnico with frame {&frame-name}.
        END.
        ELSE DO:
            ASSIGN c-nome = "000000".
            DISP c-nome with frame {&frame-name}.
            DISP "" @ c-descr-tecnico with frame {&frame-name}.
        END.
    END.
    ELSE DO:
        ASSIGN c-nome = "000000".
        DISP c-nome with frame {&frame-name}.
        DISP "" @ c-descr-tecnico with frame {&frame-name}.
    END.

    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard if  avail ord-manut then do:
    find manut where manut.cd-manut = ord-manut.cd-manut no-lock no-error.
    if avail manut then do:
ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.      
                        */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  if  avail ord-manut then do:
        find manut
            where manut.cd-manut = ord-manut.cd-manut
            no-lock no-error.
        find equipto
            where equipto.cd-equipto = ord-manut.cd-equipto
            no-lock no-error.
        find grup-maquina
            where grup-maquina.gm-codigo = equipto.gm-codigo
            no-lock no-error.
        if  (ord-manut.cd-manut  = ""
        or  (ord-manut.cd-manut <> ""
        and (avail manut 
        and (manut.controle = 2
        or   manut.controle = 3)))) 
        AND (avail grup-maquina and grup-maquina.ind-utiliz = no) then do:
            find last ut-equipto
                where ut-equipto.cd-equipto = ord-manut.cd-equipto
                no-lock no-error.
            if  avail ut-equipto then do:
                find tecn-mi
                    where tecn-mi.cd-tecnico = ut-equipto.cd-tecnico
                    no-lock no-error.
                disp (ut-equipto.contador - ut-equipto.vl-contador)
                                     @ de-tot-cont
                     ut-equipto.data @ da-movto with frame {&frame-name}.
                if  avail tecn-mi then do:
                    disp tecn-mi.cd-tecnico @ c-nome with frame {&frame-name}.
                    assign c-nome = tecn-mi.cd-tecnico.
                end.
                assign de-cont-ant = ut-equipto.contador  
                de-contador:screen-value in frame {&frame-name} = string(ut-equipto.contador + 1).
                disp ut-equipto.contador @ de-tot-cont with frame {&frame-name}.
            end.
            else do:
                  assign de-contador:screen-value in frame {&frame-name} = string(1).
                  disp 0 @ de-tot-cont with frame {&frame-name}.
            end.

            enable c-nome with frame {&frame-name}.
            if  equipto.tp-apont = 1 then do:
                enable de-contador with frame {&frame-name}.
                disable de-utilizacao with frame {&frame-name}.
            end.
            else do:
                enable de-utilizacao with frame {&frame-name}.
                disable de-contador with frame {&frame-name}.
            end.
        end.
        else do: 
            disable c-nome with frame {&frame-name}.            
            disable de-utilizacao with frame {&frame-name}.

            IF equipto.tp-apont = 1 AND (AVAIL manut AND (manut.controle = 2 OR manut.controle = 3)) THEN
                ENABLE de-contador with frame {&frame-name}.
            ELSE
                DISABLE de-contador with frame {&frame-name}. 


        end.
        
            ENABLE c-nome WITH FRAME {&FRAME-NAME}.
        
    end.        


  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.

      
         enable c-cod-docto-anexo with frame {&FRAME-NAME}.
      
  &endif



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
    /* Dispatch standard ADM method. */

    
        find first param-global no-lock no-error.
        assign c-cod-docto-anexo:hidden in frame {&FRAME-NAME} = no
               bt-docto:hidden in frame {&FRAME-NAME} = no.
        if c-cod-docto-anexo:load-mouse-pointer('image/lupa.cur') in frame {&frame-name} then.

        if  not valid-handle (h-bomn161) or
            h-bomn161:TYPE <> "PROCEDURE":U or
            h-bomn161:FILE-NAME <> "mnbo/bomn161.p":U then

            run mnbo/bomn161.p persistent set h-bomn161.

    

     RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

     find first param-global NO-LOCK.
     if param-global.modulo-po then
         run mnbo/bomn183a.p persistent set h-agenda-tec.

    /* Code placed here will execute AFTER standard behavior.    */

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
  
     if avail ord-manut then
        assign  c-cod-docto-anexo:screen-value in frame {&FRAME-NAME} = ord-manut.cod-docto-anexo.
     else
        assign c-cod-docto-anexo:screen-value in frame {&FRAME-NAME} = "".   
  


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-envia-hand V-table-Win 
PROCEDURE pi-envia-hand :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param p-handle as handle no-undo.

assign h-handle = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-preditiva V-table-Win 
PROCEDURE pi-mostra-preditiva :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE INPUT  PARAMETER pOrdem LIKE ord-manut.nr-ord-produ NO-UNDO.

    DEF BUFFER bfordmanut FOR ord-manut.

    Run ipp/ip0304a.p (INPUT pOrdem).
    IF RETURN-VALUE = "OK":U THEN DO:
        ASSIGN l-acoes-ativas = YES.
        FIND bfordmanut NO-LOCK
            WHERE bfordmanut.nr-ord-produ = pOrdem NO-ERROR.
        ASSIGN gr-ord-manut = ROWID(bfordmanut).

        SESSION:SET-WAIT-STATE("GENERAL":U).
        assign {&window-name}:sensitive = no.
        RUN ipp/ip0304.w.
        assign {&WINDOW-NAME}:sensitive = yes.
        SESSION:SET-WAIT-STATE("":U).

        run utp/ut-msgs.p (input 'show':U,
                           input 31211,
                           input STRING(ord-manut.nr-ord-produ)).
        IF RETURN-VALUE = "YES":U THEN
            RETURN "OK":U.
        ELSE
            RETURN "NOK":U.
    END.
    ELSE
        ASSIGN l-acoes-ativas = NO.
RETURN "ok":u.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-valor V-table-Win 
PROCEDURE pi-recebe-valor :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
run get-field-screen-value in adm-broker-hdl
(input this-procedure, input "dt-fecham").

assign da-movto:screen-value in frame {&frame-name} = return-value
       da-dt-fecham = date(return-value).

run pi-inicializa-var in h-handle (input return-value).
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
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

    find first param-mi no-lock no-error.
    if  c-nome:sensitive in frame {&frame-name} AND
        ((AVAIL manut AND manut.controle > 1) OR (input frame {&frame-name} c-nome <> "000000"))  THEN DO:
        find tecn-mi 
            where tecn-mi.cd-tecnico = input frame {&frame-name} c-nome
            AND tecn-mi.sit-tecn = 1
            no-lock no-error.
        if  not avail tecn-mi then do:
            {utp/ut-table.i mgind tecn-mi 1}
            run utp/ut-msgs.p(input "show",
                              input 56,
                              input return-value).
            return 'ADM-ERROR'.
        end.
    end.
    &if defined (bf_mnt_ems203) &then
    if param-mi.prop-utiliz then
    &else
    if  param-mi.log-1 = yes then
    &endif
    if  de-contador:sensitive in frame {&frame-name} and 
         input frame {&frame-name} de-contador <= input frame {&frame-name} de-tot-cont then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",
                           input 5545,
                           input return-value).
        return 'ADM-ERROR'.
    end.                              

    find tipo-manut
        where tipo-manut.cd-tipo = ord-manut.cd-tipo
        no-lock no-error.
    find first reservas
        where reservas.nr-ord-produ =  ord-manut.nr-ord-produ
        and   reservas.quant-atend  <> reservas.quant-aplic
        no-lock no-error.
    if  avail reservas
    and avail tipo-manut 
    and tipo-manut.forma-ajuste = 2 then do:
       /* {include/i-vldprg.i}*/
        {utp/ut-table.i mgind ord-manut 1}
        run utp/ut-msgs.p(input "show",
                          input 5924,
                          input return-value).
        return 'ADM-ERROR'.
    end.


    if  ord-manut.estado = 7
    or  ord-manut.estado = 8 then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind ord-manut 1}
        run utp/ut-msgs.p(input "show",
                          input 5944,
                          input return-value).
        return 'ADM-ERROR'.
    end.


    if  ord-manut.estado-om = 3 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 5676,
                          input return-value).
        return 'ADM-ERROR'.
    end.

    find first param-global no-lock no-error.
       
    if  param-global.modulo-pi = yes 
    and ord-manut.estado       = 1 then do:         
        {include/i-vldprg.i}
        run utp/ut-msgs.p(input "show",
                          input 5935,
                          input return-value).
        return 'ADM-ERROR'.
    end.
   
    IF param-global.log-modul-calib = yes
    AND ord-manut.tp-manut = 3 
    AND ord-manut.estado = 1 THEN DO:
        {utp/ut-table.i mgind ord-prod 1}
        run utp/ut-msgs.p(input "SHOW":U, 
                          input 28075, 
                          input return-value).    /* ordem de calibracao nao liberada*/
        return 'ADM-ERROR'.
    END.

    if  ord-manut.estado-om    = 4
    and ord-manut.om-encerrada = yes then do:
        {include/i-vldprg.i}
        {utp/ut-table.i mgind ord-manut 1}
        run utp/ut-msgs.p(input "show",
                          input 5944,
                          input return-value).
        return 'ADM-ERROR'.
    end.

    find equipto
        where equipto.cd-equipto = ord-manut.cd-equipto
        no-lock no-error.
    if  da-movto:sensitive in frame {&frame-name} = yes then do:
        find first ut-equipto
            where ut-equipto.cd-equipto = equipto.cd-equipto
            and   ut-equipto.data       > input frame {&frame-name} da-movto
            no-lock no-error.
        if  not available ut-equipto then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 6437,
                               input return-value).
            return 'ADM-ERROR'.
        end.

        if  input frame {&frame-name} de-contador <= de-cont-ant then do:
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",
                               input 5545,
                               input return-value).
            return 'ADM-ERROR'.
        end.                              
        if  equipto.tp-contador <> "Ne" 
        and input frame {&frame-name} de-utilizacao <= 0 then do:
            {include/i-vldprg.i}
            {utp/ut-liter.i "Utilizaá∆o" * r}
            run utp/ut-msgs.p (input "show",
                               input 6385,
                               input return-value).
            return 'ADM-ERROR'.
        end.                              
    end.

    find first sint-padrao where sint-padrao.cd-sint-padr = 
         input frame {&frame-name} ord-manut.cd-sint-padr no-error.
    if not avail sint-padrao then do:
       {include/i-vldprg.i}
       {utp/ut-field.i mgind ord-manut cd-sint-padr 1}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).
       return 'ADM-ERROR'.
    end.                           

    find first causa-padrao where causa-padrao.cd-causa-padr = 
         input frame {&frame-name} ord-manut.cd-causa-padr no-error.
    if not avail causa-padrao then do:
       {include/i-vldprg.i}
       {utp/ut-field.i mgind ord-manut cd-causa-padr 1}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).
       return 'ADM-ERROR'.
    end.                          

    find first interv-padrao where interv-padrao.cd-interv-padr = 
         input frame {&frame-name} ord-manut.cd-interv-padr no-error.
    if not avail interv-padrao then do:
       {include/i-vldprg.i}
       {utp/ut-field.i mgind ord-manut cd-interv-padr 1}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).
       return 'ADM-ERROR'.
    end.      


    if input frame {&FRAME-NAME} c-cod-docto-anexo <> "" then do:
     find docto_anexo where docto_anexo.cod_docto_anexo = input frame {&frame-name}  
          c-cod-docto-anexo no-lock no-error.

     if avail docto_anexo then do:
        IF AVAILABLE param-mi AND param-mi.cod-catal-docto-anexo <> "" THEN DO:
            IF docto_anexo.cod_catal_docto_anexo <> param-mi.cod-catal-docto-anexo THEN DO:
                run utp/ut-msgs.p (input 'show':U,
                                   input 7596,
                                   input string (param-mi.cod-catal-docto-anexo)).
                return no-apply.
            END.
        END.    
        ELSE DO:
           IF docto_anexo.cod_catal_docto_anexo <> param-global.cod-catal-docto-anexo then do: 
               run utp/ut-msgs.p (input 'show':U,
                                  input 7596,
                                  input string (param-global.cod-catal-docto-anexo)).
               return no-apply.

           END.
        END.
     end.
     else do:
        {utp/ut-table.i mguni docto_anexo 1}
        run utp/ut-msgs.p (input 'show':U,
                           input 558,
                           input return-value).
        apply 'entry' to c-cod-docto-anexo in frame {&FRAME-NAME}.                   
        return 'ADM-ERROR':U.
     end.
    end.  


      /*Se a ordem for de preditiva, faz as tratativas*/  
      &IF DEFINED (bf_mnt_ems208) &THEN
         IF ord-manut.tp-manut = 2
      &else
         IF ord-manut.dec-1 = 2
      &endif
      THEN DO:

      /*Tratativa da Preditiva*/
      IF l-log-modul-preditiva = YES THEN DO:

          RUN pi-mostra-preditiva IN THIS-PROCEDURE (INPUT ord-manut.nr-ord-produ).

          IF RETURN-VALUE = "NOK":U THEN 
              RETURN 'ADM-ERROR':U.
        
          /*:T--- Verifica se o DBO jˇ estˇ inicializado ---*/
          IF NOT VALID-HANDLE(hDBOMipParamPredit) OR
             hDBOMipParamPredit:TYPE <> "PROCEDURE":U OR
             hDBOMipParamPredit:FILE-NAME <> "mnbo/bomn215.p":U THEN DO:
             {btb/btb008za.i1 mnbo/bomn215.p YES}
             {btb/btb008za.i2 mnbo/bomn215.p '' hDBOMipParamPredit}
          END.

          RUN openQueryStatic IN hDBOMipParamPredit (INPUT "Main":U) NO-ERROR.

          RUN PermiteEncerrarOMCPendencia IN hDBOMipParamPredit.

          DELETE PROCEDURE hDBOMipParamPredit.

          IF RETURN-VALUE = "NOK":U THEN DO: /*N∆o Permite*/
/*               Run ipp/ip0304a.p (INPUT ord-manut.nr-ord-produ). */
              IF /*RETURN-VALUE = "OK":U*/ l-acoes-ativas = YES THEN DO: /*Existe Pendencia*/
                  run utp/ut-msgs.p (input 'show':U,
                                     input 31212,
                                     input "").
                  return 'ADM-ERROR':U.
              END.
          END.
      END.
  END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-ordem V-table-Win 
PROCEDURE pi-verifica-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def var c-liter1 as char format "x(15)" no-undo.
def var c-liter2 as char format "x(15)" no-undo.
def var c-liter3 as char format "x(06)" no-undo.
def var c-liter4 as char format "x(15)" no-undo.
DEFINE VARIABLE c-liter5 AS CHARACTER   NO-UNDO.

if  avail ord-manut then do:
    if  l-antecipa
    and ord-manut.dt-manut > da-dt-fecham then
        assign ord-manut.dt-manut = da-dt-fecham.
    if  l-antecipa = no
    and ord-manut.dt-manut > da-dt-fecham then do:
        run utp/ut-msgs.p (input "show",
                        input 30340,
                        input ""). 
        if RETURN-VALUE = "YES" then do:
            FIND CURRENT ord-manut EXCLUSIVE-LOCK.
            IF AVAIL ord-manut THEN
                ASSIGN ord-manut.dt-manut = da-dt-fecham.
            RETURN "OK":U.
        end.
        ELSE DO:
            return 'NOK':U.
        END.                
    end.
end. 

find first manut where manut.cd-manut = ord-manut.cd-manut
     no-lock no-error.

for each ord-taref
    where ord-taref.nr-ord-produ = ord-manut.nr-ord-produ no-lock
    break by ord-taref.cd-tarefa:


   /* N∆o valida tarefas agrupadas n∆o principais */
   if ord-taref.nr-ord-sum <> 0 and
       (ord-taref.nr-ord-princ <> 0 or ord-taref.cd-tarefa-princ <> 0) and
       (ord-taref.nr-ord-produ <> ord-taref.nr-ord-princ or
        ord-taref.cd-tarefa    <> ord-taref.cd-tarefa-princ)           then
       next.

   FIND FIRST funcao NO-LOCK
        WHERE funcao.cd-funcao = 'SPP-MI0309ACEITE'
          AND funcao.ativo     = YES NO-ERROR.
   IF NOT AVAIL funcao 
   AND param-mi.aceite-taref
   AND l-aceite = NO 
   AND CAN-FIND(FIRST ord-taref
                WHERE ord-taref.nr-ord-produ = ord-manut.nr-ord-produ
                  AND ord-taref.aceite       = YES
                  AND ord-taref.sit-aceite   = NO) THEN DO:

       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                           INPUT 5428,
                           INPUT STRING(ord-manut.nr-ord-produ)).
                           
       RETURN "nok".
        
   END.   

   if  ord-taref.tar-obrigatoria = yes
   and ord-taref.tempo-real = 0 then do:
       {utp/ut-field.i mgind ord-taref tar-obrigatoria 1}
       assign c-liter3 = trim(return-value) + " " + string(ord-taref.cd-tarefa).
       run utp/ut-msgs.p(input "show",
                         input 7383,
                         input c-liter3).
       return "nok".
   end.

   IF l-tarefa = NO AND ord-taref.estado < 4 THEN DO:
       IF ord-taref.tempo > 0 AND ord-taref.tempo-real = 0 THEN DO:
           {utp/ut-field.i mgind ord-taref cd-tarefa 1}
           assign c-liter5 = trim(return-value) + " " + string(ord-taref.cd-tarefa).
           run utp/ut-msgs.p(input "show",
                             input 7383,
                             input c-liter5).
           return "nok".
       END.
   END.

end.

if  l-oc-pend = no then do:
 
      find first param-mnt no-lock no-error.
        if  avail param-mnt 
        and param-mnt.modulo-cc
        and param-mnt.produto-cc = 2 then do:
            {btb/btb008za.i1 inbo/boin274.p YES}
            {btb/btb008za.i2 inbo/boin274.p '' hDBOOrdemCompra}
            run findSituacaoDiferenteEliminadaeRecebida in hDBOOrdemCompra
                         (input ord-manut.nr-ord-prod, output l-encontrado).
            run destroy in hDBOOrdemCompra.  
        end.

        if l-encontrado then do:
           {utp/ut-liter.i Ordem_de_Compra}
           assign c-liter4 = trim(return-value).
           run utp/ut-msgs.p(input "show",
                             input 5780,
                            input c-liter4).
           return "nok".
        end.             
end.

IF l-req-pend = NO THEN DO:

    FOR EACH req-ord-produ
      WHERE req-ord-produ.nr-ord-produ = ord-manut.nr-ord-produ:
        FIND FIRST requisicao                                            
             WHERE requisicao.nr-requisicao = req-ord-produ.nr-requisicao NO-LOCK NO-ERROR.
        IF  requisicao.situacao = 4 THEN DO:
            FIND FIRST ordem-compra
                 WHERE ordem-compra.nr-requisicao = req-ord-produ.nr-requisicao
                   AND ordem-compra.sequencia = req-ord-produ.sequencia        
                   AND (ordem-compra.situacao = 4 OR
                        ordem-compra.situacao = 6) NO-LOCK NO-ERROR.
            IF  AVAIL ordem-compra THEN DO:
                IF  ordem-compra.ordem-servic = 0 OR ordem-compra.ordem-servic = ord-manut.nr-ord-produ THEN
                    NEXT.
            END.
        END.

        IF  requisicao.situacao <> 2 THEN DO:
            RUN utp/ut-msgs.p(INPUT "show",
                              INPUT 5783,
                              INPUT RETURN-VALUE).
            RETURN "NOK":U.
        END.
    END.
END.

if l-movimenta = yes then
   run mip/mi1006.w.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.             */
  {src/adm/template/sndkytop.i}

  /* Return the key value associated with each key case.             */
  {src/adm/template/sndkycas.i "al-codigo" "ord-manut" "al-codigo"}
  {src/adm/template/sndkycas.i "cd-causa-padr" "ord-manut" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cd-equipto" "ord-manut" "cd-equipto"}
  {src/adm/template/sndkycas.i "nr-ord-produ" "ord-manut" "nr-ord-produ"}
  {src/adm/template/sndkycas.i "cd-inspecao" "ord-manut" "cd-inspecao"}
  {src/adm/template/sndkycas.i "cd-interv-padr" "ord-manut" "cd-interv-padr"}
  {src/adm/template/sndkycas.i "cd-manut" "ord-manut" "cd-manut"}
  {src/adm/template/sndkycas.i "sequencia" "ord-manut" "sequencia"}
  {src/adm/template/sndkycas.i "cd-parada" "ord-manut" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-tag" "ord-manut" "cd-tag"}
  {src/adm/template/sndkycas.i "cd-pend-padr" "ord-manut" "cd-pend-padr"}
  {src/adm/template/sndkycas.i "cd-planejado" "ord-manut" "cd-planejado"}
  {src/adm/template/sndkycas.i "cd-projeto" "ord-manut" "cd-projeto"}
  {src/adm/template/sndkycas.i "nr-rot-insp" "ord-manut" "nr-rot-insp"}
  {src/adm/template/sndkycas.i "nr-rot-lubr" "ord-manut" "nr-rot-lubr"}
  {src/adm/template/sndkycas.i "cd-sint-padr" "ord-manut" "cd-sint-padr"}
  {src/adm/template/sndkycas.i "cd-tipo" "ord-manut" "cd-tipo"}

  /* Close the CASE statement and end the procedure.                 */
  {src/adm/template/sndkyend.i}

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
  {src/adm/template/snd-list.i "ord-manut"}

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

