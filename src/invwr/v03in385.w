&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
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
{include/i-prgvrs.i V03IN385 2.00.01.003 } /*** 010103 ***/
 

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v03in385 MUT}
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
 
/* Parameters Definitions ---                                           */
 
/* Local Variable Definitions ---                                       */
 
{include/i-vrtab.i item}
{include/i-vrtab.i emitente}
{include/i-vrtab.i tab-unidade}
{include/i-vrtab.i estabelec}
{include/i-vrtab.i conta-contab}
{include/i-vrtab.i deposito}
{include/i-vrtab.i localizacao}
{include/i-vrtab.i lote}

{cdp/cdcfgdis.i}

def var i-empresa           like param-global.empresa-prin no-undo.
def var h_api_ccusto        as handle    no-undo.
def var v_cod_ccusto        as character no-undo.
def var h_api_cta_ctbl      as handle    no-undo.
def var v_des_cta_ctbl      as character no-undo.
def var v_cod_cta_ctbl      as char      no-undo.
def var v_num_tip_cta_ctbl  as char      no-undo. 
def var v_num_sit_cta_ctbl  as char      no-undo. 
def var v_ind_finalid_cta   as char      no-undo. 
def var v_des_ccusto        as char      no-undo.
def var v_cod_formato       as char      no-undo.

def temp-table tt_log_erro no-undo
    field ttv_num_cod_erro      as integer   format ">>>>,>>9" label "N£mero"          column-label "N£mero"
    field ttv_des_msg_ajuda     as character format "x(40)"    label "Mensagem Ajuda"  column-label "Mensagem Ajuda"
    field ttv_des_msg_erro      as character format "x(60)"    label "Mensagem Erro"   column-label "Inconsistˆncia".

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
&Scoped-define EXTERNAL-TABLES it-requisicao
&Scoped-define FIRST-EXTERNAL-TABLE it-requisicao


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR it-requisicao.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS it-requisicao.nome-abrev ~
it-requisicao.ct-codigo it-requisicao.sc-codigo it-requisicao.dt-entrega ~
it-requisicao.cod-localiz it-requisicao.num-ord-inv 
&Scoped-define ENABLED-TABLES it-requisicao
&Scoped-define FIRST-ENABLED-TABLE it-requisicao
&Scoped-Define ENABLED-OBJECTS rt-mold 
&Scoped-Define DISPLAYED-FIELDS it-requisicao.it-codigo ~
it-requisicao.nome-abrev it-requisicao.cod-estabel it-requisicao.ct-codigo ~
it-requisicao.sc-codigo it-requisicao.cod-unid-negoc ~
it-requisicao.cod-depos it-requisicao.dt-entrega it-requisicao.cod-localiz ~
it-requisicao.numero-ordem it-requisicao.lote it-requisicao.num-ord-inv 
&Scoped-define DISPLAYED-TABLES it-requisicao
&Scoped-define FIRST-DISPLAYED-TABLE it-requisicao
&Scoped-Define DISPLAYED-OBJECTS c-descricao c-requisitante c-estabel ~
c-ct-desc c-sc-desc c-des-unid-negoc c-situacao 

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
DEFINE VARIABLE c-ct-desc AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-des-unid-negoc AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 49.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-descricao AS CHARACTER FORMAT "x(60)" 
     VIEW-AS FILL-IN 
     SIZE 39.43 BY .88 NO-UNDO.

DEFINE VARIABLE c-estabel AS CHARACTER FORMAT "X(40)" 
     VIEW-AS FILL-IN 
     SIZE 49.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-requisitante AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 40.57 BY .88 NO-UNDO.

DEFINE VARIABLE c-sc-desc AS CHARACTER FORMAT "x(32)" 
     VIEW-AS FILL-IN 
     SIZE 38.72 BY .88 NO-UNDO.

