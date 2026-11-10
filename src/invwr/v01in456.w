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
{include/i-prgvrs.i V01IN456 2.00.00.010}  /*** 010010 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN456 MUT}
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
def var rw-parent as rowid no-undo.
def var l-item    as logical no-undo init no.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES oper-item-cons
&Scoped-define FIRST-EXTERNAL-TABLE oper-item-cons


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR oper-item-cons.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS oper-item-cons.qtd-consumida ~
oper-item-cons.qtd-operacao oper-item-cons.val-proporcao ~
oper-item-cons.observacao 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}qtd-consumida ~{&FP2}qtd-consumida ~{&FP3}~
 ~{&FP1}qtd-operacao ~{&FP2}qtd-operacao ~{&FP3}~
 ~{&FP1}val-proporcao ~{&FP2}val-proporcao ~{&FP3}~
 ~{&FP1}observacao ~{&FP2}observacao ~{&FP3}
&Scoped-define ENABLED-TABLES oper-item-cons
&Scoped-define FIRST-ENABLED-TABLE oper-item-cons
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS operacao.op-codigo operacao.descricao ~
oper-item-cons.it-consumo oper-item-cons.qtd-consumida ~
oper-item-cons.qtd-operacao oper-item-cons.val-proporcao ~
oper-item-cons.observacao 
&Scoped-Define DISPLAYED-OBJECTS c-codigo c-descricao c-item-descricao c-un 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS oper-item-cons.it-consumo 

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
DEFINE VARIABLE c-codigo AS CHARACTER FORMAT "x(16)" 
     LABEL "":R5 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 44.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-item-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 41 BY .88.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 5.14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 3.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 4.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-codigo AT ROW 1.17 COL 24.86 COLON-ALIGNED HELP
          "C¢digo do Item"
     c-descricao AT ROW 1.17 COL 39.43 COLON-ALIGNED NO-LABEL
     operacao.op-codigo AT ROW 2.17 COL 24.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     operacao.descricao AT ROW 2.17 COL 32.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 36.29 BY .88
     oper-item-cons.it-consumo AT ROW 3.17 COL 24.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-item-descricao AT ROW 3.17 COL 42.57 COLON-ALIGNED NO-LABEL
     oper-item-cons.qtd-consumida AT ROW 4.63 COL 25 COLON-ALIGNED FORMAT ">>>>9.99"
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     c-un AT ROW 4.63 COL 37.14 COLON-ALIGNED HELP
          "Unidade de medida do item" NO-LABEL
     oper-item-cons.qtd-operacao AT ROW 5.63 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     oper-item-cons.val-proporcao AT ROW 6.63 COL 25 COLON-ALIGNED FORMAT ">>9.9"
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     oper-item-cons.observacao AT ROW 7.63 COL 25 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
          FONT 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.46 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.oper-item-cons
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
         HEIGHT             = 7.71
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

/* SETTINGS FOR FILL-IN c-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-item-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN operacao.descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN oper-item-cons.it-consumo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN operacao.op-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN oper-item-cons.qtd-consumida IN FRAME f-main
   EXP-FORMAT                                                           */
/* SETTINGS FOR FILL-IN oper-item-cons.val-proporcao IN FRAME f-main
   EXP-FORMAT                                                           */
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

&Scoped-define SELF-NAME oper-item-cons.it-consumo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-item-cons.it-consumo V-table-Win
ON F5 OF oper-item-cons.it-consumo IN FRAME f-main /* Item Consumo */
DO:
   assign l-implanta = yes.
   {include/zoomvar.i &prog-zoom="inzoom/z02in172.w"
                      &campo=oper-item-cons.it-consumo
                      &campozoom=it-codigo
                      &campo2=c-item-descricao
                      &campozoom2=desc-item
                      &campo3=c-un
                      &campozoom3=un}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-item-cons.it-consumo V-table-Win
