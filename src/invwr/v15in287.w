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
{include/i-prgvrs.i V15IN287 2.00.00.008} /*** "010008" 09/01/2026 14:41:41  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V15IN287 MUT}
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

def var  i-mo-fasb   as integer  no-undo.
def var  i-mo-cmi    as integer  no-undo.
def var  l-corrige   as logical  no-undo.
def var  i-x         as integer  no-undo.
def var  i-flag      as integer  no-undo.
def var  c-handle    as char     no-undo.
def var  h-viewer    as handle   no-undo.

def new shared var da-dt-cotacao  as date  no-undo.
def new shared var da-iniper-x    as date  no-undo.

def new shared var i-moeda        like cotacao.mo-codigo  no-undo.
def new shared var c-it-codigo    like item.it-codigo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS item-estab.cod-estabel item-estab.it-codigo 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}cod-estabel ~{&FP2}cod-estabel ~{&FP3}~
 ~{&FP1}it-codigo ~{&FP2}it-codigo ~{&FP3}
&Scoped-define ENABLED-TABLES item-estab
&Scoped-define FIRST-ENABLED-TABLE item-estab
&Scoped-Define ENABLED-OBJECTS rt-mold de-saldo 
&Scoped-Define DISPLAYED-FIELDS item-estab.cod-estabel item-estab.it-codigo 
&Scoped-Define DISPLAYED-OBJECTS c-desc-estab c-un c-desc-item de-saldo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-ASSIGN-FIELDS item-estab.cod-estabel 

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
DEFINE VARIABLE c-desc-estab AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-item AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "xx" 
     VIEW-AS FILL-IN 
     SIZE 3.86 BY .88 NO-UNDO.

DEFINE VARIABLE de-saldo AS DECIMAL FORMAT "->>,>>9.99":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.43 BY 7.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     item-estab.cod-estabel AT ROW 2.5 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-desc-estab AT ROW 2.5 COL 28.72 COLON-ALIGNED NO-LABEL
     item-estab.it-codigo AT ROW 3.5 COL 20.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-un AT ROW 3.5 COL 38.72 COLON-ALIGNED HELP
          "Unidade de medida do item." NO-LABEL
     c-desc-item AT ROW 3.5 COL 43.14 COLON-ALIGNED NO-LABEL
     de-saldo AT ROW 4.5 COL 20.86 COLON-ALIGNED
     rt-mold AT ROW 1 COL 1
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
         HEIGHT             = 7.13
         WIDTH              = 84.43.
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

/* SETTINGS FOR FILL-IN c-desc-estab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-item IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN item-estab.cod-estabel IN FRAME f-main
   2                                                                    */
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