DEFINE VARIABLE c-situacao AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS FILL-IN 
     SIZE 14 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 84.86 BY 10.5.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     it-requisicao.it-codigo AT ROW 1.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 17.43 BY .88
     c-descricao AT ROW 1.25 COL 39.72 COLON-ALIGNED NO-LABEL
     it-requisicao.nome-abrev AT ROW 2.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 16.43 BY .88
     c-requisitante AT ROW 2.25 COL 38.57 COLON-ALIGNED NO-LABEL
     it-requisicao.cod-estabel AT ROW 3.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     c-estabel AT ROW 3.25 COL 29.86 COLON-ALIGNED NO-LABEL
     it-requisicao.ct-codigo AT ROW 4.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-ct-desc AT ROW 4.25 COL 40.57 COLON-ALIGNED HELP
          "F5 para zoom" NO-LABEL
     it-requisicao.sc-codigo AT ROW 5.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 18.14 BY .88
     c-sc-desc AT ROW 5.25 COL 40.57 COLON-ALIGNED HELP
          "F5 para zoom" NO-LABEL
     it-requisicao.cod-unid-negoc AT ROW 6.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.14 BY .88
     c-des-unid-negoc AT ROW 6.25 COL 29.86 COLON-ALIGNED NO-LABEL
     c-situacao AT ROW 7.25 COL 22 COLON-ALIGNED
     it-requisicao.cod-depos AT ROW 8.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 7.43 BY .88
     it-requisicao.dt-entrega AT ROW 8.25 COL 66.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 12.86 BY .88
     it-requisicao.cod-localiz AT ROW 9.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     it-requisicao.numero-ordem AT ROW 9.25 COL 66.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 11.72 BY .88
     it-requisicao.lote AT ROW 10.25 COL 22 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 25 BY .88
     it-requisicao.num-ord-inv AT ROW 10.25 COL 66.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 9.14 BY .88
     rt-mold AT ROW 1 COL 1.43
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: movind.it-requisicao
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
         HEIGHT             = 10.5
         WIDTH              = 85.43.
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
       FRAME f-main:HIDDEN           = TRUE
       FRAME f-main:HEIGHT           = 10.5
       FRAME f-main:WIDTH            = 85.43.

/* SETTINGS FOR FILL-IN c-ct-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-des-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-descricao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-requisitante IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-sc-desc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN c-situacao IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-requisicao.cod-depos IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-requisicao.cod-estabel IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-requisicao.cod-unid-negoc IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-requisicao.it-codigo IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-requisicao.lote IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN it-requisicao.numero-ordem IN FRAME f-main
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
 
{utp/ut-field.i mgind it-requisicao situacao 01}
ASSIGN c-situacao:LABEL IN FRAME {&frame-name} = RETURN-VALUE.

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
  {src/adm/template/row-list.i "it-requisicao"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "it-requisicao"}

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

/*for each b-ord-prod fields ( it-codigo dt-termino estado valorizada nr-ord-prod ) 
 * use-index item where b-ord-prod.it-codigo = c-itemord no-lock */
 
    if available it-requisicao then do:

/*     find requisitante where requisitante.nome-abrev = it-requisicao.nome-abrev no-lock no-error.
 *      assign c-requisitante = if avail requisitante then requisitante.nome else "":U.*/
 
