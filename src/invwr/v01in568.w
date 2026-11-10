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
{include/i-prgvrs.i V01IN568 2.00.00.037 } /*** "010037" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN568 MUT}
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
 
/* global variable definitions */
def new global shared var v-row-parent as rowid no-undo.                                
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
def new global shared var i-ordem like oper-ord.nr-ord-produ no-undo.
def new global shared var c-it-codigo  like oper-ord.it-codigo no-undo.
def new global shared var gr-ord-prod  as rowid no-undo.
def new global shared var gr-ord-manut as rowid no-undo.
def new global shared var gr-estabelec as rowid no-undo.
DEF NEW GLOBAL SHARED VAR gr-movto-dir AS ROWID NO-UNDO.

{cdp/cdcfgman.i}  /* Preprocessador bf_man_linha_estab */
{cdp/cdcfgmnt.i}
{cpp/cpapi006.i}
{cdp/cd0666.i}
{mip/miapi002.i}

 
def var da-dt-retorno as date no-undo.

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}

def var dt-trans as date no-undo.

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
&Scoped-define EXTERNAL-TABLES movto-dir
&Scoped-define FIRST-EXTERNAL-TABLE movto-dir


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-dir.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-OBJECTS fi-nro-docto fi-serie-docto fi-it-codigo ~
c-desc-item fi-op-codigo c-desc-oper fi-cod-roteiro c-desc-roteiro ~
fi-cd-tecnico c-desc-tec fi-cd-tarefa c-desc-tarefa fi-gm-codigo c-desc-maq ~
fi-cc-codigo c-desc-cc fi-cd-mob-dir c-desc-mob 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,ord-manut,ord-prod */
&Scoped-define ADM-CREATE-FIELDS fi-nro-docto fi-serie-docto fi-it-codigo ~
fi-cc-codigo fi-cd-mob-dir 
&Scoped-define ADM-ASSIGN-FIELDS fi-nro-docto fi-serie-docto fi-it-codigo ~
fi-op-codigo fi-cod-roteiro fi-cd-tecnico fi-cd-tarefa fi-gm-codigo ~
fi-cc-codigo fi-cd-mob-dir 
&Scoped-define ord-manut fi-cd-tecnico fi-cd-tarefa fi-cc-codigo 
&Scoped-define ord-prod fi-op-codigo fi-cod-roteiro fi-gm-codigo ~
fi-cc-codigo 

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
DEFINE VARIABLE c-desc-cc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-maq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-mob AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-oper AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-roteiro AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tarefa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-tec AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cc-codigo AS CHARACTER FORMAT "X(20)":U 
     LABEL "Centro Custo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-mob-dir AS CHARACTER FORMAT "x(5)" 
     LABEL "MÆo-de-Obra Direta":R21 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-cd-tarefa AS INTEGER FORMAT ">>>>9":U INITIAL 0 
     LABEL "Tarefa Manuten‡Æo" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cd-tecnico AS CHARACTER FORMAT "99999-9":U 
     LABEL "T‚cnico" 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-roteiro AS CHARACTER FORMAT "x(16)" 
     LABEL "Roteiro":R9 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-gm-codigo AS CHARACTER FORMAT "x(9)" 
     LABEL "Grupo M quina":R16 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-it-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "Item":R10 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-nro-docto AS CHARACTER FORMAT "x(16)" 
     LABEL "Documento":R11 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-op-codigo AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "Opera‡Æo":R10 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE fi-serie-docto AS CHARACTER FORMAT "x(5)" 
     LABEL "":R18 
     VIEW-AS FILL-IN 
     SIZE 9.14 BY .88.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 83 BY 9.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-nro-docto AT ROW 1.25 COL 20.14 COLON-ALIGNED
     fi-serie-docto AT ROW 1.25 COL 72.29 COLON-ALIGNED HELP
          "S‚rie do Documento"
     fi-it-codigo AT ROW 2.25 COL 20.14 COLON-ALIGNED HELP
          "C¢digo do Item da Ordem"
     c-desc-item AT ROW 2.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-op-codigo AT ROW 3.25 COL 20.14 COLON-ALIGNED
     c-desc-oper AT ROW 3.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cod-roteiro AT ROW 4.25 COL 20.14 COLON-ALIGNED
     c-desc-roteiro AT ROW 4.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cd-tecnico AT ROW 5.25 COL 20.14 COLON-ALIGNED
     c-desc-tec AT ROW 5.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cd-tarefa AT ROW 6.25 COL 20.14 COLON-ALIGNED
     c-desc-tarefa AT ROW 6.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-gm-codigo AT ROW 7.25 COL 20.14 COLON-ALIGNED
     c-desc-maq AT ROW 7.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cc-codigo AT ROW 8.25 COL 20.14 COLON-ALIGNED
     c-desc-cc AT ROW 8.25 COL 40.57 COLON-ALIGNED NO-LABEL
     fi-cd-mob-dir AT ROW 9.25 COL 20.14 COLON-ALIGNED
     c-desc-mob AT ROW 9.25 COL 40.57 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.movto-dir
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
         WIDTH              = 83.
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

