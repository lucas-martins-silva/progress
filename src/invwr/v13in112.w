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
{include/i-prgvrs.i V13IN112 2.00.00.010}  /*** 010010 ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v13in112 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def temp-table tt-entrega
    field cd-freq        like frequencia.cd-freq /*cod. da frequencia de */
    field nr-sequencia   as integer /* seq. das entregas de cada cod. freq.*/
    field dat-entrega    as date.

def var c-contrato like contrato-for.nr-contrato no-undo.
def var i-num-seq-item as integer no-undo.
def var i-ordem as integer no-undo.
def var i-seq-evento as integer no-undo.
def var c-cod-estabel as char no-undo.

def var da-data-prev as date no-undo.
def var i-cont as integer no-undo.
def var l-confirma as logical no-undo.

def buffer b-evento-ped for evento-ped.

{cdp/cdcfgmat.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key i-frequencia i-num-periodos ~
l-realizado 
&Scoped-Define DISPLAYED-OBJECTS i-frequencia c-frequencia i-num-periodos ~
l-realizado 

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

/* ************************  Function Prototypes ********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-frequencia AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 40 BY .88 NO-UNDO.

DEFINE VARIABLE i-frequencia AS INTEGER FORMAT ">>9" INITIAL 0 
     LABEL "":R12 
     VIEW-AS FILL-IN 
     SIZE 6 BY .88 NO-UNDO.

DEFINE VARIABLE i-num-periodos AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 1 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 78 BY 2.5.

DEFINE VARIABLE l-realizado AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 27 BY .83 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     i-frequencia AT ROW 1.25 COL 21 COLON-ALIGNED HELP
          "FreqÅància de ocorrància do evento."
     c-frequencia AT ROW 1.25 COL 27 COLON-ALIGNED HELP
          "Descriá∆o da frequància de fornecimento dos itens" NO-LABEL
     i-num-periodos AT ROW 2.25 COL 21 COLON-ALIGNED
     l-realizado AT ROW 2.25 COL 42
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 2.58
         WIDTH              = 78.29.
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

/* SETTINGS FOR FILL-IN c-frequencia IN FRAME f-main
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

&Scoped-define SELF-NAME i-frequencia
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-frequencia V-table-Win
ON F5 OF i-frequencia IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom="adzoom\z01ad122.w"
                     &campo=i-frequencia
                     &campozoom=descricao }

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-frequencia V-table-Win
ON LEAVE OF i-frequencia IN FRAME f-main
DO:
  {include/leave.i &tabela=frequencia 
                 &atributo-ref=descricao
                 &variavel-ref=c-frequencia
                 &where="frequencia.cd-freq = input frame {&frame-name} i-frequencia"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-frequencia V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-frequencia IN FRAME f-main
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

{utp/ut-liter.i Eventos_Realizados * L}
  assign l-realizado:label in frame {&frame-name} = return-value.

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
  /* Ponha na pi-validate todas as validaá‰es */
  /* N∆o gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
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
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  if adm-new-record = yes then
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

  assign i-num-periodos = 1.

  {utp/ut-field.i mgadm frequencia cd-freq 1}
  assign i-frequencia:label in frame {&frame-name} = trim (return-value).

  {utp/ut-liter.i Nr._Per°odos MCC l}
  assign i-num-periodos:label in frame {&frame-name} = trim (return-value).

  {utp/ut-liter.i Realizado MCC l}
  assign l-realizado:label in frame {&frame-name} = trim (return-value).

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  disp i-num-periodos with frame {&frame-name}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
     define input parameter v-row-parent-externo as rowid no-undo.

     assign v-row-parent = v-row-parent-externo.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-eventos V-table-Win 
PROCEDURE pi-gera-eventos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 find frequencia where 
      frequencia.cd-freq = input frame {&frame-name} i-frequencia no-lock no-error.
 if not avail frequencia then do:
    {utp/ut-table.i mgadm frequencia 1}
    run utp/ut-msgs.p (input "show",
                       input 56,
                       input return-value).
    apply 'entry' to i-frequencia in frame {&frame-name}.
    return "adm-error".
 end.

 if input frame {&frame-name} i-num-periodos < 1 then do:
    run utp/ut-msgs.p (input "show",
                       input 8782,
                       input "").
    apply 'entry' to i-num-periodos in frame {&frame-name}.
    return "adm-error".
 end.
 for each tt-entrega:
     delete tt-entrega.
 end.

 &if defined(bf_mat_contratos) &then
 assign c-contrato     = int(f-retorna-campo ("nr-contrato"))
 &else
 assign c-contrato     = f-retorna-campo ("nr-contrato")
 &endif
        i-num-seq-item = int (f-retorna-campo ("num-seq-item"))
        i-ordem        = int (f-retorna-campo ("numero-ordem"))
        i-seq-evento   = int (f-retorna-campo ("seq-evento"))
        c-cod-estabel  = f-retorna-campo ("cod-estabel")
        da-data-prev   = date (f-retorna-campo ("dat-prev-entr")).

 find contrato-for where contrato-for.nr-contrato = c-contrato no-lock no-error.

 find item-contrat where 
      item-contrat.num-seq-item = i-num-seq-item and
      item-contrat.nr-contrat   = c-contrato no-lock no-error.
 if avail item-contrat then do:
     run cnp/cn9012.p (input (input frame {&frame-name} i-frequencia),
                       input da-data-prev,
                       input (input frame {&frame-name} i-num-periodos),
                       input-output table tt-entrega).

     do i-cont = 1 to input frame {&frame-name} i-num-periodos:
        create evento-ped.
        assign  evento-ped.nr-contrat   = c-contrato
                evento-ped.num-seq-item = i-num-seq-item
                evento-ped.numero-ordem = i-ordem
                evento-ped.frequencia   = i-frequencia
                evento-ped.cod-estabel  = c-cod-estabel
                l-confirma = no.

        if i-cont = 1 then
           assign evento-ped.seq-evento = int (f-retorna-campo ("seq-evento")).           
        else do:
             do while l-confirma = no:
                assign i-seq-evento = i-seq-evento + 1.
                find first b-evento-ped EXCLUSIVE-LOCK
                     where b-evento-ped.nr-contrat   = c-contrato
                       and b-evento-ped.num-seq-item = i-num-seq-item
                       and b-evento-ped.numero-ordem = i-ordem
                       and b-evento-ped.seq-evento   = i-seq-evento
                       NO-ERROR.           
                if not avail b-evento-ped then assign
                   l-confirma = yes.            
             end.
             assign evento-ped.seq-evento = i-seq-evento.
        end. 

        find first tt-entrega where 
                   tt-entrega.nr-sequencia = i-cont no-error.
        if avail tt-entrega then
           assign da-data-prev = tt-entrega.dat-entrega.

        assign evento-ped.dat-prev-entr = da-data-prev.
               assign evento-ped.dat-nova-realiz = evento-ped.dat-prev-entr.

        assign evento-ped.dat-entr-orig  = evento-ped.dat-prev-entr
               evento-ped.dat-prev-event = evento-ped.dat-prev-entr
               evento-ped.cod-cond-pag   = int (f-retorna-campo ("cod-cond-pag"))
               evento-ped.observacao     = f-retorna-campo ("observacao")
               evento-ped.narrativa      = f-retorna-campo ("narrat-event")
               evento-ped.des-event      = f-retorna-campo ("des-event").
        assign evento-ped.dt-evento      = date(f-retorna-campo ("dt-evento")).       
     end.
 end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE Pi-validate V-table-Win 
PROCEDURE Pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
  {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

   /*Segue um exemplo de validaá∆o de programa 
 *    find tabela where tabela.campo1 = c-variavel and
 *                      tabela.campo2 > i-variavel no-lock no-error.
 *    {include/i-vldprg.i} /* Este include deve ser colocado sempre antes do ut-msgs.p */                  
 *    run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *    return 'ADM-ERROR':U.*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valores V-table-Win 
PROCEDURE pi-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output parameter p-cd-freq      as integer format ">>9".
def output parameter p-num-periodos as integer.
def output parameter p-realizado    as logical.

assign p-cd-freq      = input frame {&frame-name} i-frequencia
       p-num-periodos = input frame {&frame-name} i-num-periodos
       p-realizado    = input frame {&frame-name} l-realizado.

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION f-retorna-campo V-table-Win 
FUNCTION f-retorna-campo RETURNS CHARACTER
  ( input c-campo as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  RUN Get-Field-Screen-Value IN adm-broker-hdl
     (INPUT this-procedure,
      INPUT c-campo).   

  RETURN return-value.   /* Function return value. */

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


