&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V76IN172 2.00.00.050}  /*** "010050" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v76in172 MUT}
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
def new global shared var v-row-parent as rowid   no-undo.
def new global shared var l-mod-pd     as logical no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

/**  Melhorias
**/
{cdp/cdcfgmat.i}


def var c-local             like saldo-estoq.cod-localiz no-undo.
def var i-tipo-contr        as integer no-undo.
def var i-tipo-contr-estoq  as integer no-undo.
def var i-saldo             as integer no-undo.

/************* Multi-Planta ***************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.

{cdp/cd7300.i1}
{cdp/cd0669.i}
{mcinc/mcapi003.i}
def temp-table tt-dados-env-SMC     like tt-dados-env.
def temp-table tt-replica-msg-SMC   like tt-replica-msg.
def temp-table tt-control-env-SMC   like tt-control-env.
def temp-table tt-integracao-SMC    like tt-integracao.

/*************Fim Multi-Planta*****************/

/*** Vari†veis para integraá∆o EMS x SISDOC ***/

def var i-integracao-sisdoc as integer init ? no-undo.
def var c-handle            as char           no-undo.
def var c-opcao-int         as char           no-undo.
def var i-retorno-erro      as integer init ? no-undo.

    /* 
    ** 5 => Quando parÉmetro "nao-integra" e o registro j† est† integrado **
    ** 6 => Erro de integraá∆o no SISDOC                                  **
    ** 7 => Erro de integraá∆o no EMS                                     ** */

/********* Fim vari†veis para integraá∆o ******/

    def var c-lista-prioridade   as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.nat-despesa item.ge-codigo ~
item.deposito-pad item.fm-codigo item.cod-localiz item.data-ult-ent ~
item.data-ult-sai item.loc-unica item.fraciona item.alt-refer 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nat-despesa ~{&FP2}nat-despesa ~{&FP3}~
 ~{&FP1}ge-codigo ~{&FP2}ge-codigo ~{&FP3}~
 ~{&FP1}deposito-pad ~{&FP2}deposito-pad ~{&FP3}~
 ~{&FP1}fm-codigo ~{&FP2}fm-codigo ~{&FP3}~
 ~{&FP1}cod-localiz ~{&FP2}cod-localiz ~{&FP3}~
 ~{&FP1}data-ult-ent ~{&FP2}data-ult-ent ~{&FP3}~
 ~{&FP1}data-ult-sai ~{&FP2}data-ult-sai ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.nat-despesa item.ge-codigo ~
item.deposito-pad item.fm-codigo item.cod-localiz item.data-ult-ent ~
item.data-ult-sai item.loc-unica item.fraciona item.alt-refer 
&Scoped-Define DISPLAYED-OBJECTS desc-nat-despesa desc-ge-codigo ~
desc-deposito-pad desc-fm-codigo cb-tipo-controle-estoque ~
cb-tipo-controle-estoq-segur de-var-aprov cb-prioridade 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item.loc-unica 
&Scoped-define ADM-MODIFY-FIELDS cb-tipo-controle-estoque ~
cb-tipo-controle-estoq-segur 

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
DEFINE VARIABLE cb-prioridade AS CHARACTER FORMAT "X(256)":U 
     LABEL "Prior. Aprov." 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 13.72 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-controle-estoq-segur AS CHARACTER FORMAT "X(15)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 15 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tipo-controle-estoque AS CHARACTER FORMAT "X(18)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "Item 1" 
     SIZE 18 BY 1 NO-UNDO.

DEFINE VARIABLE de-var-aprov AS DECIMAL FORMAT ">>9.99":U INITIAL 0 
     LABEL "Variaá∆o Perm." 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE desc-deposito-pad AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 52.29 BY .88 NO-UNDO.

DEFINE VARIABLE desc-fm-codigo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 47.14 BY .88 NO-UNDO.

DEFINE VARIABLE desc-ge-codigo AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 55.72 BY .88 NO-UNDO.

