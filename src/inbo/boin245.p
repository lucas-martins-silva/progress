&ANALYZE-SUSPEND _VERSION-NUMBER UIB_v8r12
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _DEFINITIONS DBOProgram 
/********************************************************************************
** Copyright DATASUL S.A. (1997)
** Todos os Direitos Reservados.
** 
** Este fonte e de propriedade exclusiva da DATASUL, sua reproducao
** parcial ou total por qualquer meio, so podera ser feita mediante
** autorizacao expressa.
*******************************************************************************/
{include/i-prgvrs.i BOIN245 2.00.00.058 } /*** "010058" 08/07/2026 13:54:52 ***/

&IF "{&EMSFND_VERSION}" >= "1.00" &THEN
{include/i-license-manager.i BOIN245 MEN}
&ENDIF


/*--------------------------------------------------------------------------
    File       : dbo.p
    Purpose    : O DBO (Datasul Business Objects) é um programa PROGRESS 
                 que contém a lógica de negócio e acesso a dados para uma 
                 tabela do banco de dados.

    Parameters : 

    Notes      : 
  ------------------------------------------------------------------------*/
/*          This .W file was created with the Progress UIB.               */
/*------------------------------------------------------------------------*/

/* ***************************  Definitions  **************************** */

/*--- Diretrizes de defini‡Æo ---*/
&GLOBAL-DEFINE DBOName BOIN245
&GLOBAL-DEFINE DBOVersion 2.00.00.000
&GLOBAL-DEFINE DBOCustomFunctions 
&GLOBAL-DEFINE TableName natur-oper
&GLOBAL-DEFINE TableLabel Natureza de Opera‡Æo
&GLOBAL-DEFINE QueryName qr{&TableName} 
&GLOBAL-DEFINE ROW-NUM-DEFINED NO

&GLOBAL-DEFINE XMLReceiver YES
&GLOBAL-DEFINE XMLProducer YES  
&GLOBAL-DEFINE DYNAMIC-QUERY-ENABLED YES

{utp/ut-glob.i}
{cdp/cdcfgdis.i}
{cdp/cdcfgmat.i}
{include/tt-edit.i}
{include/pi-edit.i}

/* Include i-epc200.i: Defini‡Æo Temp-Table tt-epc e dos programas de EPCs */
{include/i-epc200.i boin245}

DEFINE TEMP-TABLE tt-ct-clas-natur-operac NO-UNDO LIKE ct-clas-natur-operac
       field r-rowid as rowid.
       
&if defined (bf_dis_versao_ems) &then
&else
    &GLOBAL-DEFINE bf_dis_versao_ems 2.00
&endif

/*--- Include com defini‡Æo da temptable RowObject ---*/
/*--- Este include deve ser copiado para o diret¢rio do DBO e, ainda, seu nome
      deve ser alterado a fim de ser idˆntico ao nome do DBO mas com 
      extensÆo .i ---*/
{inbo/boin245.i RowObject}
/*--- Fat antecip / Ent fut no recebimento ---*/
{cdp/cd9700.i} /* definicao variaveis para cd9700.i1 */
{dibo/bodi159.i RowPedvenda}
{dibo/bodi159.i RowPedvendaAux}

{inbo/boin01059.i tt-natur-operac-internac}

/* Defini‡Æo/atribui‡Æo da vari ve l-mult-natur-receb -> Usa multiplas naturezas no recebimento */
{cdp/cd9701.i}


{java/boRest.i}



/*--- Include com defini‡Æo da query para tabela {&TableName} ---*/
/*--- Em caso de necessidade de altera‡Æo da defini‡Æo da query, pode ser retirada
      a chamada ao include a seguir e em seu lugar deve ser feita a defini‡Æo 
      manual da query ---*/
{method/dboqry.i}

{cdp/cd7300.i1}
{cdp/cdapi204.i}
{include/i_prdvers.i}

/*--- Defini‡Æo de buffer que ser  utilizado pelo m‚todo goToKey ---*/
DEFINE BUFFER bf{&TableName} FOR {&TableName}.

DEFINE BUFFER b-natur-oper FOR natur-oper.
def var h-boin245val     as handle no-undo.
def var h-bodi159        as handle no-undo.
DEF VAR h-bodi619        AS HANDLE NO-UNDO.
DEF VAR h-acompanhamento AS HANDLE NO-UNDO.
DEF VAR h-bomx202029     AS HANDLE NO-UNDO.
DEF VAR h-boin01059      AS HANDLE NO-UNDO.

def var cIniNatOperacao as char   no-undo.
def var cEndNatOperacao as char   no-undo.
def var cIniDenominacao as char   no-undo.
def var cEndDenominacao as char   no-undo.
def var iNatAtiva       as int    no-undo.
def var cIniCodCFOP     as char   no-undo.
def var c-cod-clas-fisc as char   NO-UNDO INITIAL "".

def var i-sequencia          as int no-undo.
def var i-cod-mensagem-ant   as int no-undo.

def var l-atualizar-mensagem as log init yes no-undo.

def var l-atualizar-mp as log init yes no-undo.

def var c-InfAdic-cfop as char no-undo.
 
DEF VAR l-funcao-spp-ent-fut AS LOG NO-UNDO INITIAL NO.

ASSIGN l-funcao-spp-ent-fut = CAN-FIND(FIRST funcao
                                      WHERE funcao.cd-funcao = "spp-ent-fut":U
                                      AND   funcao.ativo).


/*Integra‡Æo EAI*/
define new global shared variable v_log_eai_habilit as log  no-undo.
define new global shared variable v-prog-version    as char no-undo.
define new global shared variable v-prog-obj        as char no-undo.

def var l-del as logical init no no-undo.


DEFINE VARIABLE h-cd0606-crm  AS HANDLE  NO-UNDO.
DEFINE VARIABLE lIntCRM11     AS LOGICAL NO-UNDO INITIAL FALSE.
RUN utp/ut-crm11.p (OUTPUT lIntCRM11).

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-PREPROCESSOR-BLOCK 

/* ********************  Preprocessor Definitions  ******************** */

&Scoped-define PROCEDURE-TYPE DBOProgram
&Scoped-define DB-AWARE no



/* _UIB-PREPROCESSOR-BLOCK-END */
&ANALYZE-RESUME



/* *********************** Procedure Settings ************************ */

&ANALYZE-SUSPEND _PROCEDURE-SETTINGS
/* Settings for THIS-PROCEDURE
   Type: DBOProgram
   Allow: 
   Frames: 0
   Add Fields to: Neither
   Other Settings: CODE-ONLY COMPILE
 */
&ANALYZE-RESUME _END-PROCEDURE-SETTINGS

/* *************************  Create Window  ************************** */

&ANALYZE-SUSPEND _CREATE-WINDOW
/* DESIGN Window definition (used by the UIB) 
  CREATE WINDOW DBOProgram ASSIGN
         HEIGHT             = 1.42
         WIDTH              = 40.
/* END WINDOW DEFINITION */
                                                                        */
&ANALYZE-RESUME
&ANALYZE-SUSPEND _UIB-CODE-BLOCK _XFTR "DBO 2.0 Wizard" DBOProgram _INLINE
/* Actions: wizard/dbowizard.w ? ? ? ? */
/* DBO 2.0 Wizard (DELETE)*/
/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _INCLUDED-LIB DBOProgram 
/* ************************* Included-Libraries *********************** */

{method/dbo.i}

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


 


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _CUSTOM _MAIN-BLOCK DBOProgram 


/* ***************************  Main Block  *************************** */

find param-global NO-LOCK NO-ERROR.

def temp-table RowErrorsAux NO-UNDO like RowErrors.

def temp-table tt-natur-oper-eai no-undo like natur-oper.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


