&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V02IN661 2.00.00.013 } /*** "010013" ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in661 MUT}
&ENDIF

/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

{cdp/cdcfgmat.i}  /* pre-processadores */

/* global variable definitions */

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

def var l-alterou as logical initial no.
def var c-medio   as char    no-undo.
def buffer b-estab-mat for estab-mat.
DEFINE BUFFER b-estabelec FOR estabelec.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of designated FRAME-NAME and/or first browse and/or first query */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES estab-mat
&Scoped-define FIRST-EXTERNAL-TABLE estab-mat


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR estab-mat.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS estab-mat.deposito-cq estab-mat.dep-rej-cq ~
estab-mat.custo-contab estab-mat.usa-on-line 
&Scoped-define ENABLED-TABLES estab-mat
&Scoped-define FIRST-ENABLED-TABLE estab-mat
&Scoped-Define ENABLED-OBJECTS rt-mold-2 rt-mold rt-mold-3 rc-rateia 
&Scoped-Define DISPLAYED-FIELDS estab-mat.deposito-cq estab-mat.dep-rej-cq ~
estab-mat.custo-contab estab-mat.usa-on-line 
&Scoped-define DISPLAYED-TABLES estab-mat
&Scoped-define FIRST-DISPLAYED-TABLE estab-mat
&Scoped-Define DISPLAYED-OBJECTS c-desc-cq c-desc-cq-rej rs-rateia-un ~
c-custo-contab c-tipo-custo 

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
DEFINE VARIABLE c-custo-contab AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 14 BY .67 NO-UNDO.

DEFINE VARIABLE c-desc-cq AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-desc-cq-rej AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 58.86 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-custo AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 10.29 BY .67 NO-UNDO.

DEFINE VARIABLE fi-rateia-un AS CHARACTER FORMAT "X(256)":U INITIAL "Rateia Valor Unidade Neg¢cio" 
      VIEW-AS TEXT 
     SIZE 25.14 BY .63 NO-UNDO.

DEFINE VARIABLE rs-rateia-un AS INTEGER 
     VIEW-AS RADIO-SET VERTICAL
     RADIO-BUTTONS 
          "Autom tico (C lculo Pre‡o M‚dio)", 1,
"Manual (C lculo Rateio Unidade Neg¢cio - Batch)", 2
     SIZE 41 BY 1.75 NO-UNDO.

DEFINE RECTANGLE rc-rateia
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 49.14 BY 3.46.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.43 BY 1.88.

DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 92 BY 3.38.

DEFINE RECTANGLE rt-mold-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 42.43 BY 1.33.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     estab-mat.deposito-cq AT ROW 1.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-cq AT ROW 1.25 COL 31.14 COLON-ALIGNED NO-LABEL
     estab-mat.dep-rej-cq AT ROW 2.25 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     c-desc-cq-rej AT ROW 2.25 COL 31.14 COLON-ALIGNED NO-LABEL
     estab-mat.custo-contab AT ROW 5.25 COL 7.14 NO-LABEL
          VIEW-AS RADIO-SET HORIZONTAL
          RADIO-BUTTONS 
                    "Mensal", 1,
"On-line", 2
          SIZE 29.29 BY .83
     rs-rateia-un AT ROW 5.5 COL 44.86 NO-LABEL
     estab-mat.usa-on-line AT ROW 6.92 COL 14
          VIEW-AS TOGGLE-BOX
          SIZE 16.72 BY .83
     c-custo-contab AT ROW 4.38 COL 1.14 COLON-ALIGNED NO-LABEL
     fi-rateia-un AT ROW 4.42 COL 45 NO-LABEL
     c-tipo-custo AT ROW 6.5 COL 1 COLON-ALIGNED NO-LABEL
     rt-mold-2 AT ROW 1 COL 1
     rt-mold AT ROW 4.63 COL 1
     rt-mold-3 AT ROW 6.75 COL 1
     rc-rateia AT ROW 4.63 COL 43.86
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.estab-mat
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY COMPILE
 */

/* This procedure should always be RUN PERSISTENT.  Report the error,  */
/* then cleanup and return.                                            */
IF NOT THIS-PROCEDURE:PERSISTENT THEN DO:
  MESSAGE "{&FILE-NAME} should only be RUN PERSISTENT.":U
          VIEW-AS ALERT-BOX ERROR BUTTONS OK.
  RETURN.
END.

