&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
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
{include/i-prgvrs.i V03IN101 2.00.00.004}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V03IN101 MUT}
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
def var c-ano        as char format "9999".
def var c-mes        as char format "99".

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS RECT-23 i-moeda1 c-per-ini1 c-per-fim1 ~
c-fm-codigo1 RECT-24 rs-tipo-custo 
&Scoped-Define DISPLAYED-OBJECTS i-moeda1 c-per-ini1 c-per-fim1 ~
c-fm-codigo1 rs-tipo-custo c-moeda c-desc-fam 

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
DEFINE VARIABLE c-desc-fam AS CHARACTER FORMAT "X(30)":U 
      VIEW-AS TEXT 
     SIZE 34.29 BY .67 NO-UNDO.

DEFINE VARIABLE c-fm-codigo1 AS CHARACTER FORMAT "X(8)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE VARIABLE c-moeda AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .67 NO-UNDO.

DEFINE VARIABLE c-per-fim1 AS CHARACTER FORMAT "9999/99":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-per-ini1 AS CHARACTER FORMAT "9999/99":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10.57 BY .88 NO-UNDO.

DEFINE VARIABLE i-moeda1 AS INTEGER FORMAT "9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 3 BY .88 NO-UNDO.

DEFINE VARIABLE txt-custo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE rs-tipo-custo AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Mensal", 1,
"On-Line", 2,
"PadrÆo", 3
     SIZE 50 BY 1 NO-UNDO.

DEFINE RECTANGLE RECT-23
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 69.43 BY 5.08.

DEFINE RECTANGLE RECT-24
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 68.57 BY 2.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-moeda1 AT ROW 1.83 COL 18.14 COLON-ALIGNED
     c-per-ini1 AT ROW 2.83 COL 18.14 COLON-ALIGNED
     c-per-fim1 AT ROW 3.83 COL 18.14 COLON-ALIGNED
     c-fm-codigo1 AT ROW 4.83 COL 18.14 COLON-ALIGNED
     rs-tipo-custo AT ROW 7.5 COL 4.72 NO-LABEL
     c-moeda AT ROW 1.92 COL 21.86 COLON-ALIGNED NO-LABEL
     c-desc-fam AT ROW 4.92 COL 32.72 COLON-ALIGNED NO-LABEL
     txt-custo AT ROW 6.58 COL 3.86 NO-LABEL
     RECT-23 AT ROW 1.25 COL 1
     RECT-24 AT ROW 6.92 COL 2.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
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
         HEIGHT             = 8.42
         WIDTH              = 70.29.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit L-To-R                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-desc-fam IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-moeda IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN txt-custo IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
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