/* for first param-cp fields (var-rep) no-lock: end.*/
 
        for first requisitante fields (nome) where requisitante.nome-abrev = it-requisicao.nome-abrev no-lock:
            assign c-requisitante = if avail requisitante then requisitante.nome else "":U.
        end. 
     
        for first item fields (desc-item) where item.it-codigo = it-requisicao.it-codigo no-lock:
            assign c-descricao = if avail item then item.desc-item else "":U.
        end. 
        
        for first estabelec fields (nome) where estabelec.cod-estabel = it-requisicao.cod-estabel no-lock:
            assign c-estabel = if avail estabelec then estabelec.nome else "":U.
        end.
          
        FIND FIRST unid-negoc NO-LOCK 
             WHERE unid-negoc.cod-unid-negoc = it-requisicao.cod-unid-negoc NO-ERROR.
        ASSIGN c-des-unid-negoc = IF  AVAIL unid-negoc THEN unid-negoc.des-unid-negoc ELSE "":U.
    
        find first estabelec no-lock 
             where estabelec.cod-estabel = it-requisicao.cod-estabel no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec.

        run prgint/utb/utb742za.py persistent set h_api_ccusto.
        run prgint/utb/utb743za.py persistent set h_api_cta_ctbl.

        /* CONTA */
        assign v_cod_cta_ctbl = it-requisicao.ct-codigo.
        run pi_busca_dados_cta_ctbl in h_api_cta_ctbl (input        i-empresa,                  /* EMPRESA EMS2 */
                                                       input        "",                         /* PLANO DE CONTAS */
                                                       input-output v_cod_cta_ctbl,             /* CONTA */
                                                       input        it-requisicao.dt-entrega,   /* DATA TRANSACAO */
                                                       output       v_des_cta_ctbl,             /* DESCRICAO CONTA */
                                                       output       v_num_tip_cta_ctbl,         /* TIPO DA CONTA */
                                                       output       v_num_sit_cta_ctbl,         /* SITUA€ÇO DA CONTA */
                                                       output       v_ind_finalid_cta,          /* FINALIDADES DA CONTA */
                                                       output table tt_log_erro).               /* ERROS */ 
        assign c-ct-desc = if can-find(tt_log_erro) then "" else v_des_cta_ctbl.
        
        /* Format conta */
        run pi_retorna_formato_cta_ctbl in h_api_cta_ctbl (input  i-empresa,                /* EMPRESA EMS2 */
                                                           input  "",                       /* PLANO CONTAS */
                                                           input  it-requisicao.dt-entrega, /* DATA DE TRANSACAO */
                                                           output v_cod_formato,            /* FORMATO CONTA */
                                                           output table tt_log_erro).       /* ERROS */
        if trim(v_cod_cta_ctbl) <> "" and v_cod_formato <> "" then
            assign it-requisicao.ct-codigo:format in frame {&frame-name} = if can-find(tt_log_erro) then "" else v_cod_formato.

        /* CENTRO CUSTO */
        assign v_cod_ccusto = it-requisicao.sc-codigo.
        run pi_busca_dados_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS2 */
                                                   input  "",                       /* CODIGO DO PLANO CCUSTO */
                                                   input  v_cod_ccusto,             /* CCUSTO */
                                                   input  it-requisicao.dt-entrega, /* DATA DE TRANSACAO */
                                                   output v_des_ccusto,             /* DESCRICAO DO CCUSTO */
                                                   output table tt_log_erro).       /* ERROS */
        assign c-sc-desc = if can-find(tt_log_erro) then "" else v_des_ccusto.

        /* Formato Centro Custo */
        run pi_retorna_formato_ccusto in h_api_ccusto (input  i-empresa,                /* EMPRESA EMS2 */
                                                       input  "",                       /* PLANO CCUSTO */
                                                       input  it-requisicao.dt-entrega, /* DATA DE TRANSACAO */
                                                       output v_cod_formato,            /* FORMATO CCUSTO */
                                                       output table tt_log_erro).       /* ERROS */        
        if trim(v_cod_ccusto) <> "" and v_cod_formato <> "" then
            assign it-requisicao.sc-codigo:format in frame {&frame-name} = if can-find(tt_log_erro) then "" else v_cod_formato.

        if valid-handle(h_api_ccusto) then
            delete object h_api_ccusto.
    
        if valid-handle(h_api_cta_ctbl) then
            delete object h_api_cta_ctbl.
    end.

    RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

    IF AVAIL it-requisicao THEN DO:  
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {ininc/i01in385.i 04 it-requisicao.situacao}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  c-situacao:SCREEN-VALUE IN FRAME {&frame-name} = RETURN-VALUE.     
        &else
            ASSIGN c-situacao:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i01in385.i 04 it-requisicao.situacao}.
        &endif
    END.
    ELSE DO:
       &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
           DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
           ASSIGN cAuxTraducao002 = {ininc/i01in385.i 04 01}.
           run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                               INPUT "",
                               INPUT "").
           ASSIGN  c-situacao:SCREEN-VALUE IN FRAME {&frame-name} = RETURN-VALUE.
       &else
           ASSIGN c-situacao:SCREEN-VALUE IN FRAME {&frame-name} = {ininc/i01in385.i 04 01}.
       &endif
    END. 

    ENABLE it-requisicao.lote with frame {&frame-name}.
    ASSIGN it-requisicao.lote:READ-ONLY IN FRAME {&FRAME-NAME} = YES.
    
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
    find first param-global no-lock no-error.  

    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .
 
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

    /* Code placed here will execute PRIOR to standard behavior. */
    
    /* Dispatch standard ADM method.                             */
    RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .
        
    if avail it-requisicao then do:
        find first item where item.it-codigo = it-requisicao.it-codigo no-lock no-error. 
        if avail item then 
            assign gr-item = rowid(item).

        find first tab-unidade where tab-unidade.un = it-requisicao.un no-lock no-error.
        if avail tab-unidade then 
            assign gr-tab-unidade = rowid(tab-unidade).
        
        find first estabelec no-lock 
             where estabelec.cod-estabel = it-requisicao.cod-estabel no-error.
        assign i-empresa = estabelec.ep-codigo when avail estabelec.
         
        find first deposito where deposito.cod-depos = it-requisicao.cod-depos no-lock no-error.
        if avail deposito then 
            assign gr-deposito = rowid(deposito).
        
        find first localizacao where localizacao.cod-localiz = it-requisicao.cod-localiz no-lock no-error.
        if avail localizacao then 
            assign gr-localizacao = rowid(localizacao).
        
        find first lote where lote.nr-lote = it-requisicao.lote no-lock no-error. 
        if avail lote then 
            assign gr-lote = rowid(lote).
    end.          
    
    /* Code placed here will execute AFTER standard behavior.    */
 
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-update-record V-table-Win 
PROCEDURE local-update-record :
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
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'update-record':U ) .
 
  /* Code placed here will execute AFTER standard behavior.    */
 
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
  {src/adm/template/snd-list.i "it-requisicao"}

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

