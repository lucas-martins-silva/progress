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

{include/i-prgvrs.i V21IN122 2.00.00.080 } /*** "010080" ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
    {include/i-license-manager.i v21in122 MUT}
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

{cdp/cdcfgmat.i}


/* Parameters Definitions ---                                           */

/* Local Variable Definitions ---                                       */

def buffer b-familia for familia.
def buffer b1-familia for familia.
&IF DEFINED(bf_mat_tipo_ressup) &THEN
def buffer b1-familia-mat for familia-mat.
&endif
def new global shared var gr-familia as rowid no-undo.

/*************Multiplanta********************/
def var i-tipo-movto as integer no-undo.
def var l-cria       as logical initial no no-undo.

{cdp/cd0666.i}
{cdp/cd7300.i1}
{cdp/cdapi211.i}

{mcinc/mcapi030.i}
def temp-table tt-dados-env-SMC   LIKE tt-dados-env.
def temp-table tt-replica-msg-SMC LIKE tt-replica-msg.
def temp-table tt-control-env-SMC LIKE tt-control-env.
def temp-table tt-integracao-SMC  LIKE tt-integracao.
/************Fim*****************************/

{bhp/bh9999.i1} /* Definiá∆o Temp-Table TT-TABELA   */

/* Local Definitions for EAI                                   */
{cdp/cd9043.i} /* Definiá∆o da tabela de erros RowErros */
{cdp/cdcfgman.i} /* Definiá∆o pre-processadores Manufatura */
DEF VAR c-action AS CHARACTER FORMAT "X(8)" NO-UNDO.
DEFINE TEMP-TABLE tt-fam LIKE familia.
DEF VAR hShowMsg AS HANDLE NO-UNDO.
&IF DEFINED (bf_man_204) &THEN 
DEF NEW GLOBAL SHARED VAR v_log_eai_habilit AS LOGICAL NO-UNDO. 
DEF NEW GLOBAL SHARED VAR whg-cd0202Integracao AS WIDGET-HANDLE NO-UNDO.
DEFINE VARIABLE i-idi-classif-item  AS INTEGER    NO-UNDO.
&ENDIF

&IF '{&mgscm_version}' >= '2.06B' &THEN
DEFINE VARIABLE hDBOproxy AS HANDLE NO-UNDO.
&ENDIF

DEF VAR l-copia AS LOGICAL .
DEF VAR rw-familia AS ROWID NO-UNDO.

&IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
    /* Integraá∆o EMS EAI2.0 Mensagem unica */
    DEFINE NEW GLOBAL SHARED VARIABLE v_log_eai2_ativado AS LOGICAL NO-UNDO INITIAL NO.
    DEFINE VARIABLE h-cdapi996     AS HANDLE NO-UNDO. 
&ENDIF

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
&Scoped-define EXTERNAL-TABLES familia
&Scoped-define FIRST-EXTERNAL-TABLE familia


/* Need to scope the external tables to this procedure                  */
DEFINE QUERY external_tables FOR familia.
/* Standard List Definitions                                            */
&Scoped-Define ENABLED-FIELDS familia.descricao familia.un 
&Scoped-define ENABLED-TABLES familia
&Scoped-define FIRST-ENABLED-TABLE familia
&Scoped-Define ENABLED-OBJECTS cb-tp-classif-item rt-key rt-mold 
&Scoped-Define DISPLAYED-FIELDS familia.fm-codigo familia.descricao ~
familia.un 
&Scoped-define DISPLAYED-TABLES familia
&Scoped-define FIRST-DISPLAYED-TABLE familia
&Scoped-Define DISPLAYED-OBJECTS c-un tg-integra-his cb-tp-classif-item 

/* Custom List Definitions                                              */
/* ADM-CREATE-FIELDS,ADM-ASSIGN-FIELDS,ADM-MODIFY-FIELDS,List-4,List-5,List-6 */
&Scoped-define ADM-CREATE-FIELDS familia.fm-codigo 

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
DEFINE VARIABLE cb-tp-classif-item AS CHARACTER FORMAT "X(256)":U 
     LABEL "" 
     VIEW-AS COMBO-BOX INNER-LINES 5
     DROP-DOWN-LIST
     SIZE 16 BY 1 NO-UNDO.

