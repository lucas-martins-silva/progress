&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
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
{include/i-prgvrs.i V06IN089 2.00.00.003 } /*** 010003 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V06IN089 MUT} 
&ENDIF


    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def var v-row-parent as rowid no-undo.
    def var i-emitente like emitente.cod-emitente.
    def new global shared var l-re1001a-inclui as logical no-undo.
    def var i-especie     as integer no-undo.
    def var i-observa     as integer no-undo.
    def var i-tipo-nota   as integer no-undo.
 
    {rep/re2001a.i} /**  Temp-table tt-inicializa          **/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer
&Scoped-define DB-AWARE no

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS doc-fisico.valor-frete ~
doc-fisico.valor-seguro doc-fisico.valor-outras doc-fisico.despesa-nota ~
doc-fisico.tot-peso doc-fisico.tot-desconto doc-fisico.valor-mercad 
&Scoped-define ENABLED-TABLES doc-fisico
&Scoped-define FIRST-ENABLED-TABLE doc-fisico
&Scoped-define DISPLAYED-TABLES doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-mold-2 
&Scoped-Define DISPLAYED-FIELDS doc-fisico.valor-frete ~
doc-fisico.valor-seguro doc-fisico.valor-outras doc-fisico.despesa-nota ~
doc-fisico.tot-peso doc-fisico.tot-desconto doc-fisico.valor-mercad 

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
DEFINE RECTANGLE rt-mold-2
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 84.86 BY 13.25.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     doc-fisico.valor-frete AT ROW 4.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     doc-fisico.valor-seguro AT ROW 5.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     doc-fisico.valor-outras AT ROW 6.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     doc-fisico.despesa-nota AT ROW 7.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     doc-fisico.tot-peso AT ROW 8.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     doc-fisico.tot-desconto AT ROW 9.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     doc-fisico.valor-mercad AT ROW 10.13 COL 37.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.43 BY .88
     rt-mold-2 AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.doc-fisico
   Allow: Basic,DB-Fields
   Frames: 1
   Add Fields to: EXTERNAL-TABLES
   Other Settings: PERSISTENT-ONLY
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
         HEIGHT             = 13.25
         WIDTH              = 84.86.
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

