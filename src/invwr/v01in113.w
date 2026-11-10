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
{include/i-prgvrs.i V01IN113 2.00.00.010 } /*** 010010 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in113 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def new global shared var gr-ficha-cq  as rowid no-undo.
def new global shared var v-row-parent as rowid no-undo.

def buffer b-exam-ficha for exam-ficha.

def var i-tp-insp like item-fornec.tp-inspecao no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES exam-ficha
&Scoped-define FIRST-EXTERNAL-TABLE exam-ficha


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR exam-ficha.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS exam-ficha.responsavel exam-ficha.nr-aceita ~
exam-ficha.nr-rejeita exam-ficha.tam-amostra 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}responsavel ~{&FP2}responsavel ~{&FP3}~
 ~{&FP1}nr-aceita ~{&FP2}nr-aceita ~{&FP3}~
 ~{&FP1}nr-rejeita ~{&FP2}nr-rejeita ~{&FP3}~
 ~{&FP1}tam-amostra ~{&FP2}tam-amostra ~{&FP3}
&Scoped-define ENABLED-TABLES exam-ficha
&Scoped-define FIRST-ENABLED-TABLE exam-ficha
&Scoped-Define ENABLED-OBJECTS rt-mold RECT-3 
&Scoped-Define DISPLAYED-FIELDS exam-ficha.cod-exame exam-ficha.responsavel ~
exam-ficha.nr-aceita exam-ficha.nr-rejeita exam-ficha.tam-amostra 
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-responsavel 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS exam-ficha.cod-exame 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(34)":U 
     VIEW-AS FILL-IN 
     SIZE 33.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-responsavel AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 32 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 4.58.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.86 BY 1.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     exam-ficha.cod-exame AT ROW 1.17 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     c-descricao AT ROW 1.17 COL 37.72 COLON-ALIGNED NO-LABEL
     exam-ficha.responsavel AT ROW 2.63 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-responsavel AT ROW 2.63 COL 48.14 COLON-ALIGNED NO-LABEL
     exam-ficha.nr-aceita AT ROW 3.71 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     exam-ficha.nr-rejeita AT ROW 4.75 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.86 BY .88
     exam-ficha.tam-amostra AT ROW 5.83 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6 BY .88
     rt-mold AT ROW 1 COL 1
     RECT-3 AT ROW 2.33 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: exam-ficha
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
         HEIGHT             = 6.04
         WIDTH              = 88.86.
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

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-responsavel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN exam-ficha.cod-exame IN FRAME f-main
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

&Scoped-define SELF-NAME exam-ficha.cod-exame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exam-ficha.cod-exame V-table-Win
ON F5 OF exam-ficha.cod-exame IN FRAME f-main /* Exame */
DO:
    /* alterado o programa de zoom para o z03in164.w pois este zoom mostra apenas os exames cadastrados
       para o item.*/

    find ficha-cq where rowid(ficha-cq) = gr-ficha-cq no-lock no-error. 
    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z03in164.w
                       &campo=exam-ficha.cod-exame
                       &campozoom=cod-exame
                       &parametros="run pi-seta-inicial in wh-pesquisa (input ficha-cq.it-codigo)."}
                      
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exam-ficha.cod-exame V-table-Win
ON LEAVE OF exam-ficha.cod-exame IN FRAME f-main /* Exame */
DO:
    find ficha-cq where rowid(ficha-cq) = gr-ficha-cq no-lock no-error. 

    {include/leave.i &tabela = it-exame
                     &atributo-ref = descricao
                     &variavel-ref = c-descricao
                     &atributo-ref2 = responsavel
                     &variavel-ref2 = exam-ficha.responsavel
                     &where = "it-exame.it-codigo = ficha-cq.it-codigo and it-exame.cod-exame = input frame {&frame-name} exam-ficha.cod-exame"}
                        
    if avail it-exame then do with frame {&FRAME-NAME}:
        find responsavel where responsavel.cod-resp = it-exame.responsavel no-error.
        assign c-responsavel:screen-value = if avail responsavel then responsavel.nome-resp else "":U.
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exam-ficha.cod-exame V-table-Win
ON MOUSE-SELECT-DBLCLICK OF exam-ficha.cod-exame IN FRAME f-main /* Exame */
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME exam-ficha.responsavel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exam-ficha.responsavel V-table-Win
ON F5 OF exam-ficha.responsavel IN FRAME f-main /* Respons†vel */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom = inzoom/z01in391.w
                     &campo     = exam-ficha.responsavel
                     &campozoom = cod-resp}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exam-ficha.responsavel V-table-Win