DEFINE VARIABLE c-un AS CHARACTER FORMAT "X(40)":U 
     VIEW-AS FILL-IN 
     SIZE 42.86 BY .88 NO-UNDO.

DEFINE RECTANGLE rt-key
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 1.25.

DEFINE RECTANGLE rt-mold
     EDGE-PIXELS 2 GRAPHIC-EDGE  NO-FILL   
     SIZE 88.57 BY 3.25.

DEFINE VARIABLE tg-integra-his AS LOGICAL INITIAL no 
     LABEL "Integraá∆o HIS" 
     VIEW-AS TOGGLE-BOX
     SIZE 16 BY .88 NO-UNDO.


/* ************************  Frame Definitions  *********************** */

DEFINE FRAME f-main
     familia.fm-codigo AT ROW 1.17 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 15.72 BY .88
     familia.descricao AT ROW 2.67 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 48.72 BY .88
     familia.un AT ROW 3.67 COL 27.29 COLON-ALIGNED
          VIEW-AS FILL-IN 
          SIZE 5.43 BY .88
     c-un AT ROW 3.67 COL 33.14 COLON-ALIGNED NO-LABEL
     tg-integra-his AT ROW 4.67 COL 29.43
     cb-tp-classif-item AT ROW 1.17 COL 60 COLON-ALIGNED WIDGET-ID 2
     rt-key AT ROW 1 COL 1
     rt-mold AT ROW 2.5 COL 1
    WITH 1 DOWN NO-BOX KEEP-TAB-ORDER OVERLAY 
         SIDE-LABELS NO-UNDERLINE THREE-D 
         AT COL 1 ROW 1 SCROLLABLE .


/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: SmartViewer
   External Tables: mgind.familia
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
         HEIGHT             = 4.75
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
   NOT-VISIBLE FRAME-NAME Size-to-Fit Custom                            */
ASSIGN 
       FRAME f-main:SCROLLABLE       = FALSE
       FRAME f-main:HIDDEN           = TRUE.

/* SETTINGS FOR FILL-IN c-un IN FRAME f-main
   NO-ENABLE                                                            */
/* SETTINGS FOR FILL-IN familia.fm-codigo IN FRAME f-main
   NO-ENABLE 1                                                          */
/* SETTINGS FOR TOGGLE-BOX tg-integra-his IN FRAME f-main
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

&Scoped-define SELF-NAME familia.un
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON F5 OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  assign l-implanta = yes.
  {include/zoomvar.i &prog-zoom="inzoom/z01in417.w"
                     &campo=familia.un
                     &campozoom=un
                     &campo2=c-un
                     &campozoom2=descricao}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON LEAVE OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
   {include/leave.i &tabela=tab-unidade
                    &atributo-ref=descricao
                    &variavel-ref=c-un
                    &where="tab-unidade.un = input frame {&frame-name} familia.un "}
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CONTROL familia.un V-table-Win
ON MOUSE-SELECT-DBLCLICK OF familia.un IN FRAME f-main /* Unid Padr∆o */
DO:
  apply 'f5' to self.
END.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&UNDEFINE SELF-NAME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK V-table-Win 


/* ***************************  Main Block  *************************** */
  if familia.un:load-mouse-pointer ("image/lupa.cur") in frame {&frame-name} then.

  &IF DEFINED(UIB_IS_RUNNING) <> 0 &THEN          
    RUN dispatch IN THIS-PROCEDURE ('initialize':U).        
  &ENDIF         
   
   {utp/ut-liter.i Classificaá∆o}
   assign cb-tp-classif-item:label in frame {&frame-name} = return-value. 

    IF NOT CAN-FIND (FIRST funcao 
               WHERE funcao.cd-funcao = "spp-integra-ems-his"
               AND   funcao.ativo     = YES) THEN
        tg-integra-his:VISIBLE IN FRAME f-main = NO.
  /************************ INTERNAL PROCEDURES ********************/

