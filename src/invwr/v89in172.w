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
{include/i-prgvrs.i V89IN172 2.00.00.016} /*** "010016" 08/04/2024 14:38:46  ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v89in172 MUT}
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

{cdp/cdcfgmat.i}

/* Local Variable Definitions ---                                       */
def var i-sd-qt    as integer no-undo.
def var i-med-qt   as integer no-undo.
def var i-atual-qt as integer no-undo.
def var i-seg-qt   as integer no-undo.

def var l-achou          as logical no-undo.
def var de-cons-prev     as decimal no-undo.
def var de-consumo-prev  as decimal no-undo.
def var c-estab          as char    no-undo.

{cdp/cdcfgdis.i}

DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.

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
&Scoped-define EXTERNAL-TABLES item
&Scoped-define FIRST-EXTERNAL-TABLE item


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR item.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-4 
&Scoped-Define DISPLAYED-OBJECTS de-consumo i-tempo de-lote-eco de-giro ~
c-abc de-est de-real c-quantidade c-per-1 c-dia c-per-2 

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
DEFINE VARIABLE c-abc AS CHARACTER FORMAT "X(03)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE c-dia AS CHARACTER FORMAT "X(08)":U 
      VIEW-AS TEXT 
     SIZE 8 BY .67 NO-UNDO.

DEFINE VARIABLE c-per-1 AS CHARACTER FORMAT "X(04)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE c-per-2 AS CHARACTER FORMAT "X(04)":U 
      VIEW-AS TEXT 
     SIZE 4 BY .67 NO-UNDO.

DEFINE VARIABLE c-quantidade AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE de-consumo AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-est AS DECIMAL FORMAT "ZZZ999-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE de-giro AS DECIMAL FORMAT "ZZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE de-lote-eco AS DECIMAL FORMAT ">>>>,>>9.9999":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 16.72 BY .88 NO-UNDO.

DEFINE VARIABLE de-real AS DECIMAL FORMAT "ZZZ9.99-":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE i-tempo AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 11.57 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.43 BY 7.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     de-consumo AT ROW 2.25 COL 17.86 COLON-ALIGNED
     i-tempo AT ROW 2.25 COL 58.57 COLON-ALIGNED
     de-lote-eco AT ROW 3.25 COL 17.86 COLON-ALIGNED
     de-giro AT ROW 3.25 COL 58.43 COLON-ALIGNED
     c-abc AT ROW 4.25 COL 58.43 COLON-ALIGNED
     de-est AT ROW 5.25 COL 58.43 COLON-ALIGNED
     de-real AT ROW 6.25 COL 58.43 COLON-ALIGNED
     c-quantidade AT ROW 1.42 COL 23 COLON-ALIGNED NO-LABEL
     c-per-1 AT ROW 3.42 COL 68 COLON-ALIGNED NO-LABEL
     c-dia AT ROW 5.42 COL 69.14 COLON-ALIGNED NO-LABEL
     c-per-2 AT ROW 6.42 COL 68.14 COLON-ALIGNED NO-LABEL
     RECT-4 AT ROW 1.08 COL 1.29
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
         HEIGHT             = 7.75
         WIDTH              = 86.
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