/* **********************  Internal Procedures  *********************** */

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterCreateRecord DBOProgram 
PROCEDURE afterCreateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        FIND FIRST tt-natur-operac-internac 
             WHERE tt-natur-operac-internac.cod-natur-operac = RowObject.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL tt-natur-operac-internac THEN DO:
            IF NOT VALID-HANDLE(h-boin01059) THEN DO:
                RUN inbo/boin01059.p PERSISTENT SET h-boin01059.
                RUN openQueryStatic IN h-boin01059(INPUT "Main":U) NO-ERROR.
            END.

            RUN pi-set-tt-natur-oper IN h-boin01059 (INPUT TABLE RowObject).
            
            RUN emptyRowErrors  IN h-boin01059.
            RUN goToKey         IN h-boin01059 (INPUT tt-natur-operac-internac.cod-natur-operac).                              
    
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN setRecord       IN h-boin01059 (INPUT TABLE tt-natur-operac-internac).
                RUN createRecord    IN h-boin01059.
            END.
            ELSE DO:
                RUN setRecord       IN h-boin01059 (INPUT TABLE tt-natur-operac-internac).
                RUN updateRecord    IN h-boin01059.
            END.
    
            IF RETURN-VALUE <> "OK":U THEN DO:               
                RUN getRowErrors IN h-boin01059 (OUTPUT TABLE RowErrors).
                IF  CAN-FIND(FIRST RowErrors
                             WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN RETURN "NOK":U.
            END. 

            if  valid-handle(h-boin01059) then
                RUN destroy IN h-boin01059.
        END.
    END.

    /* In¡cio da Classe Fiscal */
    IF i-pais-impto-usuario = 1 AND c-cod-clas-fisc <> "" THEN DO:

        IF NOT VALID-HANDLE(h-bodi619) THEN
          RUN dibo/bodi619.p PERSISTENT SET h-bodi619.

        RUN openQueryStatic IN h-bodi619 (INPUT "Main":U) NO-ERROR.
    
        RUN gotokey IN h-bodi619 (INPUT c-cod-clas-fisc, 
                                  INPUT RowObject.nat-operacao).
    
        IF RETURN-VALUE = "NOK" THEN DO:

            EMPTY TEMP-TABLE tt-ct-clas-natur-operac.
            CREATE tt-ct-clas-natur-operac.
            ASSIGN tt-ct-clas-natur-operac.cod-clas-fisc    = c-cod-clas-fisc
                   tt-ct-clas-natur-operac.cod-natur-operac = RowObject.nat-operacao.
        
            RUN emptyRowErrors IN h-bodi619.    
            RUN setRecord      IN h-bodi619 (INPUT TABLE tt-ct-clas-natur-operac).
            RUN createRecord   IN h-bodi619.
            RUN getRowErrors   IN h-bodi619 (OUTPUT TABLE RowErrors).

            FOR EACH RowErrors WHERE 
                     RowErrors.ErrorType    = "INTERNAL":U AND
                     RowErrors.ErrorSubType = "ERROR":U: 
                
                DELETE RowErrors.
            END.

            IF CAN-FIND(FIRST RowErrors WHERE 
                              RowErrors.ErrorSubType = "ERROR":U) THEN DO:  
                
                IF VALID-HANDLE(h-bodi619) THEN DO:
                    DELETE PROCEDURE h-bodi619.
                    ASSIGN h-bodi619 = ?.
                END. 
                RETURN "NOK". 
            END.
        END.

        RUN piPrioridadeMaxima IN h-bodi619 (INPUT RowObject.nat-operacao,
                                             INPUT c-cod-clas-fisc).
    END.
    
    IF  VALID-HANDLE(h-bodi619) THEN DO:
        DELETE PROCEDURE h-bodi619.
        ASSIGN h-bodi619 = ?.
    END. 
    /* Fim da Classe Fiscal */
    
    if l-atualizar-mp then do:
    
        {cdp/cd7300.i13 "001" "'DIS003'"}
    
        if  param-global.modulo-mp and
            tt-replica-msg.log-replica-msg then do:
            create tt-natur-oper-aux.
            buffer-copy RowObject except r-Rowid to tt-natur-oper-aux.
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-sequencia
                   tt-dados-env.cod-tipo-reg   = 10
                   tt-dados-env.ind-tipo-movto = 1
                   tt-dados-env.identif-msg    = RowObject.nat-operacao.
            raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.
            assign i-sequencia = i-sequencia + 1.
        end.
    
        {cdp/cd7300.i14 "001" "'DIS003'"}
    
    end.

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0606-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0606-crm.p PERSISTENT SET h-cd0606-crm.

        RUN sendToCRM IN h-cd0606-crm (INPUT RowObject.nat-operacao,
                                       OUTPUT TABLE RowErrors APPEND).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        DELETE PROCEDURE h-cd0606-crm.
    END.

    FIND FIRST b-natur-oper
         WHERE b-natur-oper.nat-operacao = RowObject.nat-operacao
           AND LOOKUP(SUBSTRING(b-natur-oper.cod-cfop,1,1),"5,6") > 0 NO-LOCK NO-ERROR.
    IF AVAIL b-natur-oper THEN
       RUN piIntegracao("CREATE").
    
     /* Integra‡Æo EAI */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then 
        if v_log_eai_habilit then do:
         
           if can-find(first tt-natur-oper-eai) then
            empty temp-table tt-natur-oper-eai no-error.

         create tt-natur-oper-eai.
         buffer-copy RowObject except r-rowid to tt-natur-oper-eai no-error.
                                                   
         run adapters/xml/vd2/axsvd002.p (input "add":U,
                                               input v-prog-obj,
                                               input v-prog-version,
                                               input table tt-natur-oper-eai,
                                               output table RowErrors).
           empty temp-table tt-natur-oper-eai no-error. 

          return (if can-find(first RowErrors) then "NOK":U
                else "OK":U).
       end.
   &endif.
     
    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "sendCreateRecordToWsAdd":U:

        DELETE tt-epc.
    END.
     
        {include/i-epc200.i2 &CodEvent='"sendCreateRecordToWsAdd"'
                                                 &CodParameter='"cod-natureza"'
                                                 &ValueParameter="RowObject.nat-operacao"}    

        {include/i-epc200.i2 &CodEvent='"sendCreateRecordToWsAdd"'
                                                 &CodParameter='"denominacao"'
                                                 &ValueParameter="RowObject.denominacao"}   
                                                 
                                                 
   {include/i-epc201.i "sendCreateRecordToWsAdd"}
                                                 
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterDeleteRecord DBOProgram 
PROCEDURE afterDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:      
      IF NOT VALID-HANDLE(h-boin01059) THEN DO:
          RUN inbo/boin01059.p PERSISTENT SET h-boin01059.
          RUN openQueryStatic IN h-boin01059(INPUT "Main":U) NO-ERROR.
      END.
      
      RUN goToKey IN h-boin01059 (INPUT RowObject.nat-operacao).
      
      IF RETURN-VALUE = "OK":U THEN DO:
          RUN deleteRecord IN h-boin01059.
      END.

      RUN destroy IN h-boin01059.
  END.

 /* Integra‡Æo EAI */
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN
        IF v_log_eai_habilit THEN DO:
            IF l-del THEN DO:
       
                RUN adapters/xml/vd2/axsvd002.p (INPUT "del":U,
                                                 INPUT v-prog-obj,
                                                 INPUT v-prog-version,
                                                 INPUT TABLE tt-natur-oper-eai,
                                                 OUTPUT TABLE RowErrors).
                ASSIGN l-del = NO.

                IF CAN-FIND(FIRST tt-natur-oper-eai) THEN
                    EMPTY TEMP-TABLE tt-natur-oper-eai NO-ERROR.

                RETURN(IF CAN-FIND(FIRST RowErrors) THEN "NOK":U ELSE "OK":U).
            END.
        END.
    &endif
    
    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "sendCreateRecordToWsDel":U:

        DELETE tt-epc.
    END.

    {include/i-epc200.i2 &CodEvent='"sendCreateRecordToWsDel"'
                                                 &CodParameter='"cod-natureza"'
                                                 &ValueParameter="RowObject.nat-operacao"}    
  
    {include/i-epc200.i2 &CodEvent='"sendCreateRecordToWsDel"'
                                                 &CodParameter='"denominacao"'
                                                 &ValueParameter="RowObject.denominacao"}   
                                                 
        {include/i-epc201.i "sendCreateRecordToWsDel"}
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE afterUpdateRecord DBOProgram 
PROCEDURE afterUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def var i-qtde-registros  as int  no-undo.
    def var cod-clas-fisc-aux as char NO-UNDO initial "".

    /* classe fiscal do cliente */
    IF NOT VALID-HANDLE(h-bodi619) THEN
          RUN dibo/bodi619.p PERSISTENT SET h-bodi619.
          
    RUN openQueryStatic IN h-bodi619 (INPUT "Main":U) NO-ERROR.
    
    RUN goToKey2     IN h-bodi619 (INPUT RowObject.nat-operacao).
    IF RETURN-VALUE  = "OK" THEN
        RUN getcharfield IN h-bodi619 (INPUT "cod-clas-fisc",
                                       OUTPUT cod-clas-fisc-aux). 
                                           
    IF cod-clas-fisc-aux <> "" AND cod-clas-fisc-aux <> c-cod-clas-fisc THEN DO:
              
        RUN emptyRowErrors IN h-bodi619.
        RUN gotokey        IN h-bodi619 (INPUT cod-clas-fisc-aux, INPUT RowObject.nat-operacao).
        RUN deleteRecord   IN h-bodi619.
        RUN getRowErrors   IN h-bodi619 (OUTPUT TABLE RowErrors).
          
        FOR EACH RowErrors WHERE 
                 RowErrors.ErrorType    = "INTERNAL":U AND
                 RowErrors.ErrorSubType = "ERROR":U: 
                 
            DELETE RowErrors.
        END.
        IF  CAN-FIND(FIRST RowErrors WHERE
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:             
            
            IF  VALID-HANDLE(h-bodi619) THEN DO:
                DELETE PROCEDURE h-bodi619.
                ASSIGN h-bodi619 = ?.
            END. 
            RETURN "NOK". 
        END.
    END.
    IF c-cod-clas-fisc <> "" THEN DO:
    
        RUN gotokey IN h-bodi619 (INPUT c-cod-clas-fisc,
                                  INPUT RowObject.nat-operacao).

        IF RETURN-VALUE = "NOK" THEN DO:    
        
            EMPTY TEMP-TABLE tt-ct-clas-natur-operac.
            CREATE tt-ct-clas-natur-operac.
            ASSIGN tt-ct-clas-natur-operac.cod-clas-fisc    = c-cod-clas-fisc
                   tt-ct-clas-natur-operac.cod-natur-operac = RowObject.nat-operacao.
                        
            RUN emptyRowErrors IN h-bodi619.    
            RUN setRecord      IN h-bodi619 (INPUT TABLE tt-ct-clas-natur-operac).
            RUN createRecord   IN h-bodi619.
            RUN getRowErrors   IN h-bodi619 (OUTPUT TABLE RowErrors).
          
            FOR EACH RowErrors WHERE 
                     RowErrors.ErrorType    = "INTERNAL":U AND
                     RowErrors.ErrorSubType = "ERROR":U: 
                     
                DELETE RowErrors.
            END.
            IF  CAN-FIND(FIRST RowErrors WHERE
                               RowErrors.ErrorSubType = "ERROR":U) THEN DO:  
                               
                IF  VALID-HANDLE(h-bodi619) THEN DO:
                    DELETE PROCEDURE h-bodi619.
                    ASSIGN h-bodi619 = ?.
                END. 
                RETURN "NOK". 
            END.
        END.
        
        RUN piPrioridadeMaxima IN h-bodi619 (INPUT RowObject.nat-operacao,
                                             INPUT c-cod-clas-fisc).
    END.
      
    IF  VALID-HANDLE(h-bodi619) THEN DO:
        DELETE PROCEDURE h-bodi619.
        ASSIGN h-bodi619 = ?.
    END. 
    /* fim classe fiscal do cliente */
    
    IF i-pais-impto-usuario <> 1 /* Brasil */ THEN DO:
        FIND FIRST tt-natur-operac-internac 
             WHERE tt-natur-operac-internac.cod-natur-operac = RowObject.nat-operacao NO-LOCK NO-ERROR.
        IF AVAIL tt-natur-operac-internac THEN DO:
            IF NOT VALID-HANDLE(h-boin01059) THEN DO:
                RUN inbo/boin01059.p PERSISTENT SET h-boin01059.
                RUN openQueryStatic IN h-boin01059(INPUT "Main":U) NO-ERROR.
            END.
      
            RUN pi-set-tt-natur-oper IN h-boin01059 (INPUT TABLE RowObject).
      
            RUN emptyRowErrors  IN h-boin01059.
            RUN goToKey         IN h-boin01059 (INPUT tt-natur-operac-internac.cod-natur-operac).                              
      
            IF RETURN-VALUE = "NOK":U THEN DO:
                RUN setRecord       IN h-boin01059 (INPUT TABLE tt-natur-operac-internac).
                RUN createRecord    IN h-boin01059.
            END.
            ELSE DO:
                RUN setRecord       IN h-boin01059 (INPUT TABLE tt-natur-operac-internac).
                RUN updateRecord    IN h-boin01059.
            END.
      
            IF RETURN-VALUE <> "OK":U THEN DO:               
                RUN getRowErrors IN h-boin01059 (OUTPUT TABLE RowErrors).
                IF  CAN-FIND(FIRST RowErrors
                             WHERE RowErrors.ErrorType <> "INTERNAL":U) THEN RETURN "NOK":U.
            END.

            if  valid-handle(h-boin01059) then
                RUN destroy IN h-boin01059.

        END.
    END.


    if l-atualizar-mp then do:

        {cdp/cd7300.i13 "001" "'DIS003'"}
    
        if  param-global.modulo-mp and
            tt-replica-msg.log-replica-msg then do:
            create tt-natur-oper-aux.
            buffer-copy RowObject except r-Rowid to tt-natur-oper-aux.
            create tt-dados-env.
            assign tt-dados-env.num-sequencia  = i-sequencia
                   tt-dados-env.cod-tipo-reg   = 10
                   tt-dados-env.ind-tipo-movto = 2
                   tt-dados-env.identif-msg    = RowObject.nat-operacao.
            raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.
            assign i-sequencia = i-sequencia + 1.
        end.
    
        {cdp/cd7300.i14 "001" "'DIS003'"}

    end.

    if  RowObject.cod-mensagem <> i-cod-mensagem-ant and
        l-atualizar-mensagem then do:
        if  not session:remote then do:
            run utp/ut-acomp.p persistent set h-acompanhamento.
            run pi-inicializar in h-acompanhamento("Alterando as Mensagens do Pedido.").
            /* Inicio -- Projeto Internacional */
            {utp/ut-liter.i "Verificando_os_Pedidos" *}
            run pi-acompanhar in h-acompanhamento(RETURN-VALUE).
        end.

        for each ped-venda use-index ch-natoper
            where ped-venda.cod-sit-ped  < 2
            and ped-venda.nat-operacao = RowObject.nat-operacao
            and ped-venda.cod-mensagem = i-cod-mensagem-ant exclusive-lock:
            
            if  not session:remote THEN
                /* Inicio -- Projeto Internacional */
                DO:
                DEFINE VARIABLE c-lbl-liter-nome-abreviado AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Nome_Abreviado" *}
                ASSIGN c-lbl-liter-nome-abreviado = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-liter-pedido AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Pedido" *}
                ASSIGN c-lbl-liter-pedido = TRIM(RETURN-VALUE).
                run pi-acompanhar in h-acompanhamento(c-lbl-liter-nome-abreviado + ": " + ped-venda.nome-abrev + " | " + 
                                                      c-lbl-liter-pedido + ": " + ped-venda.nr-pedcli + ".").
                END. 
            assign ped-venda.cod-mensagem = RowObject.cod-mensagem.
        end.

        if  not session:remote then do:
            if  valid-handle(h-acompanhamento) then do:
                run pi-finalizar in h-acompanhamento.
                assign h-acompanhamento = ?.
            end.
        end.
    end.

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0606-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0606-crm.p PERSISTENT SET h-cd0606-crm.

        RUN sendToCRM IN h-cd0606-crm (INPUT RowObject.nat-operacao,
                                       OUTPUT TABLE RowErrors APPEND).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        DELETE PROCEDURE h-cd0606-crm.
    END.

    FOR FIRST b-natur-oper
        WHERE b-natur-oper.nat-operacao = RowObject.nat-operacao 
          AND LOOKUP(SUBSTRING(b-natur-oper.cod-cfop,1,1),"5,6") > 0 NO-LOCK:
        RUN piIntegracao("UPDATE").
    END.

    /* Integra‡Æo EAI */
    &IF '{&BF_DIS_VERSAO_EMS}' >= '2.04' &THEN 
        IF v_log_eai_habilit THEN DO:
      
            IF CAN-FIND(FIRST tt-natur-oper-eai) THEN
                EMPTY TEMP-TABLE tt-natur-oper-eai NO-ERROR.

            CREATE tt-natur-oper-eai.
            BUFFER-COPY RowObject EXCEPT r-rowid TO tt-natur-oper-eai NO-ERROR.

            RUN adapters/xml/vd2/axsvd002.p (INPUT "upd":U,
                                             INPUT v-prog-obj,
                                             INPUT v-prog-version,
                                             INPUT TABLE tt-natur-oper-eai,
                                             OUTPUT TABLE RowErrors).
            EMPTY TEMP-TABLE tt-natur-oper-eai NO-ERROR. 
         
            RETURN (IF CAN-FIND(FIRST RowErrors) THEN "NOK":U ELSE "OK":U).
        END.
    &ENDIF.
      
    FOR EACH tt-epc
        WHERE tt-epc.cod-event = "sendCreateRecordToWsAdd":U:

        DELETE tt-epc.
    END.
           
        {include/i-epc200.i2 &CodEvent='"sendCreateRecordToWsAdd"'
                                                 &CodParameter='"cod-natureza"'
                                                 &ValueParameter="RowObject.nat-operacao"}    
         
        {include/i-epc200.i2 &CodEvent='"sendCreateRecordToWsAdd"'
                                                 &CodParameter='"denominacao"'
                                                 &ValueParameter="RowObject.denominacao"}   

    
    {include/i-epc201.i "sendCreateRecordToWsAdd"}
     
    RETURN "OK".
                      
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE atualizarMP DBOProgram 
PROCEDURE atualizarMP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-atualizar-mp as log no-undo.

    assign l-atualizar-mp = p-atualizar-mp.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeDeleteRecord DBOProgram 
PROCEDURE beforeDeleteRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    if l-atualizar-mp then do:
  
      {cdp/cd7300.i13 "001" "'DIS003'"}
  
      if  param-global.modulo-mp and
          tt-replica-msg.log-replica-msg then do: 
          create tt-natur-oper-aux.
          buffer-copy RowObject except r-rowid to tt-natur-oper-aux.
          create tt-dados-env.                  
          assign tt-dados-env.num-sequencia  = i-sequencia
                 tt-dados-env.cod-tipo-reg   = 10
                 tt-dados-env.ind-tipo-movto = 3
                 tt-dados-env.identif-msg    = RowObject.nat-operacao
                 i-sequencia                 = i-sequencia + 1.
          raw-transfer tt-natur-oper-aux to tt-dados-env.conteudo-msg.
      end.
  
      {cdp/cd7300.i14 "001" "'DIS003'"}
  
   end.

    IF lIntCRM11 THEN DO:
        IF NOT VALID-HANDLE(h-cd0606-crm) THEN
            RUN integracoes/adapters/emstocrm/cd0606-crm.p PERSISTENT SET h-cd0606-crm.
        
        RUN deleteFromCRM IN h-cd0606-crm (INPUT RowObject.nat-operacao,
                                           OUTPUT TABLE RowErrors APPEND).
        IF CAN-FIND (FIRST RowErrors WHERE 
                           RowErrors.ErrorSubType = "ERROR":U) THEN DO:
            RETURN "NOK":U.
        END.
        DELETE PROCEDURE h-cd0606-crm.
    END.

    FOR FIRST b-natur-oper
        WHERE b-natur-oper.nat-operacao = RowObject.nat-operacao
          AND LOOKUP(SUBSTRING(b-natur-oper.cod-cfop,1,1),"5,6") > 0 NO-LOCK:
        RUN piIntegracao("DELETE").
    END.

    /* Integra‡Æo EAI */
    &if '{&BF_DIS_VERSAO_EMS}' >= '2.04' &then 
        if v_log_eai_habilit then do:
         
         create tt-natur-oper-eai.
         buffer-copy RowObject except r-rowid to tt-natur-oper-eai no-error.
                   
         assign l-del = yes.
           
        end.
    &endif.
    
    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE beforeUpdateRecord DBOProgram 
PROCEDURE beforeUpdateRecord :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    assign i-cod-mensagem-ant = natur-oper.cod-mensagem.

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE convertOperationType DBOProgram 
PROCEDURE convertOperationType :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input        param p-resultado        as int no-undo. /* (1) campos da tabela (0,2,3...) tipo opera‡Æo */
    def input-output param p-tipo-operacao    as int no-undo.
    def input-output param p-tipo-entrega     as int no-undo. /* char-1,1,5 */
    def input-output param p-nota-faturamento as log no-undo. /* natur-oper.ind-entfut */
    def input-output param p-nota-remessa     as log no-undo. /* natur-oper.ind-est-qtd */
    
    /**************************************************************
    ** Tipos de Opera‡äes Entrega Futura/ Faturamento Antecipado
    **
    **   1 - Nenhum/Faturamento Presente
    **   2 - Faturamento Antecipado
    **   3 - Remessa de Faturamento Antecipado
    **   4 - Faturamento com Entrega Futura
    **   5 - Remessa de Entrega Futura
    **   Outros Valores - Nenhum/Faturamento Presente
    **
    **************************************************************/

    if  p-resultado = 1 then do:
        case p-tipo-operacao:
            when 1 then
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = no
                          p-nota-remessa     = no.
            when 2 then
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = yes
                          p-nota-remessa     = no.
            when 3 then
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = no
                          p-nota-remessa     = yes.
            when 4 then
                   assign p-tipo-entrega     = 2
                          p-nota-faturamento = yes
                          p-nota-remessa     = no.
            when 5 then
                   assign p-tipo-entrega     = 2
                          p-nota-faturamento = no
                          p-nota-remessa     = yes.
            otherwise
                   assign p-tipo-entrega     = 1
                          p-nota-faturamento = no
                          p-nota-remessa     = no.
        end case.
    end.
    else do:
        if  p-tipo-entrega = 1 then do:

            if  not p-nota-faturamento and
                not p-nota-remessa then
                assign p-tipo-operacao = 1.

            if  p-nota-faturamento and
                not p-nota-remessa then
                assign p-tipo-operacao = 2.

            if  not p-nota-faturamento and
                p-nota-remessa then
                assign p-tipo-operacao = 3.

        end.
        else do:
            if  p-tipo-entrega = 2 then do:

                /******************************************
                ** Assume 1 apenas por conven‡Æo, a com- **
                ** bina‡Æo abaixo nÆo existe nesse caso  **
                *******************************************/
                if  not p-nota-faturamento and
                    not p-nota-remessa then
                    assign p-tipo-operacao = 1.

                if  p-nota-faturamento and
                    not p-nota-remessa then
                    assign p-tipo-operacao = 4.

                if  not p-nota-faturamento and
                    p-nota-remessa then
                    assign p-tipo-operacao = 5.

            end.
            else
                assign p-tipo-operacao = 1.
        end.
    end.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ExportCFOP DBOProgram 
PROCEDURE ExportCFOP :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEF INPUT PARAM pc-nat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    &if defined(bf_dis_formato_CFOP) &then
        DEF INPUT PARAM pc-old-cfop     LIKE natur-oper.cod-cfop   NO-UNDO.
        DEF INPUT PARAM pc-new-cfop     LIKE natur-oper.cod-cfop   NO-UNDO.
    &else
        DEF INPUT PARAM pc-old-cfop     LIKE natur-oper.char-1     NO-UNDO.
        DEF INPUT PARAM pc-new-cfop     LIKE natur-oper.char-1     NO-UNDO.
    &endif
    
    DEF INPUT PARAM pd-dt-ini       AS DATE NO-UNDO.
    DEF INPUT PARAM pd-dt-fim       AS DATE NO-UNDO.
    DEF INPUT PARAM pl-export-equal AS LOG  NO-UNDO.
        
    DEF VAR h-acomp AS HANDLE NO-UNDO.

    IF  NOT SESSION:REMOTE THEN DO:
        RUN utp/ut-acomp.p PERSISTENT SET h-acomp.
        RUN pi-inicializar IN h-acomp(INPUT "Exportando CFOP: Natur Oper -> DOC-FISCAL").
    END.

    BLOCK_exporta:
    DO TRANS:

        FOR EACH  doc-fiscal 
            WHERE doc-fiscal.nat-operacao = pc-nat-operacao
              AND doc-fiscal.dt-docto    >= pd-dt-ini
              AND doc-fiscal.dt-docto    <= pd-dt-fim EXCLUSIVE-LOCK 
            ON STOP  UNDO BLOCK_exporta, RETURN "NOK":U
            ON ERROR UNDO BLOCK_exporta, RETURN "NOK":U:
    
        IF  pl-export-equal 
            AND &IF defined(bf_dis_formato_CFOP) &THEN
                doc-fiscal.cod-cfop <> pc-old-cfop THEN
                &else
                trim(substr(doc-fiscal.char-1,1,10)) <> pc-old-cfop THEN
                &endif
                NEXT.
    
            IF  NOT SESSION:REMOTE THEN
                /* Inicio -- Projeto Internacional */
                DO:
                {utp/ut-liter.i "Documento" *}
                RUN pi-acompanhar IN h-acomp (INPUT RETURN-VALUE + ": " + doc-fiscal.nr-doc-fis).
                END. 

            &IF defined(bf_dis_formato_CFOP) &THEN
            ASSIGN doc-fiscal.cod-cfop = pc-new-cfop.
                &ELSE
                ASSIGN OVERLAY (doc-fiscal.char-1,1,10) = pc-new-cfop.
            &endif
            
        END.

        IF  NOT SESSION:REMOTE THEN
            RUN pi-finalizar IN h-acomp.

    END.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE findNatureza DBOProgram 
PROCEDURE findNatureza :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  parameter c-nat-operacao as char no-undo.
    def output parameter c-return       as char no-undo.
 
    find natur-oper where
         natur-oper.nat-operacao = c-nat-operacao no-lock no-error.
    if  not avail natur-oper then do:
        /* Inicio -- Projeto Internacional */
        {utp/ut-liter.i "Natureza_de_Opera‡Æo" *}
        run utp/ut-msgs.p (input "msg",
                           input 2,
                           input RETURN-VALUE).
        assign c-return = return-value.
    end.
    else do:
        run _copyBuffer2TT.
    end.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getCharField DBOProgram 
PROCEDURE getCharField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo caracter
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS CHARACTER NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "cd-registro":U THEN ASSIGN pFieldValue = RowObject.cd-registro.
        WHEN "cd-vinc-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-vinc-ipi.
        WHEN "char-1":U THEN ASSIGN pFieldValue = RowObject.char-1.
        WHEN "char-2":U THEN ASSIGN pFieldValue = RowObject.char-2.
        
        &if defined(bf-mat-comex) &then            
            WHEN "narrativa":U THEN ASSIGN pFieldValue = string(RowObject.narrativa[1] + RowObject.narrativa[2] + RowObject.narrativa[3]).
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
            WHEN "mercado":U THEN ASSIGN pFieldValue = RowObject.mercado.
        &else
            WHEN "narrativa":U THEN ASSIGN pFieldValue = RowObject.narrativa.
            WHEN "check-sum":U THEN ASSIGN pFieldValue = RowObject.check-sum.
            WHEN "ct-cusven":U THEN ASSIGN pFieldValue = RowObject.ct-cusven.
            WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
            WHEN "ct-transven":U THEN ASSIGN pFieldValue = RowObject.ct-transven.
            WHEN "sc-cusven":U THEN ASSIGN pFieldValue = RowObject.sc-cusven.
            WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
            WHEN "sc-transven":U THEN ASSIGN pFieldValue = RowObject.sc-transven.
            &if defined (bf_dis_desc_bonif) &then
                WHEN "cod-natur-oper-bonif":U THEN ASSIGN pFieldValue = RowObject.cod-natur-oper-bonif.
            &endif
        &endif
        WHEN "cod-esp":U THEN ASSIGN pFieldValue = RowObject.cod-esp.
        WHEN "denominacao":U THEN ASSIGN pFieldValue = RowObject.denominacao.
        WHEN "especie-doc":U THEN ASSIGN pFieldValue = RowObject.especie-doc.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "form-cfop":U THEN ASSIGN pFieldValue = RowObject.form-cfop.
        WHEN "log-nota-comercio":U THEN ASSIGN pFieldValue = RowObject.log-nota-comercio.
        WHEN "modelo-cupom":U THEN ASSIGN pFieldValue = RowObject.modelo-cupom.
        &endif
        &if '{&bf_dis_versao_ems}' >= '2.07' &THEN
        WHEN "cod-model-nf-eletro":U THEN ASSIGN pFieldValue = RowObject.cod-model-nf-eletro.
        &endif
        WHEN "modelo-docto":U THEN ASSIGN pFieldValue = RowObject.modelo-docto.
        WHEN "nat-comp":U THEN ASSIGN pFieldValue = RowObject.nat-comp.
        WHEN "nat-operacao":U THEN ASSIGN pFieldValue = RowObject.nat-operacao.
        WHEN "nat-vinculada":U THEN ASSIGN pFieldValue = RowObject.nat-vinculada.
        WHEN "tp-base-icm":U THEN ASSIGN pFieldValue = RowObject.tp-base-icm.
        WHEN "cod-cfop":U THEN ASSIGN pFieldValue = 
                                        &if defined(bf_dis_formato_CFOP) &then
                                             natur-oper.cod-cfop
                                        &else
                                             trim(substr(natur-oper.char-1,45,10))
                                        &ENDIF .


        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE GetCodModeloNFe DBOProgram 
PROCEDURE GetCodModeloNFe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM c-modeloNFe AS CHARACTER NO-UNDO.

   /*--- Nota Fiscal Eletronica ---*/
   /*Campo para versäes 204 a 207*/

    &if '{&bf_dis_versao_ems}' >= '2.04' AND '{&bf_dis_versao_ems}' < '2.07' &THEN
          ASSIGN c-modeloNFe = SUBSTR(RowObject.char-2,120,2).
    &endif
    /*Campo para versäes 204 a 207*/
    &if '{&bf_dis_versao_ems}' >= '2.07' &THEN
        ASSIGN c-modeloNFe = RowObject.cod-model-nf-eletro.
    &endif
    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDataCFOP DBOProgram 
PROCEDURE getDataCFOP :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a Data do CFOP
  Parameters:  
               recebe      - 
               retorna Data-cfop
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pData-cfop AS CHAR NO-UNDO.
    
    find para-ped no-lock no-error.
    if avail para-ped then 
        find param-of where param-of.cod-estabel = para-ped.estab-padrao no-lock no-error.
    else
        find first param-of no-lock no-error.
       
    if avail param-of then do:
        &if defined(bf_dis_formato_CFOP) &then
            assign pData-cfop = string(param-of.dat-format-cfop).
        &ELSE 
            assign pData-cfop = string(param-of.data-2).
        &endif
        if  pData-cfop = ? then              
            assign pData-cfop = "01/01/2003". 

    end.  
    ELSE 
        assign pData-cfop = "01/01/2003".
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDateField DBOProgram 
PROCEDURE getDateField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo data
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DATE NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &if defined(bf-mat-comex) &then            
        &else
            WHEN "data-1":U THEN ASSIGN pFieldValue = RowObject.data-1.
            WHEN "data-2":U THEN ASSIGN pFieldValue = RowObject.data-2.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDecField DBOProgram 
PROCEDURE getDecField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo decimal
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pFieldName AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS DECIMAL NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        WHEN "aliq-icm-com":U THEN ASSIGN pFieldValue = RowObject.aliq-icm-com.
        WHEN "aliquota-icm":U THEN ASSIGN pFieldValue = RowObject.aliquota-icm.
        WHEN "dec-1":U THEN ASSIGN pFieldValue = RowObject.dec-1.
        WHEN "dec-2":U THEN ASSIGN pFieldValue = RowObject.dec-2.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "dest-red-icms":U THEN ASSIGN pFieldValue = RowObject.dest-red-icms.
        &endif
        WHEN "icms-subs-trib":U THEN ASSIGN pFieldValue = RowObject.icms-subs-trib.
        WHEN "per-des-icms":U THEN ASSIGN pFieldValue = RowObject.per-des-icms.
        WHEN "per-fin-soc[1]":U THEN ASSIGN pFieldValue = RowObject.per-fin-soc[1].
        WHEN "per-fin-soc[2]":U THEN ASSIGN pFieldValue = RowObject.per-fin-soc[2].
        WHEN "per-sub-tri":U THEN ASSIGN pFieldValue = RowObject.per-sub-tri.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "perc-desc-zf":U THEN ASSIGN pFieldValue = RowObject.perc-desc-zf.
        &endif
        WHEN "perc-PIS[1]":U THEN ASSIGN pFieldValue = RowObject.perc-PIS[1].
        WHEN "perc-PIS[2]":U THEN ASSIGN pFieldValue = RowObject.perc-PIS[2].
        WHEN "perc-red-icm":U THEN ASSIGN pFieldValue = RowObject.perc-red-icm.
        WHEN "perc-red-ipi":U THEN ASSIGN pFieldValue = RowObject.perc-red-ipi.
        WHEN "perc-red-iss":U THEN ASSIGN pFieldValue = RowObject.perc-red-iss.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "var-val-it-terc":U THEN ASSIGN pFieldValue = RowObject.var-val-it-terc.
        &endif
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDenomNatur DBOProgram 
PROCEDURE getDenomNatur :
/*------------------------------------------------------------------------------
  Parameters: pc-nat-operacao  - recebe o codigo da natureza
              pc-denominacao   - retorna a descricao
  Notes:       
------------------------------------------------------------------------------*/
    def input  param pc-nat-operacao like natur-oper.nat-operacao no-undo.
    def output param pc-denominacao  LIKE natur-oper.denominacao  no-undo.

    for first natur-oper fields (denominacao)
        where natur-oper.nat-operacao = pc-nat-operacao no-lock: end.
    
    if avail natur-oper then
       assign pc-denominacao = natur-oper.denominacao.    
    else DO:
        {utp/ut-liter.i Natureza_de_opera‡Æo_inexistente *}
         assign pc-denominacao = TRIM(RETURN-VALUE).
        RETURN "NOK":U.
    END.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getDescCFOP DBOProgram 
PROCEDURE getDescCFOP :
/*------------------------------------------------------------------------------
  Purpose:     Retorna a descri‡Æo do CFOP
  Parameters:  
               recebe Cod-cfop 
               retorna Des-cfop
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pItCod-cfop AS CHAR      NO-UNDO.
    DEFINE OUTPUT PARAMETER pDesc-cfop  AS CHARACTER NO-UNDO.
    
    &IF DEFINED(bf_dis_formato_CFOP) &THEN
        FIND FIRST cfop-natur WHERE cfop-natur.cod-cfop = pItCod-cfop NO-LOCK NO-ERROR.
        IF AVAIL cfop-natur THEN DO:
            ASSIGN pDesc-cfop = cfop-natur.des-cfop. 
            RETURN "OK":U.
        END.
        ELSE
           RETURN "NOK":U.
    &ELSE
        find first ped-curva where ped-curva.it-codigo = pItCod-cfop and
                                   ped-curva.vl-aberto = 620 no-lock no-error.
        if avail ped-curva then do:    
           assign pDesc-cfop = ped-curva.nome.
           RETURN "OK":U.
        end.
        else
           RETURN "NOK":U.
    &ENDIF
           
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getInfAdicCFOP DBOProgram 
PROCEDURE getInfAdicCFOP :
/*------------------------------------------------------------------------------
  Purpose:     Retorna as informa‡äes adicionais do CFOP
  Parameters:  
               recebe Cod-cfop 
               retorna  
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pItCod-cfop   AS CHAR      NO-UNDO.
    DEFINE OUTPUT PARAMETER pInfAdic-cfop AS CHARACTER NO-UNDO.

    def var l-pri as logical init "yes" no-undo.
    
    &if defined(bf_dis_formato_CFOP) &then
        find cfop-natur where cfop-natur.cod-cfop = pItCod-cfop no-lock no-error.
        if  avail cfop-natur then     
            assign c-InfAdic-cfop = cfop-natur.dsl-inform-adic.
    &else
        find first ped-curva 
             where ped-curva.it-codigo = pItCod-cfop 
               and ped-curva.vl-aberto = 620 no-lock no-error.
        if  avail ped-curva then
            assign c-InfAdic-cfop = ped-curva.char-1 + ped-curva.char-2.
    &endif.
    
    assign c-InfAdic-cfop = replace (c-InfAdic-cfop,chr(10)," ").
    run pi-print-editor(c-InfAdic-cfop,60).
    for each tt-editor:
    IF tt-editor.conteudo <> " " then
        if l-pri = yes then
            assign pInfAdic-cfop = tt-editor.conteudo.
        else
            assign pInfAdic-cfop = pInfAdic-cfop + chr(10) + tt-editor.conteudo.    
    assign l-pri = no.    
    end. 
   
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getIntField DBOProgram 
PROCEDURE getIntField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo inteiro
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS INTEGER   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.
    CASE pFieldName:
        WHEN "cd-situacao":U THEN ASSIGN pFieldValue = RowObject.cd-situacao.
        WHEN "cod-mensagem":U THEN ASSIGN pFieldValue = RowObject.cod-mensagem.
        &if defined(bf-mat-comex) &then            
            WHEN "ct-cusven":U THEN ASSIGN pFieldValue = RowObject.ct-cusven.
            WHEN "ct-recven":U THEN ASSIGN pFieldValue = RowObject.ct-recven.
            WHEN "ct-transven":U THEN ASSIGN pFieldValue = RowObject.ct-transven.
            WHEN "sc-cusven":U THEN ASSIGN pFieldValue = RowObject.sc-cusven.
            WHEN "sc-recven":U THEN ASSIGN pFieldValue = RowObject.sc-recven.
            WHEN "sc-transven":U THEN ASSIGN pFieldValue = RowObject.sc-transven.
        &else
            WHEN "merc-base-icms":U THEN ASSIGN pFieldValue = RowObject.merc-base-icms.
            WHEN "mercado":U THEN ASSIGN pFieldValue = RowObject.mercado.
            WHEN "cd-trib-icm":U THEN ASSIGN pFieldValue = RowObject.cd-trib-icm.
            WHEN "cd-trib-ipi":U THEN ASSIGN pFieldValue = RowObject.cd-trib-ipi.
            WHEN "cd-trib-iss":U THEN ASSIGN pFieldValue = RowObject.cd-trib-iss.
            WHEN "cod-canal-venda":U THEN ASSIGN pFieldValue = RowObject.cod-canal-venda.
            WHEN "oper-terc":U THEN ASSIGN pFieldValue = RowObject.oper-terc.
            WHEN "preco-saida":U THEN ASSIGN pFieldValue = RowObject.preco-saida.
            WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
            WHEN "tipo-trib":U THEN ASSIGN pFieldValue = RowObject.tipo-trib.
        &endif
        
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "ind-entreg-futur":U THEN ASSIGN pFieldValue = RowObject.ind-entreg-futur.
        WHEN "ind-nota-propria":U THEN ASSIGN pFieldValue = RowObject.ind-nota-propria.
        &endif
        &if {&bf_dis_versao_ems} >= 2.04 &then
        WHEN "ind-situacao":U THEN ASSIGN pFieldValue = RowObject.ind-situacao.
        &endif
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "ind-venda-ambulante":U THEN ASSIGN pFieldValue = RowObject.ind-venda-ambulante.
        &endif
        WHEN "int-1":U THEN ASSIGN pFieldValue = RowObject.int-1.
        WHEN "int-2":U THEN ASSIGN pFieldValue = RowObject.int-2.
        &if defined (bf_mat_natur_compra_re) &then
        WHEN "tipo-compra":U THEN ASSIGN pFieldValue = RowObject.tipo-compra.
        &endif
        
        WHEN "tp-oper-terc":U THEN ASSIGN pFieldValue = RowObject.tp-oper-terc.
        WHEN "tp-rec-desp":U THEN ASSIGN pFieldValue = RowObject.tp-rec-desp.
        WHEN "uso":U THEN ASSIGN pFieldValue = RowObject.uso.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getKey DBOProgram 
PROCEDURE getKey :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valores dos campos do ¡ndice natureza
  Parameters:  
               retorna valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE OUTPUT PARAMETER pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
       RETURN "NOK":U.

    ASSIGN pnat-operacao = RowObject.nat-operacao.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getLogField DBOProgram 
PROCEDURE getLogField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo l¢gico
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS LOGICAL   NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "alt-vl-it-terc":U THEN ASSIGN pFieldValue = RowObject.alt-vl-it-terc.
        &endif
        &if defined(bf-mat-comex) &then            
            WHEN "merc-base-icms":U THEN ASSIGN pFieldValue = RowObject.merc-base-icms.
            WHEN "oper-terc":U THEN ASSIGN pFieldValue = RowObject.oper-terc.
            WHEN "preco-saida":U THEN ASSIGN pFieldValue = RowObject.preco-saida.
            WHEN "tipo":U THEN ASSIGN pFieldValue = RowObject.tipo.
        &else
            WHEN "auto-ct":U THEN ASSIGN pFieldValue = RowObject.auto-ct.
            WHEN "atual-estat":U THEN ASSIGN pFieldValue = RowObject.atual-estat.
            WHEN "baixa-ship":U THEN ASSIGN pFieldValue = RowObject.baixa-ship.
            WHEN "nota-rateio":U THEN ASSIGN pFieldValue = RowObject.nota-rateio.
        &endif

        
        WHEN "atualiza-of":U THEN ASSIGN pFieldValue = RowObject.atualiza-of.
        WHEN "auto-ce":U THEN ASSIGN pFieldValue = RowObject.auto-ce.
        WHEN "auto-cr":U THEN ASSIGN pFieldValue = RowObject.auto-cr.
        
        WHEN "auto-est":U THEN ASSIGN pFieldValue = RowObject.auto-est.
        WHEN "baixa-estoq":U THEN ASSIGN pFieldValue = RowObject.baixa-estoq.
        
        WHEN "calc-auto":U THEN ASSIGN pFieldValue = RowObject.calc-auto.
        WHEN "consum-final":U THEN ASSIGN pFieldValue = RowObject.consum-final.
        &if defined(bf_dis_ciap) &then
        WHEN "credito-ciap":U THEN ASSIGN pFieldValue = RowObject.credito-ciap.
        &endif
        WHEN "credito-subs":U THEN ASSIGN pFieldValue = RowObject.credito-subs.
        WHEN "emite-duplic":U THEN ASSIGN pFieldValue = RowObject.emite-duplic.
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "gera-prev-cr":U THEN ASSIGN pFieldValue = RowObject.gera-prev-cr.
        &endif
        WHEN "imp-nota":U THEN ASSIGN pFieldValue = RowObject.imp-nota.
        WHEN "ind-contabilizacao":U THEN ASSIGN pFieldValue = RowObject.ind-contabilizacao.
        WHEN "ind-entfut":U THEN ASSIGN pFieldValue = RowObject.ind-entfut.
        WHEN "ind-est-crz":U THEN ASSIGN pFieldValue = RowObject.ind-est-crz.
        WHEN "ind-est-mof":U THEN ASSIGN pFieldValue = RowObject.ind-est-mof.
        WHEN "ind-est-qtd":U THEN ASSIGN pFieldValue = RowObject.ind-est-qtd.
        WHEN "ind-gera-of":U THEN ASSIGN pFieldValue = RowObject.ind-gera-of.
        WHEN "ind-imprenda":U THEN ASSIGN pFieldValue = RowObject.ind-imprenda.
        WHEN "ind-it-icms":U THEN ASSIGN pFieldValue = RowObject.ind-it-icms.
        WHEN "ind-it-sub-dif":U THEN ASSIGN pFieldValue = RowObject.ind-it-sub-dif.
        WHEN "ind-tipo-vat":U THEN ASSIGN pFieldValue = RowObject.ind-tipo-vat.
        WHEN "ipi-icm-out":U THEN ASSIGN pFieldValue = RowObject.ipi-icm-out.
        WHEN "log-1":U THEN ASSIGN pFieldValue = RowObject.log-1.
        WHEN "log-2":U THEN ASSIGN pFieldValue = RowObject.log-2.
        &if defined(bf_dis_ciap) &then
        WHEN "log-acum-ciap":U THEN ASSIGN pFieldValue = RowObject.log-acum-ciap.
        &endif
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "log-atual-cotas":U THEN ASSIGN pFieldValue = RowObject.log-atual-cotas.
        WHEN "log-base-ipi":U THEN ASSIGN pFieldValue = RowObject.log-base-ipi.
        WHEN "log-biss":U THEN ASSIGN pFieldValue = RowObject.log-biss.
        WHEN "log-emit-remito":U THEN ASSIGN pFieldValue = RowObject.log-emit-remito.
        WHEN "log-frete-bipi":U THEN ASSIGN pFieldValue = RowObject.log-frete-bipi.
        WHEN "log-gera-cre-subst":U THEN ASSIGN pFieldValue = RowObject.log-gera-cre-subst.
        WHEN "log-icms-out-subst":U THEN ASSIGN pFieldValue = RowObject.log-icms-out-subst.
        WHEN "log-ipi-bicms":U THEN ASSIGN pFieldValue = RowObject.log-ipi-bicms.
        WHEN "log-ipi-out-bsubst":U THEN ASSIGN pFieldValue = RowObject.log-ipi-out-bsubst.
        WHEN "log-ipi-out-tot":U THEN ASSIGN pFieldValue = RowObject.log-ipi-out-tot.
        &endif
        &if defined (bf_dis_desc_bonif) &then
        WHEN "log-natureza-bonif":U THEN ASSIGN pFieldValue = RowObject.log-natureza-bonif.
        &endif
        &if '{&bf_dis_versao_ems}':U >= '2.071':U &then 
        WHEN "log-vda-ret":U THEN ASSIGN pFieldValue = RowObject.log-vda-ret. 
        &endif
        &if defined (bf_mat_oper_triangular) &then
        WHEN "log-oper-triang":U THEN ASSIGN pFieldValue = RowObject.log-oper-triang.
        &endif
        &if {&bf_dis_versao_ems} >= 2.03 &then
        WHEN "log-remito-gera-prevcr":U THEN ASSIGN pFieldValue = RowObject.log-remito-gera-prevcr.
        WHEN "log-ret-inss-fonte":U THEN ASSIGN pFieldValue = RowObject.log-ret-inss-fonte.
        WHEN "log-vl-it-terc":U THEN ASSIGN pFieldValue = RowObject.log-vl-it-terc.
        &endif
        WHEN "manut-icm":U THEN ASSIGN pFieldValue = RowObject.manut-icm.
        WHEN "manut-ipi":U THEN ASSIGN pFieldValue = RowObject.manut-ipi.
        WHEN "nat-ativa":U THEN ASSIGN pFieldValue = RowObject.nat-ativa.
        
        WHEN "subs-trib":U THEN ASSIGN pFieldValue = RowObject.subs-trib.
        WHEN "terceiros":U THEN ASSIGN pFieldValue = RowObject.terceiros.
        WHEN "transf":U THEN ASSIGN pFieldValue = RowObject.transf.
        WHEN "usa-nota-ent":U THEN ASSIGN pFieldValue = RowObject.usa-nota-ent.
        WHEN "usa-pick":U THEN ASSIGN pFieldValue = RowObject.usa-pick.
        WHEN "venda-ativo":U THEN ASSIGN pFieldValue = RowObject.venda-ativo.
        &if {&bf_dis_versao_ems} >= 2.062 &then
            WHEN "log-ipi-contrib-retid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-contrib-retid.
            WHEN "log-ipi-outras-contrib-retid":U THEN ASSIGN pFieldValue = RowObject.log-ipi-outras-contrib-retid.
        &endif
        WHEN "log-operac-transp":U THEN ASSIGN pFieldValue = RowObject.log-operac-transp.
        WHEN "log-ipi-suspen-icms":U THEN ASSIGN pFieldValue = RowObject.log-ipi-suspen-icms.
        WHEN "log-gera-ncredito":U THEN ASSIGN pFieldValue = RowObject.log-gera-ncredito.
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getRawField DBOProgram 
PROCEDURE getRawField :
/*------------------------------------------------------------------------------
  Purpose:     Retorna valor de campos do tipo raw
  Parameters:  
               recebe nome do campo
               retorna valor do campo
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT  PARAMETER pFieldName  AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAMETER pFieldValue AS RAW       NO-UNDO.

    /*--- Verifica se temptable RowObject est  dispon¡vel, caso nÆo esteja ser 
          retornada flag "NOK":U ---*/
    IF NOT AVAILABLE RowObject THEN 
        RETURN "NOK":U.

    CASE pFieldName:
        OTHERWISE RETURN "NOK":U.
    END CASE.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME


&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE getTipoCompra DBOProgram 
PROCEDURE getTipoCompra :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/

    define input  parameter pc-cod-cfop as char no-undo.
    define output parameter pi-tip-comp as int  no-undo.

    &if defined(bf_dis_formato_CFOP) &then
        find first cfop-natur where cfop-natur.cod-cfop = pc-cod-cfop no-lock no-error.
        if  avail cfop-natur then do:
            if      cfop-natur.idi-tip-cfop = 4 then assign pi-tip-comp = 5.
            else if cfop-natur.idi-tip-cfop = 5 then assign pi-tip-comp = 6.
            else if cfop-natur.idi-tip-cfop = 6 then assign pi-tip-comp = 4.
            else if cfop-natur.idi-tip-cfop = 7 then assign pi-tip-comp = 8.
            else pi-tip-comp = cfop-natur.idi-tip-cfop.
            return "OK":U.
        end.
    &else
        find first ped-curva
             where ped-curva.it-codigo = pc-cod-cfop
               and ped-curva.vl-aberto = 620 no-lock no-error.
        if  avail ped-curva then do:
            if      ped-curva.int-1 = 4 then assign pi-tip-comp = 5.
            else if ped-curva.int-1 = 5 then assign pi-tip-comp = 6.
            else if ped-curva.int-1 = 6 then assign pi-tip-comp = 4.
            else pi-tip-comp = ped-curva.int-1.
            return "OK":U.
        end.
    &endif
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE goToKey DBOProgram 
PROCEDURE goToKey :
/*------------------------------------------------------------------------------
  Purpose:     Reposiciona registro com base no ¡ndice natureza
  Parameters:  
               recebe valor do campo nat-operacao
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pnat-operacao LIKE natur-oper.nat-operacao NO-UNDO.

    FIND FIRST bfnatur-oper WHERE
        bfnatur-oper.nat-operacao = pnat-operacao NO-LOCK NO-ERROR.

    /*--- Verifica se registro foi encontrado, em caso de erro ser  retornada flag "NOK":U ---*/
    IF NOT AVAILABLE bfnatur-oper THEN 
        RETURN "NOK":U.

    /*--- Reposiciona query atrav‚s de rowid e verifica a ocorrˆncia de erros, caso
          existam erros ser  retornada flag "NOK":U ---*/
    RUN repositionRecord IN THIS-PROCEDURE (INPUT ROWID(bfnatur-oper)).
    IF RETURN-VALUE = "NOK":U THEN
        RETURN "NOK":U.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE inputUpdates DBOProgram 
PROCEDURE inputUpdates :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param p-atualizar-mensagem as log no-undo.

    assign l-atualizar-mensagem = p-atualizar-mensagem.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuery DBOProgram 
PROCEDURE openQuery :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input param i-abertura as int no-undo.

    case i-abertura:
        when 1 or when 2 then
               run openQueryStatic (input "RangePage1":U).
        when 3 then
               run openQueryStatic (input "RangePage2":U).
        when 4 then do:
               run openQueryStatic (input "RangePage2":U).
               run openQueryStatic (input "RangePage1":U).
        end.
        when 5 then do:
               run openQueryStatic (input "RangePage1":U).
               run openQueryStatic (input "RangePage2":U).
        end.
    end case.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryMain DBOProgram 
PROCEDURE openQueryMain :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

  open query qr{&tableName} for each {&tableName} no-lock
       indexed-reposition.
       
  return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage1 DBOProgram 
PROCEDURE openQueryRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nat-operacao >= cIniNatOperacao
           and {&tableName}.nat-operacao <= cEndNatOperacao no-lock 
           indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQueryRangePage2 DBOProgram 
PROCEDURE openQueryRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName}
         where {&tableName}.denominacao >= cIniDenominacao
           and {&tableName}.denominacao <= cEndDenominacao no-lock
           by {&tableName}.denominacao by {&tableName}.nat-operacao
           indexed-reposition.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacionPage1 DBOProgram 
PROCEDURE openQuerySituacionPage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    
    open query qr{&tableName} for each {&tableName}
         where {&tableName}.nat-operacao >= cIniNatOperacao
         and   {&tableName}.nat-operacao <= cEndNatOperacao
         and  (({&tableName}.nat-ativa  = yes and iNatAtiva = 1)
         or    ({&tableName}.nat-ativa  = no  and iNatAtiva = 1)
         or    ({&tableName}.nat-ativa  = yes and iNatAtiva = 2)
         or    ({&tableName}.nat-ativa  = no  and iNatAtiva = 3)) no-lock
         BY {&tableName}.nat-operacao INDEXED-REPOSITION.

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacionPage2 DBOProgram 
PROCEDURE openQuerySituacionPage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    open query qr{&tableName} for each {&tableName} NO-LOCK 
         where {&tableName}.denominacao >= cIniDenominacao
         and   {&tableName}.denominacao <= cEndDenominacao 
         and  (({&tableName}.nat-ativa = yes and iNatAtiva = 1)
          or   ({&tableName}.nat-ativa = no  and iNatAtiva = 1)
          or   ({&tableName}.nat-ativa = yes and iNatAtiva = 2)
          or   ({&tableName}.nat-ativa = no  and iNatAtiva = 3)) 
          by {&tableName}.denominacao
          by {&tableName}.nat-operacao INDEXED-REPOSITION.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE openQuerySituacionPage3 DBOProgram 
PROCEDURE openQuerySituacionPage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    open query qr{&tableName} for each {&tableName} no-lock  
           WHERE &if defined(bf_dis_formato_CFOP) &then
                     {&tableName}.cod-cfop = cIniCodCFOP 
                 &else
                     trim(substr({&tableName}.char-1,45,10)) = cIniCodCFOP 
                 &endif    
           and (({&tableName}.nat-ativa = yes and iNatAtiva = 1)
            or  ({&tableName}.nat-ativa = no  and iNatAtiva = 1)
            or  ({&tableName}.nat-ativa = yes and iNatAtiva = 2)
            or  ({&tableName}.nat-ativa = no  and iNatAtiva = 3)) 
            by {&tableName}.nat-operacao indexed-reposition.
    
    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE outputOperationTypeList DBOProgram 
PROCEDURE outputOperationTypeList :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param i-tipo-lista           as int  no-undo. /* (1)Combo-Box (2)Radio-Set */
    def output param c-lista-tipo-operacoes as char no-undo.

    if  i-tipo-lista = 1 then
        assign c-lista-tipo-operacoes =
               "Nenhum,Faturamento Antecipado,Remessa de Faturamento Antecipado,Faturamento com Entrega Futura,Remessa de Entrega Futura".
    if  i-tipo-lista = 2 then
        assign c-lista-tipo-operacoes =
               "Nenhum,1,Faturamento Antecipado,2,Remessa de Faturamento Antecipado,3,Faturamento com Entrega Futura,4,Remessa de Entrega Futura,5".

    return "OK".

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-integraRIxEMS DBOProgram 
PROCEDURE pi-integraRIxEMS :
/*------------------------------------------------------------------------------
  Purpose:
  Parameters:  <none>
  Notes:
------------------------------------------------------------------------------*/

    DEFINE OUTPUT PARAMETER p-integra-ems AS LOGICAL NO-UNDO.

    ASSIGN p-integra-ems = NO.

    ASSIGN p-integra-ems = {cdp/cd9870.i2 "EMS"}.
   
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE pi-validateNatOperCompl DBOProgram 
PROCEDURE pi-validateNatOperCompl :
/*------------------------------------------------------------------------------
  Purpose:     Validar a natureza complementar informada
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    DEFINE VARIABLE c-msg-help   AS CHARACTER NO-UNDO.
    
    /* --> Valida se a natureza complementar informada ‚ v lida... */
    IF  NOT CAN-FIND(FIRST bfnatur-oper WHERE bfnatur-oper.nat-operacao = RowObject.nat-comp) THEN DO:
        {method/svc/errors/inserr.i
                &ErrorNumber     = 53236 /* A natureza complementar informada ‚ inexistente */
                &ErrorType       = "EMS" /* Help: Verifique se a natureza complementar foi digitada corretamente.*/
                &ErrorSubType    = "ERROR"
                &ErrorParameters = "''"}.
        RETURN "NOK":U.
    END.
    /* --> */

    /* Se usa m£ltiplas naturezas realiza as valida‡Æoes da natureza complementar... */
    IF  l-mult-natur-receb THEN DO: /* Var def em cd9701.i */
    
        FIND FIRST bfnatur-oper WHERE bfnatur-oper.nat-operacao = RowObject.nat-comp NO-LOCK NO-ERROR.
        
        /* --> Valida‡Æo da natureza complementar informada em rela‡Æo … natureza de opera‡Æo. */
        IF  Rowobject.tipo = 2 THEN DO: /* Se ‚ natureza de sa¡da... */ 
            
            IF  RowObject.transf AND NOT bfnatur-oper.transf THEN DO:
                /* Se ‚ natureza de transferˆncia e a complementar nÆo ‚ tranferˆncia... */
                /* Para natureza de sa¡da para transferˆncia somente pode ter como complementar uma natureza de entrada de transferˆncia... */
                {method/svc/errors/inserr.i 
                        &ErrorNumber     = 53237 /* A natureza complementar dever  ser de transferˆncia */
                        &ErrorType       = "EMS" /* Help: Naturezas de sa¡da para transferˆncia somente poderÆo ter como complementar uma natureza de entrada de transferˆncia. */
                        &ErrorSubType    = "ERROR"
                        &ErrorParameters = "''"}.
            END.
            
            IF  RowObject.terceiros AND NOT bfnatur-oper.terceiros THEN DO:
                /* Se ‚ natureza que movimenta terceiros e a complementar nÆo movimenta terceiros... */
                /* Para natureza de sa¡da que movimente terceiros somente pode ter com complementar uma natureza de entrada que movimente terceiros... */
                {method/svc/errors/inserr.i
                        &ErrorNumber     = 53238 /* A natureza complementar dever  movimentar terceiros */ 
                        &ErrorType       = "EMS" /* Help: Naturezas de sa¡da que movimentem terceiros somente poderÆo ter como complementar uma natureza de entrada que movimente terceiros. */
                        &ErrorSubType    = "ERROR"
                        &ErrorParameters = "''" }.
            END.
        END.
        /* --> */    
        
        /* --> Valida‡äes entre naturezas de sa¡da dentro/fora do estado e exporta‡Æo e sua complementar.*/
        IF SUBSTRING(RowObject.char-1,172,1) <> "1" THEN DO: /* NÆo validar para Ind por encomenda*/

            IF  RowObject.nat-operacao BEGINS "5"                /* Se a natureza ‚ de sa¡da dentro do estado */
                AND NOT (RowObject.nat-comp BEGINS "1") THEN DO: /* e a complementar nÆo ‚ de entrada dentro do estado */
                {utp/ut-liter.i Uma_natureza_de_sa¡da_para_dentro_do_estado_somente_pode_ter_uma_complementar_de_entrada_dentro_do_estado. *}
                ASSIGN c-msg-help = RETURN-VALUE.
                {method/svc/errors/inserr.i 
                        &ErrorNumber     = 53239 /* A natureza complementar nÆo est  em concordƒncia */
                        &ErrorType       = "EMS"
                        &ErrorSubType    = "ERROR"
                        &ErrorParameters = "c-msg-help"}.
            END.
        
                        ELSE IF RowObject.nat-operacao BEGINS "7"            /* Se a natureza ‚ de sa¡da exporta‡Æo */
                                AND NOT (RowObject.nat-comp BEGINS "3") THEN DO: /* e a complementar nÆo ‚ de entrada exporta‡Æo */ 
                                {utp/ut-liter.i Uma_natureza_de_sa¡da_exporta‡Æo_somente_pode_ter_uma_complementar_de_entrada_importa‡Æo. *}
                                ASSIGN c-msg-help = RETURN-VALUE.
                                {method/svc/errors/inserr.i 
                                                &ErrorNumber     = 53239 /* A natureza complementar nÆo est  em concordƒncia */
                                                &ErrorType       = "EMS"
                                                &ErrorSubType    = "ERROR"
                                                &ErrorParameters = "c-msg-help"}.
    
                        END.
                        ELSE IF RowObject.nat-operacao BEGINS "6"            /* Se a natureza ‚ de sa¡da fora do estado */
                                AND NOT (RowObject.nat-comp BEGINS "2") THEN DO: /* e a complementar nÆo ‚ de entrada fora do estado */
                                {utp/ut-liter.i Uma_natureza_de_sa¡da_para_fora_do_estado_somente_pode_ter_uma_complementar_de_entrada_fora_do_estado. *}
                                ASSIGN c-msg-help = RETURN-VALUE.
                                {method/svc/errors/inserr.i 
                                                &ErrorNumber     = 53239 /* A natureza complementar nÆo est  em concordƒncia */
                                                &ErrorType       = "EMS"
                                                &ErrorSubType    = "ERROR"
                                                &ErrorParameters = "c-msg-help"}.
                        END.
                END.
        /* --> */
        
    END. /* END IF l-mult-natur-receb */

    RETURN "OK":U.
    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE piIntegracao DBOProgram 
PROCEDURE piIntegracao :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.

    DEFINE VARIABLE h-ut-integration AS HANDLE NO-UNDO.

    RUN utp/ut-integration.p PERSISTENT SET h-ut-integration.
    RUN eai-integration IN h-ut-integration (INPUT "TransactionTypes",       /* Nome da transa‡Æo     */
                                                                                 INPUT ROWID(b-natur-oper),      /* Registro da transa‡Æo */
                                                                                 INPUT pType,                    /* Evento da transa‡Æo   */
                                                                                 OUTPUT TABLE RowErrors APPEND). /* Erros da transa‡Æo    */ 
    DELETE PROCEDURE h-ut-integration.
    ASSIGN h-ut-integration = ?.
    
    IF CAN-FIND (FIRST RowErrors 
                 WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
       RETURN "NOK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTipo DBOProgram 
PROCEDURE returnTipo :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-chave as rowid no-undo.
    def output param p-tipo  as char  no-undo.
    
    run repositionRecord(input p-chave).

    &if defined(bf-mat-comex) &then            
        IF RowObject.tipo = YES THEN
            p-tipo = "Entrada".
        IF Rowobject.tipo = NO THEN
            p-tipo = "Sa¡da".
    &else
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao001 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao001 = {ininc/i06in245.i 04 rowObject.tipo}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao001)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  p-tipo = RETURN-VALUE.
        &else
            ASSIGN p-tipo = {ininc/i06in245.i 04 rowObject.tipo}.
        &endif
    &endif
    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTribicm DBOProgram 
PROCEDURE returnTribicm :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-chave   as rowid no-undo.
    def output param p-tribicm as char  no-undo.
    
    run repositionRecord(input p-chave).
    
    &if defined(bf-mat-comex) &then            
       IF rowObject.cd-trib-icm = "T" THEN
           ASSIGN p-tribicm = "Tribut".
       IF rowObject.cd-trib-icm = "I" THEN
           ASSIGN p-tribicm = "Isen".
       IF rowObject.cd-trib-icm = "O" THEN
           ASSIGN p-tribicm = "Outros".
       IF rowObject.cd-trib-icm = "R" THEN
           ASSIGN p-tribicm = "Reduz".
       IF rowObject.cd-trib-icm = "V" THEN
           ASSIGN p-tribicm = "Trib p/ Brindes".
       IF rowObject.cd-trib-icm = "F" THEN
           ASSIGN p-tribicm = "Financiam".
    &else
    
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao002 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao002 = {ininc/i01in245.i 04 rowObject.cd-trib-icm}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao002)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  p-tribicm = RETURN-VALUE.
        &else
            ASSIGN p-tribicm = {ininc/i01in245.i 04 rowObject.cd-trib-icm}.
        &endif
    &endif
    
        
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE returnTribipi DBOProgram 
PROCEDURE returnTribipi :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input  param p-chave   as rowid no-undo.
    def output param p-tribipi as char  no-undo.
    
    run repositionRecord(input p-chave).
    
    &if defined(bf-mat-comex) &then            
        IF Rowobject.cd-trib-ipi = "T" THEN
            ASSIGN p-tribipi = "Tributa‡Æo".
        IF Rowobject.cd-trib-ipi = "I" THEN
            ASSIGN p-tribipi = "Isento".
        IF Rowobject.cd-trib-ipi = "O" THEN
            ASSIGN p-tribipi = "Outros".
        IF Rowobject.cd-trib-ipi = "R" THEN
            ASSIGN p-tribipi = "Reduzido".
    &else
        &if "{&FNC_MULTI_IDIOMA}" = "Yes" &then
            DEFINE VARIABLE cAuxTraducao003 AS CHARACTER NO-UNDO.
            ASSIGN cAuxTraducao003 = {ininc/i10in172.i 04 rowObject.cd-trib-ipi}.
            run utp/ut-liter.p (INPUT REPLACE(TRIM(cAuxTraducao003)," ","_"),
                                INPUT "",
                                INPUT "").
            ASSIGN  p-tribipi = RETURN-VALUE.
        &else
            ASSIGN p-tribipi = {ininc/i10in172.i 04 rowObject.cd-trib-ipi}.
        &endif
    &endif    
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE set-tt-natur-operac-internac DBOProgram 
PROCEDURE set-tt-natur-operac-internac :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM TABLE FOR tt-natur-operac-internac.

    
    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setClasseFiscal DBOProgram 
