&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgind            PROGRESS
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
{include/i-prgvrs.i V02IN656 2.00.00.003}  /*** 010003 ***/


&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v02in656 MUT}
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

/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */
def var v-row-parent as rowid no-undo.

{cdp/cdcfgmat.i}

&if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    {cdp/cd9590.i}
    {cdp/cd0666.i}

    DEF VAR hProgramZoom AS HANDLE NO-UNDO.
    DEF VAR h-cdapi024   AS HANDLE NO-UNDO.
    
    if not valid-handle(h-cdapi024) then
        run cdp/cdapi024.p persistent set h-cdapi024.
&ELSE
    def temp-table tt_unid_negoc no-undo
        field cod_unid_negoc               as character format "x(3)"  label "Unid Neg¢cio" column-label "Un Neg"
        field des_unid_negoc               as character format "x(40)" label "Descri‡Æo" column-label "Descri‡Æo"
        field cdn_unid_negoc               as Integer   format ">>9"   initial 0 label "N£mero Unidade Negoc" column-label "Numero UN".

    def new global shared var v_cod_unid_negoc as character format "x(3)" label "Unid Neg¢cio" column-label "Un Neg" no-undo.
&ENDIF

def buffer b-neg-nota for unid-neg-nota.
def var d-perc as decimal initial 0 no-undo.

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
&Scoped-define EXTERNAL-TABLES unid-neg-nota
&Scoped-define FIRST-EXTERNAL-TABLE unid-neg-nota


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR unid-neg-nota.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS unid-neg-nota.perc-unid-neg 
&Scoped-define ENABLED-TABLES unid-neg-nota
&Scoped-define FIRST-ENABLED-TABLE unid-neg-nota
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS unid-neg-nota.cod_unid_negoc ~
unid-neg-nota.perc-unid-neg 
&Scoped-define DISPLAYED-TABLES unid-neg-nota
&Scoped-define FIRST-DISPLAYED-TABLE unid-neg-nota
&Scoped-Define DISPLAYED-OBJECTS c-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS unid-neg-nota.cod_unid_negoc ~
unid-neg-nota.perc-unid-neg 
&Scoped-define ADM-ASSIGN-FIELDS unid-neg-nota.cod_unid_negoc ~
unid-neg-nota.perc-unid-neg 
&Scoped-define ADM-MODIFY-FIELDS unid-neg-nota.perc-unid-neg 

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
DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "X(256)":U 
     VIEW-AS FILL-IN 
     SIZE 35.14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 67 BY 2.63.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     unid-neg-nota.cod_unid_negoc AT ROW 1.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-descricao AT ROW 1.46 COL 28.43 COLON-ALIGNED NO-LABEL
     unid-neg-nota.perc-unid-neg AT ROW 2.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 10.29 BY .88
     rt-mold AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.unid-neg-nota
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
         HEIGHT             = 2.63
         WIDTH              = 67.
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

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN unid-neg-nota.cod_unid_negoc IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN unid-neg-nota.perc-unid-neg IN FRAME f-main
   1 2 3                                                                */
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