ON LEAVE OF exam-ficha.responsavel IN FRAME f-main /* Respons†vel */
DO:
  {include/leave.i &tabela = responsavel
                   &atributo-ref = nome-resp
                   &variavel-ref = c-responsavel
                   &where = "responsavel.cod-resp = input frame {&frame-name} exam-ficha.responsavel"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL exam-ficha.responsavel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF exam-ficha.responsavel IN FRAME f-main /* Respons†vel */
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
  
  if exam-ficha.cod-exame:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  if exam-ficha.responsavel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.
  
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
  {src/adm/template/row-list.i "exam-ficha"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "exam-ficha"}

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
 
  /* Ponha aqui a validaá∆o de chave duplicada */

  find ficha-cq where rowid(ficha-cq) = gr-ficha-cq no-lock no-error. 
  
  if exam-ficha.cod-exame:sensitive in frame {&frame-name} = yes 
     and can-find (b-exam-ficha   where
             b-exam-ficha.nr-ficha  = ficha-cq.nr-ficha  and
             b-exam-ficha.cod-exame = input frame {&frame-name} exam-ficha.cod-exame) then do:
      {utp/ut-table.i mgind exam-ficha 1}
      run utp/ut-msgs.p (input "show", input 1, input return-value).
      apply 'entry' to exam-ficha.cod-exame in frame {&frame-name}.
      return 'adm-error'.
  end.
 
  /* Ponha aqui as demais validaá‰es */
  
  /* VERIFICA SE EXISTE EXAME COM O CODIGO INFORMADO */
  {utp/ut-field.i mgind exame cod-exame 1}
  find first exame where exame.cod-exame = input frame {&frame-name} exam-ficha.cod-exame no-lock no-error.
  if  not avail exame then do:
      run utp/ut-msgs.p (input "show", input 47, input return-value).
      apply 'entry' to exam-ficha.cod-exame in frame {&frame-name}.
      return 'adm-error'.
  end.
  
  /* VERIFICA SE EXISTE VERS√O LIBERADA PARA O EXAME INFORMADO */
  FIND FIRST exame NO-LOCK 
       WHERE exame.cod-exame = INPUT FRAME {&frame-name} exam-ficha.cod-exame 
         AND exame.cdn-sit-vers = 2 /* Liberada */ NO-ERROR.
  IF NOT AVAILABLE exame then do:
      RUN utp/ut-msgs.p (INPUT "show", 
                         INPUT 55445,  /* Exame n„o possui vers„o liberada! */
                         INPUT '').
      APPLY 'entry' to exam-ficha.cod-exame IN FRAME {&frame-name}.
      RETURN 'adm-error'.
  END.
  
  {utp/ut-field.i mgind exam-ficha responsavel 1}
  find first responsavel where responsavel.cod-resp = input frame {&frame-name} exam-ficha.responsavel no-lock no-error.
  if  not avail responsavel then do:
      run utp/ut-msgs.p (input "show", input 47, input return-value).
      apply 'entry' to exam-ficha.responsavel in frame {&frame-name}.
      return 'adm-error'.
  end.
  
  /* VERIFICA A EXISTENCIA DE RELACIONAMENTO DO EXAME COM O ITEM */
   find it-exame where it-exame.cod-exame = input frame {&FRAME-NAME} exam-ficha.cod-exame
                   and it-exame.it-codigo = ficha-cq.it-codigo NO-LOCK no-error.
  if not avail it-exame then do:
      run utp/ut-msgs.p (input "show", 
                         input 3862,
                         input input frame {&FRAME-NAME} exam-ficha.cod-exame + "~~" + 
                               ficha-cq.it-codigo).
      apply 'entry' to exam-ficha.cod-exame in frame {&frame-name}.
      return 'adm-error'.
  end.
  
  /* VERIFICA SE O RELACIONAMENTO DO EXAME COM O ITEM ESTA ATIVO */
  find first it-exame no-lock
       where it-exame.cod-exame = input frame {&FRAME-NAME} exam-ficha.cod-exame
         and it-exame.it-codigo = ficha-cq.it-codigo 
         and it-exame.situacao  = 1 /*Ativo */ no-error.         
  if not avail it-exame then do:
      run utp/ut-msgs.p (input "show", 
                         input 55466, /*Exame &1 inativo para o item &2!*/
                         input input frame {&FRAME-NAME} exam-ficha.cod-exame + "~~" + 
                               ficha-cq.it-codigo).
      apply 'entry' to exam-ficha.cod-exame in frame {&frame-name}.
      return 'adm-error'.
  end.
  
  


if exam-ficha.cod-exame:sensitive in frame {&frame-name} = yes then do:    
  find first item-fornec use-index onde-compra where
             item-fornec.it-codigo    = it-exame.it-codigo and
             item-fornec.cod-emitente = ficha-cq.cod-emitente 
             no-lock no-error.
  if  avail item-fornec then 
    assign i-tp-insp = item-fornec.tp-inspecao.
  else
    assign i-tp-insp = 2. 

  find first exame-insp use-index codigo where 
             exame-insp.it-codigo   = it-exame.it-codigo and
             exame-insp.cod-exame   = it-exame.cod-exame and
             exame-insp.tp-inspecao = i-tp-insp 
             no-lock no-error.
  if  not avail exame-insp then do:
            if avail item-fornec then do:
                run utp/ut-msgs.p (input "show", input 8861, input "" ).
                /* Tipo de inspecao do exame difere da relacao Item x Fornecedor */
                return "adm-error".
            end.
            else do:
                 run utp/ut-msgs.p (input "show", input 8860, input "").
                 /* Item nao possui relacao com o Fornecedor 
                    Tipo de inspecao do exame dever ser 2 - Normal */
                 return "adm-error".
            end.
  end.
end.

  /* Obs.: CASO A VALIDAÄ«O FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
  find ficha-cq where rowid(ficha-cq) = gr-ficha-cq no-lock no-error.
  if  available ficha-cq then do:
      assign exam-ficha.nr-ficha  = ficha-cq.nr-ficha
             exam-ficha.it-codigo = ficha-cq.it-codigo.
  end.

  /*Alimenta o c¢digo da vers∆o liberada*/
  IF NOT AVAIL exame THEN
      FIND FIRST exame NO-LOCK 
          WHERE exame.cod-exame = INPUT FRAME {&frame-name} exam-ficha.cod-exame 
          AND exame.cdn-sit-vers = 2 /* Liberada */ NO-ERROR.
  IF AVAIL exame THEN
      ASSIGN exam-ficha.cdn-versao = exame.cdn-versao. 
  
  
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


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .
  
  
  APPLY "LEAVE" TO exam-ficha.cod-exame IN FRAME {&frame-name}.

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
  {src/adm/template/snd-list.i "exam-ficha"}

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


