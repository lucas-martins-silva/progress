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
{include/i-prgvrs.i V05IN464 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN464 MUT}
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
def new global shared var r-parent as rowid no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
                              
def var c-msg-1        as char.
def var c-msg-2        as char.
def var c-estado       as char.
def var c-it-codigo    like item.it-codigo.
def var de-quant-usada as decimal.
def var c-quant-usada  as char.
def var c-log-quant-fix     as char.
def var c-fi-qtd-componente as char.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estr-mod-cf
&Scoped-define FIRST-EXTERNAL-TABLE estr-mod-cf


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estr-mod-cf.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estr-mod-cf.num-min-comp ~
estr-mod-cf.num-max-comp estr-mod-cf.qt-min-tot estr-mod-cf.qt-max-tot 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}num-min-comp ~{&FP2}num-min-comp ~{&FP3}~
 ~{&FP1}num-max-comp ~{&FP2}num-max-comp ~{&FP3}~
 ~{&FP1}qt-min-tot ~{&FP2}qt-min-tot ~{&FP3}~
 ~{&FP1}qt-max-tot ~{&FP2}qt-max-tot ~{&FP3}
&Scoped-define ENABLED-TABLES estr-mod-cf
&Scoped-define FIRST-ENABLED-TABLE estr-mod-cf
&Scoped-Define ENABLED-OBJECTS RECT-12 RECT-13 
&Scoped-Define DISPLAYED-FIELDS estr-mod-cf.num-min-comp ~
estr-mod-cf.num-max-comp estr-mod-cf.qt-min-tot estr-mod-cf.qt-max-tot 

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
DEFINE RECTANGLE RECT-12
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 2.42.

DEFINE RECTANGLE RECT-13
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 83 BY 2.42.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estr-mod-cf.num-min-comp AT ROW 1.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     estr-mod-cf.num-max-comp AT ROW 2.25 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 3.72 BY .88
     estr-mod-cf.qt-min-tot AT ROW 3.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     estr-mod-cf.qt-max-tot AT ROW 4.71 COL 21 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 22 BY .88
     RECT-12 AT ROW 1 COL 1
     RECT-13 AT ROW 3.42 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estr-mod-cf
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
         HEIGHT             = 5
         WIDTH              = 83.14.
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
  {src/adm/template/row-list.i "estr-mod-cf"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estr-mod-cf"}

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

  RUN Get-Field-Screen-Value IN adm-broker-hdl (INPUT THIS-PROCEDURE,
                                                INPUT "it-codigo").
      
  assign c-it-codigo = return-value.

  if c-it-codigo <> "" then do:
     assign estr-mod-cf.num-min-comp:sensitive in frame {&frame-name} = no
            estr-mod-cf.num-max-comp:sensitive in frame {&frame-name} = no.
  end.
  else do:
     assign estr-mod-cf.num-min-comp:sensitive in frame {&frame-name} = yes
            estr-mod-cf.num-max-comp:sensitive in frame {&frame-name} = yes.  
  end.
    /* D_MAN002 - Quantidade fixa para componentes de engenharia */
    run get-attribute ('adm-new-record').
    
    IF AVAIL estr-mod-cf THEN
    if adm-new-record = false and estr-mod-cf.log-quant-fix then
        assign estr-mod-cf.qt-min-tot:sensitive in frame {&frame-name} = no
               estr-mod-cf.qt-max-tot:sensitive in frame {&frame-name} = no.
               
    else
        assign estr-mod-cf.qt-min-tot:sensitive in frame {&frame-name} = yes
               estr-mod-cf.qt-max-tot:sensitive in frame {&frame-name} = yes.
  
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atu-numeros V-table-Win 
PROCEDURE pi-atu-numeros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   def input parameter l-habilita as logical.
   
   assign estr-mod-cf.num-min-comp:screen-value in frame {&frame-name} = string(0)
          estr-mod-cf.num-max-comp:screen-value in frame {&frame-name} = string(1).
   assign estr-mod-cf.num-min-comp:sensitive    in frame {&frame-name} = l-habilita
          estr-mod-cf.num-max-comp:sensitive    in frame {&frame-name} = l-habilita.
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atu-quantidades V-table-Win 
PROCEDURE pi-atu-quantidades :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
  def input parameter de-valor-1  as decimal.
  def input parameter de-valor-2  as decimal.
  def input parameter de-qt-usada as decimal.
  
  if de-valor-1 <> ? and
     de-valor-2 <> ? then 
     assign estr-mod-cf.qt-min-tot:screen-value in frame {&frame-name} = string(de-valor-1)
            estr-mod-cf.qt-max-tot:screen-value in frame {&frame-name} = string(de-valor-2).
  assign de-quant-usada = de-qt-usada.
            
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-compon V-table-Win 
PROCEDURE pi-atualiza-compon :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter fi-qtd-componente as decimal.
    define input parameter p-log-quant-fix as logical.
    
    assign estr-mod-cf.qt-max-tot:screen-value in frame {&frame-name} = string(fi-qtd-componente)
           estr-mod-cf.qt-min-tot:sensitive in frame {&frame-name} = not p-log-quant-fix
           estr-mod-cf.qt-max-tot:sensitive in frame {&frame-name} = not p-log-quant-fix.
           
    if p-log-quant-fix then
        estr-mod-cf.qt-min-tot:screen-value in frame {&frame-name} = string(fi-qtd-componente).
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-estado V-table-Win 
PROCEDURE pi-estado :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input parameter p-estado as char no-undo.

assign c-estado = p-estado.

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
 
 if input frame {&frame-name} estr-mod-cf.num-max-comp < 
    input frame {&frame-name} estr-mod-cf.num-min-comp then do:
     {utp/ut-liter.i Min_Componenetes MCF R}  
     assign c-msg-1 = return-value.
     {utp/ut-liter.i Max_Componenetes MCF R}  
     assign c-msg-2 = return-value.
        
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show",
                        input  5820,
                        input c-msg-1 + "~~" + c-msg-2).     
     apply "ENTRY" to estr-mod-cf.num-min-comp in frame {&frame-name}.
     return "ADM-ERROR":U.  
 end.
 
 if input frame {&frame-name} estr-mod-cf.qt-max-tot < 
    input frame {&frame-name} estr-mod-cf.qt-min-tot then do:
         {utp/ut-liter.i Qtde_Min_Total MCF R}  
     assign c-msg-1 = return-value.
     {utp/ut-liter.i Qtde_Max_Total MCF R}  
     assign c-msg-2 = return-value.
        
     {include/i-vldprg.i}
     run utp/ut-msgs.p (input "show",
                        input  5820,
                        input c-msg-1 + "~~" + c-msg-2).     
     apply "ENTRY" to estr-mod-cf.num-min-comp in frame {&frame-name}.
     return "ADM-ERROR":U.   
 end.
        
 if de-quant-usada < input frame {&frame-name} estr-mod-cf.qt-min-tot or
    de-quant-usada > input frame {&frame-name} estr-mod-cf.qt-max-tot then do:
     {include/i-vldprg.i}
     run utp/ut-msgs.p ( input "show",
                         input 15138,
                         input "").     
     apply "ENTRY" to estr-mod-cf.qt-min-tot in frame {&frame-name}.
     return "ADM-ERROR":U.   
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
  {src/adm/template/snd-list.i "estr-mod-cf"}

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