&Scoped-define SELF-NAME unid-neg-nota.cod_unid_negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL unid-neg-nota.cod_unid_negoc V-table-Win
ON F5 OF unid-neg-nota.cod_unid_negoc IN FRAME f-main /* Unid Neg¢cio */
DO:
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    
        {method/zoomfields.i &ProgramZoom="inzoom/z01in745.w"
                             &FieldZoom1="cod-unid-negoc"
                             &FieldScreen1="unid-neg-nota.cod_unid_negoc"
                             &Frame1="{&frame-name}"
                             &FieldZoom2="des-unid-negoc"
                             &FieldScreen2="c-descricao"
                             &Frame2="{&frame-name}"
                             &EnableImplant="NO"}
    &ELSE
        if  search("prgint/utb/utb011ka.p") <> ? 
        or  search("prgint/utb/utb011ka.r") <> ? then do:
    
            run prgint/utb/utb011ka.p  persistent set wh-pesquisa.
    
            if  v_cod_unid_negoc <> " " then 
                assign unid-neg-nota.cod_unid_negoc:screen-value in frame {&frame-name} = v_cod_unid_negoc .
        end.        
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL unid-neg-nota.cod_unid_negoc V-table-Win
ON LEAVE OF unid-neg-nota.cod_unid_negoc IN FRAME f-main /* Unid Neg¢cio */
DO:

    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
    
        {include/leave.i &tabela=unid-negoc
                         &atributo-ref=des-unid-negoc
                         &variavel-ref=c-descricao
                         &WHERE="unid-negoc.cod-unid-negoc = input frame {&frame-name} unid-neg-nota.cod_unid_negoc"}
    &ELSE
        for each tt_unid_negoc exclusive-lock:
            delete tt_unid_negoc.
        end.
        
        create tt_unid_negoc.
        assign tt_unid_negoc.cod_unid_negoc = input frame {&frame-name} unid-neg-nota.cod_unid_negoc.
    
        run prgint/utb/utb907za.py ( input 1,
                                     input-output table tt_unid_negoc ).
    
        find first tt_unid_negoc no-lock no-error.
        
        assign c-descricao:screen-value in frame {&frame-name} = tt_unid_negoc.des_unid_negoc.
    &ENDIF
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL unid-neg-nota.cod_unid_negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF unid-neg-nota.cod_unid_negoc IN FRAME f-main /* Unid Neg¢cio */
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

  if unid-neg-nota.cod_unid_negoc:load-mouse-pointer("image/lupa.cur")
     in frame {&frame-name} then .

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
  {src/adm/template/row-list.i "unid-neg-nota"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "unid-neg-nota"}

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
    
    /* Ponha na pi-validate todas as valida‡äes */

    find it-doc-fisico where
         rowid(it-doc-fisico) = v-row-parent no-lock no-error.
    if avail it-doc-fisico and adm-new-record = yes then do: 
       find first unid-neg-nota where
            unid-neg-nota.cod_unid_negoc = input frame {&frame-name} unid-neg-nota.cod_unid_negoc and
            unid-neg-nota.sequencia      = it-doc-fisico.sequencia and
            unid-neg-nota.cod-emitente   = it-doc-fisico.cod-emitente and
            unid-neg-nota.nat-operacao   = "" and
            unid-neg-nota.tipo-nota      = it-doc-fisico.tipo-nota and
            unid-neg-nota.nro-docto      = it-doc-fisico.nro-docto and
            unid-neg-nota.serie-docto    = it-doc-fisico.serie-docto no-lock no-error.
       if avail unid-neg-nota then do:
            {utp/ut-table.i mgind unid-neg-nota 1}
            run utp/ut-msgs.p (input "show":U, input 7, input return-value).
            apply 'entry' to unid-neg-nota.cod_unid_negoc in frame {&frame-name}.
            return 'ADM-ERROR':U.
       end.   
    end.
    
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        IF  NOT CAN-FIND(FIRST unid-negoc
                         WHERE unid-negoc.cod-unid-negoc = input frame {&frame-name} unid-neg-nota.cod_unid_negoc) THEN DO:
            {utp/ut-table.i mgind unid-negoc 1}
            run utp/ut-msgs.p (input "show":U, input 2, input return-value).
            apply 'entry' to unid-neg-nota.cod_unid_negoc in frame {&frame-name}.
            return 'ADM-ERROR':U.
        END.
        ELSE DO:
            if  valid-handle(h-cdapi024) then do:
                EMPTY TEMP-TABLE tt-erro.

                FIND doc-fisico
                    WHERE doc-fisico.serie-docto  = it-doc-fisico.serie-docto
                      AND doc-fisico.nro-docto    = it-doc-fisico.nro-docto
                      AND doc-fisico.cod-emitente = it-doc-fisico.cod-emitente
                      AND doc-fisico.tipo-nota    = it-doc-fisico.tipo-nota NO-LOCK NO-ERROR.

                run ValidaUnidadeNegocioEstabel in h-cdapi024 (input  doc-fisico.cod-estabel,
                                                               input  doc-fisico.dt-trans,
                                                               input  input frame {&frame-name} unid-neg-nota.cod_unid_negoc,
                                                               output table tt-erro).
            
                run ValidaUnidadeNegocioUsuario in h-cdapi024 (input c-seg-usuario,
                                                               input input frame {&frame-name} unid-neg-nota.cod_unid_negoc,
                                                               output table tt-erro append).
                IF  CAN-FIND(FIRST tt-erro) THEN DO:
                    RUN cdp/cd0666.w (INPUT TABLE tt-erro).
                    apply 'entry' to unid-neg-nota.cod_unid_negoc in frame {&frame-name}.
                    return 'ADM-ERROR':U.
                END.
            end.
        END.
    &ELSE
        if input frame {&frame-name} c-descricao = "" then do:
           {utp/ut-field.i mgind unid-neg-nota cod_unid_negoc 1}
           run utp/ut-msgs.p (input "show":U, input 56, input return-value).
           apply 'entry' to unid-neg-nota.cod_unid_negoc in frame {&frame-name}.
           return 'ADM-ERROR':U.
        end.    

        assign d-perc = 0.
        for each b-neg-nota 
           where b-neg-nota.sequencia    = it-doc-fisico.sequencia 
             and b-neg-nota.cod-emitente = it-doc-fisico.cod-emitente 
             and b-neg-nota.nat-operacao = ""
             and b-neg-nota.tipo-nota    = it-doc-fisico.tipo-nota
             and b-neg-nota.nro-docto    = it-doc-fisico.nro-docto 
             and b-neg-nota.serie-docto  = it-doc-fisico.serie-docto 
             and b-neg-nota.cod_unid_negoc <> input frame {&frame-name} unid-neg-nota.cod_unid_negoc no-lock:
            assign d-perc = d-perc + b-neg-nota.perc-unid-neg.
        end.    
        assign d-perc = d-perc + input frame {&frame-name} unid-neg-nota.perc-unid-neg.
        if d-perc > 100 then do:
            {utp/ut-liter.i maior * R}
            run utp/ut-msgs.p (input "show":U, input 17068, input return-value).
            apply 'entry' to unid-neg-nota.cod_unid_negoc in frame {&frame-name}.
            RETURN 'ADM-ERROR':U.
        end.
    &ENDIF
    
    if input frame {&frame-name} unid-neg-nota.perc-unid-neg < 0 or 
       input frame {&frame-name} unid-neg-nota.perc-unid-neg > 100 then do:
        run utp/ut-msgs.p (input "show":U, input 507, input "").
        apply 'entry' to unid-neg-nota.cod_unid_negoc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.


    /* NÆo gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignïs nÆo feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    
    if avail it-doc-fisico then         
       assign unid-neg-nota.sequencia    = it-doc-fisico.sequencia
              unid-neg-nota.cod-emitente = it-doc-fisico.cod-emitente
              unid-neg-nota.nat-operacao = ""
              unid-neg-nota.tipo-nota    = it-doc-fisico.tipo-nota
              unid-neg-nota.nro-docto    = it-doc-fisico.nro-docto
              unid-neg-nota.serie-docto  = it-doc-fisico.serie-docto.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-destroy V-table-Win 
PROCEDURE local-destroy :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */
    &if "{&BF_MAT_VERSAO_EMS}" >= "2.062" &then
        if valid-handle(h-cdapi024) then do:
            RUN pi-finalizar IN h-cdapi024.
            assign h-cdapi024 = ?.
        end.
    &endif

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'destroy':U ) .

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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-display-fields V-table-Win 
PROCEDURE local-display-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  APPLY "leave":U TO unid-neg-nota.cod_unid_negoc IN FRAME {&FRAME-NAME}.
  
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
  {src/adm/template/snd-list.i "unid-neg-nota"}

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

