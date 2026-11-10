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
{include/i-prgvrs.i V07IN163 2.00.00.000}  /*** 010000 ***/

    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def var v-row-parent        as rowid    no-undo.
    def var l-pede-data-comp    as logical  no-undo.
    def var c-it-codigo         as char     no-undo.
    def var h_v06in163          as handle   no-undo.
    def var l-novo-reg          as logical  no-undo.
 
    def new global shared var gr-doc-fisico  as rowid   no-undo.

    def var c-data1 as char no-undo.
    def var c-data2 as char no-undo.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE SmartViewer

&Scoped-define ADM-SUPPORTED-LINKS Record-Source,Record-Target,TableIO-Target

/* Name of first Frame and/or Browse and/or first Query                 */
&Scoped-define FRAME-NAME f-main

/* External Tables                                                      */
&Scoped-define EXTERNAL-TABLES it-doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE it-doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-doc-fisico.data-comp ~
it-doc-fisico.reabre-pd 
&Scoped-define FIELD-PAIRS~
 ~{&FP1}data-comp ~{&FP2}data-comp ~{&FP3}
&Scoped-define ENABLED-TABLES it-doc-fisico
&Scoped-define FIRST-ENABLED-TABLE it-doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS it-doc-fisico.serie-comp ~
it-doc-fisico.nro-comp it-doc-fisico.nat-comp it-doc-fisico.seq-comp ~
it-doc-fisico.data-comp it-doc-fisico.nr-pedcli it-doc-fisico.nr-pd-seq ~
it-doc-fisico.reabre-pd 

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
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.72 BY 9.13.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-doc-fisico.serie-comp AT ROW 1.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     it-doc-fisico.nro-comp AT ROW 2.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     it-doc-fisico.nat-comp AT ROW 3.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     it-doc-fisico.seq-comp AT ROW 4.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     it-doc-fisico.data-comp AT ROW 5.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.57 BY .88
     it-doc-fisico.nr-pedcli AT ROW 6.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.14 BY .88
     it-doc-fisico.nr-pd-seq AT ROW 7.63 COL 40.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 8 BY .88
     it-doc-fisico.reabre-pd AT ROW 8.75 COL 42.14
          VIEW-AS TOGGLE-BOX
          SIZE 15.57 BY .83
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.it-doc-fisico
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
         HEIGHT             = 9.13
         WIDTH              = 85.86.
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