{database/tgin/tdp/tdin122.i}

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
  {src/adm/template/row-list.i "familia"}

  /* Get the record ROWID's from the RECORD-SOURCE.                  */
  {src/adm/template/row-get.i}

  /* FIND each record specified by the RECORD-SOURCE.                */
  {src/adm/template/row-find.i "familia"}

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

  DEFINE VARIABLE c-classif-item AS CHARACTER NO-UNDO.
    
    
  /* Code placed here will execute PRIOR to standard behavior. */
  if  not frame {&frame-name}:validate() then
      return 'ADM-ERROR':U.

  /* Ponha aqui a validaá∆o de chave duplicada */

  if familia.fm-codigo:sensitive in frame {&frame-name} = yes
     and can-find(b-familia 
               where b-familia.fm-codigo = input frame {&frame-name} familia.fm-codigo) then do:
     {utp/ut-table.i mgind familia 1}
      run utp/ut-msgs.p( input "show",
                         input 8,
                         input return-value).
      apply 'entry' to familia.fm-codigo in frame {&frame-name}.
      return 'adm-error'.

  end. 

  IF l-copia THEN
      ASSIGN rw-familia = ROWID(familia).

  ASSIGN c-classif-item = cb-tp-classif-item:SCREEN-VALUE IN FRAME {&FRAME-NAME}.

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'assign-record':U ) .

  if  return-value = 'ADM-ERROR':U THEN
      return 'ADM-ERROR':U.

    &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN

        IF tg-integra-his:CHECKED IN FRAME {&frame-name} THEN DO:

            ASSIGN familia.log-orig-ext = YES.

            FOR EACH ITEM WHERE ITEM.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK:
                ASSIGN ITEM.log-orig-ext = YES.
            END.
        END.
        ELSE DO:
           
            ASSIGN familia.log-orig-ext = NO.
                    
            FIND ITEM WHERE ITEM.fm-codigo = familia.fm-codigo Exclusive-lock NO-ERROR.
                IF AVAIL ITEM THEN
                    ASSIGN ITEM.log-orig-ext = NO.
        END.
    &ELSE
        &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
        OVERLAY(familia.char-1,154,1) = " ".
        &ENDIF     
    &ENDIF
    
  IF l-copia THEN DO:
      FIND b1-familia WHERE
           rowid(b1-familia) = rw-familia EXCLUSIVE-LOCK NO-ERROR.
      BUFFER-COPY b1-familia EXCEPT un fm-codigo descricao TO familia.
    &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
              IF tg-integra-his:CHECKED IN FRAME {&frame-name} THEN
                  ASSIGN familia.log-orig-ext = YES.
              ELSE 
              ASSIGN familia.log-orig-ext = NO.
          &ELSE
             &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
                OVERLAY(familia.char-1,154,1) = " ".
               &ENDIF     
          &ENDIF
    END.


    IF  AVAIL familia THEN DO:
        &IF DEFINED (bf_man_204) &THEN
            ASSIGN substring(familia.char-1,19,1) = trim(STRING({ininc/i99in122.i 6 c-classif-item})).
            IF substring(familia.char-1,19,1) <> "1" AND
               substring(familia.char-1,19,1) <> "2" AND
               substring(familia.char-1,19,1) <> "3"  THEN
               ASSIGN OVERLAY(familia.char-1,19,1) = "1".
        &ENDIF
        &IF DEFINED (bf_man_206) &THEN
            ASSIGN familia.idi-classif-item = {ininc/i99in122.i 6 c-classif-item}.
            IF familia.idi-classif-item <> 1 AND
               familia.idi-classif-item <> 2 AND
               familia.idi-classif-item <> 3 THEN
               ASSIGN familia.idi-classif-item = 1.
        &ENDIF
    END.      


  assign familia.codigo-orig = if l-cria = yes 
                                  then 0 
                                  else familia.codigo-orig.  

  /******** EMS 2.02 **********/
  &IF DEFINED(bf_mat_tipo_ressup) &THEN
      run cdp/cd0202a1.p (input rowid(familia), input 1).
      IF l-copia THEN DO:
          find b1-familia-mat where b1-familia-mat.fm-codigo = b1-familia.fm-codigo NO-LOCK NO-ERROR.
          IF AVAIL b1-familia-mat THEN DO:

             find familia-mat where familia-mat.fm-codigo = familia.fm-codigo EXCLUSIVE-LOCK NO-ERROR.
             IF AVAIL familia-mat THEN DO:
                 ASSIGN familia-mat.altera-conta     = b1-familia-mat.altera-conta
                        familia-mat.cd-freq          = b1-familia-mat.cd-freq          
                        familia-mat.char-1           = b1-familia-mat.char-1           
                        familia-mat.char-2           = b1-familia-mat.char-2           
                        familia-mat.classif-abc      = b1-familia-mat.classif-abc      
                        familia-mat.cod-estab-gestor = b1-familia-mat.cod-estab-gestor 
                        familia-mat.cod-fat-ponder   = b1-familia-mat.cod-fat-ponder   
                        familia-mat.cod-grp-compra   = b1-familia-mat.cod-grp-compra   
                        familia-mat.crit-cc          = b1-familia-mat.crit-cc          
                        familia-mat.crit-ce          = b1-familia-mat.crit-ce          
                        familia-mat.data-1           = b1-familia-mat.data-1           
                        familia-mat.data-2           = b1-familia-mat.data-2           
                        familia-mat.dec-1            = b1-familia-mat.dec-1            
                        familia-mat.dec-2            = b1-familia-mat.dec-2            
                        familia-mat.dep-rej-cq       = b1-familia-mat.dep-rej-cq       
                        familia-mat.deposito-cq      = b1-familia-mat.deposito-cq      
                        familia-mat.int-1            = b1-familia-mat.int-1            
                        familia-mat.int-2            = b1-familia-mat.int-2            
                        familia-mat.log-1            = b1-familia-mat.log-1            
                        familia-mat.log-2            = b1-familia-mat.log-2            
                        familia-mat.lote-per-max     = b1-familia-mat.lote-per-max     
                        familia-mat.nat-despesa      = b1-familia-mat.nat-despesa      
                        familia-mat.ponto-encomenda  = b1-familia-mat.ponto-encomenda  
                        familia-mat.prioridade-aprov = b1-familia-mat.prioridade-aprov 
                        familia-mat.tp-ressup        = b1-familia-mat.tp-ressup        
                        familia-mat.var-qtd-re       = b1-familia-mat.var-qtd-re       
                        familia-mat.var-val-re-maior = b1-familia-mat.var-val-re-maior 
                        familia-mat.var-val-re-menor = b1-familia-mat.var-val-re-menor 
                        familia-mat.variacao-perm    = b1-familia-mat.variacao-perm
                        familia-mat.cod-unid-negoc   = b1-familia-mat.cod-unid-negoc.
             END.
          END.
      END.
  &ENDIF 

  IF l-copia THEN
     ASSIGN l-copia = NO.


  /* Code placed here will execute AFTER standard behavior.    */