/* SETTINGS FOR FILL-IN c-desc-cc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-maq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-mob IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-oper IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-roteiro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tarefa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-tec IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-cc-codigo IN FRAME f-main
   NO-ENABLE 1 2 5 6                                                    */
/* SETTINGS FOR FILL-IN fi-cd-mob-dir IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-cd-tarefa IN FRAME f-main
   NO-ENABLE 2 5                                                        */
/* SETTINGS FOR FILL-IN fi-cd-tecnico IN FRAME f-main
   NO-ENABLE 2 5                                                        */
/* SETTINGS FOR FILL-IN fi-cod-roteiro IN FRAME f-main
   NO-ENABLE 2 6                                                        */
/* SETTINGS FOR FILL-IN fi-gm-codigo IN FRAME f-main
   NO-ENABLE 2 6                                                        */
/* SETTINGS FOR FILL-IN fi-it-codigo IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-nro-docto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN fi-op-codigo IN FRAME f-main
   NO-ENABLE 2 6                                                        */
/* SETTINGS FOR FILL-IN fi-serie-docto IN FRAME f-main
   NO-ENABLE 1 2                                                        */
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

&Scoped-define SELF-NAME fi-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON ENTRY OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    assign fi-cc-codigo:format in frame {&frame-name} = 'x(20)'.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON f5 OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
  
  &IF DEFINED (bf_man_linha_estab) &THEN
      find first estabelec
           where estabelec.cod-estabel = ord-prod.cod-estabel no-lock no-error.
      if avail estabelec then
         assign gr-estabelec = rowid(estabelec).
  &ENDIF
    
  /** Utilizar Centro de Custo Produtivo **/
  {include/zoomvar.i &prog-zoom  = "inzoom/z01in042.w"
                     &campo      = fi-cc-codigo
                     &campozoom  = cc-codigo
                     &campo2     = c-desc-cc
                     &campozoom2 = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON LEAVE OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
   {include/leave.i &tabela=centro-custo
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-cc
                     &where="centro-custo.cc-codigo = input frame {&frame-name} fi-cc-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-mob-dir
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-mob-dir V-table-Win
ON F5 OF fi-cd-mob-dir IN FRAME f-main /* MÆo-de-Obra Direta */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in566.w"
                       &campo=fi-cd-mob-dir
                       &campo2=c-desc-mob
                       &campozoom=cd-mob-dir
                       &campozoom2=descricao}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-mob-dir V-table-Win
ON LEAVE OF fi-cd-mob-dir IN FRAME f-main /* MÆo-de-Obra Direta */
DO:
   {include/leave.i &tabela=tab-mob-dir
                    &atributo-ref=descricao
                    &variavel-ref=c-desc-mob
                    &where="tab-mob-dir.cd-mob-dir = input frame {&frame-name} fi-cd-mob-dir"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-mob-dir V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-mob-dir IN FRAME f-main /* MÆo-de-Obra Direta */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-tarefa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tarefa V-table-Win
ON F5 OF fi-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
  assign gr-ord-manut = rowid(ord-manut).
  {include/zoomvar.i &prog-zoom  = "inzoom/z01in273.w"
                     &campo      = fi-cd-tarefa
                     &campozoom  = cd-tarefa
                     &campo2     = c-desc-tarefa
                     &campozoom2 = descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tarefa V-table-Win
ON LEAVE OF fi-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
    {include/leave.i &tabela=ord-taref
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-tarefa
                     &where="ord-taref.nr-ord-produ = ord-prod.nr-ord-produ and
                             ord-taref.cd-tarefa    = input frame {&frame-name} fi-cd-tarefa"}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tarefa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-tarefa IN FRAME f-main /* Tarefa Manuten‡Æo */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cd-tecnico
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tecnico V-table-Win
ON F5 OF fi-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
  {include/zoomvar.i &prog-zoom  = "inzoom/z01in428.w"
                     &campo      = fi-cd-tecnico
                     &campozoom  = cd-tecnico
                     &campo2     = c-desc-tec
                     &campozoom2 = nome-compl}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tecnico V-table-Win
ON LEAVE OF fi-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
 {include/leave.i
            &tabela=tecn-mi
            &variavel-ref=c-desc-tec
            &atributo-ref=nome-compl
            &where="tecn-mi.cd-tecnico = input frame {&frame-name} fi-cd-tecnico"}
 
  
   if fi-cd-tecnico <> input frame {&frame-name} fi-cd-tecnico then do:
       
      assign fi-cd-tecnico.
      find tecn-mi where 
           tecn-mi.cd-tecnico = input frame {&frame-name} fi-cd-tecnico 
           no-lock no-error.
      if avail tecn-mi then do:

         find equipto where
              equipto.cd-equipto = ord-manut.cd-equipto 
              no-lock no-error.         
         assign fi-gm-codigo = (if avail equipto then
                                   equipto.gm-codigo
                                else "").      
         assign fi-cc-codigo = tecn-mi.cc-codigo.

         disp fi-gm-codigo
              fi-cc-codigo with frame {&frame-name}.

         if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
                 run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                    INPUT "",
                                                    INPUT tecn-mi.cc-codigo,
                                                    INPUT today,
                                                    OUTPUT v_des_ccusto,
                                                    OUTPUT TABLE tt_log_erro).

         assign c-desc-cc:screen-value in frame {&frame-name} = v_des_ccusto.

         find tab-mob-dir where 
              tab-mob-dir.cd-mob-dir = tecn-mi.cd-mob-dir 
              no-lock no-error.
         if avail tab-mob-dir then
            assign fi-cd-mob-dir:screen-value = tecn-mi.cd-mob-dir
                   c-desc-mob:screen-value    = tab-mob-dir.descricao.
         else do:
              find esp-tecn where 
                   esp-tecn.cd-tecnico = input frame {&frame-name} fi-cd-tecnico and
                   esp-tecn.atividade  = 1 no-lock no-error.
              if avail esp-tecn  then do:
                 find mi-espec where 
                      mi-espec.tp-especial = esp-tecn.tp-especial 
                      no-lock no-error.
                 if avail mi-espec then do: 

                    find tab-mob-dir where
                         tab-mob-dir.cd-mob-dir = mi-espec.cd-mob-dir
                         no-lock no-error.
                    if avail tab-mob-dir then
                       assign fi-cd-mob-dir:screen-value  = mi-espec.cd-mob-dir
                              c-desc-mob:screen-value     = tab-mob-dir.descricao.
                 end.
              end.
         end.                                                                 
      end.
      else 
          assign c-desc-tec:screen-value in frame {&frame-name}  = ""
                 fi-gm-codigo:screen-value in frame {&frame-name} = ""
                 fi-gm-codigo                                     = "". 
   end.

    if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cd-tecnico V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cd-tecnico IN FRAME f-main /* T‚cnico */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-cod-roteiro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON F5 OF fi-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = fi-op-codigo
                     &campozoom  = op-codigo
                     &campo2     = fi-cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = fi-it-codigo
                     &campozoom3 = it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON LEAVE OF fi-cod-roteiro IN FRAME f-main /* Roteiro */
DO:  
     {include/leave.i &tabela=oper-ord
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-oper
                     &where="oper-ord.nr-ord-produ = ord-prod.nr-ord-produ and
                             oper-ord.it-codigo    = input frame {&frame-name} fi-it-codigo and
                             oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo and
                             oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro"}
    if fi-op-codigo <> int (fi-op-codigo:screen-value in frame {&frame-name}) then do:
       assign fi-op-codigo.
       run pi-leave-op-codigo.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-roteiro V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-roteiro IN FRAME f-main /* Roteiro */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-gm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-gm-codigo V-table-Win
ON F5 OF fi-gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
    {include/zoomvar.i &prog-zoom="inzoom/z01in144.w"
                       &campo=fi-gm-codigo
                       &campo2=c-desc-maq
                       &campozoom=gm-codigo
                       &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-gm-codigo V-table-Win
ON LEAVE OF fi-gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
    {include/leave.i
            &tabela=grup-maquina
            &atributo-ref=descricao
            &variavel-ref=c-desc-maq
            &where="grup-maquina.gm-codigo = input frame {&frame-name} fi-gm-codigo"}
    
    if fi-gm-codigo <> fi-gm-codigo:screen-value in frame {&frame-name} then do:
       assign fi-gm-codigo.

       &IF DEFINED (bf_man_linha_estab) &THEN
                        
                 find first gm-estab
                      where gm-estab.gm-codigo   = input  fi-gm-codigo
                        and gm-estab.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                
                                      
                 if not avail gm-estab then
                    find first gm-estab
                         where gm-estab.gm-codigo = input fi-gm-codigo
                         and   gm-estab.cod-estabel = "*" no-lock no-error.
                         
                
                 if avail gm-estab then DO:
                    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
                                        run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                               INPUT "",
                                                               INPUT gm-estab.cc-codigo,
                                                               INPUT today,
                                                               OUTPUT v_des_ccusto,
                                                               OUTPUT TABLE tt_log_erro).
                
                    assign fi-cc-codigo:screen-value in frame {&frame-name} = gm-estab.cc-codigo
                           c-desc-cc:screen-value    in frame {&frame-name} = v_des_ccusto
                           fi-cc-codigo:sensitive    in frame {&frame-name} = no.
                 end.
                 else do:
                     assign fi-cc-codigo:screen-value in frame {&frame-name} = ""
                            c-desc-cc:screen-value    in frame {&frame-name} = ""
                            fi-cc-codigo:sensitive    in frame {&frame-name} = yes.
                            apply 'entry' to fi-cc-codigo in frame {&frame-name}.
                            return no-apply.
                 end.
             &ELSE 

               find grup-maquina where 
                    grup-maquina.gm-codigo = input fi-gm-codigo
                    no-lock no-error.
               if avail grup-maquina then do:
                    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
                                        run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                               INPUT "",
                                                               INPUT gm-estab.cc-codigo,
                                                               INPUT today,
                                                               OUTPUT v_des_ccusto,
                                                               OUTPUT TABLE tt_log_erro).
                  assign fi-cc-codigo:screen-value in frame {&frame-name} = grup-maquina.cc-codigo
                         c-desc-cc:screen-value    in frame {&frame-name} = v_des_ccusto
                         fi-cc-codigo:sensitive    in frame {&frame-name} = no.
               end.
               else do:
                    assign fi-cc-codigo:screen-value in frame {&frame-name} = ""
                           c-desc-cc:screen-value    in frame {&frame-name} = ""
                           fi-cc-codigo:sensitive    in frame {&frame-name} = yes.
                    apply 'entry' to fi-cc-codigo in frame {&frame-name}.
                    return no-apply.
               end.
             &ENDIF
    end.
        
        if valid-handle(h_api_ccusto) then
                delete object h_api_ccusto.
                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-gm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-gm-codigo IN FRAME f-main /* Grupo M quina */
DO:
    apply "F5":U to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON F5 OF fi-it-codigo IN FRAME f-main /* Item */
DO:
  {include/zoomvar.i &prog-zoom = "inzoom/z01in172.w"
                     &campo     = fi-it-codigo
                     &campozoom = it-codigo   }
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON LEAVE OF fi-it-codigo IN FRAME f-main /* Item */
DO:
  {include/leave.i &tabela=item
                   &atributo-ref=desc-item
                   &variavel-ref=c-desc-item
                   &where="item.it-codigo = input frame {&frame-name} fi-it-codigo"}
  if fi-it-codigo <> fi-it-codigo:screen-value in frame {&frame-name} and
     not avail ord-manut then do:
     assign fi-it-codigo.                   
     run pi-leave-op-codigo.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-it-codigo IN FRAME f-main /* Item */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME fi-op-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON F5 OF fi-op-codigo IN FRAME f-main /* Opera‡Æo */
DO:
  assign i-ordem = ord-prod.nr-ord-prod.
  {include/zoomvar.i &prog-zoom  = "inzoom/z02in260.w"
                     &campo      = fi-op-codigo
                     &campozoom  = op-codigo
                     &campo2     = fi-cod-roteiro
                     &campozoom2 = cod-roteiro
                     &campo3     = fi-it-codigo
                     &campozoom3 = it-codigo}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON LEAVE OF fi-op-codigo IN FRAME f-main /* Opera‡Æo */
DO: 
    {include/leave.i &tabela=oper-ord
                     &atributo-ref=descricao
                     &variavel-ref=c-desc-oper
                     &where="oper-ord.nr-ord-produ = ord-prod.nr-ord-produ and
                             oper-ord.it-codigo    = input frame {&frame-name} fi-it-codigo and
                             oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo and
                             oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro"}
    if fi-op-codigo <> int (fi-op-codigo:screen-value in frame {&frame-name}) then do:
       assign fi-op-codigo.
       run pi-leave-op-codigo.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-op-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-op-codigo IN FRAME f-main /* Opera‡Æo */
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
  
if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.

do with frame {&frame-name}:
   if fi-it-codigo:load-mouse-pointer ("Image~\lupa.cur")   then.
   if fi-cd-tecnico:load-mouse-pointer ("Image~\lupa.cur")  then.
   if fi-op-codigo:load-mouse-pointer ("Image~\lupa.cur")   then.
   if fi-cd-tarefa:load-mouse-pointer ("Image~\lupa.cur")   then.
   if fi-cod-roteiro:load-mouse-pointer ("Image~\lupa.cur") then.
   if fi-gm-codigo:load-mouse-pointer ("Image~\lupa.cur")   then.
   if fi-cc-codigo:load-mouse-pointer ("Image~\lupa.cur")   then.
   if fi-cd-mob-dir:load-mouse-pointer ("Image~\lupa.cur")  then.
   {utp/ut-field.i mgind movto-dir nro-docto 1}
   assign fi-nro-docto:label  = trim (return-value).
   {utp/ut-field.i mgind movto-dir serie-docto 1}
   assign fi-serie-docto:label = trim (return-value).
   {utp/ut-field.i mgind movto-dir it-codigo 1}
   assign fi-it-codigo:label  = trim (return-value).
   {utp/ut-field.i mgind tecn-mi cd-tecnico 1}
   assign fi-cd-tecnico:label = trim (return-value).
   {utp/ut-field.i mgind movto-dir op-codigo 1}
   assign fi-op-codigo:label = trim (return-value).
   {utp/ut-field.i mgind ord-taref cd-tarefa 1}
   assign fi-cd-tarefa:label = trim (return-value).
   {utp/ut-field.i mgind movto-dir cod-roteiro 1}
   assign fi-cod-roteiro:label  = trim (return-value).
   {utp/ut-field.i mgind movto-dir gm-codigo 1}
   assign fi-gm-codigo:label  = trim (return-value).
   {utp/ut-field.i mgind movto-dir cc-codigo 1}
   assign fi-cc-codigo:label  = trim (return-value).
   {utp/ut-field.i mgind movto-dir cd-mob-dir 1}
   assign fi-cd-mob-dir:label = trim (return-value).
end.

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
  {src/adm/template/row-list.i "movto-dir"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-dir"}

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.
  

  
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
 
  /* Code placed here will execute PRIOR to standard behavior. */
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
 
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
 
  find ord-prod  where 
       rowid(ord-prod) = gr-ord-prod 
       no-lock no-error.
  find ord-manut where 
       ord-manut.nr-ord-produ = ord-prod.nr-ord-produ 
       no-lock no-error.
  run get-attribute in this-procedure ('adm-new-record').
  if return-value = 'yes' then do:
     assign fi-it-codigo = ord-prod.it-codigo.
     find item where 
          item.it-codigo = ord-prod.it-codigo
          no-lock no-error.
     assign c-desc-item = (if avail item then
                              item.desc-item
                           else "").
     disp fi-it-codigo
          fi-op-codigo
          fi-cod-roteiro
          c-desc-item with frame {&frame-name}.
     enable {&ADM-CREATE-FIELDS} with frame {&frame-name}.
     if avail ord-manut then
        enable {&ord-manut} with frame {&frame-name}.        
     else do:
          enable {&ord-prod} with frame {&frame-name}.
          assign fi-gm-codigo:sensitive in frame {&frame-name} = (ord-prod.reporte-mob = 1).
     end.
     
     run pi-leave-op-codigo.
     
     apply 'entry' to fi-nro-docto in frame {&frame-name}.
  end.
    
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
 
  find ord-prod where rowid (ord-prod) = gr-ord-prod no-lock no-error.
  IF gr-movto-dir <> ? THEN
    FIND movto-dir WHERE
         ROWID(movto-dir) = gr-movto-dir NO-LOCK NO-ERROR.

  if avail ord-prod then do:         
     if avail movto-dir then do:
        assign fi-nro-docto = movto-dir.nro-docto
               fi-serie-docto = movto-dir.serie-docto
               fi-it-codigo = movto-dir.it-codigo
 
               fi-op-codigo    = movto-dir.op-codigo
               fi-cod-roteiro  = movto-dir.cod-roteiro
               fi-gm-codigo    = movto-dir.gm-codigo
               fi-cd-mob-dir   = movto-dir.cd-mob-dir
               fi-cd-tarefa    = movto-dir.cd-tarefa
               fi-cd-tecnico   = movto-dir.cd-tecnico
               fi-cc-codigo    = movto-dir.cc-codigo.  
 
        find item where item.it-codigo = movto-dir.it-codigo no-lock no-error.
        if avail item then 
           assign c-desc-item = item.desc-item.
        else
            assign c-desc-item = "".
 
        find oper-ord where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
                        and oper-ord.it-codigo    = movto-dir.it-codigo
                        and oper-ord.op-codigo    = movto-dir.op-codigo
                        and oper-ord.cod-roteiro  = movto-dir.cod-roteiro
             no-lock no-error.
        if avail oper-ord then
           assign c-desc-oper = oper-ord.descricao.
        else
            assign c-desc-oper = "".
 
        find first ord-taref
             where ord-taref.nr-ord-produ = movto-dir.nr-ord-produ
               and ord-taref.cd-tarefa    = movto-dir.cd-tarefa no-lock no-error.
        if  available(ord-taref) then
            assign c-desc-tarefa = ord-taref.descricao.
        else
            assign c-desc-tarefa = "".
        find grup-maquin where grup-maquin.gm-codigo = movto-dir.gm-codigo
             no-lock no-error.
        if avail grup-maquin then
           assign c-desc-maq = grup-maquin.descricao.
        else
            assign c-desc-maq = "".


        if not valid-handle(h_api_ccusto) then 
            run prgint/utb/utb742za.py persistent set h_api_ccusto.

        run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                   INPUT "",
                                                   INPUT fi-cc-codigo,
                                                   INPUT today,
                                                   OUTPUT v_des_ccusto,
                                                   OUTPUT TABLE tt_log_erro).
        assign c-desc-cc = v_des_ccusto.

        find tab-mob-dir where tab-mob-dir.cd-mob-dir = movto-dir.cd-mob-dir
             no-lock no-error.
        if avail tab-mob-dir then
           assign c-desc-mob = tab-mob-dir.descricao.
        else
            assign c-desc-mob = "".                              
 
        assign da-dt-retorno = movto-dir.dt-trans.            
 
     end.
  end.
 
  run dispatch in this-procedure ('display-fields').
 
  if valid-handle(h_api_ccusto) then
          delete object h_api_ccusto.
                
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-leave-op-codigo V-table-Win 
PROCEDURE pi-leave-op-codigo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    find first oper-ord 
         where oper-ord.nr-ord-produ = ord-prod.nr-ord-produ
           and oper-ord.it-codigo    = input frame {&frame-name} fi-it-codigo
           and oper-ord.op-codigo    = input frame {&frame-name} fi-op-codigo
           and oper-ord.cod-roteiro  = input frame {&frame-name} fi-cod-roteiro
           no-lock no-error.
    
    assign c-desc-oper:screen-value in frame {&frame-name} = (if avail oper-ord then
                                                                 oper-ord.descricao
                                                              else "").                 
    if fi-op-codigo <> 0 then do:
        if  available(oper-ord) then do:
            if oper-ord.tipo-oper = 2 then do:
                run utp/ut-msgs.p (input "show",
                                   input 17474,
                                   input "").
                return no-apply.
            end.
            else do:
                assign fi-gm-codigo:sensitive     in frame {&frame-name} = (ord-prod.reporte-mob = 1)
                       fi-gm-codigo                                      = oper-ord.gm-codigo
                       fi-gm-codigo:screen-value  in frame {&frame-name} = oper-ord.gm-codigo
                       fi-cd-mob-dir:screen-value in frame {&frame-name} = oper-ord.cd-mob-dir.         


             &IF DEFINED (bf_man_linha_estab) &THEN

                find first gm-estab
                     where gm-estab.gm-codigo   = oper-ord.gm-codigo
                       and gm-estab.cod-estabel = ord-prod.cod-estabel no-lock no-error.
                
                if not avail gm-estab then
                    find first gm-estab
                         where gm-estab.gm-codigo = oper-ord.gm-codigo
                         and   gm-estab.cod-estabel = "*" no-lock no-error.
                      
                
                if avail gm-estab then do :
                    assign fi-cc-codigo                                     = gm-estab.cc-codigo
                           fi-cc-codigo:screen-value in frame {&frame-name} = gm-estab.cc-codigo .
                    if not valid-handle(h_api_ccusto) then 
                        run prgint/utb/utb742za.py persistent set h_api_ccusto.

                    run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                                INPUT "",
                                                                INPUT gm-estab.cc-codigo,
                                                                INPUT today,
                                                                OUTPUT v_des_ccusto,
                                                                OUTPUT TABLE tt_log_erro).
                    find grup-maquina where 
                          grup-maquina.gm-codigo = oper-ord.gm-codigo no-lock no-error.
                    if avail grup-maquina THEN
                        assign c-desc-maq:screen-value   in frame {&frame-name} = grup-maquina.descricao
                               fi-cc-codigo:sensitive    in frame {&frame-name} = avail ord-manut
                               c-desc-cc:screen-value    in frame {&frame-name} = v_des_ccusto.
                end.
                else
                    assign fi-cc-codigo                                     = ""
                           fi-cc-codigo:screen-value in frame {&frame-name} = ""
                           c-desc-maq:screen-value   in frame {&frame-name} = ""
                           fi-cc-codigo:sensitive    in frame {&frame-name} = YES.

             &ELSE        
                find grup-maquina where 
                     grup-maquina.gm-codigo = oper-ord.gm-codigo no-lock no-error.
                if avail grup-maquina then
                     assign fi-cc-codigo                                     = grup-maquina.cc-codigo
                            fi-cc-codigo:screen-value in frame {&frame-name} = grup-maquina.cc-codigo
                            c-desc-maq:screen-value   in frame {&frame-name} = grup-maquina.descricao
                            fi-cc-codigo:sensitive    in frame {&frame-name} = avail ord-manut.
                else
                    assign fi-cc-codigo                                     = ""
                           fi-cc-codigo:screen-value in frame {&frame-name} = ""
                           c-desc-maq:screen-value   in frame {&frame-name} = ""
                           fi-cc-codigo:sensitive    in frame {&frame-name} = yes.                    
                
                if not valid-handle(h_api_ccusto) then 
                    run prgint/utb/utb742za.py persistent set h_api_ccusto.

                run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                                            INPUT "",
                                                            INPUT input frame {&frame-name} fi-cc-codigo,
                                                            INPUT today,
                                                            OUTPUT v_des_ccusto,
                                                            OUTPUT TABLE tt_log_erro).
                assign c-desc-cc:screen-value in frame {&frame-name} = v_des_ccusto.
             &ENDIF
            end.
        end.
        else do:
            assign fi-gm-codigo:screen-value  in frame {&frame-name} = ""
                   fi-gm-codigo                                      = ""
                   fi-cc-codigo:screen-value  in frame {&frame-name} = ""
                   fi-cc-codigo                                      = ""
                   fi-cd-mob-dir:screen-value in frame {&frame-name} = ""
                   c-desc-maq:screen-value    in frame {&frame-name} = ""
                   c-desc-cc:screen-value     in frame {&frame-name} = ""
                   fi-gm-codigo:sensitive     in frame {&frame-name} = 
                   not can-find (first oper-ord 
                                 where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod no-lock)
                   and input frame {&frame-name} fi-op-codigo = 0
                   fi-cc-codigo:sensitive     in frame {&frame-name} =
                   fi-gm-codigo:sensitive     in frame {&frame-name}
                   fi-cd-mob-dir:sensitive    in frame {&frame-name} =
                   fi-gm-codigo:sensitive     in frame {&frame-name}.
        end.
    end.
    else do:
         assign fi-gm-codigo:screen-value  in frame {&frame-name} = ""
                fi-gm-codigo                                      = ""
                fi-cc-codigo:screen-value  in frame {&frame-name} = ""
                fi-cc-codigo                                      = ""
                fi-cd-mob-dir:screen-value in frame {&frame-name} = ""
                c-desc-maq:screen-value    in frame {&frame-name} = ""
                c-desc-cc:screen-value     in frame {&frame-name} = ""
                fi-gm-codigo:sensitive     in frame {&frame-name} = yes
                fi-cc-codigo:sensitive     in frame {&frame-name} = yes
                fi-cd-mob-dir:sensitive    in frame {&frame-name} = yes.
    end. 

    if valid-handle(h_api_ccusto) then
        delete object h_api_ccusto.
                
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-update-record V-table-Win 
PROCEDURE pi-update-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE VARIABLE cHora   AS CHARACTER NO-UNDO.
DEFINE VARIABLE cMinuto AS CHARACTER NO-UNDO.

{include/i-vldfrm.i}
do   with frame {&frame-name}:
 
     for each tt-movto-dir:
         delete tt-movto-dir.
     end.
     create tt-movto-dir.
 
     find first oper-ord
          where oper-ord.nr-ord-prod = ord-prod.nr-ord-prod
            and oper-ord.it-codigo   = input fi-it-codigo
            and oper-ord.op-codigo   = input fi-op-codigo
            and oper-ord.cod-roteiro = input fi-cod-roteiro
          no-lock no-error.
     run get-attribute ('adm-new-record').  
     assign tt-movto-dir.cod-versao-integracao = 1
            tt-movto-dir.nr-ord-produ          = ord-prod.nr-ord-produ
            tt-movto-dir.cod-estabel           = ord-prod.cod-estabel
            tt-movto-dir.nro-docto             = input fi-nro-docto
            tt-movto-dir.serie-docto           = input fi-serie-docto
            tt-movto-dir.qt-reportada          = 0
            tt-movto-dir.it-codigo             = input fi-it-codigo
            tt-movto-dir.op-codigo             = input fi-op-codigo
            tt-movto-dir.cod-roteiro           = input fi-cod-roteiro
            tt-movto-dir.gm-codigo             = input fi-gm-codigo
            tt-movto-dir.cd-mob-dir            = input fi-cd-mob-dir
            tt-movto-dir.tipo-trans            = if return-value = "yes" 
                                                    then 1
                                                    else 2
            tt-movto-dir.cd-tecnico            = input fi-cd-tecnico
            tt-movto-dir.cd-tarefa             = input fi-cd-tarefa
            tt-movto-dir.cc-codigo             = input fi-cc-codigo
            tt-movto-dir.rw-mov-orig           = if avail movto-dir then 
                                                    rowid (movto-dir)
                                                 else ?
            tt-movto-dir.op-seq                = if avail oper-ord then
                                                    oper-ord.sequencia
                                                 else 0                                     
            tt-movto-dir.dt-retorno            = if return-value = "yes"
                                                    then ?
                                                    else da-dt-retorno.    
            &IF DEFINED (bf_man_204) &THEN
               assign
                 tt-movto-dir.num-id-movto-dir = next-value(seq-movto-dir,mgind). 
            &ENDIF 
 
 

     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-dt-trans").
     assign tt-movto-dir.dt-trans = date(return-value).
     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-tempo-homem").      
     assign tt-movto-dir.tempo-homem  = decimal (return-value).     
     assign tt-movto-dir.horas-report = decimal (return-value).
     RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-cd-turno").
      assign tt-movto-dir.cd-turno = return-value
             tt-movto-dir.lg-recalc-horas = yes.
      RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-referencia").
      assign tt-movto-dir.char-1 = return-value.
      RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT THIS-PROCEDURE,
         INPUT "fi-matr-func").
      assign tt-movto-dir.matr-func = int(return-value).
      
      run cpp/cpapi006.p (input-output table tt-movto-dir,
                          input-output table tt-erro,
                          input        yes).
     
     find first tt-erro no-lock no-error.
     if  avail tt-erro then do:
         run cdp/cd0666.w (input table tt-erro).
         undo, return "adm-error".
     end.
     else do:

         /********************* CHAMADA UPC *********************/
         /** Chamada referente …s chamadas X do Magnus do CP0320
             "Reporte-Real" FO 825.431 - Magistral **/
         find first tt-movto-dir.
         RUN pi-upc (INPUT "row-movto-dir",
                     INPUT "bt-ok",
                     INPUT ?,
                     INPUT ?,
                     INPUT "movto-dir",
                     INPUT tt-movto-dir.rw-movto-dir).

         if return-value = "NOK":U then
            undo, return "adm-error":U.

         /******************************************************/
     end.
 
     find first ord-taref where
                ord-taref.cd-tarefa    = tt-movto-dir.cd-tarefa    and
                ord-taref.nr-ord-produ = tt-movto-dir.nr-ord-produ
                exclusive-lock no-error.
 
     if  available(ord-taref) then do:
         find first tt-movto-dir.
         find first esp-tecn
              where esp-tecn.cd-tecnico = input frame {&frame-name} fi-cd-tecnico
                and esp-tecn.atividade = 1 no-lock no-error.
         create tt-ord-mob.
         assign tt-ord-mob.nr-ord-produ = ord-prod.nr-ord-produ
                tt-ord-mob.cd-tarefa    = input fi-cd-tarefa
                tt-ord-mob.dt-trans     = tt-movto-dir.dt-trans
                tt-ord-mob.cc-codigo    = input fi-cc-codigo
                tt-ord-mob.horas-report = tt-movto-dir.tempo-homem
                tt-ord-mob.tipo-trans   = tt-movto-dir.tipo-trans
                tt-ord-mob.cd-tecnico   = tt-movto-dir.cd-tecnico
                tt-ord-mob.tp-especial  = esp-tecn.tp-especial
                tt-ord-mob.cod-versao-integracao = 2
                tt-ord-mob.gera-movto-ggf = no
                tt-ord-mob.gera-movto-dir = no.

         &if defined(bf_mnt_ems204) &then
         /* Busca Parƒmetros MI */
         FIND FIRST param-mi NO-LOCK NO-ERROR.
         /* Hora Inicial */
         RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                       INPUT "i-hr-ini").
         ASSIGN cHora = STRING(RETURN-VALUE).
         RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                       INPUT "i-min-ini").
         ASSIGN cMinuto = STRING(RETURN-VALUE).
         ASSIGN tt-ord-mob.hora-inicio = cHora + cMinuto + "00".

         /* Hora Final */
         RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                       INPUT "i-hr-fim").
         ASSIGN cHora = STRING(RETURN-VALUE).
         RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                       INPUT "i-min-fim").
         ASSIGN cMinuto = STRING(RETURN-VALUE).
         ASSIGN tt-ord-mob.hora-termino = cHora + cMinuto + "00".

         IF AVAIL param-mi THEN DO:
             IF param-mi.tp-turno = 1 THEN DO:
                 ASSIGN tt-ord-mob.cd-turno = param-mi.cd-turno.
             END.
             ELSE DO:
                 RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                               INPUT "fi-cd-turno").
                 assign tt-ord-mob.cd-turno = int(return-value).
             END.
         END.
         &ENDIF
        
        run mip/miapi002.p (input-output table tt-ord-mob,
                            input-output table tt-erro,
                            input yes).
        
        find first tt-erro no-lock no-error.
        if  avail tt-erro then do:
            run cdp/cd0666.w (input table tt-erro).
            undo, return "adm-error".
        end.
 

        find first tt-ord-mob.
 
        if  tt-movto-dir.tipo-trans = 1 then
            assign ord-taref.tempo-real = ord-taref.tempo-real + 
                                          tt-ord-mob.horas-report.
        else do:
            assign ord-taref.tempo-real = ord-taref.tempo-real - 
                                          tt-ord-mob.horas-report.
            if  ord-taref.tempo-real < 0 then do:
                run utp/ut-msgs.p (input "show",
                                   input 6489,
                                   input "").
                undo, return "adm-error".
            end.
        end.
 
    end.
end.
 
disable all with frame {&frame-name}.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */
 
 
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
  {src/adm/template/snd-list.i "movto-dir"}

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

