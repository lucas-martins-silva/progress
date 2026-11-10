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
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i V02IN301 2.00.00.006 } /*** 010006 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i v02in301 MUT}
&ENDIF



/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

/* global variable definitions */

def new global shared var gr-ord-prod as rowid no-undo.
def new global shared var gr-oper-ord as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var chCellView    as com-handle no-undo.
def var l-problema    as logical    no-undo.
def var rw-ult-oper   as rowid      no-undo.
def var i-mensagem    as integer    no-undo.

def buffer b-pert-ordem for pert-ordem.
def buffer b-oper-ord   for oper-ord.

def temp-table tt-nivel-pert no-undo
    field rw-pert-ordem as rowid
    field nivel         as integer
    index codigo rw-pert-ordem
    index nivel nivel.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES ord-prod
&Scoped-define FIRST-EXTERNAL-TABLE ord-prod


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR ord-prod.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS bt-inconsist bt-detalhe 

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION-FORWARD cria-chave V-table-Win 
FUNCTION cria-chave RETURNS CHARACTER
  ( input it-codigo as char,
    input op-codigo as integer,
    input cod-roteiro as char )  FORWARD.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of handles for OCX Containers                            */
DEFINE VARIABLE CtrlFrame AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE chCtrlFrame AS COMPONENT-HANDLE NO-UNDO.

/* Definitions of the field level widgets                               */
DEFINE BUTTON bt-detalhe 
     LABEL "" 
     SIZE 12 BY 1.13.

DEFINE BUTTON bt-inconsist 
     LABEL "" 
     SIZE 12 BY 1.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     bt-inconsist AT ROW 9.54 COL 1.14
     bt-detalhe AT ROW 9.54 COL 13.14
     SPACE(60.43) SKIP(0.00)
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.ord-prod
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
         HEIGHT             = 9.71
         WIDTH              = 84.72.
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



/* **********************  Create OCX Containers  ********************** */

&ANALYZE-SUSPEND _CREATE-DYNAMIC

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN

CREATE CONTROL-FRAME CtrlFrame ASSIGN
       FRAME        = FRAME f-main:HANDLE
       ROW          = 1.08
       COLUMN       = 1.14
       HEIGHT       = 8.46
       WIDTH        = 84.43
       HIDDEN       = no
       SENSITIVE    = yes.

PROCEDURE adm-create-controls:
      CtrlFrame:NAME = "CtrlFrame":U .
/* CtrlFrame OCXINFO:CREATE-CONTROL from: {03F241EA-CC94-11D2-B5FF-006097135C1C} type: CellView */
      CtrlFrame:MOVE-BEFORE(bt-inconsist:HANDLE IN FRAME f-main).

END PROCEDURE.

&ENDIF

&ANALYZE-RESUME /* End of _CREATE-DYNAMIC */


/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME bt-detalhe
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-detalhe V-table-Win
ON CHOOSE OF bt-detalhe IN FRAME f-main
DO:
  if gr-oper-ord <> ? then do:
     assign {&window-name}:sensitive = no.
     run cpp/cp0510a.w (input rowid(ord-prod),
                        input rowid(oper-ord)).
     assign {&window-name}:sensitive = yes.
  end.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME bt-inconsist
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL bt-inconsist V-table-Win
ON CHOOSE OF bt-inconsist IN FRAME f-main
DO:
  IF NOT AVAIL param-global THEN
      FIND FIRST param-global NO-LOCK NO-ERROR.

  IF not avail param-sfc then
      find first param-sfc no-lock no-error.

  if (ord-prod.rep-prod = 2  or
      ord-prod.rep-prod = 3) or
     (ord-prod.rep-prod  = 1 and
      param-global.modulo-ch AND
      AVAIL param-sfc AND
      param-sfc.log-consid-rede-pert) THEN
      run cpp/cp9000.p (input rowid (ord-prod),
                        input yes,
                        output l-problema,
                        output rw-ult-oper,
                        output i-mensagem).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME CtrlFrame
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame V-table-Win
PROCEDURE CtrlFrame.CellView.Click .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    Key
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Key AS CHARACTER NO-UNDO.

find oper-ord where
     rowid (oper-ord) = to-rowid (p-Key) no-lock no-error.
     