/* SETTINGS FOR FILL-IN c-abc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-dia IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-per-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-per-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-quantidade IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-consumo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-est IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-giro IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-lote-eco IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN de-real IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN i-tempo IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/
  find first param-estoq no-lock no-error.

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  {include/i-valid.i}
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
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

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-sd-qt").
  assign i-sd-qt = integer(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-med-qt").
  assign i-med-qt = integer(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-atual-qt").
  assign i-atual-qt = integer(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-seg-qt").
  assign i-seg-qt = integer(return-value).  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  run pi-calcula.

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

  {utp/ut-liter.i Quantidade * R}
  assign c-quantidade = return-value.

  {utp/ut-liter.i Consumo_Previsto * L}
  assign de-consumo:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Lote_Econ“mico * L}
  assign de-lote-eco:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Tempo_Seguran‡a * L}
  assign i-tempo:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Giro * L}
  assign de-giro:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Classe_ABC * L}
  assign c-abc:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Estoque_para * L}
  assign de-est:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i J _Realizado * L}
  assign de-real:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i dia(s) * L}
  assign c-dia = return-value.

  assign c-per-1 = "%"
         c-per-2 = "%".

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-sd-qt").
  assign i-sd-qt = integer(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-med-qt").
  assign i-med-qt = integer(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-atual-qt").
  assign i-atual-qt = integer(return-value).

  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure, INPUT "de-seg-qt").
  assign i-seg-qt = integer(return-value).

  run pi-calcula.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-calcula V-table-Win 
PROCEDURE pi-calcula :
/*------------------------------------------------------------------------------
  Purpose:     calcular os campos
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  assign c-cod-estabel-usuar = param-estoq.estabel-pad.

  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (INPUT c-seg-usuario,
                           INPUT-OUTPUT c-cod-estabel-usuar).
      END.
  &ENDIF

  if  c-estab = "" then
      assign c-estab = c-cod-estabel-usuar.

  assign de-consumo = 0.

  &if defined(bf_mat_uni_estab) &then /* EMS 2.03 */ 
      find first item-uni-estab
           where item-uni-estab.it-codigo   = item.it-codigo
             and item-uni-estab.cod-estabel = c-estab no-lock no-error.
  &else
      find first item-mat-estab
           where item-mat-estab.it-codigo   = item.it-codigo
             and item-mat-estab.cod-estabel = c-estab no-lock no-error.
  &endif

  if  param-estoq.cons-prev-estab then do:
      &if defined(bf_mat_uni_estab) &then /* EMS 2.03 */
          if avail item-uni-estab then
              assign de-consumo = item-uni-estab.consumo-prev.
          else 
              assign de-consumo = item.consumo-prev.
      &else
          if avail item-mat-estab then
              assign de-consumo = item-mat-estab.consumo-prev.
          else 
              assign de-consumo = item.consumo-prev.
      &endif
  end.
  else 
      assign de-consumo = item.consumo-prev.

  &if defined(bf_mat_uni_estab) &then /* EMS 2.03 */ 
      if avail item-uni-estab then
         assign de-lote-eco = item-uni-estab.lote-econom
                i-tempo     = item-uni-estab.tempo-segur.
      else       
         assign de-lote-eco = item.lote-econom
                i-tempo     = item.tempo-segur.
  &else
      if avail item-mat-estab then
         assign de-lote-eco = item-mat-estab.lote-econom
                i-tempo     = item-mat-estab.tempo-segur.
      else       
         assign de-lote-eco = item.lote-econom
                i-tempo     = item.tempo-segur.
  &endif

  assign de-giro = (i-sd-qt / i-med-qt) * 100.
  if de-giro = ? then
        assign de-giro = 0.
  if de-est = ? or de-est < 0 then
        assign de-est  = 0.
  assign de-real = (i-sd-qt * 100) / de-consumo.
  if de-real = ? then
        assign de-real = 0.

  if de-consumo = 0 then
      assign de-est = 0.
  else
      assign de-est = ((i-atual-qt - i-seg-qt) * 30) / de-consumo.

  if de-consumo = 0 then 
      assign de-est = 999.

  /*display do campo Classe ABC*/
  &if defined(bf_mat_uni_estab) &then /* EMS 2.03 */ 
      if avail item-uni-estab then
         assign c-abc:screen-value in frame {&frame-name} = {ininc/i03in172.i 04 item-uni-estab.classif-abc}.
      else       
         assign c-abc:screen-value in frame {&frame-name} = {ininc/i03in172.i 04 item.classif-abc}.
  &else
      if avail item-mat-estab then
         assign c-abc:screen-value in frame {&frame-name} = {ininc/i03in172.i 04 item-mat-estab.classif-abc}.
      else       
         assign c-abc:screen-value in frame {&frame-name} = {ininc/i03in172.i 04 item.classif-abc}.
  &endif

  /*display dos demais campos */
  display de-consumo 
          de-lote-eco
          de-giro
          i-tempo
          de-est 
          de-real with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estab V-table-Win 
PROCEDURE pi-estab :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


def input param p-c-estab as char    no-undo.

find first param-estoq no-lock no-error.

assign c-estab = p-c-estab.

/*RUN dispatch IN THIS-PROCEDURE ('open-query':U).*/


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

