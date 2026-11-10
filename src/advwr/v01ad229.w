&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12 GUI ADM1
&ANALYZE-RESUME
/* Connected Databases 
          mgadm            PROGRESS
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
{include/i-prgvrs.i V01AD229 2.00.00.045 } /*** "010045" 25/06/2025 16:21:12  ***/



&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v01ad229 MUT}
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

{cdp/cdcfgdis.i}

{utp/ut-glob.i}
def new global shared var gr-repres as rowid no-undo.

/************* Multiplanta ********************/
def var i-tipo-movto as integer no-undo.
{cdp/cd7300.i1}
{cdp/cdapi236.i}
/************ Fim *****************************/

def var i-cod-repres   as integer              no-undo.
def var i-cont-char    as int                  no-undo.
def var l-altera       as logical init no      no-undo.

/*--- possibilita utilizar o   Modulo Multiplanta Financeiro (MMF) ---*/
def var l-ok-mmf     as logical  initial yes   no-undo.
def var c-empr       as char                   no-undo.

def new shared var c-nome-ant  like repres.nome-abrev.
def new shared var c-novo-nome like repres.nome-abrev.
def new global shared var c-cod-rep as char no-undo.
def var h_repres as widget-handle no-undo.

/* buffer do arquivo repres */
def buffer b1-repres for repres.
def new shared buffer repres for repres.

/* miniflexibilizaá∆o */
{cdp/cdcfgfin.i}

{include/i-freeac.i}
/*-------------- Integraá∆o Magnus I.01 x EMS 2.04 -------------*/
def var i-ind-tipo-movto as integer no-undo.

{cdp/cd0708i1.i} /* Definiá∆o da temp-table tt-gr-cli-mg */
{cdp/cd0001i1.i} /* Definiá∆o da temp-table de erros tt-erro-mg */
/****************************************************************/

{bhp/bh9999.i1}
{include/i_prdvers.i}


/* Integraá∆o EAI */
DEF VAR i-cod-rep    LIKE repres.cod-rep    NO-UNDO.
DEF VAR c-nome       LIKE repres.nome       NO-UNDO.
DEF VAR c-nome-abrev LIKE repres.nome-abrev NO-UNDO.

&IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN

    DEFINE NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO.

    {cdp/cd9043.i}
    DEF VAR h-axsvd009 AS HANDLE NO-UNDO.
    DEF VAR c-action   AS CHAR   NO-UNDO.
    DEF VAR hShowMsg   AS HANDLE NO-UNDO.

    DEFINE TEMP-TABLE tt_log_erro  NO-UNDO
        FIELD ttv_num_cod_erro  AS INT  INIT ?
        FIELD ttv_des_msg_ajuda AS CHAR INIT ?
        FIELD ttv_des_msg_erro  AS CHAR INIT ?.
&ENDIF


DEFINE VARIABLE h-cd0708-crm AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11    AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p ( OUTPUT lIntCRM11).

/*VARIµVEIS LOCALIZAÄ«O EQUADOR*/
DEFINE VARIABLE h-boec013 AS HANDLE      NO-UNDO.
DEFINE VARIABLE h-handle-container AS HANDLE      NO-UNDO.
/*FIM - VARIµVEIS LOCALIZAÄ«O EQUADOR*/

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
&Scoped-define EXTERNAL-TABLES repres
&Scoped-define FIRST-EXTERNAL-TABLE repres


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR repres.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS repres.nome-abrev repres.nome 
&Scoped-define ENABLED-TABLES repres
&Scoped-define FIRST-ENABLED-TABLE repres
&Scoped-Define ENABLED-OBJECTS rt-key 
&Scoped-Define DISPLAYED-FIELDS repres.cod-rep repres.nome-abrev ~
repres.nome 
&Scoped-define DISPLAYED-TABLES repres
&Scoped-define FIRST-DISPLAYED-TABLE repres


/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS repres.cod-rep repres.nome-abrev 