PROCEDURE setClasseFiscal :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-cod-clas-fisc as char no-undo.

    assign c-cod-clas-fisc = p-cod-clas-fisc.

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint1 DBOProgram 
PROCEDURE setConstraint1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-nat-ini as char no-undo.

    run setConstraintRangePage1(input p-nat-ini,
                                input "zzzzzz":U).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraint2 DBOProgram 
PROCEDURE setConstraint2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

    def input parameter p-nat-inicial as char no-undo.
    def input parameter p-nat-final   as char no-undo.
    def input parameter p-denom-ini   as char no-undo.
    def input parameter p-denom-fim   as char no-undo.

    run setConstraintRangePage1(input p-nat-inicial,
                                input p-nat-final).
    run setConstraintRangePage2(input p-denom-ini,
                                input p-denom-fim).

    return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage1 DBOProgram 
PROCEDURE setConstraintRangePage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNatOperacao as char no-undo.
def input param pcEndNatOperacao as char no-undo.

    assign cIniNatOperacao = pcIniNatOperacao
           cEndNatOperacao = pcEndNatOperacao.          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintRangePage2 DBOProgram 
PROCEDURE setConstraintRangePage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/

def input param pcIniDenominacao as char no-undo.
def input param pcEndDenominacao as char no-undo.

    assign cIniDenominacao = pcIniDenominacao
           cEndDenominacao = pcEndDenominacao.           

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacionPage1 DBOProgram 
PROCEDURE setConstraintSituacionPage1 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniNatOperacao as char no-undo.
def input param pcEndNatOperacao as char no-undo.
def input param piNatAtiva       as int  no-undo.

    assign cIniNatOperacao = pcIniNatOperacao
           cEndNatOperacao = pcEndNatOperacao
           iNatAtiva       = piNatAtiva.          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacionPage2 DBOProgram 
