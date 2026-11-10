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
{include/i-prgvrs.i V13IN144 2.00.00.012 } /*** 010012 ***/

&IF "{&EMSFND_VERSION}" >= "1.00"
&THEN
{include/i-license-manager.i V13IN144 MUT}
&ENDIF


/* Create an unnamed pool to store all the widgets created 
     by this procedure. This is a good default which assures
     that this procedure's triggers and internal procedures 
     will execute in this procedure's storage, and that proper
     cleanup will occur on deletion of the procedure. */

CREATE WIDGET-POOL.

/* ***************************  Definitions  ************************** */
&Scop adm-attribute-dlg support/viewerd.w

def var v-row-parent as rowid no-undo.

DEF TEMP-TABLE tt-ordens NO-UNDO
    FIELD nr-ord-produ LIKE oper-ord.nr-ord-produ
    FIELD it-codigo    LIKE oper-ord.it-codigo
    FIELD op-codigo    LIKE oper-ord.op-codigo
    FIELD cod-roteiro  LIKE oper-ord.cod-roteiro
    FIELD pto-controle LIKE oper-ord.pto-controle
    INDEX id IS PRIMARY nr-ord-produ op-codigo it-codigo.

DEF VAR l-erro AS LOG NO-UNDO.
DEFINE VARIABLE i-ind-tip-ctrab AS INTEGER    NO-UNDO.

{cdp/cdcfgman.i} /*preprocessadores manufatura*/

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
&Scoped-define EXTERNAL-TABLES grup-maquina
&Scoped-define FIRST-EXTERNAL-TABLE grup-maquina


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR grup-maquina.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS grup-maquina.num-operador-ctrab ~
grup-maquina.num-operac-simult grup-maquina.qtd-carga-batch ~
grup-maquina.qtd-lead-time grup-maquina.log-pto-control ~
grup-maquina.log-reporte-contador grup-maquina.log-possui-prepar 
&Scoped-define ENABLED-TABLES grup-maquina
&Scoped-define FIRST-ENABLED-TABLE grup-maquina
&Scoped-Define ENABLED-OBJECTS RECT-3 RECT-4 
&Scoped-Define DISPLAYED-FIELDS grup-maquina.num-operador-ctrab ~
grup-maquina.num-operac-simult grup-maquina.qtd-carga-batch ~
grup-maquina.qtd-lead-time grup-maquina.log-pto-control ~
grup-maquina.log-reporte-contador grup-maquina.log-possui-prepar 
&Scoped-define DISPLAYED-TABLES grup-maquina
&Scoped-define FIRST-DISPLAYED-TABLE grup-maquina
&Scoped-Define DISPLAYED-OBJECTS cb-tempo-operac cb-reporte-mod ~
i-cdn-interface c-texto1 c-texto2 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-MODIFY-FIELDS grup-maquina.num-operador-ctrab ~
grup-maquina.num-operac-simult cb-tempo-operac grup-maquina.qtd-carga-batch ~
grup-maquina.qtd-lead-time cb-reporte-mod i-cdn-interface ~
grup-maquina.log-pto-control 

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
DEFINE VARIABLE cb-reporte-mod AS CHARACTER FORMAT "X(16)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 3
     DROP-DOWN-LIST
     SIZE 15.57 BY 1 NO-UNDO.

DEFINE VARIABLE cb-tempo-operac AS CHARACTER FORMAT "X(17)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 4
     DROP-DOWN-LIST
     SIZE 15.43 BY 1 NO-UNDO.

DEFINE VARIABLE c-texto1 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .67 NO-UNDO.

DEFINE VARIABLE c-texto2 AS CHARACTER FORMAT "X(256)":U 
      VIEW-AS TEXT 
     SIZE 11 BY .58 NO-UNDO.

DEFINE VARIABLE i-cdn-interface AS INTEGER FORMAT ">>9":U INITIAL 0 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 7.72 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-3
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 4.21.