/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "Foreign Keys" V-table-Win _INLINE
/* Actions: ? adm/support/keyedit.w ? ? ? */
/* STRUCTURED-DATA
<KEY-OBJECT>
THIS-PROCEDURE
</KEY-OBJECT>
<FOREIGN-KEYS></FOREIGN-KEYS> 
<EXECUTING-CODE>
**************************
* Set attributes related to FOREIGN KEYS
*/
RUN set-attribute-list (
    'Keys-Accepted = ,
     Keys-Supplied = ':U).
/**************************
</EXECUTING-CODE> */
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* ***********************  Control Definitions  ********************** */


/* Definitions of the field level widgets                               */
DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL 
     SIZE 85.14 BY 2.17.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     repres.cod-rep AT ROW 1.17 COL 28.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 6.86 BY .88
     repres.nome-abrev AT ROW 1.17 COL 35.57 COLON-ALIGNED NO-LABEL
          VIEW-AS FILL-IN 
          SIZE 16 BY .88
     repres.nome AT ROW 2.08 COL 28.14 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 39.29 BY .88
     rt-key AT ROW 1 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE NO-VALIDATE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgadm.repres
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
         HEIGHT             = 2.17
         WIDTH              = 85.72.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB V-table-Win 
/* ************************* Included-Libraries *********************** */

{src/adm/method/viewer.i}
{include/c-viewer.i}

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

/* SETTINGS FOR FILL-IN repres.cod-rep IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR FILL-IN repres.nome-abrev IN FRAME f-main
   1                                                                    */
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

&Scoped-define SELF-NAME repres.nome-abrev
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL repres.nome-abrev V-table-Win
ON ENTRY OF repres.nome-abrev IN FRAME f-main /* Nome Abreviado */
DO:
  assign c-nome-ant = repres.nome-abrev when avail repres
         l-altera   = no.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
&IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
   RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
&ENDIF

  {btb/btb008za.i0} /* RPC - Integraá∆o do EMS 2.04 Financeiro x Magnus I.01 */

/************************ INTERNAL PROCEDURES ********************/

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE adm-find-using-key V-table-Win  adm/support/_key-fnd.p
PROCEDURE adm-find-using-key :
/*------------------------------------------------------------------------------
  Purpose:     Finds the current record using the contents of
               the 'Key-Name' and 'Key-Value' attributes.
  Parameters:  <none>
------------------------------------------------------------------------------*/

  /* No Foreign keys are accepted by this SmartObject. */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

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
  {src/adm/template/row-list.i "repres"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "repres"}

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

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'add-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-apply-entry V-table-Win 
PROCEDURE local-apply-entry :
/*------------------------------------------------------------------------------
   Purpose:     Override standard ADM method
   Notes:       
------------------------------------------------------------------------------*/

   RUN get-attribute('adm-new-record':U).
   if  return-value = 'yes':U then do:
       find last b1-repres no-lock no-error.
       if  avail b1-repres then do:
           if  b1-repres.cod-rep <> 99999 then do:
                assign i-cod-repres = b1-repres.cod-rep + 1.
           end.
           else do:
               assign i-cod-repres = 1.
               repeat:
                   find b1-repres 
                      where b1-repres.cod-rep = i-cod-repres no-lock no-error.
                         if  not avail b1-repres then 
                             leave.
                         else
                             assign i-cod-repres = i-cod-repres + 1.
               end.
           end.
       end.
       else do:
            assign i-cod-repres = 1.
       end.

       assign repres.cod-rep:screen-value in frame {&FRAME-NAME} = string(i-cod-repres).

   end.

   RUN dispatch IN THIS-PROCEDURE ( INPUT 'apply-entry':U ) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-assign-record V-table-Win 
PROCEDURE local-assign-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DO TRANSACTION:

        if  not frame {&frame-name}:validate() then
            return 'ADM-ERROR':U.
    
        If  repres.cod-rep:sensitive then do:
            If  can-find(repres where repres.cod-rep = input frame {&frame-name} repres.cod-rep) then do:
                {utp/ut-table.i mgadm repres 1}.
                run utp/ut-msgs.p (input "show",
                                   input 7,
                                   input return-value).
                apply "entry"  to repres.cod-rep in frame {&frame-name}.                 
                Return 'adm-error':U.
            End.
        End.   
    
        if  input frame {&frame-name} repres.cod-rep = 0 then do:
            run utp/ut-msgs.p (input "show",
                               input 3884,
                               input "").
            apply "entry"  to repres.cod-rep in frame {&frame-name}.
            return 'adm-error':U.
        end.
    
        RUN get-attribute ("adm-new-record").
        if  return-value = "yes":U then do:
            if  input frame {&frame-name} repres.nome-abrev <> " "
                and can-find (repres where repres.nome-abrev = input frame {&frame-name} repres.nome-abrev) then do:
                {utp/ut-field.i mgadm repres nome-abrev 1}
                run utp/ut-msgs.p (input "show",
                                   input 1, 
                                   input return-value).
                apply "entry" to repres.nome-abrev in frame {&frame-name}.                   
                return 'ADM-ERROR':U.
            end.     
        end.
    
        if  avail repres then do:
            find first b1-repres 
                 where input frame {&Frame-name} repres.nome-abrev = b1-repres.nome-abrev 
                 and rowid(repres) <> rowid(b1-repres) no-lock no-error.
            if  avail b1-repres then do:
                {utp/ut-field.i mgadm repres nome-abrev 1}
                run utp/ut-msgs.p (input "show",
                                   input 1, 
                                   input return-value).
                apply "entry" to repres.nome-abrev in frame {&frame-name}.                   
                return 'ADM-ERROR':U.   
            end.      
        end.   
    
        if  input frame {&frame-name} repres.nome-abrev = "" then do:
            run utp/ut-msgs.p (input "show",
                               input 3258,
                               input "").
            apply "entry" to repres.nome-abrev in frame {&frame-name}.
            Return 'adm-error':U.
        end.
    
        if  input frame {&frame-name} repres.nome = "" then do:
            run utp/ut-msgs.p (input "show",
                               input 3885,
                               input "").
            apply "entry" to repres.nome in frame {&frame-name}.
            Return 'adm-error':U.
        end.
        if can-find(repres where repres.cod-rep = input frame {&frame-name} repres.cod-rep)
        then do:
          if c-nome-ant <> input frame {&FRAME-NAME} repres.nome-abrev then do:
    
            assign c-novo-nome = input frame {&FRAME-NAME} repres.nome-abrev.
            assign l-altera = yes.
          end.
        end.
    
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .
    
        if  return-value = "adm-error":U then
            return "adm-error":U. 
    
        {cdp/cd0002i1.i repres} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    
        if  l-ok-mmf = yes then do:
            /********************Multiplanta***********************/
            assign c-transacao = "ADM035".
            {cdp/cd7300.i5 "001" c-transacao}
    
            assign i-tipo-movto = if repres.cod-rep:sensitive in frame {&frame-name} = yes
                                     then 1 else 2.
    
            run pi-cria-tt-dados (input i-tipo-movto).
    
            {cdp/cd7300.i6 "001" c-transacao}
            /******************Fim-Multiplanta********************/ 
        end.

        IF lIntCRM11 THEN DO:
            IF NOT VALID-HANDLE(h-cd0708-crm) THEN
                RUN integracoes/adapters/emstocrm/cd0708-crm.p PERSISTENT SET h-cd0708-crm.

            RUN sendToCRM IN h-cd0708-crm (INPUT repres.cod-rep,
                                           OUTPUT TABLE RowErrors).
            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                UNDO, RETURN "ADM-ERROR":U.
            END.
            DELETE PROCEDURE h-cd0708-crm.
        END.
        

        /* Integraá∆o EAI ->> Sender de Representante (Representative) */
        &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
            IF v_log_eai_habilit THEN DO:
                IF NOT VALID-HANDLE(h-axsvd009) THEN
                    RUN adapters/xml/vd2/axsvd009.p PERSISTENT SET h-axsvd009.

                ASSIGN c-action = IF adm-new-record THEN "add":U
                                  ELSE "upd":U.

                IF AVAIL repres THEN
                    RUN piTransUpsert IN h-axsvd009 (INPUT  c-action,
                                                     INPUT  ROWID(repres),
                                                     OUTPUT TABLE tt_log_erro).

                EMPTY TEMP-TABLE RowErrors.

                FOR EACH tt_log_erro:

                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                           RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                           RowErrors.ErrorHelp        = ""
                           RowErrors.ErrorSubType     = "ERROR":U.
                END.

                IF CAN-FIND (FIRST RowErrors WHERE
                                   RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"} UNDO, RETURN "ADM-ERROR":U.
                END.

                IF VALID-HANDLE(h-axsvd009) THEN DO:
                    DELETE PROCEDURE h-axsvd009.
                    ASSIGN h-axsvd009 = ?.
                END.

                IF VALID-HANDLE(hShowMsg) THEN DO:
                    {method/showmessage.i3}
                END.
            END.
        &ENDIF

    END. /*do transaction*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-delete-record V-table-Win 
PROCEDURE local-delete-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

    DO TRANSACTION:

        ASSIGN i-cod-rep    = repres.cod-rep
               c-nome       = repres.nome
               c-nome-abrev = repres.nome-abrev.

        /* Verifica notas fiscais para o representante */  
        for each regiao no-lock:
            find first nota-fiscal use-index ch-reg-rep
                where nota-fiscal.nome-ab-reg  = regiao.nome-ab-reg
                and   nota-fiscal.no-ab-reppri = repres.nome-abrev
                no-lock no-error.
                if avail nota-fiscal then
                    leave.
        end.
        if avail nota-fiscal then do:
            run utp/ut-msgs.p (input "show",
                               input 59,
                               input nota-fiscal.cod-estabel + "~~" +
                                     nota-fiscal.serie + "~~" +
                                     nota-fiscal.nr-nota-fis).
            Return "adm-error":U.
        end.
    
        /* Verifica se possui representante indireto */
        find first b1-repres use-index indireto 
            where b1-repres.rep-indireto = repres.cod-rep
            no-lock no-error.
        if avail b1-repres then do:
            run utp/ut-msgs.p (input "show",
                               input 60,
                               input string(b1-repres.cod-rep)).
            Return "adm-error":U.
        end.
    
        /* verifica emitente para representante */
        find first emitente use-index repres
            where emitente.cod-rep    = repres.cod-rep
            and   emitente.identific <> 2
            no-lock no-error.
        if avail emitente then do:
            run utp/ut-msgs.p (input "show",
                               input 61,
                               input string(emitente.cod-emitente) + "~~" +
                                     emitente.nome-abrev).
            Return "adm-error":U.
        end.
    
        /* verifica titulos para representante */
        find first rep-tit use-index represent
            where rep-tit.cod-rep = repres.cod-rep 
            no-lock no-error.
        if avail rep-tit then do:
            run utp/ut-msgs.p (input "show",
                               input 62,
                               input rep-tit.cod-estabel + "~~" +
                                     rep-tit.cod-esp     + "~~" +
                                     rep-tit.nr-docto    + "~~" +
                                     rep-tit.parcela).
            Return "adm-error":U.
        end.
    
        /* verifica pedidos de venda */ 
        find first ped-repre use-index ch-repped
            where ped-repre.nome-ab-rep = repres.nome-abrev
            no-lock no-error.
        if avail ped-repre then do:
            find ped-venda where ped-venda.nr-pedido = ped-repre.nr-pedido no-lock no-error.
            run utp/ut-msgs.p (input "show",
                               input 63,
                               input ped-venda.nome-abrev + "~~" +
                                     ped-venda.nr-pedcli).
    
            Return "adm-error":U.
        end.
    
        /* verifica se rep. esta ligado a grupo de cliente */
        find first gr-cli use-index ch-repres
            where gr-cli.cod-rep = repres.cod-rep 
            no-lock no-error.
        if avail gr-cli then do:
            run utp/ut-msgs.p (input "show",
                               input 65,
                               input string(gr-cli.cod-gr-cli)).
            Return "adm-error":U.
        end.
    
        {utp/ut-table.i mgadm repres 1}.
        /* verifica se rep. possui relacionamento com os parametros do faturamento */  
        find first param-fb 
            where param-fb.cod-rep = repres.cod-rep
            no-lock no-error.
        if avail param-fb then do:
            run utp/ut-msgs.p (input "show",
                            input 67,
                            input return-value).
            Return "adm-error":U.
        End.    
    
        /* verifica tabela de comissoes */
        find first comissao
            where comissao.cod-rep = repres.cod-rep
            no-lock no-error.
        if avail comissao then do: 
            run utp/ut-msgs.p (input "show",
                            input 69,
                            input return-value).
            Return "adm-error":U.
        End.
    
        /* verifica tabela de micro-regioes */
        find first rep-micro
            where rep-micro.nome-ab-rep = repres.nome-abrev
            no-lock no-error.
        if avail rep-micro then do: 
            run utp/ut-msgs.p (input "show",
                            input 70,
                            input return-value).
            Return "adm-error":U.
        End.
    
        /* verifica estatisticas do faturamento */
        find first fat-estat
            where fat-estat.cod-rep = repres.cod-rep
            no-lock no-error.
        if avail fat-estat then do: 
            run utp/ut-msgs.p (input "show",
                            input 71,
                            input return-value).
            Return "adm-error":U.
        End.

        if can-find (first distrib-emit-estab where 
                           distrib-emit-estab.cod-rep = repres.cod-rep) then do:  

           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-repres AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Representante" *}
           ASSIGN c-lbl-liter-repres = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-emit-estab AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Emitentes_Estabelecimento" *}
           ASSIGN c-lbl-liter-emit-estab = TRIM(RETURN-VALUE).
 
           run utp/ut-msgs.p (input "show",
                              input 5,        /* Repres possui relacionamentos ativos com Emitentes Estabelecimento. */
                              input c-lbl-liter-repres + "~~" + c-lbl-liter-emit-estab).
           Return "adm-error":U.

        end.
        
        if can-find (first canal-clien-estab where 
                           canal-clien-estab.cod-rep = repres.cod-rep) then do:  

           /* Inicio -- Projeto Internacional */
           DEFINE VARIABLE c-lbl-liter-repres-aux AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Representante" *}
           ASSIGN c-lbl-liter-repres-aux = TRIM(RETURN-VALUE).
           DEFINE VARIABLE c-lbl-liter-clien-estab AS CHARACTER NO-UNDO.
           {utp/ut-liter.i "Canal_Cliente_Estabelecimento" *}
           ASSIGN c-lbl-liter-clien-estab = TRIM(RETURN-VALUE).
 
           run utp/ut-msgs.p (input "show",
                              input 5,        /* Repres possui relacionamentos ativos com Canal Cliente Estabelecimento. */
                              input c-lbl-liter-repres-aux + "~~" + c-lbl-liter-clien-estab).
           Return "adm-error":U.

        end.
	
	/*****[ LOCALIZAÄ«O EQUADOR ]**********************************************************************************/
        IF i-pais-impto-usuario = 21 THEN DO:
            IF NOT VALID-HANDLE(h-boec013) THEN DO:
                RUN local/ecu/ec2bo/boec013.p PERSISTENT SET h-boec013.
                RUN openQueryStatic IN h-boec013 (INPUT 'Main':U).
            END.            
            RUN goToKey IN h-boec013 (INPUT i-cod-rep).
            IF RETURN-VALUE = "OK":U THEN DO:            
                RUN emptyRowErrors IN h-boec013.
                RUN validateRecord IN h-boec013 (INPUT "DELETE":U).
                RUN getRowErrors   IN h-boec013 (OUTPUT TABLE RowErrors).
    
                IF CAN-FIND (FIRST RowErrors WHERE 
                                   RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"}
                    RETURN "ADM-ERROR":U.
                END.
            END.
        END.    
        /************************************************************************************************************/

    /*****[ BANCOS HIST‡RICOS ]**********************************************************************************/
        if not available(param-global) then
            find first param-global no-lock no-error.
    
        if param-global.modulo-bh = yes then do:
            {bhp/bh9999.i 1 Repres repres.cod-rep '' '' '' '' ''}
            if return-value <> "OK" then
                return "ADM-ERROR".
        end.
    /************************************************************************************************************/
    
        /* exclui registros de contato do fornecedor se ok */                                        
        for each cont-repres where cont-repres.cod-repres = repres.cod-rep exclusive-lock.
            delete cont-repres.
        end.
    
        {cdp/cd0002i1.i1 repres "no"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
    
        RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .
        if return-value = 'ADM-ERROR':U then 
           return 'ADM-ERROR':U.
    
        {cdp/cd0002i1.i1 repres "yes"} /* Integraá∆o EMS 2.04 Financeiro x Magnus I.01 */
        
         IF lIntCRM11 THEN DO:
            IF NOT VALID-HANDLE(h-cd0708-crm) THEN
                RUN integracoes/adapters/emstocrm/cd0708-crm.p PERSISTENT SET h-cd0708-crm.
    
            RUN deleteFromCRM IN h-cd0708-crm (INPUT i-cod-rep,
                                               OUTPUT TABLE RowErrors).
            
            IF CAN-FIND (FIRST RowErrors WHERE 
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                {method/ShowMessage.i1}
                {method/ShowMessage.i2 &Modal="YES"}
                UNDO, RETURN "ADM-ERROR":U.
            END.
            DELETE PROCEDURE h-cd0708-crm.
         END.
        IF i-pais-impto-usuario = 21 THEN DO:
            IF NOT VALID-HANDLE(h-boec013) THEN DO:
                RUN local/ecu/ec2bo/boec010.p PERSISTENT SET h-boec013.
                RUN openQueryStatic IN h-boec013 (INPUT 'Main':U).
            END.            

            RUN goToKey IN h-boec013 (INPUT i-cod-rep).
            IF RETURN-VALUE = "OK":U THEN DO:
                RUN deleteRecord IN h-boec013.
                IF RETURN-VALUE = "OK":U THEN
                    RUN pi-limpa-dados-localiz IN h-handle-container.
            END.
        END.

        /* Integraá∆o EAI ->> Sender de Represntante (Representative) */
        &IF "{&bf_dis_versao_ems}" >= "2.04":U &THEN
            IF v_log_eai_habilit THEN DO:
                IF NOT VALID-HANDLE(h-axsvd009) THEN
                    RUN adapters/xml/vd2/axsvd009.p PERSISTENT SET h-axsvd009.

                IF AVAIL repres THEN
                    RUN piTransDelete IN h-axsvd009 (INPUT  i-cod-rep,
                                                     INPUT  c-nome,
                                                     INPUT  c-nome-abrev,
                                                     OUTPUT TABLE tt_log_erro).

                EMPTY TEMP-TABLE RowErrors.
                
                FOR EACH tt_log_erro:

                    CREATE RowErrors.
                    ASSIGN RowErrors.ErrorNumber      = tt_log_erro.ttv_num_cod_erro
                           RowErrors.ErrorDescription = tt_log_erro.ttv_des_msg_erro
                           RowErrors.ErrorHelp        = tt_log_erro.ttv_des_msg_ajuda
                           RowErrors.ErrorSubType     = "ERROR":U.
                END.

                IF CAN-FIND (FIRST RowErrors WHERE
                                   RowErrors.ErrorSubType = "ERROR":U) THEN DO:

                    {method/showmessage.i1}
                    {method/showmessage.i2 &Modal="YES"} UNDO, RETURN "ADM-ERROR":U.
                END.

                IF VALID-HANDLE(h-axsvd009) THEN DO:
                    DELETE PROCEDURE h-axsvd009.
                    ASSIGN h-axsvd009 = ?.
                END.

                IF VALID-HANDLE(hShowMsg) THEN DO:
                    {method/showmessage.i3}
                END.
            END.
        &ENDIF

    END. /*do transaction*/

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-disable-fields V-table-Win 
PROCEDURE local-disable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'disable-fields':U ) .

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



  assign c-cod-rep    = repres.cod-rep:screen-value in frame {&FRAME-NAME}.
  assign i-cod-repres = input frame {&FRAME-NAME} repres.cod-rep.

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-enable-fields V-table-Win 
PROCEDURE local-enable-fields :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'enable-fields':U ).

  if NOT can-find (
      first funcao 
      where funcao.cd-funcao = "Repres 2.00" 
      or funcao.cd-funcao = "Representantes 2.00") then do:

      &if  defined(ADM-MODIFY-FIELDS) &then
          enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
      &endif
  END.
  ELSE
      DISABLE repres.nome-abrev repres.nome WITH FRAME {&FRAME-NAME}.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  if l-altera then
    run cdp/cd0708b.p (input c-novo-nome,
                       input c-nome-ant,
                       input rowid(repres)).

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

   
  /*---  Modulo Multiplanta Financeiro (MMF) ---*/
  {cdp/cdapi531.i1 "ADM035" "NO"}

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

  RUN dispatch IN THIS-PROCEDURE ( INPUT 'row-available':U ) .

  if avail repres then
     assign gr-repres = rowid(repres).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-atualiza-rpc-mg V-table-Win 
PROCEDURE pi-atualiza-rpc-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0003i1.i repres cdp/cd0708i1.p}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-busca-repres V-table-Win 
PROCEDURE pi-busca-repres :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def output param i-cod-repres as integer no-undo.

assign i-cod-repres = input frame {&FRAME-NAME} repres.cod-rep.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados V-table-Win 
PROCEDURE pi-cria-tt-dados :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter i-tipo-movto as integer.

if  param-global.modulo-mp and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-repres-aux.
    buffer-copy repres to tt-repres-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 86
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = string(repres.cod-rep).
    raw-transfer tt-repres-aux to tt-dados-env.conteudo-msg.                                    
    assign i-seq = i-seq + 1.                                     
end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-repres-mg V-table-Win 
PROCEDURE pi-cria-tt-repres-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-ind-tipo-movto as int no-undo.
    def input param p-atualiza       as log no-undo.

    for each tt-repres-mg exclusive-lock:
        delete tt-repres-mg.
    end.

    create tt-repres-mg.
    assign tt-repres-mg.ind-tipo-movto = p-ind-tipo-movto
           tt-repres-mg.l-atualiza     = p-atualiza.

    /* Campos Iguais */
    assign tt-repres-mg.cod-rep         = repres.cod-rep
           tt-repres-mg.nome            = fn-free-accent(repres.nome)
           tt-repres-mg.nome-abrev      = fn-free-accent(repres.nome-abrev)
           tt-repres-mg.nome-ab-reg     = repres.nome-ab-reg
           tt-repres-mg.endereco        = fn-free-accent(repres.endereco)
           tt-repres-mg.bairro          = fn-free-accent(substring(string(repres.bairro,"x(15)"),1,15))
           tt-repres-mg.cep             = int(repres.cep)
           tt-repres-mg.cidade          = fn-free-accent(repres.cidade)
           tt-repres-mg.estado          = repres.estado
           tt-repres-mg.pais            = repres.pais
           tt-repres-mg.caixa-postal    = repres.caixa-postal
           tt-repres-mg.cgc             = repres.cgc
           tt-repres-mg.telefone[1]     = repres.telefone[1]
           tt-repres-mg.telefone[2]     = repres.telefone[2]
           tt-repres-mg.inscr-est       = repres.inscr-est
           tt-repres-mg.rep-indireto    = repres.rep-indireto
           tt-repres-mg.comis-direta    = repres.comis-direta
           tt-repres-mg.comis-emis      = repres.comis-emis
           tt-repres-mg.comis-indir     = repres.comis-indir
           tt-repres-mg.telex           = repres.telex
           tt-repres-mg.telefax         = repres.telefax
           tt-repres-mg.telef-modem     = repres.telef-modem
           tt-repres-mg.int-2           = repres.int-2
           tt-repres-mg.char-1          = repres.char-1
           tt-repres-mg.char-2          = repres.char-2
           tt-repres-mg.dec-1           = repres.dec-1
           tt-repres-mg.dec-2           = repres.dec-2
           tt-repres-mg.log-1           = repres.log-1
           tt-repres-mg.log-2           = repres.log-2
           tt-repres-mg.perc-aire       = repres.perc-aire
           tt-repres-mg.comis-max       = repres.comis-max
           tt-repres-mg.comis-min       = repres.comis-min
           tt-repres-mg.ins-municipal   = repres.ins-municipal
           tt-repres-mg.zip-code        = repres.zip-code
           tt-repres-mg.permissao       = repres.permissao.

    if repres.natureza = 1 then
       assign tt-repres-mg.natureza = "F".
    if repres.natureza = 2 then
       assign tt-repres-mg.natureza = "J".
    if repres.natureza = 3 then
       assign tt-repres-mg.natureza = "E".
    if repres.natureza = 4 then /* conforme obs. engenharia repres */
       assign tt-repres-mg.natureza = "E".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-gera-log-mg V-table-Win 
PROCEDURE pi-gera-log-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    {cdp/cd0004i1.i "CD0708" "REPRES" repres.cod-rep tt-repres-mg.ind-tipo-movto tt-erros-mg.help-msg}

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-recebe-handle-container V-table-Win 
PROCEDURE pi-recebe-handle-container :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input parameter h-container as handle no-undo.

  assign h-handle-container  = h-container.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-valida-repres-mg V-table-Win 
PROCEDURE pi-valida-repres-mg :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input-output param p-ind-tipo-movto as int no-undo.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE send-key V-table-Win  adm/support/_key-snd.p
PROCEDURE send-key :
/*------------------------------------------------------------------------------
  Purpose:     Sends a requested KEY value back to the calling
               SmartObject.
  Parameters:  <see adm/template/sndkytop.i>
------------------------------------------------------------------------------*/

  /* There are no foreign keys supplied by this SmartObject. */

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
  {src/adm/template/snd-list.i "repres"}

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

