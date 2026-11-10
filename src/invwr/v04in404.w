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
{include/i-prgvrs.i V04IN404 2.00.00.029 } /*** "010029" ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN404 MUT}
&ENDIF

{cdp/cdcfgdis.i} /*  defini‡Æo e pr‚-processadores distribui‡Æo */ 
 
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
 
def buffer b-saldo for saldo-terc.
 
def var rw-saldo-terc as rowid no-undo.
 
def var c-it-codigo as char no-undo.
def var c-cod-refer as char no-undo.
def var c-sequencia as char no-undo.
def var h_v07in404  as handle no-undo.
def var h_v08in053  as handle no-undo.
def var p-cod-refer like saldo-terc.cod-refer no-undo.
def new global shared var r-componente as rowid no-undo.
def var i-tipo-sal-terc like natur-oper.tipo no-undo.
 
DEF VAR c-cod-estabel-usuar LIKE estabelec.cod-estabel.
{cdp/cd4300.i3}  /*Variÿveis para o cd4300.i4 */
{cdp/cd0101.i50} /*Variÿveis para o re1001b.i51*/
def var c-label      as handle  no-undo.

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
&Scoped-Define ENABLED-FIELDS saldo-terc.cod-emitente ~
saldo-terc.serie-docto saldo-terc.nro-docto saldo-terc.nat-operacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-emitente ~{&FP2}cod-emitente ~{&FP3}~
 ~{&FP1}serie-docto ~{&FP2}serie-docto ~{&FP3}~
 ~{&FP1}nro-docto ~{&FP2}nro-docto ~{&FP3}~
 ~{&FP1}nat-operacao ~{&FP2}nat-operacao ~{&FP3}
&Scoped-define ENABLED-TABLES saldo-terc
&Scoped-define FIRST-ENABLED-TABLE saldo-terc
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS saldo-terc.cod-emitente ~
saldo-terc.serie-docto saldo-terc.nro-docto saldo-terc.nat-operacao 
&Scoped-Define DISPLAYED-OBJECTS c-nome-abrev c-cgc 

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
DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "x(19)" INITIAL ? 
     LABEL "CGC":R4 
     VIEW-AS FILL-IN 
     SIZE 20 BY .88.

DEFINE VARIABLE c-nome-abrev AS CHARACTER FORMAT "X(12)" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     saldo-terc.cod-emitente AT ROW 1.13 COL 14.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12 BY .88
     c-nome-abrev AT ROW 1.13 COL 27.14 COLON-ALIGNED NO-LABEL
     saldo-terc.serie-docto AT ROW 1.13 COL 55.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9 BY .88
     c-cgc AT ROW 2.08 COL 14.86 COLON-ALIGNED
     saldo-terc.nro-docto AT ROW 2.08 COL 55.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     saldo-terc.nat-operacao AT ROW 3.04 COL 55.43 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.57 BY .88
     rt-key AT ROW 1 COL 1
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
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 3.29
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-cgc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-abrev IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */
 
