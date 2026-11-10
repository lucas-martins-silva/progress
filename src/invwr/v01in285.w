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
{include/i-prgvrs.i V01IN285 2.00.00.016}  /*** 010016 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V01IN285 MUT}
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES param-dp
&Scoped-define FIRST-EXTERNAL-TABLE param-dp


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR param-dp.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS param-dp.nome-abrev param-dp.nr-prox-estrut ~
param-dp.it-codigo-dp param-dp.it-codigo-pend 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome-abrev ~{&FP2}nome-abrev ~{&FP3}~
 ~{&FP1}nr-prox-estrut ~{&FP2}nr-prox-estrut ~{&FP3}~
 ~{&FP1}it-codigo-dp ~{&FP2}it-codigo-dp ~{&FP3}~
 ~{&FP1}it-codigo-pend ~{&FP2}it-codigo-pend ~{&FP3}
&Scoped-define ENABLED-TABLES param-dp
&Scoped-define FIRST-ENABLED-TABLE param-dp
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS param-dp.nome-abrev param-dp.nr-prox-estrut ~
param-dp.it-codigo-dp param-dp.it-codigo-pend 
&Scoped-Define DISPLAYED-OBJECTS c-nome-emit c-descricao-1 c-descricao-2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS param-dp.nome-abrev ~
param-dp.nr-prox-estrut param-dp.it-codigo-dp param-dp.it-codigo-pend 

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
DEFINE VARIABLE c-descricao-1 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-2 AS CHARACTER FORMAT "X(60)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE VARIABLE c-nome-emit AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 36 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.57 BY 4.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     param-dp.nome-abrev AT ROW 1.25 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-nome-emit AT ROW 1.25 COL 45.14 COLON-ALIGNED NO-LABEL
     param-dp.nr-prox-estrut AT ROW 2.29 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     param-dp.it-codigo-dp AT ROW 3.29 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-1 AT ROW 3.29 COL 46.43 COLON-ALIGNED NO-LABEL
     param-dp.it-codigo-pend AT ROW 4.33 COL 28 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao-2 AT ROW 4.33 COL 46.43 COLON-ALIGNED NO-LABEL
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.param-dp
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
         HEIGHT             = 4.88
         WIDTH              = 86.72.
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

/* SETTINGS FOR FILL-IN c-descricao-1 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-nome-emit IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN param-dp.it-codigo-dp IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN param-dp.it-codigo-pend IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN param-dp.nome-abrev IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN param-dp.nr-prox-estrut IN FRAME f-main
   1                                                                    */
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

&Scoped-define SELF-NAME param-dp.it-codigo-dp
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.it-codigo-dp V-table-Win
ON F5 OF param-dp.it-codigo-dp IN FRAME f-main /* Item Ordem Prot¢tipo */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                  &campo=param-dp.it-codigo-dp
                  &campozoom=it-codigo}
                  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.it-codigo-dp V-table-Win
ON LEAVE OF param-dp.it-codigo-dp IN FRAME f-main /* Item Ordem Prot¢tipo */
DO:
  find first item 
     where item.it-codigo = input frame {&frame-name}
                            param-dp.it-codigo-dp no-lock no-error.

  if  not avail item then do:
     {utp/ut-table.i mgind item 1}.
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return no-apply.
     assign c-descricao-1 = "".
  end.                      
  else do:
          assign c-descricao-1 = item.desc-item.
  end.
  display c-descricao-1 with frame {&frame-name}.
  
  if  item.tipo-contr <> 4 and
     input frame {&frame-name} param-dp.it-codigo-pend <> ? then  do:
     run utp/ut-msgs.p (input "show",
                        input 851,
                        input "").
     return no-apply. 
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.it-codigo-dp V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-dp.it-codigo-dp IN FRAME f-main /* Item Ordem Prot¢tipo */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-dp.it-codigo-pend
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.it-codigo-pend V-table-Win
ON F5 OF param-dp.it-codigo-pend IN FRAME f-main /* Item Pendente DP */
DO:
    {include/zoomvar.i &prog-zoom=inzoom/z02in172.w
                  &campo=param-dp.it-codigo-pend
                  &campozoom=it-codigo}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.it-codigo-pend V-table-Win
