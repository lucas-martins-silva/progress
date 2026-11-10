&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD298 2.00.00.002}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i  MUT}
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
def new global shared var r-row-val-tab-prog-impto as rowid no-undo.
def new global shared var r-row-tab-progres-ir as rowid no-undo.
def new global shared var v-incluir-modificar as char format "x(20)" no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var vl-faixa-final-anterior like tab-progres-ir.vl-faixa-fim.
def var vl-deducao-anterior like tab-progres-ir.vl-deducao.
def var vl-aplicado like tab-progres-ir.vl-deducao.
def var primeira-sequencia as logical initial no.
def var segunda-entrada-inicial as logical.
def var segunda-entrada-final as logical.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES tab-progres-ir
&Scoped-define FIRST-EXTERNAL-TABLE tab-progres-ir


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR tab-progres-ir.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS tab-progres-ir.vl-faixa-ini ~
tab-progres-ir.vl-faixa-fim tab-progres-ir.perc-faixa 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}vl-faixa-ini ~{&FP2}vl-faixa-ini ~{&FP3}~
 ~{&FP1}vl-faixa-fim ~{&FP2}vl-faixa-fim ~{&FP3}~
 ~{&FP1}perc-faixa ~{&FP2}perc-faixa ~{&FP3}
&Scoped-define ENABLED-TABLES tab-progres-ir
&Scoped-define FIRST-ENABLED-TABLE tab-progres-ir
&Scoped-Define ENABLED-OBJECTS rt-key i-sequencia rt-mold ~
vl-calculo-deducao 
&Scoped-Define DISPLAYED-FIELDS tab-progres-ir.nr-tab-progr ~
tab-progres-ir.seq-valid tab-progres-ir.vl-faixa-ini ~
tab-progres-ir.vl-faixa-fim tab-progres-ir.perc-faixa 
&Scoped-Define DISPLAYED-OBJECTS i-sequencia vl-calculo-deducao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS i-sequencia 
&Scoped-define ADM-ASSIGN-FIELDS tab-progres-ir.nr-tab-progr ~
tab-progres-ir.seq-valid 

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
DEFINE VARIABLE i-sequencia AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "":R8 
     VIEW-AS FILL-IN 
     SIZE 4.72 BY .88.

DEFINE VARIABLE vl-calculo-deducao AS DECIMAL FORMAT "->>,>>9.99" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 17.14 BY .88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.57 BY 3.75.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 75.72 BY 5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     tab-progres-ir.nr-tab-progr AT ROW 1.38 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     tab-progres-ir.seq-valid AT ROW 2.38 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     i-sequencia AT ROW 3.38 COL 31 COLON-ALIGNED
     tab-progres-ir.vl-faixa-ini AT ROW 5.13 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     tab-progres-ir.vl-faixa-fim AT ROW 6.13 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     tab-progres-ir.perc-faixa AT ROW 7.13 COL 31 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     vl-calculo-deducao AT ROW 8.21 COL 31 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 4.75 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.tab-progres-ir
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
         HEIGHT             = 8.88
         WIDTH              = 75.86.
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

/* SETTINGS FOR FILL-IN i-sequencia IN FRAME f-main
   1                                                                    */
/* SETTINGS FOR FILL-IN tab-progres-ir.nr-tab-progr IN FRAME f-main
   NO-ENABLE 2                                                          */
/* SETTINGS FOR FILL-IN tab-progres-ir.seq-valid IN FRAME f-main
   NO-ENABLE 2                                                          */
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

&Scoped-define SELF-NAME tab-progres-ir.perc-faixa
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-progres-ir.perc-faixa V-table-Win
ON LEAVE OF tab-progres-ir.perc-faixa IN FRAME f-main /* Perc Faixa */
DO:
   if v-incluir-modificar = 'incluir' then do:
      find last tab-progres-ir no-lock
           where tab-progres-ir.nr-tab-progr = val-tab-prog-impto.nr-tab-progr
           and tab-progres-ir.seq-valid = val-tab-prog-impto.seq-valid
           no-error.
      if primeira-sequencia = yes then do:
         assign vl-calculo-deducao = (input frame {&frame-name} tab-progres-ir.vl-faixa-fim * (input frame {&frame-name} tab-progres-ir.perc-faixa / 100)).
      end.
      else do:
           assign vl-calculo-deducao = (( vl-faixa-final-anterior * (input frame {&frame-name} tab-progres-ir.perc-faixa / 100)) - vl-deducao-anterior).
      end.
      assign vl-calculo-deducao:screen-value in frame {&frame-name} = string(vl-calculo-deducao).
   end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-progres-ir.vl-faixa-fim
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-progres-ir.vl-faixa-fim V-table-Win
ON LEAVE OF tab-progres-ir.vl-faixa-fim IN FRAME f-main /* Vl Faixa Final */
DO:
  if segunda-entrada-final = no then do:
     apply 'leave' to tab-progres-ir.perc-faixa.
  end.
  assign segunda-entrada-final = no.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME tab-progres-ir.vl-faixa-ini
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL tab-progres-ir.vl-faixa-ini V-table-Win
ON LEAVE OF tab-progres-ir.vl-faixa-ini IN FRAME f-main /* Vl Faixa Inicial */
DO:
  if segunda-entrada-inicial = no then do:
     apply 'leave' to tab-progres-ir.perc-faixa.
  end.
  assign segunda-entrada-inicial = no.   
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  {utp\ut-field.i mgadm tab-progres-ir vl-deducao 1}
  assign vl-calculo-deducao:label in frame {&frame-name} = return-value.
  
  {utp\ut-field.i mgadm tab-progres-ir seq-valid 1}
  assign i-sequencia:label in frame {&frame-name} = return-value.

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
  {src/adm/template/row-list.i "tab-progres-ir"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "tab-progres-ir"}

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

 /*Inicializa‡Æo de variaveis*/
 if v-incluir-modificar = 'incluir' then do:
    find val-tab-prog-impto where rowid(val-tab-prog-impto) = r-row-val-tab-prog-impto no-lock no-error.
    if avail val-tab-prog-impto then do:
    end.
    assign tab-progres-ir.nr-tab-progr:screen-value in frame {&frame-name} = string(val-tab-prog-impto.nr-tab-progr)
           tab-progres-ir.seq-valid:screen-value in frame {&frame-name} = string(val-tab-prog-impto.seq-valid)
           segunda-entrada-inicial = yes
           segunda-entrada-final = yes.
 end.    
 else do:
      find tab-progres-ir where rowid(tab-progres-ir) = r-row-tab-progres-ir no-lock.
      if avail tab-progres-ir then do:
      disable i-sequencia with frame {&frame-name}.
      assign tab-progres-ir.nr-tab-progr:screen-value in frame {&frame-name} = string(tab-progres-ir.nr-tab-progr)
             tab-progres-ir.seq-valid:screen-value in frame {&frame-name} = string(tab-progres-ir.seq-valid)
             i-sequencia:screen-value in frame {&frame-name} = string(tab-progres-ir.num-seq-tab-progr)
             tab-progres-ir.vl-faixa-ini:screen-value in frame {&frame-name} = string(tab-progres-ir.vl-faixa-ini)
             tab-progres-ir.vl-faixa-fim:screen-value in frame {&frame-name} = string(tab-progres-ir.vl-faixa-fim)
             tab-progres-ir.perc-faixa:screen-value in frame {&frame-name} = string(tab-progres-ir.perc-faixa)
             vl-calculo-deducao:screen-value in frame {&frame-name} = string(tab-progres-ir.vl-deducao).
      end.
 end.

