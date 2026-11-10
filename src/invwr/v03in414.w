&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V03IN414 2.00.00.007 } /*** 010007 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN414 MUT}
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
def new global shared var v-row-parent     as rowid no-undo.                                
def new global shared var gr-equipto       as rowid no-undo.
def new global shared var gr-tag           as rowid no-undo.
def new global shared var gr-fam-equipto   as rowid no-undo.
def new global shared var gr-centro-custo  as rowid no-undo.
def new global shared var gr-causa-padrao  as rowid no-undo.
def new global shared var gr-sint-padrao   as rowid no-undo.
def new global shared var gr-interv-padrao as rowid no-undo.
def new global shared var gr-requisitante  as rowid no-undo.

def new global shared var gc-cd-equipto    like equipto.cd-equipto     no-undo.
def new global shared var gc-fm-equipto    like fam-equipto.fm-equipto no-undo.
def new global shared var gc-cd-tag        like tag.cd-tag             no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-table-label1 as char format "x(40)" no-undo.
def var c-table-label2 as char format "x(40)" no-undo.
def var c-table-label3 as char format "x(40)" no-undo.
def var c-table1       as char format "x(22)" no-undo.
def var c-table2       as char format "x(13)" no-undo.
def var h-handle-pg2   as handle              no-undo.
def var c-handle       as char                no-undo.

def buffer b-solic-serv for solic-serv.

/** Unifica‡Æo de Conceito **/
{cdp/cdunif001.i}
{cdp/cdunif001.i1}  


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
&Scoped-define EXTERNAL-TABLES solic-serv
&Scoped-define FIRST-EXTERNAL-TABLE solic-serv


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR solic-serv.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS solic-serv.cd-equipto solic-serv.cd-tag ~
solic-serv.fm-equipto solic-serv.cc-codigo solic-serv.cd-causa-padr ~
solic-serv.cd-sint-padr solic-serv.cd-interv-padr solic-serv.nome-usua 
&Scoped-define ENABLED-TABLES solic-serv
&Scoped-define FIRST-ENABLED-TABLE solic-serv
&Scoped-Define ENABLED-OBJECTS RECT-12 
&Scoped-Define DISPLAYED-FIELDS solic-serv.cd-equipto solic-serv.cd-tag ~
solic-serv.fm-equipto solic-serv.cc-codigo solic-serv.cd-causa-padr ~
solic-serv.cd-sint-padr solic-serv.cd-interv-padr solic-serv.nome-usua 
&Scoped-define DISPLAYED-TABLES solic-serv
&Scoped-define FIRST-DISPLAYED-TABLE solic-serv
&Scoped-Define DISPLAYED-OBJECTS c-descricao-equipto c-descricao-tag ~
c-descricao-familia c-descricao-centro-custo c-descr-causa c-descr-sintoma ~
c-descr-interv c-nome-requis 

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
nr-soli-serv|y|y|mgind.solic-serv.nr-soli-serv
cd-causa-padr||y|mgind.solic-serv.cd-causa-padr
cc-codigo||y|mgind.solic-serv.cc-codigo
cd-equipto||y|mgind.solic-serv.cd-equipto
fm-equipto||y|mgind.solic-serv.fm-equipto
cd-manut||y|mgind.solic-serv.cd-manut
cd-parada||y|mgind.solic-serv.cd-parada
cd-tag||y|mgind.solic-serv.cd-tag
</FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = "nr-soli-serv",
     Keys-Supplied = "nr-soli-serv,cd-causa-padr,cc-codigo,cd-equipto,fm-equipto,cd-manut,cd-parada,cd-tag"':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-descr-causa AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-interv AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descr-sintoma AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-centro-custo AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-equipto AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-familia AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-tag AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-requis AS CHARACTER FORMAT "X(30)" 
     VIEW-AS FILL-IN 
     SIZE 35.86 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 82 BY 8.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     solic-serv.cd-equipto AT ROW 1.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-equipto AT ROW 1.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cd-tag AT ROW 2.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-tag AT ROW 2.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.fm-equipto AT ROW 3.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descricao-familia AT ROW 3.21 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cc-codigo AT ROW 4.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descricao-centro-custo AT ROW 4.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cd-causa-padr AT ROW 5.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-causa AT ROW 5.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cd-sint-padr AT ROW 6.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-sintoma AT ROW 6.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.cd-interv-padr AT ROW 7.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-descr-interv AT ROW 7.17 COL 36 COLON-ALIGNED NO-LABEL
     solic-serv.nome-usua AT ROW 8.17 COL 18 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 21.43 BY .88
     c-nome-requis AT ROW 8.17 COL 40.29 COLON-ALIGNED HELP
          "Nome completo do Requisitante" NO-LABEL
     RECT-12 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.solic-serv
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
         HEIGHT             = 8.25
         WIDTH              = 82.14.
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

