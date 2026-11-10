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
{include/i-prgvrs.i V35IN172 2.00.01.012 } /*** 010112 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v35in172 MUT}
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
def new global shared var v-log-fam    as logical no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-it-codigo like item.it-codigo.
def var c-fm-codigo like item.fm-codigo no-undo.
def var v-log-adm   as logical initial yes no-undo.
def var v-log-dis   as logical initial yes no-undo.
def var v-log-mnt   as logical initial yes no-undo.
def var v-log-mrp   as logical initial yes no-undo.
def var h-cdapi024  as handle  no-undo.

def temp-table tt-erro-aux no-undo
    field i-sequenc as int
    field cd-erro   as int
    field mensagem  as char format "x(255)".

DEF BUFFER b10-familia FOR familia.

{cdp/cdcfgman.i}
{cdp/cdcfgman.i1} /*** Procedure VerificarConfiguracaoMAN ***/

&IF DEFINED (bf_man_204) &THEN
    def var l-existe as log    no-undo.
    def var h-cd7010 as handle no-undo.

    run cdp/cd7010.p persistent set h-cd7010.
&ENDIF

{cdp/cdcfgmat.i}
{cdp/cdcfgdis.i}

{DATABASE/tgin/twp/twin172.i3 ITEM}

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item.ge-codigo item.fm-codigo item.fm-cod-com ~
item.un item.cod-estabel item.data-implant item.data-liberac 
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS item.ge-codigo item.fm-codigo ~
item.fm-cod-com item.un item.cod-estabel item.data-implant ~
item.data-liberac 
&Scoped-define DISPLAYED-TABLES item
&Scoped-define FIRST-DISPLAYED-TABLE item
&Scoped-Define DISPLAYED-OBJECTS c-grup-estoque c-fm-desc c-fam-com-desc ~
c-un-desc c-nome-estabel CB-COD-OBSOLETO 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS CB-COD-OBSOLETO 

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
DEFINE VARIABLE CB-COD-OBSOLETO AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     DROP-DOWN-LIST
     SIZE 40.57 BY 1 NO-UNDO.

DEFINE VARIABLE c-fam-com-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-fm-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 36.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-grup-estoque AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 39.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-estabel AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.43 BY .88.

DEFINE VARIABLE c-un-desc AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 38.57 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 85.72 BY 7.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.ge-codigo AT ROW 1.17 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     c-grup-estoque AT ROW 1.17 COL 31.57 COLON-ALIGNED NO-LABEL
     item.fm-codigo AT ROW 2.17 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-fm-desc AT ROW 2.17 COL 40.29 COLON-ALIGNED NO-LABEL
     item.fm-cod-com AT ROW 3.17 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     c-fam-com-desc AT ROW 3.17 COL 40.29 COLON-ALIGNED NO-LABEL
     item.un AT ROW 4.17 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-un-desc AT ROW 4.17 COL 33.29 COLON-ALIGNED NO-LABEL
     item.cod-estabel AT ROW 5.17 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-nome-estabel AT ROW 5.17 COL 35.29 COLON-ALIGNED NO-LABEL
     CB-COD-OBSOLETO AT ROW 6.17 COL 27.29 COLON-ALIGNED
     item.data-implant AT ROW 7.29 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     item.data-liberac AT ROW 7.29 COL 63.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     rt-mold AT ROW 1.04 COL 1
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
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.38
         WIDTH              = 85.72.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 7.38
       FRAME f-main:WIDTH            = 85.72.

/* SETTINGS FOR FILL-IN c-fam-com-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-fm-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-grup-estoque IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR COMBO-BOX CB-COD-OBSOLETO IN FRAME f-main
   NO-ENABLE 3                                                          */
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

