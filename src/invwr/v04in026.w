&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI
&ANALYZE-RESUME
/* Connected Databases 
          mgmnt            PROGRESS
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
{include/i-prgvrs.i V04IN026 2.00.00.003}  /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V04IN026 MUT}
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
define new global shared var gr-calen-gener       as rowid no-undo.
define new global shared var gr-mi-turno          as rowid no-undo.
define new global shared var gr-turno-calen-gener as rowid no-undo.

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.
def buffer b-mi-turno for mi-turno.
def buffer b-turno-calen-gener for turno-calen-gener.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES mi-turno
&Scoped-define FIRST-EXTERNAL-TABLE mi-turno


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR mi-turno.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-OBJECTS rt-key rt-mold i-ano-inicio i-ano-fim ~
i-ciclo RECT-9 RECT-10 tb-domingo tb-domingo-manut tb-segunda ~
tb-segunda-manut tb-terca tb-terca-manut tb-quarta tb-quarta-manut ~
tb-quinta tb-quinta-manut tb-sexta tb-sexta-manut tb-sabado tb-sabado-manut 
&Scoped-Define DISPLAYED-OBJECTS c-cd-calen c-desc-calen c-cd-turno ~
c-descricao-turno i-ano-inicio i-ano-fim i-ciclo tb-domingo ~
tb-domingo-manut tb-segunda tb-segunda-manut tb-terca tb-terca-manut ~
tb-quarta tb-quarta-manut tb-quinta tb-quinta-manut tb-sexta tb-sexta-manut ~
tb-sabado tb-sabado-manut 

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
DEFINE VARIABLE c-cd-calen AS CHARACTER FORMAT "X(9)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE VARIABLE c-cd-turno AS INTEGER FORMAT "->,>>>,>>9" INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 4.57 BY .88.

DEFINE VARIABLE c-desc-calen AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 43 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao-turno AS CHARACTER FORMAT "x(40)" 
     VIEW-AS FILL-IN 
     SIZE 41.14 BY .88.

DEFINE VARIABLE fi-label-retangulo1 AS CHARACTER FORMAT "X(20)":U 
      VIEW-AS TEXT 
     SIZE 16 BY .63 NO-UNDO.

DEFINE VARIABLE fi-label-retangulo2 AS CHARACTER FORMAT "X(25)":U 
      VIEW-AS TEXT 
     SIZE 23 BY .63 NO-UNDO.

DEFINE VARIABLE i-ano-fim AS INTEGER FORMAT ">>>9":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-ano-inicio AS INTEGER FORMAT ">>>9":U INITIAL ? 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 8 BY .88 NO-UNDO.

DEFINE VARIABLE i-ciclo AS INTEGER FORMAT "->,>>>,>>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-10
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 7.

DEFINE RECTANGLE RECT-9
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 25 BY 7.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 2.38.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 80 BY 10.

DEFINE VARIABLE tb-domingo AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-domingo-manut AS LOGICAL INITIAL no 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-quarta AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-quarta-manut AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-quinta AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-quinta-manut AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sabado AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sabado-manut AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-segunda AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-segunda-manut AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sexta AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-sexta-manut AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-terca AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.

DEFINE VARIABLE tb-terca-manut AS LOGICAL INITIAL yes 
     LABEL "" 
     VIEW-AS TOGGLE-BOX
     SIZE 11.72 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     c-cd-calen AT ROW 1.17 COL 17.86 COLON-ALIGNED
     c-desc-calen AT ROW 1.17 COL 30.43 COLON-ALIGNED NO-LABEL
     c-cd-turno AT ROW 2.17 COL 17.86 COLON-ALIGNED HELP
          "C¢digo do Turno"
     c-descricao-turno AT ROW 2.17 COL 22.72 COLON-ALIGNED NO-LABEL
     i-ano-inicio AT ROW 3.63 COL 17.86 COLON-ALIGNED
     i-ano-fim AT ROW 3.63 COL 60.86 COLON-ALIGNED
     i-ciclo AT ROW 4.63 COL 17.86 COLON-ALIGNED
     tb-domingo AT ROW 6.58 COL 16.86
     tb-domingo-manut AT ROW 6.58 COL 51.86
     tb-segunda AT ROW 7.42 COL 16.86
     tb-segunda-manut AT ROW 7.42 COL 51.86
     tb-terca AT ROW 8.21 COL 16.86
     tb-terca-manut AT ROW 8.21 COL 51.86
     tb-quarta AT ROW 9.04 COL 16.86
     tb-quarta-manut AT ROW 9.04 COL 51.86
     tb-quinta AT ROW 9.83 COL 16.86
     tb-quinta-manut AT ROW 9.83 COL 51.86
     tb-sexta AT ROW 10.63 COL 16.86
     tb-sexta-manut AT ROW 10.63 COL 51.86
     tb-sabado AT ROW 11.46 COL 16.86
     tb-sabado-manut AT ROW 11.46 COL 51.86
     fi-label-retangulo1 AT ROW 5.83 COL 11.86 COLON-ALIGNED NO-LABEL
     fi-label-retangulo2 AT ROW 5.83 COL 44.86 COLON-ALIGNED NO-LABEL
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 3.38 COL 1
     RECT-9 AT ROW 6.08 COL 11.86
     RECT-10 AT ROW 6.08 COL 45.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgmnt.mi-turno
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
         HEIGHT             = 12.38
         WIDTH              = 80.29.
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

/* SETTINGS FOR FILL-IN c-cd-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-cd-turno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-calen IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao-turno IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-label-retangulo1 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
/* SETTINGS FOR FILL-IN fi-label-retangulo2 IN FRAME f-main
   NO-DISPLAY NO-ENABLE                                                 */
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