&Scoped-define SELF-NAME doc-fisico.valor-frete
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.valor-frete V-table-Win
ON LEAVE OF doc-fisico.valor-frete IN FRAME f-main /* Valor Frete */
DO:

    assign doc-fisico.despesa-nota:screen-value in frame {&frame-name} = string(
        input frame {&frame-name} doc-fisico.valor-frete  +
        input frame {&frame-name} doc-fisico.valor-seguro +
        input frame {&frame-name} doc-fisico.valor-outras ).

    if l-re1001a-inclui = no then do:
        /**  Na modificaá∆o, inicializa o valor das despesas na viewer de totais.
        **/
        run pi-recria-tt-inicializa.
        assign tt-inicializa.despesa-nota = input frame {&frame-name} doc-fisico.valor-frete  +
                                            input frame {&frame-name} doc-fisico.valor-seguro +
                                            input frame {&frame-name} doc-fisico.valor-outras.
                                            
        RUN pi-inicializa-campos IN h_v07in089
          (INPUT table tt-inicializa).
 
    end.            
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.valor-outras
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.valor-outras V-table-Win
ON LEAVE OF doc-fisico.valor-outras IN FRAME f-main /* Outras */
DO:

    apply "leave" to doc-fisico.valor-frete in frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME doc-fisico.valor-seguro
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL doc-fisico.valor-seguro V-table-Win
ON LEAVE OF doc-fisico.valor-seguro IN FRAME f-main /* Seguro */
DO:

    apply "leave" to doc-fisico.valor-frete in frame {&frame-name}.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF         
  
    find first param-estoq  
        no-lock no-error.
    
    find first param-global 
        no-lock no-error.
    
    find param-re where 
        param-re.usuario = c-seg-usuario 
        no-lock no-error.

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
  {src/adm/template/row-list.i "doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "doc-fisico"}

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

    /**  Se for alteraá∆o, os campos despesa-nota,tot-desconto,
    ***  valor-mercad,tot-peso ser∆o atualizados a partir dos
    ***  valores informados na viewer v20in090.w 
    **/ 

    if not l-re1001a-inclui then 
        RUN pi-atualiza-totais. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .
    
    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    disable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
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

if  avail doc-fisico and
          doc-fisico.valor-outras < 0 then
    assign doc-fisico.valor-outras:screen-value in frame {&FRAME-NAME} = string(0).

if  avail doc-fisico and
          doc-fisico.valor-outras = 0 AND 
          VALID-HANDLE(h_v07in089) THEN
run pi-total-item in h_v07in089 (input rowid(doc-fisico)).

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
    
    IF adm-new-record THEN DO:
      assign  doc-fisico.tot-desconto:screen-value in frame {&frame-name} = string(0)
              doc-fisico.tot-peso    :screen-value in frame {&frame-name} = string(0)
              doc-fisico.valor-frete :screen-value in frame {&frame-name} = string(0)
              doc-fisico.valor-mercad:screen-value in frame {&frame-name} = string(0)
              doc-fisico.valor-outras:screen-value in frame {&frame-name} = string(0)
              doc-fisico.valor-seguro:screen-value in frame {&frame-name} = string(0)
              doc-fisico.despesa-nota:screen-value in frame {&frame-name} = string(0).
    END.

    do with frame {&FRAME-NAME}:
        assign doc-fisico.tot-desconto:sensitive    = no
               doc-fisico.tot-peso:sensitive        = no
               doc-fisico.valor-frete:sensitive     = no
               doc-fisico.valor-mercad:sensitive    = no
               doc-fisico.valor-outras:sensitive    = no
               doc-fisico.valor-seguro:sensitive    = no
               doc-fisico.despesa-nota:sensitive    = no.
               
        if l-re1001a-inclui = no and avail doc-fisico then do:
 
            RUN Get-Field-Screen-Value IN adm-broker-hdl
                (INPUT this-procedure, INPUT "c-tipo-nota").
            assign i-tipo-nota = {ininc/i01in089.i 06 return-value}.

            if i-tipo-nota <> 3 then 
                assign doc-fisico.tot-desconto:sensitive    = yes
                       doc-fisico.tot-peso:sensitive        = yes
                       doc-fisico.valor-frete:sensitive     = yes
                       doc-fisico.valor-mercad:sensitive    = yes
                       doc-fisico.valor-outras:sensitive    = yes
                       doc-fisico.valor-seguro:sensitive    = yes.
        end.        
    end.           
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-totais V-table-Win 
PROCEDURE pi-atualiza-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    RUN pi-retorna-totais IN h_v07in089
        (output table tt-inicializa).
 
    find first tt-inicializa 
        no-error.
        
    assign doc-fisico.despesa-nota  = tt-inicializa.despesa-nota
           doc-fisico.tot-peso      = tt-inicializa.tot-peso
           doc-fisico.tot-desconto  = tt-inicializa.tot-desconto
           doc-fisico.valor-mercad  = tt-inicializa.valor-mercad.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-desabilita V-table-Win 
PROCEDURE pi-desabilita :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    disable all with frame {&frame-name}.  

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-inicializa-campos V-table-Win 
PROCEDURE pi-inicializa-campos :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param table for tt-inicializa.
 
    find first tt-inicializa 
        no-error.
 
    if l-re1001a-inclui then do with frame {&FRAME-NAME}:
 
        RUN Get-Field-Screen-Value IN adm-broker-hdl
            (INPUT this-procedure, INPUT "c-tipo-nota").
        assign i-tipo-nota = {ininc/i01in089.i 06 return-value}.
 
        /**  Habilita campos de valores
        **/
        if i-tipo-nota <> 3 then do:
            assign doc-fisico.tot-desconto:sensitive    = yes
                   doc-fisico.tot-peso:sensitive        = yes
                   doc-fisico.valor-frete:sensitive     = yes
                   doc-fisico.valor-mercad:sensitive    = yes
                   doc-fisico.valor-outras:sensitive    = yes
                   doc-fisico.valor-seguro:sensitive    = yes.
         end.
             
    end.
 
    if l-re1001a-inclui and 
        tt-inicializa.valor-mercad <> ? then do with frame {&FRAME-NAME}:
        assign doc-fisico.despesa-nota:screen-value = string(tt-inicializa.despesa-nota)
               doc-fisico.valor-frete:screen-value  = string(tt-inicializa.valor-frete)
               doc-fisico.tot-peso:screen-value     = string(tt-inicializa.tot-peso)
               doc-fisico.valor-mercad:screen-value = string(tt-inicializa.valor-mercad).
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-retorna-totais V-table-Win 
PROCEDURE pi-retorna-totais :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def output param table for tt-inicializa.
 
    run pi-recria-tt-inicializa.
    
    assign tt-inicializa.despesa-nota  = input frame {&FRAME-NAME} doc-fisico.despesa-nota
           tt-inicializa.tot-peso      = input frame {&FRAME-NAME} doc-fisico.tot-peso   
           tt-inicializa.tot-desconto  = input frame {&FRAME-NAME} doc-fisico.tot-desconto     
           tt-inicializa.valor-mercad  = input frame {&FRAME-NAME} doc-fisico.valor-mercad.

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

    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "c-tipo-nota").
    assign i-tipo-nota = {ininc/i01in089.i 06 return-value}.

    if l-re1001a-inclui and i-tipo-nota = 9 and
        input frame {&FRAME-NAME} doc-fisico.valor-mercad = 0 then do:
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show":U, input 15114, input "").
        apply "entry" to doc-fisico.valor-mercad in frame {&frame-name}.
        return 'ADM-ERROR':U.
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
  {src/adm/template/snd-list.i "doc-fisico"}

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