&Scoped-define SELF-NAME item.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-estabel V-table-Win
ON F5 OF item.cod-estabel IN FRAME f-main /* Estabelecimento Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="adzoom/z01ad107.w"
                     &campo=item.cod-estabel
                     &campozoom=cod-estabel
                     &campo2=c-nome-estabel
                     &campozoom2=nome}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-estabel V-table-Win
ON LEAVE OF item.cod-estabel IN FRAME f-main /* Estabelecimento Padr∆o */
DO:
  {include/leave.i &tabela=estabelec
                    &atributo-ref=nome
                    &variavel-ref=c-nome-estabel
                    &where="estabelec.cod-estabel = input frame {&frame-name} item.cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.cod-estabel IN FRAME f-main /* Estabelecimento Padr∆o */
DO:
   apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.fm-cod-com
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-cod-com V-table-Win
ON F5 OF item.fm-cod-com IN FRAME f-main /* Fam°lia Comercial */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="dizoom/z01di050.w"
                     &campo=item.fm-cod-com
                     &campozoom=fm-cod-com
                     &campo2=c-fam-com-desc
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-cod-com V-table-Win
ON LEAVE OF item.fm-cod-com IN FRAME f-main /* Fam°lia Comercial */
DO:
    if v-log-dis then do:
        run cdp/cd0204j.p (input "find":U,
                           input input frame {&frame-name} item.fm-cod-com,
                           output c-fam-com-desc).

        disp c-fam-com-desc 
             with frame {&frame-name}.
    end.

/****    
  {include/leave.i &tabela=fam-comerc
                    &atributo-ref=descricao
                    &variavel-ref=c-fam-com-desc
                    &where="fam-comerc.fm-cod-com = input frame {&frame-name} item.fm-cod-com"}
 ****/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-cod-com V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.fm-cod-com IN FRAME f-main /* Fam°lia Comercial */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.fm-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON F5 OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z02in122.w"
                     &campo=item.fm-codigo
                     &campozoom=fm-codigo
                     &campo2=c-fm-desc
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON LEAVE OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  def var c-handle as char no-undo. 

  find first familia where familia.fm-codigo = input frame {&frame-name} item.fm-codigo NO-LOCK no-error.
  if adm-new-record = no and adm-adding-record = no then do:
      find first familia where familia.fm-codigo = input frame {&frame-name} item.fm-codigo NO-LOCK no-error.
        if available familia  then do:

         /* Chamada UPC solicitada pela Frame */
        RUN pi-upc (INPUT "OnLeave-familia",
                    INPUT "VIEWER",
                    INPUT ?,
                    INPUT ?,
                    INPUT "familia",
                    INPUT ROWID(familia)).

         {include/leave.i &tabela=familia
                        &atributo-ref=descricao
                        &variavel-ref=c-fm-desc
                        &where="familia.fm-codigo = input frame {&frame-name} item.fm-codigo"}
        END.
  END.
  ELSE DO:
      /* Chamada UPC solicitada pela Frame */
      if avail familia and adm-new-record = yes and adm-adding-record = yes then
         RUN pi-upc (INPUT "OnLeave-familia",
                    INPUT "VIEWER",
                    INPUT ?,
                    INPUT ?,
                    INPUT "familia",
                    INPUT ROWID(familia)).
     {include/leave.i &tabela=familia
                    &atributo-ref=descricao
                    &variavel-ref=c-fm-desc
                    &where="familia.fm-codigo = input frame {&frame-name} item.fm-codigo"}

      if avail familia and adm-new-record = yes and adm-adding-record = yes then do:

         assign item.un:screen-value in frame {&frame-name} = familia.un.  

         RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, INPUT "it-codigo").
         if return-value <> "" then do:
            RUN get-link-handle IN adm-broker-hdl (INPUT this-procedure,
                                                   INPUT 'familia-target',
                                                   OUTPUT c-handle).
            if valid-handle(widget-handle(entry(1,c-handle) )) then do:
               run pi-seta-tipo-cont in widget-handle(entry(1,c-handle)) (input familia.tipo-contr).
               /*1839.176*/
               run pi-seta-lote-economi in widget-handle(entry(1,c-handle)) (input familia.lote-economi).
               /*1839.176*/
               IF param-global.ind-int-agro THEN
                  run pi-seta-idi-classif-item in widget-handle(entry(1,c-handle)) (input familia.idi-classif-item).
            END.
         END.
     end.

  END.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.fm-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.fm-codigo IN FRAME f-main /* Fam°lia */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.ge-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON F5 OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in142.w"
                     &campo=item.ge-codigo
                     &campozoom=ge-codigo
                     &campo2=c-grup-estoque
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON LEAVE OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
   {include/leave.i &tabela=grup-estoque
                    &atributo-ref=descricao
                    &variavel-ref=c-grup-estoque
                    &where="grup-estoque.ge-codigo = input frame {&frame-name} item.ge-codigo"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.ge-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.ge-codigo IN FRAME f-main /* Grupo Estoque */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.un V-table-Win
ON F5 OF item.un IN FRAME f-main /* Unid Medid */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                     &campo=item.un
                     &campozoom=un
                     &campo2=c-un-desc
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.un V-table-Win
ON LEAVE OF item.un IN FRAME f-main /* Unid Medid */
DO:
  {include/leave.i &tabela=tab-unidade
                    &atributo-ref=descricao
                    &variavel-ref=c-un-desc
                    &where="tab-unidade.un = input frame {&frame-name} item.un "}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.un IN FRAME f-main /* Unid Medid */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if item.ge-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if item.fm-codigo:load-mouse-pointer   ("image/lupa.cur") in frame {&frame-name} then.
  if item.fm-cod-com:load-mouse-pointer  ("image/lupa.cur") in frame {&frame-name} then.
  if item.un:load-mouse-pointer          ("image/lupa.cur") in frame {&frame-name} then.
  if item.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.  

  {utp/ut-field.i mgind item cod-obsoleto 1}
  assign cb-cod-obsoleto:label in frame {&frame-name} = return-value.  

  find first param-global NO-LOCK NO-ERROR.

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
  display today @ item.data-implant 
          today @ item.data-liberac
          with frame {&frame-name}.

  assign cb-cod-obsoleto:screen-value in frame {&frame-name} = {ininc/i17in172.i 04 1}.

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

/*   assign c-fm-codigo = input frame {&frame-name} item.fm-codigo. */

  &if defined(bf_mat_tipo_ressup) &then
      for each item-mat-estab where
          item-mat-estab.it-codigo   = item.it-codigo exclusive-lock:
      assign item-mat-estab.fm-codigo = input frame {&FRAME-NAME} item.fm-codigo.
      end.
  &else
  &endif    
         
  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF adm-new-record = YES THEN DO:
         IF CAN-FIND(FIRST funcao
                     WHERE funcao.cd-funcao = "spp-sgt"
                     AND   funcao.ativo = YES)  THEN DO:
            /* Inicio -- Projeto Internacional */
            DEFINE VARIABLE c-lbl-liter-inclusao AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "inclus∆o" *}
            ASSIGN c-lbl-liter-inclusao = TRIM(RETURN-VALUE).
            DEFINE VARIABLE c-lbl-liter-item AS CHARACTER NO-UNDO.
            {utp/ut-liter.i "Item" *}
            ASSIGN c-lbl-liter-item = TRIM(RETURN-VALUE).
            RUN utp/ut-msgs.p (input "show",
                               input 33548,
                               input c-lbl-liter-inclusao + "~~" + c-lbl-liter-item ).
            RETURN 'adm-error'.
        END.
     END.
  &endif.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.

  /* Variaveis utilizadas na integraá∆o EMS2/NEOLOG */
  {cdp/cdapi090def.i}

  IF adm-new-record THEN DO:
     /* Include respons†vel pela envio de dados do EMS2 ao NEOLOG */
     {cdp/cdapi090.i CREATE item}
  END.
  ELSE DO:
     {cdp/cdapi090.i UPSERT item}
  END.

  IF ADM-NEW-RECORD THEN DO:

      &if "{&bf_dis_versao_ems}" >= "2.062":U &THEN
          FIND FIRST fam-uni-estab
              WHERE fam-uni-estab.fm-codigo   = input frame {&FRAME-NAME} item.fm-codigo
              AND   fam-uni-estab.cod-estabel = INPUT FRAME {&FRAME-NAME} ITEM.cod-estabel NO-LOCK NO-ERROR.
          IF AVAIL fam-uni-estab
          THEN DO:
              ASSIGN ITEM.cod-unid-negoc = fam-uni-estab.cod-unid-negoc.

              RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.
              RUN ValidaUnidadeNegocioEstabel IN h-cdapi024 (INPUT FRAME {&FRAME-NAME} ITEM.cod-estabel,
                                                             INPUT TODAY,
                                                             INPUT fam-uni-estab.cod-unid-negoc,
                                                             OUTPUT TABLE tt-erro-aux).
              DELETE PROCEDURE h-cdapi024.

              IF CAN-FIND(FIRST tt-erro-aux) THEN
                 ASSIGN ITEM.cod-unid-negoc = "".
          END.

      &ENDIF
  END.
  
  /* Code placed here will execute AFTER standard behavior.    */

  if  v-log-fam = YES THEN do:

        /*** c¢pia dos dados da fam°lia para o item. ***/

           FIND FIRST b10-familia WHERE b10-familia.fm-codigo = input frame {&FRAME-NAME} item.fm-codigo NO-ERROR.

       IF AVAIL b10-familia THEN DO:
             IF fn-permite-alteracao-un() = NO THEN DO:
                if b10-familia.fm-codigo = item.fm-codigo and b10-familia.un <> input frame {&frame-name} item.un then do:
                    run utp/ut-msgs.p (input "show", 
                                       input 28520, 
                                       input "").            

                    apply "ENTRY" to item.fm-codigo.
                  end.
                  buffer-copy b10-familia EXCEPT fm-codigo log-1 tipo-con-est tipo-contr char-2 un to item. 
                  ASSIGN OVERLAY(item.char-2,188,12) = SUBSTR(b10-familia.char-2,188,12)
                         OVERLAY(item.char-2,88,12)  = SUBSTR(b10-familia.char-2,88,12).

              END.
              ELSE DO:
                  buffer-copy b10-familia EXCEPT fm-codigo log-1 tipo-contr char-2 to item.
                  ASSIGN OVERLAY(item.char-2,188,12) = SUBSTR(b10-familia.char-2,188,12)
                         OVERLAY(item.char-2,88,12)  = SUBSTR(b10-familia.char-2,88,12).
              END.

          ASSIGN ITEM.class-fiscal = b10-familia.class-fiscal.

           end.


           assign item.reporte-ggf  = (2 - int (familia.log-1)).

           find classif-fisc
            where classif-fisc.class-fiscal = b10-familia.class-fiscal
            no-lock no-error.

            if available classif-fisc then
                    assign item.aliquota-ipi       = classif-fisc.aliquota-ipi.
            if familia.niv-rest-icms = "" then assign item.niv-rest-icms = "1".

            &if "{&bf_mat_versao_ems}" >= "2.062" &then
                if avail item and i-pais-impto-usuario = 1 then do:
                    find familia-mat where
                        familia-mat.fm-codigo = item.fm-codigo no-lock no-error.
                    if avail familia-mat then do: 
                        for first item-mat where item-mat.it-codigo = item.it-codigo exclusive-lock:
                            assign item-mat.cod-familia-impto = familia-mat.cod-familia-impto.
                        end.
                    end.
                end.
            &endif
            
         IF i-pais-impto-usuario = 17 THEN DO:
            RUN local/col/col108.p (INPUT INPUT FRAME {&FRAME-NAME} ITEM.fm-codigo,
                                    INPUT ROWID(ITEM)).
         END.

      end.

      /* Quando incluir o item deve inicializar a classificaá∆o ABC com a opá∆o C*/
      if  adm-new-record then 
          assign item.classif-abc = 3.    

      /****************** SEF 2 REPLICAÄ«O ******************/

      IF CAN-FIND(FIRST estabelec WHERE estabelec.estado = "PE") THEN
          IF NOT CAN-FIND(FIRST sef-item WHERE sef-item.cod-item = item.it-codigo) THEN DO:
                CREATE sef-item.
                ASSIGN sef-item.cod-item            = ITEM.it-codigo.
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

 /* assign input frame {&frame-name} cb-cod-obsoleto. */

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*  assign item.cod-obsoleto = {ininc/i17in172.i 06 cb-cod-obsoleto}.*/

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

   assign item.data-implant:screen-value in frame {&frame-name} = string(today)
          item.data-liberac:screen-value in frame {&frame-name} = string(today).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

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

  &IF DEFINED (bf_man_204) &THEN
    delete procedure h-cd7010.
  &ENDIF

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

  if available item then do:
     find grup-estoque where grup-estoque.ge-codigo = item.ge-codigo no-lock no-error.
     assign c-grup-estoque = if avail grup-estoque then grup-estoque.descricao else "":U.

     find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
     assign c-fm-desc = if avail familia then familia.descricao else "":U.

     find tab-unidade where tab-unidade.un = item.un no-lock no-error.
     assign c-un-desc = if avail tab-unidade then tab-unidade.descricao else "":U.

     find estabelec where estabelec.cod-estabel = item.cod-estabel no-lock no-error.
     assign c-nome-estabel = if avail estabelec then estabelec.nome else "":U.

     if v-log-dis then do:
         run cdp/cd0204j.p (input "find":U,
                            input item.fm-cod-com,
                            output c-fam-com-desc).


     /******
     find fam-comerc where fam-comerc.fm-cod-com = item.fm-cod-com no-lock no-error.
     assign c-fam-com-desc = if avail fam-comerc then fam-comerc.descricao else "":U.
      ******/

     end.
  end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

