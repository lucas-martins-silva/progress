&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
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
{include/i-prgvrs.i V02IN223 2.00.00.003}

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V02IN223 MUT}
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
def var de-lim-inferior as decimal no-undo.
def var de-lim-superior as decimal no-undo.
def var de-valor        as decimal no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES movto-pend
&Scoped-define FIRST-EXTERNAL-TABLE movto-pend


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR movto-pend.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS movto-pend.quantidade movto-pend.un 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}quantidade ~{&FP2}quantidade ~{&FP3}~
 ~{&FP1}un ~{&FP2}un ~{&FP3}
&Scoped-define ENABLED-TABLES movto-pend
&Scoped-define FIRST-ENABLED-TABLE movto-pend
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS movto-pend.quantidade movto-pend.un ~
movto-pend.valor-mat[1] movto-pend.valor-mat[2] movto-pend.valor-mat[3] ~
movto-pend.valor-mob[1] movto-pend.valor-mob[2] movto-pend.valor-mob[3] 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.86 BY 11.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     movto-pend.quantidade AT ROW 2.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     movto-pend.un AT ROW 3.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.14 BY .88
     movto-pend.valor-mat[1] AT ROW 4.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mat[2] AT ROW 5.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mat[3] AT ROW 6.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob[1] AT ROW 7.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob[2] AT ROW 8.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     movto-pend.valor-mob[3] AT ROW 9.71 COL 37.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.29 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .

 

/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.movto-pend
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
         HEIGHT             = 11.67
         WIDTH              = 86.86.
                                                                        */
&ANALYZE-RESUME


/* ***************  Runtime Attributes and UIB Settings  ************** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit Default                                      */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN movto-pend.valor-mat[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mat[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mat[3] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mob[1] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mob[2] IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN movto-pend.valor-mob[3] IN FRAME f-main
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

&Scoped-define SELF-NAME movto-pend.valor-mat[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.valor-mat[1] V-table-Win
ON LEAVE OF movto-pend.valor-mat[1] IN FRAME f-main /* Valor Mat[1] */
DO:
    if  param-estoq.tem-moeda1 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 1, input movto-pend.valor-mat[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mat[2]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
    if  param-estoq.tem-moeda2 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 2, input movto-pend.valor-mat[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mat[3]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME movto-pend.valor-mob[1]
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL movto-pend.valor-mob[1] V-table-Win
ON LEAVE OF movto-pend.valor-mob[1] IN FRAME f-main /* Valor MOB[1] */
DO:
    if  param-estoq.tem-moeda1 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 1, input movto-pend.valor-mob[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mob[2]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
    if  param-estoq.tem-moeda2 then do with frame {&frame-name}:
        run cdp/cd0813.p (input 0, input 2, input movto-pend.valor-mob[1], 
                          input docum-est.dt-trans, output de-valor).
        assign movto-pend.valor-mob[3]:screen-value = if de-valor = ? then "0"
                                                      else string(de-valor).
    end.
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

  find first param-estoq no-lock no-error.
  find docum-est where rowid(docum-est) = v-row-parent no-lock no-error.

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
  {src/adm/template/row-list.i "movto-pend"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "movto-pend"}

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

  /* Code placed here will execute AFTER standard behavior.    */
  if  avail param-estoq then do with frame {&frame-name}:
      assign movto-pend.valor-mat[2]:sensitive = param-estoq.tem-moeda1
             movto-pend.valor-mat[3]:sensitive = param-estoq.tem-moeda2
             movto-pend.valor-mob[2]:sensitive = param-estoq.tem-moeda1
             movto-pend.valor-mob[3]:sensitive = param-estoq.tem-moeda2.
  end.           
             
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campo V-table-Win 
PROCEDURE pi-inicializa-campo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  def input param rw-parcela as rowid no-undo.
  
  find prazo-compra where rowid(prazo-compra) = rw-parcela no-lock no-error.
  find ordem-compra where ordem-compra.numero-ordem = prazo-compra.numero-ordem
       no-lock no-error.
  find item where item.it-codigo = ordem-compra.it-codigo no-lock no-error.
  find familia where familia.fm-codigo = item.fm-codigo no-lock no-error.
  assign de-lim-inferior = prazo-compra.quantidade * familia.var-qtd-perm / 100
         de-lim-superior = prazo-compra.quant-saldo + de-lim-inferior
         de-lim-inferior = prazo-compra.quant-saldo - de-lim-inferior.
  display prazo-compra.quant-saldo @ movto-pend.quantidade
          prazo-compra.un          @ movto-pend.un
          with frame {&frame-name}.
          
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
   
  if  param-global.modulo-cc
  and input frame {&frame-name} movto-pend.quantidade > de-lim-inferior then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 5517, input "").
      if  param-re.aceita-var then do:
          {utp/ut-liter.i Quantidade MRE R}
          run utp/ut-msgs.p (input "show":U, input 6164, input return-value).
          if  return-value = "no" then do:
              apply "entry" to movto-pend.quantidade in frame {&frame-name}.
              return 'ADM-ERROR':U.
          end.    
      end.
      run rep/re9997.p (input v-row-parent,
                        input (de-lim-inferior + de-lim-superior) / 2,
                        input input frame {&frame-name} movto-pend.quantidade,
                        input 5517, input no).  
  end.
  else 
      run rep/re9997.p (input v-row-parent,
                        input (de-lim-inferior + de-lim-superior) / 2,
                        input input frame {&frame-name} movto-pend.quantidade,
                        input 5517, input yes).  
  RUN Get-Field-Screen-Value IN adm-broker-hdl
      (INPUT this-procedure, INPUT "it-codigo").
  find item where item.it-codigo = return-value no-lock no-error.
  if  input frame {&frame-name} movto-pend.un <> item.un 
  and item.tipo-contr <> 4 then do:
      {include/i-vldprg.i} 
      run utp/ut-msgs.p (input "show":U, input 1225, input "").
      apply "entry" to movto-pend.quantidade in frame {&frame-name}.
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
  {src/adm/template/snd-list.i "movto-pend"}

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


