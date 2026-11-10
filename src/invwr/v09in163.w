&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgmov            PROGRESS
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
{include/i-prgvrs.i V09IN163 2.00.00.011 } /*** "010011" 28/12/2023 09:52:42  ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V09IN163 MUT}
&ENDIF


    CREATE WIDGET-POOL.
    &Scop adm-attribute-dlg support/viewerd.w

    def new global shared var v-row-parent   as rowid no-undo.                                
    def new global shared var gr-doc-fisico  as rowid no-undo.
    def new global shared var gr-emitente    as rowid no-undo.

    def var h-re0301 as handle no-undo.
    DEF VAR h-boin847  AS HANDLE NO-UNDO.
    def var c-handle as char   no-undo.
    def var c-label  as handle no-undo.

    def var i-indice-cq   as int                      no-undo.

{cdp/cdcfgmat.i}

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
&Scoped-define EXTERNAL-TABLES doc-fisico
&Scoped-define FIRST-EXTERNAL-TABLE doc-fisico


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR doc-fisico.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS doc-fisico.cod-emitente doc-fisico.nro-docto ~
doc-fisico.serie-docto 
&Scoped-define ENABLED-TABLES doc-fisico
&Scoped-define FIRST-ENABLED-TABLE doc-fisico
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS doc-fisico.cod-emitente ~
doc-fisico.nro-docto doc-fisico.serie-docto 
&Scoped-define DISPLAYED-TABLES doc-fisico
&Scoped-define FIRST-DISPLAYED-TABLE doc-fisico
&Scoped-Define DISPLAYED-OBJECTS c-emitente c-cgc c-ind-sit-wms-ext c-tipo-nota 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS c-cgc 

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


/* Menu Definitions                                                     */
DEFINE MENU POPUP-MENU-c-cgc 
       MENU-ITEM CPF            LABEL "Pessoa F°sica" 
       MENU-ITEM CGC            LABEL "Pessoa Jur°dica"
       MENU-ITEM Estrangeiro    LABEL "Estrangeiro"   
       MENU-ITEM Trading        LABEL "Trading"       .


/* Definitions of the field level widgets                               */
DEFINE VARIABLE c-cgc AS CHARACTER FORMAT "x(19)" 
     LABEL "CGC" 
     VIEW-AS FILL-IN 
     SIZE 15 BY .88 NO-UNDO.

DEFINE VARIABLE c-emitente AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 40.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-ind-sit-wms-ext AS CHARACTER FORMAT "X(256)":U 
     LABEL "Situaá∆o WMS Ext" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE VARIABLE c-tipo-nota AS CHARACTER FORMAT "X(256)":U 
     LABEL "Tipo Nota" 
     VIEW-AS FILL-IN 
     SIZE 21 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.29 BY 3.38.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     doc-fisico.cod-emitente AT ROW 1.25 COL 13.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-emitente AT ROW 1.25 COL 23 COLON-ALIGNED NO-LABEL
     c-cgc AT ROW 2.25 COL 13.14 COLON-ALIGNED HELP
          "CGC ou CIC do cliente/fornecedor"
     c-ind-sit-wms-ext AT ROW 2.25 COL 65 COLON-ALIGNED WIDGET-ID 4
     doc-fisico.nro-docto AT ROW 3.25 COL 13.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     doc-fisico.serie-docto AT ROW 3.25 COL 40 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.43 BY .88
     c-tipo-nota AT ROW 3.25 COL 65 COLON-ALIGNED
     rt-key AT ROW 1 COL 1
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
         HEIGHT             = 3.46
         WIDTH              = 88.57.
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