PROCEDURE setConstraintSituacionPage2 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniDenominacao as char no-undo.
def input param pcEndDenominacao as char no-undo.
def input param piNatAtiva       as int  no-undo.

    assign cIniDenominacao = pcIniDenominacao
           cEndDenominacao = pcEndDenominacao
           iNatAtiva       = piNatAtiva.                          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE setConstraintSituacionPage3 DBOProgram 
PROCEDURE setConstraintSituacionPage3 :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
def input param pcIniCodCFOP as char no-undo.
def input param piNatAtiva   as int  no-undo.

    assign cIniCodCFOP     = pcIniCodCFOP
           iNatAtiva       = piNatAtiva.                          

   return "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE ValidateExport DBOProgram 
PROCEDURE ValidateExport :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEF INPUT PARAM pd-dt-cfop       AS DATE NO-UNDO.
    DEF INPUT PARAM pd-dt-ini-export AS DATE NO-UNDO.
    DEF INPUT PARAM pd-dt-fim-export AS DATE NO-UNDO.

    RUN emptyRowErrors IN THIS-PROCEDURE.

    IF  pd-dt-ini-export < pd-dt-cfop THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-a-data-inicial-noo-pode-ser-me AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_data_inicial_nÆo_pode_ser_menor_que" *}
        ASSIGN c-lbl-liter-a-data-inicial-noo-pode-ser-me = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                                &ErrorNumber="25997"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-a-data-inicial-noo-pode-ser-me + ' ' + STRING(pd-dt-cfop)"}
    END.

    IF  pd-dt-fim-export < pd-dt-ini-export THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-a-data-final-noo-pode-ser-meno AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "A_data_final_nÆo_pode_ser_menor_que_a_data_inicial" *}
        ASSIGN c-lbl-liter-a-data-final-noo-pode-ser-meno = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                        &ErrorNumber="25997"
                        &ErrorType="EMS"
                        &ErrorSubType="ERROR"
                        &ErrorParameters="c-lbl-liter-a-data-final-noo-pode-ser-meno"}
    END.

    IF  CAN-FIND(FIRST param-of 
                 WHERE param-of.dt-congela >= pd-dt-ini-export) THEN DO:
        /* Inicio -- Projeto Internacional */
        DEFINE VARIABLE c-lbl-liter-data-inicial AS CHARACTER NO-UNDO.
        {utp/ut-liter.i "Data_Inicial" *}
        ASSIGN c-lbl-liter-data-inicial = TRIM(RETURN-VALUE).
        {method/svc/errors/inserr.i
                                &ErrorNumber="16476"
                                &ErrorType="EMS"
                                &ErrorSubType="ERROR"
                                &ErrorParameters="c-lbl-liter-data-inicial"}
    END.

    RETURN (IF  CAN-FIND(FIRST RowErrors 
                         WHERE RowErrors.ErrorSubType = "Error":U) THEN "NOK":U
            ELSE "OK":U).
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateRecord DBOProgram 
PROCEDURE validateRecord :
/*------------------------------------------------------------------------------
  Purpose:     Valida‡äes pertinentes ao DBO
  Parameters:  recebe o tipo de valida‡Æo (Create, Delete, Update)
  Notes:       
------------------------------------------------------------------------------*/
    
    DEFINE INPUT PARAMETER pType AS CHARACTER NO-UNDO.
    
    /*--- Utilize o parƒmetro pType para identificar quais as valida‡äes a serem
          executadas ---*/
    /*--- Os valores poss¡veis para o parƒmetro sÆo: Create, Delete e Update ---*/
    /*--- Devem ser tratados erros PROGRESS e erros do Produto, atrav‚s do 
          include: method/svc/errors/inserr.i ---*/
    /*--- Inclua aqui as valida‡äes ---*/    

    run inbo/boin245val.p persistent set h-boin245val.    

    if  pType = "Delete" THEN
        run validateDelete in h-boin245val(input  table RowObject,
                                           output table RowErrors).
    ELSE DO:
        /* CHAMADA EPC - GRENDENE - Validar natureza complementar */
        /* Elimina natureza complementar digitada se natur-oper.nat-operacao for de transferˆncia */
        /* A natureza complementar ‚ gravada no campo char_3 da tabela gr_tab_geral e recuperada */
        /* na chamada abaixo (afterCreateUpdateRecord) */
        {method/svc/custom/custom.i &Event = "BeforeCreateUpdateRecord"}

        /* Executa getRecord pois a temp-table pode ter sido modificada na epc */        
        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE RowObject).
        FIND FIRST RowObject NO-ERROR.

        run validateCreateUpdate in h-boin245val(input  table RowObject,
                                                 input  pType,
                                                 output table RowErrors).

        /* CHAMADA EPC - GRENDENE - Validar natureza complementar */
        {method/svc/custom/custom.i &Event = "AfterCreateUpdateRecord"}

        /* Executa getRecord pois a temp-table pode ter sido modificada na epc */        
        RUN getRecord IN THIS-PROCEDURE (OUTPUT TABLE RowObject).
        FIND FIRST RowObject NO-ERROR.
    END.

    IF pType = "Update" THEN DO:

        FIND FIRST bfnatur-oper WHERE 
                   bfnatur-oper.nat-operacao = RowObject.nat-operacao NO-LOCK NO-ERROR.

        IF  AVAIL bfnatur-oper
        AND SUBSTRING(bfnatur-oper.char-1,1,5) <> "" THEN
        IF AVAIL bfnatur-oper 
            AND bfnatur-oper.idi-escrit-fatur-remes <> RowObject.idi-escrit-fatur-remes 
                OR (bfnatur-oper.ind-entfut             <> RowObject.ind-entfut  OR
                    bfnatur-oper.ind-est-qtd            <> RowObject.ind-est-qtd OR
                    SUBSTRING(bfnatur-oper.char-1,1,5)  <> SUBSTRING(RowObject.char-1,1,5)) THEN DO:

            IF CAN-FIND (FIRST ped-venda
                         WHERE ped-venda.nat-operacao = bfnatur-oper.nat-operacao) THEN DO:


                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nao-e-possivel-alterar-o-tipo AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_‚_poss¡vel_alterar_o_Tipo_de_Escritura‡Æo_ou_Opera‡Æo_de_Entrega_Futura/Faturamento_Antecipado_pois_esta_natureza_j _possui_relacionamentos_com_Pedidos_de_Venda" *}
                ASSIGN c-lbl-liter-nao-e-possivel-alterar-o-tipo = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-nao-e-possivel-alterar-o-tip AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-nao-e-possivel-alterar-o-tip = c-lbl-liter-nao-e-possivel-alterar-o-tipo + '.' + '~~~~' + 
                                                                c-lbl-liter-nao-e-possivel-alterar-o-tipo + '.'.
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = "c-lbl-inserr-nao-e-possivel-alterar-o-tip"}

            END.

            IF CAN-FIND (FIRST docum-est
                         WHERE docum-est.nat-operacao = bfnatur-oper.nat-operacao) THEN DO:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nao-e-possivel-alterar-o-tipo-2 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_‚_poss¡vel_alterar_o_Tipo_de_Escritura‡Æo_ou_Opera‡Æo_de_Entrega_Futura/Faturamento_Antecipado_pois_esta_natureza_j _possui_relacionamentos_com_Nota_Fiscal_de_Entrada" *}
                ASSIGN c-lbl-liter-nao-e-possivel-alterar-o-tipo-2 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-nao-e-possivel-alterar-o-tip-2 AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-nao-e-possivel-alterar-o-tip-2 = c-lbl-liter-nao-e-possivel-alterar-o-tipo-2 + '.' + '~~~~' + 
                                                                c-lbl-liter-nao-e-possivel-alterar-o-tipo-2 + '.'.
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = "c-lbl-inserr-nao-e-possivel-alterar-o-tip-2"}

            END.

            IF CAN-FIND (FIRST nota-fiscal
                         WHERE nota-fiscal.nat-operacao = bfnatur-oper.nat-operacao) THEN DO:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nao-e-possivel-alterar-o-tipo-3 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_‚_poss¡vel_alterar_o_Tipo_de_Escritura‡Æo_ou_Opera‡Æo_de_Entrega_Futura/Faturamento_Antecipado_pois_esta_natureza_j _possui_relacionamentos_com_Nota_Fiscal_de_Sa¡da" *}
                ASSIGN c-lbl-liter-nao-e-possivel-alterar-o-tipo-3 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-nao-e-possivel-alterar-o-tip-3 AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-nao-e-possivel-alterar-o-tip-3 = c-lbl-liter-nao-e-possivel-alterar-o-tipo-3 + '.' + '~~~~' + 
                                                                c-lbl-liter-nao-e-possivel-alterar-o-tipo-3 + '.'.
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = "c-lbl-inserr-nao-e-possivel-alterar-o-tip-3"}

            END.

            IF CAN-FIND (FIRST saldo-terc
                         WHERE saldo-terc.nat-operacao = bfnatur-oper.nat-operacao) THEN DO:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-nao-e-possivel-alterar-o-tipo-4 AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "NÆo_‚_poss¡vel_alterar_o_Tipo_de_Escritura‡Æo_ou_Opera‡Æo_de_Entrega_Futura/Faturamento_Antecipado_pois_esta_natureza_j _possui_relacionamentos_com_Saldo_em_Poder_de_Terceiros" *}
                ASSIGN c-lbl-liter-nao-e-possivel-alterar-o-tipo-4 = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-nao-e-possivel-alterar-o-tip-4 AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-nao-e-possivel-alterar-o-tip-4 = c-lbl-liter-nao-e-possivel-alterar-o-tipo-4 + '.' + '~~~~' + 
                                                                c-lbl-liter-nao-e-possivel-alterar-o-tipo-4 + '.'.
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = "c-lbl-inserr-nao-e-possivel-alterar-o-tip-4"}

                END.
            END.

        END.
    
    IF  pType = "CREATE" OR 
        pType = "Update" THEN DO:

        IF RowObject.tipo = 1 AND 
          (RowObject.especie-doc = "NFE" OR RowObject.especie-doc = "NFD") THEN DO:

            /*--- identifica se a natureza do docum-est eh fatura faturamento antecipado, 
            remessa faturamento antecipado, fatura ent futura ou remessa ent futura ---*/    
            {cdp/cd9700.i1 RowObject}

            /* Se for natureza de Faturamento Antecipado ou Faturamento com Entrega Futura n’o pode estar marcada a opera»’o com terceiros */
            IF (l-fatura-fat-antecip OR l-fatura-ent-futura) AND RowObject.especie-doc = "NFE" AND             
               RowObject.terceiros THEN DO:
    
                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-natureza-para-faturamento-ante AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_para_Faturamento_Antecipado_ou_Faturamento_com_Entrega_Futura_nÆo_deve_ser_de_Opera‡Æo_com_Terceiros" *}
                ASSIGN c-lbl-liter-natureza-para-faturamento-ante = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-natureza-para-faturamento-an AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-natureza-para-faturamento-an = c-lbl-liter-natureza-para-faturamento-ante + '.' + '~~~~' + 
                                                                c-lbl-liter-natureza-para-faturamento-ante + '.'.
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = "c-lbl-inserr-natureza-para-faturamento-an"}                
    
            END. 
            
                        /* Se for natureza de Remessa de Entrega Futura ou de Remessa de Faturamento Antecipado o PIS e a COFINS devem ficar como 'isentos' */
                        IF (l-remessa-ent-futura) AND RowObject.especie-doc = "NFE" AND
                           (substr(RowObject.char-1,86,1) <> "2" OR substr(RowObject.char-1,87,1) <> "2") THEN DO:                                
                 
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-natureza-de-remessa-de-entrega AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Natureza_de_Remessa_de_Entrega_Futura_deve_ter_PIS_e_COFINS_com_Tributa‡Æo_isenta" *}
                                ASSIGN c-lbl-liter-natureza-de-remessa-de-entrega = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-inserr-natureza-de-remessa-de-entre AS CHARACTER NO-UNDO.
                                ASSIGN c-lbl-inserr-natureza-de-remessa-de-entre = c-lbl-liter-natureza-de-remessa-de-entrega + '.' + '~~~~' + 
                                                                                                                                c-lbl-liter-natureza-de-remessa-de-entrega + '.'.
                                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                                                        &ErrorType       = "EMS"
                                                                                        &ErrorSubType    = "ERROR"
                                                                                        &ErrorParameters = "c-lbl-inserr-natureza-de-remessa-de-entre"}      
                                                                 

                        END.
                        
            IF l-remessa-ent-futura AND RowObject.especie-doc = "NFE" AND 
               NOT RowObject.terceiros THEN DO:

                /* Inicio -- Projeto Internacional */
                DEFINE VARIABLE c-lbl-liter-natureza-para-remessa-entrega AS CHARACTER NO-UNDO.
                {utp/ut-liter.i "Natureza_para_Remessa_Entrega_Futura_precisa_ser_opera‡Æo_com_terceiros" *}
                ASSIGN c-lbl-liter-natureza-para-remessa-entrega = TRIM(RETURN-VALUE).
                DEFINE VARIABLE c-lbl-inserr-natureza-para-remessa-entreg AS CHARACTER NO-UNDO.
                ASSIGN c-lbl-inserr-natureza-para-remessa-entreg = c-lbl-liter-natureza-para-remessa-entrega + '~~~~' + 
                                                                c-lbl-liter-natureza-para-remessa-entrega.
                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                            &ErrorType       = "EMS"
                                            &ErrorSubType    = "ERROR"
                                            &ErrorParameters = "c-lbl-inserr-natureza-para-remessa-entreg"}                

            END.

                    
            IF l-fatura-ent-futura THEN DO:
                IF RowObject.nat-comp = "" THEN DO:
                    /* Inicio -- Projeto Internacional */
                    DEFINE VARIABLE c-lbl-liter-entrada-de-entrega-futura-prec AS CHARACTER NO-UNDO.
                    {utp/ut-liter.i "Entrada_de_Entrega_Futura_precisa_natureza_complementar_do_tipo_Sa¡da,_Opera‡Æo_com_Terceiros_e_Remessa_Beneficiamento" *}
                    ASSIGN c-lbl-liter-entrada-de-entrega-futura-prec = TRIM(RETURN-VALUE).
                    DEFINE VARIABLE c-lbl-inserr-entrada-de-entrega-futura-pr AS CHARACTER NO-UNDO.
                    ASSIGN c-lbl-inserr-entrada-de-entrega-futura-pr = c-lbl-liter-entrada-de-entrega-futura-prec + '~~~~' + 
                                                                    c-lbl-liter-entrada-de-entrega-futura-prec.
                    {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                &ErrorType       = "EMS"
                                                &ErrorSubType    = "ERROR"
                                                &ErrorParameters = "c-lbl-inserr-entrada-de-entrega-futura-pr"}                
                END.
                ELSE DO:
                    FOR FIRST bfnatur-oper NO-LOCK
                        WHERE bfnatur-oper.nat-operacao = RowObject.nat-comp : END.                                                    

                    IF NOT AVAIL bfnatur-oper THEN DO:
                        /* Inicio -- Projeto Internacional */
                        DEFINE VARIABLE c-lbl-liter-entrada-de-entrega-futura-prec-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "Entrada_de_Entrega_Futura_precisa_natureza_complementar_do_tipo_Sa¡da,_Opera‡Æo_com_Terceiros_e_Remessa_Beneficiamento" *}
                        ASSIGN c-lbl-liter-entrada-de-entrega-futura-prec-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-entrada-de-entrega-futura-pr-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-entrada-de-entrega-futura-pr-2 = c-lbl-liter-entrada-de-entrega-futura-prec-2 + '~~~~' + 
                                                                        c-lbl-liter-entrada-de-entrega-futura-prec-2.
                        {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = "c-lbl-inserr-entrada-de-entrega-futura-pr-2"}                
                    END.
                    ELSE DO:                     
                                                /*Se for nota de devolucao cliente, especie NFD e for uma devolucao de entrega 
                                                  futura o tipo de operacao de terceiros tem que ser de retorno beneficiamento */                                       
                                                IF  RowObject.tipo-compra = 3
                                                AND RowObject.especie-doc = "NFD":U
                                                AND (SUBSTRING(RowObject.char-1,1,5) = ""
                                                OR  SUBSTRING(RowObject.char-1,1,5) = "0")
                                                AND ((RowObject.tipo = 1 and bfnatur-oper.tipo = 2)       
                                                OR  (RowObject.tipo = 2 and bfnatur-oper.tipo = 1))
                                                AND bfnatur-oper.terceiros THEN DO:                                                             
                                                        if bfnatur-oper.tp-oper-terc <> 2 then do:
                                DEFINE VARIABLE c-lbl-liter-entrada-de-entrega-futura-prec-3 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Entrada_de_Devolu‡Æo_de_Entrega_Futura_precisa_natureza_complementar_do_tipo_Sa¡da,_Opera‡Æo_com_Terceiros_e_Retorno_Beneficiamento" *}
                                ASSIGN c-lbl-liter-entrada-de-entrega-futura-prec-3 = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-inserr-entrada-de-entrega-futura-pr-3 AS CHARACTER NO-UNDO.
                                ASSIGN c-lbl-inserr-entrada-de-entrega-futura-pr-3 = c-lbl-liter-entrada-de-entrega-futura-prec-3 + '~~~~' + 
                                                                                c-lbl-liter-entrada-de-entrega-futura-prec-3. 
                                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                            &ErrorType       = "EMS"
                                                            &ErrorSubType    = "ERROR"
                                                            &ErrorParameters = "c-lbl-inserr-entrada-de-entrega-futura-pr-3"} 
                                                        end.
                                                END.
                                                ELSE DO:                            
                            IF RowObject.especie-doc = "NFD" 
                            AND bfnatur-oper.tp-oper-terc <> 2 THEN /* Devolu‡Æo de fatura entrega futura deve ter complementar do tipo retorno beneficiamento */
                                                               
                                                                  /*Natureza Complementar Inválida para Operação Entrega Futura.*/ 
                                                                  {method/svc/errors/inserr.i &ErrorNumber     = 53994    
                                                                                                                          &ErrorType       = "EMS"
                                                                                                                          &ErrorSubType    = "ERROR"
                                                                                                                          &ErrorParameters = " "} 
                            ELSE
                            IF  RowObject.especie-doc <> "NFD" 
                                                        AND (bfnatur-oper.tipo    <> 2    
                                                        OR  NOT bfnatur-oper.terceiros 
                                                        OR  bfnatur-oper.tp-oper-terc <> 1) THEN DO:
                                /* Inicio -- Projeto Internacional */
                                DEFINE VARIABLE c-lbl-liter-entrada-de-entrega-futura-prec-4 AS CHARACTER NO-UNDO.
                                {utp/ut-liter.i "Entrada_de_Entrega_Futura_precisa_natureza_complementar_do_tipo_Sa¡da,_Opera‡Æo_com_Terceiros_e_Remessa_Beneficiamento" *}
                                ASSIGN c-lbl-liter-entrada-de-entrega-futura-prec-4 = TRIM(RETURN-VALUE).
                                DEFINE VARIABLE c-lbl-inserr-entrada-de-entrega-futura-pr-4 AS CHARACTER NO-UNDO.
                                ASSIGN c-lbl-inserr-entrada-de-entrega-futura-pr-4 = c-lbl-liter-entrada-de-entrega-futura-prec-4 + '~~~~' + 
                                                                                c-lbl-liter-entrada-de-entrega-futura-prec-4.
                                {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                            &ErrorType       = "EMS"
                                                            &ErrorSubType    = "ERROR"
                                                            &ErrorParameters = "c-lbl-inserr-entrada-de-entrega-futura-pr-4"} 
                                                        END.
                                                END.                                                    
                    END.    
                END.
            END.    
        END.
        IF  l-funcao-spp-ent-fut THEN DO:

            FIND FIRST para-ped NO-LOCK NO-ERROR.
            IF  AVAIL para-ped  
                &if '{&bf_dis_versao_ems}' >= '2.071' &THEN
                AND para-ped.Log-aloca-autom-ref = YES
                &else
                AND SUBSTR(para-ped.Char-1,19,1)  = "y" 
                &ENDIF THEN DO:
                
                &if '{&bf_dis_versao_ems}' <= '2.07'&THEN DO:
                    IF  (INT(substr(rowobject.char-1,1,5)) = 0   AND 
                                    rowobject.ind-entfut   = YES AND 
                                    rowobject.ind-est-qtd  = NO) AND          /*faturamento entrega futura*/
                             substr(RowObject.char-2,125,6) = "" THEN 
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-de-remes AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_opera‡Æo_de_Remessa_de_Entrega_Futura_deve_ser_informada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-de-remes = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-de-rem AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-de-rem = c-lbl-liter-a-natureza-de-operaoo-de-remes + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-de-rem'}
                        END. 
                END.
                &else DO:
                    IF  (INT(substr(rowobject.char-1,1,5))   = 0   AND 
                                    rowobject.ind-entfut     = YES AND 
                                    rowobject.ind-est-qtd    = NO) AND          /*faturamento entrega futura*/
                          /* substr(RowObject.cod-natur-ref) = ""*/
                                    RowObject.cod-natur-ref = ""  THEN 
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-de-remes-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_opera‡Æo_de_Remessa_de_Entrega_Futura_deve_ser_informada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-de-remes-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-de-rem-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-de-rem-2 = c-lbl-liter-a-natureza-de-operaoo-de-remes-2 + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                  &ErrorType       = "EMS"
                                                  &ErrorSubType    = "ERROR"
                                                  &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-de-rem-2'}
                        END. 
                END.  
                &ENDif
            END.
        
            &if '{&bf_dis_versao_ems}' <= '2.07'&THEN DO:
                IF  substr(RowObject.char-2,125,6) <> "" THEN DO:
                    FIND bfnatur-oper WHERE 
                         bfnatur-oper.nat-operacao = substr(RowObject.char-2,125,6) NO-LOCK NO-ERROR.
                    IF  AVAIL bfnatur-oper  THEN DO:
                        IF  NOT( INT(substr(bfnatur-oper.char-1,1,5))  = 0    AND 
                                            bfnatur-oper.ind-entfut    = NO   AND
                                            bfnatur-oper.ind-est-qtd   = yes) THEN 
    
                            /* Inicio -- Projeto Internacional */
                            DO:
                            DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-deve-ser AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "A_natureza_de_opera‡Æo_deve_ser_de_remessa_de_entrega_futura" *}
                            ASSIGN c-lbl-liter-a-natureza-de-operaoo-deve-ser = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                     &ErrorType       = "EMS"
                                                     &ErrorSubType    = "ERROR"
                                                     &ErrorParameters = 'c-lbl-liter-a-natureza-de-operaoo-deve-ser'}
                            END. 
    
                    END.
                    ELSE
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-noo-est AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_opera‡Æo_nÆo_est _cadastrada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-noo-est = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-noo-es AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-noo-es = c-lbl-liter-a-natureza-de-operaoo-noo-est + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-noo-es'}
                        END. 
                                                    
                END.
            END.
            &ELSE DO:
              /* IF  substr(RowObject.cod-natur-ref) <> "" THEN DO: */
                 IF  RowObject.cod-natur-ref <> "" THEN DO:
                    FIND bfnatur-oper WHERE 
                         bfnatur-oper.nat-operacao = RowObject.cod-natur-ref NO-LOCK NO-ERROR.
                    IF  AVAIL bfnatur-oper  THEN DO:
                        IF  NOT( INT(substr(bfnatur-oper.char-1,1,5)) = 0    AND 
                                            bfnatur-oper.ind-entfut   = no   AND
                                            bfnatur-oper.ind-est-qtd  = yes) THEN 
                            /* Inicio -- Projeto Internacional */
                            DO:
                            DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-deve-ser-2 AS CHARACTER NO-UNDO.
                            {utp/ut-liter.i "A_natureza_de_opera‡Æo_deve_ser_de_remessa_de_entrega_futura" *}
                            ASSIGN c-lbl-liter-a-natureza-de-operaoo-deve-ser-2 = TRIM(RETURN-VALUE).
                            {method/svc/errors/inserr.i &ErrorNumber     = 17006
                                                        &ErrorType       = "EMS"
                                                        &ErrorSubType    = "ERROR"
                                                        &ErrorParameters = 'c-lbl-liter-a-natureza-de-operaoo-deve-ser-2'}
                            END. 
                    END.
                    ELSE
                        /* Inicio -- Projeto Internacional */
                        DO:
                        DEFINE VARIABLE c-lbl-liter-a-natureza-de-operaoo-noo-est-2 AS CHARACTER NO-UNDO.
                        {utp/ut-liter.i "A_natureza_de_opera‡Æo_nÆo_est _cadastrada" *}
                        ASSIGN c-lbl-liter-a-natureza-de-operaoo-noo-est-2 = TRIM(RETURN-VALUE).
                        DEFINE VARIABLE c-lbl-inserr-a-natureza-de-operaoo-noo-es-2 AS CHARACTER NO-UNDO.
                        ASSIGN c-lbl-inserr-a-natureza-de-operaoo-noo-es-2 = c-lbl-liter-a-natureza-de-operaoo-noo-est-2 + '.'.
                        {method/svc/errors/inserr.i &ErrorNumber       = 17006
                                                    &ErrorType       = "EMS"
                                                    &ErrorSubType    = "ERROR"
                                                    &ErrorParameters = 'c-lbl-inserr-a-natureza-de-operaoo-noo-es-2'}
                        END. 
                END.
             END.
            &endif
        END.
            
        /* --> Valida natureza de opera‡Æo complementar informada... */
        IF  RowObject.nat-comp <> "" AND RowObject.nat-comp <> ? THEN
            RUN pi-validateNatOperCompl.
        /* --> */

        IF i-pais-impto-usuario = 4 THEN DO:                                          

            IF SUBSTRING(RowObject.char-2,167,5) <> "" THEN DO:

                RUN local/mex/bomx202029.p PERSISTENT SET h-bomx202029.

                RUN setConstraintByCodigo IN h-bomx202029 (INPUT SUBSTRING(RowObject.char-2,167,5),
                                                           INPUT SUBSTRING(RowObject.char-2,167,5)).
    
                RUN openQueryStatic IN h-bomx202029 (INPUT "ByCodigo":U).

                RUN goToKey IN h-bomx202029 (INPUT SUBSTRING(RowObject.char-2,167,5)).

                IF RETURN-VALUE = "NOK":U THEN DO:
                    {utp/ut-liter.i "Uso_CFDI" *}               
                    {method/svc/errors/inserr.i &ErrorNumber     = 49653
                                                &ErrorType       = "EMS"
                                                &ErrorSubType    = "ERROR"
                                                &ErrorParameters = trim(return-value)}
                END.

                RUN destroy IN h-bomx202029.
            END.            
        END.
    
    END.
    delete procedure h-boin245val.

    /*--- Verifica ocorrˆncia de erros ---*/
    IF  CAN-FIND(FIRST RowErrors WHERE RowErrors.ErrorSubType = "ERROR":U) THEN
        RETURN "NOK":U.
                  
    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validNaturOperCalculatePRFV DBOProgram 