assign gr-oper-ord = rowid (oper-ord)
       bt-detalhe:sensitive in frame {&frame-name} = (gr-oper-ord <> ?).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL CtrlFrame V-table-Win
PROCEDURE CtrlFrame.CellView.DblClick .
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  Required for OCX.
    Key
  Notes:       
------------------------------------------------------------------------------*/

DEFINE INPUT PARAMETER p-Key AS CHARACTER NO-UNDO.

find oper-ord where
     rowid (oper-ord) = to-rowid (p-Key) no-lock no-error.
     
assign gr-oper-ord = rowid (oper-ord)
       bt-detalhe:sensitive in frame {&frame-name} = (gr-oper-ord <> ?).

if bt-detalhe:sensitive in frame {&frame-name} then
   apply 'choose' to bt-detalhe in frame {&frame-name}.
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "ord-prod"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "ord-prod"}

  /* Process the newly available records (i.e. display fields,
     open queries, and/or pass records on to any RECORD-TARGETS).    */
  {src/adm/template/row-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE control_load V-table-Win _CONTROL-LOAD
PROCEDURE control_load :
/*------------------------------------------------------------------------------
  Purpose:     Load the OCXs    
  Parameters:  <none>
  Notes:       Here we load, initialize and make visible the 
               OCXs in the interface.                        
------------------------------------------------------------------------------*/

&IF "{&OPSYS}" = "WIN32":U AND "{&WINDOW-SYSTEM}" NE "TTY":U &THEN
DEFINE VARIABLE UIB_S    AS LOGICAL    NO-UNDO.
DEFINE VARIABLE OCXFile  AS CHARACTER  NO-UNDO.

OCXFile = SEARCH( "invwr/v02in301.wrx":U ).

IF OCXFile <> ? THEN DO:
  ASSIGN
    chCtrlFrame = CtrlFrame:COM-HANDLE
    UIB_S = chCtrlFrame:LoadControls( OCXFile, "CtrlFrame":U)
  .
  RUN DISPATCH IN THIS-PROCEDURE("initialize-controls":U) NO-ERROR.
END.

&ENDIF

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE initialize-controls V-table-Win 
PROCEDURE initialize-controls :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  chCellView = chctrlframe:CellView.
  
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
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
  
  chCellView:ClearCells.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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
  
  {utp/ut-liter.i Inconsistˆncias * l}
  assign bt-inconsist:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Detalhar * l}
  assign bt-detalhe:label in frame {&frame-name} = return-value.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

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

  /* Code placed here will execute AFTER standard behavior.    */
  
  RUN set-cursor IN adm-broker-hdl (INPUT "WAIT").
  
  assign bt-inconsist:sensitive in frame {&frame-name} = no
         bt-detalhe:sensitive   in frame {&frame-name} = no.
  
  for each tt-nivel-pert:
      delete tt-nivel-pert.
  end.
    
  if avail ord-prod then do:
     assign gr-ord-prod   = rowid (ord-prod)
            gr-oper-ord   = ?.
     chCellView:ClearCells.
     run cpp/cp9000.p (input rowid (ord-prod),
                       input no,
                       output l-problema,
                       output rw-ult-oper,
                       output i-mensagem).
     if rw-ult-oper <> ? then do:
        if l-problema then
           assign chCellView:ForeColor = 4095.
        else
            assign chCellView:ForeColor = 0.
            
        find oper-ord where rowid (oper-ord) = rw-ult-oper no-lock no-error.    
                
        for  each pert-ordem 
            where pert-ordem.nr-ord-prod = ord-prod.nr-ord-prod
              and pert-ordem.it-codigo   = oper-ord.it-codigo
              and pert-ordem.op-codigo   = oper-ord.op-codigo
              and pert-ordem.cod-roteiro = oper-ord.cod-roteiro no-lock:
            create tt-nivel-pert.
            assign tt-nivel-pert.rw-pert-ordem = rowid (pert-ordem)
                   tt-nivel-pert.nivel         = 0.
            run pi-navega-rede-pert (buffer pert-ordem,
                                     input 1).                   
        end.
        
        find first tt-nivel-pert no-error.
        
        if avail tt-nivel-pert then do:                                                                  
           for each tt-nivel-pert
               by tt-nivel-pert.nivel:
               find pert-ordem where
                    rowid (pert-ordem) = tt-nivel-pert.rw-pert-ordem NO-LOCK NO-ERROR.
                     
               find oper-ord where
                    oper-ord.nr-ord-prod = ord-prod.nr-ord-prod and
                    oper-ord.it-codigo   = pert-ordem.it-predec and
                    oper-ord.op-codigo   = pert-ordem.op-predec and
                    oper-ord.cod-roteiro = rot-predec no-lock no-error.
                    
               find b-oper-ord where
                    b-oper-ord.nr-ord-prod = ord-prod.nr-ord-prod and
                    b-oper-ord.it-codigo   = pert-ordem.it-codigo and
                    b-oper-ord.op-codigo   = pert-ordem.op-codigo and
                    b-oper-ord.cod-roteiro = pert-ordem.cod-roteiro no-lock no-error.                 
                       
               if avail oper-ord and avail b-oper-ord then
                  chCellView:AddLink (tt-nivel-pert.nivel,
                                      string (rowid (oper-ord)),
                                      cria-chave (pert-ordem.it-predec,
                                                  pert-ordem.op-predec,
                                                  pert-ordem.rot-predec) +
                                      (if oper-ord.pto-controle > 0 then
                                          " (" + string (oper-ord.pto-controle) + ")"
                                       else ""),
                                      oper-ord.descricao,
                                      string (rowid (b-oper-ord)),
                                      cria-chave (pert-ordem.it-codigo,
                                                  pert-ordem.op-codigo,
                                                  pert-ordem.cod-roteiro) +
                                      (if b-oper-ord.pto-controle > 0 then
                                          " (" + string (b-oper-ord.pto-controle) + ")"
                                       else ""),
                                      b-oper-ord.descricao).
           end.
           
           find oper-ord where rowid (oper-ord) = rw-ult-oper NO-LOCK NO-ERROR.
           assign bt-inconsist:sensitive in frame {&frame-name} = l-problema
                  chCellView:CellForeColor (string (rowid (oper-ord))) = 16711680.           
        end.
     end.
  end.                                                           
  
  RUN set-cursor IN adm-broker-hdl (INPUT "").

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-navega-rede-pert V-table-Win 
PROCEDURE pi-navega-rede-pert :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
define parameter buffer b1-pert-ordem for pert-ordem.
define input parameter  i-nivel       as integer no-undo.