/* SETTINGS FOR FILL-IN c-cgc IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       c-cgc:POPUP-MENU IN FRAME f-main       = MENU POPUP-MENU-c-cgc:HANDLE.

/* SETTINGS FOR FILL-IN c-emitente IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-ind-sit-wms-ext IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-tipo-nota IN FRAME f-main
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

 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
        RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
    &ENDIF         

    {utp/ut-liter.i Tipo_Nota MRE L}  
    assign c-tipo-nota:label in frame {&FRAME-NAME}  = return-value.

    {utp/ut-liter.i Situaá∆o_WMS_Ext MRE L}  
    assign c-ind-sit-wms-ext:label in frame {&FRAME-NAME}  = return-value.

    find first param-cq no-lock no-error.

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

    /* Ponha na pi-validate todas as validaá‰es */
    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    /* Code placed here will execute PRIOR to standard behavior. */

    DEF VAR h-bodi578 AS HANDLE NO-UNDO.

    {rep/re2001.i 1 "CLOSE"}
    IF v-row-parent <> ? THEN
       FOR FIRST doc-fisico NO-LOCK
           WHERE ROWID(doc-fisico) = v-row-parent:
       END.
    /**********************************************************
    ** Desenvolvimento Engenharia Controle de Seriais        **
    ** Variavel indicara se a funcao SPP-SERIAIS-NF estara   **
    ** ativa ou nao.                                         **
    **********************************************************/
    DEFINE VARIABLE l-funcao-spp-seriais-nf AS LOGICAL NO-UNDO.
    DEFINE VARIABLE l-deleta                AS LOGICAL NO-UNDO.

    ASSIGN l-deleta = YES.

    IF doc-fisico.log-1 = YES  THEN DO:
       RUN utp/ut-msgs.p (INPUT "SHOW":U,
                          INPUT "29977",
                          INPUT "":U).
       IF RETURN-VALUE = "NO" THEN 
          ASSIGN l-deleta = no.
    END.

    IF l-deleta = YES THEN DO:

       FIND FIRST funcao
            WHERE funcao.cd-funcao = "spp-seriais-nf":U
              AND funcao.ativo     = YES NO-LOCK NO-ERROR.

       IF AVAIL funcao THEN
          ASSIGN l-funcao-spp-seriais-nf = YES.
       ELSE
          ASSIGN l-funcao-spp-seriais-nf = NO.

       /*****************************************
       ** Nova Funcionalidade Controle Seriais **
       *****************************************/
       &IF '{&bf_mat_versao_ems}' >= '2.05' &THEN
           IF l-funcao-spp-seriais-nf THEN DO:
               FOR EACH it-doc-fisico-serial EXCLUSIVE-LOCK
                  WHERE it-doc-fisico-serial.cod-ser-docto = doc-fisico.serie-docto  
                    AND it-doc-fisico-serial.cod-docto     = doc-fisico.nro-docto    
                    AND it-doc-fisico-serial.cdn-emitente  = doc-fisico.cod-emitente:

                   DELETE it-doc-fisico-serial.
               END.
           END.
       &ENDIF

       /* atualiza saldo faturamento antecipado, voltando o saldo da nota eliminada */
       IF  NOT VALID-HANDLE(h-bodi578) THEN
           RUN dibo/bodi578.p PERSISTENT SET h-bodi578.

       IF  VALID-HANDLE(h-bodi578) THEN DO:

           RUN openQueryStatic IN h-bodi578("main").

           IF  doc-fisico.tipo-nota = 11 /* faturamento antecipado */ THEN
           FOR EACH it-doc-fisico FIELDS (seq-comp quantidade) 
               OF doc-fisico NO-LOCK:
               RUN atualizaSaldoFisicoItem IN h-bodi578(it-doc-fisico.seq-comp, /* ID do sdo-fatur-antecip */
                                                        "",                   /* cod-estabel  */
                                                        "",                   /* serie-docto  */  
                                                        "",                   /* nr-nota-fis  */  
                                                        0,                    /* cod-emitente */
                                                        "",                   /* it-codigo    */                        
                                                        "",                   /* cod-refer    */ 
                                                        0,                    /* num-seq      */
                                                        (it-doc-fisico.quantidade * -1)). /* qtd-saldo    */
           END.                                        
                                                       
           DELETE PROCEDURE h-bodi578 NO-ERROR.

       END.

       run pi-AtualizaNVInsp .

       /* Conversor NFe */
       IF  CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN
           RUN piAtualizaConversorNfe.
       /* Fim Conversor NFe */

       /* Dispatch standard ADM method.                             */
       RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

       IF NOT AVAIL doc-fisico THEN
          run pi-desabilita-atualizar in h-re0301 (input YES). 

       /* Code placed here will execute AFTER standard behavior.    */
    END.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose: Override standard ADM method    
  Parameters:  
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
        IF  VALID-HANDLE(h-boin847)        AND
            h-boin847:TYPE = "PROCEDURE":U AND
            h-boin847:FILE-NAME = "inbo/boin847.p":U THEN DO:
            DELETE PROCEDURE h-boin847.
            ASSIGN h-boin847 = ?.
        END.
    END.
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .
    
    RETURN "OK":U.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    if available doc-fisico then do:
        find emitente where
             emitente.cod-emitente = doc-fisico.cod-emitente
            no-lock no-error.
        if available emitente then
            assign c-emitente:screen-value in frame {&frame-name} = emitente.nome-abrev
                   c-cgc:screen-value      in frame {&frame-name} = emitente.cgc.
        else 
            assign c-emitente:screen-value in frame {&frame-name} = ""
                   c-cgc:screen-value      in frame {&frame-name} = "".

        assign c-tipo-nota  :screen-value in frame {&frame-name} = {ininc/i01in089.i 04 doc-fisico.tipo-nota}.
        
        IF CAN-FIND(FIRST funcao NO-LOCK
                    WHERE funcao.cd-funcao = "WMS-SAAS":U
                      AND funcao.ativo) THEN
         ASSIGN c-ind-sit-wms-ext:screen-value in frame {&frame-name} = IF doc-fisico.ind-sit-wms-ext = 0 THEN {ininc/i03in089.i 04 1} ELSE {ininc/i03in089.i 04 doc-fisico.ind-sit-wms-ext}.
        ELSE
          ASSIGN c-ind-sit-wms-ext:screen-value in frame {&frame-name} = "".
    end.        

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

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  ASSIGN c-ind-sit-wms-ext:VISIBLE in frame {&frame-name} = CAN-FIND(FIRST funcao NO-LOCK
             WHERE funcao.cd-funcao = "WMS-SAAS":U
               AND funcao.ativo).

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

    def var i-pagina as integer no-undo.

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

    RUN Who-Is-The-Container IN adm-broker-hdl 
        (INPUT THIS-PROCEDURE, OUTPUT c-handle).

    assign h-re0301 = widget-handle(c-handle).

    if avail doc-fisico then do:
        IF VALID-HANDLE (h-re0301) THEN DO:
            if doc-fisico.situacao = 1 then do: /*N∆o atualizado*/
                RUN pi-desabilita-manutencao IN h-re0301 (input yes, input yes, input yes).

                CASE doc-fisico.ind-sit-wms-ext:
                    WHEN 2 OR WHEN 3 THEN DO: // Aguardando ou Em processo WMS
                        RUN pi-desabilita-manutencao IN h-re0301 (input no, input no, input no).
                        RUN pi-habilita-modifica IN h-re0301 (input no, input yes).
                    END.
                    WHEN 4 THEN DO: // Conferencia OK - Habilita apenas o bota∆o de atualizar
                        RUN pi-desabilita-manutencao IN h-re0301 (input no, input no, input yes).
                    END.
                    WHEN 5 THEN DO: // Conferencia NOK
                        RUN pi-desabilita-manutencao IN h-re0301 (input no, input no, input yes).
                        RUN pi-habilita-modifica IN h-re0301 (input yes, input yes).
                    END.
                END.
            end.
            else do:
                run pi-desabilita-manutencao in h-re0301 (input no, input no, input no).
            end.
        END.

        assign gr-doc-fisico  = rowid(doc-fisico)
               v-row-parent   = rowid(doc-fisico).

        find emitente where
             doc-fisico.cod-emitente = emitente.cod-emitente no-lock no-error.
        if avail emitente then
             assign gr-emitente = rowid(emitente).           
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-AtualizaNVInsp V-table-Win 
PROCEDURE pi-AtualizaNVInsp :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
if  avail param-cq
    and param-cq.tipo-cq = 3 then do:

      FOR EACH  it-doc-fisico 
          WHERE it-doc-fisico.serie-docto  = doc-fisico.serie-docto  
          AND   it-doc-fisico.nro-docto    = doc-fisico.nro-docto    
          AND   it-doc-fisico.cod-emitente = doc-fisico.cod-emitente no-lock:
            find first item
                 where item.it-codigo = it-doc-fisico.it-codigo no-lock no-error.

            for each rat-lote
                where rat-lote.cod-emitente = it-doc-fisico.cod-emitente
                and   rat-lote.nro-docto    = it-doc-fisico.nro-docto
                and   rat-lote.nat-operacao = ""
                and   rat-lote.serie-docto  = it-doc-fisico.serie-docto
                and   rat-lote.sequencia    = it-doc-fisico.sequencia  no-lock:
            
            
                find first item-fornec-estab
                    where  item-fornec-estab.it-codigo    = it-doc-fisico.it-codigo
                    and    item-fornec-estab.cod-emitente = it-doc-fisico.cod-emitente
                    and    item-fornec-estab.cod-estabel  = doc-fisico.cod-estabel exclusive-lock no-error.
            
                if avail item-fornec-estab
                and  item-fornec-estab.tp-inspecao > 3 then do:
                    if item-fornec-estab.niv-inspecao > 0 then do:
                        assign item-fornec-estab.niv-inspecao =  item-fornec-estab.niv-inspecao - 1.
                    end.
                    else do:
                        assign i-indice-cq = if  item.criticidade = 1 
                                             then param-cq.ins-pref-x[item-fornec-estab.tp-inspecao - 3]
                                             else 
                                                 if  item.criticidade = 2 
                                                 then param-cq.ins-pref-y[item-fornec-estab.tp-inspecao - 3]
                                                 else 
                                                     if  item.criticidade = 3 
                                                     then param-cq.ins-pref-z[item-fornec-estab.tp-inspecao - 3]
                                                     else 0.
                        
                        assign item-fornec-estab.niv-inspecao =  i-indice-cq.
                    end.
                end.
            
                if not avail item-fornec-estab then do:
                    find first item-fornec
                        where  item-fornec.it-codigo    = it-doc-fisico.it-codigo
                        and    item-fornec.cod-emitente = it-doc-fisico.cod-emitente exclusive-lock no-error.
                    if avail item-fornec
                    and  item-fornec.tp-inspecao > 3 then do:
                         if  item-fornec.niv-inspecao > 0 then
                             assign item-fornec.niv-inspecao =  item-fornec.niv-inspecao - 1.
                         else do:
                             assign i-indice-cq = if  item.criticidade = 1
                                                  then param-cq.ins-pref-x[item-fornec.tp-inspecao - 3]
                                                  else 
                                                      if  item.criticidade = 2 
                                                      then param-cq.ins-pref-y[item-fornec.tp-inspecao - 3]
                                                      else 
                                                          if  item.criticidade = 3 
                                                          then param-cq.ins-pref-z[item-fornec.tp-inspecao - 3]
                                                          else 0.
                             
                             assign item-fornec.niv-inspecao =  i-indice-cq.
                         end.
                    end.
                end.
            end.
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

/*/*    Segue um exemplo de validaá∆o de programa */
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piAtualizaConversorNfe V-table-Win 
PROCEDURE piAtualizaConversorNfe :
/*------------------------------------------------------------------------------
  Purpose: Atualiza dados no Conversor de NFe   
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    IF CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-conv-nfe-entrada":U AND funcao.ativo NO-LOCK) THEN DO:
        if not valid-handle(h-boin847) or
            h-boin847:type      <> "PROCEDURE":U or
            h-boin847:file-name <> "inbo/boin847.p":U then
            
            RUN inbo/boin847.p PERSISTENT SET h-boin847.
        
        RUN atualizaSituacaoEliminacaoDocFisico IN h-boin847 (INPUT doc-fisico.serie-docto,
                                                              INPUT doc-fisico.nro-docto,
                                                              INPUT doc-fisico.cod-emitente,
                                                              INPUT doc-fisico.cod-estabel,
                                                              INPUT doc-fisico.tipo-nota,
                                                              INPUT doc-fisico.cod-chave-aces-nf-eletro,
                                                              INPUT doc-fisico.dt-emissao). 
    END.

    RETURN "OK":U.

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

