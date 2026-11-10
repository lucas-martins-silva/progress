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
{include/i-prgvrs.i V23IN271 2.00.00.012}  /*** 010012 ***/
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
def new global shared var v-row-parent as rowid  no-undo.                                
def new global shared var gr-ord-prod  as rowid  no-undo.
def new global shared var gr-item      as rowid  no-undo.
def new global shared var h-acomp      as handle no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def var c-handle-browse  as char   initial "".
def var wh-handle-browse as handle.

def var c-handle  as char    no-undo.
def var h-handle  as handle  no-undo.
def var i-cont    as integer no-undo.
def var c-erro    as char    no-undo.
def var c-texto   as char    no-undo.
def var c-retorno as char    no-undo.
def var l-erro    as logical no-undo.

def var i-prioridade   as integer init 3   no-undo.
def var l-reaproveita  as logical          no-undo.
def var l-deposito     as logical          no-undo.
def var l-aloca-altern as logical          no-undo.
def var l-erro-valid   as logical          no-undo.
def var l-prim-exec    as logical init yes no-undo.


{cpp/cpapi013.i}
{cpp/cpapi013.i1}
{cdp/cd0666.i}

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
&Scoped-Define ENABLED-FIELDS ord-prod.sit-aloc 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES ord-prod
&Scoped-define FIRST-ENABLED-TABLE ord-prod
&Scoped-Define ENABLED-OBJECTS rt-key RECT-12 RECT-11 
&Scoped-Define DISPLAYED-FIELDS ord-prod.nr-ord-produ ord-prod.it-codigo ~
ord-prod.qt-ordem ord-prod.un ord-prod.cod-refer ord-prod.sit-aloc 
&Scoped-Define DISPLAYED-OBJECTS fi-estado RS-TIPO-MOVIMENTO fi-perc ~
fi-label-retangulo-2 fi-label-retangulo 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS RS-TIPO-MOVIMENTO ord-prod.sit-aloc 

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
DEFINE VARIABLE fi-estado AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo-2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 19 BY .63 NO-UNDO.

DEFINE VARIABLE fi-perc AS DECIMAL FORMAT ">>9.99":U INITIAL 100 
     LABEL "%" 
     VIEW-AS FILL-IN 
     SIZE 9 BY .88 NO-UNDO.

DEFINE VARIABLE RS-TIPO-MOVIMENTO AS INTEGER 
     VIEW-AS RADIO-SET HORIZONTAL
     RADIO-BUTTONS 
          "Estornar Aloca‡äes Anteriores", 2,
"Alocar", 1
     SIZE 48 BY .79 NO-UNDO.

DEFINE RECTANGLE RECT-11
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 1.33.

DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 62 BY 1.33.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 90 BY 7.54.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     ord-prod.nr-ord-produ AT ROW 1.25 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     fi-estado AT ROW 1.25 COL 61 COLON-ALIGNED
     ord-prod.it-codigo AT ROW 2.33 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ord-prod.qt-ordem AT ROW 3.42 COL 24 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     ord-prod.un AT ROW 3.42 COL 42 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     ord-prod.cod-refer AT ROW 3.42 COL 61 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15 BY .88
     RS-TIPO-MOVIMENTO AT ROW 5.29 COL 22 NO-LABEL
     fi-perc AT ROW 7.17 COL 66 COLON-ALIGNED
     ord-prod.sit-aloc AT ROW 7.21 COL 22 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Total", 1,
"Parcial", 2,
"Proporcional", 3
          SIZE 42 BY .79
     fi-label-retangulo-2 AT ROW 4.63 COL 19 COLON-ALIGNED NO-LABEL
     fi-label-retangulo AT ROW 6.5 COL 19 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     RECT-12 AT ROW 5.04 COL 16
     RECT-11 AT ROW 6.92 COL 16
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
         HEIGHT             = 7.54
         WIDTH              = 90.43.
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

