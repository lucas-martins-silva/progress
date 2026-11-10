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
{include/i-prgvrs.i V01IN657 2.00.00.008 } /*** 010008 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01in657 MCC}
&ENDIF

{cdp/cdcfgmat.i}

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
def var i-empresa    as character no-undo.

&if '{&bf_mat_versao_ems}' >= '2.062' &then 
{cdp/cd0666.i}
DEFINE VARIABLE hProgramZoom   AS HANDLE             NO-UNDO.
DEFINE VARIABLE h-cdapi024     AS HANDLE             NO-UNDO.
DEFINE VARIABLE l-unid-neg     AS LOGICAL INITIAL NO NO-UNDO.
DEFINE VARIABLE h_api_cta_ctbl AS HANDLE             NO-UNDO.
/* ****************** Multiplanta ***************** */
def var i-tipo-movto as integer no-undo.
/* ****************** Multiplanta ***************** */
&else
    def temp-table tt_unid_negoc no-undo
        field cod_unid_negoc               as character format "x(3)"  label "Unid Neg¢cio" column-label "Un Neg"
        field des_unid_negoc               as character format "x(40)" label "Descriá∆o" column-label "Descriá∆o"
        field cdn_unid_negoc               as Integer   format ">>9"   initial 0 label "N£mero Unidade Negoc" column-label "Numero UN".
&endif

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro   as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda  as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro   as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistància".

def buffer b-neg-ordem for unid-neg-ordem.

def var d-perc          as decimal initial 0 no-undo.


def new global shared var v_cod_unid_negoc   as character  format "x(3)"    
                      label "Unid Neg¢cio" column-label "Un Neg"   no-undo.

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
&Scoped-define EXTERNAL-TABLES unid-neg-ordem
&Scoped-define FIRST-EXTERNAL-TABLE unid-neg-ordem


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR unid-neg-ordem.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS unid-neg-ordem.perc-unid-neg 
&Scoped-define ENABLED-TABLES unid-neg-ordem
&Scoped-define FIRST-ENABLED-TABLE unid-neg-ordem
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS unid-neg-ordem.cod_unid_negoc ~
unid-neg-ordem.perc-unid-neg 
&Scoped-define DISPLAYED-TABLES unid-neg-ordem
&Scoped-define FIRST-DISPLAYED-TABLE unid-neg-ordem
&Scoped-Define DISPLAYED-OBJECTS c-descricao 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS unid-neg-ordem.cod_unid_negoc ~
unid-neg-ordem.perc-unid-neg 
&Scoped-define ADM-ASSIGN-FIELDS unid-neg-ordem.cod_unid_negoc ~
unid-neg-ordem.perc-unid-neg 
&Scoped-define ADM-MODIFY-FIELDS unid-neg-ordem.perc-unid-neg 

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
     unid-neg-ordem.cod_unid_negoc AT ROW 1.46 COL 20.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-descricao AT ROW 1.46 COL 28.43 COLON-ALIGNED NO-LABEL
     unid-neg-ordem.perc-unid-neg AT ROW 2.46 COL 20.72 COLON-ALIGNED
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
   External Tables: movind.unid-neg-ordem
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit                                   */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN unid-neg-ordem.cod_unid_negoc IN FRAME f-main
   NO-ENABLE 1 2                                                        */
/* SETTINGS FOR FILL-IN unid-neg-ordem.perc-unid-neg IN FRAME f-main
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

&Scoped-define SELF-NAME unid-neg-ordem.cod_unid_negoc
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL unid-neg-ordem.cod_unid_negoc V-table-Win
ON F5 OF unid-neg-ordem.cod_unid_negoc IN FRAME f-main /* Unid Neg¢cio */
DO:
    &if '{&bf_mat_versao_ems}' >= '2.062' &then 
        {method/ZoomFields.i
            &ProgramZoom="inzoom/z01in745.w"
            &FieldZoom1="cod-unid-negoc"
            &FieldScreen1="unid-neg-ordem.cod_unid_negoc"
            &Frame1="f-main"
            &FieldZoom2="des-unid-negoc"
            &FieldScreen2="c-descricao"
            &Frame2="f-main"
            &EnableImplant="no"}
            
    &else
        if  search("prgint/utb/utb011ka.p") <> ? 
        or  search("prgint/utb/utb011ka.r") <> ? then do:
    
            run prgint/utb/utb011ka.p  persistent set wh-pesquisa.
    
            if  v_cod_unid_negoc <> " " then 
                assign unid-neg-ordem.cod_unid_negoc:screen-value in frame {&frame-name} = v_cod_unid_negoc .
        end.      
    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL unid-neg-ordem.cod_unid_negoc V-table-Win