DEFINE RECTANGLE RECT-4
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85 BY 5.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     grup-maquina.num-operador-ctrab AT ROW 1.71 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     grup-maquina.num-operac-simult AT ROW 2.79 COL 23 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 4.57 BY .88
     cb-tempo-operac AT ROW 3.92 COL 23 COLON-ALIGNED
     grup-maquina.qtd-carga-batch AT ROW 1.71 COL 57.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.14 BY .88
     grup-maquina.qtd-lead-time AT ROW 2.79 COL 57.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.43 BY .88
     cb-reporte-mod AT ROW 6.46 COL 23 COLON-ALIGNED
     i-cdn-interface AT ROW 7.79 COL 23.14 COLON-ALIGNED
     grup-maquina.log-pto-control AT ROW 6.46 COL 59.57
          VIEW-AS TOGGLE-BOX
          SIZE 13.14 BY .83
     grup-maquina.log-reporte-contador AT ROW 7.46 COL 59.43
          VIEW-AS TOGGLE-BOX
          SIZE 19.72 BY .83
     grup-maquina.log-possui-prepar AT ROW 8.46 COL 59.43
          VIEW-AS TOGGLE-BOX
          SIZE 21.14 BY .83
     c-texto1 AT ROW 1.08 COL 2.86 NO-LABEL
     c-texto2 AT ROW 5.67 COL 2.72 NO-LABEL
     RECT-3 AT ROW 1.21 COL 1.14
     RECT-4 AT ROW 5.92 COL 1.14
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.grup-maquina
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
         HEIGHT             = 10.21
         WIDTH              = 85.14.
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
   NOT-VISIBLE Size-to-Fit Custom                                       */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-texto1 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR FILL-IN c-texto2 IN FRAME f-main
   NO-ENABLE ALIGN-L                                                    */
/* SETTINGS FOR COMBO-BOX cb-reporte-mod IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR COMBO-BOX cb-tempo-operac IN FRAME f-main
   NO-ENABLE 3                                                          */
/* SETTINGS FOR FILL-IN i-cdn-interface IN FRAME f-main
   NO-ENABLE 3                                                          */
ASSIGN 
       i-cdn-interface:HIDDEN IN FRAME f-main           = TRUE.

/* SETTINGS FOR TOGGLE-BOX grup-maquina.log-pto-control IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.num-operac-simult IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.num-operador-ctrab IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.qtd-carga-batch IN FRAME f-main
   3                                                                    */
/* SETTINGS FOR FILL-IN grup-maquina.qtd-lead-time IN FRAME f-main
   3                                                                    */
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

&Scoped-define SELF-NAME cb-tempo-operac
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL cb-tempo-operac V-table-Win
ON VALUE-CHANGED OF cb-tempo-operac IN FRAME f-main
DO:

  if input frame {&frame-name} cb-tempo-operac = {ininc/i06in144.i 04 3} then 
       assign grup-maquina.qtd-carga-batch:sensitive in frame {&frame-name} = yes.
  else assign grup-maquina.qtd-carga-batch:sensitive in frame {&frame-name} = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&Scoped-define SELF-NAME i-cdn-interface
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-interface V-table-Win
ON F5 OF i-cdn-interface IN FRAME f-main
DO:
    assign l-implanta = no.
    {include/zoomvar.i &prog-zoom="mfzoom/z01mf543.w"
                       &campo=i-cdn-interface
                       &campozoom=cdn-interface} 
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL i-cdn-interface V-table-Win
ON MOUSE-SELECT-DBLCLICK OF i-cdn-interface IN FRAME f-main
DO:
  apply 'F5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */

{utp/ut-liter.i Padr∆o_Operaá∆o * R}
assign c-texto1 = return-value.

{utp/ut-liter.i Controle_F†brica * R}
assign c-texto2 = return-value.

{utp/ut-field.i mgind grup-maquina ind-tempo-operac 01}
assign cb-tempo-operac:label in frame {&frame-name} = return-value.

{utp/ut-field.i mgind grup-maquina ind-reporte-mod 01}
assign cb-reporte-mod:label in frame {&frame-name} = return-value.

&IF DEFINED (bf_man_trans_assinc) &THEN

{utp/ut-field.i mgmfg interface-rep cdn-interface 01}
assign i-cdn-interface:label in frame {&frame-name} = return-value.

i-cdn-interface:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name}.

