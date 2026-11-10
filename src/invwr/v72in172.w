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
{include/i-prgvrs.i V72IN172 2.00.00.009}  /*** 010009 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V72IN172 MUT}
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
def new global shared var g-rw-item   as rowid no-undo.

/************* Multi-Planta *******************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical no-undo.
{cdp/cd0669.i}
{cdp/cd7300.i1}
/****************** Fim ***********************/

def var l-codigo-orig     as logical no-undo.
def var l-cd-trib-icm     as logical no-undo.
def var l-cd-trib-ipi     as logical no-undo.
def var l-baixa-estoq     as logical no-undo.
def var l-fraciona        as logical no-undo.
def var l-perm-saldo-neg  as logical no-undo.
def var l-class-fiscal    as logical no-undo.
def var l-gera-log        as logical no-undo.
def var c-handle          as char no-undo.

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
&Scoped-Define ENABLED-FIELDS item.codigo-orig item.baixa-estoq ~
item.fraciona item.class-fiscal 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}codigo-orig ~{&FP2}codigo-orig ~{&FP3}~
 ~{&FP1}class-fiscal ~{&FP2}class-fiscal ~{&FP3}
&Scoped-define ENABLED-TABLES item
&Scoped-define FIRST-ENABLED-TABLE item
&Scoped-Define ENABLED-OBJECTS rt-key RECT-8 rt-mold-2 rect-12 
&Scoped-Define DISPLAYED-FIELDS item.it-codigo item.desc-item ~
item.codigo-orig item.baixa-estoq item.fraciona item.class-fiscal 
&Scoped-Define DISPLAYED-OBJECTS cb-perm-saldo-neg fi-desc-class-fisc ~
cb-cd-trib-icm cb-cd-trib-ipi 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS cb-perm-saldo-neg 
&Scoped-define ADM-MODIFY-FIELDS item.baixa-estoq cb-perm-saldo-neg ~
item.fraciona 

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
DEFINE VARIABLE cb-cd-trib-icm AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo ICMS":R26 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-cd-trib-ipi AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "C¢digo Tributa‡Æo IPI":R25 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE cb-perm-saldo-neg AS CHARACTER FORMAT "X(256)" INITIAL "1" 
     LABEL "Saldo Neg":R11 
     VIEW-AS COMBO-BOX INNER-LINES 5
     LIST-ITEMS "0" 
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE fi-desc-class-fisc AS CHARACTER FORMAT "X(35)":U 
     VIEW-AS FILL-IN 
     SIZE 41.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rect-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.14 BY 3.63.

DEFINE RECTANGLE RECT-8
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 48.29 BY 2.63.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 87.14 BY 1.25.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 38.14 BY 2.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item.it-codigo AT ROW 1.21 COL 7 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     item.desc-item AT ROW 1.21 COL 24.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 60 BY .88
     item.codigo-orig AT ROW 2.67 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     item.baixa-estoq AT ROW 2.67 COL 56.43
          VIEW-AS TOGGLE-BOX
          SIZE 19 BY .75
     cb-perm-saldo-neg AT ROW 3.67 COL 26 COLON-ALIGNED HELP
          "Permite parametrizar o Tipo de Saldo"
     item.fraciona AT ROW 3.67 COL 56.43
          VIEW-AS TOGGLE-BOX
          SIZE 27.43 BY .75
     item.class-fiscal AT ROW 5.5 COL 26 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     fi-desc-class-fisc AT ROW 5.5 COL 39.72 COLON-ALIGNED NO-LABEL
     cb-cd-trib-icm AT ROW 6.5 COL 26 COLON-ALIGNED
     cb-cd-trib-ipi AT ROW 7.63 COL 26 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     RECT-8 AT ROW 2.42 COL 1
     rt-mold-2 AT ROW 2.42 COL 50
     rect-12 AT ROW 5.25 COL 1
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
         HEIGHT             = 7.88
         WIDTH              = 87.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R, COLUMNS                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR TOGGLE-BOX item.baixa-estoq IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR COMBO-BOX cb-cd-trib-icm IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-icm:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-cd-trib-ipi IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       cb-cd-trib-ipi:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR COMBO-BOX cb-perm-saldo-neg IN FRAME f-main
   NO-ENABLE 2 3                                                        */
ASSIGN 
       item.class-fiscal:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR FILL-IN item.desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-desc-class-fisc IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       fi-desc-class-fisc:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX item.fraciona IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN item.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
ASSIGN 
       rect-12:HIDDEN IN FRAME f-main           = TRUE.

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

&Scoped-define SELF-NAME item.class-fiscal
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON F5 OF item.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
  l-implanta = yes.
  {include/zoom.i &prog-zoom="inzoom/z01in046.w" 
                  &tabela=item
                  &atributo=class-fiscal}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON LEAVE OF item.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