ON LEAVE OF unid-neg-ordem.cod_unid_negoc IN FRAME f-main /* Unid Neg¢cio */
DO:
    &if '{&bf_mat_versao_ems}' >= '2.062' &then 
        FIND FIRST unid-negoc 
             WHERE unid-negoc.cod-unid-negoc = INPUT FRAME {&FRAME-NAME} unid-neg-ordem.cod_unid_negoc
             NO-LOCK NO-ERROR.
        ASSIGN c-descricao:SCREEN-VALUE IN FRAME {&FRAME-NAME} = IF AVAIL unid-negoc THEN unid-negoc.des-unid-negoc
                                                                 ELSE "".
    &else
        for each tt_unid_negoc exclusive-lock:
            delete tt_unid_negoc.
        end.
        
        create tt_unid_negoc.
        assign tt_unid_negoc.cod_unid_negoc = input frame {&frame-name} unid-neg-ordem.cod_unid_negoc.
    
        run prgint/utb/utb907za.py ( input 1,
                                     input-output table tt_unid_negoc ).
    
        find first tt_unid_negoc no-lock no-error.
        
        assign c-descricao:screen-value in frame {&frame-name} = tt_unid_negoc.des_unid_negoc.

    &endif

END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL unid-neg-ordem.cod_unid_negoc V-table-Win
ON MOUSE-SELECT-DBLCLICK OF unid-neg-ordem.cod_unid_negoc IN FRAME f-main /* Unid Neg¢cio */
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

  if unid-neg-ordem.cod_unid_negoc:load-mouse-pointer("image/lupa.cur")
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
  {src/adm/template/row-list.i "unid-neg-ordem"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "unid-neg-ordem"}

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
    find ordem-compra where
         rowid(ordem-compra) = v-row-parent exclusive-lock no-error.
    if avail ordem-compra and adm-new-record = yes then do: 
       find first unid-neg-ordem where
            unid-neg-ordem.cod_unid_negoc = input frame {&frame-name} unid-neg-ordem.cod_unid_negoc and
            unid-neg-ordem.numero-ordem   = ordem-compra.numero-ordem no-lock no-error.
       if avail unid-neg-ordem then do:
            {utp/ut-table.i movind unid-neg-ordem 1}
            run utp/ut-msgs.p (input "show":U, input 7, input return-value).
            apply 'entry' to unid-neg-ordem.cod_unid_negoc in frame {&frame-name}.
            return 'ADM-ERROR':U.
       end.   
    end.
    
    &if '{&bf_mat_versao_ems}' >= '2.062' &then 
        EMPTY TEMP-TABLE tt-erro.

        /*Verifica se existe unidade de neg¢cio cadastrada*/
        IF NOT CAN-FIND(FIRST unid-negoc
            WHERE unid-negoc.cod-unid-negoc = INPUT FRAME {&FRAME-NAME} unid-neg-ordem.cod_unid_negoc) THEN DO:
            {utp/ut-liter.i Unidade_de_Neg¢cio}
            RUN utp/ut-msgs.p (INPUT "show":U, INPUT 2, INPUT RETURN-VALUE).
            APPLY 'entry' TO unid-neg-ordem.cod_unid_negoc IN FRAME {&FRAME-NAME}.
            RETURN 'ADM-ERROR':U.
        END.

        RUN cdp/cdapi024.p PERSISTENT SET h-cdapi024.

        IF VALID-HANDLE(h-cdapi024) THEN DO:
            IF AVAIL ordem-compra THEN DO:
                /*Verifica permiss∆o para utilizar unidade de neg¢cio no estabelecimento*/
                RUN ValidaUnidadeNegocioEstabel IN h-cdapi024(INPUT ordem-compra.cod-estabel,
                                                              INPUT ordem-compra.data-emissao,
                                                              INPUT INPUT FRAME {&FRAME-NAME} unid-neg-ordem.cod_unid_negoc,
                                                              OUTPUT TABLE tt-erro).
                IF CAN-FIND(FIRST tt-erro) THEN DO:
                    RUN cdp/cd0666.w(INPUT TABLE tt-erro).
                    APPLY 'entry' TO unid-neg-ordem.cod_unid_negoc IN FRAME {&FRAME-NAME}.
                    RETURN 'ADM-ERROR':U.
                END.

                /*Verifica permiss∆o do usu†rio para utilizar unidade de neg¢cio*/
                RUN ValidaUnidadeNegocioUsuario IN h-cdapi024(INPUT ordem-compra.requisitante,
                                                              INPUT INPUT FRAME {&FRAME-NAME} unid-neg-ordem.cod_unid_negoc, 
                                                              OUTPUT TABLE tt-erro).

                IF CAN-FIND(FIRST tt-erro) THEN DO:
                   RUN cdp/cd0666.w(INPUT TABLE tt-erro).
                   APPLY 'entry' TO unid-neg-ordem.cod_unid_negoc IN FRAME {&FRAME-NAME}.
                   RETURN 'ADM-ERROR':U.
               END. 
            end.

            RUN pi-finalizar IN h-cdapi024.
        END.
    &else
        if input frame {&frame-name} c-descricao = "" then do:
            {utp/ut-field.i movind unid-neg-ordem cod_unid_negoc 1}
            run utp/ut-msgs.p (input "show":U, input 56, input return-value).
            apply 'entry' to unid-neg-ordem.cod_unid_negoc in frame {&frame-name}.
            return 'ADM-ERROR':U.
         end.    
    &endif

    {cdp/cd9970.i ordem-compra.cod-estabel}
    
    run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.
    
    run pi_valida_conta_contabil in h_api_cta_ctbl (input  i-empresa,                 /* EMPRESA EMS2 */
                                                    input  ordem-compra.cod-estabel,  /* ESTABELECIMENTO EMS2 */
                                                    input  INPUT FRAME {&FRAME-NAME} unid-neg-ordem.cod_unid_negoc,   /* UNIDADE NEG‡CIO */
                                                    input  "",                        /* PLANO CONTAS */ 
                                                    input  ordem-compra.ct-codigo,    /* CONTA */
                                                    input  "",                        /* PLANO CCUSTO */ 
                                                    input  ordem-compra.sc-codigo,    /* CCUSTO */
                                                    input  ordem-compra.data-emissao, /* DATA TRANSACAO */
                                                    output table tt_log_erro).        /* ERROS */
                
    IF CAN-FIND(tt_log_erro) OR RETURN-VALUE = "NOK" THEN DO:    
       RUN pi_transfere_tt_log_erro.

       RUN cdp/cd0666.w (INPUT TABLE tt-erro).

       apply 'entry' to unid-neg-ordem.cod_unid_negoc in frame {&frame-name}.
       return 'ADM-ERROR':U.                              
    END.    
    
    if valid-handle(h_api_cta_ctbl) then
    do:
       delete object h_api_cta_ctbl.
       assign h_api_cta_ctbl = ?.
    end.
      
                    
    if input frame {&frame-name} unid-neg-ordem.perc-unid-neg < 0 or 
       input frame {&frame-name} unid-neg-ordem.perc-unid-neg > 100 then do:
        run utp/ut-msgs.p (input "show":U, input 507, input return-value).
        apply 'entry' to unid-neg-ordem.cod_unid_negoc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    if input frame {&frame-name} unid-neg-ordem.perc-unid-neg = 0 then do:
        run utp/ut-msgs.p (input "show":U, 
                           input 5376, 
                           input return-value).
        apply 'entry' to unid-neg-ordem.cod_unid_negoc in frame {&frame-name}.
        return 'ADM-ERROR':U.
    end.

    assign d-perc = 0.
    for each b-neg-ordem where 
        b-neg-ordem.numero-ordem = ordem-compra.numero-ordem and
        b-neg-ordem.cod_unid_neg <> input frame {&frame-name} unid-neg-ordem.cod_unid_negoc no-lock:
        d-perc = d-perc + b-neg-ordem.perc-unid-neg.
    end.    
    assign d-perc = d-perc + input frame {&frame-name} unid-neg-ordem.perc-unid-neg.
    if d-perc > 100 then do:
       {utp/ut-liter.i Maior * r}        
       run utp/ut-msgs.p (input "show":U, input 17068, input return-value).
       apply 'entry' to unid-neg-ordem.cod_unid_negoc in frame {&frame-name}.
       return 'ADM-ERROR':U.
    end.


    /* N∆o gravar nada no registro antes do dispatch do assign-record e 
       nem na PI-validate. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    if RETURN-VALUE = 'ADM-ERROR':U then 
        return 'ADM-ERROR':U.
    
    /* Todos os assignÔs n∆o feitos pelo assign-record devem ser feitos aqui */  
    /* Code placed here will execute AFTER standard behavior.    */
    
    if avail ordem-compra then do:        
       assign unid-neg-ordem.numero-ordem = ordem-compra.numero-ordem.
       &if '{&bf_mat_versao_ems}' >= '2.062' &then 
           IF ordem-compra.cod-unid-negoc <> "" THEN
               ASSIGN ordem-compra.cod-unid-negoc = "".
       &endif
    end.
    &if "{&bf_mat_versao_ems}" >= "2.062" &then
        /* ****************************** Multiplanta ****************************** */    
        find first param-global no-lock no-error.
        if not avail param-global then next.
        if  param-global.modulo-mp then do:
            assign i-tipo-movto = if  unid-neg-ordem.cod_unid_negoc:sensitive in frame {&frame-name} = yes 
                                  then 1 
                                  else 2.
            find first unid-neg-ordem no-lock
                 where unid-neg-ordem.cod_unid_negoc = input frame {&frame-name} unid-neg-ordem.cod_unid_negoc
                 and   unid-neg-ordem.numero-ordem   = ordem-compra.numero-ordem no-error.
           if avail unid-neg-ordem then do:
                run ccp/ccapi200.p (input "unid-neg-ordem",
                                    input rowid(unid-neg-ordem),
                                    input i-tipo-movto, /* 1 - Inclus∆o ** 2 - Manutená∆o */
                                    input-output table tt-erro).
                if can-find (first tt-erro) then do:
                    run cdp/cd0666.w (input table tt-erro).
                    return 'ADM-ERROR':U.
                end.
            end.
        END.
        /* ****************************** Multiplanta ****************************** */
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
  &if '{&bf_mat_versao_ems}' >= '2.062' &then 
      APPLY 'LEAVE':U TO unid-neg-ordem.cod_unid_negoc IN FRAME {&FRAME-NAME}.
  &else
      if avail unid-neg-ordem then do:
        for each tt_unid_negoc exclusive-lock:
             delete tt_unid_negoc.
         end.
     
         create tt_unid_negoc.
         assign tt_unid_negoc.cod_unid_negoc = input frame {&frame-name} unid-neg-ordem.cod_unid_negoc.
     
         run prgint/utb/utb907za.py ( input 1,
                                      input-output table tt_unid_negoc ).
     
         find first tt_unid_negoc no-lock no-error.
     
         assign c-descricao:screen-value in frame {&frame-name} = tt_unid_negoc.des_unid_negoc.
      end.
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-parent V-table-Win 
PROCEDURE pi-atualiza-parent :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    define input parameter v-row-parent-externo as rowid no-undo.
    
    assign v-row-parent = v-row-parent-externo.
    
    find ordem-compra 
        where rowid(ordem-compra) = v-row-parent no-lock no-error.
    
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

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi_transfere_tt_log_erro V-table-Win 
PROCEDURE pi_transfere_tt_log_erro :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE VARIABLE i-count AS INTEGER INITIAL 0 NO-UNDO.

    EMPTY TEMP-TABLE tt-erro NO-ERROR.

    FOR EACH tt_log_erro:

        ASSIGN i-count = i-count + 1.

        CREATE tt-erro.
        ASSIGN tt-erro.mensagem    = tt_log_erro.ttv_des_msg_erro
               tt-erro.cd-erro     = tt_log_erro.ttv_num_cod_erro
               tt-erro.i-sequen    = i-count.
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
  {src/adm/template/snd-list.i "unid-neg-ordem"}

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