&Scoped-define SELF-NAME item-estab.cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON F5 OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   {include/zoom.i &prog-zoom="adzoom/z01ad107.w"
                   &tabela=item-estab
                   &atributo=cod-estabel}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON LEAVE OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
  {include/leave.i &tabela=estabelec
                   &atributo-ref=nome
                   &variavel-ref=c-desc-estab
                   &where="estabelec.cod-estabel = input frame {&frame-name} item-estab.cod-estabel}.

  /*if i-medio = 0 then do:                 
 *      find estabelec where estabelec.cod-estabel = input frame {&frame-name} item-estab.cod-estabel no-lock no-error.
 *      if avail estabelec then do:
 *         assign i-medio = estabelec.custo-contab.
 *      end.
 *   end.*/
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-estab.cod-estabel IN FRAME f-main /* Estabelecimento */
DO:
   apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME item-estab.it-codigo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON F5 OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
   {include/zoom.i &prog-zoom="inzoom/z02in172.w"
                   &tabela=item-estab
                   &atributo=it-codigo} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON LEAVE OF item-estab.it-codigo IN FRAME f-main /* Item */
DO:
   {include/leave.i &tabela=item
                    &atributo-ref=descricao-1
                    &variavel-ref=c-desc-item
                    &where="item.it-codigo = input frame {&frame-name} item-estab.it-codigo"}.
                    
   {include/leave.i &tabela=item
                    &atributo-ref=un
                    &variavel-ref=c-un
                    &where="item.it-codigo = input frame {&frame-name} item-estab.it-codigo"}.
                    
      
   /* VERIFICA SE O ITEM DE ESTOQUE POSSUI SALDO DE ESTOQUE IMPLANTADO */
   find item-estab where item-estab.it-codigo   = input item-estab.it-codigo and
                         item-estab.cod-estabel = input item-estab.cod-estabel no-error.
   if not available item-estab then do:
      run utp/ut-msgs.p (input "show",
                         input 3801,
                         input "").
      apply 'entry' to item-estab.cod-estabel in frame {&frame-name}.                          
      return no-apply.
   end.
   
   
   /* TOTALIZA A QUANTIDADE DO ITEM NO ESTABELECIMENTO */
   assign de-saldo = 0.
   for each saldo-estoq use-index item 
       where saldo-estoq.it-codigo   = item-estab.it-codigo and
             saldo-estoq.cod-estabel = item-estab.cod-estabel no-lock:
       if avail saldo-estoq then do:
          assign de-saldo = de-saldo + saldo-estoq.qtidade-ini.
       end.
   end.
 
   display de-saldo with frame {&frame-name}.
   
   RUN get-link-handle IN adm-broker-hdl
    (INPUT this-procedure, INPUT "passa-valor-target", OUTPUT c-handle).
   do i-x = 1 to num-entries(c-handle):
      assign h-viewer = widget-handle(entry(i-x,c-handle)).
      if valid-handle(h-viewer) then do:
         run pi-inicializa in h-viewer (input rowid(item),
                                        input rowid(item-estab),
                                        input de-saldo).
      end.
   end.

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL item-estab.it-codigo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF item-estab.it-codigo IN FRAME f-main /* Item */
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

 if item-estab.it-codigo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
 if item-estab.cod-estabel:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

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

  enable item-estab.cod-estabel
         item-estab.it-codigo with frame {&frame-name}.
  disable c-desc-estab
          c-un
          c-desc-item 
          de-saldo with frame {&frame-name}.
  
  find first param-global no-lock no-error.
  if not avail param-global then do:
     run utp/ut-msgs.p (input "show",
                        input 16,
                        input "").
     return 'adm-error'.
  end.
  
  find first param-estoq exclusive-lock no-error. 
  if not avail param-estoq then do:
     run utp/ut-msgs.p (input "show",
                        input 1059,
                        input "").
     return 'adm-error'.
  end.
  
/*  if param-estoq.ult-fech-dia < param-estoq.mensal-ate then do:
     run utp/ut-msgs.p (input "show",
                        input 2052,
                        input "").
     apply 'close' to this-procedure.
     return 'adm-error'.
  end. */
  
   if param-estoq.tem-moeda1 and param-estoq.tem-moeda2 then do:
     assign i-moeda = 3.
   end.
   else do: 
      if param-estoq.tem-moeda1 then do:
         assign i-moeda = 1.
      end. 
      if param-estoq.tem-moeda2 then do:
         assign i-moeda = 2.
      end.  
   end.
  
  find param-fasb where param-fasb.ep-codigo = param-global.empresa-prin no-lock no-error.
  if avail param-fasb then do:
     assign i-mo-fasb = param-fasb.moeda-fasb
            i-mo-cmi  = param-fasb.moeda-cmi.   
  end.
    
  {utp/ut-liter.i  Saldo_Inicial * L}
  assign de-saldo:label in frame {&frame-name} = return-value.
  
  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-saldo V-table-Win 
PROCEDURE Pi-saldo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter l-ok as logical initial yes.


   /* VERIFICA SE O ITEM DE ESTOQUE POSSUI SALDO DE ESTOQUE IMPLANTADO */
   find item-estab where item-estab.it-codigo   = input frame {&frame-name} item-estab.it-codigo and
                         item-estab.cod-estabel = input frame {&frame-name} item-estab.cod-estabel no-error.
   if not available item-estab then do:
      run utp/ut-msgs.p (input "show",
                         input 3801,
                         input "").
      apply 'entry' to item-estab.cod-estabel in frame {&frame-name}.                          
      assign l-ok = no.
      return "adm-error":U.
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


