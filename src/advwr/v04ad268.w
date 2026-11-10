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
{include/i-prgvrs.i V04AD268 2.00.00.013} /*** "010013" 06/11/2024 14:04:19  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04AD268 MUT}
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

def new global shared var gr-transporte as rowid no-undo.

/* Local Variable Definitions ---                                       */

def var h-acomp    as handle no-undo.
def var c-caracter as character format "x" initial "-" no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES transporte
&Scoped-define FIRST-EXTERNAL-TABLE transporte


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR transporte.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS transporte.nome transporte.nome-abrev 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}nome ~{&FP2}nome ~{&FP3}~
 ~{&FP1}nome-abrev ~{&FP2}nome-abrev ~{&FP3}
&Scoped-define ENABLED-TABLES transporte
&Scoped-define FIRST-ENABLED-TABLE transporte
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS transporte.cod-transp transporte.nome ~
transporte.nome-abrev 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS transporte.cod-transp 

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
DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 2.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     transporte.cod-transp AT ROW 1.29 COL 28.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8.29 BY .88
     transporte.nome AT ROW 1.29 COL 37.72 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     transporte.nome-abrev AT ROW 2.29 COL 28.86 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.transporte
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
         HEIGHT             = 2.58
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

/* SETTINGS FOR FILL-IN transporte.cod-transp IN FRAME f-main
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



&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
  
  /************************ INTERNAL PROCEDURES ********************/

  run utp/ut-acomp.p persistent set h-acomp.

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
  {src/adm/template/row-list.i "transporte"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "transporte"}

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
  Notes:       Traz automaticamente o codigo do transportador
------------------------------------------------------------------------------*/
  def buffer b-transportador for transporte.

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  find last b-transportador no-lock no-error.
  assign transporte.cod-transp:screen-value in frame {&frame-name} = 
         if avail b-transportador then string(b-transportador.cod-transp + 1)
         else "1".
  
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  {include/i-valid.i}
  
  def buffer b-estab      for estab-cli.
  def buffer b-nota       for nota-fiscal.
  def buffer b-ped        for ped-venda.
  def buffer b-emitente   for emitente.
  def buffer b-imag-for   for imag-for.
  def buffer b-ender-red  for ender-red.
  def buffer b-pre-fatur  for pre-fatur.
  def buffer b-embarque   for embarque.
  
  def var l-altera-nome-abrev as logical   no-undo.
  def var c-nome-transp       as character no-undo.
  def var c-novo-nome         as character no-undo.
  def var r-registro          as rowid     no-undo.
  
  assign l-altera-nome-abrev = no.

Do  on stop undo, return error: 