/* SETTINGS FOR FILL-IN ord-prod.cod-refer IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo-2 IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-perc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.nr-ord-produ IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN ord-prod.qt-ordem IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR RADIO-SET RS-TIPO-MOVIMENTO IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR RADIO-SET ord-prod.sit-aloc IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN ord-prod.un IN FRAME f-main
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

&Scoped-define SELF-NAME RS-TIPO-MOVIMENTO
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL RS-TIPO-MOVIMENTO V-table-Win
ON VALUE-CHANGED OF RS-TIPO-MOVIMENTO IN FRAME f-main
DO:
   assign fi-perc = 100
          l-erro  = no.
   disp fi-perc with frame {&frame-name}.
   if input frame {&frame-name} rs-tipo-movimento = 1 
   then do:
      assign ord-prod.sit-aloc:sensitive in frame {&frame-name} = true.
      apply "value-changed" to ord-prod.sit-aloc in frame {&frame-name}.
   end.   
   else do:
      assign ord-prod.sit-aloc:sensitive in frame {&frame-name} = false.  
      for each tt-reservas:
          delete tt-reservas.
      end.
      run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
      run notify ('pi-recebe-tt-res-aloc,record-target').   
   end. 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME ord-prod.sit-aloc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL ord-prod.sit-aloc V-table-Win
ON VALUE-CHANGED OF ord-prod.sit-aloc IN FRAME f-main /* Aloc */
DO:
   assign l-erro = no.
   if input frame {&frame-name} rs-tipo-movimento = 1 then do:  
      RUN set-cursor IN adm-broker-hdl (INPUT "WAIT").
      run pi-carrega-tt-reservas in h-handle (input (input frame {&frame-name} ord-prod.sit-aloc),
                                              input  ord-prod.nr-ord-prod,
                                              input  i-prioridade,
                                              input  no,
                                              input  l-aloca-altern,
                                              output fi-perc,
                                              output c-erro,
                                              output c-texto).                                             
      disp fi-perc with frame {&frame-name}.                                        
      if return-value = "nok" then do:
         assign l-erro = yes.
         for each tt-reservas:
             delete tt-reservas.
         end.
         run pi-recebe-tt-reservas in h-handle (input table tt-reservas).
         do i-cont = 1 to num-entries (c-erro):
            run utp/ut-msgs.p (input "show",
                               input int (entry (i-cont, c-erro)),
                               input entry (i-cont, c-texto)).
         end.
      end.  

      run notify ('pi-recebe-tt-res-aloc,record-target').                     
      RUN set-cursor IN adm-broker-hdl (INPUT "").   
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


{utp/ut-field.i mgind ord-prod estado 1}.
assign fi-estado:Label = return-value.

{utp/ut-rtlbl.i mgind ord-prod sit-aloc fi-label-retangulo}

{utp/ut-liter.i Tipo_de_Movimento MCP R}
assign fi-label-retangulo-2:screen-value in frame {&frame-name} = " " + return-value
       fi-label-retangulo-2                                     = " " + return-value.

{utp/ut-rdset.i rs-tipo-movimento MCP}

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

  if l-erro then do:
     do i-cont = 1 to num-entries (c-erro):
        run utp/ut-msgs.p (input "show",
                           input int (entry (i-cont, c-erro)),
                           input entry (i-cont, c-texto)).
     end.
     return "adm-error".
  end.

  if input frame {&frame-name} rs-tipo-movimento = 2 then do:
     /* Confirma estorno da ordem ? */
     run utp/ut-msgs.p (input "show",
                        input  1695 ,
                        input  "").                     
     if return-value = "no" then return "adm-error".    
  end.

  for each tt-alocacao:
      delete tt-alocacao.
  end.

  create tt-alocacao.
  assign tt-alocacao.cod-versao-integracao = 001
         tt-alocacao.tipo-trans   = input frame {&frame-name} rs-tipo-movimento
         tt-alocacao.nr-ord-produ = ord-prod.nr-ord-produ
         tt-alocacao.prioridade   = i-prioridade
         tt-alocacao.sit-aloc     = input frame {&frame-name} ord-prod.sit-aloc
         tt-alocacao.informa-dep  = yes
         tt-alocacao.reaproveita  = l-reaproveita
         tt-alocacao.aloca-altern = l-aloca-altern
         tt-alocacao.prog-seg     = "cp0315".

  run pi-recebe-tt-alocacao in h-handle (input table tt-alocacao).

  run pi-retorna-tt-deposito in h-handle (output table tt-deposito).

  run pi-valida-alocacao in h-handle (input  yes,
                                      input  ord-prod.nr-ord-prod,
                                      input  tt-alocacao.tipo-trans,
                                      input  "cp",
                                      output c-erro,
                                      output c-texto). 

  assign c-retorno = return-value.       

  do i-cont = 1 to num-entries (c-erro):
     run utp/ut-msgs.p (input "show",
                        input int (entry (i-cont, c-erro)),
                        input entry (i-cont, c-texto)).
  end.

  if c-retorno = "nok" then return "adm-error". 

  run notify ('pi-validate,record-target').

  if return-value = "adm-error" then
     return "adm-error".

  /* Chamada EPC para a assign record */
     {include/i-epc003.i}   

  run utp/ut-acomp.p persistent set h-acomp.
  if tt-alocacao.tipo-trans = 1 then Do:
     {utp/ut-liter.i Processando_Aloca‡Æo *}
     run pi-inicializar in h-acomp ( Return-value ).