/*C lculo Sequencial*/
 if v-incluir-modificar = 'incluir' then do:
    find last tab-progres-ir no-lock
              where tab-progres-ir.nr-tab-progr = val-tab-prog-impto.nr-tab-progr
              and tab-progres-ir.seq-valid = val-tab-prog-impto.seq-valid
              no-error.
    if  avail tab-progres-ir then do:
        assign primeira-sequencia = no
               i-sequencia = tab-progres-ir.num-seq-tab-progr + 10
               tab-progres-ir.vl-faixa-ini:screen-value in frame {&frame-name} = string(vl-faixa-final-anterior + 0.01)
               vl-faixa-final-anterior = tab-progres-ir.vl-faixa-fim
               vl-deducao-anterior = tab-progres-ir.vl-deducao.
    end.
    else do:
         assign i-sequencia = 10
                primeira-sequencia = yes.
    end.
    assign i-sequencia:screen-value in frame {&frame-name} = string(i-sequencia).
 end.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .

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
  /*Passando valor para a variavel*/
  
  if v-incluir-modificar = 'incluir' then do:
     assign i-sequencia = input frame {&frame-name} i-sequencia.
  end.

  /*Passando valor para a variavel*/
  assign vl-calculo-deducao = input frame {&frame-name} vl-calculo-deducao
         vl-aplicado = (input frame {&frame-name} tab-progres-ir.vl-faixa-ini * (input frame {&frame-name} tab-progres-ir.perc-faixa / 100)).

   if not frame {&frame-name}:validate() then
     return 'adm-error':U.
   
  run pi-validate.
  
 /*Valida faixa final menor que faixa inicial*/
 if input frame {&frame-name} tab-progres-ir.vl-faixa-fim < input frame {&frame-name} tab-progres-ir.vl-faixa-ini then do:
     {utp/ut-table.i mgadm tab-progres-ir 1}
     run utp/ut-msgs.p (input "show":U,
                        input 7466,
                        input return-value).
     apply 'entry' to tab-progres-ir.vl-faixa-fim.
     return 'ADM-ERROR':U.
 end.
 
 /*Valida valor dedu‡Æo ‚ maior que valor aplicado*/
 if (input frame {&frame-name} vl-calculo-deducao < 0) or (input frame {&frame-name} vl-calculo-deducao > vl-aplicado) then do :
    {utp\ut-table.i mgadm tab-progres-ir 1}
    run utp/ut-msgs.p (input "show":U, 
                       input 7440, 
                       input return-value).
    apply  'entry' to vl-calculo-deducao in frame {&frame-name}.
    return 'ADM-ERROR':U.
 end.   
 
  /* Dispatch standard ADM method.                      */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */
  assign tab-progres-ir.num-seq-tab-progr = input frame {&frame-name} i-sequencia
         tab-progres-ir.vl-deducao = input frame {&frame-name} vl-calculo-deducao.
       
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
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
 
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

 /*valida chave duplicada*/
if v-incluir-modificar = 'inclui' then do: 
    find tab-progres-ir where tab-progres-ir.nr-tab-progr = input frame {&frame-name} tab-progres-ir.nr-tab-progr
         and tab-progres-ir.seq-valid = input frame {&frame-name} tab-progres-ir.seq-valid
         and tab-progres-ir.num-seq-tab-progr = input frame {&frame-name} i-sequencia
         exclusive-lock no-error.
    if avail tab-progres-ir then do:
       {utp\ut-table.i mgadm tab-progres-ir 1}
       run utp\ut-msgs.p(input "show",
                         input 1,
                         input return-value).
       APPLY 'entry' TO i-sequencia.
       RETURN 'adm-error'.
    END.
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
  {src/adm/template/snd-list.i "tab-progres-ir"}

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