PROCEDURE validNaturOperCalculatePRFV :
/*------------------------------------------------------------------------------
  Purpose:     m‚todo utilizado para validar notas fiscais usadas pelo calculo 
               do PRFV - CRM280 
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
    DEFINE INPUT PARAM natur-oper AS CHARACTER NO-UNDO.
    DEFINE OUTPUT PARAM pl-natur-oper AS LOGICAL NO-UNDO.

    IF CAN-FIND(FIRST natur-oper WHERE natur-oper.nat-operacao = natur-oper
                                  AND  natur-oper.emite-duplic = TRUE
                                  AND (natur-oper.tipo = 1 OR natur-oper.tipo = 2) ) THEN
        ASSIGN pl-natur-oper = TRUE.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE VerificaCodModeloNFe DBOProgram 
PROCEDURE VerificaCodModeloNFe :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  <none>
  Notes:       
------------------------------------------------------------------------------*/
DEFINE OUTPUT PARAM l-modeloNFe AS LOGICAL NO-UNDO.

   /*--- Nota Fiscal Eletronica ---*/
    IF RowObject.cod-model-nf-eletro  = "55" OR
       RowObject.cod-model-nf-eletro  = "57" OR
       RowObject.cod-model-nf-eletro  = "65" OR 
       RowObject.cod-model-nf-eletro  = "66" OR 
       RowObject.cod-model-nf-eletro  = "67" THEN
        ASSIGN l-modeloNFe = YES.
    ELSE 
        ASSIGN l-modeloNFe = NO.

    RETURN "OK":U.