/********************Multiplanta***********************/
   assign c-transacao = "MAN013":U.
  {cdp/cd7300.i5 "001" c-transacao}

assign i-tipo-movto = if l-cria = yes then 1 else 2.
if  param-global.modulo-mp and avail
    tt-replica-msg and
    tt-replica-msg.log-replica-msg  = yes then do: 
    create tt-familia-aux.
    buffer-copy familia to tt-familia-aux.
    create tt-dados-env.                  
    assign tt-dados-env.num-sequencia  = i-seq 
           tt-dados-env.cod-tipo-reg   = 30
           tt-dados-env.ind-tipo-movto = i-tipo-movto
           tt-dados-env.identif-msg    = familia.fm-codigo.
    raw-transfer tt-familia-aux to tt-dados-env.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
end.

{cdp/cd7300.i6 "001" c-transacao}

/******************Fim-Multiplanta********************/ 

/***GERAÄ«O DE TRANSAÄ«O MULTIPLANTA ESPEC÷FICO SMC****/
   for each tt-smc-familia:
       delete tt-smc-familia.
   end.
   assign c-transacao = "SMC012"
          i-tipo-movto = if l-cria = yes then 1 else 2.
   {cdp/cd7300.i5 "001" c-transacao "-SMC"}
   run pi-cria-tt-dados-smc (i-tipo-movto).  
   {cdp/cd7300.i6 "001" c-transacao "-SMC"}

/***************FIM MULTIPLANTA SMC*******************/ 