/* SETTINGS FOR FILL-IN c-descr-causa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-interv IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descr-sintoma IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-centro-custo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-equipto IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-familia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-tag IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-requis IN FRAME f-main
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

&Scoped-define SELF-NAME solic-serv.cc-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cc-codigo V-table-Win
ON F5 OF solic-serv.cc-codigo IN FRAME f-main /* Centro Custo */
DO:

    IF NOT VALID-HANDLE(h_api_ccusto) THEN 
        RUN prgint/utb/utb742za.py PERSISTENT SET h_api_ccusto.

    RUN pi_zoom_ccusto in h_api_ccusto (INPUT "",
                                        INPUT "",
                                        INPUT "",
                                        INPUT TODAY,
                                        OUTPUT v_cod_ccusto,
                                        OUTPUT v_des_ccusto,
                                        OUTPUT TABLE tt_log_erro).

    if v_cod_ccusto <> "" then
		ASSIGN solic-serv.cc-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_cod_ccusto
           c-descricao-centro-custo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
		   
    if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cc-codigo V-table-Win
ON LEAVE OF solic-serv.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    if not valid-handle(h_api_ccusto) then run prgint/utb/utb742za.py persistent set h_api_ccusto.
	run pi_busca_dados_ccusto in h_api_ccusto (INPUT "",
                                               INPUT "",
                                               INPUT input frame {&frame-name} solic-serv.cc-codigo,
                                               INPUT today,
                                               OUTPUT v_des_ccusto,
                                               OUTPUT TABLE tt_log_erro).

   ASSIGN c-descricao-centro-custo:SCREEN-VALUE IN FRAME {&FRAME-NAME} = v_des_ccusto.
   
    if valid-handle(h_api_ccusto) then
		delete object h_api_ccusto.
		
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cc-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cc-codigo IN FRAME f-main /* Centro Custo */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-causa-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-causa-padr V-table-Win
ON F5 OF solic-serv.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in040.w"
                  &tabela=solic-serv
                  &atributo=cd-causa-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-causa-padr V-table-Win
ON LEAVE OF solic-serv.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  {include/leave.i &tabela=causa-padr
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-causa
                   &where="causa-padr.cd-causa-padr = input frame {&frame-name} solic-serv.cd-causa-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-causa-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-causa-padr IN FRAME f-main /* Causa */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-equipto V-table-Win
ON F5 OF solic-serv.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in095.w"
                  &tabela=solic-serv
                  &atributo=cd-equipto}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-equipto V-table-Win
ON LEAVE OF solic-serv.cd-equipto IN FRAME f-main /* Equipamento */
DO:

  if  solic-serv.cd-equipto:screen-value in frame {&frame-name} <> "" then do:
      {include/leave.i &tabela=equipto
                       &atributo-ref=descricao
                       &variavel-ref=c-descricao-equipto
                       &where="equipto.cd-equipto = input frame {&frame-name} solic-serv.cd-equipto"}
      {include/leave.i &tabela=equipto
                       &atributo-ref=cd-tag
                       &variavel-ref=solic-serv.cd-tag
                       &where="equipto.cd-equipto = input frame {&frame-name} solic-serv.cd-equipto"}
      {include/leave.i &tabela=equipto
                       &atributo-ref=fm-equipto
                       &variavel-ref=solic-serv.fm-equipto
                       &where="equipto.cd-equipto = input frame {&frame-name} solic-serv.cd-equipto"}
      {include/leave.i &tabela=equipto
                       &atributo-ref=cc-codigo
                       &variavel-ref=solic-serv.cc-codigo
                       &where="equipto.cd-equipto = input frame {&frame-name} solic-serv.cd-equipto"}



      if  gc-cd-equipto <> input frame {&frame-name} solic-serv.cd-equipto then
          assign gc-cd-equipto = INPUT frame {&frame-name} solic-serv.cd-equipto.
          run notify ('pi-planeja2,state-target').

      /* Verifica a situa‡Æo do equipamento */
      FIND FIRST PARAM-MI NO-LOCK NO-ERROR.
      /* Permite cadastrar com confirma‡Æo */
      IF PARAM-MI.perm-equip = 2 THEN DO:
         FIND FIRST EQUIPTO 
              WHERE EQUIPTO.CD-EQUIPTO = solic-serv.cd-equipto:SCREEN-VALUE NO-LOCK NO-ERROR.
         IF EQUIPTO.situacao <> 1 THEN DO:
            run utp/ut-msgs.p (input "show":U,input 7168,input "").
            if return-value = "no" then do:
               RETURN NO-APPLY. 
            end.
          END.
       END.
       ELSE DO: 
         /* NÆo permite cadastrar */
         IF PARAM-MI.perm-equip = 3 THEN DO:
            FIND FIRST EQUIPTO 
                 WHERE EQUIPTO.CD-EQUIPTO = solic-serv.cd-equipto:SCREEN-VALUE NO-LOCK NO-ERROR.
            IF EQUIPTO.situacao <> 1 THEN DO:
               run utp/ut-msgs.p (input "show":U,input 7176,input "").
               RETURN NO-APPLY.
            end.
         END.
      END.          
  END.

  assign gc-cd-equipto = INPUT frame {&frame-name} solic-serv.cd-equipto
         gc-fm-equipto = solic-serv.fm-equipto:screen-value in frame {&frame-name}
         gc-cd-tag     = solic-serv.cd-tag:screen-value in frame {&frame-name}.


