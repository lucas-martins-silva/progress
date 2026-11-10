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
{include/i-prgvrs.i V05IN025 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V05IN025 MUT}
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
def new global shared var v-row-parent  as rowid no-undo.                                
def new global shared var gr-calen-data as rowid no-undo.
/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var c-dias-semana as char no-undo.
def var c-tipos-dia   as char no-undo.
def var c-label as char no-undo.

def var c-hora-ini    as char format "x(6)"    extent 5.
def var c-hora-fim    as char format "x(6)"    extent 5.
def var c-turno       like calen-prod.turno    extent 5.
def var i-cont        as integer.
def var i-auxiliar    as integer.
def buffer b-calen-data  for  calen-data.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES calen-data
&Scoped-define FIRST-EXTERNAL-TABLE calen-data


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR calen-data.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS calen-data.tipo-dia calen-data.dia-manut 
&Scoped-define FIELD-PAIRS
&Scoped-define ENABLED-TABLES calen-data
&Scoped-define FIRST-ENABLED-TABLE calen-data
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold-2 RECT-2 
&Scoped-Define DISPLAYED-FIELDS calen-data.cd-calen calen-data.data ~
calen-data.tipo-dia calen-data.dia-manut 
&Scoped-Define DISPLAYED-OBJECTS fi-desc-calen fi-dia-semana ~
fi-label-tipo-dia 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS calen-data.cd-calen calen-data.data 

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
DEFINE VARIABLE fi-desc-calen AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-dia-semana AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 35.72 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-tipo-dia AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 22 BY .71 NO-UNDO.

DEFINE RECTANGLE RECT-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 60 BY 1.46.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.29 BY 2.29.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 81.43 BY 3.71.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     calen-data.cd-calen AT ROW 1.25 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 13 BY .88
     fi-desc-calen AT ROW 1.25 COL 35 COLON-ALIGNED NO-LABEL
     calen-data.data AT ROW 2.25 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     fi-dia-semana AT ROW 2.25 COL 35 COLON-ALIGNED NO-LABEL
     calen-data.tipo-dia AT ROW 4.33 COL 24.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "étil", 1,
"Descanso", 2,
"Feriado", 3
          SIZE 38.43 BY .83
     calen-data.dia-manut AT ROW 5.79 COL 13.14
          VIEW-AS TOGGLE-BOX
          SIZE 29.72 BY .75
     fi-label-tipo-dia AT ROW 3.67 COL 12.72 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold-2 AT ROW 3.42 COL 1
     RECT-2 AT ROW 4.04 COL 12.57
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.calen-data
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
         HEIGHT             = 6.25
         WIDTH              = 81.72.
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

/* SETTINGS FOR FILL-IN calen-data.cd-calen IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN calen-data.data IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN fi-desc-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-dia-semana IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-tipo-dia IN FRAME f-main
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

&Scoped-define SELF-NAME calen-data.cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL calen-data.cd-calen V-table-Win
ON F5 OF calen-data.cd-calen IN FRAME f-main /* Calend rio */
DO:
   assign  l-implanta = yes.
   { include/zoomvar.i &prog-zoom = "inzoom/z01in026.w"
                       &campo     = calen-data.cd-calen
                       &campozoom = cd-calen }  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL calen-data.cd-calen V-table-Win