&ENDIF

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         

  /************************ INTERNAL PROCEDURES ********************/

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
  {src/adm/template/row-list.i "grup-maquina"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "grup-maquina"}

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

    do with frame {&frame-name}:
        assign cb-tempo-operac
               cb-reporte-mod.
    end.     

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.

    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */

    assign grup-maquina.ind-tempo-operac    = {ininc/i06in144.i 06 cb-tempo-operac}
           grup-maquina.ind-reporte-mod     = {ininc/i02in144.i 06 cb-reporte-mod}.

    for each ctrab where
             ctrab.gm-codigo = grup-maquina.gm-codigo exclusive-lock :

        assign ctrab.log-ctrab-progdo = grup-maquina.log-ctrab-progdo 
               ctrab.ind-tip-ctrab    = grup-maquina.ind-tip-ctrab    
               ctrab.log-pto-control  = grup-maquina.log-pto-control
               ctrab.ind-reporte-mod  = grup-maquina.ind-reporte-mod.

    end.
    &IF DEFINED (bf_man_trans_assinc) &THEN

    assign grup-maquina.cdn-interface = input frame {&frame-name} i-cdn-interface.

    &ENDIF

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

  /* Code placed here will execute PRIOR to standard behavior. */

  if available grup-maquina then
     assign cb-tempo-operac = {ininc/i06in144.i 04 grup-maquina.ind-tempo-operac}     
            cb-reporte-mod  = {ininc/i02in144.i 04 grup-maquina.ind-reporte-mod}.
  else
     assign cb-tempo-operac = {ininc/i06in144.i 04 01}     
            cb-reporte-mod  = {ininc/i02in144.i 04 01}.

  &IF DEFINED (bf_man_trans_assinc) &THEN

    assign i-cdn-interface = grup-maquina.cdn-interface.

  &ENDIF

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

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ) .

    /* Code placed here will execute AFTER standard behavior.    */
    &if  defined(ADM-MODIFY-FIELDS) &then
    /*if adm-new-record = yes then*/
        enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
    &endif

    if input frame {&frame-name} cb-tempo-operac = {ininc/i06in144.i 04 3} then 
         assign grup-maquina.qtd-carga-batch:sensitive in frame {&frame-name} = yes.
    else assign grup-maquina.qtd-carga-batch:sensitive in frame {&frame-name} = no.  

  &IF DEFINED (bf_man_trans_assinc) &THEN

  &ELSE
      assign i-cdn-interface:hidden    in frame {&frame-name} = yes
             i-cdn-interface:sensitive in frame {&frame-name} = no.
  &ENDIF

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

 do with frame {&frame-name}:
    assign cb-tempo-operac:list-items = {ininc/i06in144.i 03}
           cb-reporte-mod:list-items  = {ininc/i02in144.i 03}.
 end.

  &IF DEFINED (bf_man_trans_assinc) &THEN
      assign i-cdn-interface:hidden in frame {&frame-name} = no.
  &ENDIF

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

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
  Notes: N∆o fazer assign aqui. Nesta procedure
  devem ser colocadas apenas validaá‰es, pois neste ponto do programa o registro 
  ainda n∆o foi criado.       
------------------------------------------------------------------------------*/
    {include/i-vldfrm.i} /* Validaá∆o de dicion†rio */

DEF VAR c-erro AS CHAR FORMAT "x(60)" NO-UNDO.
DEF VAR c-help-erro AS CHAR FORMAT "x(6000)" NO-UNDO.
DEFINE VARIABLE c-ordem    AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-item     AS CHARACTER  NO-UNDO.
DEFINE VARIABLE c-operacao AS CHARACTER  NO-UNDO.