DEFINE VARIABLE desc-nat-despesa AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 53.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 9.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.nat-despesa AT ROW 1.25 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.43 BY .88
     desc-nat-despesa AT ROW 1.25 COL 28.14 COLON-ALIGNED NO-LABEL
     item.ge-codigo AT ROW 2.25 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.29 BY .88
     desc-ge-codigo AT ROW 2.25 COL 26 COLON-ALIGNED NO-LABEL
     item.deposito-pad AT ROW 3.25 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.72 BY .88
     desc-deposito-pad AT ROW 3.25 COL 29.43 COLON-ALIGNED NO-LABEL
     item.fm-codigo AT ROW 4.25 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     desc-fm-codigo AT ROW 4.25 COL 34.57 COLON-ALIGNED NO-LABEL
     cb-tipo-controle-estoque AT ROW 5.38 COL 21.72 COLON-ALIGNED
     cb-tipo-controle-estoq-segur AT ROW 5.38 COL 67.14 COLON-ALIGNED
     item.cod-localiz AT ROW 6.38 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     item.data-ult-ent AT ROW 6.38 COL 67.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.data-ult-sai AT ROW 7.38 COL 67.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.loc-unica AT ROW 7.5 COL 23.72
          VIEW-AS TOGGLE-BOX
          SIZE 21.57 BY .88
     de-var-aprov AT ROW 8.38 COL 67.14 COLON-ALIGNED
     item.fraciona AT ROW 8.5 COL 23.72
          VIEW-AS TOGGLE-BOX
          SIZE 25.29 BY .88
     cb-prioridade AT ROW 9.38 COL 67.14 COLON-ALIGNED
     item.alt-refer AT ROW 9.5 COL 23.72
          VIEW-AS TOGGLE-BOX
          SIZE 29.29 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.item
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT."
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.75
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-prioridade IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-prioridade:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-tipo-controle-estoq-segur IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tipo-controle-estoque IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN de-var-aprov IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       de-var-aprov:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN desc-deposito-pad IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-fm-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-ge-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN desc-nat-despesa IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR TOGGLE-BOX item.loc-unica IN FRAME f-main
   2                                                                    */
/* _RUN-TIME-ATTRIBUTES-END */
&ANALYZE-RESUME


/* Setting information for Queries and Browse Widgets fields            */

