&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
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
{include/i-prgvrs.i V07IN404 2.00.00.019}  /*** 010019 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V07IN404 MUT}
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
 
def new global shared var r-componente as rowid no-undo.
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
def var c-conta-ant as char format "x(08)".
def var c-item-ant like item.it-codigo no-undo.
def var c-cod-estabel like estabelec.cod-estabel no-undo.
def new global shared var estab       like saldo-estoq.cod-estabel no-undo.
def new global shared var deposito    like saldo-estoq.cod-depos no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES saldo-terc
&Scoped-define FIRST-EXTERNAL-TABLE saldo-terc


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR saldo-terc.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS saldo-terc.log-1 saldo-terc.cod-depos ~
saldo-terc.cod-localiz 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-depos ~{&FP2}cod-depos ~{&FP3}~
 ~{&FP1}cod-localiz ~{&FP2}cod-localiz ~{&FP3}
&Scoped-define ENABLED-TABLES saldo-terc
&Scoped-define FIRST-ENABLED-TABLE saldo-terc
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS saldo-terc.cod-refer saldo-terc.log-1 ~
saldo-terc.cod-depos saldo-terc.cod-localiz saldo-terc.lote 
&Scoped-Define DISPLAYED-OBJECTS l-baixa-estoque c-ct-codigo c-desc-depos ~
c-desc-local da-dt-vali-lote 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS saldo-terc.cod-refer l-baixa-estoque ~
c-ct-codigo saldo-terc.lote 
&Scoped-define ADM-ASSIGN-FIELDS da-dt-vali-lote 

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
DEFINE VARIABLE c-ct-codigo AS CHARACTER FORMAT "x(17)" 
     LABEL "Conta":R7 
     VIEW-AS FILL-IN 
     SIZE 22 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-depos AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-local AS CHARACTER FORMAT "x(30)" 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE da-dt-vali-lote AS DATE FORMAT "99/99/9999":U 
     VIEW-AS FILL-IN 
     SIZE 14.43 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.29 BY 7.25.

DEFINE VARIABLE l-baixa-estoque AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .79 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     saldo-terc.cod-refer AT ROW 2.25 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     l-baixa-estoque AT ROW 3.17 COL 24.86
     saldo-terc.log-1 AT ROW 3.42 COL 68.86
          VIEW-AS TOGGLE-BOX
          SIZE 8.14 BY .83
     c-ct-codigo AT ROW 3.92 COL 22.86 COLON-ALIGNED
     saldo-terc.cod-depos AT ROW 4.92 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY 1
     c-desc-depos AT ROW 4.92 COL 30.86 COLON-ALIGNED HELP
          "Descriá∆o do Dep¢sito" NO-LABEL
     saldo-terc.cod-localiz AT ROW 5.92 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.14 BY 1
     c-desc-local AT ROW 5.92 COL 37.86 COLON-ALIGNED NO-LABEL
     saldo-terc.lote AT ROW 7 COL 22.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 14.43 BY .88
     da-dt-vali-lote AT ROW 7 COL 47.86 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 2
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.saldo-terc
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
         HEIGHT             = 7.46
         WIDTH              = 85.29.
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

/* SETTINGS FOR FILL-IN c-ct-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN c-desc-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-local IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN saldo-terc.cod-refer IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN da-dt-vali-lote IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR TOGGLE-BOX l-baixa-estoque IN FRAME f-main
   NO-ENABLE 1                                                          */
ASSIGN 
       saldo-terc.log-1:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN saldo-terc.lote IN FRAME f-main
   NO-ENABLE 1                                                          */
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