&Scoped-define SELF-NAME c-cd-calen
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-calen V-table-Win
ON ENTRY OF c-cd-calen IN FRAME f-main
DO:
  {include/leave.i &tabela       = calen-gener
                   &atributo-ref = descricao
                   &variavel-ref = c-desc-calen
                   &where        = "calen-gener.cd-calen  eq 
                                   input frame {&frame-name} c-cd-calen"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-calen V-table-Win
ON F5 OF c-cd-calen IN FRAME f-main
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom = "inzoom/Z01in026.w"
                     &campo     = c-cd-calen
                     &campozoom = cd-calen}
  END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-calen V-table-Win
ON LEAVE OF c-cd-calen IN FRAME f-main
DO:
  {include/leave.i &tabela       = calen-gener
                   &atributo-ref = descricao
                   &variavel-ref = c-desc-calen
                   &where        = "calen-gener.cd-calen  eq 
                                   input frame {&frame-name} c-cd-calen"}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL c-cd-calen V-table-Win
ON MOUSE-SELECT-DBLCLICK OF c-cd-calen IN FRAME f-main
DO:
  apply "F5" to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ano-inicio
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ano-inicio V-table-Win
ON LEAVE OF i-ano-inicio IN FRAME f-main
DO:
  assign i-ciclo:screen-value in frame {&frame-name} = string(weekday(date(01,01,int(i-ano-inicio:screen-value in frame {&frame-name})))).
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-ciclo
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ciclo V-table-Win
ON F5 OF i-ciclo IN FRAME f-main
DO:
  find mi-turno where rowid(mi-turno) = gr-mi-turno no-lock no-error.
  
  {include/zoomvar.i &prog-zoom=mnzoom/z01mn016.w
                     &campo=i-ciclo
                     &campozoom=ciclo
                     &parametros="run pi-seta-inicial in wh-pesquisa (input mi-turno.cd-turno)."}.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-ciclo V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-ciclo IN FRAME f-main
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

  {utp/ut-field.i mgind calen-gener cd-calen 1}     /* Label do Calend rio */
  assign c-cd-calen:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i Come‡ar_com_ciclo}     /* Label do Ciclo */
  assign i-ciclo:label in frame {&frame-name} = return-value.

  {utp/ut-liter.i "Ano_Inicial" "*" "L"}
  assign i-ano-inicio:label in frame {&frame-name} = return-value.
  
  {utp/ut-liter.i "Ano_Final" "*" "L"}
  assign i-ano-fim:label in frame {&frame-name} = return-value.
  
  /* Label nos retangulos */
  {utp/ut-liter.i "Dias_Uteis" "*" "L"}
  assign 
     fi-label-retangulo1:screen-value in frame {&frame-name} = " " + return-value
     fi-label-retangulo1                                      = " " + return-value.
  {utp/ut-liter.i "Uteis_de_Manuten‡Æo" "*" "L"}
  assign 
     fi-label-retangulo2:screen-value in frame {&frame-name} = " " + return-value
     fi-label-retangulo2                                     = " " + return-value.
                  
  {utp/ut-liter.i "Domingo,Segunda,Ter‡a,Quarta,Quinta,Sexta,S bado" "*" "R"} 
  assign tb-domingo:label in frame {&frame-name} = entry( 1 , return-value ) 
         tb-segunda:label in frame {&frame-name} = entry( 2 , return-value ) 
         tb-terca:label   in frame {&frame-name} = entry( 3 , return-value ) 
         tb-quarta:label  in frame {&frame-name} = entry( 4 , return-value ) 
         tb-quinta:label  in frame {&frame-name} = entry( 5 , return-value ) 
         tb-sexta:label   in frame {&frame-name} = entry( 6 , return-value ) 
         tb-sabado:label  in frame {&frame-name} = entry( 7 , return-value ).

  {utp/ut-liter.i "Domingo,Segunda,Ter‡a,Quarta,Quinta,Sexta,S bado" "*" "R"} 
  assign tb-domingo-manut:label in frame {&frame-name} = entry( 1 , return-value ) 
         tb-segunda-manut:label in frame {&frame-name} = entry( 2 , return-value ) 
         tb-terca-manut:label   in frame {&frame-name} = entry( 3 , return-value ) 
         tb-quarta-manut:label  in frame {&frame-name} = entry( 4 , return-value ) 
         tb-quinta-manut:label  in frame {&frame-name} = entry( 5 , return-value ) 
         tb-sexta-manut:label   in frame {&frame-name} = entry( 6 , return-value ) 
         tb-sabado-manut:label  in frame {&frame-name} = entry( 7 , return-value ).

  if c-cd-calen:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.
  if i-ciclo:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.


  assign i-ano-inicio:screen-value in frame {&frame-name} = string(year(today))
         i-ano-fim:screen-value in frame {&frame-name} = string(year(today))
         i-ciclo:screen-value in frame {&frame-name} = string(weekday(date(01,01,year(today)))).
         
  find calen-gener where rowid(calen-gener) = gr-calen-gener no-lock no-error.
    if avail calen-gener then do:
          assign c-cd-calen:screen-value in frame {&frame-name} = calen-gener.cd-calen.
          apply 'leave' to c-cd-calen in frame {&frame-name}.
    end.

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
  {src/adm/template/row-list.i "mi-turno"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "mi-turno"}

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
    
    /* Dispatch standard ADM method.                             */

  
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
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
  assign i-ano-inicio = (year(today))
         i-ano-fim = (year(today)).
    
    
    if  gr-turno-calen-gener <> ? then do:
        find b-turno-calen-gener where
             rowid(b-turno-calen-gener) = gr-turno-calen-gener no-lock no-error.
        find b-mi-turno where
             b-mi-turno.cd-turno = b-turno-calen-gener.cd-turno no-lock no-error.
        if  avail b-mi-turno then
            assign c-cd-turno:screen-value in frame {&frame-name} = string(b-mi-turno.cd-turno)
                   c-descricao-turno:screen-value in frame {&frame-name} = b-mi-turno.descricao.
    end.           
               
    {utp/ut-field.i mgmnt mi-turno cd-turno 1}
    assign c-cd-turno:label in frame {&frame-name} = trim(return-value).     
    display  i-ano-inicio
             i-ano-fim
             tb-domingo
             tb-segunda
             tb-terca
             tb-quarta
             tb-quinta
             tb-sexta
             tb-sabado     
             tb-domingo-manut
             tb-segunda-manut
             tb-terca-manut
             tb-quarta-manut
             tb-quinta-manut
             tb-sexta-manut
             tb-sabado-manut     with frame {&frame-name}.

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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-carrega-valores V-table-Win 
PROCEDURE pi-carrega-valores :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
   define input  parameter p-turno          like turno-calen-gener.cd-turno.
   define output parameter p-ciclo          like mi-turno-ciclo.ciclo.
   define output parameter p-ano-ini        like i-ano-inicio.
   define output parameter p-ano-fim        like i-ano-fim.
   define output parameter p-domingo        as log.
   define output parameter p-segunda        as log.
   define output parameter p-terca          as log.
   define output parameter p-quarta         as log.
   define output parameter p-quinta         as log.
   define output parameter p-sexta          as log.
   define output parameter p-sabado         as log.
   define output parameter p-domingo-manut  as log.
   define output parameter p-segunda-manut  as log.
   define output parameter p-terca-manut    as log.
   define output parameter p-quarta-manut   as log.
   define output parameter p-quinta-manut   as log.
   define output parameter p-sexta-manut    as log.
   define output parameter p-sabado-manut   as log.
   def var c-label as char no-undo. 
 
   find first mi-turno-ciclo where 
              mi-turno-ciclo.ciclo    = input frame {&frame-name} i-ciclo 
          and mi-turno-ciclo.cd-turno = p-turno no-lock no-error.
   if not avail(mi-turno-ciclo) then do:      
      {utp/ut-table.i mgmnt mi-turno-ciclo 1}                                     
      run utp/ut-msgs.p (input "show"     ,
                         input 2          ,
                         input return-value).
      apply "entry" to i-ciclo in frame {&frame-name}.
      return "adm-error".
   end.                                                             
   if input frame {&frame-name} i-ano-inicio gt 
      input frame {&frame-name} i-ano-fim then do:   /* Inicial <= Final */
      {utp/ut-field.i mgind cot-oper data-termino 1}  
      assign c-label = return-value.
      {utp/ut-field.i mgind cot-oper data-inicio 1}  
      run utp/ut-msgs.p (input "show",
                         input 508   ,
                         input return-value + "~~" + c-label).    
      apply "entry" to i-ano-inicio in frame {&frame-name}.
      return "adm-error".
   end. 
      
   assign p-ciclo         = input frame {&frame-name} i-ciclo
          p-ano-ini       = input frame {&frame-name} i-ano-inicio 
          p-ano-fim       = input frame {&frame-name} i-ano-fim    
          p-domingo       = input frame {&frame-name} tb-domingo    
          p-segunda       = input frame {&frame-name} tb-segunda    
          p-terca         = input frame {&frame-name} tb-terca      
          p-quarta        = input frame {&frame-name} tb-quarta     
          p-quinta        = input frame {&frame-name} tb-quinta     
          p-sexta         = input frame {&frame-name} tb-sexta      
          p-sabado        = input frame {&frame-name} tb-sabado 
          p-domingo-manut = input frame {&frame-name} tb-domingo-manut    
          p-segunda-manut = input frame {&frame-name} tb-segunda-manut    
          p-terca-manut   = input frame {&frame-name} tb-terca-manut      
          p-quarta-manut  = input frame {&frame-name} tb-quarta-manut     
          p-quinta-manut  = input frame {&frame-name} tb-quinta-manut     
          p-sexta-manut   = input frame {&frame-name} tb-sexta-manut      
          p-sabado-manut  = input frame {&frame-name} tb-sabado-manut.
   return "OK". 

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
  {src/adm/template/snd-list.i "mi-turno"}

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