/*  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  */
  /* Ponha aqui a valida‡Æo de chave duplicada */
  if  transporte.cod-transp:sensitive in frame {&frame-name}
  and can-find(transporte 
         where transporte.cod-transp = input frame {&frame-name} transporte.cod-transp)
  then do:
      {utp/ut-table.i mgadm transporte 1}
      run utp/ut-msgs.p (input "show", input 1, input return-value).
      apply "entry" to transporte.cod-transp in frame {&frame-name}.
      return "adm-error".
  end.
  
  /* Ponha aqui as demais valida‡äes */
  if  transporte.cod-transp:sensitive in frame {&frame-name} then do:
      if  can-find(transporte 
             where transporte.nome-abrev = input frame {&frame-name} 
                   transporte.nome-abrev) then do:
          {utp/ut-table.i mgadm transporte 1}
          run utp/ut-msgs.p (input "show", input 1, input return-value).
          apply "entry" to transporte.nome-abrev in frame {&frame-name}.
          return "adm-error".
      end.
  end.
  else do:
      assign c-nome-transp = transporte.nome-abrev 
             c-novo-nome   = input frame {&frame-name} transporte.nome-abrev.
      if  c-nome-transp <> c-novo-nome then do:
          run utp/ut-msgs.p (input "show", input 26, input "").
          if  return-value = "no" then do:
              assign transporte.nome-abrev:screen-value in frame {&frame-name} = 
                     c-nome-transp.
          end.
          else do:
              assign l-altera-nome-abrev = yes.
          end.
      end.
  end.
  
   if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

 
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

  /* Code placed here will execute AFTER standard behavior.    */

  if   l-altera-nome-abrev then do:
       run utp/ut-acomp.p persistent set h-acomp. 
       run pi-inicializar in h-acomp (input "Processando ... ").

      for each b-estab where b-estab.nome-transp = c-nome-transp no-lock:
          assign r-registro = rowid(b-estab).
          find estab-cli where rowid(estab-cli) = r-registro exclusive-lock no-error.
          assign estab-cli.nome-transp = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-nota
          where b-nota.nome-transp = c-nome-transp
          or    b-nota.nome-tr-red = c-nome-transp no-lock:
          find nota-fiscal where rowid(nota-fiscal) = rowid(b-nota) exclusive-lock.
          if  b-nota.nome-transp = c-nome-transp then
              assign nota-fiscal.nome-transp = c-novo-nome.
          if  b-nota.nome-tr-red = c-nome-transp then
              assign nota-fiscal.nome-tr-red = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-ped
          where b-ped.nome-transp = c-nome-transp
          or    b-ped.nome-tr-red = c-nome-transp no-lock:
          find ped-venda where rowid(ped-venda) = rowid(b-ped) exclusive-lock.
          if  b-ped.nome-transp = c-nome-transp then
              assign ped-venda.nome-transp = c-novo-nome.
          if  b-ped.nome-tr-red = c-nome-transp then
              assign ped-venda.nome-tr-red = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-emitente
          where b-emitente.nome-tr-red = c-nome-transp no-lock:
          find emitente where rowid(emitente) = rowid(b-emitente) exclusive-lock.
          assign emitente.nome-tr-red = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-imag-for
          where b-imag-for.nome-tr-red = c-nome-transp no-lock:
          find imag-for where rowid(imag-for) = rowid(b-imag-for) exclusive-lock.
          assign imag-for.nome-tr-red = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-ender-red
          where b-ender-red.nome-tr-red = c-nome-transp no-lock:
          find ender-red where rowid(ender-red) = rowid(b-ender-red) exclusive-lock.
          assign ender-red.nome-tr-red = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-embarque
          where b-embarque.nome-transp = c-nome-transp no-lock:
          find embarque where rowid(embarque) = rowid(b-embarque) exclusive-lock.
          assign embarque.nome-transp = c-novo-nome.
          run pi-imprime-caracter.
      end.

      for each  b-pre-fatur
          where b-pre-fatur.nome-transp = c-nome-transp
          or    b-pre-fatur.nome-tr-red = c-nome-transp no-lock:
          find pre-fatur where rowid(pre-fatur) = rowid(b-pre-fatur) exclusive-lock.
          if  b-pre-fatur.nome-transp = c-nome-transp then
              assign pre-fatur.nome-transp = c-novo-nome.
          if  b-pre-fatur.nome-tr-red = c-nome-transp then
              assign pre-fatur.nome-tr-red = c-novo-nome.
          run pi-imprime-caracter.
      end.
      
      run pi-finalizar in h-acomp.
  end.
end. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-statement V-table-Win 
PROCEDURE local-assign-statement :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-statement':U ) .

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

 for each cont-tran
     where cont-tran.cod-transp = input frame {&frame-name} transporte.cod-transp exclusive-lock.
     delete cont-tran.
  end.

  /* Code placed here will execute PRIOR to standard behavior. */

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-row-available V-table-Win 
PROCEDURE local-row-available :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
  
  if avail transporte then 
   assign gr-transporte = rowid(transporte).

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-Imprime-Caracter V-table-Win 
PROCEDURE pi-Imprime-Caracter :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       Mostrar ao usuario o processamento efetuado.
------------------------------------------------------------------------------*/

def var c-mensagem as character format "x(50)" no-undo.

assign c-caracter = if c-caracter = "-" then "\"
                    else if c-caracter = "\" then "|"
                         else if c-caracter = "|" then "/"
                              else "-"
       c-mensagem = "      Por favor, aguarde ...    " + c-caracter.
       
run pi-acompanhar in h-acomp (input c-mensagem).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

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
  {src/adm/template/snd-list.i "transporte"}

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