&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW V-table-Win ASSIGN
         HEIGHT             = 7.08
         WIDTH              = 92.
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-custo-contab IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-desc-cq-rej IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-custo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN fi-rateia-un IN FRAME f-main
   NO-DISPLAY NO-ENABLE ALIGN-L                                         */
ASSIGN 
       fi-rateia-un:PRIVATE-DATA IN FRAME f-main     = 
                "Rateia Valor Unidade Neg¢cio".

/* SETTINGS FOR RADIO-SET rs-rateia-un IN FRAME f-main
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

&Scoped-define SELF-NAME estab-mat.custo-contab
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.custo-contab V-table-Win
ON VALUE-CHANGED OF estab-mat.custo-contab IN FRAME f-main /* Custo Cont bil */
DO:
  if input frame {&frame-name} estab-mat.custo-contab = 1 /* mensal */ then
     assign estab-mat.usa-on-line:sensitive in frame {&frame-name} = yes.
  else /* on line */
     assign estab-mat.usa-on-line:sensitive in frame {&frame-name} = no
            estab-mat.usa-on-line:checked   in frame {&frame-name} = yes.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.dep-rej-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.dep-rej-cq V-table-Win
ON F5 OF estab-mat.dep-rej-cq IN FRAME f-main /* Dep¢sito Rejei‡Æo CQ */
DO:

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                       &campo=estab-mat.dep-rej-cq
                       &campozoom=cod-depos}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.dep-rej-cq V-table-Win
ON LEAVE OF estab-mat.dep-rej-cq IN FRAME f-main /* Dep¢sito Rejei‡Æo CQ */
DO:

    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-desc-cq-rej
                     &where="deposito.cod-depos = input frame {&frame-name} 
                             estab-mat.dep-rej-cq"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.dep-rej-cq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.dep-rej-cq IN FRAME f-main /* Dep¢sito Rejei‡Æo CQ */