define buffer b2-pert-ordem for pert-ordem.
for each  b2-pert-ordem 
    where b2-pert-ordem.nr-ord-prod = ord-prod.nr-ord-prod
      and b2-pert-ordem.it-codigo   = b1-pert-ordem.it-predec
      and b2-pert-ordem.cod-roteiro = b1-pert-ordem.rot-predec
      and b2-pert-ordem.op-codigo   = b1-pert-ordem.op-predec no-lock:   
      
    if not can-find (tt-nivel-pert where
                     tt-nivel-pert.rw-pert-ordem = rowid (b2-pert-ordem)) then do: 
       create tt-nivel-pert.
       assign tt-nivel-pert.rw-pert-ordem = rowid (b2-pert-ordem)
              tt-nivel-pert.nivel         = i-nivel.      
    end.
    if i-mensagem <> 16636 then 
       run pi-navega-rede-pert (buffer b2-pert-ordem,
                                input  i-nivel + 1).
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
    
/*/*    Segue um exemplo de valida‡Æo de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

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
  {src/adm/template/snd-list.i "ord-prod"}

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


/* ************************  Function Implementations ***************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _FUNCTION cria-chave V-table-Win 
FUNCTION cria-chave RETURNS CHARACTER
  ( input it-codigo as char,
    input op-codigo as integer,
    input cod-roteiro as char ) :
/*------------------------------------------------------------------------------
  Purpose:  
    Notes:  
------------------------------------------------------------------------------*/

  if cod-roteiro = "" then
     RETURN string (op-codigo) + " - " + lc (it-codigo).
  else
      RETURN string (op-codigo) + " - " + lc (cod-roteiro) + " - " + lc (it-codigo).

END FUNCTION.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


