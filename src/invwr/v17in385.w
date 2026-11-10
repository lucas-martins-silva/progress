&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V17IN385 2.00.00.004 } /*** 010004 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v17in385 MUT}
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
def new global shared var v-row-parent as rowid no-undo.  
def new global shared var gr-requisicao as rowid no-undo.                              
/* Parameters Definitions ---                                           */


def var i-empresa like param-global.empresa-prin no-undo.
FIND FIRST param-global.
ASSIGN i-empresa = param-global.empresa-prin WHEN AVAIL param-global.
/***********API FINANCAS****************/
def var h_api_ccusto            as handle no-undo.
DEF VAR p_cod_ccusto            AS CHAR NO-UNDO.
DEF VAR p_cod_format_ccusto     AS CHAR NO-UNDO.
DEF VAR v_des_ccusto        AS CHAR FORMAT "X(150)" NO-UNDO.

run prgint/utb/utb742za.py persistent set h_api_ccusto.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro  as integer format ">>>>,>>9" label "Nßmero" column-label "Nßmero"
    field ttv_des_msg_ajuda as character format "x(40)" label "Mensagem Ajuda" column-label "Mensagem Ajuda"
    field ttv_des_msg_erro  as character format "x(60)" label "Mensagem Erro" column-label "Inconsist¬ncia".


def temp-table tt_ccusto_integr no-undo
    field ttv_cod_ccusto as char format "x(11)" label "Centro Custo" column-label "Centro Custo"
    field ttv_des_titulo as char format "x(40)".
/*###########*/


/* Local Variable Definitions ---                                       */

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
&Scoped-define EXTERNAL-TABLES requisicao estabelec
&Scoped-define FIRST-EXTERNAL-TABLE requisicao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR requisicao, estabelec.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS requisicao.nr-requisicao estabelec.nome ~
requisicao.cod-estabel requisicao.sc-codigo ~
requisicao.loc-entrega requisicao.nome-abrev requisicao.dt-requisicao 
&Scoped-define ENABLED-TABLES requisicao estabelec
&Scoped-define FIRST-ENABLED-TABLE requisicao
&Scoped-define SECOND-ENABLED-TABLE estabelec

&Scoped-define DISPLAYED-TABLES requisicao estabelec
&Scoped-define FIRST-DISPLAYED-TABLE requisicao
&Scoped-define SECOND-DISPLAYED-TABLE estabelec

&Scoped-Define ENABLED-OBJECTS RECT-1 rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS requisicao.nr-requisicao estabelec.nome ~
requisicao.cod-estabel requisicao.sc-codigo ~
requisicao.loc-entrega requisicao.nome-abrev requisicao.dt-requisicao ~
requisicao.narrativa v_des_ccusto
&Scoped-Define DISPLAYED-OBJECTS c-situacao c-estado c-text-narrat 

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
DEFINE VARIABLE c-estado AS CHARACTER FORMAT "X(15)" INITIAL "2" 
     LABEL "Estado":R8 
     VIEW-AS FILL-IN 
     SIZE 17.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(25)" INITIAL "2" 
     LABEL "Situa‡Æo":R10 
     VIEW-AS FILL-IN 
     SIZE 26.14 BY .88 NO-UNDO.

DEFINE VARIABLE c-text-narrat AS CHARACTER FORMAT "X(12)":U 
      VIEW-AS TEXT 
     SIZE 12 BY .88 NO-UNDO.

DEFINE RECTANGLE RECT-1
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 86.29 BY 5.88.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 88.57 BY 13.29.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     requisicao.nr-requisicao AT ROW 1.21 COL 21.72 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11 BY .88
     estabelec.nome AT ROW 2.67 COL 29.29 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 41.43 BY .88
     requisicao.cod-estabel AT ROW 2.71 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     requisicao.sc-codigo AT ROW 3.67 COL 21.57 COLON-ALIGNED LABEL "Centro de Custo"
          VIEW-AS FILL-IN 
          SIZE 12.43 BY .88
     v_des_ccusto AT ROW 3.67 COL 34.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 33.43 BY .88
     c-situacao AT ROW 4.63 COL 21.43 COLON-ALIGNED
     c-estado AT ROW 5.54 COL 21.57 COLON-ALIGNED
     requisicao.loc-entrega AT ROW 6.5 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 31.43 BY .88
     requisicao.nome-abrev AT ROW 7.5 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 19.14 BY .88
     requisicao.dt-requisicao AT ROW 8.46 COL 21.57 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     requisicao.narrativa AT ROW 10.33 COL 19.43 NO-LABEL
          VIEW-AS EDITOR SCROLLBAR-VERTICAL
          SIZE 60 BY 5
     c-text-narrat AT ROW 9.17 COL 38.57 COLON-ALIGNED NO-LABEL
     RECT-1 AT ROW 9.67 COL 2.72
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.requisicao,mgadm.estabelec,mgadm.sub-conta
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
         HEIGHT             = 14.92
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
   NOT-VISIBLE Size-to-Fit                                              */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-estado IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-text-narrat IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR EDITOR requisicao.narrativa IN FRAME f-main
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