{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME saldo-terc.cod-emitente
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-emitente V-table-Win
ON F5 OF saldo-terc.cod-emitente IN FRAME f-main /* Emitente */
DO:
 
  assign l-implanta = yes.
 
  {include/zoomvar.i &prog-zoom = adzoom/z01ad098.w
                     &campo = saldo-terc.cod-emitente
                     &campozoom = cod-emitente}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-emitente V-table-Win
ON LEAVE OF saldo-terc.cod-emitente IN FRAME f-main /* Emitente */
DO:
  {include/leave.i &tabela = emitente
                   &atributo-ref = nome-abrev
                   &variavel-ref = c-nome-abrev
                   &where = "emitente.cod-emitente = input frame {&frame-name} saldo-terc.cod-emitente} 
 
  {include/leave.i &tabela = emitente
                   &atributo-ref = cgc
                   &variavel-ref = c-cgc
                   &where = "emitente.cod-emitente = input frame {&frame-name} saldo-terc.cod-emitente}                                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.cod-emitente V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.cod-emitente IN FRAME f-main /* Emitente */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.nat-operacao
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.nat-operacao V-table-Win
ON F5 OF saldo-terc.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
 
  assign l-implanta = yes.
 
  {include/zoomvar.i &prog-zoom = inzoom/z01in245.w
                     &campo = saldo-terc.nat-operacao
                     &campozoom = nat-operacao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.nat-operacao V-table-Win
ON LEAVE OF saldo-terc.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:

find natur-oper where 
     natur-oper.nat-operacao = input frame {&frame-name} saldo-terc.nat-operacao
     no-lock no-error.
  
  if avail natur-oper then do:
     if valid-handle(h_v08in053) then do:
        run pi-icm in h_v08in053 (input input frame {&frame-name} saldo-terc.nat-operacao). 
     end.   
  end.
  else do:
       {utp/ut-table.i mgind natur-oper 1}
       run utp/ut-msgs.p (input "show",
                          input 47,
                          input return-value).
       apply "entry" to saldo-terc.nat-operacao in frame {&frame-name}.
       return no-apply.                   
  end.   

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.nat-operacao V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.nat-operacao IN FRAME f-main /* Nat Opera‡Æo */
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME saldo-terc.serie-docto
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.serie-docto V-table-Win
ON F5 OF saldo-terc.serie-docto IN FRAME f-main /* S‚rie */
DO:
 
   assign l-implanta = yes.
 
  {include/zoomvar.i &prog-zoom = inzoom/z01in407.w
                     &campo = saldo-terc.serie-docto
                     &campozoom = serie}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.serie-docto V-table-Win
ON LEAVE OF saldo-terc.serie-docto IN FRAME f-main /* S‚rie */
DO: 
 
 
 
  {include/leave.i &tabela = serie
                   &atributo-ref = serie
                   &variavel-ref = serie-docto
                   &where = "serie.serie = input frame {&frame-name} saldo-terc.serie-docto}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL saldo-terc.serie-docto V-table-Win
ON MOUSE-SELECT-DBLCLICK OF saldo-terc.serie-docto IN FRAME f-main /* S‚rie */
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
 
 
  if saldo-terc.cod-emitente:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
  if saldo-terc.serie-docto:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then. 
  if saldo-terc.nat-operacao:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.   
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
 
 
  /********
find saldo-terc where  rowid(saldo-terc) = rw-saldo-terc no-lock no-error.
if avail saldo-terc  then do:
    find emitente where emitente.cod-emitente = saldo-terc.cod-emitente no-lock no-error.
    if avail emitente then  
        assign saldo-terc.cod-emitente:screen-value in frame {&frame-name}= string(saldo-terc.cod-emitente)
               c-nome-abrev:screen-value in frame {&frame-name} = string(emitente.nome-abrev)
               c-cgc:screen-value in frame {&frame-name} = string(emitente.cgc)
               saldo-terc.serie-docto:screen-value  in frame {&frame-name}= string(saldo-terc.serie-docto)
               saldo-terc.nro-docto:screen-value    in frame {&frame-name}= string(saldo-terc.nro-docto)
               saldo-terc.nat-operacao:screen-value in frame {&frame-name}= string(saldo-terc.nat-operacao).
end.
 
 ********/
 
do with frame {&FRAME-NAME}:
   find estabelec where 
        estabelec.cod-estabel = c-cod-estabel-usuar
        no-lock no-error.
   assign saldo-terc.serie-docto:screen-value = if avail estabelec then estabelec.serie-manual 
                                   else "".
/*Pa¡s diferente de Brasil e Utiliza S‚rie desmarcado deve buscar da param-estoq*/
     IF NOT l-ut-ser
         AND i-pais-impto-usuario <> 1 /*Brasil*/ THEN DO:

         IF NOT AVAIL param-estoq THEN
             FOR FIRST param-estoq NO-LOCK: END.

         ASSIGN saldo-terc.serie-docto:SCREEN-VALUE = SUBSTRING(param-estoq.char-2,69,5).

     END.
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
 
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.
 
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
 
 
  /* local-assign-record */
 
  find first natur-oper where 
             natur-oper.nat-operacao = input frame {&frame-name} saldo-terc.nat-operacao no-lock no-error.
 
  if avail natur-oper then do:
     {cdp/cd4398.i4}        /* Determina Tipo de Saldo em Poder de Terceiros (saldo-terc.tipo-sal-terc) */
      assign saldo-terc.tipo-sal-terc = i-tipo-sal-terc.
  end.     
 
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
 
  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .
 
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, 
        INPUT "it-codigo").
  assign saldo-terc.it-codigo = return-value.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT this-procedure, 
        INPUT "sequencia").
  assign saldo-terc.sequencia = int(return-value).
 
  if valid-handle(h_v07in404) then
    run pi-cod-refer in h_v07in404 (output p-cod-refer).
  assign saldo-terc.cod-refer = p-cod-refer.
 
 
  /**************** Cria Componente ****************************/ 
 
  create componente.
 
  assign componente.serie-docto  = input frame {&frame-name} saldo-terc.serie-docto
         componente.nro-docto    = input frame {&frame-name} saldo-terc.nro-docto
         componente.cod-emitente = input frame {&frame-name} saldo-terc.cod-emitente
         componente.nat-operacao = input frame {&frame-name} saldo-terc.nat-operacao.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "it-codigo").
  assign componente.it-codigo    = return-value.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "cod-refer").
  assign componente.cod-refer    = return-value.
 
  RUN Get-Field-Screen-Value IN adm-broker-hdl
    (INPUT this-procedure,
     INPUT "sequencia").
  assign componente.sequencia    = int(return-value).
 
  assign r-componente = rowid(componente).
 
  /*************************************************************/
 
  /* Code placed here will execute AFTER standard behavior.    */
 
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
 
  find docum-est where docum-est.serie-docto  = input frame {&frame-name}  saldo-terc.serie-docto  and
                       docum-est.nro-docto    = input frame {&frame-name}  saldo-terc.nro-docto    and
                       docum-est.cod-emitente = input frame {&frame-name}  saldo-terc.cod-emitente and
                       docum-est.nat-operacao = input frame {&frame-name}  saldo-terc.nat-operacao no-lock no-error.
 
  if avail docum-est then do:                      
     run utp/ut-msgs.p (input "show":U, input 6378, input "").   
     return 'ADM-ERROR':U.
  end.
 
  find componente use-index comp where componente.cod-emitente = saldo-terc.cod-emitente  and 
                                       componente.serie-comp   = saldo-terc.serie-docto   and
                                       componente.nro-comp     = saldo-terc.nro-docto     and
                                       componente.nat-comp     = saldo-terc.nat-operacao  and
                                       componente.it-codigo    = saldo-terc.it-codigo     and
                                       componente.cod-refer    = saldo-terc.cod-refer     and
                                       componente.seq-comp     = saldo-terc.sequencia     no-lock no-error.
 
  if avail componente then do:
     find docum-est where docum-est.serie-docto   = componente.serie-docto   and
                          docum-est.nro-docto     = componente.nro-docto     and
                          docum-est.cod-emitente = componente.cod-emitente  and                                      
                          docum-est.nat-operacao  = componente.nat-operacao  no-lock no-error.  
 
      if avail docum-est then do:                      
         run utp/ut-msgs.p (input "show":U, input 6386, input "").   
         return 'ADM-ERROR':U.
      end.                                      
  end.    
 
  for each componente where componente.serie-docto   = saldo-terc.serie-docto     and
                            componente.nro-docto     = saldo-terc.nro-docto       and
                            componente.cod-emitente  = saldo-terc.cod-emitente    and 
                            componente.nat-operacao  = saldo-terc.nat-operacao    and                            
                            componente.it-codigo     = saldo-terc.it-codigo       and                            
                            componente.cod-refer     = saldo-terc.cod-refer       and
                            componente.sequencia     = saldo-terc.sequencia       exclusive-lock:
     delete componente.
  end.
 
 
  for each componente use-index comp where componente.cod-emitente = saldo-terc.cod-emitente  and 
                                           componente.serie-comp   = saldo-terc.serie-docto   and
                                           componente.nro-comp     = saldo-terc.nro-docto     and
                                           componente.nat-comp     = saldo-terc.nat-operacao  and
                                           componente.it-codigo    = saldo-terc.it-codigo     and
                                           componente.cod-refer    = saldo-terc.cod-refer     and
                                           componente.seq-comp     = saldo-terc.sequencia     exclusive-lock:
    delete componente.                                           
  end.
 
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
     assign rw-saldo-terc = rowid(saldo-terc).
     find emitente where emitente.cod-emitente = saldo-terc.cod-emitente no-lock no-error.
     assign c-cgc        = if avail emitente then emitente.cgc else "":U
            c-nome-abrev = if avail emitente then emitente.nome-abrev else "":U.
   end.
 
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
 
  find first param-global no-lock no-error.
  find first param-estoq no-lock no-error.
 
  ASSIGN c-cod-estabel-usuar = param-estoq.estabel-pad.

  /* Funcao Super/Minas */
  &IF DEFINED(Bf_dis_usuario_estab) &THEN
      IF CAN-FIND(funcao WHERE funcao.cd-funcao = "Fn-estab-usuario"
                           AND funcao.ativo     = YES) THEN DO:
         RUN cdp/cd8702.p (INPUT c-seg-usuario,
                                INPUT-OUTPUT c-cod-estabel-usuar).
      END.
  &ENDIF
  {utp/ut-liter.i CGC}
  assign c-cgc:label in frame {&FRAME-NAME} = trim(return-value).   
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
  /*Quando tem valor na param-estoq deve ser considerado o que est  nesse campo e nÆo na param-global*/
  IF SUBSTRING(param-estoq.char-2,68,1) <> "":U THEN
      ASSIGN l-ut-ser = (SUBSTRING(param-estoq.char-2,68,1) = "S":U).
  ELSE DO:
      {cdp/cd4300.i4  "yes" param-global.char-2}             
      {cdp/cd0101.i51 "yes"}
  END.
 
  do with frame {&FRAME-NAME}:
    if not l-ut-ser  /*nÆo utiliza serie*/
    and i-pais-impto-usuario <> 1 /*brasil*/ then 
        assign saldo-terc.nat-operacao:row = saldo-terc.nro-docto:row 
               c-label          = saldo-terc.nat-operacao:SIDE-LABEL-HANDLE  /*pega o handle do label*/
               c-label:row      = saldo-terc.nro-docto:row  /*move o label para a mesma linha do fill-in*/
               saldo-terc.nro-docto:row = saldo-terc.serie-docto:row 
               c-label          = saldo-terc.nro-docto:SIDE-LABEL-HANDLE  /*pega o handle do label*/
               c-label:row      = saldo-terc.serie-docto:row  /*move o label para a mesma linha do fill-in*/
               saldo-terc.serie-docto:visible  = no. /*esconde a s‚rie*/
  end.
 
 
  find first param-global no-lock no-error.
  if avail param-global then 
     assign c-cgc:format in frame {&frame-name} = param-global.formato-id-federal.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle.
 
assign h_v07in404 = p-handle.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle-v08 V-table-Win 
PROCEDURE pi-passa-handle-v08 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-handle as handle.
 
assign h_v08in053 = p-handle.

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
 
 
   find emitente where 
                 emitente.cod-emitente = input frame {&frame-name} saldo-terc.cod-emitente no-lock no-error.
   if not avail emitente then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgadm emitente 1} 
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      return 'ADM-ERROR':U.
   end. 
 
   find first serie where 
                 serie.serie = input frame {&frame-name} saldo-terc.serie-docto no-lock no-error.
   if not avail serie and saldo-terc.serie-docto:visible in frame {&frame-name} = yes then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind serie 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      return 'ADM-ERROR':U.
   end.
 
   find natur-oper where 
                 natur-oper.nat-operacao = input frame {&frame-name} saldo-terc.nat-operacao no-lock no-error.
   if not avail natur-oper then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind natur-oper 1}
      run utp/ut-msgs.p (input "show":U, input 2, input return-value).
      return 'ADM-ERROR':U.
   end.
 
   if natur-oper.terceiros = no or natur-oper.transf = yes then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 5492, input "").
      return 'ADM-ERROR':U.
   end.
 
   if  natur-oper.tp-oper-terc <> 1 AND natur-oper.tp-oper-terc <> 8 AND natur-oper.tp-oper-terc <> 10 AND natur-oper.tp-oper-terc <> 3 then do:
       {include/i-vldprg.i}
       run utp/ut-msgs.p (input "show":U, input 16158, input "").
       return 'ADM-ERROR':U.
   end.
 
   /*if natur-oper.tipo = 2 and natur-oper.oper-terc = 2 then do:
 *       {include/i-vldprg.i}
 *       run utp/ut-msgs.p (input "show":U, input 5495, input "").
 *       return 'ADM-ERROR':U.
 *    end.*/
 
   find docum-est where docum-est.serie-docto  = input frame {&frame-name} saldo-terc.serie-docto    and
                        docum-est.nro-docto    = input frame {&frame-name} saldo-terc.nro-docto      and
                        docum-est.cod-emitente = input frame {&frame-name} saldo-terc.cod-emitente   and
                        docum-est.nat-operacao = input frame {&frame-name} saldo-terc.nat-operacao no-lock no-error.
   if avail docum-est then do:
      {include/i-vldprg.i}
      run utp/ut-msgs.p (input "show":U, input 3175, input "").
      return 'ADM-ERROR':U.
   end.                           
 
 
   RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure,
                                                INPUT "it-codigo").
   assign c-it-codigo = return-value.
 
   RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure,
                                                INPUT "cod-refer").
   assign c-cod-refer = return-value.
 
   RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure,
                                                INPUT "sequencia").
   assign c-sequencia = return-value.
 
   find b-saldo where 
                b-saldo.serie-docto  = input frame {&frame-name} saldo-terc.serie-docto    and
                b-saldo.nro-docto    = input frame {&frame-name} saldo-terc.nro-docto      and
                b-saldo.cod-emitente = input frame {&frame-name} saldo-terc.cod-emitente   and
                b-saldo.nat-operacao = input frame {&frame-name} saldo-terc.nat-operacao   and 
                b-saldo.it-codigo    = c-it-codigo               and
                b-saldo.cod-refer    = c-cod-refer               and
                b-saldo.sequencia    = int(c-sequencia)          no-lock no-error.
   if avail b-saldo then do:
      {include/i-vldprg.i}
      {utp/ut-table.i mgind saldo-terc 1}
      run utp/ut-msgs.p (input "show":U, input 7, input return-value).
      return 'ADM-ERROR':U.
   end.
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-verifica-sensitive V-table-Win 
PROCEDURE pi-verifica-sensitive :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
def output parameter l-sensitive-codigo as logical no-undo.
 
    if saldo-terc.cod-emitente:sensitive in frame {&frame-name} = yes then
        assign l-sensitive-codigo = yes.
    else
        assign l-sensitive-codigo = no.
 
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