End.
  else Do:
      {utp/ut-liter.i Processando_Desaloca‡Æo *}
      run pi-inicializar in h-acomp ( Return-value ).
End.

  run pi-desabilita-cancela in h-acomp.                          

  run pi-processa-alocacoes in h-handle (input        table tt-alocacao,
                                         input        table tt-deposito,
                                         input-output table tt-erro,
                                         input        yes).

  run pi-finalizar in h-acomp.                                         

  assign c-retorno = return-value.

  find first tt-erro no-error.
  if avail tt-erro then
     run cdp/cd0666.p (input table tt-erro).

  if c-retorno = "nok" then
     return "adm-error".  

  if tt-alocacao.tipo-trans = 2 then
     run utp/ut-msgs.p (input "show",
                        input 1932  ,
                        input ""    ).                                         
  else
      run utp/ut-msgs.p (input "show" ,
                         input 1948   ,
                         input ""     ).

  /* Ponha na pi-validate todas as valida‡äes */
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */

  run dispatch in this-procedure ("display-fields").

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

  run notify ('pi-desabilita-campos,record-target').

  assign fi-perc = 100
         l-erro = no.
  disp fi-perc with frame {&frame-name}.

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
  if avail ord-prod then DO:
     RUN utp/ut-liter.p (trim({ininc/i01in271.i 03}), "*", "").
     assign fi-estado = entry (ord-prod.estado, RETURN-VALUE).
  END.
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

  if rs-tipo-movimento:sensitive in frame {&frame-name} then do:
     if input frame {&frame-name} rs-tipo-movimento eq 2 then
        assign ord-prod.sit-aloc:sensitive in frame {&frame-name} = false.
     else
         apply "value-changed" to ord-prod.sit-aloc in frame {&frame-name}.  

     run notify ('pi-habilita-campos,record-target').    
  end.
  else do:  
      /* Dispatch standard ADM method.                             */
      RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

      /* Code placed here will execute AFTER standard behavior.    */
      &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif
  end.

  assign l-erro = no.

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
   RUN get-link-handle IN adm-broker-hdl
      (INPUT  this-procedure:handle,
       INPUT  "record-target",
       OUTPUT c-handle-browse).
   assign wh-handle-browse = (widget-handle(c-handle-browse)).       

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
  if  avail(ord-prod) then
      assign gr-ord-prod = rowid(ord-prod). 

  if  avail item then
      assign gr-item = rowid(item).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parametros V-table-Win 
PROCEDURE pi-atualiza-parametros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-prioridade   as integer no-undo.
def input parameter p-reaproveita  as logical no-undo.
def input parameter p-deposito     as logical no-undo.
def input parameter p-aloca-altern as logical no-undo.

assign i-prioridade   = p-prioridade
       l-reaproveita  = p-reaproveita
       l-deposito     = p-deposito
       l-aloca-altern = p-aloca-altern.

if ord-prod.sit-aloc:sensitive in frame {&frame-name} and
   input frame {&frame-name} rs-tipo-movimento = 1 then       
   apply "value-changed" to ord-prod.sit-aloc in frame {&frame-name}.       

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle V-table-Win 
PROCEDURE pi-recebe-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
RUN Who-Is-The-Container IN adm-broker-hdl
    (INPUT  this-procedure,
     OUTPUT c-handle).

run get-attribute in widget-handle (c-handle) (input 'HANDLE').

assign h-handle = widget-handle (return-value).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-ordem V-table-Win 
PROCEDURE pi-valida-ordem :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

run pi-valida-ordem in h-handle (input yes,
                                 input ord-prod.nr-ord-prod,
                                 input "cp",
                                 output c-erro,
                                 output c-texto).           
assign c-retorno = return-value.
do i-cont = 1 to num-entries (c-erro):
   run utp/ut-msgs.p (input "show",
                      input int (entry (i-cont, c-erro)),
                      input entry (i-cont, c-texto)).
end.
return c-retorno.

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

  /* Include com os tratamentos necess rios … valida‡Æo antes que se 
     habilite os campos                                           */ 

 {cpp/cp9100.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