/* ***************************  Main Block  *************************** */

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
  {src/adm/template/row-list.i "requisicao"}
  {src/adm/template/row-list.i "estabelec"}
  

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "requisicao"}
  {src/adm/template/row-find.i "estabelec"}
  

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
  /* NÆo gravar nada no registro antes do dispatch do assign-record e 
  nem na PI-validate. */  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
if RETURN-VALUE = 'ADM-ERROR':U then 
   RETURN 'ADM-ERROR':U.
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
  find  requisicao where rowid(requisicao)=gr-requisicao NO-LOCK no-error.
  if avail requisicao then do with frame {&frame-name}:
      
        /*## busca i-empresa ##*/
        find estabelec where
                        estabelec.cod-estabel = requisicao.cod-estabel:SCREEN-VALUE IN FRAME f-main no-lock no-error.
            assign i-empresa = estabelec.ep-codigo when avail estabelec.
        /*## fim busca i-empresa ##*/

        ASSIGN v_des_ccusto = "".
        IF requisicao.sc-codigo:SCREEN-VALUE <> "" THEN DO:
             run pi_retorna_formato_ccusto in h_api_ccusto (input i-empresa,           /* EMPRESA EMS2 */
                                                            input "",                  /* PLANO CCUSTO */
                                                            input today,               /* DATA DE TRANSACAO */
                                                            output p_cod_format_ccusto, /* FORMATO CCUSTO */
                                                            output table tt_log_erro). /* ERROS */
            run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS2 */
                                                       input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                       input  requisicao.sc-codigo:SCREEN-VALUE,     /* CCUSTO */
                                                       input  TODAY,                    /* DATA DE TRANSACAO */
                                                       output v_des_ccusto,             /* DESCRICAO DO CCUSTO */
                                                       output table tt_log_erro).       /* ERROS */ 
            ASSIGN v_des_ccusto:SCREEN-VALUE IN FRAME f-main = v_des_ccusto.
         
            FIND FIRST tt_log_erro NO-LOCK NO-ERROR.
            IF AVAIL tt_log_erro THEN DO:
                ASSIGN v_des_ccusto:SCREEN-VALUE IN FRAME f-main = ""
                       v_des_ccusto = "".
                run utp/ut-msgs.p (input "show", 
                                   input 17006, 
                                   STRING(tt_log_erro.ttv_des_msg_erro) + ' ('  + string(tt_log_erro.ttv_num_cod_erro) + ')' + "~~" + tt_log_erro.ttv_des_msg_ajuda).
            END.
            ELSE
                ASSIGN requisicao.sc-codigo:SCREEN-VALUE = string(requisicao.sc-codigo:SCREEN-VALUE,p_cod_format_ccusto).
        END.
      
      assign c-situacao:screen-value = {ininc/i01in385.i  04 requisicao.situacao}.
      assign c-estado:screen-value = {ininc/i02in385.i  04 requisicao.estado}.
  end.
  else do:
      assign c-situacao:screen-value = {ininc/i01in385.i  04 1}.
      assign c-situacao:screen-value = {ininc/i02in385.i  04 1}.
  end.    
  
   {utp/ut-liter.i Narrativa * L}
  assign c-text-narrat:screen-value in frame {&frame-name} = return-value.    


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
  
  assign v-row-parent=rowid(requisicao).
  /* Code placed here will execute AFTER standard behavior.    */
  
  {utp/ut-liter.i Narrativa * L}
  assign c-text-narrat:screen-value in frame {&frame-name} = return-value.

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
  {src/adm/template/snd-list.i "requisicao"}
  {src/adm/template/snd-list.i "estabelec"}
  
 
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