/*/*    Segue um exemplo de validaá∆o de programa */
 *     find tabela where tabela.campo1 = c-variavel and
 *                       tabela.campo2 > i-variavel no-lock no-error.
 *     
 *     /* Este include deve ser colocado sempre antes do ut-msgs.p */
 *     {include/i-vldprg.i}
 *     run utp/ut-msgs.p (input "show":U, input 7, input return-value).
 *     return 'ADM-ERROR':U.*/

    &IF DEFINED (bf_man_trans_assinc) &THEN
     if  int(i-cdn-interface:screen-value in frame {&frame-name}) <> 0 then do :
         find first interface-rep
             where interface-rep.cdn-interface = int(i-cdn-interface:screen-value in frame {&frame-name}) 
              no-lock no-error.

         if  not avail interface-rep then do:

            {include/i-vldprg.i}
            {utp/ut-table.i mgmfg interface-rep 01}
            run utp/ut-msgs.p (input "show":U, 
                               input 47,
                               input return-value).
            apply 'entry' to i-cdn-interface in frame {&frame-name}.
            return 'ADM-ERROR':U.
         end.
         ELSE DO:
            case i-ind-tip-ctrab:
                 when 1 then do:
                    if interface-rep.ind-monoproc = 2 then do : 
                      run utp/ut-msgs.p (input "show":U, 
                                         input 26401,
                                         input "":U).
                      return 'ADM-ERROR':U.    
                    end.  
                 end.
                 when 2 then do:
                    if interface-rep.ind-batelada = 2 then do : 
                       run utp/ut-msgs.p (input "show":U, 
                                          input 26401,
                                          input "":U).
                       return 'ADM-ERROR':U.
                    end.
                 end.
            
                 when 3 then do :
                    if interface-rep.ind-multiproc = 2 then do : 
                       run utp/ut-msgs.p (input "show":U, 
                                          input 26401,
                                          input "":U).
                                          return 'ADM-ERROR':U.
                    end.   
                 end.
             
                 when 4 then do :
                    if interface-rep.ind-posto-manual = 2  then do :
                     
                      run utp/ut-msgs.p (input "show":U, 
                                         input 26401,
                                         input "":U).
                      return 'ADM-ERROR':U.            
                    end.
                 end.        
            end case.    
         END.
     end.
    &ENDIF

    /*** N∆o permite alterar para "nao" reportado um grupo de maquina que possua operacoes pendentes de reporte ***/
    IF  grup-maquina.log-pto-control 
    AND NOT grup-maquina.log-pto-control:CHECKED IN FRAME {&frame-name} THEN DO:

        ASSIGN l-erro = NO.
        EMPTY TEMP-TABLE tt-ordens.

        FOR EACH oper-ord FIELDS(nr-ord-produ gm-codigo estado pto-controle it-codigo op-codigo cod-roteiro)
            WHERE oper-ord.gm-codigo = grup-maquina.gm-codigo
              AND oper-ord.estado    < 3 NO-LOCK:


            FOR FIRST ord-prod FIELDS(nr-ord-produ rep-prod)
                WHERE ord-prod.nr-ord-produ = oper-ord.nr-ord-produ NO-LOCK: END.
            IF  ord-prod.rep-prod = 2
            OR (ord-prod.rep-prod = 3
            AND oper-ord.pto-controle <> 0) THEN DO:

                ASSIGN l-erro = YES.
                CREATE tt-ordens.
                BUFFER-COPY oper-ord TO tt-ordens.
            END.
        END.
        IF  l-erro THEN DO:
            {utp/ut-liter.i N∆o_Ç_permitida_a_alteraá∆o_para_N«O_REPORTADO. *}
            ASSIGN c-erro = RETURN-VALUE.
            {utp/ut-liter.i Existem_as_seguintes_operaá‰es_em_andamento_para_o_grupo_de_m†quina: *}
            ASSIGN c-help-erro = RETURN-VALUE + " ":U + CHR(10).
            {utp/ut-liter.i Ordem *}
            ASSIGN c-ordem = " ":U + RETURN-VALUE + ": ":U.  
            {utp/ut-liter.i Item *}
            ASSIGN c-item = " ":U + RETURN-VALUE + ": ":U. 
            {utp/ut-liter.i Operaá∆o *}
            ASSIGN c-operacao = " ":U + RETURN-VALUE + ": ":U. 

            FOR EACH tt-ordens:
                ASSIGN c-help-erro = c-help-erro + 
                                     c-ordem     + trim(STRING(tt-ordens.nr-ord-produ)) +
                                     c-item      + TRIM(tt-ordens.it-codigo) + 
                                     c-operacao  + TRIM(STRING(tt-ordens.op-codigo)) + 
                                     CHR(10).

                IF length(c-help-erro) > 6000 THEN
                    UNDO, LEAVE.
            END.

            {include/i-vldprg.i}
            run utp/ut-msgs.p (input "show":U, 
                               input 17006,
                               input c-erro + "~~" + c-help-erro).
            apply 'entry' to grup-maquina.log-pto-control in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
    END.
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
  {src/adm/template/snd-list.i "grup-maquina"}

  /* Deal with any unexpected table requests before closing.           */
  {src/adm/template/snd-end.i}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setaTipo V-table-Win 
PROCEDURE setaTipo :
/*------------------------------------------------------------------------------
  Purpose:     Recebe o Tipo de Processador, da p†gina 1, na etapa de validacao do programa.
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEF INPUT PARAM p-ind-tip-ctrab AS INT NO-UNDO.

ASSIGN i-ind-tip-ctrab = p-ind-tip-ctrab.

RETURN "OK":U.
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