ON LEAVE OF param-dp.it-codigo-pend IN FRAME f-main /* Item Pendente DP */
DO:
  find first item 
     where item.it-codigo = input frame {&frame-name}
                            param-dp.it-codigo-pend no-lock no-error.

  if  not avail item then do:
     {utp/ut-table.i mgind item 1}.
     run utp/ut-msgs.p (input "show",
                        input 56,
                        input return-value).
     return no-apply.
     assign c-descricao-2 = "".
  end.                      
  else do:
          assign c-descricao-2 = item.desc-item.
  end.
  display c-descricao-2 with frame {&frame-name}.

         
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.it-codigo-pend V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-dp.it-codigo-pend IN FRAME f-main /* Item Pendente DP */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME param-dp.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.nome-abrev V-table-Win
ON F5 OF param-dp.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:
  {include/zoom.i &prog-zoom="adzoom/z02ad098.w"
                  &tabela=param-dp
                  &atributo=nome-abrev}
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.nome-abrev V-table-Win
ON LEAVE OF param-dp.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:
 {include/leave.i &tabela=emitente
                  &atributo-ref=nome-emit
                  &variavel-ref=c-nome-emit
                  &where="emitente.nome-abrev=input frame {&frame-name} param-dp.nome-abrev"} 
 
 find first emitente use-index nome 
    where emitente.nome-abrev = input frame {&frame-name} param-dp.nome-abrev 
      and emitente.identific <> 2 
    no-lock no-error.
  if not avail emitente or
     emitente.identific = 2 then do :
     run utp/ut-msgs.p (input "show",
                        input 2067,
                        input "").
     return no-apply.
  end.                     
                                                              
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL param-dp.nome-abrev V-table-Win
ON MOUSE-SELECT-DBLCLICK OF param-dp.nome-abrev IN FRAME f-main /* Nome Abreviado */
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

if param-dp.nome-abrev:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
if param-dp.it-codigo-dp:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.
if param-dp.it-codigo-pend:load-mouse-pointer ("image\lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "param-dp"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "param-dp"}

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
   
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  find first param-global no-lock no-error.

  if param-global.modulo-co = yes then do:
    find modelo-cf
      where modelo-cf.item-criado = input frame {&frame-name} param-dp.it-codigo-pend no-error.
    if avail modelo-cf then do:
       run utp/ut-msgs.p (input "show",
                          input 8819,
                          input "").
       apply 'entry' to param-dp.it-codigo-pend in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.   
  end.  
  
  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  find item where item.it-codigo = input frame {&frame-name} param-dp.it-codigo-pend no-error.
  if avail item then do:
     find cot-item 
        where cot-item.item-cotacao = item.it-codigo no-error.
        if not avail cot-item then do:
           create cot-item.
           assign cot-item.item-cotacao  = item.it-codigo
                  cot-item.descricao-1   = substr(item.desc-item,1,18)
                  cot-item.descricao-2   = substr(item.desc-item,19,18)  
                  cot-item.cod-imagem    = item.cod-imagem 
                  cot-item.cod-obsoleto  = item.cod-obsoleto
                  cot-item.compr-fabric  = item.compr-fabric
                  cot-item.data-base     = item.data-base
                  cot-item.data-implant  = item.data-implant
                  cot-item.data-liberac  = item.data-liberac
                  cot-item.data-ult-ent  = item.data-ult-ent
                  cot-item.data-ult-rep  = item.data-ult-rep
                  cot-item.desc-inter    = item.desc-inter
                  cot-item.desc-nacional = item.desc-nacional
                  cot-item.fator-refugo  = item.fator-refugo
                  cot-item.fm-cod-com    = item.fm-cod-com
                  cot-item.fm-codigo     = item.fm-codigo
                  cot-item.ge-codigo     = item.ge-codigo
                  cot-item.item-destino  = item.it-codigo
                  cot-item.item-ordem    = item.it-codigo
                  cot-item.lote-economi  = item.lote-economi
                  cot-item.preco-repos   = item.preco-repos
                  cot-item.preco-fiscal  = item.preco-fiscal
                  cot-item.preco-base    = item.preco-base
                  cot-item.path          = item.path
                  cot-item.niv-mais-bai  = item.niv-mais-bai
                  cot-item.moeda-padrao  = item.moeda-padrao
                  cot-item.un            = item.un
                  cot-item.preco-ul-ent  = item.preco-ul-ent.
        end.
  end.     
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
 if avail param-dp then do :
    find emitente where emitente.nome-abrev = input frame {&frame-name} param-dp.nome-abrev no-lock no-error.
    assign c-nome-emit = if avail emitente then emitente.nome-emit else "":U.
 end.
 
 if avail param-dp then do :
    find item 
      where item.it-codigo = param-dp.it-codigo-dp no-lock no-error.
    assign c-descricao-1 = if avail item then item.desc-item else "":U.

    find item 
      where item.it-codigo = param-dp.it-codigo-pend no-lock no-error.
    assign c-descricao-2 = if avail item then item.desc-item else "":U.

    find first emitente use-index nome 
      where emitente.nome-abrev = param-dp.nome-abrev no-lock no-error.
    assign c-nome-emit = if avail emitente then emitente.nome-emit else "":U.
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
  {src/adm/template/snd-list.i "param-dp"}

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