/****************************************************************/    
    /* Para execuá∆o de Adapter da Mensagem Familia - EAI           */
    /****************************************************************/
    &IF DEFINED (bf_man_204) &THEN 
      /* Execucao caso usuario possua integracao EAI */
      IF v_log_eai_habilit THEN DO:
        IF adm-new-record THEN ASSIGN c-action = "add". 
                          ELSE ASSIGN c-action = "upd".
        FOR EACH tt-fam:
            DELETE tt-fam.
        END.
        CREATE tt-fam.
        BUFFER-COPY familia TO tt-fam.
        /*
        Se encontrar UPC de integraá∆o com agroind£stria
        alimenta a tt-fam com o atributo livre para atÇ
        a release 2.05 ou com o atributo de classificaá∆o
        a partir da release 2.06 
        */
                   
        RUN adapters/xml/ma2/axsma004.p (INPUT c-action,
                                         INPUT "CD0202.W",
                                         INPUT STRING(c-prg-vrs),
                                         INPUT "CDP",
                                         INPUT TABLE tt-fam,
                                         OUTPUT TABLE RowErrors).  

        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:

           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}

           undo, return "ADM-ERROR":U.
        END.
      END.
    &ENDIF
    
    &IF '{&mgscm_version}' >= '2.06B' &THEN
        IF CONNECTED('mgscm') THEN DO: 
            IF NOT VALID-HANDLE(hDBOproxy) THEN
                RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
            RUN ReplicaFamilia IN hDBOproxy(INPUT 2,
                                            INPUT familia.fm-codigo, 
                                            INPUT familia.descricao,
                                            INPUT familia.un,
                                            INPUT familia.tipo-con-est,
                                            OUTPUT TABLE RowErrors).
            IF RETURN-VALUE = 'NOK':U THEN DO:
                FOR EACH RowErrors:
                    RUN utp/ut-msgs.p (INPUT "show":U,
                                       INPUT RowErrors.ErrorNumber,
                                       INPUT RowErrors.ErrorParameters).
                END.
                RUN destroy IN hDBOproxy.
                RETURN "ADM-ERROR":U.
            END.
            RUN destroy IN hDBOproxy.
        END.
    &ENDIF
    
    &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
        /** Integraá∆o EAI2 **/
        
        IF v_log_eai2_ativado THEN DO:

           IF NOT VALID-HANDLE(h-cdapi996) OR
              h-cdapi996:TYPE <> "PROCEDURE":U OR
              h-cdapi996:FILE-NAME <> "cdp/cdapi996.p":U THEN DO:
              RUN cdp/cdapi996.p PERSISTENT SET h-cdapi996. 
           END.
            
           RUN pi-sendUpsert IN h-cdapi996 (INPUT ROWID(familia), OUTPUT TABLE RowErrors).

           IF VALID-HANDLE(h-cdapi996) AND
              h-cdapi996:TYPE = "PROCEDURE":U AND
              h-cdapi996:FILE-NAME = "cdp/cdapi996.p":U THEN DO:
              DELETE PROCEDURE h-cdapi996 NO-ERROR.
              ASSIGN h-cdapi996 = ?.
           END. 

           IF CAN-FIND(FIRST RowErrors) THEN DO:
               {method/showmessage.i1}
               {method/showmessage.i2 &Modal="YES"}
               ASSIGN cb-tp-classif-item:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.
               UNDO, RETURN "ADM-ERROR". 
           END.                     
        END.
    &ENDIF
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-copy-record V-table-Win 
PROCEDURE local-copy-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  ASSIGN l-copia = YES.                                                            
  assign tg-integra-his:CHECKED IN FRAME {&FRAME-NAME} = no.


  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'copy-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-create-record V-table-Win 