END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-equipto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-equipto IN FRAME f-main /* Equipamento */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-interv-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-interv-padr V-table-Win
ON F5 OF solic-serv.cd-interv-padr IN FRAME f-main /* Interven‡Æo */
DO:
  assign l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in153.w"
                  &tabela=solic-serv
                  &atributo=cd-interv-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-interv-padr V-table-Win
ON LEAVE OF solic-serv.cd-interv-padr IN FRAME f-main /* Interven‡Æo */
DO:
  {include/leave.i &tabela=interv-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-interv
                   &where="interv-padrao.cd-interv-padr = input frame {&frame-name} solic-serv.cd-interv-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-interv-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-interv-padr IN FRAME f-main /* Interven‡Æo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-sint-padr
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-sint-padr V-table-Win
ON F5 OF solic-serv.cd-sint-padr IN FRAME f-main /* Sintoma */
DO:
  assign l-implanta = yes. 
  {include/zoom.i &prog-zoom="inzoom/z01in408.w"
                  &tabela=solic-serv
                  &atributo=cd-sint-padr}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-sint-padr V-table-Win
ON LEAVE OF solic-serv.cd-sint-padr IN FRAME f-main /* Sintoma */
DO:
  {include/leave.i &tabela=sint-padrao
                   &atributo-ref=descricao
                   &variavel-ref=c-descr-sintoma
                   &where="sint-padrao.cd-sint-padr = input frame {&frame-name} solic-serv.cd-sint-padr"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-sint-padr V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-sint-padr IN FRAME f-main /* Sintoma */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.cd-tag
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-tag V-table-Win
ON F5 OF solic-serv.cd-tag IN FRAME f-main /* TAG */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in419.w"
                  &tabela=solic-serv
                  &atributo=cd-tag}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-tag V-table-Win
ON LEAVE OF solic-serv.cd-tag IN FRAME f-main /* TAG */
DO:
  if  solic-serv.cd-tag:screen-value in frame {&frame-name} <> "" then do:
      {include/leave.i &tabela=tag
                       &atributo-ref=descricao
                       &variavel-ref=c-descricao-tag
                       &where="tag.cd-tag = input frame {&frame-name} solic-serv.cd-tag"}

      {include/leave.i &tabela=tag
                       &atributo-ref=cc-codigo
                       &variavel-ref=solic-serv.cc-codigo
                       &where="tag.cd-tag = input frame {&frame-name} solic-serv.cd-tag"}

      if  gc-cd-tag <> input frame {&frame-name} solic-serv.cd-tag then
          run notify ('pi-planeja2,state-target').
  end.

  assign gc-cd-tag = solic-serv.cd-tag:screen-value in frame {&frame-name}.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.cd-tag V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.cd-tag IN FRAME f-main /* TAG */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.fm-equipto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.fm-equipto V-table-Win
ON F5 OF solic-serv.fm-equipto IN FRAME f-main /* Fam¡lia */
DO:
  {include/zoom.i &prog-zoom="inzoom/z01in120.w"
                  &tabela=solic-serv
                  &atributo=fm-equipto}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.fm-equipto V-table-Win
ON LEAVE OF solic-serv.fm-equipto IN FRAME f-main /* Fam¡lia */
DO:
  {include/leave.i &tabela=fam-equipto
                   &atributo-ref=descricao
                   &variavel-ref=c-descricao-familia
                   &where="fam-equipto.fm-equipto = input frame {&frame-name} solic-serv.fm-equipto"}

  if  gc-fm-equipto <> input frame {&frame-name} solic-serv.fm-equipto then
      run notify ('pi-planeja2,state-target').

  assign gc-fm-equipto = solic-serv.fm-equipto:screen-value in frame {&frame-name}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.fm-equipto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.fm-equipto IN FRAME f-main /* Fam¡lia */
DO:
    apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME solic-serv.nome-usua
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.nome-usua V-table-Win
ON F5 OF solic-serv.nome-usua IN FRAME f-main /* Usu rio */
DO:
  {include/zoomvar.i &prog-zoom=inzoom/z01in627.w
                     &campo=solic-serv.nome-usua
                     &campozoom=cod-usuario}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.nome-usua V-table-Win
ON LEAVE OF solic-serv.nome-usua IN FRAME f-main /* Usu rio */
DO:
  {include/leave.i &tabela=usuar_mestre
                   &atributo-ref=nom_usuario
                   &variavel-ref=c-nome-requis
                   &where="usuar_mestre.cod_usuario = input frame {&frame-name} solic-serv.nome-usua"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL solic-serv.nome-usua V-table-Win
ON MOUSE-SELECT-DBLCLICK OF solic-serv.nome-usua IN FRAME f-main /* Usu rio */
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

  /************************ INTERNAL PROCEDURES ********************/
do with frame {&frame-name}:
 solic-serv.cd-equipto:load-mouse-pointer ("image/lupa.cur").
 solic-serv.cd-tag:load-mouse-pointer ("image/lupa.cur") .
 solic-serv.fm-equipto:load-mouse-pointer ("image/lupa.cur").
 solic-serv.cc-codigo:load-mouse-pointer ("image/lupa.cur") .
 solic-serv.cd-causa-padr:load-mouse-pointer ("image/lupa.cur").
 solic-serv.cd-interv-padr:load-mouse-pointer ("image/lupa.cur").
 solic-serv.cd-sint-padr:load-mouse-pointer ("image/lupa.cur").
 solic-serv.nome-usua:load-mouse-pointer ("image/lupa.cur") .
end.

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
  DEF VAR key-value AS CHAR NO-UNDO.
  DEF VAR row-avail-enabled AS LOGICAL NO-UNDO.

  /* LOCK status on the find depends on FIELDS-ENABLED. */
  RUN get-attribute ('FIELDS-ENABLED':U).
  row-avail-enabled = (RETURN-VALUE eq 'yes':U).
  /* Look up the current key-value. */
  RUN get-attribute ('Key-Value':U).
  key-value = RETURN-VALUE.

  /* Find the current record using the current Key-Name. */
  RUN get-attribute ('Key-Name':U).
  CASE RETURN-VALUE:
    WHEN 'nr-soli-serv':U THEN
       {src/adm/template/find-tbl.i
           &TABLE = solic-serv
           &WHERE = "WHERE solic-serv.nr-soli-serv eq INTEGER(key-value)"
       }
  END CASE.

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
  {src/adm/template/row-list.i "solic-serv"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "solic-serv"}

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

  if adm-new-record then do:
     assign solic-serv.nome-usua:screen-value in frame {&frame-name} = c-seg-usuario.
     find usuar_mestre
          where usuar_mestre.cod_usuario = input frame {&frame-name} solic-serv.nome-usua
          no-lock no-error.
      assign c-nome-requis:screen-value in frame {&frame-name} = if avail usuar_mestre then usuar_mestre.nom_usuario else "":U.

  end.
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

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}

  /* Ponha aqui a valida‡Æo de chave duplicada */

  /* Ponha aqui as demais valida‡äes */

  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  /*-------------------VERIFICA SE Jµ EXISTE O.S. PARA O EQUIPAMENTO--------------*/
   if can-find (first b-solic-serv where
      b-solic-serv.cd-equipto = input frame {&frame-name} solic-serv.cd-equipto and
      b-solic-serv.estado <> 4 and
      b-solic-serv.estado <> 5) then do:

      {utp/ut-table.i mgind solic-serv 1}
      assign c-table1 = return-value.

      {utp/ut-table.i mgind equipto 1}
      assign c-table2 = return-value.

      run utp/ut-msgs.p (input "show",
                         input 15115,
                         input c-table2 + "~~" + c-table1).

      if return-value = "yes" then
         for first equipto fields (cd-equipto) where 
              equipto.cd-equipto = input frame {&frame-name} solic-serv.cd-equipto
              no-lock :
              assign gr-equipto = rowid(equipto).
              run mip/mi0603.w.
         end.   
  end.

  /*--------------Verifica se j  existe O.S. para o tag ----------------------*/
  if can-find (first b-solic-serv where
      b-solic-serv.cd-tag = input frame {&frame-name} solic-serv.cd-tag and
      b-solic-serv.estado <> 4 and
      b-solic-serv.estado <> 5) then do:

      {utp/ut-table.i mgind solic-serv 1}
      assign c-table1 = return-value.

      {utp/ut-table.i mgind Tag 1}
      assign c-table2 = return-value.

      run utp/ut-msgs.p (input "show",
                         input 15115,
                         input c-table2 + "~~" + c-table1).

      if return-value = "yes" then  
         for first tag fields(cd-tag) where
             tag.cd-tag = input frame {&frame-name} solic-serv.cd-tag no-lock :
             assign gr-tag = rowid(tag).
            run mip/mi0719a.w.
         end.   
  end.


  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */


/* Jere */
IF solic-serv.cd-equipto:screen-value in frame {&frame-name} <> "" then do:
   IF PARAM-MI.perm-equip = 3 THEN DO:
      FIND FIRST EQUIPTO 
           WHERE EQUIPTO.CD-EQUIPTO = solic-serv.cd-equipto:SCREEN-VALUE NO-LOCK NO-ERROR.
      IF EQUIPTO.situacao <> 1 THEN DO:
         RUN utp/ut-msgs.p (input "show":U,input 7176,input "").
       /*  RETURN NO-APPLY. */
         RETURN 'ADM-ERROR':U.
      END.
   END.
END.
/* Jere */
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


  find first param-mi
      no-lock no-error.
  if  avail param-mi and param-mi.formato-cd-equipto <> " " then do:
      assign solic-serv.cd-equipto:format in frame {&frame-name} = param-mi.formato-cd-equipto.
  end.
  if  avail param-mi and param-mi.formato-cd-tag <> " " then do:
      assign solic-serv.cd-tag:format in frame {&frame-name} = param-mi.formato-cd-tag.
  end.

  if  available solic-serv then do:
      find equipto
          where equipto.cd-equipto = solic-serv.cd-equipto
          no-lock no-error.
      assign c-descricao-equipto = if avail equipto then equipto.descricao else "":U
             gr-equipto          = if avail equipto then rowid(equipto) else ?.
      find tag
          where tag.cd-tag = solic-serv.cd-tag
          no-lock no-error.
      assign c-descricao-tag = if avail tag then tag.descricao else "":U
             gr-tag          = if avail tag then rowid(tag) else ?.
      find fam-equipto
          where fam-equipto.fm-equipto = solic-serv.fm-equipto
          no-lock no-error.
      assign c-descricao-familia = if avail fam-equipto then fam-equipto.descricao else "":U
             gr-fam-equipto      = if avail fam-equipto then rowid(fam-equipto) else ?.
      find centro-custo
          where centro-custo.cc-codigo = solic-serv.cc-codigo
          no-lock no-error.
      assign c-descricao-centro-custo = if avail centro-custo then centro-custo.descricao else "":U
             gr-centro-custo          = if avail centro-custo then rowid(centro-custo) else ?.
      find causa-padrao
          where causa-padrao.cd-causa-padr = solic-serv.cd-causa-padr
          no-lock no-error.
      assign c-descr-causa   = if avail causa-padrao then causa-padrao.descricao else "":U
             gr-causa-padrao = if avail causa-padrao then rowid(causa-padrao) else ?.
      find sint-padrao
          where sint-padrao.cd-sint-padr = solic-serv.cd-sint-padr
          no-lock no-error.
      assign c-descr-sintoma = if avail sint-padrao then sint-padrao.descricao else "":U
             gr-sint-padrao  = if avail sint-padrao then rowid(sint-padrao) else ?.
      find interv-padrao
          where interv-padrao.cd-interv-padr = solic-serv.cd-interv-padr
          no-lock no-error.
      assign c-descr-interv   = if avail interv-padrao then interv-padrao.descricao else "":U
             gr-interv-padrao = if avail interv-padrao then rowid(interv-padrao) else ?.

      find usuar_mestre
          where usuar_mestre.cod_usuario = solic-serv.nome-usua
          no-lock no-error.
      assign c-nome-requis = if avail usuar_mestre then usuar_mestre.nom_usuario else "":U.

      assign gc-cd-equipto = solic-serv.cd-equipto
             gc-fm-equipto = solic-serv.fm-equipto
             gc-cd-tag     = solic-serv.cd-tag.
  end.   

  if  avail solic-serv then do with frame {&frame-name}:
      find equipto
          where equipto.cd-equipto = solic-serv.cd-equipto
          no-lock no-error.
      assign solic-serv.cd-tag:screen-value=if avail equipto then equipto.cd-tag else "":U.
      assign solic-serv.fm-equipto:screen-value=if avail equipto then equipto.fm-equipto else "":U.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  assign gc-cd-equipto = solic-serv.cd-equipto:screen-value in frame {&frame-name}
         gc-fm-equipto = solic-serv.fm-equipto:screen-value in frame {&frame-name}
         gc-cd-tag     = solic-serv.cd-tag:screen-value in frame {&frame-name}.

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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
  /* Code placed here will execute AFTER standard behavior.    */
/*  &if  defined(ADM-MODIFY-FIELDS) &then
 *       enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
 *   &endif*/

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

   assign gc-cd-equipto = ""
          gc-fm-equipto = ""
          gc-cd-tag     = "".


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

  {include/i-vldfrm.i} /* antigo frame:validate() */

  /* valida‡äes da viewer, sempre no modelo abaixo */

  if  solic-serv.cd-equipto:screen-value in frame {&frame-name} = ""
  and solic-serv.fm-equipto:screen-value in frame {&frame-name} = ""
  and solic-serv.cd-tag:screen-value in frame {&frame-name} = "" then do:
      {include/i-vldprg.i} /*posiciona p gina*/
      {utp/ut-table.i mgind equipto 1}
      assign c-table-label1 = return-value.
      {utp/ut-table.i mgind fam-equipto 1}
      assign c-table-label2 = return-value.
      {utp/ut-table.i mgind tag 1}
      assign c-table-label3 = return-value.
      run utp/ut-msgs.p (input "show", 
                         input 5491,
                         input c-table-label1 + "~~" + c-table-label2 + "~~" +
                               c-table-label3).
      apply 'entry' to solic-serv.cd-equipto in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  find centro-custo
      where centro-custo.cc-codigo = solic-serv.cc-codigo:screen-value in frame {&frame-name}
      no-lock no-error.
  if  not avail centro-custo then do:
      {include/i-vldprg.i} /*posiciona p gina*/
      {utp/ut-table.i mgind centro-custo 1}
      run utp/ut-msgs.p( input "show",
                         input 3549,
                         input return-value).
      apply 'entry' to solic-serv.cc-codigo in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

  find usuar_mestre
      where usuar_mestre.cod_usuario = solic-serv.nome-usua:screen-value in frame {&frame-name}
      no-lock no-error.
  if  not avail usuar_mestre then do:
      {include/i-vldprg.i} /*posiciona p gina*/
      {utp/ut-table.i mguni usuar_mestre 1}
      run utp/ut-msgs.p( input "show",
                         input 3549,
                         input return-value).
      apply 'entry' to solic-serv.nome-usua in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.

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
  {src/adm/template/sndkycas.i "nr-soli-serv" "solic-serv" "nr-soli-serv"}
  {src/adm/template/sndkycas.i "cd-causa-padr" "solic-serv" "cd-causa-padr"}
  {src/adm/template/sndkycas.i "cc-codigo" "solic-serv" "cc-codigo"}
  {src/adm/template/sndkycas.i "cd-equipto" "solic-serv" "cd-equipto"}
  {src/adm/template/sndkycas.i "fm-equipto" "solic-serv" "fm-equipto"}
  {src/adm/template/sndkycas.i "cd-manut" "solic-serv" "cd-manut"}
  {src/adm/template/sndkycas.i "cd-parada" "solic-serv" "cd-parada"}
  {src/adm/template/sndkycas.i "cd-tag" "solic-serv" "cd-tag"}

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
  {src/adm/template/snd-list.i "solic-serv"}

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