/* SETTINGS FOR FILL-IN it-doc-fisico.nat-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.nr-pd-seq IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.nr-pedcli IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.nro-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.seq-comp IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-doc-fisico.serie-comp IN FRAME f-main
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

&Scoped-define SELF-NAME it-doc-fisico.nr-pd-seq
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL it-doc-fisico.nr-pd-seq V-table-Win
ON LEAVE OF it-doc-fisico.nr-pd-seq IN FRAME f-main /* SeqÅància */
DO:

    RUN Get-Field-Screen-Value IN adm-broker-hdl
        (INPUT this-procedure, INPUT "it-codigo").
    assign c-it-codigo = return-value.        
 
    find first ped-item where
        ped-item.nome-abrev   = emitente.nome-abrev and
        ped-item.nr-pedcli    = input frame {&frame-name} it-doc-fisico.nr-pedcli and
        ped-item.nr-sequencia = input frame {&frame-name} it-doc-fisico.nr-pd-seq and
        ped-item.it-codigo    = c-it-codigo
        no-lock no-error.
    if available ped-item then do:        
        find ped-venda where
            ped-venda.nome-abrev = ped-item.nome-abrev and
            ped-venda.nr-pedcli  = ped-item.nr-pedcli
            no-lock no-error.
        if available ped-venda and
            ped-venda.cod-sit-ped <> 4 and
            ped-venda.cod-sit-ped <> 9 and
            valid-handle(h_v06in163) then
            run pi-passa-quantidade in h_v06in163 (ped-item.qt-atendida).            
    end.
  
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

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
  {src/adm/template/row-list.i "it-doc-fisico"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-doc-fisico"}

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

    {include/i-valid.i}

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    assign l-novo-reg = no.

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

    assign l-novo-reg = no.
    
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
 
    assign l-novo-reg = yes.
 
    run pi-apos-enable.
 
    if adm-new-record = yes then do:
        &if  defined(ADM-MODIFY-FIELDS) &then
            enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
        &endif
    end.
 
    if not adm-new-record and
        available it-doc-fisico and
        it-doc-fisico.nr-pedcli:screen-value in frame {&frame-name} <> "" then do:
        assign it-doc-fisico.reabre-pd:sensitive in frame {&FRAME-NAME} = param-re.reabre-pd 
                                                                          and param-global.modulo-pd 
                                                                          and doc-fisico.tipo-nota = 2.
    end.                                                                          
    else
        assign it-doc-fisico.reabre-pd:sensitive in frame {&FRAME-NAME} = no. 

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    {utp/ut-field.i mgind param-re reabre-pd 1}
    
    assign it-doc-fisico.reabre-pd:label in frame {&FRAME-NAME} = return-value.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
    find doc-fisico where
        rowid(doc-fisico) = gr-doc-fisico
        no-lock no-error.
        
    if avail doc-fisico then do:
        find emitente where
            emitente.cod-emitente = doc-fisico.cod-emitente
            no-lock no-error.
    end.
    
    find param-re where
        param-re.usuario = c-seg-usuario
        no-lock no-error.        
        
    find first param-global
        no-lock no-error.
        
    find first param-compra
        no-lock no-error.        

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-apos-enable V-table-Win 
PROCEDURE pi-apos-enable :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    run pi-recebimento.
 
    if l-novo-reg then do:
        if not l-pede-data-comp then
            disable it-doc-fisico.data-comp
                    it-doc-fisico.nr-pd-seq with frame {&frame-name}.
        else do:
            if input frame {&frame-name} it-doc-fisico.nro-comp <> "" then 
                disable it-doc-fisico.data-comp
                        it-doc-fisico.nr-pd-seq with frame {&frame-name}.
            else do:
                enable it-doc-fisico.data-comp with frame {&frame-name}.        
            end.                            
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


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-passa-handle V-table-Win 
PROCEDURE pi-passa-handle :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-handle as handle no-undo.
    assign h_v06in163 = p-handle.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebimento V-table-Win 
PROCEDURE pi-recebimento :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
 
    assign l-pede-data-comp = doc-fisico.tipo-nota = 2
                            and input frame {&frame-name} it-doc-fisico.nro-comp = "".

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
        (INPUT this-procedure, INPUT "it-codigo").
    assign c-it-codigo = return-value.        

    if l-pede-data-comp and 
        input frame {&frame-name} it-doc-fisico.data-comp > 
        doc-fisico.dt-trans then do:
        {utp/ut-field.i mgind it-doc-fisico data-comp 1}
        assign c-data1 = return-value.
        {utp/ut-field.i mgind doc-fisico dt-trans 1}
        assign c-data2 = return-value.
        /**  Data nota deve ser menor ou igual a data transaá∆o
        **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 508,input c-data1 + '~~' + c-data2).
        apply 'entry' to it-doc-fisico.nr-pedcli in frame {&frame-name}.
        return 'adm-error':U.
    end.
 
    if l-pede-data-comp and
        input frame {&frame-name} it-doc-fisico.data-comp = ? then do:   
        /**  Devera ser informada data da nota da sa°da 
        **/
        {include/i-vldprg.i}
        run utp/ut-msgs.p (input "show",input 15200,input " ").
        apply 'entry' to it-doc-fisico.data-comp in frame {&frame-name}.
        return 'adm-error':U.
    end.
    
    if l-pede-data-comp and
        (input frame {&frame-name} it-doc-fisico.nr-pedcli <> "" or
        input frame {&frame-name} it-doc-fisico.nr-pd-seq <> 0) then do:
        find first ped-item where
            ped-item.nome-abrev   = emitente.nome-abrev and
            ped-item.nr-pedcli    = input frame {&frame-name} it-doc-fisico.nr-pedcli and
            ped-item.nr-sequencia = input frame {&frame-name} it-doc-fisico.nr-pd-seq and
            ped-item.it-codigo    = c-it-codigo
            no-lock no-error.
        if not available ped-item then do:
            /**  Item n∆o consta no pedido de venda 
            **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7154,input " ").
            apply 'entry' to it-doc-fisico.nr-pedcli in frame {&frame-name}.
            return 'adm-error':U.
        end.
        find ped-venda where
            ped-venda.nome-abrev = ped-item.nome-abrev and
            ped-venda.nr-pedcli  = ped-item.nr-pedcli
            no-lock no-error.
        if not available ped-venda or 
            (available ped-venda and 
            ped-venda.cod-sit-ped = 4) then do:
            /**  Pedido de venda esta suspenso 
            **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7152,input " ").
            apply 'entry' to it-doc-fisico.nr-pedcli in frame {&frame-name}.
            return 'adm-error':U.
        end.
        if not available ped-venda or 
            (available ped-venda and 
            ped-venda.cod-sit-ped = 9) then do:
            /**  Pedido de venda esta cancelado 
            **/
            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show",input 7153,input " ").
            apply 'entry' to it-doc-fisico.nr-pedcli in frame {&frame-name}.
            return 'adm-error':U.
        end.
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
  {src/adm/template/snd-list.i "it-doc-fisico"}

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