DO:

    apply 'F5' to self. 

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME estab-mat.deposito-cq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.deposito-cq V-table-Win
ON F5 OF estab-mat.deposito-cq IN FRAME f-main /* Dep¢sito CQ */
DO:

    assign l-implanta = yes.
    {include/zoomvar.i &prog-zoom=inzoom/z01in084.w
                       &campo=estab-mat.deposito-cq
                       &campozoom=cod-depos}  

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.deposito-cq V-table-Win
ON LEAVE OF estab-mat.deposito-cq IN FRAME f-main /* Dep¢sito CQ */
DO:

    {include/leave.i &tabela=deposito
                     &atributo-ref=nome
                     &variavel-ref=c-desc-cq
                     &where="deposito.cod-depos = input frame {&frame-name} 
                     estab-mat.deposito-cq"}

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL estab-mat.deposito-cq V-table-Win
ON MOUSE-SELECT-DBLCLICK OF estab-mat.deposito-cq IN FRAME f-main /* Dep¢sito CQ */
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

    {utp/ut-liter.i Custo_Cont bil * r}
    assign c-custo-contab:screen-value in frame {&frame-name} = return-value.

    {utp/ut-liter.i Tipo_Custo * r}
    assign c-tipo-custo:screen-value in frame {&frame-name} = return-value.

    if estab-mat.deposito-cq:load-mouse-pointer  ("image~\lupa.cur") in frame {&frame-name} then.
    if estab-mat.dep-rej-cq:load-mouse-pointer   ("image~\lupa.cur") in frame {&frame-name} then.
    
    {utp/ut-liter.i Rateia_Valor_Unidade_Neg¢cio * R}
    assign fi-rateia-un:screen-value in frame {&frame-name} = return-value.
    
    &if "{&bf_mat_versao_ems}":U < "2.062":U &then
    assign rc-rateia   :hidden in frame {&frame-name} = yes
           fi-rateia-un:hidden in frame {&frame-name} = yes
           rs-rateia-un:hidden in frame {&frame-name} = yes.      
    &endif

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

  /* Create a list of all the tables that we need to get.            */
  {src/adm/template/row-list.i "estab-mat"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "estab-mat"}

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

    {utp/ut-liter.i Custo_Cont bil * r}
    assign c-custo-contab:screen-value in frame {&frame-name} = return-value.

    {utp/ut-liter.i Tipo_Custo * r}
    assign c-tipo-custo:screen-value in frame {&frame-name} = return-value.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    {utp/ut-liter.i Rateia_Valor_Unidade_Neg¢cio * R}
    assign fi-rateia-un:screen-value in frame {&frame-name} = return-value.
    &endif


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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
        
    /********************** Validacao fechamento por Empresa *********************/
     RUN pi-valida-fech-por-emp.
     IF RETURN-VALUE = "NOK":U THEN RETURN "ADM-ERROR".
    /*****************************************************************************/    

    /**  Grava valores do estab-mat no estabelec.
    **/
    find estabelec where    
        estabelec.cod-estabel = estab-mat.cod-estabel
        exclusive-lock no-error.
    if not available estabelec then do:
        RUN Get-Field-Screen-Value IN adm-broker-hdl(INPUT this-procedure, INPUT "cod-estabel").
        find estabelec where
            estabelec.cod-estabel = return-value
            exclusive-lock no-error.
    end.            
    assign estabelec.cod-emitente = estab-mat.cod-emitente        
           estabelec.custo-contab = estab-mat.custo-contab
           estabelec.deposito-cq  = estab-mat.deposito-cq
           estabelec.dep-rej-cq   = estab-mat.dep-rej-cq
           estabelec.usa-on-line  = estab-mat.usa-on-line.
    release estabelec.           

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
        &if "{&bf_mat_versao_ems}":U < "2.08":U &then
            assign overlay(estab-mat.char-1,36,1) = string(rs-rateia-un:input-value in frame {&frame-name}).
        &else
            assign estab-mat.cdn-rat-un = rs-rateia-un:input-value in frame {&frame-name}.
        &endif
    &endif


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
    
    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    disable rs-rateia-un with frame {&frame-name}.
    &endif


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available estab-mat then do with frame {&frame-name}:
        find deposito where
            deposito.cod-depos = estab-mat.deposito-cq
            no-lock no-error.
        assign c-desc-cq:screen-value = if available deposito 
                                        then deposito.nome
                                        else "":U.
        find deposito where
            deposito.cod-depos = estab-mat.dep-rej-cq
            no-lock no-error.
        assign c-desc-cq-rej:screen-value = if available deposito 
                                            then deposito.nome
                                            else "":U.
        
        &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
            &if "{&bf_mat_versao_ems}":U < "2.08":U &then
                if substring(estab-mat.char-1,36,1) <> "" then
                   assign rs-rateia-un = int(substring(estab-mat.char-1,36,1)).
                else
                   assign rs-rateia-un = 1.
            &else
                assign rs-rateia-un = estab-mat.cdn-rat-un.
            &endif
            display rs-rateia-un with frame {&frame-name}.
        &endif

    end.


    {utp/ut-liter.i Custo_Cont bil * r}
    assign c-custo-contab:screen-value in frame {&frame-name} = return-value.

    {utp/ut-liter.i Tipo_Custo * r}
    assign c-tipo-custo:screen-value in frame {&frame-name} = return-value.




END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    if adm-new-record = yes then
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    assign l-alterou = no.

    {utp/ut-liter.i Custo_Cont bil * r}
    assign c-custo-contab:screen-value in frame {&frame-name} = return-value.

    {utp/ut-liter.i Tipo_Custo * r}
    assign c-tipo-custo:screen-value in frame {&frame-name} = return-value.

    &if "{&bf_mat_versao_ems}":U >= "2.062":U &then
    find first param-estoq no-lock no-error.
    assign rs-rateia-un:sensitive in frame {&frame-name} = (param-estoq.tp-fech = 2).
    &endif

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-fech-por-emp V-table-Win 
PROCEDURE pi-valida-fech-por-emp PRIVATE :
/*------------------------------------------------------------------------------
 Purpose:
 Notes:
------------------------------------------------------------------------------*/

    FIND FIRST param-estoq NO-LOCK NO-ERROR.
   
    IF NOT AVAILABLE param-estoq OR SUBSTRING(param-estoq.CHAR-2,67,1) <> "S" THEN RETURN "OK".
    
    FOR FIRST b-estabelec NO-LOCK 
        WHERE b-estabelec.cod-estabel = estab-mat.cod-estabel:
  
        IF estab-mat.cdn-rat-un <> rs-rateia-un:INPUT-VALUE IN FRAME {&frame-name} THEN DO:
              
           RUN utp/ut-msgs.p (INPUT 'show',
                              INPUT 54428, 
                              INPUT b-estabelec.ep-codigo).
                                                       
           IF RETURN-VALUE = "NO" THEN RETURN "NOK":U.                            
        END.      
             
        FOR EACH estabelec NO-LOCK  
           WHERE estabelec.ep-codigo = b-estabelec.ep-codigo:
        
            FOR FIRST b-estab-mat EXCLUSIVE-LOCK
                WHERE b-estab-mat.cod-estabel = estabelec.cod-estabel: 
                ASSIGN b-estab-mat.cdn-rat-un = rs-rateia-un:INPUT-VALUE IN FRAME {&frame-name}.                 
            END.                                              
        END.
    END.
    
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validate V-table-Win 
PROCEDURE pi-validate :
/*------------------------------------------------------------------------------
  Purpose:Validar a viewer     
  Parameters:  <none>
  Notes: NÆo fazer assign aqui. Nesta procedure
  devem ser colocadas apenas valida‡äes, pois neste ponto do programa o registro 
  ainda nÆo foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Valida‡Æo de dicion rio */

    find first param-global
        no-lock no-error.

    {utp/ut-liter.i Custo_Cont bil mcd r}
    assign  c-medio  = return-value.

    &if '{&bf_mat_versao_ems}' >= '2.05' &then
        if  not can-find (first funcao
                          where funcao.cd-funcao = "BetaCusteioItem"
                            and funcao.ativo     = yes ) 
        and estab-mat.usa-on-line:checked in frame {&frame-name} then do:

            run utp/ut-msgs.p (input "show":U,
                               input 29885,
                               input "").

            apply 'entry':U to estab-mat.usa-on-line in frame {&frame-name}.
            return 'adm-error':U.
        end.
    &endif
    
    if available param-global then do:
        if param-global.modulo-cq = yes then do:
            find first deposito where 
                deposito.cod-depos = input frame {&frame-name} estab-mat.deposito-cq and
                deposito.ind-dep-cq = yes 
                no-lock no-error.
            if not avail deposito then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show", 
                                   input 1014, 
                                   input "").
                apply 'entry' to estab-mat.deposito-cq in frame {&frame-name}.
                return 'adm-error'.
            end.
            find first deposito where 
                deposito.cod-depos = input frame {&frame-name} estab-mat.dep-rej-cq and
                deposito.ind-dep-rej = yes 
                no-lock no-error.
            if not avail deposito then do:
                {include/i-vldprg.i}
                run utp/ut-msgs.p (input "show", 
                                   input 1015, 
                                   input "").
                apply 'entry' to estab-mat.dep-rej-cq in frame {&frame-name}.
                return 'adm-error'.
            end.                
        end.            
    end.        
    
  find first param-estoq no-lock no-error.
  if avail param-estoq then do:
     if input frame {&frame-name} estab-mat.custo-contab = 1 and
        param-estoq.log-1 = no then do :
     /* Para utilizar a contabiliza‡Æo pelo m‚dio mensal, o estoque deve
        estar parametrizado para utilizar o "m‚dio batch".            */
        run utp/ut-msgs.p (input "show",
                           input 15035 ,
                           input ""    ).
        apply "entry" to estab-mat.custo-contab in frame {&frame-name}.
        return "adm-error".
     end.
  end.

  run get-attribute('adm-new-record':U).

  if not adm-new-record 
     and estab-mat.custo-contab:modified in frame {&frame-name} = yes 
     and can-find(first movto-estoq where movto-estoq.cod-estabel = estab-mat.cod-estabel no-lock) 
  then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                            input 5020  ,
                            input string(c-medio)).
         disp estab-mat.custo-contab with frame {&frame-name}.
         assign estab-mat.usa-on-line:checked in frame {&frame-name}   = estab-mat.usa-on-line
                estab-mat.custo-contab:modified in frame {&frame-name} = no
                estab-mat.usa-on-line:modified in frame {&frame-name}  = no.
         disable estab-mat.custo-contab with frame {&frame-name}.
         enable  estab-mat.usa-on-line with frame {&frame-name}.
         return "adm-error".
  end.

  if not adm-new-record 
     and estab-mat.usa-on-line:modified in frame {&frame-name}  = yes 
     and can-find(first movto-estoq where movto-estoq.cod-estabel = estab-mat.cod-estabel no-lock) 
  then do:
         {include/i-vldprg.i}
         run utp/ut-msgs.p (input "show",
                            input 34871 ,
                            input ""    ).
  end.


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

  /* Define variables needed by this internal procedure.               */
  {src/adm/template/snd-head.i}

  /* For each requested table, put it's ROWID in the output list.      */
  {src/adm/template/snd-list.i "estab-mat"}

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