&Scoped-define SELF-NAME c-ct-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo V-table-Win
ON F5 OF c-ct-codigo IN FRAME f-main /* Conta */
DO:  
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-ct-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-ct-codigo IN FRAME f-main /* Conta */
DO:
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.cod-depos
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-depos V-table-Win
ON F5 OF saldo-terc.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
    assign l-implanta=yes.
 
    {include/zoomvar.i &prog-zoom = "inzoom/z01in084.w"
                       &campo     = saldo-terc.cod-depos
                       &campozoom = cod-depos}
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-depos V-table-Win
ON LEAVE OF saldo-terc.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  {include/leave.i &tabela=deposito
                    &atributo-ref=nome
                    &variavel-ref=c-desc-depos
                    &where="deposito.cod-depos = input frame {&frame-name} saldo-terc.cod-depos}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-depos V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.cod-depos IN FRAME f-main /* Dep¢sito */
DO:
  apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.cod-localiz
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-localiz V-table-Win
ON F5 OF saldo-terc.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").           
  assign c-cod-estabel = return-value
         l-implanta    = yes.
 
 
    &SCOPED-DEFINE estab    c-cod-estabel
    &SCOPED-DEFINE deposito input frame {&FRAME-NAME} saldo-terc.cod-depos
 
    {include/zoom.i
        &prog-zoom   = "inzoom/z01in189.w"
        &tabela      = saldo-terc
        &atributo    = cod-localiz
        &parametros  = "run pi-faixa in wh-pesquisa
                            ({&estab}, {&estab},
                             {&deposito}, {&deposito})."}
 
 
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-localiz V-table-Win
ON LEAVE OF saldo-terc.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").           
  assign c-cod-estabel = return-value.
 
  {include/leave.i &tabela=localizacao
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-local
                   &where="localizacao.cod-localiz = input frame {&frame-name} saldo-terc.cod-localiz and
                           localizacao.cod-estabel = c-cod-estabel and
                           localizacao.cod-depos   = input frame {&frame-name} saldo-terc.cod-depos"}.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-localiz V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.cod-localiz IN FRAME f-main /* Localizaá∆o */
DO:
   apply "F5" to self.
 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.cod-refer
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-refer V-table-Win
ON F5 OF saldo-terc.cod-refer IN FRAME f-main /* Referància */
DO:
    assign l-implanta = yes.
 
    {include/zoomvar.i &prog-zoom = inzoom/z01in377.w
                       &campo     = saldo-terc.cod-refer
                       &campozoom = cod-refer}                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-refer V-table-Win
ON LEAVE OF saldo-terc.cod-refer IN FRAME f-main /* Referància */
DO:         
  {include/leave.i &tabela       = referencia
                   &atributo-ref = cod-refer
                   &variavel-ref = saldo-terc.cod-refer
                   &where        = "referencia.cod-refer = input frame {&frame-name} saldo-terc.cod-refer"}                
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-refer V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.cod-refer IN FRAME f-main /* Referància */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.lote
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.lote V-table-Win
ON F5 OF saldo-terc.lote IN FRAME f-main /* Lote/SÇrie */
DO:
 
   assign l-implanta = yes.
 
   {include/zoomvar.i &prog-zoom = inzoom/z01in190.w
                      &campo     = saldo-terc.lote
                      &campozoom = nr-lote} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.lote V-table-Win
ON LEAVE OF saldo-terc.lote IN FRAME f-main /* Lote/SÇrie */
DO:

RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").
assign c-cod-estabel = trim(return-value).

RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").

do  with frame {&FRAME-NAME}:
    for first saldo-estoq fields (it-codigo cod-estabel lote cod-depos cod-localiz dt-vali-lote)
        where saldo-estoq.it-codigo   = trim(return-value)
          and saldo-estoq.cod-estabel = c-cod-estabel
          and saldo-estoq.lote        = input saldo-terc.lote
          and saldo-estoq.cod-depos   = input saldo-terc.cod-depos
          and saldo-estoq.cod-localiz = input saldo-terc.cod-localiz
    no-lock: end.

    if  avail saldo-estoq then do:
        disp saldo-estoq.dt-vali-lote @ da-dt-vali-lote.
        disable da-dt-vali-lote.
    end.
    else do:
        enable da-dt-vali-lote.
        apply "entry" TO da-dt-vali-lote IN FRAME {&frame-name}.
        return no-apply.
    end.
end.

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.lote V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.lote IN FRAME f-main /* Lote/SÇrie */
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
 
  if saldo-terc.cod-refer:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
 
  if saldo-terc.lote:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
 
  if saldo-terc.cod-localiz:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
 
  if saldo-terc.cod-depos:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
 
  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "saldo-terc"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "saldo-terc"}

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
 
  assign c-item-ant = "".
 
  find first param-global no-lock no-error.
 
  /*if param-global.modulo-cp = yes then
      enable saldo-terc.nr-ord-prod with frame {&frame-name}.
  else do:
      display "" @ saldo-terc.nr-ord-prod with frame {&frame-name}.
      disable saldo-terc.nr-ord-prod with frame {&frame-name}.
  end.*/
 
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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
  assign saldo-ter.cod-depos = input frame {&frame-name} saldo-terc.cod-depos
         saldo-ter.cod-localiz = input frame {&frame-name} saldo-terc.cod-localiz.
 
  find componente where rowid(componente) = r-componente EXCLUSIVE-LOCK NO-ERROR.
  if avail componente
     then assign componente.conta-contabil = input frame {&frame-name} c-ct-codigo
                 componente.lote           = input frame {&frame-name} saldo-terc.lote
                 componente.dt-vali-lote   = input frame {&frame-name} da-dt-vali-lote
                 componente.cod-depos      = saldo-terc.cod-depos
                 componente.cod-localiz    = saldo-terc.cod-localiz
                 componente.baixa-ce       = l-baixa-estoque.
 
 
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
  disable da-dt-vali-lote with frame {&frame-name}.

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
 
  if avail saldo-terc then do:
     find componente where componente.serie-docto = saldo-terc.serie-docto and
                          componente.nro-docto = saldo-terc.nro-docto and
                          componente.cod-emitente = saldo-terc.cod-emitente and
                          componente.nat-operacao = saldo-terc.nat-operacao and
                          componente.it-codigo = saldo-terc.it-codigo and
                          componente.cod-refer = saldo-terc.cod-refer and
                          componente.sequencia = saldo-terc.sequencia 
                          no-lock no-error.
 
     if avail componente then do:
        if not adm-new-record then do:
           assign c-ct-codigo = String(componente.ct-codigo + componente.sc-codigo).
           assign da-dt-vali-lote = componente.dt-vali-lote.       
           display da-dt-vali-lote 
                   c-ct-codigo with frame {&frame-name}.
        end.   
        else
           display ? @ da-dt-vali-lote 
                   "" @ c-ct-codigo with frame {&frame-name}.
 
     end.
     else          
         display ? @ da-dt-vali-lote
                 "" @ c-ct-codigo with frame {&frame-name}.
  end.
 
  find deposito
        where deposito.cod-depos = movto-estoq.cod-depos no-lock no-error.
  if avail deposito
     then assign c-desc-depos = deposito.nome.
     else assign c-desc-depos = "":U.
 
  find localizacao
       where localizacao.cod-localiz = movto-estoq.cod-localiz no-lock no-error.
  if avail localizacao
     then assign c-desc-local = localizacao.descricao.   
     else assign c-desc-local = "":U.
 
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
 
  if adm-new-record = yes then
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif
  
  disable da-dt-vali-lote with frame {&frame-name}.  
  
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
 
  {utp/ut-field.i mgind componente conta-contabil 1}
  assign c-ct-codigo:label in frame {&FRAME-NAME} = trim(return-value).
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-add-record V-table-Win 
PROCEDURE pi-add-record :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
assign c-item-ant = "".
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.
 
     assign v-row-parent = v-row-parent-externo.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cod-refer V-table-Win 
PROCEDURE pi-cod-refer :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-cod-refer like saldo-terc.cod-refer.
 
assign p-cod-refer = input frame {&frame-name} saldo-terc.cod-refer.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-habilita-conta V-table-Win 
PROCEDURE pi-habilita-conta :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter l-sensitive-emitente as logical no-undo.
 
   {utp/ut-liter.i Baixa_Estoque * R}
   assign l-baixa-estoque:label in frame {&frame-name} = return-value.
 
   IF l-sensitive-emitente = yes THEN DO:
 
       enable l-baixa-estoque with frame {&frame-name}. 
 
       find first param-global no-lock no-error.
 
       RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "nr-ord-prod").
 
       if return-value = "0" or
          return-value = "" then do:
 
          enable c-ct-codigo with frame {&frame-name}.
       end.     
       else do:
 
            find first ord-prod where ord-prod.nr-ord-prod = 
                   int(return-value) no-lock no-error.            
            if avail ord-prod then do:
                if avail param-global then do:
                    find first conta-contab where conta-contab.ep-codigo = param-global.empresa-prin and
                               conta-contab.ct-codigo = ord-prod.ct-codigo and
                               conta-contab.sc-codigo = ord-prod.sc-codigo no-lock no-error.
                    if avail conta-contab then
                        assign c-ct-codigo:screen-value in frame {&frame-name} = conta-contab.conta-contabil.
                    else 
                        assign c-ct-codigo:screen-value in frame {&frame-name} = "".  
                end.
            end.
            else     
                display string("") @  c-ct-codigo with frame {&frame-name}.
 
            disable c-ct-codigo with frame {&frame-name}.       
       end. 
 
       RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").           
 
       find last item where item.it-codigo = return-value no-lock no-error.
 
       if avail item then do:
 
           if item.it-codigo <> c-item-ant then do:
 
               if c-ct-codigo:sensitive in frame {&frame-name} = yes then do:
                   if avail param-global then do:
                       find first conta-contab where conta-contab.ep-codigo = param-global.empresa-prin and
                                  conta-contab.ct-codigo = item.ct-codigo and
                                  conta-contab.sc-codigo = item.sc-codigo no-lock no-error.
                       if avail conta-contab then
                           assign c-ct-codigo:screen-value in frame {&frame-name} = conta-contab.conta-contabil.
                       else 
                           assign c-ct-codigo:screen-value in frame {&frame-name} = "".  
                   end.
               end.        
 
               if item.tipo-con-est = 4 then 
                   enable  saldo-terc.cod-refer with frame {&frame-name}.
               else do:
                   assign  saldo-terc.cod-refer:screen-value in frame {&frame-name} = string("").
                   disable saldo-terc.cod-refer with frame {&frame-name}.
               end.
 
               if item.tipo-con-est = 3 or item.tipo-con-est = 4 then do:
                   enable  saldo-terc.lote with frame {&frame-name}.
               end.
               else do: 
                   assign  saldo-terc.lote:screen-value in frame {&frame-name} = "".
                   disable saldo-terc.lote with frame {&frame-name}.    
                   assign  da-dt-vali-lote:screen-value in frame {&frame-name} = ?.
                   disable da-dt-vali-lote with frame {&frame-name}.
               end.       
           end.
 
           assign c-item-ant = item.it-codigo.
       end.        
   END. 
   ELSE
       disable l-baixa-estoque with frame {&frame-name}.
 
 
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
 
   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
   run pi-habilita-conta (input yes).
 
 
   RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "it-codigo").
 
   find first item where item.it-codigo = return-value no-lock no-error.
 
   if avail item then do:
       if /*saldo-terc.cod-refer:sensitive in frame {&frame-name} = yes 
        and*/ item.tipo-con-est = 4 
        then do:
 
          find referencia where referencia.cod-refer = input frame {&frame-name} saldo-terc.cod-refer no-lock no-error.
          if not avail referencia then do:
             {include/i-vldprg.i}
             {utp/ut-table.i mgind referencia 1} 
             run utp/ut-msgs.p (input "show":U, 
                                input 2, 
                                input return-value).
             return 'ADM-ERROR':U.
          end.
          find first saldo-estoq
               where saldo-estoq.it-codigo = item.it-codigo
               and   saldo-estoq.lote      = input frame {&frame-name} saldo-terc.lote
               no-lock no-error.
          if  avail saldo-estoq then do:
              if  saldo-estoq.cod-refer <> input frame {&frame-name} saldo-terc.cod-refer
                  then do:
                  /* Referància n∆o confere com lote */
                  {include/i-vldprg.i}                  
                  run utp/ut-msgs.p (input "show":U, input 1785, input "").
                  return 'ADM-ERROR':U.
              end.  
 
          end.
        end.
 
   end.
 
   if avail item then do:
       if input frame {&frame-name} c-ct-codigo <> "" or
         (item.tipo-contr = 1 or item.tipo-contr = 4) or 
         (input frame {&frame-name} l-baixa-estoque = no) then do:
 
               find first param-global no-lock no-error.
 
               find conta-contab where 
                          conta-contab.ep-codigo      = param-global.empresa-prin   and
                          conta-contab.conta-contabil = input frame {&frame-name} c-ct-codigo no-lock no-error.
 
               if not avail conta-contab then do:
                   {include/i-vldprg.i}
                   {utp/ut-table.i mgadm conta-contab 1} 
                   run utp/ut-msgs.p (input "show":U, input 2, input return-value).
                   return 'ADM-ERROR':U.
               end.                
 
               if conta-contab.estado <> 3  then do:
                   {include/i-vldprg.i}                  
                   run utp/ut-msgs.p (input "show":U, input 638, input frame {&frame-name} c-ct-codigo).
                   return 'ADM-ERROR':U.
               end.        
 
               if conta-contab.estoq = 0 then do:
                   {include/i-vldprg.i}                  
                   run utp/ut-msgs.p (input "show":U, input 5002, input "").
                   return 'ADM-ERROR':U.
               end. 
 
               if not can-do("1,2,4,5", string(conta-contab.tipo)) then do:
                   {include/i-vldprg.i}                  
                   run utp/ut-msgs.p (input "show":U, input 6093, input "").
                   return 'ADM-ERROR':U.
               end.
 
               if not can-do("1,2,5,3,6", string(conta-contab.estoque)) then do:
                   {include/i-vldprg.i}                  
                   run utp/ut-msgs.p (input "show":U, input 1884, input "").
                   return 'ADM-ERROR':U.
               end.   
       end.
   end. /* item */
 
   if (item.tipo-con-est = 3 or item.tipo-con-est = 4) and
   input frame {&frame-name} saldo-terc.lote = "" then do:
      {include/i-vldprg.i}                  
      run utp/ut-msgs.p (input "show":U, input 2158, input "").
      return 'ADM-ERROR':U.
   end.
 
   if (item.tipo-con-est = 3 or item.tipo-con-est = 4) and
   input frame {&frame-name} da-dt-vali-lote = ? then do:
      {include/i-vldprg.i}                  
      run utp/ut-msgs.p (input "show":U, input 8067, input "").
      return 'ADM-ERROR':U.
   end.
 
   find localizacao where
        localizacao.cod-localiz = input frame {&frame-name} saldo-terc.cod-localiz and
        localizacao.cod-depos   = input frame {&frame-name} saldo-terc.cod-depos and
        localizacao.cod-estabel = c-cod-estabel no-lock no-error.
   if not avail localizacao then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 6662, input "").
      apply 'entry' to input frame {&frame-name} saldo-terc.cod-localiz.
      return 'ADM-ERROR':U.     
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
  {src/adm/template/snd-list.i "saldo-terc"}

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