DO:
    {include/leave.i &tabela=classif-fisc
                     &atributo-ref=descricao
                     &variavel-ref=fi-desc-class-fisc
                     &where="classif-fisc.class-fiscal = input frame {&frame-name} mgind.item.class-fiscal"}

  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item.class-fiscal V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item.class-fiscal IN FRAME f-main /* Classifica‡Æo Fiscal */
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
  
  if item.class-fiscal:load-mouse-pointer ("Image\lupa.cur") in frame 
     {&frame-name} then.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  do with frame {&FRAME-NAME}:
    assign cb-cd-trib-icm 
           cb-cd-trib-ipi 
           cb-perm-saldo-neg.
  end.       

  if input frame {&frame-name} item.class-fiscal:hidden = no then do:
    find first classif-fisc where input frame {&frame-name} item.class-fiscal =
         classif-fisc.class-fiscal no-lock no-error. 
    if not avail classif-fisc or 
       input frame {&frame-name} item.class-fiscal = " " then do:
       run utp/ut-msgs.p (input "show",
                          input 5670,
                          input " ").
       return 'ADM-ERROR':U.
    end.                       
  end.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if RETURN-VALUE = 'ADM-ERROR':U then 
     RETURN 'ADM-ERROR':U.
  
  assign item.cd-trib-icm    = {ininc/i07in122.i 06 cb-cd-trib-icm}
         item.perm-saldo-neg = {ininc/i11in122.i 06 cb-perm-saldo-neg}
         item.cd-trib-ipi    = {ininc/i10in172.i 06 cb-cd-trib-ipi}.
  
    /******************* Multi-Planta *********************/
    assign c-transacao = "MAT040".      
    assign i-tipo-movto = 2.      
    run pi-cria-tt-dados (input i-tipo-movto).
    /*********************** Fim *************************/
         

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
  
  find item where rowid(item) = g-rw-item no-lock no-error.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  if avail familia then do with frame {&frame-name}:
     if l-baixa-estoq then
        assign item.baixa-estoq:checked       = familia.baixa-estoq.
     if l-class-fiscal then
        assign item.class-fiscal:screen-value = familia.class-fiscal.
     if l-codigo-orig then
        assign item.codigo-orig:screen-value  = string(familia.codigo-orig).
     if l-fraciona then
        assign item.fraciona:checked          = familia.fraciona.
     if l-cd-trib-icm then
        assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 familia.cd-trib-icm}.
     else 
        assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i 04 item.cd-trib-icm}.
     if l-perm-saldo-neg then
        assign cb-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 familia.perm-saldo-neg}.  
     else
        assign cb-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 item.perm-saldo-neg}.  
     
     if l-cd-trib-ipi then
        assign cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 familia.cd-trib-ipi}. 
     else
        assign cb-cd-trib-ipi:screen-value = {ininc/i10in172.i 04 item.cd-trib-ipi}. 
     
  end.
  else do:
     assign cb-cd-trib-icm:screen-value = {ininc/i07in122.i    04 1}
            cb-perm-saldo-neg:screen-value = {ininc/i11in122.i 04 1}
            cb-cd-trib-ipi:screen-value = {ininc/i10in172.i    04 1}.
  end.      
  find classif-fisc
        where classif-fisc.class-fiscal = input frame {&FRAME-NAME} item.class-fiscal no-lock no-error.
  if  avail classif-fisc then
      assign fi-desc-class-fisc:screen-value = classif-fisc.descricao.

  
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
  run get-attribute ('adm-new-record').
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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
  find item where rowid(item) = g-rw-item no-lock no-error.
  find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
  do with frame {&frame-name}:
    assign cb-cd-trib-icm:list-items    = {ininc/i07in122.i 03}.
    assign cb-perm-saldo-neg:list-items = {ininc/i11in122.i 03}.
    assign cb-cd-trib-ipi:list-items    = {ininc/i10in172.i 03}. 
  end. 

RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT this-procedure,
     OUTPUT c-handle).
if valid-handle(widget-handle(c-handle))    then 
    RUN pi-passa-parametros IN widget-handle(c-handle)
        (OUTPUT l-codigo-orig ,
         OUTPUT l-cd-trib-icm ,
         OUTPUT l-cd-trib-ipi ,
         OUTPUT l-baixa-estoq ,
         OUTPUT l-fraciona ,
         OUTPUT l-perm-saldo-neg ,
         OUTPUT l-class-fiscal).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  RUN dispatch IN THIS-PROCEDURE ('enable-fields':U).
  
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

find first param-global no-lock no-error.

if  param-global.modulo-mp then do:
    run cdp/cdapi150.p (input "item",
                        input rowid(item),
                        input i-tipo-movto,
                        input c-transacao,
                        input-output table tt-erro).
end.

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
   
   /*Segue um exemplo de valida‡Æo de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/
 
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