&Scoped-define SELF-NAME c-fm-codigo1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-codigo1 V-table-Win
ON F5 OF c-fm-codigo1 IN FRAME f-main
DO:
                     
  {include/zoomvar.i &prog-zoom="inzoom/z01in122.w"
                     &campo=c-fm-codigo1
                     &campo2=c-desc-fam
                     &campozoom=fm-codigo
                     &campozoom2=descricao}

                     
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-codigo1 V-table-Win
ON LEAVE OF c-fm-codigo1 IN FRAME f-main
DO:
  {include/leave.i &tabela=familia
                   &atributo-ref=descricao
                   &variavel-ref=c-desc-fam
                   &where="familia.fm-codigo = input frame {&frame-name} c-fm-codigo1"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-fm-codigo1 V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-fm-codigo1 IN FRAME f-main
DO:
  apply "f5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-moeda1
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-moeda1 V-table-Win
ON LEAVE OF i-moeda1 IN FRAME f-main
DO:
  find first moeda
     where moeda.mo-codigo = input frame {&frame-name} i-moeda1 no-lock no-error.

  if input frame {&frame-name} i-moeda1 = 0 then do:
     {utp/ut-liter.i Corrente * L}
     assign c-moeda:screen-value in frame {&frame-name} = return-value.
  end.  
  if input frame {&frame-name} i-moeda1 = 1 and param-estoq.tem-moeda1 then 
     assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
  if input frame {&frame-name} i-moeda1 = 2 and param-estoq.tem-moeda2 then 
     assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  if c-fm-codigo1:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if i-moeda1:load-mouse-pointer     ("image/lupa.cur") in frame {&frame-name} then.

  {utp/ut-rdset.i rs-tipo-custo *}

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

  find first param-estoq  no-lock no-error.
  find first param-global no-lock no-error.

  {utp/ut-field.i mguni moeda mo-codigo 1}
  assign i-moeda1:label in frame {&frame-name} = return-value.
 /* {utp/ut-liter.i Parƒmetros * r}
 *   assign c-tit-par:screen-value in frame {&frame-name} = return-value.
 *   */{utp/ut-liter.i Tipo_de_Custo * r}
  assign txt-custo:screen-value in frame {&frame-name} = return-value.
  {utp/ut-liter.i Per¡odo_1 * L}
  assign c-per-ini1:label in frame {&frame-name} = return-value.
  {utp/ut-liter.i Per¡odo_2 * L}
  assign c-per-fim1:label in frame {&frame-name} = return-value.
  {utp/ut-field.i mgind item fm-codigo 1}
  assign c-fm-codigo1:label in frame {&frame-name} = return-value.

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-define-param V-table-Win 
PROCEDURE pi-define-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input-output param c-per-ini    as char.
  def input-output param c-per-fim    as char.
  def input-output param i-moeda      like moeda.mo-codigo.
  def input-output param c-fm-codigo  like item.fm-codigo.
  def input-output param i-tipo-custo as integer no-undo.

  /* Local Variable Definitions ---                                       */
  def var c-ano as c format "9999".
  def var c-mes as c format "99".

  if i-moeda <> ? then do:
     assign i-moeda1:screen-value in frame {&frame-name} = string(i-moeda).
     if i-moeda = 0 then do:
        {utp/ut-liter.i Corrente * L}
        assign c-moeda:screen-value in frame {&frame-name} = return-value.
     end.
     else do:
        find first moeda where moeda.mo-codigo = i-moeda no-lock no-error.
        assign c-moeda:screen-value in frame {&frame-name} = moeda.descricao.
     end.    
  end. 

  if c-per-ini <> ? then
     assign c-per-ini1:screen-value in frame {&frame-name} = string(c-per-ini).
  else
     assign c-ano = (substring(param-estoq.ult-per-fech,1,4))
            c-mes = (substring(param-estoq.ult-per-fech,5,2))
            c-mes = string(int(c-mes) - 1,"99")
            c-per-ini = string(c-ano) + "/" + string(c-mes)
            c-per-ini1:screen-value in frame {&frame-name} = string(c-per-ini).

  if c-per-fim <> ? then 
     assign c-per-fim1:screen-value in frame {&frame-name} = string(c-per-fim).
  else
     assign c-per-fim1:screen-value in frame {&frame-name} = string(param-estoq.ult-per-fech).

  find first familia where familia.fm-codigo = c-fm-codigo no-lock no-error.
  if avail familia then
     assign c-fm-codigo1:screen-value in frame {&frame-name} = familia.fm-codigo
            c-desc-fam:screen-value   in frame {&frame-name} = familia.descricao.

  assign rs-tipo-custo = i-tipo-custo.
  disp rs-tipo-custo with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-seta-param V-table-Win 
PROCEDURE pi-seta-param :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input-output param c-per-ini    as char.
  def input-output param c-per-fim    as char.
  def input-output param i-moeda      like moeda.mo-codigo.
  def input-output param c-fm-codigo  like item.fm-codigo.
  def input-output param i-tipo-custo as integer no-undo.

  assign c-per-ini1 = input frame {&frame-name} c-per-ini1
         c-per-fim1 = input frame {&frame-name} c-per-fim1.

  if  input frame {&frame-name} i-moeda1 = 1
  and not param-estoq.tem-moeda1 then do:
      run utp/ut-msgs.p (input "show", input 110, input "").
      apply 'entry' to i-moeda1 in frame {&frame-name}. 
      return error.
  end.    
  if  input frame {&frame-name} i-moeda1 = 2
  and not param-estoq.tem-moeda2 then do:
      run utp/ut-msgs.p (input "show", input 111, input "").
      apply 'entry' to i-moeda1 in frame {&frame-name}.
      return error.
  end.
  if input frame {&frame-name} i-moeda1 > 2 then do:
     run utp/ut-msgs.p (input "show", input 3762, input "").
     apply 'entry' to i-moeda1 in frame {&frame-name}. 
     return error.
  end.
  if input frame {&frame-name} c-per-ini1 >= input frame {&frame-name} c-per-fim1 then do:
     run utp/ut-msgs.p (input "show", input 1046, input c-per-ini1).
     apply 'entry' to c-per-ini1 in frame {&frame-name}. 
     return error.
  end.
  if integer(substring(c-per-ini1,5,2)) <= 0
  or integer(substring(c-per-ini1,5,2))  > 12
  or integer(substring(c-per-ini1,1,4)) <= 0 then do:
     run utp/ut-msgs.p (input "show", input 333, input "").
     apply 'entry' to c-per-ini1 in frame {&frame-name}. 
     return error.
  end.
  if integer(substring(c-per-fim1,5,2)) <= 0
  or integer(substring(c-per-fim1,5,2)) > 12
  or integer(substring(c-per-fim1,1,4)) <= 0 then do:
     run utp/ut-msgs.p (input "show", input 333, input "").
     apply 'entry' to c-per-fim1 in frame {&frame-name}. 
     return error.
  end.
  find first familia
     where familia.fm-codigo = input frame {&frame-name} c-fm-codigo1
     no-lock no-error.
  if not avail familia then do:
     run utp/ut-msgs.p (input "show", input 3220, input "").
     apply 'entry' to c-fm-codigo1 in frame {&frame-name}.      
     return error.
  end.

  assign c-per-ini    = input frame {&frame-name} c-per-ini1 
         c-per-fim    = input frame {&frame-name} c-per-fim1
         i-moeda      = input frame {&frame-name} i-moeda1
         c-fm-codigo  = input frame {&frame-name} c-fm-codigo1
         i-tipo-custo = input frame {&frame-name} rs-tipo-custo.
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

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this SmartViewer, and there are no
     tables specified in any contained Browse, Query, or Frame. */

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