/*  if avail item 
 *   and item.cod-obsoleto <> 0 then do:
 *      assign cb-cod-obsoleto:screen-value in frame {&frame-name} = {ininc/i17in172.i 04 item.cod-obsoleto}.
 *   end.
 *   else do:
 *      assign cb-cod-obsoleto:screen-value in frame {&frame-name} = {ininc/i17in172.i 04 1}.
 *   end.*/

if avail item then 
   assign cb-cod-obsoleto:screen-value in frame {&frame-name} = {ininc/i17in172.i 04 item.cod-obsoleto}.

else 
   assign cb-cod-obsoleto:screen-value in frame {&frame-name} = {ininc/i17in172.i 04 1}.

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

   ASSIGN c-fm-codigo = ITEM.fm-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

   /* Code placed here will execute PRIOR to standard behavior. */
   run get-attribute ('adm-new-record').
   
   &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
       IF adm-new-record = NO THEN DO:

          IF CAN-FIND(FIRST funcao
                      WHERE funcao.cd-funcao = "spp-sgt"
                      AND   funcao.ativo = YES)  THEN DO:
             DISABLE ITEM.un WITH FRAME f-main.
          END.
       END.
   &endif.


   /* Code placed here will execute AFTER standard behavior.    */
   &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
   &endif

   /* Dispatch standard ADM method.                             */
   RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .


   if param-global.modulo-pd = no then 
      assign item.fm-cod-com:sensitive in frame {&frame-name} = no.

   if adm-new-record = no 
   and (can-find (first movto-estoq use-index item-data 
                  where movto-estoq.it-codigo = item.it-codigo) 
   or   can-find (first saldo-estoq use-index item
                  where saldo-estoq.it-codigo = item.it-codigo)) then
      assign item.ge-codigo:sensitive in frame {&frame-name} = no.
   else 
      assign item.ge-codigo:sensitive in frame {&frame-name} = yes.


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
   &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
       DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
       ASSIGN cAuxTraducao001 = {ininc/i17in172.i 03}.
       RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao001).
       ASSIGN  cb-cod-obsoleto:LIST-ITEM-PAIRS in frame {&frame-name} = cAuxTraducao001.
   &else
       ASSIGN cb-cod-obsoleto:list-items in frame {&frame-name} = {ininc/i17in172.i 03}.
   &endif

   run VerificarConfiguracaoMAN (output v-log-adm,
                                 output v-log-dis,
                                 output v-log-mnt,
                                 output v-log-mrp). 


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
   {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */
   ASSIGN v-log-fam = NO.
   
   
   /******Verifica integraá∆o HIS**********/
  IF CAN-FIND (FIRST funcao 
                 WHERE funcao.cd-funcao = "spp-integra-ems-his"
                 AND   funcao.ativo     = YES) THEN DO:

      FIND FIRST grup-estoque NO-LOCK
           WHERE grup-estoque.ge-codigo = INPUT FRAME {&FRAME-NAME} ITEM.ge-codigo NO-ERROR.
      &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          
          IF grup-estoque.log-orig-ext = YES AND (AVAIL ITEM AND ITEM.log-orig-ext = NO) THEN DO:
    
             /* Inicio -- Projeto Internacional */
             DEFINE VARIABLE c-lbl-liter-grupo-de-estoque-deve-ser-alte AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Grupo_de_estoque_deve_ser_alterado" *}
             ASSIGN c-lbl-liter-grupo-de-estoque-deve-ser-alte = TRIM(RETURN-VALUE).
             DEFINE VARIABLE c-lbl-liter-grupo-de-estoque-nao-pode-ser AS CHARACTER NO-UNDO.
             {utp/ut-liter.i "Grupo_de_Estoque_n∆o_pode_ser_relacionado_ao_item,_pois_pertence_ao_Sistema_Hospitalar" *}
             ASSIGN c-lbl-liter-grupo-de-estoque-nao-pode-ser = TRIM(RETURN-VALUE).
             RUN utp/ut-msgs.p (INPUT "show",
                                INPUT 17006,
                                INPUT c-lbl-liter-grupo-de-estoque-deve-ser-alte + "~~" + c-lbl-liter-grupo-de-estoque-nao-pode-ser ).
             apply "ENTRY" to item.un.
             RETURN 'adm-error'.
          END.
      &ELSE
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            IF grup-estoque.log-1 = YES AND (AVAIL ITEM AND TRIM(SUBSTR(ITEM.CHAR-1,267,1)) <> "S") THEN DO:
    
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-ge-alterado AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Grupo_de_estoque_deve_ser_alterado" *}
                ASSIGN c-lbl-liter-ge-alterado = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-ge-relac AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Grupo_de_Estoque_n∆o_pode_ser_relacionado_ao_item,_pois_pertence_ao_Sistema_Hospitalar" *}
                ASSIGN c-lbl-liter-ge-relac = TRIM(RETURN-VALUE).
                RUN utp/ut-msgs.p (INPUT "show",
                                   INPUT 17006,
                                   INPUT c-lbl-liter-ge-alterado + "~~" + c-lbl-liter-ge-relac ).
                apply "ENTRY" to item.un.
                RETURN 'adm-error'.
            END.
          &ENDIF
      &ENDIF 
  END.
  /***************************************/
   if input frame {&frame-name} item.data-implant > today then do: 
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show", input 2566, input "").
      apply 'entry' to item.data-implant in frame {&frame-name}.
      return 'adm-error':U.
   end.

   if input frame {&frame-name} item.data-liberac < 
      input frame {&frame-name} item.data-implant then do: 
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show", input 2565, input "").
      apply 'entry' to item.data-liberac in frame {&frame-name}.
      return 'adm-error':U.
   end.

   FIND FIRST familia WHERE familia.fm-codigo = item.fm-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} NO-LOCK NO-ERROR.
   IF AVAIL familia THEN DO:
       FIND FIRST deposito WHERE deposito.cod-depos  = familia.deposito-pad NO-LOCK NO-ERROR.
       IF NOT AVAIL deposito THEN DO:
           {include/i-vldprg.i}
           run utp/ut-msgs.p (input "show", input 28627, input "").
           IF RETURN-VALUE = "no" THEN
              return 'adm-error':U.
       END.
   END.

    if  adm-new-record = no 
    and item.fm-codigo <> item.fm-codigo:SCREEN-VALUE IN FRAME {&FRAME-NAME} then do:

        run utp/ut-msgs.p (input "show", 
                           input 2805, 
                           input "").
        if return-value = "yes" then ASSIGN v-log-fam = YES.
            IF RETURN-VALUE = "no" THEN ASSIGN v-log-fam = NO.

    end.


   &IF DEFINED (bf_man_204) &THEN
       RUN set-cursor IN adm-broker-hdl (INPUT "wait":U).
       if adm-new-record =  no then do:
           if item.fm-codigo <> item.fm-codigo:screen-value in frame {&frame-name} then do:

               for each item-uni-estab where
                        item-uni-estab.it-codigo = item.it-codigo no-lock:

                   run pi-mov-estab in h-cd7010 (input  item-uni-estab.it-codigo,
                                                 input  item-uni-estab.cod-estabel,
                                                 output l-existe).

                   if l-existe then do:
                       if not can-find (first fam-uni-estab where
                                              fam-uni-estab.fm-codigo   = item.fm-codigo:screen-value in frame {&frame-name} and
                                              fam-uni-estab.cod-estabel = item-uni-estab.cod-estabel) then do:
                            run utp/ut-msgs.p (input "show", 
                                               input 26435, 
                                               input item.fm-codigo:screen-value in frame {&frame-name} + "~~" + item-uni-estab.cod-estabel).
                            return 'adm-error':U.
                       end.
                   end.
               end.
           end.
       end.
       RUN set-cursor IN adm-broker-hdl (INPUT "").       
   &ENDIF
   
   /******Verificaá∆o Integra HIS******/

   &IF '{&bf_mat_versao_ems}':U >= '2.062':U &THEN
   IF CAN-FIND(FIRST funcao
               WHERE funcao.cd-funcao = "spp-integra-ems-his":U
               AND   funcao.ativo     = YES) THEN DO:
       
       FIND FIRST grup-estoque
            WHERE grup-estoque.ge-codigo = INPUT FRAME {&FRAME-NAME} ITEM.ge-codigo NO-LOCK NO-ERROR.
       IF AVAIL grup-estoque THEN DO:
           &IF '{&bf_mat_versao_ems}':U >= '2.08':U &THEN
           IF grup-estoque.log-orig-ext THEN DO:
           &ELSE
           IF grup-estoque.log-1 THEN DO:       
           &ENDIF
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-item-ge-his AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Item_com_Grupo_de_Estoque_do_HIS" *}
               ASSIGN c-lbl-liter-item-ge-his = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-itens-ge-sh AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Itens_com_Grupo_de_Estoque_do_HIS_somente_poder∆o_ser_cadastrados_atravÇs_do_sistema_hospitalar" *}
               ASSIGN c-lbl-liter-itens-ge-sh = TRIM(RETURN-VALUE).
               RUN utp/ut-msgs.p(INPUT 'show':U,
                                 INPUT 17006,
                                 INPUT c-lbl-liter-item-ge-his + "~~" + c-lbl-liter-itens-ge-sh + '.').
               RETURN "ADM-ERROR":U.
           END.
       END.
       
       FIND FIRST familia
            WHERE familia.fm-codigo = INPUT FRAME {&FRAME-NAME} ITEM.fm-codigo NO-LOCK NO-ERROR.
       IF AVAIL familia THEN DO:
           &IF '{&bf_mat_versao_ems}':U >= '2.08':U &THEN
           IF familia.log-orig-ext THEN DO:
           &ELSE
           IF TRIM(SUBSTRING(familia.char-1,154,1)) = "S":U THEN DO:
           &ENDIF
               /* Inicio -- Projeto Internacional */
               DEFINE VARIABLE c-lbl-liter-item-fm-his AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Item_com_Fam°lia_do_HIS" *}
               ASSIGN c-lbl-liter-item-fm-his = TRIM(RETURN-VALUE).
               DEFINE VARIABLE c-lbl-liter-itens-fm-sh AS CHARACTER NO-UNDO.
               {utp/ut-liter.i "Itens_com_Fam°lia_do_HIS_somente_poder∆o_ser_cadastrados_atravÇs_do_sistema_hospitalar" *}
               ASSIGN c-lbl-liter-itens-fm-sh = TRIM(RETURN-VALUE).
               RUN utp/ut-msgs.p(INPUT 'show':U,
                                 INPUT 17006,
                                 INPUT c-lbl-liter-item-fm-his + "~~" + c-lbl-liter-itens-fm-sh + '.').
               RETURN "ADM-ERROR":U.
           END.
       END.

   END.
   &ENDIF

   /******Verificaá∆o Integra HIS******/

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