ON LEAVE OF calen-data.cd-calen IN FRAME f-main /* Calend rio */
DO:
  {include/leave.i &tabela       = calen-gener
                   &atributo-ref = descricao
                   &variavel-ref = fi-desc-calen
                   &where        = "calen-gener.cd-calen eq input frame {&frame-name}
                                    calen-data.cd-calen"}  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL calen-data.cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF calen-data.cd-calen IN FRAME f-main /* Calend rio */
DO:
   APPLY 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME calen-data.data
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL calen-data.data V-table-Win
ON LEAVE OF calen-data.data IN FRAME f-main /* Data */
DO:
  if input frame {&frame-name} calen-data.data ne "" then
     assign fi-dia-semana = 
      (entry( (weekday(input frame {&frame-name} calen-data.data)) , c-dias-semana )).
  else
     assign fi-dia-semana = "".
  display fi-dia-semana with frame {&frame-name}.  
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
    
  {utp/ut-liter.i "Domingo,Segunda,Ter‡a,Quarta,Quinta,Sexta,S bado"   "*"   "R"}
  assign c-dias-semana = return-value.
  
  {utp/ut-liter.i "Dia Util,Dia de Descanso,Feriado,Meio Periodo" "MCP" "R"}
  assign c-tipos-dia = return-value.
  
  {utp/ut-rtlbl.i mgind calen-prod tipo-dia fi-label-tipo-dia}
  
  if calen-data.cd-calen:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

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
  {src/adm/template/row-list.i "calen-data"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "calen-data"}

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
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  {utp/ut-rtlbl.i mgind calen-data tipo-dia fi-label-tipo-dia}
 
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
  
       if calen-data.cd-calen:sensitive in frame {&frame-name} = yes
     and can-find(b-calen-data where
       b-calen-data.cd-calen eq input frame {&frame-name} calen-data.cd-calen and
       b-calen-data.data        eq input frame {&frame-name} calen-data.data      )
     then do:
        {utp/ut-table.i mgind calen-data 3}
        run utp/ut-msgs.p (input "show",
                           input 1,
                           input return-value).
        return "adm-error".
     end.                                   
 
     if (input frame {&frame-name} mgind.calen-data.data eq (date("")) ) then do:  
     {utp/ut-field.i mgind calen-data data 3}
        run utp/ut-msgs.p (input "show",
                           input 688,
                           input return-value).
        apply "entry" to calen-data.data in frame {&frame-name} .
        return "adm-error".
     end.                              
 
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
  
  
  /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
  /* Code placed here will execute AFTER standard behavior.    */


/* I-CONT */
do i-cont = 1 to 5:  
  if c-turno[i-cont] ne "" then do:  
    if c-hora-fim[i-cont] gt "2400" then do:
          /* Erro 725 -> hora final deve ser menor ou igual a 24:00 */
          run utp/ut-msgs.p (input "show",
                                   input 725,
                                   input "" ).
    end.                                                               
  
    if c-hora-ini[i-cont] gt c-hora-fim[i-cont] then do:
       /* Erro 508 -> Hora inicial menor que final */  
       {utp/ut-field.i mgind calen-data hora-ini 1}
       {utp/ut-field.i mgind calen-data hora-fin 1} 
       assign c-label = return-value.
       run utp/ut-msgs.p (input "show",
                                input 508,
                                input return-value + "~~" + c-label).
       return "adm-error".
    end.                                                            
  
    if (i-cont gt 1) and (c-hora-ini[i-cont] lt c-hora-fim[i-cont - 1]) then do:
       /* Erro 726 -> O horario inicial do turno deve ser maior que o horario
                      final do turno anterior.                                */
       run utp/ut-msgs.p (input "show",
                                input 726,
                                input "" ).
       return "adm-error".
    end.                            

  end.

end.                      

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
  if avail calen-data then do:
     assign fi-dia-semana = (entry(weekday(calen-data.data),c-dias-semana)).
     find calen-gener where
          calen-gener.cd-calen eq calen-data.cd-calen no-lock no-error.
     if avail(calen-gener) then 
        assign fi-desc-calen = calen-gener.descricao.
     else
        assign fi-desc-calen = "".               
  end.   


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .


  /* Code placed here will execute AFTER standard behavior.    */
  
   {utp/ut-rtlbl.i mgind calen-data tipo-dia fi-label-tipo-dia}
 
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
  
   {utp/ut-rtlbl.i mgind calen-data tipo-dia fi-label-tipo-dia}
 
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
  
  if avail calen-data then
     assign gr-calen-data = rowid(calen-data).

  /* Code placed here will execute AFTER standard behavior.    */

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
  {src/adm/template/snd-list.i "calen-data"}

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