END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

&ANALYZE-SUSPEND _UIB-CODE-BLOCK _PROCEDURE validateNatOper DBOProgram 
PROCEDURE validateNatOper :
/*------------------------------------------------------------------------------
  Purpose:     
  Parameters:  
  Notes: UTILIZADA PARA VALIDACAO DE CLIENTES INTEGRADOS COM O CRM DATASUL      
------------------------------------------------------------------------------*/

    DEFINE INPUT  PARAMETER iCodEmit  AS INTEGER     NO-UNDO.
    DEFINE INPUT  PARAMETER cNatOper  AS CHARACTER   NO-UNDO.
    DEFINE INPUT  PARAMETER cNatOpInt AS CHARACTER   NO-UNDO.
    DEFINE OUTPUT PARAMETER isOk      AS LOGICAL INITIAL TRUE  NO-UNDO.

    //validar somente se Brasil
    IF i-pais-impto-usuario NE 1 THEN
        RETURN.

    FOR  FIRST emitente NO-LOCK 
         WHERE emitente.cod-emitente EQ iCodEmit:

        // estrangeiro n validar
        IF emitente.natureza EQ 4 THEN
            RETURN.

        IF LENGTH(cNatOper) > 0 THEN DO:
            FOR  FIRST natur-oper  NO-LOCK 
                 WHERE natur-oper.nat-operacao = cNatOper /* emitente.nat-operacao*/ :

                // nao validar natureza de servico (1 entrada, 2 saida, 3 servico) e que nao possua CFOP informado
                IF NOT (natur-oper.tipo = 3 AND LENGTH(TRIM(natur-oper.cod-cfop)) = 0) THEN DO:

                    IF NOT CAN-DO('1,5', SUBSTR(natur-oper.cod-cfop,1,1)) THEN
                       ASSIGN isOk = FALSE. //Error: 57889           

                END.

            END.            
        END.

        IF LENGTH(cNatOpInt) > 0 THEN DO:
            FOR  FIRST natur-oper  NO-LOCK 
                 WHERE natur-oper.nat-operacao = cNatOpInt /*emitente.nat-ope-ext*/ :

                // nao validar natureza de servico (1 entrada, 2 saida, 3 servico) e que nao possua CFOP informado
                IF NOT (natur-oper.tipo = 3 AND LENGTH(TRIM(natur-oper.cod-cfop)) = 0) THEN DO:

                    IF NOT CAN-DO('2,6', SUBSTR(natur-oper.cod-cfop,1,1)) THEN
                      ASSIGN isOk = FALSE. //Error: 57889          

                END.

            END.            
        END.

    END.

    RETURN "OK":U.

END PROCEDURE.

/* _UIB-CODE-BLOCK-END */
&ANALYZE-RESUME