&ANALYZE-SUSPEND _QUERY-BLOCK FRAME f-main
/* Query rebuild information for FRAME f-main
     _Options          = "NO-LOCK"
     _Query            is NOT OPENED
*/  /* FRAME f-main */
&ANALYZE-RESUME

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME cb-tipo-controle-estoque
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tipo-controle-estoque V-table-Win
ON VALUE-CHANGED OF cb-tipo-controle-estoque IN FRAME f-main
DO:
   assign i-tipo-contr-estoq = {ininc/i01in122.i 06 cb-tipo-controle-estoque:screen-value in frame {&frame-name}}
          item.alt-refer:sensitive in frame {&frame-name} = if i-tipo-contr-estoq = 4 then yes else no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON F5 OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "inzoom/z01in189.w"
                     &campo=item.cod-localiz
                     &campozoom=cod-localiz}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.deposito-pad
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON F5 OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "inzoom/z01in084.w"
                     &campo=item.deposito-pad
                     &campozoom=cod-depos}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON LEAVE OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  {include/leave.i &tabela=deposito
                   &atributo-ref=nome
                   &variavel-ref=desc-deposito-pad
                   &where="deposito.cod-depos = input frame {&frame-name} item.deposito-pad"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.deposito-pad V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.deposito-pad IN FRAME f-main /* Dep¢sito Padr∆o */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON F5 OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  assign l-implanta = yes.  
  {include/zoomvar.i &prog-zoom= "inzoom/z01in122.w"
                     &campo=item.fm-codigo
                     &campozoom=fm-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON LEAVE OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  {include/leave.i &tabela=familia
                   &atributo-ref=descricao
                   &variavel-ref=desc-fm-codigo
                   &where="familia.fm-codigo = input frame {&frame-name} item.fm-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON LEAVE OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  {include/leave.i &tabela=grup-estoque
                   &atributo-ref=descricao
                   &variavel-ref=desc-ge-codigo
                   &where="grup-estoque.ge-codigo = input frame {&frame-name} item.ge-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.nat-despesa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.nat-despesa V-table-Win
ON F5 OF item.nat-despesa IN FRAME f-main /* Natureza  Despesa */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom= "inzoom/z01in246.w"
                     &campo=item.nat-despesa
                     &campozoom=nat-despesa}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.nat-despesa V-table-Win
ON LEAVE OF item.nat-despesa IN FRAME f-main /* Natureza  Despesa */
DO:
  {include/leave.i &tabela=natureza-despesa
                   &atributo-ref=descricao
                   &variavel-ref=desc-nat-despesa
                   &where="natureza-despesa.nat-despesa = input frame {&frame-name} item.nat-despesa"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.nat-despesa V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.nat-despesa IN FRAME f-main /* Natureza  Despesa */
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
  if item.fm-codigo:load-mouse-pointer    ("image/lupa.cur") in frame {&frame-name} then.
  if item.deposito-pad:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if item.nat-despesa:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
  if item.cod-localiz:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      {utp/ut-liter.i Variaá∆o_Perm. * r}
      assign de-var-aprov:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Prior._Aprov. * r}
      assign cb-prioridade:label in frame {&frame-name} = trim(return-value).
      {utp/ut-liter.i Muito_Alta * r}
      assign c-lista-prioridade = trim(return-value).
      {utp/ut-liter.i Alta * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i MÇdia * r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
      {utp/ut-liter.i Baixa MCE r}
      assign c-lista-prioridade = c-lista-prioridade + " ," + trim(return-value).    
  &endif

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win _ADM-ROW-AVAILABLE
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
  {src/adm/template/row-list.i "item"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "item"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win _DEFAULT-DISABLE
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

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade = entry(4,c-lista-prioridade).
        display cb-prioridade with frame {&frame-name}.
    &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  do  transaction:
      /* Code placed here will execute PRIOR to standard behavior. */
      {include/i-valid.i}
               
      /* Ponha na pi-validate todas as validaá‰es */
      /* N∆o gravar nada no registro antes do dispatch do assign-record e 
         nem na PI-validate. */
      /* Dispatch standard ADM method.                             */

        /**  Melhorias
        **/
        &if defined(bf_mat_aprova_eletronica) &then
            assign input frame {&frame-name} cb-prioridade
                   input frame {&frame-name} de-var-aprov.
        &endif

      RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
      if RETURN-VALUE = 'ADM-ERROR':U then 
         RETURN 'ADM-ERROR':U.

      do  on error undo, leave:
          validate item.
      end.

      if  return-value <> 'ok' and return-value <> '' then do:
          {database/tgin/twp/twin172.i 'show':U}
      end.

      /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */ 
      
      &if defined(bf_mat_tipo_ressup) &then
          for each item-mat-estab where
              item-mat-estab.it-codigo   = item.it-codigo exclusive-lock:
          assign item-mat-estab.fm-codigo = input frame {&FRAME-NAME} item.fm-codigo.
          end.
      &else
      &endif

      assign input frame {&frame-name} cb-tipo-controle-estoque
             item.tipo-con-est = {ininc/i01in122.i 06 cb-tipo-controle-estoque}.
      assign input frame {&frame-name} cb-tipo-controle-estoq-segur
             item.tipo-est-seg = {ininc/i05in122.i 06 cb-tipo-controle-estoq-segur}.
      if  item.fm-codigo <> input frame {&frame-name} item.fm-codigo then do:
          find familia
              where familia.fm-codigo = input frame {&frame-name} item.fm-codigo
              no-lock no-error.
          if  avail familia then do:
              assign item.fm-codigo = input frame {&frame-name} item.fm-codigo.
              run utp/ut-msgs.p (input "show", input 2038, input "").
              if  return-value = "no" then do:
                  apply 'entry' to item.fm-codigo in frame {&frame-name}.
                  return.
              end.
              else
              if  return-value = "yes" then do:
                  assign item.class-fiscal = familia.class-fiscal
                         item.cod-localiz  = familia.cod-localiz
                         item.loc-unica    = familia.loc-unica
                         item.codigo-orig  = familia.codigo-orig
                         item.tipo-con-est = familia.tipo-con-est
                         item.cd-trib-icm  = familia.cd-trib-icm
                         item.deposito-pad = familia.deposito-pad
                         item.cd-trib-ipi  = familia.cd-trib-ipi
                         item.contr-qualid = familia.contr-qualid
                         item.tipo-est-seg = familia.tipo-est-seg
                         item.periodo-fixo = familia.periodo-fixo
                         item.fraciona     = familia.fraciona
                         item.tipo-contr   = familia.tipo-contr
                       /*item.curva-abc    = familia.curva-abc*/
                         item.res-int-comp = familia.res-int-comp
                         item.demanda      = familia.demanda
                         item.res-for-comp = familia.res-for-comp
                         item.emissao-ord  = familia.emissao-ord
                         item.res-cq-comp  = familia.res-cq-comp
                         item.lote-minimo  = familia.lote-minimo
                         item.ressup-fabri = familia.ressup-fabri
                         item.tipo-lote-ec = familia.tipo-lote-ec
                         item.res-cq-fabri = familia.res-cq-fabri
                         item.lote-economi = familia.lote-economi
                         item.tempo-segur  = familia.tempo-segur
                         item.lote-multipl = familia.lote-multipl
                         item.fator-refugo = familia.fator-refugo
                         item.quant-segur  = familia.quant-segur
                         item.politica     = familia.politica
                         item.ciclo-contag = familia.ciclo-contag
                         item.moeda-padrao = familia.moeda-padrao.
              end.
          end.
      end.

      /* Code placed here will execute AFTER standard behavior.    */

      /****** Integraá∆o EMS x SISDOC ******/

      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.

      /******  Multi-Planta  ******/
      assign c-transacao = "MAT007".      
      assign i-tipo-movto = 2.
      run pi-cria-tt-dados (input i-tipo-movto).      
      /**********  Fim  ***********/
      
      /******  Multi-Planta-SMC  ******/
      for each tt-smc-item:
        delete tt-smc-item.
      end.
      
      assign c-transacao = "SMC015".
      {cdp/cd7300.i5 "001" c-transacao "-SMC"}
      
      assign i-tipo-movto = 2.
      run pi-cria-tt-dados-smc (input i-tipo-movto).
      
      {cdp/cd7300.i6 "001" c-transacao "-SMC"}
      /**********  Fim-SMC  ***********/


    /*** excluir registro PEND-ITEM  p/ modulo ESTOQUE ***/

     find first pend-item 
           where pend-item.it-codigo = item.it-codigo
           and   pend-item.modulo    = "MCE" exclusive-lock no-error.
       if  avail pend-item   then delete pend-item.  



    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find item-mat where
            item-mat.it-codigo = item.it-codigo
            exclusive-lock no-error.
        if available item-mat then do:
            assign item-mat.variacao-perm = de-var-aprov.
            case lookup(cb-prioridade,replace(c-lista-prioridade," ,",",")):
                when 1 then assign item-mat.prioridade-aprov = 999.
                when 2 then assign item-mat.prioridade-aprov = 750.
                when 3 then assign item-mat.prioridade-aprov = 450.
                when 4 then assign item-mat.prioridade-aprov = 150.
            end case.
        end.
        release item-mat.
    &endif
    
end.  /* do transaction: */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  /******* Integraá∆o EMS x SISDOC ******/
  if  i-integracao-sisdoc = ? then do:
      RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                  OUTPUT c-handle).
      run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
  end.
  
  if  i-integracao-sisdoc = 2 then
      assign c-opcao-int = "nao-integra".
  if  i-integracao-sisdoc = 3 then
      assign c-opcao-int = "elimina".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

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
  
    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade:sensitive in frame {&frame-name} = no
               de-var-aprov:sensitive  in frame {&frame-name} = no.
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
  if  avail item then do:
      find natureza-despesa where natureza-despesa.nat-despesa = item.nat-despesa  no-lock no-error.
      find grup-estoque     where grup-estoque.ge-codigo       = item.ge-codigo    no-lock no-error.
      find deposito         where deposito.cod-depos           = item.deposito-pad no-lock no-error.
      find familia          where familia.fm-codigo            = item.fm-codigo    no-lock no-error.

      assign desc-nat-despesa  = (if avail natureza-despesa then natureza-despesa.descricao else "":U)
             desc-ge-codigo    = (if avail grup-estoque     then grup-estoque.descricao     else "":U)
             desc-deposito-pad = (if avail deposito         then deposito.nome              else "":U)
             desc-fm-codigo    = (if avail familia          then familia.descricao          else "":U).
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  do  with frame {&frame-name}:
      if  avail item then
          assign cb-tipo-controle-estoque:screen-value     = {ininc/i01in122.i 04 item.tipo-con-est}
                 cb-tipo-controle-estoq-segur:screen-value = {ininc/i05in122.i 04 item.tipo-est-seg}.
      else
          assign cb-tipo-controle-estoque:screen-value     = {ininc/i01in122.i 04 1}
                 cb-tipo-controle-estoq-segur:screen-value = {ininc/i05in122.i 04 1}.
  end.


    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        find item-mat where
            item-mat.it-codigo = item.it-codigo
            no-lock no-error.
        if available item-mat then do:
            display item-mat.variacao-perm @ de-var-aprov with frame {&frame-name}.
            if  item-mat.prioridade-aprov >= 0 and
                item-mat.prioridade-aprov <= 300 then
                assign cb-prioridade = entry(4,c-lista-prioridade).
            if  item-mat.prioridade-aprov >  300 and
                item-mat.prioridade-aprov <= 600 then
                assign cb-prioridade = entry(3,c-lista-prioridade).
            if  item-mat.prioridade-aprov >  600 and
                item-mat.prioridade-aprov <  999 then
                assign cb-prioridade = entry(2,c-lista-prioridade).
            if  item-mat.prioridade-aprov =  999 then
                assign cb-prioridade = entry(1,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
        end.
    &endif

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

  /******* Integraá∆o EMS x SISDOC ******/
  run get-attribute ('adm-new-record').
  if  not adm-new-record then do:
      if  i-integracao-sisdoc = ? then do:
          RUN Who-Is-The-Container IN adm-broker-hdl (INPUT  this-procedure,
                                                      OUTPUT c-handle).
          run pi-atualiza-var in widget-handle(c-handle) (output i-integracao-sisdoc).
      end.
  end.
  /***** Fim Integraá∆o EMS x SISDOC ****/

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "it-codigo").
  if (    not can-find(first saldo-estoq
              where saldo-estoq.it-codigo = return-value)
      and not can-find(first ped-item
              where ped-item.it-codigo     = return-value)
      and not can-find(first preco-item
              where preco-item.it-codigo   = return-value
                and preco-item.situacao    = 1)
      and not can-find(first item-estab
              where item-estab.it-codigo = return-value)
      and not can-find(first item-doc-est
              where item-doc-est.it-codigo = return-value)              
      and not can-find(first it-nota-fisc
              where it-nota-fisc.it-codigo = return-value)) then
      assign cb-tipo-controle-estoque:sensitive in frame {&frame-name} = yes.
  else
      assign cb-tipo-controle-estoque:sensitive in frame {&frame-name} = no.


  assign i-tipo-contr-estoq = {ininc/i01in122.i 06 cb-tipo-controle-estoque:screen-value in frame {&frame-name}}
         item.alt-refer:sensitive in frame {&frame-name} = if i-tipo-contr-estoq = 4 then yes else no.
  if adm-new-record = no
  and (can-find(first movto-estoq use-index item-data 
           where movto-estoq.it-codigo = item.it-codigo) 
  or   can-find(first saldo-estoq use-index item
           where saldo-estoq.it-codigo = item.it-codigo)) then
      assign item.ge-codigo:sensitive in frame {&frame-name} = no.
  else
      assign item.ge-codigo:sensitive in frame {&frame-name} = yes.

    /**  Melhorias
    **/
    &if defined(bf_mat_aprova_eletronica) &then
        assign cb-prioridade:sensitive in frame {&frame-name} = yes
               de-var-aprov:sensitive  in frame {&frame-name} = yes.
        if adm-new-record then do:               
            assign cb-prioridade = entry(4,c-lista-prioridade).
            display cb-prioridade with frame {&frame-name}.
        end.            
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
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:list-items in frame {&frame-name} = c-lista-prioridade.
  &endif
  
  find first param-global no-lock no-error.

  do  with frame {&frame-name}:
      {utp/ut-field.i mgind item tipo-con-est 1}
      assign cb-tipo-controle-estoque:label = trim(return-value).
      {utp/ut-field.i mgind item tipo-est-seg 1}
      assign cb-tipo-controle-estoq-segur:label = trim(return-value).

      assign cb-tipo-controle-estoque:list-items     = {ininc/i01in122.i 03}
             cb-tipo-controle-estoq-segur:list-items = {ininc/i05in122.i 03}.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /**  Melhorias
  **/
  &if defined(bf_mat_aprova_eletronica) &then
      assign cb-prioridade:hidden in frame {&frame-name} = no
             de-var-aprov:hidden  in frame {&frame-name} = no.
  &endif

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    def input parameter i-tipo-movto as integer.
    
    def var h-cdapi150 as handle no-undo.
    
    if  param-global.modulo-mp then do:    
        run cdp/cdapi150.p persistent set h-cdapi150
        (input ?, ?, ?, ?, input-output table tt-erro).    
        
        run pi-gera-log in h-cdapi150 
                          (input "item",
                           input rowid(item),
                           input i-tipo-movto,
                           input c-transacao,
                           input-output table tt-erro).
                  
        &if defined(bf_mat_tipo_ressup) &then
        find item-mat where
             item-mat.it-codigo = item.it-codigo no-lock no-error.
        run pi-gera-log in h-cdapi150 
                          (input "item-mat",
                           input rowid(item-mat),
                           input i-tipo-movto,
                           input c-transacao,
                           input-output table tt-erro).
        &endif         
        run pi-finaliza in h-cdapi150 (input c-transacao).    
        delete procedure h-cdapi150.        
    end.

        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter i-tipo-movto as integer.

    if  param-global.modulo-mp
    and tt-replica-msg-SMC.log-replica-msg  = yes 
    then do:
        create tt-smc-item.
        buffer-copy item to tt-smc-item.
        create tt-dados-env-SMC.
        assign tt-dados-env-SMC.num-sequencia  = i-seq
               tt-dados-env-SMC.cod-tipo-reg   = 3
               tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
               tt-dados-env-SMC.identif-msg    = item.it-codigo.
        raw-transfer tt-smc-item to tt-dados-env-SMC.conteudo-msg.
        assign i-seq = i-seq + 1.
    end.
    
    /*&if defined(bf_mat_tipo_ressup) &then
 *         find item-mat where
 *              item-mat.it-codigo = item.it-codigo no-lock no-error.
 *         create tt-dados-env.
 *         assign tt-dados-env.num-sequencia  = i-seq
 *                tt-dados-env.cod-tipo-reg   = 268
 *                tt-dados-env.ind-tipo-movto = i-tipo-movto
 *                tt-dados-env.identif-msg    = item-mat.it-codigo.
 *         raw-transfer item-mat to tt-dados-env.conteudo-msg.
 *     &endif*/


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-tipo-con-est V-table-Win 
PROCEDURE pi-tipo-con-est :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param i-tipo-contr-aux as int no-undo.


/** Casos em que o tipo de controle era debito direto **/

  
  
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "it-codigo").
  
  if (    not can-find(first saldo-estoq
              where saldo-estoq.it-codigo  = return-value)
      and not can-find(first ped-item
              where ped-item.it-codigo     = return-value)
      and not can-find(first preco-item
              where preco-item.it-codigo   = return-value
                and preco-item.situacao    = 1)
      and not can-find(first it-nota-fisc
              where it-nota-fisc.it-codigo = return-value)
      and not can-find(first item-estab
              where item-estab.it-codigo = return-value)
      and not can-find(first item-doc-est
              where item-doc-est.it-codigo = return-value))
  and (return-value <> "" and i-tipo-contr-aux <> 4) then do  with frame {&frame-name}:
      if i-tipo-contr-aux = 4 then do: 
         assign cb-tipo-controle-estoque:screen-value = {ininc/i01in122.i 04 1}
                i-tipo-contr-estoq = {ininc/i01in122.i 06 cb-tipo-controle-estoque:screen-value in frame {&frame-name}}.
      end.       
      assign cb-tipo-controle-estoque:sensitive in frame {&frame-name} = yes.
      
  end.    
  else do with frame {&frame-name}:
      if i-tipo-contr-aux = 4 then do:
         assign cb-tipo-controle-estoque:screen-value = {ininc/i01in122.i 04 1}
                i-tipo-contr-estoq = {ininc/i01in122.i 06 cb-tipo-controle-estoque:screen-value in frame {&frame-name}}.
      end.
      assign cb-tipo-controle-estoque:sensitive in frame {&frame-name} = no.
  end.    

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

  /** Validaá∆o do campo dep¢sito padr∆o **/
  if (input frame {&frame-name} item.deposito-pad = " ") or
     not can-find( deposito
     where deposito.cod-depos = input frame {&frame-name} item.deposito-pad)
  then do:
     run utp/ut-msgs.p (input "show", input 530, input item.deposito-pad).
     apply 'entry' to item.deposito-pad in frame {&frame-name}.
     return 'ADM-ERROR':U.
  end.   


   
  assign i-tipo-contr-estoq = {ininc/i01in122.i 06 cb-tipo-controle-estoque:screen-value in frame {&frame-name}}.
  if  item.tipo-con-est <> i-tipo-contr-estoq then do:

      /* Verifica integraá∆o com C.Pedidos. Se houver e o item possuir tabela
         de preáo ativa e tipo-con-est = 4, n∆o permitir alteraá∆o deste campo.
         Caso possua tabela ativa e tipo-con-est <> 4, n∆o permitir que o campo
         assuma este valor */

      if (item.tipo-con-est  = 4 and i-tipo-contr-estoq <> 4)
      or (item.tipo-con-est <> 4 and i-tipo-contr-estoq  = 4) then do:

          find first saldo-estoq
              where  saldo-estoq.it-codigo = item.it-codigo no-lock no-error.
          if  avail saldo-estoq then do:
              {include/i-vldprg.i}
              run utp/ut-msgs.p (input "show":U, input 17682, input "").
              apply 'entry' to cb-tipo-controle-estoque in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.

          find first ped-item
              where  ped-item.it-codigo = item.it-codigo no-lock no-error.
          if  avail ped-item then do:
              {include/i-vldprg.i}
              run utp/ut-msgs.p (input "show":U, input 17683, input "").
              apply 'entry' to cb-tipo-controle-estoque in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
          
          find first it-nota-fisc
              where  it-nota-fisc.it-codigo = item.it-codigo no-lock no-error.
          if  avail it-nota-fisc then do:
              {include/i-vldprg.i}
              run utp/ut-msgs.p (input "show":U, input 17681, input "").
              apply 'entry' to cb-tipo-controle-estoque in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.

          find first preco-item
              where  preco-item.it-codigo = item.it-codigo no-lock no-error.
          if  avail preco-item and preco-item.situacao = 1 and l-mod-pd then do:
              {include/i-vldprg.i}
              run utp/ut-msgs.p (input "show":U, input 2300, input "").
              apply 'entry' to cb-tipo-controle-estoque in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.
      end.
  end.
  assign i-saldo = 0
         c-local = ?.

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure,
                                                INPUT "cb-tipo-controle").

  assign i-tipo-contr = {ininc/i09in122.i 06 return-value}.
  if (item.loc-unica entered or item.cod-localiz entered)
  and input frame {&frame-name} item.loc-unica and i-tipo-contr <> 4 then do:

      for each     saldo-estoq
          where    saldo-estoq.it-codigo = item.it-codigo no-lock 
          break by saldo-estoq.cod-localiz:

          if  saldo-estoq.qtidade-atu <> 0 then
              if  saldo-estoq.cod-localiz <> c-local then
                  assign c-local = saldo-estoq.cod-localiz
                         i-saldo = i-saldo + 1.
          if  i-saldo > 1 then leave.
      end.
      if  i-saldo > 1 then do:
          {include/i-vldprg.i}
          run utp/ut-msgs.p (input "show":U, input 2295, input "").
          return 'ADM-ERROR':U.
      end.
      if  item.cod-localiz <> c-local and c-local <> ? then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, input 2296, input c-local).
         apply 'entry' to item.cod-localiz in frame {&frame-name}.
         return 'ADM-ERROR':U.
      end.
  end.
  if  not ((param-global.modulo-co = yes and item.politica  = 5 and i-tipo-contr-estoq = 4)
  or       (param-global.modulo-co = yes and item.politica <> 5)
  or        param-global.modulo-co = no) then do:

      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 5685, input return-value).
      assign cb-tipo-controle-estoque:screen-value =  {ininc/i01in122.i 04 4}.
      disp cb-tipo-controle-estoque with frame {&frame-name}.
      apply "entry" to cb-tipo-controle-estoque in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  find first param-estoq no-lock no-error.
  find localizacao
      where localizacao.cod-estabel = param-estoq.estabel-pad
      and   localizacao.cod-depos   = input frame {&frame-name} item.deposito-pad
      and   localizacao.cod-localiz = input frame {&frame-name} item.cod-localiz
      no-lock no-error.
  if  param-estoq.estab-uni and not avail localizacao then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 6662, input "").
      apply 'entry' to item.cod-localiz in frame {&frame-name}.
      return 'ADM-ERROR':U.
  end.
  if  not param-estoq.estab-uni and not avail localizacao then do:
      find first localizacao
          where  localizacao.cod-depos   = input frame {&frame-name} item.deposito-pad
          and    localizacao.cod-localiz = input frame {&frame-name} item.cod-localiz
          no-lock no-error.
     if  not avail localizacao then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show":U, input 6662, input "").
         apply 'entry' to item.cod-localiz in frame {&frame-name}.
         return 'ADM-ERROR':U.
     end.
  end.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "item"}

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