PROCEDURE local-create-record :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'create-record':U ) .

  assign l-cria = yes.

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
  
  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
      define variable c-familia          as character no-undo.
      define variable c-descricao        as character no-undo.
      define variable c-idi-classif-item as character no-undo.
      
  &ENDIF    

  IF CAN-FIND (FIRST funcao 
               WHERE funcao.cd-funcao = "spp-integra-ems-his"
               AND   funcao.ativo     = YES) THEN DO:

      &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          IF (familia.log-orig-ext) THEN DO:
             RUN utp/ut-msgs.p (input "show",
                                INPUT 35072,
                                input "" ).
             RETURN 'adm-error'.
          END.                  
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
         
            IF TRIM(SUBSTRING(familia.char-1,154,1)) = "S" THEN DO:
               RUN utp/ut-msgs.p (input "show",
                                  INPUT 35072,
                                  input "" ).
               RETURN 'adm-error'.
            END.
         &ENDIF
      &ENDIF
  END.
  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF CAN-FIND(FIRST funcao
                  WHERE funcao.cd-funcao = "spp-sgt"
                  AND   funcao.ativo = YES)  THEN DO:
         /* Inicio -- Projeto Internacional */
         DEFINE VARIABLE c-lbl-liter-eliminacao AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Eliminaá∆o" *}
         ASSIGN c-lbl-liter-eliminacao = TRIM(RETURN-VALUE).
         DEFINE VARIABLE c-lbl-liter-familias AS CHARACTER NO-UNDO.
         {utp/ut-liter.i "Familias" *}
         ASSIGN c-lbl-liter-familias = TRIM(RETURN-VALUE).
         RUN utp/ut-msgs.p (input "show",
                            input 33548,
                            input c-lbl-liter-eliminacao + "~~" + c-lbl-liter-familias ).
         RETURN 'adm-error'.
      END.
  &endif

  run pi-valida-eliminacao-familia.

  if  return-value <> "ok" then do:
      run pi-mostra-erros.
      return "ADM-ERROR".
  end.

  /******** EMS 2.02 **********/
  &IF DEFINED(bf_mat_tipo_ressup) &THEN
      run cdp/cd0202a1.p (input rowid(familia), input 2).
  &ENDIF 

  /***GERAÄ«O DE TRANSAÄ«O MULTIPLANTA ESPEC÷FICO SMC****/
   for each tt-smc-familia:
       delete tt-smc-familia.
   end.
   assign c-transacao = "SMC012"
          i-tipo-movto = 3.
   {cdp/cd7300.i5 "001" c-transacao "-SMC"}
   run pi-cria-tt-dados-smc (i-tipo-movto).  
   {cdp/cd7300.i6 "001" c-transacao "-SMC"}

  /***************FIM MULTIPLANTA SMC*******************/ 

  /****************************************************************/    
  /* Para execuá∆o de Adapter da Mensagem Familia Materiais - EAI */
  /****************************************************************/
  &IF DEFINED (bf_man_204) &THEN 
    IF v_log_eai_habilit THEN DO:
        FOR EACH tt-fam EXCLUSIVE-LOCK: DELETE tt-fam. END.
        CREATE tt-fam.
        BUFFER-COPY familia TO tt-fam.
    END.
  &ENDIF
  
  &IF '{&mgscm_version}' >= '2.06B' &THEN
      IF CONNECTED('mgscm') THEN DO: 
          IF NOT VALID-HANDLE(hDBOproxy) THEN
              RUN wmp/wmprx042.p PERSISTENT SET hDBOproxy.
          RUN EliminaFamilia IN hDBOproxy(INPUT 2,
                                          INPUT familia.fm-codigo, 
                                          OUTPUT TABLE RowErrors).
          IF RETURN-VALUE = 'NOK':U THEN DO:
              FOR EACH RowErrors
                  WHERE RowErrors.ErrorType <> 'INTERNAL':U:
                  RUN utp/ut-msgs.p (INPUT "show":U,
                                     INPUT RowErrors.ErrorNumber,
                                     INPUT RowErrors.ErrorParameters).
              END.
              RUN destroy IN hDBOproxy.
              RETURN "ADM-ERROR":U.
          END.
          RUN destroy IN hDBOproxy.
      END.
  &ENDIF
  
  &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
      assign c-familia          = familia.fm-codigo
             c-descricao        = familia.descricao
             c-idi-classif-item = STRING(familia.idi-classif-item).
  &ENDIF    
  
  

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'delete-record':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  /****************************************************************/    
  /* Para execuá∆o de Adapter da Mensagem Familia Materiais - EAI */
  /****************************************************************/
  if NOT RETURN-VALUE = 'ADM-ERROR':U then DO:
      &IF DEFINED (bf_man_204) &THEN 
        /* Execucao caso usuario possua integracao EAI */
        IF v_log_eai_habilit THEN DO:
            IF CAN-FIND (FIRST tt-fam) THEN DO:
                RUN adapters/xml/ma2/axsma004.p (INPUT "del",           
                                                 INPUT "CD0202.W",         
                                                 INPUT STRING(c-prg-vrs),  
                                                 INPUT "CDP",              
                                                 INPUT TABLE tt-fam,       
                                                 OUTPUT TABLE RowErrors).  
                    DELETE tt-fam.
                    IF CAN-FIND (FIRST RowErrors WHERE 
                                       RowErrors.ErrorSubType = "ERROR":U) THEN DO:
                       {method/showmessage.i1}
                       {method/showmessage.i2 &Modal="YES"}
                       UNDO, return "ADM-ERROR":U.
                    END.
                END.
        END.
      &ENDIF
      
      
      &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
     /** Integraá∆o EAI2 **/
     
     IF v_log_eai2_ativado THEN DO:
                                          
        IF NOT VALID-HANDLE(h-cdapi996) OR
           h-cdapi996:TYPE <> "PROCEDURE":U OR
           h-cdapi996:FILE-NAME <> "cdp/cdapi996.p":U THEN DO:
           RUN cdp/cdapi996.p PERSISTENT SET h-cdapi996. 
        END. 
                                                                 
        RUN pi-sendDelete IN h-cdapi996 (INPUT c-familia,
                                         INPUT c-descricao,
                                         INPUT c-idi-classif-item,
                                         OUTPUT TABLE RowErrors).
       
        IF VALID-HANDLE(h-cdapi996) AND
           h-cdapi996:TYPE = "PROCEDURE":U AND
           h-cdapi996:FILE-NAME = "cdp/cdapi996.p":U THEN DO:
           DELETE PROCEDURE h-cdapi996 NO-ERROR.
           ASSIGN h-cdapi996 = ?.
        END.
              
        IF CAN-FIND(FIRST RowErrors) THEN DO:
           {method/showmessage.i1}
           {method/showmessage.i2 &Modal="YES"}
           UNDO, return "ADM-ERROR":U.
        END.                     
     END.
  &ENDIF 
      
      
  END.

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

  if available familia then do:
     find tab-unidade where tab-unidade.un = familia.un no-lock no-error.
     assign c-un = if avail tab-unidade then tab-unidade.descricao else "":U.
  end. 

  if avail familia then do with frame {&frame-name}:
     assign cb-tp-classif-item:SCREEN-VALUE = {ininc/i99in122.i 04 familia.idi-classif-item} NO-ERROR.
  end.
  else do:
     assign cb-tp-classif-item:SCREEN-VALUE = {ininc/i99in122.i 04 1} NO-ERROR.
  end.
  
  ASSIGN cb-tp-classif-item:SENSITIVE IN FRAME {&FRAME-NAME} = FALSE.
  
  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'display-fields':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

  IF AVAIL familia THEN DO:
  &IF '{&bf_mat_versao_ems}' >= '2.08' &THEN
          IF (familia.log-orig-ext) THEN
             tg-integra-his:CHECKED IN FRAME f-main = YES.
          ELSE
             tg-integra-his:CHECKED IN FRAME f-main = NO.
      &ELSE
         &IF '{&bf_mat_versao_ems}' >= '2.062' &THEN
            IF TRIM(SUBSTRING(familia.char-1,154,1)) = "S" THEN DO:
               tg-integra-his:CHECKED IN FRAME f-main = YES.
            END.

            ELSE 
               tg-integra-his:CHECKED IN FRAME f-main = NO.
         &ENDIF
   &ENDIF
  END.
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
  
  ASSIGN cb-tp-classif-item:SENSITIVE IN FRAME {&FRAME-NAME} = TRUE.

  /* Code placed here will execute AFTER standard behavior.    */
  &if  defined(ADM-MODIFY-FIELDS) &then
      enable {&ADM-MODIFY-FIELDS} with frame {&frame-name}.
  &endif

  &IF '{&bf_mat_versao_ems}' >= '2.04' &THEN
      IF adm-new-record = NO THEN
         IF CAN-FIND(FIRST funcao
                     WHERE funcao.cd-funcao = "spp-sgt"
                     AND   funcao.ativo = YES)  THEN
            DISABLE familia.un WITH FRAME {&FRAME-NAME}.
      
  &endif
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-end-update V-table-Win 
PROCEDURE local-end-update :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/
  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'end-update':U ) .

  /*--- Na criaá∆oo default para o tipo de controle cont†bel 
        passa a ser 5 = Nao Definido ---*/

  if adm-adding-record AND familia.fm-codigo:sensitive in frame {&frame-name} then
      assign familia.tipo-contr = 1 no-error. 

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-initialize V-table-Win 
PROCEDURE local-initialize :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/


 /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'initialize':U ) .

  /* Code placed here will execute AFTER standard behavior.    */
  IF CAN-FIND (FIRST funcao 
               WHERE funcao.cd-funcao = "spp-integra-ems-his"
               AND   funcao.ativo     = YES) THEN DO:
                
      tg-integra-his:VISIBLE IN FRAME {&FRAME-NAME} = YES.
      tg-integra-his:SENSITIVE IN FRAME {&FRAME-NAME} = NO.
      /* FRAME {&FRAME-NAME}:HEIGHT =  FRAME {&FRAME-NAME}:HEIGHT + 1. */

   END. 
   ELSE DO:
       rt-mold:HEIGHT IN FRAME {&FRAME-NAME} =  rt-mold:HEIGHT IN FRAME {&FRAME-NAME} - 1.
       FRAME {&FRAME-NAME}:HEIGHT =  FRAME {&FRAME-NAME}:HEIGHT - 1.
    
    
    
       tg-integra-his:VISIBLE IN FRAME {&FRAME-NAME} = NO.
       tg-integra-his:ROW IN FRAME {&FRAME-NAME} = 1.
       tg-integra-his:COLUMN IN FRAME {&FRAME-NAME} = 1.
       tg-integra-his:WIDTH IN FRAME {&FRAME-NAME} = 1.
       tg-integra-his:HEIGHT IN FRAME {&FRAME-NAME} = 1.
   END.
    
   FIND FIRST param-global NO-LOCK NO-ERROR.
   IF (AVAILABLE param-global AND param-global.ind-int-agro) OR 
      (CAN-FIND(FIRST funcao WHERE funcao.cd-funcao = "spp-eai2-integra-ems-pims" AND funcao.ativo)) THEN
      ASSIGN cb-tp-classif-item:VISIBLE IN FRAME {&FRAME-NAME} = YES.
   ELSE  ASSIGN cb-tp-classif-item:VISIBLE IN FRAME {&FRAME-NAME} = NO.  
            
   do with frame {&frame-name}:
          DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
          ASSIGN cAuxTraducao002 = {ininc/i99in122.i 03}.
          RUN utp/ut-lstit.p (INPUT-OUTPUT cAuxTraducao002).
      assign cb-tp-classif-item:LIST-ITEM-PAIRS = cAuxTraducao002.
   
      /*assign cb-tp-classif-item:LIST-ITEM-PAIRS = {ininc/i99in122.i 03}.*/
   end.

   &IF '{&bf_mat_versao_ems}' >= '2.08' AND '{&bf_mat_integra_eai2}' = 'YES' &THEN
       /* Carrega a vari·vel global v_log_eai2_ativado */
       RUN cdp/cd0101i.p. 
   &ENDIF
    
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

  /* Code placed here will execute AFTER standard behavior.    */

  if avail familia then
     assign gr-familia = rowid(familia).

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE local-show-errors V-table-Win 
PROCEDURE local-show-errors :
/*------------------------------------------------------------------------------
  Purpose:     Override standard ADM method
  Notes:       
------------------------------------------------------------------------------*/

  /* Code placed here will execute PRIOR to standard behavior. */

  /* Dispatch standard ADM method.                             */
  RUN dispatch IN THIS-PROCEDURE ( INPUT 'show-errors':U ) .

  /* Code placed here will execute AFTER standard behavior.    */

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-cria-tt-dados-smc V-table-Win 
PROCEDURE pi-cria-tt-dados-smc :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param i-tipo-movto as integer.
assign i-seq = 1.

if  param-global.modulo-mp and
    tt-replica-msg-SMC.log-replica-msg  = yes then do: 
    create tt-smc-familia.
    buffer-copy familia to tt-smc-familia.
    create tt-dados-env-SMC.                  
    assign tt-dados-env-SMC.num-sequencia  = i-seq 
           tt-dados-env-SMC.cod-tipo-reg   = 30
           tt-dados-env-SMC.ind-tipo-movto = i-tipo-movto
           tt-dados-env-SMC.identif-msg    = familia.fm-codigo.
    raw-transfer tt-smc-familia to tt-dados-env-SMC.conteudo-msg.                                     
    assign i-seq = i-seq + 1.                                     
end.


END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-mostra-erros V-table-Win 
PROCEDURE pi-mostra-erros :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    for each tt-erro:
        delete tt-erro.
    end.
    
    {database/tgin/tdp/tdin122.i1}
    
    run cdp/cd0666.w (input table tt-erro).

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
  {src/adm/template/snd-list.i "familia"}

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

