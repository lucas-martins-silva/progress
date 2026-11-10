&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r11 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgcad            PROGRESS
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
{include/i-prgvrs.i V02IN027 2.00.00.007}  /*** 010007 ***/
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

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE Window
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold RECT-1 fi-cod-estabel ~
fi-ano-inicio fi-ano-fim tb-domingo tb-segunda tb-terca tb-quarta tb-quinta ~
tb-sexta tb-sabado 
&Scoped-Define DISPLAYED-OBJECTS fi-cod-estabel fi-nome-estabel ~
fi-ano-inicio fi-ano-fim tb-domingo tb-segunda tb-terca tb-quarta tb-quinta ~
tb-sexta tb-sabado 

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
DEFINE VARIABLE fi-ano-fim AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-ano-inicio AS INTEGER FORMAT ">>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 10 BY .88 NO-UNDO.

DEFINE VARIABLE fi-cod-estabel LIKE estabelec.cod-estabel
     LABEL "":R7 
     VIEW-AS FILL-IN 
     SIZE 5 BY .88 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .63 NO-UNDO.

DEFINE VARIABLE fi-nome-estabel AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 6.46.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 1.63.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84 BY 8.33.

DEFINE VARIABLE tb-domingo AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-quarta AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-quinta AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sabado AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-segunda AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sexta AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-terca AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     fi-cod-estabel AT ROW 1.25 COL 22 COLON-ALIGNED
          LABEL "":R7
     fi-nome-estabel AT ROW 1.25 COL 27 COLON-ALIGNED NO-LABEL
     fi-ano-inicio AT ROW 2.88 COL 22 COLON-ALIGNED
     fi-ano-fim AT ROW 2.88 COL 51 COLON-ALIGNED
     tb-domingo AT ROW 4.75 COL 33
     tb-segunda AT ROW 5.58 COL 33
     tb-terca AT ROW 6.38 COL 33
     tb-quarta AT ROW 7.21 COL 33
     tb-quinta AT ROW 8 COL 33
     tb-sexta AT ROW 8.79 COL 33
     tb-sabado AT ROW 9.63 COL 33
     fi-label-retangulo AT ROW 3.96 COL 31 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.63 COL 1
     RECT-1 AT ROW 4.25 COL 28
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: Window
   Allow: Basic,Browse,DB-Fields
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 9.96
         WIDTH              = 84.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}
{utp/ut-glob.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME




/* ***********  Runtime Attributes and AppBuilder Settings  *********** */

&ANALYZE-SUSPEND _RUN-TIME-ATTRIBUTES
/* SETTINGS FOR WINDOW V-table-Win
  VISIBLE,,RUN-PERSISTENT                                               */
/* SETTINGS FOR FRAME f-main
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN fi-cod-estabel IN FRAME f-main
   LIKE = mgcad.estabelec.cod-estabel EXP-LABEL                         */
/* SETTINGS FOR FILL-IN fi-label-retangulo IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-nome-estabel IN FRAME f-main
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

 



/* ************************  Control Triggers  ************************ */

&Scoped-define SELF-NAME fi-cod-estabel
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON ENTRY OF fi-cod-estabel IN FRAME f-main
DO:
  {include/leave.i &tabela       = estabelec
                   &atributo-ref = nome
                   &variavel-ref = fi-nome-estabel
                   &where        = "estabelec.cod-estabel eq 
                                   input frame {&frame-name} fi-cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON F5 OF fi-cod-estabel IN FRAME f-main
DO:
  {include/zoomvar.i &prog-zoom = "adzoom/z01ad107.w"
                     &campo     = fi-cod-estabel
                     &campozoom = cod-estabel}
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON LEAVE OF fi-cod-estabel IN FRAME f-main
DO:
  {include/leave.i &tabela       = estabelec
                   &atributo-ref = nome
                   &variavel-ref = fi-nome-estabel
                   &where        = "estabelec.cod-estabel eq 
                                   input frame {&frame-name} fi-cod-estabel"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL fi-cod-estabel V-table-Win
ON MOUSE-SELECT-DBLCLICK OF fi-cod-estabel IN FRAME f-main
DO:
  apply "F5" to self.
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

  {utp/ut-field.i mgadm estabelec cod-estabel 1}
  assign fi-cod-estabel:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i "Ano_Inicial" "*" "L"}
  assign fi-ano-inicio:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i "Ano_Final" "*" "L"}
  assign fi-ano-fim:label in frame {&frame-name} = return-value.
  
  /* Label no retangulo */
  {utp/ut-liter.i "Dias_Uteis" "*" "L"}
  assign fi-label-retangulo:screen-value in frame {&frame-name} = " " + return-value
         fi-label-retangulo                                     = " " + return-value.
         
  {utp/ut-liter.i "Domingo,Segunda,Ter‡a,Quarta,Quinta,Sexta,S bado" "*" "R"} 
  assign tb-domingo:label in frame {&frame-name} = entry( 1 , return-value ) 
         tb-segunda:label in frame {&frame-name} = entry( 2 , return-value ) 
         tb-terca:label   in frame {&frame-name} = entry( 3 , return-value ) 
         tb-quarta:label  in frame {&frame-name} = entry( 4 , return-value ) 
         tb-quinta:label  in frame {&frame-name} = entry( 5 , return-value ) 
         tb-sexta:label   in frame {&frame-name} = entry( 6 , return-value ) 
         tb-sabado:label  in frame {&frame-name} = entry( 7 , return-value ).

  if fi-cod-estabel:load-mouse-pointer ("image~\lupa.cur") in frame {&frame-name} then.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-row-available V-table-Win  _ADM-ROW-AVAILABLE
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE disable_UI V-table-Win  _DEFAULT-DISABLE
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
  
  /* Label no retangulo */
  {utp/ut-liter.i "Dias Uteis" "*" "L"}
  assign fi-label-retangulo:screen-value in frame {&frame-name} = " " + return-value
         fi-label-retangulo                                     = " " + return-value. 
         
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
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.
  
  /* Ponha aqui a valida‡Æo de chave duplicada */
  
  /* Ponha aqui as demais valida‡äes */
  
  /* Obs.: CASO A VALIDA€ÇO FALHE, DEVERµ SER RETORNADO UM COMANDO "RETURN 'ADM-ERROR'.". */
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.

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
  assign  fi-ano-inicio = year(today)
          fi-ano-fim    = year(today).
  display fi-ano-inicio
          fi-ano-fim    
          tb-segunda    
          tb-terca      
          tb-quarta     
          tb-quinta     
          tb-sexta      
          tb-sabado     with frame {&frame-name}.     
          
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-consiste-valores V-table-Win 
PROCEDURE pi-consiste-valores :
/*------------------------------------------------------------------------------
  Purpose: Consistencia dos valores informados na tela.     
  Parameters:
  Notes:       
------------------------------------------------------------------------------*/
   define output parameter p-cod-estabel  like fi-cod-estabel.
   define output parameter p-ano-ini      like fi-ano-inicio.
   define output parameter p-ano-fim      like fi-ano-fim.
   define output parameter p-domingo      as log.
   define output parameter p-segunda      as log.
   define output parameter p-terca        as log.
   define output parameter p-quarta       as log.
   define output parameter p-quinta       as log.
   define output parameter p-sexta        as log.
   define output parameter p-sabado       as log.  
   def var c-label as char no-undo.

   find estabelec no-lock where 
        estabelec.cod-estabel eq input frame {&frame-name} fi-cod-estabel no-error.
   if not avail(estabelec) then do:      
      {utp/ut-table.i mgadm estabelec 1}                                     
      run utp/ut-msgs.p (input "show"     ,
                         input 2          ,
                         input return-value).
      apply "entry" to fi-cod-estabel in frame {&frame-name}.
      return "adm-error".
   end.                                                             

   if input frame {&frame-name} fi-ano-inicio gt 
      input frame {&frame-name} fi-ano-fim then do: 
     {utp/ut-field.i mgind cot-oper data-inicio 1} 
     {utp/ut-field.i mgind cot-oper data-termino 1} 
     assign c-label = return-value.      
      run utp/ut-msgs.p (input "show",
                         input 508   ,
                         input return-value + "~~" + c-label).    
      apply "entry" to fi-ano-inicio in frame {&frame-name}.
      return "adm-error".
   end.                       
   
assign p-cod-estabel = input frame {&frame-name} fi-cod-estabel
       p-ano-ini     = input frame {&frame-name} fi-ano-inicio 
       p-ano-fim     = input frame {&frame-name} fi-ano-fim    
       p-domingo     = input frame {&frame-name} tb-domingo    
       p-segunda     = input frame {&frame-name} tb-segunda    
       p-terca       = input frame {&frame-name} tb-terca      
       p-quarta      = input frame {&frame-name} tb-quarta     
       p-quinta      = input frame {&frame-name} tb-quinta     
       p-sexta       = input frame {&frame-name} tb-sexta      
       p-sabado      = input frame {&frame-name} tb-sabado     . 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-records V-table-Win  _ADM-SEND-RECORDS
PROCEDURE send-records :
/*------------------------------------------------------------------------------
  Purpose:     Send record ROWID's for all tables used by
               this file.
  Parameters:  see template/snd-head.i
------------------------------------------------------------------------------*/

  /* SEND-RECORDS does nothing because there are no External
     Tables specified for this Window, and there are no
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