ON LEAVE OF oper-item-cons.it-consumo IN FRAME f-main /* Item Consumo */
DO:
   {include/leave.i &tabela=item
                    &atributo-ref=desc-item 
                    &variavel-ref=c-item-descricao
                    &where="item.it-codigo = input frame {&frame-name} oper-item-cons.it-consumo"}
   if avail item then 
      assign c-item-descricao:screen-value in frame {&frame-name} = item.desc-item           
             c-un:screen-value in frame {&frame-name} = item.un. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL oper-item-cons.it-consumo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF oper-item-cons.it-consumo IN FRAME f-main /* Item Consumo */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  If oper-item-cons.it-consumo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
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
  {src/adm/template/row-list.i "oper-item-cons"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "oper-item-cons"}

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

  /* Code placed here will execute AFTER standard behavior.    */
   display c-codigo c-descricao with frame {&frame-name}.

  
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  find operacao where rowid(operacao) = v-row-parent no-lock no-error.
  if oper-item-cons.it-consumo:sensitive in frame {&frame-name} = yes 
  and can-find (oper-item-cons 
                where oper-item-cons.num-id-operacao = operacao.num-id-operacao
                and   oper-item-cons.op-altern       = 0
                and   oper-item-cons.it-consumo      = input frame {&frame-name} oper-item-cons.it-consumo) then do:
     {utp/ut-table.i mgind oper-item-cons 1}
     run utp/ut-msgs.p (input "show",
                        input 1,
                        input return-value).
     apply "entry" to oper-item-cons.it-consumo in frame {&frame-name}.
     return 'ADM-ERROR':U.                        
  end.   
  
  /* Ponha aqui as demais valida‡äes */
  /* Item Consumo deve ser diferente do Item */
  if input frame {&frame-name} oper-item-cons.it-consumo = c-codigo:screen-value in frame {&FRAME-NAME} 
     and l-item then do:
     run utp/ut-msgs.p (input "show",
                        input 17447,
                        input "").
     apply "entry" to oper-item-cons.it-consumo in frame {&frame-name}.
     return 'ADM-ERROR':U.                        
  end.
  
  if not can-find(first item where item.it-codigo = input frame {&frame-name} oper-item-cons.it-consumo) 
     then do:  
     {utp/ut-field.i mgind oper-item-cons it-consumo 1} 
     run utp/ut-msgs.p (input "show",
                        input 2,
                        input return-value).
     apply "entry" to oper-item-cons.it-consumo in frame {&frame-name}.
     return 'ADM-ERROR':U.                        
  end.   
  
  if decimal(oper-item-cons.qtd-consumida:screen-value in frame {&FRAME-NAME}) <= 0 
     then do:
     {utp/ut-field.i mgind oper-item-cons qtd-consumida 1} 
     run utp/ut-msgs.p (input "show",
                        input 36,
                        input return-value).
     apply "entry" to oper-item-cons.qtd-consumida in frame {&frame-name}.
     return 'ADM-ERROR':U.                        
  end.   
  
  if decimal(oper-item-cons.qtd-operacao:screen-value in frame {&FRAME-NAME}) <= 0 
     then do:
     {utp/ut-field.i mgind oper-item-cons qtd-operacao 1} 
     run utp/ut-msgs.p (input "show",
                        input 36,
                        input return-value).
     apply "entry" to oper-item-cons.qtd-operacao in frame {&frame-name}.
     return 'ADM-ERROR':U.                        
  end.   

  if decimal(oper-item-cons.val-proporcao:screen-value in frame {&FRAME-NAME}) <= 0 
  or decimal(oper-item-cons.val-proporcao:screen-value in frame {&FRAME-NAME}) > 100
     then do:
     {utp/ut-field.i mgind oper-item-cons val-proporcao 1} 
     run utp/ut-msgs.p (input "show",
                        input 2447,
                        input return-value).
     apply "entry" to oper-item-cons.val-proporcao in frame {&frame-name}.
     return 'ADM-ERROR':U.                        
  end.   

  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute AFTER standard behavior.    */
  if avail operacao then 
     assign oper-item-cons.num-id-operacao = operacao.num-id-operacao.

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
  if avail oper-item-cons then do:
     find item where item.it-codigo = oper-item-cons.it-consumo no-lock no-error.
     assign c-item-descricao = if avail item then item.desc-item else "":U
            c-un = if avail item then item.un  else "":U.
      
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
  
  find operacao where rowid(operacao) = v-row-parent no-lock no-error.
  if not avail operacao then do:
    {utp/ut-table.i mgind operacao 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    return "adm-error":U.
  end.      
                  
  assign rw-parent = v-row-parent.
  
  if operacao.cod-roteiro <> '' then do:
     {utp/ut-field.i mgind rot-fabric cod-roteiro 1}
     find rot-fabric where rot-fabric.cod-roteiro = operacao.cod-roteiro no-lock no-error.
     assign c-codigo    = operacao.cod-roteiro
            c-descricao = if avail rot-fabric then rot-fabric.descricao else "":U
            c-codigo:label in frame {&frame-name} = return-value.
  end.
  else do:
     {utp/ut-field.i mgind operacao it-codigo 1}
     find item where item.it-codigo = operacao.it-codigo no-lock no-error.
     assign c-codigo    = operacao.it-codigo
            c-descricao = if avail item then item.desc-item else "":U
            c-codigo:label in frame {&frame-name} = return-value
            l-item = yes.
  end. 
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "oper-item-cons"}

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


